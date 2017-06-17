
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
   6:	e8 a7 07 00 00       	call   7b2 <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "Current UID is: %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 90 0c 00 00       	push   $0xc90
  19:	6a 01                	push   $0x1
  1b:	e8 b9 08 00 00       	call   8d9 <printf>
  20:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to %d\n", nval);
  23:	83 ec 04             	sub    $0x4,%esp
  26:	ff 75 08             	pushl  0x8(%ebp)
  29:	68 a4 0c 00 00       	push   $0xca4
  2e:	6a 01                	push   $0x1
  30:	e8 a4 08 00 00       	call   8d9 <printf>
  35:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	ff 75 08             	pushl  0x8(%ebp)
  3e:	e8 87 07 00 00       	call   7ca <setuid>
  43:	83 c4 10             	add    $0x10,%esp
  46:	85 c0                	test   %eax,%eax
  48:	79 15                	jns    5f <uidTest+0x5f>
    printf(2, "Error. Invalid UID: %d\n", nval);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 08             	pushl  0x8(%ebp)
  50:	68 b7 0c 00 00       	push   $0xcb7
  55:	6a 02                	push   $0x2
  57:	e8 7d 08 00 00       	call   8d9 <printf>
  5c:	83 c4 10             	add    $0x10,%esp

  uid = getuid();
  5f:	e8 4e 07 00 00       	call   7b2 <getuid>
  64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  67:	83 ec 04             	sub    $0x4,%esp
  6a:	ff 75 f4             	pushl  -0xc(%ebp)
  6d:	68 90 0c 00 00       	push   $0xc90
  72:	6a 01                	push   $0x1
  74:	e8 60 08 00 00       	call   8d9 <printf>
  79:	83 c4 10             	add    $0x10,%esp

  printf(1, "Sleeping...\n");
  7c:	83 ec 08             	sub    $0x8,%esp
  7f:	68 cf 0c 00 00       	push   $0xccf
  84:	6a 01                	push   $0x1
  86:	e8 4e 08 00 00       	call   8d9 <printf>
  8b:	83 c4 10             	add    $0x10,%esp
  sleep(500); // now type control-p
  8e:	83 ec 0c             	sub    $0xc,%esp
  91:	68 f4 01 00 00       	push   $0x1f4
  96:	e8 f7 06 00 00       	call   792 <sleep>
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
  a7:	e8 0e 07 00 00       	call   7ba <getgid>
  ac:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "Current GID is: %d\n", gid);
  af:	83 ec 04             	sub    $0x4,%esp
  b2:	ff 75 f4             	pushl  -0xc(%ebp)
  b5:	68 dc 0c 00 00       	push   $0xcdc
  ba:	6a 01                	push   $0x1
  bc:	e8 18 08 00 00       	call   8d9 <printf>
  c1:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to %d\n", nval);
  c4:	83 ec 04             	sub    $0x4,%esp
  c7:	ff 75 08             	pushl  0x8(%ebp)
  ca:	68 f0 0c 00 00       	push   $0xcf0
  cf:	6a 01                	push   $0x1
  d1:	e8 03 08 00 00       	call   8d9 <printf>
  d6:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 08             	pushl  0x8(%ebp)
  df:	e8 ee 06 00 00       	call   7d2 <setgid>
  e4:	83 c4 10             	add    $0x10,%esp
  e7:	85 c0                	test   %eax,%eax
  e9:	79 15                	jns    100 <gidTest+0x5f>
    printf(2, "Error. Invalid GID: %d\n", nval);
  eb:	83 ec 04             	sub    $0x4,%esp
  ee:	ff 75 08             	pushl  0x8(%ebp)
  f1:	68 03 0d 00 00       	push   $0xd03
  f6:	6a 02                	push   $0x2
  f8:	e8 dc 07 00 00       	call   8d9 <printf>
  fd:	83 c4 10             	add    $0x10,%esp

  gid = getgid();
 100:	e8 b5 06 00 00       	call   7ba <getgid>
 105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 108:	83 ec 04             	sub    $0x4,%esp
 10b:	ff 75 f4             	pushl  -0xc(%ebp)
 10e:	68 dc 0c 00 00       	push   $0xcdc
 113:	6a 01                	push   $0x1
 115:	e8 bf 07 00 00       	call   8d9 <printf>
 11a:	83 c4 10             	add    $0x10,%esp

  printf(1, "Sleeping...\n");
 11d:	83 ec 08             	sub    $0x8,%esp
 120:	68 cf 0c 00 00       	push   $0xccf
 125:	6a 01                	push   $0x1
 127:	e8 ad 07 00 00       	call   8d9 <printf>
 12c:	83 c4 10             	add    $0x10,%esp
  sleep(500); // now type control-p
 12f:	83 ec 0c             	sub    $0xc,%esp
 132:	68 f4 01 00 00       	push   $0x1f4
 137:	e8 56 06 00 00       	call   792 <sleep>
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
 14f:	68 1c 0d 00 00       	push   $0xd1c
 154:	6a 01                	push   $0x1
 156:	e8 7e 07 00 00       	call   8d9 <printf>
 15b:	83 c4 10             	add    $0x10,%esp
  	          " should be inherited\n", nval, nval);

  if (setuid(nval) < 0)
 15e:	83 ec 0c             	sub    $0xc,%esp
 161:	ff 75 08             	pushl  0x8(%ebp)
 164:	e8 61 06 00 00       	call   7ca <setuid>
 169:	83 c4 10             	add    $0x10,%esp
 16c:	85 c0                	test   %eax,%eax
 16e:	79 15                	jns    185 <forkTest+0x43>
    printf(2, "Error. Invalid UID: %d\n", nval);
 170:	83 ec 04             	sub    $0x4,%esp
 173:	ff 75 08             	pushl  0x8(%ebp)
 176:	68 b7 0c 00 00       	push   $0xcb7
 17b:	6a 02                	push   $0x2
 17d:	e8 57 07 00 00       	call   8d9 <printf>
 182:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 185:	83 ec 0c             	sub    $0xc,%esp
 188:	ff 75 08             	pushl  0x8(%ebp)
 18b:	e8 42 06 00 00       	call   7d2 <setgid>
 190:	83 c4 10             	add    $0x10,%esp
 193:	85 c0                	test   %eax,%eax
 195:	79 15                	jns    1ac <forkTest+0x6a>
    printf(2, "Error. Invalid GID: %d\n", nval);
 197:	83 ec 04             	sub    $0x4,%esp
 19a:	ff 75 08             	pushl  0x8(%ebp)
 19d:	68 03 0d 00 00       	push   $0xd03
 1a2:	6a 02                	push   $0x2
 1a4:	e8 30 07 00 00       	call   8d9 <printf>
 1a9:	83 c4 10             	add    $0x10,%esp

  printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getgid());
 1ac:	e8 09 06 00 00       	call   7ba <getgid>
 1b1:	89 c3                	mov    %eax,%ebx
 1b3:	e8 fa 05 00 00       	call   7b2 <getuid>
 1b8:	53                   	push   %ebx
 1b9:	50                   	push   %eax
 1ba:	68 68 0d 00 00       	push   $0xd68
 1bf:	6a 01                	push   $0x1
 1c1:	e8 13 07 00 00       	call   8d9 <printf>
 1c6:	83 c4 10             	add    $0x10,%esp

  pid = fork();
 1c9:	e8 2c 05 00 00       	call   6fa <fork>
 1ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (pid == 0) { // child
 1d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d5:	75 4c                	jne    223 <forkTest+0xe1>
    uid = getuid();
 1d7:	e8 d6 05 00 00       	call   7b2 <getuid>
 1dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    gid = getgid();
 1df:	e8 d6 05 00 00       	call   7ba <getgid>
 1e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1, "Child: UID is: %d, GID = %d\n", uid, gid);
 1e7:	ff 75 ec             	pushl  -0x14(%ebp)
 1ea:	ff 75 f0             	pushl  -0x10(%ebp)
 1ed:	68 8b 0d 00 00       	push   $0xd8b
 1f2:	6a 01                	push   $0x1
 1f4:	e8 e0 06 00 00       	call   8d9 <printf>
 1f9:	83 c4 10             	add    $0x10,%esp

    printf(1, "Sleeping...\n");
 1fc:	83 ec 08             	sub    $0x8,%esp
 1ff:	68 cf 0c 00 00       	push   $0xccf
 204:	6a 01                	push   $0x1
 206:	e8 ce 06 00 00       	call   8d9 <printf>
 20b:	83 c4 10             	add    $0x10,%esp
    sleep(500); // now type control-p
 20e:	83 ec 0c             	sub    $0xc,%esp
 211:	68 f4 01 00 00       	push   $0x1f4
 216:	e8 77 05 00 00       	call   792 <sleep>
 21b:	83 c4 10             	add    $0x10,%esp

    exit();
 21e:	e8 df 04 00 00       	call   702 <exit>
  }
  else
    sleep(1000); // wait for child to exit before proceeding
 223:	83 ec 0c             	sub    $0xc,%esp
 226:	68 e8 03 00 00       	push   $0x3e8
 22b:	e8 62 05 00 00       	call   792 <sleep>
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
 245:	68 a8 0d 00 00       	push   $0xda8
 24a:	6a 01                	push   $0x1
 24c:	e8 88 06 00 00       	call   8d9 <printf>
 251:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
 254:	83 ec 0c             	sub    $0xc,%esp
 257:	ff 75 08             	pushl  0x8(%ebp)
 25a:	e8 6b 05 00 00       	call   7ca <setuid>
 25f:	83 c4 10             	add    $0x10,%esp
 262:	85 c0                	test   %eax,%eax
 264:	79 14                	jns    27a <invalidTest+0x41>
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
 266:	83 ec 08             	sub    $0x8,%esp
 269:	68 d4 0d 00 00       	push   $0xdd4
 26e:	6a 01                	push   $0x1
 270:	e8 64 06 00 00       	call   8d9 <printf>
 275:	83 c4 10             	add    $0x10,%esp
 278:	eb 12                	jmp    28c <invalidTest+0x53>
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");
 27a:	83 ec 08             	sub    $0x8,%esp
 27d:	68 08 0e 00 00       	push   $0xe08
 282:	6a 02                	push   $0x2
 284:	e8 50 06 00 00       	call   8d9 <printf>
 289:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", nval);
 28c:	83 ec 04             	sub    $0x4,%esp
 28f:	ff 75 08             	pushl  0x8(%ebp)
 292:	68 3c 0e 00 00       	push   $0xe3c
 297:	6a 01                	push   $0x1
 299:	e8 3b 06 00 00       	call   8d9 <printf>
 29e:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 2a1:	83 ec 0c             	sub    $0xc,%esp
 2a4:	ff 75 08             	pushl  0x8(%ebp)
 2a7:	e8 26 05 00 00       	call   7d2 <setgid>
 2ac:	83 c4 10             	add    $0x10,%esp
 2af:	85 c0                	test   %eax,%eax
 2b1:	79 14                	jns    2c7 <invalidTest+0x8e>
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
 2b3:	83 ec 08             	sub    $0x8,%esp
 2b6:	68 68 0e 00 00       	push   $0xe68
 2bb:	6a 01                	push   $0x1
 2bd:	e8 17 06 00 00       	call   8d9 <printf>
 2c2:	83 c4 10             	add    $0x10,%esp
 2c5:	eb 12                	jmp    2d9 <invalidTest+0xa0>
  else
    printf(2, "FAILURE! The setgid system call indicates success\n");
 2c7:	83 ec 08             	sub    $0x8,%esp
 2ca:	68 9c 0e 00 00       	push   $0xe9c
 2cf:	6a 02                	push   $0x2
 2d1:	e8 03 06 00 00       	call   8d9 <printf>
 2d6:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting UID to %d. This test should FAIL\n", -1);
 2d9:	83 ec 04             	sub    $0x4,%esp
 2dc:	6a ff                	push   $0xffffffff
 2de:	68 a8 0d 00 00       	push   $0xda8
 2e3:	6a 01                	push   $0x1
 2e5:	e8 ef 05 00 00       	call   8d9 <printf>
 2ea:	83 c4 10             	add    $0x10,%esp
  if (setuid(-1) < 0)
 2ed:	83 ec 0c             	sub    $0xc,%esp
 2f0:	6a ff                	push   $0xffffffff
 2f2:	e8 d3 04 00 00       	call   7ca <setuid>
 2f7:	83 c4 10             	add    $0x10,%esp
 2fa:	85 c0                	test   %eax,%eax
 2fc:	79 14                	jns    312 <invalidTest+0xd9>
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
 2fe:	83 ec 08             	sub    $0x8,%esp
 301:	68 d4 0d 00 00       	push   $0xdd4
 306:	6a 01                	push   $0x1
 308:	e8 cc 05 00 00       	call   8d9 <printf>
 30d:	83 c4 10             	add    $0x10,%esp
 310:	eb 12                	jmp    324 <invalidTest+0xeb>
  else
    printf(2, "FAILURE! The setuid system call indicated success\n");
 312:	83 ec 08             	sub    $0x8,%esp
 315:	68 d0 0e 00 00       	push   $0xed0
 31a:	6a 02                	push   $0x2
 31c:	e8 b8 05 00 00       	call   8d9 <printf>
 321:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", -1);
 324:	83 ec 04             	sub    $0x4,%esp
 327:	6a ff                	push   $0xffffffff
 329:	68 3c 0e 00 00       	push   $0xe3c
 32e:	6a 01                	push   $0x1
 330:	e8 a4 05 00 00       	call   8d9 <printf>
 335:	83 c4 10             	add    $0x10,%esp
  if (setgid(-1) < 0)
 338:	83 ec 0c             	sub    $0xc,%esp
 33b:	6a ff                	push   $0xffffffff
 33d:	e8 90 04 00 00       	call   7d2 <setgid>
 342:	83 c4 10             	add    $0x10,%esp
 345:	85 c0                	test   %eax,%eax
 347:	79 14                	jns    35d <invalidTest+0x124>
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
 349:	83 ec 08             	sub    $0x8,%esp
 34c:	68 68 0e 00 00       	push   $0xe68
 351:	6a 01                	push   $0x1
 353:	e8 81 05 00 00       	call   8d9 <printf>
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
 360:	68 04 0f 00 00       	push   $0xf04
 365:	6a 02                	push   $0x2
 367:	e8 6d 05 00 00       	call   8d9 <printf>
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
 3a2:	e8 1b 04 00 00       	call   7c2 <getppid>
 3a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "My parent process is: %d\n", ppid);
 3aa:	83 ec 04             	sub    $0x4,%esp
 3ad:	ff 75 f0             	pushl  -0x10(%ebp)
 3b0:	68 37 0f 00 00       	push   $0xf37
 3b5:	6a 01                	push   $0x1
 3b7:	e8 1d 05 00 00       	call   8d9 <printf>
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
 3ec:	68 51 0f 00 00       	push   $0xf51
 3f1:	6a 01                	push   $0x1
 3f3:	e8 e1 04 00 00       	call   8d9 <printf>
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
 418:	e8 e5 02 00 00       	call   702 <exit>

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
 540:	e8 d5 01 00 00       	call   71a <read>
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
 5a3:	e8 9a 01 00 00       	call   742 <open>
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
 5c4:	e8 91 01 00 00       	call   75a <fstat>
 5c9:	83 c4 10             	add    $0x10,%esp
 5cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 5cf:	83 ec 0c             	sub    $0xc,%esp
 5d2:	ff 75 f4             	pushl  -0xc(%ebp)
 5d5:	e8 50 01 00 00       	call   72a <close>
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

