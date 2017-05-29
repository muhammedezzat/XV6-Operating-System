
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

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
8010003d:	68 24 94 10 80       	push   $0x80109424
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 d2 5c 00 00       	call   80105d1e <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 15 11 80       	mov    $0x80111584,%eax
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
801000bc:	68 80 d6 10 80       	push   $0x8010d680
801000c1:	e8 7a 5c 00 00       	call   80105d40 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 15 11 80       	mov    0x80111594,%eax
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
80100107:	68 80 d6 10 80       	push   $0x8010d680
8010010c:	e8 96 5c 00 00       	call   80105da7 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 87 4d 00 00       	call   80104eb3 <sleep>
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
8010013a:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 15 11 80       	mov    0x80111590,%eax
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
80100183:	68 80 d6 10 80       	push   $0x8010d680
80100188:	e8 1a 5c 00 00       	call   80105da7 <release>
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
8010019e:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 2b 94 10 80       	push   $0x8010942b
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
80100204:	68 3c 94 10 80       	push   $0x8010943c
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
80100243:	68 43 94 10 80       	push   $0x80109443
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 e6 5a 00 00       	call   80105d40 <acquire>
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
8010027b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 15 11 80       	mov    0x80111594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 15 11 80       	mov    %eax,0x80111594

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
801002b9:	e8 dc 4c 00 00       	call   80104f9a <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 d9 5a 00 00       	call   80105da7 <release>
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
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
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
801003cc:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 c5 10 80       	push   $0x8010c5e0
801003e2:	e8 59 59 00 00       	call   80105d40 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 4a 94 10 80       	push   $0x8010944a
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
801004cd:	c7 45 ec 53 94 10 80 	movl   $0x80109453,-0x14(%ebp)
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
80100556:	68 e0 c5 10 80       	push   $0x8010c5e0
8010055b:	e8 47 58 00 00       	call   80105da7 <release>
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
80100571:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 5a 94 10 80       	push   $0x8010945a
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
801005aa:	68 69 94 10 80       	push   $0x80109469
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 32 58 00 00       	call   80105df9 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 6b 94 10 80       	push   $0x8010946b
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
801005f5:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
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
80100699:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
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
801006ca:	68 6f 94 10 80       	push   $0x8010946f
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 66 59 00 00       	call   80106062 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 7d 58 00 00       	call   80105fa3 <memset>
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
8010077e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
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
80100798:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
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
801007b6:	e8 f2 72 00 00       	call   80107aad <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 e5 72 00 00       	call   80107aad <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 d8 72 00 00       	call   80107aad <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 c8 72 00 00       	call   80107aad <uartputc>
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
80100825:	68 e0 c5 10 80       	push   $0x8010c5e0
8010082a:	e8 11 55 00 00       	call   80105d40 <acquire>
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
801008bf:	a1 28 18 11 80       	mov    0x80111828,%eax
801008c4:	83 e8 01             	sub    $0x1,%eax
801008c7:	a3 28 18 11 80       	mov    %eax,0x80111828
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
801008dc:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008e2:	a1 24 18 11 80       	mov    0x80111824,%eax
801008e7:	39 c2                	cmp    %eax,%edx
801008e9:	0f 84 e2 00 00 00    	je     801009d1 <consoleintr+0x1d8>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008ef:	a1 28 18 11 80       	mov    0x80111828,%eax
801008f4:	83 e8 01             	sub    $0x1,%eax
801008f7:	83 e0 7f             	and    $0x7f,%eax
801008fa:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
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
8010090a:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100910:	a1 24 18 11 80       	mov    0x80111824,%eax
80100915:	39 c2                	cmp    %eax,%edx
80100917:	0f 84 b4 00 00 00    	je     801009d1 <consoleintr+0x1d8>
        input.e--;
8010091d:	a1 28 18 11 80       	mov    0x80111828,%eax
80100922:	83 e8 01             	sub    $0x1,%eax
80100925:	a3 28 18 11 80       	mov    %eax,0x80111828
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
80100949:	8b 15 28 18 11 80    	mov    0x80111828,%edx
8010094f:	a1 20 18 11 80       	mov    0x80111820,%eax
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
80100970:	a1 28 18 11 80       	mov    0x80111828,%eax
80100975:	8d 50 01             	lea    0x1(%eax),%edx
80100978:	89 15 28 18 11 80    	mov    %edx,0x80111828
8010097e:	83 e0 7f             	and    $0x7f,%eax
80100981:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100984:	88 90 a0 17 11 80    	mov    %dl,-0x7feee860(%eax)
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
801009a4:	a1 28 18 11 80       	mov    0x80111828,%eax
801009a9:	8b 15 20 18 11 80    	mov    0x80111820,%edx
801009af:	83 ea 80             	sub    $0xffffff80,%edx
801009b2:	39 d0                	cmp    %edx,%eax
801009b4:	75 1a                	jne    801009d0 <consoleintr+0x1d7>
          input.w = input.e;
801009b6:	a1 28 18 11 80       	mov    0x80111828,%eax
801009bb:	a3 24 18 11 80       	mov    %eax,0x80111824
          wakeup(&input.r);
801009c0:	83 ec 0c             	sub    $0xc,%esp
801009c3:	68 20 18 11 80       	push   $0x80111820
801009c8:	e8 cd 45 00 00       	call   80104f9a <wakeup>
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
801009e6:	68 e0 c5 10 80       	push   $0x8010c5e0
801009eb:	e8 b7 53 00 00       	call   80105da7 <release>
801009f0:	83 c4 10             	add    $0x10,%esp
  if(doprocdump)
801009f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009f7:	74 07                	je     80100a00 <consoleintr+0x207>
    procdump();  // now call procdump() wo. cons.lock held
801009f9:	e8 5c 46 00 00       	call   8010505a <procdump>
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
80100a06:	e8 98 48 00 00       	call   801052a3 <readydump>
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
80100a13:	e8 85 49 00 00       	call   8010539d <freedump>
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
80100a20:	e8 db 49 00 00       	call   80105400 <sleepdump>
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
80100a2d:	e8 76 4a 00 00       	call   801054a8 <zombiedump>
    
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
80100a52:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a57:	e8 e4 52 00 00       	call   80105d40 <acquire>
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
80100a74:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a79:	e8 29 53 00 00       	call   80105da7 <release>
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
80100a9c:	68 e0 c5 10 80       	push   $0x8010c5e0
80100aa1:	68 20 18 11 80       	push   $0x80111820
80100aa6:	e8 08 44 00 00       	call   80104eb3 <sleep>
80100aab:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100aae:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100ab4:	a1 24 18 11 80       	mov    0x80111824,%eax
80100ab9:	39 c2                	cmp    %eax,%edx
80100abb:	74 a7                	je     80100a64 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100abd:	a1 20 18 11 80       	mov    0x80111820,%eax
80100ac2:	8d 50 01             	lea    0x1(%eax),%edx
80100ac5:	89 15 20 18 11 80    	mov    %edx,0x80111820
80100acb:	83 e0 7f             	and    $0x7f,%eax
80100ace:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
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
80100ae9:	a1 20 18 11 80       	mov    0x80111820,%eax
80100aee:	83 e8 01             	sub    $0x1,%eax
80100af1:	a3 20 18 11 80       	mov    %eax,0x80111820
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
80100b1f:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b24:	e8 7e 52 00 00       	call   80105da7 <release>
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
80100b5d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b62:	e8 d9 51 00 00       	call   80105d40 <acquire>
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
80100b9f:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ba4:	e8 fe 51 00 00       	call   80105da7 <release>
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
80100bc8:	68 82 94 10 80       	push   $0x80109482
80100bcd:	68 e0 c5 10 80       	push   $0x8010c5e0
80100bd2:	e8 47 51 00 00       	call   80105d1e <initlock>
80100bd7:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bda:	c7 05 ec 21 11 80 46 	movl   $0x80100b46,0x801121ec
80100be1:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be4:	c7 05 e8 21 11 80 35 	movl   $0x80100a35,0x801121e8
80100beb:	0a 10 80 
  cons.locking = 1;
80100bee:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
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
80100c90:	e8 6d 7f 00 00       	call   80108c02 <setupkvm>
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
80100d16:	e8 8e 82 00 00       	call   80108fa9 <allocuvm>
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
80100d49:	e8 84 81 00 00       	call   80108ed2 <loaduvm>
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
80100db8:	e8 ec 81 00 00       	call   80108fa9 <allocuvm>
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
80100ddc:	e8 ee 83 00 00       	call   801091cf <clearpteu>
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
80100e15:	e8 d6 53 00 00       	call   801061f0 <strlen>
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
80100e42:	e8 a9 53 00 00       	call   801061f0 <strlen>
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
80100e68:	e8 19 85 00 00       	call   80109386 <copyout>
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
80100f04:	e8 7d 84 00 00       	call   80109386 <copyout>
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
80100f55:	e8 4c 52 00 00       	call   801061a6 <safestrcpy>
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
80100fab:	e8 39 7d 00 00       	call   80108ce9 <switchuvm>
80100fb0:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 75 d0             	pushl  -0x30(%ebp)
80100fb9:	e8 71 81 00 00       	call   8010912f <freevm>
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
80100ff3:	e8 37 81 00 00       	call   8010912f <freevm>
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
80101024:	68 8a 94 10 80       	push   $0x8010948a
80101029:	68 40 18 11 80       	push   $0x80111840
8010102e:	e8 eb 4c 00 00       	call   80105d1e <initlock>
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
80101042:	68 40 18 11 80       	push   $0x80111840
80101047:	e8 f4 4c 00 00       	call   80105d40 <acquire>
8010104c:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010104f:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
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
8010106f:	68 40 18 11 80       	push   $0x80111840
80101074:	e8 2e 4d 00 00       	call   80105da7 <release>
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
80101085:	b8 d4 21 11 80       	mov    $0x801121d4,%eax
8010108a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010108d:	72 c9                	jb     80101058 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	68 40 18 11 80       	push   $0x80111840
80101097:	e8 0b 4d 00 00       	call   80105da7 <release>
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
801010af:	68 40 18 11 80       	push   $0x80111840
801010b4:	e8 87 4c 00 00       	call   80105d40 <acquire>
801010b9:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010bc:	8b 45 08             	mov    0x8(%ebp),%eax
801010bf:	8b 40 04             	mov    0x4(%eax),%eax
801010c2:	85 c0                	test   %eax,%eax
801010c4:	7f 0d                	jg     801010d3 <filedup+0x2d>
    panic("filedup");
801010c6:	83 ec 0c             	sub    $0xc,%esp
801010c9:	68 91 94 10 80       	push   $0x80109491
801010ce:	e8 93 f4 ff ff       	call   80100566 <panic>
  f->ref++;
801010d3:	8b 45 08             	mov    0x8(%ebp),%eax
801010d6:	8b 40 04             	mov    0x4(%eax),%eax
801010d9:	8d 50 01             	lea    0x1(%eax),%edx
801010dc:	8b 45 08             	mov    0x8(%ebp),%eax
801010df:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010e2:	83 ec 0c             	sub    $0xc,%esp
801010e5:	68 40 18 11 80       	push   $0x80111840
801010ea:	e8 b8 4c 00 00       	call   80105da7 <release>
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
80101100:	68 40 18 11 80       	push   $0x80111840
80101105:	e8 36 4c 00 00       	call   80105d40 <acquire>
8010110a:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010110d:	8b 45 08             	mov    0x8(%ebp),%eax
80101110:	8b 40 04             	mov    0x4(%eax),%eax
80101113:	85 c0                	test   %eax,%eax
80101115:	7f 0d                	jg     80101124 <fileclose+0x2d>
    panic("fileclose");
80101117:	83 ec 0c             	sub    $0xc,%esp
8010111a:	68 99 94 10 80       	push   $0x80109499
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
80101140:	68 40 18 11 80       	push   $0x80111840
80101145:	e8 5d 4c 00 00       	call   80105da7 <release>
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
8010118e:	68 40 18 11 80       	push   $0x80111840
80101193:	e8 0f 4c 00 00       	call   80105da7 <release>
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
801012e2:	68 a3 94 10 80       	push   $0x801094a3
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
801013e5:	68 ac 94 10 80       	push   $0x801094ac
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
8010141b:	68 bc 94 10 80       	push   $0x801094bc
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
80101453:	e8 0a 4c 00 00       	call   80106062 <memmove>
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
80101499:	e8 05 4b 00 00       	call   80105fa3 <memset>
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
801014ec:	a1 58 22 11 80       	mov    0x80112258,%eax
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
801015ca:	a1 40 22 11 80       	mov    0x80112240,%eax
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
801015ec:	8b 15 40 22 11 80    	mov    0x80112240,%edx
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
80101600:	68 c8 94 10 80       	push   $0x801094c8
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
80101615:	68 40 22 11 80       	push   $0x80112240
8010161a:	ff 75 08             	pushl  0x8(%ebp)
8010161d:	e8 08 fe ff ff       	call   8010142a <readsb>
80101622:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101625:	8b 45 0c             	mov    0xc(%ebp),%eax
80101628:	c1 e8 0c             	shr    $0xc,%eax
8010162b:	89 c2                	mov    %eax,%edx
8010162d:	a1 58 22 11 80       	mov    0x80112258,%eax
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
80101693:	68 de 94 10 80       	push   $0x801094de
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
801016f0:	68 f1 94 10 80       	push   $0x801094f1
801016f5:	68 60 22 11 80       	push   $0x80112260
801016fa:	e8 1f 46 00 00       	call   80105d1e <initlock>
801016ff:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101702:	83 ec 08             	sub    $0x8,%esp
80101705:	68 40 22 11 80       	push   $0x80112240
8010170a:	ff 75 08             	pushl  0x8(%ebp)
8010170d:	e8 18 fd ff ff       	call   8010142a <readsb>
80101712:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101715:	a1 58 22 11 80       	mov    0x80112258,%eax
8010171a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010171d:	8b 3d 54 22 11 80    	mov    0x80112254,%edi
80101723:	8b 35 50 22 11 80    	mov    0x80112250,%esi
80101729:	8b 1d 4c 22 11 80    	mov    0x8011224c,%ebx
8010172f:	8b 0d 48 22 11 80    	mov    0x80112248,%ecx
80101735:	8b 15 44 22 11 80    	mov    0x80112244,%edx
8010173b:	a1 40 22 11 80       	mov    0x80112240,%eax
80101740:	ff 75 e4             	pushl  -0x1c(%ebp)
80101743:	57                   	push   %edi
80101744:	56                   	push   %esi
80101745:	53                   	push   %ebx
80101746:	51                   	push   %ecx
80101747:	52                   	push   %edx
80101748:	50                   	push   %eax
80101749:	68 f8 94 10 80       	push   $0x801094f8
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
80101780:	a1 54 22 11 80       	mov    0x80112254,%eax
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
801017c2:	e8 dc 47 00 00       	call   80105fa3 <memset>
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
80101816:	8b 15 48 22 11 80    	mov    0x80112248,%edx
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
8010182a:	68 4b 95 10 80       	push   $0x8010954b
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
80101847:	a1 54 22 11 80       	mov    0x80112254,%eax
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
801018d0:	e8 8d 47 00 00       	call   80106062 <memmove>
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
80101900:	68 60 22 11 80       	push   $0x80112260
80101905:	e8 36 44 00 00       	call   80105d40 <acquire>
8010190a:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010190d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101914:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
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
8010194e:	68 60 22 11 80       	push   $0x80112260
80101953:	e8 4f 44 00 00       	call   80105da7 <release>
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
8010197a:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
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
8010198c:	68 5d 95 10 80       	push   $0x8010955d
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
801019c4:	68 60 22 11 80       	push   $0x80112260
801019c9:	e8 d9 43 00 00       	call   80105da7 <release>
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
801019df:	68 60 22 11 80       	push   $0x80112260
801019e4:	e8 57 43 00 00       	call   80105d40 <acquire>
801019e9:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	8b 40 08             	mov    0x8(%eax),%eax
801019f2:	8d 50 01             	lea    0x1(%eax),%edx
801019f5:	8b 45 08             	mov    0x8(%ebp),%eax
801019f8:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019fb:	83 ec 0c             	sub    $0xc,%esp
801019fe:	68 60 22 11 80       	push   $0x80112260
80101a03:	e8 9f 43 00 00       	call   80105da7 <release>
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
80101a29:	68 6d 95 10 80       	push   $0x8010956d
80101a2e:	e8 33 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a33:	83 ec 0c             	sub    $0xc,%esp
80101a36:	68 60 22 11 80       	push   $0x80112260
80101a3b:	e8 00 43 00 00       	call   80105d40 <acquire>
80101a40:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a43:	eb 13                	jmp    80101a58 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a45:	83 ec 08             	sub    $0x8,%esp
80101a48:	68 60 22 11 80       	push   $0x80112260
80101a4d:	ff 75 08             	pushl  0x8(%ebp)
80101a50:	e8 5e 34 00 00       	call   80104eb3 <sleep>
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
80101a79:	68 60 22 11 80       	push   $0x80112260
80101a7e:	e8 24 43 00 00       	call   80105da7 <release>
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
80101aa2:	a1 54 22 11 80       	mov    0x80112254,%eax
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
80101b2b:	e8 32 45 00 00       	call   80106062 <memmove>
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
80101b61:	68 73 95 10 80       	push   $0x80109573
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
80101b94:	68 82 95 10 80       	push   $0x80109582
80101b99:	e8 c8 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b9e:	83 ec 0c             	sub    $0xc,%esp
80101ba1:	68 60 22 11 80       	push   $0x80112260
80101ba6:	e8 95 41 00 00       	call   80105d40 <acquire>
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
80101bc5:	e8 d0 33 00 00       	call   80104f9a <wakeup>
80101bca:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bcd:	83 ec 0c             	sub    $0xc,%esp
80101bd0:	68 60 22 11 80       	push   $0x80112260
80101bd5:	e8 cd 41 00 00       	call   80105da7 <release>
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
80101be9:	68 60 22 11 80       	push   $0x80112260
80101bee:	e8 4d 41 00 00       	call   80105d40 <acquire>
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
80101c36:	68 8a 95 10 80       	push   $0x8010958a
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
80101c54:	68 60 22 11 80       	push   $0x80112260
80101c59:	e8 49 41 00 00       	call   80105da7 <release>
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
80101c89:	68 60 22 11 80       	push   $0x80112260
80101c8e:	e8 ad 40 00 00       	call   80105d40 <acquire>
80101c93:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c96:	8b 45 08             	mov    0x8(%ebp),%eax
80101c99:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ca0:	83 ec 0c             	sub    $0xc,%esp
80101ca3:	ff 75 08             	pushl  0x8(%ebp)
80101ca6:	e8 ef 32 00 00       	call   80104f9a <wakeup>
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
80101cc0:	68 60 22 11 80       	push   $0x80112260
80101cc5:	e8 dd 40 00 00       	call   80105da7 <release>
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
80101e05:	68 94 95 10 80       	push   $0x80109594
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
80101fb2:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101fb9:	85 c0                	test   %eax,%eax
80101fbb:	75 0a                	jne    80101fc7 <readi+0x49>
      return -1;
80101fbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc2:	e9 0c 01 00 00       	jmp    801020d3 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101fca:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fce:	98                   	cwtl   
80101fcf:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
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
8010209c:	e8 c1 3f 00 00       	call   80106062 <memmove>
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
80102109:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80102110:	85 c0                	test   %eax,%eax
80102112:	75 0a                	jne    8010211e <writei+0x49>
      return -1;
80102114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102119:	e9 3d 01 00 00       	jmp    8010225b <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010211e:	8b 45 08             	mov    0x8(%ebp),%eax
80102121:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102125:	98                   	cwtl   
80102126:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
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
801021ee:	e8 6f 3e 00 00       	call   80106062 <memmove>
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
8010226e:	e8 85 3e 00 00       	call   801060f8 <strncmp>
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
8010228e:	68 a7 95 10 80       	push   $0x801095a7
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
801022bd:	68 b9 95 10 80       	push   $0x801095b9
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
80102392:	68 b9 95 10 80       	push   $0x801095b9
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
801023cd:	e8 7c 3d 00 00       	call   8010614e <strncpy>
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
801023f9:	68 c6 95 10 80       	push   $0x801095c6
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
8010246f:	e8 ee 3b 00 00       	call   80106062 <memmove>
80102474:	83 c4 10             	add    $0x10,%esp
80102477:	eb 26                	jmp    8010249f <skipelem+0x95>
  else {
    memmove(name, s, len);
80102479:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010247c:	83 ec 04             	sub    $0x4,%esp
8010247f:	50                   	push   %eax
80102480:	ff 75 f4             	pushl  -0xc(%ebp)
80102483:	ff 75 0c             	pushl  0xc(%ebp)
80102486:	e8 d7 3b 00 00       	call   80106062 <memmove>
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
801026db:	68 ce 95 10 80       	push   $0x801095ce
801026e0:	68 20 c6 10 80       	push   $0x8010c620
801026e5:	e8 34 36 00 00       	call   80105d1e <initlock>
801026ea:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026ed:	83 ec 0c             	sub    $0xc,%esp
801026f0:	6a 0e                	push   $0xe
801026f2:	e8 da 18 00 00       	call   80103fd1 <picenable>
801026f7:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026fa:	a1 60 39 11 80       	mov    0x80113960,%eax
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
8010274f:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
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
8010278f:	68 d2 95 10 80       	push   $0x801095d2
80102794:	e8 cd dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102799:	8b 45 08             	mov    0x8(%ebp),%eax
8010279c:	8b 40 08             	mov    0x8(%eax),%eax
8010279f:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027a4:	76 0d                	jbe    801027b3 <idestart+0x33>
    panic("incorrect blockno");
801027a6:	83 ec 0c             	sub    $0xc,%esp
801027a9:	68 db 95 10 80       	push   $0x801095db
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
801027d2:	68 d2 95 10 80       	push   $0x801095d2
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
801028e7:	68 20 c6 10 80       	push   $0x8010c620
801028ec:	e8 4f 34 00 00       	call   80105d40 <acquire>
801028f1:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028f4:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102900:	75 15                	jne    80102917 <ideintr+0x39>
    release(&idelock);
80102902:	83 ec 0c             	sub    $0xc,%esp
80102905:	68 20 c6 10 80       	push   $0x8010c620
8010290a:	e8 98 34 00 00       	call   80105da7 <release>
8010290f:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102912:	e9 9a 00 00 00       	jmp    801029b1 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291a:	8b 40 14             	mov    0x14(%eax),%eax
8010291d:	a3 54 c6 10 80       	mov    %eax,0x8010c654

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
8010297f:	e8 16 26 00 00       	call   80104f9a <wakeup>
80102984:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102987:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010298c:	85 c0                	test   %eax,%eax
8010298e:	74 11                	je     801029a1 <ideintr+0xc3>
    idestart(idequeue);
80102990:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102995:	83 ec 0c             	sub    $0xc,%esp
80102998:	50                   	push   %eax
80102999:	e8 e2 fd ff ff       	call   80102780 <idestart>
8010299e:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801029a1:	83 ec 0c             	sub    $0xc,%esp
801029a4:	68 20 c6 10 80       	push   $0x8010c620
801029a9:	e8 f9 33 00 00       	call   80105da7 <release>
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
801029c8:	68 ed 95 10 80       	push   $0x801095ed
801029cd:	e8 94 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029d2:	8b 45 08             	mov    0x8(%ebp),%eax
801029d5:	8b 00                	mov    (%eax),%eax
801029d7:	83 e0 06             	and    $0x6,%eax
801029da:	83 f8 02             	cmp    $0x2,%eax
801029dd:	75 0d                	jne    801029ec <iderw+0x39>
    panic("iderw: nothing to do");
801029df:	83 ec 0c             	sub    $0xc,%esp
801029e2:	68 01 96 10 80       	push   $0x80109601
801029e7:	e8 7a db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801029ec:	8b 45 08             	mov    0x8(%ebp),%eax
801029ef:	8b 40 04             	mov    0x4(%eax),%eax
801029f2:	85 c0                	test   %eax,%eax
801029f4:	74 16                	je     80102a0c <iderw+0x59>
801029f6:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801029fb:	85 c0                	test   %eax,%eax
801029fd:	75 0d                	jne    80102a0c <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801029ff:	83 ec 0c             	sub    $0xc,%esp
80102a02:	68 16 96 10 80       	push   $0x80109616
80102a07:	e8 5a db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a0c:	83 ec 0c             	sub    $0xc,%esp
80102a0f:	68 20 c6 10 80       	push   $0x8010c620
80102a14:	e8 27 33 00 00       	call   80105d40 <acquire>
80102a19:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a26:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
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
80102a4b:	a1 54 c6 10 80       	mov    0x8010c654,%eax
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
80102a68:	68 20 c6 10 80       	push   $0x8010c620
80102a6d:	ff 75 08             	pushl  0x8(%ebp)
80102a70:	e8 3e 24 00 00       	call   80104eb3 <sleep>
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
80102a88:	68 20 c6 10 80       	push   $0x8010c620
80102a8d:	e8 15 33 00 00       	call   80105da7 <release>
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
80102a9b:	a1 34 32 11 80       	mov    0x80113234,%eax
80102aa0:	8b 55 08             	mov    0x8(%ebp),%edx
80102aa3:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102aa5:	a1 34 32 11 80       	mov    0x80113234,%eax
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
80102ab2:	a1 34 32 11 80       	mov    0x80113234,%eax
80102ab7:	8b 55 08             	mov    0x8(%ebp),%edx
80102aba:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102abc:	a1 34 32 11 80       	mov    0x80113234,%eax
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
80102ad0:	a1 64 33 11 80       	mov    0x80113364,%eax
80102ad5:	85 c0                	test   %eax,%eax
80102ad7:	0f 84 a0 00 00 00    	je     80102b7d <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102add:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
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
80102b0c:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
80102b13:	0f b6 c0             	movzbl %al,%eax
80102b16:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b19:	74 10                	je     80102b2b <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b1b:	83 ec 0c             	sub    $0xc,%esp
80102b1e:	68 34 96 10 80       	push   $0x80109634
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
80102b83:	a1 64 33 11 80       	mov    0x80113364,%eax
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
80102bde:	68 66 96 10 80       	push   $0x80109666
80102be3:	68 40 32 11 80       	push   $0x80113240
80102be8:	e8 31 31 00 00       	call   80105d1e <initlock>
80102bed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102bf0:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
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
80102c25:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
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
80102c81:	81 7d 08 3c 69 11 80 	cmpl   $0x8011693c,0x8(%ebp)
80102c88:	72 12                	jb     80102c9c <kfree+0x2d>
80102c8a:	ff 75 08             	pushl  0x8(%ebp)
80102c8d:	e8 36 ff ff ff       	call   80102bc8 <v2p>
80102c92:	83 c4 04             	add    $0x4,%esp
80102c95:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c9a:	76 0d                	jbe    80102ca9 <kfree+0x3a>
    panic("kfree");
80102c9c:	83 ec 0c             	sub    $0xc,%esp
80102c9f:	68 6b 96 10 80       	push   $0x8010966b
80102ca4:	e8 bd d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ca9:	83 ec 04             	sub    $0x4,%esp
80102cac:	68 00 10 00 00       	push   $0x1000
80102cb1:	6a 01                	push   $0x1
80102cb3:	ff 75 08             	pushl  0x8(%ebp)
80102cb6:	e8 e8 32 00 00       	call   80105fa3 <memset>
80102cbb:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cbe:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cc3:	85 c0                	test   %eax,%eax
80102cc5:	74 10                	je     80102cd7 <kfree+0x68>
    acquire(&kmem.lock);
80102cc7:	83 ec 0c             	sub    $0xc,%esp
80102cca:	68 40 32 11 80       	push   $0x80113240
80102ccf:	e8 6c 30 00 00       	call   80105d40 <acquire>
80102cd4:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80102cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102cdd:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce6:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ceb:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102cf0:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cf5:	85 c0                	test   %eax,%eax
80102cf7:	74 10                	je     80102d09 <kfree+0x9a>
    release(&kmem.lock);
80102cf9:	83 ec 0c             	sub    $0xc,%esp
80102cfc:	68 40 32 11 80       	push   $0x80113240
80102d01:	e8 a1 30 00 00       	call   80105da7 <release>
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
80102d12:	a1 74 32 11 80       	mov    0x80113274,%eax
80102d17:	85 c0                	test   %eax,%eax
80102d19:	74 10                	je     80102d2b <kalloc+0x1f>
    acquire(&kmem.lock);
80102d1b:	83 ec 0c             	sub    $0xc,%esp
80102d1e:	68 40 32 11 80       	push   $0x80113240
80102d23:	e8 18 30 00 00       	call   80105d40 <acquire>
80102d28:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d2b:	a1 78 32 11 80       	mov    0x80113278,%eax
80102d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d37:	74 0a                	je     80102d43 <kalloc+0x37>
    kmem.freelist = r->next;
80102d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d3c:	8b 00                	mov    (%eax),%eax
80102d3e:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102d43:	a1 74 32 11 80       	mov    0x80113274,%eax
80102d48:	85 c0                	test   %eax,%eax
80102d4a:	74 10                	je     80102d5c <kalloc+0x50>
    release(&kmem.lock);
80102d4c:	83 ec 0c             	sub    $0xc,%esp
80102d4f:	68 40 32 11 80       	push   $0x80113240
80102d54:	e8 4e 30 00 00       	call   80105da7 <release>
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
80102dc1:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dc6:	83 c8 40             	or     $0x40,%eax
80102dc9:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
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
80102de4:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
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
80102e01:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e06:	0f b6 00             	movzbl (%eax),%eax
80102e09:	83 c8 40             	or     $0x40,%eax
80102e0c:	0f b6 c0             	movzbl %al,%eax
80102e0f:	f7 d0                	not    %eax
80102e11:	89 c2                	mov    %eax,%edx
80102e13:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e18:	21 d0                	and    %edx,%eax
80102e1a:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102e1f:	b8 00 00 00 00       	mov    $0x0,%eax
80102e24:	e9 a2 00 00 00       	jmp    80102ecb <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e29:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e2e:	83 e0 40             	and    $0x40,%eax
80102e31:	85 c0                	test   %eax,%eax
80102e33:	74 14                	je     80102e49 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e35:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e3c:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e41:	83 e0 bf             	and    $0xffffffbf,%eax
80102e44:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e4c:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e51:	0f b6 00             	movzbl (%eax),%eax
80102e54:	0f b6 d0             	movzbl %al,%edx
80102e57:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e5c:	09 d0                	or     %edx,%eax
80102e5e:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e66:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102e6b:	0f b6 00             	movzbl (%eax),%eax
80102e6e:	0f b6 d0             	movzbl %al,%edx
80102e71:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e76:	31 d0                	xor    %edx,%eax
80102e78:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e7d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e82:	83 e0 03             	and    $0x3,%eax
80102e85:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e8f:	01 d0                	add    %edx,%eax
80102e91:	0f b6 00             	movzbl (%eax),%eax
80102e94:	0f b6 c0             	movzbl %al,%eax
80102e97:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e9a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
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
80102f35:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f3a:	8b 55 08             	mov    0x8(%ebp),%edx
80102f3d:	c1 e2 02             	shl    $0x2,%edx
80102f40:	01 c2                	add    %eax,%edx
80102f42:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f45:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f47:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102f57:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102fca:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
8010304c:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80103086:	a1 60 c6 10 80       	mov    0x8010c660,%eax
8010308b:	8d 50 01             	lea    0x1(%eax),%edx
8010308e:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80103094:	85 c0                	test   %eax,%eax
80103096:	75 14                	jne    801030ac <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103098:	8b 45 04             	mov    0x4(%ebp),%eax
8010309b:	83 ec 08             	sub    $0x8,%esp
8010309e:	50                   	push   %eax
8010309f:	68 74 96 10 80       	push   $0x80109674
801030a4:	e8 1d d3 ff ff       	call   801003c6 <cprintf>
801030a9:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801030ac:	a1 7c 32 11 80       	mov    0x8011327c,%eax
801030b1:	85 c0                	test   %eax,%eax
801030b3:	74 0f                	je     801030c4 <cpunum+0x52>
    return lapic[ID]>>24;
801030b5:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
801030ce:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
801032ca:	e8 3b 2d 00 00       	call   8010600a <memcmp>
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
801033de:	68 a0 96 10 80       	push   $0x801096a0
801033e3:	68 80 32 11 80       	push   $0x80113280
801033e8:	e8 31 29 00 00       	call   80105d1e <initlock>
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
80103405:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
8010340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010340d:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = dev;
80103412:	8b 45 08             	mov    0x8(%ebp),%eax
80103415:	a3 c4 32 11 80       	mov    %eax,0x801132c4
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
80103434:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010343d:	01 d0                	add    %edx,%eax
8010343f:	83 c0 01             	add    $0x1,%eax
80103442:	89 c2                	mov    %eax,%edx
80103444:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103449:	83 ec 08             	sub    $0x8,%esp
8010344c:	52                   	push   %edx
8010344d:	50                   	push   %eax
8010344e:	e8 63 cd ff ff       	call   801001b6 <bread>
80103453:	83 c4 10             	add    $0x10,%esp
80103456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010345c:	83 c0 10             	add    $0x10,%eax
8010345f:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103466:	89 c2                	mov    %eax,%edx
80103468:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
80103493:	e8 ca 2b 00 00       	call   80106062 <memmove>
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
801034c9:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
801034e0:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801034e5:	89 c2                	mov    %eax,%edx
801034e7:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
8010350a:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
8010350f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103516:	eb 1b                	jmp    80103533 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103518:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010351b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010351e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103522:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103525:	83 c2 10             	add    $0x10,%edx
80103528:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010352f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103533:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
80103554:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103559:	89 c2                	mov    %eax,%edx
8010355b:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
80103579:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
8010357f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103582:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010358b:	eb 1b                	jmp    801035a8 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
8010358d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103590:	83 c0 10             	add    $0x10,%eax
80103593:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
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
801035a8:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
801035e1:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
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
801035fc:	68 80 32 11 80       	push   $0x80113280
80103601:	e8 3a 27 00 00       	call   80105d40 <acquire>
80103606:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103609:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010360e:	85 c0                	test   %eax,%eax
80103610:	74 17                	je     80103629 <begin_op+0x36>
      sleep(&log, &log.lock);
80103612:	83 ec 08             	sub    $0x8,%esp
80103615:	68 80 32 11 80       	push   $0x80113280
8010361a:	68 80 32 11 80       	push   $0x80113280
8010361f:	e8 8f 18 00 00       	call   80104eb3 <sleep>
80103624:	83 c4 10             	add    $0x10,%esp
80103627:	eb e0                	jmp    80103609 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103629:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
8010362f:	a1 bc 32 11 80       	mov    0x801132bc,%eax
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
8010364a:	68 80 32 11 80       	push   $0x80113280
8010364f:	68 80 32 11 80       	push   $0x80113280
80103654:	e8 5a 18 00 00       	call   80104eb3 <sleep>
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	eb ab                	jmp    80103609 <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010365e:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103663:	83 c0 01             	add    $0x1,%eax
80103666:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
8010366b:	83 ec 0c             	sub    $0xc,%esp
8010366e:	68 80 32 11 80       	push   $0x80113280
80103673:	e8 2f 27 00 00       	call   80105da7 <release>
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
8010368f:	68 80 32 11 80       	push   $0x80113280
80103694:	e8 a7 26 00 00       	call   80105d40 <acquire>
80103699:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010369c:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801036a1:	83 e8 01             	sub    $0x1,%eax
801036a4:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
801036a9:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801036ae:	85 c0                	test   %eax,%eax
801036b0:	74 0d                	je     801036bf <end_op+0x40>
    panic("log.committing");
801036b2:	83 ec 0c             	sub    $0xc,%esp
801036b5:	68 a4 96 10 80       	push   $0x801096a4
801036ba:	e8 a7 ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801036bf:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801036c4:	85 c0                	test   %eax,%eax
801036c6:	75 13                	jne    801036db <end_op+0x5c>
    do_commit = 1;
801036c8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036cf:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
801036d6:	00 00 00 
801036d9:	eb 10                	jmp    801036eb <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801036db:	83 ec 0c             	sub    $0xc,%esp
801036de:	68 80 32 11 80       	push   $0x80113280
801036e3:	e8 b2 18 00 00       	call   80104f9a <wakeup>
801036e8:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036eb:	83 ec 0c             	sub    $0xc,%esp
801036ee:	68 80 32 11 80       	push   $0x80113280
801036f3:	e8 af 26 00 00       	call   80105da7 <release>
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
80103709:	68 80 32 11 80       	push   $0x80113280
8010370e:	e8 2d 26 00 00       	call   80105d40 <acquire>
80103713:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103716:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
8010371d:	00 00 00 
    wakeup(&log);
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	68 80 32 11 80       	push   $0x80113280
80103728:	e8 6d 18 00 00       	call   80104f9a <wakeup>
8010372d:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	68 80 32 11 80       	push   $0x80113280
80103738:	e8 6a 26 00 00       	call   80105da7 <release>
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
80103755:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010375b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010375e:	01 d0                	add    %edx,%eax
80103760:	83 c0 01             	add    $0x1,%eax
80103763:	89 c2                	mov    %eax,%edx
80103765:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010376a:	83 ec 08             	sub    $0x8,%esp
8010376d:	52                   	push   %edx
8010376e:	50                   	push   %eax
8010376f:	e8 42 ca ff ff       	call   801001b6 <bread>
80103774:	83 c4 10             	add    $0x10,%esp
80103777:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010377a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010377d:	83 c0 10             	add    $0x10,%eax
80103780:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103787:	89 c2                	mov    %eax,%edx
80103789:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
801037b4:	e8 a9 28 00 00       	call   80106062 <memmove>
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
801037ea:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
80103801:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103806:	85 c0                	test   %eax,%eax
80103808:	7e 1e                	jle    80103828 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010380a:	e8 34 ff ff ff       	call   80103743 <write_log>
    write_head();    // Write header to disk -- the real commit
8010380f:	e8 3a fd ff ff       	call   8010354e <write_head>
    install_trans(); // Now install writes to home locations
80103814:	e8 09 fc ff ff       	call   80103422 <install_trans>
    log.lh.n = 0; 
80103819:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
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
80103831:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103836:	83 f8 1d             	cmp    $0x1d,%eax
80103839:	7f 12                	jg     8010384d <log_write+0x22>
8010383b:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103840:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
80103846:	83 ea 01             	sub    $0x1,%edx
80103849:	39 d0                	cmp    %edx,%eax
8010384b:	7c 0d                	jl     8010385a <log_write+0x2f>
    panic("too big a transaction");
8010384d:	83 ec 0c             	sub    $0xc,%esp
80103850:	68 b3 96 10 80       	push   $0x801096b3
80103855:	e8 0c cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010385a:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010385f:	85 c0                	test   %eax,%eax
80103861:	7f 0d                	jg     80103870 <log_write+0x45>
    panic("log_write outside of trans");
80103863:	83 ec 0c             	sub    $0xc,%esp
80103866:	68 c9 96 10 80       	push   $0x801096c9
8010386b:	e8 f6 cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
80103873:	68 80 32 11 80       	push   $0x80113280
80103878:	e8 c3 24 00 00       	call   80105d40 <acquire>
8010387d:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103887:	eb 1d                	jmp    801038a6 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010388c:	83 c0 10             	add    $0x10,%eax
8010388f:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
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
801038a6:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
801038c1:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
801038c8:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801038cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038d0:	75 0d                	jne    801038df <log_write+0xb4>
    log.lh.n++;
801038d2:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801038d7:	83 c0 01             	add    $0x1,%eax
801038da:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
801038df:	8b 45 08             	mov    0x8(%ebp),%eax
801038e2:	8b 00                	mov    (%eax),%eax
801038e4:	83 c8 04             	or     $0x4,%eax
801038e7:	89 c2                	mov    %eax,%edx
801038e9:	8b 45 08             	mov    0x8(%ebp),%eax
801038ec:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038ee:	83 ec 0c             	sub    $0xc,%esp
801038f1:	68 80 32 11 80       	push   $0x80113280
801038f6:	e8 ac 24 00 00       	call   80105da7 <release>
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
8010394e:	68 3c 69 11 80       	push   $0x8011693c
80103953:	e8 7d f2 ff ff       	call   80102bd5 <kinit1>
80103958:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
8010395b:	e8 54 53 00 00       	call   80108cb4 <kvmalloc>
  mpinit();        // collect info about this machine
80103960:	e8 43 04 00 00       	call   80103da8 <mpinit>
  lapicinit();
80103965:	e8 ea f5 ff ff       	call   80102f54 <lapicinit>
  seginit();       // set up segments
8010396a:	e8 ee 4c 00 00       	call   8010865d <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010396f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103975:	0f b6 00             	movzbl (%eax),%eax
80103978:	0f b6 c0             	movzbl %al,%eax
8010397b:	83 ec 08             	sub    $0x8,%esp
8010397e:	50                   	push   %eax
8010397f:	68 e4 96 10 80       	push   $0x801096e4
80103984:	e8 3d ca ff ff       	call   801003c6 <cprintf>
80103989:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010398c:	e8 6d 06 00 00       	call   80103ffe <picinit>
  ioapicinit();    // another interrupt controller
80103991:	e8 34 f1 ff ff       	call   80102aca <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103996:	e8 24 d2 ff ff       	call   80100bbf <consoleinit>
  uartinit();      // serial port
8010399b:	e8 19 40 00 00       	call   801079b9 <uartinit>
  pinit();         // process table
801039a0:	e8 5d 0b 00 00       	call   80104502 <pinit>
  tvinit();        // trap vectors
801039a5:	e8 0b 3c 00 00       	call   801075b5 <tvinit>
  binit();         // buffer cache
801039aa:	e8 85 c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039af:	e8 67 d6 ff ff       	call   8010101b <fileinit>
  ideinit();       // disk
801039b4:	e8 19 ed ff ff       	call   801026d2 <ideinit>
  if(!ismp)
801039b9:	a1 64 33 11 80       	mov    0x80113364,%eax
801039be:	85 c0                	test   %eax,%eax
801039c0:	75 05                	jne    801039c7 <main+0x92>
    timerinit();   // uniprocessor timer
801039c2:	e8 3f 3b 00 00       	call   80107506 <timerinit>
  startothers();   // start other processors
801039c7:	e8 7f 00 00 00       	call   80103a4b <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039cc:	83 ec 08             	sub    $0x8,%esp
801039cf:	68 00 00 00 8e       	push   $0x8e000000
801039d4:	68 00 00 40 80       	push   $0x80400000
801039d9:	e8 30 f2 ff ff       	call   80102c0e <kinit2>
801039de:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039e1:	e8 88 0c 00 00       	call   8010466e <userinit>
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
801039f1:	e8 d6 52 00 00       	call   80108ccc <switchkvm>
  seginit();
801039f6:	e8 62 4c 00 00       	call   8010865d <seginit>
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
80103a1b:	68 fb 96 10 80       	push   $0x801096fb
80103a20:	e8 a1 c9 ff ff       	call   801003c6 <cprintf>
80103a25:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a28:	e8 e9 3c 00 00       	call   80107716 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a2d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a33:	05 a8 00 00 00       	add    $0xa8,%eax
80103a38:	83 ec 08             	sub    $0x8,%esp
80103a3b:	6a 01                	push   $0x1
80103a3d:	50                   	push   %eax
80103a3e:	e8 d8 fe ff ff       	call   8010391b <xchg>
80103a43:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a46:	e8 18 12 00 00       	call   80104c63 <scheduler>

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
80103a6b:	68 2c c5 10 80       	push   $0x8010c52c
80103a70:	ff 75 f0             	pushl  -0x10(%ebp)
80103a73:	e8 ea 25 00 00       	call   80106062 <memmove>
80103a78:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a7b:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
80103a82:	e9 90 00 00 00       	jmp    80103b17 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a87:	e8 e6 f5 ff ff       	call   80103072 <cpunum>
80103a8c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a92:	05 80 33 11 80       	add    $0x80113380,%eax
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
80103aca:	68 00 b0 10 80       	push   $0x8010b000
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
80103b17:	a1 60 39 11 80       	mov    0x80113960,%eax
80103b1c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b22:	05 80 33 11 80       	add    $0x80113380,%eax
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
80103b82:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103b87:	89 c2                	mov    %eax,%edx
80103b89:	b8 80 33 11 80       	mov    $0x80113380,%eax
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
80103c01:	68 0c 97 10 80       	push   $0x8010970c
80103c06:	ff 75 f4             	pushl  -0xc(%ebp)
80103c09:	e8 fc 23 00 00       	call   8010600a <memcmp>
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
80103d3f:	68 11 97 10 80       	push   $0x80109711
80103d44:	ff 75 f0             	pushl  -0x10(%ebp)
80103d47:	e8 be 22 00 00       	call   8010600a <memcmp>
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
80103dae:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103db5:	33 11 80 
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
80103dd4:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103ddb:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de1:	8b 40 24             	mov    0x24(%eax),%eax
80103de4:	a3 7c 32 11 80       	mov    %eax,0x8011327c
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
80103e1b:	8b 04 85 54 97 10 80 	mov    -0x7fef68ac(,%eax,4),%eax
80103e22:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e27:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e2d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e31:	0f b6 d0             	movzbl %al,%edx
80103e34:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e39:	39 c2                	cmp    %eax,%edx
80103e3b:	74 2b                	je     80103e68 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e40:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e44:	0f b6 d0             	movzbl %al,%edx
80103e47:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e4c:	83 ec 04             	sub    $0x4,%esp
80103e4f:	52                   	push   %edx
80103e50:	50                   	push   %eax
80103e51:	68 16 97 10 80       	push   $0x80109716
80103e56:	e8 6b c5 ff ff       	call   801003c6 <cprintf>
80103e5b:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e5e:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
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
80103e79:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e7e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e84:	05 80 33 11 80       	add    $0x80113380,%eax
80103e89:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103e8e:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e93:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103e99:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e9f:	05 80 33 11 80       	add    $0x80113380,%eax
80103ea4:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103ea6:	a1 60 39 11 80       	mov    0x80113960,%eax
80103eab:	83 c0 01             	add    $0x1,%eax
80103eae:	a3 60 39 11 80       	mov    %eax,0x80113960
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
80103ec6:	a2 60 33 11 80       	mov    %al,0x80113360
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
80103ee4:	68 34 97 10 80       	push   $0x80109734
80103ee9:	e8 d8 c4 ff ff       	call   801003c6 <cprintf>
80103eee:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103ef1:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
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
80103f07:	a1 64 33 11 80       	mov    0x80113364,%eax
80103f0c:	85 c0                	test   %eax,%eax
80103f0e:	75 1d                	jne    80103f2d <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f10:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103f17:	00 00 00 
    lapic = 0;
80103f1a:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103f21:	00 00 00 
    ioapicid = 0;
80103f24:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
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
80103f9d:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
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
80103fe6:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
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
801040c4:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801040cb:	66 83 f8 ff          	cmp    $0xffff,%ax
801040cf:	74 13                	je     801040e4 <picinit+0xe6>
    picsetmask(irqmask);
801040d1:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
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
80104185:	68 68 97 10 80       	push   $0x80109768
8010418a:	50                   	push   %eax
8010418b:	e8 8e 1b 00 00       	call   80105d1e <initlock>
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
80104247:	e8 f4 1a 00 00       	call   80105d40 <acquire>
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
8010426e:	e8 27 0d 00 00       	call   80104f9a <wakeup>
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
80104291:	e8 04 0d 00 00       	call   80104f9a <wakeup>
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
801042ba:	e8 e8 1a 00 00       	call   80105da7 <release>
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
801042d9:	e8 c9 1a 00 00       	call   80105da7 <release>
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
801042f1:	e8 4a 1a 00 00       	call   80105d40 <acquire>
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
80104326:	e8 7c 1a 00 00       	call   80105da7 <release>
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
80104344:	e8 51 0c 00 00       	call   80104f9a <wakeup>
80104349:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010434c:	8b 45 08             	mov    0x8(%ebp),%eax
8010434f:	8b 55 08             	mov    0x8(%ebp),%edx
80104352:	81 c2 38 02 00 00    	add    $0x238,%edx
80104358:	83 ec 08             	sub    $0x8,%esp
8010435b:	50                   	push   %eax
8010435c:	52                   	push   %edx
8010435d:	e8 51 0b 00 00       	call   80104eb3 <sleep>
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
801043c6:	e8 cf 0b 00 00       	call   80104f9a <wakeup>
801043cb:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043ce:	8b 45 08             	mov    0x8(%ebp),%eax
801043d1:	83 ec 0c             	sub    $0xc,%esp
801043d4:	50                   	push   %eax
801043d5:	e8 cd 19 00 00       	call   80105da7 <release>
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
801043f0:	e8 4b 19 00 00       	call   80105d40 <acquire>
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
8010440e:	e8 94 19 00 00       	call   80105da7 <release>
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
80104431:	e8 7d 0a 00 00       	call   80104eb3 <sleep>
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
801044c5:	e8 d0 0a 00 00       	call   80104f9a <wakeup>
801044ca:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044cd:	8b 45 08             	mov    0x8(%ebp),%eax
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	50                   	push   %eax
801044d4:	e8 ce 18 00 00       	call   80105da7 <release>
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
8010450b:	68 70 97 10 80       	push   $0x80109770
80104510:	68 80 39 11 80       	push   $0x80113980
80104515:	e8 04 18 00 00       	call   80105d1e <initlock>
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
    goto found; // using goto similar to the original code (I think this is allowed?)   

  release(&ptable.lock);
  // END: Added for Project 3: List Management
  #else
  acquire(&ptable.lock);
80104526:	83 ec 0c             	sub    $0xc,%esp
80104529:	68 80 39 11 80       	push   $0x80113980
8010452e:	e8 0d 18 00 00       	call   80105d40 <acquire>
80104533:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104536:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010453d:	eb 11                	jmp    80104550 <allocproc+0x30>
    if(p->state == UNUSED)
8010453f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104542:	8b 40 0c             	mov    0xc(%eax),%eax
80104545:	85 c0                	test   %eax,%eax
80104547:	74 2a                	je     80104573 <allocproc+0x53>

  release(&ptable.lock);
  // END: Added for Project 3: List Management
  #else
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104549:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104550:	81 7d f4 b4 60 11 80 	cmpl   $0x801160b4,-0xc(%ebp)
80104557:	72 e6                	jb     8010453f <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104559:	83 ec 0c             	sub    $0xc,%esp
8010455c:	68 80 39 11 80       	push   $0x80113980
80104561:	e8 41 18 00 00       	call   80105da7 <release>
80104566:	83 c4 10             	add    $0x10,%esp
  #endif

  return 0;
80104569:	b8 00 00 00 00       	mov    $0x0,%eax
8010456e:	e9 f9 00 00 00       	jmp    8010466c <allocproc+0x14c>
  // END: Added for Project 3: List Management
  #else
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104573:	90                   	nop
  #endif

  return 0;

found:
  p->state = EMBRYO;
80104574:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104577:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  #ifdef CS333_P3P4
  // add new proc to embryo list
  addToStateListHead(&ptable.pLists.embryo, EMBRYO, p); // Added for Project 3: List Management
  #endif  

  p->pid = nextpid++;
8010457e:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104583:	8d 50 01             	lea    0x1(%eax),%edx
80104586:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010458c:	89 c2                	mov    %eax,%edx
8010458e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104591:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
80104594:	83 ec 0c             	sub    $0xc,%esp
80104597:	68 80 39 11 80       	push   $0x80113980
8010459c:	e8 06 18 00 00       	call   80105da7 <release>
801045a1:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801045a4:	e8 63 e7 ff ff       	call   80102d0c <kalloc>
801045a9:	89 c2                	mov    %eax,%edx
801045ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ae:	89 50 08             	mov    %edx,0x8(%eax)
801045b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b4:	8b 40 08             	mov    0x8(%eax),%eax
801045b7:	85 c0                	test   %eax,%eax
801045b9:	75 14                	jne    801045cf <allocproc+0xaf>
    addToStateListHead(&ptable.pLists.free, UNUSED, p);

    release(&ptable.lock);
    // END: Added for Project 3: List Management
    #else
    p->state = UNUSED;
801045bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #endif

    return 0;
801045c5:	b8 00 00 00 00       	mov    $0x0,%eax
801045ca:	e9 9d 00 00 00       	jmp    8010466c <allocproc+0x14c>
  }
  sp = p->kstack + KSTACKSIZE;
801045cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d2:	8b 40 08             	mov    0x8(%eax),%eax
801045d5:	05 00 10 00 00       	add    $0x1000,%eax
801045da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801045dd:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801045e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045e7:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801045ea:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801045ee:	ba 63 75 10 80       	mov    $0x80107563,%edx
801045f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045f6:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801045f8:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801045fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104602:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104608:	8b 40 1c             	mov    0x1c(%eax),%eax
8010460b:	83 ec 04             	sub    $0x4,%esp
8010460e:	6a 14                	push   $0x14
80104610:	6a 00                	push   $0x0
80104612:	50                   	push   %eax
80104613:	e8 8b 19 00 00       	call   80105fa3 <memset>
80104618:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010461b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104621:	ba 6d 4e 10 80       	mov    $0x80104e6d,%edx
80104626:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // Init value.  Added for Project 1: CTL-P
80104629:	8b 15 e0 68 11 80    	mov    0x801168e0,%edx
8010462f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104632:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total = 0; // Init value. Added for Project 2: Process Execution Time
80104635:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104638:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010463f:	00 00 00 
  p->cpu_ticks_in = 0;    // Init value. Added for Project 2: Process Execution Time
80104642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104645:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010464c:	00 00 00 
  p->priority = 0; 	  // Init to highest priority. Added for Project 4: Periodic Priority Adjustment
8010464f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104652:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104659:	00 00 00 
  p->budget = DEFAULT_BUDGET; // Init to default budget. Added for Project 4: Periodic Priority Adjustment
8010465c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465f:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80104666:	01 00 00 

  return p;
80104669:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010466c:	c9                   	leave  
8010466d:	c3                   	ret    

8010466e <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010466e:	55                   	push   %ebp
8010466f:	89 e5                	mov    %esp,%ebp
80104671:	83 ec 18             	sub    $0x18,%esp
    addToStateListHead(&ptable.pLists.free, UNUSED, &ptable.proc[i]);
    
  release(&ptable.lock);
  #endif
  // END: Added for Project 3: Initializing the Lists
  p = allocproc();
80104674:	e8 a7 fe ff ff       	call   80104520 <allocproc>
80104679:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010467c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467f:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104684:	e8 79 45 00 00       	call   80108c02 <setupkvm>
80104689:	89 c2                	mov    %eax,%edx
8010468b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468e:	89 50 04             	mov    %edx,0x4(%eax)
80104691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104694:	8b 40 04             	mov    0x4(%eax),%eax
80104697:	85 c0                	test   %eax,%eax
80104699:	75 0d                	jne    801046a8 <userinit+0x3a>
    panic("userinit: out of memory?");
8010469b:	83 ec 0c             	sub    $0xc,%esp
8010469e:	68 77 97 10 80       	push   $0x80109777
801046a3:	e8 be be ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801046a8:	ba 2c 00 00 00       	mov    $0x2c,%edx
801046ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b0:	8b 40 04             	mov    0x4(%eax),%eax
801046b3:	83 ec 04             	sub    $0x4,%esp
801046b6:	52                   	push   %edx
801046b7:	68 00 c5 10 80       	push   $0x8010c500
801046bc:	50                   	push   %eax
801046bd:	e8 9a 47 00 00       	call   80108e5c <inituvm>
801046c2:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801046c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c8:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801046ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d1:	8b 40 18             	mov    0x18(%eax),%eax
801046d4:	83 ec 04             	sub    $0x4,%esp
801046d7:	6a 4c                	push   $0x4c
801046d9:	6a 00                	push   $0x0
801046db:	50                   	push   %eax
801046dc:	e8 c2 18 00 00       	call   80105fa3 <memset>
801046e1:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801046e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e7:	8b 40 18             	mov    0x18(%eax),%eax
801046ea:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801046f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f3:	8b 40 18             	mov    0x18(%eax),%eax
801046f6:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801046fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ff:	8b 40 18             	mov    0x18(%eax),%eax
80104702:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104705:	8b 52 18             	mov    0x18(%edx),%edx
80104708:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010470c:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104710:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104713:	8b 40 18             	mov    0x18(%eax),%eax
80104716:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104719:	8b 52 18             	mov    0x18(%edx),%edx
8010471c:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104720:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104724:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104727:	8b 40 18             	mov    0x18(%eax),%eax
8010472a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104734:	8b 40 18             	mov    0x18(%eax),%eax
80104737:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010473e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104741:	8b 40 18             	mov    0x18(%eax),%eax
80104744:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  p->uid = DEFAULT_UID; // Added for Project 2: UIDs and GIDs and PPIDs
8010474b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104755:	00 00 00 
  p->gid = DEFAULT_GID; // Added for Project 2: UIDs and GIDs and PPIDs
80104758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104762:	00 00 00 


  safestrcpy(p->name, "initcode", sizeof(p->name));
80104765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104768:	83 c0 6c             	add    $0x6c,%eax
8010476b:	83 ec 04             	sub    $0x4,%esp
8010476e:	6a 10                	push   $0x10
80104770:	68 90 97 10 80       	push   $0x80109790
80104775:	50                   	push   %eax
80104776:	e8 2b 1a 00 00       	call   801061a6 <safestrcpy>
8010477b:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
8010477e:	83 ec 0c             	sub    $0xc,%esp
80104781:	68 99 97 10 80       	push   $0x80109799
80104786:	e8 43 de ff ff       	call   801025ce <namei>
8010478b:	83 c4 10             	add    $0x10,%esp
8010478e:	89 c2                	mov    %eax,%edx
80104790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104793:	89 50 68             	mov    %edx,0x68(%eax)
  p->state = RUNNABLE;
  addToStateListHead(&ptable.pLists.ready[0], RUNNABLE, p); // added to head of ready since nothing else is there. Modified for Project 4: Periodic Priority Adjustment

  release(&ptable.lock);
  #else
  p->state = RUNNABLE;
80104796:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104799:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #endif
  // END: Added for Project 3: Initializing the Lists
}
801047a0:	90                   	nop
801047a1:	c9                   	leave  
801047a2:	c3                   	ret    

801047a3 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801047a3:	55                   	push   %ebp
801047a4:	89 e5                	mov    %esp,%ebp
801047a6:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801047a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047af:	8b 00                	mov    (%eax),%eax
801047b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801047b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047b8:	7e 31                	jle    801047eb <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801047ba:	8b 55 08             	mov    0x8(%ebp),%edx
801047bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c0:	01 c2                	add    %eax,%edx
801047c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c8:	8b 40 04             	mov    0x4(%eax),%eax
801047cb:	83 ec 04             	sub    $0x4,%esp
801047ce:	52                   	push   %edx
801047cf:	ff 75 f4             	pushl  -0xc(%ebp)
801047d2:	50                   	push   %eax
801047d3:	e8 d1 47 00 00       	call   80108fa9 <allocuvm>
801047d8:	83 c4 10             	add    $0x10,%esp
801047db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047e2:	75 3e                	jne    80104822 <growproc+0x7f>
      return -1;
801047e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047e9:	eb 59                	jmp    80104844 <growproc+0xa1>
  } else if(n < 0){
801047eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047ef:	79 31                	jns    80104822 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801047f1:	8b 55 08             	mov    0x8(%ebp),%edx
801047f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f7:	01 c2                	add    %eax,%edx
801047f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ff:	8b 40 04             	mov    0x4(%eax),%eax
80104802:	83 ec 04             	sub    $0x4,%esp
80104805:	52                   	push   %edx
80104806:	ff 75 f4             	pushl  -0xc(%ebp)
80104809:	50                   	push   %eax
8010480a:	e8 63 48 00 00       	call   80109072 <deallocuvm>
8010480f:	83 c4 10             	add    $0x10,%esp
80104812:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104819:	75 07                	jne    80104822 <growproc+0x7f>
      return -1;
8010481b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104820:	eb 22                	jmp    80104844 <growproc+0xa1>
  }
  proc->sz = sz;
80104822:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104828:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010482b:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010482d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104833:	83 ec 0c             	sub    $0xc,%esp
80104836:	50                   	push   %eax
80104837:	e8 ad 44 00 00       	call   80108ce9 <switchuvm>
8010483c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010483f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104844:	c9                   	leave  
80104845:	c3                   	ret    

80104846 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104846:	55                   	push   %ebp
80104847:	89 e5                	mov    %esp,%ebp
80104849:	57                   	push   %edi
8010484a:	56                   	push   %esi
8010484b:	53                   	push   %ebx
8010484c:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010484f:	e8 cc fc ff ff       	call   80104520 <allocproc>
80104854:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104857:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010485b:	75 0a                	jne    80104867 <fork+0x21>
    return -1;
8010485d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104862:	e9 92 01 00 00       	jmp    801049f9 <fork+0x1b3>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104867:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010486d:	8b 10                	mov    (%eax),%edx
8010486f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104875:	8b 40 04             	mov    0x4(%eax),%eax
80104878:	83 ec 08             	sub    $0x8,%esp
8010487b:	52                   	push   %edx
8010487c:	50                   	push   %eax
8010487d:	e8 8e 49 00 00       	call   80109210 <copyuvm>
80104882:	83 c4 10             	add    $0x10,%esp
80104885:	89 c2                	mov    %eax,%edx
80104887:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010488a:	89 50 04             	mov    %edx,0x4(%eax)
8010488d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104890:	8b 40 04             	mov    0x4(%eax),%eax
80104893:	85 c0                	test   %eax,%eax
80104895:	75 30                	jne    801048c7 <fork+0x81>
    kfree(np->kstack);
80104897:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010489a:	8b 40 08             	mov    0x8(%eax),%eax
8010489d:	83 ec 0c             	sub    $0xc,%esp
801048a0:	50                   	push   %eax
801048a1:	e8 c9 e3 ff ff       	call   80102c6f <kfree>
801048a6:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801048a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
    addToStateListHead(&ptable.pLists.free, UNUSED, np);

    release(&ptable.lock);
    #else
    np->state = UNUSED;
801048b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #endif
    // END: Added for Project 3: List Management
    
    return -1;
801048bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048c2:	e9 32 01 00 00       	jmp    801049f9 <fork+0x1b3>
  }
  np->sz = proc->sz;
801048c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048cd:	8b 10                	mov    (%eax),%edx
801048cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048d2:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801048d4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048de:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801048e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048e4:	8b 50 18             	mov    0x18(%eax),%edx
801048e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ed:	8b 40 18             	mov    0x18(%eax),%eax
801048f0:	89 c3                	mov    %eax,%ebx
801048f2:	b8 13 00 00 00       	mov    $0x13,%eax
801048f7:	89 d7                	mov    %edx,%edi
801048f9:	89 de                	mov    %ebx,%esi
801048fb:	89 c1                	mov    %eax,%ecx
801048fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->uid = proc->uid; // Added for Project 2: UIDs and GIDs and PPIDs
801048ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104905:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010490b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010490e:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid; // Added for Project 2: UIDs and GIDs and PPIDs
80104914:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104920:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104923:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104929:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010492c:	8b 40 18             	mov    0x18(%eax),%eax
8010492f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104936:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010493d:	eb 43                	jmp    80104982 <fork+0x13c>
    if(proc->ofile[i])
8010493f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104945:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104948:	83 c2 08             	add    $0x8,%edx
8010494b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010494f:	85 c0                	test   %eax,%eax
80104951:	74 2b                	je     8010497e <fork+0x138>
      np->ofile[i] = filedup(proc->ofile[i]);
80104953:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104959:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010495c:	83 c2 08             	add    $0x8,%edx
8010495f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104963:	83 ec 0c             	sub    $0xc,%esp
80104966:	50                   	push   %eax
80104967:	e8 3a c7 ff ff       	call   801010a6 <filedup>
8010496c:	83 c4 10             	add    $0x10,%esp
8010496f:	89 c1                	mov    %eax,%ecx
80104971:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104974:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104977:	83 c2 08             	add    $0x8,%edx
8010497a:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np->gid = proc->gid; // Added for Project 2: UIDs and GIDs and PPIDs

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010497e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104982:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104986:	7e b7                	jle    8010493f <fork+0xf9>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104988:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498e:	8b 40 68             	mov    0x68(%eax),%eax
80104991:	83 ec 0c             	sub    $0xc,%esp
80104994:	50                   	push   %eax
80104995:	e8 3c d0 ff ff       	call   801019d6 <idup>
8010499a:	83 c4 10             	add    $0x10,%esp
8010499d:	89 c2                	mov    %eax,%edx
8010499f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049a2:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801049a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ab:	8d 50 6c             	lea    0x6c(%eax),%edx
801049ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049b1:	83 c0 6c             	add    $0x6c,%eax
801049b4:	83 ec 04             	sub    $0x4,%esp
801049b7:	6a 10                	push   $0x10
801049b9:	52                   	push   %edx
801049ba:	50                   	push   %eax
801049bb:	e8 e6 17 00 00       	call   801061a6 <safestrcpy>
801049c0:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
801049c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049c6:	8b 40 10             	mov    0x10(%eax),%eax
801049c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  addToStateListTail(&ptable.pLists.ready[0], RUNNABLE, np); // Modified for Project 4: Periodic Priority Adjustment

  release(&ptable.lock);
  #else
  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801049cc:	83 ec 0c             	sub    $0xc,%esp
801049cf:	68 80 39 11 80       	push   $0x80113980
801049d4:	e8 67 13 00 00       	call   80105d40 <acquire>
801049d9:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801049dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801049e6:	83 ec 0c             	sub    $0xc,%esp
801049e9:	68 80 39 11 80       	push   $0x80113980
801049ee:	e8 b4 13 00 00       	call   80105da7 <release>
801049f3:	83 c4 10             	add    $0x10,%esp
  #endif
  // END: Added for Project 3: List Management
  
  return pid;
801049f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801049f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049fc:	5b                   	pop    %ebx
801049fd:	5e                   	pop    %esi
801049fe:	5f                   	pop    %edi
801049ff:	5d                   	pop    %ebp
80104a00:	c3                   	ret    

80104a01 <exit>:
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
80104a01:	55                   	push   %ebp
80104a02:	89 e5                	mov    %esp,%ebp
80104a04:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104a07:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a0e:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104a13:	39 c2                	cmp    %eax,%edx
80104a15:	75 0d                	jne    80104a24 <exit+0x23>
    panic("init exiting");
80104a17:	83 ec 0c             	sub    $0xc,%esp
80104a1a:	68 9b 97 10 80       	push   $0x8010979b
80104a1f:	e8 42 bb ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104a2b:	eb 48                	jmp    80104a75 <exit+0x74>
    if(proc->ofile[fd]){
80104a2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a33:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a36:	83 c2 08             	add    $0x8,%edx
80104a39:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a3d:	85 c0                	test   %eax,%eax
80104a3f:	74 30                	je     80104a71 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104a41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a47:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a4a:	83 c2 08             	add    $0x8,%edx
80104a4d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a51:	83 ec 0c             	sub    $0xc,%esp
80104a54:	50                   	push   %eax
80104a55:	e8 9d c6 ff ff       	call   801010f7 <fileclose>
80104a5a:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a63:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a66:	83 c2 08             	add    $0x8,%edx
80104a69:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a70:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a71:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a75:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a79:	7e b2                	jle    80104a2d <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104a7b:	e8 73 eb ff ff       	call   801035f3 <begin_op>
  iput(proc->cwd);
80104a80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a86:	8b 40 68             	mov    0x68(%eax),%eax
80104a89:	83 ec 0c             	sub    $0xc,%esp
80104a8c:	50                   	push   %eax
80104a8d:	e8 4e d1 ff ff       	call   80101be0 <iput>
80104a92:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a95:	e8 e5 eb ff ff       	call   8010367f <end_op>
  proc->cwd = 0;
80104a9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa0:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104aa7:	83 ec 0c             	sub    $0xc,%esp
80104aaa:	68 80 39 11 80       	push   $0x80113980
80104aaf:	e8 8c 12 00 00       	call   80105d40 <acquire>
80104ab4:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104ab7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104abd:	8b 40 14             	mov    0x14(%eax),%eax
80104ac0:	83 ec 0c             	sub    $0xc,%esp
80104ac3:	50                   	push   %eax
80104ac4:	e8 8f 04 00 00       	call   80104f58 <wakeup1>
80104ac9:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104acc:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104ad3:	eb 3f                	jmp    80104b14 <exit+0x113>
    if(p->parent == proc){
80104ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad8:	8b 50 14             	mov    0x14(%eax),%edx
80104adb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae1:	39 c2                	cmp    %eax,%edx
80104ae3:	75 28                	jne    80104b0d <exit+0x10c>
      p->parent = initproc;
80104ae5:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aee:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af4:	8b 40 0c             	mov    0xc(%eax),%eax
80104af7:	83 f8 05             	cmp    $0x5,%eax
80104afa:	75 11                	jne    80104b0d <exit+0x10c>
        wakeup1(initproc);
80104afc:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104b01:	83 ec 0c             	sub    $0xc,%esp
80104b04:	50                   	push   %eax
80104b05:	e8 4e 04 00 00       	call   80104f58 <wakeup1>
80104b0a:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b0d:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104b14:	81 7d f4 b4 60 11 80 	cmpl   $0x801160b4,-0xc(%ebp)
80104b1b:	72 b8                	jb     80104ad5 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104b1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b23:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104b2a:	e8 11 02 00 00       	call   80104d40 <sched>
  panic("zombie exit");
80104b2f:	83 ec 0c             	sub    $0xc,%esp
80104b32:	68 a8 97 10 80       	push   $0x801097a8
80104b37:	e8 2a ba ff ff       	call   80100566 <panic>

80104b3c <wait>:
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
80104b3c:	55                   	push   %ebp
80104b3d:	89 e5                	mov    %esp,%ebp
80104b3f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b42:	83 ec 0c             	sub    $0xc,%esp
80104b45:	68 80 39 11 80       	push   $0x80113980
80104b4a:	e8 f1 11 00 00       	call   80105d40 <acquire>
80104b4f:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b52:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b59:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104b60:	e9 a9 00 00 00       	jmp    80104c0e <wait+0xd2>
      if(p->parent != proc)
80104b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b68:	8b 50 14             	mov    0x14(%eax),%edx
80104b6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b71:	39 c2                	cmp    %eax,%edx
80104b73:	0f 85 8d 00 00 00    	jne    80104c06 <wait+0xca>
        continue;
      havekids = 1;
80104b79:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b83:	8b 40 0c             	mov    0xc(%eax),%eax
80104b86:	83 f8 05             	cmp    $0x5,%eax
80104b89:	75 7c                	jne    80104c07 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8e:	8b 40 10             	mov    0x10(%eax),%eax
80104b91:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b97:	8b 40 08             	mov    0x8(%eax),%eax
80104b9a:	83 ec 0c             	sub    $0xc,%esp
80104b9d:	50                   	push   %eax
80104b9e:	e8 cc e0 ff ff       	call   80102c6f <kfree>
80104ba3:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb3:	8b 40 04             	mov    0x4(%eax),%eax
80104bb6:	83 ec 0c             	sub    $0xc,%esp
80104bb9:	50                   	push   %eax
80104bba:	e8 70 45 00 00       	call   8010912f <freevm>
80104bbf:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bcf:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be3:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bea:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104bf1:	83 ec 0c             	sub    $0xc,%esp
80104bf4:	68 80 39 11 80       	push   $0x80113980
80104bf9:	e8 a9 11 00 00       	call   80105da7 <release>
80104bfe:	83 c4 10             	add    $0x10,%esp
        return pid;
80104c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c04:	eb 5b                	jmp    80104c61 <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104c06:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c07:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104c0e:	81 7d f4 b4 60 11 80 	cmpl   $0x801160b4,-0xc(%ebp)
80104c15:	0f 82 4a ff ff ff    	jb     80104b65 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104c1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c1f:	74 0d                	je     80104c2e <wait+0xf2>
80104c21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c27:	8b 40 24             	mov    0x24(%eax),%eax
80104c2a:	85 c0                	test   %eax,%eax
80104c2c:	74 17                	je     80104c45 <wait+0x109>
      release(&ptable.lock);
80104c2e:	83 ec 0c             	sub    $0xc,%esp
80104c31:	68 80 39 11 80       	push   $0x80113980
80104c36:	e8 6c 11 00 00       	call   80105da7 <release>
80104c3b:	83 c4 10             	add    $0x10,%esp
      return -1;
80104c3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c43:	eb 1c                	jmp    80104c61 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c4b:	83 ec 08             	sub    $0x8,%esp
80104c4e:	68 80 39 11 80       	push   $0x80113980
80104c53:	50                   	push   %eax
80104c54:	e8 5a 02 00 00       	call   80104eb3 <sleep>
80104c59:	83 c4 10             	add    $0x10,%esp
  }
80104c5c:	e9 f1 fe ff ff       	jmp    80104b52 <wait+0x16>
}
80104c61:	c9                   	leave  
80104c62:	c3                   	ret    

80104c63 <scheduler>:
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
80104c63:	55                   	push   %ebp
80104c64:	89 e5                	mov    %esp,%ebp
80104c66:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c69:	e8 8d f8 ff ff       	call   801044fb <sti>

    idle = 1;  // assume idle unless we schedule a process
80104c6e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c75:	83 ec 0c             	sub    $0xc,%esp
80104c78:	68 80 39 11 80       	push   $0x80113980
80104c7d:	e8 be 10 00 00       	call   80105d40 <acquire>
80104c82:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c85:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104c8c:	eb 7c                	jmp    80104d0a <scheduler+0xa7>
      if(p->state != RUNNABLE)
80104c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c91:	8b 40 0c             	mov    0xc(%eax),%eax
80104c94:	83 f8 03             	cmp    $0x3,%eax
80104c97:	75 69                	jne    80104d02 <scheduler+0x9f>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
80104c99:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      proc = p;
80104ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ca3:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104ca9:	83 ec 0c             	sub    $0xc,%esp
80104cac:	ff 75 f4             	pushl  -0xc(%ebp)
80104caf:	e8 35 40 00 00       	call   80108ce9 <switchuvm>
80104cb4:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cba:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      p->cpu_ticks_in = ticks; // set tick that proc enters CPU. Added for Project 2: Process Execution Time
80104cc1:	8b 15 e0 68 11 80    	mov    0x801168e0,%edx
80104cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cca:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)

      swtch(&cpu->scheduler, proc->context);
80104cd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cd6:	8b 40 1c             	mov    0x1c(%eax),%eax
80104cd9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ce0:	83 c2 04             	add    $0x4,%edx
80104ce3:	83 ec 08             	sub    $0x8,%esp
80104ce6:	50                   	push   %eax
80104ce7:	52                   	push   %edx
80104ce8:	e8 2a 15 00 00       	call   80106217 <swtch>
80104ced:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104cf0:	e8 d7 3f 00 00       	call   80108ccc <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104cf5:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104cfc:	00 00 00 00 
80104d00:	eb 01                	jmp    80104d03 <scheduler+0xa0>
    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104d02:	90                   	nop
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d03:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104d0a:	81 7d f4 b4 60 11 80 	cmpl   $0x801160b4,-0xc(%ebp)
80104d11:	0f 82 77 ff ff ff    	jb     80104c8e <scheduler+0x2b>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104d17:	83 ec 0c             	sub    $0xc,%esp
80104d1a:	68 80 39 11 80       	push   $0x80113980
80104d1f:	e8 83 10 00 00       	call   80105da7 <release>
80104d24:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
80104d27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104d2b:	0f 84 38 ff ff ff    	je     80104c69 <scheduler+0x6>
      sti();
80104d31:	e8 c5 f7 ff ff       	call   801044fb <sti>
      hlt();
80104d36:	e8 a9 f7 ff ff       	call   801044e4 <hlt>
    }
  }
80104d3b:	e9 29 ff ff ff       	jmp    80104c69 <scheduler+0x6>

80104d40 <sched>:
// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	53                   	push   %ebx
80104d44:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d47:	83 ec 0c             	sub    $0xc,%esp
80104d4a:	68 80 39 11 80       	push   $0x80113980
80104d4f:	e8 1f 11 00 00       	call   80105e73 <holding>
80104d54:	83 c4 10             	add    $0x10,%esp
80104d57:	85 c0                	test   %eax,%eax
80104d59:	75 0d                	jne    80104d68 <sched+0x28>
    panic("sched ptable.lock");
80104d5b:	83 ec 0c             	sub    $0xc,%esp
80104d5e:	68 b4 97 10 80       	push   $0x801097b4
80104d63:	e8 fe b7 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104d68:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d6e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d74:	83 f8 01             	cmp    $0x1,%eax
80104d77:	74 0d                	je     80104d86 <sched+0x46>
    panic("sched locks");
80104d79:	83 ec 0c             	sub    $0xc,%esp
80104d7c:	68 c6 97 10 80       	push   $0x801097c6
80104d81:	e8 e0 b7 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104d86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d8c:	8b 40 0c             	mov    0xc(%eax),%eax
80104d8f:	83 f8 04             	cmp    $0x4,%eax
80104d92:	75 0d                	jne    80104da1 <sched+0x61>
    panic("sched running");
80104d94:	83 ec 0c             	sub    $0xc,%esp
80104d97:	68 d2 97 10 80       	push   $0x801097d2
80104d9c:	e8 c5 b7 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104da1:	e8 45 f7 ff ff       	call   801044eb <readeflags>
80104da6:	25 00 02 00 00       	and    $0x200,%eax
80104dab:	85 c0                	test   %eax,%eax
80104dad:	74 0d                	je     80104dbc <sched+0x7c>
    panic("sched interruptible");
80104daf:	83 ec 0c             	sub    $0xc,%esp
80104db2:	68 e0 97 10 80       	push   $0x801097e0
80104db7:	e8 aa b7 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104dbc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dc2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104dc8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // add time delta to total CPU time. Added for Project 2: Process Execution Time
80104dcb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dd1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104dd8:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80104dde:	8b 1d e0 68 11 80    	mov    0x801168e0,%ebx
80104de4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104deb:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80104df1:	29 d3                	sub    %edx,%ebx
80104df3:	89 da                	mov    %ebx,%edx
80104df5:	01 ca                	add    %ecx,%edx
80104df7:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)

  swtch(&proc->context, cpu->scheduler);
80104dfd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e03:	8b 40 04             	mov    0x4(%eax),%eax
80104e06:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e0d:	83 c2 1c             	add    $0x1c,%edx
80104e10:	83 ec 08             	sub    $0x8,%esp
80104e13:	50                   	push   %eax
80104e14:	52                   	push   %edx
80104e15:	e8 fd 13 00 00       	call   80106217 <swtch>
80104e1a:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104e1d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e26:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104e2c:	90                   	nop
80104e2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e30:	c9                   	leave  
80104e31:	c3                   	ret    

80104e32 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104e32:	55                   	push   %ebp
80104e33:	89 e5                	mov    %esp,%ebp
80104e35:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104e38:	83 ec 0c             	sub    $0xc,%esp
80104e3b:	68 80 39 11 80       	push   $0x80113980
80104e40:	e8 fb 0e 00 00       	call   80105d40 <acquire>
80104e45:	83 c4 10             	add    $0x10,%esp
  // move proc from running to ready 
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
  proc->state = RUNNABLE;
  addToStateListTail(&ptable.pLists.ready[0], RUNNABLE, proc); // Modified for Project 4: Periodic Priority Adjustment
  #else
  proc->state = RUNNABLE;
80104e48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e4e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #endif

  sched();
80104e55:	e8 e6 fe ff ff       	call   80104d40 <sched>
  release(&ptable.lock);
80104e5a:	83 ec 0c             	sub    $0xc,%esp
80104e5d:	68 80 39 11 80       	push   $0x80113980
80104e62:	e8 40 0f 00 00       	call   80105da7 <release>
80104e67:	83 c4 10             	add    $0x10,%esp
}
80104e6a:	90                   	nop
80104e6b:	c9                   	leave  
80104e6c:	c3                   	ret    

80104e6d <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104e6d:	55                   	push   %ebp
80104e6e:	89 e5                	mov    %esp,%ebp
80104e70:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104e73:	83 ec 0c             	sub    $0xc,%esp
80104e76:	68 80 39 11 80       	push   $0x80113980
80104e7b:	e8 27 0f 00 00       	call   80105da7 <release>
80104e80:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104e83:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80104e88:	85 c0                	test   %eax,%eax
80104e8a:	74 24                	je     80104eb0 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104e8c:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80104e93:	00 00 00 
    iinit(ROOTDEV);
80104e96:	83 ec 0c             	sub    $0xc,%esp
80104e99:	6a 01                	push   $0x1
80104e9b:	e8 44 c8 ff ff       	call   801016e4 <iinit>
80104ea0:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104ea3:	83 ec 0c             	sub    $0xc,%esp
80104ea6:	6a 01                	push   $0x1
80104ea8:	e8 28 e5 ff ff       	call   801033d5 <initlog>
80104ead:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104eb0:	90                   	nop
80104eb1:	c9                   	leave  
80104eb2:	c3                   	ret    

80104eb3 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80104eb3:	55                   	push   %ebp
80104eb4:	89 e5                	mov    %esp,%ebp
80104eb6:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104eb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ebf:	85 c0                	test   %eax,%eax
80104ec1:	75 0d                	jne    80104ed0 <sleep+0x1d>
    panic("sleep");
80104ec3:	83 ec 0c             	sub    $0xc,%esp
80104ec6:	68 f4 97 10 80       	push   $0x801097f4
80104ecb:	e8 96 b6 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80104ed0:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104ed7:	74 24                	je     80104efd <sleep+0x4a>
    acquire(&ptable.lock);
80104ed9:	83 ec 0c             	sub    $0xc,%esp
80104edc:	68 80 39 11 80       	push   $0x80113980
80104ee1:	e8 5a 0e 00 00       	call   80105d40 <acquire>
80104ee6:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80104ee9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104eed:	74 0e                	je     80104efd <sleep+0x4a>
80104eef:	83 ec 0c             	sub    $0xc,%esp
80104ef2:	ff 75 0c             	pushl  0xc(%ebp)
80104ef5:	e8 ad 0e 00 00       	call   80105da7 <release>
80104efa:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104efd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f03:	8b 55 08             	mov    0x8(%ebp),%edx
80104f06:	89 50 20             	mov    %edx,0x20(%eax)
  // move proc from running to sleep list
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
  proc->state = SLEEPING;
  addToStateListHead(&ptable.pLists.sleep, SLEEPING, proc);
  #else
  proc->state = SLEEPING;
80104f09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f0f:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  #endif
  sched(); // TODO: sched???
80104f16:	e8 25 fe ff ff       	call   80104d40 <sched>
  // END: Added for Project 3: List Management

  // Tidy up.
  proc->chan = 0;
80104f1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f21:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
80104f28:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104f2f:	74 24                	je     80104f55 <sleep+0xa2>
    release(&ptable.lock);
80104f31:	83 ec 0c             	sub    $0xc,%esp
80104f34:	68 80 39 11 80       	push   $0x80113980
80104f39:	e8 69 0e 00 00       	call   80105da7 <release>
80104f3e:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
80104f41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104f45:	74 0e                	je     80104f55 <sleep+0xa2>
80104f47:	83 ec 0c             	sub    $0xc,%esp
80104f4a:	ff 75 0c             	pushl  0xc(%ebp)
80104f4d:	e8 ee 0d 00 00       	call   80105d40 <acquire>
80104f52:	83 c4 10             	add    $0x10,%esp
  }
}
80104f55:	90                   	nop
80104f56:	c9                   	leave  
80104f57:	c3                   	ret    

80104f58 <wakeup1>:
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104f58:	55                   	push   %ebp
80104f59:	89 e5                	mov    %esp,%ebp
80104f5b:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f5e:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104f65:	eb 27                	jmp    80104f8e <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104f67:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f6a:	8b 40 0c             	mov    0xc(%eax),%eax
80104f6d:	83 f8 02             	cmp    $0x2,%eax
80104f70:	75 15                	jne    80104f87 <wakeup1+0x2f>
80104f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f75:	8b 40 20             	mov    0x20(%eax),%eax
80104f78:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f7b:	75 0a                	jne    80104f87 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104f7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f80:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f87:	81 45 fc 9c 00 00 00 	addl   $0x9c,-0x4(%ebp)
80104f8e:	81 7d fc b4 60 11 80 	cmpl   $0x801160b4,-0x4(%ebp)
80104f95:	72 d0                	jb     80104f67 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104f97:	90                   	nop
80104f98:	c9                   	leave  
80104f99:	c3                   	ret    

80104f9a <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f9a:	55                   	push   %ebp
80104f9b:	89 e5                	mov    %esp,%ebp
80104f9d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104fa0:	83 ec 0c             	sub    $0xc,%esp
80104fa3:	68 80 39 11 80       	push   $0x80113980
80104fa8:	e8 93 0d 00 00       	call   80105d40 <acquire>
80104fad:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104fb0:	83 ec 0c             	sub    $0xc,%esp
80104fb3:	ff 75 08             	pushl  0x8(%ebp)
80104fb6:	e8 9d ff ff ff       	call   80104f58 <wakeup1>
80104fbb:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104fbe:	83 ec 0c             	sub    $0xc,%esp
80104fc1:	68 80 39 11 80       	push   $0x80113980
80104fc6:	e8 dc 0d 00 00       	call   80105da7 <release>
80104fcb:	83 c4 10             	add    $0x10,%esp
}
80104fce:	90                   	nop
80104fcf:	c9                   	leave  
80104fd0:	c3                   	ret    

80104fd1 <kill>:
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
80104fd1:	55                   	push   %ebp
80104fd2:	89 e5                	mov    %esp,%ebp
80104fd4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104fd7:	83 ec 0c             	sub    $0xc,%esp
80104fda:	68 80 39 11 80       	push   $0x80113980
80104fdf:	e8 5c 0d 00 00       	call   80105d40 <acquire>
80104fe4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fe7:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104fee:	eb 4a                	jmp    8010503a <kill+0x69>
    if(p->pid == pid){
80104ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff3:	8b 50 10             	mov    0x10(%eax),%edx
80104ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff9:	39 c2                	cmp    %eax,%edx
80104ffb:	75 36                	jne    80105033 <kill+0x62>
      p->killed = 1;
80104ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105000:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105007:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010500a:	8b 40 0c             	mov    0xc(%eax),%eax
8010500d:	83 f8 02             	cmp    $0x2,%eax
80105010:	75 0a                	jne    8010501c <kill+0x4b>
        p->state = RUNNABLE;
80105012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105015:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010501c:	83 ec 0c             	sub    $0xc,%esp
8010501f:	68 80 39 11 80       	push   $0x80113980
80105024:	e8 7e 0d 00 00       	call   80105da7 <release>
80105029:	83 c4 10             	add    $0x10,%esp
      return 0;
8010502c:	b8 00 00 00 00       	mov    $0x0,%eax
80105031:	eb 25                	jmp    80105058 <kill+0x87>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105033:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
8010503a:	81 7d f4 b4 60 11 80 	cmpl   $0x801160b4,-0xc(%ebp)
80105041:	72 ad                	jb     80104ff0 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105043:	83 ec 0c             	sub    $0xc,%esp
80105046:	68 80 39 11 80       	push   $0x80113980
8010504b:	e8 57 0d 00 00       	call   80105da7 <release>
80105050:	83 c4 10             	add    $0x10,%esp
  return -1;
80105053:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105058:	c9                   	leave  
80105059:	c3                   	ret    

8010505a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010505a:	55                   	push   %ebp
8010505b:	89 e5                	mov    %esp,%ebp
8010505d:	57                   	push   %edi
8010505e:	56                   	push   %esi
8010505f:	53                   	push   %ebx
80105060:	83 ec 6c             	sub    $0x6c,%esp
  char *state;
  uint pc[10];
  uint ppid;
 
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command
80105063:	83 ec 0c             	sub    $0xc,%esp
80105066:	68 24 98 10 80       	push   $0x80109824
8010506b:	e8 56 b3 ff ff       	call   801003c6 <cprintf>
80105070:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105073:	c7 45 e0 b4 39 11 80 	movl   $0x801139b4,-0x20(%ebp)
8010507a:	e9 0e 02 00 00       	jmp    8010528d <procdump+0x233>
    if(p->state == UNUSED)
8010507f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105082:	8b 40 0c             	mov    0xc(%eax),%eax
80105085:	85 c0                	test   %eax,%eax
80105087:	0f 84 f8 01 00 00    	je     80105285 <procdump+0x22b>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010508d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105090:	8b 40 0c             	mov    0xc(%eax),%eax
80105093:	83 f8 05             	cmp    $0x5,%eax
80105096:	77 23                	ja     801050bb <procdump+0x61>
80105098:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010509b:	8b 40 0c             	mov    0xc(%eax),%eax
8010509e:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801050a5:	85 c0                	test   %eax,%eax
801050a7:	74 12                	je     801050bb <procdump+0x61>
      state = states[p->state];
801050a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050ac:	8b 40 0c             	mov    0xc(%eax),%eax
801050af:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801050b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
801050b9:	eb 07                	jmp    801050c2 <procdump+0x68>
    else
      state = "???";
801050bb:	c7 45 dc 5d 98 10 80 	movl   $0x8010985d,-0x24(%ebp)
    // Print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size (with needed spacing)
    // Switched to tabs and mod in Project 2: Modifying the Console)
    // (I wish I used this method from the start.... :(  )
    
    // get ppid (and if it is init then its ppid is itself (1))
    if (p->pid == 1)
801050c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050c5:	8b 40 10             	mov    0x10(%eax),%eax
801050c8:	83 f8 01             	cmp    $0x1,%eax
801050cb:	75 09                	jne    801050d6 <procdump+0x7c>
      ppid = 1;
801050cd:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
801050d4:	eb 0c                	jmp    801050e2 <procdump+0x88>
    else
      ppid = p->parent->pid;
801050d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050d9:	8b 40 14             	mov    0x14(%eax),%eax
801050dc:	8b 40 10             	mov    0x10(%eax),%eax
801050df:	89 45 d8             	mov    %eax,-0x28(%ebp)

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801050e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050e5:	8b 38                	mov    (%eax),%edi
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
		p->cpu_ticks_total / 100,
		p->cpu_ticks_total % 100 / 10,
801050e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050ea:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
801050f0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801050f5:	89 c8                	mov    %ecx,%eax
801050f7:	f7 e2                	mul    %edx
801050f9:	89 d0                	mov    %edx,%eax
801050fb:	c1 e8 05             	shr    $0x5,%eax
801050fe:	6b c0 64             	imul   $0x64,%eax,%eax
80105101:	29 c1                	sub    %eax,%ecx
80105103:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
80105105:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010510a:	f7 e2                	mul    %edx
8010510c:	c1 ea 03             	shr    $0x3,%edx
8010510f:	89 55 a4             	mov    %edx,-0x5c(%ebp)
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
		p->cpu_ticks_total / 100,
80105112:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105115:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
8010511b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105120:	f7 e2                	mul    %edx
80105122:	89 d0                	mov    %edx,%eax
80105124:	c1 e8 05             	shr    $0x5,%eax
80105127:	89 45 a0             	mov    %eax,-0x60(%ebp)
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
8010512a:	8b 15 e0 68 11 80    	mov    0x801168e0,%edx
80105130:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105133:	8b 40 7c             	mov    0x7c(%eax),%eax
80105136:	89 d3                	mov    %edx,%ebx
80105138:	29 c3                	sub    %eax,%ebx
8010513a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010513f:	89 d8                	mov    %ebx,%eax
80105141:	f7 e2                	mul    %edx
80105143:	89 d1                	mov    %edx,%ecx
80105145:	c1 e9 05             	shr    $0x5,%ecx
80105148:	6b c1 64             	imul   $0x64,%ecx,%eax
8010514b:	29 c3                	sub    %eax,%ebx
8010514d:	89 d9                	mov    %ebx,%ecx
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
8010514f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105154:	89 c8                	mov    %ecx,%eax
80105156:	f7 e2                	mul    %edx
80105158:	89 d3                	mov    %edx,%ebx
8010515a:	c1 eb 03             	shr    $0x3,%ebx
8010515d:	89 d8                	mov    %ebx,%eax
8010515f:	c1 e0 02             	shl    $0x2,%eax
80105162:	01 d8                	add    %ebx,%eax
80105164:	01 c0                	add    %eax,%eax
80105166:	89 cb                	mov    %ecx,%ebx
80105168:	29 c3                	sub    %eax,%ebx
		p->uid,
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
8010516a:	8b 15 e0 68 11 80    	mov    0x801168e0,%edx
80105170:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105173:	8b 40 7c             	mov    0x7c(%eax),%eax
80105176:	89 d1                	mov    %edx,%ecx
80105178:	29 c1                	sub    %eax,%ecx
8010517a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010517f:	89 c8                	mov    %ecx,%eax
80105181:	f7 e2                	mul    %edx
80105183:	89 d0                	mov    %edx,%eax
80105185:	c1 e8 05             	shr    $0x5,%eax
80105188:	6b c0 64             	imul   $0x64,%eax,%eax
8010518b:	29 c1                	sub    %eax,%ecx
8010518d:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
8010518f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105194:	f7 e2                	mul    %edx
80105196:	89 d6                	mov    %edx,%esi
80105198:	c1 ee 03             	shr    $0x3,%esi
8010519b:	89 75 9c             	mov    %esi,-0x64(%ebp)
		p->name,
		p->uid,
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
8010519e:	8b 15 e0 68 11 80    	mov    0x801168e0,%edx
801051a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051a7:	8b 40 7c             	mov    0x7c(%eax),%eax
801051aa:	89 d1                	mov    %edx,%ecx
801051ac:	29 c1                	sub    %eax,%ecx
801051ae:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801051b0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801051b5:	f7 e2                	mul    %edx
801051b7:	89 d1                	mov    %edx,%ecx
801051b9:	c1 e9 05             	shr    $0x5,%ecx
801051bc:	89 4d 98             	mov    %ecx,-0x68(%ebp)
801051bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051c2:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801051c8:	89 45 94             	mov    %eax,-0x6c(%ebp)
801051cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051ce:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
801051d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051d7:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
		p->pid,
		p->name,
801051dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051e0:	8d 50 6c             	lea    0x6c(%eax),%edx
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801051e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051e6:	8b 40 10             	mov    0x10(%eax),%eax
801051e9:	83 ec 08             	sub    $0x8,%esp
801051ec:	57                   	push   %edi
801051ed:	ff 75 dc             	pushl  -0x24(%ebp)
801051f0:	ff 75 a4             	pushl  -0x5c(%ebp)
801051f3:	ff 75 a0             	pushl  -0x60(%ebp)
801051f6:	53                   	push   %ebx
801051f7:	ff 75 9c             	pushl  -0x64(%ebp)
801051fa:	ff 75 98             	pushl  -0x68(%ebp)
801051fd:	ff 75 94             	pushl  -0x6c(%ebp)
80105200:	ff 75 d8             	pushl  -0x28(%ebp)
80105203:	56                   	push   %esi
80105204:	51                   	push   %ecx
80105205:	52                   	push   %edx
80105206:	50                   	push   %eax
80105207:	68 64 98 10 80       	push   $0x80109864
8010520c:	e8 b5 b1 ff ff       	call   801003c6 <cprintf>
80105211:	83 c4 40             	add    $0x40,%esp
		p->sz);

    // END: Added for Project 1: CTL-P

    // Print PCs data
    if(p->state == SLEEPING){
80105214:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105217:	8b 40 0c             	mov    0xc(%eax),%eax
8010521a:	83 f8 02             	cmp    $0x2,%eax
8010521d:	75 54                	jne    80105273 <procdump+0x219>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010521f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105222:	8b 40 1c             	mov    0x1c(%eax),%eax
80105225:	8b 40 0c             	mov    0xc(%eax),%eax
80105228:	83 c0 08             	add    $0x8,%eax
8010522b:	89 c2                	mov    %eax,%edx
8010522d:	83 ec 08             	sub    $0x8,%esp
80105230:	8d 45 b0             	lea    -0x50(%ebp),%eax
80105233:	50                   	push   %eax
80105234:	52                   	push   %edx
80105235:	e8 bf 0b 00 00       	call   80105df9 <getcallerpcs>
8010523a:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010523d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105244:	eb 1c                	jmp    80105262 <procdump+0x208>
        cprintf(" %p", pc[i]);
80105246:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105249:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
8010524d:	83 ec 08             	sub    $0x8,%esp
80105250:	50                   	push   %eax
80105251:	68 8b 98 10 80       	push   $0x8010988b
80105256:	e8 6b b1 ff ff       	call   801003c6 <cprintf>
8010525b:	83 c4 10             	add    $0x10,%esp
    // END: Added for Project 1: CTL-P

    // Print PCs data
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010525e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105262:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
80105266:	7f 0b                	jg     80105273 <procdump+0x219>
80105268:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010526b:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
8010526f:	85 c0                	test   %eax,%eax
80105271:	75 d3                	jne    80105246 <procdump+0x1ec>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105273:	83 ec 0c             	sub    $0xc,%esp
80105276:	68 8f 98 10 80       	push   $0x8010988f
8010527b:	e8 46 b1 ff ff       	call   801003c6 <cprintf>
80105280:	83 c4 10             	add    $0x10,%esp
80105283:	eb 01                	jmp    80105286 <procdump+0x22c>
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105285:	90                   	nop
  uint ppid;
 
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105286:	81 45 e0 9c 00 00 00 	addl   $0x9c,-0x20(%ebp)
8010528d:	81 7d e0 b4 60 11 80 	cmpl   $0x801160b4,-0x20(%ebp)
80105294:	0f 82 e5 fd ff ff    	jb     8010507f <procdump+0x25>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
8010529a:	90                   	nop
8010529b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010529e:	5b                   	pop    %ebx
8010529f:	5e                   	pop    %esi
801052a0:	5f                   	pop    %edi
801052a1:	5d                   	pop    %ebp
801052a2:	c3                   	ret    

801052a3 <readydump>:

// START: Added for Project 3: New Console Control Sequences
void
readydump(void) // Modified for Project 4: ctrl-r Console Command
{
801052a3:	55                   	push   %ebp
801052a4:	89 e5                	mov    %esp,%ebp
801052a6:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	68 80 39 11 80       	push   $0x80113980
801052b1:	e8 8a 0a 00 00       	call   80105d40 <acquire>
801052b6:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = 0;
801052b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  cprintf("Ready List Processes:\n"); 
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	68 91 98 10 80       	push   $0x80109891
801052c8:	e8 f9 b0 ff ff       	call   801003c6 <cprintf>
801052cd:	83 c4 10             	add    $0x10,%esp

  for(int i = 0; i < MAX + 1; ++i){
801052d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801052d7:	e9 a4 00 00 00       	jmp    80105380 <readydump+0xdd>
    currPtr = ptable.pLists.ready[i];
801052dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052df:	05 cc 09 00 00       	add    $0x9cc,%eax
801052e4:	8b 04 85 84 39 11 80 	mov    -0x7feec67c(,%eax,4),%eax
801052eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%d: ", i); // print list number
801052ee:	83 ec 08             	sub    $0x8,%esp
801052f1:	ff 75 f0             	pushl  -0x10(%ebp)
801052f4:	68 a8 98 10 80       	push   $0x801098a8
801052f9:	e8 c8 b0 ff ff       	call   801003c6 <cprintf>
801052fe:	83 c4 10             	add    $0x10,%esp
    
    if (currPtr == 0)
80105301:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105305:	75 6f                	jne    80105376 <readydump+0xd3>
      cprintf("Empty!\n");
80105307:	83 ec 0c             	sub    $0xc,%esp
8010530a:	68 ad 98 10 80       	push   $0x801098ad
8010530f:	e8 b2 b0 ff ff       	call   801003c6 <cprintf>
80105314:	83 c4 10             	add    $0x10,%esp

    while (currPtr != 0){
80105317:	eb 5d                	jmp    80105376 <readydump+0xd3>
      if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
80105319:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010531c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105322:	85 c0                	test   %eax,%eax
80105324:	75 23                	jne    80105349 <readydump+0xa6>
        cprintf("(%d, %d)\n", currPtr->pid, currPtr->budget);
80105326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105329:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010532f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105332:	8b 40 10             	mov    0x10(%eax),%eax
80105335:	83 ec 04             	sub    $0x4,%esp
80105338:	52                   	push   %edx
80105339:	50                   	push   %eax
8010533a:	68 b5 98 10 80       	push   $0x801098b5
8010533f:	e8 82 b0 ff ff       	call   801003c6 <cprintf>
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	eb 21                	jmp    8010536a <readydump+0xc7>
      else
        cprintf("(%d, %d) -> ", currPtr->pid, currPtr->budget);
80105349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010534c:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105355:	8b 40 10             	mov    0x10(%eax),%eax
80105358:	83 ec 04             	sub    $0x4,%esp
8010535b:	52                   	push   %edx
8010535c:	50                   	push   %eax
8010535d:	68 bf 98 10 80       	push   $0x801098bf
80105362:	e8 5f b0 ff ff       	call   801003c6 <cprintf>
80105367:	83 c4 10             	add    $0x10,%esp

      currPtr = currPtr->next;
8010536a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010536d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105373:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%d: ", i); // print list number
    
    if (currPtr == 0)
      cprintf("Empty!\n");

    while (currPtr != 0){
80105376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010537a:	75 9d                	jne    80105319 <readydump+0x76>

  struct proc *currPtr = 0;

  cprintf("Ready List Processes:\n"); 

  for(int i = 0; i < MAX + 1; ++i){
8010537c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105384:	0f 8e 52 ff ff ff    	jle    801052dc <readydump+0x39>

      currPtr = currPtr->next;
    }
  }

  release(&ptable.lock);
8010538a:	83 ec 0c             	sub    $0xc,%esp
8010538d:	68 80 39 11 80       	push   $0x80113980
80105392:	e8 10 0a 00 00       	call   80105da7 <release>
80105397:	83 c4 10             	add    $0x10,%esp
}
8010539a:	90                   	nop
8010539b:	c9                   	leave  
8010539c:	c3                   	ret    

8010539d <freedump>:

void
freedump(void)
{
8010539d:	55                   	push   %ebp
8010539e:	89 e5                	mov    %esp,%ebp
801053a0:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801053a3:	83 ec 0c             	sub    $0xc,%esp
801053a6:	68 80 39 11 80       	push   $0x80113980
801053ab:	e8 90 09 00 00       	call   80105d40 <acquire>
801053b0:	83 c4 10             	add    $0x10,%esp
  
  struct proc *currPtr = ptable.pLists.free;
801053b3:	a1 b8 60 11 80       	mov    0x801160b8,%eax
801053b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint numProcs = 0;
801053bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  while (currPtr != 0){
801053c2:	eb 10                	jmp    801053d4 <freedump+0x37>
    ++numProcs;
801053c4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    currPtr = currPtr->next;
801053c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053cb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801053d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&ptable.lock);
  
  struct proc *currPtr = ptable.pLists.free;
  uint numProcs = 0;

  while (currPtr != 0){
801053d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053d8:	75 ea                	jne    801053c4 <freedump+0x27>
    ++numProcs;
    currPtr = currPtr->next;
  }

  cprintf("Free List Size: %d processes\n", numProcs);
801053da:	83 ec 08             	sub    $0x8,%esp
801053dd:	ff 75 f0             	pushl  -0x10(%ebp)
801053e0:	68 cc 98 10 80       	push   $0x801098cc
801053e5:	e8 dc af ff ff       	call   801003c6 <cprintf>
801053ea:	83 c4 10             	add    $0x10,%esp

  release(&ptable.lock);
801053ed:	83 ec 0c             	sub    $0xc,%esp
801053f0:	68 80 39 11 80       	push   $0x80113980
801053f5:	e8 ad 09 00 00       	call   80105da7 <release>
801053fa:	83 c4 10             	add    $0x10,%esp
}
801053fd:	90                   	nop
801053fe:	c9                   	leave  
801053ff:	c3                   	ret    

80105400 <sleepdump>:

void
sleepdump(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105406:	83 ec 0c             	sub    $0xc,%esp
80105409:	68 80 39 11 80       	push   $0x80113980
8010540e:	e8 2d 09 00 00       	call   80105d40 <acquire>
80105413:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = ptable.pLists.sleep;
80105416:	a1 bc 60 11 80       	mov    0x801160bc,%eax
8010541b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  cprintf("Sleep List Processes:\n"); 
8010541e:	83 ec 0c             	sub    $0xc,%esp
80105421:	68 ea 98 10 80       	push   $0x801098ea
80105426:	e8 9b af ff ff       	call   801003c6 <cprintf>
8010542b:	83 c4 10             	add    $0x10,%esp
  
  if (currPtr == 0)
8010542e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105432:	75 5b                	jne    8010548f <sleepdump+0x8f>
    cprintf("Empty!\n");
80105434:	83 ec 0c             	sub    $0xc,%esp
80105437:	68 ad 98 10 80       	push   $0x801098ad
8010543c:	e8 85 af ff ff       	call   801003c6 <cprintf>
80105441:	83 c4 10             	add    $0x10,%esp

  while (currPtr != 0){
80105444:	eb 49                	jmp    8010548f <sleepdump+0x8f>
    if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
80105446:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105449:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010544f:	85 c0                	test   %eax,%eax
80105451:	75 19                	jne    8010546c <sleepdump+0x6c>
      cprintf("%d\n", currPtr->pid);
80105453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105456:	8b 40 10             	mov    0x10(%eax),%eax
80105459:	83 ec 08             	sub    $0x8,%esp
8010545c:	50                   	push   %eax
8010545d:	68 01 99 10 80       	push   $0x80109901
80105462:	e8 5f af ff ff       	call   801003c6 <cprintf>
80105467:	83 c4 10             	add    $0x10,%esp
8010546a:	eb 17                	jmp    80105483 <sleepdump+0x83>
    else
      cprintf("%d -> ", currPtr->pid);
8010546c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010546f:	8b 40 10             	mov    0x10(%eax),%eax
80105472:	83 ec 08             	sub    $0x8,%esp
80105475:	50                   	push   %eax
80105476:	68 05 99 10 80       	push   $0x80109905
8010547b:	e8 46 af ff ff       	call   801003c6 <cprintf>
80105480:	83 c4 10             	add    $0x10,%esp

    currPtr = currPtr->next;
80105483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105486:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010548c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cprintf("Sleep List Processes:\n"); 
  
  if (currPtr == 0)
    cprintf("Empty!\n");

  while (currPtr != 0){
8010548f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105493:	75 b1                	jne    80105446 <sleepdump+0x46>
      cprintf("%d -> ", currPtr->pid);

    currPtr = currPtr->next;
  }

  release(&ptable.lock);
80105495:	83 ec 0c             	sub    $0xc,%esp
80105498:	68 80 39 11 80       	push   $0x80113980
8010549d:	e8 05 09 00 00       	call   80105da7 <release>
801054a2:	83 c4 10             	add    $0x10,%esp
}
801054a5:	90                   	nop
801054a6:	c9                   	leave  
801054a7:	c3                   	ret    

801054a8 <zombiedump>:

void
zombiedump(void)
{
801054a8:	55                   	push   %ebp
801054a9:	89 e5                	mov    %esp,%ebp
801054ab:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801054ae:	83 ec 0c             	sub    $0xc,%esp
801054b1:	68 80 39 11 80       	push   $0x80113980
801054b6:	e8 85 08 00 00       	call   80105d40 <acquire>
801054bb:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = ptable.pLists.zombie;
801054be:	a1 c0 60 11 80       	mov    0x801160c0,%eax
801054c3:	89 45 f4             	mov    %eax,-0xc(%ebp)

  cprintf("Zombie List Processes:\n"); 
801054c6:	83 ec 0c             	sub    $0xc,%esp
801054c9:	68 0c 99 10 80       	push   $0x8010990c
801054ce:	e8 f3 ae ff ff       	call   801003c6 <cprintf>
801054d3:	83 c4 10             	add    $0x10,%esp

  if (currPtr == 0)
801054d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054da:	75 6f                	jne    8010554b <zombiedump+0xa3>
    cprintf("Empty!\n");
801054dc:	83 ec 0c             	sub    $0xc,%esp
801054df:	68 ad 98 10 80       	push   $0x801098ad
801054e4:	e8 dd ae ff ff       	call   801003c6 <cprintf>
801054e9:	83 c4 10             	add    $0x10,%esp

  while (currPtr != 0){
801054ec:	eb 5d                	jmp    8010554b <zombiedump+0xa3>
    if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
801054ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801054f7:	85 c0                	test   %eax,%eax
801054f9:	75 23                	jne    8010551e <zombiedump+0x76>
        cprintf("(%d, %d)\n", currPtr->pid, currPtr->parent->pid);
801054fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054fe:	8b 40 14             	mov    0x14(%eax),%eax
80105501:	8b 50 10             	mov    0x10(%eax),%edx
80105504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105507:	8b 40 10             	mov    0x10(%eax),%eax
8010550a:	83 ec 04             	sub    $0x4,%esp
8010550d:	52                   	push   %edx
8010550e:	50                   	push   %eax
8010550f:	68 b5 98 10 80       	push   $0x801098b5
80105514:	e8 ad ae ff ff       	call   801003c6 <cprintf>
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	eb 21                	jmp    8010553f <zombiedump+0x97>
    else
      cprintf("(%d, %d) -> ", currPtr->pid, currPtr->parent->pid);
8010551e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105521:	8b 40 14             	mov    0x14(%eax),%eax
80105524:	8b 50 10             	mov    0x10(%eax),%edx
80105527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010552a:	8b 40 10             	mov    0x10(%eax),%eax
8010552d:	83 ec 04             	sub    $0x4,%esp
80105530:	52                   	push   %edx
80105531:	50                   	push   %eax
80105532:	68 bf 98 10 80       	push   $0x801098bf
80105537:	e8 8a ae ff ff       	call   801003c6 <cprintf>
8010553c:	83 c4 10             	add    $0x10,%esp
    
    currPtr = currPtr->next;
8010553f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105542:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105548:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cprintf("Zombie List Processes:\n"); 

  if (currPtr == 0)
    cprintf("Empty!\n");

  while (currPtr != 0){
8010554b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010554f:	75 9d                	jne    801054ee <zombiedump+0x46>
      cprintf("(%d, %d) -> ", currPtr->pid, currPtr->parent->pid);
    
    currPtr = currPtr->next;
  }

  release(&ptable.lock);
80105551:	83 ec 0c             	sub    $0xc,%esp
80105554:	68 80 39 11 80       	push   $0x80113980
80105559:	e8 49 08 00 00       	call   80105da7 <release>
8010555e:	83 c4 10             	add    $0x10,%esp
}
80105561:	90                   	nop
80105562:	c9                   	leave  
80105563:	c3                   	ret    

80105564 <getuprocs>:
// END: Added for Project 3: New Console Control Sequences

// get array of uproc structs
int
getuprocs(uint max, struct uproc *table) // Added for Project 2: The "ps" Command
{
80105564:	55                   	push   %ebp
80105565:	89 e5                	mov    %esp,%ebp
80105567:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  uint numProcs = 0; // number of procs in struct array
8010556a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  acquire(&ptable.lock); // get lock so we get a snapshot
80105571:	83 ec 0c             	sub    $0xc,%esp
80105574:	68 80 39 11 80       	push   $0x80113980
80105579:	e8 c2 07 00 00       	call   80105d40 <acquire>
8010557e:	83 c4 10             	add    $0x10,%esp

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
80105581:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80105588:	e9 08 01 00 00       	jmp    80105695 <getuprocs+0x131>
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
8010558d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105590:	8b 40 0c             	mov    0xc(%eax),%eax
80105593:	83 f8 03             	cmp    $0x3,%eax
80105596:	74 25                	je     801055bd <getuprocs+0x59>
        p->state == SLEEPING || 
80105598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010559b:	8b 40 0c             	mov    0xc(%eax),%eax

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
8010559e:	83 f8 02             	cmp    $0x2,%eax
801055a1:	74 1a                	je     801055bd <getuprocs+0x59>
        p->state == SLEEPING || 
        p->state == RUNNING  || 
801055a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a6:	8b 40 0c             	mov    0xc(%eax),%eax
  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
        p->state == SLEEPING || 
801055a9:	83 f8 04             	cmp    $0x4,%eax
801055ac:	74 0f                	je     801055bd <getuprocs+0x59>
        p->state == RUNNING  || 
        p->state == ZOMBIE)
801055ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b1:	8b 40 0c             	mov    0xc(%eax),%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
        p->state == SLEEPING || 
        p->state == RUNNING  || 
801055b4:	83 f8 05             	cmp    $0x5,%eax
801055b7:	0f 85 d1 00 00 00    	jne    8010568e <getuprocs+0x12a>
        p->state == ZOMBIE)
    {

      // populate uproc struct entry in table
      table->pid  = p->pid;
801055bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c0:	8b 50 10             	mov    0x10(%eax),%edx
801055c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801055c6:	89 10                	mov    %edx,(%eax)
      table->uid  = p->uid;
801055c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055cb:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801055d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801055d4:	89 50 04             	mov    %edx,0x4(%eax)
      table->gid  = p->gid;
801055d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055da:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
801055e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801055e3:	89 50 08             	mov    %edx,0x8(%eax)

      if (p->pid == 1) // if p is init, then set ppid to itself (1)
801055e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e9:	8b 40 10             	mov    0x10(%eax),%eax
801055ec:	83 f8 01             	cmp    $0x1,%eax
801055ef:	75 0c                	jne    801055fd <getuprocs+0x99>
        table->ppid = 1;
801055f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801055f4:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
801055fb:	eb 0f                	jmp    8010560c <getuprocs+0xa8>
      else
        table->ppid = p->parent->pid;
801055fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105600:	8b 40 14             	mov    0x14(%eax),%eax
80105603:	8b 50 10             	mov    0x10(%eax),%edx
80105606:	8b 45 0c             	mov    0xc(%ebp),%eax
80105609:	89 50 0c             	mov    %edx,0xc(%eax)

      table->priority = p->priority;
8010560c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010560f:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105615:	8b 45 0c             	mov    0xc(%ebp),%eax
80105618:	89 50 10             	mov    %edx,0x10(%eax)
      table->elapsed_ticks = ticks - p->start_ticks;
8010561b:	8b 15 e0 68 11 80    	mov    0x801168e0,%edx
80105621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105624:	8b 40 7c             	mov    0x7c(%eax),%eax
80105627:	29 c2                	sub    %eax,%edx
80105629:	8b 45 0c             	mov    0xc(%ebp),%eax
8010562c:	89 50 14             	mov    %edx,0x14(%eax)
      table->CPU_total_ticks = p->cpu_ticks_total;
8010562f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105632:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80105638:	8b 45 0c             	mov    0xc(%ebp),%eax
8010563b:	89 50 18             	mov    %edx,0x18(%eax)
      safestrcpy(table->state, states[p->state], NELEM(table->state));
8010563e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105641:	8b 40 0c             	mov    0xc(%eax),%eax
80105644:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
8010564b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010564e:	83 c2 1c             	add    $0x1c,%edx
80105651:	83 ec 04             	sub    $0x4,%esp
80105654:	6a 20                	push   $0x20
80105656:	50                   	push   %eax
80105657:	52                   	push   %edx
80105658:	e8 49 0b 00 00       	call   801061a6 <safestrcpy>
8010565d:	83 c4 10             	add    $0x10,%esp
      table->size = p->sz;
80105660:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105663:	8b 10                	mov    (%eax),%edx
80105665:	8b 45 0c             	mov    0xc(%ebp),%eax
80105668:	89 50 3c             	mov    %edx,0x3c(%eax)
      safestrcpy(table->name, p->name, NELEM(table->name));
8010566b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010566e:	8d 50 6c             	lea    0x6c(%eax),%edx
80105671:	8b 45 0c             	mov    0xc(%ebp),%eax
80105674:	83 c0 40             	add    $0x40,%eax
80105677:	83 ec 04             	sub    $0x4,%esp
8010567a:	6a 20                	push   $0x20
8010567c:	52                   	push   %edx
8010567d:	50                   	push   %eax
8010567e:	e8 23 0b 00 00       	call   801061a6 <safestrcpy>
80105683:	83 c4 10             	add    $0x10,%esp

      ++table; // go to next entry
80105686:	83 45 0c 60          	addl   $0x60,0xc(%ebp)
      ++numProcs; // inc number of procs in struct array
8010568a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  uint numProcs = 0; // number of procs in struct array

  acquire(&ptable.lock); // get lock so we get a snapshot

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
8010568e:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80105695:	81 7d f4 b4 60 11 80 	cmpl   $0x801160b4,-0xc(%ebp)
8010569c:	73 0c                	jae    801056aa <getuprocs+0x146>
8010569e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a1:	3b 45 08             	cmp    0x8(%ebp),%eax
801056a4:	0f 82 e3 fe ff ff    	jb     8010558d <getuprocs+0x29>
      ++table; // go to next entry
      ++numProcs; // inc number of procs in struct array
    }
  }

  release(&ptable.lock); // return lock
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	68 80 39 11 80       	push   $0x80113980
801056b2:	e8 f0 06 00 00       	call   80105da7 <release>
801056b7:	83 c4 10             	add    $0x10,%esp

  return numProcs;
801056ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801056bd:	c9                   	leave  
801056be:	c3                   	ret    

801056bf <removeFromStateList>:

// Removes a proc "p" from a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
removeFromStateList(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
801056bf:	55                   	push   %ebp
801056c0:	89 e5                	mov    %esp,%ebp
801056c2:	83 ec 08             	sub    $0x8,%esp
   
  // check if passed in proc is in the specified state
  if (p->state != state) {
801056c5:	8b 45 10             	mov    0x10(%ebp),%eax
801056c8:	8b 40 0c             	mov    0xc(%eax),%eax
801056cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801056ce:	74 34                	je     80105704 <removeFromStateList+0x45>
    panic("The passed in proc to remove had the wrong state.");
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	68 24 99 10 80       	push   $0x80109924
801056d8:	e8 89 ae ff ff       	call   80100566 <panic>

  // search through list to find proc to remove
  while((*sList) != 0) {
  
    // if matching proc is found then remove it and return
    if ((*sList) == p) {
801056dd:	8b 45 08             	mov    0x8(%ebp),%eax
801056e0:	8b 00                	mov    (%eax),%eax
801056e2:	3b 45 10             	cmp    0x10(%ebp),%eax
801056e5:	75 10                	jne    801056f7 <removeFromStateList+0x38>
      (*sList) = p->next; // remove proc by "skipping" over it     
801056e7:	8b 45 10             	mov    0x10(%ebp),%eax
801056ea:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801056f0:	8b 45 08             	mov    0x8(%ebp),%eax
801056f3:	89 10                	mov    %edx,(%eax)
      return;
801056f5:	eb 4b                	jmp    80105742 <removeFromStateList+0x83>
    }

    // else, keep searching 
    sList = &(*sList)->next;
801056f7:	8b 45 08             	mov    0x8(%ebp),%eax
801056fa:	8b 00                	mov    (%eax),%eax
801056fc:	05 90 00 00 00       	add    $0x90,%eax
80105701:	89 45 08             	mov    %eax,0x8(%ebp)
  if (p->state != state) {
    panic("The passed in proc to remove had the wrong state.");
  }

  // search through list to find proc to remove
  while((*sList) != 0) {
80105704:	8b 45 08             	mov    0x8(%ebp),%eax
80105707:	8b 00                	mov    (%eax),%eax
80105709:	85 c0                	test   %eax,%eax
8010570b:	75 d0                	jne    801056dd <removeFromStateList+0x1e>

    // else, keep searching 
    sList = &(*sList)->next;
  }

  cprintf("removeFromStateList: p->priority is %d p->pid is %d p->ppid is %d\n", p->priority, p->pid, p->parent->pid);
8010570d:	8b 45 10             	mov    0x10(%ebp),%eax
80105710:	8b 40 14             	mov    0x14(%eax),%eax
80105713:	8b 48 10             	mov    0x10(%eax),%ecx
80105716:	8b 45 10             	mov    0x10(%ebp),%eax
80105719:	8b 50 10             	mov    0x10(%eax),%edx
8010571c:	8b 45 10             	mov    0x10(%ebp),%eax
8010571f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105725:	51                   	push   %ecx
80105726:	52                   	push   %edx
80105727:	50                   	push   %eax
80105728:	68 58 99 10 80       	push   $0x80109958
8010572d:	e8 94 ac ff ff       	call   801003c6 <cprintf>
80105732:	83 c4 10             	add    $0x10,%esp
  // if it wasn't found then panic and return error
  panic("The passed in proc to remove was not found.");
80105735:	83 ec 0c             	sub    $0xc,%esp
80105738:	68 9c 99 10 80       	push   $0x8010999c
8010573d:	e8 24 ae ff ff       	call   80100566 <panic>
  
}
80105742:	c9                   	leave  
80105743:	c3                   	ret    

80105744 <getFromStateListHead>:
// This is O(1) and is used to get procs from lists which are equivalent (e.g. free)
// If there the specified list is empty then panic
// Also, if the proc that is gotten has the wrong state then panic
struct proc*
getFromStateListHead(struct proc **sList, enum procstate state) // Added for Project 3: List Management
{
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	83 ec 18             	sub    $0x18,%esp
  struct proc* head = (*sList);
8010574a:	8b 45 08             	mov    0x8(%ebp),%eax
8010574d:	8b 00                	mov    (%eax),%eax
8010574f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // if head exists then return gotten head proc (if correct state) and remove from sList
  if (head != 0) {
80105752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105756:	74 2d                	je     80105785 <getFromStateListHead+0x41>
    if (head->state != state)
80105758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575b:	8b 40 0c             	mov    0xc(%eax),%eax
8010575e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105761:	74 0d                	je     80105770 <getFromStateListHead+0x2c>
      panic("The gotten head proc had the wrong state.");
80105763:	83 ec 0c             	sub    $0xc,%esp
80105766:	68 c8 99 10 80       	push   $0x801099c8
8010576b:	e8 f6 ad ff ff       	call   80100566 <panic>
    else {
      (*sList) = (*sList)->next; // remove gotten head proc by skipping over it
80105770:	8b 45 08             	mov    0x8(%ebp),%eax
80105773:	8b 00                	mov    (%eax),%eax
80105775:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
8010577b:	8b 45 08             	mov    0x8(%ebp),%eax
8010577e:	89 10                	mov    %edx,(%eax)
      return head;
80105780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105783:	eb 05                	jmp    8010578a <getFromStateListHead+0x46>
    }
    
  }

  return 0; // if head doesn't exist then null is returned
80105785:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    

8010578c <addToStateListHead>:

// Adds a proc "p" to the head of a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
addToStateListHead(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
8010578c:	55                   	push   %ebp
8010578d:	89 e5                	mov    %esp,%ebp
8010578f:	83 ec 08             	sub    $0x8,%esp
  // check if proc that is being added is correct state
  if (p->state != state) {
80105792:	8b 45 10             	mov    0x10(%ebp),%eax
80105795:	8b 40 0c             	mov    0xc(%eax),%eax
80105798:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010579b:	74 0d                	je     801057aa <addToStateListHead+0x1e>
    panic("The passed in proc to add to head had the wrong state.");
8010579d:	83 ec 0c             	sub    $0xc,%esp
801057a0:	68 f4 99 10 80       	push   $0x801099f4
801057a5:	e8 bc ad ff ff       	call   80100566 <panic>
  }

  // add proc to head
  p->next = (*sList); // note that if the sList is empty then the next will be set to null (as expected)
801057aa:	8b 45 08             	mov    0x8(%ebp),%eax
801057ad:	8b 10                	mov    (%eax),%edx
801057af:	8b 45 10             	mov    0x10(%ebp),%eax
801057b2:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  (*sList) = p;
801057b8:	8b 45 08             	mov    0x8(%ebp),%eax
801057bb:	8b 55 10             	mov    0x10(%ebp),%edx
801057be:	89 10                	mov    %edx,(%eax)

}
801057c0:	90                   	nop
801057c1:	c9                   	leave  
801057c2:	c3                   	ret    

801057c3 <addToStateListTail>:

// Adds a proc "p" to the tail of a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
addToStateListTail(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
801057c3:	55                   	push   %ebp
801057c4:	89 e5                	mov    %esp,%ebp
801057c6:	83 ec 08             	sub    $0x8,%esp
  // check if proc that is being added is correct state
  if (p->state != state) {
801057c9:	8b 45 10             	mov    0x10(%ebp),%eax
801057cc:	8b 40 0c             	mov    0xc(%eax),%eax
801057cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
801057d2:	74 0d                	je     801057e1 <addToStateListTail+0x1e>
    panic("The passed in proc to add to tail had the wrong state.");
801057d4:	83 ec 0c             	sub    $0xc,%esp
801057d7:	68 2c 9a 10 80       	push   $0x80109a2c
801057dc:	e8 85 ad ff ff       	call   80100566 <panic>
  }
  
  // if list being added to is empty, then just add to head
  if ((*sList) == 0) {
801057e1:	8b 45 08             	mov    0x8(%ebp),%eax
801057e4:	8b 00                	mov    (%eax),%eax
801057e6:	85 c0                	test   %eax,%eax
801057e8:	75 50                	jne    8010583a <addToStateListTail+0x77>
    (*sList) = p;
801057ea:	8b 45 08             	mov    0x8(%ebp),%eax
801057ed:	8b 55 10             	mov    0x10(%ebp),%edx
801057f0:	89 10                	mov    %edx,(%eax)
    p->next = 0; 
801057f2:	8b 45 10             	mov    0x10(%ebp),%eax
801057f5:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801057fc:	00 00 00 
801057ff:	eb 42                	jmp    80105843 <addToStateListTail+0x80>
  // otherwise, find the tail and add proc
  } else {
    while ((*sList) != 0) {
      
      // if tail is found then add proc and return
      if ((*sList)->next == 0) {
80105801:	8b 45 08             	mov    0x8(%ebp),%eax
80105804:	8b 00                	mov    (%eax),%eax
80105806:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010580c:	85 c0                	test   %eax,%eax
8010580e:	75 1d                	jne    8010582d <addToStateListTail+0x6a>
        (*sList)->next = p;
80105810:	8b 45 08             	mov    0x8(%ebp),%eax
80105813:	8b 00                	mov    (%eax),%eax
80105815:	8b 55 10             	mov    0x10(%ebp),%edx
80105818:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        p->next = 0;
8010581e:	8b 45 10             	mov    0x10(%ebp),%eax
80105821:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105828:	00 00 00 
        return;
8010582b:	eb 16                	jmp    80105843 <addToStateListTail+0x80>
      }

      // otherwise, keep looping
      sList = &(*sList)->next; 
8010582d:	8b 45 08             	mov    0x8(%ebp),%eax
80105830:	8b 00                	mov    (%eax),%eax
80105832:	05 90 00 00 00       	add    $0x90,%eax
80105837:	89 45 08             	mov    %eax,0x8(%ebp)
    (*sList) = p;
    p->next = 0; 

  // otherwise, find the tail and add proc
  } else {
    while ((*sList) != 0) {
8010583a:	8b 45 08             	mov    0x8(%ebp),%eax
8010583d:	8b 00                	mov    (%eax),%eax
8010583f:	85 c0                	test   %eax,%eax
80105841:	75 be                	jne    80105801 <addToStateListTail+0x3e>
      // otherwise, keep looping
      sList = &(*sList)->next; 
    }
  }

}
80105843:	c9                   	leave  
80105844:	c3                   	ret    

80105845 <tackToStateListTail>:
// Tacks a proc p (and all of its "next" children) onto the tail of sList. 
// This function is only used when moving a list of procs between ready list priority queues.
// Also, the procs moved will have their priority decremented and their budget reset
void
tackToStateListTail(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 4: Periodic Priority Adjustment (helper)
{
80105845:	55                   	push   %ebp
80105846:	89 e5                	mov    %esp,%ebp
80105848:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0;
8010584b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  // if p is null, then just return
  if (p == 0)
80105852:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105856:	0f 84 de 00 00 00    	je     8010593a <tackToStateListTail+0xf5>
    return;
  
  // check if proc that is being moved is correct state
  if (p->state != state)
8010585c:	8b 45 10             	mov    0x10(%ebp),%eax
8010585f:	8b 40 0c             	mov    0xc(%eax),%eax
80105862:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105865:	74 0d                	je     80105874 <tackToStateListTail+0x2f>
    panic("The passed in proc to tack to tail had the wrong state.");
80105867:	83 ec 0c             	sub    $0xc,%esp
8010586a:	68 64 9a 10 80       	push   $0x80109a64
8010586f:	e8 f2 ac ff ff       	call   80100566 <panic>

  // if list being tacked to is empty, then just add to head
  if ((*sList) == 0){
80105874:	8b 45 08             	mov    0x8(%ebp),%eax
80105877:	8b 00                	mov    (%eax),%eax
80105879:	85 c0                	test   %eax,%eax
8010587b:	0f 85 ae 00 00 00    	jne    8010592f <tackToStateListTail+0xea>
    (*sList) = p; // note that p's tail is not set to null since it is assumed its tail and its "next" children are set accordingly
80105881:	8b 45 08             	mov    0x8(%ebp),%eax
80105884:	8b 55 10             	mov    0x10(%ebp),%edx
80105887:	89 10                	mov    %edx,(%eax)

    
    currPtr = p;
80105889:	8b 45 10             	mov    0x10(%ebp),%eax
8010588c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(currPtr != 0){
8010588f:	eb 2e                	jmp    801058bf <tackToStateListTail+0x7a>
      currPtr->priority--;
80105891:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105894:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010589a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010589d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a0:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
801058a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a9:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
801058b0:	01 00 00 

      currPtr = currPtr->next;
801058b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801058bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((*sList) == 0){
    (*sList) = p; // note that p's tail is not set to null since it is assumed its tail and its "next" children are set accordingly

    
    currPtr = p;
    while(currPtr != 0){
801058bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058c3:	75 cc                	jne    80105891 <tackToStateListTail+0x4c>
801058c5:	eb 74                	jmp    8010593b <tackToStateListTail+0xf6>
  // otherwise, find the tail and tack on p
  } else {
    while ((*sList) != 0) {
      
      // if tail is found then tack on p and return
      if ((*sList)->next == 0){
801058c7:	8b 45 08             	mov    0x8(%ebp),%eax
801058ca:	8b 00                	mov    (%eax),%eax
801058cc:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801058d2:	85 c0                	test   %eax,%eax
801058d4:	75 4c                	jne    80105922 <tackToStateListTail+0xdd>
        (*sList)->next = p; // note that next is not set to null since it is assumed its tail and its "next" children are set accordingly
801058d6:	8b 45 08             	mov    0x8(%ebp),%eax
801058d9:	8b 00                	mov    (%eax),%eax
801058db:	8b 55 10             	mov    0x10(%ebp),%edx
801058de:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
         
        currPtr = p;
801058e4:	8b 45 10             	mov    0x10(%ebp),%eax
801058e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(currPtr != 0){
801058ea:	eb 2e                	jmp    8010591a <tackToStateListTail+0xd5>
          currPtr->priority--;
801058ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ef:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801058f5:	8d 50 ff             	lea    -0x1(%eax),%edx
801058f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058fb:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
          currPtr->budget = DEFAULT_BUDGET;
80105901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105904:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
8010590b:	01 00 00 

          currPtr = currPtr->next;
8010590e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105911:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105917:	89 45 f4             	mov    %eax,-0xc(%ebp)
      // if tail is found then tack on p and return
      if ((*sList)->next == 0){
        (*sList)->next = p; // note that next is not set to null since it is assumed its tail and its "next" children are set accordingly
         
        currPtr = p;
        while(currPtr != 0){
8010591a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010591e:	75 cc                	jne    801058ec <tackToStateListTail+0xa7>
          currPtr->budget = DEFAULT_BUDGET;

          currPtr = currPtr->next;
        }
        
        return;
80105920:	eb 19                	jmp    8010593b <tackToStateListTail+0xf6>
      }
      
      // otherwise, keep looping
      sList = &(*sList)->next;
80105922:	8b 45 08             	mov    0x8(%ebp),%eax
80105925:	8b 00                	mov    (%eax),%eax
80105927:	05 90 00 00 00       	add    $0x90,%eax
8010592c:	89 45 08             	mov    %eax,0x8(%ebp)
      currPtr = currPtr->next;
    }

  // otherwise, find the tail and tack on p
  } else {
    while ((*sList) != 0) {
8010592f:	8b 45 08             	mov    0x8(%ebp),%eax
80105932:	8b 00                	mov    (%eax),%eax
80105934:	85 c0                	test   %eax,%eax
80105936:	75 8f                	jne    801058c7 <tackToStateListTail+0x82>
80105938:	eb 01                	jmp    8010593b <tackToStateListTail+0xf6>
{
  struct proc *currPtr = 0;

  // if p is null, then just return
  if (p == 0)
    return;
8010593a:	90                   	nop
      
      // otherwise, keep looping
      sList = &(*sList)->next;
    }
  }
}
8010593b:	c9                   	leave  
8010593c:	c3                   	ret    

8010593d <findMatchingProcPID>:

// find a proc whose PID is equal to the specified PID
// this function searches through all lists except the free list (as mentioned in the mailing list)
struct proc*
findMatchingProcPID(uint pid)
{
8010593d:	55                   	push   %ebp
8010593e:	89 e5                	mov    %esp,%ebp
80105940:	83 ec 10             	sub    $0x10,%esp
  struct proc *currPtr = 0; 
80105943:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
8010594a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105951:	eb 3d                	jmp    80105990 <findMatchingProcPID+0x53>
    currPtr = ptable.pLists.ready[i];
80105953:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105956:	05 cc 09 00 00       	add    $0x9cc,%eax
8010595b:	8b 04 85 84 39 11 80 	mov    -0x7feec67c(,%eax,4),%eax
80105962:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while(currPtr != 0) {
80105965:	eb 1f                	jmp    80105986 <findMatchingProcPID+0x49>
      if (currPtr->pid == pid) // check if we found the proc
80105967:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010596a:	8b 40 10             	mov    0x10(%eax),%eax
8010596d:	3b 45 08             	cmp    0x8(%ebp),%eax
80105970:	75 08                	jne    8010597a <findMatchingProcPID+0x3d>
        return currPtr;
80105972:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105975:	e9 d4 00 00 00       	jmp    80105a4e <findMatchingProcPID+0x111>

      currPtr = currPtr->next;
8010597a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010597d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105983:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc *currPtr = 0; 

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
    currPtr = ptable.pLists.ready[i];
    while(currPtr != 0) {
80105986:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010598a:	75 db                	jne    80105967 <findMatchingProcPID+0x2a>
findMatchingProcPID(uint pid)
{
  struct proc *currPtr = 0; 

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
8010598c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105990:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80105994:	7e bd                	jle    80105953 <findMatchingProcPID+0x16>
      currPtr = currPtr->next;
    }
  }

  // search through sleep list
  currPtr = ptable.pLists.sleep;
80105996:	a1 bc 60 11 80       	mov    0x801160bc,%eax
8010599b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
8010599e:	eb 1f                	jmp    801059bf <findMatchingProcPID+0x82>
    if (currPtr->pid == pid) // check if we found the proc
801059a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059a3:	8b 40 10             	mov    0x10(%eax),%eax
801059a6:	3b 45 08             	cmp    0x8(%ebp),%eax
801059a9:	75 08                	jne    801059b3 <findMatchingProcPID+0x76>
      return currPtr;
801059ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059ae:	e9 9b 00 00 00       	jmp    80105a4e <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
801059b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059b6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }
  }

  // search through sleep list
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0) {
801059bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801059c3:	75 db                	jne    801059a0 <findMatchingProcPID+0x63>

    currPtr = currPtr->next;
  }

  // search through zombie list
  currPtr = ptable.pLists.zombie;
801059c5:	a1 c0 60 11 80       	mov    0x801160c0,%eax
801059ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
801059cd:	eb 1c                	jmp    801059eb <findMatchingProcPID+0xae>
    if (currPtr->pid == pid) // check if we found the proc
801059cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059d2:	8b 40 10             	mov    0x10(%eax),%eax
801059d5:	3b 45 08             	cmp    0x8(%ebp),%eax
801059d8:	75 05                	jne    801059df <findMatchingProcPID+0xa2>
      return currPtr;
801059da:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059dd:	eb 6f                	jmp    80105a4e <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
801059df:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059e2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through zombie list
  currPtr = ptable.pLists.zombie;
  while(currPtr != 0) {
801059eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801059ef:	75 de                	jne    801059cf <findMatchingProcPID+0x92>

    currPtr = currPtr->next;
  }

  // search through running list
  currPtr = ptable.pLists.running;
801059f1:	a1 c4 60 11 80       	mov    0x801160c4,%eax
801059f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
801059f9:	eb 1c                	jmp    80105a17 <findMatchingProcPID+0xda>
    if (currPtr->pid == pid) // check if we found the proc
801059fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059fe:	8b 40 10             	mov    0x10(%eax),%eax
80105a01:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a04:	75 05                	jne    80105a0b <findMatchingProcPID+0xce>
      return currPtr;
80105a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a09:	eb 43                	jmp    80105a4e <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a0e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a14:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through running list
  currPtr = ptable.pLists.running;
  while(currPtr != 0) {
80105a17:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105a1b:	75 de                	jne    801059fb <findMatchingProcPID+0xbe>

    currPtr = currPtr->next;
  }

  // search through embryo list
  currPtr = ptable.pLists.embryo;
80105a1d:	a1 c8 60 11 80       	mov    0x801160c8,%eax
80105a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105a25:	eb 1c                	jmp    80105a43 <findMatchingProcPID+0x106>
    if (currPtr->pid == pid) // check if we found the proc
80105a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a2a:	8b 40 10             	mov    0x10(%eax),%eax
80105a2d:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a30:	75 05                	jne    80105a37 <findMatchingProcPID+0xfa>
      return currPtr;
80105a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a35:	eb 17                	jmp    80105a4e <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a3a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a40:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through embryo list
  currPtr = ptable.pLists.embryo;
  while(currPtr != 0) {
80105a43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105a47:	75 de                	jne    80105a27 <findMatchingProcPID+0xea>

    currPtr = currPtr->next;
  }

  // if it isn't found then return null
  return 0;
80105a49:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a4e:	c9                   	leave  
80105a4f:	c3                   	ret    

80105a50 <setpriority>:
// sets process with pid to the specified priority. Also, this resets the budget of this process.
// only checks the RUNNING, SLEEPING, and RUNNABLE process (as mentioned in mailing list)
// returns 0 on success and -1 on error (e.g. didn't find process, or invalid params)
int
setpriority(int pid, int priority) // Added for Project 4: The setpriority() System Call
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0; 
80105a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  // check params to ensure no invalid input
  if (pid < 0 || priority < 0 || priority > MAX)
80105a5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105a61:	78 0c                	js     80105a6f <setpriority+0x1f>
80105a63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105a67:	78 06                	js     80105a6f <setpriority+0x1f>
80105a69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105a6d:	7e 0a                	jle    80105a79 <setpriority+0x29>
    return -1;
80105a6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a74:	e9 53 01 00 00       	jmp    80105bcc <setpriority+0x17c>

  acquire(&ptable.lock);
80105a79:	83 ec 0c             	sub    $0xc,%esp
80105a7c:	68 80 39 11 80       	push   $0x80113980
80105a81:	e8 ba 02 00 00       	call   80105d40 <acquire>
80105a86:	83 c4 10             	add    $0x10,%esp
 
  // check running list for process pid
  currPtr = ptable.pLists.running;
80105a89:	a1 c4 60 11 80       	mov    0x801160c4,%eax
80105a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
80105a91:	eb 4c                	jmp    80105adf <setpriority+0x8f>
    if(currPtr->pid == pid){
80105a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a96:	8b 50 10             	mov    0x10(%eax),%edx
80105a99:	8b 45 08             	mov    0x8(%ebp),%eax
80105a9c:	39 c2                	cmp    %eax,%edx
80105a9e:	75 33                	jne    80105ad3 <setpriority+0x83>
      currPtr->priority = priority;
80105aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
80105aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa6:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
80105aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aaf:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105ab6:	01 00 00 
      
      release(&ptable.lock); // since process was found, release lock and return 0 (success)
80105ab9:	83 ec 0c             	sub    $0xc,%esp
80105abc:	68 80 39 11 80       	push   $0x80113980
80105ac1:	e8 e1 02 00 00       	call   80105da7 <release>
80105ac6:	83 c4 10             	add    $0x10,%esp
      return 0;
80105ac9:	b8 00 00 00 00       	mov    $0x0,%eax
80105ace:	e9 f9 00 00 00       	jmp    80105bcc <setpriority+0x17c>
    }

    currPtr = currPtr->next;
80105ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105adc:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&ptable.lock);
 
  // check running list for process pid
  currPtr = ptable.pLists.running;
  while(currPtr != 0){
80105adf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ae3:	75 ae                	jne    80105a93 <setpriority+0x43>

    currPtr = currPtr->next;
  }

  // check sleep list for process pid
  currPtr = ptable.pLists.sleep;
80105ae5:	a1 bc 60 11 80       	mov    0x801160bc,%eax
80105aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
80105aed:	eb 4c                	jmp    80105b3b <setpriority+0xeb>

    if(currPtr->pid == pid){
80105aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af2:	8b 50 10             	mov    0x10(%eax),%edx
80105af5:	8b 45 08             	mov    0x8(%ebp),%eax
80105af8:	39 c2                	cmp    %eax,%edx
80105afa:	75 33                	jne    80105b2f <setpriority+0xdf>
      currPtr->priority = priority;
80105afc:	8b 55 0c             	mov    0xc(%ebp),%edx
80105aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b02:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
80105b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0b:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105b12:	01 00 00 
      
      release(&ptable.lock); // since process was found, release lock and return 0 (success)
80105b15:	83 ec 0c             	sub    $0xc,%esp
80105b18:	68 80 39 11 80       	push   $0x80113980
80105b1d:	e8 85 02 00 00       	call   80105da7 <release>
80105b22:	83 c4 10             	add    $0x10,%esp
      return 0;
80105b25:	b8 00 00 00 00       	mov    $0x0,%eax
80105b2a:	e9 9d 00 00 00       	jmp    80105bcc <setpriority+0x17c>
    }

    currPtr = currPtr->next;
80105b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b32:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // check sleep list for process pid
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0){
80105b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b3f:	75 ae                	jne    80105aef <setpriority+0x9f>
    }

    currPtr = currPtr->next;
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){
80105b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105b48:	eb 67                	jmp    80105bb1 <setpriority+0x161>

    currPtr = ptable.pLists.ready[i];
80105b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4d:	05 cc 09 00 00       	add    $0x9cc,%eax
80105b52:	8b 04 85 84 39 11 80 	mov    -0x7feec67c(,%eax,4),%eax
80105b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(currPtr != 0){
80105b5c:	eb 49                	jmp    80105ba7 <setpriority+0x157>

      if(currPtr->pid == pid){
80105b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b61:	8b 50 10             	mov    0x10(%eax),%edx
80105b64:	8b 45 08             	mov    0x8(%ebp),%eax
80105b67:	39 c2                	cmp    %eax,%edx
80105b69:	75 30                	jne    80105b9b <setpriority+0x14b>
        currPtr->priority = priority;
80105b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b71:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        currPtr->budget = DEFAULT_BUDGET;
80105b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7a:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105b81:	01 00 00 
      
        release(&ptable.lock); // since process was found, release lock and return 0 (success)
80105b84:	83 ec 0c             	sub    $0xc,%esp
80105b87:	68 80 39 11 80       	push   $0x80113980
80105b8c:	e8 16 02 00 00       	call   80105da7 <release>
80105b91:	83 c4 10             	add    $0x10,%esp
        return 0;
80105b94:	b8 00 00 00 00       	mov    $0x0,%eax
80105b99:	eb 31                	jmp    80105bcc <setpriority+0x17c>
      }

      currPtr = currPtr->next;
80105b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b9e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){

    currPtr = ptable.pLists.ready[i];
    while(currPtr != 0){
80105ba7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bab:	75 b1                	jne    80105b5e <setpriority+0x10e>
    }

    currPtr = currPtr->next;
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){
80105bad:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105bb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bb5:	7e 93                	jle    80105b4a <setpriority+0xfa>
      currPtr = currPtr->next;
    }
  }

  // if nothing was found, release lock and return -1 (error)
  release(&ptable.lock);
80105bb7:	83 ec 0c             	sub    $0xc,%esp
80105bba:	68 80 39 11 80       	push   $0x80113980
80105bbf:	e8 e3 01 00 00       	call   80105da7 <release>
80105bc4:	83 c4 10             	add    $0x10,%esp
  return -1;
80105bc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bcc:	c9                   	leave  
80105bcd:	c3                   	ret    

80105bce <doPeriodicPromotion>:

// promote all processes within ready, sleeping, and running lists by 1 priority level (this is called from scheduler when we hit ticks threshold) 
void
doPeriodicPromotion(void) // Added for Project 4: Periodic Priority Adjustment
{
80105bce:	55                   	push   %ebp
80105bcf:	89 e5                	mov    %esp,%ebp
80105bd1:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0;
80105bd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
  // reduce priority of procs in running list (if they aren't at 0)
  currPtr = ptable.pLists.running;
80105bdb:	a1 c4 60 11 80       	mov    0x801160c4,%eax
80105be0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (currPtr != 0){
80105be3:	eb 3b                	jmp    80105c20 <doPeriodicPromotion+0x52>
    currPtr->budget = DEFAULT_BUDGET;
80105be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be8:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105bef:	01 00 00 

    if (currPtr->priority > 0){
80105bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf5:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105bfb:	85 c0                	test   %eax,%eax
80105bfd:	74 15                	je     80105c14 <doPeriodicPromotion+0x46>
      currPtr->priority--;
80105bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c02:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c08:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c0e:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    }
      
    currPtr = currPtr->next;
80105c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c17:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc *currPtr = 0;
  
  // reduce priority of procs in running list (if they aren't at 0)
  currPtr = ptable.pLists.running;
  while (currPtr != 0){
80105c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c24:	75 bf                	jne    80105be5 <doPeriodicPromotion+0x17>
      
    currPtr = currPtr->next;
  }

  // reduce priority of procs in sleep list (if they aren't at 0), also reset budgets
  currPtr = ptable.pLists.sleep;
80105c26:	a1 bc 60 11 80       	mov    0x801160bc,%eax
80105c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
80105c2e:	eb 3b                	jmp    80105c6b <doPeriodicPromotion+0x9d>
    currPtr->budget = DEFAULT_BUDGET;
80105c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c33:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105c3a:	01 00 00 
    
    if (currPtr->priority > 0)
80105c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c40:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c46:	85 c0                	test   %eax,%eax
80105c48:	74 15                	je     80105c5f <doPeriodicPromotion+0x91>
      currPtr->priority--;
80105c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c53:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c59:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)

    currPtr = currPtr->next;
80105c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c62:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // reduce priority of procs in sleep list (if they aren't at 0), also reset budgets
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0){
80105c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c6f:	75 bf                	jne    80105c30 <doPeriodicPromotion+0x62>

    currPtr = currPtr->next;
  }

  // reset budgets of procs already in ready[0] to prevent un-needed budget-resets in the below for/while loop
  currPtr = ptable.pLists.ready[0];
80105c71:	a1 b4 60 11 80       	mov    0x801160b4,%eax
80105c76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (currPtr != 0){
80105c79:	eb 19                	jmp    80105c94 <doPeriodicPromotion+0xc6>
    currPtr->budget = DEFAULT_BUDGET;
80105c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7e:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105c85:	01 00 00 
    currPtr = currPtr->next;
80105c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c8b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // reset budgets of procs already in ready[0] to prevent un-needed budget-resets in the below for/while loop
  currPtr = ptable.pLists.ready[0];
  while (currPtr != 0){
80105c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c98:	75 e1                	jne    80105c7b <doPeriodicPromotion+0xad>
    currPtr->budget = DEFAULT_BUDGET;
    currPtr = currPtr->next;
  }
  
  // move procs in priorities 1 through MAX + 1 up one level (and reset their budgets)
  for(int i = 1; i < MAX + 1; ++i)
80105c9a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80105ca1:	eb 3a                	jmp    80105cdd <doPeriodicPromotion+0x10f>
    tackToStateListTail(&ptable.pLists.ready[i - 1], RUNNABLE, ptable.pLists.ready[i]);
80105ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca6:	05 cc 09 00 00       	add    $0x9cc,%eax
80105cab:	8b 04 85 84 39 11 80 	mov    -0x7feec67c(,%eax,4),%eax
80105cb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105cb5:	83 ea 01             	sub    $0x1,%edx
80105cb8:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80105cbe:	c1 e2 02             	shl    $0x2,%edx
80105cc1:	81 c2 80 39 11 80    	add    $0x80113980,%edx
80105cc7:	83 c2 04             	add    $0x4,%edx
80105cca:	83 ec 04             	sub    $0x4,%esp
80105ccd:	50                   	push   %eax
80105cce:	6a 03                	push   $0x3
80105cd0:	52                   	push   %edx
80105cd1:	e8 6f fb ff ff       	call   80105845 <tackToStateListTail>
80105cd6:	83 c4 10             	add    $0x10,%esp
    currPtr->budget = DEFAULT_BUDGET;
    currPtr = currPtr->next;
  }
  
  // move procs in priorities 1 through MAX + 1 up one level (and reset their budgets)
  for(int i = 1; i < MAX + 1; ++i)
80105cd9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105cdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ce1:	7e c0                	jle    80105ca3 <doPeriodicPromotion+0xd5>
    tackToStateListTail(&ptable.pLists.ready[i - 1], RUNNABLE, ptable.pLists.ready[i]);

}
80105ce3:	90                   	nop
80105ce4:	c9                   	leave  
80105ce5:	c3                   	ret    

80105ce6 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105ce6:	55                   	push   %ebp
80105ce7:	89 e5                	mov    %esp,%ebp
80105ce9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105cec:	9c                   	pushf  
80105ced:	58                   	pop    %eax
80105cee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105cf4:	c9                   	leave  
80105cf5:	c3                   	ret    

80105cf6 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105cf6:	55                   	push   %ebp
80105cf7:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105cf9:	fa                   	cli    
}
80105cfa:	90                   	nop
80105cfb:	5d                   	pop    %ebp
80105cfc:	c3                   	ret    

80105cfd <sti>:

static inline void
sti(void)
{
80105cfd:	55                   	push   %ebp
80105cfe:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105d00:	fb                   	sti    
}
80105d01:	90                   	nop
80105d02:	5d                   	pop    %ebp
80105d03:	c3                   	ret    

80105d04 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105d0a:	8b 55 08             	mov    0x8(%ebp),%edx
80105d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d10:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105d13:	f0 87 02             	lock xchg %eax,(%edx)
80105d16:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105d19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105d1c:	c9                   	leave  
80105d1d:	c3                   	ret    

80105d1e <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105d1e:	55                   	push   %ebp
80105d1f:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105d21:	8b 45 08             	mov    0x8(%ebp),%eax
80105d24:	8b 55 0c             	mov    0xc(%ebp),%edx
80105d27:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105d2a:	8b 45 08             	mov    0x8(%ebp),%eax
80105d2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105d33:	8b 45 08             	mov    0x8(%ebp),%eax
80105d36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105d3d:	90                   	nop
80105d3e:	5d                   	pop    %ebp
80105d3f:	c3                   	ret    

80105d40 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105d46:	e8 52 01 00 00       	call   80105e9d <pushcli>
  if(holding(lk))
80105d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80105d4e:	83 ec 0c             	sub    $0xc,%esp
80105d51:	50                   	push   %eax
80105d52:	e8 1c 01 00 00       	call   80105e73 <holding>
80105d57:	83 c4 10             	add    $0x10,%esp
80105d5a:	85 c0                	test   %eax,%eax
80105d5c:	74 0d                	je     80105d6b <acquire+0x2b>
    panic("acquire");
80105d5e:	83 ec 0c             	sub    $0xc,%esp
80105d61:	68 9c 9a 10 80       	push   $0x80109a9c
80105d66:	e8 fb a7 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105d6b:	90                   	nop
80105d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80105d6f:	83 ec 08             	sub    $0x8,%esp
80105d72:	6a 01                	push   $0x1
80105d74:	50                   	push   %eax
80105d75:	e8 8a ff ff ff       	call   80105d04 <xchg>
80105d7a:	83 c4 10             	add    $0x10,%esp
80105d7d:	85 c0                	test   %eax,%eax
80105d7f:	75 eb                	jne    80105d6c <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105d81:	8b 45 08             	mov    0x8(%ebp),%eax
80105d84:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105d8b:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105d8e:	8b 45 08             	mov    0x8(%ebp),%eax
80105d91:	83 c0 0c             	add    $0xc,%eax
80105d94:	83 ec 08             	sub    $0x8,%esp
80105d97:	50                   	push   %eax
80105d98:	8d 45 08             	lea    0x8(%ebp),%eax
80105d9b:	50                   	push   %eax
80105d9c:	e8 58 00 00 00       	call   80105df9 <getcallerpcs>
80105da1:	83 c4 10             	add    $0x10,%esp
}
80105da4:	90                   	nop
80105da5:	c9                   	leave  
80105da6:	c3                   	ret    

80105da7 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105da7:	55                   	push   %ebp
80105da8:	89 e5                	mov    %esp,%ebp
80105daa:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105dad:	83 ec 0c             	sub    $0xc,%esp
80105db0:	ff 75 08             	pushl  0x8(%ebp)
80105db3:	e8 bb 00 00 00       	call   80105e73 <holding>
80105db8:	83 c4 10             	add    $0x10,%esp
80105dbb:	85 c0                	test   %eax,%eax
80105dbd:	75 0d                	jne    80105dcc <release+0x25>
    panic("release");
80105dbf:	83 ec 0c             	sub    $0xc,%esp
80105dc2:	68 a4 9a 10 80       	push   $0x80109aa4
80105dc7:	e8 9a a7 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80105dcf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80105dd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105de0:	8b 45 08             	mov    0x8(%ebp),%eax
80105de3:	83 ec 08             	sub    $0x8,%esp
80105de6:	6a 00                	push   $0x0
80105de8:	50                   	push   %eax
80105de9:	e8 16 ff ff ff       	call   80105d04 <xchg>
80105dee:	83 c4 10             	add    $0x10,%esp

  popcli();
80105df1:	e8 ec 00 00 00       	call   80105ee2 <popcli>
}
80105df6:	90                   	nop
80105df7:	c9                   	leave  
80105df8:	c3                   	ret    

80105df9 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105df9:	55                   	push   %ebp
80105dfa:	89 e5                	mov    %esp,%ebp
80105dfc:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105dff:	8b 45 08             	mov    0x8(%ebp),%eax
80105e02:	83 e8 08             	sub    $0x8,%eax
80105e05:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105e08:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105e0f:	eb 38                	jmp    80105e49 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105e11:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105e15:	74 53                	je     80105e6a <getcallerpcs+0x71>
80105e17:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105e1e:	76 4a                	jbe    80105e6a <getcallerpcs+0x71>
80105e20:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105e24:	74 44                	je     80105e6a <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105e26:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105e29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105e30:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e33:	01 c2                	add    %eax,%edx
80105e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e38:	8b 40 04             	mov    0x4(%eax),%eax
80105e3b:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e40:	8b 00                	mov    (%eax),%eax
80105e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105e45:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105e49:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105e4d:	7e c2                	jle    80105e11 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105e4f:	eb 19                	jmp    80105e6a <getcallerpcs+0x71>
    pcs[i] = 0;
80105e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105e54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e5e:	01 d0                	add    %edx,%eax
80105e60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105e66:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105e6a:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105e6e:	7e e1                	jle    80105e51 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105e70:	90                   	nop
80105e71:	c9                   	leave  
80105e72:	c3                   	ret    

80105e73 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105e73:	55                   	push   %ebp
80105e74:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105e76:	8b 45 08             	mov    0x8(%ebp),%eax
80105e79:	8b 00                	mov    (%eax),%eax
80105e7b:	85 c0                	test   %eax,%eax
80105e7d:	74 17                	je     80105e96 <holding+0x23>
80105e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80105e82:	8b 50 08             	mov    0x8(%eax),%edx
80105e85:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105e8b:	39 c2                	cmp    %eax,%edx
80105e8d:	75 07                	jne    80105e96 <holding+0x23>
80105e8f:	b8 01 00 00 00       	mov    $0x1,%eax
80105e94:	eb 05                	jmp    80105e9b <holding+0x28>
80105e96:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e9b:	5d                   	pop    %ebp
80105e9c:	c3                   	ret    

80105e9d <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105e9d:	55                   	push   %ebp
80105e9e:	89 e5                	mov    %esp,%ebp
80105ea0:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105ea3:	e8 3e fe ff ff       	call   80105ce6 <readeflags>
80105ea8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105eab:	e8 46 fe ff ff       	call   80105cf6 <cli>
  if(cpu->ncli++ == 0)
80105eb0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105eb7:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105ebd:	8d 48 01             	lea    0x1(%eax),%ecx
80105ec0:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105ec6:	85 c0                	test   %eax,%eax
80105ec8:	75 15                	jne    80105edf <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105eca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ed3:	81 e2 00 02 00 00    	and    $0x200,%edx
80105ed9:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105edf:	90                   	nop
80105ee0:	c9                   	leave  
80105ee1:	c3                   	ret    

80105ee2 <popcli>:

void
popcli(void)
{
80105ee2:	55                   	push   %ebp
80105ee3:	89 e5                	mov    %esp,%ebp
80105ee5:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105ee8:	e8 f9 fd ff ff       	call   80105ce6 <readeflags>
80105eed:	25 00 02 00 00       	and    $0x200,%eax
80105ef2:	85 c0                	test   %eax,%eax
80105ef4:	74 0d                	je     80105f03 <popcli+0x21>
    panic("popcli - interruptible");
80105ef6:	83 ec 0c             	sub    $0xc,%esp
80105ef9:	68 ac 9a 10 80       	push   $0x80109aac
80105efe:	e8 63 a6 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80105f03:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105f09:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105f0f:	83 ea 01             	sub    $0x1,%edx
80105f12:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105f18:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105f1e:	85 c0                	test   %eax,%eax
80105f20:	79 0d                	jns    80105f2f <popcli+0x4d>
    panic("popcli");
80105f22:	83 ec 0c             	sub    $0xc,%esp
80105f25:	68 c3 9a 10 80       	push   $0x80109ac3
80105f2a:	e8 37 a6 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105f2f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105f35:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105f3b:	85 c0                	test   %eax,%eax
80105f3d:	75 15                	jne    80105f54 <popcli+0x72>
80105f3f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105f45:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105f4b:	85 c0                	test   %eax,%eax
80105f4d:	74 05                	je     80105f54 <popcli+0x72>
    sti();
80105f4f:	e8 a9 fd ff ff       	call   80105cfd <sti>
}
80105f54:	90                   	nop
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    

80105f57 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105f57:	55                   	push   %ebp
80105f58:	89 e5                	mov    %esp,%ebp
80105f5a:	57                   	push   %edi
80105f5b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105f5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105f5f:	8b 55 10             	mov    0x10(%ebp),%edx
80105f62:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f65:	89 cb                	mov    %ecx,%ebx
80105f67:	89 df                	mov    %ebx,%edi
80105f69:	89 d1                	mov    %edx,%ecx
80105f6b:	fc                   	cld    
80105f6c:	f3 aa                	rep stos %al,%es:(%edi)
80105f6e:	89 ca                	mov    %ecx,%edx
80105f70:	89 fb                	mov    %edi,%ebx
80105f72:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105f75:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105f78:	90                   	nop
80105f79:	5b                   	pop    %ebx
80105f7a:	5f                   	pop    %edi
80105f7b:	5d                   	pop    %ebp
80105f7c:	c3                   	ret    

80105f7d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105f7d:	55                   	push   %ebp
80105f7e:	89 e5                	mov    %esp,%ebp
80105f80:	57                   	push   %edi
80105f81:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105f82:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105f85:	8b 55 10             	mov    0x10(%ebp),%edx
80105f88:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f8b:	89 cb                	mov    %ecx,%ebx
80105f8d:	89 df                	mov    %ebx,%edi
80105f8f:	89 d1                	mov    %edx,%ecx
80105f91:	fc                   	cld    
80105f92:	f3 ab                	rep stos %eax,%es:(%edi)
80105f94:	89 ca                	mov    %ecx,%edx
80105f96:	89 fb                	mov    %edi,%ebx
80105f98:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105f9b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105f9e:	90                   	nop
80105f9f:	5b                   	pop    %ebx
80105fa0:	5f                   	pop    %edi
80105fa1:	5d                   	pop    %ebp
80105fa2:	c3                   	ret    

80105fa3 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105fa3:	55                   	push   %ebp
80105fa4:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105fa6:	8b 45 08             	mov    0x8(%ebp),%eax
80105fa9:	83 e0 03             	and    $0x3,%eax
80105fac:	85 c0                	test   %eax,%eax
80105fae:	75 43                	jne    80105ff3 <memset+0x50>
80105fb0:	8b 45 10             	mov    0x10(%ebp),%eax
80105fb3:	83 e0 03             	and    $0x3,%eax
80105fb6:	85 c0                	test   %eax,%eax
80105fb8:	75 39                	jne    80105ff3 <memset+0x50>
    c &= 0xFF;
80105fba:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105fc1:	8b 45 10             	mov    0x10(%ebp),%eax
80105fc4:	c1 e8 02             	shr    $0x2,%eax
80105fc7:	89 c1                	mov    %eax,%ecx
80105fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fcc:	c1 e0 18             	shl    $0x18,%eax
80105fcf:	89 c2                	mov    %eax,%edx
80105fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fd4:	c1 e0 10             	shl    $0x10,%eax
80105fd7:	09 c2                	or     %eax,%edx
80105fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fdc:	c1 e0 08             	shl    $0x8,%eax
80105fdf:	09 d0                	or     %edx,%eax
80105fe1:	0b 45 0c             	or     0xc(%ebp),%eax
80105fe4:	51                   	push   %ecx
80105fe5:	50                   	push   %eax
80105fe6:	ff 75 08             	pushl  0x8(%ebp)
80105fe9:	e8 8f ff ff ff       	call   80105f7d <stosl>
80105fee:	83 c4 0c             	add    $0xc,%esp
80105ff1:	eb 12                	jmp    80106005 <memset+0x62>
  } else
    stosb(dst, c, n);
80105ff3:	8b 45 10             	mov    0x10(%ebp),%eax
80105ff6:	50                   	push   %eax
80105ff7:	ff 75 0c             	pushl  0xc(%ebp)
80105ffa:	ff 75 08             	pushl  0x8(%ebp)
80105ffd:	e8 55 ff ff ff       	call   80105f57 <stosb>
80106002:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106005:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106008:	c9                   	leave  
80106009:	c3                   	ret    

8010600a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010600a:	55                   	push   %ebp
8010600b:	89 e5                	mov    %esp,%ebp
8010600d:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106010:	8b 45 08             	mov    0x8(%ebp),%eax
80106013:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106016:	8b 45 0c             	mov    0xc(%ebp),%eax
80106019:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010601c:	eb 30                	jmp    8010604e <memcmp+0x44>
    if(*s1 != *s2)
8010601e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106021:	0f b6 10             	movzbl (%eax),%edx
80106024:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106027:	0f b6 00             	movzbl (%eax),%eax
8010602a:	38 c2                	cmp    %al,%dl
8010602c:	74 18                	je     80106046 <memcmp+0x3c>
      return *s1 - *s2;
8010602e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106031:	0f b6 00             	movzbl (%eax),%eax
80106034:	0f b6 d0             	movzbl %al,%edx
80106037:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010603a:	0f b6 00             	movzbl (%eax),%eax
8010603d:	0f b6 c0             	movzbl %al,%eax
80106040:	29 c2                	sub    %eax,%edx
80106042:	89 d0                	mov    %edx,%eax
80106044:	eb 1a                	jmp    80106060 <memcmp+0x56>
    s1++, s2++;
80106046:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010604a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010604e:	8b 45 10             	mov    0x10(%ebp),%eax
80106051:	8d 50 ff             	lea    -0x1(%eax),%edx
80106054:	89 55 10             	mov    %edx,0x10(%ebp)
80106057:	85 c0                	test   %eax,%eax
80106059:	75 c3                	jne    8010601e <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010605b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106060:	c9                   	leave  
80106061:	c3                   	ret    

80106062 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106062:	55                   	push   %ebp
80106063:	89 e5                	mov    %esp,%ebp
80106065:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106068:	8b 45 0c             	mov    0xc(%ebp),%eax
8010606b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010606e:	8b 45 08             	mov    0x8(%ebp),%eax
80106071:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106074:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106077:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010607a:	73 54                	jae    801060d0 <memmove+0x6e>
8010607c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010607f:	8b 45 10             	mov    0x10(%ebp),%eax
80106082:	01 d0                	add    %edx,%eax
80106084:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106087:	76 47                	jbe    801060d0 <memmove+0x6e>
    s += n;
80106089:	8b 45 10             	mov    0x10(%ebp),%eax
8010608c:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010608f:	8b 45 10             	mov    0x10(%ebp),%eax
80106092:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106095:	eb 13                	jmp    801060aa <memmove+0x48>
      *--d = *--s;
80106097:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010609b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010609f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801060a2:	0f b6 10             	movzbl (%eax),%edx
801060a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801060a8:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801060aa:	8b 45 10             	mov    0x10(%ebp),%eax
801060ad:	8d 50 ff             	lea    -0x1(%eax),%edx
801060b0:	89 55 10             	mov    %edx,0x10(%ebp)
801060b3:	85 c0                	test   %eax,%eax
801060b5:	75 e0                	jne    80106097 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801060b7:	eb 24                	jmp    801060dd <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801060b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801060bc:	8d 50 01             	lea    0x1(%eax),%edx
801060bf:	89 55 f8             	mov    %edx,-0x8(%ebp)
801060c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801060c5:	8d 4a 01             	lea    0x1(%edx),%ecx
801060c8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801060cb:	0f b6 12             	movzbl (%edx),%edx
801060ce:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801060d0:	8b 45 10             	mov    0x10(%ebp),%eax
801060d3:	8d 50 ff             	lea    -0x1(%eax),%edx
801060d6:	89 55 10             	mov    %edx,0x10(%ebp)
801060d9:	85 c0                	test   %eax,%eax
801060db:	75 dc                	jne    801060b9 <memmove+0x57>
      *d++ = *s++;

  return dst;
801060dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
801060e0:	c9                   	leave  
801060e1:	c3                   	ret    

801060e2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801060e2:	55                   	push   %ebp
801060e3:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801060e5:	ff 75 10             	pushl  0x10(%ebp)
801060e8:	ff 75 0c             	pushl  0xc(%ebp)
801060eb:	ff 75 08             	pushl  0x8(%ebp)
801060ee:	e8 6f ff ff ff       	call   80106062 <memmove>
801060f3:	83 c4 0c             	add    $0xc,%esp
}
801060f6:	c9                   	leave  
801060f7:	c3                   	ret    

801060f8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801060f8:	55                   	push   %ebp
801060f9:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801060fb:	eb 0c                	jmp    80106109 <strncmp+0x11>
    n--, p++, q++;
801060fd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106101:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106105:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106109:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010610d:	74 1a                	je     80106129 <strncmp+0x31>
8010610f:	8b 45 08             	mov    0x8(%ebp),%eax
80106112:	0f b6 00             	movzbl (%eax),%eax
80106115:	84 c0                	test   %al,%al
80106117:	74 10                	je     80106129 <strncmp+0x31>
80106119:	8b 45 08             	mov    0x8(%ebp),%eax
8010611c:	0f b6 10             	movzbl (%eax),%edx
8010611f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106122:	0f b6 00             	movzbl (%eax),%eax
80106125:	38 c2                	cmp    %al,%dl
80106127:	74 d4                	je     801060fd <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106129:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010612d:	75 07                	jne    80106136 <strncmp+0x3e>
    return 0;
8010612f:	b8 00 00 00 00       	mov    $0x0,%eax
80106134:	eb 16                	jmp    8010614c <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106136:	8b 45 08             	mov    0x8(%ebp),%eax
80106139:	0f b6 00             	movzbl (%eax),%eax
8010613c:	0f b6 d0             	movzbl %al,%edx
8010613f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106142:	0f b6 00             	movzbl (%eax),%eax
80106145:	0f b6 c0             	movzbl %al,%eax
80106148:	29 c2                	sub    %eax,%edx
8010614a:	89 d0                	mov    %edx,%eax
}
8010614c:	5d                   	pop    %ebp
8010614d:	c3                   	ret    

8010614e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010614e:	55                   	push   %ebp
8010614f:	89 e5                	mov    %esp,%ebp
80106151:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106154:	8b 45 08             	mov    0x8(%ebp),%eax
80106157:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010615a:	90                   	nop
8010615b:	8b 45 10             	mov    0x10(%ebp),%eax
8010615e:	8d 50 ff             	lea    -0x1(%eax),%edx
80106161:	89 55 10             	mov    %edx,0x10(%ebp)
80106164:	85 c0                	test   %eax,%eax
80106166:	7e 2c                	jle    80106194 <strncpy+0x46>
80106168:	8b 45 08             	mov    0x8(%ebp),%eax
8010616b:	8d 50 01             	lea    0x1(%eax),%edx
8010616e:	89 55 08             	mov    %edx,0x8(%ebp)
80106171:	8b 55 0c             	mov    0xc(%ebp),%edx
80106174:	8d 4a 01             	lea    0x1(%edx),%ecx
80106177:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010617a:	0f b6 12             	movzbl (%edx),%edx
8010617d:	88 10                	mov    %dl,(%eax)
8010617f:	0f b6 00             	movzbl (%eax),%eax
80106182:	84 c0                	test   %al,%al
80106184:	75 d5                	jne    8010615b <strncpy+0xd>
    ;
  while(n-- > 0)
80106186:	eb 0c                	jmp    80106194 <strncpy+0x46>
    *s++ = 0;
80106188:	8b 45 08             	mov    0x8(%ebp),%eax
8010618b:	8d 50 01             	lea    0x1(%eax),%edx
8010618e:	89 55 08             	mov    %edx,0x8(%ebp)
80106191:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106194:	8b 45 10             	mov    0x10(%ebp),%eax
80106197:	8d 50 ff             	lea    -0x1(%eax),%edx
8010619a:	89 55 10             	mov    %edx,0x10(%ebp)
8010619d:	85 c0                	test   %eax,%eax
8010619f:	7f e7                	jg     80106188 <strncpy+0x3a>
    *s++ = 0;
  return os;
801061a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801061a4:	c9                   	leave  
801061a5:	c3                   	ret    

801061a6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801061a6:	55                   	push   %ebp
801061a7:	89 e5                	mov    %esp,%ebp
801061a9:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801061ac:	8b 45 08             	mov    0x8(%ebp),%eax
801061af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801061b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801061b6:	7f 05                	jg     801061bd <safestrcpy+0x17>
    return os;
801061b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061bb:	eb 31                	jmp    801061ee <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801061bd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801061c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801061c5:	7e 1e                	jle    801061e5 <safestrcpy+0x3f>
801061c7:	8b 45 08             	mov    0x8(%ebp),%eax
801061ca:	8d 50 01             	lea    0x1(%eax),%edx
801061cd:	89 55 08             	mov    %edx,0x8(%ebp)
801061d0:	8b 55 0c             	mov    0xc(%ebp),%edx
801061d3:	8d 4a 01             	lea    0x1(%edx),%ecx
801061d6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801061d9:	0f b6 12             	movzbl (%edx),%edx
801061dc:	88 10                	mov    %dl,(%eax)
801061de:	0f b6 00             	movzbl (%eax),%eax
801061e1:	84 c0                	test   %al,%al
801061e3:	75 d8                	jne    801061bd <safestrcpy+0x17>
    ;
  *s = 0;
801061e5:	8b 45 08             	mov    0x8(%ebp),%eax
801061e8:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801061eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801061ee:	c9                   	leave  
801061ef:	c3                   	ret    

801061f0 <strlen>:

int
strlen(const char *s)
{
801061f0:	55                   	push   %ebp
801061f1:	89 e5                	mov    %esp,%ebp
801061f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801061f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801061fd:	eb 04                	jmp    80106203 <strlen+0x13>
801061ff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106203:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106206:	8b 45 08             	mov    0x8(%ebp),%eax
80106209:	01 d0                	add    %edx,%eax
8010620b:	0f b6 00             	movzbl (%eax),%eax
8010620e:	84 c0                	test   %al,%al
80106210:	75 ed                	jne    801061ff <strlen+0xf>
    ;
  return n;
80106212:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106215:	c9                   	leave  
80106216:	c3                   	ret    

80106217 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106217:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010621b:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010621f:	55                   	push   %ebp
  pushl %ebx
80106220:	53                   	push   %ebx
  pushl %esi
80106221:	56                   	push   %esi
  pushl %edi
80106222:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106223:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106225:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106227:	5f                   	pop    %edi
  popl %esi
80106228:	5e                   	pop    %esi
  popl %ebx
80106229:	5b                   	pop    %ebx
  popl %ebp
8010622a:	5d                   	pop    %ebp
  ret
8010622b:	c3                   	ret    

8010622c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010622c:	55                   	push   %ebp
8010622d:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010622f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106235:	8b 00                	mov    (%eax),%eax
80106237:	3b 45 08             	cmp    0x8(%ebp),%eax
8010623a:	76 12                	jbe    8010624e <fetchint+0x22>
8010623c:	8b 45 08             	mov    0x8(%ebp),%eax
8010623f:	8d 50 04             	lea    0x4(%eax),%edx
80106242:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106248:	8b 00                	mov    (%eax),%eax
8010624a:	39 c2                	cmp    %eax,%edx
8010624c:	76 07                	jbe    80106255 <fetchint+0x29>
    return -1;
8010624e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106253:	eb 0f                	jmp    80106264 <fetchint+0x38>
  *ip = *(int*)(addr);
80106255:	8b 45 08             	mov    0x8(%ebp),%eax
80106258:	8b 10                	mov    (%eax),%edx
8010625a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010625d:	89 10                	mov    %edx,(%eax)
  return 0;
8010625f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106264:	5d                   	pop    %ebp
80106265:	c3                   	ret    

80106266 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106266:	55                   	push   %ebp
80106267:	89 e5                	mov    %esp,%ebp
80106269:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010626c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106272:	8b 00                	mov    (%eax),%eax
80106274:	3b 45 08             	cmp    0x8(%ebp),%eax
80106277:	77 07                	ja     80106280 <fetchstr+0x1a>
    return -1;
80106279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010627e:	eb 46                	jmp    801062c6 <fetchstr+0x60>
  *pp = (char*)addr;
80106280:	8b 55 08             	mov    0x8(%ebp),%edx
80106283:	8b 45 0c             	mov    0xc(%ebp),%eax
80106286:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106288:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010628e:	8b 00                	mov    (%eax),%eax
80106290:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106293:	8b 45 0c             	mov    0xc(%ebp),%eax
80106296:	8b 00                	mov    (%eax),%eax
80106298:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010629b:	eb 1c                	jmp    801062b9 <fetchstr+0x53>
    if(*s == 0)
8010629d:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062a0:	0f b6 00             	movzbl (%eax),%eax
801062a3:	84 c0                	test   %al,%al
801062a5:	75 0e                	jne    801062b5 <fetchstr+0x4f>
      return s - *pp;
801062a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801062aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801062ad:	8b 00                	mov    (%eax),%eax
801062af:	29 c2                	sub    %eax,%edx
801062b1:	89 d0                	mov    %edx,%eax
801062b3:	eb 11                	jmp    801062c6 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801062b5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801062b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801062bf:	72 dc                	jb     8010629d <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801062c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062c6:	c9                   	leave  
801062c7:	c3                   	ret    

801062c8 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801062c8:	55                   	push   %ebp
801062c9:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801062cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062d1:	8b 40 18             	mov    0x18(%eax),%eax
801062d4:	8b 40 44             	mov    0x44(%eax),%eax
801062d7:	8b 55 08             	mov    0x8(%ebp),%edx
801062da:	c1 e2 02             	shl    $0x2,%edx
801062dd:	01 d0                	add    %edx,%eax
801062df:	83 c0 04             	add    $0x4,%eax
801062e2:	ff 75 0c             	pushl  0xc(%ebp)
801062e5:	50                   	push   %eax
801062e6:	e8 41 ff ff ff       	call   8010622c <fetchint>
801062eb:	83 c4 08             	add    $0x8,%esp
}
801062ee:	c9                   	leave  
801062ef:	c3                   	ret    

801062f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801062f6:	8d 45 fc             	lea    -0x4(%ebp),%eax
801062f9:	50                   	push   %eax
801062fa:	ff 75 08             	pushl  0x8(%ebp)
801062fd:	e8 c6 ff ff ff       	call   801062c8 <argint>
80106302:	83 c4 08             	add    $0x8,%esp
80106305:	85 c0                	test   %eax,%eax
80106307:	79 07                	jns    80106310 <argptr+0x20>
    return -1;
80106309:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010630e:	eb 3b                	jmp    8010634b <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106310:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106316:	8b 00                	mov    (%eax),%eax
80106318:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010631b:	39 d0                	cmp    %edx,%eax
8010631d:	76 16                	jbe    80106335 <argptr+0x45>
8010631f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106322:	89 c2                	mov    %eax,%edx
80106324:	8b 45 10             	mov    0x10(%ebp),%eax
80106327:	01 c2                	add    %eax,%edx
80106329:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010632f:	8b 00                	mov    (%eax),%eax
80106331:	39 c2                	cmp    %eax,%edx
80106333:	76 07                	jbe    8010633c <argptr+0x4c>
    return -1;
80106335:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010633a:	eb 0f                	jmp    8010634b <argptr+0x5b>
  *pp = (char*)i;
8010633c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010633f:	89 c2                	mov    %eax,%edx
80106341:	8b 45 0c             	mov    0xc(%ebp),%eax
80106344:	89 10                	mov    %edx,(%eax)
  return 0;
80106346:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010634b:	c9                   	leave  
8010634c:	c3                   	ret    

8010634d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010634d:	55                   	push   %ebp
8010634e:	89 e5                	mov    %esp,%ebp
80106350:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106353:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106356:	50                   	push   %eax
80106357:	ff 75 08             	pushl  0x8(%ebp)
8010635a:	e8 69 ff ff ff       	call   801062c8 <argint>
8010635f:	83 c4 08             	add    $0x8,%esp
80106362:	85 c0                	test   %eax,%eax
80106364:	79 07                	jns    8010636d <argstr+0x20>
    return -1;
80106366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010636b:	eb 0f                	jmp    8010637c <argstr+0x2f>
  return fetchstr(addr, pp);
8010636d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106370:	ff 75 0c             	pushl  0xc(%ebp)
80106373:	50                   	push   %eax
80106374:	e8 ed fe ff ff       	call   80106266 <fetchstr>
80106379:	83 c4 08             	add    $0x8,%esp
}
8010637c:	c9                   	leave  
8010637d:	c3                   	ret    

8010637e <syscall>:
#endif
// END: Added for Project 1: System Call Tracing

void
syscall(void)
{
8010637e:	55                   	push   %ebp
8010637f:	89 e5                	mov    %esp,%ebp
80106381:	53                   	push   %ebx
80106382:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106385:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010638b:	8b 40 18             	mov    0x18(%eax),%eax
8010638e:	8b 40 1c             	mov    0x1c(%eax),%eax
80106391:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106394:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106398:	7e 30                	jle    801063ca <syscall+0x4c>
8010639a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639d:	83 f8 1c             	cmp    $0x1c,%eax
801063a0:	77 28                	ja     801063ca <syscall+0x4c>
801063a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a5:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801063ac:	85 c0                	test   %eax,%eax
801063ae:	74 1a                	je     801063ca <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801063b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063b6:	8b 58 18             	mov    0x18(%eax),%ebx
801063b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063bc:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801063c3:	ff d0                	call   *%eax
801063c5:	89 43 1c             	mov    %eax,0x1c(%ebx)
801063c8:	eb 34                	jmp    801063fe <syscall+0x80>
    #endif
    // END: Added for Project 1: System Call Tracing

  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801063ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063d0:	8d 50 6c             	lea    0x6c(%eax),%edx
801063d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
            syscallnames[num], proc->tf->eax);
    #endif
    // END: Added for Project 1: System Call Tracing

  } else {
    cprintf("%d %s: unknown sys call %d\n",
801063d9:	8b 40 10             	mov    0x10(%eax),%eax
801063dc:	ff 75 f4             	pushl  -0xc(%ebp)
801063df:	52                   	push   %edx
801063e0:	50                   	push   %eax
801063e1:	68 ca 9a 10 80       	push   $0x80109aca
801063e6:	e8 db 9f ff ff       	call   801003c6 <cprintf>
801063eb:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801063ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063f4:	8b 40 18             	mov    0x18(%eax),%eax
801063f7:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801063fe:	90                   	nop
801063ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106402:	c9                   	leave  
80106403:	c3                   	ret    

80106404 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106404:	55                   	push   %ebp
80106405:	89 e5                	mov    %esp,%ebp
80106407:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010640a:	83 ec 08             	sub    $0x8,%esp
8010640d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106410:	50                   	push   %eax
80106411:	ff 75 08             	pushl  0x8(%ebp)
80106414:	e8 af fe ff ff       	call   801062c8 <argint>
80106419:	83 c4 10             	add    $0x10,%esp
8010641c:	85 c0                	test   %eax,%eax
8010641e:	79 07                	jns    80106427 <argfd+0x23>
    return -1;
80106420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106425:	eb 50                	jmp    80106477 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106427:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010642a:	85 c0                	test   %eax,%eax
8010642c:	78 21                	js     8010644f <argfd+0x4b>
8010642e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106431:	83 f8 0f             	cmp    $0xf,%eax
80106434:	7f 19                	jg     8010644f <argfd+0x4b>
80106436:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010643c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010643f:	83 c2 08             	add    $0x8,%edx
80106442:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106446:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010644d:	75 07                	jne    80106456 <argfd+0x52>
    return -1;
8010644f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106454:	eb 21                	jmp    80106477 <argfd+0x73>
  if(pfd)
80106456:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010645a:	74 08                	je     80106464 <argfd+0x60>
    *pfd = fd;
8010645c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010645f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106462:	89 10                	mov    %edx,(%eax)
  if(pf)
80106464:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106468:	74 08                	je     80106472 <argfd+0x6e>
    *pf = f;
8010646a:	8b 45 10             	mov    0x10(%ebp),%eax
8010646d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106470:	89 10                	mov    %edx,(%eax)
  return 0;
80106472:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106477:	c9                   	leave  
80106478:	c3                   	ret    

80106479 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106479:	55                   	push   %ebp
8010647a:	89 e5                	mov    %esp,%ebp
8010647c:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010647f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106486:	eb 30                	jmp    801064b8 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106488:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010648e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106491:	83 c2 08             	add    $0x8,%edx
80106494:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106498:	85 c0                	test   %eax,%eax
8010649a:	75 18                	jne    801064b4 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010649c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801064a5:	8d 4a 08             	lea    0x8(%edx),%ecx
801064a8:	8b 55 08             	mov    0x8(%ebp),%edx
801064ab:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801064af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801064b2:	eb 0f                	jmp    801064c3 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801064b4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801064b8:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801064bc:	7e ca                	jle    80106488 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801064be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064c3:	c9                   	leave  
801064c4:	c3                   	ret    

801064c5 <sys_dup>:

int
sys_dup(void)
{
801064c5:	55                   	push   %ebp
801064c6:	89 e5                	mov    %esp,%ebp
801064c8:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801064cb:	83 ec 04             	sub    $0x4,%esp
801064ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064d1:	50                   	push   %eax
801064d2:	6a 00                	push   $0x0
801064d4:	6a 00                	push   $0x0
801064d6:	e8 29 ff ff ff       	call   80106404 <argfd>
801064db:	83 c4 10             	add    $0x10,%esp
801064de:	85 c0                	test   %eax,%eax
801064e0:	79 07                	jns    801064e9 <sys_dup+0x24>
    return -1;
801064e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e7:	eb 31                	jmp    8010651a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801064e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ec:	83 ec 0c             	sub    $0xc,%esp
801064ef:	50                   	push   %eax
801064f0:	e8 84 ff ff ff       	call   80106479 <fdalloc>
801064f5:	83 c4 10             	add    $0x10,%esp
801064f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064ff:	79 07                	jns    80106508 <sys_dup+0x43>
    return -1;
80106501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106506:	eb 12                	jmp    8010651a <sys_dup+0x55>
  filedup(f);
80106508:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010650b:	83 ec 0c             	sub    $0xc,%esp
8010650e:	50                   	push   %eax
8010650f:	e8 92 ab ff ff       	call   801010a6 <filedup>
80106514:	83 c4 10             	add    $0x10,%esp
  return fd;
80106517:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010651a:	c9                   	leave  
8010651b:	c3                   	ret    

8010651c <sys_read>:

int
sys_read(void)
{
8010651c:	55                   	push   %ebp
8010651d:	89 e5                	mov    %esp,%ebp
8010651f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106522:	83 ec 04             	sub    $0x4,%esp
80106525:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106528:	50                   	push   %eax
80106529:	6a 00                	push   $0x0
8010652b:	6a 00                	push   $0x0
8010652d:	e8 d2 fe ff ff       	call   80106404 <argfd>
80106532:	83 c4 10             	add    $0x10,%esp
80106535:	85 c0                	test   %eax,%eax
80106537:	78 2e                	js     80106567 <sys_read+0x4b>
80106539:	83 ec 08             	sub    $0x8,%esp
8010653c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010653f:	50                   	push   %eax
80106540:	6a 02                	push   $0x2
80106542:	e8 81 fd ff ff       	call   801062c8 <argint>
80106547:	83 c4 10             	add    $0x10,%esp
8010654a:	85 c0                	test   %eax,%eax
8010654c:	78 19                	js     80106567 <sys_read+0x4b>
8010654e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106551:	83 ec 04             	sub    $0x4,%esp
80106554:	50                   	push   %eax
80106555:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106558:	50                   	push   %eax
80106559:	6a 01                	push   $0x1
8010655b:	e8 90 fd ff ff       	call   801062f0 <argptr>
80106560:	83 c4 10             	add    $0x10,%esp
80106563:	85 c0                	test   %eax,%eax
80106565:	79 07                	jns    8010656e <sys_read+0x52>
    return -1;
80106567:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010656c:	eb 17                	jmp    80106585 <sys_read+0x69>
  return fileread(f, p, n);
8010656e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106571:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106574:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106577:	83 ec 04             	sub    $0x4,%esp
8010657a:	51                   	push   %ecx
8010657b:	52                   	push   %edx
8010657c:	50                   	push   %eax
8010657d:	e8 b4 ac ff ff       	call   80101236 <fileread>
80106582:	83 c4 10             	add    $0x10,%esp
}
80106585:	c9                   	leave  
80106586:	c3                   	ret    

80106587 <sys_write>:

int
sys_write(void)
{
80106587:	55                   	push   %ebp
80106588:	89 e5                	mov    %esp,%ebp
8010658a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010658d:	83 ec 04             	sub    $0x4,%esp
80106590:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106593:	50                   	push   %eax
80106594:	6a 00                	push   $0x0
80106596:	6a 00                	push   $0x0
80106598:	e8 67 fe ff ff       	call   80106404 <argfd>
8010659d:	83 c4 10             	add    $0x10,%esp
801065a0:	85 c0                	test   %eax,%eax
801065a2:	78 2e                	js     801065d2 <sys_write+0x4b>
801065a4:	83 ec 08             	sub    $0x8,%esp
801065a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065aa:	50                   	push   %eax
801065ab:	6a 02                	push   $0x2
801065ad:	e8 16 fd ff ff       	call   801062c8 <argint>
801065b2:	83 c4 10             	add    $0x10,%esp
801065b5:	85 c0                	test   %eax,%eax
801065b7:	78 19                	js     801065d2 <sys_write+0x4b>
801065b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065bc:	83 ec 04             	sub    $0x4,%esp
801065bf:	50                   	push   %eax
801065c0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801065c3:	50                   	push   %eax
801065c4:	6a 01                	push   $0x1
801065c6:	e8 25 fd ff ff       	call   801062f0 <argptr>
801065cb:	83 c4 10             	add    $0x10,%esp
801065ce:	85 c0                	test   %eax,%eax
801065d0:	79 07                	jns    801065d9 <sys_write+0x52>
    return -1;
801065d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d7:	eb 17                	jmp    801065f0 <sys_write+0x69>
  return filewrite(f, p, n);
801065d9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801065dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801065df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e2:	83 ec 04             	sub    $0x4,%esp
801065e5:	51                   	push   %ecx
801065e6:	52                   	push   %edx
801065e7:	50                   	push   %eax
801065e8:	e8 01 ad ff ff       	call   801012ee <filewrite>
801065ed:	83 c4 10             	add    $0x10,%esp
}
801065f0:	c9                   	leave  
801065f1:	c3                   	ret    

801065f2 <sys_close>:

int
sys_close(void)
{
801065f2:	55                   	push   %ebp
801065f3:	89 e5                	mov    %esp,%ebp
801065f5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801065f8:	83 ec 04             	sub    $0x4,%esp
801065fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065fe:	50                   	push   %eax
801065ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106602:	50                   	push   %eax
80106603:	6a 00                	push   $0x0
80106605:	e8 fa fd ff ff       	call   80106404 <argfd>
8010660a:	83 c4 10             	add    $0x10,%esp
8010660d:	85 c0                	test   %eax,%eax
8010660f:	79 07                	jns    80106618 <sys_close+0x26>
    return -1;
80106611:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106616:	eb 28                	jmp    80106640 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106618:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010661e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106621:	83 c2 08             	add    $0x8,%edx
80106624:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010662b:	00 
  fileclose(f);
8010662c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010662f:	83 ec 0c             	sub    $0xc,%esp
80106632:	50                   	push   %eax
80106633:	e8 bf aa ff ff       	call   801010f7 <fileclose>
80106638:	83 c4 10             	add    $0x10,%esp
  return 0;
8010663b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106640:	c9                   	leave  
80106641:	c3                   	ret    

80106642 <sys_fstat>:

int
sys_fstat(void)
{
80106642:	55                   	push   %ebp
80106643:	89 e5                	mov    %esp,%ebp
80106645:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106648:	83 ec 04             	sub    $0x4,%esp
8010664b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010664e:	50                   	push   %eax
8010664f:	6a 00                	push   $0x0
80106651:	6a 00                	push   $0x0
80106653:	e8 ac fd ff ff       	call   80106404 <argfd>
80106658:	83 c4 10             	add    $0x10,%esp
8010665b:	85 c0                	test   %eax,%eax
8010665d:	78 17                	js     80106676 <sys_fstat+0x34>
8010665f:	83 ec 04             	sub    $0x4,%esp
80106662:	6a 14                	push   $0x14
80106664:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106667:	50                   	push   %eax
80106668:	6a 01                	push   $0x1
8010666a:	e8 81 fc ff ff       	call   801062f0 <argptr>
8010666f:	83 c4 10             	add    $0x10,%esp
80106672:	85 c0                	test   %eax,%eax
80106674:	79 07                	jns    8010667d <sys_fstat+0x3b>
    return -1;
80106676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010667b:	eb 13                	jmp    80106690 <sys_fstat+0x4e>
  return filestat(f, st);
8010667d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106680:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106683:	83 ec 08             	sub    $0x8,%esp
80106686:	52                   	push   %edx
80106687:	50                   	push   %eax
80106688:	e8 52 ab ff ff       	call   801011df <filestat>
8010668d:	83 c4 10             	add    $0x10,%esp
}
80106690:	c9                   	leave  
80106691:	c3                   	ret    

80106692 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106692:	55                   	push   %ebp
80106693:	89 e5                	mov    %esp,%ebp
80106695:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106698:	83 ec 08             	sub    $0x8,%esp
8010669b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010669e:	50                   	push   %eax
8010669f:	6a 00                	push   $0x0
801066a1:	e8 a7 fc ff ff       	call   8010634d <argstr>
801066a6:	83 c4 10             	add    $0x10,%esp
801066a9:	85 c0                	test   %eax,%eax
801066ab:	78 15                	js     801066c2 <sys_link+0x30>
801066ad:	83 ec 08             	sub    $0x8,%esp
801066b0:	8d 45 dc             	lea    -0x24(%ebp),%eax
801066b3:	50                   	push   %eax
801066b4:	6a 01                	push   $0x1
801066b6:	e8 92 fc ff ff       	call   8010634d <argstr>
801066bb:	83 c4 10             	add    $0x10,%esp
801066be:	85 c0                	test   %eax,%eax
801066c0:	79 0a                	jns    801066cc <sys_link+0x3a>
    return -1;
801066c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066c7:	e9 68 01 00 00       	jmp    80106834 <sys_link+0x1a2>

  begin_op();
801066cc:	e8 22 cf ff ff       	call   801035f3 <begin_op>
  if((ip = namei(old)) == 0){
801066d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801066d4:	83 ec 0c             	sub    $0xc,%esp
801066d7:	50                   	push   %eax
801066d8:	e8 f1 be ff ff       	call   801025ce <namei>
801066dd:	83 c4 10             	add    $0x10,%esp
801066e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066e7:	75 0f                	jne    801066f8 <sys_link+0x66>
    end_op();
801066e9:	e8 91 cf ff ff       	call   8010367f <end_op>
    return -1;
801066ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066f3:	e9 3c 01 00 00       	jmp    80106834 <sys_link+0x1a2>
  }

  ilock(ip);
801066f8:	83 ec 0c             	sub    $0xc,%esp
801066fb:	ff 75 f4             	pushl  -0xc(%ebp)
801066fe:	e8 0d b3 ff ff       	call   80101a10 <ilock>
80106703:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106709:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010670d:	66 83 f8 01          	cmp    $0x1,%ax
80106711:	75 1d                	jne    80106730 <sys_link+0x9e>
    iunlockput(ip);
80106713:	83 ec 0c             	sub    $0xc,%esp
80106716:	ff 75 f4             	pushl  -0xc(%ebp)
80106719:	e8 b2 b5 ff ff       	call   80101cd0 <iunlockput>
8010671e:	83 c4 10             	add    $0x10,%esp
    end_op();
80106721:	e8 59 cf ff ff       	call   8010367f <end_op>
    return -1;
80106726:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010672b:	e9 04 01 00 00       	jmp    80106834 <sys_link+0x1a2>
  }

  ip->nlink++;
80106730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106733:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106737:	83 c0 01             	add    $0x1,%eax
8010673a:	89 c2                	mov    %eax,%edx
8010673c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106743:	83 ec 0c             	sub    $0xc,%esp
80106746:	ff 75 f4             	pushl  -0xc(%ebp)
80106749:	e8 e8 b0 ff ff       	call   80101836 <iupdate>
8010674e:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106751:	83 ec 0c             	sub    $0xc,%esp
80106754:	ff 75 f4             	pushl  -0xc(%ebp)
80106757:	e8 12 b4 ff ff       	call   80101b6e <iunlock>
8010675c:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
8010675f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106762:	83 ec 08             	sub    $0x8,%esp
80106765:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106768:	52                   	push   %edx
80106769:	50                   	push   %eax
8010676a:	e8 7b be ff ff       	call   801025ea <nameiparent>
8010676f:	83 c4 10             	add    $0x10,%esp
80106772:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106775:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106779:	74 71                	je     801067ec <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010677b:	83 ec 0c             	sub    $0xc,%esp
8010677e:	ff 75 f0             	pushl  -0x10(%ebp)
80106781:	e8 8a b2 ff ff       	call   80101a10 <ilock>
80106786:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106789:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010678c:	8b 10                	mov    (%eax),%edx
8010678e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106791:	8b 00                	mov    (%eax),%eax
80106793:	39 c2                	cmp    %eax,%edx
80106795:	75 1d                	jne    801067b4 <sys_link+0x122>
80106797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679a:	8b 40 04             	mov    0x4(%eax),%eax
8010679d:	83 ec 04             	sub    $0x4,%esp
801067a0:	50                   	push   %eax
801067a1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801067a4:	50                   	push   %eax
801067a5:	ff 75 f0             	pushl  -0x10(%ebp)
801067a8:	e8 85 bb ff ff       	call   80102332 <dirlink>
801067ad:	83 c4 10             	add    $0x10,%esp
801067b0:	85 c0                	test   %eax,%eax
801067b2:	79 10                	jns    801067c4 <sys_link+0x132>
    iunlockput(dp);
801067b4:	83 ec 0c             	sub    $0xc,%esp
801067b7:	ff 75 f0             	pushl  -0x10(%ebp)
801067ba:	e8 11 b5 ff ff       	call   80101cd0 <iunlockput>
801067bf:	83 c4 10             	add    $0x10,%esp
    goto bad;
801067c2:	eb 29                	jmp    801067ed <sys_link+0x15b>
  }
  iunlockput(dp);
801067c4:	83 ec 0c             	sub    $0xc,%esp
801067c7:	ff 75 f0             	pushl  -0x10(%ebp)
801067ca:	e8 01 b5 ff ff       	call   80101cd0 <iunlockput>
801067cf:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801067d2:	83 ec 0c             	sub    $0xc,%esp
801067d5:	ff 75 f4             	pushl  -0xc(%ebp)
801067d8:	e8 03 b4 ff ff       	call   80101be0 <iput>
801067dd:	83 c4 10             	add    $0x10,%esp

  end_op();
801067e0:	e8 9a ce ff ff       	call   8010367f <end_op>

  return 0;
801067e5:	b8 00 00 00 00       	mov    $0x0,%eax
801067ea:	eb 48                	jmp    80106834 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801067ec:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
801067ed:	83 ec 0c             	sub    $0xc,%esp
801067f0:	ff 75 f4             	pushl  -0xc(%ebp)
801067f3:	e8 18 b2 ff ff       	call   80101a10 <ilock>
801067f8:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801067fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067fe:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106802:	83 e8 01             	sub    $0x1,%eax
80106805:	89 c2                	mov    %eax,%edx
80106807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010680a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010680e:	83 ec 0c             	sub    $0xc,%esp
80106811:	ff 75 f4             	pushl  -0xc(%ebp)
80106814:	e8 1d b0 ff ff       	call   80101836 <iupdate>
80106819:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010681c:	83 ec 0c             	sub    $0xc,%esp
8010681f:	ff 75 f4             	pushl  -0xc(%ebp)
80106822:	e8 a9 b4 ff ff       	call   80101cd0 <iunlockput>
80106827:	83 c4 10             	add    $0x10,%esp
  end_op();
8010682a:	e8 50 ce ff ff       	call   8010367f <end_op>
  return -1;
8010682f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106834:	c9                   	leave  
80106835:	c3                   	ret    

80106836 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106836:	55                   	push   %ebp
80106837:	89 e5                	mov    %esp,%ebp
80106839:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010683c:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106843:	eb 40                	jmp    80106885 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106848:	6a 10                	push   $0x10
8010684a:	50                   	push   %eax
8010684b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010684e:	50                   	push   %eax
8010684f:	ff 75 08             	pushl  0x8(%ebp)
80106852:	e8 27 b7 ff ff       	call   80101f7e <readi>
80106857:	83 c4 10             	add    $0x10,%esp
8010685a:	83 f8 10             	cmp    $0x10,%eax
8010685d:	74 0d                	je     8010686c <isdirempty+0x36>
      panic("isdirempty: readi");
8010685f:	83 ec 0c             	sub    $0xc,%esp
80106862:	68 e6 9a 10 80       	push   $0x80109ae6
80106867:	e8 fa 9c ff ff       	call   80100566 <panic>
    if(de.inum != 0)
8010686c:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106870:	66 85 c0             	test   %ax,%ax
80106873:	74 07                	je     8010687c <isdirempty+0x46>
      return 0;
80106875:	b8 00 00 00 00       	mov    $0x0,%eax
8010687a:	eb 1b                	jmp    80106897 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010687c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010687f:	83 c0 10             	add    $0x10,%eax
80106882:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106885:	8b 45 08             	mov    0x8(%ebp),%eax
80106888:	8b 50 18             	mov    0x18(%eax),%edx
8010688b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010688e:	39 c2                	cmp    %eax,%edx
80106890:	77 b3                	ja     80106845 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106892:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106897:	c9                   	leave  
80106898:	c3                   	ret    

80106899 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106899:	55                   	push   %ebp
8010689a:	89 e5                	mov    %esp,%ebp
8010689c:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010689f:	83 ec 08             	sub    $0x8,%esp
801068a2:	8d 45 cc             	lea    -0x34(%ebp),%eax
801068a5:	50                   	push   %eax
801068a6:	6a 00                	push   $0x0
801068a8:	e8 a0 fa ff ff       	call   8010634d <argstr>
801068ad:	83 c4 10             	add    $0x10,%esp
801068b0:	85 c0                	test   %eax,%eax
801068b2:	79 0a                	jns    801068be <sys_unlink+0x25>
    return -1;
801068b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b9:	e9 bc 01 00 00       	jmp    80106a7a <sys_unlink+0x1e1>

  begin_op();
801068be:	e8 30 cd ff ff       	call   801035f3 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801068c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801068c6:	83 ec 08             	sub    $0x8,%esp
801068c9:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801068cc:	52                   	push   %edx
801068cd:	50                   	push   %eax
801068ce:	e8 17 bd ff ff       	call   801025ea <nameiparent>
801068d3:	83 c4 10             	add    $0x10,%esp
801068d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068dd:	75 0f                	jne    801068ee <sys_unlink+0x55>
    end_op();
801068df:	e8 9b cd ff ff       	call   8010367f <end_op>
    return -1;
801068e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e9:	e9 8c 01 00 00       	jmp    80106a7a <sys_unlink+0x1e1>
  }

  ilock(dp);
801068ee:	83 ec 0c             	sub    $0xc,%esp
801068f1:	ff 75 f4             	pushl  -0xc(%ebp)
801068f4:	e8 17 b1 ff ff       	call   80101a10 <ilock>
801068f9:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801068fc:	83 ec 08             	sub    $0x8,%esp
801068ff:	68 f8 9a 10 80       	push   $0x80109af8
80106904:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106907:	50                   	push   %eax
80106908:	e8 50 b9 ff ff       	call   8010225d <namecmp>
8010690d:	83 c4 10             	add    $0x10,%esp
80106910:	85 c0                	test   %eax,%eax
80106912:	0f 84 4a 01 00 00    	je     80106a62 <sys_unlink+0x1c9>
80106918:	83 ec 08             	sub    $0x8,%esp
8010691b:	68 fa 9a 10 80       	push   $0x80109afa
80106920:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106923:	50                   	push   %eax
80106924:	e8 34 b9 ff ff       	call   8010225d <namecmp>
80106929:	83 c4 10             	add    $0x10,%esp
8010692c:	85 c0                	test   %eax,%eax
8010692e:	0f 84 2e 01 00 00    	je     80106a62 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106934:	83 ec 04             	sub    $0x4,%esp
80106937:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010693a:	50                   	push   %eax
8010693b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010693e:	50                   	push   %eax
8010693f:	ff 75 f4             	pushl  -0xc(%ebp)
80106942:	e8 31 b9 ff ff       	call   80102278 <dirlookup>
80106947:	83 c4 10             	add    $0x10,%esp
8010694a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010694d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106951:	0f 84 0a 01 00 00    	je     80106a61 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106957:	83 ec 0c             	sub    $0xc,%esp
8010695a:	ff 75 f0             	pushl  -0x10(%ebp)
8010695d:	e8 ae b0 ff ff       	call   80101a10 <ilock>
80106962:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106965:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106968:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010696c:	66 85 c0             	test   %ax,%ax
8010696f:	7f 0d                	jg     8010697e <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106971:	83 ec 0c             	sub    $0xc,%esp
80106974:	68 fd 9a 10 80       	push   $0x80109afd
80106979:	e8 e8 9b ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010697e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106981:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106985:	66 83 f8 01          	cmp    $0x1,%ax
80106989:	75 25                	jne    801069b0 <sys_unlink+0x117>
8010698b:	83 ec 0c             	sub    $0xc,%esp
8010698e:	ff 75 f0             	pushl  -0x10(%ebp)
80106991:	e8 a0 fe ff ff       	call   80106836 <isdirempty>
80106996:	83 c4 10             	add    $0x10,%esp
80106999:	85 c0                	test   %eax,%eax
8010699b:	75 13                	jne    801069b0 <sys_unlink+0x117>
    iunlockput(ip);
8010699d:	83 ec 0c             	sub    $0xc,%esp
801069a0:	ff 75 f0             	pushl  -0x10(%ebp)
801069a3:	e8 28 b3 ff ff       	call   80101cd0 <iunlockput>
801069a8:	83 c4 10             	add    $0x10,%esp
    goto bad;
801069ab:	e9 b2 00 00 00       	jmp    80106a62 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801069b0:	83 ec 04             	sub    $0x4,%esp
801069b3:	6a 10                	push   $0x10
801069b5:	6a 00                	push   $0x0
801069b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801069ba:	50                   	push   %eax
801069bb:	e8 e3 f5 ff ff       	call   80105fa3 <memset>
801069c0:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801069c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
801069c6:	6a 10                	push   $0x10
801069c8:	50                   	push   %eax
801069c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801069cc:	50                   	push   %eax
801069cd:	ff 75 f4             	pushl  -0xc(%ebp)
801069d0:	e8 00 b7 ff ff       	call   801020d5 <writei>
801069d5:	83 c4 10             	add    $0x10,%esp
801069d8:	83 f8 10             	cmp    $0x10,%eax
801069db:	74 0d                	je     801069ea <sys_unlink+0x151>
    panic("unlink: writei");
801069dd:	83 ec 0c             	sub    $0xc,%esp
801069e0:	68 0f 9b 10 80       	push   $0x80109b0f
801069e5:	e8 7c 9b ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801069ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069ed:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801069f1:	66 83 f8 01          	cmp    $0x1,%ax
801069f5:	75 21                	jne    80106a18 <sys_unlink+0x17f>
    dp->nlink--;
801069f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069fa:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801069fe:	83 e8 01             	sub    $0x1,%eax
80106a01:	89 c2                	mov    %eax,%edx
80106a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a06:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106a0a:	83 ec 0c             	sub    $0xc,%esp
80106a0d:	ff 75 f4             	pushl  -0xc(%ebp)
80106a10:	e8 21 ae ff ff       	call   80101836 <iupdate>
80106a15:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106a18:	83 ec 0c             	sub    $0xc,%esp
80106a1b:	ff 75 f4             	pushl  -0xc(%ebp)
80106a1e:	e8 ad b2 ff ff       	call   80101cd0 <iunlockput>
80106a23:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a29:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106a2d:	83 e8 01             	sub    $0x1,%eax
80106a30:	89 c2                	mov    %eax,%edx
80106a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a35:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106a39:	83 ec 0c             	sub    $0xc,%esp
80106a3c:	ff 75 f0             	pushl  -0x10(%ebp)
80106a3f:	e8 f2 ad ff ff       	call   80101836 <iupdate>
80106a44:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106a47:	83 ec 0c             	sub    $0xc,%esp
80106a4a:	ff 75 f0             	pushl  -0x10(%ebp)
80106a4d:	e8 7e b2 ff ff       	call   80101cd0 <iunlockput>
80106a52:	83 c4 10             	add    $0x10,%esp

  end_op();
80106a55:	e8 25 cc ff ff       	call   8010367f <end_op>

  return 0;
80106a5a:	b8 00 00 00 00       	mov    $0x0,%eax
80106a5f:	eb 19                	jmp    80106a7a <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106a61:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106a62:	83 ec 0c             	sub    $0xc,%esp
80106a65:	ff 75 f4             	pushl  -0xc(%ebp)
80106a68:	e8 63 b2 ff ff       	call   80101cd0 <iunlockput>
80106a6d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106a70:	e8 0a cc ff ff       	call   8010367f <end_op>
  return -1;
80106a75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a7a:	c9                   	leave  
80106a7b:	c3                   	ret    

80106a7c <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106a7c:	55                   	push   %ebp
80106a7d:	89 e5                	mov    %esp,%ebp
80106a7f:	83 ec 38             	sub    $0x38,%esp
80106a82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a85:	8b 55 10             	mov    0x10(%ebp),%edx
80106a88:	8b 45 14             	mov    0x14(%ebp),%eax
80106a8b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106a8f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106a93:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106a97:	83 ec 08             	sub    $0x8,%esp
80106a9a:	8d 45 de             	lea    -0x22(%ebp),%eax
80106a9d:	50                   	push   %eax
80106a9e:	ff 75 08             	pushl  0x8(%ebp)
80106aa1:	e8 44 bb ff ff       	call   801025ea <nameiparent>
80106aa6:	83 c4 10             	add    $0x10,%esp
80106aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106aac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ab0:	75 0a                	jne    80106abc <create+0x40>
    return 0;
80106ab2:	b8 00 00 00 00       	mov    $0x0,%eax
80106ab7:	e9 90 01 00 00       	jmp    80106c4c <create+0x1d0>
  ilock(dp);
80106abc:	83 ec 0c             	sub    $0xc,%esp
80106abf:	ff 75 f4             	pushl  -0xc(%ebp)
80106ac2:	e8 49 af ff ff       	call   80101a10 <ilock>
80106ac7:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106aca:	83 ec 04             	sub    $0x4,%esp
80106acd:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ad0:	50                   	push   %eax
80106ad1:	8d 45 de             	lea    -0x22(%ebp),%eax
80106ad4:	50                   	push   %eax
80106ad5:	ff 75 f4             	pushl  -0xc(%ebp)
80106ad8:	e8 9b b7 ff ff       	call   80102278 <dirlookup>
80106add:	83 c4 10             	add    $0x10,%esp
80106ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106ae3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ae7:	74 50                	je     80106b39 <create+0xbd>
    iunlockput(dp);
80106ae9:	83 ec 0c             	sub    $0xc,%esp
80106aec:	ff 75 f4             	pushl  -0xc(%ebp)
80106aef:	e8 dc b1 ff ff       	call   80101cd0 <iunlockput>
80106af4:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106af7:	83 ec 0c             	sub    $0xc,%esp
80106afa:	ff 75 f0             	pushl  -0x10(%ebp)
80106afd:	e8 0e af ff ff       	call   80101a10 <ilock>
80106b02:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106b05:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106b0a:	75 15                	jne    80106b21 <create+0xa5>
80106b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b0f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106b13:	66 83 f8 02          	cmp    $0x2,%ax
80106b17:	75 08                	jne    80106b21 <create+0xa5>
      return ip;
80106b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b1c:	e9 2b 01 00 00       	jmp    80106c4c <create+0x1d0>
    iunlockput(ip);
80106b21:	83 ec 0c             	sub    $0xc,%esp
80106b24:	ff 75 f0             	pushl  -0x10(%ebp)
80106b27:	e8 a4 b1 ff ff       	call   80101cd0 <iunlockput>
80106b2c:	83 c4 10             	add    $0x10,%esp
    return 0;
80106b2f:	b8 00 00 00 00       	mov    $0x0,%eax
80106b34:	e9 13 01 00 00       	jmp    80106c4c <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106b39:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b40:	8b 00                	mov    (%eax),%eax
80106b42:	83 ec 08             	sub    $0x8,%esp
80106b45:	52                   	push   %edx
80106b46:	50                   	push   %eax
80106b47:	e8 13 ac ff ff       	call   8010175f <ialloc>
80106b4c:	83 c4 10             	add    $0x10,%esp
80106b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106b52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106b56:	75 0d                	jne    80106b65 <create+0xe9>
    panic("create: ialloc");
80106b58:	83 ec 0c             	sub    $0xc,%esp
80106b5b:	68 1e 9b 10 80       	push   $0x80109b1e
80106b60:	e8 01 9a ff ff       	call   80100566 <panic>

  ilock(ip);
80106b65:	83 ec 0c             	sub    $0xc,%esp
80106b68:	ff 75 f0             	pushl  -0x10(%ebp)
80106b6b:	e8 a0 ae ff ff       	call   80101a10 <ilock>
80106b70:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b76:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106b7a:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b81:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106b85:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b8c:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106b92:	83 ec 0c             	sub    $0xc,%esp
80106b95:	ff 75 f0             	pushl  -0x10(%ebp)
80106b98:	e8 99 ac ff ff       	call   80101836 <iupdate>
80106b9d:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106ba0:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106ba5:	75 6a                	jne    80106c11 <create+0x195>
    dp->nlink++;  // for ".."
80106ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106baa:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106bae:	83 c0 01             	add    $0x1,%eax
80106bb1:	89 c2                	mov    %eax,%edx
80106bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb6:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	ff 75 f4             	pushl  -0xc(%ebp)
80106bc0:	e8 71 ac ff ff       	call   80101836 <iupdate>
80106bc5:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bcb:	8b 40 04             	mov    0x4(%eax),%eax
80106bce:	83 ec 04             	sub    $0x4,%esp
80106bd1:	50                   	push   %eax
80106bd2:	68 f8 9a 10 80       	push   $0x80109af8
80106bd7:	ff 75 f0             	pushl  -0x10(%ebp)
80106bda:	e8 53 b7 ff ff       	call   80102332 <dirlink>
80106bdf:	83 c4 10             	add    $0x10,%esp
80106be2:	85 c0                	test   %eax,%eax
80106be4:	78 1e                	js     80106c04 <create+0x188>
80106be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106be9:	8b 40 04             	mov    0x4(%eax),%eax
80106bec:	83 ec 04             	sub    $0x4,%esp
80106bef:	50                   	push   %eax
80106bf0:	68 fa 9a 10 80       	push   $0x80109afa
80106bf5:	ff 75 f0             	pushl  -0x10(%ebp)
80106bf8:	e8 35 b7 ff ff       	call   80102332 <dirlink>
80106bfd:	83 c4 10             	add    $0x10,%esp
80106c00:	85 c0                	test   %eax,%eax
80106c02:	79 0d                	jns    80106c11 <create+0x195>
      panic("create dots");
80106c04:	83 ec 0c             	sub    $0xc,%esp
80106c07:	68 2d 9b 10 80       	push   $0x80109b2d
80106c0c:	e8 55 99 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c14:	8b 40 04             	mov    0x4(%eax),%eax
80106c17:	83 ec 04             	sub    $0x4,%esp
80106c1a:	50                   	push   %eax
80106c1b:	8d 45 de             	lea    -0x22(%ebp),%eax
80106c1e:	50                   	push   %eax
80106c1f:	ff 75 f4             	pushl  -0xc(%ebp)
80106c22:	e8 0b b7 ff ff       	call   80102332 <dirlink>
80106c27:	83 c4 10             	add    $0x10,%esp
80106c2a:	85 c0                	test   %eax,%eax
80106c2c:	79 0d                	jns    80106c3b <create+0x1bf>
    panic("create: dirlink");
80106c2e:	83 ec 0c             	sub    $0xc,%esp
80106c31:	68 39 9b 10 80       	push   $0x80109b39
80106c36:	e8 2b 99 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80106c3b:	83 ec 0c             	sub    $0xc,%esp
80106c3e:	ff 75 f4             	pushl  -0xc(%ebp)
80106c41:	e8 8a b0 ff ff       	call   80101cd0 <iunlockput>
80106c46:	83 c4 10             	add    $0x10,%esp

  return ip;
80106c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106c4c:	c9                   	leave  
80106c4d:	c3                   	ret    

80106c4e <sys_open>:

int
sys_open(void)
{
80106c4e:	55                   	push   %ebp
80106c4f:	89 e5                	mov    %esp,%ebp
80106c51:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106c54:	83 ec 08             	sub    $0x8,%esp
80106c57:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106c5a:	50                   	push   %eax
80106c5b:	6a 00                	push   $0x0
80106c5d:	e8 eb f6 ff ff       	call   8010634d <argstr>
80106c62:	83 c4 10             	add    $0x10,%esp
80106c65:	85 c0                	test   %eax,%eax
80106c67:	78 15                	js     80106c7e <sys_open+0x30>
80106c69:	83 ec 08             	sub    $0x8,%esp
80106c6c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106c6f:	50                   	push   %eax
80106c70:	6a 01                	push   $0x1
80106c72:	e8 51 f6 ff ff       	call   801062c8 <argint>
80106c77:	83 c4 10             	add    $0x10,%esp
80106c7a:	85 c0                	test   %eax,%eax
80106c7c:	79 0a                	jns    80106c88 <sys_open+0x3a>
    return -1;
80106c7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c83:	e9 61 01 00 00       	jmp    80106de9 <sys_open+0x19b>

  begin_op();
80106c88:	e8 66 c9 ff ff       	call   801035f3 <begin_op>

  if(omode & O_CREATE){
80106c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c90:	25 00 02 00 00       	and    $0x200,%eax
80106c95:	85 c0                	test   %eax,%eax
80106c97:	74 2a                	je     80106cc3 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106c99:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106c9c:	6a 00                	push   $0x0
80106c9e:	6a 00                	push   $0x0
80106ca0:	6a 02                	push   $0x2
80106ca2:	50                   	push   %eax
80106ca3:	e8 d4 fd ff ff       	call   80106a7c <create>
80106ca8:	83 c4 10             	add    $0x10,%esp
80106cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106cae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106cb2:	75 75                	jne    80106d29 <sys_open+0xdb>
      end_op();
80106cb4:	e8 c6 c9 ff ff       	call   8010367f <end_op>
      return -1;
80106cb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cbe:	e9 26 01 00 00       	jmp    80106de9 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106cc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106cc6:	83 ec 0c             	sub    $0xc,%esp
80106cc9:	50                   	push   %eax
80106cca:	e8 ff b8 ff ff       	call   801025ce <namei>
80106ccf:	83 c4 10             	add    $0x10,%esp
80106cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106cd9:	75 0f                	jne    80106cea <sys_open+0x9c>
      end_op();
80106cdb:	e8 9f c9 ff ff       	call   8010367f <end_op>
      return -1;
80106ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ce5:	e9 ff 00 00 00       	jmp    80106de9 <sys_open+0x19b>
    }
    ilock(ip);
80106cea:	83 ec 0c             	sub    $0xc,%esp
80106ced:	ff 75 f4             	pushl  -0xc(%ebp)
80106cf0:	e8 1b ad ff ff       	call   80101a10 <ilock>
80106cf5:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cfb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106cff:	66 83 f8 01          	cmp    $0x1,%ax
80106d03:	75 24                	jne    80106d29 <sys_open+0xdb>
80106d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d08:	85 c0                	test   %eax,%eax
80106d0a:	74 1d                	je     80106d29 <sys_open+0xdb>
      iunlockput(ip);
80106d0c:	83 ec 0c             	sub    $0xc,%esp
80106d0f:	ff 75 f4             	pushl  -0xc(%ebp)
80106d12:	e8 b9 af ff ff       	call   80101cd0 <iunlockput>
80106d17:	83 c4 10             	add    $0x10,%esp
      end_op();
80106d1a:	e8 60 c9 ff ff       	call   8010367f <end_op>
      return -1;
80106d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d24:	e9 c0 00 00 00       	jmp    80106de9 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106d29:	e8 0b a3 ff ff       	call   80101039 <filealloc>
80106d2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106d31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d35:	74 17                	je     80106d4e <sys_open+0x100>
80106d37:	83 ec 0c             	sub    $0xc,%esp
80106d3a:	ff 75 f0             	pushl  -0x10(%ebp)
80106d3d:	e8 37 f7 ff ff       	call   80106479 <fdalloc>
80106d42:	83 c4 10             	add    $0x10,%esp
80106d45:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106d48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106d4c:	79 2e                	jns    80106d7c <sys_open+0x12e>
    if(f)
80106d4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d52:	74 0e                	je     80106d62 <sys_open+0x114>
      fileclose(f);
80106d54:	83 ec 0c             	sub    $0xc,%esp
80106d57:	ff 75 f0             	pushl  -0x10(%ebp)
80106d5a:	e8 98 a3 ff ff       	call   801010f7 <fileclose>
80106d5f:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106d62:	83 ec 0c             	sub    $0xc,%esp
80106d65:	ff 75 f4             	pushl  -0xc(%ebp)
80106d68:	e8 63 af ff ff       	call   80101cd0 <iunlockput>
80106d6d:	83 c4 10             	add    $0x10,%esp
    end_op();
80106d70:	e8 0a c9 ff ff       	call   8010367f <end_op>
    return -1;
80106d75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d7a:	eb 6d                	jmp    80106de9 <sys_open+0x19b>
  }
  iunlock(ip);
80106d7c:	83 ec 0c             	sub    $0xc,%esp
80106d7f:	ff 75 f4             	pushl  -0xc(%ebp)
80106d82:	e8 e7 ad ff ff       	call   80101b6e <iunlock>
80106d87:	83 c4 10             	add    $0x10,%esp
  end_op();
80106d8a:	e8 f0 c8 ff ff       	call   8010367f <end_op>

  f->type = FD_INODE;
80106d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d92:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106d9e:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106da4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dae:	83 e0 01             	and    $0x1,%eax
80106db1:	85 c0                	test   %eax,%eax
80106db3:	0f 94 c0             	sete   %al
80106db6:	89 c2                	mov    %eax,%edx
80106db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106dbb:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106dbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dc1:	83 e0 01             	and    $0x1,%eax
80106dc4:	85 c0                	test   %eax,%eax
80106dc6:	75 0a                	jne    80106dd2 <sys_open+0x184>
80106dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dcb:	83 e0 02             	and    $0x2,%eax
80106dce:	85 c0                	test   %eax,%eax
80106dd0:	74 07                	je     80106dd9 <sys_open+0x18b>
80106dd2:	b8 01 00 00 00       	mov    $0x1,%eax
80106dd7:	eb 05                	jmp    80106dde <sys_open+0x190>
80106dd9:	b8 00 00 00 00       	mov    $0x0,%eax
80106dde:	89 c2                	mov    %eax,%edx
80106de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106de3:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106de9:	c9                   	leave  
80106dea:	c3                   	ret    

80106deb <sys_mkdir>:

int
sys_mkdir(void)
{
80106deb:	55                   	push   %ebp
80106dec:	89 e5                	mov    %esp,%ebp
80106dee:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106df1:	e8 fd c7 ff ff       	call   801035f3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106df6:	83 ec 08             	sub    $0x8,%esp
80106df9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106dfc:	50                   	push   %eax
80106dfd:	6a 00                	push   $0x0
80106dff:	e8 49 f5 ff ff       	call   8010634d <argstr>
80106e04:	83 c4 10             	add    $0x10,%esp
80106e07:	85 c0                	test   %eax,%eax
80106e09:	78 1b                	js     80106e26 <sys_mkdir+0x3b>
80106e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e0e:	6a 00                	push   $0x0
80106e10:	6a 00                	push   $0x0
80106e12:	6a 01                	push   $0x1
80106e14:	50                   	push   %eax
80106e15:	e8 62 fc ff ff       	call   80106a7c <create>
80106e1a:	83 c4 10             	add    $0x10,%esp
80106e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e24:	75 0c                	jne    80106e32 <sys_mkdir+0x47>
    end_op();
80106e26:	e8 54 c8 ff ff       	call   8010367f <end_op>
    return -1;
80106e2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e30:	eb 18                	jmp    80106e4a <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106e32:	83 ec 0c             	sub    $0xc,%esp
80106e35:	ff 75 f4             	pushl  -0xc(%ebp)
80106e38:	e8 93 ae ff ff       	call   80101cd0 <iunlockput>
80106e3d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106e40:	e8 3a c8 ff ff       	call   8010367f <end_op>
  return 0;
80106e45:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e4a:	c9                   	leave  
80106e4b:	c3                   	ret    

80106e4c <sys_mknod>:

int
sys_mknod(void)
{
80106e4c:	55                   	push   %ebp
80106e4d:	89 e5                	mov    %esp,%ebp
80106e4f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106e52:	e8 9c c7 ff ff       	call   801035f3 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106e57:	83 ec 08             	sub    $0x8,%esp
80106e5a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106e5d:	50                   	push   %eax
80106e5e:	6a 00                	push   $0x0
80106e60:	e8 e8 f4 ff ff       	call   8010634d <argstr>
80106e65:	83 c4 10             	add    $0x10,%esp
80106e68:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e6f:	78 4f                	js     80106ec0 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106e71:	83 ec 08             	sub    $0x8,%esp
80106e74:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106e77:	50                   	push   %eax
80106e78:	6a 01                	push   $0x1
80106e7a:	e8 49 f4 ff ff       	call   801062c8 <argint>
80106e7f:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106e82:	85 c0                	test   %eax,%eax
80106e84:	78 3a                	js     80106ec0 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106e86:	83 ec 08             	sub    $0x8,%esp
80106e89:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106e8c:	50                   	push   %eax
80106e8d:	6a 02                	push   $0x2
80106e8f:	e8 34 f4 ff ff       	call   801062c8 <argint>
80106e94:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106e97:	85 c0                	test   %eax,%eax
80106e99:	78 25                	js     80106ec0 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e9e:	0f bf c8             	movswl %ax,%ecx
80106ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106ea4:	0f bf d0             	movswl %ax,%edx
80106ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106eaa:	51                   	push   %ecx
80106eab:	52                   	push   %edx
80106eac:	6a 03                	push   $0x3
80106eae:	50                   	push   %eax
80106eaf:	e8 c8 fb ff ff       	call   80106a7c <create>
80106eb4:	83 c4 10             	add    $0x10,%esp
80106eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106eba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ebe:	75 0c                	jne    80106ecc <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106ec0:	e8 ba c7 ff ff       	call   8010367f <end_op>
    return -1;
80106ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eca:	eb 18                	jmp    80106ee4 <sys_mknod+0x98>
  }
  iunlockput(ip);
80106ecc:	83 ec 0c             	sub    $0xc,%esp
80106ecf:	ff 75 f0             	pushl  -0x10(%ebp)
80106ed2:	e8 f9 ad ff ff       	call   80101cd0 <iunlockput>
80106ed7:	83 c4 10             	add    $0x10,%esp
  end_op();
80106eda:	e8 a0 c7 ff ff       	call   8010367f <end_op>
  return 0;
80106edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ee4:	c9                   	leave  
80106ee5:	c3                   	ret    

80106ee6 <sys_chdir>:

int
sys_chdir(void)
{
80106ee6:	55                   	push   %ebp
80106ee7:	89 e5                	mov    %esp,%ebp
80106ee9:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106eec:	e8 02 c7 ff ff       	call   801035f3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106ef1:	83 ec 08             	sub    $0x8,%esp
80106ef4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ef7:	50                   	push   %eax
80106ef8:	6a 00                	push   $0x0
80106efa:	e8 4e f4 ff ff       	call   8010634d <argstr>
80106eff:	83 c4 10             	add    $0x10,%esp
80106f02:	85 c0                	test   %eax,%eax
80106f04:	78 18                	js     80106f1e <sys_chdir+0x38>
80106f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f09:	83 ec 0c             	sub    $0xc,%esp
80106f0c:	50                   	push   %eax
80106f0d:	e8 bc b6 ff ff       	call   801025ce <namei>
80106f12:	83 c4 10             	add    $0x10,%esp
80106f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106f18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106f1c:	75 0c                	jne    80106f2a <sys_chdir+0x44>
    end_op();
80106f1e:	e8 5c c7 ff ff       	call   8010367f <end_op>
    return -1;
80106f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f28:	eb 6e                	jmp    80106f98 <sys_chdir+0xb2>
  }
  ilock(ip);
80106f2a:	83 ec 0c             	sub    $0xc,%esp
80106f2d:	ff 75 f4             	pushl  -0xc(%ebp)
80106f30:	e8 db aa ff ff       	call   80101a10 <ilock>
80106f35:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f3b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106f3f:	66 83 f8 01          	cmp    $0x1,%ax
80106f43:	74 1a                	je     80106f5f <sys_chdir+0x79>
    iunlockput(ip);
80106f45:	83 ec 0c             	sub    $0xc,%esp
80106f48:	ff 75 f4             	pushl  -0xc(%ebp)
80106f4b:	e8 80 ad ff ff       	call   80101cd0 <iunlockput>
80106f50:	83 c4 10             	add    $0x10,%esp
    end_op();
80106f53:	e8 27 c7 ff ff       	call   8010367f <end_op>
    return -1;
80106f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f5d:	eb 39                	jmp    80106f98 <sys_chdir+0xb2>
  }
  iunlock(ip);
80106f5f:	83 ec 0c             	sub    $0xc,%esp
80106f62:	ff 75 f4             	pushl  -0xc(%ebp)
80106f65:	e8 04 ac ff ff       	call   80101b6e <iunlock>
80106f6a:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106f6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f73:	8b 40 68             	mov    0x68(%eax),%eax
80106f76:	83 ec 0c             	sub    $0xc,%esp
80106f79:	50                   	push   %eax
80106f7a:	e8 61 ac ff ff       	call   80101be0 <iput>
80106f7f:	83 c4 10             	add    $0x10,%esp
  end_op();
80106f82:	e8 f8 c6 ff ff       	call   8010367f <end_op>
  proc->cwd = ip;
80106f87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f90:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106f93:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106f98:	c9                   	leave  
80106f99:	c3                   	ret    

80106f9a <sys_exec>:

int
sys_exec(void)
{
80106f9a:	55                   	push   %ebp
80106f9b:	89 e5                	mov    %esp,%ebp
80106f9d:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106fa3:	83 ec 08             	sub    $0x8,%esp
80106fa6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fa9:	50                   	push   %eax
80106faa:	6a 00                	push   $0x0
80106fac:	e8 9c f3 ff ff       	call   8010634d <argstr>
80106fb1:	83 c4 10             	add    $0x10,%esp
80106fb4:	85 c0                	test   %eax,%eax
80106fb6:	78 18                	js     80106fd0 <sys_exec+0x36>
80106fb8:	83 ec 08             	sub    $0x8,%esp
80106fbb:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106fc1:	50                   	push   %eax
80106fc2:	6a 01                	push   $0x1
80106fc4:	e8 ff f2 ff ff       	call   801062c8 <argint>
80106fc9:	83 c4 10             	add    $0x10,%esp
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	79 0a                	jns    80106fda <sys_exec+0x40>
    return -1;
80106fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fd5:	e9 c6 00 00 00       	jmp    801070a0 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106fda:	83 ec 04             	sub    $0x4,%esp
80106fdd:	68 80 00 00 00       	push   $0x80
80106fe2:	6a 00                	push   $0x0
80106fe4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106fea:	50                   	push   %eax
80106feb:	e8 b3 ef ff ff       	call   80105fa3 <memset>
80106ff0:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106ff3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ffd:	83 f8 1f             	cmp    $0x1f,%eax
80107000:	76 0a                	jbe    8010700c <sys_exec+0x72>
      return -1;
80107002:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107007:	e9 94 00 00 00       	jmp    801070a0 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010700c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010700f:	c1 e0 02             	shl    $0x2,%eax
80107012:	89 c2                	mov    %eax,%edx
80107014:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010701a:	01 c2                	add    %eax,%edx
8010701c:	83 ec 08             	sub    $0x8,%esp
8010701f:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107025:	50                   	push   %eax
80107026:	52                   	push   %edx
80107027:	e8 00 f2 ff ff       	call   8010622c <fetchint>
8010702c:	83 c4 10             	add    $0x10,%esp
8010702f:	85 c0                	test   %eax,%eax
80107031:	79 07                	jns    8010703a <sys_exec+0xa0>
      return -1;
80107033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107038:	eb 66                	jmp    801070a0 <sys_exec+0x106>
    if(uarg == 0){
8010703a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107040:	85 c0                	test   %eax,%eax
80107042:	75 27                	jne    8010706b <sys_exec+0xd1>
      argv[i] = 0;
80107044:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107047:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010704e:	00 00 00 00 
      break;
80107052:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107053:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107056:	83 ec 08             	sub    $0x8,%esp
80107059:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010705f:	52                   	push   %edx
80107060:	50                   	push   %eax
80107061:	e8 b1 9b ff ff       	call   80100c17 <exec>
80107066:	83 c4 10             	add    $0x10,%esp
80107069:	eb 35                	jmp    801070a0 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010706b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107071:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107074:	c1 e2 02             	shl    $0x2,%edx
80107077:	01 c2                	add    %eax,%edx
80107079:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010707f:	83 ec 08             	sub    $0x8,%esp
80107082:	52                   	push   %edx
80107083:	50                   	push   %eax
80107084:	e8 dd f1 ff ff       	call   80106266 <fetchstr>
80107089:	83 c4 10             	add    $0x10,%esp
8010708c:	85 c0                	test   %eax,%eax
8010708e:	79 07                	jns    80107097 <sys_exec+0xfd>
      return -1;
80107090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107095:	eb 09                	jmp    801070a0 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107097:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010709b:	e9 5a ff ff ff       	jmp    80106ffa <sys_exec+0x60>
  return exec(path, argv);
}
801070a0:	c9                   	leave  
801070a1:	c3                   	ret    

801070a2 <sys_pipe>:

int
sys_pipe(void)
{
801070a2:	55                   	push   %ebp
801070a3:	89 e5                	mov    %esp,%ebp
801070a5:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801070a8:	83 ec 04             	sub    $0x4,%esp
801070ab:	6a 08                	push   $0x8
801070ad:	8d 45 ec             	lea    -0x14(%ebp),%eax
801070b0:	50                   	push   %eax
801070b1:	6a 00                	push   $0x0
801070b3:	e8 38 f2 ff ff       	call   801062f0 <argptr>
801070b8:	83 c4 10             	add    $0x10,%esp
801070bb:	85 c0                	test   %eax,%eax
801070bd:	79 0a                	jns    801070c9 <sys_pipe+0x27>
    return -1;
801070bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070c4:	e9 af 00 00 00       	jmp    80107178 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801070c9:	83 ec 08             	sub    $0x8,%esp
801070cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801070cf:	50                   	push   %eax
801070d0:	8d 45 e8             	lea    -0x18(%ebp),%eax
801070d3:	50                   	push   %eax
801070d4:	e8 0e d0 ff ff       	call   801040e7 <pipealloc>
801070d9:	83 c4 10             	add    $0x10,%esp
801070dc:	85 c0                	test   %eax,%eax
801070de:	79 0a                	jns    801070ea <sys_pipe+0x48>
    return -1;
801070e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070e5:	e9 8e 00 00 00       	jmp    80107178 <sys_pipe+0xd6>
  fd0 = -1;
801070ea:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801070f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801070f4:	83 ec 0c             	sub    $0xc,%esp
801070f7:	50                   	push   %eax
801070f8:	e8 7c f3 ff ff       	call   80106479 <fdalloc>
801070fd:	83 c4 10             	add    $0x10,%esp
80107100:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107103:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107107:	78 18                	js     80107121 <sys_pipe+0x7f>
80107109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010710c:	83 ec 0c             	sub    $0xc,%esp
8010710f:	50                   	push   %eax
80107110:	e8 64 f3 ff ff       	call   80106479 <fdalloc>
80107115:	83 c4 10             	add    $0x10,%esp
80107118:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010711b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010711f:	79 3f                	jns    80107160 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107121:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107125:	78 14                	js     8010713b <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107127:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010712d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107130:	83 c2 08             	add    $0x8,%edx
80107133:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010713a:	00 
    fileclose(rf);
8010713b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010713e:	83 ec 0c             	sub    $0xc,%esp
80107141:	50                   	push   %eax
80107142:	e8 b0 9f ff ff       	call   801010f7 <fileclose>
80107147:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010714a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010714d:	83 ec 0c             	sub    $0xc,%esp
80107150:	50                   	push   %eax
80107151:	e8 a1 9f ff ff       	call   801010f7 <fileclose>
80107156:	83 c4 10             	add    $0x10,%esp
    return -1;
80107159:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010715e:	eb 18                	jmp    80107178 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107160:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107163:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107166:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107168:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010716b:	8d 50 04             	lea    0x4(%eax),%edx
8010716e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107171:	89 02                	mov    %eax,(%edx)
  return 0;
80107173:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107178:	c9                   	leave  
80107179:	c3                   	ret    

8010717a <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
8010717a:	55                   	push   %ebp
8010717b:	89 e5                	mov    %esp,%ebp
8010717d:	83 ec 08             	sub    $0x8,%esp
80107180:	8b 55 08             	mov    0x8(%ebp),%edx
80107183:	8b 45 0c             	mov    0xc(%ebp),%eax
80107186:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010718a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010718e:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107192:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107196:	66 ef                	out    %ax,(%dx)
}
80107198:	90                   	nop
80107199:	c9                   	leave  
8010719a:	c3                   	ret    

8010719b <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
8010719b:	55                   	push   %ebp
8010719c:	89 e5                	mov    %esp,%ebp
8010719e:	83 ec 08             	sub    $0x8,%esp
  return fork();
801071a1:	e8 a0 d6 ff ff       	call   80104846 <fork>
}
801071a6:	c9                   	leave  
801071a7:	c3                   	ret    

801071a8 <sys_exit>:

int
sys_exit(void)
{
801071a8:	55                   	push   %ebp
801071a9:	89 e5                	mov    %esp,%ebp
801071ab:	83 ec 08             	sub    $0x8,%esp
  exit();
801071ae:	e8 4e d8 ff ff       	call   80104a01 <exit>
  return 0;  // not reached
801071b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801071b8:	c9                   	leave  
801071b9:	c3                   	ret    

801071ba <sys_wait>:

int
sys_wait(void)
{
801071ba:	55                   	push   %ebp
801071bb:	89 e5                	mov    %esp,%ebp
801071bd:	83 ec 08             	sub    $0x8,%esp
  return wait();
801071c0:	e8 77 d9 ff ff       	call   80104b3c <wait>
}
801071c5:	c9                   	leave  
801071c6:	c3                   	ret    

801071c7 <sys_kill>:

int
sys_kill(void)
{
801071c7:	55                   	push   %ebp
801071c8:	89 e5                	mov    %esp,%ebp
801071ca:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801071cd:	83 ec 08             	sub    $0x8,%esp
801071d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801071d3:	50                   	push   %eax
801071d4:	6a 00                	push   $0x0
801071d6:	e8 ed f0 ff ff       	call   801062c8 <argint>
801071db:	83 c4 10             	add    $0x10,%esp
801071de:	85 c0                	test   %eax,%eax
801071e0:	79 07                	jns    801071e9 <sys_kill+0x22>
    return -1;
801071e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071e7:	eb 0f                	jmp    801071f8 <sys_kill+0x31>
  return kill(pid);
801071e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ec:	83 ec 0c             	sub    $0xc,%esp
801071ef:	50                   	push   %eax
801071f0:	e8 dc dd ff ff       	call   80104fd1 <kill>
801071f5:	83 c4 10             	add    $0x10,%esp
}
801071f8:	c9                   	leave  
801071f9:	c3                   	ret    

801071fa <sys_getpid>:

int
sys_getpid(void)
{
801071fa:	55                   	push   %ebp
801071fb:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801071fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107203:	8b 40 10             	mov    0x10(%eax),%eax
}
80107206:	5d                   	pop    %ebp
80107207:	c3                   	ret    

80107208 <sys_sbrk>:

int
sys_sbrk(void)
{
80107208:	55                   	push   %ebp
80107209:	89 e5                	mov    %esp,%ebp
8010720b:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010720e:	83 ec 08             	sub    $0x8,%esp
80107211:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107214:	50                   	push   %eax
80107215:	6a 00                	push   $0x0
80107217:	e8 ac f0 ff ff       	call   801062c8 <argint>
8010721c:	83 c4 10             	add    $0x10,%esp
8010721f:	85 c0                	test   %eax,%eax
80107221:	79 07                	jns    8010722a <sys_sbrk+0x22>
    return -1;
80107223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107228:	eb 28                	jmp    80107252 <sys_sbrk+0x4a>
  addr = proc->sz;
8010722a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107230:	8b 00                	mov    (%eax),%eax
80107232:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107235:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107238:	83 ec 0c             	sub    $0xc,%esp
8010723b:	50                   	push   %eax
8010723c:	e8 62 d5 ff ff       	call   801047a3 <growproc>
80107241:	83 c4 10             	add    $0x10,%esp
80107244:	85 c0                	test   %eax,%eax
80107246:	79 07                	jns    8010724f <sys_sbrk+0x47>
    return -1;
80107248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010724d:	eb 03                	jmp    80107252 <sys_sbrk+0x4a>
  return addr;
8010724f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107252:	c9                   	leave  
80107253:	c3                   	ret    

80107254 <sys_sleep>:

int
sys_sleep(void)
{
80107254:	55                   	push   %ebp
80107255:	89 e5                	mov    %esp,%ebp
80107257:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010725a:	83 ec 08             	sub    $0x8,%esp
8010725d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107260:	50                   	push   %eax
80107261:	6a 00                	push   $0x0
80107263:	e8 60 f0 ff ff       	call   801062c8 <argint>
80107268:	83 c4 10             	add    $0x10,%esp
8010726b:	85 c0                	test   %eax,%eax
8010726d:	79 07                	jns    80107276 <sys_sleep+0x22>
    return -1;
8010726f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107274:	eb 44                	jmp    801072ba <sys_sleep+0x66>
  ticks0 = ticks;
80107276:	a1 e0 68 11 80       	mov    0x801168e0,%eax
8010727b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010727e:	eb 26                	jmp    801072a6 <sys_sleep+0x52>
    if(proc->killed){
80107280:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107286:	8b 40 24             	mov    0x24(%eax),%eax
80107289:	85 c0                	test   %eax,%eax
8010728b:	74 07                	je     80107294 <sys_sleep+0x40>
      return -1;
8010728d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107292:	eb 26                	jmp    801072ba <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107294:	83 ec 08             	sub    $0x8,%esp
80107297:	6a 00                	push   $0x0
80107299:	68 e0 68 11 80       	push   $0x801168e0
8010729e:	e8 10 dc ff ff       	call   80104eb3 <sleep>
801072a3:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801072a6:	a1 e0 68 11 80       	mov    0x801168e0,%eax
801072ab:	2b 45 f4             	sub    -0xc(%ebp),%eax
801072ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
801072b1:	39 d0                	cmp    %edx,%eax
801072b3:	72 cb                	jb     80107280 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
801072b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801072ba:	c9                   	leave  
801072bb:	c3                   	ret    

801072bc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
801072bc:	55                   	push   %ebp
801072bd:	89 e5                	mov    %esp,%ebp
801072bf:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
801072c2:	a1 e0 68 11 80       	mov    0x801168e0,%eax
801072c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
801072ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801072cd:	c9                   	leave  
801072ce:	c3                   	ret    

801072cf <sys_halt>:

//Turn of the computer
int sys_halt(void){
801072cf:	55                   	push   %ebp
801072d0:	89 e5                	mov    %esp,%ebp
801072d2:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
801072d5:	83 ec 0c             	sub    $0xc,%esp
801072d8:	68 49 9b 10 80       	push   $0x80109b49
801072dd:	e8 e4 90 ff ff       	call   801003c6 <cprintf>
801072e2:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
801072e5:	83 ec 08             	sub    $0x8,%esp
801072e8:	68 00 20 00 00       	push   $0x2000
801072ed:	68 04 06 00 00       	push   $0x604
801072f2:	e8 83 fe ff ff       	call   8010717a <outw>
801072f7:	83 c4 10             	add    $0x10,%esp
  return 0;
801072fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801072ff:	c9                   	leave  
80107300:	c3                   	ret    

80107301 <sys_date>:

// returns the rtcdate
int
sys_date(void) // Added for Project 1: The date() System Call
{
80107301:	55                   	push   %ebp
80107302:	89 e5                	mov    %esp,%ebp
80107304:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if(argptr(0, (void*)&d, sizeof(*d)) < 0)
80107307:	83 ec 04             	sub    $0x4,%esp
8010730a:	6a 18                	push   $0x18
8010730c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010730f:	50                   	push   %eax
80107310:	6a 00                	push   $0x0
80107312:	e8 d9 ef ff ff       	call   801062f0 <argptr>
80107317:	83 c4 10             	add    $0x10,%esp
8010731a:	85 c0                	test   %eax,%eax
8010731c:	79 07                	jns    80107325 <sys_date+0x24>
    return -1;
8010731e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107323:	eb 14                	jmp    80107339 <sys_date+0x38>

  cmostime(d);
80107325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107328:	83 ec 0c             	sub    $0xc,%esp
8010732b:	50                   	push   %eax
8010732c:	e8 3d bf ff ff       	call   8010326e <cmostime>
80107331:	83 c4 10             	add    $0x10,%esp
  return 0;
80107334:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107339:	c9                   	leave  
8010733a:	c3                   	ret    

8010733b <sys_getuid>:

// START: Added for Project 2: UIDs and GIDs and PPIDs
// get uid of current process
int
sys_getuid(void)
{
8010733b:	55                   	push   %ebp
8010733c:	89 e5                	mov    %esp,%ebp
  return proc->uid;
8010733e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107344:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
8010734a:	5d                   	pop    %ebp
8010734b:	c3                   	ret    

8010734c <sys_getgid>:

// get gid of current process
int
sys_getgid(void)
{
8010734c:	55                   	push   %ebp
8010734d:	89 e5                	mov    %esp,%ebp
  return proc->gid;
8010734f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107355:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
8010735b:	5d                   	pop    %ebp
8010735c:	c3                   	ret    

8010735d <sys_getppid>:

// get pid of parent process (init is its own parent)
int
sys_getppid(void)
{
8010735d:	55                   	push   %ebp
8010735e:	89 e5                	mov    %esp,%ebp
  if (proc->pid == 1)
80107360:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107366:	8b 40 10             	mov    0x10(%eax),%eax
80107369:	83 f8 01             	cmp    $0x1,%eax
8010736c:	75 07                	jne    80107375 <sys_getppid+0x18>
    return 1;
8010736e:	b8 01 00 00 00       	mov    $0x1,%eax
80107373:	eb 0c                	jmp    80107381 <sys_getppid+0x24>
  else
    return proc->parent->pid;
80107375:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010737b:	8b 40 14             	mov    0x14(%eax),%eax
8010737e:	8b 40 10             	mov    0x10(%eax),%eax
}
80107381:	5d                   	pop    %ebp
80107382:	c3                   	ret    

80107383 <sys_setuid>:

// set uid
int
sys_setuid(void)
{
80107383:	55                   	push   %ebp
80107384:	89 e5                	mov    %esp,%ebp
80107386:	83 ec 18             	sub    $0x18,%esp
  int uid;

  if (argint(0, &uid) < 0)
80107389:	83 ec 08             	sub    $0x8,%esp
8010738c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010738f:	50                   	push   %eax
80107390:	6a 00                	push   $0x0
80107392:	e8 31 ef ff ff       	call   801062c8 <argint>
80107397:	83 c4 10             	add    $0x10,%esp
8010739a:	85 c0                	test   %eax,%eax
8010739c:	79 07                	jns    801073a5 <sys_setuid+0x22>
    return -1;
8010739e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073a3:	eb 2c                	jmp    801073d1 <sys_setuid+0x4e>
  
  if (0 <= uid && uid <= 32767){
801073a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a8:	85 c0                	test   %eax,%eax
801073aa:	78 20                	js     801073cc <sys_setuid+0x49>
801073ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073af:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801073b4:	7f 16                	jg     801073cc <sys_setuid+0x49>
    proc->uid = uid;
801073b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801073bf:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    return 0;
801073c5:	b8 00 00 00 00       	mov    $0x0,%eax
801073ca:	eb 05                	jmp    801073d1 <sys_setuid+0x4e>
  }
  else
    return -1;
801073cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
801073d1:	c9                   	leave  
801073d2:	c3                   	ret    

801073d3 <sys_setgid>:

// set gid
int
sys_setgid(void)
{
801073d3:	55                   	push   %ebp
801073d4:	89 e5                	mov    %esp,%ebp
801073d6:	83 ec 18             	sub    $0x18,%esp
  int gid;

  if (argint(0, &gid) < 0)
801073d9:	83 ec 08             	sub    $0x8,%esp
801073dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801073df:	50                   	push   %eax
801073e0:	6a 00                	push   $0x0
801073e2:	e8 e1 ee ff ff       	call   801062c8 <argint>
801073e7:	83 c4 10             	add    $0x10,%esp
801073ea:	85 c0                	test   %eax,%eax
801073ec:	79 07                	jns    801073f5 <sys_setgid+0x22>
    return -1;
801073ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073f3:	eb 2c                	jmp    80107421 <sys_setgid+0x4e>

  if (0 <= gid && gid <= 32767){
801073f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f8:	85 c0                	test   %eax,%eax
801073fa:	78 20                	js     8010741c <sys_setgid+0x49>
801073fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ff:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107404:	7f 16                	jg     8010741c <sys_setgid+0x49>
    proc->gid = gid;
80107406:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010740c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010740f:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    return 0;
80107415:	b8 00 00 00 00       	mov    $0x0,%eax
8010741a:	eb 05                	jmp    80107421 <sys_setgid+0x4e>
  }
  else
    return -1;
8010741c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107421:	c9                   	leave  
80107422:	c3                   	ret    

80107423 <sys_getprocs>:
// END: Added for Project 2: UIDs and GIDs and PPIDs

// get list of procs (for ps display)
int
sys_getprocs(void) // Added for Project 2: The "ps" Command
{
80107423:	55                   	push   %ebp
80107424:	89 e5                	mov    %esp,%ebp
80107426:	83 ec 18             	sub    $0x18,%esp
  int max;
  struct uproc *table;

  if (argint(0, &max) < 0)
80107429:	83 ec 08             	sub    $0x8,%esp
8010742c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010742f:	50                   	push   %eax
80107430:	6a 00                	push   $0x0
80107432:	e8 91 ee ff ff       	call   801062c8 <argint>
80107437:	83 c4 10             	add    $0x10,%esp
8010743a:	85 c0                	test   %eax,%eax
8010743c:	79 07                	jns    80107445 <sys_getprocs+0x22>
    return -1;
8010743e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107443:	eb 31                	jmp    80107476 <sys_getprocs+0x53>

  if (argptr(1, (void*)&table, sizeof(*table)) < 0)
80107445:	83 ec 04             	sub    $0x4,%esp
80107448:	6a 60                	push   $0x60
8010744a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010744d:	50                   	push   %eax
8010744e:	6a 01                	push   $0x1
80107450:	e8 9b ee ff ff       	call   801062f0 <argptr>
80107455:	83 c4 10             	add    $0x10,%esp
80107458:	85 c0                	test   %eax,%eax
8010745a:	79 07                	jns    80107463 <sys_getprocs+0x40>
    return -1;
8010745c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107461:	eb 13                	jmp    80107476 <sys_getprocs+0x53>

  return getuprocs(max, table); // get uproc struct array from proc.c
80107463:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107466:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107469:	83 ec 08             	sub    $0x8,%esp
8010746c:	50                   	push   %eax
8010746d:	52                   	push   %edx
8010746e:	e8 f1 e0 ff ff       	call   80105564 <getuprocs>
80107473:	83 c4 10             	add    $0x10,%esp
}
80107476:	c9                   	leave  
80107477:	c3                   	ret    

80107478 <sys_setpriority>:

// sets proc with PID of pid to priority and resets budget
// returns 0 on success and -1 on error
int
sys_setpriority(void) // Added for Project 4: The setpriority() System Call
{
80107478:	55                   	push   %ebp
80107479:	89 e5                	mov    %esp,%ebp
8010747b:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int priority;

  // get pid/ priority parameters off stack (return -1 on error)
  if(argint(0, &pid) < 0)
8010747e:	83 ec 08             	sub    $0x8,%esp
80107481:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107484:	50                   	push   %eax
80107485:	6a 00                	push   $0x0
80107487:	e8 3c ee ff ff       	call   801062c8 <argint>
8010748c:	83 c4 10             	add    $0x10,%esp
8010748f:	85 c0                	test   %eax,%eax
80107491:	79 07                	jns    8010749a <sys_setpriority+0x22>
    return -1;
80107493:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107498:	eb 4b                	jmp    801074e5 <sys_setpriority+0x6d>
  if(argint(1, &priority) < 0)
8010749a:	83 ec 08             	sub    $0x8,%esp
8010749d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801074a0:	50                   	push   %eax
801074a1:	6a 01                	push   $0x1
801074a3:	e8 20 ee ff ff       	call   801062c8 <argint>
801074a8:	83 c4 10             	add    $0x10,%esp
801074ab:	85 c0                	test   %eax,%eax
801074ad:	79 07                	jns    801074b6 <sys_setpriority+0x3e>
    return -1;
801074af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074b4:	eb 2f                	jmp    801074e5 <sys_setpriority+0x6d>

  // check if parameters have valid values (return -1 on error)
  if (pid < 0 || priority < 0 || priority > MAX)
801074b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b9:	85 c0                	test   %eax,%eax
801074bb:	78 0e                	js     801074cb <sys_setpriority+0x53>
801074bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074c0:	85 c0                	test   %eax,%eax
801074c2:	78 07                	js     801074cb <sys_setpriority+0x53>
801074c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074c7:	85 c0                	test   %eax,%eax
801074c9:	7e 07                	jle    801074d2 <sys_setpriority+0x5a>
    return -1;
801074cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074d0:	eb 13                	jmp    801074e5 <sys_setpriority+0x6d>

  // call setpriority (and return its return code)
  return setpriority(pid, priority);
801074d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801074d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d8:	83 ec 08             	sub    $0x8,%esp
801074db:	52                   	push   %edx
801074dc:	50                   	push   %eax
801074dd:	e8 6e e5 ff ff       	call   80105a50 <setpriority>
801074e2:	83 c4 10             	add    $0x10,%esp
}
801074e5:	c9                   	leave  
801074e6:	c3                   	ret    

801074e7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801074e7:	55                   	push   %ebp
801074e8:	89 e5                	mov    %esp,%ebp
801074ea:	83 ec 08             	sub    $0x8,%esp
801074ed:	8b 55 08             	mov    0x8(%ebp),%edx
801074f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801074f3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801074f7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801074fa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801074fe:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107502:	ee                   	out    %al,(%dx)
}
80107503:	90                   	nop
80107504:	c9                   	leave  
80107505:	c3                   	ret    

80107506 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80107506:	55                   	push   %ebp
80107507:	89 e5                	mov    %esp,%ebp
80107509:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010750c:	6a 34                	push   $0x34
8010750e:	6a 43                	push   $0x43
80107510:	e8 d2 ff ff ff       	call   801074e7 <outb>
80107515:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107518:	68 9c 00 00 00       	push   $0x9c
8010751d:	6a 40                	push   $0x40
8010751f:	e8 c3 ff ff ff       	call   801074e7 <outb>
80107524:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80107527:	6a 2e                	push   $0x2e
80107529:	6a 40                	push   $0x40
8010752b:	e8 b7 ff ff ff       	call   801074e7 <outb>
80107530:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80107533:	83 ec 0c             	sub    $0xc,%esp
80107536:	6a 00                	push   $0x0
80107538:	e8 94 ca ff ff       	call   80103fd1 <picenable>
8010753d:	83 c4 10             	add    $0x10,%esp
}
80107540:	90                   	nop
80107541:	c9                   	leave  
80107542:	c3                   	ret    

80107543 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107543:	1e                   	push   %ds
  pushl %es
80107544:	06                   	push   %es
  pushl %fs
80107545:	0f a0                	push   %fs
  pushl %gs
80107547:	0f a8                	push   %gs
  pushal
80107549:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010754a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010754e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107550:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107552:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107556:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107558:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010755a:	54                   	push   %esp
  call trap
8010755b:	e8 ce 01 00 00       	call   8010772e <trap>
  addl $4, %esp
80107560:	83 c4 04             	add    $0x4,%esp

80107563 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107563:	61                   	popa   
  popl %gs
80107564:	0f a9                	pop    %gs
  popl %fs
80107566:	0f a1                	pop    %fs
  popl %es
80107568:	07                   	pop    %es
  popl %ds
80107569:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010756a:	83 c4 08             	add    $0x8,%esp
  iret
8010756d:	cf                   	iret   

8010756e <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
8010756e:	55                   	push   %ebp
8010756f:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80107571:	8b 45 08             	mov    0x8(%ebp),%eax
80107574:	f0 ff 00             	lock incl (%eax)
}
80107577:	90                   	nop
80107578:	5d                   	pop    %ebp
80107579:	c3                   	ret    

8010757a <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010757a:	55                   	push   %ebp
8010757b:	89 e5                	mov    %esp,%ebp
8010757d:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107580:	8b 45 0c             	mov    0xc(%ebp),%eax
80107583:	83 e8 01             	sub    $0x1,%eax
80107586:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010758a:	8b 45 08             	mov    0x8(%ebp),%eax
8010758d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107591:	8b 45 08             	mov    0x8(%ebp),%eax
80107594:	c1 e8 10             	shr    $0x10,%eax
80107597:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010759b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010759e:	0f 01 18             	lidtl  (%eax)
}
801075a1:	90                   	nop
801075a2:	c9                   	leave  
801075a3:	c3                   	ret    

801075a4 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801075a4:	55                   	push   %ebp
801075a5:	89 e5                	mov    %esp,%ebp
801075a7:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801075aa:	0f 20 d0             	mov    %cr2,%eax
801075ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801075b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801075b3:	c9                   	leave  
801075b4:	c3                   	ret    

801075b5 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
801075b5:	55                   	push   %ebp
801075b6:	89 e5                	mov    %esp,%ebp
801075b8:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
801075bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801075c2:	e9 c3 00 00 00       	jmp    8010768a <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801075c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801075ca:	8b 04 85 b4 c0 10 80 	mov    -0x7fef3f4c(,%eax,4),%eax
801075d1:	89 c2                	mov    %eax,%edx
801075d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801075d6:	66 89 14 c5 e0 60 11 	mov    %dx,-0x7fee9f20(,%eax,8)
801075dd:	80 
801075de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801075e1:	66 c7 04 c5 e2 60 11 	movw   $0x8,-0x7fee9f1e(,%eax,8)
801075e8:	80 08 00 
801075eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801075ee:	0f b6 14 c5 e4 60 11 	movzbl -0x7fee9f1c(,%eax,8),%edx
801075f5:	80 
801075f6:	83 e2 e0             	and    $0xffffffe0,%edx
801075f9:	88 14 c5 e4 60 11 80 	mov    %dl,-0x7fee9f1c(,%eax,8)
80107600:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107603:	0f b6 14 c5 e4 60 11 	movzbl -0x7fee9f1c(,%eax,8),%edx
8010760a:	80 
8010760b:	83 e2 1f             	and    $0x1f,%edx
8010760e:	88 14 c5 e4 60 11 80 	mov    %dl,-0x7fee9f1c(,%eax,8)
80107615:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107618:	0f b6 14 c5 e5 60 11 	movzbl -0x7fee9f1b(,%eax,8),%edx
8010761f:	80 
80107620:	83 e2 f0             	and    $0xfffffff0,%edx
80107623:	83 ca 0e             	or     $0xe,%edx
80107626:	88 14 c5 e5 60 11 80 	mov    %dl,-0x7fee9f1b(,%eax,8)
8010762d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107630:	0f b6 14 c5 e5 60 11 	movzbl -0x7fee9f1b(,%eax,8),%edx
80107637:	80 
80107638:	83 e2 ef             	and    $0xffffffef,%edx
8010763b:	88 14 c5 e5 60 11 80 	mov    %dl,-0x7fee9f1b(,%eax,8)
80107642:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107645:	0f b6 14 c5 e5 60 11 	movzbl -0x7fee9f1b(,%eax,8),%edx
8010764c:	80 
8010764d:	83 e2 9f             	and    $0xffffff9f,%edx
80107650:	88 14 c5 e5 60 11 80 	mov    %dl,-0x7fee9f1b(,%eax,8)
80107657:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010765a:	0f b6 14 c5 e5 60 11 	movzbl -0x7fee9f1b(,%eax,8),%edx
80107661:	80 
80107662:	83 ca 80             	or     $0xffffff80,%edx
80107665:	88 14 c5 e5 60 11 80 	mov    %dl,-0x7fee9f1b(,%eax,8)
8010766c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010766f:	8b 04 85 b4 c0 10 80 	mov    -0x7fef3f4c(,%eax,4),%eax
80107676:	c1 e8 10             	shr    $0x10,%eax
80107679:	89 c2                	mov    %eax,%edx
8010767b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010767e:	66 89 14 c5 e6 60 11 	mov    %dx,-0x7fee9f1a(,%eax,8)
80107685:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107686:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010768a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107691:	0f 8e 30 ff ff ff    	jle    801075c7 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107697:	a1 b4 c1 10 80       	mov    0x8010c1b4,%eax
8010769c:	66 a3 e0 62 11 80    	mov    %ax,0x801162e0
801076a2:	66 c7 05 e2 62 11 80 	movw   $0x8,0x801162e2
801076a9:	08 00 
801076ab:	0f b6 05 e4 62 11 80 	movzbl 0x801162e4,%eax
801076b2:	83 e0 e0             	and    $0xffffffe0,%eax
801076b5:	a2 e4 62 11 80       	mov    %al,0x801162e4
801076ba:	0f b6 05 e4 62 11 80 	movzbl 0x801162e4,%eax
801076c1:	83 e0 1f             	and    $0x1f,%eax
801076c4:	a2 e4 62 11 80       	mov    %al,0x801162e4
801076c9:	0f b6 05 e5 62 11 80 	movzbl 0x801162e5,%eax
801076d0:	83 c8 0f             	or     $0xf,%eax
801076d3:	a2 e5 62 11 80       	mov    %al,0x801162e5
801076d8:	0f b6 05 e5 62 11 80 	movzbl 0x801162e5,%eax
801076df:	83 e0 ef             	and    $0xffffffef,%eax
801076e2:	a2 e5 62 11 80       	mov    %al,0x801162e5
801076e7:	0f b6 05 e5 62 11 80 	movzbl 0x801162e5,%eax
801076ee:	83 c8 60             	or     $0x60,%eax
801076f1:	a2 e5 62 11 80       	mov    %al,0x801162e5
801076f6:	0f b6 05 e5 62 11 80 	movzbl 0x801162e5,%eax
801076fd:	83 c8 80             	or     $0xffffff80,%eax
80107700:	a2 e5 62 11 80       	mov    %al,0x801162e5
80107705:	a1 b4 c1 10 80       	mov    0x8010c1b4,%eax
8010770a:	c1 e8 10             	shr    $0x10,%eax
8010770d:	66 a3 e6 62 11 80    	mov    %ax,0x801162e6
  
}
80107713:	90                   	nop
80107714:	c9                   	leave  
80107715:	c3                   	ret    

80107716 <idtinit>:

void
idtinit(void)
{
80107716:	55                   	push   %ebp
80107717:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107719:	68 00 08 00 00       	push   $0x800
8010771e:	68 e0 60 11 80       	push   $0x801160e0
80107723:	e8 52 fe ff ff       	call   8010757a <lidt>
80107728:	83 c4 08             	add    $0x8,%esp
}
8010772b:	90                   	nop
8010772c:	c9                   	leave  
8010772d:	c3                   	ret    

8010772e <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010772e:	55                   	push   %ebp
8010772f:	89 e5                	mov    %esp,%ebp
80107731:	57                   	push   %edi
80107732:	56                   	push   %esi
80107733:	53                   	push   %ebx
80107734:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107737:	8b 45 08             	mov    0x8(%ebp),%eax
8010773a:	8b 40 30             	mov    0x30(%eax),%eax
8010773d:	83 f8 40             	cmp    $0x40,%eax
80107740:	75 3e                	jne    80107780 <trap+0x52>
    if(proc->killed)
80107742:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107748:	8b 40 24             	mov    0x24(%eax),%eax
8010774b:	85 c0                	test   %eax,%eax
8010774d:	74 05                	je     80107754 <trap+0x26>
      exit();
8010774f:	e8 ad d2 ff ff       	call   80104a01 <exit>
    proc->tf = tf;
80107754:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010775a:	8b 55 08             	mov    0x8(%ebp),%edx
8010775d:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107760:	e8 19 ec ff ff       	call   8010637e <syscall>
    if(proc->killed)
80107765:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010776b:	8b 40 24             	mov    0x24(%eax),%eax
8010776e:	85 c0                	test   %eax,%eax
80107770:	0f 84 fe 01 00 00    	je     80107974 <trap+0x246>
      exit();
80107776:	e8 86 d2 ff ff       	call   80104a01 <exit>
    return;
8010777b:	e9 f4 01 00 00       	jmp    80107974 <trap+0x246>
  }

  switch(tf->trapno){
80107780:	8b 45 08             	mov    0x8(%ebp),%eax
80107783:	8b 40 30             	mov    0x30(%eax),%eax
80107786:	83 e8 20             	sub    $0x20,%eax
80107789:	83 f8 1f             	cmp    $0x1f,%eax
8010778c:	0f 87 a3 00 00 00    	ja     80107835 <trap+0x107>
80107792:	8b 04 85 fc 9b 10 80 	mov    -0x7fef6404(,%eax,4),%eax
80107799:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
8010779b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801077a1:	0f b6 00             	movzbl (%eax),%eax
801077a4:	84 c0                	test   %al,%al
801077a6:	75 20                	jne    801077c8 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
801077a8:	83 ec 0c             	sub    $0xc,%esp
801077ab:	68 e0 68 11 80       	push   $0x801168e0
801077b0:	e8 b9 fd ff ff       	call   8010756e <atom_inc>
801077b5:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
801077b8:	83 ec 0c             	sub    $0xc,%esp
801077bb:	68 e0 68 11 80       	push   $0x801168e0
801077c0:	e8 d5 d7 ff ff       	call   80104f9a <wakeup>
801077c5:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801077c8:	e8 fe b8 ff ff       	call   801030cb <lapiceoi>
    break;
801077cd:	e9 1c 01 00 00       	jmp    801078ee <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801077d2:	e8 07 b1 ff ff       	call   801028de <ideintr>
    lapiceoi();
801077d7:	e8 ef b8 ff ff       	call   801030cb <lapiceoi>
    break;
801077dc:	e9 0d 01 00 00       	jmp    801078ee <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801077e1:	e8 e7 b6 ff ff       	call   80102ecd <kbdintr>
    lapiceoi();
801077e6:	e8 e0 b8 ff ff       	call   801030cb <lapiceoi>
    break;
801077eb:	e9 fe 00 00 00       	jmp    801078ee <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801077f0:	e8 60 03 00 00       	call   80107b55 <uartintr>
    lapiceoi();
801077f5:	e8 d1 b8 ff ff       	call   801030cb <lapiceoi>
    break;
801077fa:	e9 ef 00 00 00       	jmp    801078ee <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801077ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107802:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107805:	8b 45 08             	mov    0x8(%ebp),%eax
80107808:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010780c:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010780f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107815:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107818:	0f b6 c0             	movzbl %al,%eax
8010781b:	51                   	push   %ecx
8010781c:	52                   	push   %edx
8010781d:	50                   	push   %eax
8010781e:	68 5c 9b 10 80       	push   $0x80109b5c
80107823:	e8 9e 8b ff ff       	call   801003c6 <cprintf>
80107828:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010782b:	e8 9b b8 ff ff       	call   801030cb <lapiceoi>
    break;
80107830:	e9 b9 00 00 00       	jmp    801078ee <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107835:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010783b:	85 c0                	test   %eax,%eax
8010783d:	74 11                	je     80107850 <trap+0x122>
8010783f:	8b 45 08             	mov    0x8(%ebp),%eax
80107842:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107846:	0f b7 c0             	movzwl %ax,%eax
80107849:	83 e0 03             	and    $0x3,%eax
8010784c:	85 c0                	test   %eax,%eax
8010784e:	75 40                	jne    80107890 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107850:	e8 4f fd ff ff       	call   801075a4 <rcr2>
80107855:	89 c3                	mov    %eax,%ebx
80107857:	8b 45 08             	mov    0x8(%ebp),%eax
8010785a:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010785d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107863:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107866:	0f b6 d0             	movzbl %al,%edx
80107869:	8b 45 08             	mov    0x8(%ebp),%eax
8010786c:	8b 40 30             	mov    0x30(%eax),%eax
8010786f:	83 ec 0c             	sub    $0xc,%esp
80107872:	53                   	push   %ebx
80107873:	51                   	push   %ecx
80107874:	52                   	push   %edx
80107875:	50                   	push   %eax
80107876:	68 80 9b 10 80       	push   $0x80109b80
8010787b:	e8 46 8b ff ff       	call   801003c6 <cprintf>
80107880:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107883:	83 ec 0c             	sub    $0xc,%esp
80107886:	68 b2 9b 10 80       	push   $0x80109bb2
8010788b:	e8 d6 8c ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107890:	e8 0f fd ff ff       	call   801075a4 <rcr2>
80107895:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107898:	8b 45 08             	mov    0x8(%ebp),%eax
8010789b:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010789e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801078a4:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801078a7:	0f b6 d8             	movzbl %al,%ebx
801078aa:	8b 45 08             	mov    0x8(%ebp),%eax
801078ad:	8b 48 34             	mov    0x34(%eax),%ecx
801078b0:	8b 45 08             	mov    0x8(%ebp),%eax
801078b3:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801078b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078bc:	8d 78 6c             	lea    0x6c(%eax),%edi
801078bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801078c5:	8b 40 10             	mov    0x10(%eax),%eax
801078c8:	ff 75 e4             	pushl  -0x1c(%ebp)
801078cb:	56                   	push   %esi
801078cc:	53                   	push   %ebx
801078cd:	51                   	push   %ecx
801078ce:	52                   	push   %edx
801078cf:	57                   	push   %edi
801078d0:	50                   	push   %eax
801078d1:	68 b8 9b 10 80       	push   $0x80109bb8
801078d6:	e8 eb 8a ff ff       	call   801003c6 <cprintf>
801078db:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801078de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078e4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801078eb:	eb 01                	jmp    801078ee <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801078ed:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801078ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078f4:	85 c0                	test   %eax,%eax
801078f6:	74 24                	je     8010791c <trap+0x1ee>
801078f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078fe:	8b 40 24             	mov    0x24(%eax),%eax
80107901:	85 c0                	test   %eax,%eax
80107903:	74 17                	je     8010791c <trap+0x1ee>
80107905:	8b 45 08             	mov    0x8(%ebp),%eax
80107908:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010790c:	0f b7 c0             	movzwl %ax,%eax
8010790f:	83 e0 03             	and    $0x3,%eax
80107912:	83 f8 03             	cmp    $0x3,%eax
80107915:	75 05                	jne    8010791c <trap+0x1ee>
    exit();
80107917:	e8 e5 d0 ff ff       	call   80104a01 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010791c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107922:	85 c0                	test   %eax,%eax
80107924:	74 1e                	je     80107944 <trap+0x216>
80107926:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010792c:	8b 40 0c             	mov    0xc(%eax),%eax
8010792f:	83 f8 04             	cmp    $0x4,%eax
80107932:	75 10                	jne    80107944 <trap+0x216>
80107934:	8b 45 08             	mov    0x8(%ebp),%eax
80107937:	8b 40 30             	mov    0x30(%eax),%eax
8010793a:	83 f8 20             	cmp    $0x20,%eax
8010793d:	75 05                	jne    80107944 <trap+0x216>
    yield();
8010793f:	e8 ee d4 ff ff       	call   80104e32 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107944:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010794a:	85 c0                	test   %eax,%eax
8010794c:	74 27                	je     80107975 <trap+0x247>
8010794e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107954:	8b 40 24             	mov    0x24(%eax),%eax
80107957:	85 c0                	test   %eax,%eax
80107959:	74 1a                	je     80107975 <trap+0x247>
8010795b:	8b 45 08             	mov    0x8(%ebp),%eax
8010795e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107962:	0f b7 c0             	movzwl %ax,%eax
80107965:	83 e0 03             	and    $0x3,%eax
80107968:	83 f8 03             	cmp    $0x3,%eax
8010796b:	75 08                	jne    80107975 <trap+0x247>
    exit();
8010796d:	e8 8f d0 ff ff       	call   80104a01 <exit>
80107972:	eb 01                	jmp    80107975 <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107974:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107975:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107978:	5b                   	pop    %ebx
80107979:	5e                   	pop    %esi
8010797a:	5f                   	pop    %edi
8010797b:	5d                   	pop    %ebp
8010797c:	c3                   	ret    

8010797d <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
8010797d:	55                   	push   %ebp
8010797e:	89 e5                	mov    %esp,%ebp
80107980:	83 ec 14             	sub    $0x14,%esp
80107983:	8b 45 08             	mov    0x8(%ebp),%eax
80107986:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010798a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010798e:	89 c2                	mov    %eax,%edx
80107990:	ec                   	in     (%dx),%al
80107991:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107994:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107998:	c9                   	leave  
80107999:	c3                   	ret    

8010799a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010799a:	55                   	push   %ebp
8010799b:	89 e5                	mov    %esp,%ebp
8010799d:	83 ec 08             	sub    $0x8,%esp
801079a0:	8b 55 08             	mov    0x8(%ebp),%edx
801079a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801079a6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801079aa:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801079ad:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801079b1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801079b5:	ee                   	out    %al,(%dx)
}
801079b6:	90                   	nop
801079b7:	c9                   	leave  
801079b8:	c3                   	ret    

801079b9 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801079b9:	55                   	push   %ebp
801079ba:	89 e5                	mov    %esp,%ebp
801079bc:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801079bf:	6a 00                	push   $0x0
801079c1:	68 fa 03 00 00       	push   $0x3fa
801079c6:	e8 cf ff ff ff       	call   8010799a <outb>
801079cb:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801079ce:	68 80 00 00 00       	push   $0x80
801079d3:	68 fb 03 00 00       	push   $0x3fb
801079d8:	e8 bd ff ff ff       	call   8010799a <outb>
801079dd:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801079e0:	6a 0c                	push   $0xc
801079e2:	68 f8 03 00 00       	push   $0x3f8
801079e7:	e8 ae ff ff ff       	call   8010799a <outb>
801079ec:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801079ef:	6a 00                	push   $0x0
801079f1:	68 f9 03 00 00       	push   $0x3f9
801079f6:	e8 9f ff ff ff       	call   8010799a <outb>
801079fb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801079fe:	6a 03                	push   $0x3
80107a00:	68 fb 03 00 00       	push   $0x3fb
80107a05:	e8 90 ff ff ff       	call   8010799a <outb>
80107a0a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107a0d:	6a 00                	push   $0x0
80107a0f:	68 fc 03 00 00       	push   $0x3fc
80107a14:	e8 81 ff ff ff       	call   8010799a <outb>
80107a19:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107a1c:	6a 01                	push   $0x1
80107a1e:	68 f9 03 00 00       	push   $0x3f9
80107a23:	e8 72 ff ff ff       	call   8010799a <outb>
80107a28:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107a2b:	68 fd 03 00 00       	push   $0x3fd
80107a30:	e8 48 ff ff ff       	call   8010797d <inb>
80107a35:	83 c4 04             	add    $0x4,%esp
80107a38:	3c ff                	cmp    $0xff,%al
80107a3a:	74 6e                	je     80107aaa <uartinit+0xf1>
    return;
  uart = 1;
80107a3c:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107a43:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107a46:	68 fa 03 00 00       	push   $0x3fa
80107a4b:	e8 2d ff ff ff       	call   8010797d <inb>
80107a50:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107a53:	68 f8 03 00 00       	push   $0x3f8
80107a58:	e8 20 ff ff ff       	call   8010797d <inb>
80107a5d:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107a60:	83 ec 0c             	sub    $0xc,%esp
80107a63:	6a 04                	push   $0x4
80107a65:	e8 67 c5 ff ff       	call   80103fd1 <picenable>
80107a6a:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107a6d:	83 ec 08             	sub    $0x8,%esp
80107a70:	6a 00                	push   $0x0
80107a72:	6a 04                	push   $0x4
80107a74:	e8 07 b1 ff ff       	call   80102b80 <ioapicenable>
80107a79:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107a7c:	c7 45 f4 7c 9c 10 80 	movl   $0x80109c7c,-0xc(%ebp)
80107a83:	eb 19                	jmp    80107a9e <uartinit+0xe5>
    uartputc(*p);
80107a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a88:	0f b6 00             	movzbl (%eax),%eax
80107a8b:	0f be c0             	movsbl %al,%eax
80107a8e:	83 ec 0c             	sub    $0xc,%esp
80107a91:	50                   	push   %eax
80107a92:	e8 16 00 00 00       	call   80107aad <uartputc>
80107a97:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107a9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa1:	0f b6 00             	movzbl (%eax),%eax
80107aa4:	84 c0                	test   %al,%al
80107aa6:	75 dd                	jne    80107a85 <uartinit+0xcc>
80107aa8:	eb 01                	jmp    80107aab <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107aaa:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107aab:	c9                   	leave  
80107aac:	c3                   	ret    

80107aad <uartputc>:

void
uartputc(int c)
{
80107aad:	55                   	push   %ebp
80107aae:	89 e5                	mov    %esp,%ebp
80107ab0:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107ab3:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107ab8:	85 c0                	test   %eax,%eax
80107aba:	74 53                	je     80107b0f <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107abc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ac3:	eb 11                	jmp    80107ad6 <uartputc+0x29>
    microdelay(10);
80107ac5:	83 ec 0c             	sub    $0xc,%esp
80107ac8:	6a 0a                	push   $0xa
80107aca:	e8 17 b6 ff ff       	call   801030e6 <microdelay>
80107acf:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107ad2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107ad6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107ada:	7f 1a                	jg     80107af6 <uartputc+0x49>
80107adc:	83 ec 0c             	sub    $0xc,%esp
80107adf:	68 fd 03 00 00       	push   $0x3fd
80107ae4:	e8 94 fe ff ff       	call   8010797d <inb>
80107ae9:	83 c4 10             	add    $0x10,%esp
80107aec:	0f b6 c0             	movzbl %al,%eax
80107aef:	83 e0 20             	and    $0x20,%eax
80107af2:	85 c0                	test   %eax,%eax
80107af4:	74 cf                	je     80107ac5 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107af6:	8b 45 08             	mov    0x8(%ebp),%eax
80107af9:	0f b6 c0             	movzbl %al,%eax
80107afc:	83 ec 08             	sub    $0x8,%esp
80107aff:	50                   	push   %eax
80107b00:	68 f8 03 00 00       	push   $0x3f8
80107b05:	e8 90 fe ff ff       	call   8010799a <outb>
80107b0a:	83 c4 10             	add    $0x10,%esp
80107b0d:	eb 01                	jmp    80107b10 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107b0f:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107b10:	c9                   	leave  
80107b11:	c3                   	ret    

80107b12 <uartgetc>:

static int
uartgetc(void)
{
80107b12:	55                   	push   %ebp
80107b13:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107b15:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107b1a:	85 c0                	test   %eax,%eax
80107b1c:	75 07                	jne    80107b25 <uartgetc+0x13>
    return -1;
80107b1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b23:	eb 2e                	jmp    80107b53 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107b25:	68 fd 03 00 00       	push   $0x3fd
80107b2a:	e8 4e fe ff ff       	call   8010797d <inb>
80107b2f:	83 c4 04             	add    $0x4,%esp
80107b32:	0f b6 c0             	movzbl %al,%eax
80107b35:	83 e0 01             	and    $0x1,%eax
80107b38:	85 c0                	test   %eax,%eax
80107b3a:	75 07                	jne    80107b43 <uartgetc+0x31>
    return -1;
80107b3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b41:	eb 10                	jmp    80107b53 <uartgetc+0x41>
  return inb(COM1+0);
80107b43:	68 f8 03 00 00       	push   $0x3f8
80107b48:	e8 30 fe ff ff       	call   8010797d <inb>
80107b4d:	83 c4 04             	add    $0x4,%esp
80107b50:	0f b6 c0             	movzbl %al,%eax
}
80107b53:	c9                   	leave  
80107b54:	c3                   	ret    

80107b55 <uartintr>:

void
uartintr(void)
{
80107b55:	55                   	push   %ebp
80107b56:	89 e5                	mov    %esp,%ebp
80107b58:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107b5b:	83 ec 0c             	sub    $0xc,%esp
80107b5e:	68 12 7b 10 80       	push   $0x80107b12
80107b63:	e8 91 8c ff ff       	call   801007f9 <consoleintr>
80107b68:	83 c4 10             	add    $0x10,%esp
}
80107b6b:	90                   	nop
80107b6c:	c9                   	leave  
80107b6d:	c3                   	ret    

80107b6e <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107b6e:	6a 00                	push   $0x0
  pushl $0
80107b70:	6a 00                	push   $0x0
  jmp alltraps
80107b72:	e9 cc f9 ff ff       	jmp    80107543 <alltraps>

80107b77 <vector1>:
.globl vector1
vector1:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $1
80107b79:	6a 01                	push   $0x1
  jmp alltraps
80107b7b:	e9 c3 f9 ff ff       	jmp    80107543 <alltraps>

80107b80 <vector2>:
.globl vector2
vector2:
  pushl $0
80107b80:	6a 00                	push   $0x0
  pushl $2
80107b82:	6a 02                	push   $0x2
  jmp alltraps
80107b84:	e9 ba f9 ff ff       	jmp    80107543 <alltraps>

80107b89 <vector3>:
.globl vector3
vector3:
  pushl $0
80107b89:	6a 00                	push   $0x0
  pushl $3
80107b8b:	6a 03                	push   $0x3
  jmp alltraps
80107b8d:	e9 b1 f9 ff ff       	jmp    80107543 <alltraps>

80107b92 <vector4>:
.globl vector4
vector4:
  pushl $0
80107b92:	6a 00                	push   $0x0
  pushl $4
80107b94:	6a 04                	push   $0x4
  jmp alltraps
80107b96:	e9 a8 f9 ff ff       	jmp    80107543 <alltraps>

80107b9b <vector5>:
.globl vector5
vector5:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $5
80107b9d:	6a 05                	push   $0x5
  jmp alltraps
80107b9f:	e9 9f f9 ff ff       	jmp    80107543 <alltraps>

80107ba4 <vector6>:
.globl vector6
vector6:
  pushl $0
80107ba4:	6a 00                	push   $0x0
  pushl $6
80107ba6:	6a 06                	push   $0x6
  jmp alltraps
80107ba8:	e9 96 f9 ff ff       	jmp    80107543 <alltraps>

80107bad <vector7>:
.globl vector7
vector7:
  pushl $0
80107bad:	6a 00                	push   $0x0
  pushl $7
80107baf:	6a 07                	push   $0x7
  jmp alltraps
80107bb1:	e9 8d f9 ff ff       	jmp    80107543 <alltraps>

80107bb6 <vector8>:
.globl vector8
vector8:
  pushl $8
80107bb6:	6a 08                	push   $0x8
  jmp alltraps
80107bb8:	e9 86 f9 ff ff       	jmp    80107543 <alltraps>

80107bbd <vector9>:
.globl vector9
vector9:
  pushl $0
80107bbd:	6a 00                	push   $0x0
  pushl $9
80107bbf:	6a 09                	push   $0x9
  jmp alltraps
80107bc1:	e9 7d f9 ff ff       	jmp    80107543 <alltraps>

80107bc6 <vector10>:
.globl vector10
vector10:
  pushl $10
80107bc6:	6a 0a                	push   $0xa
  jmp alltraps
80107bc8:	e9 76 f9 ff ff       	jmp    80107543 <alltraps>

80107bcd <vector11>:
.globl vector11
vector11:
  pushl $11
80107bcd:	6a 0b                	push   $0xb
  jmp alltraps
80107bcf:	e9 6f f9 ff ff       	jmp    80107543 <alltraps>

80107bd4 <vector12>:
.globl vector12
vector12:
  pushl $12
80107bd4:	6a 0c                	push   $0xc
  jmp alltraps
80107bd6:	e9 68 f9 ff ff       	jmp    80107543 <alltraps>

80107bdb <vector13>:
.globl vector13
vector13:
  pushl $13
80107bdb:	6a 0d                	push   $0xd
  jmp alltraps
80107bdd:	e9 61 f9 ff ff       	jmp    80107543 <alltraps>

80107be2 <vector14>:
.globl vector14
vector14:
  pushl $14
80107be2:	6a 0e                	push   $0xe
  jmp alltraps
80107be4:	e9 5a f9 ff ff       	jmp    80107543 <alltraps>

80107be9 <vector15>:
.globl vector15
vector15:
  pushl $0
80107be9:	6a 00                	push   $0x0
  pushl $15
80107beb:	6a 0f                	push   $0xf
  jmp alltraps
80107bed:	e9 51 f9 ff ff       	jmp    80107543 <alltraps>

80107bf2 <vector16>:
.globl vector16
vector16:
  pushl $0
80107bf2:	6a 00                	push   $0x0
  pushl $16
80107bf4:	6a 10                	push   $0x10
  jmp alltraps
80107bf6:	e9 48 f9 ff ff       	jmp    80107543 <alltraps>

80107bfb <vector17>:
.globl vector17
vector17:
  pushl $17
80107bfb:	6a 11                	push   $0x11
  jmp alltraps
80107bfd:	e9 41 f9 ff ff       	jmp    80107543 <alltraps>

80107c02 <vector18>:
.globl vector18
vector18:
  pushl $0
80107c02:	6a 00                	push   $0x0
  pushl $18
80107c04:	6a 12                	push   $0x12
  jmp alltraps
80107c06:	e9 38 f9 ff ff       	jmp    80107543 <alltraps>

80107c0b <vector19>:
.globl vector19
vector19:
  pushl $0
80107c0b:	6a 00                	push   $0x0
  pushl $19
80107c0d:	6a 13                	push   $0x13
  jmp alltraps
80107c0f:	e9 2f f9 ff ff       	jmp    80107543 <alltraps>

80107c14 <vector20>:
.globl vector20
vector20:
  pushl $0
80107c14:	6a 00                	push   $0x0
  pushl $20
80107c16:	6a 14                	push   $0x14
  jmp alltraps
80107c18:	e9 26 f9 ff ff       	jmp    80107543 <alltraps>

80107c1d <vector21>:
.globl vector21
vector21:
  pushl $0
80107c1d:	6a 00                	push   $0x0
  pushl $21
80107c1f:	6a 15                	push   $0x15
  jmp alltraps
80107c21:	e9 1d f9 ff ff       	jmp    80107543 <alltraps>

80107c26 <vector22>:
.globl vector22
vector22:
  pushl $0
80107c26:	6a 00                	push   $0x0
  pushl $22
80107c28:	6a 16                	push   $0x16
  jmp alltraps
80107c2a:	e9 14 f9 ff ff       	jmp    80107543 <alltraps>

80107c2f <vector23>:
.globl vector23
vector23:
  pushl $0
80107c2f:	6a 00                	push   $0x0
  pushl $23
80107c31:	6a 17                	push   $0x17
  jmp alltraps
80107c33:	e9 0b f9 ff ff       	jmp    80107543 <alltraps>

80107c38 <vector24>:
.globl vector24
vector24:
  pushl $0
80107c38:	6a 00                	push   $0x0
  pushl $24
80107c3a:	6a 18                	push   $0x18
  jmp alltraps
80107c3c:	e9 02 f9 ff ff       	jmp    80107543 <alltraps>

80107c41 <vector25>:
.globl vector25
vector25:
  pushl $0
80107c41:	6a 00                	push   $0x0
  pushl $25
80107c43:	6a 19                	push   $0x19
  jmp alltraps
80107c45:	e9 f9 f8 ff ff       	jmp    80107543 <alltraps>

80107c4a <vector26>:
.globl vector26
vector26:
  pushl $0
80107c4a:	6a 00                	push   $0x0
  pushl $26
80107c4c:	6a 1a                	push   $0x1a
  jmp alltraps
80107c4e:	e9 f0 f8 ff ff       	jmp    80107543 <alltraps>

80107c53 <vector27>:
.globl vector27
vector27:
  pushl $0
80107c53:	6a 00                	push   $0x0
  pushl $27
80107c55:	6a 1b                	push   $0x1b
  jmp alltraps
80107c57:	e9 e7 f8 ff ff       	jmp    80107543 <alltraps>

80107c5c <vector28>:
.globl vector28
vector28:
  pushl $0
80107c5c:	6a 00                	push   $0x0
  pushl $28
80107c5e:	6a 1c                	push   $0x1c
  jmp alltraps
80107c60:	e9 de f8 ff ff       	jmp    80107543 <alltraps>

80107c65 <vector29>:
.globl vector29
vector29:
  pushl $0
80107c65:	6a 00                	push   $0x0
  pushl $29
80107c67:	6a 1d                	push   $0x1d
  jmp alltraps
80107c69:	e9 d5 f8 ff ff       	jmp    80107543 <alltraps>

80107c6e <vector30>:
.globl vector30
vector30:
  pushl $0
80107c6e:	6a 00                	push   $0x0
  pushl $30
80107c70:	6a 1e                	push   $0x1e
  jmp alltraps
80107c72:	e9 cc f8 ff ff       	jmp    80107543 <alltraps>

80107c77 <vector31>:
.globl vector31
vector31:
  pushl $0
80107c77:	6a 00                	push   $0x0
  pushl $31
80107c79:	6a 1f                	push   $0x1f
  jmp alltraps
80107c7b:	e9 c3 f8 ff ff       	jmp    80107543 <alltraps>

80107c80 <vector32>:
.globl vector32
vector32:
  pushl $0
80107c80:	6a 00                	push   $0x0
  pushl $32
80107c82:	6a 20                	push   $0x20
  jmp alltraps
80107c84:	e9 ba f8 ff ff       	jmp    80107543 <alltraps>

80107c89 <vector33>:
.globl vector33
vector33:
  pushl $0
80107c89:	6a 00                	push   $0x0
  pushl $33
80107c8b:	6a 21                	push   $0x21
  jmp alltraps
80107c8d:	e9 b1 f8 ff ff       	jmp    80107543 <alltraps>

80107c92 <vector34>:
.globl vector34
vector34:
  pushl $0
80107c92:	6a 00                	push   $0x0
  pushl $34
80107c94:	6a 22                	push   $0x22
  jmp alltraps
80107c96:	e9 a8 f8 ff ff       	jmp    80107543 <alltraps>

80107c9b <vector35>:
.globl vector35
vector35:
  pushl $0
80107c9b:	6a 00                	push   $0x0
  pushl $35
80107c9d:	6a 23                	push   $0x23
  jmp alltraps
80107c9f:	e9 9f f8 ff ff       	jmp    80107543 <alltraps>

80107ca4 <vector36>:
.globl vector36
vector36:
  pushl $0
80107ca4:	6a 00                	push   $0x0
  pushl $36
80107ca6:	6a 24                	push   $0x24
  jmp alltraps
80107ca8:	e9 96 f8 ff ff       	jmp    80107543 <alltraps>

80107cad <vector37>:
.globl vector37
vector37:
  pushl $0
80107cad:	6a 00                	push   $0x0
  pushl $37
80107caf:	6a 25                	push   $0x25
  jmp alltraps
80107cb1:	e9 8d f8 ff ff       	jmp    80107543 <alltraps>

80107cb6 <vector38>:
.globl vector38
vector38:
  pushl $0
80107cb6:	6a 00                	push   $0x0
  pushl $38
80107cb8:	6a 26                	push   $0x26
  jmp alltraps
80107cba:	e9 84 f8 ff ff       	jmp    80107543 <alltraps>

80107cbf <vector39>:
.globl vector39
vector39:
  pushl $0
80107cbf:	6a 00                	push   $0x0
  pushl $39
80107cc1:	6a 27                	push   $0x27
  jmp alltraps
80107cc3:	e9 7b f8 ff ff       	jmp    80107543 <alltraps>

80107cc8 <vector40>:
.globl vector40
vector40:
  pushl $0
80107cc8:	6a 00                	push   $0x0
  pushl $40
80107cca:	6a 28                	push   $0x28
  jmp alltraps
80107ccc:	e9 72 f8 ff ff       	jmp    80107543 <alltraps>

80107cd1 <vector41>:
.globl vector41
vector41:
  pushl $0
80107cd1:	6a 00                	push   $0x0
  pushl $41
80107cd3:	6a 29                	push   $0x29
  jmp alltraps
80107cd5:	e9 69 f8 ff ff       	jmp    80107543 <alltraps>

80107cda <vector42>:
.globl vector42
vector42:
  pushl $0
80107cda:	6a 00                	push   $0x0
  pushl $42
80107cdc:	6a 2a                	push   $0x2a
  jmp alltraps
80107cde:	e9 60 f8 ff ff       	jmp    80107543 <alltraps>

80107ce3 <vector43>:
.globl vector43
vector43:
  pushl $0
80107ce3:	6a 00                	push   $0x0
  pushl $43
80107ce5:	6a 2b                	push   $0x2b
  jmp alltraps
80107ce7:	e9 57 f8 ff ff       	jmp    80107543 <alltraps>

80107cec <vector44>:
.globl vector44
vector44:
  pushl $0
80107cec:	6a 00                	push   $0x0
  pushl $44
80107cee:	6a 2c                	push   $0x2c
  jmp alltraps
80107cf0:	e9 4e f8 ff ff       	jmp    80107543 <alltraps>

80107cf5 <vector45>:
.globl vector45
vector45:
  pushl $0
80107cf5:	6a 00                	push   $0x0
  pushl $45
80107cf7:	6a 2d                	push   $0x2d
  jmp alltraps
80107cf9:	e9 45 f8 ff ff       	jmp    80107543 <alltraps>

80107cfe <vector46>:
.globl vector46
vector46:
  pushl $0
80107cfe:	6a 00                	push   $0x0
  pushl $46
80107d00:	6a 2e                	push   $0x2e
  jmp alltraps
80107d02:	e9 3c f8 ff ff       	jmp    80107543 <alltraps>

80107d07 <vector47>:
.globl vector47
vector47:
  pushl $0
80107d07:	6a 00                	push   $0x0
  pushl $47
80107d09:	6a 2f                	push   $0x2f
  jmp alltraps
80107d0b:	e9 33 f8 ff ff       	jmp    80107543 <alltraps>

80107d10 <vector48>:
.globl vector48
vector48:
  pushl $0
80107d10:	6a 00                	push   $0x0
  pushl $48
80107d12:	6a 30                	push   $0x30
  jmp alltraps
80107d14:	e9 2a f8 ff ff       	jmp    80107543 <alltraps>

80107d19 <vector49>:
.globl vector49
vector49:
  pushl $0
80107d19:	6a 00                	push   $0x0
  pushl $49
80107d1b:	6a 31                	push   $0x31
  jmp alltraps
80107d1d:	e9 21 f8 ff ff       	jmp    80107543 <alltraps>

80107d22 <vector50>:
.globl vector50
vector50:
  pushl $0
80107d22:	6a 00                	push   $0x0
  pushl $50
80107d24:	6a 32                	push   $0x32
  jmp alltraps
80107d26:	e9 18 f8 ff ff       	jmp    80107543 <alltraps>

80107d2b <vector51>:
.globl vector51
vector51:
  pushl $0
80107d2b:	6a 00                	push   $0x0
  pushl $51
80107d2d:	6a 33                	push   $0x33
  jmp alltraps
80107d2f:	e9 0f f8 ff ff       	jmp    80107543 <alltraps>

80107d34 <vector52>:
.globl vector52
vector52:
  pushl $0
80107d34:	6a 00                	push   $0x0
  pushl $52
80107d36:	6a 34                	push   $0x34
  jmp alltraps
80107d38:	e9 06 f8 ff ff       	jmp    80107543 <alltraps>

80107d3d <vector53>:
.globl vector53
vector53:
  pushl $0
80107d3d:	6a 00                	push   $0x0
  pushl $53
80107d3f:	6a 35                	push   $0x35
  jmp alltraps
80107d41:	e9 fd f7 ff ff       	jmp    80107543 <alltraps>

80107d46 <vector54>:
.globl vector54
vector54:
  pushl $0
80107d46:	6a 00                	push   $0x0
  pushl $54
80107d48:	6a 36                	push   $0x36
  jmp alltraps
80107d4a:	e9 f4 f7 ff ff       	jmp    80107543 <alltraps>

80107d4f <vector55>:
.globl vector55
vector55:
  pushl $0
80107d4f:	6a 00                	push   $0x0
  pushl $55
80107d51:	6a 37                	push   $0x37
  jmp alltraps
80107d53:	e9 eb f7 ff ff       	jmp    80107543 <alltraps>

80107d58 <vector56>:
.globl vector56
vector56:
  pushl $0
80107d58:	6a 00                	push   $0x0
  pushl $56
80107d5a:	6a 38                	push   $0x38
  jmp alltraps
80107d5c:	e9 e2 f7 ff ff       	jmp    80107543 <alltraps>

80107d61 <vector57>:
.globl vector57
vector57:
  pushl $0
80107d61:	6a 00                	push   $0x0
  pushl $57
80107d63:	6a 39                	push   $0x39
  jmp alltraps
80107d65:	e9 d9 f7 ff ff       	jmp    80107543 <alltraps>

80107d6a <vector58>:
.globl vector58
vector58:
  pushl $0
80107d6a:	6a 00                	push   $0x0
  pushl $58
80107d6c:	6a 3a                	push   $0x3a
  jmp alltraps
80107d6e:	e9 d0 f7 ff ff       	jmp    80107543 <alltraps>

80107d73 <vector59>:
.globl vector59
vector59:
  pushl $0
80107d73:	6a 00                	push   $0x0
  pushl $59
80107d75:	6a 3b                	push   $0x3b
  jmp alltraps
80107d77:	e9 c7 f7 ff ff       	jmp    80107543 <alltraps>

80107d7c <vector60>:
.globl vector60
vector60:
  pushl $0
80107d7c:	6a 00                	push   $0x0
  pushl $60
80107d7e:	6a 3c                	push   $0x3c
  jmp alltraps
80107d80:	e9 be f7 ff ff       	jmp    80107543 <alltraps>

80107d85 <vector61>:
.globl vector61
vector61:
  pushl $0
80107d85:	6a 00                	push   $0x0
  pushl $61
80107d87:	6a 3d                	push   $0x3d
  jmp alltraps
80107d89:	e9 b5 f7 ff ff       	jmp    80107543 <alltraps>

80107d8e <vector62>:
.globl vector62
vector62:
  pushl $0
80107d8e:	6a 00                	push   $0x0
  pushl $62
80107d90:	6a 3e                	push   $0x3e
  jmp alltraps
80107d92:	e9 ac f7 ff ff       	jmp    80107543 <alltraps>

80107d97 <vector63>:
.globl vector63
vector63:
  pushl $0
80107d97:	6a 00                	push   $0x0
  pushl $63
80107d99:	6a 3f                	push   $0x3f
  jmp alltraps
80107d9b:	e9 a3 f7 ff ff       	jmp    80107543 <alltraps>

80107da0 <vector64>:
.globl vector64
vector64:
  pushl $0
80107da0:	6a 00                	push   $0x0
  pushl $64
80107da2:	6a 40                	push   $0x40
  jmp alltraps
80107da4:	e9 9a f7 ff ff       	jmp    80107543 <alltraps>

80107da9 <vector65>:
.globl vector65
vector65:
  pushl $0
80107da9:	6a 00                	push   $0x0
  pushl $65
80107dab:	6a 41                	push   $0x41
  jmp alltraps
80107dad:	e9 91 f7 ff ff       	jmp    80107543 <alltraps>

80107db2 <vector66>:
.globl vector66
vector66:
  pushl $0
80107db2:	6a 00                	push   $0x0
  pushl $66
80107db4:	6a 42                	push   $0x42
  jmp alltraps
80107db6:	e9 88 f7 ff ff       	jmp    80107543 <alltraps>

80107dbb <vector67>:
.globl vector67
vector67:
  pushl $0
80107dbb:	6a 00                	push   $0x0
  pushl $67
80107dbd:	6a 43                	push   $0x43
  jmp alltraps
80107dbf:	e9 7f f7 ff ff       	jmp    80107543 <alltraps>

80107dc4 <vector68>:
.globl vector68
vector68:
  pushl $0
80107dc4:	6a 00                	push   $0x0
  pushl $68
80107dc6:	6a 44                	push   $0x44
  jmp alltraps
80107dc8:	e9 76 f7 ff ff       	jmp    80107543 <alltraps>

80107dcd <vector69>:
.globl vector69
vector69:
  pushl $0
80107dcd:	6a 00                	push   $0x0
  pushl $69
80107dcf:	6a 45                	push   $0x45
  jmp alltraps
80107dd1:	e9 6d f7 ff ff       	jmp    80107543 <alltraps>

80107dd6 <vector70>:
.globl vector70
vector70:
  pushl $0
80107dd6:	6a 00                	push   $0x0
  pushl $70
80107dd8:	6a 46                	push   $0x46
  jmp alltraps
80107dda:	e9 64 f7 ff ff       	jmp    80107543 <alltraps>

80107ddf <vector71>:
.globl vector71
vector71:
  pushl $0
80107ddf:	6a 00                	push   $0x0
  pushl $71
80107de1:	6a 47                	push   $0x47
  jmp alltraps
80107de3:	e9 5b f7 ff ff       	jmp    80107543 <alltraps>

80107de8 <vector72>:
.globl vector72
vector72:
  pushl $0
80107de8:	6a 00                	push   $0x0
  pushl $72
80107dea:	6a 48                	push   $0x48
  jmp alltraps
80107dec:	e9 52 f7 ff ff       	jmp    80107543 <alltraps>

80107df1 <vector73>:
.globl vector73
vector73:
  pushl $0
80107df1:	6a 00                	push   $0x0
  pushl $73
80107df3:	6a 49                	push   $0x49
  jmp alltraps
80107df5:	e9 49 f7 ff ff       	jmp    80107543 <alltraps>

80107dfa <vector74>:
.globl vector74
vector74:
  pushl $0
80107dfa:	6a 00                	push   $0x0
  pushl $74
80107dfc:	6a 4a                	push   $0x4a
  jmp alltraps
80107dfe:	e9 40 f7 ff ff       	jmp    80107543 <alltraps>

80107e03 <vector75>:
.globl vector75
vector75:
  pushl $0
80107e03:	6a 00                	push   $0x0
  pushl $75
80107e05:	6a 4b                	push   $0x4b
  jmp alltraps
80107e07:	e9 37 f7 ff ff       	jmp    80107543 <alltraps>

80107e0c <vector76>:
.globl vector76
vector76:
  pushl $0
80107e0c:	6a 00                	push   $0x0
  pushl $76
80107e0e:	6a 4c                	push   $0x4c
  jmp alltraps
80107e10:	e9 2e f7 ff ff       	jmp    80107543 <alltraps>

80107e15 <vector77>:
.globl vector77
vector77:
  pushl $0
80107e15:	6a 00                	push   $0x0
  pushl $77
80107e17:	6a 4d                	push   $0x4d
  jmp alltraps
80107e19:	e9 25 f7 ff ff       	jmp    80107543 <alltraps>

80107e1e <vector78>:
.globl vector78
vector78:
  pushl $0
80107e1e:	6a 00                	push   $0x0
  pushl $78
80107e20:	6a 4e                	push   $0x4e
  jmp alltraps
80107e22:	e9 1c f7 ff ff       	jmp    80107543 <alltraps>

80107e27 <vector79>:
.globl vector79
vector79:
  pushl $0
80107e27:	6a 00                	push   $0x0
  pushl $79
80107e29:	6a 4f                	push   $0x4f
  jmp alltraps
80107e2b:	e9 13 f7 ff ff       	jmp    80107543 <alltraps>

80107e30 <vector80>:
.globl vector80
vector80:
  pushl $0
80107e30:	6a 00                	push   $0x0
  pushl $80
80107e32:	6a 50                	push   $0x50
  jmp alltraps
80107e34:	e9 0a f7 ff ff       	jmp    80107543 <alltraps>

80107e39 <vector81>:
.globl vector81
vector81:
  pushl $0
80107e39:	6a 00                	push   $0x0
  pushl $81
80107e3b:	6a 51                	push   $0x51
  jmp alltraps
80107e3d:	e9 01 f7 ff ff       	jmp    80107543 <alltraps>

80107e42 <vector82>:
.globl vector82
vector82:
  pushl $0
80107e42:	6a 00                	push   $0x0
  pushl $82
80107e44:	6a 52                	push   $0x52
  jmp alltraps
80107e46:	e9 f8 f6 ff ff       	jmp    80107543 <alltraps>

80107e4b <vector83>:
.globl vector83
vector83:
  pushl $0
80107e4b:	6a 00                	push   $0x0
  pushl $83
80107e4d:	6a 53                	push   $0x53
  jmp alltraps
80107e4f:	e9 ef f6 ff ff       	jmp    80107543 <alltraps>

80107e54 <vector84>:
.globl vector84
vector84:
  pushl $0
80107e54:	6a 00                	push   $0x0
  pushl $84
80107e56:	6a 54                	push   $0x54
  jmp alltraps
80107e58:	e9 e6 f6 ff ff       	jmp    80107543 <alltraps>

80107e5d <vector85>:
.globl vector85
vector85:
  pushl $0
80107e5d:	6a 00                	push   $0x0
  pushl $85
80107e5f:	6a 55                	push   $0x55
  jmp alltraps
80107e61:	e9 dd f6 ff ff       	jmp    80107543 <alltraps>

80107e66 <vector86>:
.globl vector86
vector86:
  pushl $0
80107e66:	6a 00                	push   $0x0
  pushl $86
80107e68:	6a 56                	push   $0x56
  jmp alltraps
80107e6a:	e9 d4 f6 ff ff       	jmp    80107543 <alltraps>

80107e6f <vector87>:
.globl vector87
vector87:
  pushl $0
80107e6f:	6a 00                	push   $0x0
  pushl $87
80107e71:	6a 57                	push   $0x57
  jmp alltraps
80107e73:	e9 cb f6 ff ff       	jmp    80107543 <alltraps>

80107e78 <vector88>:
.globl vector88
vector88:
  pushl $0
80107e78:	6a 00                	push   $0x0
  pushl $88
80107e7a:	6a 58                	push   $0x58
  jmp alltraps
80107e7c:	e9 c2 f6 ff ff       	jmp    80107543 <alltraps>

80107e81 <vector89>:
.globl vector89
vector89:
  pushl $0
80107e81:	6a 00                	push   $0x0
  pushl $89
80107e83:	6a 59                	push   $0x59
  jmp alltraps
80107e85:	e9 b9 f6 ff ff       	jmp    80107543 <alltraps>

80107e8a <vector90>:
.globl vector90
vector90:
  pushl $0
80107e8a:	6a 00                	push   $0x0
  pushl $90
80107e8c:	6a 5a                	push   $0x5a
  jmp alltraps
80107e8e:	e9 b0 f6 ff ff       	jmp    80107543 <alltraps>

80107e93 <vector91>:
.globl vector91
vector91:
  pushl $0
80107e93:	6a 00                	push   $0x0
  pushl $91
80107e95:	6a 5b                	push   $0x5b
  jmp alltraps
80107e97:	e9 a7 f6 ff ff       	jmp    80107543 <alltraps>

80107e9c <vector92>:
.globl vector92
vector92:
  pushl $0
80107e9c:	6a 00                	push   $0x0
  pushl $92
80107e9e:	6a 5c                	push   $0x5c
  jmp alltraps
80107ea0:	e9 9e f6 ff ff       	jmp    80107543 <alltraps>

80107ea5 <vector93>:
.globl vector93
vector93:
  pushl $0
80107ea5:	6a 00                	push   $0x0
  pushl $93
80107ea7:	6a 5d                	push   $0x5d
  jmp alltraps
80107ea9:	e9 95 f6 ff ff       	jmp    80107543 <alltraps>

80107eae <vector94>:
.globl vector94
vector94:
  pushl $0
80107eae:	6a 00                	push   $0x0
  pushl $94
80107eb0:	6a 5e                	push   $0x5e
  jmp alltraps
80107eb2:	e9 8c f6 ff ff       	jmp    80107543 <alltraps>

80107eb7 <vector95>:
.globl vector95
vector95:
  pushl $0
80107eb7:	6a 00                	push   $0x0
  pushl $95
80107eb9:	6a 5f                	push   $0x5f
  jmp alltraps
80107ebb:	e9 83 f6 ff ff       	jmp    80107543 <alltraps>

80107ec0 <vector96>:
.globl vector96
vector96:
  pushl $0
80107ec0:	6a 00                	push   $0x0
  pushl $96
80107ec2:	6a 60                	push   $0x60
  jmp alltraps
80107ec4:	e9 7a f6 ff ff       	jmp    80107543 <alltraps>

80107ec9 <vector97>:
.globl vector97
vector97:
  pushl $0
80107ec9:	6a 00                	push   $0x0
  pushl $97
80107ecb:	6a 61                	push   $0x61
  jmp alltraps
80107ecd:	e9 71 f6 ff ff       	jmp    80107543 <alltraps>

80107ed2 <vector98>:
.globl vector98
vector98:
  pushl $0
80107ed2:	6a 00                	push   $0x0
  pushl $98
80107ed4:	6a 62                	push   $0x62
  jmp alltraps
80107ed6:	e9 68 f6 ff ff       	jmp    80107543 <alltraps>

80107edb <vector99>:
.globl vector99
vector99:
  pushl $0
80107edb:	6a 00                	push   $0x0
  pushl $99
80107edd:	6a 63                	push   $0x63
  jmp alltraps
80107edf:	e9 5f f6 ff ff       	jmp    80107543 <alltraps>

80107ee4 <vector100>:
.globl vector100
vector100:
  pushl $0
80107ee4:	6a 00                	push   $0x0
  pushl $100
80107ee6:	6a 64                	push   $0x64
  jmp alltraps
80107ee8:	e9 56 f6 ff ff       	jmp    80107543 <alltraps>

80107eed <vector101>:
.globl vector101
vector101:
  pushl $0
80107eed:	6a 00                	push   $0x0
  pushl $101
80107eef:	6a 65                	push   $0x65
  jmp alltraps
80107ef1:	e9 4d f6 ff ff       	jmp    80107543 <alltraps>

80107ef6 <vector102>:
.globl vector102
vector102:
  pushl $0
80107ef6:	6a 00                	push   $0x0
  pushl $102
80107ef8:	6a 66                	push   $0x66
  jmp alltraps
80107efa:	e9 44 f6 ff ff       	jmp    80107543 <alltraps>

80107eff <vector103>:
.globl vector103
vector103:
  pushl $0
80107eff:	6a 00                	push   $0x0
  pushl $103
80107f01:	6a 67                	push   $0x67
  jmp alltraps
80107f03:	e9 3b f6 ff ff       	jmp    80107543 <alltraps>

80107f08 <vector104>:
.globl vector104
vector104:
  pushl $0
80107f08:	6a 00                	push   $0x0
  pushl $104
80107f0a:	6a 68                	push   $0x68
  jmp alltraps
80107f0c:	e9 32 f6 ff ff       	jmp    80107543 <alltraps>

80107f11 <vector105>:
.globl vector105
vector105:
  pushl $0
80107f11:	6a 00                	push   $0x0
  pushl $105
80107f13:	6a 69                	push   $0x69
  jmp alltraps
80107f15:	e9 29 f6 ff ff       	jmp    80107543 <alltraps>

80107f1a <vector106>:
.globl vector106
vector106:
  pushl $0
80107f1a:	6a 00                	push   $0x0
  pushl $106
80107f1c:	6a 6a                	push   $0x6a
  jmp alltraps
80107f1e:	e9 20 f6 ff ff       	jmp    80107543 <alltraps>

80107f23 <vector107>:
.globl vector107
vector107:
  pushl $0
80107f23:	6a 00                	push   $0x0
  pushl $107
80107f25:	6a 6b                	push   $0x6b
  jmp alltraps
80107f27:	e9 17 f6 ff ff       	jmp    80107543 <alltraps>

80107f2c <vector108>:
.globl vector108
vector108:
  pushl $0
80107f2c:	6a 00                	push   $0x0
  pushl $108
80107f2e:	6a 6c                	push   $0x6c
  jmp alltraps
80107f30:	e9 0e f6 ff ff       	jmp    80107543 <alltraps>

80107f35 <vector109>:
.globl vector109
vector109:
  pushl $0
80107f35:	6a 00                	push   $0x0
  pushl $109
80107f37:	6a 6d                	push   $0x6d
  jmp alltraps
80107f39:	e9 05 f6 ff ff       	jmp    80107543 <alltraps>

80107f3e <vector110>:
.globl vector110
vector110:
  pushl $0
80107f3e:	6a 00                	push   $0x0
  pushl $110
80107f40:	6a 6e                	push   $0x6e
  jmp alltraps
80107f42:	e9 fc f5 ff ff       	jmp    80107543 <alltraps>

80107f47 <vector111>:
.globl vector111
vector111:
  pushl $0
80107f47:	6a 00                	push   $0x0
  pushl $111
80107f49:	6a 6f                	push   $0x6f
  jmp alltraps
80107f4b:	e9 f3 f5 ff ff       	jmp    80107543 <alltraps>

80107f50 <vector112>:
.globl vector112
vector112:
  pushl $0
80107f50:	6a 00                	push   $0x0
  pushl $112
80107f52:	6a 70                	push   $0x70
  jmp alltraps
80107f54:	e9 ea f5 ff ff       	jmp    80107543 <alltraps>

80107f59 <vector113>:
.globl vector113
vector113:
  pushl $0
80107f59:	6a 00                	push   $0x0
  pushl $113
80107f5b:	6a 71                	push   $0x71
  jmp alltraps
80107f5d:	e9 e1 f5 ff ff       	jmp    80107543 <alltraps>

80107f62 <vector114>:
.globl vector114
vector114:
  pushl $0
80107f62:	6a 00                	push   $0x0
  pushl $114
80107f64:	6a 72                	push   $0x72
  jmp alltraps
80107f66:	e9 d8 f5 ff ff       	jmp    80107543 <alltraps>

80107f6b <vector115>:
.globl vector115
vector115:
  pushl $0
80107f6b:	6a 00                	push   $0x0
  pushl $115
80107f6d:	6a 73                	push   $0x73
  jmp alltraps
80107f6f:	e9 cf f5 ff ff       	jmp    80107543 <alltraps>

80107f74 <vector116>:
.globl vector116
vector116:
  pushl $0
80107f74:	6a 00                	push   $0x0
  pushl $116
80107f76:	6a 74                	push   $0x74
  jmp alltraps
80107f78:	e9 c6 f5 ff ff       	jmp    80107543 <alltraps>

80107f7d <vector117>:
.globl vector117
vector117:
  pushl $0
80107f7d:	6a 00                	push   $0x0
  pushl $117
80107f7f:	6a 75                	push   $0x75
  jmp alltraps
80107f81:	e9 bd f5 ff ff       	jmp    80107543 <alltraps>

80107f86 <vector118>:
.globl vector118
vector118:
  pushl $0
80107f86:	6a 00                	push   $0x0
  pushl $118
80107f88:	6a 76                	push   $0x76
  jmp alltraps
80107f8a:	e9 b4 f5 ff ff       	jmp    80107543 <alltraps>

80107f8f <vector119>:
.globl vector119
vector119:
  pushl $0
80107f8f:	6a 00                	push   $0x0
  pushl $119
80107f91:	6a 77                	push   $0x77
  jmp alltraps
80107f93:	e9 ab f5 ff ff       	jmp    80107543 <alltraps>

80107f98 <vector120>:
.globl vector120
vector120:
  pushl $0
80107f98:	6a 00                	push   $0x0
  pushl $120
80107f9a:	6a 78                	push   $0x78
  jmp alltraps
80107f9c:	e9 a2 f5 ff ff       	jmp    80107543 <alltraps>

80107fa1 <vector121>:
.globl vector121
vector121:
  pushl $0
80107fa1:	6a 00                	push   $0x0
  pushl $121
80107fa3:	6a 79                	push   $0x79
  jmp alltraps
80107fa5:	e9 99 f5 ff ff       	jmp    80107543 <alltraps>

80107faa <vector122>:
.globl vector122
vector122:
  pushl $0
80107faa:	6a 00                	push   $0x0
  pushl $122
80107fac:	6a 7a                	push   $0x7a
  jmp alltraps
80107fae:	e9 90 f5 ff ff       	jmp    80107543 <alltraps>

80107fb3 <vector123>:
.globl vector123
vector123:
  pushl $0
80107fb3:	6a 00                	push   $0x0
  pushl $123
80107fb5:	6a 7b                	push   $0x7b
  jmp alltraps
80107fb7:	e9 87 f5 ff ff       	jmp    80107543 <alltraps>

80107fbc <vector124>:
.globl vector124
vector124:
  pushl $0
80107fbc:	6a 00                	push   $0x0
  pushl $124
80107fbe:	6a 7c                	push   $0x7c
  jmp alltraps
80107fc0:	e9 7e f5 ff ff       	jmp    80107543 <alltraps>

80107fc5 <vector125>:
.globl vector125
vector125:
  pushl $0
80107fc5:	6a 00                	push   $0x0
  pushl $125
80107fc7:	6a 7d                	push   $0x7d
  jmp alltraps
80107fc9:	e9 75 f5 ff ff       	jmp    80107543 <alltraps>

80107fce <vector126>:
.globl vector126
vector126:
  pushl $0
80107fce:	6a 00                	push   $0x0
  pushl $126
80107fd0:	6a 7e                	push   $0x7e
  jmp alltraps
80107fd2:	e9 6c f5 ff ff       	jmp    80107543 <alltraps>

80107fd7 <vector127>:
.globl vector127
vector127:
  pushl $0
80107fd7:	6a 00                	push   $0x0
  pushl $127
80107fd9:	6a 7f                	push   $0x7f
  jmp alltraps
80107fdb:	e9 63 f5 ff ff       	jmp    80107543 <alltraps>

80107fe0 <vector128>:
.globl vector128
vector128:
  pushl $0
80107fe0:	6a 00                	push   $0x0
  pushl $128
80107fe2:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107fe7:	e9 57 f5 ff ff       	jmp    80107543 <alltraps>

80107fec <vector129>:
.globl vector129
vector129:
  pushl $0
80107fec:	6a 00                	push   $0x0
  pushl $129
80107fee:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107ff3:	e9 4b f5 ff ff       	jmp    80107543 <alltraps>

80107ff8 <vector130>:
.globl vector130
vector130:
  pushl $0
80107ff8:	6a 00                	push   $0x0
  pushl $130
80107ffa:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107fff:	e9 3f f5 ff ff       	jmp    80107543 <alltraps>

80108004 <vector131>:
.globl vector131
vector131:
  pushl $0
80108004:	6a 00                	push   $0x0
  pushl $131
80108006:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010800b:	e9 33 f5 ff ff       	jmp    80107543 <alltraps>

80108010 <vector132>:
.globl vector132
vector132:
  pushl $0
80108010:	6a 00                	push   $0x0
  pushl $132
80108012:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108017:	e9 27 f5 ff ff       	jmp    80107543 <alltraps>

8010801c <vector133>:
.globl vector133
vector133:
  pushl $0
8010801c:	6a 00                	push   $0x0
  pushl $133
8010801e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108023:	e9 1b f5 ff ff       	jmp    80107543 <alltraps>

80108028 <vector134>:
.globl vector134
vector134:
  pushl $0
80108028:	6a 00                	push   $0x0
  pushl $134
8010802a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010802f:	e9 0f f5 ff ff       	jmp    80107543 <alltraps>

80108034 <vector135>:
.globl vector135
vector135:
  pushl $0
80108034:	6a 00                	push   $0x0
  pushl $135
80108036:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010803b:	e9 03 f5 ff ff       	jmp    80107543 <alltraps>

80108040 <vector136>:
.globl vector136
vector136:
  pushl $0
80108040:	6a 00                	push   $0x0
  pushl $136
80108042:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108047:	e9 f7 f4 ff ff       	jmp    80107543 <alltraps>

8010804c <vector137>:
.globl vector137
vector137:
  pushl $0
8010804c:	6a 00                	push   $0x0
  pushl $137
8010804e:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108053:	e9 eb f4 ff ff       	jmp    80107543 <alltraps>

80108058 <vector138>:
.globl vector138
vector138:
  pushl $0
80108058:	6a 00                	push   $0x0
  pushl $138
8010805a:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010805f:	e9 df f4 ff ff       	jmp    80107543 <alltraps>

80108064 <vector139>:
.globl vector139
vector139:
  pushl $0
80108064:	6a 00                	push   $0x0
  pushl $139
80108066:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010806b:	e9 d3 f4 ff ff       	jmp    80107543 <alltraps>

80108070 <vector140>:
.globl vector140
vector140:
  pushl $0
80108070:	6a 00                	push   $0x0
  pushl $140
80108072:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108077:	e9 c7 f4 ff ff       	jmp    80107543 <alltraps>

8010807c <vector141>:
.globl vector141
vector141:
  pushl $0
8010807c:	6a 00                	push   $0x0
  pushl $141
8010807e:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108083:	e9 bb f4 ff ff       	jmp    80107543 <alltraps>

80108088 <vector142>:
.globl vector142
vector142:
  pushl $0
80108088:	6a 00                	push   $0x0
  pushl $142
8010808a:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010808f:	e9 af f4 ff ff       	jmp    80107543 <alltraps>

80108094 <vector143>:
.globl vector143
vector143:
  pushl $0
80108094:	6a 00                	push   $0x0
  pushl $143
80108096:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010809b:	e9 a3 f4 ff ff       	jmp    80107543 <alltraps>

801080a0 <vector144>:
.globl vector144
vector144:
  pushl $0
801080a0:	6a 00                	push   $0x0
  pushl $144
801080a2:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801080a7:	e9 97 f4 ff ff       	jmp    80107543 <alltraps>

801080ac <vector145>:
.globl vector145
vector145:
  pushl $0
801080ac:	6a 00                	push   $0x0
  pushl $145
801080ae:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801080b3:	e9 8b f4 ff ff       	jmp    80107543 <alltraps>

801080b8 <vector146>:
.globl vector146
vector146:
  pushl $0
801080b8:	6a 00                	push   $0x0
  pushl $146
801080ba:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801080bf:	e9 7f f4 ff ff       	jmp    80107543 <alltraps>

801080c4 <vector147>:
.globl vector147
vector147:
  pushl $0
801080c4:	6a 00                	push   $0x0
  pushl $147
801080c6:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801080cb:	e9 73 f4 ff ff       	jmp    80107543 <alltraps>

801080d0 <vector148>:
.globl vector148
vector148:
  pushl $0
801080d0:	6a 00                	push   $0x0
  pushl $148
801080d2:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801080d7:	e9 67 f4 ff ff       	jmp    80107543 <alltraps>

801080dc <vector149>:
.globl vector149
vector149:
  pushl $0
801080dc:	6a 00                	push   $0x0
  pushl $149
801080de:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801080e3:	e9 5b f4 ff ff       	jmp    80107543 <alltraps>

801080e8 <vector150>:
.globl vector150
vector150:
  pushl $0
801080e8:	6a 00                	push   $0x0
  pushl $150
801080ea:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801080ef:	e9 4f f4 ff ff       	jmp    80107543 <alltraps>

801080f4 <vector151>:
.globl vector151
vector151:
  pushl $0
801080f4:	6a 00                	push   $0x0
  pushl $151
801080f6:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801080fb:	e9 43 f4 ff ff       	jmp    80107543 <alltraps>

80108100 <vector152>:
.globl vector152
vector152:
  pushl $0
80108100:	6a 00                	push   $0x0
  pushl $152
80108102:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108107:	e9 37 f4 ff ff       	jmp    80107543 <alltraps>

8010810c <vector153>:
.globl vector153
vector153:
  pushl $0
8010810c:	6a 00                	push   $0x0
  pushl $153
8010810e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108113:	e9 2b f4 ff ff       	jmp    80107543 <alltraps>

80108118 <vector154>:
.globl vector154
vector154:
  pushl $0
80108118:	6a 00                	push   $0x0
  pushl $154
8010811a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010811f:	e9 1f f4 ff ff       	jmp    80107543 <alltraps>

80108124 <vector155>:
.globl vector155
vector155:
  pushl $0
80108124:	6a 00                	push   $0x0
  pushl $155
80108126:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010812b:	e9 13 f4 ff ff       	jmp    80107543 <alltraps>

80108130 <vector156>:
.globl vector156
vector156:
  pushl $0
80108130:	6a 00                	push   $0x0
  pushl $156
80108132:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108137:	e9 07 f4 ff ff       	jmp    80107543 <alltraps>

8010813c <vector157>:
.globl vector157
vector157:
  pushl $0
8010813c:	6a 00                	push   $0x0
  pushl $157
8010813e:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108143:	e9 fb f3 ff ff       	jmp    80107543 <alltraps>

80108148 <vector158>:
.globl vector158
vector158:
  pushl $0
80108148:	6a 00                	push   $0x0
  pushl $158
8010814a:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010814f:	e9 ef f3 ff ff       	jmp    80107543 <alltraps>

80108154 <vector159>:
.globl vector159
vector159:
  pushl $0
80108154:	6a 00                	push   $0x0
  pushl $159
80108156:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010815b:	e9 e3 f3 ff ff       	jmp    80107543 <alltraps>

80108160 <vector160>:
.globl vector160
vector160:
  pushl $0
80108160:	6a 00                	push   $0x0
  pushl $160
80108162:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108167:	e9 d7 f3 ff ff       	jmp    80107543 <alltraps>

8010816c <vector161>:
.globl vector161
vector161:
  pushl $0
8010816c:	6a 00                	push   $0x0
  pushl $161
8010816e:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108173:	e9 cb f3 ff ff       	jmp    80107543 <alltraps>

80108178 <vector162>:
.globl vector162
vector162:
  pushl $0
80108178:	6a 00                	push   $0x0
  pushl $162
8010817a:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010817f:	e9 bf f3 ff ff       	jmp    80107543 <alltraps>

80108184 <vector163>:
.globl vector163
vector163:
  pushl $0
80108184:	6a 00                	push   $0x0
  pushl $163
80108186:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010818b:	e9 b3 f3 ff ff       	jmp    80107543 <alltraps>

80108190 <vector164>:
.globl vector164
vector164:
  pushl $0
80108190:	6a 00                	push   $0x0
  pushl $164
80108192:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108197:	e9 a7 f3 ff ff       	jmp    80107543 <alltraps>

8010819c <vector165>:
.globl vector165
vector165:
  pushl $0
8010819c:	6a 00                	push   $0x0
  pushl $165
8010819e:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801081a3:	e9 9b f3 ff ff       	jmp    80107543 <alltraps>

801081a8 <vector166>:
.globl vector166
vector166:
  pushl $0
801081a8:	6a 00                	push   $0x0
  pushl $166
801081aa:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801081af:	e9 8f f3 ff ff       	jmp    80107543 <alltraps>

801081b4 <vector167>:
.globl vector167
vector167:
  pushl $0
801081b4:	6a 00                	push   $0x0
  pushl $167
801081b6:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801081bb:	e9 83 f3 ff ff       	jmp    80107543 <alltraps>

801081c0 <vector168>:
.globl vector168
vector168:
  pushl $0
801081c0:	6a 00                	push   $0x0
  pushl $168
801081c2:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801081c7:	e9 77 f3 ff ff       	jmp    80107543 <alltraps>

801081cc <vector169>:
.globl vector169
vector169:
  pushl $0
801081cc:	6a 00                	push   $0x0
  pushl $169
801081ce:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801081d3:	e9 6b f3 ff ff       	jmp    80107543 <alltraps>

801081d8 <vector170>:
.globl vector170
vector170:
  pushl $0
801081d8:	6a 00                	push   $0x0
  pushl $170
801081da:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801081df:	e9 5f f3 ff ff       	jmp    80107543 <alltraps>

801081e4 <vector171>:
.globl vector171
vector171:
  pushl $0
801081e4:	6a 00                	push   $0x0
  pushl $171
801081e6:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801081eb:	e9 53 f3 ff ff       	jmp    80107543 <alltraps>

801081f0 <vector172>:
.globl vector172
vector172:
  pushl $0
801081f0:	6a 00                	push   $0x0
  pushl $172
801081f2:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801081f7:	e9 47 f3 ff ff       	jmp    80107543 <alltraps>

801081fc <vector173>:
.globl vector173
vector173:
  pushl $0
801081fc:	6a 00                	push   $0x0
  pushl $173
801081fe:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108203:	e9 3b f3 ff ff       	jmp    80107543 <alltraps>

80108208 <vector174>:
.globl vector174
vector174:
  pushl $0
80108208:	6a 00                	push   $0x0
  pushl $174
8010820a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010820f:	e9 2f f3 ff ff       	jmp    80107543 <alltraps>

80108214 <vector175>:
.globl vector175
vector175:
  pushl $0
80108214:	6a 00                	push   $0x0
  pushl $175
80108216:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010821b:	e9 23 f3 ff ff       	jmp    80107543 <alltraps>

80108220 <vector176>:
.globl vector176
vector176:
  pushl $0
80108220:	6a 00                	push   $0x0
  pushl $176
80108222:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108227:	e9 17 f3 ff ff       	jmp    80107543 <alltraps>

8010822c <vector177>:
.globl vector177
vector177:
  pushl $0
8010822c:	6a 00                	push   $0x0
  pushl $177
8010822e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108233:	e9 0b f3 ff ff       	jmp    80107543 <alltraps>

80108238 <vector178>:
.globl vector178
vector178:
  pushl $0
80108238:	6a 00                	push   $0x0
  pushl $178
8010823a:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010823f:	e9 ff f2 ff ff       	jmp    80107543 <alltraps>

80108244 <vector179>:
.globl vector179
vector179:
  pushl $0
80108244:	6a 00                	push   $0x0
  pushl $179
80108246:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010824b:	e9 f3 f2 ff ff       	jmp    80107543 <alltraps>

80108250 <vector180>:
.globl vector180
vector180:
  pushl $0
80108250:	6a 00                	push   $0x0
  pushl $180
80108252:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108257:	e9 e7 f2 ff ff       	jmp    80107543 <alltraps>

8010825c <vector181>:
.globl vector181
vector181:
  pushl $0
8010825c:	6a 00                	push   $0x0
  pushl $181
8010825e:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108263:	e9 db f2 ff ff       	jmp    80107543 <alltraps>

80108268 <vector182>:
.globl vector182
vector182:
  pushl $0
80108268:	6a 00                	push   $0x0
  pushl $182
8010826a:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010826f:	e9 cf f2 ff ff       	jmp    80107543 <alltraps>

80108274 <vector183>:
.globl vector183
vector183:
  pushl $0
80108274:	6a 00                	push   $0x0
  pushl $183
80108276:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010827b:	e9 c3 f2 ff ff       	jmp    80107543 <alltraps>

80108280 <vector184>:
.globl vector184
vector184:
  pushl $0
80108280:	6a 00                	push   $0x0
  pushl $184
80108282:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108287:	e9 b7 f2 ff ff       	jmp    80107543 <alltraps>

8010828c <vector185>:
.globl vector185
vector185:
  pushl $0
8010828c:	6a 00                	push   $0x0
  pushl $185
8010828e:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108293:	e9 ab f2 ff ff       	jmp    80107543 <alltraps>

80108298 <vector186>:
.globl vector186
vector186:
  pushl $0
80108298:	6a 00                	push   $0x0
  pushl $186
8010829a:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010829f:	e9 9f f2 ff ff       	jmp    80107543 <alltraps>

801082a4 <vector187>:
.globl vector187
vector187:
  pushl $0
801082a4:	6a 00                	push   $0x0
  pushl $187
801082a6:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801082ab:	e9 93 f2 ff ff       	jmp    80107543 <alltraps>

801082b0 <vector188>:
.globl vector188
vector188:
  pushl $0
801082b0:	6a 00                	push   $0x0
  pushl $188
801082b2:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801082b7:	e9 87 f2 ff ff       	jmp    80107543 <alltraps>

801082bc <vector189>:
.globl vector189
vector189:
  pushl $0
801082bc:	6a 00                	push   $0x0
  pushl $189
801082be:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801082c3:	e9 7b f2 ff ff       	jmp    80107543 <alltraps>

801082c8 <vector190>:
.globl vector190
vector190:
  pushl $0
801082c8:	6a 00                	push   $0x0
  pushl $190
801082ca:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801082cf:	e9 6f f2 ff ff       	jmp    80107543 <alltraps>

801082d4 <vector191>:
.globl vector191
vector191:
  pushl $0
801082d4:	6a 00                	push   $0x0
  pushl $191
801082d6:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801082db:	e9 63 f2 ff ff       	jmp    80107543 <alltraps>

801082e0 <vector192>:
.globl vector192
vector192:
  pushl $0
801082e0:	6a 00                	push   $0x0
  pushl $192
801082e2:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801082e7:	e9 57 f2 ff ff       	jmp    80107543 <alltraps>

801082ec <vector193>:
.globl vector193
vector193:
  pushl $0
801082ec:	6a 00                	push   $0x0
  pushl $193
801082ee:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801082f3:	e9 4b f2 ff ff       	jmp    80107543 <alltraps>

801082f8 <vector194>:
.globl vector194
vector194:
  pushl $0
801082f8:	6a 00                	push   $0x0
  pushl $194
801082fa:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801082ff:	e9 3f f2 ff ff       	jmp    80107543 <alltraps>

80108304 <vector195>:
.globl vector195
vector195:
  pushl $0
80108304:	6a 00                	push   $0x0
  pushl $195
80108306:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010830b:	e9 33 f2 ff ff       	jmp    80107543 <alltraps>

80108310 <vector196>:
.globl vector196
vector196:
  pushl $0
80108310:	6a 00                	push   $0x0
  pushl $196
80108312:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108317:	e9 27 f2 ff ff       	jmp    80107543 <alltraps>

8010831c <vector197>:
.globl vector197
vector197:
  pushl $0
8010831c:	6a 00                	push   $0x0
  pushl $197
8010831e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108323:	e9 1b f2 ff ff       	jmp    80107543 <alltraps>

80108328 <vector198>:
.globl vector198
vector198:
  pushl $0
80108328:	6a 00                	push   $0x0
  pushl $198
8010832a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010832f:	e9 0f f2 ff ff       	jmp    80107543 <alltraps>

80108334 <vector199>:
.globl vector199
vector199:
  pushl $0
80108334:	6a 00                	push   $0x0
  pushl $199
80108336:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010833b:	e9 03 f2 ff ff       	jmp    80107543 <alltraps>

80108340 <vector200>:
.globl vector200
vector200:
  pushl $0
80108340:	6a 00                	push   $0x0
  pushl $200
80108342:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108347:	e9 f7 f1 ff ff       	jmp    80107543 <alltraps>

8010834c <vector201>:
.globl vector201
vector201:
  pushl $0
8010834c:	6a 00                	push   $0x0
  pushl $201
8010834e:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108353:	e9 eb f1 ff ff       	jmp    80107543 <alltraps>

80108358 <vector202>:
.globl vector202
vector202:
  pushl $0
80108358:	6a 00                	push   $0x0
  pushl $202
8010835a:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010835f:	e9 df f1 ff ff       	jmp    80107543 <alltraps>

80108364 <vector203>:
.globl vector203
vector203:
  pushl $0
80108364:	6a 00                	push   $0x0
  pushl $203
80108366:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010836b:	e9 d3 f1 ff ff       	jmp    80107543 <alltraps>

80108370 <vector204>:
.globl vector204
vector204:
  pushl $0
80108370:	6a 00                	push   $0x0
  pushl $204
80108372:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108377:	e9 c7 f1 ff ff       	jmp    80107543 <alltraps>

8010837c <vector205>:
.globl vector205
vector205:
  pushl $0
8010837c:	6a 00                	push   $0x0
  pushl $205
8010837e:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108383:	e9 bb f1 ff ff       	jmp    80107543 <alltraps>

80108388 <vector206>:
.globl vector206
vector206:
  pushl $0
80108388:	6a 00                	push   $0x0
  pushl $206
8010838a:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010838f:	e9 af f1 ff ff       	jmp    80107543 <alltraps>

80108394 <vector207>:
.globl vector207
vector207:
  pushl $0
80108394:	6a 00                	push   $0x0
  pushl $207
80108396:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010839b:	e9 a3 f1 ff ff       	jmp    80107543 <alltraps>

801083a0 <vector208>:
.globl vector208
vector208:
  pushl $0
801083a0:	6a 00                	push   $0x0
  pushl $208
801083a2:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801083a7:	e9 97 f1 ff ff       	jmp    80107543 <alltraps>

801083ac <vector209>:
.globl vector209
vector209:
  pushl $0
801083ac:	6a 00                	push   $0x0
  pushl $209
801083ae:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801083b3:	e9 8b f1 ff ff       	jmp    80107543 <alltraps>

801083b8 <vector210>:
.globl vector210
vector210:
  pushl $0
801083b8:	6a 00                	push   $0x0
  pushl $210
801083ba:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801083bf:	e9 7f f1 ff ff       	jmp    80107543 <alltraps>

801083c4 <vector211>:
.globl vector211
vector211:
  pushl $0
801083c4:	6a 00                	push   $0x0
  pushl $211
801083c6:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801083cb:	e9 73 f1 ff ff       	jmp    80107543 <alltraps>

801083d0 <vector212>:
.globl vector212
vector212:
  pushl $0
801083d0:	6a 00                	push   $0x0
  pushl $212
801083d2:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801083d7:	e9 67 f1 ff ff       	jmp    80107543 <alltraps>

801083dc <vector213>:
.globl vector213
vector213:
  pushl $0
801083dc:	6a 00                	push   $0x0
  pushl $213
801083de:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801083e3:	e9 5b f1 ff ff       	jmp    80107543 <alltraps>

801083e8 <vector214>:
.globl vector214
vector214:
  pushl $0
801083e8:	6a 00                	push   $0x0
  pushl $214
801083ea:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801083ef:	e9 4f f1 ff ff       	jmp    80107543 <alltraps>

801083f4 <vector215>:
.globl vector215
vector215:
  pushl $0
801083f4:	6a 00                	push   $0x0
  pushl $215
801083f6:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801083fb:	e9 43 f1 ff ff       	jmp    80107543 <alltraps>

80108400 <vector216>:
.globl vector216
vector216:
  pushl $0
80108400:	6a 00                	push   $0x0
  pushl $216
80108402:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108407:	e9 37 f1 ff ff       	jmp    80107543 <alltraps>

8010840c <vector217>:
.globl vector217
vector217:
  pushl $0
8010840c:	6a 00                	push   $0x0
  pushl $217
8010840e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108413:	e9 2b f1 ff ff       	jmp    80107543 <alltraps>

80108418 <vector218>:
.globl vector218
vector218:
  pushl $0
80108418:	6a 00                	push   $0x0
  pushl $218
8010841a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010841f:	e9 1f f1 ff ff       	jmp    80107543 <alltraps>

80108424 <vector219>:
.globl vector219
vector219:
  pushl $0
80108424:	6a 00                	push   $0x0
  pushl $219
80108426:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010842b:	e9 13 f1 ff ff       	jmp    80107543 <alltraps>

80108430 <vector220>:
.globl vector220
vector220:
  pushl $0
80108430:	6a 00                	push   $0x0
  pushl $220
80108432:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108437:	e9 07 f1 ff ff       	jmp    80107543 <alltraps>

8010843c <vector221>:
.globl vector221
vector221:
  pushl $0
8010843c:	6a 00                	push   $0x0
  pushl $221
8010843e:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108443:	e9 fb f0 ff ff       	jmp    80107543 <alltraps>

80108448 <vector222>:
.globl vector222
vector222:
  pushl $0
80108448:	6a 00                	push   $0x0
  pushl $222
8010844a:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010844f:	e9 ef f0 ff ff       	jmp    80107543 <alltraps>

80108454 <vector223>:
.globl vector223
vector223:
  pushl $0
80108454:	6a 00                	push   $0x0
  pushl $223
80108456:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010845b:	e9 e3 f0 ff ff       	jmp    80107543 <alltraps>

80108460 <vector224>:
.globl vector224
vector224:
  pushl $0
80108460:	6a 00                	push   $0x0
  pushl $224
80108462:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108467:	e9 d7 f0 ff ff       	jmp    80107543 <alltraps>

8010846c <vector225>:
.globl vector225
vector225:
  pushl $0
8010846c:	6a 00                	push   $0x0
  pushl $225
8010846e:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108473:	e9 cb f0 ff ff       	jmp    80107543 <alltraps>

80108478 <vector226>:
.globl vector226
vector226:
  pushl $0
80108478:	6a 00                	push   $0x0
  pushl $226
8010847a:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010847f:	e9 bf f0 ff ff       	jmp    80107543 <alltraps>

80108484 <vector227>:
.globl vector227
vector227:
  pushl $0
80108484:	6a 00                	push   $0x0
  pushl $227
80108486:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010848b:	e9 b3 f0 ff ff       	jmp    80107543 <alltraps>

80108490 <vector228>:
.globl vector228
vector228:
  pushl $0
80108490:	6a 00                	push   $0x0
  pushl $228
80108492:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108497:	e9 a7 f0 ff ff       	jmp    80107543 <alltraps>

8010849c <vector229>:
.globl vector229
vector229:
  pushl $0
8010849c:	6a 00                	push   $0x0
  pushl $229
8010849e:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801084a3:	e9 9b f0 ff ff       	jmp    80107543 <alltraps>

801084a8 <vector230>:
.globl vector230
vector230:
  pushl $0
801084a8:	6a 00                	push   $0x0
  pushl $230
801084aa:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801084af:	e9 8f f0 ff ff       	jmp    80107543 <alltraps>

801084b4 <vector231>:
.globl vector231
vector231:
  pushl $0
801084b4:	6a 00                	push   $0x0
  pushl $231
801084b6:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801084bb:	e9 83 f0 ff ff       	jmp    80107543 <alltraps>

801084c0 <vector232>:
.globl vector232
vector232:
  pushl $0
801084c0:	6a 00                	push   $0x0
  pushl $232
801084c2:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801084c7:	e9 77 f0 ff ff       	jmp    80107543 <alltraps>

801084cc <vector233>:
.globl vector233
vector233:
  pushl $0
801084cc:	6a 00                	push   $0x0
  pushl $233
801084ce:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801084d3:	e9 6b f0 ff ff       	jmp    80107543 <alltraps>

801084d8 <vector234>:
.globl vector234
vector234:
  pushl $0
801084d8:	6a 00                	push   $0x0
  pushl $234
801084da:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801084df:	e9 5f f0 ff ff       	jmp    80107543 <alltraps>

801084e4 <vector235>:
.globl vector235
vector235:
  pushl $0
801084e4:	6a 00                	push   $0x0
  pushl $235
801084e6:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801084eb:	e9 53 f0 ff ff       	jmp    80107543 <alltraps>

801084f0 <vector236>:
.globl vector236
vector236:
  pushl $0
801084f0:	6a 00                	push   $0x0
  pushl $236
801084f2:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801084f7:	e9 47 f0 ff ff       	jmp    80107543 <alltraps>

801084fc <vector237>:
.globl vector237
vector237:
  pushl $0
801084fc:	6a 00                	push   $0x0
  pushl $237
801084fe:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108503:	e9 3b f0 ff ff       	jmp    80107543 <alltraps>

80108508 <vector238>:
.globl vector238
vector238:
  pushl $0
80108508:	6a 00                	push   $0x0
  pushl $238
8010850a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010850f:	e9 2f f0 ff ff       	jmp    80107543 <alltraps>

80108514 <vector239>:
.globl vector239
vector239:
  pushl $0
80108514:	6a 00                	push   $0x0
  pushl $239
80108516:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010851b:	e9 23 f0 ff ff       	jmp    80107543 <alltraps>

80108520 <vector240>:
.globl vector240
vector240:
  pushl $0
80108520:	6a 00                	push   $0x0
  pushl $240
80108522:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108527:	e9 17 f0 ff ff       	jmp    80107543 <alltraps>

8010852c <vector241>:
.globl vector241
vector241:
  pushl $0
8010852c:	6a 00                	push   $0x0
  pushl $241
8010852e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108533:	e9 0b f0 ff ff       	jmp    80107543 <alltraps>

80108538 <vector242>:
.globl vector242
vector242:
  pushl $0
80108538:	6a 00                	push   $0x0
  pushl $242
8010853a:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010853f:	e9 ff ef ff ff       	jmp    80107543 <alltraps>

80108544 <vector243>:
.globl vector243
vector243:
  pushl $0
80108544:	6a 00                	push   $0x0
  pushl $243
80108546:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010854b:	e9 f3 ef ff ff       	jmp    80107543 <alltraps>

80108550 <vector244>:
.globl vector244
vector244:
  pushl $0
80108550:	6a 00                	push   $0x0
  pushl $244
80108552:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108557:	e9 e7 ef ff ff       	jmp    80107543 <alltraps>

8010855c <vector245>:
.globl vector245
vector245:
  pushl $0
8010855c:	6a 00                	push   $0x0
  pushl $245
8010855e:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108563:	e9 db ef ff ff       	jmp    80107543 <alltraps>

80108568 <vector246>:
.globl vector246
vector246:
  pushl $0
80108568:	6a 00                	push   $0x0
  pushl $246
8010856a:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010856f:	e9 cf ef ff ff       	jmp    80107543 <alltraps>

80108574 <vector247>:
.globl vector247
vector247:
  pushl $0
80108574:	6a 00                	push   $0x0
  pushl $247
80108576:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010857b:	e9 c3 ef ff ff       	jmp    80107543 <alltraps>

80108580 <vector248>:
.globl vector248
vector248:
  pushl $0
80108580:	6a 00                	push   $0x0
  pushl $248
80108582:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108587:	e9 b7 ef ff ff       	jmp    80107543 <alltraps>

8010858c <vector249>:
.globl vector249
vector249:
  pushl $0
8010858c:	6a 00                	push   $0x0
  pushl $249
8010858e:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108593:	e9 ab ef ff ff       	jmp    80107543 <alltraps>

80108598 <vector250>:
.globl vector250
vector250:
  pushl $0
80108598:	6a 00                	push   $0x0
  pushl $250
8010859a:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010859f:	e9 9f ef ff ff       	jmp    80107543 <alltraps>

801085a4 <vector251>:
.globl vector251
vector251:
  pushl $0
801085a4:	6a 00                	push   $0x0
  pushl $251
801085a6:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801085ab:	e9 93 ef ff ff       	jmp    80107543 <alltraps>

801085b0 <vector252>:
.globl vector252
vector252:
  pushl $0
801085b0:	6a 00                	push   $0x0
  pushl $252
801085b2:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801085b7:	e9 87 ef ff ff       	jmp    80107543 <alltraps>

801085bc <vector253>:
.globl vector253
vector253:
  pushl $0
801085bc:	6a 00                	push   $0x0
  pushl $253
801085be:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801085c3:	e9 7b ef ff ff       	jmp    80107543 <alltraps>

801085c8 <vector254>:
.globl vector254
vector254:
  pushl $0
801085c8:	6a 00                	push   $0x0
  pushl $254
801085ca:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801085cf:	e9 6f ef ff ff       	jmp    80107543 <alltraps>

801085d4 <vector255>:
.globl vector255
vector255:
  pushl $0
801085d4:	6a 00                	push   $0x0
  pushl $255
801085d6:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801085db:	e9 63 ef ff ff       	jmp    80107543 <alltraps>

801085e0 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801085e0:	55                   	push   %ebp
801085e1:	89 e5                	mov    %esp,%ebp
801085e3:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801085e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801085e9:	83 e8 01             	sub    $0x1,%eax
801085ec:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801085f0:	8b 45 08             	mov    0x8(%ebp),%eax
801085f3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801085f7:	8b 45 08             	mov    0x8(%ebp),%eax
801085fa:	c1 e8 10             	shr    $0x10,%eax
801085fd:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108601:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108604:	0f 01 10             	lgdtl  (%eax)
}
80108607:	90                   	nop
80108608:	c9                   	leave  
80108609:	c3                   	ret    

8010860a <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
8010860a:	55                   	push   %ebp
8010860b:	89 e5                	mov    %esp,%ebp
8010860d:	83 ec 04             	sub    $0x4,%esp
80108610:	8b 45 08             	mov    0x8(%ebp),%eax
80108613:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108617:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010861b:	0f 00 d8             	ltr    %ax
}
8010861e:	90                   	nop
8010861f:	c9                   	leave  
80108620:	c3                   	ret    

80108621 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108621:	55                   	push   %ebp
80108622:	89 e5                	mov    %esp,%ebp
80108624:	83 ec 04             	sub    $0x4,%esp
80108627:	8b 45 08             	mov    0x8(%ebp),%eax
8010862a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
8010862e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108632:	8e e8                	mov    %eax,%gs
}
80108634:	90                   	nop
80108635:	c9                   	leave  
80108636:	c3                   	ret    

80108637 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108637:	55                   	push   %ebp
80108638:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010863a:	8b 45 08             	mov    0x8(%ebp),%eax
8010863d:	0f 22 d8             	mov    %eax,%cr3
}
80108640:	90                   	nop
80108641:	5d                   	pop    %ebp
80108642:	c3                   	ret    

80108643 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108643:	55                   	push   %ebp
80108644:	89 e5                	mov    %esp,%ebp
80108646:	8b 45 08             	mov    0x8(%ebp),%eax
80108649:	05 00 00 00 80       	add    $0x80000000,%eax
8010864e:	5d                   	pop    %ebp
8010864f:	c3                   	ret    

80108650 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108650:	55                   	push   %ebp
80108651:	89 e5                	mov    %esp,%ebp
80108653:	8b 45 08             	mov    0x8(%ebp),%eax
80108656:	05 00 00 00 80       	add    $0x80000000,%eax
8010865b:	5d                   	pop    %ebp
8010865c:	c3                   	ret    

8010865d <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010865d:	55                   	push   %ebp
8010865e:	89 e5                	mov    %esp,%ebp
80108660:	53                   	push   %ebx
80108661:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108664:	e8 09 aa ff ff       	call   80103072 <cpunum>
80108669:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010866f:	05 80 33 11 80       	add    $0x80113380,%eax
80108674:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010867a:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108680:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108683:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010868c:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108693:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108697:	83 e2 f0             	and    $0xfffffff0,%edx
8010869a:	83 ca 0a             	or     $0xa,%edx
8010869d:	88 50 7d             	mov    %dl,0x7d(%eax)
801086a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086a3:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801086a7:	83 ca 10             	or     $0x10,%edx
801086aa:	88 50 7d             	mov    %dl,0x7d(%eax)
801086ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086b0:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801086b4:	83 e2 9f             	and    $0xffffff9f,%edx
801086b7:	88 50 7d             	mov    %dl,0x7d(%eax)
801086ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086bd:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801086c1:	83 ca 80             	or     $0xffffff80,%edx
801086c4:	88 50 7d             	mov    %dl,0x7d(%eax)
801086c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ca:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801086ce:	83 ca 0f             	or     $0xf,%edx
801086d1:	88 50 7e             	mov    %dl,0x7e(%eax)
801086d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086d7:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801086db:	83 e2 ef             	and    $0xffffffef,%edx
801086de:	88 50 7e             	mov    %dl,0x7e(%eax)
801086e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086e4:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801086e8:	83 e2 df             	and    $0xffffffdf,%edx
801086eb:	88 50 7e             	mov    %dl,0x7e(%eax)
801086ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f1:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801086f5:	83 ca 40             	or     $0x40,%edx
801086f8:	88 50 7e             	mov    %dl,0x7e(%eax)
801086fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086fe:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108702:	83 ca 80             	or     $0xffffff80,%edx
80108705:	88 50 7e             	mov    %dl,0x7e(%eax)
80108708:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010870b:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010870f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108712:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108719:	ff ff 
8010871b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010871e:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108725:	00 00 
80108727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010872a:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108734:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010873b:	83 e2 f0             	and    $0xfffffff0,%edx
8010873e:	83 ca 02             	or     $0x2,%edx
80108741:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108751:	83 ca 10             	or     $0x10,%edx
80108754:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010875a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010875d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108764:	83 e2 9f             	and    $0xffffff9f,%edx
80108767:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010876d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108770:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108777:	83 ca 80             	or     $0xffffff80,%edx
8010877a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108783:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010878a:	83 ca 0f             	or     $0xf,%edx
8010878d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108796:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010879d:	83 e2 ef             	and    $0xffffffef,%edx
801087a0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801087a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a9:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801087b0:	83 e2 df             	and    $0xffffffdf,%edx
801087b3:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801087b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087bc:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801087c3:	83 ca 40             	or     $0x40,%edx
801087c6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801087cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087cf:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801087d6:	83 ca 80             	or     $0xffffff80,%edx
801087d9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801087df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e2:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801087e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ec:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801087f3:	ff ff 
801087f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087f8:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801087ff:	00 00 
80108801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108804:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010880b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010880e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108815:	83 e2 f0             	and    $0xfffffff0,%edx
80108818:	83 ca 0a             	or     $0xa,%edx
8010881b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108824:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010882b:	83 ca 10             	or     $0x10,%edx
8010882e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108837:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010883e:	83 ca 60             	or     $0x60,%edx
80108841:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108847:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010884a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108851:	83 ca 80             	or     $0xffffff80,%edx
80108854:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010885a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010885d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108864:	83 ca 0f             	or     $0xf,%edx
80108867:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010886d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108870:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108877:	83 e2 ef             	and    $0xffffffef,%edx
8010887a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108880:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108883:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010888a:	83 e2 df             	and    $0xffffffdf,%edx
8010888d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108896:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010889d:	83 ca 40             	or     $0x40,%edx
801088a0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801088a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088a9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801088b0:	83 ca 80             	or     $0xffffff80,%edx
801088b3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801088b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088bc:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801088c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c6:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801088cd:	ff ff 
801088cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d2:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801088d9:	00 00 
801088db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088de:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801088e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801088ef:	83 e2 f0             	and    $0xfffffff0,%edx
801088f2:	83 ca 02             	or     $0x2,%edx
801088f5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801088fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088fe:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108905:	83 ca 10             	or     $0x10,%edx
80108908:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010890e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108911:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108918:	83 ca 60             	or     $0x60,%edx
8010891b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108924:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010892b:	83 ca 80             	or     $0xffffff80,%edx
8010892e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108937:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010893e:	83 ca 0f             	or     $0xf,%edx
80108941:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108947:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010894a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108951:	83 e2 ef             	and    $0xffffffef,%edx
80108954:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010895a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010895d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108964:	83 e2 df             	and    $0xffffffdf,%edx
80108967:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010896d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108970:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108977:	83 ca 40             	or     $0x40,%edx
8010897a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108980:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108983:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010898a:	83 ca 80             	or     $0xffffff80,%edx
8010898d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108993:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108996:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010899d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089a0:	05 b4 00 00 00       	add    $0xb4,%eax
801089a5:	89 c3                	mov    %eax,%ebx
801089a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089aa:	05 b4 00 00 00       	add    $0xb4,%eax
801089af:	c1 e8 10             	shr    $0x10,%eax
801089b2:	89 c2                	mov    %eax,%edx
801089b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089b7:	05 b4 00 00 00       	add    $0xb4,%eax
801089bc:	c1 e8 18             	shr    $0x18,%eax
801089bf:	89 c1                	mov    %eax,%ecx
801089c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089c4:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801089cb:	00 00 
801089cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089d0:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801089d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089da:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801089e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089e3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801089ea:	83 e2 f0             	and    $0xfffffff0,%edx
801089ed:	83 ca 02             	or     $0x2,%edx
801089f0:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801089f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f9:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108a00:	83 ca 10             	or     $0x10,%edx
80108a03:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a0c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108a13:	83 e2 9f             	and    $0xffffff9f,%edx
80108a16:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a1f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108a26:	83 ca 80             	or     $0xffffff80,%edx
80108a29:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a32:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108a39:	83 e2 f0             	and    $0xfffffff0,%edx
80108a3c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a45:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108a4c:	83 e2 ef             	and    $0xffffffef,%edx
80108a4f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a58:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108a5f:	83 e2 df             	and    $0xffffffdf,%edx
80108a62:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a6b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108a72:	83 ca 40             	or     $0x40,%edx
80108a75:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a7e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108a85:	83 ca 80             	or     $0xffffff80,%edx
80108a88:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a91:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a9a:	83 c0 70             	add    $0x70,%eax
80108a9d:	83 ec 08             	sub    $0x8,%esp
80108aa0:	6a 38                	push   $0x38
80108aa2:	50                   	push   %eax
80108aa3:	e8 38 fb ff ff       	call   801085e0 <lgdt>
80108aa8:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108aab:	83 ec 0c             	sub    $0xc,%esp
80108aae:	6a 18                	push   $0x18
80108ab0:	e8 6c fb ff ff       	call   80108621 <loadgs>
80108ab5:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abb:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108ac1:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108ac8:	00 00 00 00 
}
80108acc:	90                   	nop
80108acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108ad0:	c9                   	leave  
80108ad1:	c3                   	ret    

80108ad2 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108ad2:	55                   	push   %ebp
80108ad3:	89 e5                	mov    %esp,%ebp
80108ad5:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
80108adb:	c1 e8 16             	shr    $0x16,%eax
80108ade:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ae5:	8b 45 08             	mov    0x8(%ebp),%eax
80108ae8:	01 d0                	add    %edx,%eax
80108aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108af0:	8b 00                	mov    (%eax),%eax
80108af2:	83 e0 01             	and    $0x1,%eax
80108af5:	85 c0                	test   %eax,%eax
80108af7:	74 18                	je     80108b11 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108afc:	8b 00                	mov    (%eax),%eax
80108afe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b03:	50                   	push   %eax
80108b04:	e8 47 fb ff ff       	call   80108650 <p2v>
80108b09:	83 c4 04             	add    $0x4,%esp
80108b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108b0f:	eb 48                	jmp    80108b59 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108b11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108b15:	74 0e                	je     80108b25 <walkpgdir+0x53>
80108b17:	e8 f0 a1 ff ff       	call   80102d0c <kalloc>
80108b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108b23:	75 07                	jne    80108b2c <walkpgdir+0x5a>
      return 0;
80108b25:	b8 00 00 00 00       	mov    $0x0,%eax
80108b2a:	eb 44                	jmp    80108b70 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108b2c:	83 ec 04             	sub    $0x4,%esp
80108b2f:	68 00 10 00 00       	push   $0x1000
80108b34:	6a 00                	push   $0x0
80108b36:	ff 75 f4             	pushl  -0xc(%ebp)
80108b39:	e8 65 d4 ff ff       	call   80105fa3 <memset>
80108b3e:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108b41:	83 ec 0c             	sub    $0xc,%esp
80108b44:	ff 75 f4             	pushl  -0xc(%ebp)
80108b47:	e8 f7 fa ff ff       	call   80108643 <v2p>
80108b4c:	83 c4 10             	add    $0x10,%esp
80108b4f:	83 c8 07             	or     $0x7,%eax
80108b52:	89 c2                	mov    %eax,%edx
80108b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b57:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108b59:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b5c:	c1 e8 0c             	shr    $0xc,%eax
80108b5f:	25 ff 03 00 00       	and    $0x3ff,%eax
80108b64:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b6e:	01 d0                	add    %edx,%eax
}
80108b70:	c9                   	leave  
80108b71:	c3                   	ret    

80108b72 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108b72:	55                   	push   %ebp
80108b73:	89 e5                	mov    %esp,%ebp
80108b75:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108b78:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108b83:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b86:	8b 45 10             	mov    0x10(%ebp),%eax
80108b89:	01 d0                	add    %edx,%eax
80108b8b:	83 e8 01             	sub    $0x1,%eax
80108b8e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108b96:	83 ec 04             	sub    $0x4,%esp
80108b99:	6a 01                	push   $0x1
80108b9b:	ff 75 f4             	pushl  -0xc(%ebp)
80108b9e:	ff 75 08             	pushl  0x8(%ebp)
80108ba1:	e8 2c ff ff ff       	call   80108ad2 <walkpgdir>
80108ba6:	83 c4 10             	add    $0x10,%esp
80108ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108bac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108bb0:	75 07                	jne    80108bb9 <mappages+0x47>
      return -1;
80108bb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108bb7:	eb 47                	jmp    80108c00 <mappages+0x8e>
    if(*pte & PTE_P)
80108bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bbc:	8b 00                	mov    (%eax),%eax
80108bbe:	83 e0 01             	and    $0x1,%eax
80108bc1:	85 c0                	test   %eax,%eax
80108bc3:	74 0d                	je     80108bd2 <mappages+0x60>
      panic("remap");
80108bc5:	83 ec 0c             	sub    $0xc,%esp
80108bc8:	68 84 9c 10 80       	push   $0x80109c84
80108bcd:	e8 94 79 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80108bd2:	8b 45 18             	mov    0x18(%ebp),%eax
80108bd5:	0b 45 14             	or     0x14(%ebp),%eax
80108bd8:	83 c8 01             	or     $0x1,%eax
80108bdb:	89 c2                	mov    %eax,%edx
80108bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108be0:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108be8:	74 10                	je     80108bfa <mappages+0x88>
      break;
    a += PGSIZE;
80108bea:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108bf1:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108bf8:	eb 9c                	jmp    80108b96 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108bfa:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108bfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c00:	c9                   	leave  
80108c01:	c3                   	ret    

80108c02 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108c02:	55                   	push   %ebp
80108c03:	89 e5                	mov    %esp,%ebp
80108c05:	53                   	push   %ebx
80108c06:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108c09:	e8 fe a0 ff ff       	call   80102d0c <kalloc>
80108c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108c11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108c15:	75 0a                	jne    80108c21 <setupkvm+0x1f>
    return 0;
80108c17:	b8 00 00 00 00       	mov    $0x0,%eax
80108c1c:	e9 8e 00 00 00       	jmp    80108caf <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108c21:	83 ec 04             	sub    $0x4,%esp
80108c24:	68 00 10 00 00       	push   $0x1000
80108c29:	6a 00                	push   $0x0
80108c2b:	ff 75 f0             	pushl  -0x10(%ebp)
80108c2e:	e8 70 d3 ff ff       	call   80105fa3 <memset>
80108c33:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108c36:	83 ec 0c             	sub    $0xc,%esp
80108c39:	68 00 00 00 0e       	push   $0xe000000
80108c3e:	e8 0d fa ff ff       	call   80108650 <p2v>
80108c43:	83 c4 10             	add    $0x10,%esp
80108c46:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108c4b:	76 0d                	jbe    80108c5a <setupkvm+0x58>
    panic("PHYSTOP too high");
80108c4d:	83 ec 0c             	sub    $0xc,%esp
80108c50:	68 8a 9c 10 80       	push   $0x80109c8a
80108c55:	e8 0c 79 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108c5a:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108c61:	eb 40                	jmp    80108ca3 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c66:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c6c:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c72:	8b 58 08             	mov    0x8(%eax),%ebx
80108c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c78:	8b 40 04             	mov    0x4(%eax),%eax
80108c7b:	29 c3                	sub    %eax,%ebx
80108c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c80:	8b 00                	mov    (%eax),%eax
80108c82:	83 ec 0c             	sub    $0xc,%esp
80108c85:	51                   	push   %ecx
80108c86:	52                   	push   %edx
80108c87:	53                   	push   %ebx
80108c88:	50                   	push   %eax
80108c89:	ff 75 f0             	pushl  -0x10(%ebp)
80108c8c:	e8 e1 fe ff ff       	call   80108b72 <mappages>
80108c91:	83 c4 20             	add    $0x20,%esp
80108c94:	85 c0                	test   %eax,%eax
80108c96:	79 07                	jns    80108c9f <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108c98:	b8 00 00 00 00       	mov    $0x0,%eax
80108c9d:	eb 10                	jmp    80108caf <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108c9f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108ca3:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108caa:	72 b7                	jb     80108c63 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108cb2:	c9                   	leave  
80108cb3:	c3                   	ret    

80108cb4 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108cb4:	55                   	push   %ebp
80108cb5:	89 e5                	mov    %esp,%ebp
80108cb7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108cba:	e8 43 ff ff ff       	call   80108c02 <setupkvm>
80108cbf:	a3 38 69 11 80       	mov    %eax,0x80116938
  switchkvm();
80108cc4:	e8 03 00 00 00       	call   80108ccc <switchkvm>
}
80108cc9:	90                   	nop
80108cca:	c9                   	leave  
80108ccb:	c3                   	ret    

80108ccc <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108ccc:	55                   	push   %ebp
80108ccd:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108ccf:	a1 38 69 11 80       	mov    0x80116938,%eax
80108cd4:	50                   	push   %eax
80108cd5:	e8 69 f9 ff ff       	call   80108643 <v2p>
80108cda:	83 c4 04             	add    $0x4,%esp
80108cdd:	50                   	push   %eax
80108cde:	e8 54 f9 ff ff       	call   80108637 <lcr3>
80108ce3:	83 c4 04             	add    $0x4,%esp
}
80108ce6:	90                   	nop
80108ce7:	c9                   	leave  
80108ce8:	c3                   	ret    

80108ce9 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108ce9:	55                   	push   %ebp
80108cea:	89 e5                	mov    %esp,%ebp
80108cec:	56                   	push   %esi
80108ced:	53                   	push   %ebx
  pushcli();
80108cee:	e8 aa d1 ff ff       	call   80105e9d <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108cf3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108cf9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108d00:	83 c2 08             	add    $0x8,%edx
80108d03:	89 d6                	mov    %edx,%esi
80108d05:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108d0c:	83 c2 08             	add    $0x8,%edx
80108d0f:	c1 ea 10             	shr    $0x10,%edx
80108d12:	89 d3                	mov    %edx,%ebx
80108d14:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108d1b:	83 c2 08             	add    $0x8,%edx
80108d1e:	c1 ea 18             	shr    $0x18,%edx
80108d21:	89 d1                	mov    %edx,%ecx
80108d23:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108d2a:	67 00 
80108d2c:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108d33:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108d39:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108d40:	83 e2 f0             	and    $0xfffffff0,%edx
80108d43:	83 ca 09             	or     $0x9,%edx
80108d46:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108d4c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108d53:	83 ca 10             	or     $0x10,%edx
80108d56:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108d5c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108d63:	83 e2 9f             	and    $0xffffff9f,%edx
80108d66:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108d6c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108d73:	83 ca 80             	or     $0xffffff80,%edx
80108d76:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108d7c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108d83:	83 e2 f0             	and    $0xfffffff0,%edx
80108d86:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108d8c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108d93:	83 e2 ef             	and    $0xffffffef,%edx
80108d96:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108d9c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108da3:	83 e2 df             	and    $0xffffffdf,%edx
80108da6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108dac:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108db3:	83 ca 40             	or     $0x40,%edx
80108db6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108dbc:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108dc3:	83 e2 7f             	and    $0x7f,%edx
80108dc6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108dcc:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108dd2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108dd8:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108ddf:	83 e2 ef             	and    $0xffffffef,%edx
80108de2:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108de8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108dee:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108df4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108dfa:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108e01:	8b 52 08             	mov    0x8(%edx),%edx
80108e04:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108e0a:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108e0d:	83 ec 0c             	sub    $0xc,%esp
80108e10:	6a 30                	push   $0x30
80108e12:	e8 f3 f7 ff ff       	call   8010860a <ltr>
80108e17:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108e1a:	8b 45 08             	mov    0x8(%ebp),%eax
80108e1d:	8b 40 04             	mov    0x4(%eax),%eax
80108e20:	85 c0                	test   %eax,%eax
80108e22:	75 0d                	jne    80108e31 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108e24:	83 ec 0c             	sub    $0xc,%esp
80108e27:	68 9b 9c 10 80       	push   $0x80109c9b
80108e2c:	e8 35 77 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108e31:	8b 45 08             	mov    0x8(%ebp),%eax
80108e34:	8b 40 04             	mov    0x4(%eax),%eax
80108e37:	83 ec 0c             	sub    $0xc,%esp
80108e3a:	50                   	push   %eax
80108e3b:	e8 03 f8 ff ff       	call   80108643 <v2p>
80108e40:	83 c4 10             	add    $0x10,%esp
80108e43:	83 ec 0c             	sub    $0xc,%esp
80108e46:	50                   	push   %eax
80108e47:	e8 eb f7 ff ff       	call   80108637 <lcr3>
80108e4c:	83 c4 10             	add    $0x10,%esp
  popcli();
80108e4f:	e8 8e d0 ff ff       	call   80105ee2 <popcli>
}
80108e54:	90                   	nop
80108e55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108e58:	5b                   	pop    %ebx
80108e59:	5e                   	pop    %esi
80108e5a:	5d                   	pop    %ebp
80108e5b:	c3                   	ret    

80108e5c <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108e5c:	55                   	push   %ebp
80108e5d:	89 e5                	mov    %esp,%ebp
80108e5f:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108e62:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108e69:	76 0d                	jbe    80108e78 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108e6b:	83 ec 0c             	sub    $0xc,%esp
80108e6e:	68 af 9c 10 80       	push   $0x80109caf
80108e73:	e8 ee 76 ff ff       	call   80100566 <panic>
  mem = kalloc();
80108e78:	e8 8f 9e ff ff       	call   80102d0c <kalloc>
80108e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108e80:	83 ec 04             	sub    $0x4,%esp
80108e83:	68 00 10 00 00       	push   $0x1000
80108e88:	6a 00                	push   $0x0
80108e8a:	ff 75 f4             	pushl  -0xc(%ebp)
80108e8d:	e8 11 d1 ff ff       	call   80105fa3 <memset>
80108e92:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108e95:	83 ec 0c             	sub    $0xc,%esp
80108e98:	ff 75 f4             	pushl  -0xc(%ebp)
80108e9b:	e8 a3 f7 ff ff       	call   80108643 <v2p>
80108ea0:	83 c4 10             	add    $0x10,%esp
80108ea3:	83 ec 0c             	sub    $0xc,%esp
80108ea6:	6a 06                	push   $0x6
80108ea8:	50                   	push   %eax
80108ea9:	68 00 10 00 00       	push   $0x1000
80108eae:	6a 00                	push   $0x0
80108eb0:	ff 75 08             	pushl  0x8(%ebp)
80108eb3:	e8 ba fc ff ff       	call   80108b72 <mappages>
80108eb8:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108ebb:	83 ec 04             	sub    $0x4,%esp
80108ebe:	ff 75 10             	pushl  0x10(%ebp)
80108ec1:	ff 75 0c             	pushl  0xc(%ebp)
80108ec4:	ff 75 f4             	pushl  -0xc(%ebp)
80108ec7:	e8 96 d1 ff ff       	call   80106062 <memmove>
80108ecc:	83 c4 10             	add    $0x10,%esp
}
80108ecf:	90                   	nop
80108ed0:	c9                   	leave  
80108ed1:	c3                   	ret    

80108ed2 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108ed2:	55                   	push   %ebp
80108ed3:	89 e5                	mov    %esp,%ebp
80108ed5:	53                   	push   %ebx
80108ed6:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108edc:	25 ff 0f 00 00       	and    $0xfff,%eax
80108ee1:	85 c0                	test   %eax,%eax
80108ee3:	74 0d                	je     80108ef2 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108ee5:	83 ec 0c             	sub    $0xc,%esp
80108ee8:	68 cc 9c 10 80       	push   $0x80109ccc
80108eed:	e8 74 76 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108ef2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108ef9:	e9 95 00 00 00       	jmp    80108f93 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108efe:	8b 55 0c             	mov    0xc(%ebp),%edx
80108f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f04:	01 d0                	add    %edx,%eax
80108f06:	83 ec 04             	sub    $0x4,%esp
80108f09:	6a 00                	push   $0x0
80108f0b:	50                   	push   %eax
80108f0c:	ff 75 08             	pushl  0x8(%ebp)
80108f0f:	e8 be fb ff ff       	call   80108ad2 <walkpgdir>
80108f14:	83 c4 10             	add    $0x10,%esp
80108f17:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108f1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108f1e:	75 0d                	jne    80108f2d <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108f20:	83 ec 0c             	sub    $0xc,%esp
80108f23:	68 ef 9c 10 80       	push   $0x80109cef
80108f28:	e8 39 76 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108f2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f30:	8b 00                	mov    (%eax),%eax
80108f32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f37:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108f3a:	8b 45 18             	mov    0x18(%ebp),%eax
80108f3d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108f40:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108f45:	77 0b                	ja     80108f52 <loaduvm+0x80>
      n = sz - i;
80108f47:	8b 45 18             	mov    0x18(%ebp),%eax
80108f4a:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108f50:	eb 07                	jmp    80108f59 <loaduvm+0x87>
    else
      n = PGSIZE;
80108f52:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108f59:	8b 55 14             	mov    0x14(%ebp),%edx
80108f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f5f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108f62:	83 ec 0c             	sub    $0xc,%esp
80108f65:	ff 75 e8             	pushl  -0x18(%ebp)
80108f68:	e8 e3 f6 ff ff       	call   80108650 <p2v>
80108f6d:	83 c4 10             	add    $0x10,%esp
80108f70:	ff 75 f0             	pushl  -0x10(%ebp)
80108f73:	53                   	push   %ebx
80108f74:	50                   	push   %eax
80108f75:	ff 75 10             	pushl  0x10(%ebp)
80108f78:	e8 01 90 ff ff       	call   80101f7e <readi>
80108f7d:	83 c4 10             	add    $0x10,%esp
80108f80:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108f83:	74 07                	je     80108f8c <loaduvm+0xba>
      return -1;
80108f85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f8a:	eb 18                	jmp    80108fa4 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108f8c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f96:	3b 45 18             	cmp    0x18(%ebp),%eax
80108f99:	0f 82 5f ff ff ff    	jb     80108efe <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108fa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108fa7:	c9                   	leave  
80108fa8:	c3                   	ret    

80108fa9 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108fa9:	55                   	push   %ebp
80108faa:	89 e5                	mov    %esp,%ebp
80108fac:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108faf:	8b 45 10             	mov    0x10(%ebp),%eax
80108fb2:	85 c0                	test   %eax,%eax
80108fb4:	79 0a                	jns    80108fc0 <allocuvm+0x17>
    return 0;
80108fb6:	b8 00 00 00 00       	mov    $0x0,%eax
80108fbb:	e9 b0 00 00 00       	jmp    80109070 <allocuvm+0xc7>
  if(newsz < oldsz)
80108fc0:	8b 45 10             	mov    0x10(%ebp),%eax
80108fc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108fc6:	73 08                	jae    80108fd0 <allocuvm+0x27>
    return oldsz;
80108fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80108fcb:	e9 a0 00 00 00       	jmp    80109070 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80108fd3:	05 ff 0f 00 00       	add    $0xfff,%eax
80108fd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108fe0:	eb 7f                	jmp    80109061 <allocuvm+0xb8>
    mem = kalloc();
80108fe2:	e8 25 9d ff ff       	call   80102d0c <kalloc>
80108fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108fea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108fee:	75 2b                	jne    8010901b <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108ff0:	83 ec 0c             	sub    $0xc,%esp
80108ff3:	68 0d 9d 10 80       	push   $0x80109d0d
80108ff8:	e8 c9 73 ff ff       	call   801003c6 <cprintf>
80108ffd:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109000:	83 ec 04             	sub    $0x4,%esp
80109003:	ff 75 0c             	pushl  0xc(%ebp)
80109006:	ff 75 10             	pushl  0x10(%ebp)
80109009:	ff 75 08             	pushl  0x8(%ebp)
8010900c:	e8 61 00 00 00       	call   80109072 <deallocuvm>
80109011:	83 c4 10             	add    $0x10,%esp
      return 0;
80109014:	b8 00 00 00 00       	mov    $0x0,%eax
80109019:	eb 55                	jmp    80109070 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
8010901b:	83 ec 04             	sub    $0x4,%esp
8010901e:	68 00 10 00 00       	push   $0x1000
80109023:	6a 00                	push   $0x0
80109025:	ff 75 f0             	pushl  -0x10(%ebp)
80109028:	e8 76 cf ff ff       	call   80105fa3 <memset>
8010902d:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109030:	83 ec 0c             	sub    $0xc,%esp
80109033:	ff 75 f0             	pushl  -0x10(%ebp)
80109036:	e8 08 f6 ff ff       	call   80108643 <v2p>
8010903b:	83 c4 10             	add    $0x10,%esp
8010903e:	89 c2                	mov    %eax,%edx
80109040:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109043:	83 ec 0c             	sub    $0xc,%esp
80109046:	6a 06                	push   $0x6
80109048:	52                   	push   %edx
80109049:	68 00 10 00 00       	push   $0x1000
8010904e:	50                   	push   %eax
8010904f:	ff 75 08             	pushl  0x8(%ebp)
80109052:	e8 1b fb ff ff       	call   80108b72 <mappages>
80109057:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010905a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109064:	3b 45 10             	cmp    0x10(%ebp),%eax
80109067:	0f 82 75 ff ff ff    	jb     80108fe2 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010906d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109070:	c9                   	leave  
80109071:	c3                   	ret    

80109072 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109072:	55                   	push   %ebp
80109073:	89 e5                	mov    %esp,%ebp
80109075:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109078:	8b 45 10             	mov    0x10(%ebp),%eax
8010907b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010907e:	72 08                	jb     80109088 <deallocuvm+0x16>
    return oldsz;
80109080:	8b 45 0c             	mov    0xc(%ebp),%eax
80109083:	e9 a5 00 00 00       	jmp    8010912d <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109088:	8b 45 10             	mov    0x10(%ebp),%eax
8010908b:	05 ff 0f 00 00       	add    $0xfff,%eax
80109090:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109095:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109098:	e9 81 00 00 00       	jmp    8010911e <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010909d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090a0:	83 ec 04             	sub    $0x4,%esp
801090a3:	6a 00                	push   $0x0
801090a5:	50                   	push   %eax
801090a6:	ff 75 08             	pushl  0x8(%ebp)
801090a9:	e8 24 fa ff ff       	call   80108ad2 <walkpgdir>
801090ae:	83 c4 10             	add    $0x10,%esp
801090b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801090b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801090b8:	75 09                	jne    801090c3 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801090ba:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801090c1:	eb 54                	jmp    80109117 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801090c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090c6:	8b 00                	mov    (%eax),%eax
801090c8:	83 e0 01             	and    $0x1,%eax
801090cb:	85 c0                	test   %eax,%eax
801090cd:	74 48                	je     80109117 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801090cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090d2:	8b 00                	mov    (%eax),%eax
801090d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801090dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801090e0:	75 0d                	jne    801090ef <deallocuvm+0x7d>
        panic("kfree");
801090e2:	83 ec 0c             	sub    $0xc,%esp
801090e5:	68 25 9d 10 80       	push   $0x80109d25
801090ea:	e8 77 74 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
801090ef:	83 ec 0c             	sub    $0xc,%esp
801090f2:	ff 75 ec             	pushl  -0x14(%ebp)
801090f5:	e8 56 f5 ff ff       	call   80108650 <p2v>
801090fa:	83 c4 10             	add    $0x10,%esp
801090fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109100:	83 ec 0c             	sub    $0xc,%esp
80109103:	ff 75 e8             	pushl  -0x18(%ebp)
80109106:	e8 64 9b ff ff       	call   80102c6f <kfree>
8010910b:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
8010910e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109111:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109117:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010911e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109121:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109124:	0f 82 73 ff ff ff    	jb     8010909d <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010912a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010912d:	c9                   	leave  
8010912e:	c3                   	ret    

8010912f <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010912f:	55                   	push   %ebp
80109130:	89 e5                	mov    %esp,%ebp
80109132:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109139:	75 0d                	jne    80109148 <freevm+0x19>
    panic("freevm: no pgdir");
8010913b:	83 ec 0c             	sub    $0xc,%esp
8010913e:	68 2b 9d 10 80       	push   $0x80109d2b
80109143:	e8 1e 74 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109148:	83 ec 04             	sub    $0x4,%esp
8010914b:	6a 00                	push   $0x0
8010914d:	68 00 00 00 80       	push   $0x80000000
80109152:	ff 75 08             	pushl  0x8(%ebp)
80109155:	e8 18 ff ff ff       	call   80109072 <deallocuvm>
8010915a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010915d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109164:	eb 4f                	jmp    801091b5 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109170:	8b 45 08             	mov    0x8(%ebp),%eax
80109173:	01 d0                	add    %edx,%eax
80109175:	8b 00                	mov    (%eax),%eax
80109177:	83 e0 01             	and    $0x1,%eax
8010917a:	85 c0                	test   %eax,%eax
8010917c:	74 33                	je     801091b1 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010917e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109181:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109188:	8b 45 08             	mov    0x8(%ebp),%eax
8010918b:	01 d0                	add    %edx,%eax
8010918d:	8b 00                	mov    (%eax),%eax
8010918f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109194:	83 ec 0c             	sub    $0xc,%esp
80109197:	50                   	push   %eax
80109198:	e8 b3 f4 ff ff       	call   80108650 <p2v>
8010919d:	83 c4 10             	add    $0x10,%esp
801091a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801091a3:	83 ec 0c             	sub    $0xc,%esp
801091a6:	ff 75 f0             	pushl  -0x10(%ebp)
801091a9:	e8 c1 9a ff ff       	call   80102c6f <kfree>
801091ae:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801091b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801091b5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801091bc:	76 a8                	jbe    80109166 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801091be:	83 ec 0c             	sub    $0xc,%esp
801091c1:	ff 75 08             	pushl  0x8(%ebp)
801091c4:	e8 a6 9a ff ff       	call   80102c6f <kfree>
801091c9:	83 c4 10             	add    $0x10,%esp
}
801091cc:	90                   	nop
801091cd:	c9                   	leave  
801091ce:	c3                   	ret    

801091cf <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801091cf:	55                   	push   %ebp
801091d0:	89 e5                	mov    %esp,%ebp
801091d2:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801091d5:	83 ec 04             	sub    $0x4,%esp
801091d8:	6a 00                	push   $0x0
801091da:	ff 75 0c             	pushl  0xc(%ebp)
801091dd:	ff 75 08             	pushl  0x8(%ebp)
801091e0:	e8 ed f8 ff ff       	call   80108ad2 <walkpgdir>
801091e5:	83 c4 10             	add    $0x10,%esp
801091e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801091eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801091ef:	75 0d                	jne    801091fe <clearpteu+0x2f>
    panic("clearpteu");
801091f1:	83 ec 0c             	sub    $0xc,%esp
801091f4:	68 3c 9d 10 80       	push   $0x80109d3c
801091f9:	e8 68 73 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801091fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109201:	8b 00                	mov    (%eax),%eax
80109203:	83 e0 fb             	and    $0xfffffffb,%eax
80109206:	89 c2                	mov    %eax,%edx
80109208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010920b:	89 10                	mov    %edx,(%eax)
}
8010920d:	90                   	nop
8010920e:	c9                   	leave  
8010920f:	c3                   	ret    

80109210 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109210:	55                   	push   %ebp
80109211:	89 e5                	mov    %esp,%ebp
80109213:	53                   	push   %ebx
80109214:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109217:	e8 e6 f9 ff ff       	call   80108c02 <setupkvm>
8010921c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010921f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109223:	75 0a                	jne    8010922f <copyuvm+0x1f>
    return 0;
80109225:	b8 00 00 00 00       	mov    $0x0,%eax
8010922a:	e9 f8 00 00 00       	jmp    80109327 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
8010922f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109236:	e9 c4 00 00 00       	jmp    801092ff <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010923b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010923e:	83 ec 04             	sub    $0x4,%esp
80109241:	6a 00                	push   $0x0
80109243:	50                   	push   %eax
80109244:	ff 75 08             	pushl  0x8(%ebp)
80109247:	e8 86 f8 ff ff       	call   80108ad2 <walkpgdir>
8010924c:	83 c4 10             	add    $0x10,%esp
8010924f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109252:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109256:	75 0d                	jne    80109265 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109258:	83 ec 0c             	sub    $0xc,%esp
8010925b:	68 46 9d 10 80       	push   $0x80109d46
80109260:	e8 01 73 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109265:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109268:	8b 00                	mov    (%eax),%eax
8010926a:	83 e0 01             	and    $0x1,%eax
8010926d:	85 c0                	test   %eax,%eax
8010926f:	75 0d                	jne    8010927e <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109271:	83 ec 0c             	sub    $0xc,%esp
80109274:	68 60 9d 10 80       	push   $0x80109d60
80109279:	e8 e8 72 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010927e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109281:	8b 00                	mov    (%eax),%eax
80109283:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109288:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010928b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010928e:	8b 00                	mov    (%eax),%eax
80109290:	25 ff 0f 00 00       	and    $0xfff,%eax
80109295:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109298:	e8 6f 9a ff ff       	call   80102d0c <kalloc>
8010929d:	89 45 e0             	mov    %eax,-0x20(%ebp)
801092a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801092a4:	74 6a                	je     80109310 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801092a6:	83 ec 0c             	sub    $0xc,%esp
801092a9:	ff 75 e8             	pushl  -0x18(%ebp)
801092ac:	e8 9f f3 ff ff       	call   80108650 <p2v>
801092b1:	83 c4 10             	add    $0x10,%esp
801092b4:	83 ec 04             	sub    $0x4,%esp
801092b7:	68 00 10 00 00       	push   $0x1000
801092bc:	50                   	push   %eax
801092bd:	ff 75 e0             	pushl  -0x20(%ebp)
801092c0:	e8 9d cd ff ff       	call   80106062 <memmove>
801092c5:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801092c8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801092cb:	83 ec 0c             	sub    $0xc,%esp
801092ce:	ff 75 e0             	pushl  -0x20(%ebp)
801092d1:	e8 6d f3 ff ff       	call   80108643 <v2p>
801092d6:	83 c4 10             	add    $0x10,%esp
801092d9:	89 c2                	mov    %eax,%edx
801092db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092de:	83 ec 0c             	sub    $0xc,%esp
801092e1:	53                   	push   %ebx
801092e2:	52                   	push   %edx
801092e3:	68 00 10 00 00       	push   $0x1000
801092e8:	50                   	push   %eax
801092e9:	ff 75 f0             	pushl  -0x10(%ebp)
801092ec:	e8 81 f8 ff ff       	call   80108b72 <mappages>
801092f1:	83 c4 20             	add    $0x20,%esp
801092f4:	85 c0                	test   %eax,%eax
801092f6:	78 1b                	js     80109313 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801092f8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801092ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109302:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109305:	0f 82 30 ff ff ff    	jb     8010923b <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
8010930b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010930e:	eb 17                	jmp    80109327 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109310:	90                   	nop
80109311:	eb 01                	jmp    80109314 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109313:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109314:	83 ec 0c             	sub    $0xc,%esp
80109317:	ff 75 f0             	pushl  -0x10(%ebp)
8010931a:	e8 10 fe ff ff       	call   8010912f <freevm>
8010931f:	83 c4 10             	add    $0x10,%esp
  return 0;
80109322:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109327:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010932a:	c9                   	leave  
8010932b:	c3                   	ret    

8010932c <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010932c:	55                   	push   %ebp
8010932d:	89 e5                	mov    %esp,%ebp
8010932f:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109332:	83 ec 04             	sub    $0x4,%esp
80109335:	6a 00                	push   $0x0
80109337:	ff 75 0c             	pushl  0xc(%ebp)
8010933a:	ff 75 08             	pushl  0x8(%ebp)
8010933d:	e8 90 f7 ff ff       	call   80108ad2 <walkpgdir>
80109342:	83 c4 10             	add    $0x10,%esp
80109345:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010934b:	8b 00                	mov    (%eax),%eax
8010934d:	83 e0 01             	and    $0x1,%eax
80109350:	85 c0                	test   %eax,%eax
80109352:	75 07                	jne    8010935b <uva2ka+0x2f>
    return 0;
80109354:	b8 00 00 00 00       	mov    $0x0,%eax
80109359:	eb 29                	jmp    80109384 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
8010935b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010935e:	8b 00                	mov    (%eax),%eax
80109360:	83 e0 04             	and    $0x4,%eax
80109363:	85 c0                	test   %eax,%eax
80109365:	75 07                	jne    8010936e <uva2ka+0x42>
    return 0;
80109367:	b8 00 00 00 00       	mov    $0x0,%eax
8010936c:	eb 16                	jmp    80109384 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010936e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109371:	8b 00                	mov    (%eax),%eax
80109373:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109378:	83 ec 0c             	sub    $0xc,%esp
8010937b:	50                   	push   %eax
8010937c:	e8 cf f2 ff ff       	call   80108650 <p2v>
80109381:	83 c4 10             	add    $0x10,%esp
}
80109384:	c9                   	leave  
80109385:	c3                   	ret    

80109386 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109386:	55                   	push   %ebp
80109387:	89 e5                	mov    %esp,%ebp
80109389:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010938c:	8b 45 10             	mov    0x10(%ebp),%eax
8010938f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109392:	eb 7f                	jmp    80109413 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109394:	8b 45 0c             	mov    0xc(%ebp),%eax
80109397:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010939c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010939f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801093a2:	83 ec 08             	sub    $0x8,%esp
801093a5:	50                   	push   %eax
801093a6:	ff 75 08             	pushl  0x8(%ebp)
801093a9:	e8 7e ff ff ff       	call   8010932c <uva2ka>
801093ae:	83 c4 10             	add    $0x10,%esp
801093b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801093b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801093b8:	75 07                	jne    801093c1 <copyout+0x3b>
      return -1;
801093ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801093bf:	eb 61                	jmp    80109422 <copyout+0x9c>
    n = PGSIZE - (va - va0);
801093c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801093c4:	2b 45 0c             	sub    0xc(%ebp),%eax
801093c7:	05 00 10 00 00       	add    $0x1000,%eax
801093cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801093cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093d2:	3b 45 14             	cmp    0x14(%ebp),%eax
801093d5:	76 06                	jbe    801093dd <copyout+0x57>
      n = len;
801093d7:	8b 45 14             	mov    0x14(%ebp),%eax
801093da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801093dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801093e0:	2b 45 ec             	sub    -0x14(%ebp),%eax
801093e3:	89 c2                	mov    %eax,%edx
801093e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801093e8:	01 d0                	add    %edx,%eax
801093ea:	83 ec 04             	sub    $0x4,%esp
801093ed:	ff 75 f0             	pushl  -0x10(%ebp)
801093f0:	ff 75 f4             	pushl  -0xc(%ebp)
801093f3:	50                   	push   %eax
801093f4:	e8 69 cc ff ff       	call   80106062 <memmove>
801093f9:	83 c4 10             	add    $0x10,%esp
    len -= n;
801093fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093ff:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109402:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109405:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109408:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010940b:	05 00 10 00 00       	add    $0x1000,%eax
80109410:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109413:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109417:	0f 85 77 ff ff ff    	jne    80109394 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010941d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109422:	c9                   	leave  
80109423:	c3                   	ret    
