
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 40 0d 00 00       	add    $0xd40,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 40 0d 00 00       	add    $0xd40,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 2f 0a 00 00       	push   $0xa2f
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 40 0d 00 00       	push   $0xd40
  98:	ff 75 08             	pushl  0x8(%ebp)
  9b:	e8 1a 04 00 00       	call   4ba <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 35 0a 00 00       	push   $0xa35
  be:	6a 01                	push   $0x1
  c0:	e8 b4 05 00 00       	call   679 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 d5 03 00 00       	call   4a2 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	pushl  0xc(%ebp)
  d3:	ff 75 e8             	pushl  -0x18(%ebp)
  d6:	ff 75 ec             	pushl  -0x14(%ebp)
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	68 45 0a 00 00       	push   $0xa45
  e1:	6a 01                	push   $0x1
  e3:	e8 91 05 00 00       	call   679 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	pushl  -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 52 0a 00 00       	push   $0xa52
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 84 03 00 00       	call   4a2 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 9c 03 00 00       	call   4e2 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 53 0a 00 00       	push   $0xa53
 16c:	6a 01                	push   $0x1
 16e:	e8 06 05 00 00       	call   679 <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 27 03 00 00       	call   4a2 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	pushl  -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	pushl  -0x10(%ebp)
 1a1:	e8 24 03 00 00       	call   4ca <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1b8:	e8 e5 02 00 00       	call   4a2 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 08             	mov    %edx,0x8(%ebp)
 1f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fc:	8d 4a 01             	lea    0x1(%edx),%ecx
 1ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c0             	movzbl %al,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    

00000252 <strlen>:

uint
strlen(char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	pushl  0xc(%ebp)
 283:	ff 75 08             	pushl  0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 d5 01 00 00       	call   4ba <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 320:	7c b3                	jl     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 324:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <stat>:

int
stat(char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	pushl  0x8(%ebp)
 343:	e8 9a 01 00 00       	call   4e2 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	pushl  0xc(%ebp)
 361:	ff 75 f4             	pushl  -0xc(%ebp)
 364:	e8 91 01 00 00       	call   4fa <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	pushl  -0xc(%ebp)
 375:	e8 50 01 00 00       	call   4ca <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38f:	eb 25                	jmp    3b6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 391:	8b 55 fc             	mov    -0x4(%ebp),%edx
 394:	89 d0                	mov    %edx,%eax
 396:	c1 e0 02             	shl    $0x2,%eax
 399:	01 d0                	add    %edx,%eax
 39b:	01 c0                	add    %eax,%eax
 39d:	89 c1                	mov    %eax,%ecx
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8d 50 01             	lea    0x1(%eax),%edx
 3a5:	89 55 08             	mov    %edx,0x8(%ebp)
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	0f be c0             	movsbl %al,%eax
 3ae:	01 c8                	add    %ecx,%eax
 3b0:	83 e8 30             	sub    $0x30,%eax
 3b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	3c 2f                	cmp    $0x2f,%al
 3be:	7e 0a                	jle    3ca <atoi+0x48>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	3c 39                	cmp    $0x39,%al
 3c8:	7e c7                	jle    391 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e1:	eb 17                	jmp    3fa <memmove+0x2b>
    *dst++ = *src++;
 3e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e6:	8d 50 01             	lea    0x1(%eax),%edx
 3e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ef:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3f5:	0f b6 12             	movzbl (%edx),%edx
 3f8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3fa:	8b 45 10             	mov    0x10(%ebp),%eax
 3fd:	8d 50 ff             	lea    -0x1(%eax),%edx
 400:	89 55 10             	mov    %edx,0x10(%ebp)
 403:	85 c0                	test   %eax,%eax
 405:	7f dc                	jg     3e3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <atoo>:

int
atoo(const char *s)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 412:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 419:	eb 04                	jmp    41f <atoo+0x13>
 41b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	0f b6 00             	movzbl (%eax),%eax
 425:	3c 20                	cmp    $0x20,%al
 427:	74 f2                	je     41b <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 429:	8b 45 08             	mov    0x8(%ebp),%eax
 42c:	0f b6 00             	movzbl (%eax),%eax
 42f:	3c 2d                	cmp    $0x2d,%al
 431:	75 07                	jne    43a <atoo+0x2e>
 433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 438:	eb 05                	jmp    43f <atoo+0x33>
 43a:	b8 01 00 00 00       	mov    $0x1,%eax
 43f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	0f b6 00             	movzbl (%eax),%eax
 448:	3c 2b                	cmp    $0x2b,%al
 44a:	74 0a                	je     456 <atoo+0x4a>
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
 44f:	0f b6 00             	movzbl (%eax),%eax
 452:	3c 2d                	cmp    $0x2d,%al
 454:	75 27                	jne    47d <atoo+0x71>
    s++;
 456:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 45a:	eb 21                	jmp    47d <atoo+0x71>
    n = n*8 + *s++ - '0';
 45c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 45f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 466:	8b 45 08             	mov    0x8(%ebp),%eax
 469:	8d 50 01             	lea    0x1(%eax),%edx
 46c:	89 55 08             	mov    %edx,0x8(%ebp)
 46f:	0f b6 00             	movzbl (%eax),%eax
 472:	0f be c0             	movsbl %al,%eax
 475:	01 c8                	add    %ecx,%eax
 477:	83 e8 30             	sub    $0x30,%eax
 47a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	0f b6 00             	movzbl (%eax),%eax
 483:	3c 2f                	cmp    $0x2f,%al
 485:	7e 0a                	jle    491 <atoo+0x85>
 487:	8b 45 08             	mov    0x8(%ebp),%eax
 48a:	0f b6 00             	movzbl (%eax),%eax
 48d:	3c 37                	cmp    $0x37,%al
 48f:	7e cb                	jle    45c <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 491:	8b 45 f8             	mov    -0x8(%ebp),%eax
 494:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 498:	c9                   	leave  
 499:	c3                   	ret    

0000049a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 49a:	b8 01 00 00 00       	mov    $0x1,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <exit>:
SYSCALL(exit)
 4a2:	b8 02 00 00 00       	mov    $0x2,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <wait>:
SYSCALL(wait)
 4aa:	b8 03 00 00 00       	mov    $0x3,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <pipe>:
SYSCALL(pipe)
 4b2:	b8 04 00 00 00       	mov    $0x4,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <read>:
SYSCALL(read)
 4ba:	b8 05 00 00 00       	mov    $0x5,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <write>:
SYSCALL(write)
 4c2:	b8 10 00 00 00       	mov    $0x10,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <close>:
SYSCALL(close)
 4ca:	b8 15 00 00 00       	mov    $0x15,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <kill>:
SYSCALL(kill)
 4d2:	b8 06 00 00 00       	mov    $0x6,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <exec>:
SYSCALL(exec)
 4da:	b8 07 00 00 00       	mov    $0x7,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <open>:
SYSCALL(open)
 4e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <mknod>:
SYSCALL(mknod)
 4ea:	b8 11 00 00 00       	mov    $0x11,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <unlink>:
SYSCALL(unlink)
 4f2:	b8 12 00 00 00       	mov    $0x12,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <fstat>:
SYSCALL(fstat)
 4fa:	b8 08 00 00 00       	mov    $0x8,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <link>:
SYSCALL(link)
 502:	b8 13 00 00 00       	mov    $0x13,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <mkdir>:
SYSCALL(mkdir)
 50a:	b8 14 00 00 00       	mov    $0x14,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <chdir>:
SYSCALL(chdir)
 512:	b8 09 00 00 00       	mov    $0x9,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <dup>:
SYSCALL(dup)
 51a:	b8 0a 00 00 00       	mov    $0xa,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <getpid>:
SYSCALL(getpid)
 522:	b8 0b 00 00 00       	mov    $0xb,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <sbrk>:
SYSCALL(sbrk)
 52a:	b8 0c 00 00 00       	mov    $0xc,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <sleep>:
SYSCALL(sleep)
 532:	b8 0d 00 00 00       	mov    $0xd,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <uptime>:
SYSCALL(uptime)
 53a:	b8 0e 00 00 00       	mov    $0xe,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <halt>:
SYSCALL(halt)
 542:	b8 16 00 00 00       	mov    $0x16,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 54a:	b8 17 00 00 00       	mov    $0x17,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 552:	b8 18 00 00 00       	mov    $0x18,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 55a:	b8 19 00 00 00       	mov    $0x19,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 562:	b8 1a 00 00 00       	mov    $0x1a,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 56a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 572:	b8 1c 00 00 00       	mov    $0x1c,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 57a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 582:	b8 1e 00 00 00       	mov    $0x1e,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 58a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 592:	b8 20 00 00 00       	mov    $0x20,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 59a:	b8 21 00 00 00       	mov    $0x21,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5a2:	55                   	push   %ebp
 5a3:	89 e5                	mov    %esp,%ebp
 5a5:	83 ec 18             	sub    $0x18,%esp
 5a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ab:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5ae:	83 ec 04             	sub    $0x4,%esp
 5b1:	6a 01                	push   $0x1
 5b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5b6:	50                   	push   %eax
 5b7:	ff 75 08             	pushl  0x8(%ebp)
 5ba:	e8 03 ff ff ff       	call   4c2 <write>
 5bf:	83 c4 10             	add    $0x10,%esp
}
 5c2:	90                   	nop
 5c3:	c9                   	leave  
 5c4:	c3                   	ret    

000005c5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c5:	55                   	push   %ebp
 5c6:	89 e5                	mov    %esp,%ebp
 5c8:	53                   	push   %ebx
 5c9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5d3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5d7:	74 17                	je     5f0 <printint+0x2b>
 5d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5dd:	79 11                	jns    5f0 <printint+0x2b>
    neg = 1;
 5df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e9:	f7 d8                	neg    %eax
 5eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5ee:	eb 06                	jmp    5f6 <printint+0x31>
  } else {
    x = xx;
 5f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5fd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 600:	8d 41 01             	lea    0x1(%ecx),%eax
 603:	89 45 f4             	mov    %eax,-0xc(%ebp)
 606:	8b 5d 10             	mov    0x10(%ebp),%ebx
 609:	8b 45 ec             	mov    -0x14(%ebp),%eax
 60c:	ba 00 00 00 00       	mov    $0x0,%edx
 611:	f7 f3                	div    %ebx
 613:	89 d0                	mov    %edx,%eax
 615:	0f b6 80 fc 0c 00 00 	movzbl 0xcfc(%eax),%eax
 61c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 620:	8b 5d 10             	mov    0x10(%ebp),%ebx
 623:	8b 45 ec             	mov    -0x14(%ebp),%eax
 626:	ba 00 00 00 00       	mov    $0x0,%edx
 62b:	f7 f3                	div    %ebx
 62d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 630:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 634:	75 c7                	jne    5fd <printint+0x38>
  if(neg)
 636:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 63a:	74 2d                	je     669 <printint+0xa4>
    buf[i++] = '-';
 63c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63f:	8d 50 01             	lea    0x1(%eax),%edx
 642:	89 55 f4             	mov    %edx,-0xc(%ebp)
 645:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 64a:	eb 1d                	jmp    669 <printint+0xa4>
    putc(fd, buf[i]);
 64c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 64f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 652:	01 d0                	add    %edx,%eax
 654:	0f b6 00             	movzbl (%eax),%eax
 657:	0f be c0             	movsbl %al,%eax
 65a:	83 ec 08             	sub    $0x8,%esp
 65d:	50                   	push   %eax
 65e:	ff 75 08             	pushl  0x8(%ebp)
 661:	e8 3c ff ff ff       	call   5a2 <putc>
 666:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 669:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 66d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 671:	79 d9                	jns    64c <printint+0x87>
    putc(fd, buf[i]);
}
 673:	90                   	nop
 674:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 677:	c9                   	leave  
 678:	c3                   	ret    