0000066c <atoo>:

int
atoo(const char *s)
{
 66c:	55                   	push   %ebp
 66d:	89 e5                	mov    %esp,%ebp
 66f:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 672:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 679:	eb 04                	jmp    67f <atoo+0x13>
 67b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	0f b6 00             	movzbl (%eax),%eax
 685:	3c 20                	cmp    $0x20,%al
 687:	74 f2                	je     67b <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 689:	8b 45 08             	mov    0x8(%ebp),%eax
 68c:	0f b6 00             	movzbl (%eax),%eax
 68f:	3c 2d                	cmp    $0x2d,%al
 691:	75 07                	jne    69a <atoo+0x2e>
 693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 698:	eb 05                	jmp    69f <atoo+0x33>
 69a:	b8 01 00 00 00       	mov    $0x1,%eax
 69f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 6a2:	8b 45 08             	mov    0x8(%ebp),%eax
 6a5:	0f b6 00             	movzbl (%eax),%eax
 6a8:	3c 2b                	cmp    $0x2b,%al
 6aa:	74 0a                	je     6b6 <atoo+0x4a>
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	0f b6 00             	movzbl (%eax),%eax
 6b2:	3c 2d                	cmp    $0x2d,%al
 6b4:	75 27                	jne    6dd <atoo+0x71>
    s++;
 6b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 6ba:	eb 21                	jmp    6dd <atoo+0x71>
    n = n*8 + *s++ - '0';
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 6c6:	8b 45 08             	mov    0x8(%ebp),%eax
 6c9:	8d 50 01             	lea    0x1(%eax),%edx
 6cc:	89 55 08             	mov    %edx,0x8(%ebp)
 6cf:	0f b6 00             	movzbl (%eax),%eax
 6d2:	0f be c0             	movsbl %al,%eax
 6d5:	01 c8                	add    %ecx,%eax
 6d7:	83 e8 30             	sub    $0x30,%eax
 6da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 6dd:	8b 45 08             	mov    0x8(%ebp),%eax
 6e0:	0f b6 00             	movzbl (%eax),%eax
 6e3:	3c 2f                	cmp    $0x2f,%al
 6e5:	7e 0a                	jle    6f1 <atoo+0x85>
 6e7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ea:	0f b6 00             	movzbl (%eax),%eax
 6ed:	3c 37                	cmp    $0x37,%al
 6ef:	7e cb                	jle    6bc <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 6f8:	c9                   	leave  
 6f9:	c3                   	ret    

000006fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6fa:	b8 01 00 00 00       	mov    $0x1,%eax
 6ff:	cd 40                	int    $0x40
 701:	c3                   	ret    

00000702 <exit>:
SYSCALL(exit)
 702:	b8 02 00 00 00       	mov    $0x2,%eax
 707:	cd 40                	int    $0x40
 709:	c3                   	ret    

0000070a <wait>:
SYSCALL(wait)
 70a:	b8 03 00 00 00       	mov    $0x3,%eax
 70f:	cd 40                	int    $0x40
 711:	c3                   	ret    

00000712 <pipe>:
SYSCALL(pipe)
 712:	b8 04 00 00 00       	mov    $0x4,%eax
 717:	cd 40                	int    $0x40
 719:	c3                   	ret    

0000071a <read>:
SYSCALL(read)
 71a:	b8 05 00 00 00       	mov    $0x5,%eax
 71f:	cd 40                	int    $0x40
 721:	c3                   	ret    

00000722 <write>:
SYSCALL(write)
 722:	b8 10 00 00 00       	mov    $0x10,%eax
 727:	cd 40                	int    $0x40
 729:	c3                   	ret    

0000072a <close>:
SYSCALL(close)
 72a:	b8 15 00 00 00       	mov    $0x15,%eax
 72f:	cd 40                	int    $0x40
 731:	c3                   	ret    

00000732 <kill>:
SYSCALL(kill)
 732:	b8 06 00 00 00       	mov    $0x6,%eax
 737:	cd 40                	int    $0x40
 739:	c3                   	ret    

0000073a <exec>:
SYSCALL(exec)
 73a:	b8 07 00 00 00       	mov    $0x7,%eax
 73f:	cd 40                	int    $0x40
 741:	c3                   	ret    

00000742 <open>:
SYSCALL(open)
 742:	b8 0f 00 00 00       	mov    $0xf,%eax
 747:	cd 40                	int    $0x40
 749:	c3                   	ret    

0000074a <mknod>:
SYSCALL(mknod)
 74a:	b8 11 00 00 00       	mov    $0x11,%eax
 74f:	cd 40                	int    $0x40
 751:	c3                   	ret    

00000752 <unlink>:
SYSCALL(unlink)
 752:	b8 12 00 00 00       	mov    $0x12,%eax
 757:	cd 40                	int    $0x40
 759:	c3                   	ret    

0000075a <fstat>:
SYSCALL(fstat)
 75a:	b8 08 00 00 00       	mov    $0x8,%eax
 75f:	cd 40                	int    $0x40
 761:	c3                   	ret    

00000762 <link>:
SYSCALL(link)
 762:	b8 13 00 00 00       	mov    $0x13,%eax
 767:	cd 40                	int    $0x40
 769:	c3                   	ret    

0000076a <mkdir>:
SYSCALL(mkdir)
 76a:	b8 14 00 00 00       	mov    $0x14,%eax
 76f:	cd 40                	int    $0x40
 771:	c3                   	ret    

00000772 <chdir>:
SYSCALL(chdir)
 772:	b8 09 00 00 00       	mov    $0x9,%eax
 777:	cd 40                	int    $0x40
 779:	c3                   	ret    

0000077a <dup>:
SYSCALL(dup)
 77a:	b8 0a 00 00 00       	mov    $0xa,%eax
 77f:	cd 40                	int    $0x40
 781:	c3                   	ret    

00000782 <getpid>:
SYSCALL(getpid)
 782:	b8 0b 00 00 00       	mov    $0xb,%eax
 787:	cd 40                	int    $0x40
 789:	c3                   	ret    

0000078a <sbrk>:
SYSCALL(sbrk)
 78a:	b8 0c 00 00 00       	mov    $0xc,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <sleep>:
SYSCALL(sleep)
 792:	b8 0d 00 00 00       	mov    $0xd,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <uptime>:
SYSCALL(uptime)
 79a:	b8 0e 00 00 00       	mov    $0xe,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <halt>:
SYSCALL(halt)
 7a2:	b8 16 00 00 00       	mov    $0x16,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 7aa:	b8 17 00 00 00       	mov    $0x17,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 7b2:	b8 18 00 00 00       	mov    $0x18,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 7ba:	b8 19 00 00 00       	mov    $0x19,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 7c2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 7ca:	b8 1b 00 00 00       	mov    $0x1b,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 7d2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 7da:	b8 1d 00 00 00       	mov    $0x1d,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 7e2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 7ea:	b8 1f 00 00 00       	mov    $0x1f,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 7f2:	b8 20 00 00 00       	mov    $0x20,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 7fa:	b8 21 00 00 00       	mov    $0x21,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 802:	55                   	push   %ebp
 803:	89 e5                	mov    %esp,%ebp
 805:	83 ec 18             	sub    $0x18,%esp
 808:	8b 45 0c             	mov    0xc(%ebp),%eax
 80b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 80e:	83 ec 04             	sub    $0x4,%esp
 811:	6a 01                	push   $0x1
 813:	8d 45 f4             	lea    -0xc(%ebp),%eax
 816:	50                   	push   %eax
 817:	ff 75 08             	pushl  0x8(%ebp)
 81a:	e8 03 ff ff ff       	call   722 <write>
 81f:	83 c4 10             	add    $0x10,%esp
}
 822:	90                   	nop
 823:	c9                   	leave  
 824:	c3                   	ret    

