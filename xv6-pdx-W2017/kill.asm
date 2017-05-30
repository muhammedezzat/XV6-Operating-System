
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 e4 08 00 00       	push   $0x8e4
  21:	6a 02                	push   $0x2
  23:	e8 06 05 00 00       	call   52e <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 27 03 00 00       	call   357 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 28 03 00 00       	call   387 <kill>
  5f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  6d:	e8 e5 02 00 00       	call   357 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	8d 50 01             	lea    0x1(%eax),%edx
  ab:	89 55 08             	mov    %edx,0x8(%ebp)
  ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	pushl  0xc(%ebp)
 138:	ff 75 08             	pushl  0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 d5 01 00 00       	call   36f <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d5:	7c b3                	jl     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 9a 01 00 00       	call   397 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 91 01 00 00       	call   3af <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 50 01 00 00       	call   37f <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29b:	8d 50 01             	lea    0x1(%eax),%edx
 29e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <atoo>:

int
atoo(const char *s)
{
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2ce:	eb 04                	jmp    2d4 <atoo+0x13>
 2d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	0f b6 00             	movzbl (%eax),%eax
 2da:	3c 20                	cmp    $0x20,%al
 2dc:	74 f2                	je     2d0 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	3c 2d                	cmp    $0x2d,%al
 2e6:	75 07                	jne    2ef <atoo+0x2e>
 2e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ed:	eb 05                	jmp    2f4 <atoo+0x33>
 2ef:	b8 01 00 00 00       	mov    $0x1,%eax
 2f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	3c 2b                	cmp    $0x2b,%al
 2ff:	74 0a                	je     30b <atoo+0x4a>
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	0f b6 00             	movzbl (%eax),%eax
 307:	3c 2d                	cmp    $0x2d,%al
 309:	75 27                	jne    332 <atoo+0x71>
    s++;
 30b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 30f:	eb 21                	jmp    332 <atoo+0x71>
    n = n*8 + *s++ - '0';
 311:	8b 45 fc             	mov    -0x4(%ebp),%eax
 314:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	8d 50 01             	lea    0x1(%eax),%edx
 321:	89 55 08             	mov    %edx,0x8(%ebp)
 324:	0f b6 00             	movzbl (%eax),%eax
 327:	0f be c0             	movsbl %al,%eax
 32a:	01 c8                	add    %ecx,%eax
 32c:	83 e8 30             	sub    $0x30,%eax
 32f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	0f b6 00             	movzbl (%eax),%eax
 338:	3c 2f                	cmp    $0x2f,%al
 33a:	7e 0a                	jle    346 <atoo+0x85>
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	0f b6 00             	movzbl (%eax),%eax
 342:	3c 37                	cmp    $0x37,%al
 344:	7e cb                	jle    311 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 346:	8b 45 f8             	mov    -0x8(%ebp),%eax
 349:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 34d:	c9                   	leave  
 34e:	c3                   	ret    

0000034f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34f:	b8 01 00 00 00       	mov    $0x1,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <exit>:
SYSCALL(exit)
 357:	b8 02 00 00 00       	mov    $0x2,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <wait>:
SYSCALL(wait)
 35f:	b8 03 00 00 00       	mov    $0x3,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <pipe>:
SYSCALL(pipe)
 367:	b8 04 00 00 00       	mov    $0x4,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <read>:
SYSCALL(read)
 36f:	b8 05 00 00 00       	mov    $0x5,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <write>:
SYSCALL(write)
 377:	b8 10 00 00 00       	mov    $0x10,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <close>:
SYSCALL(close)
 37f:	b8 15 00 00 00       	mov    $0x15,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <kill>:
SYSCALL(kill)
 387:	b8 06 00 00 00       	mov    $0x6,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <exec>:
SYSCALL(exec)
 38f:	b8 07 00 00 00       	mov    $0x7,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <open>:
SYSCALL(open)
 397:	b8 0f 00 00 00       	mov    $0xf,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <mknod>:
SYSCALL(mknod)
 39f:	b8 11 00 00 00       	mov    $0x11,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <unlink>:
SYSCALL(unlink)
 3a7:	b8 12 00 00 00       	mov    $0x12,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <fstat>:
SYSCALL(fstat)
 3af:	b8 08 00 00 00       	mov    $0x8,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <link>:
SYSCALL(link)
 3b7:	b8 13 00 00 00       	mov    $0x13,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <mkdir>:
SYSCALL(mkdir)
 3bf:	b8 14 00 00 00       	mov    $0x14,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <chdir>:
SYSCALL(chdir)
 3c7:	b8 09 00 00 00       	mov    $0x9,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <dup>:
SYSCALL(dup)
 3cf:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <getpid>:
SYSCALL(getpid)
 3d7:	b8 0b 00 00 00       	mov    $0xb,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <sbrk>:
SYSCALL(sbrk)
 3df:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <sleep>:
SYSCALL(sleep)
 3e7:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <uptime>:
SYSCALL(uptime)
 3ef:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <halt>:
SYSCALL(halt)
 3f7:	b8 16 00 00 00       	mov    $0x16,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 3ff:	b8 17 00 00 00       	mov    $0x17,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 407:	b8 18 00 00 00       	mov    $0x18,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 40f:	b8 19 00 00 00       	mov    $0x19,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 417:	b8 1a 00 00 00       	mov    $0x1a,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 41f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 427:	b8 1c 00 00 00       	mov    $0x1c,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 42f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 437:	b8 1b 00 00 00       	mov    $0x1b,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 43f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 447:	b8 1d 00 00 00       	mov    $0x1d,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 44f:	b8 1e 00 00 00       	mov    $0x1e,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 457:	55                   	push   %ebp
 458:	89 e5                	mov    %esp,%ebp
 45a:	83 ec 18             	sub    $0x18,%esp
 45d:	8b 45 0c             	mov    0xc(%ebp),%eax
 460:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 463:	83 ec 04             	sub    $0x4,%esp
 466:	6a 01                	push   $0x1
 468:	8d 45 f4             	lea    -0xc(%ebp),%eax
 46b:	50                   	push   %eax
 46c:	ff 75 08             	pushl  0x8(%ebp)
 46f:	e8 03 ff ff ff       	call   377 <write>
 474:	83 c4 10             	add    $0x10,%esp
}
 477:	90                   	nop
 478:	c9                   	leave  
 479:	c3                   	ret    

