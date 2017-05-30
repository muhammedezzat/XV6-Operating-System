
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

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
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 76 09 00 00       	push   $0x976
  1b:	e8 06 04 00 00       	call   426 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 76 09 00 00       	push   $0x976
  33:	e8 f6 03 00 00       	call   42e <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 76 09 00 00       	push   $0x976
  45:	e8 dc 03 00 00       	call   426 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 07 04 00 00       	call   45e <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 fa 03 00 00       	call   45e <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 7e 09 00 00       	push   $0x97e
  6f:	6a 01                	push   $0x1
  71:	e8 47 05 00 00       	call   5bd <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 60 03 00 00       	call   3de <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 91 09 00 00       	push   $0x991
  8f:	6a 01                	push   $0x1
  91:	e8 27 05 00 00       	call   5bd <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 48 03 00 00       	call   3e6 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 34 0c 00 00       	push   $0xc34
  ac:	68 73 09 00 00       	push   $0x973
  b1:	e8 68 03 00 00       	call   41e <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 a4 09 00 00       	push   $0x9a4
  c1:	6a 01                	push   $0x1
  c3:	e8 f5 04 00 00       	call   5bd <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 16 03 00 00       	call   3e6 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 ba 09 00 00       	push   $0x9ba
  d8:	6a 01                	push   $0x1
  da:	e8 de 04 00 00       	call   5bd <printf>
  df:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	e8 07 03 00 00       	call   3ee <wait>
  e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ee:	0f 88 73 ff ff ff    	js     67 <main+0x67>
  f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fa:	75 d4                	jne    d0 <main+0xd0>
      printf(1, "zombie!\n");
  }
  fc:	e9 66 ff ff ff       	jmp    67 <main+0x67>

00000101 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 10             	mov    0x10(%ebp),%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 cb                	mov    %ecx,%ebx
 111:	89 df                	mov    %ebx,%edi
 113:	89 d1                	mov    %edx,%ecx
 115:	fc                   	cld    
 116:	f3 aa                	rep stos %al,%es:(%edi)
 118:	89 ca                	mov    %ecx,%edx
 11a:	89 fb                	mov    %edi,%ebx
 11c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 122:	90                   	nop
 123:	5b                   	pop    %ebx
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 133:	90                   	nop
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8d 50 01             	lea    0x1(%eax),%edx
 13a:	89 55 08             	mov    %edx,0x8(%ebp)
 13d:	8b 55 0c             	mov    0xc(%ebp),%edx
 140:	8d 4a 01             	lea    0x1(%edx),%ecx
 143:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 146:	0f b6 12             	movzbl (%edx),%edx
 149:	88 10                	mov    %dl,(%eax)
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strcpy+0xd>
    ;
  return os;
 152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 155:	c9                   	leave  
 156:	c3                   	ret    

00000157 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15a:	eb 08                	jmp    164 <strcmp+0xd>
    p++, q++;
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	74 10                	je     17e <strcmp+0x27>
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 c2                	cmp    %al,%dl
 17c:	74 de                	je     15c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	0f b6 d0             	movzbl %al,%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	0f b6 c0             	movzbl %al,%eax
 190:	29 c2                	sub    %eax,%edx
 192:	89 d0                	mov    %edx,%eax
}
 194:	5d                   	pop    %ebp
 195:	c3                   	ret    

00000196 <strlen>:

uint
strlen(char *s)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a3:	eb 04                	jmp    1a9 <strlen+0x13>
 1a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 d0                	add    %edx,%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	75 ed                	jne    1a5 <strlen+0xf>
    ;
  return n;
 1b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
 1c3:	50                   	push   %eax
 1c4:	ff 75 0c             	pushl  0xc(%ebp)
 1c7:	ff 75 08             	pushl  0x8(%ebp)
 1ca:	e8 32 ff ff ff       	call   101 <stosb>
 1cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <strchr>:

char*
strchr(const char *s, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 14                	jmp    1f9 <strchr+0x22>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ee:	75 05                	jne    1f5 <strchr+0x1e>
      return (char*)s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	eb 13                	jmp    208 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 42                	jmp    25b <gets+0x51>
    cc = read(0, &c, 1);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	6a 01                	push   $0x1
 21e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 221:	50                   	push   %eax
 222:	6a 00                	push   $0x0
 224:	e8 d5 01 00 00       	call   3fe <read>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 233:	7e 33                	jle    268 <gets+0x5e>
      break;
    buf[i++] = c;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23e:	89 c2                	mov    %eax,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	01 c2                	add    %eax,%edx
 245:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 249:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 16                	je     269 <gets+0x5f>
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	3c 0d                	cmp    $0xd,%al
 259:	74 0e                	je     269 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	83 c0 01             	add    $0x1,%eax
 261:	3b 45 0c             	cmp    0xc(%ebp),%eax
 264:	7c b3                	jl     219 <gets+0xf>
 266:	eb 01                	jmp    269 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 268:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 269:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	01 d0                	add    %edx,%eax
 271:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <stat>:

int
stat(char *n, struct stat *st)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 9a 01 00 00       	call   426 <open>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 296:	79 07                	jns    29f <stat+0x26>
    return -1;
 298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29d:	eb 25                	jmp    2c4 <stat+0x4b>
  r = fstat(fd, st);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	ff 75 0c             	pushl  0xc(%ebp)
 2a5:	ff 75 f4             	pushl  -0xc(%ebp)
 2a8:	e8 91 01 00 00       	call   43e <fstat>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 75 f4             	pushl  -0xc(%ebp)
 2b9:	e8 50 01 00 00       	call   40e <close>
 2be:	83 c4 10             	add    $0x10,%esp
  return r;
 2c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <atoi>:

int
atoi(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d3:	eb 25                	jmp    2fa <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d8:	89 d0                	mov    %edx,%eax
 2da:	c1 e0 02             	shl    $0x2,%eax
 2dd:	01 d0                	add    %edx,%eax
 2df:	01 c0                	add    %eax,%eax
 2e1:	89 c1                	mov    %eax,%ecx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8d 50 01             	lea    0x1(%eax),%edx
 2e9:	89 55 08             	mov    %edx,0x8(%ebp)
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	0f be c0             	movsbl %al,%eax
 2f2:	01 c8                	add    %ecx,%eax
 2f4:	83 e8 30             	sub    $0x30,%eax
 2f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 2f                	cmp    $0x2f,%al
 302:	7e 0a                	jle    30e <atoi+0x48>
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	3c 39                	cmp    $0x39,%al
 30c:	7e c7                	jle    2d5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 30e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 325:	eb 17                	jmp    33e <memmove+0x2b>
    *dst++ = *src++;
 327:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32a:	8d 50 01             	lea    0x1(%eax),%edx
 32d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 330:	8b 55 f8             	mov    -0x8(%ebp),%edx
 333:	8d 4a 01             	lea    0x1(%edx),%ecx
 336:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 339:	0f b6 12             	movzbl (%edx),%edx
 33c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33e:	8b 45 10             	mov    0x10(%ebp),%eax
 341:	8d 50 ff             	lea    -0x1(%eax),%edx
 344:	89 55 10             	mov    %edx,0x10(%ebp)
 347:	85 c0                	test   %eax,%eax
 349:	7f dc                	jg     327 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34e:	c9                   	leave  
 34f:	c3                   	ret    

00000350 <atoo>:

int
atoo(const char *s)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 35d:	eb 04                	jmp    363 <atoo+0x13>
 35f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	0f b6 00             	movzbl (%eax),%eax
 369:	3c 20                	cmp    $0x20,%al
 36b:	74 f2                	je     35f <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	0f b6 00             	movzbl (%eax),%eax
 373:	3c 2d                	cmp    $0x2d,%al
 375:	75 07                	jne    37e <atoo+0x2e>
 377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 37c:	eb 05                	jmp    383 <atoo+0x33>
 37e:	b8 01 00 00 00       	mov    $0x1,%eax
 383:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	0f b6 00             	movzbl (%eax),%eax
 38c:	3c 2b                	cmp    $0x2b,%al
 38e:	74 0a                	je     39a <atoo+0x4a>
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	3c 2d                	cmp    $0x2d,%al
 398:	75 27                	jne    3c1 <atoo+0x71>
    s++;
 39a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 39e:	eb 21                	jmp    3c1 <atoo+0x71>
    n = n*8 + *s++ - '0';
 3a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3a3:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
 3ad:	8d 50 01             	lea    0x1(%eax),%edx
 3b0:	89 55 08             	mov    %edx,0x8(%ebp)
 3b3:	0f b6 00             	movzbl (%eax),%eax
 3b6:	0f be c0             	movsbl %al,%eax
 3b9:	01 c8                	add    %ecx,%eax
 3bb:	83 e8 30             	sub    $0x30,%eax
 3be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	0f b6 00             	movzbl (%eax),%eax
 3c7:	3c 2f                	cmp    $0x2f,%al
 3c9:	7e 0a                	jle    3d5 <atoo+0x85>
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	0f b6 00             	movzbl (%eax),%eax
 3d1:	3c 37                	cmp    $0x37,%al
 3d3:	7e cb                	jle    3a0 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3d8:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3dc:	c9                   	leave  
 3dd:	c3                   	ret    

000003de <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3de:	b8 01 00 00 00       	mov    $0x1,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <exit>:
SYSCALL(exit)
 3e6:	b8 02 00 00 00       	mov    $0x2,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <wait>:
SYSCALL(wait)
 3ee:	b8 03 00 00 00       	mov    $0x3,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <pipe>:
SYSCALL(pipe)
 3f6:	b8 04 00 00 00       	mov    $0x4,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <read>:
SYSCALL(read)
 3fe:	b8 05 00 00 00       	mov    $0x5,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <write>:
SYSCALL(write)
 406:	b8 10 00 00 00       	mov    $0x10,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <close>:
SYSCALL(close)
 40e:	b8 15 00 00 00       	mov    $0x15,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <kill>:
SYSCALL(kill)
 416:	b8 06 00 00 00       	mov    $0x6,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <exec>:
SYSCALL(exec)
 41e:	b8 07 00 00 00       	mov    $0x7,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <open>:
SYSCALL(open)
 426:	b8 0f 00 00 00       	mov    $0xf,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <mknod>:
SYSCALL(mknod)
 42e:	b8 11 00 00 00       	mov    $0x11,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <unlink>:
SYSCALL(unlink)
 436:	b8 12 00 00 00       	mov    $0x12,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <fstat>:
SYSCALL(fstat)
 43e:	b8 08 00 00 00       	mov    $0x8,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <link>:
SYSCALL(link)
 446:	b8 13 00 00 00       	mov    $0x13,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <mkdir>:
SYSCALL(mkdir)
 44e:	b8 14 00 00 00       	mov    $0x14,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <chdir>:
SYSCALL(chdir)
 456:	b8 09 00 00 00       	mov    $0x9,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <dup>:
SYSCALL(dup)
 45e:	b8 0a 00 00 00       	mov    $0xa,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <getpid>:
SYSCALL(getpid)
 466:	b8 0b 00 00 00       	mov    $0xb,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <sbrk>:
SYSCALL(sbrk)
 46e:	b8 0c 00 00 00       	mov    $0xc,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <sleep>:
SYSCALL(sleep)
 476:	b8 0d 00 00 00       	mov    $0xd,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <uptime>:
SYSCALL(uptime)
 47e:	b8 0e 00 00 00       	mov    $0xe,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <halt>:
SYSCALL(halt)
 486:	b8 16 00 00 00       	mov    $0x16,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 48e:	b8 17 00 00 00       	mov    $0x17,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 496:	b8 18 00 00 00       	mov    $0x18,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 49e:	b8 19 00 00 00       	mov    $0x19,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 4a6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 4ae:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 4b6:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 4be:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 4c6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 4ce:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 4d6:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 4de:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e6:	55                   	push   %ebp
 4e7:	89 e5                	mov    %esp,%ebp
 4e9:	83 ec 18             	sub    $0x18,%esp
 4ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ef:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f2:	83 ec 04             	sub    $0x4,%esp
 4f5:	6a 01                	push   $0x1
 4f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4fa:	50                   	push   %eax
 4fb:	ff 75 08             	pushl  0x8(%ebp)
 4fe:	e8 03 ff ff ff       	call   406 <write>
 503:	83 c4 10             	add    $0x10,%esp
}
 506:	90                   	nop
 507:	c9                   	leave  
 508:	c3                   	ret    

00000509 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	53                   	push   %ebx
 50d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 510:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 517:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 51b:	74 17                	je     534 <printint+0x2b>
 51d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 521:	79 11                	jns    534 <printint+0x2b>
    neg = 1;
 523:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 52a:	8b 45 0c             	mov    0xc(%ebp),%eax
 52d:	f7 d8                	neg    %eax
 52f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 532:	eb 06                	jmp    53a <printint+0x31>
  } else {
    x = xx;
 534:	8b 45 0c             	mov    0xc(%ebp),%eax
 537:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 53a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 541:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 544:	8d 41 01             	lea    0x1(%ecx),%eax
 547:	89 45 f4             	mov    %eax,-0xc(%ebp)
 54a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 54d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 550:	ba 00 00 00 00       	mov    $0x0,%edx
 555:	f7 f3                	div    %ebx
 557:	89 d0                	mov    %edx,%eax
 559:	0f b6 80 3c 0c 00 00 	movzbl 0xc3c(%eax),%eax
 560:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 564:	8b 5d 10             	mov    0x10(%ebp),%ebx
 567:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56a:	ba 00 00 00 00       	mov    $0x0,%edx
 56f:	f7 f3                	div    %ebx
 571:	89 45 ec             	mov    %eax,-0x14(%ebp)
 574:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 578:	75 c7                	jne    541 <printint+0x38>
  if(neg)
 57a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 57e:	74 2d                	je     5ad <printint+0xa4>
    buf[i++] = '-';
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	8d 50 01             	lea    0x1(%eax),%edx
 586:	89 55 f4             	mov    %edx,-0xc(%ebp)
 589:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 58e:	eb 1d                	jmp    5ad <printint+0xa4>
    putc(fd, buf[i]);
 590:	8d 55 dc             	lea    -0x24(%ebp),%edx
 593:	8b 45 f4             	mov    -0xc(%ebp),%eax
 596:	01 d0                	add    %edx,%eax
 598:	0f b6 00             	movzbl (%eax),%eax
 59b:	0f be c0             	movsbl %al,%eax
 59e:	83 ec 08             	sub    $0x8,%esp
 5a1:	50                   	push   %eax
 5a2:	ff 75 08             	pushl  0x8(%ebp)
 5a5:	e8 3c ff ff ff       	call   4e6 <putc>
 5aa:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b5:	79 d9                	jns    590 <printint+0x87>
    putc(fd, buf[i]);
}
 5b7:	90                   	nop
 5b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5bb:	c9                   	leave  
 5bc:	c3                   	ret    