00000825 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 825:	55                   	push   %ebp
 826:	89 e5                	mov    %esp,%ebp
 828:	53                   	push   %ebx
 829:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 82c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 833:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 837:	74 17                	je     850 <printint+0x2b>
 839:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 83d:	79 11                	jns    850 <printint+0x2b>
    neg = 1;
 83f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 846:	8b 45 0c             	mov    0xc(%ebp),%eax
 849:	f7 d8                	neg    %eax
 84b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 84e:	eb 06                	jmp    856 <printint+0x31>
  } else {
    x = xx;
 850:	8b 45 0c             	mov    0xc(%ebp),%eax
 853:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 85d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 860:	8d 41 01             	lea    0x1(%ecx),%eax
 863:	89 45 f4             	mov    %eax,-0xc(%ebp)
 866:	8b 5d 10             	mov    0x10(%ebp),%ebx
 869:	8b 45 ec             	mov    -0x14(%ebp),%eax
 86c:	ba 00 00 00 00       	mov    $0x0,%edx
 871:	f7 f3                	div    %ebx
 873:	89 d0                	mov    %edx,%eax
 875:	0f b6 80 6c 12 00 00 	movzbl 0x126c(%eax),%eax
 87c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 880:	8b 5d 10             	mov    0x10(%ebp),%ebx
 883:	8b 45 ec             	mov    -0x14(%ebp),%eax
 886:	ba 00 00 00 00       	mov    $0x0,%edx
 88b:	f7 f3                	div    %ebx
 88d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 890:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 894:	75 c7                	jne    85d <printint+0x38>
  if(neg)
 896:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 89a:	74 2d                	je     8c9 <printint+0xa4>
    buf[i++] = '-';
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	8d 50 01             	lea    0x1(%eax),%edx
 8a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8a5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8aa:	eb 1d                	jmp    8c9 <printint+0xa4>
    putc(fd, buf[i]);
 8ac:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	01 d0                	add    %edx,%eax
 8b4:	0f b6 00             	movzbl (%eax),%eax
 8b7:	0f be c0             	movsbl %al,%eax
 8ba:	83 ec 08             	sub    $0x8,%esp
 8bd:	50                   	push   %eax
 8be:	ff 75 08             	pushl  0x8(%ebp)
 8c1:	e8 3c ff ff ff       	call   802 <putc>
 8c6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 8c9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 8cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d1:	79 d9                	jns    8ac <printint+0x87>
    putc(fd, buf[i]);
}
 8d3:	90                   	nop
 8d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8d7:	c9                   	leave  
 8d8:	c3                   	ret    

