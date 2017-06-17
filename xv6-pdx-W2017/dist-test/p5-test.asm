
_p5-test:     file format elf32-i386


Disassembly of section .text:

00000000 <canRun>:
#include "stat.h"
#include "p5-test.h"

static int
canRun(char *name)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  int rc, uid, gid;
  struct stat st;

  uid = getuid();
       6:	e8 97 14 00 00       	call   14a2 <getuid>
       b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  gid = getgid();
       e:	e8 97 14 00 00       	call   14aa <getgid>
      13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  check(stat(name, &st));
      16:	83 ec 08             	sub    $0x8,%esp
      19:	8d 45 d0             	lea    -0x30(%ebp),%eax
      1c:	50                   	push   %eax
      1d:	ff 75 08             	pushl  0x8(%ebp)
      20:	e8 60 12 00 00       	call   1285 <stat>
      25:	83 c4 10             	add    $0x10,%esp
      28:	89 45 ec             	mov    %eax,-0x14(%ebp)
      2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
      2f:	74 21                	je     52 <canRun+0x52>
      31:	83 ec 04             	sub    $0x4,%esp
      34:	68 80 19 00 00       	push   $0x1980
      39:	68 90 19 00 00       	push   $0x1990
      3e:	6a 02                	push   $0x2
      40:	e8 84 15 00 00       	call   15c9 <printf>
      45:	83 c4 10             	add    $0x10,%esp
      48:	b8 00 00 00 00       	mov    $0x0,%eax
      4d:	e9 97 00 00 00       	jmp    e9 <canRun+0xe9>
  if (uid == st.uid) {
      52:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
      56:	0f b7 c0             	movzwl %ax,%eax
      59:	3b 45 f4             	cmp    -0xc(%ebp),%eax
      5c:	75 2b                	jne    89 <canRun+0x89>
    if (st.mode.flags.u_x)
      5e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
      62:	83 e0 40             	and    $0x40,%eax
      65:	84 c0                	test   %al,%al
      67:	74 07                	je     70 <canRun+0x70>
      return TRUE;
      69:	b8 01 00 00 00       	mov    $0x1,%eax
      6e:	eb 79                	jmp    e9 <canRun+0xe9>
    else {
      printf(2, "UID match. Execute permission for user not set.\n");
      70:	83 ec 08             	sub    $0x8,%esp
      73:	68 a4 19 00 00       	push   $0x19a4
      78:	6a 02                	push   $0x2
      7a:	e8 4a 15 00 00       	call   15c9 <printf>
      7f:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      82:	b8 00 00 00 00       	mov    $0x0,%eax
      87:	eb 60                	jmp    e9 <canRun+0xe9>
    }
  }
  if (gid == st.gid) {
      89:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
      8d:	0f b7 c0             	movzwl %ax,%eax
      90:	3b 45 f0             	cmp    -0x10(%ebp),%eax
      93:	75 2b                	jne    c0 <canRun+0xc0>
    if (st.mode.flags.g_x)
      95:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
      99:	83 e0 08             	and    $0x8,%eax
      9c:	84 c0                	test   %al,%al
      9e:	74 07                	je     a7 <canRun+0xa7>
      return TRUE;
      a0:	b8 01 00 00 00       	mov    $0x1,%eax
      a5:	eb 42                	jmp    e9 <canRun+0xe9>
    else {
      printf(2, "GID match. Execute permission for group not set.\n");
      a7:	83 ec 08             	sub    $0x8,%esp
      aa:	68 d8 19 00 00       	push   $0x19d8
      af:	6a 02                	push   $0x2
      b1:	e8 13 15 00 00       	call   15c9 <printf>
      b6:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      b9:	b8 00 00 00 00       	mov    $0x0,%eax
      be:	eb 29                	jmp    e9 <canRun+0xe9>
    }
  }
  if (st.mode.flags.o_x) {
      c0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
      c4:	83 e0 01             	and    $0x1,%eax
      c7:	84 c0                	test   %al,%al
      c9:	74 07                	je     d2 <canRun+0xd2>
    return TRUE;
      cb:	b8 01 00 00 00       	mov    $0x1,%eax
      d0:	eb 17                	jmp    e9 <canRun+0xe9>
  }

  printf(2, "Execute permission for other not set.\n");
      d2:	83 ec 08             	sub    $0x8,%esp
      d5:	68 0c 1a 00 00       	push   $0x1a0c
      da:	6a 02                	push   $0x2
      dc:	e8 e8 14 00 00       	call   15c9 <printf>
      e1:	83 c4 10             	add    $0x10,%esp
  return FALSE;  // failure. Can't run
      e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
      e9:	c9                   	leave  
      ea:	c3                   	ret    

000000eb <doSetuidTest>:

static int
doSetuidTest (char **cmd)
{
      eb:	55                   	push   %ebp
      ec:	89 e5                	mov    %esp,%ebp
      ee:	53                   	push   %ebx
      ef:	83 ec 24             	sub    $0x24,%esp
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};
      f2:	c7 45 e0 33 1a 00 00 	movl   $0x1a33,-0x20(%ebp)
      f9:	c7 45 e4 3d 1a 00 00 	movl   $0x1a3d,-0x1c(%ebp)
     100:	c7 45 e8 47 1a 00 00 	movl   $0x1a47,-0x18(%ebp)
     107:	c7 45 ec 4d 1a 00 00 	movl   $0x1a4d,-0x14(%ebp)

  printf(1, "\nTesting the set uid bit.\n\n");
     10e:	83 ec 08             	sub    $0x8,%esp
     111:	68 59 1a 00 00       	push   $0x1a59
     116:	6a 01                	push   $0x1
     118:	e8 ac 14 00 00       	call   15c9 <printf>
     11d:	83 c4 10             	add    $0x10,%esp

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     120:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     127:	e9 71 02 00 00       	jmp    39d <doSetuidTest+0x2b2>
    printf(1, "Starting test: %s.\n", test[i]);
     12c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     12f:	8b 44 85 e0          	mov    -0x20(%ebp,%eax,4),%eax
     133:	83 ec 04             	sub    $0x4,%esp
     136:	50                   	push   %eax
     137:	68 75 1a 00 00       	push   $0x1a75
     13c:	6a 01                	push   $0x1
     13e:	e8 86 14 00 00       	call   15c9 <printf>
     143:	83 c4 10             	add    $0x10,%esp
    check(setuid(testperms[i][procuid]));
     146:	8b 45 f4             	mov    -0xc(%ebp),%eax
     149:	c1 e0 04             	shl    $0x4,%eax
     14c:	05 80 26 00 00       	add    $0x2680,%eax
     151:	8b 00                	mov    (%eax),%eax
     153:	83 ec 0c             	sub    $0xc,%esp
     156:	50                   	push   %eax
     157:	e8 5e 13 00 00       	call   14ba <setuid>
     15c:	83 c4 10             	add    $0x10,%esp
     15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     166:	74 21                	je     189 <doSetuidTest+0x9e>
     168:	83 ec 04             	sub    $0x4,%esp
     16b:	68 89 1a 00 00       	push   $0x1a89
     170:	68 90 19 00 00       	push   $0x1990
     175:	6a 02                	push   $0x2
     177:	e8 4d 14 00 00       	call   15c9 <printf>
     17c:	83 c4 10             	add    $0x10,%esp
     17f:	b8 00 00 00 00       	mov    $0x0,%eax
     184:	e9 4f 02 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    check(setgid(testperms[i][procgid]));
     189:	8b 45 f4             	mov    -0xc(%ebp),%eax
     18c:	c1 e0 04             	shl    $0x4,%eax
     18f:	05 84 26 00 00       	add    $0x2684,%eax
     194:	8b 00                	mov    (%eax),%eax
     196:	83 ec 0c             	sub    $0xc,%esp
     199:	50                   	push   %eax
     19a:	e8 23 13 00 00       	call   14c2 <setgid>
     19f:	83 c4 10             	add    $0x10,%esp
     1a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     1a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1a9:	74 21                	je     1cc <doSetuidTest+0xe1>
     1ab:	83 ec 04             	sub    $0x4,%esp
     1ae:	68 a7 1a 00 00       	push   $0x1aa7
     1b3:	68 90 19 00 00       	push   $0x1990
     1b8:	6a 02                	push   $0x2
     1ba:	e8 0a 14 00 00       	call   15c9 <printf>
     1bf:	83 c4 10             	add    $0x10,%esp
     1c2:	b8 00 00 00 00       	mov    $0x0,%eax
     1c7:	e9 0c 02 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "Process uid: %d, gid: %d\n", getuid(), getgid());
     1cc:	e8 d9 12 00 00       	call   14aa <getgid>
     1d1:	89 c3                	mov    %eax,%ebx
     1d3:	e8 ca 12 00 00       	call   14a2 <getuid>
     1d8:	53                   	push   %ebx
     1d9:	50                   	push   %eax
     1da:	68 c5 1a 00 00       	push   $0x1ac5
     1df:	6a 01                	push   $0x1
     1e1:	e8 e3 13 00 00       	call   15c9 <printf>
     1e6:	83 c4 10             	add    $0x10,%esp
    check(chown(cmd[0], testperms[i][fileuid]));
     1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1ec:	c1 e0 04             	shl    $0x4,%eax
     1ef:	05 88 26 00 00       	add    $0x2688,%eax
     1f4:	8b 10                	mov    (%eax),%edx
     1f6:	8b 45 08             	mov    0x8(%ebp),%eax
     1f9:	8b 00                	mov    (%eax),%eax
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	52                   	push   %edx
     1ff:	50                   	push   %eax
     200:	e8 dd 12 00 00       	call   14e2 <chown>
     205:	83 c4 10             	add    $0x10,%esp
     208:	89 45 f0             	mov    %eax,-0x10(%ebp)
     20b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     20f:	74 21                	je     232 <doSetuidTest+0x147>
     211:	83 ec 04             	sub    $0x4,%esp
     214:	68 e0 1a 00 00       	push   $0x1ae0
     219:	68 90 19 00 00       	push   $0x1990
     21e:	6a 02                	push   $0x2
     220:	e8 a4 13 00 00       	call   15c9 <printf>
     225:	83 c4 10             	add    $0x10,%esp
     228:	b8 00 00 00 00       	mov    $0x0,%eax
     22d:	e9 a6 01 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    check(chgrp(cmd[0], testperms[i][filegid]));
     232:	8b 45 f4             	mov    -0xc(%ebp),%eax
     235:	c1 e0 04             	shl    $0x4,%eax
     238:	05 8c 26 00 00       	add    $0x268c,%eax
     23d:	8b 10                	mov    (%eax),%edx
     23f:	8b 45 08             	mov    0x8(%ebp),%eax
     242:	8b 00                	mov    (%eax),%eax
     244:	83 ec 08             	sub    $0x8,%esp
     247:	52                   	push   %edx
     248:	50                   	push   %eax
     249:	e8 9c 12 00 00       	call   14ea <chgrp>
     24e:	83 c4 10             	add    $0x10,%esp
     251:	89 45 f0             	mov    %eax,-0x10(%ebp)
     254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     258:	74 21                	je     27b <doSetuidTest+0x190>
     25a:	83 ec 04             	sub    $0x4,%esp
     25d:	68 08 1b 00 00       	push   $0x1b08
     262:	68 90 19 00 00       	push   $0x1990
     267:	6a 02                	push   $0x2
     269:	e8 5b 13 00 00       	call   15c9 <printf>
     26e:	83 c4 10             	add    $0x10,%esp
     271:	b8 00 00 00 00       	mov    $0x0,%eax
     276:	e9 5d 01 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "File uid: %d, gid: %d\n",
     27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     27e:	c1 e0 04             	shl    $0x4,%eax
     281:	05 8c 26 00 00       	add    $0x268c,%eax
     286:	8b 10                	mov    (%eax),%edx
     288:	8b 45 f4             	mov    -0xc(%ebp),%eax
     28b:	c1 e0 04             	shl    $0x4,%eax
     28e:	05 88 26 00 00       	add    $0x2688,%eax
     293:	8b 00                	mov    (%eax),%eax
     295:	52                   	push   %edx
     296:	50                   	push   %eax
     297:	68 2d 1b 00 00       	push   $0x1b2d
     29c:	6a 01                	push   $0x1
     29e:	e8 26 13 00 00       	call   15c9 <printf>
     2a3:	83 c4 10             	add    $0x10,%esp
		    testperms[i][fileuid], testperms[i][filegid]);
    check(chmod(cmd[0], perms[i]));
     2a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2a9:	8b 14 85 64 26 00 00 	mov    0x2664(,%eax,4),%edx
     2b0:	8b 45 08             	mov    0x8(%ebp),%eax
     2b3:	8b 00                	mov    (%eax),%eax
     2b5:	83 ec 08             	sub    $0x8,%esp
     2b8:	52                   	push   %edx
     2b9:	50                   	push   %eax
     2ba:	e8 1b 12 00 00       	call   14da <chmod>
     2bf:	83 c4 10             	add    $0x10,%esp
     2c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     2c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2c9:	74 21                	je     2ec <doSetuidTest+0x201>
     2cb:	83 ec 04             	sub    $0x4,%esp
     2ce:	68 44 1b 00 00       	push   $0x1b44
     2d3:	68 90 19 00 00       	push   $0x1990
     2d8:	6a 02                	push   $0x2
     2da:	e8 ea 12 00 00       	call   15c9 <printf>
     2df:	83 c4 10             	add    $0x10,%esp
     2e2:	b8 00 00 00 00       	mov    $0x0,%eax
     2e7:	e9 ec 00 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "perms set to %d for %s\n", perms[i], cmd[0]);
     2ec:	8b 45 08             	mov    0x8(%ebp),%eax
     2ef:	8b 10                	mov    (%eax),%edx
     2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2f4:	8b 04 85 64 26 00 00 	mov    0x2664(,%eax,4),%eax
     2fb:	52                   	push   %edx
     2fc:	50                   	push   %eax
     2fd:	68 5c 1b 00 00       	push   $0x1b5c
     302:	6a 01                	push   $0x1
     304:	e8 c0 12 00 00       	call   15c9 <printf>
     309:	83 c4 10             	add    $0x10,%esp

    rc = fork();
     30c:	e8 d9 10 00 00       	call   13ea <fork>
     311:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     314:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     318:	79 1c                	jns    336 <doSetuidTest+0x24b>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     31a:	83 ec 08             	sub    $0x8,%esp
     31d:	68 74 1b 00 00       	push   $0x1b74
     322:	6a 02                	push   $0x2
     324:	e8 a0 12 00 00       	call   15c9 <printf>
     329:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     32c:	b8 00 00 00 00       	mov    $0x0,%eax
     331:	e9 a2 00 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    }
    if (rc == 0) {   // child
     336:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     33a:	75 58                	jne    394 <doSetuidTest+0x2a9>
      exec(cmd[0], cmd);
     33c:	8b 45 08             	mov    0x8(%ebp),%eax
     33f:	8b 00                	mov    (%eax),%eax
     341:	83 ec 08             	sub    $0x8,%esp
     344:	ff 75 08             	pushl  0x8(%ebp)
     347:	50                   	push   %eax
     348:	e8 dd 10 00 00       	call   142a <exec>
     34d:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     350:	a1 60 26 00 00       	mov    0x2660,%eax
     355:	83 e8 01             	sub    $0x1,%eax
     358:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     35b:	74 1a                	je     377 <doSetuidTest+0x28c>
     35d:	8b 45 08             	mov    0x8(%ebp),%eax
     360:	8b 00                	mov    (%eax),%eax
     362:	83 ec 04             	sub    $0x4,%esp
     365:	50                   	push   %eax
     366:	68 bc 1b 00 00       	push   $0x1bbc
     36b:	6a 02                	push   $0x2
     36d:	e8 57 12 00 00       	call   15c9 <printf>
     372:	83 c4 10             	add    $0x10,%esp
     375:	eb 18                	jmp    38f <doSetuidTest+0x2a4>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     377:	8b 45 08             	mov    0x8(%ebp),%eax
     37a:	8b 00                	mov    (%eax),%eax
     37c:	83 ec 04             	sub    $0x4,%esp
     37f:	50                   	push   %eax
     380:	68 e0 1b 00 00       	push   $0x1be0
     385:	6a 02                	push   $0x2
     387:	e8 3d 12 00 00       	call   15c9 <printf>
     38c:	83 c4 10             	add    $0x10,%esp
      exit();
     38f:	e8 5e 10 00 00       	call   13f2 <exit>
    }
    wait();
     394:	e8 61 10 00 00       	call   13fa <wait>
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};

  printf(1, "\nTesting the set uid bit.\n\n");

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     399:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     39d:	a1 60 26 00 00       	mov    0x2660,%eax
     3a2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     3a5:	0f 8c 81 fd ff ff    	jl     12c <doSetuidTest+0x41>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chmod(cmd[0], 00755);  // total hack but necessary. sigh
     3ab:	8b 45 08             	mov    0x8(%ebp),%eax
     3ae:	8b 00                	mov    (%eax),%eax
     3b0:	83 ec 08             	sub    $0x8,%esp
     3b3:	68 ed 01 00 00       	push   $0x1ed
     3b8:	50                   	push   %eax
     3b9:	e8 1c 11 00 00       	call   14da <chmod>
     3be:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     3c1:	83 ec 08             	sub    $0x8,%esp
     3c4:	68 0d 1c 00 00       	push   $0x1c0d
     3c9:	6a 01                	push   $0x1
     3cb:	e8 f9 11 00 00       	call   15c9 <printf>
     3d0:	83 c4 10             	add    $0x10,%esp
  return PASS;
     3d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
     3d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3db:	c9                   	leave  
     3dc:	c3                   	ret    

