
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
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
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 f3 02 00 00       	call   309 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 7d 03 00 00       	call   3a1 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 e5 02 00 00       	call   311 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8d 50 01             	lea    0x1(%eax),%edx
  65:	89 55 08             	mov    %edx,0x8(%ebp)
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	pushl  0xc(%ebp)
  f2:	ff 75 08             	pushl  0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 d5 01 00 00       	call   329 <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18f:	7c b3                	jl     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 193:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	pushl  0x8(%ebp)
 1b2:	e8 9a 01 00 00       	call   351 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	pushl  0xc(%ebp)
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 91 01 00 00       	call   369 <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	pushl  -0xc(%ebp)
 1e4:	e8 50 01 00 00       	call   339 <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fe:	eb 25                	jmp    225 <atoi+0x34>
    n = n*10 + *s++ - '0';
 200:	8b 55 fc             	mov    -0x4(%ebp),%edx
 203:	89 d0                	mov    %edx,%eax
 205:	c1 e0 02             	shl    $0x2,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	01 c0                	add    %eax,%eax
 20c:	89 c1                	mov    %eax,%ecx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8d 50 01             	lea    0x1(%eax),%edx
 214:	89 55 08             	mov    %edx,0x8(%ebp)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	0f be c0             	movsbl %al,%eax
 21d:	01 c8                	add    %ecx,%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 0a                	jle    239 <atoi+0x48>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 39                	cmp    $0x39,%al
 237:	7e c7                	jle    200 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 250:	eb 17                	jmp    269 <memmove+0x2b>
    *dst++ = *src++;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
 255:	8d 50 01             	lea    0x1(%eax),%edx
 258:	89 55 fc             	mov    %edx,-0x4(%ebp)
 25b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25e:	8d 4a 01             	lea    0x1(%edx),%ecx
 261:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 264:	0f b6 12             	movzbl (%edx),%edx
 267:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 269:	8b 45 10             	mov    0x10(%ebp),%eax
 26c:	8d 50 ff             	lea    -0x1(%eax),%edx
 26f:	89 55 10             	mov    %edx,0x10(%ebp)
 272:	85 c0                	test   %eax,%eax
 274:	7f dc                	jg     252 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <atoo>:

int
atoo(const char *s)
{
 27b:	55                   	push   %ebp
 27c:	89 e5                	mov    %esp,%ebp
 27e:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 281:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 288:	eb 04                	jmp    28e <atoo+0x13>
 28a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	3c 20                	cmp    $0x20,%al
 296:	74 f2                	je     28a <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	0f b6 00             	movzbl (%eax),%eax
 29e:	3c 2d                	cmp    $0x2d,%al
 2a0:	75 07                	jne    2a9 <atoo+0x2e>
 2a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a7:	eb 05                	jmp    2ae <atoo+0x33>
 2a9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	3c 2b                	cmp    $0x2b,%al
 2b9:	74 0a                	je     2c5 <atoo+0x4a>
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	3c 2d                	cmp    $0x2d,%al
 2c3:	75 27                	jne    2ec <atoo+0x71>
    s++;
 2c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 2c9:	eb 21                	jmp    2ec <atoo+0x71>
    n = n*8 + *s++ - '0';
 2cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ce:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	8d 50 01             	lea    0x1(%eax),%edx
 2db:	89 55 08             	mov    %edx,0x8(%ebp)
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	0f be c0             	movsbl %al,%eax
 2e4:	01 c8                	add    %ecx,%eax
 2e6:	83 e8 30             	sub    $0x30,%eax
 2e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	0f b6 00             	movzbl (%eax),%eax
 2f2:	3c 2f                	cmp    $0x2f,%al
 2f4:	7e 0a                	jle    300 <atoo+0x85>
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	3c 37                	cmp    $0x37,%al
 2fe:	7e cb                	jle    2cb <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 300:	8b 45 f8             	mov    -0x8(%ebp),%eax
 303:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 307:	c9                   	leave  
 308:	c3                   	ret    

00000309 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 309:	b8 01 00 00 00       	mov    $0x1,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <exit>:
SYSCALL(exit)
 311:	b8 02 00 00 00       	mov    $0x2,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <wait>:
SYSCALL(wait)
 319:	b8 03 00 00 00       	mov    $0x3,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <pipe>:
SYSCALL(pipe)
 321:	b8 04 00 00 00       	mov    $0x4,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <read>:
SYSCALL(read)
 329:	b8 05 00 00 00       	mov    $0x5,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <write>:
SYSCALL(write)
 331:	b8 10 00 00 00       	mov    $0x10,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <close>:
SYSCALL(close)
 339:	b8 15 00 00 00       	mov    $0x15,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <kill>:
SYSCALL(kill)
 341:	b8 06 00 00 00       	mov    $0x6,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <exec>:
SYSCALL(exec)
 349:	b8 07 00 00 00       	mov    $0x7,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <open>:
SYSCALL(open)
 351:	b8 0f 00 00 00       	mov    $0xf,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <mknod>:
SYSCALL(mknod)
 359:	b8 11 00 00 00       	mov    $0x11,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <unlink>:
SYSCALL(unlink)
 361:	b8 12 00 00 00       	mov    $0x12,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <fstat>:
SYSCALL(fstat)
 369:	b8 08 00 00 00       	mov    $0x8,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <link>:
SYSCALL(link)
 371:	b8 13 00 00 00       	mov    $0x13,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <mkdir>:
SYSCALL(mkdir)
 379:	b8 14 00 00 00       	mov    $0x14,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <chdir>:
SYSCALL(chdir)
 381:	b8 09 00 00 00       	mov    $0x9,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <dup>:
SYSCALL(dup)
 389:	b8 0a 00 00 00       	mov    $0xa,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <getpid>:
SYSCALL(getpid)
 391:	b8 0b 00 00 00       	mov    $0xb,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <sbrk>:
SYSCALL(sbrk)
 399:	b8 0c 00 00 00       	mov    $0xc,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <sleep>:
SYSCALL(sleep)
 3a1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <uptime>:
SYSCALL(uptime)
 3a9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <halt>:
SYSCALL(halt)
 3b1:	b8 16 00 00 00       	mov    $0x16,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 3b9:	b8 17 00 00 00       	mov    $0x17,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 3c1:	b8 18 00 00 00       	mov    $0x18,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 3c9:	b8 19 00 00 00       	mov    $0x19,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 3d1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 3d9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 3e1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 3e9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 3f1:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 3f9:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 401:	b8 20 00 00 00       	mov    $0x20,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 409:	b8 21 00 00 00       	mov    $0x21,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 411:	55                   	push   %ebp
 412:	89 e5                	mov    %esp,%ebp
 414:	83 ec 18             	sub    $0x18,%esp
 417:	8b 45 0c             	mov    0xc(%ebp),%eax
 41a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 41d:	83 ec 04             	sub    $0x4,%esp
 420:	6a 01                	push   $0x1
 422:	8d 45 f4             	lea    -0xc(%ebp),%eax
 425:	50                   	push   %eax
 426:	ff 75 08             	pushl  0x8(%ebp)
 429:	e8 03 ff ff ff       	call   331 <write>
 42e:	83 c4 10             	add    $0x10,%esp
}
 431:	90                   	nop
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	53                   	push   %ebx
 438:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 43b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 442:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 446:	74 17                	je     45f <printint+0x2b>
 448:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 44c:	79 11                	jns    45f <printint+0x2b>
    neg = 1;
 44e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 455:	8b 45 0c             	mov    0xc(%ebp),%eax
 458:	f7 d8                	neg    %eax
 45a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45d:	eb 06                	jmp    465 <printint+0x31>
  } else {
    x = xx;
 45f:	8b 45 0c             	mov    0xc(%ebp),%eax
 462:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 465:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 46c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 46f:	8d 41 01             	lea    0x1(%ecx),%eax
 472:	89 45 f4             	mov    %eax,-0xc(%ebp)
 475:	8b 5d 10             	mov    0x10(%ebp),%ebx
 478:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47b:	ba 00 00 00 00       	mov    $0x0,%edx
 480:	f7 f3                	div    %ebx
 482:	89 d0                	mov    %edx,%eax
 484:	0f b6 80 10 0b 00 00 	movzbl 0xb10(%eax),%eax
 48b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 48f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 492:	8b 45 ec             	mov    -0x14(%ebp),%eax
 495:	ba 00 00 00 00       	mov    $0x0,%edx
 49a:	f7 f3                	div    %ebx
 49c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a3:	75 c7                	jne    46c <printint+0x38>
  if(neg)
 4a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a9:	74 2d                	je     4d8 <printint+0xa4>
    buf[i++] = '-';
 4ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ae:	8d 50 01             	lea    0x1(%eax),%edx
 4b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b9:	eb 1d                	jmp    4d8 <printint+0xa4>
    putc(fd, buf[i]);
 4bb:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c1:	01 d0                	add    %edx,%eax
 4c3:	0f b6 00             	movzbl (%eax),%eax
 4c6:	0f be c0             	movsbl %al,%eax
 4c9:	83 ec 08             	sub    $0x8,%esp
 4cc:	50                   	push   %eax
 4cd:	ff 75 08             	pushl  0x8(%ebp)
 4d0:	e8 3c ff ff ff       	call   411 <putc>
 4d5:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4d8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e0:	79 d9                	jns    4bb <printint+0x87>
    putc(fd, buf[i]);
}
 4e2:	90                   	nop
 4e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4e6:	c9                   	leave  
 4e7:	c3                   	ret    

