
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <time>:
// a console command (which is its input). Note that the input could be
// a nested time command.
// Added for Project 2: The "time" Command
int
time(char *argv[])
{ 
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  uint ticks_total = 0;
   7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uint ticks_in = 0;
   e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // get pid of parent
  uint pid = getpid();
  15:	e8 08 04 00 00       	call   422 <getpid>
  1a:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // fork before tracking time so we don't include the overhead of fork
  fork();
  1d:	e8 78 03 00 00       	call   39a <fork>

  // get starting ticks (adds a tiny bit of overhead to calculation)
  ticks_in = uptime();
  22:	e8 13 04 00 00       	call   43a <uptime>
  27:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // if current proc is parent, then wait for child and track the time delta
  if (pid == getpid())
  2a:	e8 f3 03 00 00       	call   422 <getpid>
  2f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  32:	0f 85 8f 00 00 00    	jne    c7 <time+0xc7>
  {
    wait();
  38:	e8 6d 03 00 00       	call   3aa <wait>
    
    // calculate time delta
    ticks_total += uptime() - ticks_in;
  3d:	e8 f8 03 00 00       	call   43a <uptime>
  42:	2b 45 f0             	sub    -0x10(%ebp),%eax
  45:	01 45 f4             	add    %eax,-0xc(%ebp)
    // print result
    printf(1, "%s ran in %d.%d%d seconds.\n",
              argv[0],
              ticks_total / 100,
              ticks_total % 100 / 10,
              ticks_total % 100 % 10);
  48:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  4b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  50:	89 c8                	mov    %ecx,%eax
  52:	f7 e2                	mul    %edx
  54:	89 d3                	mov    %edx,%ebx
  56:	c1 eb 05             	shr    $0x5,%ebx
  59:	6b c3 64             	imul   $0x64,%ebx,%eax
  5c:	29 c1                	sub    %eax,%ecx
  5e:	89 cb                	mov    %ecx,%ebx
    
    // calculate time delta
    ticks_total += uptime() - ticks_in;
    
    // print result
    printf(1, "%s ran in %d.%d%d seconds.\n",
  60:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  65:	89 d8                	mov    %ebx,%eax
  67:	f7 e2                	mul    %edx
  69:	89 d1                	mov    %edx,%ecx
  6b:	c1 e9 03             	shr    $0x3,%ecx
  6e:	89 c8                	mov    %ecx,%eax
  70:	c1 e0 02             	shl    $0x2,%eax
  73:	01 c8                	add    %ecx,%eax
  75:	01 c0                	add    %eax,%eax
  77:	29 c3                	sub    %eax,%ebx
  79:	89 d9                	mov    %ebx,%ecx
              argv[0],
              ticks_total / 100,
              ticks_total % 100 / 10,
  7b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  7e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  83:	89 d8                	mov    %ebx,%eax
  85:	f7 e2                	mul    %edx
  87:	89 d0                	mov    %edx,%eax
  89:	c1 e8 05             	shr    $0x5,%eax
  8c:	6b c0 64             	imul   $0x64,%eax,%eax
  8f:	29 c3                	sub    %eax,%ebx
  91:	89 d8                	mov    %ebx,%eax
    
    // calculate time delta
    ticks_total += uptime() - ticks_in;
    
    // print result
    printf(1, "%s ran in %d.%d%d seconds.\n",
  93:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  98:	f7 e2                	mul    %edx
  9a:	89 d3                	mov    %edx,%ebx
  9c:	c1 eb 03             	shr    $0x3,%ebx
  9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  a7:	f7 e2                	mul    %edx
  a9:	c1 ea 05             	shr    $0x5,%edx
  ac:	8b 45 08             	mov    0x8(%ebp),%eax
  af:	8b 00                	mov    (%eax),%eax
  b1:	83 ec 08             	sub    $0x8,%esp
  b4:	51                   	push   %ecx
  b5:	53                   	push   %ebx
  b6:	52                   	push   %edx
  b7:	50                   	push   %eax
  b8:	68 17 09 00 00       	push   $0x917
  bd:	6a 01                	push   $0x1
  bf:	e8 9d 04 00 00       	call   561 <printf>
  c4:	83 c4 20             	add    $0x20,%esp
              ticks_total % 100 % 10);
    
  }
 
  // if current proc is not parent, then exec
  if (pid != getpid())
  c7:	e8 56 03 00 00       	call   422 <getpid>
  cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  cf:	74 26                	je     f7 <time+0xf7>
  {
    exec(argv[0], &argv[0]);
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	8b 00                	mov    (%eax),%eax
  d6:	83 ec 08             	sub    $0x8,%esp
  d9:	ff 75 08             	pushl  0x8(%ebp)
  dc:	50                   	push   %eax
  dd:	e8 f8 02 00 00       	call   3da <exec>
  e2:	83 c4 10             	add    $0x10,%esp
    
    // if the executed command is not valid, print an error
    printf(1, "Not a valid command. \n");
  e5:	83 ec 08             	sub    $0x8,%esp
  e8:	68 33 09 00 00       	push   $0x933
  ed:	6a 01                	push   $0x1
  ef:	e8 6d 04 00 00       	call   561 <printf>
  f4:	83 c4 10             	add    $0x10,%esp
  }

  return 0;
  f7:	b8 00 00 00 00       	mov    $0x0,%eax
} 
  fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <main>:

int
main(int argc, char *argv[])
{
 101:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 105:	83 e4 f0             	and    $0xfffffff0,%esp
 108:	ff 71 fc             	pushl  -0x4(%ecx)
 10b:	55                   	push   %ebp
 10c:	89 e5                	mov    %esp,%ebp
 10e:	51                   	push   %ecx
 10f:	83 ec 04             	sub    $0x4,%esp
 112:	89 c8                	mov    %ecx,%eax

  // if there is an arg then keep track of the time,
  // otherwise no program, so 0.00 secs is printed
  if (argv[1] != 0)
 114:	8b 50 04             	mov    0x4(%eax),%edx
 117:	83 c2 04             	add    $0x4,%edx
 11a:	8b 12                	mov    (%edx),%edx
 11c:	85 d2                	test   %edx,%edx
 11e:	74 14                	je     134 <main+0x33>
    time(&argv[1]);
 120:	8b 40 04             	mov    0x4(%eax),%eax
 123:	83 c0 04             	add    $0x4,%eax
 126:	83 ec 0c             	sub    $0xc,%esp
 129:	50                   	push   %eax
 12a:	e8 d1 fe ff ff       	call   0 <time>
 12f:	83 c4 10             	add    $0x10,%esp
 132:	eb 12                	jmp    146 <main+0x45>
  else
    printf(1, "ran in 0.00 seconds.\n");
 134:	83 ec 08             	sub    $0x8,%esp
 137:	68 4a 09 00 00       	push   $0x94a
 13c:	6a 01                	push   $0x1
 13e:	e8 1e 04 00 00       	call   561 <printf>
 143:	83 c4 10             	add    $0x10,%esp
  exit();
 146:	e8 57 02 00 00       	call   3a2 <exit>

0000014b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	57                   	push   %edi
 14f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 150:	8b 4d 08             	mov    0x8(%ebp),%ecx
 153:	8b 55 10             	mov    0x10(%ebp),%edx
 156:	8b 45 0c             	mov    0xc(%ebp),%eax
 159:	89 cb                	mov    %ecx,%ebx
 15b:	89 df                	mov    %ebx,%edi
 15d:	89 d1                	mov    %edx,%ecx
 15f:	fc                   	cld    
 160:	f3 aa                	rep stos %al,%es:(%edi)
 162:	89 ca                	mov    %ecx,%edx
 164:	89 fb                	mov    %edi,%ebx
 166:	89 5d 08             	mov    %ebx,0x8(%ebp)
 169:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 16c:	90                   	nop
 16d:	5b                   	pop    %ebx
 16e:	5f                   	pop    %edi
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    

00000171 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
 174:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 17d:	90                   	nop
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	8d 50 01             	lea    0x1(%eax),%edx
 184:	89 55 08             	mov    %edx,0x8(%ebp)
 187:	8b 55 0c             	mov    0xc(%ebp),%edx
 18a:	8d 4a 01             	lea    0x1(%edx),%ecx
 18d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 190:	0f b6 12             	movzbl (%edx),%edx
 193:	88 10                	mov    %dl,(%eax)
 195:	0f b6 00             	movzbl (%eax),%eax
 198:	84 c0                	test   %al,%al
 19a:	75 e2                	jne    17e <strcpy+0xd>
    ;
  return os;
 19c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19f:	c9                   	leave  
 1a0:	c3                   	ret    

000001a1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1a4:	eb 08                	jmp    1ae <strcmp+0xd>
    p++, q++;
 1a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1aa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	74 10                	je     1c8 <strcmp+0x27>
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	0f b6 10             	movzbl (%eax),%edx
 1be:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c1:	0f b6 00             	movzbl (%eax),%eax
 1c4:	38 c2                	cmp    %al,%dl
 1c6:	74 de                	je     1a6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	0f b6 00             	movzbl (%eax),%eax
 1ce:	0f b6 d0             	movzbl %al,%edx
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	0f b6 00             	movzbl (%eax),%eax
 1d7:	0f b6 c0             	movzbl %al,%eax
 1da:	29 c2                	sub    %eax,%edx
 1dc:	89 d0                	mov    %edx,%eax
}
 1de:	5d                   	pop    %ebp
 1df:	c3                   	ret    

000001e0 <strlen>:

uint
strlen(char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ed:	eb 04                	jmp    1f3 <strlen+0x13>
 1ef:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	01 d0                	add    %edx,%eax
 1fb:	0f b6 00             	movzbl (%eax),%eax
 1fe:	84 c0                	test   %al,%al
 200:	75 ed                	jne    1ef <strlen+0xf>
    ;
  return n;
 202:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <memset>:

void*
memset(void *dst, int c, uint n)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 20a:	8b 45 10             	mov    0x10(%ebp),%eax
 20d:	50                   	push   %eax
 20e:	ff 75 0c             	pushl  0xc(%ebp)
 211:	ff 75 08             	pushl  0x8(%ebp)
 214:	e8 32 ff ff ff       	call   14b <stosb>
 219:	83 c4 0c             	add    $0xc,%esp
  return dst;
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <strchr>:

char*
strchr(const char *s, char c)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	83 ec 04             	sub    $0x4,%esp
 227:	8b 45 0c             	mov    0xc(%ebp),%eax
 22a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 22d:	eb 14                	jmp    243 <strchr+0x22>
    if(*s == c)
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3a 45 fc             	cmp    -0x4(%ebp),%al
 238:	75 05                	jne    23f <strchr+0x1e>
      return (char*)s;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	eb 13                	jmp    252 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 23f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	84 c0                	test   %al,%al
 24b:	75 e2                	jne    22f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 24d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 252:	c9                   	leave  
 253:	c3                   	ret    

00000254 <gets>:

char*
gets(char *buf, int max)
{
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 261:	eb 42                	jmp    2a5 <gets+0x51>
    cc = read(0, &c, 1);
 263:	83 ec 04             	sub    $0x4,%esp
 266:	6a 01                	push   $0x1
 268:	8d 45 ef             	lea    -0x11(%ebp),%eax
 26b:	50                   	push   %eax
 26c:	6a 00                	push   $0x0
 26e:	e8 47 01 00 00       	call   3ba <read>
 273:	83 c4 10             	add    $0x10,%esp
 276:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27d:	7e 33                	jle    2b2 <gets+0x5e>
      break;
    buf[i++] = c;
 27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 282:	8d 50 01             	lea    0x1(%eax),%edx
 285:	89 55 f4             	mov    %edx,-0xc(%ebp)
 288:	89 c2                	mov    %eax,%edx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	01 c2                	add    %eax,%edx
 28f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 293:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 295:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 299:	3c 0a                	cmp    $0xa,%al
 29b:	74 16                	je     2b3 <gets+0x5f>
 29d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a1:	3c 0d                	cmp    $0xd,%al
 2a3:	74 0e                	je     2b3 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a8:	83 c0 01             	add    $0x1,%eax
 2ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2ae:	7c b3                	jl     263 <gets+0xf>
 2b0:	eb 01                	jmp    2b3 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2b2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	01 d0                	add    %edx,%eax
 2bb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <stat>:

int
stat(char *n, struct stat *st)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	6a 00                	push   $0x0
 2ce:	ff 75 08             	pushl  0x8(%ebp)
 2d1:	e8 0c 01 00 00       	call   3e2 <open>
 2d6:	83 c4 10             	add    $0x10,%esp
 2d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e0:	79 07                	jns    2e9 <stat+0x26>
    return -1;
 2e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e7:	eb 25                	jmp    30e <stat+0x4b>
  r = fstat(fd, st);
 2e9:	83 ec 08             	sub    $0x8,%esp
 2ec:	ff 75 0c             	pushl  0xc(%ebp)
 2ef:	ff 75 f4             	pushl  -0xc(%ebp)
 2f2:	e8 03 01 00 00       	call   3fa <fstat>
 2f7:	83 c4 10             	add    $0x10,%esp
 2fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2fd:	83 ec 0c             	sub    $0xc,%esp
 300:	ff 75 f4             	pushl  -0xc(%ebp)
 303:	e8 c2 00 00 00       	call   3ca <close>
 308:	83 c4 10             	add    $0x10,%esp
  return r;
 30b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 316:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31d:	eb 25                	jmp    344 <atoi+0x34>
    n = n*10 + *s++ - '0';
 31f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 322:	89 d0                	mov    %edx,%eax
 324:	c1 e0 02             	shl    $0x2,%eax
 327:	01 d0                	add    %edx,%eax
 329:	01 c0                	add    %eax,%eax
 32b:	89 c1                	mov    %eax,%ecx
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	8d 50 01             	lea    0x1(%eax),%edx
 333:	89 55 08             	mov    %edx,0x8(%ebp)
 336:	0f b6 00             	movzbl (%eax),%eax
 339:	0f be c0             	movsbl %al,%eax
 33c:	01 c8                	add    %ecx,%eax
 33e:	83 e8 30             	sub    $0x30,%eax
 341:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	3c 2f                	cmp    $0x2f,%al
 34c:	7e 0a                	jle    358 <atoi+0x48>
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	0f b6 00             	movzbl (%eax),%eax
 354:	3c 39                	cmp    $0x39,%al
 356:	7e c7                	jle    31f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 358:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35b:	c9                   	leave  
 35c:	c3                   	ret    

0000035d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 369:	8b 45 0c             	mov    0xc(%ebp),%eax
 36c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 36f:	eb 17                	jmp    388 <memmove+0x2b>
    *dst++ = *src++;
 371:	8b 45 fc             	mov    -0x4(%ebp),%eax
 374:	8d 50 01             	lea    0x1(%eax),%edx
 377:	89 55 fc             	mov    %edx,-0x4(%ebp)
 37a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37d:	8d 4a 01             	lea    0x1(%edx),%ecx
 380:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 383:	0f b6 12             	movzbl (%edx),%edx
 386:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 388:	8b 45 10             	mov    0x10(%ebp),%eax
 38b:	8d 50 ff             	lea    -0x1(%eax),%edx
 38e:	89 55 10             	mov    %edx,0x10(%ebp)
 391:	85 c0                	test   %eax,%eax
 393:	7f dc                	jg     371 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 395:	8b 45 08             	mov    0x8(%ebp),%eax
}
 398:	c9                   	leave  
 399:	c3                   	ret    

0000039a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39a:	b8 01 00 00 00       	mov    $0x1,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <exit>:
SYSCALL(exit)
 3a2:	b8 02 00 00 00       	mov    $0x2,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <wait>:
SYSCALL(wait)
 3aa:	b8 03 00 00 00       	mov    $0x3,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <pipe>:
SYSCALL(pipe)
 3b2:	b8 04 00 00 00       	mov    $0x4,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <read>:
SYSCALL(read)
 3ba:	b8 05 00 00 00       	mov    $0x5,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <write>:
SYSCALL(write)
 3c2:	b8 10 00 00 00       	mov    $0x10,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <close>:
SYSCALL(close)
 3ca:	b8 15 00 00 00       	mov    $0x15,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <kill>:
SYSCALL(kill)
 3d2:	b8 06 00 00 00       	mov    $0x6,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <exec>:
SYSCALL(exec)
 3da:	b8 07 00 00 00       	mov    $0x7,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <open>:
SYSCALL(open)
 3e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <mknod>:
SYSCALL(mknod)
 3ea:	b8 11 00 00 00       	mov    $0x11,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <unlink>:
SYSCALL(unlink)
 3f2:	b8 12 00 00 00       	mov    $0x12,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <fstat>:
SYSCALL(fstat)
 3fa:	b8 08 00 00 00       	mov    $0x8,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <link>:
SYSCALL(link)
 402:	b8 13 00 00 00       	mov    $0x13,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <mkdir>:
SYSCALL(mkdir)
 40a:	b8 14 00 00 00       	mov    $0x14,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <chdir>:
SYSCALL(chdir)
 412:	b8 09 00 00 00       	mov    $0x9,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <dup>:
SYSCALL(dup)
 41a:	b8 0a 00 00 00       	mov    $0xa,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <getpid>:
SYSCALL(getpid)
 422:	b8 0b 00 00 00       	mov    $0xb,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <sbrk>:
SYSCALL(sbrk)
 42a:	b8 0c 00 00 00       	mov    $0xc,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <sleep>:
SYSCALL(sleep)
 432:	b8 0d 00 00 00       	mov    $0xd,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <uptime>:
SYSCALL(uptime)
 43a:	b8 0e 00 00 00       	mov    $0xe,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <halt>:
SYSCALL(halt)
 442:	b8 16 00 00 00       	mov    $0x16,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 44a:	b8 17 00 00 00       	mov    $0x17,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 452:	b8 18 00 00 00       	mov    $0x18,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 45a:	b8 19 00 00 00       	mov    $0x19,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 462:	b8 1a 00 00 00       	mov    $0x1a,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 46a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 472:	b8 1c 00 00 00       	mov    $0x1c,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 47a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 482:	b8 1b 00 00 00       	mov    $0x1b,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 48a:	55                   	push   %ebp
 48b:	89 e5                	mov    %esp,%ebp
 48d:	83 ec 18             	sub    $0x18,%esp
 490:	8b 45 0c             	mov    0xc(%ebp),%eax
 493:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 496:	83 ec 04             	sub    $0x4,%esp
 499:	6a 01                	push   $0x1
 49b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 49e:	50                   	push   %eax
 49f:	ff 75 08             	pushl  0x8(%ebp)
 4a2:	e8 1b ff ff ff       	call   3c2 <write>
 4a7:	83 c4 10             	add    $0x10,%esp
}
 4aa:	90                   	nop
 4ab:	c9                   	leave  
 4ac:	c3                   	ret    

000004ad <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ad:	55                   	push   %ebp
 4ae:	89 e5                	mov    %esp,%ebp
 4b0:	53                   	push   %ebx
 4b1:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4bb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4bf:	74 17                	je     4d8 <printint+0x2b>
 4c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4c5:	79 11                	jns    4d8 <printint+0x2b>
    neg = 1;
 4c7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d1:	f7 d8                	neg    %eax
 4d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d6:	eb 06                	jmp    4de <printint+0x31>
  } else {
    x = xx;
 4d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4e5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4e8:	8d 41 01             	lea    0x1(%ecx),%eax
 4eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f4:	ba 00 00 00 00       	mov    $0x0,%edx
 4f9:	f7 f3                	div    %ebx
 4fb:	89 d0                	mov    %edx,%eax
 4fd:	0f b6 80 d4 0b 00 00 	movzbl 0xbd4(%eax),%eax
 504:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 508:	8b 5d 10             	mov    0x10(%ebp),%ebx
 50b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50e:	ba 00 00 00 00       	mov    $0x0,%edx
 513:	f7 f3                	div    %ebx
 515:	89 45 ec             	mov    %eax,-0x14(%ebp)
 518:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51c:	75 c7                	jne    4e5 <printint+0x38>
  if(neg)
 51e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 522:	74 2d                	je     551 <printint+0xa4>
    buf[i++] = '-';
 524:	8b 45 f4             	mov    -0xc(%ebp),%eax
 527:	8d 50 01             	lea    0x1(%eax),%edx
 52a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 52d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 532:	eb 1d                	jmp    551 <printint+0xa4>
    putc(fd, buf[i]);
 534:	8d 55 dc             	lea    -0x24(%ebp),%edx
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	01 d0                	add    %edx,%eax
 53c:	0f b6 00             	movzbl (%eax),%eax
 53f:	0f be c0             	movsbl %al,%eax
 542:	83 ec 08             	sub    $0x8,%esp
 545:	50                   	push   %eax
 546:	ff 75 08             	pushl  0x8(%ebp)
 549:	e8 3c ff ff ff       	call   48a <putc>
 54e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 551:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 555:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 559:	79 d9                	jns    534 <printint+0x87>
    putc(fd, buf[i]);
}
 55b:	90                   	nop
 55c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 55f:	c9                   	leave  
 560:	c3                   	ret    

