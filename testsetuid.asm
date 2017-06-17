
_testsetuid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

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
   f:	89 cb                	mov    %ecx,%ebx
  printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  11:	e8 b2 03 00 00       	call   3c8 <getuid>
  16:	89 c2                	mov    %eax,%edx
  18:	8b 43 04             	mov    0x4(%ebx),%eax
  1b:	8b 00                	mov    (%eax),%eax
  1d:	52                   	push   %edx
  1e:	50                   	push   %eax
  1f:	68 a5 08 00 00       	push   $0x8a5
  24:	6a 01                	push   $0x1
  26:	e8 c4 04 00 00       	call   4ef <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  exit();
  2e:	e8 e5 02 00 00       	call   318 <exit>

00000033 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  33:	55                   	push   %ebp
  34:	89 e5                	mov    %esp,%ebp
  36:	57                   	push   %edi
  37:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  3b:	8b 55 10             	mov    0x10(%ebp),%edx
  3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  41:	89 cb                	mov    %ecx,%ebx
  43:	89 df                	mov    %ebx,%edi
  45:	89 d1                	mov    %edx,%ecx
  47:	fc                   	cld    
  48:	f3 aa                	rep stos %al,%es:(%edi)
  4a:	89 ca                	mov    %ecx,%edx
  4c:	89 fb                	mov    %edi,%ebx
  4e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  51:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  54:	90                   	nop
  55:	5b                   	pop    %ebx
  56:	5f                   	pop    %edi
  57:	5d                   	pop    %ebp
  58:	c3                   	ret    

00000059 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  65:	90                   	nop
  66:	8b 45 08             	mov    0x8(%ebp),%eax
  69:	8d 50 01             	lea    0x1(%eax),%edx
  6c:	89 55 08             	mov    %edx,0x8(%ebp)
  6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  72:	8d 4a 01             	lea    0x1(%edx),%ecx
  75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  78:	0f b6 12             	movzbl (%edx),%edx
  7b:	88 10                	mov    %dl,(%eax)
  7d:	0f b6 00             	movzbl (%eax),%eax
  80:	84 c0                	test   %al,%al
  82:	75 e2                	jne    66 <strcpy+0xd>
    ;
  return os;
  84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  87:	c9                   	leave  
  88:	c3                   	ret    

00000089 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  89:	55                   	push   %ebp
  8a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  8c:	eb 08                	jmp    96 <strcmp+0xd>
    p++, q++;
  8e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  92:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  96:	8b 45 08             	mov    0x8(%ebp),%eax
  99:	0f b6 00             	movzbl (%eax),%eax
  9c:	84 c0                	test   %al,%al
  9e:	74 10                	je     b0 <strcmp+0x27>
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	0f b6 10             	movzbl (%eax),%edx
  a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  a9:	0f b6 00             	movzbl (%eax),%eax
  ac:	38 c2                	cmp    %al,%dl
  ae:	74 de                	je     8e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	0f b6 00             	movzbl (%eax),%eax
  b6:	0f b6 d0             	movzbl %al,%edx
  b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	0f b6 c0             	movzbl %al,%eax
  c2:	29 c2                	sub    %eax,%edx
  c4:	89 d0                	mov    %edx,%eax
}
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    

000000c8 <strlen>:

uint
strlen(char *s)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  d5:	eb 04                	jmp    db <strlen+0x13>
  d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	01 d0                	add    %edx,%eax
  e3:	0f b6 00             	movzbl (%eax),%eax
  e6:	84 c0                	test   %al,%al
  e8:	75 ed                	jne    d7 <strlen+0xf>
    ;
  return n;
  ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ed:	c9                   	leave  
  ee:	c3                   	ret    

000000ef <memset>:

void*
memset(void *dst, int c, uint n)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  f2:	8b 45 10             	mov    0x10(%ebp),%eax
  f5:	50                   	push   %eax
  f6:	ff 75 0c             	pushl  0xc(%ebp)
  f9:	ff 75 08             	pushl  0x8(%ebp)
  fc:	e8 32 ff ff ff       	call   33 <stosb>
 101:	83 c4 0c             	add    $0xc,%esp
  return dst;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
}
 107:	c9                   	leave  
 108:	c3                   	ret    

00000109 <strchr>:

char*
strchr(const char *s, char c)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 04             	sub    $0x4,%esp
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 115:	eb 14                	jmp    12b <strchr+0x22>
    if(*s == c)
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 120:	75 05                	jne    127 <strchr+0x1e>
      return (char*)s;
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	eb 13                	jmp    13a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 127:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 e2                	jne    117 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 135:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13a:	c9                   	leave  
 13b:	c3                   	ret    

0000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 149:	eb 42                	jmp    18d <gets+0x51>
    cc = read(0, &c, 1);
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	6a 01                	push   $0x1
 150:	8d 45 ef             	lea    -0x11(%ebp),%eax
 153:	50                   	push   %eax
 154:	6a 00                	push   $0x0
 156:	e8 d5 01 00 00       	call   330 <read>
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 161:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 165:	7e 33                	jle    19a <gets+0x5e>
      break;
    buf[i++] = c;
 167:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16a:	8d 50 01             	lea    0x1(%eax),%edx
 16d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 170:	89 c2                	mov    %eax,%edx
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	01 c2                	add    %eax,%edx
 177:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 17d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 181:	3c 0a                	cmp    $0xa,%al
 183:	74 16                	je     19b <gets+0x5f>
 185:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 189:	3c 0d                	cmp    $0xd,%al
 18b:	74 0e                	je     19b <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 190:	83 c0 01             	add    $0x1,%eax
 193:	3b 45 0c             	cmp    0xc(%ebp),%eax
 196:	7c b3                	jl     14b <gets+0xf>
 198:	eb 01                	jmp    19b <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 19a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <stat>:

int
stat(char *n, struct stat *st)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b1:	83 ec 08             	sub    $0x8,%esp
 1b4:	6a 00                	push   $0x0
 1b6:	ff 75 08             	pushl  0x8(%ebp)
 1b9:	e8 9a 01 00 00       	call   358 <open>
 1be:	83 c4 10             	add    $0x10,%esp
 1c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c8:	79 07                	jns    1d1 <stat+0x26>
    return -1;
 1ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1cf:	eb 25                	jmp    1f6 <stat+0x4b>
  r = fstat(fd, st);
 1d1:	83 ec 08             	sub    $0x8,%esp
 1d4:	ff 75 0c             	pushl  0xc(%ebp)
 1d7:	ff 75 f4             	pushl  -0xc(%ebp)
 1da:	e8 91 01 00 00       	call   370 <fstat>
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e5:	83 ec 0c             	sub    $0xc,%esp
 1e8:	ff 75 f4             	pushl  -0xc(%ebp)
 1eb:	e8 50 01 00 00       	call   340 <close>
 1f0:	83 c4 10             	add    $0x10,%esp
  return r;
 1f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f6:	c9                   	leave  
 1f7:	c3                   	ret    

000001f8 <atoi>:

int
atoi(const char *s)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 205:	eb 25                	jmp    22c <atoi+0x34>
    n = n*10 + *s++ - '0';
 207:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20a:	89 d0                	mov    %edx,%eax
 20c:	c1 e0 02             	shl    $0x2,%eax
 20f:	01 d0                	add    %edx,%eax
 211:	01 c0                	add    %eax,%eax
 213:	89 c1                	mov    %eax,%ecx
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	8d 50 01             	lea    0x1(%eax),%edx
 21b:	89 55 08             	mov    %edx,0x8(%ebp)
 21e:	0f b6 00             	movzbl (%eax),%eax
 221:	0f be c0             	movsbl %al,%eax
 224:	01 c8                	add    %ecx,%eax
 226:	83 e8 30             	sub    $0x30,%eax
 229:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
 22f:	0f b6 00             	movzbl (%eax),%eax
 232:	3c 2f                	cmp    $0x2f,%al
 234:	7e 0a                	jle    240 <atoi+0x48>
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	3c 39                	cmp    $0x39,%al
 23e:	7e c7                	jle    207 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 240:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 243:	c9                   	leave  
 244:	c3                   	ret    

