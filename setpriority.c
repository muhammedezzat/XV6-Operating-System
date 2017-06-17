#include "types.h"
#include "user.h"

// Added for Project 4: The setpriority() System Call

// used for testing our setpriority() system call
// and verifying that our periodic adjustment is working correctly
int
main(int argc, char *argv[])
{
  int rc = 0;
  int pid = 0;
  int priority = 0;

  if (argv[1] == 0 || argv[2] == 0)
    printf(1, "Invalid params. (pid priority)\n");

  pid = atoi(argv[1]);
  priority = atoi(argv[2]);

  rc = setpriority(pid, priority);
  if (rc == 0)
    printf(1, "Successfully set priority!\n");
  else
    printf(1, "Failed to set priority!\n");

  exit();
}
