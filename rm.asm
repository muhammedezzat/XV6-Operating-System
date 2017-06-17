
_rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: rm files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 02 09 00 00       	push   $0x902
  21:	6a 02                	push   $0x2
  23:	e8 24 05 00 00       	call   54c <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 45 03 00 00       	call   375 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(unlink(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 72 03 00 00       	call   3c5 <unlink>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 16 09 00 00       	push   $0x916
  74:	6a 02                	push   $0x2
  76:	e8 d1 04 00 00       	call   54c <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  8b:	e8 e5 02 00 00       	call   375 <exit>

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	90                   	nop
  b2:	5b                   	pop    %ebx
  b3:	5f                   	pop    %edi
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c2:	90                   	nop
  c3:	8b 45 08             	mov    0x8(%ebp),%eax
  c6:	8d 50 01             	lea    0x1(%eax),%edx
  c9:	89 55 08             	mov    %edx,0x8(%ebp)
  cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  d2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d5:	0f b6 12             	movzbl (%edx),%edx
  d8:	88 10                	mov    %dl,(%eax)
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	75 e2                	jne    c3 <strcpy+0xd>
    ;
  return os;
  e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e4:	c9                   	leave  
  e5:	c3                   	ret    

000000e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e9:	eb 08                	jmp    f3 <strcmp+0xd>
    p++, q++;
  eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	84 c0                	test   %al,%al
  fb:	74 10                	je     10d <strcmp+0x27>
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 10             	movzbl (%eax),%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	38 c2                	cmp    %al,%dl
 10b:	74 de                	je     eb <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	0f b6 d0             	movzbl %al,%edx
 116:	8b 45 0c             	mov    0xc(%ebp),%eax
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	0f b6 c0             	movzbl %al,%eax
 11f:	29 c2                	sub    %eax,%edx
 121:	89 d0                	mov    %edx,%eax
}
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <strlen>:

uint
strlen(char *s)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 132:	eb 04                	jmp    138 <strlen+0x13>
 134:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 138:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	01 d0                	add    %edx,%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	84 c0                	test   %al,%al
 145:	75 ed                	jne    134 <strlen+0xf>
    ;
  return n;
 147:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14a:	c9                   	leave  
 14b:	c3                   	ret    

0000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14f:	8b 45 10             	mov    0x10(%ebp),%eax
 152:	50                   	push   %eax
 153:	ff 75 0c             	pushl  0xc(%ebp)
 156:	ff 75 08             	pushl  0x8(%ebp)
 159:	e8 32 ff ff ff       	call   90 <stosb>
 15e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 14                	jmp    188 <strchr+0x22>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17d:	75 05                	jne    184 <strchr+0x1e>
      return (char*)s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	eb 13                	jmp    197 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 e2                	jne    174 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 192:	b8 00 00 00 00       	mov    $0x0,%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <gets>:

char*
gets(char *buf, int max)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a6:	eb 42                	jmp    1ea <gets+0x51>
    cc = read(0, &c, 1);
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	6a 01                	push   $0x1
 1ad:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b0:	50                   	push   %eax
 1b1:	6a 00                	push   $0x0
 1b3:	e8 d5 01 00 00       	call   38d <read>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c2:	7e 33                	jle    1f7 <gets+0x5e>
      break;
    buf[i++] = c;
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	8d 50 01             	lea    0x1(%eax),%edx
 1ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cd:	89 c2                	mov    %eax,%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 c2                	add    %eax,%edx
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0a                	cmp    $0xa,%al
 1e0:	74 16                	je     1f8 <gets+0x5f>
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	3c 0d                	cmp    $0xd,%al
 1e8:	74 0e                	je     1f8 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f3:	7c b3                	jl     1a8 <gets+0xf>
 1f5:	eb 01                	jmp    1f8 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f7:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <stat>:

int
stat(char *n, struct stat *st)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	83 ec 08             	sub    $0x8,%esp
 211:	6a 00                	push   $0x0
 213:	ff 75 08             	pushl  0x8(%ebp)
 216:	e8 9a 01 00 00       	call   3b5 <open>
 21b:	83 c4 10             	add    $0x10,%esp
 21e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 225:	79 07                	jns    22e <stat+0x26>
    return -1;
 227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22c:	eb 25                	jmp    253 <stat+0x4b>
  r = fstat(fd, st);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	ff 75 0c             	pushl  0xc(%ebp)
 234:	ff 75 f4             	pushl  -0xc(%ebp)
 237:	e8 91 01 00 00       	call   3cd <fstat>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 242:	83 ec 0c             	sub    $0xc,%esp
 245:	ff 75 f4             	pushl  -0xc(%ebp)
 248:	e8 50 01 00 00       	call   39d <close>
 24d:	83 c4 10             	add    $0x10,%esp
  return r;
 250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 253:	c9                   	leave  
 254:	c3                   	ret    

00000255 <atoi>:

int
atoi(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 262:	eb 25                	jmp    289 <atoi+0x34>
    n = n*10 + *s++ - '0';
 264:	8b 55 fc             	mov    -0x4(%ebp),%edx
 267:	89 d0                	mov    %edx,%eax
 269:	c1 e0 02             	shl    $0x2,%eax
 26c:	01 d0                	add    %edx,%eax
 26e:	01 c0                	add    %eax,%eax
 270:	89 c1                	mov    %eax,%ecx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	8d 50 01             	lea    0x1(%eax),%edx
 278:	89 55 08             	mov    %edx,0x8(%ebp)
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	0f be c0             	movsbl %al,%eax
 281:	01 c8                	add    %ecx,%eax
 283:	83 e8 30             	sub    $0x30,%eax
 286:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2f                	cmp    $0x2f,%al
 291:	7e 0a                	jle    29d <atoi+0x48>
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 39                	cmp    $0x39,%al
 29b:	7e c7                	jle    264 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b4:	eb 17                	jmp    2cd <memmove+0x2b>
    *dst++ = *src++;
 2b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b9:	8d 50 01             	lea    0x1(%eax),%edx
 2bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c2:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c8:	0f b6 12             	movzbl (%edx),%edx
 2cb:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2cd:	8b 45 10             	mov    0x10(%ebp),%eax
 2d0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d3:	89 55 10             	mov    %edx,0x10(%ebp)
 2d6:	85 c0                	test   %eax,%eax
 2d8:	7f dc                	jg     2b6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <atoo>:

int
atoo(const char *s)
{
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2ec:	eb 04                	jmp    2f2 <atoo+0x13>
 2ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	0f b6 00             	movzbl (%eax),%eax
 2f8:	3c 20                	cmp    $0x20,%al
 2fa:	74 f2                	je     2ee <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 00             	movzbl (%eax),%eax
 302:	3c 2d                	cmp    $0x2d,%al
 304:	75 07                	jne    30d <atoo+0x2e>
 306:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 30b:	eb 05                	jmp    312 <atoo+0x33>
 30d:	b8 01 00 00 00       	mov    $0x1,%eax
 312:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	3c 2b                	cmp    $0x2b,%al
 31d:	74 0a                	je     329 <atoo+0x4a>
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	3c 2d                	cmp    $0x2d,%al
 327:	75 27                	jne    350 <atoo+0x71>
    s++;
 329:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 32d:	eb 21                	jmp    350 <atoo+0x71>
    n = n*8 + *s++ - '0';
 32f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 332:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	8d 50 01             	lea    0x1(%eax),%edx
 33f:	89 55 08             	mov    %edx,0x8(%ebp)
 342:	0f b6 00             	movzbl (%eax),%eax
 345:	0f be c0             	movsbl %al,%eax
 348:	01 c8                	add    %ecx,%eax
 34a:	83 e8 30             	sub    $0x30,%eax
 34d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	0f b6 00             	movzbl (%eax),%eax
 356:	3c 2f                	cmp    $0x2f,%al
 358:	7e 0a                	jle    364 <atoo+0x85>
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	0f b6 00             	movzbl (%eax),%eax
 360:	3c 37                	cmp    $0x37,%al
 362:	7e cb                	jle    32f <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 364:	8b 45 f8             	mov    -0x8(%ebp),%eax
 367:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 36b:	c9                   	leave  
 36c:	c3                   	ret    

0000036d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36d:	b8 01 00 00 00       	mov    $0x1,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <exit>:
SYSCALL(exit)
 375:	b8 02 00 00 00       	mov    $0x2,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <wait>:
SYSCALL(wait)
 37d:	b8 03 00 00 00       	mov    $0x3,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <pipe>:
SYSCALL(pipe)
 385:	b8 04 00 00 00       	mov    $0x4,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <read>:
SYSCALL(read)
 38d:	b8 05 00 00 00       	mov    $0x5,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <write>:
SYSCALL(write)
 395:	b8 10 00 00 00       	mov    $0x10,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <close>:
SYSCALL(close)
 39d:	b8 15 00 00 00       	mov    $0x15,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <kill>:
SYSCALL(kill)
 3a5:	b8 06 00 00 00       	mov    $0x6,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <exec>:
SYSCALL(exec)
 3ad:	b8 07 00 00 00       	mov    $0x7,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <open>:
SYSCALL(open)
 3b5:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <mknod>:
SYSCALL(mknod)
 3bd:	b8 11 00 00 00       	mov    $0x11,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <unlink>:
SYSCALL(unlink)
 3c5:	b8 12 00 00 00       	mov    $0x12,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <fstat>:
SYSCALL(fstat)
 3cd:	b8 08 00 00 00       	mov    $0x8,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <link>:
SYSCALL(link)
 3d5:	b8 13 00 00 00       	mov    $0x13,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <mkdir>:
SYSCALL(mkdir)
 3dd:	b8 14 00 00 00       	mov    $0x14,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <chdir>:
SYSCALL(chdir)
 3e5:	b8 09 00 00 00       	mov    $0x9,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <dup>:
SYSCALL(dup)
 3ed:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <getpid>:
SYSCALL(getpid)
 3f5:	b8 0b 00 00 00       	mov    $0xb,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <sbrk>:
SYSCALL(sbrk)
 3fd:	b8 0c 00 00 00       	mov    $0xc,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <sleep>:
SYSCALL(sleep)
 405:	b8 0d 00 00 00       	mov    $0xd,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <uptime>:
SYSCALL(uptime)
 40d:	b8 0e 00 00 00       	mov    $0xe,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <halt>:
SYSCALL(halt)
 415:	b8 16 00 00 00       	mov    $0x16,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 41d:	b8 17 00 00 00       	mov    $0x17,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 425:	b8 18 00 00 00       	mov    $0x18,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 42d:	b8 19 00 00 00       	mov    $0x19,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 435:	b8 1a 00 00 00       	mov    $0x1a,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 43d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 445:	b8 1c 00 00 00       	mov    $0x1c,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 44d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 455:	b8 1e 00 00 00       	mov    $0x1e,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 45d:	b8 1f 00 00 00       	mov    $0x1f,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 465:	b8 20 00 00 00       	mov    $0x20,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 46d:	b8 21 00 00 00       	mov    $0x21,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 475:	55                   	push   %ebp
 476:	89 e5                	mov    %esp,%ebp
 478:	83 ec 18             	sub    $0x18,%esp
 47b:	8b 45 0c             	mov    0xc(%ebp),%eax
 47e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 481:	83 ec 04             	sub    $0x4,%esp
 484:	6a 01                	push   $0x1
 486:	8d 45 f4             	lea    -0xc(%ebp),%eax
 489:	50                   	push   %eax
 48a:	ff 75 08             	pushl  0x8(%ebp)
 48d:	e8 03 ff ff ff       	call   395 <write>
 492:	83 c4 10             	add    $0x10,%esp
}
 495:	90                   	nop
 496:	c9                   	leave  
 497:	c3                   	ret    

00000498 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 498:	55                   	push   %ebp
 499:	89 e5                	mov    %esp,%ebp
 49b:	53                   	push   %ebx
 49c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 49f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4a6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4aa:	74 17                	je     4c3 <printint+0x2b>
 4ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b0:	79 11                	jns    4c3 <printint+0x2b>
    neg = 1;
 4b2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bc:	f7 d8                	neg    %eax
 4be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c1:	eb 06                	jmp    4c9 <printint+0x31>
  } else {
    x = xx;
 4c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4d3:	8d 41 01             	lea    0x1(%ecx),%eax
 4d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4df:	ba 00 00 00 00       	mov    $0x0,%edx
 4e4:	f7 f3                	div    %ebx
 4e6:	89 d0                	mov    %edx,%eax
 4e8:	0f b6 80 a4 0b 00 00 	movzbl 0xba4(%eax),%eax
 4ef:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f9:	ba 00 00 00 00       	mov    $0x0,%edx
 4fe:	f7 f3                	div    %ebx
 500:	89 45 ec             	mov    %eax,-0x14(%ebp)
 503:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 507:	75 c7                	jne    4d0 <printint+0x38>
  if(neg)
 509:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 50d:	74 2d                	je     53c <printint+0xa4>
    buf[i++] = '-';
 50f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 512:	8d 50 01             	lea    0x1(%eax),%edx
 515:	89 55 f4             	mov    %edx,-0xc(%ebp)
 518:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 51d:	eb 1d                	jmp    53c <printint+0xa4>
    putc(fd, buf[i]);
 51f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 522:	8b 45 f4             	mov    -0xc(%ebp),%eax
 525:	01 d0                	add    %edx,%eax
 527:	0f b6 00             	movzbl (%eax),%eax
 52a:	0f be c0             	movsbl %al,%eax
 52d:	83 ec 08             	sub    $0x8,%esp
 530:	50                   	push   %eax
 531:	ff 75 08             	pushl  0x8(%ebp)
 534:	e8 3c ff ff ff       	call   475 <putc>
 539:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 53c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 544:	79 d9                	jns    51f <printint+0x87>
    putc(fd, buf[i]);
}
 546:	90                   	nop
 547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 54a:	c9                   	leave  
 54b:	c3                   	ret    

0000054c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 54c:	55                   	push   %ebp
 54d:	89 e5                	mov    %esp,%ebp
 54f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 552:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 559:	8d 45 0c             	lea    0xc(%ebp),%eax
 55c:	83 c0 04             	add    $0x4,%eax
 55f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 562:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 569:	e9 59 01 00 00       	jmp    6c7 <printf+0x17b>
    c = fmt[i] & 0xff;
 56e:	8b 55 0c             	mov    0xc(%ebp),%edx
 571:	8b 45 f0             	mov    -0x10(%ebp),%eax
 574:	01 d0                	add    %edx,%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	25 ff 00 00 00       	and    $0xff,%eax
 581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 584:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 588:	75 2c                	jne    5b6 <printf+0x6a>
      if(c == '%'){
 58a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58e:	75 0c                	jne    59c <printf+0x50>
        state = '%';
 590:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 597:	e9 27 01 00 00       	jmp    6c3 <printf+0x177>
      } else {
        putc(fd, c);
 59c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59f:	0f be c0             	movsbl %al,%eax
 5a2:	83 ec 08             	sub    $0x8,%esp
 5a5:	50                   	push   %eax
 5a6:	ff 75 08             	pushl  0x8(%ebp)
 5a9:	e8 c7 fe ff ff       	call   475 <putc>
 5ae:	83 c4 10             	add    $0x10,%esp
 5b1:	e9 0d 01 00 00       	jmp    6c3 <printf+0x177>
      }
    } else if(state == '%'){
 5b6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ba:	0f 85 03 01 00 00    	jne    6c3 <printf+0x177>
      if(c == 'd'){
 5c0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5c4:	75 1e                	jne    5e4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c9:	8b 00                	mov    (%eax),%eax
 5cb:	6a 01                	push   $0x1
 5cd:	6a 0a                	push   $0xa
 5cf:	50                   	push   %eax
 5d0:	ff 75 08             	pushl  0x8(%ebp)
 5d3:	e8 c0 fe ff ff       	call   498 <printint>
 5d8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5df:	e9 d8 00 00 00       	jmp    6bc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5e4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e8:	74 06                	je     5f0 <printf+0xa4>
 5ea:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ee:	75 1e                	jne    60e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f3:	8b 00                	mov    (%eax),%eax
 5f5:	6a 00                	push   $0x0
 5f7:	6a 10                	push   $0x10
 5f9:	50                   	push   %eax
 5fa:	ff 75 08             	pushl  0x8(%ebp)
 5fd:	e8 96 fe ff ff       	call   498 <printint>
 602:	83 c4 10             	add    $0x10,%esp
        ap++;
 605:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 609:	e9 ae 00 00 00       	jmp    6bc <printf+0x170>
      } else if(c == 's'){
 60e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 612:	75 43                	jne    657 <printf+0x10b>
        s = (char*)*ap;
 614:	8b 45 e8             	mov    -0x18(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 624:	75 25                	jne    64b <printf+0xff>
          s = "(null)";
 626:	c7 45 f4 2f 09 00 00 	movl   $0x92f,-0xc(%ebp)
        while(*s != 0){
 62d:	eb 1c                	jmp    64b <printf+0xff>
          putc(fd, *s);
 62f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 632:	0f b6 00             	movzbl (%eax),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	83 ec 08             	sub    $0x8,%esp
 63b:	50                   	push   %eax
 63c:	ff 75 08             	pushl  0x8(%ebp)
 63f:	e8 31 fe ff ff       	call   475 <putc>
 644:	83 c4 10             	add    $0x10,%esp
          s++;
 647:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64e:	0f b6 00             	movzbl (%eax),%eax
 651:	84 c0                	test   %al,%al
 653:	75 da                	jne    62f <printf+0xe3>
 655:	eb 65                	jmp    6bc <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 657:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 65b:	75 1d                	jne    67a <printf+0x12e>
        putc(fd, *ap);
 65d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	0f be c0             	movsbl %al,%eax
 665:	83 ec 08             	sub    $0x8,%esp
 668:	50                   	push   %eax
 669:	ff 75 08             	pushl  0x8(%ebp)
 66c:	e8 04 fe ff ff       	call   475 <putc>
 671:	83 c4 10             	add    $0x10,%esp
        ap++;
 674:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 678:	eb 42                	jmp    6bc <printf+0x170>
      } else if(c == '%'){
 67a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 67e:	75 17                	jne    697 <printf+0x14b>
        putc(fd, c);
 680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	83 ec 08             	sub    $0x8,%esp
 689:	50                   	push   %eax
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 e3 fd ff ff       	call   475 <putc>
 692:	83 c4 10             	add    $0x10,%esp
 695:	eb 25                	jmp    6bc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 697:	83 ec 08             	sub    $0x8,%esp
 69a:	6a 25                	push   $0x25
 69c:	ff 75 08             	pushl  0x8(%ebp)
 69f:	e8 d1 fd ff ff       	call   475 <putc>
 6a4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6aa:	0f be c0             	movsbl %al,%eax
 6ad:	83 ec 08             	sub    $0x8,%esp
 6b0:	50                   	push   %eax
 6b1:	ff 75 08             	pushl  0x8(%ebp)
 6b4:	e8 bc fd ff ff       	call   475 <putc>
 6b9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c7:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cd:	01 d0                	add    %edx,%eax
 6cf:	0f b6 00             	movzbl (%eax),%eax
 6d2:	84 c0                	test   %al,%al
 6d4:	0f 85 94 fe ff ff    	jne    56e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6da:	90                   	nop
 6db:	c9                   	leave  
 6dc:	c3                   	ret    

000006dd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6dd:	55                   	push   %ebp
 6de:	89 e5                	mov    %esp,%ebp
 6e0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	83 e8 08             	sub    $0x8,%eax
 6e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ec:	a1 c0 0b 00 00       	mov    0xbc0,%eax
 6f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f4:	eb 24                	jmp    71a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 00                	mov    (%eax),%eax
 6fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fe:	77 12                	ja     712 <free+0x35>
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 706:	77 24                	ja     72c <free+0x4f>
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 710:	77 1a                	ja     72c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	8b 00                	mov    (%eax),%eax
 717:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 720:	76 d4                	jbe    6f6 <free+0x19>
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 00                	mov    (%eax),%eax
 727:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72a:	76 ca                	jbe    6f6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	8b 40 04             	mov    0x4(%eax),%eax
 732:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 739:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73c:	01 c2                	add    %eax,%edx
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 00                	mov    (%eax),%eax
 743:	39 c2                	cmp    %eax,%edx
 745:	75 24                	jne    76b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	8b 50 04             	mov    0x4(%eax),%edx
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	8b 40 04             	mov    0x4(%eax),%eax
 755:	01 c2                	add    %eax,%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	8b 10                	mov    (%eax),%edx
 764:	8b 45 f8             	mov    -0x8(%ebp),%eax
 767:	89 10                	mov    %edx,(%eax)
 769:	eb 0a                	jmp    775 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	8b 10                	mov    (%eax),%edx
 770:	8b 45 f8             	mov    -0x8(%ebp),%eax
 773:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 40 04             	mov    0x4(%eax),%eax
 77b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	01 d0                	add    %edx,%eax
 787:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78a:	75 20                	jne    7ac <free+0xcf>
    p->s.size += bp->s.size;
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 50 04             	mov    0x4(%eax),%edx
 792:	8b 45 f8             	mov    -0x8(%ebp),%eax
 795:	8b 40 04             	mov    0x4(%eax),%eax
 798:	01 c2                	add    %eax,%edx
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a3:	8b 10                	mov    (%eax),%edx
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	89 10                	mov    %edx,(%eax)
 7aa:	eb 08                	jmp    7b4 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b2:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	a3 c0 0b 00 00       	mov    %eax,0xbc0
}
 7bc:	90                   	nop
 7bd:	c9                   	leave  
 7be:	c3                   	ret    

000007bf <morecore>:

static Header*
morecore(uint nu)
{
 7bf:	55                   	push   %ebp
 7c0:	89 e5                	mov    %esp,%ebp
 7c2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7cc:	77 07                	ja     7d5 <morecore+0x16>
    nu = 4096;
 7ce:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d5:	8b 45 08             	mov    0x8(%ebp),%eax
 7d8:	c1 e0 03             	shl    $0x3,%eax
 7db:	83 ec 0c             	sub    $0xc,%esp
 7de:	50                   	push   %eax
 7df:	e8 19 fc ff ff       	call   3fd <sbrk>
 7e4:	83 c4 10             	add    $0x10,%esp
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ea:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ee:	75 07                	jne    7f7 <morecore+0x38>
    return 0;
 7f0:	b8 00 00 00 00       	mov    $0x0,%eax
 7f5:	eb 26                	jmp    81d <morecore+0x5e>
  hp = (Header*)p;
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	8b 55 08             	mov    0x8(%ebp),%edx
 803:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 806:	8b 45 f0             	mov    -0x10(%ebp),%eax
 809:	83 c0 08             	add    $0x8,%eax
 80c:	83 ec 0c             	sub    $0xc,%esp
 80f:	50                   	push   %eax
 810:	e8 c8 fe ff ff       	call   6dd <free>
 815:	83 c4 10             	add    $0x10,%esp
  return freep;
 818:	a1 c0 0b 00 00       	mov    0xbc0,%eax
}
 81d:	c9                   	leave  
 81e:	c3                   	ret    

0000081f <malloc>:

void*
malloc(uint nbytes)
{
 81f:	55                   	push   %ebp
 820:	89 e5                	mov    %esp,%ebp
 822:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 825:	8b 45 08             	mov    0x8(%ebp),%eax
 828:	83 c0 07             	add    $0x7,%eax
 82b:	c1 e8 03             	shr    $0x3,%eax
 82e:	83 c0 01             	add    $0x1,%eax
 831:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 834:	a1 c0 0b 00 00       	mov    0xbc0,%eax
 839:	89 45 f0             	mov    %eax,-0x10(%ebp)
 83c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 840:	75 23                	jne    865 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 842:	c7 45 f0 b8 0b 00 00 	movl   $0xbb8,-0x10(%ebp)
 849:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84c:	a3 c0 0b 00 00       	mov    %eax,0xbc0
 851:	a1 c0 0b 00 00       	mov    0xbc0,%eax
 856:	a3 b8 0b 00 00       	mov    %eax,0xbb8
    base.s.size = 0;
 85b:	c7 05 bc 0b 00 00 00 	movl   $0x0,0xbbc
 862:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 865:	8b 45 f0             	mov    -0x10(%ebp),%eax
 868:	8b 00                	mov    (%eax),%eax
 86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	8b 40 04             	mov    0x4(%eax),%eax
 873:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 876:	72 4d                	jb     8c5 <malloc+0xa6>
      if(p->s.size == nunits)
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	8b 40 04             	mov    0x4(%eax),%eax
 87e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 881:	75 0c                	jne    88f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	8b 10                	mov    (%eax),%edx
 888:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88b:	89 10                	mov    %edx,(%eax)
 88d:	eb 26                	jmp    8b5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	2b 45 ec             	sub    -0x14(%ebp),%eax
 898:	89 c2                	mov    %eax,%edx
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	8b 40 04             	mov    0x4(%eax),%eax
 8a6:	c1 e0 03             	shl    $0x3,%eax
 8a9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8b2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b8:	a3 c0 0b 00 00       	mov    %eax,0xbc0
      return (void*)(p + 1);
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	83 c0 08             	add    $0x8,%eax
 8c3:	eb 3b                	jmp    900 <malloc+0xe1>
    }
    if(p == freep)
 8c5:	a1 c0 0b 00 00       	mov    0xbc0,%eax
 8ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8cd:	75 1e                	jne    8ed <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8cf:	83 ec 0c             	sub    $0xc,%esp
 8d2:	ff 75 ec             	pushl  -0x14(%ebp)
 8d5:	e8 e5 fe ff ff       	call   7bf <morecore>
 8da:	83 c4 10             	add    $0x10,%esp
 8dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e4:	75 07                	jne    8ed <malloc+0xce>
        return 0;
 8e6:	b8 00 00 00 00       	mov    $0x0,%eax
 8eb:	eb 13                	jmp    900 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	8b 00                	mov    (%eax),%eax
 8f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8fb:	e9 6d ff ff ff       	jmp    86d <malloc+0x4e>
}
 900:	c9                   	leave  
 901:	c3                   	ret    