00000679 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 679:	55                   	push   %ebp
 67a:	89 e5                	mov    %esp,%ebp
 67c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 67f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 686:	8d 45 0c             	lea    0xc(%ebp),%eax
 689:	83 c0 04             	add    $0x4,%eax
 68c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 68f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 696:	e9 59 01 00 00       	jmp    7f4 <printf+0x17b>
    c = fmt[i] & 0xff;
 69b:	8b 55 0c             	mov    0xc(%ebp),%edx
 69e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a1:	01 d0                	add    %edx,%eax
 6a3:	0f b6 00             	movzbl (%eax),%eax
 6a6:	0f be c0             	movsbl %al,%eax
 6a9:	25 ff 00 00 00       	and    $0xff,%eax
 6ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b5:	75 2c                	jne    6e3 <printf+0x6a>
      if(c == '%'){
 6b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6bb:	75 0c                	jne    6c9 <printf+0x50>
        state = '%';
 6bd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6c4:	e9 27 01 00 00       	jmp    7f0 <printf+0x177>
      } else {
        putc(fd, c);
 6c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6cc:	0f be c0             	movsbl %al,%eax
 6cf:	83 ec 08             	sub    $0x8,%esp
 6d2:	50                   	push   %eax
 6d3:	ff 75 08             	pushl  0x8(%ebp)
 6d6:	e8 c7 fe ff ff       	call   5a2 <putc>
 6db:	83 c4 10             	add    $0x10,%esp
 6de:	e9 0d 01 00 00       	jmp    7f0 <printf+0x177>
      }
    } else if(state == '%'){
 6e3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6e7:	0f 85 03 01 00 00    	jne    7f0 <printf+0x177>
      if(c == 'd'){
 6ed:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6f1:	75 1e                	jne    711 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	6a 01                	push   $0x1
 6fa:	6a 0a                	push   $0xa
 6fc:	50                   	push   %eax
 6fd:	ff 75 08             	pushl  0x8(%ebp)
 700:	e8 c0 fe ff ff       	call   5c5 <printint>
 705:	83 c4 10             	add    $0x10,%esp
        ap++;
 708:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 70c:	e9 d8 00 00 00       	jmp    7e9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 711:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 715:	74 06                	je     71d <printf+0xa4>
 717:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 71b:	75 1e                	jne    73b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 71d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	6a 00                	push   $0x0
 724:	6a 10                	push   $0x10
 726:	50                   	push   %eax
 727:	ff 75 08             	pushl  0x8(%ebp)
 72a:	e8 96 fe ff ff       	call   5c5 <printint>
 72f:	83 c4 10             	add    $0x10,%esp
        ap++;
 732:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 736:	e9 ae 00 00 00       	jmp    7e9 <printf+0x170>
      } else if(c == 's'){
 73b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 73f:	75 43                	jne    784 <printf+0x10b>
        s = (char*)*ap;
 741:	8b 45 e8             	mov    -0x18(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 749:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 74d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 751:	75 25                	jne    778 <printf+0xff>
          s = "(null)";
 753:	c7 45 f4 67 0a 00 00 	movl   $0xa67,-0xc(%ebp)
        while(*s != 0){
 75a:	eb 1c                	jmp    778 <printf+0xff>
          putc(fd, *s);
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	0f b6 00             	movzbl (%eax),%eax
 762:	0f be c0             	movsbl %al,%eax
 765:	83 ec 08             	sub    $0x8,%esp
 768:	50                   	push   %eax
 769:	ff 75 08             	pushl  0x8(%ebp)
 76c:	e8 31 fe ff ff       	call   5a2 <putc>
 771:	83 c4 10             	add    $0x10,%esp
          s++;
 774:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	0f b6 00             	movzbl (%eax),%eax
 77e:	84 c0                	test   %al,%al
 780:	75 da                	jne    75c <printf+0xe3>
 782:	eb 65                	jmp    7e9 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 784:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 788:	75 1d                	jne    7a7 <printf+0x12e>
        putc(fd, *ap);
 78a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78d:	8b 00                	mov    (%eax),%eax
 78f:	0f be c0             	movsbl %al,%eax
 792:	83 ec 08             	sub    $0x8,%esp
 795:	50                   	push   %eax
 796:	ff 75 08             	pushl  0x8(%ebp)
 799:	e8 04 fe ff ff       	call   5a2 <putc>
 79e:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a5:	eb 42                	jmp    7e9 <printf+0x170>
      } else if(c == '%'){
 7a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ab:	75 17                	jne    7c4 <printf+0x14b>
        putc(fd, c);
 7ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b0:	0f be c0             	movsbl %al,%eax
 7b3:	83 ec 08             	sub    $0x8,%esp
 7b6:	50                   	push   %eax
 7b7:	ff 75 08             	pushl  0x8(%ebp)
 7ba:	e8 e3 fd ff ff       	call   5a2 <putc>
 7bf:	83 c4 10             	add    $0x10,%esp
 7c2:	eb 25                	jmp    7e9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7c4:	83 ec 08             	sub    $0x8,%esp
 7c7:	6a 25                	push   $0x25
 7c9:	ff 75 08             	pushl  0x8(%ebp)
 7cc:	e8 d1 fd ff ff       	call   5a2 <putc>
 7d1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d7:	0f be c0             	movsbl %al,%eax
 7da:	83 ec 08             	sub    $0x8,%esp
 7dd:	50                   	push   %eax
 7de:	ff 75 08             	pushl  0x8(%ebp)
 7e1:	e8 bc fd ff ff       	call   5a2 <putc>
 7e6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7f0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7f4:	8b 55 0c             	mov    0xc(%ebp),%edx
 7f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fa:	01 d0                	add    %edx,%eax
 7fc:	0f b6 00             	movzbl (%eax),%eax
 7ff:	84 c0                	test   %al,%al
 801:	0f 85 94 fe ff ff    	jne    69b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 807:	90                   	nop
 808:	c9                   	leave  
 809:	c3                   	ret    

0000080a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80a:	55                   	push   %ebp
 80b:	89 e5                	mov    %esp,%ebp
 80d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 810:	8b 45 08             	mov    0x8(%ebp),%eax
 813:	83 e8 08             	sub    $0x8,%eax
 816:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 819:	a1 28 0d 00 00       	mov    0xd28,%eax
 81e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 821:	eb 24                	jmp    847 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 823:	8b 45 fc             	mov    -0x4(%ebp),%eax
 826:	8b 00                	mov    (%eax),%eax
 828:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 82b:	77 12                	ja     83f <free+0x35>
 82d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 830:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 833:	77 24                	ja     859 <free+0x4f>
 835:	8b 45 fc             	mov    -0x4(%ebp),%eax
 838:	8b 00                	mov    (%eax),%eax
 83a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 83d:	77 1a                	ja     859 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 842:	8b 00                	mov    (%eax),%eax
 844:	89 45 fc             	mov    %eax,-0x4(%ebp)
 847:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 84d:	76 d4                	jbe    823 <free+0x19>
 84f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 852:	8b 00                	mov    (%eax),%eax
 854:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 857:	76 ca                	jbe    823 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 859:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85c:	8b 40 04             	mov    0x4(%eax),%eax
 85f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 866:	8b 45 f8             	mov    -0x8(%ebp),%eax
 869:	01 c2                	add    %eax,%edx
 86b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86e:	8b 00                	mov    (%eax),%eax
 870:	39 c2                	cmp    %eax,%edx
 872:	75 24                	jne    898 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 874:	8b 45 f8             	mov    -0x8(%ebp),%eax
 877:	8b 50 04             	mov    0x4(%eax),%edx
 87a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87d:	8b 00                	mov    (%eax),%eax
 87f:	8b 40 04             	mov    0x4(%eax),%eax
 882:	01 c2                	add    %eax,%edx
 884:	8b 45 f8             	mov    -0x8(%ebp),%eax
 887:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 88a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88d:	8b 00                	mov    (%eax),%eax
 88f:	8b 10                	mov    (%eax),%edx
 891:	8b 45 f8             	mov    -0x8(%ebp),%eax
 894:	89 10                	mov    %edx,(%eax)
 896:	eb 0a                	jmp    8a2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 898:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89b:	8b 10                	mov    (%eax),%edx
 89d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a5:	8b 40 04             	mov    0x4(%eax),%eax
 8a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b2:	01 d0                	add    %edx,%eax
 8b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8b7:	75 20                	jne    8d9 <free+0xcf>
    p->s.size += bp->s.size;
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bc:	8b 50 04             	mov    0x4(%eax),%edx
 8bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c2:	8b 40 04             	mov    0x4(%eax),%eax
 8c5:	01 c2                	add    %eax,%edx
 8c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ca:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d0:	8b 10                	mov    (%eax),%edx
 8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d5:	89 10                	mov    %edx,(%eax)
 8d7:	eb 08                	jmp    8e1 <free+0xd7>
  } else
    p->s.ptr = bp;
 8d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8df:	89 10                	mov    %edx,(%eax)
  freep = p;
 8e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e4:	a3 28 0d 00 00       	mov    %eax,0xd28
}
 8e9:	90                   	nop
 8ea:	c9                   	leave  
 8eb:	c3                   	ret    

000008ec <morecore>:

static Header*
morecore(uint nu)
{
 8ec:	55                   	push   %ebp
 8ed:	89 e5                	mov    %esp,%ebp
 8ef:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8f2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8f9:	77 07                	ja     902 <morecore+0x16>
    nu = 4096;
 8fb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 902:	8b 45 08             	mov    0x8(%ebp),%eax
 905:	c1 e0 03             	shl    $0x3,%eax
 908:	83 ec 0c             	sub    $0xc,%esp
 90b:	50                   	push   %eax
 90c:	e8 19 fc ff ff       	call   52a <sbrk>
 911:	83 c4 10             	add    $0x10,%esp
 914:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 917:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 91b:	75 07                	jne    924 <morecore+0x38>
    return 0;
 91d:	b8 00 00 00 00       	mov    $0x0,%eax
 922:	eb 26                	jmp    94a <morecore+0x5e>
  hp = (Header*)p;
 924:	8b 45 f4             	mov    -0xc(%ebp),%eax
 927:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 92a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92d:	8b 55 08             	mov    0x8(%ebp),%edx
 930:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 933:	8b 45 f0             	mov    -0x10(%ebp),%eax
 936:	83 c0 08             	add    $0x8,%eax
 939:	83 ec 0c             	sub    $0xc,%esp
 93c:	50                   	push   %eax
 93d:	e8 c8 fe ff ff       	call   80a <free>
 942:	83 c4 10             	add    $0x10,%esp
  return freep;
 945:	a1 28 0d 00 00       	mov    0xd28,%eax
}
 94a:	c9                   	leave  
 94b:	c3                   	ret    

0000094c <malloc>:

void*
malloc(uint nbytes)
{
 94c:	55                   	push   %ebp
 94d:	89 e5                	mov    %esp,%ebp
 94f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 952:	8b 45 08             	mov    0x8(%ebp),%eax
 955:	83 c0 07             	add    $0x7,%eax
 958:	c1 e8 03             	shr    $0x3,%eax
 95b:	83 c0 01             	add    $0x1,%eax
 95e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 961:	a1 28 0d 00 00       	mov    0xd28,%eax
 966:	89 45 f0             	mov    %eax,-0x10(%ebp)
 969:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 96d:	75 23                	jne    992 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 96f:	c7 45 f0 20 0d 00 00 	movl   $0xd20,-0x10(%ebp)
 976:	8b 45 f0             	mov    -0x10(%ebp),%eax
 979:	a3 28 0d 00 00       	mov    %eax,0xd28
 97e:	a1 28 0d 00 00       	mov    0xd28,%eax
 983:	a3 20 0d 00 00       	mov    %eax,0xd20
    base.s.size = 0;
 988:	c7 05 24 0d 00 00 00 	movl   $0x0,0xd24
 98f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 992:	8b 45 f0             	mov    -0x10(%ebp),%eax
 995:	8b 00                	mov    (%eax),%eax
 997:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 99a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99d:	8b 40 04             	mov    0x4(%eax),%eax
 9a0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9a3:	72 4d                	jb     9f2 <malloc+0xa6>
      if(p->s.size == nunits)
 9a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a8:	8b 40 04             	mov    0x4(%eax),%eax
 9ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9ae:	75 0c                	jne    9bc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b3:	8b 10                	mov    (%eax),%edx
 9b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b8:	89 10                	mov    %edx,(%eax)
 9ba:	eb 26                	jmp    9e2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bf:	8b 40 04             	mov    0x4(%eax),%eax
 9c2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9c5:	89 c2                	mov    %eax,%edx
 9c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ca:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d0:	8b 40 04             	mov    0x4(%eax),%eax
 9d3:	c1 e0 03             	shl    $0x3,%eax
 9d6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9df:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e5:	a3 28 0d 00 00       	mov    %eax,0xd28
      return (void*)(p + 1);
 9ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ed:	83 c0 08             	add    $0x8,%eax
 9f0:	eb 3b                	jmp    a2d <malloc+0xe1>
    }
    if(p == freep)
 9f2:	a1 28 0d 00 00       	mov    0xd28,%eax
 9f7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9fa:	75 1e                	jne    a1a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9fc:	83 ec 0c             	sub    $0xc,%esp
 9ff:	ff 75 ec             	pushl  -0x14(%ebp)
 a02:	e8 e5 fe ff ff       	call   8ec <morecore>
 a07:	83 c4 10             	add    $0x10,%esp
 a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a11:	75 07                	jne    a1a <malloc+0xce>
        return 0;
 a13:	b8 00 00 00 00       	mov    $0x0,%eax
 a18:	eb 13                	jmp    a2d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a23:	8b 00                	mov    (%eax),%eax
 a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a28:	e9 6d ff ff ff       	jmp    99a <malloc+0x4e>
}
 a2d:	c9                   	leave  
 a2e:	c3                   	ret    
