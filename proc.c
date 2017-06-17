#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "uproc.h"

struct StateLists { // Added for Project 3: New Lists
  struct proc* ready[MAX + 1];
  struct proc* free;
  struct proc* sleep;
  struct proc* zombie;
  struct proc* running;
  struct proc* embryo;
};

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct StateLists pLists; // Added for Project 3: New Lists
  uint PromoteAtTime; // Added for Project 4: Periodic Priority Adjustment
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  // START: Added for Project 3: List Management
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
  // get an unused proc
  p = getFromStateListHead(&ptable.pLists.free, UNUSED);
  
  // if we successfully got a proc then proceed, otherwise return
  if (p != 0)
    goto found; // using goto similar to the original code (I think this is allowed?)   

  release(&ptable.lock);
  // END: Added for Project 3: List Management
  #else
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  #endif

  return 0;

found:
  p->state = EMBRYO;
  #ifdef CS333_P3P4
  // add new proc to embryo list
  addToStateListHead(&ptable.pLists.embryo, EMBRYO, p); // Added for Project 3: List Management
  #endif  

  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    // START: Added for Project 3: List Management
    #ifdef CS333_P3P4
    acquire(&ptable.lock);

    // if there was an error allocating space then put the proc back on the free list
    removeFromStateList(&ptable.pLists.embryo, EMBRYO, p);
    p->state = UNUSED;
    addToStateListHead(&ptable.pLists.free, UNUSED, p);

    release(&ptable.lock);
    // END: Added for Project 3: List Management
    #else
    p->state = UNUSED;
    #endif

    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  p->start_ticks = ticks; // Init value.  Added for Project 1: CTL-P
  p->cpu_ticks_total = 0; // Init value. Added for Project 2: Process Execution Time
  p->cpu_ticks_in = 0;    // Init value. Added for Project 2: Process Execution Time
  p->priority = 0; 	  // Init to highest priority. Added for Project 4: Periodic Priority Adjustment
  p->budget = DEFAULT_BUDGET; // Init to default budget. Added for Project 4: Periodic Priority Adjustment

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  // START: Added for Project 3: Initializing the Lists
  #ifdef CS333_P3P4
  acquire(&ptable.lock);

  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; // init PromoteAtTime to first threshold. Added for Project 4: Periodic Priority Adjustment 

  // Init all proc lists to ensure starting state
  for (int i = 0; i < MAX + 1; ++i) // Added for Project 4: Periodic Priority Adjustment
    ptable.pLists.ready[i] = 0;
  ptable.pLists.free = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.running = 0;
  ptable.pLists.embryo = 0;

  // add ptable procs to free list (added in backwards so our ctrl-p/ps print in the same order as before)
  for (int i = NPROC - 1; i >= 0; --i)
    addToStateListHead(&ptable.pLists.free, UNUSED, &ptable.proc[i]);
    
  release(&ptable.lock);
  #endif
  // END: Added for Project 3: Initializing the Lists
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  p->uid = DEFAULT_UID; // Added for Project 2: UIDs and GIDs and PPIDs
  p->gid = DEFAULT_GID; // Added for Project 2: UIDs and GIDs and PPIDs


  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // START: Added for Project 3: Initializing the Lists
  #ifdef CS333_P3P4
  acquire(&ptable.lock);

  // remove p proc from embryo and add to ready
  removeFromStateList(&ptable.pLists.embryo, EMBRYO, p);
  p->state = RUNNABLE;
  addToStateListHead(&ptable.pLists.ready[0], RUNNABLE, p); // added to head of ready since nothing else is there. Modified for Project 4: Periodic Priority Adjustment

  release(&ptable.lock);
  #else
  p->state = RUNNABLE;
  #endif
  // END: Added for Project 3: Initializing the Lists
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    
    // START: Added for Project 3: List Management
    #ifdef CS333_P3P4
    acquire(&ptable.lock);

    // if copyuvm failed then put np back in the free list from embryo
    removeFromStateList(&ptable.pLists.embryo, EMBRYO, np);
    np->state = UNUSED;
    addToStateListHead(&ptable.pLists.free, UNUSED, np);

    release(&ptable.lock);
    #else
    np->state = UNUSED;
    #endif
    // END: Added for Project 3: List Management
    
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;
  np->uid = proc->uid; // Added for Project 2: UIDs and GIDs and PPIDs
  np->gid = proc->gid; // Added for Project 2: UIDs and GIDs and PPIDs

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // START: Added for Project 3: List Management
  #ifdef CS333_P3P4
  acquire(&ptable.lock);

  // move np proc from embryo to ready
  removeFromStateList(&ptable.pLists.embryo, EMBRYO, np);
  np->state = RUNNABLE;
  addToStateListTail(&ptable.pLists.ready[0], RUNNABLE, np); // Modified for Project 4: Periodic Priority Adjustment

  release(&ptable.lock);
  #else
  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);
  #endif
  // END: Added for Project 3: List Management
  
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#else
void
exit(void) // Added for Project 3: List Management
{
  struct proc *p = 0;
  int fd;
  uint isFound = 0; // can't use bool, would need to define but I will just use uint instead

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  
  // START: Added for Project 3: List Managament

  // the below code is super ugly, but I had issues using a helper function to do this work by passing proc to it... so I had to put the code here
  
  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){
    p = ptable.pLists.ready[i];
    while (p != 0 && isFound != 1){
      if (p->parent == proc)
        isFound = 1;
      else
        p = p->next;
    }
  }

  if (isFound != 1){
  // search through sleep list
    p = ptable.pLists.sleep;
    while (p != 0 && isFound != 1){
      if (p->parent == proc)
        isFound = 1;
      else
        p = p->next;
    }
  }

  if (isFound != 1){
  // search through zombie list
    p = ptable.pLists.zombie;
    while (p != 0 && isFound != 1){
      if (p->parent == proc)
        isFound = 1;
      else
        p = p->next;
    }
  }

  if (isFound != 1){
  // search through running list
    p = ptable.pLists.running;
    while (p != 0 && isFound != 1){
      if (p->parent == proc)
        isFound = 1;
      else
        p = p->next;
    }
  }

  if (isFound != 1){
  // search through embryo list
    p = ptable.pLists.embryo;
    while (p != 0 && isFound != 1){
      if (p->parent == proc)
        isFound = 1;
      else
        p = p->next;
    }
  }

   if (p != 0 && isFound == 1){
    // Pass abandoned children to init.
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  // Move process p from running list to zombie list
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
  proc->state = ZOMBIE;
  addToStateListHead(&ptable.pLists.zombie, ZOMBIE, proc);
  // END: Added for Project 3: List Management

  sched();
  panic("zombie exit");
}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void) // Added for Project 3: List Management
{
  struct proc *p = 0;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ // TODO: Switch to using lists (tried using same method as in exit but it wouldn't run usertests so I've left it like this since it works)
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);

        // START: Added for Project 3: List Management
        
        // Move proc p from zombie to free
        removeFromStateList(&ptable.pLists.zombie, ZOMBIE, p);
        p->state = UNUSED;
        addToStateListHead(&ptable.pLists.free, UNUSED, p);
        // END: Added for Project 3: List Management

        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#endif

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;

      p->cpu_ticks_in = ticks; // set tick that proc enters CPU. Added for Project 2: Process Execution Time

      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else
