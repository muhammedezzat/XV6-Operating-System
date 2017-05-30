
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <dayofweek>:
  "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
static char *days[] = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};

int
dayofweek(int y, int m, int d)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
   4:	83 7d 0c 02          	cmpl   $0x2,0xc(%ebp)
   8:	7f 0b                	jg     15 <dayofweek+0x15>
   a:	8b 45 08             	mov    0x8(%ebp),%eax
   d:	8d 50 ff             	lea    -0x1(%eax),%edx
  10:	89 55 08             	mov    %edx,0x8(%ebp)
  13:	eb 06                	jmp    1b <dayofweek+0x1b>
  15:	8b 45 08             	mov    0x8(%ebp),%eax
  18:	83 e8 02             	sub    $0x2,%eax
  1b:	01 45 10             	add    %eax,0x10(%ebp)
  1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  21:	6b c8 17             	imul   $0x17,%eax,%ecx
  24:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
  29:	89 c8                	mov    %ecx,%eax
  2b:	f7 ea                	imul   %edx
  2d:	d1 fa                	sar    %edx
  2f:	89 c8                	mov    %ecx,%eax
  31:	c1 f8 1f             	sar    $0x1f,%eax
  34:	29 c2                	sub    %eax,%edx
  36:	8b 45 10             	mov    0x10(%ebp),%eax
  39:	01 d0                	add    %edx,%eax
  3b:	8d 48 04             	lea    0x4(%eax),%ecx
  3e:	8b 45 08             	mov    0x8(%ebp),%eax
  41:	8d 50 03             	lea    0x3(%eax),%edx
  44:	85 c0                	test   %eax,%eax
  46:	0f 48 c2             	cmovs  %edx,%eax
  49:	c1 f8 02             	sar    $0x2,%eax
  4c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
  4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  52:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  57:	89 c8                	mov    %ecx,%eax
  59:	f7 ea                	imul   %edx
  5b:	c1 fa 05             	sar    $0x5,%edx
  5e:	89 c8                	mov    %ecx,%eax
  60:	c1 f8 1f             	sar    $0x1f,%eax
  63:	29 c2                	sub    %eax,%edx
  65:	89 d0                	mov    %edx,%eax
  67:	29 c3                	sub    %eax,%ebx
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  71:	89 c8                	mov    %ecx,%eax
  73:	f7 ea                	imul   %edx
  75:	c1 fa 07             	sar    $0x7,%edx
  78:	89 c8                	mov    %ecx,%eax
  7a:	c1 f8 1f             	sar    $0x1f,%eax
  7d:	29 c2                	sub    %eax,%edx
  7f:	89 d0                	mov    %edx,%eax
  81:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
  84:	ba 93 24 49 92       	mov    $0x92492493,%edx
  89:	89 c8                	mov    %ecx,%eax
  8b:	f7 ea                	imul   %edx
  8d:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  90:	c1 f8 02             	sar    $0x2,%eax
  93:	89 c2                	mov    %eax,%edx
  95:	89 c8                	mov    %ecx,%eax
  97:	c1 f8 1f             	sar    $0x1f,%eax
  9a:	29 c2                	sub    %eax,%edx
  9c:	89 d0                	mov    %edx,%eax
  9e:	89 c2                	mov    %eax,%edx
  a0:	c1 e2 03             	shl    $0x3,%edx
  a3:	29 c2                	sub    %eax,%edx
  a5:	89 c8                	mov    %ecx,%eax
  a7:	29 d0                	sub    %edx,%eax
}
  a9:	5b                   	pop    %ebx
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <main>:

int
main(int argc, char *argv[])
{
  ac:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  b0:	83 e4 f0             	and    $0xfffffff0,%esp
  b3:	ff 71 fc             	pushl  -0x4(%ecx)
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	53                   	push   %ebx
  ba:	51                   	push   %ecx
  bb:	83 ec 20             	sub    $0x20,%esp
  int day;
  struct rtcdate r;

  if (date(&r)) {
  be:	83 ec 0c             	sub    $0xc,%esp
  c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  c4:	50                   	push   %eax
  c5:	e8 20 04 00 00       	call   4ea <date>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	85 c0                	test   %eax,%eax
  cf:	74 1b                	je     ec <main+0x40>
    printf(2,"Error: date call failed. %s at line %d\n", __FILE__, __LINE__);
  d1:	6a 19                	push   $0x19
  d3:	68 21 0a 00 00       	push   $0xa21
  d8:	68 28 0a 00 00       	push   $0xa28
  dd:	6a 02                	push   $0x2
  df:	e8 35 05 00 00       	call   619 <printf>
  e4:	83 c4 10             	add    $0x10,%esp
    exit();
  e7:	e8 56 03 00 00       	call   442 <exit>
  }

  day = dayofweek(r.year, r.month, r.day);
  ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  ef:	89 c1                	mov    %eax,%ecx
  f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  f4:	89 c2                	mov    %eax,%edx
  f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f9:	83 ec 04             	sub    $0x4,%esp
  fc:	51                   	push   %ecx
  fd:	52                   	push   %edx
  fe:	50                   	push   %eax
  ff:	e8 fc fe ff ff       	call   0 <dayofweek>
 104:	83 c4 10             	add    $0x10,%esp
 107:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "%s %s %d", days[day], months[r.month], r.day);
 10a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 10d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 110:	8b 14 85 20 0d 00 00 	mov    0xd20(,%eax,4),%edx
 117:	8b 45 f4             	mov    -0xc(%ebp),%eax
 11a:	8b 04 85 54 0d 00 00 	mov    0xd54(,%eax,4),%eax
 121:	83 ec 0c             	sub    $0xc,%esp
 124:	51                   	push   %ecx
 125:	52                   	push   %edx
 126:	50                   	push   %eax
 127:	68 50 0a 00 00       	push   $0xa50
 12c:	6a 01                	push   $0x1
 12e:	e8 e6 04 00 00       	call   619 <printf>
 133:	83 c4 20             	add    $0x20,%esp
  printf(1, " %d:%d:%d UTC %d\n", r.hour, r.minute, r.second, r.year);
 136:	8b 5d f0             	mov    -0x10(%ebp),%ebx
 139:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 13c:	8b 55 e0             	mov    -0x20(%ebp),%edx
 13f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 142:	83 ec 08             	sub    $0x8,%esp
 145:	53                   	push   %ebx
 146:	51                   	push   %ecx
 147:	52                   	push   %edx
 148:	50                   	push   %eax
 149:	68 59 0a 00 00       	push   $0xa59
 14e:	6a 01                	push   $0x1
 150:	e8 c4 04 00 00       	call   619 <printf>
 155:	83 c4 20             	add    $0x20,%esp

  exit();
 158:	e8 e5 02 00 00       	call   442 <exit>

0000015d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	57                   	push   %edi
 161:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 162:	8b 4d 08             	mov    0x8(%ebp),%ecx
 165:	8b 55 10             	mov    0x10(%ebp),%edx
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	89 cb                	mov    %ecx,%ebx
 16d:	89 df                	mov    %ebx,%edi
 16f:	89 d1                	mov    %edx,%ecx
 171:	fc                   	cld    
 172:	f3 aa                	rep stos %al,%es:(%edi)
 174:	89 ca                	mov    %ecx,%edx
 176:	89 fb                	mov    %edi,%ebx
 178:	89 5d 08             	mov    %ebx,0x8(%ebp)
 17b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 17e:	90                   	nop
 17f:	5b                   	pop    %ebx
 180:	5f                   	pop    %edi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    

00000183 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 183:	55                   	push   %ebp
 184:	89 e5                	mov    %esp,%ebp
 186:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 18f:	90                   	nop
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	8d 50 01             	lea    0x1(%eax),%edx
 196:	89 55 08             	mov    %edx,0x8(%ebp)
 199:	8b 55 0c             	mov    0xc(%ebp),%edx
 19c:	8d 4a 01             	lea    0x1(%edx),%ecx
 19f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1a2:	0f b6 12             	movzbl (%edx),%edx
 1a5:	88 10                	mov    %dl,(%eax)
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	84 c0                	test   %al,%al
 1ac:	75 e2                	jne    190 <strcpy+0xd>
    ;
  return os;
 1ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b1:	c9                   	leave  
 1b2:	c3                   	ret    

000001b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1b6:	eb 08                	jmp    1c0 <strcmp+0xd>
    p++, q++;
 1b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1bc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	0f b6 00             	movzbl (%eax),%eax
 1c6:	84 c0                	test   %al,%al
 1c8:	74 10                	je     1da <strcmp+0x27>
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	0f b6 10             	movzbl (%eax),%edx
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	38 c2                	cmp    %al,%dl
 1d8:	74 de                	je     1b8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	0f b6 00             	movzbl (%eax),%eax
 1e0:	0f b6 d0             	movzbl %al,%edx
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	0f b6 00             	movzbl (%eax),%eax
 1e9:	0f b6 c0             	movzbl %al,%eax
 1ec:	29 c2                	sub    %eax,%edx
 1ee:	89 d0                	mov    %edx,%eax
}
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    

