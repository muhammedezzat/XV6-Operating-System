
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 b6 00 00 00       	jmp    c8 <grep+0xc8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 20 0f 00 00       	add    $0xf20,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 20 0f 00 00 	movl   $0xf20,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4a                	jmp    76 <grep+0x76>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	pushl  -0x10(%ebp)
  38:	ff 75 08             	pushl  0x8(%ebp)
  3b:	e8 9a 01 00 00       	call   1da <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 26                	je     6d <grep+0x6d>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	29 c2                	sub    %eax,%edx
  5a:	89 d0                	mov    %edx,%eax
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f0             	pushl  -0x10(%ebp)
  63:	6a 01                	push   $0x1
  65:	e8 d1 05 00 00       	call   63b <write>
  6a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  70:	83 c0 01             	add    $0x1,%eax
  73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  76:	83 ec 08             	sub    $0x8,%esp
  79:	6a 0a                	push   $0xa
  7b:	ff 75 f0             	pushl  -0x10(%ebp)
  7e:	e8 89 03 00 00       	call   40c <strchr>
  83:	83 c4 10             	add    $0x10,%esp
  86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8d:	75 9d                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8f:	81 7d f0 20 0f 00 00 	cmpl   $0xf20,-0x10(%ebp)
  96:	75 07                	jne    9f <grep+0x9f>
      m = 0;
  98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a3:	7e 23                	jle    c8 <grep+0xc8>
      m -= p - buf;
  a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a8:	ba 20 0f 00 00       	mov    $0xf20,%edx
  ad:	29 d0                	sub    %edx,%eax
  af:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b2:	83 ec 04             	sub    $0x4,%esp
  b5:	ff 75 f4             	pushl  -0xc(%ebp)
  b8:	ff 75 f0             	pushl  -0x10(%ebp)
  bb:	68 20 0f 00 00       	push   $0xf20
  c0:	e8 83 04 00 00       	call   548 <memmove>
  c5:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cb:	ba ff 03 00 00       	mov    $0x3ff,%edx
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	89 c2                	mov    %eax,%edx
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	05 20 0f 00 00       	add    $0xf20,%eax
  de:	83 ec 04             	sub    $0x4,%esp
  e1:	52                   	push   %edx
  e2:	50                   	push   %eax
  e3:	ff 75 0c             	pushl  0xc(%ebp)
  e6:	e8 48 05 00 00       	call   633 <read>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f5:	0f 8f 17 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  fb:	90                   	nop
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 102:	83 e4 f0             	and    $0xfffffff0,%esp
 105:	ff 71 fc             	pushl  -0x4(%ecx)
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	53                   	push   %ebx
 10c:	51                   	push   %ecx
 10d:	83 ec 10             	sub    $0x10,%esp
 110:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 112:	83 3b 01             	cmpl   $0x1,(%ebx)
 115:	7f 17                	jg     12e <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 117:	83 ec 08             	sub    $0x8,%esp
 11a:	68 a8 0b 00 00       	push   $0xba8
 11f:	6a 02                	push   $0x2
 121:	e8 cc 06 00 00       	call   7f2 <printf>
 126:	83 c4 10             	add    $0x10,%esp
    exit();
 129:	e8 ed 04 00 00       	call   61b <exit>
  }
  pattern = argv[1];
 12e:	8b 43 04             	mov    0x4(%ebx),%eax
 131:	8b 40 04             	mov    0x4(%eax),%eax
 134:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 137:	83 3b 02             	cmpl   $0x2,(%ebx)
 13a:	7f 15                	jg     151 <main+0x53>
    grep(pattern, 0);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	6a 00                	push   $0x0
 141:	ff 75 f0             	pushl  -0x10(%ebp)
 144:	e8 b7 fe ff ff       	call   0 <grep>
 149:	83 c4 10             	add    $0x10,%esp
    exit();
 14c:	e8 ca 04 00 00       	call   61b <exit>
  }

  for(i = 2; i < argc; i++){
 151:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 158:	eb 74                	jmp    1ce <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	6a 00                	push   $0x0
 170:	50                   	push   %eax
 171:	e8 e5 04 00 00       	call   65b <open>
 176:	83 c4 10             	add    $0x10,%esp
 179:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 180:	79 29                	jns    1ab <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18c:	8b 43 04             	mov    0x4(%ebx),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	8b 00                	mov    (%eax),%eax
 193:	83 ec 04             	sub    $0x4,%esp
 196:	50                   	push   %eax
 197:	68 c8 0b 00 00       	push   $0xbc8
 19c:	6a 01                	push   $0x1
 19e:	e8 4f 06 00 00       	call   7f2 <printf>
 1a3:	83 c4 10             	add    $0x10,%esp
      exit();
 1a6:	e8 70 04 00 00       	call   61b <exit>
    }
    grep(pattern, fd);
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	ff 75 ec             	pushl  -0x14(%ebp)
 1b1:	ff 75 f0             	pushl  -0x10(%ebp)
 1b4:	e8 47 fe ff ff       	call   0 <grep>
 1b9:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bc:	83 ec 0c             	sub    $0xc,%esp
 1bf:	ff 75 ec             	pushl  -0x14(%ebp)
 1c2:	e8 7c 04 00 00       	call   643 <close>
 1c7:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	3b 03                	cmp    (%ebx),%eax
 1d3:	7c 85                	jl     15a <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1d5:	e8 41 04 00 00       	call   61b <exit>