0000047a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47a:	55                   	push   %ebp
 47b:	89 e5                	mov    %esp,%ebp
 47d:	53                   	push   %ebx
 47e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 481:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 488:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 48c:	74 17                	je     4a5 <printint+0x2b>
 48e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 492:	79 11                	jns    4a5 <printint+0x2b>
    neg = 1;
 494:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 49b:	8b 45 0c             	mov    0xc(%ebp),%eax
 49e:	f7 d8                	neg    %eax
 4a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a3:	eb 06                	jmp    4ab <printint+0x31>
  } else {
    x = xx;
 4a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4b5:	8d 41 01             	lea    0x1(%ecx),%eax
 4b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c1:	ba 00 00 00 00       	mov    $0x0,%edx
 4c6:	f7 f3                	div    %ebx
 4c8:	89 d0                	mov    %edx,%eax
 4ca:	0f b6 80 6c 0b 00 00 	movzbl 0xb6c(%eax),%eax
 4d1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4db:	ba 00 00 00 00       	mov    $0x0,%edx
 4e0:	f7 f3                	div    %ebx
 4e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e9:	75 c7                	jne    4b2 <printint+0x38>
  if(neg)
 4eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ef:	74 2d                	je     51e <printint+0xa4>
    buf[i++] = '-';
 4f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f4:	8d 50 01             	lea    0x1(%eax),%edx
 4f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4fa:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ff:	eb 1d                	jmp    51e <printint+0xa4>
    putc(fd, buf[i]);
 501:	8d 55 dc             	lea    -0x24(%ebp),%edx
 504:	8b 45 f4             	mov    -0xc(%ebp),%eax
 507:	01 d0                	add    %edx,%eax
 509:	0f b6 00             	movzbl (%eax),%eax
 50c:	0f be c0             	movsbl %al,%eax
 50f:	83 ec 08             	sub    $0x8,%esp
 512:	50                   	push   %eax
 513:	ff 75 08             	pushl  0x8(%ebp)
 516:	e8 3c ff ff ff       	call   457 <putc>
 51b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 51e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 522:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 526:	79 d9                	jns    501 <printint+0x87>
    putc(fd, buf[i]);
}
 528:	90                   	nop
 529:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 52c:	c9                   	leave  
 52d:	c3                   	ret    