00000245 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 245:	55                   	push   %ebp
 246:	89 e5                	mov    %esp,%ebp
 248:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 251:	8b 45 0c             	mov    0xc(%ebp),%eax
 254:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 257:	eb 17                	jmp    270 <memmove+0x2b>
    *dst++ = *src++;
 259:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25c:	8d 50 01             	lea    0x1(%eax),%edx
 25f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 262:	8b 55 f8             	mov    -0x8(%ebp),%edx
 265:	8d 4a 01             	lea    0x1(%edx),%ecx
 268:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 26b:	0f b6 12             	movzbl (%edx),%edx
 26e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 270:	8b 45 10             	mov    0x10(%ebp),%eax
 273:	8d 50 ff             	lea    -0x1(%eax),%edx
 276:	89 55 10             	mov    %edx,0x10(%ebp)
 279:	85 c0                	test   %eax,%eax
 27b:	7f dc                	jg     259 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <atoo>:

int
atoo(const char *s)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 288:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 28f:	eb 04                	jmp    295 <atoo+0x13>
 291:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	0f b6 00             	movzbl (%eax),%eax
 29b:	3c 20                	cmp    $0x20,%al
 29d:	74 f2                	je     291 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	3c 2d                	cmp    $0x2d,%al
 2a7:	75 07                	jne    2b0 <atoo+0x2e>
 2a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ae:	eb 05                	jmp    2b5 <atoo+0x33>
 2b0:	b8 01 00 00 00       	mov    $0x1,%eax
 2b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	3c 2b                	cmp    $0x2b,%al
 2c0:	74 0a                	je     2cc <atoo+0x4a>
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	0f b6 00             	movzbl (%eax),%eax
 2c8:	3c 2d                	cmp    $0x2d,%al
 2ca:	75 27                	jne    2f3 <atoo+0x71>
    s++;
 2cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 2d0:	eb 21                	jmp    2f3 <atoo+0x71>
    n = n*8 + *s++ - '0';
 2d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d5:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	8d 50 01             	lea    0x1(%eax),%edx
 2e2:	89 55 08             	mov    %edx,0x8(%ebp)
 2e5:	0f b6 00             	movzbl (%eax),%eax
 2e8:	0f be c0             	movsbl %al,%eax
 2eb:	01 c8                	add    %ecx,%eax
 2ed:	83 e8 30             	sub    $0x30,%eax
 2f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	0f b6 00             	movzbl (%eax),%eax
 2f9:	3c 2f                	cmp    $0x2f,%al
 2fb:	7e 0a                	jle    307 <atoo+0x85>
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	0f b6 00             	movzbl (%eax),%eax
 303:	3c 37                	cmp    $0x37,%al
 305:	7e cb                	jle    2d2 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 307:	8b 45 f8             	mov    -0x8(%ebp),%eax
 30a:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 310:	b8 01 00 00 00       	mov    $0x1,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <exit>:
SYSCALL(exit)
 318:	b8 02 00 00 00       	mov    $0x2,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <wait>:
SYSCALL(wait)
 320:	b8 03 00 00 00       	mov    $0x3,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <pipe>:
SYSCALL(pipe)
 328:	b8 04 00 00 00       	mov    $0x4,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <read>:
SYSCALL(read)
 330:	b8 05 00 00 00       	mov    $0x5,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <write>:
SYSCALL(write)
 338:	b8 10 00 00 00       	mov    $0x10,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <close>:
SYSCALL(close)
 340:	b8 15 00 00 00       	mov    $0x15,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <kill>:
SYSCALL(kill)
 348:	b8 06 00 00 00       	mov    $0x6,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <exec>:
SYSCALL(exec)
 350:	b8 07 00 00 00       	mov    $0x7,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <open>:
SYSCALL(open)
 358:	b8 0f 00 00 00       	mov    $0xf,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <mknod>:
SYSCALL(mknod)
 360:	b8 11 00 00 00       	mov    $0x11,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <unlink>:
SYSCALL(unlink)
 368:	b8 12 00 00 00       	mov    $0x12,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <fstat>:
SYSCALL(fstat)
 370:	b8 08 00 00 00       	mov    $0x8,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <link>:
SYSCALL(link)
 378:	b8 13 00 00 00       	mov    $0x13,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <mkdir>:
SYSCALL(mkdir)
 380:	b8 14 00 00 00       	mov    $0x14,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <chdir>:
SYSCALL(chdir)
 388:	b8 09 00 00 00       	mov    $0x9,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <dup>:
SYSCALL(dup)
 390:	b8 0a 00 00 00       	mov    $0xa,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <getpid>:
SYSCALL(getpid)
 398:	b8 0b 00 00 00       	mov    $0xb,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <sbrk>:
SYSCALL(sbrk)
 3a0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <sleep>:
SYSCALL(sleep)
 3a8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <uptime>:
SYSCALL(uptime)
 3b0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <halt>:
SYSCALL(halt)
 3b8:	b8 16 00 00 00       	mov    $0x16,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 3c0:	b8 17 00 00 00       	mov    $0x17,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 3c8:	b8 18 00 00 00       	mov    $0x18,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 3d0:	b8 19 00 00 00       	mov    $0x19,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 3d8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 3e0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 3e8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 3f0:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 3f8:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 400:	b8 1f 00 00 00       	mov    $0x1f,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 408:	b8 20 00 00 00       	mov    $0x20,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 410:	b8 21 00 00 00       	mov    $0x21,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 18             	sub    $0x18,%esp
 41e:	8b 45 0c             	mov    0xc(%ebp),%eax
 421:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 424:	83 ec 04             	sub    $0x4,%esp
 427:	6a 01                	push   $0x1
 429:	8d 45 f4             	lea    -0xc(%ebp),%eax
 42c:	50                   	push   %eax
 42d:	ff 75 08             	pushl  0x8(%ebp)
 430:	e8 03 ff ff ff       	call   338 <write>
 435:	83 c4 10             	add    $0x10,%esp
}
 438:	90                   	nop
 439:	c9                   	leave  
 43a:	c3                   	ret    

0000043b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43b:	55                   	push   %ebp
 43c:	89 e5                	mov    %esp,%ebp
 43e:	53                   	push   %ebx
 43f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 442:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 449:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 44d:	74 17                	je     466 <printint+0x2b>
 44f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 453:	79 11                	jns    466 <printint+0x2b>
    neg = 1;
 455:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 45c:	8b 45 0c             	mov    0xc(%ebp),%eax
 45f:	f7 d8                	neg    %eax
 461:	89 45 ec             	mov    %eax,-0x14(%ebp)
 464:	eb 06                	jmp    46c <printint+0x31>
  } else {
    x = xx;
 466:	8b 45 0c             	mov    0xc(%ebp),%eax
 469:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 46c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 473:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 476:	8d 41 01             	lea    0x1(%ecx),%eax
 479:	89 45 f4             	mov    %eax,-0xc(%ebp)
 47c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 482:	ba 00 00 00 00       	mov    $0x0,%edx
 487:	f7 f3                	div    %ebx
 489:	89 d0                	mov    %edx,%eax
 48b:	0f b6 80 34 0b 00 00 	movzbl 0xb34(%eax),%eax
 492:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 496:	8b 5d 10             	mov    0x10(%ebp),%ebx
 499:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49c:	ba 00 00 00 00       	mov    $0x0,%edx
 4a1:	f7 f3                	div    %ebx
 4a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4aa:	75 c7                	jne    473 <printint+0x38>
  if(neg)
 4ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b0:	74 2d                	je     4df <printint+0xa4>
    buf[i++] = '-';
 4b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b5:	8d 50 01             	lea    0x1(%eax),%edx
 4b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4bb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4c0:	eb 1d                	jmp    4df <printint+0xa4>
    putc(fd, buf[i]);
 4c2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c8:	01 d0                	add    %edx,%eax
 4ca:	0f b6 00             	movzbl (%eax),%eax
 4cd:	0f be c0             	movsbl %al,%eax
 4d0:	83 ec 08             	sub    $0x8,%esp
 4d3:	50                   	push   %eax
 4d4:	ff 75 08             	pushl  0x8(%ebp)
 4d7:	e8 3c ff ff ff       	call   418 <putc>
 4dc:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4df:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e7:	79 d9                	jns    4c2 <printint+0x87>
    putc(fd, buf[i]);
}
 4e9:	90                   	nop
 4ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4ed:	c9                   	leave  
 4ee:	c3                   	ret    