000003dd <doUidTest>:

static int
doUidTest (char **cmd)
{
     3dd:	55                   	push   %ebp
     3de:	89 e5                	mov    %esp,%ebp
     3e0:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, startuid, testuid, baduidcount = 3;
     3e3:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int baduids[] = {32767+5, -41, ~0};  // 32767 is max value
     3ea:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     3f1:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     3f8:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setuid() test.\n\n");
     3ff:	83 ec 08             	sub    $0x8,%esp
     402:	68 1a 1c 00 00       	push   $0x1c1a
     407:	6a 01                	push   $0x1
     409:	e8 bb 11 00 00       	call   15c9 <printf>
     40e:	83 c4 10             	add    $0x10,%esp

  startuid = uid = getuid();
     411:	e8 8c 10 00 00       	call   14a2 <getuid>
     416:	89 45 ec             	mov    %eax,-0x14(%ebp)
     419:	8b 45 ec             	mov    -0x14(%ebp),%eax
     41c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testuid = ++uid;
     41f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     423:	8b 45 ec             	mov    -0x14(%ebp),%eax
     426:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setuid(testuid);
     429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     42c:	83 ec 0c             	sub    $0xc,%esp
     42f:	50                   	push   %eax
     430:	e8 85 10 00 00       	call   14ba <setuid>
     435:	83 c4 10             	add    $0x10,%esp
     438:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     43b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     43f:	74 1c                	je     45d <doUidTest+0x80>
    printf(2, "setuid system call reports an error.\n");
     441:	83 ec 08             	sub    $0x8,%esp
     444:	68 38 1c 00 00       	push   $0x1c38
     449:	6a 02                	push   $0x2
     44b:	e8 79 11 00 00       	call   15c9 <printf>
     450:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     453:	b8 00 00 00 00       	mov    $0x0,%eax
     458:	e9 07 01 00 00       	jmp    564 <doUidTest+0x187>
  }
  uid = getuid();
     45d:	e8 40 10 00 00       	call   14a2 <getuid>
     462:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (uid != testuid) {
     465:	8b 45 ec             	mov    -0x14(%ebp),%eax
     468:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     46b:	74 31                	je     49e <doUidTest+0xc1>
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
     46d:	83 ec 08             	sub    $0x8,%esp
     470:	68 60 1c 00 00       	push   $0x1c60
     475:	6a 02                	push   $0x2
     477:	e8 4d 11 00 00       	call   15c9 <printf>
     47c:	83 c4 10             	add    $0x10,%esp
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
     47f:	ff 75 ec             	pushl  -0x14(%ebp)
     482:	ff 75 e4             	pushl  -0x1c(%ebp)
     485:	68 98 1c 00 00       	push   $0x1c98
     48a:	6a 02                	push   $0x2
     48c:	e8 38 11 00 00       	call   15c9 <printf>
     491:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     494:	b8 00 00 00 00       	mov    $0x0,%eax
     499:	e9 c6 00 00 00       	jmp    564 <doUidTest+0x187>
  }
  for (i=0; i<baduidcount; i++) {
     49e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4a5:	e9 88 00 00 00       	jmp    532 <doUidTest+0x155>
    rc = setuid(baduids[i]);
     4aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ad:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4b1:	83 ec 0c             	sub    $0xc,%esp
     4b4:	50                   	push   %eax
     4b5:	e8 00 10 00 00       	call   14ba <setuid>
     4ba:	83 c4 10             	add    $0x10,%esp
     4bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     4c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     4c4:	75 21                	jne    4e7 <doUidTest+0x10a>
      printf(2, "Tried to set the uid to a bad value (%d) and setuid()failed to fail. rc == %d\n",
     4c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c9:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4cd:	ff 75 e0             	pushl  -0x20(%ebp)
     4d0:	50                   	push   %eax
     4d1:	68 bc 1c 00 00       	push   $0x1cbc
     4d6:	6a 02                	push   $0x2
     4d8:	e8 ec 10 00 00       	call   15c9 <printf>
     4dd:	83 c4 10             	add    $0x10,%esp
                      baduids[i], rc);
      return NOPASS;
     4e0:	b8 00 00 00 00       	mov    $0x0,%eax
     4e5:	eb 7d                	jmp    564 <doUidTest+0x187>
    }
    rc = getuid();
     4e7:	e8 b6 0f 00 00       	call   14a2 <getuid>
     4ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (baduids[i] == rc) {
     4ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f2:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     4f9:	75 33                	jne    52e <doUidTest+0x151>
      printf(2, "ERROR! Gave setuid() a bad value (%d) and it failed to fail. gid: %d\n",
     4fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fe:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     502:	ff 75 e0             	pushl  -0x20(%ebp)
     505:	50                   	push   %eax
     506:	68 0c 1d 00 00       	push   $0x1d0c
     50b:	6a 02                	push   $0x2
     50d:	e8 b7 10 00 00       	call   15c9 <printf>
     512:	83 c4 10             	add    $0x10,%esp
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
     515:	83 ec 08             	sub    $0x8,%esp
     518:	68 54 1d 00 00       	push   $0x1d54
     51d:	6a 02                	push   $0x2
     51f:	e8 a5 10 00 00       	call   15c9 <printf>
     524:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     527:	b8 00 00 00 00       	mov    $0x0,%eax
     52c:	eb 36                	jmp    564 <doUidTest+0x187>
  if (uid != testuid) {
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
    return NOPASS;
  }
  for (i=0; i<baduidcount; i++) {
     52e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     532:	8b 45 f4             	mov    -0xc(%ebp),%eax
     535:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     538:	0f 8c 6c ff ff ff    	jl     4aa <doUidTest+0xcd>
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setuid(startuid);
     53e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     541:	83 ec 0c             	sub    $0xc,%esp
     544:	50                   	push   %eax
     545:	e8 70 0f 00 00       	call   14ba <setuid>
     54a:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     54d:	83 ec 08             	sub    $0x8,%esp
     550:	68 0d 1c 00 00       	push   $0x1c0d
     555:	6a 01                	push   $0x1
     557:	e8 6d 10 00 00       	call   15c9 <printf>
     55c:	83 c4 10             	add    $0x10,%esp
  return PASS;
     55f:	b8 01 00 00 00       	mov    $0x1,%eax
}
     564:	c9                   	leave  
     565:	c3                   	ret    

00000566 <doGidTest>:

static int
doGidTest (char **cmd)
{
     566:	55                   	push   %ebp
     567:	89 e5                	mov    %esp,%ebp
     569:	83 ec 38             	sub    $0x38,%esp
  int i, rc, gid, startgid, testgid, badgidcount = 3;
     56c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int badgids[] = {32767+5, -41, ~0};  // 32767 is max value
     573:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     57a:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     581:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setgid() test.\n\n");
     588:	83 ec 08             	sub    $0x8,%esp
     58b:	68 82 1d 00 00       	push   $0x1d82
     590:	6a 01                	push   $0x1
     592:	e8 32 10 00 00       	call   15c9 <printf>
     597:	83 c4 10             	add    $0x10,%esp

  startgid = gid = getgid();
     59a:	e8 0b 0f 00 00       	call   14aa <getgid>
     59f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     5a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testgid = ++gid;
     5a8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     5ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setgid(testgid);
     5b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5b5:	83 ec 0c             	sub    $0xc,%esp
     5b8:	50                   	push   %eax
     5b9:	e8 04 0f 00 00       	call   14c2 <setgid>
     5be:	83 c4 10             	add    $0x10,%esp
     5c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     5c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     5c8:	74 1c                	je     5e6 <doGidTest+0x80>
    printf(2, "setgid system call reports an error.\n");
     5ca:	83 ec 08             	sub    $0x8,%esp
     5cd:	68 a0 1d 00 00       	push   $0x1da0
     5d2:	6a 02                	push   $0x2
     5d4:	e8 f0 0f 00 00       	call   15c9 <printf>
     5d9:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     5dc:	b8 00 00 00 00       	mov    $0x0,%eax
     5e1:	e9 07 01 00 00       	jmp    6ed <doGidTest+0x187>
  }
  gid = getgid();
     5e6:	e8 bf 0e 00 00       	call   14aa <getgid>
     5eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (gid != testgid) {
     5ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     5f4:	74 31                	je     627 <doGidTest+0xc1>
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
     5f6:	83 ec 08             	sub    $0x8,%esp
     5f9:	68 c8 1d 00 00       	push   $0x1dc8
     5fe:	6a 02                	push   $0x2
     600:	e8 c4 0f 00 00       	call   15c9 <printf>
     605:	83 c4 10             	add    $0x10,%esp
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
     608:	ff 75 ec             	pushl  -0x14(%ebp)
     60b:	ff 75 e4             	pushl  -0x1c(%ebp)
     60e:	68 00 1e 00 00       	push   $0x1e00
     613:	6a 02                	push   $0x2
     615:	e8 af 0f 00 00       	call   15c9 <printf>
     61a:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     61d:	b8 00 00 00 00       	mov    $0x0,%eax
     622:	e9 c6 00 00 00       	jmp    6ed <doGidTest+0x187>
  }
  for (i=0; i<badgidcount; i++) {
     627:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     62e:	e9 88 00 00 00       	jmp    6bb <doGidTest+0x155>
    rc = setgid(badgids[i]); 
     633:	8b 45 f4             	mov    -0xc(%ebp),%eax
     636:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     63a:	83 ec 0c             	sub    $0xc,%esp
     63d:	50                   	push   %eax
     63e:	e8 7f 0e 00 00       	call   14c2 <setgid>
     643:	83 c4 10             	add    $0x10,%esp
     646:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     649:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     64d:	75 21                	jne    670 <doGidTest+0x10a>
      printf(2, "Tried to set the gid to a bad value (%d) and setgid()failed to fail. rc == %d\n",
     64f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     652:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     656:	ff 75 e0             	pushl  -0x20(%ebp)
     659:	50                   	push   %eax
     65a:	68 24 1e 00 00       	push   $0x1e24
     65f:	6a 02                	push   $0x2
     661:	e8 63 0f 00 00       	call   15c9 <printf>
     666:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      return NOPASS;
     669:	b8 00 00 00 00       	mov    $0x0,%eax
     66e:	eb 7d                	jmp    6ed <doGidTest+0x187>
    }
    rc = getgid();
     670:	e8 35 0e 00 00       	call   14aa <getgid>
     675:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (badgids[i] == rc) {
     678:	8b 45 f4             	mov    -0xc(%ebp),%eax
     67b:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     67f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     682:	75 33                	jne    6b7 <doGidTest+0x151>
      printf(2, "ERROR! Gave setgid() a bad value (%d) and it failed to fail. gid: %d\n",
     684:	8b 45 f4             	mov    -0xc(%ebp),%eax
     687:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     68b:	ff 75 e0             	pushl  -0x20(%ebp)
     68e:	50                   	push   %eax
     68f:	68 74 1e 00 00       	push   $0x1e74
     694:	6a 02                	push   $0x2
     696:	e8 2e 0f 00 00       	call   15c9 <printf>
     69b:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
     69e:	83 ec 08             	sub    $0x8,%esp
     6a1:	68 bc 1e 00 00       	push   $0x1ebc
     6a6:	6a 02                	push   $0x2
     6a8:	e8 1c 0f 00 00       	call   15c9 <printf>
     6ad:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     6b0:	b8 00 00 00 00       	mov    $0x0,%eax
     6b5:	eb 36                	jmp    6ed <doGidTest+0x187>
  if (gid != testgid) {
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
    return NOPASS;
  }
  for (i=0; i<badgidcount; i++) {
     6b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     6bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     6c1:	0f 8c 6c ff ff ff    	jl     633 <doGidTest+0xcd>
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setgid(startgid);
     6c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6ca:	83 ec 0c             	sub    $0xc,%esp
     6cd:	50                   	push   %eax
     6ce:	e8 ef 0d 00 00       	call   14c2 <setgid>
     6d3:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     6d6:	83 ec 08             	sub    $0x8,%esp
     6d9:	68 0d 1c 00 00       	push   $0x1c0d
     6de:	6a 01                	push   $0x1
     6e0:	e8 e4 0e 00 00       	call   15c9 <printf>
     6e5:	83 c4 10             	add    $0x10,%esp
  return PASS;
     6e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
     6ed:	c9                   	leave  
     6ee:	c3                   	ret    

000006ef <doChmodTest>:

static int
doChmodTest(char **cmd) 
{
     6ef:	55                   	push   %ebp
     6f0:	89 e5                	mov    %esp,%ebp
     6f2:	83 ec 38             	sub    $0x38,%esp
  int i, rc, mode, testmode;
  struct stat st;

  printf(1, "\nExecuting chmod() test.\n\n");
     6f5:	83 ec 08             	sub    $0x8,%esp
     6f8:	68 ea 1e 00 00       	push   $0x1eea
     6fd:	6a 01                	push   $0x1
     6ff:	e8 c5 0e 00 00       	call   15c9 <printf>
     704:	83 c4 10             	add    $0x10,%esp

  check(stat(cmd[0], &st));
     707:	8b 45 08             	mov    0x8(%ebp),%eax
     70a:	8b 00                	mov    (%eax),%eax
     70c:	83 ec 08             	sub    $0x8,%esp
     70f:	8d 55 cc             	lea    -0x34(%ebp),%edx
     712:	52                   	push   %edx
     713:	50                   	push   %eax
     714:	e8 6c 0b 00 00       	call   1285 <stat>
     719:	83 c4 10             	add    $0x10,%esp
     71c:	89 45 f0             	mov    %eax,-0x10(%ebp)
     71f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     723:	74 21                	je     746 <doChmodTest+0x57>
     725:	83 ec 04             	sub    $0x4,%esp
     728:	68 05 1f 00 00       	push   $0x1f05
     72d:	68 90 19 00 00       	push   $0x1990
     732:	6a 02                	push   $0x2
     734:	e8 90 0e 00 00       	call   15c9 <printf>
     739:	83 c4 10             	add    $0x10,%esp
     73c:	b8 00 00 00 00       	mov    $0x0,%eax
     741:	e9 46 01 00 00       	jmp    88c <doChmodTest+0x19d>
  mode = st.mode.asInt;
     746:	8b 45 e0             	mov    -0x20(%ebp),%eax
     749:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     74c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     753:	e9 f9 00 00 00       	jmp    851 <doChmodTest+0x162>
    check(chmod(cmd[0], perms[i]));
     758:	8b 45 f4             	mov    -0xc(%ebp),%eax
     75b:	8b 14 85 64 26 00 00 	mov    0x2664(,%eax,4),%edx
     762:	8b 45 08             	mov    0x8(%ebp),%eax
     765:	8b 00                	mov    (%eax),%eax
     767:	83 ec 08             	sub    $0x8,%esp
     76a:	52                   	push   %edx
     76b:	50                   	push   %eax
     76c:	e8 69 0d 00 00       	call   14da <chmod>
     771:	83 c4 10             	add    $0x10,%esp
     774:	89 45 f0             	mov    %eax,-0x10(%ebp)
     777:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     77b:	74 21                	je     79e <doChmodTest+0xaf>
     77d:	83 ec 04             	sub    $0x4,%esp
     780:	68 44 1b 00 00       	push   $0x1b44
     785:	68 90 19 00 00       	push   $0x1990
     78a:	6a 02                	push   $0x2
     78c:	e8 38 0e 00 00       	call   15c9 <printf>
     791:	83 c4 10             	add    $0x10,%esp
     794:	b8 00 00 00 00       	mov    $0x0,%eax
     799:	e9 ee 00 00 00       	jmp    88c <doChmodTest+0x19d>
    check(stat(cmd[0], &st));
     79e:	8b 45 08             	mov    0x8(%ebp),%eax
     7a1:	8b 00                	mov    (%eax),%eax
     7a3:	83 ec 08             	sub    $0x8,%esp
     7a6:	8d 55 cc             	lea    -0x34(%ebp),%edx
     7a9:	52                   	push   %edx
     7aa:	50                   	push   %eax
     7ab:	e8 d5 0a 00 00       	call   1285 <stat>
     7b0:	83 c4 10             	add    $0x10,%esp
     7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7ba:	74 21                	je     7dd <doChmodTest+0xee>
     7bc:	83 ec 04             	sub    $0x4,%esp
     7bf:	68 05 1f 00 00       	push   $0x1f05
     7c4:	68 90 19 00 00       	push   $0x1990
     7c9:	6a 02                	push   $0x2
     7cb:	e8 f9 0d 00 00       	call   15c9 <printf>
     7d0:	83 c4 10             	add    $0x10,%esp
     7d3:	b8 00 00 00 00       	mov    $0x0,%eax
     7d8:	e9 af 00 00 00       	jmp    88c <doChmodTest+0x19d>
    testmode = st.mode.asInt;
     7dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (mode == testmode) {
     7e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     7e9:	75 3a                	jne    825 <doChmodTest+0x136>
      printf(2, "Error! Unable to test.\n");
     7eb:	83 ec 08             	sub    $0x8,%esp
     7ee:	68 17 1f 00 00       	push   $0x1f17
     7f3:	6a 02                	push   $0x2
     7f5:	e8 cf 0d 00 00       	call   15c9 <printf>
     7fa:	83 c4 10             	add    $0x10,%esp
      printf(2, "\tfile mode (%d) == testmode (%d) for file (%s) in test %d\n",
     7fd:	8b 45 08             	mov    0x8(%ebp),%eax
     800:	8b 00                	mov    (%eax),%eax
     802:	83 ec 08             	sub    $0x8,%esp
     805:	ff 75 f4             	pushl  -0xc(%ebp)
     808:	50                   	push   %eax
     809:	ff 75 e8             	pushl  -0x18(%ebp)
     80c:	ff 75 ec             	pushl  -0x14(%ebp)
     80f:	68 30 1f 00 00       	push   $0x1f30
     814:	6a 02                	push   $0x2
     816:	e8 ae 0d 00 00       	call   15c9 <printf>
     81b:	83 c4 20             	add    $0x20,%esp
		     mode, testmode, cmd[0], i);
      return NOPASS;
     81e:	b8 00 00 00 00       	mov    $0x0,%eax
     823:	eb 67                	jmp    88c <doChmodTest+0x19d>
    }
    if (mode == testmode) { 
     825:	8b 45 ec             	mov    -0x14(%ebp),%eax
     828:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     82b:	75 20                	jne    84d <doChmodTest+0x15e>
      printf(2, "Error! chmod() failed to set permissions correctly. %s, %d\n",
     82d:	68 ba 00 00 00       	push   $0xba
     832:	68 6b 1f 00 00       	push   $0x1f6b
     837:	68 78 1f 00 00       	push   $0x1f78
     83c:	6a 02                	push   $0x2
     83e:	e8 86 0d 00 00       	call   15c9 <printf>
     843:	83 c4 10             	add    $0x10,%esp
		      __FILE__, __LINE__);
      return NOPASS;
     846:	b8 00 00 00 00       	mov    $0x0,%eax
     84b:	eb 3f                	jmp    88c <doChmodTest+0x19d>
  printf(1, "\nExecuting chmod() test.\n\n");

  check(stat(cmd[0], &st));
  mode = st.mode.asInt;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     84d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     851:	a1 60 26 00 00       	mov    0x2660,%eax
     856:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     859:	0f 8c f9 fe ff ff    	jl     758 <doChmodTest+0x69>
      printf(2, "Error! chmod() failed to set permissions correctly. %s, %d\n",
		      __FILE__, __LINE__);
      return NOPASS;
    }
  }
  chmod(cmd[0], 00755); // hack
     85f:	8b 45 08             	mov    0x8(%ebp),%eax
     862:	8b 00                	mov    (%eax),%eax
     864:	83 ec 08             	sub    $0x8,%esp
     867:	68 ed 01 00 00       	push   $0x1ed
     86c:	50                   	push   %eax
     86d:	e8 68 0c 00 00       	call   14da <chmod>
     872:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     875:	83 ec 08             	sub    $0x8,%esp
     878:	68 0d 1c 00 00       	push   $0x1c0d
     87d:	6a 01                	push   $0x1
     87f:	e8 45 0d 00 00       	call   15c9 <printf>
     884:	83 c4 10             	add    $0x10,%esp
  return PASS;
     887:	b8 01 00 00 00       	mov    $0x1,%eax
}
     88c:	c9                   	leave  
     88d:	c3                   	ret    

0000088e <doChownTest>:

static int
doChownTest(char **cmd) 
{
     88e:	55                   	push   %ebp
     88f:	89 e5                	mov    %esp,%ebp
     891:	83 ec 38             	sub    $0x38,%esp
  int rc, uid1, uid2;
  struct stat st;

  printf(1, "\nExecuting chown test.\n\n");
     894:	83 ec 08             	sub    $0x8,%esp
     897:	68 b4 1f 00 00       	push   $0x1fb4
     89c:	6a 01                	push   $0x1
     89e:	e8 26 0d 00 00       	call   15c9 <printf>
     8a3:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     8a6:	8b 45 08             	mov    0x8(%ebp),%eax
     8a9:	8b 00                	mov    (%eax),%eax
     8ab:	83 ec 08             	sub    $0x8,%esp
     8ae:	8d 55 d0             	lea    -0x30(%ebp),%edx
     8b1:	52                   	push   %edx
     8b2:	50                   	push   %eax
     8b3:	e8 cd 09 00 00       	call   1285 <stat>
     8b8:	83 c4 10             	add    $0x10,%esp
  uid1 = st.uid;
     8bb:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
     8bf:	0f b7 c0             	movzwl %ax,%eax
     8c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chown(cmd[0], uid1+1);
     8c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c8:	8d 50 01             	lea    0x1(%eax),%edx
     8cb:	8b 45 08             	mov    0x8(%ebp),%eax
     8ce:	8b 00                	mov    (%eax),%eax
     8d0:	83 ec 08             	sub    $0x8,%esp
     8d3:	52                   	push   %edx
     8d4:	50                   	push   %eax
     8d5:	e8 08 0c 00 00       	call   14e2 <chown>
     8da:	83 c4 10             	add    $0x10,%esp
     8dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     8e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8e4:	74 1c                	je     902 <doChownTest+0x74>
    printf(2, "Error! chown() failed on setting new owner. %d as rc.\n", rc);
     8e6:	83 ec 04             	sub    $0x4,%esp
     8e9:	ff 75 f0             	pushl  -0x10(%ebp)
     8ec:	68 d0 1f 00 00       	push   $0x1fd0
     8f1:	6a 02                	push   $0x2
     8f3:	e8 d1 0c 00 00       	call   15c9 <printf>
     8f8:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     8fb:	b8 00 00 00 00       	mov    $0x0,%eax
     900:	eb 6e                	jmp    970 <doChownTest+0xe2>
  }

  stat(cmd[0], &st);
     902:	8b 45 08             	mov    0x8(%ebp),%eax
     905:	8b 00                	mov    (%eax),%eax
     907:	83 ec 08             	sub    $0x8,%esp
     90a:	8d 55 d0             	lea    -0x30(%ebp),%edx
     90d:	52                   	push   %edx
     90e:	50                   	push   %eax
     90f:	e8 71 09 00 00       	call   1285 <stat>
     914:	83 c4 10             	add    $0x10,%esp
  uid2 = st.uid;
     917:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
     91b:	0f b7 c0             	movzwl %ax,%eax
     91e:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (uid1 == uid2) {
     921:	8b 45 f4             	mov    -0xc(%ebp),%eax
     924:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     927:	75 1c                	jne    945 <doChownTest+0xb7>
    printf(2, "Error! test failed. Old uid: %d, new uid: uid2, should differ\n",
     929:	ff 75 ec             	pushl  -0x14(%ebp)
     92c:	ff 75 f4             	pushl  -0xc(%ebp)
     92f:	68 08 20 00 00       	push   $0x2008
     934:	6a 02                	push   $0x2
     936:	e8 8e 0c 00 00       	call   15c9 <printf>
     93b:	83 c4 10             	add    $0x10,%esp
		    uid1, uid2);
    return NOPASS;
     93e:	b8 00 00 00 00       	mov    $0x0,%eax
     943:	eb 2b                	jmp    970 <doChownTest+0xe2>
  }
  chown(cmd[0], uid1);  // put back the original
     945:	8b 45 08             	mov    0x8(%ebp),%eax
     948:	8b 00                	mov    (%eax),%eax
     94a:	83 ec 08             	sub    $0x8,%esp
     94d:	ff 75 f4             	pushl  -0xc(%ebp)
     950:	50                   	push   %eax
     951:	e8 8c 0b 00 00       	call   14e2 <chown>
     956:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     959:	83 ec 08             	sub    $0x8,%esp
     95c:	68 0d 1c 00 00       	push   $0x1c0d
     961:	6a 01                	push   $0x1
     963:	e8 61 0c 00 00       	call   15c9 <printf>
     968:	83 c4 10             	add    $0x10,%esp
  return PASS;
     96b:	b8 01 00 00 00       	mov    $0x1,%eax
}
     970:	c9                   	leave  
     971:	c3                   	ret    

00000972 <doChgrpTest>:

static int
doChgrpTest(char **cmd) 
{
     972:	55                   	push   %ebp
     973:	89 e5                	mov    %esp,%ebp
     975:	83 ec 38             	sub    $0x38,%esp
  int rc, gid1, gid2;
  struct stat st;

  printf(1, "\nExecuting chgrp test.\n\n");
     978:	83 ec 08             	sub    $0x8,%esp
     97b:	68 47 20 00 00       	push   $0x2047
     980:	6a 01                	push   $0x1
     982:	e8 42 0c 00 00       	call   15c9 <printf>
     987:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     98a:	8b 45 08             	mov    0x8(%ebp),%eax
     98d:	8b 00                	mov    (%eax),%eax
     98f:	83 ec 08             	sub    $0x8,%esp
     992:	8d 55 d0             	lea    -0x30(%ebp),%edx
     995:	52                   	push   %edx
     996:	50                   	push   %eax
     997:	e8 e9 08 00 00       	call   1285 <stat>
     99c:	83 c4 10             	add    $0x10,%esp
  gid1 = st.gid;
     99f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
     9a3:	0f b7 c0             	movzwl %ax,%eax
     9a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chgrp(cmd[0], gid1+1);
     9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9ac:	8d 50 01             	lea    0x1(%eax),%edx
     9af:	8b 45 08             	mov    0x8(%ebp),%eax
     9b2:	8b 00                	mov    (%eax),%eax
     9b4:	83 ec 08             	sub    $0x8,%esp
     9b7:	52                   	push   %edx
     9b8:	50                   	push   %eax
     9b9:	e8 2c 0b 00 00       	call   14ea <chgrp>
     9be:	83 c4 10             	add    $0x10,%esp
     9c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     9c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9c8:	74 19                	je     9e3 <doChgrpTest+0x71>
    printf(2, "Error! chgrp() failed on setting new group.\n");
     9ca:	83 ec 08             	sub    $0x8,%esp
     9cd:	68 60 20 00 00       	push   $0x2060
     9d2:	6a 02                	push   $0x2
     9d4:	e8 f0 0b 00 00       	call   15c9 <printf>
     9d9:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     9dc:	b8 00 00 00 00       	mov    $0x0,%eax
     9e1:	eb 6e                	jmp    a51 <doChgrpTest+0xdf>
  }

  stat(cmd[0], &st);
     9e3:	8b 45 08             	mov    0x8(%ebp),%eax
     9e6:	8b 00                	mov    (%eax),%eax
     9e8:	83 ec 08             	sub    $0x8,%esp
     9eb:	8d 55 d0             	lea    -0x30(%ebp),%edx
     9ee:	52                   	push   %edx
     9ef:	50                   	push   %eax
     9f0:	e8 90 08 00 00       	call   1285 <stat>
     9f5:	83 c4 10             	add    $0x10,%esp
  gid2 = st.gid;
     9f8:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
     9fc:	0f b7 c0             	movzwl %ax,%eax
     9ff:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (gid1 == gid2) {
     a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a05:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a08:	75 1c                	jne    a26 <doChgrpTest+0xb4>
    printf(2, "Error! test failed. Old gid: %d, new gid: gid2, should differ\n",
     a0a:	ff 75 ec             	pushl  -0x14(%ebp)
     a0d:	ff 75 f4             	pushl  -0xc(%ebp)
     a10:	68 90 20 00 00       	push   $0x2090
     a15:	6a 02                	push   $0x2
     a17:	e8 ad 0b 00 00       	call   15c9 <printf>
     a1c:	83 c4 10             	add    $0x10,%esp
                    gid1, gid2);
    return NOPASS;
     a1f:	b8 00 00 00 00       	mov    $0x0,%eax
     a24:	eb 2b                	jmp    a51 <doChgrpTest+0xdf>
  }
  chgrp(cmd[0], gid1);  // put back the original
     a26:	8b 45 08             	mov    0x8(%ebp),%eax
     a29:	8b 00                	mov    (%eax),%eax
     a2b:	83 ec 08             	sub    $0x8,%esp
     a2e:	ff 75 f4             	pushl  -0xc(%ebp)
     a31:	50                   	push   %eax
     a32:	e8 b3 0a 00 00       	call   14ea <chgrp>
     a37:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     a3a:	83 ec 08             	sub    $0x8,%esp
     a3d:	68 0d 1c 00 00       	push   $0x1c0d
     a42:	6a 01                	push   $0x1
     a44:	e8 80 0b 00 00       	call   15c9 <printf>
     a49:	83 c4 10             	add    $0x10,%esp
  return PASS;
     a4c:	b8 01 00 00 00       	mov    $0x1,%eax
}
     a51:	c9                   	leave  
     a52:	c3                   	ret    

00000a53 <doExecTest>:

static int
doExecTest(char **cmd) 
{
     a53:	55                   	push   %ebp
     a54:	89 e5                	mov    %esp,%ebp
     a56:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, gid;
  struct stat st;

  printf(1, "\nExecuting exec test.\n\n");
     a59:	83 ec 08             	sub    $0x8,%esp
     a5c:	68 cf 20 00 00       	push   $0x20cf
     a61:	6a 01                	push   $0x1
     a63:	e8 61 0b 00 00       	call   15c9 <printf>
     a68:	83 c4 10             	add    $0x10,%esp

  if (!canRun(cmd[0])) {
     a6b:	8b 45 08             	mov    0x8(%ebp),%eax
     a6e:	8b 00                	mov    (%eax),%eax
     a70:	83 ec 0c             	sub    $0xc,%esp
     a73:	50                   	push   %eax
     a74:	e8 87 f5 ff ff       	call   0 <canRun>
     a79:	83 c4 10             	add    $0x10,%esp
     a7c:	85 c0                	test   %eax,%eax
     a7e:	75 22                	jne    aa2 <doExecTest+0x4f>
    printf(2, "Unable to run %s. test aborted.\n", cmd[0]);
     a80:	8b 45 08             	mov    0x8(%ebp),%eax
     a83:	8b 00                	mov    (%eax),%eax
     a85:	83 ec 04             	sub    $0x4,%esp
     a88:	50                   	push   %eax
     a89:	68 e8 20 00 00       	push   $0x20e8
     a8e:	6a 02                	push   $0x2
     a90:	e8 34 0b 00 00       	call   15c9 <printf>
     a95:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     a98:	b8 00 00 00 00       	mov    $0x0,%eax
     a9d:	e9 e4 02 00 00       	jmp    d86 <doExecTest+0x333>
  }

  check(stat(cmd[0], &st));
     aa2:	8b 45 08             	mov    0x8(%ebp),%eax
     aa5:	8b 00                	mov    (%eax),%eax
     aa7:	83 ec 08             	sub    $0x8,%esp
     aaa:	8d 55 cc             	lea    -0x34(%ebp),%edx
     aad:	52                   	push   %edx
     aae:	50                   	push   %eax
     aaf:	e8 d1 07 00 00       	call   1285 <stat>
     ab4:	83 c4 10             	add    $0x10,%esp
     ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
     aba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     abe:	74 21                	je     ae1 <doExecTest+0x8e>
     ac0:	83 ec 04             	sub    $0x4,%esp
     ac3:	68 05 1f 00 00       	push   $0x1f05
     ac8:	68 90 19 00 00       	push   $0x1990
     acd:	6a 02                	push   $0x2
     acf:	e8 f5 0a 00 00       	call   15c9 <printf>
     ad4:	83 c4 10             	add    $0x10,%esp
     ad7:	b8 00 00 00 00       	mov    $0x0,%eax
     adc:	e9 a5 02 00 00       	jmp    d86 <doExecTest+0x333>
  uid = st.uid;
     ae1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
     ae5:	0f b7 c0             	movzwl %ax,%eax
     ae8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  gid = st.gid;
     aeb:	0f b7 45 dc          	movzwl -0x24(%ebp),%eax
     aef:	0f b7 c0             	movzwl %ax,%eax
     af2:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     af5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     afc:	e9 22 02 00 00       	jmp    d23 <doExecTest+0x2d0>
    check(setuid(testperms[i][procuid]));
     b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b04:	c1 e0 04             	shl    $0x4,%eax
     b07:	05 80 26 00 00       	add    $0x2680,%eax
     b0c:	8b 00                	mov    (%eax),%eax
     b0e:	83 ec 0c             	sub    $0xc,%esp
     b11:	50                   	push   %eax
     b12:	e8 a3 09 00 00       	call   14ba <setuid>
     b17:	83 c4 10             	add    $0x10,%esp
     b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b21:	74 21                	je     b44 <doExecTest+0xf1>
     b23:	83 ec 04             	sub    $0x4,%esp
     b26:	68 89 1a 00 00       	push   $0x1a89
     b2b:	68 90 19 00 00       	push   $0x1990
     b30:	6a 02                	push   $0x2
     b32:	e8 92 0a 00 00       	call   15c9 <printf>
     b37:	83 c4 10             	add    $0x10,%esp
     b3a:	b8 00 00 00 00       	mov    $0x0,%eax
     b3f:	e9 42 02 00 00       	jmp    d86 <doExecTest+0x333>
    check(setgid(testperms[i][procgid]));
     b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b47:	c1 e0 04             	shl    $0x4,%eax
     b4a:	05 84 26 00 00       	add    $0x2684,%eax
     b4f:	8b 00                	mov    (%eax),%eax
     b51:	83 ec 0c             	sub    $0xc,%esp
     b54:	50                   	push   %eax
     b55:	e8 68 09 00 00       	call   14c2 <setgid>
     b5a:	83 c4 10             	add    $0x10,%esp
     b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b64:	74 21                	je     b87 <doExecTest+0x134>
     b66:	83 ec 04             	sub    $0x4,%esp
     b69:	68 a7 1a 00 00       	push   $0x1aa7
     b6e:	68 90 19 00 00       	push   $0x1990
     b73:	6a 02                	push   $0x2
     b75:	e8 4f 0a 00 00       	call   15c9 <printf>
     b7a:	83 c4 10             	add    $0x10,%esp
     b7d:	b8 00 00 00 00       	mov    $0x0,%eax
     b82:	e9 ff 01 00 00       	jmp    d86 <doExecTest+0x333>
    check(chown(cmd[0], testperms[i][fileuid]));
     b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b8a:	c1 e0 04             	shl    $0x4,%eax
     b8d:	05 88 26 00 00       	add    $0x2688,%eax
     b92:	8b 10                	mov    (%eax),%edx
     b94:	8b 45 08             	mov    0x8(%ebp),%eax
     b97:	8b 00                	mov    (%eax),%eax
     b99:	83 ec 08             	sub    $0x8,%esp
     b9c:	52                   	push   %edx
     b9d:	50                   	push   %eax
     b9e:	e8 3f 09 00 00       	call   14e2 <chown>
     ba3:	83 c4 10             	add    $0x10,%esp
     ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bad:	74 21                	je     bd0 <doExecTest+0x17d>
     baf:	83 ec 04             	sub    $0x4,%esp
     bb2:	68 e0 1a 00 00       	push   $0x1ae0
     bb7:	68 90 19 00 00       	push   $0x1990
     bbc:	6a 02                	push   $0x2
     bbe:	e8 06 0a 00 00       	call   15c9 <printf>
     bc3:	83 c4 10             	add    $0x10,%esp
     bc6:	b8 00 00 00 00       	mov    $0x0,%eax
     bcb:	e9 b6 01 00 00       	jmp    d86 <doExecTest+0x333>
    check(chgrp(cmd[0], testperms[i][filegid]));
     bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bd3:	c1 e0 04             	shl    $0x4,%eax
     bd6:	05 8c 26 00 00       	add    $0x268c,%eax
     bdb:	8b 10                	mov    (%eax),%edx
     bdd:	8b 45 08             	mov    0x8(%ebp),%eax
     be0:	8b 00                	mov    (%eax),%eax
     be2:	83 ec 08             	sub    $0x8,%esp
     be5:	52                   	push   %edx
     be6:	50                   	push   %eax
     be7:	e8 fe 08 00 00       	call   14ea <chgrp>
     bec:	83 c4 10             	add    $0x10,%esp
     bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
     bf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bf6:	74 21                	je     c19 <doExecTest+0x1c6>
     bf8:	83 ec 04             	sub    $0x4,%esp
     bfb:	68 08 1b 00 00       	push   $0x1b08
     c00:	68 90 19 00 00       	push   $0x1990
     c05:	6a 02                	push   $0x2
     c07:	e8 bd 09 00 00       	call   15c9 <printf>
     c0c:	83 c4 10             	add    $0x10,%esp
     c0f:	b8 00 00 00 00       	mov    $0x0,%eax
     c14:	e9 6d 01 00 00       	jmp    d86 <doExecTest+0x333>
    check(chmod(cmd[0], perms[i]));
     c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c1c:	8b 14 85 64 26 00 00 	mov    0x2664(,%eax,4),%edx
     c23:	8b 45 08             	mov    0x8(%ebp),%eax
     c26:	8b 00                	mov    (%eax),%eax
     c28:	83 ec 08             	sub    $0x8,%esp
     c2b:	52                   	push   %edx
     c2c:	50                   	push   %eax
     c2d:	e8 a8 08 00 00       	call   14da <chmod>
     c32:	83 c4 10             	add    $0x10,%esp
     c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
     c38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c3c:	74 21                	je     c5f <doExecTest+0x20c>
     c3e:	83 ec 04             	sub    $0x4,%esp
     c41:	68 44 1b 00 00       	push   $0x1b44
     c46:	68 90 19 00 00       	push   $0x1990
     c4b:	6a 02                	push   $0x2
     c4d:	e8 77 09 00 00       	call   15c9 <printf>
     c52:	83 c4 10             	add    $0x10,%esp
     c55:	b8 00 00 00 00       	mov    $0x0,%eax
     c5a:	e9 27 01 00 00       	jmp    d86 <doExecTest+0x333>
    if (i != NUMPERMSTOCHECK-1)
     c5f:	a1 60 26 00 00       	mov    0x2660,%eax
     c64:	83 e8 01             	sub    $0x1,%eax
     c67:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     c6a:	74 14                	je     c80 <doExecTest+0x22d>
      printf(2, "The following test should not produce an error.\n");
     c6c:	83 ec 08             	sub    $0x8,%esp
     c6f:	68 0c 21 00 00       	push   $0x210c
     c74:	6a 02                	push   $0x2
     c76:	e8 4e 09 00 00       	call   15c9 <printf>
     c7b:	83 c4 10             	add    $0x10,%esp
     c7e:	eb 12                	jmp    c92 <doExecTest+0x23f>
    else
      printf(2, "The following test should fail.\n");
     c80:	83 ec 08             	sub    $0x8,%esp
     c83:	68 40 21 00 00       	push   $0x2140
     c88:	6a 02                	push   $0x2
     c8a:	e8 3a 09 00 00       	call   15c9 <printf>
     c8f:	83 c4 10             	add    $0x10,%esp
    rc = fork();
     c92:	e8 53 07 00 00       	call   13ea <fork>
     c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     c9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c9e:	79 1c                	jns    cbc <doExecTest+0x269>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     ca0:	83 ec 08             	sub    $0x8,%esp
     ca3:	68 74 1b 00 00       	push   $0x1b74
     ca8:	6a 02                	push   $0x2
     caa:	e8 1a 09 00 00       	call   15c9 <printf>
     caf:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     cb2:	b8 00 00 00 00       	mov    $0x0,%eax
     cb7:	e9 ca 00 00 00       	jmp    d86 <doExecTest+0x333>
    }
    if (rc == 0) {   // child
     cbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cc0:	75 58                	jne    d1a <doExecTest+0x2c7>
      exec(cmd[0], cmd);
     cc2:	8b 45 08             	mov    0x8(%ebp),%eax
     cc5:	8b 00                	mov    (%eax),%eax
     cc7:	83 ec 08             	sub    $0x8,%esp
     cca:	ff 75 08             	pushl  0x8(%ebp)
     ccd:	50                   	push   %eax
     cce:	e8 57 07 00 00       	call   142a <exec>
     cd3:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     cd6:	a1 60 26 00 00       	mov    0x2660,%eax
     cdb:	83 e8 01             	sub    $0x1,%eax
     cde:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     ce1:	74 1a                	je     cfd <doExecTest+0x2aa>
     ce3:	8b 45 08             	mov    0x8(%ebp),%eax
     ce6:	8b 00                	mov    (%eax),%eax
     ce8:	83 ec 04             	sub    $0x4,%esp
     ceb:	50                   	push   %eax
     cec:	68 bc 1b 00 00       	push   $0x1bbc
     cf1:	6a 02                	push   $0x2
     cf3:	e8 d1 08 00 00       	call   15c9 <printf>
     cf8:	83 c4 10             	add    $0x10,%esp
     cfb:	eb 18                	jmp    d15 <doExecTest+0x2c2>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     cfd:	8b 45 08             	mov    0x8(%ebp),%eax
     d00:	8b 00                	mov    (%eax),%eax
     d02:	83 ec 04             	sub    $0x4,%esp
     d05:	50                   	push   %eax
     d06:	68 e0 1b 00 00       	push   $0x1be0
     d0b:	6a 02                	push   $0x2
     d0d:	e8 b7 08 00 00       	call   15c9 <printf>
     d12:	83 c4 10             	add    $0x10,%esp
      exit();
     d15:	e8 d8 06 00 00       	call   13f2 <exit>
    }
    wait();
     d1a:	e8 db 06 00 00       	call   13fa <wait>

  check(stat(cmd[0], &st));
  uid = st.uid;
  gid = st.gid;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     d1f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d23:	a1 60 26 00 00       	mov    0x2660,%eax
     d28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     d2b:	0f 8c d0 fd ff ff    	jl     b01 <doExecTest+0xae>
      exit();
    }
    wait();
  }
  
  chown(cmd[0], uid);
     d31:	8b 45 08             	mov    0x8(%ebp),%eax
     d34:	8b 00                	mov    (%eax),%eax
     d36:	83 ec 08             	sub    $0x8,%esp
     d39:	ff 75 ec             	pushl  -0x14(%ebp)
     d3c:	50                   	push   %eax
     d3d:	e8 a0 07 00 00       	call   14e2 <chown>
     d42:	83 c4 10             	add    $0x10,%esp
  chgrp(cmd[0], gid);
     d45:	8b 45 08             	mov    0x8(%ebp),%eax
     d48:	8b 00                	mov    (%eax),%eax
     d4a:	83 ec 08             	sub    $0x8,%esp
     d4d:	ff 75 e8             	pushl  -0x18(%ebp)
     d50:	50                   	push   %eax
     d51:	e8 94 07 00 00       	call   14ea <chgrp>
     d56:	83 c4 10             	add    $0x10,%esp
  chmod(cmd[0], 00755);
     d59:	8b 45 08             	mov    0x8(%ebp),%eax
     d5c:	8b 00                	mov    (%eax),%eax
     d5e:	83 ec 08             	sub    $0x8,%esp
     d61:	68 ed 01 00 00       	push   $0x1ed
     d66:	50                   	push   %eax
     d67:	e8 6e 07 00 00       	call   14da <chmod>
     d6c:	83 c4 10             	add    $0x10,%esp
  printf(1, "Requires user visually confirms PASS/FAIL\n");
     d6f:	83 ec 08             	sub    $0x8,%esp
     d72:	68 64 21 00 00       	push   $0x2164
     d77:	6a 01                	push   $0x1
     d79:	e8 4b 08 00 00       	call   15c9 <printf>
     d7e:	83 c4 10             	add    $0x10,%esp
  return PASS;
     d81:	b8 01 00 00 00       	mov    $0x1,%eax
}
     d86:	c9                   	leave  
     d87:	c3                   	ret    