void
scheduler(void) // Added for Project 3: List Management
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    // START: Added for Project 4: Periodic Priority Adjustment
    if (ticks >= ptable.PromoteAtTime){ // Check if we hit PromoteAtTime threshold
      doPeriodicPromotion(); // do periodic promotion of all process on ready, sleeping, and running lists
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; // update PromoteAtTime threshold after we've done the promotions
    }
    // END: Added for Project 4: Periodic Priority Adjustment

    // START: Added for Project 3: List Management

    // get ready proc p and add it to running list (if a ready proc exists)
    for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment

      p = getFromStateListHead(&ptable.pLists.ready[i], RUNNABLE); // get a proc from certain priority list (null if empty)    
      if (p != 0){ // if a proc is found then put on running list

        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
        idle = 0;  // not idle this timeslice
        proc = p;
        switchuvm(p);
      
        // switch proc p from ready to running list
        p->state = RUNNING;
        addToStateListHead(&ptable.pLists.running, RUNNING, p);
        // END: Added for Project 3: List Management

        p->cpu_ticks_in = ticks; // set tick that proc enters CPU. Added for Project 2: Process Execution Time

        swtch(&cpu->scheduler, proc->context);
        switchkvm();

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0;
        
        break; // break out of for loop now that we've found a proc. Added for Project 4: Periodic Priority Adjustment
      }
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;

  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // add time delta to total CPU time. Added for Project 2: Process Execution Time

  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#else
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;

  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // add time delta to total CPU time. Added for Project 2: Process Execution Time
  
  // START: Added for Project 4: Periodic Priority Adjustment
  proc->budget -= ticks - proc->cpu_ticks_in; // Reduce used CPU budget

  // if budget is expended (and the proc is not at the lowest priority) then demote and reset budget
  if (proc->budget <= 0 && proc->priority != MAX){
 
    // if proc is in a ready list then we need to switch its list to the lower priority one
    if (proc->state == RUNNABLE){
      removeFromStateList(&ptable.pLists.ready[proc->priority], RUNNABLE, proc);
      addToStateListTail(&ptable.pLists.ready[proc->priority + 1], RUNNABLE, proc);
    }
    
    proc->priority++;
    proc->budget = DEFAULT_BUDGET;
  }
  // END: Added for Project 4: Periodic Priority Adjustment
  
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock

  // START: Added for Project 3: List Management
  #ifdef CS333_P3P4
  // move proc from running to ready 
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
  proc->state = RUNNABLE;
  addToStateListTail(&ptable.pLists.ready[0], RUNNABLE, proc); // Modified for Project 4: Periodic Priority Adjustment
  #else
  proc->state = RUNNABLE;
  #endif

  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  // Go to sleep.
  proc->chan = chan;

  // START: Added for Project 3: List Management
  #ifdef CS333_P3P4
  // move proc from running to sleep list
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
  proc->state = SLEEPING;
  addToStateListHead(&ptable.pLists.sleep, SLEEPING, proc);
  #else
  proc->state = SLEEPING;
  #endif
  sched(); // TODO: sched???
  // END: Added for Project 3: List Management

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