00000561 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 561:	55                   	push   %ebp
 562:	89 e5                	mov    %esp,%ebp
 564:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 567:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 56e:	8d 45 0c             	lea    0xc(%ebp),%eax
 571:	83 c0 04             	add    $0x4,%eax
 574:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 577:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 57e:	e9 59 01 00 00       	jmp    6dc <printf+0x17b>
    c = fmt[i] & 0xff;
 583:	8b 55 0c             	mov    0xc(%ebp),%edx
 586:	8b 45 f0             	mov    -0x10(%ebp),%eax
 589:	01 d0                	add    %edx,%eax
 58b:	0f b6 00             	movzbl (%eax),%eax
 58e:	0f be c0             	movsbl %al,%eax
 591:	25 ff 00 00 00       	and    $0xff,%eax
 596:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 599:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 59d:	75 2c                	jne    5cb <printf+0x6a>
      if(c == '%'){
 59f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a3:	75 0c                	jne    5b1 <printf+0x50>
        state = '%';
 5a5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ac:	e9 27 01 00 00       	jmp    6d8 <printf+0x177>
      } else {
        putc(fd, c);
 5b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b4:	0f be c0             	movsbl %al,%eax
 5b7:	83 ec 08             	sub    $0x8,%esp
 5ba:	50                   	push   %eax
 5bb:	ff 75 08             	pushl  0x8(%ebp)
 5be:	e8 c7 fe ff ff       	call   48a <putc>
 5c3:	83 c4 10             	add    $0x10,%esp
 5c6:	e9 0d 01 00 00       	jmp    6d8 <printf+0x177>
      }
    } else if(state == '%'){
 5cb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5cf:	0f 85 03 01 00 00    	jne    6d8 <printf+0x177>
      if(c == 'd'){
 5d5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5d9:	75 1e                	jne    5f9 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5db:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5de:	8b 00                	mov    (%eax),%eax
 5e0:	6a 01                	push   $0x1
 5e2:	6a 0a                	push   $0xa
 5e4:	50                   	push   %eax
 5e5:	ff 75 08             	pushl  0x8(%ebp)
 5e8:	e8 c0 fe ff ff       	call   4ad <printint>
 5ed:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f4:	e9 d8 00 00 00       	jmp    6d1 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5f9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5fd:	74 06                	je     605 <printf+0xa4>
 5ff:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 603:	75 1e                	jne    623 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 605:	8b 45 e8             	mov    -0x18(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	6a 00                	push   $0x0
 60c:	6a 10                	push   $0x10
 60e:	50                   	push   %eax
 60f:	ff 75 08             	pushl  0x8(%ebp)
 612:	e8 96 fe ff ff       	call   4ad <printint>
 617:	83 c4 10             	add    $0x10,%esp
        ap++;
 61a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61e:	e9 ae 00 00 00       	jmp    6d1 <printf+0x170>
      } else if(c == 's'){
 623:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 627:	75 43                	jne    66c <printf+0x10b>
        s = (char*)*ap;
 629:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 631:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 635:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 639:	75 25                	jne    660 <printf+0xff>
          s = "(null)";
 63b:	c7 45 f4 60 09 00 00 	movl   $0x960,-0xc(%ebp)
        while(*s != 0){
 642:	eb 1c                	jmp    660 <printf+0xff>
          putc(fd, *s);
 644:	8b 45 f4             	mov    -0xc(%ebp),%eax
 647:	0f b6 00             	movzbl (%eax),%eax
 64a:	0f be c0             	movsbl %al,%eax
 64d:	83 ec 08             	sub    $0x8,%esp
 650:	50                   	push   %eax
 651:	ff 75 08             	pushl  0x8(%ebp)
 654:	e8 31 fe ff ff       	call   48a <putc>
 659:	83 c4 10             	add    $0x10,%esp
          s++;
 65c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 660:	8b 45 f4             	mov    -0xc(%ebp),%eax
 663:	0f b6 00             	movzbl (%eax),%eax
 666:	84 c0                	test   %al,%al
 668:	75 da                	jne    644 <printf+0xe3>
 66a:	eb 65                	jmp    6d1 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 670:	75 1d                	jne    68f <printf+0x12e>
        putc(fd, *ap);
 672:	8b 45 e8             	mov    -0x18(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	0f be c0             	movsbl %al,%eax
 67a:	83 ec 08             	sub    $0x8,%esp
 67d:	50                   	push   %eax
 67e:	ff 75 08             	pushl  0x8(%ebp)
 681:	e8 04 fe ff ff       	call   48a <putc>
 686:	83 c4 10             	add    $0x10,%esp
        ap++;
 689:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68d:	eb 42                	jmp    6d1 <printf+0x170>
      } else if(c == '%'){
 68f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 693:	75 17                	jne    6ac <printf+0x14b>
        putc(fd, c);
 695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 698:	0f be c0             	movsbl %al,%eax
 69b:	83 ec 08             	sub    $0x8,%esp
 69e:	50                   	push   %eax
 69f:	ff 75 08             	pushl  0x8(%ebp)
 6a2:	e8 e3 fd ff ff       	call   48a <putc>
 6a7:	83 c4 10             	add    $0x10,%esp
 6aa:	eb 25                	jmp    6d1 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ac:	83 ec 08             	sub    $0x8,%esp
 6af:	6a 25                	push   $0x25
 6b1:	ff 75 08             	pushl  0x8(%ebp)
 6b4:	e8 d1 fd ff ff       	call   48a <putc>
 6b9:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6bf:	0f be c0             	movsbl %al,%eax
 6c2:	83 ec 08             	sub    $0x8,%esp
 6c5:	50                   	push   %eax
 6c6:	ff 75 08             	pushl  0x8(%ebp)
 6c9:	e8 bc fd ff ff       	call   48a <putc>
 6ce:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6dc:	8b 55 0c             	mov    0xc(%ebp),%edx
 6df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e2:	01 d0                	add    %edx,%eax
 6e4:	0f b6 00             	movzbl (%eax),%eax
 6e7:	84 c0                	test   %al,%al
 6e9:	0f 85 94 fe ff ff    	jne    583 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6ef:	90                   	nop
 6f0:	c9                   	leave  
 6f1:	c3                   	ret    

000006f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f2:	55                   	push   %ebp
 6f3:	89 e5                	mov    %esp,%ebp
 6f5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f8:	8b 45 08             	mov    0x8(%ebp),%eax
 6fb:	83 e8 08             	sub    $0x8,%eax
 6fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 706:	89 45 fc             	mov    %eax,-0x4(%ebp)
 709:	eb 24                	jmp    72f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 713:	77 12                	ja     727 <free+0x35>
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71b:	77 24                	ja     741 <free+0x4f>
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 725:	77 1a                	ja     741 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	8b 00                	mov    (%eax),%eax
 72c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 735:	76 d4                	jbe    70b <free+0x19>
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 00                	mov    (%eax),%eax
 73c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73f:	76 ca                	jbe    70b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 741:	8b 45 f8             	mov    -0x8(%ebp),%eax
 744:	8b 40 04             	mov    0x4(%eax),%eax
 747:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	01 c2                	add    %eax,%edx
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	8b 00                	mov    (%eax),%eax
 758:	39 c2                	cmp    %eax,%edx
 75a:	75 24                	jne    780 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 75c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75f:	8b 50 04             	mov    0x4(%eax),%edx
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 00                	mov    (%eax),%eax
 767:	8b 40 04             	mov    0x4(%eax),%eax
 76a:	01 c2                	add    %eax,%edx
 76c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	8b 10                	mov    (%eax),%edx
 779:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77c:	89 10                	mov    %edx,(%eax)
 77e:	eb 0a                	jmp    78a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	8b 10                	mov    (%eax),%edx
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	8b 40 04             	mov    0x4(%eax),%eax
 790:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	01 d0                	add    %edx,%eax
 79c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79f:	75 20                	jne    7c1 <free+0xcf>
    p->s.size += bp->s.size;
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 50 04             	mov    0x4(%eax),%edx
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	01 c2                	add    %eax,%edx
 7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b8:	8b 10                	mov    (%eax),%edx
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	89 10                	mov    %edx,(%eax)
 7bf:	eb 08                	jmp    7c9 <free+0xd7>
  } else
    p->s.ptr = bp;
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	a3 f0 0b 00 00       	mov    %eax,0xbf0
}
 7d1:	90                   	nop
 7d2:	c9                   	leave  
 7d3:	c3                   	ret    

000007d4 <morecore>:

static Header*
morecore(uint nu)
{
 7d4:	55                   	push   %ebp
 7d5:	89 e5                	mov    %esp,%ebp
 7d7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7da:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7e1:	77 07                	ja     7ea <morecore+0x16>
    nu = 4096;
 7e3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ea:	8b 45 08             	mov    0x8(%ebp),%eax
 7ed:	c1 e0 03             	shl    $0x3,%eax
 7f0:	83 ec 0c             	sub    $0xc,%esp
 7f3:	50                   	push   %eax
 7f4:	e8 31 fc ff ff       	call   42a <sbrk>
 7f9:	83 c4 10             	add    $0x10,%esp
 7fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ff:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 803:	75 07                	jne    80c <morecore+0x38>
    return 0;
 805:	b8 00 00 00 00       	mov    $0x0,%eax
 80a:	eb 26                	jmp    832 <morecore+0x5e>
  hp = (Header*)p;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 812:	8b 45 f0             	mov    -0x10(%ebp),%eax
 815:	8b 55 08             	mov    0x8(%ebp),%edx
 818:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 81b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81e:	83 c0 08             	add    $0x8,%eax
 821:	83 ec 0c             	sub    $0xc,%esp
 824:	50                   	push   %eax
 825:	e8 c8 fe ff ff       	call   6f2 <free>
 82a:	83 c4 10             	add    $0x10,%esp
  return freep;
 82d:	a1 f0 0b 00 00       	mov    0xbf0,%eax
}
 832:	c9                   	leave  
 833:	c3                   	ret    

00000834 <malloc>:

void*
malloc(uint nbytes)
{
 834:	55                   	push   %ebp
 835:	89 e5                	mov    %esp,%ebp
 837:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83a:	8b 45 08             	mov    0x8(%ebp),%eax
 83d:	83 c0 07             	add    $0x7,%eax
 840:	c1 e8 03             	shr    $0x3,%eax
 843:	83 c0 01             	add    $0x1,%eax
 846:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 849:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 84e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 851:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 855:	75 23                	jne    87a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 857:	c7 45 f0 e8 0b 00 00 	movl   $0xbe8,-0x10(%ebp)
 85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 861:	a3 f0 0b 00 00       	mov    %eax,0xbf0
 866:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 86b:	a3 e8 0b 00 00       	mov    %eax,0xbe8
    base.s.size = 0;
 870:	c7 05 ec 0b 00 00 00 	movl   $0x0,0xbec
 877:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87d:	8b 00                	mov    (%eax),%eax
 87f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	8b 40 04             	mov    0x4(%eax),%eax
 888:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 88b:	72 4d                	jb     8da <malloc+0xa6>
      if(p->s.size == nunits)
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	8b 40 04             	mov    0x4(%eax),%eax
 893:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 896:	75 0c                	jne    8a4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 10                	mov    (%eax),%edx
 89d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a0:	89 10                	mov    %edx,(%eax)
 8a2:	eb 26                	jmp    8ca <malloc+0x96>
      else {
        p->s.size -= nunits;
 8a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a7:	8b 40 04             	mov    0x4(%eax),%eax
 8aa:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ad:	89 c2                	mov    %eax,%edx
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	8b 40 04             	mov    0x4(%eax),%eax
 8bb:	c1 e0 03             	shl    $0x3,%eax
 8be:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8c7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cd:	a3 f0 0b 00 00       	mov    %eax,0xbf0
      return (void*)(p + 1);
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	83 c0 08             	add    $0x8,%eax
 8d8:	eb 3b                	jmp    915 <malloc+0xe1>
    }
    if(p == freep)
 8da:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 8df:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8e2:	75 1e                	jne    902 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8e4:	83 ec 0c             	sub    $0xc,%esp
 8e7:	ff 75 ec             	pushl  -0x14(%ebp)
 8ea:	e8 e5 fe ff ff       	call   7d4 <morecore>
 8ef:	83 c4 10             	add    $0x10,%esp
 8f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8f9:	75 07                	jne    902 <malloc+0xce>
        return 0;
 8fb:	b8 00 00 00 00       	mov    $0x0,%eax
 900:	eb 13                	jmp    915 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	89 45 f0             	mov    %eax,-0x10(%ebp)
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	8b 00                	mov    (%eax),%eax
 90d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 910:	e9 6d ff ff ff       	jmp    882 <malloc+0x4e>
}
 915:	c9                   	leave  
 916:	c3                   	ret    
