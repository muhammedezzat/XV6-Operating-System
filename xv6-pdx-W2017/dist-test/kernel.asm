
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 e6 10 80       	mov    $0x8010e670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 35 39 10 80       	mov    $0x80103935,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 f4 99 10 80       	push   $0x801099f4
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 a1 62 00 00       	call   801062ed <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 25 11 80 84 	movl   $0x80112584,0x80112590
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 25 11 80 84 	movl   $0x80112584,0x80112594
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 e6 10 80 	movl   $0x8010e6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 25 11 80       	mov    0x80112594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 25 11 80       	mov    %eax,0x80112594
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 25 11 80       	mov    $0x80112584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 e6 10 80       	push   $0x8010e680
801000c1:	e8 49 62 00 00       	call   8010630f <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 25 11 80       	mov    0x80112594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 e6 10 80       	push   $0x8010e680
8010010c:	e8 65 62 00 00       	call   80106376 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 a0 52 00 00       	call   801053cc <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 25 11 80       	mov    0x80112590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 e6 10 80       	push   $0x8010e680
80100188:	e8 e9 61 00 00       	call   80106376 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 fb 99 10 80       	push   $0x801099fb
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 cc 27 00 00       	call   801029b3 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 0c 9a 10 80       	push   $0x80109a0c
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 8b 27 00 00       	call   801029b3 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 13 9a 10 80       	push   $0x80109a13
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 b5 60 00 00       	call   8010630f <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 25 11 80       	mov    0x80112594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 25 11 80       	mov    %eax,0x80112594

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 69 52 00 00       	call   80105527 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 a8 60 00 00       	call   80106376 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 d6 10 80       	mov    0x8010d614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 d5 10 80       	push   $0x8010d5e0
801003e2:	e8 28 5f 00 00       	call   8010630f <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 1a 9a 10 80       	push   $0x80109a1a
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec 23 9a 10 80 	movl   $0x80109a23,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 d5 10 80       	push   $0x8010d5e0
8010055b:	e8 16 5e 00 00       	call   80106376 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 14 d6 10 80 00 	movl   $0x0,0x8010d614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 2a 9a 10 80       	push   $0x80109a2a
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 39 9a 10 80       	push   $0x80109a39
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 01 5e 00 00       	call   801063c8 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 3b 9a 10 80       	push   $0x80109a3b
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 c0 d5 10 80 01 	movl   $0x1,0x8010d5c0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 3f 9a 10 80       	push   $0x80109a3f
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 35 5f 00 00       	call   80106631 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 4c 5e 00 00       	call   80106572 <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 c0 d5 10 80       	mov    0x8010d5c0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 c1 78 00 00       	call   8010807c <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 b4 78 00 00       	call   8010807c <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 a7 78 00 00       	call   8010807c <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 97 78 00 00       	call   8010807c <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0, doreadydump = 0, dofreedump = 0, dosleepdump = 0, dozombiedump = 0; // Added ready-zombie for Project 3: New Console Control Sequences
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010080d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100814:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
8010081b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

  acquire(&cons.lock);
80100822:	83 ec 0c             	sub    $0xc,%esp
80100825:	68 e0 d5 10 80       	push   $0x8010d5e0
8010082a:	e8 e0 5a 00 00       	call   8010630f <acquire>
8010082f:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100832:	e9 9a 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    switch(c){
80100837:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010083a:	83 f8 12             	cmp    $0x12,%eax
8010083d:	74 50                	je     8010088f <consoleintr+0x96>
8010083f:	83 f8 12             	cmp    $0x12,%eax
80100842:	7f 18                	jg     8010085c <consoleintr+0x63>
80100844:	83 f8 08             	cmp    $0x8,%eax
80100847:	0f 84 bd 00 00 00    	je     8010090a <consoleintr+0x111>
8010084d:	83 f8 10             	cmp    $0x10,%eax
80100850:	74 31                	je     80100883 <consoleintr+0x8a>
80100852:	83 f8 06             	cmp    $0x6,%eax
80100855:	74 44                	je     8010089b <consoleintr+0xa2>
80100857:	e9 e3 00 00 00       	jmp    8010093f <consoleintr+0x146>
8010085c:	83 f8 15             	cmp    $0x15,%eax
8010085f:	74 7b                	je     801008dc <consoleintr+0xe3>
80100861:	83 f8 15             	cmp    $0x15,%eax
80100864:	7f 0a                	jg     80100870 <consoleintr+0x77>
80100866:	83 f8 13             	cmp    $0x13,%eax
80100869:	74 3c                	je     801008a7 <consoleintr+0xae>
8010086b:	e9 cf 00 00 00       	jmp    8010093f <consoleintr+0x146>
80100870:	83 f8 1a             	cmp    $0x1a,%eax
80100873:	74 3e                	je     801008b3 <consoleintr+0xba>
80100875:	83 f8 7f             	cmp    $0x7f,%eax
80100878:	0f 84 8c 00 00 00    	je     8010090a <consoleintr+0x111>
8010087e:	e9 bc 00 00 00       	jmp    8010093f <consoleintr+0x146>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100883:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010088a:	e9 42 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('R'): 	// START: Added for Project 3: New Console Control Sequence
      doreadydump = 1;
8010088f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
80100896:	e9 36 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('F'):
      dofreedump = 1;
8010089b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
      break;
801008a2:	e9 2a 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('S'):
      dosleepdump = 1;
801008a7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
      break;
801008ae:	e9 1e 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('Z'):
      dozombiedump = 1;
801008b3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;		// END: Added for Project 3: New Console Control Sequence
801008ba:	e9 12 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008bf:	a1 28 28 11 80       	mov    0x80112828,%eax
801008c4:	83 e8 01             	sub    $0x1,%eax
801008c7:	a3 28 28 11 80       	mov    %eax,0x80112828
        consputc(BACKSPACE);
801008cc:	83 ec 0c             	sub    $0xc,%esp
801008cf:	68 00 01 00 00       	push   $0x100
801008d4:	e8 b9 fe ff ff       	call   80100792 <consputc>
801008d9:	83 c4 10             	add    $0x10,%esp
      break;
    case C('Z'):
      dozombiedump = 1;
      break;		// END: Added for Project 3: New Console Control Sequence
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008dc:	8b 15 28 28 11 80    	mov    0x80112828,%edx
801008e2:	a1 24 28 11 80       	mov    0x80112824,%eax
801008e7:	39 c2                	cmp    %eax,%edx
801008e9:	0f 84 e2 00 00 00    	je     801009d1 <consoleintr+0x1d8>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008ef:	a1 28 28 11 80       	mov    0x80112828,%eax
801008f4:	83 e8 01             	sub    $0x1,%eax
801008f7:	83 e0 7f             	and    $0x7f,%eax
801008fa:	0f b6 80 a0 27 11 80 	movzbl -0x7feed860(%eax),%eax
      break;
    case C('Z'):
      dozombiedump = 1;
      break;		// END: Added for Project 3: New Console Control Sequence
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100901:	3c 0a                	cmp    $0xa,%al
80100903:	75 ba                	jne    801008bf <consoleintr+0xc6>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100905:	e9 c7 00 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010090a:	8b 15 28 28 11 80    	mov    0x80112828,%edx
80100910:	a1 24 28 11 80       	mov    0x80112824,%eax
80100915:	39 c2                	cmp    %eax,%edx
80100917:	0f 84 b4 00 00 00    	je     801009d1 <consoleintr+0x1d8>
        input.e--;
8010091d:	a1 28 28 11 80       	mov    0x80112828,%eax
80100922:	83 e8 01             	sub    $0x1,%eax
80100925:	a3 28 28 11 80       	mov    %eax,0x80112828
        consputc(BACKSPACE);
8010092a:	83 ec 0c             	sub    $0xc,%esp
8010092d:	68 00 01 00 00       	push   $0x100
80100932:	e8 5b fe ff ff       	call   80100792 <consputc>
80100937:	83 c4 10             	add    $0x10,%esp
      }
      break;
8010093a:	e9 92 00 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010093f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100943:	0f 84 87 00 00 00    	je     801009d0 <consoleintr+0x1d7>
80100949:	8b 15 28 28 11 80    	mov    0x80112828,%edx
8010094f:	a1 20 28 11 80       	mov    0x80112820,%eax
80100954:	29 c2                	sub    %eax,%edx
80100956:	89 d0                	mov    %edx,%eax
80100958:	83 f8 7f             	cmp    $0x7f,%eax
8010095b:	77 73                	ja     801009d0 <consoleintr+0x1d7>
        c = (c == '\r') ? '\n' : c;
8010095d:	83 7d e0 0d          	cmpl   $0xd,-0x20(%ebp)
80100961:	74 05                	je     80100968 <consoleintr+0x16f>
80100963:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100966:	eb 05                	jmp    8010096d <consoleintr+0x174>
80100968:	b8 0a 00 00 00       	mov    $0xa,%eax
8010096d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100970:	a1 28 28 11 80       	mov    0x80112828,%eax
80100975:	8d 50 01             	lea    0x1(%eax),%edx
80100978:	89 15 28 28 11 80    	mov    %edx,0x80112828
8010097e:	83 e0 7f             	and    $0x7f,%eax
80100981:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100984:	88 90 a0 27 11 80    	mov    %dl,-0x7feed860(%eax)
        consputc(c);
8010098a:	83 ec 0c             	sub    $0xc,%esp
8010098d:	ff 75 e0             	pushl  -0x20(%ebp)
80100990:	e8 fd fd ff ff       	call   80100792 <consputc>
80100995:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100998:	83 7d e0 0a          	cmpl   $0xa,-0x20(%ebp)
8010099c:	74 18                	je     801009b6 <consoleintr+0x1bd>
8010099e:	83 7d e0 04          	cmpl   $0x4,-0x20(%ebp)
801009a2:	74 12                	je     801009b6 <consoleintr+0x1bd>
801009a4:	a1 28 28 11 80       	mov    0x80112828,%eax
801009a9:	8b 15 20 28 11 80    	mov    0x80112820,%edx
801009af:	83 ea 80             	sub    $0xffffff80,%edx
801009b2:	39 d0                	cmp    %edx,%eax
801009b4:	75 1a                	jne    801009d0 <consoleintr+0x1d7>
          input.w = input.e;
801009b6:	a1 28 28 11 80       	mov    0x80112828,%eax
801009bb:	a3 24 28 11 80       	mov    %eax,0x80112824
          wakeup(&input.r);
801009c0:	83 ec 0c             	sub    $0xc,%esp
801009c3:	68 20 28 11 80       	push   $0x80112820
801009c8:	e8 5a 4b 00 00       	call   80105527 <wakeup>
801009cd:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009d0:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0, doreadydump = 0, dofreedump = 0, dosleepdump = 0, dozombiedump = 0; // Added ready-zombie for Project 3: New Console Control Sequences

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009d1:	8b 45 08             	mov    0x8(%ebp),%eax
801009d4:	ff d0                	call   *%eax
801009d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801009d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801009dd:	0f 89 54 fe ff ff    	jns    80100837 <consoleintr+0x3e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009e3:	83 ec 0c             	sub    $0xc,%esp
801009e6:	68 e0 d5 10 80       	push   $0x8010d5e0
801009eb:	e8 86 59 00 00       	call   80106376 <release>
801009f0:	83 c4 10             	add    $0x10,%esp
  if(doprocdump)
801009f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009f7:	74 07                	je     80100a00 <consoleintr+0x207>
    procdump();  // now call procdump() wo. cons.lock held
801009f9:	e8 2b 4c 00 00       	call   80105629 <procdump>
  else if(dosleepdump)
    sleepdump();
  else if(dozombiedump)
    zombiedump();	// END: Added for Project 3: New Console Control Sequence
    
}
801009fe:	eb 32                	jmp    80100a32 <consoleintr+0x239>
    }
  }
  release(&cons.lock);
  if(doprocdump)
    procdump();  // now call procdump() wo. cons.lock held
  else if(doreadydump) 	// START: Added for Project 3: New Console Control Sequence
80100a00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a04:	74 07                	je     80100a0d <consoleintr+0x214>
    readydump();
80100a06:	e8 67 4e 00 00       	call   80105872 <readydump>
  else if(dosleepdump)
    sleepdump();
  else if(dozombiedump)
    zombiedump();	// END: Added for Project 3: New Console Control Sequence
    
}
80100a0b:	eb 25                	jmp    80100a32 <consoleintr+0x239>
  release(&cons.lock);
  if(doprocdump)
    procdump();  // now call procdump() wo. cons.lock held
  else if(doreadydump) 	// START: Added for Project 3: New Console Control Sequence
    readydump();
  else if(dofreedump)
80100a0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a11:	74 07                	je     80100a1a <consoleintr+0x221>
    freedump();
80100a13:	e8 54 4f 00 00       	call   8010596c <freedump>
  else if(dosleepdump)
    sleepdump();
  else if(dozombiedump)
    zombiedump();	// END: Added for Project 3: New Console Control Sequence
    
}
80100a18:	eb 18                	jmp    80100a32 <consoleintr+0x239>
    procdump();  // now call procdump() wo. cons.lock held
  else if(doreadydump) 	// START: Added for Project 3: New Console Control Sequence
    readydump();
  else if(dofreedump)
    freedump();
  else if(dosleepdump)
80100a1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a1e:	74 07                	je     80100a27 <consoleintr+0x22e>
    sleepdump();
80100a20:	e8 aa 4f 00 00       	call   801059cf <sleepdump>
  else if(dozombiedump)
    zombiedump();	// END: Added for Project 3: New Console Control Sequence
    
}
80100a25:	eb 0b                	jmp    80100a32 <consoleintr+0x239>
    readydump();
  else if(dofreedump)
    freedump();
  else if(dosleepdump)
    sleepdump();
  else if(dozombiedump)
80100a27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a2b:	74 05                	je     80100a32 <consoleintr+0x239>
    zombiedump();	// END: Added for Project 3: New Console Control Sequence
80100a2d:	e8 45 50 00 00       	call   80105a77 <zombiedump>
    
}
80100a32:	90                   	nop
80100a33:	c9                   	leave  
80100a34:	c3                   	ret    

80100a35 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a35:	55                   	push   %ebp
80100a36:	89 e5                	mov    %esp,%ebp
80100a38:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a3b:	83 ec 0c             	sub    $0xc,%esp
80100a3e:	ff 75 08             	pushl  0x8(%ebp)
80100a41:	e8 28 11 00 00       	call   80101b6e <iunlock>
80100a46:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a49:	8b 45 10             	mov    0x10(%ebp),%eax
80100a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a4f:	83 ec 0c             	sub    $0xc,%esp
80100a52:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a57:	e8 b3 58 00 00       	call   8010630f <acquire>
80100a5c:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a5f:	e9 ac 00 00 00       	jmp    80100b10 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a6a:	8b 40 24             	mov    0x24(%eax),%eax
80100a6d:	85 c0                	test   %eax,%eax
80100a6f:	74 28                	je     80100a99 <consoleread+0x64>
        release(&cons.lock);
80100a71:	83 ec 0c             	sub    $0xc,%esp
80100a74:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a79:	e8 f8 58 00 00       	call   80106376 <release>
80100a7e:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a81:	83 ec 0c             	sub    $0xc,%esp
80100a84:	ff 75 08             	pushl  0x8(%ebp)
80100a87:	e8 84 0f 00 00       	call   80101a10 <ilock>
80100a8c:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a94:	e9 ab 00 00 00       	jmp    80100b44 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a99:	83 ec 08             	sub    $0x8,%esp
80100a9c:	68 e0 d5 10 80       	push   $0x8010d5e0
80100aa1:	68 20 28 11 80       	push   $0x80112820
80100aa6:	e8 21 49 00 00       	call   801053cc <sleep>
80100aab:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100aae:	8b 15 20 28 11 80    	mov    0x80112820,%edx
80100ab4:	a1 24 28 11 80       	mov    0x80112824,%eax
80100ab9:	39 c2                	cmp    %eax,%edx
80100abb:	74 a7                	je     80100a64 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100abd:	a1 20 28 11 80       	mov    0x80112820,%eax
80100ac2:	8d 50 01             	lea    0x1(%eax),%edx
80100ac5:	89 15 20 28 11 80    	mov    %edx,0x80112820
80100acb:	83 e0 7f             	and    $0x7f,%eax
80100ace:	0f b6 80 a0 27 11 80 	movzbl -0x7feed860(%eax),%eax
80100ad5:	0f be c0             	movsbl %al,%eax
80100ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100adb:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100adf:	75 17                	jne    80100af8 <consoleread+0xc3>
      if(n < target){
80100ae1:	8b 45 10             	mov    0x10(%ebp),%eax
80100ae4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100ae7:	73 2f                	jae    80100b18 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100ae9:	a1 20 28 11 80       	mov    0x80112820,%eax
80100aee:	83 e8 01             	sub    $0x1,%eax
80100af1:	a3 20 28 11 80       	mov    %eax,0x80112820
      }
      break;
80100af6:	eb 20                	jmp    80100b18 <consoleread+0xe3>
    }
    *dst++ = c;
80100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100afb:	8d 50 01             	lea    0x1(%eax),%edx
80100afe:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b01:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b04:	88 10                	mov    %dl,(%eax)
    --n;
80100b06:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b0a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b0e:	74 0b                	je     80100b1b <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b14:	7f 98                	jg     80100aae <consoleread+0x79>
80100b16:	eb 04                	jmp    80100b1c <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100b18:	90                   	nop
80100b19:	eb 01                	jmp    80100b1c <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100b1b:	90                   	nop
  }
  release(&cons.lock);
80100b1c:	83 ec 0c             	sub    $0xc,%esp
80100b1f:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b24:	e8 4d 58 00 00       	call   80106376 <release>
80100b29:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	pushl  0x8(%ebp)
80100b32:	e8 d9 0e 00 00       	call   80101a10 <ilock>
80100b37:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b3a:	8b 45 10             	mov    0x10(%ebp),%eax
80100b3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b40:	29 c2                	sub    %eax,%edx
80100b42:	89 d0                	mov    %edx,%eax
}
80100b44:	c9                   	leave  
80100b45:	c3                   	ret    

80100b46 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b46:	55                   	push   %ebp
80100b47:	89 e5                	mov    %esp,%ebp
80100b49:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b4c:	83 ec 0c             	sub    $0xc,%esp
80100b4f:	ff 75 08             	pushl  0x8(%ebp)
80100b52:	e8 17 10 00 00       	call   80101b6e <iunlock>
80100b57:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b5a:	83 ec 0c             	sub    $0xc,%esp
80100b5d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b62:	e8 a8 57 00 00       	call   8010630f <acquire>
80100b67:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b71:	eb 21                	jmp    80100b94 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b79:	01 d0                	add    %edx,%eax
80100b7b:	0f b6 00             	movzbl (%eax),%eax
80100b7e:	0f be c0             	movsbl %al,%eax
80100b81:	0f b6 c0             	movzbl %al,%eax
80100b84:	83 ec 0c             	sub    $0xc,%esp
80100b87:	50                   	push   %eax
80100b88:	e8 05 fc ff ff       	call   80100792 <consputc>
80100b8d:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b90:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b97:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b9a:	7c d7                	jl     80100b73 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b9c:	83 ec 0c             	sub    $0xc,%esp
80100b9f:	68 e0 d5 10 80       	push   $0x8010d5e0
80100ba4:	e8 cd 57 00 00       	call   80106376 <release>
80100ba9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bac:	83 ec 0c             	sub    $0xc,%esp
80100baf:	ff 75 08             	pushl  0x8(%ebp)
80100bb2:	e8 59 0e 00 00       	call   80101a10 <ilock>
80100bb7:	83 c4 10             	add    $0x10,%esp

  return n;
80100bba:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bbd:	c9                   	leave  
80100bbe:	c3                   	ret    

80100bbf <consoleinit>:

void
consoleinit(void)
{
80100bbf:	55                   	push   %ebp
80100bc0:	89 e5                	mov    %esp,%ebp
80100bc2:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100bc5:	83 ec 08             	sub    $0x8,%esp
80100bc8:	68 52 9a 10 80       	push   $0x80109a52
80100bcd:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bd2:	e8 16 57 00 00       	call   801062ed <initlock>
80100bd7:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bda:	c7 05 ec 31 11 80 46 	movl   $0x80100b46,0x801131ec
80100be1:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be4:	c7 05 e8 31 11 80 35 	movl   $0x80100a35,0x801131e8
80100beb:	0a 10 80 
  cons.locking = 1;
80100bee:	c7 05 14 d6 10 80 01 	movl   $0x1,0x8010d614
80100bf5:	00 00 00 

  picenable(IRQ_KBD);
80100bf8:	83 ec 0c             	sub    $0xc,%esp
80100bfb:	6a 01                	push   $0x1
80100bfd:	e8 cf 33 00 00       	call   80103fd1 <picenable>
80100c02:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c05:	83 ec 08             	sub    $0x8,%esp
80100c08:	6a 00                	push   $0x0
80100c0a:	6a 01                	push   $0x1
80100c0c:	e8 6f 1f 00 00       	call   80102b80 <ioapicenable>
80100c11:	83 c4 10             	add    $0x10,%esp
}
80100c14:	90                   	nop
80100c15:	c9                   	leave  
80100c16:	c3                   	ret    

80100c17 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c17:	55                   	push   %ebp
80100c18:	89 e5                	mov    %esp,%ebp
80100c1a:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100c20:	e8 ce 29 00 00       	call   801035f3 <begin_op>
  if((ip = namei(path)) == 0){
80100c25:	83 ec 0c             	sub    $0xc,%esp
80100c28:	ff 75 08             	pushl  0x8(%ebp)
80100c2b:	e8 9e 19 00 00       	call   801025ce <namei>
80100c30:	83 c4 10             	add    $0x10,%esp
80100c33:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c36:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c3a:	75 0f                	jne    80100c4b <exec+0x34>
    end_op();
80100c3c:	e8 3e 2a 00 00       	call   8010367f <end_op>
    return -1;
80100c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c46:	e9 ce 03 00 00       	jmp    80101019 <exec+0x402>
  }
  ilock(ip);
80100c4b:	83 ec 0c             	sub    $0xc,%esp
80100c4e:	ff 75 d8             	pushl  -0x28(%ebp)
80100c51:	e8 ba 0d 00 00       	call   80101a10 <ilock>
80100c56:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c59:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c60:	6a 34                	push   $0x34
80100c62:	6a 00                	push   $0x0
80100c64:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100c6a:	50                   	push   %eax
80100c6b:	ff 75 d8             	pushl  -0x28(%ebp)
80100c6e:	e8 0b 13 00 00       	call   80101f7e <readi>
80100c73:	83 c4 10             	add    $0x10,%esp
80100c76:	83 f8 33             	cmp    $0x33,%eax
80100c79:	0f 86 49 03 00 00    	jbe    80100fc8 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c7f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c85:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c8a:	0f 85 3b 03 00 00    	jne    80100fcb <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c90:	e8 3c 85 00 00       	call   801091d1 <setupkvm>
80100c95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c98:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c9c:	0f 84 2c 03 00 00    	je     80100fce <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100ca2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ca9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100cb0:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100cb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cb9:	e9 ab 00 00 00       	jmp    80100d69 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cc1:	6a 20                	push   $0x20
80100cc3:	50                   	push   %eax
80100cc4:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100cca:	50                   	push   %eax
80100ccb:	ff 75 d8             	pushl  -0x28(%ebp)
80100cce:	e8 ab 12 00 00       	call   80101f7e <readi>
80100cd3:	83 c4 10             	add    $0x10,%esp
80100cd6:	83 f8 20             	cmp    $0x20,%eax
80100cd9:	0f 85 f2 02 00 00    	jne    80100fd1 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100cdf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ce5:	83 f8 01             	cmp    $0x1,%eax
80100ce8:	75 71                	jne    80100d5b <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100cea:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100cf0:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cf6:	39 c2                	cmp    %eax,%edx
80100cf8:	0f 82 d6 02 00 00    	jb     80100fd4 <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cfe:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100d04:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100d0a:	01 d0                	add    %edx,%eax
80100d0c:	83 ec 04             	sub    $0x4,%esp
80100d0f:	50                   	push   %eax
80100d10:	ff 75 e0             	pushl  -0x20(%ebp)
80100d13:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d16:	e8 5d 88 00 00       	call   80109578 <allocuvm>
80100d1b:	83 c4 10             	add    $0x10,%esp
80100d1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d25:	0f 84 ac 02 00 00    	je     80100fd7 <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d2b:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d31:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d37:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d3d:	83 ec 0c             	sub    $0xc,%esp
80100d40:	52                   	push   %edx
80100d41:	50                   	push   %eax
80100d42:	ff 75 d8             	pushl  -0x28(%ebp)
80100d45:	51                   	push   %ecx
80100d46:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d49:	e8 53 87 00 00       	call   801094a1 <loaduvm>
80100d4e:	83 c4 20             	add    $0x20,%esp
80100d51:	85 c0                	test   %eax,%eax
80100d53:	0f 88 81 02 00 00    	js     80100fda <exec+0x3c3>
80100d59:	eb 01                	jmp    80100d5c <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d5b:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d5c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d60:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d63:	83 c0 20             	add    $0x20,%eax
80100d66:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d69:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d70:	0f b7 c0             	movzwl %ax,%eax
80100d73:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d76:	0f 8f 42 ff ff ff    	jg     80100cbe <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d7c:	83 ec 0c             	sub    $0xc,%esp
80100d7f:	ff 75 d8             	pushl  -0x28(%ebp)
80100d82:	e8 49 0f 00 00       	call   80101cd0 <iunlockput>
80100d87:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d8a:	e8 f0 28 00 00       	call   8010367f <end_op>
  ip = 0;
80100d8f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d96:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d99:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100da3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100da6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da9:	05 00 20 00 00       	add    $0x2000,%eax
80100dae:	83 ec 04             	sub    $0x4,%esp
80100db1:	50                   	push   %eax
80100db2:	ff 75 e0             	pushl  -0x20(%ebp)
80100db5:	ff 75 d4             	pushl  -0x2c(%ebp)
80100db8:	e8 bb 87 00 00       	call   80109578 <allocuvm>
80100dbd:	83 c4 10             	add    $0x10,%esp
80100dc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dc7:	0f 84 10 02 00 00    	je     80100fdd <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dd0:	2d 00 20 00 00       	sub    $0x2000,%eax
80100dd5:	83 ec 08             	sub    $0x8,%esp
80100dd8:	50                   	push   %eax
80100dd9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ddc:	e8 bd 89 00 00       	call   8010979e <clearpteu>
80100de1:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100de4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100de7:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100df1:	e9 96 00 00 00       	jmp    80100e8c <exec+0x275>
    if(argc >= MAXARG)
80100df6:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dfa:	0f 87 e0 01 00 00    	ja     80100fe0 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e03:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e0d:	01 d0                	add    %edx,%eax
80100e0f:	8b 00                	mov    (%eax),%eax
80100e11:	83 ec 0c             	sub    $0xc,%esp
80100e14:	50                   	push   %eax
80100e15:	e8 a5 59 00 00       	call   801067bf <strlen>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	89 c2                	mov    %eax,%edx
80100e1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e22:	29 d0                	sub    %edx,%eax
80100e24:	83 e8 01             	sub    $0x1,%eax
80100e27:	83 e0 fc             	and    $0xfffffffc,%eax
80100e2a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e37:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e3a:	01 d0                	add    %edx,%eax
80100e3c:	8b 00                	mov    (%eax),%eax
80100e3e:	83 ec 0c             	sub    $0xc,%esp
80100e41:	50                   	push   %eax
80100e42:	e8 78 59 00 00       	call   801067bf <strlen>
80100e47:	83 c4 10             	add    $0x10,%esp
80100e4a:	83 c0 01             	add    $0x1,%eax
80100e4d:	89 c1                	mov    %eax,%ecx
80100e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e59:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e5c:	01 d0                	add    %edx,%eax
80100e5e:	8b 00                	mov    (%eax),%eax
80100e60:	51                   	push   %ecx
80100e61:	50                   	push   %eax
80100e62:	ff 75 dc             	pushl  -0x24(%ebp)
80100e65:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e68:	e8 e8 8a 00 00       	call   80109955 <copyout>
80100e6d:	83 c4 10             	add    $0x10,%esp
80100e70:	85 c0                	test   %eax,%eax
80100e72:	0f 88 6b 01 00 00    	js     80100fe3 <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e7b:	8d 50 03             	lea    0x3(%eax),%edx
80100e7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e81:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e88:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e96:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e99:	01 d0                	add    %edx,%eax
80100e9b:	8b 00                	mov    (%eax),%eax
80100e9d:	85 c0                	test   %eax,%eax
80100e9f:	0f 85 51 ff ff ff    	jne    80100df6 <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100ea5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea8:	83 c0 03             	add    $0x3,%eax
80100eab:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100eb2:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100eb6:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100ebd:	ff ff ff 
  ustack[1] = argc;
80100ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec3:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ecc:	83 c0 01             	add    $0x1,%eax
80100ecf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ed6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ed9:	29 d0                	sub    %edx,%eax
80100edb:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee4:	83 c0 04             	add    $0x4,%eax
80100ee7:	c1 e0 02             	shl    $0x2,%eax
80100eea:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef0:	83 c0 04             	add    $0x4,%eax
80100ef3:	c1 e0 02             	shl    $0x2,%eax
80100ef6:	50                   	push   %eax
80100ef7:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100efd:	50                   	push   %eax
80100efe:	ff 75 dc             	pushl  -0x24(%ebp)
80100f01:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f04:	e8 4c 8a 00 00       	call   80109955 <copyout>
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 c0                	test   %eax,%eax
80100f0e:	0f 88 d2 00 00 00    	js     80100fe6 <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f14:	8b 45 08             	mov    0x8(%ebp),%eax
80100f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f20:	eb 17                	jmp    80100f39 <exec+0x322>
    if(*s == '/')
80100f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f25:	0f b6 00             	movzbl (%eax),%eax
80100f28:	3c 2f                	cmp    $0x2f,%al
80100f2a:	75 09                	jne    80100f35 <exec+0x31e>
      last = s+1;
80100f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f2f:	83 c0 01             	add    $0x1,%eax
80100f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f3c:	0f b6 00             	movzbl (%eax),%eax
80100f3f:	84 c0                	test   %al,%al
80100f41:	75 df                	jne    80100f22 <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f49:	83 c0 6c             	add    $0x6c,%eax
80100f4c:	83 ec 04             	sub    $0x4,%esp
80100f4f:	6a 10                	push   $0x10
80100f51:	ff 75 f0             	pushl  -0x10(%ebp)
80100f54:	50                   	push   %eax
80100f55:	e8 1b 58 00 00       	call   80106775 <safestrcpy>
80100f5a:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f63:	8b 40 04             	mov    0x4(%eax),%eax
80100f66:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f72:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f7e:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f86:	8b 40 18             	mov    0x18(%eax),%eax
80100f89:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f8f:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f98:	8b 40 18             	mov    0x18(%eax),%eax
80100f9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f9e:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100fa1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fa7:	83 ec 0c             	sub    $0xc,%esp
80100faa:	50                   	push   %eax
80100fab:	e8 08 83 00 00       	call   801092b8 <switchuvm>
80100fb0:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 75 d0             	pushl  -0x30(%ebp)
80100fb9:	e8 40 87 00 00       	call   801096fe <freevm>
80100fbe:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fc1:	b8 00 00 00 00       	mov    $0x0,%eax
80100fc6:	eb 51                	jmp    80101019 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100fc8:	90                   	nop
80100fc9:	eb 1c                	jmp    80100fe7 <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100fcb:	90                   	nop
80100fcc:	eb 19                	jmp    80100fe7 <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100fce:	90                   	nop
80100fcf:	eb 16                	jmp    80100fe7 <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100fd1:	90                   	nop
80100fd2:	eb 13                	jmp    80100fe7 <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100fd4:	90                   	nop
80100fd5:	eb 10                	jmp    80100fe7 <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100fd7:	90                   	nop
80100fd8:	eb 0d                	jmp    80100fe7 <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100fda:	90                   	nop
80100fdb:	eb 0a                	jmp    80100fe7 <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100fdd:	90                   	nop
80100fde:	eb 07                	jmp    80100fe7 <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100fe0:	90                   	nop
80100fe1:	eb 04                	jmp    80100fe7 <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100fe3:	90                   	nop
80100fe4:	eb 01                	jmp    80100fe7 <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100fe6:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100fe7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100feb:	74 0e                	je     80100ffb <exec+0x3e4>
    freevm(pgdir);
80100fed:	83 ec 0c             	sub    $0xc,%esp
80100ff0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ff3:	e8 06 87 00 00       	call   801096fe <freevm>
80100ff8:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100ffb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fff:	74 13                	je     80101014 <exec+0x3fd>
    iunlockput(ip);
80101001:	83 ec 0c             	sub    $0xc,%esp
80101004:	ff 75 d8             	pushl  -0x28(%ebp)
80101007:	e8 c4 0c 00 00       	call   80101cd0 <iunlockput>
8010100c:	83 c4 10             	add    $0x10,%esp
    end_op();
8010100f:	e8 6b 26 00 00       	call   8010367f <end_op>
  }
  return -1;
80101014:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101019:	c9                   	leave  
8010101a:	c3                   	ret    

8010101b <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
8010101b:	55                   	push   %ebp
8010101c:	89 e5                	mov    %esp,%ebp
8010101e:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80101021:	83 ec 08             	sub    $0x8,%esp
80101024:	68 5a 9a 10 80       	push   $0x80109a5a
80101029:	68 40 28 11 80       	push   $0x80112840
8010102e:	e8 ba 52 00 00       	call   801062ed <initlock>
80101033:	83 c4 10             	add    $0x10,%esp
}
80101036:	90                   	nop
80101037:	c9                   	leave  
80101038:	c3                   	ret    

80101039 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101039:	55                   	push   %ebp
8010103a:	89 e5                	mov    %esp,%ebp
8010103c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
8010103f:	83 ec 0c             	sub    $0xc,%esp
80101042:	68 40 28 11 80       	push   $0x80112840
80101047:	e8 c3 52 00 00       	call   8010630f <acquire>
8010104c:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010104f:	c7 45 f4 74 28 11 80 	movl   $0x80112874,-0xc(%ebp)
80101056:	eb 2d                	jmp    80101085 <filealloc+0x4c>
    if(f->ref == 0){
80101058:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010105b:	8b 40 04             	mov    0x4(%eax),%eax
8010105e:	85 c0                	test   %eax,%eax
80101060:	75 1f                	jne    80101081 <filealloc+0x48>
      f->ref = 1;
80101062:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101065:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010106c:	83 ec 0c             	sub    $0xc,%esp
8010106f:	68 40 28 11 80       	push   $0x80112840
80101074:	e8 fd 52 00 00       	call   80106376 <release>
80101079:	83 c4 10             	add    $0x10,%esp
      return f;
8010107c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010107f:	eb 23                	jmp    801010a4 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101081:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101085:	b8 d4 31 11 80       	mov    $0x801131d4,%eax
8010108a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010108d:	72 c9                	jb     80101058 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	68 40 28 11 80       	push   $0x80112840
80101097:	e8 da 52 00 00       	call   80106376 <release>
8010109c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010109f:	b8 00 00 00 00       	mov    $0x0,%eax
}
801010a4:	c9                   	leave  
801010a5:	c3                   	ret    

801010a6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010a6:	55                   	push   %ebp
801010a7:	89 e5                	mov    %esp,%ebp
801010a9:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801010ac:	83 ec 0c             	sub    $0xc,%esp
801010af:	68 40 28 11 80       	push   $0x80112840
801010b4:	e8 56 52 00 00       	call   8010630f <acquire>
801010b9:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010bc:	8b 45 08             	mov    0x8(%ebp),%eax
801010bf:	8b 40 04             	mov    0x4(%eax),%eax
801010c2:	85 c0                	test   %eax,%eax
801010c4:	7f 0d                	jg     801010d3 <filedup+0x2d>
    panic("filedup");
801010c6:	83 ec 0c             	sub    $0xc,%esp
801010c9:	68 61 9a 10 80       	push   $0x80109a61
801010ce:	e8 93 f4 ff ff       	call   80100566 <panic>
  f->ref++;
801010d3:	8b 45 08             	mov    0x8(%ebp),%eax
801010d6:	8b 40 04             	mov    0x4(%eax),%eax
801010d9:	8d 50 01             	lea    0x1(%eax),%edx
801010dc:	8b 45 08             	mov    0x8(%ebp),%eax
801010df:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010e2:	83 ec 0c             	sub    $0xc,%esp
801010e5:	68 40 28 11 80       	push   $0x80112840
801010ea:	e8 87 52 00 00       	call   80106376 <release>
801010ef:	83 c4 10             	add    $0x10,%esp
  return f;
801010f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010f5:	c9                   	leave  
801010f6:	c3                   	ret    

801010f7 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010f7:	55                   	push   %ebp
801010f8:	89 e5                	mov    %esp,%ebp
801010fa:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010fd:	83 ec 0c             	sub    $0xc,%esp
80101100:	68 40 28 11 80       	push   $0x80112840
80101105:	e8 05 52 00 00       	call   8010630f <acquire>
8010110a:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010110d:	8b 45 08             	mov    0x8(%ebp),%eax
80101110:	8b 40 04             	mov    0x4(%eax),%eax
80101113:	85 c0                	test   %eax,%eax
80101115:	7f 0d                	jg     80101124 <fileclose+0x2d>
    panic("fileclose");
80101117:	83 ec 0c             	sub    $0xc,%esp
8010111a:	68 69 9a 10 80       	push   $0x80109a69
8010111f:	e8 42 f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
80101124:	8b 45 08             	mov    0x8(%ebp),%eax
80101127:	8b 40 04             	mov    0x4(%eax),%eax
8010112a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010112d:	8b 45 08             	mov    0x8(%ebp),%eax
80101130:	89 50 04             	mov    %edx,0x4(%eax)
80101133:	8b 45 08             	mov    0x8(%ebp),%eax
80101136:	8b 40 04             	mov    0x4(%eax),%eax
80101139:	85 c0                	test   %eax,%eax
8010113b:	7e 15                	jle    80101152 <fileclose+0x5b>
    release(&ftable.lock);
8010113d:	83 ec 0c             	sub    $0xc,%esp
80101140:	68 40 28 11 80       	push   $0x80112840
80101145:	e8 2c 52 00 00       	call   80106376 <release>
8010114a:	83 c4 10             	add    $0x10,%esp
8010114d:	e9 8b 00 00 00       	jmp    801011dd <fileclose+0xe6>
    return;
  }
  ff = *f;
80101152:	8b 45 08             	mov    0x8(%ebp),%eax
80101155:	8b 10                	mov    (%eax),%edx
80101157:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010115a:	8b 50 04             	mov    0x4(%eax),%edx
8010115d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101160:	8b 50 08             	mov    0x8(%eax),%edx
80101163:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101166:	8b 50 0c             	mov    0xc(%eax),%edx
80101169:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010116c:	8b 50 10             	mov    0x10(%eax),%edx
8010116f:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101172:	8b 40 14             	mov    0x14(%eax),%eax
80101175:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101178:	8b 45 08             	mov    0x8(%ebp),%eax
8010117b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101182:	8b 45 08             	mov    0x8(%ebp),%eax
80101185:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010118b:	83 ec 0c             	sub    $0xc,%esp
8010118e:	68 40 28 11 80       	push   $0x80112840
80101193:	e8 de 51 00 00       	call   80106376 <release>
80101198:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
8010119b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010119e:	83 f8 01             	cmp    $0x1,%eax
801011a1:	75 19                	jne    801011bc <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801011a3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801011a7:	0f be d0             	movsbl %al,%edx
801011aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011ad:	83 ec 08             	sub    $0x8,%esp
801011b0:	52                   	push   %edx
801011b1:	50                   	push   %eax
801011b2:	e8 83 30 00 00       	call   8010423a <pipeclose>
801011b7:	83 c4 10             	add    $0x10,%esp
801011ba:	eb 21                	jmp    801011dd <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801011bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bf:	83 f8 02             	cmp    $0x2,%eax
801011c2:	75 19                	jne    801011dd <fileclose+0xe6>
    begin_op();
801011c4:	e8 2a 24 00 00       	call   801035f3 <begin_op>
    iput(ff.ip);
801011c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011cc:	83 ec 0c             	sub    $0xc,%esp
801011cf:	50                   	push   %eax
801011d0:	e8 0b 0a 00 00       	call   80101be0 <iput>
801011d5:	83 c4 10             	add    $0x10,%esp
    end_op();
801011d8:	e8 a2 24 00 00       	call   8010367f <end_op>
  }
}
801011dd:	c9                   	leave  
801011de:	c3                   	ret    

801011df <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011df:	55                   	push   %ebp
801011e0:	89 e5                	mov    %esp,%ebp
801011e2:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011e5:	8b 45 08             	mov    0x8(%ebp),%eax
801011e8:	8b 00                	mov    (%eax),%eax
801011ea:	83 f8 02             	cmp    $0x2,%eax
801011ed:	75 40                	jne    8010122f <filestat+0x50>
    ilock(f->ip);
801011ef:	8b 45 08             	mov    0x8(%ebp),%eax
801011f2:	8b 40 10             	mov    0x10(%eax),%eax
801011f5:	83 ec 0c             	sub    $0xc,%esp
801011f8:	50                   	push   %eax
801011f9:	e8 12 08 00 00       	call   80101a10 <ilock>
801011fe:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101201:	8b 45 08             	mov    0x8(%ebp),%eax
80101204:	8b 40 10             	mov    0x10(%eax),%eax
80101207:	83 ec 08             	sub    $0x8,%esp
8010120a:	ff 75 0c             	pushl  0xc(%ebp)
8010120d:	50                   	push   %eax
8010120e:	e8 25 0d 00 00       	call   80101f38 <stati>
80101213:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101216:	8b 45 08             	mov    0x8(%ebp),%eax
80101219:	8b 40 10             	mov    0x10(%eax),%eax
8010121c:	83 ec 0c             	sub    $0xc,%esp
8010121f:	50                   	push   %eax
80101220:	e8 49 09 00 00       	call   80101b6e <iunlock>
80101225:	83 c4 10             	add    $0x10,%esp
    return 0;
80101228:	b8 00 00 00 00       	mov    $0x0,%eax
8010122d:	eb 05                	jmp    80101234 <filestat+0x55>
  }
  return -1;
8010122f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101234:	c9                   	leave  
80101235:	c3                   	ret    

80101236 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101236:	55                   	push   %ebp
80101237:	89 e5                	mov    %esp,%ebp
80101239:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010123c:	8b 45 08             	mov    0x8(%ebp),%eax
8010123f:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101243:	84 c0                	test   %al,%al
80101245:	75 0a                	jne    80101251 <fileread+0x1b>
    return -1;
80101247:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010124c:	e9 9b 00 00 00       	jmp    801012ec <fileread+0xb6>
  if(f->type == FD_PIPE)
80101251:	8b 45 08             	mov    0x8(%ebp),%eax
80101254:	8b 00                	mov    (%eax),%eax
80101256:	83 f8 01             	cmp    $0x1,%eax
80101259:	75 1a                	jne    80101275 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010125b:	8b 45 08             	mov    0x8(%ebp),%eax
8010125e:	8b 40 0c             	mov    0xc(%eax),%eax
80101261:	83 ec 04             	sub    $0x4,%esp
80101264:	ff 75 10             	pushl  0x10(%ebp)
80101267:	ff 75 0c             	pushl  0xc(%ebp)
8010126a:	50                   	push   %eax
8010126b:	e8 72 31 00 00       	call   801043e2 <piperead>
80101270:	83 c4 10             	add    $0x10,%esp
80101273:	eb 77                	jmp    801012ec <fileread+0xb6>
  if(f->type == FD_INODE){
80101275:	8b 45 08             	mov    0x8(%ebp),%eax
80101278:	8b 00                	mov    (%eax),%eax
8010127a:	83 f8 02             	cmp    $0x2,%eax
8010127d:	75 60                	jne    801012df <fileread+0xa9>
    ilock(f->ip);
8010127f:	8b 45 08             	mov    0x8(%ebp),%eax
80101282:	8b 40 10             	mov    0x10(%eax),%eax
80101285:	83 ec 0c             	sub    $0xc,%esp
80101288:	50                   	push   %eax
80101289:	e8 82 07 00 00       	call   80101a10 <ilock>
8010128e:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101291:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101294:	8b 45 08             	mov    0x8(%ebp),%eax
80101297:	8b 50 14             	mov    0x14(%eax),%edx
8010129a:	8b 45 08             	mov    0x8(%ebp),%eax
8010129d:	8b 40 10             	mov    0x10(%eax),%eax
801012a0:	51                   	push   %ecx
801012a1:	52                   	push   %edx
801012a2:	ff 75 0c             	pushl  0xc(%ebp)
801012a5:	50                   	push   %eax
801012a6:	e8 d3 0c 00 00       	call   80101f7e <readi>
801012ab:	83 c4 10             	add    $0x10,%esp
801012ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012b5:	7e 11                	jle    801012c8 <fileread+0x92>
      f->off += r;
801012b7:	8b 45 08             	mov    0x8(%ebp),%eax
801012ba:	8b 50 14             	mov    0x14(%eax),%edx
801012bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c0:	01 c2                	add    %eax,%edx
801012c2:	8b 45 08             	mov    0x8(%ebp),%eax
801012c5:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	8b 40 10             	mov    0x10(%eax),%eax
801012ce:	83 ec 0c             	sub    $0xc,%esp
801012d1:	50                   	push   %eax
801012d2:	e8 97 08 00 00       	call   80101b6e <iunlock>
801012d7:	83 c4 10             	add    $0x10,%esp
    return r;
801012da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012dd:	eb 0d                	jmp    801012ec <fileread+0xb6>
  }
  panic("fileread");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 73 9a 10 80       	push   $0x80109a73
801012e7:	e8 7a f2 ff ff       	call   80100566 <panic>
}
801012ec:	c9                   	leave  
801012ed:	c3                   	ret    

801012ee <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012ee:	55                   	push   %ebp
801012ef:	89 e5                	mov    %esp,%ebp
801012f1:	53                   	push   %ebx
801012f2:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012f5:	8b 45 08             	mov    0x8(%ebp),%eax
801012f8:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012fc:	84 c0                	test   %al,%al
801012fe:	75 0a                	jne    8010130a <filewrite+0x1c>
    return -1;
80101300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101305:	e9 1b 01 00 00       	jmp    80101425 <filewrite+0x137>
  if(f->type == FD_PIPE)
8010130a:	8b 45 08             	mov    0x8(%ebp),%eax
8010130d:	8b 00                	mov    (%eax),%eax
8010130f:	83 f8 01             	cmp    $0x1,%eax
80101312:	75 1d                	jne    80101331 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101314:	8b 45 08             	mov    0x8(%ebp),%eax
80101317:	8b 40 0c             	mov    0xc(%eax),%eax
8010131a:	83 ec 04             	sub    $0x4,%esp
8010131d:	ff 75 10             	pushl  0x10(%ebp)
80101320:	ff 75 0c             	pushl  0xc(%ebp)
80101323:	50                   	push   %eax
80101324:	e8 bb 2f 00 00       	call   801042e4 <pipewrite>
80101329:	83 c4 10             	add    $0x10,%esp
8010132c:	e9 f4 00 00 00       	jmp    80101425 <filewrite+0x137>
  if(f->type == FD_INODE){
80101331:	8b 45 08             	mov    0x8(%ebp),%eax
80101334:	8b 00                	mov    (%eax),%eax
80101336:	83 f8 02             	cmp    $0x2,%eax
80101339:	0f 85 d9 00 00 00    	jne    80101418 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010133f:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010134d:	e9 a3 00 00 00       	jmp    801013f5 <filewrite+0x107>
      int n1 = n - i;
80101352:	8b 45 10             	mov    0x10(%ebp),%eax
80101355:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101358:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010135b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010135e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101361:	7e 06                	jle    80101369 <filewrite+0x7b>
        n1 = max;
80101363:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101366:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101369:	e8 85 22 00 00       	call   801035f3 <begin_op>
      ilock(f->ip);
8010136e:	8b 45 08             	mov    0x8(%ebp),%eax
80101371:	8b 40 10             	mov    0x10(%eax),%eax
80101374:	83 ec 0c             	sub    $0xc,%esp
80101377:	50                   	push   %eax
80101378:	e8 93 06 00 00       	call   80101a10 <ilock>
8010137d:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101380:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101383:	8b 45 08             	mov    0x8(%ebp),%eax
80101386:	8b 50 14             	mov    0x14(%eax),%edx
80101389:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010138c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010138f:	01 c3                	add    %eax,%ebx
80101391:	8b 45 08             	mov    0x8(%ebp),%eax
80101394:	8b 40 10             	mov    0x10(%eax),%eax
80101397:	51                   	push   %ecx
80101398:	52                   	push   %edx
80101399:	53                   	push   %ebx
8010139a:	50                   	push   %eax
8010139b:	e8 35 0d 00 00       	call   801020d5 <writei>
801013a0:	83 c4 10             	add    $0x10,%esp
801013a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
801013a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013aa:	7e 11                	jle    801013bd <filewrite+0xcf>
        f->off += r;
801013ac:	8b 45 08             	mov    0x8(%ebp),%eax
801013af:	8b 50 14             	mov    0x14(%eax),%edx
801013b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013b5:	01 c2                	add    %eax,%edx
801013b7:	8b 45 08             	mov    0x8(%ebp),%eax
801013ba:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013bd:	8b 45 08             	mov    0x8(%ebp),%eax
801013c0:	8b 40 10             	mov    0x10(%eax),%eax
801013c3:	83 ec 0c             	sub    $0xc,%esp
801013c6:	50                   	push   %eax
801013c7:	e8 a2 07 00 00       	call   80101b6e <iunlock>
801013cc:	83 c4 10             	add    $0x10,%esp
      end_op();
801013cf:	e8 ab 22 00 00       	call   8010367f <end_op>

      if(r < 0)
801013d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013d8:	78 29                	js     80101403 <filewrite+0x115>
        break;
      if(r != n1)
801013da:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013e0:	74 0d                	je     801013ef <filewrite+0x101>
        panic("short filewrite");
801013e2:	83 ec 0c             	sub    $0xc,%esp
801013e5:	68 7c 9a 10 80       	push   $0x80109a7c
801013ea:	e8 77 f1 ff ff       	call   80100566 <panic>
      i += r;
801013ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013f2:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f8:	3b 45 10             	cmp    0x10(%ebp),%eax
801013fb:	0f 8c 51 ff ff ff    	jl     80101352 <filewrite+0x64>
80101401:	eb 01                	jmp    80101404 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
80101403:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101407:	3b 45 10             	cmp    0x10(%ebp),%eax
8010140a:	75 05                	jne    80101411 <filewrite+0x123>
8010140c:	8b 45 10             	mov    0x10(%ebp),%eax
8010140f:	eb 14                	jmp    80101425 <filewrite+0x137>
80101411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101416:	eb 0d                	jmp    80101425 <filewrite+0x137>
  }
  panic("filewrite");
80101418:	83 ec 0c             	sub    $0xc,%esp
8010141b:	68 8c 9a 10 80       	push   $0x80109a8c
80101420:	e8 41 f1 ff ff       	call   80100566 <panic>
}
80101425:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101428:	c9                   	leave  
80101429:	c3                   	ret    

8010142a <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010142a:	55                   	push   %ebp
8010142b:	89 e5                	mov    %esp,%ebp
8010142d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101430:	8b 45 08             	mov    0x8(%ebp),%eax
80101433:	83 ec 08             	sub    $0x8,%esp
80101436:	6a 01                	push   $0x1
80101438:	50                   	push   %eax
80101439:	e8 78 ed ff ff       	call   801001b6 <bread>
8010143e:	83 c4 10             	add    $0x10,%esp
80101441:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101447:	83 c0 18             	add    $0x18,%eax
8010144a:	83 ec 04             	sub    $0x4,%esp
8010144d:	6a 1c                	push   $0x1c
8010144f:	50                   	push   %eax
80101450:	ff 75 0c             	pushl  0xc(%ebp)
80101453:	e8 d9 51 00 00       	call   80106631 <memmove>
80101458:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010145b:	83 ec 0c             	sub    $0xc,%esp
8010145e:	ff 75 f4             	pushl  -0xc(%ebp)
80101461:	e8 c8 ed ff ff       	call   8010022e <brelse>
80101466:	83 c4 10             	add    $0x10,%esp
}
80101469:	90                   	nop
8010146a:	c9                   	leave  
8010146b:	c3                   	ret    

8010146c <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010146c:	55                   	push   %ebp
8010146d:	89 e5                	mov    %esp,%ebp
8010146f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101472:	8b 55 0c             	mov    0xc(%ebp),%edx
80101475:	8b 45 08             	mov    0x8(%ebp),%eax
80101478:	83 ec 08             	sub    $0x8,%esp
8010147b:	52                   	push   %edx
8010147c:	50                   	push   %eax
8010147d:	e8 34 ed ff ff       	call   801001b6 <bread>
80101482:	83 c4 10             	add    $0x10,%esp
80101485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101488:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010148b:	83 c0 18             	add    $0x18,%eax
8010148e:	83 ec 04             	sub    $0x4,%esp
80101491:	68 00 02 00 00       	push   $0x200
80101496:	6a 00                	push   $0x0
80101498:	50                   	push   %eax
80101499:	e8 d4 50 00 00       	call   80106572 <memset>
8010149e:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801014a1:	83 ec 0c             	sub    $0xc,%esp
801014a4:	ff 75 f4             	pushl  -0xc(%ebp)
801014a7:	e8 7f 23 00 00       	call   8010382b <log_write>
801014ac:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	ff 75 f4             	pushl  -0xc(%ebp)
801014b5:	e8 74 ed ff ff       	call   8010022e <brelse>
801014ba:	83 c4 10             	add    $0x10,%esp
}
801014bd:	90                   	nop
801014be:	c9                   	leave  
801014bf:	c3                   	ret    

801014c0 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014d4:	e9 13 01 00 00       	jmp    801015ec <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801014d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014dc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014e2:	85 c0                	test   %eax,%eax
801014e4:	0f 48 c2             	cmovs  %edx,%eax
801014e7:	c1 f8 0c             	sar    $0xc,%eax
801014ea:	89 c2                	mov    %eax,%edx
801014ec:	a1 58 32 11 80       	mov    0x80113258,%eax
801014f1:	01 d0                	add    %edx,%eax
801014f3:	83 ec 08             	sub    $0x8,%esp
801014f6:	50                   	push   %eax
801014f7:	ff 75 08             	pushl  0x8(%ebp)
801014fa:	e8 b7 ec ff ff       	call   801001b6 <bread>
801014ff:	83 c4 10             	add    $0x10,%esp
80101502:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101505:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010150c:	e9 a6 00 00 00       	jmp    801015b7 <balloc+0xf7>
      m = 1 << (bi % 8);
80101511:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101514:	99                   	cltd   
80101515:	c1 ea 1d             	shr    $0x1d,%edx
80101518:	01 d0                	add    %edx,%eax
8010151a:	83 e0 07             	and    $0x7,%eax
8010151d:	29 d0                	sub    %edx,%eax
8010151f:	ba 01 00 00 00       	mov    $0x1,%edx
80101524:	89 c1                	mov    %eax,%ecx
80101526:	d3 e2                	shl    %cl,%edx
80101528:	89 d0                	mov    %edx,%eax
8010152a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101530:	8d 50 07             	lea    0x7(%eax),%edx
80101533:	85 c0                	test   %eax,%eax
80101535:	0f 48 c2             	cmovs  %edx,%eax
80101538:	c1 f8 03             	sar    $0x3,%eax
8010153b:	89 c2                	mov    %eax,%edx
8010153d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101540:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101545:	0f b6 c0             	movzbl %al,%eax
80101548:	23 45 e8             	and    -0x18(%ebp),%eax
8010154b:	85 c0                	test   %eax,%eax
8010154d:	75 64                	jne    801015b3 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010154f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101552:	8d 50 07             	lea    0x7(%eax),%edx
80101555:	85 c0                	test   %eax,%eax
80101557:	0f 48 c2             	cmovs  %edx,%eax
8010155a:	c1 f8 03             	sar    $0x3,%eax
8010155d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101560:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101565:	89 d1                	mov    %edx,%ecx
80101567:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010156a:	09 ca                	or     %ecx,%edx
8010156c:	89 d1                	mov    %edx,%ecx
8010156e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101571:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101575:	83 ec 0c             	sub    $0xc,%esp
80101578:	ff 75 ec             	pushl  -0x14(%ebp)
8010157b:	e8 ab 22 00 00       	call   8010382b <log_write>
80101580:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101583:	83 ec 0c             	sub    $0xc,%esp
80101586:	ff 75 ec             	pushl  -0x14(%ebp)
80101589:	e8 a0 ec ff ff       	call   8010022e <brelse>
8010158e:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101591:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101594:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101597:	01 c2                	add    %eax,%edx
80101599:	8b 45 08             	mov    0x8(%ebp),%eax
8010159c:	83 ec 08             	sub    $0x8,%esp
8010159f:	52                   	push   %edx
801015a0:	50                   	push   %eax
801015a1:	e8 c6 fe ff ff       	call   8010146c <bzero>
801015a6:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015af:	01 d0                	add    %edx,%eax
801015b1:	eb 57                	jmp    8010160a <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015b3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015b7:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015be:	7f 17                	jg     801015d7 <balloc+0x117>
801015c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c6:	01 d0                	add    %edx,%eax
801015c8:	89 c2                	mov    %eax,%edx
801015ca:	a1 40 32 11 80       	mov    0x80113240,%eax
801015cf:	39 c2                	cmp    %eax,%edx
801015d1:	0f 82 3a ff ff ff    	jb     80101511 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015d7:	83 ec 0c             	sub    $0xc,%esp
801015da:	ff 75 ec             	pushl  -0x14(%ebp)
801015dd:	e8 4c ec ff ff       	call   8010022e <brelse>
801015e2:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015e5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015ec:	8b 15 40 32 11 80    	mov    0x80113240,%edx
801015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f5:	39 c2                	cmp    %eax,%edx
801015f7:	0f 87 dc fe ff ff    	ja     801014d9 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015fd:	83 ec 0c             	sub    $0xc,%esp
80101600:	68 98 9a 10 80       	push   $0x80109a98
80101605:	e8 5c ef ff ff       	call   80100566 <panic>
}
8010160a:	c9                   	leave  
8010160b:	c3                   	ret    

8010160c <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010160c:	55                   	push   %ebp
8010160d:	89 e5                	mov    %esp,%ebp
8010160f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101612:	83 ec 08             	sub    $0x8,%esp
80101615:	68 40 32 11 80       	push   $0x80113240
8010161a:	ff 75 08             	pushl  0x8(%ebp)
8010161d:	e8 08 fe ff ff       	call   8010142a <readsb>
80101622:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101625:	8b 45 0c             	mov    0xc(%ebp),%eax
80101628:	c1 e8 0c             	shr    $0xc,%eax
8010162b:	89 c2                	mov    %eax,%edx
8010162d:	a1 58 32 11 80       	mov    0x80113258,%eax
80101632:	01 c2                	add    %eax,%edx
80101634:	8b 45 08             	mov    0x8(%ebp),%eax
80101637:	83 ec 08             	sub    $0x8,%esp
8010163a:	52                   	push   %edx
8010163b:	50                   	push   %eax
8010163c:	e8 75 eb ff ff       	call   801001b6 <bread>
80101641:	83 c4 10             	add    $0x10,%esp
80101644:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101647:	8b 45 0c             	mov    0xc(%ebp),%eax
8010164a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101652:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101655:	99                   	cltd   
80101656:	c1 ea 1d             	shr    $0x1d,%edx
80101659:	01 d0                	add    %edx,%eax
8010165b:	83 e0 07             	and    $0x7,%eax
8010165e:	29 d0                	sub    %edx,%eax
80101660:	ba 01 00 00 00       	mov    $0x1,%edx
80101665:	89 c1                	mov    %eax,%ecx
80101667:	d3 e2                	shl    %cl,%edx
80101669:	89 d0                	mov    %edx,%eax
8010166b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010166e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101671:	8d 50 07             	lea    0x7(%eax),%edx
80101674:	85 c0                	test   %eax,%eax
80101676:	0f 48 c2             	cmovs  %edx,%eax
80101679:	c1 f8 03             	sar    $0x3,%eax
8010167c:	89 c2                	mov    %eax,%edx
8010167e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101681:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101686:	0f b6 c0             	movzbl %al,%eax
80101689:	23 45 ec             	and    -0x14(%ebp),%eax
8010168c:	85 c0                	test   %eax,%eax
8010168e:	75 0d                	jne    8010169d <bfree+0x91>
    panic("freeing free block");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 ae 9a 10 80       	push   $0x80109aae
80101698:	e8 c9 ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
8010169d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a0:	8d 50 07             	lea    0x7(%eax),%edx
801016a3:	85 c0                	test   %eax,%eax
801016a5:	0f 48 c2             	cmovs  %edx,%eax
801016a8:	c1 f8 03             	sar    $0x3,%eax
801016ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016ae:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801016b3:	89 d1                	mov    %edx,%ecx
801016b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016b8:	f7 d2                	not    %edx
801016ba:	21 ca                	and    %ecx,%edx
801016bc:	89 d1                	mov    %edx,%ecx
801016be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016c1:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801016c5:	83 ec 0c             	sub    $0xc,%esp
801016c8:	ff 75 f4             	pushl  -0xc(%ebp)
801016cb:	e8 5b 21 00 00       	call   8010382b <log_write>
801016d0:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016d3:	83 ec 0c             	sub    $0xc,%esp
801016d6:	ff 75 f4             	pushl  -0xc(%ebp)
801016d9:	e8 50 eb ff ff       	call   8010022e <brelse>
801016de:	83 c4 10             	add    $0x10,%esp
}
801016e1:	90                   	nop
801016e2:	c9                   	leave  
801016e3:	c3                   	ret    

801016e4 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016e4:	55                   	push   %ebp
801016e5:	89 e5                	mov    %esp,%ebp
801016e7:	57                   	push   %edi
801016e8:	56                   	push   %esi
801016e9:	53                   	push   %ebx
801016ea:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801016ed:	83 ec 08             	sub    $0x8,%esp
801016f0:	68 c1 9a 10 80       	push   $0x80109ac1
801016f5:	68 60 32 11 80       	push   $0x80113260
801016fa:	e8 ee 4b 00 00       	call   801062ed <initlock>
801016ff:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101702:	83 ec 08             	sub    $0x8,%esp
80101705:	68 40 32 11 80       	push   $0x80113240
8010170a:	ff 75 08             	pushl  0x8(%ebp)
8010170d:	e8 18 fd ff ff       	call   8010142a <readsb>
80101712:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101715:	a1 58 32 11 80       	mov    0x80113258,%eax
8010171a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010171d:	8b 3d 54 32 11 80    	mov    0x80113254,%edi
80101723:	8b 35 50 32 11 80    	mov    0x80113250,%esi
80101729:	8b 1d 4c 32 11 80    	mov    0x8011324c,%ebx
8010172f:	8b 0d 48 32 11 80    	mov    0x80113248,%ecx
80101735:	8b 15 44 32 11 80    	mov    0x80113244,%edx
8010173b:	a1 40 32 11 80       	mov    0x80113240,%eax
80101740:	ff 75 e4             	pushl  -0x1c(%ebp)
80101743:	57                   	push   %edi
80101744:	56                   	push   %esi
80101745:	53                   	push   %ebx
80101746:	51                   	push   %ecx
80101747:	52                   	push   %edx
80101748:	50                   	push   %eax
80101749:	68 c8 9a 10 80       	push   $0x80109ac8
8010174e:	e8 73 ec ff ff       	call   801003c6 <cprintf>
80101753:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101756:	90                   	nop
80101757:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010175a:	5b                   	pop    %ebx
8010175b:	5e                   	pop    %esi
8010175c:	5f                   	pop    %edi
8010175d:	5d                   	pop    %ebp
8010175e:	c3                   	ret    

8010175f <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010175f:	55                   	push   %ebp
80101760:	89 e5                	mov    %esp,%ebp
80101762:	83 ec 28             	sub    $0x28,%esp
80101765:	8b 45 0c             	mov    0xc(%ebp),%eax
80101768:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010176c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101773:	e9 9e 00 00 00       	jmp    80101816 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177b:	c1 e8 03             	shr    $0x3,%eax
8010177e:	89 c2                	mov    %eax,%edx
80101780:	a1 54 32 11 80       	mov    0x80113254,%eax
80101785:	01 d0                	add    %edx,%eax
80101787:	83 ec 08             	sub    $0x8,%esp
8010178a:	50                   	push   %eax
8010178b:	ff 75 08             	pushl  0x8(%ebp)
8010178e:	e8 23 ea ff ff       	call   801001b6 <bread>
80101793:	83 c4 10             	add    $0x10,%esp
80101796:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101799:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179c:	8d 50 18             	lea    0x18(%eax),%edx
8010179f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a2:	83 e0 07             	and    $0x7,%eax
801017a5:	c1 e0 06             	shl    $0x6,%eax
801017a8:	01 d0                	add    %edx,%eax
801017aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017b0:	0f b7 00             	movzwl (%eax),%eax
801017b3:	66 85 c0             	test   %ax,%ax
801017b6:	75 4c                	jne    80101804 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017b8:	83 ec 04             	sub    $0x4,%esp
801017bb:	6a 40                	push   $0x40
801017bd:	6a 00                	push   $0x0
801017bf:	ff 75 ec             	pushl  -0x14(%ebp)
801017c2:	e8 ab 4d 00 00       	call   80106572 <memset>
801017c7:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017cd:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017d1:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	ff 75 f0             	pushl  -0x10(%ebp)
801017da:	e8 4c 20 00 00       	call   8010382b <log_write>
801017df:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017e2:	83 ec 0c             	sub    $0xc,%esp
801017e5:	ff 75 f0             	pushl  -0x10(%ebp)
801017e8:	e8 41 ea ff ff       	call   8010022e <brelse>
801017ed:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f3:	83 ec 08             	sub    $0x8,%esp
801017f6:	50                   	push   %eax
801017f7:	ff 75 08             	pushl  0x8(%ebp)
801017fa:	e8 f8 00 00 00       	call   801018f7 <iget>
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	eb 30                	jmp    80101834 <ialloc+0xd5>
    }
    brelse(bp);
80101804:	83 ec 0c             	sub    $0xc,%esp
80101807:	ff 75 f0             	pushl  -0x10(%ebp)
8010180a:	e8 1f ea ff ff       	call   8010022e <brelse>
8010180f:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101812:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101816:	8b 15 48 32 11 80    	mov    0x80113248,%edx
8010181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181f:	39 c2                	cmp    %eax,%edx
80101821:	0f 87 51 ff ff ff    	ja     80101778 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 1b 9b 10 80       	push   $0x80109b1b
8010182f:	e8 32 ed ff ff       	call   80100566 <panic>
}
80101834:	c9                   	leave  
80101835:	c3                   	ret    

80101836 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101836:	55                   	push   %ebp
80101837:	89 e5                	mov    %esp,%ebp
80101839:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010183c:	8b 45 08             	mov    0x8(%ebp),%eax
8010183f:	8b 40 04             	mov    0x4(%eax),%eax
80101842:	c1 e8 03             	shr    $0x3,%eax
80101845:	89 c2                	mov    %eax,%edx
80101847:	a1 54 32 11 80       	mov    0x80113254,%eax
8010184c:	01 c2                	add    %eax,%edx
8010184e:	8b 45 08             	mov    0x8(%ebp),%eax
80101851:	8b 00                	mov    (%eax),%eax
80101853:	83 ec 08             	sub    $0x8,%esp
80101856:	52                   	push   %edx
80101857:	50                   	push   %eax
80101858:	e8 59 e9 ff ff       	call   801001b6 <bread>
8010185d:	83 c4 10             	add    $0x10,%esp
80101860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101866:	8d 50 18             	lea    0x18(%eax),%edx
80101869:	8b 45 08             	mov    0x8(%ebp),%eax
8010186c:	8b 40 04             	mov    0x4(%eax),%eax
8010186f:	83 e0 07             	and    $0x7,%eax
80101872:	c1 e0 06             	shl    $0x6,%eax
80101875:	01 d0                	add    %edx,%eax
80101877:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010187a:	8b 45 08             	mov    0x8(%ebp),%eax
8010187d:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101881:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101884:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101887:	8b 45 08             	mov    0x8(%ebp),%eax
8010188a:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101891:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101895:	8b 45 08             	mov    0x8(%ebp),%eax
80101898:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010189c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189f:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018a3:	8b 45 08             	mov    0x8(%ebp),%eax
801018a6:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ad:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018b1:	8b 45 08             	mov    0x8(%ebp),%eax
801018b4:	8b 50 18             	mov    0x18(%eax),%edx
801018b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ba:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018bd:	8b 45 08             	mov    0x8(%ebp),%eax
801018c0:	8d 50 1c             	lea    0x1c(%eax),%edx
801018c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c6:	83 c0 0c             	add    $0xc,%eax
801018c9:	83 ec 04             	sub    $0x4,%esp
801018cc:	6a 34                	push   $0x34
801018ce:	52                   	push   %edx
801018cf:	50                   	push   %eax
801018d0:	e8 5c 4d 00 00       	call   80106631 <memmove>
801018d5:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018d8:	83 ec 0c             	sub    $0xc,%esp
801018db:	ff 75 f4             	pushl  -0xc(%ebp)
801018de:	e8 48 1f 00 00       	call   8010382b <log_write>
801018e3:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018e6:	83 ec 0c             	sub    $0xc,%esp
801018e9:	ff 75 f4             	pushl  -0xc(%ebp)
801018ec:	e8 3d e9 ff ff       	call   8010022e <brelse>
801018f1:	83 c4 10             	add    $0x10,%esp
}
801018f4:	90                   	nop
801018f5:	c9                   	leave  
801018f6:	c3                   	ret    

801018f7 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018f7:	55                   	push   %ebp
801018f8:	89 e5                	mov    %esp,%ebp
801018fa:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018fd:	83 ec 0c             	sub    $0xc,%esp
80101900:	68 60 32 11 80       	push   $0x80113260
80101905:	e8 05 4a 00 00       	call   8010630f <acquire>
8010190a:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010190d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101914:	c7 45 f4 94 32 11 80 	movl   $0x80113294,-0xc(%ebp)
8010191b:	eb 5d                	jmp    8010197a <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010191d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101920:	8b 40 08             	mov    0x8(%eax),%eax
80101923:	85 c0                	test   %eax,%eax
80101925:	7e 39                	jle    80101960 <iget+0x69>
80101927:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192a:	8b 00                	mov    (%eax),%eax
8010192c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010192f:	75 2f                	jne    80101960 <iget+0x69>
80101931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101934:	8b 40 04             	mov    0x4(%eax),%eax
80101937:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010193a:	75 24                	jne    80101960 <iget+0x69>
      ip->ref++;
8010193c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193f:	8b 40 08             	mov    0x8(%eax),%eax
80101942:	8d 50 01             	lea    0x1(%eax),%edx
80101945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101948:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010194b:	83 ec 0c             	sub    $0xc,%esp
8010194e:	68 60 32 11 80       	push   $0x80113260
80101953:	e8 1e 4a 00 00       	call   80106376 <release>
80101958:	83 c4 10             	add    $0x10,%esp
      return ip;
8010195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195e:	eb 74                	jmp    801019d4 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101960:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101964:	75 10                	jne    80101976 <iget+0x7f>
80101966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101969:	8b 40 08             	mov    0x8(%eax),%eax
8010196c:	85 c0                	test   %eax,%eax
8010196e:	75 06                	jne    80101976 <iget+0x7f>
      empty = ip;
80101970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101973:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101976:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010197a:	81 7d f4 34 42 11 80 	cmpl   $0x80114234,-0xc(%ebp)
80101981:	72 9a                	jb     8010191d <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101983:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101987:	75 0d                	jne    80101996 <iget+0x9f>
    panic("iget: no inodes");
80101989:	83 ec 0c             	sub    $0xc,%esp
8010198c:	68 2d 9b 10 80       	push   $0x80109b2d
80101991:	e8 d0 eb ff ff       	call   80100566 <panic>

  ip = empty;
80101996:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101999:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010199f:	8b 55 08             	mov    0x8(%ebp),%edx
801019a2:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801019aa:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801019b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801019c1:	83 ec 0c             	sub    $0xc,%esp
801019c4:	68 60 32 11 80       	push   $0x80113260
801019c9:	e8 a8 49 00 00       	call   80106376 <release>
801019ce:	83 c4 10             	add    $0x10,%esp

  return ip;
801019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019d4:	c9                   	leave  
801019d5:	c3                   	ret    

801019d6 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019d6:	55                   	push   %ebp
801019d7:	89 e5                	mov    %esp,%ebp
801019d9:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019dc:	83 ec 0c             	sub    $0xc,%esp
801019df:	68 60 32 11 80       	push   $0x80113260
801019e4:	e8 26 49 00 00       	call   8010630f <acquire>
801019e9:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	8b 40 08             	mov    0x8(%eax),%eax
801019f2:	8d 50 01             	lea    0x1(%eax),%edx
801019f5:	8b 45 08             	mov    0x8(%ebp),%eax
801019f8:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019fb:	83 ec 0c             	sub    $0xc,%esp
801019fe:	68 60 32 11 80       	push   $0x80113260
80101a03:	e8 6e 49 00 00       	call   80106376 <release>
80101a08:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a0e:	c9                   	leave  
80101a0f:	c3                   	ret    

80101a10 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a1a:	74 0a                	je     80101a26 <ilock+0x16>
80101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1f:	8b 40 08             	mov    0x8(%eax),%eax
80101a22:	85 c0                	test   %eax,%eax
80101a24:	7f 0d                	jg     80101a33 <ilock+0x23>
    panic("ilock");
80101a26:	83 ec 0c             	sub    $0xc,%esp
80101a29:	68 3d 9b 10 80       	push   $0x80109b3d
80101a2e:	e8 33 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a33:	83 ec 0c             	sub    $0xc,%esp
80101a36:	68 60 32 11 80       	push   $0x80113260
80101a3b:	e8 cf 48 00 00       	call   8010630f <acquire>
80101a40:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a43:	eb 13                	jmp    80101a58 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a45:	83 ec 08             	sub    $0x8,%esp
80101a48:	68 60 32 11 80       	push   $0x80113260
80101a4d:	ff 75 08             	pushl  0x8(%ebp)
80101a50:	e8 77 39 00 00       	call   801053cc <sleep>
80101a55:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101a58:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a5e:	83 e0 01             	and    $0x1,%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	75 e0                	jne    80101a45 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101a65:	8b 45 08             	mov    0x8(%ebp),%eax
80101a68:	8b 40 0c             	mov    0xc(%eax),%eax
80101a6b:	83 c8 01             	or     $0x1,%eax
80101a6e:	89 c2                	mov    %eax,%edx
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a76:	83 ec 0c             	sub    $0xc,%esp
80101a79:	68 60 32 11 80       	push   $0x80113260
80101a7e:	e8 f3 48 00 00       	call   80106376 <release>
80101a83:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a86:	8b 45 08             	mov    0x8(%ebp),%eax
80101a89:	8b 40 0c             	mov    0xc(%eax),%eax
80101a8c:	83 e0 02             	and    $0x2,%eax
80101a8f:	85 c0                	test   %eax,%eax
80101a91:	0f 85 d4 00 00 00    	jne    80101b6b <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a97:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9a:	8b 40 04             	mov    0x4(%eax),%eax
80101a9d:	c1 e8 03             	shr    $0x3,%eax
80101aa0:	89 c2                	mov    %eax,%edx
80101aa2:	a1 54 32 11 80       	mov    0x80113254,%eax
80101aa7:	01 c2                	add    %eax,%edx
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 00                	mov    (%eax),%eax
80101aae:	83 ec 08             	sub    $0x8,%esp
80101ab1:	52                   	push   %edx
80101ab2:	50                   	push   %eax
80101ab3:	e8 fe e6 ff ff       	call   801001b6 <bread>
80101ab8:	83 c4 10             	add    $0x10,%esp
80101abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ac1:	8d 50 18             	lea    0x18(%eax),%edx
80101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac7:	8b 40 04             	mov    0x4(%eax),%eax
80101aca:	83 e0 07             	and    $0x7,%eax
80101acd:	c1 e0 06             	shl    $0x6,%eax
80101ad0:	01 d0                	add    %edx,%eax
80101ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad8:	0f b7 10             	movzwl (%eax),%edx
80101adb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ade:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae5:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aec:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af3:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101af7:	8b 45 08             	mov    0x8(%ebp),%eax
80101afa:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b01:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101b05:	8b 45 08             	mov    0x8(%ebp),%eax
80101b08:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b0f:	8b 50 08             	mov    0x8(%eax),%edx
80101b12:	8b 45 08             	mov    0x8(%ebp),%eax
80101b15:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b1b:	8d 50 0c             	lea    0xc(%eax),%edx
80101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b21:	83 c0 1c             	add    $0x1c,%eax
80101b24:	83 ec 04             	sub    $0x4,%esp
80101b27:	6a 34                	push   $0x34
80101b29:	52                   	push   %edx
80101b2a:	50                   	push   %eax
80101b2b:	e8 01 4b 00 00       	call   80106631 <memmove>
80101b30:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b33:	83 ec 0c             	sub    $0xc,%esp
80101b36:	ff 75 f4             	pushl  -0xc(%ebp)
80101b39:	e8 f0 e6 ff ff       	call   8010022e <brelse>
80101b3e:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101b41:	8b 45 08             	mov    0x8(%ebp),%eax
80101b44:	8b 40 0c             	mov    0xc(%eax),%eax
80101b47:	83 c8 02             	or     $0x2,%eax
80101b4a:	89 c2                	mov    %eax,%edx
80101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4f:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101b52:	8b 45 08             	mov    0x8(%ebp),%eax
80101b55:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b59:	66 85 c0             	test   %ax,%ax
80101b5c:	75 0d                	jne    80101b6b <ilock+0x15b>
      panic("ilock: no type");
80101b5e:	83 ec 0c             	sub    $0xc,%esp
80101b61:	68 43 9b 10 80       	push   $0x80109b43
80101b66:	e8 fb e9 ff ff       	call   80100566 <panic>
  }
}
80101b6b:	90                   	nop
80101b6c:	c9                   	leave  
80101b6d:	c3                   	ret    

80101b6e <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b6e:	55                   	push   %ebp
80101b6f:	89 e5                	mov    %esp,%ebp
80101b71:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b78:	74 17                	je     80101b91 <iunlock+0x23>
80101b7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7d:	8b 40 0c             	mov    0xc(%eax),%eax
80101b80:	83 e0 01             	and    $0x1,%eax
80101b83:	85 c0                	test   %eax,%eax
80101b85:	74 0a                	je     80101b91 <iunlock+0x23>
80101b87:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8a:	8b 40 08             	mov    0x8(%eax),%eax
80101b8d:	85 c0                	test   %eax,%eax
80101b8f:	7f 0d                	jg     80101b9e <iunlock+0x30>
    panic("iunlock");
80101b91:	83 ec 0c             	sub    $0xc,%esp
80101b94:	68 52 9b 10 80       	push   $0x80109b52
80101b99:	e8 c8 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b9e:	83 ec 0c             	sub    $0xc,%esp
80101ba1:	68 60 32 11 80       	push   $0x80113260
80101ba6:	e8 64 47 00 00       	call   8010630f <acquire>
80101bab:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101bae:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb1:	8b 40 0c             	mov    0xc(%eax),%eax
80101bb4:	83 e0 fe             	and    $0xfffffffe,%eax
80101bb7:	89 c2                	mov    %eax,%edx
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101bbf:	83 ec 0c             	sub    $0xc,%esp
80101bc2:	ff 75 08             	pushl  0x8(%ebp)
80101bc5:	e8 5d 39 00 00       	call   80105527 <wakeup>
80101bca:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bcd:	83 ec 0c             	sub    $0xc,%esp
80101bd0:	68 60 32 11 80       	push   $0x80113260
80101bd5:	e8 9c 47 00 00       	call   80106376 <release>
80101bda:	83 c4 10             	add    $0x10,%esp
}
80101bdd:	90                   	nop
80101bde:	c9                   	leave  
80101bdf:	c3                   	ret    

80101be0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101be6:	83 ec 0c             	sub    $0xc,%esp
80101be9:	68 60 32 11 80       	push   $0x80113260
80101bee:	e8 1c 47 00 00       	call   8010630f <acquire>
80101bf3:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf9:	8b 40 08             	mov    0x8(%eax),%eax
80101bfc:	83 f8 01             	cmp    $0x1,%eax
80101bff:	0f 85 a9 00 00 00    	jne    80101cae <iput+0xce>
80101c05:	8b 45 08             	mov    0x8(%ebp),%eax
80101c08:	8b 40 0c             	mov    0xc(%eax),%eax
80101c0b:	83 e0 02             	and    $0x2,%eax
80101c0e:	85 c0                	test   %eax,%eax
80101c10:	0f 84 98 00 00 00    	je     80101cae <iput+0xce>
80101c16:	8b 45 08             	mov    0x8(%ebp),%eax
80101c19:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101c1d:	66 85 c0             	test   %ax,%ax
80101c20:	0f 85 88 00 00 00    	jne    80101cae <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101c26:	8b 45 08             	mov    0x8(%ebp),%eax
80101c29:	8b 40 0c             	mov    0xc(%eax),%eax
80101c2c:	83 e0 01             	and    $0x1,%eax
80101c2f:	85 c0                	test   %eax,%eax
80101c31:	74 0d                	je     80101c40 <iput+0x60>
      panic("iput busy");
80101c33:	83 ec 0c             	sub    $0xc,%esp
80101c36:	68 5a 9b 10 80       	push   $0x80109b5a
80101c3b:	e8 26 e9 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101c40:	8b 45 08             	mov    0x8(%ebp),%eax
80101c43:	8b 40 0c             	mov    0xc(%eax),%eax
80101c46:	83 c8 01             	or     $0x1,%eax
80101c49:	89 c2                	mov    %eax,%edx
80101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4e:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101c51:	83 ec 0c             	sub    $0xc,%esp
80101c54:	68 60 32 11 80       	push   $0x80113260
80101c59:	e8 18 47 00 00       	call   80106376 <release>
80101c5e:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c61:	83 ec 0c             	sub    $0xc,%esp
80101c64:	ff 75 08             	pushl  0x8(%ebp)
80101c67:	e8 a8 01 00 00       	call   80101e14 <itrunc>
80101c6c:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c72:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c78:	83 ec 0c             	sub    $0xc,%esp
80101c7b:	ff 75 08             	pushl  0x8(%ebp)
80101c7e:	e8 b3 fb ff ff       	call   80101836 <iupdate>
80101c83:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c86:	83 ec 0c             	sub    $0xc,%esp
80101c89:	68 60 32 11 80       	push   $0x80113260
80101c8e:	e8 7c 46 00 00       	call   8010630f <acquire>
80101c93:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c96:	8b 45 08             	mov    0x8(%ebp),%eax
80101c99:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ca0:	83 ec 0c             	sub    $0xc,%esp
80101ca3:	ff 75 08             	pushl  0x8(%ebp)
80101ca6:	e8 7c 38 00 00       	call   80105527 <wakeup>
80101cab:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101cae:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb1:	8b 40 08             	mov    0x8(%eax),%eax
80101cb4:	8d 50 ff             	lea    -0x1(%eax),%edx
80101cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cba:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101cbd:	83 ec 0c             	sub    $0xc,%esp
80101cc0:	68 60 32 11 80       	push   $0x80113260
80101cc5:	e8 ac 46 00 00       	call   80106376 <release>
80101cca:	83 c4 10             	add    $0x10,%esp
}
80101ccd:	90                   	nop
80101cce:	c9                   	leave  
80101ccf:	c3                   	ret    

80101cd0 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101cd6:	83 ec 0c             	sub    $0xc,%esp
80101cd9:	ff 75 08             	pushl  0x8(%ebp)
80101cdc:	e8 8d fe ff ff       	call   80101b6e <iunlock>
80101ce1:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101ce4:	83 ec 0c             	sub    $0xc,%esp
80101ce7:	ff 75 08             	pushl  0x8(%ebp)
80101cea:	e8 f1 fe ff ff       	call   80101be0 <iput>
80101cef:	83 c4 10             	add    $0x10,%esp
}
80101cf2:	90                   	nop
80101cf3:	c9                   	leave  
80101cf4:	c3                   	ret    

80101cf5 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101cf5:	55                   	push   %ebp
80101cf6:	89 e5                	mov    %esp,%ebp
80101cf8:	53                   	push   %ebx
80101cf9:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101cfc:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101d00:	77 42                	ja     80101d44 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101d02:	8b 45 08             	mov    0x8(%ebp),%eax
80101d05:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d08:	83 c2 04             	add    $0x4,%edx
80101d0b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d16:	75 24                	jne    80101d3c <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d18:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1b:	8b 00                	mov    (%eax),%eax
80101d1d:	83 ec 0c             	sub    $0xc,%esp
80101d20:	50                   	push   %eax
80101d21:	e8 9a f7 ff ff       	call   801014c0 <balloc>
80101d26:	83 c4 10             	add    $0x10,%esp
80101d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d32:	8d 4a 04             	lea    0x4(%edx),%ecx
80101d35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d38:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d3f:	e9 cb 00 00 00       	jmp    80101e0f <bmap+0x11a>
  }
  bn -= NDIRECT;
80101d44:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d48:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d4c:	0f 87 b0 00 00 00    	ja     80101e02 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d52:	8b 45 08             	mov    0x8(%ebp),%eax
80101d55:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d5f:	75 1d                	jne    80101d7e <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d61:	8b 45 08             	mov    0x8(%ebp),%eax
80101d64:	8b 00                	mov    (%eax),%eax
80101d66:	83 ec 0c             	sub    $0xc,%esp
80101d69:	50                   	push   %eax
80101d6a:	e8 51 f7 ff ff       	call   801014c0 <balloc>
80101d6f:	83 c4 10             	add    $0x10,%esp
80101d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d75:	8b 45 08             	mov    0x8(%ebp),%eax
80101d78:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d7b:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d81:	8b 00                	mov    (%eax),%eax
80101d83:	83 ec 08             	sub    $0x8,%esp
80101d86:	ff 75 f4             	pushl  -0xc(%ebp)
80101d89:	50                   	push   %eax
80101d8a:	e8 27 e4 ff ff       	call   801001b6 <bread>
80101d8f:	83 c4 10             	add    $0x10,%esp
80101d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d98:	83 c0 18             	add    $0x18,%eax
80101d9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101da1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dab:	01 d0                	add    %edx,%eax
80101dad:	8b 00                	mov    (%eax),%eax
80101daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101db6:	75 37                	jne    80101def <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101db8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dbb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dc5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101dc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcb:	8b 00                	mov    (%eax),%eax
80101dcd:	83 ec 0c             	sub    $0xc,%esp
80101dd0:	50                   	push   %eax
80101dd1:	e8 ea f6 ff ff       	call   801014c0 <balloc>
80101dd6:	83 c4 10             	add    $0x10,%esp
80101dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ddf:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101de1:	83 ec 0c             	sub    $0xc,%esp
80101de4:	ff 75 f0             	pushl  -0x10(%ebp)
80101de7:	e8 3f 1a 00 00       	call   8010382b <log_write>
80101dec:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101def:	83 ec 0c             	sub    $0xc,%esp
80101df2:	ff 75 f0             	pushl  -0x10(%ebp)
80101df5:	e8 34 e4 ff ff       	call   8010022e <brelse>
80101dfa:	83 c4 10             	add    $0x10,%esp
    return addr;
80101dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e00:	eb 0d                	jmp    80101e0f <bmap+0x11a>
  }

  panic("bmap: out of range");
80101e02:	83 ec 0c             	sub    $0xc,%esp
80101e05:	68 64 9b 10 80       	push   $0x80109b64
80101e0a:	e8 57 e7 ff ff       	call   80100566 <panic>
}
80101e0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e12:	c9                   	leave  
80101e13:	c3                   	ret    

80101e14 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e14:	55                   	push   %ebp
80101e15:	89 e5                	mov    %esp,%ebp
80101e17:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e21:	eb 45                	jmp    80101e68 <itrunc+0x54>
    if(ip->addrs[i]){
80101e23:	8b 45 08             	mov    0x8(%ebp),%eax
80101e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e29:	83 c2 04             	add    $0x4,%edx
80101e2c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e30:	85 c0                	test   %eax,%eax
80101e32:	74 30                	je     80101e64 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101e34:	8b 45 08             	mov    0x8(%ebp),%eax
80101e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e3a:	83 c2 04             	add    $0x4,%edx
80101e3d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e41:	8b 55 08             	mov    0x8(%ebp),%edx
80101e44:	8b 12                	mov    (%edx),%edx
80101e46:	83 ec 08             	sub    $0x8,%esp
80101e49:	50                   	push   %eax
80101e4a:	52                   	push   %edx
80101e4b:	e8 bc f7 ff ff       	call   8010160c <bfree>
80101e50:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e53:	8b 45 08             	mov    0x8(%ebp),%eax
80101e56:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e59:	83 c2 04             	add    $0x4,%edx
80101e5c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e63:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e68:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e6c:	7e b5                	jle    80101e23 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e71:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e74:	85 c0                	test   %eax,%eax
80101e76:	0f 84 a1 00 00 00    	je     80101f1d <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e82:	8b 45 08             	mov    0x8(%ebp),%eax
80101e85:	8b 00                	mov    (%eax),%eax
80101e87:	83 ec 08             	sub    $0x8,%esp
80101e8a:	52                   	push   %edx
80101e8b:	50                   	push   %eax
80101e8c:	e8 25 e3 ff ff       	call   801001b6 <bread>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e9a:	83 c0 18             	add    $0x18,%eax
80101e9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ea0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101ea7:	eb 3c                	jmp    80101ee5 <itrunc+0xd1>
      if(a[j])
80101ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101eb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101eb6:	01 d0                	add    %edx,%eax
80101eb8:	8b 00                	mov    (%eax),%eax
80101eba:	85 c0                	test   %eax,%eax
80101ebc:	74 23                	je     80101ee1 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ecb:	01 d0                	add    %edx,%eax
80101ecd:	8b 00                	mov    (%eax),%eax
80101ecf:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed2:	8b 12                	mov    (%edx),%edx
80101ed4:	83 ec 08             	sub    $0x8,%esp
80101ed7:	50                   	push   %eax
80101ed8:	52                   	push   %edx
80101ed9:	e8 2e f7 ff ff       	call   8010160c <bfree>
80101ede:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ee1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee8:	83 f8 7f             	cmp    $0x7f,%eax
80101eeb:	76 bc                	jbe    80101ea9 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101eed:	83 ec 0c             	sub    $0xc,%esp
80101ef0:	ff 75 ec             	pushl  -0x14(%ebp)
80101ef3:	e8 36 e3 ff ff       	call   8010022e <brelse>
80101ef8:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101efb:	8b 45 08             	mov    0x8(%ebp),%eax
80101efe:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f01:	8b 55 08             	mov    0x8(%ebp),%edx
80101f04:	8b 12                	mov    (%edx),%edx
80101f06:	83 ec 08             	sub    $0x8,%esp
80101f09:	50                   	push   %eax
80101f0a:	52                   	push   %edx
80101f0b:	e8 fc f6 ff ff       	call   8010160c <bfree>
80101f10:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101f13:	8b 45 08             	mov    0x8(%ebp),%eax
80101f16:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101f1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f20:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101f27:	83 ec 0c             	sub    $0xc,%esp
80101f2a:	ff 75 08             	pushl  0x8(%ebp)
80101f2d:	e8 04 f9 ff ff       	call   80101836 <iupdate>
80101f32:	83 c4 10             	add    $0x10,%esp
}
80101f35:	90                   	nop
80101f36:	c9                   	leave  
80101f37:	c3                   	ret    

80101f38 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101f38:	55                   	push   %ebp
80101f39:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3e:	8b 00                	mov    (%eax),%eax
80101f40:	89 c2                	mov    %eax,%edx
80101f42:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f45:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f48:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4b:	8b 50 04             	mov    0x4(%eax),%edx
80101f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f51:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f54:	8b 45 08             	mov    0x8(%ebp),%eax
80101f57:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f5e:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f61:	8b 45 08             	mov    0x8(%ebp),%eax
80101f64:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f68:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f6b:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f72:	8b 50 18             	mov    0x18(%eax),%edx
80101f75:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f78:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f7b:	90                   	nop
80101f7c:	5d                   	pop    %ebp
80101f7d:	c3                   	ret    

80101f7e <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f7e:	55                   	push   %ebp
80101f7f:	89 e5                	mov    %esp,%ebp
80101f81:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f84:	8b 45 08             	mov    0x8(%ebp),%eax
80101f87:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f8b:	66 83 f8 03          	cmp    $0x3,%ax
80101f8f:	75 5c                	jne    80101fed <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f91:	8b 45 08             	mov    0x8(%ebp),%eax
80101f94:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f98:	66 85 c0             	test   %ax,%ax
80101f9b:	78 20                	js     80101fbd <readi+0x3f>
80101f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa4:	66 83 f8 09          	cmp    $0x9,%ax
80101fa8:	7f 13                	jg     80101fbd <readi+0x3f>
80101faa:	8b 45 08             	mov    0x8(%ebp),%eax
80101fad:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fb1:	98                   	cwtl   
80101fb2:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
80101fb9:	85 c0                	test   %eax,%eax
80101fbb:	75 0a                	jne    80101fc7 <readi+0x49>
      return -1;
80101fbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc2:	e9 0c 01 00 00       	jmp    801020d3 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101fca:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fce:	98                   	cwtl   
80101fcf:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
80101fd6:	8b 55 14             	mov    0x14(%ebp),%edx
80101fd9:	83 ec 04             	sub    $0x4,%esp
80101fdc:	52                   	push   %edx
80101fdd:	ff 75 0c             	pushl  0xc(%ebp)
80101fe0:	ff 75 08             	pushl  0x8(%ebp)
80101fe3:	ff d0                	call   *%eax
80101fe5:	83 c4 10             	add    $0x10,%esp
80101fe8:	e9 e6 00 00 00       	jmp    801020d3 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101fed:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff0:	8b 40 18             	mov    0x18(%eax),%eax
80101ff3:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ff6:	72 0d                	jb     80102005 <readi+0x87>
80101ff8:	8b 55 10             	mov    0x10(%ebp),%edx
80101ffb:	8b 45 14             	mov    0x14(%ebp),%eax
80101ffe:	01 d0                	add    %edx,%eax
80102000:	3b 45 10             	cmp    0x10(%ebp),%eax
80102003:	73 0a                	jae    8010200f <readi+0x91>
    return -1;
80102005:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200a:	e9 c4 00 00 00       	jmp    801020d3 <readi+0x155>
  if(off + n > ip->size)
8010200f:	8b 55 10             	mov    0x10(%ebp),%edx
80102012:	8b 45 14             	mov    0x14(%ebp),%eax
80102015:	01 c2                	add    %eax,%edx
80102017:	8b 45 08             	mov    0x8(%ebp),%eax
8010201a:	8b 40 18             	mov    0x18(%eax),%eax
8010201d:	39 c2                	cmp    %eax,%edx
8010201f:	76 0c                	jbe    8010202d <readi+0xaf>
    n = ip->size - off;
80102021:	8b 45 08             	mov    0x8(%ebp),%eax
80102024:	8b 40 18             	mov    0x18(%eax),%eax
80102027:	2b 45 10             	sub    0x10(%ebp),%eax
8010202a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010202d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102034:	e9 8b 00 00 00       	jmp    801020c4 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102039:	8b 45 10             	mov    0x10(%ebp),%eax
8010203c:	c1 e8 09             	shr    $0x9,%eax
8010203f:	83 ec 08             	sub    $0x8,%esp
80102042:	50                   	push   %eax
80102043:	ff 75 08             	pushl  0x8(%ebp)
80102046:	e8 aa fc ff ff       	call   80101cf5 <bmap>
8010204b:	83 c4 10             	add    $0x10,%esp
8010204e:	89 c2                	mov    %eax,%edx
80102050:	8b 45 08             	mov    0x8(%ebp),%eax
80102053:	8b 00                	mov    (%eax),%eax
80102055:	83 ec 08             	sub    $0x8,%esp
80102058:	52                   	push   %edx
80102059:	50                   	push   %eax
8010205a:	e8 57 e1 ff ff       	call   801001b6 <bread>
8010205f:	83 c4 10             	add    $0x10,%esp
80102062:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102065:	8b 45 10             	mov    0x10(%ebp),%eax
80102068:	25 ff 01 00 00       	and    $0x1ff,%eax
8010206d:	ba 00 02 00 00       	mov    $0x200,%edx
80102072:	29 c2                	sub    %eax,%edx
80102074:	8b 45 14             	mov    0x14(%ebp),%eax
80102077:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010207a:	39 c2                	cmp    %eax,%edx
8010207c:	0f 46 c2             	cmovbe %edx,%eax
8010207f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102082:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102085:	8d 50 18             	lea    0x18(%eax),%edx
80102088:	8b 45 10             	mov    0x10(%ebp),%eax
8010208b:	25 ff 01 00 00       	and    $0x1ff,%eax
80102090:	01 d0                	add    %edx,%eax
80102092:	83 ec 04             	sub    $0x4,%esp
80102095:	ff 75 ec             	pushl  -0x14(%ebp)
80102098:	50                   	push   %eax
80102099:	ff 75 0c             	pushl  0xc(%ebp)
8010209c:	e8 90 45 00 00       	call   80106631 <memmove>
801020a1:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	ff 75 f0             	pushl  -0x10(%ebp)
801020aa:	e8 7f e1 ff ff       	call   8010022e <brelse>
801020af:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020b5:	01 45 f4             	add    %eax,-0xc(%ebp)
801020b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020bb:	01 45 10             	add    %eax,0x10(%ebp)
801020be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020c1:	01 45 0c             	add    %eax,0xc(%ebp)
801020c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020c7:	3b 45 14             	cmp    0x14(%ebp),%eax
801020ca:	0f 82 69 ff ff ff    	jb     80102039 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801020d0:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020d3:	c9                   	leave  
801020d4:	c3                   	ret    

801020d5 <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020d5:	55                   	push   %ebp
801020d6:	89 e5                	mov    %esp,%ebp
801020d8:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
801020de:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020e2:	66 83 f8 03          	cmp    $0x3,%ax
801020e6:	75 5c                	jne    80102144 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020e8:	8b 45 08             	mov    0x8(%ebp),%eax
801020eb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020ef:	66 85 c0             	test   %ax,%ax
801020f2:	78 20                	js     80102114 <writei+0x3f>
801020f4:	8b 45 08             	mov    0x8(%ebp),%eax
801020f7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020fb:	66 83 f8 09          	cmp    $0x9,%ax
801020ff:	7f 13                	jg     80102114 <writei+0x3f>
80102101:	8b 45 08             	mov    0x8(%ebp),%eax
80102104:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102108:	98                   	cwtl   
80102109:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
80102110:	85 c0                	test   %eax,%eax
80102112:	75 0a                	jne    8010211e <writei+0x49>
      return -1;
80102114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102119:	e9 3d 01 00 00       	jmp    8010225b <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010211e:	8b 45 08             	mov    0x8(%ebp),%eax
80102121:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102125:	98                   	cwtl   
80102126:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
8010212d:	8b 55 14             	mov    0x14(%ebp),%edx
80102130:	83 ec 04             	sub    $0x4,%esp
80102133:	52                   	push   %edx
80102134:	ff 75 0c             	pushl  0xc(%ebp)
80102137:	ff 75 08             	pushl  0x8(%ebp)
8010213a:	ff d0                	call   *%eax
8010213c:	83 c4 10             	add    $0x10,%esp
8010213f:	e9 17 01 00 00       	jmp    8010225b <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102144:	8b 45 08             	mov    0x8(%ebp),%eax
80102147:	8b 40 18             	mov    0x18(%eax),%eax
8010214a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010214d:	72 0d                	jb     8010215c <writei+0x87>
8010214f:	8b 55 10             	mov    0x10(%ebp),%edx
80102152:	8b 45 14             	mov    0x14(%ebp),%eax
80102155:	01 d0                	add    %edx,%eax
80102157:	3b 45 10             	cmp    0x10(%ebp),%eax
8010215a:	73 0a                	jae    80102166 <writei+0x91>
    return -1;
8010215c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102161:	e9 f5 00 00 00       	jmp    8010225b <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
80102166:	8b 55 10             	mov    0x10(%ebp),%edx
80102169:	8b 45 14             	mov    0x14(%ebp),%eax
8010216c:	01 d0                	add    %edx,%eax
8010216e:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102173:	76 0a                	jbe    8010217f <writei+0xaa>
    return -1;
80102175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010217a:	e9 dc 00 00 00       	jmp    8010225b <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010217f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102186:	e9 99 00 00 00       	jmp    80102224 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010218b:	8b 45 10             	mov    0x10(%ebp),%eax
8010218e:	c1 e8 09             	shr    $0x9,%eax
80102191:	83 ec 08             	sub    $0x8,%esp
80102194:	50                   	push   %eax
80102195:	ff 75 08             	pushl  0x8(%ebp)
80102198:	e8 58 fb ff ff       	call   80101cf5 <bmap>
8010219d:	83 c4 10             	add    $0x10,%esp
801021a0:	89 c2                	mov    %eax,%edx
801021a2:	8b 45 08             	mov    0x8(%ebp),%eax
801021a5:	8b 00                	mov    (%eax),%eax
801021a7:	83 ec 08             	sub    $0x8,%esp
801021aa:	52                   	push   %edx
801021ab:	50                   	push   %eax
801021ac:	e8 05 e0 ff ff       	call   801001b6 <bread>
801021b1:	83 c4 10             	add    $0x10,%esp
801021b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021b7:	8b 45 10             	mov    0x10(%ebp),%eax
801021ba:	25 ff 01 00 00       	and    $0x1ff,%eax
801021bf:	ba 00 02 00 00       	mov    $0x200,%edx
801021c4:	29 c2                	sub    %eax,%edx
801021c6:	8b 45 14             	mov    0x14(%ebp),%eax
801021c9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021cc:	39 c2                	cmp    %eax,%edx
801021ce:	0f 46 c2             	cmovbe %edx,%eax
801021d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021d7:	8d 50 18             	lea    0x18(%eax),%edx
801021da:	8b 45 10             	mov    0x10(%ebp),%eax
801021dd:	25 ff 01 00 00       	and    $0x1ff,%eax
801021e2:	01 d0                	add    %edx,%eax
801021e4:	83 ec 04             	sub    $0x4,%esp
801021e7:	ff 75 ec             	pushl  -0x14(%ebp)
801021ea:	ff 75 0c             	pushl  0xc(%ebp)
801021ed:	50                   	push   %eax
801021ee:	e8 3e 44 00 00       	call   80106631 <memmove>
801021f3:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801021f6:	83 ec 0c             	sub    $0xc,%esp
801021f9:	ff 75 f0             	pushl  -0x10(%ebp)
801021fc:	e8 2a 16 00 00       	call   8010382b <log_write>
80102201:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	ff 75 f0             	pushl  -0x10(%ebp)
8010220a:	e8 1f e0 ff ff       	call   8010022e <brelse>
8010220f:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102212:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102215:	01 45 f4             	add    %eax,-0xc(%ebp)
80102218:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010221b:	01 45 10             	add    %eax,0x10(%ebp)
8010221e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102221:	01 45 0c             	add    %eax,0xc(%ebp)
80102224:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102227:	3b 45 14             	cmp    0x14(%ebp),%eax
8010222a:	0f 82 5b ff ff ff    	jb     8010218b <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102230:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102234:	74 22                	je     80102258 <writei+0x183>
80102236:	8b 45 08             	mov    0x8(%ebp),%eax
80102239:	8b 40 18             	mov    0x18(%eax),%eax
8010223c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010223f:	73 17                	jae    80102258 <writei+0x183>
    ip->size = off;
80102241:	8b 45 08             	mov    0x8(%ebp),%eax
80102244:	8b 55 10             	mov    0x10(%ebp),%edx
80102247:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010224a:	83 ec 0c             	sub    $0xc,%esp
8010224d:	ff 75 08             	pushl  0x8(%ebp)
80102250:	e8 e1 f5 ff ff       	call   80101836 <iupdate>
80102255:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102258:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010225b:	c9                   	leave  
8010225c:	c3                   	ret    

8010225d <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
8010225d:	55                   	push   %ebp
8010225e:	89 e5                	mov    %esp,%ebp
80102260:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102263:	83 ec 04             	sub    $0x4,%esp
80102266:	6a 0e                	push   $0xe
80102268:	ff 75 0c             	pushl  0xc(%ebp)
8010226b:	ff 75 08             	pushl  0x8(%ebp)
8010226e:	e8 54 44 00 00       	call   801066c7 <strncmp>
80102273:	83 c4 10             	add    $0x10,%esp
}
80102276:	c9                   	leave  
80102277:	c3                   	ret    

80102278 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102278:	55                   	push   %ebp
80102279:	89 e5                	mov    %esp,%ebp
8010227b:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010227e:	8b 45 08             	mov    0x8(%ebp),%eax
80102281:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102285:	66 83 f8 01          	cmp    $0x1,%ax
80102289:	74 0d                	je     80102298 <dirlookup+0x20>
    panic("dirlookup not DIR");
8010228b:	83 ec 0c             	sub    $0xc,%esp
8010228e:	68 77 9b 10 80       	push   $0x80109b77
80102293:	e8 ce e2 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010229f:	eb 7b                	jmp    8010231c <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022a1:	6a 10                	push   $0x10
801022a3:	ff 75 f4             	pushl  -0xc(%ebp)
801022a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a9:	50                   	push   %eax
801022aa:	ff 75 08             	pushl  0x8(%ebp)
801022ad:	e8 cc fc ff ff       	call   80101f7e <readi>
801022b2:	83 c4 10             	add    $0x10,%esp
801022b5:	83 f8 10             	cmp    $0x10,%eax
801022b8:	74 0d                	je     801022c7 <dirlookup+0x4f>
      panic("dirlink read");
801022ba:	83 ec 0c             	sub    $0xc,%esp
801022bd:	68 89 9b 10 80       	push   $0x80109b89
801022c2:	e8 9f e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801022c7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022cb:	66 85 c0             	test   %ax,%ax
801022ce:	74 47                	je     80102317 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801022d0:	83 ec 08             	sub    $0x8,%esp
801022d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022d6:	83 c0 02             	add    $0x2,%eax
801022d9:	50                   	push   %eax
801022da:	ff 75 0c             	pushl  0xc(%ebp)
801022dd:	e8 7b ff ff ff       	call   8010225d <namecmp>
801022e2:	83 c4 10             	add    $0x10,%esp
801022e5:	85 c0                	test   %eax,%eax
801022e7:	75 2f                	jne    80102318 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801022e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022ed:	74 08                	je     801022f7 <dirlookup+0x7f>
        *poff = off;
801022ef:	8b 45 10             	mov    0x10(%ebp),%eax
801022f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022f5:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801022f7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022fb:	0f b7 c0             	movzwl %ax,%eax
801022fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102301:	8b 45 08             	mov    0x8(%ebp),%eax
80102304:	8b 00                	mov    (%eax),%eax
80102306:	83 ec 08             	sub    $0x8,%esp
80102309:	ff 75 f0             	pushl  -0x10(%ebp)
8010230c:	50                   	push   %eax
8010230d:	e8 e5 f5 ff ff       	call   801018f7 <iget>
80102312:	83 c4 10             	add    $0x10,%esp
80102315:	eb 19                	jmp    80102330 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102317:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102318:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010231c:	8b 45 08             	mov    0x8(%ebp),%eax
8010231f:	8b 40 18             	mov    0x18(%eax),%eax
80102322:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102325:	0f 87 76 ff ff ff    	ja     801022a1 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010232b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102330:	c9                   	leave  
80102331:	c3                   	ret    

80102332 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102332:	55                   	push   %ebp
80102333:	89 e5                	mov    %esp,%ebp
80102335:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102338:	83 ec 04             	sub    $0x4,%esp
8010233b:	6a 00                	push   $0x0
8010233d:	ff 75 0c             	pushl  0xc(%ebp)
80102340:	ff 75 08             	pushl  0x8(%ebp)
80102343:	e8 30 ff ff ff       	call   80102278 <dirlookup>
80102348:	83 c4 10             	add    $0x10,%esp
8010234b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010234e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102352:	74 18                	je     8010236c <dirlink+0x3a>
    iput(ip);
80102354:	83 ec 0c             	sub    $0xc,%esp
80102357:	ff 75 f0             	pushl  -0x10(%ebp)
8010235a:	e8 81 f8 ff ff       	call   80101be0 <iput>
8010235f:	83 c4 10             	add    $0x10,%esp
    return -1;
80102362:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102367:	e9 9c 00 00 00       	jmp    80102408 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010236c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102373:	eb 39                	jmp    801023ae <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102378:	6a 10                	push   $0x10
8010237a:	50                   	push   %eax
8010237b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010237e:	50                   	push   %eax
8010237f:	ff 75 08             	pushl  0x8(%ebp)
80102382:	e8 f7 fb ff ff       	call   80101f7e <readi>
80102387:	83 c4 10             	add    $0x10,%esp
8010238a:	83 f8 10             	cmp    $0x10,%eax
8010238d:	74 0d                	je     8010239c <dirlink+0x6a>
      panic("dirlink read");
8010238f:	83 ec 0c             	sub    $0xc,%esp
80102392:	68 89 9b 10 80       	push   $0x80109b89
80102397:	e8 ca e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
8010239c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801023a0:	66 85 c0             	test   %ax,%ax
801023a3:	74 18                	je     801023bd <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a8:	83 c0 10             	add    $0x10,%eax
801023ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023ae:	8b 45 08             	mov    0x8(%ebp),%eax
801023b1:	8b 50 18             	mov    0x18(%eax),%edx
801023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b7:	39 c2                	cmp    %eax,%edx
801023b9:	77 ba                	ja     80102375 <dirlink+0x43>
801023bb:	eb 01                	jmp    801023be <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801023bd:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801023be:	83 ec 04             	sub    $0x4,%esp
801023c1:	6a 0e                	push   $0xe
801023c3:	ff 75 0c             	pushl  0xc(%ebp)
801023c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023c9:	83 c0 02             	add    $0x2,%eax
801023cc:	50                   	push   %eax
801023cd:	e8 4b 43 00 00       	call   8010671d <strncpy>
801023d2:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023d5:	8b 45 10             	mov    0x10(%ebp),%eax
801023d8:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023df:	6a 10                	push   $0x10
801023e1:	50                   	push   %eax
801023e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023e5:	50                   	push   %eax
801023e6:	ff 75 08             	pushl  0x8(%ebp)
801023e9:	e8 e7 fc ff ff       	call   801020d5 <writei>
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	83 f8 10             	cmp    $0x10,%eax
801023f4:	74 0d                	je     80102403 <dirlink+0xd1>
    panic("dirlink");
801023f6:	83 ec 0c             	sub    $0xc,%esp
801023f9:	68 96 9b 10 80       	push   $0x80109b96
801023fe:	e8 63 e1 ff ff       	call   80100566 <panic>
  
  return 0;
80102403:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102408:	c9                   	leave  
80102409:	c3                   	ret    

8010240a <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010240a:	55                   	push   %ebp
8010240b:	89 e5                	mov    %esp,%ebp
8010240d:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102410:	eb 04                	jmp    80102416 <skipelem+0xc>
    path++;
80102412:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102416:	8b 45 08             	mov    0x8(%ebp),%eax
80102419:	0f b6 00             	movzbl (%eax),%eax
8010241c:	3c 2f                	cmp    $0x2f,%al
8010241e:	74 f2                	je     80102412 <skipelem+0x8>
    path++;
  if(*path == 0)
80102420:	8b 45 08             	mov    0x8(%ebp),%eax
80102423:	0f b6 00             	movzbl (%eax),%eax
80102426:	84 c0                	test   %al,%al
80102428:	75 07                	jne    80102431 <skipelem+0x27>
    return 0;
8010242a:	b8 00 00 00 00       	mov    $0x0,%eax
8010242f:	eb 7b                	jmp    801024ac <skipelem+0xa2>
  s = path;
80102431:	8b 45 08             	mov    0x8(%ebp),%eax
80102434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102437:	eb 04                	jmp    8010243d <skipelem+0x33>
    path++;
80102439:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
80102440:	0f b6 00             	movzbl (%eax),%eax
80102443:	3c 2f                	cmp    $0x2f,%al
80102445:	74 0a                	je     80102451 <skipelem+0x47>
80102447:	8b 45 08             	mov    0x8(%ebp),%eax
8010244a:	0f b6 00             	movzbl (%eax),%eax
8010244d:	84 c0                	test   %al,%al
8010244f:	75 e8                	jne    80102439 <skipelem+0x2f>
    path++;
  len = path - s;
80102451:	8b 55 08             	mov    0x8(%ebp),%edx
80102454:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102457:	29 c2                	sub    %eax,%edx
80102459:	89 d0                	mov    %edx,%eax
8010245b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010245e:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102462:	7e 15                	jle    80102479 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102464:	83 ec 04             	sub    $0x4,%esp
80102467:	6a 0e                	push   $0xe
80102469:	ff 75 f4             	pushl  -0xc(%ebp)
8010246c:	ff 75 0c             	pushl  0xc(%ebp)
8010246f:	e8 bd 41 00 00       	call   80106631 <memmove>
80102474:	83 c4 10             	add    $0x10,%esp
80102477:	eb 26                	jmp    8010249f <skipelem+0x95>
  else {
    memmove(name, s, len);
80102479:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010247c:	83 ec 04             	sub    $0x4,%esp
8010247f:	50                   	push   %eax
80102480:	ff 75 f4             	pushl  -0xc(%ebp)
80102483:	ff 75 0c             	pushl  0xc(%ebp)
80102486:	e8 a6 41 00 00       	call   80106631 <memmove>
8010248b:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010248e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102491:	8b 45 0c             	mov    0xc(%ebp),%eax
80102494:	01 d0                	add    %edx,%eax
80102496:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102499:	eb 04                	jmp    8010249f <skipelem+0x95>
    path++;
8010249b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010249f:	8b 45 08             	mov    0x8(%ebp),%eax
801024a2:	0f b6 00             	movzbl (%eax),%eax
801024a5:	3c 2f                	cmp    $0x2f,%al
801024a7:	74 f2                	je     8010249b <skipelem+0x91>
    path++;
  return path;
801024a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024ac:	c9                   	leave  
801024ad:	c3                   	ret    

801024ae <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801024ae:	55                   	push   %ebp
801024af:	89 e5                	mov    %esp,%ebp
801024b1:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801024b4:	8b 45 08             	mov    0x8(%ebp),%eax
801024b7:	0f b6 00             	movzbl (%eax),%eax
801024ba:	3c 2f                	cmp    $0x2f,%al
801024bc:	75 17                	jne    801024d5 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801024be:	83 ec 08             	sub    $0x8,%esp
801024c1:	6a 01                	push   $0x1
801024c3:	6a 01                	push   $0x1
801024c5:	e8 2d f4 ff ff       	call   801018f7 <iget>
801024ca:	83 c4 10             	add    $0x10,%esp
801024cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024d0:	e9 bb 00 00 00       	jmp    80102590 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801024d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801024db:	8b 40 68             	mov    0x68(%eax),%eax
801024de:	83 ec 0c             	sub    $0xc,%esp
801024e1:	50                   	push   %eax
801024e2:	e8 ef f4 ff ff       	call   801019d6 <idup>
801024e7:	83 c4 10             	add    $0x10,%esp
801024ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801024ed:	e9 9e 00 00 00       	jmp    80102590 <namex+0xe2>
    ilock(ip);
801024f2:	83 ec 0c             	sub    $0xc,%esp
801024f5:	ff 75 f4             	pushl  -0xc(%ebp)
801024f8:	e8 13 f5 ff ff       	call   80101a10 <ilock>
801024fd:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102503:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102507:	66 83 f8 01          	cmp    $0x1,%ax
8010250b:	74 18                	je     80102525 <namex+0x77>
      iunlockput(ip);
8010250d:	83 ec 0c             	sub    $0xc,%esp
80102510:	ff 75 f4             	pushl  -0xc(%ebp)
80102513:	e8 b8 f7 ff ff       	call   80101cd0 <iunlockput>
80102518:	83 c4 10             	add    $0x10,%esp
      return 0;
8010251b:	b8 00 00 00 00       	mov    $0x0,%eax
80102520:	e9 a7 00 00 00       	jmp    801025cc <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102525:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102529:	74 20                	je     8010254b <namex+0x9d>
8010252b:	8b 45 08             	mov    0x8(%ebp),%eax
8010252e:	0f b6 00             	movzbl (%eax),%eax
80102531:	84 c0                	test   %al,%al
80102533:	75 16                	jne    8010254b <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102535:	83 ec 0c             	sub    $0xc,%esp
80102538:	ff 75 f4             	pushl  -0xc(%ebp)
8010253b:	e8 2e f6 ff ff       	call   80101b6e <iunlock>
80102540:	83 c4 10             	add    $0x10,%esp
      return ip;
80102543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102546:	e9 81 00 00 00       	jmp    801025cc <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010254b:	83 ec 04             	sub    $0x4,%esp
8010254e:	6a 00                	push   $0x0
80102550:	ff 75 10             	pushl  0x10(%ebp)
80102553:	ff 75 f4             	pushl  -0xc(%ebp)
80102556:	e8 1d fd ff ff       	call   80102278 <dirlookup>
8010255b:	83 c4 10             	add    $0x10,%esp
8010255e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102561:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102565:	75 15                	jne    8010257c <namex+0xce>
      iunlockput(ip);
80102567:	83 ec 0c             	sub    $0xc,%esp
8010256a:	ff 75 f4             	pushl  -0xc(%ebp)
8010256d:	e8 5e f7 ff ff       	call   80101cd0 <iunlockput>
80102572:	83 c4 10             	add    $0x10,%esp
      return 0;
80102575:	b8 00 00 00 00       	mov    $0x0,%eax
8010257a:	eb 50                	jmp    801025cc <namex+0x11e>
    }
    iunlockput(ip);
8010257c:	83 ec 0c             	sub    $0xc,%esp
8010257f:	ff 75 f4             	pushl  -0xc(%ebp)
80102582:	e8 49 f7 ff ff       	call   80101cd0 <iunlockput>
80102587:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010258a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010258d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102590:	83 ec 08             	sub    $0x8,%esp
80102593:	ff 75 10             	pushl  0x10(%ebp)
80102596:	ff 75 08             	pushl  0x8(%ebp)
80102599:	e8 6c fe ff ff       	call   8010240a <skipelem>
8010259e:	83 c4 10             	add    $0x10,%esp
801025a1:	89 45 08             	mov    %eax,0x8(%ebp)
801025a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025a8:	0f 85 44 ff ff ff    	jne    801024f2 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801025ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025b2:	74 15                	je     801025c9 <namex+0x11b>
    iput(ip);
801025b4:	83 ec 0c             	sub    $0xc,%esp
801025b7:	ff 75 f4             	pushl  -0xc(%ebp)
801025ba:	e8 21 f6 ff ff       	call   80101be0 <iput>
801025bf:	83 c4 10             	add    $0x10,%esp
    return 0;
801025c2:	b8 00 00 00 00       	mov    $0x0,%eax
801025c7:	eb 03                	jmp    801025cc <namex+0x11e>
  }
  return ip;
801025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025cc:	c9                   	leave  
801025cd:	c3                   	ret    

801025ce <namei>:

struct inode*
namei(char *path)
{
801025ce:	55                   	push   %ebp
801025cf:	89 e5                	mov    %esp,%ebp
801025d1:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025d4:	83 ec 04             	sub    $0x4,%esp
801025d7:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025da:	50                   	push   %eax
801025db:	6a 00                	push   $0x0
801025dd:	ff 75 08             	pushl  0x8(%ebp)
801025e0:	e8 c9 fe ff ff       	call   801024ae <namex>
801025e5:	83 c4 10             	add    $0x10,%esp
}
801025e8:	c9                   	leave  
801025e9:	c3                   	ret    

801025ea <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025ea:	55                   	push   %ebp
801025eb:	89 e5                	mov    %esp,%ebp
801025ed:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801025f0:	83 ec 04             	sub    $0x4,%esp
801025f3:	ff 75 0c             	pushl  0xc(%ebp)
801025f6:	6a 01                	push   $0x1
801025f8:	ff 75 08             	pushl  0x8(%ebp)
801025fb:	e8 ae fe ff ff       	call   801024ae <namex>
80102600:	83 c4 10             	add    $0x10,%esp
}
80102603:	c9                   	leave  
80102604:	c3                   	ret    

80102605 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102605:	55                   	push   %ebp
80102606:	89 e5                	mov    %esp,%ebp
80102608:	83 ec 14             	sub    $0x14,%esp
8010260b:	8b 45 08             	mov    0x8(%ebp),%eax
8010260e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102612:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102616:	89 c2                	mov    %eax,%edx
80102618:	ec                   	in     (%dx),%al
80102619:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010261c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102620:	c9                   	leave  
80102621:	c3                   	ret    

80102622 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102622:	55                   	push   %ebp
80102623:	89 e5                	mov    %esp,%ebp
80102625:	57                   	push   %edi
80102626:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102627:	8b 55 08             	mov    0x8(%ebp),%edx
8010262a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010262d:	8b 45 10             	mov    0x10(%ebp),%eax
80102630:	89 cb                	mov    %ecx,%ebx
80102632:	89 df                	mov    %ebx,%edi
80102634:	89 c1                	mov    %eax,%ecx
80102636:	fc                   	cld    
80102637:	f3 6d                	rep insl (%dx),%es:(%edi)
80102639:	89 c8                	mov    %ecx,%eax
8010263b:	89 fb                	mov    %edi,%ebx
8010263d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102640:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102643:	90                   	nop
80102644:	5b                   	pop    %ebx
80102645:	5f                   	pop    %edi
80102646:	5d                   	pop    %ebp
80102647:	c3                   	ret    

80102648 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102648:	55                   	push   %ebp
80102649:	89 e5                	mov    %esp,%ebp
8010264b:	83 ec 08             	sub    $0x8,%esp
8010264e:	8b 55 08             	mov    0x8(%ebp),%edx
80102651:	8b 45 0c             	mov    0xc(%ebp),%eax
80102654:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102658:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010265f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102663:	ee                   	out    %al,(%dx)
}
80102664:	90                   	nop
80102665:	c9                   	leave  
80102666:	c3                   	ret    

80102667 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102667:	55                   	push   %ebp
80102668:	89 e5                	mov    %esp,%ebp
8010266a:	56                   	push   %esi
8010266b:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010266c:	8b 55 08             	mov    0x8(%ebp),%edx
8010266f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102672:	8b 45 10             	mov    0x10(%ebp),%eax
80102675:	89 cb                	mov    %ecx,%ebx
80102677:	89 de                	mov    %ebx,%esi
80102679:	89 c1                	mov    %eax,%ecx
8010267b:	fc                   	cld    
8010267c:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010267e:	89 c8                	mov    %ecx,%eax
80102680:	89 f3                	mov    %esi,%ebx
80102682:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102685:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102688:	90                   	nop
80102689:	5b                   	pop    %ebx
8010268a:	5e                   	pop    %esi
8010268b:	5d                   	pop    %ebp
8010268c:	c3                   	ret    

8010268d <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010268d:	55                   	push   %ebp
8010268e:	89 e5                	mov    %esp,%ebp
80102690:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102693:	90                   	nop
80102694:	68 f7 01 00 00       	push   $0x1f7
80102699:	e8 67 ff ff ff       	call   80102605 <inb>
8010269e:	83 c4 04             	add    $0x4,%esp
801026a1:	0f b6 c0             	movzbl %al,%eax
801026a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
801026a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026aa:	25 c0 00 00 00       	and    $0xc0,%eax
801026af:	83 f8 40             	cmp    $0x40,%eax
801026b2:	75 e0                	jne    80102694 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026b8:	74 11                	je     801026cb <idewait+0x3e>
801026ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026bd:	83 e0 21             	and    $0x21,%eax
801026c0:	85 c0                	test   %eax,%eax
801026c2:	74 07                	je     801026cb <idewait+0x3e>
    return -1;
801026c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026c9:	eb 05                	jmp    801026d0 <idewait+0x43>
  return 0;
801026cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026d0:	c9                   	leave  
801026d1:	c3                   	ret    

801026d2 <ideinit>:

void
ideinit(void)
{
801026d2:	55                   	push   %ebp
801026d3:	89 e5                	mov    %esp,%ebp
801026d5:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801026d8:	83 ec 08             	sub    $0x8,%esp
801026db:	68 9e 9b 10 80       	push   $0x80109b9e
801026e0:	68 20 d6 10 80       	push   $0x8010d620
801026e5:	e8 03 3c 00 00       	call   801062ed <initlock>
801026ea:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026ed:	83 ec 0c             	sub    $0xc,%esp
801026f0:	6a 0e                	push   $0xe
801026f2:	e8 da 18 00 00       	call   80103fd1 <picenable>
801026f7:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026fa:	a1 60 49 11 80       	mov    0x80114960,%eax
801026ff:	83 e8 01             	sub    $0x1,%eax
80102702:	83 ec 08             	sub    $0x8,%esp
80102705:	50                   	push   %eax
80102706:	6a 0e                	push   $0xe
80102708:	e8 73 04 00 00       	call   80102b80 <ioapicenable>
8010270d:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102710:	83 ec 0c             	sub    $0xc,%esp
80102713:	6a 00                	push   $0x0
80102715:	e8 73 ff ff ff       	call   8010268d <idewait>
8010271a:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010271d:	83 ec 08             	sub    $0x8,%esp
80102720:	68 f0 00 00 00       	push   $0xf0
80102725:	68 f6 01 00 00       	push   $0x1f6
8010272a:	e8 19 ff ff ff       	call   80102648 <outb>
8010272f:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102739:	eb 24                	jmp    8010275f <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010273b:	83 ec 0c             	sub    $0xc,%esp
8010273e:	68 f7 01 00 00       	push   $0x1f7
80102743:	e8 bd fe ff ff       	call   80102605 <inb>
80102748:	83 c4 10             	add    $0x10,%esp
8010274b:	84 c0                	test   %al,%al
8010274d:	74 0c                	je     8010275b <ideinit+0x89>
      havedisk1 = 1;
8010274f:	c7 05 58 d6 10 80 01 	movl   $0x1,0x8010d658
80102756:	00 00 00 
      break;
80102759:	eb 0d                	jmp    80102768 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010275b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010275f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102766:	7e d3                	jle    8010273b <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102768:	83 ec 08             	sub    $0x8,%esp
8010276b:	68 e0 00 00 00       	push   $0xe0
80102770:	68 f6 01 00 00       	push   $0x1f6
80102775:	e8 ce fe ff ff       	call   80102648 <outb>
8010277a:	83 c4 10             	add    $0x10,%esp
}
8010277d:	90                   	nop
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    

80102780 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102786:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010278a:	75 0d                	jne    80102799 <idestart+0x19>
    panic("idestart");
8010278c:	83 ec 0c             	sub    $0xc,%esp
8010278f:	68 a2 9b 10 80       	push   $0x80109ba2
80102794:	e8 cd dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102799:	8b 45 08             	mov    0x8(%ebp),%eax
8010279c:	8b 40 08             	mov    0x8(%eax),%eax
8010279f:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027a4:	76 0d                	jbe    801027b3 <idestart+0x33>
    panic("incorrect blockno");
801027a6:	83 ec 0c             	sub    $0xc,%esp
801027a9:	68 ab 9b 10 80       	push   $0x80109bab
801027ae:	e8 b3 dd ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801027b3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801027ba:	8b 45 08             	mov    0x8(%ebp),%eax
801027bd:	8b 50 08             	mov    0x8(%eax),%edx
801027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c3:	0f af c2             	imul   %edx,%eax
801027c6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801027c9:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801027cd:	7e 0d                	jle    801027dc <idestart+0x5c>
801027cf:	83 ec 0c             	sub    $0xc,%esp
801027d2:	68 a2 9b 10 80       	push   $0x80109ba2
801027d7:	e8 8a dd ff ff       	call   80100566 <panic>
  
  idewait(0);
801027dc:	83 ec 0c             	sub    $0xc,%esp
801027df:	6a 00                	push   $0x0
801027e1:	e8 a7 fe ff ff       	call   8010268d <idewait>
801027e6:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801027e9:	83 ec 08             	sub    $0x8,%esp
801027ec:	6a 00                	push   $0x0
801027ee:	68 f6 03 00 00       	push   $0x3f6
801027f3:	e8 50 fe ff ff       	call   80102648 <outb>
801027f8:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fe:	0f b6 c0             	movzbl %al,%eax
80102801:	83 ec 08             	sub    $0x8,%esp
80102804:	50                   	push   %eax
80102805:	68 f2 01 00 00       	push   $0x1f2
8010280a:	e8 39 fe ff ff       	call   80102648 <outb>
8010280f:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102812:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102815:	0f b6 c0             	movzbl %al,%eax
80102818:	83 ec 08             	sub    $0x8,%esp
8010281b:	50                   	push   %eax
8010281c:	68 f3 01 00 00       	push   $0x1f3
80102821:	e8 22 fe ff ff       	call   80102648 <outb>
80102826:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102829:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010282c:	c1 f8 08             	sar    $0x8,%eax
8010282f:	0f b6 c0             	movzbl %al,%eax
80102832:	83 ec 08             	sub    $0x8,%esp
80102835:	50                   	push   %eax
80102836:	68 f4 01 00 00       	push   $0x1f4
8010283b:	e8 08 fe ff ff       	call   80102648 <outb>
80102840:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102846:	c1 f8 10             	sar    $0x10,%eax
80102849:	0f b6 c0             	movzbl %al,%eax
8010284c:	83 ec 08             	sub    $0x8,%esp
8010284f:	50                   	push   %eax
80102850:	68 f5 01 00 00       	push   $0x1f5
80102855:	e8 ee fd ff ff       	call   80102648 <outb>
8010285a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010285d:	8b 45 08             	mov    0x8(%ebp),%eax
80102860:	8b 40 04             	mov    0x4(%eax),%eax
80102863:	83 e0 01             	and    $0x1,%eax
80102866:	c1 e0 04             	shl    $0x4,%eax
80102869:	89 c2                	mov    %eax,%edx
8010286b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010286e:	c1 f8 18             	sar    $0x18,%eax
80102871:	83 e0 0f             	and    $0xf,%eax
80102874:	09 d0                	or     %edx,%eax
80102876:	83 c8 e0             	or     $0xffffffe0,%eax
80102879:	0f b6 c0             	movzbl %al,%eax
8010287c:	83 ec 08             	sub    $0x8,%esp
8010287f:	50                   	push   %eax
80102880:	68 f6 01 00 00       	push   $0x1f6
80102885:	e8 be fd ff ff       	call   80102648 <outb>
8010288a:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010288d:	8b 45 08             	mov    0x8(%ebp),%eax
80102890:	8b 00                	mov    (%eax),%eax
80102892:	83 e0 04             	and    $0x4,%eax
80102895:	85 c0                	test   %eax,%eax
80102897:	74 30                	je     801028c9 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102899:	83 ec 08             	sub    $0x8,%esp
8010289c:	6a 30                	push   $0x30
8010289e:	68 f7 01 00 00       	push   $0x1f7
801028a3:	e8 a0 fd ff ff       	call   80102648 <outb>
801028a8:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801028ab:	8b 45 08             	mov    0x8(%ebp),%eax
801028ae:	83 c0 18             	add    $0x18,%eax
801028b1:	83 ec 04             	sub    $0x4,%esp
801028b4:	68 80 00 00 00       	push   $0x80
801028b9:	50                   	push   %eax
801028ba:	68 f0 01 00 00       	push   $0x1f0
801028bf:	e8 a3 fd ff ff       	call   80102667 <outsl>
801028c4:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
801028c7:	eb 12                	jmp    801028db <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
801028c9:	83 ec 08             	sub    $0x8,%esp
801028cc:	6a 20                	push   $0x20
801028ce:	68 f7 01 00 00       	push   $0x1f7
801028d3:	e8 70 fd ff ff       	call   80102648 <outb>
801028d8:	83 c4 10             	add    $0x10,%esp
  }
}
801028db:	90                   	nop
801028dc:	c9                   	leave  
801028dd:	c3                   	ret    

801028de <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028de:	55                   	push   %ebp
801028df:	89 e5                	mov    %esp,%ebp
801028e1:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028e4:	83 ec 0c             	sub    $0xc,%esp
801028e7:	68 20 d6 10 80       	push   $0x8010d620
801028ec:	e8 1e 3a 00 00       	call   8010630f <acquire>
801028f1:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028f4:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801028f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102900:	75 15                	jne    80102917 <ideintr+0x39>
    release(&idelock);
80102902:	83 ec 0c             	sub    $0xc,%esp
80102905:	68 20 d6 10 80       	push   $0x8010d620
8010290a:	e8 67 3a 00 00       	call   80106376 <release>
8010290f:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102912:	e9 9a 00 00 00       	jmp    801029b1 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291a:	8b 40 14             	mov    0x14(%eax),%eax
8010291d:	a3 54 d6 10 80       	mov    %eax,0x8010d654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102925:	8b 00                	mov    (%eax),%eax
80102927:	83 e0 04             	and    $0x4,%eax
8010292a:	85 c0                	test   %eax,%eax
8010292c:	75 2d                	jne    8010295b <ideintr+0x7d>
8010292e:	83 ec 0c             	sub    $0xc,%esp
80102931:	6a 01                	push   $0x1
80102933:	e8 55 fd ff ff       	call   8010268d <idewait>
80102938:	83 c4 10             	add    $0x10,%esp
8010293b:	85 c0                	test   %eax,%eax
8010293d:	78 1c                	js     8010295b <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
8010293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102942:	83 c0 18             	add    $0x18,%eax
80102945:	83 ec 04             	sub    $0x4,%esp
80102948:	68 80 00 00 00       	push   $0x80
8010294d:	50                   	push   %eax
8010294e:	68 f0 01 00 00       	push   $0x1f0
80102953:	e8 ca fc ff ff       	call   80102622 <insl>
80102958:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010295e:	8b 00                	mov    (%eax),%eax
80102960:	83 c8 02             	or     $0x2,%eax
80102963:	89 c2                	mov    %eax,%edx
80102965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102968:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296d:	8b 00                	mov    (%eax),%eax
8010296f:	83 e0 fb             	and    $0xfffffffb,%eax
80102972:	89 c2                	mov    %eax,%edx
80102974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102977:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102979:	83 ec 0c             	sub    $0xc,%esp
8010297c:	ff 75 f4             	pushl  -0xc(%ebp)
8010297f:	e8 a3 2b 00 00       	call   80105527 <wakeup>
80102984:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102987:	a1 54 d6 10 80       	mov    0x8010d654,%eax
8010298c:	85 c0                	test   %eax,%eax
8010298e:	74 11                	je     801029a1 <ideintr+0xc3>
    idestart(idequeue);
80102990:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102995:	83 ec 0c             	sub    $0xc,%esp
80102998:	50                   	push   %eax
80102999:	e8 e2 fd ff ff       	call   80102780 <idestart>
8010299e:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801029a1:	83 ec 0c             	sub    $0xc,%esp
801029a4:	68 20 d6 10 80       	push   $0x8010d620
801029a9:	e8 c8 39 00 00       	call   80106376 <release>
801029ae:	83 c4 10             	add    $0x10,%esp
}
801029b1:	c9                   	leave  
801029b2:	c3                   	ret    

801029b3 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029b3:	55                   	push   %ebp
801029b4:	89 e5                	mov    %esp,%ebp
801029b6:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801029b9:	8b 45 08             	mov    0x8(%ebp),%eax
801029bc:	8b 00                	mov    (%eax),%eax
801029be:	83 e0 01             	and    $0x1,%eax
801029c1:	85 c0                	test   %eax,%eax
801029c3:	75 0d                	jne    801029d2 <iderw+0x1f>
    panic("iderw: buf not busy");
801029c5:	83 ec 0c             	sub    $0xc,%esp
801029c8:	68 bd 9b 10 80       	push   $0x80109bbd
801029cd:	e8 94 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029d2:	8b 45 08             	mov    0x8(%ebp),%eax
801029d5:	8b 00                	mov    (%eax),%eax
801029d7:	83 e0 06             	and    $0x6,%eax
801029da:	83 f8 02             	cmp    $0x2,%eax
801029dd:	75 0d                	jne    801029ec <iderw+0x39>
    panic("iderw: nothing to do");
801029df:	83 ec 0c             	sub    $0xc,%esp
801029e2:	68 d1 9b 10 80       	push   $0x80109bd1
801029e7:	e8 7a db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801029ec:	8b 45 08             	mov    0x8(%ebp),%eax
801029ef:	8b 40 04             	mov    0x4(%eax),%eax
801029f2:	85 c0                	test   %eax,%eax
801029f4:	74 16                	je     80102a0c <iderw+0x59>
801029f6:	a1 58 d6 10 80       	mov    0x8010d658,%eax
801029fb:	85 c0                	test   %eax,%eax
801029fd:	75 0d                	jne    80102a0c <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801029ff:	83 ec 0c             	sub    $0xc,%esp
80102a02:	68 e6 9b 10 80       	push   $0x80109be6
80102a07:	e8 5a db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a0c:	83 ec 0c             	sub    $0xc,%esp
80102a0f:	68 20 d6 10 80       	push   $0x8010d620
80102a14:	e8 f6 38 00 00       	call   8010630f <acquire>
80102a19:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a26:	c7 45 f4 54 d6 10 80 	movl   $0x8010d654,-0xc(%ebp)
80102a2d:	eb 0b                	jmp    80102a3a <iderw+0x87>
80102a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a32:	8b 00                	mov    (%eax),%eax
80102a34:	83 c0 14             	add    $0x14,%eax
80102a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3d:	8b 00                	mov    (%eax),%eax
80102a3f:	85 c0                	test   %eax,%eax
80102a41:	75 ec                	jne    80102a2f <iderw+0x7c>
    ;
  *pp = b;
80102a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a46:	8b 55 08             	mov    0x8(%ebp),%edx
80102a49:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102a4b:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102a50:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a53:	75 23                	jne    80102a78 <iderw+0xc5>
    idestart(b);
80102a55:	83 ec 0c             	sub    $0xc,%esp
80102a58:	ff 75 08             	pushl  0x8(%ebp)
80102a5b:	e8 20 fd ff ff       	call   80102780 <idestart>
80102a60:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a63:	eb 13                	jmp    80102a78 <iderw+0xc5>
    sleep(b, &idelock);
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	68 20 d6 10 80       	push   $0x8010d620
80102a6d:	ff 75 08             	pushl  0x8(%ebp)
80102a70:	e8 57 29 00 00       	call   801053cc <sleep>
80102a75:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a78:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7b:	8b 00                	mov    (%eax),%eax
80102a7d:	83 e0 06             	and    $0x6,%eax
80102a80:	83 f8 02             	cmp    $0x2,%eax
80102a83:	75 e0                	jne    80102a65 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a85:	83 ec 0c             	sub    $0xc,%esp
80102a88:	68 20 d6 10 80       	push   $0x8010d620
80102a8d:	e8 e4 38 00 00       	call   80106376 <release>
80102a92:	83 c4 10             	add    $0x10,%esp
}
80102a95:	90                   	nop
80102a96:	c9                   	leave  
80102a97:	c3                   	ret    

80102a98 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a98:	55                   	push   %ebp
80102a99:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a9b:	a1 34 42 11 80       	mov    0x80114234,%eax
80102aa0:	8b 55 08             	mov    0x8(%ebp),%edx
80102aa3:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102aa5:	a1 34 42 11 80       	mov    0x80114234,%eax
80102aaa:	8b 40 10             	mov    0x10(%eax),%eax
}
80102aad:	5d                   	pop    %ebp
80102aae:	c3                   	ret    

80102aaf <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102aaf:	55                   	push   %ebp
80102ab0:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102ab2:	a1 34 42 11 80       	mov    0x80114234,%eax
80102ab7:	8b 55 08             	mov    0x8(%ebp),%edx
80102aba:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102abc:	a1 34 42 11 80       	mov    0x80114234,%eax
80102ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
80102ac4:	89 50 10             	mov    %edx,0x10(%eax)
}
80102ac7:	90                   	nop
80102ac8:	5d                   	pop    %ebp
80102ac9:	c3                   	ret    

80102aca <ioapicinit>:

void
ioapicinit(void)
{
80102aca:	55                   	push   %ebp
80102acb:	89 e5                	mov    %esp,%ebp
80102acd:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102ad0:	a1 64 43 11 80       	mov    0x80114364,%eax
80102ad5:	85 c0                	test   %eax,%eax
80102ad7:	0f 84 a0 00 00 00    	je     80102b7d <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102add:	c7 05 34 42 11 80 00 	movl   $0xfec00000,0x80114234
80102ae4:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102ae7:	6a 01                	push   $0x1
80102ae9:	e8 aa ff ff ff       	call   80102a98 <ioapicread>
80102aee:	83 c4 04             	add    $0x4,%esp
80102af1:	c1 e8 10             	shr    $0x10,%eax
80102af4:	25 ff 00 00 00       	and    $0xff,%eax
80102af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102afc:	6a 00                	push   $0x0
80102afe:	e8 95 ff ff ff       	call   80102a98 <ioapicread>
80102b03:	83 c4 04             	add    $0x4,%esp
80102b06:	c1 e8 18             	shr    $0x18,%eax
80102b09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102b0c:	0f b6 05 60 43 11 80 	movzbl 0x80114360,%eax
80102b13:	0f b6 c0             	movzbl %al,%eax
80102b16:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b19:	74 10                	je     80102b2b <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b1b:	83 ec 0c             	sub    $0xc,%esp
80102b1e:	68 04 9c 10 80       	push   $0x80109c04
80102b23:	e8 9e d8 ff ff       	call   801003c6 <cprintf>
80102b28:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b32:	eb 3f                	jmp    80102b73 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b37:	83 c0 20             	add    $0x20,%eax
80102b3a:	0d 00 00 01 00       	or     $0x10000,%eax
80102b3f:	89 c2                	mov    %eax,%edx
80102b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b44:	83 c0 08             	add    $0x8,%eax
80102b47:	01 c0                	add    %eax,%eax
80102b49:	83 ec 08             	sub    $0x8,%esp
80102b4c:	52                   	push   %edx
80102b4d:	50                   	push   %eax
80102b4e:	e8 5c ff ff ff       	call   80102aaf <ioapicwrite>
80102b53:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b59:	83 c0 08             	add    $0x8,%eax
80102b5c:	01 c0                	add    %eax,%eax
80102b5e:	83 c0 01             	add    $0x1,%eax
80102b61:	83 ec 08             	sub    $0x8,%esp
80102b64:	6a 00                	push   $0x0
80102b66:	50                   	push   %eax
80102b67:	e8 43 ff ff ff       	call   80102aaf <ioapicwrite>
80102b6c:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b76:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b79:	7e b9                	jle    80102b34 <ioapicinit+0x6a>
80102b7b:	eb 01                	jmp    80102b7e <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102b7d:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b7e:	c9                   	leave  
80102b7f:	c3                   	ret    

80102b80 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b83:	a1 64 43 11 80       	mov    0x80114364,%eax
80102b88:	85 c0                	test   %eax,%eax
80102b8a:	74 39                	je     80102bc5 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b8f:	83 c0 20             	add    $0x20,%eax
80102b92:	89 c2                	mov    %eax,%edx
80102b94:	8b 45 08             	mov    0x8(%ebp),%eax
80102b97:	83 c0 08             	add    $0x8,%eax
80102b9a:	01 c0                	add    %eax,%eax
80102b9c:	52                   	push   %edx
80102b9d:	50                   	push   %eax
80102b9e:	e8 0c ff ff ff       	call   80102aaf <ioapicwrite>
80102ba3:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ba9:	c1 e0 18             	shl    $0x18,%eax
80102bac:	89 c2                	mov    %eax,%edx
80102bae:	8b 45 08             	mov    0x8(%ebp),%eax
80102bb1:	83 c0 08             	add    $0x8,%eax
80102bb4:	01 c0                	add    %eax,%eax
80102bb6:	83 c0 01             	add    $0x1,%eax
80102bb9:	52                   	push   %edx
80102bba:	50                   	push   %eax
80102bbb:	e8 ef fe ff ff       	call   80102aaf <ioapicwrite>
80102bc0:	83 c4 08             	add    $0x8,%esp
80102bc3:	eb 01                	jmp    80102bc6 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102bc5:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102bc6:	c9                   	leave  
80102bc7:	c3                   	ret    

80102bc8 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102bc8:	55                   	push   %ebp
80102bc9:	89 e5                	mov    %esp,%ebp
80102bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80102bce:	05 00 00 00 80       	add    $0x80000000,%eax
80102bd3:	5d                   	pop    %ebp
80102bd4:	c3                   	ret    

80102bd5 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102bd5:	55                   	push   %ebp
80102bd6:	89 e5                	mov    %esp,%ebp
80102bd8:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102bdb:	83 ec 08             	sub    $0x8,%esp
80102bde:	68 36 9c 10 80       	push   $0x80109c36
80102be3:	68 40 42 11 80       	push   $0x80114240
80102be8:	e8 00 37 00 00       	call   801062ed <initlock>
80102bed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102bf0:	c7 05 74 42 11 80 00 	movl   $0x0,0x80114274
80102bf7:	00 00 00 
  freerange(vstart, vend);
80102bfa:	83 ec 08             	sub    $0x8,%esp
80102bfd:	ff 75 0c             	pushl  0xc(%ebp)
80102c00:	ff 75 08             	pushl  0x8(%ebp)
80102c03:	e8 2a 00 00 00       	call   80102c32 <freerange>
80102c08:	83 c4 10             	add    $0x10,%esp
}
80102c0b:	90                   	nop
80102c0c:	c9                   	leave  
80102c0d:	c3                   	ret    

80102c0e <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102c0e:	55                   	push   %ebp
80102c0f:	89 e5                	mov    %esp,%ebp
80102c11:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102c14:	83 ec 08             	sub    $0x8,%esp
80102c17:	ff 75 0c             	pushl  0xc(%ebp)
80102c1a:	ff 75 08             	pushl  0x8(%ebp)
80102c1d:	e8 10 00 00 00       	call   80102c32 <freerange>
80102c22:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102c25:	c7 05 74 42 11 80 01 	movl   $0x1,0x80114274
80102c2c:	00 00 00 
}
80102c2f:	90                   	nop
80102c30:	c9                   	leave  
80102c31:	c3                   	ret    

80102c32 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102c32:	55                   	push   %ebp
80102c33:	89 e5                	mov    %esp,%ebp
80102c35:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c38:	8b 45 08             	mov    0x8(%ebp),%eax
80102c3b:	05 ff 0f 00 00       	add    $0xfff,%eax
80102c40:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c48:	eb 15                	jmp    80102c5f <freerange+0x2d>
    kfree(p);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
80102c4d:	ff 75 f4             	pushl  -0xc(%ebp)
80102c50:	e8 1a 00 00 00       	call   80102c6f <kfree>
80102c55:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c58:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c62:	05 00 10 00 00       	add    $0x1000,%eax
80102c67:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c6a:	76 de                	jbe    80102c4a <freerange+0x18>
    kfree(p);
}
80102c6c:	90                   	nop
80102c6d:	c9                   	leave  
80102c6e:	c3                   	ret    

80102c6f <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c6f:	55                   	push   %ebp
80102c70:	89 e5                	mov    %esp,%ebp
80102c72:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102c75:	8b 45 08             	mov    0x8(%ebp),%eax
80102c78:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c7d:	85 c0                	test   %eax,%eax
80102c7f:	75 1b                	jne    80102c9c <kfree+0x2d>
80102c81:	81 7d 08 3c 79 11 80 	cmpl   $0x8011793c,0x8(%ebp)
80102c88:	72 12                	jb     80102c9c <kfree+0x2d>
80102c8a:	ff 75 08             	pushl  0x8(%ebp)
80102c8d:	e8 36 ff ff ff       	call   80102bc8 <v2p>
80102c92:	83 c4 04             	add    $0x4,%esp
80102c95:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c9a:	76 0d                	jbe    80102ca9 <kfree+0x3a>
    panic("kfree");
80102c9c:	83 ec 0c             	sub    $0xc,%esp
80102c9f:	68 3b 9c 10 80       	push   $0x80109c3b
80102ca4:	e8 bd d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ca9:	83 ec 04             	sub    $0x4,%esp
80102cac:	68 00 10 00 00       	push   $0x1000
80102cb1:	6a 01                	push   $0x1
80102cb3:	ff 75 08             	pushl  0x8(%ebp)
80102cb6:	e8 b7 38 00 00       	call   80106572 <memset>
80102cbb:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cbe:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cc3:	85 c0                	test   %eax,%eax
80102cc5:	74 10                	je     80102cd7 <kfree+0x68>
    acquire(&kmem.lock);
80102cc7:	83 ec 0c             	sub    $0xc,%esp
80102cca:	68 40 42 11 80       	push   $0x80114240
80102ccf:	e8 3b 36 00 00       	call   8010630f <acquire>
80102cd4:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80102cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102cdd:	8b 15 78 42 11 80    	mov    0x80114278,%edx
80102ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce6:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ceb:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102cf0:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cf5:	85 c0                	test   %eax,%eax
80102cf7:	74 10                	je     80102d09 <kfree+0x9a>
    release(&kmem.lock);
80102cf9:	83 ec 0c             	sub    $0xc,%esp
80102cfc:	68 40 42 11 80       	push   $0x80114240
80102d01:	e8 70 36 00 00       	call   80106376 <release>
80102d06:	83 c4 10             	add    $0x10,%esp
}
80102d09:	90                   	nop
80102d0a:	c9                   	leave  
80102d0b:	c3                   	ret    

80102d0c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d0c:	55                   	push   %ebp
80102d0d:	89 e5                	mov    %esp,%ebp
80102d0f:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102d12:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d17:	85 c0                	test   %eax,%eax
80102d19:	74 10                	je     80102d2b <kalloc+0x1f>
    acquire(&kmem.lock);
80102d1b:	83 ec 0c             	sub    $0xc,%esp
80102d1e:	68 40 42 11 80       	push   $0x80114240
80102d23:	e8 e7 35 00 00       	call   8010630f <acquire>
80102d28:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d2b:	a1 78 42 11 80       	mov    0x80114278,%eax
80102d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d37:	74 0a                	je     80102d43 <kalloc+0x37>
    kmem.freelist = r->next;
80102d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d3c:	8b 00                	mov    (%eax),%eax
80102d3e:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102d43:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d48:	85 c0                	test   %eax,%eax
80102d4a:	74 10                	je     80102d5c <kalloc+0x50>
    release(&kmem.lock);
80102d4c:	83 ec 0c             	sub    $0xc,%esp
80102d4f:	68 40 42 11 80       	push   $0x80114240
80102d54:	e8 1d 36 00 00       	call   80106376 <release>
80102d59:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d5f:	c9                   	leave  
80102d60:	c3                   	ret    

80102d61 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102d61:	55                   	push   %ebp
80102d62:	89 e5                	mov    %esp,%ebp
80102d64:	83 ec 14             	sub    $0x14,%esp
80102d67:	8b 45 08             	mov    0x8(%ebp),%eax
80102d6a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d6e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d72:	89 c2                	mov    %eax,%edx
80102d74:	ec                   	in     (%dx),%al
80102d75:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d78:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d7c:	c9                   	leave  
80102d7d:	c3                   	ret    

80102d7e <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d7e:	55                   	push   %ebp
80102d7f:	89 e5                	mov    %esp,%ebp
80102d81:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d84:	6a 64                	push   $0x64
80102d86:	e8 d6 ff ff ff       	call   80102d61 <inb>
80102d8b:	83 c4 04             	add    $0x4,%esp
80102d8e:	0f b6 c0             	movzbl %al,%eax
80102d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d97:	83 e0 01             	and    $0x1,%eax
80102d9a:	85 c0                	test   %eax,%eax
80102d9c:	75 0a                	jne    80102da8 <kbdgetc+0x2a>
    return -1;
80102d9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102da3:	e9 23 01 00 00       	jmp    80102ecb <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102da8:	6a 60                	push   $0x60
80102daa:	e8 b2 ff ff ff       	call   80102d61 <inb>
80102daf:	83 c4 04             	add    $0x4,%esp
80102db2:	0f b6 c0             	movzbl %al,%eax
80102db5:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102db8:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102dbf:	75 17                	jne    80102dd8 <kbdgetc+0x5a>
    shift |= E0ESC;
80102dc1:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102dc6:	83 c8 40             	or     $0x40,%eax
80102dc9:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102dce:	b8 00 00 00 00       	mov    $0x0,%eax
80102dd3:	e9 f3 00 00 00       	jmp    80102ecb <kbdgetc+0x14d>
  } else if(data & 0x80){
80102dd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ddb:	25 80 00 00 00       	and    $0x80,%eax
80102de0:	85 c0                	test   %eax,%eax
80102de2:	74 45                	je     80102e29 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102de4:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102de9:	83 e0 40             	and    $0x40,%eax
80102dec:	85 c0                	test   %eax,%eax
80102dee:	75 08                	jne    80102df8 <kbdgetc+0x7a>
80102df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df3:	83 e0 7f             	and    $0x7f,%eax
80102df6:	eb 03                	jmp    80102dfb <kbdgetc+0x7d>
80102df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102dfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e01:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e06:	0f b6 00             	movzbl (%eax),%eax
80102e09:	83 c8 40             	or     $0x40,%eax
80102e0c:	0f b6 c0             	movzbl %al,%eax
80102e0f:	f7 d0                	not    %eax
80102e11:	89 c2                	mov    %eax,%edx
80102e13:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e18:	21 d0                	and    %edx,%eax
80102e1a:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102e1f:	b8 00 00 00 00       	mov    $0x0,%eax
80102e24:	e9 a2 00 00 00       	jmp    80102ecb <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e29:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e2e:	83 e0 40             	and    $0x40,%eax
80102e31:	85 c0                	test   %eax,%eax
80102e33:	74 14                	je     80102e49 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e35:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e3c:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e41:	83 e0 bf             	and    $0xffffffbf,%eax
80102e44:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  }

  shift |= shiftcode[data];
80102e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e4c:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e51:	0f b6 00             	movzbl (%eax),%eax
80102e54:	0f b6 d0             	movzbl %al,%edx
80102e57:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e5c:	09 d0                	or     %edx,%eax
80102e5e:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  shift ^= togglecode[data];
80102e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e66:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102e6b:	0f b6 00             	movzbl (%eax),%eax
80102e6e:	0f b6 d0             	movzbl %al,%edx
80102e71:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e76:	31 d0                	xor    %edx,%eax
80102e78:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e7d:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e82:	83 e0 03             	and    $0x3,%eax
80102e85:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e8f:	01 d0                	add    %edx,%eax
80102e91:	0f b6 00             	movzbl (%eax),%eax
80102e94:	0f b6 c0             	movzbl %al,%eax
80102e97:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e9a:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e9f:	83 e0 08             	and    $0x8,%eax
80102ea2:	85 c0                	test   %eax,%eax
80102ea4:	74 22                	je     80102ec8 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102ea6:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102eaa:	76 0c                	jbe    80102eb8 <kbdgetc+0x13a>
80102eac:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102eb0:	77 06                	ja     80102eb8 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102eb2:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102eb6:	eb 10                	jmp    80102ec8 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102eb8:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102ebc:	76 0a                	jbe    80102ec8 <kbdgetc+0x14a>
80102ebe:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102ec2:	77 04                	ja     80102ec8 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102ec4:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ec8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ecb:	c9                   	leave  
80102ecc:	c3                   	ret    

80102ecd <kbdintr>:

void
kbdintr(void)
{
80102ecd:	55                   	push   %ebp
80102ece:	89 e5                	mov    %esp,%ebp
80102ed0:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ed3:	83 ec 0c             	sub    $0xc,%esp
80102ed6:	68 7e 2d 10 80       	push   $0x80102d7e
80102edb:	e8 19 d9 ff ff       	call   801007f9 <consoleintr>
80102ee0:	83 c4 10             	add    $0x10,%esp
}
80102ee3:	90                   	nop
80102ee4:	c9                   	leave  
80102ee5:	c3                   	ret    

80102ee6 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102ee6:	55                   	push   %ebp
80102ee7:	89 e5                	mov    %esp,%ebp
80102ee9:	83 ec 14             	sub    $0x14,%esp
80102eec:	8b 45 08             	mov    0x8(%ebp),%eax
80102eef:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ef7:	89 c2                	mov    %eax,%edx
80102ef9:	ec                   	in     (%dx),%al
80102efa:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102efd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102f01:	c9                   	leave  
80102f02:	c3                   	ret    

80102f03 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102f03:	55                   	push   %ebp
80102f04:	89 e5                	mov    %esp,%ebp
80102f06:	83 ec 08             	sub    $0x8,%esp
80102f09:	8b 55 08             	mov    0x8(%ebp),%edx
80102f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f0f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102f13:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f16:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102f1a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102f1e:	ee                   	out    %al,(%dx)
}
80102f1f:	90                   	nop
80102f20:	c9                   	leave  
80102f21:	c3                   	ret    

80102f22 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102f22:	55                   	push   %ebp
80102f23:	89 e5                	mov    %esp,%ebp
80102f25:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102f28:	9c                   	pushf  
80102f29:	58                   	pop    %eax
80102f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102f30:	c9                   	leave  
80102f31:	c3                   	ret    

80102f32 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102f32:	55                   	push   %ebp
80102f33:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102f35:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f3a:	8b 55 08             	mov    0x8(%ebp),%edx
80102f3d:	c1 e2 02             	shl    $0x2,%edx
80102f40:	01 c2                	add    %eax,%edx
80102f42:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f45:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f47:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f4c:	83 c0 20             	add    $0x20,%eax
80102f4f:	8b 00                	mov    (%eax),%eax
}
80102f51:	90                   	nop
80102f52:	5d                   	pop    %ebp
80102f53:	c3                   	ret    

80102f54 <lapicinit>:

void
lapicinit(void)
{
80102f54:	55                   	push   %ebp
80102f55:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102f57:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f5c:	85 c0                	test   %eax,%eax
80102f5e:	0f 84 0b 01 00 00    	je     8010306f <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f64:	68 3f 01 00 00       	push   $0x13f
80102f69:	6a 3c                	push   $0x3c
80102f6b:	e8 c2 ff ff ff       	call   80102f32 <lapicw>
80102f70:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f73:	6a 0b                	push   $0xb
80102f75:	68 f8 00 00 00       	push   $0xf8
80102f7a:	e8 b3 ff ff ff       	call   80102f32 <lapicw>
80102f7f:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f82:	68 20 00 02 00       	push   $0x20020
80102f87:	68 c8 00 00 00       	push   $0xc8
80102f8c:	e8 a1 ff ff ff       	call   80102f32 <lapicw>
80102f91:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102f94:	68 80 96 98 00       	push   $0x989680
80102f99:	68 e0 00 00 00       	push   $0xe0
80102f9e:	e8 8f ff ff ff       	call   80102f32 <lapicw>
80102fa3:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102fa6:	68 00 00 01 00       	push   $0x10000
80102fab:	68 d4 00 00 00       	push   $0xd4
80102fb0:	e8 7d ff ff ff       	call   80102f32 <lapicw>
80102fb5:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102fb8:	68 00 00 01 00       	push   $0x10000
80102fbd:	68 d8 00 00 00       	push   $0xd8
80102fc2:	e8 6b ff ff ff       	call   80102f32 <lapicw>
80102fc7:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102fca:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102fcf:	83 c0 30             	add    $0x30,%eax
80102fd2:	8b 00                	mov    (%eax),%eax
80102fd4:	c1 e8 10             	shr    $0x10,%eax
80102fd7:	0f b6 c0             	movzbl %al,%eax
80102fda:	83 f8 03             	cmp    $0x3,%eax
80102fdd:	76 12                	jbe    80102ff1 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102fdf:	68 00 00 01 00       	push   $0x10000
80102fe4:	68 d0 00 00 00       	push   $0xd0
80102fe9:	e8 44 ff ff ff       	call   80102f32 <lapicw>
80102fee:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ff1:	6a 33                	push   $0x33
80102ff3:	68 dc 00 00 00       	push   $0xdc
80102ff8:	e8 35 ff ff ff       	call   80102f32 <lapicw>
80102ffd:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103000:	6a 00                	push   $0x0
80103002:	68 a0 00 00 00       	push   $0xa0
80103007:	e8 26 ff ff ff       	call   80102f32 <lapicw>
8010300c:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
8010300f:	6a 00                	push   $0x0
80103011:	68 a0 00 00 00       	push   $0xa0
80103016:	e8 17 ff ff ff       	call   80102f32 <lapicw>
8010301b:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
8010301e:	6a 00                	push   $0x0
80103020:	6a 2c                	push   $0x2c
80103022:	e8 0b ff ff ff       	call   80102f32 <lapicw>
80103027:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010302a:	6a 00                	push   $0x0
8010302c:	68 c4 00 00 00       	push   $0xc4
80103031:	e8 fc fe ff ff       	call   80102f32 <lapicw>
80103036:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103039:	68 00 85 08 00       	push   $0x88500
8010303e:	68 c0 00 00 00       	push   $0xc0
80103043:	e8 ea fe ff ff       	call   80102f32 <lapicw>
80103048:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
8010304b:	90                   	nop
8010304c:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80103051:	05 00 03 00 00       	add    $0x300,%eax
80103056:	8b 00                	mov    (%eax),%eax
80103058:	25 00 10 00 00       	and    $0x1000,%eax
8010305d:	85 c0                	test   %eax,%eax
8010305f:	75 eb                	jne    8010304c <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103061:	6a 00                	push   $0x0
80103063:	6a 20                	push   $0x20
80103065:	e8 c8 fe ff ff       	call   80102f32 <lapicw>
8010306a:	83 c4 08             	add    $0x8,%esp
8010306d:	eb 01                	jmp    80103070 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
8010306f:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103070:	c9                   	leave  
80103071:	c3                   	ret    

80103072 <cpunum>:

int
cpunum(void)
{
80103072:	55                   	push   %ebp
80103073:	89 e5                	mov    %esp,%ebp
80103075:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103078:	e8 a5 fe ff ff       	call   80102f22 <readeflags>
8010307d:	25 00 02 00 00       	and    $0x200,%eax
80103082:	85 c0                	test   %eax,%eax
80103084:	74 26                	je     801030ac <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80103086:	a1 60 d6 10 80       	mov    0x8010d660,%eax
8010308b:	8d 50 01             	lea    0x1(%eax),%edx
8010308e:	89 15 60 d6 10 80    	mov    %edx,0x8010d660
80103094:	85 c0                	test   %eax,%eax
80103096:	75 14                	jne    801030ac <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103098:	8b 45 04             	mov    0x4(%ebp),%eax
8010309b:	83 ec 08             	sub    $0x8,%esp
8010309e:	50                   	push   %eax
8010309f:	68 44 9c 10 80       	push   $0x80109c44
801030a4:	e8 1d d3 ff ff       	call   801003c6 <cprintf>
801030a9:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801030ac:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030b1:	85 c0                	test   %eax,%eax
801030b3:	74 0f                	je     801030c4 <cpunum+0x52>
    return lapic[ID]>>24;
801030b5:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030ba:	83 c0 20             	add    $0x20,%eax
801030bd:	8b 00                	mov    (%eax),%eax
801030bf:	c1 e8 18             	shr    $0x18,%eax
801030c2:	eb 05                	jmp    801030c9 <cpunum+0x57>
  return 0;
801030c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801030c9:	c9                   	leave  
801030ca:	c3                   	ret    

801030cb <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801030cb:	55                   	push   %ebp
801030cc:	89 e5                	mov    %esp,%ebp
  if(lapic)
801030ce:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030d3:	85 c0                	test   %eax,%eax
801030d5:	74 0c                	je     801030e3 <lapiceoi+0x18>
    lapicw(EOI, 0);
801030d7:	6a 00                	push   $0x0
801030d9:	6a 2c                	push   $0x2c
801030db:	e8 52 fe ff ff       	call   80102f32 <lapicw>
801030e0:	83 c4 08             	add    $0x8,%esp
}
801030e3:	90                   	nop
801030e4:	c9                   	leave  
801030e5:	c3                   	ret    

801030e6 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801030e6:	55                   	push   %ebp
801030e7:	89 e5                	mov    %esp,%ebp
}
801030e9:	90                   	nop
801030ea:	5d                   	pop    %ebp
801030eb:	c3                   	ret    

801030ec <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030ec:	55                   	push   %ebp
801030ed:	89 e5                	mov    %esp,%ebp
801030ef:	83 ec 14             	sub    $0x14,%esp
801030f2:	8b 45 08             	mov    0x8(%ebp),%eax
801030f5:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801030f8:	6a 0f                	push   $0xf
801030fa:	6a 70                	push   $0x70
801030fc:	e8 02 fe ff ff       	call   80102f03 <outb>
80103101:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103104:	6a 0a                	push   $0xa
80103106:	6a 71                	push   $0x71
80103108:	e8 f6 fd ff ff       	call   80102f03 <outb>
8010310d:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103110:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103117:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010311a:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010311f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103122:	83 c0 02             	add    $0x2,%eax
80103125:	8b 55 0c             	mov    0xc(%ebp),%edx
80103128:	c1 ea 04             	shr    $0x4,%edx
8010312b:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010312e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103132:	c1 e0 18             	shl    $0x18,%eax
80103135:	50                   	push   %eax
80103136:	68 c4 00 00 00       	push   $0xc4
8010313b:	e8 f2 fd ff ff       	call   80102f32 <lapicw>
80103140:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103143:	68 00 c5 00 00       	push   $0xc500
80103148:	68 c0 00 00 00       	push   $0xc0
8010314d:	e8 e0 fd ff ff       	call   80102f32 <lapicw>
80103152:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103155:	68 c8 00 00 00       	push   $0xc8
8010315a:	e8 87 ff ff ff       	call   801030e6 <microdelay>
8010315f:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103162:	68 00 85 00 00       	push   $0x8500
80103167:	68 c0 00 00 00       	push   $0xc0
8010316c:	e8 c1 fd ff ff       	call   80102f32 <lapicw>
80103171:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103174:	6a 64                	push   $0x64
80103176:	e8 6b ff ff ff       	call   801030e6 <microdelay>
8010317b:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010317e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103185:	eb 3d                	jmp    801031c4 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103187:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010318b:	c1 e0 18             	shl    $0x18,%eax
8010318e:	50                   	push   %eax
8010318f:	68 c4 00 00 00       	push   $0xc4
80103194:	e8 99 fd ff ff       	call   80102f32 <lapicw>
80103199:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010319c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010319f:	c1 e8 0c             	shr    $0xc,%eax
801031a2:	80 cc 06             	or     $0x6,%ah
801031a5:	50                   	push   %eax
801031a6:	68 c0 00 00 00       	push   $0xc0
801031ab:	e8 82 fd ff ff       	call   80102f32 <lapicw>
801031b0:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801031b3:	68 c8 00 00 00       	push   $0xc8
801031b8:	e8 29 ff ff ff       	call   801030e6 <microdelay>
801031bd:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801031c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801031c4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801031c8:	7e bd                	jle    80103187 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801031ca:	90                   	nop
801031cb:	c9                   	leave  
801031cc:	c3                   	ret    

801031cd <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801031cd:	55                   	push   %ebp
801031ce:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801031d0:	8b 45 08             	mov    0x8(%ebp),%eax
801031d3:	0f b6 c0             	movzbl %al,%eax
801031d6:	50                   	push   %eax
801031d7:	6a 70                	push   $0x70
801031d9:	e8 25 fd ff ff       	call   80102f03 <outb>
801031de:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031e1:	68 c8 00 00 00       	push   $0xc8
801031e6:	e8 fb fe ff ff       	call   801030e6 <microdelay>
801031eb:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801031ee:	6a 71                	push   $0x71
801031f0:	e8 f1 fc ff ff       	call   80102ee6 <inb>
801031f5:	83 c4 04             	add    $0x4,%esp
801031f8:	0f b6 c0             	movzbl %al,%eax
}
801031fb:	c9                   	leave  
801031fc:	c3                   	ret    

801031fd <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801031fd:	55                   	push   %ebp
801031fe:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103200:	6a 00                	push   $0x0
80103202:	e8 c6 ff ff ff       	call   801031cd <cmos_read>
80103207:	83 c4 04             	add    $0x4,%esp
8010320a:	89 c2                	mov    %eax,%edx
8010320c:	8b 45 08             	mov    0x8(%ebp),%eax
8010320f:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103211:	6a 02                	push   $0x2
80103213:	e8 b5 ff ff ff       	call   801031cd <cmos_read>
80103218:	83 c4 04             	add    $0x4,%esp
8010321b:	89 c2                	mov    %eax,%edx
8010321d:	8b 45 08             	mov    0x8(%ebp),%eax
80103220:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103223:	6a 04                	push   $0x4
80103225:	e8 a3 ff ff ff       	call   801031cd <cmos_read>
8010322a:	83 c4 04             	add    $0x4,%esp
8010322d:	89 c2                	mov    %eax,%edx
8010322f:	8b 45 08             	mov    0x8(%ebp),%eax
80103232:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103235:	6a 07                	push   $0x7
80103237:	e8 91 ff ff ff       	call   801031cd <cmos_read>
8010323c:	83 c4 04             	add    $0x4,%esp
8010323f:	89 c2                	mov    %eax,%edx
80103241:	8b 45 08             	mov    0x8(%ebp),%eax
80103244:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103247:	6a 08                	push   $0x8
80103249:	e8 7f ff ff ff       	call   801031cd <cmos_read>
8010324e:	83 c4 04             	add    $0x4,%esp
80103251:	89 c2                	mov    %eax,%edx
80103253:	8b 45 08             	mov    0x8(%ebp),%eax
80103256:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103259:	6a 09                	push   $0x9
8010325b:	e8 6d ff ff ff       	call   801031cd <cmos_read>
80103260:	83 c4 04             	add    $0x4,%esp
80103263:	89 c2                	mov    %eax,%edx
80103265:	8b 45 08             	mov    0x8(%ebp),%eax
80103268:	89 50 14             	mov    %edx,0x14(%eax)
}
8010326b:	90                   	nop
8010326c:	c9                   	leave  
8010326d:	c3                   	ret    

8010326e <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010326e:	55                   	push   %ebp
8010326f:	89 e5                	mov    %esp,%ebp
80103271:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103274:	6a 0b                	push   $0xb
80103276:	e8 52 ff ff ff       	call   801031cd <cmos_read>
8010327b:	83 c4 04             	add    $0x4,%esp
8010327e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103284:	83 e0 04             	and    $0x4,%eax
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 94 c0             	sete   %al
8010328c:	0f b6 c0             	movzbl %al,%eax
8010328f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103292:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103295:	50                   	push   %eax
80103296:	e8 62 ff ff ff       	call   801031fd <fill_rtcdate>
8010329b:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010329e:	6a 0a                	push   $0xa
801032a0:	e8 28 ff ff ff       	call   801031cd <cmos_read>
801032a5:	83 c4 04             	add    $0x4,%esp
801032a8:	25 80 00 00 00       	and    $0x80,%eax
801032ad:	85 c0                	test   %eax,%eax
801032af:	75 27                	jne    801032d8 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801032b1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032b4:	50                   	push   %eax
801032b5:	e8 43 ff ff ff       	call   801031fd <fill_rtcdate>
801032ba:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801032bd:	83 ec 04             	sub    $0x4,%esp
801032c0:	6a 18                	push   $0x18
801032c2:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032c5:	50                   	push   %eax
801032c6:	8d 45 d8             	lea    -0x28(%ebp),%eax
801032c9:	50                   	push   %eax
801032ca:	e8 0a 33 00 00       	call   801065d9 <memcmp>
801032cf:	83 c4 10             	add    $0x10,%esp
801032d2:	85 c0                	test   %eax,%eax
801032d4:	74 05                	je     801032db <cmostime+0x6d>
801032d6:	eb ba                	jmp    80103292 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801032d8:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801032d9:	eb b7                	jmp    80103292 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801032db:	90                   	nop
  }

  // convert
  if (bcd) {
801032dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801032e0:	0f 84 b4 00 00 00    	je     8010339a <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032e9:	c1 e8 04             	shr    $0x4,%eax
801032ec:	89 c2                	mov    %eax,%edx
801032ee:	89 d0                	mov    %edx,%eax
801032f0:	c1 e0 02             	shl    $0x2,%eax
801032f3:	01 d0                	add    %edx,%eax
801032f5:	01 c0                	add    %eax,%eax
801032f7:	89 c2                	mov    %eax,%edx
801032f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032fc:	83 e0 0f             	and    $0xf,%eax
801032ff:	01 d0                	add    %edx,%eax
80103301:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103304:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103307:	c1 e8 04             	shr    $0x4,%eax
8010330a:	89 c2                	mov    %eax,%edx
8010330c:	89 d0                	mov    %edx,%eax
8010330e:	c1 e0 02             	shl    $0x2,%eax
80103311:	01 d0                	add    %edx,%eax
80103313:	01 c0                	add    %eax,%eax
80103315:	89 c2                	mov    %eax,%edx
80103317:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010331a:	83 e0 0f             	and    $0xf,%eax
8010331d:	01 d0                	add    %edx,%eax
8010331f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103322:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103325:	c1 e8 04             	shr    $0x4,%eax
80103328:	89 c2                	mov    %eax,%edx
8010332a:	89 d0                	mov    %edx,%eax
8010332c:	c1 e0 02             	shl    $0x2,%eax
8010332f:	01 d0                	add    %edx,%eax
80103331:	01 c0                	add    %eax,%eax
80103333:	89 c2                	mov    %eax,%edx
80103335:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103338:	83 e0 0f             	and    $0xf,%eax
8010333b:	01 d0                	add    %edx,%eax
8010333d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103340:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103343:	c1 e8 04             	shr    $0x4,%eax
80103346:	89 c2                	mov    %eax,%edx
80103348:	89 d0                	mov    %edx,%eax
8010334a:	c1 e0 02             	shl    $0x2,%eax
8010334d:	01 d0                	add    %edx,%eax
8010334f:	01 c0                	add    %eax,%eax
80103351:	89 c2                	mov    %eax,%edx
80103353:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103356:	83 e0 0f             	and    $0xf,%eax
80103359:	01 d0                	add    %edx,%eax
8010335b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010335e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103361:	c1 e8 04             	shr    $0x4,%eax
80103364:	89 c2                	mov    %eax,%edx
80103366:	89 d0                	mov    %edx,%eax
80103368:	c1 e0 02             	shl    $0x2,%eax
8010336b:	01 d0                	add    %edx,%eax
8010336d:	01 c0                	add    %eax,%eax
8010336f:	89 c2                	mov    %eax,%edx
80103371:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103374:	83 e0 0f             	and    $0xf,%eax
80103377:	01 d0                	add    %edx,%eax
80103379:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010337c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010337f:	c1 e8 04             	shr    $0x4,%eax
80103382:	89 c2                	mov    %eax,%edx
80103384:	89 d0                	mov    %edx,%eax
80103386:	c1 e0 02             	shl    $0x2,%eax
80103389:	01 d0                	add    %edx,%eax
8010338b:	01 c0                	add    %eax,%eax
8010338d:	89 c2                	mov    %eax,%edx
8010338f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103392:	83 e0 0f             	and    $0xf,%eax
80103395:	01 d0                	add    %edx,%eax
80103397:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010339a:	8b 45 08             	mov    0x8(%ebp),%eax
8010339d:	8b 55 d8             	mov    -0x28(%ebp),%edx
801033a0:	89 10                	mov    %edx,(%eax)
801033a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801033a5:	89 50 04             	mov    %edx,0x4(%eax)
801033a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801033ab:	89 50 08             	mov    %edx,0x8(%eax)
801033ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801033b1:	89 50 0c             	mov    %edx,0xc(%eax)
801033b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801033b7:	89 50 10             	mov    %edx,0x10(%eax)
801033ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
801033bd:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801033c0:	8b 45 08             	mov    0x8(%ebp),%eax
801033c3:	8b 40 14             	mov    0x14(%eax),%eax
801033c6:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801033cc:	8b 45 08             	mov    0x8(%ebp),%eax
801033cf:	89 50 14             	mov    %edx,0x14(%eax)
}
801033d2:	90                   	nop
801033d3:	c9                   	leave  
801033d4:	c3                   	ret    

801033d5 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801033d5:	55                   	push   %ebp
801033d6:	89 e5                	mov    %esp,%ebp
801033d8:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801033db:	83 ec 08             	sub    $0x8,%esp
801033de:	68 70 9c 10 80       	push   $0x80109c70
801033e3:	68 80 42 11 80       	push   $0x80114280
801033e8:	e8 00 2f 00 00       	call   801062ed <initlock>
801033ed:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801033f0:	83 ec 08             	sub    $0x8,%esp
801033f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033f6:	50                   	push   %eax
801033f7:	ff 75 08             	pushl  0x8(%ebp)
801033fa:	e8 2b e0 ff ff       	call   8010142a <readsb>
801033ff:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103402:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103405:	a3 b4 42 11 80       	mov    %eax,0x801142b4
  log.size = sb.nlog;
8010340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010340d:	a3 b8 42 11 80       	mov    %eax,0x801142b8
  log.dev = dev;
80103412:	8b 45 08             	mov    0x8(%ebp),%eax
80103415:	a3 c4 42 11 80       	mov    %eax,0x801142c4
  recover_from_log();
8010341a:	e8 b2 01 00 00       	call   801035d1 <recover_from_log>
}
8010341f:	90                   	nop
80103420:	c9                   	leave  
80103421:	c3                   	ret    

80103422 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103422:	55                   	push   %ebp
80103423:	89 e5                	mov    %esp,%ebp
80103425:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103428:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010342f:	e9 95 00 00 00       	jmp    801034c9 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103434:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
8010343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010343d:	01 d0                	add    %edx,%eax
8010343f:	83 c0 01             	add    $0x1,%eax
80103442:	89 c2                	mov    %eax,%edx
80103444:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103449:	83 ec 08             	sub    $0x8,%esp
8010344c:	52                   	push   %edx
8010344d:	50                   	push   %eax
8010344e:	e8 63 cd ff ff       	call   801001b6 <bread>
80103453:	83 c4 10             	add    $0x10,%esp
80103456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010345c:	83 c0 10             	add    $0x10,%eax
8010345f:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
80103466:	89 c2                	mov    %eax,%edx
80103468:	a1 c4 42 11 80       	mov    0x801142c4,%eax
8010346d:	83 ec 08             	sub    $0x8,%esp
80103470:	52                   	push   %edx
80103471:	50                   	push   %eax
80103472:	e8 3f cd ff ff       	call   801001b6 <bread>
80103477:	83 c4 10             	add    $0x10,%esp
8010347a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010347d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103480:	8d 50 18             	lea    0x18(%eax),%edx
80103483:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103486:	83 c0 18             	add    $0x18,%eax
80103489:	83 ec 04             	sub    $0x4,%esp
8010348c:	68 00 02 00 00       	push   $0x200
80103491:	52                   	push   %edx
80103492:	50                   	push   %eax
80103493:	e8 99 31 00 00       	call   80106631 <memmove>
80103498:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010349b:	83 ec 0c             	sub    $0xc,%esp
8010349e:	ff 75 ec             	pushl  -0x14(%ebp)
801034a1:	e8 49 cd ff ff       	call   801001ef <bwrite>
801034a6:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801034a9:	83 ec 0c             	sub    $0xc,%esp
801034ac:	ff 75 f0             	pushl  -0x10(%ebp)
801034af:	e8 7a cd ff ff       	call   8010022e <brelse>
801034b4:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801034b7:	83 ec 0c             	sub    $0xc,%esp
801034ba:	ff 75 ec             	pushl  -0x14(%ebp)
801034bd:	e8 6c cd ff ff       	call   8010022e <brelse>
801034c2:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034c9:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801034ce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034d1:	0f 8f 5d ff ff ff    	jg     80103434 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801034d7:	90                   	nop
801034d8:	c9                   	leave  
801034d9:	c3                   	ret    

801034da <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801034da:	55                   	push   %ebp
801034db:	89 e5                	mov    %esp,%ebp
801034dd:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034e0:	a1 b4 42 11 80       	mov    0x801142b4,%eax
801034e5:	89 c2                	mov    %eax,%edx
801034e7:	a1 c4 42 11 80       	mov    0x801142c4,%eax
801034ec:	83 ec 08             	sub    $0x8,%esp
801034ef:	52                   	push   %edx
801034f0:	50                   	push   %eax
801034f1:	e8 c0 cc ff ff       	call   801001b6 <bread>
801034f6:	83 c4 10             	add    $0x10,%esp
801034f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801034fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034ff:	83 c0 18             	add    $0x18,%eax
80103502:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103505:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103508:	8b 00                	mov    (%eax),%eax
8010350a:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  for (i = 0; i < log.lh.n; i++) {
8010350f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103516:	eb 1b                	jmp    80103533 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103518:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010351b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010351e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103522:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103525:	83 c2 10             	add    $0x10,%edx
80103528:	89 04 95 8c 42 11 80 	mov    %eax,-0x7feebd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010352f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103533:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103538:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010353b:	7f db                	jg     80103518 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010353d:	83 ec 0c             	sub    $0xc,%esp
80103540:	ff 75 f0             	pushl  -0x10(%ebp)
80103543:	e8 e6 cc ff ff       	call   8010022e <brelse>
80103548:	83 c4 10             	add    $0x10,%esp
}
8010354b:	90                   	nop
8010354c:	c9                   	leave  
8010354d:	c3                   	ret    

8010354e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010354e:	55                   	push   %ebp
8010354f:	89 e5                	mov    %esp,%ebp
80103551:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103554:	a1 b4 42 11 80       	mov    0x801142b4,%eax
80103559:	89 c2                	mov    %eax,%edx
8010355b:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103560:	83 ec 08             	sub    $0x8,%esp
80103563:	52                   	push   %edx
80103564:	50                   	push   %eax
80103565:	e8 4c cc ff ff       	call   801001b6 <bread>
8010356a:	83 c4 10             	add    $0x10,%esp
8010356d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103570:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103573:	83 c0 18             	add    $0x18,%eax
80103576:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103579:	8b 15 c8 42 11 80    	mov    0x801142c8,%edx
8010357f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103582:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010358b:	eb 1b                	jmp    801035a8 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
8010358d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103590:	83 c0 10             	add    $0x10,%eax
80103593:	8b 0c 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%ecx
8010359a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010359d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035a0:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801035a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035a8:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801035ad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035b0:	7f db                	jg     8010358d <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801035b2:	83 ec 0c             	sub    $0xc,%esp
801035b5:	ff 75 f0             	pushl  -0x10(%ebp)
801035b8:	e8 32 cc ff ff       	call   801001ef <bwrite>
801035bd:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	ff 75 f0             	pushl  -0x10(%ebp)
801035c6:	e8 63 cc ff ff       	call   8010022e <brelse>
801035cb:	83 c4 10             	add    $0x10,%esp
}
801035ce:	90                   	nop
801035cf:	c9                   	leave  
801035d0:	c3                   	ret    

801035d1 <recover_from_log>:

static void
recover_from_log(void)
{
801035d1:	55                   	push   %ebp
801035d2:	89 e5                	mov    %esp,%ebp
801035d4:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801035d7:	e8 fe fe ff ff       	call   801034da <read_head>
  install_trans(); // if committed, copy from log to disk
801035dc:	e8 41 fe ff ff       	call   80103422 <install_trans>
  log.lh.n = 0;
801035e1:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
801035e8:	00 00 00 
  write_head(); // clear the log
801035eb:	e8 5e ff ff ff       	call   8010354e <write_head>
}
801035f0:	90                   	nop
801035f1:	c9                   	leave  
801035f2:	c3                   	ret    

801035f3 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801035f3:	55                   	push   %ebp
801035f4:	89 e5                	mov    %esp,%ebp
801035f6:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801035f9:	83 ec 0c             	sub    $0xc,%esp
801035fc:	68 80 42 11 80       	push   $0x80114280
80103601:	e8 09 2d 00 00       	call   8010630f <acquire>
80103606:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103609:	a1 c0 42 11 80       	mov    0x801142c0,%eax
8010360e:	85 c0                	test   %eax,%eax
80103610:	74 17                	je     80103629 <begin_op+0x36>
      sleep(&log, &log.lock);
80103612:	83 ec 08             	sub    $0x8,%esp
80103615:	68 80 42 11 80       	push   $0x80114280
8010361a:	68 80 42 11 80       	push   $0x80114280
8010361f:	e8 a8 1d 00 00       	call   801053cc <sleep>
80103624:	83 c4 10             	add    $0x10,%esp
80103627:	eb e0                	jmp    80103609 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103629:	8b 0d c8 42 11 80    	mov    0x801142c8,%ecx
8010362f:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103634:	8d 50 01             	lea    0x1(%eax),%edx
80103637:	89 d0                	mov    %edx,%eax
80103639:	c1 e0 02             	shl    $0x2,%eax
8010363c:	01 d0                	add    %edx,%eax
8010363e:	01 c0                	add    %eax,%eax
80103640:	01 c8                	add    %ecx,%eax
80103642:	83 f8 1e             	cmp    $0x1e,%eax
80103645:	7e 17                	jle    8010365e <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103647:	83 ec 08             	sub    $0x8,%esp
8010364a:	68 80 42 11 80       	push   $0x80114280
8010364f:	68 80 42 11 80       	push   $0x80114280
80103654:	e8 73 1d 00 00       	call   801053cc <sleep>
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	eb ab                	jmp    80103609 <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010365e:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103663:	83 c0 01             	add    $0x1,%eax
80103666:	a3 bc 42 11 80       	mov    %eax,0x801142bc
      release(&log.lock);
8010366b:	83 ec 0c             	sub    $0xc,%esp
8010366e:	68 80 42 11 80       	push   $0x80114280
80103673:	e8 fe 2c 00 00       	call   80106376 <release>
80103678:	83 c4 10             	add    $0x10,%esp
      break;
8010367b:	90                   	nop
    }
  }
}
8010367c:	90                   	nop
8010367d:	c9                   	leave  
8010367e:	c3                   	ret    

8010367f <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010367f:	55                   	push   %ebp
80103680:	89 e5                	mov    %esp,%ebp
80103682:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103685:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010368c:	83 ec 0c             	sub    $0xc,%esp
8010368f:	68 80 42 11 80       	push   $0x80114280
80103694:	e8 76 2c 00 00       	call   8010630f <acquire>
80103699:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010369c:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801036a1:	83 e8 01             	sub    $0x1,%eax
801036a4:	a3 bc 42 11 80       	mov    %eax,0x801142bc
  if(log.committing)
801036a9:	a1 c0 42 11 80       	mov    0x801142c0,%eax
801036ae:	85 c0                	test   %eax,%eax
801036b0:	74 0d                	je     801036bf <end_op+0x40>
    panic("log.committing");
801036b2:	83 ec 0c             	sub    $0xc,%esp
801036b5:	68 74 9c 10 80       	push   $0x80109c74
801036ba:	e8 a7 ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801036bf:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801036c4:	85 c0                	test   %eax,%eax
801036c6:	75 13                	jne    801036db <end_op+0x5c>
    do_commit = 1;
801036c8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036cf:	c7 05 c0 42 11 80 01 	movl   $0x1,0x801142c0
801036d6:	00 00 00 
801036d9:	eb 10                	jmp    801036eb <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801036db:	83 ec 0c             	sub    $0xc,%esp
801036de:	68 80 42 11 80       	push   $0x80114280
801036e3:	e8 3f 1e 00 00       	call   80105527 <wakeup>
801036e8:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036eb:	83 ec 0c             	sub    $0xc,%esp
801036ee:	68 80 42 11 80       	push   $0x80114280
801036f3:	e8 7e 2c 00 00       	call   80106376 <release>
801036f8:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801036fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801036ff:	74 3f                	je     80103740 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103701:	e8 f5 00 00 00       	call   801037fb <commit>
    acquire(&log.lock);
80103706:	83 ec 0c             	sub    $0xc,%esp
80103709:	68 80 42 11 80       	push   $0x80114280
8010370e:	e8 fc 2b 00 00       	call   8010630f <acquire>
80103713:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103716:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
8010371d:	00 00 00 
    wakeup(&log);
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	68 80 42 11 80       	push   $0x80114280
80103728:	e8 fa 1d 00 00       	call   80105527 <wakeup>
8010372d:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	68 80 42 11 80       	push   $0x80114280
80103738:	e8 39 2c 00 00       	call   80106376 <release>
8010373d:	83 c4 10             	add    $0x10,%esp
  }
}
80103740:	90                   	nop
80103741:	c9                   	leave  
80103742:	c3                   	ret    

80103743 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103743:	55                   	push   %ebp
80103744:	89 e5                	mov    %esp,%ebp
80103746:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103750:	e9 95 00 00 00       	jmp    801037ea <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103755:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
8010375b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010375e:	01 d0                	add    %edx,%eax
80103760:	83 c0 01             	add    $0x1,%eax
80103763:	89 c2                	mov    %eax,%edx
80103765:	a1 c4 42 11 80       	mov    0x801142c4,%eax
8010376a:	83 ec 08             	sub    $0x8,%esp
8010376d:	52                   	push   %edx
8010376e:	50                   	push   %eax
8010376f:	e8 42 ca ff ff       	call   801001b6 <bread>
80103774:	83 c4 10             	add    $0x10,%esp
80103777:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010377a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010377d:	83 c0 10             	add    $0x10,%eax
80103780:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
80103787:	89 c2                	mov    %eax,%edx
80103789:	a1 c4 42 11 80       	mov    0x801142c4,%eax
8010378e:	83 ec 08             	sub    $0x8,%esp
80103791:	52                   	push   %edx
80103792:	50                   	push   %eax
80103793:	e8 1e ca ff ff       	call   801001b6 <bread>
80103798:	83 c4 10             	add    $0x10,%esp
8010379b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010379e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037a1:	8d 50 18             	lea    0x18(%eax),%edx
801037a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037a7:	83 c0 18             	add    $0x18,%eax
801037aa:	83 ec 04             	sub    $0x4,%esp
801037ad:	68 00 02 00 00       	push   $0x200
801037b2:	52                   	push   %edx
801037b3:	50                   	push   %eax
801037b4:	e8 78 2e 00 00       	call   80106631 <memmove>
801037b9:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801037bc:	83 ec 0c             	sub    $0xc,%esp
801037bf:	ff 75 f0             	pushl  -0x10(%ebp)
801037c2:	e8 28 ca ff ff       	call   801001ef <bwrite>
801037c7:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801037ca:	83 ec 0c             	sub    $0xc,%esp
801037cd:	ff 75 ec             	pushl  -0x14(%ebp)
801037d0:	e8 59 ca ff ff       	call   8010022e <brelse>
801037d5:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801037d8:	83 ec 0c             	sub    $0xc,%esp
801037db:	ff 75 f0             	pushl  -0x10(%ebp)
801037de:	e8 4b ca ff ff       	call   8010022e <brelse>
801037e3:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037ea:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801037ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037f2:	0f 8f 5d ff ff ff    	jg     80103755 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801037f8:	90                   	nop
801037f9:	c9                   	leave  
801037fa:	c3                   	ret    

801037fb <commit>:

static void
commit()
{
801037fb:	55                   	push   %ebp
801037fc:	89 e5                	mov    %esp,%ebp
801037fe:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103801:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103806:	85 c0                	test   %eax,%eax
80103808:	7e 1e                	jle    80103828 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010380a:	e8 34 ff ff ff       	call   80103743 <write_log>
    write_head();    // Write header to disk -- the real commit
8010380f:	e8 3a fd ff ff       	call   8010354e <write_head>
    install_trans(); // Now install writes to home locations
80103814:	e8 09 fc ff ff       	call   80103422 <install_trans>
    log.lh.n = 0; 
80103819:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
80103820:	00 00 00 
    write_head();    // Erase the transaction from the log
80103823:	e8 26 fd ff ff       	call   8010354e <write_head>
  }
}
80103828:	90                   	nop
80103829:	c9                   	leave  
8010382a:	c3                   	ret    

8010382b <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010382b:	55                   	push   %ebp
8010382c:	89 e5                	mov    %esp,%ebp
8010382e:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103831:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103836:	83 f8 1d             	cmp    $0x1d,%eax
80103839:	7f 12                	jg     8010384d <log_write+0x22>
8010383b:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103840:	8b 15 b8 42 11 80    	mov    0x801142b8,%edx
80103846:	83 ea 01             	sub    $0x1,%edx
80103849:	39 d0                	cmp    %edx,%eax
8010384b:	7c 0d                	jl     8010385a <log_write+0x2f>
    panic("too big a transaction");
8010384d:	83 ec 0c             	sub    $0xc,%esp
80103850:	68 83 9c 10 80       	push   $0x80109c83
80103855:	e8 0c cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010385a:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010385f:	85 c0                	test   %eax,%eax
80103861:	7f 0d                	jg     80103870 <log_write+0x45>
    panic("log_write outside of trans");
80103863:	83 ec 0c             	sub    $0xc,%esp
80103866:	68 99 9c 10 80       	push   $0x80109c99
8010386b:	e8 f6 cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
80103873:	68 80 42 11 80       	push   $0x80114280
80103878:	e8 92 2a 00 00       	call   8010630f <acquire>
8010387d:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103887:	eb 1d                	jmp    801038a6 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010388c:	83 c0 10             	add    $0x10,%eax
8010388f:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
80103896:	89 c2                	mov    %eax,%edx
80103898:	8b 45 08             	mov    0x8(%ebp),%eax
8010389b:	8b 40 08             	mov    0x8(%eax),%eax
8010389e:	39 c2                	cmp    %eax,%edx
801038a0:	74 10                	je     801038b2 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801038a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038a6:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038ae:	7f d9                	jg     80103889 <log_write+0x5e>
801038b0:	eb 01                	jmp    801038b3 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
801038b2:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801038b3:	8b 45 08             	mov    0x8(%ebp),%eax
801038b6:	8b 40 08             	mov    0x8(%eax),%eax
801038b9:	89 c2                	mov    %eax,%edx
801038bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038be:	83 c0 10             	add    $0x10,%eax
801038c1:	89 14 85 8c 42 11 80 	mov    %edx,-0x7feebd74(,%eax,4)
  if (i == log.lh.n)
801038c8:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038d0:	75 0d                	jne    801038df <log_write+0xb4>
    log.lh.n++;
801038d2:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038d7:	83 c0 01             	add    $0x1,%eax
801038da:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  b->flags |= B_DIRTY; // prevent eviction
801038df:	8b 45 08             	mov    0x8(%ebp),%eax
801038e2:	8b 00                	mov    (%eax),%eax
801038e4:	83 c8 04             	or     $0x4,%eax
801038e7:	89 c2                	mov    %eax,%edx
801038e9:	8b 45 08             	mov    0x8(%ebp),%eax
801038ec:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038ee:	83 ec 0c             	sub    $0xc,%esp
801038f1:	68 80 42 11 80       	push   $0x80114280
801038f6:	e8 7b 2a 00 00       	call   80106376 <release>
801038fb:	83 c4 10             	add    $0x10,%esp
}
801038fe:	90                   	nop
801038ff:	c9                   	leave  
80103900:	c3                   	ret    

80103901 <v2p>:
80103901:	55                   	push   %ebp
80103902:	89 e5                	mov    %esp,%ebp
80103904:	8b 45 08             	mov    0x8(%ebp),%eax
80103907:	05 00 00 00 80       	add    $0x80000000,%eax
8010390c:	5d                   	pop    %ebp
8010390d:	c3                   	ret    

8010390e <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010390e:	55                   	push   %ebp
8010390f:	89 e5                	mov    %esp,%ebp
80103911:	8b 45 08             	mov    0x8(%ebp),%eax
80103914:	05 00 00 00 80       	add    $0x80000000,%eax
80103919:	5d                   	pop    %ebp
8010391a:	c3                   	ret    

8010391b <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010391b:	55                   	push   %ebp
8010391c:	89 e5                	mov    %esp,%ebp
8010391e:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103921:	8b 55 08             	mov    0x8(%ebp),%edx
80103924:	8b 45 0c             	mov    0xc(%ebp),%eax
80103927:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010392a:	f0 87 02             	lock xchg %eax,(%edx)
8010392d:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103930:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103933:	c9                   	leave  
80103934:	c3                   	ret    

80103935 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103935:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103939:	83 e4 f0             	and    $0xfffffff0,%esp
8010393c:	ff 71 fc             	pushl  -0x4(%ecx)
8010393f:	55                   	push   %ebp
80103940:	89 e5                	mov    %esp,%ebp
80103942:	51                   	push   %ecx
80103943:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103946:	83 ec 08             	sub    $0x8,%esp
80103949:	68 00 00 40 80       	push   $0x80400000
8010394e:	68 3c 79 11 80       	push   $0x8011793c
80103953:	e8 7d f2 ff ff       	call   80102bd5 <kinit1>
80103958:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
8010395b:	e8 23 59 00 00       	call   80109283 <kvmalloc>
  mpinit();        // collect info about this machine
80103960:	e8 43 04 00 00       	call   80103da8 <mpinit>
  lapicinit();
80103965:	e8 ea f5 ff ff       	call   80102f54 <lapicinit>
  seginit();       // set up segments
8010396a:	e8 bd 52 00 00       	call   80108c2c <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010396f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103975:	0f b6 00             	movzbl (%eax),%eax
80103978:	0f b6 c0             	movzbl %al,%eax
8010397b:	83 ec 08             	sub    $0x8,%esp
8010397e:	50                   	push   %eax
8010397f:	68 b4 9c 10 80       	push   $0x80109cb4
80103984:	e8 3d ca ff ff       	call   801003c6 <cprintf>
80103989:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010398c:	e8 6d 06 00 00       	call   80103ffe <picinit>
  ioapicinit();    // another interrupt controller
80103991:	e8 34 f1 ff ff       	call   80102aca <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103996:	e8 24 d2 ff ff       	call   80100bbf <consoleinit>
  uartinit();      // serial port
8010399b:	e8 e8 45 00 00       	call   80107f88 <uartinit>
  pinit();         // process table
801039a0:	e8 5d 0b 00 00       	call   80104502 <pinit>
  tvinit();        // trap vectors
801039a5:	e8 da 41 00 00       	call   80107b84 <tvinit>
  binit();         // buffer cache
801039aa:	e8 85 c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039af:	e8 67 d6 ff ff       	call   8010101b <fileinit>
  ideinit();       // disk
801039b4:	e8 19 ed ff ff       	call   801026d2 <ideinit>
  if(!ismp)
801039b9:	a1 64 43 11 80       	mov    0x80114364,%eax
801039be:	85 c0                	test   %eax,%eax
801039c0:	75 05                	jne    801039c7 <main+0x92>
    timerinit();   // uniprocessor timer
801039c2:	e8 0e 41 00 00       	call   80107ad5 <timerinit>
  startothers();   // start other processors
801039c7:	e8 7f 00 00 00       	call   80103a4b <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039cc:	83 ec 08             	sub    $0x8,%esp
801039cf:	68 00 00 00 8e       	push   $0x8e000000
801039d4:	68 00 00 40 80       	push   $0x80400000
801039d9:	e8 30 f2 ff ff       	call   80102c0e <kinit2>
801039de:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039e1:	e8 df 0c 00 00       	call   801046c5 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801039e6:	e8 1a 00 00 00       	call   80103a05 <mpmain>

801039eb <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801039eb:	55                   	push   %ebp
801039ec:	89 e5                	mov    %esp,%ebp
801039ee:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801039f1:	e8 a5 58 00 00       	call   8010929b <switchkvm>
  seginit();
801039f6:	e8 31 52 00 00       	call   80108c2c <seginit>
  lapicinit();
801039fb:	e8 54 f5 ff ff       	call   80102f54 <lapicinit>
  mpmain();
80103a00:	e8 00 00 00 00       	call   80103a05 <mpmain>

80103a05 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103a05:	55                   	push   %ebp
80103a06:	89 e5                	mov    %esp,%ebp
80103a08:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103a0b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a11:	0f b6 00             	movzbl (%eax),%eax
80103a14:	0f b6 c0             	movzbl %al,%eax
80103a17:	83 ec 08             	sub    $0x8,%esp
80103a1a:	50                   	push   %eax
80103a1b:	68 cb 9c 10 80       	push   $0x80109ccb
80103a20:	e8 a1 c9 ff ff       	call   801003c6 <cprintf>
80103a25:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a28:	e8 b8 42 00 00       	call   80107ce5 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a2d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a33:	05 a8 00 00 00       	add    $0xa8,%eax
80103a38:	83 ec 08             	sub    $0x8,%esp
80103a3b:	6a 01                	push   $0x1
80103a3d:	50                   	push   %eax
80103a3e:	e8 d8 fe ff ff       	call   8010391b <xchg>
80103a43:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a46:	e8 b2 15 00 00       	call   80104ffd <scheduler>

80103a4b <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103a4b:	55                   	push   %ebp
80103a4c:	89 e5                	mov    %esp,%ebp
80103a4e:	53                   	push   %ebx
80103a4f:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103a52:	68 00 70 00 00       	push   $0x7000
80103a57:	e8 b2 fe ff ff       	call   8010390e <p2v>
80103a5c:	83 c4 04             	add    $0x4,%esp
80103a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a62:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a67:	83 ec 04             	sub    $0x4,%esp
80103a6a:	50                   	push   %eax
80103a6b:	68 2c d5 10 80       	push   $0x8010d52c
80103a70:	ff 75 f0             	pushl  -0x10(%ebp)
80103a73:	e8 b9 2b 00 00       	call   80106631 <memmove>
80103a78:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a7b:	c7 45 f4 80 43 11 80 	movl   $0x80114380,-0xc(%ebp)
80103a82:	e9 90 00 00 00       	jmp    80103b17 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a87:	e8 e6 f5 ff ff       	call   80103072 <cpunum>
80103a8c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a92:	05 80 43 11 80       	add    $0x80114380,%eax
80103a97:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a9a:	74 73                	je     80103b0f <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a9c:	e8 6b f2 ff ff       	call   80102d0c <kalloc>
80103aa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aa7:	83 e8 04             	sub    $0x4,%eax
80103aaa:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103aad:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103ab3:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ab8:	83 e8 08             	sub    $0x8,%eax
80103abb:	c7 00 eb 39 10 80    	movl   $0x801039eb,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ac4:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103ac7:	83 ec 0c             	sub    $0xc,%esp
80103aca:	68 00 c0 10 80       	push   $0x8010c000
80103acf:	e8 2d fe ff ff       	call   80103901 <v2p>
80103ad4:	83 c4 10             	add    $0x10,%esp
80103ad7:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103ad9:	83 ec 0c             	sub    $0xc,%esp
80103adc:	ff 75 f0             	pushl  -0x10(%ebp)
80103adf:	e8 1d fe ff ff       	call   80103901 <v2p>
80103ae4:	83 c4 10             	add    $0x10,%esp
80103ae7:	89 c2                	mov    %eax,%edx
80103ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aec:	0f b6 00             	movzbl (%eax),%eax
80103aef:	0f b6 c0             	movzbl %al,%eax
80103af2:	83 ec 08             	sub    $0x8,%esp
80103af5:	52                   	push   %edx
80103af6:	50                   	push   %eax
80103af7:	e8 f0 f5 ff ff       	call   801030ec <lapicstartap>
80103afc:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103aff:	90                   	nop
80103b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b03:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103b09:	85 c0                	test   %eax,%eax
80103b0b:	74 f3                	je     80103b00 <startothers+0xb5>
80103b0d:	eb 01                	jmp    80103b10 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103b0f:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103b10:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103b17:	a1 60 49 11 80       	mov    0x80114960,%eax
80103b1c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b22:	05 80 43 11 80       	add    $0x80114380,%eax
80103b27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b2a:	0f 87 57 ff ff ff    	ja     80103a87 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103b30:	90                   	nop
80103b31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b34:	c9                   	leave  
80103b35:	c3                   	ret    

80103b36 <p2v>:
80103b36:	55                   	push   %ebp
80103b37:	89 e5                	mov    %esp,%ebp
80103b39:	8b 45 08             	mov    0x8(%ebp),%eax
80103b3c:	05 00 00 00 80       	add    $0x80000000,%eax
80103b41:	5d                   	pop    %ebp
80103b42:	c3                   	ret    

80103b43 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103b43:	55                   	push   %ebp
80103b44:	89 e5                	mov    %esp,%ebp
80103b46:	83 ec 14             	sub    $0x14,%esp
80103b49:	8b 45 08             	mov    0x8(%ebp),%eax
80103b4c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b50:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103b54:	89 c2                	mov    %eax,%edx
80103b56:	ec                   	in     (%dx),%al
80103b57:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b5a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103b5e:	c9                   	leave  
80103b5f:	c3                   	ret    

80103b60 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	83 ec 08             	sub    $0x8,%esp
80103b66:	8b 55 08             	mov    0x8(%ebp),%edx
80103b69:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b6c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b70:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b73:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b77:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b7b:	ee                   	out    %al,(%dx)
}
80103b7c:	90                   	nop
80103b7d:	c9                   	leave  
80103b7e:	c3                   	ret    

80103b7f <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b7f:	55                   	push   %ebp
80103b80:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b82:	a1 64 d6 10 80       	mov    0x8010d664,%eax
80103b87:	89 c2                	mov    %eax,%edx
80103b89:	b8 80 43 11 80       	mov    $0x80114380,%eax
80103b8e:	29 c2                	sub    %eax,%edx
80103b90:	89 d0                	mov    %edx,%eax
80103b92:	c1 f8 02             	sar    $0x2,%eax
80103b95:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103b9b:	5d                   	pop    %ebp
80103b9c:	c3                   	ret    

80103b9d <sum>:

static uchar
sum(uchar *addr, int len)
{
80103b9d:	55                   	push   %ebp
80103b9e:	89 e5                	mov    %esp,%ebp
80103ba0:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103ba3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103baa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103bb1:	eb 15                	jmp    80103bc8 <sum+0x2b>
    sum += addr[i];
80103bb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103bb6:	8b 45 08             	mov    0x8(%ebp),%eax
80103bb9:	01 d0                	add    %edx,%eax
80103bbb:	0f b6 00             	movzbl (%eax),%eax
80103bbe:	0f b6 c0             	movzbl %al,%eax
80103bc1:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103bc4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bcb:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103bce:	7c e3                	jl     80103bb3 <sum+0x16>
    sum += addr[i];
  return sum;
80103bd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103bd3:	c9                   	leave  
80103bd4:	c3                   	ret    

80103bd5 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103bd5:	55                   	push   %ebp
80103bd6:	89 e5                	mov    %esp,%ebp
80103bd8:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103bdb:	ff 75 08             	pushl  0x8(%ebp)
80103bde:	e8 53 ff ff ff       	call   80103b36 <p2v>
80103be3:	83 c4 04             	add    $0x4,%esp
80103be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103be9:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bef:	01 d0                	add    %edx,%eax
80103bf1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bfa:	eb 36                	jmp    80103c32 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103bfc:	83 ec 04             	sub    $0x4,%esp
80103bff:	6a 04                	push   $0x4
80103c01:	68 dc 9c 10 80       	push   $0x80109cdc
80103c06:	ff 75 f4             	pushl  -0xc(%ebp)
80103c09:	e8 cb 29 00 00       	call   801065d9 <memcmp>
80103c0e:	83 c4 10             	add    $0x10,%esp
80103c11:	85 c0                	test   %eax,%eax
80103c13:	75 19                	jne    80103c2e <mpsearch1+0x59>
80103c15:	83 ec 08             	sub    $0x8,%esp
80103c18:	6a 10                	push   $0x10
80103c1a:	ff 75 f4             	pushl  -0xc(%ebp)
80103c1d:	e8 7b ff ff ff       	call   80103b9d <sum>
80103c22:	83 c4 10             	add    $0x10,%esp
80103c25:	84 c0                	test   %al,%al
80103c27:	75 05                	jne    80103c2e <mpsearch1+0x59>
      return (struct mp*)p;
80103c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2c:	eb 11                	jmp    80103c3f <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103c2e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c35:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c38:	72 c2                	jb     80103bfc <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103c3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c3f:	c9                   	leave  
80103c40:	c3                   	ret    

80103c41 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c41:	55                   	push   %ebp
80103c42:	89 e5                	mov    %esp,%ebp
80103c44:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c47:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c51:	83 c0 0f             	add    $0xf,%eax
80103c54:	0f b6 00             	movzbl (%eax),%eax
80103c57:	0f b6 c0             	movzbl %al,%eax
80103c5a:	c1 e0 08             	shl    $0x8,%eax
80103c5d:	89 c2                	mov    %eax,%edx
80103c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c62:	83 c0 0e             	add    $0xe,%eax
80103c65:	0f b6 00             	movzbl (%eax),%eax
80103c68:	0f b6 c0             	movzbl %al,%eax
80103c6b:	09 d0                	or     %edx,%eax
80103c6d:	c1 e0 04             	shl    $0x4,%eax
80103c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c77:	74 21                	je     80103c9a <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103c79:	83 ec 08             	sub    $0x8,%esp
80103c7c:	68 00 04 00 00       	push   $0x400
80103c81:	ff 75 f0             	pushl  -0x10(%ebp)
80103c84:	e8 4c ff ff ff       	call   80103bd5 <mpsearch1>
80103c89:	83 c4 10             	add    $0x10,%esp
80103c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c93:	74 51                	je     80103ce6 <mpsearch+0xa5>
      return mp;
80103c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c98:	eb 61                	jmp    80103cfb <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9d:	83 c0 14             	add    $0x14,%eax
80103ca0:	0f b6 00             	movzbl (%eax),%eax
80103ca3:	0f b6 c0             	movzbl %al,%eax
80103ca6:	c1 e0 08             	shl    $0x8,%eax
80103ca9:	89 c2                	mov    %eax,%edx
80103cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cae:	83 c0 13             	add    $0x13,%eax
80103cb1:	0f b6 00             	movzbl (%eax),%eax
80103cb4:	0f b6 c0             	movzbl %al,%eax
80103cb7:	09 d0                	or     %edx,%eax
80103cb9:	c1 e0 0a             	shl    $0xa,%eax
80103cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cc2:	2d 00 04 00 00       	sub    $0x400,%eax
80103cc7:	83 ec 08             	sub    $0x8,%esp
80103cca:	68 00 04 00 00       	push   $0x400
80103ccf:	50                   	push   %eax
80103cd0:	e8 00 ff ff ff       	call   80103bd5 <mpsearch1>
80103cd5:	83 c4 10             	add    $0x10,%esp
80103cd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103cdf:	74 05                	je     80103ce6 <mpsearch+0xa5>
      return mp;
80103ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ce4:	eb 15                	jmp    80103cfb <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103ce6:	83 ec 08             	sub    $0x8,%esp
80103ce9:	68 00 00 01 00       	push   $0x10000
80103cee:	68 00 00 0f 00       	push   $0xf0000
80103cf3:	e8 dd fe ff ff       	call   80103bd5 <mpsearch1>
80103cf8:	83 c4 10             	add    $0x10,%esp
}
80103cfb:	c9                   	leave  
80103cfc:	c3                   	ret    

80103cfd <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103cfd:	55                   	push   %ebp
80103cfe:	89 e5                	mov    %esp,%ebp
80103d00:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d03:	e8 39 ff ff ff       	call   80103c41 <mpsearch>
80103d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d0f:	74 0a                	je     80103d1b <mpconfig+0x1e>
80103d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d14:	8b 40 04             	mov    0x4(%eax),%eax
80103d17:	85 c0                	test   %eax,%eax
80103d19:	75 0a                	jne    80103d25 <mpconfig+0x28>
    return 0;
80103d1b:	b8 00 00 00 00       	mov    $0x0,%eax
80103d20:	e9 81 00 00 00       	jmp    80103da6 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d28:	8b 40 04             	mov    0x4(%eax),%eax
80103d2b:	83 ec 0c             	sub    $0xc,%esp
80103d2e:	50                   	push   %eax
80103d2f:	e8 02 fe ff ff       	call   80103b36 <p2v>
80103d34:	83 c4 10             	add    $0x10,%esp
80103d37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d3a:	83 ec 04             	sub    $0x4,%esp
80103d3d:	6a 04                	push   $0x4
80103d3f:	68 e1 9c 10 80       	push   $0x80109ce1
80103d44:	ff 75 f0             	pushl  -0x10(%ebp)
80103d47:	e8 8d 28 00 00       	call   801065d9 <memcmp>
80103d4c:	83 c4 10             	add    $0x10,%esp
80103d4f:	85 c0                	test   %eax,%eax
80103d51:	74 07                	je     80103d5a <mpconfig+0x5d>
    return 0;
80103d53:	b8 00 00 00 00       	mov    $0x0,%eax
80103d58:	eb 4c                	jmp    80103da6 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d5d:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d61:	3c 01                	cmp    $0x1,%al
80103d63:	74 12                	je     80103d77 <mpconfig+0x7a>
80103d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d68:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d6c:	3c 04                	cmp    $0x4,%al
80103d6e:	74 07                	je     80103d77 <mpconfig+0x7a>
    return 0;
80103d70:	b8 00 00 00 00       	mov    $0x0,%eax
80103d75:	eb 2f                	jmp    80103da6 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d7a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d7e:	0f b7 c0             	movzwl %ax,%eax
80103d81:	83 ec 08             	sub    $0x8,%esp
80103d84:	50                   	push   %eax
80103d85:	ff 75 f0             	pushl  -0x10(%ebp)
80103d88:	e8 10 fe ff ff       	call   80103b9d <sum>
80103d8d:	83 c4 10             	add    $0x10,%esp
80103d90:	84 c0                	test   %al,%al
80103d92:	74 07                	je     80103d9b <mpconfig+0x9e>
    return 0;
80103d94:	b8 00 00 00 00       	mov    $0x0,%eax
80103d99:	eb 0b                	jmp    80103da6 <mpconfig+0xa9>
  *pmp = mp;
80103d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103da1:	89 10                	mov    %edx,(%eax)
  return conf;
80103da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103da6:	c9                   	leave  
80103da7:	c3                   	ret    

80103da8 <mpinit>:

void
mpinit(void)
{
80103da8:	55                   	push   %ebp
80103da9:	89 e5                	mov    %esp,%ebp
80103dab:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103dae:	c7 05 64 d6 10 80 80 	movl   $0x80114380,0x8010d664
80103db5:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103db8:	83 ec 0c             	sub    $0xc,%esp
80103dbb:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103dbe:	50                   	push   %eax
80103dbf:	e8 39 ff ff ff       	call   80103cfd <mpconfig>
80103dc4:	83 c4 10             	add    $0x10,%esp
80103dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103dca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103dce:	0f 84 96 01 00 00    	je     80103f6a <mpinit+0x1c2>
    return;
  ismp = 1;
80103dd4:	c7 05 64 43 11 80 01 	movl   $0x1,0x80114364
80103ddb:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de1:	8b 40 24             	mov    0x24(%eax),%eax
80103de4:	a3 7c 42 11 80       	mov    %eax,0x8011427c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dec:	83 c0 2c             	add    $0x2c,%eax
80103def:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df5:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103df9:	0f b7 d0             	movzwl %ax,%edx
80103dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dff:	01 d0                	add    %edx,%eax
80103e01:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e04:	e9 f2 00 00 00       	jmp    80103efb <mpinit+0x153>
    switch(*p){
80103e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e0c:	0f b6 00             	movzbl (%eax),%eax
80103e0f:	0f b6 c0             	movzbl %al,%eax
80103e12:	83 f8 04             	cmp    $0x4,%eax
80103e15:	0f 87 bc 00 00 00    	ja     80103ed7 <mpinit+0x12f>
80103e1b:	8b 04 85 24 9d 10 80 	mov    -0x7fef62dc(,%eax,4),%eax
80103e22:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e27:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e2d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e31:	0f b6 d0             	movzbl %al,%edx
80103e34:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e39:	39 c2                	cmp    %eax,%edx
80103e3b:	74 2b                	je     80103e68 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e40:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e44:	0f b6 d0             	movzbl %al,%edx
80103e47:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e4c:	83 ec 04             	sub    $0x4,%esp
80103e4f:	52                   	push   %edx
80103e50:	50                   	push   %eax
80103e51:	68 e6 9c 10 80       	push   $0x80109ce6
80103e56:	e8 6b c5 ff ff       	call   801003c6 <cprintf>
80103e5b:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e5e:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
80103e65:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e68:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e6b:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103e6f:	0f b6 c0             	movzbl %al,%eax
80103e72:	83 e0 02             	and    $0x2,%eax
80103e75:	85 c0                	test   %eax,%eax
80103e77:	74 15                	je     80103e8e <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103e79:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e7e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e84:	05 80 43 11 80       	add    $0x80114380,%eax
80103e89:	a3 64 d6 10 80       	mov    %eax,0x8010d664
      cpus[ncpu].id = ncpu;
80103e8e:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e93:	8b 15 60 49 11 80    	mov    0x80114960,%edx
80103e99:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e9f:	05 80 43 11 80       	add    $0x80114380,%eax
80103ea4:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103ea6:	a1 60 49 11 80       	mov    0x80114960,%eax
80103eab:	83 c0 01             	add    $0x1,%eax
80103eae:	a3 60 49 11 80       	mov    %eax,0x80114960
      p += sizeof(struct mpproc);
80103eb3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103eb7:	eb 42                	jmp    80103efb <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ebc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103ebf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ec2:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ec6:	a2 60 43 11 80       	mov    %al,0x80114360
      p += sizeof(struct mpioapic);
80103ecb:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ecf:	eb 2a                	jmp    80103efb <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ed1:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ed5:	eb 24                	jmp    80103efb <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eda:	0f b6 00             	movzbl (%eax),%eax
80103edd:	0f b6 c0             	movzbl %al,%eax
80103ee0:	83 ec 08             	sub    $0x8,%esp
80103ee3:	50                   	push   %eax
80103ee4:	68 04 9d 10 80       	push   $0x80109d04
80103ee9:	e8 d8 c4 ff ff       	call   801003c6 <cprintf>
80103eee:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103ef1:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
80103ef8:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103efe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103f01:	0f 82 02 ff ff ff    	jb     80103e09 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103f07:	a1 64 43 11 80       	mov    0x80114364,%eax
80103f0c:	85 c0                	test   %eax,%eax
80103f0e:	75 1d                	jne    80103f2d <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f10:	c7 05 60 49 11 80 01 	movl   $0x1,0x80114960
80103f17:	00 00 00 
    lapic = 0;
80103f1a:	c7 05 7c 42 11 80 00 	movl   $0x0,0x8011427c
80103f21:	00 00 00 
    ioapicid = 0;
80103f24:	c6 05 60 43 11 80 00 	movb   $0x0,0x80114360
    return;
80103f2b:	eb 3e                	jmp    80103f6b <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103f2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f30:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f34:	84 c0                	test   %al,%al
80103f36:	74 33                	je     80103f6b <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f38:	83 ec 08             	sub    $0x8,%esp
80103f3b:	6a 70                	push   $0x70
80103f3d:	6a 22                	push   $0x22
80103f3f:	e8 1c fc ff ff       	call   80103b60 <outb>
80103f44:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	6a 23                	push   $0x23
80103f4c:	e8 f2 fb ff ff       	call   80103b43 <inb>
80103f51:	83 c4 10             	add    $0x10,%esp
80103f54:	83 c8 01             	or     $0x1,%eax
80103f57:	0f b6 c0             	movzbl %al,%eax
80103f5a:	83 ec 08             	sub    $0x8,%esp
80103f5d:	50                   	push   %eax
80103f5e:	6a 23                	push   $0x23
80103f60:	e8 fb fb ff ff       	call   80103b60 <outb>
80103f65:	83 c4 10             	add    $0x10,%esp
80103f68:	eb 01                	jmp    80103f6b <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103f6a:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103f6b:	c9                   	leave  
80103f6c:	c3                   	ret    

80103f6d <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103f6d:	55                   	push   %ebp
80103f6e:	89 e5                	mov    %esp,%ebp
80103f70:	83 ec 08             	sub    $0x8,%esp
80103f73:	8b 55 08             	mov    0x8(%ebp),%edx
80103f76:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f79:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103f7d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f80:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f84:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f88:	ee                   	out    %al,(%dx)
}
80103f89:	90                   	nop
80103f8a:	c9                   	leave  
80103f8b:	c3                   	ret    

80103f8c <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f8c:	55                   	push   %ebp
80103f8d:	89 e5                	mov    %esp,%ebp
80103f8f:	83 ec 04             	sub    $0x4,%esp
80103f92:	8b 45 08             	mov    0x8(%ebp),%eax
80103f95:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f99:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f9d:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80103fa3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fa7:	0f b6 c0             	movzbl %al,%eax
80103faa:	50                   	push   %eax
80103fab:	6a 21                	push   $0x21
80103fad:	e8 bb ff ff ff       	call   80103f6d <outb>
80103fb2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103fb5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fb9:	66 c1 e8 08          	shr    $0x8,%ax
80103fbd:	0f b6 c0             	movzbl %al,%eax
80103fc0:	50                   	push   %eax
80103fc1:	68 a1 00 00 00       	push   $0xa1
80103fc6:	e8 a2 ff ff ff       	call   80103f6d <outb>
80103fcb:	83 c4 08             	add    $0x8,%esp
}
80103fce:	90                   	nop
80103fcf:	c9                   	leave  
80103fd0:	c3                   	ret    

80103fd1 <picenable>:

void
picenable(int irq)
{
80103fd1:	55                   	push   %ebp
80103fd2:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd7:	ba 01 00 00 00       	mov    $0x1,%edx
80103fdc:	89 c1                	mov    %eax,%ecx
80103fde:	d3 e2                	shl    %cl,%edx
80103fe0:	89 d0                	mov    %edx,%eax
80103fe2:	f7 d0                	not    %eax
80103fe4:	89 c2                	mov    %eax,%edx
80103fe6:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80103fed:	21 d0                	and    %edx,%eax
80103fef:	0f b7 c0             	movzwl %ax,%eax
80103ff2:	50                   	push   %eax
80103ff3:	e8 94 ff ff ff       	call   80103f8c <picsetmask>
80103ff8:	83 c4 04             	add    $0x4,%esp
}
80103ffb:	90                   	nop
80103ffc:	c9                   	leave  
80103ffd:	c3                   	ret    

80103ffe <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ffe:	55                   	push   %ebp
80103fff:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104001:	68 ff 00 00 00       	push   $0xff
80104006:	6a 21                	push   $0x21
80104008:	e8 60 ff ff ff       	call   80103f6d <outb>
8010400d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104010:	68 ff 00 00 00       	push   $0xff
80104015:	68 a1 00 00 00       	push   $0xa1
8010401a:	e8 4e ff ff ff       	call   80103f6d <outb>
8010401f:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104022:	6a 11                	push   $0x11
80104024:	6a 20                	push   $0x20
80104026:	e8 42 ff ff ff       	call   80103f6d <outb>
8010402b:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
8010402e:	6a 20                	push   $0x20
80104030:	6a 21                	push   $0x21
80104032:	e8 36 ff ff ff       	call   80103f6d <outb>
80104037:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010403a:	6a 04                	push   $0x4
8010403c:	6a 21                	push   $0x21
8010403e:	e8 2a ff ff ff       	call   80103f6d <outb>
80104043:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80104046:	6a 03                	push   $0x3
80104048:	6a 21                	push   $0x21
8010404a:	e8 1e ff ff ff       	call   80103f6d <outb>
8010404f:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104052:	6a 11                	push   $0x11
80104054:	68 a0 00 00 00       	push   $0xa0
80104059:	e8 0f ff ff ff       	call   80103f6d <outb>
8010405e:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104061:	6a 28                	push   $0x28
80104063:	68 a1 00 00 00       	push   $0xa1
80104068:	e8 00 ff ff ff       	call   80103f6d <outb>
8010406d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104070:	6a 02                	push   $0x2
80104072:	68 a1 00 00 00       	push   $0xa1
80104077:	e8 f1 fe ff ff       	call   80103f6d <outb>
8010407c:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
8010407f:	6a 03                	push   $0x3
80104081:	68 a1 00 00 00       	push   $0xa1
80104086:	e8 e2 fe ff ff       	call   80103f6d <outb>
8010408b:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
8010408e:	6a 68                	push   $0x68
80104090:	6a 20                	push   $0x20
80104092:	e8 d6 fe ff ff       	call   80103f6d <outb>
80104097:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
8010409a:	6a 0a                	push   $0xa
8010409c:	6a 20                	push   $0x20
8010409e:	e8 ca fe ff ff       	call   80103f6d <outb>
801040a3:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
801040a6:	6a 68                	push   $0x68
801040a8:	68 a0 00 00 00       	push   $0xa0
801040ad:	e8 bb fe ff ff       	call   80103f6d <outb>
801040b2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801040b5:	6a 0a                	push   $0xa
801040b7:	68 a0 00 00 00       	push   $0xa0
801040bc:	e8 ac fe ff ff       	call   80103f6d <outb>
801040c1:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801040c4:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801040cb:	66 83 f8 ff          	cmp    $0xffff,%ax
801040cf:	74 13                	je     801040e4 <picinit+0xe6>
    picsetmask(irqmask);
801040d1:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801040d8:	0f b7 c0             	movzwl %ax,%eax
801040db:	50                   	push   %eax
801040dc:	e8 ab fe ff ff       	call   80103f8c <picsetmask>
801040e1:	83 c4 04             	add    $0x4,%esp
}
801040e4:	90                   	nop
801040e5:	c9                   	leave  
801040e6:	c3                   	ret    

801040e7 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801040e7:	55                   	push   %ebp
801040e8:	89 e5                	mov    %esp,%ebp
801040ea:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801040ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801040f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801040fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80104100:	8b 10                	mov    (%eax),%edx
80104102:	8b 45 08             	mov    0x8(%ebp),%eax
80104105:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104107:	e8 2d cf ff ff       	call   80101039 <filealloc>
8010410c:	89 c2                	mov    %eax,%edx
8010410e:	8b 45 08             	mov    0x8(%ebp),%eax
80104111:	89 10                	mov    %edx,(%eax)
80104113:	8b 45 08             	mov    0x8(%ebp),%eax
80104116:	8b 00                	mov    (%eax),%eax
80104118:	85 c0                	test   %eax,%eax
8010411a:	0f 84 cb 00 00 00    	je     801041eb <pipealloc+0x104>
80104120:	e8 14 cf ff ff       	call   80101039 <filealloc>
80104125:	89 c2                	mov    %eax,%edx
80104127:	8b 45 0c             	mov    0xc(%ebp),%eax
8010412a:	89 10                	mov    %edx,(%eax)
8010412c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010412f:	8b 00                	mov    (%eax),%eax
80104131:	85 c0                	test   %eax,%eax
80104133:	0f 84 b2 00 00 00    	je     801041eb <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104139:	e8 ce eb ff ff       	call   80102d0c <kalloc>
8010413e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104141:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104145:	0f 84 9f 00 00 00    	je     801041ea <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
8010414b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010414e:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104155:	00 00 00 
  p->writeopen = 1;
80104158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010415b:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104162:	00 00 00 
  p->nwrite = 0;
80104165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104168:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010416f:	00 00 00 
  p->nread = 0;
80104172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104175:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010417c:	00 00 00 
  initlock(&p->lock, "pipe");
8010417f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104182:	83 ec 08             	sub    $0x8,%esp
80104185:	68 38 9d 10 80       	push   $0x80109d38
8010418a:	50                   	push   %eax
8010418b:	e8 5d 21 00 00       	call   801062ed <initlock>
80104190:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104193:	8b 45 08             	mov    0x8(%ebp),%eax
80104196:	8b 00                	mov    (%eax),%eax
80104198:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010419e:	8b 45 08             	mov    0x8(%ebp),%eax
801041a1:	8b 00                	mov    (%eax),%eax
801041a3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801041a7:	8b 45 08             	mov    0x8(%ebp),%eax
801041aa:	8b 00                	mov    (%eax),%eax
801041ac:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801041b0:	8b 45 08             	mov    0x8(%ebp),%eax
801041b3:	8b 00                	mov    (%eax),%eax
801041b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b8:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801041bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801041be:	8b 00                	mov    (%eax),%eax
801041c0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801041c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c9:	8b 00                	mov    (%eax),%eax
801041cb:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801041cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d2:	8b 00                	mov    (%eax),%eax
801041d4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801041d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801041db:	8b 00                	mov    (%eax),%eax
801041dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e0:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801041e3:	b8 00 00 00 00       	mov    $0x0,%eax
801041e8:	eb 4e                	jmp    80104238 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801041ea:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
801041eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041ef:	74 0e                	je     801041ff <pipealloc+0x118>
    kfree((char*)p);
801041f1:	83 ec 0c             	sub    $0xc,%esp
801041f4:	ff 75 f4             	pushl  -0xc(%ebp)
801041f7:	e8 73 ea ff ff       	call   80102c6f <kfree>
801041fc:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801041ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104202:	8b 00                	mov    (%eax),%eax
80104204:	85 c0                	test   %eax,%eax
80104206:	74 11                	je     80104219 <pipealloc+0x132>
    fileclose(*f0);
80104208:	8b 45 08             	mov    0x8(%ebp),%eax
8010420b:	8b 00                	mov    (%eax),%eax
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	50                   	push   %eax
80104211:	e8 e1 ce ff ff       	call   801010f7 <fileclose>
80104216:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104219:	8b 45 0c             	mov    0xc(%ebp),%eax
8010421c:	8b 00                	mov    (%eax),%eax
8010421e:	85 c0                	test   %eax,%eax
80104220:	74 11                	je     80104233 <pipealloc+0x14c>
    fileclose(*f1);
80104222:	8b 45 0c             	mov    0xc(%ebp),%eax
80104225:	8b 00                	mov    (%eax),%eax
80104227:	83 ec 0c             	sub    $0xc,%esp
8010422a:	50                   	push   %eax
8010422b:	e8 c7 ce ff ff       	call   801010f7 <fileclose>
80104230:	83 c4 10             	add    $0x10,%esp
  return -1;
80104233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104238:	c9                   	leave  
80104239:	c3                   	ret    

8010423a <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010423a:	55                   	push   %ebp
8010423b:	89 e5                	mov    %esp,%ebp
8010423d:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104240:	8b 45 08             	mov    0x8(%ebp),%eax
80104243:	83 ec 0c             	sub    $0xc,%esp
80104246:	50                   	push   %eax
80104247:	e8 c3 20 00 00       	call   8010630f <acquire>
8010424c:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010424f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104253:	74 23                	je     80104278 <pipeclose+0x3e>
    p->writeopen = 0;
80104255:	8b 45 08             	mov    0x8(%ebp),%eax
80104258:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010425f:	00 00 00 
    wakeup(&p->nread);
80104262:	8b 45 08             	mov    0x8(%ebp),%eax
80104265:	05 34 02 00 00       	add    $0x234,%eax
8010426a:	83 ec 0c             	sub    $0xc,%esp
8010426d:	50                   	push   %eax
8010426e:	e8 b4 12 00 00       	call   80105527 <wakeup>
80104273:	83 c4 10             	add    $0x10,%esp
80104276:	eb 21                	jmp    80104299 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104278:	8b 45 08             	mov    0x8(%ebp),%eax
8010427b:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104282:	00 00 00 
    wakeup(&p->nwrite);
80104285:	8b 45 08             	mov    0x8(%ebp),%eax
80104288:	05 38 02 00 00       	add    $0x238,%eax
8010428d:	83 ec 0c             	sub    $0xc,%esp
80104290:	50                   	push   %eax
80104291:	e8 91 12 00 00       	call   80105527 <wakeup>
80104296:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104299:	8b 45 08             	mov    0x8(%ebp),%eax
8010429c:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042a2:	85 c0                	test   %eax,%eax
801042a4:	75 2c                	jne    801042d2 <pipeclose+0x98>
801042a6:	8b 45 08             	mov    0x8(%ebp),%eax
801042a9:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042af:	85 c0                	test   %eax,%eax
801042b1:	75 1f                	jne    801042d2 <pipeclose+0x98>
    release(&p->lock);
801042b3:	8b 45 08             	mov    0x8(%ebp),%eax
801042b6:	83 ec 0c             	sub    $0xc,%esp
801042b9:	50                   	push   %eax
801042ba:	e8 b7 20 00 00       	call   80106376 <release>
801042bf:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801042c2:	83 ec 0c             	sub    $0xc,%esp
801042c5:	ff 75 08             	pushl  0x8(%ebp)
801042c8:	e8 a2 e9 ff ff       	call   80102c6f <kfree>
801042cd:	83 c4 10             	add    $0x10,%esp
801042d0:	eb 0f                	jmp    801042e1 <pipeclose+0xa7>
  } else
    release(&p->lock);
801042d2:	8b 45 08             	mov    0x8(%ebp),%eax
801042d5:	83 ec 0c             	sub    $0xc,%esp
801042d8:	50                   	push   %eax
801042d9:	e8 98 20 00 00       	call   80106376 <release>
801042de:	83 c4 10             	add    $0x10,%esp
}
801042e1:	90                   	nop
801042e2:	c9                   	leave  
801042e3:	c3                   	ret    

801042e4 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
801042e4:	55                   	push   %ebp
801042e5:	89 e5                	mov    %esp,%ebp
801042e7:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042ea:	8b 45 08             	mov    0x8(%ebp),%eax
801042ed:	83 ec 0c             	sub    $0xc,%esp
801042f0:	50                   	push   %eax
801042f1:	e8 19 20 00 00       	call   8010630f <acquire>
801042f6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801042f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104300:	e9 ad 00 00 00       	jmp    801043b2 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104305:	8b 45 08             	mov    0x8(%ebp),%eax
80104308:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010430e:	85 c0                	test   %eax,%eax
80104310:	74 0d                	je     8010431f <pipewrite+0x3b>
80104312:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104318:	8b 40 24             	mov    0x24(%eax),%eax
8010431b:	85 c0                	test   %eax,%eax
8010431d:	74 19                	je     80104338 <pipewrite+0x54>
        release(&p->lock);
8010431f:	8b 45 08             	mov    0x8(%ebp),%eax
80104322:	83 ec 0c             	sub    $0xc,%esp
80104325:	50                   	push   %eax
80104326:	e8 4b 20 00 00       	call   80106376 <release>
8010432b:	83 c4 10             	add    $0x10,%esp
        return -1;
8010432e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104333:	e9 a8 00 00 00       	jmp    801043e0 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104338:	8b 45 08             	mov    0x8(%ebp),%eax
8010433b:	05 34 02 00 00       	add    $0x234,%eax
80104340:	83 ec 0c             	sub    $0xc,%esp
80104343:	50                   	push   %eax
80104344:	e8 de 11 00 00       	call   80105527 <wakeup>
80104349:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010434c:	8b 45 08             	mov    0x8(%ebp),%eax
8010434f:	8b 55 08             	mov    0x8(%ebp),%edx
80104352:	81 c2 38 02 00 00    	add    $0x238,%edx
80104358:	83 ec 08             	sub    $0x8,%esp
8010435b:	50                   	push   %eax
8010435c:	52                   	push   %edx
8010435d:	e8 6a 10 00 00       	call   801053cc <sleep>
80104362:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104365:	8b 45 08             	mov    0x8(%ebp),%eax
80104368:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010436e:	8b 45 08             	mov    0x8(%ebp),%eax
80104371:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104377:	05 00 02 00 00       	add    $0x200,%eax
8010437c:	39 c2                	cmp    %eax,%edx
8010437e:	74 85                	je     80104305 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104380:	8b 45 08             	mov    0x8(%ebp),%eax
80104383:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104389:	8d 48 01             	lea    0x1(%eax),%ecx
8010438c:	8b 55 08             	mov    0x8(%ebp),%edx
8010438f:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104395:	25 ff 01 00 00       	and    $0x1ff,%eax
8010439a:	89 c1                	mov    %eax,%ecx
8010439c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010439f:	8b 45 0c             	mov    0xc(%ebp),%eax
801043a2:	01 d0                	add    %edx,%eax
801043a4:	0f b6 10             	movzbl (%eax),%edx
801043a7:	8b 45 08             	mov    0x8(%ebp),%eax
801043aa:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801043ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b5:	3b 45 10             	cmp    0x10(%ebp),%eax
801043b8:	7c ab                	jl     80104365 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043ba:	8b 45 08             	mov    0x8(%ebp),%eax
801043bd:	05 34 02 00 00       	add    $0x234,%eax
801043c2:	83 ec 0c             	sub    $0xc,%esp
801043c5:	50                   	push   %eax
801043c6:	e8 5c 11 00 00       	call   80105527 <wakeup>
801043cb:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043ce:	8b 45 08             	mov    0x8(%ebp),%eax
801043d1:	83 ec 0c             	sub    $0xc,%esp
801043d4:	50                   	push   %eax
801043d5:	e8 9c 1f 00 00       	call   80106376 <release>
801043da:	83 c4 10             	add    $0x10,%esp
  return n;
801043dd:	8b 45 10             	mov    0x10(%ebp),%eax
}
801043e0:	c9                   	leave  
801043e1:	c3                   	ret    

801043e2 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801043e2:	55                   	push   %ebp
801043e3:	89 e5                	mov    %esp,%ebp
801043e5:	53                   	push   %ebx
801043e6:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801043e9:	8b 45 08             	mov    0x8(%ebp),%eax
801043ec:	83 ec 0c             	sub    $0xc,%esp
801043ef:	50                   	push   %eax
801043f0:	e8 1a 1f 00 00       	call   8010630f <acquire>
801043f5:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043f8:	eb 3f                	jmp    80104439 <piperead+0x57>
    if(proc->killed){
801043fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104400:	8b 40 24             	mov    0x24(%eax),%eax
80104403:	85 c0                	test   %eax,%eax
80104405:	74 19                	je     80104420 <piperead+0x3e>
      release(&p->lock);
80104407:	8b 45 08             	mov    0x8(%ebp),%eax
8010440a:	83 ec 0c             	sub    $0xc,%esp
8010440d:	50                   	push   %eax
8010440e:	e8 63 1f 00 00       	call   80106376 <release>
80104413:	83 c4 10             	add    $0x10,%esp
      return -1;
80104416:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010441b:	e9 bf 00 00 00       	jmp    801044df <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104420:	8b 45 08             	mov    0x8(%ebp),%eax
80104423:	8b 55 08             	mov    0x8(%ebp),%edx
80104426:	81 c2 34 02 00 00    	add    $0x234,%edx
8010442c:	83 ec 08             	sub    $0x8,%esp
8010442f:	50                   	push   %eax
80104430:	52                   	push   %edx
80104431:	e8 96 0f 00 00       	call   801053cc <sleep>
80104436:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104439:	8b 45 08             	mov    0x8(%ebp),%eax
8010443c:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104442:	8b 45 08             	mov    0x8(%ebp),%eax
80104445:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010444b:	39 c2                	cmp    %eax,%edx
8010444d:	75 0d                	jne    8010445c <piperead+0x7a>
8010444f:	8b 45 08             	mov    0x8(%ebp),%eax
80104452:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104458:	85 c0                	test   %eax,%eax
8010445a:	75 9e                	jne    801043fa <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010445c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104463:	eb 49                	jmp    801044ae <piperead+0xcc>
    if(p->nread == p->nwrite)
80104465:	8b 45 08             	mov    0x8(%ebp),%eax
80104468:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010446e:	8b 45 08             	mov    0x8(%ebp),%eax
80104471:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104477:	39 c2                	cmp    %eax,%edx
80104479:	74 3d                	je     801044b8 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010447b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010447e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104481:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104484:	8b 45 08             	mov    0x8(%ebp),%eax
80104487:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010448d:	8d 48 01             	lea    0x1(%eax),%ecx
80104490:	8b 55 08             	mov    0x8(%ebp),%edx
80104493:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104499:	25 ff 01 00 00       	and    $0x1ff,%eax
8010449e:	89 c2                	mov    %eax,%edx
801044a0:	8b 45 08             	mov    0x8(%ebp),%eax
801044a3:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801044a8:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b1:	3b 45 10             	cmp    0x10(%ebp),%eax
801044b4:	7c af                	jl     80104465 <piperead+0x83>
801044b6:	eb 01                	jmp    801044b9 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801044b8:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044b9:	8b 45 08             	mov    0x8(%ebp),%eax
801044bc:	05 38 02 00 00       	add    $0x238,%eax
801044c1:	83 ec 0c             	sub    $0xc,%esp
801044c4:	50                   	push   %eax
801044c5:	e8 5d 10 00 00       	call   80105527 <wakeup>
801044ca:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044cd:	8b 45 08             	mov    0x8(%ebp),%eax
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	50                   	push   %eax
801044d4:	e8 9d 1e 00 00       	call   80106376 <release>
801044d9:	83 c4 10             	add    $0x10,%esp
  return i;
801044dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e2:	c9                   	leave  
801044e3:	c3                   	ret    

801044e4 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
801044e4:	55                   	push   %ebp
801044e5:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
801044e7:	f4                   	hlt    
}
801044e8:	90                   	nop
801044e9:	5d                   	pop    %ebp
801044ea:	c3                   	ret    

801044eb <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801044eb:	55                   	push   %ebp
801044ec:	89 e5                	mov    %esp,%ebp
801044ee:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044f1:	9c                   	pushf  
801044f2:	58                   	pop    %eax
801044f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801044f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801044f9:	c9                   	leave  
801044fa:	c3                   	ret    

801044fb <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801044fb:	55                   	push   %ebp
801044fc:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801044fe:	fb                   	sti    
}
801044ff:	90                   	nop
80104500:	5d                   	pop    %ebp
80104501:	c3                   	ret    

80104502 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104502:	55                   	push   %ebp
80104503:	89 e5                	mov    %esp,%ebp
80104505:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104508:	83 ec 08             	sub    $0x8,%esp
8010450b:	68 40 9d 10 80       	push   $0x80109d40
80104510:	68 80 49 11 80       	push   $0x80114980
80104515:	e8 d3 1d 00 00       	call   801062ed <initlock>
8010451a:	83 c4 10             	add    $0x10,%esp
}
8010451d:	90                   	nop
8010451e:	c9                   	leave  
8010451f:	c3                   	ret    

80104520 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  // START: Added for Project 3: List Management
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
80104526:	83 ec 0c             	sub    $0xc,%esp
80104529:	68 80 49 11 80       	push   $0x80114980
8010452e:	e8 dc 1d 00 00       	call   8010630f <acquire>
80104533:	83 c4 10             	add    $0x10,%esp
  // get an unused proc
  p = getFromStateListHead(&ptable.pLists.free, UNUSED);
80104536:	83 ec 08             	sub    $0x8,%esp
80104539:	6a 00                	push   $0x0
8010453b:	68 b8 70 11 80       	push   $0x801170b8
80104540:	e8 ce 17 00 00       	call   80105d13 <getFromStateListHead>
80104545:	83 c4 10             	add    $0x10,%esp
80104548:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  // if we successfully got a proc then proceed, otherwise return
  if (p != 0)
8010454b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010454f:	75 1a                	jne    8010456b <allocproc+0x4b>
    goto found; // using goto similar to the original code (I think this is allowed?)   

  release(&ptable.lock);
80104551:	83 ec 0c             	sub    $0xc,%esp
80104554:	68 80 49 11 80       	push   $0x80114980
80104559:	e8 18 1e 00 00       	call   80106376 <release>
8010455e:	83 c4 10             	add    $0x10,%esp
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  #endif

  return 0;
80104561:	b8 00 00 00 00       	mov    $0x0,%eax
80104566:	e9 58 01 00 00       	jmp    801046c3 <allocproc+0x1a3>
  // get an unused proc
  p = getFromStateListHead(&ptable.pLists.free, UNUSED);
  
  // if we successfully got a proc then proceed, otherwise return
  if (p != 0)
    goto found; // using goto similar to the original code (I think this is allowed?)   
8010456b:	90                   	nop
  #endif

  return 0;

found:
  p->state = EMBRYO;
8010456c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456f:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  #ifdef CS333_P3P4
  // add new proc to embryo list
  addToStateListHead(&ptable.pLists.embryo, EMBRYO, p); // Added for Project 3: List Management
80104576:	83 ec 04             	sub    $0x4,%esp
80104579:	ff 75 f4             	pushl  -0xc(%ebp)
8010457c:	6a 01                	push   $0x1
8010457e:	68 c8 70 11 80       	push   $0x801170c8
80104583:	e8 d3 17 00 00       	call   80105d5b <addToStateListHead>
80104588:	83 c4 10             	add    $0x10,%esp
  #endif  

  p->pid = nextpid++;
8010458b:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104590:	8d 50 01             	lea    0x1(%eax),%edx
80104593:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
80104599:	89 c2                	mov    %eax,%edx
8010459b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459e:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
801045a1:	83 ec 0c             	sub    $0xc,%esp
801045a4:	68 80 49 11 80       	push   $0x80114980
801045a9:	e8 c8 1d 00 00       	call   80106376 <release>
801045ae:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801045b1:	e8 56 e7 ff ff       	call   80102d0c <kalloc>
801045b6:	89 c2                	mov    %eax,%edx
801045b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bb:	89 50 08             	mov    %edx,0x8(%eax)
801045be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c1:	8b 40 08             	mov    0x8(%eax),%eax
801045c4:	85 c0                	test   %eax,%eax
801045c6:	75 5e                	jne    80104626 <allocproc+0x106>
    // START: Added for Project 3: List Management
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	68 80 49 11 80       	push   $0x80114980
801045d0:	e8 3a 1d 00 00       	call   8010630f <acquire>
801045d5:	83 c4 10             	add    $0x10,%esp

    // if there was an error allocating space then put the proc back on the free list
    removeFromStateList(&ptable.pLists.embryo, EMBRYO, p);
801045d8:	83 ec 04             	sub    $0x4,%esp
801045db:	ff 75 f4             	pushl  -0xc(%ebp)
801045de:	6a 01                	push   $0x1
801045e0:	68 c8 70 11 80       	push   $0x801170c8
801045e5:	e8 a4 16 00 00       	call   80105c8e <removeFromStateList>
801045ea:	83 c4 10             	add    $0x10,%esp
    p->state = UNUSED;
801045ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    addToStateListHead(&ptable.pLists.free, UNUSED, p);
801045f7:	83 ec 04             	sub    $0x4,%esp
801045fa:	ff 75 f4             	pushl  -0xc(%ebp)
801045fd:	6a 00                	push   $0x0
801045ff:	68 b8 70 11 80       	push   $0x801170b8
80104604:	e8 52 17 00 00       	call   80105d5b <addToStateListHead>
80104609:	83 c4 10             	add    $0x10,%esp

    release(&ptable.lock);
8010460c:	83 ec 0c             	sub    $0xc,%esp
8010460f:	68 80 49 11 80       	push   $0x80114980
80104614:	e8 5d 1d 00 00       	call   80106376 <release>
80104619:	83 c4 10             	add    $0x10,%esp
    // END: Added for Project 3: List Management
    #else
    p->state = UNUSED;
    #endif

    return 0;
8010461c:	b8 00 00 00 00       	mov    $0x0,%eax
80104621:	e9 9d 00 00 00       	jmp    801046c3 <allocproc+0x1a3>
  }
  sp = p->kstack + KSTACKSIZE;
80104626:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104629:	8b 40 08             	mov    0x8(%eax),%eax
8010462c:	05 00 10 00 00       	add    $0x1000,%eax
80104631:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104634:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010463e:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104641:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104645:	ba 32 7b 10 80       	mov    $0x80107b32,%edx
8010464a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010464d:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010464f:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104656:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104659:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010465c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104662:	83 ec 04             	sub    $0x4,%esp
80104665:	6a 14                	push   $0x14
80104667:	6a 00                	push   $0x0
80104669:	50                   	push   %eax
8010466a:	e8 03 1f 00 00       	call   80106572 <memset>
8010466f:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104675:	8b 40 1c             	mov    0x1c(%eax),%eax
80104678:	ba 86 53 10 80       	mov    $0x80105386,%edx
8010467d:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // Init value.  Added for Project 1: CTL-P
80104680:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80104686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104689:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total = 0; // Init value. Added for Project 2: Process Execution Time
8010468c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468f:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104696:	00 00 00 
  p->cpu_ticks_in = 0;    // Init value. Added for Project 2: Process Execution Time
80104699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010469c:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
801046a3:	00 00 00 
  p->priority = 0; 	  // Init to highest priority. Added for Project 4: Periodic Priority Adjustment
801046a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a9:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
801046b0:	00 00 00 
  p->budget = DEFAULT_BUDGET; // Init to default budget. Added for Project 4: Periodic Priority Adjustment
801046b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b6:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
801046bd:	01 00 00 

  return p;
801046c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801046c3:	c9                   	leave  
801046c4:	c3                   	ret    

801046c5 <userinit>:

// Set up first user process.
void
userinit(void)
{
801046c5:	55                   	push   %ebp
801046c6:	89 e5                	mov    %esp,%ebp
801046c8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  // START: Added for Project 3: Initializing the Lists
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
801046cb:	83 ec 0c             	sub    $0xc,%esp
801046ce:	68 80 49 11 80       	push   $0x80114980
801046d3:	e8 37 1c 00 00       	call   8010630f <acquire>
801046d8:	83 c4 10             	add    $0x10,%esp

  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; // init PromoteAtTime to first threshold. Added for Project 4: Periodic Priority Adjustment 
801046db:	a1 e0 78 11 80       	mov    0x801178e0,%eax
801046e0:	05 e8 03 00 00       	add    $0x3e8,%eax
801046e5:	a3 cc 70 11 80       	mov    %eax,0x801170cc

  // Init all proc lists to ensure starting state
  for (int i = 0; i < MAX + 1; ++i) // Added for Project 4: Periodic Priority Adjustment
801046ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801046f1:	eb 17                	jmp    8010470a <userinit+0x45>
    ptable.pLists.ready[i] = 0;
801046f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f6:	05 cc 09 00 00       	add    $0x9cc,%eax
801046fb:	c7 04 85 84 49 11 80 	movl   $0x0,-0x7feeb67c(,%eax,4)
80104702:	00 00 00 00 
  acquire(&ptable.lock);

  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; // init PromoteAtTime to first threshold. Added for Project 4: Periodic Priority Adjustment 

  // Init all proc lists to ensure starting state
  for (int i = 0; i < MAX + 1; ++i) // Added for Project 4: Periodic Priority Adjustment
80104706:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010470a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010470e:	7e e3                	jle    801046f3 <userinit+0x2e>
    ptable.pLists.ready[i] = 0;
  ptable.pLists.free = 0;
80104710:	c7 05 b8 70 11 80 00 	movl   $0x0,0x801170b8
80104717:	00 00 00 
  ptable.pLists.sleep = 0;
8010471a:	c7 05 bc 70 11 80 00 	movl   $0x0,0x801170bc
80104721:	00 00 00 
  ptable.pLists.zombie = 0;
80104724:	c7 05 c0 70 11 80 00 	movl   $0x0,0x801170c0
8010472b:	00 00 00 
  ptable.pLists.running = 0;
8010472e:	c7 05 c4 70 11 80 00 	movl   $0x0,0x801170c4
80104735:	00 00 00 
  ptable.pLists.embryo = 0;
80104738:	c7 05 c8 70 11 80 00 	movl   $0x0,0x801170c8
8010473f:	00 00 00 

  // add ptable procs to free list (added in backwards so our ctrl-p/ps print in the same order as before)
  for (int i = NPROC - 1; i >= 0; --i)
80104742:	c7 45 f0 3f 00 00 00 	movl   $0x3f,-0x10(%ebp)
80104749:	eb 2b                	jmp    80104776 <userinit+0xb1>
    addToStateListHead(&ptable.pLists.free, UNUSED, &ptable.proc[i]);
8010474b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010474e:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
80104754:	83 c0 30             	add    $0x30,%eax
80104757:	05 80 49 11 80       	add    $0x80114980,%eax
8010475c:	83 c0 04             	add    $0x4,%eax
8010475f:	83 ec 04             	sub    $0x4,%esp
80104762:	50                   	push   %eax
80104763:	6a 00                	push   $0x0
80104765:	68 b8 70 11 80       	push   $0x801170b8
8010476a:	e8 ec 15 00 00       	call   80105d5b <addToStateListHead>
8010476f:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.zombie = 0;
  ptable.pLists.running = 0;
  ptable.pLists.embryo = 0;

  // add ptable procs to free list (added in backwards so our ctrl-p/ps print in the same order as before)
  for (int i = NPROC - 1; i >= 0; --i)
80104772:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80104776:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010477a:	79 cf                	jns    8010474b <userinit+0x86>
    addToStateListHead(&ptable.pLists.free, UNUSED, &ptable.proc[i]);
    
  release(&ptable.lock);
8010477c:	83 ec 0c             	sub    $0xc,%esp
8010477f:	68 80 49 11 80       	push   $0x80114980
80104784:	e8 ed 1b 00 00       	call   80106376 <release>
80104789:	83 c4 10             	add    $0x10,%esp
  #endif
  // END: Added for Project 3: Initializing the Lists
  p = allocproc();
8010478c:	e8 8f fd ff ff       	call   80104520 <allocproc>
80104791:	89 45 ec             	mov    %eax,-0x14(%ebp)
  initproc = p;
80104794:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104797:	a3 68 d6 10 80       	mov    %eax,0x8010d668
  if((p->pgdir = setupkvm()) == 0)
8010479c:	e8 30 4a 00 00       	call   801091d1 <setupkvm>
801047a1:	89 c2                	mov    %eax,%edx
801047a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047a6:	89 50 04             	mov    %edx,0x4(%eax)
801047a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ac:	8b 40 04             	mov    0x4(%eax),%eax
801047af:	85 c0                	test   %eax,%eax
801047b1:	75 0d                	jne    801047c0 <userinit+0xfb>
    panic("userinit: out of memory?");
801047b3:	83 ec 0c             	sub    $0xc,%esp
801047b6:	68 47 9d 10 80       	push   $0x80109d47
801047bb:	e8 a6 bd ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047c0:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047c8:	8b 40 04             	mov    0x4(%eax),%eax
801047cb:	83 ec 04             	sub    $0x4,%esp
801047ce:	52                   	push   %edx
801047cf:	68 00 d5 10 80       	push   $0x8010d500
801047d4:	50                   	push   %eax
801047d5:	e8 51 4c 00 00       	call   8010942b <inituvm>
801047da:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801047dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047e0:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801047e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047e9:	8b 40 18             	mov    0x18(%eax),%eax
801047ec:	83 ec 04             	sub    $0x4,%esp
801047ef:	6a 4c                	push   $0x4c
801047f1:	6a 00                	push   $0x0
801047f3:	50                   	push   %eax
801047f4:	e8 79 1d 00 00       	call   80106572 <memset>
801047f9:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801047fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ff:	8b 40 18             	mov    0x18(%eax),%eax
80104802:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104808:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010480b:	8b 40 18             	mov    0x18(%eax),%eax
8010480e:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104814:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104817:	8b 40 18             	mov    0x18(%eax),%eax
8010481a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010481d:	8b 52 18             	mov    0x18(%edx),%edx
80104820:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104824:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104828:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010482b:	8b 40 18             	mov    0x18(%eax),%eax
8010482e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104831:	8b 52 18             	mov    0x18(%edx),%edx
80104834:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104838:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010483c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010483f:	8b 40 18             	mov    0x18(%eax),%eax
80104842:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104849:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010484c:	8b 40 18             	mov    0x18(%eax),%eax
8010484f:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104856:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104859:	8b 40 18             	mov    0x18(%eax),%eax
8010485c:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  p->uid = DEFAULT_UID; // Added for Project 2: UIDs and GIDs and PPIDs
80104863:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104866:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010486d:	00 00 00 
  p->gid = DEFAULT_GID; // Added for Project 2: UIDs and GIDs and PPIDs
80104870:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104873:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010487a:	00 00 00 


  safestrcpy(p->name, "initcode", sizeof(p->name));
8010487d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104880:	83 c0 6c             	add    $0x6c,%eax
80104883:	83 ec 04             	sub    $0x4,%esp
80104886:	6a 10                	push   $0x10
80104888:	68 60 9d 10 80       	push   $0x80109d60
8010488d:	50                   	push   %eax
8010488e:	e8 e2 1e 00 00       	call   80106775 <safestrcpy>
80104893:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104896:	83 ec 0c             	sub    $0xc,%esp
80104899:	68 69 9d 10 80       	push   $0x80109d69
8010489e:	e8 2b dd ff ff       	call   801025ce <namei>
801048a3:	83 c4 10             	add    $0x10,%esp
801048a6:	89 c2                	mov    %eax,%edx
801048a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048ab:	89 50 68             	mov    %edx,0x68(%eax)

  // START: Added for Project 3: Initializing the Lists
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
801048ae:	83 ec 0c             	sub    $0xc,%esp
801048b1:	68 80 49 11 80       	push   $0x80114980
801048b6:	e8 54 1a 00 00       	call   8010630f <acquire>
801048bb:	83 c4 10             	add    $0x10,%esp

  // remove p proc from embryo and add to ready
  removeFromStateList(&ptable.pLists.embryo, EMBRYO, p);
801048be:	83 ec 04             	sub    $0x4,%esp
801048c1:	ff 75 ec             	pushl  -0x14(%ebp)
801048c4:	6a 01                	push   $0x1
801048c6:	68 c8 70 11 80       	push   $0x801170c8
801048cb:	e8 be 13 00 00       	call   80105c8e <removeFromStateList>
801048d0:	83 c4 10             	add    $0x10,%esp
  p->state = RUNNABLE;
801048d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048d6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  addToStateListHead(&ptable.pLists.ready[0], RUNNABLE, p); // added to head of ready since nothing else is there. Modified for Project 4: Periodic Priority Adjustment
801048dd:	83 ec 04             	sub    $0x4,%esp
801048e0:	ff 75 ec             	pushl  -0x14(%ebp)
801048e3:	6a 03                	push   $0x3
801048e5:	68 b4 70 11 80       	push   $0x801170b4
801048ea:	e8 6c 14 00 00       	call   80105d5b <addToStateListHead>
801048ef:	83 c4 10             	add    $0x10,%esp

  release(&ptable.lock);
801048f2:	83 ec 0c             	sub    $0xc,%esp
801048f5:	68 80 49 11 80       	push   $0x80114980
801048fa:	e8 77 1a 00 00       	call   80106376 <release>
801048ff:	83 c4 10             	add    $0x10,%esp
  #else
  p->state = RUNNABLE;
  #endif
  // END: Added for Project 3: Initializing the Lists
}
80104902:	90                   	nop
80104903:	c9                   	leave  
80104904:	c3                   	ret    

80104905 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104905:	55                   	push   %ebp
80104906:	89 e5                	mov    %esp,%ebp
80104908:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010490b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104911:	8b 00                	mov    (%eax),%eax
80104913:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104916:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010491a:	7e 31                	jle    8010494d <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010491c:	8b 55 08             	mov    0x8(%ebp),%edx
8010491f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104922:	01 c2                	add    %eax,%edx
80104924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010492a:	8b 40 04             	mov    0x4(%eax),%eax
8010492d:	83 ec 04             	sub    $0x4,%esp
80104930:	52                   	push   %edx
80104931:	ff 75 f4             	pushl  -0xc(%ebp)
80104934:	50                   	push   %eax
80104935:	e8 3e 4c 00 00       	call   80109578 <allocuvm>
8010493a:	83 c4 10             	add    $0x10,%esp
8010493d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104940:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104944:	75 3e                	jne    80104984 <growproc+0x7f>
      return -1;
80104946:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010494b:	eb 59                	jmp    801049a6 <growproc+0xa1>
  } else if(n < 0){
8010494d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104951:	79 31                	jns    80104984 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104953:	8b 55 08             	mov    0x8(%ebp),%edx
80104956:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104959:	01 c2                	add    %eax,%edx
8010495b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104961:	8b 40 04             	mov    0x4(%eax),%eax
80104964:	83 ec 04             	sub    $0x4,%esp
80104967:	52                   	push   %edx
80104968:	ff 75 f4             	pushl  -0xc(%ebp)
8010496b:	50                   	push   %eax
8010496c:	e8 d0 4c 00 00       	call   80109641 <deallocuvm>
80104971:	83 c4 10             	add    $0x10,%esp
80104974:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104977:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010497b:	75 07                	jne    80104984 <growproc+0x7f>
      return -1;
8010497d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104982:	eb 22                	jmp    801049a6 <growproc+0xa1>
  }
  proc->sz = sz;
80104984:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010498d:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010498f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104995:	83 ec 0c             	sub    $0xc,%esp
80104998:	50                   	push   %eax
80104999:	e8 1a 49 00 00       	call   801092b8 <switchuvm>
8010499e:	83 c4 10             	add    $0x10,%esp
  return 0;
801049a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049a6:	c9                   	leave  
801049a7:	c3                   	ret    

801049a8 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801049a8:	55                   	push   %ebp
801049a9:	89 e5                	mov    %esp,%ebp
801049ab:	57                   	push   %edi
801049ac:	56                   	push   %esi
801049ad:	53                   	push   %ebx
801049ae:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801049b1:	e8 6a fb ff ff       	call   80104520 <allocproc>
801049b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049bd:	75 0a                	jne    801049c9 <fork+0x21>
    return -1;
801049bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049c4:	e9 06 02 00 00       	jmp    80104bcf <fork+0x227>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801049c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049cf:	8b 10                	mov    (%eax),%edx
801049d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d7:	8b 40 04             	mov    0x4(%eax),%eax
801049da:	83 ec 08             	sub    $0x8,%esp
801049dd:	52                   	push   %edx
801049de:	50                   	push   %eax
801049df:	e8 fb 4d 00 00       	call   801097df <copyuvm>
801049e4:	83 c4 10             	add    $0x10,%esp
801049e7:	89 c2                	mov    %eax,%edx
801049e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ec:	89 50 04             	mov    %edx,0x4(%eax)
801049ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049f2:	8b 40 04             	mov    0x4(%eax),%eax
801049f5:	85 c0                	test   %eax,%eax
801049f7:	75 7a                	jne    80104a73 <fork+0xcb>
    kfree(np->kstack);
801049f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049fc:	8b 40 08             	mov    0x8(%eax),%eax
801049ff:	83 ec 0c             	sub    $0xc,%esp
80104a02:	50                   	push   %eax
80104a03:	e8 67 e2 ff ff       	call   80102c6f <kfree>
80104a08:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    
    // START: Added for Project 3: List Management
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104a15:	83 ec 0c             	sub    $0xc,%esp
80104a18:	68 80 49 11 80       	push   $0x80114980
80104a1d:	e8 ed 18 00 00       	call   8010630f <acquire>
80104a22:	83 c4 10             	add    $0x10,%esp

    // if copyuvm failed then put np back in the free list from embryo
    removeFromStateList(&ptable.pLists.embryo, EMBRYO, np);
80104a25:	83 ec 04             	sub    $0x4,%esp
80104a28:	ff 75 e0             	pushl  -0x20(%ebp)
80104a2b:	6a 01                	push   $0x1
80104a2d:	68 c8 70 11 80       	push   $0x801170c8
80104a32:	e8 57 12 00 00       	call   80105c8e <removeFromStateList>
80104a37:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    addToStateListHead(&ptable.pLists.free, UNUSED, np);
80104a44:	83 ec 04             	sub    $0x4,%esp
80104a47:	ff 75 e0             	pushl  -0x20(%ebp)
80104a4a:	6a 00                	push   $0x0
80104a4c:	68 b8 70 11 80       	push   $0x801170b8
80104a51:	e8 05 13 00 00       	call   80105d5b <addToStateListHead>
80104a56:	83 c4 10             	add    $0x10,%esp

    release(&ptable.lock);
80104a59:	83 ec 0c             	sub    $0xc,%esp
80104a5c:	68 80 49 11 80       	push   $0x80114980
80104a61:	e8 10 19 00 00       	call   80106376 <release>
80104a66:	83 c4 10             	add    $0x10,%esp
    #else
    np->state = UNUSED;
    #endif
    // END: Added for Project 3: List Management
    
    return -1;
80104a69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a6e:	e9 5c 01 00 00       	jmp    80104bcf <fork+0x227>
  }
  np->sz = proc->sz;
80104a73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a79:	8b 10                	mov    (%eax),%edx
80104a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a7e:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104a80:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a8a:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a90:	8b 50 18             	mov    0x18(%eax),%edx
80104a93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a99:	8b 40 18             	mov    0x18(%eax),%eax
80104a9c:	89 c3                	mov    %eax,%ebx
80104a9e:	b8 13 00 00 00       	mov    $0x13,%eax
80104aa3:	89 d7                	mov    %edx,%edi
80104aa5:	89 de                	mov    %ebx,%esi
80104aa7:	89 c1                	mov    %eax,%ecx
80104aa9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->uid = proc->uid; // Added for Project 2: UIDs and GIDs and PPIDs
80104aab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab1:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104ab7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aba:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid; // Added for Project 2: UIDs and GIDs and PPIDs
80104ac0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104acf:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104ad5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ad8:	8b 40 18             	mov    0x18(%eax),%eax
80104adb:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104ae2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104ae9:	eb 43                	jmp    80104b2e <fork+0x186>
    if(proc->ofile[i])
80104aeb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104af4:	83 c2 08             	add    $0x8,%edx
80104af7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104afb:	85 c0                	test   %eax,%eax
80104afd:	74 2b                	je     80104b2a <fork+0x182>
      np->ofile[i] = filedup(proc->ofile[i]);
80104aff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b08:	83 c2 08             	add    $0x8,%edx
80104b0b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b0f:	83 ec 0c             	sub    $0xc,%esp
80104b12:	50                   	push   %eax
80104b13:	e8 8e c5 ff ff       	call   801010a6 <filedup>
80104b18:	83 c4 10             	add    $0x10,%esp
80104b1b:	89 c1                	mov    %eax,%ecx
80104b1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b23:	83 c2 08             	add    $0x8,%edx
80104b26:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np->gid = proc->gid; // Added for Project 2: UIDs and GIDs and PPIDs

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104b2a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b2e:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b32:	7e b7                	jle    80104aeb <fork+0x143>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104b34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3a:	8b 40 68             	mov    0x68(%eax),%eax
80104b3d:	83 ec 0c             	sub    $0xc,%esp
80104b40:	50                   	push   %eax
80104b41:	e8 90 ce ff ff       	call   801019d6 <idup>
80104b46:	83 c4 10             	add    $0x10,%esp
80104b49:	89 c2                	mov    %eax,%edx
80104b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b4e:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104b51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b57:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b5d:	83 c0 6c             	add    $0x6c,%eax
80104b60:	83 ec 04             	sub    $0x4,%esp
80104b63:	6a 10                	push   $0x10
80104b65:	52                   	push   %edx
80104b66:	50                   	push   %eax
80104b67:	e8 09 1c 00 00       	call   80106775 <safestrcpy>
80104b6c:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104b6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b72:	8b 40 10             	mov    0x10(%eax),%eax
80104b75:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // START: Added for Project 3: List Management
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
80104b78:	83 ec 0c             	sub    $0xc,%esp
80104b7b:	68 80 49 11 80       	push   $0x80114980
80104b80:	e8 8a 17 00 00       	call   8010630f <acquire>
80104b85:	83 c4 10             	add    $0x10,%esp

  // move np proc from embryo to ready
  removeFromStateList(&ptable.pLists.embryo, EMBRYO, np);
80104b88:	83 ec 04             	sub    $0x4,%esp
80104b8b:	ff 75 e0             	pushl  -0x20(%ebp)
80104b8e:	6a 01                	push   $0x1
80104b90:	68 c8 70 11 80       	push   $0x801170c8
80104b95:	e8 f4 10 00 00       	call   80105c8e <removeFromStateList>
80104b9a:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104b9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ba0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  addToStateListTail(&ptable.pLists.ready[0], RUNNABLE, np); // Modified for Project 4: Periodic Priority Adjustment
80104ba7:	83 ec 04             	sub    $0x4,%esp
80104baa:	ff 75 e0             	pushl  -0x20(%ebp)
80104bad:	6a 03                	push   $0x3
80104baf:	68 b4 70 11 80       	push   $0x801170b4
80104bb4:	e8 d9 11 00 00       	call   80105d92 <addToStateListTail>
80104bb9:	83 c4 10             	add    $0x10,%esp

  release(&ptable.lock);
80104bbc:	83 ec 0c             	sub    $0xc,%esp
80104bbf:	68 80 49 11 80       	push   $0x80114980
80104bc4:	e8 ad 17 00 00       	call   80106376 <release>
80104bc9:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
  release(&ptable.lock);
  #endif
  // END: Added for Project 3: List Management
  
  return pid;
80104bcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104bcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bd2:	5b                   	pop    %ebx
80104bd3:	5e                   	pop    %esi
80104bd4:	5f                   	pop    %edi
80104bd5:	5d                   	pop    %ebp
80104bd6:	c3                   	ret    

80104bd7 <exit>:
  panic("zombie exit");
}
#else
void
exit(void) // Added for Project 3: List Management
{
80104bd7:	55                   	push   %ebp
80104bd8:	89 e5                	mov    %esp,%ebp
80104bda:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = 0;
80104bdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int fd;
  uint isFound = 0; // can't use bool, would need to define but I will just use uint instead
80104be4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  if(proc == initproc)
80104beb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bf2:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104bf7:	39 c2                	cmp    %eax,%edx
80104bf9:	75 0d                	jne    80104c08 <exit+0x31>
    panic("init exiting");
80104bfb:	83 ec 0c             	sub    $0xc,%esp
80104bfe:	68 6b 9d 10 80       	push   $0x80109d6b
80104c03:	e8 5e b9 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c08:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c0f:	eb 48                	jmp    80104c59 <exit+0x82>
    if(proc->ofile[fd]){
80104c11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c17:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c1a:	83 c2 08             	add    $0x8,%edx
80104c1d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c21:	85 c0                	test   %eax,%eax
80104c23:	74 30                	je     80104c55 <exit+0x7e>
      fileclose(proc->ofile[fd]);
80104c25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c2e:	83 c2 08             	add    $0x8,%edx
80104c31:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c35:	83 ec 0c             	sub    $0xc,%esp
80104c38:	50                   	push   %eax
80104c39:	e8 b9 c4 ff ff       	call   801010f7 <fileclose>
80104c3e:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104c41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c47:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c4a:	83 c2 08             	add    $0x8,%edx
80104c4d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104c54:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c55:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c59:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c5d:	7e b2                	jle    80104c11 <exit+0x3a>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104c5f:	e8 8f e9 ff ff       	call   801035f3 <begin_op>
  iput(proc->cwd);
80104c64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c6a:	8b 40 68             	mov    0x68(%eax),%eax
80104c6d:	83 ec 0c             	sub    $0xc,%esp
80104c70:	50                   	push   %eax
80104c71:	e8 6a cf ff ff       	call   80101be0 <iput>
80104c76:	83 c4 10             	add    $0x10,%esp
  end_op();
80104c79:	e8 01 ea ff ff       	call   8010367f <end_op>
  proc->cwd = 0;
80104c7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c84:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104c8b:	83 ec 0c             	sub    $0xc,%esp
80104c8e:	68 80 49 11 80       	push   $0x80114980
80104c93:	e8 77 16 00 00       	call   8010630f <acquire>
80104c98:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104c9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca1:	8b 40 14             	mov    0x14(%eax),%eax
80104ca4:	83 ec 0c             	sub    $0xc,%esp
80104ca7:	50                   	push   %eax
80104ca8:	e8 f6 07 00 00       	call   801054a3 <wakeup1>
80104cad:	83 c4 10             	add    $0x10,%esp
  // START: Added for Project 3: List Managament

  // the below code is super ugly, but I had issues using a helper function to do this work by passing proc to it... so I had to put the code here
  
  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){
80104cb0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80104cb7:	eb 49                	jmp    80104d02 <exit+0x12b>
    p = ptable.pLists.ready[i];
80104cb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104cbc:	05 cc 09 00 00       	add    $0x9cc,%eax
80104cc1:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80104cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p != 0 && isFound != 1){
80104ccb:	eb 25                	jmp    80104cf2 <exit+0x11b>
      if (p->parent == proc)
80104ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd0:	8b 50 14             	mov    0x14(%eax),%edx
80104cd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cd9:	39 c2                	cmp    %eax,%edx
80104cdb:	75 09                	jne    80104ce6 <exit+0x10f>
        isFound = 1;
80104cdd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
80104ce4:	eb 0c                	jmp    80104cf2 <exit+0x11b>
      else
        p = p->next;
80104ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // the below code is super ugly, but I had issues using a helper function to do this work by passing proc to it... so I had to put the code here
  
  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){
    p = ptable.pLists.ready[i];
    while (p != 0 && isFound != 1){
80104cf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104cf6:	74 06                	je     80104cfe <exit+0x127>
80104cf8:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
80104cfc:	75 cf                	jne    80104ccd <exit+0xf6>
  // START: Added for Project 3: List Managament

  // the below code is super ugly, but I had issues using a helper function to do this work by passing proc to it... so I had to put the code here
  
  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){
80104cfe:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80104d02:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80104d06:	7e b1                	jle    80104cb9 <exit+0xe2>
      else
        p = p->next;
    }
  }

  if (isFound != 1){
80104d08:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
80104d0c:	74 3b                	je     80104d49 <exit+0x172>
  // search through sleep list
    p = ptable.pLists.sleep;
80104d0e:	a1 bc 70 11 80       	mov    0x801170bc,%eax
80104d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p != 0 && isFound != 1){
80104d16:	eb 25                	jmp    80104d3d <exit+0x166>
      if (p->parent == proc)
80104d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d1b:	8b 50 14             	mov    0x14(%eax),%edx
80104d1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d24:	39 c2                	cmp    %eax,%edx
80104d26:	75 09                	jne    80104d31 <exit+0x15a>
        isFound = 1;
80104d28:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
80104d2f:	eb 0c                	jmp    80104d3d <exit+0x166>
      else
        p = p->next;
80104d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d34:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  if (isFound != 1){
  // search through sleep list
    p = ptable.pLists.sleep;
    while (p != 0 && isFound != 1){
80104d3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d41:	74 06                	je     80104d49 <exit+0x172>
80104d43:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
80104d47:	75 cf                	jne    80104d18 <exit+0x141>
      else
        p = p->next;
    }
  }

  if (isFound != 1){
80104d49:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
80104d4d:	74 3b                	je     80104d8a <exit+0x1b3>
  // search through zombie list
    p = ptable.pLists.zombie;
80104d4f:	a1 c0 70 11 80       	mov    0x801170c0,%eax
80104d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p != 0 && isFound != 1){
80104d57:	eb 25                	jmp    80104d7e <exit+0x1a7>
      if (p->parent == proc)
80104d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d5c:	8b 50 14             	mov    0x14(%eax),%edx
80104d5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d65:	39 c2                	cmp    %eax,%edx
80104d67:	75 09                	jne    80104d72 <exit+0x19b>
        isFound = 1;
80104d69:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
80104d70:	eb 0c                	jmp    80104d7e <exit+0x1a7>
      else
        p = p->next;
80104d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d75:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  if (isFound != 1){
  // search through zombie list
    p = ptable.pLists.zombie;
    while (p != 0 && isFound != 1){
80104d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d82:	74 06                	je     80104d8a <exit+0x1b3>
80104d84:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
80104d88:	75 cf                	jne    80104d59 <exit+0x182>
      else
        p = p->next;
    }
  }

  if (isFound != 1){
80104d8a:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
80104d8e:	74 3b                	je     80104dcb <exit+0x1f4>
  // search through running list
    p = ptable.pLists.running;
80104d90:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80104d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p != 0 && isFound != 1){
80104d98:	eb 25                	jmp    80104dbf <exit+0x1e8>
      if (p->parent == proc)
80104d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9d:	8b 50 14             	mov    0x14(%eax),%edx
80104da0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da6:	39 c2                	cmp    %eax,%edx
80104da8:	75 09                	jne    80104db3 <exit+0x1dc>
        isFound = 1;
80104daa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
80104db1:	eb 0c                	jmp    80104dbf <exit+0x1e8>
      else
        p = p->next;
80104db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  if (isFound != 1){
  // search through running list
    p = ptable.pLists.running;
    while (p != 0 && isFound != 1){
80104dbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104dc3:	74 06                	je     80104dcb <exit+0x1f4>
80104dc5:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
80104dc9:	75 cf                	jne    80104d9a <exit+0x1c3>
      else
        p = p->next;
    }
  }

  if (isFound != 1){
80104dcb:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
80104dcf:	74 3b                	je     80104e0c <exit+0x235>
  // search through embryo list
    p = ptable.pLists.embryo;
80104dd1:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80104dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p != 0 && isFound != 1){
80104dd9:	eb 25                	jmp    80104e00 <exit+0x229>
      if (p->parent == proc)
80104ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dde:	8b 50 14             	mov    0x14(%eax),%edx
80104de1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de7:	39 c2                	cmp    %eax,%edx
80104de9:	75 09                	jne    80104df4 <exit+0x21d>
        isFound = 1;
80104deb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
80104df2:	eb 0c                	jmp    80104e00 <exit+0x229>
      else
        p = p->next;
80104df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  if (isFound != 1){
  // search through embryo list
    p = ptable.pLists.embryo;
    while (p != 0 && isFound != 1){
80104e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e04:	74 06                	je     80104e0c <exit+0x235>
80104e06:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
80104e0a:	75 cf                	jne    80104ddb <exit+0x204>
      else
        p = p->next;
    }
  }

   if (p != 0 && isFound == 1){
80104e0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e10:	74 3e                	je     80104e50 <exit+0x279>
80104e12:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
80104e16:	75 38                	jne    80104e50 <exit+0x279>
    // Pass abandoned children to init.
    if(p->parent == proc){
80104e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e1b:	8b 50 14             	mov    0x14(%eax),%edx
80104e1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e24:	39 c2                	cmp    %eax,%edx
80104e26:	75 28                	jne    80104e50 <exit+0x279>
      p->parent = initproc;
80104e28:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e31:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e37:	8b 40 0c             	mov    0xc(%eax),%eax
80104e3a:	83 f8 05             	cmp    $0x5,%eax
80104e3d:	75 11                	jne    80104e50 <exit+0x279>
        wakeup1(initproc);
80104e3f:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104e44:	83 ec 0c             	sub    $0xc,%esp
80104e47:	50                   	push   %eax
80104e48:	e8 56 06 00 00       	call   801054a3 <wakeup1>
80104e4d:	83 c4 10             	add    $0x10,%esp
    }
  }

  // Jump into the scheduler, never to return.
  // Move process p from running list to zombie list
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
80104e50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e56:	83 ec 04             	sub    $0x4,%esp
80104e59:	50                   	push   %eax
80104e5a:	6a 04                	push   $0x4
80104e5c:	68 c4 70 11 80       	push   $0x801170c4
80104e61:	e8 28 0e 00 00       	call   80105c8e <removeFromStateList>
80104e66:	83 c4 10             	add    $0x10,%esp
  proc->state = ZOMBIE;
80104e69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e6f:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  addToStateListHead(&ptable.pLists.zombie, ZOMBIE, proc);
80104e76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7c:	83 ec 04             	sub    $0x4,%esp
80104e7f:	50                   	push   %eax
80104e80:	6a 05                	push   $0x5
80104e82:	68 c0 70 11 80       	push   $0x801170c0
80104e87:	e8 cf 0e 00 00       	call   80105d5b <addToStateListHead>
80104e8c:	83 c4 10             	add    $0x10,%esp
  // END: Added for Project 3: List Management

  sched();
80104e8f:	e8 99 02 00 00       	call   8010512d <sched>
  panic("zombie exit");
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	68 78 9d 10 80       	push   $0x80109d78
80104e9c:	e8 c5 b6 ff ff       	call   80100566 <panic>

80104ea1 <wait>:
  }
}
#else
int
wait(void) // Added for Project 3: List Management
{
80104ea1:	55                   	push   %ebp
80104ea2:	89 e5                	mov    %esp,%ebp
80104ea4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = 0;
80104ea7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int havekids, pid;

  acquire(&ptable.lock);
80104eae:	83 ec 0c             	sub    $0xc,%esp
80104eb1:	68 80 49 11 80       	push   $0x80114980
80104eb6:	e8 54 14 00 00       	call   8010630f <acquire>
80104ebb:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104ebe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ // TODO: Switch to using lists (tried using same method as in exit but it wouldn't run usertests so I've left it like this since it works)
80104ec5:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80104ecc:	e9 d7 00 00 00       	jmp    80104fa8 <wait+0x107>
      if(p->parent != proc)
80104ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed4:	8b 50 14             	mov    0x14(%eax),%edx
80104ed7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104edd:	39 c2                	cmp    %eax,%edx
80104edf:	0f 85 bb 00 00 00    	jne    80104fa0 <wait+0xff>
        continue;
      havekids = 1;
80104ee5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eef:	8b 40 0c             	mov    0xc(%eax),%eax
80104ef2:	83 f8 05             	cmp    $0x5,%eax
80104ef5:	0f 85 a6 00 00 00    	jne    80104fa1 <wait+0x100>
        // Found one.
        pid = p->pid;
80104efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104efe:	8b 40 10             	mov    0x10(%eax),%eax
80104f01:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f07:	8b 40 08             	mov    0x8(%eax),%eax
80104f0a:	83 ec 0c             	sub    $0xc,%esp
80104f0d:	50                   	push   %eax
80104f0e:	e8 5c dd ff ff       	call   80102c6f <kfree>
80104f13:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f19:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f23:	8b 40 04             	mov    0x4(%eax),%eax
80104f26:	83 ec 0c             	sub    $0xc,%esp
80104f29:	50                   	push   %eax
80104f2a:	e8 cf 47 00 00       	call   801096fe <freevm>
80104f2f:	83 c4 10             	add    $0x10,%esp

        // START: Added for Project 3: List Management
        
        // Move proc p from zombie to free
        removeFromStateList(&ptable.pLists.zombie, ZOMBIE, p);
80104f32:	83 ec 04             	sub    $0x4,%esp
80104f35:	ff 75 f4             	pushl  -0xc(%ebp)
80104f38:	6a 05                	push   $0x5
80104f3a:	68 c0 70 11 80       	push   $0x801170c0
80104f3f:	e8 4a 0d 00 00       	call   80105c8e <removeFromStateList>
80104f44:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        addToStateListHead(&ptable.pLists.free, UNUSED, p);
80104f51:	83 ec 04             	sub    $0x4,%esp
80104f54:	ff 75 f4             	pushl  -0xc(%ebp)
80104f57:	6a 00                	push   $0x0
80104f59:	68 b8 70 11 80       	push   $0x801170b8
80104f5e:	e8 f8 0d 00 00       	call   80105d5b <addToStateListHead>
80104f63:	83 c4 10             	add    $0x10,%esp
        // END: Added for Project 3: List Management

        p->pid = 0;
80104f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f69:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f73:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f7d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f84:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104f8b:	83 ec 0c             	sub    $0xc,%esp
80104f8e:	68 80 49 11 80       	push   $0x80114980
80104f93:	e8 de 13 00 00       	call   80106376 <release>
80104f98:	83 c4 10             	add    $0x10,%esp
        return pid;
80104f9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f9e:	eb 5b                	jmp    80104ffb <wait+0x15a>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ // TODO: Switch to using lists (tried using same method as in exit but it wouldn't run usertests so I've left it like this since it works)
      if(p->parent != proc)
        continue;
80104fa0:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ // TODO: Switch to using lists (tried using same method as in exit but it wouldn't run usertests so I've left it like this since it works)
80104fa1:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104fa8:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80104faf:	0f 82 1c ff ff ff    	jb     80104ed1 <wait+0x30>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104fb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104fb9:	74 0d                	je     80104fc8 <wait+0x127>
80104fbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fc1:	8b 40 24             	mov    0x24(%eax),%eax
80104fc4:	85 c0                	test   %eax,%eax
80104fc6:	74 17                	je     80104fdf <wait+0x13e>
      release(&ptable.lock);
80104fc8:	83 ec 0c             	sub    $0xc,%esp
80104fcb:	68 80 49 11 80       	push   $0x80114980
80104fd0:	e8 a1 13 00 00       	call   80106376 <release>
80104fd5:	83 c4 10             	add    $0x10,%esp
      return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	eb 1c                	jmp    80104ffb <wait+0x15a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104fdf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fe5:	83 ec 08             	sub    $0x8,%esp
80104fe8:	68 80 49 11 80       	push   $0x80114980
80104fed:	50                   	push   %eax
80104fee:	e8 d9 03 00 00       	call   801053cc <sleep>
80104ff3:	83 c4 10             	add    $0x10,%esp
  }
80104ff6:	e9 c3 fe ff ff       	jmp    80104ebe <wait+0x1d>
}
80104ffb:	c9                   	leave  
80104ffc:	c3                   	ret    

80104ffd <scheduler>:
}

#else
void
scheduler(void) // Added for Project 3: List Management
{
80104ffd:	55                   	push   %ebp
80104ffe:	89 e5                	mov    %esp,%ebp
80105000:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
80105003:	e8 f3 f4 ff ff       	call   801044fb <sti>

    idle = 1;  // assume idle unless we schedule a process
80105008:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010500f:	83 ec 0c             	sub    $0xc,%esp
80105012:	68 80 49 11 80       	push   $0x80114980
80105017:	e8 f3 12 00 00       	call   8010630f <acquire>
8010501c:	83 c4 10             	add    $0x10,%esp

    // START: Added for Project 4: Periodic Priority Adjustment
    if (ticks >= ptable.PromoteAtTime){ // Check if we hit PromoteAtTime threshold
8010501f:	8b 15 cc 70 11 80    	mov    0x801170cc,%edx
80105025:	a1 e0 78 11 80       	mov    0x801178e0,%eax
8010502a:	39 c2                	cmp    %eax,%edx
8010502c:	77 14                	ja     80105042 <scheduler+0x45>
      doPeriodicPromotion(); // do periodic promotion of all process on ready, sleeping, and running lists
8010502e:	e8 6a 11 00 00       	call   8010619d <doPeriodicPromotion>
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; // update PromoteAtTime threshold after we've done the promotions
80105033:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80105038:	05 e8 03 00 00       	add    $0x3e8,%eax
8010503d:	a3 cc 70 11 80       	mov    %eax,0x801170cc
    // END: Added for Project 4: Periodic Priority Adjustment

    // START: Added for Project 3: List Management

    // get ready proc p and add it to running list (if a ready proc exists)
    for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
80105042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105049:	e9 ac 00 00 00       	jmp    801050fa <scheduler+0xfd>

      p = getFromStateListHead(&ptable.pLists.ready[i], RUNNABLE); // get a proc from certain priority list (null if empty)    
8010504e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105051:	05 cc 09 00 00       	add    $0x9cc,%eax
80105056:	c1 e0 02             	shl    $0x2,%eax
80105059:	05 80 49 11 80       	add    $0x80114980,%eax
8010505e:	83 c0 04             	add    $0x4,%eax
80105061:	83 ec 08             	sub    $0x8,%esp
80105064:	6a 03                	push   $0x3
80105066:	50                   	push   %eax
80105067:	e8 a7 0c 00 00       	call   80105d13 <getFromStateListHead>
8010506c:	83 c4 10             	add    $0x10,%esp
8010506f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if (p != 0){ // if a proc is found then put on running list
80105072:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105076:	74 7e                	je     801050f6 <scheduler+0xf9>

        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
        idle = 0;  // not idle this timeslice
80105078:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        proc = p;
8010507f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105082:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
        switchuvm(p);
80105088:	83 ec 0c             	sub    $0xc,%esp
8010508b:	ff 75 ec             	pushl  -0x14(%ebp)
8010508e:	e8 25 42 00 00       	call   801092b8 <switchuvm>
80105093:	83 c4 10             	add    $0x10,%esp
      
        // switch proc p from ready to running list
        p->state = RUNNING;
80105096:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105099:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
        addToStateListHead(&ptable.pLists.running, RUNNING, p);
801050a0:	83 ec 04             	sub    $0x4,%esp
801050a3:	ff 75 ec             	pushl  -0x14(%ebp)
801050a6:	6a 04                	push   $0x4
801050a8:	68 c4 70 11 80       	push   $0x801170c4
801050ad:	e8 a9 0c 00 00       	call   80105d5b <addToStateListHead>
801050b2:	83 c4 10             	add    $0x10,%esp
        // END: Added for Project 3: List Management

        p->cpu_ticks_in = ticks; // set tick that proc enters CPU. Added for Project 2: Process Execution Time
801050b5:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
801050bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050be:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)

        swtch(&cpu->scheduler, proc->context);
801050c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050ca:	8b 40 1c             	mov    0x1c(%eax),%eax
801050cd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050d4:	83 c2 04             	add    $0x4,%edx
801050d7:	83 ec 08             	sub    $0x8,%esp
801050da:	50                   	push   %eax
801050db:	52                   	push   %edx
801050dc:	e8 05 17 00 00       	call   801067e6 <swtch>
801050e1:	83 c4 10             	add    $0x10,%esp
        switchkvm();
801050e4:	e8 b2 41 00 00       	call   8010929b <switchkvm>

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0;
801050e9:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801050f0:	00 00 00 00 
        
        break; // break out of for loop now that we've found a proc. Added for Project 4: Periodic Priority Adjustment
801050f4:	eb 0e                	jmp    80105104 <scheduler+0x107>
    // END: Added for Project 4: Periodic Priority Adjustment

    // START: Added for Project 3: List Management

    // get ready proc p and add it to running list (if a ready proc exists)
    for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
801050f6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801050fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801050fe:	0f 8e 4a ff ff ff    	jle    8010504e <scheduler+0x51>
        proc = 0;
        
        break; // break out of for loop now that we've found a proc. Added for Project 4: Periodic Priority Adjustment
      }
    }
    release(&ptable.lock);
80105104:	83 ec 0c             	sub    $0xc,%esp
80105107:	68 80 49 11 80       	push   $0x80114980
8010510c:	e8 65 12 00 00       	call   80106376 <release>
80105111:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
80105114:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105118:	0f 84 e5 fe ff ff    	je     80105003 <scheduler+0x6>
      sti();
8010511e:	e8 d8 f3 ff ff       	call   801044fb <sti>
      hlt();
80105123:	e8 bc f3 ff ff       	call   801044e4 <hlt>
    }
  }
80105128:	e9 d6 fe ff ff       	jmp    80105003 <scheduler+0x6>

8010512d <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
8010512d:	55                   	push   %ebp
8010512e:	89 e5                	mov    %esp,%ebp
80105130:	53                   	push   %ebx
80105131:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80105134:	83 ec 0c             	sub    $0xc,%esp
80105137:	68 80 49 11 80       	push   $0x80114980
8010513c:	e8 01 13 00 00       	call   80106442 <holding>
80105141:	83 c4 10             	add    $0x10,%esp
80105144:	85 c0                	test   %eax,%eax
80105146:	75 0d                	jne    80105155 <sched+0x28>
    panic("sched ptable.lock");
80105148:	83 ec 0c             	sub    $0xc,%esp
8010514b:	68 84 9d 10 80       	push   $0x80109d84
80105150:	e8 11 b4 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80105155:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010515b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105161:	83 f8 01             	cmp    $0x1,%eax
80105164:	74 0d                	je     80105173 <sched+0x46>
    panic("sched locks");
80105166:	83 ec 0c             	sub    $0xc,%esp
80105169:	68 96 9d 10 80       	push   $0x80109d96
8010516e:	e8 f3 b3 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80105173:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105179:	8b 40 0c             	mov    0xc(%eax),%eax
8010517c:	83 f8 04             	cmp    $0x4,%eax
8010517f:	75 0d                	jne    8010518e <sched+0x61>
    panic("sched running");
80105181:	83 ec 0c             	sub    $0xc,%esp
80105184:	68 a2 9d 10 80       	push   $0x80109da2
80105189:	e8 d8 b3 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
8010518e:	e8 58 f3 ff ff       	call   801044eb <readeflags>
80105193:	25 00 02 00 00       	and    $0x200,%eax
80105198:	85 c0                	test   %eax,%eax
8010519a:	74 0d                	je     801051a9 <sched+0x7c>
    panic("sched interruptible");
8010519c:	83 ec 0c             	sub    $0xc,%esp
8010519f:	68 b0 9d 10 80       	push   $0x80109db0
801051a4:	e8 bd b3 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
801051a9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051af:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801051b5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // add time delta to total CPU time. Added for Project 2: Process Execution Time
801051b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051be:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051c5:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801051cb:	8b 1d e0 78 11 80    	mov    0x801178e0,%ebx
801051d1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051d8:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801051de:	29 d3                	sub    %edx,%ebx
801051e0:	89 da                	mov    %ebx,%edx
801051e2:	01 ca                	add    %ecx,%edx
801051e4:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  
  // START: Added for Project 4: Periodic Priority Adjustment
  proc->budget -= ticks - proc->cpu_ticks_in; // Reduce used CPU budget
801051ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051f0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051f7:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
801051fd:	89 d3                	mov    %edx,%ebx
801051ff:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105206:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
8010520c:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105212:	29 d1                	sub    %edx,%ecx
80105214:	89 ca                	mov    %ecx,%edx
80105216:	01 da                	add    %ebx,%edx
80105218:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)

  // if budget is expended (and the proc is not at the lowest priority) then demote and reset budget
  if (proc->budget <= 0 && proc->priority != MAX){
8010521e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105224:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010522a:	85 c0                	test   %eax,%eax
8010522c:	0f 8f b2 00 00 00    	jg     801052e4 <sched+0x1b7>
80105232:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105238:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010523e:	85 c0                	test   %eax,%eax
80105240:	0f 84 9e 00 00 00    	je     801052e4 <sched+0x1b7>
 
    // if proc is in a ready list then we need to switch its list to the lower priority one
    if (proc->state == RUNNABLE){
80105246:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010524c:	8b 40 0c             	mov    0xc(%eax),%eax
8010524f:	83 f8 03             	cmp    $0x3,%eax
80105252:	75 6b                	jne    801052bf <sched+0x192>
      removeFromStateList(&ptable.pLists.ready[proc->priority], RUNNABLE, proc);
80105254:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010525a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105261:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105267:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
8010526d:	c1 e2 02             	shl    $0x2,%edx
80105270:	81 c2 80 49 11 80    	add    $0x80114980,%edx
80105276:	83 c2 04             	add    $0x4,%edx
80105279:	83 ec 04             	sub    $0x4,%esp
8010527c:	50                   	push   %eax
8010527d:	6a 03                	push   $0x3
8010527f:	52                   	push   %edx
80105280:	e8 09 0a 00 00       	call   80105c8e <removeFromStateList>
80105285:	83 c4 10             	add    $0x10,%esp
      addToStateListTail(&ptable.pLists.ready[proc->priority + 1], RUNNABLE, proc);
80105288:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010528e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105295:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
8010529b:	83 c2 01             	add    $0x1,%edx
8010529e:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
801052a4:	c1 e2 02             	shl    $0x2,%edx
801052a7:	81 c2 80 49 11 80    	add    $0x80114980,%edx
801052ad:	83 c2 04             	add    $0x4,%edx
801052b0:	83 ec 04             	sub    $0x4,%esp
801052b3:	50                   	push   %eax
801052b4:	6a 03                	push   $0x3
801052b6:	52                   	push   %edx
801052b7:	e8 d6 0a 00 00       	call   80105d92 <addToStateListTail>
801052bc:	83 c4 10             	add    $0x10,%esp
    }
    
    proc->priority++;
801052bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052c5:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
801052cb:	83 c2 01             	add    $0x1,%edx
801052ce:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    proc->budget = DEFAULT_BUDGET;
801052d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052da:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
801052e1:	01 00 00 
  }
  // END: Added for Project 4: Periodic Priority Adjustment
  
  swtch(&proc->context, cpu->scheduler);
801052e4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052ea:	8b 40 04             	mov    0x4(%eax),%eax
801052ed:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052f4:	83 c2 1c             	add    $0x1c,%edx
801052f7:	83 ec 08             	sub    $0x8,%esp
801052fa:	50                   	push   %eax
801052fb:	52                   	push   %edx
801052fc:	e8 e5 14 00 00       	call   801067e6 <swtch>
80105301:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80105304:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010530a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010530d:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105313:	90                   	nop
80105314:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105317:	c9                   	leave  
80105318:	c3                   	ret    

80105319 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105319:	55                   	push   %ebp
8010531a:	89 e5                	mov    %esp,%ebp
8010531c:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010531f:	83 ec 0c             	sub    $0xc,%esp
80105322:	68 80 49 11 80       	push   $0x80114980
80105327:	e8 e3 0f 00 00       	call   8010630f <acquire>
8010532c:	83 c4 10             	add    $0x10,%esp

  // START: Added for Project 3: List Management
  #ifdef CS333_P3P4
  // move proc from running to ready 
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
8010532f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105335:	83 ec 04             	sub    $0x4,%esp
80105338:	50                   	push   %eax
80105339:	6a 04                	push   $0x4
8010533b:	68 c4 70 11 80       	push   $0x801170c4
80105340:	e8 49 09 00 00       	call   80105c8e <removeFromStateList>
80105345:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80105348:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010534e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  addToStateListTail(&ptable.pLists.ready[0], RUNNABLE, proc); // Modified for Project 4: Periodic Priority Adjustment
80105355:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010535b:	83 ec 04             	sub    $0x4,%esp
8010535e:	50                   	push   %eax
8010535f:	6a 03                	push   $0x3
80105361:	68 b4 70 11 80       	push   $0x801170b4
80105366:	e8 27 0a 00 00       	call   80105d92 <addToStateListTail>
8010536b:	83 c4 10             	add    $0x10,%esp
  #else
  proc->state = RUNNABLE;
  #endif

  sched();
8010536e:	e8 ba fd ff ff       	call   8010512d <sched>
  release(&ptable.lock);
80105373:	83 ec 0c             	sub    $0xc,%esp
80105376:	68 80 49 11 80       	push   $0x80114980
8010537b:	e8 f6 0f 00 00       	call   80106376 <release>
80105380:	83 c4 10             	add    $0x10,%esp
}
80105383:	90                   	nop
80105384:	c9                   	leave  
80105385:	c3                   	ret    

80105386 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105386:	55                   	push   %ebp
80105387:	89 e5                	mov    %esp,%ebp
80105389:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010538c:	83 ec 0c             	sub    $0xc,%esp
8010538f:	68 80 49 11 80       	push   $0x80114980
80105394:	e8 dd 0f 00 00       	call   80106376 <release>
80105399:	83 c4 10             	add    $0x10,%esp

  if (first) {
8010539c:	a1 20 d0 10 80       	mov    0x8010d020,%eax
801053a1:	85 c0                	test   %eax,%eax
801053a3:	74 24                	je     801053c9 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801053a5:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
801053ac:	00 00 00 
    iinit(ROOTDEV);
801053af:	83 ec 0c             	sub    $0xc,%esp
801053b2:	6a 01                	push   $0x1
801053b4:	e8 2b c3 ff ff       	call   801016e4 <iinit>
801053b9:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801053bc:	83 ec 0c             	sub    $0xc,%esp
801053bf:	6a 01                	push   $0x1
801053c1:	e8 0f e0 ff ff       	call   801033d5 <initlog>
801053c6:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801053c9:	90                   	nop
801053ca:	c9                   	leave  
801053cb:	c3                   	ret    

801053cc <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
801053cc:	55                   	push   %ebp
801053cd:	89 e5                	mov    %esp,%ebp
801053cf:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
801053d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053d8:	85 c0                	test   %eax,%eax
801053da:	75 0d                	jne    801053e9 <sleep+0x1d>
    panic("sleep");
801053dc:	83 ec 0c             	sub    $0xc,%esp
801053df:	68 c4 9d 10 80       	push   $0x80109dc4
801053e4:	e8 7d b1 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
801053e9:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801053f0:	74 24                	je     80105416 <sleep+0x4a>
    acquire(&ptable.lock);
801053f2:	83 ec 0c             	sub    $0xc,%esp
801053f5:	68 80 49 11 80       	push   $0x80114980
801053fa:	e8 10 0f 00 00       	call   8010630f <acquire>
801053ff:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105402:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105406:	74 0e                	je     80105416 <sleep+0x4a>
80105408:	83 ec 0c             	sub    $0xc,%esp
8010540b:	ff 75 0c             	pushl  0xc(%ebp)
8010540e:	e8 63 0f 00 00       	call   80106376 <release>
80105413:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80105416:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010541c:	8b 55 08             	mov    0x8(%ebp),%edx
8010541f:	89 50 20             	mov    %edx,0x20(%eax)

  // START: Added for Project 3: List Management
  #ifdef CS333_P3P4
  // move proc from running to sleep list
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
80105422:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105428:	83 ec 04             	sub    $0x4,%esp
8010542b:	50                   	push   %eax
8010542c:	6a 04                	push   $0x4
8010542e:	68 c4 70 11 80       	push   $0x801170c4
80105433:	e8 56 08 00 00       	call   80105c8e <removeFromStateList>
80105438:	83 c4 10             	add    $0x10,%esp
  proc->state = SLEEPING;
8010543b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105441:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  addToStateListHead(&ptable.pLists.sleep, SLEEPING, proc);
80105448:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010544e:	83 ec 04             	sub    $0x4,%esp
80105451:	50                   	push   %eax
80105452:	6a 02                	push   $0x2
80105454:	68 bc 70 11 80       	push   $0x801170bc
80105459:	e8 fd 08 00 00       	call   80105d5b <addToStateListHead>
8010545e:	83 c4 10             	add    $0x10,%esp
  #else
  proc->state = SLEEPING;
  #endif
  sched(); // TODO: sched???
80105461:	e8 c7 fc ff ff       	call   8010512d <sched>
  // END: Added for Project 3: List Management

  // Tidy up.
  proc->chan = 0;
80105466:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010546c:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
80105473:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
8010547a:	74 24                	je     801054a0 <sleep+0xd4>
    release(&ptable.lock);
8010547c:	83 ec 0c             	sub    $0xc,%esp
8010547f:	68 80 49 11 80       	push   $0x80114980
80105484:	e8 ed 0e 00 00       	call   80106376 <release>
80105489:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
8010548c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105490:	74 0e                	je     801054a0 <sleep+0xd4>
80105492:	83 ec 0c             	sub    $0xc,%esp
80105495:	ff 75 0c             	pushl  0xc(%ebp)
80105498:	e8 72 0e 00 00       	call   8010630f <acquire>
8010549d:	83 c4 10             	add    $0x10,%esp
  }
}
801054a0:	90                   	nop
801054a1:	c9                   	leave  
801054a2:	c3                   	ret    

801054a3 <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan) // Added for Project 3: List Management
{
801054a3:	55                   	push   %ebp
801054a4:	89 e5                	mov    %esp,%ebp
801054a6:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = ptable.pLists.sleep;
801054a9:	a1 bc 70 11 80       	mov    0x801170bc,%eax
801054ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // go through sleep list to find process with correct chan
  while(p != 0) {
801054b1:	eb 6b                	jmp    8010551e <wakeup1+0x7b>
    if(p->state == SLEEPING && p->chan == chan) {
801054b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b6:	8b 40 0c             	mov    0xc(%eax),%eax
801054b9:	83 f8 02             	cmp    $0x2,%eax
801054bc:	75 54                	jne    80105512 <wakeup1+0x6f>
801054be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c1:	8b 40 20             	mov    0x20(%eax),%eax
801054c4:	3b 45 08             	cmp    0x8(%ebp),%eax
801054c7:	75 49                	jne    80105512 <wakeup1+0x6f>
      // START: Added for Project 3: List Management
      // move proc p from sleep to ready list
      removeFromStateList(&ptable.pLists.sleep, SLEEPING, p);
801054c9:	83 ec 04             	sub    $0x4,%esp
801054cc:	ff 75 f4             	pushl  -0xc(%ebp)
801054cf:	6a 02                	push   $0x2
801054d1:	68 bc 70 11 80       	push   $0x801170bc
801054d6:	e8 b3 07 00 00       	call   80105c8e <removeFromStateList>
801054db:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
801054de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      addToStateListTail(&ptable.pLists.ready[p->priority], RUNNABLE, p); // Modified for Project 4: Periodic Priority Adjustment
801054e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054eb:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801054f1:	05 cc 09 00 00       	add    $0x9cc,%eax
801054f6:	c1 e0 02             	shl    $0x2,%eax
801054f9:	05 80 49 11 80       	add    $0x80114980,%eax
801054fe:	83 c0 04             	add    $0x4,%eax
80105501:	83 ec 04             	sub    $0x4,%esp
80105504:	ff 75 f4             	pushl  -0xc(%ebp)
80105507:	6a 03                	push   $0x3
80105509:	50                   	push   %eax
8010550a:	e8 83 08 00 00       	call   80105d92 <addToStateListTail>
8010550f:	83 c4 10             	add    $0x10,%esp
      // END: Added for Project 3: List Management
    }

    p = p->next;
80105512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105515:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010551b:	89 45 f4             	mov    %eax,-0xc(%ebp)
wakeup1(void *chan) // Added for Project 3: List Management
{
  struct proc *p = ptable.pLists.sleep;

  // go through sleep list to find process with correct chan
  while(p != 0) {
8010551e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105522:	75 8f                	jne    801054b3 <wakeup1+0x10>
      // END: Added for Project 3: List Management
    }

    p = p->next;
  }
}
80105524:	90                   	nop
80105525:	c9                   	leave  
80105526:	c3                   	ret    

80105527 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105527:	55                   	push   %ebp
80105528:	89 e5                	mov    %esp,%ebp
8010552a:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010552d:	83 ec 0c             	sub    $0xc,%esp
80105530:	68 80 49 11 80       	push   $0x80114980
80105535:	e8 d5 0d 00 00       	call   8010630f <acquire>
8010553a:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010553d:	83 ec 0c             	sub    $0xc,%esp
80105540:	ff 75 08             	pushl  0x8(%ebp)
80105543:	e8 5b ff ff ff       	call   801054a3 <wakeup1>
80105548:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010554b:	83 ec 0c             	sub    $0xc,%esp
8010554e:	68 80 49 11 80       	push   $0x80114980
80105553:	e8 1e 0e 00 00       	call   80106376 <release>
80105558:	83 c4 10             	add    $0x10,%esp
}
8010555b:	90                   	nop
8010555c:	c9                   	leave  
8010555d:	c3                   	ret    

8010555e <kill>:
  return -1;
}
#else
int
kill(int pid) // Added for Project 3: List Management
{
8010555e:	55                   	push   %ebp
8010555f:	89 e5                	mov    %esp,%ebp
80105561:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  acquire(&ptable.lock);
80105564:	83 ec 0c             	sub    $0xc,%esp
80105567:	68 80 49 11 80       	push   $0x80114980
8010556c:	e8 9e 0d 00 00       	call   8010630f <acquire>
80105571:	83 c4 10             	add    $0x10,%esp
  // find proc that has the specified pid from all lists except free list (as mentioned in mail list)
  p = findMatchingProcPID(pid); // Added for Project 3: List Management
80105574:	8b 45 08             	mov    0x8(%ebp),%eax
80105577:	83 ec 0c             	sub    $0xc,%esp
8010557a:	50                   	push   %eax
8010557b:	e8 8c 09 00 00       	call   80105f0c <findMatchingProcPID>
80105580:	83 c4 10             	add    $0x10,%esp
80105583:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p != 0){			// Added for Project 3: List Management
80105586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010558a:	0f 84 82 00 00 00    	je     80105612 <kill+0xb4>
    if(p->pid == pid){
80105590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105593:	8b 50 10             	mov    0x10(%eax),%edx
80105596:	8b 45 08             	mov    0x8(%ebp),%eax
80105599:	39 c2                	cmp    %eax,%edx
8010559b:	75 75                	jne    80105612 <kill+0xb4>
      p->killed = 1;
8010559d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a0:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING) {
801055a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055aa:	8b 40 0c             	mov    0xc(%eax),%eax
801055ad:	83 f8 02             	cmp    $0x2,%eax
801055b0:	75 49                	jne    801055fb <kill+0x9d>
        // START: Added for Project 3: List Management
        // move proc p from sleeping to ready
        removeFromStateList(&ptable.pLists.sleep, SLEEPING, p);
801055b2:	83 ec 04             	sub    $0x4,%esp
801055b5:	ff 75 f4             	pushl  -0xc(%ebp)
801055b8:	6a 02                	push   $0x2
801055ba:	68 bc 70 11 80       	push   $0x801170bc
801055bf:	e8 ca 06 00 00       	call   80105c8e <removeFromStateList>
801055c4:	83 c4 10             	add    $0x10,%esp
        p->state = RUNNABLE;
801055c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ca:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        addToStateListTail(&ptable.pLists.ready[p->priority], RUNNABLE, p); // Modified for Project 4: Periodic Priority Adjustment
801055d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801055da:	05 cc 09 00 00       	add    $0x9cc,%eax
801055df:	c1 e0 02             	shl    $0x2,%eax
801055e2:	05 80 49 11 80       	add    $0x80114980,%eax
801055e7:	83 c0 04             	add    $0x4,%eax
801055ea:	83 ec 04             	sub    $0x4,%esp
801055ed:	ff 75 f4             	pushl  -0xc(%ebp)
801055f0:	6a 03                	push   $0x3
801055f2:	50                   	push   %eax
801055f3:	e8 9a 07 00 00       	call   80105d92 <addToStateListTail>
801055f8:	83 c4 10             	add    $0x10,%esp
        // END: Added for Project 3: List Management
      }

      release(&ptable.lock);
801055fb:	83 ec 0c             	sub    $0xc,%esp
801055fe:	68 80 49 11 80       	push   $0x80114980
80105603:	e8 6e 0d 00 00       	call   80106376 <release>
80105608:	83 c4 10             	add    $0x10,%esp
      return 0;
8010560b:	b8 00 00 00 00       	mov    $0x0,%eax
80105610:	eb 15                	jmp    80105627 <kill+0xc9>
    }
  }
  release(&ptable.lock);
80105612:	83 ec 0c             	sub    $0xc,%esp
80105615:	68 80 49 11 80       	push   $0x80114980
8010561a:	e8 57 0d 00 00       	call   80106376 <release>
8010561f:	83 c4 10             	add    $0x10,%esp
  return -1;
80105622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105627:	c9                   	leave  
80105628:	c3                   	ret    

80105629 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105629:	55                   	push   %ebp
8010562a:	89 e5                	mov    %esp,%ebp
8010562c:	57                   	push   %edi
8010562d:	56                   	push   %esi
8010562e:	53                   	push   %ebx
8010562f:	83 ec 6c             	sub    $0x6c,%esp
  char *state;
  uint pc[10];
  uint ppid;
 
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command
80105632:	83 ec 0c             	sub    $0xc,%esp
80105635:	68 f4 9d 10 80       	push   $0x80109df4
8010563a:	e8 87 ad ff ff       	call   801003c6 <cprintf>
8010563f:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105642:	c7 45 e0 b4 49 11 80 	movl   $0x801149b4,-0x20(%ebp)
80105649:	e9 0e 02 00 00       	jmp    8010585c <procdump+0x233>
    if(p->state == UNUSED)
8010564e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105651:	8b 40 0c             	mov    0xc(%eax),%eax
80105654:	85 c0                	test   %eax,%eax
80105656:	0f 84 f8 01 00 00    	je     80105854 <procdump+0x22b>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010565c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010565f:	8b 40 0c             	mov    0xc(%eax),%eax
80105662:	83 f8 05             	cmp    $0x5,%eax
80105665:	77 23                	ja     8010568a <procdump+0x61>
80105667:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010566a:	8b 40 0c             	mov    0xc(%eax),%eax
8010566d:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105674:	85 c0                	test   %eax,%eax
80105676:	74 12                	je     8010568a <procdump+0x61>
      state = states[p->state];
80105678:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010567b:	8b 40 0c             	mov    0xc(%eax),%eax
8010567e:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105685:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105688:	eb 07                	jmp    80105691 <procdump+0x68>
    else
      state = "???";
8010568a:	c7 45 dc 2d 9e 10 80 	movl   $0x80109e2d,-0x24(%ebp)
    // Print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size (with needed spacing)
    // Switched to tabs and mod in Project 2: Modifying the Console)
    // (I wish I used this method from the start.... :(  )
    
    // get ppid (and if it is init then its ppid is itself (1))
    if (p->pid == 1)
80105691:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105694:	8b 40 10             	mov    0x10(%eax),%eax
80105697:	83 f8 01             	cmp    $0x1,%eax
8010569a:	75 09                	jne    801056a5 <procdump+0x7c>
      ppid = 1;
8010569c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
801056a3:	eb 0c                	jmp    801056b1 <procdump+0x88>
    else
      ppid = p->parent->pid;
801056a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056a8:	8b 40 14             	mov    0x14(%eax),%eax
801056ab:	8b 40 10             	mov    0x10(%eax),%eax
801056ae:	89 45 d8             	mov    %eax,-0x28(%ebp)

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801056b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056b4:	8b 38                	mov    (%eax),%edi
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
		p->cpu_ticks_total / 100,
		p->cpu_ticks_total % 100 / 10,
801056b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056b9:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
801056bf:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801056c4:	89 c8                	mov    %ecx,%eax
801056c6:	f7 e2                	mul    %edx
801056c8:	89 d0                	mov    %edx,%eax
801056ca:	c1 e8 05             	shr    $0x5,%eax
801056cd:	6b c0 64             	imul   $0x64,%eax,%eax
801056d0:	29 c1                	sub    %eax,%ecx
801056d2:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801056d4:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801056d9:	f7 e2                	mul    %edx
801056db:	c1 ea 03             	shr    $0x3,%edx
801056de:	89 55 a4             	mov    %edx,-0x5c(%ebp)
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
		p->cpu_ticks_total / 100,
801056e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056e4:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801056ea:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801056ef:	f7 e2                	mul    %edx
801056f1:	89 d0                	mov    %edx,%eax
801056f3:	c1 e8 05             	shr    $0x5,%eax
801056f6:	89 45 a0             	mov    %eax,-0x60(%ebp)
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
801056f9:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
801056ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105702:	8b 40 7c             	mov    0x7c(%eax),%eax
80105705:	89 d3                	mov    %edx,%ebx
80105707:	29 c3                	sub    %eax,%ebx
80105709:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010570e:	89 d8                	mov    %ebx,%eax
80105710:	f7 e2                	mul    %edx
80105712:	89 d1                	mov    %edx,%ecx
80105714:	c1 e9 05             	shr    $0x5,%ecx
80105717:	6b c1 64             	imul   $0x64,%ecx,%eax
8010571a:	29 c3                	sub    %eax,%ebx
8010571c:	89 d9                	mov    %ebx,%ecx
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
8010571e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105723:	89 c8                	mov    %ecx,%eax
80105725:	f7 e2                	mul    %edx
80105727:	89 d3                	mov    %edx,%ebx
80105729:	c1 eb 03             	shr    $0x3,%ebx
8010572c:	89 d8                	mov    %ebx,%eax
8010572e:	c1 e0 02             	shl    $0x2,%eax
80105731:	01 d8                	add    %ebx,%eax
80105733:	01 c0                	add    %eax,%eax
80105735:	89 cb                	mov    %ecx,%ebx
80105737:	29 c3                	sub    %eax,%ebx
		p->uid,
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
80105739:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
8010573f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105742:	8b 40 7c             	mov    0x7c(%eax),%eax
80105745:	89 d1                	mov    %edx,%ecx
80105747:	29 c1                	sub    %eax,%ecx
80105749:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010574e:	89 c8                	mov    %ecx,%eax
80105750:	f7 e2                	mul    %edx
80105752:	89 d0                	mov    %edx,%eax
80105754:	c1 e8 05             	shr    $0x5,%eax
80105757:	6b c0 64             	imul   $0x64,%eax,%eax
8010575a:	29 c1                	sub    %eax,%ecx
8010575c:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
8010575e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105763:	f7 e2                	mul    %edx
80105765:	89 d6                	mov    %edx,%esi
80105767:	c1 ee 03             	shr    $0x3,%esi
8010576a:	89 75 9c             	mov    %esi,-0x64(%ebp)
		p->name,
		p->uid,
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
8010576d:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105773:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105776:	8b 40 7c             	mov    0x7c(%eax),%eax
80105779:	89 d1                	mov    %edx,%ecx
8010577b:	29 c1                	sub    %eax,%ecx
8010577d:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
8010577f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105784:	f7 e2                	mul    %edx
80105786:	89 d1                	mov    %edx,%ecx
80105788:	c1 e9 05             	shr    $0x5,%ecx
8010578b:	89 4d 98             	mov    %ecx,-0x68(%ebp)
8010578e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105791:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105797:	89 45 94             	mov    %eax,-0x6c(%ebp)
8010579a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010579d:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
801057a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057a6:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
		p->pid,
		p->name,
801057ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057af:	8d 50 6c             	lea    0x6c(%eax),%edx
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801057b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057b5:	8b 40 10             	mov    0x10(%eax),%eax
801057b8:	83 ec 08             	sub    $0x8,%esp
801057bb:	57                   	push   %edi
801057bc:	ff 75 dc             	pushl  -0x24(%ebp)
801057bf:	ff 75 a4             	pushl  -0x5c(%ebp)
801057c2:	ff 75 a0             	pushl  -0x60(%ebp)
801057c5:	53                   	push   %ebx
801057c6:	ff 75 9c             	pushl  -0x64(%ebp)
801057c9:	ff 75 98             	pushl  -0x68(%ebp)
801057cc:	ff 75 94             	pushl  -0x6c(%ebp)
801057cf:	ff 75 d8             	pushl  -0x28(%ebp)
801057d2:	56                   	push   %esi
801057d3:	51                   	push   %ecx
801057d4:	52                   	push   %edx
801057d5:	50                   	push   %eax
801057d6:	68 34 9e 10 80       	push   $0x80109e34
801057db:	e8 e6 ab ff ff       	call   801003c6 <cprintf>
801057e0:	83 c4 40             	add    $0x40,%esp
		p->sz);

    // END: Added for Project 1: CTL-P

    // Print PCs data
    if(p->state == SLEEPING){
801057e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057e6:	8b 40 0c             	mov    0xc(%eax),%eax
801057e9:	83 f8 02             	cmp    $0x2,%eax
801057ec:	75 54                	jne    80105842 <procdump+0x219>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801057ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057f1:	8b 40 1c             	mov    0x1c(%eax),%eax
801057f4:	8b 40 0c             	mov    0xc(%eax),%eax
801057f7:	83 c0 08             	add    $0x8,%eax
801057fa:	89 c2                	mov    %eax,%edx
801057fc:	83 ec 08             	sub    $0x8,%esp
801057ff:	8d 45 b0             	lea    -0x50(%ebp),%eax
80105802:	50                   	push   %eax
80105803:	52                   	push   %edx
80105804:	e8 bf 0b 00 00       	call   801063c8 <getcallerpcs>
80105809:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010580c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105813:	eb 1c                	jmp    80105831 <procdump+0x208>
        cprintf(" %p", pc[i]);
80105815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105818:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
8010581c:	83 ec 08             	sub    $0x8,%esp
8010581f:	50                   	push   %eax
80105820:	68 5b 9e 10 80       	push   $0x80109e5b
80105825:	e8 9c ab ff ff       	call   801003c6 <cprintf>
8010582a:	83 c4 10             	add    $0x10,%esp
    // END: Added for Project 1: CTL-P

    // Print PCs data
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010582d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105831:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
80105835:	7f 0b                	jg     80105842 <procdump+0x219>
80105837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010583a:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
8010583e:	85 c0                	test   %eax,%eax
80105840:	75 d3                	jne    80105815 <procdump+0x1ec>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105842:	83 ec 0c             	sub    $0xc,%esp
80105845:	68 5f 9e 10 80       	push   $0x80109e5f
8010584a:	e8 77 ab ff ff       	call   801003c6 <cprintf>
8010584f:	83 c4 10             	add    $0x10,%esp
80105852:	eb 01                	jmp    80105855 <procdump+0x22c>
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105854:	90                   	nop
  uint ppid;
 
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105855:	81 45 e0 9c 00 00 00 	addl   $0x9c,-0x20(%ebp)
8010585c:	81 7d e0 b4 70 11 80 	cmpl   $0x801170b4,-0x20(%ebp)
80105863:	0f 82 e5 fd ff ff    	jb     8010564e <procdump+0x25>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105869:	90                   	nop
8010586a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010586d:	5b                   	pop    %ebx
8010586e:	5e                   	pop    %esi
8010586f:	5f                   	pop    %edi
80105870:	5d                   	pop    %ebp
80105871:	c3                   	ret    

80105872 <readydump>:

// START: Added for Project 3: New Console Control Sequences
void
readydump(void) // Modified for Project 4: ctrl-r Console Command
{
80105872:	55                   	push   %ebp
80105873:	89 e5                	mov    %esp,%ebp
80105875:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	68 80 49 11 80       	push   $0x80114980
80105880:	e8 8a 0a 00 00       	call   8010630f <acquire>
80105885:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = 0;
80105888:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  cprintf("Ready List Processes:\n"); 
8010588f:	83 ec 0c             	sub    $0xc,%esp
80105892:	68 61 9e 10 80       	push   $0x80109e61
80105897:	e8 2a ab ff ff       	call   801003c6 <cprintf>
8010589c:	83 c4 10             	add    $0x10,%esp

  for(int i = 0; i < MAX + 1; ++i){
8010589f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801058a6:	e9 a4 00 00 00       	jmp    8010594f <readydump+0xdd>
    currPtr = ptable.pLists.ready[i];
801058ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ae:	05 cc 09 00 00       	add    $0x9cc,%eax
801058b3:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801058ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%d: ", i); // print list number
801058bd:	83 ec 08             	sub    $0x8,%esp
801058c0:	ff 75 f0             	pushl  -0x10(%ebp)
801058c3:	68 78 9e 10 80       	push   $0x80109e78
801058c8:	e8 f9 aa ff ff       	call   801003c6 <cprintf>
801058cd:	83 c4 10             	add    $0x10,%esp
    
    if (currPtr == 0)
801058d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058d4:	75 6f                	jne    80105945 <readydump+0xd3>
      cprintf("Empty!\n");
801058d6:	83 ec 0c             	sub    $0xc,%esp
801058d9:	68 7d 9e 10 80       	push   $0x80109e7d
801058de:	e8 e3 aa ff ff       	call   801003c6 <cprintf>
801058e3:	83 c4 10             	add    $0x10,%esp

    while (currPtr != 0){
801058e6:	eb 5d                	jmp    80105945 <readydump+0xd3>
      if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
801058e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058eb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801058f1:	85 c0                	test   %eax,%eax
801058f3:	75 23                	jne    80105918 <readydump+0xa6>
        cprintf("(%d, %d)\n", currPtr->pid, currPtr->budget);
801058f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f8:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
801058fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105901:	8b 40 10             	mov    0x10(%eax),%eax
80105904:	83 ec 04             	sub    $0x4,%esp
80105907:	52                   	push   %edx
80105908:	50                   	push   %eax
80105909:	68 85 9e 10 80       	push   $0x80109e85
8010590e:	e8 b3 aa ff ff       	call   801003c6 <cprintf>
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	eb 21                	jmp    80105939 <readydump+0xc7>
      else
        cprintf("(%d, %d) -> ", currPtr->pid, currPtr->budget);
80105918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591b:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105924:	8b 40 10             	mov    0x10(%eax),%eax
80105927:	83 ec 04             	sub    $0x4,%esp
8010592a:	52                   	push   %edx
8010592b:	50                   	push   %eax
8010592c:	68 8f 9e 10 80       	push   $0x80109e8f
80105931:	e8 90 aa ff ff       	call   801003c6 <cprintf>
80105936:	83 c4 10             	add    $0x10,%esp

      currPtr = currPtr->next;
80105939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105942:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%d: ", i); // print list number
    
    if (currPtr == 0)
      cprintf("Empty!\n");

    while (currPtr != 0){
80105945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105949:	75 9d                	jne    801058e8 <readydump+0x76>

  struct proc *currPtr = 0;

  cprintf("Ready List Processes:\n"); 

  for(int i = 0; i < MAX + 1; ++i){
8010594b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010594f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105953:	0f 8e 52 ff ff ff    	jle    801058ab <readydump+0x39>

      currPtr = currPtr->next;
    }
  }

  release(&ptable.lock);
80105959:	83 ec 0c             	sub    $0xc,%esp
8010595c:	68 80 49 11 80       	push   $0x80114980
80105961:	e8 10 0a 00 00       	call   80106376 <release>
80105966:	83 c4 10             	add    $0x10,%esp
}
80105969:	90                   	nop
8010596a:	c9                   	leave  
8010596b:	c3                   	ret    

8010596c <freedump>:

void
freedump(void)
{
8010596c:	55                   	push   %ebp
8010596d:	89 e5                	mov    %esp,%ebp
8010596f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105972:	83 ec 0c             	sub    $0xc,%esp
80105975:	68 80 49 11 80       	push   $0x80114980
8010597a:	e8 90 09 00 00       	call   8010630f <acquire>
8010597f:	83 c4 10             	add    $0x10,%esp
  
  struct proc *currPtr = ptable.pLists.free;
80105982:	a1 b8 70 11 80       	mov    0x801170b8,%eax
80105987:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint numProcs = 0;
8010598a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  while (currPtr != 0){
80105991:	eb 10                	jmp    801059a3 <freedump+0x37>
    ++numProcs;
80105993:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    currPtr = currPtr->next;
80105997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010599a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&ptable.lock);
  
  struct proc *currPtr = ptable.pLists.free;
  uint numProcs = 0;

  while (currPtr != 0){
801059a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059a7:	75 ea                	jne    80105993 <freedump+0x27>
    ++numProcs;
    currPtr = currPtr->next;
  }

  cprintf("Free List Size: %d processes\n", numProcs);
801059a9:	83 ec 08             	sub    $0x8,%esp
801059ac:	ff 75 f0             	pushl  -0x10(%ebp)
801059af:	68 9c 9e 10 80       	push   $0x80109e9c
801059b4:	e8 0d aa ff ff       	call   801003c6 <cprintf>
801059b9:	83 c4 10             	add    $0x10,%esp

  release(&ptable.lock);
801059bc:	83 ec 0c             	sub    $0xc,%esp
801059bf:	68 80 49 11 80       	push   $0x80114980
801059c4:	e8 ad 09 00 00       	call   80106376 <release>
801059c9:	83 c4 10             	add    $0x10,%esp
}
801059cc:	90                   	nop
801059cd:	c9                   	leave  
801059ce:	c3                   	ret    

801059cf <sleepdump>:

void
sleepdump(void)
{
801059cf:	55                   	push   %ebp
801059d0:	89 e5                	mov    %esp,%ebp
801059d2:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801059d5:	83 ec 0c             	sub    $0xc,%esp
801059d8:	68 80 49 11 80       	push   $0x80114980
801059dd:	e8 2d 09 00 00       	call   8010630f <acquire>
801059e2:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = ptable.pLists.sleep;
801059e5:	a1 bc 70 11 80       	mov    0x801170bc,%eax
801059ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

  cprintf("Sleep List Processes:\n"); 
801059ed:	83 ec 0c             	sub    $0xc,%esp
801059f0:	68 ba 9e 10 80       	push   $0x80109eba
801059f5:	e8 cc a9 ff ff       	call   801003c6 <cprintf>
801059fa:	83 c4 10             	add    $0x10,%esp
  
  if (currPtr == 0)
801059fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a01:	75 5b                	jne    80105a5e <sleepdump+0x8f>
    cprintf("Empty!\n");
80105a03:	83 ec 0c             	sub    $0xc,%esp
80105a06:	68 7d 9e 10 80       	push   $0x80109e7d
80105a0b:	e8 b6 a9 ff ff       	call   801003c6 <cprintf>
80105a10:	83 c4 10             	add    $0x10,%esp

  while (currPtr != 0){
80105a13:	eb 49                	jmp    80105a5e <sleepdump+0x8f>
    if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
80105a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a18:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a1e:	85 c0                	test   %eax,%eax
80105a20:	75 19                	jne    80105a3b <sleepdump+0x6c>
      cprintf("%d\n", currPtr->pid);
80105a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a25:	8b 40 10             	mov    0x10(%eax),%eax
80105a28:	83 ec 08             	sub    $0x8,%esp
80105a2b:	50                   	push   %eax
80105a2c:	68 d1 9e 10 80       	push   $0x80109ed1
80105a31:	e8 90 a9 ff ff       	call   801003c6 <cprintf>
80105a36:	83 c4 10             	add    $0x10,%esp
80105a39:	eb 17                	jmp    80105a52 <sleepdump+0x83>
    else
      cprintf("%d -> ", currPtr->pid);
80105a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3e:	8b 40 10             	mov    0x10(%eax),%eax
80105a41:	83 ec 08             	sub    $0x8,%esp
80105a44:	50                   	push   %eax
80105a45:	68 d5 9e 10 80       	push   $0x80109ed5
80105a4a:	e8 77 a9 ff ff       	call   801003c6 <cprintf>
80105a4f:	83 c4 10             	add    $0x10,%esp

    currPtr = currPtr->next;
80105a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a55:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cprintf("Sleep List Processes:\n"); 
  
  if (currPtr == 0)
    cprintf("Empty!\n");

  while (currPtr != 0){
80105a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a62:	75 b1                	jne    80105a15 <sleepdump+0x46>
      cprintf("%d -> ", currPtr->pid);

    currPtr = currPtr->next;
  }

  release(&ptable.lock);
80105a64:	83 ec 0c             	sub    $0xc,%esp
80105a67:	68 80 49 11 80       	push   $0x80114980
80105a6c:	e8 05 09 00 00       	call   80106376 <release>
80105a71:	83 c4 10             	add    $0x10,%esp
}
80105a74:	90                   	nop
80105a75:	c9                   	leave  
80105a76:	c3                   	ret    

80105a77 <zombiedump>:

void
zombiedump(void)
{
80105a77:	55                   	push   %ebp
80105a78:	89 e5                	mov    %esp,%ebp
80105a7a:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	68 80 49 11 80       	push   $0x80114980
80105a85:	e8 85 08 00 00       	call   8010630f <acquire>
80105a8a:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = ptable.pLists.zombie;
80105a8d:	a1 c0 70 11 80       	mov    0x801170c0,%eax
80105a92:	89 45 f4             	mov    %eax,-0xc(%ebp)

  cprintf("Zombie List Processes:\n"); 
80105a95:	83 ec 0c             	sub    $0xc,%esp
80105a98:	68 dc 9e 10 80       	push   $0x80109edc
80105a9d:	e8 24 a9 ff ff       	call   801003c6 <cprintf>
80105aa2:	83 c4 10             	add    $0x10,%esp

  if (currPtr == 0)
80105aa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aa9:	75 6f                	jne    80105b1a <zombiedump+0xa3>
    cprintf("Empty!\n");
80105aab:	83 ec 0c             	sub    $0xc,%esp
80105aae:	68 7d 9e 10 80       	push   $0x80109e7d
80105ab3:	e8 0e a9 ff ff       	call   801003c6 <cprintf>
80105ab8:	83 c4 10             	add    $0x10,%esp

  while (currPtr != 0){
80105abb:	eb 5d                	jmp    80105b1a <zombiedump+0xa3>
    if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
80105abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ac6:	85 c0                	test   %eax,%eax
80105ac8:	75 23                	jne    80105aed <zombiedump+0x76>
        cprintf("(%d, %d)\n", currPtr->pid, currPtr->parent->pid);
80105aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105acd:	8b 40 14             	mov    0x14(%eax),%eax
80105ad0:	8b 50 10             	mov    0x10(%eax),%edx
80105ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad6:	8b 40 10             	mov    0x10(%eax),%eax
80105ad9:	83 ec 04             	sub    $0x4,%esp
80105adc:	52                   	push   %edx
80105add:	50                   	push   %eax
80105ade:	68 85 9e 10 80       	push   $0x80109e85
80105ae3:	e8 de a8 ff ff       	call   801003c6 <cprintf>
80105ae8:	83 c4 10             	add    $0x10,%esp
80105aeb:	eb 21                	jmp    80105b0e <zombiedump+0x97>
    else
      cprintf("(%d, %d) -> ", currPtr->pid, currPtr->parent->pid);
80105aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af0:	8b 40 14             	mov    0x14(%eax),%eax
80105af3:	8b 50 10             	mov    0x10(%eax),%edx
80105af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af9:	8b 40 10             	mov    0x10(%eax),%eax
80105afc:	83 ec 04             	sub    $0x4,%esp
80105aff:	52                   	push   %edx
80105b00:	50                   	push   %eax
80105b01:	68 8f 9e 10 80       	push   $0x80109e8f
80105b06:	e8 bb a8 ff ff       	call   801003c6 <cprintf>
80105b0b:	83 c4 10             	add    $0x10,%esp
    
    currPtr = currPtr->next;
80105b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b11:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cprintf("Zombie List Processes:\n"); 

  if (currPtr == 0)
    cprintf("Empty!\n");

  while (currPtr != 0){
80105b1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b1e:	75 9d                	jne    80105abd <zombiedump+0x46>
      cprintf("(%d, %d) -> ", currPtr->pid, currPtr->parent->pid);
    
    currPtr = currPtr->next;
  }

  release(&ptable.lock);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	68 80 49 11 80       	push   $0x80114980
80105b28:	e8 49 08 00 00       	call   80106376 <release>
80105b2d:	83 c4 10             	add    $0x10,%esp
}
80105b30:	90                   	nop
80105b31:	c9                   	leave  
80105b32:	c3                   	ret    

80105b33 <getuprocs>:
// END: Added for Project 3: New Console Control Sequences

// get array of uproc structs
int
getuprocs(uint max, struct uproc *table) // Added for Project 2: The "ps" Command
{
80105b33:	55                   	push   %ebp
80105b34:	89 e5                	mov    %esp,%ebp
80105b36:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  uint numProcs = 0; // number of procs in struct array
80105b39:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  acquire(&ptable.lock); // get lock so we get a snapshot
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	68 80 49 11 80       	push   $0x80114980
80105b48:	e8 c2 07 00 00       	call   8010630f <acquire>
80105b4d:	83 c4 10             	add    $0x10,%esp

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
80105b50:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80105b57:	e9 08 01 00 00       	jmp    80105c64 <getuprocs+0x131>
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
80105b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5f:	8b 40 0c             	mov    0xc(%eax),%eax
80105b62:	83 f8 03             	cmp    $0x3,%eax
80105b65:	74 25                	je     80105b8c <getuprocs+0x59>
        p->state == SLEEPING || 
80105b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6a:	8b 40 0c             	mov    0xc(%eax),%eax

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
80105b6d:	83 f8 02             	cmp    $0x2,%eax
80105b70:	74 1a                	je     80105b8c <getuprocs+0x59>
        p->state == SLEEPING || 
        p->state == RUNNING  || 
80105b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b75:	8b 40 0c             	mov    0xc(%eax),%eax
  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
        p->state == SLEEPING || 
80105b78:	83 f8 04             	cmp    $0x4,%eax
80105b7b:	74 0f                	je     80105b8c <getuprocs+0x59>
        p->state == RUNNING  || 
        p->state == ZOMBIE)
80105b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b80:	8b 40 0c             	mov    0xc(%eax),%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
        p->state == SLEEPING || 
        p->state == RUNNING  || 
80105b83:	83 f8 05             	cmp    $0x5,%eax
80105b86:	0f 85 d1 00 00 00    	jne    80105c5d <getuprocs+0x12a>
        p->state == ZOMBIE)
    {

      // populate uproc struct entry in table
      table->pid  = p->pid;
80105b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8f:	8b 50 10             	mov    0x10(%eax),%edx
80105b92:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b95:	89 10                	mov    %edx,(%eax)
      table->uid  = p->uid;
80105b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b9a:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ba3:	89 50 04             	mov    %edx,0x4(%eax)
      table->gid  = p->gid;
80105ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80105baf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bb2:	89 50 08             	mov    %edx,0x8(%eax)

      if (p->pid == 1) // if p is init, then set ppid to itself (1)
80105bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb8:	8b 40 10             	mov    0x10(%eax),%eax
80105bbb:	83 f8 01             	cmp    $0x1,%eax
80105bbe:	75 0c                	jne    80105bcc <getuprocs+0x99>
        table->ppid = 1;
80105bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bc3:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80105bca:	eb 0f                	jmp    80105bdb <getuprocs+0xa8>
      else
        table->ppid = p->parent->pid;
80105bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bcf:	8b 40 14             	mov    0x14(%eax),%eax
80105bd2:	8b 50 10             	mov    0x10(%eax),%edx
80105bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bd8:	89 50 0c             	mov    %edx,0xc(%eax)

      table->priority = p->priority;
80105bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bde:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105be4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105be7:	89 50 10             	mov    %edx,0x10(%eax)
      table->elapsed_ticks = ticks - p->start_ticks;
80105bea:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf3:	8b 40 7c             	mov    0x7c(%eax),%eax
80105bf6:	29 c2                	sub    %eax,%edx
80105bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bfb:	89 50 14             	mov    %edx,0x14(%eax)
      table->CPU_total_ticks = p->cpu_ticks_total;
80105bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c01:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80105c07:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c0a:	89 50 18             	mov    %edx,0x18(%eax)
      safestrcpy(table->state, states[p->state], NELEM(table->state));
80105c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c10:	8b 40 0c             	mov    0xc(%eax),%eax
80105c13:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c1d:	83 c2 1c             	add    $0x1c,%edx
80105c20:	83 ec 04             	sub    $0x4,%esp
80105c23:	6a 20                	push   $0x20
80105c25:	50                   	push   %eax
80105c26:	52                   	push   %edx
80105c27:	e8 49 0b 00 00       	call   80106775 <safestrcpy>
80105c2c:	83 c4 10             	add    $0x10,%esp
      table->size = p->sz;
80105c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c32:	8b 10                	mov    (%eax),%edx
80105c34:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c37:	89 50 3c             	mov    %edx,0x3c(%eax)
      safestrcpy(table->name, p->name, NELEM(table->name));
80105c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3d:	8d 50 6c             	lea    0x6c(%eax),%edx
80105c40:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c43:	83 c0 40             	add    $0x40,%eax
80105c46:	83 ec 04             	sub    $0x4,%esp
80105c49:	6a 20                	push   $0x20
80105c4b:	52                   	push   %edx
80105c4c:	50                   	push   %eax
80105c4d:	e8 23 0b 00 00       	call   80106775 <safestrcpy>
80105c52:	83 c4 10             	add    $0x10,%esp

      ++table; // go to next entry
80105c55:	83 45 0c 60          	addl   $0x60,0xc(%ebp)
      ++numProcs; // inc number of procs in struct array
80105c59:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  uint numProcs = 0; // number of procs in struct array

  acquire(&ptable.lock); // get lock so we get a snapshot

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
80105c5d:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80105c64:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80105c6b:	73 0c                	jae    80105c79 <getuprocs+0x146>
80105c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c70:	3b 45 08             	cmp    0x8(%ebp),%eax
80105c73:	0f 82 e3 fe ff ff    	jb     80105b5c <getuprocs+0x29>
      ++table; // go to next entry
      ++numProcs; // inc number of procs in struct array
    }
  }

  release(&ptable.lock); // return lock
80105c79:	83 ec 0c             	sub    $0xc,%esp
80105c7c:	68 80 49 11 80       	push   $0x80114980
80105c81:	e8 f0 06 00 00       	call   80106376 <release>
80105c86:	83 c4 10             	add    $0x10,%esp

  return numProcs;
80105c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105c8c:	c9                   	leave  
80105c8d:	c3                   	ret    

80105c8e <removeFromStateList>:

// Removes a proc "p" from a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
removeFromStateList(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
80105c8e:	55                   	push   %ebp
80105c8f:	89 e5                	mov    %esp,%ebp
80105c91:	83 ec 08             	sub    $0x8,%esp
   
  // check if passed in proc is in the specified state
  if (p->state != state) {
80105c94:	8b 45 10             	mov    0x10(%ebp),%eax
80105c97:	8b 40 0c             	mov    0xc(%eax),%eax
80105c9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105c9d:	74 34                	je     80105cd3 <removeFromStateList+0x45>
    panic("The passed in proc to remove had the wrong state.");
80105c9f:	83 ec 0c             	sub    $0xc,%esp
80105ca2:	68 f4 9e 10 80       	push   $0x80109ef4
80105ca7:	e8 ba a8 ff ff       	call   80100566 <panic>

  // search through list to find proc to remove
  while((*sList) != 0) {
  
    // if matching proc is found then remove it and return
    if ((*sList) == p) {
80105cac:	8b 45 08             	mov    0x8(%ebp),%eax
80105caf:	8b 00                	mov    (%eax),%eax
80105cb1:	3b 45 10             	cmp    0x10(%ebp),%eax
80105cb4:	75 10                	jne    80105cc6 <removeFromStateList+0x38>
      (*sList) = p->next; // remove proc by "skipping" over it     
80105cb6:	8b 45 10             	mov    0x10(%ebp),%eax
80105cb9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105cbf:	8b 45 08             	mov    0x8(%ebp),%eax
80105cc2:	89 10                	mov    %edx,(%eax)
      return;
80105cc4:	eb 4b                	jmp    80105d11 <removeFromStateList+0x83>
    }

    // else, keep searching 
    sList = &(*sList)->next;
80105cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80105cc9:	8b 00                	mov    (%eax),%eax
80105ccb:	05 90 00 00 00       	add    $0x90,%eax
80105cd0:	89 45 08             	mov    %eax,0x8(%ebp)
  if (p->state != state) {
    panic("The passed in proc to remove had the wrong state.");
  }

  // search through list to find proc to remove
  while((*sList) != 0) {
80105cd3:	8b 45 08             	mov    0x8(%ebp),%eax
80105cd6:	8b 00                	mov    (%eax),%eax
80105cd8:	85 c0                	test   %eax,%eax
80105cda:	75 d0                	jne    80105cac <removeFromStateList+0x1e>

    // else, keep searching 
    sList = &(*sList)->next;
  }

  cprintf("removeFromStateList: p->priority is %d p->pid is %d p->ppid is %d\n", p->priority, p->pid, p->parent->pid);
80105cdc:	8b 45 10             	mov    0x10(%ebp),%eax
80105cdf:	8b 40 14             	mov    0x14(%eax),%eax
80105ce2:	8b 48 10             	mov    0x10(%eax),%ecx
80105ce5:	8b 45 10             	mov    0x10(%ebp),%eax
80105ce8:	8b 50 10             	mov    0x10(%eax),%edx
80105ceb:	8b 45 10             	mov    0x10(%ebp),%eax
80105cee:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105cf4:	51                   	push   %ecx
80105cf5:	52                   	push   %edx
80105cf6:	50                   	push   %eax
80105cf7:	68 28 9f 10 80       	push   $0x80109f28
80105cfc:	e8 c5 a6 ff ff       	call   801003c6 <cprintf>
80105d01:	83 c4 10             	add    $0x10,%esp
  // if it wasn't found then panic and return error
  panic("The passed in proc to remove was not found.");
80105d04:	83 ec 0c             	sub    $0xc,%esp
80105d07:	68 6c 9f 10 80       	push   $0x80109f6c
80105d0c:	e8 55 a8 ff ff       	call   80100566 <panic>
  
}
80105d11:	c9                   	leave  
80105d12:	c3                   	ret    

80105d13 <getFromStateListHead>:
// This is O(1) and is used to get procs from lists which are equivalent (e.g. free)
// If there the specified list is empty then panic
// Also, if the proc that is gotten has the wrong state then panic
struct proc*
getFromStateListHead(struct proc **sList, enum procstate state) // Added for Project 3: List Management
{
80105d13:	55                   	push   %ebp
80105d14:	89 e5                	mov    %esp,%ebp
80105d16:	83 ec 18             	sub    $0x18,%esp
  struct proc* head = (*sList);
80105d19:	8b 45 08             	mov    0x8(%ebp),%eax
80105d1c:	8b 00                	mov    (%eax),%eax
80105d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // if head exists then return gotten head proc (if correct state) and remove from sList
  if (head != 0) {
80105d21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d25:	74 2d                	je     80105d54 <getFromStateListHead+0x41>
    if (head->state != state)
80105d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2a:	8b 40 0c             	mov    0xc(%eax),%eax
80105d2d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105d30:	74 0d                	je     80105d3f <getFromStateListHead+0x2c>
      panic("The gotten head proc had the wrong state.");
80105d32:	83 ec 0c             	sub    $0xc,%esp
80105d35:	68 98 9f 10 80       	push   $0x80109f98
80105d3a:	e8 27 a8 ff ff       	call   80100566 <panic>
    else {
      (*sList) = (*sList)->next; // remove gotten head proc by skipping over it
80105d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80105d42:	8b 00                	mov    (%eax),%eax
80105d44:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80105d4d:	89 10                	mov    %edx,(%eax)
      return head;
80105d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d52:	eb 05                	jmp    80105d59 <getFromStateListHead+0x46>
    }
    
  }

  return 0; // if head doesn't exist then null is returned
80105d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d59:	c9                   	leave  
80105d5a:	c3                   	ret    

80105d5b <addToStateListHead>:

// Adds a proc "p" to the head of a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
addToStateListHead(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
80105d5b:	55                   	push   %ebp
80105d5c:	89 e5                	mov    %esp,%ebp
80105d5e:	83 ec 08             	sub    $0x8,%esp
  // check if proc that is being added is correct state
  if (p->state != state) {
80105d61:	8b 45 10             	mov    0x10(%ebp),%eax
80105d64:	8b 40 0c             	mov    0xc(%eax),%eax
80105d67:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105d6a:	74 0d                	je     80105d79 <addToStateListHead+0x1e>
    panic("The passed in proc to add to head had the wrong state.");
80105d6c:	83 ec 0c             	sub    $0xc,%esp
80105d6f:	68 c4 9f 10 80       	push   $0x80109fc4
80105d74:	e8 ed a7 ff ff       	call   80100566 <panic>
  }

  // add proc to head
  p->next = (*sList); // note that if the sList is empty then the next will be set to null (as expected)
80105d79:	8b 45 08             	mov    0x8(%ebp),%eax
80105d7c:	8b 10                	mov    (%eax),%edx
80105d7e:	8b 45 10             	mov    0x10(%ebp),%eax
80105d81:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  (*sList) = p;
80105d87:	8b 45 08             	mov    0x8(%ebp),%eax
80105d8a:	8b 55 10             	mov    0x10(%ebp),%edx
80105d8d:	89 10                	mov    %edx,(%eax)

}
80105d8f:	90                   	nop
80105d90:	c9                   	leave  
80105d91:	c3                   	ret    

80105d92 <addToStateListTail>:

// Adds a proc "p" to the tail of a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
addToStateListTail(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
80105d92:	55                   	push   %ebp
80105d93:	89 e5                	mov    %esp,%ebp
80105d95:	83 ec 08             	sub    $0x8,%esp
  // check if proc that is being added is correct state
  if (p->state != state) {
80105d98:	8b 45 10             	mov    0x10(%ebp),%eax
80105d9b:	8b 40 0c             	mov    0xc(%eax),%eax
80105d9e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105da1:	74 0d                	je     80105db0 <addToStateListTail+0x1e>
    panic("The passed in proc to add to tail had the wrong state.");
80105da3:	83 ec 0c             	sub    $0xc,%esp
80105da6:	68 fc 9f 10 80       	push   $0x80109ffc
80105dab:	e8 b6 a7 ff ff       	call   80100566 <panic>
  }
  
  // if list being added to is empty, then just add to head
  if ((*sList) == 0) {
80105db0:	8b 45 08             	mov    0x8(%ebp),%eax
80105db3:	8b 00                	mov    (%eax),%eax
80105db5:	85 c0                	test   %eax,%eax
80105db7:	75 50                	jne    80105e09 <addToStateListTail+0x77>
    (*sList) = p;
80105db9:	8b 45 08             	mov    0x8(%ebp),%eax
80105dbc:	8b 55 10             	mov    0x10(%ebp),%edx
80105dbf:	89 10                	mov    %edx,(%eax)
    p->next = 0; 
80105dc1:	8b 45 10             	mov    0x10(%ebp),%eax
80105dc4:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105dcb:	00 00 00 
80105dce:	eb 42                	jmp    80105e12 <addToStateListTail+0x80>
  // otherwise, find the tail and add proc
  } else {
    while ((*sList) != 0) {
      
      // if tail is found then add proc and return
      if ((*sList)->next == 0) {
80105dd0:	8b 45 08             	mov    0x8(%ebp),%eax
80105dd3:	8b 00                	mov    (%eax),%eax
80105dd5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ddb:	85 c0                	test   %eax,%eax
80105ddd:	75 1d                	jne    80105dfc <addToStateListTail+0x6a>
        (*sList)->next = p;
80105ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80105de2:	8b 00                	mov    (%eax),%eax
80105de4:	8b 55 10             	mov    0x10(%ebp),%edx
80105de7:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        p->next = 0;
80105ded:	8b 45 10             	mov    0x10(%ebp),%eax
80105df0:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105df7:	00 00 00 
        return;
80105dfa:	eb 16                	jmp    80105e12 <addToStateListTail+0x80>
      }

      // otherwise, keep looping
      sList = &(*sList)->next; 
80105dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80105dff:	8b 00                	mov    (%eax),%eax
80105e01:	05 90 00 00 00       	add    $0x90,%eax
80105e06:	89 45 08             	mov    %eax,0x8(%ebp)
    (*sList) = p;
    p->next = 0; 

  // otherwise, find the tail and add proc
  } else {
    while ((*sList) != 0) {
80105e09:	8b 45 08             	mov    0x8(%ebp),%eax
80105e0c:	8b 00                	mov    (%eax),%eax
80105e0e:	85 c0                	test   %eax,%eax
80105e10:	75 be                	jne    80105dd0 <addToStateListTail+0x3e>
      // otherwise, keep looping
      sList = &(*sList)->next; 
    }
  }

}
80105e12:	c9                   	leave  
80105e13:	c3                   	ret    

80105e14 <tackToStateListTail>:
// Tacks a proc p (and all of its "next" children) onto the tail of sList. 
// This function is only used when moving a list of procs between ready list priority queues.
// Also, the procs moved will have their priority decremented and their budget reset
void
tackToStateListTail(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 4: Periodic Priority Adjustment (helper)
{
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0;
80105e1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  // if p is null, then just return
  if (p == 0)
80105e21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105e25:	0f 84 de 00 00 00    	je     80105f09 <tackToStateListTail+0xf5>
    return;
  
  // check if proc that is being moved is correct state
  if (p->state != state)
80105e2b:	8b 45 10             	mov    0x10(%ebp),%eax
80105e2e:	8b 40 0c             	mov    0xc(%eax),%eax
80105e31:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105e34:	74 0d                	je     80105e43 <tackToStateListTail+0x2f>
    panic("The passed in proc to tack to tail had the wrong state.");
80105e36:	83 ec 0c             	sub    $0xc,%esp
80105e39:	68 34 a0 10 80       	push   $0x8010a034
80105e3e:	e8 23 a7 ff ff       	call   80100566 <panic>

  // if list being tacked to is empty, then just add to head
  if ((*sList) == 0){
80105e43:	8b 45 08             	mov    0x8(%ebp),%eax
80105e46:	8b 00                	mov    (%eax),%eax
80105e48:	85 c0                	test   %eax,%eax
80105e4a:	0f 85 ae 00 00 00    	jne    80105efe <tackToStateListTail+0xea>
    (*sList) = p; // note that p's tail is not set to null since it is assumed its tail and its "next" children are set accordingly
80105e50:	8b 45 08             	mov    0x8(%ebp),%eax
80105e53:	8b 55 10             	mov    0x10(%ebp),%edx
80105e56:	89 10                	mov    %edx,(%eax)

    
    currPtr = p;
80105e58:	8b 45 10             	mov    0x10(%ebp),%eax
80105e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(currPtr != 0){
80105e5e:	eb 2e                	jmp    80105e8e <tackToStateListTail+0x7a>
      currPtr->priority--;
80105e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e63:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105e69:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e6f:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
80105e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e78:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105e7f:	01 00 00 

      currPtr = currPtr->next;
80105e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e85:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((*sList) == 0){
    (*sList) = p; // note that p's tail is not set to null since it is assumed its tail and its "next" children are set accordingly

    
    currPtr = p;
    while(currPtr != 0){
80105e8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e92:	75 cc                	jne    80105e60 <tackToStateListTail+0x4c>
80105e94:	eb 74                	jmp    80105f0a <tackToStateListTail+0xf6>
  // otherwise, find the tail and tack on p
  } else {
    while ((*sList) != 0) {
      
      // if tail is found then tack on p and return
      if ((*sList)->next == 0){
80105e96:	8b 45 08             	mov    0x8(%ebp),%eax
80105e99:	8b 00                	mov    (%eax),%eax
80105e9b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ea1:	85 c0                	test   %eax,%eax
80105ea3:	75 4c                	jne    80105ef1 <tackToStateListTail+0xdd>
        (*sList)->next = p; // note that next is not set to null since it is assumed its tail and its "next" children are set accordingly
80105ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80105ea8:	8b 00                	mov    (%eax),%eax
80105eaa:	8b 55 10             	mov    0x10(%ebp),%edx
80105ead:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
         
        currPtr = p;
80105eb3:	8b 45 10             	mov    0x10(%ebp),%eax
80105eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(currPtr != 0){
80105eb9:	eb 2e                	jmp    80105ee9 <tackToStateListTail+0xd5>
          currPtr->priority--;
80105ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ebe:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105ec4:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eca:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
          currPtr->budget = DEFAULT_BUDGET;
80105ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed3:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105eda:	01 00 00 

          currPtr = currPtr->next;
80105edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      // if tail is found then tack on p and return
      if ((*sList)->next == 0){
        (*sList)->next = p; // note that next is not set to null since it is assumed its tail and its "next" children are set accordingly
         
        currPtr = p;
        while(currPtr != 0){
80105ee9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eed:	75 cc                	jne    80105ebb <tackToStateListTail+0xa7>
          currPtr->budget = DEFAULT_BUDGET;

          currPtr = currPtr->next;
        }
        
        return;
80105eef:	eb 19                	jmp    80105f0a <tackToStateListTail+0xf6>
      }
      
      // otherwise, keep looping
      sList = &(*sList)->next;
80105ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80105ef4:	8b 00                	mov    (%eax),%eax
80105ef6:	05 90 00 00 00       	add    $0x90,%eax
80105efb:	89 45 08             	mov    %eax,0x8(%ebp)
      currPtr = currPtr->next;
    }

  // otherwise, find the tail and tack on p
  } else {
    while ((*sList) != 0) {
80105efe:	8b 45 08             	mov    0x8(%ebp),%eax
80105f01:	8b 00                	mov    (%eax),%eax
80105f03:	85 c0                	test   %eax,%eax
80105f05:	75 8f                	jne    80105e96 <tackToStateListTail+0x82>
80105f07:	eb 01                	jmp    80105f0a <tackToStateListTail+0xf6>
{
  struct proc *currPtr = 0;

  // if p is null, then just return
  if (p == 0)
    return;
80105f09:	90                   	nop
      
      // otherwise, keep looping
      sList = &(*sList)->next;
    }
  }
}
80105f0a:	c9                   	leave  
80105f0b:	c3                   	ret    

80105f0c <findMatchingProcPID>:

// find a proc whose PID is equal to the specified PID
// this function searches through all lists except the free list (as mentioned in the mailing list)
struct proc*
findMatchingProcPID(uint pid)
{
80105f0c:	55                   	push   %ebp
80105f0d:	89 e5                	mov    %esp,%ebp
80105f0f:	83 ec 10             	sub    $0x10,%esp
  struct proc *currPtr = 0; 
80105f12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
80105f19:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105f20:	eb 3d                	jmp    80105f5f <findMatchingProcPID+0x53>
    currPtr = ptable.pLists.ready[i];
80105f22:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f25:	05 cc 09 00 00       	add    $0x9cc,%eax
80105f2a:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80105f31:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while(currPtr != 0) {
80105f34:	eb 1f                	jmp    80105f55 <findMatchingProcPID+0x49>
      if (currPtr->pid == pid) // check if we found the proc
80105f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f39:	8b 40 10             	mov    0x10(%eax),%eax
80105f3c:	3b 45 08             	cmp    0x8(%ebp),%eax
80105f3f:	75 08                	jne    80105f49 <findMatchingProcPID+0x3d>
        return currPtr;
80105f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f44:	e9 d4 00 00 00       	jmp    8010601d <findMatchingProcPID+0x111>

      currPtr = currPtr->next;
80105f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f4c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc *currPtr = 0; 

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
    currPtr = ptable.pLists.ready[i];
    while(currPtr != 0) {
80105f55:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105f59:	75 db                	jne    80105f36 <findMatchingProcPID+0x2a>
findMatchingProcPID(uint pid)
{
  struct proc *currPtr = 0; 

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
80105f5b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105f5f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80105f63:	7e bd                	jle    80105f22 <findMatchingProcPID+0x16>
      currPtr = currPtr->next;
    }
  }

  // search through sleep list
  currPtr = ptable.pLists.sleep;
80105f65:	a1 bc 70 11 80       	mov    0x801170bc,%eax
80105f6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105f6d:	eb 1f                	jmp    80105f8e <findMatchingProcPID+0x82>
    if (currPtr->pid == pid) // check if we found the proc
80105f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f72:	8b 40 10             	mov    0x10(%eax),%eax
80105f75:	3b 45 08             	cmp    0x8(%ebp),%eax
80105f78:	75 08                	jne    80105f82 <findMatchingProcPID+0x76>
      return currPtr;
80105f7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f7d:	e9 9b 00 00 00       	jmp    8010601d <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105f82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f85:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }
  }

  // search through sleep list
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0) {
80105f8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105f92:	75 db                	jne    80105f6f <findMatchingProcPID+0x63>

    currPtr = currPtr->next;
  }

  // search through zombie list
  currPtr = ptable.pLists.zombie;
80105f94:	a1 c0 70 11 80       	mov    0x801170c0,%eax
80105f99:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105f9c:	eb 1c                	jmp    80105fba <findMatchingProcPID+0xae>
    if (currPtr->pid == pid) // check if we found the proc
80105f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fa1:	8b 40 10             	mov    0x10(%eax),%eax
80105fa4:	3b 45 08             	cmp    0x8(%ebp),%eax
80105fa7:	75 05                	jne    80105fae <findMatchingProcPID+0xa2>
      return currPtr;
80105fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fac:	eb 6f                	jmp    8010601d <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fb1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105fb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through zombie list
  currPtr = ptable.pLists.zombie;
  while(currPtr != 0) {
80105fba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105fbe:	75 de                	jne    80105f9e <findMatchingProcPID+0x92>

    currPtr = currPtr->next;
  }

  // search through running list
  currPtr = ptable.pLists.running;
80105fc0:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80105fc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105fc8:	eb 1c                	jmp    80105fe6 <findMatchingProcPID+0xda>
    if (currPtr->pid == pid) // check if we found the proc
80105fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fcd:	8b 40 10             	mov    0x10(%eax),%eax
80105fd0:	3b 45 08             	cmp    0x8(%ebp),%eax
80105fd3:	75 05                	jne    80105fda <findMatchingProcPID+0xce>
      return currPtr;
80105fd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fd8:	eb 43                	jmp    8010601d <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fdd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105fe3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through running list
  currPtr = ptable.pLists.running;
  while(currPtr != 0) {
80105fe6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105fea:	75 de                	jne    80105fca <findMatchingProcPID+0xbe>

    currPtr = currPtr->next;
  }

  // search through embryo list
  currPtr = ptable.pLists.embryo;
80105fec:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80105ff1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105ff4:	eb 1c                	jmp    80106012 <findMatchingProcPID+0x106>
    if (currPtr->pid == pid) // check if we found the proc
80105ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ff9:	8b 40 10             	mov    0x10(%eax),%eax
80105ffc:	3b 45 08             	cmp    0x8(%ebp),%eax
80105fff:	75 05                	jne    80106006 <findMatchingProcPID+0xfa>
      return currPtr;
80106001:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106004:	eb 17                	jmp    8010601d <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80106006:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106009:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010600f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through embryo list
  currPtr = ptable.pLists.embryo;
  while(currPtr != 0) {
80106012:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106016:	75 de                	jne    80105ff6 <findMatchingProcPID+0xea>

    currPtr = currPtr->next;
  }

  // if it isn't found then return null
  return 0;
80106018:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010601d:	c9                   	leave  
8010601e:	c3                   	ret    

8010601f <setpriority>:
// sets process with pid to the specified priority. Also, this resets the budget of this process.
// only checks the RUNNING, SLEEPING, and RUNNABLE process (as mentioned in mailing list)
// returns 0 on success and -1 on error (e.g. didn't find process, or invalid params)
int
setpriority(int pid, int priority) // Added for Project 4: The setpriority() System Call
{
8010601f:	55                   	push   %ebp
80106020:	89 e5                	mov    %esp,%ebp
80106022:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0; 
80106025:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  // check params to ensure no invalid input
  if (pid < 0 || priority < 0 || priority > MAX)
8010602c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106030:	78 0c                	js     8010603e <setpriority+0x1f>
80106032:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106036:	78 06                	js     8010603e <setpriority+0x1f>
80106038:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010603c:	7e 0a                	jle    80106048 <setpriority+0x29>
    return -1;
8010603e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106043:	e9 53 01 00 00       	jmp    8010619b <setpriority+0x17c>

  acquire(&ptable.lock);
80106048:	83 ec 0c             	sub    $0xc,%esp
8010604b:	68 80 49 11 80       	push   $0x80114980
80106050:	e8 ba 02 00 00       	call   8010630f <acquire>
80106055:	83 c4 10             	add    $0x10,%esp
 
  // check running list for process pid
  currPtr = ptable.pLists.running;
80106058:	a1 c4 70 11 80       	mov    0x801170c4,%eax
8010605d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
80106060:	eb 4c                	jmp    801060ae <setpriority+0x8f>
    if(currPtr->pid == pid){
80106062:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106065:	8b 50 10             	mov    0x10(%eax),%edx
80106068:	8b 45 08             	mov    0x8(%ebp),%eax
8010606b:	39 c2                	cmp    %eax,%edx
8010606d:	75 33                	jne    801060a2 <setpriority+0x83>
      currPtr->priority = priority;
8010606f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106075:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
8010607b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607e:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80106085:	01 00 00 
      
      release(&ptable.lock); // since process was found, release lock and return 0 (success)
80106088:	83 ec 0c             	sub    $0xc,%esp
8010608b:	68 80 49 11 80       	push   $0x80114980
80106090:	e8 e1 02 00 00       	call   80106376 <release>
80106095:	83 c4 10             	add    $0x10,%esp
      return 0;
80106098:	b8 00 00 00 00       	mov    $0x0,%eax
8010609d:	e9 f9 00 00 00       	jmp    8010619b <setpriority+0x17c>
    }

    currPtr = currPtr->next;
801060a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&ptable.lock);
 
  // check running list for process pid
  currPtr = ptable.pLists.running;
  while(currPtr != 0){
801060ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060b2:	75 ae                	jne    80106062 <setpriority+0x43>

    currPtr = currPtr->next;
  }

  // check sleep list for process pid
  currPtr = ptable.pLists.sleep;
801060b4:	a1 bc 70 11 80       	mov    0x801170bc,%eax
801060b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
801060bc:	eb 4c                	jmp    8010610a <setpriority+0xeb>

    if(currPtr->pid == pid){
801060be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c1:	8b 50 10             	mov    0x10(%eax),%edx
801060c4:	8b 45 08             	mov    0x8(%ebp),%eax
801060c7:	39 c2                	cmp    %eax,%edx
801060c9:	75 33                	jne    801060fe <setpriority+0xdf>
      currPtr->priority = priority;
801060cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801060ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d1:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
801060d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060da:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
801060e1:	01 00 00 
      
      release(&ptable.lock); // since process was found, release lock and return 0 (success)
801060e4:	83 ec 0c             	sub    $0xc,%esp
801060e7:	68 80 49 11 80       	push   $0x80114980
801060ec:	e8 85 02 00 00       	call   80106376 <release>
801060f1:	83 c4 10             	add    $0x10,%esp
      return 0;
801060f4:	b8 00 00 00 00       	mov    $0x0,%eax
801060f9:	e9 9d 00 00 00       	jmp    8010619b <setpriority+0x17c>
    }

    currPtr = currPtr->next;
801060fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106101:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106107:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // check sleep list for process pid
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0){
8010610a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010610e:	75 ae                	jne    801060be <setpriority+0x9f>
    }

    currPtr = currPtr->next;
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){
80106110:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80106117:	eb 67                	jmp    80106180 <setpriority+0x161>

    currPtr = ptable.pLists.ready[i];
80106119:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010611c:	05 cc 09 00 00       	add    $0x9cc,%eax
80106121:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80106128:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(currPtr != 0){
8010612b:	eb 49                	jmp    80106176 <setpriority+0x157>

      if(currPtr->pid == pid){
8010612d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106130:	8b 50 10             	mov    0x10(%eax),%edx
80106133:	8b 45 08             	mov    0x8(%ebp),%eax
80106136:	39 c2                	cmp    %eax,%edx
80106138:	75 30                	jne    8010616a <setpriority+0x14b>
        currPtr->priority = priority;
8010613a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010613d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106140:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        currPtr->budget = DEFAULT_BUDGET;
80106146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106149:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80106150:	01 00 00 
      
        release(&ptable.lock); // since process was found, release lock and return 0 (success)
80106153:	83 ec 0c             	sub    $0xc,%esp
80106156:	68 80 49 11 80       	push   $0x80114980
8010615b:	e8 16 02 00 00       	call   80106376 <release>
80106160:	83 c4 10             	add    $0x10,%esp
        return 0;
80106163:	b8 00 00 00 00       	mov    $0x0,%eax
80106168:	eb 31                	jmp    8010619b <setpriority+0x17c>
      }

      currPtr = currPtr->next;
8010616a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106173:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){

    currPtr = ptable.pLists.ready[i];
    while(currPtr != 0){
80106176:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010617a:	75 b1                	jne    8010612d <setpriority+0x10e>
    }

    currPtr = currPtr->next;
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){
8010617c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80106180:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106184:	7e 93                	jle    80106119 <setpriority+0xfa>
      currPtr = currPtr->next;
    }
  }

  // if nothing was found, release lock and return -1 (error)
  release(&ptable.lock);
80106186:	83 ec 0c             	sub    $0xc,%esp
80106189:	68 80 49 11 80       	push   $0x80114980
8010618e:	e8 e3 01 00 00       	call   80106376 <release>
80106193:	83 c4 10             	add    $0x10,%esp
  return -1;
80106196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010619b:	c9                   	leave  
8010619c:	c3                   	ret    

8010619d <doPeriodicPromotion>:

// promote all processes within ready, sleeping, and running lists by 1 priority level (this is called from scheduler when we hit ticks threshold) 
void
doPeriodicPromotion(void) // Added for Project 4: Periodic Priority Adjustment
{
8010619d:	55                   	push   %ebp
8010619e:	89 e5                	mov    %esp,%ebp
801061a0:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0;
801061a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
  // reduce priority of procs in running list (if they aren't at 0)
  currPtr = ptable.pLists.running;
801061aa:	a1 c4 70 11 80       	mov    0x801170c4,%eax
801061af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (currPtr != 0){
801061b2:	eb 3b                	jmp    801061ef <doPeriodicPromotion+0x52>
    currPtr->budget = DEFAULT_BUDGET;
801061b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b7:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
801061be:	01 00 00 

    if (currPtr->priority > 0){
801061c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801061ca:	85 c0                	test   %eax,%eax
801061cc:	74 15                	je     801061e3 <doPeriodicPromotion+0x46>
      currPtr->priority--;
801061ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d1:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801061d7:	8d 50 ff             	lea    -0x1(%eax),%edx
801061da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061dd:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    }
      
    currPtr = currPtr->next;
801061e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801061ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc *currPtr = 0;
  
  // reduce priority of procs in running list (if they aren't at 0)
  currPtr = ptable.pLists.running;
  while (currPtr != 0){
801061ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061f3:	75 bf                	jne    801061b4 <doPeriodicPromotion+0x17>
      
    currPtr = currPtr->next;
  }

  // reduce priority of procs in sleep list (if they aren't at 0), also reset budgets
  currPtr = ptable.pLists.sleep;
801061f5:	a1 bc 70 11 80       	mov    0x801170bc,%eax
801061fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
801061fd:	eb 3b                	jmp    8010623a <doPeriodicPromotion+0x9d>
    currPtr->budget = DEFAULT_BUDGET;
801061ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106202:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80106209:	01 00 00 
    
    if (currPtr->priority > 0)
8010620c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106215:	85 c0                	test   %eax,%eax
80106217:	74 15                	je     8010622e <doPeriodicPromotion+0x91>
      currPtr->priority--;
80106219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010621c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106222:	8d 50 ff             	lea    -0x1(%eax),%edx
80106225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106228:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)

    currPtr = currPtr->next;
8010622e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106231:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106237:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // reduce priority of procs in sleep list (if they aren't at 0), also reset budgets
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0){
8010623a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010623e:	75 bf                	jne    801061ff <doPeriodicPromotion+0x62>

    currPtr = currPtr->next;
  }

  // reset budgets of procs already in ready[0] to prevent un-needed budget-resets in the below for/while loop
  currPtr = ptable.pLists.ready[0];
80106240:	a1 b4 70 11 80       	mov    0x801170b4,%eax
80106245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (currPtr != 0){
80106248:	eb 19                	jmp    80106263 <doPeriodicPromotion+0xc6>
    currPtr->budget = DEFAULT_BUDGET;
8010624a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010624d:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80106254:	01 00 00 
    currPtr = currPtr->next;
80106257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010625a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106260:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // reset budgets of procs already in ready[0] to prevent un-needed budget-resets in the below for/while loop
  currPtr = ptable.pLists.ready[0];
  while (currPtr != 0){
80106263:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106267:	75 e1                	jne    8010624a <doPeriodicPromotion+0xad>
    currPtr->budget = DEFAULT_BUDGET;
    currPtr = currPtr->next;
  }
  
  // move procs in priorities 1 through MAX + 1 up one level (and reset their budgets)
  for(int i = 1; i < MAX + 1; ++i)
80106269:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80106270:	eb 3a                	jmp    801062ac <doPeriodicPromotion+0x10f>
    tackToStateListTail(&ptable.pLists.ready[i - 1], RUNNABLE, ptable.pLists.ready[i]);
80106272:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106275:	05 cc 09 00 00       	add    $0x9cc,%eax
8010627a:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80106281:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106284:	83 ea 01             	sub    $0x1,%edx
80106287:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
8010628d:	c1 e2 02             	shl    $0x2,%edx
80106290:	81 c2 80 49 11 80    	add    $0x80114980,%edx
80106296:	83 c2 04             	add    $0x4,%edx
80106299:	83 ec 04             	sub    $0x4,%esp
8010629c:	50                   	push   %eax
8010629d:	6a 03                	push   $0x3
8010629f:	52                   	push   %edx
801062a0:	e8 6f fb ff ff       	call   80105e14 <tackToStateListTail>
801062a5:	83 c4 10             	add    $0x10,%esp
    currPtr->budget = DEFAULT_BUDGET;
    currPtr = currPtr->next;
  }
  
  // move procs in priorities 1 through MAX + 1 up one level (and reset their budgets)
  for(int i = 1; i < MAX + 1; ++i)
801062a8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801062ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062b0:	7e c0                	jle    80106272 <doPeriodicPromotion+0xd5>
    tackToStateListTail(&ptable.pLists.ready[i - 1], RUNNABLE, ptable.pLists.ready[i]);

}
801062b2:	90                   	nop
801062b3:	c9                   	leave  
801062b4:	c3                   	ret    

801062b5 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801062b5:	55                   	push   %ebp
801062b6:	89 e5                	mov    %esp,%ebp
801062b8:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801062bb:	9c                   	pushf  
801062bc:	58                   	pop    %eax
801062bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801062c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801062c3:	c9                   	leave  
801062c4:	c3                   	ret    

801062c5 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801062c5:	55                   	push   %ebp
801062c6:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801062c8:	fa                   	cli    
}
801062c9:	90                   	nop
801062ca:	5d                   	pop    %ebp
801062cb:	c3                   	ret    

801062cc <sti>:

static inline void
sti(void)
{
801062cc:	55                   	push   %ebp
801062cd:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801062cf:	fb                   	sti    
}
801062d0:	90                   	nop
801062d1:	5d                   	pop    %ebp
801062d2:	c3                   	ret    

801062d3 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801062d3:	55                   	push   %ebp
801062d4:	89 e5                	mov    %esp,%ebp
801062d6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801062d9:	8b 55 08             	mov    0x8(%ebp),%edx
801062dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801062df:	8b 4d 08             	mov    0x8(%ebp),%ecx
801062e2:	f0 87 02             	lock xchg %eax,(%edx)
801062e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801062e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801062eb:	c9                   	leave  
801062ec:	c3                   	ret    

801062ed <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801062ed:	55                   	push   %ebp
801062ee:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801062f0:	8b 45 08             	mov    0x8(%ebp),%eax
801062f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801062f6:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801062f9:	8b 45 08             	mov    0x8(%ebp),%eax
801062fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106302:	8b 45 08             	mov    0x8(%ebp),%eax
80106305:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010630c:	90                   	nop
8010630d:	5d                   	pop    %ebp
8010630e:	c3                   	ret    

8010630f <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010630f:	55                   	push   %ebp
80106310:	89 e5                	mov    %esp,%ebp
80106312:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106315:	e8 52 01 00 00       	call   8010646c <pushcli>
  if(holding(lk))
8010631a:	8b 45 08             	mov    0x8(%ebp),%eax
8010631d:	83 ec 0c             	sub    $0xc,%esp
80106320:	50                   	push   %eax
80106321:	e8 1c 01 00 00       	call   80106442 <holding>
80106326:	83 c4 10             	add    $0x10,%esp
80106329:	85 c0                	test   %eax,%eax
8010632b:	74 0d                	je     8010633a <acquire+0x2b>
    panic("acquire");
8010632d:	83 ec 0c             	sub    $0xc,%esp
80106330:	68 6c a0 10 80       	push   $0x8010a06c
80106335:	e8 2c a2 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010633a:	90                   	nop
8010633b:	8b 45 08             	mov    0x8(%ebp),%eax
8010633e:	83 ec 08             	sub    $0x8,%esp
80106341:	6a 01                	push   $0x1
80106343:	50                   	push   %eax
80106344:	e8 8a ff ff ff       	call   801062d3 <xchg>
80106349:	83 c4 10             	add    $0x10,%esp
8010634c:	85 c0                	test   %eax,%eax
8010634e:	75 eb                	jne    8010633b <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80106350:	8b 45 08             	mov    0x8(%ebp),%eax
80106353:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010635a:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010635d:	8b 45 08             	mov    0x8(%ebp),%eax
80106360:	83 c0 0c             	add    $0xc,%eax
80106363:	83 ec 08             	sub    $0x8,%esp
80106366:	50                   	push   %eax
80106367:	8d 45 08             	lea    0x8(%ebp),%eax
8010636a:	50                   	push   %eax
8010636b:	e8 58 00 00 00       	call   801063c8 <getcallerpcs>
80106370:	83 c4 10             	add    $0x10,%esp
}
80106373:	90                   	nop
80106374:	c9                   	leave  
80106375:	c3                   	ret    

80106376 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80106376:	55                   	push   %ebp
80106377:	89 e5                	mov    %esp,%ebp
80106379:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010637c:	83 ec 0c             	sub    $0xc,%esp
8010637f:	ff 75 08             	pushl  0x8(%ebp)
80106382:	e8 bb 00 00 00       	call   80106442 <holding>
80106387:	83 c4 10             	add    $0x10,%esp
8010638a:	85 c0                	test   %eax,%eax
8010638c:	75 0d                	jne    8010639b <release+0x25>
    panic("release");
8010638e:	83 ec 0c             	sub    $0xc,%esp
80106391:	68 74 a0 10 80       	push   $0x8010a074
80106396:	e8 cb a1 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
8010639b:	8b 45 08             	mov    0x8(%ebp),%eax
8010639e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801063a5:	8b 45 08             	mov    0x8(%ebp),%eax
801063a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801063af:	8b 45 08             	mov    0x8(%ebp),%eax
801063b2:	83 ec 08             	sub    $0x8,%esp
801063b5:	6a 00                	push   $0x0
801063b7:	50                   	push   %eax
801063b8:	e8 16 ff ff ff       	call   801062d3 <xchg>
801063bd:	83 c4 10             	add    $0x10,%esp

  popcli();
801063c0:	e8 ec 00 00 00       	call   801064b1 <popcli>
}
801063c5:	90                   	nop
801063c6:	c9                   	leave  
801063c7:	c3                   	ret    

801063c8 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801063c8:	55                   	push   %ebp
801063c9:	89 e5                	mov    %esp,%ebp
801063cb:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801063ce:	8b 45 08             	mov    0x8(%ebp),%eax
801063d1:	83 e8 08             	sub    $0x8,%eax
801063d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801063d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801063de:	eb 38                	jmp    80106418 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801063e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801063e4:	74 53                	je     80106439 <getcallerpcs+0x71>
801063e6:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801063ed:	76 4a                	jbe    80106439 <getcallerpcs+0x71>
801063ef:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801063f3:	74 44                	je     80106439 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801063f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801063f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801063ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80106402:	01 c2                	add    %eax,%edx
80106404:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106407:	8b 40 04             	mov    0x4(%eax),%eax
8010640a:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010640c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010640f:	8b 00                	mov    (%eax),%eax
80106411:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106414:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106418:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010641c:	7e c2                	jle    801063e0 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010641e:	eb 19                	jmp    80106439 <getcallerpcs+0x71>
    pcs[i] = 0;
80106420:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106423:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010642a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010642d:	01 d0                	add    %edx,%eax
8010642f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106435:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106439:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010643d:	7e e1                	jle    80106420 <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010643f:	90                   	nop
80106440:	c9                   	leave  
80106441:	c3                   	ret    

80106442 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106442:	55                   	push   %ebp
80106443:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106445:	8b 45 08             	mov    0x8(%ebp),%eax
80106448:	8b 00                	mov    (%eax),%eax
8010644a:	85 c0                	test   %eax,%eax
8010644c:	74 17                	je     80106465 <holding+0x23>
8010644e:	8b 45 08             	mov    0x8(%ebp),%eax
80106451:	8b 50 08             	mov    0x8(%eax),%edx
80106454:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010645a:	39 c2                	cmp    %eax,%edx
8010645c:	75 07                	jne    80106465 <holding+0x23>
8010645e:	b8 01 00 00 00       	mov    $0x1,%eax
80106463:	eb 05                	jmp    8010646a <holding+0x28>
80106465:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010646a:	5d                   	pop    %ebp
8010646b:	c3                   	ret    

8010646c <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010646c:	55                   	push   %ebp
8010646d:	89 e5                	mov    %esp,%ebp
8010646f:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80106472:	e8 3e fe ff ff       	call   801062b5 <readeflags>
80106477:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010647a:	e8 46 fe ff ff       	call   801062c5 <cli>
  if(cpu->ncli++ == 0)
8010647f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106486:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010648c:	8d 48 01             	lea    0x1(%eax),%ecx
8010648f:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106495:	85 c0                	test   %eax,%eax
80106497:	75 15                	jne    801064ae <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80106499:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010649f:	8b 55 fc             	mov    -0x4(%ebp),%edx
801064a2:	81 e2 00 02 00 00    	and    $0x200,%edx
801064a8:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801064ae:	90                   	nop
801064af:	c9                   	leave  
801064b0:	c3                   	ret    

801064b1 <popcli>:

void
popcli(void)
{
801064b1:	55                   	push   %ebp
801064b2:	89 e5                	mov    %esp,%ebp
801064b4:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801064b7:	e8 f9 fd ff ff       	call   801062b5 <readeflags>
801064bc:	25 00 02 00 00       	and    $0x200,%eax
801064c1:	85 c0                	test   %eax,%eax
801064c3:	74 0d                	je     801064d2 <popcli+0x21>
    panic("popcli - interruptible");
801064c5:	83 ec 0c             	sub    $0xc,%esp
801064c8:	68 7c a0 10 80       	push   $0x8010a07c
801064cd:	e8 94 a0 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801064d2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064d8:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801064de:	83 ea 01             	sub    $0x1,%edx
801064e1:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801064e7:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801064ed:	85 c0                	test   %eax,%eax
801064ef:	79 0d                	jns    801064fe <popcli+0x4d>
    panic("popcli");
801064f1:	83 ec 0c             	sub    $0xc,%esp
801064f4:	68 93 a0 10 80       	push   $0x8010a093
801064f9:	e8 68 a0 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801064fe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106504:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010650a:	85 c0                	test   %eax,%eax
8010650c:	75 15                	jne    80106523 <popcli+0x72>
8010650e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106514:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010651a:	85 c0                	test   %eax,%eax
8010651c:	74 05                	je     80106523 <popcli+0x72>
    sti();
8010651e:	e8 a9 fd ff ff       	call   801062cc <sti>
}
80106523:	90                   	nop
80106524:	c9                   	leave  
80106525:	c3                   	ret    

80106526 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106526:	55                   	push   %ebp
80106527:	89 e5                	mov    %esp,%ebp
80106529:	57                   	push   %edi
8010652a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010652b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010652e:	8b 55 10             	mov    0x10(%ebp),%edx
80106531:	8b 45 0c             	mov    0xc(%ebp),%eax
80106534:	89 cb                	mov    %ecx,%ebx
80106536:	89 df                	mov    %ebx,%edi
80106538:	89 d1                	mov    %edx,%ecx
8010653a:	fc                   	cld    
8010653b:	f3 aa                	rep stos %al,%es:(%edi)
8010653d:	89 ca                	mov    %ecx,%edx
8010653f:	89 fb                	mov    %edi,%ebx
80106541:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106544:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106547:	90                   	nop
80106548:	5b                   	pop    %ebx
80106549:	5f                   	pop    %edi
8010654a:	5d                   	pop    %ebp
8010654b:	c3                   	ret    

8010654c <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010654c:	55                   	push   %ebp
8010654d:	89 e5                	mov    %esp,%ebp
8010654f:	57                   	push   %edi
80106550:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106551:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106554:	8b 55 10             	mov    0x10(%ebp),%edx
80106557:	8b 45 0c             	mov    0xc(%ebp),%eax
8010655a:	89 cb                	mov    %ecx,%ebx
8010655c:	89 df                	mov    %ebx,%edi
8010655e:	89 d1                	mov    %edx,%ecx
80106560:	fc                   	cld    
80106561:	f3 ab                	rep stos %eax,%es:(%edi)
80106563:	89 ca                	mov    %ecx,%edx
80106565:	89 fb                	mov    %edi,%ebx
80106567:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010656a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010656d:	90                   	nop
8010656e:	5b                   	pop    %ebx
8010656f:	5f                   	pop    %edi
80106570:	5d                   	pop    %ebp
80106571:	c3                   	ret    

80106572 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106572:	55                   	push   %ebp
80106573:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106575:	8b 45 08             	mov    0x8(%ebp),%eax
80106578:	83 e0 03             	and    $0x3,%eax
8010657b:	85 c0                	test   %eax,%eax
8010657d:	75 43                	jne    801065c2 <memset+0x50>
8010657f:	8b 45 10             	mov    0x10(%ebp),%eax
80106582:	83 e0 03             	and    $0x3,%eax
80106585:	85 c0                	test   %eax,%eax
80106587:	75 39                	jne    801065c2 <memset+0x50>
    c &= 0xFF;
80106589:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106590:	8b 45 10             	mov    0x10(%ebp),%eax
80106593:	c1 e8 02             	shr    $0x2,%eax
80106596:	89 c1                	mov    %eax,%ecx
80106598:	8b 45 0c             	mov    0xc(%ebp),%eax
8010659b:	c1 e0 18             	shl    $0x18,%eax
8010659e:	89 c2                	mov    %eax,%edx
801065a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801065a3:	c1 e0 10             	shl    $0x10,%eax
801065a6:	09 c2                	or     %eax,%edx
801065a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801065ab:	c1 e0 08             	shl    $0x8,%eax
801065ae:	09 d0                	or     %edx,%eax
801065b0:	0b 45 0c             	or     0xc(%ebp),%eax
801065b3:	51                   	push   %ecx
801065b4:	50                   	push   %eax
801065b5:	ff 75 08             	pushl  0x8(%ebp)
801065b8:	e8 8f ff ff ff       	call   8010654c <stosl>
801065bd:	83 c4 0c             	add    $0xc,%esp
801065c0:	eb 12                	jmp    801065d4 <memset+0x62>
  } else
    stosb(dst, c, n);
801065c2:	8b 45 10             	mov    0x10(%ebp),%eax
801065c5:	50                   	push   %eax
801065c6:	ff 75 0c             	pushl  0xc(%ebp)
801065c9:	ff 75 08             	pushl  0x8(%ebp)
801065cc:	e8 55 ff ff ff       	call   80106526 <stosb>
801065d1:	83 c4 0c             	add    $0xc,%esp
  return dst;
801065d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801065d7:	c9                   	leave  
801065d8:	c3                   	ret    

801065d9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801065d9:	55                   	push   %ebp
801065da:	89 e5                	mov    %esp,%ebp
801065dc:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801065df:	8b 45 08             	mov    0x8(%ebp),%eax
801065e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801065e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801065e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801065eb:	eb 30                	jmp    8010661d <memcmp+0x44>
    if(*s1 != *s2)
801065ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065f0:	0f b6 10             	movzbl (%eax),%edx
801065f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801065f6:	0f b6 00             	movzbl (%eax),%eax
801065f9:	38 c2                	cmp    %al,%dl
801065fb:	74 18                	je     80106615 <memcmp+0x3c>
      return *s1 - *s2;
801065fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106600:	0f b6 00             	movzbl (%eax),%eax
80106603:	0f b6 d0             	movzbl %al,%edx
80106606:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106609:	0f b6 00             	movzbl (%eax),%eax
8010660c:	0f b6 c0             	movzbl %al,%eax
8010660f:	29 c2                	sub    %eax,%edx
80106611:	89 d0                	mov    %edx,%eax
80106613:	eb 1a                	jmp    8010662f <memcmp+0x56>
    s1++, s2++;
80106615:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106619:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010661d:	8b 45 10             	mov    0x10(%ebp),%eax
80106620:	8d 50 ff             	lea    -0x1(%eax),%edx
80106623:	89 55 10             	mov    %edx,0x10(%ebp)
80106626:	85 c0                	test   %eax,%eax
80106628:	75 c3                	jne    801065ed <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010662a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010662f:	c9                   	leave  
80106630:	c3                   	ret    

80106631 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106631:	55                   	push   %ebp
80106632:	89 e5                	mov    %esp,%ebp
80106634:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106637:	8b 45 0c             	mov    0xc(%ebp),%eax
8010663a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010663d:	8b 45 08             	mov    0x8(%ebp),%eax
80106640:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106643:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106646:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106649:	73 54                	jae    8010669f <memmove+0x6e>
8010664b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010664e:	8b 45 10             	mov    0x10(%ebp),%eax
80106651:	01 d0                	add    %edx,%eax
80106653:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106656:	76 47                	jbe    8010669f <memmove+0x6e>
    s += n;
80106658:	8b 45 10             	mov    0x10(%ebp),%eax
8010665b:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010665e:	8b 45 10             	mov    0x10(%ebp),%eax
80106661:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106664:	eb 13                	jmp    80106679 <memmove+0x48>
      *--d = *--s;
80106666:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010666a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010666e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106671:	0f b6 10             	movzbl (%eax),%edx
80106674:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106677:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106679:	8b 45 10             	mov    0x10(%ebp),%eax
8010667c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010667f:	89 55 10             	mov    %edx,0x10(%ebp)
80106682:	85 c0                	test   %eax,%eax
80106684:	75 e0                	jne    80106666 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106686:	eb 24                	jmp    801066ac <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106688:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010668b:	8d 50 01             	lea    0x1(%eax),%edx
8010668e:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106691:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106694:	8d 4a 01             	lea    0x1(%edx),%ecx
80106697:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010669a:	0f b6 12             	movzbl (%edx),%edx
8010669d:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010669f:	8b 45 10             	mov    0x10(%ebp),%eax
801066a2:	8d 50 ff             	lea    -0x1(%eax),%edx
801066a5:	89 55 10             	mov    %edx,0x10(%ebp)
801066a8:	85 c0                	test   %eax,%eax
801066aa:	75 dc                	jne    80106688 <memmove+0x57>
      *d++ = *s++;

  return dst;
801066ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
801066af:	c9                   	leave  
801066b0:	c3                   	ret    

801066b1 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801066b1:	55                   	push   %ebp
801066b2:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801066b4:	ff 75 10             	pushl  0x10(%ebp)
801066b7:	ff 75 0c             	pushl  0xc(%ebp)
801066ba:	ff 75 08             	pushl  0x8(%ebp)
801066bd:	e8 6f ff ff ff       	call   80106631 <memmove>
801066c2:	83 c4 0c             	add    $0xc,%esp
}
801066c5:	c9                   	leave  
801066c6:	c3                   	ret    

801066c7 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801066c7:	55                   	push   %ebp
801066c8:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801066ca:	eb 0c                	jmp    801066d8 <strncmp+0x11>
    n--, p++, q++;
801066cc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801066d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801066d4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801066d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066dc:	74 1a                	je     801066f8 <strncmp+0x31>
801066de:	8b 45 08             	mov    0x8(%ebp),%eax
801066e1:	0f b6 00             	movzbl (%eax),%eax
801066e4:	84 c0                	test   %al,%al
801066e6:	74 10                	je     801066f8 <strncmp+0x31>
801066e8:	8b 45 08             	mov    0x8(%ebp),%eax
801066eb:	0f b6 10             	movzbl (%eax),%edx
801066ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801066f1:	0f b6 00             	movzbl (%eax),%eax
801066f4:	38 c2                	cmp    %al,%dl
801066f6:	74 d4                	je     801066cc <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801066f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066fc:	75 07                	jne    80106705 <strncmp+0x3e>
    return 0;
801066fe:	b8 00 00 00 00       	mov    $0x0,%eax
80106703:	eb 16                	jmp    8010671b <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106705:	8b 45 08             	mov    0x8(%ebp),%eax
80106708:	0f b6 00             	movzbl (%eax),%eax
8010670b:	0f b6 d0             	movzbl %al,%edx
8010670e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106711:	0f b6 00             	movzbl (%eax),%eax
80106714:	0f b6 c0             	movzbl %al,%eax
80106717:	29 c2                	sub    %eax,%edx
80106719:	89 d0                	mov    %edx,%eax
}
8010671b:	5d                   	pop    %ebp
8010671c:	c3                   	ret    

8010671d <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010671d:	55                   	push   %ebp
8010671e:	89 e5                	mov    %esp,%ebp
80106720:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106723:	8b 45 08             	mov    0x8(%ebp),%eax
80106726:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106729:	90                   	nop
8010672a:	8b 45 10             	mov    0x10(%ebp),%eax
8010672d:	8d 50 ff             	lea    -0x1(%eax),%edx
80106730:	89 55 10             	mov    %edx,0x10(%ebp)
80106733:	85 c0                	test   %eax,%eax
80106735:	7e 2c                	jle    80106763 <strncpy+0x46>
80106737:	8b 45 08             	mov    0x8(%ebp),%eax
8010673a:	8d 50 01             	lea    0x1(%eax),%edx
8010673d:	89 55 08             	mov    %edx,0x8(%ebp)
80106740:	8b 55 0c             	mov    0xc(%ebp),%edx
80106743:	8d 4a 01             	lea    0x1(%edx),%ecx
80106746:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106749:	0f b6 12             	movzbl (%edx),%edx
8010674c:	88 10                	mov    %dl,(%eax)
8010674e:	0f b6 00             	movzbl (%eax),%eax
80106751:	84 c0                	test   %al,%al
80106753:	75 d5                	jne    8010672a <strncpy+0xd>
    ;
  while(n-- > 0)
80106755:	eb 0c                	jmp    80106763 <strncpy+0x46>
    *s++ = 0;
80106757:	8b 45 08             	mov    0x8(%ebp),%eax
8010675a:	8d 50 01             	lea    0x1(%eax),%edx
8010675d:	89 55 08             	mov    %edx,0x8(%ebp)
80106760:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106763:	8b 45 10             	mov    0x10(%ebp),%eax
80106766:	8d 50 ff             	lea    -0x1(%eax),%edx
80106769:	89 55 10             	mov    %edx,0x10(%ebp)
8010676c:	85 c0                	test   %eax,%eax
8010676e:	7f e7                	jg     80106757 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106770:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106773:	c9                   	leave  
80106774:	c3                   	ret    

80106775 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106775:	55                   	push   %ebp
80106776:	89 e5                	mov    %esp,%ebp
80106778:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010677b:	8b 45 08             	mov    0x8(%ebp),%eax
8010677e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106781:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106785:	7f 05                	jg     8010678c <safestrcpy+0x17>
    return os;
80106787:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010678a:	eb 31                	jmp    801067bd <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010678c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106790:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106794:	7e 1e                	jle    801067b4 <safestrcpy+0x3f>
80106796:	8b 45 08             	mov    0x8(%ebp),%eax
80106799:	8d 50 01             	lea    0x1(%eax),%edx
8010679c:	89 55 08             	mov    %edx,0x8(%ebp)
8010679f:	8b 55 0c             	mov    0xc(%ebp),%edx
801067a2:	8d 4a 01             	lea    0x1(%edx),%ecx
801067a5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801067a8:	0f b6 12             	movzbl (%edx),%edx
801067ab:	88 10                	mov    %dl,(%eax)
801067ad:	0f b6 00             	movzbl (%eax),%eax
801067b0:	84 c0                	test   %al,%al
801067b2:	75 d8                	jne    8010678c <safestrcpy+0x17>
    ;
  *s = 0;
801067b4:	8b 45 08             	mov    0x8(%ebp),%eax
801067b7:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801067ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801067bd:	c9                   	leave  
801067be:	c3                   	ret    

801067bf <strlen>:

int
strlen(const char *s)
{
801067bf:	55                   	push   %ebp
801067c0:	89 e5                	mov    %esp,%ebp
801067c2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801067c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801067cc:	eb 04                	jmp    801067d2 <strlen+0x13>
801067ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801067d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801067d5:	8b 45 08             	mov    0x8(%ebp),%eax
801067d8:	01 d0                	add    %edx,%eax
801067da:	0f b6 00             	movzbl (%eax),%eax
801067dd:	84 c0                	test   %al,%al
801067df:	75 ed                	jne    801067ce <strlen+0xf>
    ;
  return n;
801067e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801067e4:	c9                   	leave  
801067e5:	c3                   	ret    

801067e6 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801067e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801067ea:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801067ee:	55                   	push   %ebp
  pushl %ebx
801067ef:	53                   	push   %ebx
  pushl %esi
801067f0:	56                   	push   %esi
  pushl %edi
801067f1:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801067f2:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801067f4:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801067f6:	5f                   	pop    %edi
  popl %esi
801067f7:	5e                   	pop    %esi
  popl %ebx
801067f8:	5b                   	pop    %ebx
  popl %ebp
801067f9:	5d                   	pop    %ebp
  ret
801067fa:	c3                   	ret    

801067fb <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801067fb:	55                   	push   %ebp
801067fc:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801067fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106804:	8b 00                	mov    (%eax),%eax
80106806:	3b 45 08             	cmp    0x8(%ebp),%eax
80106809:	76 12                	jbe    8010681d <fetchint+0x22>
8010680b:	8b 45 08             	mov    0x8(%ebp),%eax
8010680e:	8d 50 04             	lea    0x4(%eax),%edx
80106811:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106817:	8b 00                	mov    (%eax),%eax
80106819:	39 c2                	cmp    %eax,%edx
8010681b:	76 07                	jbe    80106824 <fetchint+0x29>
    return -1;
8010681d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106822:	eb 0f                	jmp    80106833 <fetchint+0x38>
  *ip = *(int*)(addr);
80106824:	8b 45 08             	mov    0x8(%ebp),%eax
80106827:	8b 10                	mov    (%eax),%edx
80106829:	8b 45 0c             	mov    0xc(%ebp),%eax
8010682c:	89 10                	mov    %edx,(%eax)
  return 0;
8010682e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106833:	5d                   	pop    %ebp
80106834:	c3                   	ret    

80106835 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106835:	55                   	push   %ebp
80106836:	89 e5                	mov    %esp,%ebp
80106838:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010683b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106841:	8b 00                	mov    (%eax),%eax
80106843:	3b 45 08             	cmp    0x8(%ebp),%eax
80106846:	77 07                	ja     8010684f <fetchstr+0x1a>
    return -1;
80106848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010684d:	eb 46                	jmp    80106895 <fetchstr+0x60>
  *pp = (char*)addr;
8010684f:	8b 55 08             	mov    0x8(%ebp),%edx
80106852:	8b 45 0c             	mov    0xc(%ebp),%eax
80106855:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106857:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010685d:	8b 00                	mov    (%eax),%eax
8010685f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106862:	8b 45 0c             	mov    0xc(%ebp),%eax
80106865:	8b 00                	mov    (%eax),%eax
80106867:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010686a:	eb 1c                	jmp    80106888 <fetchstr+0x53>
    if(*s == 0)
8010686c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010686f:	0f b6 00             	movzbl (%eax),%eax
80106872:	84 c0                	test   %al,%al
80106874:	75 0e                	jne    80106884 <fetchstr+0x4f>
      return s - *pp;
80106876:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106879:	8b 45 0c             	mov    0xc(%ebp),%eax
8010687c:	8b 00                	mov    (%eax),%eax
8010687e:	29 c2                	sub    %eax,%edx
80106880:	89 d0                	mov    %edx,%eax
80106882:	eb 11                	jmp    80106895 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106884:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106888:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010688b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010688e:	72 dc                	jb     8010686c <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106895:	c9                   	leave  
80106896:	c3                   	ret    

80106897 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106897:	55                   	push   %ebp
80106898:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010689a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068a0:	8b 40 18             	mov    0x18(%eax),%eax
801068a3:	8b 40 44             	mov    0x44(%eax),%eax
801068a6:	8b 55 08             	mov    0x8(%ebp),%edx
801068a9:	c1 e2 02             	shl    $0x2,%edx
801068ac:	01 d0                	add    %edx,%eax
801068ae:	83 c0 04             	add    $0x4,%eax
801068b1:	ff 75 0c             	pushl  0xc(%ebp)
801068b4:	50                   	push   %eax
801068b5:	e8 41 ff ff ff       	call   801067fb <fetchint>
801068ba:	83 c4 08             	add    $0x8,%esp
}
801068bd:	c9                   	leave  
801068be:	c3                   	ret    

801068bf <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801068bf:	55                   	push   %ebp
801068c0:	89 e5                	mov    %esp,%ebp
801068c2:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801068c5:	8d 45 fc             	lea    -0x4(%ebp),%eax
801068c8:	50                   	push   %eax
801068c9:	ff 75 08             	pushl  0x8(%ebp)
801068cc:	e8 c6 ff ff ff       	call   80106897 <argint>
801068d1:	83 c4 08             	add    $0x8,%esp
801068d4:	85 c0                	test   %eax,%eax
801068d6:	79 07                	jns    801068df <argptr+0x20>
    return -1;
801068d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068dd:	eb 3b                	jmp    8010691a <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801068df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068e5:	8b 00                	mov    (%eax),%eax
801068e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801068ea:	39 d0                	cmp    %edx,%eax
801068ec:	76 16                	jbe    80106904 <argptr+0x45>
801068ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801068f1:	89 c2                	mov    %eax,%edx
801068f3:	8b 45 10             	mov    0x10(%ebp),%eax
801068f6:	01 c2                	add    %eax,%edx
801068f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068fe:	8b 00                	mov    (%eax),%eax
80106900:	39 c2                	cmp    %eax,%edx
80106902:	76 07                	jbe    8010690b <argptr+0x4c>
    return -1;
80106904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106909:	eb 0f                	jmp    8010691a <argptr+0x5b>
  *pp = (char*)i;
8010690b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010690e:	89 c2                	mov    %eax,%edx
80106910:	8b 45 0c             	mov    0xc(%ebp),%eax
80106913:	89 10                	mov    %edx,(%eax)
  return 0;
80106915:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010691a:	c9                   	leave  
8010691b:	c3                   	ret    

8010691c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010691c:	55                   	push   %ebp
8010691d:	89 e5                	mov    %esp,%ebp
8010691f:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106922:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106925:	50                   	push   %eax
80106926:	ff 75 08             	pushl  0x8(%ebp)
80106929:	e8 69 ff ff ff       	call   80106897 <argint>
8010692e:	83 c4 08             	add    $0x8,%esp
80106931:	85 c0                	test   %eax,%eax
80106933:	79 07                	jns    8010693c <argstr+0x20>
    return -1;
80106935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010693a:	eb 0f                	jmp    8010694b <argstr+0x2f>
  return fetchstr(addr, pp);
8010693c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010693f:	ff 75 0c             	pushl  0xc(%ebp)
80106942:	50                   	push   %eax
80106943:	e8 ed fe ff ff       	call   80106835 <fetchstr>
80106948:	83 c4 08             	add    $0x8,%esp
}
8010694b:	c9                   	leave  
8010694c:	c3                   	ret    

8010694d <syscall>:
#endif
// END: Added for Project 1: System Call Tracing

void
syscall(void)
{
8010694d:	55                   	push   %ebp
8010694e:	89 e5                	mov    %esp,%ebp
80106950:	53                   	push   %ebx
80106951:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106954:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010695a:	8b 40 18             	mov    0x18(%eax),%eax
8010695d:	8b 40 1c             	mov    0x1c(%eax),%eax
80106960:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106967:	7e 30                	jle    80106999 <syscall+0x4c>
80106969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010696c:	83 f8 1c             	cmp    $0x1c,%eax
8010696f:	77 28                	ja     80106999 <syscall+0x4c>
80106971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106974:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
8010697b:	85 c0                	test   %eax,%eax
8010697d:	74 1a                	je     80106999 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
8010697f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106985:	8b 58 18             	mov    0x18(%eax),%ebx
80106988:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010698b:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106992:	ff d0                	call   *%eax
80106994:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106997:	eb 34                	jmp    801069cd <syscall+0x80>
    #endif
    // END: Added for Project 1: System Call Tracing

  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80106999:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010699f:	8d 50 6c             	lea    0x6c(%eax),%edx
801069a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
            syscallnames[num], proc->tf->eax);
    #endif
    // END: Added for Project 1: System Call Tracing

  } else {
    cprintf("%d %s: unknown sys call %d\n",
801069a8:	8b 40 10             	mov    0x10(%eax),%eax
801069ab:	ff 75 f4             	pushl  -0xc(%ebp)
801069ae:	52                   	push   %edx
801069af:	50                   	push   %eax
801069b0:	68 9a a0 10 80       	push   $0x8010a09a
801069b5:	e8 0c 9a ff ff       	call   801003c6 <cprintf>
801069ba:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801069bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069c3:	8b 40 18             	mov    0x18(%eax),%eax
801069c6:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801069cd:	90                   	nop
801069ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801069d1:	c9                   	leave  
801069d2:	c3                   	ret    

801069d3 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801069d3:	55                   	push   %ebp
801069d4:	89 e5                	mov    %esp,%ebp
801069d6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801069d9:	83 ec 08             	sub    $0x8,%esp
801069dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069df:	50                   	push   %eax
801069e0:	ff 75 08             	pushl  0x8(%ebp)
801069e3:	e8 af fe ff ff       	call   80106897 <argint>
801069e8:	83 c4 10             	add    $0x10,%esp
801069eb:	85 c0                	test   %eax,%eax
801069ed:	79 07                	jns    801069f6 <argfd+0x23>
    return -1;
801069ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069f4:	eb 50                	jmp    80106a46 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801069f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069f9:	85 c0                	test   %eax,%eax
801069fb:	78 21                	js     80106a1e <argfd+0x4b>
801069fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a00:	83 f8 0f             	cmp    $0xf,%eax
80106a03:	7f 19                	jg     80106a1e <argfd+0x4b>
80106a05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a0e:	83 c2 08             	add    $0x8,%edx
80106a11:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a1c:	75 07                	jne    80106a25 <argfd+0x52>
    return -1;
80106a1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a23:	eb 21                	jmp    80106a46 <argfd+0x73>
  if(pfd)
80106a25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106a29:	74 08                	je     80106a33 <argfd+0x60>
    *pfd = fd;
80106a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a31:	89 10                	mov    %edx,(%eax)
  if(pf)
80106a33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106a37:	74 08                	je     80106a41 <argfd+0x6e>
    *pf = f;
80106a39:	8b 45 10             	mov    0x10(%ebp),%eax
80106a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a3f:	89 10                	mov    %edx,(%eax)
  return 0;
80106a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a46:	c9                   	leave  
80106a47:	c3                   	ret    

80106a48 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106a48:	55                   	push   %ebp
80106a49:	89 e5                	mov    %esp,%ebp
80106a4b:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106a4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106a55:	eb 30                	jmp    80106a87 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106a57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a60:	83 c2 08             	add    $0x8,%edx
80106a63:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106a67:	85 c0                	test   %eax,%eax
80106a69:	75 18                	jne    80106a83 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106a6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a71:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a74:	8d 4a 08             	lea    0x8(%edx),%ecx
80106a77:	8b 55 08             	mov    0x8(%ebp),%edx
80106a7a:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106a81:	eb 0f                	jmp    80106a92 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106a83:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106a87:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106a8b:	7e ca                	jle    80106a57 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106a8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a92:	c9                   	leave  
80106a93:	c3                   	ret    

80106a94 <sys_dup>:

int
sys_dup(void)
{
80106a94:	55                   	push   %ebp
80106a95:	89 e5                	mov    %esp,%ebp
80106a97:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106a9a:	83 ec 04             	sub    $0x4,%esp
80106a9d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106aa0:	50                   	push   %eax
80106aa1:	6a 00                	push   $0x0
80106aa3:	6a 00                	push   $0x0
80106aa5:	e8 29 ff ff ff       	call   801069d3 <argfd>
80106aaa:	83 c4 10             	add    $0x10,%esp
80106aad:	85 c0                	test   %eax,%eax
80106aaf:	79 07                	jns    80106ab8 <sys_dup+0x24>
    return -1;
80106ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ab6:	eb 31                	jmp    80106ae9 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106abb:	83 ec 0c             	sub    $0xc,%esp
80106abe:	50                   	push   %eax
80106abf:	e8 84 ff ff ff       	call   80106a48 <fdalloc>
80106ac4:	83 c4 10             	add    $0x10,%esp
80106ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106aca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ace:	79 07                	jns    80106ad7 <sys_dup+0x43>
    return -1;
80106ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ad5:	eb 12                	jmp    80106ae9 <sys_dup+0x55>
  filedup(f);
80106ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ada:	83 ec 0c             	sub    $0xc,%esp
80106add:	50                   	push   %eax
80106ade:	e8 c3 a5 ff ff       	call   801010a6 <filedup>
80106ae3:	83 c4 10             	add    $0x10,%esp
  return fd;
80106ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106ae9:	c9                   	leave  
80106aea:	c3                   	ret    

80106aeb <sys_read>:

int
sys_read(void)
{
80106aeb:	55                   	push   %ebp
80106aec:	89 e5                	mov    %esp,%ebp
80106aee:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106af1:	83 ec 04             	sub    $0x4,%esp
80106af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106af7:	50                   	push   %eax
80106af8:	6a 00                	push   $0x0
80106afa:	6a 00                	push   $0x0
80106afc:	e8 d2 fe ff ff       	call   801069d3 <argfd>
80106b01:	83 c4 10             	add    $0x10,%esp
80106b04:	85 c0                	test   %eax,%eax
80106b06:	78 2e                	js     80106b36 <sys_read+0x4b>
80106b08:	83 ec 08             	sub    $0x8,%esp
80106b0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b0e:	50                   	push   %eax
80106b0f:	6a 02                	push   $0x2
80106b11:	e8 81 fd ff ff       	call   80106897 <argint>
80106b16:	83 c4 10             	add    $0x10,%esp
80106b19:	85 c0                	test   %eax,%eax
80106b1b:	78 19                	js     80106b36 <sys_read+0x4b>
80106b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b20:	83 ec 04             	sub    $0x4,%esp
80106b23:	50                   	push   %eax
80106b24:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b27:	50                   	push   %eax
80106b28:	6a 01                	push   $0x1
80106b2a:	e8 90 fd ff ff       	call   801068bf <argptr>
80106b2f:	83 c4 10             	add    $0x10,%esp
80106b32:	85 c0                	test   %eax,%eax
80106b34:	79 07                	jns    80106b3d <sys_read+0x52>
    return -1;
80106b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b3b:	eb 17                	jmp    80106b54 <sys_read+0x69>
  return fileread(f, p, n);
80106b3d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106b40:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b46:	83 ec 04             	sub    $0x4,%esp
80106b49:	51                   	push   %ecx
80106b4a:	52                   	push   %edx
80106b4b:	50                   	push   %eax
80106b4c:	e8 e5 a6 ff ff       	call   80101236 <fileread>
80106b51:	83 c4 10             	add    $0x10,%esp
}
80106b54:	c9                   	leave  
80106b55:	c3                   	ret    

80106b56 <sys_write>:

int
sys_write(void)
{
80106b56:	55                   	push   %ebp
80106b57:	89 e5                	mov    %esp,%ebp
80106b59:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106b5c:	83 ec 04             	sub    $0x4,%esp
80106b5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b62:	50                   	push   %eax
80106b63:	6a 00                	push   $0x0
80106b65:	6a 00                	push   $0x0
80106b67:	e8 67 fe ff ff       	call   801069d3 <argfd>
80106b6c:	83 c4 10             	add    $0x10,%esp
80106b6f:	85 c0                	test   %eax,%eax
80106b71:	78 2e                	js     80106ba1 <sys_write+0x4b>
80106b73:	83 ec 08             	sub    $0x8,%esp
80106b76:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b79:	50                   	push   %eax
80106b7a:	6a 02                	push   $0x2
80106b7c:	e8 16 fd ff ff       	call   80106897 <argint>
80106b81:	83 c4 10             	add    $0x10,%esp
80106b84:	85 c0                	test   %eax,%eax
80106b86:	78 19                	js     80106ba1 <sys_write+0x4b>
80106b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b8b:	83 ec 04             	sub    $0x4,%esp
80106b8e:	50                   	push   %eax
80106b8f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b92:	50                   	push   %eax
80106b93:	6a 01                	push   $0x1
80106b95:	e8 25 fd ff ff       	call   801068bf <argptr>
80106b9a:	83 c4 10             	add    $0x10,%esp
80106b9d:	85 c0                	test   %eax,%eax
80106b9f:	79 07                	jns    80106ba8 <sys_write+0x52>
    return -1;
80106ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ba6:	eb 17                	jmp    80106bbf <sys_write+0x69>
  return filewrite(f, p, n);
80106ba8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106bab:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb1:	83 ec 04             	sub    $0x4,%esp
80106bb4:	51                   	push   %ecx
80106bb5:	52                   	push   %edx
80106bb6:	50                   	push   %eax
80106bb7:	e8 32 a7 ff ff       	call   801012ee <filewrite>
80106bbc:	83 c4 10             	add    $0x10,%esp
}
80106bbf:	c9                   	leave  
80106bc0:	c3                   	ret    

80106bc1 <sys_close>:

int
sys_close(void)
{
80106bc1:	55                   	push   %ebp
80106bc2:	89 e5                	mov    %esp,%ebp
80106bc4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106bc7:	83 ec 04             	sub    $0x4,%esp
80106bca:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bcd:	50                   	push   %eax
80106bce:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bd1:	50                   	push   %eax
80106bd2:	6a 00                	push   $0x0
80106bd4:	e8 fa fd ff ff       	call   801069d3 <argfd>
80106bd9:	83 c4 10             	add    $0x10,%esp
80106bdc:	85 c0                	test   %eax,%eax
80106bde:	79 07                	jns    80106be7 <sys_close+0x26>
    return -1;
80106be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106be5:	eb 28                	jmp    80106c0f <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106be7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106bf0:	83 c2 08             	add    $0x8,%edx
80106bf3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106bfa:	00 
  fileclose(f);
80106bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bfe:	83 ec 0c             	sub    $0xc,%esp
80106c01:	50                   	push   %eax
80106c02:	e8 f0 a4 ff ff       	call   801010f7 <fileclose>
80106c07:	83 c4 10             	add    $0x10,%esp
  return 0;
80106c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c0f:	c9                   	leave  
80106c10:	c3                   	ret    

80106c11 <sys_fstat>:

int
sys_fstat(void)
{
80106c11:	55                   	push   %ebp
80106c12:	89 e5                	mov    %esp,%ebp
80106c14:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106c17:	83 ec 04             	sub    $0x4,%esp
80106c1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c1d:	50                   	push   %eax
80106c1e:	6a 00                	push   $0x0
80106c20:	6a 00                	push   $0x0
80106c22:	e8 ac fd ff ff       	call   801069d3 <argfd>
80106c27:	83 c4 10             	add    $0x10,%esp
80106c2a:	85 c0                	test   %eax,%eax
80106c2c:	78 17                	js     80106c45 <sys_fstat+0x34>
80106c2e:	83 ec 04             	sub    $0x4,%esp
80106c31:	6a 14                	push   $0x14
80106c33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c36:	50                   	push   %eax
80106c37:	6a 01                	push   $0x1
80106c39:	e8 81 fc ff ff       	call   801068bf <argptr>
80106c3e:	83 c4 10             	add    $0x10,%esp
80106c41:	85 c0                	test   %eax,%eax
80106c43:	79 07                	jns    80106c4c <sys_fstat+0x3b>
    return -1;
80106c45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c4a:	eb 13                	jmp    80106c5f <sys_fstat+0x4e>
  return filestat(f, st);
80106c4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c52:	83 ec 08             	sub    $0x8,%esp
80106c55:	52                   	push   %edx
80106c56:	50                   	push   %eax
80106c57:	e8 83 a5 ff ff       	call   801011df <filestat>
80106c5c:	83 c4 10             	add    $0x10,%esp
}
80106c5f:	c9                   	leave  
80106c60:	c3                   	ret    

80106c61 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106c61:	55                   	push   %ebp
80106c62:	89 e5                	mov    %esp,%ebp
80106c64:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106c67:	83 ec 08             	sub    $0x8,%esp
80106c6a:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106c6d:	50                   	push   %eax
80106c6e:	6a 00                	push   $0x0
80106c70:	e8 a7 fc ff ff       	call   8010691c <argstr>
80106c75:	83 c4 10             	add    $0x10,%esp
80106c78:	85 c0                	test   %eax,%eax
80106c7a:	78 15                	js     80106c91 <sys_link+0x30>
80106c7c:	83 ec 08             	sub    $0x8,%esp
80106c7f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106c82:	50                   	push   %eax
80106c83:	6a 01                	push   $0x1
80106c85:	e8 92 fc ff ff       	call   8010691c <argstr>
80106c8a:	83 c4 10             	add    $0x10,%esp
80106c8d:	85 c0                	test   %eax,%eax
80106c8f:	79 0a                	jns    80106c9b <sys_link+0x3a>
    return -1;
80106c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c96:	e9 68 01 00 00       	jmp    80106e03 <sys_link+0x1a2>

  begin_op();
80106c9b:	e8 53 c9 ff ff       	call   801035f3 <begin_op>
  if((ip = namei(old)) == 0){
80106ca0:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106ca3:	83 ec 0c             	sub    $0xc,%esp
80106ca6:	50                   	push   %eax
80106ca7:	e8 22 b9 ff ff       	call   801025ce <namei>
80106cac:	83 c4 10             	add    $0x10,%esp
80106caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106cb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106cb6:	75 0f                	jne    80106cc7 <sys_link+0x66>
    end_op();
80106cb8:	e8 c2 c9 ff ff       	call   8010367f <end_op>
    return -1;
80106cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cc2:	e9 3c 01 00 00       	jmp    80106e03 <sys_link+0x1a2>
  }

  ilock(ip);
80106cc7:	83 ec 0c             	sub    $0xc,%esp
80106cca:	ff 75 f4             	pushl  -0xc(%ebp)
80106ccd:	e8 3e ad ff ff       	call   80101a10 <ilock>
80106cd2:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106cdc:	66 83 f8 01          	cmp    $0x1,%ax
80106ce0:	75 1d                	jne    80106cff <sys_link+0x9e>
    iunlockput(ip);
80106ce2:	83 ec 0c             	sub    $0xc,%esp
80106ce5:	ff 75 f4             	pushl  -0xc(%ebp)
80106ce8:	e8 e3 af ff ff       	call   80101cd0 <iunlockput>
80106ced:	83 c4 10             	add    $0x10,%esp
    end_op();
80106cf0:	e8 8a c9 ff ff       	call   8010367f <end_op>
    return -1;
80106cf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cfa:	e9 04 01 00 00       	jmp    80106e03 <sys_link+0x1a2>
  }

  ip->nlink++;
80106cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d02:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106d06:	83 c0 01             	add    $0x1,%eax
80106d09:	89 c2                	mov    %eax,%edx
80106d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d0e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106d12:	83 ec 0c             	sub    $0xc,%esp
80106d15:	ff 75 f4             	pushl  -0xc(%ebp)
80106d18:	e8 19 ab ff ff       	call   80101836 <iupdate>
80106d1d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106d20:	83 ec 0c             	sub    $0xc,%esp
80106d23:	ff 75 f4             	pushl  -0xc(%ebp)
80106d26:	e8 43 ae ff ff       	call   80101b6e <iunlock>
80106d2b:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106d2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d31:	83 ec 08             	sub    $0x8,%esp
80106d34:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106d37:	52                   	push   %edx
80106d38:	50                   	push   %eax
80106d39:	e8 ac b8 ff ff       	call   801025ea <nameiparent>
80106d3e:	83 c4 10             	add    $0x10,%esp
80106d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106d44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d48:	74 71                	je     80106dbb <sys_link+0x15a>
    goto bad;
  ilock(dp);
80106d4a:	83 ec 0c             	sub    $0xc,%esp
80106d4d:	ff 75 f0             	pushl  -0x10(%ebp)
80106d50:	e8 bb ac ff ff       	call   80101a10 <ilock>
80106d55:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d5b:	8b 10                	mov    (%eax),%edx
80106d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d60:	8b 00                	mov    (%eax),%eax
80106d62:	39 c2                	cmp    %eax,%edx
80106d64:	75 1d                	jne    80106d83 <sys_link+0x122>
80106d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d69:	8b 40 04             	mov    0x4(%eax),%eax
80106d6c:	83 ec 04             	sub    $0x4,%esp
80106d6f:	50                   	push   %eax
80106d70:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106d73:	50                   	push   %eax
80106d74:	ff 75 f0             	pushl  -0x10(%ebp)
80106d77:	e8 b6 b5 ff ff       	call   80102332 <dirlink>
80106d7c:	83 c4 10             	add    $0x10,%esp
80106d7f:	85 c0                	test   %eax,%eax
80106d81:	79 10                	jns    80106d93 <sys_link+0x132>
    iunlockput(dp);
80106d83:	83 ec 0c             	sub    $0xc,%esp
80106d86:	ff 75 f0             	pushl  -0x10(%ebp)
80106d89:	e8 42 af ff ff       	call   80101cd0 <iunlockput>
80106d8e:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106d91:	eb 29                	jmp    80106dbc <sys_link+0x15b>
  }
  iunlockput(dp);
80106d93:	83 ec 0c             	sub    $0xc,%esp
80106d96:	ff 75 f0             	pushl  -0x10(%ebp)
80106d99:	e8 32 af ff ff       	call   80101cd0 <iunlockput>
80106d9e:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106da1:	83 ec 0c             	sub    $0xc,%esp
80106da4:	ff 75 f4             	pushl  -0xc(%ebp)
80106da7:	e8 34 ae ff ff       	call   80101be0 <iput>
80106dac:	83 c4 10             	add    $0x10,%esp

  end_op();
80106daf:	e8 cb c8 ff ff       	call   8010367f <end_op>

  return 0;
80106db4:	b8 00 00 00 00       	mov    $0x0,%eax
80106db9:	eb 48                	jmp    80106e03 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106dbb:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80106dbc:	83 ec 0c             	sub    $0xc,%esp
80106dbf:	ff 75 f4             	pushl  -0xc(%ebp)
80106dc2:	e8 49 ac ff ff       	call   80101a10 <ilock>
80106dc7:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dcd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106dd1:	83 e8 01             	sub    $0x1,%eax
80106dd4:	89 c2                	mov    %eax,%edx
80106dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dd9:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106ddd:	83 ec 0c             	sub    $0xc,%esp
80106de0:	ff 75 f4             	pushl  -0xc(%ebp)
80106de3:	e8 4e aa ff ff       	call   80101836 <iupdate>
80106de8:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106deb:	83 ec 0c             	sub    $0xc,%esp
80106dee:	ff 75 f4             	pushl  -0xc(%ebp)
80106df1:	e8 da ae ff ff       	call   80101cd0 <iunlockput>
80106df6:	83 c4 10             	add    $0x10,%esp
  end_op();
80106df9:	e8 81 c8 ff ff       	call   8010367f <end_op>
  return -1;
80106dfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e03:	c9                   	leave  
80106e04:	c3                   	ret    

80106e05 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106e05:	55                   	push   %ebp
80106e06:	89 e5                	mov    %esp,%ebp
80106e08:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106e0b:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106e12:	eb 40                	jmp    80106e54 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e17:	6a 10                	push   $0x10
80106e19:	50                   	push   %eax
80106e1a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106e1d:	50                   	push   %eax
80106e1e:	ff 75 08             	pushl  0x8(%ebp)
80106e21:	e8 58 b1 ff ff       	call   80101f7e <readi>
80106e26:	83 c4 10             	add    $0x10,%esp
80106e29:	83 f8 10             	cmp    $0x10,%eax
80106e2c:	74 0d                	je     80106e3b <isdirempty+0x36>
      panic("isdirempty: readi");
80106e2e:	83 ec 0c             	sub    $0xc,%esp
80106e31:	68 b6 a0 10 80       	push   $0x8010a0b6
80106e36:	e8 2b 97 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80106e3b:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106e3f:	66 85 c0             	test   %ax,%ax
80106e42:	74 07                	je     80106e4b <isdirempty+0x46>
      return 0;
80106e44:	b8 00 00 00 00       	mov    $0x0,%eax
80106e49:	eb 1b                	jmp    80106e66 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e4e:	83 c0 10             	add    $0x10,%eax
80106e51:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e54:	8b 45 08             	mov    0x8(%ebp),%eax
80106e57:	8b 50 18             	mov    0x18(%eax),%edx
80106e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e5d:	39 c2                	cmp    %eax,%edx
80106e5f:	77 b3                	ja     80106e14 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106e61:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106e66:	c9                   	leave  
80106e67:	c3                   	ret    

80106e68 <sys_unlink>:

int
sys_unlink(void)
{
80106e68:	55                   	push   %ebp
80106e69:	89 e5                	mov    %esp,%ebp
80106e6b:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106e6e:	83 ec 08             	sub    $0x8,%esp
80106e71:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106e74:	50                   	push   %eax
80106e75:	6a 00                	push   $0x0
80106e77:	e8 a0 fa ff ff       	call   8010691c <argstr>
80106e7c:	83 c4 10             	add    $0x10,%esp
80106e7f:	85 c0                	test   %eax,%eax
80106e81:	79 0a                	jns    80106e8d <sys_unlink+0x25>
    return -1;
80106e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e88:	e9 bc 01 00 00       	jmp    80107049 <sys_unlink+0x1e1>

  begin_op();
80106e8d:	e8 61 c7 ff ff       	call   801035f3 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106e92:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106e95:	83 ec 08             	sub    $0x8,%esp
80106e98:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106e9b:	52                   	push   %edx
80106e9c:	50                   	push   %eax
80106e9d:	e8 48 b7 ff ff       	call   801025ea <nameiparent>
80106ea2:	83 c4 10             	add    $0x10,%esp
80106ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ea8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106eac:	75 0f                	jne    80106ebd <sys_unlink+0x55>
    end_op();
80106eae:	e8 cc c7 ff ff       	call   8010367f <end_op>
    return -1;
80106eb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eb8:	e9 8c 01 00 00       	jmp    80107049 <sys_unlink+0x1e1>
  }

  ilock(dp);
80106ebd:	83 ec 0c             	sub    $0xc,%esp
80106ec0:	ff 75 f4             	pushl  -0xc(%ebp)
80106ec3:	e8 48 ab ff ff       	call   80101a10 <ilock>
80106ec8:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106ecb:	83 ec 08             	sub    $0x8,%esp
80106ece:	68 c8 a0 10 80       	push   $0x8010a0c8
80106ed3:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106ed6:	50                   	push   %eax
80106ed7:	e8 81 b3 ff ff       	call   8010225d <namecmp>
80106edc:	83 c4 10             	add    $0x10,%esp
80106edf:	85 c0                	test   %eax,%eax
80106ee1:	0f 84 4a 01 00 00    	je     80107031 <sys_unlink+0x1c9>
80106ee7:	83 ec 08             	sub    $0x8,%esp
80106eea:	68 ca a0 10 80       	push   $0x8010a0ca
80106eef:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106ef2:	50                   	push   %eax
80106ef3:	e8 65 b3 ff ff       	call   8010225d <namecmp>
80106ef8:	83 c4 10             	add    $0x10,%esp
80106efb:	85 c0                	test   %eax,%eax
80106efd:	0f 84 2e 01 00 00    	je     80107031 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106f03:	83 ec 04             	sub    $0x4,%esp
80106f06:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106f09:	50                   	push   %eax
80106f0a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106f0d:	50                   	push   %eax
80106f0e:	ff 75 f4             	pushl  -0xc(%ebp)
80106f11:	e8 62 b3 ff ff       	call   80102278 <dirlookup>
80106f16:	83 c4 10             	add    $0x10,%esp
80106f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106f1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106f20:	0f 84 0a 01 00 00    	je     80107030 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106f26:	83 ec 0c             	sub    $0xc,%esp
80106f29:	ff 75 f0             	pushl  -0x10(%ebp)
80106f2c:	e8 df aa ff ff       	call   80101a10 <ilock>
80106f31:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f37:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106f3b:	66 85 c0             	test   %ax,%ax
80106f3e:	7f 0d                	jg     80106f4d <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106f40:	83 ec 0c             	sub    $0xc,%esp
80106f43:	68 cd a0 10 80       	push   $0x8010a0cd
80106f48:	e8 19 96 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f50:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106f54:	66 83 f8 01          	cmp    $0x1,%ax
80106f58:	75 25                	jne    80106f7f <sys_unlink+0x117>
80106f5a:	83 ec 0c             	sub    $0xc,%esp
80106f5d:	ff 75 f0             	pushl  -0x10(%ebp)
80106f60:	e8 a0 fe ff ff       	call   80106e05 <isdirempty>
80106f65:	83 c4 10             	add    $0x10,%esp
80106f68:	85 c0                	test   %eax,%eax
80106f6a:	75 13                	jne    80106f7f <sys_unlink+0x117>
    iunlockput(ip);
80106f6c:	83 ec 0c             	sub    $0xc,%esp
80106f6f:	ff 75 f0             	pushl  -0x10(%ebp)
80106f72:	e8 59 ad ff ff       	call   80101cd0 <iunlockput>
80106f77:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106f7a:	e9 b2 00 00 00       	jmp    80107031 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106f7f:	83 ec 04             	sub    $0x4,%esp
80106f82:	6a 10                	push   $0x10
80106f84:	6a 00                	push   $0x0
80106f86:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106f89:	50                   	push   %eax
80106f8a:	e8 e3 f5 ff ff       	call   80106572 <memset>
80106f8f:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106f92:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106f95:	6a 10                	push   $0x10
80106f97:	50                   	push   %eax
80106f98:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106f9b:	50                   	push   %eax
80106f9c:	ff 75 f4             	pushl  -0xc(%ebp)
80106f9f:	e8 31 b1 ff ff       	call   801020d5 <writei>
80106fa4:	83 c4 10             	add    $0x10,%esp
80106fa7:	83 f8 10             	cmp    $0x10,%eax
80106faa:	74 0d                	je     80106fb9 <sys_unlink+0x151>
    panic("unlink: writei");
80106fac:	83 ec 0c             	sub    $0xc,%esp
80106faf:	68 df a0 10 80       	push   $0x8010a0df
80106fb4:	e8 ad 95 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80106fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fbc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106fc0:	66 83 f8 01          	cmp    $0x1,%ax
80106fc4:	75 21                	jne    80106fe7 <sys_unlink+0x17f>
    dp->nlink--;
80106fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fc9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106fcd:	83 e8 01             	sub    $0x1,%eax
80106fd0:	89 c2                	mov    %eax,%edx
80106fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fd5:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106fd9:	83 ec 0c             	sub    $0xc,%esp
80106fdc:	ff 75 f4             	pushl  -0xc(%ebp)
80106fdf:	e8 52 a8 ff ff       	call   80101836 <iupdate>
80106fe4:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106fe7:	83 ec 0c             	sub    $0xc,%esp
80106fea:	ff 75 f4             	pushl  -0xc(%ebp)
80106fed:	e8 de ac ff ff       	call   80101cd0 <iunlockput>
80106ff2:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ff8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106ffc:	83 e8 01             	sub    $0x1,%eax
80106fff:	89 c2                	mov    %eax,%edx
80107001:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107004:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107008:	83 ec 0c             	sub    $0xc,%esp
8010700b:	ff 75 f0             	pushl  -0x10(%ebp)
8010700e:	e8 23 a8 ff ff       	call   80101836 <iupdate>
80107013:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107016:	83 ec 0c             	sub    $0xc,%esp
80107019:	ff 75 f0             	pushl  -0x10(%ebp)
8010701c:	e8 af ac ff ff       	call   80101cd0 <iunlockput>
80107021:	83 c4 10             	add    $0x10,%esp

  end_op();
80107024:	e8 56 c6 ff ff       	call   8010367f <end_op>

  return 0;
80107029:	b8 00 00 00 00       	mov    $0x0,%eax
8010702e:	eb 19                	jmp    80107049 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80107030:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80107031:	83 ec 0c             	sub    $0xc,%esp
80107034:	ff 75 f4             	pushl  -0xc(%ebp)
80107037:	e8 94 ac ff ff       	call   80101cd0 <iunlockput>
8010703c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010703f:	e8 3b c6 ff ff       	call   8010367f <end_op>
  return -1;
80107044:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107049:	c9                   	leave  
8010704a:	c3                   	ret    

8010704b <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010704b:	55                   	push   %ebp
8010704c:	89 e5                	mov    %esp,%ebp
8010704e:	83 ec 38             	sub    $0x38,%esp
80107051:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107054:	8b 55 10             	mov    0x10(%ebp),%edx
80107057:	8b 45 14             	mov    0x14(%ebp),%eax
8010705a:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010705e:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80107062:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80107066:	83 ec 08             	sub    $0x8,%esp
80107069:	8d 45 de             	lea    -0x22(%ebp),%eax
8010706c:	50                   	push   %eax
8010706d:	ff 75 08             	pushl  0x8(%ebp)
80107070:	e8 75 b5 ff ff       	call   801025ea <nameiparent>
80107075:	83 c4 10             	add    $0x10,%esp
80107078:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010707b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010707f:	75 0a                	jne    8010708b <create+0x40>
    return 0;
80107081:	b8 00 00 00 00       	mov    $0x0,%eax
80107086:	e9 90 01 00 00       	jmp    8010721b <create+0x1d0>
  ilock(dp);
8010708b:	83 ec 0c             	sub    $0xc,%esp
8010708e:	ff 75 f4             	pushl  -0xc(%ebp)
80107091:	e8 7a a9 ff ff       	call   80101a10 <ilock>
80107096:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80107099:	83 ec 04             	sub    $0x4,%esp
8010709c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010709f:	50                   	push   %eax
801070a0:	8d 45 de             	lea    -0x22(%ebp),%eax
801070a3:	50                   	push   %eax
801070a4:	ff 75 f4             	pushl  -0xc(%ebp)
801070a7:	e8 cc b1 ff ff       	call   80102278 <dirlookup>
801070ac:	83 c4 10             	add    $0x10,%esp
801070af:	89 45 f0             	mov    %eax,-0x10(%ebp)
801070b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801070b6:	74 50                	je     80107108 <create+0xbd>
    iunlockput(dp);
801070b8:	83 ec 0c             	sub    $0xc,%esp
801070bb:	ff 75 f4             	pushl  -0xc(%ebp)
801070be:	e8 0d ac ff ff       	call   80101cd0 <iunlockput>
801070c3:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801070c6:	83 ec 0c             	sub    $0xc,%esp
801070c9:	ff 75 f0             	pushl  -0x10(%ebp)
801070cc:	e8 3f a9 ff ff       	call   80101a10 <ilock>
801070d1:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801070d4:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801070d9:	75 15                	jne    801070f0 <create+0xa5>
801070db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070de:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801070e2:	66 83 f8 02          	cmp    $0x2,%ax
801070e6:	75 08                	jne    801070f0 <create+0xa5>
      return ip;
801070e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070eb:	e9 2b 01 00 00       	jmp    8010721b <create+0x1d0>
    iunlockput(ip);
801070f0:	83 ec 0c             	sub    $0xc,%esp
801070f3:	ff 75 f0             	pushl  -0x10(%ebp)
801070f6:	e8 d5 ab ff ff       	call   80101cd0 <iunlockput>
801070fb:	83 c4 10             	add    $0x10,%esp
    return 0;
801070fe:	b8 00 00 00 00       	mov    $0x0,%eax
80107103:	e9 13 01 00 00       	jmp    8010721b <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80107108:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010710c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010710f:	8b 00                	mov    (%eax),%eax
80107111:	83 ec 08             	sub    $0x8,%esp
80107114:	52                   	push   %edx
80107115:	50                   	push   %eax
80107116:	e8 44 a6 ff ff       	call   8010175f <ialloc>
8010711b:	83 c4 10             	add    $0x10,%esp
8010711e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107121:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107125:	75 0d                	jne    80107134 <create+0xe9>
    panic("create: ialloc");
80107127:	83 ec 0c             	sub    $0xc,%esp
8010712a:	68 ee a0 10 80       	push   $0x8010a0ee
8010712f:	e8 32 94 ff ff       	call   80100566 <panic>

  ilock(ip);
80107134:	83 ec 0c             	sub    $0xc,%esp
80107137:	ff 75 f0             	pushl  -0x10(%ebp)
8010713a:	e8 d1 a8 ff ff       	call   80101a10 <ilock>
8010713f:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107142:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107145:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80107149:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010714d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107150:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107154:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107158:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010715b:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80107161:	83 ec 0c             	sub    $0xc,%esp
80107164:	ff 75 f0             	pushl  -0x10(%ebp)
80107167:	e8 ca a6 ff ff       	call   80101836 <iupdate>
8010716c:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010716f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80107174:	75 6a                	jne    801071e0 <create+0x195>
    dp->nlink++;  // for ".."
80107176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107179:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010717d:	83 c0 01             	add    $0x1,%eax
80107180:	89 c2                	mov    %eax,%edx
80107182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107185:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107189:	83 ec 0c             	sub    $0xc,%esp
8010718c:	ff 75 f4             	pushl  -0xc(%ebp)
8010718f:	e8 a2 a6 ff ff       	call   80101836 <iupdate>
80107194:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107197:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010719a:	8b 40 04             	mov    0x4(%eax),%eax
8010719d:	83 ec 04             	sub    $0x4,%esp
801071a0:	50                   	push   %eax
801071a1:	68 c8 a0 10 80       	push   $0x8010a0c8
801071a6:	ff 75 f0             	pushl  -0x10(%ebp)
801071a9:	e8 84 b1 ff ff       	call   80102332 <dirlink>
801071ae:	83 c4 10             	add    $0x10,%esp
801071b1:	85 c0                	test   %eax,%eax
801071b3:	78 1e                	js     801071d3 <create+0x188>
801071b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071b8:	8b 40 04             	mov    0x4(%eax),%eax
801071bb:	83 ec 04             	sub    $0x4,%esp
801071be:	50                   	push   %eax
801071bf:	68 ca a0 10 80       	push   $0x8010a0ca
801071c4:	ff 75 f0             	pushl  -0x10(%ebp)
801071c7:	e8 66 b1 ff ff       	call   80102332 <dirlink>
801071cc:	83 c4 10             	add    $0x10,%esp
801071cf:	85 c0                	test   %eax,%eax
801071d1:	79 0d                	jns    801071e0 <create+0x195>
      panic("create dots");
801071d3:	83 ec 0c             	sub    $0xc,%esp
801071d6:	68 fd a0 10 80       	push   $0x8010a0fd
801071db:	e8 86 93 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801071e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071e3:	8b 40 04             	mov    0x4(%eax),%eax
801071e6:	83 ec 04             	sub    $0x4,%esp
801071e9:	50                   	push   %eax
801071ea:	8d 45 de             	lea    -0x22(%ebp),%eax
801071ed:	50                   	push   %eax
801071ee:	ff 75 f4             	pushl  -0xc(%ebp)
801071f1:	e8 3c b1 ff ff       	call   80102332 <dirlink>
801071f6:	83 c4 10             	add    $0x10,%esp
801071f9:	85 c0                	test   %eax,%eax
801071fb:	79 0d                	jns    8010720a <create+0x1bf>
    panic("create: dirlink");
801071fd:	83 ec 0c             	sub    $0xc,%esp
80107200:	68 09 a1 10 80       	push   $0x8010a109
80107205:	e8 5c 93 ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010720a:	83 ec 0c             	sub    $0xc,%esp
8010720d:	ff 75 f4             	pushl  -0xc(%ebp)
80107210:	e8 bb aa ff ff       	call   80101cd0 <iunlockput>
80107215:	83 c4 10             	add    $0x10,%esp

  return ip;
80107218:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010721b:	c9                   	leave  
8010721c:	c3                   	ret    

8010721d <sys_open>:

int
sys_open(void)
{
8010721d:	55                   	push   %ebp
8010721e:	89 e5                	mov    %esp,%ebp
80107220:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107223:	83 ec 08             	sub    $0x8,%esp
80107226:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107229:	50                   	push   %eax
8010722a:	6a 00                	push   $0x0
8010722c:	e8 eb f6 ff ff       	call   8010691c <argstr>
80107231:	83 c4 10             	add    $0x10,%esp
80107234:	85 c0                	test   %eax,%eax
80107236:	78 15                	js     8010724d <sys_open+0x30>
80107238:	83 ec 08             	sub    $0x8,%esp
8010723b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010723e:	50                   	push   %eax
8010723f:	6a 01                	push   $0x1
80107241:	e8 51 f6 ff ff       	call   80106897 <argint>
80107246:	83 c4 10             	add    $0x10,%esp
80107249:	85 c0                	test   %eax,%eax
8010724b:	79 0a                	jns    80107257 <sys_open+0x3a>
    return -1;
8010724d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107252:	e9 61 01 00 00       	jmp    801073b8 <sys_open+0x19b>

  begin_op();
80107257:	e8 97 c3 ff ff       	call   801035f3 <begin_op>

  if(omode & O_CREATE){
8010725c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010725f:	25 00 02 00 00       	and    $0x200,%eax
80107264:	85 c0                	test   %eax,%eax
80107266:	74 2a                	je     80107292 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80107268:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010726b:	6a 00                	push   $0x0
8010726d:	6a 00                	push   $0x0
8010726f:	6a 02                	push   $0x2
80107271:	50                   	push   %eax
80107272:	e8 d4 fd ff ff       	call   8010704b <create>
80107277:	83 c4 10             	add    $0x10,%esp
8010727a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010727d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107281:	75 75                	jne    801072f8 <sys_open+0xdb>
      end_op();
80107283:	e8 f7 c3 ff ff       	call   8010367f <end_op>
      return -1;
80107288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010728d:	e9 26 01 00 00       	jmp    801073b8 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80107292:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107295:	83 ec 0c             	sub    $0xc,%esp
80107298:	50                   	push   %eax
80107299:	e8 30 b3 ff ff       	call   801025ce <namei>
8010729e:	83 c4 10             	add    $0x10,%esp
801072a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801072a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072a8:	75 0f                	jne    801072b9 <sys_open+0x9c>
      end_op();
801072aa:	e8 d0 c3 ff ff       	call   8010367f <end_op>
      return -1;
801072af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072b4:	e9 ff 00 00 00       	jmp    801073b8 <sys_open+0x19b>
    }
    ilock(ip);
801072b9:	83 ec 0c             	sub    $0xc,%esp
801072bc:	ff 75 f4             	pushl  -0xc(%ebp)
801072bf:	e8 4c a7 ff ff       	call   80101a10 <ilock>
801072c4:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801072c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ca:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801072ce:	66 83 f8 01          	cmp    $0x1,%ax
801072d2:	75 24                	jne    801072f8 <sys_open+0xdb>
801072d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072d7:	85 c0                	test   %eax,%eax
801072d9:	74 1d                	je     801072f8 <sys_open+0xdb>
      iunlockput(ip);
801072db:	83 ec 0c             	sub    $0xc,%esp
801072de:	ff 75 f4             	pushl  -0xc(%ebp)
801072e1:	e8 ea a9 ff ff       	call   80101cd0 <iunlockput>
801072e6:	83 c4 10             	add    $0x10,%esp
      end_op();
801072e9:	e8 91 c3 ff ff       	call   8010367f <end_op>
      return -1;
801072ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072f3:	e9 c0 00 00 00       	jmp    801073b8 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801072f8:	e8 3c 9d ff ff       	call   80101039 <filealloc>
801072fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107300:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107304:	74 17                	je     8010731d <sys_open+0x100>
80107306:	83 ec 0c             	sub    $0xc,%esp
80107309:	ff 75 f0             	pushl  -0x10(%ebp)
8010730c:	e8 37 f7 ff ff       	call   80106a48 <fdalloc>
80107311:	83 c4 10             	add    $0x10,%esp
80107314:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107317:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010731b:	79 2e                	jns    8010734b <sys_open+0x12e>
    if(f)
8010731d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107321:	74 0e                	je     80107331 <sys_open+0x114>
      fileclose(f);
80107323:	83 ec 0c             	sub    $0xc,%esp
80107326:	ff 75 f0             	pushl  -0x10(%ebp)
80107329:	e8 c9 9d ff ff       	call   801010f7 <fileclose>
8010732e:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107331:	83 ec 0c             	sub    $0xc,%esp
80107334:	ff 75 f4             	pushl  -0xc(%ebp)
80107337:	e8 94 a9 ff ff       	call   80101cd0 <iunlockput>
8010733c:	83 c4 10             	add    $0x10,%esp
    end_op();
8010733f:	e8 3b c3 ff ff       	call   8010367f <end_op>
    return -1;
80107344:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107349:	eb 6d                	jmp    801073b8 <sys_open+0x19b>
  }
  iunlock(ip);
8010734b:	83 ec 0c             	sub    $0xc,%esp
8010734e:	ff 75 f4             	pushl  -0xc(%ebp)
80107351:	e8 18 a8 ff ff       	call   80101b6e <iunlock>
80107356:	83 c4 10             	add    $0x10,%esp
  end_op();
80107359:	e8 21 c3 ff ff       	call   8010367f <end_op>

  f->type = FD_INODE;
8010735e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107361:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80107367:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010736a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010736d:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107370:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107373:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010737a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010737d:	83 e0 01             	and    $0x1,%eax
80107380:	85 c0                	test   %eax,%eax
80107382:	0f 94 c0             	sete   %al
80107385:	89 c2                	mov    %eax,%edx
80107387:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010738a:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010738d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107390:	83 e0 01             	and    $0x1,%eax
80107393:	85 c0                	test   %eax,%eax
80107395:	75 0a                	jne    801073a1 <sys_open+0x184>
80107397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010739a:	83 e0 02             	and    $0x2,%eax
8010739d:	85 c0                	test   %eax,%eax
8010739f:	74 07                	je     801073a8 <sys_open+0x18b>
801073a1:	b8 01 00 00 00       	mov    $0x1,%eax
801073a6:	eb 05                	jmp    801073ad <sys_open+0x190>
801073a8:	b8 00 00 00 00       	mov    $0x0,%eax
801073ad:	89 c2                	mov    %eax,%edx
801073af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073b2:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801073b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801073b8:	c9                   	leave  
801073b9:	c3                   	ret    

801073ba <sys_mkdir>:

int
sys_mkdir(void)
{
801073ba:	55                   	push   %ebp
801073bb:	89 e5                	mov    %esp,%ebp
801073bd:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801073c0:	e8 2e c2 ff ff       	call   801035f3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801073c5:	83 ec 08             	sub    $0x8,%esp
801073c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801073cb:	50                   	push   %eax
801073cc:	6a 00                	push   $0x0
801073ce:	e8 49 f5 ff ff       	call   8010691c <argstr>
801073d3:	83 c4 10             	add    $0x10,%esp
801073d6:	85 c0                	test   %eax,%eax
801073d8:	78 1b                	js     801073f5 <sys_mkdir+0x3b>
801073da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073dd:	6a 00                	push   $0x0
801073df:	6a 00                	push   $0x0
801073e1:	6a 01                	push   $0x1
801073e3:	50                   	push   %eax
801073e4:	e8 62 fc ff ff       	call   8010704b <create>
801073e9:	83 c4 10             	add    $0x10,%esp
801073ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073f3:	75 0c                	jne    80107401 <sys_mkdir+0x47>
    end_op();
801073f5:	e8 85 c2 ff ff       	call   8010367f <end_op>
    return -1;
801073fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073ff:	eb 18                	jmp    80107419 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107401:	83 ec 0c             	sub    $0xc,%esp
80107404:	ff 75 f4             	pushl  -0xc(%ebp)
80107407:	e8 c4 a8 ff ff       	call   80101cd0 <iunlockput>
8010740c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010740f:	e8 6b c2 ff ff       	call   8010367f <end_op>
  return 0;
80107414:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107419:	c9                   	leave  
8010741a:	c3                   	ret    

8010741b <sys_mknod>:

int
sys_mknod(void)
{
8010741b:	55                   	push   %ebp
8010741c:	89 e5                	mov    %esp,%ebp
8010741e:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107421:	e8 cd c1 ff ff       	call   801035f3 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107426:	83 ec 08             	sub    $0x8,%esp
80107429:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010742c:	50                   	push   %eax
8010742d:	6a 00                	push   $0x0
8010742f:	e8 e8 f4 ff ff       	call   8010691c <argstr>
80107434:	83 c4 10             	add    $0x10,%esp
80107437:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010743a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010743e:	78 4f                	js     8010748f <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107440:	83 ec 08             	sub    $0x8,%esp
80107443:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107446:	50                   	push   %eax
80107447:	6a 01                	push   $0x1
80107449:	e8 49 f4 ff ff       	call   80106897 <argint>
8010744e:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107451:	85 c0                	test   %eax,%eax
80107453:	78 3a                	js     8010748f <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107455:	83 ec 08             	sub    $0x8,%esp
80107458:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010745b:	50                   	push   %eax
8010745c:	6a 02                	push   $0x2
8010745e:	e8 34 f4 ff ff       	call   80106897 <argint>
80107463:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107466:	85 c0                	test   %eax,%eax
80107468:	78 25                	js     8010748f <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010746a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010746d:	0f bf c8             	movswl %ax,%ecx
80107470:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107473:	0f bf d0             	movswl %ax,%edx
80107476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107479:	51                   	push   %ecx
8010747a:	52                   	push   %edx
8010747b:	6a 03                	push   $0x3
8010747d:	50                   	push   %eax
8010747e:	e8 c8 fb ff ff       	call   8010704b <create>
80107483:	83 c4 10             	add    $0x10,%esp
80107486:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010748d:	75 0c                	jne    8010749b <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
8010748f:	e8 eb c1 ff ff       	call   8010367f <end_op>
    return -1;
80107494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107499:	eb 18                	jmp    801074b3 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010749b:	83 ec 0c             	sub    $0xc,%esp
8010749e:	ff 75 f0             	pushl  -0x10(%ebp)
801074a1:	e8 2a a8 ff ff       	call   80101cd0 <iunlockput>
801074a6:	83 c4 10             	add    $0x10,%esp
  end_op();
801074a9:	e8 d1 c1 ff ff       	call   8010367f <end_op>
  return 0;
801074ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
801074b3:	c9                   	leave  
801074b4:	c3                   	ret    

801074b5 <sys_chdir>:

int
sys_chdir(void)
{
801074b5:	55                   	push   %ebp
801074b6:	89 e5                	mov    %esp,%ebp
801074b8:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801074bb:	e8 33 c1 ff ff       	call   801035f3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801074c0:	83 ec 08             	sub    $0x8,%esp
801074c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801074c6:	50                   	push   %eax
801074c7:	6a 00                	push   $0x0
801074c9:	e8 4e f4 ff ff       	call   8010691c <argstr>
801074ce:	83 c4 10             	add    $0x10,%esp
801074d1:	85 c0                	test   %eax,%eax
801074d3:	78 18                	js     801074ed <sys_chdir+0x38>
801074d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074d8:	83 ec 0c             	sub    $0xc,%esp
801074db:	50                   	push   %eax
801074dc:	e8 ed b0 ff ff       	call   801025ce <namei>
801074e1:	83 c4 10             	add    $0x10,%esp
801074e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801074eb:	75 0c                	jne    801074f9 <sys_chdir+0x44>
    end_op();
801074ed:	e8 8d c1 ff ff       	call   8010367f <end_op>
    return -1;
801074f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074f7:	eb 6e                	jmp    80107567 <sys_chdir+0xb2>
  }
  ilock(ip);
801074f9:	83 ec 0c             	sub    $0xc,%esp
801074fc:	ff 75 f4             	pushl  -0xc(%ebp)
801074ff:	e8 0c a5 ff ff       	call   80101a10 <ilock>
80107504:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010750e:	66 83 f8 01          	cmp    $0x1,%ax
80107512:	74 1a                	je     8010752e <sys_chdir+0x79>
    iunlockput(ip);
80107514:	83 ec 0c             	sub    $0xc,%esp
80107517:	ff 75 f4             	pushl  -0xc(%ebp)
8010751a:	e8 b1 a7 ff ff       	call   80101cd0 <iunlockput>
8010751f:	83 c4 10             	add    $0x10,%esp
    end_op();
80107522:	e8 58 c1 ff ff       	call   8010367f <end_op>
    return -1;
80107527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010752c:	eb 39                	jmp    80107567 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010752e:	83 ec 0c             	sub    $0xc,%esp
80107531:	ff 75 f4             	pushl  -0xc(%ebp)
80107534:	e8 35 a6 ff ff       	call   80101b6e <iunlock>
80107539:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010753c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107542:	8b 40 68             	mov    0x68(%eax),%eax
80107545:	83 ec 0c             	sub    $0xc,%esp
80107548:	50                   	push   %eax
80107549:	e8 92 a6 ff ff       	call   80101be0 <iput>
8010754e:	83 c4 10             	add    $0x10,%esp
  end_op();
80107551:	e8 29 c1 ff ff       	call   8010367f <end_op>
  proc->cwd = ip;
80107556:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010755c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010755f:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107562:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107567:	c9                   	leave  
80107568:	c3                   	ret    

80107569 <sys_exec>:

int
sys_exec(void)
{
80107569:	55                   	push   %ebp
8010756a:	89 e5                	mov    %esp,%ebp
8010756c:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107572:	83 ec 08             	sub    $0x8,%esp
80107575:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107578:	50                   	push   %eax
80107579:	6a 00                	push   $0x0
8010757b:	e8 9c f3 ff ff       	call   8010691c <argstr>
80107580:	83 c4 10             	add    $0x10,%esp
80107583:	85 c0                	test   %eax,%eax
80107585:	78 18                	js     8010759f <sys_exec+0x36>
80107587:	83 ec 08             	sub    $0x8,%esp
8010758a:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107590:	50                   	push   %eax
80107591:	6a 01                	push   $0x1
80107593:	e8 ff f2 ff ff       	call   80106897 <argint>
80107598:	83 c4 10             	add    $0x10,%esp
8010759b:	85 c0                	test   %eax,%eax
8010759d:	79 0a                	jns    801075a9 <sys_exec+0x40>
    return -1;
8010759f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075a4:	e9 c6 00 00 00       	jmp    8010766f <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801075a9:	83 ec 04             	sub    $0x4,%esp
801075ac:	68 80 00 00 00       	push   $0x80
801075b1:	6a 00                	push   $0x0
801075b3:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801075b9:	50                   	push   %eax
801075ba:	e8 b3 ef ff ff       	call   80106572 <memset>
801075bf:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801075c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801075c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075cc:	83 f8 1f             	cmp    $0x1f,%eax
801075cf:	76 0a                	jbe    801075db <sys_exec+0x72>
      return -1;
801075d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075d6:	e9 94 00 00 00       	jmp    8010766f <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801075db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075de:	c1 e0 02             	shl    $0x2,%eax
801075e1:	89 c2                	mov    %eax,%edx
801075e3:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801075e9:	01 c2                	add    %eax,%edx
801075eb:	83 ec 08             	sub    $0x8,%esp
801075ee:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801075f4:	50                   	push   %eax
801075f5:	52                   	push   %edx
801075f6:	e8 00 f2 ff ff       	call   801067fb <fetchint>
801075fb:	83 c4 10             	add    $0x10,%esp
801075fe:	85 c0                	test   %eax,%eax
80107600:	79 07                	jns    80107609 <sys_exec+0xa0>
      return -1;
80107602:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107607:	eb 66                	jmp    8010766f <sys_exec+0x106>
    if(uarg == 0){
80107609:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010760f:	85 c0                	test   %eax,%eax
80107611:	75 27                	jne    8010763a <sys_exec+0xd1>
      argv[i] = 0;
80107613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107616:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010761d:	00 00 00 00 
      break;
80107621:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107622:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107625:	83 ec 08             	sub    $0x8,%esp
80107628:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010762e:	52                   	push   %edx
8010762f:	50                   	push   %eax
80107630:	e8 e2 95 ff ff       	call   80100c17 <exec>
80107635:	83 c4 10             	add    $0x10,%esp
80107638:	eb 35                	jmp    8010766f <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010763a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107640:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107643:	c1 e2 02             	shl    $0x2,%edx
80107646:	01 c2                	add    %eax,%edx
80107648:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010764e:	83 ec 08             	sub    $0x8,%esp
80107651:	52                   	push   %edx
80107652:	50                   	push   %eax
80107653:	e8 dd f1 ff ff       	call   80106835 <fetchstr>
80107658:	83 c4 10             	add    $0x10,%esp
8010765b:	85 c0                	test   %eax,%eax
8010765d:	79 07                	jns    80107666 <sys_exec+0xfd>
      return -1;
8010765f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107664:	eb 09                	jmp    8010766f <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107666:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010766a:	e9 5a ff ff ff       	jmp    801075c9 <sys_exec+0x60>
  return exec(path, argv);
}
8010766f:	c9                   	leave  
80107670:	c3                   	ret    

80107671 <sys_pipe>:

int
sys_pipe(void)
{
80107671:	55                   	push   %ebp
80107672:	89 e5                	mov    %esp,%ebp
80107674:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107677:	83 ec 04             	sub    $0x4,%esp
8010767a:	6a 08                	push   $0x8
8010767c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010767f:	50                   	push   %eax
80107680:	6a 00                	push   $0x0
80107682:	e8 38 f2 ff ff       	call   801068bf <argptr>
80107687:	83 c4 10             	add    $0x10,%esp
8010768a:	85 c0                	test   %eax,%eax
8010768c:	79 0a                	jns    80107698 <sys_pipe+0x27>
    return -1;
8010768e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107693:	e9 af 00 00 00       	jmp    80107747 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107698:	83 ec 08             	sub    $0x8,%esp
8010769b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010769e:	50                   	push   %eax
8010769f:	8d 45 e8             	lea    -0x18(%ebp),%eax
801076a2:	50                   	push   %eax
801076a3:	e8 3f ca ff ff       	call   801040e7 <pipealloc>
801076a8:	83 c4 10             	add    $0x10,%esp
801076ab:	85 c0                	test   %eax,%eax
801076ad:	79 0a                	jns    801076b9 <sys_pipe+0x48>
    return -1;
801076af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076b4:	e9 8e 00 00 00       	jmp    80107747 <sys_pipe+0xd6>
  fd0 = -1;
801076b9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801076c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801076c3:	83 ec 0c             	sub    $0xc,%esp
801076c6:	50                   	push   %eax
801076c7:	e8 7c f3 ff ff       	call   80106a48 <fdalloc>
801076cc:	83 c4 10             	add    $0x10,%esp
801076cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801076d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801076d6:	78 18                	js     801076f0 <sys_pipe+0x7f>
801076d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076db:	83 ec 0c             	sub    $0xc,%esp
801076de:	50                   	push   %eax
801076df:	e8 64 f3 ff ff       	call   80106a48 <fdalloc>
801076e4:	83 c4 10             	add    $0x10,%esp
801076e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801076ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801076ee:	79 3f                	jns    8010772f <sys_pipe+0xbe>
    if(fd0 >= 0)
801076f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801076f4:	78 14                	js     8010770a <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801076f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801076ff:	83 c2 08             	add    $0x8,%edx
80107702:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107709:	00 
    fileclose(rf);
8010770a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010770d:	83 ec 0c             	sub    $0xc,%esp
80107710:	50                   	push   %eax
80107711:	e8 e1 99 ff ff       	call   801010f7 <fileclose>
80107716:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010771c:	83 ec 0c             	sub    $0xc,%esp
8010771f:	50                   	push   %eax
80107720:	e8 d2 99 ff ff       	call   801010f7 <fileclose>
80107725:	83 c4 10             	add    $0x10,%esp
    return -1;
80107728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010772d:	eb 18                	jmp    80107747 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
8010772f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107732:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107735:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107737:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010773a:	8d 50 04             	lea    0x4(%eax),%edx
8010773d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107740:	89 02                	mov    %eax,(%edx)
  return 0;
80107742:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107747:	c9                   	leave  
80107748:	c3                   	ret    

80107749 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107749:	55                   	push   %ebp
8010774a:	89 e5                	mov    %esp,%ebp
8010774c:	83 ec 08             	sub    $0x8,%esp
8010774f:	8b 55 08             	mov    0x8(%ebp),%edx
80107752:	8b 45 0c             	mov    0xc(%ebp),%eax
80107755:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107759:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010775d:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107761:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107765:	66 ef                	out    %ax,(%dx)
}
80107767:	90                   	nop
80107768:	c9                   	leave  
80107769:	c3                   	ret    

8010776a <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
8010776a:	55                   	push   %ebp
8010776b:	89 e5                	mov    %esp,%ebp
8010776d:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107770:	e8 33 d2 ff ff       	call   801049a8 <fork>
}
80107775:	c9                   	leave  
80107776:	c3                   	ret    

80107777 <sys_exit>:

int
sys_exit(void)
{
80107777:	55                   	push   %ebp
80107778:	89 e5                	mov    %esp,%ebp
8010777a:	83 ec 08             	sub    $0x8,%esp
  exit();
8010777d:	e8 55 d4 ff ff       	call   80104bd7 <exit>
  return 0;  // not reached
80107782:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107787:	c9                   	leave  
80107788:	c3                   	ret    

80107789 <sys_wait>:

int
sys_wait(void)
{
80107789:	55                   	push   %ebp
8010778a:	89 e5                	mov    %esp,%ebp
8010778c:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010778f:	e8 0d d7 ff ff       	call   80104ea1 <wait>
}
80107794:	c9                   	leave  
80107795:	c3                   	ret    

80107796 <sys_kill>:

int
sys_kill(void)
{
80107796:	55                   	push   %ebp
80107797:	89 e5                	mov    %esp,%ebp
80107799:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010779c:	83 ec 08             	sub    $0x8,%esp
8010779f:	8d 45 f4             	lea    -0xc(%ebp),%eax
801077a2:	50                   	push   %eax
801077a3:	6a 00                	push   $0x0
801077a5:	e8 ed f0 ff ff       	call   80106897 <argint>
801077aa:	83 c4 10             	add    $0x10,%esp
801077ad:	85 c0                	test   %eax,%eax
801077af:	79 07                	jns    801077b8 <sys_kill+0x22>
    return -1;
801077b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077b6:	eb 0f                	jmp    801077c7 <sys_kill+0x31>
  return kill(pid);
801077b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bb:	83 ec 0c             	sub    $0xc,%esp
801077be:	50                   	push   %eax
801077bf:	e8 9a dd ff ff       	call   8010555e <kill>
801077c4:	83 c4 10             	add    $0x10,%esp
}
801077c7:	c9                   	leave  
801077c8:	c3                   	ret    

801077c9 <sys_getpid>:

int
sys_getpid(void)
{
801077c9:	55                   	push   %ebp
801077ca:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801077cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077d2:	8b 40 10             	mov    0x10(%eax),%eax
}
801077d5:	5d                   	pop    %ebp
801077d6:	c3                   	ret    

801077d7 <sys_sbrk>:

int
sys_sbrk(void)
{
801077d7:	55                   	push   %ebp
801077d8:	89 e5                	mov    %esp,%ebp
801077da:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801077dd:	83 ec 08             	sub    $0x8,%esp
801077e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801077e3:	50                   	push   %eax
801077e4:	6a 00                	push   $0x0
801077e6:	e8 ac f0 ff ff       	call   80106897 <argint>
801077eb:	83 c4 10             	add    $0x10,%esp
801077ee:	85 c0                	test   %eax,%eax
801077f0:	79 07                	jns    801077f9 <sys_sbrk+0x22>
    return -1;
801077f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077f7:	eb 28                	jmp    80107821 <sys_sbrk+0x4a>
  addr = proc->sz;
801077f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077ff:	8b 00                	mov    (%eax),%eax
80107801:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107804:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107807:	83 ec 0c             	sub    $0xc,%esp
8010780a:	50                   	push   %eax
8010780b:	e8 f5 d0 ff ff       	call   80104905 <growproc>
80107810:	83 c4 10             	add    $0x10,%esp
80107813:	85 c0                	test   %eax,%eax
80107815:	79 07                	jns    8010781e <sys_sbrk+0x47>
    return -1;
80107817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010781c:	eb 03                	jmp    80107821 <sys_sbrk+0x4a>
  return addr;
8010781e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107821:	c9                   	leave  
80107822:	c3                   	ret    

80107823 <sys_sleep>:

int
sys_sleep(void)
{
80107823:	55                   	push   %ebp
80107824:	89 e5                	mov    %esp,%ebp
80107826:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107829:	83 ec 08             	sub    $0x8,%esp
8010782c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010782f:	50                   	push   %eax
80107830:	6a 00                	push   $0x0
80107832:	e8 60 f0 ff ff       	call   80106897 <argint>
80107837:	83 c4 10             	add    $0x10,%esp
8010783a:	85 c0                	test   %eax,%eax
8010783c:	79 07                	jns    80107845 <sys_sleep+0x22>
    return -1;
8010783e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107843:	eb 44                	jmp    80107889 <sys_sleep+0x66>
  ticks0 = ticks;
80107845:	a1 e0 78 11 80       	mov    0x801178e0,%eax
8010784a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010784d:	eb 26                	jmp    80107875 <sys_sleep+0x52>
    if(proc->killed){
8010784f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107855:	8b 40 24             	mov    0x24(%eax),%eax
80107858:	85 c0                	test   %eax,%eax
8010785a:	74 07                	je     80107863 <sys_sleep+0x40>
      return -1;
8010785c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107861:	eb 26                	jmp    80107889 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107863:	83 ec 08             	sub    $0x8,%esp
80107866:	6a 00                	push   $0x0
80107868:	68 e0 78 11 80       	push   $0x801178e0
8010786d:	e8 5a db ff ff       	call   801053cc <sleep>
80107872:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107875:	a1 e0 78 11 80       	mov    0x801178e0,%eax
8010787a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010787d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107880:	39 d0                	cmp    %edx,%eax
80107882:	72 cb                	jb     8010784f <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107884:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107889:	c9                   	leave  
8010788a:	c3                   	ret    

8010788b <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
8010788b:	55                   	push   %ebp
8010788c:	89 e5                	mov    %esp,%ebp
8010788e:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107891:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80107896:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107899:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010789c:	c9                   	leave  
8010789d:	c3                   	ret    

8010789e <sys_halt>:

//Turn of the computer
int sys_halt(void){
8010789e:	55                   	push   %ebp
8010789f:	89 e5                	mov    %esp,%ebp
801078a1:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
801078a4:	83 ec 0c             	sub    $0xc,%esp
801078a7:	68 19 a1 10 80       	push   $0x8010a119
801078ac:	e8 15 8b ff ff       	call   801003c6 <cprintf>
801078b1:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
801078b4:	83 ec 08             	sub    $0x8,%esp
801078b7:	68 00 20 00 00       	push   $0x2000
801078bc:	68 04 06 00 00       	push   $0x604
801078c1:	e8 83 fe ff ff       	call   80107749 <outw>
801078c6:	83 c4 10             	add    $0x10,%esp
  return 0;
801078c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801078ce:	c9                   	leave  
801078cf:	c3                   	ret    

801078d0 <sys_date>:

// returns the rtcdate
int
sys_date(void) // Added for Project 1: The date() System Call
{
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if(argptr(0, (void*)&d, sizeof(*d)) < 0)
801078d6:	83 ec 04             	sub    $0x4,%esp
801078d9:	6a 18                	push   $0x18
801078db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801078de:	50                   	push   %eax
801078df:	6a 00                	push   $0x0
801078e1:	e8 d9 ef ff ff       	call   801068bf <argptr>
801078e6:	83 c4 10             	add    $0x10,%esp
801078e9:	85 c0                	test   %eax,%eax
801078eb:	79 07                	jns    801078f4 <sys_date+0x24>
    return -1;
801078ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078f2:	eb 14                	jmp    80107908 <sys_date+0x38>

  cmostime(d);
801078f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f7:	83 ec 0c             	sub    $0xc,%esp
801078fa:	50                   	push   %eax
801078fb:	e8 6e b9 ff ff       	call   8010326e <cmostime>
80107900:	83 c4 10             	add    $0x10,%esp
  return 0;
80107903:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107908:	c9                   	leave  
80107909:	c3                   	ret    

8010790a <sys_getuid>:

// START: Added for Project 2: UIDs and GIDs and PPIDs
// get uid of current process
int
sys_getuid(void)
{
8010790a:	55                   	push   %ebp
8010790b:	89 e5                	mov    %esp,%ebp
  return proc->uid;
8010790d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107913:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107919:	5d                   	pop    %ebp
8010791a:	c3                   	ret    

8010791b <sys_getgid>:

// get gid of current process
int
sys_getgid(void)
{
8010791b:	55                   	push   %ebp
8010791c:	89 e5                	mov    %esp,%ebp
  return proc->gid;
8010791e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107924:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
8010792a:	5d                   	pop    %ebp
8010792b:	c3                   	ret    

8010792c <sys_getppid>:

// get pid of parent process (init is its own parent)
int
sys_getppid(void)
{
8010792c:	55                   	push   %ebp
8010792d:	89 e5                	mov    %esp,%ebp
  if (proc->pid == 1)
8010792f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107935:	8b 40 10             	mov    0x10(%eax),%eax
80107938:	83 f8 01             	cmp    $0x1,%eax
8010793b:	75 07                	jne    80107944 <sys_getppid+0x18>
    return 1;
8010793d:	b8 01 00 00 00       	mov    $0x1,%eax
80107942:	eb 0c                	jmp    80107950 <sys_getppid+0x24>
  else
    return proc->parent->pid;
80107944:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010794a:	8b 40 14             	mov    0x14(%eax),%eax
8010794d:	8b 40 10             	mov    0x10(%eax),%eax
}
80107950:	5d                   	pop    %ebp
80107951:	c3                   	ret    

80107952 <sys_setuid>:

// set uid
int
sys_setuid(void)
{
80107952:	55                   	push   %ebp
80107953:	89 e5                	mov    %esp,%ebp
80107955:	83 ec 18             	sub    $0x18,%esp
  int uid;

  if (argint(0, &uid) < 0)
80107958:	83 ec 08             	sub    $0x8,%esp
8010795b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010795e:	50                   	push   %eax
8010795f:	6a 00                	push   $0x0
80107961:	e8 31 ef ff ff       	call   80106897 <argint>
80107966:	83 c4 10             	add    $0x10,%esp
80107969:	85 c0                	test   %eax,%eax
8010796b:	79 07                	jns    80107974 <sys_setuid+0x22>
    return -1;
8010796d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107972:	eb 2c                	jmp    801079a0 <sys_setuid+0x4e>
  
  if (0 <= uid && uid <= 32767){
80107974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107977:	85 c0                	test   %eax,%eax
80107979:	78 20                	js     8010799b <sys_setuid+0x49>
8010797b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797e:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107983:	7f 16                	jg     8010799b <sys_setuid+0x49>
    proc->uid = uid;
80107985:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010798b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010798e:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    return 0;
80107994:	b8 00 00 00 00       	mov    $0x0,%eax
80107999:	eb 05                	jmp    801079a0 <sys_setuid+0x4e>
  }
  else
    return -1;
8010799b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
801079a0:	c9                   	leave  
801079a1:	c3                   	ret    

801079a2 <sys_setgid>:

// set gid
int
sys_setgid(void)
{
801079a2:	55                   	push   %ebp
801079a3:	89 e5                	mov    %esp,%ebp
801079a5:	83 ec 18             	sub    $0x18,%esp
  int gid;

  if (argint(0, &gid) < 0)
801079a8:	83 ec 08             	sub    $0x8,%esp
801079ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801079ae:	50                   	push   %eax
801079af:	6a 00                	push   $0x0
801079b1:	e8 e1 ee ff ff       	call   80106897 <argint>
801079b6:	83 c4 10             	add    $0x10,%esp
801079b9:	85 c0                	test   %eax,%eax
801079bb:	79 07                	jns    801079c4 <sys_setgid+0x22>
    return -1;
801079bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079c2:	eb 2c                	jmp    801079f0 <sys_setgid+0x4e>

  if (0 <= gid && gid <= 32767){
801079c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c7:	85 c0                	test   %eax,%eax
801079c9:	78 20                	js     801079eb <sys_setgid+0x49>
801079cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ce:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801079d3:	7f 16                	jg     801079eb <sys_setgid+0x49>
    proc->gid = gid;
801079d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801079db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801079de:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    return 0;
801079e4:	b8 00 00 00 00       	mov    $0x0,%eax
801079e9:	eb 05                	jmp    801079f0 <sys_setgid+0x4e>
  }
  else
    return -1;
801079eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079f0:	c9                   	leave  
801079f1:	c3                   	ret    

801079f2 <sys_getprocs>:
// END: Added for Project 2: UIDs and GIDs and PPIDs

// get list of procs (for ps display)
int
sys_getprocs(void) // Added for Project 2: The "ps" Command
{
801079f2:	55                   	push   %ebp
801079f3:	89 e5                	mov    %esp,%ebp
801079f5:	83 ec 18             	sub    $0x18,%esp
  int max;
  struct uproc *table;

  if (argint(0, &max) < 0)
801079f8:	83 ec 08             	sub    $0x8,%esp
801079fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801079fe:	50                   	push   %eax
801079ff:	6a 00                	push   $0x0
80107a01:	e8 91 ee ff ff       	call   80106897 <argint>
80107a06:	83 c4 10             	add    $0x10,%esp
80107a09:	85 c0                	test   %eax,%eax
80107a0b:	79 07                	jns    80107a14 <sys_getprocs+0x22>
    return -1;
80107a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a12:	eb 31                	jmp    80107a45 <sys_getprocs+0x53>

  if (argptr(1, (void*)&table, sizeof(*table)) < 0)
80107a14:	83 ec 04             	sub    $0x4,%esp
80107a17:	6a 60                	push   $0x60
80107a19:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a1c:	50                   	push   %eax
80107a1d:	6a 01                	push   $0x1
80107a1f:	e8 9b ee ff ff       	call   801068bf <argptr>
80107a24:	83 c4 10             	add    $0x10,%esp
80107a27:	85 c0                	test   %eax,%eax
80107a29:	79 07                	jns    80107a32 <sys_getprocs+0x40>
    return -1;
80107a2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a30:	eb 13                	jmp    80107a45 <sys_getprocs+0x53>

  return getuprocs(max, table); // get uproc struct array from proc.c
80107a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a38:	83 ec 08             	sub    $0x8,%esp
80107a3b:	50                   	push   %eax
80107a3c:	52                   	push   %edx
80107a3d:	e8 f1 e0 ff ff       	call   80105b33 <getuprocs>
80107a42:	83 c4 10             	add    $0x10,%esp
}
80107a45:	c9                   	leave  
80107a46:	c3                   	ret    

80107a47 <sys_setpriority>:

// sets proc with PID of pid to priority and resets budget
// returns 0 on success and -1 on error
int
sys_setpriority(void) // Added for Project 4: The setpriority() System Call
{
80107a47:	55                   	push   %ebp
80107a48:	89 e5                	mov    %esp,%ebp
80107a4a:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int priority;

  // get pid/ priority parameters off stack (return -1 on error)
  if(argint(0, &pid) < 0)
80107a4d:	83 ec 08             	sub    $0x8,%esp
80107a50:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107a53:	50                   	push   %eax
80107a54:	6a 00                	push   $0x0
80107a56:	e8 3c ee ff ff       	call   80106897 <argint>
80107a5b:	83 c4 10             	add    $0x10,%esp
80107a5e:	85 c0                	test   %eax,%eax
80107a60:	79 07                	jns    80107a69 <sys_setpriority+0x22>
    return -1;
80107a62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a67:	eb 4b                	jmp    80107ab4 <sys_setpriority+0x6d>
  if(argint(1, &priority) < 0)
80107a69:	83 ec 08             	sub    $0x8,%esp
80107a6c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a6f:	50                   	push   %eax
80107a70:	6a 01                	push   $0x1
80107a72:	e8 20 ee ff ff       	call   80106897 <argint>
80107a77:	83 c4 10             	add    $0x10,%esp
80107a7a:	85 c0                	test   %eax,%eax
80107a7c:	79 07                	jns    80107a85 <sys_setpriority+0x3e>
    return -1;
80107a7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a83:	eb 2f                	jmp    80107ab4 <sys_setpriority+0x6d>

  // check if parameters have valid values (return -1 on error)
  if (pid < 0 || priority < 0 || priority > MAX)
80107a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a88:	85 c0                	test   %eax,%eax
80107a8a:	78 0e                	js     80107a9a <sys_setpriority+0x53>
80107a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a8f:	85 c0                	test   %eax,%eax
80107a91:	78 07                	js     80107a9a <sys_setpriority+0x53>
80107a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a96:	85 c0                	test   %eax,%eax
80107a98:	7e 07                	jle    80107aa1 <sys_setpriority+0x5a>
    return -1;
80107a9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a9f:	eb 13                	jmp    80107ab4 <sys_setpriority+0x6d>

  // call setpriority (and return its return code)
  return setpriority(pid, priority);
80107aa1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa7:	83 ec 08             	sub    $0x8,%esp
80107aaa:	52                   	push   %edx
80107aab:	50                   	push   %eax
80107aac:	e8 6e e5 ff ff       	call   8010601f <setpriority>
80107ab1:	83 c4 10             	add    $0x10,%esp
}
80107ab4:	c9                   	leave  
80107ab5:	c3                   	ret    

80107ab6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107ab6:	55                   	push   %ebp
80107ab7:	89 e5                	mov    %esp,%ebp
80107ab9:	83 ec 08             	sub    $0x8,%esp
80107abc:	8b 55 08             	mov    0x8(%ebp),%edx
80107abf:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ac2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107ac6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107ac9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107acd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107ad1:	ee                   	out    %al,(%dx)
}
80107ad2:	90                   	nop
80107ad3:	c9                   	leave  
80107ad4:	c3                   	ret    

80107ad5 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80107ad5:	55                   	push   %ebp
80107ad6:	89 e5                	mov    %esp,%ebp
80107ad8:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107adb:	6a 34                	push   $0x34
80107add:	6a 43                	push   $0x43
80107adf:	e8 d2 ff ff ff       	call   80107ab6 <outb>
80107ae4:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107ae7:	68 9c 00 00 00       	push   $0x9c
80107aec:	6a 40                	push   $0x40
80107aee:	e8 c3 ff ff ff       	call   80107ab6 <outb>
80107af3:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80107af6:	6a 2e                	push   $0x2e
80107af8:	6a 40                	push   $0x40
80107afa:	e8 b7 ff ff ff       	call   80107ab6 <outb>
80107aff:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80107b02:	83 ec 0c             	sub    $0xc,%esp
80107b05:	6a 00                	push   $0x0
80107b07:	e8 c5 c4 ff ff       	call   80103fd1 <picenable>
80107b0c:	83 c4 10             	add    $0x10,%esp
}
80107b0f:	90                   	nop
80107b10:	c9                   	leave  
80107b11:	c3                   	ret    

80107b12 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107b12:	1e                   	push   %ds
  pushl %es
80107b13:	06                   	push   %es
  pushl %fs
80107b14:	0f a0                	push   %fs
  pushl %gs
80107b16:	0f a8                	push   %gs
  pushal
80107b18:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107b19:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107b1d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107b1f:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107b21:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107b25:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107b27:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107b29:	54                   	push   %esp
  call trap
80107b2a:	e8 ce 01 00 00       	call   80107cfd <trap>
  addl $4, %esp
80107b2f:	83 c4 04             	add    $0x4,%esp

80107b32 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107b32:	61                   	popa   
  popl %gs
80107b33:	0f a9                	pop    %gs
  popl %fs
80107b35:	0f a1                	pop    %fs
  popl %es
80107b37:	07                   	pop    %es
  popl %ds
80107b38:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107b39:	83 c4 08             	add    $0x8,%esp
  iret
80107b3c:	cf                   	iret   

80107b3d <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80107b3d:	55                   	push   %ebp
80107b3e:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80107b40:	8b 45 08             	mov    0x8(%ebp),%eax
80107b43:	f0 ff 00             	lock incl (%eax)
}
80107b46:	90                   	nop
80107b47:	5d                   	pop    %ebp
80107b48:	c3                   	ret    

80107b49 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107b49:	55                   	push   %ebp
80107b4a:	89 e5                	mov    %esp,%ebp
80107b4c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b52:	83 e8 01             	sub    $0x1,%eax
80107b55:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107b59:	8b 45 08             	mov    0x8(%ebp),%eax
80107b5c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107b60:	8b 45 08             	mov    0x8(%ebp),%eax
80107b63:	c1 e8 10             	shr    $0x10,%eax
80107b66:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107b6a:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107b6d:	0f 01 18             	lidtl  (%eax)
}
80107b70:	90                   	nop
80107b71:	c9                   	leave  
80107b72:	c3                   	ret    

80107b73 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80107b73:	55                   	push   %ebp
80107b74:	89 e5                	mov    %esp,%ebp
80107b76:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107b79:	0f 20 d0             	mov    %cr2,%eax
80107b7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107b82:	c9                   	leave  
80107b83:	c3                   	ret    

80107b84 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80107b84:	55                   	push   %ebp
80107b85:	89 e5                	mov    %esp,%ebp
80107b87:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107b8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107b91:	e9 c3 00 00 00       	jmp    80107c59 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b99:	8b 04 85 b4 d0 10 80 	mov    -0x7fef2f4c(,%eax,4),%eax
80107ba0:	89 c2                	mov    %eax,%edx
80107ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ba5:	66 89 14 c5 e0 70 11 	mov    %dx,-0x7fee8f20(,%eax,8)
80107bac:	80 
80107bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bb0:	66 c7 04 c5 e2 70 11 	movw   $0x8,-0x7fee8f1e(,%eax,8)
80107bb7:	80 08 00 
80107bba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bbd:	0f b6 14 c5 e4 70 11 	movzbl -0x7fee8f1c(,%eax,8),%edx
80107bc4:	80 
80107bc5:	83 e2 e0             	and    $0xffffffe0,%edx
80107bc8:	88 14 c5 e4 70 11 80 	mov    %dl,-0x7fee8f1c(,%eax,8)
80107bcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bd2:	0f b6 14 c5 e4 70 11 	movzbl -0x7fee8f1c(,%eax,8),%edx
80107bd9:	80 
80107bda:	83 e2 1f             	and    $0x1f,%edx
80107bdd:	88 14 c5 e4 70 11 80 	mov    %dl,-0x7fee8f1c(,%eax,8)
80107be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107be7:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80107bee:	80 
80107bef:	83 e2 f0             	and    $0xfffffff0,%edx
80107bf2:	83 ca 0e             	or     $0xe,%edx
80107bf5:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80107bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bff:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80107c06:	80 
80107c07:	83 e2 ef             	and    $0xffffffef,%edx
80107c0a:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80107c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c14:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80107c1b:	80 
80107c1c:	83 e2 9f             	and    $0xffffff9f,%edx
80107c1f:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80107c26:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c29:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80107c30:	80 
80107c31:	83 ca 80             	or     $0xffffff80,%edx
80107c34:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80107c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c3e:	8b 04 85 b4 d0 10 80 	mov    -0x7fef2f4c(,%eax,4),%eax
80107c45:	c1 e8 10             	shr    $0x10,%eax
80107c48:	89 c2                	mov    %eax,%edx
80107c4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c4d:	66 89 14 c5 e6 70 11 	mov    %dx,-0x7fee8f1a(,%eax,8)
80107c54:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107c55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107c59:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107c60:	0f 8e 30 ff ff ff    	jle    80107b96 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107c66:	a1 b4 d1 10 80       	mov    0x8010d1b4,%eax
80107c6b:	66 a3 e0 72 11 80    	mov    %ax,0x801172e0
80107c71:	66 c7 05 e2 72 11 80 	movw   $0x8,0x801172e2
80107c78:	08 00 
80107c7a:	0f b6 05 e4 72 11 80 	movzbl 0x801172e4,%eax
80107c81:	83 e0 e0             	and    $0xffffffe0,%eax
80107c84:	a2 e4 72 11 80       	mov    %al,0x801172e4
80107c89:	0f b6 05 e4 72 11 80 	movzbl 0x801172e4,%eax
80107c90:	83 e0 1f             	and    $0x1f,%eax
80107c93:	a2 e4 72 11 80       	mov    %al,0x801172e4
80107c98:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107c9f:	83 c8 0f             	or     $0xf,%eax
80107ca2:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107ca7:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107cae:	83 e0 ef             	and    $0xffffffef,%eax
80107cb1:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107cb6:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107cbd:	83 c8 60             	or     $0x60,%eax
80107cc0:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107cc5:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107ccc:	83 c8 80             	or     $0xffffff80,%eax
80107ccf:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107cd4:	a1 b4 d1 10 80       	mov    0x8010d1b4,%eax
80107cd9:	c1 e8 10             	shr    $0x10,%eax
80107cdc:	66 a3 e6 72 11 80    	mov    %ax,0x801172e6
  
}
80107ce2:	90                   	nop
80107ce3:	c9                   	leave  
80107ce4:	c3                   	ret    

80107ce5 <idtinit>:

void
idtinit(void)
{
80107ce5:	55                   	push   %ebp
80107ce6:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107ce8:	68 00 08 00 00       	push   $0x800
80107ced:	68 e0 70 11 80       	push   $0x801170e0
80107cf2:	e8 52 fe ff ff       	call   80107b49 <lidt>
80107cf7:	83 c4 08             	add    $0x8,%esp
}
80107cfa:	90                   	nop
80107cfb:	c9                   	leave  
80107cfc:	c3                   	ret    

80107cfd <trap>:

void
trap(struct trapframe *tf)
{
80107cfd:	55                   	push   %ebp
80107cfe:	89 e5                	mov    %esp,%ebp
80107d00:	57                   	push   %edi
80107d01:	56                   	push   %esi
80107d02:	53                   	push   %ebx
80107d03:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107d06:	8b 45 08             	mov    0x8(%ebp),%eax
80107d09:	8b 40 30             	mov    0x30(%eax),%eax
80107d0c:	83 f8 40             	cmp    $0x40,%eax
80107d0f:	75 3e                	jne    80107d4f <trap+0x52>
    if(proc->killed)
80107d11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d17:	8b 40 24             	mov    0x24(%eax),%eax
80107d1a:	85 c0                	test   %eax,%eax
80107d1c:	74 05                	je     80107d23 <trap+0x26>
      exit();
80107d1e:	e8 b4 ce ff ff       	call   80104bd7 <exit>
    proc->tf = tf;
80107d23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d29:	8b 55 08             	mov    0x8(%ebp),%edx
80107d2c:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107d2f:	e8 19 ec ff ff       	call   8010694d <syscall>
    if(proc->killed)
80107d34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d3a:	8b 40 24             	mov    0x24(%eax),%eax
80107d3d:	85 c0                	test   %eax,%eax
80107d3f:	0f 84 fe 01 00 00    	je     80107f43 <trap+0x246>
      exit();
80107d45:	e8 8d ce ff ff       	call   80104bd7 <exit>
    return;
80107d4a:	e9 f4 01 00 00       	jmp    80107f43 <trap+0x246>
  }

  switch(tf->trapno){
80107d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d52:	8b 40 30             	mov    0x30(%eax),%eax
80107d55:	83 e8 20             	sub    $0x20,%eax
80107d58:	83 f8 1f             	cmp    $0x1f,%eax
80107d5b:	0f 87 a3 00 00 00    	ja     80107e04 <trap+0x107>
80107d61:	8b 04 85 cc a1 10 80 	mov    -0x7fef5e34(,%eax,4),%eax
80107d68:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80107d6a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d70:	0f b6 00             	movzbl (%eax),%eax
80107d73:	84 c0                	test   %al,%al
80107d75:	75 20                	jne    80107d97 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107d77:	83 ec 0c             	sub    $0xc,%esp
80107d7a:	68 e0 78 11 80       	push   $0x801178e0
80107d7f:	e8 b9 fd ff ff       	call   80107b3d <atom_inc>
80107d84:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107d87:	83 ec 0c             	sub    $0xc,%esp
80107d8a:	68 e0 78 11 80       	push   $0x801178e0
80107d8f:	e8 93 d7 ff ff       	call   80105527 <wakeup>
80107d94:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107d97:	e8 2f b3 ff ff       	call   801030cb <lapiceoi>
    break;
80107d9c:	e9 1c 01 00 00       	jmp    80107ebd <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107da1:	e8 38 ab ff ff       	call   801028de <ideintr>
    lapiceoi();
80107da6:	e8 20 b3 ff ff       	call   801030cb <lapiceoi>
    break;
80107dab:	e9 0d 01 00 00       	jmp    80107ebd <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107db0:	e8 18 b1 ff ff       	call   80102ecd <kbdintr>
    lapiceoi();
80107db5:	e8 11 b3 ff ff       	call   801030cb <lapiceoi>
    break;
80107dba:	e9 fe 00 00 00       	jmp    80107ebd <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107dbf:	e8 60 03 00 00       	call   80108124 <uartintr>
    lapiceoi();
80107dc4:	e8 02 b3 ff ff       	call   801030cb <lapiceoi>
    break;
80107dc9:	e9 ef 00 00 00       	jmp    80107ebd <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107dce:	8b 45 08             	mov    0x8(%ebp),%eax
80107dd1:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80107dd7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107ddb:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107dde:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107de4:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107de7:	0f b6 c0             	movzbl %al,%eax
80107dea:	51                   	push   %ecx
80107deb:	52                   	push   %edx
80107dec:	50                   	push   %eax
80107ded:	68 2c a1 10 80       	push   $0x8010a12c
80107df2:	e8 cf 85 ff ff       	call   801003c6 <cprintf>
80107df7:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107dfa:	e8 cc b2 ff ff       	call   801030cb <lapiceoi>
    break;
80107dff:	e9 b9 00 00 00       	jmp    80107ebd <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107e04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e0a:	85 c0                	test   %eax,%eax
80107e0c:	74 11                	je     80107e1f <trap+0x122>
80107e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80107e11:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107e15:	0f b7 c0             	movzwl %ax,%eax
80107e18:	83 e0 03             	and    $0x3,%eax
80107e1b:	85 c0                	test   %eax,%eax
80107e1d:	75 40                	jne    80107e5f <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107e1f:	e8 4f fd ff ff       	call   80107b73 <rcr2>
80107e24:	89 c3                	mov    %eax,%ebx
80107e26:	8b 45 08             	mov    0x8(%ebp),%eax
80107e29:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107e2c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e32:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107e35:	0f b6 d0             	movzbl %al,%edx
80107e38:	8b 45 08             	mov    0x8(%ebp),%eax
80107e3b:	8b 40 30             	mov    0x30(%eax),%eax
80107e3e:	83 ec 0c             	sub    $0xc,%esp
80107e41:	53                   	push   %ebx
80107e42:	51                   	push   %ecx
80107e43:	52                   	push   %edx
80107e44:	50                   	push   %eax
80107e45:	68 50 a1 10 80       	push   $0x8010a150
80107e4a:	e8 77 85 ff ff       	call   801003c6 <cprintf>
80107e4f:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107e52:	83 ec 0c             	sub    $0xc,%esp
80107e55:	68 82 a1 10 80       	push   $0x8010a182
80107e5a:	e8 07 87 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e5f:	e8 0f fd ff ff       	call   80107b73 <rcr2>
80107e64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e67:	8b 45 08             	mov    0x8(%ebp),%eax
80107e6a:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107e6d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e73:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e76:	0f b6 d8             	movzbl %al,%ebx
80107e79:	8b 45 08             	mov    0x8(%ebp),%eax
80107e7c:	8b 48 34             	mov    0x34(%eax),%ecx
80107e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80107e82:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107e85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e8b:	8d 78 6c             	lea    0x6c(%eax),%edi
80107e8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e94:	8b 40 10             	mov    0x10(%eax),%eax
80107e97:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e9a:	56                   	push   %esi
80107e9b:	53                   	push   %ebx
80107e9c:	51                   	push   %ecx
80107e9d:	52                   	push   %edx
80107e9e:	57                   	push   %edi
80107e9f:	50                   	push   %eax
80107ea0:	68 88 a1 10 80       	push   $0x8010a188
80107ea5:	e8 1c 85 ff ff       	call   801003c6 <cprintf>
80107eaa:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107eb3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107eba:	eb 01                	jmp    80107ebd <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107ebc:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107ebd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ec3:	85 c0                	test   %eax,%eax
80107ec5:	74 24                	je     80107eeb <trap+0x1ee>
80107ec7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ecd:	8b 40 24             	mov    0x24(%eax),%eax
80107ed0:	85 c0                	test   %eax,%eax
80107ed2:	74 17                	je     80107eeb <trap+0x1ee>
80107ed4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107edb:	0f b7 c0             	movzwl %ax,%eax
80107ede:	83 e0 03             	and    $0x3,%eax
80107ee1:	83 f8 03             	cmp    $0x3,%eax
80107ee4:	75 05                	jne    80107eeb <trap+0x1ee>
    exit();
80107ee6:	e8 ec cc ff ff       	call   80104bd7 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107eeb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ef1:	85 c0                	test   %eax,%eax
80107ef3:	74 1e                	je     80107f13 <trap+0x216>
80107ef5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107efb:	8b 40 0c             	mov    0xc(%eax),%eax
80107efe:	83 f8 04             	cmp    $0x4,%eax
80107f01:	75 10                	jne    80107f13 <trap+0x216>
80107f03:	8b 45 08             	mov    0x8(%ebp),%eax
80107f06:	8b 40 30             	mov    0x30(%eax),%eax
80107f09:	83 f8 20             	cmp    $0x20,%eax
80107f0c:	75 05                	jne    80107f13 <trap+0x216>
    yield();
80107f0e:	e8 06 d4 ff ff       	call   80105319 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107f13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f19:	85 c0                	test   %eax,%eax
80107f1b:	74 27                	je     80107f44 <trap+0x247>
80107f1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f23:	8b 40 24             	mov    0x24(%eax),%eax
80107f26:	85 c0                	test   %eax,%eax
80107f28:	74 1a                	je     80107f44 <trap+0x247>
80107f2a:	8b 45 08             	mov    0x8(%ebp),%eax
80107f2d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107f31:	0f b7 c0             	movzwl %ax,%eax
80107f34:	83 e0 03             	and    $0x3,%eax
80107f37:	83 f8 03             	cmp    $0x3,%eax
80107f3a:	75 08                	jne    80107f44 <trap+0x247>
    exit();
80107f3c:	e8 96 cc ff ff       	call   80104bd7 <exit>
80107f41:	eb 01                	jmp    80107f44 <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107f43:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f47:	5b                   	pop    %ebx
80107f48:	5e                   	pop    %esi
80107f49:	5f                   	pop    %edi
80107f4a:	5d                   	pop    %ebp
80107f4b:	c3                   	ret    

80107f4c <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80107f4c:	55                   	push   %ebp
80107f4d:	89 e5                	mov    %esp,%ebp
80107f4f:	83 ec 14             	sub    $0x14,%esp
80107f52:	8b 45 08             	mov    0x8(%ebp),%eax
80107f55:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107f59:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107f5d:	89 c2                	mov    %eax,%edx
80107f5f:	ec                   	in     (%dx),%al
80107f60:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107f63:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107f67:	c9                   	leave  
80107f68:	c3                   	ret    

80107f69 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107f69:	55                   	push   %ebp
80107f6a:	89 e5                	mov    %esp,%ebp
80107f6c:	83 ec 08             	sub    $0x8,%esp
80107f6f:	8b 55 08             	mov    0x8(%ebp),%edx
80107f72:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f75:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107f79:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107f7c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107f80:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107f84:	ee                   	out    %al,(%dx)
}
80107f85:	90                   	nop
80107f86:	c9                   	leave  
80107f87:	c3                   	ret    

80107f88 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107f88:	55                   	push   %ebp
80107f89:	89 e5                	mov    %esp,%ebp
80107f8b:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107f8e:	6a 00                	push   $0x0
80107f90:	68 fa 03 00 00       	push   $0x3fa
80107f95:	e8 cf ff ff ff       	call   80107f69 <outb>
80107f9a:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107f9d:	68 80 00 00 00       	push   $0x80
80107fa2:	68 fb 03 00 00       	push   $0x3fb
80107fa7:	e8 bd ff ff ff       	call   80107f69 <outb>
80107fac:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107faf:	6a 0c                	push   $0xc
80107fb1:	68 f8 03 00 00       	push   $0x3f8
80107fb6:	e8 ae ff ff ff       	call   80107f69 <outb>
80107fbb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107fbe:	6a 00                	push   $0x0
80107fc0:	68 f9 03 00 00       	push   $0x3f9
80107fc5:	e8 9f ff ff ff       	call   80107f69 <outb>
80107fca:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107fcd:	6a 03                	push   $0x3
80107fcf:	68 fb 03 00 00       	push   $0x3fb
80107fd4:	e8 90 ff ff ff       	call   80107f69 <outb>
80107fd9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107fdc:	6a 00                	push   $0x0
80107fde:	68 fc 03 00 00       	push   $0x3fc
80107fe3:	e8 81 ff ff ff       	call   80107f69 <outb>
80107fe8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107feb:	6a 01                	push   $0x1
80107fed:	68 f9 03 00 00       	push   $0x3f9
80107ff2:	e8 72 ff ff ff       	call   80107f69 <outb>
80107ff7:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107ffa:	68 fd 03 00 00       	push   $0x3fd
80107fff:	e8 48 ff ff ff       	call   80107f4c <inb>
80108004:	83 c4 04             	add    $0x4,%esp
80108007:	3c ff                	cmp    $0xff,%al
80108009:	74 6e                	je     80108079 <uartinit+0xf1>
    return;
  uart = 1;
8010800b:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
80108012:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80108015:	68 fa 03 00 00       	push   $0x3fa
8010801a:	e8 2d ff ff ff       	call   80107f4c <inb>
8010801f:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80108022:	68 f8 03 00 00       	push   $0x3f8
80108027:	e8 20 ff ff ff       	call   80107f4c <inb>
8010802c:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010802f:	83 ec 0c             	sub    $0xc,%esp
80108032:	6a 04                	push   $0x4
80108034:	e8 98 bf ff ff       	call   80103fd1 <picenable>
80108039:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
8010803c:	83 ec 08             	sub    $0x8,%esp
8010803f:	6a 00                	push   $0x0
80108041:	6a 04                	push   $0x4
80108043:	e8 38 ab ff ff       	call   80102b80 <ioapicenable>
80108048:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010804b:	c7 45 f4 4c a2 10 80 	movl   $0x8010a24c,-0xc(%ebp)
80108052:	eb 19                	jmp    8010806d <uartinit+0xe5>
    uartputc(*p);
80108054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108057:	0f b6 00             	movzbl (%eax),%eax
8010805a:	0f be c0             	movsbl %al,%eax
8010805d:	83 ec 0c             	sub    $0xc,%esp
80108060:	50                   	push   %eax
80108061:	e8 16 00 00 00       	call   8010807c <uartputc>
80108066:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108069:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010806d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108070:	0f b6 00             	movzbl (%eax),%eax
80108073:	84 c0                	test   %al,%al
80108075:	75 dd                	jne    80108054 <uartinit+0xcc>
80108077:	eb 01                	jmp    8010807a <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80108079:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010807a:	c9                   	leave  
8010807b:	c3                   	ret    

8010807c <uartputc>:

void
uartputc(int c)
{
8010807c:	55                   	push   %ebp
8010807d:	89 e5                	mov    %esp,%ebp
8010807f:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80108082:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80108087:	85 c0                	test   %eax,%eax
80108089:	74 53                	je     801080de <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010808b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108092:	eb 11                	jmp    801080a5 <uartputc+0x29>
    microdelay(10);
80108094:	83 ec 0c             	sub    $0xc,%esp
80108097:	6a 0a                	push   $0xa
80108099:	e8 48 b0 ff ff       	call   801030e6 <microdelay>
8010809e:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801080a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801080a5:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801080a9:	7f 1a                	jg     801080c5 <uartputc+0x49>
801080ab:	83 ec 0c             	sub    $0xc,%esp
801080ae:	68 fd 03 00 00       	push   $0x3fd
801080b3:	e8 94 fe ff ff       	call   80107f4c <inb>
801080b8:	83 c4 10             	add    $0x10,%esp
801080bb:	0f b6 c0             	movzbl %al,%eax
801080be:	83 e0 20             	and    $0x20,%eax
801080c1:	85 c0                	test   %eax,%eax
801080c3:	74 cf                	je     80108094 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801080c5:	8b 45 08             	mov    0x8(%ebp),%eax
801080c8:	0f b6 c0             	movzbl %al,%eax
801080cb:	83 ec 08             	sub    $0x8,%esp
801080ce:	50                   	push   %eax
801080cf:	68 f8 03 00 00       	push   $0x3f8
801080d4:	e8 90 fe ff ff       	call   80107f69 <outb>
801080d9:	83 c4 10             	add    $0x10,%esp
801080dc:	eb 01                	jmp    801080df <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801080de:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801080df:	c9                   	leave  
801080e0:	c3                   	ret    

801080e1 <uartgetc>:

static int
uartgetc(void)
{
801080e1:	55                   	push   %ebp
801080e2:	89 e5                	mov    %esp,%ebp
  if(!uart)
801080e4:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
801080e9:	85 c0                	test   %eax,%eax
801080eb:	75 07                	jne    801080f4 <uartgetc+0x13>
    return -1;
801080ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080f2:	eb 2e                	jmp    80108122 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801080f4:	68 fd 03 00 00       	push   $0x3fd
801080f9:	e8 4e fe ff ff       	call   80107f4c <inb>
801080fe:	83 c4 04             	add    $0x4,%esp
80108101:	0f b6 c0             	movzbl %al,%eax
80108104:	83 e0 01             	and    $0x1,%eax
80108107:	85 c0                	test   %eax,%eax
80108109:	75 07                	jne    80108112 <uartgetc+0x31>
    return -1;
8010810b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108110:	eb 10                	jmp    80108122 <uartgetc+0x41>
  return inb(COM1+0);
80108112:	68 f8 03 00 00       	push   $0x3f8
80108117:	e8 30 fe ff ff       	call   80107f4c <inb>
8010811c:	83 c4 04             	add    $0x4,%esp
8010811f:	0f b6 c0             	movzbl %al,%eax
}
80108122:	c9                   	leave  
80108123:	c3                   	ret    

80108124 <uartintr>:

void
uartintr(void)
{
80108124:	55                   	push   %ebp
80108125:	89 e5                	mov    %esp,%ebp
80108127:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010812a:	83 ec 0c             	sub    $0xc,%esp
8010812d:	68 e1 80 10 80       	push   $0x801080e1
80108132:	e8 c2 86 ff ff       	call   801007f9 <consoleintr>
80108137:	83 c4 10             	add    $0x10,%esp
}
8010813a:	90                   	nop
8010813b:	c9                   	leave  
8010813c:	c3                   	ret    

8010813d <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010813d:	6a 00                	push   $0x0
  pushl $0
8010813f:	6a 00                	push   $0x0
  jmp alltraps
80108141:	e9 cc f9 ff ff       	jmp    80107b12 <alltraps>

80108146 <vector1>:
.globl vector1
vector1:
  pushl $0
80108146:	6a 00                	push   $0x0
  pushl $1
80108148:	6a 01                	push   $0x1
  jmp alltraps
8010814a:	e9 c3 f9 ff ff       	jmp    80107b12 <alltraps>

8010814f <vector2>:
.globl vector2
vector2:
  pushl $0
8010814f:	6a 00                	push   $0x0
  pushl $2
80108151:	6a 02                	push   $0x2
  jmp alltraps
80108153:	e9 ba f9 ff ff       	jmp    80107b12 <alltraps>

80108158 <vector3>:
.globl vector3
vector3:
  pushl $0
80108158:	6a 00                	push   $0x0
  pushl $3
8010815a:	6a 03                	push   $0x3
  jmp alltraps
8010815c:	e9 b1 f9 ff ff       	jmp    80107b12 <alltraps>

80108161 <vector4>:
.globl vector4
vector4:
  pushl $0
80108161:	6a 00                	push   $0x0
  pushl $4
80108163:	6a 04                	push   $0x4
  jmp alltraps
80108165:	e9 a8 f9 ff ff       	jmp    80107b12 <alltraps>

8010816a <vector5>:
.globl vector5
vector5:
  pushl $0
8010816a:	6a 00                	push   $0x0
  pushl $5
8010816c:	6a 05                	push   $0x5
  jmp alltraps
8010816e:	e9 9f f9 ff ff       	jmp    80107b12 <alltraps>

80108173 <vector6>:
.globl vector6
vector6:
  pushl $0
80108173:	6a 00                	push   $0x0
  pushl $6
80108175:	6a 06                	push   $0x6
  jmp alltraps
80108177:	e9 96 f9 ff ff       	jmp    80107b12 <alltraps>

8010817c <vector7>:
.globl vector7
vector7:
  pushl $0
8010817c:	6a 00                	push   $0x0
  pushl $7
8010817e:	6a 07                	push   $0x7
  jmp alltraps
80108180:	e9 8d f9 ff ff       	jmp    80107b12 <alltraps>

80108185 <vector8>:
.globl vector8
vector8:
  pushl $8
80108185:	6a 08                	push   $0x8
  jmp alltraps
80108187:	e9 86 f9 ff ff       	jmp    80107b12 <alltraps>

8010818c <vector9>:
.globl vector9
vector9:
  pushl $0
8010818c:	6a 00                	push   $0x0
  pushl $9
8010818e:	6a 09                	push   $0x9
  jmp alltraps
80108190:	e9 7d f9 ff ff       	jmp    80107b12 <alltraps>

80108195 <vector10>:
.globl vector10
vector10:
  pushl $10
80108195:	6a 0a                	push   $0xa
  jmp alltraps
80108197:	e9 76 f9 ff ff       	jmp    80107b12 <alltraps>

8010819c <vector11>:
.globl vector11
vector11:
  pushl $11
8010819c:	6a 0b                	push   $0xb
  jmp alltraps
8010819e:	e9 6f f9 ff ff       	jmp    80107b12 <alltraps>

801081a3 <vector12>:
.globl vector12
vector12:
  pushl $12
801081a3:	6a 0c                	push   $0xc
  jmp alltraps
801081a5:	e9 68 f9 ff ff       	jmp    80107b12 <alltraps>

801081aa <vector13>:
.globl vector13
vector13:
  pushl $13
801081aa:	6a 0d                	push   $0xd
  jmp alltraps
801081ac:	e9 61 f9 ff ff       	jmp    80107b12 <alltraps>

801081b1 <vector14>:
.globl vector14
vector14:
  pushl $14
801081b1:	6a 0e                	push   $0xe
  jmp alltraps
801081b3:	e9 5a f9 ff ff       	jmp    80107b12 <alltraps>

801081b8 <vector15>:
.globl vector15
vector15:
  pushl $0
801081b8:	6a 00                	push   $0x0
  pushl $15
801081ba:	6a 0f                	push   $0xf
  jmp alltraps
801081bc:	e9 51 f9 ff ff       	jmp    80107b12 <alltraps>

801081c1 <vector16>:
.globl vector16
vector16:
  pushl $0
801081c1:	6a 00                	push   $0x0
  pushl $16
801081c3:	6a 10                	push   $0x10
  jmp alltraps
801081c5:	e9 48 f9 ff ff       	jmp    80107b12 <alltraps>

801081ca <vector17>:
.globl vector17
vector17:
  pushl $17
801081ca:	6a 11                	push   $0x11
  jmp alltraps
801081cc:	e9 41 f9 ff ff       	jmp    80107b12 <alltraps>

801081d1 <vector18>:
.globl vector18
vector18:
  pushl $0
801081d1:	6a 00                	push   $0x0
  pushl $18
801081d3:	6a 12                	push   $0x12
  jmp alltraps
801081d5:	e9 38 f9 ff ff       	jmp    80107b12 <alltraps>

801081da <vector19>:
.globl vector19
vector19:
  pushl $0
801081da:	6a 00                	push   $0x0
  pushl $19
801081dc:	6a 13                	push   $0x13
  jmp alltraps
801081de:	e9 2f f9 ff ff       	jmp    80107b12 <alltraps>

801081e3 <vector20>:
.globl vector20
vector20:
  pushl $0
801081e3:	6a 00                	push   $0x0
  pushl $20
801081e5:	6a 14                	push   $0x14
  jmp alltraps
801081e7:	e9 26 f9 ff ff       	jmp    80107b12 <alltraps>

801081ec <vector21>:
.globl vector21
vector21:
  pushl $0
801081ec:	6a 00                	push   $0x0
  pushl $21
801081ee:	6a 15                	push   $0x15
  jmp alltraps
801081f0:	e9 1d f9 ff ff       	jmp    80107b12 <alltraps>

801081f5 <vector22>:
.globl vector22
vector22:
  pushl $0
801081f5:	6a 00                	push   $0x0
  pushl $22
801081f7:	6a 16                	push   $0x16
  jmp alltraps
801081f9:	e9 14 f9 ff ff       	jmp    80107b12 <alltraps>

801081fe <vector23>:
.globl vector23
vector23:
  pushl $0
801081fe:	6a 00                	push   $0x0
  pushl $23
80108200:	6a 17                	push   $0x17
  jmp alltraps
80108202:	e9 0b f9 ff ff       	jmp    80107b12 <alltraps>

80108207 <vector24>:
.globl vector24
vector24:
  pushl $0
80108207:	6a 00                	push   $0x0
  pushl $24
80108209:	6a 18                	push   $0x18
  jmp alltraps
8010820b:	e9 02 f9 ff ff       	jmp    80107b12 <alltraps>

80108210 <vector25>:
.globl vector25
vector25:
  pushl $0
80108210:	6a 00                	push   $0x0
  pushl $25
80108212:	6a 19                	push   $0x19
  jmp alltraps
80108214:	e9 f9 f8 ff ff       	jmp    80107b12 <alltraps>

80108219 <vector26>:
.globl vector26
vector26:
  pushl $0
80108219:	6a 00                	push   $0x0
  pushl $26
8010821b:	6a 1a                	push   $0x1a
  jmp alltraps
8010821d:	e9 f0 f8 ff ff       	jmp    80107b12 <alltraps>

80108222 <vector27>:
.globl vector27
vector27:
  pushl $0
80108222:	6a 00                	push   $0x0
  pushl $27
80108224:	6a 1b                	push   $0x1b
  jmp alltraps
80108226:	e9 e7 f8 ff ff       	jmp    80107b12 <alltraps>

8010822b <vector28>:
.globl vector28
vector28:
  pushl $0
8010822b:	6a 00                	push   $0x0
  pushl $28
8010822d:	6a 1c                	push   $0x1c
  jmp alltraps
8010822f:	e9 de f8 ff ff       	jmp    80107b12 <alltraps>

80108234 <vector29>:
.globl vector29
vector29:
  pushl $0
80108234:	6a 00                	push   $0x0
  pushl $29
80108236:	6a 1d                	push   $0x1d
  jmp alltraps
80108238:	e9 d5 f8 ff ff       	jmp    80107b12 <alltraps>

8010823d <vector30>:
.globl vector30
vector30:
  pushl $0
8010823d:	6a 00                	push   $0x0
  pushl $30
8010823f:	6a 1e                	push   $0x1e
  jmp alltraps
80108241:	e9 cc f8 ff ff       	jmp    80107b12 <alltraps>

80108246 <vector31>:
.globl vector31
vector31:
  pushl $0
80108246:	6a 00                	push   $0x0
  pushl $31
80108248:	6a 1f                	push   $0x1f
  jmp alltraps
8010824a:	e9 c3 f8 ff ff       	jmp    80107b12 <alltraps>

8010824f <vector32>:
.globl vector32
vector32:
  pushl $0
8010824f:	6a 00                	push   $0x0
  pushl $32
80108251:	6a 20                	push   $0x20
  jmp alltraps
80108253:	e9 ba f8 ff ff       	jmp    80107b12 <alltraps>

80108258 <vector33>:
.globl vector33
vector33:
  pushl $0
80108258:	6a 00                	push   $0x0
  pushl $33
8010825a:	6a 21                	push   $0x21
  jmp alltraps
8010825c:	e9 b1 f8 ff ff       	jmp    80107b12 <alltraps>

80108261 <vector34>:
.globl vector34
vector34:
  pushl $0
80108261:	6a 00                	push   $0x0
  pushl $34
80108263:	6a 22                	push   $0x22
  jmp alltraps
80108265:	e9 a8 f8 ff ff       	jmp    80107b12 <alltraps>

8010826a <vector35>:
.globl vector35
vector35:
  pushl $0
8010826a:	6a 00                	push   $0x0
  pushl $35
8010826c:	6a 23                	push   $0x23
  jmp alltraps
8010826e:	e9 9f f8 ff ff       	jmp    80107b12 <alltraps>

80108273 <vector36>:
.globl vector36
vector36:
  pushl $0
80108273:	6a 00                	push   $0x0
  pushl $36
80108275:	6a 24                	push   $0x24
  jmp alltraps
80108277:	e9 96 f8 ff ff       	jmp    80107b12 <alltraps>

8010827c <vector37>:
.globl vector37
vector37:
  pushl $0
8010827c:	6a 00                	push   $0x0
  pushl $37
8010827e:	6a 25                	push   $0x25
  jmp alltraps
80108280:	e9 8d f8 ff ff       	jmp    80107b12 <alltraps>

80108285 <vector38>:
.globl vector38
vector38:
  pushl $0
80108285:	6a 00                	push   $0x0
  pushl $38
80108287:	6a 26                	push   $0x26
  jmp alltraps
80108289:	e9 84 f8 ff ff       	jmp    80107b12 <alltraps>

8010828e <vector39>:
.globl vector39
vector39:
  pushl $0
8010828e:	6a 00                	push   $0x0
  pushl $39
80108290:	6a 27                	push   $0x27
  jmp alltraps
80108292:	e9 7b f8 ff ff       	jmp    80107b12 <alltraps>

80108297 <vector40>:
.globl vector40
vector40:
  pushl $0
80108297:	6a 00                	push   $0x0
  pushl $40
80108299:	6a 28                	push   $0x28
  jmp alltraps
8010829b:	e9 72 f8 ff ff       	jmp    80107b12 <alltraps>

801082a0 <vector41>:
.globl vector41
vector41:
  pushl $0
801082a0:	6a 00                	push   $0x0
  pushl $41
801082a2:	6a 29                	push   $0x29
  jmp alltraps
801082a4:	e9 69 f8 ff ff       	jmp    80107b12 <alltraps>

801082a9 <vector42>:
.globl vector42
vector42:
  pushl $0
801082a9:	6a 00                	push   $0x0
  pushl $42
801082ab:	6a 2a                	push   $0x2a
  jmp alltraps
801082ad:	e9 60 f8 ff ff       	jmp    80107b12 <alltraps>

801082b2 <vector43>:
.globl vector43
vector43:
  pushl $0
801082b2:	6a 00                	push   $0x0
  pushl $43
801082b4:	6a 2b                	push   $0x2b
  jmp alltraps
801082b6:	e9 57 f8 ff ff       	jmp    80107b12 <alltraps>

801082bb <vector44>:
.globl vector44
vector44:
  pushl $0
801082bb:	6a 00                	push   $0x0
  pushl $44
801082bd:	6a 2c                	push   $0x2c
  jmp alltraps
801082bf:	e9 4e f8 ff ff       	jmp    80107b12 <alltraps>

801082c4 <vector45>:
.globl vector45
vector45:
  pushl $0
801082c4:	6a 00                	push   $0x0
  pushl $45
801082c6:	6a 2d                	push   $0x2d
  jmp alltraps
801082c8:	e9 45 f8 ff ff       	jmp    80107b12 <alltraps>

801082cd <vector46>:
.globl vector46
vector46:
  pushl $0
801082cd:	6a 00                	push   $0x0
  pushl $46
801082cf:	6a 2e                	push   $0x2e
  jmp alltraps
801082d1:	e9 3c f8 ff ff       	jmp    80107b12 <alltraps>

801082d6 <vector47>:
.globl vector47
vector47:
  pushl $0
801082d6:	6a 00                	push   $0x0
  pushl $47
801082d8:	6a 2f                	push   $0x2f
  jmp alltraps
801082da:	e9 33 f8 ff ff       	jmp    80107b12 <alltraps>

801082df <vector48>:
.globl vector48
vector48:
  pushl $0
801082df:	6a 00                	push   $0x0
  pushl $48
801082e1:	6a 30                	push   $0x30
  jmp alltraps
801082e3:	e9 2a f8 ff ff       	jmp    80107b12 <alltraps>

801082e8 <vector49>:
.globl vector49
vector49:
  pushl $0
801082e8:	6a 00                	push   $0x0
  pushl $49
801082ea:	6a 31                	push   $0x31
  jmp alltraps
801082ec:	e9 21 f8 ff ff       	jmp    80107b12 <alltraps>

801082f1 <vector50>:
.globl vector50
vector50:
  pushl $0
801082f1:	6a 00                	push   $0x0
  pushl $50
801082f3:	6a 32                	push   $0x32
  jmp alltraps
801082f5:	e9 18 f8 ff ff       	jmp    80107b12 <alltraps>

801082fa <vector51>:
.globl vector51
vector51:
  pushl $0
801082fa:	6a 00                	push   $0x0
  pushl $51
801082fc:	6a 33                	push   $0x33
  jmp alltraps
801082fe:	e9 0f f8 ff ff       	jmp    80107b12 <alltraps>

80108303 <vector52>:
.globl vector52
vector52:
  pushl $0
80108303:	6a 00                	push   $0x0
  pushl $52
80108305:	6a 34                	push   $0x34
  jmp alltraps
80108307:	e9 06 f8 ff ff       	jmp    80107b12 <alltraps>

8010830c <vector53>:
.globl vector53
vector53:
  pushl $0
8010830c:	6a 00                	push   $0x0
  pushl $53
8010830e:	6a 35                	push   $0x35
  jmp alltraps
80108310:	e9 fd f7 ff ff       	jmp    80107b12 <alltraps>

80108315 <vector54>:
.globl vector54
vector54:
  pushl $0
80108315:	6a 00                	push   $0x0
  pushl $54
80108317:	6a 36                	push   $0x36
  jmp alltraps
80108319:	e9 f4 f7 ff ff       	jmp    80107b12 <alltraps>

8010831e <vector55>:
.globl vector55
vector55:
  pushl $0
8010831e:	6a 00                	push   $0x0
  pushl $55
80108320:	6a 37                	push   $0x37
  jmp alltraps
80108322:	e9 eb f7 ff ff       	jmp    80107b12 <alltraps>

80108327 <vector56>:
.globl vector56
vector56:
  pushl $0
80108327:	6a 00                	push   $0x0
  pushl $56
80108329:	6a 38                	push   $0x38
  jmp alltraps
8010832b:	e9 e2 f7 ff ff       	jmp    80107b12 <alltraps>

80108330 <vector57>:
.globl vector57
vector57:
  pushl $0
80108330:	6a 00                	push   $0x0
  pushl $57
80108332:	6a 39                	push   $0x39
  jmp alltraps
80108334:	e9 d9 f7 ff ff       	jmp    80107b12 <alltraps>

80108339 <vector58>:
.globl vector58
vector58:
  pushl $0
80108339:	6a 00                	push   $0x0
  pushl $58
8010833b:	6a 3a                	push   $0x3a
  jmp alltraps
8010833d:	e9 d0 f7 ff ff       	jmp    80107b12 <alltraps>

80108342 <vector59>:
.globl vector59
vector59:
  pushl $0
80108342:	6a 00                	push   $0x0
  pushl $59
80108344:	6a 3b                	push   $0x3b
  jmp alltraps
80108346:	e9 c7 f7 ff ff       	jmp    80107b12 <alltraps>

8010834b <vector60>:
.globl vector60
vector60:
  pushl $0
8010834b:	6a 00                	push   $0x0
  pushl $60
8010834d:	6a 3c                	push   $0x3c
  jmp alltraps
8010834f:	e9 be f7 ff ff       	jmp    80107b12 <alltraps>

80108354 <vector61>:
.globl vector61
vector61:
  pushl $0
80108354:	6a 00                	push   $0x0
  pushl $61
80108356:	6a 3d                	push   $0x3d
  jmp alltraps
80108358:	e9 b5 f7 ff ff       	jmp    80107b12 <alltraps>

8010835d <vector62>:
.globl vector62
vector62:
  pushl $0
8010835d:	6a 00                	push   $0x0
  pushl $62
8010835f:	6a 3e                	push   $0x3e
  jmp alltraps
80108361:	e9 ac f7 ff ff       	jmp    80107b12 <alltraps>

80108366 <vector63>:
.globl vector63
vector63:
  pushl $0
80108366:	6a 00                	push   $0x0
  pushl $63
80108368:	6a 3f                	push   $0x3f
  jmp alltraps
8010836a:	e9 a3 f7 ff ff       	jmp    80107b12 <alltraps>

8010836f <vector64>:
.globl vector64
vector64:
  pushl $0
8010836f:	6a 00                	push   $0x0
  pushl $64
80108371:	6a 40                	push   $0x40
  jmp alltraps
80108373:	e9 9a f7 ff ff       	jmp    80107b12 <alltraps>

80108378 <vector65>:
.globl vector65
vector65:
  pushl $0
80108378:	6a 00                	push   $0x0
  pushl $65
8010837a:	6a 41                	push   $0x41
  jmp alltraps
8010837c:	e9 91 f7 ff ff       	jmp    80107b12 <alltraps>

80108381 <vector66>:
.globl vector66
vector66:
  pushl $0
80108381:	6a 00                	push   $0x0
  pushl $66
80108383:	6a 42                	push   $0x42
  jmp alltraps
80108385:	e9 88 f7 ff ff       	jmp    80107b12 <alltraps>

8010838a <vector67>:
.globl vector67
vector67:
  pushl $0
8010838a:	6a 00                	push   $0x0
  pushl $67
8010838c:	6a 43                	push   $0x43
  jmp alltraps
8010838e:	e9 7f f7 ff ff       	jmp    80107b12 <alltraps>

80108393 <vector68>:
.globl vector68
vector68:
  pushl $0
80108393:	6a 00                	push   $0x0
  pushl $68
80108395:	6a 44                	push   $0x44
  jmp alltraps
80108397:	e9 76 f7 ff ff       	jmp    80107b12 <alltraps>

8010839c <vector69>:
.globl vector69
vector69:
  pushl $0
8010839c:	6a 00                	push   $0x0
  pushl $69
8010839e:	6a 45                	push   $0x45
  jmp alltraps
801083a0:	e9 6d f7 ff ff       	jmp    80107b12 <alltraps>

801083a5 <vector70>:
.globl vector70
vector70:
  pushl $0
801083a5:	6a 00                	push   $0x0
  pushl $70
801083a7:	6a 46                	push   $0x46
  jmp alltraps
801083a9:	e9 64 f7 ff ff       	jmp    80107b12 <alltraps>

801083ae <vector71>:
.globl vector71
vector71:
  pushl $0
801083ae:	6a 00                	push   $0x0
  pushl $71
801083b0:	6a 47                	push   $0x47
  jmp alltraps
801083b2:	e9 5b f7 ff ff       	jmp    80107b12 <alltraps>

801083b7 <vector72>:
.globl vector72
vector72:
  pushl $0
801083b7:	6a 00                	push   $0x0
  pushl $72
801083b9:	6a 48                	push   $0x48
  jmp alltraps
801083bb:	e9 52 f7 ff ff       	jmp    80107b12 <alltraps>

801083c0 <vector73>:
.globl vector73
vector73:
  pushl $0
801083c0:	6a 00                	push   $0x0
  pushl $73
801083c2:	6a 49                	push   $0x49
  jmp alltraps
801083c4:	e9 49 f7 ff ff       	jmp    80107b12 <alltraps>

801083c9 <vector74>:
.globl vector74
vector74:
  pushl $0
801083c9:	6a 00                	push   $0x0
  pushl $74
801083cb:	6a 4a                	push   $0x4a
  jmp alltraps
801083cd:	e9 40 f7 ff ff       	jmp    80107b12 <alltraps>

801083d2 <vector75>:
.globl vector75
vector75:
  pushl $0
801083d2:	6a 00                	push   $0x0
  pushl $75
801083d4:	6a 4b                	push   $0x4b
  jmp alltraps
801083d6:	e9 37 f7 ff ff       	jmp    80107b12 <alltraps>

801083db <vector76>:
.globl vector76
vector76:
  pushl $0
801083db:	6a 00                	push   $0x0
  pushl $76
801083dd:	6a 4c                	push   $0x4c
  jmp alltraps
801083df:	e9 2e f7 ff ff       	jmp    80107b12 <alltraps>

801083e4 <vector77>:
.globl vector77
vector77:
  pushl $0
801083e4:	6a 00                	push   $0x0
  pushl $77
801083e6:	6a 4d                	push   $0x4d
  jmp alltraps
801083e8:	e9 25 f7 ff ff       	jmp    80107b12 <alltraps>

801083ed <vector78>:
.globl vector78
vector78:
  pushl $0
801083ed:	6a 00                	push   $0x0
  pushl $78
801083ef:	6a 4e                	push   $0x4e
  jmp alltraps
801083f1:	e9 1c f7 ff ff       	jmp    80107b12 <alltraps>

801083f6 <vector79>:
.globl vector79
vector79:
  pushl $0
801083f6:	6a 00                	push   $0x0
  pushl $79
801083f8:	6a 4f                	push   $0x4f
  jmp alltraps
801083fa:	e9 13 f7 ff ff       	jmp    80107b12 <alltraps>

801083ff <vector80>:
.globl vector80
vector80:
  pushl $0
801083ff:	6a 00                	push   $0x0
  pushl $80
80108401:	6a 50                	push   $0x50
  jmp alltraps
80108403:	e9 0a f7 ff ff       	jmp    80107b12 <alltraps>

80108408 <vector81>:
.globl vector81
vector81:
  pushl $0
80108408:	6a 00                	push   $0x0
  pushl $81
8010840a:	6a 51                	push   $0x51
  jmp alltraps
8010840c:	e9 01 f7 ff ff       	jmp    80107b12 <alltraps>

80108411 <vector82>:
.globl vector82
vector82:
  pushl $0
80108411:	6a 00                	push   $0x0
  pushl $82
80108413:	6a 52                	push   $0x52
  jmp alltraps
80108415:	e9 f8 f6 ff ff       	jmp    80107b12 <alltraps>

8010841a <vector83>:
.globl vector83
vector83:
  pushl $0
8010841a:	6a 00                	push   $0x0
  pushl $83
8010841c:	6a 53                	push   $0x53
  jmp alltraps
8010841e:	e9 ef f6 ff ff       	jmp    80107b12 <alltraps>

80108423 <vector84>:
.globl vector84
vector84:
  pushl $0
80108423:	6a 00                	push   $0x0
  pushl $84
80108425:	6a 54                	push   $0x54
  jmp alltraps
80108427:	e9 e6 f6 ff ff       	jmp    80107b12 <alltraps>

8010842c <vector85>:
.globl vector85
vector85:
  pushl $0
8010842c:	6a 00                	push   $0x0
  pushl $85
8010842e:	6a 55                	push   $0x55
  jmp alltraps
80108430:	e9 dd f6 ff ff       	jmp    80107b12 <alltraps>

80108435 <vector86>:
.globl vector86
vector86:
  pushl $0
80108435:	6a 00                	push   $0x0
  pushl $86
80108437:	6a 56                	push   $0x56
  jmp alltraps
80108439:	e9 d4 f6 ff ff       	jmp    80107b12 <alltraps>

8010843e <vector87>:
.globl vector87
vector87:
  pushl $0
8010843e:	6a 00                	push   $0x0
  pushl $87
80108440:	6a 57                	push   $0x57
  jmp alltraps
80108442:	e9 cb f6 ff ff       	jmp    80107b12 <alltraps>

80108447 <vector88>:
.globl vector88
vector88:
  pushl $0
80108447:	6a 00                	push   $0x0
  pushl $88
80108449:	6a 58                	push   $0x58
  jmp alltraps
8010844b:	e9 c2 f6 ff ff       	jmp    80107b12 <alltraps>

80108450 <vector89>:
.globl vector89
vector89:
  pushl $0
80108450:	6a 00                	push   $0x0
  pushl $89
80108452:	6a 59                	push   $0x59
  jmp alltraps
80108454:	e9 b9 f6 ff ff       	jmp    80107b12 <alltraps>

80108459 <vector90>:
.globl vector90
vector90:
  pushl $0
80108459:	6a 00                	push   $0x0
  pushl $90
8010845b:	6a 5a                	push   $0x5a
  jmp alltraps
8010845d:	e9 b0 f6 ff ff       	jmp    80107b12 <alltraps>

80108462 <vector91>:
.globl vector91
vector91:
  pushl $0
80108462:	6a 00                	push   $0x0
  pushl $91
80108464:	6a 5b                	push   $0x5b
  jmp alltraps
80108466:	e9 a7 f6 ff ff       	jmp    80107b12 <alltraps>

8010846b <vector92>:
.globl vector92
vector92:
  pushl $0
8010846b:	6a 00                	push   $0x0
  pushl $92
8010846d:	6a 5c                	push   $0x5c
  jmp alltraps
8010846f:	e9 9e f6 ff ff       	jmp    80107b12 <alltraps>

80108474 <vector93>:
.globl vector93
vector93:
  pushl $0
80108474:	6a 00                	push   $0x0
  pushl $93
80108476:	6a 5d                	push   $0x5d
  jmp alltraps
80108478:	e9 95 f6 ff ff       	jmp    80107b12 <alltraps>

8010847d <vector94>:
.globl vector94
vector94:
  pushl $0
8010847d:	6a 00                	push   $0x0
  pushl $94
8010847f:	6a 5e                	push   $0x5e
  jmp alltraps
80108481:	e9 8c f6 ff ff       	jmp    80107b12 <alltraps>

80108486 <vector95>:
.globl vector95
vector95:
  pushl $0
80108486:	6a 00                	push   $0x0
  pushl $95
80108488:	6a 5f                	push   $0x5f
  jmp alltraps
8010848a:	e9 83 f6 ff ff       	jmp    80107b12 <alltraps>

8010848f <vector96>:
.globl vector96
vector96:
  pushl $0
8010848f:	6a 00                	push   $0x0
  pushl $96
80108491:	6a 60                	push   $0x60
  jmp alltraps
80108493:	e9 7a f6 ff ff       	jmp    80107b12 <alltraps>

80108498 <vector97>:
.globl vector97
vector97:
  pushl $0
80108498:	6a 00                	push   $0x0
  pushl $97
8010849a:	6a 61                	push   $0x61
  jmp alltraps
8010849c:	e9 71 f6 ff ff       	jmp    80107b12 <alltraps>

801084a1 <vector98>:
.globl vector98
vector98:
  pushl $0
801084a1:	6a 00                	push   $0x0
  pushl $98
801084a3:	6a 62                	push   $0x62
  jmp alltraps
801084a5:	e9 68 f6 ff ff       	jmp    80107b12 <alltraps>

801084aa <vector99>:
.globl vector99
vector99:
  pushl $0
801084aa:	6a 00                	push   $0x0
  pushl $99
801084ac:	6a 63                	push   $0x63
  jmp alltraps
801084ae:	e9 5f f6 ff ff       	jmp    80107b12 <alltraps>

801084b3 <vector100>:
.globl vector100
vector100:
  pushl $0
801084b3:	6a 00                	push   $0x0
  pushl $100
801084b5:	6a 64                	push   $0x64
  jmp alltraps
801084b7:	e9 56 f6 ff ff       	jmp    80107b12 <alltraps>

801084bc <vector101>:
.globl vector101
vector101:
  pushl $0
801084bc:	6a 00                	push   $0x0
  pushl $101
801084be:	6a 65                	push   $0x65
  jmp alltraps
801084c0:	e9 4d f6 ff ff       	jmp    80107b12 <alltraps>

801084c5 <vector102>:
.globl vector102
vector102:
  pushl $0
801084c5:	6a 00                	push   $0x0
  pushl $102
801084c7:	6a 66                	push   $0x66
  jmp alltraps
801084c9:	e9 44 f6 ff ff       	jmp    80107b12 <alltraps>

801084ce <vector103>:
.globl vector103
vector103:
  pushl $0
801084ce:	6a 00                	push   $0x0
  pushl $103
801084d0:	6a 67                	push   $0x67
  jmp alltraps
801084d2:	e9 3b f6 ff ff       	jmp    80107b12 <alltraps>

801084d7 <vector104>:
.globl vector104
vector104:
  pushl $0
801084d7:	6a 00                	push   $0x0
  pushl $104
801084d9:	6a 68                	push   $0x68
  jmp alltraps
801084db:	e9 32 f6 ff ff       	jmp    80107b12 <alltraps>

801084e0 <vector105>:
.globl vector105
vector105:
  pushl $0
801084e0:	6a 00                	push   $0x0
  pushl $105
801084e2:	6a 69                	push   $0x69
  jmp alltraps
801084e4:	e9 29 f6 ff ff       	jmp    80107b12 <alltraps>

801084e9 <vector106>:
.globl vector106
vector106:
  pushl $0
801084e9:	6a 00                	push   $0x0
  pushl $106
801084eb:	6a 6a                	push   $0x6a
  jmp alltraps
801084ed:	e9 20 f6 ff ff       	jmp    80107b12 <alltraps>

801084f2 <vector107>:
.globl vector107
vector107:
  pushl $0
801084f2:	6a 00                	push   $0x0
  pushl $107
801084f4:	6a 6b                	push   $0x6b
  jmp alltraps
801084f6:	e9 17 f6 ff ff       	jmp    80107b12 <alltraps>

801084fb <vector108>:
.globl vector108
vector108:
  pushl $0
801084fb:	6a 00                	push   $0x0
  pushl $108
801084fd:	6a 6c                	push   $0x6c
  jmp alltraps
801084ff:	e9 0e f6 ff ff       	jmp    80107b12 <alltraps>

80108504 <vector109>:
.globl vector109
vector109:
  pushl $0
80108504:	6a 00                	push   $0x0
  pushl $109
80108506:	6a 6d                	push   $0x6d
  jmp alltraps
80108508:	e9 05 f6 ff ff       	jmp    80107b12 <alltraps>

8010850d <vector110>:
.globl vector110
vector110:
  pushl $0
8010850d:	6a 00                	push   $0x0
  pushl $110
8010850f:	6a 6e                	push   $0x6e
  jmp alltraps
80108511:	e9 fc f5 ff ff       	jmp    80107b12 <alltraps>

80108516 <vector111>:
.globl vector111
vector111:
  pushl $0
80108516:	6a 00                	push   $0x0
  pushl $111
80108518:	6a 6f                	push   $0x6f
  jmp alltraps
8010851a:	e9 f3 f5 ff ff       	jmp    80107b12 <alltraps>

8010851f <vector112>:
.globl vector112
vector112:
  pushl $0
8010851f:	6a 00                	push   $0x0
  pushl $112
80108521:	6a 70                	push   $0x70
  jmp alltraps
80108523:	e9 ea f5 ff ff       	jmp    80107b12 <alltraps>

80108528 <vector113>:
.globl vector113
vector113:
  pushl $0
80108528:	6a 00                	push   $0x0
  pushl $113
8010852a:	6a 71                	push   $0x71
  jmp alltraps
8010852c:	e9 e1 f5 ff ff       	jmp    80107b12 <alltraps>

80108531 <vector114>:
.globl vector114
vector114:
  pushl $0
80108531:	6a 00                	push   $0x0
  pushl $114
80108533:	6a 72                	push   $0x72
  jmp alltraps
80108535:	e9 d8 f5 ff ff       	jmp    80107b12 <alltraps>

8010853a <vector115>:
.globl vector115
vector115:
  pushl $0
8010853a:	6a 00                	push   $0x0
  pushl $115
8010853c:	6a 73                	push   $0x73
  jmp alltraps
8010853e:	e9 cf f5 ff ff       	jmp    80107b12 <alltraps>

80108543 <vector116>:
.globl vector116
vector116:
  pushl $0
80108543:	6a 00                	push   $0x0
  pushl $116
80108545:	6a 74                	push   $0x74
  jmp alltraps
80108547:	e9 c6 f5 ff ff       	jmp    80107b12 <alltraps>

8010854c <vector117>:
.globl vector117
vector117:
  pushl $0
8010854c:	6a 00                	push   $0x0
  pushl $117
8010854e:	6a 75                	push   $0x75
  jmp alltraps
80108550:	e9 bd f5 ff ff       	jmp    80107b12 <alltraps>

80108555 <vector118>:
.globl vector118
vector118:
  pushl $0
80108555:	6a 00                	push   $0x0
  pushl $118
80108557:	6a 76                	push   $0x76
  jmp alltraps
80108559:	e9 b4 f5 ff ff       	jmp    80107b12 <alltraps>

8010855e <vector119>:
.globl vector119
vector119:
  pushl $0
8010855e:	6a 00                	push   $0x0
  pushl $119
80108560:	6a 77                	push   $0x77
  jmp alltraps
80108562:	e9 ab f5 ff ff       	jmp    80107b12 <alltraps>

80108567 <vector120>:
.globl vector120
vector120:
  pushl $0
80108567:	6a 00                	push   $0x0
  pushl $120
80108569:	6a 78                	push   $0x78
  jmp alltraps
8010856b:	e9 a2 f5 ff ff       	jmp    80107b12 <alltraps>

80108570 <vector121>:
.globl vector121
vector121:
  pushl $0
80108570:	6a 00                	push   $0x0
  pushl $121
80108572:	6a 79                	push   $0x79
  jmp alltraps
80108574:	e9 99 f5 ff ff       	jmp    80107b12 <alltraps>

80108579 <vector122>:
.globl vector122
vector122:
  pushl $0
80108579:	6a 00                	push   $0x0
  pushl $122
8010857b:	6a 7a                	push   $0x7a
  jmp alltraps
8010857d:	e9 90 f5 ff ff       	jmp    80107b12 <alltraps>

80108582 <vector123>:
.globl vector123
vector123:
  pushl $0
80108582:	6a 00                	push   $0x0
  pushl $123
80108584:	6a 7b                	push   $0x7b
  jmp alltraps
80108586:	e9 87 f5 ff ff       	jmp    80107b12 <alltraps>

8010858b <vector124>:
.globl vector124
vector124:
  pushl $0
8010858b:	6a 00                	push   $0x0
  pushl $124
8010858d:	6a 7c                	push   $0x7c
  jmp alltraps
8010858f:	e9 7e f5 ff ff       	jmp    80107b12 <alltraps>

80108594 <vector125>:
.globl vector125
vector125:
  pushl $0
80108594:	6a 00                	push   $0x0
  pushl $125
80108596:	6a 7d                	push   $0x7d
  jmp alltraps
80108598:	e9 75 f5 ff ff       	jmp    80107b12 <alltraps>

8010859d <vector126>:
.globl vector126
vector126:
  pushl $0
8010859d:	6a 00                	push   $0x0
  pushl $126
8010859f:	6a 7e                	push   $0x7e
  jmp alltraps
801085a1:	e9 6c f5 ff ff       	jmp    80107b12 <alltraps>

801085a6 <vector127>:
.globl vector127
vector127:
  pushl $0
801085a6:	6a 00                	push   $0x0
  pushl $127
801085a8:	6a 7f                	push   $0x7f
  jmp alltraps
801085aa:	e9 63 f5 ff ff       	jmp    80107b12 <alltraps>

801085af <vector128>:
.globl vector128
vector128:
  pushl $0
801085af:	6a 00                	push   $0x0
  pushl $128
801085b1:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801085b6:	e9 57 f5 ff ff       	jmp    80107b12 <alltraps>

801085bb <vector129>:
.globl vector129
vector129:
  pushl $0
801085bb:	6a 00                	push   $0x0
  pushl $129
801085bd:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801085c2:	e9 4b f5 ff ff       	jmp    80107b12 <alltraps>

801085c7 <vector130>:
.globl vector130
vector130:
  pushl $0
801085c7:	6a 00                	push   $0x0
  pushl $130
801085c9:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801085ce:	e9 3f f5 ff ff       	jmp    80107b12 <alltraps>

801085d3 <vector131>:
.globl vector131
vector131:
  pushl $0
801085d3:	6a 00                	push   $0x0
  pushl $131
801085d5:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801085da:	e9 33 f5 ff ff       	jmp    80107b12 <alltraps>

801085df <vector132>:
.globl vector132
vector132:
  pushl $0
801085df:	6a 00                	push   $0x0
  pushl $132
801085e1:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801085e6:	e9 27 f5 ff ff       	jmp    80107b12 <alltraps>

801085eb <vector133>:
.globl vector133
vector133:
  pushl $0
801085eb:	6a 00                	push   $0x0
  pushl $133
801085ed:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801085f2:	e9 1b f5 ff ff       	jmp    80107b12 <alltraps>

801085f7 <vector134>:
.globl vector134
vector134:
  pushl $0
801085f7:	6a 00                	push   $0x0
  pushl $134
801085f9:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801085fe:	e9 0f f5 ff ff       	jmp    80107b12 <alltraps>

80108603 <vector135>:
.globl vector135
vector135:
  pushl $0
80108603:	6a 00                	push   $0x0
  pushl $135
80108605:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010860a:	e9 03 f5 ff ff       	jmp    80107b12 <alltraps>

8010860f <vector136>:
.globl vector136
vector136:
  pushl $0
8010860f:	6a 00                	push   $0x0
  pushl $136
80108611:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108616:	e9 f7 f4 ff ff       	jmp    80107b12 <alltraps>

8010861b <vector137>:
.globl vector137
vector137:
  pushl $0
8010861b:	6a 00                	push   $0x0
  pushl $137
8010861d:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108622:	e9 eb f4 ff ff       	jmp    80107b12 <alltraps>

80108627 <vector138>:
.globl vector138
vector138:
  pushl $0
80108627:	6a 00                	push   $0x0
  pushl $138
80108629:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010862e:	e9 df f4 ff ff       	jmp    80107b12 <alltraps>

80108633 <vector139>:
.globl vector139
vector139:
  pushl $0
80108633:	6a 00                	push   $0x0
  pushl $139
80108635:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010863a:	e9 d3 f4 ff ff       	jmp    80107b12 <alltraps>

8010863f <vector140>:
.globl vector140
vector140:
  pushl $0
8010863f:	6a 00                	push   $0x0
  pushl $140
80108641:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108646:	e9 c7 f4 ff ff       	jmp    80107b12 <alltraps>

8010864b <vector141>:
.globl vector141
vector141:
  pushl $0
8010864b:	6a 00                	push   $0x0
  pushl $141
8010864d:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108652:	e9 bb f4 ff ff       	jmp    80107b12 <alltraps>

80108657 <vector142>:
.globl vector142
vector142:
  pushl $0
80108657:	6a 00                	push   $0x0
  pushl $142
80108659:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010865e:	e9 af f4 ff ff       	jmp    80107b12 <alltraps>

80108663 <vector143>:
.globl vector143
vector143:
  pushl $0
80108663:	6a 00                	push   $0x0
  pushl $143
80108665:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010866a:	e9 a3 f4 ff ff       	jmp    80107b12 <alltraps>

8010866f <vector144>:
.globl vector144
vector144:
  pushl $0
8010866f:	6a 00                	push   $0x0
  pushl $144
80108671:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108676:	e9 97 f4 ff ff       	jmp    80107b12 <alltraps>

8010867b <vector145>:
.globl vector145
vector145:
  pushl $0
8010867b:	6a 00                	push   $0x0
  pushl $145
8010867d:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108682:	e9 8b f4 ff ff       	jmp    80107b12 <alltraps>

80108687 <vector146>:
.globl vector146
vector146:
  pushl $0
80108687:	6a 00                	push   $0x0
  pushl $146
80108689:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010868e:	e9 7f f4 ff ff       	jmp    80107b12 <alltraps>

80108693 <vector147>:
.globl vector147
vector147:
  pushl $0
80108693:	6a 00                	push   $0x0
  pushl $147
80108695:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010869a:	e9 73 f4 ff ff       	jmp    80107b12 <alltraps>

8010869f <vector148>:
.globl vector148
vector148:
  pushl $0
8010869f:	6a 00                	push   $0x0
  pushl $148
801086a1:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801086a6:	e9 67 f4 ff ff       	jmp    80107b12 <alltraps>

801086ab <vector149>:
.globl vector149
vector149:
  pushl $0
801086ab:	6a 00                	push   $0x0
  pushl $149
801086ad:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801086b2:	e9 5b f4 ff ff       	jmp    80107b12 <alltraps>

801086b7 <vector150>:
.globl vector150
vector150:
  pushl $0
801086b7:	6a 00                	push   $0x0
  pushl $150
801086b9:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801086be:	e9 4f f4 ff ff       	jmp    80107b12 <alltraps>

801086c3 <vector151>:
.globl vector151
vector151:
  pushl $0
801086c3:	6a 00                	push   $0x0
  pushl $151
801086c5:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801086ca:	e9 43 f4 ff ff       	jmp    80107b12 <alltraps>

801086cf <vector152>:
.globl vector152
vector152:
  pushl $0
801086cf:	6a 00                	push   $0x0
  pushl $152
801086d1:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801086d6:	e9 37 f4 ff ff       	jmp    80107b12 <alltraps>

801086db <vector153>:
.globl vector153
vector153:
  pushl $0
801086db:	6a 00                	push   $0x0
  pushl $153
801086dd:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801086e2:	e9 2b f4 ff ff       	jmp    80107b12 <alltraps>

801086e7 <vector154>:
.globl vector154
vector154:
  pushl $0
801086e7:	6a 00                	push   $0x0
  pushl $154
801086e9:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801086ee:	e9 1f f4 ff ff       	jmp    80107b12 <alltraps>

801086f3 <vector155>:
.globl vector155
vector155:
  pushl $0
801086f3:	6a 00                	push   $0x0
  pushl $155
801086f5:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801086fa:	e9 13 f4 ff ff       	jmp    80107b12 <alltraps>

801086ff <vector156>:
.globl vector156
vector156:
  pushl $0
801086ff:	6a 00                	push   $0x0
  pushl $156
80108701:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108706:	e9 07 f4 ff ff       	jmp    80107b12 <alltraps>

8010870b <vector157>:
.globl vector157
vector157:
  pushl $0
8010870b:	6a 00                	push   $0x0
  pushl $157
8010870d:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108712:	e9 fb f3 ff ff       	jmp    80107b12 <alltraps>

80108717 <vector158>:
.globl vector158
vector158:
  pushl $0
80108717:	6a 00                	push   $0x0
  pushl $158
80108719:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010871e:	e9 ef f3 ff ff       	jmp    80107b12 <alltraps>

80108723 <vector159>:
.globl vector159
vector159:
  pushl $0
80108723:	6a 00                	push   $0x0
  pushl $159
80108725:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010872a:	e9 e3 f3 ff ff       	jmp    80107b12 <alltraps>

8010872f <vector160>:
.globl vector160
vector160:
  pushl $0
8010872f:	6a 00                	push   $0x0
  pushl $160
80108731:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108736:	e9 d7 f3 ff ff       	jmp    80107b12 <alltraps>

8010873b <vector161>:
.globl vector161
vector161:
  pushl $0
8010873b:	6a 00                	push   $0x0
  pushl $161
8010873d:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108742:	e9 cb f3 ff ff       	jmp    80107b12 <alltraps>

80108747 <vector162>:
.globl vector162
vector162:
  pushl $0
80108747:	6a 00                	push   $0x0
  pushl $162
80108749:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010874e:	e9 bf f3 ff ff       	jmp    80107b12 <alltraps>

80108753 <vector163>:
.globl vector163
vector163:
  pushl $0
80108753:	6a 00                	push   $0x0
  pushl $163
80108755:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010875a:	e9 b3 f3 ff ff       	jmp    80107b12 <alltraps>

8010875f <vector164>:
.globl vector164
vector164:
  pushl $0
8010875f:	6a 00                	push   $0x0
  pushl $164
80108761:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108766:	e9 a7 f3 ff ff       	jmp    80107b12 <alltraps>

8010876b <vector165>:
.globl vector165
vector165:
  pushl $0
8010876b:	6a 00                	push   $0x0
  pushl $165
8010876d:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108772:	e9 9b f3 ff ff       	jmp    80107b12 <alltraps>

80108777 <vector166>:
.globl vector166
vector166:
  pushl $0
80108777:	6a 00                	push   $0x0
  pushl $166
80108779:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010877e:	e9 8f f3 ff ff       	jmp    80107b12 <alltraps>

80108783 <vector167>:
.globl vector167
vector167:
  pushl $0
80108783:	6a 00                	push   $0x0
  pushl $167
80108785:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010878a:	e9 83 f3 ff ff       	jmp    80107b12 <alltraps>

8010878f <vector168>:
.globl vector168
vector168:
  pushl $0
8010878f:	6a 00                	push   $0x0
  pushl $168
80108791:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108796:	e9 77 f3 ff ff       	jmp    80107b12 <alltraps>

8010879b <vector169>:
.globl vector169
vector169:
  pushl $0
8010879b:	6a 00                	push   $0x0
  pushl $169
8010879d:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801087a2:	e9 6b f3 ff ff       	jmp    80107b12 <alltraps>

801087a7 <vector170>:
.globl vector170
vector170:
  pushl $0
801087a7:	6a 00                	push   $0x0
  pushl $170
801087a9:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801087ae:	e9 5f f3 ff ff       	jmp    80107b12 <alltraps>

801087b3 <vector171>:
.globl vector171
vector171:
  pushl $0
801087b3:	6a 00                	push   $0x0
  pushl $171
801087b5:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801087ba:	e9 53 f3 ff ff       	jmp    80107b12 <alltraps>

801087bf <vector172>:
.globl vector172
vector172:
  pushl $0
801087bf:	6a 00                	push   $0x0
  pushl $172
801087c1:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801087c6:	e9 47 f3 ff ff       	jmp    80107b12 <alltraps>

801087cb <vector173>:
.globl vector173
vector173:
  pushl $0
801087cb:	6a 00                	push   $0x0
  pushl $173
801087cd:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801087d2:	e9 3b f3 ff ff       	jmp    80107b12 <alltraps>

801087d7 <vector174>:
.globl vector174
vector174:
  pushl $0
801087d7:	6a 00                	push   $0x0
  pushl $174
801087d9:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801087de:	e9 2f f3 ff ff       	jmp    80107b12 <alltraps>

801087e3 <vector175>:
.globl vector175
vector175:
  pushl $0
801087e3:	6a 00                	push   $0x0
  pushl $175
801087e5:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801087ea:	e9 23 f3 ff ff       	jmp    80107b12 <alltraps>

801087ef <vector176>:
.globl vector176
vector176:
  pushl $0
801087ef:	6a 00                	push   $0x0
  pushl $176
801087f1:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801087f6:	e9 17 f3 ff ff       	jmp    80107b12 <alltraps>

801087fb <vector177>:
.globl vector177
vector177:
  pushl $0
801087fb:	6a 00                	push   $0x0
  pushl $177
801087fd:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108802:	e9 0b f3 ff ff       	jmp    80107b12 <alltraps>

80108807 <vector178>:
.globl vector178
vector178:
  pushl $0
80108807:	6a 00                	push   $0x0
  pushl $178
80108809:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010880e:	e9 ff f2 ff ff       	jmp    80107b12 <alltraps>

80108813 <vector179>:
.globl vector179
vector179:
  pushl $0
80108813:	6a 00                	push   $0x0
  pushl $179
80108815:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010881a:	e9 f3 f2 ff ff       	jmp    80107b12 <alltraps>

8010881f <vector180>:
.globl vector180
vector180:
  pushl $0
8010881f:	6a 00                	push   $0x0
  pushl $180
80108821:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108826:	e9 e7 f2 ff ff       	jmp    80107b12 <alltraps>

8010882b <vector181>:
.globl vector181
vector181:
  pushl $0
8010882b:	6a 00                	push   $0x0
  pushl $181
8010882d:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108832:	e9 db f2 ff ff       	jmp    80107b12 <alltraps>

80108837 <vector182>:
.globl vector182
vector182:
  pushl $0
80108837:	6a 00                	push   $0x0
  pushl $182
80108839:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010883e:	e9 cf f2 ff ff       	jmp    80107b12 <alltraps>

80108843 <vector183>:
.globl vector183
vector183:
  pushl $0
80108843:	6a 00                	push   $0x0
  pushl $183
80108845:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010884a:	e9 c3 f2 ff ff       	jmp    80107b12 <alltraps>

8010884f <vector184>:
.globl vector184
vector184:
  pushl $0
8010884f:	6a 00                	push   $0x0
  pushl $184
80108851:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108856:	e9 b7 f2 ff ff       	jmp    80107b12 <alltraps>

8010885b <vector185>:
.globl vector185
vector185:
  pushl $0
8010885b:	6a 00                	push   $0x0
  pushl $185
8010885d:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108862:	e9 ab f2 ff ff       	jmp    80107b12 <alltraps>

80108867 <vector186>:
.globl vector186
vector186:
  pushl $0
80108867:	6a 00                	push   $0x0
  pushl $186
80108869:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010886e:	e9 9f f2 ff ff       	jmp    80107b12 <alltraps>

80108873 <vector187>:
.globl vector187
vector187:
  pushl $0
80108873:	6a 00                	push   $0x0
  pushl $187
80108875:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010887a:	e9 93 f2 ff ff       	jmp    80107b12 <alltraps>

8010887f <vector188>:
.globl vector188
vector188:
  pushl $0
8010887f:	6a 00                	push   $0x0
  pushl $188
80108881:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108886:	e9 87 f2 ff ff       	jmp    80107b12 <alltraps>

8010888b <vector189>:
.globl vector189
vector189:
  pushl $0
8010888b:	6a 00                	push   $0x0
  pushl $189
8010888d:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108892:	e9 7b f2 ff ff       	jmp    80107b12 <alltraps>

80108897 <vector190>:
.globl vector190
vector190:
  pushl $0
80108897:	6a 00                	push   $0x0
  pushl $190
80108899:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010889e:	e9 6f f2 ff ff       	jmp    80107b12 <alltraps>

801088a3 <vector191>:
.globl vector191
vector191:
  pushl $0
801088a3:	6a 00                	push   $0x0
  pushl $191
801088a5:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801088aa:	e9 63 f2 ff ff       	jmp    80107b12 <alltraps>

801088af <vector192>:
.globl vector192
vector192:
  pushl $0
801088af:	6a 00                	push   $0x0
  pushl $192
801088b1:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801088b6:	e9 57 f2 ff ff       	jmp    80107b12 <alltraps>

801088bb <vector193>:
.globl vector193
vector193:
  pushl $0
801088bb:	6a 00                	push   $0x0
  pushl $193
801088bd:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801088c2:	e9 4b f2 ff ff       	jmp    80107b12 <alltraps>

801088c7 <vector194>:
.globl vector194
vector194:
  pushl $0
801088c7:	6a 00                	push   $0x0
  pushl $194
801088c9:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801088ce:	e9 3f f2 ff ff       	jmp    80107b12 <alltraps>

801088d3 <vector195>:
.globl vector195
vector195:
  pushl $0
801088d3:	6a 00                	push   $0x0
  pushl $195
801088d5:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801088da:	e9 33 f2 ff ff       	jmp    80107b12 <alltraps>

801088df <vector196>:
.globl vector196
vector196:
  pushl $0
801088df:	6a 00                	push   $0x0
  pushl $196
801088e1:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801088e6:	e9 27 f2 ff ff       	jmp    80107b12 <alltraps>

801088eb <vector197>:
.globl vector197
vector197:
  pushl $0
801088eb:	6a 00                	push   $0x0
  pushl $197
801088ed:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801088f2:	e9 1b f2 ff ff       	jmp    80107b12 <alltraps>

801088f7 <vector198>:
.globl vector198
vector198:
  pushl $0
801088f7:	6a 00                	push   $0x0
  pushl $198
801088f9:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801088fe:	e9 0f f2 ff ff       	jmp    80107b12 <alltraps>

80108903 <vector199>:
.globl vector199
vector199:
  pushl $0
80108903:	6a 00                	push   $0x0
  pushl $199
80108905:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010890a:	e9 03 f2 ff ff       	jmp    80107b12 <alltraps>

8010890f <vector200>:
.globl vector200
vector200:
  pushl $0
8010890f:	6a 00                	push   $0x0
  pushl $200
80108911:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108916:	e9 f7 f1 ff ff       	jmp    80107b12 <alltraps>

8010891b <vector201>:
.globl vector201
vector201:
  pushl $0
8010891b:	6a 00                	push   $0x0
  pushl $201
8010891d:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108922:	e9 eb f1 ff ff       	jmp    80107b12 <alltraps>

80108927 <vector202>:
.globl vector202
vector202:
  pushl $0
80108927:	6a 00                	push   $0x0
  pushl $202
80108929:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010892e:	e9 df f1 ff ff       	jmp    80107b12 <alltraps>

80108933 <vector203>:
.globl vector203
vector203:
  pushl $0
80108933:	6a 00                	push   $0x0
  pushl $203
80108935:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010893a:	e9 d3 f1 ff ff       	jmp    80107b12 <alltraps>

8010893f <vector204>:
.globl vector204
vector204:
  pushl $0
8010893f:	6a 00                	push   $0x0
  pushl $204
80108941:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108946:	e9 c7 f1 ff ff       	jmp    80107b12 <alltraps>

8010894b <vector205>:
.globl vector205
vector205:
  pushl $0
8010894b:	6a 00                	push   $0x0
  pushl $205
8010894d:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108952:	e9 bb f1 ff ff       	jmp    80107b12 <alltraps>

80108957 <vector206>:
.globl vector206
vector206:
  pushl $0
80108957:	6a 00                	push   $0x0
  pushl $206
80108959:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010895e:	e9 af f1 ff ff       	jmp    80107b12 <alltraps>

80108963 <vector207>:
.globl vector207
vector207:
  pushl $0
80108963:	6a 00                	push   $0x0
  pushl $207
80108965:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010896a:	e9 a3 f1 ff ff       	jmp    80107b12 <alltraps>

8010896f <vector208>:
.globl vector208
vector208:
  pushl $0
8010896f:	6a 00                	push   $0x0
  pushl $208
80108971:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108976:	e9 97 f1 ff ff       	jmp    80107b12 <alltraps>

8010897b <vector209>:
.globl vector209
vector209:
  pushl $0
8010897b:	6a 00                	push   $0x0
  pushl $209
8010897d:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108982:	e9 8b f1 ff ff       	jmp    80107b12 <alltraps>

80108987 <vector210>:
.globl vector210
vector210:
  pushl $0
80108987:	6a 00                	push   $0x0
  pushl $210
80108989:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010898e:	e9 7f f1 ff ff       	jmp    80107b12 <alltraps>

80108993 <vector211>:
.globl vector211
vector211:
  pushl $0
80108993:	6a 00                	push   $0x0
  pushl $211
80108995:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010899a:	e9 73 f1 ff ff       	jmp    80107b12 <alltraps>

8010899f <vector212>:
.globl vector212
vector212:
  pushl $0
8010899f:	6a 00                	push   $0x0
  pushl $212
801089a1:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801089a6:	e9 67 f1 ff ff       	jmp    80107b12 <alltraps>

801089ab <vector213>:
.globl vector213
vector213:
  pushl $0
801089ab:	6a 00                	push   $0x0
  pushl $213
801089ad:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801089b2:	e9 5b f1 ff ff       	jmp    80107b12 <alltraps>

801089b7 <vector214>:
.globl vector214
vector214:
  pushl $0
801089b7:	6a 00                	push   $0x0
  pushl $214
801089b9:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801089be:	e9 4f f1 ff ff       	jmp    80107b12 <alltraps>

801089c3 <vector215>:
.globl vector215
vector215:
  pushl $0
801089c3:	6a 00                	push   $0x0
  pushl $215
801089c5:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801089ca:	e9 43 f1 ff ff       	jmp    80107b12 <alltraps>

801089cf <vector216>:
.globl vector216
vector216:
  pushl $0
801089cf:	6a 00                	push   $0x0
  pushl $216
801089d1:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801089d6:	e9 37 f1 ff ff       	jmp    80107b12 <alltraps>

801089db <vector217>:
.globl vector217
vector217:
  pushl $0
801089db:	6a 00                	push   $0x0
  pushl $217
801089dd:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801089e2:	e9 2b f1 ff ff       	jmp    80107b12 <alltraps>

801089e7 <vector218>:
.globl vector218
vector218:
  pushl $0
801089e7:	6a 00                	push   $0x0
  pushl $218
801089e9:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801089ee:	e9 1f f1 ff ff       	jmp    80107b12 <alltraps>

801089f3 <vector219>:
.globl vector219
vector219:
  pushl $0
801089f3:	6a 00                	push   $0x0
  pushl $219
801089f5:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801089fa:	e9 13 f1 ff ff       	jmp    80107b12 <alltraps>

801089ff <vector220>:
.globl vector220
vector220:
  pushl $0
801089ff:	6a 00                	push   $0x0
  pushl $220
80108a01:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108a06:	e9 07 f1 ff ff       	jmp    80107b12 <alltraps>

80108a0b <vector221>:
.globl vector221
vector221:
  pushl $0
80108a0b:	6a 00                	push   $0x0
  pushl $221
80108a0d:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108a12:	e9 fb f0 ff ff       	jmp    80107b12 <alltraps>

80108a17 <vector222>:
.globl vector222
vector222:
  pushl $0
80108a17:	6a 00                	push   $0x0
  pushl $222
80108a19:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108a1e:	e9 ef f0 ff ff       	jmp    80107b12 <alltraps>

80108a23 <vector223>:
.globl vector223
vector223:
  pushl $0
80108a23:	6a 00                	push   $0x0
  pushl $223
80108a25:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108a2a:	e9 e3 f0 ff ff       	jmp    80107b12 <alltraps>

80108a2f <vector224>:
.globl vector224
vector224:
  pushl $0
80108a2f:	6a 00                	push   $0x0
  pushl $224
80108a31:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108a36:	e9 d7 f0 ff ff       	jmp    80107b12 <alltraps>

80108a3b <vector225>:
.globl vector225
vector225:
  pushl $0
80108a3b:	6a 00                	push   $0x0
  pushl $225
80108a3d:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108a42:	e9 cb f0 ff ff       	jmp    80107b12 <alltraps>

80108a47 <vector226>:
.globl vector226
vector226:
  pushl $0
80108a47:	6a 00                	push   $0x0
  pushl $226
80108a49:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108a4e:	e9 bf f0 ff ff       	jmp    80107b12 <alltraps>

80108a53 <vector227>:
.globl vector227
vector227:
  pushl $0
80108a53:	6a 00                	push   $0x0
  pushl $227
80108a55:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108a5a:	e9 b3 f0 ff ff       	jmp    80107b12 <alltraps>

80108a5f <vector228>:
.globl vector228
vector228:
  pushl $0
80108a5f:	6a 00                	push   $0x0
  pushl $228
80108a61:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108a66:	e9 a7 f0 ff ff       	jmp    80107b12 <alltraps>

80108a6b <vector229>:
.globl vector229
vector229:
  pushl $0
80108a6b:	6a 00                	push   $0x0
  pushl $229
80108a6d:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108a72:	e9 9b f0 ff ff       	jmp    80107b12 <alltraps>

80108a77 <vector230>:
.globl vector230
vector230:
  pushl $0
80108a77:	6a 00                	push   $0x0
  pushl $230
80108a79:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108a7e:	e9 8f f0 ff ff       	jmp    80107b12 <alltraps>

80108a83 <vector231>:
.globl vector231
vector231:
  pushl $0
80108a83:	6a 00                	push   $0x0
  pushl $231
80108a85:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108a8a:	e9 83 f0 ff ff       	jmp    80107b12 <alltraps>

80108a8f <vector232>:
.globl vector232
vector232:
  pushl $0
80108a8f:	6a 00                	push   $0x0
  pushl $232
80108a91:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108a96:	e9 77 f0 ff ff       	jmp    80107b12 <alltraps>

80108a9b <vector233>:
.globl vector233
vector233:
  pushl $0
80108a9b:	6a 00                	push   $0x0
  pushl $233
80108a9d:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108aa2:	e9 6b f0 ff ff       	jmp    80107b12 <alltraps>

80108aa7 <vector234>:
.globl vector234
vector234:
  pushl $0
80108aa7:	6a 00                	push   $0x0
  pushl $234
80108aa9:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108aae:	e9 5f f0 ff ff       	jmp    80107b12 <alltraps>

80108ab3 <vector235>:
.globl vector235
vector235:
  pushl $0
80108ab3:	6a 00                	push   $0x0
  pushl $235
80108ab5:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108aba:	e9 53 f0 ff ff       	jmp    80107b12 <alltraps>

80108abf <vector236>:
.globl vector236
vector236:
  pushl $0
80108abf:	6a 00                	push   $0x0
  pushl $236
80108ac1:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108ac6:	e9 47 f0 ff ff       	jmp    80107b12 <alltraps>

80108acb <vector237>:
.globl vector237
vector237:
  pushl $0
80108acb:	6a 00                	push   $0x0
  pushl $237
80108acd:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108ad2:	e9 3b f0 ff ff       	jmp    80107b12 <alltraps>

80108ad7 <vector238>:
.globl vector238
vector238:
  pushl $0
80108ad7:	6a 00                	push   $0x0
  pushl $238
80108ad9:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108ade:	e9 2f f0 ff ff       	jmp    80107b12 <alltraps>

80108ae3 <vector239>:
.globl vector239
vector239:
  pushl $0
80108ae3:	6a 00                	push   $0x0
  pushl $239
80108ae5:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108aea:	e9 23 f0 ff ff       	jmp    80107b12 <alltraps>

80108aef <vector240>:
.globl vector240
vector240:
  pushl $0
80108aef:	6a 00                	push   $0x0
  pushl $240
80108af1:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108af6:	e9 17 f0 ff ff       	jmp    80107b12 <alltraps>

80108afb <vector241>:
.globl vector241
vector241:
  pushl $0
80108afb:	6a 00                	push   $0x0
  pushl $241
80108afd:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108b02:	e9 0b f0 ff ff       	jmp    80107b12 <alltraps>

80108b07 <vector242>:
.globl vector242
vector242:
  pushl $0
80108b07:	6a 00                	push   $0x0
  pushl $242
80108b09:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108b0e:	e9 ff ef ff ff       	jmp    80107b12 <alltraps>

80108b13 <vector243>:
.globl vector243
vector243:
  pushl $0
80108b13:	6a 00                	push   $0x0
  pushl $243
80108b15:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108b1a:	e9 f3 ef ff ff       	jmp    80107b12 <alltraps>

80108b1f <vector244>:
.globl vector244
vector244:
  pushl $0
80108b1f:	6a 00                	push   $0x0
  pushl $244
80108b21:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108b26:	e9 e7 ef ff ff       	jmp    80107b12 <alltraps>

80108b2b <vector245>:
.globl vector245
vector245:
  pushl $0
80108b2b:	6a 00                	push   $0x0
  pushl $245
80108b2d:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108b32:	e9 db ef ff ff       	jmp    80107b12 <alltraps>

80108b37 <vector246>:
.globl vector246
vector246:
  pushl $0
80108b37:	6a 00                	push   $0x0
  pushl $246
80108b39:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108b3e:	e9 cf ef ff ff       	jmp    80107b12 <alltraps>

80108b43 <vector247>:
.globl vector247
vector247:
  pushl $0
80108b43:	6a 00                	push   $0x0
  pushl $247
80108b45:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108b4a:	e9 c3 ef ff ff       	jmp    80107b12 <alltraps>

80108b4f <vector248>:
.globl vector248
vector248:
  pushl $0
80108b4f:	6a 00                	push   $0x0
  pushl $248
80108b51:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108b56:	e9 b7 ef ff ff       	jmp    80107b12 <alltraps>

80108b5b <vector249>:
.globl vector249
vector249:
  pushl $0
80108b5b:	6a 00                	push   $0x0
  pushl $249
80108b5d:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108b62:	e9 ab ef ff ff       	jmp    80107b12 <alltraps>

80108b67 <vector250>:
.globl vector250
vector250:
  pushl $0
80108b67:	6a 00                	push   $0x0
  pushl $250
80108b69:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108b6e:	e9 9f ef ff ff       	jmp    80107b12 <alltraps>

80108b73 <vector251>:
.globl vector251
vector251:
  pushl $0
80108b73:	6a 00                	push   $0x0
  pushl $251
80108b75:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108b7a:	e9 93 ef ff ff       	jmp    80107b12 <alltraps>

80108b7f <vector252>:
.globl vector252
vector252:
  pushl $0
80108b7f:	6a 00                	push   $0x0
  pushl $252
80108b81:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108b86:	e9 87 ef ff ff       	jmp    80107b12 <alltraps>

80108b8b <vector253>:
.globl vector253
vector253:
  pushl $0
80108b8b:	6a 00                	push   $0x0
  pushl $253
80108b8d:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108b92:	e9 7b ef ff ff       	jmp    80107b12 <alltraps>

80108b97 <vector254>:
.globl vector254
vector254:
  pushl $0
80108b97:	6a 00                	push   $0x0
  pushl $254
80108b99:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108b9e:	e9 6f ef ff ff       	jmp    80107b12 <alltraps>

80108ba3 <vector255>:
.globl vector255
vector255:
  pushl $0
80108ba3:	6a 00                	push   $0x0
  pushl $255
80108ba5:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108baa:	e9 63 ef ff ff       	jmp    80107b12 <alltraps>

80108baf <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108baf:	55                   	push   %ebp
80108bb0:	89 e5                	mov    %esp,%ebp
80108bb2:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bb8:	83 e8 01             	sub    $0x1,%eax
80108bbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108bbf:	8b 45 08             	mov    0x8(%ebp),%eax
80108bc2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108bc6:	8b 45 08             	mov    0x8(%ebp),%eax
80108bc9:	c1 e8 10             	shr    $0x10,%eax
80108bcc:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108bd0:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108bd3:	0f 01 10             	lgdtl  (%eax)
}
80108bd6:	90                   	nop
80108bd7:	c9                   	leave  
80108bd8:	c3                   	ret    

80108bd9 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108bd9:	55                   	push   %ebp
80108bda:	89 e5                	mov    %esp,%ebp
80108bdc:	83 ec 04             	sub    $0x4,%esp
80108bdf:	8b 45 08             	mov    0x8(%ebp),%eax
80108be2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108be6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108bea:	0f 00 d8             	ltr    %ax
}
80108bed:	90                   	nop
80108bee:	c9                   	leave  
80108bef:	c3                   	ret    

80108bf0 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108bf0:	55                   	push   %ebp
80108bf1:	89 e5                	mov    %esp,%ebp
80108bf3:	83 ec 04             	sub    $0x4,%esp
80108bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80108bf9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108bfd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108c01:	8e e8                	mov    %eax,%gs
}
80108c03:	90                   	nop
80108c04:	c9                   	leave  
80108c05:	c3                   	ret    

80108c06 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108c06:	55                   	push   %ebp
80108c07:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108c09:	8b 45 08             	mov    0x8(%ebp),%eax
80108c0c:	0f 22 d8             	mov    %eax,%cr3
}
80108c0f:	90                   	nop
80108c10:	5d                   	pop    %ebp
80108c11:	c3                   	ret    

80108c12 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108c12:	55                   	push   %ebp
80108c13:	89 e5                	mov    %esp,%ebp
80108c15:	8b 45 08             	mov    0x8(%ebp),%eax
80108c18:	05 00 00 00 80       	add    $0x80000000,%eax
80108c1d:	5d                   	pop    %ebp
80108c1e:	c3                   	ret    

80108c1f <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108c1f:	55                   	push   %ebp
80108c20:	89 e5                	mov    %esp,%ebp
80108c22:	8b 45 08             	mov    0x8(%ebp),%eax
80108c25:	05 00 00 00 80       	add    $0x80000000,%eax
80108c2a:	5d                   	pop    %ebp
80108c2b:	c3                   	ret    

80108c2c <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108c2c:	55                   	push   %ebp
80108c2d:	89 e5                	mov    %esp,%ebp
80108c2f:	53                   	push   %ebx
80108c30:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108c33:	e8 3a a4 ff ff       	call   80103072 <cpunum>
80108c38:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108c3e:	05 80 43 11 80       	add    $0x80114380,%eax
80108c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c49:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c52:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c5b:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c62:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c66:	83 e2 f0             	and    $0xfffffff0,%edx
80108c69:	83 ca 0a             	or     $0xa,%edx
80108c6c:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c72:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c76:	83 ca 10             	or     $0x10,%edx
80108c79:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c7f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c83:	83 e2 9f             	and    $0xffffff9f,%edx
80108c86:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c8c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c90:	83 ca 80             	or     $0xffffff80,%edx
80108c93:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c99:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c9d:	83 ca 0f             	or     $0xf,%edx
80108ca0:	88 50 7e             	mov    %dl,0x7e(%eax)
80108ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ca6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108caa:	83 e2 ef             	and    $0xffffffef,%edx
80108cad:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cb7:	83 e2 df             	and    $0xffffffdf,%edx
80108cba:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cc4:	83 ca 40             	or     $0x40,%edx
80108cc7:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ccd:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cd1:	83 ca 80             	or     $0xffffff80,%edx
80108cd4:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cda:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce1:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108ce8:	ff ff 
80108cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ced:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108cf4:	00 00 
80108cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cf9:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d03:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d0a:	83 e2 f0             	and    $0xfffffff0,%edx
80108d0d:	83 ca 02             	or     $0x2,%edx
80108d10:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d19:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d20:	83 ca 10             	or     $0x10,%edx
80108d23:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d2c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d33:	83 e2 9f             	and    $0xffffff9f,%edx
80108d36:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d3f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d46:	83 ca 80             	or     $0xffffff80,%edx
80108d49:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d52:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d59:	83 ca 0f             	or     $0xf,%edx
80108d5c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d65:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d6c:	83 e2 ef             	and    $0xffffffef,%edx
80108d6f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d78:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d7f:	83 e2 df             	and    $0xffffffdf,%edx
80108d82:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d8b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d92:	83 ca 40             	or     $0x40,%edx
80108d95:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d9e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108da5:	83 ca 80             	or     $0xffffff80,%edx
80108da8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db1:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dbb:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108dc2:	ff ff 
80108dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dc7:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108dce:	00 00 
80108dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dd3:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ddd:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108de4:	83 e2 f0             	and    $0xfffffff0,%edx
80108de7:	83 ca 0a             	or     $0xa,%edx
80108dea:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108dfa:	83 ca 10             	or     $0x10,%edx
80108dfd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e06:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108e0d:	83 ca 60             	or     $0x60,%edx
80108e10:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e19:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108e20:	83 ca 80             	or     $0xffffff80,%edx
80108e23:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e2c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e33:	83 ca 0f             	or     $0xf,%edx
80108e36:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e3f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e46:	83 e2 ef             	and    $0xffffffef,%edx
80108e49:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e52:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e59:	83 e2 df             	and    $0xffffffdf,%edx
80108e5c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e65:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e6c:	83 ca 40             	or     $0x40,%edx
80108e6f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e78:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e7f:	83 ca 80             	or     $0xffffff80,%edx
80108e82:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e8b:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e95:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108e9c:	ff ff 
80108e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ea1:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108ea8:	00 00 
80108eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ead:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb7:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ebe:	83 e2 f0             	and    $0xfffffff0,%edx
80108ec1:	83 ca 02             	or     $0x2,%edx
80108ec4:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ecd:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ed4:	83 ca 10             	or     $0x10,%edx
80108ed7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ee0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ee7:	83 ca 60             	or     $0x60,%edx
80108eea:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ef3:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108efa:	83 ca 80             	or     $0xffffff80,%edx
80108efd:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f06:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f0d:	83 ca 0f             	or     $0xf,%edx
80108f10:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f19:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f20:	83 e2 ef             	and    $0xffffffef,%edx
80108f23:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f2c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f33:	83 e2 df             	and    $0xffffffdf,%edx
80108f36:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f3f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f46:	83 ca 40             	or     $0x40,%edx
80108f49:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f52:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f59:	83 ca 80             	or     $0xffffff80,%edx
80108f5c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f65:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f6f:	05 b4 00 00 00       	add    $0xb4,%eax
80108f74:	89 c3                	mov    %eax,%ebx
80108f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f79:	05 b4 00 00 00       	add    $0xb4,%eax
80108f7e:	c1 e8 10             	shr    $0x10,%eax
80108f81:	89 c2                	mov    %eax,%edx
80108f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f86:	05 b4 00 00 00       	add    $0xb4,%eax
80108f8b:	c1 e8 18             	shr    $0x18,%eax
80108f8e:	89 c1                	mov    %eax,%ecx
80108f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f93:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108f9a:	00 00 
80108f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f9f:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fa9:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fb2:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108fb9:	83 e2 f0             	and    $0xfffffff0,%edx
80108fbc:	83 ca 02             	or     $0x2,%edx
80108fbf:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc8:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108fcf:	83 ca 10             	or     $0x10,%edx
80108fd2:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fdb:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108fe2:	83 e2 9f             	and    $0xffffff9f,%edx
80108fe5:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fee:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108ff5:	83 ca 80             	or     $0xffffff80,%edx
80108ff8:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109001:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109008:	83 e2 f0             	and    $0xfffffff0,%edx
8010900b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109014:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010901b:	83 e2 ef             	and    $0xffffffef,%edx
8010901e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109024:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109027:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010902e:	83 e2 df             	and    $0xffffffdf,%edx
80109031:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010903a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109041:	83 ca 40             	or     $0x40,%edx
80109044:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010904a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010904d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109054:	83 ca 80             	or     $0xffffff80,%edx
80109057:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010905d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109060:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80109066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109069:	83 c0 70             	add    $0x70,%eax
8010906c:	83 ec 08             	sub    $0x8,%esp
8010906f:	6a 38                	push   $0x38
80109071:	50                   	push   %eax
80109072:	e8 38 fb ff ff       	call   80108baf <lgdt>
80109077:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010907a:	83 ec 0c             	sub    $0xc,%esp
8010907d:	6a 18                	push   $0x18
8010907f:	e8 6c fb ff ff       	call   80108bf0 <loadgs>
80109084:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80109087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010908a:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80109090:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109097:	00 00 00 00 
}
8010909b:	90                   	nop
8010909c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010909f:	c9                   	leave  
801090a0:	c3                   	ret    

801090a1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801090a1:	55                   	push   %ebp
801090a2:	89 e5                	mov    %esp,%ebp
801090a4:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801090a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801090aa:	c1 e8 16             	shr    $0x16,%eax
801090ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801090b4:	8b 45 08             	mov    0x8(%ebp),%eax
801090b7:	01 d0                	add    %edx,%eax
801090b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801090bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090bf:	8b 00                	mov    (%eax),%eax
801090c1:	83 e0 01             	and    $0x1,%eax
801090c4:	85 c0                	test   %eax,%eax
801090c6:	74 18                	je     801090e0 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801090c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090cb:	8b 00                	mov    (%eax),%eax
801090cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090d2:	50                   	push   %eax
801090d3:	e8 47 fb ff ff       	call   80108c1f <p2v>
801090d8:	83 c4 04             	add    $0x4,%esp
801090db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801090de:	eb 48                	jmp    80109128 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801090e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801090e4:	74 0e                	je     801090f4 <walkpgdir+0x53>
801090e6:	e8 21 9c ff ff       	call   80102d0c <kalloc>
801090eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801090ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801090f2:	75 07                	jne    801090fb <walkpgdir+0x5a>
      return 0;
801090f4:	b8 00 00 00 00       	mov    $0x0,%eax
801090f9:	eb 44                	jmp    8010913f <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801090fb:	83 ec 04             	sub    $0x4,%esp
801090fe:	68 00 10 00 00       	push   $0x1000
80109103:	6a 00                	push   $0x0
80109105:	ff 75 f4             	pushl  -0xc(%ebp)
80109108:	e8 65 d4 ff ff       	call   80106572 <memset>
8010910d:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80109110:	83 ec 0c             	sub    $0xc,%esp
80109113:	ff 75 f4             	pushl  -0xc(%ebp)
80109116:	e8 f7 fa ff ff       	call   80108c12 <v2p>
8010911b:	83 c4 10             	add    $0x10,%esp
8010911e:	83 c8 07             	or     $0x7,%eax
80109121:	89 c2                	mov    %eax,%edx
80109123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109126:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80109128:	8b 45 0c             	mov    0xc(%ebp),%eax
8010912b:	c1 e8 0c             	shr    $0xc,%eax
8010912e:	25 ff 03 00 00       	and    $0x3ff,%eax
80109133:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010913a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010913d:	01 d0                	add    %edx,%eax
}
8010913f:	c9                   	leave  
80109140:	c3                   	ret    

80109141 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80109141:	55                   	push   %ebp
80109142:	89 e5                	mov    %esp,%ebp
80109144:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80109147:	8b 45 0c             	mov    0xc(%ebp),%eax
8010914a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010914f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80109152:	8b 55 0c             	mov    0xc(%ebp),%edx
80109155:	8b 45 10             	mov    0x10(%ebp),%eax
80109158:	01 d0                	add    %edx,%eax
8010915a:	83 e8 01             	sub    $0x1,%eax
8010915d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109162:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80109165:	83 ec 04             	sub    $0x4,%esp
80109168:	6a 01                	push   $0x1
8010916a:	ff 75 f4             	pushl  -0xc(%ebp)
8010916d:	ff 75 08             	pushl  0x8(%ebp)
80109170:	e8 2c ff ff ff       	call   801090a1 <walkpgdir>
80109175:	83 c4 10             	add    $0x10,%esp
80109178:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010917b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010917f:	75 07                	jne    80109188 <mappages+0x47>
      return -1;
80109181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109186:	eb 47                	jmp    801091cf <mappages+0x8e>
    if(*pte & PTE_P)
80109188:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010918b:	8b 00                	mov    (%eax),%eax
8010918d:	83 e0 01             	and    $0x1,%eax
80109190:	85 c0                	test   %eax,%eax
80109192:	74 0d                	je     801091a1 <mappages+0x60>
      panic("remap");
80109194:	83 ec 0c             	sub    $0xc,%esp
80109197:	68 54 a2 10 80       	push   $0x8010a254
8010919c:	e8 c5 73 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
801091a1:	8b 45 18             	mov    0x18(%ebp),%eax
801091a4:	0b 45 14             	or     0x14(%ebp),%eax
801091a7:	83 c8 01             	or     $0x1,%eax
801091aa:	89 c2                	mov    %eax,%edx
801091ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801091af:	89 10                	mov    %edx,(%eax)
    if(a == last)
801091b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801091b7:	74 10                	je     801091c9 <mappages+0x88>
      break;
    a += PGSIZE;
801091b9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801091c0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801091c7:	eb 9c                	jmp    80109165 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801091c9:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801091ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
801091cf:	c9                   	leave  
801091d0:	c3                   	ret    

801091d1 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801091d1:	55                   	push   %ebp
801091d2:	89 e5                	mov    %esp,%ebp
801091d4:	53                   	push   %ebx
801091d5:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801091d8:	e8 2f 9b ff ff       	call   80102d0c <kalloc>
801091dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801091e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801091e4:	75 0a                	jne    801091f0 <setupkvm+0x1f>
    return 0;
801091e6:	b8 00 00 00 00       	mov    $0x0,%eax
801091eb:	e9 8e 00 00 00       	jmp    8010927e <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801091f0:	83 ec 04             	sub    $0x4,%esp
801091f3:	68 00 10 00 00       	push   $0x1000
801091f8:	6a 00                	push   $0x0
801091fa:	ff 75 f0             	pushl  -0x10(%ebp)
801091fd:	e8 70 d3 ff ff       	call   80106572 <memset>
80109202:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80109205:	83 ec 0c             	sub    $0xc,%esp
80109208:	68 00 00 00 0e       	push   $0xe000000
8010920d:	e8 0d fa ff ff       	call   80108c1f <p2v>
80109212:	83 c4 10             	add    $0x10,%esp
80109215:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010921a:	76 0d                	jbe    80109229 <setupkvm+0x58>
    panic("PHYSTOP too high");
8010921c:	83 ec 0c             	sub    $0xc,%esp
8010921f:	68 5a a2 10 80       	push   $0x8010a25a
80109224:	e8 3d 73 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109229:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
80109230:	eb 40                	jmp    80109272 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109232:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109235:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80109238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010923b:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010923e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109241:	8b 58 08             	mov    0x8(%eax),%ebx
80109244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109247:	8b 40 04             	mov    0x4(%eax),%eax
8010924a:	29 c3                	sub    %eax,%ebx
8010924c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010924f:	8b 00                	mov    (%eax),%eax
80109251:	83 ec 0c             	sub    $0xc,%esp
80109254:	51                   	push   %ecx
80109255:	52                   	push   %edx
80109256:	53                   	push   %ebx
80109257:	50                   	push   %eax
80109258:	ff 75 f0             	pushl  -0x10(%ebp)
8010925b:	e8 e1 fe ff ff       	call   80109141 <mappages>
80109260:	83 c4 20             	add    $0x20,%esp
80109263:	85 c0                	test   %eax,%eax
80109265:	79 07                	jns    8010926e <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109267:	b8 00 00 00 00       	mov    $0x0,%eax
8010926c:	eb 10                	jmp    8010927e <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010926e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80109272:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
80109279:	72 b7                	jb     80109232 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010927b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010927e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109281:	c9                   	leave  
80109282:	c3                   	ret    

80109283 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80109283:	55                   	push   %ebp
80109284:	89 e5                	mov    %esp,%ebp
80109286:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109289:	e8 43 ff ff ff       	call   801091d1 <setupkvm>
8010928e:	a3 38 79 11 80       	mov    %eax,0x80117938
  switchkvm();
80109293:	e8 03 00 00 00       	call   8010929b <switchkvm>
}
80109298:	90                   	nop
80109299:	c9                   	leave  
8010929a:	c3                   	ret    

8010929b <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010929b:	55                   	push   %ebp
8010929c:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010929e:	a1 38 79 11 80       	mov    0x80117938,%eax
801092a3:	50                   	push   %eax
801092a4:	e8 69 f9 ff ff       	call   80108c12 <v2p>
801092a9:	83 c4 04             	add    $0x4,%esp
801092ac:	50                   	push   %eax
801092ad:	e8 54 f9 ff ff       	call   80108c06 <lcr3>
801092b2:	83 c4 04             	add    $0x4,%esp
}
801092b5:	90                   	nop
801092b6:	c9                   	leave  
801092b7:	c3                   	ret    

801092b8 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801092b8:	55                   	push   %ebp
801092b9:	89 e5                	mov    %esp,%ebp
801092bb:	56                   	push   %esi
801092bc:	53                   	push   %ebx
  pushcli();
801092bd:	e8 aa d1 ff ff       	call   8010646c <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801092c2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801092c8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801092cf:	83 c2 08             	add    $0x8,%edx
801092d2:	89 d6                	mov    %edx,%esi
801092d4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801092db:	83 c2 08             	add    $0x8,%edx
801092de:	c1 ea 10             	shr    $0x10,%edx
801092e1:	89 d3                	mov    %edx,%ebx
801092e3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801092ea:	83 c2 08             	add    $0x8,%edx
801092ed:	c1 ea 18             	shr    $0x18,%edx
801092f0:	89 d1                	mov    %edx,%ecx
801092f2:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801092f9:	67 00 
801092fb:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80109302:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80109308:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010930f:	83 e2 f0             	and    $0xfffffff0,%edx
80109312:	83 ca 09             	or     $0x9,%edx
80109315:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010931b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109322:	83 ca 10             	or     $0x10,%edx
80109325:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010932b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109332:	83 e2 9f             	and    $0xffffff9f,%edx
80109335:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010933b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109342:	83 ca 80             	or     $0xffffff80,%edx
80109345:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010934b:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109352:	83 e2 f0             	and    $0xfffffff0,%edx
80109355:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010935b:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109362:	83 e2 ef             	and    $0xffffffef,%edx
80109365:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010936b:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109372:	83 e2 df             	and    $0xffffffdf,%edx
80109375:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010937b:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109382:	83 ca 40             	or     $0x40,%edx
80109385:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010938b:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109392:	83 e2 7f             	and    $0x7f,%edx
80109395:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010939b:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801093a1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801093a7:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801093ae:	83 e2 ef             	and    $0xffffffef,%edx
801093b1:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801093b7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801093bd:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801093c3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801093c9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801093d0:	8b 52 08             	mov    0x8(%edx),%edx
801093d3:	81 c2 00 10 00 00    	add    $0x1000,%edx
801093d9:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801093dc:	83 ec 0c             	sub    $0xc,%esp
801093df:	6a 30                	push   $0x30
801093e1:	e8 f3 f7 ff ff       	call   80108bd9 <ltr>
801093e6:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801093e9:	8b 45 08             	mov    0x8(%ebp),%eax
801093ec:	8b 40 04             	mov    0x4(%eax),%eax
801093ef:	85 c0                	test   %eax,%eax
801093f1:	75 0d                	jne    80109400 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801093f3:	83 ec 0c             	sub    $0xc,%esp
801093f6:	68 6b a2 10 80       	push   $0x8010a26b
801093fb:	e8 66 71 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109400:	8b 45 08             	mov    0x8(%ebp),%eax
80109403:	8b 40 04             	mov    0x4(%eax),%eax
80109406:	83 ec 0c             	sub    $0xc,%esp
80109409:	50                   	push   %eax
8010940a:	e8 03 f8 ff ff       	call   80108c12 <v2p>
8010940f:	83 c4 10             	add    $0x10,%esp
80109412:	83 ec 0c             	sub    $0xc,%esp
80109415:	50                   	push   %eax
80109416:	e8 eb f7 ff ff       	call   80108c06 <lcr3>
8010941b:	83 c4 10             	add    $0x10,%esp
  popcli();
8010941e:	e8 8e d0 ff ff       	call   801064b1 <popcli>
}
80109423:	90                   	nop
80109424:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109427:	5b                   	pop    %ebx
80109428:	5e                   	pop    %esi
80109429:	5d                   	pop    %ebp
8010942a:	c3                   	ret    

8010942b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010942b:	55                   	push   %ebp
8010942c:	89 e5                	mov    %esp,%ebp
8010942e:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80109431:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109438:	76 0d                	jbe    80109447 <inituvm+0x1c>
    panic("inituvm: more than a page");
8010943a:	83 ec 0c             	sub    $0xc,%esp
8010943d:	68 7f a2 10 80       	push   $0x8010a27f
80109442:	e8 1f 71 ff ff       	call   80100566 <panic>
  mem = kalloc();
80109447:	e8 c0 98 ff ff       	call   80102d0c <kalloc>
8010944c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010944f:	83 ec 04             	sub    $0x4,%esp
80109452:	68 00 10 00 00       	push   $0x1000
80109457:	6a 00                	push   $0x0
80109459:	ff 75 f4             	pushl  -0xc(%ebp)
8010945c:	e8 11 d1 ff ff       	call   80106572 <memset>
80109461:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109464:	83 ec 0c             	sub    $0xc,%esp
80109467:	ff 75 f4             	pushl  -0xc(%ebp)
8010946a:	e8 a3 f7 ff ff       	call   80108c12 <v2p>
8010946f:	83 c4 10             	add    $0x10,%esp
80109472:	83 ec 0c             	sub    $0xc,%esp
80109475:	6a 06                	push   $0x6
80109477:	50                   	push   %eax
80109478:	68 00 10 00 00       	push   $0x1000
8010947d:	6a 00                	push   $0x0
8010947f:	ff 75 08             	pushl  0x8(%ebp)
80109482:	e8 ba fc ff ff       	call   80109141 <mappages>
80109487:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010948a:	83 ec 04             	sub    $0x4,%esp
8010948d:	ff 75 10             	pushl  0x10(%ebp)
80109490:	ff 75 0c             	pushl  0xc(%ebp)
80109493:	ff 75 f4             	pushl  -0xc(%ebp)
80109496:	e8 96 d1 ff ff       	call   80106631 <memmove>
8010949b:	83 c4 10             	add    $0x10,%esp
}
8010949e:	90                   	nop
8010949f:	c9                   	leave  
801094a0:	c3                   	ret    

801094a1 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801094a1:	55                   	push   %ebp
801094a2:	89 e5                	mov    %esp,%ebp
801094a4:	53                   	push   %ebx
801094a5:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801094a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801094ab:	25 ff 0f 00 00       	and    $0xfff,%eax
801094b0:	85 c0                	test   %eax,%eax
801094b2:	74 0d                	je     801094c1 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801094b4:	83 ec 0c             	sub    $0xc,%esp
801094b7:	68 9c a2 10 80       	push   $0x8010a29c
801094bc:	e8 a5 70 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801094c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801094c8:	e9 95 00 00 00       	jmp    80109562 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801094cd:	8b 55 0c             	mov    0xc(%ebp),%edx
801094d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094d3:	01 d0                	add    %edx,%eax
801094d5:	83 ec 04             	sub    $0x4,%esp
801094d8:	6a 00                	push   $0x0
801094da:	50                   	push   %eax
801094db:	ff 75 08             	pushl  0x8(%ebp)
801094de:	e8 be fb ff ff       	call   801090a1 <walkpgdir>
801094e3:	83 c4 10             	add    $0x10,%esp
801094e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801094e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801094ed:	75 0d                	jne    801094fc <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801094ef:	83 ec 0c             	sub    $0xc,%esp
801094f2:	68 bf a2 10 80       	push   $0x8010a2bf
801094f7:	e8 6a 70 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801094fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801094ff:	8b 00                	mov    (%eax),%eax
80109501:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109506:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109509:	8b 45 18             	mov    0x18(%ebp),%eax
8010950c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010950f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109514:	77 0b                	ja     80109521 <loaduvm+0x80>
      n = sz - i;
80109516:	8b 45 18             	mov    0x18(%ebp),%eax
80109519:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010951c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010951f:	eb 07                	jmp    80109528 <loaduvm+0x87>
    else
      n = PGSIZE;
80109521:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109528:	8b 55 14             	mov    0x14(%ebp),%edx
8010952b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010952e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109531:	83 ec 0c             	sub    $0xc,%esp
80109534:	ff 75 e8             	pushl  -0x18(%ebp)
80109537:	e8 e3 f6 ff ff       	call   80108c1f <p2v>
8010953c:	83 c4 10             	add    $0x10,%esp
8010953f:	ff 75 f0             	pushl  -0x10(%ebp)
80109542:	53                   	push   %ebx
80109543:	50                   	push   %eax
80109544:	ff 75 10             	pushl  0x10(%ebp)
80109547:	e8 32 8a ff ff       	call   80101f7e <readi>
8010954c:	83 c4 10             	add    $0x10,%esp
8010954f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109552:	74 07                	je     8010955b <loaduvm+0xba>
      return -1;
80109554:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109559:	eb 18                	jmp    80109573 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010955b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109565:	3b 45 18             	cmp    0x18(%ebp),%eax
80109568:	0f 82 5f ff ff ff    	jb     801094cd <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010956e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109573:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109576:	c9                   	leave  
80109577:	c3                   	ret    

80109578 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109578:	55                   	push   %ebp
80109579:	89 e5                	mov    %esp,%ebp
8010957b:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010957e:	8b 45 10             	mov    0x10(%ebp),%eax
80109581:	85 c0                	test   %eax,%eax
80109583:	79 0a                	jns    8010958f <allocuvm+0x17>
    return 0;
80109585:	b8 00 00 00 00       	mov    $0x0,%eax
8010958a:	e9 b0 00 00 00       	jmp    8010963f <allocuvm+0xc7>
  if(newsz < oldsz)
8010958f:	8b 45 10             	mov    0x10(%ebp),%eax
80109592:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109595:	73 08                	jae    8010959f <allocuvm+0x27>
    return oldsz;
80109597:	8b 45 0c             	mov    0xc(%ebp),%eax
8010959a:	e9 a0 00 00 00       	jmp    8010963f <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
8010959f:	8b 45 0c             	mov    0xc(%ebp),%eax
801095a2:	05 ff 0f 00 00       	add    $0xfff,%eax
801095a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801095ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801095af:	eb 7f                	jmp    80109630 <allocuvm+0xb8>
    mem = kalloc();
801095b1:	e8 56 97 ff ff       	call   80102d0c <kalloc>
801095b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801095b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801095bd:	75 2b                	jne    801095ea <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801095bf:	83 ec 0c             	sub    $0xc,%esp
801095c2:	68 dd a2 10 80       	push   $0x8010a2dd
801095c7:	e8 fa 6d ff ff       	call   801003c6 <cprintf>
801095cc:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801095cf:	83 ec 04             	sub    $0x4,%esp
801095d2:	ff 75 0c             	pushl  0xc(%ebp)
801095d5:	ff 75 10             	pushl  0x10(%ebp)
801095d8:	ff 75 08             	pushl  0x8(%ebp)
801095db:	e8 61 00 00 00       	call   80109641 <deallocuvm>
801095e0:	83 c4 10             	add    $0x10,%esp
      return 0;
801095e3:	b8 00 00 00 00       	mov    $0x0,%eax
801095e8:	eb 55                	jmp    8010963f <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
801095ea:	83 ec 04             	sub    $0x4,%esp
801095ed:	68 00 10 00 00       	push   $0x1000
801095f2:	6a 00                	push   $0x0
801095f4:	ff 75 f0             	pushl  -0x10(%ebp)
801095f7:	e8 76 cf ff ff       	call   80106572 <memset>
801095fc:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801095ff:	83 ec 0c             	sub    $0xc,%esp
80109602:	ff 75 f0             	pushl  -0x10(%ebp)
80109605:	e8 08 f6 ff ff       	call   80108c12 <v2p>
8010960a:	83 c4 10             	add    $0x10,%esp
8010960d:	89 c2                	mov    %eax,%edx
8010960f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109612:	83 ec 0c             	sub    $0xc,%esp
80109615:	6a 06                	push   $0x6
80109617:	52                   	push   %edx
80109618:	68 00 10 00 00       	push   $0x1000
8010961d:	50                   	push   %eax
8010961e:	ff 75 08             	pushl  0x8(%ebp)
80109621:	e8 1b fb ff ff       	call   80109141 <mappages>
80109626:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109629:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109633:	3b 45 10             	cmp    0x10(%ebp),%eax
80109636:	0f 82 75 ff ff ff    	jb     801095b1 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010963c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010963f:	c9                   	leave  
80109640:	c3                   	ret    

80109641 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109641:	55                   	push   %ebp
80109642:	89 e5                	mov    %esp,%ebp
80109644:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109647:	8b 45 10             	mov    0x10(%ebp),%eax
8010964a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010964d:	72 08                	jb     80109657 <deallocuvm+0x16>
    return oldsz;
8010964f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109652:	e9 a5 00 00 00       	jmp    801096fc <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109657:	8b 45 10             	mov    0x10(%ebp),%eax
8010965a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010965f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109664:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109667:	e9 81 00 00 00       	jmp    801096ed <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010966c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010966f:	83 ec 04             	sub    $0x4,%esp
80109672:	6a 00                	push   $0x0
80109674:	50                   	push   %eax
80109675:	ff 75 08             	pushl  0x8(%ebp)
80109678:	e8 24 fa ff ff       	call   801090a1 <walkpgdir>
8010967d:	83 c4 10             	add    $0x10,%esp
80109680:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109683:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109687:	75 09                	jne    80109692 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109689:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109690:	eb 54                	jmp    801096e6 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109692:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109695:	8b 00                	mov    (%eax),%eax
80109697:	83 e0 01             	and    $0x1,%eax
8010969a:	85 c0                	test   %eax,%eax
8010969c:	74 48                	je     801096e6 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
8010969e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096a1:	8b 00                	mov    (%eax),%eax
801096a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801096ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801096af:	75 0d                	jne    801096be <deallocuvm+0x7d>
        panic("kfree");
801096b1:	83 ec 0c             	sub    $0xc,%esp
801096b4:	68 f5 a2 10 80       	push   $0x8010a2f5
801096b9:	e8 a8 6e ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
801096be:	83 ec 0c             	sub    $0xc,%esp
801096c1:	ff 75 ec             	pushl  -0x14(%ebp)
801096c4:	e8 56 f5 ff ff       	call   80108c1f <p2v>
801096c9:	83 c4 10             	add    $0x10,%esp
801096cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801096cf:	83 ec 0c             	sub    $0xc,%esp
801096d2:	ff 75 e8             	pushl  -0x18(%ebp)
801096d5:	e8 95 95 ff ff       	call   80102c6f <kfree>
801096da:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801096dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801096e6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801096ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801096f3:	0f 82 73 ff ff ff    	jb     8010966c <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801096f9:	8b 45 10             	mov    0x10(%ebp),%eax
}
801096fc:	c9                   	leave  
801096fd:	c3                   	ret    

801096fe <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801096fe:	55                   	push   %ebp
801096ff:	89 e5                	mov    %esp,%ebp
80109701:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109704:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109708:	75 0d                	jne    80109717 <freevm+0x19>
    panic("freevm: no pgdir");
8010970a:	83 ec 0c             	sub    $0xc,%esp
8010970d:	68 fb a2 10 80       	push   $0x8010a2fb
80109712:	e8 4f 6e ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109717:	83 ec 04             	sub    $0x4,%esp
8010971a:	6a 00                	push   $0x0
8010971c:	68 00 00 00 80       	push   $0x80000000
80109721:	ff 75 08             	pushl  0x8(%ebp)
80109724:	e8 18 ff ff ff       	call   80109641 <deallocuvm>
80109729:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010972c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109733:	eb 4f                	jmp    80109784 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109735:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109738:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010973f:	8b 45 08             	mov    0x8(%ebp),%eax
80109742:	01 d0                	add    %edx,%eax
80109744:	8b 00                	mov    (%eax),%eax
80109746:	83 e0 01             	and    $0x1,%eax
80109749:	85 c0                	test   %eax,%eax
8010974b:	74 33                	je     80109780 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010974d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109750:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109757:	8b 45 08             	mov    0x8(%ebp),%eax
8010975a:	01 d0                	add    %edx,%eax
8010975c:	8b 00                	mov    (%eax),%eax
8010975e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109763:	83 ec 0c             	sub    $0xc,%esp
80109766:	50                   	push   %eax
80109767:	e8 b3 f4 ff ff       	call   80108c1f <p2v>
8010976c:	83 c4 10             	add    $0x10,%esp
8010976f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109772:	83 ec 0c             	sub    $0xc,%esp
80109775:	ff 75 f0             	pushl  -0x10(%ebp)
80109778:	e8 f2 94 ff ff       	call   80102c6f <kfree>
8010977d:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109780:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109784:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010978b:	76 a8                	jbe    80109735 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010978d:	83 ec 0c             	sub    $0xc,%esp
80109790:	ff 75 08             	pushl  0x8(%ebp)
80109793:	e8 d7 94 ff ff       	call   80102c6f <kfree>
80109798:	83 c4 10             	add    $0x10,%esp
}
8010979b:	90                   	nop
8010979c:	c9                   	leave  
8010979d:	c3                   	ret    

8010979e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010979e:	55                   	push   %ebp
8010979f:	89 e5                	mov    %esp,%ebp
801097a1:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801097a4:	83 ec 04             	sub    $0x4,%esp
801097a7:	6a 00                	push   $0x0
801097a9:	ff 75 0c             	pushl  0xc(%ebp)
801097ac:	ff 75 08             	pushl  0x8(%ebp)
801097af:	e8 ed f8 ff ff       	call   801090a1 <walkpgdir>
801097b4:	83 c4 10             	add    $0x10,%esp
801097b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801097ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801097be:	75 0d                	jne    801097cd <clearpteu+0x2f>
    panic("clearpteu");
801097c0:	83 ec 0c             	sub    $0xc,%esp
801097c3:	68 0c a3 10 80       	push   $0x8010a30c
801097c8:	e8 99 6d ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801097cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097d0:	8b 00                	mov    (%eax),%eax
801097d2:	83 e0 fb             	and    $0xfffffffb,%eax
801097d5:	89 c2                	mov    %eax,%edx
801097d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097da:	89 10                	mov    %edx,(%eax)
}
801097dc:	90                   	nop
801097dd:	c9                   	leave  
801097de:	c3                   	ret    

801097df <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801097df:	55                   	push   %ebp
801097e0:	89 e5                	mov    %esp,%ebp
801097e2:	53                   	push   %ebx
801097e3:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801097e6:	e8 e6 f9 ff ff       	call   801091d1 <setupkvm>
801097eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801097ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801097f2:	75 0a                	jne    801097fe <copyuvm+0x1f>
    return 0;
801097f4:	b8 00 00 00 00       	mov    $0x0,%eax
801097f9:	e9 f8 00 00 00       	jmp    801098f6 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
801097fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109805:	e9 c4 00 00 00       	jmp    801098ce <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010980a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010980d:	83 ec 04             	sub    $0x4,%esp
80109810:	6a 00                	push   $0x0
80109812:	50                   	push   %eax
80109813:	ff 75 08             	pushl  0x8(%ebp)
80109816:	e8 86 f8 ff ff       	call   801090a1 <walkpgdir>
8010981b:	83 c4 10             	add    $0x10,%esp
8010981e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109821:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109825:	75 0d                	jne    80109834 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109827:	83 ec 0c             	sub    $0xc,%esp
8010982a:	68 16 a3 10 80       	push   $0x8010a316
8010982f:	e8 32 6d ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109834:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109837:	8b 00                	mov    (%eax),%eax
80109839:	83 e0 01             	and    $0x1,%eax
8010983c:	85 c0                	test   %eax,%eax
8010983e:	75 0d                	jne    8010984d <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109840:	83 ec 0c             	sub    $0xc,%esp
80109843:	68 30 a3 10 80       	push   $0x8010a330
80109848:	e8 19 6d ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010984d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109850:	8b 00                	mov    (%eax),%eax
80109852:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109857:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010985a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010985d:	8b 00                	mov    (%eax),%eax
8010985f:	25 ff 0f 00 00       	and    $0xfff,%eax
80109864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109867:	e8 a0 94 ff ff       	call   80102d0c <kalloc>
8010986c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010986f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109873:	74 6a                	je     801098df <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109875:	83 ec 0c             	sub    $0xc,%esp
80109878:	ff 75 e8             	pushl  -0x18(%ebp)
8010987b:	e8 9f f3 ff ff       	call   80108c1f <p2v>
80109880:	83 c4 10             	add    $0x10,%esp
80109883:	83 ec 04             	sub    $0x4,%esp
80109886:	68 00 10 00 00       	push   $0x1000
8010988b:	50                   	push   %eax
8010988c:	ff 75 e0             	pushl  -0x20(%ebp)
8010988f:	e8 9d cd ff ff       	call   80106631 <memmove>
80109894:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109897:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010989a:	83 ec 0c             	sub    $0xc,%esp
8010989d:	ff 75 e0             	pushl  -0x20(%ebp)
801098a0:	e8 6d f3 ff ff       	call   80108c12 <v2p>
801098a5:	83 c4 10             	add    $0x10,%esp
801098a8:	89 c2                	mov    %eax,%edx
801098aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098ad:	83 ec 0c             	sub    $0xc,%esp
801098b0:	53                   	push   %ebx
801098b1:	52                   	push   %edx
801098b2:	68 00 10 00 00       	push   $0x1000
801098b7:	50                   	push   %eax
801098b8:	ff 75 f0             	pushl  -0x10(%ebp)
801098bb:	e8 81 f8 ff ff       	call   80109141 <mappages>
801098c0:	83 c4 20             	add    $0x20,%esp
801098c3:	85 c0                	test   %eax,%eax
801098c5:	78 1b                	js     801098e2 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801098c7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801098ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801098d4:	0f 82 30 ff ff ff    	jb     8010980a <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801098da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098dd:	eb 17                	jmp    801098f6 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801098df:	90                   	nop
801098e0:	eb 01                	jmp    801098e3 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801098e2:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801098e3:	83 ec 0c             	sub    $0xc,%esp
801098e6:	ff 75 f0             	pushl  -0x10(%ebp)
801098e9:	e8 10 fe ff ff       	call   801096fe <freevm>
801098ee:	83 c4 10             	add    $0x10,%esp
  return 0;
801098f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801098f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801098f9:	c9                   	leave  
801098fa:	c3                   	ret    

801098fb <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801098fb:	55                   	push   %ebp
801098fc:	89 e5                	mov    %esp,%ebp
801098fe:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109901:	83 ec 04             	sub    $0x4,%esp
80109904:	6a 00                	push   $0x0
80109906:	ff 75 0c             	pushl  0xc(%ebp)
80109909:	ff 75 08             	pushl  0x8(%ebp)
8010990c:	e8 90 f7 ff ff       	call   801090a1 <walkpgdir>
80109911:	83 c4 10             	add    $0x10,%esp
80109914:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010991a:	8b 00                	mov    (%eax),%eax
8010991c:	83 e0 01             	and    $0x1,%eax
8010991f:	85 c0                	test   %eax,%eax
80109921:	75 07                	jne    8010992a <uva2ka+0x2f>
    return 0;
80109923:	b8 00 00 00 00       	mov    $0x0,%eax
80109928:	eb 29                	jmp    80109953 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
8010992a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010992d:	8b 00                	mov    (%eax),%eax
8010992f:	83 e0 04             	and    $0x4,%eax
80109932:	85 c0                	test   %eax,%eax
80109934:	75 07                	jne    8010993d <uva2ka+0x42>
    return 0;
80109936:	b8 00 00 00 00       	mov    $0x0,%eax
8010993b:	eb 16                	jmp    80109953 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010993d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109940:	8b 00                	mov    (%eax),%eax
80109942:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109947:	83 ec 0c             	sub    $0xc,%esp
8010994a:	50                   	push   %eax
8010994b:	e8 cf f2 ff ff       	call   80108c1f <p2v>
80109950:	83 c4 10             	add    $0x10,%esp
}
80109953:	c9                   	leave  
80109954:	c3                   	ret    

80109955 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109955:	55                   	push   %ebp
80109956:	89 e5                	mov    %esp,%ebp
80109958:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010995b:	8b 45 10             	mov    0x10(%ebp),%eax
8010995e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109961:	eb 7f                	jmp    801099e2 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109963:	8b 45 0c             	mov    0xc(%ebp),%eax
80109966:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010996b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010996e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109971:	83 ec 08             	sub    $0x8,%esp
80109974:	50                   	push   %eax
80109975:	ff 75 08             	pushl  0x8(%ebp)
80109978:	e8 7e ff ff ff       	call   801098fb <uva2ka>
8010997d:	83 c4 10             	add    $0x10,%esp
80109980:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109983:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109987:	75 07                	jne    80109990 <copyout+0x3b>
      return -1;
80109989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010998e:	eb 61                	jmp    801099f1 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109990:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109993:	2b 45 0c             	sub    0xc(%ebp),%eax
80109996:	05 00 10 00 00       	add    $0x1000,%eax
8010999b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010999e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099a1:	3b 45 14             	cmp    0x14(%ebp),%eax
801099a4:	76 06                	jbe    801099ac <copyout+0x57>
      n = len;
801099a6:	8b 45 14             	mov    0x14(%ebp),%eax
801099a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801099ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801099af:	2b 45 ec             	sub    -0x14(%ebp),%eax
801099b2:	89 c2                	mov    %eax,%edx
801099b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099b7:	01 d0                	add    %edx,%eax
801099b9:	83 ec 04             	sub    $0x4,%esp
801099bc:	ff 75 f0             	pushl  -0x10(%ebp)
801099bf:	ff 75 f4             	pushl  -0xc(%ebp)
801099c2:	50                   	push   %eax
801099c3:	e8 69 cc ff ff       	call   80106631 <memmove>
801099c8:	83 c4 10             	add    $0x10,%esp
    len -= n;
801099cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099ce:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801099d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099d4:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801099d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801099da:	05 00 10 00 00       	add    $0x1000,%eax
801099df:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801099e2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801099e6:	0f 85 77 ff ff ff    	jne    80109963 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801099ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801099f1:	c9                   	leave  
801099f2:	c3                   	ret    