//PAGEBREAK!
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan) // Added for Project 3: List Management
{
  struct proc *p = ptable.pLists.sleep;

  // go through sleep list to find process with correct chan
  while(p != 0) {
    if(p->state == SLEEPING && p->chan == chan) {
      // START: Added for Project 3: List Management
      // move proc p from sleep to ready list
      removeFromStateList(&ptable.pLists.sleep, SLEEPING, p);
      p->state = RUNNABLE;
      addToStateListTail(&ptable.pLists.ready[p->priority], RUNNABLE, p); // Modified for Project 4: Periodic Priority Adjustment
      // END: Added for Project 3: List Management
    }

    p = p->next;
  }
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid) // Added for Project 3: List Management
{
  struct proc *p;
  acquire(&ptable.lock);
  // find proc that has the specified pid from all lists except free list (as mentioned in mail list)
  p = findMatchingProcPID(pid); // Added for Project 3: List Management
  if (p != 0){			// Added for Project 3: List Management
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING) {
        // START: Added for Project 3: List Management
        // move proc p from sleeping to ready
        removeFromStateList(&ptable.pLists.sleep, SLEEPING, p);
        p->state = RUNNABLE;
        addToStateListTail(&ptable.pLists.ready[p->priority], RUNNABLE, p); // Modified for Project 4: Periodic Priority Adjustment
        // END: Added for Project 3: List Management
      }

      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
};

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  uint ppid;
 
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    // START: Added for Project 1: CTL-P (modified for Project 2: Modifying the Console)
    // Print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size (with needed spacing)
    // Switched to tabs and mod in Project 2: Modifying the Console)
    // (I wish I used this method from the start.... :(  )
    
    // get ppid (and if it is init then its ppid is itself (1))
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
		p->pid,
		p->name,
		p->uid,
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
		p->cpu_ticks_total / 100,
		p->cpu_ticks_total % 100 / 10,
		state,
		p->sz);

    // END: Added for Project 1: CTL-P

    // Print PCs data
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// START: Added for Project 3: New Console Control Sequences
void
readydump(void) // Modified for Project 4: ctrl-r Console Command
{
  acquire(&ptable.lock);

  struct proc *currPtr = 0;

  cprintf("Ready List Processes:\n"); 

  for(int i = 0; i < MAX + 1; ++i){
    currPtr = ptable.pLists.ready[i];
    cprintf("%d: ", i); // print list number
    
    if (currPtr == 0)
      cprintf("Empty!\n");

    while (currPtr != 0){
      if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
        cprintf("(%d, %d)\n", currPtr->pid, currPtr->budget);
      else
        cprintf("(%d, %d) -> ", currPtr->pid, currPtr->budget);

      currPtr = currPtr->next;
    }
  }

  release(&ptable.lock);
}

