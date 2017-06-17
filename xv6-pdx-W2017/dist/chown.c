#include "types.h"
#include "user.h"

#ifdef CS333_P5
int
main(int argc, char *argv[]) // Added for Project 5: New Commands
{
  char *pathname = 0;
  int uid = 0;

  // error check for invalid parameters
  if ((argc != 3) || // check number of params
      (argv[1][0] == '-')){ // check if uid is negative 
 
    printf(1, "Invalid parameters.\n");  

  // everything looks good! 
  } else{
    
    pathname = argv[2];
    uid = atoi(argv[1]);

    if (chown(pathname, uid) == 0)
      printf(1, "chown was successful!\n");
    else
      printf(1, "chown was unsuccessful...\n");
  }

  exit();
}
#else
int
main(int argc, char *argv[])
{
  printf(1, "The CS333_P5 compilation flag is not enabled.\n");
  exit();
}
#endif
