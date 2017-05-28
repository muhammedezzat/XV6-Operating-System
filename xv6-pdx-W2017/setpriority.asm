
_setpriority:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

// used for testing our setpriority() system call
// and verifying that our periodic adjustment is working correctly
int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int rc = 0;
  14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int pid = 0;
  1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int priority = 0;
  22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  if (argv[1] == 0 || argv[2] == 0)
  29:	8b 43 04             	mov    0x4(%ebx),%eax
  2c:	83 c0 04             	add    $0x4,%eax
  2f:	8b 00                	mov    (%eax),%eax
  31:	85 c0                	test   %eax,%eax
  33:	74 0c                	je     41 <main+0x41>
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 08             	add    $0x8,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	85 c0                	test   %eax,%eax
  3f:	75 12                	jne    53 <main+0x53>
    printf(1, "Invalid params. (pid priority)\n");
  41:	83 ec 08             	sub    $0x8,%esp
  44:	68 94 08 00 00       	push   $0x894
  49:	6a 01                	push   $0x1
  4b:	e8 8c 04 00 00       	call   4dc <printf>
  50:	83 c4 10             	add    $0x10,%esp

  pid = atoi(argv[1]);
  53:	8b 43 04             	mov    0x4(%ebx),%eax
  56:	83 c0 04             	add    $0x4,%eax
  59:	8b 00                	mov    (%eax),%eax
  5b:	83 ec 0c             	sub    $0xc,%esp
  5e:	50                   	push   %eax
  5f:	e8 27 02 00 00       	call   28b <atoi>
  64:	83 c4 10             	add    $0x10,%esp
  67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  priority = atoi(argv[2]);
  6a:	8b 43 04             	mov    0x4(%ebx),%eax
  6d:	83 c0 08             	add    $0x8,%eax
  70:	8b 00                	mov    (%eax),%eax
  72:	83 ec 0c             	sub    $0xc,%esp
  75:	50                   	push   %eax
  76:	e8 10 02 00 00       	call   28b <atoi>
  7b:	83 c4 10             	add    $0x10,%esp
  7e:	89 45 ec             	mov    %eax,-0x14(%ebp)

  rc = setpriority(pid, priority);
  81:	83 ec 08             	sub    $0x8,%esp
  84:	ff 75 ec             	pushl  -0x14(%ebp)
  87:	ff 75 f0             	pushl  -0x10(%ebp)
  8a:	e8 6e 03 00 00       	call   3fd <setpriority>
  8f:	83 c4 10             	add    $0x10,%esp
  92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (rc == 0)
  95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  99:	75 14                	jne    af <main+0xaf>
    printf(1, "Successfully set priority!\n");
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	68 b4 08 00 00       	push   $0x8b4
  a3:	6a 01                	push   $0x1
  a5:	e8 32 04 00 00       	call   4dc <printf>
  aa:	83 c4 10             	add    $0x10,%esp
  ad:	eb 12                	jmp    c1 <main+0xc1>
  else
    printf(1, "Failed to set priority!\n");
  af:	83 ec 08             	sub    $0x8,%esp
  b2:	68 d0 08 00 00       	push   $0x8d0
  b7:	6a 01                	push   $0x1
  b9:	e8 1e 04 00 00       	call   4dc <printf>
  be:	83 c4 10             	add    $0x10,%esp

  exit();
  c1:	e8 57 02 00 00       	call   31d <exit>

000000c6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c6:	55                   	push   %ebp
  c7:	89 e5                	mov    %esp,%ebp
  c9:	57                   	push   %edi
  ca:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ce:	8b 55 10             	mov    0x10(%ebp),%edx
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	89 cb                	mov    %ecx,%ebx
  d6:	89 df                	mov    %ebx,%edi
  d8:	89 d1                	mov    %edx,%ecx
  da:	fc                   	cld    
  db:	f3 aa                	rep stos %al,%es:(%edi)
  dd:	89 ca                	mov    %ecx,%edx
  df:	89 fb                	mov    %edi,%ebx
  e1:	89 5d 08             	mov    %ebx,0x8(%ebp)
  e4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e7:	90                   	nop
  e8:	5b                   	pop    %ebx
  e9:	5f                   	pop    %edi
  ea:	5d                   	pop    %ebp
  eb:	c3                   	ret    