000004e8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e8:	55                   	push   %ebp
 4e9:	89 e5                	mov    %esp,%ebp
 4eb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f5:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f8:	83 c0 04             	add    $0x4,%eax
 4fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 505:	e9 59 01 00 00       	jmp    663 <printf+0x17b>
    c = fmt[i] & 0xff;
 50a:	8b 55 0c             	mov    0xc(%ebp),%edx
 50d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 510:	01 d0                	add    %edx,%eax
 512:	0f b6 00             	movzbl (%eax),%eax
 515:	0f be c0             	movsbl %al,%eax
 518:	25 ff 00 00 00       	and    $0xff,%eax
 51d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 520:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 524:	75 2c                	jne    552 <printf+0x6a>
      if(c == '%'){
 526:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 52a:	75 0c                	jne    538 <printf+0x50>
        state = '%';
 52c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 533:	e9 27 01 00 00       	jmp    65f <printf+0x177>
      } else {
        putc(fd, c);
 538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53b:	0f be c0             	movsbl %al,%eax
 53e:	83 ec 08             	sub    $0x8,%esp
 541:	50                   	push   %eax
 542:	ff 75 08             	pushl  0x8(%ebp)
 545:	e8 c7 fe ff ff       	call   411 <putc>
 54a:	83 c4 10             	add    $0x10,%esp
 54d:	e9 0d 01 00 00       	jmp    65f <printf+0x177>
      }
    } else if(state == '%'){
 552:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 556:	0f 85 03 01 00 00    	jne    65f <printf+0x177>
      if(c == 'd'){
 55c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 560:	75 1e                	jne    580 <printf+0x98>
        printint(fd, *ap, 10, 1);
 562:	8b 45 e8             	mov    -0x18(%ebp),%eax
 565:	8b 00                	mov    (%eax),%eax
 567:	6a 01                	push   $0x1
 569:	6a 0a                	push   $0xa
 56b:	50                   	push   %eax
 56c:	ff 75 08             	pushl  0x8(%ebp)
 56f:	e8 c0 fe ff ff       	call   434 <printint>
 574:	83 c4 10             	add    $0x10,%esp
        ap++;
 577:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57b:	e9 d8 00 00 00       	jmp    658 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 580:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 584:	74 06                	je     58c <printf+0xa4>
 586:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 58a:	75 1e                	jne    5aa <printf+0xc2>
        printint(fd, *ap, 16, 0);
 58c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58f:	8b 00                	mov    (%eax),%eax
 591:	6a 00                	push   $0x0
 593:	6a 10                	push   $0x10
 595:	50                   	push   %eax
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 96 fe ff ff       	call   434 <printint>
 59e:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a5:	e9 ae 00 00 00       	jmp    658 <printf+0x170>
      } else if(c == 's'){
 5aa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ae:	75 43                	jne    5f3 <printf+0x10b>
        s = (char*)*ap;
 5b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b3:	8b 00                	mov    (%eax),%eax
 5b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c0:	75 25                	jne    5e7 <printf+0xff>
          s = "(null)";
 5c2:	c7 45 f4 9e 08 00 00 	movl   $0x89e,-0xc(%ebp)
        while(*s != 0){
 5c9:	eb 1c                	jmp    5e7 <printf+0xff>
          putc(fd, *s);
 5cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ce:	0f b6 00             	movzbl (%eax),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	83 ec 08             	sub    $0x8,%esp
 5d7:	50                   	push   %eax
 5d8:	ff 75 08             	pushl  0x8(%ebp)
 5db:	e8 31 fe ff ff       	call   411 <putc>
 5e0:	83 c4 10             	add    $0x10,%esp
          s++;
 5e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ea:	0f b6 00             	movzbl (%eax),%eax
 5ed:	84 c0                	test   %al,%al
 5ef:	75 da                	jne    5cb <printf+0xe3>
 5f1:	eb 65                	jmp    658 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f7:	75 1d                	jne    616 <printf+0x12e>
        putc(fd, *ap);
 5f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fc:	8b 00                	mov    (%eax),%eax
 5fe:	0f be c0             	movsbl %al,%eax
 601:	83 ec 08             	sub    $0x8,%esp
 604:	50                   	push   %eax
 605:	ff 75 08             	pushl  0x8(%ebp)
 608:	e8 04 fe ff ff       	call   411 <putc>
 60d:	83 c4 10             	add    $0x10,%esp
        ap++;
 610:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 614:	eb 42                	jmp    658 <printf+0x170>
      } else if(c == '%'){
 616:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 61a:	75 17                	jne    633 <printf+0x14b>
        putc(fd, c);
 61c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61f:	0f be c0             	movsbl %al,%eax
 622:	83 ec 08             	sub    $0x8,%esp
 625:	50                   	push   %eax
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 e3 fd ff ff       	call   411 <putc>
 62e:	83 c4 10             	add    $0x10,%esp
 631:	eb 25                	jmp    658 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 633:	83 ec 08             	sub    $0x8,%esp
 636:	6a 25                	push   $0x25
 638:	ff 75 08             	pushl  0x8(%ebp)
 63b:	e8 d1 fd ff ff       	call   411 <putc>
 640:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 646:	0f be c0             	movsbl %al,%eax
 649:	83 ec 08             	sub    $0x8,%esp
 64c:	50                   	push   %eax
 64d:	ff 75 08             	pushl  0x8(%ebp)
 650:	e8 bc fd ff ff       	call   411 <putc>
 655:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 658:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 65f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 663:	8b 55 0c             	mov    0xc(%ebp),%edx
 666:	8b 45 f0             	mov    -0x10(%ebp),%eax
 669:	01 d0                	add    %edx,%eax
 66b:	0f b6 00             	movzbl (%eax),%eax
 66e:	84 c0                	test   %al,%al
 670:	0f 85 94 fe ff ff    	jne    50a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 676:	90                   	nop
 677:	c9                   	leave  
 678:	c3                   	ret    

00000679 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 679:	55                   	push   %ebp
 67a:	89 e5                	mov    %esp,%ebp
 67c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	83 e8 08             	sub    $0x8,%eax
 685:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 688:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 68d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 690:	eb 24                	jmp    6b6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69a:	77 12                	ja     6ae <free+0x35>
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a2:	77 24                	ja     6c8 <free+0x4f>
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ac:	77 1a                	ja     6c8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bc:	76 d4                	jbe    692 <free+0x19>
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 00                	mov    (%eax),%eax
 6c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c6:	76 ca                	jbe    692 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	8b 40 04             	mov    0x4(%eax),%eax
 6ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	01 c2                	add    %eax,%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 00                	mov    (%eax),%eax
 6df:	39 c2                	cmp    %eax,%edx
 6e1:	75 24                	jne    707 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	8b 50 04             	mov    0x4(%eax),%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	8b 40 04             	mov    0x4(%eax),%eax
 6f1:	01 c2                	add    %eax,%edx
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	8b 10                	mov    (%eax),%edx
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	89 10                	mov    %edx,(%eax)
 705:	eb 0a                	jmp    711 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 10                	mov    (%eax),%edx
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 40 04             	mov    0x4(%eax),%eax
 717:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	01 d0                	add    %edx,%eax
 723:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 726:	75 20                	jne    748 <free+0xcf>
    p->s.size += bp->s.size;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 50 04             	mov    0x4(%eax),%edx
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	8b 40 04             	mov    0x4(%eax),%eax
 734:	01 c2                	add    %eax,%edx
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 73c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73f:	8b 10                	mov    (%eax),%edx
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	89 10                	mov    %edx,(%eax)
 746:	eb 08                	jmp    750 <free+0xd7>
  } else
    p->s.ptr = bp;
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 74e:	89 10                	mov    %edx,(%eax)
  freep = p;
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	a3 2c 0b 00 00       	mov    %eax,0xb2c
}
 758:	90                   	nop
 759:	c9                   	leave  
 75a:	c3                   	ret    

0000075b <morecore>:

static Header*
morecore(uint nu)
{
 75b:	55                   	push   %ebp
 75c:	89 e5                	mov    %esp,%ebp
 75e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 761:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 768:	77 07                	ja     771 <morecore+0x16>
    nu = 4096;
 76a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 771:	8b 45 08             	mov    0x8(%ebp),%eax
 774:	c1 e0 03             	shl    $0x3,%eax
 777:	83 ec 0c             	sub    $0xc,%esp
 77a:	50                   	push   %eax
 77b:	e8 19 fc ff ff       	call   399 <sbrk>
 780:	83 c4 10             	add    $0x10,%esp
 783:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 786:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 78a:	75 07                	jne    793 <morecore+0x38>
    return 0;
 78c:	b8 00 00 00 00       	mov    $0x0,%eax
 791:	eb 26                	jmp    7b9 <morecore+0x5e>
  hp = (Header*)p;
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 799:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79c:	8b 55 08             	mov    0x8(%ebp),%edx
 79f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a5:	83 c0 08             	add    $0x8,%eax
 7a8:	83 ec 0c             	sub    $0xc,%esp
 7ab:	50                   	push   %eax
 7ac:	e8 c8 fe ff ff       	call   679 <free>
 7b1:	83 c4 10             	add    $0x10,%esp
  return freep;
 7b4:	a1 2c 0b 00 00       	mov    0xb2c,%eax
}
 7b9:	c9                   	leave  
 7ba:	c3                   	ret    

000007bb <malloc>:

void*
malloc(uint nbytes)
{
 7bb:	55                   	push   %ebp
 7bc:	89 e5                	mov    %esp,%ebp
 7be:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c1:	8b 45 08             	mov    0x8(%ebp),%eax
 7c4:	83 c0 07             	add    $0x7,%eax
 7c7:	c1 e8 03             	shr    $0x3,%eax
 7ca:	83 c0 01             	add    $0x1,%eax
 7cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d0:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 7d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7dc:	75 23                	jne    801 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7de:	c7 45 f0 24 0b 00 00 	movl   $0xb24,-0x10(%ebp)
 7e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e8:	a3 2c 0b 00 00       	mov    %eax,0xb2c
 7ed:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 7f2:	a3 24 0b 00 00       	mov    %eax,0xb24
    base.s.size = 0;
 7f7:	c7 05 28 0b 00 00 00 	movl   $0x0,0xb28
 7fe:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 801:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804:	8b 00                	mov    (%eax),%eax
 806:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	8b 40 04             	mov    0x4(%eax),%eax
 80f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 812:	72 4d                	jb     861 <malloc+0xa6>
      if(p->s.size == nunits)
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	8b 40 04             	mov    0x4(%eax),%eax
 81a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81d:	75 0c                	jne    82b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	8b 10                	mov    (%eax),%edx
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	89 10                	mov    %edx,(%eax)
 829:	eb 26                	jmp    851 <malloc+0x96>
      else {
        p->s.size -= nunits;
 82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82e:	8b 40 04             	mov    0x4(%eax),%eax
 831:	2b 45 ec             	sub    -0x14(%ebp),%eax
 834:	89 c2                	mov    %eax,%edx
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	8b 40 04             	mov    0x4(%eax),%eax
 842:	c1 e0 03             	shl    $0x3,%eax
 845:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 84e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 851:	8b 45 f0             	mov    -0x10(%ebp),%eax
 854:	a3 2c 0b 00 00       	mov    %eax,0xb2c
      return (void*)(p + 1);
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	83 c0 08             	add    $0x8,%eax
 85f:	eb 3b                	jmp    89c <malloc+0xe1>
    }
    if(p == freep)
 861:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 866:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 869:	75 1e                	jne    889 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 86b:	83 ec 0c             	sub    $0xc,%esp
 86e:	ff 75 ec             	pushl  -0x14(%ebp)
 871:	e8 e5 fe ff ff       	call   75b <morecore>
 876:	83 c4 10             	add    $0x10,%esp
 879:	89 45 f4             	mov    %eax,-0xc(%ebp)
 87c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 880:	75 07                	jne    889 <malloc+0xce>
        return 0;
 882:	b8 00 00 00 00       	mov    $0x0,%eax
 887:	eb 13                	jmp    89c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 00                	mov    (%eax),%eax
 894:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 897:	e9 6d ff ff ff       	jmp    809 <malloc+0x4e>
}
 89c:	c9                   	leave  
 89d:	c3                   	ret    