000001f2 <strlen>:

uint
strlen(char *s)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ff:	eb 04                	jmp    205 <strlen+0x13>
 201:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 205:	8b 55 fc             	mov    -0x4(%ebp),%edx
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	01 d0                	add    %edx,%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	84 c0                	test   %al,%al
 212:	75 ed                	jne    201 <strlen+0xf>
    ;
  return n;
 214:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <memset>:

void*
memset(void *dst, int c, uint n)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 21c:	8b 45 10             	mov    0x10(%ebp),%eax
 21f:	50                   	push   %eax
 220:	ff 75 0c             	pushl  0xc(%ebp)
 223:	ff 75 08             	pushl  0x8(%ebp)
 226:	e8 32 ff ff ff       	call   15d <stosb>
 22b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <strchr>:

char*
strchr(const char *s, char c)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	83 ec 04             	sub    $0x4,%esp
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 23f:	eb 14                	jmp    255 <strchr+0x22>
    if(*s == c)
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	3a 45 fc             	cmp    -0x4(%ebp),%al
 24a:	75 05                	jne    251 <strchr+0x1e>
      return (char*)s;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	eb 13                	jmp    264 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 251:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	84 c0                	test   %al,%al
 25d:	75 e2                	jne    241 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 25f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <gets>:

char*
gets(char *buf, int max)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 273:	eb 42                	jmp    2b7 <gets+0x51>
    cc = read(0, &c, 1);
 275:	83 ec 04             	sub    $0x4,%esp
 278:	6a 01                	push   $0x1
 27a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 27d:	50                   	push   %eax
 27e:	6a 00                	push   $0x0
 280:	e8 d5 01 00 00       	call   45a <read>
 285:	83 c4 10             	add    $0x10,%esp
 288:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 28b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 28f:	7e 33                	jle    2c4 <gets+0x5e>
      break;
    buf[i++] = c;
 291:	8b 45 f4             	mov    -0xc(%ebp),%eax
 294:	8d 50 01             	lea    0x1(%eax),%edx
 297:	89 55 f4             	mov    %edx,-0xc(%ebp)
 29a:	89 c2                	mov    %eax,%edx
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	01 c2                	add    %eax,%edx
 2a1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ab:	3c 0a                	cmp    $0xa,%al
 2ad:	74 16                	je     2c5 <gets+0x5f>
 2af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b3:	3c 0d                	cmp    $0xd,%al
 2b5:	74 0e                	je     2c5 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ba:	83 c0 01             	add    $0x1,%eax
 2bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c0:	7c b3                	jl     275 <gets+0xf>
 2c2:	eb 01                	jmp    2c5 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2c4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	01 d0                	add    %edx,%eax
 2cd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <stat>:

int
stat(char *n, struct stat *st)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2db:	83 ec 08             	sub    $0x8,%esp
 2de:	6a 00                	push   $0x0
 2e0:	ff 75 08             	pushl  0x8(%ebp)
 2e3:	e8 9a 01 00 00       	call   482 <open>
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f2:	79 07                	jns    2fb <stat+0x26>
    return -1;
 2f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f9:	eb 25                	jmp    320 <stat+0x4b>
  r = fstat(fd, st);
 2fb:	83 ec 08             	sub    $0x8,%esp
 2fe:	ff 75 0c             	pushl  0xc(%ebp)
 301:	ff 75 f4             	pushl  -0xc(%ebp)
 304:	e8 91 01 00 00       	call   49a <fstat>
 309:	83 c4 10             	add    $0x10,%esp
 30c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30f:	83 ec 0c             	sub    $0xc,%esp
 312:	ff 75 f4             	pushl  -0xc(%ebp)
 315:	e8 50 01 00 00       	call   46a <close>
 31a:	83 c4 10             	add    $0x10,%esp
  return r;
 31d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <atoi>:

int
atoi(const char *s)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 328:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32f:	eb 25                	jmp    356 <atoi+0x34>
    n = n*10 + *s++ - '0';
 331:	8b 55 fc             	mov    -0x4(%ebp),%edx
 334:	89 d0                	mov    %edx,%eax
 336:	c1 e0 02             	shl    $0x2,%eax
 339:	01 d0                	add    %edx,%eax
 33b:	01 c0                	add    %eax,%eax
 33d:	89 c1                	mov    %eax,%ecx
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	8d 50 01             	lea    0x1(%eax),%edx
 345:	89 55 08             	mov    %edx,0x8(%ebp)
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	0f be c0             	movsbl %al,%eax
 34e:	01 c8                	add    %ecx,%eax
 350:	83 e8 30             	sub    $0x30,%eax
 353:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	0f b6 00             	movzbl (%eax),%eax
 35c:	3c 2f                	cmp    $0x2f,%al
 35e:	7e 0a                	jle    36a <atoi+0x48>
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	0f b6 00             	movzbl (%eax),%eax
 366:	3c 39                	cmp    $0x39,%al
 368:	7e c7                	jle    331 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 36a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 37b:	8b 45 0c             	mov    0xc(%ebp),%eax
 37e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 381:	eb 17                	jmp    39a <memmove+0x2b>
    *dst++ = *src++;
 383:	8b 45 fc             	mov    -0x4(%ebp),%eax
 386:	8d 50 01             	lea    0x1(%eax),%edx
 389:	89 55 fc             	mov    %edx,-0x4(%ebp)
 38c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38f:	8d 4a 01             	lea    0x1(%edx),%ecx
 392:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 395:	0f b6 12             	movzbl (%edx),%edx
 398:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 39a:	8b 45 10             	mov    0x10(%ebp),%eax
 39d:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a0:	89 55 10             	mov    %edx,0x10(%ebp)
 3a3:	85 c0                	test   %eax,%eax
 3a5:	7f dc                	jg     383 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <atoo>:

int
atoo(const char *s)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3b9:	eb 04                	jmp    3bf <atoo+0x13>
 3bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	0f b6 00             	movzbl (%eax),%eax
 3c5:	3c 20                	cmp    $0x20,%al
 3c7:	74 f2                	je     3bb <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 2d                	cmp    $0x2d,%al
 3d1:	75 07                	jne    3da <atoo+0x2e>
 3d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3d8:	eb 05                	jmp    3df <atoo+0x33>
 3da:	b8 01 00 00 00       	mov    $0x1,%eax
 3df:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	0f b6 00             	movzbl (%eax),%eax
 3e8:	3c 2b                	cmp    $0x2b,%al
 3ea:	74 0a                	je     3f6 <atoo+0x4a>
 3ec:	8b 45 08             	mov    0x8(%ebp),%eax
 3ef:	0f b6 00             	movzbl (%eax),%eax
 3f2:	3c 2d                	cmp    $0x2d,%al
 3f4:	75 27                	jne    41d <atoo+0x71>
    s++;
 3f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3fa:	eb 21                	jmp    41d <atoo+0x71>
    n = n*8 + *s++ - '0';
 3fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ff:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	8d 50 01             	lea    0x1(%eax),%edx
 40c:	89 55 08             	mov    %edx,0x8(%ebp)
 40f:	0f b6 00             	movzbl (%eax),%eax
 412:	0f be c0             	movsbl %al,%eax
 415:	01 c8                	add    %ecx,%eax
 417:	83 e8 30             	sub    $0x30,%eax
 41a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
 420:	0f b6 00             	movzbl (%eax),%eax
 423:	3c 2f                	cmp    $0x2f,%al
 425:	7e 0a                	jle    431 <atoo+0x85>
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	0f b6 00             	movzbl (%eax),%eax
 42d:	3c 37                	cmp    $0x37,%al
 42f:	7e cb                	jle    3fc <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 431:	8b 45 f8             	mov    -0x8(%ebp),%eax
 434:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 438:	c9                   	leave  
 439:	c3                   	ret    

0000043a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 43a:	b8 01 00 00 00       	mov    $0x1,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <exit>:
SYSCALL(exit)
 442:	b8 02 00 00 00       	mov    $0x2,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <wait>:
SYSCALL(wait)
 44a:	b8 03 00 00 00       	mov    $0x3,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <pipe>:
SYSCALL(pipe)
 452:	b8 04 00 00 00       	mov    $0x4,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <read>:
SYSCALL(read)
 45a:	b8 05 00 00 00       	mov    $0x5,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <write>:
SYSCALL(write)
 462:	b8 10 00 00 00       	mov    $0x10,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <close>:
SYSCALL(close)
 46a:	b8 15 00 00 00       	mov    $0x15,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <kill>:
SYSCALL(kill)
 472:	b8 06 00 00 00       	mov    $0x6,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <exec>:
SYSCALL(exec)
 47a:	b8 07 00 00 00       	mov    $0x7,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <open>:
SYSCALL(open)
 482:	b8 0f 00 00 00       	mov    $0xf,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <mknod>:
SYSCALL(mknod)
 48a:	b8 11 00 00 00       	mov    $0x11,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <unlink>:
SYSCALL(unlink)
 492:	b8 12 00 00 00       	mov    $0x12,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <fstat>:
SYSCALL(fstat)
 49a:	b8 08 00 00 00       	mov    $0x8,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <link>:
SYSCALL(link)
 4a2:	b8 13 00 00 00       	mov    $0x13,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <mkdir>:
SYSCALL(mkdir)
 4aa:	b8 14 00 00 00       	mov    $0x14,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <chdir>:
SYSCALL(chdir)
 4b2:	b8 09 00 00 00       	mov    $0x9,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <dup>:
SYSCALL(dup)
 4ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <getpid>:
SYSCALL(getpid)
 4c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <sbrk>:
SYSCALL(sbrk)
 4ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <sleep>:
SYSCALL(sleep)
 4d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <uptime>:
SYSCALL(uptime)
 4da:	b8 0e 00 00 00       	mov    $0xe,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <halt>:
SYSCALL(halt)
 4e2:	b8 16 00 00 00       	mov    $0x16,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 4ea:	b8 17 00 00 00       	mov    $0x17,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 4f2:	b8 18 00 00 00       	mov    $0x18,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 4fa:	b8 19 00 00 00       	mov    $0x19,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 502:	b8 1a 00 00 00       	mov    $0x1a,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 50a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 512:	b8 1c 00 00 00       	mov    $0x1c,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 51a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 522:	b8 1b 00 00 00       	mov    $0x1b,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 52a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 532:	b8 1d 00 00 00       	mov    $0x1d,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 53a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 542:	55                   	push   %ebp
 543:	89 e5                	mov    %esp,%ebp
 545:	83 ec 18             	sub    $0x18,%esp
 548:	8b 45 0c             	mov    0xc(%ebp),%eax
 54b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 54e:	83 ec 04             	sub    $0x4,%esp
 551:	6a 01                	push   $0x1
 553:	8d 45 f4             	lea    -0xc(%ebp),%eax
 556:	50                   	push   %eax
 557:	ff 75 08             	pushl  0x8(%ebp)
 55a:	e8 03 ff ff ff       	call   462 <write>
 55f:	83 c4 10             	add    $0x10,%esp
}
 562:	90                   	nop
 563:	c9                   	leave  
 564:	c3                   	ret    

00000565 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 565:	55                   	push   %ebp
 566:	89 e5                	mov    %esp,%ebp
 568:	53                   	push   %ebx
 569:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 56c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 573:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 577:	74 17                	je     590 <printint+0x2b>
 579:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 57d:	79 11                	jns    590 <printint+0x2b>
    neg = 1;
 57f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 586:	8b 45 0c             	mov    0xc(%ebp),%eax
 589:	f7 d8                	neg    %eax
 58b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 58e:	eb 06                	jmp    596 <printint+0x31>
  } else {
    x = xx;
 590:	8b 45 0c             	mov    0xc(%ebp),%eax
 593:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 596:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 59d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5a0:	8d 41 01             	lea    0x1(%ecx),%eax
 5a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ac:	ba 00 00 00 00       	mov    $0x0,%edx
 5b1:	f7 f3                	div    %ebx
 5b3:	89 d0                	mov    %edx,%eax
 5b5:	0f b6 80 70 0d 00 00 	movzbl 0xd70(%eax),%eax
 5bc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c6:	ba 00 00 00 00       	mov    $0x0,%edx
 5cb:	f7 f3                	div    %ebx
 5cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d4:	75 c7                	jne    59d <printint+0x38>
  if(neg)
 5d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5da:	74 2d                	je     609 <printint+0xa4>
    buf[i++] = '-';
 5dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5df:	8d 50 01             	lea    0x1(%eax),%edx
 5e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5e5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5ea:	eb 1d                	jmp    609 <printint+0xa4>
    putc(fd, buf[i]);
 5ec:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f2:	01 d0                	add    %edx,%eax
 5f4:	0f b6 00             	movzbl (%eax),%eax
 5f7:	0f be c0             	movsbl %al,%eax
 5fa:	83 ec 08             	sub    $0x8,%esp
 5fd:	50                   	push   %eax
 5fe:	ff 75 08             	pushl  0x8(%ebp)
 601:	e8 3c ff ff ff       	call   542 <putc>
 606:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 609:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 60d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 611:	79 d9                	jns    5ec <printint+0x87>
    putc(fd, buf[i]);
}
 613:	90                   	nop
 614:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 617:	c9                   	leave  
 618:	c3                   	ret    

