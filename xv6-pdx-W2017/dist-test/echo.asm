
_echo:     file format elf32-i386


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

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba d7 08 00 00       	mov    $0x8d7,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba d9 08 00 00       	mov    $0x8d9,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 db 08 00 00       	push   $0x8db
  4b:	6a 01                	push   $0x1
  4d:	e8 cf 04 00 00       	call   521 <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 e5 02 00 00       	call   34a <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	90                   	nop
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	8d 50 01             	lea    0x1(%eax),%edx
  9e:	89 55 08             	mov    %edx,0x8(%ebp)
  a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	88 10                	mov    %dl,(%eax)
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 08                	jmp    c8 <strcmp+0xd>
    p++, q++;
  c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	74 10                	je     e2 <strcmp+0x27>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 10             	movzbl (%eax),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	38 c2                	cmp    %al,%dl
  e0:	74 de                	je     c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	29 c2                	sub    %eax,%edx
  f6:	89 d0                	mov    %edx,%eax
}
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strlen>:

uint
strlen(char *s)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 107:	eb 04                	jmp    10d <strlen+0x13>
 109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 ed                	jne    109 <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	pushl  0xc(%ebp)
 12b:	ff 75 08             	pushl  0x8(%ebp)
 12e:	e8 32 ff ff ff       	call   65 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 14                	jmp    15d <strchr+0x22>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 152:	75 05                	jne    159 <strchr+0x1e>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 13                	jmp    16c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 d5 01 00 00       	call   362 <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7e 33                	jle    1cc <gets+0x5e>
      break;
    buf[i++] = c;
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	8d 50 01             	lea    0x1(%eax),%edx
 19f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a2:	89 c2                	mov    %eax,%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 16                	je     1cd <gets+0x5f>
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0e                	je     1cd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	83 c0 01             	add    $0x1,%eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b3                	jl     17d <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	pushl  0x8(%ebp)
 1eb:	e8 9a 01 00 00       	call   38a <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x26>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4b>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 f4             	pushl  -0xc(%ebp)
 20c:	e8 91 01 00 00       	call   3a2 <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	pushl  -0xc(%ebp)
 21d:	e8 50 01 00 00       	call   372 <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 237:	eb 25                	jmp    25e <atoi+0x34>
    n = n*10 + *s++ - '0';
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	89 d0                	mov    %edx,%eax
 23e:	c1 e0 02             	shl    $0x2,%eax
 241:	01 d0                	add    %edx,%eax
 243:	01 c0                	add    %eax,%eax
 245:	89 c1                	mov    %eax,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 08             	mov    %edx,0x8(%ebp)
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 0a                	jle    272 <atoi+0x48>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 39                	cmp    $0x39,%al
 270:	7e c7                	jle    239 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 289:	eb 17                	jmp    2a2 <memmove+0x2b>
    *dst++ = *src++;
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28e:	8d 50 01             	lea    0x1(%eax),%edx
 291:	89 55 fc             	mov    %edx,-0x4(%ebp)
 294:	8b 55 f8             	mov    -0x8(%ebp),%edx
 297:	8d 4a 01             	lea    0x1(%edx),%ecx
 29a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 29d:	0f b6 12             	movzbl (%edx),%edx
 2a0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a8:	89 55 10             	mov    %edx,0x10(%ebp)
 2ab:	85 c0                	test   %eax,%eax
 2ad:	7f dc                	jg     28b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <atoo>:

int
atoo(const char *s)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2c1:	eb 04                	jmp    2c7 <atoo+0x13>
 2c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	0f b6 00             	movzbl (%eax),%eax
 2cd:	3c 20                	cmp    $0x20,%al
 2cf:	74 f2                	je     2c3 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 00             	movzbl (%eax),%eax
 2d7:	3c 2d                	cmp    $0x2d,%al
 2d9:	75 07                	jne    2e2 <atoo+0x2e>
 2db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e0:	eb 05                	jmp    2e7 <atoo+0x33>
 2e2:	b8 01 00 00 00       	mov    $0x1,%eax
 2e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	0f b6 00             	movzbl (%eax),%eax
 2f0:	3c 2b                	cmp    $0x2b,%al
 2f2:	74 0a                	je     2fe <atoo+0x4a>
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	0f b6 00             	movzbl (%eax),%eax
 2fa:	3c 2d                	cmp    $0x2d,%al
 2fc:	75 27                	jne    325 <atoo+0x71>
    s++;
 2fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 302:	eb 21                	jmp    325 <atoo+0x71>
    n = n*8 + *s++ - '0';
 304:	8b 45 fc             	mov    -0x4(%ebp),%eax
 307:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
 311:	8d 50 01             	lea    0x1(%eax),%edx
 314:	89 55 08             	mov    %edx,0x8(%ebp)
 317:	0f b6 00             	movzbl (%eax),%eax
 31a:	0f be c0             	movsbl %al,%eax
 31d:	01 c8                	add    %ecx,%eax
 31f:	83 e8 30             	sub    $0x30,%eax
 322:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 325:	8b 45 08             	mov    0x8(%ebp),%eax
 328:	0f b6 00             	movzbl (%eax),%eax
 32b:	3c 2f                	cmp    $0x2f,%al
 32d:	7e 0a                	jle    339 <atoo+0x85>
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	0f b6 00             	movzbl (%eax),%eax
 335:	3c 37                	cmp    $0x37,%al
 337:	7e cb                	jle    304 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 339:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33c:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 340:	c9                   	leave  
 341:	c3                   	ret    

00000342 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 342:	b8 01 00 00 00       	mov    $0x1,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <exit>:
SYSCALL(exit)
 34a:	b8 02 00 00 00       	mov    $0x2,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <wait>:
SYSCALL(wait)
 352:	b8 03 00 00 00       	mov    $0x3,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <pipe>:
SYSCALL(pipe)
 35a:	b8 04 00 00 00       	mov    $0x4,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <read>:
SYSCALL(read)
 362:	b8 05 00 00 00       	mov    $0x5,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <write>:
SYSCALL(write)
 36a:	b8 10 00 00 00       	mov    $0x10,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <close>:
SYSCALL(close)
 372:	b8 15 00 00 00       	mov    $0x15,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <kill>:
SYSCALL(kill)
 37a:	b8 06 00 00 00       	mov    $0x6,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <exec>:
SYSCALL(exec)
 382:	b8 07 00 00 00       	mov    $0x7,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <open>:
SYSCALL(open)
 38a:	b8 0f 00 00 00       	mov    $0xf,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <mknod>:
SYSCALL(mknod)
 392:	b8 11 00 00 00       	mov    $0x11,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <unlink>:
SYSCALL(unlink)
 39a:	b8 12 00 00 00       	mov    $0x12,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <fstat>:
SYSCALL(fstat)
 3a2:	b8 08 00 00 00       	mov    $0x8,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <link>:
SYSCALL(link)
 3aa:	b8 13 00 00 00       	mov    $0x13,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <mkdir>:
SYSCALL(mkdir)
 3b2:	b8 14 00 00 00       	mov    $0x14,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <chdir>:
SYSCALL(chdir)
 3ba:	b8 09 00 00 00       	mov    $0x9,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <dup>:
SYSCALL(dup)
 3c2:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <getpid>:
SYSCALL(getpid)
 3ca:	b8 0b 00 00 00       	mov    $0xb,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <sbrk>:
SYSCALL(sbrk)
 3d2:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <sleep>:
SYSCALL(sleep)
 3da:	b8 0d 00 00 00       	mov    $0xd,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <uptime>:
SYSCALL(uptime)
 3e2:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <halt>:
