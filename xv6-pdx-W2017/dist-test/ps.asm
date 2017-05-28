
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

// The "ps" user command which displays process information similar to the "CTL-P" result without the PCs column.
// Added for Project 2: The "ps" Command
int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 38             	sub    $0x38,%esp
  uint max = 16; // max procs that will be displayed
  14:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  struct uproc *table = malloc(max * sizeof(struct uproc));
  1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1e:	89 d0                	mov    %edx,%eax
  20:	01 c0                	add    %eax,%eax
  22:	01 d0                	add    %edx,%eax
  24:	c1 e0 05             	shl    $0x5,%eax
  27:	83 ec 0c             	sub    $0xc,%esp
  2a:	50                   	push   %eax
  2b:	e8 46 09 00 00       	call   976 <malloc>
  30:	83 c4 10             	add    $0x10,%esp
  33:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int entries = 0; // actual entries in the table
  36:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // get procs
  entries = getprocs(max, table);
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	ff 75 dc             	pushl  -0x24(%ebp)
  43:	ff 75 e0             	pushl  -0x20(%ebp)
  46:	e8 71 05 00 00       	call   5bc <getprocs>
  4b:	83 c4 10             	add    $0x10,%esp
  4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (entries <= 0)
  51:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  55:	7f 17                	jg     6e <main+0x6e>
    printf(1, "No entries. Error.");
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	68 5c 0a 00 00       	push   $0xa5c
  5f:	6a 01                	push   $0x1
  61:	e8 3d 06 00 00       	call   6a3 <printf>
  66:	83 c4 10             	add    $0x10,%esp
  69:	e9 1a 02 00 00       	jmp    288 <main+0x288>
  else
  {
    // print table header
    printf(1, "\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n"); // Modified for Project 4: ps Command
  6e:	83 ec 08             	sub    $0x8,%esp
  71:	68 70 0a 00 00       	push   $0xa70
  76:	6a 01                	push   $0x1
  78:	e8 26 06 00 00       	call   6a3 <printf>
  7d:	83 c4 10             	add    $0x10,%esp

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
  80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  87:	e9 f0 01 00 00       	jmp    27c <main+0x27c>
		table[i].elapsed_ticks % 100 / 10,
		table[i].elapsed_ticks % 100 % 10,
		table[i].CPU_total_ticks / 100,
		table[i].CPU_total_ticks % 100 / 10,
		table[i].state,
		table[i].size);
  8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8f:	89 d0                	mov    %edx,%eax
  91:	01 c0                	add    %eax,%eax
  93:	01 d0                	add    %edx,%eax
  95:	c1 e0 05             	shl    $0x5,%eax
  98:	89 c2                	mov    %eax,%edx
  9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  9d:	01 d0                	add    %edx,%eax

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
  9f:	8b 40 3c             	mov    0x3c(%eax),%eax
  a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		table[i].elapsed_ticks / 100,
		table[i].elapsed_ticks % 100 / 10,
		table[i].elapsed_ticks % 100 % 10,
		table[i].CPU_total_ticks / 100,
		table[i].CPU_total_ticks % 100 / 10,
		table[i].state,
  a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  a8:	89 d0                	mov    %edx,%eax
  aa:	01 c0                	add    %eax,%eax
  ac:	01 d0                	add    %edx,%eax
  ae:	c1 e0 05             	shl    $0x5,%eax
  b1:	89 c2                	mov    %eax,%edx
  b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	8d 78 1c             	lea    0x1c(%eax),%edi
  bb:	89 7d d0             	mov    %edi,-0x30(%ebp)
		table[i].priority, // Added for Project 4: ps Command
		table[i].elapsed_ticks / 100,
		table[i].elapsed_ticks % 100 / 10,
		table[i].elapsed_ticks % 100 % 10,
		table[i].CPU_total_ticks / 100,
		table[i].CPU_total_ticks % 100 / 10,
  be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  c1:	89 d0                	mov    %edx,%eax
  c3:	01 c0                	add    %eax,%eax
  c5:	01 d0                	add    %edx,%eax
  c7:	c1 e0 05             	shl    $0x5,%eax
  ca:	89 c2                	mov    %eax,%edx
  cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  cf:	01 d0                	add    %edx,%eax
  d1:	8b 48 18             	mov    0x18(%eax),%ecx
  d4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  d9:	89 c8                	mov    %ecx,%eax
  db:	f7 e2                	mul    %edx
  dd:	89 d0                	mov    %edx,%eax
  df:	c1 e8 05             	shr    $0x5,%eax
  e2:	6b c0 64             	imul   $0x64,%eax,%eax
  e5:	29 c1                	sub    %eax,%ecx
  e7:	89 c8                	mov    %ecx,%eax

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
  e9:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  ee:	f7 e2                	mul    %edx
  f0:	c1 ea 03             	shr    $0x3,%edx
  f3:	89 55 cc             	mov    %edx,-0x34(%ebp)
		table[i].ppid,
		table[i].priority, // Added for Project 4: ps Command
		table[i].elapsed_ticks / 100,
		table[i].elapsed_ticks % 100 / 10,
		table[i].elapsed_ticks % 100 % 10,
		table[i].CPU_total_ticks / 100,
  f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f9:	89 d0                	mov    %edx,%eax
  fb:	01 c0                	add    %eax,%eax
  fd:	01 d0                	add    %edx,%eax
  ff:	c1 e0 05             	shl    $0x5,%eax
 102:	89 c2                	mov    %eax,%edx
 104:	8b 45 dc             	mov    -0x24(%ebp),%eax
 107:	01 d0                	add    %edx,%eax
 109:	8b 40 18             	mov    0x18(%eax),%eax

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
 10c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 111:	f7 e2                	mul    %edx
 113:	89 d0                	mov    %edx,%eax
 115:	c1 e8 05             	shr    $0x5,%eax
 118:	89 45 c8             	mov    %eax,-0x38(%ebp)
		table[i].gid,
		table[i].ppid,
		table[i].priority, // Added for Project 4: ps Command
		table[i].elapsed_ticks / 100,
		table[i].elapsed_ticks % 100 / 10,
		table[i].elapsed_ticks % 100 % 10,
 11b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 11e:	89 d0                	mov    %edx,%eax
 120:	01 c0                	add    %eax,%eax
 122:	01 d0                	add    %edx,%eax
 124:	c1 e0 05             	shl    $0x5,%eax
 127:	89 c2                	mov    %eax,%edx
 129:	8b 45 dc             	mov    -0x24(%ebp),%eax
 12c:	01 d0                	add    %edx,%eax
 12e:	8b 48 14             	mov    0x14(%eax),%ecx
 131:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 136:	89 c8                	mov    %ecx,%eax
 138:	f7 e2                	mul    %edx
 13a:	89 d3                	mov    %edx,%ebx
 13c:	c1 eb 05             	shr    $0x5,%ebx
 13f:	6b c3 64             	imul   $0x64,%ebx,%eax
 142:	89 cb                	mov    %ecx,%ebx
 144:	29 c3                	sub    %eax,%ebx

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
 146:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 14b:	89 d8                	mov    %ebx,%eax
 14d:	f7 e2                	mul    %edx
 14f:	89 d6                	mov    %edx,%esi
 151:	c1 ee 03             	shr    $0x3,%esi
 154:	89 f0                	mov    %esi,%eax
 156:	c1 e0 02             	shl    $0x2,%eax
 159:	01 f0                	add    %esi,%eax
 15b:	01 c0                	add    %eax,%eax
 15d:	89 de                	mov    %ebx,%esi
 15f:	29 c6                	sub    %eax,%esi
		table[i].uid,
		table[i].gid,
		table[i].ppid,
		table[i].priority, // Added for Project 4: ps Command
		table[i].elapsed_ticks / 100,
		table[i].elapsed_ticks % 100 / 10,
 161:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 164:	89 d0                	mov    %edx,%eax
 166:	01 c0                	add    %eax,%eax
 168:	01 d0                	add    %edx,%eax
 16a:	c1 e0 05             	shl    $0x5,%eax
 16d:	89 c2                	mov    %eax,%edx
 16f:	8b 45 dc             	mov    -0x24(%ebp),%eax
 172:	01 d0                	add    %edx,%eax
 174:	8b 48 14             	mov    0x14(%eax),%ecx
 177:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 17c:	89 c8                	mov    %ecx,%eax
 17e:	f7 e2                	mul    %edx
 180:	89 d0                	mov    %edx,%eax
 182:	c1 e8 05             	shr    $0x5,%eax
 185:	6b c0 64             	imul   $0x64,%eax,%eax
 188:	29 c1                	sub    %eax,%ecx
 18a:	89 c8                	mov    %ecx,%eax

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
 18c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 191:	f7 e2                	mul    %edx
 193:	89 d7                	mov    %edx,%edi
 195:	c1 ef 03             	shr    $0x3,%edi
 198:	89 7d c4             	mov    %edi,-0x3c(%ebp)
		table[i].name,
		table[i].uid,
		table[i].gid,
		table[i].ppid,
		table[i].priority, // Added for Project 4: ps Command
		table[i].elapsed_ticks / 100,
 19b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 19e:	89 d0                	mov    %edx,%eax
 1a0:	01 c0                	add    %eax,%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	c1 e0 05             	shl    $0x5,%eax
 1a7:	89 c2                	mov    %eax,%edx
 1a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1ac:	01 d0                	add    %edx,%eax
 1ae:	8b 40 14             	mov    0x14(%eax),%eax

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
 1b1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 1b6:	f7 e2                	mul    %edx
 1b8:	89 d3                	mov    %edx,%ebx
 1ba:	c1 eb 05             	shr    $0x5,%ebx
 1bd:	89 5d c0             	mov    %ebx,-0x40(%ebp)
		table[i].pid,
		table[i].name,
		table[i].uid,
		table[i].gid,
		table[i].ppid,
		table[i].priority, // Added for Project 4: ps Command
 1c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1c3:	89 d0                	mov    %edx,%eax
 1c5:	01 c0                	add    %eax,%eax
 1c7:	01 d0                	add    %edx,%eax
 1c9:	c1 e0 05             	shl    $0x5,%eax
 1cc:	89 c2                	mov    %eax,%edx
 1ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1d1:	01 d0                	add    %edx,%eax

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
 1d3:	8b 48 10             	mov    0x10(%eax),%ecx
 1d6:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		table[i].pid,
		table[i].name,
		table[i].uid,
		table[i].gid,
		table[i].ppid,
 1d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1dc:	89 d0                	mov    %edx,%eax
 1de:	01 c0                	add    %eax,%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c1 e0 05             	shl    $0x5,%eax
 1e5:	89 c2                	mov    %eax,%edx
 1e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1ea:	01 d0                	add    %edx,%eax

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
 1ec:	8b 58 0c             	mov    0xc(%eax),%ebx
 1ef:	89 5d b8             	mov    %ebx,-0x48(%ebp)
		table[i].pid,
		table[i].name,
		table[i].uid,
		table[i].gid,
 1f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1f5:	89 d0                	mov    %edx,%eax
 1f7:	01 c0                	add    %eax,%eax
 1f9:	01 d0                	add    %edx,%eax
 1fb:	c1 e0 05             	shl    $0x5,%eax
 1fe:	89 c2                	mov    %eax,%edx
 200:	8b 45 dc             	mov    -0x24(%ebp),%eax
 203:	01 d0                	add    %edx,%eax

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
 205:	8b 78 08             	mov    0x8(%eax),%edi
		table[i].pid,
		table[i].name,
		table[i].uid,
 208:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 20b:	89 d0                	mov    %edx,%eax
 20d:	01 c0                	add    %eax,%eax
 20f:	01 d0                	add    %edx,%eax
 211:	c1 e0 05             	shl    $0x5,%eax
 214:	89 c2                	mov    %eax,%edx
 216:	8b 45 dc             	mov    -0x24(%ebp),%eax
 219:	01 d0                	add    %edx,%eax

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
 21b:	8b 58 04             	mov    0x4(%eax),%ebx
		table[i].pid,
		table[i].name,
 21e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 221:	89 d0                	mov    %edx,%eax
 223:	01 c0                	add    %eax,%eax
 225:	01 d0                	add    %edx,%eax
 227:	c1 e0 05             	shl    $0x5,%eax
 22a:	89 c2                	mov    %eax,%edx
 22c:	8b 45 dc             	mov    -0x24(%ebp),%eax
 22f:	01 d0                	add    %edx,%eax
 231:	8d 48 40             	lea    0x40(%eax),%ecx
    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
		table[i].pid,
 234:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 237:	89 d0                	mov    %edx,%eax
 239:	01 c0                	add    %eax,%eax
 23b:	01 d0                	add    %edx,%eax
 23d:	c1 e0 05             	shl    $0x5,%eax
 240:	89 c2                	mov    %eax,%edx
 242:	8b 45 dc             	mov    -0x24(%ebp),%eax
 245:	01 d0                	add    %edx,%eax

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
    {
      // Print the columns (I wish I used tabs and mod from the beginning :(  )
      printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\n",
 247:	8b 00                	mov    (%eax),%eax
 249:	83 ec 04             	sub    $0x4,%esp
 24c:	ff 75 d4             	pushl  -0x2c(%ebp)
 24f:	ff 75 d0             	pushl  -0x30(%ebp)
 252:	ff 75 cc             	pushl  -0x34(%ebp)
 255:	ff 75 c8             	pushl  -0x38(%ebp)
 258:	56                   	push   %esi
 259:	ff 75 c4             	pushl  -0x3c(%ebp)
 25c:	ff 75 c0             	pushl  -0x40(%ebp)
 25f:	ff 75 bc             	pushl  -0x44(%ebp)
 262:	ff 75 b8             	pushl  -0x48(%ebp)
 265:	57                   	push   %edi
 266:	53                   	push   %ebx
 267:	51                   	push   %ecx
 268:	50                   	push   %eax
 269:	68 a4 0a 00 00       	push   $0xaa4
 26e:	6a 01                	push   $0x1
 270:	e8 2e 04 00 00       	call   6a3 <printf>
 275:	83 c4 40             	add    $0x40,%esp
  {
    // print table header
    printf(1, "\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n"); // Modified for Project 4: ps Command

    // print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size for each uproc
    for (int i = 0; i < entries; ++i)
 278:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 27c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 27f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
 282:	0f 8c 04 fe ff ff    	jl     8c <main+0x8c>
		table[i].state,
		table[i].size);
    }
  }
  
  exit();
 288:	e8 57 02 00 00       	call   4e4 <exit>