000000ec <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f8:	90                   	nop
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
  fc:	8d 50 01             	lea    0x1(%eax),%edx
  ff:	89 55 08             	mov    %edx,0x8(%ebp)
 102:	8b 55 0c             	mov    0xc(%ebp),%edx
 105:	8d 4a 01             	lea    0x1(%edx),%ecx
 108:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 10b:	0f b6 12             	movzbl (%edx),%edx
 10e:	88 10                	mov    %dl,(%eax)
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	84 c0                	test   %al,%al
 115:	75 e2                	jne    f9 <strcpy+0xd>
    ;
  return os;
 117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11a:	c9                   	leave  
 11b:	c3                   	ret    

0000011c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 11f:	eb 08                	jmp    129 <strcmp+0xd>
    p++, q++;
 121:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 125:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 129:	8b 45 08             	mov    0x8(%ebp),%eax
 12c:	0f b6 00             	movzbl (%eax),%eax
 12f:	84 c0                	test   %al,%al
 131:	74 10                	je     143 <strcmp+0x27>
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	0f b6 10             	movzbl (%eax),%edx
 139:	8b 45 0c             	mov    0xc(%ebp),%eax
 13c:	0f b6 00             	movzbl (%eax),%eax
 13f:	38 c2                	cmp    %al,%dl
 141:	74 de                	je     121 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 00             	movzbl (%eax),%eax
 149:	0f b6 d0             	movzbl %al,%edx
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	0f b6 00             	movzbl (%eax),%eax
 152:	0f b6 c0             	movzbl %al,%eax
 155:	29 c2                	sub    %eax,%edx
 157:	89 d0                	mov    %edx,%eax
}
 159:	5d                   	pop    %ebp
 15a:	c3                   	ret    

0000015b <strlen>:

uint
strlen(char *s)
{
 15b:	55                   	push   %ebp
 15c:	89 e5                	mov    %esp,%ebp
 15e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 161:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 168:	eb 04                	jmp    16e <strlen+0x13>
 16a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 16e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	01 d0                	add    %edx,%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	84 c0                	test   %al,%al
 17b:	75 ed                	jne    16a <strlen+0xf>
    ;
  return n;
 17d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 180:	c9                   	leave  
 181:	c3                   	ret    

00000182 <memset>:

void*
memset(void *dst, int c, uint n)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 185:	8b 45 10             	mov    0x10(%ebp),%eax
 188:	50                   	push   %eax
 189:	ff 75 0c             	pushl  0xc(%ebp)
 18c:	ff 75 08             	pushl  0x8(%ebp)
 18f:	e8 32 ff ff ff       	call   c6 <stosb>
 194:	83 c4 0c             	add    $0xc,%esp
  return dst;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19a:	c9                   	leave  
 19b:	c3                   	ret    

0000019c <strchr>:

char*
strchr(const char *s, char c)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	83 ec 04             	sub    $0x4,%esp
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1a8:	eb 14                	jmp    1be <strchr+0x22>
    if(*s == c)
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	0f b6 00             	movzbl (%eax),%eax
 1b0:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1b3:	75 05                	jne    1ba <strchr+0x1e>
      return (char*)s;
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	eb 13                	jmp    1cd <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	0f b6 00             	movzbl (%eax),%eax
 1c4:	84 c0                	test   %al,%al
 1c6:	75 e2                	jne    1aa <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1cd:	c9                   	leave  
 1ce:	c3                   	ret    

000001cf <gets>:

char*
gets(char *buf, int max)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1dc:	eb 42                	jmp    220 <gets+0x51>
    cc = read(0, &c, 1);
 1de:	83 ec 04             	sub    $0x4,%esp
 1e1:	6a 01                	push   $0x1
 1e3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1e6:	50                   	push   %eax
 1e7:	6a 00                	push   $0x0
 1e9:	e8 47 01 00 00       	call   335 <read>
 1ee:	83 c4 10             	add    $0x10,%esp
 1f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1f8:	7e 33                	jle    22d <gets+0x5e>
      break;
    buf[i++] = c;
 1fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fd:	8d 50 01             	lea    0x1(%eax),%edx
 200:	89 55 f4             	mov    %edx,-0xc(%ebp)
 203:	89 c2                	mov    %eax,%edx
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	01 c2                	add    %eax,%edx
 20a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 210:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 214:	3c 0a                	cmp    $0xa,%al
 216:	74 16                	je     22e <gets+0x5f>
 218:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21c:	3c 0d                	cmp    $0xd,%al
 21e:	74 0e                	je     22e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 220:	8b 45 f4             	mov    -0xc(%ebp),%eax
 223:	83 c0 01             	add    $0x1,%eax
 226:	3b 45 0c             	cmp    0xc(%ebp),%eax
 229:	7c b3                	jl     1de <gets+0xf>
 22b:	eb 01                	jmp    22e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 22d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 22e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	01 d0                	add    %edx,%eax
 236:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 239:	8b 45 08             	mov    0x8(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <stat>:

int
stat(char *n, struct stat *st)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 244:	83 ec 08             	sub    $0x8,%esp
 247:	6a 00                	push   $0x0
 249:	ff 75 08             	pushl  0x8(%ebp)
 24c:	e8 0c 01 00 00       	call   35d <open>
 251:	83 c4 10             	add    $0x10,%esp
 254:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 257:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 25b:	79 07                	jns    264 <stat+0x26>
    return -1;
 25d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 262:	eb 25                	jmp    289 <stat+0x4b>
  r = fstat(fd, st);
 264:	83 ec 08             	sub    $0x8,%esp
 267:	ff 75 0c             	pushl  0xc(%ebp)
 26a:	ff 75 f4             	pushl  -0xc(%ebp)
 26d:	e8 03 01 00 00       	call   375 <fstat>
 272:	83 c4 10             	add    $0x10,%esp
 275:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 278:	83 ec 0c             	sub    $0xc,%esp
 27b:	ff 75 f4             	pushl  -0xc(%ebp)
 27e:	e8 c2 00 00 00       	call   345 <close>
 283:	83 c4 10             	add    $0x10,%esp
  return r;
 286:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 289:	c9                   	leave  
 28a:	c3                   	ret    

0000028b <atoi>:

int
atoi(const char *s)
{
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 291:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 298:	eb 25                	jmp    2bf <atoi+0x34>
    n = n*10 + *s++ - '0';
 29a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29d:	89 d0                	mov    %edx,%eax
 29f:	c1 e0 02             	shl    $0x2,%eax
 2a2:	01 d0                	add    %edx,%eax
 2a4:	01 c0                	add    %eax,%eax
 2a6:	89 c1                	mov    %eax,%ecx
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	8d 50 01             	lea    0x1(%eax),%edx
 2ae:	89 55 08             	mov    %edx,0x8(%ebp)
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	0f be c0             	movsbl %al,%eax
 2b7:	01 c8                	add    %ecx,%eax
 2b9:	83 e8 30             	sub    $0x30,%eax
 2bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	3c 2f                	cmp    $0x2f,%al
 2c7:	7e 0a                	jle    2d3 <atoi+0x48>
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	0f b6 00             	movzbl (%eax),%eax
 2cf:	3c 39                	cmp    $0x39,%al
 2d1:	7e c7                	jle    29a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d6:	c9                   	leave  
 2d7:	c3                   	ret    

000002d8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d8:	55                   	push   %ebp
 2d9:	89 e5                	mov    %esp,%ebp
 2db:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ea:	eb 17                	jmp    303 <memmove+0x2b>
    *dst++ = *src++;
 2ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ef:	8d 50 01             	lea    0x1(%eax),%edx
 2f2:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2f8:	8d 4a 01             	lea    0x1(%edx),%ecx
 2fb:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2fe:	0f b6 12             	movzbl (%edx),%edx
 301:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 303:	8b 45 10             	mov    0x10(%ebp),%eax
 306:	8d 50 ff             	lea    -0x1(%eax),%edx
 309:	89 55 10             	mov    %edx,0x10(%ebp)
 30c:	85 c0                	test   %eax,%eax
 30e:	7f dc                	jg     2ec <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 310:	8b 45 08             	mov    0x8(%ebp),%eax
}
 313:	c9                   	leave  
 314:	c3                   	ret    

00000315 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 315:	b8 01 00 00 00       	mov    $0x1,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <exit>:
SYSCALL(exit)
 31d:	b8 02 00 00 00       	mov    $0x2,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <wait>:
SYSCALL(wait)
 325:	b8 03 00 00 00       	mov    $0x3,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <pipe>:
SYSCALL(pipe)
 32d:	b8 04 00 00 00       	mov    $0x4,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <read>:
SYSCALL(read)
 335:	b8 05 00 00 00       	mov    $0x5,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <write>:
SYSCALL(write)
 33d:	b8 10 00 00 00       	mov    $0x10,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <close>:
SYSCALL(close)
 345:	b8 15 00 00 00       	mov    $0x15,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <kill>:
SYSCALL(kill)
 34d:	b8 06 00 00 00       	mov    $0x6,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <exec>:
SYSCALL(exec)
 355:	b8 07 00 00 00       	mov    $0x7,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <open>:
SYSCALL(open)
 35d:	b8 0f 00 00 00       	mov    $0xf,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <mknod>:
SYSCALL(mknod)
 365:	b8 11 00 00 00       	mov    $0x11,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <unlink>:
SYSCALL(unlink)
 36d:	b8 12 00 00 00       	mov    $0x12,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <fstat>:
SYSCALL(fstat)
 375:	b8 08 00 00 00       	mov    $0x8,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <link>:
SYSCALL(link)
 37d:	b8 13 00 00 00       	mov    $0x13,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <mkdir>:
SYSCALL(mkdir)
 385:	b8 14 00 00 00       	mov    $0x14,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <chdir>:
SYSCALL(chdir)
 38d:	b8 09 00 00 00       	mov    $0x9,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <dup>:
SYSCALL(dup)
 395:	b8 0a 00 00 00       	mov    $0xa,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <getpid>:
SYSCALL(getpid)
 39d:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <sbrk>:
SYSCALL(sbrk)
 3a5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <sleep>:
SYSCALL(sleep)
 3ad:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <uptime>:
SYSCALL(uptime)
 3b5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <halt>:
SYSCALL(halt)
 3bd:	b8 16 00 00 00       	mov    $0x16,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 3c5:	b8 17 00 00 00       	mov    $0x17,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 3cd:	b8 18 00 00 00       	mov    $0x18,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 3d5:	b8 19 00 00 00       	mov    $0x19,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 3dd:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 3e5:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 3ed:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 3f5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 3fd:	b8 1b 00 00 00       	mov    $0x1b,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
 408:	83 ec 18             	sub    $0x18,%esp
 40b:	8b 45 0c             	mov    0xc(%ebp),%eax
 40e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 411:	83 ec 04             	sub    $0x4,%esp
 414:	6a 01                	push   $0x1
 416:	8d 45 f4             	lea    -0xc(%ebp),%eax
 419:	50                   	push   %eax
 41a:	ff 75 08             	pushl  0x8(%ebp)
 41d:	e8 1b ff ff ff       	call   33d <write>
 422:	83 c4 10             	add    $0x10,%esp
}
 425:	90                   	nop
 426:	c9                   	leave  
 427:	c3                   	ret    

00000428 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 428:	55                   	push   %ebp
 429:	89 e5                	mov    %esp,%ebp
 42b:	53                   	push   %ebx
 42c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 42f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 436:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 43a:	74 17                	je     453 <printint+0x2b>
 43c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 440:	79 11                	jns    453 <printint+0x2b>
    neg = 1;
 442:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 449:	8b 45 0c             	mov    0xc(%ebp),%eax
 44c:	f7 d8                	neg    %eax
 44e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 451:	eb 06                	jmp    459 <printint+0x31>
  } else {
    x = xx;
 453:	8b 45 0c             	mov    0xc(%ebp),%eax
 456:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 459:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 460:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 463:	8d 41 01             	lea    0x1(%ecx),%eax
 466:	89 45 f4             	mov    %eax,-0xc(%ebp)
 469:	8b 5d 10             	mov    0x10(%ebp),%ebx
 46c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46f:	ba 00 00 00 00       	mov    $0x0,%edx
 474:	f7 f3                	div    %ebx
 476:	89 d0                	mov    %edx,%eax
 478:	0f b6 80 3c 0b 00 00 	movzbl 0xb3c(%eax),%eax
 47f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 483:	8b 5d 10             	mov    0x10(%ebp),%ebx
 486:	8b 45 ec             	mov    -0x14(%ebp),%eax
 489:	ba 00 00 00 00       	mov    $0x0,%edx
 48e:	f7 f3                	div    %ebx
 490:	89 45 ec             	mov    %eax,-0x14(%ebp)
 493:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 497:	75 c7                	jne    460 <printint+0x38>
  if(neg)
 499:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49d:	74 2d                	je     4cc <printint+0xa4>
    buf[i++] = '-';
 49f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a2:	8d 50 01             	lea    0x1(%eax),%edx
 4a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ad:	eb 1d                	jmp    4cc <printint+0xa4>
    putc(fd, buf[i]);
 4af:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b5:	01 d0                	add    %edx,%eax
 4b7:	0f b6 00             	movzbl (%eax),%eax
 4ba:	0f be c0             	movsbl %al,%eax
 4bd:	83 ec 08             	sub    $0x8,%esp
 4c0:	50                   	push   %eax
 4c1:	ff 75 08             	pushl  0x8(%ebp)
 4c4:	e8 3c ff ff ff       	call   405 <putc>
 4c9:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4cc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d4:	79 d9                	jns    4af <printint+0x87>
    putc(fd, buf[i]);
}
 4d6:	90                   	nop
 4d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4da:	c9                   	leave  
 4db:	c3                   	ret    