void
freedump(void)
{
  acquire(&ptable.lock);
  
  struct proc *currPtr = ptable.pLists.free;
  uint numProcs = 0;

  while (currPtr != 0){
    ++numProcs;
    currPtr = currPtr->next;
  }

  cprintf("Free List Size: %d processes\n", numProcs);

  release(&ptable.lock);
}

void
sleepdump(void)
{
  acquire(&ptable.lock);

  struct proc *currPtr = ptable.pLists.sleep;

  cprintf("Sleep List Processes:\n"); 
  
  if (currPtr == 0)
    cprintf("Empty!\n");

  while (currPtr != 0){
    if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
      cprintf("%d\n", currPtr->pid);
    else
      cprintf("%d -> ", currPtr->pid);

    currPtr = currPtr->next;
  }

  release(&ptable.lock);
}

void
zombiedump(void)
{
  acquire(&ptable.lock);

  struct proc *currPtr = ptable.pLists.zombie;

  cprintf("Zombie List Processes:\n"); 

  if (currPtr == 0)
    cprintf("Empty!\n");

  while (currPtr != 0){
    if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
        cprintf("(%d, %d)\n", currPtr->pid, currPtr->parent->pid);
    else
      cprintf("(%d, %d) -> ", currPtr->pid, currPtr->parent->pid);
    
    currPtr = currPtr->next;
  }

  release(&ptable.lock);
}
// END: Added for Project 3: New Console Control Sequences

// get array of uproc structs
int
getuprocs(uint max, struct uproc *table) // Added for Project 2: The "ps" Command
{
  struct proc *p;
  uint numProcs = 0; // number of procs in struct array

  acquire(&ptable.lock); // get lock so we get a snapshot

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
        p->state == SLEEPING || 
        p->state == RUNNING  || 
        p->state == ZOMBIE)
    {

      // populate uproc struct entry in table
      table->pid  = p->pid;
      table->uid  = p->uid;
      table->gid  = p->gid;

      if (p->pid == 1) // if p is init, then set ppid to itself (1)
        table->ppid = 1;
      else
        table->ppid = p->parent->pid;

      table->priority = p->priority;
      table->elapsed_ticks = ticks - p->start_ticks;
      table->CPU_total_ticks = p->cpu_ticks_total;
      safestrcpy(table->state, states[p->state], NELEM(table->state));
      table->size = p->sz;
      safestrcpy(table->name, p->name, NELEM(table->name));

      ++table; // go to next entry
      ++numProcs; // inc number of procs in struct array
    }
  }

  release(&ptable.lock); // return lock

  return numProcs;
}

