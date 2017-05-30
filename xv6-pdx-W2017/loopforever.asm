
_loopforever:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, max = 7;
  11:	c7 45 ec 07 00 00 00 	movl   $0x7,-0x14(%ebp)
  unsigned long x = 0;
  18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  for (int i=0; i<max; i++) {
  1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  26:	eb 59                	jmp    81 <main+0x81>
    sleep(5*100);  // pause before each child starts
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	68 f4 01 00 00       	push   $0x1f4
  30:	e8 16 04 00 00       	call   44b <sleep>
  35:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  38:	e8 76 03 00 00       	call   3b3 <fork>
  3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (pid < 0) {
  40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  44:	79 17                	jns    5d <main+0x5d>
      printf(2, "fork failed!\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 48 09 00 00       	push   $0x948
  4e:	6a 02                	push   $0x2
  50:	e8 3d 05 00 00       	call   592 <printf>
  55:	83 c4 10             	add    $0x10,%esp
      exit();
  58:	e8 5e 03 00 00       	call   3bb <exit>
    }

    if (pid == 0) { // child
  5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  61:	75 1a                	jne    7d <main+0x7d>
      sleep(getpid()*100); // stagger start
  63:	e8 d3 03 00 00       	call   43b <getpid>
  68:	6b c0 64             	imul   $0x64,%eax,%eax
  6b:	83 ec 0c             	sub    $0xc,%esp
  6e:	50                   	push   %eax
  6f:	e8 d7 03 00 00       	call   44b <sleep>
  74:	83 c4 10             	add    $0x10,%esp
      do {
	x += 1;
  77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } while (1);
  7b:	eb fa                	jmp    77 <main+0x77>
main(void)
{
  int pid, max = 7;
  unsigned long x = 0;

  for (int i=0; i<max; i++) {
  7d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  84:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  87:	7c 9f                	jl     28 <main+0x28>
      printf(1, "Child %d exiting\n", getpid());
      exit();
    }
  }

  pid = fork();
  89:	e8 25 03 00 00       	call   3b3 <fork>
  8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (pid == 0) {
  91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  95:	75 13                	jne    aa <main+0xaa>
    sleep(20);
  97:	83 ec 0c             	sub    $0xc,%esp
  9a:	6a 14                	push   $0x14
  9c:	e8 aa 03 00 00       	call   44b <sleep>
  a1:	83 c4 10             	add    $0x10,%esp
    do {
      x = x+1;
  a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    } while (1);
  a8:	eb fa                	jmp    a4 <main+0xa4>
  }

  sleep(15*100);
  aa:	83 ec 0c             	sub    $0xc,%esp
  ad:	68 dc 05 00 00       	push   $0x5dc
  b2:	e8 94 03 00 00       	call   44b <sleep>
  b7:	83 c4 10             	add    $0x10,%esp
  wait();
  ba:	e8 04 03 00 00       	call   3c3 <wait>
  printf(1, "Parent exiting\n");
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	68 56 09 00 00       	push   $0x956
  c7:	6a 01                	push   $0x1
  c9:	e8 c4 04 00 00       	call   592 <printf>
  ce:	83 c4 10             	add    $0x10,%esp
  exit();
  d1:	e8 e5 02 00 00       	call   3bb <exit>

000000d6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  d9:	57                   	push   %edi
  da:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  de:	8b 55 10             	mov    0x10(%ebp),%edx
  e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  e4:	89 cb                	mov    %ecx,%ebx
  e6:	89 df                	mov    %ebx,%edi
  e8:	89 d1                	mov    %edx,%ecx
  ea:	fc                   	cld    
  eb:	f3 aa                	rep stos %al,%es:(%edi)
  ed:	89 ca                	mov    %ecx,%edx
  ef:	89 fb                	mov    %edi,%ebx
  f1:	89 5d 08             	mov    %ebx,0x8(%ebp)
  f4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  f7:	90                   	nop
  f8:	5b                   	pop    %ebx
  f9:	5f                   	pop    %edi
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret    

000000fc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 108:	90                   	nop
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	8d 50 01             	lea    0x1(%eax),%edx
 10f:	89 55 08             	mov    %edx,0x8(%ebp)
 112:	8b 55 0c             	mov    0xc(%ebp),%edx
 115:	8d 4a 01             	lea    0x1(%edx),%ecx
 118:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 11b:	0f b6 12             	movzbl (%edx),%edx
 11e:	88 10                	mov    %dl,(%eax)
 120:	0f b6 00             	movzbl (%eax),%eax
 123:	84 c0                	test   %al,%al
 125:	75 e2                	jne    109 <strcpy+0xd>
    ;
  return os;
 127:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12a:	c9                   	leave  
 12b:	c3                   	ret    

0000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 12f:	eb 08                	jmp    139 <strcmp+0xd>
    p++, q++;
 131:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 135:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	0f b6 00             	movzbl (%eax),%eax
 13f:	84 c0                	test   %al,%al
 141:	74 10                	je     153 <strcmp+0x27>
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 10             	movzbl (%eax),%edx
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	38 c2                	cmp    %al,%dl
 151:	74 de                	je     131 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	0f b6 d0             	movzbl %al,%edx
 15c:	8b 45 0c             	mov    0xc(%ebp),%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	0f b6 c0             	movzbl %al,%eax
 165:	29 c2                	sub    %eax,%edx
 167:	89 d0                	mov    %edx,%eax
}
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <strlen>:

uint
strlen(char *s)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 178:	eb 04                	jmp    17e <strlen+0x13>
 17a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 17e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	01 d0                	add    %edx,%eax
 186:	0f b6 00             	movzbl (%eax),%eax
 189:	84 c0                	test   %al,%al
 18b:	75 ed                	jne    17a <strlen+0xf>
    ;
  return n;
 18d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 190:	c9                   	leave  
 191:	c3                   	ret    

00000192 <memset>:

void*
memset(void *dst, int c, uint n)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 195:	8b 45 10             	mov    0x10(%ebp),%eax
 198:	50                   	push   %eax
 199:	ff 75 0c             	pushl  0xc(%ebp)
 19c:	ff 75 08             	pushl  0x8(%ebp)
 19f:	e8 32 ff ff ff       	call   d6 <stosb>
 1a4:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1aa:	c9                   	leave  
 1ab:	c3                   	ret    

000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	83 ec 04             	sub    $0x4,%esp
 1b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b8:	eb 14                	jmp    1ce <strchr+0x22>
    if(*s == c)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c3:	75 05                	jne    1ca <strchr+0x1e>
      return (char*)s;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
 1c8:	eb 13                	jmp    1dd <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	0f b6 00             	movzbl (%eax),%eax
 1d4:	84 c0                	test   %al,%al
 1d6:	75 e2                	jne    1ba <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1dd:	c9                   	leave  
 1de:	c3                   	ret    

000001df <gets>:

char*
gets(char *buf, int max)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ec:	eb 42                	jmp    230 <gets+0x51>
    cc = read(0, &c, 1);
 1ee:	83 ec 04             	sub    $0x4,%esp
 1f1:	6a 01                	push   $0x1
 1f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f6:	50                   	push   %eax
 1f7:	6a 00                	push   $0x0
 1f9:	e8 d5 01 00 00       	call   3d3 <read>
 1fe:	83 c4 10             	add    $0x10,%esp
 201:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 204:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 208:	7e 33                	jle    23d <gets+0x5e>
      break;
    buf[i++] = c;
 20a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20d:	8d 50 01             	lea    0x1(%eax),%edx
 210:	89 55 f4             	mov    %edx,-0xc(%ebp)
 213:	89 c2                	mov    %eax,%edx
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	01 c2                	add    %eax,%edx
 21a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 220:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 224:	3c 0a                	cmp    $0xa,%al
 226:	74 16                	je     23e <gets+0x5f>
 228:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22c:	3c 0d                	cmp    $0xd,%al
 22e:	74 0e                	je     23e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	8b 45 f4             	mov    -0xc(%ebp),%eax
 233:	83 c0 01             	add    $0x1,%eax
 236:	3b 45 0c             	cmp    0xc(%ebp),%eax
 239:	7c b3                	jl     1ee <gets+0xf>
 23b:	eb 01                	jmp    23e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 23d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 23e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	01 d0                	add    %edx,%eax
 246:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 249:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <stat>:

int
stat(char *n, struct stat *st)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	83 ec 08             	sub    $0x8,%esp
 257:	6a 00                	push   $0x0
 259:	ff 75 08             	pushl  0x8(%ebp)
 25c:	e8 9a 01 00 00       	call   3fb <open>
 261:	83 c4 10             	add    $0x10,%esp
 264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 26b:	79 07                	jns    274 <stat+0x26>
    return -1;
 26d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 272:	eb 25                	jmp    299 <stat+0x4b>
  r = fstat(fd, st);
 274:	83 ec 08             	sub    $0x8,%esp
 277:	ff 75 0c             	pushl  0xc(%ebp)
 27a:	ff 75 f4             	pushl  -0xc(%ebp)
 27d:	e8 91 01 00 00       	call   413 <fstat>
 282:	83 c4 10             	add    $0x10,%esp
 285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 288:	83 ec 0c             	sub    $0xc,%esp
 28b:	ff 75 f4             	pushl  -0xc(%ebp)
 28e:	e8 50 01 00 00       	call   3e3 <close>
 293:	83 c4 10             	add    $0x10,%esp
  return r;
 296:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 299:	c9                   	leave  
 29a:	c3                   	ret    

0000029b <atoi>:

int
atoi(const char *s)
{
 29b:	55                   	push   %ebp
 29c:	89 e5                	mov    %esp,%ebp
 29e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a8:	eb 25                	jmp    2cf <atoi+0x34>
    n = n*10 + *s++ - '0';
 2aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ad:	89 d0                	mov    %edx,%eax
 2af:	c1 e0 02             	shl    $0x2,%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	01 c0                	add    %eax,%eax
 2b6:	89 c1                	mov    %eax,%ecx
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	8d 50 01             	lea    0x1(%eax),%edx
 2be:	89 55 08             	mov    %edx,0x8(%ebp)
 2c1:	0f b6 00             	movzbl (%eax),%eax
 2c4:	0f be c0             	movsbl %al,%eax
 2c7:	01 c8                	add    %ecx,%eax
 2c9:	83 e8 30             	sub    $0x30,%eax
 2cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	3c 2f                	cmp    $0x2f,%al
 2d7:	7e 0a                	jle    2e3 <atoi+0x48>
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 39                	cmp    $0x39,%al
 2e1:	7e c7                	jle    2aa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e6:	c9                   	leave  
 2e7:	c3                   	ret    

000002e8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2fa:	eb 17                	jmp    313 <memmove+0x2b>
    *dst++ = *src++;
 2fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ff:	8d 50 01             	lea    0x1(%eax),%edx
 302:	89 55 fc             	mov    %edx,-0x4(%ebp)
 305:	8b 55 f8             	mov    -0x8(%ebp),%edx
 308:	8d 4a 01             	lea    0x1(%edx),%ecx
 30b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 30e:	0f b6 12             	movzbl (%edx),%edx
 311:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 313:	8b 45 10             	mov    0x10(%ebp),%eax
 316:	8d 50 ff             	lea    -0x1(%eax),%edx
 319:	89 55 10             	mov    %edx,0x10(%ebp)
 31c:	85 c0                	test   %eax,%eax
 31e:	7f dc                	jg     2fc <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 320:	8b 45 08             	mov    0x8(%ebp),%eax
}
 323:	c9                   	leave  
 324:	c3                   	ret    

00000325 <atoo>:

int
atoo(const char *s)
{
 325:	55                   	push   %ebp
 326:	89 e5                	mov    %esp,%ebp
 328:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 32b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 332:	eb 04                	jmp    338 <atoo+0x13>
 334:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	0f b6 00             	movzbl (%eax),%eax
 33e:	3c 20                	cmp    $0x20,%al
 340:	74 f2                	je     334 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	0f b6 00             	movzbl (%eax),%eax
 348:	3c 2d                	cmp    $0x2d,%al
 34a:	75 07                	jne    353 <atoo+0x2e>
 34c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 351:	eb 05                	jmp    358 <atoo+0x33>
 353:	b8 01 00 00 00       	mov    $0x1,%eax
 358:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	0f b6 00             	movzbl (%eax),%eax
 361:	3c 2b                	cmp    $0x2b,%al
 363:	74 0a                	je     36f <atoo+0x4a>
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	0f b6 00             	movzbl (%eax),%eax
 36b:	3c 2d                	cmp    $0x2d,%al
 36d:	75 27                	jne    396 <atoo+0x71>
    s++;
 36f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 373:	eb 21                	jmp    396 <atoo+0x71>
    n = n*8 + *s++ - '0';
 375:	8b 45 fc             	mov    -0x4(%ebp),%eax
 378:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	8d 50 01             	lea    0x1(%eax),%edx
 385:	89 55 08             	mov    %edx,0x8(%ebp)
 388:	0f b6 00             	movzbl (%eax),%eax
 38b:	0f be c0             	movsbl %al,%eax
 38e:	01 c8                	add    %ecx,%eax
 390:	83 e8 30             	sub    $0x30,%eax
 393:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	0f b6 00             	movzbl (%eax),%eax
 39c:	3c 2f                	cmp    $0x2f,%al
 39e:	7e 0a                	jle    3aa <atoo+0x85>
 3a0:	8b 45 08             	mov    0x8(%ebp),%eax
 3a3:	0f b6 00             	movzbl (%eax),%eax
 3a6:	3c 37                	cmp    $0x37,%al
 3a8:	7e cb                	jle    375 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ad:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3b1:	c9                   	leave  
 3b2:	c3                   	ret    

000003b3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b3:	b8 01 00 00 00       	mov    $0x1,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <exit>:
SYSCALL(exit)
 3bb:	b8 02 00 00 00       	mov    $0x2,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <wait>:
SYSCALL(wait)
 3c3:	b8 03 00 00 00       	mov    $0x3,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <pipe>:
SYSCALL(pipe)
 3cb:	b8 04 00 00 00       	mov    $0x4,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <read>:
SYSCALL(read)
 3d3:	b8 05 00 00 00       	mov    $0x5,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <write>:
SYSCALL(write)
 3db:	b8 10 00 00 00       	mov    $0x10,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <close>:
SYSCALL(close)
 3e3:	b8 15 00 00 00       	mov    $0x15,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <kill>:
SYSCALL(kill)
 3eb:	b8 06 00 00 00       	mov    $0x6,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <exec>:
SYSCALL(exec)
 3f3:	b8 07 00 00 00       	mov    $0x7,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <open>:
SYSCALL(open)
 3fb:	b8 0f 00 00 00       	mov    $0xf,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <mknod>:
SYSCALL(mknod)
 403:	b8 11 00 00 00       	mov    $0x11,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <unlink>:
SYSCALL(unlink)
 40b:	b8 12 00 00 00       	mov    $0x12,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <fstat>:
SYSCALL(fstat)
 413:	b8 08 00 00 00       	mov    $0x8,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <link>:
SYSCALL(link)
 41b:	b8 13 00 00 00       	mov    $0x13,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <mkdir>:
SYSCALL(mkdir)
 423:	b8 14 00 00 00       	mov    $0x14,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <chdir>:
SYSCALL(chdir)
 42b:	b8 09 00 00 00       	mov    $0x9,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <dup>:
SYSCALL(dup)
 433:	b8 0a 00 00 00       	mov    $0xa,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <getpid>:
SYSCALL(getpid)
 43b:	b8 0b 00 00 00       	mov    $0xb,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <sbrk>:
SYSCALL(sbrk)
 443:	b8 0c 00 00 00       	mov    $0xc,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <sleep>:
SYSCALL(sleep)
 44b:	b8 0d 00 00 00       	mov    $0xd,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <uptime>:
SYSCALL(uptime)
 453:	b8 0e 00 00 00       	mov    $0xe,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <halt>:
SYSCALL(halt)
 45b:	b8 16 00 00 00       	mov    $0x16,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 463:	b8 17 00 00 00       	mov    $0x17,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 46b:	b8 18 00 00 00       	mov    $0x18,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 473:	b8 19 00 00 00       	mov    $0x19,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 47b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 483:	b8 1b 00 00 00       	mov    $0x1b,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 48b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 493:	b8 1a 00 00 00       	mov    $0x1a,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 49b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 4a3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 4ab:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 4b3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4bb:	55                   	push   %ebp
 4bc:	89 e5                	mov    %esp,%ebp
 4be:	83 ec 18             	sub    $0x18,%esp
 4c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4c7:	83 ec 04             	sub    $0x4,%esp
 4ca:	6a 01                	push   $0x1
 4cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4cf:	50                   	push   %eax
 4d0:	ff 75 08             	pushl  0x8(%ebp)
 4d3:	e8 03 ff ff ff       	call   3db <write>
 4d8:	83 c4 10             	add    $0x10,%esp
}
 4db:	90                   	nop
 4dc:	c9                   	leave  
 4dd:	c3                   	ret    

000004de <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4de:	55                   	push   %ebp
 4df:	89 e5                	mov    %esp,%ebp
 4e1:	53                   	push   %ebx
 4e2:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4ec:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f0:	74 17                	je     509 <printint+0x2b>
 4f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4f6:	79 11                	jns    509 <printint+0x2b>
    neg = 1;
 4f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 502:	f7 d8                	neg    %eax
 504:	89 45 ec             	mov    %eax,-0x14(%ebp)
 507:	eb 06                	jmp    50f <printint+0x31>
  } else {
    x = xx;
 509:	8b 45 0c             	mov    0xc(%ebp),%eax
 50c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 50f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 516:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 519:	8d 41 01             	lea    0x1(%ecx),%eax
 51c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 51f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 522:	8b 45 ec             	mov    -0x14(%ebp),%eax
 525:	ba 00 00 00 00       	mov    $0x0,%edx
 52a:	f7 f3                	div    %ebx
 52c:	89 d0                	mov    %edx,%eax
 52e:	0f b6 80 d8 0b 00 00 	movzbl 0xbd8(%eax),%eax
 535:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 539:	8b 5d 10             	mov    0x10(%ebp),%ebx
 53c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 53f:	ba 00 00 00 00       	mov    $0x0,%edx
 544:	f7 f3                	div    %ebx
 546:	89 45 ec             	mov    %eax,-0x14(%ebp)
 549:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 54d:	75 c7                	jne    516 <printint+0x38>
  if(neg)
 54f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 553:	74 2d                	je     582 <printint+0xa4>
    buf[i++] = '-';
 555:	8b 45 f4             	mov    -0xc(%ebp),%eax
 558:	8d 50 01             	lea    0x1(%eax),%edx
 55b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 55e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 563:	eb 1d                	jmp    582 <printint+0xa4>
    putc(fd, buf[i]);
 565:	8d 55 dc             	lea    -0x24(%ebp),%edx
 568:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56b:	01 d0                	add    %edx,%eax
 56d:	0f b6 00             	movzbl (%eax),%eax
 570:	0f be c0             	movsbl %al,%eax
 573:	83 ec 08             	sub    $0x8,%esp
 576:	50                   	push   %eax
 577:	ff 75 08             	pushl  0x8(%ebp)
 57a:	e8 3c ff ff ff       	call   4bb <putc>
 57f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 582:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58a:	79 d9                	jns    565 <printint+0x87>
    putc(fd, buf[i]);
}
 58c:	90                   	nop
 58d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 590:	c9                   	leave  
 591:	c3                   	ret    

00000592 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 592:	55                   	push   %ebp
 593:	89 e5                	mov    %esp,%ebp
 595:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 598:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 59f:	8d 45 0c             	lea    0xc(%ebp),%eax
 5a2:	83 c0 04             	add    $0x4,%eax
 5a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5af:	e9 59 01 00 00       	jmp    70d <printf+0x17b>
    c = fmt[i] & 0xff;
 5b4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ba:	01 d0                	add    %edx,%eax
 5bc:	0f b6 00             	movzbl (%eax),%eax
 5bf:	0f be c0             	movsbl %al,%eax
 5c2:	25 ff 00 00 00       	and    $0xff,%eax
 5c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ce:	75 2c                	jne    5fc <printf+0x6a>
      if(c == '%'){
 5d0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d4:	75 0c                	jne    5e2 <printf+0x50>
        state = '%';
 5d6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5dd:	e9 27 01 00 00       	jmp    709 <printf+0x177>
      } else {
        putc(fd, c);
 5e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	83 ec 08             	sub    $0x8,%esp
 5eb:	50                   	push   %eax
 5ec:	ff 75 08             	pushl  0x8(%ebp)
 5ef:	e8 c7 fe ff ff       	call   4bb <putc>
 5f4:	83 c4 10             	add    $0x10,%esp
 5f7:	e9 0d 01 00 00       	jmp    709 <printf+0x177>
      }
    } else if(state == '%'){
 5fc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 600:	0f 85 03 01 00 00    	jne    709 <printf+0x177>
      if(c == 'd'){
 606:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 60a:	75 1e                	jne    62a <printf+0x98>
        printint(fd, *ap, 10, 1);
 60c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60f:	8b 00                	mov    (%eax),%eax
 611:	6a 01                	push   $0x1
 613:	6a 0a                	push   $0xa
 615:	50                   	push   %eax
 616:	ff 75 08             	pushl  0x8(%ebp)
 619:	e8 c0 fe ff ff       	call   4de <printint>
 61e:	83 c4 10             	add    $0x10,%esp
        ap++;
 621:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 625:	e9 d8 00 00 00       	jmp    702 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 62a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 62e:	74 06                	je     636 <printf+0xa4>
 630:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 634:	75 1e                	jne    654 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 636:	8b 45 e8             	mov    -0x18(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	6a 00                	push   $0x0
 63d:	6a 10                	push   $0x10
 63f:	50                   	push   %eax
 640:	ff 75 08             	pushl  0x8(%ebp)
 643:	e8 96 fe ff ff       	call   4de <printint>
 648:	83 c4 10             	add    $0x10,%esp
        ap++;
 64b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64f:	e9 ae 00 00 00       	jmp    702 <printf+0x170>
      } else if(c == 's'){
 654:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 658:	75 43                	jne    69d <printf+0x10b>
        s = (char*)*ap;
 65a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 662:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 666:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 66a:	75 25                	jne    691 <printf+0xff>
          s = "(null)";
 66c:	c7 45 f4 66 09 00 00 	movl   $0x966,-0xc(%ebp)
        while(*s != 0){
 673:	eb 1c                	jmp    691 <printf+0xff>
          putc(fd, *s);
 675:	8b 45 f4             	mov    -0xc(%ebp),%eax
 678:	0f b6 00             	movzbl (%eax),%eax
 67b:	0f be c0             	movsbl %al,%eax
 67e:	83 ec 08             	sub    $0x8,%esp
 681:	50                   	push   %eax
 682:	ff 75 08             	pushl  0x8(%ebp)
 685:	e8 31 fe ff ff       	call   4bb <putc>
 68a:	83 c4 10             	add    $0x10,%esp
          s++;
 68d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 691:	8b 45 f4             	mov    -0xc(%ebp),%eax
 694:	0f b6 00             	movzbl (%eax),%eax
 697:	84 c0                	test   %al,%al
 699:	75 da                	jne    675 <printf+0xe3>
 69b:	eb 65                	jmp    702 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 69d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6a1:	75 1d                	jne    6c0 <printf+0x12e>
        putc(fd, *ap);
 6a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a6:	8b 00                	mov    (%eax),%eax
 6a8:	0f be c0             	movsbl %al,%eax
 6ab:	83 ec 08             	sub    $0x8,%esp
 6ae:	50                   	push   %eax
 6af:	ff 75 08             	pushl  0x8(%ebp)
 6b2:	e8 04 fe ff ff       	call   4bb <putc>
 6b7:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6be:	eb 42                	jmp    702 <printf+0x170>
      } else if(c == '%'){
 6c0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c4:	75 17                	jne    6dd <printf+0x14b>
        putc(fd, c);
 6c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c9:	0f be c0             	movsbl %al,%eax
 6cc:	83 ec 08             	sub    $0x8,%esp
 6cf:	50                   	push   %eax
 6d0:	ff 75 08             	pushl  0x8(%ebp)
 6d3:	e8 e3 fd ff ff       	call   4bb <putc>
 6d8:	83 c4 10             	add    $0x10,%esp
 6db:	eb 25                	jmp    702 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6dd:	83 ec 08             	sub    $0x8,%esp
 6e0:	6a 25                	push   $0x25
 6e2:	ff 75 08             	pushl  0x8(%ebp)
 6e5:	e8 d1 fd ff ff       	call   4bb <putc>
 6ea:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f0:	0f be c0             	movsbl %al,%eax
 6f3:	83 ec 08             	sub    $0x8,%esp
 6f6:	50                   	push   %eax
 6f7:	ff 75 08             	pushl  0x8(%ebp)
 6fa:	e8 bc fd ff ff       	call   4bb <putc>
 6ff:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 702:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 709:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 70d:	8b 55 0c             	mov    0xc(%ebp),%edx
 710:	8b 45 f0             	mov    -0x10(%ebp),%eax
 713:	01 d0                	add    %edx,%eax
 715:	0f b6 00             	movzbl (%eax),%eax
 718:	84 c0                	test   %al,%al
 71a:	0f 85 94 fe ff ff    	jne    5b4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 720:	90                   	nop
 721:	c9                   	leave  
 722:	c3                   	ret    

00000723 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 723:	55                   	push   %ebp
 724:	89 e5                	mov    %esp,%ebp
 726:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	83 e8 08             	sub    $0x8,%eax
 72f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 732:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 737:	89 45 fc             	mov    %eax,-0x4(%ebp)
 73a:	eb 24                	jmp    760 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 744:	77 12                	ja     758 <free+0x35>
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74c:	77 24                	ja     772 <free+0x4f>
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	8b 00                	mov    (%eax),%eax
 753:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 756:	77 1a                	ja     772 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 766:	76 d4                	jbe    73c <free+0x19>
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 770:	76 ca                	jbe    73c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 772:	8b 45 f8             	mov    -0x8(%ebp),%eax
 775:	8b 40 04             	mov    0x4(%eax),%eax
 778:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	01 c2                	add    %eax,%edx
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 00                	mov    (%eax),%eax
 789:	39 c2                	cmp    %eax,%edx
 78b:	75 24                	jne    7b1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	8b 50 04             	mov    0x4(%eax),%edx
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	01 c2                	add    %eax,%edx
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	8b 00                	mov    (%eax),%eax
 7a8:	8b 10                	mov    (%eax),%edx
 7aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ad:	89 10                	mov    %edx,(%eax)
 7af:	eb 0a                	jmp    7bb <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 10                	mov    (%eax),%edx
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	01 d0                	add    %edx,%eax
 7cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d0:	75 20                	jne    7f2 <free+0xcf>
    p->s.size += bp->s.size;
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	8b 50 04             	mov    0x4(%eax),%edx
 7d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7db:	8b 40 04             	mov    0x4(%eax),%eax
 7de:	01 c2                	add    %eax,%edx
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e9:	8b 10                	mov    (%eax),%edx
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	89 10                	mov    %edx,(%eax)
 7f0:	eb 08                	jmp    7fa <free+0xd7>
  } else
    p->s.ptr = bp;
 7f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f8:	89 10                	mov    %edx,(%eax)
  freep = p;
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	a3 f4 0b 00 00       	mov    %eax,0xbf4
}
 802:	90                   	nop
 803:	c9                   	leave  
 804:	c3                   	ret    

00000805 <morecore>:

static Header*
morecore(uint nu)
{
 805:	55                   	push   %ebp
 806:	89 e5                	mov    %esp,%ebp
 808:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 80b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 812:	77 07                	ja     81b <morecore+0x16>
    nu = 4096;
 814:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 81b:	8b 45 08             	mov    0x8(%ebp),%eax
 81e:	c1 e0 03             	shl    $0x3,%eax
 821:	83 ec 0c             	sub    $0xc,%esp
 824:	50                   	push   %eax
 825:	e8 19 fc ff ff       	call   443 <sbrk>
 82a:	83 c4 10             	add    $0x10,%esp
 82d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 830:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 834:	75 07                	jne    83d <morecore+0x38>
    return 0;
 836:	b8 00 00 00 00       	mov    $0x0,%eax
 83b:	eb 26                	jmp    863 <morecore+0x5e>
  hp = (Header*)p;
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 843:	8b 45 f0             	mov    -0x10(%ebp),%eax
 846:	8b 55 08             	mov    0x8(%ebp),%edx
 849:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 84c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84f:	83 c0 08             	add    $0x8,%eax
 852:	83 ec 0c             	sub    $0xc,%esp
 855:	50                   	push   %eax
 856:	e8 c8 fe ff ff       	call   723 <free>
 85b:	83 c4 10             	add    $0x10,%esp
  return freep;
 85e:	a1 f4 0b 00 00       	mov    0xbf4,%eax
}
 863:	c9                   	leave  
 864:	c3                   	ret    

00000865 <malloc>:

void*
malloc(uint nbytes)
{
 865:	55                   	push   %ebp
 866:	89 e5                	mov    %esp,%ebp
 868:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86b:	8b 45 08             	mov    0x8(%ebp),%eax
 86e:	83 c0 07             	add    $0x7,%eax
 871:	c1 e8 03             	shr    $0x3,%eax
 874:	83 c0 01             	add    $0x1,%eax
 877:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 87a:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 87f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 882:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 886:	75 23                	jne    8ab <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 888:	c7 45 f0 ec 0b 00 00 	movl   $0xbec,-0x10(%ebp)
 88f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 892:	a3 f4 0b 00 00       	mov    %eax,0xbf4
 897:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 89c:	a3 ec 0b 00 00       	mov    %eax,0xbec
    base.s.size = 0;
 8a1:	c7 05 f0 0b 00 00 00 	movl   $0x0,0xbf0
 8a8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ae:	8b 00                	mov    (%eax),%eax
 8b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b6:	8b 40 04             	mov    0x4(%eax),%eax
 8b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8bc:	72 4d                	jb     90b <malloc+0xa6>
      if(p->s.size == nunits)
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	8b 40 04             	mov    0x4(%eax),%eax
 8c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c7:	75 0c                	jne    8d5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	8b 10                	mov    (%eax),%edx
 8ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d1:	89 10                	mov    %edx,(%eax)
 8d3:	eb 26                	jmp    8fb <malloc+0x96>
      else {
        p->s.size -= nunits;
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 40 04             	mov    0x4(%eax),%eax
 8db:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8de:	89 c2                	mov    %eax,%edx
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	8b 40 04             	mov    0x4(%eax),%eax
 8ec:	c1 e0 03             	shl    $0x3,%eax
 8ef:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8f8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fe:	a3 f4 0b 00 00       	mov    %eax,0xbf4
      return (void*)(p + 1);
 903:	8b 45 f4             	mov    -0xc(%ebp),%eax
 906:	83 c0 08             	add    $0x8,%eax
 909:	eb 3b                	jmp    946 <malloc+0xe1>
    }
    if(p == freep)
 90b:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 910:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 913:	75 1e                	jne    933 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 915:	83 ec 0c             	sub    $0xc,%esp
 918:	ff 75 ec             	pushl  -0x14(%ebp)
 91b:	e8 e5 fe ff ff       	call   805 <morecore>
 920:	83 c4 10             	add    $0x10,%esp
 923:	89 45 f4             	mov    %eax,-0xc(%ebp)
 926:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 92a:	75 07                	jne    933 <malloc+0xce>
        return 0;
 92c:	b8 00 00 00 00       	mov    $0x0,%eax
 931:	eb 13                	jmp    946 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	89 45 f0             	mov    %eax,-0x10(%ebp)
 939:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93c:	8b 00                	mov    (%eax),%eax
 93e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 941:	e9 6d ff ff ff       	jmp    8b3 <malloc+0x4e>
}
 946:	c9                   	leave  
 947:	c3                   	ret    
