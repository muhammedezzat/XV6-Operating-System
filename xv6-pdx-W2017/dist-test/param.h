#define NPROC        64  // maximum number of processes
#define KSTACKSIZE 4096  // size of per-process kernel stack
#define NCPU          8  // maximum number of CPUs
#define NOFILE       16  // open files per process
#define NFILE       100  // open files per system
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         10  // maximum major device number
#define ROOTDEV       1  // device number of file system root disk
#define MAXARG       32  // max exec arguments
#define MAXOPBLOCKS  10  // max # of blocks any FS op writes
#define LOGSIZE      (MAXOPBLOCKS*3)  // max data blocks in on-disk log
#define NBUF         (MAXOPBLOCKS*3)  // size of disk block cache
// #define FSSIZE       1000  // size of file system in blocks
#define FSSIZE       2000  // size of file system in blocks  // CS333 requires a larger FS.
#define DEFAULT_UID  0 // default UID (for init) Added for Project 2: UIDs and GIDs and PPIDs
#define DEFAULT_GID  0 // default GID (for init) Added for Project 2: UIDs and GIDs and PPIDs
#define MAX	     0 // Added for Project 4: Process Priority
#define TICKS_TO_PROMOTE 1000 // Added for Project 4: Periodic Priority Adjustment
#define DEFAULT_BUDGET 300 // Added for Project 4: Periodic Priority Adjustment
