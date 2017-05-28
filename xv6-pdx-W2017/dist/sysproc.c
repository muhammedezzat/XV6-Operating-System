#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
}

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
  uint xticks;
  
  xticks = ticks;
  return xticks;
}

//Turn of the computer
int sys_halt(void){
  cprintf("Shutting down ...\n");
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
  return 0;
}

// returns the rtcdate
int
sys_date(void) // Added for Project 1: The date() System Call
{
  struct rtcdate *d;

  if(argptr(0, (void*)&d, sizeof(*d)) < 0)
    return -1;

  cmostime(d);
  return 0;
}

// START: Added for Project 2: UIDs and GIDs and PPIDs
// get uid of current process
int
sys_getuid(void)
{
  return proc->uid;
}

// get gid of current process
int
sys_getgid(void)
{
  return proc->gid;
}

// get pid of parent process (init is its own parent)
int
sys_getppid(void)
{
  if (proc->pid == 1)
    return 1;
  else
    return proc->parent->pid;
}

// set uid
int
sys_setuid(void)
{
  int uid;

  if (argint(0, &uid) < 0)
    return -1;
  
  if (0 <= uid && uid <= 32767){
    proc->uid = uid;
    return 0;
  }
  else
    return -1;

}

// set gid
int
sys_setgid(void)
{
  int gid;

  if (argint(0, &gid) < 0)
    return -1;

  if (0 <= gid && gid <= 32767){
    proc->gid = gid;
    return 0;
  }
  else
    return -1;
}
// END: Added for Project 2: UIDs and GIDs and PPIDs

// get list of procs (for ps display)
int
sys_getprocs(void) // Added for Project 2: The "ps" Command
{
  int max;
  struct uproc *table;

  if (argint(0, &max) < 0)
    return -1;

  if (argptr(1, (void*)&table, sizeof(*table)) < 0)
    return -1;

  return getuprocs(max, table); // get uproc struct array from proc.c
}

// sets proc with PID of pid to priority and resets budget
// returns 0 on success and -1 on error
int
sys_setpriority(void) // Added for Project 4: The setpriority() System Call
{
  int pid;
  int priority;

  // get pid/ priority parameters off stack (return -1 on error)
  if(argint(0, &pid) < 0)
    return -1;
  if(argint(1, &priority) < 0)
    return -1;

  // check if parameters have valid values (return -1 on error)
  if (pid < 0 || priority < 0 || priority > MAX)
    return -1;

  // call setpriority (and return its return code)
  return setpriority(pid, priority);
}
