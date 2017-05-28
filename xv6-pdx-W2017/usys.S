#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(halt)
SYSCALL(date) // Added for Project 1: The date() System Call
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