// Removes a proc "p" from a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
removeFromStateList(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
   
  // check if passed in proc is in the specified state
  if (p->state != state) {
    panic("The passed in proc to remove had the wrong state.");
  }

  // search through list to find proc to remove
  while((*sList) != 0) {
  
    // if matching proc is found then remove it and return
    if ((*sList) == p) {
      (*sList) = p->next; // remove proc by "skipping" over it     
      return;
    }

    // else, keep searching 
    sList = &(*sList)->next;
  }

  cprintf("removeFromStateList: p->priority is %d p->pid is %d p->ppid is %d\n", p->priority, p->pid, p->parent->pid);
  // if it wasn't found then panic and return error
  panic("The passed in proc to remove was not found.");
  
}

// Gets a head proc from a list (which removes it from that list)
// This is O(1) and is used to get procs from lists which are equivalent (e.g. free)
// If there the specified list is empty then panic
// Also, if the proc that is gotten has the wrong state then panic
struct proc*
getFromStateListHead(struct proc **sList, enum procstate state) // Added for Project 3: List Management
{
  struct proc* head = (*sList);

  // if head exists then return gotten head proc (if correct state) and remove from sList
  if (head != 0) {
    if (head->state != state)
      panic("The gotten head proc had the wrong state.");
    else {
      (*sList) = (*sList)->next; // remove gotten head proc by skipping over it
      return head;
    }
    
  }

  return 0; // if head doesn't exist then null is returned
}

// Adds a proc "p" to the head of a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
addToStateListHead(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
  // check if proc that is being added is correct state
  if (p->state != state) {
    panic("The passed in proc to add to head had the wrong state.");
  }

  // add proc to head
  p->next = (*sList); // note that if the sList is empty then the next will be set to null (as expected)
  (*sList) = p;

}

// Adds a proc "p" to the tail of a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
addToStateListTail(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
  // check if proc that is being added is correct state
  if (p->state != state) {
    panic("The passed in proc to add to tail had the wrong state.");
  }
  
  // if list being added to is empty, then just add to head
  if ((*sList) == 0) {
    (*sList) = p;
    p->next = 0; 

  // otherwise, find the tail and add proc
  } else {
    while ((*sList) != 0) {
      
      // if tail is found then add proc and return
      if ((*sList)->next == 0) {
        (*sList)->next = p;
        p->next = 0;
        return;
      }

      // otherwise, keep looping
      sList = &(*sList)->next; 
    }
  }

}

// Tacks a proc p (and all of its "next" children) onto the tail of sList. 
// This function is only used when moving a list of procs between ready list priority queues.
// Also, the procs moved will have their priority decremented and their budget reset
void
tackToStateListTail(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 4: Periodic Priority Adjustment (helper)
{
  struct proc *currPtr = 0;

  // if p is null, then just return
  if (p == 0)
    return;
  
  // check if proc that is being moved is correct state
  if (p->state != state)
    panic("The passed in proc to tack to tail had the wrong state.");

  // if list being tacked to is empty, then just add to head
  if ((*sList) == 0){
    (*sList) = p; // note that p's tail is not set to null since it is assumed its tail and its "next" children are set accordingly

    
    currPtr = p;
    while(currPtr != 0){
      currPtr->priority--;
      currPtr->budget = DEFAULT_BUDGET;

      currPtr = currPtr->next;
    }

  // otherwise, find the tail and tack on p
  } else {
    while ((*sList) != 0) {
      
      // if tail is found then tack on p and return
      if ((*sList)->next == 0){
        (*sList)->next = p; // note that next is not set to null since it is assumed its tail and its "next" children are set accordingly
         
        currPtr = p;
        while(currPtr != 0){
          currPtr->priority--;
          currPtr->budget = DEFAULT_BUDGET;

          currPtr = currPtr->next;
        }
        
        return;
      }
      
      // otherwise, keep looping
      sList = &(*sList)->next;
    }
  }
}

// find a proc whose PID is equal to the specified PID
// this function searches through all lists except the free list (as mentioned in the mailing list)
struct proc*
findMatchingProcPID(uint pid)
{
  struct proc *currPtr = 0; 

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
    currPtr = ptable.pLists.ready[i];
    while(currPtr != 0) {
      if (currPtr->pid == pid) // check if we found the proc
        return currPtr;

      currPtr = currPtr->next;
    }
  }

  // search through sleep list
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0) {
    if (currPtr->pid == pid) // check if we found the proc
      return currPtr;

    currPtr = currPtr->next;
  }

  // search through zombie list
  currPtr = ptable.pLists.zombie;
  while(currPtr != 0) {
    if (currPtr->pid == pid) // check if we found the proc
      return currPtr;

    currPtr = currPtr->next;
  }

  // search through running list
  currPtr = ptable.pLists.running;
  while(currPtr != 0) {
    if (currPtr->pid == pid) // check if we found the proc
      return currPtr;

    currPtr = currPtr->next;
  }

  // search through embryo list
  currPtr = ptable.pLists.embryo;
  while(currPtr != 0) {
    if (currPtr->pid == pid) // check if we found the proc
      return currPtr;

    currPtr = currPtr->next;
  }

  // if it isn't found then return null
  return 0;
}

