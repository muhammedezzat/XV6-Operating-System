
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
  44:	68 38 09 00 00       	push   $0x938
  49:	6a 01                	push   $0x1
  4b:	e8 32 05 00 00       	call   582 <printf>
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
  8a:	e8 fc 03 00 00       	call   48b <setpriority>
  8f:	83 c4 10             	add    $0x10,%esp
  92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (rc == 0)
  95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  99:	75 14                	jne    af <main+0xaf>
    printf(1, "Successfully set priority!\n");
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	68 58 09 00 00       	push   $0x958
  a3:	6a 01                	push   $0x1
  a5:	e8 d8 04 00 00       	call   582 <printf>
  aa:	83 c4 10             	add    $0x10,%esp
  ad:	eb 12                	jmp    c1 <main+0xc1>
  else
    printf(1, "Failed to set priority!\n");
  af:	83 ec 08             	sub    $0x8,%esp
  b2:	68 74 09 00 00       	push   $0x974
  b7:	6a 01                	push   $0x1
  b9:	e8 c4 04 00 00       	call   582 <printf>
  be:	83 c4 10             	add    $0x10,%esp

  exit();
  c1:	e8 e5 02 00 00       	call   3ab <exit>

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
 1e9:	e8 d5 01 00 00       	call   3c3 <read>
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
 24c:	e8 9a 01 00 00       	call   3eb <open>
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
 26d:	e8 91 01 00 00       	call   403 <fstat>
 272:	83 c4 10             	add    $0x10,%esp
 275:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 278:	83 ec 0c             	sub    $0xc,%esp
 27b:	ff 75 f4             	pushl  -0xc(%ebp)
 27e:	e8 50 01 00 00       	call   3d3 <close>
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

00000315 <atoo>:

int
atoo(const char *s)
{
 315:	55                   	push   %ebp
 316:	89 e5                	mov    %esp,%ebp
 318:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 31b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 322:	eb 04                	jmp    328 <atoo+0x13>
 324:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	0f b6 00             	movzbl (%eax),%eax
 32e:	3c 20                	cmp    $0x20,%al
 330:	74 f2                	je     324 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	0f b6 00             	movzbl (%eax),%eax
 338:	3c 2d                	cmp    $0x2d,%al
 33a:	75 07                	jne    343 <atoo+0x2e>
 33c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 341:	eb 05                	jmp    348 <atoo+0x33>
 343:	b8 01 00 00 00       	mov    $0x1,%eax
 348:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 2b                	cmp    $0x2b,%al
 353:	74 0a                	je     35f <atoo+0x4a>
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 2d                	cmp    $0x2d,%al
 35d:	75 27                	jne    386 <atoo+0x71>
    s++;
 35f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 363:	eb 21                	jmp    386 <atoo+0x71>
    n = n*8 + *s++ - '0';
 365:	8b 45 fc             	mov    -0x4(%ebp),%eax
 368:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	8d 50 01             	lea    0x1(%eax),%edx
 375:	89 55 08             	mov    %edx,0x8(%ebp)
 378:	0f b6 00             	movzbl (%eax),%eax
 37b:	0f be c0             	movsbl %al,%eax
 37e:	01 c8                	add    %ecx,%eax
 380:	83 e8 30             	sub    $0x30,%eax
 383:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	0f b6 00             	movzbl (%eax),%eax
 38c:	3c 2f                	cmp    $0x2f,%al
 38e:	7e 0a                	jle    39a <atoo+0x85>
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	3c 37                	cmp    $0x37,%al
 398:	7e cb                	jle    365 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 39a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 39d:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3a1:	c9                   	leave  
 3a2:	c3                   	ret    

000003a3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a3:	b8 01 00 00 00       	mov    $0x1,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <exit>:
SYSCALL(exit)
 3ab:	b8 02 00 00 00       	mov    $0x2,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <wait>:
SYSCALL(wait)
 3b3:	b8 03 00 00 00       	mov    $0x3,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <pipe>:
SYSCALL(pipe)
 3bb:	b8 04 00 00 00       	mov    $0x4,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <read>:
SYSCALL(read)
 3c3:	b8 05 00 00 00       	mov    $0x5,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <write>:
SYSCALL(write)
 3cb:	b8 10 00 00 00       	mov    $0x10,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <close>:
SYSCALL(close)
 3d3:	b8 15 00 00 00       	mov    $0x15,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <kill>:
SYSCALL(kill)
 3db:	b8 06 00 00 00       	mov    $0x6,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <exec>:
SYSCALL(exec)
 3e3:	b8 07 00 00 00       	mov    $0x7,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <open>:
SYSCALL(open)
 3eb:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <mknod>:
SYSCALL(mknod)
 3f3:	b8 11 00 00 00       	mov    $0x11,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <unlink>:
SYSCALL(unlink)
 3fb:	b8 12 00 00 00       	mov    $0x12,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <fstat>:
SYSCALL(fstat)
 403:	b8 08 00 00 00       	mov    $0x8,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <link>:
SYSCALL(link)
 40b:	b8 13 00 00 00       	mov    $0x13,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <mkdir>:
SYSCALL(mkdir)
 413:	b8 14 00 00 00       	mov    $0x14,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <chdir>:
SYSCALL(chdir)
 41b:	b8 09 00 00 00       	mov    $0x9,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <dup>:
SYSCALL(dup)
 423:	b8 0a 00 00 00       	mov    $0xa,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <getpid>:
SYSCALL(getpid)
 42b:	b8 0b 00 00 00       	mov    $0xb,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <sbrk>:
SYSCALL(sbrk)
 433:	b8 0c 00 00 00       	mov    $0xc,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <sleep>:
SYSCALL(sleep)
 43b:	b8 0d 00 00 00       	mov    $0xd,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <uptime>:
SYSCALL(uptime)
 443:	b8 0e 00 00 00       	mov    $0xe,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <halt>:
SYSCALL(halt)
 44b:	b8 16 00 00 00       	mov    $0x16,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 453:	b8 17 00 00 00       	mov    $0x17,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 45b:	b8 18 00 00 00       	mov    $0x18,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 463:	b8 19 00 00 00       	mov    $0x19,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 46b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 473:	b8 1b 00 00 00       	mov    $0x1b,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 47b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 483:	b8 1a 00 00 00       	mov    $0x1a,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 48b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 493:	b8 1c 00 00 00       	mov    $0x1c,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 49b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 4a3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4ab:	55                   	push   %ebp
 4ac:	89 e5                	mov    %esp,%ebp
 4ae:	83 ec 18             	sub    $0x18,%esp
 4b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4b7:	83 ec 04             	sub    $0x4,%esp
 4ba:	6a 01                	push   $0x1
 4bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4bf:	50                   	push   %eax
 4c0:	ff 75 08             	pushl  0x8(%ebp)
 4c3:	e8 03 ff ff ff       	call   3cb <write>
 4c8:	83 c4 10             	add    $0x10,%esp
}
 4cb:	90                   	nop
 4cc:	c9                   	leave  
 4cd:	c3                   	ret    

000004ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ce:	55                   	push   %ebp
 4cf:	89 e5                	mov    %esp,%ebp
 4d1:	53                   	push   %ebx
 4d2:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4dc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4e0:	74 17                	je     4f9 <printint+0x2b>
 4e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e6:	79 11                	jns    4f9 <printint+0x2b>
    neg = 1;
 4e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f2:	f7 d8                	neg    %eax
 4f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f7:	eb 06                	jmp    4ff <printint+0x31>
  } else {
    x = xx;
 4f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 506:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 509:	8d 41 01             	lea    0x1(%ecx),%eax
 50c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 50f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 512:	8b 45 ec             	mov    -0x14(%ebp),%eax
 515:	ba 00 00 00 00       	mov    $0x0,%edx
 51a:	f7 f3                	div    %ebx
 51c:	89 d0                	mov    %edx,%eax
 51e:	0f b6 80 00 0c 00 00 	movzbl 0xc00(%eax),%eax
 525:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 529:	8b 5d 10             	mov    0x10(%ebp),%ebx
 52c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52f:	ba 00 00 00 00       	mov    $0x0,%edx
 534:	f7 f3                	div    %ebx
 536:	89 45 ec             	mov    %eax,-0x14(%ebp)
 539:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53d:	75 c7                	jne    506 <printint+0x38>
  if(neg)
 53f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 543:	74 2d                	je     572 <printint+0xa4>
    buf[i++] = '-';
 545:	8b 45 f4             	mov    -0xc(%ebp),%eax
 548:	8d 50 01             	lea    0x1(%eax),%edx
 54b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 553:	eb 1d                	jmp    572 <printint+0xa4>
    putc(fd, buf[i]);
 555:	8d 55 dc             	lea    -0x24(%ebp),%edx
 558:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55b:	01 d0                	add    %edx,%eax
 55d:	0f b6 00             	movzbl (%eax),%eax
 560:	0f be c0             	movsbl %al,%eax
 563:	83 ec 08             	sub    $0x8,%esp
 566:	50                   	push   %eax
 567:	ff 75 08             	pushl  0x8(%ebp)
 56a:	e8 3c ff ff ff       	call   4ab <putc>
 56f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 572:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57a:	79 d9                	jns    555 <printint+0x87>
    putc(fd, buf[i]);
}
 57c:	90                   	nop
 57d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 580:	c9                   	leave  
 581:	c3                   	ret    