0000028d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 28d:	55                   	push   %ebp
 28e:	89 e5                	mov    %esp,%ebp
 290:	57                   	push   %edi
 291:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 292:	8b 4d 08             	mov    0x8(%ebp),%ecx
 295:	8b 55 10             	mov    0x10(%ebp),%edx
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	89 cb                	mov    %ecx,%ebx
 29d:	89 df                	mov    %ebx,%edi
 29f:	89 d1                	mov    %edx,%ecx
 2a1:	fc                   	cld    
 2a2:	f3 aa                	rep stos %al,%es:(%edi)
 2a4:	89 ca                	mov    %ecx,%edx
 2a6:	89 fb                	mov    %edi,%ebx
 2a8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2ab:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2ae:	90                   	nop
 2af:	5b                   	pop    %ebx
 2b0:	5f                   	pop    %edi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    

000002b3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2bf:	90                   	nop
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	8d 50 01             	lea    0x1(%eax),%edx
 2c6:	89 55 08             	mov    %edx,0x8(%ebp)
 2c9:	8b 55 0c             	mov    0xc(%ebp),%edx
 2cc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2cf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2d2:	0f b6 12             	movzbl (%edx),%edx
 2d5:	88 10                	mov    %dl,(%eax)
 2d7:	0f b6 00             	movzbl (%eax),%eax
 2da:	84 c0                	test   %al,%al
 2dc:	75 e2                	jne    2c0 <strcpy+0xd>
    ;
  return os;
 2de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e1:	c9                   	leave  
 2e2:	c3                   	ret    

