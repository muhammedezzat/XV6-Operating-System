// for testing getters (getuid, getgid, getppid) and setters (setuid, setgid) that were added in Project 2: UIDs and GIDs and PPIDs
// uses some code that Mark Morrissey provided
#include "types.h"
#include "user.h"

static void
uidTest(uint nval)
{
  uint uid = getuid();

  printf(1, "Current UID is: %d\n", uid);
  printf(1, "Setting UID to %d\n", nval);
  if (setuid(nval) < 0)
    printf(2, "Error. Invalid UID: %d\n", nval);

  uid = getuid();
  printf(1, "Current UID is: %d\n", uid);

  printf(1, "Sleeping...\n");
  sleep(500); // now type control-p
}

static void
gidTest(uint nval)
{
  uint gid = getgid();

  printf(1, "Current GID is: %d\n", gid);
  printf(1, "Setting GID to %d\n", nval);
  if (setgid(nval) < 0)
    printf(2, "Error. Invalid GID: %d\n", nval);

  gid = getgid();
  printf(1, "Current GID is: %d\n", gid);

  printf(1, "Sleeping...\n");
  sleep(500); // now type control-p
}

static void
forkTest(uint nval)
{
  uint uid, gid;
  int pid;

  printf(1, "Setting UID to %d and GID to %d before fork(). Value"
  	          " should be inherited\n", nval, nval);

  if (setuid(nval) < 0)
    printf(2, "Error. Invalid UID: %d\n", nval);
  if (setgid(nval) < 0)
    printf(2, "Error. Invalid GID: %d\n", nval);

  printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getgid());

  pid = fork();
  if (pid == 0) { // child
    uid = getuid();
    gid = getgid();
    printf(1, "Child: UID is: %d, GID = %d\n", uid, gid);

    printf(1, "Sleeping...\n");
    sleep(500); // now type control-p

    exit();
  }
  else
    sleep(1000); // wait for child to exit before proceeding

}

static void
invalidTest(uint nval)
{
  printf(1, "Setting UID to %d. This test should FAIL\n", nval);
  if (setuid(nval) < 0)
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");

  printf(1, "Setting GID to %d. This test should FAIL\n", nval);
  if (setgid(nval) < 0)
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
  else
    printf(2, "FAILURE! The setgid system call indicates success\n");

  printf(1, "Setting UID to %d. This test should FAIL\n", -1);
  if (setuid(-1) < 0)
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
  else
    printf(2, "FAILURE! The setuid system call indicated success\n");

  printf(1, "Setting GID to %d. This test should FAIL\n", -1);
  if (setgid(-1) < 0)
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
  else
    printf(2, "FAILURE! The setgid system call indicated success\n");
}

static int
testuidgid(void)
{
  uint nval;
  int ppid;

  // get/set uid test (valid value)
  nval = 100;
  uidTest(nval);

  // get/set gid test (valid value)
  nval = 200;
  gidTest(nval);

  // get ppid test
  ppid = getppid();
  printf(1, "My parent process is: %d\n", ppid);

  // fork tests to demonstrate UID/GID inheritance
  nval = 111;
  forkTest(nval);

  // tests for invalid values for uid and gid setters
  nval = 32800;
  invalidTest(nval);

  printf(1, "Done!\n");
  return 0;
}

int
main() 
{
  testuidgid();
  exit();
}
