#include "types.h"
#include "user.h"

#ifdef CS333_P5
int
main(int argc, char *argv[]) // Added for Project 5: New Commands
{
  char *pathname = 0;
  int mode = 0;

  // error check for invalid parameters
  if ((argc != 3) || // check number of params
      (argv[1][0] == '-') || // check if mode is negative 
      (strlen(argv[1]) != 4) || // check if mode is not 4 digits
      (argv[1][0] < '0' || argv[1][0] > '1') || // check setuid bit
      (argv[1][1] < '0' || argv[1][1] > '7') || // check user bits
      (argv[1][2] < '0' || argv[1][2] > '7') || // check group bits
      (argv[1][3] < '0' || argv[1][3] > '7')){ // check other bits

    printf(1, "Invalid parameters.\n");

  // everything looks good!
  } else {
    
    pathname = argv[2];
    mode = atoo(argv[1]); // use provided octal converter
    
    if(chmod(pathname, mode) == 0)
      printf(1, "chmod was successful!\n");
    else
      printf(1, "chmod was unsuccessful...\n");
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
