
_chgrp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"

#ifdef CS333_P5
int
main(int argc, char *argv[]) // Added for Project 5: New Commands
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  11:	89 c8                	mov    %ecx,%eax
  char *pathname = 0;
  13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int gid = 0;
  1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // error check for invalid parameters
  if ((argc != 3) || // check number of params
  21:	83 38 03             	cmpl   $0x3,(%eax)
  24:	75 10                	jne    36 <main+0x36>
      (argv[1][0] == '-')){ // check if gid is negative
  26:	8b 50 04             	mov    0x4(%eax),%edx
  29:	83 c2 04             	add    $0x4,%edx
  2c:	8b 12                	mov    (%edx),%edx
  2e:	0f b6 12             	movzbl (%edx),%edx
{
  char *pathname = 0;
  int gid = 0;

  // error check for invalid parameters
  if ((argc != 3) || // check number of params
  31:	80 fa 2d             	cmp    $0x2d,%dl
  34:	75 14                	jne    4a <main+0x4a>
      (argv[1][0] == '-')){ // check if gid is negative

    printf(1, "Invalid parameters.\n");
  36:	83 ec 08             	sub    $0x8,%esp
  39:	68 1c 09 00 00       	push   $0x91c
  3e:	6a 01                	push   $0x1
  40:	e8 21 05 00 00       	call   566 <printf>
  45:	83 c4 10             	add    $0x10,%esp
  48:	eb 5b                	jmp    a5 <main+0xa5>

  // everything looks good!
  } else{
 
    pathname = argv[2];
  4a:	8b 50 04             	mov    0x4(%eax),%edx
  4d:	8b 52 08             	mov    0x8(%edx),%edx
  50:	89 55 f4             	mov    %edx,-0xc(%ebp)
    gid = atoi(argv[1]);
  53:	8b 40 04             	mov    0x4(%eax),%eax
  56:	83 c0 04             	add    $0x4,%eax
  59:	8b 00                	mov    (%eax),%eax
  5b:	83 ec 0c             	sub    $0xc,%esp
  5e:	50                   	push   %eax
  5f:	e8 0b 02 00 00       	call   26f <atoi>
  64:	83 c4 10             	add    $0x10,%esp
  67:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if (chgrp(pathname, gid) == 0)
  6a:	83 ec 08             	sub    $0x8,%esp
  6d:	ff 75 f0             	pushl  -0x10(%ebp)
  70:	ff 75 f4             	pushl  -0xc(%ebp)
  73:	e8 0f 04 00 00       	call   487 <chgrp>
  78:	83 c4 10             	add    $0x10,%esp
  7b:	85 c0                	test   %eax,%eax
  7d:	75 14                	jne    93 <main+0x93>
      printf(1, "chgrp was successful!\n");
  7f:	83 ec 08             	sub    $0x8,%esp
  82:	68 31 09 00 00       	push   $0x931
  87:	6a 01                	push   $0x1
  89:	e8 d8 04 00 00       	call   566 <printf>
  8e:	83 c4 10             	add    $0x10,%esp
  91:	eb 12                	jmp    a5 <main+0xa5>
    else
      printf(1, "chgrp was unsuccessful...\n");  
  93:	83 ec 08             	sub    $0x8,%esp
  96:	68 48 09 00 00       	push   $0x948
  9b:	6a 01                	push   $0x1
  9d:	e8 c4 04 00 00       	call   566 <printf>
  a2:	83 c4 10             	add    $0x10,%esp
  }

  exit();
  a5:	e8 e5 02 00 00       	call   38f <exit>

000000aa <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  aa:	55                   	push   %ebp
  ab:	89 e5                	mov    %esp,%ebp
  ad:	57                   	push   %edi
  ae:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b2:	8b 55 10             	mov    0x10(%ebp),%edx
  b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  b8:	89 cb                	mov    %ecx,%ebx
  ba:	89 df                	mov    %ebx,%edi
  bc:	89 d1                	mov    %edx,%ecx
  be:	fc                   	cld    
  bf:	f3 aa                	rep stos %al,%es:(%edi)
  c1:	89 ca                	mov    %ecx,%edx
  c3:	89 fb                	mov    %edi,%ebx
  c5:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  cb:	90                   	nop
  cc:	5b                   	pop    %ebx
  cd:	5f                   	pop    %edi
  ce:	5d                   	pop    %ebp
  cf:	c3                   	ret    

000000d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  dc:	90                   	nop
  dd:	8b 45 08             	mov    0x8(%ebp),%eax
  e0:	8d 50 01             	lea    0x1(%eax),%edx
  e3:	89 55 08             	mov    %edx,0x8(%ebp)
  e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  e9:	8d 4a 01             	lea    0x1(%edx),%ecx
  ec:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ef:	0f b6 12             	movzbl (%edx),%edx
  f2:	88 10                	mov    %dl,(%eax)
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	84 c0                	test   %al,%al
  f9:	75 e2                	jne    dd <strcpy+0xd>
    ;
  return os;
  fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fe:	c9                   	leave  
  ff:	c3                   	ret    

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 103:	eb 08                	jmp    10d <strcmp+0xd>
    p++, q++;
 105:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 109:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	84 c0                	test   %al,%al
 115:	74 10                	je     127 <strcmp+0x27>
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	0f b6 10             	movzbl (%eax),%edx
 11d:	8b 45 0c             	mov    0xc(%ebp),%eax
 120:	0f b6 00             	movzbl (%eax),%eax
 123:	38 c2                	cmp    %al,%dl
 125:	74 de                	je     105 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 127:	8b 45 08             	mov    0x8(%ebp),%eax
 12a:	0f b6 00             	movzbl (%eax),%eax
 12d:	0f b6 d0             	movzbl %al,%edx
 130:	8b 45 0c             	mov    0xc(%ebp),%eax
 133:	0f b6 00             	movzbl (%eax),%eax
 136:	0f b6 c0             	movzbl %al,%eax
 139:	29 c2                	sub    %eax,%edx
 13b:	89 d0                	mov    %edx,%eax
}
 13d:	5d                   	pop    %ebp
 13e:	c3                   	ret    

0000013f <strlen>:

uint
strlen(char *s)
{
 13f:	55                   	push   %ebp
 140:	89 e5                	mov    %esp,%ebp
 142:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 145:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 14c:	eb 04                	jmp    152 <strlen+0x13>
 14e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 152:	8b 55 fc             	mov    -0x4(%ebp),%edx
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	01 d0                	add    %edx,%eax
 15a:	0f b6 00             	movzbl (%eax),%eax
 15d:	84 c0                	test   %al,%al
 15f:	75 ed                	jne    14e <strlen+0xf>
    ;
  return n;
 161:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <memset>:

void*
memset(void *dst, int c, uint n)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 169:	8b 45 10             	mov    0x10(%ebp),%eax
 16c:	50                   	push   %eax
 16d:	ff 75 0c             	pushl  0xc(%ebp)
 170:	ff 75 08             	pushl  0x8(%ebp)
 173:	e8 32 ff ff ff       	call   aa <stosb>
 178:	83 c4 0c             	add    $0xc,%esp
  return dst;
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 17e:	c9                   	leave  
 17f:	c3                   	ret    

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	83 ec 04             	sub    $0x4,%esp
 186:	8b 45 0c             	mov    0xc(%ebp),%eax
 189:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 18c:	eb 14                	jmp    1a2 <strchr+0x22>
    if(*s == c)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	3a 45 fc             	cmp    -0x4(%ebp),%al
 197:	75 05                	jne    19e <strchr+0x1e>
      return (char*)s;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	eb 13                	jmp    1b1 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 19e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	84 c0                	test   %al,%al
 1aa:	75 e2                	jne    18e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b1:	c9                   	leave  
 1b2:	c3                   	ret    

000001b3 <gets>:

char*
gets(char *buf, int max)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c0:	eb 42                	jmp    204 <gets+0x51>
    cc = read(0, &c, 1);
 1c2:	83 ec 04             	sub    $0x4,%esp
 1c5:	6a 01                	push   $0x1
 1c7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ca:	50                   	push   %eax
 1cb:	6a 00                	push   $0x0
 1cd:	e8 d5 01 00 00       	call   3a7 <read>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1dc:	7e 33                	jle    211 <gets+0x5e>
      break;
    buf[i++] = c;
 1de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e1:	8d 50 01             	lea    0x1(%eax),%edx
 1e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e7:	89 c2                	mov    %eax,%edx
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	01 c2                	add    %eax,%edx
 1ee:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f8:	3c 0a                	cmp    $0xa,%al
 1fa:	74 16                	je     212 <gets+0x5f>
 1fc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 200:	3c 0d                	cmp    $0xd,%al
 202:	74 0e                	je     212 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 204:	8b 45 f4             	mov    -0xc(%ebp),%eax
 207:	83 c0 01             	add    $0x1,%eax
 20a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 20d:	7c b3                	jl     1c2 <gets+0xf>
 20f:	eb 01                	jmp    212 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 211:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 212:	8b 55 f4             	mov    -0xc(%ebp),%edx
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	01 d0                	add    %edx,%eax
 21a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <stat>:

int
stat(char *n, struct stat *st)
{
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
 225:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 228:	83 ec 08             	sub    $0x8,%esp
 22b:	6a 00                	push   $0x0
 22d:	ff 75 08             	pushl  0x8(%ebp)
 230:	e8 9a 01 00 00       	call   3cf <open>
 235:	83 c4 10             	add    $0x10,%esp
 238:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 23b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 23f:	79 07                	jns    248 <stat+0x26>
    return -1;
 241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 246:	eb 25                	jmp    26d <stat+0x4b>
  r = fstat(fd, st);
 248:	83 ec 08             	sub    $0x8,%esp
 24b:	ff 75 0c             	pushl  0xc(%ebp)
 24e:	ff 75 f4             	pushl  -0xc(%ebp)
 251:	e8 91 01 00 00       	call   3e7 <fstat>
 256:	83 c4 10             	add    $0x10,%esp
 259:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 25c:	83 ec 0c             	sub    $0xc,%esp
 25f:	ff 75 f4             	pushl  -0xc(%ebp)
 262:	e8 50 01 00 00       	call   3b7 <close>
 267:	83 c4 10             	add    $0x10,%esp
  return r;
 26a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 26d:	c9                   	leave  
 26e:	c3                   	ret    

0000026f <atoi>:

int
atoi(const char *s)
{
 26f:	55                   	push   %ebp
 270:	89 e5                	mov    %esp,%ebp
 272:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 275:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 27c:	eb 25                	jmp    2a3 <atoi+0x34>
    n = n*10 + *s++ - '0';
 27e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 281:	89 d0                	mov    %edx,%eax
 283:	c1 e0 02             	shl    $0x2,%eax
 286:	01 d0                	add    %edx,%eax
 288:	01 c0                	add    %eax,%eax
 28a:	89 c1                	mov    %eax,%ecx
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	8d 50 01             	lea    0x1(%eax),%edx
 292:	89 55 08             	mov    %edx,0x8(%ebp)
 295:	0f b6 00             	movzbl (%eax),%eax
 298:	0f be c0             	movsbl %al,%eax
 29b:	01 c8                	add    %ecx,%eax
 29d:	83 e8 30             	sub    $0x30,%eax
 2a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	3c 2f                	cmp    $0x2f,%al
 2ab:	7e 0a                	jle    2b7 <atoi+0x48>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 39                	cmp    $0x39,%al
 2b5:	7e c7                	jle    27e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ce:	eb 17                	jmp    2e7 <memmove+0x2b>
    *dst++ = *src++;
 2d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d3:	8d 50 01             	lea    0x1(%eax),%edx
 2d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2dc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2df:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2e2:	0f b6 12             	movzbl (%edx),%edx
 2e5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e7:	8b 45 10             	mov    0x10(%ebp),%eax
 2ea:	8d 50 ff             	lea    -0x1(%eax),%edx
 2ed:	89 55 10             	mov    %edx,0x10(%ebp)
 2f0:	85 c0                	test   %eax,%eax
 2f2:	7f dc                	jg     2d0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <atoo>:

int
atoo(const char *s)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 306:	eb 04                	jmp    30c <atoo+0x13>
 308:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	0f b6 00             	movzbl (%eax),%eax
 312:	3c 20                	cmp    $0x20,%al
 314:	74 f2                	je     308 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	3c 2d                	cmp    $0x2d,%al
 31e:	75 07                	jne    327 <atoo+0x2e>
 320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 325:	eb 05                	jmp    32c <atoo+0x33>
 327:	b8 01 00 00 00       	mov    $0x1,%eax
 32c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	0f b6 00             	movzbl (%eax),%eax
 335:	3c 2b                	cmp    $0x2b,%al
 337:	74 0a                	je     343 <atoo+0x4a>
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	0f b6 00             	movzbl (%eax),%eax
 33f:	3c 2d                	cmp    $0x2d,%al
 341:	75 27                	jne    36a <atoo+0x71>
    s++;
 343:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 347:	eb 21                	jmp    36a <atoo+0x71>
    n = n*8 + *s++ - '0';
 349:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	8d 50 01             	lea    0x1(%eax),%edx
 359:	89 55 08             	mov    %edx,0x8(%ebp)
 35c:	0f b6 00             	movzbl (%eax),%eax
 35f:	0f be c0             	movsbl %al,%eax
 362:	01 c8                	add    %ecx,%eax
 364:	83 e8 30             	sub    $0x30,%eax
 367:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	0f b6 00             	movzbl (%eax),%eax
 370:	3c 2f                	cmp    $0x2f,%al
 372:	7e 0a                	jle    37e <atoo+0x85>
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	0f b6 00             	movzbl (%eax),%eax
 37a:	3c 37                	cmp    $0x37,%al
 37c:	7e cb                	jle    349 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 37e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 381:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 385:	c9                   	leave  
 386:	c3                   	ret    

00000387 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 387:	b8 01 00 00 00       	mov    $0x1,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <exit>:
SYSCALL(exit)
 38f:	b8 02 00 00 00       	mov    $0x2,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <wait>:
SYSCALL(wait)
 397:	b8 03 00 00 00       	mov    $0x3,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <pipe>:
SYSCALL(pipe)
 39f:	b8 04 00 00 00       	mov    $0x4,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <read>:
SYSCALL(read)
 3a7:	b8 05 00 00 00       	mov    $0x5,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <write>:
SYSCALL(write)
 3af:	b8 10 00 00 00       	mov    $0x10,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <close>:
SYSCALL(close)
 3b7:	b8 15 00 00 00       	mov    $0x15,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <kill>:
SYSCALL(kill)
 3bf:	b8 06 00 00 00       	mov    $0x6,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <exec>:
SYSCALL(exec)
 3c7:	b8 07 00 00 00       	mov    $0x7,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <open>:
SYSCALL(open)
 3cf:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <mknod>:
SYSCALL(mknod)
 3d7:	b8 11 00 00 00       	mov    $0x11,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <unlink>:
SYSCALL(unlink)
 3df:	b8 12 00 00 00       	mov    $0x12,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <fstat>:
SYSCALL(fstat)
 3e7:	b8 08 00 00 00       	mov    $0x8,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <link>:
SYSCALL(link)
 3ef:	b8 13 00 00 00       	mov    $0x13,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <mkdir>:
SYSCALL(mkdir)
 3f7:	b8 14 00 00 00       	mov    $0x14,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <chdir>:
SYSCALL(chdir)
 3ff:	b8 09 00 00 00       	mov    $0x9,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <dup>:
SYSCALL(dup)
 407:	b8 0a 00 00 00       	mov    $0xa,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <getpid>:
SYSCALL(getpid)
 40f:	b8 0b 00 00 00       	mov    $0xb,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <sbrk>:
SYSCALL(sbrk)
 417:	b8 0c 00 00 00       	mov    $0xc,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <sleep>:
SYSCALL(sleep)
 41f:	b8 0d 00 00 00       	mov    $0xd,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <uptime>:
SYSCALL(uptime)
 427:	b8 0e 00 00 00       	mov    $0xe,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <halt>:
SYSCALL(halt)
 42f:	b8 16 00 00 00       	mov    $0x16,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 437:	b8 17 00 00 00       	mov    $0x17,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 43f:	b8 18 00 00 00       	mov    $0x18,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 447:	b8 19 00 00 00       	mov    $0x19,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 44f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 457:	b8 1b 00 00 00       	mov    $0x1b,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 45f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 467:	b8 1d 00 00 00       	mov    $0x1d,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 46f:	b8 1e 00 00 00       	mov    $0x1e,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 477:	b8 1f 00 00 00       	mov    $0x1f,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 47f:	b8 20 00 00 00       	mov    $0x20,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 487:	b8 21 00 00 00       	mov    $0x21,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 48f:	55                   	push   %ebp
 490:	89 e5                	mov    %esp,%ebp
 492:	83 ec 18             	sub    $0x18,%esp
 495:	8b 45 0c             	mov    0xc(%ebp),%eax
 498:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 49b:	83 ec 04             	sub    $0x4,%esp
 49e:	6a 01                	push   $0x1
 4a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a3:	50                   	push   %eax
 4a4:	ff 75 08             	pushl  0x8(%ebp)
 4a7:	e8 03 ff ff ff       	call   3af <write>
 4ac:	83 c4 10             	add    $0x10,%esp
}
 4af:	90                   	nop
 4b0:	c9                   	leave  
 4b1:	c3                   	ret    

000004b2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b2:	55                   	push   %ebp
 4b3:	89 e5                	mov    %esp,%ebp
 4b5:	53                   	push   %ebx
 4b6:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4c0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4c4:	74 17                	je     4dd <printint+0x2b>
 4c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4ca:	79 11                	jns    4dd <printint+0x2b>
    neg = 1;
 4cc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d6:	f7 d8                	neg    %eax
 4d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4db:	eb 06                	jmp    4e3 <printint+0x31>
  } else {
    x = xx;
 4dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ea:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4ed:	8d 41 01             	lea    0x1(%ecx),%eax
 4f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f9:	ba 00 00 00 00       	mov    $0x0,%edx
 4fe:	f7 f3                	div    %ebx
 500:	89 d0                	mov    %edx,%eax
 502:	0f b6 80 d4 0b 00 00 	movzbl 0xbd4(%eax),%eax
 509:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 50d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 510:	8b 45 ec             	mov    -0x14(%ebp),%eax
 513:	ba 00 00 00 00       	mov    $0x0,%edx
 518:	f7 f3                	div    %ebx
 51a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 521:	75 c7                	jne    4ea <printint+0x38>
  if(neg)
 523:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 527:	74 2d                	je     556 <printint+0xa4>
    buf[i++] = '-';
 529:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52c:	8d 50 01             	lea    0x1(%eax),%edx
 52f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 532:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 537:	eb 1d                	jmp    556 <printint+0xa4>
    putc(fd, buf[i]);
 539:	8d 55 dc             	lea    -0x24(%ebp),%edx
 53c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53f:	01 d0                	add    %edx,%eax
 541:	0f b6 00             	movzbl (%eax),%eax
 544:	0f be c0             	movsbl %al,%eax
 547:	83 ec 08             	sub    $0x8,%esp
 54a:	50                   	push   %eax
 54b:	ff 75 08             	pushl  0x8(%ebp)
 54e:	e8 3c ff ff ff       	call   48f <putc>
 553:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 556:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 55a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55e:	79 d9                	jns    539 <printint+0x87>
    putc(fd, buf[i]);
}
 560:	90                   	nop
 561:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 564:	c9                   	leave  
 565:	c3                   	ret    

00000566 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 566:	55                   	push   %ebp
 567:	89 e5                	mov    %esp,%ebp
 569:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 56c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 573:	8d 45 0c             	lea    0xc(%ebp),%eax
 576:	83 c0 04             	add    $0x4,%eax
 579:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 57c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 583:	e9 59 01 00 00       	jmp    6e1 <printf+0x17b>
    c = fmt[i] & 0xff;
 588:	8b 55 0c             	mov    0xc(%ebp),%edx
 58b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58e:	01 d0                	add    %edx,%eax
 590:	0f b6 00             	movzbl (%eax),%eax
 593:	0f be c0             	movsbl %al,%eax
 596:	25 ff 00 00 00       	and    $0xff,%eax
 59b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 59e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a2:	75 2c                	jne    5d0 <printf+0x6a>
      if(c == '%'){
 5a4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a8:	75 0c                	jne    5b6 <printf+0x50>
        state = '%';
 5aa:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5b1:	e9 27 01 00 00       	jmp    6dd <printf+0x177>
      } else {
        putc(fd, c);
 5b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b9:	0f be c0             	movsbl %al,%eax
 5bc:	83 ec 08             	sub    $0x8,%esp
 5bf:	50                   	push   %eax
 5c0:	ff 75 08             	pushl  0x8(%ebp)
 5c3:	e8 c7 fe ff ff       	call   48f <putc>
 5c8:	83 c4 10             	add    $0x10,%esp
 5cb:	e9 0d 01 00 00       	jmp    6dd <printf+0x177>
      }
    } else if(state == '%'){
 5d0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d4:	0f 85 03 01 00 00    	jne    6dd <printf+0x177>
      if(c == 'd'){
 5da:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5de:	75 1e                	jne    5fe <printf+0x98>
        printint(fd, *ap, 10, 1);
 5e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e3:	8b 00                	mov    (%eax),%eax
 5e5:	6a 01                	push   $0x1
 5e7:	6a 0a                	push   $0xa
 5e9:	50                   	push   %eax
 5ea:	ff 75 08             	pushl  0x8(%ebp)
 5ed:	e8 c0 fe ff ff       	call   4b2 <printint>
 5f2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f9:	e9 d8 00 00 00       	jmp    6d6 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5fe:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 602:	74 06                	je     60a <printf+0xa4>
 604:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 608:	75 1e                	jne    628 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 60a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60d:	8b 00                	mov    (%eax),%eax
 60f:	6a 00                	push   $0x0
 611:	6a 10                	push   $0x10
 613:	50                   	push   %eax
 614:	ff 75 08             	pushl  0x8(%ebp)
 617:	e8 96 fe ff ff       	call   4b2 <printint>
 61c:	83 c4 10             	add    $0x10,%esp
        ap++;
 61f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 623:	e9 ae 00 00 00       	jmp    6d6 <printf+0x170>
      } else if(c == 's'){
 628:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 62c:	75 43                	jne    671 <printf+0x10b>
        s = (char*)*ap;
 62e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 636:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 63a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 63e:	75 25                	jne    665 <printf+0xff>
          s = "(null)";
 640:	c7 45 f4 63 09 00 00 	movl   $0x963,-0xc(%ebp)
        while(*s != 0){
 647:	eb 1c                	jmp    665 <printf+0xff>
          putc(fd, *s);
 649:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64c:	0f b6 00             	movzbl (%eax),%eax
 64f:	0f be c0             	movsbl %al,%eax
 652:	83 ec 08             	sub    $0x8,%esp
 655:	50                   	push   %eax
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 31 fe ff ff       	call   48f <putc>
 65e:	83 c4 10             	add    $0x10,%esp
          s++;
 661:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 665:	8b 45 f4             	mov    -0xc(%ebp),%eax
 668:	0f b6 00             	movzbl (%eax),%eax
 66b:	84 c0                	test   %al,%al
 66d:	75 da                	jne    649 <printf+0xe3>
 66f:	eb 65                	jmp    6d6 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 671:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 675:	75 1d                	jne    694 <printf+0x12e>
        putc(fd, *ap);
 677:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	0f be c0             	movsbl %al,%eax
 67f:	83 ec 08             	sub    $0x8,%esp
 682:	50                   	push   %eax
 683:	ff 75 08             	pushl  0x8(%ebp)
 686:	e8 04 fe ff ff       	call   48f <putc>
 68b:	83 c4 10             	add    $0x10,%esp
        ap++;
 68e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 692:	eb 42                	jmp    6d6 <printf+0x170>
      } else if(c == '%'){
 694:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 698:	75 17                	jne    6b1 <printf+0x14b>
        putc(fd, c);
 69a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69d:	0f be c0             	movsbl %al,%eax
 6a0:	83 ec 08             	sub    $0x8,%esp
 6a3:	50                   	push   %eax
 6a4:	ff 75 08             	pushl  0x8(%ebp)
 6a7:	e8 e3 fd ff ff       	call   48f <putc>
 6ac:	83 c4 10             	add    $0x10,%esp
 6af:	eb 25                	jmp    6d6 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6b1:	83 ec 08             	sub    $0x8,%esp
 6b4:	6a 25                	push   $0x25
 6b6:	ff 75 08             	pushl  0x8(%ebp)
 6b9:	e8 d1 fd ff ff       	call   48f <putc>
 6be:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c4:	0f be c0             	movsbl %al,%eax
 6c7:	83 ec 08             	sub    $0x8,%esp
 6ca:	50                   	push   %eax
 6cb:	ff 75 08             	pushl  0x8(%ebp)
 6ce:	e8 bc fd ff ff       	call   48f <putc>
 6d3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6dd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6e1:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e7:	01 d0                	add    %edx,%eax
 6e9:	0f b6 00             	movzbl (%eax),%eax
 6ec:	84 c0                	test   %al,%al
 6ee:	0f 85 94 fe ff ff    	jne    588 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f4:	90                   	nop
 6f5:	c9                   	leave  
 6f6:	c3                   	ret    

000006f7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f7:	55                   	push   %ebp
 6f8:	89 e5                	mov    %esp,%ebp
 6fa:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	83 e8 08             	sub    $0x8,%eax
 703:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 706:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 70b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70e:	eb 24                	jmp    734 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 718:	77 12                	ja     72c <free+0x35>
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 720:	77 24                	ja     746 <free+0x4f>
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 00                	mov    (%eax),%eax
 727:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72a:	77 1a                	ja     746 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	89 45 fc             	mov    %eax,-0x4(%ebp)
 734:	8b 45 f8             	mov    -0x8(%ebp),%eax
 737:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73a:	76 d4                	jbe    710 <free+0x19>
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 744:	76 ca                	jbe    710 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	8b 40 04             	mov    0x4(%eax),%eax
 74c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	01 c2                	add    %eax,%edx
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	39 c2                	cmp    %eax,%edx
 75f:	75 24                	jne    785 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	8b 50 04             	mov    0x4(%eax),%edx
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	8b 40 04             	mov    0x4(%eax),%eax
 76f:	01 c2                	add    %eax,%edx
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	8b 10                	mov    (%eax),%edx
 77e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 781:	89 10                	mov    %edx,(%eax)
 783:	eb 0a                	jmp    78f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 10                	mov    (%eax),%edx
 78a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	01 d0                	add    %edx,%eax
 7a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a4:	75 20                	jne    7c6 <free+0xcf>
    p->s.size += bp->s.size;
 7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a9:	8b 50 04             	mov    0x4(%eax),%edx
 7ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	01 c2                	add    %eax,%edx
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	8b 10                	mov    (%eax),%edx
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	89 10                	mov    %edx,(%eax)
 7c4:	eb 08                	jmp    7ce <free+0xd7>
  } else
    p->s.ptr = bp;
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7cc:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	a3 f0 0b 00 00       	mov    %eax,0xbf0
}
 7d6:	90                   	nop
 7d7:	c9                   	leave  
 7d8:	c3                   	ret    

000007d9 <morecore>:

static Header*
morecore(uint nu)
{
 7d9:	55                   	push   %ebp
 7da:	89 e5                	mov    %esp,%ebp
 7dc:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7df:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7e6:	77 07                	ja     7ef <morecore+0x16>
    nu = 4096;
 7e8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ef:	8b 45 08             	mov    0x8(%ebp),%eax
 7f2:	c1 e0 03             	shl    $0x3,%eax
 7f5:	83 ec 0c             	sub    $0xc,%esp
 7f8:	50                   	push   %eax
 7f9:	e8 19 fc ff ff       	call   417 <sbrk>
 7fe:	83 c4 10             	add    $0x10,%esp
 801:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 804:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 808:	75 07                	jne    811 <morecore+0x38>
    return 0;
 80a:	b8 00 00 00 00       	mov    $0x0,%eax
 80f:	eb 26                	jmp    837 <morecore+0x5e>
  hp = (Header*)p;
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 817:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81a:	8b 55 08             	mov    0x8(%ebp),%edx
 81d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 820:	8b 45 f0             	mov    -0x10(%ebp),%eax
 823:	83 c0 08             	add    $0x8,%eax
 826:	83 ec 0c             	sub    $0xc,%esp
 829:	50                   	push   %eax
 82a:	e8 c8 fe ff ff       	call   6f7 <free>
 82f:	83 c4 10             	add    $0x10,%esp
  return freep;
 832:	a1 f0 0b 00 00       	mov    0xbf0,%eax
}
 837:	c9                   	leave  
 838:	c3                   	ret    

00000839 <malloc>:

void*
malloc(uint nbytes)
{
 839:	55                   	push   %ebp
 83a:	89 e5                	mov    %esp,%ebp
 83c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83f:	8b 45 08             	mov    0x8(%ebp),%eax
 842:	83 c0 07             	add    $0x7,%eax
 845:	c1 e8 03             	shr    $0x3,%eax
 848:	83 c0 01             	add    $0x1,%eax
 84b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 84e:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 853:	89 45 f0             	mov    %eax,-0x10(%ebp)
 856:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 85a:	75 23                	jne    87f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 85c:	c7 45 f0 e8 0b 00 00 	movl   $0xbe8,-0x10(%ebp)
 863:	8b 45 f0             	mov    -0x10(%ebp),%eax
 866:	a3 f0 0b 00 00       	mov    %eax,0xbf0
 86b:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 870:	a3 e8 0b 00 00       	mov    %eax,0xbe8
    base.s.size = 0;
 875:	c7 05 ec 0b 00 00 00 	movl   $0x0,0xbec
 87c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 882:	8b 00                	mov    (%eax),%eax
 884:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 887:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88a:	8b 40 04             	mov    0x4(%eax),%eax
 88d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 890:	72 4d                	jb     8df <malloc+0xa6>
      if(p->s.size == nunits)
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	8b 40 04             	mov    0x4(%eax),%eax
 898:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89b:	75 0c                	jne    8a9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	8b 10                	mov    (%eax),%edx
 8a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a5:	89 10                	mov    %edx,(%eax)
 8a7:	eb 26                	jmp    8cf <malloc+0x96>
      else {
        p->s.size -= nunits;
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	8b 40 04             	mov    0x4(%eax),%eax
 8af:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8b2:	89 c2                	mov    %eax,%edx
 8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	8b 40 04             	mov    0x4(%eax),%eax
 8c0:	c1 e0 03             	shl    $0x3,%eax
 8c3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8cc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d2:	a3 f0 0b 00 00       	mov    %eax,0xbf0
      return (void*)(p + 1);
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	83 c0 08             	add    $0x8,%eax
 8dd:	eb 3b                	jmp    91a <malloc+0xe1>
    }
    if(p == freep)
 8df:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 8e4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8e7:	75 1e                	jne    907 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8e9:	83 ec 0c             	sub    $0xc,%esp
 8ec:	ff 75 ec             	pushl  -0x14(%ebp)
 8ef:	e8 e5 fe ff ff       	call   7d9 <morecore>
 8f4:	83 c4 10             	add    $0x10,%esp
 8f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8fe:	75 07                	jne    907 <malloc+0xce>
        return 0;
 900:	b8 00 00 00 00       	mov    $0x0,%eax
 905:	eb 13                	jmp    91a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 907:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 910:	8b 00                	mov    (%eax),%eax
 912:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 915:	e9 6d ff ff ff       	jmp    887 <malloc+0x4e>
}
 91a:	c9                   	leave  
 91b:	c3                   	ret    