00000582 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 588:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58f:	8d 45 0c             	lea    0xc(%ebp),%eax
 592:	83 c0 04             	add    $0x4,%eax
 595:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 598:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59f:	e9 59 01 00 00       	jmp    6fd <printf+0x17b>
    c = fmt[i] & 0xff;
 5a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5aa:	01 d0                	add    %edx,%eax
 5ac:	0f b6 00             	movzbl (%eax),%eax
 5af:	0f be c0             	movsbl %al,%eax
 5b2:	25 ff 00 00 00       	and    $0xff,%eax
 5b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5be:	75 2c                	jne    5ec <printf+0x6a>
      if(c == '%'){
 5c0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c4:	75 0c                	jne    5d2 <printf+0x50>
        state = '%';
 5c6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cd:	e9 27 01 00 00       	jmp    6f9 <printf+0x177>
      } else {
        putc(fd, c);
 5d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d5:	0f be c0             	movsbl %al,%eax
 5d8:	83 ec 08             	sub    $0x8,%esp
 5db:	50                   	push   %eax
 5dc:	ff 75 08             	pushl  0x8(%ebp)
 5df:	e8 c7 fe ff ff       	call   4ab <putc>
 5e4:	83 c4 10             	add    $0x10,%esp
 5e7:	e9 0d 01 00 00       	jmp    6f9 <printf+0x177>
      }
    } else if(state == '%'){
 5ec:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5f0:	0f 85 03 01 00 00    	jne    6f9 <printf+0x177>
      if(c == 'd'){
 5f6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5fa:	75 1e                	jne    61a <printf+0x98>
        printint(fd, *ap, 10, 1);
 5fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ff:	8b 00                	mov    (%eax),%eax
 601:	6a 01                	push   $0x1
 603:	6a 0a                	push   $0xa
 605:	50                   	push   %eax
 606:	ff 75 08             	pushl  0x8(%ebp)
 609:	e8 c0 fe ff ff       	call   4ce <printint>
 60e:	83 c4 10             	add    $0x10,%esp
        ap++;
 611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 615:	e9 d8 00 00 00       	jmp    6f2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 61a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 61e:	74 06                	je     626 <printf+0xa4>
 620:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 624:	75 1e                	jne    644 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 626:	8b 45 e8             	mov    -0x18(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	6a 00                	push   $0x0
 62d:	6a 10                	push   $0x10
 62f:	50                   	push   %eax
 630:	ff 75 08             	pushl  0x8(%ebp)
 633:	e8 96 fe ff ff       	call   4ce <printint>
 638:	83 c4 10             	add    $0x10,%esp
        ap++;
 63b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63f:	e9 ae 00 00 00       	jmp    6f2 <printf+0x170>
      } else if(c == 's'){
 644:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 648:	75 43                	jne    68d <printf+0x10b>
        s = (char*)*ap;
 64a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 652:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 65a:	75 25                	jne    681 <printf+0xff>
          s = "(null)";
 65c:	c7 45 f4 8d 09 00 00 	movl   $0x98d,-0xc(%ebp)
        while(*s != 0){
 663:	eb 1c                	jmp    681 <printf+0xff>
          putc(fd, *s);
 665:	8b 45 f4             	mov    -0xc(%ebp),%eax
 668:	0f b6 00             	movzbl (%eax),%eax
 66b:	0f be c0             	movsbl %al,%eax
 66e:	83 ec 08             	sub    $0x8,%esp
 671:	50                   	push   %eax
 672:	ff 75 08             	pushl  0x8(%ebp)
 675:	e8 31 fe ff ff       	call   4ab <putc>
 67a:	83 c4 10             	add    $0x10,%esp
          s++;
 67d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 681:	8b 45 f4             	mov    -0xc(%ebp),%eax
 684:	0f b6 00             	movzbl (%eax),%eax
 687:	84 c0                	test   %al,%al
 689:	75 da                	jne    665 <printf+0xe3>
 68b:	eb 65                	jmp    6f2 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 691:	75 1d                	jne    6b0 <printf+0x12e>
        putc(fd, *ap);
 693:	8b 45 e8             	mov    -0x18(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	0f be c0             	movsbl %al,%eax
 69b:	83 ec 08             	sub    $0x8,%esp
 69e:	50                   	push   %eax
 69f:	ff 75 08             	pushl  0x8(%ebp)
 6a2:	e8 04 fe ff ff       	call   4ab <putc>
 6a7:	83 c4 10             	add    $0x10,%esp
        ap++;
 6aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ae:	eb 42                	jmp    6f2 <printf+0x170>
      } else if(c == '%'){
 6b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b4:	75 17                	jne    6cd <printf+0x14b>
        putc(fd, c);
 6b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b9:	0f be c0             	movsbl %al,%eax
 6bc:	83 ec 08             	sub    $0x8,%esp
 6bf:	50                   	push   %eax
 6c0:	ff 75 08             	pushl  0x8(%ebp)
 6c3:	e8 e3 fd ff ff       	call   4ab <putc>
 6c8:	83 c4 10             	add    $0x10,%esp
 6cb:	eb 25                	jmp    6f2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6cd:	83 ec 08             	sub    $0x8,%esp
 6d0:	6a 25                	push   $0x25
 6d2:	ff 75 08             	pushl  0x8(%ebp)
 6d5:	e8 d1 fd ff ff       	call   4ab <putc>
 6da:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e0:	0f be c0             	movsbl %al,%eax
 6e3:	83 ec 08             	sub    $0x8,%esp
 6e6:	50                   	push   %eax
 6e7:	ff 75 08             	pushl  0x8(%ebp)
 6ea:	e8 bc fd ff ff       	call   4ab <putc>
 6ef:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6fd:	8b 55 0c             	mov    0xc(%ebp),%edx
 700:	8b 45 f0             	mov    -0x10(%ebp),%eax
 703:	01 d0                	add    %edx,%eax
 705:	0f b6 00             	movzbl (%eax),%eax
 708:	84 c0                	test   %al,%al
 70a:	0f 85 94 fe ff ff    	jne    5a4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 710:	90                   	nop
 711:	c9                   	leave  
 712:	c3                   	ret    

00000713 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 713:	55                   	push   %ebp
 714:	89 e5                	mov    %esp,%ebp
 716:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	83 e8 08             	sub    $0x8,%eax
 71f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 722:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 727:	89 45 fc             	mov    %eax,-0x4(%ebp)
 72a:	eb 24                	jmp    750 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 734:	77 12                	ja     748 <free+0x35>
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73c:	77 24                	ja     762 <free+0x4f>
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 00                	mov    (%eax),%eax
 743:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 746:	77 1a                	ja     762 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 00                	mov    (%eax),%eax
 74d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 756:	76 d4                	jbe    72c <free+0x19>
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 760:	76 ca                	jbe    72c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 762:	8b 45 f8             	mov    -0x8(%ebp),%eax
 765:	8b 40 04             	mov    0x4(%eax),%eax
 768:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	01 c2                	add    %eax,%edx
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	39 c2                	cmp    %eax,%edx
 77b:	75 24                	jne    7a1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 77d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 780:	8b 50 04             	mov    0x4(%eax),%edx
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	01 c2                	add    %eax,%edx
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	8b 10                	mov    (%eax),%edx
 79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79d:	89 10                	mov    %edx,(%eax)
 79f:	eb 0a                	jmp    7ab <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 10                	mov    (%eax),%edx
 7a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	01 d0                	add    %edx,%eax
 7bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c0:	75 20                	jne    7e2 <free+0xcf>
    p->s.size += bp->s.size;
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 50 04             	mov    0x4(%eax),%edx
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	01 c2                	add    %eax,%edx
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	8b 10                	mov    (%eax),%edx
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	89 10                	mov    %edx,(%eax)
 7e0:	eb 08                	jmp    7ea <free+0xd7>
  } else
    p->s.ptr = bp;
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e8:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ed:	a3 1c 0c 00 00       	mov    %eax,0xc1c
}
 7f2:	90                   	nop
 7f3:	c9                   	leave  
 7f4:	c3                   	ret    

000007f5 <morecore>:

static Header*
morecore(uint nu)
{
 7f5:	55                   	push   %ebp
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7fb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 802:	77 07                	ja     80b <morecore+0x16>
    nu = 4096;
 804:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	c1 e0 03             	shl    $0x3,%eax
 811:	83 ec 0c             	sub    $0xc,%esp
 814:	50                   	push   %eax
 815:	e8 19 fc ff ff       	call   433 <sbrk>
 81a:	83 c4 10             	add    $0x10,%esp
 81d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 820:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 824:	75 07                	jne    82d <morecore+0x38>
    return 0;
 826:	b8 00 00 00 00       	mov    $0x0,%eax
 82b:	eb 26                	jmp    853 <morecore+0x5e>
  hp = (Header*)p;
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	8b 55 08             	mov    0x8(%ebp),%edx
 839:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	83 c0 08             	add    $0x8,%eax
 842:	83 ec 0c             	sub    $0xc,%esp
 845:	50                   	push   %eax
 846:	e8 c8 fe ff ff       	call   713 <free>
 84b:	83 c4 10             	add    $0x10,%esp
  return freep;
 84e:	a1 1c 0c 00 00       	mov    0xc1c,%eax
}
 853:	c9                   	leave  
 854:	c3                   	ret    

00000855 <malloc>:

void*
malloc(uint nbytes)
{
 855:	55                   	push   %ebp
 856:	89 e5                	mov    %esp,%ebp
 858:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85b:	8b 45 08             	mov    0x8(%ebp),%eax
 85e:	83 c0 07             	add    $0x7,%eax
 861:	c1 e8 03             	shr    $0x3,%eax
 864:	83 c0 01             	add    $0x1,%eax
 867:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 86a:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 86f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 872:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 876:	75 23                	jne    89b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 878:	c7 45 f0 14 0c 00 00 	movl   $0xc14,-0x10(%ebp)
 87f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 882:	a3 1c 0c 00 00       	mov    %eax,0xc1c
 887:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 88c:	a3 14 0c 00 00       	mov    %eax,0xc14
    base.s.size = 0;
 891:	c7 05 18 0c 00 00 00 	movl   $0x0,0xc18
 898:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89e:	8b 00                	mov    (%eax),%eax
 8a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	8b 40 04             	mov    0x4(%eax),%eax
 8a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ac:	72 4d                	jb     8fb <malloc+0xa6>
      if(p->s.size == nunits)
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	8b 40 04             	mov    0x4(%eax),%eax
 8b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b7:	75 0c                	jne    8c5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	8b 10                	mov    (%eax),%edx
 8be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c1:	89 10                	mov    %edx,(%eax)
 8c3:	eb 26                	jmp    8eb <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c8:	8b 40 04             	mov    0x4(%eax),%eax
 8cb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ce:	89 c2                	mov    %eax,%edx
 8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	8b 40 04             	mov    0x4(%eax),%eax
 8dc:	c1 e0 03             	shl    $0x3,%eax
 8df:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8e8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ee:	a3 1c 0c 00 00       	mov    %eax,0xc1c
      return (void*)(p + 1);
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	83 c0 08             	add    $0x8,%eax
 8f9:	eb 3b                	jmp    936 <malloc+0xe1>
    }
    if(p == freep)
 8fb:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 900:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 903:	75 1e                	jne    923 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 905:	83 ec 0c             	sub    $0xc,%esp
 908:	ff 75 ec             	pushl  -0x14(%ebp)
 90b:	e8 e5 fe ff ff       	call   7f5 <morecore>
 910:	83 c4 10             	add    $0x10,%esp
 913:	89 45 f4             	mov    %eax,-0xc(%ebp)
 916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 91a:	75 07                	jne    923 <malloc+0xce>
        return 0;
 91c:	b8 00 00 00 00       	mov    $0x0,%eax
 921:	eb 13                	jmp    936 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 923:	8b 45 f4             	mov    -0xc(%ebp),%eax
 926:	89 45 f0             	mov    %eax,-0x10(%ebp)
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 931:	e9 6d ff ff ff       	jmp    8a3 <malloc+0x4e>
}
 936:	c9                   	leave  
 937:	c3                   	ret    