000005bd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5bd:	55                   	push   %ebp
 5be:	89 e5                	mov    %esp,%ebp
 5c0:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ca:	8d 45 0c             	lea    0xc(%ebp),%eax
 5cd:	83 c0 04             	add    $0x4,%eax
 5d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5da:	e9 59 01 00 00       	jmp    738 <printf+0x17b>
    c = fmt[i] & 0xff;
 5df:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e5:	01 d0                	add    %edx,%eax
 5e7:	0f b6 00             	movzbl (%eax),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	25 ff 00 00 00       	and    $0xff,%eax
 5f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f9:	75 2c                	jne    627 <printf+0x6a>
      if(c == '%'){
 5fb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ff:	75 0c                	jne    60d <printf+0x50>
        state = '%';
 601:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 608:	e9 27 01 00 00       	jmp    734 <printf+0x177>
      } else {
        putc(fd, c);
 60d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	83 ec 08             	sub    $0x8,%esp
 616:	50                   	push   %eax
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 c7 fe ff ff       	call   4e6 <putc>
 61f:	83 c4 10             	add    $0x10,%esp
 622:	e9 0d 01 00 00       	jmp    734 <printf+0x177>
      }
    } else if(state == '%'){
 627:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 62b:	0f 85 03 01 00 00    	jne    734 <printf+0x177>
      if(c == 'd'){
 631:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 635:	75 1e                	jne    655 <printf+0x98>
        printint(fd, *ap, 10, 1);
 637:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	6a 01                	push   $0x1
 63e:	6a 0a                	push   $0xa
 640:	50                   	push   %eax
 641:	ff 75 08             	pushl  0x8(%ebp)
 644:	e8 c0 fe ff ff       	call   509 <printint>
 649:	83 c4 10             	add    $0x10,%esp
        ap++;
 64c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 650:	e9 d8 00 00 00       	jmp    72d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 655:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 659:	74 06                	je     661 <printf+0xa4>
 65b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 65f:	75 1e                	jne    67f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 661:	8b 45 e8             	mov    -0x18(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	6a 00                	push   $0x0
 668:	6a 10                	push   $0x10
 66a:	50                   	push   %eax
 66b:	ff 75 08             	pushl  0x8(%ebp)
 66e:	e8 96 fe ff ff       	call   509 <printint>
 673:	83 c4 10             	add    $0x10,%esp
        ap++;
 676:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67a:	e9 ae 00 00 00       	jmp    72d <printf+0x170>
      } else if(c == 's'){
 67f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 683:	75 43                	jne    6c8 <printf+0x10b>
        s = (char*)*ap;
 685:	8b 45 e8             	mov    -0x18(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 68d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 695:	75 25                	jne    6bc <printf+0xff>
          s = "(null)";
 697:	c7 45 f4 c3 09 00 00 	movl   $0x9c3,-0xc(%ebp)
        while(*s != 0){
 69e:	eb 1c                	jmp    6bc <printf+0xff>
          putc(fd, *s);
 6a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a3:	0f b6 00             	movzbl (%eax),%eax
 6a6:	0f be c0             	movsbl %al,%eax
 6a9:	83 ec 08             	sub    $0x8,%esp
 6ac:	50                   	push   %eax
 6ad:	ff 75 08             	pushl  0x8(%ebp)
 6b0:	e8 31 fe ff ff       	call   4e6 <putc>
 6b5:	83 c4 10             	add    $0x10,%esp
          s++;
 6b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bf:	0f b6 00             	movzbl (%eax),%eax
 6c2:	84 c0                	test   %al,%al
 6c4:	75 da                	jne    6a0 <printf+0xe3>
 6c6:	eb 65                	jmp    72d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6cc:	75 1d                	jne    6eb <printf+0x12e>
        putc(fd, *ap);
 6ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	0f be c0             	movsbl %al,%eax
 6d6:	83 ec 08             	sub    $0x8,%esp
 6d9:	50                   	push   %eax
 6da:	ff 75 08             	pushl  0x8(%ebp)
 6dd:	e8 04 fe ff ff       	call   4e6 <putc>
 6e2:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e9:	eb 42                	jmp    72d <printf+0x170>
      } else if(c == '%'){
 6eb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ef:	75 17                	jne    708 <printf+0x14b>
        putc(fd, c);
 6f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f4:	0f be c0             	movsbl %al,%eax
 6f7:	83 ec 08             	sub    $0x8,%esp
 6fa:	50                   	push   %eax
 6fb:	ff 75 08             	pushl  0x8(%ebp)
 6fe:	e8 e3 fd ff ff       	call   4e6 <putc>
 703:	83 c4 10             	add    $0x10,%esp
 706:	eb 25                	jmp    72d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 708:	83 ec 08             	sub    $0x8,%esp
 70b:	6a 25                	push   $0x25
 70d:	ff 75 08             	pushl  0x8(%ebp)
 710:	e8 d1 fd ff ff       	call   4e6 <putc>
 715:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71b:	0f be c0             	movsbl %al,%eax
 71e:	83 ec 08             	sub    $0x8,%esp
 721:	50                   	push   %eax
 722:	ff 75 08             	pushl  0x8(%ebp)
 725:	e8 bc fd ff ff       	call   4e6 <putc>
 72a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 72d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 734:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 738:	8b 55 0c             	mov    0xc(%ebp),%edx
 73b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73e:	01 d0                	add    %edx,%eax
 740:	0f b6 00             	movzbl (%eax),%eax
 743:	84 c0                	test   %al,%al
 745:	0f 85 94 fe ff ff    	jne    5df <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 74b:	90                   	nop
 74c:	c9                   	leave  
 74d:	c3                   	ret    

0000074e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74e:	55                   	push   %ebp
 74f:	89 e5                	mov    %esp,%ebp
 751:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	83 e8 08             	sub    $0x8,%eax
 75a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75d:	a1 58 0c 00 00       	mov    0xc58,%eax
 762:	89 45 fc             	mov    %eax,-0x4(%ebp)
 765:	eb 24                	jmp    78b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76f:	77 12                	ja     783 <free+0x35>
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 777:	77 24                	ja     79d <free+0x4f>
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 781:	77 1a                	ja     79d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 791:	76 d4                	jbe    767 <free+0x19>
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79b:	76 ca                	jbe    767 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ad:	01 c2                	add    %eax,%edx
 7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b2:	8b 00                	mov    (%eax),%eax
 7b4:	39 c2                	cmp    %eax,%edx
 7b6:	75 24                	jne    7dc <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bb:	8b 50 04             	mov    0x4(%eax),%edx
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	8b 40 04             	mov    0x4(%eax),%eax
 7c6:	01 c2                	add    %eax,%edx
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	8b 00                	mov    (%eax),%eax
 7d3:	8b 10                	mov    (%eax),%edx
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	89 10                	mov    %edx,(%eax)
 7da:	eb 0a                	jmp    7e6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	8b 10                	mov    (%eax),%edx
 7e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	01 d0                	add    %edx,%eax
 7f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fb:	75 20                	jne    81d <free+0xcf>
    p->s.size += bp->s.size;
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 50 04             	mov    0x4(%eax),%edx
 803:	8b 45 f8             	mov    -0x8(%ebp),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	01 c2                	add    %eax,%edx
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
 81b:	eb 08                	jmp    825 <free+0xd7>
  } else
    p->s.ptr = bp;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 55 f8             	mov    -0x8(%ebp),%edx
 823:	89 10                	mov    %edx,(%eax)
  freep = p;
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	a3 58 0c 00 00       	mov    %eax,0xc58
}
 82d:	90                   	nop
 82e:	c9                   	leave  
 82f:	c3                   	ret    

00000830 <morecore>:

static Header*
morecore(uint nu)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 836:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83d:	77 07                	ja     846 <morecore+0x16>
    nu = 4096;
 83f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 846:	8b 45 08             	mov    0x8(%ebp),%eax
 849:	c1 e0 03             	shl    $0x3,%eax
 84c:	83 ec 0c             	sub    $0xc,%esp
 84f:	50                   	push   %eax
 850:	e8 19 fc ff ff       	call   46e <sbrk>
 855:	83 c4 10             	add    $0x10,%esp
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 85b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 85f:	75 07                	jne    868 <morecore+0x38>
    return 0;
 861:	b8 00 00 00 00       	mov    $0x0,%eax
 866:	eb 26                	jmp    88e <morecore+0x5e>
  hp = (Header*)p;
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	8b 55 08             	mov    0x8(%ebp),%edx
 874:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	83 c0 08             	add    $0x8,%eax
 87d:	83 ec 0c             	sub    $0xc,%esp
 880:	50                   	push   %eax
 881:	e8 c8 fe ff ff       	call   74e <free>
 886:	83 c4 10             	add    $0x10,%esp
  return freep;
 889:	a1 58 0c 00 00       	mov    0xc58,%eax
}
 88e:	c9                   	leave  
 88f:	c3                   	ret    

00000890 <malloc>:

void*
malloc(uint nbytes)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 896:	8b 45 08             	mov    0x8(%ebp),%eax
 899:	83 c0 07             	add    $0x7,%eax
 89c:	c1 e8 03             	shr    $0x3,%eax
 89f:	83 c0 01             	add    $0x1,%eax
 8a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a5:	a1 58 0c 00 00       	mov    0xc58,%eax
 8aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b1:	75 23                	jne    8d6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b3:	c7 45 f0 50 0c 00 00 	movl   $0xc50,-0x10(%ebp)
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	a3 58 0c 00 00       	mov    %eax,0xc58
 8c2:	a1 58 0c 00 00       	mov    0xc58,%eax
 8c7:	a3 50 0c 00 00       	mov    %eax,0xc50
    base.s.size = 0;
 8cc:	c7 05 54 0c 00 00 00 	movl   $0x0,0xc54
 8d3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e1:	8b 40 04             	mov    0x4(%eax),%eax
 8e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e7:	72 4d                	jb     936 <malloc+0xa6>
      if(p->s.size == nunits)
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	8b 40 04             	mov    0x4(%eax),%eax
 8ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f2:	75 0c                	jne    900 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	8b 10                	mov    (%eax),%edx
 8f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fc:	89 10                	mov    %edx,(%eax)
 8fe:	eb 26                	jmp    926 <malloc+0x96>
      else {
        p->s.size -= nunits;
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	8b 40 04             	mov    0x4(%eax),%eax
 906:	2b 45 ec             	sub    -0x14(%ebp),%eax
 909:	89 c2                	mov    %eax,%edx
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	8b 40 04             	mov    0x4(%eax),%eax
 917:	c1 e0 03             	shl    $0x3,%eax
 91a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	8b 55 ec             	mov    -0x14(%ebp),%edx
 923:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 926:	8b 45 f0             	mov    -0x10(%ebp),%eax
 929:	a3 58 0c 00 00       	mov    %eax,0xc58
      return (void*)(p + 1);
 92e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 931:	83 c0 08             	add    $0x8,%eax
 934:	eb 3b                	jmp    971 <malloc+0xe1>
    }
    if(p == freep)
 936:	a1 58 0c 00 00       	mov    0xc58,%eax
 93b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 93e:	75 1e                	jne    95e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 940:	83 ec 0c             	sub    $0xc,%esp
 943:	ff 75 ec             	pushl  -0x14(%ebp)
 946:	e8 e5 fe ff ff       	call   830 <morecore>
 94b:	83 c4 10             	add    $0x10,%esp
 94e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 955:	75 07                	jne    95e <malloc+0xce>
        return 0;
 957:	b8 00 00 00 00       	mov    $0x0,%eax
 95c:	eb 13                	jmp    971 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	89 45 f0             	mov    %eax,-0x10(%ebp)
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 96c:	e9 6d ff ff ff       	jmp    8de <malloc+0x4e>
}
 971:	c9                   	leave  
 972:	c3                   	ret    
