
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 80 0c 00 00       	push   $0xc80
  13:	6a 01                	push   $0x1
  15:	e8 fa 03 00 00       	call   414 <write>
  1a:	83 c4 10             	add    $0x10,%esp
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 80 0c 00 00       	push   $0xc80
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 da 03 00 00       	call   40c <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 81 09 00 00       	push   $0x981
  4c:	6a 01                	push   $0x1
  4e:	e8 78 05 00 00       	call   5cb <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 99 03 00 00       	call   3f4 <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	pushl  -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 6b 03 00 00       	call   3f4 <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 86 03 00 00       	call   434 <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 92 09 00 00       	push   $0x992
  d4:	6a 01                	push   $0x1
  d6:	e8 f0 04 00 00       	call   5cb <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 11 03 00 00       	call   3f4 <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	pushl  -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	pushl  -0x10(%ebp)
  f7:	e8 20 03 00 00       	call   41c <close>
  fc:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 10a:	e8 e5 02 00 00       	call   3f4 <exit>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	90                   	nop
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	8d 50 01             	lea    0x1(%eax),%edx
 148:	89 55 08             	mov    %edx,0x8(%ebp)
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 4a 01             	lea    0x1(%edx),%ecx
 151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	29 c2                	sub    %eax,%edx
 1a0:	89 d0                	mov    %edx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 0c             	pushl  0xc(%ebp)
 1d5:	ff 75 08             	pushl  0x8(%ebp)
 1d8:	e8 32 ff ff ff       	call   10f <stosb>
 1dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strchr>:

char*
strchr(const char *s, char c)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f1:	eb 14                	jmp    207 <strchr+0x22>
    if(*s == c)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1fc:	75 05                	jne    203 <strchr+0x1e>
      return (char*)s;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	eb 13                	jmp    216 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 01                	push   $0x1
 22c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22f:	50                   	push   %eax
 230:	6a 00                	push   $0x0
 232:	e8 d5 01 00 00       	call   40c <read>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 241:	7e 33                	jle    276 <gets+0x5e>
      break;
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 16                	je     277 <gets+0x5f>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0e                	je     277 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 272:	7c b3                	jl     227 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 276:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	pushl  0x8(%ebp)
 295:	e8 9a 01 00 00       	call   434 <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	pushl  0xc(%ebp)
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	e8 91 01 00 00       	call   44c <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	pushl  -0xc(%ebp)
 2c7:	e8 50 01 00 00       	call   41c <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e1:	eb 25                	jmp    308 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	c1 e0 02             	shl    $0x2,%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	01 c0                	add    %eax,%eax
 2ef:	89 c1                	mov    %eax,%ecx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 08             	mov    %edx,0x8(%ebp)
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	0f be c0             	movsbl %al,%eax
 300:	01 c8                	add    %ecx,%eax
 302:	83 e8 30             	sub    $0x30,%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 2f                	cmp    $0x2f,%al
 310:	7e 0a                	jle    31c <atoi+0x48>
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	3c 39                	cmp    $0x39,%al
 31a:	7e c7                	jle    2e3 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 31c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 333:	eb 17                	jmp    34c <memmove+0x2b>
    *dst++ = *src++;
 335:	8b 45 fc             	mov    -0x4(%ebp),%eax
 338:	8d 50 01             	lea    0x1(%eax),%edx
 33b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 33e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 341:	8d 4a 01             	lea    0x1(%edx),%ecx
 344:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 347:	0f b6 12             	movzbl (%edx),%edx
 34a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34c:	8b 45 10             	mov    0x10(%ebp),%eax
 34f:	8d 50 ff             	lea    -0x1(%eax),%edx
 352:	89 55 10             	mov    %edx,0x10(%ebp)
 355:	85 c0                	test   %eax,%eax
 357:	7f dc                	jg     335 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <atoo>:

int
atoo(const char *s)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 364:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 36b:	eb 04                	jmp    371 <atoo+0x13>
 36d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	0f b6 00             	movzbl (%eax),%eax
 377:	3c 20                	cmp    $0x20,%al
 379:	74 f2                	je     36d <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	0f b6 00             	movzbl (%eax),%eax
 381:	3c 2d                	cmp    $0x2d,%al
 383:	75 07                	jne    38c <atoo+0x2e>
 385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38a:	eb 05                	jmp    391 <atoo+0x33>
 38c:	b8 01 00 00 00       	mov    $0x1,%eax
 391:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	0f b6 00             	movzbl (%eax),%eax
 39a:	3c 2b                	cmp    $0x2b,%al
 39c:	74 0a                	je     3a8 <atoo+0x4a>
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	3c 2d                	cmp    $0x2d,%al
 3a6:	75 27                	jne    3cf <atoo+0x71>
    s++;
 3a8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3ac:	eb 21                	jmp    3cf <atoo+0x71>
    n = n*8 + *s++ - '0';
 3ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b1:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	8d 50 01             	lea    0x1(%eax),%edx
 3be:	89 55 08             	mov    %edx,0x8(%ebp)
 3c1:	0f b6 00             	movzbl (%eax),%eax
 3c4:	0f be c0             	movsbl %al,%eax
 3c7:	01 c8                	add    %ecx,%eax
 3c9:	83 e8 30             	sub    $0x30,%eax
 3cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3cf:	8b 45 08             	mov    0x8(%ebp),%eax
 3d2:	0f b6 00             	movzbl (%eax),%eax
 3d5:	3c 2f                	cmp    $0x2f,%al
 3d7:	7e 0a                	jle    3e3 <atoo+0x85>
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	0f b6 00             	movzbl (%eax),%eax
 3df:	3c 37                	cmp    $0x37,%al
 3e1:	7e cb                	jle    3ae <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3e6:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3ea:	c9                   	leave  
 3eb:	c3                   	ret    

000003ec <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ec:	b8 01 00 00 00       	mov    $0x1,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <exit>:
SYSCALL(exit)
 3f4:	b8 02 00 00 00       	mov    $0x2,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <wait>:
SYSCALL(wait)
 3fc:	b8 03 00 00 00       	mov    $0x3,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <pipe>:
SYSCALL(pipe)
 404:	b8 04 00 00 00       	mov    $0x4,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <read>:
SYSCALL(read)
 40c:	b8 05 00 00 00       	mov    $0x5,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <write>:
SYSCALL(write)
 414:	b8 10 00 00 00       	mov    $0x10,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <close>:
SYSCALL(close)
 41c:	b8 15 00 00 00       	mov    $0x15,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <kill>:
SYSCALL(kill)
 424:	b8 06 00 00 00       	mov    $0x6,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <exec>:
SYSCALL(exec)
 42c:	b8 07 00 00 00       	mov    $0x7,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <open>:
SYSCALL(open)
 434:	b8 0f 00 00 00       	mov    $0xf,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <mknod>:
SYSCALL(mknod)
 43c:	b8 11 00 00 00       	mov    $0x11,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <unlink>:
SYSCALL(unlink)
 444:	b8 12 00 00 00       	mov    $0x12,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <fstat>:
SYSCALL(fstat)
 44c:	b8 08 00 00 00       	mov    $0x8,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <link>:
SYSCALL(link)
 454:	b8 13 00 00 00       	mov    $0x13,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <mkdir>:
SYSCALL(mkdir)
 45c:	b8 14 00 00 00       	mov    $0x14,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <chdir>:
SYSCALL(chdir)
 464:	b8 09 00 00 00       	mov    $0x9,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <dup>:
SYSCALL(dup)
 46c:	b8 0a 00 00 00       	mov    $0xa,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <getpid>:
SYSCALL(getpid)
 474:	b8 0b 00 00 00       	mov    $0xb,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <sbrk>:
SYSCALL(sbrk)
 47c:	b8 0c 00 00 00       	mov    $0xc,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <sleep>:
SYSCALL(sleep)
 484:	b8 0d 00 00 00       	mov    $0xd,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <uptime>:
SYSCALL(uptime)
 48c:	b8 0e 00 00 00       	mov    $0xe,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <halt>:
SYSCALL(halt)
 494:	b8 16 00 00 00       	mov    $0x16,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 49c:	b8 17 00 00 00       	mov    $0x17,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 4a4:	b8 18 00 00 00       	mov    $0x18,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 4ac:	b8 19 00 00 00       	mov    $0x19,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 4b4:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 4bc:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 4c4:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 4cc:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 4d4:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 4dc:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 4e4:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 4ec:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	83 ec 18             	sub    $0x18,%esp
 4fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 500:	83 ec 04             	sub    $0x4,%esp
 503:	6a 01                	push   $0x1
 505:	8d 45 f4             	lea    -0xc(%ebp),%eax
 508:	50                   	push   %eax
 509:	ff 75 08             	pushl  0x8(%ebp)
 50c:	e8 03 ff ff ff       	call   414 <write>
 511:	83 c4 10             	add    $0x10,%esp
}
 514:	90                   	nop
 515:	c9                   	leave  
 516:	c3                   	ret    

00000517 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 517:	55                   	push   %ebp
 518:	89 e5                	mov    %esp,%ebp
 51a:	53                   	push   %ebx
 51b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 51e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 525:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 529:	74 17                	je     542 <printint+0x2b>
 52b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 52f:	79 11                	jns    542 <printint+0x2b>
    neg = 1;
 531:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 538:	8b 45 0c             	mov    0xc(%ebp),%eax
 53b:	f7 d8                	neg    %eax
 53d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 540:	eb 06                	jmp    548 <printint+0x31>
  } else {
    x = xx;
 542:	8b 45 0c             	mov    0xc(%ebp),%eax
 545:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 548:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 54f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 552:	8d 41 01             	lea    0x1(%ecx),%eax
 555:	89 45 f4             	mov    %eax,-0xc(%ebp)
 558:	8b 5d 10             	mov    0x10(%ebp),%ebx
 55b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 55e:	ba 00 00 00 00       	mov    $0x0,%edx
 563:	f7 f3                	div    %ebx
 565:	89 d0                	mov    %edx,%eax
 567:	0f b6 80 3c 0c 00 00 	movzbl 0xc3c(%eax),%eax
 56e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 572:	8b 5d 10             	mov    0x10(%ebp),%ebx
 575:	8b 45 ec             	mov    -0x14(%ebp),%eax
 578:	ba 00 00 00 00       	mov    $0x0,%edx
 57d:	f7 f3                	div    %ebx
 57f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 582:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 586:	75 c7                	jne    54f <printint+0x38>
  if(neg)
 588:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 58c:	74 2d                	je     5bb <printint+0xa4>
    buf[i++] = '-';
 58e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 591:	8d 50 01             	lea    0x1(%eax),%edx
 594:	89 55 f4             	mov    %edx,-0xc(%ebp)
 597:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 59c:	eb 1d                	jmp    5bb <printint+0xa4>
    putc(fd, buf[i]);
 59e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a4:	01 d0                	add    %edx,%eax
 5a6:	0f b6 00             	movzbl (%eax),%eax
 5a9:	0f be c0             	movsbl %al,%eax
 5ac:	83 ec 08             	sub    $0x8,%esp
 5af:	50                   	push   %eax
 5b0:	ff 75 08             	pushl  0x8(%ebp)
 5b3:	e8 3c ff ff ff       	call   4f4 <putc>
 5b8:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5bb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c3:	79 d9                	jns    59e <printint+0x87>
    putc(fd, buf[i]);
}
 5c5:	90                   	nop
 5c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5c9:	c9                   	leave  
 5ca:	c3                   	ret    

