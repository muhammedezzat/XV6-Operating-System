
_testuidgid:     file format elf32-i386


Disassembly of section .text:

00000000 <uidTest>:
#include "types.h"
#include "user.h"

static void
uidTest(uint nval)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  uint uid = getuid();
   6:	e8 19 07 00 00       	call   724 <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "Current UID is: %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 ec 0b 00 00       	push   $0xbec
  19:	6a 01                	push   $0x1
  1b:	e8 13 08 00 00       	call   833 <printf>
  20:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to %d\n", nval);
  23:	83 ec 04             	sub    $0x4,%esp
  26:	ff 75 08             	pushl  0x8(%ebp)
  29:	68 00 0c 00 00       	push   $0xc00
  2e:	6a 01                	push   $0x1
  30:	e8 fe 07 00 00       	call   833 <printf>
  35:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	ff 75 08             	pushl  0x8(%ebp)
  3e:	e8 f9 06 00 00       	call   73c <setuid>
  43:	83 c4 10             	add    $0x10,%esp
  46:	85 c0                	test   %eax,%eax
  48:	79 15                	jns    5f <uidTest+0x5f>
    printf(2, "Error. Invalid UID: %d\n", nval);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 08             	pushl  0x8(%ebp)
  50:	68 13 0c 00 00       	push   $0xc13
  55:	6a 02                	push   $0x2
  57:	e8 d7 07 00 00       	call   833 <printf>
  5c:	83 c4 10             	add    $0x10,%esp

  uid = getuid();
  5f:	e8 c0 06 00 00       	call   724 <getuid>
  64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  67:	83 ec 04             	sub    $0x4,%esp
  6a:	ff 75 f4             	pushl  -0xc(%ebp)
  6d:	68 ec 0b 00 00       	push   $0xbec
  72:	6a 01                	push   $0x1
  74:	e8 ba 07 00 00       	call   833 <printf>
  79:	83 c4 10             	add    $0x10,%esp

  printf(1, "Sleeping...\n");
  7c:	83 ec 08             	sub    $0x8,%esp
  7f:	68 2b 0c 00 00       	push   $0xc2b
  84:	6a 01                	push   $0x1
  86:	e8 a8 07 00 00       	call   833 <printf>
  8b:	83 c4 10             	add    $0x10,%esp
  sleep(500); // now type control-p
  8e:	83 ec 0c             	sub    $0xc,%esp
  91:	68 f4 01 00 00       	push   $0x1f4
  96:	e8 69 06 00 00       	call   704 <sleep>
  9b:	83 c4 10             	add    $0x10,%esp
}
  9e:	90                   	nop
  9f:	c9                   	leave  
  a0:	c3                   	ret    

000000a1 <gidTest>:

static void
gidTest(uint nval)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 18             	sub    $0x18,%esp
  uint gid = getgid();
  a7:	e8 80 06 00 00       	call   72c <getgid>
  ac:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "Current GID is: %d\n", gid);
  af:	83 ec 04             	sub    $0x4,%esp
  b2:	ff 75 f4             	pushl  -0xc(%ebp)
  b5:	68 38 0c 00 00       	push   $0xc38
  ba:	6a 01                	push   $0x1
  bc:	e8 72 07 00 00       	call   833 <printf>
  c1:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to %d\n", nval);
  c4:	83 ec 04             	sub    $0x4,%esp
  c7:	ff 75 08             	pushl  0x8(%ebp)
  ca:	68 4c 0c 00 00       	push   $0xc4c
  cf:	6a 01                	push   $0x1
  d1:	e8 5d 07 00 00       	call   833 <printf>
  d6:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 08             	pushl  0x8(%ebp)
  df:	e8 60 06 00 00       	call   744 <setgid>
  e4:	83 c4 10             	add    $0x10,%esp
  e7:	85 c0                	test   %eax,%eax
  e9:	79 15                	jns    100 <gidTest+0x5f>
    printf(2, "Error. Invalid GID: %d\n", nval);
  eb:	83 ec 04             	sub    $0x4,%esp
  ee:	ff 75 08             	pushl  0x8(%ebp)
  f1:	68 5f 0c 00 00       	push   $0xc5f
  f6:	6a 02                	push   $0x2
  f8:	e8 36 07 00 00       	call   833 <printf>
  fd:	83 c4 10             	add    $0x10,%esp

  gid = getgid();
 100:	e8 27 06 00 00       	call   72c <getgid>
 105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 108:	83 ec 04             	sub    $0x4,%esp
 10b:	ff 75 f4             	pushl  -0xc(%ebp)
 10e:	68 38 0c 00 00       	push   $0xc38
 113:	6a 01                	push   $0x1
 115:	e8 19 07 00 00       	call   833 <printf>
 11a:	83 c4 10             	add    $0x10,%esp

  printf(1, "Sleeping...\n");
 11d:	83 ec 08             	sub    $0x8,%esp
 120:	68 2b 0c 00 00       	push   $0xc2b
 125:	6a 01                	push   $0x1
 127:	e8 07 07 00 00       	call   833 <printf>
 12c:	83 c4 10             	add    $0x10,%esp
  sleep(500); // now type control-p
 12f:	83 ec 0c             	sub    $0xc,%esp
 132:	68 f4 01 00 00       	push   $0x1f4
 137:	e8 c8 05 00 00       	call   704 <sleep>
 13c:	83 c4 10             	add    $0x10,%esp
}
 13f:	90                   	nop
 140:	c9                   	leave  
 141:	c3                   	ret    

00000142 <forkTest>:

static void
forkTest(uint nval)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	53                   	push   %ebx
 146:	83 ec 14             	sub    $0x14,%esp
  uint uid, gid;
  int pid;

  printf(1, "Setting UID to %d and GID to %d before fork(). Value"
 149:	ff 75 08             	pushl  0x8(%ebp)
 14c:	ff 75 08             	pushl  0x8(%ebp)
 14f:	68 78 0c 00 00       	push   $0xc78
 154:	6a 01                	push   $0x1
 156:	e8 d8 06 00 00       	call   833 <printf>
 15b:	83 c4 10             	add    $0x10,%esp
  	          " should be inherited\n", nval, nval);

  if (setuid(nval) < 0)
 15e:	83 ec 0c             	sub    $0xc,%esp
 161:	ff 75 08             	pushl  0x8(%ebp)
 164:	e8 d3 05 00 00       	call   73c <setuid>
 169:	83 c4 10             	add    $0x10,%esp
 16c:	85 c0                	test   %eax,%eax
 16e:	79 15                	jns    185 <forkTest+0x43>
    printf(2, "Error. Invalid UID: %d\n", nval);
 170:	83 ec 04             	sub    $0x4,%esp
 173:	ff 75 08             	pushl  0x8(%ebp)
 176:	68 13 0c 00 00       	push   $0xc13
 17b:	6a 02                	push   $0x2
 17d:	e8 b1 06 00 00       	call   833 <printf>
 182:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 185:	83 ec 0c             	sub    $0xc,%esp
 188:	ff 75 08             	pushl  0x8(%ebp)
 18b:	e8 b4 05 00 00       	call   744 <setgid>
 190:	83 c4 10             	add    $0x10,%esp
 193:	85 c0                	test   %eax,%eax
 195:	79 15                	jns    1ac <forkTest+0x6a>
    printf(2, "Error. Invalid GID: %d\n", nval);
 197:	83 ec 04             	sub    $0x4,%esp
 19a:	ff 75 08             	pushl  0x8(%ebp)
 19d:	68 5f 0c 00 00       	push   $0xc5f
 1a2:	6a 02                	push   $0x2
 1a4:	e8 8a 06 00 00       	call   833 <printf>
 1a9:	83 c4 10             	add    $0x10,%esp

  printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getgid());
 1ac:	e8 7b 05 00 00       	call   72c <getgid>
 1b1:	89 c3                	mov    %eax,%ebx
 1b3:	e8 6c 05 00 00       	call   724 <getuid>
 1b8:	53                   	push   %ebx
 1b9:	50                   	push   %eax
 1ba:	68 c4 0c 00 00       	push   $0xcc4
 1bf:	6a 01                	push   $0x1
 1c1:	e8 6d 06 00 00       	call   833 <printf>
 1c6:	83 c4 10             	add    $0x10,%esp

  pid = fork();
 1c9:	e8 9e 04 00 00       	call   66c <fork>
 1ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (pid == 0) { // child
 1d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d5:	75 4c                	jne    223 <forkTest+0xe1>
    uid = getuid();
 1d7:	e8 48 05 00 00       	call   724 <getuid>
 1dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    gid = getgid();
 1df:	e8 48 05 00 00       	call   72c <getgid>
 1e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1, "Child: UID is: %d, GID = %d\n", uid, gid);
 1e7:	ff 75 ec             	pushl  -0x14(%ebp)
 1ea:	ff 75 f0             	pushl  -0x10(%ebp)
 1ed:	68 e7 0c 00 00       	push   $0xce7
 1f2:	6a 01                	push   $0x1
 1f4:	e8 3a 06 00 00       	call   833 <printf>
 1f9:	83 c4 10             	add    $0x10,%esp

    printf(1, "Sleeping...\n");
 1fc:	83 ec 08             	sub    $0x8,%esp
 1ff:	68 2b 0c 00 00       	push   $0xc2b
 204:	6a 01                	push   $0x1
 206:	e8 28 06 00 00       	call   833 <printf>
 20b:	83 c4 10             	add    $0x10,%esp
    sleep(500); // now type control-p
 20e:	83 ec 0c             	sub    $0xc,%esp
 211:	68 f4 01 00 00       	push   $0x1f4
 216:	e8 e9 04 00 00       	call   704 <sleep>
 21b:	83 c4 10             	add    $0x10,%esp

    exit();
 21e:	e8 51 04 00 00       	call   674 <exit>
  }
  else
    sleep(1000); // wait for child to exit before proceeding
 223:	83 ec 0c             	sub    $0xc,%esp
 226:	68 e8 03 00 00       	push   $0x3e8
 22b:	e8 d4 04 00 00       	call   704 <sleep>
 230:	83 c4 10             	add    $0x10,%esp

}
 233:	90                   	nop
 234:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <invalidTest>:

static void
invalidTest(uint nval)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 08             	sub    $0x8,%esp
  printf(1, "Setting UID to %d. This test should FAIL\n", nval);
 23f:	83 ec 04             	sub    $0x4,%esp
 242:	ff 75 08             	pushl  0x8(%ebp)
 245:	68 04 0d 00 00       	push   $0xd04
 24a:	6a 01                	push   $0x1
 24c:	e8 e2 05 00 00       	call   833 <printf>
 251:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
 254:	83 ec 0c             	sub    $0xc,%esp
 257:	ff 75 08             	pushl  0x8(%ebp)
 25a:	e8 dd 04 00 00       	call   73c <setuid>
 25f:	83 c4 10             	add    $0x10,%esp
 262:	85 c0                	test   %eax,%eax
 264:	79 14                	jns    27a <invalidTest+0x41>
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
 266:	83 ec 08             	sub    $0x8,%esp
 269:	68 30 0d 00 00       	push   $0xd30
 26e:	6a 01                	push   $0x1
 270:	e8 be 05 00 00       	call   833 <printf>
 275:	83 c4 10             	add    $0x10,%esp
 278:	eb 12                	jmp    28c <invalidTest+0x53>
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");
 27a:	83 ec 08             	sub    $0x8,%esp
 27d:	68 64 0d 00 00       	push   $0xd64
 282:	6a 02                	push   $0x2
 284:	e8 aa 05 00 00       	call   833 <printf>
 289:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", nval);
 28c:	83 ec 04             	sub    $0x4,%esp
 28f:	ff 75 08             	pushl  0x8(%ebp)
 292:	68 98 0d 00 00       	push   $0xd98
 297:	6a 01                	push   $0x1
 299:	e8 95 05 00 00       	call   833 <printf>
 29e:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 2a1:	83 ec 0c             	sub    $0xc,%esp
 2a4:	ff 75 08             	pushl  0x8(%ebp)
 2a7:	e8 98 04 00 00       	call   744 <setgid>
 2ac:	83 c4 10             	add    $0x10,%esp
 2af:	85 c0                	test   %eax,%eax
 2b1:	79 14                	jns    2c7 <invalidTest+0x8e>
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
 2b3:	83 ec 08             	sub    $0x8,%esp
 2b6:	68 c4 0d 00 00       	push   $0xdc4
 2bb:	6a 01                	push   $0x1
 2bd:	e8 71 05 00 00       	call   833 <printf>
 2c2:	83 c4 10             	add    $0x10,%esp
 2c5:	eb 12                	jmp    2d9 <invalidTest+0xa0>
  else
    printf(2, "FAILURE! The setgid system call indicates success\n");
 2c7:	83 ec 08             	sub    $0x8,%esp
 2ca:	68 f8 0d 00 00       	push   $0xdf8
 2cf:	6a 02                	push   $0x2
 2d1:	e8 5d 05 00 00       	call   833 <printf>
 2d6:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting UID to %d. This test should FAIL\n", -1);
 2d9:	83 ec 04             	sub    $0x4,%esp
 2dc:	6a ff                	push   $0xffffffff
 2de:	68 04 0d 00 00       	push   $0xd04
 2e3:	6a 01                	push   $0x1
 2e5:	e8 49 05 00 00       	call   833 <printf>
 2ea:	83 c4 10             	add    $0x10,%esp
  if (setuid(-1) < 0)
 2ed:	83 ec 0c             	sub    $0xc,%esp
 2f0:	6a ff                	push   $0xffffffff
 2f2:	e8 45 04 00 00       	call   73c <setuid>
 2f7:	83 c4 10             	add    $0x10,%esp
 2fa:	85 c0                	test   %eax,%eax
 2fc:	79 14                	jns    312 <invalidTest+0xd9>
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
 2fe:	83 ec 08             	sub    $0x8,%esp
 301:	68 30 0d 00 00       	push   $0xd30
 306:	6a 01                	push   $0x1
 308:	e8 26 05 00 00       	call   833 <printf>
 30d:	83 c4 10             	add    $0x10,%esp
 310:	eb 12                	jmp    324 <invalidTest+0xeb>
  else
    printf(2, "FAILURE! The setuid system call indicated success\n");
 312:	83 ec 08             	sub    $0x8,%esp
 315:	68 2c 0e 00 00       	push   $0xe2c
 31a:	6a 02                	push   $0x2
 31c:	e8 12 05 00 00       	call   833 <printf>
 321:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", -1);
 324:	83 ec 04             	sub    $0x4,%esp
 327:	6a ff                	push   $0xffffffff
 329:	68 98 0d 00 00       	push   $0xd98
 32e:	6a 01                	push   $0x1
 330:	e8 fe 04 00 00       	call   833 <printf>
 335:	83 c4 10             	add    $0x10,%esp
  if (setgid(-1) < 0)
 338:	83 ec 0c             	sub    $0xc,%esp
 33b:	6a ff                	push   $0xffffffff
 33d:	e8 02 04 00 00       	call   744 <setgid>
 342:	83 c4 10             	add    $0x10,%esp
 345:	85 c0                	test   %eax,%eax
 347:	79 14                	jns    35d <invalidTest+0x124>
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
 349:	83 ec 08             	sub    $0x8,%esp
 34c:	68 c4 0d 00 00       	push   $0xdc4
 351:	6a 01                	push   $0x1
 353:	e8 db 04 00 00       	call   833 <printf>
 358:	83 c4 10             	add    $0x10,%esp
  else
    printf(2, "FAILURE! The setgid system call indicated success\n");
}
 35b:	eb 12                	jmp    36f <invalidTest+0x136>

  printf(1, "Setting GID to %d. This test should FAIL\n", -1);
  if (setgid(-1) < 0)
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
  else
    printf(2, "FAILURE! The setgid system call indicated success\n");
 35d:	83 ec 08             	sub    $0x8,%esp
 360:	68 60 0e 00 00       	push   $0xe60
 365:	6a 02                	push   $0x2
 367:	e8 c7 04 00 00       	call   833 <printf>
 36c:	83 c4 10             	add    $0x10,%esp
}
 36f:	90                   	nop
 370:	c9                   	leave  
 371:	c3                   	ret    

00000372 <testuidgid>:

static int
testuidgid(void)
{
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	83 ec 18             	sub    $0x18,%esp
  uint nval;
  int ppid;

  // get/set uid test (valid value)
  nval = 100;
 378:	c7 45 f4 64 00 00 00 	movl   $0x64,-0xc(%ebp)
  uidTest(nval);
 37f:	83 ec 0c             	sub    $0xc,%esp
 382:	ff 75 f4             	pushl  -0xc(%ebp)
 385:	e8 76 fc ff ff       	call   0 <uidTest>
 38a:	83 c4 10             	add    $0x10,%esp

  // get/set gid test (valid value)
  nval = 200;
 38d:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%ebp)
  gidTest(nval);
 394:	83 ec 0c             	sub    $0xc,%esp
 397:	ff 75 f4             	pushl  -0xc(%ebp)
 39a:	e8 02 fd ff ff       	call   a1 <gidTest>
 39f:	83 c4 10             	add    $0x10,%esp

  // get ppid test
  ppid = getppid();
 3a2:	e8 8d 03 00 00       	call   734 <getppid>
 3a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "My parent process is: %d\n", ppid);
 3aa:	83 ec 04             	sub    $0x4,%esp
 3ad:	ff 75 f0             	pushl  -0x10(%ebp)
 3b0:	68 93 0e 00 00       	push   $0xe93
 3b5:	6a 01                	push   $0x1
 3b7:	e8 77 04 00 00       	call   833 <printf>
 3bc:	83 c4 10             	add    $0x10,%esp

  // fork tests to demonstrate UID/GID inheritance
  nval = 111;
 3bf:	c7 45 f4 6f 00 00 00 	movl   $0x6f,-0xc(%ebp)
  forkTest(nval);
 3c6:	83 ec 0c             	sub    $0xc,%esp
 3c9:	ff 75 f4             	pushl  -0xc(%ebp)
 3cc:	e8 71 fd ff ff       	call   142 <forkTest>
 3d1:	83 c4 10             	add    $0x10,%esp

  // tests for invalid values for uid and gid setters
  nval = 32800;
 3d4:	c7 45 f4 20 80 00 00 	movl   $0x8020,-0xc(%ebp)
  invalidTest(nval);
 3db:	83 ec 0c             	sub    $0xc,%esp
 3de:	ff 75 f4             	pushl  -0xc(%ebp)
 3e1:	e8 53 fe ff ff       	call   239 <invalidTest>
 3e6:	83 c4 10             	add    $0x10,%esp

  printf(1, "Done!\n");
 3e9:	83 ec 08             	sub    $0x8,%esp
 3ec:	68 ad 0e 00 00       	push   $0xead
 3f1:	6a 01                	push   $0x1
 3f3:	e8 3b 04 00 00       	call   833 <printf>
 3f8:	83 c4 10             	add    $0x10,%esp
  return 0;
 3fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 400:	c9                   	leave  
 401:	c3                   	ret    

00000402 <main>:

int
main() 
{
 402:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 406:	83 e4 f0             	and    $0xfffffff0,%esp
 409:	ff 71 fc             	pushl  -0x4(%ecx)
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	51                   	push   %ecx
 410:	83 ec 04             	sub    $0x4,%esp
  testuidgid();
 413:	e8 5a ff ff ff       	call   372 <testuidgid>
  exit();
 418:	e8 57 02 00 00       	call   674 <exit>

0000041d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 41d:	55                   	push   %ebp
 41e:	89 e5                	mov    %esp,%ebp
 420:	57                   	push   %edi
 421:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 422:	8b 4d 08             	mov    0x8(%ebp),%ecx
 425:	8b 55 10             	mov    0x10(%ebp),%edx
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	89 cb                	mov    %ecx,%ebx
 42d:	89 df                	mov    %ebx,%edi
 42f:	89 d1                	mov    %edx,%ecx
 431:	fc                   	cld    
 432:	f3 aa                	rep stos %al,%es:(%edi)
 434:	89 ca                	mov    %ecx,%edx
 436:	89 fb                	mov    %edi,%ebx
 438:	89 5d 08             	mov    %ebx,0x8(%ebp)
 43b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 43e:	90                   	nop
 43f:	5b                   	pop    %ebx
 440:	5f                   	pop    %edi
 441:	5d                   	pop    %ebp
 442:	c3                   	ret    

00000443 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 443:	55                   	push   %ebp
 444:	89 e5                	mov    %esp,%ebp
 446:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 44f:	90                   	nop
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	8d 50 01             	lea    0x1(%eax),%edx
 456:	89 55 08             	mov    %edx,0x8(%ebp)
 459:	8b 55 0c             	mov    0xc(%ebp),%edx
 45c:	8d 4a 01             	lea    0x1(%edx),%ecx
 45f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 462:	0f b6 12             	movzbl (%edx),%edx
 465:	88 10                	mov    %dl,(%eax)
 467:	0f b6 00             	movzbl (%eax),%eax
 46a:	84 c0                	test   %al,%al
 46c:	75 e2                	jne    450 <strcpy+0xd>
    ;
  return os;
 46e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 471:	c9                   	leave  
 472:	c3                   	ret    

00000473 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 473:	55                   	push   %ebp
 474:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 476:	eb 08                	jmp    480 <strcmp+0xd>
    p++, q++;
 478:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 47c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	0f b6 00             	movzbl (%eax),%eax
 486:	84 c0                	test   %al,%al
 488:	74 10                	je     49a <strcmp+0x27>
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	0f b6 10             	movzbl (%eax),%edx
 490:	8b 45 0c             	mov    0xc(%ebp),%eax
 493:	0f b6 00             	movzbl (%eax),%eax
 496:	38 c2                	cmp    %al,%dl
 498:	74 de                	je     478 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	0f b6 d0             	movzbl %al,%edx
 4a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a6:	0f b6 00             	movzbl (%eax),%eax
 4a9:	0f b6 c0             	movzbl %al,%eax
 4ac:	29 c2                	sub    %eax,%edx
 4ae:	89 d0                	mov    %edx,%eax
}
 4b0:	5d                   	pop    %ebp
 4b1:	c3                   	ret    

000004b2 <strlen>:

uint
strlen(char *s)
{
 4b2:	55                   	push   %ebp
 4b3:	89 e5                	mov    %esp,%ebp
 4b5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 4b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4bf:	eb 04                	jmp    4c5 <strlen+0x13>
 4c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 4c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	01 d0                	add    %edx,%eax
 4cd:	0f b6 00             	movzbl (%eax),%eax
 4d0:	84 c0                	test   %al,%al
 4d2:	75 ed                	jne    4c1 <strlen+0xf>
    ;
  return n;
 4d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4d7:	c9                   	leave  
 4d8:	c3                   	ret    

000004d9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4d9:	55                   	push   %ebp
 4da:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 4dc:	8b 45 10             	mov    0x10(%ebp),%eax
 4df:	50                   	push   %eax
 4e0:	ff 75 0c             	pushl  0xc(%ebp)
 4e3:	ff 75 08             	pushl  0x8(%ebp)
 4e6:	e8 32 ff ff ff       	call   41d <stosb>
 4eb:	83 c4 0c             	add    $0xc,%esp
  return dst;
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4f1:	c9                   	leave  
 4f2:	c3                   	ret    

000004f3 <strchr>:

char*
strchr(const char *s, char c)
{
 4f3:	55                   	push   %ebp
 4f4:	89 e5                	mov    %esp,%ebp
 4f6:	83 ec 04             	sub    $0x4,%esp
 4f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 4ff:	eb 14                	jmp    515 <strchr+0x22>
    if(*s == c)
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	0f b6 00             	movzbl (%eax),%eax
 507:	3a 45 fc             	cmp    -0x4(%ebp),%al
 50a:	75 05                	jne    511 <strchr+0x1e>
      return (char*)s;
 50c:	8b 45 08             	mov    0x8(%ebp),%eax
 50f:	eb 13                	jmp    524 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 511:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 515:	8b 45 08             	mov    0x8(%ebp),%eax
 518:	0f b6 00             	movzbl (%eax),%eax
 51b:	84 c0                	test   %al,%al
 51d:	75 e2                	jne    501 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 51f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 524:	c9                   	leave  
 525:	c3                   	ret    

00000526 <gets>:

char*
gets(char *buf, int max)
{
 526:	55                   	push   %ebp
 527:	89 e5                	mov    %esp,%ebp
 529:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 52c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 533:	eb 42                	jmp    577 <gets+0x51>
    cc = read(0, &c, 1);
 535:	83 ec 04             	sub    $0x4,%esp
 538:	6a 01                	push   $0x1
 53a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 53d:	50                   	push   %eax
 53e:	6a 00                	push   $0x0
 540:	e8 47 01 00 00       	call   68c <read>
 545:	83 c4 10             	add    $0x10,%esp
 548:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 54b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 54f:	7e 33                	jle    584 <gets+0x5e>
      break;
    buf[i++] = c;
 551:	8b 45 f4             	mov    -0xc(%ebp),%eax
 554:	8d 50 01             	lea    0x1(%eax),%edx
 557:	89 55 f4             	mov    %edx,-0xc(%ebp)
 55a:	89 c2                	mov    %eax,%edx
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	01 c2                	add    %eax,%edx
 561:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 565:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 567:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 56b:	3c 0a                	cmp    $0xa,%al
 56d:	74 16                	je     585 <gets+0x5f>
 56f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 573:	3c 0d                	cmp    $0xd,%al
 575:	74 0e                	je     585 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 577:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57a:	83 c0 01             	add    $0x1,%eax
 57d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 580:	7c b3                	jl     535 <gets+0xf>
 582:	eb 01                	jmp    585 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 584:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 585:	8b 55 f4             	mov    -0xc(%ebp),%edx
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	01 d0                	add    %edx,%eax
 58d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 590:	8b 45 08             	mov    0x8(%ebp),%eax
}
 593:	c9                   	leave  
 594:	c3                   	ret    

00000595 <stat>:

int
stat(char *n, struct stat *st)
{
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp
 598:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 59b:	83 ec 08             	sub    $0x8,%esp
 59e:	6a 00                	push   $0x0
 5a0:	ff 75 08             	pushl  0x8(%ebp)
 5a3:	e8 0c 01 00 00       	call   6b4 <open>
 5a8:	83 c4 10             	add    $0x10,%esp
 5ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 5ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b2:	79 07                	jns    5bb <stat+0x26>
    return -1;
 5b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5b9:	eb 25                	jmp    5e0 <stat+0x4b>
  r = fstat(fd, st);
 5bb:	83 ec 08             	sub    $0x8,%esp
 5be:	ff 75 0c             	pushl  0xc(%ebp)
 5c1:	ff 75 f4             	pushl  -0xc(%ebp)
 5c4:	e8 03 01 00 00       	call   6cc <fstat>
 5c9:	83 c4 10             	add    $0x10,%esp
 5cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 5cf:	83 ec 0c             	sub    $0xc,%esp
 5d2:	ff 75 f4             	pushl  -0xc(%ebp)
 5d5:	e8 c2 00 00 00       	call   69c <close>
 5da:	83 c4 10             	add    $0x10,%esp
  return r;
 5dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 5e0:	c9                   	leave  
 5e1:	c3                   	ret    

000005e2 <atoi>:

int
atoi(const char *s)
{
 5e2:	55                   	push   %ebp
 5e3:	89 e5                	mov    %esp,%ebp
 5e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 5e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 5ef:	eb 25                	jmp    616 <atoi+0x34>
    n = n*10 + *s++ - '0';
 5f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5f4:	89 d0                	mov    %edx,%eax
 5f6:	c1 e0 02             	shl    $0x2,%eax
 5f9:	01 d0                	add    %edx,%eax
 5fb:	01 c0                	add    %eax,%eax
 5fd:	89 c1                	mov    %eax,%ecx
 5ff:	8b 45 08             	mov    0x8(%ebp),%eax
 602:	8d 50 01             	lea    0x1(%eax),%edx
 605:	89 55 08             	mov    %edx,0x8(%ebp)
 608:	0f b6 00             	movzbl (%eax),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	01 c8                	add    %ecx,%eax
 610:	83 e8 30             	sub    $0x30,%eax
 613:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	0f b6 00             	movzbl (%eax),%eax
 61c:	3c 2f                	cmp    $0x2f,%al
 61e:	7e 0a                	jle    62a <atoi+0x48>
 620:	8b 45 08             	mov    0x8(%ebp),%eax
 623:	0f b6 00             	movzbl (%eax),%eax
 626:	3c 39                	cmp    $0x39,%al
 628:	7e c7                	jle    5f1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 62a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 62d:	c9                   	leave  
 62e:	c3                   	ret    

0000062f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 62f:	55                   	push   %ebp
 630:	89 e5                	mov    %esp,%ebp
 632:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 63b:	8b 45 0c             	mov    0xc(%ebp),%eax
 63e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 641:	eb 17                	jmp    65a <memmove+0x2b>
    *dst++ = *src++;
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8d 50 01             	lea    0x1(%eax),%edx
 649:	89 55 fc             	mov    %edx,-0x4(%ebp)
 64c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 64f:	8d 4a 01             	lea    0x1(%edx),%ecx
 652:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 655:	0f b6 12             	movzbl (%edx),%edx
 658:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 65a:	8b 45 10             	mov    0x10(%ebp),%eax
 65d:	8d 50 ff             	lea    -0x1(%eax),%edx
 660:	89 55 10             	mov    %edx,0x10(%ebp)
 663:	85 c0                	test   %eax,%eax
 665:	7f dc                	jg     643 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 667:	8b 45 08             	mov    0x8(%ebp),%eax
}
 66a:	c9                   	leave  
 66b:	c3                   	ret    

0000066c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 66c:	b8 01 00 00 00       	mov    $0x1,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <exit>:
SYSCALL(exit)
 674:	b8 02 00 00 00       	mov    $0x2,%eax
 679:	cd 40                	int    $0x40
 67b:	c3                   	ret    

0000067c <wait>:
SYSCALL(wait)
 67c:	b8 03 00 00 00       	mov    $0x3,%eax
 681:	cd 40                	int    $0x40
 683:	c3                   	ret    

00000684 <pipe>:
SYSCALL(pipe)
 684:	b8 04 00 00 00       	mov    $0x4,%eax
 689:	cd 40                	int    $0x40
 68b:	c3                   	ret    

0000068c <read>:
SYSCALL(read)
 68c:	b8 05 00 00 00       	mov    $0x5,%eax
 691:	cd 40                	int    $0x40
 693:	c3                   	ret    

00000694 <write>:
SYSCALL(write)
 694:	b8 10 00 00 00       	mov    $0x10,%eax
 699:	cd 40                	int    $0x40
 69b:	c3                   	ret    

0000069c <close>:
SYSCALL(close)
 69c:	b8 15 00 00 00       	mov    $0x15,%eax
 6a1:	cd 40                	int    $0x40
 6a3:	c3                   	ret    

000006a4 <kill>:
SYSCALL(kill)
 6a4:	b8 06 00 00 00       	mov    $0x6,%eax
 6a9:	cd 40                	int    $0x40
 6ab:	c3                   	ret    

000006ac <exec>:
SYSCALL(exec)
 6ac:	b8 07 00 00 00       	mov    $0x7,%eax
 6b1:	cd 40                	int    $0x40
 6b3:	c3                   	ret    

000006b4 <open>:
SYSCALL(open)
 6b4:	b8 0f 00 00 00       	mov    $0xf,%eax
 6b9:	cd 40                	int    $0x40
 6bb:	c3                   	ret    

000006bc <mknod>:
SYSCALL(mknod)
 6bc:	b8 11 00 00 00       	mov    $0x11,%eax
 6c1:	cd 40                	int    $0x40
 6c3:	c3                   	ret    

000006c4 <unlink>:
SYSCALL(unlink)
 6c4:	b8 12 00 00 00       	mov    $0x12,%eax
 6c9:	cd 40                	int    $0x40
 6cb:	c3                   	ret    

000006cc <fstat>:
SYSCALL(fstat)
 6cc:	b8 08 00 00 00       	mov    $0x8,%eax
 6d1:	cd 40                	int    $0x40
 6d3:	c3                   	ret    

000006d4 <link>:
SYSCALL(link)
 6d4:	b8 13 00 00 00       	mov    $0x13,%eax
 6d9:	cd 40                	int    $0x40
 6db:	c3                   	ret    

000006dc <mkdir>:
SYSCALL(mkdir)
 6dc:	b8 14 00 00 00       	mov    $0x14,%eax
 6e1:	cd 40                	int    $0x40
 6e3:	c3                   	ret    

000006e4 <chdir>:
SYSCALL(chdir)
 6e4:	b8 09 00 00 00       	mov    $0x9,%eax
 6e9:	cd 40                	int    $0x40
 6eb:	c3                   	ret    

000006ec <dup>:
SYSCALL(dup)
 6ec:	b8 0a 00 00 00       	mov    $0xa,%eax
 6f1:	cd 40                	int    $0x40
 6f3:	c3                   	ret    

000006f4 <getpid>:
SYSCALL(getpid)
 6f4:	b8 0b 00 00 00       	mov    $0xb,%eax
 6f9:	cd 40                	int    $0x40
 6fb:	c3                   	ret    

000006fc <sbrk>:
SYSCALL(sbrk)
 6fc:	b8 0c 00 00 00       	mov    $0xc,%eax
 701:	cd 40                	int    $0x40
 703:	c3                   	ret    

00000704 <sleep>:
SYSCALL(sleep)
 704:	b8 0d 00 00 00       	mov    $0xd,%eax
 709:	cd 40                	int    $0x40
 70b:	c3                   	ret    

0000070c <uptime>:
SYSCALL(uptime)
 70c:	b8 0e 00 00 00       	mov    $0xe,%eax
 711:	cd 40                	int    $0x40
 713:	c3                   	ret    

00000714 <halt>:
SYSCALL(halt)
 714:	b8 16 00 00 00       	mov    $0x16,%eax
 719:	cd 40                	int    $0x40
 71b:	c3                   	ret    

0000071c <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 71c:	b8 17 00 00 00       	mov    $0x17,%eax
 721:	cd 40                	int    $0x40
 723:	c3                   	ret    

00000724 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 724:	b8 18 00 00 00       	mov    $0x18,%eax
 729:	cd 40                	int    $0x40
 72b:	c3                   	ret    

0000072c <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 72c:	b8 19 00 00 00       	mov    $0x19,%eax
 731:	cd 40                	int    $0x40
 733:	c3                   	ret    

00000734 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 734:	b8 1a 00 00 00       	mov    $0x1a,%eax
 739:	cd 40                	int    $0x40
 73b:	c3                   	ret    

0000073c <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 73c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 741:	cd 40                	int    $0x40
 743:	c3                   	ret    

00000744 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 744:	b8 1c 00 00 00       	mov    $0x1c,%eax
 749:	cd 40                	int    $0x40
 74b:	c3                   	ret    

0000074c <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 74c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 751:	cd 40                	int    $0x40
 753:	c3                   	ret    

00000754 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 754:	b8 1b 00 00 00       	mov    $0x1b,%eax
 759:	cd 40                	int    $0x40
 75b:	c3                   	ret    

0000075c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 75c:	55                   	push   %ebp
 75d:	89 e5                	mov    %esp,%ebp
 75f:	83 ec 18             	sub    $0x18,%esp
 762:	8b 45 0c             	mov    0xc(%ebp),%eax
 765:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 768:	83 ec 04             	sub    $0x4,%esp
 76b:	6a 01                	push   $0x1
 76d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 770:	50                   	push   %eax
 771:	ff 75 08             	pushl  0x8(%ebp)
 774:	e8 1b ff ff ff       	call   694 <write>
 779:	83 c4 10             	add    $0x10,%esp
}
 77c:	90                   	nop
 77d:	c9                   	leave  
 77e:	c3                   	ret    

0000077f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 77f:	55                   	push   %ebp
 780:	89 e5                	mov    %esp,%ebp
 782:	53                   	push   %ebx
 783:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 786:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 78d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 791:	74 17                	je     7aa <printint+0x2b>
 793:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 797:	79 11                	jns    7aa <printint+0x2b>
    neg = 1;
 799:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a3:	f7 d8                	neg    %eax
 7a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7a8:	eb 06                	jmp    7b0 <printint+0x31>
  } else {
    x = xx;
 7aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7b7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7ba:	8d 41 01             	lea    0x1(%ecx),%eax
 7bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c6:	ba 00 00 00 00       	mov    $0x0,%edx
 7cb:	f7 f3                	div    %ebx
 7cd:	89 d0                	mov    %edx,%eax
 7cf:	0f b6 80 a8 11 00 00 	movzbl 0x11a8(%eax),%eax
 7d6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7da:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e0:	ba 00 00 00 00       	mov    $0x0,%edx
 7e5:	f7 f3                	div    %ebx
 7e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ee:	75 c7                	jne    7b7 <printint+0x38>
  if(neg)
 7f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f4:	74 2d                	je     823 <printint+0xa4>
    buf[i++] = '-';
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8d 50 01             	lea    0x1(%eax),%edx
 7fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7ff:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 804:	eb 1d                	jmp    823 <printint+0xa4>
    putc(fd, buf[i]);
 806:	8d 55 dc             	lea    -0x24(%ebp),%edx
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	01 d0                	add    %edx,%eax
 80e:	0f b6 00             	movzbl (%eax),%eax
 811:	0f be c0             	movsbl %al,%eax
 814:	83 ec 08             	sub    $0x8,%esp
 817:	50                   	push   %eax
 818:	ff 75 08             	pushl  0x8(%ebp)
 81b:	e8 3c ff ff ff       	call   75c <putc>
 820:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 823:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 827:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 82b:	79 d9                	jns    806 <printint+0x87>
    putc(fd, buf[i]);
}
 82d:	90                   	nop
 82e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 831:	c9                   	leave  
 832:	c3                   	ret    

00000833 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 833:	55                   	push   %ebp
 834:	89 e5                	mov    %esp,%ebp
 836:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 839:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 840:	8d 45 0c             	lea    0xc(%ebp),%eax
 843:	83 c0 04             	add    $0x4,%eax
 846:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 849:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 850:	e9 59 01 00 00       	jmp    9ae <printf+0x17b>
    c = fmt[i] & 0xff;
 855:	8b 55 0c             	mov    0xc(%ebp),%edx
 858:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85b:	01 d0                	add    %edx,%eax
 85d:	0f b6 00             	movzbl (%eax),%eax
 860:	0f be c0             	movsbl %al,%eax
 863:	25 ff 00 00 00       	and    $0xff,%eax
 868:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 86b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 86f:	75 2c                	jne    89d <printf+0x6a>
      if(c == '%'){
 871:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 875:	75 0c                	jne    883 <printf+0x50>
        state = '%';
 877:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 87e:	e9 27 01 00 00       	jmp    9aa <printf+0x177>
      } else {
        putc(fd, c);
 883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 886:	0f be c0             	movsbl %al,%eax
 889:	83 ec 08             	sub    $0x8,%esp
 88c:	50                   	push   %eax
 88d:	ff 75 08             	pushl  0x8(%ebp)
 890:	e8 c7 fe ff ff       	call   75c <putc>
 895:	83 c4 10             	add    $0x10,%esp
 898:	e9 0d 01 00 00       	jmp    9aa <printf+0x177>
      }
    } else if(state == '%'){
 89d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8a1:	0f 85 03 01 00 00    	jne    9aa <printf+0x177>
      if(c == 'd'){
 8a7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8ab:	75 1e                	jne    8cb <printf+0x98>
        printint(fd, *ap, 10, 1);
 8ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b0:	8b 00                	mov    (%eax),%eax
 8b2:	6a 01                	push   $0x1
 8b4:	6a 0a                	push   $0xa
 8b6:	50                   	push   %eax
 8b7:	ff 75 08             	pushl  0x8(%ebp)
 8ba:	e8 c0 fe ff ff       	call   77f <printint>
 8bf:	83 c4 10             	add    $0x10,%esp
        ap++;
 8c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c6:	e9 d8 00 00 00       	jmp    9a3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 8cb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8cf:	74 06                	je     8d7 <printf+0xa4>
 8d1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8d5:	75 1e                	jne    8f5 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 8d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8da:	8b 00                	mov    (%eax),%eax
 8dc:	6a 00                	push   $0x0
 8de:	6a 10                	push   $0x10
 8e0:	50                   	push   %eax
 8e1:	ff 75 08             	pushl  0x8(%ebp)
 8e4:	e8 96 fe ff ff       	call   77f <printint>
 8e9:	83 c4 10             	add    $0x10,%esp
        ap++;
 8ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8f0:	e9 ae 00 00 00       	jmp    9a3 <printf+0x170>
      } else if(c == 's'){
 8f5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8f9:	75 43                	jne    93e <printf+0x10b>
        s = (char*)*ap;
 8fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8fe:	8b 00                	mov    (%eax),%eax
 900:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 903:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90b:	75 25                	jne    932 <printf+0xff>
          s = "(null)";
 90d:	c7 45 f4 b4 0e 00 00 	movl   $0xeb4,-0xc(%ebp)
        while(*s != 0){
 914:	eb 1c                	jmp    932 <printf+0xff>
          putc(fd, *s);
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	0f b6 00             	movzbl (%eax),%eax
 91c:	0f be c0             	movsbl %al,%eax
 91f:	83 ec 08             	sub    $0x8,%esp
 922:	50                   	push   %eax
 923:	ff 75 08             	pushl  0x8(%ebp)
 926:	e8 31 fe ff ff       	call   75c <putc>
 92b:	83 c4 10             	add    $0x10,%esp
          s++;
 92e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	0f b6 00             	movzbl (%eax),%eax
 938:	84 c0                	test   %al,%al
 93a:	75 da                	jne    916 <printf+0xe3>
 93c:	eb 65                	jmp    9a3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 93e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 942:	75 1d                	jne    961 <printf+0x12e>
        putc(fd, *ap);
 944:	8b 45 e8             	mov    -0x18(%ebp),%eax
 947:	8b 00                	mov    (%eax),%eax
 949:	0f be c0             	movsbl %al,%eax
 94c:	83 ec 08             	sub    $0x8,%esp
 94f:	50                   	push   %eax
 950:	ff 75 08             	pushl  0x8(%ebp)
 953:	e8 04 fe ff ff       	call   75c <putc>
 958:	83 c4 10             	add    $0x10,%esp
        ap++;
 95b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 95f:	eb 42                	jmp    9a3 <printf+0x170>
      } else if(c == '%'){
 961:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 965:	75 17                	jne    97e <printf+0x14b>
        putc(fd, c);
 967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 96a:	0f be c0             	movsbl %al,%eax
 96d:	83 ec 08             	sub    $0x8,%esp
 970:	50                   	push   %eax
 971:	ff 75 08             	pushl  0x8(%ebp)
 974:	e8 e3 fd ff ff       	call   75c <putc>
 979:	83 c4 10             	add    $0x10,%esp
 97c:	eb 25                	jmp    9a3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 97e:	83 ec 08             	sub    $0x8,%esp
 981:	6a 25                	push   $0x25
 983:	ff 75 08             	pushl  0x8(%ebp)
 986:	e8 d1 fd ff ff       	call   75c <putc>
 98b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 98e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 991:	0f be c0             	movsbl %al,%eax
 994:	83 ec 08             	sub    $0x8,%esp
 997:	50                   	push   %eax
 998:	ff 75 08             	pushl  0x8(%ebp)
 99b:	e8 bc fd ff ff       	call   75c <putc>
 9a0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9aa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 9b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b4:	01 d0                	add    %edx,%eax
 9b6:	0f b6 00             	movzbl (%eax),%eax
 9b9:	84 c0                	test   %al,%al
 9bb:	0f 85 94 fe ff ff    	jne    855 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9c1:	90                   	nop
 9c2:	c9                   	leave  
 9c3:	c3                   	ret    

000009c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9c4:	55                   	push   %ebp
 9c5:	89 e5                	mov    %esp,%ebp
 9c7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9ca:	8b 45 08             	mov    0x8(%ebp),%eax
 9cd:	83 e8 08             	sub    $0x8,%eax
 9d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d3:	a1 c4 11 00 00       	mov    0x11c4,%eax
 9d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9db:	eb 24                	jmp    a01 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e0:	8b 00                	mov    (%eax),%eax
 9e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9e5:	77 12                	ja     9f9 <free+0x35>
 9e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9ed:	77 24                	ja     a13 <free+0x4f>
 9ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f2:	8b 00                	mov    (%eax),%eax
 9f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9f7:	77 1a                	ja     a13 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fc:	8b 00                	mov    (%eax),%eax
 9fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a01:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a04:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a07:	76 d4                	jbe    9dd <free+0x19>
 a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0c:	8b 00                	mov    (%eax),%eax
 a0e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a11:	76 ca                	jbe    9dd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a13:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a16:	8b 40 04             	mov    0x4(%eax),%eax
 a19:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a20:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a23:	01 c2                	add    %eax,%edx
 a25:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a28:	8b 00                	mov    (%eax),%eax
 a2a:	39 c2                	cmp    %eax,%edx
 a2c:	75 24                	jne    a52 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a31:	8b 50 04             	mov    0x4(%eax),%edx
 a34:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a37:	8b 00                	mov    (%eax),%eax
 a39:	8b 40 04             	mov    0x4(%eax),%eax
 a3c:	01 c2                	add    %eax,%edx
 a3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a41:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a47:	8b 00                	mov    (%eax),%eax
 a49:	8b 10                	mov    (%eax),%edx
 a4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4e:	89 10                	mov    %edx,(%eax)
 a50:	eb 0a                	jmp    a5c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a55:	8b 10                	mov    (%eax),%edx
 a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5f:	8b 40 04             	mov    0x4(%eax),%eax
 a62:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6c:	01 d0                	add    %edx,%eax
 a6e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a71:	75 20                	jne    a93 <free+0xcf>
    p->s.size += bp->s.size;
 a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a76:	8b 50 04             	mov    0x4(%eax),%edx
 a79:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a7c:	8b 40 04             	mov    0x4(%eax),%eax
 a7f:	01 c2                	add    %eax,%edx
 a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a84:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a87:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a8a:	8b 10                	mov    (%eax),%edx
 a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8f:	89 10                	mov    %edx,(%eax)
 a91:	eb 08                	jmp    a9b <free+0xd7>
  } else
    p->s.ptr = bp;
 a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a96:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a99:	89 10                	mov    %edx,(%eax)
  freep = p;
 a9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9e:	a3 c4 11 00 00       	mov    %eax,0x11c4
}
 aa3:	90                   	nop
 aa4:	c9                   	leave  
 aa5:	c3                   	ret    

00000aa6 <morecore>:

static Header*
morecore(uint nu)
{
 aa6:	55                   	push   %ebp
 aa7:	89 e5                	mov    %esp,%ebp
 aa9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 aac:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 ab3:	77 07                	ja     abc <morecore+0x16>
    nu = 4096;
 ab5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 abc:	8b 45 08             	mov    0x8(%ebp),%eax
 abf:	c1 e0 03             	shl    $0x3,%eax
 ac2:	83 ec 0c             	sub    $0xc,%esp
 ac5:	50                   	push   %eax
 ac6:	e8 31 fc ff ff       	call   6fc <sbrk>
 acb:	83 c4 10             	add    $0x10,%esp
 ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 ad1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 ad5:	75 07                	jne    ade <morecore+0x38>
    return 0;
 ad7:	b8 00 00 00 00       	mov    $0x0,%eax
 adc:	eb 26                	jmp    b04 <morecore+0x5e>
  hp = (Header*)p;
 ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae7:	8b 55 08             	mov    0x8(%ebp),%edx
 aea:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af0:	83 c0 08             	add    $0x8,%eax
 af3:	83 ec 0c             	sub    $0xc,%esp
 af6:	50                   	push   %eax
 af7:	e8 c8 fe ff ff       	call   9c4 <free>
 afc:	83 c4 10             	add    $0x10,%esp
  return freep;
 aff:	a1 c4 11 00 00       	mov    0x11c4,%eax
}
 b04:	c9                   	leave  
 b05:	c3                   	ret    

00000b06 <malloc>:

void*
malloc(uint nbytes)
{
 b06:	55                   	push   %ebp
 b07:	89 e5                	mov    %esp,%ebp
 b09:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b0c:	8b 45 08             	mov    0x8(%ebp),%eax
 b0f:	83 c0 07             	add    $0x7,%eax
 b12:	c1 e8 03             	shr    $0x3,%eax
 b15:	83 c0 01             	add    $0x1,%eax
 b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b1b:	a1 c4 11 00 00       	mov    0x11c4,%eax
 b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b27:	75 23                	jne    b4c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b29:	c7 45 f0 bc 11 00 00 	movl   $0x11bc,-0x10(%ebp)
 b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b33:	a3 c4 11 00 00       	mov    %eax,0x11c4
 b38:	a1 c4 11 00 00       	mov    0x11c4,%eax
 b3d:	a3 bc 11 00 00       	mov    %eax,0x11bc
    base.s.size = 0;
 b42:	c7 05 c0 11 00 00 00 	movl   $0x0,0x11c0
 b49:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4f:	8b 00                	mov    (%eax),%eax
 b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b57:	8b 40 04             	mov    0x4(%eax),%eax
 b5a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b5d:	72 4d                	jb     bac <malloc+0xa6>
      if(p->s.size == nunits)
 b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b62:	8b 40 04             	mov    0x4(%eax),%eax
 b65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b68:	75 0c                	jne    b76 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b6d:	8b 10                	mov    (%eax),%edx
 b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b72:	89 10                	mov    %edx,(%eax)
 b74:	eb 26                	jmp    b9c <malloc+0x96>
      else {
        p->s.size -= nunits;
 b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b79:	8b 40 04             	mov    0x4(%eax),%eax
 b7c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b7f:	89 c2                	mov    %eax,%edx
 b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b84:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b8a:	8b 40 04             	mov    0x4(%eax),%eax
 b8d:	c1 e0 03             	shl    $0x3,%eax
 b90:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b96:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b99:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b9f:	a3 c4 11 00 00       	mov    %eax,0x11c4
      return (void*)(p + 1);
 ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba7:	83 c0 08             	add    $0x8,%eax
 baa:	eb 3b                	jmp    be7 <malloc+0xe1>
    }
    if(p == freep)
 bac:	a1 c4 11 00 00       	mov    0x11c4,%eax
 bb1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bb4:	75 1e                	jne    bd4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 bb6:	83 ec 0c             	sub    $0xc,%esp
 bb9:	ff 75 ec             	pushl  -0x14(%ebp)
 bbc:	e8 e5 fe ff ff       	call   aa6 <morecore>
 bc1:	83 c4 10             	add    $0x10,%esp
 bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bcb:	75 07                	jne    bd4 <malloc+0xce>
        return 0;
 bcd:	b8 00 00 00 00       	mov    $0x0,%eax
 bd2:	eb 13                	jmp    be7 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bdd:	8b 00                	mov    (%eax),%eax
 bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 be2:	e9 6d ff ff ff       	jmp    b54 <malloc+0x4e>
}
 be7:	c9                   	leave  
 be8:	c3                   	ret    
