
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
8010003d:	68 f8 99 10 80       	push   $0x801099f8
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 a2 62 00 00       	call   801062ee <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
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

//PAGEBREAK!
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
801000c1:	e8 4a 62 00 00       	call   80106310 <acquire>
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
8010010c:	e8 66 62 00 00       	call   80106377 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 a1 52 00 00       	call   801053cd <sleep>
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
80100188:	e8 ea 61 00 00       	call   80106377 <release>
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
801001aa:	68 ff 99 10 80       	push   $0x801099ff
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
80100204:	68 10 9a 10 80       	push   $0x80109a10
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
80100243:	68 17 9a 10 80       	push   $0x80109a17
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 b6 60 00 00       	call   80106310 <acquire>
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
801002b9:	e8 6a 52 00 00       	call   80105528 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 a9 60 00 00       	call   80106377 <release>
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
//PAGEBREAK: 50

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
801003e2:	e8 29 5f 00 00       	call   80106310 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 1e 9a 10 80       	push   $0x80109a1e
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
801004cd:	c7 45 ec 27 9a 10 80 	movl   $0x80109a27,-0x14(%ebp)
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
8010055b:	e8 17 5e 00 00       	call   80106377 <release>
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
8010058b:	68 2e 9a 10 80       	push   $0x80109a2e
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
801005aa:	68 3d 9a 10 80       	push   $0x80109a3d
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 02 5e 00 00       	call   801063c9 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 3f 9a 10 80       	push   $0x80109a3f
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
801006ca:	68 43 9a 10 80       	push   $0x80109a43
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
801006f7:	e8 36 5f 00 00       	call   80106632 <memmove>
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
80100721:	e8 4d 5e 00 00       	call   80106573 <memset>
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
801007b6:	e8 c3 78 00 00       	call   8010807e <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 b6 78 00 00       	call   8010807e <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 a9 78 00 00       	call   8010807e <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 99 78 00 00       	call   8010807e <uartputc>
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
8010082a:	e8 e1 5a 00 00       	call   80106310 <acquire>
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
801009c8:	e8 5b 4b 00 00       	call   80105528 <wakeup>
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
801009eb:	e8 87 59 00 00       	call   80106377 <release>
801009f0:	83 c4 10             	add    $0x10,%esp
  if(doprocdump)
801009f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009f7:	74 07                	je     80100a00 <consoleintr+0x207>
    procdump();  // now call procdump() wo. cons.lock held
801009f9:	e8 2c 4c 00 00       	call   8010562a <procdump>
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
80100a06:	e8 68 4e 00 00       	call   80105873 <readydump>
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
80100a13:	e8 55 4f 00 00       	call   8010596d <freedump>
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
80100a20:	e8 ab 4f 00 00       	call   801059d0 <sleepdump>
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
80100a2d:	e8 46 50 00 00       	call   80105a78 <zombiedump>
    
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
80100a57:	e8 b4 58 00 00       	call   80106310 <acquire>
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
80100a79:	e8 f9 58 00 00       	call   80106377 <release>
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
80100aa6:	e8 22 49 00 00       	call   801053cd <sleep>
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
80100b24:	e8 4e 58 00 00       	call   80106377 <release>
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
80100b62:	e8 a9 57 00 00       	call   80106310 <acquire>
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
80100ba4:	e8 ce 57 00 00       	call   80106377 <release>
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
80100bc8:	68 56 9a 10 80       	push   $0x80109a56
80100bcd:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bd2:	e8 17 57 00 00       	call   801062ee <initlock>
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
80100c90:	e8 3e 85 00 00       	call   801091d3 <setupkvm>
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
80100d16:	e8 5f 88 00 00       	call   8010957a <allocuvm>
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
80100d49:	e8 55 87 00 00       	call   801094a3 <loaduvm>
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
80100db8:	e8 bd 87 00 00       	call   8010957a <allocuvm>
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
80100ddc:	e8 bf 89 00 00       	call   801097a0 <clearpteu>
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
80100e15:	e8 a6 59 00 00       	call   801067c0 <strlen>
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
80100e42:	e8 79 59 00 00       	call   801067c0 <strlen>
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
80100e68:	e8 ea 8a 00 00       	call   80109957 <copyout>
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
80100f04:	e8 4e 8a 00 00       	call   80109957 <copyout>
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
80100f55:	e8 1c 58 00 00       	call   80106776 <safestrcpy>
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
80100fab:	e8 0a 83 00 00       	call   801092ba <switchuvm>
80100fb0:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 75 d0             	pushl  -0x30(%ebp)
80100fb9:	e8 42 87 00 00       	call   80109700 <freevm>
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
80100ff3:	e8 08 87 00 00       	call   80109700 <freevm>
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
80101024:	68 5e 9a 10 80       	push   $0x80109a5e
80101029:	68 40 28 11 80       	push   $0x80112840
8010102e:	e8 bb 52 00 00       	call   801062ee <initlock>
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
80101047:	e8 c4 52 00 00       	call   80106310 <acquire>
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
80101074:	e8 fe 52 00 00       	call   80106377 <release>
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
80101097:	e8 db 52 00 00       	call   80106377 <release>
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
801010b4:	e8 57 52 00 00       	call   80106310 <acquire>
801010b9:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010bc:	8b 45 08             	mov    0x8(%ebp),%eax
801010bf:	8b 40 04             	mov    0x4(%eax),%eax
801010c2:	85 c0                	test   %eax,%eax
801010c4:	7f 0d                	jg     801010d3 <filedup+0x2d>
    panic("filedup");
801010c6:	83 ec 0c             	sub    $0xc,%esp
801010c9:	68 65 9a 10 80       	push   $0x80109a65
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
801010ea:	e8 88 52 00 00       	call   80106377 <release>
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
80101105:	e8 06 52 00 00       	call   80106310 <acquire>
8010110a:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010110d:	8b 45 08             	mov    0x8(%ebp),%eax
80101110:	8b 40 04             	mov    0x4(%eax),%eax
80101113:	85 c0                	test   %eax,%eax
80101115:	7f 0d                	jg     80101124 <fileclose+0x2d>
    panic("fileclose");
80101117:	83 ec 0c             	sub    $0xc,%esp
8010111a:	68 6d 9a 10 80       	push   $0x80109a6d
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
80101145:	e8 2d 52 00 00       	call   80106377 <release>
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
80101193:	e8 df 51 00 00       	call   80106377 <release>
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
801012e2:	68 77 9a 10 80       	push   $0x80109a77
801012e7:	e8 7a f2 ff ff       	call   80100566 <panic>
}
801012ec:	c9                   	leave  
801012ed:	c3                   	ret    

801012ee <filewrite>:

//PAGEBREAK!
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
801013e5:	68 80 9a 10 80       	push   $0x80109a80
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
8010141b:	68 90 9a 10 80       	push   $0x80109a90
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
80101453:	e8 da 51 00 00       	call   80106632 <memmove>
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
80101499:	e8 d5 50 00 00       	call   80106573 <memset>
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
80101600:	68 9c 9a 10 80       	push   $0x80109a9c
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
80101693:	68 b2 9a 10 80       	push   $0x80109ab2
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
801016f0:	68 c5 9a 10 80       	push   $0x80109ac5
801016f5:	68 60 32 11 80       	push   $0x80113260
801016fa:	e8 ef 4b 00 00       	call   801062ee <initlock>
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
80101749:	68 cc 9a 10 80       	push   $0x80109acc
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
//PAGEBREAK!
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
801017c2:	e8 ac 4d 00 00       	call   80106573 <memset>
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
8010182a:	68 1f 9b 10 80       	push   $0x80109b1f
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
801018d0:	e8 5d 4d 00 00       	call   80106632 <memmove>
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
80101905:	e8 06 4a 00 00       	call   80106310 <acquire>
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
80101953:	e8 1f 4a 00 00       	call   80106377 <release>
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
8010198c:	68 31 9b 10 80       	push   $0x80109b31
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
801019c9:	e8 a9 49 00 00       	call   80106377 <release>
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
801019e4:	e8 27 49 00 00       	call   80106310 <acquire>
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
80101a03:	e8 6f 49 00 00       	call   80106377 <release>
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
80101a29:	68 41 9b 10 80       	push   $0x80109b41
80101a2e:	e8 33 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a33:	83 ec 0c             	sub    $0xc,%esp
80101a36:	68 60 32 11 80       	push   $0x80113260
80101a3b:	e8 d0 48 00 00       	call   80106310 <acquire>
80101a40:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a43:	eb 13                	jmp    80101a58 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a45:	83 ec 08             	sub    $0x8,%esp
80101a48:	68 60 32 11 80       	push   $0x80113260
80101a4d:	ff 75 08             	pushl  0x8(%ebp)
80101a50:	e8 78 39 00 00       	call   801053cd <sleep>
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
80101a7e:	e8 f4 48 00 00       	call   80106377 <release>
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
80101b2b:	e8 02 4b 00 00       	call   80106632 <memmove>
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
80101b61:	68 47 9b 10 80       	push   $0x80109b47
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
80101b94:	68 56 9b 10 80       	push   $0x80109b56
80101b99:	e8 c8 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b9e:	83 ec 0c             	sub    $0xc,%esp
80101ba1:	68 60 32 11 80       	push   $0x80113260
80101ba6:	e8 65 47 00 00       	call   80106310 <acquire>
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
80101bc5:	e8 5e 39 00 00       	call   80105528 <wakeup>
80101bca:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bcd:	83 ec 0c             	sub    $0xc,%esp
80101bd0:	68 60 32 11 80       	push   $0x80113260
80101bd5:	e8 9d 47 00 00       	call   80106377 <release>
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
80101bee:	e8 1d 47 00 00       	call   80106310 <acquire>
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
80101c36:	68 5e 9b 10 80       	push   $0x80109b5e
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
80101c59:	e8 19 47 00 00       	call   80106377 <release>
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
80101c8e:	e8 7d 46 00 00       	call   80106310 <acquire>
80101c93:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c96:	8b 45 08             	mov    0x8(%ebp),%eax
80101c99:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ca0:	83 ec 0c             	sub    $0xc,%esp
80101ca3:	ff 75 08             	pushl  0x8(%ebp)
80101ca6:	e8 7d 38 00 00       	call   80105528 <wakeup>
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
80101cc5:	e8 ad 46 00 00       	call   80106377 <release>
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
80101e05:	68 68 9b 10 80       	push   $0x80109b68
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

//PAGEBREAK!
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
8010209c:	e8 91 45 00 00       	call   80106632 <memmove>
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

// PAGEBREAK!
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
801021ee:	e8 3f 44 00 00       	call   80106632 <memmove>
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
//PAGEBREAK!
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
8010226e:	e8 55 44 00 00       	call   801066c8 <strncmp>
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
8010228e:	68 7b 9b 10 80       	push   $0x80109b7b
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
801022bd:	68 8d 9b 10 80       	push   $0x80109b8d
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
80102392:	68 8d 9b 10 80       	push   $0x80109b8d
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
801023cd:	e8 4c 43 00 00       	call   8010671e <strncpy>
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
801023f9:	68 9a 9b 10 80       	push   $0x80109b9a
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
8010246f:	e8 be 41 00 00       	call   80106632 <memmove>
80102474:	83 c4 10             	add    $0x10,%esp
80102477:	eb 26                	jmp    8010249f <skipelem+0x95>
  else {
    memmove(name, s, len);
80102479:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010247c:	83 ec 04             	sub    $0x4,%esp
8010247f:	50                   	push   %eax
80102480:	ff 75 f4             	pushl  -0xc(%ebp)
80102483:	ff 75 0c             	pushl  0xc(%ebp)
80102486:	e8 a7 41 00 00       	call   80106632 <memmove>
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
801026db:	68 a2 9b 10 80       	push   $0x80109ba2
801026e0:	68 20 d6 10 80       	push   $0x8010d620
801026e5:	e8 04 3c 00 00       	call   801062ee <initlock>
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
8010278f:	68 a6 9b 10 80       	push   $0x80109ba6
80102794:	e8 cd dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102799:	8b 45 08             	mov    0x8(%ebp),%eax
8010279c:	8b 40 08             	mov    0x8(%eax),%eax
8010279f:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027a4:	76 0d                	jbe    801027b3 <idestart+0x33>
    panic("incorrect blockno");
801027a6:	83 ec 0c             	sub    $0xc,%esp
801027a9:	68 af 9b 10 80       	push   $0x80109baf
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
801027d2:	68 a6 9b 10 80       	push   $0x80109ba6
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
801028ec:	e8 1f 3a 00 00       	call   80106310 <acquire>
801028f1:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028f4:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801028f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102900:	75 15                	jne    80102917 <ideintr+0x39>
    release(&idelock);
80102902:	83 ec 0c             	sub    $0xc,%esp
80102905:	68 20 d6 10 80       	push   $0x8010d620
8010290a:	e8 68 3a 00 00       	call   80106377 <release>
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
8010297f:	e8 a4 2b 00 00       	call   80105528 <wakeup>
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
801029a9:	e8 c9 39 00 00       	call   80106377 <release>
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
801029c8:	68 c1 9b 10 80       	push   $0x80109bc1
801029cd:	e8 94 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029d2:	8b 45 08             	mov    0x8(%ebp),%eax
801029d5:	8b 00                	mov    (%eax),%eax
801029d7:	83 e0 06             	and    $0x6,%eax
801029da:	83 f8 02             	cmp    $0x2,%eax
801029dd:	75 0d                	jne    801029ec <iderw+0x39>
    panic("iderw: nothing to do");
801029df:	83 ec 0c             	sub    $0xc,%esp
801029e2:	68 d5 9b 10 80       	push   $0x80109bd5
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
80102a02:	68 ea 9b 10 80       	push   $0x80109bea
80102a07:	e8 5a db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a0c:	83 ec 0c             	sub    $0xc,%esp
80102a0f:	68 20 d6 10 80       	push   $0x8010d620
80102a14:	e8 f7 38 00 00       	call   80106310 <acquire>
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
80102a70:	e8 58 29 00 00       	call   801053cd <sleep>
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
80102a8d:	e8 e5 38 00 00       	call   80106377 <release>
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
80102b1e:	68 08 9c 10 80       	push   $0x80109c08
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
80102bde:	68 3a 9c 10 80       	push   $0x80109c3a
80102be3:	68 40 42 11 80       	push   $0x80114240
80102be8:	e8 01 37 00 00       	call   801062ee <initlock>
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
80102c9f:	68 3f 9c 10 80       	push   $0x80109c3f
80102ca4:	e8 bd d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ca9:	83 ec 04             	sub    $0x4,%esp
80102cac:	68 00 10 00 00       	push   $0x1000
80102cb1:	6a 01                	push   $0x1
80102cb3:	ff 75 08             	pushl  0x8(%ebp)
80102cb6:	e8 b8 38 00 00       	call   80106573 <memset>
80102cbb:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cbe:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cc3:	85 c0                	test   %eax,%eax
80102cc5:	74 10                	je     80102cd7 <kfree+0x68>
    acquire(&kmem.lock);
80102cc7:	83 ec 0c             	sub    $0xc,%esp
80102cca:	68 40 42 11 80       	push   $0x80114240
80102ccf:	e8 3c 36 00 00       	call   80106310 <acquire>
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
80102d01:	e8 71 36 00 00       	call   80106377 <release>
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
80102d23:	e8 e8 35 00 00       	call   80106310 <acquire>
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
80102d54:	e8 1e 36 00 00       	call   80106377 <release>
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
//PAGEBREAK!

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
8010309f:	68 48 9c 10 80       	push   $0x80109c48
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
801032ca:	e8 0b 33 00 00       	call   801065da <memcmp>
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
801033de:	68 74 9c 10 80       	push   $0x80109c74
801033e3:	68 80 42 11 80       	push   $0x80114280
801033e8:	e8 01 2f 00 00       	call   801062ee <initlock>
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
80103493:	e8 9a 31 00 00       	call   80106632 <memmove>
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
80103601:	e8 0a 2d 00 00       	call   80106310 <acquire>
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
8010361f:	e8 a9 1d 00 00       	call   801053cd <sleep>
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
80103654:	e8 74 1d 00 00       	call   801053cd <sleep>
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
80103673:	e8 ff 2c 00 00       	call   80106377 <release>
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
80103694:	e8 77 2c 00 00       	call   80106310 <acquire>
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
801036b5:	68 78 9c 10 80       	push   $0x80109c78
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
801036e3:	e8 40 1e 00 00       	call   80105528 <wakeup>
801036e8:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036eb:	83 ec 0c             	sub    $0xc,%esp
801036ee:	68 80 42 11 80       	push   $0x80114280
801036f3:	e8 7f 2c 00 00       	call   80106377 <release>
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
8010370e:	e8 fd 2b 00 00       	call   80106310 <acquire>
80103713:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103716:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
8010371d:	00 00 00 
    wakeup(&log);
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	68 80 42 11 80       	push   $0x80114280
80103728:	e8 fb 1d 00 00       	call   80105528 <wakeup>
8010372d:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	68 80 42 11 80       	push   $0x80114280
80103738:	e8 3a 2c 00 00       	call   80106377 <release>
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
801037b4:	e8 79 2e 00 00       	call   80106632 <memmove>
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
80103850:	68 87 9c 10 80       	push   $0x80109c87
80103855:	e8 0c cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010385a:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010385f:	85 c0                	test   %eax,%eax
80103861:	7f 0d                	jg     80103870 <log_write+0x45>
    panic("log_write outside of trans");
80103863:	83 ec 0c             	sub    $0xc,%esp
80103866:	68 9d 9c 10 80       	push   $0x80109c9d
8010386b:	e8 f6 cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
80103873:	68 80 42 11 80       	push   $0x80114280
80103878:	e8 93 2a 00 00       	call   80106310 <acquire>
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
801038f6:	e8 7c 2a 00 00       	call   80106377 <release>
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
8010395b:	e8 25 59 00 00       	call   80109285 <kvmalloc>
  mpinit();        // collect info about this machine
80103960:	e8 43 04 00 00       	call   80103da8 <mpinit>
  lapicinit();
80103965:	e8 ea f5 ff ff       	call   80102f54 <lapicinit>
  seginit();       // set up segments
8010396a:	e8 bf 52 00 00       	call   80108c2e <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010396f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103975:	0f b6 00             	movzbl (%eax),%eax
80103978:	0f b6 c0             	movzbl %al,%eax
8010397b:	83 ec 08             	sub    $0x8,%esp
8010397e:	50                   	push   %eax
8010397f:	68 b8 9c 10 80       	push   $0x80109cb8
80103984:	e8 3d ca ff ff       	call   801003c6 <cprintf>
80103989:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010398c:	e8 6d 06 00 00       	call   80103ffe <picinit>
  ioapicinit();    // another interrupt controller
80103991:	e8 34 f1 ff ff       	call   80102aca <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103996:	e8 24 d2 ff ff       	call   80100bbf <consoleinit>
  uartinit();      // serial port
8010399b:	e8 ea 45 00 00       	call   80107f8a <uartinit>
  pinit();         // process table
801039a0:	e8 5d 0b 00 00       	call   80104502 <pinit>
  tvinit();        // trap vectors
801039a5:	e8 dc 41 00 00       	call   80107b86 <tvinit>
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
801039c2:	e8 10 41 00 00       	call   80107ad7 <timerinit>
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
801039f1:	e8 a7 58 00 00       	call   8010929d <switchkvm>
  seginit();
801039f6:	e8 33 52 00 00       	call   80108c2e <seginit>
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
80103a1b:	68 cf 9c 10 80       	push   $0x80109ccf
80103a20:	e8 a1 c9 ff ff       	call   801003c6 <cprintf>
80103a25:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a28:	e8 ba 42 00 00       	call   80107ce7 <idtinit>
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
80103a73:	e8 ba 2b 00 00       	call   80106632 <memmove>
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
80103c01:	68 e0 9c 10 80       	push   $0x80109ce0
80103c06:	ff 75 f4             	pushl  -0xc(%ebp)
80103c09:	e8 cc 29 00 00       	call   801065da <memcmp>
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
80103d3f:	68 e5 9c 10 80       	push   $0x80109ce5
80103d44:	ff 75 f0             	pushl  -0x10(%ebp)
80103d47:	e8 8e 28 00 00       	call   801065da <memcmp>
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
80103e1b:	8b 04 85 28 9d 10 80 	mov    -0x7fef62d8(,%eax,4),%eax
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
80103e51:	68 ea 9c 10 80       	push   $0x80109cea
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
80103ee4:	68 08 9d 10 80       	push   $0x80109d08
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
80104185:	68 3c 9d 10 80       	push   $0x80109d3c
8010418a:	50                   	push   %eax
8010418b:	e8 5e 21 00 00       	call   801062ee <initlock>
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
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
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
80104247:	e8 c4 20 00 00       	call   80106310 <acquire>
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
8010426e:	e8 b5 12 00 00       	call   80105528 <wakeup>
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
80104291:	e8 92 12 00 00       	call   80105528 <wakeup>
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
801042ba:	e8 b8 20 00 00       	call   80106377 <release>
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
801042d9:	e8 99 20 00 00       	call   80106377 <release>
801042de:	83 c4 10             	add    $0x10,%esp
}
801042e1:	90                   	nop
801042e2:	c9                   	leave  
801042e3:	c3                   	ret    

801042e4 <pipewrite>:

//PAGEBREAK: 40
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
801042f1:	e8 1a 20 00 00       	call   80106310 <acquire>
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
80104326:	e8 4c 20 00 00       	call   80106377 <release>
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
80104344:	e8 df 11 00 00       	call   80105528 <wakeup>
80104349:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010434c:	8b 45 08             	mov    0x8(%ebp),%eax
8010434f:	8b 55 08             	mov    0x8(%ebp),%edx
80104352:	81 c2 38 02 00 00    	add    $0x238,%edx
80104358:	83 ec 08             	sub    $0x8,%esp
8010435b:	50                   	push   %eax
8010435c:	52                   	push   %edx
8010435d:	e8 6b 10 00 00       	call   801053cd <sleep>
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
801043c6:	e8 5d 11 00 00       	call   80105528 <wakeup>
801043cb:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043ce:	8b 45 08             	mov    0x8(%ebp),%eax
801043d1:	83 ec 0c             	sub    $0xc,%esp
801043d4:	50                   	push   %eax
801043d5:	e8 9d 1f 00 00       	call   80106377 <release>
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
801043f0:	e8 1b 1f 00 00       	call   80106310 <acquire>
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
8010440e:	e8 64 1f 00 00       	call   80106377 <release>
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
80104431:	e8 97 0f 00 00       	call   801053cd <sleep>
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
801044c5:	e8 5e 10 00 00       	call   80105528 <wakeup>
801044ca:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044cd:	8b 45 08             	mov    0x8(%ebp),%eax
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	50                   	push   %eax
801044d4:	e8 9e 1e 00 00       	call   80106377 <release>
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
8010450b:	68 44 9d 10 80       	push   $0x80109d44
80104510:	68 80 49 11 80       	push   $0x80114980
80104515:	e8 d4 1d 00 00       	call   801062ee <initlock>
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
8010452e:	e8 dd 1d 00 00       	call   80106310 <acquire>
80104533:	83 c4 10             	add    $0x10,%esp
  // get an unused proc
  p = getFromStateListHead(&ptable.pLists.free, UNUSED);
80104536:	83 ec 08             	sub    $0x8,%esp
80104539:	6a 00                	push   $0x0
8010453b:	68 c4 70 11 80       	push   $0x801170c4
80104540:	e8 cf 17 00 00       	call   80105d14 <getFromStateListHead>
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
80104559:	e8 19 1e 00 00       	call   80106377 <release>
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
8010457e:	68 d4 70 11 80       	push   $0x801170d4
80104583:	e8 d4 17 00 00       	call   80105d5c <addToStateListHead>
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
801045a9:	e8 c9 1d 00 00       	call   80106377 <release>
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
801045d0:	e8 3b 1d 00 00       	call   80106310 <acquire>
801045d5:	83 c4 10             	add    $0x10,%esp

    // if there was an error allocating space then put the proc back on the free list
    removeFromStateList(&ptable.pLists.embryo, EMBRYO, p);
801045d8:	83 ec 04             	sub    $0x4,%esp
801045db:	ff 75 f4             	pushl  -0xc(%ebp)
801045de:	6a 01                	push   $0x1
801045e0:	68 d4 70 11 80       	push   $0x801170d4
801045e5:	e8 a5 16 00 00       	call   80105c8f <removeFromStateList>
801045ea:	83 c4 10             	add    $0x10,%esp
    p->state = UNUSED;
801045ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    addToStateListHead(&ptable.pLists.free, UNUSED, p);
801045f7:	83 ec 04             	sub    $0x4,%esp
801045fa:	ff 75 f4             	pushl  -0xc(%ebp)
801045fd:	6a 00                	push   $0x0
801045ff:	68 c4 70 11 80       	push   $0x801170c4
80104604:	e8 53 17 00 00       	call   80105d5c <addToStateListHead>
80104609:	83 c4 10             	add    $0x10,%esp

    release(&ptable.lock);
8010460c:	83 ec 0c             	sub    $0xc,%esp
8010460f:	68 80 49 11 80       	push   $0x80114980
80104614:	e8 5e 1d 00 00       	call   80106377 <release>
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
80104645:	ba 34 7b 10 80       	mov    $0x80107b34,%edx
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
8010466a:	e8 04 1f 00 00       	call   80106573 <memset>
8010466f:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104675:	8b 40 1c             	mov    0x1c(%eax),%eax
80104678:	ba 87 53 10 80       	mov    $0x80105387,%edx
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

//PAGEBREAK: 32
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
801046d3:	e8 38 1c 00 00       	call   80106310 <acquire>
801046d8:	83 c4 10             	add    $0x10,%esp

  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; // init PromoteAtTime to first threshold. Added for Project 4: Periodic Priority Adjustment 
801046db:	a1 e0 78 11 80       	mov    0x801178e0,%eax
801046e0:	05 e8 03 00 00       	add    $0x3e8,%eax
801046e5:	a3 d8 70 11 80       	mov    %eax,0x801170d8

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
8010470a:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
8010470e:	7e e3                	jle    801046f3 <userinit+0x2e>
    ptable.pLists.ready[i] = 0;
  ptable.pLists.free = 0;
80104710:	c7 05 c4 70 11 80 00 	movl   $0x0,0x801170c4
80104717:	00 00 00 
  ptable.pLists.sleep = 0;
8010471a:	c7 05 c8 70 11 80 00 	movl   $0x0,0x801170c8
80104721:	00 00 00 
  ptable.pLists.zombie = 0;
80104724:	c7 05 cc 70 11 80 00 	movl   $0x0,0x801170cc
8010472b:	00 00 00 
  ptable.pLists.running = 0;
8010472e:	c7 05 d0 70 11 80 00 	movl   $0x0,0x801170d0
80104735:	00 00 00 
  ptable.pLists.embryo = 0;
80104738:	c7 05 d4 70 11 80 00 	movl   $0x0,0x801170d4
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
80104765:	68 c4 70 11 80       	push   $0x801170c4
8010476a:	e8 ed 15 00 00       	call   80105d5c <addToStateListHead>
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
80104784:	e8 ee 1b 00 00       	call   80106377 <release>
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
8010479c:	e8 32 4a 00 00       	call   801091d3 <setupkvm>
801047a1:	89 c2                	mov    %eax,%edx
801047a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047a6:	89 50 04             	mov    %edx,0x4(%eax)
801047a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ac:	8b 40 04             	mov    0x4(%eax),%eax
801047af:	85 c0                	test   %eax,%eax
801047b1:	75 0d                	jne    801047c0 <userinit+0xfb>
    panic("userinit: out of memory?");
801047b3:	83 ec 0c             	sub    $0xc,%esp
801047b6:	68 4b 9d 10 80       	push   $0x80109d4b
801047bb:	e8 a6 bd ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047c0:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047c8:	8b 40 04             	mov    0x4(%eax),%eax
801047cb:	83 ec 04             	sub    $0x4,%esp
801047ce:	52                   	push   %edx
801047cf:	68 00 d5 10 80       	push   $0x8010d500
801047d4:	50                   	push   %eax
801047d5:	e8 53 4c 00 00       	call   8010942d <inituvm>
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
801047f4:	e8 7a 1d 00 00       	call   80106573 <memset>
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
80104888:	68 64 9d 10 80       	push   $0x80109d64
8010488d:	50                   	push   %eax
8010488e:	e8 e3 1e 00 00       	call   80106776 <safestrcpy>
80104893:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104896:	83 ec 0c             	sub    $0xc,%esp
80104899:	68 6d 9d 10 80       	push   $0x80109d6d
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
801048b6:	e8 55 1a 00 00       	call   80106310 <acquire>
801048bb:	83 c4 10             	add    $0x10,%esp

  // remove p proc from embryo and add to ready
  removeFromStateList(&ptable.pLists.embryo, EMBRYO, p);
801048be:	83 ec 04             	sub    $0x4,%esp
801048c1:	ff 75 ec             	pushl  -0x14(%ebp)
801048c4:	6a 01                	push   $0x1
801048c6:	68 d4 70 11 80       	push   $0x801170d4
801048cb:	e8 bf 13 00 00       	call   80105c8f <removeFromStateList>
801048d0:	83 c4 10             	add    $0x10,%esp
  p->state = RUNNABLE;
801048d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048d6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  addToStateListHead(&ptable.pLists.ready[0], RUNNABLE, p); // added to head of ready since nothing else is there. Modified for Project 4: Periodic Priority Adjustment
801048dd:	83 ec 04             	sub    $0x4,%esp
801048e0:	ff 75 ec             	pushl  -0x14(%ebp)
801048e3:	6a 03                	push   $0x3
801048e5:	68 b4 70 11 80       	push   $0x801170b4
801048ea:	e8 6d 14 00 00       	call   80105d5c <addToStateListHead>
801048ef:	83 c4 10             	add    $0x10,%esp

  release(&ptable.lock);
801048f2:	83 ec 0c             	sub    $0xc,%esp
801048f5:	68 80 49 11 80       	push   $0x80114980
801048fa:	e8 78 1a 00 00       	call   80106377 <release>
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
80104935:	e8 40 4c 00 00       	call   8010957a <allocuvm>
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
8010496c:	e8 d2 4c 00 00       	call   80109643 <deallocuvm>
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
80104999:	e8 1c 49 00 00       	call   801092ba <switchuvm>
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
801049df:	e8 fd 4d 00 00       	call   801097e1 <copyuvm>
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
80104a1d:	e8 ee 18 00 00       	call   80106310 <acquire>
80104a22:	83 c4 10             	add    $0x10,%esp

    // if copyuvm failed then put np back in the free list from embryo
    removeFromStateList(&ptable.pLists.embryo, EMBRYO, np);
80104a25:	83 ec 04             	sub    $0x4,%esp
80104a28:	ff 75 e0             	pushl  -0x20(%ebp)
80104a2b:	6a 01                	push   $0x1
80104a2d:	68 d4 70 11 80       	push   $0x801170d4
80104a32:	e8 58 12 00 00       	call   80105c8f <removeFromStateList>
80104a37:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    addToStateListHead(&ptable.pLists.free, UNUSED, np);
80104a44:	83 ec 04             	sub    $0x4,%esp
80104a47:	ff 75 e0             	pushl  -0x20(%ebp)
80104a4a:	6a 00                	push   $0x0
80104a4c:	68 c4 70 11 80       	push   $0x801170c4
80104a51:	e8 06 13 00 00       	call   80105d5c <addToStateListHead>
80104a56:	83 c4 10             	add    $0x10,%esp

    release(&ptable.lock);
80104a59:	83 ec 0c             	sub    $0xc,%esp
80104a5c:	68 80 49 11 80       	push   $0x80114980
80104a61:	e8 11 19 00 00       	call   80106377 <release>
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
80104b67:	e8 0a 1c 00 00       	call   80106776 <safestrcpy>
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
80104b80:	e8 8b 17 00 00       	call   80106310 <acquire>
80104b85:	83 c4 10             	add    $0x10,%esp

  // move np proc from embryo to ready
  removeFromStateList(&ptable.pLists.embryo, EMBRYO, np);
80104b88:	83 ec 04             	sub    $0x4,%esp
80104b8b:	ff 75 e0             	pushl  -0x20(%ebp)
80104b8e:	6a 01                	push   $0x1
80104b90:	68 d4 70 11 80       	push   $0x801170d4
80104b95:	e8 f5 10 00 00       	call   80105c8f <removeFromStateList>
80104b9a:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104b9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ba0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  addToStateListTail(&ptable.pLists.ready[0], RUNNABLE, np); // Modified for Project 4: Periodic Priority Adjustment
80104ba7:	83 ec 04             	sub    $0x4,%esp
80104baa:	ff 75 e0             	pushl  -0x20(%ebp)
80104bad:	6a 03                	push   $0x3
80104baf:	68 b4 70 11 80       	push   $0x801170b4
80104bb4:	e8 da 11 00 00       	call   80105d93 <addToStateListTail>
80104bb9:	83 c4 10             	add    $0x10,%esp

  release(&ptable.lock);
80104bbc:	83 ec 0c             	sub    $0xc,%esp
80104bbf:	68 80 49 11 80       	push   $0x80114980
80104bc4:	e8 ae 17 00 00       	call   80106377 <release>
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
80104bfe:	68 6f 9d 10 80       	push   $0x80109d6f
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
80104c93:	e8 78 16 00 00       	call   80106310 <acquire>
80104c98:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104c9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca1:	8b 40 14             	mov    0x14(%eax),%eax
80104ca4:	83 ec 0c             	sub    $0xc,%esp
80104ca7:	50                   	push   %eax
80104ca8:	e8 f7 07 00 00       	call   801054a4 <wakeup1>
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
80104d02:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
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
80104d0e:	a1 c8 70 11 80       	mov    0x801170c8,%eax
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
80104d4f:	a1 cc 70 11 80       	mov    0x801170cc,%eax
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
80104d90:	a1 d0 70 11 80       	mov    0x801170d0,%eax
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
80104dd1:	a1 d4 70 11 80       	mov    0x801170d4,%eax
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
80104e48:	e8 57 06 00 00       	call   801054a4 <wakeup1>
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
80104e5c:	68 d0 70 11 80       	push   $0x801170d0
80104e61:	e8 29 0e 00 00       	call   80105c8f <removeFromStateList>
80104e66:	83 c4 10             	add    $0x10,%esp
  proc->state = ZOMBIE;
80104e69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e6f:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  addToStateListHead(&ptable.pLists.zombie, ZOMBIE, proc);
80104e76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7c:	83 ec 04             	sub    $0x4,%esp
80104e7f:	50                   	push   %eax
80104e80:	6a 05                	push   $0x5
80104e82:	68 cc 70 11 80       	push   $0x801170cc
80104e87:	e8 d0 0e 00 00       	call   80105d5c <addToStateListHead>
80104e8c:	83 c4 10             	add    $0x10,%esp
  // END: Added for Project 3: List Management

  sched();
80104e8f:	e8 99 02 00 00       	call   8010512d <sched>
  panic("zombie exit");
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	68 7c 9d 10 80       	push   $0x80109d7c
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
80104eb6:	e8 55 14 00 00       	call   80106310 <acquire>
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
80104f2a:	e8 d1 47 00 00       	call   80109700 <freevm>
80104f2f:	83 c4 10             	add    $0x10,%esp

        // START: Added for Project 3: List Management
        
        // Move proc p from zombie to free
        removeFromStateList(&ptable.pLists.zombie, ZOMBIE, p);
80104f32:	83 ec 04             	sub    $0x4,%esp
80104f35:	ff 75 f4             	pushl  -0xc(%ebp)
80104f38:	6a 05                	push   $0x5
80104f3a:	68 cc 70 11 80       	push   $0x801170cc
80104f3f:	e8 4b 0d 00 00       	call   80105c8f <removeFromStateList>
80104f44:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        addToStateListHead(&ptable.pLists.free, UNUSED, p);
80104f51:	83 ec 04             	sub    $0x4,%esp
80104f54:	ff 75 f4             	pushl  -0xc(%ebp)
80104f57:	6a 00                	push   $0x0
80104f59:	68 c4 70 11 80       	push   $0x801170c4
80104f5e:	e8 f9 0d 00 00       	call   80105d5c <addToStateListHead>
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
80104f93:	e8 df 13 00 00       	call   80106377 <release>
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
80104fd0:	e8 a2 13 00 00       	call   80106377 <release>
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
80104fee:	e8 da 03 00 00       	call   801053cd <sleep>
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
80105017:	e8 f4 12 00 00       	call   80106310 <acquire>
8010501c:	83 c4 10             	add    $0x10,%esp

    // START: Added for Project 4: Periodic Priority Adjustment
    if (ticks >= ptable.PromoteAtTime){ // Check if we hit PromoteAtTime threshold
8010501f:	8b 15 d8 70 11 80    	mov    0x801170d8,%edx
80105025:	a1 e0 78 11 80       	mov    0x801178e0,%eax
8010502a:	39 c2                	cmp    %eax,%edx
8010502c:	77 14                	ja     80105042 <scheduler+0x45>
      doPeriodicPromotion(); // do periodic promotion of all process on ready, sleeping, and running lists
8010502e:	e8 6b 11 00 00       	call   8010619e <doPeriodicPromotion>
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; // update PromoteAtTime threshold after we've done the promotions
80105033:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80105038:	05 e8 03 00 00       	add    $0x3e8,%eax
8010503d:	a3 d8 70 11 80       	mov    %eax,0x801170d8
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
80105067:	e8 a8 0c 00 00       	call   80105d14 <getFromStateListHead>
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
8010508e:	e8 27 42 00 00       	call   801092ba <switchuvm>
80105093:	83 c4 10             	add    $0x10,%esp
      
        // switch proc p from ready to running list
        p->state = RUNNING;
80105096:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105099:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
        addToStateListHead(&ptable.pLists.running, RUNNING, p);
801050a0:	83 ec 04             	sub    $0x4,%esp
801050a3:	ff 75 ec             	pushl  -0x14(%ebp)
801050a6:	6a 04                	push   $0x4
801050a8:	68 d0 70 11 80       	push   $0x801170d0
801050ad:	e8 aa 0c 00 00       	call   80105d5c <addToStateListHead>
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
801050dc:	e8 06 17 00 00       	call   801067e7 <swtch>
801050e1:	83 c4 10             	add    $0x10,%esp
        switchkvm();
801050e4:	e8 b4 41 00 00       	call   8010929d <switchkvm>

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
801050fa:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
801050fe:	0f 8e 4a ff ff ff    	jle    8010504e <scheduler+0x51>
        proc = 0;
        
        break; // break out of for loop now that we've found a proc. Added for Project 4: Periodic Priority Adjustment
      }
    }
    release(&ptable.lock);
80105104:	83 ec 0c             	sub    $0xc,%esp
80105107:	68 80 49 11 80       	push   $0x80114980
8010510c:	e8 66 12 00 00       	call   80106377 <release>
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
8010513c:	e8 02 13 00 00       	call   80106443 <holding>
80105141:	83 c4 10             	add    $0x10,%esp
80105144:	85 c0                	test   %eax,%eax
80105146:	75 0d                	jne    80105155 <sched+0x28>
    panic("sched ptable.lock");
80105148:	83 ec 0c             	sub    $0xc,%esp
8010514b:	68 88 9d 10 80       	push   $0x80109d88
80105150:	e8 11 b4 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80105155:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010515b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105161:	83 f8 01             	cmp    $0x1,%eax
80105164:	74 0d                	je     80105173 <sched+0x46>
    panic("sched locks");
80105166:	83 ec 0c             	sub    $0xc,%esp
80105169:	68 9a 9d 10 80       	push   $0x80109d9a
8010516e:	e8 f3 b3 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80105173:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105179:	8b 40 0c             	mov    0xc(%eax),%eax
8010517c:	83 f8 04             	cmp    $0x4,%eax
8010517f:	75 0d                	jne    8010518e <sched+0x61>
    panic("sched running");
80105181:	83 ec 0c             	sub    $0xc,%esp
80105184:	68 a6 9d 10 80       	push   $0x80109da6
80105189:	e8 d8 b3 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
8010518e:	e8 58 f3 ff ff       	call   801044eb <readeflags>
80105193:	25 00 02 00 00       	and    $0x200,%eax
80105198:	85 c0                	test   %eax,%eax
8010519a:	74 0d                	je     801051a9 <sched+0x7c>
    panic("sched interruptible");
8010519c:	83 ec 0c             	sub    $0xc,%esp
8010519f:	68 b4 9d 10 80       	push   $0x80109db4
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
8010522c:	0f 8f b3 00 00 00    	jg     801052e5 <sched+0x1b8>
80105232:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105238:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010523e:	83 f8 03             	cmp    $0x3,%eax
80105241:	0f 84 9e 00 00 00    	je     801052e5 <sched+0x1b8>
 
    // if proc is in a ready list then we need to switch its list to the lower priority one
    if (proc->state == RUNNABLE){
80105247:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010524d:	8b 40 0c             	mov    0xc(%eax),%eax
80105250:	83 f8 03             	cmp    $0x3,%eax
80105253:	75 6b                	jne    801052c0 <sched+0x193>
      removeFromStateList(&ptable.pLists.ready[proc->priority], RUNNABLE, proc);
80105255:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010525b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105262:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105268:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
8010526e:	c1 e2 02             	shl    $0x2,%edx
80105271:	81 c2 80 49 11 80    	add    $0x80114980,%edx
80105277:	83 c2 04             	add    $0x4,%edx
8010527a:	83 ec 04             	sub    $0x4,%esp
8010527d:	50                   	push   %eax
8010527e:	6a 03                	push   $0x3
80105280:	52                   	push   %edx
80105281:	e8 09 0a 00 00       	call   80105c8f <removeFromStateList>
80105286:	83 c4 10             	add    $0x10,%esp
      addToStateListTail(&ptable.pLists.ready[proc->priority + 1], RUNNABLE, proc);
80105289:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010528f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105296:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
8010529c:	83 c2 01             	add    $0x1,%edx
8010529f:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
801052a5:	c1 e2 02             	shl    $0x2,%edx
801052a8:	81 c2 80 49 11 80    	add    $0x80114980,%edx
801052ae:	83 c2 04             	add    $0x4,%edx
801052b1:	83 ec 04             	sub    $0x4,%esp
801052b4:	50                   	push   %eax
801052b5:	6a 03                	push   $0x3
801052b7:	52                   	push   %edx
801052b8:	e8 d6 0a 00 00       	call   80105d93 <addToStateListTail>
801052bd:	83 c4 10             	add    $0x10,%esp
    }
    
    proc->priority++;
801052c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052c6:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
801052cc:	83 c2 01             	add    $0x1,%edx
801052cf:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    proc->budget = DEFAULT_BUDGET;
801052d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052db:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
801052e2:	01 00 00 
  }
  // END: Added for Project 4: Periodic Priority Adjustment
  
  swtch(&proc->context, cpu->scheduler);
801052e5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052eb:	8b 40 04             	mov    0x4(%eax),%eax
801052ee:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052f5:	83 c2 1c             	add    $0x1c,%edx
801052f8:	83 ec 08             	sub    $0x8,%esp
801052fb:	50                   	push   %eax
801052fc:	52                   	push   %edx
801052fd:	e8 e5 14 00 00       	call   801067e7 <swtch>
80105302:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80105305:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010530b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010530e:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105314:	90                   	nop
80105315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105318:	c9                   	leave  
80105319:	c3                   	ret    

8010531a <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010531a:	55                   	push   %ebp
8010531b:	89 e5                	mov    %esp,%ebp
8010531d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	68 80 49 11 80       	push   $0x80114980
80105328:	e8 e3 0f 00 00       	call   80106310 <acquire>
8010532d:	83 c4 10             	add    $0x10,%esp

  // START: Added for Project 3: List Management
  #ifdef CS333_P3P4
  // move proc from running to ready 
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
80105330:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105336:	83 ec 04             	sub    $0x4,%esp
80105339:	50                   	push   %eax
8010533a:	6a 04                	push   $0x4
8010533c:	68 d0 70 11 80       	push   $0x801170d0
80105341:	e8 49 09 00 00       	call   80105c8f <removeFromStateList>
80105346:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80105349:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010534f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  addToStateListTail(&ptable.pLists.ready[0], RUNNABLE, proc); // Modified for Project 4: Periodic Priority Adjustment
80105356:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010535c:	83 ec 04             	sub    $0x4,%esp
8010535f:	50                   	push   %eax
80105360:	6a 03                	push   $0x3
80105362:	68 b4 70 11 80       	push   $0x801170b4
80105367:	e8 27 0a 00 00       	call   80105d93 <addToStateListTail>
8010536c:	83 c4 10             	add    $0x10,%esp
  #else
  proc->state = RUNNABLE;
  #endif

  sched();
8010536f:	e8 b9 fd ff ff       	call   8010512d <sched>
  release(&ptable.lock);
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	68 80 49 11 80       	push   $0x80114980
8010537c:	e8 f6 0f 00 00       	call   80106377 <release>
80105381:	83 c4 10             	add    $0x10,%esp
}
80105384:	90                   	nop
80105385:	c9                   	leave  
80105386:	c3                   	ret    

80105387 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105387:	55                   	push   %ebp
80105388:	89 e5                	mov    %esp,%ebp
8010538a:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010538d:	83 ec 0c             	sub    $0xc,%esp
80105390:	68 80 49 11 80       	push   $0x80114980
80105395:	e8 dd 0f 00 00       	call   80106377 <release>
8010539a:	83 c4 10             	add    $0x10,%esp

  if (first) {
8010539d:	a1 20 d0 10 80       	mov    0x8010d020,%eax
801053a2:	85 c0                	test   %eax,%eax
801053a4:	74 24                	je     801053ca <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801053a6:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
801053ad:	00 00 00 
    iinit(ROOTDEV);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	6a 01                	push   $0x1
801053b5:	e8 2a c3 ff ff       	call   801016e4 <iinit>
801053ba:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801053bd:	83 ec 0c             	sub    $0xc,%esp
801053c0:	6a 01                	push   $0x1
801053c2:	e8 0e e0 ff ff       	call   801033d5 <initlog>
801053c7:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801053ca:	90                   	nop
801053cb:	c9                   	leave  
801053cc:	c3                   	ret    

801053cd <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
801053cd:	55                   	push   %ebp
801053ce:	89 e5                	mov    %esp,%ebp
801053d0:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
801053d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053d9:	85 c0                	test   %eax,%eax
801053db:	75 0d                	jne    801053ea <sleep+0x1d>
    panic("sleep");
801053dd:	83 ec 0c             	sub    $0xc,%esp
801053e0:	68 c8 9d 10 80       	push   $0x80109dc8
801053e5:	e8 7c b1 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
801053ea:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801053f1:	74 24                	je     80105417 <sleep+0x4a>
    acquire(&ptable.lock);
801053f3:	83 ec 0c             	sub    $0xc,%esp
801053f6:	68 80 49 11 80       	push   $0x80114980
801053fb:	e8 10 0f 00 00       	call   80106310 <acquire>
80105400:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105403:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105407:	74 0e                	je     80105417 <sleep+0x4a>
80105409:	83 ec 0c             	sub    $0xc,%esp
8010540c:	ff 75 0c             	pushl  0xc(%ebp)
8010540f:	e8 63 0f 00 00       	call   80106377 <release>
80105414:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80105417:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010541d:	8b 55 08             	mov    0x8(%ebp),%edx
80105420:	89 50 20             	mov    %edx,0x20(%eax)

  // START: Added for Project 3: List Management
  #ifdef CS333_P3P4
  // move proc from running to sleep list
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
80105423:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105429:	83 ec 04             	sub    $0x4,%esp
8010542c:	50                   	push   %eax
8010542d:	6a 04                	push   $0x4
8010542f:	68 d0 70 11 80       	push   $0x801170d0
80105434:	e8 56 08 00 00       	call   80105c8f <removeFromStateList>
80105439:	83 c4 10             	add    $0x10,%esp
  proc->state = SLEEPING;
8010543c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105442:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  addToStateListHead(&ptable.pLists.sleep, SLEEPING, proc);
80105449:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010544f:	83 ec 04             	sub    $0x4,%esp
80105452:	50                   	push   %eax
80105453:	6a 02                	push   $0x2
80105455:	68 c8 70 11 80       	push   $0x801170c8
8010545a:	e8 fd 08 00 00       	call   80105d5c <addToStateListHead>
8010545f:	83 c4 10             	add    $0x10,%esp
  #else
  proc->state = SLEEPING;
  #endif
  sched(); // TODO: sched???
80105462:	e8 c6 fc ff ff       	call   8010512d <sched>
  // END: Added for Project 3: List Management

  // Tidy up.
  proc->chan = 0;
80105467:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010546d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
80105474:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
8010547b:	74 24                	je     801054a1 <sleep+0xd4>
    release(&ptable.lock);
8010547d:	83 ec 0c             	sub    $0xc,%esp
80105480:	68 80 49 11 80       	push   $0x80114980
80105485:	e8 ed 0e 00 00       	call   80106377 <release>
8010548a:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
8010548d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105491:	74 0e                	je     801054a1 <sleep+0xd4>
80105493:	83 ec 0c             	sub    $0xc,%esp
80105496:	ff 75 0c             	pushl  0xc(%ebp)
80105499:	e8 72 0e 00 00       	call   80106310 <acquire>
8010549e:	83 c4 10             	add    $0x10,%esp
  }
}
801054a1:	90                   	nop
801054a2:	c9                   	leave  
801054a3:	c3                   	ret    

801054a4 <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan) // Added for Project 3: List Management
{
801054a4:	55                   	push   %ebp
801054a5:	89 e5                	mov    %esp,%ebp
801054a7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = ptable.pLists.sleep;
801054aa:	a1 c8 70 11 80       	mov    0x801170c8,%eax
801054af:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // go through sleep list to find process with correct chan
  while(p != 0) {
801054b2:	eb 6b                	jmp    8010551f <wakeup1+0x7b>
    if(p->state == SLEEPING && p->chan == chan) {
801054b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b7:	8b 40 0c             	mov    0xc(%eax),%eax
801054ba:	83 f8 02             	cmp    $0x2,%eax
801054bd:	75 54                	jne    80105513 <wakeup1+0x6f>
801054bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c2:	8b 40 20             	mov    0x20(%eax),%eax
801054c5:	3b 45 08             	cmp    0x8(%ebp),%eax
801054c8:	75 49                	jne    80105513 <wakeup1+0x6f>
      // START: Added for Project 3: List Management
      // move proc p from sleep to ready list
      removeFromStateList(&ptable.pLists.sleep, SLEEPING, p);
801054ca:	83 ec 04             	sub    $0x4,%esp
801054cd:	ff 75 f4             	pushl  -0xc(%ebp)
801054d0:	6a 02                	push   $0x2
801054d2:	68 c8 70 11 80       	push   $0x801170c8
801054d7:	e8 b3 07 00 00       	call   80105c8f <removeFromStateList>
801054dc:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
801054df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      addToStateListTail(&ptable.pLists.ready[p->priority], RUNNABLE, p); // Modified for Project 4: Periodic Priority Adjustment
801054e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ec:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801054f2:	05 cc 09 00 00       	add    $0x9cc,%eax
801054f7:	c1 e0 02             	shl    $0x2,%eax
801054fa:	05 80 49 11 80       	add    $0x80114980,%eax
801054ff:	83 c0 04             	add    $0x4,%eax
80105502:	83 ec 04             	sub    $0x4,%esp
80105505:	ff 75 f4             	pushl  -0xc(%ebp)
80105508:	6a 03                	push   $0x3
8010550a:	50                   	push   %eax
8010550b:	e8 83 08 00 00       	call   80105d93 <addToStateListTail>
80105510:	83 c4 10             	add    $0x10,%esp
      // END: Added for Project 3: List Management
    }

    p = p->next;
80105513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105516:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010551c:	89 45 f4             	mov    %eax,-0xc(%ebp)
wakeup1(void *chan) // Added for Project 3: List Management
{
  struct proc *p = ptable.pLists.sleep;

  // go through sleep list to find process with correct chan
  while(p != 0) {
8010551f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105523:	75 8f                	jne    801054b4 <wakeup1+0x10>
      // END: Added for Project 3: List Management
    }

    p = p->next;
  }
}
80105525:	90                   	nop
80105526:	c9                   	leave  
80105527:	c3                   	ret    

80105528 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105528:	55                   	push   %ebp
80105529:	89 e5                	mov    %esp,%ebp
8010552b:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010552e:	83 ec 0c             	sub    $0xc,%esp
80105531:	68 80 49 11 80       	push   $0x80114980
80105536:	e8 d5 0d 00 00       	call   80106310 <acquire>
8010553b:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010553e:	83 ec 0c             	sub    $0xc,%esp
80105541:	ff 75 08             	pushl  0x8(%ebp)
80105544:	e8 5b ff ff ff       	call   801054a4 <wakeup1>
80105549:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010554c:	83 ec 0c             	sub    $0xc,%esp
8010554f:	68 80 49 11 80       	push   $0x80114980
80105554:	e8 1e 0e 00 00       	call   80106377 <release>
80105559:	83 c4 10             	add    $0x10,%esp
}
8010555c:	90                   	nop
8010555d:	c9                   	leave  
8010555e:	c3                   	ret    

8010555f <kill>:
  return -1;
}
#else
int
kill(int pid) // Added for Project 3: List Management
{
8010555f:	55                   	push   %ebp
80105560:	89 e5                	mov    %esp,%ebp
80105562:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  acquire(&ptable.lock);
80105565:	83 ec 0c             	sub    $0xc,%esp
80105568:	68 80 49 11 80       	push   $0x80114980
8010556d:	e8 9e 0d 00 00       	call   80106310 <acquire>
80105572:	83 c4 10             	add    $0x10,%esp
  // find proc that has the specified pid from all lists except free list (as mentioned in mail list)
  p = findMatchingProcPID(pid); // Added for Project 3: List Management
80105575:	8b 45 08             	mov    0x8(%ebp),%eax
80105578:	83 ec 0c             	sub    $0xc,%esp
8010557b:	50                   	push   %eax
8010557c:	e8 8c 09 00 00       	call   80105f0d <findMatchingProcPID>
80105581:	83 c4 10             	add    $0x10,%esp
80105584:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p != 0){			// Added for Project 3: List Management
80105587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010558b:	0f 84 82 00 00 00    	je     80105613 <kill+0xb4>
    if(p->pid == pid){
80105591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105594:	8b 50 10             	mov    0x10(%eax),%edx
80105597:	8b 45 08             	mov    0x8(%ebp),%eax
8010559a:	39 c2                	cmp    %eax,%edx
8010559c:	75 75                	jne    80105613 <kill+0xb4>
      p->killed = 1;
8010559e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING) {
801055a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ab:	8b 40 0c             	mov    0xc(%eax),%eax
801055ae:	83 f8 02             	cmp    $0x2,%eax
801055b1:	75 49                	jne    801055fc <kill+0x9d>
        // START: Added for Project 3: List Management
        // move proc p from sleeping to ready
        removeFromStateList(&ptable.pLists.sleep, SLEEPING, p);
801055b3:	83 ec 04             	sub    $0x4,%esp
801055b6:	ff 75 f4             	pushl  -0xc(%ebp)
801055b9:	6a 02                	push   $0x2
801055bb:	68 c8 70 11 80       	push   $0x801170c8
801055c0:	e8 ca 06 00 00       	call   80105c8f <removeFromStateList>
801055c5:	83 c4 10             	add    $0x10,%esp
        p->state = RUNNABLE;
801055c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055cb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        addToStateListTail(&ptable.pLists.ready[p->priority], RUNNABLE, p); // Modified for Project 4: Periodic Priority Adjustment
801055d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d5:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801055db:	05 cc 09 00 00       	add    $0x9cc,%eax
801055e0:	c1 e0 02             	shl    $0x2,%eax
801055e3:	05 80 49 11 80       	add    $0x80114980,%eax
801055e8:	83 c0 04             	add    $0x4,%eax
801055eb:	83 ec 04             	sub    $0x4,%esp
801055ee:	ff 75 f4             	pushl  -0xc(%ebp)
801055f1:	6a 03                	push   $0x3
801055f3:	50                   	push   %eax
801055f4:	e8 9a 07 00 00       	call   80105d93 <addToStateListTail>
801055f9:	83 c4 10             	add    $0x10,%esp
        // END: Added for Project 3: List Management
      }

      release(&ptable.lock);
801055fc:	83 ec 0c             	sub    $0xc,%esp
801055ff:	68 80 49 11 80       	push   $0x80114980
80105604:	e8 6e 0d 00 00       	call   80106377 <release>
80105609:	83 c4 10             	add    $0x10,%esp
      return 0;
8010560c:	b8 00 00 00 00       	mov    $0x0,%eax
80105611:	eb 15                	jmp    80105628 <kill+0xc9>
    }
  }
  release(&ptable.lock);
80105613:	83 ec 0c             	sub    $0xc,%esp
80105616:	68 80 49 11 80       	push   $0x80114980
8010561b:	e8 57 0d 00 00       	call   80106377 <release>
80105620:	83 c4 10             	add    $0x10,%esp
  return -1;
80105623:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105628:	c9                   	leave  
80105629:	c3                   	ret    

8010562a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010562a:	55                   	push   %ebp
8010562b:	89 e5                	mov    %esp,%ebp
8010562d:	57                   	push   %edi
8010562e:	56                   	push   %esi
8010562f:	53                   	push   %ebx
80105630:	83 ec 6c             	sub    $0x6c,%esp
  char *state;
  uint pc[10];
  uint ppid;
 
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command
80105633:	83 ec 0c             	sub    $0xc,%esp
80105636:	68 f8 9d 10 80       	push   $0x80109df8
8010563b:	e8 86 ad ff ff       	call   801003c6 <cprintf>
80105640:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105643:	c7 45 e0 b4 49 11 80 	movl   $0x801149b4,-0x20(%ebp)
8010564a:	e9 0e 02 00 00       	jmp    8010585d <procdump+0x233>
    if(p->state == UNUSED)
8010564f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105652:	8b 40 0c             	mov    0xc(%eax),%eax
80105655:	85 c0                	test   %eax,%eax
80105657:	0f 84 f8 01 00 00    	je     80105855 <procdump+0x22b>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010565d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105660:	8b 40 0c             	mov    0xc(%eax),%eax
80105663:	83 f8 05             	cmp    $0x5,%eax
80105666:	77 23                	ja     8010568b <procdump+0x61>
80105668:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010566b:	8b 40 0c             	mov    0xc(%eax),%eax
8010566e:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105675:	85 c0                	test   %eax,%eax
80105677:	74 12                	je     8010568b <procdump+0x61>
      state = states[p->state];
80105679:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010567c:	8b 40 0c             	mov    0xc(%eax),%eax
8010567f:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105686:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105689:	eb 07                	jmp    80105692 <procdump+0x68>
    else
      state = "???";
8010568b:	c7 45 dc 31 9e 10 80 	movl   $0x80109e31,-0x24(%ebp)
    // Print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size (with needed spacing)
    // Switched to tabs and mod in Project 2: Modifying the Console)
    // (I wish I used this method from the start.... :(  )
    
    // get ppid (and if it is init then its ppid is itself (1))
    if (p->pid == 1)
80105692:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105695:	8b 40 10             	mov    0x10(%eax),%eax
80105698:	83 f8 01             	cmp    $0x1,%eax
8010569b:	75 09                	jne    801056a6 <procdump+0x7c>
      ppid = 1;
8010569d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
801056a4:	eb 0c                	jmp    801056b2 <procdump+0x88>
    else
      ppid = p->parent->pid;
801056a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056a9:	8b 40 14             	mov    0x14(%eax),%eax
801056ac:	8b 40 10             	mov    0x10(%eax),%eax
801056af:	89 45 d8             	mov    %eax,-0x28(%ebp)

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801056b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056b5:	8b 38                	mov    (%eax),%edi
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
		p->cpu_ticks_total / 100,
		p->cpu_ticks_total % 100 / 10,
801056b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056ba:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
801056c0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801056c5:	89 c8                	mov    %ecx,%eax
801056c7:	f7 e2                	mul    %edx
801056c9:	89 d0                	mov    %edx,%eax
801056cb:	c1 e8 05             	shr    $0x5,%eax
801056ce:	6b c0 64             	imul   $0x64,%eax,%eax
801056d1:	29 c1                	sub    %eax,%ecx
801056d3:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801056d5:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801056da:	f7 e2                	mul    %edx
801056dc:	c1 ea 03             	shr    $0x3,%edx
801056df:	89 55 a4             	mov    %edx,-0x5c(%ebp)
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
		p->cpu_ticks_total / 100,
801056e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056e5:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801056eb:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801056f0:	f7 e2                	mul    %edx
801056f2:	89 d0                	mov    %edx,%eax
801056f4:	c1 e8 05             	shr    $0x5,%eax
801056f7:	89 45 a0             	mov    %eax,-0x60(%ebp)
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
801056fa:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105700:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105703:	8b 40 7c             	mov    0x7c(%eax),%eax
80105706:	89 d3                	mov    %edx,%ebx
80105708:	29 c3                	sub    %eax,%ebx
8010570a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010570f:	89 d8                	mov    %ebx,%eax
80105711:	f7 e2                	mul    %edx
80105713:	89 d1                	mov    %edx,%ecx
80105715:	c1 e9 05             	shr    $0x5,%ecx
80105718:	6b c1 64             	imul   $0x64,%ecx,%eax
8010571b:	29 c3                	sub    %eax,%ebx
8010571d:	89 d9                	mov    %ebx,%ecx
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
8010571f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105724:	89 c8                	mov    %ecx,%eax
80105726:	f7 e2                	mul    %edx
80105728:	89 d3                	mov    %edx,%ebx
8010572a:	c1 eb 03             	shr    $0x3,%ebx
8010572d:	89 d8                	mov    %ebx,%eax
8010572f:	c1 e0 02             	shl    $0x2,%eax
80105732:	01 d8                	add    %ebx,%eax
80105734:	01 c0                	add    %eax,%eax
80105736:	89 cb                	mov    %ecx,%ebx
80105738:	29 c3                	sub    %eax,%ebx
		p->uid,
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
8010573a:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105740:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105743:	8b 40 7c             	mov    0x7c(%eax),%eax
80105746:	89 d1                	mov    %edx,%ecx
80105748:	29 c1                	sub    %eax,%ecx
8010574a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010574f:	89 c8                	mov    %ecx,%eax
80105751:	f7 e2                	mul    %edx
80105753:	89 d0                	mov    %edx,%eax
80105755:	c1 e8 05             	shr    $0x5,%eax
80105758:	6b c0 64             	imul   $0x64,%eax,%eax
8010575b:	29 c1                	sub    %eax,%ecx
8010575d:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
8010575f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105764:	f7 e2                	mul    %edx
80105766:	89 d6                	mov    %edx,%esi
80105768:	c1 ee 03             	shr    $0x3,%esi
8010576b:	89 75 9c             	mov    %esi,-0x64(%ebp)
		p->name,
		p->uid,
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
8010576e:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105774:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105777:	8b 40 7c             	mov    0x7c(%eax),%eax
8010577a:	89 d1                	mov    %edx,%ecx
8010577c:	29 c1                	sub    %eax,%ecx
8010577e:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
80105780:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105785:	f7 e2                	mul    %edx
80105787:	89 d1                	mov    %edx,%ecx
80105789:	c1 e9 05             	shr    $0x5,%ecx
8010578c:	89 4d 98             	mov    %ecx,-0x68(%ebp)
8010578f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105792:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105798:	89 45 94             	mov    %eax,-0x6c(%ebp)
8010579b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010579e:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
801057a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057a7:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
		p->pid,
		p->name,
801057ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057b0:	8d 50 6c             	lea    0x6c(%eax),%edx
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801057b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057b6:	8b 40 10             	mov    0x10(%eax),%eax
801057b9:	83 ec 08             	sub    $0x8,%esp
801057bc:	57                   	push   %edi
801057bd:	ff 75 dc             	pushl  -0x24(%ebp)
801057c0:	ff 75 a4             	pushl  -0x5c(%ebp)
801057c3:	ff 75 a0             	pushl  -0x60(%ebp)
801057c6:	53                   	push   %ebx
801057c7:	ff 75 9c             	pushl  -0x64(%ebp)
801057ca:	ff 75 98             	pushl  -0x68(%ebp)
801057cd:	ff 75 94             	pushl  -0x6c(%ebp)
801057d0:	ff 75 d8             	pushl  -0x28(%ebp)
801057d3:	56                   	push   %esi
801057d4:	51                   	push   %ecx
801057d5:	52                   	push   %edx
801057d6:	50                   	push   %eax
801057d7:	68 38 9e 10 80       	push   $0x80109e38
801057dc:	e8 e5 ab ff ff       	call   801003c6 <cprintf>
801057e1:	83 c4 40             	add    $0x40,%esp
		p->sz);

    // END: Added for Project 1: CTL-P

    // Print PCs data
    if(p->state == SLEEPING){
801057e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057e7:	8b 40 0c             	mov    0xc(%eax),%eax
801057ea:	83 f8 02             	cmp    $0x2,%eax
801057ed:	75 54                	jne    80105843 <procdump+0x219>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801057ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057f2:	8b 40 1c             	mov    0x1c(%eax),%eax
801057f5:	8b 40 0c             	mov    0xc(%eax),%eax
801057f8:	83 c0 08             	add    $0x8,%eax
801057fb:	89 c2                	mov    %eax,%edx
801057fd:	83 ec 08             	sub    $0x8,%esp
80105800:	8d 45 b0             	lea    -0x50(%ebp),%eax
80105803:	50                   	push   %eax
80105804:	52                   	push   %edx
80105805:	e8 bf 0b 00 00       	call   801063c9 <getcallerpcs>
8010580a:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010580d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105814:	eb 1c                	jmp    80105832 <procdump+0x208>
        cprintf(" %p", pc[i]);
80105816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105819:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
8010581d:	83 ec 08             	sub    $0x8,%esp
80105820:	50                   	push   %eax
80105821:	68 5f 9e 10 80       	push   $0x80109e5f
80105826:	e8 9b ab ff ff       	call   801003c6 <cprintf>
8010582b:	83 c4 10             	add    $0x10,%esp
    // END: Added for Project 1: CTL-P

    // Print PCs data
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010582e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105832:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
80105836:	7f 0b                	jg     80105843 <procdump+0x219>
80105838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010583b:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
8010583f:	85 c0                	test   %eax,%eax
80105841:	75 d3                	jne    80105816 <procdump+0x1ec>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105843:	83 ec 0c             	sub    $0xc,%esp
80105846:	68 63 9e 10 80       	push   $0x80109e63
8010584b:	e8 76 ab ff ff       	call   801003c6 <cprintf>
80105850:	83 c4 10             	add    $0x10,%esp
80105853:	eb 01                	jmp    80105856 <procdump+0x22c>
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105855:	90                   	nop
  uint ppid;
 
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105856:	81 45 e0 9c 00 00 00 	addl   $0x9c,-0x20(%ebp)
8010585d:	81 7d e0 b4 70 11 80 	cmpl   $0x801170b4,-0x20(%ebp)
80105864:	0f 82 e5 fd ff ff    	jb     8010564f <procdump+0x25>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
8010586a:	90                   	nop
8010586b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010586e:	5b                   	pop    %ebx
8010586f:	5e                   	pop    %esi
80105870:	5f                   	pop    %edi
80105871:	5d                   	pop    %ebp
80105872:	c3                   	ret    

80105873 <readydump>:

// START: Added for Project 3: New Console Control Sequences
void
readydump(void) // Modified for Project 4: ctrl-r Console Command
{
80105873:	55                   	push   %ebp
80105874:	89 e5                	mov    %esp,%ebp
80105876:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105879:	83 ec 0c             	sub    $0xc,%esp
8010587c:	68 80 49 11 80       	push   $0x80114980
80105881:	e8 8a 0a 00 00       	call   80106310 <acquire>
80105886:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = 0;
80105889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  cprintf("Ready List Processes:\n"); 
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	68 65 9e 10 80       	push   $0x80109e65
80105898:	e8 29 ab ff ff       	call   801003c6 <cprintf>
8010589d:	83 c4 10             	add    $0x10,%esp

  for(int i = 0; i < MAX + 1; ++i){
801058a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801058a7:	e9 a4 00 00 00       	jmp    80105950 <readydump+0xdd>
    currPtr = ptable.pLists.ready[i];
801058ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058af:	05 cc 09 00 00       	add    $0x9cc,%eax
801058b4:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801058bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%d: ", i); // print list number
801058be:	83 ec 08             	sub    $0x8,%esp
801058c1:	ff 75 f0             	pushl  -0x10(%ebp)
801058c4:	68 7c 9e 10 80       	push   $0x80109e7c
801058c9:	e8 f8 aa ff ff       	call   801003c6 <cprintf>
801058ce:	83 c4 10             	add    $0x10,%esp
    
    if (currPtr == 0)
801058d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058d5:	75 6f                	jne    80105946 <readydump+0xd3>
      cprintf("Empty!\n");
801058d7:	83 ec 0c             	sub    $0xc,%esp
801058da:	68 81 9e 10 80       	push   $0x80109e81
801058df:	e8 e2 aa ff ff       	call   801003c6 <cprintf>
801058e4:	83 c4 10             	add    $0x10,%esp

    while (currPtr != 0){
801058e7:	eb 5d                	jmp    80105946 <readydump+0xd3>
      if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
801058e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ec:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801058f2:	85 c0                	test   %eax,%eax
801058f4:	75 23                	jne    80105919 <readydump+0xa6>
        cprintf("(%d, %d)\n", currPtr->pid, currPtr->budget);
801058f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f9:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
801058ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105902:	8b 40 10             	mov    0x10(%eax),%eax
80105905:	83 ec 04             	sub    $0x4,%esp
80105908:	52                   	push   %edx
80105909:	50                   	push   %eax
8010590a:	68 89 9e 10 80       	push   $0x80109e89
8010590f:	e8 b2 aa ff ff       	call   801003c6 <cprintf>
80105914:	83 c4 10             	add    $0x10,%esp
80105917:	eb 21                	jmp    8010593a <readydump+0xc7>
      else
        cprintf("(%d, %d) -> ", currPtr->pid, currPtr->budget);
80105919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591c:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105925:	8b 40 10             	mov    0x10(%eax),%eax
80105928:	83 ec 04             	sub    $0x4,%esp
8010592b:	52                   	push   %edx
8010592c:	50                   	push   %eax
8010592d:	68 93 9e 10 80       	push   $0x80109e93
80105932:	e8 8f aa ff ff       	call   801003c6 <cprintf>
80105937:	83 c4 10             	add    $0x10,%esp

      currPtr = currPtr->next;
8010593a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105943:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%d: ", i); // print list number
    
    if (currPtr == 0)
      cprintf("Empty!\n");

    while (currPtr != 0){
80105946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010594a:	75 9d                	jne    801058e9 <readydump+0x76>

  struct proc *currPtr = 0;

  cprintf("Ready List Processes:\n"); 

  for(int i = 0; i < MAX + 1; ++i){
8010594c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105950:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
80105954:	0f 8e 52 ff ff ff    	jle    801058ac <readydump+0x39>

      currPtr = currPtr->next;
    }
  }

  release(&ptable.lock);
8010595a:	83 ec 0c             	sub    $0xc,%esp
8010595d:	68 80 49 11 80       	push   $0x80114980
80105962:	e8 10 0a 00 00       	call   80106377 <release>
80105967:	83 c4 10             	add    $0x10,%esp
}
8010596a:	90                   	nop
8010596b:	c9                   	leave  
8010596c:	c3                   	ret    

8010596d <freedump>:

void
freedump(void)
{
8010596d:	55                   	push   %ebp
8010596e:	89 e5                	mov    %esp,%ebp
80105970:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105973:	83 ec 0c             	sub    $0xc,%esp
80105976:	68 80 49 11 80       	push   $0x80114980
8010597b:	e8 90 09 00 00       	call   80106310 <acquire>
80105980:	83 c4 10             	add    $0x10,%esp
  
  struct proc *currPtr = ptable.pLists.free;
80105983:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80105988:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint numProcs = 0;
8010598b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  while (currPtr != 0){
80105992:	eb 10                	jmp    801059a4 <freedump+0x37>
    ++numProcs;
80105994:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    currPtr = currPtr->next;
80105998:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010599b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&ptable.lock);
  
  struct proc *currPtr = ptable.pLists.free;
  uint numProcs = 0;

  while (currPtr != 0){
801059a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059a8:	75 ea                	jne    80105994 <freedump+0x27>
    ++numProcs;
    currPtr = currPtr->next;
  }

  cprintf("Free List Size: %d processes\n", numProcs);
801059aa:	83 ec 08             	sub    $0x8,%esp
801059ad:	ff 75 f0             	pushl  -0x10(%ebp)
801059b0:	68 a0 9e 10 80       	push   $0x80109ea0
801059b5:	e8 0c aa ff ff       	call   801003c6 <cprintf>
801059ba:	83 c4 10             	add    $0x10,%esp

  release(&ptable.lock);
801059bd:	83 ec 0c             	sub    $0xc,%esp
801059c0:	68 80 49 11 80       	push   $0x80114980
801059c5:	e8 ad 09 00 00       	call   80106377 <release>
801059ca:	83 c4 10             	add    $0x10,%esp
}
801059cd:	90                   	nop
801059ce:	c9                   	leave  
801059cf:	c3                   	ret    

801059d0 <sleepdump>:

void
sleepdump(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801059d6:	83 ec 0c             	sub    $0xc,%esp
801059d9:	68 80 49 11 80       	push   $0x80114980
801059de:	e8 2d 09 00 00       	call   80106310 <acquire>
801059e3:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = ptable.pLists.sleep;
801059e6:	a1 c8 70 11 80       	mov    0x801170c8,%eax
801059eb:	89 45 f4             	mov    %eax,-0xc(%ebp)

  cprintf("Sleep List Processes:\n"); 
801059ee:	83 ec 0c             	sub    $0xc,%esp
801059f1:	68 be 9e 10 80       	push   $0x80109ebe
801059f6:	e8 cb a9 ff ff       	call   801003c6 <cprintf>
801059fb:	83 c4 10             	add    $0x10,%esp
  
  if (currPtr == 0)
801059fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a02:	75 5b                	jne    80105a5f <sleepdump+0x8f>
    cprintf("Empty!\n");
80105a04:	83 ec 0c             	sub    $0xc,%esp
80105a07:	68 81 9e 10 80       	push   $0x80109e81
80105a0c:	e8 b5 a9 ff ff       	call   801003c6 <cprintf>
80105a11:	83 c4 10             	add    $0x10,%esp

  while (currPtr != 0){
80105a14:	eb 49                	jmp    80105a5f <sleepdump+0x8f>
    if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
80105a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a19:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a1f:	85 c0                	test   %eax,%eax
80105a21:	75 19                	jne    80105a3c <sleepdump+0x6c>
      cprintf("%d\n", currPtr->pid);
80105a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a26:	8b 40 10             	mov    0x10(%eax),%eax
80105a29:	83 ec 08             	sub    $0x8,%esp
80105a2c:	50                   	push   %eax
80105a2d:	68 d5 9e 10 80       	push   $0x80109ed5
80105a32:	e8 8f a9 ff ff       	call   801003c6 <cprintf>
80105a37:	83 c4 10             	add    $0x10,%esp
80105a3a:	eb 17                	jmp    80105a53 <sleepdump+0x83>
    else
      cprintf("%d -> ", currPtr->pid);
80105a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3f:	8b 40 10             	mov    0x10(%eax),%eax
80105a42:	83 ec 08             	sub    $0x8,%esp
80105a45:	50                   	push   %eax
80105a46:	68 d9 9e 10 80       	push   $0x80109ed9
80105a4b:	e8 76 a9 ff ff       	call   801003c6 <cprintf>
80105a50:	83 c4 10             	add    $0x10,%esp

    currPtr = currPtr->next;
80105a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a56:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cprintf("Sleep List Processes:\n"); 
  
  if (currPtr == 0)
    cprintf("Empty!\n");

  while (currPtr != 0){
80105a5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a63:	75 b1                	jne    80105a16 <sleepdump+0x46>
      cprintf("%d -> ", currPtr->pid);

    currPtr = currPtr->next;
  }

  release(&ptable.lock);
80105a65:	83 ec 0c             	sub    $0xc,%esp
80105a68:	68 80 49 11 80       	push   $0x80114980
80105a6d:	e8 05 09 00 00       	call   80106377 <release>
80105a72:	83 c4 10             	add    $0x10,%esp
}
80105a75:	90                   	nop
80105a76:	c9                   	leave  
80105a77:	c3                   	ret    

80105a78 <zombiedump>:

void
zombiedump(void)
{
80105a78:	55                   	push   %ebp
80105a79:	89 e5                	mov    %esp,%ebp
80105a7b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105a7e:	83 ec 0c             	sub    $0xc,%esp
80105a81:	68 80 49 11 80       	push   $0x80114980
80105a86:	e8 85 08 00 00       	call   80106310 <acquire>
80105a8b:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = ptable.pLists.zombie;
80105a8e:	a1 cc 70 11 80       	mov    0x801170cc,%eax
80105a93:	89 45 f4             	mov    %eax,-0xc(%ebp)

  cprintf("Zombie List Processes:\n"); 
80105a96:	83 ec 0c             	sub    $0xc,%esp
80105a99:	68 e0 9e 10 80       	push   $0x80109ee0
80105a9e:	e8 23 a9 ff ff       	call   801003c6 <cprintf>
80105aa3:	83 c4 10             	add    $0x10,%esp

  if (currPtr == 0)
80105aa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aaa:	75 6f                	jne    80105b1b <zombiedump+0xa3>
    cprintf("Empty!\n");
80105aac:	83 ec 0c             	sub    $0xc,%esp
80105aaf:	68 81 9e 10 80       	push   $0x80109e81
80105ab4:	e8 0d a9 ff ff       	call   801003c6 <cprintf>
80105ab9:	83 c4 10             	add    $0x10,%esp

  while (currPtr != 0){
80105abc:	eb 5d                	jmp    80105b1b <zombiedump+0xa3>
    if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
80105abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ac7:	85 c0                	test   %eax,%eax
80105ac9:	75 23                	jne    80105aee <zombiedump+0x76>
        cprintf("(%d, %d)\n", currPtr->pid, currPtr->parent->pid);
80105acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ace:	8b 40 14             	mov    0x14(%eax),%eax
80105ad1:	8b 50 10             	mov    0x10(%eax),%edx
80105ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad7:	8b 40 10             	mov    0x10(%eax),%eax
80105ada:	83 ec 04             	sub    $0x4,%esp
80105add:	52                   	push   %edx
80105ade:	50                   	push   %eax
80105adf:	68 89 9e 10 80       	push   $0x80109e89
80105ae4:	e8 dd a8 ff ff       	call   801003c6 <cprintf>
80105ae9:	83 c4 10             	add    $0x10,%esp
80105aec:	eb 21                	jmp    80105b0f <zombiedump+0x97>
    else
      cprintf("(%d, %d) -> ", currPtr->pid, currPtr->parent->pid);
80105aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af1:	8b 40 14             	mov    0x14(%eax),%eax
80105af4:	8b 50 10             	mov    0x10(%eax),%edx
80105af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afa:	8b 40 10             	mov    0x10(%eax),%eax
80105afd:	83 ec 04             	sub    $0x4,%esp
80105b00:	52                   	push   %edx
80105b01:	50                   	push   %eax
80105b02:	68 93 9e 10 80       	push   $0x80109e93
80105b07:	e8 ba a8 ff ff       	call   801003c6 <cprintf>
80105b0c:	83 c4 10             	add    $0x10,%esp
    
    currPtr = currPtr->next;
80105b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b12:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cprintf("Zombie List Processes:\n"); 

  if (currPtr == 0)
    cprintf("Empty!\n");

  while (currPtr != 0){
80105b1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b1f:	75 9d                	jne    80105abe <zombiedump+0x46>
      cprintf("(%d, %d) -> ", currPtr->pid, currPtr->parent->pid);
    
    currPtr = currPtr->next;
  }

  release(&ptable.lock);
80105b21:	83 ec 0c             	sub    $0xc,%esp
80105b24:	68 80 49 11 80       	push   $0x80114980
80105b29:	e8 49 08 00 00       	call   80106377 <release>
80105b2e:	83 c4 10             	add    $0x10,%esp
}
80105b31:	90                   	nop
80105b32:	c9                   	leave  
80105b33:	c3                   	ret    

80105b34 <getuprocs>:
// END: Added for Project 3: New Console Control Sequences

// get array of uproc structs
int
getuprocs(uint max, struct uproc *table) // Added for Project 2: The "ps" Command
{
80105b34:	55                   	push   %ebp
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  uint numProcs = 0; // number of procs in struct array
80105b3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  acquire(&ptable.lock); // get lock so we get a snapshot
80105b41:	83 ec 0c             	sub    $0xc,%esp
80105b44:	68 80 49 11 80       	push   $0x80114980
80105b49:	e8 c2 07 00 00       	call   80106310 <acquire>
80105b4e:	83 c4 10             	add    $0x10,%esp

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
80105b51:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80105b58:	e9 08 01 00 00       	jmp    80105c65 <getuprocs+0x131>
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
80105b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b60:	8b 40 0c             	mov    0xc(%eax),%eax
80105b63:	83 f8 03             	cmp    $0x3,%eax
80105b66:	74 25                	je     80105b8d <getuprocs+0x59>
        p->state == SLEEPING || 
80105b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6b:	8b 40 0c             	mov    0xc(%eax),%eax

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
80105b6e:	83 f8 02             	cmp    $0x2,%eax
80105b71:	74 1a                	je     80105b8d <getuprocs+0x59>
        p->state == SLEEPING || 
        p->state == RUNNING  || 
80105b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b76:	8b 40 0c             	mov    0xc(%eax),%eax
  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
        p->state == SLEEPING || 
80105b79:	83 f8 04             	cmp    $0x4,%eax
80105b7c:	74 0f                	je     80105b8d <getuprocs+0x59>
        p->state == RUNNING  || 
        p->state == ZOMBIE)
80105b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b81:	8b 40 0c             	mov    0xc(%eax),%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
        p->state == SLEEPING || 
        p->state == RUNNING  || 
80105b84:	83 f8 05             	cmp    $0x5,%eax
80105b87:	0f 85 d1 00 00 00    	jne    80105c5e <getuprocs+0x12a>
        p->state == ZOMBIE)
    {

      // populate uproc struct entry in table
      table->pid  = p->pid;
80105b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b90:	8b 50 10             	mov    0x10(%eax),%edx
80105b93:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b96:	89 10                	mov    %edx,(%eax)
      table->uid  = p->uid;
80105b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b9b:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ba4:	89 50 04             	mov    %edx,0x4(%eax)
      table->gid  = p->gid;
80105ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105baa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80105bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bb3:	89 50 08             	mov    %edx,0x8(%eax)

      if (p->pid == 1) // if p is init, then set ppid to itself (1)
80105bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb9:	8b 40 10             	mov    0x10(%eax),%eax
80105bbc:	83 f8 01             	cmp    $0x1,%eax
80105bbf:	75 0c                	jne    80105bcd <getuprocs+0x99>
        table->ppid = 1;
80105bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bc4:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80105bcb:	eb 0f                	jmp    80105bdc <getuprocs+0xa8>
      else
        table->ppid = p->parent->pid;
80105bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd0:	8b 40 14             	mov    0x14(%eax),%eax
80105bd3:	8b 50 10             	mov    0x10(%eax),%edx
80105bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bd9:	89 50 0c             	mov    %edx,0xc(%eax)

      table->priority = p->priority;
80105bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bdf:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105be5:	8b 45 0c             	mov    0xc(%ebp),%eax
80105be8:	89 50 10             	mov    %edx,0x10(%eax)
      table->elapsed_ticks = ticks - p->start_ticks;
80105beb:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf4:	8b 40 7c             	mov    0x7c(%eax),%eax
80105bf7:	29 c2                	sub    %eax,%edx
80105bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bfc:	89 50 14             	mov    %edx,0x14(%eax)
      table->CPU_total_ticks = p->cpu_ticks_total;
80105bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c02:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80105c08:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c0b:	89 50 18             	mov    %edx,0x18(%eax)
      safestrcpy(table->state, states[p->state], NELEM(table->state));
80105c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c11:	8b 40 0c             	mov    0xc(%eax),%eax
80105c14:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105c1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c1e:	83 c2 1c             	add    $0x1c,%edx
80105c21:	83 ec 04             	sub    $0x4,%esp
80105c24:	6a 20                	push   $0x20
80105c26:	50                   	push   %eax
80105c27:	52                   	push   %edx
80105c28:	e8 49 0b 00 00       	call   80106776 <safestrcpy>
80105c2d:	83 c4 10             	add    $0x10,%esp
      table->size = p->sz;
80105c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c33:	8b 10                	mov    (%eax),%edx
80105c35:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c38:	89 50 3c             	mov    %edx,0x3c(%eax)
      safestrcpy(table->name, p->name, NELEM(table->name));
80105c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3e:	8d 50 6c             	lea    0x6c(%eax),%edx
80105c41:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c44:	83 c0 40             	add    $0x40,%eax
80105c47:	83 ec 04             	sub    $0x4,%esp
80105c4a:	6a 20                	push   $0x20
80105c4c:	52                   	push   %edx
80105c4d:	50                   	push   %eax
80105c4e:	e8 23 0b 00 00       	call   80106776 <safestrcpy>
80105c53:	83 c4 10             	add    $0x10,%esp

      ++table; // go to next entry
80105c56:	83 45 0c 60          	addl   $0x60,0xc(%ebp)
      ++numProcs; // inc number of procs in struct array
80105c5a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  uint numProcs = 0; // number of procs in struct array

  acquire(&ptable.lock); // get lock so we get a snapshot

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
80105c5e:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80105c65:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80105c6c:	73 0c                	jae    80105c7a <getuprocs+0x146>
80105c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c71:	3b 45 08             	cmp    0x8(%ebp),%eax
80105c74:	0f 82 e3 fe ff ff    	jb     80105b5d <getuprocs+0x29>
      ++table; // go to next entry
      ++numProcs; // inc number of procs in struct array
    }
  }

  release(&ptable.lock); // return lock
80105c7a:	83 ec 0c             	sub    $0xc,%esp
80105c7d:	68 80 49 11 80       	push   $0x80114980
80105c82:	e8 f0 06 00 00       	call   80106377 <release>
80105c87:	83 c4 10             	add    $0x10,%esp

  return numProcs;
80105c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105c8d:	c9                   	leave  
80105c8e:	c3                   	ret    

80105c8f <removeFromStateList>:

// Removes a proc "p" from a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
removeFromStateList(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
80105c8f:	55                   	push   %ebp
80105c90:	89 e5                	mov    %esp,%ebp
80105c92:	83 ec 08             	sub    $0x8,%esp
   
  // check if passed in proc is in the specified state
  if (p->state != state) {
80105c95:	8b 45 10             	mov    0x10(%ebp),%eax
80105c98:	8b 40 0c             	mov    0xc(%eax),%eax
80105c9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105c9e:	74 34                	je     80105cd4 <removeFromStateList+0x45>
    panic("The passed in proc to remove had the wrong state.");
80105ca0:	83 ec 0c             	sub    $0xc,%esp
80105ca3:	68 f8 9e 10 80       	push   $0x80109ef8
80105ca8:	e8 b9 a8 ff ff       	call   80100566 <panic>

  // search through list to find proc to remove
  while((*sList) != 0) {
  
    // if matching proc is found then remove it and return
    if ((*sList) == p) {
80105cad:	8b 45 08             	mov    0x8(%ebp),%eax
80105cb0:	8b 00                	mov    (%eax),%eax
80105cb2:	3b 45 10             	cmp    0x10(%ebp),%eax
80105cb5:	75 10                	jne    80105cc7 <removeFromStateList+0x38>
      (*sList) = p->next; // remove proc by "skipping" over it     
80105cb7:	8b 45 10             	mov    0x10(%ebp),%eax
80105cba:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80105cc3:	89 10                	mov    %edx,(%eax)
      return;
80105cc5:	eb 4b                	jmp    80105d12 <removeFromStateList+0x83>
    }

    // else, keep searching 
    sList = &(*sList)->next;
80105cc7:	8b 45 08             	mov    0x8(%ebp),%eax
80105cca:	8b 00                	mov    (%eax),%eax
80105ccc:	05 90 00 00 00       	add    $0x90,%eax
80105cd1:	89 45 08             	mov    %eax,0x8(%ebp)
  if (p->state != state) {
    panic("The passed in proc to remove had the wrong state.");
  }

  // search through list to find proc to remove
  while((*sList) != 0) {
80105cd4:	8b 45 08             	mov    0x8(%ebp),%eax
80105cd7:	8b 00                	mov    (%eax),%eax
80105cd9:	85 c0                	test   %eax,%eax
80105cdb:	75 d0                	jne    80105cad <removeFromStateList+0x1e>

    // else, keep searching 
    sList = &(*sList)->next;
  }

  cprintf("removeFromStateList: p->priority is %d p->pid is %d p->ppid is %d\n", p->priority, p->pid, p->parent->pid);
80105cdd:	8b 45 10             	mov    0x10(%ebp),%eax
80105ce0:	8b 40 14             	mov    0x14(%eax),%eax
80105ce3:	8b 48 10             	mov    0x10(%eax),%ecx
80105ce6:	8b 45 10             	mov    0x10(%ebp),%eax
80105ce9:	8b 50 10             	mov    0x10(%eax),%edx
80105cec:	8b 45 10             	mov    0x10(%ebp),%eax
80105cef:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105cf5:	51                   	push   %ecx
80105cf6:	52                   	push   %edx
80105cf7:	50                   	push   %eax
80105cf8:	68 2c 9f 10 80       	push   $0x80109f2c
80105cfd:	e8 c4 a6 ff ff       	call   801003c6 <cprintf>
80105d02:	83 c4 10             	add    $0x10,%esp
  // if it wasn't found then panic and return error
  panic("The passed in proc to remove was not found.");
80105d05:	83 ec 0c             	sub    $0xc,%esp
80105d08:	68 70 9f 10 80       	push   $0x80109f70
80105d0d:	e8 54 a8 ff ff       	call   80100566 <panic>
  
}
80105d12:	c9                   	leave  
80105d13:	c3                   	ret    

80105d14 <getFromStateListHead>:
// This is O(1) and is used to get procs from lists which are equivalent (e.g. free)
// If there the specified list is empty then panic
// Also, if the proc that is gotten has the wrong state then panic
struct proc*
getFromStateListHead(struct proc **sList, enum procstate state) // Added for Project 3: List Management
{
80105d14:	55                   	push   %ebp
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	83 ec 18             	sub    $0x18,%esp
  struct proc* head = (*sList);
80105d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80105d1d:	8b 00                	mov    (%eax),%eax
80105d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // if head exists then return gotten head proc (if correct state) and remove from sList
  if (head != 0) {
80105d22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d26:	74 2d                	je     80105d55 <getFromStateListHead+0x41>
    if (head->state != state)
80105d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2b:	8b 40 0c             	mov    0xc(%eax),%eax
80105d2e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105d31:	74 0d                	je     80105d40 <getFromStateListHead+0x2c>
      panic("The gotten head proc had the wrong state.");
80105d33:	83 ec 0c             	sub    $0xc,%esp
80105d36:	68 9c 9f 10 80       	push   $0x80109f9c
80105d3b:	e8 26 a8 ff ff       	call   80100566 <panic>
    else {
      (*sList) = (*sList)->next; // remove gotten head proc by skipping over it
80105d40:	8b 45 08             	mov    0x8(%ebp),%eax
80105d43:	8b 00                	mov    (%eax),%eax
80105d45:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80105d4e:	89 10                	mov    %edx,(%eax)
      return head;
80105d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d53:	eb 05                	jmp    80105d5a <getFromStateListHead+0x46>
    }
    
  }

  return 0; // if head doesn't exist then null is returned
80105d55:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d5a:	c9                   	leave  
80105d5b:	c3                   	ret    

80105d5c <addToStateListHead>:

// Adds a proc "p" to the head of a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
addToStateListHead(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
80105d5c:	55                   	push   %ebp
80105d5d:	89 e5                	mov    %esp,%ebp
80105d5f:	83 ec 08             	sub    $0x8,%esp
  // check if proc that is being added is correct state
  if (p->state != state) {
80105d62:	8b 45 10             	mov    0x10(%ebp),%eax
80105d65:	8b 40 0c             	mov    0xc(%eax),%eax
80105d68:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105d6b:	74 0d                	je     80105d7a <addToStateListHead+0x1e>
    panic("The passed in proc to add to head had the wrong state.");
80105d6d:	83 ec 0c             	sub    $0xc,%esp
80105d70:	68 c8 9f 10 80       	push   $0x80109fc8
80105d75:	e8 ec a7 ff ff       	call   80100566 <panic>
  }

  // add proc to head
  p->next = (*sList); // note that if the sList is empty then the next will be set to null (as expected)
80105d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80105d7d:	8b 10                	mov    (%eax),%edx
80105d7f:	8b 45 10             	mov    0x10(%ebp),%eax
80105d82:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  (*sList) = p;
80105d88:	8b 45 08             	mov    0x8(%ebp),%eax
80105d8b:	8b 55 10             	mov    0x10(%ebp),%edx
80105d8e:	89 10                	mov    %edx,(%eax)

}
80105d90:	90                   	nop
80105d91:	c9                   	leave  
80105d92:	c3                   	ret    

80105d93 <addToStateListTail>:

// Adds a proc "p" to the tail of a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
addToStateListTail(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
80105d93:	55                   	push   %ebp
80105d94:	89 e5                	mov    %esp,%ebp
80105d96:	83 ec 08             	sub    $0x8,%esp
  // check if proc that is being added is correct state
  if (p->state != state) {
80105d99:	8b 45 10             	mov    0x10(%ebp),%eax
80105d9c:	8b 40 0c             	mov    0xc(%eax),%eax
80105d9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105da2:	74 0d                	je     80105db1 <addToStateListTail+0x1e>
    panic("The passed in proc to add to tail had the wrong state.");
80105da4:	83 ec 0c             	sub    $0xc,%esp
80105da7:	68 00 a0 10 80       	push   $0x8010a000
80105dac:	e8 b5 a7 ff ff       	call   80100566 <panic>
  }
  
  // if list being added to is empty, then just add to head
  if ((*sList) == 0) {
80105db1:	8b 45 08             	mov    0x8(%ebp),%eax
80105db4:	8b 00                	mov    (%eax),%eax
80105db6:	85 c0                	test   %eax,%eax
80105db8:	75 50                	jne    80105e0a <addToStateListTail+0x77>
    (*sList) = p;
80105dba:	8b 45 08             	mov    0x8(%ebp),%eax
80105dbd:	8b 55 10             	mov    0x10(%ebp),%edx
80105dc0:	89 10                	mov    %edx,(%eax)
    p->next = 0; 
80105dc2:	8b 45 10             	mov    0x10(%ebp),%eax
80105dc5:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105dcc:	00 00 00 
80105dcf:	eb 42                	jmp    80105e13 <addToStateListTail+0x80>
  // otherwise, find the tail and add proc
  } else {
    while ((*sList) != 0) {
      
      // if tail is found then add proc and return
      if ((*sList)->next == 0) {
80105dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80105dd4:	8b 00                	mov    (%eax),%eax
80105dd6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ddc:	85 c0                	test   %eax,%eax
80105dde:	75 1d                	jne    80105dfd <addToStateListTail+0x6a>
        (*sList)->next = p;
80105de0:	8b 45 08             	mov    0x8(%ebp),%eax
80105de3:	8b 00                	mov    (%eax),%eax
80105de5:	8b 55 10             	mov    0x10(%ebp),%edx
80105de8:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        p->next = 0;
80105dee:	8b 45 10             	mov    0x10(%ebp),%eax
80105df1:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105df8:	00 00 00 
        return;
80105dfb:	eb 16                	jmp    80105e13 <addToStateListTail+0x80>
      }

      // otherwise, keep looping
      sList = &(*sList)->next; 
80105dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80105e00:	8b 00                	mov    (%eax),%eax
80105e02:	05 90 00 00 00       	add    $0x90,%eax
80105e07:	89 45 08             	mov    %eax,0x8(%ebp)
    (*sList) = p;
    p->next = 0; 

  // otherwise, find the tail and add proc
  } else {
    while ((*sList) != 0) {
80105e0a:	8b 45 08             	mov    0x8(%ebp),%eax
80105e0d:	8b 00                	mov    (%eax),%eax
80105e0f:	85 c0                	test   %eax,%eax
80105e11:	75 be                	jne    80105dd1 <addToStateListTail+0x3e>
      // otherwise, keep looping
      sList = &(*sList)->next; 
    }
  }

}
80105e13:	c9                   	leave  
80105e14:	c3                   	ret    

80105e15 <tackToStateListTail>:
// Tacks a proc p (and all of its "next" children) onto the tail of sList. 
// This function is only used when moving a list of procs between ready list priority queues.
// Also, the procs moved will have their priority decremented and their budget reset
void
tackToStateListTail(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 4: Periodic Priority Adjustment (helper)
{
80105e15:	55                   	push   %ebp
80105e16:	89 e5                	mov    %esp,%ebp
80105e18:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0;
80105e1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  // if p is null, then just return
  if (p == 0)
80105e22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105e26:	0f 84 de 00 00 00    	je     80105f0a <tackToStateListTail+0xf5>
    return;
  
  // check if proc that is being moved is correct state
  if (p->state != state)
80105e2c:	8b 45 10             	mov    0x10(%ebp),%eax
80105e2f:	8b 40 0c             	mov    0xc(%eax),%eax
80105e32:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105e35:	74 0d                	je     80105e44 <tackToStateListTail+0x2f>
    panic("The passed in proc to tack to tail had the wrong state.");
80105e37:	83 ec 0c             	sub    $0xc,%esp
80105e3a:	68 38 a0 10 80       	push   $0x8010a038
80105e3f:	e8 22 a7 ff ff       	call   80100566 <panic>

  // if list being tacked to is empty, then just add to head
  if ((*sList) == 0){
80105e44:	8b 45 08             	mov    0x8(%ebp),%eax
80105e47:	8b 00                	mov    (%eax),%eax
80105e49:	85 c0                	test   %eax,%eax
80105e4b:	0f 85 ae 00 00 00    	jne    80105eff <tackToStateListTail+0xea>
    (*sList) = p; // note that p's tail is not set to null since it is assumed its tail and its "next" children are set accordingly
80105e51:	8b 45 08             	mov    0x8(%ebp),%eax
80105e54:	8b 55 10             	mov    0x10(%ebp),%edx
80105e57:	89 10                	mov    %edx,(%eax)

    
    currPtr = p;
80105e59:	8b 45 10             	mov    0x10(%ebp),%eax
80105e5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(currPtr != 0){
80105e5f:	eb 2e                	jmp    80105e8f <tackToStateListTail+0x7a>
      currPtr->priority--;
80105e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e64:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e70:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
80105e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e79:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105e80:	01 00 00 

      currPtr = currPtr->next;
80105e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e86:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((*sList) == 0){
    (*sList) = p; // note that p's tail is not set to null since it is assumed its tail and its "next" children are set accordingly

    
    currPtr = p;
    while(currPtr != 0){
80105e8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e93:	75 cc                	jne    80105e61 <tackToStateListTail+0x4c>
80105e95:	eb 74                	jmp    80105f0b <tackToStateListTail+0xf6>
  // otherwise, find the tail and tack on p
  } else {
    while ((*sList) != 0) {
      
      // if tail is found then tack on p and return
      if ((*sList)->next == 0){
80105e97:	8b 45 08             	mov    0x8(%ebp),%eax
80105e9a:	8b 00                	mov    (%eax),%eax
80105e9c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ea2:	85 c0                	test   %eax,%eax
80105ea4:	75 4c                	jne    80105ef2 <tackToStateListTail+0xdd>
        (*sList)->next = p; // note that next is not set to null since it is assumed its tail and its "next" children are set accordingly
80105ea6:	8b 45 08             	mov    0x8(%ebp),%eax
80105ea9:	8b 00                	mov    (%eax),%eax
80105eab:	8b 55 10             	mov    0x10(%ebp),%edx
80105eae:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
         
        currPtr = p;
80105eb4:	8b 45 10             	mov    0x10(%ebp),%eax
80105eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(currPtr != 0){
80105eba:	eb 2e                	jmp    80105eea <tackToStateListTail+0xd5>
          currPtr->priority--;
80105ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ebf:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105ec5:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ecb:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
          currPtr->budget = DEFAULT_BUDGET;
80105ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed4:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105edb:	01 00 00 

          currPtr = currPtr->next;
80105ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      // if tail is found then tack on p and return
      if ((*sList)->next == 0){
        (*sList)->next = p; // note that next is not set to null since it is assumed its tail and its "next" children are set accordingly
         
        currPtr = p;
        while(currPtr != 0){
80105eea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eee:	75 cc                	jne    80105ebc <tackToStateListTail+0xa7>
          currPtr->budget = DEFAULT_BUDGET;

          currPtr = currPtr->next;
        }
        
        return;
80105ef0:	eb 19                	jmp    80105f0b <tackToStateListTail+0xf6>
      }
      
      // otherwise, keep looping
      sList = &(*sList)->next;
80105ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ef5:	8b 00                	mov    (%eax),%eax
80105ef7:	05 90 00 00 00       	add    $0x90,%eax
80105efc:	89 45 08             	mov    %eax,0x8(%ebp)
      currPtr = currPtr->next;
    }

  // otherwise, find the tail and tack on p
  } else {
    while ((*sList) != 0) {
80105eff:	8b 45 08             	mov    0x8(%ebp),%eax
80105f02:	8b 00                	mov    (%eax),%eax
80105f04:	85 c0                	test   %eax,%eax
80105f06:	75 8f                	jne    80105e97 <tackToStateListTail+0x82>
80105f08:	eb 01                	jmp    80105f0b <tackToStateListTail+0xf6>
{
  struct proc *currPtr = 0;

  // if p is null, then just return
  if (p == 0)
    return;
80105f0a:	90                   	nop
      
      // otherwise, keep looping
      sList = &(*sList)->next;
    }
  }
}
80105f0b:	c9                   	leave  
80105f0c:	c3                   	ret    

80105f0d <findMatchingProcPID>:

// find a proc whose PID is equal to the specified PID
// this function searches through all lists except the free list (as mentioned in the mailing list)
struct proc*
findMatchingProcPID(uint pid)
{
80105f0d:	55                   	push   %ebp
80105f0e:	89 e5                	mov    %esp,%ebp
80105f10:	83 ec 10             	sub    $0x10,%esp
  struct proc *currPtr = 0; 
80105f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
80105f1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105f21:	eb 3d                	jmp    80105f60 <findMatchingProcPID+0x53>
    currPtr = ptable.pLists.ready[i];
80105f23:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f26:	05 cc 09 00 00       	add    $0x9cc,%eax
80105f2b:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80105f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while(currPtr != 0) {
80105f35:	eb 1f                	jmp    80105f56 <findMatchingProcPID+0x49>
      if (currPtr->pid == pid) // check if we found the proc
80105f37:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f3a:	8b 40 10             	mov    0x10(%eax),%eax
80105f3d:	3b 45 08             	cmp    0x8(%ebp),%eax
80105f40:	75 08                	jne    80105f4a <findMatchingProcPID+0x3d>
        return currPtr;
80105f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f45:	e9 d4 00 00 00       	jmp    8010601e <findMatchingProcPID+0x111>

      currPtr = currPtr->next;
80105f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f4d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f53:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc *currPtr = 0; 

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
    currPtr = ptable.pLists.ready[i];
    while(currPtr != 0) {
80105f56:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105f5a:	75 db                	jne    80105f37 <findMatchingProcPID+0x2a>
findMatchingProcPID(uint pid)
{
  struct proc *currPtr = 0; 

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
80105f5c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105f60:	83 7d f8 03          	cmpl   $0x3,-0x8(%ebp)
80105f64:	7e bd                	jle    80105f23 <findMatchingProcPID+0x16>
      currPtr = currPtr->next;
    }
  }

  // search through sleep list
  currPtr = ptable.pLists.sleep;
80105f66:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80105f6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105f6e:	eb 1f                	jmp    80105f8f <findMatchingProcPID+0x82>
    if (currPtr->pid == pid) // check if we found the proc
80105f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f73:	8b 40 10             	mov    0x10(%eax),%eax
80105f76:	3b 45 08             	cmp    0x8(%ebp),%eax
80105f79:	75 08                	jne    80105f83 <findMatchingProcPID+0x76>
      return currPtr;
80105f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f7e:	e9 9b 00 00 00       	jmp    8010601e <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f86:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }
  }

  // search through sleep list
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0) {
80105f8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105f93:	75 db                	jne    80105f70 <findMatchingProcPID+0x63>

    currPtr = currPtr->next;
  }

  // search through zombie list
  currPtr = ptable.pLists.zombie;
80105f95:	a1 cc 70 11 80       	mov    0x801170cc,%eax
80105f9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105f9d:	eb 1c                	jmp    80105fbb <findMatchingProcPID+0xae>
    if (currPtr->pid == pid) // check if we found the proc
80105f9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fa2:	8b 40 10             	mov    0x10(%eax),%eax
80105fa5:	3b 45 08             	cmp    0x8(%ebp),%eax
80105fa8:	75 05                	jne    80105faf <findMatchingProcPID+0xa2>
      return currPtr;
80105faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fad:	eb 6f                	jmp    8010601e <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105faf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fb2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through zombie list
  currPtr = ptable.pLists.zombie;
  while(currPtr != 0) {
80105fbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105fbf:	75 de                	jne    80105f9f <findMatchingProcPID+0x92>

    currPtr = currPtr->next;
  }

  // search through running list
  currPtr = ptable.pLists.running;
80105fc1:	a1 d0 70 11 80       	mov    0x801170d0,%eax
80105fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105fc9:	eb 1c                	jmp    80105fe7 <findMatchingProcPID+0xda>
    if (currPtr->pid == pid) // check if we found the proc
80105fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fce:	8b 40 10             	mov    0x10(%eax),%eax
80105fd1:	3b 45 08             	cmp    0x8(%ebp),%eax
80105fd4:	75 05                	jne    80105fdb <findMatchingProcPID+0xce>
      return currPtr;
80105fd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fd9:	eb 43                	jmp    8010601e <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fde:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through running list
  currPtr = ptable.pLists.running;
  while(currPtr != 0) {
80105fe7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105feb:	75 de                	jne    80105fcb <findMatchingProcPID+0xbe>

    currPtr = currPtr->next;
  }

  // search through embryo list
  currPtr = ptable.pLists.embryo;
80105fed:	a1 d4 70 11 80       	mov    0x801170d4,%eax
80105ff2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105ff5:	eb 1c                	jmp    80106013 <findMatchingProcPID+0x106>
    if (currPtr->pid == pid) // check if we found the proc
80105ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ffa:	8b 40 10             	mov    0x10(%eax),%eax
80105ffd:	3b 45 08             	cmp    0x8(%ebp),%eax
80106000:	75 05                	jne    80106007 <findMatchingProcPID+0xfa>
      return currPtr;
80106002:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106005:	eb 17                	jmp    8010601e <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80106007:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010600a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106010:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through embryo list
  currPtr = ptable.pLists.embryo;
  while(currPtr != 0) {
80106013:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106017:	75 de                	jne    80105ff7 <findMatchingProcPID+0xea>

    currPtr = currPtr->next;
  }

  // if it isn't found then return null
  return 0;
80106019:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010601e:	c9                   	leave  
8010601f:	c3                   	ret    

80106020 <setpriority>:
// sets process with pid to the specified priority. Also, this resets the budget of this process.
// only checks the RUNNING, SLEEPING, and RUNNABLE process (as mentioned in mailing list)
// returns 0 on success and -1 on error (e.g. didn't find process, or invalid params)
int
setpriority(int pid, int priority) // Added for Project 4: The setpriority() System Call
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0; 
80106026:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  // check params to ensure no invalid input
  if (pid < 0 || priority < 0 || priority > MAX)
8010602d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106031:	78 0c                	js     8010603f <setpriority+0x1f>
80106033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106037:	78 06                	js     8010603f <setpriority+0x1f>
80106039:	83 7d 0c 03          	cmpl   $0x3,0xc(%ebp)
8010603d:	7e 0a                	jle    80106049 <setpriority+0x29>
    return -1;
8010603f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106044:	e9 53 01 00 00       	jmp    8010619c <setpriority+0x17c>

  acquire(&ptable.lock);
80106049:	83 ec 0c             	sub    $0xc,%esp
8010604c:	68 80 49 11 80       	push   $0x80114980
80106051:	e8 ba 02 00 00       	call   80106310 <acquire>
80106056:	83 c4 10             	add    $0x10,%esp
 
  // check running list for process pid
  currPtr = ptable.pLists.running;
80106059:	a1 d0 70 11 80       	mov    0x801170d0,%eax
8010605e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
80106061:	eb 4c                	jmp    801060af <setpriority+0x8f>
    if(currPtr->pid == pid){
80106063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106066:	8b 50 10             	mov    0x10(%eax),%edx
80106069:	8b 45 08             	mov    0x8(%ebp),%eax
8010606c:	39 c2                	cmp    %eax,%edx
8010606e:	75 33                	jne    801060a3 <setpriority+0x83>
      currPtr->priority = priority;
80106070:	8b 55 0c             	mov    0xc(%ebp),%edx
80106073:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106076:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
8010607c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607f:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80106086:	01 00 00 
      
      release(&ptable.lock); // since process was found, release lock and return 0 (success)
80106089:	83 ec 0c             	sub    $0xc,%esp
8010608c:	68 80 49 11 80       	push   $0x80114980
80106091:	e8 e1 02 00 00       	call   80106377 <release>
80106096:	83 c4 10             	add    $0x10,%esp
      return 0;
80106099:	b8 00 00 00 00       	mov    $0x0,%eax
8010609e:	e9 f9 00 00 00       	jmp    8010619c <setpriority+0x17c>
    }

    currPtr = currPtr->next;
801060a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060ac:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&ptable.lock);
 
  // check running list for process pid
  currPtr = ptable.pLists.running;
  while(currPtr != 0){
801060af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060b3:	75 ae                	jne    80106063 <setpriority+0x43>

    currPtr = currPtr->next;
  }

  // check sleep list for process pid
  currPtr = ptable.pLists.sleep;
801060b5:	a1 c8 70 11 80       	mov    0x801170c8,%eax
801060ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
801060bd:	eb 4c                	jmp    8010610b <setpriority+0xeb>

    if(currPtr->pid == pid){
801060bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c2:	8b 50 10             	mov    0x10(%eax),%edx
801060c5:	8b 45 08             	mov    0x8(%ebp),%eax
801060c8:	39 c2                	cmp    %eax,%edx
801060ca:	75 33                	jne    801060ff <setpriority+0xdf>
      currPtr->priority = priority;
801060cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801060cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d2:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
801060d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060db:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
801060e2:	01 00 00 
      
      release(&ptable.lock); // since process was found, release lock and return 0 (success)
801060e5:	83 ec 0c             	sub    $0xc,%esp
801060e8:	68 80 49 11 80       	push   $0x80114980
801060ed:	e8 85 02 00 00       	call   80106377 <release>
801060f2:	83 c4 10             	add    $0x10,%esp
      return 0;
801060f5:	b8 00 00 00 00       	mov    $0x0,%eax
801060fa:	e9 9d 00 00 00       	jmp    8010619c <setpriority+0x17c>
    }

    currPtr = currPtr->next;
801060ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106102:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106108:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // check sleep list for process pid
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0){
8010610b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010610f:	75 ae                	jne    801060bf <setpriority+0x9f>
    }

    currPtr = currPtr->next;
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){
80106111:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80106118:	eb 67                	jmp    80106181 <setpriority+0x161>

    currPtr = ptable.pLists.ready[i];
8010611a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010611d:	05 cc 09 00 00       	add    $0x9cc,%eax
80106122:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80106129:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(currPtr != 0){
8010612c:	eb 49                	jmp    80106177 <setpriority+0x157>

      if(currPtr->pid == pid){
8010612e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106131:	8b 50 10             	mov    0x10(%eax),%edx
80106134:	8b 45 08             	mov    0x8(%ebp),%eax
80106137:	39 c2                	cmp    %eax,%edx
80106139:	75 30                	jne    8010616b <setpriority+0x14b>
        currPtr->priority = priority;
8010613b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010613e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106141:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        currPtr->budget = DEFAULT_BUDGET;
80106147:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010614a:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80106151:	01 00 00 
      
        release(&ptable.lock); // since process was found, release lock and return 0 (success)
80106154:	83 ec 0c             	sub    $0xc,%esp
80106157:	68 80 49 11 80       	push   $0x80114980
8010615c:	e8 16 02 00 00       	call   80106377 <release>
80106161:	83 c4 10             	add    $0x10,%esp
        return 0;
80106164:	b8 00 00 00 00       	mov    $0x0,%eax
80106169:	eb 31                	jmp    8010619c <setpriority+0x17c>
      }

      currPtr = currPtr->next;
8010616b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106174:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){

    currPtr = ptable.pLists.ready[i];
    while(currPtr != 0){
80106177:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010617b:	75 b1                	jne    8010612e <setpriority+0x10e>
    }

    currPtr = currPtr->next;
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){
8010617d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80106181:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
80106185:	7e 93                	jle    8010611a <setpriority+0xfa>
      currPtr = currPtr->next;
    }
  }

  // if nothing was found, release lock and return -1 (error)
  release(&ptable.lock);
80106187:	83 ec 0c             	sub    $0xc,%esp
8010618a:	68 80 49 11 80       	push   $0x80114980
8010618f:	e8 e3 01 00 00       	call   80106377 <release>
80106194:	83 c4 10             	add    $0x10,%esp
  return -1;
80106197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010619c:	c9                   	leave  
8010619d:	c3                   	ret    

8010619e <doPeriodicPromotion>:

// promote all processes within ready, sleeping, and running lists by 1 priority level (this is called from scheduler when we hit ticks threshold) 
void
doPeriodicPromotion(void) // Added for Project 4: Periodic Priority Adjustment
{
8010619e:	55                   	push   %ebp
8010619f:	89 e5                	mov    %esp,%ebp
801061a1:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0;
801061a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
  // reduce priority of procs in running list (if they aren't at 0)
  currPtr = ptable.pLists.running;
801061ab:	a1 d0 70 11 80       	mov    0x801170d0,%eax
801061b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (currPtr != 0){
801061b3:	eb 3b                	jmp    801061f0 <doPeriodicPromotion+0x52>
    currPtr->budget = DEFAULT_BUDGET;
801061b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b8:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
801061bf:	01 00 00 

    if (currPtr->priority > 0){
801061c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c5:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801061cb:	85 c0                	test   %eax,%eax
801061cd:	74 15                	je     801061e4 <doPeriodicPromotion+0x46>
      currPtr->priority--;
801061cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d2:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801061d8:	8d 50 ff             	lea    -0x1(%eax),%edx
801061db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061de:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    }
      
    currPtr = currPtr->next;
801061e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801061ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc *currPtr = 0;
  
  // reduce priority of procs in running list (if they aren't at 0)
  currPtr = ptable.pLists.running;
  while (currPtr != 0){
801061f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061f4:	75 bf                	jne    801061b5 <doPeriodicPromotion+0x17>
      
    currPtr = currPtr->next;
  }

  // reduce priority of procs in sleep list (if they aren't at 0), also reset budgets
  currPtr = ptable.pLists.sleep;
801061f6:	a1 c8 70 11 80       	mov    0x801170c8,%eax
801061fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
801061fe:	eb 3b                	jmp    8010623b <doPeriodicPromotion+0x9d>
    currPtr->budget = DEFAULT_BUDGET;
80106200:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106203:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
8010620a:	01 00 00 
    
    if (currPtr->priority > 0)
8010620d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106210:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106216:	85 c0                	test   %eax,%eax
80106218:	74 15                	je     8010622f <doPeriodicPromotion+0x91>
      currPtr->priority--;
8010621a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010621d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106223:	8d 50 ff             	lea    -0x1(%eax),%edx
80106226:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106229:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)

    currPtr = currPtr->next;
8010622f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106232:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106238:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // reduce priority of procs in sleep list (if they aren't at 0), also reset budgets
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0){
8010623b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010623f:	75 bf                	jne    80106200 <doPeriodicPromotion+0x62>

    currPtr = currPtr->next;
  }

  // reset budgets of procs already in ready[0] to prevent un-needed budget-resets in the below for/while loop
  currPtr = ptable.pLists.ready[0];
80106241:	a1 b4 70 11 80       	mov    0x801170b4,%eax
80106246:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (currPtr != 0){
80106249:	eb 19                	jmp    80106264 <doPeriodicPromotion+0xc6>
    currPtr->budget = DEFAULT_BUDGET;
8010624b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010624e:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80106255:	01 00 00 
    currPtr = currPtr->next;
80106258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010625b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106261:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // reset budgets of procs already in ready[0] to prevent un-needed budget-resets in the below for/while loop
  currPtr = ptable.pLists.ready[0];
  while (currPtr != 0){
80106264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106268:	75 e1                	jne    8010624b <doPeriodicPromotion+0xad>
    currPtr->budget = DEFAULT_BUDGET;
    currPtr = currPtr->next;
  }
  
  // move procs in priorities 1 through MAX + 1 up one level (and reset their budgets)
  for(int i = 1; i < MAX + 1; ++i)
8010626a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80106271:	eb 3a                	jmp    801062ad <doPeriodicPromotion+0x10f>
    tackToStateListTail(&ptable.pLists.ready[i - 1], RUNNABLE, ptable.pLists.ready[i]);
80106273:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106276:	05 cc 09 00 00       	add    $0x9cc,%eax
8010627b:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80106282:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106285:	83 ea 01             	sub    $0x1,%edx
80106288:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
8010628e:	c1 e2 02             	shl    $0x2,%edx
80106291:	81 c2 80 49 11 80    	add    $0x80114980,%edx
80106297:	83 c2 04             	add    $0x4,%edx
8010629a:	83 ec 04             	sub    $0x4,%esp
8010629d:	50                   	push   %eax
8010629e:	6a 03                	push   $0x3
801062a0:	52                   	push   %edx
801062a1:	e8 6f fb ff ff       	call   80105e15 <tackToStateListTail>
801062a6:	83 c4 10             	add    $0x10,%esp
    currPtr->budget = DEFAULT_BUDGET;
    currPtr = currPtr->next;
  }
  
  // move procs in priorities 1 through MAX + 1 up one level (and reset their budgets)
  for(int i = 1; i < MAX + 1; ++i)
801062a9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801062ad:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
801062b1:	7e c0                	jle    80106273 <doPeriodicPromotion+0xd5>
    tackToStateListTail(&ptable.pLists.ready[i - 1], RUNNABLE, ptable.pLists.ready[i]);

}
801062b3:	90                   	nop
801062b4:	c9                   	leave  
801062b5:	c3                   	ret    

801062b6 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801062b6:	55                   	push   %ebp
801062b7:	89 e5                	mov    %esp,%ebp
801062b9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801062bc:	9c                   	pushf  
801062bd:	58                   	pop    %eax
801062be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801062c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801062c4:	c9                   	leave  
801062c5:	c3                   	ret    

801062c6 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801062c6:	55                   	push   %ebp
801062c7:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801062c9:	fa                   	cli    
}
801062ca:	90                   	nop
801062cb:	5d                   	pop    %ebp
801062cc:	c3                   	ret    

801062cd <sti>:

static inline void
sti(void)
{
801062cd:	55                   	push   %ebp
801062ce:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801062d0:	fb                   	sti    
}
801062d1:	90                   	nop
801062d2:	5d                   	pop    %ebp
801062d3:	c3                   	ret    

801062d4 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801062d4:	55                   	push   %ebp
801062d5:	89 e5                	mov    %esp,%ebp
801062d7:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801062da:	8b 55 08             	mov    0x8(%ebp),%edx
801062dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801062e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801062e3:	f0 87 02             	lock xchg %eax,(%edx)
801062e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801062e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801062ec:	c9                   	leave  
801062ed:	c3                   	ret    

801062ee <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801062ee:	55                   	push   %ebp
801062ef:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801062f1:	8b 45 08             	mov    0x8(%ebp),%eax
801062f4:	8b 55 0c             	mov    0xc(%ebp),%edx
801062f7:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801062fa:	8b 45 08             	mov    0x8(%ebp),%eax
801062fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106303:	8b 45 08             	mov    0x8(%ebp),%eax
80106306:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010630d:	90                   	nop
8010630e:	5d                   	pop    %ebp
8010630f:	c3                   	ret    

80106310 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106316:	e8 52 01 00 00       	call   8010646d <pushcli>
  if(holding(lk))
8010631b:	8b 45 08             	mov    0x8(%ebp),%eax
8010631e:	83 ec 0c             	sub    $0xc,%esp
80106321:	50                   	push   %eax
80106322:	e8 1c 01 00 00       	call   80106443 <holding>
80106327:	83 c4 10             	add    $0x10,%esp
8010632a:	85 c0                	test   %eax,%eax
8010632c:	74 0d                	je     8010633b <acquire+0x2b>
    panic("acquire");
8010632e:	83 ec 0c             	sub    $0xc,%esp
80106331:	68 70 a0 10 80       	push   $0x8010a070
80106336:	e8 2b a2 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010633b:	90                   	nop
8010633c:	8b 45 08             	mov    0x8(%ebp),%eax
8010633f:	83 ec 08             	sub    $0x8,%esp
80106342:	6a 01                	push   $0x1
80106344:	50                   	push   %eax
80106345:	e8 8a ff ff ff       	call   801062d4 <xchg>
8010634a:	83 c4 10             	add    $0x10,%esp
8010634d:	85 c0                	test   %eax,%eax
8010634f:	75 eb                	jne    8010633c <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80106351:	8b 45 08             	mov    0x8(%ebp),%eax
80106354:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010635b:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010635e:	8b 45 08             	mov    0x8(%ebp),%eax
80106361:	83 c0 0c             	add    $0xc,%eax
80106364:	83 ec 08             	sub    $0x8,%esp
80106367:	50                   	push   %eax
80106368:	8d 45 08             	lea    0x8(%ebp),%eax
8010636b:	50                   	push   %eax
8010636c:	e8 58 00 00 00       	call   801063c9 <getcallerpcs>
80106371:	83 c4 10             	add    $0x10,%esp
}
80106374:	90                   	nop
80106375:	c9                   	leave  
80106376:	c3                   	ret    

80106377 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80106377:	55                   	push   %ebp
80106378:	89 e5                	mov    %esp,%ebp
8010637a:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010637d:	83 ec 0c             	sub    $0xc,%esp
80106380:	ff 75 08             	pushl  0x8(%ebp)
80106383:	e8 bb 00 00 00       	call   80106443 <holding>
80106388:	83 c4 10             	add    $0x10,%esp
8010638b:	85 c0                	test   %eax,%eax
8010638d:	75 0d                	jne    8010639c <release+0x25>
    panic("release");
8010638f:	83 ec 0c             	sub    $0xc,%esp
80106392:	68 78 a0 10 80       	push   $0x8010a078
80106397:	e8 ca a1 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
8010639c:	8b 45 08             	mov    0x8(%ebp),%eax
8010639f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801063a6:	8b 45 08             	mov    0x8(%ebp),%eax
801063a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801063b0:	8b 45 08             	mov    0x8(%ebp),%eax
801063b3:	83 ec 08             	sub    $0x8,%esp
801063b6:	6a 00                	push   $0x0
801063b8:	50                   	push   %eax
801063b9:	e8 16 ff ff ff       	call   801062d4 <xchg>
801063be:	83 c4 10             	add    $0x10,%esp

  popcli();
801063c1:	e8 ec 00 00 00       	call   801064b2 <popcli>
}
801063c6:	90                   	nop
801063c7:	c9                   	leave  
801063c8:	c3                   	ret    

801063c9 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801063c9:	55                   	push   %ebp
801063ca:	89 e5                	mov    %esp,%ebp
801063cc:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801063cf:	8b 45 08             	mov    0x8(%ebp),%eax
801063d2:	83 e8 08             	sub    $0x8,%eax
801063d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801063d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801063df:	eb 38                	jmp    80106419 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801063e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801063e5:	74 53                	je     8010643a <getcallerpcs+0x71>
801063e7:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801063ee:	76 4a                	jbe    8010643a <getcallerpcs+0x71>
801063f0:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801063f4:	74 44                	je     8010643a <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801063f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801063f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106400:	8b 45 0c             	mov    0xc(%ebp),%eax
80106403:	01 c2                	add    %eax,%edx
80106405:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106408:	8b 40 04             	mov    0x4(%eax),%eax
8010640b:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010640d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106410:	8b 00                	mov    (%eax),%eax
80106412:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106415:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106419:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010641d:	7e c2                	jle    801063e1 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010641f:	eb 19                	jmp    8010643a <getcallerpcs+0x71>
    pcs[i] = 0;
80106421:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010642b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010642e:	01 d0                	add    %edx,%eax
80106430:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106436:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010643a:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010643e:	7e e1                	jle    80106421 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80106440:	90                   	nop
80106441:	c9                   	leave  
80106442:	c3                   	ret    

80106443 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106443:	55                   	push   %ebp
80106444:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106446:	8b 45 08             	mov    0x8(%ebp),%eax
80106449:	8b 00                	mov    (%eax),%eax
8010644b:	85 c0                	test   %eax,%eax
8010644d:	74 17                	je     80106466 <holding+0x23>
8010644f:	8b 45 08             	mov    0x8(%ebp),%eax
80106452:	8b 50 08             	mov    0x8(%eax),%edx
80106455:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010645b:	39 c2                	cmp    %eax,%edx
8010645d:	75 07                	jne    80106466 <holding+0x23>
8010645f:	b8 01 00 00 00       	mov    $0x1,%eax
80106464:	eb 05                	jmp    8010646b <holding+0x28>
80106466:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010646b:	5d                   	pop    %ebp
8010646c:	c3                   	ret    

8010646d <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010646d:	55                   	push   %ebp
8010646e:	89 e5                	mov    %esp,%ebp
80106470:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80106473:	e8 3e fe ff ff       	call   801062b6 <readeflags>
80106478:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010647b:	e8 46 fe ff ff       	call   801062c6 <cli>
  if(cpu->ncli++ == 0)
80106480:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106487:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010648d:	8d 48 01             	lea    0x1(%eax),%ecx
80106490:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106496:	85 c0                	test   %eax,%eax
80106498:	75 15                	jne    801064af <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010649a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801064a3:	81 e2 00 02 00 00    	and    $0x200,%edx
801064a9:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801064af:	90                   	nop
801064b0:	c9                   	leave  
801064b1:	c3                   	ret    

801064b2 <popcli>:

void
popcli(void)
{
801064b2:	55                   	push   %ebp
801064b3:	89 e5                	mov    %esp,%ebp
801064b5:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801064b8:	e8 f9 fd ff ff       	call   801062b6 <readeflags>
801064bd:	25 00 02 00 00       	and    $0x200,%eax
801064c2:	85 c0                	test   %eax,%eax
801064c4:	74 0d                	je     801064d3 <popcli+0x21>
    panic("popcli - interruptible");
801064c6:	83 ec 0c             	sub    $0xc,%esp
801064c9:	68 80 a0 10 80       	push   $0x8010a080
801064ce:	e8 93 a0 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801064d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064d9:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801064df:	83 ea 01             	sub    $0x1,%edx
801064e2:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801064e8:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801064ee:	85 c0                	test   %eax,%eax
801064f0:	79 0d                	jns    801064ff <popcli+0x4d>
    panic("popcli");
801064f2:	83 ec 0c             	sub    $0xc,%esp
801064f5:	68 97 a0 10 80       	push   $0x8010a097
801064fa:	e8 67 a0 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801064ff:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106505:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010650b:	85 c0                	test   %eax,%eax
8010650d:	75 15                	jne    80106524 <popcli+0x72>
8010650f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106515:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010651b:	85 c0                	test   %eax,%eax
8010651d:	74 05                	je     80106524 <popcli+0x72>
    sti();
8010651f:	e8 a9 fd ff ff       	call   801062cd <sti>
}
80106524:	90                   	nop
80106525:	c9                   	leave  
80106526:	c3                   	ret    

80106527 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106527:	55                   	push   %ebp
80106528:	89 e5                	mov    %esp,%ebp
8010652a:	57                   	push   %edi
8010652b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010652c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010652f:	8b 55 10             	mov    0x10(%ebp),%edx
80106532:	8b 45 0c             	mov    0xc(%ebp),%eax
80106535:	89 cb                	mov    %ecx,%ebx
80106537:	89 df                	mov    %ebx,%edi
80106539:	89 d1                	mov    %edx,%ecx
8010653b:	fc                   	cld    
8010653c:	f3 aa                	rep stos %al,%es:(%edi)
8010653e:	89 ca                	mov    %ecx,%edx
80106540:	89 fb                	mov    %edi,%ebx
80106542:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106545:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106548:	90                   	nop
80106549:	5b                   	pop    %ebx
8010654a:	5f                   	pop    %edi
8010654b:	5d                   	pop    %ebp
8010654c:	c3                   	ret    

8010654d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010654d:	55                   	push   %ebp
8010654e:	89 e5                	mov    %esp,%ebp
80106550:	57                   	push   %edi
80106551:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106552:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106555:	8b 55 10             	mov    0x10(%ebp),%edx
80106558:	8b 45 0c             	mov    0xc(%ebp),%eax
8010655b:	89 cb                	mov    %ecx,%ebx
8010655d:	89 df                	mov    %ebx,%edi
8010655f:	89 d1                	mov    %edx,%ecx
80106561:	fc                   	cld    
80106562:	f3 ab                	rep stos %eax,%es:(%edi)
80106564:	89 ca                	mov    %ecx,%edx
80106566:	89 fb                	mov    %edi,%ebx
80106568:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010656b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010656e:	90                   	nop
8010656f:	5b                   	pop    %ebx
80106570:	5f                   	pop    %edi
80106571:	5d                   	pop    %ebp
80106572:	c3                   	ret    

80106573 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106573:	55                   	push   %ebp
80106574:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106576:	8b 45 08             	mov    0x8(%ebp),%eax
80106579:	83 e0 03             	and    $0x3,%eax
8010657c:	85 c0                	test   %eax,%eax
8010657e:	75 43                	jne    801065c3 <memset+0x50>
80106580:	8b 45 10             	mov    0x10(%ebp),%eax
80106583:	83 e0 03             	and    $0x3,%eax
80106586:	85 c0                	test   %eax,%eax
80106588:	75 39                	jne    801065c3 <memset+0x50>
    c &= 0xFF;
8010658a:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106591:	8b 45 10             	mov    0x10(%ebp),%eax
80106594:	c1 e8 02             	shr    $0x2,%eax
80106597:	89 c1                	mov    %eax,%ecx
80106599:	8b 45 0c             	mov    0xc(%ebp),%eax
8010659c:	c1 e0 18             	shl    $0x18,%eax
8010659f:	89 c2                	mov    %eax,%edx
801065a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801065a4:	c1 e0 10             	shl    $0x10,%eax
801065a7:	09 c2                	or     %eax,%edx
801065a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801065ac:	c1 e0 08             	shl    $0x8,%eax
801065af:	09 d0                	or     %edx,%eax
801065b1:	0b 45 0c             	or     0xc(%ebp),%eax
801065b4:	51                   	push   %ecx
801065b5:	50                   	push   %eax
801065b6:	ff 75 08             	pushl  0x8(%ebp)
801065b9:	e8 8f ff ff ff       	call   8010654d <stosl>
801065be:	83 c4 0c             	add    $0xc,%esp
801065c1:	eb 12                	jmp    801065d5 <memset+0x62>
  } else
    stosb(dst, c, n);
801065c3:	8b 45 10             	mov    0x10(%ebp),%eax
801065c6:	50                   	push   %eax
801065c7:	ff 75 0c             	pushl  0xc(%ebp)
801065ca:	ff 75 08             	pushl  0x8(%ebp)
801065cd:	e8 55 ff ff ff       	call   80106527 <stosb>
801065d2:	83 c4 0c             	add    $0xc,%esp
  return dst;
801065d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801065d8:	c9                   	leave  
801065d9:	c3                   	ret    

801065da <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801065da:	55                   	push   %ebp
801065db:	89 e5                	mov    %esp,%ebp
801065dd:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801065e0:	8b 45 08             	mov    0x8(%ebp),%eax
801065e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801065e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801065e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801065ec:	eb 30                	jmp    8010661e <memcmp+0x44>
    if(*s1 != *s2)
801065ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065f1:	0f b6 10             	movzbl (%eax),%edx
801065f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801065f7:	0f b6 00             	movzbl (%eax),%eax
801065fa:	38 c2                	cmp    %al,%dl
801065fc:	74 18                	je     80106616 <memcmp+0x3c>
      return *s1 - *s2;
801065fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106601:	0f b6 00             	movzbl (%eax),%eax
80106604:	0f b6 d0             	movzbl %al,%edx
80106607:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010660a:	0f b6 00             	movzbl (%eax),%eax
8010660d:	0f b6 c0             	movzbl %al,%eax
80106610:	29 c2                	sub    %eax,%edx
80106612:	89 d0                	mov    %edx,%eax
80106614:	eb 1a                	jmp    80106630 <memcmp+0x56>
    s1++, s2++;
80106616:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010661a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010661e:	8b 45 10             	mov    0x10(%ebp),%eax
80106621:	8d 50 ff             	lea    -0x1(%eax),%edx
80106624:	89 55 10             	mov    %edx,0x10(%ebp)
80106627:	85 c0                	test   %eax,%eax
80106629:	75 c3                	jne    801065ee <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010662b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106630:	c9                   	leave  
80106631:	c3                   	ret    

80106632 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106632:	55                   	push   %ebp
80106633:	89 e5                	mov    %esp,%ebp
80106635:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106638:	8b 45 0c             	mov    0xc(%ebp),%eax
8010663b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010663e:	8b 45 08             	mov    0x8(%ebp),%eax
80106641:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106644:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106647:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010664a:	73 54                	jae    801066a0 <memmove+0x6e>
8010664c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010664f:	8b 45 10             	mov    0x10(%ebp),%eax
80106652:	01 d0                	add    %edx,%eax
80106654:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106657:	76 47                	jbe    801066a0 <memmove+0x6e>
    s += n;
80106659:	8b 45 10             	mov    0x10(%ebp),%eax
8010665c:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010665f:	8b 45 10             	mov    0x10(%ebp),%eax
80106662:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106665:	eb 13                	jmp    8010667a <memmove+0x48>
      *--d = *--s;
80106667:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010666b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010666f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106672:	0f b6 10             	movzbl (%eax),%edx
80106675:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106678:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010667a:	8b 45 10             	mov    0x10(%ebp),%eax
8010667d:	8d 50 ff             	lea    -0x1(%eax),%edx
80106680:	89 55 10             	mov    %edx,0x10(%ebp)
80106683:	85 c0                	test   %eax,%eax
80106685:	75 e0                	jne    80106667 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106687:	eb 24                	jmp    801066ad <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106689:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010668c:	8d 50 01             	lea    0x1(%eax),%edx
8010668f:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106692:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106695:	8d 4a 01             	lea    0x1(%edx),%ecx
80106698:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010669b:	0f b6 12             	movzbl (%edx),%edx
8010669e:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801066a0:	8b 45 10             	mov    0x10(%ebp),%eax
801066a3:	8d 50 ff             	lea    -0x1(%eax),%edx
801066a6:	89 55 10             	mov    %edx,0x10(%ebp)
801066a9:	85 c0                	test   %eax,%eax
801066ab:	75 dc                	jne    80106689 <memmove+0x57>
      *d++ = *s++;

  return dst;
801066ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
801066b0:	c9                   	leave  
801066b1:	c3                   	ret    

801066b2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801066b2:	55                   	push   %ebp
801066b3:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801066b5:	ff 75 10             	pushl  0x10(%ebp)
801066b8:	ff 75 0c             	pushl  0xc(%ebp)
801066bb:	ff 75 08             	pushl  0x8(%ebp)
801066be:	e8 6f ff ff ff       	call   80106632 <memmove>
801066c3:	83 c4 0c             	add    $0xc,%esp
}
801066c6:	c9                   	leave  
801066c7:	c3                   	ret    

801066c8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801066c8:	55                   	push   %ebp
801066c9:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801066cb:	eb 0c                	jmp    801066d9 <strncmp+0x11>
    n--, p++, q++;
801066cd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801066d1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801066d5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801066d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066dd:	74 1a                	je     801066f9 <strncmp+0x31>
801066df:	8b 45 08             	mov    0x8(%ebp),%eax
801066e2:	0f b6 00             	movzbl (%eax),%eax
801066e5:	84 c0                	test   %al,%al
801066e7:	74 10                	je     801066f9 <strncmp+0x31>
801066e9:	8b 45 08             	mov    0x8(%ebp),%eax
801066ec:	0f b6 10             	movzbl (%eax),%edx
801066ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801066f2:	0f b6 00             	movzbl (%eax),%eax
801066f5:	38 c2                	cmp    %al,%dl
801066f7:	74 d4                	je     801066cd <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801066f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066fd:	75 07                	jne    80106706 <strncmp+0x3e>
    return 0;
801066ff:	b8 00 00 00 00       	mov    $0x0,%eax
80106704:	eb 16                	jmp    8010671c <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106706:	8b 45 08             	mov    0x8(%ebp),%eax
80106709:	0f b6 00             	movzbl (%eax),%eax
8010670c:	0f b6 d0             	movzbl %al,%edx
8010670f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106712:	0f b6 00             	movzbl (%eax),%eax
80106715:	0f b6 c0             	movzbl %al,%eax
80106718:	29 c2                	sub    %eax,%edx
8010671a:	89 d0                	mov    %edx,%eax
}
8010671c:	5d                   	pop    %ebp
8010671d:	c3                   	ret    

8010671e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010671e:	55                   	push   %ebp
8010671f:	89 e5                	mov    %esp,%ebp
80106721:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106724:	8b 45 08             	mov    0x8(%ebp),%eax
80106727:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010672a:	90                   	nop
8010672b:	8b 45 10             	mov    0x10(%ebp),%eax
8010672e:	8d 50 ff             	lea    -0x1(%eax),%edx
80106731:	89 55 10             	mov    %edx,0x10(%ebp)
80106734:	85 c0                	test   %eax,%eax
80106736:	7e 2c                	jle    80106764 <strncpy+0x46>
80106738:	8b 45 08             	mov    0x8(%ebp),%eax
8010673b:	8d 50 01             	lea    0x1(%eax),%edx
8010673e:	89 55 08             	mov    %edx,0x8(%ebp)
80106741:	8b 55 0c             	mov    0xc(%ebp),%edx
80106744:	8d 4a 01             	lea    0x1(%edx),%ecx
80106747:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010674a:	0f b6 12             	movzbl (%edx),%edx
8010674d:	88 10                	mov    %dl,(%eax)
8010674f:	0f b6 00             	movzbl (%eax),%eax
80106752:	84 c0                	test   %al,%al
80106754:	75 d5                	jne    8010672b <strncpy+0xd>
    ;
  while(n-- > 0)
80106756:	eb 0c                	jmp    80106764 <strncpy+0x46>
    *s++ = 0;
80106758:	8b 45 08             	mov    0x8(%ebp),%eax
8010675b:	8d 50 01             	lea    0x1(%eax),%edx
8010675e:	89 55 08             	mov    %edx,0x8(%ebp)
80106761:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106764:	8b 45 10             	mov    0x10(%ebp),%eax
80106767:	8d 50 ff             	lea    -0x1(%eax),%edx
8010676a:	89 55 10             	mov    %edx,0x10(%ebp)
8010676d:	85 c0                	test   %eax,%eax
8010676f:	7f e7                	jg     80106758 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106771:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106774:	c9                   	leave  
80106775:	c3                   	ret    

80106776 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106776:	55                   	push   %ebp
80106777:	89 e5                	mov    %esp,%ebp
80106779:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010677c:	8b 45 08             	mov    0x8(%ebp),%eax
8010677f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106782:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106786:	7f 05                	jg     8010678d <safestrcpy+0x17>
    return os;
80106788:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010678b:	eb 31                	jmp    801067be <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010678d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106791:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106795:	7e 1e                	jle    801067b5 <safestrcpy+0x3f>
80106797:	8b 45 08             	mov    0x8(%ebp),%eax
8010679a:	8d 50 01             	lea    0x1(%eax),%edx
8010679d:	89 55 08             	mov    %edx,0x8(%ebp)
801067a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801067a3:	8d 4a 01             	lea    0x1(%edx),%ecx
801067a6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801067a9:	0f b6 12             	movzbl (%edx),%edx
801067ac:	88 10                	mov    %dl,(%eax)
801067ae:	0f b6 00             	movzbl (%eax),%eax
801067b1:	84 c0                	test   %al,%al
801067b3:	75 d8                	jne    8010678d <safestrcpy+0x17>
    ;
  *s = 0;
801067b5:	8b 45 08             	mov    0x8(%ebp),%eax
801067b8:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801067bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801067be:	c9                   	leave  
801067bf:	c3                   	ret    

801067c0 <strlen>:

int
strlen(const char *s)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801067c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801067cd:	eb 04                	jmp    801067d3 <strlen+0x13>
801067cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801067d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801067d6:	8b 45 08             	mov    0x8(%ebp),%eax
801067d9:	01 d0                	add    %edx,%eax
801067db:	0f b6 00             	movzbl (%eax),%eax
801067de:	84 c0                	test   %al,%al
801067e0:	75 ed                	jne    801067cf <strlen+0xf>
    ;
  return n;
801067e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801067e5:	c9                   	leave  
801067e6:	c3                   	ret    

801067e7 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801067e7:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801067eb:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801067ef:	55                   	push   %ebp
  pushl %ebx
801067f0:	53                   	push   %ebx
  pushl %esi
801067f1:	56                   	push   %esi
  pushl %edi
801067f2:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801067f3:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801067f5:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801067f7:	5f                   	pop    %edi
  popl %esi
801067f8:	5e                   	pop    %esi
  popl %ebx
801067f9:	5b                   	pop    %ebx
  popl %ebp
801067fa:	5d                   	pop    %ebp
  ret
801067fb:	c3                   	ret    

801067fc <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801067fc:	55                   	push   %ebp
801067fd:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801067ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106805:	8b 00                	mov    (%eax),%eax
80106807:	3b 45 08             	cmp    0x8(%ebp),%eax
8010680a:	76 12                	jbe    8010681e <fetchint+0x22>
8010680c:	8b 45 08             	mov    0x8(%ebp),%eax
8010680f:	8d 50 04             	lea    0x4(%eax),%edx
80106812:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106818:	8b 00                	mov    (%eax),%eax
8010681a:	39 c2                	cmp    %eax,%edx
8010681c:	76 07                	jbe    80106825 <fetchint+0x29>
    return -1;
8010681e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106823:	eb 0f                	jmp    80106834 <fetchint+0x38>
  *ip = *(int*)(addr);
80106825:	8b 45 08             	mov    0x8(%ebp),%eax
80106828:	8b 10                	mov    (%eax),%edx
8010682a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010682d:	89 10                	mov    %edx,(%eax)
  return 0;
8010682f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106834:	5d                   	pop    %ebp
80106835:	c3                   	ret    

80106836 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106836:	55                   	push   %ebp
80106837:	89 e5                	mov    %esp,%ebp
80106839:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010683c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106842:	8b 00                	mov    (%eax),%eax
80106844:	3b 45 08             	cmp    0x8(%ebp),%eax
80106847:	77 07                	ja     80106850 <fetchstr+0x1a>
    return -1;
80106849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010684e:	eb 46                	jmp    80106896 <fetchstr+0x60>
  *pp = (char*)addr;
80106850:	8b 55 08             	mov    0x8(%ebp),%edx
80106853:	8b 45 0c             	mov    0xc(%ebp),%eax
80106856:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106858:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010685e:	8b 00                	mov    (%eax),%eax
80106860:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106863:	8b 45 0c             	mov    0xc(%ebp),%eax
80106866:	8b 00                	mov    (%eax),%eax
80106868:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010686b:	eb 1c                	jmp    80106889 <fetchstr+0x53>
    if(*s == 0)
8010686d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106870:	0f b6 00             	movzbl (%eax),%eax
80106873:	84 c0                	test   %al,%al
80106875:	75 0e                	jne    80106885 <fetchstr+0x4f>
      return s - *pp;
80106877:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010687a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010687d:	8b 00                	mov    (%eax),%eax
8010687f:	29 c2                	sub    %eax,%edx
80106881:	89 d0                	mov    %edx,%eax
80106883:	eb 11                	jmp    80106896 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106885:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106889:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010688c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010688f:	72 dc                	jb     8010686d <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106891:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106896:	c9                   	leave  
80106897:	c3                   	ret    

80106898 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106898:	55                   	push   %ebp
80106899:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010689b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068a1:	8b 40 18             	mov    0x18(%eax),%eax
801068a4:	8b 40 44             	mov    0x44(%eax),%eax
801068a7:	8b 55 08             	mov    0x8(%ebp),%edx
801068aa:	c1 e2 02             	shl    $0x2,%edx
801068ad:	01 d0                	add    %edx,%eax
801068af:	83 c0 04             	add    $0x4,%eax
801068b2:	ff 75 0c             	pushl  0xc(%ebp)
801068b5:	50                   	push   %eax
801068b6:	e8 41 ff ff ff       	call   801067fc <fetchint>
801068bb:	83 c4 08             	add    $0x8,%esp
}
801068be:	c9                   	leave  
801068bf:	c3                   	ret    

801068c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801068c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
801068c9:	50                   	push   %eax
801068ca:	ff 75 08             	pushl  0x8(%ebp)
801068cd:	e8 c6 ff ff ff       	call   80106898 <argint>
801068d2:	83 c4 08             	add    $0x8,%esp
801068d5:	85 c0                	test   %eax,%eax
801068d7:	79 07                	jns    801068e0 <argptr+0x20>
    return -1;
801068d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068de:	eb 3b                	jmp    8010691b <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801068e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068e6:	8b 00                	mov    (%eax),%eax
801068e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801068eb:	39 d0                	cmp    %edx,%eax
801068ed:	76 16                	jbe    80106905 <argptr+0x45>
801068ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801068f2:	89 c2                	mov    %eax,%edx
801068f4:	8b 45 10             	mov    0x10(%ebp),%eax
801068f7:	01 c2                	add    %eax,%edx
801068f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ff:	8b 00                	mov    (%eax),%eax
80106901:	39 c2                	cmp    %eax,%edx
80106903:	76 07                	jbe    8010690c <argptr+0x4c>
    return -1;
80106905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010690a:	eb 0f                	jmp    8010691b <argptr+0x5b>
  *pp = (char*)i;
8010690c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010690f:	89 c2                	mov    %eax,%edx
80106911:	8b 45 0c             	mov    0xc(%ebp),%eax
80106914:	89 10                	mov    %edx,(%eax)
  return 0;
80106916:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010691b:	c9                   	leave  
8010691c:	c3                   	ret    

8010691d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010691d:	55                   	push   %ebp
8010691e:	89 e5                	mov    %esp,%ebp
80106920:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106923:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106926:	50                   	push   %eax
80106927:	ff 75 08             	pushl  0x8(%ebp)
8010692a:	e8 69 ff ff ff       	call   80106898 <argint>
8010692f:	83 c4 08             	add    $0x8,%esp
80106932:	85 c0                	test   %eax,%eax
80106934:	79 07                	jns    8010693d <argstr+0x20>
    return -1;
80106936:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010693b:	eb 0f                	jmp    8010694c <argstr+0x2f>
  return fetchstr(addr, pp);
8010693d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106940:	ff 75 0c             	pushl  0xc(%ebp)
80106943:	50                   	push   %eax
80106944:	e8 ed fe ff ff       	call   80106836 <fetchstr>
80106949:	83 c4 08             	add    $0x8,%esp
}
8010694c:	c9                   	leave  
8010694d:	c3                   	ret    

8010694e <syscall>:
#endif
// END: Added for Project 1: System Call Tracing

void
syscall(void)
{
8010694e:	55                   	push   %ebp
8010694f:	89 e5                	mov    %esp,%ebp
80106951:	53                   	push   %ebx
80106952:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106955:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010695b:	8b 40 18             	mov    0x18(%eax),%eax
8010695e:	8b 40 1c             	mov    0x1c(%eax),%eax
80106961:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106968:	7e 30                	jle    8010699a <syscall+0x4c>
8010696a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010696d:	83 f8 1c             	cmp    $0x1c,%eax
80106970:	77 28                	ja     8010699a <syscall+0x4c>
80106972:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106975:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
8010697c:	85 c0                	test   %eax,%eax
8010697e:	74 1a                	je     8010699a <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106980:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106986:	8b 58 18             	mov    0x18(%eax),%ebx
80106989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010698c:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106993:	ff d0                	call   *%eax
80106995:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106998:	eb 34                	jmp    801069ce <syscall+0x80>
    #endif
    // END: Added for Project 1: System Call Tracing

  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010699a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069a0:	8d 50 6c             	lea    0x6c(%eax),%edx
801069a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
            syscallnames[num], proc->tf->eax);
    #endif
    // END: Added for Project 1: System Call Tracing

  } else {
    cprintf("%d %s: unknown sys call %d\n",
801069a9:	8b 40 10             	mov    0x10(%eax),%eax
801069ac:	ff 75 f4             	pushl  -0xc(%ebp)
801069af:	52                   	push   %edx
801069b0:	50                   	push   %eax
801069b1:	68 9e a0 10 80       	push   $0x8010a09e
801069b6:	e8 0b 9a ff ff       	call   801003c6 <cprintf>
801069bb:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801069be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069c4:	8b 40 18             	mov    0x18(%eax),%eax
801069c7:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801069ce:	90                   	nop
801069cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801069d2:	c9                   	leave  
801069d3:	c3                   	ret    

801069d4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801069d4:	55                   	push   %ebp
801069d5:	89 e5                	mov    %esp,%ebp
801069d7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801069da:	83 ec 08             	sub    $0x8,%esp
801069dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069e0:	50                   	push   %eax
801069e1:	ff 75 08             	pushl  0x8(%ebp)
801069e4:	e8 af fe ff ff       	call   80106898 <argint>
801069e9:	83 c4 10             	add    $0x10,%esp
801069ec:	85 c0                	test   %eax,%eax
801069ee:	79 07                	jns    801069f7 <argfd+0x23>
    return -1;
801069f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069f5:	eb 50                	jmp    80106a47 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801069f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069fa:	85 c0                	test   %eax,%eax
801069fc:	78 21                	js     80106a1f <argfd+0x4b>
801069fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a01:	83 f8 0f             	cmp    $0xf,%eax
80106a04:	7f 19                	jg     80106a1f <argfd+0x4b>
80106a06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a0f:	83 c2 08             	add    $0x8,%edx
80106a12:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a1d:	75 07                	jne    80106a26 <argfd+0x52>
    return -1;
80106a1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a24:	eb 21                	jmp    80106a47 <argfd+0x73>
  if(pfd)
80106a26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106a2a:	74 08                	je     80106a34 <argfd+0x60>
    *pfd = fd;
80106a2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a32:	89 10                	mov    %edx,(%eax)
  if(pf)
80106a34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106a38:	74 08                	je     80106a42 <argfd+0x6e>
    *pf = f;
80106a3a:	8b 45 10             	mov    0x10(%ebp),%eax
80106a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a40:	89 10                	mov    %edx,(%eax)
  return 0;
80106a42:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a47:	c9                   	leave  
80106a48:	c3                   	ret    

80106a49 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106a49:	55                   	push   %ebp
80106a4a:	89 e5                	mov    %esp,%ebp
80106a4c:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106a4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106a56:	eb 30                	jmp    80106a88 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106a58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a61:	83 c2 08             	add    $0x8,%edx
80106a64:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106a68:	85 c0                	test   %eax,%eax
80106a6a:	75 18                	jne    80106a84 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106a6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a72:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a75:	8d 4a 08             	lea    0x8(%edx),%ecx
80106a78:	8b 55 08             	mov    0x8(%ebp),%edx
80106a7b:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106a7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106a82:	eb 0f                	jmp    80106a93 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106a84:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106a88:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106a8c:	7e ca                	jle    80106a58 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106a8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a93:	c9                   	leave  
80106a94:	c3                   	ret    

80106a95 <sys_dup>:

int
sys_dup(void)
{
80106a95:	55                   	push   %ebp
80106a96:	89 e5                	mov    %esp,%ebp
80106a98:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106a9b:	83 ec 04             	sub    $0x4,%esp
80106a9e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106aa1:	50                   	push   %eax
80106aa2:	6a 00                	push   $0x0
80106aa4:	6a 00                	push   $0x0
80106aa6:	e8 29 ff ff ff       	call   801069d4 <argfd>
80106aab:	83 c4 10             	add    $0x10,%esp
80106aae:	85 c0                	test   %eax,%eax
80106ab0:	79 07                	jns    80106ab9 <sys_dup+0x24>
    return -1;
80106ab2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ab7:	eb 31                	jmp    80106aea <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106abc:	83 ec 0c             	sub    $0xc,%esp
80106abf:	50                   	push   %eax
80106ac0:	e8 84 ff ff ff       	call   80106a49 <fdalloc>
80106ac5:	83 c4 10             	add    $0x10,%esp
80106ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106acb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106acf:	79 07                	jns    80106ad8 <sys_dup+0x43>
    return -1;
80106ad1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ad6:	eb 12                	jmp    80106aea <sys_dup+0x55>
  filedup(f);
80106ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106adb:	83 ec 0c             	sub    $0xc,%esp
80106ade:	50                   	push   %eax
80106adf:	e8 c2 a5 ff ff       	call   801010a6 <filedup>
80106ae4:	83 c4 10             	add    $0x10,%esp
  return fd;
80106ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106aea:	c9                   	leave  
80106aeb:	c3                   	ret    

80106aec <sys_read>:

int
sys_read(void)
{
80106aec:	55                   	push   %ebp
80106aed:	89 e5                	mov    %esp,%ebp
80106aef:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106af2:	83 ec 04             	sub    $0x4,%esp
80106af5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106af8:	50                   	push   %eax
80106af9:	6a 00                	push   $0x0
80106afb:	6a 00                	push   $0x0
80106afd:	e8 d2 fe ff ff       	call   801069d4 <argfd>
80106b02:	83 c4 10             	add    $0x10,%esp
80106b05:	85 c0                	test   %eax,%eax
80106b07:	78 2e                	js     80106b37 <sys_read+0x4b>
80106b09:	83 ec 08             	sub    $0x8,%esp
80106b0c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b0f:	50                   	push   %eax
80106b10:	6a 02                	push   $0x2
80106b12:	e8 81 fd ff ff       	call   80106898 <argint>
80106b17:	83 c4 10             	add    $0x10,%esp
80106b1a:	85 c0                	test   %eax,%eax
80106b1c:	78 19                	js     80106b37 <sys_read+0x4b>
80106b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b21:	83 ec 04             	sub    $0x4,%esp
80106b24:	50                   	push   %eax
80106b25:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b28:	50                   	push   %eax
80106b29:	6a 01                	push   $0x1
80106b2b:	e8 90 fd ff ff       	call   801068c0 <argptr>
80106b30:	83 c4 10             	add    $0x10,%esp
80106b33:	85 c0                	test   %eax,%eax
80106b35:	79 07                	jns    80106b3e <sys_read+0x52>
    return -1;
80106b37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b3c:	eb 17                	jmp    80106b55 <sys_read+0x69>
  return fileread(f, p, n);
80106b3e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106b41:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b47:	83 ec 04             	sub    $0x4,%esp
80106b4a:	51                   	push   %ecx
80106b4b:	52                   	push   %edx
80106b4c:	50                   	push   %eax
80106b4d:	e8 e4 a6 ff ff       	call   80101236 <fileread>
80106b52:	83 c4 10             	add    $0x10,%esp
}
80106b55:	c9                   	leave  
80106b56:	c3                   	ret    

80106b57 <sys_write>:

int
sys_write(void)
{
80106b57:	55                   	push   %ebp
80106b58:	89 e5                	mov    %esp,%ebp
80106b5a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106b5d:	83 ec 04             	sub    $0x4,%esp
80106b60:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b63:	50                   	push   %eax
80106b64:	6a 00                	push   $0x0
80106b66:	6a 00                	push   $0x0
80106b68:	e8 67 fe ff ff       	call   801069d4 <argfd>
80106b6d:	83 c4 10             	add    $0x10,%esp
80106b70:	85 c0                	test   %eax,%eax
80106b72:	78 2e                	js     80106ba2 <sys_write+0x4b>
80106b74:	83 ec 08             	sub    $0x8,%esp
80106b77:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b7a:	50                   	push   %eax
80106b7b:	6a 02                	push   $0x2
80106b7d:	e8 16 fd ff ff       	call   80106898 <argint>
80106b82:	83 c4 10             	add    $0x10,%esp
80106b85:	85 c0                	test   %eax,%eax
80106b87:	78 19                	js     80106ba2 <sys_write+0x4b>
80106b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b8c:	83 ec 04             	sub    $0x4,%esp
80106b8f:	50                   	push   %eax
80106b90:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b93:	50                   	push   %eax
80106b94:	6a 01                	push   $0x1
80106b96:	e8 25 fd ff ff       	call   801068c0 <argptr>
80106b9b:	83 c4 10             	add    $0x10,%esp
80106b9e:	85 c0                	test   %eax,%eax
80106ba0:	79 07                	jns    80106ba9 <sys_write+0x52>
    return -1;
80106ba2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ba7:	eb 17                	jmp    80106bc0 <sys_write+0x69>
  return filewrite(f, p, n);
80106ba9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106bac:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb2:	83 ec 04             	sub    $0x4,%esp
80106bb5:	51                   	push   %ecx
80106bb6:	52                   	push   %edx
80106bb7:	50                   	push   %eax
80106bb8:	e8 31 a7 ff ff       	call   801012ee <filewrite>
80106bbd:	83 c4 10             	add    $0x10,%esp
}
80106bc0:	c9                   	leave  
80106bc1:	c3                   	ret    

80106bc2 <sys_close>:

int
sys_close(void)
{
80106bc2:	55                   	push   %ebp
80106bc3:	89 e5                	mov    %esp,%ebp
80106bc5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106bc8:	83 ec 04             	sub    $0x4,%esp
80106bcb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bce:	50                   	push   %eax
80106bcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bd2:	50                   	push   %eax
80106bd3:	6a 00                	push   $0x0
80106bd5:	e8 fa fd ff ff       	call   801069d4 <argfd>
80106bda:	83 c4 10             	add    $0x10,%esp
80106bdd:	85 c0                	test   %eax,%eax
80106bdf:	79 07                	jns    80106be8 <sys_close+0x26>
    return -1;
80106be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106be6:	eb 28                	jmp    80106c10 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106be8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106bf1:	83 c2 08             	add    $0x8,%edx
80106bf4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106bfb:	00 
  fileclose(f);
80106bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bff:	83 ec 0c             	sub    $0xc,%esp
80106c02:	50                   	push   %eax
80106c03:	e8 ef a4 ff ff       	call   801010f7 <fileclose>
80106c08:	83 c4 10             	add    $0x10,%esp
  return 0;
80106c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c10:	c9                   	leave  
80106c11:	c3                   	ret    

80106c12 <sys_fstat>:

int
sys_fstat(void)
{
80106c12:	55                   	push   %ebp
80106c13:	89 e5                	mov    %esp,%ebp
80106c15:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106c18:	83 ec 04             	sub    $0x4,%esp
80106c1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c1e:	50                   	push   %eax
80106c1f:	6a 00                	push   $0x0
80106c21:	6a 00                	push   $0x0
80106c23:	e8 ac fd ff ff       	call   801069d4 <argfd>
80106c28:	83 c4 10             	add    $0x10,%esp
80106c2b:	85 c0                	test   %eax,%eax
80106c2d:	78 17                	js     80106c46 <sys_fstat+0x34>
80106c2f:	83 ec 04             	sub    $0x4,%esp
80106c32:	6a 14                	push   $0x14
80106c34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c37:	50                   	push   %eax
80106c38:	6a 01                	push   $0x1
80106c3a:	e8 81 fc ff ff       	call   801068c0 <argptr>
80106c3f:	83 c4 10             	add    $0x10,%esp
80106c42:	85 c0                	test   %eax,%eax
80106c44:	79 07                	jns    80106c4d <sys_fstat+0x3b>
    return -1;
80106c46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c4b:	eb 13                	jmp    80106c60 <sys_fstat+0x4e>
  return filestat(f, st);
80106c4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c53:	83 ec 08             	sub    $0x8,%esp
80106c56:	52                   	push   %edx
80106c57:	50                   	push   %eax
80106c58:	e8 82 a5 ff ff       	call   801011df <filestat>
80106c5d:	83 c4 10             	add    $0x10,%esp
}
80106c60:	c9                   	leave  
80106c61:	c3                   	ret    

80106c62 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106c62:	55                   	push   %ebp
80106c63:	89 e5                	mov    %esp,%ebp
80106c65:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106c68:	83 ec 08             	sub    $0x8,%esp
80106c6b:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106c6e:	50                   	push   %eax
80106c6f:	6a 00                	push   $0x0
80106c71:	e8 a7 fc ff ff       	call   8010691d <argstr>
80106c76:	83 c4 10             	add    $0x10,%esp
80106c79:	85 c0                	test   %eax,%eax
80106c7b:	78 15                	js     80106c92 <sys_link+0x30>
80106c7d:	83 ec 08             	sub    $0x8,%esp
80106c80:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106c83:	50                   	push   %eax
80106c84:	6a 01                	push   $0x1
80106c86:	e8 92 fc ff ff       	call   8010691d <argstr>
80106c8b:	83 c4 10             	add    $0x10,%esp
80106c8e:	85 c0                	test   %eax,%eax
80106c90:	79 0a                	jns    80106c9c <sys_link+0x3a>
    return -1;
80106c92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c97:	e9 68 01 00 00       	jmp    80106e04 <sys_link+0x1a2>

  begin_op();
80106c9c:	e8 52 c9 ff ff       	call   801035f3 <begin_op>
  if((ip = namei(old)) == 0){
80106ca1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106ca4:	83 ec 0c             	sub    $0xc,%esp
80106ca7:	50                   	push   %eax
80106ca8:	e8 21 b9 ff ff       	call   801025ce <namei>
80106cad:	83 c4 10             	add    $0x10,%esp
80106cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106cb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106cb7:	75 0f                	jne    80106cc8 <sys_link+0x66>
    end_op();
80106cb9:	e8 c1 c9 ff ff       	call   8010367f <end_op>
    return -1;
80106cbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cc3:	e9 3c 01 00 00       	jmp    80106e04 <sys_link+0x1a2>
  }

  ilock(ip);
80106cc8:	83 ec 0c             	sub    $0xc,%esp
80106ccb:	ff 75 f4             	pushl  -0xc(%ebp)
80106cce:	e8 3d ad ff ff       	call   80101a10 <ilock>
80106cd3:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106cdd:	66 83 f8 01          	cmp    $0x1,%ax
80106ce1:	75 1d                	jne    80106d00 <sys_link+0x9e>
    iunlockput(ip);
80106ce3:	83 ec 0c             	sub    $0xc,%esp
80106ce6:	ff 75 f4             	pushl  -0xc(%ebp)
80106ce9:	e8 e2 af ff ff       	call   80101cd0 <iunlockput>
80106cee:	83 c4 10             	add    $0x10,%esp
    end_op();
80106cf1:	e8 89 c9 ff ff       	call   8010367f <end_op>
    return -1;
80106cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cfb:	e9 04 01 00 00       	jmp    80106e04 <sys_link+0x1a2>
  }

  ip->nlink++;
80106d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d03:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106d07:	83 c0 01             	add    $0x1,%eax
80106d0a:	89 c2                	mov    %eax,%edx
80106d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d0f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106d13:	83 ec 0c             	sub    $0xc,%esp
80106d16:	ff 75 f4             	pushl  -0xc(%ebp)
80106d19:	e8 18 ab ff ff       	call   80101836 <iupdate>
80106d1e:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106d21:	83 ec 0c             	sub    $0xc,%esp
80106d24:	ff 75 f4             	pushl  -0xc(%ebp)
80106d27:	e8 42 ae ff ff       	call   80101b6e <iunlock>
80106d2c:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106d2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d32:	83 ec 08             	sub    $0x8,%esp
80106d35:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106d38:	52                   	push   %edx
80106d39:	50                   	push   %eax
80106d3a:	e8 ab b8 ff ff       	call   801025ea <nameiparent>
80106d3f:	83 c4 10             	add    $0x10,%esp
80106d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106d45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d49:	74 71                	je     80106dbc <sys_link+0x15a>
    goto bad;
  ilock(dp);
80106d4b:	83 ec 0c             	sub    $0xc,%esp
80106d4e:	ff 75 f0             	pushl  -0x10(%ebp)
80106d51:	e8 ba ac ff ff       	call   80101a10 <ilock>
80106d56:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d5c:	8b 10                	mov    (%eax),%edx
80106d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d61:	8b 00                	mov    (%eax),%eax
80106d63:	39 c2                	cmp    %eax,%edx
80106d65:	75 1d                	jne    80106d84 <sys_link+0x122>
80106d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d6a:	8b 40 04             	mov    0x4(%eax),%eax
80106d6d:	83 ec 04             	sub    $0x4,%esp
80106d70:	50                   	push   %eax
80106d71:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106d74:	50                   	push   %eax
80106d75:	ff 75 f0             	pushl  -0x10(%ebp)
80106d78:	e8 b5 b5 ff ff       	call   80102332 <dirlink>
80106d7d:	83 c4 10             	add    $0x10,%esp
80106d80:	85 c0                	test   %eax,%eax
80106d82:	79 10                	jns    80106d94 <sys_link+0x132>
    iunlockput(dp);
80106d84:	83 ec 0c             	sub    $0xc,%esp
80106d87:	ff 75 f0             	pushl  -0x10(%ebp)
80106d8a:	e8 41 af ff ff       	call   80101cd0 <iunlockput>
80106d8f:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106d92:	eb 29                	jmp    80106dbd <sys_link+0x15b>
  }
  iunlockput(dp);
80106d94:	83 ec 0c             	sub    $0xc,%esp
80106d97:	ff 75 f0             	pushl  -0x10(%ebp)
80106d9a:	e8 31 af ff ff       	call   80101cd0 <iunlockput>
80106d9f:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106da2:	83 ec 0c             	sub    $0xc,%esp
80106da5:	ff 75 f4             	pushl  -0xc(%ebp)
80106da8:	e8 33 ae ff ff       	call   80101be0 <iput>
80106dad:	83 c4 10             	add    $0x10,%esp

  end_op();
80106db0:	e8 ca c8 ff ff       	call   8010367f <end_op>

  return 0;
80106db5:	b8 00 00 00 00       	mov    $0x0,%eax
80106dba:	eb 48                	jmp    80106e04 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106dbc:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80106dbd:	83 ec 0c             	sub    $0xc,%esp
80106dc0:	ff 75 f4             	pushl  -0xc(%ebp)
80106dc3:	e8 48 ac ff ff       	call   80101a10 <ilock>
80106dc8:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dce:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106dd2:	83 e8 01             	sub    $0x1,%eax
80106dd5:	89 c2                	mov    %eax,%edx
80106dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dda:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106dde:	83 ec 0c             	sub    $0xc,%esp
80106de1:	ff 75 f4             	pushl  -0xc(%ebp)
80106de4:	e8 4d aa ff ff       	call   80101836 <iupdate>
80106de9:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106dec:	83 ec 0c             	sub    $0xc,%esp
80106def:	ff 75 f4             	pushl  -0xc(%ebp)
80106df2:	e8 d9 ae ff ff       	call   80101cd0 <iunlockput>
80106df7:	83 c4 10             	add    $0x10,%esp
  end_op();
80106dfa:	e8 80 c8 ff ff       	call   8010367f <end_op>
  return -1;
80106dff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e04:	c9                   	leave  
80106e05:	c3                   	ret    

80106e06 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106e06:	55                   	push   %ebp
80106e07:	89 e5                	mov    %esp,%ebp
80106e09:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106e0c:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106e13:	eb 40                	jmp    80106e55 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e18:	6a 10                	push   $0x10
80106e1a:	50                   	push   %eax
80106e1b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106e1e:	50                   	push   %eax
80106e1f:	ff 75 08             	pushl  0x8(%ebp)
80106e22:	e8 57 b1 ff ff       	call   80101f7e <readi>
80106e27:	83 c4 10             	add    $0x10,%esp
80106e2a:	83 f8 10             	cmp    $0x10,%eax
80106e2d:	74 0d                	je     80106e3c <isdirempty+0x36>
      panic("isdirempty: readi");
80106e2f:	83 ec 0c             	sub    $0xc,%esp
80106e32:	68 ba a0 10 80       	push   $0x8010a0ba
80106e37:	e8 2a 97 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80106e3c:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106e40:	66 85 c0             	test   %ax,%ax
80106e43:	74 07                	je     80106e4c <isdirempty+0x46>
      return 0;
80106e45:	b8 00 00 00 00       	mov    $0x0,%eax
80106e4a:	eb 1b                	jmp    80106e67 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e4f:	83 c0 10             	add    $0x10,%eax
80106e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e55:	8b 45 08             	mov    0x8(%ebp),%eax
80106e58:	8b 50 18             	mov    0x18(%eax),%edx
80106e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e5e:	39 c2                	cmp    %eax,%edx
80106e60:	77 b3                	ja     80106e15 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106e62:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106e67:	c9                   	leave  
80106e68:	c3                   	ret    

80106e69 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106e69:	55                   	push   %ebp
80106e6a:	89 e5                	mov    %esp,%ebp
80106e6c:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106e6f:	83 ec 08             	sub    $0x8,%esp
80106e72:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106e75:	50                   	push   %eax
80106e76:	6a 00                	push   $0x0
80106e78:	e8 a0 fa ff ff       	call   8010691d <argstr>
80106e7d:	83 c4 10             	add    $0x10,%esp
80106e80:	85 c0                	test   %eax,%eax
80106e82:	79 0a                	jns    80106e8e <sys_unlink+0x25>
    return -1;
80106e84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e89:	e9 bc 01 00 00       	jmp    8010704a <sys_unlink+0x1e1>

  begin_op();
80106e8e:	e8 60 c7 ff ff       	call   801035f3 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106e93:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106e96:	83 ec 08             	sub    $0x8,%esp
80106e99:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106e9c:	52                   	push   %edx
80106e9d:	50                   	push   %eax
80106e9e:	e8 47 b7 ff ff       	call   801025ea <nameiparent>
80106ea3:	83 c4 10             	add    $0x10,%esp
80106ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ea9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ead:	75 0f                	jne    80106ebe <sys_unlink+0x55>
    end_op();
80106eaf:	e8 cb c7 ff ff       	call   8010367f <end_op>
    return -1;
80106eb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eb9:	e9 8c 01 00 00       	jmp    8010704a <sys_unlink+0x1e1>
  }

  ilock(dp);
80106ebe:	83 ec 0c             	sub    $0xc,%esp
80106ec1:	ff 75 f4             	pushl  -0xc(%ebp)
80106ec4:	e8 47 ab ff ff       	call   80101a10 <ilock>
80106ec9:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106ecc:	83 ec 08             	sub    $0x8,%esp
80106ecf:	68 cc a0 10 80       	push   $0x8010a0cc
80106ed4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106ed7:	50                   	push   %eax
80106ed8:	e8 80 b3 ff ff       	call   8010225d <namecmp>
80106edd:	83 c4 10             	add    $0x10,%esp
80106ee0:	85 c0                	test   %eax,%eax
80106ee2:	0f 84 4a 01 00 00    	je     80107032 <sys_unlink+0x1c9>
80106ee8:	83 ec 08             	sub    $0x8,%esp
80106eeb:	68 ce a0 10 80       	push   $0x8010a0ce
80106ef0:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106ef3:	50                   	push   %eax
80106ef4:	e8 64 b3 ff ff       	call   8010225d <namecmp>
80106ef9:	83 c4 10             	add    $0x10,%esp
80106efc:	85 c0                	test   %eax,%eax
80106efe:	0f 84 2e 01 00 00    	je     80107032 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106f04:	83 ec 04             	sub    $0x4,%esp
80106f07:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106f0a:	50                   	push   %eax
80106f0b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106f0e:	50                   	push   %eax
80106f0f:	ff 75 f4             	pushl  -0xc(%ebp)
80106f12:	e8 61 b3 ff ff       	call   80102278 <dirlookup>
80106f17:	83 c4 10             	add    $0x10,%esp
80106f1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106f1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106f21:	0f 84 0a 01 00 00    	je     80107031 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106f27:	83 ec 0c             	sub    $0xc,%esp
80106f2a:	ff 75 f0             	pushl  -0x10(%ebp)
80106f2d:	e8 de aa ff ff       	call   80101a10 <ilock>
80106f32:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f38:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106f3c:	66 85 c0             	test   %ax,%ax
80106f3f:	7f 0d                	jg     80106f4e <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106f41:	83 ec 0c             	sub    $0xc,%esp
80106f44:	68 d1 a0 10 80       	push   $0x8010a0d1
80106f49:	e8 18 96 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f51:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106f55:	66 83 f8 01          	cmp    $0x1,%ax
80106f59:	75 25                	jne    80106f80 <sys_unlink+0x117>
80106f5b:	83 ec 0c             	sub    $0xc,%esp
80106f5e:	ff 75 f0             	pushl  -0x10(%ebp)
80106f61:	e8 a0 fe ff ff       	call   80106e06 <isdirempty>
80106f66:	83 c4 10             	add    $0x10,%esp
80106f69:	85 c0                	test   %eax,%eax
80106f6b:	75 13                	jne    80106f80 <sys_unlink+0x117>
    iunlockput(ip);
80106f6d:	83 ec 0c             	sub    $0xc,%esp
80106f70:	ff 75 f0             	pushl  -0x10(%ebp)
80106f73:	e8 58 ad ff ff       	call   80101cd0 <iunlockput>
80106f78:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106f7b:	e9 b2 00 00 00       	jmp    80107032 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106f80:	83 ec 04             	sub    $0x4,%esp
80106f83:	6a 10                	push   $0x10
80106f85:	6a 00                	push   $0x0
80106f87:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106f8a:	50                   	push   %eax
80106f8b:	e8 e3 f5 ff ff       	call   80106573 <memset>
80106f90:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106f93:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106f96:	6a 10                	push   $0x10
80106f98:	50                   	push   %eax
80106f99:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106f9c:	50                   	push   %eax
80106f9d:	ff 75 f4             	pushl  -0xc(%ebp)
80106fa0:	e8 30 b1 ff ff       	call   801020d5 <writei>
80106fa5:	83 c4 10             	add    $0x10,%esp
80106fa8:	83 f8 10             	cmp    $0x10,%eax
80106fab:	74 0d                	je     80106fba <sys_unlink+0x151>
    panic("unlink: writei");
80106fad:	83 ec 0c             	sub    $0xc,%esp
80106fb0:	68 e3 a0 10 80       	push   $0x8010a0e3
80106fb5:	e8 ac 95 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80106fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fbd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106fc1:	66 83 f8 01          	cmp    $0x1,%ax
80106fc5:	75 21                	jne    80106fe8 <sys_unlink+0x17f>
    dp->nlink--;
80106fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fca:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106fce:	83 e8 01             	sub    $0x1,%eax
80106fd1:	89 c2                	mov    %eax,%edx
80106fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fd6:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106fda:	83 ec 0c             	sub    $0xc,%esp
80106fdd:	ff 75 f4             	pushl  -0xc(%ebp)
80106fe0:	e8 51 a8 ff ff       	call   80101836 <iupdate>
80106fe5:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106fe8:	83 ec 0c             	sub    $0xc,%esp
80106feb:	ff 75 f4             	pushl  -0xc(%ebp)
80106fee:	e8 dd ac ff ff       	call   80101cd0 <iunlockput>
80106ff3:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ff9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106ffd:	83 e8 01             	sub    $0x1,%eax
80107000:	89 c2                	mov    %eax,%edx
80107002:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107005:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107009:	83 ec 0c             	sub    $0xc,%esp
8010700c:	ff 75 f0             	pushl  -0x10(%ebp)
8010700f:	e8 22 a8 ff ff       	call   80101836 <iupdate>
80107014:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107017:	83 ec 0c             	sub    $0xc,%esp
8010701a:	ff 75 f0             	pushl  -0x10(%ebp)
8010701d:	e8 ae ac ff ff       	call   80101cd0 <iunlockput>
80107022:	83 c4 10             	add    $0x10,%esp

  end_op();
80107025:	e8 55 c6 ff ff       	call   8010367f <end_op>

  return 0;
8010702a:	b8 00 00 00 00       	mov    $0x0,%eax
8010702f:	eb 19                	jmp    8010704a <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80107031:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80107032:	83 ec 0c             	sub    $0xc,%esp
80107035:	ff 75 f4             	pushl  -0xc(%ebp)
80107038:	e8 93 ac ff ff       	call   80101cd0 <iunlockput>
8010703d:	83 c4 10             	add    $0x10,%esp
  end_op();
80107040:	e8 3a c6 ff ff       	call   8010367f <end_op>
  return -1;
80107045:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010704a:	c9                   	leave  
8010704b:	c3                   	ret    

8010704c <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010704c:	55                   	push   %ebp
8010704d:	89 e5                	mov    %esp,%ebp
8010704f:	83 ec 38             	sub    $0x38,%esp
80107052:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107055:	8b 55 10             	mov    0x10(%ebp),%edx
80107058:	8b 45 14             	mov    0x14(%ebp),%eax
8010705b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010705f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80107063:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80107067:	83 ec 08             	sub    $0x8,%esp
8010706a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010706d:	50                   	push   %eax
8010706e:	ff 75 08             	pushl  0x8(%ebp)
80107071:	e8 74 b5 ff ff       	call   801025ea <nameiparent>
80107076:	83 c4 10             	add    $0x10,%esp
80107079:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010707c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107080:	75 0a                	jne    8010708c <create+0x40>
    return 0;
80107082:	b8 00 00 00 00       	mov    $0x0,%eax
80107087:	e9 90 01 00 00       	jmp    8010721c <create+0x1d0>
  ilock(dp);
8010708c:	83 ec 0c             	sub    $0xc,%esp
8010708f:	ff 75 f4             	pushl  -0xc(%ebp)
80107092:	e8 79 a9 ff ff       	call   80101a10 <ilock>
80107097:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010709a:	83 ec 04             	sub    $0x4,%esp
8010709d:	8d 45 ec             	lea    -0x14(%ebp),%eax
801070a0:	50                   	push   %eax
801070a1:	8d 45 de             	lea    -0x22(%ebp),%eax
801070a4:	50                   	push   %eax
801070a5:	ff 75 f4             	pushl  -0xc(%ebp)
801070a8:	e8 cb b1 ff ff       	call   80102278 <dirlookup>
801070ad:	83 c4 10             	add    $0x10,%esp
801070b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801070b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801070b7:	74 50                	je     80107109 <create+0xbd>
    iunlockput(dp);
801070b9:	83 ec 0c             	sub    $0xc,%esp
801070bc:	ff 75 f4             	pushl  -0xc(%ebp)
801070bf:	e8 0c ac ff ff       	call   80101cd0 <iunlockput>
801070c4:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801070c7:	83 ec 0c             	sub    $0xc,%esp
801070ca:	ff 75 f0             	pushl  -0x10(%ebp)
801070cd:	e8 3e a9 ff ff       	call   80101a10 <ilock>
801070d2:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801070d5:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801070da:	75 15                	jne    801070f1 <create+0xa5>
801070dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070df:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801070e3:	66 83 f8 02          	cmp    $0x2,%ax
801070e7:	75 08                	jne    801070f1 <create+0xa5>
      return ip;
801070e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070ec:	e9 2b 01 00 00       	jmp    8010721c <create+0x1d0>
    iunlockput(ip);
801070f1:	83 ec 0c             	sub    $0xc,%esp
801070f4:	ff 75 f0             	pushl  -0x10(%ebp)
801070f7:	e8 d4 ab ff ff       	call   80101cd0 <iunlockput>
801070fc:	83 c4 10             	add    $0x10,%esp
    return 0;
801070ff:	b8 00 00 00 00       	mov    $0x0,%eax
80107104:	e9 13 01 00 00       	jmp    8010721c <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80107109:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010710d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107110:	8b 00                	mov    (%eax),%eax
80107112:	83 ec 08             	sub    $0x8,%esp
80107115:	52                   	push   %edx
80107116:	50                   	push   %eax
80107117:	e8 43 a6 ff ff       	call   8010175f <ialloc>
8010711c:	83 c4 10             	add    $0x10,%esp
8010711f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107122:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107126:	75 0d                	jne    80107135 <create+0xe9>
    panic("create: ialloc");
80107128:	83 ec 0c             	sub    $0xc,%esp
8010712b:	68 f2 a0 10 80       	push   $0x8010a0f2
80107130:	e8 31 94 ff ff       	call   80100566 <panic>

  ilock(ip);
80107135:	83 ec 0c             	sub    $0xc,%esp
80107138:	ff 75 f0             	pushl  -0x10(%ebp)
8010713b:	e8 d0 a8 ff ff       	call   80101a10 <ilock>
80107140:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107143:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107146:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010714a:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010714e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107151:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107155:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107159:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010715c:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80107162:	83 ec 0c             	sub    $0xc,%esp
80107165:	ff 75 f0             	pushl  -0x10(%ebp)
80107168:	e8 c9 a6 ff ff       	call   80101836 <iupdate>
8010716d:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80107170:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80107175:	75 6a                	jne    801071e1 <create+0x195>
    dp->nlink++;  // for ".."
80107177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010717a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010717e:	83 c0 01             	add    $0x1,%eax
80107181:	89 c2                	mov    %eax,%edx
80107183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107186:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010718a:	83 ec 0c             	sub    $0xc,%esp
8010718d:	ff 75 f4             	pushl  -0xc(%ebp)
80107190:	e8 a1 a6 ff ff       	call   80101836 <iupdate>
80107195:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107198:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010719b:	8b 40 04             	mov    0x4(%eax),%eax
8010719e:	83 ec 04             	sub    $0x4,%esp
801071a1:	50                   	push   %eax
801071a2:	68 cc a0 10 80       	push   $0x8010a0cc
801071a7:	ff 75 f0             	pushl  -0x10(%ebp)
801071aa:	e8 83 b1 ff ff       	call   80102332 <dirlink>
801071af:	83 c4 10             	add    $0x10,%esp
801071b2:	85 c0                	test   %eax,%eax
801071b4:	78 1e                	js     801071d4 <create+0x188>
801071b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071b9:	8b 40 04             	mov    0x4(%eax),%eax
801071bc:	83 ec 04             	sub    $0x4,%esp
801071bf:	50                   	push   %eax
801071c0:	68 ce a0 10 80       	push   $0x8010a0ce
801071c5:	ff 75 f0             	pushl  -0x10(%ebp)
801071c8:	e8 65 b1 ff ff       	call   80102332 <dirlink>
801071cd:	83 c4 10             	add    $0x10,%esp
801071d0:	85 c0                	test   %eax,%eax
801071d2:	79 0d                	jns    801071e1 <create+0x195>
      panic("create dots");
801071d4:	83 ec 0c             	sub    $0xc,%esp
801071d7:	68 01 a1 10 80       	push   $0x8010a101
801071dc:	e8 85 93 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801071e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071e4:	8b 40 04             	mov    0x4(%eax),%eax
801071e7:	83 ec 04             	sub    $0x4,%esp
801071ea:	50                   	push   %eax
801071eb:	8d 45 de             	lea    -0x22(%ebp),%eax
801071ee:	50                   	push   %eax
801071ef:	ff 75 f4             	pushl  -0xc(%ebp)
801071f2:	e8 3b b1 ff ff       	call   80102332 <dirlink>
801071f7:	83 c4 10             	add    $0x10,%esp
801071fa:	85 c0                	test   %eax,%eax
801071fc:	79 0d                	jns    8010720b <create+0x1bf>
    panic("create: dirlink");
801071fe:	83 ec 0c             	sub    $0xc,%esp
80107201:	68 0d a1 10 80       	push   $0x8010a10d
80107206:	e8 5b 93 ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010720b:	83 ec 0c             	sub    $0xc,%esp
8010720e:	ff 75 f4             	pushl  -0xc(%ebp)
80107211:	e8 ba aa ff ff       	call   80101cd0 <iunlockput>
80107216:	83 c4 10             	add    $0x10,%esp

  return ip;
80107219:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010721c:	c9                   	leave  
8010721d:	c3                   	ret    

8010721e <sys_open>:

int
sys_open(void)
{
8010721e:	55                   	push   %ebp
8010721f:	89 e5                	mov    %esp,%ebp
80107221:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107224:	83 ec 08             	sub    $0x8,%esp
80107227:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010722a:	50                   	push   %eax
8010722b:	6a 00                	push   $0x0
8010722d:	e8 eb f6 ff ff       	call   8010691d <argstr>
80107232:	83 c4 10             	add    $0x10,%esp
80107235:	85 c0                	test   %eax,%eax
80107237:	78 15                	js     8010724e <sys_open+0x30>
80107239:	83 ec 08             	sub    $0x8,%esp
8010723c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010723f:	50                   	push   %eax
80107240:	6a 01                	push   $0x1
80107242:	e8 51 f6 ff ff       	call   80106898 <argint>
80107247:	83 c4 10             	add    $0x10,%esp
8010724a:	85 c0                	test   %eax,%eax
8010724c:	79 0a                	jns    80107258 <sys_open+0x3a>
    return -1;
8010724e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107253:	e9 61 01 00 00       	jmp    801073b9 <sys_open+0x19b>

  begin_op();
80107258:	e8 96 c3 ff ff       	call   801035f3 <begin_op>

  if(omode & O_CREATE){
8010725d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107260:	25 00 02 00 00       	and    $0x200,%eax
80107265:	85 c0                	test   %eax,%eax
80107267:	74 2a                	je     80107293 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80107269:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010726c:	6a 00                	push   $0x0
8010726e:	6a 00                	push   $0x0
80107270:	6a 02                	push   $0x2
80107272:	50                   	push   %eax
80107273:	e8 d4 fd ff ff       	call   8010704c <create>
80107278:	83 c4 10             	add    $0x10,%esp
8010727b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010727e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107282:	75 75                	jne    801072f9 <sys_open+0xdb>
      end_op();
80107284:	e8 f6 c3 ff ff       	call   8010367f <end_op>
      return -1;
80107289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010728e:	e9 26 01 00 00       	jmp    801073b9 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80107293:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107296:	83 ec 0c             	sub    $0xc,%esp
80107299:	50                   	push   %eax
8010729a:	e8 2f b3 ff ff       	call   801025ce <namei>
8010729f:	83 c4 10             	add    $0x10,%esp
801072a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801072a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072a9:	75 0f                	jne    801072ba <sys_open+0x9c>
      end_op();
801072ab:	e8 cf c3 ff ff       	call   8010367f <end_op>
      return -1;
801072b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072b5:	e9 ff 00 00 00       	jmp    801073b9 <sys_open+0x19b>
    }
    ilock(ip);
801072ba:	83 ec 0c             	sub    $0xc,%esp
801072bd:	ff 75 f4             	pushl  -0xc(%ebp)
801072c0:	e8 4b a7 ff ff       	call   80101a10 <ilock>
801072c5:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801072c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072cb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801072cf:	66 83 f8 01          	cmp    $0x1,%ax
801072d3:	75 24                	jne    801072f9 <sys_open+0xdb>
801072d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072d8:	85 c0                	test   %eax,%eax
801072da:	74 1d                	je     801072f9 <sys_open+0xdb>
      iunlockput(ip);
801072dc:	83 ec 0c             	sub    $0xc,%esp
801072df:	ff 75 f4             	pushl  -0xc(%ebp)
801072e2:	e8 e9 a9 ff ff       	call   80101cd0 <iunlockput>
801072e7:	83 c4 10             	add    $0x10,%esp
      end_op();
801072ea:	e8 90 c3 ff ff       	call   8010367f <end_op>
      return -1;
801072ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072f4:	e9 c0 00 00 00       	jmp    801073b9 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801072f9:	e8 3b 9d ff ff       	call   80101039 <filealloc>
801072fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107301:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107305:	74 17                	je     8010731e <sys_open+0x100>
80107307:	83 ec 0c             	sub    $0xc,%esp
8010730a:	ff 75 f0             	pushl  -0x10(%ebp)
8010730d:	e8 37 f7 ff ff       	call   80106a49 <fdalloc>
80107312:	83 c4 10             	add    $0x10,%esp
80107315:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107318:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010731c:	79 2e                	jns    8010734c <sys_open+0x12e>
    if(f)
8010731e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107322:	74 0e                	je     80107332 <sys_open+0x114>
      fileclose(f);
80107324:	83 ec 0c             	sub    $0xc,%esp
80107327:	ff 75 f0             	pushl  -0x10(%ebp)
8010732a:	e8 c8 9d ff ff       	call   801010f7 <fileclose>
8010732f:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107332:	83 ec 0c             	sub    $0xc,%esp
80107335:	ff 75 f4             	pushl  -0xc(%ebp)
80107338:	e8 93 a9 ff ff       	call   80101cd0 <iunlockput>
8010733d:	83 c4 10             	add    $0x10,%esp
    end_op();
80107340:	e8 3a c3 ff ff       	call   8010367f <end_op>
    return -1;
80107345:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010734a:	eb 6d                	jmp    801073b9 <sys_open+0x19b>
  }
  iunlock(ip);
8010734c:	83 ec 0c             	sub    $0xc,%esp
8010734f:	ff 75 f4             	pushl  -0xc(%ebp)
80107352:	e8 17 a8 ff ff       	call   80101b6e <iunlock>
80107357:	83 c4 10             	add    $0x10,%esp
  end_op();
8010735a:	e8 20 c3 ff ff       	call   8010367f <end_op>

  f->type = FD_INODE;
8010735f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107362:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80107368:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010736b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010736e:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107371:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107374:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010737b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010737e:	83 e0 01             	and    $0x1,%eax
80107381:	85 c0                	test   %eax,%eax
80107383:	0f 94 c0             	sete   %al
80107386:	89 c2                	mov    %eax,%edx
80107388:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010738b:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010738e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107391:	83 e0 01             	and    $0x1,%eax
80107394:	85 c0                	test   %eax,%eax
80107396:	75 0a                	jne    801073a2 <sys_open+0x184>
80107398:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010739b:	83 e0 02             	and    $0x2,%eax
8010739e:	85 c0                	test   %eax,%eax
801073a0:	74 07                	je     801073a9 <sys_open+0x18b>
801073a2:	b8 01 00 00 00       	mov    $0x1,%eax
801073a7:	eb 05                	jmp    801073ae <sys_open+0x190>
801073a9:	b8 00 00 00 00       	mov    $0x0,%eax
801073ae:	89 c2                	mov    %eax,%edx
801073b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073b3:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801073b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801073b9:	c9                   	leave  
801073ba:	c3                   	ret    

801073bb <sys_mkdir>:

int
sys_mkdir(void)
{
801073bb:	55                   	push   %ebp
801073bc:	89 e5                	mov    %esp,%ebp
801073be:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801073c1:	e8 2d c2 ff ff       	call   801035f3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801073c6:	83 ec 08             	sub    $0x8,%esp
801073c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801073cc:	50                   	push   %eax
801073cd:	6a 00                	push   $0x0
801073cf:	e8 49 f5 ff ff       	call   8010691d <argstr>
801073d4:	83 c4 10             	add    $0x10,%esp
801073d7:	85 c0                	test   %eax,%eax
801073d9:	78 1b                	js     801073f6 <sys_mkdir+0x3b>
801073db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073de:	6a 00                	push   $0x0
801073e0:	6a 00                	push   $0x0
801073e2:	6a 01                	push   $0x1
801073e4:	50                   	push   %eax
801073e5:	e8 62 fc ff ff       	call   8010704c <create>
801073ea:	83 c4 10             	add    $0x10,%esp
801073ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073f4:	75 0c                	jne    80107402 <sys_mkdir+0x47>
    end_op();
801073f6:	e8 84 c2 ff ff       	call   8010367f <end_op>
    return -1;
801073fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107400:	eb 18                	jmp    8010741a <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107402:	83 ec 0c             	sub    $0xc,%esp
80107405:	ff 75 f4             	pushl  -0xc(%ebp)
80107408:	e8 c3 a8 ff ff       	call   80101cd0 <iunlockput>
8010740d:	83 c4 10             	add    $0x10,%esp
  end_op();
80107410:	e8 6a c2 ff ff       	call   8010367f <end_op>
  return 0;
80107415:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010741a:	c9                   	leave  
8010741b:	c3                   	ret    

8010741c <sys_mknod>:

int
sys_mknod(void)
{
8010741c:	55                   	push   %ebp
8010741d:	89 e5                	mov    %esp,%ebp
8010741f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107422:	e8 cc c1 ff ff       	call   801035f3 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107427:	83 ec 08             	sub    $0x8,%esp
8010742a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010742d:	50                   	push   %eax
8010742e:	6a 00                	push   $0x0
80107430:	e8 e8 f4 ff ff       	call   8010691d <argstr>
80107435:	83 c4 10             	add    $0x10,%esp
80107438:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010743b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010743f:	78 4f                	js     80107490 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107441:	83 ec 08             	sub    $0x8,%esp
80107444:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107447:	50                   	push   %eax
80107448:	6a 01                	push   $0x1
8010744a:	e8 49 f4 ff ff       	call   80106898 <argint>
8010744f:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107452:	85 c0                	test   %eax,%eax
80107454:	78 3a                	js     80107490 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107456:	83 ec 08             	sub    $0x8,%esp
80107459:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010745c:	50                   	push   %eax
8010745d:	6a 02                	push   $0x2
8010745f:	e8 34 f4 ff ff       	call   80106898 <argint>
80107464:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107467:	85 c0                	test   %eax,%eax
80107469:	78 25                	js     80107490 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010746b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010746e:	0f bf c8             	movswl %ax,%ecx
80107471:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107474:	0f bf d0             	movswl %ax,%edx
80107477:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010747a:	51                   	push   %ecx
8010747b:	52                   	push   %edx
8010747c:	6a 03                	push   $0x3
8010747e:	50                   	push   %eax
8010747f:	e8 c8 fb ff ff       	call   8010704c <create>
80107484:	83 c4 10             	add    $0x10,%esp
80107487:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010748a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010748e:	75 0c                	jne    8010749c <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107490:	e8 ea c1 ff ff       	call   8010367f <end_op>
    return -1;
80107495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010749a:	eb 18                	jmp    801074b4 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010749c:	83 ec 0c             	sub    $0xc,%esp
8010749f:	ff 75 f0             	pushl  -0x10(%ebp)
801074a2:	e8 29 a8 ff ff       	call   80101cd0 <iunlockput>
801074a7:	83 c4 10             	add    $0x10,%esp
  end_op();
801074aa:	e8 d0 c1 ff ff       	call   8010367f <end_op>
  return 0;
801074af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801074b4:	c9                   	leave  
801074b5:	c3                   	ret    

801074b6 <sys_chdir>:

int
sys_chdir(void)
{
801074b6:	55                   	push   %ebp
801074b7:	89 e5                	mov    %esp,%ebp
801074b9:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801074bc:	e8 32 c1 ff ff       	call   801035f3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801074c1:	83 ec 08             	sub    $0x8,%esp
801074c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801074c7:	50                   	push   %eax
801074c8:	6a 00                	push   $0x0
801074ca:	e8 4e f4 ff ff       	call   8010691d <argstr>
801074cf:	83 c4 10             	add    $0x10,%esp
801074d2:	85 c0                	test   %eax,%eax
801074d4:	78 18                	js     801074ee <sys_chdir+0x38>
801074d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074d9:	83 ec 0c             	sub    $0xc,%esp
801074dc:	50                   	push   %eax
801074dd:	e8 ec b0 ff ff       	call   801025ce <namei>
801074e2:	83 c4 10             	add    $0x10,%esp
801074e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801074ec:	75 0c                	jne    801074fa <sys_chdir+0x44>
    end_op();
801074ee:	e8 8c c1 ff ff       	call   8010367f <end_op>
    return -1;
801074f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074f8:	eb 6e                	jmp    80107568 <sys_chdir+0xb2>
  }
  ilock(ip);
801074fa:	83 ec 0c             	sub    $0xc,%esp
801074fd:	ff 75 f4             	pushl  -0xc(%ebp)
80107500:	e8 0b a5 ff ff       	call   80101a10 <ilock>
80107505:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107508:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010750f:	66 83 f8 01          	cmp    $0x1,%ax
80107513:	74 1a                	je     8010752f <sys_chdir+0x79>
    iunlockput(ip);
80107515:	83 ec 0c             	sub    $0xc,%esp
80107518:	ff 75 f4             	pushl  -0xc(%ebp)
8010751b:	e8 b0 a7 ff ff       	call   80101cd0 <iunlockput>
80107520:	83 c4 10             	add    $0x10,%esp
    end_op();
80107523:	e8 57 c1 ff ff       	call   8010367f <end_op>
    return -1;
80107528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010752d:	eb 39                	jmp    80107568 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010752f:	83 ec 0c             	sub    $0xc,%esp
80107532:	ff 75 f4             	pushl  -0xc(%ebp)
80107535:	e8 34 a6 ff ff       	call   80101b6e <iunlock>
8010753a:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010753d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107543:	8b 40 68             	mov    0x68(%eax),%eax
80107546:	83 ec 0c             	sub    $0xc,%esp
80107549:	50                   	push   %eax
8010754a:	e8 91 a6 ff ff       	call   80101be0 <iput>
8010754f:	83 c4 10             	add    $0x10,%esp
  end_op();
80107552:	e8 28 c1 ff ff       	call   8010367f <end_op>
  proc->cwd = ip;
80107557:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010755d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107560:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107563:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107568:	c9                   	leave  
80107569:	c3                   	ret    

8010756a <sys_exec>:

int
sys_exec(void)
{
8010756a:	55                   	push   %ebp
8010756b:	89 e5                	mov    %esp,%ebp
8010756d:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107573:	83 ec 08             	sub    $0x8,%esp
80107576:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107579:	50                   	push   %eax
8010757a:	6a 00                	push   $0x0
8010757c:	e8 9c f3 ff ff       	call   8010691d <argstr>
80107581:	83 c4 10             	add    $0x10,%esp
80107584:	85 c0                	test   %eax,%eax
80107586:	78 18                	js     801075a0 <sys_exec+0x36>
80107588:	83 ec 08             	sub    $0x8,%esp
8010758b:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107591:	50                   	push   %eax
80107592:	6a 01                	push   $0x1
80107594:	e8 ff f2 ff ff       	call   80106898 <argint>
80107599:	83 c4 10             	add    $0x10,%esp
8010759c:	85 c0                	test   %eax,%eax
8010759e:	79 0a                	jns    801075aa <sys_exec+0x40>
    return -1;
801075a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075a5:	e9 c6 00 00 00       	jmp    80107670 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801075aa:	83 ec 04             	sub    $0x4,%esp
801075ad:	68 80 00 00 00       	push   $0x80
801075b2:	6a 00                	push   $0x0
801075b4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801075ba:	50                   	push   %eax
801075bb:	e8 b3 ef ff ff       	call   80106573 <memset>
801075c0:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801075c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801075ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075cd:	83 f8 1f             	cmp    $0x1f,%eax
801075d0:	76 0a                	jbe    801075dc <sys_exec+0x72>
      return -1;
801075d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075d7:	e9 94 00 00 00       	jmp    80107670 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801075dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075df:	c1 e0 02             	shl    $0x2,%eax
801075e2:	89 c2                	mov    %eax,%edx
801075e4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801075ea:	01 c2                	add    %eax,%edx
801075ec:	83 ec 08             	sub    $0x8,%esp
801075ef:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801075f5:	50                   	push   %eax
801075f6:	52                   	push   %edx
801075f7:	e8 00 f2 ff ff       	call   801067fc <fetchint>
801075fc:	83 c4 10             	add    $0x10,%esp
801075ff:	85 c0                	test   %eax,%eax
80107601:	79 07                	jns    8010760a <sys_exec+0xa0>
      return -1;
80107603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107608:	eb 66                	jmp    80107670 <sys_exec+0x106>
    if(uarg == 0){
8010760a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107610:	85 c0                	test   %eax,%eax
80107612:	75 27                	jne    8010763b <sys_exec+0xd1>
      argv[i] = 0;
80107614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107617:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010761e:	00 00 00 00 
      break;
80107622:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107623:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107626:	83 ec 08             	sub    $0x8,%esp
80107629:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010762f:	52                   	push   %edx
80107630:	50                   	push   %eax
80107631:	e8 e1 95 ff ff       	call   80100c17 <exec>
80107636:	83 c4 10             	add    $0x10,%esp
80107639:	eb 35                	jmp    80107670 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010763b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107641:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107644:	c1 e2 02             	shl    $0x2,%edx
80107647:	01 c2                	add    %eax,%edx
80107649:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010764f:	83 ec 08             	sub    $0x8,%esp
80107652:	52                   	push   %edx
80107653:	50                   	push   %eax
80107654:	e8 dd f1 ff ff       	call   80106836 <fetchstr>
80107659:	83 c4 10             	add    $0x10,%esp
8010765c:	85 c0                	test   %eax,%eax
8010765e:	79 07                	jns    80107667 <sys_exec+0xfd>
      return -1;
80107660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107665:	eb 09                	jmp    80107670 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107667:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010766b:	e9 5a ff ff ff       	jmp    801075ca <sys_exec+0x60>
  return exec(path, argv);
}
80107670:	c9                   	leave  
80107671:	c3                   	ret    

80107672 <sys_pipe>:

int
sys_pipe(void)
{
80107672:	55                   	push   %ebp
80107673:	89 e5                	mov    %esp,%ebp
80107675:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107678:	83 ec 04             	sub    $0x4,%esp
8010767b:	6a 08                	push   $0x8
8010767d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107680:	50                   	push   %eax
80107681:	6a 00                	push   $0x0
80107683:	e8 38 f2 ff ff       	call   801068c0 <argptr>
80107688:	83 c4 10             	add    $0x10,%esp
8010768b:	85 c0                	test   %eax,%eax
8010768d:	79 0a                	jns    80107699 <sys_pipe+0x27>
    return -1;
8010768f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107694:	e9 af 00 00 00       	jmp    80107748 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107699:	83 ec 08             	sub    $0x8,%esp
8010769c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010769f:	50                   	push   %eax
801076a0:	8d 45 e8             	lea    -0x18(%ebp),%eax
801076a3:	50                   	push   %eax
801076a4:	e8 3e ca ff ff       	call   801040e7 <pipealloc>
801076a9:	83 c4 10             	add    $0x10,%esp
801076ac:	85 c0                	test   %eax,%eax
801076ae:	79 0a                	jns    801076ba <sys_pipe+0x48>
    return -1;
801076b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076b5:	e9 8e 00 00 00       	jmp    80107748 <sys_pipe+0xd6>
  fd0 = -1;
801076ba:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801076c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801076c4:	83 ec 0c             	sub    $0xc,%esp
801076c7:	50                   	push   %eax
801076c8:	e8 7c f3 ff ff       	call   80106a49 <fdalloc>
801076cd:	83 c4 10             	add    $0x10,%esp
801076d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801076d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801076d7:	78 18                	js     801076f1 <sys_pipe+0x7f>
801076d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076dc:	83 ec 0c             	sub    $0xc,%esp
801076df:	50                   	push   %eax
801076e0:	e8 64 f3 ff ff       	call   80106a49 <fdalloc>
801076e5:	83 c4 10             	add    $0x10,%esp
801076e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801076eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801076ef:	79 3f                	jns    80107730 <sys_pipe+0xbe>
    if(fd0 >= 0)
801076f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801076f5:	78 14                	js     8010770b <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801076f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107700:	83 c2 08             	add    $0x8,%edx
80107703:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010770a:	00 
    fileclose(rf);
8010770b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010770e:	83 ec 0c             	sub    $0xc,%esp
80107711:	50                   	push   %eax
80107712:	e8 e0 99 ff ff       	call   801010f7 <fileclose>
80107717:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010771a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010771d:	83 ec 0c             	sub    $0xc,%esp
80107720:	50                   	push   %eax
80107721:	e8 d1 99 ff ff       	call   801010f7 <fileclose>
80107726:	83 c4 10             	add    $0x10,%esp
    return -1;
80107729:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010772e:	eb 18                	jmp    80107748 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107730:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107733:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107736:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107738:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010773b:	8d 50 04             	lea    0x4(%eax),%edx
8010773e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107741:	89 02                	mov    %eax,(%edx)
  return 0;
80107743:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107748:	c9                   	leave  
80107749:	c3                   	ret    

8010774a <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
8010774a:	55                   	push   %ebp
8010774b:	89 e5                	mov    %esp,%ebp
8010774d:	83 ec 08             	sub    $0x8,%esp
80107750:	8b 55 08             	mov    0x8(%ebp),%edx
80107753:	8b 45 0c             	mov    0xc(%ebp),%eax
80107756:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010775a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010775e:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107762:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107766:	66 ef                	out    %ax,(%dx)
}
80107768:	90                   	nop
80107769:	c9                   	leave  
8010776a:	c3                   	ret    

8010776b <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
8010776b:	55                   	push   %ebp
8010776c:	89 e5                	mov    %esp,%ebp
8010776e:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107771:	e8 32 d2 ff ff       	call   801049a8 <fork>
}
80107776:	c9                   	leave  
80107777:	c3                   	ret    

80107778 <sys_exit>:

int
sys_exit(void)
{
80107778:	55                   	push   %ebp
80107779:	89 e5                	mov    %esp,%ebp
8010777b:	83 ec 08             	sub    $0x8,%esp
  exit();
8010777e:	e8 54 d4 ff ff       	call   80104bd7 <exit>
  return 0;  // not reached
80107783:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107788:	c9                   	leave  
80107789:	c3                   	ret    

8010778a <sys_wait>:

int
sys_wait(void)
{
8010778a:	55                   	push   %ebp
8010778b:	89 e5                	mov    %esp,%ebp
8010778d:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107790:	e8 0c d7 ff ff       	call   80104ea1 <wait>
}
80107795:	c9                   	leave  
80107796:	c3                   	ret    

80107797 <sys_kill>:

int
sys_kill(void)
{
80107797:	55                   	push   %ebp
80107798:	89 e5                	mov    %esp,%ebp
8010779a:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010779d:	83 ec 08             	sub    $0x8,%esp
801077a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801077a3:	50                   	push   %eax
801077a4:	6a 00                	push   $0x0
801077a6:	e8 ed f0 ff ff       	call   80106898 <argint>
801077ab:	83 c4 10             	add    $0x10,%esp
801077ae:	85 c0                	test   %eax,%eax
801077b0:	79 07                	jns    801077b9 <sys_kill+0x22>
    return -1;
801077b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077b7:	eb 0f                	jmp    801077c8 <sys_kill+0x31>
  return kill(pid);
801077b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bc:	83 ec 0c             	sub    $0xc,%esp
801077bf:	50                   	push   %eax
801077c0:	e8 9a dd ff ff       	call   8010555f <kill>
801077c5:	83 c4 10             	add    $0x10,%esp
}
801077c8:	c9                   	leave  
801077c9:	c3                   	ret    

801077ca <sys_getpid>:

int
sys_getpid(void)
{
801077ca:	55                   	push   %ebp
801077cb:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801077cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077d3:	8b 40 10             	mov    0x10(%eax),%eax
}
801077d6:	5d                   	pop    %ebp
801077d7:	c3                   	ret    

801077d8 <sys_sbrk>:

int
sys_sbrk(void)
{
801077d8:	55                   	push   %ebp
801077d9:	89 e5                	mov    %esp,%ebp
801077db:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801077de:	83 ec 08             	sub    $0x8,%esp
801077e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801077e4:	50                   	push   %eax
801077e5:	6a 00                	push   $0x0
801077e7:	e8 ac f0 ff ff       	call   80106898 <argint>
801077ec:	83 c4 10             	add    $0x10,%esp
801077ef:	85 c0                	test   %eax,%eax
801077f1:	79 07                	jns    801077fa <sys_sbrk+0x22>
    return -1;
801077f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077f8:	eb 28                	jmp    80107822 <sys_sbrk+0x4a>
  addr = proc->sz;
801077fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107800:	8b 00                	mov    (%eax),%eax
80107802:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107805:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107808:	83 ec 0c             	sub    $0xc,%esp
8010780b:	50                   	push   %eax
8010780c:	e8 f4 d0 ff ff       	call   80104905 <growproc>
80107811:	83 c4 10             	add    $0x10,%esp
80107814:	85 c0                	test   %eax,%eax
80107816:	79 07                	jns    8010781f <sys_sbrk+0x47>
    return -1;
80107818:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010781d:	eb 03                	jmp    80107822 <sys_sbrk+0x4a>
  return addr;
8010781f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107822:	c9                   	leave  
80107823:	c3                   	ret    

80107824 <sys_sleep>:

int
sys_sleep(void)
{
80107824:	55                   	push   %ebp
80107825:	89 e5                	mov    %esp,%ebp
80107827:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010782a:	83 ec 08             	sub    $0x8,%esp
8010782d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107830:	50                   	push   %eax
80107831:	6a 00                	push   $0x0
80107833:	e8 60 f0 ff ff       	call   80106898 <argint>
80107838:	83 c4 10             	add    $0x10,%esp
8010783b:	85 c0                	test   %eax,%eax
8010783d:	79 07                	jns    80107846 <sys_sleep+0x22>
    return -1;
8010783f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107844:	eb 44                	jmp    8010788a <sys_sleep+0x66>
  ticks0 = ticks;
80107846:	a1 e0 78 11 80       	mov    0x801178e0,%eax
8010784b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010784e:	eb 26                	jmp    80107876 <sys_sleep+0x52>
    if(proc->killed){
80107850:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107856:	8b 40 24             	mov    0x24(%eax),%eax
80107859:	85 c0                	test   %eax,%eax
8010785b:	74 07                	je     80107864 <sys_sleep+0x40>
      return -1;
8010785d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107862:	eb 26                	jmp    8010788a <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107864:	83 ec 08             	sub    $0x8,%esp
80107867:	6a 00                	push   $0x0
80107869:	68 e0 78 11 80       	push   $0x801178e0
8010786e:	e8 5a db ff ff       	call   801053cd <sleep>
80107873:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107876:	a1 e0 78 11 80       	mov    0x801178e0,%eax
8010787b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010787e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107881:	39 d0                	cmp    %edx,%eax
80107883:	72 cb                	jb     80107850 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107885:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010788a:	c9                   	leave  
8010788b:	c3                   	ret    

8010788c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
8010788c:	55                   	push   %ebp
8010788d:	89 e5                	mov    %esp,%ebp
8010788f:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107892:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80107897:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
8010789a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010789d:	c9                   	leave  
8010789e:	c3                   	ret    

8010789f <sys_halt>:

//Turn of the computer
int sys_halt(void){
8010789f:	55                   	push   %ebp
801078a0:	89 e5                	mov    %esp,%ebp
801078a2:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
801078a5:	83 ec 0c             	sub    $0xc,%esp
801078a8:	68 1d a1 10 80       	push   $0x8010a11d
801078ad:	e8 14 8b ff ff       	call   801003c6 <cprintf>
801078b2:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
801078b5:	83 ec 08             	sub    $0x8,%esp
801078b8:	68 00 20 00 00       	push   $0x2000
801078bd:	68 04 06 00 00       	push   $0x604
801078c2:	e8 83 fe ff ff       	call   8010774a <outw>
801078c7:	83 c4 10             	add    $0x10,%esp
  return 0;
801078ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
801078cf:	c9                   	leave  
801078d0:	c3                   	ret    

801078d1 <sys_date>:

// returns the rtcdate
int
sys_date(void) // Added for Project 1: The date() System Call
{
801078d1:	55                   	push   %ebp
801078d2:	89 e5                	mov    %esp,%ebp
801078d4:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if(argptr(0, (void*)&d, sizeof(*d)) < 0)
801078d7:	83 ec 04             	sub    $0x4,%esp
801078da:	6a 18                	push   $0x18
801078dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801078df:	50                   	push   %eax
801078e0:	6a 00                	push   $0x0
801078e2:	e8 d9 ef ff ff       	call   801068c0 <argptr>
801078e7:	83 c4 10             	add    $0x10,%esp
801078ea:	85 c0                	test   %eax,%eax
801078ec:	79 07                	jns    801078f5 <sys_date+0x24>
    return -1;
801078ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078f3:	eb 14                	jmp    80107909 <sys_date+0x38>

  cmostime(d);
801078f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f8:	83 ec 0c             	sub    $0xc,%esp
801078fb:	50                   	push   %eax
801078fc:	e8 6d b9 ff ff       	call   8010326e <cmostime>
80107901:	83 c4 10             	add    $0x10,%esp
  return 0;
80107904:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107909:	c9                   	leave  
8010790a:	c3                   	ret    

8010790b <sys_getuid>:

// START: Added for Project 2: UIDs and GIDs and PPIDs
// get uid of current process
int
sys_getuid(void)
{
8010790b:	55                   	push   %ebp
8010790c:	89 e5                	mov    %esp,%ebp
  return proc->uid;
8010790e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107914:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
8010791a:	5d                   	pop    %ebp
8010791b:	c3                   	ret    

8010791c <sys_getgid>:

// get gid of current process
int
sys_getgid(void)
{
8010791c:	55                   	push   %ebp
8010791d:	89 e5                	mov    %esp,%ebp
  return proc->gid;
8010791f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107925:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
8010792b:	5d                   	pop    %ebp
8010792c:	c3                   	ret    

8010792d <sys_getppid>:

// get pid of parent process (init is its own parent)
int
sys_getppid(void)
{
8010792d:	55                   	push   %ebp
8010792e:	89 e5                	mov    %esp,%ebp
  if (proc->pid == 1)
80107930:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107936:	8b 40 10             	mov    0x10(%eax),%eax
80107939:	83 f8 01             	cmp    $0x1,%eax
8010793c:	75 07                	jne    80107945 <sys_getppid+0x18>
    return 1;
8010793e:	b8 01 00 00 00       	mov    $0x1,%eax
80107943:	eb 0c                	jmp    80107951 <sys_getppid+0x24>
  else
    return proc->parent->pid;
80107945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010794b:	8b 40 14             	mov    0x14(%eax),%eax
8010794e:	8b 40 10             	mov    0x10(%eax),%eax
}
80107951:	5d                   	pop    %ebp
80107952:	c3                   	ret    

80107953 <sys_setuid>:

// set uid
int
sys_setuid(void)
{
80107953:	55                   	push   %ebp
80107954:	89 e5                	mov    %esp,%ebp
80107956:	83 ec 18             	sub    $0x18,%esp
  int uid;

  if (argint(0, &uid) < 0)
80107959:	83 ec 08             	sub    $0x8,%esp
8010795c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010795f:	50                   	push   %eax
80107960:	6a 00                	push   $0x0
80107962:	e8 31 ef ff ff       	call   80106898 <argint>
80107967:	83 c4 10             	add    $0x10,%esp
8010796a:	85 c0                	test   %eax,%eax
8010796c:	79 07                	jns    80107975 <sys_setuid+0x22>
    return -1;
8010796e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107973:	eb 2c                	jmp    801079a1 <sys_setuid+0x4e>
  
  if (0 <= uid && uid <= 32767){
80107975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107978:	85 c0                	test   %eax,%eax
8010797a:	78 20                	js     8010799c <sys_setuid+0x49>
8010797c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797f:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107984:	7f 16                	jg     8010799c <sys_setuid+0x49>
    proc->uid = uid;
80107986:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010798c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010798f:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    return 0;
80107995:	b8 00 00 00 00       	mov    $0x0,%eax
8010799a:	eb 05                	jmp    801079a1 <sys_setuid+0x4e>
  }
  else
    return -1;
8010799c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
801079a1:	c9                   	leave  
801079a2:	c3                   	ret    

801079a3 <sys_setgid>:

// set gid
int
sys_setgid(void)
{
801079a3:	55                   	push   %ebp
801079a4:	89 e5                	mov    %esp,%ebp
801079a6:	83 ec 18             	sub    $0x18,%esp
  int gid;

  if (argint(0, &gid) < 0)
801079a9:	83 ec 08             	sub    $0x8,%esp
801079ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801079af:	50                   	push   %eax
801079b0:	6a 00                	push   $0x0
801079b2:	e8 e1 ee ff ff       	call   80106898 <argint>
801079b7:	83 c4 10             	add    $0x10,%esp
801079ba:	85 c0                	test   %eax,%eax
801079bc:	79 07                	jns    801079c5 <sys_setgid+0x22>
    return -1;
801079be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079c3:	eb 2c                	jmp    801079f1 <sys_setgid+0x4e>

  if (0 <= gid && gid <= 32767){
801079c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c8:	85 c0                	test   %eax,%eax
801079ca:	78 20                	js     801079ec <sys_setgid+0x49>
801079cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079cf:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801079d4:	7f 16                	jg     801079ec <sys_setgid+0x49>
    proc->gid = gid;
801079d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801079dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801079df:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    return 0;
801079e5:	b8 00 00 00 00       	mov    $0x0,%eax
801079ea:	eb 05                	jmp    801079f1 <sys_setgid+0x4e>
  }
  else
    return -1;
801079ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079f1:	c9                   	leave  
801079f2:	c3                   	ret    

801079f3 <sys_getprocs>:
// END: Added for Project 2: UIDs and GIDs and PPIDs

// get list of procs (for ps display)
int
sys_getprocs(void) // Added for Project 2: The "ps" Command
{
801079f3:	55                   	push   %ebp
801079f4:	89 e5                	mov    %esp,%ebp
801079f6:	83 ec 18             	sub    $0x18,%esp
  int max;
  struct uproc *table;

  if (argint(0, &max) < 0)
801079f9:	83 ec 08             	sub    $0x8,%esp
801079fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801079ff:	50                   	push   %eax
80107a00:	6a 00                	push   $0x0
80107a02:	e8 91 ee ff ff       	call   80106898 <argint>
80107a07:	83 c4 10             	add    $0x10,%esp
80107a0a:	85 c0                	test   %eax,%eax
80107a0c:	79 07                	jns    80107a15 <sys_getprocs+0x22>
    return -1;
80107a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a13:	eb 31                	jmp    80107a46 <sys_getprocs+0x53>

  if (argptr(1, (void*)&table, sizeof(*table)) < 0)
80107a15:	83 ec 04             	sub    $0x4,%esp
80107a18:	6a 60                	push   $0x60
80107a1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a1d:	50                   	push   %eax
80107a1e:	6a 01                	push   $0x1
80107a20:	e8 9b ee ff ff       	call   801068c0 <argptr>
80107a25:	83 c4 10             	add    $0x10,%esp
80107a28:	85 c0                	test   %eax,%eax
80107a2a:	79 07                	jns    80107a33 <sys_getprocs+0x40>
    return -1;
80107a2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a31:	eb 13                	jmp    80107a46 <sys_getprocs+0x53>

  return getuprocs(max, table); // get uproc struct array from proc.c
80107a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a39:	83 ec 08             	sub    $0x8,%esp
80107a3c:	50                   	push   %eax
80107a3d:	52                   	push   %edx
80107a3e:	e8 f1 e0 ff ff       	call   80105b34 <getuprocs>
80107a43:	83 c4 10             	add    $0x10,%esp
}
80107a46:	c9                   	leave  
80107a47:	c3                   	ret    

80107a48 <sys_setpriority>:

// sets proc with PID of pid to priority and resets budget
// returns 0 on success and -1 on error
int
sys_setpriority(void) // Added for Project 4: The setpriority() System Call
{
80107a48:	55                   	push   %ebp
80107a49:	89 e5                	mov    %esp,%ebp
80107a4b:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int priority;

  // get pid/ priority parameters off stack (return -1 on error)
  if(argint(0, &pid) < 0)
80107a4e:	83 ec 08             	sub    $0x8,%esp
80107a51:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107a54:	50                   	push   %eax
80107a55:	6a 00                	push   $0x0
80107a57:	e8 3c ee ff ff       	call   80106898 <argint>
80107a5c:	83 c4 10             	add    $0x10,%esp
80107a5f:	85 c0                	test   %eax,%eax
80107a61:	79 07                	jns    80107a6a <sys_setpriority+0x22>
    return -1;
80107a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a68:	eb 4c                	jmp    80107ab6 <sys_setpriority+0x6e>
  if(argint(1, &priority) < 0)
80107a6a:	83 ec 08             	sub    $0x8,%esp
80107a6d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a70:	50                   	push   %eax
80107a71:	6a 01                	push   $0x1
80107a73:	e8 20 ee ff ff       	call   80106898 <argint>
80107a78:	83 c4 10             	add    $0x10,%esp
80107a7b:	85 c0                	test   %eax,%eax
80107a7d:	79 07                	jns    80107a86 <sys_setpriority+0x3e>
    return -1;
80107a7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a84:	eb 30                	jmp    80107ab6 <sys_setpriority+0x6e>

  // check if parameters have valid values (return -1 on error)
  if (pid < 0 || priority < 0 || priority > MAX)
80107a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a89:	85 c0                	test   %eax,%eax
80107a8b:	78 0f                	js     80107a9c <sys_setpriority+0x54>
80107a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a90:	85 c0                	test   %eax,%eax
80107a92:	78 08                	js     80107a9c <sys_setpriority+0x54>
80107a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a97:	83 f8 03             	cmp    $0x3,%eax
80107a9a:	7e 07                	jle    80107aa3 <sys_setpriority+0x5b>
    return -1;
80107a9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107aa1:	eb 13                	jmp    80107ab6 <sys_setpriority+0x6e>

  // call setpriority (and return its return code)
  return setpriority(pid, priority);
80107aa3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa9:	83 ec 08             	sub    $0x8,%esp
80107aac:	52                   	push   %edx
80107aad:	50                   	push   %eax
80107aae:	e8 6d e5 ff ff       	call   80106020 <setpriority>
80107ab3:	83 c4 10             	add    $0x10,%esp
}
80107ab6:	c9                   	leave  
80107ab7:	c3                   	ret    

80107ab8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107ab8:	55                   	push   %ebp
80107ab9:	89 e5                	mov    %esp,%ebp
80107abb:	83 ec 08             	sub    $0x8,%esp
80107abe:	8b 55 08             	mov    0x8(%ebp),%edx
80107ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ac4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107ac8:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107acb:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107acf:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107ad3:	ee                   	out    %al,(%dx)
}
80107ad4:	90                   	nop
80107ad5:	c9                   	leave  
80107ad6:	c3                   	ret    

80107ad7 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80107ad7:	55                   	push   %ebp
80107ad8:	89 e5                	mov    %esp,%ebp
80107ada:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107add:	6a 34                	push   $0x34
80107adf:	6a 43                	push   $0x43
80107ae1:	e8 d2 ff ff ff       	call   80107ab8 <outb>
80107ae6:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107ae9:	68 9c 00 00 00       	push   $0x9c
80107aee:	6a 40                	push   $0x40
80107af0:	e8 c3 ff ff ff       	call   80107ab8 <outb>
80107af5:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80107af8:	6a 2e                	push   $0x2e
80107afa:	6a 40                	push   $0x40
80107afc:	e8 b7 ff ff ff       	call   80107ab8 <outb>
80107b01:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80107b04:	83 ec 0c             	sub    $0xc,%esp
80107b07:	6a 00                	push   $0x0
80107b09:	e8 c3 c4 ff ff       	call   80103fd1 <picenable>
80107b0e:	83 c4 10             	add    $0x10,%esp
}
80107b11:	90                   	nop
80107b12:	c9                   	leave  
80107b13:	c3                   	ret    

80107b14 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107b14:	1e                   	push   %ds
  pushl %es
80107b15:	06                   	push   %es
  pushl %fs
80107b16:	0f a0                	push   %fs
  pushl %gs
80107b18:	0f a8                	push   %gs
  pushal
80107b1a:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107b1b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107b1f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107b21:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107b23:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107b27:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107b29:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107b2b:	54                   	push   %esp
  call trap
80107b2c:	e8 ce 01 00 00       	call   80107cff <trap>
  addl $4, %esp
80107b31:	83 c4 04             	add    $0x4,%esp

80107b34 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107b34:	61                   	popa   
  popl %gs
80107b35:	0f a9                	pop    %gs
  popl %fs
80107b37:	0f a1                	pop    %fs
  popl %es
80107b39:	07                   	pop    %es
  popl %ds
80107b3a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107b3b:	83 c4 08             	add    $0x8,%esp
  iret
80107b3e:	cf                   	iret   

80107b3f <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80107b3f:	55                   	push   %ebp
80107b40:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80107b42:	8b 45 08             	mov    0x8(%ebp),%eax
80107b45:	f0 ff 00             	lock incl (%eax)
}
80107b48:	90                   	nop
80107b49:	5d                   	pop    %ebp
80107b4a:	c3                   	ret    

80107b4b <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107b4b:	55                   	push   %ebp
80107b4c:	89 e5                	mov    %esp,%ebp
80107b4e:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107b51:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b54:	83 e8 01             	sub    $0x1,%eax
80107b57:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107b5e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107b62:	8b 45 08             	mov    0x8(%ebp),%eax
80107b65:	c1 e8 10             	shr    $0x10,%eax
80107b68:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107b6c:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107b6f:	0f 01 18             	lidtl  (%eax)
}
80107b72:	90                   	nop
80107b73:	c9                   	leave  
80107b74:	c3                   	ret    

80107b75 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80107b75:	55                   	push   %ebp
80107b76:	89 e5                	mov    %esp,%ebp
80107b78:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107b7b:	0f 20 d0             	mov    %cr2,%eax
80107b7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107b81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107b84:	c9                   	leave  
80107b85:	c3                   	ret    

80107b86 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80107b86:	55                   	push   %ebp
80107b87:	89 e5                	mov    %esp,%ebp
80107b89:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107b8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107b93:	e9 c3 00 00 00       	jmp    80107c5b <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107b98:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b9b:	8b 04 85 b4 d0 10 80 	mov    -0x7fef2f4c(,%eax,4),%eax
80107ba2:	89 c2                	mov    %eax,%edx
80107ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ba7:	66 89 14 c5 e0 70 11 	mov    %dx,-0x7fee8f20(,%eax,8)
80107bae:	80 
80107baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bb2:	66 c7 04 c5 e2 70 11 	movw   $0x8,-0x7fee8f1e(,%eax,8)
80107bb9:	80 08 00 
80107bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bbf:	0f b6 14 c5 e4 70 11 	movzbl -0x7fee8f1c(,%eax,8),%edx
80107bc6:	80 
80107bc7:	83 e2 e0             	and    $0xffffffe0,%edx
80107bca:	88 14 c5 e4 70 11 80 	mov    %dl,-0x7fee8f1c(,%eax,8)
80107bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bd4:	0f b6 14 c5 e4 70 11 	movzbl -0x7fee8f1c(,%eax,8),%edx
80107bdb:	80 
80107bdc:	83 e2 1f             	and    $0x1f,%edx
80107bdf:	88 14 c5 e4 70 11 80 	mov    %dl,-0x7fee8f1c(,%eax,8)
80107be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107be9:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80107bf0:	80 
80107bf1:	83 e2 f0             	and    $0xfffffff0,%edx
80107bf4:	83 ca 0e             	or     $0xe,%edx
80107bf7:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80107bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c01:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80107c08:	80 
80107c09:	83 e2 ef             	and    $0xffffffef,%edx
80107c0c:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80107c13:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c16:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80107c1d:	80 
80107c1e:	83 e2 9f             	and    $0xffffff9f,%edx
80107c21:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80107c28:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c2b:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80107c32:	80 
80107c33:	83 ca 80             	or     $0xffffff80,%edx
80107c36:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80107c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c40:	8b 04 85 b4 d0 10 80 	mov    -0x7fef2f4c(,%eax,4),%eax
80107c47:	c1 e8 10             	shr    $0x10,%eax
80107c4a:	89 c2                	mov    %eax,%edx
80107c4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c4f:	66 89 14 c5 e6 70 11 	mov    %dx,-0x7fee8f1a(,%eax,8)
80107c56:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107c57:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107c5b:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107c62:	0f 8e 30 ff ff ff    	jle    80107b98 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107c68:	a1 b4 d1 10 80       	mov    0x8010d1b4,%eax
80107c6d:	66 a3 e0 72 11 80    	mov    %ax,0x801172e0
80107c73:	66 c7 05 e2 72 11 80 	movw   $0x8,0x801172e2
80107c7a:	08 00 
80107c7c:	0f b6 05 e4 72 11 80 	movzbl 0x801172e4,%eax
80107c83:	83 e0 e0             	and    $0xffffffe0,%eax
80107c86:	a2 e4 72 11 80       	mov    %al,0x801172e4
80107c8b:	0f b6 05 e4 72 11 80 	movzbl 0x801172e4,%eax
80107c92:	83 e0 1f             	and    $0x1f,%eax
80107c95:	a2 e4 72 11 80       	mov    %al,0x801172e4
80107c9a:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107ca1:	83 c8 0f             	or     $0xf,%eax
80107ca4:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107ca9:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107cb0:	83 e0 ef             	and    $0xffffffef,%eax
80107cb3:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107cb8:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107cbf:	83 c8 60             	or     $0x60,%eax
80107cc2:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107cc7:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107cce:	83 c8 80             	or     $0xffffff80,%eax
80107cd1:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107cd6:	a1 b4 d1 10 80       	mov    0x8010d1b4,%eax
80107cdb:	c1 e8 10             	shr    $0x10,%eax
80107cde:	66 a3 e6 72 11 80    	mov    %ax,0x801172e6
  
}
80107ce4:	90                   	nop
80107ce5:	c9                   	leave  
80107ce6:	c3                   	ret    

80107ce7 <idtinit>:

void
idtinit(void)
{
80107ce7:	55                   	push   %ebp
80107ce8:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107cea:	68 00 08 00 00       	push   $0x800
80107cef:	68 e0 70 11 80       	push   $0x801170e0
80107cf4:	e8 52 fe ff ff       	call   80107b4b <lidt>
80107cf9:	83 c4 08             	add    $0x8,%esp
}
80107cfc:	90                   	nop
80107cfd:	c9                   	leave  
80107cfe:	c3                   	ret    

80107cff <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107cff:	55                   	push   %ebp
80107d00:	89 e5                	mov    %esp,%ebp
80107d02:	57                   	push   %edi
80107d03:	56                   	push   %esi
80107d04:	53                   	push   %ebx
80107d05:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107d08:	8b 45 08             	mov    0x8(%ebp),%eax
80107d0b:	8b 40 30             	mov    0x30(%eax),%eax
80107d0e:	83 f8 40             	cmp    $0x40,%eax
80107d11:	75 3e                	jne    80107d51 <trap+0x52>
    if(proc->killed)
80107d13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d19:	8b 40 24             	mov    0x24(%eax),%eax
80107d1c:	85 c0                	test   %eax,%eax
80107d1e:	74 05                	je     80107d25 <trap+0x26>
      exit();
80107d20:	e8 b2 ce ff ff       	call   80104bd7 <exit>
    proc->tf = tf;
80107d25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d2b:	8b 55 08             	mov    0x8(%ebp),%edx
80107d2e:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107d31:	e8 18 ec ff ff       	call   8010694e <syscall>
    if(proc->killed)
80107d36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d3c:	8b 40 24             	mov    0x24(%eax),%eax
80107d3f:	85 c0                	test   %eax,%eax
80107d41:	0f 84 fe 01 00 00    	je     80107f45 <trap+0x246>
      exit();
80107d47:	e8 8b ce ff ff       	call   80104bd7 <exit>
    return;
80107d4c:	e9 f4 01 00 00       	jmp    80107f45 <trap+0x246>
  }

  switch(tf->trapno){
80107d51:	8b 45 08             	mov    0x8(%ebp),%eax
80107d54:	8b 40 30             	mov    0x30(%eax),%eax
80107d57:	83 e8 20             	sub    $0x20,%eax
80107d5a:	83 f8 1f             	cmp    $0x1f,%eax
80107d5d:	0f 87 a3 00 00 00    	ja     80107e06 <trap+0x107>
80107d63:	8b 04 85 d0 a1 10 80 	mov    -0x7fef5e30(,%eax,4),%eax
80107d6a:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80107d6c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d72:	0f b6 00             	movzbl (%eax),%eax
80107d75:	84 c0                	test   %al,%al
80107d77:	75 20                	jne    80107d99 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107d79:	83 ec 0c             	sub    $0xc,%esp
80107d7c:	68 e0 78 11 80       	push   $0x801178e0
80107d81:	e8 b9 fd ff ff       	call   80107b3f <atom_inc>
80107d86:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107d89:	83 ec 0c             	sub    $0xc,%esp
80107d8c:	68 e0 78 11 80       	push   $0x801178e0
80107d91:	e8 92 d7 ff ff       	call   80105528 <wakeup>
80107d96:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107d99:	e8 2d b3 ff ff       	call   801030cb <lapiceoi>
    break;
80107d9e:	e9 1c 01 00 00       	jmp    80107ebf <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107da3:	e8 36 ab ff ff       	call   801028de <ideintr>
    lapiceoi();
80107da8:	e8 1e b3 ff ff       	call   801030cb <lapiceoi>
    break;
80107dad:	e9 0d 01 00 00       	jmp    80107ebf <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107db2:	e8 16 b1 ff ff       	call   80102ecd <kbdintr>
    lapiceoi();
80107db7:	e8 0f b3 ff ff       	call   801030cb <lapiceoi>
    break;
80107dbc:	e9 fe 00 00 00       	jmp    80107ebf <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107dc1:	e8 60 03 00 00       	call   80108126 <uartintr>
    lapiceoi();
80107dc6:	e8 00 b3 ff ff       	call   801030cb <lapiceoi>
    break;
80107dcb:	e9 ef 00 00 00       	jmp    80107ebf <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107dd0:	8b 45 08             	mov    0x8(%ebp),%eax
80107dd3:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80107dd9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107ddd:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107de0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107de6:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107de9:	0f b6 c0             	movzbl %al,%eax
80107dec:	51                   	push   %ecx
80107ded:	52                   	push   %edx
80107dee:	50                   	push   %eax
80107def:	68 30 a1 10 80       	push   $0x8010a130
80107df4:	e8 cd 85 ff ff       	call   801003c6 <cprintf>
80107df9:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107dfc:	e8 ca b2 ff ff       	call   801030cb <lapiceoi>
    break;
80107e01:	e9 b9 00 00 00       	jmp    80107ebf <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107e06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e0c:	85 c0                	test   %eax,%eax
80107e0e:	74 11                	je     80107e21 <trap+0x122>
80107e10:	8b 45 08             	mov    0x8(%ebp),%eax
80107e13:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107e17:	0f b7 c0             	movzwl %ax,%eax
80107e1a:	83 e0 03             	and    $0x3,%eax
80107e1d:	85 c0                	test   %eax,%eax
80107e1f:	75 40                	jne    80107e61 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107e21:	e8 4f fd ff ff       	call   80107b75 <rcr2>
80107e26:	89 c3                	mov    %eax,%ebx
80107e28:	8b 45 08             	mov    0x8(%ebp),%eax
80107e2b:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107e2e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e34:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107e37:	0f b6 d0             	movzbl %al,%edx
80107e3a:	8b 45 08             	mov    0x8(%ebp),%eax
80107e3d:	8b 40 30             	mov    0x30(%eax),%eax
80107e40:	83 ec 0c             	sub    $0xc,%esp
80107e43:	53                   	push   %ebx
80107e44:	51                   	push   %ecx
80107e45:	52                   	push   %edx
80107e46:	50                   	push   %eax
80107e47:	68 54 a1 10 80       	push   $0x8010a154
80107e4c:	e8 75 85 ff ff       	call   801003c6 <cprintf>
80107e51:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107e54:	83 ec 0c             	sub    $0xc,%esp
80107e57:	68 86 a1 10 80       	push   $0x8010a186
80107e5c:	e8 05 87 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e61:	e8 0f fd ff ff       	call   80107b75 <rcr2>
80107e66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e69:	8b 45 08             	mov    0x8(%ebp),%eax
80107e6c:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107e6f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e75:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e78:	0f b6 d8             	movzbl %al,%ebx
80107e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e7e:	8b 48 34             	mov    0x34(%eax),%ecx
80107e81:	8b 45 08             	mov    0x8(%ebp),%eax
80107e84:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107e87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e8d:	8d 78 6c             	lea    0x6c(%eax),%edi
80107e90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e96:	8b 40 10             	mov    0x10(%eax),%eax
80107e99:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e9c:	56                   	push   %esi
80107e9d:	53                   	push   %ebx
80107e9e:	51                   	push   %ecx
80107e9f:	52                   	push   %edx
80107ea0:	57                   	push   %edi
80107ea1:	50                   	push   %eax
80107ea2:	68 8c a1 10 80       	push   $0x8010a18c
80107ea7:	e8 1a 85 ff ff       	call   801003c6 <cprintf>
80107eac:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107eaf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107eb5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107ebc:	eb 01                	jmp    80107ebf <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107ebe:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107ebf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ec5:	85 c0                	test   %eax,%eax
80107ec7:	74 24                	je     80107eed <trap+0x1ee>
80107ec9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ecf:	8b 40 24             	mov    0x24(%eax),%eax
80107ed2:	85 c0                	test   %eax,%eax
80107ed4:	74 17                	je     80107eed <trap+0x1ee>
80107ed6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107edd:	0f b7 c0             	movzwl %ax,%eax
80107ee0:	83 e0 03             	and    $0x3,%eax
80107ee3:	83 f8 03             	cmp    $0x3,%eax
80107ee6:	75 05                	jne    80107eed <trap+0x1ee>
    exit();
80107ee8:	e8 ea cc ff ff       	call   80104bd7 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107eed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ef3:	85 c0                	test   %eax,%eax
80107ef5:	74 1e                	je     80107f15 <trap+0x216>
80107ef7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107efd:	8b 40 0c             	mov    0xc(%eax),%eax
80107f00:	83 f8 04             	cmp    $0x4,%eax
80107f03:	75 10                	jne    80107f15 <trap+0x216>
80107f05:	8b 45 08             	mov    0x8(%ebp),%eax
80107f08:	8b 40 30             	mov    0x30(%eax),%eax
80107f0b:	83 f8 20             	cmp    $0x20,%eax
80107f0e:	75 05                	jne    80107f15 <trap+0x216>
    yield();
80107f10:	e8 05 d4 ff ff       	call   8010531a <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107f15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f1b:	85 c0                	test   %eax,%eax
80107f1d:	74 27                	je     80107f46 <trap+0x247>
80107f1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f25:	8b 40 24             	mov    0x24(%eax),%eax
80107f28:	85 c0                	test   %eax,%eax
80107f2a:	74 1a                	je     80107f46 <trap+0x247>
80107f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80107f2f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107f33:	0f b7 c0             	movzwl %ax,%eax
80107f36:	83 e0 03             	and    $0x3,%eax
80107f39:	83 f8 03             	cmp    $0x3,%eax
80107f3c:	75 08                	jne    80107f46 <trap+0x247>
    exit();
80107f3e:	e8 94 cc ff ff       	call   80104bd7 <exit>
80107f43:	eb 01                	jmp    80107f46 <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107f45:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f49:	5b                   	pop    %ebx
80107f4a:	5e                   	pop    %esi
80107f4b:	5f                   	pop    %edi
80107f4c:	5d                   	pop    %ebp
80107f4d:	c3                   	ret    

80107f4e <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80107f4e:	55                   	push   %ebp
80107f4f:	89 e5                	mov    %esp,%ebp
80107f51:	83 ec 14             	sub    $0x14,%esp
80107f54:	8b 45 08             	mov    0x8(%ebp),%eax
80107f57:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107f5b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107f5f:	89 c2                	mov    %eax,%edx
80107f61:	ec                   	in     (%dx),%al
80107f62:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107f65:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107f69:	c9                   	leave  
80107f6a:	c3                   	ret    

80107f6b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107f6b:	55                   	push   %ebp
80107f6c:	89 e5                	mov    %esp,%ebp
80107f6e:	83 ec 08             	sub    $0x8,%esp
80107f71:	8b 55 08             	mov    0x8(%ebp),%edx
80107f74:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f77:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107f7b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107f7e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107f82:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107f86:	ee                   	out    %al,(%dx)
}
80107f87:	90                   	nop
80107f88:	c9                   	leave  
80107f89:	c3                   	ret    

80107f8a <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107f8a:	55                   	push   %ebp
80107f8b:	89 e5                	mov    %esp,%ebp
80107f8d:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107f90:	6a 00                	push   $0x0
80107f92:	68 fa 03 00 00       	push   $0x3fa
80107f97:	e8 cf ff ff ff       	call   80107f6b <outb>
80107f9c:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107f9f:	68 80 00 00 00       	push   $0x80
80107fa4:	68 fb 03 00 00       	push   $0x3fb
80107fa9:	e8 bd ff ff ff       	call   80107f6b <outb>
80107fae:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107fb1:	6a 0c                	push   $0xc
80107fb3:	68 f8 03 00 00       	push   $0x3f8
80107fb8:	e8 ae ff ff ff       	call   80107f6b <outb>
80107fbd:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107fc0:	6a 00                	push   $0x0
80107fc2:	68 f9 03 00 00       	push   $0x3f9
80107fc7:	e8 9f ff ff ff       	call   80107f6b <outb>
80107fcc:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107fcf:	6a 03                	push   $0x3
80107fd1:	68 fb 03 00 00       	push   $0x3fb
80107fd6:	e8 90 ff ff ff       	call   80107f6b <outb>
80107fdb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107fde:	6a 00                	push   $0x0
80107fe0:	68 fc 03 00 00       	push   $0x3fc
80107fe5:	e8 81 ff ff ff       	call   80107f6b <outb>
80107fea:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107fed:	6a 01                	push   $0x1
80107fef:	68 f9 03 00 00       	push   $0x3f9
80107ff4:	e8 72 ff ff ff       	call   80107f6b <outb>
80107ff9:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107ffc:	68 fd 03 00 00       	push   $0x3fd
80108001:	e8 48 ff ff ff       	call   80107f4e <inb>
80108006:	83 c4 04             	add    $0x4,%esp
80108009:	3c ff                	cmp    $0xff,%al
8010800b:	74 6e                	je     8010807b <uartinit+0xf1>
    return;
  uart = 1;
8010800d:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
80108014:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80108017:	68 fa 03 00 00       	push   $0x3fa
8010801c:	e8 2d ff ff ff       	call   80107f4e <inb>
80108021:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80108024:	68 f8 03 00 00       	push   $0x3f8
80108029:	e8 20 ff ff ff       	call   80107f4e <inb>
8010802e:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80108031:	83 ec 0c             	sub    $0xc,%esp
80108034:	6a 04                	push   $0x4
80108036:	e8 96 bf ff ff       	call   80103fd1 <picenable>
8010803b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
8010803e:	83 ec 08             	sub    $0x8,%esp
80108041:	6a 00                	push   $0x0
80108043:	6a 04                	push   $0x4
80108045:	e8 36 ab ff ff       	call   80102b80 <ioapicenable>
8010804a:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010804d:	c7 45 f4 50 a2 10 80 	movl   $0x8010a250,-0xc(%ebp)
80108054:	eb 19                	jmp    8010806f <uartinit+0xe5>
    uartputc(*p);
80108056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108059:	0f b6 00             	movzbl (%eax),%eax
8010805c:	0f be c0             	movsbl %al,%eax
8010805f:	83 ec 0c             	sub    $0xc,%esp
80108062:	50                   	push   %eax
80108063:	e8 16 00 00 00       	call   8010807e <uartputc>
80108068:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010806b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010806f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108072:	0f b6 00             	movzbl (%eax),%eax
80108075:	84 c0                	test   %al,%al
80108077:	75 dd                	jne    80108056 <uartinit+0xcc>
80108079:	eb 01                	jmp    8010807c <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010807b:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010807c:	c9                   	leave  
8010807d:	c3                   	ret    

8010807e <uartputc>:

void
uartputc(int c)
{
8010807e:	55                   	push   %ebp
8010807f:	89 e5                	mov    %esp,%ebp
80108081:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80108084:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80108089:	85 c0                	test   %eax,%eax
8010808b:	74 53                	je     801080e0 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010808d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108094:	eb 11                	jmp    801080a7 <uartputc+0x29>
    microdelay(10);
80108096:	83 ec 0c             	sub    $0xc,%esp
80108099:	6a 0a                	push   $0xa
8010809b:	e8 46 b0 ff ff       	call   801030e6 <microdelay>
801080a0:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801080a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801080a7:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801080ab:	7f 1a                	jg     801080c7 <uartputc+0x49>
801080ad:	83 ec 0c             	sub    $0xc,%esp
801080b0:	68 fd 03 00 00       	push   $0x3fd
801080b5:	e8 94 fe ff ff       	call   80107f4e <inb>
801080ba:	83 c4 10             	add    $0x10,%esp
801080bd:	0f b6 c0             	movzbl %al,%eax
801080c0:	83 e0 20             	and    $0x20,%eax
801080c3:	85 c0                	test   %eax,%eax
801080c5:	74 cf                	je     80108096 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801080c7:	8b 45 08             	mov    0x8(%ebp),%eax
801080ca:	0f b6 c0             	movzbl %al,%eax
801080cd:	83 ec 08             	sub    $0x8,%esp
801080d0:	50                   	push   %eax
801080d1:	68 f8 03 00 00       	push   $0x3f8
801080d6:	e8 90 fe ff ff       	call   80107f6b <outb>
801080db:	83 c4 10             	add    $0x10,%esp
801080de:	eb 01                	jmp    801080e1 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801080e0:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801080e1:	c9                   	leave  
801080e2:	c3                   	ret    

801080e3 <uartgetc>:

static int
uartgetc(void)
{
801080e3:	55                   	push   %ebp
801080e4:	89 e5                	mov    %esp,%ebp
  if(!uart)
801080e6:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
801080eb:	85 c0                	test   %eax,%eax
801080ed:	75 07                	jne    801080f6 <uartgetc+0x13>
    return -1;
801080ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080f4:	eb 2e                	jmp    80108124 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801080f6:	68 fd 03 00 00       	push   $0x3fd
801080fb:	e8 4e fe ff ff       	call   80107f4e <inb>
80108100:	83 c4 04             	add    $0x4,%esp
80108103:	0f b6 c0             	movzbl %al,%eax
80108106:	83 e0 01             	and    $0x1,%eax
80108109:	85 c0                	test   %eax,%eax
8010810b:	75 07                	jne    80108114 <uartgetc+0x31>
    return -1;
8010810d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108112:	eb 10                	jmp    80108124 <uartgetc+0x41>
  return inb(COM1+0);
80108114:	68 f8 03 00 00       	push   $0x3f8
80108119:	e8 30 fe ff ff       	call   80107f4e <inb>
8010811e:	83 c4 04             	add    $0x4,%esp
80108121:	0f b6 c0             	movzbl %al,%eax
}
80108124:	c9                   	leave  
80108125:	c3                   	ret    

80108126 <uartintr>:

void
uartintr(void)
{
80108126:	55                   	push   %ebp
80108127:	89 e5                	mov    %esp,%ebp
80108129:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010812c:	83 ec 0c             	sub    $0xc,%esp
8010812f:	68 e3 80 10 80       	push   $0x801080e3
80108134:	e8 c0 86 ff ff       	call   801007f9 <consoleintr>
80108139:	83 c4 10             	add    $0x10,%esp
}
8010813c:	90                   	nop
8010813d:	c9                   	leave  
8010813e:	c3                   	ret    

8010813f <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010813f:	6a 00                	push   $0x0
  pushl $0
80108141:	6a 00                	push   $0x0
  jmp alltraps
80108143:	e9 cc f9 ff ff       	jmp    80107b14 <alltraps>

80108148 <vector1>:
.globl vector1
vector1:
  pushl $0
80108148:	6a 00                	push   $0x0
  pushl $1
8010814a:	6a 01                	push   $0x1
  jmp alltraps
8010814c:	e9 c3 f9 ff ff       	jmp    80107b14 <alltraps>

80108151 <vector2>:
.globl vector2
vector2:
  pushl $0
80108151:	6a 00                	push   $0x0
  pushl $2
80108153:	6a 02                	push   $0x2
  jmp alltraps
80108155:	e9 ba f9 ff ff       	jmp    80107b14 <alltraps>

8010815a <vector3>:
.globl vector3
vector3:
  pushl $0
8010815a:	6a 00                	push   $0x0
  pushl $3
8010815c:	6a 03                	push   $0x3
  jmp alltraps
8010815e:	e9 b1 f9 ff ff       	jmp    80107b14 <alltraps>

80108163 <vector4>:
.globl vector4
vector4:
  pushl $0
80108163:	6a 00                	push   $0x0
  pushl $4
80108165:	6a 04                	push   $0x4
  jmp alltraps
80108167:	e9 a8 f9 ff ff       	jmp    80107b14 <alltraps>

8010816c <vector5>:
.globl vector5
vector5:
  pushl $0
8010816c:	6a 00                	push   $0x0
  pushl $5
8010816e:	6a 05                	push   $0x5
  jmp alltraps
80108170:	e9 9f f9 ff ff       	jmp    80107b14 <alltraps>

80108175 <vector6>:
.globl vector6
vector6:
  pushl $0
80108175:	6a 00                	push   $0x0
  pushl $6
80108177:	6a 06                	push   $0x6
  jmp alltraps
80108179:	e9 96 f9 ff ff       	jmp    80107b14 <alltraps>

8010817e <vector7>:
.globl vector7
vector7:
  pushl $0
8010817e:	6a 00                	push   $0x0
  pushl $7
80108180:	6a 07                	push   $0x7
  jmp alltraps
80108182:	e9 8d f9 ff ff       	jmp    80107b14 <alltraps>

80108187 <vector8>:
.globl vector8
vector8:
  pushl $8
80108187:	6a 08                	push   $0x8
  jmp alltraps
80108189:	e9 86 f9 ff ff       	jmp    80107b14 <alltraps>

8010818e <vector9>:
.globl vector9
vector9:
  pushl $0
8010818e:	6a 00                	push   $0x0
  pushl $9
80108190:	6a 09                	push   $0x9
  jmp alltraps
80108192:	e9 7d f9 ff ff       	jmp    80107b14 <alltraps>

80108197 <vector10>:
.globl vector10
vector10:
  pushl $10
80108197:	6a 0a                	push   $0xa
  jmp alltraps
80108199:	e9 76 f9 ff ff       	jmp    80107b14 <alltraps>

8010819e <vector11>:
.globl vector11
vector11:
  pushl $11
8010819e:	6a 0b                	push   $0xb
  jmp alltraps
801081a0:	e9 6f f9 ff ff       	jmp    80107b14 <alltraps>

801081a5 <vector12>:
.globl vector12
vector12:
  pushl $12
801081a5:	6a 0c                	push   $0xc
  jmp alltraps
801081a7:	e9 68 f9 ff ff       	jmp    80107b14 <alltraps>

801081ac <vector13>:
.globl vector13
vector13:
  pushl $13
801081ac:	6a 0d                	push   $0xd
  jmp alltraps
801081ae:	e9 61 f9 ff ff       	jmp    80107b14 <alltraps>

801081b3 <vector14>:
.globl vector14
vector14:
  pushl $14
801081b3:	6a 0e                	push   $0xe
  jmp alltraps
801081b5:	e9 5a f9 ff ff       	jmp    80107b14 <alltraps>

801081ba <vector15>:
.globl vector15
vector15:
  pushl $0
801081ba:	6a 00                	push   $0x0
  pushl $15
801081bc:	6a 0f                	push   $0xf
  jmp alltraps
801081be:	e9 51 f9 ff ff       	jmp    80107b14 <alltraps>

801081c3 <vector16>:
.globl vector16
vector16:
  pushl $0
801081c3:	6a 00                	push   $0x0
  pushl $16
801081c5:	6a 10                	push   $0x10
  jmp alltraps
801081c7:	e9 48 f9 ff ff       	jmp    80107b14 <alltraps>

801081cc <vector17>:
.globl vector17
vector17:
  pushl $17
801081cc:	6a 11                	push   $0x11
  jmp alltraps
801081ce:	e9 41 f9 ff ff       	jmp    80107b14 <alltraps>

801081d3 <vector18>:
.globl vector18
vector18:
  pushl $0
801081d3:	6a 00                	push   $0x0
  pushl $18
801081d5:	6a 12                	push   $0x12
  jmp alltraps
801081d7:	e9 38 f9 ff ff       	jmp    80107b14 <alltraps>

801081dc <vector19>:
.globl vector19
vector19:
  pushl $0
801081dc:	6a 00                	push   $0x0
  pushl $19
801081de:	6a 13                	push   $0x13
  jmp alltraps
801081e0:	e9 2f f9 ff ff       	jmp    80107b14 <alltraps>

801081e5 <vector20>:
.globl vector20
vector20:
  pushl $0
801081e5:	6a 00                	push   $0x0
  pushl $20
801081e7:	6a 14                	push   $0x14
  jmp alltraps
801081e9:	e9 26 f9 ff ff       	jmp    80107b14 <alltraps>

801081ee <vector21>:
.globl vector21
vector21:
  pushl $0
801081ee:	6a 00                	push   $0x0
  pushl $21
801081f0:	6a 15                	push   $0x15
  jmp alltraps
801081f2:	e9 1d f9 ff ff       	jmp    80107b14 <alltraps>

801081f7 <vector22>:
.globl vector22
vector22:
  pushl $0
801081f7:	6a 00                	push   $0x0
  pushl $22
801081f9:	6a 16                	push   $0x16
  jmp alltraps
801081fb:	e9 14 f9 ff ff       	jmp    80107b14 <alltraps>

80108200 <vector23>:
.globl vector23
vector23:
  pushl $0
80108200:	6a 00                	push   $0x0
  pushl $23
80108202:	6a 17                	push   $0x17
  jmp alltraps
80108204:	e9 0b f9 ff ff       	jmp    80107b14 <alltraps>

80108209 <vector24>:
.globl vector24
vector24:
  pushl $0
80108209:	6a 00                	push   $0x0
  pushl $24
8010820b:	6a 18                	push   $0x18
  jmp alltraps
8010820d:	e9 02 f9 ff ff       	jmp    80107b14 <alltraps>

80108212 <vector25>:
.globl vector25
vector25:
  pushl $0
80108212:	6a 00                	push   $0x0
  pushl $25
80108214:	6a 19                	push   $0x19
  jmp alltraps
80108216:	e9 f9 f8 ff ff       	jmp    80107b14 <alltraps>

8010821b <vector26>:
.globl vector26
vector26:
  pushl $0
8010821b:	6a 00                	push   $0x0
  pushl $26
8010821d:	6a 1a                	push   $0x1a
  jmp alltraps
8010821f:	e9 f0 f8 ff ff       	jmp    80107b14 <alltraps>

80108224 <vector27>:
.globl vector27
vector27:
  pushl $0
80108224:	6a 00                	push   $0x0
  pushl $27
80108226:	6a 1b                	push   $0x1b
  jmp alltraps
80108228:	e9 e7 f8 ff ff       	jmp    80107b14 <alltraps>

8010822d <vector28>:
.globl vector28
vector28:
  pushl $0
8010822d:	6a 00                	push   $0x0
  pushl $28
8010822f:	6a 1c                	push   $0x1c
  jmp alltraps
80108231:	e9 de f8 ff ff       	jmp    80107b14 <alltraps>

80108236 <vector29>:
.globl vector29
vector29:
  pushl $0
80108236:	6a 00                	push   $0x0
  pushl $29
80108238:	6a 1d                	push   $0x1d
  jmp alltraps
8010823a:	e9 d5 f8 ff ff       	jmp    80107b14 <alltraps>

8010823f <vector30>:
.globl vector30
vector30:
  pushl $0
8010823f:	6a 00                	push   $0x0
  pushl $30
80108241:	6a 1e                	push   $0x1e
  jmp alltraps
80108243:	e9 cc f8 ff ff       	jmp    80107b14 <alltraps>

80108248 <vector31>:
.globl vector31
vector31:
  pushl $0
80108248:	6a 00                	push   $0x0
  pushl $31
8010824a:	6a 1f                	push   $0x1f
  jmp alltraps
8010824c:	e9 c3 f8 ff ff       	jmp    80107b14 <alltraps>

80108251 <vector32>:
.globl vector32
vector32:
  pushl $0
80108251:	6a 00                	push   $0x0
  pushl $32
80108253:	6a 20                	push   $0x20
  jmp alltraps
80108255:	e9 ba f8 ff ff       	jmp    80107b14 <alltraps>

8010825a <vector33>:
.globl vector33
vector33:
  pushl $0
8010825a:	6a 00                	push   $0x0
  pushl $33
8010825c:	6a 21                	push   $0x21
  jmp alltraps
8010825e:	e9 b1 f8 ff ff       	jmp    80107b14 <alltraps>

80108263 <vector34>:
.globl vector34
vector34:
  pushl $0
80108263:	6a 00                	push   $0x0
  pushl $34
80108265:	6a 22                	push   $0x22
  jmp alltraps
80108267:	e9 a8 f8 ff ff       	jmp    80107b14 <alltraps>

8010826c <vector35>:
.globl vector35
vector35:
  pushl $0
8010826c:	6a 00                	push   $0x0
  pushl $35
8010826e:	6a 23                	push   $0x23
  jmp alltraps
80108270:	e9 9f f8 ff ff       	jmp    80107b14 <alltraps>

80108275 <vector36>:
.globl vector36
vector36:
  pushl $0
80108275:	6a 00                	push   $0x0
  pushl $36
80108277:	6a 24                	push   $0x24
  jmp alltraps
80108279:	e9 96 f8 ff ff       	jmp    80107b14 <alltraps>

8010827e <vector37>:
.globl vector37
vector37:
  pushl $0
8010827e:	6a 00                	push   $0x0
  pushl $37
80108280:	6a 25                	push   $0x25
  jmp alltraps
80108282:	e9 8d f8 ff ff       	jmp    80107b14 <alltraps>

80108287 <vector38>:
.globl vector38
vector38:
  pushl $0
80108287:	6a 00                	push   $0x0
  pushl $38
80108289:	6a 26                	push   $0x26
  jmp alltraps
8010828b:	e9 84 f8 ff ff       	jmp    80107b14 <alltraps>

80108290 <vector39>:
.globl vector39
vector39:
  pushl $0
80108290:	6a 00                	push   $0x0
  pushl $39
80108292:	6a 27                	push   $0x27
  jmp alltraps
80108294:	e9 7b f8 ff ff       	jmp    80107b14 <alltraps>

80108299 <vector40>:
.globl vector40
vector40:
  pushl $0
80108299:	6a 00                	push   $0x0
  pushl $40
8010829b:	6a 28                	push   $0x28
  jmp alltraps
8010829d:	e9 72 f8 ff ff       	jmp    80107b14 <alltraps>

801082a2 <vector41>:
.globl vector41
vector41:
  pushl $0
801082a2:	6a 00                	push   $0x0
  pushl $41
801082a4:	6a 29                	push   $0x29
  jmp alltraps
801082a6:	e9 69 f8 ff ff       	jmp    80107b14 <alltraps>

801082ab <vector42>:
.globl vector42
vector42:
  pushl $0
801082ab:	6a 00                	push   $0x0
  pushl $42
801082ad:	6a 2a                	push   $0x2a
  jmp alltraps
801082af:	e9 60 f8 ff ff       	jmp    80107b14 <alltraps>

801082b4 <vector43>:
.globl vector43
vector43:
  pushl $0
801082b4:	6a 00                	push   $0x0
  pushl $43
801082b6:	6a 2b                	push   $0x2b
  jmp alltraps
801082b8:	e9 57 f8 ff ff       	jmp    80107b14 <alltraps>

801082bd <vector44>:
.globl vector44
vector44:
  pushl $0
801082bd:	6a 00                	push   $0x0
  pushl $44
801082bf:	6a 2c                	push   $0x2c
  jmp alltraps
801082c1:	e9 4e f8 ff ff       	jmp    80107b14 <alltraps>

801082c6 <vector45>:
.globl vector45
vector45:
  pushl $0
801082c6:	6a 00                	push   $0x0
  pushl $45
801082c8:	6a 2d                	push   $0x2d
  jmp alltraps
801082ca:	e9 45 f8 ff ff       	jmp    80107b14 <alltraps>

801082cf <vector46>:
.globl vector46
vector46:
  pushl $0
801082cf:	6a 00                	push   $0x0
  pushl $46
801082d1:	6a 2e                	push   $0x2e
  jmp alltraps
801082d3:	e9 3c f8 ff ff       	jmp    80107b14 <alltraps>

801082d8 <vector47>:
.globl vector47
vector47:
  pushl $0
801082d8:	6a 00                	push   $0x0
  pushl $47
801082da:	6a 2f                	push   $0x2f
  jmp alltraps
801082dc:	e9 33 f8 ff ff       	jmp    80107b14 <alltraps>

801082e1 <vector48>:
.globl vector48
vector48:
  pushl $0
801082e1:	6a 00                	push   $0x0
  pushl $48
801082e3:	6a 30                	push   $0x30
  jmp alltraps
801082e5:	e9 2a f8 ff ff       	jmp    80107b14 <alltraps>

801082ea <vector49>:
.globl vector49
vector49:
  pushl $0
801082ea:	6a 00                	push   $0x0
  pushl $49
801082ec:	6a 31                	push   $0x31
  jmp alltraps
801082ee:	e9 21 f8 ff ff       	jmp    80107b14 <alltraps>

801082f3 <vector50>:
.globl vector50
vector50:
  pushl $0
801082f3:	6a 00                	push   $0x0
  pushl $50
801082f5:	6a 32                	push   $0x32
  jmp alltraps
801082f7:	e9 18 f8 ff ff       	jmp    80107b14 <alltraps>

801082fc <vector51>:
.globl vector51
vector51:
  pushl $0
801082fc:	6a 00                	push   $0x0
  pushl $51
801082fe:	6a 33                	push   $0x33
  jmp alltraps
80108300:	e9 0f f8 ff ff       	jmp    80107b14 <alltraps>

80108305 <vector52>:
.globl vector52
vector52:
  pushl $0
80108305:	6a 00                	push   $0x0
  pushl $52
80108307:	6a 34                	push   $0x34
  jmp alltraps
80108309:	e9 06 f8 ff ff       	jmp    80107b14 <alltraps>

8010830e <vector53>:
.globl vector53
vector53:
  pushl $0
8010830e:	6a 00                	push   $0x0
  pushl $53
80108310:	6a 35                	push   $0x35
  jmp alltraps
80108312:	e9 fd f7 ff ff       	jmp    80107b14 <alltraps>

80108317 <vector54>:
.globl vector54
vector54:
  pushl $0
80108317:	6a 00                	push   $0x0
  pushl $54
80108319:	6a 36                	push   $0x36
  jmp alltraps
8010831b:	e9 f4 f7 ff ff       	jmp    80107b14 <alltraps>

80108320 <vector55>:
.globl vector55
vector55:
  pushl $0
80108320:	6a 00                	push   $0x0
  pushl $55
80108322:	6a 37                	push   $0x37
  jmp alltraps
80108324:	e9 eb f7 ff ff       	jmp    80107b14 <alltraps>

80108329 <vector56>:
.globl vector56
vector56:
  pushl $0
80108329:	6a 00                	push   $0x0
  pushl $56
8010832b:	6a 38                	push   $0x38
  jmp alltraps
8010832d:	e9 e2 f7 ff ff       	jmp    80107b14 <alltraps>

80108332 <vector57>:
.globl vector57
vector57:
  pushl $0
80108332:	6a 00                	push   $0x0
  pushl $57
80108334:	6a 39                	push   $0x39
  jmp alltraps
80108336:	e9 d9 f7 ff ff       	jmp    80107b14 <alltraps>

8010833b <vector58>:
.globl vector58
vector58:
  pushl $0
8010833b:	6a 00                	push   $0x0
  pushl $58
8010833d:	6a 3a                	push   $0x3a
  jmp alltraps
8010833f:	e9 d0 f7 ff ff       	jmp    80107b14 <alltraps>

80108344 <vector59>:
.globl vector59
vector59:
  pushl $0
80108344:	6a 00                	push   $0x0
  pushl $59
80108346:	6a 3b                	push   $0x3b
  jmp alltraps
80108348:	e9 c7 f7 ff ff       	jmp    80107b14 <alltraps>

8010834d <vector60>:
.globl vector60
vector60:
  pushl $0
8010834d:	6a 00                	push   $0x0
  pushl $60
8010834f:	6a 3c                	push   $0x3c
  jmp alltraps
80108351:	e9 be f7 ff ff       	jmp    80107b14 <alltraps>

80108356 <vector61>:
.globl vector61
vector61:
  pushl $0
80108356:	6a 00                	push   $0x0
  pushl $61
80108358:	6a 3d                	push   $0x3d
  jmp alltraps
8010835a:	e9 b5 f7 ff ff       	jmp    80107b14 <alltraps>

8010835f <vector62>:
.globl vector62
vector62:
  pushl $0
8010835f:	6a 00                	push   $0x0
  pushl $62
80108361:	6a 3e                	push   $0x3e
  jmp alltraps
80108363:	e9 ac f7 ff ff       	jmp    80107b14 <alltraps>

80108368 <vector63>:
.globl vector63
vector63:
  pushl $0
80108368:	6a 00                	push   $0x0
  pushl $63
8010836a:	6a 3f                	push   $0x3f
  jmp alltraps
8010836c:	e9 a3 f7 ff ff       	jmp    80107b14 <alltraps>

80108371 <vector64>:
.globl vector64
vector64:
  pushl $0
80108371:	6a 00                	push   $0x0
  pushl $64
80108373:	6a 40                	push   $0x40
  jmp alltraps
80108375:	e9 9a f7 ff ff       	jmp    80107b14 <alltraps>

8010837a <vector65>:
.globl vector65
vector65:
  pushl $0
8010837a:	6a 00                	push   $0x0
  pushl $65
8010837c:	6a 41                	push   $0x41
  jmp alltraps
8010837e:	e9 91 f7 ff ff       	jmp    80107b14 <alltraps>

80108383 <vector66>:
.globl vector66
vector66:
  pushl $0
80108383:	6a 00                	push   $0x0
  pushl $66
80108385:	6a 42                	push   $0x42
  jmp alltraps
80108387:	e9 88 f7 ff ff       	jmp    80107b14 <alltraps>

8010838c <vector67>:
.globl vector67
vector67:
  pushl $0
8010838c:	6a 00                	push   $0x0
  pushl $67
8010838e:	6a 43                	push   $0x43
  jmp alltraps
80108390:	e9 7f f7 ff ff       	jmp    80107b14 <alltraps>

80108395 <vector68>:
.globl vector68
vector68:
  pushl $0
80108395:	6a 00                	push   $0x0
  pushl $68
80108397:	6a 44                	push   $0x44
  jmp alltraps
80108399:	e9 76 f7 ff ff       	jmp    80107b14 <alltraps>

8010839e <vector69>:
.globl vector69
vector69:
  pushl $0
8010839e:	6a 00                	push   $0x0
  pushl $69
801083a0:	6a 45                	push   $0x45
  jmp alltraps
801083a2:	e9 6d f7 ff ff       	jmp    80107b14 <alltraps>

801083a7 <vector70>:
.globl vector70
vector70:
  pushl $0
801083a7:	6a 00                	push   $0x0
  pushl $70
801083a9:	6a 46                	push   $0x46
  jmp alltraps
801083ab:	e9 64 f7 ff ff       	jmp    80107b14 <alltraps>

801083b0 <vector71>:
.globl vector71
vector71:
  pushl $0
801083b0:	6a 00                	push   $0x0
  pushl $71
801083b2:	6a 47                	push   $0x47
  jmp alltraps
801083b4:	e9 5b f7 ff ff       	jmp    80107b14 <alltraps>

801083b9 <vector72>:
.globl vector72
vector72:
  pushl $0
801083b9:	6a 00                	push   $0x0
  pushl $72
801083bb:	6a 48                	push   $0x48
  jmp alltraps
801083bd:	e9 52 f7 ff ff       	jmp    80107b14 <alltraps>

801083c2 <vector73>:
.globl vector73
vector73:
  pushl $0
801083c2:	6a 00                	push   $0x0
  pushl $73
801083c4:	6a 49                	push   $0x49
  jmp alltraps
801083c6:	e9 49 f7 ff ff       	jmp    80107b14 <alltraps>

801083cb <vector74>:
.globl vector74
vector74:
  pushl $0
801083cb:	6a 00                	push   $0x0
  pushl $74
801083cd:	6a 4a                	push   $0x4a
  jmp alltraps
801083cf:	e9 40 f7 ff ff       	jmp    80107b14 <alltraps>

801083d4 <vector75>:
.globl vector75
vector75:
  pushl $0
801083d4:	6a 00                	push   $0x0
  pushl $75
801083d6:	6a 4b                	push   $0x4b
  jmp alltraps
801083d8:	e9 37 f7 ff ff       	jmp    80107b14 <alltraps>

801083dd <vector76>:
.globl vector76
vector76:
  pushl $0
801083dd:	6a 00                	push   $0x0
  pushl $76
801083df:	6a 4c                	push   $0x4c
  jmp alltraps
801083e1:	e9 2e f7 ff ff       	jmp    80107b14 <alltraps>

801083e6 <vector77>:
.globl vector77
vector77:
  pushl $0
801083e6:	6a 00                	push   $0x0
  pushl $77
801083e8:	6a 4d                	push   $0x4d
  jmp alltraps
801083ea:	e9 25 f7 ff ff       	jmp    80107b14 <alltraps>

801083ef <vector78>:
.globl vector78
vector78:
  pushl $0
801083ef:	6a 00                	push   $0x0
  pushl $78
801083f1:	6a 4e                	push   $0x4e
  jmp alltraps
801083f3:	e9 1c f7 ff ff       	jmp    80107b14 <alltraps>

801083f8 <vector79>:
.globl vector79
vector79:
  pushl $0
801083f8:	6a 00                	push   $0x0
  pushl $79
801083fa:	6a 4f                	push   $0x4f
  jmp alltraps
801083fc:	e9 13 f7 ff ff       	jmp    80107b14 <alltraps>

80108401 <vector80>:
.globl vector80
vector80:
  pushl $0
80108401:	6a 00                	push   $0x0
  pushl $80
80108403:	6a 50                	push   $0x50
  jmp alltraps
80108405:	e9 0a f7 ff ff       	jmp    80107b14 <alltraps>

8010840a <vector81>:
.globl vector81
vector81:
  pushl $0
8010840a:	6a 00                	push   $0x0
  pushl $81
8010840c:	6a 51                	push   $0x51
  jmp alltraps
8010840e:	e9 01 f7 ff ff       	jmp    80107b14 <alltraps>

80108413 <vector82>:
.globl vector82
vector82:
  pushl $0
80108413:	6a 00                	push   $0x0
  pushl $82
80108415:	6a 52                	push   $0x52
  jmp alltraps
80108417:	e9 f8 f6 ff ff       	jmp    80107b14 <alltraps>

8010841c <vector83>:
.globl vector83
vector83:
  pushl $0
8010841c:	6a 00                	push   $0x0
  pushl $83
8010841e:	6a 53                	push   $0x53
  jmp alltraps
80108420:	e9 ef f6 ff ff       	jmp    80107b14 <alltraps>

80108425 <vector84>:
.globl vector84
vector84:
  pushl $0
80108425:	6a 00                	push   $0x0
  pushl $84
80108427:	6a 54                	push   $0x54
  jmp alltraps
80108429:	e9 e6 f6 ff ff       	jmp    80107b14 <alltraps>

8010842e <vector85>:
.globl vector85
vector85:
  pushl $0
8010842e:	6a 00                	push   $0x0
  pushl $85
80108430:	6a 55                	push   $0x55
  jmp alltraps
80108432:	e9 dd f6 ff ff       	jmp    80107b14 <alltraps>

80108437 <vector86>:
.globl vector86
vector86:
  pushl $0
80108437:	6a 00                	push   $0x0
  pushl $86
80108439:	6a 56                	push   $0x56
  jmp alltraps
8010843b:	e9 d4 f6 ff ff       	jmp    80107b14 <alltraps>

80108440 <vector87>:
.globl vector87
vector87:
  pushl $0
80108440:	6a 00                	push   $0x0
  pushl $87
80108442:	6a 57                	push   $0x57
  jmp alltraps
80108444:	e9 cb f6 ff ff       	jmp    80107b14 <alltraps>

80108449 <vector88>:
.globl vector88
vector88:
  pushl $0
80108449:	6a 00                	push   $0x0
  pushl $88
8010844b:	6a 58                	push   $0x58
  jmp alltraps
8010844d:	e9 c2 f6 ff ff       	jmp    80107b14 <alltraps>

80108452 <vector89>:
.globl vector89
vector89:
  pushl $0
80108452:	6a 00                	push   $0x0
  pushl $89
80108454:	6a 59                	push   $0x59
  jmp alltraps
80108456:	e9 b9 f6 ff ff       	jmp    80107b14 <alltraps>

8010845b <vector90>:
.globl vector90
vector90:
  pushl $0
8010845b:	6a 00                	push   $0x0
  pushl $90
8010845d:	6a 5a                	push   $0x5a
  jmp alltraps
8010845f:	e9 b0 f6 ff ff       	jmp    80107b14 <alltraps>

80108464 <vector91>:
.globl vector91
vector91:
  pushl $0
80108464:	6a 00                	push   $0x0
  pushl $91
80108466:	6a 5b                	push   $0x5b
  jmp alltraps
80108468:	e9 a7 f6 ff ff       	jmp    80107b14 <alltraps>

8010846d <vector92>:
.globl vector92
vector92:
  pushl $0
8010846d:	6a 00                	push   $0x0
  pushl $92
8010846f:	6a 5c                	push   $0x5c
  jmp alltraps
80108471:	e9 9e f6 ff ff       	jmp    80107b14 <alltraps>

80108476 <vector93>:
.globl vector93
vector93:
  pushl $0
80108476:	6a 00                	push   $0x0
  pushl $93
80108478:	6a 5d                	push   $0x5d
  jmp alltraps
8010847a:	e9 95 f6 ff ff       	jmp    80107b14 <alltraps>

8010847f <vector94>:
.globl vector94
vector94:
  pushl $0
8010847f:	6a 00                	push   $0x0
  pushl $94
80108481:	6a 5e                	push   $0x5e
  jmp alltraps
80108483:	e9 8c f6 ff ff       	jmp    80107b14 <alltraps>

80108488 <vector95>:
.globl vector95
vector95:
  pushl $0
80108488:	6a 00                	push   $0x0
  pushl $95
8010848a:	6a 5f                	push   $0x5f
  jmp alltraps
8010848c:	e9 83 f6 ff ff       	jmp    80107b14 <alltraps>

80108491 <vector96>:
.globl vector96
vector96:
  pushl $0
80108491:	6a 00                	push   $0x0
  pushl $96
80108493:	6a 60                	push   $0x60
  jmp alltraps
80108495:	e9 7a f6 ff ff       	jmp    80107b14 <alltraps>

8010849a <vector97>:
.globl vector97
vector97:
  pushl $0
8010849a:	6a 00                	push   $0x0
  pushl $97
8010849c:	6a 61                	push   $0x61
  jmp alltraps
8010849e:	e9 71 f6 ff ff       	jmp    80107b14 <alltraps>

801084a3 <vector98>:
.globl vector98
vector98:
  pushl $0
801084a3:	6a 00                	push   $0x0
  pushl $98
801084a5:	6a 62                	push   $0x62
  jmp alltraps
801084a7:	e9 68 f6 ff ff       	jmp    80107b14 <alltraps>

801084ac <vector99>:
.globl vector99
vector99:
  pushl $0
801084ac:	6a 00                	push   $0x0
  pushl $99
801084ae:	6a 63                	push   $0x63
  jmp alltraps
801084b0:	e9 5f f6 ff ff       	jmp    80107b14 <alltraps>

801084b5 <vector100>:
.globl vector100
vector100:
  pushl $0
801084b5:	6a 00                	push   $0x0
  pushl $100
801084b7:	6a 64                	push   $0x64
  jmp alltraps
801084b9:	e9 56 f6 ff ff       	jmp    80107b14 <alltraps>

801084be <vector101>:
.globl vector101
vector101:
  pushl $0
801084be:	6a 00                	push   $0x0
  pushl $101
801084c0:	6a 65                	push   $0x65
  jmp alltraps
801084c2:	e9 4d f6 ff ff       	jmp    80107b14 <alltraps>

801084c7 <vector102>:
.globl vector102
vector102:
  pushl $0
801084c7:	6a 00                	push   $0x0
  pushl $102
801084c9:	6a 66                	push   $0x66
  jmp alltraps
801084cb:	e9 44 f6 ff ff       	jmp    80107b14 <alltraps>

801084d0 <vector103>:
.globl vector103
vector103:
  pushl $0
801084d0:	6a 00                	push   $0x0
  pushl $103
801084d2:	6a 67                	push   $0x67
  jmp alltraps
801084d4:	e9 3b f6 ff ff       	jmp    80107b14 <alltraps>

801084d9 <vector104>:
.globl vector104
vector104:
  pushl $0
801084d9:	6a 00                	push   $0x0
  pushl $104
801084db:	6a 68                	push   $0x68
  jmp alltraps
801084dd:	e9 32 f6 ff ff       	jmp    80107b14 <alltraps>

801084e2 <vector105>:
.globl vector105
vector105:
  pushl $0
801084e2:	6a 00                	push   $0x0
  pushl $105
801084e4:	6a 69                	push   $0x69
  jmp alltraps
801084e6:	e9 29 f6 ff ff       	jmp    80107b14 <alltraps>

801084eb <vector106>:
.globl vector106
vector106:
  pushl $0
801084eb:	6a 00                	push   $0x0
  pushl $106
801084ed:	6a 6a                	push   $0x6a
  jmp alltraps
801084ef:	e9 20 f6 ff ff       	jmp    80107b14 <alltraps>

801084f4 <vector107>:
.globl vector107
vector107:
  pushl $0
801084f4:	6a 00                	push   $0x0
  pushl $107
801084f6:	6a 6b                	push   $0x6b
  jmp alltraps
801084f8:	e9 17 f6 ff ff       	jmp    80107b14 <alltraps>

801084fd <vector108>:
.globl vector108
vector108:
  pushl $0
801084fd:	6a 00                	push   $0x0
  pushl $108
801084ff:	6a 6c                	push   $0x6c
  jmp alltraps
80108501:	e9 0e f6 ff ff       	jmp    80107b14 <alltraps>

80108506 <vector109>:
.globl vector109
vector109:
  pushl $0
80108506:	6a 00                	push   $0x0
  pushl $109
80108508:	6a 6d                	push   $0x6d
  jmp alltraps
8010850a:	e9 05 f6 ff ff       	jmp    80107b14 <alltraps>

8010850f <vector110>:
.globl vector110
vector110:
  pushl $0
8010850f:	6a 00                	push   $0x0
  pushl $110
80108511:	6a 6e                	push   $0x6e
  jmp alltraps
80108513:	e9 fc f5 ff ff       	jmp    80107b14 <alltraps>

80108518 <vector111>:
.globl vector111
vector111:
  pushl $0
80108518:	6a 00                	push   $0x0
  pushl $111
8010851a:	6a 6f                	push   $0x6f
  jmp alltraps
8010851c:	e9 f3 f5 ff ff       	jmp    80107b14 <alltraps>

80108521 <vector112>:
.globl vector112
vector112:
  pushl $0
80108521:	6a 00                	push   $0x0
  pushl $112
80108523:	6a 70                	push   $0x70
  jmp alltraps
80108525:	e9 ea f5 ff ff       	jmp    80107b14 <alltraps>

8010852a <vector113>:
.globl vector113
vector113:
  pushl $0
8010852a:	6a 00                	push   $0x0
  pushl $113
8010852c:	6a 71                	push   $0x71
  jmp alltraps
8010852e:	e9 e1 f5 ff ff       	jmp    80107b14 <alltraps>

80108533 <vector114>:
.globl vector114
vector114:
  pushl $0
80108533:	6a 00                	push   $0x0
  pushl $114
80108535:	6a 72                	push   $0x72
  jmp alltraps
80108537:	e9 d8 f5 ff ff       	jmp    80107b14 <alltraps>

8010853c <vector115>:
.globl vector115
vector115:
  pushl $0
8010853c:	6a 00                	push   $0x0
  pushl $115
8010853e:	6a 73                	push   $0x73
  jmp alltraps
80108540:	e9 cf f5 ff ff       	jmp    80107b14 <alltraps>

80108545 <vector116>:
.globl vector116
vector116:
  pushl $0
80108545:	6a 00                	push   $0x0
  pushl $116
80108547:	6a 74                	push   $0x74
  jmp alltraps
80108549:	e9 c6 f5 ff ff       	jmp    80107b14 <alltraps>

8010854e <vector117>:
.globl vector117
vector117:
  pushl $0
8010854e:	6a 00                	push   $0x0
  pushl $117
80108550:	6a 75                	push   $0x75
  jmp alltraps
80108552:	e9 bd f5 ff ff       	jmp    80107b14 <alltraps>

80108557 <vector118>:
.globl vector118
vector118:
  pushl $0
80108557:	6a 00                	push   $0x0
  pushl $118
80108559:	6a 76                	push   $0x76
  jmp alltraps
8010855b:	e9 b4 f5 ff ff       	jmp    80107b14 <alltraps>

80108560 <vector119>:
.globl vector119
vector119:
  pushl $0
80108560:	6a 00                	push   $0x0
  pushl $119
80108562:	6a 77                	push   $0x77
  jmp alltraps
80108564:	e9 ab f5 ff ff       	jmp    80107b14 <alltraps>

80108569 <vector120>:
.globl vector120
vector120:
  pushl $0
80108569:	6a 00                	push   $0x0
  pushl $120
8010856b:	6a 78                	push   $0x78
  jmp alltraps
8010856d:	e9 a2 f5 ff ff       	jmp    80107b14 <alltraps>

80108572 <vector121>:
.globl vector121
vector121:
  pushl $0
80108572:	6a 00                	push   $0x0
  pushl $121
80108574:	6a 79                	push   $0x79
  jmp alltraps
80108576:	e9 99 f5 ff ff       	jmp    80107b14 <alltraps>

8010857b <vector122>:
.globl vector122
vector122:
  pushl $0
8010857b:	6a 00                	push   $0x0
  pushl $122
8010857d:	6a 7a                	push   $0x7a
  jmp alltraps
8010857f:	e9 90 f5 ff ff       	jmp    80107b14 <alltraps>

80108584 <vector123>:
.globl vector123
vector123:
  pushl $0
80108584:	6a 00                	push   $0x0
  pushl $123
80108586:	6a 7b                	push   $0x7b
  jmp alltraps
80108588:	e9 87 f5 ff ff       	jmp    80107b14 <alltraps>

8010858d <vector124>:
.globl vector124
vector124:
  pushl $0
8010858d:	6a 00                	push   $0x0
  pushl $124
8010858f:	6a 7c                	push   $0x7c
  jmp alltraps
80108591:	e9 7e f5 ff ff       	jmp    80107b14 <alltraps>

80108596 <vector125>:
.globl vector125
vector125:
  pushl $0
80108596:	6a 00                	push   $0x0
  pushl $125
80108598:	6a 7d                	push   $0x7d
  jmp alltraps
8010859a:	e9 75 f5 ff ff       	jmp    80107b14 <alltraps>

8010859f <vector126>:
.globl vector126
vector126:
  pushl $0
8010859f:	6a 00                	push   $0x0
  pushl $126
801085a1:	6a 7e                	push   $0x7e
  jmp alltraps
801085a3:	e9 6c f5 ff ff       	jmp    80107b14 <alltraps>

801085a8 <vector127>:
.globl vector127
vector127:
  pushl $0
801085a8:	6a 00                	push   $0x0
  pushl $127
801085aa:	6a 7f                	push   $0x7f
  jmp alltraps
801085ac:	e9 63 f5 ff ff       	jmp    80107b14 <alltraps>

801085b1 <vector128>:
.globl vector128
vector128:
  pushl $0
801085b1:	6a 00                	push   $0x0
  pushl $128
801085b3:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801085b8:	e9 57 f5 ff ff       	jmp    80107b14 <alltraps>

801085bd <vector129>:
.globl vector129
vector129:
  pushl $0
801085bd:	6a 00                	push   $0x0
  pushl $129
801085bf:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801085c4:	e9 4b f5 ff ff       	jmp    80107b14 <alltraps>

801085c9 <vector130>:
.globl vector130
vector130:
  pushl $0
801085c9:	6a 00                	push   $0x0
  pushl $130
801085cb:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801085d0:	e9 3f f5 ff ff       	jmp    80107b14 <alltraps>

801085d5 <vector131>:
.globl vector131
vector131:
  pushl $0
801085d5:	6a 00                	push   $0x0
  pushl $131
801085d7:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801085dc:	e9 33 f5 ff ff       	jmp    80107b14 <alltraps>

801085e1 <vector132>:
.globl vector132
vector132:
  pushl $0
801085e1:	6a 00                	push   $0x0
  pushl $132
801085e3:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801085e8:	e9 27 f5 ff ff       	jmp    80107b14 <alltraps>

801085ed <vector133>:
.globl vector133
vector133:
  pushl $0
801085ed:	6a 00                	push   $0x0
  pushl $133
801085ef:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801085f4:	e9 1b f5 ff ff       	jmp    80107b14 <alltraps>

801085f9 <vector134>:
.globl vector134
vector134:
  pushl $0
801085f9:	6a 00                	push   $0x0
  pushl $134
801085fb:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108600:	e9 0f f5 ff ff       	jmp    80107b14 <alltraps>

80108605 <vector135>:
.globl vector135
vector135:
  pushl $0
80108605:	6a 00                	push   $0x0
  pushl $135
80108607:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010860c:	e9 03 f5 ff ff       	jmp    80107b14 <alltraps>

80108611 <vector136>:
.globl vector136
vector136:
  pushl $0
80108611:	6a 00                	push   $0x0
  pushl $136
80108613:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108618:	e9 f7 f4 ff ff       	jmp    80107b14 <alltraps>

8010861d <vector137>:
.globl vector137
vector137:
  pushl $0
8010861d:	6a 00                	push   $0x0
  pushl $137
8010861f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108624:	e9 eb f4 ff ff       	jmp    80107b14 <alltraps>

80108629 <vector138>:
.globl vector138
vector138:
  pushl $0
80108629:	6a 00                	push   $0x0
  pushl $138
8010862b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108630:	e9 df f4 ff ff       	jmp    80107b14 <alltraps>

80108635 <vector139>:
.globl vector139
vector139:
  pushl $0
80108635:	6a 00                	push   $0x0
  pushl $139
80108637:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010863c:	e9 d3 f4 ff ff       	jmp    80107b14 <alltraps>

80108641 <vector140>:
.globl vector140
vector140:
  pushl $0
80108641:	6a 00                	push   $0x0
  pushl $140
80108643:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108648:	e9 c7 f4 ff ff       	jmp    80107b14 <alltraps>

8010864d <vector141>:
.globl vector141
vector141:
  pushl $0
8010864d:	6a 00                	push   $0x0
  pushl $141
8010864f:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108654:	e9 bb f4 ff ff       	jmp    80107b14 <alltraps>

80108659 <vector142>:
.globl vector142
vector142:
  pushl $0
80108659:	6a 00                	push   $0x0
  pushl $142
8010865b:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108660:	e9 af f4 ff ff       	jmp    80107b14 <alltraps>

80108665 <vector143>:
.globl vector143
vector143:
  pushl $0
80108665:	6a 00                	push   $0x0
  pushl $143
80108667:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010866c:	e9 a3 f4 ff ff       	jmp    80107b14 <alltraps>

80108671 <vector144>:
.globl vector144
vector144:
  pushl $0
80108671:	6a 00                	push   $0x0
  pushl $144
80108673:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108678:	e9 97 f4 ff ff       	jmp    80107b14 <alltraps>

8010867d <vector145>:
.globl vector145
vector145:
  pushl $0
8010867d:	6a 00                	push   $0x0
  pushl $145
8010867f:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108684:	e9 8b f4 ff ff       	jmp    80107b14 <alltraps>

80108689 <vector146>:
.globl vector146
vector146:
  pushl $0
80108689:	6a 00                	push   $0x0
  pushl $146
8010868b:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108690:	e9 7f f4 ff ff       	jmp    80107b14 <alltraps>

80108695 <vector147>:
.globl vector147
vector147:
  pushl $0
80108695:	6a 00                	push   $0x0
  pushl $147
80108697:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010869c:	e9 73 f4 ff ff       	jmp    80107b14 <alltraps>

801086a1 <vector148>:
.globl vector148
vector148:
  pushl $0
801086a1:	6a 00                	push   $0x0
  pushl $148
801086a3:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801086a8:	e9 67 f4 ff ff       	jmp    80107b14 <alltraps>

801086ad <vector149>:
.globl vector149
vector149:
  pushl $0
801086ad:	6a 00                	push   $0x0
  pushl $149
801086af:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801086b4:	e9 5b f4 ff ff       	jmp    80107b14 <alltraps>

801086b9 <vector150>:
.globl vector150
vector150:
  pushl $0
801086b9:	6a 00                	push   $0x0
  pushl $150
801086bb:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801086c0:	e9 4f f4 ff ff       	jmp    80107b14 <alltraps>

801086c5 <vector151>:
.globl vector151
vector151:
  pushl $0
801086c5:	6a 00                	push   $0x0
  pushl $151
801086c7:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801086cc:	e9 43 f4 ff ff       	jmp    80107b14 <alltraps>

801086d1 <vector152>:
.globl vector152
vector152:
  pushl $0
801086d1:	6a 00                	push   $0x0
  pushl $152
801086d3:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801086d8:	e9 37 f4 ff ff       	jmp    80107b14 <alltraps>

801086dd <vector153>:
.globl vector153
vector153:
  pushl $0
801086dd:	6a 00                	push   $0x0
  pushl $153
801086df:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801086e4:	e9 2b f4 ff ff       	jmp    80107b14 <alltraps>

801086e9 <vector154>:
.globl vector154
vector154:
  pushl $0
801086e9:	6a 00                	push   $0x0
  pushl $154
801086eb:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801086f0:	e9 1f f4 ff ff       	jmp    80107b14 <alltraps>

801086f5 <vector155>:
.globl vector155
vector155:
  pushl $0
801086f5:	6a 00                	push   $0x0
  pushl $155
801086f7:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801086fc:	e9 13 f4 ff ff       	jmp    80107b14 <alltraps>

80108701 <vector156>:
.globl vector156
vector156:
  pushl $0
80108701:	6a 00                	push   $0x0
  pushl $156
80108703:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108708:	e9 07 f4 ff ff       	jmp    80107b14 <alltraps>

8010870d <vector157>:
.globl vector157
vector157:
  pushl $0
8010870d:	6a 00                	push   $0x0
  pushl $157
8010870f:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108714:	e9 fb f3 ff ff       	jmp    80107b14 <alltraps>

80108719 <vector158>:
.globl vector158
vector158:
  pushl $0
80108719:	6a 00                	push   $0x0
  pushl $158
8010871b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108720:	e9 ef f3 ff ff       	jmp    80107b14 <alltraps>

80108725 <vector159>:
.globl vector159
vector159:
  pushl $0
80108725:	6a 00                	push   $0x0
  pushl $159
80108727:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010872c:	e9 e3 f3 ff ff       	jmp    80107b14 <alltraps>

80108731 <vector160>:
.globl vector160
vector160:
  pushl $0
80108731:	6a 00                	push   $0x0
  pushl $160
80108733:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108738:	e9 d7 f3 ff ff       	jmp    80107b14 <alltraps>

8010873d <vector161>:
.globl vector161
vector161:
  pushl $0
8010873d:	6a 00                	push   $0x0
  pushl $161
8010873f:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108744:	e9 cb f3 ff ff       	jmp    80107b14 <alltraps>

80108749 <vector162>:
.globl vector162
vector162:
  pushl $0
80108749:	6a 00                	push   $0x0
  pushl $162
8010874b:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108750:	e9 bf f3 ff ff       	jmp    80107b14 <alltraps>

80108755 <vector163>:
.globl vector163
vector163:
  pushl $0
80108755:	6a 00                	push   $0x0
  pushl $163
80108757:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010875c:	e9 b3 f3 ff ff       	jmp    80107b14 <alltraps>

80108761 <vector164>:
.globl vector164
vector164:
  pushl $0
80108761:	6a 00                	push   $0x0
  pushl $164
80108763:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108768:	e9 a7 f3 ff ff       	jmp    80107b14 <alltraps>

8010876d <vector165>:
.globl vector165
vector165:
  pushl $0
8010876d:	6a 00                	push   $0x0
  pushl $165
8010876f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108774:	e9 9b f3 ff ff       	jmp    80107b14 <alltraps>

80108779 <vector166>:
.globl vector166
vector166:
  pushl $0
80108779:	6a 00                	push   $0x0
  pushl $166
8010877b:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108780:	e9 8f f3 ff ff       	jmp    80107b14 <alltraps>

80108785 <vector167>:
.globl vector167
vector167:
  pushl $0
80108785:	6a 00                	push   $0x0
  pushl $167
80108787:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010878c:	e9 83 f3 ff ff       	jmp    80107b14 <alltraps>

80108791 <vector168>:
.globl vector168
vector168:
  pushl $0
80108791:	6a 00                	push   $0x0
  pushl $168
80108793:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108798:	e9 77 f3 ff ff       	jmp    80107b14 <alltraps>

8010879d <vector169>:
.globl vector169
vector169:
  pushl $0
8010879d:	6a 00                	push   $0x0
  pushl $169
8010879f:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801087a4:	e9 6b f3 ff ff       	jmp    80107b14 <alltraps>

801087a9 <vector170>:
.globl vector170
vector170:
  pushl $0
801087a9:	6a 00                	push   $0x0
  pushl $170
801087ab:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801087b0:	e9 5f f3 ff ff       	jmp    80107b14 <alltraps>

801087b5 <vector171>:
.globl vector171
vector171:
  pushl $0
801087b5:	6a 00                	push   $0x0
  pushl $171
801087b7:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801087bc:	e9 53 f3 ff ff       	jmp    80107b14 <alltraps>

801087c1 <vector172>:
.globl vector172
vector172:
  pushl $0
801087c1:	6a 00                	push   $0x0
  pushl $172
801087c3:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801087c8:	e9 47 f3 ff ff       	jmp    80107b14 <alltraps>

801087cd <vector173>:
.globl vector173
vector173:
  pushl $0
801087cd:	6a 00                	push   $0x0
  pushl $173
801087cf:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801087d4:	e9 3b f3 ff ff       	jmp    80107b14 <alltraps>

801087d9 <vector174>:
.globl vector174
vector174:
  pushl $0
801087d9:	6a 00                	push   $0x0
  pushl $174
801087db:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801087e0:	e9 2f f3 ff ff       	jmp    80107b14 <alltraps>

801087e5 <vector175>:
.globl vector175
vector175:
  pushl $0
801087e5:	6a 00                	push   $0x0
  pushl $175
801087e7:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801087ec:	e9 23 f3 ff ff       	jmp    80107b14 <alltraps>

801087f1 <vector176>:
.globl vector176
vector176:
  pushl $0
801087f1:	6a 00                	push   $0x0
  pushl $176
801087f3:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801087f8:	e9 17 f3 ff ff       	jmp    80107b14 <alltraps>

801087fd <vector177>:
.globl vector177
vector177:
  pushl $0
801087fd:	6a 00                	push   $0x0
  pushl $177
801087ff:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108804:	e9 0b f3 ff ff       	jmp    80107b14 <alltraps>

80108809 <vector178>:
.globl vector178
vector178:
  pushl $0
80108809:	6a 00                	push   $0x0
  pushl $178
8010880b:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108810:	e9 ff f2 ff ff       	jmp    80107b14 <alltraps>

80108815 <vector179>:
.globl vector179
vector179:
  pushl $0
80108815:	6a 00                	push   $0x0
  pushl $179
80108817:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010881c:	e9 f3 f2 ff ff       	jmp    80107b14 <alltraps>

80108821 <vector180>:
.globl vector180
vector180:
  pushl $0
80108821:	6a 00                	push   $0x0
  pushl $180
80108823:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108828:	e9 e7 f2 ff ff       	jmp    80107b14 <alltraps>

8010882d <vector181>:
.globl vector181
vector181:
  pushl $0
8010882d:	6a 00                	push   $0x0
  pushl $181
8010882f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108834:	e9 db f2 ff ff       	jmp    80107b14 <alltraps>

80108839 <vector182>:
.globl vector182
vector182:
  pushl $0
80108839:	6a 00                	push   $0x0
  pushl $182
8010883b:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108840:	e9 cf f2 ff ff       	jmp    80107b14 <alltraps>

80108845 <vector183>:
.globl vector183
vector183:
  pushl $0
80108845:	6a 00                	push   $0x0
  pushl $183
80108847:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010884c:	e9 c3 f2 ff ff       	jmp    80107b14 <alltraps>

80108851 <vector184>:
.globl vector184
vector184:
  pushl $0
80108851:	6a 00                	push   $0x0
  pushl $184
80108853:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108858:	e9 b7 f2 ff ff       	jmp    80107b14 <alltraps>

8010885d <vector185>:
.globl vector185
vector185:
  pushl $0
8010885d:	6a 00                	push   $0x0
  pushl $185
8010885f:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108864:	e9 ab f2 ff ff       	jmp    80107b14 <alltraps>

80108869 <vector186>:
.globl vector186
vector186:
  pushl $0
80108869:	6a 00                	push   $0x0
  pushl $186
8010886b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108870:	e9 9f f2 ff ff       	jmp    80107b14 <alltraps>

80108875 <vector187>:
.globl vector187
vector187:
  pushl $0
80108875:	6a 00                	push   $0x0
  pushl $187
80108877:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010887c:	e9 93 f2 ff ff       	jmp    80107b14 <alltraps>

80108881 <vector188>:
.globl vector188
vector188:
  pushl $0
80108881:	6a 00                	push   $0x0
  pushl $188
80108883:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108888:	e9 87 f2 ff ff       	jmp    80107b14 <alltraps>

8010888d <vector189>:
.globl vector189
vector189:
  pushl $0
8010888d:	6a 00                	push   $0x0
  pushl $189
8010888f:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108894:	e9 7b f2 ff ff       	jmp    80107b14 <alltraps>

80108899 <vector190>:
.globl vector190
vector190:
  pushl $0
80108899:	6a 00                	push   $0x0
  pushl $190
8010889b:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801088a0:	e9 6f f2 ff ff       	jmp    80107b14 <alltraps>

801088a5 <vector191>:
.globl vector191
vector191:
  pushl $0
801088a5:	6a 00                	push   $0x0
  pushl $191
801088a7:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801088ac:	e9 63 f2 ff ff       	jmp    80107b14 <alltraps>

801088b1 <vector192>:
.globl vector192
vector192:
  pushl $0
801088b1:	6a 00                	push   $0x0
  pushl $192
801088b3:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801088b8:	e9 57 f2 ff ff       	jmp    80107b14 <alltraps>

801088bd <vector193>:
.globl vector193
vector193:
  pushl $0
801088bd:	6a 00                	push   $0x0
  pushl $193
801088bf:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801088c4:	e9 4b f2 ff ff       	jmp    80107b14 <alltraps>

801088c9 <vector194>:
.globl vector194
vector194:
  pushl $0
801088c9:	6a 00                	push   $0x0
  pushl $194
801088cb:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801088d0:	e9 3f f2 ff ff       	jmp    80107b14 <alltraps>

801088d5 <vector195>:
.globl vector195
vector195:
  pushl $0
801088d5:	6a 00                	push   $0x0
  pushl $195
801088d7:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801088dc:	e9 33 f2 ff ff       	jmp    80107b14 <alltraps>

801088e1 <vector196>:
.globl vector196
vector196:
  pushl $0
801088e1:	6a 00                	push   $0x0
  pushl $196
801088e3:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801088e8:	e9 27 f2 ff ff       	jmp    80107b14 <alltraps>

801088ed <vector197>:
.globl vector197
vector197:
  pushl $0
801088ed:	6a 00                	push   $0x0
  pushl $197
801088ef:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801088f4:	e9 1b f2 ff ff       	jmp    80107b14 <alltraps>

801088f9 <vector198>:
.globl vector198
vector198:
  pushl $0
801088f9:	6a 00                	push   $0x0
  pushl $198
801088fb:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108900:	e9 0f f2 ff ff       	jmp    80107b14 <alltraps>

80108905 <vector199>:
.globl vector199
vector199:
  pushl $0
80108905:	6a 00                	push   $0x0
  pushl $199
80108907:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010890c:	e9 03 f2 ff ff       	jmp    80107b14 <alltraps>

80108911 <vector200>:
.globl vector200
vector200:
  pushl $0
80108911:	6a 00                	push   $0x0
  pushl $200
80108913:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108918:	e9 f7 f1 ff ff       	jmp    80107b14 <alltraps>

8010891d <vector201>:
.globl vector201
vector201:
  pushl $0
8010891d:	6a 00                	push   $0x0
  pushl $201
8010891f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108924:	e9 eb f1 ff ff       	jmp    80107b14 <alltraps>

80108929 <vector202>:
.globl vector202
vector202:
  pushl $0
80108929:	6a 00                	push   $0x0
  pushl $202
8010892b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108930:	e9 df f1 ff ff       	jmp    80107b14 <alltraps>

80108935 <vector203>:
.globl vector203
vector203:
  pushl $0
80108935:	6a 00                	push   $0x0
  pushl $203
80108937:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010893c:	e9 d3 f1 ff ff       	jmp    80107b14 <alltraps>

80108941 <vector204>:
.globl vector204
vector204:
  pushl $0
80108941:	6a 00                	push   $0x0
  pushl $204
80108943:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108948:	e9 c7 f1 ff ff       	jmp    80107b14 <alltraps>

8010894d <vector205>:
.globl vector205
vector205:
  pushl $0
8010894d:	6a 00                	push   $0x0
  pushl $205
8010894f:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108954:	e9 bb f1 ff ff       	jmp    80107b14 <alltraps>

80108959 <vector206>:
.globl vector206
vector206:
  pushl $0
80108959:	6a 00                	push   $0x0
  pushl $206
8010895b:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108960:	e9 af f1 ff ff       	jmp    80107b14 <alltraps>

80108965 <vector207>:
.globl vector207
vector207:
  pushl $0
80108965:	6a 00                	push   $0x0
  pushl $207
80108967:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010896c:	e9 a3 f1 ff ff       	jmp    80107b14 <alltraps>

80108971 <vector208>:
.globl vector208
vector208:
  pushl $0
80108971:	6a 00                	push   $0x0
  pushl $208
80108973:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108978:	e9 97 f1 ff ff       	jmp    80107b14 <alltraps>

8010897d <vector209>:
.globl vector209
vector209:
  pushl $0
8010897d:	6a 00                	push   $0x0
  pushl $209
8010897f:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108984:	e9 8b f1 ff ff       	jmp    80107b14 <alltraps>

80108989 <vector210>:
.globl vector210
vector210:
  pushl $0
80108989:	6a 00                	push   $0x0
  pushl $210
8010898b:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108990:	e9 7f f1 ff ff       	jmp    80107b14 <alltraps>

80108995 <vector211>:
.globl vector211
vector211:
  pushl $0
80108995:	6a 00                	push   $0x0
  pushl $211
80108997:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010899c:	e9 73 f1 ff ff       	jmp    80107b14 <alltraps>

801089a1 <vector212>:
.globl vector212
vector212:
  pushl $0
801089a1:	6a 00                	push   $0x0
  pushl $212
801089a3:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801089a8:	e9 67 f1 ff ff       	jmp    80107b14 <alltraps>

801089ad <vector213>:
.globl vector213
vector213:
  pushl $0
801089ad:	6a 00                	push   $0x0
  pushl $213
801089af:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801089b4:	e9 5b f1 ff ff       	jmp    80107b14 <alltraps>

801089b9 <vector214>:
.globl vector214
vector214:
  pushl $0
801089b9:	6a 00                	push   $0x0
  pushl $214
801089bb:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801089c0:	e9 4f f1 ff ff       	jmp    80107b14 <alltraps>

801089c5 <vector215>:
.globl vector215
vector215:
  pushl $0
801089c5:	6a 00                	push   $0x0
  pushl $215
801089c7:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801089cc:	e9 43 f1 ff ff       	jmp    80107b14 <alltraps>

801089d1 <vector216>:
.globl vector216
vector216:
  pushl $0
801089d1:	6a 00                	push   $0x0
  pushl $216
801089d3:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801089d8:	e9 37 f1 ff ff       	jmp    80107b14 <alltraps>

801089dd <vector217>:
.globl vector217
vector217:
  pushl $0
801089dd:	6a 00                	push   $0x0
  pushl $217
801089df:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801089e4:	e9 2b f1 ff ff       	jmp    80107b14 <alltraps>

801089e9 <vector218>:
.globl vector218
vector218:
  pushl $0
801089e9:	6a 00                	push   $0x0
  pushl $218
801089eb:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801089f0:	e9 1f f1 ff ff       	jmp    80107b14 <alltraps>

801089f5 <vector219>:
.globl vector219
vector219:
  pushl $0
801089f5:	6a 00                	push   $0x0
  pushl $219
801089f7:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801089fc:	e9 13 f1 ff ff       	jmp    80107b14 <alltraps>

80108a01 <vector220>:
.globl vector220
vector220:
  pushl $0
80108a01:	6a 00                	push   $0x0
  pushl $220
80108a03:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108a08:	e9 07 f1 ff ff       	jmp    80107b14 <alltraps>

80108a0d <vector221>:
.globl vector221
vector221:
  pushl $0
80108a0d:	6a 00                	push   $0x0
  pushl $221
80108a0f:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108a14:	e9 fb f0 ff ff       	jmp    80107b14 <alltraps>

80108a19 <vector222>:
.globl vector222
vector222:
  pushl $0
80108a19:	6a 00                	push   $0x0
  pushl $222
80108a1b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108a20:	e9 ef f0 ff ff       	jmp    80107b14 <alltraps>

80108a25 <vector223>:
.globl vector223
vector223:
  pushl $0
80108a25:	6a 00                	push   $0x0
  pushl $223
80108a27:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108a2c:	e9 e3 f0 ff ff       	jmp    80107b14 <alltraps>

80108a31 <vector224>:
.globl vector224
vector224:
  pushl $0
80108a31:	6a 00                	push   $0x0
  pushl $224
80108a33:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108a38:	e9 d7 f0 ff ff       	jmp    80107b14 <alltraps>

80108a3d <vector225>:
.globl vector225
vector225:
  pushl $0
80108a3d:	6a 00                	push   $0x0
  pushl $225
80108a3f:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108a44:	e9 cb f0 ff ff       	jmp    80107b14 <alltraps>

80108a49 <vector226>:
.globl vector226
vector226:
  pushl $0
80108a49:	6a 00                	push   $0x0
  pushl $226
80108a4b:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108a50:	e9 bf f0 ff ff       	jmp    80107b14 <alltraps>

80108a55 <vector227>:
.globl vector227
vector227:
  pushl $0
80108a55:	6a 00                	push   $0x0
  pushl $227
80108a57:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108a5c:	e9 b3 f0 ff ff       	jmp    80107b14 <alltraps>

80108a61 <vector228>:
.globl vector228
vector228:
  pushl $0
80108a61:	6a 00                	push   $0x0
  pushl $228
80108a63:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108a68:	e9 a7 f0 ff ff       	jmp    80107b14 <alltraps>

80108a6d <vector229>:
.globl vector229
vector229:
  pushl $0
80108a6d:	6a 00                	push   $0x0
  pushl $229
80108a6f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108a74:	e9 9b f0 ff ff       	jmp    80107b14 <alltraps>

80108a79 <vector230>:
.globl vector230
vector230:
  pushl $0
80108a79:	6a 00                	push   $0x0
  pushl $230
80108a7b:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108a80:	e9 8f f0 ff ff       	jmp    80107b14 <alltraps>

80108a85 <vector231>:
.globl vector231
vector231:
  pushl $0
80108a85:	6a 00                	push   $0x0
  pushl $231
80108a87:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108a8c:	e9 83 f0 ff ff       	jmp    80107b14 <alltraps>

80108a91 <vector232>:
.globl vector232
vector232:
  pushl $0
80108a91:	6a 00                	push   $0x0
  pushl $232
80108a93:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108a98:	e9 77 f0 ff ff       	jmp    80107b14 <alltraps>

80108a9d <vector233>:
.globl vector233
vector233:
  pushl $0
80108a9d:	6a 00                	push   $0x0
  pushl $233
80108a9f:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108aa4:	e9 6b f0 ff ff       	jmp    80107b14 <alltraps>

80108aa9 <vector234>:
.globl vector234
vector234:
  pushl $0
80108aa9:	6a 00                	push   $0x0
  pushl $234
80108aab:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108ab0:	e9 5f f0 ff ff       	jmp    80107b14 <alltraps>

80108ab5 <vector235>:
.globl vector235
vector235:
  pushl $0
80108ab5:	6a 00                	push   $0x0
  pushl $235
80108ab7:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108abc:	e9 53 f0 ff ff       	jmp    80107b14 <alltraps>

80108ac1 <vector236>:
.globl vector236
vector236:
  pushl $0
80108ac1:	6a 00                	push   $0x0
  pushl $236
80108ac3:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108ac8:	e9 47 f0 ff ff       	jmp    80107b14 <alltraps>

80108acd <vector237>:
.globl vector237
vector237:
  pushl $0
80108acd:	6a 00                	push   $0x0
  pushl $237
80108acf:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108ad4:	e9 3b f0 ff ff       	jmp    80107b14 <alltraps>

80108ad9 <vector238>:
.globl vector238
vector238:
  pushl $0
80108ad9:	6a 00                	push   $0x0
  pushl $238
80108adb:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108ae0:	e9 2f f0 ff ff       	jmp    80107b14 <alltraps>

80108ae5 <vector239>:
.globl vector239
vector239:
  pushl $0
80108ae5:	6a 00                	push   $0x0
  pushl $239
80108ae7:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108aec:	e9 23 f0 ff ff       	jmp    80107b14 <alltraps>

80108af1 <vector240>:
.globl vector240
vector240:
  pushl $0
80108af1:	6a 00                	push   $0x0
  pushl $240
80108af3:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108af8:	e9 17 f0 ff ff       	jmp    80107b14 <alltraps>

80108afd <vector241>:
.globl vector241
vector241:
  pushl $0
80108afd:	6a 00                	push   $0x0
  pushl $241
80108aff:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108b04:	e9 0b f0 ff ff       	jmp    80107b14 <alltraps>

80108b09 <vector242>:
.globl vector242
vector242:
  pushl $0
80108b09:	6a 00                	push   $0x0
  pushl $242
80108b0b:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108b10:	e9 ff ef ff ff       	jmp    80107b14 <alltraps>

80108b15 <vector243>:
.globl vector243
vector243:
  pushl $0
80108b15:	6a 00                	push   $0x0
  pushl $243
80108b17:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108b1c:	e9 f3 ef ff ff       	jmp    80107b14 <alltraps>

80108b21 <vector244>:
.globl vector244
vector244:
  pushl $0
80108b21:	6a 00                	push   $0x0
  pushl $244
80108b23:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108b28:	e9 e7 ef ff ff       	jmp    80107b14 <alltraps>

80108b2d <vector245>:
.globl vector245
vector245:
  pushl $0
80108b2d:	6a 00                	push   $0x0
  pushl $245
80108b2f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108b34:	e9 db ef ff ff       	jmp    80107b14 <alltraps>

80108b39 <vector246>:
.globl vector246
vector246:
  pushl $0
80108b39:	6a 00                	push   $0x0
  pushl $246
80108b3b:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108b40:	e9 cf ef ff ff       	jmp    80107b14 <alltraps>

80108b45 <vector247>:
.globl vector247
vector247:
  pushl $0
80108b45:	6a 00                	push   $0x0
  pushl $247
80108b47:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108b4c:	e9 c3 ef ff ff       	jmp    80107b14 <alltraps>

80108b51 <vector248>:
.globl vector248
vector248:
  pushl $0
80108b51:	6a 00                	push   $0x0
  pushl $248
80108b53:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108b58:	e9 b7 ef ff ff       	jmp    80107b14 <alltraps>

80108b5d <vector249>:
.globl vector249
vector249:
  pushl $0
80108b5d:	6a 00                	push   $0x0
  pushl $249
80108b5f:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108b64:	e9 ab ef ff ff       	jmp    80107b14 <alltraps>

80108b69 <vector250>:
.globl vector250
vector250:
  pushl $0
80108b69:	6a 00                	push   $0x0
  pushl $250
80108b6b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108b70:	e9 9f ef ff ff       	jmp    80107b14 <alltraps>

80108b75 <vector251>:
.globl vector251
vector251:
  pushl $0
80108b75:	6a 00                	push   $0x0
  pushl $251
80108b77:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108b7c:	e9 93 ef ff ff       	jmp    80107b14 <alltraps>

80108b81 <vector252>:
.globl vector252
vector252:
  pushl $0
80108b81:	6a 00                	push   $0x0
  pushl $252
80108b83:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108b88:	e9 87 ef ff ff       	jmp    80107b14 <alltraps>

80108b8d <vector253>:
.globl vector253
vector253:
  pushl $0
80108b8d:	6a 00                	push   $0x0
  pushl $253
80108b8f:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108b94:	e9 7b ef ff ff       	jmp    80107b14 <alltraps>

80108b99 <vector254>:
.globl vector254
vector254:
  pushl $0
80108b99:	6a 00                	push   $0x0
  pushl $254
80108b9b:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108ba0:	e9 6f ef ff ff       	jmp    80107b14 <alltraps>

80108ba5 <vector255>:
.globl vector255
vector255:
  pushl $0
80108ba5:	6a 00                	push   $0x0
  pushl $255
80108ba7:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108bac:	e9 63 ef ff ff       	jmp    80107b14 <alltraps>

80108bb1 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108bb1:	55                   	push   %ebp
80108bb2:	89 e5                	mov    %esp,%ebp
80108bb4:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bba:	83 e8 01             	sub    $0x1,%eax
80108bbd:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108bc1:	8b 45 08             	mov    0x8(%ebp),%eax
80108bc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108bc8:	8b 45 08             	mov    0x8(%ebp),%eax
80108bcb:	c1 e8 10             	shr    $0x10,%eax
80108bce:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108bd2:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108bd5:	0f 01 10             	lgdtl  (%eax)
}
80108bd8:	90                   	nop
80108bd9:	c9                   	leave  
80108bda:	c3                   	ret    

80108bdb <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108bdb:	55                   	push   %ebp
80108bdc:	89 e5                	mov    %esp,%ebp
80108bde:	83 ec 04             	sub    $0x4,%esp
80108be1:	8b 45 08             	mov    0x8(%ebp),%eax
80108be4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108be8:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108bec:	0f 00 d8             	ltr    %ax
}
80108bef:	90                   	nop
80108bf0:	c9                   	leave  
80108bf1:	c3                   	ret    

80108bf2 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108bf2:	55                   	push   %ebp
80108bf3:	89 e5                	mov    %esp,%ebp
80108bf5:	83 ec 04             	sub    $0x4,%esp
80108bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80108bfb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108bff:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108c03:	8e e8                	mov    %eax,%gs
}
80108c05:	90                   	nop
80108c06:	c9                   	leave  
80108c07:	c3                   	ret    

80108c08 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108c08:	55                   	push   %ebp
80108c09:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108c0b:	8b 45 08             	mov    0x8(%ebp),%eax
80108c0e:	0f 22 d8             	mov    %eax,%cr3
}
80108c11:	90                   	nop
80108c12:	5d                   	pop    %ebp
80108c13:	c3                   	ret    

80108c14 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108c14:	55                   	push   %ebp
80108c15:	89 e5                	mov    %esp,%ebp
80108c17:	8b 45 08             	mov    0x8(%ebp),%eax
80108c1a:	05 00 00 00 80       	add    $0x80000000,%eax
80108c1f:	5d                   	pop    %ebp
80108c20:	c3                   	ret    

80108c21 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108c21:	55                   	push   %ebp
80108c22:	89 e5                	mov    %esp,%ebp
80108c24:	8b 45 08             	mov    0x8(%ebp),%eax
80108c27:	05 00 00 00 80       	add    $0x80000000,%eax
80108c2c:	5d                   	pop    %ebp
80108c2d:	c3                   	ret    

80108c2e <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108c2e:	55                   	push   %ebp
80108c2f:	89 e5                	mov    %esp,%ebp
80108c31:	53                   	push   %ebx
80108c32:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108c35:	e8 38 a4 ff ff       	call   80103072 <cpunum>
80108c3a:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108c40:	05 80 43 11 80       	add    $0x80114380,%eax
80108c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c4b:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c54:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c5d:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c64:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c68:	83 e2 f0             	and    $0xfffffff0,%edx
80108c6b:	83 ca 0a             	or     $0xa,%edx
80108c6e:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c74:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c78:	83 ca 10             	or     $0x10,%edx
80108c7b:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c81:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c85:	83 e2 9f             	and    $0xffffff9f,%edx
80108c88:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c8e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c92:	83 ca 80             	or     $0xffffff80,%edx
80108c95:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c9f:	83 ca 0f             	or     $0xf,%edx
80108ca2:	88 50 7e             	mov    %dl,0x7e(%eax)
80108ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ca8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cac:	83 e2 ef             	and    $0xffffffef,%edx
80108caf:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cb9:	83 e2 df             	and    $0xffffffdf,%edx
80108cbc:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cc6:	83 ca 40             	or     $0x40,%edx
80108cc9:	88 50 7e             	mov    %dl,0x7e(%eax)
80108ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ccf:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cd3:	83 ca 80             	or     $0xffffff80,%edx
80108cd6:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cdc:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce3:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108cea:	ff ff 
80108cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cef:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108cf6:	00 00 
80108cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cfb:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d05:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d0c:	83 e2 f0             	and    $0xfffffff0,%edx
80108d0f:	83 ca 02             	or     $0x2,%edx
80108d12:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d1b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d22:	83 ca 10             	or     $0x10,%edx
80108d25:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d2e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d35:	83 e2 9f             	and    $0xffffff9f,%edx
80108d38:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d41:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d48:	83 ca 80             	or     $0xffffff80,%edx
80108d4b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d54:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d5b:	83 ca 0f             	or     $0xf,%edx
80108d5e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d67:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d6e:	83 e2 ef             	and    $0xffffffef,%edx
80108d71:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d7a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d81:	83 e2 df             	and    $0xffffffdf,%edx
80108d84:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d8d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d94:	83 ca 40             	or     $0x40,%edx
80108d97:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108da7:	83 ca 80             	or     $0xffffff80,%edx
80108daa:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db3:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dbd:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108dc4:	ff ff 
80108dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dc9:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108dd0:	00 00 
80108dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dd5:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ddf:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108de6:	83 e2 f0             	and    $0xfffffff0,%edx
80108de9:	83 ca 0a             	or     $0xa,%edx
80108dec:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108dfc:	83 ca 10             	or     $0x10,%edx
80108dff:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e08:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108e0f:	83 ca 60             	or     $0x60,%edx
80108e12:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e1b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108e22:	83 ca 80             	or     $0xffffff80,%edx
80108e25:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e2e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e35:	83 ca 0f             	or     $0xf,%edx
80108e38:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e41:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e48:	83 e2 ef             	and    $0xffffffef,%edx
80108e4b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e54:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e5b:	83 e2 df             	and    $0xffffffdf,%edx
80108e5e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e67:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e6e:	83 ca 40             	or     $0x40,%edx
80108e71:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e7a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e81:	83 ca 80             	or     $0xffffff80,%edx
80108e84:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e8d:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e97:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108e9e:	ff ff 
80108ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ea3:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108eaa:	00 00 
80108eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eaf:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb9:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ec0:	83 e2 f0             	and    $0xfffffff0,%edx
80108ec3:	83 ca 02             	or     $0x2,%edx
80108ec6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ecf:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ed6:	83 ca 10             	or     $0x10,%edx
80108ed9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ee2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ee9:	83 ca 60             	or     $0x60,%edx
80108eec:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ef5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108efc:	83 ca 80             	or     $0xffffff80,%edx
80108eff:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f08:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f0f:	83 ca 0f             	or     $0xf,%edx
80108f12:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f1b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f22:	83 e2 ef             	and    $0xffffffef,%edx
80108f25:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f2e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f35:	83 e2 df             	and    $0xffffffdf,%edx
80108f38:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f41:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f48:	83 ca 40             	or     $0x40,%edx
80108f4b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f54:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f5b:	83 ca 80             	or     $0xffffff80,%edx
80108f5e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f67:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f71:	05 b4 00 00 00       	add    $0xb4,%eax
80108f76:	89 c3                	mov    %eax,%ebx
80108f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f7b:	05 b4 00 00 00       	add    $0xb4,%eax
80108f80:	c1 e8 10             	shr    $0x10,%eax
80108f83:	89 c2                	mov    %eax,%edx
80108f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f88:	05 b4 00 00 00       	add    $0xb4,%eax
80108f8d:	c1 e8 18             	shr    $0x18,%eax
80108f90:	89 c1                	mov    %eax,%ecx
80108f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f95:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108f9c:	00 00 
80108f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fa1:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fab:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fb4:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108fbb:	83 e2 f0             	and    $0xfffffff0,%edx
80108fbe:	83 ca 02             	or     $0x2,%edx
80108fc1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fca:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108fd1:	83 ca 10             	or     $0x10,%edx
80108fd4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fdd:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108fe4:	83 e2 9f             	and    $0xffffff9f,%edx
80108fe7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ff0:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108ff7:	83 ca 80             	or     $0xffffff80,%edx
80108ffa:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109000:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109003:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010900a:	83 e2 f0             	and    $0xfffffff0,%edx
8010900d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109013:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109016:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010901d:	83 e2 ef             	and    $0xffffffef,%edx
80109020:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109029:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109030:	83 e2 df             	and    $0xffffffdf,%edx
80109033:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010903c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109043:	83 ca 40             	or     $0x40,%edx
80109046:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010904c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010904f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109056:	83 ca 80             	or     $0xffffff80,%edx
80109059:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010905f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109062:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80109068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010906b:	83 c0 70             	add    $0x70,%eax
8010906e:	83 ec 08             	sub    $0x8,%esp
80109071:	6a 38                	push   $0x38
80109073:	50                   	push   %eax
80109074:	e8 38 fb ff ff       	call   80108bb1 <lgdt>
80109079:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010907c:	83 ec 0c             	sub    $0xc,%esp
8010907f:	6a 18                	push   $0x18
80109081:	e8 6c fb ff ff       	call   80108bf2 <loadgs>
80109086:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80109089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010908c:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80109092:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109099:	00 00 00 00 
}
8010909d:	90                   	nop
8010909e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801090a1:	c9                   	leave  
801090a2:	c3                   	ret    

801090a3 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801090a3:	55                   	push   %ebp
801090a4:	89 e5                	mov    %esp,%ebp
801090a6:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801090a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801090ac:	c1 e8 16             	shr    $0x16,%eax
801090af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801090b6:	8b 45 08             	mov    0x8(%ebp),%eax
801090b9:	01 d0                	add    %edx,%eax
801090bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801090be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090c1:	8b 00                	mov    (%eax),%eax
801090c3:	83 e0 01             	and    $0x1,%eax
801090c6:	85 c0                	test   %eax,%eax
801090c8:	74 18                	je     801090e2 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801090ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090cd:	8b 00                	mov    (%eax),%eax
801090cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090d4:	50                   	push   %eax
801090d5:	e8 47 fb ff ff       	call   80108c21 <p2v>
801090da:	83 c4 04             	add    $0x4,%esp
801090dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801090e0:	eb 48                	jmp    8010912a <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801090e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801090e6:	74 0e                	je     801090f6 <walkpgdir+0x53>
801090e8:	e8 1f 9c ff ff       	call   80102d0c <kalloc>
801090ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801090f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801090f4:	75 07                	jne    801090fd <walkpgdir+0x5a>
      return 0;
801090f6:	b8 00 00 00 00       	mov    $0x0,%eax
801090fb:	eb 44                	jmp    80109141 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801090fd:	83 ec 04             	sub    $0x4,%esp
80109100:	68 00 10 00 00       	push   $0x1000
80109105:	6a 00                	push   $0x0
80109107:	ff 75 f4             	pushl  -0xc(%ebp)
8010910a:	e8 64 d4 ff ff       	call   80106573 <memset>
8010910f:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80109112:	83 ec 0c             	sub    $0xc,%esp
80109115:	ff 75 f4             	pushl  -0xc(%ebp)
80109118:	e8 f7 fa ff ff       	call   80108c14 <v2p>
8010911d:	83 c4 10             	add    $0x10,%esp
80109120:	83 c8 07             	or     $0x7,%eax
80109123:	89 c2                	mov    %eax,%edx
80109125:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109128:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010912a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010912d:	c1 e8 0c             	shr    $0xc,%eax
80109130:	25 ff 03 00 00       	and    $0x3ff,%eax
80109135:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010913c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010913f:	01 d0                	add    %edx,%eax
}
80109141:	c9                   	leave  
80109142:	c3                   	ret    

80109143 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80109143:	55                   	push   %ebp
80109144:	89 e5                	mov    %esp,%ebp
80109146:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80109149:	8b 45 0c             	mov    0xc(%ebp),%eax
8010914c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109151:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80109154:	8b 55 0c             	mov    0xc(%ebp),%edx
80109157:	8b 45 10             	mov    0x10(%ebp),%eax
8010915a:	01 d0                	add    %edx,%eax
8010915c:	83 e8 01             	sub    $0x1,%eax
8010915f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109164:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80109167:	83 ec 04             	sub    $0x4,%esp
8010916a:	6a 01                	push   $0x1
8010916c:	ff 75 f4             	pushl  -0xc(%ebp)
8010916f:	ff 75 08             	pushl  0x8(%ebp)
80109172:	e8 2c ff ff ff       	call   801090a3 <walkpgdir>
80109177:	83 c4 10             	add    $0x10,%esp
8010917a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010917d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109181:	75 07                	jne    8010918a <mappages+0x47>
      return -1;
80109183:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109188:	eb 47                	jmp    801091d1 <mappages+0x8e>
    if(*pte & PTE_P)
8010918a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010918d:	8b 00                	mov    (%eax),%eax
8010918f:	83 e0 01             	and    $0x1,%eax
80109192:	85 c0                	test   %eax,%eax
80109194:	74 0d                	je     801091a3 <mappages+0x60>
      panic("remap");
80109196:	83 ec 0c             	sub    $0xc,%esp
80109199:	68 58 a2 10 80       	push   $0x8010a258
8010919e:	e8 c3 73 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
801091a3:	8b 45 18             	mov    0x18(%ebp),%eax
801091a6:	0b 45 14             	or     0x14(%ebp),%eax
801091a9:	83 c8 01             	or     $0x1,%eax
801091ac:	89 c2                	mov    %eax,%edx
801091ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801091b1:	89 10                	mov    %edx,(%eax)
    if(a == last)
801091b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801091b9:	74 10                	je     801091cb <mappages+0x88>
      break;
    a += PGSIZE;
801091bb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801091c2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801091c9:	eb 9c                	jmp    80109167 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801091cb:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801091cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801091d1:	c9                   	leave  
801091d2:	c3                   	ret    

801091d3 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801091d3:	55                   	push   %ebp
801091d4:	89 e5                	mov    %esp,%ebp
801091d6:	53                   	push   %ebx
801091d7:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801091da:	e8 2d 9b ff ff       	call   80102d0c <kalloc>
801091df:	89 45 f0             	mov    %eax,-0x10(%ebp)
801091e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801091e6:	75 0a                	jne    801091f2 <setupkvm+0x1f>
    return 0;
801091e8:	b8 00 00 00 00       	mov    $0x0,%eax
801091ed:	e9 8e 00 00 00       	jmp    80109280 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801091f2:	83 ec 04             	sub    $0x4,%esp
801091f5:	68 00 10 00 00       	push   $0x1000
801091fa:	6a 00                	push   $0x0
801091fc:	ff 75 f0             	pushl  -0x10(%ebp)
801091ff:	e8 6f d3 ff ff       	call   80106573 <memset>
80109204:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80109207:	83 ec 0c             	sub    $0xc,%esp
8010920a:	68 00 00 00 0e       	push   $0xe000000
8010920f:	e8 0d fa ff ff       	call   80108c21 <p2v>
80109214:	83 c4 10             	add    $0x10,%esp
80109217:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010921c:	76 0d                	jbe    8010922b <setupkvm+0x58>
    panic("PHYSTOP too high");
8010921e:	83 ec 0c             	sub    $0xc,%esp
80109221:	68 5e a2 10 80       	push   $0x8010a25e
80109226:	e8 3b 73 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010922b:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
80109232:	eb 40                	jmp    80109274 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109237:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010923a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010923d:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109243:	8b 58 08             	mov    0x8(%eax),%ebx
80109246:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109249:	8b 40 04             	mov    0x4(%eax),%eax
8010924c:	29 c3                	sub    %eax,%ebx
8010924e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109251:	8b 00                	mov    (%eax),%eax
80109253:	83 ec 0c             	sub    $0xc,%esp
80109256:	51                   	push   %ecx
80109257:	52                   	push   %edx
80109258:	53                   	push   %ebx
80109259:	50                   	push   %eax
8010925a:	ff 75 f0             	pushl  -0x10(%ebp)
8010925d:	e8 e1 fe ff ff       	call   80109143 <mappages>
80109262:	83 c4 20             	add    $0x20,%esp
80109265:	85 c0                	test   %eax,%eax
80109267:	79 07                	jns    80109270 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109269:	b8 00 00 00 00       	mov    $0x0,%eax
8010926e:	eb 10                	jmp    80109280 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109270:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80109274:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
8010927b:	72 b7                	jb     80109234 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010927d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109283:	c9                   	leave  
80109284:	c3                   	ret    

80109285 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80109285:	55                   	push   %ebp
80109286:	89 e5                	mov    %esp,%ebp
80109288:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010928b:	e8 43 ff ff ff       	call   801091d3 <setupkvm>
80109290:	a3 38 79 11 80       	mov    %eax,0x80117938
  switchkvm();
80109295:	e8 03 00 00 00       	call   8010929d <switchkvm>
}
8010929a:	90                   	nop
8010929b:	c9                   	leave  
8010929c:	c3                   	ret    

8010929d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010929d:	55                   	push   %ebp
8010929e:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801092a0:	a1 38 79 11 80       	mov    0x80117938,%eax
801092a5:	50                   	push   %eax
801092a6:	e8 69 f9 ff ff       	call   80108c14 <v2p>
801092ab:	83 c4 04             	add    $0x4,%esp
801092ae:	50                   	push   %eax
801092af:	e8 54 f9 ff ff       	call   80108c08 <lcr3>
801092b4:	83 c4 04             	add    $0x4,%esp
}
801092b7:	90                   	nop
801092b8:	c9                   	leave  
801092b9:	c3                   	ret    

801092ba <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801092ba:	55                   	push   %ebp
801092bb:	89 e5                	mov    %esp,%ebp
801092bd:	56                   	push   %esi
801092be:	53                   	push   %ebx
  pushcli();
801092bf:	e8 a9 d1 ff ff       	call   8010646d <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801092c4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801092ca:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801092d1:	83 c2 08             	add    $0x8,%edx
801092d4:	89 d6                	mov    %edx,%esi
801092d6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801092dd:	83 c2 08             	add    $0x8,%edx
801092e0:	c1 ea 10             	shr    $0x10,%edx
801092e3:	89 d3                	mov    %edx,%ebx
801092e5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801092ec:	83 c2 08             	add    $0x8,%edx
801092ef:	c1 ea 18             	shr    $0x18,%edx
801092f2:	89 d1                	mov    %edx,%ecx
801092f4:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801092fb:	67 00 
801092fd:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80109304:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
8010930a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109311:	83 e2 f0             	and    $0xfffffff0,%edx
80109314:	83 ca 09             	or     $0x9,%edx
80109317:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010931d:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109324:	83 ca 10             	or     $0x10,%edx
80109327:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010932d:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109334:	83 e2 9f             	and    $0xffffff9f,%edx
80109337:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010933d:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109344:	83 ca 80             	or     $0xffffff80,%edx
80109347:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010934d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109354:	83 e2 f0             	and    $0xfffffff0,%edx
80109357:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010935d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109364:	83 e2 ef             	and    $0xffffffef,%edx
80109367:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010936d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109374:	83 e2 df             	and    $0xffffffdf,%edx
80109377:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010937d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109384:	83 ca 40             	or     $0x40,%edx
80109387:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010938d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109394:	83 e2 7f             	and    $0x7f,%edx
80109397:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010939d:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801093a3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801093a9:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801093b0:	83 e2 ef             	and    $0xffffffef,%edx
801093b3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801093b9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801093bf:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801093c5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801093cb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801093d2:	8b 52 08             	mov    0x8(%edx),%edx
801093d5:	81 c2 00 10 00 00    	add    $0x1000,%edx
801093db:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801093de:	83 ec 0c             	sub    $0xc,%esp
801093e1:	6a 30                	push   $0x30
801093e3:	e8 f3 f7 ff ff       	call   80108bdb <ltr>
801093e8:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801093eb:	8b 45 08             	mov    0x8(%ebp),%eax
801093ee:	8b 40 04             	mov    0x4(%eax),%eax
801093f1:	85 c0                	test   %eax,%eax
801093f3:	75 0d                	jne    80109402 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801093f5:	83 ec 0c             	sub    $0xc,%esp
801093f8:	68 6f a2 10 80       	push   $0x8010a26f
801093fd:	e8 64 71 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109402:	8b 45 08             	mov    0x8(%ebp),%eax
80109405:	8b 40 04             	mov    0x4(%eax),%eax
80109408:	83 ec 0c             	sub    $0xc,%esp
8010940b:	50                   	push   %eax
8010940c:	e8 03 f8 ff ff       	call   80108c14 <v2p>
80109411:	83 c4 10             	add    $0x10,%esp
80109414:	83 ec 0c             	sub    $0xc,%esp
80109417:	50                   	push   %eax
80109418:	e8 eb f7 ff ff       	call   80108c08 <lcr3>
8010941d:	83 c4 10             	add    $0x10,%esp
  popcli();
80109420:	e8 8d d0 ff ff       	call   801064b2 <popcli>
}
80109425:	90                   	nop
80109426:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109429:	5b                   	pop    %ebx
8010942a:	5e                   	pop    %esi
8010942b:	5d                   	pop    %ebp
8010942c:	c3                   	ret    

8010942d <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010942d:	55                   	push   %ebp
8010942e:	89 e5                	mov    %esp,%ebp
80109430:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80109433:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010943a:	76 0d                	jbe    80109449 <inituvm+0x1c>
    panic("inituvm: more than a page");
8010943c:	83 ec 0c             	sub    $0xc,%esp
8010943f:	68 83 a2 10 80       	push   $0x8010a283
80109444:	e8 1d 71 ff ff       	call   80100566 <panic>
  mem = kalloc();
80109449:	e8 be 98 ff ff       	call   80102d0c <kalloc>
8010944e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80109451:	83 ec 04             	sub    $0x4,%esp
80109454:	68 00 10 00 00       	push   $0x1000
80109459:	6a 00                	push   $0x0
8010945b:	ff 75 f4             	pushl  -0xc(%ebp)
8010945e:	e8 10 d1 ff ff       	call   80106573 <memset>
80109463:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109466:	83 ec 0c             	sub    $0xc,%esp
80109469:	ff 75 f4             	pushl  -0xc(%ebp)
8010946c:	e8 a3 f7 ff ff       	call   80108c14 <v2p>
80109471:	83 c4 10             	add    $0x10,%esp
80109474:	83 ec 0c             	sub    $0xc,%esp
80109477:	6a 06                	push   $0x6
80109479:	50                   	push   %eax
8010947a:	68 00 10 00 00       	push   $0x1000
8010947f:	6a 00                	push   $0x0
80109481:	ff 75 08             	pushl  0x8(%ebp)
80109484:	e8 ba fc ff ff       	call   80109143 <mappages>
80109489:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010948c:	83 ec 04             	sub    $0x4,%esp
8010948f:	ff 75 10             	pushl  0x10(%ebp)
80109492:	ff 75 0c             	pushl  0xc(%ebp)
80109495:	ff 75 f4             	pushl  -0xc(%ebp)
80109498:	e8 95 d1 ff ff       	call   80106632 <memmove>
8010949d:	83 c4 10             	add    $0x10,%esp
}
801094a0:	90                   	nop
801094a1:	c9                   	leave  
801094a2:	c3                   	ret    

801094a3 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801094a3:	55                   	push   %ebp
801094a4:	89 e5                	mov    %esp,%ebp
801094a6:	53                   	push   %ebx
801094a7:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801094aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801094ad:	25 ff 0f 00 00       	and    $0xfff,%eax
801094b2:	85 c0                	test   %eax,%eax
801094b4:	74 0d                	je     801094c3 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801094b6:	83 ec 0c             	sub    $0xc,%esp
801094b9:	68 a0 a2 10 80       	push   $0x8010a2a0
801094be:	e8 a3 70 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801094c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801094ca:	e9 95 00 00 00       	jmp    80109564 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801094cf:	8b 55 0c             	mov    0xc(%ebp),%edx
801094d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094d5:	01 d0                	add    %edx,%eax
801094d7:	83 ec 04             	sub    $0x4,%esp
801094da:	6a 00                	push   $0x0
801094dc:	50                   	push   %eax
801094dd:	ff 75 08             	pushl  0x8(%ebp)
801094e0:	e8 be fb ff ff       	call   801090a3 <walkpgdir>
801094e5:	83 c4 10             	add    $0x10,%esp
801094e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801094eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801094ef:	75 0d                	jne    801094fe <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801094f1:	83 ec 0c             	sub    $0xc,%esp
801094f4:	68 c3 a2 10 80       	push   $0x8010a2c3
801094f9:	e8 68 70 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801094fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109501:	8b 00                	mov    (%eax),%eax
80109503:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109508:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010950b:	8b 45 18             	mov    0x18(%ebp),%eax
8010950e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109511:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109516:	77 0b                	ja     80109523 <loaduvm+0x80>
      n = sz - i;
80109518:	8b 45 18             	mov    0x18(%ebp),%eax
8010951b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010951e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109521:	eb 07                	jmp    8010952a <loaduvm+0x87>
    else
      n = PGSIZE;
80109523:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010952a:	8b 55 14             	mov    0x14(%ebp),%edx
8010952d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109530:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109533:	83 ec 0c             	sub    $0xc,%esp
80109536:	ff 75 e8             	pushl  -0x18(%ebp)
80109539:	e8 e3 f6 ff ff       	call   80108c21 <p2v>
8010953e:	83 c4 10             	add    $0x10,%esp
80109541:	ff 75 f0             	pushl  -0x10(%ebp)
80109544:	53                   	push   %ebx
80109545:	50                   	push   %eax
80109546:	ff 75 10             	pushl  0x10(%ebp)
80109549:	e8 30 8a ff ff       	call   80101f7e <readi>
8010954e:	83 c4 10             	add    $0x10,%esp
80109551:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109554:	74 07                	je     8010955d <loaduvm+0xba>
      return -1;
80109556:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010955b:	eb 18                	jmp    80109575 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010955d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109564:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109567:	3b 45 18             	cmp    0x18(%ebp),%eax
8010956a:	0f 82 5f ff ff ff    	jb     801094cf <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109570:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109575:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109578:	c9                   	leave  
80109579:	c3                   	ret    

8010957a <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010957a:	55                   	push   %ebp
8010957b:	89 e5                	mov    %esp,%ebp
8010957d:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109580:	8b 45 10             	mov    0x10(%ebp),%eax
80109583:	85 c0                	test   %eax,%eax
80109585:	79 0a                	jns    80109591 <allocuvm+0x17>
    return 0;
80109587:	b8 00 00 00 00       	mov    $0x0,%eax
8010958c:	e9 b0 00 00 00       	jmp    80109641 <allocuvm+0xc7>
  if(newsz < oldsz)
80109591:	8b 45 10             	mov    0x10(%ebp),%eax
80109594:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109597:	73 08                	jae    801095a1 <allocuvm+0x27>
    return oldsz;
80109599:	8b 45 0c             	mov    0xc(%ebp),%eax
8010959c:	e9 a0 00 00 00       	jmp    80109641 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
801095a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801095a4:	05 ff 0f 00 00       	add    $0xfff,%eax
801095a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801095ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801095b1:	eb 7f                	jmp    80109632 <allocuvm+0xb8>
    mem = kalloc();
801095b3:	e8 54 97 ff ff       	call   80102d0c <kalloc>
801095b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801095bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801095bf:	75 2b                	jne    801095ec <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801095c1:	83 ec 0c             	sub    $0xc,%esp
801095c4:	68 e1 a2 10 80       	push   $0x8010a2e1
801095c9:	e8 f8 6d ff ff       	call   801003c6 <cprintf>
801095ce:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801095d1:	83 ec 04             	sub    $0x4,%esp
801095d4:	ff 75 0c             	pushl  0xc(%ebp)
801095d7:	ff 75 10             	pushl  0x10(%ebp)
801095da:	ff 75 08             	pushl  0x8(%ebp)
801095dd:	e8 61 00 00 00       	call   80109643 <deallocuvm>
801095e2:	83 c4 10             	add    $0x10,%esp
      return 0;
801095e5:	b8 00 00 00 00       	mov    $0x0,%eax
801095ea:	eb 55                	jmp    80109641 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
801095ec:	83 ec 04             	sub    $0x4,%esp
801095ef:	68 00 10 00 00       	push   $0x1000
801095f4:	6a 00                	push   $0x0
801095f6:	ff 75 f0             	pushl  -0x10(%ebp)
801095f9:	e8 75 cf ff ff       	call   80106573 <memset>
801095fe:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109601:	83 ec 0c             	sub    $0xc,%esp
80109604:	ff 75 f0             	pushl  -0x10(%ebp)
80109607:	e8 08 f6 ff ff       	call   80108c14 <v2p>
8010960c:	83 c4 10             	add    $0x10,%esp
8010960f:	89 c2                	mov    %eax,%edx
80109611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109614:	83 ec 0c             	sub    $0xc,%esp
80109617:	6a 06                	push   $0x6
80109619:	52                   	push   %edx
8010961a:	68 00 10 00 00       	push   $0x1000
8010961f:	50                   	push   %eax
80109620:	ff 75 08             	pushl  0x8(%ebp)
80109623:	e8 1b fb ff ff       	call   80109143 <mappages>
80109628:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010962b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109632:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109635:	3b 45 10             	cmp    0x10(%ebp),%eax
80109638:	0f 82 75 ff ff ff    	jb     801095b3 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010963e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109641:	c9                   	leave  
80109642:	c3                   	ret    

80109643 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109643:	55                   	push   %ebp
80109644:	89 e5                	mov    %esp,%ebp
80109646:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109649:	8b 45 10             	mov    0x10(%ebp),%eax
8010964c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010964f:	72 08                	jb     80109659 <deallocuvm+0x16>
    return oldsz;
80109651:	8b 45 0c             	mov    0xc(%ebp),%eax
80109654:	e9 a5 00 00 00       	jmp    801096fe <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109659:	8b 45 10             	mov    0x10(%ebp),%eax
8010965c:	05 ff 0f 00 00       	add    $0xfff,%eax
80109661:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109669:	e9 81 00 00 00       	jmp    801096ef <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010966e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109671:	83 ec 04             	sub    $0x4,%esp
80109674:	6a 00                	push   $0x0
80109676:	50                   	push   %eax
80109677:	ff 75 08             	pushl  0x8(%ebp)
8010967a:	e8 24 fa ff ff       	call   801090a3 <walkpgdir>
8010967f:	83 c4 10             	add    $0x10,%esp
80109682:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109685:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109689:	75 09                	jne    80109694 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
8010968b:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109692:	eb 54                	jmp    801096e8 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109694:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109697:	8b 00                	mov    (%eax),%eax
80109699:	83 e0 01             	and    $0x1,%eax
8010969c:	85 c0                	test   %eax,%eax
8010969e:	74 48                	je     801096e8 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801096a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096a3:	8b 00                	mov    (%eax),%eax
801096a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801096ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801096b1:	75 0d                	jne    801096c0 <deallocuvm+0x7d>
        panic("kfree");
801096b3:	83 ec 0c             	sub    $0xc,%esp
801096b6:	68 f9 a2 10 80       	push   $0x8010a2f9
801096bb:	e8 a6 6e ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
801096c0:	83 ec 0c             	sub    $0xc,%esp
801096c3:	ff 75 ec             	pushl  -0x14(%ebp)
801096c6:	e8 56 f5 ff ff       	call   80108c21 <p2v>
801096cb:	83 c4 10             	add    $0x10,%esp
801096ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801096d1:	83 ec 0c             	sub    $0xc,%esp
801096d4:	ff 75 e8             	pushl  -0x18(%ebp)
801096d7:	e8 93 95 ff ff       	call   80102c6f <kfree>
801096dc:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801096df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801096e8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801096ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801096f5:	0f 82 73 ff ff ff    	jb     8010966e <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801096fb:	8b 45 10             	mov    0x10(%ebp),%eax
}
801096fe:	c9                   	leave  
801096ff:	c3                   	ret    

80109700 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109700:	55                   	push   %ebp
80109701:	89 e5                	mov    %esp,%ebp
80109703:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109706:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010970a:	75 0d                	jne    80109719 <freevm+0x19>
    panic("freevm: no pgdir");
8010970c:	83 ec 0c             	sub    $0xc,%esp
8010970f:	68 ff a2 10 80       	push   $0x8010a2ff
80109714:	e8 4d 6e ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109719:	83 ec 04             	sub    $0x4,%esp
8010971c:	6a 00                	push   $0x0
8010971e:	68 00 00 00 80       	push   $0x80000000
80109723:	ff 75 08             	pushl  0x8(%ebp)
80109726:	e8 18 ff ff ff       	call   80109643 <deallocuvm>
8010972b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010972e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109735:	eb 4f                	jmp    80109786 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010973a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109741:	8b 45 08             	mov    0x8(%ebp),%eax
80109744:	01 d0                	add    %edx,%eax
80109746:	8b 00                	mov    (%eax),%eax
80109748:	83 e0 01             	and    $0x1,%eax
8010974b:	85 c0                	test   %eax,%eax
8010974d:	74 33                	je     80109782 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010974f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109752:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109759:	8b 45 08             	mov    0x8(%ebp),%eax
8010975c:	01 d0                	add    %edx,%eax
8010975e:	8b 00                	mov    (%eax),%eax
80109760:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109765:	83 ec 0c             	sub    $0xc,%esp
80109768:	50                   	push   %eax
80109769:	e8 b3 f4 ff ff       	call   80108c21 <p2v>
8010976e:	83 c4 10             	add    $0x10,%esp
80109771:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109774:	83 ec 0c             	sub    $0xc,%esp
80109777:	ff 75 f0             	pushl  -0x10(%ebp)
8010977a:	e8 f0 94 ff ff       	call   80102c6f <kfree>
8010977f:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109782:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109786:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010978d:	76 a8                	jbe    80109737 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010978f:	83 ec 0c             	sub    $0xc,%esp
80109792:	ff 75 08             	pushl  0x8(%ebp)
80109795:	e8 d5 94 ff ff       	call   80102c6f <kfree>
8010979a:	83 c4 10             	add    $0x10,%esp
}
8010979d:	90                   	nop
8010979e:	c9                   	leave  
8010979f:	c3                   	ret    

801097a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801097a0:	55                   	push   %ebp
801097a1:	89 e5                	mov    %esp,%ebp
801097a3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801097a6:	83 ec 04             	sub    $0x4,%esp
801097a9:	6a 00                	push   $0x0
801097ab:	ff 75 0c             	pushl  0xc(%ebp)
801097ae:	ff 75 08             	pushl  0x8(%ebp)
801097b1:	e8 ed f8 ff ff       	call   801090a3 <walkpgdir>
801097b6:	83 c4 10             	add    $0x10,%esp
801097b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801097bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801097c0:	75 0d                	jne    801097cf <clearpteu+0x2f>
    panic("clearpteu");
801097c2:	83 ec 0c             	sub    $0xc,%esp
801097c5:	68 10 a3 10 80       	push   $0x8010a310
801097ca:	e8 97 6d ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801097cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097d2:	8b 00                	mov    (%eax),%eax
801097d4:	83 e0 fb             	and    $0xfffffffb,%eax
801097d7:	89 c2                	mov    %eax,%edx
801097d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097dc:	89 10                	mov    %edx,(%eax)
}
801097de:	90                   	nop
801097df:	c9                   	leave  
801097e0:	c3                   	ret    

801097e1 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801097e1:	55                   	push   %ebp
801097e2:	89 e5                	mov    %esp,%ebp
801097e4:	53                   	push   %ebx
801097e5:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801097e8:	e8 e6 f9 ff ff       	call   801091d3 <setupkvm>
801097ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
801097f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801097f4:	75 0a                	jne    80109800 <copyuvm+0x1f>
    return 0;
801097f6:	b8 00 00 00 00       	mov    $0x0,%eax
801097fb:	e9 f8 00 00 00       	jmp    801098f8 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109800:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109807:	e9 c4 00 00 00       	jmp    801098d0 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010980c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010980f:	83 ec 04             	sub    $0x4,%esp
80109812:	6a 00                	push   $0x0
80109814:	50                   	push   %eax
80109815:	ff 75 08             	pushl  0x8(%ebp)
80109818:	e8 86 f8 ff ff       	call   801090a3 <walkpgdir>
8010981d:	83 c4 10             	add    $0x10,%esp
80109820:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109823:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109827:	75 0d                	jne    80109836 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109829:	83 ec 0c             	sub    $0xc,%esp
8010982c:	68 1a a3 10 80       	push   $0x8010a31a
80109831:	e8 30 6d ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109836:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109839:	8b 00                	mov    (%eax),%eax
8010983b:	83 e0 01             	and    $0x1,%eax
8010983e:	85 c0                	test   %eax,%eax
80109840:	75 0d                	jne    8010984f <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109842:	83 ec 0c             	sub    $0xc,%esp
80109845:	68 34 a3 10 80       	push   $0x8010a334
8010984a:	e8 17 6d ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010984f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109852:	8b 00                	mov    (%eax),%eax
80109854:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109859:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010985c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010985f:	8b 00                	mov    (%eax),%eax
80109861:	25 ff 0f 00 00       	and    $0xfff,%eax
80109866:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109869:	e8 9e 94 ff ff       	call   80102d0c <kalloc>
8010986e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109871:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109875:	74 6a                	je     801098e1 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109877:	83 ec 0c             	sub    $0xc,%esp
8010987a:	ff 75 e8             	pushl  -0x18(%ebp)
8010987d:	e8 9f f3 ff ff       	call   80108c21 <p2v>
80109882:	83 c4 10             	add    $0x10,%esp
80109885:	83 ec 04             	sub    $0x4,%esp
80109888:	68 00 10 00 00       	push   $0x1000
8010988d:	50                   	push   %eax
8010988e:	ff 75 e0             	pushl  -0x20(%ebp)
80109891:	e8 9c cd ff ff       	call   80106632 <memmove>
80109896:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109899:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010989c:	83 ec 0c             	sub    $0xc,%esp
8010989f:	ff 75 e0             	pushl  -0x20(%ebp)
801098a2:	e8 6d f3 ff ff       	call   80108c14 <v2p>
801098a7:	83 c4 10             	add    $0x10,%esp
801098aa:	89 c2                	mov    %eax,%edx
801098ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098af:	83 ec 0c             	sub    $0xc,%esp
801098b2:	53                   	push   %ebx
801098b3:	52                   	push   %edx
801098b4:	68 00 10 00 00       	push   $0x1000
801098b9:	50                   	push   %eax
801098ba:	ff 75 f0             	pushl  -0x10(%ebp)
801098bd:	e8 81 f8 ff ff       	call   80109143 <mappages>
801098c2:	83 c4 20             	add    $0x20,%esp
801098c5:	85 c0                	test   %eax,%eax
801098c7:	78 1b                	js     801098e4 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801098c9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801098d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801098d6:	0f 82 30 ff ff ff    	jb     8010980c <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801098dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098df:	eb 17                	jmp    801098f8 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801098e1:	90                   	nop
801098e2:	eb 01                	jmp    801098e5 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801098e4:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801098e5:	83 ec 0c             	sub    $0xc,%esp
801098e8:	ff 75 f0             	pushl  -0x10(%ebp)
801098eb:	e8 10 fe ff ff       	call   80109700 <freevm>
801098f0:	83 c4 10             	add    $0x10,%esp
  return 0;
801098f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801098f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801098fb:	c9                   	leave  
801098fc:	c3                   	ret    

801098fd <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801098fd:	55                   	push   %ebp
801098fe:	89 e5                	mov    %esp,%ebp
80109900:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109903:	83 ec 04             	sub    $0x4,%esp
80109906:	6a 00                	push   $0x0
80109908:	ff 75 0c             	pushl  0xc(%ebp)
8010990b:	ff 75 08             	pushl  0x8(%ebp)
8010990e:	e8 90 f7 ff ff       	call   801090a3 <walkpgdir>
80109913:	83 c4 10             	add    $0x10,%esp
80109916:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010991c:	8b 00                	mov    (%eax),%eax
8010991e:	83 e0 01             	and    $0x1,%eax
80109921:	85 c0                	test   %eax,%eax
80109923:	75 07                	jne    8010992c <uva2ka+0x2f>
    return 0;
80109925:	b8 00 00 00 00       	mov    $0x0,%eax
8010992a:	eb 29                	jmp    80109955 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
8010992c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010992f:	8b 00                	mov    (%eax),%eax
80109931:	83 e0 04             	and    $0x4,%eax
80109934:	85 c0                	test   %eax,%eax
80109936:	75 07                	jne    8010993f <uva2ka+0x42>
    return 0;
80109938:	b8 00 00 00 00       	mov    $0x0,%eax
8010993d:	eb 16                	jmp    80109955 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010993f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109942:	8b 00                	mov    (%eax),%eax
80109944:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109949:	83 ec 0c             	sub    $0xc,%esp
8010994c:	50                   	push   %eax
8010994d:	e8 cf f2 ff ff       	call   80108c21 <p2v>
80109952:	83 c4 10             	add    $0x10,%esp
}
80109955:	c9                   	leave  
80109956:	c3                   	ret    

80109957 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109957:	55                   	push   %ebp
80109958:	89 e5                	mov    %esp,%ebp
8010995a:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010995d:	8b 45 10             	mov    0x10(%ebp),%eax
80109960:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109963:	eb 7f                	jmp    801099e4 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109965:	8b 45 0c             	mov    0xc(%ebp),%eax
80109968:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010996d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109970:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109973:	83 ec 08             	sub    $0x8,%esp
80109976:	50                   	push   %eax
80109977:	ff 75 08             	pushl  0x8(%ebp)
8010997a:	e8 7e ff ff ff       	call   801098fd <uva2ka>
8010997f:	83 c4 10             	add    $0x10,%esp
80109982:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109985:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109989:	75 07                	jne    80109992 <copyout+0x3b>
      return -1;
8010998b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109990:	eb 61                	jmp    801099f3 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109992:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109995:	2b 45 0c             	sub    0xc(%ebp),%eax
80109998:	05 00 10 00 00       	add    $0x1000,%eax
8010999d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801099a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099a3:	3b 45 14             	cmp    0x14(%ebp),%eax
801099a6:	76 06                	jbe    801099ae <copyout+0x57>
      n = len;
801099a8:	8b 45 14             	mov    0x14(%ebp),%eax
801099ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801099ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801099b1:	2b 45 ec             	sub    -0x14(%ebp),%eax
801099b4:	89 c2                	mov    %eax,%edx
801099b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099b9:	01 d0                	add    %edx,%eax
801099bb:	83 ec 04             	sub    $0x4,%esp
801099be:	ff 75 f0             	pushl  -0x10(%ebp)
801099c1:	ff 75 f4             	pushl  -0xc(%ebp)
801099c4:	50                   	push   %eax
801099c5:	e8 68 cc ff ff       	call   80106632 <memmove>
801099ca:	83 c4 10             	add    $0x10,%esp
    len -= n;
801099cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099d0:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801099d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099d6:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801099d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801099dc:	05 00 10 00 00       	add    $0x1000,%eax
801099e1:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801099e4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801099e8:	0f 85 77 ff ff ff    	jne    80109965 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801099ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801099f3:	c9                   	leave  
801099f4:	c3                   	ret    