000005cb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5cb:	55                   	push   %ebp
 5cc:	89 e5                	mov    %esp,%ebp
 5ce:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5d8:	8d 45 0c             	lea    0xc(%ebp),%eax
 5db:	83 c0 04             	add    $0x4,%eax
 5de:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e8:	e9 59 01 00 00       	jmp    746 <printf+0x17b>
    c = fmt[i] & 0xff;
 5ed:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f3:	01 d0                	add    %edx,%eax
 5f5:	0f b6 00             	movzbl (%eax),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	25 ff 00 00 00       	and    $0xff,%eax
 600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 603:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 607:	75 2c                	jne    635 <printf+0x6a>
      if(c == '%'){
 609:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60d:	75 0c                	jne    61b <printf+0x50>
        state = '%';
 60f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 616:	e9 27 01 00 00       	jmp    742 <printf+0x177>
      } else {
        putc(fd, c);
 61b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61e:	0f be c0             	movsbl %al,%eax
 621:	83 ec 08             	sub    $0x8,%esp
 624:	50                   	push   %eax
 625:	ff 75 08             	pushl  0x8(%ebp)
 628:	e8 c7 fe ff ff       	call   4f4 <putc>
 62d:	83 c4 10             	add    $0x10,%esp
 630:	e9 0d 01 00 00       	jmp    742 <printf+0x177>
      }
    } else if(state == '%'){
 635:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 639:	0f 85 03 01 00 00    	jne    742 <printf+0x177>
      if(c == 'd'){
 63f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 643:	75 1e                	jne    663 <printf+0x98>
        printint(fd, *ap, 10, 1);
 645:	8b 45 e8             	mov    -0x18(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	6a 01                	push   $0x1
 64c:	6a 0a                	push   $0xa
 64e:	50                   	push   %eax
 64f:	ff 75 08             	pushl  0x8(%ebp)
 652:	e8 c0 fe ff ff       	call   517 <printint>
 657:	83 c4 10             	add    $0x10,%esp
        ap++;
 65a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65e:	e9 d8 00 00 00       	jmp    73b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 663:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 667:	74 06                	je     66f <printf+0xa4>
 669:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 66d:	75 1e                	jne    68d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 66f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 672:	8b 00                	mov    (%eax),%eax
 674:	6a 00                	push   $0x0
 676:	6a 10                	push   $0x10
 678:	50                   	push   %eax
 679:	ff 75 08             	pushl  0x8(%ebp)
 67c:	e8 96 fe ff ff       	call   517 <printint>
 681:	83 c4 10             	add    $0x10,%esp
        ap++;
 684:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 688:	e9 ae 00 00 00       	jmp    73b <printf+0x170>
      } else if(c == 's'){
 68d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 691:	75 43                	jne    6d6 <printf+0x10b>
        s = (char*)*ap;
 693:	8b 45 e8             	mov    -0x18(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 69b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 69f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a3:	75 25                	jne    6ca <printf+0xff>
          s = "(null)";
 6a5:	c7 45 f4 a7 09 00 00 	movl   $0x9a7,-0xc(%ebp)
        while(*s != 0){
 6ac:	eb 1c                	jmp    6ca <printf+0xff>
          putc(fd, *s);
 6ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b1:	0f b6 00             	movzbl (%eax),%eax
 6b4:	0f be c0             	movsbl %al,%eax
 6b7:	83 ec 08             	sub    $0x8,%esp
 6ba:	50                   	push   %eax
 6bb:	ff 75 08             	pushl  0x8(%ebp)
 6be:	e8 31 fe ff ff       	call   4f4 <putc>
 6c3:	83 c4 10             	add    $0x10,%esp
          s++;
 6c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cd:	0f b6 00             	movzbl (%eax),%eax
 6d0:	84 c0                	test   %al,%al
 6d2:	75 da                	jne    6ae <printf+0xe3>
 6d4:	eb 65                	jmp    73b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6da:	75 1d                	jne    6f9 <printf+0x12e>
        putc(fd, *ap);
 6dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6df:	8b 00                	mov    (%eax),%eax
 6e1:	0f be c0             	movsbl %al,%eax
 6e4:	83 ec 08             	sub    $0x8,%esp
 6e7:	50                   	push   %eax
 6e8:	ff 75 08             	pushl  0x8(%ebp)
 6eb:	e8 04 fe ff ff       	call   4f4 <putc>
 6f0:	83 c4 10             	add    $0x10,%esp
        ap++;
 6f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f7:	eb 42                	jmp    73b <printf+0x170>
      } else if(c == '%'){
 6f9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6fd:	75 17                	jne    716 <printf+0x14b>
        putc(fd, c);
 6ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 702:	0f be c0             	movsbl %al,%eax
 705:	83 ec 08             	sub    $0x8,%esp
 708:	50                   	push   %eax
 709:	ff 75 08             	pushl  0x8(%ebp)
 70c:	e8 e3 fd ff ff       	call   4f4 <putc>
 711:	83 c4 10             	add    $0x10,%esp
 714:	eb 25                	jmp    73b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 716:	83 ec 08             	sub    $0x8,%esp
 719:	6a 25                	push   $0x25
 71b:	ff 75 08             	pushl  0x8(%ebp)
 71e:	e8 d1 fd ff ff       	call   4f4 <putc>
 723:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 729:	0f be c0             	movsbl %al,%eax
 72c:	83 ec 08             	sub    $0x8,%esp
 72f:	50                   	push   %eax
 730:	ff 75 08             	pushl  0x8(%ebp)
 733:	e8 bc fd ff ff       	call   4f4 <putc>
 738:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 73b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 742:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 746:	8b 55 0c             	mov    0xc(%ebp),%edx
 749:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74c:	01 d0                	add    %edx,%eax
 74e:	0f b6 00             	movzbl (%eax),%eax
 751:	84 c0                	test   %al,%al
 753:	0f 85 94 fe ff ff    	jne    5ed <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 759:	90                   	nop
 75a:	c9                   	leave  
 75b:	c3                   	ret    

0000075c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75c:	55                   	push   %ebp
 75d:	89 e5                	mov    %esp,%ebp
 75f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 762:	8b 45 08             	mov    0x8(%ebp),%eax
 765:	83 e8 08             	sub    $0x8,%eax
 768:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76b:	a1 68 0c 00 00       	mov    0xc68,%eax
 770:	89 45 fc             	mov    %eax,-0x4(%ebp)
 773:	eb 24                	jmp    799 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77d:	77 12                	ja     791 <free+0x35>
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 785:	77 24                	ja     7ab <free+0x4f>
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	8b 00                	mov    (%eax),%eax
 78c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78f:	77 1a                	ja     7ab <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	89 45 fc             	mov    %eax,-0x4(%ebp)
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79f:	76 d4                	jbe    775 <free+0x19>
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a9:	76 ca                	jbe    775 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bb:	01 c2                	add    %eax,%edx
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	39 c2                	cmp    %eax,%edx
 7c4:	75 24                	jne    7ea <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c9:	8b 50 04             	mov    0x4(%eax),%edx
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 00                	mov    (%eax),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	01 c2                	add    %eax,%edx
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	8b 00                	mov    (%eax),%eax
 7e1:	8b 10                	mov    (%eax),%edx
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	89 10                	mov    %edx,(%eax)
 7e8:	eb 0a                	jmp    7f4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ed:	8b 10                	mov    (%eax),%edx
 7ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f7:	8b 40 04             	mov    0x4(%eax),%eax
 7fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	01 d0                	add    %edx,%eax
 806:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 809:	75 20                	jne    82b <free+0xcf>
    p->s.size += bp->s.size;
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	8b 50 04             	mov    0x4(%eax),%edx
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	01 c2                	add    %eax,%edx
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 81f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 822:	8b 10                	mov    (%eax),%edx
 824:	8b 45 fc             	mov    -0x4(%ebp),%eax
 827:	89 10                	mov    %edx,(%eax)
 829:	eb 08                	jmp    833 <free+0xd7>
  } else
    p->s.ptr = bp;
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 831:	89 10                	mov    %edx,(%eax)
  freep = p;
 833:	8b 45 fc             	mov    -0x4(%ebp),%eax
 836:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 83b:	90                   	nop
 83c:	c9                   	leave  
 83d:	c3                   	ret    

0000083e <morecore>:

static Header*
morecore(uint nu)
{
 83e:	55                   	push   %ebp
 83f:	89 e5                	mov    %esp,%ebp
 841:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 844:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 84b:	77 07                	ja     854 <morecore+0x16>
    nu = 4096;
 84d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 854:	8b 45 08             	mov    0x8(%ebp),%eax
 857:	c1 e0 03             	shl    $0x3,%eax
 85a:	83 ec 0c             	sub    $0xc,%esp
 85d:	50                   	push   %eax
 85e:	e8 19 fc ff ff       	call   47c <sbrk>
 863:	83 c4 10             	add    $0x10,%esp
 866:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 869:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 86d:	75 07                	jne    876 <morecore+0x38>
    return 0;
 86f:	b8 00 00 00 00       	mov    $0x0,%eax
 874:	eb 26                	jmp    89c <morecore+0x5e>
  hp = (Header*)p;
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 87c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87f:	8b 55 08             	mov    0x8(%ebp),%edx
 882:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 885:	8b 45 f0             	mov    -0x10(%ebp),%eax
 888:	83 c0 08             	add    $0x8,%eax
 88b:	83 ec 0c             	sub    $0xc,%esp
 88e:	50                   	push   %eax
 88f:	e8 c8 fe ff ff       	call   75c <free>
 894:	83 c4 10             	add    $0x10,%esp
  return freep;
 897:	a1 68 0c 00 00       	mov    0xc68,%eax
}
 89c:	c9                   	leave  
 89d:	c3                   	ret    

0000089e <malloc>:

void*
malloc(uint nbytes)
{
 89e:	55                   	push   %ebp
 89f:	89 e5                	mov    %esp,%ebp
 8a1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a4:	8b 45 08             	mov    0x8(%ebp),%eax
 8a7:	83 c0 07             	add    $0x7,%eax
 8aa:	c1 e8 03             	shr    $0x3,%eax
 8ad:	83 c0 01             	add    $0x1,%eax
 8b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8b3:	a1 68 0c 00 00       	mov    0xc68,%eax
 8b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8bf:	75 23                	jne    8e4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8c1:	c7 45 f0 60 0c 00 00 	movl   $0xc60,-0x10(%ebp)
 8c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cb:	a3 68 0c 00 00       	mov    %eax,0xc68
 8d0:	a1 68 0c 00 00       	mov    0xc68,%eax
 8d5:	a3 60 0c 00 00       	mov    %eax,0xc60
    base.s.size = 0;
 8da:	c7 05 64 0c 00 00 00 	movl   $0x0,0xc64
 8e1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e7:	8b 00                	mov    (%eax),%eax
 8e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 40 04             	mov    0x4(%eax),%eax
 8f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f5:	72 4d                	jb     944 <malloc+0xa6>
      if(p->s.size == nunits)
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 900:	75 0c                	jne    90e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	8b 10                	mov    (%eax),%edx
 907:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90a:	89 10                	mov    %edx,(%eax)
 90c:	eb 26                	jmp    934 <malloc+0x96>
      else {
        p->s.size -= nunits;
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	8b 40 04             	mov    0x4(%eax),%eax
 914:	2b 45 ec             	sub    -0x14(%ebp),%eax
 917:	89 c2                	mov    %eax,%edx
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	8b 40 04             	mov    0x4(%eax),%eax
 925:	c1 e0 03             	shl    $0x3,%eax
 928:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 931:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 934:	8b 45 f0             	mov    -0x10(%ebp),%eax
 937:	a3 68 0c 00 00       	mov    %eax,0xc68
      return (void*)(p + 1);
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	83 c0 08             	add    $0x8,%eax
 942:	eb 3b                	jmp    97f <malloc+0xe1>
    }
    if(p == freep)
 944:	a1 68 0c 00 00       	mov    0xc68,%eax
 949:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 94c:	75 1e                	jne    96c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 94e:	83 ec 0c             	sub    $0xc,%esp
 951:	ff 75 ec             	pushl  -0x14(%ebp)
 954:	e8 e5 fe ff ff       	call   83e <morecore>
 959:	83 c4 10             	add    $0x10,%esp
 95c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 95f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 963:	75 07                	jne    96c <malloc+0xce>
        return 0;
 965:	b8 00 00 00 00       	mov    $0x0,%eax
 96a:	eb 13                	jmp    97f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 972:	8b 45 f4             	mov    -0xc(%ebp),%eax
 975:	8b 00                	mov    (%eax),%eax
 977:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 97a:	e9 6d ff ff ff       	jmp    8ec <malloc+0x4e>
}
 97f:	c9                   	leave  
 980:	c3                   	ret    