// sets process with pid to the specified priority. Also, this resets the budget of this process.
// only checks the RUNNING, SLEEPING, and RUNNABLE process (as mentioned in mailing list)
// returns 0 on success and -1 on error (e.g. didn't find process, or invalid params)
int
setpriority(int pid, int priority) // Added for Project 4: The setpriority() System Call
{
  struct proc *currPtr = 0; 

  // check params to ensure no invalid input
  if (pid < 0 || priority < 0 || priority > MAX)
    return -1;

  acquire(&ptable.lock);
 
  // check running list for process pid
  currPtr = ptable.pLists.running;
  while(currPtr != 0){
    if(currPtr->pid == pid){
      currPtr->priority = priority;
      currPtr->budget = DEFAULT_BUDGET;
      
      release(&ptable.lock); // since process was found, release lock and return 0 (success)
      return 0;
    }

    currPtr = currPtr->next;
  }

  // check sleep list for process pid
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0){

    if(currPtr->pid == pid){
      currPtr->priority = priority;
      currPtr->budget = DEFAULT_BUDGET;
      
      release(&ptable.lock); // since process was found, release lock and return 0 (success)
      return 0;
    }

    currPtr = currPtr->next;
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){

    currPtr = ptable.pLists.ready[i];
    while(currPtr != 0){

      if(currPtr->pid == pid){
        currPtr->priority = priority;
        currPtr->budget = DEFAULT_BUDGET;
      
        release(&ptable.lock); // since process was found, release lock and return 0 (success)
        return 0;
      }

      currPtr = currPtr->next;
    }
  }

  // if nothing was found, release lock and return -1 (error)
  release(&ptable.lock);
  return -1;
}

// promote all processes within ready, sleeping, and running lists by 1 priority level (this is called from scheduler when we hit ticks threshold) 
void
doPeriodicPromotion(void) // Added for Project 4: Periodic Priority Adjustment
{
  struct proc *currPtr = 0;
  
  // reduce priority of procs in running list (if they aren't at 0)
  currPtr = ptable.pLists.running;
  while (currPtr != 0){
    currPtr->budget = DEFAULT_BUDGET;

    if (currPtr->priority > 0){
      currPtr->priority--;
    }
      
    currPtr = currPtr->next;
  }

  // reduce priority of procs in sleep list (if they aren't at 0), also reset budgets
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0){
    currPtr->budget = DEFAULT_BUDGET;
    
    if (currPtr->priority > 0)
      currPtr->priority--;

    currPtr = currPtr->next;
  }

  // reset budgets of procs already in ready[0] to prevent un-needed budget-resets in the below for/while loop
  currPtr = ptable.pLists.ready[0];
  while (currPtr != 0){
    currPtr->budget = DEFAULT_BUDGET;
    currPtr = currPtr->next;
  }
  
  // move procs in priorities 1 through MAX + 1 up one level (and reset their budgets)
  for(int i = 1; i < MAX + 1; ++i)
    tackToStateListTail(&ptable.pLists.ready[i - 1], RUNNABLE, ptable.pLists.ready[i]);

}

