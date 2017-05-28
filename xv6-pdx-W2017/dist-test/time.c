#include "types.h"
#include "user.h"

// User "time" command which returns the amount of time it takes to run
// a console command (which is its input). Note that the input could be
// a nested time command.
// Added for Project 2: The "time" Command
int
time(char *argv[])
{ 
  uint ticks_total = 0;
  uint ticks_in = 0;

  // get pid of parent
  uint pid = getpid();

  // fork before tracking time so we don't include the overhead of fork
  fork();

  // get starting ticks (adds a tiny bit of overhead to calculation)
  ticks_in = uptime();

  // if current proc is parent, then wait for child and track the time delta
  if (pid == getpid())
  {
    wait();
    
    // calculate time delta
    ticks_total += uptime() - ticks_in;
    
    // print result
    printf(1, "%s ran in %d.%d%d seconds.\n",
              argv[0],
              ticks_total / 100,
              ticks_total % 100 / 10,
              ticks_total % 100 % 10);
    
  }
 
  // if current proc is not parent, then exec
  if (pid != getpid())
  {
    exec(argv[0], &argv[0]);
    
    // if the executed command is not valid, print an error
    printf(1, "Not a valid command. \n");
  }

  return 0;
} 

int
main(int argc, char *argv[])
{

  // if there is an arg then keep track of the time,
  // otherwise no program, so 0.00 secs is printed
  if (argv[1] != 0)
    time(&argv[1]);
  else
    printf(1, "ran in 0.00 seconds.\n");
  exit();
}