000002e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e3:	55                   	push   %ebp
 2e4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2e6:	eb 08                	jmp    2f0 <strcmp+0xd>
    p++, q++;
 2e8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2ec:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	0f b6 00             	movzbl (%eax),%eax
 2f6:	84 c0                	test   %al,%al
 2f8:	74 10                	je     30a <strcmp+0x27>
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 10             	movzbl (%eax),%edx
 300:	8b 45 0c             	mov    0xc(%ebp),%eax
 303:	0f b6 00             	movzbl (%eax),%eax
 306:	38 c2                	cmp    %al,%dl
 308:	74 de                	je     2e8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
 30d:	0f b6 00             	movzbl (%eax),%eax
 310:	0f b6 d0             	movzbl %al,%edx
 313:	8b 45 0c             	mov    0xc(%ebp),%eax
 316:	0f b6 00             	movzbl (%eax),%eax
 319:	0f b6 c0             	movzbl %al,%eax
 31c:	29 c2                	sub    %eax,%edx
 31e:	89 d0                	mov    %edx,%eax
}
 320:	5d                   	pop    %ebp
 321:	c3                   	ret    

00000322 <strlen>:

uint
strlen(char *s)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 328:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 32f:	eb 04                	jmp    335 <strlen+0x13>
 331:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 335:	8b 55 fc             	mov    -0x4(%ebp),%edx
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	01 d0                	add    %edx,%eax
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	84 c0                	test   %al,%al
 342:	75 ed                	jne    331 <strlen+0xf>
    ;
  return n;
 344:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <memset>:

void*
memset(void *dst, int c, uint n)
{
 349:	55                   	push   %ebp
 34a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 34c:	8b 45 10             	mov    0x10(%ebp),%eax
 34f:	50                   	push   %eax
 350:	ff 75 0c             	pushl  0xc(%ebp)
 353:	ff 75 08             	pushl  0x8(%ebp)
 356:	e8 32 ff ff ff       	call   28d <stosb>
 35b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 361:	c9                   	leave  
 362:	c3                   	ret    

00000363 <strchr>:

char*
strchr(const char *s, char c)
{
 363:	55                   	push   %ebp
 364:	89 e5                	mov    %esp,%ebp
 366:	83 ec 04             	sub    $0x4,%esp
 369:	8b 45 0c             	mov    0xc(%ebp),%eax
 36c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 36f:	eb 14                	jmp    385 <strchr+0x22>
    if(*s == c)
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	0f b6 00             	movzbl (%eax),%eax
 377:	3a 45 fc             	cmp    -0x4(%ebp),%al
 37a:	75 05                	jne    381 <strchr+0x1e>
      return (char*)s;
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	eb 13                	jmp    394 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 381:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	0f b6 00             	movzbl (%eax),%eax
 38b:	84 c0                	test   %al,%al
 38d:	75 e2                	jne    371 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 38f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 394:	c9                   	leave  
 395:	c3                   	ret    

00000396 <gets>:

char*
gets(char *buf, int max)
{
 396:	55                   	push   %ebp
 397:	89 e5                	mov    %esp,%ebp
 399:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 39c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3a3:	eb 42                	jmp    3e7 <gets+0x51>
    cc = read(0, &c, 1);
 3a5:	83 ec 04             	sub    $0x4,%esp
 3a8:	6a 01                	push   $0x1
 3aa:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3ad:	50                   	push   %eax
 3ae:	6a 00                	push   $0x0
 3b0:	e8 47 01 00 00       	call   4fc <read>
 3b5:	83 c4 10             	add    $0x10,%esp
 3b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3bf:	7e 33                	jle    3f4 <gets+0x5e>
      break;
    buf[i++] = c;
 3c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c4:	8d 50 01             	lea    0x1(%eax),%edx
 3c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3ca:	89 c2                	mov    %eax,%edx
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
 3cf:	01 c2                	add    %eax,%edx
 3d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3d5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3d7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3db:	3c 0a                	cmp    $0xa,%al
 3dd:	74 16                	je     3f5 <gets+0x5f>
 3df:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3e3:	3c 0d                	cmp    $0xd,%al
 3e5:	74 0e                	je     3f5 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ea:	83 c0 01             	add    $0x1,%eax
 3ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3f0:	7c b3                	jl     3a5 <gets+0xf>
 3f2:	eb 01                	jmp    3f5 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3f4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	01 d0                	add    %edx,%eax
 3fd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 400:	8b 45 08             	mov    0x8(%ebp),%eax
}
 403:	c9                   	leave  
 404:	c3                   	ret    

00000405 <stat>:

int
stat(char *n, struct stat *st)
{
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
 408:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 40b:	83 ec 08             	sub    $0x8,%esp
 40e:	6a 00                	push   $0x0
 410:	ff 75 08             	pushl  0x8(%ebp)
 413:	e8 0c 01 00 00       	call   524 <open>
 418:	83 c4 10             	add    $0x10,%esp
 41b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 41e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 422:	79 07                	jns    42b <stat+0x26>
    return -1;
 424:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 429:	eb 25                	jmp    450 <stat+0x4b>
  r = fstat(fd, st);
 42b:	83 ec 08             	sub    $0x8,%esp
 42e:	ff 75 0c             	pushl  0xc(%ebp)
 431:	ff 75 f4             	pushl  -0xc(%ebp)
 434:	e8 03 01 00 00       	call   53c <fstat>
 439:	83 c4 10             	add    $0x10,%esp
 43c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 43f:	83 ec 0c             	sub    $0xc,%esp
 442:	ff 75 f4             	pushl  -0xc(%ebp)
 445:	e8 c2 00 00 00       	call   50c <close>
 44a:	83 c4 10             	add    $0x10,%esp
  return r;
 44d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 450:	c9                   	leave  
 451:	c3                   	ret    

00000452 <atoi>:

int
atoi(const char *s)
{
 452:	55                   	push   %ebp
 453:	89 e5                	mov    %esp,%ebp
 455:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 45f:	eb 25                	jmp    486 <atoi+0x34>
    n = n*10 + *s++ - '0';
 461:	8b 55 fc             	mov    -0x4(%ebp),%edx
 464:	89 d0                	mov    %edx,%eax
 466:	c1 e0 02             	shl    $0x2,%eax
 469:	01 d0                	add    %edx,%eax
 46b:	01 c0                	add    %eax,%eax
 46d:	89 c1                	mov    %eax,%ecx
 46f:	8b 45 08             	mov    0x8(%ebp),%eax
 472:	8d 50 01             	lea    0x1(%eax),%edx
 475:	89 55 08             	mov    %edx,0x8(%ebp)
 478:	0f b6 00             	movzbl (%eax),%eax
 47b:	0f be c0             	movsbl %al,%eax
 47e:	01 c8                	add    %ecx,%eax
 480:	83 e8 30             	sub    $0x30,%eax
 483:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	0f b6 00             	movzbl (%eax),%eax
 48c:	3c 2f                	cmp    $0x2f,%al
 48e:	7e 0a                	jle    49a <atoi+0x48>
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	0f b6 00             	movzbl (%eax),%eax
 496:	3c 39                	cmp    $0x39,%al
 498:	7e c7                	jle    461 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 49a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 49d:	c9                   	leave  
 49e:	c3                   	ret    

0000049f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 49f:	55                   	push   %ebp
 4a0:	89 e5                	mov    %esp,%ebp
 4a2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4b1:	eb 17                	jmp    4ca <memmove+0x2b>
    *dst++ = *src++;
 4b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4b6:	8d 50 01             	lea    0x1(%eax),%edx
 4b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4bf:	8d 4a 01             	lea    0x1(%edx),%ecx
 4c2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4c5:	0f b6 12             	movzbl (%edx),%edx
 4c8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ca:	8b 45 10             	mov    0x10(%ebp),%eax
 4cd:	8d 50 ff             	lea    -0x1(%eax),%edx
 4d0:	89 55 10             	mov    %edx,0x10(%ebp)
 4d3:	85 c0                	test   %eax,%eax
 4d5:	7f dc                	jg     4b3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4da:	c9                   	leave  
 4db:	c3                   	ret    

000004dc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4dc:	b8 01 00 00 00       	mov    $0x1,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <exit>:
SYSCALL(exit)
 4e4:	b8 02 00 00 00       	mov    $0x2,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <wait>:
SYSCALL(wait)
 4ec:	b8 03 00 00 00       	mov    $0x3,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <pipe>:
SYSCALL(pipe)
 4f4:	b8 04 00 00 00       	mov    $0x4,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <read>:
SYSCALL(read)
 4fc:	b8 05 00 00 00       	mov    $0x5,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <write>:
SYSCALL(write)
 504:	b8 10 00 00 00       	mov    $0x10,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <close>:
SYSCALL(close)
 50c:	b8 15 00 00 00       	mov    $0x15,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <kill>:
SYSCALL(kill)
 514:	b8 06 00 00 00       	mov    $0x6,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <exec>:
SYSCALL(exec)
 51c:	b8 07 00 00 00       	mov    $0x7,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <open>:
SYSCALL(open)
 524:	b8 0f 00 00 00       	mov    $0xf,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <mknod>:
SYSCALL(mknod)
 52c:	b8 11 00 00 00       	mov    $0x11,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <unlink>:
SYSCALL(unlink)
 534:	b8 12 00 00 00       	mov    $0x12,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <fstat>:
SYSCALL(fstat)
 53c:	b8 08 00 00 00       	mov    $0x8,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <link>:
SYSCALL(link)
 544:	b8 13 00 00 00       	mov    $0x13,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <mkdir>:
SYSCALL(mkdir)
 54c:	b8 14 00 00 00       	mov    $0x14,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <chdir>:
SYSCALL(chdir)
 554:	b8 09 00 00 00       	mov    $0x9,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <dup>:
SYSCALL(dup)
 55c:	b8 0a 00 00 00       	mov    $0xa,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <getpid>:
SYSCALL(getpid)
 564:	b8 0b 00 00 00       	mov    $0xb,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <sbrk>:
SYSCALL(sbrk)
 56c:	b8 0c 00 00 00       	mov    $0xc,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <sleep>:
SYSCALL(sleep)
 574:	b8 0d 00 00 00       	mov    $0xd,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <uptime>:
SYSCALL(uptime)
 57c:	b8 0e 00 00 00       	mov    $0xe,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <halt>:
SYSCALL(halt)
 584:	b8 16 00 00 00       	mov    $0x16,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 58c:	b8 17 00 00 00       	mov    $0x17,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 594:	b8 18 00 00 00       	mov    $0x18,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 59c:	b8 19 00 00 00       	mov    $0x19,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 5a4:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 5ac:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 5b4:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 5bc:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 5c4:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5cc:	55                   	push   %ebp
 5cd:	89 e5                	mov    %esp,%ebp
 5cf:	83 ec 18             	sub    $0x18,%esp
 5d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5d8:	83 ec 04             	sub    $0x4,%esp
 5db:	6a 01                	push   $0x1
 5dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5e0:	50                   	push   %eax
 5e1:	ff 75 08             	pushl  0x8(%ebp)
 5e4:	e8 1b ff ff ff       	call   504 <write>
 5e9:	83 c4 10             	add    $0x10,%esp
}
 5ec:	90                   	nop
 5ed:	c9                   	leave  
 5ee:	c3                   	ret    

000005ef <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ef:	55                   	push   %ebp
 5f0:	89 e5                	mov    %esp,%ebp
 5f2:	53                   	push   %ebx
 5f3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5fd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 601:	74 17                	je     61a <printint+0x2b>
 603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 607:	79 11                	jns    61a <printint+0x2b>
    neg = 1;
 609:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 610:	8b 45 0c             	mov    0xc(%ebp),%eax
 613:	f7 d8                	neg    %eax
 615:	89 45 ec             	mov    %eax,-0x14(%ebp)
 618:	eb 06                	jmp    620 <printint+0x31>
  } else {
    x = xx;
 61a:	8b 45 0c             	mov    0xc(%ebp),%eax
 61d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 620:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 627:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 62a:	8d 41 01             	lea    0x1(%ecx),%eax
 62d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 630:	8b 5d 10             	mov    0x10(%ebp),%ebx
 633:	8b 45 ec             	mov    -0x14(%ebp),%eax
 636:	ba 00 00 00 00       	mov    $0x0,%edx
 63b:	f7 f3                	div    %ebx
 63d:	89 d0                	mov    %edx,%eax
 63f:	0f b6 80 28 0d 00 00 	movzbl 0xd28(%eax),%eax
 646:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 64a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 64d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 650:	ba 00 00 00 00       	mov    $0x0,%edx
 655:	f7 f3                	div    %ebx
 657:	89 45 ec             	mov    %eax,-0x14(%ebp)
 65a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 65e:	75 c7                	jne    627 <printint+0x38>
  if(neg)
 660:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 664:	74 2d                	je     693 <printint+0xa4>
    buf[i++] = '-';
 666:	8b 45 f4             	mov    -0xc(%ebp),%eax
 669:	8d 50 01             	lea    0x1(%eax),%edx
 66c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 66f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 674:	eb 1d                	jmp    693 <printint+0xa4>
    putc(fd, buf[i]);
 676:	8d 55 dc             	lea    -0x24(%ebp),%edx
 679:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67c:	01 d0                	add    %edx,%eax
 67e:	0f b6 00             	movzbl (%eax),%eax
 681:	0f be c0             	movsbl %al,%eax
 684:	83 ec 08             	sub    $0x8,%esp
 687:	50                   	push   %eax
 688:	ff 75 08             	pushl  0x8(%ebp)
 68b:	e8 3c ff ff ff       	call   5cc <putc>
 690:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69b:	79 d9                	jns    676 <printint+0x87>
    putc(fd, buf[i]);
}
 69d:	90                   	nop
 69e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6a1:	c9                   	leave  
 6a2:	c3                   	ret    

000006a3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6a3:	55                   	push   %ebp
 6a4:	89 e5                	mov    %esp,%ebp
 6a6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6b0:	8d 45 0c             	lea    0xc(%ebp),%eax
 6b3:	83 c0 04             	add    $0x4,%eax
 6b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6c0:	e9 59 01 00 00       	jmp    81e <printf+0x17b>
    c = fmt[i] & 0xff;
 6c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cb:	01 d0                	add    %edx,%eax
 6cd:	0f b6 00             	movzbl (%eax),%eax
 6d0:	0f be c0             	movsbl %al,%eax
 6d3:	25 ff 00 00 00       	and    $0xff,%eax
 6d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6df:	75 2c                	jne    70d <printf+0x6a>
      if(c == '%'){
 6e1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e5:	75 0c                	jne    6f3 <printf+0x50>
        state = '%';
 6e7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6ee:	e9 27 01 00 00       	jmp    81a <printf+0x177>
      } else {
        putc(fd, c);
 6f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f6:	0f be c0             	movsbl %al,%eax
 6f9:	83 ec 08             	sub    $0x8,%esp
 6fc:	50                   	push   %eax
 6fd:	ff 75 08             	pushl  0x8(%ebp)
 700:	e8 c7 fe ff ff       	call   5cc <putc>
 705:	83 c4 10             	add    $0x10,%esp
 708:	e9 0d 01 00 00       	jmp    81a <printf+0x177>
      }
    } else if(state == '%'){
 70d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 711:	0f 85 03 01 00 00    	jne    81a <printf+0x177>
      if(c == 'd'){
 717:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 71b:	75 1e                	jne    73b <printf+0x98>
        printint(fd, *ap, 10, 1);
 71d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	6a 01                	push   $0x1
 724:	6a 0a                	push   $0xa
 726:	50                   	push   %eax
 727:	ff 75 08             	pushl  0x8(%ebp)
 72a:	e8 c0 fe ff ff       	call   5ef <printint>
 72f:	83 c4 10             	add    $0x10,%esp
        ap++;
 732:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 736:	e9 d8 00 00 00       	jmp    813 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 73b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 73f:	74 06                	je     747 <printf+0xa4>
 741:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 745:	75 1e                	jne    765 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 747:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74a:	8b 00                	mov    (%eax),%eax
 74c:	6a 00                	push   $0x0
 74e:	6a 10                	push   $0x10
 750:	50                   	push   %eax
 751:	ff 75 08             	pushl  0x8(%ebp)
 754:	e8 96 fe ff ff       	call   5ef <printint>
 759:	83 c4 10             	add    $0x10,%esp
        ap++;
 75c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 760:	e9 ae 00 00 00       	jmp    813 <printf+0x170>
      } else if(c == 's'){
 765:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 769:	75 43                	jne    7ae <printf+0x10b>
        s = (char*)*ap;
 76b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 76e:	8b 00                	mov    (%eax),%eax
 770:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 773:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 777:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77b:	75 25                	jne    7a2 <printf+0xff>
          s = "(null)";
 77d:	c7 45 f4 cb 0a 00 00 	movl   $0xacb,-0xc(%ebp)
        while(*s != 0){
 784:	eb 1c                	jmp    7a2 <printf+0xff>
          putc(fd, *s);
 786:	8b 45 f4             	mov    -0xc(%ebp),%eax
 789:	0f b6 00             	movzbl (%eax),%eax
 78c:	0f be c0             	movsbl %al,%eax
 78f:	83 ec 08             	sub    $0x8,%esp
 792:	50                   	push   %eax
 793:	ff 75 08             	pushl  0x8(%ebp)
 796:	e8 31 fe ff ff       	call   5cc <putc>
 79b:	83 c4 10             	add    $0x10,%esp
          s++;
 79e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	0f b6 00             	movzbl (%eax),%eax
 7a8:	84 c0                	test   %al,%al
 7aa:	75 da                	jne    786 <printf+0xe3>
 7ac:	eb 65                	jmp    813 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ae:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7b2:	75 1d                	jne    7d1 <printf+0x12e>
        putc(fd, *ap);
 7b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	0f be c0             	movsbl %al,%eax
 7bc:	83 ec 08             	sub    $0x8,%esp
 7bf:	50                   	push   %eax
 7c0:	ff 75 08             	pushl  0x8(%ebp)
 7c3:	e8 04 fe ff ff       	call   5cc <putc>
 7c8:	83 c4 10             	add    $0x10,%esp
        ap++;
 7cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7cf:	eb 42                	jmp    813 <printf+0x170>
      } else if(c == '%'){
 7d1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7d5:	75 17                	jne    7ee <printf+0x14b>
        putc(fd, c);
 7d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7da:	0f be c0             	movsbl %al,%eax
 7dd:	83 ec 08             	sub    $0x8,%esp
 7e0:	50                   	push   %eax
 7e1:	ff 75 08             	pushl  0x8(%ebp)
 7e4:	e8 e3 fd ff ff       	call   5cc <putc>
 7e9:	83 c4 10             	add    $0x10,%esp
 7ec:	eb 25                	jmp    813 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ee:	83 ec 08             	sub    $0x8,%esp
 7f1:	6a 25                	push   $0x25
 7f3:	ff 75 08             	pushl  0x8(%ebp)
 7f6:	e8 d1 fd ff ff       	call   5cc <putc>
 7fb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 801:	0f be c0             	movsbl %al,%eax
 804:	83 ec 08             	sub    $0x8,%esp
 807:	50                   	push   %eax
 808:	ff 75 08             	pushl  0x8(%ebp)
 80b:	e8 bc fd ff ff       	call   5cc <putc>
 810:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 813:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 81a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 81e:	8b 55 0c             	mov    0xc(%ebp),%edx
 821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 824:	01 d0                	add    %edx,%eax
 826:	0f b6 00             	movzbl (%eax),%eax
 829:	84 c0                	test   %al,%al
 82b:	0f 85 94 fe ff ff    	jne    6c5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 831:	90                   	nop
 832:	c9                   	leave  
 833:	c3                   	ret    

00000834 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 834:	55                   	push   %ebp
 835:	89 e5                	mov    %esp,%ebp
 837:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83a:	8b 45 08             	mov    0x8(%ebp),%eax
 83d:	83 e8 08             	sub    $0x8,%eax
 840:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 843:	a1 44 0d 00 00       	mov    0xd44,%eax
 848:	89 45 fc             	mov    %eax,-0x4(%ebp)
 84b:	eb 24                	jmp    871 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 850:	8b 00                	mov    (%eax),%eax
 852:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 855:	77 12                	ja     869 <free+0x35>
 857:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 85d:	77 24                	ja     883 <free+0x4f>
 85f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 862:	8b 00                	mov    (%eax),%eax
 864:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 867:	77 1a                	ja     883 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	8b 00                	mov    (%eax),%eax
 86e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 871:	8b 45 f8             	mov    -0x8(%ebp),%eax
 874:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 877:	76 d4                	jbe    84d <free+0x19>
 879:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87c:	8b 00                	mov    (%eax),%eax
 87e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 881:	76 ca                	jbe    84d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 883:	8b 45 f8             	mov    -0x8(%ebp),%eax
 886:	8b 40 04             	mov    0x4(%eax),%eax
 889:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 890:	8b 45 f8             	mov    -0x8(%ebp),%eax
 893:	01 c2                	add    %eax,%edx
 895:	8b 45 fc             	mov    -0x4(%ebp),%eax
 898:	8b 00                	mov    (%eax),%eax
 89a:	39 c2                	cmp    %eax,%edx
 89c:	75 24                	jne    8c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 89e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a1:	8b 50 04             	mov    0x4(%eax),%edx
 8a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a7:	8b 00                	mov    (%eax),%eax
 8a9:	8b 40 04             	mov    0x4(%eax),%eax
 8ac:	01 c2                	add    %eax,%edx
 8ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b7:	8b 00                	mov    (%eax),%eax
 8b9:	8b 10                	mov    (%eax),%edx
 8bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8be:	89 10                	mov    %edx,(%eax)
 8c0:	eb 0a                	jmp    8cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c5:	8b 10                	mov    (%eax),%edx
 8c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	8b 40 04             	mov    0x4(%eax),%eax
 8d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dc:	01 d0                	add    %edx,%eax
 8de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e1:	75 20                	jne    903 <free+0xcf>
    p->s.size += bp->s.size;
 8e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e6:	8b 50 04             	mov    0x4(%eax),%edx
 8e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ec:	8b 40 04             	mov    0x4(%eax),%eax
 8ef:	01 c2                	add    %eax,%edx
 8f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fa:	8b 10                	mov    (%eax),%edx
 8fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ff:	89 10                	mov    %edx,(%eax)
 901:	eb 08                	jmp    90b <free+0xd7>
  } else
    p->s.ptr = bp;
 903:	8b 45 fc             	mov    -0x4(%ebp),%eax
 906:	8b 55 f8             	mov    -0x8(%ebp),%edx
 909:	89 10                	mov    %edx,(%eax)
  freep = p;
 90b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90e:	a3 44 0d 00 00       	mov    %eax,0xd44
}
 913:	90                   	nop
 914:	c9                   	leave  
 915:	c3                   	ret    

00000916 <morecore>:

static Header*
morecore(uint nu)
{
 916:	55                   	push   %ebp
 917:	89 e5                	mov    %esp,%ebp
 919:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 91c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 923:	77 07                	ja     92c <morecore+0x16>
    nu = 4096;
 925:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 92c:	8b 45 08             	mov    0x8(%ebp),%eax
 92f:	c1 e0 03             	shl    $0x3,%eax
 932:	83 ec 0c             	sub    $0xc,%esp
 935:	50                   	push   %eax
 936:	e8 31 fc ff ff       	call   56c <sbrk>
 93b:	83 c4 10             	add    $0x10,%esp
 93e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 941:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 945:	75 07                	jne    94e <morecore+0x38>
    return 0;
 947:	b8 00 00 00 00       	mov    $0x0,%eax
 94c:	eb 26                	jmp    974 <morecore+0x5e>
  hp = (Header*)p;
 94e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 954:	8b 45 f0             	mov    -0x10(%ebp),%eax
 957:	8b 55 08             	mov    0x8(%ebp),%edx
 95a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 95d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 960:	83 c0 08             	add    $0x8,%eax
 963:	83 ec 0c             	sub    $0xc,%esp
 966:	50                   	push   %eax
 967:	e8 c8 fe ff ff       	call   834 <free>
 96c:	83 c4 10             	add    $0x10,%esp
  return freep;
 96f:	a1 44 0d 00 00       	mov    0xd44,%eax
}
 974:	c9                   	leave  
 975:	c3                   	ret    

00000976 <malloc>:

void*
malloc(uint nbytes)
{
 976:	55                   	push   %ebp
 977:	89 e5                	mov    %esp,%ebp
 979:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97c:	8b 45 08             	mov    0x8(%ebp),%eax
 97f:	83 c0 07             	add    $0x7,%eax
 982:	c1 e8 03             	shr    $0x3,%eax
 985:	83 c0 01             	add    $0x1,%eax
 988:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 98b:	a1 44 0d 00 00       	mov    0xd44,%eax
 990:	89 45 f0             	mov    %eax,-0x10(%ebp)
 993:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 997:	75 23                	jne    9bc <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 999:	c7 45 f0 3c 0d 00 00 	movl   $0xd3c,-0x10(%ebp)
 9a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a3:	a3 44 0d 00 00       	mov    %eax,0xd44
 9a8:	a1 44 0d 00 00       	mov    0xd44,%eax
 9ad:	a3 3c 0d 00 00       	mov    %eax,0xd3c
    base.s.size = 0;
 9b2:	c7 05 40 0d 00 00 00 	movl   $0x0,0xd40
 9b9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bf:	8b 00                	mov    (%eax),%eax
 9c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c7:	8b 40 04             	mov    0x4(%eax),%eax
 9ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9cd:	72 4d                	jb     a1c <malloc+0xa6>
      if(p->s.size == nunits)
 9cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d2:	8b 40 04             	mov    0x4(%eax),%eax
 9d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d8:	75 0c                	jne    9e6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dd:	8b 10                	mov    (%eax),%edx
 9df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e2:	89 10                	mov    %edx,(%eax)
 9e4:	eb 26                	jmp    a0c <malloc+0x96>
      else {
        p->s.size -= nunits;
 9e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e9:	8b 40 04             	mov    0x4(%eax),%eax
 9ec:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9ef:	89 c2                	mov    %eax,%edx
 9f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fa:	8b 40 04             	mov    0x4(%eax),%eax
 9fd:	c1 e0 03             	shl    $0x3,%eax
 a00:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a06:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a09:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0f:	a3 44 0d 00 00       	mov    %eax,0xd44
      return (void*)(p + 1);
 a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a17:	83 c0 08             	add    $0x8,%eax
 a1a:	eb 3b                	jmp    a57 <malloc+0xe1>
    }
    if(p == freep)
 a1c:	a1 44 0d 00 00       	mov    0xd44,%eax
 a21:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a24:	75 1e                	jne    a44 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a26:	83 ec 0c             	sub    $0xc,%esp
 a29:	ff 75 ec             	pushl  -0x14(%ebp)
 a2c:	e8 e5 fe ff ff       	call   916 <morecore>
 a31:	83 c4 10             	add    $0x10,%esp
 a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a3b:	75 07                	jne    a44 <malloc+0xce>
        return 0;
 a3d:	b8 00 00 00 00       	mov    $0x0,%eax
 a42:	eb 13                	jmp    a57 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	8b 00                	mov    (%eax),%eax
 a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a52:	e9 6d ff ff ff       	jmp    9c4 <malloc+0x4e>
}
 a57:	c9                   	leave  
 a58:	c3                   	ret    