00000d88 <printMenu>:

void
printMenu(void)
{
     d88:	55                   	push   %ebp
     d89:	89 e5                	mov    %esp,%ebp
     d8b:	83 ec 18             	sub    $0x18,%esp
  int i = 0;
     d8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  printf(1, "\n");
     d95:	83 ec 08             	sub    $0x8,%esp
     d98:	68 8f 21 00 00       	push   $0x218f
     d9d:	6a 01                	push   $0x1
     d9f:	e8 25 08 00 00       	call   15c9 <printf>
     da4:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exit program\n", i++);
     da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     daa:	8d 50 01             	lea    0x1(%eax),%edx
     dad:	89 55 f4             	mov    %edx,-0xc(%ebp)
     db0:	83 ec 04             	sub    $0x4,%esp
     db3:	50                   	push   %eax
     db4:	68 91 21 00 00       	push   $0x2191
     db9:	6a 01                	push   $0x1
     dbb:	e8 09 08 00 00       	call   15c9 <printf>
     dc0:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc UID\n", i++);
     dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dc6:	8d 50 01             	lea    0x1(%eax),%edx
     dc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dcc:	83 ec 04             	sub    $0x4,%esp
     dcf:	50                   	push   %eax
     dd0:	68 a3 21 00 00       	push   $0x21a3
     dd5:	6a 01                	push   $0x1
     dd7:	e8 ed 07 00 00       	call   15c9 <printf>
     ddc:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc GID\n", i++);
     ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de2:	8d 50 01             	lea    0x1(%eax),%edx
     de5:	89 55 f4             	mov    %edx,-0xc(%ebp)
     de8:	83 ec 04             	sub    $0x4,%esp
     deb:	50                   	push   %eax
     dec:	68 b1 21 00 00       	push   $0x21b1
     df1:	6a 01                	push   $0x1
     df3:	e8 d1 07 00 00       	call   15c9 <printf>
     df8:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chmod()\n", i++);
     dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dfe:	8d 50 01             	lea    0x1(%eax),%edx
     e01:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e04:	83 ec 04             	sub    $0x4,%esp
     e07:	50                   	push   %eax
     e08:	68 bf 21 00 00       	push   $0x21bf
     e0d:	6a 01                	push   $0x1
     e0f:	e8 b5 07 00 00       	call   15c9 <printf>
     e14:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chown()\n", i++);
     e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e1a:	8d 50 01             	lea    0x1(%eax),%edx
     e1d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e20:	83 ec 04             	sub    $0x4,%esp
     e23:	50                   	push   %eax
     e24:	68 cc 21 00 00       	push   $0x21cc
     e29:	6a 01                	push   $0x1
     e2b:	e8 99 07 00 00       	call   15c9 <printf>
     e30:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chgrp()\n", i++);
     e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e36:	8d 50 01             	lea    0x1(%eax),%edx
     e39:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e3c:	83 ec 04             	sub    $0x4,%esp
     e3f:	50                   	push   %eax
     e40:	68 d9 21 00 00       	push   $0x21d9
     e45:	6a 01                	push   $0x1
     e47:	e8 7d 07 00 00       	call   15c9 <printf>
     e4c:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exec()\n", i++);
     e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e52:	8d 50 01             	lea    0x1(%eax),%edx
     e55:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e58:	83 ec 04             	sub    $0x4,%esp
     e5b:	50                   	push   %eax
     e5c:	68 e6 21 00 00       	push   $0x21e6
     e61:	6a 01                	push   $0x1
     e63:	e8 61 07 00 00       	call   15c9 <printf>
     e68:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. setuid\n", i++);
     e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e6e:	8d 50 01             	lea    0x1(%eax),%edx
     e71:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e74:	83 ec 04             	sub    $0x4,%esp
     e77:	50                   	push   %eax
     e78:	68 f2 21 00 00       	push   $0x21f2
     e7d:	6a 01                	push   $0x1
     e7f:	e8 45 07 00 00       	call   15c9 <printf>
     e84:	83 c4 10             	add    $0x10,%esp
}
     e87:	90                   	nop
     e88:	c9                   	leave  
     e89:	c3                   	ret    

