
_halt:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// halt the system.
#include "types.h"
#include "user.h"

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  halt();
  11:	e8 93 03 00 00       	call   3a9 <halt>
  return 0;
  16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1b:	83 c4 04             	add    $0x4,%esp
  1e:	59                   	pop    %ecx
  1f:	5d                   	pop    %ebp
  20:	8d 61 fc             	lea    -0x4(%ecx),%esp
  23:	c3                   	ret    

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	90                   	nop
  46:	5b                   	pop    %ebx
  47:	5f                   	pop    %edi
  48:	5d                   	pop    %ebp
  49:	c3                   	ret    

0000004a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4a:	55                   	push   %ebp
  4b:	89 e5                	mov    %esp,%ebp
  4d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  50:	8b 45 08             	mov    0x8(%ebp),%eax
  53:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  56:	90                   	nop
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	8d 50 01             	lea    0x1(%eax),%edx
  5d:	89 55 08             	mov    %edx,0x8(%ebp)
  60:	8b 55 0c             	mov    0xc(%ebp),%edx
  63:	8d 4a 01             	lea    0x1(%edx),%ecx
  66:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  69:	0f b6 12             	movzbl (%edx),%edx
  6c:	88 10                	mov    %dl,(%eax)
  6e:	0f b6 00             	movzbl (%eax),%eax
  71:	84 c0                	test   %al,%al
  73:	75 e2                	jne    57 <strcpy+0xd>
    ;
  return os;
  75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  78:	c9                   	leave  
  79:	c3                   	ret    

0000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7d:	eb 08                	jmp    87 <strcmp+0xd>
    p++, q++;
  7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  83:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  87:	8b 45 08             	mov    0x8(%ebp),%eax
  8a:	0f b6 00             	movzbl (%eax),%eax
  8d:	84 c0                	test   %al,%al
  8f:	74 10                	je     a1 <strcmp+0x27>
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	0f b6 10             	movzbl (%eax),%edx
  97:	8b 45 0c             	mov    0xc(%ebp),%eax
  9a:	0f b6 00             	movzbl (%eax),%eax
  9d:	38 c2                	cmp    %al,%dl
  9f:	74 de                	je     7f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	0f b6 00             	movzbl (%eax),%eax
  a7:	0f b6 d0             	movzbl %al,%edx
  aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  ad:	0f b6 00             	movzbl (%eax),%eax
  b0:	0f b6 c0             	movzbl %al,%eax
  b3:	29 c2                	sub    %eax,%edx
  b5:	89 d0                	mov    %edx,%eax
}
  b7:	5d                   	pop    %ebp
  b8:	c3                   	ret    

000000b9 <strlen>:

uint
strlen(char *s)
{
  b9:	55                   	push   %ebp
  ba:	89 e5                	mov    %esp,%ebp
  bc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c6:	eb 04                	jmp    cc <strlen+0x13>
  c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	01 d0                	add    %edx,%eax
  d4:	0f b6 00             	movzbl (%eax),%eax
  d7:	84 c0                	test   %al,%al
  d9:	75 ed                	jne    c8 <strlen+0xf>
    ;
  return n;
  db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  de:	c9                   	leave  
  df:	c3                   	ret    

000000e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e3:	8b 45 10             	mov    0x10(%ebp),%eax
  e6:	50                   	push   %eax
  e7:	ff 75 0c             	pushl  0xc(%ebp)
  ea:	ff 75 08             	pushl  0x8(%ebp)
  ed:	e8 32 ff ff ff       	call   24 <stosb>
  f2:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f8:	c9                   	leave  
  f9:	c3                   	ret    

000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 04             	sub    $0x4,%esp
 100:	8b 45 0c             	mov    0xc(%ebp),%eax
 103:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 106:	eb 14                	jmp    11c <strchr+0x22>
    if(*s == c)
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	0f b6 00             	movzbl (%eax),%eax
 10e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 111:	75 05                	jne    118 <strchr+0x1e>
      return (char*)s;
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	eb 13                	jmp    12b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 118:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	84 c0                	test   %al,%al
 124:	75 e2                	jne    108 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 126:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <gets>:

char*
gets(char *buf, int max)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 133:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13a:	eb 42                	jmp    17e <gets+0x51>
    cc = read(0, &c, 1);
 13c:	83 ec 04             	sub    $0x4,%esp
 13f:	6a 01                	push   $0x1
 141:	8d 45 ef             	lea    -0x11(%ebp),%eax
 144:	50                   	push   %eax
 145:	6a 00                	push   $0x0
 147:	e8 d5 01 00 00       	call   321 <read>
 14c:	83 c4 10             	add    $0x10,%esp
 14f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 152:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 156:	7e 33                	jle    18b <gets+0x5e>
      break;
    buf[i++] = c;
 158:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15b:	8d 50 01             	lea    0x1(%eax),%edx
 15e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 161:	89 c2                	mov    %eax,%edx
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	01 c2                	add    %eax,%edx
 168:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 16e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 172:	3c 0a                	cmp    $0xa,%al
 174:	74 16                	je     18c <gets+0x5f>
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0d                	cmp    $0xd,%al
 17c:	74 0e                	je     18c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 181:	83 c0 01             	add    $0x1,%eax
 184:	3b 45 0c             	cmp    0xc(%ebp),%eax
 187:	7c b3                	jl     13c <gets+0xf>
 189:	eb 01                	jmp    18c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 18b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 18c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	01 d0                	add    %edx,%eax
 194:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19a:	c9                   	leave  
 19b:	c3                   	ret    

0000019c <stat>:

int
stat(char *n, struct stat *st)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a2:	83 ec 08             	sub    $0x8,%esp
 1a5:	6a 00                	push   $0x0
 1a7:	ff 75 08             	pushl  0x8(%ebp)
 1aa:	e8 9a 01 00 00       	call   349 <open>
 1af:	83 c4 10             	add    $0x10,%esp
 1b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b9:	79 07                	jns    1c2 <stat+0x26>
    return -1;
 1bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c0:	eb 25                	jmp    1e7 <stat+0x4b>
  r = fstat(fd, st);
 1c2:	83 ec 08             	sub    $0x8,%esp
 1c5:	ff 75 0c             	pushl  0xc(%ebp)
 1c8:	ff 75 f4             	pushl  -0xc(%ebp)
 1cb:	e8 91 01 00 00       	call   361 <fstat>
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d6:	83 ec 0c             	sub    $0xc,%esp
 1d9:	ff 75 f4             	pushl  -0xc(%ebp)
 1dc:	e8 50 01 00 00       	call   331 <close>
 1e1:	83 c4 10             	add    $0x10,%esp
  return r;
 1e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <atoi>:

int
atoi(const char *s)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f6:	eb 25                	jmp    21d <atoi+0x34>
    n = n*10 + *s++ - '0';
 1f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fb:	89 d0                	mov    %edx,%eax
 1fd:	c1 e0 02             	shl    $0x2,%eax
 200:	01 d0                	add    %edx,%eax
 202:	01 c0                	add    %eax,%eax
 204:	89 c1                	mov    %eax,%ecx
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	8d 50 01             	lea    0x1(%eax),%edx
 20c:	89 55 08             	mov    %edx,0x8(%ebp)
 20f:	0f b6 00             	movzbl (%eax),%eax
 212:	0f be c0             	movsbl %al,%eax
 215:	01 c8                	add    %ecx,%eax
 217:	83 e8 30             	sub    $0x30,%eax
 21a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	0f b6 00             	movzbl (%eax),%eax
 223:	3c 2f                	cmp    $0x2f,%al
 225:	7e 0a                	jle    231 <atoi+0x48>
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 00             	movzbl (%eax),%eax
 22d:	3c 39                	cmp    $0x39,%al
 22f:	7e c7                	jle    1f8 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 231:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 242:	8b 45 0c             	mov    0xc(%ebp),%eax
 245:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 248:	eb 17                	jmp    261 <memmove+0x2b>
    *dst++ = *src++;
 24a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 24d:	8d 50 01             	lea    0x1(%eax),%edx
 250:	89 55 fc             	mov    %edx,-0x4(%ebp)
 253:	8b 55 f8             	mov    -0x8(%ebp),%edx
 256:	8d 4a 01             	lea    0x1(%edx),%ecx
 259:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 25c:	0f b6 12             	movzbl (%edx),%edx
 25f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 261:	8b 45 10             	mov    0x10(%ebp),%eax
 264:	8d 50 ff             	lea    -0x1(%eax),%edx
 267:	89 55 10             	mov    %edx,0x10(%ebp)
 26a:	85 c0                	test   %eax,%eax
 26c:	7f dc                	jg     24a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <atoo>:

int
atoo(const char *s)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 279:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 280:	eb 04                	jmp    286 <atoo+0x13>
 282:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	3c 20                	cmp    $0x20,%al
 28e:	74 f2                	je     282 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	3c 2d                	cmp    $0x2d,%al
 298:	75 07                	jne    2a1 <atoo+0x2e>
 29a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29f:	eb 05                	jmp    2a6 <atoo+0x33>
 2a1:	b8 01 00 00 00       	mov    $0x1,%eax
 2a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	3c 2b                	cmp    $0x2b,%al
 2b1:	74 0a                	je     2bd <atoo+0x4a>
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	3c 2d                	cmp    $0x2d,%al
 2bb:	75 27                	jne    2e4 <atoo+0x71>
    s++;
 2bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 2c1:	eb 21                	jmp    2e4 <atoo+0x71>
    n = n*8 + *s++ - '0';
 2c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	8d 50 01             	lea    0x1(%eax),%edx
 2d3:	89 55 08             	mov    %edx,0x8(%ebp)
 2d6:	0f b6 00             	movzbl (%eax),%eax
 2d9:	0f be c0             	movsbl %al,%eax
 2dc:	01 c8                	add    %ecx,%eax
 2de:	83 e8 30             	sub    $0x30,%eax
 2e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	0f b6 00             	movzbl (%eax),%eax
 2ea:	3c 2f                	cmp    $0x2f,%al
 2ec:	7e 0a                	jle    2f8 <atoo+0x85>
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	0f b6 00             	movzbl (%eax),%eax
 2f4:	3c 37                	cmp    $0x37,%al
 2f6:	7e cb                	jle    2c3 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 2f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2fb:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2ff:	c9                   	leave  
 300:	c3                   	ret    

00000301 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 301:	b8 01 00 00 00       	mov    $0x1,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <exit>:
SYSCALL(exit)
 309:	b8 02 00 00 00       	mov    $0x2,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <wait>:
SYSCALL(wait)
 311:	b8 03 00 00 00       	mov    $0x3,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <pipe>:
SYSCALL(pipe)
 319:	b8 04 00 00 00       	mov    $0x4,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <read>:
SYSCALL(read)
 321:	b8 05 00 00 00       	mov    $0x5,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <write>:
SYSCALL(write)
 329:	b8 10 00 00 00       	mov    $0x10,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <close>:
SYSCALL(close)
 331:	b8 15 00 00 00       	mov    $0x15,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <kill>:
SYSCALL(kill)
 339:	b8 06 00 00 00       	mov    $0x6,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <exec>:
SYSCALL(exec)
 341:	b8 07 00 00 00       	mov    $0x7,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <open>:
SYSCALL(open)
 349:	b8 0f 00 00 00       	mov    $0xf,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <mknod>:
SYSCALL(mknod)
 351:	b8 11 00 00 00       	mov    $0x11,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <unlink>:
SYSCALL(unlink)
 359:	b8 12 00 00 00       	mov    $0x12,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <fstat>:
SYSCALL(fstat)
 361:	b8 08 00 00 00       	mov    $0x8,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <link>:
SYSCALL(link)
 369:	b8 13 00 00 00       	mov    $0x13,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <mkdir>:
SYSCALL(mkdir)
 371:	b8 14 00 00 00       	mov    $0x14,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <chdir>:
SYSCALL(chdir)
 379:	b8 09 00 00 00       	mov    $0x9,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <dup>:
SYSCALL(dup)
 381:	b8 0a 00 00 00       	mov    $0xa,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <getpid>:
SYSCALL(getpid)
 389:	b8 0b 00 00 00       	mov    $0xb,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <sbrk>:
SYSCALL(sbrk)
 391:	b8 0c 00 00 00       	mov    $0xc,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <sleep>:
SYSCALL(sleep)
 399:	b8 0d 00 00 00       	mov    $0xd,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <uptime>:
SYSCALL(uptime)
 3a1:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <halt>:
SYSCALL(halt)
 3a9:	b8 16 00 00 00       	mov    $0x16,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 3b1:	b8 17 00 00 00       	mov    $0x17,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 3b9:	b8 18 00 00 00       	mov    $0x18,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 3c1:	b8 19 00 00 00       	mov    $0x19,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 3c9:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 3d1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 3d9:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 3e1:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 3e9:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 3f1:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 3f9:	b8 20 00 00 00       	mov    $0x20,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 401:	b8 21 00 00 00       	mov    $0x21,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	83 ec 18             	sub    $0x18,%esp
 40f:	8b 45 0c             	mov    0xc(%ebp),%eax
 412:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 415:	83 ec 04             	sub    $0x4,%esp
 418:	6a 01                	push   $0x1
 41a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 41d:	50                   	push   %eax
 41e:	ff 75 08             	pushl  0x8(%ebp)
 421:	e8 03 ff ff ff       	call   329 <write>
 426:	83 c4 10             	add    $0x10,%esp
}
 429:	90                   	nop
 42a:	c9                   	leave  
 42b:	c3                   	ret    

