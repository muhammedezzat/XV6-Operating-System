
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
  2b:	e8 ec 09 00 00       	call   a1c <malloc>
  30:	83 c4 10             	add    $0x10,%esp
  33:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int entries = 0; // actual entries in the table
  36:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // get procs
  entries = getprocs(max, table);
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	ff 75 dc             	pushl  -0x24(%ebp)
  43:	ff 75 e0             	pushl  -0x20(%ebp)
  46:	e8 ff 05 00 00       	call   64a <getprocs>
  4b:	83 c4 10             	add    $0x10,%esp
  4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (entries <= 0)
  51:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  55:	7f 17                	jg     6e <main+0x6e>
    printf(1, "No entries. Error.");
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	68 00 0b 00 00       	push   $0xb00
  5f:	6a 01                	push   $0x1
  61:	e8 e3 06 00 00       	call   749 <printf>
  66:	83 c4 10             	add    $0x10,%esp
  69:	e9 1a 02 00 00       	jmp    288 <main+0x288>
  else
  {
    // print table header
    printf(1, "\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n"); // Modified for Project 4: ps Command
  6e:	83 ec 08             	sub    $0x8,%esp
  71:	68 14 0b 00 00       	push   $0xb14
  76:	6a 01                	push   $0x1
  78:	e8 cc 06 00 00       	call   749 <printf>
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
 269:	68 48 0b 00 00       	push   $0xb48
 26e:	6a 01                	push   $0x1
 270:	e8 d4 04 00 00       	call   749 <printf>
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
 288:	e8 e5 02 00 00       	call   572 <exit>

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
 3b0:	e8 d5 01 00 00       	call   58a <read>
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
 413:	e8 9a 01 00 00       	call   5b2 <open>
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
 434:	e8 91 01 00 00       	call   5ca <fstat>
 439:	83 c4 10             	add    $0x10,%esp
 43c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 43f:	83 ec 0c             	sub    $0xc,%esp
 442:	ff 75 f4             	pushl  -0xc(%ebp)
 445:	e8 50 01 00 00       	call   59a <close>
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

000004dc <atoo>:

int
atoo(const char *s)
{
 4dc:	55                   	push   %ebp
 4dd:	89 e5                	mov    %esp,%ebp
 4df:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 4e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 4e9:	eb 04                	jmp    4ef <atoo+0x13>
 4eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4ef:	8b 45 08             	mov    0x8(%ebp),%eax
 4f2:	0f b6 00             	movzbl (%eax),%eax
 4f5:	3c 20                	cmp    $0x20,%al
 4f7:	74 f2                	je     4eb <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 4f9:	8b 45 08             	mov    0x8(%ebp),%eax
 4fc:	0f b6 00             	movzbl (%eax),%eax
 4ff:	3c 2d                	cmp    $0x2d,%al
 501:	75 07                	jne    50a <atoo+0x2e>
 503:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 508:	eb 05                	jmp    50f <atoo+0x33>
 50a:	b8 01 00 00 00       	mov    $0x1,%eax
 50f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	0f b6 00             	movzbl (%eax),%eax
 518:	3c 2b                	cmp    $0x2b,%al
 51a:	74 0a                	je     526 <atoo+0x4a>
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	0f b6 00             	movzbl (%eax),%eax
 522:	3c 2d                	cmp    $0x2d,%al
 524:	75 27                	jne    54d <atoo+0x71>
    s++;
 526:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 52a:	eb 21                	jmp    54d <atoo+0x71>
    n = n*8 + *s++ - '0';
 52c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 52f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	8d 50 01             	lea    0x1(%eax),%edx
 53c:	89 55 08             	mov    %edx,0x8(%ebp)
 53f:	0f b6 00             	movzbl (%eax),%eax
 542:	0f be c0             	movsbl %al,%eax
 545:	01 c8                	add    %ecx,%eax
 547:	83 e8 30             	sub    $0x30,%eax
 54a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	0f b6 00             	movzbl (%eax),%eax
 553:	3c 2f                	cmp    $0x2f,%al
 555:	7e 0a                	jle    561 <atoo+0x85>
 557:	8b 45 08             	mov    0x8(%ebp),%eax
 55a:	0f b6 00             	movzbl (%eax),%eax
 55d:	3c 37                	cmp    $0x37,%al
 55f:	7e cb                	jle    52c <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 561:	8b 45 f8             	mov    -0x8(%ebp),%eax
 564:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 568:	c9                   	leave  
 569:	c3                   	ret    

0000056a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 56a:	b8 01 00 00 00       	mov    $0x1,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <exit>:
SYSCALL(exit)
 572:	b8 02 00 00 00       	mov    $0x2,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <wait>:
SYSCALL(wait)
 57a:	b8 03 00 00 00       	mov    $0x3,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <pipe>:
SYSCALL(pipe)
 582:	b8 04 00 00 00       	mov    $0x4,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <read>:
SYSCALL(read)
 58a:	b8 05 00 00 00       	mov    $0x5,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <write>:
SYSCALL(write)
 592:	b8 10 00 00 00       	mov    $0x10,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <close>:
SYSCALL(close)
 59a:	b8 15 00 00 00       	mov    $0x15,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <kill>:
SYSCALL(kill)
 5a2:	b8 06 00 00 00       	mov    $0x6,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <exec>:
SYSCALL(exec)
 5aa:	b8 07 00 00 00       	mov    $0x7,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <open>:
SYSCALL(open)
 5b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <mknod>:
SYSCALL(mknod)
 5ba:	b8 11 00 00 00       	mov    $0x11,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <unlink>:
SYSCALL(unlink)
 5c2:	b8 12 00 00 00       	mov    $0x12,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <fstat>:
SYSCALL(fstat)
 5ca:	b8 08 00 00 00       	mov    $0x8,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <link>:
SYSCALL(link)
 5d2:	b8 13 00 00 00       	mov    $0x13,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <mkdir>:
SYSCALL(mkdir)
 5da:	b8 14 00 00 00       	mov    $0x14,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <chdir>:
SYSCALL(chdir)
 5e2:	b8 09 00 00 00       	mov    $0x9,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <dup>:
SYSCALL(dup)
 5ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <getpid>:
SYSCALL(getpid)
 5f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <sbrk>:
SYSCALL(sbrk)
 5fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <sleep>:
SYSCALL(sleep)
 602:	b8 0d 00 00 00       	mov    $0xd,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <uptime>:
SYSCALL(uptime)
 60a:	b8 0e 00 00 00       	mov    $0xe,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <halt>:
SYSCALL(halt)
 612:	b8 16 00 00 00       	mov    $0x16,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 61a:	b8 17 00 00 00       	mov    $0x17,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 622:	b8 18 00 00 00       	mov    $0x18,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 62a:	b8 19 00 00 00       	mov    $0x19,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 632:	b8 1a 00 00 00       	mov    $0x1a,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 63a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 642:	b8 1c 00 00 00       	mov    $0x1c,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 64a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 652:	b8 1b 00 00 00       	mov    $0x1b,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 65a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 662:	b8 1d 00 00 00       	mov    $0x1d,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 66a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 672:	55                   	push   %ebp
 673:	89 e5                	mov    %esp,%ebp
 675:	83 ec 18             	sub    $0x18,%esp
 678:	8b 45 0c             	mov    0xc(%ebp),%eax
 67b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 67e:	83 ec 04             	sub    $0x4,%esp
 681:	6a 01                	push   $0x1
 683:	8d 45 f4             	lea    -0xc(%ebp),%eax
 686:	50                   	push   %eax
 687:	ff 75 08             	pushl  0x8(%ebp)
 68a:	e8 03 ff ff ff       	call   592 <write>
 68f:	83 c4 10             	add    $0x10,%esp
}
 692:	90                   	nop
 693:	c9                   	leave  
 694:	c3                   	ret    

00000695 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 695:	55                   	push   %ebp
 696:	89 e5                	mov    %esp,%ebp
 698:	53                   	push   %ebx
 699:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 69c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6a3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6a7:	74 17                	je     6c0 <printint+0x2b>
 6a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6ad:	79 11                	jns    6c0 <printint+0x2b>
    neg = 1;
 6af:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b9:	f7 d8                	neg    %eax
 6bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6be:	eb 06                	jmp    6c6 <printint+0x31>
  } else {
    x = xx;
 6c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6cd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6d0:	8d 41 01             	lea    0x1(%ecx),%eax
 6d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6dc:	ba 00 00 00 00       	mov    $0x0,%edx
 6e1:	f7 f3                	div    %ebx
 6e3:	89 d0                	mov    %edx,%eax
 6e5:	0f b6 80 ec 0d 00 00 	movzbl 0xdec(%eax),%eax
 6ec:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6f6:	ba 00 00 00 00       	mov    $0x0,%edx
 6fb:	f7 f3                	div    %ebx
 6fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 700:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 704:	75 c7                	jne    6cd <printint+0x38>
  if(neg)
 706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70a:	74 2d                	je     739 <printint+0xa4>
    buf[i++] = '-';
 70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70f:	8d 50 01             	lea    0x1(%eax),%edx
 712:	89 55 f4             	mov    %edx,-0xc(%ebp)
 715:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 71a:	eb 1d                	jmp    739 <printint+0xa4>
    putc(fd, buf[i]);
 71c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 71f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 722:	01 d0                	add    %edx,%eax
 724:	0f b6 00             	movzbl (%eax),%eax
 727:	0f be c0             	movsbl %al,%eax
 72a:	83 ec 08             	sub    $0x8,%esp
 72d:	50                   	push   %eax
 72e:	ff 75 08             	pushl  0x8(%ebp)
 731:	e8 3c ff ff ff       	call   672 <putc>
 736:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 739:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 73d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 741:	79 d9                	jns    71c <printint+0x87>
    putc(fd, buf[i]);
}
 743:	90                   	nop
 744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 747:	c9                   	leave  
 748:	c3                   	ret    