00000e8a <main>:

int
main(int argc, char *argv[])
{
     e8a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     e8e:	83 e4 f0             	and    $0xfffffff0,%esp
     e91:	ff 71 fc             	pushl  -0x4(%ecx)
     e94:	55                   	push   %ebp
     e95:	89 e5                	mov    %esp,%ebp
     e97:	51                   	push   %ecx
     e98:	83 ec 24             	sub    $0x24,%esp
  int rc, select, done;
  char buf[5];

  // test strings
  char *t0[] = {'\0'}; // dummy
     e9b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  char *t1[] = {"testsetuid", '\0'};
     ea2:	c7 45 d8 fe 21 00 00 	movl   $0x21fe,-0x28(%ebp)
     ea9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

  while (1) {
    done = FALSE;
     eb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    printMenu();
     eb7:	e8 cc fe ff ff       	call   d88 <printMenu>
    printf(1, "Enter test number: ");
     ebc:	83 ec 08             	sub    $0x8,%esp
     ebf:	68 09 22 00 00       	push   $0x2209
     ec4:	6a 01                	push   $0x1
     ec6:	e8 fe 06 00 00       	call   15c9 <printf>
     ecb:	83 c4 10             	add    $0x10,%esp
    gets(buf, 5);
     ece:	83 ec 08             	sub    $0x8,%esp
     ed1:	6a 05                	push   $0x5
     ed3:	8d 45 e7             	lea    -0x19(%ebp),%eax
     ed6:	50                   	push   %eax
     ed7:	e8 3a 03 00 00       	call   1216 <gets>
     edc:	83 c4 10             	add    $0x10,%esp
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
     edf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ee3:	3c 0a                	cmp    $0xa,%al
     ee5:	0f 84 f5 01 00 00    	je     10e0 <main+0x256>
     eeb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     eef:	84 c0                	test   %al,%al
     ef1:	0f 84 e9 01 00 00    	je     10e0 <main+0x256>
    select = atoi(buf);
     ef7:	83 ec 0c             	sub    $0xc,%esp
     efa:	8d 45 e7             	lea    -0x19(%ebp),%eax
     efd:	50                   	push   %eax
     efe:	e8 cf 03 00 00       	call   12d2 <atoi>
     f03:	83 c4 10             	add    $0x10,%esp
     f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch (select) {
     f09:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
     f0d:	0f 87 9b 01 00 00    	ja     10ae <main+0x224>
     f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f16:	c1 e0 02             	shl    $0x2,%eax
     f19:	05 ac 22 00 00       	add    $0x22ac,%eax
     f1e:	8b 00                	mov    (%eax),%eax
     f20:	ff e0                	jmp    *%eax
	    case 0: done = TRUE; break;
     f22:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     f29:	e9 a7 01 00 00       	jmp    10d5 <main+0x24b>
	    case 1: doTest(doUidTest,    t0); break;
     f2e:	83 ec 0c             	sub    $0xc,%esp
     f31:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f34:	50                   	push   %eax
     f35:	e8 a3 f4 ff ff       	call   3dd <doUidTest>
     f3a:	83 c4 10             	add    $0x10,%esp
     f3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f44:	0f 85 78 01 00 00    	jne    10c2 <main+0x238>
     f4a:	83 ec 04             	sub    $0x4,%esp
     f4d:	68 1d 22 00 00       	push   $0x221d
     f52:	68 27 22 00 00       	push   $0x2227
     f57:	6a 02                	push   $0x2
     f59:	e8 6b 06 00 00       	call   15c9 <printf>
     f5e:	83 c4 10             	add    $0x10,%esp
     f61:	e8 8c 04 00 00       	call   13f2 <exit>
	    case 2: doTest(doGidTest,    t0); break;
     f66:	83 ec 0c             	sub    $0xc,%esp
     f69:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f6c:	50                   	push   %eax
     f6d:	e8 f4 f5 ff ff       	call   566 <doGidTest>
     f72:	83 c4 10             	add    $0x10,%esp
     f75:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f78:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f7c:	0f 85 43 01 00 00    	jne    10c5 <main+0x23b>
     f82:	83 ec 04             	sub    $0x4,%esp
     f85:	68 39 22 00 00       	push   $0x2239
     f8a:	68 27 22 00 00       	push   $0x2227
     f8f:	6a 02                	push   $0x2
     f91:	e8 33 06 00 00       	call   15c9 <printf>
     f96:	83 c4 10             	add    $0x10,%esp
     f99:	e8 54 04 00 00       	call   13f2 <exit>
	    case 3: doTest(doChmodTest,  t1); break;
     f9e:	83 ec 0c             	sub    $0xc,%esp
     fa1:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fa4:	50                   	push   %eax
     fa5:	e8 45 f7 ff ff       	call   6ef <doChmodTest>
     faa:	83 c4 10             	add    $0x10,%esp
     fad:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fb4:	0f 85 0e 01 00 00    	jne    10c8 <main+0x23e>
     fba:	83 ec 04             	sub    $0x4,%esp
     fbd:	68 43 22 00 00       	push   $0x2243
     fc2:	68 27 22 00 00       	push   $0x2227
     fc7:	6a 02                	push   $0x2
     fc9:	e8 fb 05 00 00       	call   15c9 <printf>
     fce:	83 c4 10             	add    $0x10,%esp
     fd1:	e8 1c 04 00 00       	call   13f2 <exit>
	    case 4: doTest(doChownTest,  t1); break;
     fd6:	83 ec 0c             	sub    $0xc,%esp
     fd9:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fdc:	50                   	push   %eax
     fdd:	e8 ac f8 ff ff       	call   88e <doChownTest>
     fe2:	83 c4 10             	add    $0x10,%esp
     fe5:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fe8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fec:	0f 85 d9 00 00 00    	jne    10cb <main+0x241>
     ff2:	83 ec 04             	sub    $0x4,%esp
     ff5:	68 4f 22 00 00       	push   $0x224f
     ffa:	68 27 22 00 00       	push   $0x2227
     fff:	6a 02                	push   $0x2
    1001:	e8 c3 05 00 00       	call   15c9 <printf>
    1006:	83 c4 10             	add    $0x10,%esp
    1009:	e8 e4 03 00 00       	call   13f2 <exit>
	    case 5: doTest(doChgrpTest,  t1); break;
    100e:	83 ec 0c             	sub    $0xc,%esp
    1011:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1014:	50                   	push   %eax
    1015:	e8 58 f9 ff ff       	call   972 <doChgrpTest>
    101a:	83 c4 10             	add    $0x10,%esp
    101d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1020:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1024:	0f 85 a4 00 00 00    	jne    10ce <main+0x244>
    102a:	83 ec 04             	sub    $0x4,%esp
    102d:	68 5b 22 00 00       	push   $0x225b
    1032:	68 27 22 00 00       	push   $0x2227
    1037:	6a 02                	push   $0x2
    1039:	e8 8b 05 00 00       	call   15c9 <printf>
    103e:	83 c4 10             	add    $0x10,%esp
    1041:	e8 ac 03 00 00       	call   13f2 <exit>
	    case 6: doTest(doExecTest,   t1); break;
    1046:	83 ec 0c             	sub    $0xc,%esp
    1049:	8d 45 d8             	lea    -0x28(%ebp),%eax
    104c:	50                   	push   %eax
    104d:	e8 01 fa ff ff       	call   a53 <doExecTest>
    1052:	83 c4 10             	add    $0x10,%esp
    1055:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1058:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    105c:	75 73                	jne    10d1 <main+0x247>
    105e:	83 ec 04             	sub    $0x4,%esp
    1061:	68 67 22 00 00       	push   $0x2267
    1066:	68 27 22 00 00       	push   $0x2227
    106b:	6a 02                	push   $0x2
    106d:	e8 57 05 00 00       	call   15c9 <printf>
    1072:	83 c4 10             	add    $0x10,%esp
    1075:	e8 78 03 00 00       	call   13f2 <exit>
	    case 7: doTest(doSetuidTest, t1); break;
    107a:	83 ec 0c             	sub    $0xc,%esp
    107d:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1080:	50                   	push   %eax
    1081:	e8 65 f0 ff ff       	call   eb <doSetuidTest>
    1086:	83 c4 10             	add    $0x10,%esp
    1089:	89 45 ec             	mov    %eax,-0x14(%ebp)
    108c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1090:	75 42                	jne    10d4 <main+0x24a>
    1092:	83 ec 04             	sub    $0x4,%esp
    1095:	68 72 22 00 00       	push   $0x2272
    109a:	68 27 22 00 00       	push   $0x2227
    109f:	6a 02                	push   $0x2
    10a1:	e8 23 05 00 00       	call   15c9 <printf>
    10a6:	83 c4 10             	add    $0x10,%esp
    10a9:	e8 44 03 00 00       	call   13f2 <exit>
	    default:
		   printf(1, "Error:invalid test number.\n");
    10ae:	83 ec 08             	sub    $0x8,%esp
    10b1:	68 7f 22 00 00       	push   $0x227f
    10b6:	6a 01                	push   $0x1
    10b8:	e8 0c 05 00 00       	call   15c9 <printf>
    10bd:	83 c4 10             	add    $0x10,%esp
    10c0:	eb 13                	jmp    10d5 <main+0x24b>
    gets(buf, 5);
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    select = atoi(buf);
    switch (select) {
	    case 0: done = TRUE; break;
	    case 1: doTest(doUidTest,    t0); break;
    10c2:	90                   	nop
    10c3:	eb 10                	jmp    10d5 <main+0x24b>
	    case 2: doTest(doGidTest,    t0); break;
    10c5:	90                   	nop
    10c6:	eb 0d                	jmp    10d5 <main+0x24b>
	    case 3: doTest(doChmodTest,  t1); break;
    10c8:	90                   	nop
    10c9:	eb 0a                	jmp    10d5 <main+0x24b>
	    case 4: doTest(doChownTest,  t1); break;
    10cb:	90                   	nop
    10cc:	eb 07                	jmp    10d5 <main+0x24b>
	    case 5: doTest(doChgrpTest,  t1); break;
    10ce:	90                   	nop
    10cf:	eb 04                	jmp    10d5 <main+0x24b>
	    case 6: doTest(doExecTest,   t1); break;
    10d1:	90                   	nop
    10d2:	eb 01                	jmp    10d5 <main+0x24b>
	    case 7: doTest(doSetuidTest, t1); break;
    10d4:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10d9:	75 0b                	jne    10e6 <main+0x25c>
    10db:	e9 d0 fd ff ff       	jmp    eb0 <main+0x26>
  while (1) {
    done = FALSE;
    printMenu();
    printf(1, "Enter test number: ");
    gets(buf, 5);
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    10e0:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
  }
    10e1:	e9 ca fd ff ff       	jmp    eb0 <main+0x26>
	    case 7: doTest(doSetuidTest, t1); break;
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10e6:	90                   	nop
  }

  printf(1, "\nDone for now\n");
    10e7:	83 ec 08             	sub    $0x8,%esp
    10ea:	68 9b 22 00 00       	push   $0x229b
    10ef:	6a 01                	push   $0x1
    10f1:	e8 d3 04 00 00       	call   15c9 <printf>
    10f6:	83 c4 10             	add    $0x10,%esp
  free(buf);
    10f9:	83 ec 0c             	sub    $0xc,%esp
    10fc:	8d 45 e7             	lea    -0x19(%ebp),%eax
    10ff:	50                   	push   %eax
    1100:	e8 55 06 00 00       	call   175a <free>
    1105:	83 c4 10             	add    $0x10,%esp
  exit();
    1108:	e8 e5 02 00 00       	call   13f2 <exit>

0000110d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    110d:	55                   	push   %ebp
    110e:	89 e5                	mov    %esp,%ebp
    1110:	57                   	push   %edi
    1111:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1112:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1115:	8b 55 10             	mov    0x10(%ebp),%edx
    1118:	8b 45 0c             	mov    0xc(%ebp),%eax
    111b:	89 cb                	mov    %ecx,%ebx
    111d:	89 df                	mov    %ebx,%edi
    111f:	89 d1                	mov    %edx,%ecx
    1121:	fc                   	cld    
    1122:	f3 aa                	rep stos %al,%es:(%edi)
    1124:	89 ca                	mov    %ecx,%edx
    1126:	89 fb                	mov    %edi,%ebx
    1128:	89 5d 08             	mov    %ebx,0x8(%ebp)
    112b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    112e:	90                   	nop
    112f:	5b                   	pop    %ebx
    1130:	5f                   	pop    %edi
    1131:	5d                   	pop    %ebp
    1132:	c3                   	ret    

00001133 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1133:	55                   	push   %ebp
    1134:	89 e5                	mov    %esp,%ebp
    1136:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1139:	8b 45 08             	mov    0x8(%ebp),%eax
    113c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    113f:	90                   	nop
    1140:	8b 45 08             	mov    0x8(%ebp),%eax
    1143:	8d 50 01             	lea    0x1(%eax),%edx
    1146:	89 55 08             	mov    %edx,0x8(%ebp)
    1149:	8b 55 0c             	mov    0xc(%ebp),%edx
    114c:	8d 4a 01             	lea    0x1(%edx),%ecx
    114f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1152:	0f b6 12             	movzbl (%edx),%edx
    1155:	88 10                	mov    %dl,(%eax)
    1157:	0f b6 00             	movzbl (%eax),%eax
    115a:	84 c0                	test   %al,%al
    115c:	75 e2                	jne    1140 <strcpy+0xd>
    ;
  return os;
    115e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1161:	c9                   	leave  
    1162:	c3                   	ret    

00001163 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1163:	55                   	push   %ebp
    1164:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1166:	eb 08                	jmp    1170 <strcmp+0xd>
    p++, q++;
    1168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1170:	8b 45 08             	mov    0x8(%ebp),%eax
    1173:	0f b6 00             	movzbl (%eax),%eax
    1176:	84 c0                	test   %al,%al
    1178:	74 10                	je     118a <strcmp+0x27>
    117a:	8b 45 08             	mov    0x8(%ebp),%eax
    117d:	0f b6 10             	movzbl (%eax),%edx
    1180:	8b 45 0c             	mov    0xc(%ebp),%eax
    1183:	0f b6 00             	movzbl (%eax),%eax
    1186:	38 c2                	cmp    %al,%dl
    1188:	74 de                	je     1168 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    118a:	8b 45 08             	mov    0x8(%ebp),%eax
    118d:	0f b6 00             	movzbl (%eax),%eax
    1190:	0f b6 d0             	movzbl %al,%edx
    1193:	8b 45 0c             	mov    0xc(%ebp),%eax
    1196:	0f b6 00             	movzbl (%eax),%eax
    1199:	0f b6 c0             	movzbl %al,%eax
    119c:	29 c2                	sub    %eax,%edx
    119e:	89 d0                	mov    %edx,%eax
}
    11a0:	5d                   	pop    %ebp
    11a1:	c3                   	ret    

000011a2 <strlen>:

uint
strlen(char *s)
{
    11a2:	55                   	push   %ebp
    11a3:	89 e5                	mov    %esp,%ebp
    11a5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11af:	eb 04                	jmp    11b5 <strlen+0x13>
    11b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11b8:	8b 45 08             	mov    0x8(%ebp),%eax
    11bb:	01 d0                	add    %edx,%eax
    11bd:	0f b6 00             	movzbl (%eax),%eax
    11c0:	84 c0                	test   %al,%al
    11c2:	75 ed                	jne    11b1 <strlen+0xf>
    ;
  return n;
    11c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11c7:	c9                   	leave  
    11c8:	c3                   	ret    

000011c9 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11c9:	55                   	push   %ebp
    11ca:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    11cc:	8b 45 10             	mov    0x10(%ebp),%eax
    11cf:	50                   	push   %eax
    11d0:	ff 75 0c             	pushl  0xc(%ebp)
    11d3:	ff 75 08             	pushl  0x8(%ebp)
    11d6:	e8 32 ff ff ff       	call   110d <stosb>
    11db:	83 c4 0c             	add    $0xc,%esp
  return dst;
    11de:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11e1:	c9                   	leave  
    11e2:	c3                   	ret    

000011e3 <strchr>:

char*
strchr(const char *s, char c)
{
    11e3:	55                   	push   %ebp
    11e4:	89 e5                	mov    %esp,%ebp
    11e6:	83 ec 04             	sub    $0x4,%esp
    11e9:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ec:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11ef:	eb 14                	jmp    1205 <strchr+0x22>
    if(*s == c)
    11f1:	8b 45 08             	mov    0x8(%ebp),%eax
    11f4:	0f b6 00             	movzbl (%eax),%eax
    11f7:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11fa:	75 05                	jne    1201 <strchr+0x1e>
      return (char*)s;
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
    11ff:	eb 13                	jmp    1214 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1201:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1205:	8b 45 08             	mov    0x8(%ebp),%eax
    1208:	0f b6 00             	movzbl (%eax),%eax
    120b:	84 c0                	test   %al,%al
    120d:	75 e2                	jne    11f1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1214:	c9                   	leave  
    1215:	c3                   	ret    

00001216 <gets>:

char*
gets(char *buf, int max)
{
    1216:	55                   	push   %ebp
    1217:	89 e5                	mov    %esp,%ebp
    1219:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    121c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1223:	eb 42                	jmp    1267 <gets+0x51>
    cc = read(0, &c, 1);
    1225:	83 ec 04             	sub    $0x4,%esp
    1228:	6a 01                	push   $0x1
    122a:	8d 45 ef             	lea    -0x11(%ebp),%eax
    122d:	50                   	push   %eax
    122e:	6a 00                	push   $0x0
    1230:	e8 d5 01 00 00       	call   140a <read>
    1235:	83 c4 10             	add    $0x10,%esp
    1238:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    123b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    123f:	7e 33                	jle    1274 <gets+0x5e>
      break;
    buf[i++] = c;
    1241:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1244:	8d 50 01             	lea    0x1(%eax),%edx
    1247:	89 55 f4             	mov    %edx,-0xc(%ebp)
    124a:	89 c2                	mov    %eax,%edx
    124c:	8b 45 08             	mov    0x8(%ebp),%eax
    124f:	01 c2                	add    %eax,%edx
    1251:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1255:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1257:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    125b:	3c 0a                	cmp    $0xa,%al
    125d:	74 16                	je     1275 <gets+0x5f>
    125f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1263:	3c 0d                	cmp    $0xd,%al
    1265:	74 0e                	je     1275 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1267:	8b 45 f4             	mov    -0xc(%ebp),%eax
    126a:	83 c0 01             	add    $0x1,%eax
    126d:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1270:	7c b3                	jl     1225 <gets+0xf>
    1272:	eb 01                	jmp    1275 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1274:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1275:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1278:	8b 45 08             	mov    0x8(%ebp),%eax
    127b:	01 d0                	add    %edx,%eax
    127d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1280:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1283:	c9                   	leave  
    1284:	c3                   	ret    

00001285 <stat>:

int
stat(char *n, struct stat *st)
{
    1285:	55                   	push   %ebp
    1286:	89 e5                	mov    %esp,%ebp
    1288:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    128b:	83 ec 08             	sub    $0x8,%esp
    128e:	6a 00                	push   $0x0
    1290:	ff 75 08             	pushl  0x8(%ebp)
    1293:	e8 9a 01 00 00       	call   1432 <open>
    1298:	83 c4 10             	add    $0x10,%esp
    129b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    129e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12a2:	79 07                	jns    12ab <stat+0x26>
    return -1;
    12a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12a9:	eb 25                	jmp    12d0 <stat+0x4b>
  r = fstat(fd, st);
    12ab:	83 ec 08             	sub    $0x8,%esp
    12ae:	ff 75 0c             	pushl  0xc(%ebp)
    12b1:	ff 75 f4             	pushl  -0xc(%ebp)
    12b4:	e8 91 01 00 00       	call   144a <fstat>
    12b9:	83 c4 10             	add    $0x10,%esp
    12bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12bf:	83 ec 0c             	sub    $0xc,%esp
    12c2:	ff 75 f4             	pushl  -0xc(%ebp)
    12c5:	e8 50 01 00 00       	call   141a <close>
    12ca:	83 c4 10             	add    $0x10,%esp
  return r;
    12cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12d0:	c9                   	leave  
    12d1:	c3                   	ret    

000012d2 <atoi>:

int
atoi(const char *s)
{
    12d2:	55                   	push   %ebp
    12d3:	89 e5                	mov    %esp,%ebp
    12d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12df:	eb 25                	jmp    1306 <atoi+0x34>
    n = n*10 + *s++ - '0';
    12e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12e4:	89 d0                	mov    %edx,%eax
    12e6:	c1 e0 02             	shl    $0x2,%eax
    12e9:	01 d0                	add    %edx,%eax
    12eb:	01 c0                	add    %eax,%eax
    12ed:	89 c1                	mov    %eax,%ecx
    12ef:	8b 45 08             	mov    0x8(%ebp),%eax
    12f2:	8d 50 01             	lea    0x1(%eax),%edx
    12f5:	89 55 08             	mov    %edx,0x8(%ebp)
    12f8:	0f b6 00             	movzbl (%eax),%eax
    12fb:	0f be c0             	movsbl %al,%eax
    12fe:	01 c8                	add    %ecx,%eax
    1300:	83 e8 30             	sub    $0x30,%eax
    1303:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1306:	8b 45 08             	mov    0x8(%ebp),%eax
    1309:	0f b6 00             	movzbl (%eax),%eax
    130c:	3c 2f                	cmp    $0x2f,%al
    130e:	7e 0a                	jle    131a <atoi+0x48>
    1310:	8b 45 08             	mov    0x8(%ebp),%eax
    1313:	0f b6 00             	movzbl (%eax),%eax
    1316:	3c 39                	cmp    $0x39,%al
    1318:	7e c7                	jle    12e1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    131a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    131d:	c9                   	leave  
    131e:	c3                   	ret    

0000131f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    131f:	55                   	push   %ebp
    1320:	89 e5                	mov    %esp,%ebp
    1322:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1325:	8b 45 08             	mov    0x8(%ebp),%eax
    1328:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    132b:	8b 45 0c             	mov    0xc(%ebp),%eax
    132e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1331:	eb 17                	jmp    134a <memmove+0x2b>
    *dst++ = *src++;
    1333:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1336:	8d 50 01             	lea    0x1(%eax),%edx
    1339:	89 55 fc             	mov    %edx,-0x4(%ebp)
    133c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    133f:	8d 4a 01             	lea    0x1(%edx),%ecx
    1342:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1345:	0f b6 12             	movzbl (%edx),%edx
    1348:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    134a:	8b 45 10             	mov    0x10(%ebp),%eax
    134d:	8d 50 ff             	lea    -0x1(%eax),%edx
    1350:	89 55 10             	mov    %edx,0x10(%ebp)
    1353:	85 c0                	test   %eax,%eax
    1355:	7f dc                	jg     1333 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1357:	8b 45 08             	mov    0x8(%ebp),%eax
}
    135a:	c9                   	leave  
    135b:	c3                   	ret    

0000135c <atoo>:

int
atoo(const char *s)
{
    135c:	55                   	push   %ebp
    135d:	89 e5                	mov    %esp,%ebp
    135f:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    1362:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
    1369:	eb 04                	jmp    136f <atoo+0x13>
    136b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    136f:	8b 45 08             	mov    0x8(%ebp),%eax
    1372:	0f b6 00             	movzbl (%eax),%eax
    1375:	3c 20                	cmp    $0x20,%al
    1377:	74 f2                	je     136b <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
    1379:	8b 45 08             	mov    0x8(%ebp),%eax
    137c:	0f b6 00             	movzbl (%eax),%eax
    137f:	3c 2d                	cmp    $0x2d,%al
    1381:	75 07                	jne    138a <atoo+0x2e>
    1383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1388:	eb 05                	jmp    138f <atoo+0x33>
    138a:	b8 01 00 00 00       	mov    $0x1,%eax
    138f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    1392:	8b 45 08             	mov    0x8(%ebp),%eax
    1395:	0f b6 00             	movzbl (%eax),%eax
    1398:	3c 2b                	cmp    $0x2b,%al
    139a:	74 0a                	je     13a6 <atoo+0x4a>
    139c:	8b 45 08             	mov    0x8(%ebp),%eax
    139f:	0f b6 00             	movzbl (%eax),%eax
    13a2:	3c 2d                	cmp    $0x2d,%al
    13a4:	75 27                	jne    13cd <atoo+0x71>
    s++;
    13a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
    13aa:	eb 21                	jmp    13cd <atoo+0x71>
    n = n*8 + *s++ - '0';
    13ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13af:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
    13b6:	8b 45 08             	mov    0x8(%ebp),%eax
    13b9:	8d 50 01             	lea    0x1(%eax),%edx
    13bc:	89 55 08             	mov    %edx,0x8(%ebp)
    13bf:	0f b6 00             	movzbl (%eax),%eax
    13c2:	0f be c0             	movsbl %al,%eax
    13c5:	01 c8                	add    %ecx,%eax
    13c7:	83 e8 30             	sub    $0x30,%eax
    13ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
    13cd:	8b 45 08             	mov    0x8(%ebp),%eax
    13d0:	0f b6 00             	movzbl (%eax),%eax
    13d3:	3c 2f                	cmp    $0x2f,%al
    13d5:	7e 0a                	jle    13e1 <atoo+0x85>
    13d7:	8b 45 08             	mov    0x8(%ebp),%eax
    13da:	0f b6 00             	movzbl (%eax),%eax
    13dd:	3c 37                	cmp    $0x37,%al
    13df:	7e cb                	jle    13ac <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
    13e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13e4:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    13e8:	c9                   	leave  
    13e9:	c3                   	ret    

000013ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13ea:	b8 01 00 00 00       	mov    $0x1,%eax
    13ef:	cd 40                	int    $0x40
    13f1:	c3                   	ret    

000013f2 <exit>:
SYSCALL(exit)
    13f2:	b8 02 00 00 00       	mov    $0x2,%eax
    13f7:	cd 40                	int    $0x40
    13f9:	c3                   	ret    

000013fa <wait>:
SYSCALL(wait)
    13fa:	b8 03 00 00 00       	mov    $0x3,%eax
    13ff:	cd 40                	int    $0x40
    1401:	c3                   	ret    

00001402 <pipe>:
SYSCALL(pipe)
    1402:	b8 04 00 00 00       	mov    $0x4,%eax
    1407:	cd 40                	int    $0x40
    1409:	c3                   	ret    

0000140a <read>:
SYSCALL(read)
    140a:	b8 05 00 00 00       	mov    $0x5,%eax
    140f:	cd 40                	int    $0x40
    1411:	c3                   	ret    

00001412 <write>:
SYSCALL(write)
    1412:	b8 10 00 00 00       	mov    $0x10,%eax
    1417:	cd 40                	int    $0x40
    1419:	c3                   	ret    

0000141a <close>:
SYSCALL(close)
    141a:	b8 15 00 00 00       	mov    $0x15,%eax
    141f:	cd 40                	int    $0x40
    1421:	c3                   	ret    

00001422 <kill>:
SYSCALL(kill)
    1422:	b8 06 00 00 00       	mov    $0x6,%eax
    1427:	cd 40                	int    $0x40
    1429:	c3                   	ret    

0000142a <exec>:
SYSCALL(exec)
    142a:	b8 07 00 00 00       	mov    $0x7,%eax
    142f:	cd 40                	int    $0x40
    1431:	c3                   	ret    

00001432 <open>:
SYSCALL(open)
    1432:	b8 0f 00 00 00       	mov    $0xf,%eax
    1437:	cd 40                	int    $0x40
    1439:	c3                   	ret    

0000143a <mknod>:
SYSCALL(mknod)
    143a:	b8 11 00 00 00       	mov    $0x11,%eax
    143f:	cd 40                	int    $0x40
    1441:	c3                   	ret    

00001442 <unlink>:
SYSCALL(unlink)
    1442:	b8 12 00 00 00       	mov    $0x12,%eax
    1447:	cd 40                	int    $0x40
    1449:	c3                   	ret    

0000144a <fstat>:
SYSCALL(fstat)
    144a:	b8 08 00 00 00       	mov    $0x8,%eax
    144f:	cd 40                	int    $0x40
    1451:	c3                   	ret    

00001452 <link>:
SYSCALL(link)
    1452:	b8 13 00 00 00       	mov    $0x13,%eax
    1457:	cd 40                	int    $0x40
    1459:	c3                   	ret    

0000145a <mkdir>:
SYSCALL(mkdir)
    145a:	b8 14 00 00 00       	mov    $0x14,%eax
    145f:	cd 40                	int    $0x40
    1461:	c3                   	ret    

00001462 <chdir>:
SYSCALL(chdir)
    1462:	b8 09 00 00 00       	mov    $0x9,%eax
    1467:	cd 40                	int    $0x40
    1469:	c3                   	ret    

0000146a <dup>:
SYSCALL(dup)
    146a:	b8 0a 00 00 00       	mov    $0xa,%eax
    146f:	cd 40                	int    $0x40
    1471:	c3                   	ret    

00001472 <getpid>:
SYSCALL(getpid)
    1472:	b8 0b 00 00 00       	mov    $0xb,%eax
    1477:	cd 40                	int    $0x40
    1479:	c3                   	ret    

0000147a <sbrk>:
SYSCALL(sbrk)
    147a:	b8 0c 00 00 00       	mov    $0xc,%eax
    147f:	cd 40                	int    $0x40
    1481:	c3                   	ret    

00001482 <sleep>:
SYSCALL(sleep)
    1482:	b8 0d 00 00 00       	mov    $0xd,%eax
    1487:	cd 40                	int    $0x40
    1489:	c3                   	ret    

0000148a <uptime>:
SYSCALL(uptime)
    148a:	b8 0e 00 00 00       	mov    $0xe,%eax
    148f:	cd 40                	int    $0x40
    1491:	c3                   	ret    

00001492 <halt>:
SYSCALL(halt)
    1492:	b8 16 00 00 00       	mov    $0x16,%eax
    1497:	cd 40                	int    $0x40
    1499:	c3                   	ret    

0000149a <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
    149a:	b8 17 00 00 00       	mov    $0x17,%eax
    149f:	cd 40                	int    $0x40
    14a1:	c3                   	ret    

000014a2 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
    14a2:	b8 18 00 00 00       	mov    $0x18,%eax
    14a7:	cd 40                	int    $0x40
    14a9:	c3                   	ret    

000014aa <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
    14aa:	b8 19 00 00 00       	mov    $0x19,%eax
    14af:	cd 40                	int    $0x40
    14b1:	c3                   	ret    

000014b2 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
    14b2:	b8 1a 00 00 00       	mov    $0x1a,%eax
    14b7:	cd 40                	int    $0x40
    14b9:	c3                   	ret    

000014ba <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
    14ba:	b8 1b 00 00 00       	mov    $0x1b,%eax
    14bf:	cd 40                	int    $0x40
    14c1:	c3                   	ret    

000014c2 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
    14c2:	b8 1c 00 00 00       	mov    $0x1c,%eax
    14c7:	cd 40                	int    $0x40
    14c9:	c3                   	ret    

000014ca <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
    14ca:	b8 1d 00 00 00       	mov    $0x1d,%eax
    14cf:	cd 40                	int    $0x40
    14d1:	c3                   	ret    

000014d2 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
    14d2:	b8 1e 00 00 00       	mov    $0x1e,%eax
    14d7:	cd 40                	int    $0x40
    14d9:	c3                   	ret    

000014da <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
    14da:	b8 1f 00 00 00       	mov    $0x1f,%eax
    14df:	cd 40                	int    $0x40
    14e1:	c3                   	ret    

000014e2 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
    14e2:	b8 20 00 00 00       	mov    $0x20,%eax
    14e7:	cd 40                	int    $0x40
    14e9:	c3                   	ret    

000014ea <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
    14ea:	b8 21 00 00 00       	mov    $0x21,%eax
    14ef:	cd 40                	int    $0x40
    14f1:	c3                   	ret    

000014f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14f2:	55                   	push   %ebp
    14f3:	89 e5                	mov    %esp,%ebp
    14f5:	83 ec 18             	sub    $0x18,%esp
    14f8:	8b 45 0c             	mov    0xc(%ebp),%eax
    14fb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14fe:	83 ec 04             	sub    $0x4,%esp
    1501:	6a 01                	push   $0x1
    1503:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1506:	50                   	push   %eax
    1507:	ff 75 08             	pushl  0x8(%ebp)
    150a:	e8 03 ff ff ff       	call   1412 <write>
    150f:	83 c4 10             	add    $0x10,%esp
}
    1512:	90                   	nop
    1513:	c9                   	leave  
    1514:	c3                   	ret    

00001515 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1515:	55                   	push   %ebp
    1516:	89 e5                	mov    %esp,%ebp
    1518:	53                   	push   %ebx
    1519:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    151c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1523:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1527:	74 17                	je     1540 <printint+0x2b>
    1529:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    152d:	79 11                	jns    1540 <printint+0x2b>
    neg = 1;
    152f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1536:	8b 45 0c             	mov    0xc(%ebp),%eax
    1539:	f7 d8                	neg    %eax
    153b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    153e:	eb 06                	jmp    1546 <printint+0x31>
  } else {
    x = xx;
    1540:	8b 45 0c             	mov    0xc(%ebp),%eax
    1543:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1546:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    154d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1550:	8d 41 01             	lea    0x1(%ecx),%eax
    1553:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1556:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1559:	8b 45 ec             	mov    -0x14(%ebp),%eax
    155c:	ba 00 00 00 00       	mov    $0x0,%edx
    1561:	f7 f3                	div    %ebx
    1563:	89 d0                	mov    %edx,%eax
    1565:	0f b6 80 c0 26 00 00 	movzbl 0x26c0(%eax),%eax
    156c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1570:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1573:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1576:	ba 00 00 00 00       	mov    $0x0,%edx
    157b:	f7 f3                	div    %ebx
    157d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1580:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1584:	75 c7                	jne    154d <printint+0x38>
  if(neg)
    1586:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    158a:	74 2d                	je     15b9 <printint+0xa4>
    buf[i++] = '-';
    158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158f:	8d 50 01             	lea    0x1(%eax),%edx
    1592:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1595:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    159a:	eb 1d                	jmp    15b9 <printint+0xa4>
    putc(fd, buf[i]);
    159c:	8d 55 dc             	lea    -0x24(%ebp),%edx
    159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a2:	01 d0                	add    %edx,%eax
    15a4:	0f b6 00             	movzbl (%eax),%eax
    15a7:	0f be c0             	movsbl %al,%eax
    15aa:	83 ec 08             	sub    $0x8,%esp
    15ad:	50                   	push   %eax
    15ae:	ff 75 08             	pushl  0x8(%ebp)
    15b1:	e8 3c ff ff ff       	call   14f2 <putc>
    15b6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    15b9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    15bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15c1:	79 d9                	jns    159c <printint+0x87>
    putc(fd, buf[i]);
}
    15c3:	90                   	nop
    15c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    15c7:	c9                   	leave  
    15c8:	c3                   	ret    

000015c9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15c9:	55                   	push   %ebp
    15ca:	89 e5                	mov    %esp,%ebp
    15cc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15d6:	8d 45 0c             	lea    0xc(%ebp),%eax
    15d9:	83 c0 04             	add    $0x4,%eax
    15dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    15df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15e6:	e9 59 01 00 00       	jmp    1744 <printf+0x17b>
    c = fmt[i] & 0xff;
    15eb:	8b 55 0c             	mov    0xc(%ebp),%edx
    15ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f1:	01 d0                	add    %edx,%eax
    15f3:	0f b6 00             	movzbl (%eax),%eax
    15f6:	0f be c0             	movsbl %al,%eax
    15f9:	25 ff 00 00 00       	and    $0xff,%eax
    15fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1605:	75 2c                	jne    1633 <printf+0x6a>
      if(c == '%'){
    1607:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    160b:	75 0c                	jne    1619 <printf+0x50>
        state = '%';
    160d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1614:	e9 27 01 00 00       	jmp    1740 <printf+0x177>
      } else {
        putc(fd, c);
    1619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    161c:	0f be c0             	movsbl %al,%eax
    161f:	83 ec 08             	sub    $0x8,%esp
    1622:	50                   	push   %eax
    1623:	ff 75 08             	pushl  0x8(%ebp)
    1626:	e8 c7 fe ff ff       	call   14f2 <putc>
    162b:	83 c4 10             	add    $0x10,%esp
    162e:	e9 0d 01 00 00       	jmp    1740 <printf+0x177>
      }
    } else if(state == '%'){
    1633:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1637:	0f 85 03 01 00 00    	jne    1740 <printf+0x177>
      if(c == 'd'){
    163d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1641:	75 1e                	jne    1661 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1643:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1646:	8b 00                	mov    (%eax),%eax
    1648:	6a 01                	push   $0x1
    164a:	6a 0a                	push   $0xa
    164c:	50                   	push   %eax
    164d:	ff 75 08             	pushl  0x8(%ebp)
    1650:	e8 c0 fe ff ff       	call   1515 <printint>
    1655:	83 c4 10             	add    $0x10,%esp
        ap++;
    1658:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    165c:	e9 d8 00 00 00       	jmp    1739 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    1661:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1665:	74 06                	je     166d <printf+0xa4>
    1667:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    166b:	75 1e                	jne    168b <printf+0xc2>
        printint(fd, *ap, 16, 0);
    166d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1670:	8b 00                	mov    (%eax),%eax
    1672:	6a 00                	push   $0x0
    1674:	6a 10                	push   $0x10
    1676:	50                   	push   %eax
    1677:	ff 75 08             	pushl  0x8(%ebp)
    167a:	e8 96 fe ff ff       	call   1515 <printint>
    167f:	83 c4 10             	add    $0x10,%esp
        ap++;
    1682:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1686:	e9 ae 00 00 00       	jmp    1739 <printf+0x170>
      } else if(c == 's'){
    168b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    168f:	75 43                	jne    16d4 <printf+0x10b>
        s = (char*)*ap;
    1691:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1694:	8b 00                	mov    (%eax),%eax
    1696:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1699:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    169d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16a1:	75 25                	jne    16c8 <printf+0xff>
          s = "(null)";
    16a3:	c7 45 f4 cc 22 00 00 	movl   $0x22cc,-0xc(%ebp)
        while(*s != 0){
    16aa:	eb 1c                	jmp    16c8 <printf+0xff>
          putc(fd, *s);
    16ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16af:	0f b6 00             	movzbl (%eax),%eax
    16b2:	0f be c0             	movsbl %al,%eax
    16b5:	83 ec 08             	sub    $0x8,%esp
    16b8:	50                   	push   %eax
    16b9:	ff 75 08             	pushl  0x8(%ebp)
    16bc:	e8 31 fe ff ff       	call   14f2 <putc>
    16c1:	83 c4 10             	add    $0x10,%esp
          s++;
    16c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    16c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16cb:	0f b6 00             	movzbl (%eax),%eax
    16ce:	84 c0                	test   %al,%al
    16d0:	75 da                	jne    16ac <printf+0xe3>
    16d2:	eb 65                	jmp    1739 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16d4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    16d8:	75 1d                	jne    16f7 <printf+0x12e>
        putc(fd, *ap);
    16da:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16dd:	8b 00                	mov    (%eax),%eax
    16df:	0f be c0             	movsbl %al,%eax
    16e2:	83 ec 08             	sub    $0x8,%esp
    16e5:	50                   	push   %eax
    16e6:	ff 75 08             	pushl  0x8(%ebp)
    16e9:	e8 04 fe ff ff       	call   14f2 <putc>
    16ee:	83 c4 10             	add    $0x10,%esp
        ap++;
    16f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16f5:	eb 42                	jmp    1739 <printf+0x170>
      } else if(c == '%'){
    16f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16fb:	75 17                	jne    1714 <printf+0x14b>
        putc(fd, c);
    16fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1700:	0f be c0             	movsbl %al,%eax
    1703:	83 ec 08             	sub    $0x8,%esp
    1706:	50                   	push   %eax
    1707:	ff 75 08             	pushl  0x8(%ebp)
    170a:	e8 e3 fd ff ff       	call   14f2 <putc>
    170f:	83 c4 10             	add    $0x10,%esp
    1712:	eb 25                	jmp    1739 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1714:	83 ec 08             	sub    $0x8,%esp
    1717:	6a 25                	push   $0x25
    1719:	ff 75 08             	pushl  0x8(%ebp)
    171c:	e8 d1 fd ff ff       	call   14f2 <putc>
    1721:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1727:	0f be c0             	movsbl %al,%eax
    172a:	83 ec 08             	sub    $0x8,%esp
    172d:	50                   	push   %eax
    172e:	ff 75 08             	pushl  0x8(%ebp)
    1731:	e8 bc fd ff ff       	call   14f2 <putc>
    1736:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1739:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1740:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1744:	8b 55 0c             	mov    0xc(%ebp),%edx
    1747:	8b 45 f0             	mov    -0x10(%ebp),%eax
    174a:	01 d0                	add    %edx,%eax
    174c:	0f b6 00             	movzbl (%eax),%eax
    174f:	84 c0                	test   %al,%al
    1751:	0f 85 94 fe ff ff    	jne    15eb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1757:	90                   	nop
    1758:	c9                   	leave  
    1759:	c3                   	ret    

0000175a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    175a:	55                   	push   %ebp
    175b:	89 e5                	mov    %esp,%ebp
    175d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1760:	8b 45 08             	mov    0x8(%ebp),%eax
    1763:	83 e8 08             	sub    $0x8,%eax
    1766:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1769:	a1 dc 26 00 00       	mov    0x26dc,%eax
    176e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1771:	eb 24                	jmp    1797 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1773:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1776:	8b 00                	mov    (%eax),%eax
    1778:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    177b:	77 12                	ja     178f <free+0x35>
    177d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1780:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1783:	77 24                	ja     17a9 <free+0x4f>
    1785:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1788:	8b 00                	mov    (%eax),%eax
    178a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    178d:	77 1a                	ja     17a9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    178f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1792:	8b 00                	mov    (%eax),%eax
    1794:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1797:	8b 45 f8             	mov    -0x8(%ebp),%eax
    179a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    179d:	76 d4                	jbe    1773 <free+0x19>
    179f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a2:	8b 00                	mov    (%eax),%eax
    17a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17a7:	76 ca                	jbe    1773 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ac:	8b 40 04             	mov    0x4(%eax),%eax
    17af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17b9:	01 c2                	add    %eax,%edx
    17bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17be:	8b 00                	mov    (%eax),%eax
    17c0:	39 c2                	cmp    %eax,%edx
    17c2:	75 24                	jne    17e8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    17c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17c7:	8b 50 04             	mov    0x4(%eax),%edx
    17ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17cd:	8b 00                	mov    (%eax),%eax
    17cf:	8b 40 04             	mov    0x4(%eax),%eax
    17d2:	01 c2                	add    %eax,%edx
    17d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17d7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    17da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17dd:	8b 00                	mov    (%eax),%eax
    17df:	8b 10                	mov    (%eax),%edx
    17e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17e4:	89 10                	mov    %edx,(%eax)
    17e6:	eb 0a                	jmp    17f2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    17e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17eb:	8b 10                	mov    (%eax),%edx
    17ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17f0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    17f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17f5:	8b 40 04             	mov    0x4(%eax),%eax
    17f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1802:	01 d0                	add    %edx,%eax
    1804:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1807:	75 20                	jne    1829 <free+0xcf>
    p->s.size += bp->s.size;
    1809:	8b 45 fc             	mov    -0x4(%ebp),%eax
    180c:	8b 50 04             	mov    0x4(%eax),%edx
    180f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1812:	8b 40 04             	mov    0x4(%eax),%eax
    1815:	01 c2                	add    %eax,%edx
    1817:	8b 45 fc             	mov    -0x4(%ebp),%eax
    181a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    181d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1820:	8b 10                	mov    (%eax),%edx
    1822:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1825:	89 10                	mov    %edx,(%eax)
    1827:	eb 08                	jmp    1831 <free+0xd7>
  } else
    p->s.ptr = bp;
    1829:	8b 45 fc             	mov    -0x4(%ebp),%eax
    182c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    182f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1831:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1834:	a3 dc 26 00 00       	mov    %eax,0x26dc
}
    1839:	90                   	nop
    183a:	c9                   	leave  
    183b:	c3                   	ret    

0000183c <morecore>:

static Header*
morecore(uint nu)
{
    183c:	55                   	push   %ebp
    183d:	89 e5                	mov    %esp,%ebp
    183f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1842:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1849:	77 07                	ja     1852 <morecore+0x16>
    nu = 4096;
    184b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1852:	8b 45 08             	mov    0x8(%ebp),%eax
    1855:	c1 e0 03             	shl    $0x3,%eax
    1858:	83 ec 0c             	sub    $0xc,%esp
    185b:	50                   	push   %eax
    185c:	e8 19 fc ff ff       	call   147a <sbrk>
    1861:	83 c4 10             	add    $0x10,%esp
    1864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1867:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    186b:	75 07                	jne    1874 <morecore+0x38>
    return 0;
    186d:	b8 00 00 00 00       	mov    $0x0,%eax
    1872:	eb 26                	jmp    189a <morecore+0x5e>
  hp = (Header*)p;
    1874:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1877:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    187a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    187d:	8b 55 08             	mov    0x8(%ebp),%edx
    1880:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1883:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1886:	83 c0 08             	add    $0x8,%eax
    1889:	83 ec 0c             	sub    $0xc,%esp
    188c:	50                   	push   %eax
    188d:	e8 c8 fe ff ff       	call   175a <free>
    1892:	83 c4 10             	add    $0x10,%esp
  return freep;
    1895:	a1 dc 26 00 00       	mov    0x26dc,%eax
}
    189a:	c9                   	leave  
    189b:	c3                   	ret    

0000189c <malloc>:

void*
malloc(uint nbytes)
{
    189c:	55                   	push   %ebp
    189d:	89 e5                	mov    %esp,%ebp
    189f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18a2:	8b 45 08             	mov    0x8(%ebp),%eax
    18a5:	83 c0 07             	add    $0x7,%eax
    18a8:	c1 e8 03             	shr    $0x3,%eax
    18ab:	83 c0 01             	add    $0x1,%eax
    18ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18b1:	a1 dc 26 00 00       	mov    0x26dc,%eax
    18b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18bd:	75 23                	jne    18e2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    18bf:	c7 45 f0 d4 26 00 00 	movl   $0x26d4,-0x10(%ebp)
    18c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18c9:	a3 dc 26 00 00       	mov    %eax,0x26dc
    18ce:	a1 dc 26 00 00       	mov    0x26dc,%eax
    18d3:	a3 d4 26 00 00       	mov    %eax,0x26d4
    base.s.size = 0;
    18d8:	c7 05 d8 26 00 00 00 	movl   $0x0,0x26d8
    18df:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e5:	8b 00                	mov    (%eax),%eax
    18e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    18ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ed:	8b 40 04             	mov    0x4(%eax),%eax
    18f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18f3:	72 4d                	jb     1942 <malloc+0xa6>
      if(p->s.size == nunits)
    18f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f8:	8b 40 04             	mov    0x4(%eax),%eax
    18fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18fe:	75 0c                	jne    190c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1900:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1903:	8b 10                	mov    (%eax),%edx
    1905:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1908:	89 10                	mov    %edx,(%eax)
    190a:	eb 26                	jmp    1932 <malloc+0x96>
      else {
        p->s.size -= nunits;
    190c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    190f:	8b 40 04             	mov    0x4(%eax),%eax
    1912:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1915:	89 c2                	mov    %eax,%edx
    1917:	8b 45 f4             	mov    -0xc(%ebp),%eax
    191a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    191d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1920:	8b 40 04             	mov    0x4(%eax),%eax
    1923:	c1 e0 03             	shl    $0x3,%eax
    1926:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1929:	8b 45 f4             	mov    -0xc(%ebp),%eax
    192c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    192f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1932:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1935:	a3 dc 26 00 00       	mov    %eax,0x26dc
      return (void*)(p + 1);
    193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    193d:	83 c0 08             	add    $0x8,%eax
    1940:	eb 3b                	jmp    197d <malloc+0xe1>
    }
    if(p == freep)
    1942:	a1 dc 26 00 00       	mov    0x26dc,%eax
    1947:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    194a:	75 1e                	jne    196a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    194c:	83 ec 0c             	sub    $0xc,%esp
    194f:	ff 75 ec             	pushl  -0x14(%ebp)
    1952:	e8 e5 fe ff ff       	call   183c <morecore>
    1957:	83 c4 10             	add    $0x10,%esp
    195a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    195d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1961:	75 07                	jne    196a <malloc+0xce>
        return 0;
    1963:	b8 00 00 00 00       	mov    $0x0,%eax
    1968:	eb 13                	jmp    197d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    196d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1970:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1973:	8b 00                	mov    (%eax),%eax
    1975:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1978:	e9 6d ff ff ff       	jmp    18ea <malloc+0x4e>
}
    197d:	c9                   	leave  
    197e:	c3                   	ret    