0000042c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	53                   	push   %ebx
 430:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 433:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 43e:	74 17                	je     457 <printint+0x2b>
 440:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 444:	79 11                	jns    457 <printint+0x2b>
    neg = 1;
 446:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 44d:	8b 45 0c             	mov    0xc(%ebp),%eax
 450:	f7 d8                	neg    %eax
 452:	89 45 ec             	mov    %eax,-0x14(%ebp)
 455:	eb 06                	jmp    45d <printint+0x31>
  } else {
    x = xx;
 457:	8b 45 0c             	mov    0xc(%ebp),%eax
 45a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 45d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 464:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 467:	8d 41 01             	lea    0x1(%ecx),%eax
 46a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 46d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 470:	8b 45 ec             	mov    -0x14(%ebp),%eax
 473:	ba 00 00 00 00       	mov    $0x0,%edx
 478:	f7 f3                	div    %ebx
 47a:	89 d0                	mov    %edx,%eax
 47c:	0f b6 80 10 0b 00 00 	movzbl 0xb10(%eax),%eax
 483:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 487:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48d:	ba 00 00 00 00       	mov    $0x0,%edx
 492:	f7 f3                	div    %ebx
 494:	89 45 ec             	mov    %eax,-0x14(%ebp)
 497:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49b:	75 c7                	jne    464 <printint+0x38>
  if(neg)
 49d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a1:	74 2d                	je     4d0 <printint+0xa4>
    buf[i++] = '-';
 4a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a6:	8d 50 01             	lea    0x1(%eax),%edx
 4a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ac:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b1:	eb 1d                	jmp    4d0 <printint+0xa4>
    putc(fd, buf[i]);
 4b3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b9:	01 d0                	add    %edx,%eax
 4bb:	0f b6 00             	movzbl (%eax),%eax
 4be:	0f be c0             	movsbl %al,%eax
 4c1:	83 ec 08             	sub    $0x8,%esp
 4c4:	50                   	push   %eax
 4c5:	ff 75 08             	pushl  0x8(%ebp)
 4c8:	e8 3c ff ff ff       	call   409 <putc>
 4cd:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4d0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d8:	79 d9                	jns    4b3 <printint+0x87>
    putc(fd, buf[i]);
}
 4da:	90                   	nop
 4db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4de:	c9                   	leave  
 4df:	c3                   	ret    