SYSCALL(halt)
 3ea:	b8 16 00 00 00       	mov    $0x16,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 3f2:	b8 17 00 00 00       	mov    $0x17,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 3fa:	b8 18 00 00 00       	mov    $0x18,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 402:	b8 19 00 00 00       	mov    $0x19,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 40a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 412:	b8 1b 00 00 00       	mov    $0x1b,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 41a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 422:	b8 1d 00 00 00       	mov    $0x1d,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 42a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 432:	b8 1f 00 00 00       	mov    $0x1f,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 43a:	b8 20 00 00 00       	mov    $0x20,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 442:	b8 21 00 00 00       	mov    $0x21,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 44a:	55                   	push   %ebp
 44b:	89 e5                	mov    %esp,%ebp
 44d:	83 ec 18             	sub    $0x18,%esp
 450:	8b 45 0c             	mov    0xc(%ebp),%eax
 453:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 456:	83 ec 04             	sub    $0x4,%esp
 459:	6a 01                	push   $0x1
 45b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 45e:	50                   	push   %eax
 45f:	ff 75 08             	pushl  0x8(%ebp)
 462:	e8 03 ff ff ff       	call   36a <write>
 467:	83 c4 10             	add    $0x10,%esp
}
 46a:	90                   	nop
 46b:	c9                   	leave  
 46c:	c3                   	ret    

0000046d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46d:	55                   	push   %ebp
 46e:	89 e5                	mov    %esp,%ebp
 470:	53                   	push   %ebx
 471:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 474:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 47b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 47f:	74 17                	je     498 <printint+0x2b>
 481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 485:	79 11                	jns    498 <printint+0x2b>
    neg = 1;
 487:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 48e:	8b 45 0c             	mov    0xc(%ebp),%eax
 491:	f7 d8                	neg    %eax
 493:	89 45 ec             	mov    %eax,-0x14(%ebp)
 496:	eb 06                	jmp    49e <printint+0x31>
  } else {
    x = xx;
 498:	8b 45 0c             	mov    0xc(%ebp),%eax
 49b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 49e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a8:	8d 41 01             	lea    0x1(%ecx),%eax
 4ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b4:	ba 00 00 00 00       	mov    $0x0,%edx
 4b9:	f7 f3                	div    %ebx
 4bb:	89 d0                	mov    %edx,%eax
 4bd:	0f b6 80 54 0b 00 00 	movzbl 0xb54(%eax),%eax
 4c4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ce:	ba 00 00 00 00       	mov    $0x0,%edx
 4d3:	f7 f3                	div    %ebx
 4d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4dc:	75 c7                	jne    4a5 <printint+0x38>
  if(neg)
 4de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e2:	74 2d                	je     511 <printint+0xa4>
    buf[i++] = '-';
 4e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e7:	8d 50 01             	lea    0x1(%eax),%edx
 4ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ed:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4f2:	eb 1d                	jmp    511 <printint+0xa4>
    putc(fd, buf[i]);
 4f4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fa:	01 d0                	add    %edx,%eax
 4fc:	0f b6 00             	movzbl (%eax),%eax
 4ff:	0f be c0             	movsbl %al,%eax
 502:	83 ec 08             	sub    $0x8,%esp
 505:	50                   	push   %eax
 506:	ff 75 08             	pushl  0x8(%ebp)
 509:	e8 3c ff ff ff       	call   44a <putc>
 50e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 511:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 519:	79 d9                	jns    4f4 <printint+0x87>
    putc(fd, buf[i]);
}
 51b:	90                   	nop
 51c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 51f:	c9                   	leave  
 520:	c3                   	ret    