000004dc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4dc:	55                   	push   %ebp
 4dd:	89 e5                	mov    %esp,%ebp
 4df:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e9:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ec:	83 c0 04             	add    $0x4,%eax
 4ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f9:	e9 59 01 00 00       	jmp    657 <printf+0x17b>
    c = fmt[i] & 0xff;
 4fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 501:	8b 45 f0             	mov    -0x10(%ebp),%eax
 504:	01 d0                	add    %edx,%eax
 506:	0f b6 00             	movzbl (%eax),%eax
 509:	0f be c0             	movsbl %al,%eax
 50c:	25 ff 00 00 00       	and    $0xff,%eax
 511:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 518:	75 2c                	jne    546 <printf+0x6a>
      if(c == '%'){
 51a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 51e:	75 0c                	jne    52c <printf+0x50>
        state = '%';
 520:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 527:	e9 27 01 00 00       	jmp    653 <printf+0x177>
      } else {
        putc(fd, c);
 52c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52f:	0f be c0             	movsbl %al,%eax
 532:	83 ec 08             	sub    $0x8,%esp
 535:	50                   	push   %eax
 536:	ff 75 08             	pushl  0x8(%ebp)
 539:	e8 c7 fe ff ff       	call   405 <putc>
 53e:	83 c4 10             	add    $0x10,%esp
 541:	e9 0d 01 00 00       	jmp    653 <printf+0x177>
      }
    } else if(state == '%'){
 546:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 54a:	0f 85 03 01 00 00    	jne    653 <printf+0x177>
      if(c == 'd'){
 550:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 554:	75 1e                	jne    574 <printf+0x98>
        printint(fd, *ap, 10, 1);
 556:	8b 45 e8             	mov    -0x18(%ebp),%eax
 559:	8b 00                	mov    (%eax),%eax
 55b:	6a 01                	push   $0x1
 55d:	6a 0a                	push   $0xa
 55f:	50                   	push   %eax
 560:	ff 75 08             	pushl  0x8(%ebp)
 563:	e8 c0 fe ff ff       	call   428 <printint>
 568:	83 c4 10             	add    $0x10,%esp
        ap++;
 56b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56f:	e9 d8 00 00 00       	jmp    64c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 574:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 578:	74 06                	je     580 <printf+0xa4>
 57a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 57e:	75 1e                	jne    59e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 580:	8b 45 e8             	mov    -0x18(%ebp),%eax
 583:	8b 00                	mov    (%eax),%eax
 585:	6a 00                	push   $0x0
 587:	6a 10                	push   $0x10
 589:	50                   	push   %eax
 58a:	ff 75 08             	pushl  0x8(%ebp)
 58d:	e8 96 fe ff ff       	call   428 <printint>
 592:	83 c4 10             	add    $0x10,%esp
        ap++;
 595:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 599:	e9 ae 00 00 00       	jmp    64c <printf+0x170>
      } else if(c == 's'){
 59e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a2:	75 43                	jne    5e7 <printf+0x10b>
        s = (char*)*ap;
 5a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a7:	8b 00                	mov    (%eax),%eax
 5a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ac:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b4:	75 25                	jne    5db <printf+0xff>
          s = "(null)";
 5b6:	c7 45 f4 e9 08 00 00 	movl   $0x8e9,-0xc(%ebp)
        while(*s != 0){
 5bd:	eb 1c                	jmp    5db <printf+0xff>
          putc(fd, *s);
 5bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c2:	0f b6 00             	movzbl (%eax),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	83 ec 08             	sub    $0x8,%esp
 5cb:	50                   	push   %eax
 5cc:	ff 75 08             	pushl  0x8(%ebp)
 5cf:	e8 31 fe ff ff       	call   405 <putc>
 5d4:	83 c4 10             	add    $0x10,%esp
          s++;
 5d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5de:	0f b6 00             	movzbl (%eax),%eax
 5e1:	84 c0                	test   %al,%al
 5e3:	75 da                	jne    5bf <printf+0xe3>
 5e5:	eb 65                	jmp    64c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5eb:	75 1d                	jne    60a <printf+0x12e>
        putc(fd, *ap);
 5ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	0f be c0             	movsbl %al,%eax
 5f5:	83 ec 08             	sub    $0x8,%esp
 5f8:	50                   	push   %eax
 5f9:	ff 75 08             	pushl  0x8(%ebp)
 5fc:	e8 04 fe ff ff       	call   405 <putc>
 601:	83 c4 10             	add    $0x10,%esp
        ap++;
 604:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 608:	eb 42                	jmp    64c <printf+0x170>
      } else if(c == '%'){
 60a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60e:	75 17                	jne    627 <printf+0x14b>
        putc(fd, c);
 610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 613:	0f be c0             	movsbl %al,%eax
 616:	83 ec 08             	sub    $0x8,%esp
 619:	50                   	push   %eax
 61a:	ff 75 08             	pushl  0x8(%ebp)
 61d:	e8 e3 fd ff ff       	call   405 <putc>
 622:	83 c4 10             	add    $0x10,%esp
 625:	eb 25                	jmp    64c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 627:	83 ec 08             	sub    $0x8,%esp
 62a:	6a 25                	push   $0x25
 62c:	ff 75 08             	pushl  0x8(%ebp)
 62f:	e8 d1 fd ff ff       	call   405 <putc>
 634:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63a:	0f be c0             	movsbl %al,%eax
 63d:	83 ec 08             	sub    $0x8,%esp
 640:	50                   	push   %eax
 641:	ff 75 08             	pushl  0x8(%ebp)
 644:	e8 bc fd ff ff       	call   405 <putc>
 649:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 64c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 653:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 657:	8b 55 0c             	mov    0xc(%ebp),%edx
 65a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65d:	01 d0                	add    %edx,%eax
 65f:	0f b6 00             	movzbl (%eax),%eax
 662:	84 c0                	test   %al,%al
 664:	0f 85 94 fe ff ff    	jne    4fe <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 66a:	90                   	nop
 66b:	c9                   	leave  
 66c:	c3                   	ret    

0000066d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66d:	55                   	push   %ebp
 66e:	89 e5                	mov    %esp,%ebp
 670:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 673:	8b 45 08             	mov    0x8(%ebp),%eax
 676:	83 e8 08             	sub    $0x8,%eax
 679:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67c:	a1 58 0b 00 00       	mov    0xb58,%eax
 681:	89 45 fc             	mov    %eax,-0x4(%ebp)
 684:	eb 24                	jmp    6aa <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68e:	77 12                	ja     6a2 <free+0x35>
 690:	8b 45 f8             	mov    -0x8(%ebp),%eax
 693:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 696:	77 24                	ja     6bc <free+0x4f>
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a0:	77 1a                	ja     6bc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 00                	mov    (%eax),%eax
 6a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b0:	76 d4                	jbe    686 <free+0x19>
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ba:	76 ca                	jbe    686 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bf:	8b 40 04             	mov    0x4(%eax),%eax
 6c2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	01 c2                	add    %eax,%edx
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	39 c2                	cmp    %eax,%edx
 6d5:	75 24                	jne    6fb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	8b 50 04             	mov    0x4(%eax),%edx
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	8b 40 04             	mov    0x4(%eax),%eax
 6e5:	01 c2                	add    %eax,%edx
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	8b 10                	mov    (%eax),%edx
 6f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f7:	89 10                	mov    %edx,(%eax)
 6f9:	eb 0a                	jmp    705 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 10                	mov    (%eax),%edx
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 40 04             	mov    0x4(%eax),%eax
 70b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	01 d0                	add    %edx,%eax
 717:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71a:	75 20                	jne    73c <free+0xcf>
    p->s.size += bp->s.size;
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 50 04             	mov    0x4(%eax),%edx
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	8b 40 04             	mov    0x4(%eax),%eax
 728:	01 c2                	add    %eax,%edx
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 730:	8b 45 f8             	mov    -0x8(%ebp),%eax
 733:	8b 10                	mov    (%eax),%edx
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	89 10                	mov    %edx,(%eax)
 73a:	eb 08                	jmp    744 <free+0xd7>
  } else
    p->s.ptr = bp;
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 742:	89 10                	mov    %edx,(%eax)
  freep = p;
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	a3 58 0b 00 00       	mov    %eax,0xb58
}
 74c:	90                   	nop
 74d:	c9                   	leave  
 74e:	c3                   	ret    

0000074f <morecore>:

static Header*
morecore(uint nu)
{
 74f:	55                   	push   %ebp
 750:	89 e5                	mov    %esp,%ebp
 752:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 755:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 75c:	77 07                	ja     765 <morecore+0x16>
    nu = 4096;
 75e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 765:	8b 45 08             	mov    0x8(%ebp),%eax
 768:	c1 e0 03             	shl    $0x3,%eax
 76b:	83 ec 0c             	sub    $0xc,%esp
 76e:	50                   	push   %eax
 76f:	e8 31 fc ff ff       	call   3a5 <sbrk>
 774:	83 c4 10             	add    $0x10,%esp
 777:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 77a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 77e:	75 07                	jne    787 <morecore+0x38>
    return 0;
 780:	b8 00 00 00 00       	mov    $0x0,%eax
 785:	eb 26                	jmp    7ad <morecore+0x5e>
  hp = (Header*)p;
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 78d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 790:	8b 55 08             	mov    0x8(%ebp),%edx
 793:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
 799:	83 c0 08             	add    $0x8,%eax
 79c:	83 ec 0c             	sub    $0xc,%esp
 79f:	50                   	push   %eax
 7a0:	e8 c8 fe ff ff       	call   66d <free>
 7a5:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a8:	a1 58 0b 00 00       	mov    0xb58,%eax
}
 7ad:	c9                   	leave  
 7ae:	c3                   	ret    

000007af <malloc>:

void*
malloc(uint nbytes)
{
 7af:	55                   	push   %ebp
 7b0:	89 e5                	mov    %esp,%ebp
 7b2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b5:	8b 45 08             	mov    0x8(%ebp),%eax
 7b8:	83 c0 07             	add    $0x7,%eax
 7bb:	c1 e8 03             	shr    $0x3,%eax
 7be:	83 c0 01             	add    $0x1,%eax
 7c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c4:	a1 58 0b 00 00       	mov    0xb58,%eax
 7c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d0:	75 23                	jne    7f5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d2:	c7 45 f0 50 0b 00 00 	movl   $0xb50,-0x10(%ebp)
 7d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dc:	a3 58 0b 00 00       	mov    %eax,0xb58
 7e1:	a1 58 0b 00 00       	mov    0xb58,%eax
 7e6:	a3 50 0b 00 00       	mov    %eax,0xb50
    base.s.size = 0;
 7eb:	c7 05 54 0b 00 00 00 	movl   $0x0,0xb54
 7f2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f8:	8b 00                	mov    (%eax),%eax
 7fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 40 04             	mov    0x4(%eax),%eax
 803:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 806:	72 4d                	jb     855 <malloc+0xa6>
      if(p->s.size == nunits)
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	8b 40 04             	mov    0x4(%eax),%eax
 80e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 811:	75 0c                	jne    81f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	8b 10                	mov    (%eax),%edx
 818:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81b:	89 10                	mov    %edx,(%eax)
 81d:	eb 26                	jmp    845 <malloc+0x96>
      else {
        p->s.size -= nunits;
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	8b 40 04             	mov    0x4(%eax),%eax
 825:	2b 45 ec             	sub    -0x14(%ebp),%eax
 828:	89 c2                	mov    %eax,%edx
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8b 40 04             	mov    0x4(%eax),%eax
 836:	c1 e0 03             	shl    $0x3,%eax
 839:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 842:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 845:	8b 45 f0             	mov    -0x10(%ebp),%eax
 848:	a3 58 0b 00 00       	mov    %eax,0xb58
      return (void*)(p + 1);
 84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 850:	83 c0 08             	add    $0x8,%eax
 853:	eb 3b                	jmp    890 <malloc+0xe1>
    }
    if(p == freep)
 855:	a1 58 0b 00 00       	mov    0xb58,%eax
 85a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 85d:	75 1e                	jne    87d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 85f:	83 ec 0c             	sub    $0xc,%esp
 862:	ff 75 ec             	pushl  -0x14(%ebp)
 865:	e8 e5 fe ff ff       	call   74f <morecore>
 86a:	83 c4 10             	add    $0x10,%esp
 86d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 874:	75 07                	jne    87d <malloc+0xce>
        return 0;
 876:	b8 00 00 00 00       	mov    $0x0,%eax
 87b:	eb 13                	jmp    890 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	89 45 f0             	mov    %eax,-0x10(%ebp)
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	8b 00                	mov    (%eax),%eax
 888:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 88b:	e9 6d ff ff ff       	jmp    7fd <malloc+0x4e>
}
 890:	c9                   	leave  
 891:	c3                   	ret    