000008d9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 8d9:	55                   	push   %ebp
 8da:	89 e5                	mov    %esp,%ebp
 8dc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8e6:	8d 45 0c             	lea    0xc(%ebp),%eax
 8e9:	83 c0 04             	add    $0x4,%eax
 8ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8f6:	e9 59 01 00 00       	jmp    a54 <printf+0x17b>
    c = fmt[i] & 0xff;
 8fb:	8b 55 0c             	mov    0xc(%ebp),%edx
 8fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 901:	01 d0                	add    %edx,%eax
 903:	0f b6 00             	movzbl (%eax),%eax
 906:	0f be c0             	movsbl %al,%eax
 909:	25 ff 00 00 00       	and    $0xff,%eax
 90e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 911:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 915:	75 2c                	jne    943 <printf+0x6a>
      if(c == '%'){
 917:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 91b:	75 0c                	jne    929 <printf+0x50>
        state = '%';
 91d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 924:	e9 27 01 00 00       	jmp    a50 <printf+0x177>
      } else {
        putc(fd, c);
 929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 92c:	0f be c0             	movsbl %al,%eax
 92f:	83 ec 08             	sub    $0x8,%esp
 932:	50                   	push   %eax
 933:	ff 75 08             	pushl  0x8(%ebp)
 936:	e8 c7 fe ff ff       	call   802 <putc>
 93b:	83 c4 10             	add    $0x10,%esp
 93e:	e9 0d 01 00 00       	jmp    a50 <printf+0x177>
      }
    } else if(state == '%'){
 943:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 947:	0f 85 03 01 00 00    	jne    a50 <printf+0x177>
      if(c == 'd'){
 94d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 951:	75 1e                	jne    971 <printf+0x98>
        printint(fd, *ap, 10, 1);
 953:	8b 45 e8             	mov    -0x18(%ebp),%eax
 956:	8b 00                	mov    (%eax),%eax
 958:	6a 01                	push   $0x1
 95a:	6a 0a                	push   $0xa
 95c:	50                   	push   %eax
 95d:	ff 75 08             	pushl  0x8(%ebp)
 960:	e8 c0 fe ff ff       	call   825 <printint>
 965:	83 c4 10             	add    $0x10,%esp
        ap++;
 968:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 96c:	e9 d8 00 00 00       	jmp    a49 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 971:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 975:	74 06                	je     97d <printf+0xa4>
 977:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 97b:	75 1e                	jne    99b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 97d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 980:	8b 00                	mov    (%eax),%eax
 982:	6a 00                	push   $0x0
 984:	6a 10                	push   $0x10
 986:	50                   	push   %eax
 987:	ff 75 08             	pushl  0x8(%ebp)
 98a:	e8 96 fe ff ff       	call   825 <printint>
 98f:	83 c4 10             	add    $0x10,%esp
        ap++;
 992:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 996:	e9 ae 00 00 00       	jmp    a49 <printf+0x170>
      } else if(c == 's'){
 99b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 99f:	75 43                	jne    9e4 <printf+0x10b>
        s = (char*)*ap;
 9a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9a4:	8b 00                	mov    (%eax),%eax
 9a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b1:	75 25                	jne    9d8 <printf+0xff>
          s = "(null)";
 9b3:	c7 45 f4 58 0f 00 00 	movl   $0xf58,-0xc(%ebp)
        while(*s != 0){
 9ba:	eb 1c                	jmp    9d8 <printf+0xff>
          putc(fd, *s);
 9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bf:	0f b6 00             	movzbl (%eax),%eax
 9c2:	0f be c0             	movsbl %al,%eax
 9c5:	83 ec 08             	sub    $0x8,%esp
 9c8:	50                   	push   %eax
 9c9:	ff 75 08             	pushl  0x8(%ebp)
 9cc:	e8 31 fe ff ff       	call   802 <putc>
 9d1:	83 c4 10             	add    $0x10,%esp
          s++;
 9d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9db:	0f b6 00             	movzbl (%eax),%eax
 9de:	84 c0                	test   %al,%al
 9e0:	75 da                	jne    9bc <printf+0xe3>
 9e2:	eb 65                	jmp    a49 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9e4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9e8:	75 1d                	jne    a07 <printf+0x12e>
        putc(fd, *ap);
 9ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9ed:	8b 00                	mov    (%eax),%eax
 9ef:	0f be c0             	movsbl %al,%eax
 9f2:	83 ec 08             	sub    $0x8,%esp
 9f5:	50                   	push   %eax
 9f6:	ff 75 08             	pushl  0x8(%ebp)
 9f9:	e8 04 fe ff ff       	call   802 <putc>
 9fe:	83 c4 10             	add    $0x10,%esp
        ap++;
 a01:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a05:	eb 42                	jmp    a49 <printf+0x170>
      } else if(c == '%'){
 a07:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a0b:	75 17                	jne    a24 <printf+0x14b>
        putc(fd, c);
 a0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a10:	0f be c0             	movsbl %al,%eax
 a13:	83 ec 08             	sub    $0x8,%esp
 a16:	50                   	push   %eax
 a17:	ff 75 08             	pushl  0x8(%ebp)
 a1a:	e8 e3 fd ff ff       	call   802 <putc>
 a1f:	83 c4 10             	add    $0x10,%esp
 a22:	eb 25                	jmp    a49 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a24:	83 ec 08             	sub    $0x8,%esp
 a27:	6a 25                	push   $0x25
 a29:	ff 75 08             	pushl  0x8(%ebp)
 a2c:	e8 d1 fd ff ff       	call   802 <putc>
 a31:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 a34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a37:	0f be c0             	movsbl %al,%eax
 a3a:	83 ec 08             	sub    $0x8,%esp
 a3d:	50                   	push   %eax
 a3e:	ff 75 08             	pushl  0x8(%ebp)
 a41:	e8 bc fd ff ff       	call   802 <putc>
 a46:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a49:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a50:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a54:	8b 55 0c             	mov    0xc(%ebp),%edx
 a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5a:	01 d0                	add    %edx,%eax
 a5c:	0f b6 00             	movzbl (%eax),%eax
 a5f:	84 c0                	test   %al,%al
 a61:	0f 85 94 fe ff ff    	jne    8fb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a67:	90                   	nop
 a68:	c9                   	leave  
 a69:	c3                   	ret    

00000a6a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a6a:	55                   	push   %ebp
 a6b:	89 e5                	mov    %esp,%ebp
 a6d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a70:	8b 45 08             	mov    0x8(%ebp),%eax
 a73:	83 e8 08             	sub    $0x8,%eax
 a76:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a79:	a1 88 12 00 00       	mov    0x1288,%eax
 a7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a81:	eb 24                	jmp    aa7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a83:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a86:	8b 00                	mov    (%eax),%eax
 a88:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a8b:	77 12                	ja     a9f <free+0x35>
 a8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a90:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a93:	77 24                	ja     ab9 <free+0x4f>
 a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a98:	8b 00                	mov    (%eax),%eax
 a9a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a9d:	77 1a                	ja     ab9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa2:	8b 00                	mov    (%eax),%eax
 aa4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 aa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aaa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 aad:	76 d4                	jbe    a83 <free+0x19>
 aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab2:	8b 00                	mov    (%eax),%eax
 ab4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ab7:	76 ca                	jbe    a83 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 ab9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 abc:	8b 40 04             	mov    0x4(%eax),%eax
 abf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ac6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac9:	01 c2                	add    %eax,%edx
 acb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ace:	8b 00                	mov    (%eax),%eax
 ad0:	39 c2                	cmp    %eax,%edx
 ad2:	75 24                	jne    af8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ad4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad7:	8b 50 04             	mov    0x4(%eax),%edx
 ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
 add:	8b 00                	mov    (%eax),%eax
 adf:	8b 40 04             	mov    0x4(%eax),%eax
 ae2:	01 c2                	add    %eax,%edx
 ae4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 aea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aed:	8b 00                	mov    (%eax),%eax
 aef:	8b 10                	mov    (%eax),%edx
 af1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af4:	89 10                	mov    %edx,(%eax)
 af6:	eb 0a                	jmp    b02 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 af8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 afb:	8b 10                	mov    (%eax),%edx
 afd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b00:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b02:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b05:	8b 40 04             	mov    0x4(%eax),%eax
 b08:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b12:	01 d0                	add    %edx,%eax
 b14:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b17:	75 20                	jne    b39 <free+0xcf>
    p->s.size += bp->s.size;
 b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1c:	8b 50 04             	mov    0x4(%eax),%edx
 b1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b22:	8b 40 04             	mov    0x4(%eax),%eax
 b25:	01 c2                	add    %eax,%edx
 b27:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b30:	8b 10                	mov    (%eax),%edx
 b32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b35:	89 10                	mov    %edx,(%eax)
 b37:	eb 08                	jmp    b41 <free+0xd7>
  } else
    p->s.ptr = bp;
 b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b3c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b3f:	89 10                	mov    %edx,(%eax)
  freep = p;
 b41:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b44:	a3 88 12 00 00       	mov    %eax,0x1288
}
 b49:	90                   	nop
 b4a:	c9                   	leave  
 b4b:	c3                   	ret    

00000b4c <morecore>:

static Header*
morecore(uint nu)
{
 b4c:	55                   	push   %ebp
 b4d:	89 e5                	mov    %esp,%ebp
 b4f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b52:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b59:	77 07                	ja     b62 <morecore+0x16>
    nu = 4096;
 b5b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b62:	8b 45 08             	mov    0x8(%ebp),%eax
 b65:	c1 e0 03             	shl    $0x3,%eax
 b68:	83 ec 0c             	sub    $0xc,%esp
 b6b:	50                   	push   %eax
 b6c:	e8 19 fc ff ff       	call   78a <sbrk>
 b71:	83 c4 10             	add    $0x10,%esp
 b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b77:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b7b:	75 07                	jne    b84 <morecore+0x38>
    return 0;
 b7d:	b8 00 00 00 00       	mov    $0x0,%eax
 b82:	eb 26                	jmp    baa <morecore+0x5e>
  hp = (Header*)p;
 b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b8d:	8b 55 08             	mov    0x8(%ebp),%edx
 b90:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b96:	83 c0 08             	add    $0x8,%eax
 b99:	83 ec 0c             	sub    $0xc,%esp
 b9c:	50                   	push   %eax
 b9d:	e8 c8 fe ff ff       	call   a6a <free>
 ba2:	83 c4 10             	add    $0x10,%esp
  return freep;
 ba5:	a1 88 12 00 00       	mov    0x1288,%eax
}
 baa:	c9                   	leave  
 bab:	c3                   	ret    

00000bac <malloc>:

void*
malloc(uint nbytes)
{
 bac:	55                   	push   %ebp
 bad:	89 e5                	mov    %esp,%ebp
 baf:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bb2:	8b 45 08             	mov    0x8(%ebp),%eax
 bb5:	83 c0 07             	add    $0x7,%eax
 bb8:	c1 e8 03             	shr    $0x3,%eax
 bbb:	83 c0 01             	add    $0x1,%eax
 bbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 bc1:	a1 88 12 00 00       	mov    0x1288,%eax
 bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 bcd:	75 23                	jne    bf2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 bcf:	c7 45 f0 80 12 00 00 	movl   $0x1280,-0x10(%ebp)
 bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bd9:	a3 88 12 00 00       	mov    %eax,0x1288
 bde:	a1 88 12 00 00       	mov    0x1288,%eax
 be3:	a3 80 12 00 00       	mov    %eax,0x1280
    base.s.size = 0;
 be8:	c7 05 84 12 00 00 00 	movl   $0x0,0x1284
 bef:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bf5:	8b 00                	mov    (%eax),%eax
 bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfd:	8b 40 04             	mov    0x4(%eax),%eax
 c00:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c03:	72 4d                	jb     c52 <malloc+0xa6>
      if(p->s.size == nunits)
 c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c08:	8b 40 04             	mov    0x4(%eax),%eax
 c0b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c0e:	75 0c                	jne    c1c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c13:	8b 10                	mov    (%eax),%edx
 c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c18:	89 10                	mov    %edx,(%eax)
 c1a:	eb 26                	jmp    c42 <malloc+0x96>
      else {
        p->s.size -= nunits;
 c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1f:	8b 40 04             	mov    0x4(%eax),%eax
 c22:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c25:	89 c2                	mov    %eax,%edx
 c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c2a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c30:	8b 40 04             	mov    0x4(%eax),%eax
 c33:	c1 e0 03             	shl    $0x3,%eax
 c36:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c3f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c45:	a3 88 12 00 00       	mov    %eax,0x1288
      return (void*)(p + 1);
 c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4d:	83 c0 08             	add    $0x8,%eax
 c50:	eb 3b                	jmp    c8d <malloc+0xe1>
    }
    if(p == freep)
 c52:	a1 88 12 00 00       	mov    0x1288,%eax
 c57:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c5a:	75 1e                	jne    c7a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 c5c:	83 ec 0c             	sub    $0xc,%esp
 c5f:	ff 75 ec             	pushl  -0x14(%ebp)
 c62:	e8 e5 fe ff ff       	call   b4c <morecore>
 c67:	83 c4 10             	add    $0x10,%esp
 c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c71:	75 07                	jne    c7a <malloc+0xce>
        return 0;
 c73:	b8 00 00 00 00       	mov    $0x0,%eax
 c78:	eb 13                	jmp    c8d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c83:	8b 00                	mov    (%eax),%eax
 c85:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c88:	e9 6d ff ff ff       	jmp    bfa <malloc+0x4e>
}
 c8d:	c9                   	leave  
 c8e:	c3                   	ret    