00000521 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 521:	55                   	push   %ebp
 522:	89 e5                	mov    %esp,%ebp
 524:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 527:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52e:	8d 45 0c             	lea    0xc(%ebp),%eax
 531:	83 c0 04             	add    $0x4,%eax
 534:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 537:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53e:	e9 59 01 00 00       	jmp    69c <printf+0x17b>
    c = fmt[i] & 0xff;
 543:	8b 55 0c             	mov    0xc(%ebp),%edx
 546:	8b 45 f0             	mov    -0x10(%ebp),%eax
 549:	01 d0                	add    %edx,%eax
 54b:	0f b6 00             	movzbl (%eax),%eax
 54e:	0f be c0             	movsbl %al,%eax
 551:	25 ff 00 00 00       	and    $0xff,%eax
 556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 559:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55d:	75 2c                	jne    58b <printf+0x6a>
      if(c == '%'){
 55f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 563:	75 0c                	jne    571 <printf+0x50>
        state = '%';
 565:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56c:	e9 27 01 00 00       	jmp    698 <printf+0x177>
      } else {
        putc(fd, c);
 571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 574:	0f be c0             	movsbl %al,%eax
 577:	83 ec 08             	sub    $0x8,%esp
 57a:	50                   	push   %eax
 57b:	ff 75 08             	pushl  0x8(%ebp)
 57e:	e8 c7 fe ff ff       	call   44a <putc>
 583:	83 c4 10             	add    $0x10,%esp
 586:	e9 0d 01 00 00       	jmp    698 <printf+0x177>
      }
    } else if(state == '%'){
 58b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 58f:	0f 85 03 01 00 00    	jne    698 <printf+0x177>
      if(c == 'd'){
 595:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 599:	75 1e                	jne    5b9 <printf+0x98>
        printint(fd, *ap, 10, 1);
 59b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59e:	8b 00                	mov    (%eax),%eax
 5a0:	6a 01                	push   $0x1
 5a2:	6a 0a                	push   $0xa
 5a4:	50                   	push   %eax
 5a5:	ff 75 08             	pushl  0x8(%ebp)
 5a8:	e8 c0 fe ff ff       	call   46d <printint>
 5ad:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b4:	e9 d8 00 00 00       	jmp    691 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5b9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5bd:	74 06                	je     5c5 <printf+0xa4>
 5bf:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c3:	75 1e                	jne    5e3 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c8:	8b 00                	mov    (%eax),%eax
 5ca:	6a 00                	push   $0x0
 5cc:	6a 10                	push   $0x10
 5ce:	50                   	push   %eax
 5cf:	ff 75 08             	pushl  0x8(%ebp)
 5d2:	e8 96 fe ff ff       	call   46d <printint>
 5d7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5de:	e9 ae 00 00 00       	jmp    691 <printf+0x170>
      } else if(c == 's'){
 5e3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e7:	75 43                	jne    62c <printf+0x10b>
        s = (char*)*ap;
 5e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f9:	75 25                	jne    620 <printf+0xff>
          s = "(null)";
 5fb:	c7 45 f4 e0 08 00 00 	movl   $0x8e0,-0xc(%ebp)
        while(*s != 0){
 602:	eb 1c                	jmp    620 <printf+0xff>
          putc(fd, *s);
 604:	8b 45 f4             	mov    -0xc(%ebp),%eax
 607:	0f b6 00             	movzbl (%eax),%eax
 60a:	0f be c0             	movsbl %al,%eax
 60d:	83 ec 08             	sub    $0x8,%esp
 610:	50                   	push   %eax
 611:	ff 75 08             	pushl  0x8(%ebp)
 614:	e8 31 fe ff ff       	call   44a <putc>
 619:	83 c4 10             	add    $0x10,%esp
          s++;
 61c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 620:	8b 45 f4             	mov    -0xc(%ebp),%eax
 623:	0f b6 00             	movzbl (%eax),%eax
 626:	84 c0                	test   %al,%al
 628:	75 da                	jne    604 <printf+0xe3>
 62a:	eb 65                	jmp    691 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 630:	75 1d                	jne    64f <printf+0x12e>
        putc(fd, *ap);
 632:	8b 45 e8             	mov    -0x18(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	0f be c0             	movsbl %al,%eax
 63a:	83 ec 08             	sub    $0x8,%esp
 63d:	50                   	push   %eax
 63e:	ff 75 08             	pushl  0x8(%ebp)
 641:	e8 04 fe ff ff       	call   44a <putc>
 646:	83 c4 10             	add    $0x10,%esp
        ap++;
 649:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64d:	eb 42                	jmp    691 <printf+0x170>
      } else if(c == '%'){
 64f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 653:	75 17                	jne    66c <printf+0x14b>
        putc(fd, c);
 655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 658:	0f be c0             	movsbl %al,%eax
 65b:	83 ec 08             	sub    $0x8,%esp
 65e:	50                   	push   %eax
 65f:	ff 75 08             	pushl  0x8(%ebp)
 662:	e8 e3 fd ff ff       	call   44a <putc>
 667:	83 c4 10             	add    $0x10,%esp
 66a:	eb 25                	jmp    691 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66c:	83 ec 08             	sub    $0x8,%esp
 66f:	6a 25                	push   $0x25
 671:	ff 75 08             	pushl  0x8(%ebp)
 674:	e8 d1 fd ff ff       	call   44a <putc>
 679:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 67c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67f:	0f be c0             	movsbl %al,%eax
 682:	83 ec 08             	sub    $0x8,%esp
 685:	50                   	push   %eax
 686:	ff 75 08             	pushl  0x8(%ebp)
 689:	e8 bc fd ff ff       	call   44a <putc>
 68e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 691:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 698:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 69c:	8b 55 0c             	mov    0xc(%ebp),%edx
 69f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a2:	01 d0                	add    %edx,%eax
 6a4:	0f b6 00             	movzbl (%eax),%eax
 6a7:	84 c0                	test   %al,%al
 6a9:	0f 85 94 fe ff ff    	jne    543 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6af:	90                   	nop
 6b0:	c9                   	leave  
 6b1:	c3                   	ret    

000006b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b2:	55                   	push   %ebp
 6b3:	89 e5                	mov    %esp,%ebp
 6b5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b8:	8b 45 08             	mov    0x8(%ebp),%eax
 6bb:	83 e8 08             	sub    $0x8,%eax
 6be:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c1:	a1 70 0b 00 00       	mov    0xb70,%eax
 6c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c9:	eb 24                	jmp    6ef <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d3:	77 12                	ja     6e7 <free+0x35>
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6db:	77 24                	ja     701 <free+0x4f>
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e5:	77 1a                	ja     701 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f5:	76 d4                	jbe    6cb <free+0x19>
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ff:	76 ca                	jbe    6cb <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 701:	8b 45 f8             	mov    -0x8(%ebp),%eax
 704:	8b 40 04             	mov    0x4(%eax),%eax
 707:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 711:	01 c2                	add    %eax,%edx
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 00                	mov    (%eax),%eax
 718:	39 c2                	cmp    %eax,%edx
 71a:	75 24                	jne    740 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	8b 50 04             	mov    0x4(%eax),%edx
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 00                	mov    (%eax),%eax
 727:	8b 40 04             	mov    0x4(%eax),%eax
 72a:	01 c2                	add    %eax,%edx
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	8b 10                	mov    (%eax),%edx
 739:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73c:	89 10                	mov    %edx,(%eax)
 73e:	eb 0a                	jmp    74a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 10                	mov    (%eax),%edx
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 40 04             	mov    0x4(%eax),%eax
 750:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	01 d0                	add    %edx,%eax
 75c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75f:	75 20                	jne    781 <free+0xcf>
    p->s.size += bp->s.size;
 761:	8b 45 fc             	mov    -0x4(%ebp),%eax
 764:	8b 50 04             	mov    0x4(%eax),%edx
 767:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76a:	8b 40 04             	mov    0x4(%eax),%eax
 76d:	01 c2                	add    %eax,%edx
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 775:	8b 45 f8             	mov    -0x8(%ebp),%eax
 778:	8b 10                	mov    (%eax),%edx
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	89 10                	mov    %edx,(%eax)
 77f:	eb 08                	jmp    789 <free+0xd7>
  } else
    p->s.ptr = bp;
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 55 f8             	mov    -0x8(%ebp),%edx
 787:	89 10                	mov    %edx,(%eax)
  freep = p;
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	a3 70 0b 00 00       	mov    %eax,0xb70
}
 791:	90                   	nop
 792:	c9                   	leave  
 793:	c3                   	ret    

00000794 <morecore>:

static Header*
morecore(uint nu)
{
 794:	55                   	push   %ebp
 795:	89 e5                	mov    %esp,%ebp
 797:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 79a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a1:	77 07                	ja     7aa <morecore+0x16>
    nu = 4096;
 7a3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7aa:	8b 45 08             	mov    0x8(%ebp),%eax
 7ad:	c1 e0 03             	shl    $0x3,%eax
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	50                   	push   %eax
 7b4:	e8 19 fc ff ff       	call   3d2 <sbrk>
 7b9:	83 c4 10             	add    $0x10,%esp
 7bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7bf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c3:	75 07                	jne    7cc <morecore+0x38>
    return 0;
 7c5:	b8 00 00 00 00       	mov    $0x0,%eax
 7ca:	eb 26                	jmp    7f2 <morecore+0x5e>
  hp = (Header*)p;
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d5:	8b 55 08             	mov    0x8(%ebp),%edx
 7d8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7de:	83 c0 08             	add    $0x8,%eax
 7e1:	83 ec 0c             	sub    $0xc,%esp
 7e4:	50                   	push   %eax
 7e5:	e8 c8 fe ff ff       	call   6b2 <free>
 7ea:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ed:	a1 70 0b 00 00       	mov    0xb70,%eax
}
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    

000007f4 <malloc>:

void*
malloc(uint nbytes)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fa:	8b 45 08             	mov    0x8(%ebp),%eax
 7fd:	83 c0 07             	add    $0x7,%eax
 800:	c1 e8 03             	shr    $0x3,%eax
 803:	83 c0 01             	add    $0x1,%eax
 806:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 809:	a1 70 0b 00 00       	mov    0xb70,%eax
 80e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 815:	75 23                	jne    83a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 817:	c7 45 f0 68 0b 00 00 	movl   $0xb68,-0x10(%ebp)
 81e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 821:	a3 70 0b 00 00       	mov    %eax,0xb70
 826:	a1 70 0b 00 00       	mov    0xb70,%eax
 82b:	a3 68 0b 00 00       	mov    %eax,0xb68
    base.s.size = 0;
 830:	c7 05 6c 0b 00 00 00 	movl   $0x0,0xb6c
 837:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83d:	8b 00                	mov    (%eax),%eax
 83f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	8b 40 04             	mov    0x4(%eax),%eax
 848:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84b:	72 4d                	jb     89a <malloc+0xa6>
      if(p->s.size == nunits)
 84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 850:	8b 40 04             	mov    0x4(%eax),%eax
 853:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 856:	75 0c                	jne    864 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 858:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85b:	8b 10                	mov    (%eax),%edx
 85d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 860:	89 10                	mov    %edx,(%eax)
 862:	eb 26                	jmp    88a <malloc+0x96>
      else {
        p->s.size -= nunits;
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 40 04             	mov    0x4(%eax),%eax
 86a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 86d:	89 c2                	mov    %eax,%edx
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	c1 e0 03             	shl    $0x3,%eax
 87e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	8b 55 ec             	mov    -0x14(%ebp),%edx
 887:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 88a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88d:	a3 70 0b 00 00       	mov    %eax,0xb70
      return (void*)(p + 1);
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	83 c0 08             	add    $0x8,%eax
 898:	eb 3b                	jmp    8d5 <malloc+0xe1>
    }
    if(p == freep)
 89a:	a1 70 0b 00 00       	mov    0xb70,%eax
 89f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a2:	75 1e                	jne    8c2 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8a4:	83 ec 0c             	sub    $0xc,%esp
 8a7:	ff 75 ec             	pushl  -0x14(%ebp)
 8aa:	e8 e5 fe ff ff       	call   794 <morecore>
 8af:	83 c4 10             	add    $0x10,%esp
 8b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b9:	75 07                	jne    8c2 <malloc+0xce>
        return 0;
 8bb:	b8 00 00 00 00       	mov    $0x0,%eax
 8c0:	eb 13                	jmp    8d5 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	8b 00                	mov    (%eax),%eax
 8cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8d0:	e9 6d ff ff ff       	jmp    842 <malloc+0x4e>
}
 8d5:	c9                   	leave  
 8d6:	c3                   	ret    