000004ef <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4fc:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ff:	83 c0 04             	add    $0x4,%eax
 502:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 505:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 50c:	e9 59 01 00 00       	jmp    66a <printf+0x17b>
    c = fmt[i] & 0xff;
 511:	8b 55 0c             	mov    0xc(%ebp),%edx
 514:	8b 45 f0             	mov    -0x10(%ebp),%eax
 517:	01 d0                	add    %edx,%eax
 519:	0f b6 00             	movzbl (%eax),%eax
 51c:	0f be c0             	movsbl %al,%eax
 51f:	25 ff 00 00 00       	and    $0xff,%eax
 524:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 527:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 52b:	75 2c                	jne    559 <printf+0x6a>
      if(c == '%'){
 52d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 531:	75 0c                	jne    53f <printf+0x50>
        state = '%';
 533:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 53a:	e9 27 01 00 00       	jmp    666 <printf+0x177>
      } else {
        putc(fd, c);
 53f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 542:	0f be c0             	movsbl %al,%eax
 545:	83 ec 08             	sub    $0x8,%esp
 548:	50                   	push   %eax
 549:	ff 75 08             	pushl  0x8(%ebp)
 54c:	e8 c7 fe ff ff       	call   418 <putc>
 551:	83 c4 10             	add    $0x10,%esp
 554:	e9 0d 01 00 00       	jmp    666 <printf+0x177>
      }
    } else if(state == '%'){
 559:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 55d:	0f 85 03 01 00 00    	jne    666 <printf+0x177>
      if(c == 'd'){
 563:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 567:	75 1e                	jne    587 <printf+0x98>
        printint(fd, *ap, 10, 1);
 569:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56c:	8b 00                	mov    (%eax),%eax
 56e:	6a 01                	push   $0x1
 570:	6a 0a                	push   $0xa
 572:	50                   	push   %eax
 573:	ff 75 08             	pushl  0x8(%ebp)
 576:	e8 c0 fe ff ff       	call   43b <printint>
 57b:	83 c4 10             	add    $0x10,%esp
        ap++;
 57e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 582:	e9 d8 00 00 00       	jmp    65f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 587:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 58b:	74 06                	je     593 <printf+0xa4>
 58d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 591:	75 1e                	jne    5b1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 593:	8b 45 e8             	mov    -0x18(%ebp),%eax
 596:	8b 00                	mov    (%eax),%eax
 598:	6a 00                	push   $0x0
 59a:	6a 10                	push   $0x10
 59c:	50                   	push   %eax
 59d:	ff 75 08             	pushl  0x8(%ebp)
 5a0:	e8 96 fe ff ff       	call   43b <printint>
 5a5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ac:	e9 ae 00 00 00       	jmp    65f <printf+0x170>
      } else if(c == 's'){
 5b1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5b5:	75 43                	jne    5fa <printf+0x10b>
        s = (char*)*ap;
 5b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ba:	8b 00                	mov    (%eax),%eax
 5bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c7:	75 25                	jne    5ee <printf+0xff>
          s = "(null)";
 5c9:	c7 45 f4 c1 08 00 00 	movl   $0x8c1,-0xc(%ebp)
        while(*s != 0){
 5d0:	eb 1c                	jmp    5ee <printf+0xff>
          putc(fd, *s);
 5d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d5:	0f b6 00             	movzbl (%eax),%eax
 5d8:	0f be c0             	movsbl %al,%eax
 5db:	83 ec 08             	sub    $0x8,%esp
 5de:	50                   	push   %eax
 5df:	ff 75 08             	pushl  0x8(%ebp)
 5e2:	e8 31 fe ff ff       	call   418 <putc>
 5e7:	83 c4 10             	add    $0x10,%esp
          s++;
 5ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f1:	0f b6 00             	movzbl (%eax),%eax
 5f4:	84 c0                	test   %al,%al
 5f6:	75 da                	jne    5d2 <printf+0xe3>
 5f8:	eb 65                	jmp    65f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fa:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5fe:	75 1d                	jne    61d <printf+0x12e>
        putc(fd, *ap);
 600:	8b 45 e8             	mov    -0x18(%ebp),%eax
 603:	8b 00                	mov    (%eax),%eax
 605:	0f be c0             	movsbl %al,%eax
 608:	83 ec 08             	sub    $0x8,%esp
 60b:	50                   	push   %eax
 60c:	ff 75 08             	pushl  0x8(%ebp)
 60f:	e8 04 fe ff ff       	call   418 <putc>
 614:	83 c4 10             	add    $0x10,%esp
        ap++;
 617:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61b:	eb 42                	jmp    65f <printf+0x170>
      } else if(c == '%'){
 61d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 621:	75 17                	jne    63a <printf+0x14b>
        putc(fd, c);
 623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 626:	0f be c0             	movsbl %al,%eax
 629:	83 ec 08             	sub    $0x8,%esp
 62c:	50                   	push   %eax
 62d:	ff 75 08             	pushl  0x8(%ebp)
 630:	e8 e3 fd ff ff       	call   418 <putc>
 635:	83 c4 10             	add    $0x10,%esp
 638:	eb 25                	jmp    65f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63a:	83 ec 08             	sub    $0x8,%esp
 63d:	6a 25                	push   $0x25
 63f:	ff 75 08             	pushl  0x8(%ebp)
 642:	e8 d1 fd ff ff       	call   418 <putc>
 647:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 64a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64d:	0f be c0             	movsbl %al,%eax
 650:	83 ec 08             	sub    $0x8,%esp
 653:	50                   	push   %eax
 654:	ff 75 08             	pushl  0x8(%ebp)
 657:	e8 bc fd ff ff       	call   418 <putc>
 65c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 65f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 666:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 66a:	8b 55 0c             	mov    0xc(%ebp),%edx
 66d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 670:	01 d0                	add    %edx,%eax
 672:	0f b6 00             	movzbl (%eax),%eax
 675:	84 c0                	test   %al,%al
 677:	0f 85 94 fe ff ff    	jne    511 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 67d:	90                   	nop
 67e:	c9                   	leave  
 67f:	c3                   	ret    

00000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 686:	8b 45 08             	mov    0x8(%ebp),%eax
 689:	83 e8 08             	sub    $0x8,%eax
 68c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68f:	a1 50 0b 00 00       	mov    0xb50,%eax
 694:	89 45 fc             	mov    %eax,-0x4(%ebp)
 697:	eb 24                	jmp    6bd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a1:	77 12                	ja     6b5 <free+0x35>
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a9:	77 24                	ja     6cf <free+0x4f>
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b3:	77 1a                	ja     6cf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c3:	76 d4                	jbe    699 <free+0x19>
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6cd:	76 ca                	jbe    699 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	8b 40 04             	mov    0x4(%eax),%eax
 6d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	01 c2                	add    %eax,%edx
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	39 c2                	cmp    %eax,%edx
 6e8:	75 24                	jne    70e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	8b 50 04             	mov    0x4(%eax),%edx
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	8b 40 04             	mov    0x4(%eax),%eax
 6f8:	01 c2                	add    %eax,%edx
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	8b 10                	mov    (%eax),%edx
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	89 10                	mov    %edx,(%eax)
 70c:	eb 0a                	jmp    718 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 10                	mov    (%eax),%edx
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 40 04             	mov    0x4(%eax),%eax
 71e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	01 d0                	add    %edx,%eax
 72a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72d:	75 20                	jne    74f <free+0xcf>
    p->s.size += bp->s.size;
 72f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 732:	8b 50 04             	mov    0x4(%eax),%edx
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	8b 40 04             	mov    0x4(%eax),%eax
 73b:	01 c2                	add    %eax,%edx
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	8b 10                	mov    (%eax),%edx
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	89 10                	mov    %edx,(%eax)
 74d:	eb 08                	jmp    757 <free+0xd7>
  } else
    p->s.ptr = bp;
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 55 f8             	mov    -0x8(%ebp),%edx
 755:	89 10                	mov    %edx,(%eax)
  freep = p;
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	a3 50 0b 00 00       	mov    %eax,0xb50
}
 75f:	90                   	nop
 760:	c9                   	leave  
 761:	c3                   	ret    

00000762 <morecore>:

static Header*
morecore(uint nu)
{
 762:	55                   	push   %ebp
 763:	89 e5                	mov    %esp,%ebp
 765:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 768:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 76f:	77 07                	ja     778 <morecore+0x16>
    nu = 4096;
 771:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 778:	8b 45 08             	mov    0x8(%ebp),%eax
 77b:	c1 e0 03             	shl    $0x3,%eax
 77e:	83 ec 0c             	sub    $0xc,%esp
 781:	50                   	push   %eax
 782:	e8 19 fc ff ff       	call   3a0 <sbrk>
 787:	83 c4 10             	add    $0x10,%esp
 78a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 78d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 791:	75 07                	jne    79a <morecore+0x38>
    return 0;
 793:	b8 00 00 00 00       	mov    $0x0,%eax
 798:	eb 26                	jmp    7c0 <morecore+0x5e>
  hp = (Header*)p;
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	8b 55 08             	mov    0x8(%ebp),%edx
 7a6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	83 c0 08             	add    $0x8,%eax
 7af:	83 ec 0c             	sub    $0xc,%esp
 7b2:	50                   	push   %eax
 7b3:	e8 c8 fe ff ff       	call   680 <free>
 7b8:	83 c4 10             	add    $0x10,%esp
  return freep;
 7bb:	a1 50 0b 00 00       	mov    0xb50,%eax
}
 7c0:	c9                   	leave  
 7c1:	c3                   	ret    

000007c2 <malloc>:

void*
malloc(uint nbytes)
{
 7c2:	55                   	push   %ebp
 7c3:	89 e5                	mov    %esp,%ebp
 7c5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c8:	8b 45 08             	mov    0x8(%ebp),%eax
 7cb:	83 c0 07             	add    $0x7,%eax
 7ce:	c1 e8 03             	shr    $0x3,%eax
 7d1:	83 c0 01             	add    $0x1,%eax
 7d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d7:	a1 50 0b 00 00       	mov    0xb50,%eax
 7dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e3:	75 23                	jne    808 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e5:	c7 45 f0 48 0b 00 00 	movl   $0xb48,-0x10(%ebp)
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	a3 50 0b 00 00       	mov    %eax,0xb50
 7f4:	a1 50 0b 00 00       	mov    0xb50,%eax
 7f9:	a3 48 0b 00 00       	mov    %eax,0xb48
    base.s.size = 0;
 7fe:	c7 05 4c 0b 00 00 00 	movl   $0x0,0xb4c
 805:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80b:	8b 00                	mov    (%eax),%eax
 80d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 819:	72 4d                	jb     868 <malloc+0xa6>
      if(p->s.size == nunits)
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	8b 40 04             	mov    0x4(%eax),%eax
 821:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 824:	75 0c                	jne    832 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	8b 10                	mov    (%eax),%edx
 82b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82e:	89 10                	mov    %edx,(%eax)
 830:	eb 26                	jmp    858 <malloc+0x96>
      else {
        p->s.size -= nunits;
 832:	8b 45 f4             	mov    -0xc(%ebp),%eax
 835:	8b 40 04             	mov    0x4(%eax),%eax
 838:	2b 45 ec             	sub    -0x14(%ebp),%eax
 83b:	89 c2                	mov    %eax,%edx
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	8b 40 04             	mov    0x4(%eax),%eax
 849:	c1 e0 03             	shl    $0x3,%eax
 84c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	8b 55 ec             	mov    -0x14(%ebp),%edx
 855:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 858:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85b:	a3 50 0b 00 00       	mov    %eax,0xb50
      return (void*)(p + 1);
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	83 c0 08             	add    $0x8,%eax
 866:	eb 3b                	jmp    8a3 <malloc+0xe1>
    }
    if(p == freep)
 868:	a1 50 0b 00 00       	mov    0xb50,%eax
 86d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 870:	75 1e                	jne    890 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 872:	83 ec 0c             	sub    $0xc,%esp
 875:	ff 75 ec             	pushl  -0x14(%ebp)
 878:	e8 e5 fe ff ff       	call   762 <morecore>
 87d:	83 c4 10             	add    $0x10,%esp
 880:	89 45 f4             	mov    %eax,-0xc(%ebp)
 883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 887:	75 07                	jne    890 <malloc+0xce>
        return 0;
 889:	b8 00 00 00 00       	mov    $0x0,%eax
 88e:	eb 13                	jmp    8a3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	89 45 f0             	mov    %eax,-0x10(%ebp)
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	8b 00                	mov    (%eax),%eax
 89b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 89e:	e9 6d ff ff ff       	jmp    810 <malloc+0x4e>
}
 8a3:	c9                   	leave  
 8a4:	c3                   	ret    