00000749 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 749:	55                   	push   %ebp
 74a:	89 e5                	mov    %esp,%ebp
 74c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 74f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 756:	8d 45 0c             	lea    0xc(%ebp),%eax
 759:	83 c0 04             	add    $0x4,%eax
 75c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 75f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 766:	e9 59 01 00 00       	jmp    8c4 <printf+0x17b>
    c = fmt[i] & 0xff;
 76b:	8b 55 0c             	mov    0xc(%ebp),%edx
 76e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 771:	01 d0                	add    %edx,%eax
 773:	0f b6 00             	movzbl (%eax),%eax
 776:	0f be c0             	movsbl %al,%eax
 779:	25 ff 00 00 00       	and    $0xff,%eax
 77e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 781:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 785:	75 2c                	jne    7b3 <printf+0x6a>
      if(c == '%'){
 787:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 78b:	75 0c                	jne    799 <printf+0x50>
        state = '%';
 78d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 794:	e9 27 01 00 00       	jmp    8c0 <printf+0x177>
      } else {
        putc(fd, c);
 799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 79c:	0f be c0             	movsbl %al,%eax
 79f:	83 ec 08             	sub    $0x8,%esp
 7a2:	50                   	push   %eax
 7a3:	ff 75 08             	pushl  0x8(%ebp)
 7a6:	e8 c7 fe ff ff       	call   672 <putc>
 7ab:	83 c4 10             	add    $0x10,%esp
 7ae:	e9 0d 01 00 00       	jmp    8c0 <printf+0x177>
      }
    } else if(state == '%'){
 7b3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7b7:	0f 85 03 01 00 00    	jne    8c0 <printf+0x177>
      if(c == 'd'){
 7bd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7c1:	75 1e                	jne    7e1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	6a 01                	push   $0x1
 7ca:	6a 0a                	push   $0xa
 7cc:	50                   	push   %eax
 7cd:	ff 75 08             	pushl  0x8(%ebp)
 7d0:	e8 c0 fe ff ff       	call   695 <printint>
 7d5:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7dc:	e9 d8 00 00 00       	jmp    8b9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7e1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7e5:	74 06                	je     7ed <printf+0xa4>
 7e7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7eb:	75 1e                	jne    80b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	6a 00                	push   $0x0
 7f4:	6a 10                	push   $0x10
 7f6:	50                   	push   %eax
 7f7:	ff 75 08             	pushl  0x8(%ebp)
 7fa:	e8 96 fe ff ff       	call   695 <printint>
 7ff:	83 c4 10             	add    $0x10,%esp
        ap++;
 802:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 806:	e9 ae 00 00 00       	jmp    8b9 <printf+0x170>
      } else if(c == 's'){
 80b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 80f:	75 43                	jne    854 <printf+0x10b>
        s = (char*)*ap;
 811:	8b 45 e8             	mov    -0x18(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 819:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 81d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 821:	75 25                	jne    848 <printf+0xff>
          s = "(null)";
 823:	c7 45 f4 6f 0b 00 00 	movl   $0xb6f,-0xc(%ebp)
        while(*s != 0){
 82a:	eb 1c                	jmp    848 <printf+0xff>
          putc(fd, *s);
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	0f b6 00             	movzbl (%eax),%eax
 832:	0f be c0             	movsbl %al,%eax
 835:	83 ec 08             	sub    $0x8,%esp
 838:	50                   	push   %eax
 839:	ff 75 08             	pushl  0x8(%ebp)
 83c:	e8 31 fe ff ff       	call   672 <putc>
 841:	83 c4 10             	add    $0x10,%esp
          s++;
 844:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	0f b6 00             	movzbl (%eax),%eax
 84e:	84 c0                	test   %al,%al
 850:	75 da                	jne    82c <printf+0xe3>
 852:	eb 65                	jmp    8b9 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 854:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 858:	75 1d                	jne    877 <printf+0x12e>
        putc(fd, *ap);
 85a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 85d:	8b 00                	mov    (%eax),%eax
 85f:	0f be c0             	movsbl %al,%eax
 862:	83 ec 08             	sub    $0x8,%esp
 865:	50                   	push   %eax
 866:	ff 75 08             	pushl  0x8(%ebp)
 869:	e8 04 fe ff ff       	call   672 <putc>
 86e:	83 c4 10             	add    $0x10,%esp
        ap++;
 871:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 875:	eb 42                	jmp    8b9 <printf+0x170>
      } else if(c == '%'){
 877:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 87b:	75 17                	jne    894 <printf+0x14b>
        putc(fd, c);
 87d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 880:	0f be c0             	movsbl %al,%eax
 883:	83 ec 08             	sub    $0x8,%esp
 886:	50                   	push   %eax
 887:	ff 75 08             	pushl  0x8(%ebp)
 88a:	e8 e3 fd ff ff       	call   672 <putc>
 88f:	83 c4 10             	add    $0x10,%esp
 892:	eb 25                	jmp    8b9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 894:	83 ec 08             	sub    $0x8,%esp
 897:	6a 25                	push   $0x25
 899:	ff 75 08             	pushl  0x8(%ebp)
 89c:	e8 d1 fd ff ff       	call   672 <putc>
 8a1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a7:	0f be c0             	movsbl %al,%eax
 8aa:	83 ec 08             	sub    $0x8,%esp
 8ad:	50                   	push   %eax
 8ae:	ff 75 08             	pushl  0x8(%ebp)
 8b1:	e8 bc fd ff ff       	call   672 <putc>
 8b6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8c0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8c4:	8b 55 0c             	mov    0xc(%ebp),%edx
 8c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ca:	01 d0                	add    %edx,%eax
 8cc:	0f b6 00             	movzbl (%eax),%eax
 8cf:	84 c0                	test   %al,%al
 8d1:	0f 85 94 fe ff ff    	jne    76b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8d7:	90                   	nop
 8d8:	c9                   	leave  
 8d9:	c3                   	ret    

000008da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8da:	55                   	push   %ebp
 8db:	89 e5                	mov    %esp,%ebp
 8dd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e0:	8b 45 08             	mov    0x8(%ebp),%eax
 8e3:	83 e8 08             	sub    $0x8,%eax
 8e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e9:	a1 08 0e 00 00       	mov    0xe08,%eax
 8ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8f1:	eb 24                	jmp    917 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f6:	8b 00                	mov    (%eax),%eax
 8f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8fb:	77 12                	ja     90f <free+0x35>
 8fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 900:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 903:	77 24                	ja     929 <free+0x4f>
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	8b 00                	mov    (%eax),%eax
 90a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 90d:	77 1a                	ja     929 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 912:	8b 00                	mov    (%eax),%eax
 914:	89 45 fc             	mov    %eax,-0x4(%ebp)
 917:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91d:	76 d4                	jbe    8f3 <free+0x19>
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 927:	76 ca                	jbe    8f3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 929:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92c:	8b 40 04             	mov    0x4(%eax),%eax
 92f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 936:	8b 45 f8             	mov    -0x8(%ebp),%eax
 939:	01 c2                	add    %eax,%edx
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 00                	mov    (%eax),%eax
 940:	39 c2                	cmp    %eax,%edx
 942:	75 24                	jne    968 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 944:	8b 45 f8             	mov    -0x8(%ebp),%eax
 947:	8b 50 04             	mov    0x4(%eax),%edx
 94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94d:	8b 00                	mov    (%eax),%eax
 94f:	8b 40 04             	mov    0x4(%eax),%eax
 952:	01 c2                	add    %eax,%edx
 954:	8b 45 f8             	mov    -0x8(%ebp),%eax
 957:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 95a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95d:	8b 00                	mov    (%eax),%eax
 95f:	8b 10                	mov    (%eax),%edx
 961:	8b 45 f8             	mov    -0x8(%ebp),%eax
 964:	89 10                	mov    %edx,(%eax)
 966:	eb 0a                	jmp    972 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 968:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96b:	8b 10                	mov    (%eax),%edx
 96d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 970:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 972:	8b 45 fc             	mov    -0x4(%ebp),%eax
 975:	8b 40 04             	mov    0x4(%eax),%eax
 978:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 97f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 982:	01 d0                	add    %edx,%eax
 984:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 987:	75 20                	jne    9a9 <free+0xcf>
    p->s.size += bp->s.size;
 989:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98c:	8b 50 04             	mov    0x4(%eax),%edx
 98f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 992:	8b 40 04             	mov    0x4(%eax),%eax
 995:	01 c2                	add    %eax,%edx
 997:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 99d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a0:	8b 10                	mov    (%eax),%edx
 9a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a5:	89 10                	mov    %edx,(%eax)
 9a7:	eb 08                	jmp    9b1 <free+0xd7>
  } else
    p->s.ptr = bp;
 9a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9af:	89 10                	mov    %edx,(%eax)
  freep = p;
 9b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b4:	a3 08 0e 00 00       	mov    %eax,0xe08
}
 9b9:	90                   	nop
 9ba:	c9                   	leave  
 9bb:	c3                   	ret    

000009bc <morecore>:

static Header*
morecore(uint nu)
{
 9bc:	55                   	push   %ebp
 9bd:	89 e5                	mov    %esp,%ebp
 9bf:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9c2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9c9:	77 07                	ja     9d2 <morecore+0x16>
    nu = 4096;
 9cb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9d2:	8b 45 08             	mov    0x8(%ebp),%eax
 9d5:	c1 e0 03             	shl    $0x3,%eax
 9d8:	83 ec 0c             	sub    $0xc,%esp
 9db:	50                   	push   %eax
 9dc:	e8 19 fc ff ff       	call   5fa <sbrk>
 9e1:	83 c4 10             	add    $0x10,%esp
 9e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9e7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9eb:	75 07                	jne    9f4 <morecore+0x38>
    return 0;
 9ed:	b8 00 00 00 00       	mov    $0x0,%eax
 9f2:	eb 26                	jmp    a1a <morecore+0x5e>
  hp = (Header*)p;
 9f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fd:	8b 55 08             	mov    0x8(%ebp),%edx
 a00:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a06:	83 c0 08             	add    $0x8,%eax
 a09:	83 ec 0c             	sub    $0xc,%esp
 a0c:	50                   	push   %eax
 a0d:	e8 c8 fe ff ff       	call   8da <free>
 a12:	83 c4 10             	add    $0x10,%esp
  return freep;
 a15:	a1 08 0e 00 00       	mov    0xe08,%eax
}
 a1a:	c9                   	leave  
 a1b:	c3                   	ret    

00000a1c <malloc>:

void*
malloc(uint nbytes)
{
 a1c:	55                   	push   %ebp
 a1d:	89 e5                	mov    %esp,%ebp
 a1f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a22:	8b 45 08             	mov    0x8(%ebp),%eax
 a25:	83 c0 07             	add    $0x7,%eax
 a28:	c1 e8 03             	shr    $0x3,%eax
 a2b:	83 c0 01             	add    $0x1,%eax
 a2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a31:	a1 08 0e 00 00       	mov    0xe08,%eax
 a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a3d:	75 23                	jne    a62 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a3f:	c7 45 f0 00 0e 00 00 	movl   $0xe00,-0x10(%ebp)
 a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a49:	a3 08 0e 00 00       	mov    %eax,0xe08
 a4e:	a1 08 0e 00 00       	mov    0xe08,%eax
 a53:	a3 00 0e 00 00       	mov    %eax,0xe00
    base.s.size = 0;
 a58:	c7 05 04 0e 00 00 00 	movl   $0x0,0xe04
 a5f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a65:	8b 00                	mov    (%eax),%eax
 a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6d:	8b 40 04             	mov    0x4(%eax),%eax
 a70:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a73:	72 4d                	jb     ac2 <malloc+0xa6>
      if(p->s.size == nunits)
 a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a78:	8b 40 04             	mov    0x4(%eax),%eax
 a7b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a7e:	75 0c                	jne    a8c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a83:	8b 10                	mov    (%eax),%edx
 a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a88:	89 10                	mov    %edx,(%eax)
 a8a:	eb 26                	jmp    ab2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8f:	8b 40 04             	mov    0x4(%eax),%eax
 a92:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a95:	89 c2                	mov    %eax,%edx
 a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	8b 40 04             	mov    0x4(%eax),%eax
 aa3:	c1 e0 03             	shl    $0x3,%eax
 aa6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aac:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aaf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab5:	a3 08 0e 00 00       	mov    %eax,0xe08
      return (void*)(p + 1);
 aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abd:	83 c0 08             	add    $0x8,%eax
 ac0:	eb 3b                	jmp    afd <malloc+0xe1>
    }
    if(p == freep)
 ac2:	a1 08 0e 00 00       	mov    0xe08,%eax
 ac7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aca:	75 1e                	jne    aea <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 acc:	83 ec 0c             	sub    $0xc,%esp
 acf:	ff 75 ec             	pushl  -0x14(%ebp)
 ad2:	e8 e5 fe ff ff       	call   9bc <morecore>
 ad7:	83 c4 10             	add    $0x10,%esp
 ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
 add:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ae1:	75 07                	jne    aea <malloc+0xce>
        return 0;
 ae3:	b8 00 00 00 00       	mov    $0x0,%eax
 ae8:	eb 13                	jmp    afd <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af3:	8b 00                	mov    (%eax),%eax
 af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 af8:	e9 6d ff ff ff       	jmp    a6a <malloc+0x4e>
}
 afd:	c9                   	leave  
 afe:	c3                   	ret    