0000052e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 52e:	55                   	push   %ebp
 52f:	89 e5                	mov    %esp,%ebp
 531:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 534:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 53b:	8d 45 0c             	lea    0xc(%ebp),%eax
 53e:	83 c0 04             	add    $0x4,%eax
 541:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 544:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 54b:	e9 59 01 00 00       	jmp    6a9 <printf+0x17b>
    c = fmt[i] & 0xff;
 550:	8b 55 0c             	mov    0xc(%ebp),%edx
 553:	8b 45 f0             	mov    -0x10(%ebp),%eax
 556:	01 d0                	add    %edx,%eax
 558:	0f b6 00             	movzbl (%eax),%eax
 55b:	0f be c0             	movsbl %al,%eax
 55e:	25 ff 00 00 00       	and    $0xff,%eax
 563:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 566:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56a:	75 2c                	jne    598 <printf+0x6a>
      if(c == '%'){
 56c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 570:	75 0c                	jne    57e <printf+0x50>
        state = '%';
 572:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 579:	e9 27 01 00 00       	jmp    6a5 <printf+0x177>
      } else {
        putc(fd, c);
 57e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 581:	0f be c0             	movsbl %al,%eax
 584:	83 ec 08             	sub    $0x8,%esp
 587:	50                   	push   %eax
 588:	ff 75 08             	pushl  0x8(%ebp)
 58b:	e8 c7 fe ff ff       	call   457 <putc>
 590:	83 c4 10             	add    $0x10,%esp
 593:	e9 0d 01 00 00       	jmp    6a5 <printf+0x177>
      }
    } else if(state == '%'){
 598:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 59c:	0f 85 03 01 00 00    	jne    6a5 <printf+0x177>
      if(c == 'd'){
 5a2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5a6:	75 1e                	jne    5c6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ab:	8b 00                	mov    (%eax),%eax
 5ad:	6a 01                	push   $0x1
 5af:	6a 0a                	push   $0xa
 5b1:	50                   	push   %eax
 5b2:	ff 75 08             	pushl  0x8(%ebp)
 5b5:	e8 c0 fe ff ff       	call   47a <printint>
 5ba:	83 c4 10             	add    $0x10,%esp
        ap++;
 5bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c1:	e9 d8 00 00 00       	jmp    69e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5c6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ca:	74 06                	je     5d2 <printf+0xa4>
 5cc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d0:	75 1e                	jne    5f0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d5:	8b 00                	mov    (%eax),%eax
 5d7:	6a 00                	push   $0x0
 5d9:	6a 10                	push   $0x10
 5db:	50                   	push   %eax
 5dc:	ff 75 08             	pushl  0x8(%ebp)
 5df:	e8 96 fe ff ff       	call   47a <printint>
 5e4:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5eb:	e9 ae 00 00 00       	jmp    69e <printf+0x170>
      } else if(c == 's'){
 5f0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5f4:	75 43                	jne    639 <printf+0x10b>
        s = (char*)*ap;
 5f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 606:	75 25                	jne    62d <printf+0xff>
          s = "(null)";
 608:	c7 45 f4 f8 08 00 00 	movl   $0x8f8,-0xc(%ebp)
        while(*s != 0){
 60f:	eb 1c                	jmp    62d <printf+0xff>
          putc(fd, *s);
 611:	8b 45 f4             	mov    -0xc(%ebp),%eax
 614:	0f b6 00             	movzbl (%eax),%eax
 617:	0f be c0             	movsbl %al,%eax
 61a:	83 ec 08             	sub    $0x8,%esp
 61d:	50                   	push   %eax
 61e:	ff 75 08             	pushl  0x8(%ebp)
 621:	e8 31 fe ff ff       	call   457 <putc>
 626:	83 c4 10             	add    $0x10,%esp
          s++;
 629:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 62d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 630:	0f b6 00             	movzbl (%eax),%eax
 633:	84 c0                	test   %al,%al
 635:	75 da                	jne    611 <printf+0xe3>
 637:	eb 65                	jmp    69e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 639:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 63d:	75 1d                	jne    65c <printf+0x12e>
        putc(fd, *ap);
 63f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 642:	8b 00                	mov    (%eax),%eax
 644:	0f be c0             	movsbl %al,%eax
 647:	83 ec 08             	sub    $0x8,%esp
 64a:	50                   	push   %eax
 64b:	ff 75 08             	pushl  0x8(%ebp)
 64e:	e8 04 fe ff ff       	call   457 <putc>
 653:	83 c4 10             	add    $0x10,%esp
        ap++;
 656:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65a:	eb 42                	jmp    69e <printf+0x170>
      } else if(c == '%'){
 65c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 660:	75 17                	jne    679 <printf+0x14b>
        putc(fd, c);
 662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 665:	0f be c0             	movsbl %al,%eax
 668:	83 ec 08             	sub    $0x8,%esp
 66b:	50                   	push   %eax
 66c:	ff 75 08             	pushl  0x8(%ebp)
 66f:	e8 e3 fd ff ff       	call   457 <putc>
 674:	83 c4 10             	add    $0x10,%esp
 677:	eb 25                	jmp    69e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 679:	83 ec 08             	sub    $0x8,%esp
 67c:	6a 25                	push   $0x25
 67e:	ff 75 08             	pushl  0x8(%ebp)
 681:	e8 d1 fd ff ff       	call   457 <putc>
 686:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68c:	0f be c0             	movsbl %al,%eax
 68f:	83 ec 08             	sub    $0x8,%esp
 692:	50                   	push   %eax
 693:	ff 75 08             	pushl  0x8(%ebp)
 696:	e8 bc fd ff ff       	call   457 <putc>
 69b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 69e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6af:	01 d0                	add    %edx,%eax
 6b1:	0f b6 00             	movzbl (%eax),%eax
 6b4:	84 c0                	test   %al,%al
 6b6:	0f 85 94 fe ff ff    	jne    550 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6bc:	90                   	nop
 6bd:	c9                   	leave  
 6be:	c3                   	ret    

000006bf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6bf:	55                   	push   %ebp
 6c0:	89 e5                	mov    %esp,%ebp
 6c2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	83 e8 08             	sub    $0x8,%eax
 6cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ce:	a1 88 0b 00 00       	mov    0xb88,%eax
 6d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d6:	eb 24                	jmp    6fc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e0:	77 12                	ja     6f4 <free+0x35>
 6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e8:	77 24                	ja     70e <free+0x4f>
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	8b 00                	mov    (%eax),%eax
 6ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f2:	77 1a                	ja     70e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 702:	76 d4                	jbe    6d8 <free+0x19>
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70c:	76 ca                	jbe    6d8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 70e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 711:	8b 40 04             	mov    0x4(%eax),%eax
 714:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	01 c2                	add    %eax,%edx
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	39 c2                	cmp    %eax,%edx
 727:	75 24                	jne    74d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	8b 50 04             	mov    0x4(%eax),%edx
 72f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 732:	8b 00                	mov    (%eax),%eax
 734:	8b 40 04             	mov    0x4(%eax),%eax
 737:	01 c2                	add    %eax,%edx
 739:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	8b 00                	mov    (%eax),%eax
 744:	8b 10                	mov    (%eax),%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	89 10                	mov    %edx,(%eax)
 74b:	eb 0a                	jmp    757 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 10                	mov    (%eax),%edx
 752:	8b 45 f8             	mov    -0x8(%ebp),%eax
 755:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 40 04             	mov    0x4(%eax),%eax
 75d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	01 d0                	add    %edx,%eax
 769:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76c:	75 20                	jne    78e <free+0xcf>
    p->s.size += bp->s.size;
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	8b 50 04             	mov    0x4(%eax),%edx
 774:	8b 45 f8             	mov    -0x8(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	01 c2                	add    %eax,%edx
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 782:	8b 45 f8             	mov    -0x8(%ebp),%eax
 785:	8b 10                	mov    (%eax),%edx
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	89 10                	mov    %edx,(%eax)
 78c:	eb 08                	jmp    796 <free+0xd7>
  } else
    p->s.ptr = bp;
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	8b 55 f8             	mov    -0x8(%ebp),%edx
 794:	89 10                	mov    %edx,(%eax)
  freep = p;
 796:	8b 45 fc             	mov    -0x4(%ebp),%eax
 799:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 79e:	90                   	nop
 79f:	c9                   	leave  
 7a0:	c3                   	ret    

000007a1 <morecore>:

static Header*
morecore(uint nu)
{
 7a1:	55                   	push   %ebp
 7a2:	89 e5                	mov    %esp,%ebp
 7a4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7a7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ae:	77 07                	ja     7b7 <morecore+0x16>
    nu = 4096;
 7b0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7b7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ba:	c1 e0 03             	shl    $0x3,%eax
 7bd:	83 ec 0c             	sub    $0xc,%esp
 7c0:	50                   	push   %eax
 7c1:	e8 19 fc ff ff       	call   3df <sbrk>
 7c6:	83 c4 10             	add    $0x10,%esp
 7c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7cc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d0:	75 07                	jne    7d9 <morecore+0x38>
    return 0;
 7d2:	b8 00 00 00 00       	mov    $0x0,%eax
 7d7:	eb 26                	jmp    7ff <morecore+0x5e>
  hp = (Header*)p;
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e2:	8b 55 08             	mov    0x8(%ebp),%edx
 7e5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	83 c0 08             	add    $0x8,%eax
 7ee:	83 ec 0c             	sub    $0xc,%esp
 7f1:	50                   	push   %eax
 7f2:	e8 c8 fe ff ff       	call   6bf <free>
 7f7:	83 c4 10             	add    $0x10,%esp
  return freep;
 7fa:	a1 88 0b 00 00       	mov    0xb88,%eax
}
 7ff:	c9                   	leave  
 800:	c3                   	ret    

00000801 <malloc>:

void*
malloc(uint nbytes)
{
 801:	55                   	push   %ebp
 802:	89 e5                	mov    %esp,%ebp
 804:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 807:	8b 45 08             	mov    0x8(%ebp),%eax
 80a:	83 c0 07             	add    $0x7,%eax
 80d:	c1 e8 03             	shr    $0x3,%eax
 810:	83 c0 01             	add    $0x1,%eax
 813:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 816:	a1 88 0b 00 00       	mov    0xb88,%eax
 81b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 822:	75 23                	jne    847 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 824:	c7 45 f0 80 0b 00 00 	movl   $0xb80,-0x10(%ebp)
 82b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82e:	a3 88 0b 00 00       	mov    %eax,0xb88
 833:	a1 88 0b 00 00       	mov    0xb88,%eax
 838:	a3 80 0b 00 00       	mov    %eax,0xb80
    base.s.size = 0;
 83d:	c7 05 84 0b 00 00 00 	movl   $0x0,0xb84
 844:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 847:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84a:	8b 00                	mov    (%eax),%eax
 84c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	8b 40 04             	mov    0x4(%eax),%eax
 855:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 858:	72 4d                	jb     8a7 <malloc+0xa6>
      if(p->s.size == nunits)
 85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85d:	8b 40 04             	mov    0x4(%eax),%eax
 860:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 863:	75 0c                	jne    871 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	8b 10                	mov    (%eax),%edx
 86a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86d:	89 10                	mov    %edx,(%eax)
 86f:	eb 26                	jmp    897 <malloc+0x96>
      else {
        p->s.size -= nunits;
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	8b 40 04             	mov    0x4(%eax),%eax
 877:	2b 45 ec             	sub    -0x14(%ebp),%eax
 87a:	89 c2                	mov    %eax,%edx
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	8b 40 04             	mov    0x4(%eax),%eax
 888:	c1 e0 03             	shl    $0x3,%eax
 88b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 891:	8b 55 ec             	mov    -0x14(%ebp),%edx
 894:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 897:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89a:	a3 88 0b 00 00       	mov    %eax,0xb88
      return (void*)(p + 1);
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	83 c0 08             	add    $0x8,%eax
 8a5:	eb 3b                	jmp    8e2 <malloc+0xe1>
    }
    if(p == freep)
 8a7:	a1 88 0b 00 00       	mov    0xb88,%eax
 8ac:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8af:	75 1e                	jne    8cf <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8b1:	83 ec 0c             	sub    $0xc,%esp
 8b4:	ff 75 ec             	pushl  -0x14(%ebp)
 8b7:	e8 e5 fe ff ff       	call   7a1 <morecore>
 8bc:	83 c4 10             	add    $0x10,%esp
 8bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c6:	75 07                	jne    8cf <malloc+0xce>
        return 0;
 8c8:	b8 00 00 00 00       	mov    $0x0,%eax
 8cd:	eb 13                	jmp    8e2 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 00                	mov    (%eax),%eax
 8da:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8dd:	e9 6d ff ff ff       	jmp    84f <malloc+0x4e>
}
 8e2:	c9                   	leave  
 8e3:	c3                   	ret    