000004e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ed:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f0:	83 c0 04             	add    $0x4,%eax
 4f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4fd:	e9 59 01 00 00       	jmp    65b <printf+0x17b>
    c = fmt[i] & 0xff;
 502:	8b 55 0c             	mov    0xc(%ebp),%edx
 505:	8b 45 f0             	mov    -0x10(%ebp),%eax
 508:	01 d0                	add    %edx,%eax
 50a:	0f b6 00             	movzbl (%eax),%eax
 50d:	0f be c0             	movsbl %al,%eax
 510:	25 ff 00 00 00       	and    $0xff,%eax
 515:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 518:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51c:	75 2c                	jne    54a <printf+0x6a>
      if(c == '%'){
 51e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 522:	75 0c                	jne    530 <printf+0x50>
        state = '%';
 524:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 52b:	e9 27 01 00 00       	jmp    657 <printf+0x177>
      } else {
        putc(fd, c);
 530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 533:	0f be c0             	movsbl %al,%eax
 536:	83 ec 08             	sub    $0x8,%esp
 539:	50                   	push   %eax
 53a:	ff 75 08             	pushl  0x8(%ebp)
 53d:	e8 c7 fe ff ff       	call   409 <putc>
 542:	83 c4 10             	add    $0x10,%esp
 545:	e9 0d 01 00 00       	jmp    657 <printf+0x177>
      }
    } else if(state == '%'){
 54a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 54e:	0f 85 03 01 00 00    	jne    657 <printf+0x177>
      if(c == 'd'){
 554:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 558:	75 1e                	jne    578 <printf+0x98>
        printint(fd, *ap, 10, 1);
 55a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55d:	8b 00                	mov    (%eax),%eax
 55f:	6a 01                	push   $0x1
 561:	6a 0a                	push   $0xa
 563:	50                   	push   %eax
 564:	ff 75 08             	pushl  0x8(%ebp)
 567:	e8 c0 fe ff ff       	call   42c <printint>
 56c:	83 c4 10             	add    $0x10,%esp
        ap++;
 56f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 573:	e9 d8 00 00 00       	jmp    650 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 578:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 57c:	74 06                	je     584 <printf+0xa4>
 57e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 582:	75 1e                	jne    5a2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 584:	8b 45 e8             	mov    -0x18(%ebp),%eax
 587:	8b 00                	mov    (%eax),%eax
 589:	6a 00                	push   $0x0
 58b:	6a 10                	push   $0x10
 58d:	50                   	push   %eax
 58e:	ff 75 08             	pushl  0x8(%ebp)
 591:	e8 96 fe ff ff       	call   42c <printint>
 596:	83 c4 10             	add    $0x10,%esp
        ap++;
 599:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59d:	e9 ae 00 00 00       	jmp    650 <printf+0x170>
      } else if(c == 's'){
 5a2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a6:	75 43                	jne    5eb <printf+0x10b>
        s = (char*)*ap;
 5a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ab:	8b 00                	mov    (%eax),%eax
 5ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b8:	75 25                	jne    5df <printf+0xff>
          s = "(null)";
 5ba:	c7 45 f4 96 08 00 00 	movl   $0x896,-0xc(%ebp)
        while(*s != 0){
 5c1:	eb 1c                	jmp    5df <printf+0xff>
          putc(fd, *s);
 5c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c6:	0f b6 00             	movzbl (%eax),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	83 ec 08             	sub    $0x8,%esp
 5cf:	50                   	push   %eax
 5d0:	ff 75 08             	pushl  0x8(%ebp)
 5d3:	e8 31 fe ff ff       	call   409 <putc>
 5d8:	83 c4 10             	add    $0x10,%esp
          s++;
 5db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	84 c0                	test   %al,%al
 5e7:	75 da                	jne    5c3 <printf+0xe3>
 5e9:	eb 65                	jmp    650 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5eb:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ef:	75 1d                	jne    60e <printf+0x12e>
        putc(fd, *ap);
 5f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f4:	8b 00                	mov    (%eax),%eax
 5f6:	0f be c0             	movsbl %al,%eax
 5f9:	83 ec 08             	sub    $0x8,%esp
 5fc:	50                   	push   %eax
 5fd:	ff 75 08             	pushl  0x8(%ebp)
 600:	e8 04 fe ff ff       	call   409 <putc>
 605:	83 c4 10             	add    $0x10,%esp
        ap++;
 608:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60c:	eb 42                	jmp    650 <printf+0x170>
      } else if(c == '%'){
 60e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 612:	75 17                	jne    62b <printf+0x14b>
        putc(fd, c);
 614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 617:	0f be c0             	movsbl %al,%eax
 61a:	83 ec 08             	sub    $0x8,%esp
 61d:	50                   	push   %eax
 61e:	ff 75 08             	pushl  0x8(%ebp)
 621:	e8 e3 fd ff ff       	call   409 <putc>
 626:	83 c4 10             	add    $0x10,%esp
 629:	eb 25                	jmp    650 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62b:	83 ec 08             	sub    $0x8,%esp
 62e:	6a 25                	push   $0x25
 630:	ff 75 08             	pushl  0x8(%ebp)
 633:	e8 d1 fd ff ff       	call   409 <putc>
 638:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 63b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63e:	0f be c0             	movsbl %al,%eax
 641:	83 ec 08             	sub    $0x8,%esp
 644:	50                   	push   %eax
 645:	ff 75 08             	pushl  0x8(%ebp)
 648:	e8 bc fd ff ff       	call   409 <putc>
 64d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 650:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 657:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65b:	8b 55 0c             	mov    0xc(%ebp),%edx
 65e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 661:	01 d0                	add    %edx,%eax
 663:	0f b6 00             	movzbl (%eax),%eax
 666:	84 c0                	test   %al,%al
 668:	0f 85 94 fe ff ff    	jne    502 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 66e:	90                   	nop
 66f:	c9                   	leave  
 670:	c3                   	ret    

00000671 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 671:	55                   	push   %ebp
 672:	89 e5                	mov    %esp,%ebp
 674:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	83 e8 08             	sub    $0x8,%eax
 67d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 680:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 685:	89 45 fc             	mov    %eax,-0x4(%ebp)
 688:	eb 24                	jmp    6ae <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 692:	77 12                	ja     6a6 <free+0x35>
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69a:	77 24                	ja     6c0 <free+0x4f>
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a4:	77 1a                	ja     6c0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b4:	76 d4                	jbe    68a <free+0x19>
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 00                	mov    (%eax),%eax
 6bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6be:	76 ca                	jbe    68a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	8b 40 04             	mov    0x4(%eax),%eax
 6c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	01 c2                	add    %eax,%edx
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	8b 00                	mov    (%eax),%eax
 6d7:	39 c2                	cmp    %eax,%edx
 6d9:	75 24                	jne    6ff <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	8b 50 04             	mov    0x4(%eax),%edx
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	8b 40 04             	mov    0x4(%eax),%eax
 6e9:	01 c2                	add    %eax,%edx
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	8b 10                	mov    (%eax),%edx
 6f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fb:	89 10                	mov    %edx,(%eax)
 6fd:	eb 0a                	jmp    709 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 10                	mov    (%eax),%edx
 704:	8b 45 f8             	mov    -0x8(%ebp),%eax
 707:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 40 04             	mov    0x4(%eax),%eax
 70f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	01 d0                	add    %edx,%eax
 71b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71e:	75 20                	jne    740 <free+0xcf>
    p->s.size += bp->s.size;
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 50 04             	mov    0x4(%eax),%edx
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	8b 40 04             	mov    0x4(%eax),%eax
 72c:	01 c2                	add    %eax,%edx
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 734:	8b 45 f8             	mov    -0x8(%ebp),%eax
 737:	8b 10                	mov    (%eax),%edx
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	89 10                	mov    %edx,(%eax)
 73e:	eb 08                	jmp    748 <free+0xd7>
  } else
    p->s.ptr = bp;
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 55 f8             	mov    -0x8(%ebp),%edx
 746:	89 10                	mov    %edx,(%eax)
  freep = p;
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	a3 2c 0b 00 00       	mov    %eax,0xb2c
}
 750:	90                   	nop
 751:	c9                   	leave  
 752:	c3                   	ret    

00000753 <morecore>:

static Header*
morecore(uint nu)
{
 753:	55                   	push   %ebp
 754:	89 e5                	mov    %esp,%ebp
 756:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 759:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 760:	77 07                	ja     769 <morecore+0x16>
    nu = 4096;
 762:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 769:	8b 45 08             	mov    0x8(%ebp),%eax
 76c:	c1 e0 03             	shl    $0x3,%eax
 76f:	83 ec 0c             	sub    $0xc,%esp
 772:	50                   	push   %eax
 773:	e8 19 fc ff ff       	call   391 <sbrk>
 778:	83 c4 10             	add    $0x10,%esp
 77b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 77e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 782:	75 07                	jne    78b <morecore+0x38>
    return 0;
 784:	b8 00 00 00 00       	mov    $0x0,%eax
 789:	eb 26                	jmp    7b1 <morecore+0x5e>
  hp = (Header*)p;
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 791:	8b 45 f0             	mov    -0x10(%ebp),%eax
 794:	8b 55 08             	mov    0x8(%ebp),%edx
 797:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	83 c0 08             	add    $0x8,%eax
 7a0:	83 ec 0c             	sub    $0xc,%esp
 7a3:	50                   	push   %eax
 7a4:	e8 c8 fe ff ff       	call   671 <free>
 7a9:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ac:	a1 2c 0b 00 00       	mov    0xb2c,%eax
}
 7b1:	c9                   	leave  
 7b2:	c3                   	ret    

000007b3 <malloc>:

void*
malloc(uint nbytes)
{
 7b3:	55                   	push   %ebp
 7b4:	89 e5                	mov    %esp,%ebp
 7b6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
 7bc:	83 c0 07             	add    $0x7,%eax
 7bf:	c1 e8 03             	shr    $0x3,%eax
 7c2:	83 c0 01             	add    $0x1,%eax
 7c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c8:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 7cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d4:	75 23                	jne    7f9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d6:	c7 45 f0 24 0b 00 00 	movl   $0xb24,-0x10(%ebp)
 7dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e0:	a3 2c 0b 00 00       	mov    %eax,0xb2c
 7e5:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 7ea:	a3 24 0b 00 00       	mov    %eax,0xb24
    base.s.size = 0;
 7ef:	c7 05 28 0b 00 00 00 	movl   $0x0,0xb28
 7f6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 40 04             	mov    0x4(%eax),%eax
 807:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80a:	72 4d                	jb     859 <malloc+0xa6>
      if(p->s.size == nunits)
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 815:	75 0c                	jne    823 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 10                	mov    (%eax),%edx
 81c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81f:	89 10                	mov    %edx,(%eax)
 821:	eb 26                	jmp    849 <malloc+0x96>
      else {
        p->s.size -= nunits;
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 40 04             	mov    0x4(%eax),%eax
 829:	2b 45 ec             	sub    -0x14(%ebp),%eax
 82c:	89 c2                	mov    %eax,%edx
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	c1 e0 03             	shl    $0x3,%eax
 83d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 55 ec             	mov    -0x14(%ebp),%edx
 846:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 849:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84c:	a3 2c 0b 00 00       	mov    %eax,0xb2c
      return (void*)(p + 1);
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	83 c0 08             	add    $0x8,%eax
 857:	eb 3b                	jmp    894 <malloc+0xe1>
    }
    if(p == freep)
 859:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 85e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 861:	75 1e                	jne    881 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 863:	83 ec 0c             	sub    $0xc,%esp
 866:	ff 75 ec             	pushl  -0x14(%ebp)
 869:	e8 e5 fe ff ff       	call   753 <morecore>
 86e:	83 c4 10             	add    $0x10,%esp
 871:	89 45 f4             	mov    %eax,-0xc(%ebp)
 874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 878:	75 07                	jne    881 <malloc+0xce>
        return 0;
 87a:	b8 00 00 00 00       	mov    $0x0,%eax
 87f:	eb 13                	jmp    894 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	89 45 f0             	mov    %eax,-0x10(%ebp)
 887:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88a:	8b 00                	mov    (%eax),%eax
 88c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 88f:	e9 6d ff ff ff       	jmp    801 <malloc+0x4e>
}
 894:	c9                   	leave  
 895:	c3                   	ret    