00000619 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 619:	55                   	push   %ebp
 61a:	89 e5                	mov    %esp,%ebp
 61c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 61f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 626:	8d 45 0c             	lea    0xc(%ebp),%eax
 629:	83 c0 04             	add    $0x4,%eax
 62c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 62f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 636:	e9 59 01 00 00       	jmp    794 <printf+0x17b>
    c = fmt[i] & 0xff;
 63b:	8b 55 0c             	mov    0xc(%ebp),%edx
 63e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 641:	01 d0                	add    %edx,%eax
 643:	0f b6 00             	movzbl (%eax),%eax
 646:	0f be c0             	movsbl %al,%eax
 649:	25 ff 00 00 00       	and    $0xff,%eax
 64e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 651:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 655:	75 2c                	jne    683 <printf+0x6a>
      if(c == '%'){
 657:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 65b:	75 0c                	jne    669 <printf+0x50>
        state = '%';
 65d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 664:	e9 27 01 00 00       	jmp    790 <printf+0x177>
      } else {
        putc(fd, c);
 669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66c:	0f be c0             	movsbl %al,%eax
 66f:	83 ec 08             	sub    $0x8,%esp
 672:	50                   	push   %eax
 673:	ff 75 08             	pushl  0x8(%ebp)
 676:	e8 c7 fe ff ff       	call   542 <putc>
 67b:	83 c4 10             	add    $0x10,%esp
 67e:	e9 0d 01 00 00       	jmp    790 <printf+0x177>
      }
    } else if(state == '%'){
 683:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 687:	0f 85 03 01 00 00    	jne    790 <printf+0x177>
      if(c == 'd'){
 68d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 691:	75 1e                	jne    6b1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 693:	8b 45 e8             	mov    -0x18(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	6a 01                	push   $0x1
 69a:	6a 0a                	push   $0xa
 69c:	50                   	push   %eax
 69d:	ff 75 08             	pushl  0x8(%ebp)
 6a0:	e8 c0 fe ff ff       	call   565 <printint>
 6a5:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ac:	e9 d8 00 00 00       	jmp    789 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6b1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6b5:	74 06                	je     6bd <printf+0xa4>
 6b7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6bb:	75 1e                	jne    6db <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	6a 00                	push   $0x0
 6c4:	6a 10                	push   $0x10
 6c6:	50                   	push   %eax
 6c7:	ff 75 08             	pushl  0x8(%ebp)
 6ca:	e8 96 fe ff ff       	call   565 <printint>
 6cf:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d6:	e9 ae 00 00 00       	jmp    789 <printf+0x170>
      } else if(c == 's'){
 6db:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6df:	75 43                	jne    724 <printf+0x10b>
        s = (char*)*ap;
 6e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f1:	75 25                	jne    718 <printf+0xff>
          s = "(null)";
 6f3:	c7 45 f4 6b 0a 00 00 	movl   $0xa6b,-0xc(%ebp)
        while(*s != 0){
 6fa:	eb 1c                	jmp    718 <printf+0xff>
          putc(fd, *s);
 6fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ff:	0f b6 00             	movzbl (%eax),%eax
 702:	0f be c0             	movsbl %al,%eax
 705:	83 ec 08             	sub    $0x8,%esp
 708:	50                   	push   %eax
 709:	ff 75 08             	pushl  0x8(%ebp)
 70c:	e8 31 fe ff ff       	call   542 <putc>
 711:	83 c4 10             	add    $0x10,%esp
          s++;
 714:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 718:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71b:	0f b6 00             	movzbl (%eax),%eax
 71e:	84 c0                	test   %al,%al
 720:	75 da                	jne    6fc <printf+0xe3>
 722:	eb 65                	jmp    789 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 724:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 728:	75 1d                	jne    747 <printf+0x12e>
        putc(fd, *ap);
 72a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 72d:	8b 00                	mov    (%eax),%eax
 72f:	0f be c0             	movsbl %al,%eax
 732:	83 ec 08             	sub    $0x8,%esp
 735:	50                   	push   %eax
 736:	ff 75 08             	pushl  0x8(%ebp)
 739:	e8 04 fe ff ff       	call   542 <putc>
 73e:	83 c4 10             	add    $0x10,%esp
        ap++;
 741:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 745:	eb 42                	jmp    789 <printf+0x170>
      } else if(c == '%'){
 747:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 74b:	75 17                	jne    764 <printf+0x14b>
        putc(fd, c);
 74d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 750:	0f be c0             	movsbl %al,%eax
 753:	83 ec 08             	sub    $0x8,%esp
 756:	50                   	push   %eax
 757:	ff 75 08             	pushl  0x8(%ebp)
 75a:	e8 e3 fd ff ff       	call   542 <putc>
 75f:	83 c4 10             	add    $0x10,%esp
 762:	eb 25                	jmp    789 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 764:	83 ec 08             	sub    $0x8,%esp
 767:	6a 25                	push   $0x25
 769:	ff 75 08             	pushl  0x8(%ebp)
 76c:	e8 d1 fd ff ff       	call   542 <putc>
 771:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 777:	0f be c0             	movsbl %al,%eax
 77a:	83 ec 08             	sub    $0x8,%esp
 77d:	50                   	push   %eax
 77e:	ff 75 08             	pushl  0x8(%ebp)
 781:	e8 bc fd ff ff       	call   542 <putc>
 786:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 789:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 790:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 794:	8b 55 0c             	mov    0xc(%ebp),%edx
 797:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79a:	01 d0                	add    %edx,%eax
 79c:	0f b6 00             	movzbl (%eax),%eax
 79f:	84 c0                	test   %al,%al
 7a1:	0f 85 94 fe ff ff    	jne    63b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7a7:	90                   	nop
 7a8:	c9                   	leave  
 7a9:	c3                   	ret    

000007aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7aa:	55                   	push   %ebp
 7ab:	89 e5                	mov    %esp,%ebp
 7ad:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b0:	8b 45 08             	mov    0x8(%ebp),%eax
 7b3:	83 e8 08             	sub    $0x8,%eax
 7b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b9:	a1 8c 0d 00 00       	mov    0xd8c,%eax
 7be:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c1:	eb 24                	jmp    7e7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cb:	77 12                	ja     7df <free+0x35>
 7cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d3:	77 24                	ja     7f9 <free+0x4f>
 7d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d8:	8b 00                	mov    (%eax),%eax
 7da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7dd:	77 1a                	ja     7f9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	8b 00                	mov    (%eax),%eax
 7e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ed:	76 d4                	jbe    7c3 <free+0x19>
 7ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f2:	8b 00                	mov    (%eax),%eax
 7f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f7:	76 ca                	jbe    7c3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fc:	8b 40 04             	mov    0x4(%eax),%eax
 7ff:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 806:	8b 45 f8             	mov    -0x8(%ebp),%eax
 809:	01 c2                	add    %eax,%edx
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	8b 00                	mov    (%eax),%eax
 810:	39 c2                	cmp    %eax,%edx
 812:	75 24                	jne    838 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 814:	8b 45 f8             	mov    -0x8(%ebp),%eax
 817:	8b 50 04             	mov    0x4(%eax),%edx
 81a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	8b 40 04             	mov    0x4(%eax),%eax
 822:	01 c2                	add    %eax,%edx
 824:	8b 45 f8             	mov    -0x8(%ebp),%eax
 827:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 82a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82d:	8b 00                	mov    (%eax),%eax
 82f:	8b 10                	mov    (%eax),%edx
 831:	8b 45 f8             	mov    -0x8(%ebp),%eax
 834:	89 10                	mov    %edx,(%eax)
 836:	eb 0a                	jmp    842 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 838:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83b:	8b 10                	mov    (%eax),%edx
 83d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 840:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 842:	8b 45 fc             	mov    -0x4(%ebp),%eax
 845:	8b 40 04             	mov    0x4(%eax),%eax
 848:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 84f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 852:	01 d0                	add    %edx,%eax
 854:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 857:	75 20                	jne    879 <free+0xcf>
    p->s.size += bp->s.size;
 859:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85c:	8b 50 04             	mov    0x4(%eax),%edx
 85f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 862:	8b 40 04             	mov    0x4(%eax),%eax
 865:	01 c2                	add    %eax,%edx
 867:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 86d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 870:	8b 10                	mov    (%eax),%edx
 872:	8b 45 fc             	mov    -0x4(%ebp),%eax
 875:	89 10                	mov    %edx,(%eax)
 877:	eb 08                	jmp    881 <free+0xd7>
  } else
    p->s.ptr = bp;
 879:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 87f:	89 10                	mov    %edx,(%eax)
  freep = p;
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	a3 8c 0d 00 00       	mov    %eax,0xd8c
}
 889:	90                   	nop
 88a:	c9                   	leave  
 88b:	c3                   	ret    

0000088c <morecore>:

static Header*
morecore(uint nu)
{
 88c:	55                   	push   %ebp
 88d:	89 e5                	mov    %esp,%ebp
 88f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 892:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 899:	77 07                	ja     8a2 <morecore+0x16>
    nu = 4096;
 89b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8a2:	8b 45 08             	mov    0x8(%ebp),%eax
 8a5:	c1 e0 03             	shl    $0x3,%eax
 8a8:	83 ec 0c             	sub    $0xc,%esp
 8ab:	50                   	push   %eax
 8ac:	e8 19 fc ff ff       	call   4ca <sbrk>
 8b1:	83 c4 10             	add    $0x10,%esp
 8b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8bb:	75 07                	jne    8c4 <morecore+0x38>
    return 0;
 8bd:	b8 00 00 00 00       	mov    $0x0,%eax
 8c2:	eb 26                	jmp    8ea <morecore+0x5e>
  hp = (Header*)p;
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cd:	8b 55 08             	mov    0x8(%ebp),%edx
 8d0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d6:	83 c0 08             	add    $0x8,%eax
 8d9:	83 ec 0c             	sub    $0xc,%esp
 8dc:	50                   	push   %eax
 8dd:	e8 c8 fe ff ff       	call   7aa <free>
 8e2:	83 c4 10             	add    $0x10,%esp
  return freep;
 8e5:	a1 8c 0d 00 00       	mov    0xd8c,%eax
}
 8ea:	c9                   	leave  
 8eb:	c3                   	ret    

000008ec <malloc>:

void*
malloc(uint nbytes)
{
 8ec:	55                   	push   %ebp
 8ed:	89 e5                	mov    %esp,%ebp
 8ef:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f2:	8b 45 08             	mov    0x8(%ebp),%eax
 8f5:	83 c0 07             	add    $0x7,%eax
 8f8:	c1 e8 03             	shr    $0x3,%eax
 8fb:	83 c0 01             	add    $0x1,%eax
 8fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 901:	a1 8c 0d 00 00       	mov    0xd8c,%eax
 906:	89 45 f0             	mov    %eax,-0x10(%ebp)
 909:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 90d:	75 23                	jne    932 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 90f:	c7 45 f0 84 0d 00 00 	movl   $0xd84,-0x10(%ebp)
 916:	8b 45 f0             	mov    -0x10(%ebp),%eax
 919:	a3 8c 0d 00 00       	mov    %eax,0xd8c
 91e:	a1 8c 0d 00 00       	mov    0xd8c,%eax
 923:	a3 84 0d 00 00       	mov    %eax,0xd84
    base.s.size = 0;
 928:	c7 05 88 0d 00 00 00 	movl   $0x0,0xd88
 92f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 932:	8b 45 f0             	mov    -0x10(%ebp),%eax
 935:	8b 00                	mov    (%eax),%eax
 937:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93d:	8b 40 04             	mov    0x4(%eax),%eax
 940:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 943:	72 4d                	jb     992 <malloc+0xa6>
      if(p->s.size == nunits)
 945:	8b 45 f4             	mov    -0xc(%ebp),%eax
 948:	8b 40 04             	mov    0x4(%eax),%eax
 94b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 94e:	75 0c                	jne    95c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 950:	8b 45 f4             	mov    -0xc(%ebp),%eax
 953:	8b 10                	mov    (%eax),%edx
 955:	8b 45 f0             	mov    -0x10(%ebp),%eax
 958:	89 10                	mov    %edx,(%eax)
 95a:	eb 26                	jmp    982 <malloc+0x96>
      else {
        p->s.size -= nunits;
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	8b 40 04             	mov    0x4(%eax),%eax
 962:	2b 45 ec             	sub    -0x14(%ebp),%eax
 965:	89 c2                	mov    %eax,%edx
 967:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 970:	8b 40 04             	mov    0x4(%eax),%eax
 973:	c1 e0 03             	shl    $0x3,%eax
 976:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 979:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 97f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 982:	8b 45 f0             	mov    -0x10(%ebp),%eax
 985:	a3 8c 0d 00 00       	mov    %eax,0xd8c
      return (void*)(p + 1);
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	83 c0 08             	add    $0x8,%eax
 990:	eb 3b                	jmp    9cd <malloc+0xe1>
    }
    if(p == freep)
 992:	a1 8c 0d 00 00       	mov    0xd8c,%eax
 997:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 99a:	75 1e                	jne    9ba <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 99c:	83 ec 0c             	sub    $0xc,%esp
 99f:	ff 75 ec             	pushl  -0x14(%ebp)
 9a2:	e8 e5 fe ff ff       	call   88c <morecore>
 9a7:	83 c4 10             	add    $0x10,%esp
 9aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b1:	75 07                	jne    9ba <malloc+0xce>
        return 0;
 9b3:	b8 00 00 00 00       	mov    $0x0,%eax
 9b8:	eb 13                	jmp    9cd <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c3:	8b 00                	mov    (%eax),%eax
 9c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9c8:	e9 6d ff ff ff       	jmp    93a <malloc+0x4e>
}
 9cd:	c9                   	leave  
 9ce:	c3                   	ret    