000001da <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	3c 5e                	cmp    $0x5e,%al
 1e8:	75 17                	jne    201 <match+0x27>
    return matchhere(re+1, text);
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	ff 75 0c             	pushl  0xc(%ebp)
 1f6:	50                   	push   %eax
 1f7:	e8 38 00 00 00       	call   234 <matchhere>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	eb 31                	jmp    232 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	pushl  0xc(%ebp)
 207:	ff 75 08             	pushl  0x8(%ebp)
 20a:	e8 25 00 00 00       	call   234 <matchhere>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	85 c0                	test   %eax,%eax
 214:	74 07                	je     21d <match+0x43>
      return 1;
 216:	b8 01 00 00 00       	mov    $0x1,%eax
 21b:	eb 15                	jmp    232 <match+0x58>
  }while(*text++ != '\0');
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	8d 50 01             	lea    0x1(%eax),%edx
 223:	89 55 0c             	mov    %edx,0xc(%ebp)
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 d4                	jne    201 <match+0x27>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	84 c0                	test   %al,%al
 242:	75 0a                	jne    24e <matchhere+0x1a>
    return 1;
 244:	b8 01 00 00 00       	mov    $0x1,%eax
 249:	e9 99 00 00 00       	jmp    2e7 <matchhere+0xb3>
  if(re[1] == '*')
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	83 c0 01             	add    $0x1,%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2a                	cmp    $0x2a,%al
 259:	75 21                	jne    27c <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 02             	lea    0x2(%eax),%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	ff 75 0c             	pushl  0xc(%ebp)
 270:	52                   	push   %edx
 271:	50                   	push   %eax
 272:	e8 72 00 00 00       	call   2e9 <matchstar>
 277:	83 c4 10             	add    $0x10,%esp
 27a:	eb 6b                	jmp    2e7 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 24                	cmp    $0x24,%al
 284:	75 1d                	jne    2a3 <matchhere+0x6f>
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	84 c0                	test   %al,%al
 291:	75 10                	jne    2a3 <matchhere+0x6f>
    return *text == '\0';
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	84 c0                	test   %al,%al
 29b:	0f 94 c0             	sete   %al
 29e:	0f b6 c0             	movzbl %al,%eax
 2a1:	eb 44                	jmp    2e7 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	84 c0                	test   %al,%al
 2ab:	74 35                	je     2e2 <matchhere+0xae>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2e                	cmp    $0x2e,%al
 2b5:	74 10                	je     2c7 <matchhere+0x93>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 c2                	cmp    %al,%dl
 2c5:	75 1b                	jne    2e2 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	8d 50 01             	lea    0x1(%eax),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	83 c0 01             	add    $0x1,%eax
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	52                   	push   %edx
 2d7:	50                   	push   %eax
 2d8:	e8 57 ff ff ff       	call   234 <matchhere>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	eb 05                	jmp    2e7 <matchhere+0xb3>
  return 0;
 2e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2ef:	83 ec 08             	sub    $0x8,%esp
 2f2:	ff 75 10             	pushl  0x10(%ebp)
 2f5:	ff 75 0c             	pushl  0xc(%ebp)
 2f8:	e8 37 ff ff ff       	call   234 <matchhere>
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	74 07                	je     30b <matchstar+0x22>
      return 1;
 304:	b8 01 00 00 00       	mov    $0x1,%eax
 309:	eb 29                	jmp    334 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 30b:	8b 45 10             	mov    0x10(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	74 1a                	je     32f <matchstar+0x46>
 315:	8b 45 10             	mov    0x10(%ebp),%eax
 318:	8d 50 01             	lea    0x1(%eax),%edx
 31b:	89 55 10             	mov    %edx,0x10(%ebp)
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f be c0             	movsbl %al,%eax
 324:	3b 45 08             	cmp    0x8(%ebp),%eax
 327:	74 c6                	je     2ef <matchstar+0x6>
 329:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 32d:	74 c0                	je     2ef <matchstar+0x6>
  return 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	57                   	push   %edi
 33a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 33b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 33e:	8b 55 10             	mov    0x10(%ebp),%edx
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	89 cb                	mov    %ecx,%ebx
 346:	89 df                	mov    %ebx,%edi
 348:	89 d1                	mov    %edx,%ecx
 34a:	fc                   	cld    
 34b:	f3 aa                	rep stos %al,%es:(%edi)
 34d:	89 ca                	mov    %ecx,%edx
 34f:	89 fb                	mov    %edi,%ebx
 351:	89 5d 08             	mov    %ebx,0x8(%ebp)
 354:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 357:	90                   	nop
 358:	5b                   	pop    %ebx
 359:	5f                   	pop    %edi
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 368:	90                   	nop
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	8d 50 01             	lea    0x1(%eax),%edx
 36f:	89 55 08             	mov    %edx,0x8(%ebp)
 372:	8b 55 0c             	mov    0xc(%ebp),%edx
 375:	8d 4a 01             	lea    0x1(%edx),%ecx
 378:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 37b:	0f b6 12             	movzbl (%edx),%edx
 37e:	88 10                	mov    %dl,(%eax)
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	84 c0                	test   %al,%al
 385:	75 e2                	jne    369 <strcpy+0xd>
    ;
  return os;
 387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 38f:	eb 08                	jmp    399 <strcmp+0xd>
    p++, q++;
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	74 10                	je     3b3 <strcmp+0x27>
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	0f b6 10             	movzbl (%eax),%edx
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	38 c2                	cmp    %al,%dl
 3b1:	74 de                	je     391 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f b6 d0             	movzbl %al,%edx
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	0f b6 c0             	movzbl %al,%eax
 3c5:	29 c2                	sub    %eax,%edx
 3c7:	89 d0                	mov    %edx,%eax
}
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <strlen>:

uint
strlen(char *s)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d8:	eb 04                	jmp    3de <strlen+0x13>
 3da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	01 d0                	add    %edx,%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	75 ed                	jne    3da <strlen+0xf>
    ;
  return n;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3f5:	8b 45 10             	mov    0x10(%ebp),%eax
 3f8:	50                   	push   %eax
 3f9:	ff 75 0c             	pushl  0xc(%ebp)
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 32 ff ff ff       	call   336 <stosb>
 404:	83 c4 0c             	add    $0xc,%esp
  return dst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <strchr>:

char*
strchr(const char *s, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 418:	eb 14                	jmp    42e <strchr+0x22>
    if(*s == c)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	3a 45 fc             	cmp    -0x4(%ebp),%al
 423:	75 05                	jne    42a <strchr+0x1e>
      return (char*)s;
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	eb 13                	jmp    43d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 42a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	0f b6 00             	movzbl (%eax),%eax
 434:	84 c0                	test   %al,%al
 436:	75 e2                	jne    41a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 438:	b8 00 00 00 00       	mov    $0x0,%eax
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <gets>:

char*
gets(char *buf, int max)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 44c:	eb 42                	jmp    490 <gets+0x51>
    cc = read(0, &c, 1);
 44e:	83 ec 04             	sub    $0x4,%esp
 451:	6a 01                	push   $0x1
 453:	8d 45 ef             	lea    -0x11(%ebp),%eax
 456:	50                   	push   %eax
 457:	6a 00                	push   $0x0
 459:	e8 d5 01 00 00       	call   633 <read>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 468:	7e 33                	jle    49d <gets+0x5e>
      break;
    buf[i++] = c;
 46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46d:	8d 50 01             	lea    0x1(%eax),%edx
 470:	89 55 f4             	mov    %edx,-0xc(%ebp)
 473:	89 c2                	mov    %eax,%edx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	01 c2                	add    %eax,%edx
 47a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 47e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 480:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 484:	3c 0a                	cmp    $0xa,%al
 486:	74 16                	je     49e <gets+0x5f>
 488:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48c:	3c 0d                	cmp    $0xd,%al
 48e:	74 0e                	je     49e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	83 c0 01             	add    $0x1,%eax
 496:	3b 45 0c             	cmp    0xc(%ebp),%eax
 499:	7c b3                	jl     44e <gets+0xf>
 49b:	eb 01                	jmp    49e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 49d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 49e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	01 d0                	add    %edx,%eax
 4a6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ac:	c9                   	leave  
 4ad:	c3                   	ret    

000004ae <stat>:

int
stat(char *n, struct stat *st)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b4:	83 ec 08             	sub    $0x8,%esp
 4b7:	6a 00                	push   $0x0
 4b9:	ff 75 08             	pushl  0x8(%ebp)
 4bc:	e8 9a 01 00 00       	call   65b <open>
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cb:	79 07                	jns    4d4 <stat+0x26>
    return -1;
 4cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4d2:	eb 25                	jmp    4f9 <stat+0x4b>
  r = fstat(fd, st);
 4d4:	83 ec 08             	sub    $0x8,%esp
 4d7:	ff 75 0c             	pushl  0xc(%ebp)
 4da:	ff 75 f4             	pushl  -0xc(%ebp)
 4dd:	e8 91 01 00 00       	call   673 <fstat>
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4e8:	83 ec 0c             	sub    $0xc,%esp
 4eb:	ff 75 f4             	pushl  -0xc(%ebp)
 4ee:	e8 50 01 00 00       	call   643 <close>
 4f3:	83 c4 10             	add    $0x10,%esp
  return r;
 4f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4f9:	c9                   	leave  
 4fa:	c3                   	ret    

000004fb <atoi>:

int
atoi(const char *s)
{
 4fb:	55                   	push   %ebp
 4fc:	89 e5                	mov    %esp,%ebp
 4fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 508:	eb 25                	jmp    52f <atoi+0x34>
    n = n*10 + *s++ - '0';
 50a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 50d:	89 d0                	mov    %edx,%eax
 50f:	c1 e0 02             	shl    $0x2,%eax
 512:	01 d0                	add    %edx,%eax
 514:	01 c0                	add    %eax,%eax
 516:	89 c1                	mov    %eax,%ecx
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	8d 50 01             	lea    0x1(%eax),%edx
 51e:	89 55 08             	mov    %edx,0x8(%ebp)
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	01 c8                	add    %ecx,%eax
 529:	83 e8 30             	sub    $0x30,%eax
 52c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 52f:	8b 45 08             	mov    0x8(%ebp),%eax
 532:	0f b6 00             	movzbl (%eax),%eax
 535:	3c 2f                	cmp    $0x2f,%al
 537:	7e 0a                	jle    543 <atoi+0x48>
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	0f b6 00             	movzbl (%eax),%eax
 53f:	3c 39                	cmp    $0x39,%al
 541:	7e c7                	jle    50a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 543:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 546:	c9                   	leave  
 547:	c3                   	ret    

00000548 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 548:	55                   	push   %ebp
 549:	89 e5                	mov    %esp,%ebp
 54b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 554:	8b 45 0c             	mov    0xc(%ebp),%eax
 557:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 55a:	eb 17                	jmp    573 <memmove+0x2b>
    *dst++ = *src++;
 55c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 55f:	8d 50 01             	lea    0x1(%eax),%edx
 562:	89 55 fc             	mov    %edx,-0x4(%ebp)
 565:	8b 55 f8             	mov    -0x8(%ebp),%edx
 568:	8d 4a 01             	lea    0x1(%edx),%ecx
 56b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 56e:	0f b6 12             	movzbl (%edx),%edx
 571:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 573:	8b 45 10             	mov    0x10(%ebp),%eax
 576:	8d 50 ff             	lea    -0x1(%eax),%edx
 579:	89 55 10             	mov    %edx,0x10(%ebp)
 57c:	85 c0                	test   %eax,%eax
 57e:	7f dc                	jg     55c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 580:	8b 45 08             	mov    0x8(%ebp),%eax
}
 583:	c9                   	leave  
 584:	c3                   	ret    

00000585 <atoo>:

int
atoo(const char *s)
{
 585:	55                   	push   %ebp
 586:	89 e5                	mov    %esp,%ebp
 588:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 58b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 592:	eb 04                	jmp    598 <atoo+0x13>
 594:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	0f b6 00             	movzbl (%eax),%eax
 59e:	3c 20                	cmp    $0x20,%al
 5a0:	74 f2                	je     594 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 5a2:	8b 45 08             	mov    0x8(%ebp),%eax
 5a5:	0f b6 00             	movzbl (%eax),%eax
 5a8:	3c 2d                	cmp    $0x2d,%al
 5aa:	75 07                	jne    5b3 <atoo+0x2e>
 5ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5b1:	eb 05                	jmp    5b8 <atoo+0x33>
 5b3:	b8 01 00 00 00       	mov    $0x1,%eax
 5b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 5bb:	8b 45 08             	mov    0x8(%ebp),%eax
 5be:	0f b6 00             	movzbl (%eax),%eax
 5c1:	3c 2b                	cmp    $0x2b,%al
 5c3:	74 0a                	je     5cf <atoo+0x4a>
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	0f b6 00             	movzbl (%eax),%eax
 5cb:	3c 2d                	cmp    $0x2d,%al
 5cd:	75 27                	jne    5f6 <atoo+0x71>
    s++;
 5cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 5d3:	eb 21                	jmp    5f6 <atoo+0x71>
    n = n*8 + *s++ - '0';
 5d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 5df:	8b 45 08             	mov    0x8(%ebp),%eax
 5e2:	8d 50 01             	lea    0x1(%eax),%edx
 5e5:	89 55 08             	mov    %edx,0x8(%ebp)
 5e8:	0f b6 00             	movzbl (%eax),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	01 c8                	add    %ecx,%eax
 5f0:	83 e8 30             	sub    $0x30,%eax
 5f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	0f b6 00             	movzbl (%eax),%eax
 5fc:	3c 2f                	cmp    $0x2f,%al
 5fe:	7e 0a                	jle    60a <atoo+0x85>
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	0f b6 00             	movzbl (%eax),%eax
 606:	3c 37                	cmp    $0x37,%al
 608:	7e cb                	jle    5d5 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 60a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60d:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 611:	c9                   	leave  
 612:	c3                   	ret    

00000613 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 613:	b8 01 00 00 00       	mov    $0x1,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <exit>:
SYSCALL(exit)
 61b:	b8 02 00 00 00       	mov    $0x2,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <wait>:
SYSCALL(wait)
 623:	b8 03 00 00 00       	mov    $0x3,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <pipe>:
SYSCALL(pipe)
 62b:	b8 04 00 00 00       	mov    $0x4,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <read>:
SYSCALL(read)
 633:	b8 05 00 00 00       	mov    $0x5,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <write>:
SYSCALL(write)
 63b:	b8 10 00 00 00       	mov    $0x10,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <close>:
SYSCALL(close)
 643:	b8 15 00 00 00       	mov    $0x15,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <kill>:
SYSCALL(kill)
 64b:	b8 06 00 00 00       	mov    $0x6,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <exec>:
SYSCALL(exec)
 653:	b8 07 00 00 00       	mov    $0x7,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <open>:
SYSCALL(open)
 65b:	b8 0f 00 00 00       	mov    $0xf,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <mknod>:
SYSCALL(mknod)
 663:	b8 11 00 00 00       	mov    $0x11,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <unlink>:
SYSCALL(unlink)
 66b:	b8 12 00 00 00       	mov    $0x12,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <fstat>:
SYSCALL(fstat)
 673:	b8 08 00 00 00       	mov    $0x8,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <link>:
SYSCALL(link)
 67b:	b8 13 00 00 00       	mov    $0x13,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <mkdir>:
SYSCALL(mkdir)
 683:	b8 14 00 00 00       	mov    $0x14,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <chdir>:
SYSCALL(chdir)
 68b:	b8 09 00 00 00       	mov    $0x9,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <dup>:
SYSCALL(dup)
 693:	b8 0a 00 00 00       	mov    $0xa,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <getpid>:
SYSCALL(getpid)
 69b:	b8 0b 00 00 00       	mov    $0xb,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <sbrk>:
SYSCALL(sbrk)
 6a3:	b8 0c 00 00 00       	mov    $0xc,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    

000006ab <sleep>:
SYSCALL(sleep)
 6ab:	b8 0d 00 00 00       	mov    $0xd,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret    

000006b3 <uptime>:
SYSCALL(uptime)
 6b3:	b8 0e 00 00 00       	mov    $0xe,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret    

000006bb <halt>:
SYSCALL(halt)
 6bb:	b8 16 00 00 00       	mov    $0x16,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret    

000006c3 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 6c3:	b8 17 00 00 00       	mov    $0x17,%eax
 6c8:	cd 40                	int    $0x40
 6ca:	c3                   	ret    

000006cb <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 6cb:	b8 18 00 00 00       	mov    $0x18,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret    

000006d3 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 6d3:	b8 19 00 00 00       	mov    $0x19,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret    

000006db <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 6db:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret    

000006e3 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 6e3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret    

000006eb <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 6eb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6f0:	cd 40                	int    $0x40
 6f2:	c3                   	ret    

000006f3 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 6f3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6f8:	cd 40                	int    $0x40
 6fa:	c3                   	ret    

000006fb <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 6fb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 700:	cd 40                	int    $0x40
 702:	c3                   	ret    

00000703 <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 703:	b8 1c 00 00 00       	mov    $0x1c,%eax
 708:	cd 40                	int    $0x40
 70a:	c3                   	ret    

0000070b <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 70b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 710:	cd 40                	int    $0x40
 712:	c3                   	ret    

00000713 <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 713:	b8 1e 00 00 00       	mov    $0x1e,%eax
 718:	cd 40                	int    $0x40
 71a:	c3                   	ret    

0000071b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 71b:	55                   	push   %ebp
 71c:	89 e5                	mov    %esp,%ebp
 71e:	83 ec 18             	sub    $0x18,%esp
 721:	8b 45 0c             	mov    0xc(%ebp),%eax
 724:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 727:	83 ec 04             	sub    $0x4,%esp
 72a:	6a 01                	push   $0x1
 72c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 72f:	50                   	push   %eax
 730:	ff 75 08             	pushl  0x8(%ebp)
 733:	e8 03 ff ff ff       	call   63b <write>
 738:	83 c4 10             	add    $0x10,%esp
}
 73b:	90                   	nop
 73c:	c9                   	leave  
 73d:	c3                   	ret    

0000073e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 73e:	55                   	push   %ebp
 73f:	89 e5                	mov    %esp,%ebp
 741:	53                   	push   %ebx
 742:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 745:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 74c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 750:	74 17                	je     769 <printint+0x2b>
 752:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 756:	79 11                	jns    769 <printint+0x2b>
    neg = 1;
 758:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 75f:	8b 45 0c             	mov    0xc(%ebp),%eax
 762:	f7 d8                	neg    %eax
 764:	89 45 ec             	mov    %eax,-0x14(%ebp)
 767:	eb 06                	jmp    76f <printint+0x31>
  } else {
    x = xx;
 769:	8b 45 0c             	mov    0xc(%ebp),%eax
 76c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 76f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 776:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 779:	8d 41 01             	lea    0x1(%ecx),%eax
 77c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 77f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 782:	8b 45 ec             	mov    -0x14(%ebp),%eax
 785:	ba 00 00 00 00       	mov    $0x0,%edx
 78a:	f7 f3                	div    %ebx
 78c:	89 d0                	mov    %edx,%eax
 78e:	0f b6 80 d4 0e 00 00 	movzbl 0xed4(%eax),%eax
 795:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 799:	8b 5d 10             	mov    0x10(%ebp),%ebx
 79c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79f:	ba 00 00 00 00       	mov    $0x0,%edx
 7a4:	f7 f3                	div    %ebx
 7a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ad:	75 c7                	jne    776 <printint+0x38>
  if(neg)
 7af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b3:	74 2d                	je     7e2 <printint+0xa4>
    buf[i++] = '-';
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	8d 50 01             	lea    0x1(%eax),%edx
 7bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7be:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7c3:	eb 1d                	jmp    7e2 <printint+0xa4>
    putc(fd, buf[i]);
 7c5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	01 d0                	add    %edx,%eax
 7cd:	0f b6 00             	movzbl (%eax),%eax
 7d0:	0f be c0             	movsbl %al,%eax
 7d3:	83 ec 08             	sub    $0x8,%esp
 7d6:	50                   	push   %eax
 7d7:	ff 75 08             	pushl  0x8(%ebp)
 7da:	e8 3c ff ff ff       	call   71b <putc>
 7df:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7e2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 7e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ea:	79 d9                	jns    7c5 <printint+0x87>
    putc(fd, buf[i]);
}
 7ec:	90                   	nop
 7ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7f0:	c9                   	leave  
 7f1:	c3                   	ret    

