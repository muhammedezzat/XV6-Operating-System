#include "types.h"
#include "user.h"
#include "uproc.h"

// The "ps" user command which displays process information similar to the "CTL-P" result without the PCs column.
// Added for Project 2: The "ps" Command
int
main(int argc, char *argv[])
{
  uint max = 16; // max procs that will be displayed
  struct uproc *table = malloc(max * sizeof(struct uproc));
  int entries = 0; // actual entries in the table

  // get procs
  entries = getprocs(max, table);
  if (entries <= 0)
    printf(1, "No entries. Error.");
  else
  {
    // print table header
    printf(1, "\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n"); // Modified for Project 4: ps Command

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
		table[i].pid,
		table[i].name,
		table[i].uid,
		table[i].gid,
		table[i].ppid,
		table[i].priority, // Added for Project 4: ps Command
		table[i].elapsed_ticks / 100,
		table[i].elapsed_ticks % 100 / 10,
		table[i].elapsed_ticks % 100 % 10,
		table[i].CPU_total_ticks / 100,
		table[i].CPU_total_ticks % 100 / 10,
		table[i].state,
		table[i].size);
    }
  }
  
  exit();
}


