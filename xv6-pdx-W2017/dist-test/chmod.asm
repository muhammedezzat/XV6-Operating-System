
_chmod:     file format elf32-i386


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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  char *pathname = 0;
  14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int mode = 0;
  1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // error check for invalid parameters
  if ((argc != 3) || // check number of params
  22:	83 3b 03             	cmpl   $0x3,(%ebx)
  25:	0f 85 ba 00 00 00    	jne    e5 <main+0xe5>
      (argv[1][0] == '-') || // check if mode is negative 
  2b:	8b 43 04             	mov    0x4(%ebx),%eax
  2e:	83 c0 04             	add    $0x4,%eax
  31:	8b 00                	mov    (%eax),%eax
  33:	0f b6 00             	movzbl (%eax),%eax
{
  char *pathname = 0;
  int mode = 0;

  // error check for invalid parameters
  if ((argc != 3) || // check number of params
  36:	3c 2d                	cmp    $0x2d,%al
  38:	0f 84 a7 00 00 00    	je     e5 <main+0xe5>
      (argv[1][0] == '-') || // check if mode is negative 
      (strlen(argv[1]) != 4) || // check if mode is not 4 digits
  3e:	8b 43 04             	mov    0x4(%ebx),%eax
  41:	83 c0 04             	add    $0x4,%eax
  44:	8b 00                	mov    (%eax),%eax
  46:	83 ec 0c             	sub    $0xc,%esp
  49:	50                   	push   %eax
  4a:	e8 9f 01 00 00       	call   1ee <strlen>
  4f:	83 c4 10             	add    $0x10,%esp
  char *pathname = 0;
  int mode = 0;

  // error check for invalid parameters
  if ((argc != 3) || // check number of params
      (argv[1][0] == '-') || // check if mode is negative 
  52:	83 f8 04             	cmp    $0x4,%eax
  55:	0f 85 8a 00 00 00    	jne    e5 <main+0xe5>
      (strlen(argv[1]) != 4) || // check if mode is not 4 digits
      (argv[1][0] < '0' || argv[1][0] > '1') || // check setuid bit
  5b:	8b 43 04             	mov    0x4(%ebx),%eax
  5e:	83 c0 04             	add    $0x4,%eax
  61:	8b 00                	mov    (%eax),%eax
  63:	0f b6 00             	movzbl (%eax),%eax
  int mode = 0;

  // error check for invalid parameters
  if ((argc != 3) || // check number of params
      (argv[1][0] == '-') || // check if mode is negative 
      (strlen(argv[1]) != 4) || // check if mode is not 4 digits
  66:	3c 2f                	cmp    $0x2f,%al
  68:	7e 7b                	jle    e5 <main+0xe5>
      (argv[1][0] < '0' || argv[1][0] > '1') || // check setuid bit
  6a:	8b 43 04             	mov    0x4(%ebx),%eax
  6d:	83 c0 04             	add    $0x4,%eax
  70:	8b 00                	mov    (%eax),%eax
  72:	0f b6 00             	movzbl (%eax),%eax
  75:	3c 31                	cmp    $0x31,%al
  77:	7f 6c                	jg     e5 <main+0xe5>
      (argv[1][1] < '0' || argv[1][1] > '7') || // check user bits
  79:	8b 43 04             	mov    0x4(%ebx),%eax
  7c:	83 c0 04             	add    $0x4,%eax
  7f:	8b 00                	mov    (%eax),%eax
  81:	83 c0 01             	add    $0x1,%eax
  84:	0f b6 00             	movzbl (%eax),%eax

  // error check for invalid parameters
  if ((argc != 3) || // check number of params
      (argv[1][0] == '-') || // check if mode is negative 
      (strlen(argv[1]) != 4) || // check if mode is not 4 digits
      (argv[1][0] < '0' || argv[1][0] > '1') || // check setuid bit
  87:	3c 2f                	cmp    $0x2f,%al
  89:	7e 5a                	jle    e5 <main+0xe5>
      (argv[1][1] < '0' || argv[1][1] > '7') || // check user bits
  8b:	8b 43 04             	mov    0x4(%ebx),%eax
  8e:	83 c0 04             	add    $0x4,%eax
  91:	8b 00                	mov    (%eax),%eax
  93:	83 c0 01             	add    $0x1,%eax
  96:	0f b6 00             	movzbl (%eax),%eax
  99:	3c 37                	cmp    $0x37,%al
  9b:	7f 48                	jg     e5 <main+0xe5>
      (argv[1][2] < '0' || argv[1][2] > '7') || // check group bits
  9d:	8b 43 04             	mov    0x4(%ebx),%eax
  a0:	83 c0 04             	add    $0x4,%eax
  a3:	8b 00                	mov    (%eax),%eax
  a5:	83 c0 02             	add    $0x2,%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  // error check for invalid parameters
  if ((argc != 3) || // check number of params
      (argv[1][0] == '-') || // check if mode is negative 
      (strlen(argv[1]) != 4) || // check if mode is not 4 digits
      (argv[1][0] < '0' || argv[1][0] > '1') || // check setuid bit
      (argv[1][1] < '0' || argv[1][1] > '7') || // check user bits
  ab:	3c 2f                	cmp    $0x2f,%al
  ad:	7e 36                	jle    e5 <main+0xe5>
      (argv[1][2] < '0' || argv[1][2] > '7') || // check group bits
  af:	8b 43 04             	mov    0x4(%ebx),%eax
  b2:	83 c0 04             	add    $0x4,%eax
  b5:	8b 00                	mov    (%eax),%eax
  b7:	83 c0 02             	add    $0x2,%eax
  ba:	0f b6 00             	movzbl (%eax),%eax
  bd:	3c 37                	cmp    $0x37,%al
  bf:	7f 24                	jg     e5 <main+0xe5>
      (argv[1][3] < '0' || argv[1][3] > '7')){ // check other bits
  c1:	8b 43 04             	mov    0x4(%ebx),%eax
  c4:	83 c0 04             	add    $0x4,%eax
  c7:	8b 00                	mov    (%eax),%eax
  c9:	83 c0 03             	add    $0x3,%eax
  cc:	0f b6 00             	movzbl (%eax),%eax
  if ((argc != 3) || // check number of params
      (argv[1][0] == '-') || // check if mode is negative 
      (strlen(argv[1]) != 4) || // check if mode is not 4 digits
      (argv[1][0] < '0' || argv[1][0] > '1') || // check setuid bit
      (argv[1][1] < '0' || argv[1][1] > '7') || // check user bits
      (argv[1][2] < '0' || argv[1][2] > '7') || // check group bits
  cf:	3c 2f                	cmp    $0x2f,%al
  d1:	7e 12                	jle    e5 <main+0xe5>
      (argv[1][3] < '0' || argv[1][3] > '7')){ // check other bits
  d3:	8b 43 04             	mov    0x4(%ebx),%eax
  d6:	83 c0 04             	add    $0x4,%eax
  d9:	8b 00                	mov    (%eax),%eax
  db:	83 c0 03             	add    $0x3,%eax
  de:	0f b6 00             	movzbl (%eax),%eax
  e1:	3c 37                	cmp    $0x37,%al
  e3:	7e 14                	jle    f9 <main+0xf9>

    printf(1, "Invalid parameters.\n");
  e5:	83 ec 08             	sub    $0x8,%esp
  e8:	68 cb 09 00 00       	push   $0x9cb
  ed:	6a 01                	push   $0x1
  ef:	e8 21 05 00 00       	call   615 <printf>
  f4:	83 c4 10             	add    $0x10,%esp
  f7:	eb 5b                	jmp    154 <main+0x154>

  // everything looks good!
  } else {
    
    pathname = argv[2];
  f9:	8b 43 04             	mov    0x4(%ebx),%eax
  fc:	8b 40 08             	mov    0x8(%eax),%eax
  ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    mode = atoo(argv[1]); // use provided octal converter
 102:	8b 43 04             	mov    0x4(%ebx),%eax
 105:	83 c0 04             	add    $0x4,%eax
 108:	8b 00                	mov    (%eax),%eax
 10a:	83 ec 0c             	sub    $0xc,%esp
 10d:	50                   	push   %eax
 10e:	e8 95 02 00 00       	call   3a8 <atoo>
 113:	83 c4 10             	add    $0x10,%esp
 116:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    if(chmod(pathname, mode) == 0)
 119:	83 ec 08             	sub    $0x8,%esp
 11c:	ff 75 f0             	pushl  -0x10(%ebp)
 11f:	ff 75 f4             	pushl  -0xc(%ebp)
 122:	e8 ff 03 00 00       	call   526 <chmod>
 127:	83 c4 10             	add    $0x10,%esp
 12a:	85 c0                	test   %eax,%eax
 12c:	75 14                	jne    142 <main+0x142>
      printf(1, "chmod was successful!\n");
 12e:	83 ec 08             	sub    $0x8,%esp
 131:	68 e0 09 00 00       	push   $0x9e0
 136:	6a 01                	push   $0x1
 138:	e8 d8 04 00 00       	call   615 <printf>
 13d:	83 c4 10             	add    $0x10,%esp
 140:	eb 12                	jmp    154 <main+0x154>
    else
      printf(1, "chmod was unsuccessful...\n");
 142:	83 ec 08             	sub    $0x8,%esp
 145:	68 f7 09 00 00       	push   $0x9f7
 14a:	6a 01                	push   $0x1
 14c:	e8 c4 04 00 00       	call   615 <printf>
 151:	83 c4 10             	add    $0x10,%esp
  }

  exit();
 154:	e8 e5 02 00 00       	call   43e <exit>

00000159 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
 15c:	57                   	push   %edi
 15d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 15e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 161:	8b 55 10             	mov    0x10(%ebp),%edx
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	89 cb                	mov    %ecx,%ebx
 169:	89 df                	mov    %ebx,%edi
 16b:	89 d1                	mov    %edx,%ecx
 16d:	fc                   	cld    
 16e:	f3 aa                	rep stos %al,%es:(%edi)
 170:	89 ca                	mov    %ecx,%edx
 172:	89 fb                	mov    %edi,%ebx
 174:	89 5d 08             	mov    %ebx,0x8(%ebp)
 177:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 17a:	90                   	nop
 17b:	5b                   	pop    %ebx
 17c:	5f                   	pop    %edi
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    

0000017f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
 182:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 18b:	90                   	nop
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	8d 50 01             	lea    0x1(%eax),%edx
 192:	89 55 08             	mov    %edx,0x8(%ebp)
 195:	8b 55 0c             	mov    0xc(%ebp),%edx
 198:	8d 4a 01             	lea    0x1(%edx),%ecx
 19b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 19e:	0f b6 12             	movzbl (%edx),%edx
 1a1:	88 10                	mov    %dl,(%eax)
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	84 c0                	test   %al,%al
 1a8:	75 e2                	jne    18c <strcpy+0xd>
    ;
  return os;
 1aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ad:	c9                   	leave  
 1ae:	c3                   	ret    

000001af <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1b2:	eb 08                	jmp    1bc <strcmp+0xd>
    p++, q++;
 1b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	74 10                	je     1d6 <strcmp+0x27>
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
 1c9:	0f b6 10             	movzbl (%eax),%edx
 1cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cf:	0f b6 00             	movzbl (%eax),%eax
 1d2:	38 c2                	cmp    %al,%dl
 1d4:	74 de                	je     1b4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	0f b6 00             	movzbl (%eax),%eax
 1dc:	0f b6 d0             	movzbl %al,%edx
 1df:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e2:	0f b6 00             	movzbl (%eax),%eax
 1e5:	0f b6 c0             	movzbl %al,%eax
 1e8:	29 c2                	sub    %eax,%edx
 1ea:	89 d0                	mov    %edx,%eax
}
 1ec:	5d                   	pop    %ebp
 1ed:	c3                   	ret    

000001ee <strlen>:

uint
strlen(char *s)
{
 1ee:	55                   	push   %ebp
 1ef:	89 e5                	mov    %esp,%ebp
 1f1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1fb:	eb 04                	jmp    201 <strlen+0x13>
 1fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 201:	8b 55 fc             	mov    -0x4(%ebp),%edx
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	01 d0                	add    %edx,%eax
 209:	0f b6 00             	movzbl (%eax),%eax
 20c:	84 c0                	test   %al,%al
 20e:	75 ed                	jne    1fd <strlen+0xf>
    ;
  return n;
 210:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 213:	c9                   	leave  
 214:	c3                   	ret    

00000215 <memset>:

void*
memset(void *dst, int c, uint n)
{
 215:	55                   	push   %ebp
 216:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 218:	8b 45 10             	mov    0x10(%ebp),%eax
 21b:	50                   	push   %eax
 21c:	ff 75 0c             	pushl  0xc(%ebp)
 21f:	ff 75 08             	pushl  0x8(%ebp)
 222:	e8 32 ff ff ff       	call   159 <stosb>
 227:	83 c4 0c             	add    $0xc,%esp
  return dst;
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <strchr>:

char*
strchr(const char *s, char c)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 04             	sub    $0x4,%esp
 235:	8b 45 0c             	mov    0xc(%ebp),%eax
 238:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 23b:	eb 14                	jmp    251 <strchr+0x22>
    if(*s == c)
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	3a 45 fc             	cmp    -0x4(%ebp),%al
 246:	75 05                	jne    24d <strchr+0x1e>
      return (char*)s;
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	eb 13                	jmp    260 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 24d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	84 c0                	test   %al,%al
 259:	75 e2                	jne    23d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 25b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 260:	c9                   	leave  
 261:	c3                   	ret    

00000262 <gets>:

char*
gets(char *buf, int max)
{
 262:	55                   	push   %ebp
 263:	89 e5                	mov    %esp,%ebp
 265:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 268:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 26f:	eb 42                	jmp    2b3 <gets+0x51>
    cc = read(0, &c, 1);
 271:	83 ec 04             	sub    $0x4,%esp
 274:	6a 01                	push   $0x1
 276:	8d 45 ef             	lea    -0x11(%ebp),%eax
 279:	50                   	push   %eax
 27a:	6a 00                	push   $0x0
 27c:	e8 d5 01 00 00       	call   456 <read>
 281:	83 c4 10             	add    $0x10,%esp
 284:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 287:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 28b:	7e 33                	jle    2c0 <gets+0x5e>
      break;
    buf[i++] = c;
 28d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 290:	8d 50 01             	lea    0x1(%eax),%edx
 293:	89 55 f4             	mov    %edx,-0xc(%ebp)
 296:	89 c2                	mov    %eax,%edx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	01 c2                	add    %eax,%edx
 29d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a7:	3c 0a                	cmp    $0xa,%al
 2a9:	74 16                	je     2c1 <gets+0x5f>
 2ab:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2af:	3c 0d                	cmp    $0xd,%al
 2b1:	74 0e                	je     2c1 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b6:	83 c0 01             	add    $0x1,%eax
 2b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2bc:	7c b3                	jl     271 <gets+0xf>
 2be:	eb 01                	jmp    2c1 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2c0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	01 d0                	add    %edx,%eax
 2c9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2cf:	c9                   	leave  
 2d0:	c3                   	ret    

000002d1 <stat>:

int
stat(char *n, struct stat *st)
{
 2d1:	55                   	push   %ebp
 2d2:	89 e5                	mov    %esp,%ebp
 2d4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d7:	83 ec 08             	sub    $0x8,%esp
 2da:	6a 00                	push   $0x0
 2dc:	ff 75 08             	pushl  0x8(%ebp)
 2df:	e8 9a 01 00 00       	call   47e <open>
 2e4:	83 c4 10             	add    $0x10,%esp
 2e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2ee:	79 07                	jns    2f7 <stat+0x26>
    return -1;
 2f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f5:	eb 25                	jmp    31c <stat+0x4b>
  r = fstat(fd, st);
 2f7:	83 ec 08             	sub    $0x8,%esp
 2fa:	ff 75 0c             	pushl  0xc(%ebp)
 2fd:	ff 75 f4             	pushl  -0xc(%ebp)
 300:	e8 91 01 00 00       	call   496 <fstat>
 305:	83 c4 10             	add    $0x10,%esp
 308:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30b:	83 ec 0c             	sub    $0xc,%esp
 30e:	ff 75 f4             	pushl  -0xc(%ebp)
 311:	e8 50 01 00 00       	call   466 <close>
 316:	83 c4 10             	add    $0x10,%esp
  return r;
 319:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 31c:	c9                   	leave  
 31d:	c3                   	ret    

0000031e <atoi>:

int
atoi(const char *s)
{
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 324:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32b:	eb 25                	jmp    352 <atoi+0x34>
    n = n*10 + *s++ - '0';
 32d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 330:	89 d0                	mov    %edx,%eax
 332:	c1 e0 02             	shl    $0x2,%eax
 335:	01 d0                	add    %edx,%eax
 337:	01 c0                	add    %eax,%eax
 339:	89 c1                	mov    %eax,%ecx
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	8d 50 01             	lea    0x1(%eax),%edx
 341:	89 55 08             	mov    %edx,0x8(%ebp)
 344:	0f b6 00             	movzbl (%eax),%eax
 347:	0f be c0             	movsbl %al,%eax
 34a:	01 c8                	add    %ecx,%eax
 34c:	83 e8 30             	sub    $0x30,%eax
 34f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	0f b6 00             	movzbl (%eax),%eax
 358:	3c 2f                	cmp    $0x2f,%al
 35a:	7e 0a                	jle    366 <atoi+0x48>
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	0f b6 00             	movzbl (%eax),%eax
 362:	3c 39                	cmp    $0x39,%al
 364:	7e c7                	jle    32d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 366:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 369:	c9                   	leave  
 36a:	c3                   	ret    

0000036b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 377:	8b 45 0c             	mov    0xc(%ebp),%eax
 37a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 37d:	eb 17                	jmp    396 <memmove+0x2b>
    *dst++ = *src++;
 37f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 382:	8d 50 01             	lea    0x1(%eax),%edx
 385:	89 55 fc             	mov    %edx,-0x4(%ebp)
 388:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38b:	8d 4a 01             	lea    0x1(%edx),%ecx
 38e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 391:	0f b6 12             	movzbl (%edx),%edx
 394:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 396:	8b 45 10             	mov    0x10(%ebp),%eax
 399:	8d 50 ff             	lea    -0x1(%eax),%edx
 39c:	89 55 10             	mov    %edx,0x10(%ebp)
 39f:	85 c0                	test   %eax,%eax
 3a1:	7f dc                	jg     37f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <atoo>:

int
atoo(const char *s)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3b5:	eb 04                	jmp    3bb <atoo+0x13>
 3b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	0f b6 00             	movzbl (%eax),%eax
 3c1:	3c 20                	cmp    $0x20,%al
 3c3:	74 f2                	je     3b7 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 3c5:	8b 45 08             	mov    0x8(%ebp),%eax
 3c8:	0f b6 00             	movzbl (%eax),%eax
 3cb:	3c 2d                	cmp    $0x2d,%al
 3cd:	75 07                	jne    3d6 <atoo+0x2e>
 3cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3d4:	eb 05                	jmp    3db <atoo+0x33>
 3d6:	b8 01 00 00 00       	mov    $0x1,%eax
 3db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	0f b6 00             	movzbl (%eax),%eax
 3e4:	3c 2b                	cmp    $0x2b,%al
 3e6:	74 0a                	je     3f2 <atoo+0x4a>
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	0f b6 00             	movzbl (%eax),%eax
 3ee:	3c 2d                	cmp    $0x2d,%al
 3f0:	75 27                	jne    419 <atoo+0x71>
    s++;
 3f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3f6:	eb 21                	jmp    419 <atoo+0x71>
    n = n*8 + *s++ - '0';
 3f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fb:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	8d 50 01             	lea    0x1(%eax),%edx
 408:	89 55 08             	mov    %edx,0x8(%ebp)
 40b:	0f b6 00             	movzbl (%eax),%eax
 40e:	0f be c0             	movsbl %al,%eax
 411:	01 c8                	add    %ecx,%eax
 413:	83 e8 30             	sub    $0x30,%eax
 416:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 419:	8b 45 08             	mov    0x8(%ebp),%eax
 41c:	0f b6 00             	movzbl (%eax),%eax
 41f:	3c 2f                	cmp    $0x2f,%al
 421:	7e 0a                	jle    42d <atoo+0x85>
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	3c 37                	cmp    $0x37,%al
 42b:	7e cb                	jle    3f8 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 42d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 430:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 434:	c9                   	leave  
 435:	c3                   	ret    

00000436 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 436:	b8 01 00 00 00       	mov    $0x1,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <exit>:
SYSCALL(exit)
 43e:	b8 02 00 00 00       	mov    $0x2,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <wait>:
SYSCALL(wait)
 446:	b8 03 00 00 00       	mov    $0x3,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <pipe>:
SYSCALL(pipe)
 44e:	b8 04 00 00 00       	mov    $0x4,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <read>:
SYSCALL(read)
 456:	b8 05 00 00 00       	mov    $0x5,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <write>:
SYSCALL(write)
 45e:	b8 10 00 00 00       	mov    $0x10,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <close>:
SYSCALL(close)
 466:	b8 15 00 00 00       	mov    $0x15,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <kill>:
SYSCALL(kill)
 46e:	b8 06 00 00 00       	mov    $0x6,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <exec>:
SYSCALL(exec)
 476:	b8 07 00 00 00       	mov    $0x7,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <open>:
SYSCALL(open)
 47e:	b8 0f 00 00 00       	mov    $0xf,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <mknod>:
SYSCALL(mknod)
 486:	b8 11 00 00 00       	mov    $0x11,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <unlink>:
SYSCALL(unlink)
 48e:	b8 12 00 00 00       	mov    $0x12,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <fstat>:
SYSCALL(fstat)
 496:	b8 08 00 00 00       	mov    $0x8,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <link>:
SYSCALL(link)
 49e:	b8 13 00 00 00       	mov    $0x13,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <mkdir>:
SYSCALL(mkdir)
 4a6:	b8 14 00 00 00       	mov    $0x14,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <chdir>:
SYSCALL(chdir)
 4ae:	b8 09 00 00 00       	mov    $0x9,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <dup>:
SYSCALL(dup)
 4b6:	b8 0a 00 00 00       	mov    $0xa,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <getpid>:
SYSCALL(getpid)
 4be:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <sbrk>:
SYSCALL(sbrk)
 4c6:	b8 0c 00 00 00       	mov    $0xc,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <sleep>:
SYSCALL(sleep)
 4ce:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <uptime>:
SYSCALL(uptime)
 4d6:	b8 0e 00 00 00       	mov    $0xe,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <halt>:
SYSCALL(halt)
 4de:	b8 16 00 00 00       	mov    $0x16,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 4e6:	b8 17 00 00 00       	mov    $0x17,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 4ee:	b8 18 00 00 00       	mov    $0x18,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 4f6:	b8 19 00 00 00       	mov    $0x19,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 4fe:	b8 1a 00 00 00       	mov    $0x1a,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 506:	b8 1b 00 00 00       	mov    $0x1b,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 50e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 516:	b8 1d 00 00 00       	mov    $0x1d,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 51e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret    

00000526 <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 526:	b8 1f 00 00 00       	mov    $0x1f,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret    

0000052e <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 52e:	b8 20 00 00 00       	mov    $0x20,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 536:	b8 21 00 00 00       	mov    $0x21,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 53e:	55                   	push   %ebp
 53f:	89 e5                	mov    %esp,%ebp
 541:	83 ec 18             	sub    $0x18,%esp
 544:	8b 45 0c             	mov    0xc(%ebp),%eax
 547:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 54a:	83 ec 04             	sub    $0x4,%esp
 54d:	6a 01                	push   $0x1
 54f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 552:	50                   	push   %eax
 553:	ff 75 08             	pushl  0x8(%ebp)
 556:	e8 03 ff ff ff       	call   45e <write>
 55b:	83 c4 10             	add    $0x10,%esp
}
 55e:	90                   	nop
 55f:	c9                   	leave  
 560:	c3                   	ret    

00000561 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 561:	55                   	push   %ebp
 562:	89 e5                	mov    %esp,%ebp
 564:	53                   	push   %ebx
 565:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 568:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 56f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 573:	74 17                	je     58c <printint+0x2b>
 575:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 579:	79 11                	jns    58c <printint+0x2b>
    neg = 1;
 57b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 582:	8b 45 0c             	mov    0xc(%ebp),%eax
 585:	f7 d8                	neg    %eax
 587:	89 45 ec             	mov    %eax,-0x14(%ebp)
 58a:	eb 06                	jmp    592 <printint+0x31>
  } else {
    x = xx;
 58c:	8b 45 0c             	mov    0xc(%ebp),%eax
 58f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 592:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 599:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 59c:	8d 41 01             	lea    0x1(%ecx),%eax
 59f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a8:	ba 00 00 00 00       	mov    $0x0,%edx
 5ad:	f7 f3                	div    %ebx
 5af:	89 d0                	mov    %edx,%eax
 5b1:	0f b6 80 88 0c 00 00 	movzbl 0xc88(%eax),%eax
 5b8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c2:	ba 00 00 00 00       	mov    $0x0,%edx
 5c7:	f7 f3                	div    %ebx
 5c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d0:	75 c7                	jne    599 <printint+0x38>
  if(neg)
 5d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d6:	74 2d                	je     605 <printint+0xa4>
    buf[i++] = '-';
 5d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5db:	8d 50 01             	lea    0x1(%eax),%edx
 5de:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5e1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5e6:	eb 1d                	jmp    605 <printint+0xa4>
    putc(fd, buf[i]);
 5e8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ee:	01 d0                	add    %edx,%eax
 5f0:	0f b6 00             	movzbl (%eax),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	83 ec 08             	sub    $0x8,%esp
 5f9:	50                   	push   %eax
 5fa:	ff 75 08             	pushl  0x8(%ebp)
 5fd:	e8 3c ff ff ff       	call   53e <putc>
 602:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 605:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60d:	79 d9                	jns    5e8 <printint+0x87>
    putc(fd, buf[i]);
}
 60f:	90                   	nop
 610:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 613:	c9                   	leave  
 614:	c3                   	ret    

00000615 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 615:	55                   	push   %ebp
 616:	89 e5                	mov    %esp,%ebp
 618:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 61b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 622:	8d 45 0c             	lea    0xc(%ebp),%eax
 625:	83 c0 04             	add    $0x4,%eax
 628:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 62b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 632:	e9 59 01 00 00       	jmp    790 <printf+0x17b>
    c = fmt[i] & 0xff;
 637:	8b 55 0c             	mov    0xc(%ebp),%edx
 63a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63d:	01 d0                	add    %edx,%eax
 63f:	0f b6 00             	movzbl (%eax),%eax
 642:	0f be c0             	movsbl %al,%eax
 645:	25 ff 00 00 00       	and    $0xff,%eax
 64a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 64d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 651:	75 2c                	jne    67f <printf+0x6a>
      if(c == '%'){
 653:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 657:	75 0c                	jne    665 <printf+0x50>
        state = '%';
 659:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 660:	e9 27 01 00 00       	jmp    78c <printf+0x177>
      } else {
        putc(fd, c);
 665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 668:	0f be c0             	movsbl %al,%eax
 66b:	83 ec 08             	sub    $0x8,%esp
 66e:	50                   	push   %eax
 66f:	ff 75 08             	pushl  0x8(%ebp)
 672:	e8 c7 fe ff ff       	call   53e <putc>
 677:	83 c4 10             	add    $0x10,%esp
 67a:	e9 0d 01 00 00       	jmp    78c <printf+0x177>
      }
    } else if(state == '%'){
 67f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 683:	0f 85 03 01 00 00    	jne    78c <printf+0x177>
      if(c == 'd'){
 689:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 68d:	75 1e                	jne    6ad <printf+0x98>
        printint(fd, *ap, 10, 1);
 68f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	6a 01                	push   $0x1
 696:	6a 0a                	push   $0xa
 698:	50                   	push   %eax
 699:	ff 75 08             	pushl  0x8(%ebp)
 69c:	e8 c0 fe ff ff       	call   561 <printint>
 6a1:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a8:	e9 d8 00 00 00       	jmp    785 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6ad:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6b1:	74 06                	je     6b9 <printf+0xa4>
 6b3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b7:	75 1e                	jne    6d7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	6a 00                	push   $0x0
 6c0:	6a 10                	push   $0x10
 6c2:	50                   	push   %eax
 6c3:	ff 75 08             	pushl  0x8(%ebp)
 6c6:	e8 96 fe ff ff       	call   561 <printint>
 6cb:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d2:	e9 ae 00 00 00       	jmp    785 <printf+0x170>
      } else if(c == 's'){
 6d7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6db:	75 43                	jne    720 <printf+0x10b>
        s = (char*)*ap;
 6dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ed:	75 25                	jne    714 <printf+0xff>
          s = "(null)";
 6ef:	c7 45 f4 12 0a 00 00 	movl   $0xa12,-0xc(%ebp)
        while(*s != 0){
 6f6:	eb 1c                	jmp    714 <printf+0xff>
          putc(fd, *s);
 6f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fb:	0f b6 00             	movzbl (%eax),%eax
 6fe:	0f be c0             	movsbl %al,%eax
 701:	83 ec 08             	sub    $0x8,%esp
 704:	50                   	push   %eax
 705:	ff 75 08             	pushl  0x8(%ebp)
 708:	e8 31 fe ff ff       	call   53e <putc>
 70d:	83 c4 10             	add    $0x10,%esp
          s++;
 710:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 714:	8b 45 f4             	mov    -0xc(%ebp),%eax
 717:	0f b6 00             	movzbl (%eax),%eax
 71a:	84 c0                	test   %al,%al
 71c:	75 da                	jne    6f8 <printf+0xe3>
 71e:	eb 65                	jmp    785 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 720:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 724:	75 1d                	jne    743 <printf+0x12e>
        putc(fd, *ap);
 726:	8b 45 e8             	mov    -0x18(%ebp),%eax
 729:	8b 00                	mov    (%eax),%eax
 72b:	0f be c0             	movsbl %al,%eax
 72e:	83 ec 08             	sub    $0x8,%esp
 731:	50                   	push   %eax
 732:	ff 75 08             	pushl  0x8(%ebp)
 735:	e8 04 fe ff ff       	call   53e <putc>
 73a:	83 c4 10             	add    $0x10,%esp
        ap++;
 73d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 741:	eb 42                	jmp    785 <printf+0x170>
      } else if(c == '%'){
 743:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 747:	75 17                	jne    760 <printf+0x14b>
        putc(fd, c);
 749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74c:	0f be c0             	movsbl %al,%eax
 74f:	83 ec 08             	sub    $0x8,%esp
 752:	50                   	push   %eax
 753:	ff 75 08             	pushl  0x8(%ebp)
 756:	e8 e3 fd ff ff       	call   53e <putc>
 75b:	83 c4 10             	add    $0x10,%esp
 75e:	eb 25                	jmp    785 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 760:	83 ec 08             	sub    $0x8,%esp
 763:	6a 25                	push   $0x25
 765:	ff 75 08             	pushl  0x8(%ebp)
 768:	e8 d1 fd ff ff       	call   53e <putc>
 76d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 773:	0f be c0             	movsbl %al,%eax
 776:	83 ec 08             	sub    $0x8,%esp
 779:	50                   	push   %eax
 77a:	ff 75 08             	pushl  0x8(%ebp)
 77d:	e8 bc fd ff ff       	call   53e <putc>
 782:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 785:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 78c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 790:	8b 55 0c             	mov    0xc(%ebp),%edx
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	01 d0                	add    %edx,%eax
 798:	0f b6 00             	movzbl (%eax),%eax
 79b:	84 c0                	test   %al,%al
 79d:	0f 85 94 fe ff ff    	jne    637 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7a3:	90                   	nop
 7a4:	c9                   	leave  
 7a5:	c3                   	ret    

000007a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a6:	55                   	push   %ebp
 7a7:	89 e5                	mov    %esp,%ebp
 7a9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	83 e8 08             	sub    $0x8,%eax
 7b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b5:	a1 a4 0c 00 00       	mov    0xca4,%eax
 7ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7bd:	eb 24                	jmp    7e3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	8b 00                	mov    (%eax),%eax
 7c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c7:	77 12                	ja     7db <free+0x35>
 7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cf:	77 24                	ja     7f5 <free+0x4f>
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d9:	77 1a                	ja     7f5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	8b 00                	mov    (%eax),%eax
 7e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e9:	76 d4                	jbe    7bf <free+0x19>
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f3:	76 ca                	jbe    7bf <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	8b 40 04             	mov    0x4(%eax),%eax
 7fb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 802:	8b 45 f8             	mov    -0x8(%ebp),%eax
 805:	01 c2                	add    %eax,%edx
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 00                	mov    (%eax),%eax
 80c:	39 c2                	cmp    %eax,%edx
 80e:	75 24                	jne    834 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 810:	8b 45 f8             	mov    -0x8(%ebp),%eax
 813:	8b 50 04             	mov    0x4(%eax),%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	8b 00                	mov    (%eax),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	01 c2                	add    %eax,%edx
 820:	8b 45 f8             	mov    -0x8(%ebp),%eax
 823:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	8b 00                	mov    (%eax),%eax
 82b:	8b 10                	mov    (%eax),%edx
 82d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 830:	89 10                	mov    %edx,(%eax)
 832:	eb 0a                	jmp    83e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	8b 10                	mov    (%eax),%edx
 839:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	8b 40 04             	mov    0x4(%eax),%eax
 844:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 84b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84e:	01 d0                	add    %edx,%eax
 850:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 853:	75 20                	jne    875 <free+0xcf>
    p->s.size += bp->s.size;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 50 04             	mov    0x4(%eax),%edx
 85b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85e:	8b 40 04             	mov    0x4(%eax),%eax
 861:	01 c2                	add    %eax,%edx
 863:	8b 45 fc             	mov    -0x4(%ebp),%eax
 866:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 869:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86c:	8b 10                	mov    (%eax),%edx
 86e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 871:	89 10                	mov    %edx,(%eax)
 873:	eb 08                	jmp    87d <free+0xd7>
  } else
    p->s.ptr = bp;
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	8b 55 f8             	mov    -0x8(%ebp),%edx
 87b:	89 10                	mov    %edx,(%eax)
  freep = p;
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	a3 a4 0c 00 00       	mov    %eax,0xca4
}
 885:	90                   	nop
 886:	c9                   	leave  
 887:	c3                   	ret    

00000888 <morecore>:

static Header*
morecore(uint nu)
{
 888:	55                   	push   %ebp
 889:	89 e5                	mov    %esp,%ebp
 88b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 88e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 895:	77 07                	ja     89e <morecore+0x16>
    nu = 4096;
 897:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 89e:	8b 45 08             	mov    0x8(%ebp),%eax
 8a1:	c1 e0 03             	shl    $0x3,%eax
 8a4:	83 ec 0c             	sub    $0xc,%esp
 8a7:	50                   	push   %eax
 8a8:	e8 19 fc ff ff       	call   4c6 <sbrk>
 8ad:	83 c4 10             	add    $0x10,%esp
 8b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b7:	75 07                	jne    8c0 <morecore+0x38>
    return 0;
 8b9:	b8 00 00 00 00       	mov    $0x0,%eax
 8be:	eb 26                	jmp    8e6 <morecore+0x5e>
  hp = (Header*)p;
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c9:	8b 55 08             	mov    0x8(%ebp),%edx
 8cc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d2:	83 c0 08             	add    $0x8,%eax
 8d5:	83 ec 0c             	sub    $0xc,%esp
 8d8:	50                   	push   %eax
 8d9:	e8 c8 fe ff ff       	call   7a6 <free>
 8de:	83 c4 10             	add    $0x10,%esp
  return freep;
 8e1:	a1 a4 0c 00 00       	mov    0xca4,%eax
}
 8e6:	c9                   	leave  
 8e7:	c3                   	ret    

000008e8 <malloc>:

void*
malloc(uint nbytes)
{
 8e8:	55                   	push   %ebp
 8e9:	89 e5                	mov    %esp,%ebp
 8eb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ee:	8b 45 08             	mov    0x8(%ebp),%eax
 8f1:	83 c0 07             	add    $0x7,%eax
 8f4:	c1 e8 03             	shr    $0x3,%eax
 8f7:	83 c0 01             	add    $0x1,%eax
 8fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8fd:	a1 a4 0c 00 00       	mov    0xca4,%eax
 902:	89 45 f0             	mov    %eax,-0x10(%ebp)
 905:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 909:	75 23                	jne    92e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 90b:	c7 45 f0 9c 0c 00 00 	movl   $0xc9c,-0x10(%ebp)
 912:	8b 45 f0             	mov    -0x10(%ebp),%eax
 915:	a3 a4 0c 00 00       	mov    %eax,0xca4
 91a:	a1 a4 0c 00 00       	mov    0xca4,%eax
 91f:	a3 9c 0c 00 00       	mov    %eax,0xc9c
    base.s.size = 0;
 924:	c7 05 a0 0c 00 00 00 	movl   $0x0,0xca0
 92b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 931:	8b 00                	mov    (%eax),%eax
 933:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 936:	8b 45 f4             	mov    -0xc(%ebp),%eax
 939:	8b 40 04             	mov    0x4(%eax),%eax
 93c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93f:	72 4d                	jb     98e <malloc+0xa6>
      if(p->s.size == nunits)
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	8b 40 04             	mov    0x4(%eax),%eax
 947:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 94a:	75 0c                	jne    958 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	8b 10                	mov    (%eax),%edx
 951:	8b 45 f0             	mov    -0x10(%ebp),%eax
 954:	89 10                	mov    %edx,(%eax)
 956:	eb 26                	jmp    97e <malloc+0x96>
      else {
        p->s.size -= nunits;
 958:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95b:	8b 40 04             	mov    0x4(%eax),%eax
 95e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 961:	89 c2                	mov    %eax,%edx
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 969:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96c:	8b 40 04             	mov    0x4(%eax),%eax
 96f:	c1 e0 03             	shl    $0x3,%eax
 972:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 975:	8b 45 f4             	mov    -0xc(%ebp),%eax
 978:	8b 55 ec             	mov    -0x14(%ebp),%edx
 97b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 97e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 981:	a3 a4 0c 00 00       	mov    %eax,0xca4
      return (void*)(p + 1);
 986:	8b 45 f4             	mov    -0xc(%ebp),%eax
 989:	83 c0 08             	add    $0x8,%eax
 98c:	eb 3b                	jmp    9c9 <malloc+0xe1>
    }
    if(p == freep)
 98e:	a1 a4 0c 00 00       	mov    0xca4,%eax
 993:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 996:	75 1e                	jne    9b6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 998:	83 ec 0c             	sub    $0xc,%esp
 99b:	ff 75 ec             	pushl  -0x14(%ebp)
 99e:	e8 e5 fe ff ff       	call   888 <morecore>
 9a3:	83 c4 10             	add    $0x10,%esp
 9a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ad:	75 07                	jne    9b6 <malloc+0xce>
        return 0;
 9af:	b8 00 00 00 00       	mov    $0x0,%eax
 9b4:	eb 13                	jmp    9c9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bf:	8b 00                	mov    (%eax),%eax
 9c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9c4:	e9 6d ff ff ff       	jmp    936 <malloc+0x4e>
}
 9c9:	c9                   	leave  
 9ca:	c3                   	ret    
