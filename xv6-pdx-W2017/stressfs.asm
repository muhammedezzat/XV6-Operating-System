
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 c4 09 00 00       	push   $0x9c4
  30:	6a 01                	push   $0x1
  32:	e8 d7 05 00 00       	call   60e <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 be 01 00 00       	call   20e <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0d                	jmp    69 <main+0x69>
    if(fork() > 0)
  5c:	e8 ce 03 00 00       	call   42f <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7f 0c                	jg     71 <main+0x71>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  69:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6d:	7e ed                	jle    5c <main+0x5c>
  6f:	eb 01                	jmp    72 <main+0x72>
    if(fork() > 0)
      break;
  71:	90                   	nop

  printf(1, "write %d\n", i);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f4             	pushl  -0xc(%ebp)
  78:	68 d7 09 00 00       	push   $0x9d7
  7d:	6a 01                	push   $0x1
  7f:	e8 8a 05 00 00       	call   60e <printf>
  84:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  87:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
  92:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 02 02 00 00       	push   $0x202
  9d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	e8 d1 03 00 00       	call   477 <open>
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b3:	eb 1e                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b5:	83 ec 04             	sub    $0x4,%esp
  b8:	68 00 02 00 00       	push   $0x200
  bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	ff 75 f0             	pushl  -0x10(%ebp)
  c7:	e8 8b 03 00 00       	call   457 <write>
  cc:	83 c4 10             	add    $0x10,%esp

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d7:	7e dc                	jle    b5 <main+0xb5>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 f0             	pushl  -0x10(%ebp)
  df:	e8 7b 03 00 00       	call   45f <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 e1 09 00 00       	push   $0x9e1
  ef:	6a 01                	push   $0x1
  f1:	e8 18 05 00 00       	call   60e <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 70 03 00 00       	call   477 <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 114:	eb 1e                	jmp    134 <main+0x134>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 f0             	pushl  -0x10(%ebp)
 128:	e8 22 03 00 00       	call   44f <read>
 12d:	83 c4 10             	add    $0x10,%esp
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 138:	7e dc                	jle    116 <main+0x116>
    read(fd, data, sizeof(data));
  close(fd);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 f0             	pushl  -0x10(%ebp)
 140:	e8 1a 03 00 00       	call   45f <close>
 145:	83 c4 10             	add    $0x10,%esp

  wait();
 148:	e8 f2 02 00 00       	call   43f <wait>
  
  exit();
 14d:	e8 e5 02 00 00       	call   437 <exit>

00000152 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15a:	8b 55 10             	mov    0x10(%ebp),%edx
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	89 cb                	mov    %ecx,%ebx
 162:	89 df                	mov    %ebx,%edi
 164:	89 d1                	mov    %edx,%ecx
 166:	fc                   	cld    
 167:	f3 aa                	rep stos %al,%es:(%edi)
 169:	89 ca                	mov    %ecx,%edx
 16b:	89 fb                	mov    %edi,%ebx
 16d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 170:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 173:	90                   	nop
 174:	5b                   	pop    %ebx
 175:	5f                   	pop    %edi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    

00000178 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 184:	90                   	nop
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8d 50 01             	lea    0x1(%eax),%edx
 18b:	89 55 08             	mov    %edx,0x8(%ebp)
 18e:	8b 55 0c             	mov    0xc(%ebp),%edx
 191:	8d 4a 01             	lea    0x1(%edx),%ecx
 194:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 197:	0f b6 12             	movzbl (%edx),%edx
 19a:	88 10                	mov    %dl,(%eax)
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	75 e2                	jne    185 <strcpy+0xd>
    ;
  return os;
 1a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ab:	eb 08                	jmp    1b5 <strcmp+0xd>
    p++, q++;
 1ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	74 10                	je     1cf <strcmp+0x27>
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 10             	movzbl (%eax),%edx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	38 c2                	cmp    %al,%dl
 1cd:	74 de                	je     1ad <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	0f b6 d0             	movzbl %al,%edx
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	0f b6 c0             	movzbl %al,%eax
 1e1:	29 c2                	sub    %eax,%edx
 1e3:	89 d0                	mov    %edx,%eax
}
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    

000001e7 <strlen>:

uint
strlen(char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f4:	eb 04                	jmp    1fa <strlen+0x13>
 1f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	84 c0                	test   %al,%al
 207:	75 ed                	jne    1f6 <strlen+0xf>
    ;
  return n;
 209:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <memset>:

void*
memset(void *dst, int c, uint n)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 211:	8b 45 10             	mov    0x10(%ebp),%eax
 214:	50                   	push   %eax
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 08             	pushl  0x8(%ebp)
 21b:	e8 32 ff ff ff       	call   152 <stosb>
 220:	83 c4 0c             	add    $0xc,%esp
  return dst;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <strchr>:

char*
strchr(const char *s, char c)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 234:	eb 14                	jmp    24a <strchr+0x22>
    if(*s == c)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 23f:	75 05                	jne    246 <strchr+0x1e>
      return (char*)s;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	eb 13                	jmp    259 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 e2                	jne    236 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <gets>:

char*
gets(char *buf, int max)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 268:	eb 42                	jmp    2ac <gets+0x51>
    cc = read(0, &c, 1);
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	6a 01                	push   $0x1
 26f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 272:	50                   	push   %eax
 273:	6a 00                	push   $0x0
 275:	e8 d5 01 00 00       	call   44f <read>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	7e 33                	jle    2b9 <gets+0x5e>
      break;
    buf[i++] = c;
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 c2                	add    %eax,%edx
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 16                	je     2ba <gets+0x5f>
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0d                	cmp    $0xd,%al
 2aa:	74 0e                	je     2ba <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b5:	7c b3                	jl     26a <gets+0xf>
 2b7:	eb 01                	jmp    2ba <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2b9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <stat>:

int
stat(char *n, struct stat *st)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	83 ec 08             	sub    $0x8,%esp
 2d3:	6a 00                	push   $0x0
 2d5:	ff 75 08             	pushl  0x8(%ebp)
 2d8:	e8 9a 01 00 00       	call   477 <open>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e7:	79 07                	jns    2f0 <stat+0x26>
    return -1;
 2e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ee:	eb 25                	jmp    315 <stat+0x4b>
  r = fstat(fd, st);
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	ff 75 0c             	pushl  0xc(%ebp)
 2f6:	ff 75 f4             	pushl  -0xc(%ebp)
 2f9:	e8 91 01 00 00       	call   48f <fstat>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 304:	83 ec 0c             	sub    $0xc,%esp
 307:	ff 75 f4             	pushl  -0xc(%ebp)
 30a:	e8 50 01 00 00       	call   45f <close>
 30f:	83 c4 10             	add    $0x10,%esp
  return r;
 312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <atoi>:

int
atoi(const char *s)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	eb 25                	jmp    34b <atoi+0x34>
    n = n*10 + *s++ - '0';
 326:	8b 55 fc             	mov    -0x4(%ebp),%edx
 329:	89 d0                	mov    %edx,%eax
 32b:	c1 e0 02             	shl    $0x2,%eax
 32e:	01 d0                	add    %edx,%eax
 330:	01 c0                	add    %eax,%eax
 332:	89 c1                	mov    %eax,%ecx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 08             	mov    %edx,0x8(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	01 c8                	add    %ecx,%eax
 345:	83 e8 30             	sub    $0x30,%eax
 348:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 2f                	cmp    $0x2f,%al
 353:	7e 0a                	jle    35f <atoi+0x48>
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 39                	cmp    $0x39,%al
 35d:	7e c7                	jle    326 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 35f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 376:	eb 17                	jmp    38f <memmove+0x2b>
    *dst++ = *src++;
 378:	8b 45 fc             	mov    -0x4(%ebp),%eax
 37b:	8d 50 01             	lea    0x1(%eax),%edx
 37e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 381:	8b 55 f8             	mov    -0x8(%ebp),%edx
 384:	8d 4a 01             	lea    0x1(%edx),%ecx
 387:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 38a:	0f b6 12             	movzbl (%edx),%edx
 38d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38f:	8b 45 10             	mov    0x10(%ebp),%eax
 392:	8d 50 ff             	lea    -0x1(%eax),%edx
 395:	89 55 10             	mov    %edx,0x10(%ebp)
 398:	85 c0                	test   %eax,%eax
 39a:	7f dc                	jg     378 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    

000003a1 <atoo>:

int
atoo(const char *s)
{
 3a1:	55                   	push   %ebp
 3a2:	89 e5                	mov    %esp,%ebp
 3a4:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3ae:	eb 04                	jmp    3b4 <atoo+0x13>
 3b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	0f b6 00             	movzbl (%eax),%eax
 3ba:	3c 20                	cmp    $0x20,%al
 3bc:	74 f2                	je     3b0 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 3be:	8b 45 08             	mov    0x8(%ebp),%eax
 3c1:	0f b6 00             	movzbl (%eax),%eax
 3c4:	3c 2d                	cmp    $0x2d,%al
 3c6:	75 07                	jne    3cf <atoo+0x2e>
 3c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3cd:	eb 05                	jmp    3d4 <atoo+0x33>
 3cf:	b8 01 00 00 00       	mov    $0x1,%eax
 3d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	3c 2b                	cmp    $0x2b,%al
 3df:	74 0a                	je     3eb <atoo+0x4a>
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	0f b6 00             	movzbl (%eax),%eax
 3e7:	3c 2d                	cmp    $0x2d,%al
 3e9:	75 27                	jne    412 <atoo+0x71>
    s++;
 3eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3ef:	eb 21                	jmp    412 <atoo+0x71>
    n = n*8 + *s++ - '0';
 3f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3fb:	8b 45 08             	mov    0x8(%ebp),%eax
 3fe:	8d 50 01             	lea    0x1(%eax),%edx
 401:	89 55 08             	mov    %edx,0x8(%ebp)
 404:	0f b6 00             	movzbl (%eax),%eax
 407:	0f be c0             	movsbl %al,%eax
 40a:	01 c8                	add    %ecx,%eax
 40c:	83 e8 30             	sub    $0x30,%eax
 40f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	0f b6 00             	movzbl (%eax),%eax
 418:	3c 2f                	cmp    $0x2f,%al
 41a:	7e 0a                	jle    426 <atoo+0x85>
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	0f b6 00             	movzbl (%eax),%eax
 422:	3c 37                	cmp    $0x37,%al
 424:	7e cb                	jle    3f1 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 426:	8b 45 f8             	mov    -0x8(%ebp),%eax
 429:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 42d:	c9                   	leave  
 42e:	c3                   	ret    

0000042f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42f:	b8 01 00 00 00       	mov    $0x1,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <exit>:
SYSCALL(exit)
 437:	b8 02 00 00 00       	mov    $0x2,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <wait>:
SYSCALL(wait)
 43f:	b8 03 00 00 00       	mov    $0x3,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <pipe>:
SYSCALL(pipe)
 447:	b8 04 00 00 00       	mov    $0x4,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <read>:
SYSCALL(read)
 44f:	b8 05 00 00 00       	mov    $0x5,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <write>:
SYSCALL(write)
 457:	b8 10 00 00 00       	mov    $0x10,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <close>:
SYSCALL(close)
 45f:	b8 15 00 00 00       	mov    $0x15,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <kill>:
SYSCALL(kill)
 467:	b8 06 00 00 00       	mov    $0x6,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <exec>:
SYSCALL(exec)
 46f:	b8 07 00 00 00       	mov    $0x7,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <open>:
SYSCALL(open)
 477:	b8 0f 00 00 00       	mov    $0xf,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <mknod>:
SYSCALL(mknod)
 47f:	b8 11 00 00 00       	mov    $0x11,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <unlink>:
SYSCALL(unlink)
 487:	b8 12 00 00 00       	mov    $0x12,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <fstat>:
SYSCALL(fstat)
 48f:	b8 08 00 00 00       	mov    $0x8,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <link>:
SYSCALL(link)
 497:	b8 13 00 00 00       	mov    $0x13,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <mkdir>:
SYSCALL(mkdir)
 49f:	b8 14 00 00 00       	mov    $0x14,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <chdir>:
SYSCALL(chdir)
 4a7:	b8 09 00 00 00       	mov    $0x9,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <dup>:
SYSCALL(dup)
 4af:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <getpid>:
SYSCALL(getpid)
 4b7:	b8 0b 00 00 00       	mov    $0xb,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <sbrk>:
SYSCALL(sbrk)
 4bf:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <sleep>:
SYSCALL(sleep)
 4c7:	b8 0d 00 00 00       	mov    $0xd,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <uptime>:
SYSCALL(uptime)
 4cf:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <halt>:
SYSCALL(halt)
 4d7:	b8 16 00 00 00       	mov    $0x16,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 4df:	b8 17 00 00 00       	mov    $0x17,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 4e7:	b8 18 00 00 00       	mov    $0x18,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 4ef:	b8 19 00 00 00       	mov    $0x19,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 4f7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 4ff:	b8 1b 00 00 00       	mov    $0x1b,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 507:	b8 1c 00 00 00       	mov    $0x1c,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 50f:	b8 1d 00 00 00       	mov    $0x1d,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 517:	b8 1e 00 00 00       	mov    $0x1e,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 51f:	b8 1f 00 00 00       	mov    $0x1f,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 527:	b8 20 00 00 00       	mov    $0x20,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 52f:	b8 21 00 00 00       	mov    $0x21,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 537:	55                   	push   %ebp
 538:	89 e5                	mov    %esp,%ebp
 53a:	83 ec 18             	sub    $0x18,%esp
 53d:	8b 45 0c             	mov    0xc(%ebp),%eax
 540:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 543:	83 ec 04             	sub    $0x4,%esp
 546:	6a 01                	push   $0x1
 548:	8d 45 f4             	lea    -0xc(%ebp),%eax
 54b:	50                   	push   %eax
 54c:	ff 75 08             	pushl  0x8(%ebp)
 54f:	e8 03 ff ff ff       	call   457 <write>
 554:	83 c4 10             	add    $0x10,%esp
}
 557:	90                   	nop
 558:	c9                   	leave  
 559:	c3                   	ret    

0000055a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55a:	55                   	push   %ebp
 55b:	89 e5                	mov    %esp,%ebp
 55d:	53                   	push   %ebx
 55e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 561:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 568:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 56c:	74 17                	je     585 <printint+0x2b>
 56e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 572:	79 11                	jns    585 <printint+0x2b>
    neg = 1;
 574:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 57b:	8b 45 0c             	mov    0xc(%ebp),%eax
 57e:	f7 d8                	neg    %eax
 580:	89 45 ec             	mov    %eax,-0x14(%ebp)
 583:	eb 06                	jmp    58b <printint+0x31>
  } else {
    x = xx;
 585:	8b 45 0c             	mov    0xc(%ebp),%eax
 588:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 58b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 592:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 595:	8d 41 01             	lea    0x1(%ecx),%eax
 598:	89 45 f4             	mov    %eax,-0xc(%ebp)
 59b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 59e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a1:	ba 00 00 00 00       	mov    $0x0,%edx
 5a6:	f7 f3                	div    %ebx
 5a8:	89 d0                	mov    %edx,%eax
 5aa:	0f b6 80 58 0c 00 00 	movzbl 0xc58(%eax),%eax
 5b1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5bb:	ba 00 00 00 00       	mov    $0x0,%edx
 5c0:	f7 f3                	div    %ebx
 5c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c9:	75 c7                	jne    592 <printint+0x38>
  if(neg)
 5cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5cf:	74 2d                	je     5fe <printint+0xa4>
    buf[i++] = '-';
 5d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d4:	8d 50 01             	lea    0x1(%eax),%edx
 5d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5da:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5df:	eb 1d                	jmp    5fe <printint+0xa4>
    putc(fd, buf[i]);
 5e1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e7:	01 d0                	add    %edx,%eax
 5e9:	0f b6 00             	movzbl (%eax),%eax
 5ec:	0f be c0             	movsbl %al,%eax
 5ef:	83 ec 08             	sub    $0x8,%esp
 5f2:	50                   	push   %eax
 5f3:	ff 75 08             	pushl  0x8(%ebp)
 5f6:	e8 3c ff ff ff       	call   537 <putc>
 5fb:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5fe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 606:	79 d9                	jns    5e1 <printint+0x87>
    putc(fd, buf[i]);
}
 608:	90                   	nop
 609:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 60c:	c9                   	leave  
 60d:	c3                   	ret    

0000060e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 60e:	55                   	push   %ebp
 60f:	89 e5                	mov    %esp,%ebp
 611:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 614:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 61b:	8d 45 0c             	lea    0xc(%ebp),%eax
 61e:	83 c0 04             	add    $0x4,%eax
 621:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 624:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 62b:	e9 59 01 00 00       	jmp    789 <printf+0x17b>
    c = fmt[i] & 0xff;
 630:	8b 55 0c             	mov    0xc(%ebp),%edx
 633:	8b 45 f0             	mov    -0x10(%ebp),%eax
 636:	01 d0                	add    %edx,%eax
 638:	0f b6 00             	movzbl (%eax),%eax
 63b:	0f be c0             	movsbl %al,%eax
 63e:	25 ff 00 00 00       	and    $0xff,%eax
 643:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 646:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 64a:	75 2c                	jne    678 <printf+0x6a>
      if(c == '%'){
 64c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 650:	75 0c                	jne    65e <printf+0x50>
        state = '%';
 652:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 659:	e9 27 01 00 00       	jmp    785 <printf+0x177>
      } else {
        putc(fd, c);
 65e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 661:	0f be c0             	movsbl %al,%eax
 664:	83 ec 08             	sub    $0x8,%esp
 667:	50                   	push   %eax
 668:	ff 75 08             	pushl  0x8(%ebp)
 66b:	e8 c7 fe ff ff       	call   537 <putc>
 670:	83 c4 10             	add    $0x10,%esp
 673:	e9 0d 01 00 00       	jmp    785 <printf+0x177>
      }
    } else if(state == '%'){
 678:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 67c:	0f 85 03 01 00 00    	jne    785 <printf+0x177>
      if(c == 'd'){
 682:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 686:	75 1e                	jne    6a6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 688:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	6a 01                	push   $0x1
 68f:	6a 0a                	push   $0xa
 691:	50                   	push   %eax
 692:	ff 75 08             	pushl  0x8(%ebp)
 695:	e8 c0 fe ff ff       	call   55a <printint>
 69a:	83 c4 10             	add    $0x10,%esp
        ap++;
 69d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a1:	e9 d8 00 00 00       	jmp    77e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6a6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6aa:	74 06                	je     6b2 <printf+0xa4>
 6ac:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b0:	75 1e                	jne    6d0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	6a 00                	push   $0x0
 6b9:	6a 10                	push   $0x10
 6bb:	50                   	push   %eax
 6bc:	ff 75 08             	pushl  0x8(%ebp)
 6bf:	e8 96 fe ff ff       	call   55a <printint>
 6c4:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cb:	e9 ae 00 00 00       	jmp    77e <printf+0x170>
      } else if(c == 's'){
 6d0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6d4:	75 43                	jne    719 <printf+0x10b>
        s = (char*)*ap;
 6d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e6:	75 25                	jne    70d <printf+0xff>
          s = "(null)";
 6e8:	c7 45 f4 e7 09 00 00 	movl   $0x9e7,-0xc(%ebp)
        while(*s != 0){
 6ef:	eb 1c                	jmp    70d <printf+0xff>
          putc(fd, *s);
 6f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f4:	0f b6 00             	movzbl (%eax),%eax
 6f7:	0f be c0             	movsbl %al,%eax
 6fa:	83 ec 08             	sub    $0x8,%esp
 6fd:	50                   	push   %eax
 6fe:	ff 75 08             	pushl  0x8(%ebp)
 701:	e8 31 fe ff ff       	call   537 <putc>
 706:	83 c4 10             	add    $0x10,%esp
          s++;
 709:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	0f b6 00             	movzbl (%eax),%eax
 713:	84 c0                	test   %al,%al
 715:	75 da                	jne    6f1 <printf+0xe3>
 717:	eb 65                	jmp    77e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 719:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 71d:	75 1d                	jne    73c <printf+0x12e>
        putc(fd, *ap);
 71f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	0f be c0             	movsbl %al,%eax
 727:	83 ec 08             	sub    $0x8,%esp
 72a:	50                   	push   %eax
 72b:	ff 75 08             	pushl  0x8(%ebp)
 72e:	e8 04 fe ff ff       	call   537 <putc>
 733:	83 c4 10             	add    $0x10,%esp
        ap++;
 736:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73a:	eb 42                	jmp    77e <printf+0x170>
      } else if(c == '%'){
 73c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 740:	75 17                	jne    759 <printf+0x14b>
        putc(fd, c);
 742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 745:	0f be c0             	movsbl %al,%eax
 748:	83 ec 08             	sub    $0x8,%esp
 74b:	50                   	push   %eax
 74c:	ff 75 08             	pushl  0x8(%ebp)
 74f:	e8 e3 fd ff ff       	call   537 <putc>
 754:	83 c4 10             	add    $0x10,%esp
 757:	eb 25                	jmp    77e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 759:	83 ec 08             	sub    $0x8,%esp
 75c:	6a 25                	push   $0x25
 75e:	ff 75 08             	pushl  0x8(%ebp)
 761:	e8 d1 fd ff ff       	call   537 <putc>
 766:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76c:	0f be c0             	movsbl %al,%eax
 76f:	83 ec 08             	sub    $0x8,%esp
 772:	50                   	push   %eax
 773:	ff 75 08             	pushl  0x8(%ebp)
 776:	e8 bc fd ff ff       	call   537 <putc>
 77b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 77e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 785:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 789:	8b 55 0c             	mov    0xc(%ebp),%edx
 78c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78f:	01 d0                	add    %edx,%eax
 791:	0f b6 00             	movzbl (%eax),%eax
 794:	84 c0                	test   %al,%al
 796:	0f 85 94 fe ff ff    	jne    630 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 79c:	90                   	nop
 79d:	c9                   	leave  
 79e:	c3                   	ret    

0000079f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79f:	55                   	push   %ebp
 7a0:	89 e5                	mov    %esp,%ebp
 7a2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	83 e8 08             	sub    $0x8,%eax
 7ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	a1 74 0c 00 00       	mov    0xc74,%eax
 7b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b6:	eb 24                	jmp    7dc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c0:	77 12                	ja     7d4 <free+0x35>
 7c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c8:	77 24                	ja     7ee <free+0x4f>
 7ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cd:	8b 00                	mov    (%eax),%eax
 7cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d2:	77 1a                	ja     7ee <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e2:	76 d4                	jbe    7b8 <free+0x19>
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ec:	76 ca                	jbe    7b8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	01 c2                	add    %eax,%edx
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 00                	mov    (%eax),%eax
 805:	39 c2                	cmp    %eax,%edx
 807:	75 24                	jne    82d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	8b 50 04             	mov    0x4(%eax),%edx
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	01 c2                	add    %eax,%edx
 819:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	8b 10                	mov    (%eax),%edx
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	89 10                	mov    %edx,(%eax)
 82b:	eb 0a                	jmp    837 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 10                	mov    (%eax),%edx
 832:	8b 45 f8             	mov    -0x8(%ebp),%eax
 835:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 40 04             	mov    0x4(%eax),%eax
 83d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 844:	8b 45 fc             	mov    -0x4(%ebp),%eax
 847:	01 d0                	add    %edx,%eax
 849:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 84c:	75 20                	jne    86e <free+0xcf>
    p->s.size += bp->s.size;
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	8b 50 04             	mov    0x4(%eax),%edx
 854:	8b 45 f8             	mov    -0x8(%ebp),%eax
 857:	8b 40 04             	mov    0x4(%eax),%eax
 85a:	01 c2                	add    %eax,%edx
 85c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 45 f8             	mov    -0x8(%ebp),%eax
 865:	8b 10                	mov    (%eax),%edx
 867:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86a:	89 10                	mov    %edx,(%eax)
 86c:	eb 08                	jmp    876 <free+0xd7>
  } else
    p->s.ptr = bp;
 86e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 871:	8b 55 f8             	mov    -0x8(%ebp),%edx
 874:	89 10                	mov    %edx,(%eax)
  freep = p;
 876:	8b 45 fc             	mov    -0x4(%ebp),%eax
 879:	a3 74 0c 00 00       	mov    %eax,0xc74
}
 87e:	90                   	nop
 87f:	c9                   	leave  
 880:	c3                   	ret    

00000881 <morecore>:

static Header*
morecore(uint nu)
{
 881:	55                   	push   %ebp
 882:	89 e5                	mov    %esp,%ebp
 884:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 887:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 88e:	77 07                	ja     897 <morecore+0x16>
    nu = 4096;
 890:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 897:	8b 45 08             	mov    0x8(%ebp),%eax
 89a:	c1 e0 03             	shl    $0x3,%eax
 89d:	83 ec 0c             	sub    $0xc,%esp
 8a0:	50                   	push   %eax
 8a1:	e8 19 fc ff ff       	call   4bf <sbrk>
 8a6:	83 c4 10             	add    $0x10,%esp
 8a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b0:	75 07                	jne    8b9 <morecore+0x38>
    return 0;
 8b2:	b8 00 00 00 00       	mov    $0x0,%eax
 8b7:	eb 26                	jmp    8df <morecore+0x5e>
  hp = (Header*)p;
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c2:	8b 55 08             	mov    0x8(%ebp),%edx
 8c5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cb:	83 c0 08             	add    $0x8,%eax
 8ce:	83 ec 0c             	sub    $0xc,%esp
 8d1:	50                   	push   %eax
 8d2:	e8 c8 fe ff ff       	call   79f <free>
 8d7:	83 c4 10             	add    $0x10,%esp
  return freep;
 8da:	a1 74 0c 00 00       	mov    0xc74,%eax
}
 8df:	c9                   	leave  
 8e0:	c3                   	ret    

000008e1 <malloc>:

void*
malloc(uint nbytes)
{
 8e1:	55                   	push   %ebp
 8e2:	89 e5                	mov    %esp,%ebp
 8e4:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ea:	83 c0 07             	add    $0x7,%eax
 8ed:	c1 e8 03             	shr    $0x3,%eax
 8f0:	83 c0 01             	add    $0x1,%eax
 8f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8f6:	a1 74 0c 00 00       	mov    0xc74,%eax
 8fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 902:	75 23                	jne    927 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 904:	c7 45 f0 6c 0c 00 00 	movl   $0xc6c,-0x10(%ebp)
 90b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90e:	a3 74 0c 00 00       	mov    %eax,0xc74
 913:	a1 74 0c 00 00       	mov    0xc74,%eax
 918:	a3 6c 0c 00 00       	mov    %eax,0xc6c
    base.s.size = 0;
 91d:	c7 05 70 0c 00 00 00 	movl   $0x0,0xc70
 924:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 927:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	8b 40 04             	mov    0x4(%eax),%eax
 935:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 938:	72 4d                	jb     987 <malloc+0xa6>
      if(p->s.size == nunits)
 93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93d:	8b 40 04             	mov    0x4(%eax),%eax
 940:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 943:	75 0c                	jne    951 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 945:	8b 45 f4             	mov    -0xc(%ebp),%eax
 948:	8b 10                	mov    (%eax),%edx
 94a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94d:	89 10                	mov    %edx,(%eax)
 94f:	eb 26                	jmp    977 <malloc+0x96>
      else {
        p->s.size -= nunits;
 951:	8b 45 f4             	mov    -0xc(%ebp),%eax
 954:	8b 40 04             	mov    0x4(%eax),%eax
 957:	2b 45 ec             	sub    -0x14(%ebp),%eax
 95a:	89 c2                	mov    %eax,%edx
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	c1 e0 03             	shl    $0x3,%eax
 96b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 96e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 971:	8b 55 ec             	mov    -0x14(%ebp),%edx
 974:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 977:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97a:	a3 74 0c 00 00       	mov    %eax,0xc74
      return (void*)(p + 1);
 97f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 982:	83 c0 08             	add    $0x8,%eax
 985:	eb 3b                	jmp    9c2 <malloc+0xe1>
    }
    if(p == freep)
 987:	a1 74 0c 00 00       	mov    0xc74,%eax
 98c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 98f:	75 1e                	jne    9af <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 991:	83 ec 0c             	sub    $0xc,%esp
 994:	ff 75 ec             	pushl  -0x14(%ebp)
 997:	e8 e5 fe ff ff       	call   881 <morecore>
 99c:	83 c4 10             	add    $0x10,%esp
 99f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a6:	75 07                	jne    9af <malloc+0xce>
        return 0;
 9a8:	b8 00 00 00 00       	mov    $0x0,%eax
 9ad:	eb 13                	jmp    9c2 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b8:	8b 00                	mov    (%eax),%eax
 9ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9bd:	e9 6d ff ff ff       	jmp    92f <malloc+0x4e>
}
 9c2:	c9                   	leave  
 9c3:	c3                   	ret    