000007f2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7f2:	55                   	push   %ebp
 7f3:	89 e5                	mov    %esp,%ebp
 7f5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7ff:	8d 45 0c             	lea    0xc(%ebp),%eax
 802:	83 c0 04             	add    $0x4,%eax
 805:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 808:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80f:	e9 59 01 00 00       	jmp    96d <printf+0x17b>
    c = fmt[i] & 0xff;
 814:	8b 55 0c             	mov    0xc(%ebp),%edx
 817:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81a:	01 d0                	add    %edx,%eax
 81c:	0f b6 00             	movzbl (%eax),%eax
 81f:	0f be c0             	movsbl %al,%eax
 822:	25 ff 00 00 00       	and    $0xff,%eax
 827:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 82a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 82e:	75 2c                	jne    85c <printf+0x6a>
      if(c == '%'){
 830:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 834:	75 0c                	jne    842 <printf+0x50>
        state = '%';
 836:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 83d:	e9 27 01 00 00       	jmp    969 <printf+0x177>
      } else {
        putc(fd, c);
 842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 845:	0f be c0             	movsbl %al,%eax
 848:	83 ec 08             	sub    $0x8,%esp
 84b:	50                   	push   %eax
 84c:	ff 75 08             	pushl  0x8(%ebp)
 84f:	e8 c7 fe ff ff       	call   71b <putc>
 854:	83 c4 10             	add    $0x10,%esp
 857:	e9 0d 01 00 00       	jmp    969 <printf+0x177>
      }
    } else if(state == '%'){
 85c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 860:	0f 85 03 01 00 00    	jne    969 <printf+0x177>
      if(c == 'd'){
 866:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 86a:	75 1e                	jne    88a <printf+0x98>
        printint(fd, *ap, 10, 1);
 86c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	6a 01                	push   $0x1
 873:	6a 0a                	push   $0xa
 875:	50                   	push   %eax
 876:	ff 75 08             	pushl  0x8(%ebp)
 879:	e8 c0 fe ff ff       	call   73e <printint>
 87e:	83 c4 10             	add    $0x10,%esp
        ap++;
 881:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 885:	e9 d8 00 00 00       	jmp    962 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 88a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 88e:	74 06                	je     896 <printf+0xa4>
 890:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 894:	75 1e                	jne    8b4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 896:	8b 45 e8             	mov    -0x18(%ebp),%eax
 899:	8b 00                	mov    (%eax),%eax
 89b:	6a 00                	push   $0x0
 89d:	6a 10                	push   $0x10
 89f:	50                   	push   %eax
 8a0:	ff 75 08             	pushl  0x8(%ebp)
 8a3:	e8 96 fe ff ff       	call   73e <printint>
 8a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 8ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8af:	e9 ae 00 00 00       	jmp    962 <printf+0x170>
      } else if(c == 's'){
 8b4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8b8:	75 43                	jne    8fd <printf+0x10b>
        s = (char*)*ap;
 8ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8bd:	8b 00                	mov    (%eax),%eax
 8bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ca:	75 25                	jne    8f1 <printf+0xff>
          s = "(null)";
 8cc:	c7 45 f4 de 0b 00 00 	movl   $0xbde,-0xc(%ebp)
        while(*s != 0){
 8d3:	eb 1c                	jmp    8f1 <printf+0xff>
          putc(fd, *s);
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	0f b6 00             	movzbl (%eax),%eax
 8db:	0f be c0             	movsbl %al,%eax
 8de:	83 ec 08             	sub    $0x8,%esp
 8e1:	50                   	push   %eax
 8e2:	ff 75 08             	pushl  0x8(%ebp)
 8e5:	e8 31 fe ff ff       	call   71b <putc>
 8ea:	83 c4 10             	add    $0x10,%esp
          s++;
 8ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	0f b6 00             	movzbl (%eax),%eax
 8f7:	84 c0                	test   %al,%al
 8f9:	75 da                	jne    8d5 <printf+0xe3>
 8fb:	eb 65                	jmp    962 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8fd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 901:	75 1d                	jne    920 <printf+0x12e>
        putc(fd, *ap);
 903:	8b 45 e8             	mov    -0x18(%ebp),%eax
 906:	8b 00                	mov    (%eax),%eax
 908:	0f be c0             	movsbl %al,%eax
 90b:	83 ec 08             	sub    $0x8,%esp
 90e:	50                   	push   %eax
 90f:	ff 75 08             	pushl  0x8(%ebp)
 912:	e8 04 fe ff ff       	call   71b <putc>
 917:	83 c4 10             	add    $0x10,%esp
        ap++;
 91a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 91e:	eb 42                	jmp    962 <printf+0x170>
      } else if(c == '%'){
 920:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 924:	75 17                	jne    93d <printf+0x14b>
        putc(fd, c);
 926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 929:	0f be c0             	movsbl %al,%eax
 92c:	83 ec 08             	sub    $0x8,%esp
 92f:	50                   	push   %eax
 930:	ff 75 08             	pushl  0x8(%ebp)
 933:	e8 e3 fd ff ff       	call   71b <putc>
 938:	83 c4 10             	add    $0x10,%esp
 93b:	eb 25                	jmp    962 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 93d:	83 ec 08             	sub    $0x8,%esp
 940:	6a 25                	push   $0x25
 942:	ff 75 08             	pushl  0x8(%ebp)
 945:	e8 d1 fd ff ff       	call   71b <putc>
 94a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 94d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 950:	0f be c0             	movsbl %al,%eax
 953:	83 ec 08             	sub    $0x8,%esp
 956:	50                   	push   %eax
 957:	ff 75 08             	pushl  0x8(%ebp)
 95a:	e8 bc fd ff ff       	call   71b <putc>
 95f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 962:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 969:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 96d:	8b 55 0c             	mov    0xc(%ebp),%edx
 970:	8b 45 f0             	mov    -0x10(%ebp),%eax
 973:	01 d0                	add    %edx,%eax
 975:	0f b6 00             	movzbl (%eax),%eax
 978:	84 c0                	test   %al,%al
 97a:	0f 85 94 fe ff ff    	jne    814 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 980:	90                   	nop
 981:	c9                   	leave  
 982:	c3                   	ret    

00000983 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 983:	55                   	push   %ebp
 984:	89 e5                	mov    %esp,%ebp
 986:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 989:	8b 45 08             	mov    0x8(%ebp),%eax
 98c:	83 e8 08             	sub    $0x8,%eax
 98f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 992:	a1 08 0f 00 00       	mov    0xf08,%eax
 997:	89 45 fc             	mov    %eax,-0x4(%ebp)
 99a:	eb 24                	jmp    9c0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	8b 00                	mov    (%eax),%eax
 9a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9a4:	77 12                	ja     9b8 <free+0x35>
 9a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9ac:	77 24                	ja     9d2 <free+0x4f>
 9ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b1:	8b 00                	mov    (%eax),%eax
 9b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9b6:	77 1a                	ja     9d2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bb:	8b 00                	mov    (%eax),%eax
 9bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9c6:	76 d4                	jbe    99c <free+0x19>
 9c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cb:	8b 00                	mov    (%eax),%eax
 9cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9d0:	76 ca                	jbe    99c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d5:	8b 40 04             	mov    0x4(%eax),%eax
 9d8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e2:	01 c2                	add    %eax,%edx
 9e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e7:	8b 00                	mov    (%eax),%eax
 9e9:	39 c2                	cmp    %eax,%edx
 9eb:	75 24                	jne    a11 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f0:	8b 50 04             	mov    0x4(%eax),%edx
 9f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f6:	8b 00                	mov    (%eax),%eax
 9f8:	8b 40 04             	mov    0x4(%eax),%eax
 9fb:	01 c2                	add    %eax,%edx
 9fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a00:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a06:	8b 00                	mov    (%eax),%eax
 a08:	8b 10                	mov    (%eax),%edx
 a0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0d:	89 10                	mov    %edx,(%eax)
 a0f:	eb 0a                	jmp    a1b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a11:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a14:	8b 10                	mov    (%eax),%edx
 a16:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a19:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1e:	8b 40 04             	mov    0x4(%eax),%eax
 a21:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2b:	01 d0                	add    %edx,%eax
 a2d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a30:	75 20                	jne    a52 <free+0xcf>
    p->s.size += bp->s.size;
 a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a35:	8b 50 04             	mov    0x4(%eax),%edx
 a38:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3b:	8b 40 04             	mov    0x4(%eax),%eax
 a3e:	01 c2                	add    %eax,%edx
 a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a43:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a46:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a49:	8b 10                	mov    (%eax),%edx
 a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4e:	89 10                	mov    %edx,(%eax)
 a50:	eb 08                	jmp    a5a <free+0xd7>
  } else
    p->s.ptr = bp;
 a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a55:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a58:	89 10                	mov    %edx,(%eax)
  freep = p;
 a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5d:	a3 08 0f 00 00       	mov    %eax,0xf08
}
 a62:	90                   	nop
 a63:	c9                   	leave  
 a64:	c3                   	ret    

00000a65 <morecore>:

static Header*
morecore(uint nu)
{
 a65:	55                   	push   %ebp
 a66:	89 e5                	mov    %esp,%ebp
 a68:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a6b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a72:	77 07                	ja     a7b <morecore+0x16>
    nu = 4096;
 a74:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a7b:	8b 45 08             	mov    0x8(%ebp),%eax
 a7e:	c1 e0 03             	shl    $0x3,%eax
 a81:	83 ec 0c             	sub    $0xc,%esp
 a84:	50                   	push   %eax
 a85:	e8 19 fc ff ff       	call   6a3 <sbrk>
 a8a:	83 c4 10             	add    $0x10,%esp
 a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a90:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a94:	75 07                	jne    a9d <morecore+0x38>
    return 0;
 a96:	b8 00 00 00 00       	mov    $0x0,%eax
 a9b:	eb 26                	jmp    ac3 <morecore+0x5e>
  hp = (Header*)p;
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa6:	8b 55 08             	mov    0x8(%ebp),%edx
 aa9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aaf:	83 c0 08             	add    $0x8,%eax
 ab2:	83 ec 0c             	sub    $0xc,%esp
 ab5:	50                   	push   %eax
 ab6:	e8 c8 fe ff ff       	call   983 <free>
 abb:	83 c4 10             	add    $0x10,%esp
  return freep;
 abe:	a1 08 0f 00 00       	mov    0xf08,%eax
}
 ac3:	c9                   	leave  
 ac4:	c3                   	ret    

00000ac5 <malloc>:

void*
malloc(uint nbytes)
{
 ac5:	55                   	push   %ebp
 ac6:	89 e5                	mov    %esp,%ebp
 ac8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 acb:	8b 45 08             	mov    0x8(%ebp),%eax
 ace:	83 c0 07             	add    $0x7,%eax
 ad1:	c1 e8 03             	shr    $0x3,%eax
 ad4:	83 c0 01             	add    $0x1,%eax
 ad7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ada:	a1 08 0f 00 00       	mov    0xf08,%eax
 adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ae6:	75 23                	jne    b0b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 ae8:	c7 45 f0 00 0f 00 00 	movl   $0xf00,-0x10(%ebp)
 aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af2:	a3 08 0f 00 00       	mov    %eax,0xf08
 af7:	a1 08 0f 00 00       	mov    0xf08,%eax
 afc:	a3 00 0f 00 00       	mov    %eax,0xf00
    base.s.size = 0;
 b01:	c7 05 04 0f 00 00 00 	movl   $0x0,0xf04
 b08:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b0e:	8b 00                	mov    (%eax),%eax
 b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b16:	8b 40 04             	mov    0x4(%eax),%eax
 b19:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b1c:	72 4d                	jb     b6b <malloc+0xa6>
      if(p->s.size == nunits)
 b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b21:	8b 40 04             	mov    0x4(%eax),%eax
 b24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b27:	75 0c                	jne    b35 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2c:	8b 10                	mov    (%eax),%edx
 b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b31:	89 10                	mov    %edx,(%eax)
 b33:	eb 26                	jmp    b5b <malloc+0x96>
      else {
        p->s.size -= nunits;
 b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b38:	8b 40 04             	mov    0x4(%eax),%eax
 b3b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b3e:	89 c2                	mov    %eax,%edx
 b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b43:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b49:	8b 40 04             	mov    0x4(%eax),%eax
 b4c:	c1 e0 03             	shl    $0x3,%eax
 b4f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b55:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b58:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b5e:	a3 08 0f 00 00       	mov    %eax,0xf08
      return (void*)(p + 1);
 b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b66:	83 c0 08             	add    $0x8,%eax
 b69:	eb 3b                	jmp    ba6 <malloc+0xe1>
    }
    if(p == freep)
 b6b:	a1 08 0f 00 00       	mov    0xf08,%eax
 b70:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b73:	75 1e                	jne    b93 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b75:	83 ec 0c             	sub    $0xc,%esp
 b78:	ff 75 ec             	pushl  -0x14(%ebp)
 b7b:	e8 e5 fe ff ff       	call   a65 <morecore>
 b80:	83 c4 10             	add    $0x10,%esp
 b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b8a:	75 07                	jne    b93 <malloc+0xce>
        return 0;
 b8c:	b8 00 00 00 00       	mov    $0x0,%eax
 b91:	eb 13                	jmp    ba6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b96:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9c:	8b 00                	mov    (%eax),%eax
 b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ba1:	e9 6d ff ff ff       	jmp    b13 <malloc+0x4e>
}
 ba6:	c9                   	leave  
 ba7:	c3                   	ret    
