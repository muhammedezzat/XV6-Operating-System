
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
8010002d:	b8 49 3a 10 80       	mov    $0x80103a49,%eax
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
8010003d:	68 9c 97 10 80       	push   $0x8010979c
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 e6 5d 00 00       	call   80105e32 <initlock>
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
801000c1:	e8 8e 5d 00 00       	call   80105e54 <acquire>
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
8010010c:	e8 aa 5d 00 00       	call   80105ebb <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 9b 4e 00 00       	call   80104fc7 <sleep>
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
80100188:	e8 2e 5d 00 00       	call   80105ebb <release>
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
801001aa:	68 a3 97 10 80       	push   $0x801097a3
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
801001e2:	e8 e0 28 00 00       	call   80102ac7 <iderw>
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
80100204:	68 b4 97 10 80       	push   $0x801097b4
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
80100223:	e8 9f 28 00 00       	call   80102ac7 <iderw>
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
80100243:	68 bb 97 10 80       	push   $0x801097bb
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 fa 5b 00 00       	call   80105e54 <acquire>
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
801002b9:	e8 f0 4d 00 00       	call   801050ae <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 ed 5b 00 00       	call   80105ebb <release>
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
801003e2:	e8 6d 5a 00 00       	call   80105e54 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 c2 97 10 80       	push   $0x801097c2
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
801004cd:	c7 45 ec cb 97 10 80 	movl   $0x801097cb,-0x14(%ebp)
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
8010055b:	e8 5b 59 00 00       	call   80105ebb <release>
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
8010058b:	68 d2 97 10 80       	push   $0x801097d2
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
801005aa:	68 e1 97 10 80       	push   $0x801097e1
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 46 59 00 00       	call   80105f0d <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 e3 97 10 80       	push   $0x801097e3
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
801006ca:	68 e7 97 10 80       	push   $0x801097e7
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
801006f7:	e8 7a 5a 00 00       	call   80106176 <memmove>
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
80100721:	e8 91 59 00 00       	call   801060b7 <memset>
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
801007b6:	e8 6a 76 00 00       	call   80107e25 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 5d 76 00 00       	call   80107e25 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 50 76 00 00       	call   80107e25 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 40 76 00 00       	call   80107e25 <uartputc>
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
8010082a:	e8 25 56 00 00       	call   80105e54 <acquire>
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
801009c8:	e8 e1 46 00 00       	call   801050ae <wakeup>
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
801009eb:	e8 cb 54 00 00       	call   80105ebb <release>
801009f0:	83 c4 10             	add    $0x10,%esp
  if(doprocdump)
801009f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009f7:	74 07                	je     80100a00 <consoleintr+0x207>
    procdump();  // now call procdump() wo. cons.lock held
801009f9:	e8 70 47 00 00       	call   8010516e <procdump>
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
80100a06:	e8 ac 49 00 00       	call   801053b7 <readydump>
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
80100a13:	e8 99 4a 00 00       	call   801054b1 <freedump>
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
80100a20:	e8 ef 4a 00 00       	call   80105514 <sleepdump>
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
80100a2d:	e8 8a 4b 00 00       	call   801055bc <zombiedump>
    
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
80100a41:	e8 14 12 00 00       	call   80101c5a <iunlock>
80100a46:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a49:	8b 45 10             	mov    0x10(%ebp),%eax
80100a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a4f:	83 ec 0c             	sub    $0xc,%esp
80100a52:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a57:	e8 f8 53 00 00       	call   80105e54 <acquire>
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
80100a79:	e8 3d 54 00 00       	call   80105ebb <release>
80100a7e:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a81:	83 ec 0c             	sub    $0xc,%esp
80100a84:	ff 75 08             	pushl  0x8(%ebp)
80100a87:	e8 48 10 00 00       	call   80101ad4 <ilock>
80100a8c:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a94:	e9 ab 00 00 00       	jmp    80100b44 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a99:	83 ec 08             	sub    $0x8,%esp
80100a9c:	68 e0 d5 10 80       	push   $0x8010d5e0
80100aa1:	68 20 28 11 80       	push   $0x80112820
80100aa6:	e8 1c 45 00 00       	call   80104fc7 <sleep>
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
80100b24:	e8 92 53 00 00       	call   80105ebb <release>
80100b29:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	pushl  0x8(%ebp)
80100b32:	e8 9d 0f 00 00       	call   80101ad4 <ilock>
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
80100b52:	e8 03 11 00 00       	call   80101c5a <iunlock>
80100b57:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b5a:	83 ec 0c             	sub    $0xc,%esp
80100b5d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b62:	e8 ed 52 00 00       	call   80105e54 <acquire>
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
80100ba4:	e8 12 53 00 00       	call   80105ebb <release>
80100ba9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bac:	83 ec 0c             	sub    $0xc,%esp
80100baf:	ff 75 08             	pushl  0x8(%ebp)
80100bb2:	e8 1d 0f 00 00       	call   80101ad4 <ilock>
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
80100bc8:	68 fa 97 10 80       	push   $0x801097fa
80100bcd:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bd2:	e8 5b 52 00 00       	call   80105e32 <initlock>
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
80100bfd:	e8 e3 34 00 00       	call   801040e5 <picenable>
80100c02:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c05:	83 ec 08             	sub    $0x8,%esp
80100c08:	6a 00                	push   $0x0
80100c0a:	6a 01                	push   $0x1
80100c0c:	e8 83 20 00 00       	call   80102c94 <ioapicenable>
80100c11:	83 c4 10             	add    $0x10,%esp
}
80100c14:	90                   	nop
80100c15:	c9                   	leave  
80100c16:	c3                   	ret    

80100c17 <exec>:
#include "fs.h"
#include "file.h"

int
exec(char *path, char **argv)
{
80100c17:	55                   	push   %ebp
80100c18:	89 e5                	mov    %esp,%ebp
80100c1a:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  #ifdef CS333_P5 // Added for Project 5: Modified System Calls
  int tempUID = -1; // set to negative value since it is illegal UID value
80100c20:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  #endif

  begin_op();
80100c27:	e8 db 2a 00 00       	call   80103707 <begin_op>
  if((ip = namei(path)) == 0){
80100c2c:	83 ec 0c             	sub    $0xc,%esp
80100c2f:	ff 75 08             	pushl  0x8(%ebp)
80100c32:	e8 ab 1a 00 00       	call   801026e2 <namei>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c3d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c41:	75 0f                	jne    80100c52 <exec+0x3b>
    end_op();
80100c43:	e8 4b 2b 00 00       	call   80103793 <end_op>
    return -1;
80100c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c4d:	e9 63 04 00 00       	jmp    801010b5 <exec+0x49e>
  }
  ilock(ip);
80100c52:	83 ec 0c             	sub    $0xc,%esp
80100c55:	ff 75 d8             	pushl  -0x28(%ebp)
80100c58:	e8 77 0e 00 00       	call   80101ad4 <ilock>
80100c5d:	83 c4 10             	add    $0x10,%esp

  #ifdef CS333_P5 // Added for Project 5: Modified System Calls
  // if at least one of these evaluates true then we proceed, otherwise goto bad
  if (!((ip->mode.flags.u_x == 1 && proc->uid == ip->uid) || // check user permissions first
80100c60:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c63:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
80100c67:	83 e0 40             	and    $0x40,%eax
80100c6a:	84 c0                	test   %al,%al
80100c6c:	74 1a                	je     80100c88 <exec+0x71>
80100c6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c74:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80100c7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c7d:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80100c81:	0f b7 c0             	movzwl %ax,%eax
80100c84:	39 c2                	cmp    %eax,%edx
80100c86:	74 3a                	je     80100cc2 <exec+0xab>
        (ip->mode.flags.g_x == 1 && proc->gid == ip->gid) || // then check group permissions
80100c88:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c8b:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
80100c8f:	83 e0 08             	and    $0x8,%eax
  }
  ilock(ip);

  #ifdef CS333_P5 // Added for Project 5: Modified System Calls
  // if at least one of these evaluates true then we proceed, otherwise goto bad
  if (!((ip->mode.flags.u_x == 1 && proc->uid == ip->uid) || // check user permissions first
80100c92:	84 c0                	test   %al,%al
80100c94:	74 1a                	je     80100cb0 <exec+0x99>
        (ip->mode.flags.g_x == 1 && proc->gid == ip->gid) || // then check group permissions
80100c96:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c9c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80100ca2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ca5:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
80100ca9:	0f b7 c0             	movzwl %ax,%eax
80100cac:	39 c2                	cmp    %eax,%edx
80100cae:	74 12                	je     80100cc2 <exec+0xab>
        (ip->mode.flags.o_x == 1))){ 			     // finally check other permissions
80100cb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cb3:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
80100cb7:	83 e0 01             	and    $0x1,%eax
  }
  ilock(ip);

  #ifdef CS333_P5 // Added for Project 5: Modified System Calls
  // if at least one of these evaluates true then we proceed, otherwise goto bad
  if (!((ip->mode.flags.u_x == 1 && proc->uid == ip->uid) || // check user permissions first
80100cba:	84 c0                	test   %al,%al
80100cbc:	0f 84 9f 03 00 00    	je     80101061 <exec+0x44a>
        (ip->mode.flags.o_x == 1))){ 			     // finally check other permissions
    goto bad;
  }

  // if we're setting uid then store the uid in temp variable to set proc later
  if (ip->mode.flags.setuid == 1)
80100cc2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cc5:	0f b6 40 1d          	movzbl 0x1d(%eax),%eax
80100cc9:	83 e0 02             	and    $0x2,%eax
80100ccc:	84 c0                	test   %al,%al
80100cce:	74 0d                	je     80100cdd <exec+0xc6>
    tempUID = ip->uid;
80100cd0:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cd3:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80100cd7:	0f b7 c0             	movzwl %ax,%eax
80100cda:	89 45 d0             	mov    %eax,-0x30(%ebp)
  #endif

  pgdir = 0;
80100cdd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100ce4:	6a 34                	push   $0x34
80100ce6:	6a 00                	push   $0x0
80100ce8:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100cee:	50                   	push   %eax
80100cef:	ff 75 d8             	pushl  -0x28(%ebp)
80100cf2:	e8 9b 13 00 00       	call   80102092 <readi>
80100cf7:	83 c4 10             	add    $0x10,%esp
80100cfa:	83 f8 33             	cmp    $0x33,%eax
80100cfd:	0f 86 61 03 00 00    	jbe    80101064 <exec+0x44d>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100d03:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100d09:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100d0e:	0f 85 53 03 00 00    	jne    80101067 <exec+0x450>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100d14:	e8 61 82 00 00       	call   80108f7a <setupkvm>
80100d19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100d1c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100d20:	0f 84 44 03 00 00    	je     8010106a <exec+0x453>
    goto bad;

  // Load program into memory.
  sz = 0;
80100d26:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d2d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100d34:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100d3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d3d:	e9 ab 00 00 00       	jmp    80100ded <exec+0x1d6>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d45:	6a 20                	push   $0x20
80100d47:	50                   	push   %eax
80100d48:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100d4e:	50                   	push   %eax
80100d4f:	ff 75 d8             	pushl  -0x28(%ebp)
80100d52:	e8 3b 13 00 00       	call   80102092 <readi>
80100d57:	83 c4 10             	add    $0x10,%esp
80100d5a:	83 f8 20             	cmp    $0x20,%eax
80100d5d:	0f 85 0a 03 00 00    	jne    8010106d <exec+0x456>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100d63:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100d69:	83 f8 01             	cmp    $0x1,%eax
80100d6c:	75 71                	jne    80100ddf <exec+0x1c8>
      continue;
    if(ph.memsz < ph.filesz)
80100d6e:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d74:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100d7a:	39 c2                	cmp    %eax,%edx
80100d7c:	0f 82 ee 02 00 00    	jb     80101070 <exec+0x459>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d82:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d88:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d8e:	01 d0                	add    %edx,%eax
80100d90:	83 ec 04             	sub    $0x4,%esp
80100d93:	50                   	push   %eax
80100d94:	ff 75 e0             	pushl  -0x20(%ebp)
80100d97:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d9a:	e8 82 85 00 00       	call   80109321 <allocuvm>
80100d9f:	83 c4 10             	add    $0x10,%esp
80100da2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100da5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100da9:	0f 84 c4 02 00 00    	je     80101073 <exec+0x45c>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100daf:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100db5:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100dbb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100dc1:	83 ec 0c             	sub    $0xc,%esp
80100dc4:	52                   	push   %edx
80100dc5:	50                   	push   %eax
80100dc6:	ff 75 d8             	pushl  -0x28(%ebp)
80100dc9:	51                   	push   %ecx
80100dca:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dcd:	e8 78 84 00 00       	call   8010924a <loaduvm>
80100dd2:	83 c4 20             	add    $0x20,%esp
80100dd5:	85 c0                	test   %eax,%eax
80100dd7:	0f 88 99 02 00 00    	js     80101076 <exec+0x45f>
80100ddd:	eb 01                	jmp    80100de0 <exec+0x1c9>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100ddf:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100de4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100de7:	83 c0 20             	add    $0x20,%eax
80100dea:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ded:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100df4:	0f b7 c0             	movzwl %ax,%eax
80100df7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100dfa:	0f 8f 42 ff ff ff    	jg     80100d42 <exec+0x12b>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100e00:	83 ec 0c             	sub    $0xc,%esp
80100e03:	ff 75 d8             	pushl  -0x28(%ebp)
80100e06:	e8 b1 0f 00 00       	call   80101dbc <iunlockput>
80100e0b:	83 c4 10             	add    $0x10,%esp
  end_op();
80100e0e:	e8 80 29 00 00       	call   80103793 <end_op>
  ip = 0;
80100e13:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e1d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e27:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e2d:	05 00 20 00 00       	add    $0x2000,%eax
80100e32:	83 ec 04             	sub    $0x4,%esp
80100e35:	50                   	push   %eax
80100e36:	ff 75 e0             	pushl  -0x20(%ebp)
80100e39:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e3c:	e8 e0 84 00 00       	call   80109321 <allocuvm>
80100e41:	83 c4 10             	add    $0x10,%esp
80100e44:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e4b:	0f 84 28 02 00 00    	je     80101079 <exec+0x462>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e54:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e59:	83 ec 08             	sub    $0x8,%esp
80100e5c:	50                   	push   %eax
80100e5d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e60:	e8 e2 86 00 00       	call   80109547 <clearpteu>
80100e65:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e6b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e75:	e9 96 00 00 00       	jmp    80100f10 <exec+0x2f9>
    if(argc >= MAXARG)
80100e7a:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e7e:	0f 87 f8 01 00 00    	ja     8010107c <exec+0x465>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e91:	01 d0                	add    %edx,%eax
80100e93:	8b 00                	mov    (%eax),%eax
80100e95:	83 ec 0c             	sub    $0xc,%esp
80100e98:	50                   	push   %eax
80100e99:	e8 66 54 00 00       	call   80106304 <strlen>
80100e9e:	83 c4 10             	add    $0x10,%esp
80100ea1:	89 c2                	mov    %eax,%edx
80100ea3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ea6:	29 d0                	sub    %edx,%eax
80100ea8:	83 e8 01             	sub    $0x1,%eax
80100eab:	83 e0 fc             	and    $0xfffffffc,%eax
80100eae:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ebe:	01 d0                	add    %edx,%eax
80100ec0:	8b 00                	mov    (%eax),%eax
80100ec2:	83 ec 0c             	sub    $0xc,%esp
80100ec5:	50                   	push   %eax
80100ec6:	e8 39 54 00 00       	call   80106304 <strlen>
80100ecb:	83 c4 10             	add    $0x10,%esp
80100ece:	83 c0 01             	add    $0x1,%eax
80100ed1:	89 c1                	mov    %eax,%ecx
80100ed3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ed6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100edd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ee0:	01 d0                	add    %edx,%eax
80100ee2:	8b 00                	mov    (%eax),%eax
80100ee4:	51                   	push   %ecx
80100ee5:	50                   	push   %eax
80100ee6:	ff 75 dc             	pushl  -0x24(%ebp)
80100ee9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100eec:	e8 0d 88 00 00       	call   801096fe <copyout>
80100ef1:	83 c4 10             	add    $0x10,%esp
80100ef4:	85 c0                	test   %eax,%eax
80100ef6:	0f 88 83 01 00 00    	js     8010107f <exec+0x468>
      goto bad;
    ustack[3+argc] = sp;
80100efc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eff:	8d 50 03             	lea    0x3(%eax),%edx
80100f02:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f05:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f0c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100f10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f1d:	01 d0                	add    %edx,%eax
80100f1f:	8b 00                	mov    (%eax),%eax
80100f21:	85 c0                	test   %eax,%eax
80100f23:	0f 85 51 ff ff ff    	jne    80100e7a <exec+0x263>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100f29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f2c:	83 c0 03             	add    $0x3,%eax
80100f2f:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100f36:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f3a:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100f41:	ff ff ff 
  ustack[1] = argc;
80100f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f47:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f50:	83 c0 01             	add    $0x1,%eax
80100f53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f5d:	29 d0                	sub    %edx,%eax
80100f5f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100f65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f68:	83 c0 04             	add    $0x4,%eax
80100f6b:	c1 e0 02             	shl    $0x2,%eax
80100f6e:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f74:	83 c0 04             	add    $0x4,%eax
80100f77:	c1 e0 02             	shl    $0x2,%eax
80100f7a:	50                   	push   %eax
80100f7b:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100f81:	50                   	push   %eax
80100f82:	ff 75 dc             	pushl  -0x24(%ebp)
80100f85:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f88:	e8 71 87 00 00       	call   801096fe <copyout>
80100f8d:	83 c4 10             	add    $0x10,%esp
80100f90:	85 c0                	test   %eax,%eax
80100f92:	0f 88 ea 00 00 00    	js     80101082 <exec+0x46b>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f98:	8b 45 08             	mov    0x8(%ebp),%eax
80100f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100fa4:	eb 17                	jmp    80100fbd <exec+0x3a6>
    if(*s == '/')
80100fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa9:	0f b6 00             	movzbl (%eax),%eax
80100fac:	3c 2f                	cmp    $0x2f,%al
80100fae:	75 09                	jne    80100fb9 <exec+0x3a2>
      last = s+1;
80100fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb3:	83 c0 01             	add    $0x1,%eax
80100fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100fb9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc0:	0f b6 00             	movzbl (%eax),%eax
80100fc3:	84 c0                	test   %al,%al
80100fc5:	75 df                	jne    80100fa6 <exec+0x38f>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100fc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fcd:	83 c0 6c             	add    $0x6c,%eax
80100fd0:	83 ec 04             	sub    $0x4,%esp
80100fd3:	6a 10                	push   $0x10
80100fd5:	ff 75 f0             	pushl  -0x10(%ebp)
80100fd8:	50                   	push   %eax
80100fd9:	e8 dc 52 00 00       	call   801062ba <safestrcpy>
80100fde:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100fe1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fe7:	8b 40 04             	mov    0x4(%eax),%eax
80100fea:	89 45 cc             	mov    %eax,-0x34(%ebp)
  proc->pgdir = pgdir;
80100fed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ff3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ff6:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ff9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fff:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101002:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80101004:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010100a:	8b 40 18             	mov    0x18(%eax),%eax
8010100d:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80101013:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80101016:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010101c:	8b 40 18             	mov    0x18(%eax),%eax
8010101f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101022:	89 50 44             	mov    %edx,0x44(%eax)

  #ifdef CS333_P5 // Added for Project 5: Modified System Calls
  if(tempUID != -1) // if tempUID has been modified from init value then set proc uid
80101025:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
80101029:	74 0f                	je     8010103a <exec+0x423>
    proc->uid = tempUID;
8010102b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101031:	8b 55 d0             	mov    -0x30(%ebp),%edx
80101034:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  #endif
  
  switchuvm(proc);
8010103a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101040:	83 ec 0c             	sub    $0xc,%esp
80101043:	50                   	push   %eax
80101044:	e8 18 80 00 00       	call   80109061 <switchuvm>
80101049:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	ff 75 cc             	pushl  -0x34(%ebp)
80101052:	e8 50 84 00 00       	call   801094a7 <freevm>
80101057:	83 c4 10             	add    $0x10,%esp
  return 0;
8010105a:	b8 00 00 00 00       	mov    $0x0,%eax
8010105f:	eb 54                	jmp    801010b5 <exec+0x49e>
  #ifdef CS333_P5 // Added for Project 5: Modified System Calls
  // if at least one of these evaluates true then we proceed, otherwise goto bad
  if (!((ip->mode.flags.u_x == 1 && proc->uid == ip->uid) || // check user permissions first
        (ip->mode.flags.g_x == 1 && proc->gid == ip->gid) || // then check group permissions
        (ip->mode.flags.o_x == 1))){ 			     // finally check other permissions
    goto bad;
80101061:	90                   	nop
80101062:	eb 1f                	jmp    80101083 <exec+0x46c>

  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80101064:	90                   	nop
80101065:	eb 1c                	jmp    80101083 <exec+0x46c>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80101067:	90                   	nop
80101068:	eb 19                	jmp    80101083 <exec+0x46c>

  if((pgdir = setupkvm()) == 0)
    goto bad;
8010106a:	90                   	nop
8010106b:	eb 16                	jmp    80101083 <exec+0x46c>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
8010106d:	90                   	nop
8010106e:	eb 13                	jmp    80101083 <exec+0x46c>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80101070:	90                   	nop
80101071:	eb 10                	jmp    80101083 <exec+0x46c>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80101073:	90                   	nop
80101074:	eb 0d                	jmp    80101083 <exec+0x46c>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80101076:	90                   	nop
80101077:	eb 0a                	jmp    80101083 <exec+0x46c>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80101079:	90                   	nop
8010107a:	eb 07                	jmp    80101083 <exec+0x46c>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
8010107c:	90                   	nop
8010107d:	eb 04                	jmp    80101083 <exec+0x46c>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
8010107f:	90                   	nop
80101080:	eb 01                	jmp    80101083 <exec+0x46c>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80101082:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80101083:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101087:	74 0e                	je     80101097 <exec+0x480>
    freevm(pgdir);
80101089:	83 ec 0c             	sub    $0xc,%esp
8010108c:	ff 75 d4             	pushl  -0x2c(%ebp)
8010108f:	e8 13 84 00 00       	call   801094a7 <freevm>
80101094:	83 c4 10             	add    $0x10,%esp
  if(ip){
80101097:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
8010109b:	74 13                	je     801010b0 <exec+0x499>
    iunlockput(ip);
8010109d:	83 ec 0c             	sub    $0xc,%esp
801010a0:	ff 75 d8             	pushl  -0x28(%ebp)
801010a3:	e8 14 0d 00 00       	call   80101dbc <iunlockput>
801010a8:	83 c4 10             	add    $0x10,%esp
    end_op();
801010ab:	e8 e3 26 00 00       	call   80103793 <end_op>
  }
  return -1;
801010b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010b5:	c9                   	leave  
801010b6:	c3                   	ret    

801010b7 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010b7:	55                   	push   %ebp
801010b8:	89 e5                	mov    %esp,%ebp
801010ba:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
801010bd:	83 ec 08             	sub    $0x8,%esp
801010c0:	68 02 98 10 80       	push   $0x80109802
801010c5:	68 40 28 11 80       	push   $0x80112840
801010ca:	e8 63 4d 00 00       	call   80105e32 <initlock>
801010cf:	83 c4 10             	add    $0x10,%esp
}
801010d2:	90                   	nop
801010d3:	c9                   	leave  
801010d4:	c3                   	ret    

801010d5 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010d5:	55                   	push   %ebp
801010d6:	89 e5                	mov    %esp,%ebp
801010d8:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
801010db:	83 ec 0c             	sub    $0xc,%esp
801010de:	68 40 28 11 80       	push   $0x80112840
801010e3:	e8 6c 4d 00 00       	call   80105e54 <acquire>
801010e8:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010eb:	c7 45 f4 74 28 11 80 	movl   $0x80112874,-0xc(%ebp)
801010f2:	eb 2d                	jmp    80101121 <filealloc+0x4c>
    if(f->ref == 0){
801010f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010f7:	8b 40 04             	mov    0x4(%eax),%eax
801010fa:	85 c0                	test   %eax,%eax
801010fc:	75 1f                	jne    8010111d <filealloc+0x48>
      f->ref = 1;
801010fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101101:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101108:	83 ec 0c             	sub    $0xc,%esp
8010110b:	68 40 28 11 80       	push   $0x80112840
80101110:	e8 a6 4d 00 00       	call   80105ebb <release>
80101115:	83 c4 10             	add    $0x10,%esp
      return f;
80101118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010111b:	eb 23                	jmp    80101140 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010111d:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101121:	b8 d4 31 11 80       	mov    $0x801131d4,%eax
80101126:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101129:	72 c9                	jb     801010f4 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	68 40 28 11 80       	push   $0x80112840
80101133:	e8 83 4d 00 00       	call   80105ebb <release>
80101138:	83 c4 10             	add    $0x10,%esp
  return 0;
8010113b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101140:	c9                   	leave  
80101141:	c3                   	ret    

80101142 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101142:	55                   	push   %ebp
80101143:	89 e5                	mov    %esp,%ebp
80101145:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 40 28 11 80       	push   $0x80112840
80101150:	e8 ff 4c 00 00       	call   80105e54 <acquire>
80101155:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101158:	8b 45 08             	mov    0x8(%ebp),%eax
8010115b:	8b 40 04             	mov    0x4(%eax),%eax
8010115e:	85 c0                	test   %eax,%eax
80101160:	7f 0d                	jg     8010116f <filedup+0x2d>
    panic("filedup");
80101162:	83 ec 0c             	sub    $0xc,%esp
80101165:	68 09 98 10 80       	push   $0x80109809
8010116a:	e8 f7 f3 ff ff       	call   80100566 <panic>
  f->ref++;
8010116f:	8b 45 08             	mov    0x8(%ebp),%eax
80101172:	8b 40 04             	mov    0x4(%eax),%eax
80101175:	8d 50 01             	lea    0x1(%eax),%edx
80101178:	8b 45 08             	mov    0x8(%ebp),%eax
8010117b:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	68 40 28 11 80       	push   $0x80112840
80101186:	e8 30 4d 00 00       	call   80105ebb <release>
8010118b:	83 c4 10             	add    $0x10,%esp
  return f;
8010118e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101191:	c9                   	leave  
80101192:	c3                   	ret    

80101193 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101193:	55                   	push   %ebp
80101194:	89 e5                	mov    %esp,%ebp
80101196:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101199:	83 ec 0c             	sub    $0xc,%esp
8010119c:	68 40 28 11 80       	push   $0x80112840
801011a1:	e8 ae 4c 00 00       	call   80105e54 <acquire>
801011a6:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011a9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ac:	8b 40 04             	mov    0x4(%eax),%eax
801011af:	85 c0                	test   %eax,%eax
801011b1:	7f 0d                	jg     801011c0 <fileclose+0x2d>
    panic("fileclose");
801011b3:	83 ec 0c             	sub    $0xc,%esp
801011b6:	68 11 98 10 80       	push   $0x80109811
801011bb:	e8 a6 f3 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
801011c0:	8b 45 08             	mov    0x8(%ebp),%eax
801011c3:	8b 40 04             	mov    0x4(%eax),%eax
801011c6:	8d 50 ff             	lea    -0x1(%eax),%edx
801011c9:	8b 45 08             	mov    0x8(%ebp),%eax
801011cc:	89 50 04             	mov    %edx,0x4(%eax)
801011cf:	8b 45 08             	mov    0x8(%ebp),%eax
801011d2:	8b 40 04             	mov    0x4(%eax),%eax
801011d5:	85 c0                	test   %eax,%eax
801011d7:	7e 15                	jle    801011ee <fileclose+0x5b>
    release(&ftable.lock);
801011d9:	83 ec 0c             	sub    $0xc,%esp
801011dc:	68 40 28 11 80       	push   $0x80112840
801011e1:	e8 d5 4c 00 00       	call   80105ebb <release>
801011e6:	83 c4 10             	add    $0x10,%esp
801011e9:	e9 8b 00 00 00       	jmp    80101279 <fileclose+0xe6>
    return;
  }
  ff = *f;
801011ee:	8b 45 08             	mov    0x8(%ebp),%eax
801011f1:	8b 10                	mov    (%eax),%edx
801011f3:	89 55 e0             	mov    %edx,-0x20(%ebp)
801011f6:	8b 50 04             	mov    0x4(%eax),%edx
801011f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801011fc:	8b 50 08             	mov    0x8(%eax),%edx
801011ff:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101202:	8b 50 0c             	mov    0xc(%eax),%edx
80101205:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101208:	8b 50 10             	mov    0x10(%eax),%edx
8010120b:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010120e:	8b 40 14             	mov    0x14(%eax),%eax
80101211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101214:	8b 45 08             	mov    0x8(%ebp),%eax
80101217:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010121e:	8b 45 08             	mov    0x8(%ebp),%eax
80101221:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101227:	83 ec 0c             	sub    $0xc,%esp
8010122a:	68 40 28 11 80       	push   $0x80112840
8010122f:	e8 87 4c 00 00       	call   80105ebb <release>
80101234:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101237:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010123a:	83 f8 01             	cmp    $0x1,%eax
8010123d:	75 19                	jne    80101258 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010123f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101243:	0f be d0             	movsbl %al,%edx
80101246:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101249:	83 ec 08             	sub    $0x8,%esp
8010124c:	52                   	push   %edx
8010124d:	50                   	push   %eax
8010124e:	e8 fb 30 00 00       	call   8010434e <pipeclose>
80101253:	83 c4 10             	add    $0x10,%esp
80101256:	eb 21                	jmp    80101279 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101258:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010125b:	83 f8 02             	cmp    $0x2,%eax
8010125e:	75 19                	jne    80101279 <fileclose+0xe6>
    begin_op();
80101260:	e8 a2 24 00 00       	call   80103707 <begin_op>
    iput(ff.ip);
80101265:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101268:	83 ec 0c             	sub    $0xc,%esp
8010126b:	50                   	push   %eax
8010126c:	e8 5b 0a 00 00       	call   80101ccc <iput>
80101271:	83 c4 10             	add    $0x10,%esp
    end_op();
80101274:	e8 1a 25 00 00       	call   80103793 <end_op>
  }
}
80101279:	c9                   	leave  
8010127a:	c3                   	ret    

8010127b <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010127b:	55                   	push   %ebp
8010127c:	89 e5                	mov    %esp,%ebp
8010127e:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101281:	8b 45 08             	mov    0x8(%ebp),%eax
80101284:	8b 00                	mov    (%eax),%eax
80101286:	83 f8 02             	cmp    $0x2,%eax
80101289:	75 40                	jne    801012cb <filestat+0x50>
    ilock(f->ip);
8010128b:	8b 45 08             	mov    0x8(%ebp),%eax
8010128e:	8b 40 10             	mov    0x10(%eax),%eax
80101291:	83 ec 0c             	sub    $0xc,%esp
80101294:	50                   	push   %eax
80101295:	e8 3a 08 00 00       	call   80101ad4 <ilock>
8010129a:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010129d:	8b 45 08             	mov    0x8(%ebp),%eax
801012a0:	8b 40 10             	mov    0x10(%eax),%eax
801012a3:	83 ec 08             	sub    $0x8,%esp
801012a6:	ff 75 0c             	pushl  0xc(%ebp)
801012a9:	50                   	push   %eax
801012aa:	e8 75 0d 00 00       	call   80102024 <stati>
801012af:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801012b2:	8b 45 08             	mov    0x8(%ebp),%eax
801012b5:	8b 40 10             	mov    0x10(%eax),%eax
801012b8:	83 ec 0c             	sub    $0xc,%esp
801012bb:	50                   	push   %eax
801012bc:	e8 99 09 00 00       	call   80101c5a <iunlock>
801012c1:	83 c4 10             	add    $0x10,%esp
    return 0;
801012c4:	b8 00 00 00 00       	mov    $0x0,%eax
801012c9:	eb 05                	jmp    801012d0 <filestat+0x55>
  }
  return -1;
801012cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012d0:	c9                   	leave  
801012d1:	c3                   	ret    

801012d2 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012d2:	55                   	push   %ebp
801012d3:	89 e5                	mov    %esp,%ebp
801012d5:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801012d8:	8b 45 08             	mov    0x8(%ebp),%eax
801012db:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801012df:	84 c0                	test   %al,%al
801012e1:	75 0a                	jne    801012ed <fileread+0x1b>
    return -1;
801012e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012e8:	e9 9b 00 00 00       	jmp    80101388 <fileread+0xb6>
  if(f->type == FD_PIPE)
801012ed:	8b 45 08             	mov    0x8(%ebp),%eax
801012f0:	8b 00                	mov    (%eax),%eax
801012f2:	83 f8 01             	cmp    $0x1,%eax
801012f5:	75 1a                	jne    80101311 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801012f7:	8b 45 08             	mov    0x8(%ebp),%eax
801012fa:	8b 40 0c             	mov    0xc(%eax),%eax
801012fd:	83 ec 04             	sub    $0x4,%esp
80101300:	ff 75 10             	pushl  0x10(%ebp)
80101303:	ff 75 0c             	pushl  0xc(%ebp)
80101306:	50                   	push   %eax
80101307:	e8 ea 31 00 00       	call   801044f6 <piperead>
8010130c:	83 c4 10             	add    $0x10,%esp
8010130f:	eb 77                	jmp    80101388 <fileread+0xb6>
  if(f->type == FD_INODE){
80101311:	8b 45 08             	mov    0x8(%ebp),%eax
80101314:	8b 00                	mov    (%eax),%eax
80101316:	83 f8 02             	cmp    $0x2,%eax
80101319:	75 60                	jne    8010137b <fileread+0xa9>
    ilock(f->ip);
8010131b:	8b 45 08             	mov    0x8(%ebp),%eax
8010131e:	8b 40 10             	mov    0x10(%eax),%eax
80101321:	83 ec 0c             	sub    $0xc,%esp
80101324:	50                   	push   %eax
80101325:	e8 aa 07 00 00       	call   80101ad4 <ilock>
8010132a:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010132d:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101330:	8b 45 08             	mov    0x8(%ebp),%eax
80101333:	8b 50 14             	mov    0x14(%eax),%edx
80101336:	8b 45 08             	mov    0x8(%ebp),%eax
80101339:	8b 40 10             	mov    0x10(%eax),%eax
8010133c:	51                   	push   %ecx
8010133d:	52                   	push   %edx
8010133e:	ff 75 0c             	pushl  0xc(%ebp)
80101341:	50                   	push   %eax
80101342:	e8 4b 0d 00 00       	call   80102092 <readi>
80101347:	83 c4 10             	add    $0x10,%esp
8010134a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010134d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101351:	7e 11                	jle    80101364 <fileread+0x92>
      f->off += r;
80101353:	8b 45 08             	mov    0x8(%ebp),%eax
80101356:	8b 50 14             	mov    0x14(%eax),%edx
80101359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135c:	01 c2                	add    %eax,%edx
8010135e:	8b 45 08             	mov    0x8(%ebp),%eax
80101361:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101364:	8b 45 08             	mov    0x8(%ebp),%eax
80101367:	8b 40 10             	mov    0x10(%eax),%eax
8010136a:	83 ec 0c             	sub    $0xc,%esp
8010136d:	50                   	push   %eax
8010136e:	e8 e7 08 00 00       	call   80101c5a <iunlock>
80101373:	83 c4 10             	add    $0x10,%esp
    return r;
80101376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101379:	eb 0d                	jmp    80101388 <fileread+0xb6>
  }
  panic("fileread");
8010137b:	83 ec 0c             	sub    $0xc,%esp
8010137e:	68 1b 98 10 80       	push   $0x8010981b
80101383:	e8 de f1 ff ff       	call   80100566 <panic>
}
80101388:	c9                   	leave  
80101389:	c3                   	ret    

8010138a <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010138a:	55                   	push   %ebp
8010138b:	89 e5                	mov    %esp,%ebp
8010138d:	53                   	push   %ebx
8010138e:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101391:	8b 45 08             	mov    0x8(%ebp),%eax
80101394:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101398:	84 c0                	test   %al,%al
8010139a:	75 0a                	jne    801013a6 <filewrite+0x1c>
    return -1;
8010139c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013a1:	e9 1b 01 00 00       	jmp    801014c1 <filewrite+0x137>
  if(f->type == FD_PIPE)
801013a6:	8b 45 08             	mov    0x8(%ebp),%eax
801013a9:	8b 00                	mov    (%eax),%eax
801013ab:	83 f8 01             	cmp    $0x1,%eax
801013ae:	75 1d                	jne    801013cd <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801013b0:	8b 45 08             	mov    0x8(%ebp),%eax
801013b3:	8b 40 0c             	mov    0xc(%eax),%eax
801013b6:	83 ec 04             	sub    $0x4,%esp
801013b9:	ff 75 10             	pushl  0x10(%ebp)
801013bc:	ff 75 0c             	pushl  0xc(%ebp)
801013bf:	50                   	push   %eax
801013c0:	e8 33 30 00 00       	call   801043f8 <pipewrite>
801013c5:	83 c4 10             	add    $0x10,%esp
801013c8:	e9 f4 00 00 00       	jmp    801014c1 <filewrite+0x137>
  if(f->type == FD_INODE){
801013cd:	8b 45 08             	mov    0x8(%ebp),%eax
801013d0:	8b 00                	mov    (%eax),%eax
801013d2:	83 f8 02             	cmp    $0x2,%eax
801013d5:	0f 85 d9 00 00 00    	jne    801014b4 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801013db:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801013e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801013e9:	e9 a3 00 00 00       	jmp    80101491 <filewrite+0x107>
      int n1 = n - i;
801013ee:	8b 45 10             	mov    0x10(%ebp),%eax
801013f1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801013f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801013f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013fa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801013fd:	7e 06                	jle    80101405 <filewrite+0x7b>
        n1 = max;
801013ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101402:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101405:	e8 fd 22 00 00       	call   80103707 <begin_op>
      ilock(f->ip);
8010140a:	8b 45 08             	mov    0x8(%ebp),%eax
8010140d:	8b 40 10             	mov    0x10(%eax),%eax
80101410:	83 ec 0c             	sub    $0xc,%esp
80101413:	50                   	push   %eax
80101414:	e8 bb 06 00 00       	call   80101ad4 <ilock>
80101419:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010141c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010141f:	8b 45 08             	mov    0x8(%ebp),%eax
80101422:	8b 50 14             	mov    0x14(%eax),%edx
80101425:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101428:	8b 45 0c             	mov    0xc(%ebp),%eax
8010142b:	01 c3                	add    %eax,%ebx
8010142d:	8b 45 08             	mov    0x8(%ebp),%eax
80101430:	8b 40 10             	mov    0x10(%eax),%eax
80101433:	51                   	push   %ecx
80101434:	52                   	push   %edx
80101435:	53                   	push   %ebx
80101436:	50                   	push   %eax
80101437:	e8 ad 0d 00 00       	call   801021e9 <writei>
8010143c:	83 c4 10             	add    $0x10,%esp
8010143f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101442:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101446:	7e 11                	jle    80101459 <filewrite+0xcf>
        f->off += r;
80101448:	8b 45 08             	mov    0x8(%ebp),%eax
8010144b:	8b 50 14             	mov    0x14(%eax),%edx
8010144e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101451:	01 c2                	add    %eax,%edx
80101453:	8b 45 08             	mov    0x8(%ebp),%eax
80101456:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101459:	8b 45 08             	mov    0x8(%ebp),%eax
8010145c:	8b 40 10             	mov    0x10(%eax),%eax
8010145f:	83 ec 0c             	sub    $0xc,%esp
80101462:	50                   	push   %eax
80101463:	e8 f2 07 00 00       	call   80101c5a <iunlock>
80101468:	83 c4 10             	add    $0x10,%esp
      end_op();
8010146b:	e8 23 23 00 00       	call   80103793 <end_op>

      if(r < 0)
80101470:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101474:	78 29                	js     8010149f <filewrite+0x115>
        break;
      if(r != n1)
80101476:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101479:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010147c:	74 0d                	je     8010148b <filewrite+0x101>
        panic("short filewrite");
8010147e:	83 ec 0c             	sub    $0xc,%esp
80101481:	68 24 98 10 80       	push   $0x80109824
80101486:	e8 db f0 ff ff       	call   80100566 <panic>
      i += r;
8010148b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010148e:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101491:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101494:	3b 45 10             	cmp    0x10(%ebp),%eax
80101497:	0f 8c 51 ff ff ff    	jl     801013ee <filewrite+0x64>
8010149d:	eb 01                	jmp    801014a0 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
8010149f:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014a3:	3b 45 10             	cmp    0x10(%ebp),%eax
801014a6:	75 05                	jne    801014ad <filewrite+0x123>
801014a8:	8b 45 10             	mov    0x10(%ebp),%eax
801014ab:	eb 14                	jmp    801014c1 <filewrite+0x137>
801014ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014b2:	eb 0d                	jmp    801014c1 <filewrite+0x137>
  }
  panic("filewrite");
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	68 34 98 10 80       	push   $0x80109834
801014bc:	e8 a5 f0 ff ff       	call   80100566 <panic>
}
801014c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014c4:	c9                   	leave  
801014c5:	c3                   	ret    

801014c6 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014c6:	55                   	push   %ebp
801014c7:	89 e5                	mov    %esp,%ebp
801014c9:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801014cc:	8b 45 08             	mov    0x8(%ebp),%eax
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	6a 01                	push   $0x1
801014d4:	50                   	push   %eax
801014d5:	e8 dc ec ff ff       	call   801001b6 <bread>
801014da:	83 c4 10             	add    $0x10,%esp
801014dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801014e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014e3:	83 c0 18             	add    $0x18,%eax
801014e6:	83 ec 04             	sub    $0x4,%esp
801014e9:	6a 1c                	push   $0x1c
801014eb:	50                   	push   %eax
801014ec:	ff 75 0c             	pushl  0xc(%ebp)
801014ef:	e8 82 4c 00 00       	call   80106176 <memmove>
801014f4:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014f7:	83 ec 0c             	sub    $0xc,%esp
801014fa:	ff 75 f4             	pushl  -0xc(%ebp)
801014fd:	e8 2c ed ff ff       	call   8010022e <brelse>
80101502:	83 c4 10             	add    $0x10,%esp
}
80101505:	90                   	nop
80101506:	c9                   	leave  
80101507:	c3                   	ret    

80101508 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101508:	55                   	push   %ebp
80101509:	89 e5                	mov    %esp,%ebp
8010150b:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010150e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101511:	8b 45 08             	mov    0x8(%ebp),%eax
80101514:	83 ec 08             	sub    $0x8,%esp
80101517:	52                   	push   %edx
80101518:	50                   	push   %eax
80101519:	e8 98 ec ff ff       	call   801001b6 <bread>
8010151e:	83 c4 10             	add    $0x10,%esp
80101521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101527:	83 c0 18             	add    $0x18,%eax
8010152a:	83 ec 04             	sub    $0x4,%esp
8010152d:	68 00 02 00 00       	push   $0x200
80101532:	6a 00                	push   $0x0
80101534:	50                   	push   %eax
80101535:	e8 7d 4b 00 00       	call   801060b7 <memset>
8010153a:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010153d:	83 ec 0c             	sub    $0xc,%esp
80101540:	ff 75 f4             	pushl  -0xc(%ebp)
80101543:	e8 f7 23 00 00       	call   8010393f <log_write>
80101548:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010154b:	83 ec 0c             	sub    $0xc,%esp
8010154e:	ff 75 f4             	pushl  -0xc(%ebp)
80101551:	e8 d8 ec ff ff       	call   8010022e <brelse>
80101556:	83 c4 10             	add    $0x10,%esp
}
80101559:	90                   	nop
8010155a:	c9                   	leave  
8010155b:	c3                   	ret    

8010155c <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010155c:	55                   	push   %ebp
8010155d:	89 e5                	mov    %esp,%ebp
8010155f:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101562:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101569:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101570:	e9 13 01 00 00       	jmp    80101688 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101575:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101578:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010157e:	85 c0                	test   %eax,%eax
80101580:	0f 48 c2             	cmovs  %edx,%eax
80101583:	c1 f8 0c             	sar    $0xc,%eax
80101586:	89 c2                	mov    %eax,%edx
80101588:	a1 58 32 11 80       	mov    0x80113258,%eax
8010158d:	01 d0                	add    %edx,%eax
8010158f:	83 ec 08             	sub    $0x8,%esp
80101592:	50                   	push   %eax
80101593:	ff 75 08             	pushl  0x8(%ebp)
80101596:	e8 1b ec ff ff       	call   801001b6 <bread>
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801015a8:	e9 a6 00 00 00       	jmp    80101653 <balloc+0xf7>
      m = 1 << (bi % 8);
801015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b0:	99                   	cltd   
801015b1:	c1 ea 1d             	shr    $0x1d,%edx
801015b4:	01 d0                	add    %edx,%eax
801015b6:	83 e0 07             	and    $0x7,%eax
801015b9:	29 d0                	sub    %edx,%eax
801015bb:	ba 01 00 00 00       	mov    $0x1,%edx
801015c0:	89 c1                	mov    %eax,%ecx
801015c2:	d3 e2                	shl    %cl,%edx
801015c4:	89 d0                	mov    %edx,%eax
801015c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015cc:	8d 50 07             	lea    0x7(%eax),%edx
801015cf:	85 c0                	test   %eax,%eax
801015d1:	0f 48 c2             	cmovs  %edx,%eax
801015d4:	c1 f8 03             	sar    $0x3,%eax
801015d7:	89 c2                	mov    %eax,%edx
801015d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015dc:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015e1:	0f b6 c0             	movzbl %al,%eax
801015e4:	23 45 e8             	and    -0x18(%ebp),%eax
801015e7:	85 c0                	test   %eax,%eax
801015e9:	75 64                	jne    8010164f <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801015eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ee:	8d 50 07             	lea    0x7(%eax),%edx
801015f1:	85 c0                	test   %eax,%eax
801015f3:	0f 48 c2             	cmovs  %edx,%eax
801015f6:	c1 f8 03             	sar    $0x3,%eax
801015f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801015fc:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101601:	89 d1                	mov    %edx,%ecx
80101603:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101606:	09 ca                	or     %ecx,%edx
80101608:	89 d1                	mov    %edx,%ecx
8010160a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010160d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101611:	83 ec 0c             	sub    $0xc,%esp
80101614:	ff 75 ec             	pushl  -0x14(%ebp)
80101617:	e8 23 23 00 00       	call   8010393f <log_write>
8010161c:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010161f:	83 ec 0c             	sub    $0xc,%esp
80101622:	ff 75 ec             	pushl  -0x14(%ebp)
80101625:	e8 04 ec ff ff       	call   8010022e <brelse>
8010162a:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010162d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101630:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101633:	01 c2                	add    %eax,%edx
80101635:	8b 45 08             	mov    0x8(%ebp),%eax
80101638:	83 ec 08             	sub    $0x8,%esp
8010163b:	52                   	push   %edx
8010163c:	50                   	push   %eax
8010163d:	e8 c6 fe ff ff       	call   80101508 <bzero>
80101642:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101645:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101648:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164b:	01 d0                	add    %edx,%eax
8010164d:	eb 57                	jmp    801016a6 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010164f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101653:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010165a:	7f 17                	jg     80101673 <balloc+0x117>
8010165c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101662:	01 d0                	add    %edx,%eax
80101664:	89 c2                	mov    %eax,%edx
80101666:	a1 40 32 11 80       	mov    0x80113240,%eax
8010166b:	39 c2                	cmp    %eax,%edx
8010166d:	0f 82 3a ff ff ff    	jb     801015ad <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101673:	83 ec 0c             	sub    $0xc,%esp
80101676:	ff 75 ec             	pushl  -0x14(%ebp)
80101679:	e8 b0 eb ff ff       	call   8010022e <brelse>
8010167e:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101681:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101688:	8b 15 40 32 11 80    	mov    0x80113240,%edx
8010168e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101691:	39 c2                	cmp    %eax,%edx
80101693:	0f 87 dc fe ff ff    	ja     80101575 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101699:	83 ec 0c             	sub    $0xc,%esp
8010169c:	68 40 98 10 80       	push   $0x80109840
801016a1:	e8 c0 ee ff ff       	call   80100566 <panic>
}
801016a6:	c9                   	leave  
801016a7:	c3                   	ret    

801016a8 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016a8:	55                   	push   %ebp
801016a9:	89 e5                	mov    %esp,%ebp
801016ab:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801016ae:	83 ec 08             	sub    $0x8,%esp
801016b1:	68 40 32 11 80       	push   $0x80113240
801016b6:	ff 75 08             	pushl  0x8(%ebp)
801016b9:	e8 08 fe ff ff       	call   801014c6 <readsb>
801016be:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801016c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801016c4:	c1 e8 0c             	shr    $0xc,%eax
801016c7:	89 c2                	mov    %eax,%edx
801016c9:	a1 58 32 11 80       	mov    0x80113258,%eax
801016ce:	01 c2                	add    %eax,%edx
801016d0:	8b 45 08             	mov    0x8(%ebp),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	52                   	push   %edx
801016d7:	50                   	push   %eax
801016d8:	e8 d9 ea ff ff       	call   801001b6 <bread>
801016dd:	83 c4 10             	add    $0x10,%esp
801016e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801016e6:	25 ff 0f 00 00       	and    $0xfff,%eax
801016eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801016ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f1:	99                   	cltd   
801016f2:	c1 ea 1d             	shr    $0x1d,%edx
801016f5:	01 d0                	add    %edx,%eax
801016f7:	83 e0 07             	and    $0x7,%eax
801016fa:	29 d0                	sub    %edx,%eax
801016fc:	ba 01 00 00 00       	mov    $0x1,%edx
80101701:	89 c1                	mov    %eax,%ecx
80101703:	d3 e2                	shl    %cl,%edx
80101705:	89 d0                	mov    %edx,%eax
80101707:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010170d:	8d 50 07             	lea    0x7(%eax),%edx
80101710:	85 c0                	test   %eax,%eax
80101712:	0f 48 c2             	cmovs  %edx,%eax
80101715:	c1 f8 03             	sar    $0x3,%eax
80101718:	89 c2                	mov    %eax,%edx
8010171a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010171d:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101722:	0f b6 c0             	movzbl %al,%eax
80101725:	23 45 ec             	and    -0x14(%ebp),%eax
80101728:	85 c0                	test   %eax,%eax
8010172a:	75 0d                	jne    80101739 <bfree+0x91>
    panic("freeing free block");
8010172c:	83 ec 0c             	sub    $0xc,%esp
8010172f:	68 56 98 10 80       	push   $0x80109856
80101734:	e8 2d ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
80101739:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010173c:	8d 50 07             	lea    0x7(%eax),%edx
8010173f:	85 c0                	test   %eax,%eax
80101741:	0f 48 c2             	cmovs  %edx,%eax
80101744:	c1 f8 03             	sar    $0x3,%eax
80101747:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010174a:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010174f:	89 d1                	mov    %edx,%ecx
80101751:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101754:	f7 d2                	not    %edx
80101756:	21 ca                	and    %ecx,%edx
80101758:	89 d1                	mov    %edx,%ecx
8010175a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010175d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101761:	83 ec 0c             	sub    $0xc,%esp
80101764:	ff 75 f4             	pushl  -0xc(%ebp)
80101767:	e8 d3 21 00 00       	call   8010393f <log_write>
8010176c:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	ff 75 f4             	pushl  -0xc(%ebp)
80101775:	e8 b4 ea ff ff       	call   8010022e <brelse>
8010177a:	83 c4 10             	add    $0x10,%esp
}
8010177d:	90                   	nop
8010177e:	c9                   	leave  
8010177f:	c3                   	ret    

80101780 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	57                   	push   %edi
80101784:	56                   	push   %esi
80101785:	53                   	push   %ebx
80101786:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101789:	83 ec 08             	sub    $0x8,%esp
8010178c:	68 69 98 10 80       	push   $0x80109869
80101791:	68 60 32 11 80       	push   $0x80113260
80101796:	e8 97 46 00 00       	call   80105e32 <initlock>
8010179b:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010179e:	83 ec 08             	sub    $0x8,%esp
801017a1:	68 40 32 11 80       	push   $0x80113240
801017a6:	ff 75 08             	pushl  0x8(%ebp)
801017a9:	e8 18 fd ff ff       	call   801014c6 <readsb>
801017ae:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801017b1:	a1 58 32 11 80       	mov    0x80113258,%eax
801017b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801017b9:	8b 3d 54 32 11 80    	mov    0x80113254,%edi
801017bf:	8b 35 50 32 11 80    	mov    0x80113250,%esi
801017c5:	8b 1d 4c 32 11 80    	mov    0x8011324c,%ebx
801017cb:	8b 0d 48 32 11 80    	mov    0x80113248,%ecx
801017d1:	8b 15 44 32 11 80    	mov    0x80113244,%edx
801017d7:	a1 40 32 11 80       	mov    0x80113240,%eax
801017dc:	ff 75 e4             	pushl  -0x1c(%ebp)
801017df:	57                   	push   %edi
801017e0:	56                   	push   %esi
801017e1:	53                   	push   %ebx
801017e2:	51                   	push   %ecx
801017e3:	52                   	push   %edx
801017e4:	50                   	push   %eax
801017e5:	68 70 98 10 80       	push   $0x80109870
801017ea:	e8 d7 eb ff ff       	call   801003c6 <cprintf>
801017ef:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801017f2:	90                   	nop
801017f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017f6:	5b                   	pop    %ebx
801017f7:	5e                   	pop    %esi
801017f8:	5f                   	pop    %edi
801017f9:	5d                   	pop    %ebp
801017fa:	c3                   	ret    

801017fb <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801017fb:	55                   	push   %ebp
801017fc:	89 e5                	mov    %esp,%ebp
801017fe:	83 ec 28             	sub    $0x28,%esp
80101801:	8b 45 0c             	mov    0xc(%ebp),%eax
80101804:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101808:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010180f:	e9 9e 00 00 00       	jmp    801018b2 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101817:	c1 e8 03             	shr    $0x3,%eax
8010181a:	89 c2                	mov    %eax,%edx
8010181c:	a1 54 32 11 80       	mov    0x80113254,%eax
80101821:	01 d0                	add    %edx,%eax
80101823:	83 ec 08             	sub    $0x8,%esp
80101826:	50                   	push   %eax
80101827:	ff 75 08             	pushl  0x8(%ebp)
8010182a:	e8 87 e9 ff ff       	call   801001b6 <bread>
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101835:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101838:	8d 50 18             	lea    0x18(%eax),%edx
8010183b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183e:	83 e0 07             	and    $0x7,%eax
80101841:	c1 e0 06             	shl    $0x6,%eax
80101844:	01 d0                	add    %edx,%eax
80101846:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101849:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010184c:	0f b7 00             	movzwl (%eax),%eax
8010184f:	66 85 c0             	test   %ax,%ax
80101852:	75 4c                	jne    801018a0 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101854:	83 ec 04             	sub    $0x4,%esp
80101857:	6a 40                	push   $0x40
80101859:	6a 00                	push   $0x0
8010185b:	ff 75 ec             	pushl  -0x14(%ebp)
8010185e:	e8 54 48 00 00       	call   801060b7 <memset>
80101863:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101866:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101869:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010186d:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101870:	83 ec 0c             	sub    $0xc,%esp
80101873:	ff 75 f0             	pushl  -0x10(%ebp)
80101876:	e8 c4 20 00 00       	call   8010393f <log_write>
8010187b:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010187e:	83 ec 0c             	sub    $0xc,%esp
80101881:	ff 75 f0             	pushl  -0x10(%ebp)
80101884:	e8 a5 e9 ff ff       	call   8010022e <brelse>
80101889:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188f:	83 ec 08             	sub    $0x8,%esp
80101892:	50                   	push   %eax
80101893:	ff 75 08             	pushl  0x8(%ebp)
80101896:	e8 20 01 00 00       	call   801019bb <iget>
8010189b:	83 c4 10             	add    $0x10,%esp
8010189e:	eb 30                	jmp    801018d0 <ialloc+0xd5>
    }
    brelse(bp);
801018a0:	83 ec 0c             	sub    $0xc,%esp
801018a3:	ff 75 f0             	pushl  -0x10(%ebp)
801018a6:	e8 83 e9 ff ff       	call   8010022e <brelse>
801018ab:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801018b2:	8b 15 48 32 11 80    	mov    0x80113248,%edx
801018b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018bb:	39 c2                	cmp    %eax,%edx
801018bd:	0f 87 51 ff ff ff    	ja     80101814 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801018c3:	83 ec 0c             	sub    $0xc,%esp
801018c6:	68 c3 98 10 80       	push   $0x801098c3
801018cb:	e8 96 ec ff ff       	call   80100566 <panic>
}
801018d0:	c9                   	leave  
801018d1:	c3                   	ret    

801018d2 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801018d2:	55                   	push   %ebp
801018d3:	89 e5                	mov    %esp,%ebp
801018d5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018d8:	8b 45 08             	mov    0x8(%ebp),%eax
801018db:	8b 40 04             	mov    0x4(%eax),%eax
801018de:	c1 e8 03             	shr    $0x3,%eax
801018e1:	89 c2                	mov    %eax,%edx
801018e3:	a1 54 32 11 80       	mov    0x80113254,%eax
801018e8:	01 c2                	add    %eax,%edx
801018ea:	8b 45 08             	mov    0x8(%ebp),%eax
801018ed:	8b 00                	mov    (%eax),%eax
801018ef:	83 ec 08             	sub    $0x8,%esp
801018f2:	52                   	push   %edx
801018f3:	50                   	push   %eax
801018f4:	e8 bd e8 ff ff       	call   801001b6 <bread>
801018f9:	83 c4 10             	add    $0x10,%esp
801018fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101902:	8d 50 18             	lea    0x18(%eax),%edx
80101905:	8b 45 08             	mov    0x8(%ebp),%eax
80101908:	8b 40 04             	mov    0x4(%eax),%eax
8010190b:	83 e0 07             	and    $0x7,%eax
8010190e:	c1 e0 06             	shl    $0x6,%eax
80101911:	01 d0                	add    %edx,%eax
80101913:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101916:	8b 45 08             	mov    0x8(%ebp),%eax
80101919:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101920:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101923:	8b 45 08             	mov    0x8(%ebp),%eax
80101926:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010192a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010192d:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101931:	8b 45 08             	mov    0x8(%ebp),%eax
80101934:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101938:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193b:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010193f:	8b 45 08             	mov    0x8(%ebp),%eax
80101942:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101946:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101949:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010194d:	8b 45 08             	mov    0x8(%ebp),%eax
80101950:	8b 50 20             	mov    0x20(%eax),%edx
80101953:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101956:	89 50 10             	mov    %edx,0x10(%eax)

  #ifdef CS333_P5 // Added for Project 5: inode / dinode
  dip->uid = ip->uid;
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	0f b7 50 18          	movzwl 0x18(%eax),%edx
80101960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101963:	66 89 50 08          	mov    %dx,0x8(%eax)
  dip->gid = ip->gid;
80101967:	8b 45 08             	mov    0x8(%ebp),%eax
8010196a:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
8010196e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101971:	66 89 50 0a          	mov    %dx,0xa(%eax)
  dip->mode.asInt = ip->mode.asInt;
80101975:	8b 45 08             	mov    0x8(%ebp),%eax
80101978:	8b 50 1c             	mov    0x1c(%eax),%edx
8010197b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197e:	89 50 0c             	mov    %edx,0xc(%eax)
  #endif

  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	8d 50 24             	lea    0x24(%eax),%edx
80101987:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198a:	83 c0 14             	add    $0x14,%eax
8010198d:	83 ec 04             	sub    $0x4,%esp
80101990:	6a 2c                	push   $0x2c
80101992:	52                   	push   %edx
80101993:	50                   	push   %eax
80101994:	e8 dd 47 00 00       	call   80106176 <memmove>
80101999:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010199c:	83 ec 0c             	sub    $0xc,%esp
8010199f:	ff 75 f4             	pushl  -0xc(%ebp)
801019a2:	e8 98 1f 00 00       	call   8010393f <log_write>
801019a7:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801019aa:	83 ec 0c             	sub    $0xc,%esp
801019ad:	ff 75 f4             	pushl  -0xc(%ebp)
801019b0:	e8 79 e8 ff ff       	call   8010022e <brelse>
801019b5:	83 c4 10             	add    $0x10,%esp
}
801019b8:	90                   	nop
801019b9:	c9                   	leave  
801019ba:	c3                   	ret    

801019bb <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019bb:	55                   	push   %ebp
801019bc:	89 e5                	mov    %esp,%ebp
801019be:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801019c1:	83 ec 0c             	sub    $0xc,%esp
801019c4:	68 60 32 11 80       	push   $0x80113260
801019c9:	e8 86 44 00 00       	call   80105e54 <acquire>
801019ce:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801019d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019d8:	c7 45 f4 94 32 11 80 	movl   $0x80113294,-0xc(%ebp)
801019df:	eb 5d                	jmp    80101a3e <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801019e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019e4:	8b 40 08             	mov    0x8(%eax),%eax
801019e7:	85 c0                	test   %eax,%eax
801019e9:	7e 39                	jle    80101a24 <iget+0x69>
801019eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ee:	8b 00                	mov    (%eax),%eax
801019f0:	3b 45 08             	cmp    0x8(%ebp),%eax
801019f3:	75 2f                	jne    80101a24 <iget+0x69>
801019f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f8:	8b 40 04             	mov    0x4(%eax),%eax
801019fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801019fe:	75 24                	jne    80101a24 <iget+0x69>
      ip->ref++;
80101a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a03:	8b 40 08             	mov    0x8(%eax),%eax
80101a06:	8d 50 01             	lea    0x1(%eax),%edx
80101a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a0c:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a0f:	83 ec 0c             	sub    $0xc,%esp
80101a12:	68 60 32 11 80       	push   $0x80113260
80101a17:	e8 9f 44 00 00       	call   80105ebb <release>
80101a1c:	83 c4 10             	add    $0x10,%esp
      return ip;
80101a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a22:	eb 74                	jmp    80101a98 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a28:	75 10                	jne    80101a3a <iget+0x7f>
80101a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a2d:	8b 40 08             	mov    0x8(%eax),%eax
80101a30:	85 c0                	test   %eax,%eax
80101a32:	75 06                	jne    80101a3a <iget+0x7f>
      empty = ip;
80101a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a37:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a3a:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101a3e:	81 7d f4 34 42 11 80 	cmpl   $0x80114234,-0xc(%ebp)
80101a45:	72 9a                	jb     801019e1 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a4b:	75 0d                	jne    80101a5a <iget+0x9f>
    panic("iget: no inodes");
80101a4d:	83 ec 0c             	sub    $0xc,%esp
80101a50:	68 d5 98 10 80       	push   $0x801098d5
80101a55:	e8 0c eb ff ff       	call   80100566 <panic>

  ip = empty;
80101a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101a6e:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a74:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a7e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101a85:	83 ec 0c             	sub    $0xc,%esp
80101a88:	68 60 32 11 80       	push   $0x80113260
80101a8d:	e8 29 44 00 00       	call   80105ebb <release>
80101a92:	83 c4 10             	add    $0x10,%esp

  return ip;
80101a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101a98:	c9                   	leave  
80101a99:	c3                   	ret    

80101a9a <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101a9a:	55                   	push   %ebp
80101a9b:	89 e5                	mov    %esp,%ebp
80101a9d:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101aa0:	83 ec 0c             	sub    $0xc,%esp
80101aa3:	68 60 32 11 80       	push   $0x80113260
80101aa8:	e8 a7 43 00 00       	call   80105e54 <acquire>
80101aad:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab3:	8b 40 08             	mov    0x8(%eax),%eax
80101ab6:	8d 50 01             	lea    0x1(%eax),%edx
80101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80101abc:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101abf:	83 ec 0c             	sub    $0xc,%esp
80101ac2:	68 60 32 11 80       	push   $0x80113260
80101ac7:	e8 ef 43 00 00       	call   80105ebb <release>
80101acc:	83 c4 10             	add    $0x10,%esp
  return ip;
80101acf:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ad2:	c9                   	leave  
80101ad3:	c3                   	ret    

80101ad4 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101ad4:	55                   	push   %ebp
80101ad5:	89 e5                	mov    %esp,%ebp
80101ad7:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101ada:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101ade:	74 0a                	je     80101aea <ilock+0x16>
80101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae3:	8b 40 08             	mov    0x8(%eax),%eax
80101ae6:	85 c0                	test   %eax,%eax
80101ae8:	7f 0d                	jg     80101af7 <ilock+0x23>
    panic("ilock");
80101aea:	83 ec 0c             	sub    $0xc,%esp
80101aed:	68 e5 98 10 80       	push   $0x801098e5
80101af2:	e8 6f ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101af7:	83 ec 0c             	sub    $0xc,%esp
80101afa:	68 60 32 11 80       	push   $0x80113260
80101aff:	e8 50 43 00 00       	call   80105e54 <acquire>
80101b04:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101b07:	eb 13                	jmp    80101b1c <ilock+0x48>
    sleep(ip, &icache.lock);
80101b09:	83 ec 08             	sub    $0x8,%esp
80101b0c:	68 60 32 11 80       	push   $0x80113260
80101b11:	ff 75 08             	pushl  0x8(%ebp)
80101b14:	e8 ae 34 00 00       	call   80104fc7 <sleep>
80101b19:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1f:	8b 40 0c             	mov    0xc(%eax),%eax
80101b22:	83 e0 01             	and    $0x1,%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	75 e0                	jne    80101b09 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2c:	8b 40 0c             	mov    0xc(%eax),%eax
80101b2f:	83 c8 01             	or     $0x1,%eax
80101b32:	89 c2                	mov    %eax,%edx
80101b34:	8b 45 08             	mov    0x8(%ebp),%eax
80101b37:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101b3a:	83 ec 0c             	sub    $0xc,%esp
80101b3d:	68 60 32 11 80       	push   $0x80113260
80101b42:	e8 74 43 00 00       	call   80105ebb <release>
80101b47:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4d:	8b 40 0c             	mov    0xc(%eax),%eax
80101b50:	83 e0 02             	and    $0x2,%eax
80101b53:	85 c0                	test   %eax,%eax
80101b55:	0f 85 fc 00 00 00    	jne    80101c57 <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5e:	8b 40 04             	mov    0x4(%eax),%eax
80101b61:	c1 e8 03             	shr    $0x3,%eax
80101b64:	89 c2                	mov    %eax,%edx
80101b66:	a1 54 32 11 80       	mov    0x80113254,%eax
80101b6b:	01 c2                	add    %eax,%edx
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 00                	mov    (%eax),%eax
80101b72:	83 ec 08             	sub    $0x8,%esp
80101b75:	52                   	push   %edx
80101b76:	50                   	push   %eax
80101b77:	e8 3a e6 ff ff       	call   801001b6 <bread>
80101b7c:	83 c4 10             	add    $0x10,%esp
80101b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b85:	8d 50 18             	lea    0x18(%eax),%edx
80101b88:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8b:	8b 40 04             	mov    0x4(%eax),%eax
80101b8e:	83 e0 07             	and    $0x7,%eax
80101b91:	c1 e0 06             	shl    $0x6,%eax
80101b94:	01 d0                	add    %edx,%eax
80101b96:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b9c:	0f b7 10             	movzwl (%eax),%edx
80101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba2:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ba9:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101bad:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb0:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bb7:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbe:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bc5:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcc:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd3:	8b 50 10             	mov    0x10(%eax),%edx
80101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd9:	89 50 20             	mov    %edx,0x20(%eax)

    #ifdef CS333_P5
    ip->uid = dip->uid;
80101bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bdf:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80101be3:	8b 45 08             	mov    0x8(%ebp),%eax
80101be6:	66 89 50 18          	mov    %dx,0x18(%eax)
    ip->gid = dip->gid;
80101bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bed:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
80101bf1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf4:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    ip->mode.asInt = dip->mode.asInt;
80101bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bfb:	8b 50 0c             	mov    0xc(%eax),%edx
80101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
80101c01:	89 50 1c             	mov    %edx,0x1c(%eax)
    #endif

    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c07:	8d 50 14             	lea    0x14(%eax),%edx
80101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0d:	83 c0 24             	add    $0x24,%eax
80101c10:	83 ec 04             	sub    $0x4,%esp
80101c13:	6a 2c                	push   $0x2c
80101c15:	52                   	push   %edx
80101c16:	50                   	push   %eax
80101c17:	e8 5a 45 00 00       	call   80106176 <memmove>
80101c1c:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101c1f:	83 ec 0c             	sub    $0xc,%esp
80101c22:	ff 75 f4             	pushl  -0xc(%ebp)
80101c25:	e8 04 e6 ff ff       	call   8010022e <brelse>
80101c2a:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c30:	8b 40 0c             	mov    0xc(%eax),%eax
80101c33:	83 c8 02             	or     $0x2,%eax
80101c36:	89 c2                	mov    %eax,%edx
80101c38:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3b:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c41:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101c45:	66 85 c0             	test   %ax,%ax
80101c48:	75 0d                	jne    80101c57 <ilock+0x183>
      panic("ilock: no type");
80101c4a:	83 ec 0c             	sub    $0xc,%esp
80101c4d:	68 eb 98 10 80       	push   $0x801098eb
80101c52:	e8 0f e9 ff ff       	call   80100566 <panic>
  }
}
80101c57:	90                   	nop
80101c58:	c9                   	leave  
80101c59:	c3                   	ret    

80101c5a <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101c5a:	55                   	push   %ebp
80101c5b:	89 e5                	mov    %esp,%ebp
80101c5d:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101c60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c64:	74 17                	je     80101c7d <iunlock+0x23>
80101c66:	8b 45 08             	mov    0x8(%ebp),%eax
80101c69:	8b 40 0c             	mov    0xc(%eax),%eax
80101c6c:	83 e0 01             	and    $0x1,%eax
80101c6f:	85 c0                	test   %eax,%eax
80101c71:	74 0a                	je     80101c7d <iunlock+0x23>
80101c73:	8b 45 08             	mov    0x8(%ebp),%eax
80101c76:	8b 40 08             	mov    0x8(%eax),%eax
80101c79:	85 c0                	test   %eax,%eax
80101c7b:	7f 0d                	jg     80101c8a <iunlock+0x30>
    panic("iunlock");
80101c7d:	83 ec 0c             	sub    $0xc,%esp
80101c80:	68 fa 98 10 80       	push   $0x801098fa
80101c85:	e8 dc e8 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101c8a:	83 ec 0c             	sub    $0xc,%esp
80101c8d:	68 60 32 11 80       	push   $0x80113260
80101c92:	e8 bd 41 00 00       	call   80105e54 <acquire>
80101c97:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9d:	8b 40 0c             	mov    0xc(%eax),%eax
80101ca0:	83 e0 fe             	and    $0xfffffffe,%eax
80101ca3:	89 c2                	mov    %eax,%edx
80101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca8:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
80101cae:	ff 75 08             	pushl  0x8(%ebp)
80101cb1:	e8 f8 33 00 00       	call   801050ae <wakeup>
80101cb6:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101cb9:	83 ec 0c             	sub    $0xc,%esp
80101cbc:	68 60 32 11 80       	push   $0x80113260
80101cc1:	e8 f5 41 00 00       	call   80105ebb <release>
80101cc6:	83 c4 10             	add    $0x10,%esp
}
80101cc9:	90                   	nop
80101cca:	c9                   	leave  
80101ccb:	c3                   	ret    

80101ccc <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101ccc:	55                   	push   %ebp
80101ccd:	89 e5                	mov    %esp,%ebp
80101ccf:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101cd2:	83 ec 0c             	sub    $0xc,%esp
80101cd5:	68 60 32 11 80       	push   $0x80113260
80101cda:	e8 75 41 00 00       	call   80105e54 <acquire>
80101cdf:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101ce2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce5:	8b 40 08             	mov    0x8(%eax),%eax
80101ce8:	83 f8 01             	cmp    $0x1,%eax
80101ceb:	0f 85 a9 00 00 00    	jne    80101d9a <iput+0xce>
80101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf4:	8b 40 0c             	mov    0xc(%eax),%eax
80101cf7:	83 e0 02             	and    $0x2,%eax
80101cfa:	85 c0                	test   %eax,%eax
80101cfc:	0f 84 98 00 00 00    	je     80101d9a <iput+0xce>
80101d02:	8b 45 08             	mov    0x8(%ebp),%eax
80101d05:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101d09:	66 85 c0             	test   %ax,%ax
80101d0c:	0f 85 88 00 00 00    	jne    80101d9a <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101d12:	8b 45 08             	mov    0x8(%ebp),%eax
80101d15:	8b 40 0c             	mov    0xc(%eax),%eax
80101d18:	83 e0 01             	and    $0x1,%eax
80101d1b:	85 c0                	test   %eax,%eax
80101d1d:	74 0d                	je     80101d2c <iput+0x60>
      panic("iput busy");
80101d1f:	83 ec 0c             	sub    $0xc,%esp
80101d22:	68 02 99 10 80       	push   $0x80109902
80101d27:	e8 3a e8 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2f:	8b 40 0c             	mov    0xc(%eax),%eax
80101d32:	83 c8 01             	or     $0x1,%eax
80101d35:	89 c2                	mov    %eax,%edx
80101d37:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3a:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101d3d:	83 ec 0c             	sub    $0xc,%esp
80101d40:	68 60 32 11 80       	push   $0x80113260
80101d45:	e8 71 41 00 00       	call   80105ebb <release>
80101d4a:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101d4d:	83 ec 0c             	sub    $0xc,%esp
80101d50:	ff 75 08             	pushl  0x8(%ebp)
80101d53:	e8 a8 01 00 00       	call   80101f00 <itrunc>
80101d58:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5e:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	ff 75 08             	pushl  0x8(%ebp)
80101d6a:	e8 63 fb ff ff       	call   801018d2 <iupdate>
80101d6f:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101d72:	83 ec 0c             	sub    $0xc,%esp
80101d75:	68 60 32 11 80       	push   $0x80113260
80101d7a:	e8 d5 40 00 00       	call   80105e54 <acquire>
80101d7f:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101d82:	8b 45 08             	mov    0x8(%ebp),%eax
80101d85:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	ff 75 08             	pushl  0x8(%ebp)
80101d92:	e8 17 33 00 00       	call   801050ae <wakeup>
80101d97:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9d:	8b 40 08             	mov    0x8(%eax),%eax
80101da0:	8d 50 ff             	lea    -0x1(%eax),%edx
80101da3:	8b 45 08             	mov    0x8(%ebp),%eax
80101da6:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101da9:	83 ec 0c             	sub    $0xc,%esp
80101dac:	68 60 32 11 80       	push   $0x80113260
80101db1:	e8 05 41 00 00       	call   80105ebb <release>
80101db6:	83 c4 10             	add    $0x10,%esp
}
80101db9:	90                   	nop
80101dba:	c9                   	leave  
80101dbb:	c3                   	ret    

80101dbc <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101dbc:	55                   	push   %ebp
80101dbd:	89 e5                	mov    %esp,%ebp
80101dbf:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101dc2:	83 ec 0c             	sub    $0xc,%esp
80101dc5:	ff 75 08             	pushl  0x8(%ebp)
80101dc8:	e8 8d fe ff ff       	call   80101c5a <iunlock>
80101dcd:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	ff 75 08             	pushl  0x8(%ebp)
80101dd6:	e8 f1 fe ff ff       	call   80101ccc <iput>
80101ddb:	83 c4 10             	add    $0x10,%esp
}
80101dde:	90                   	nop
80101ddf:	c9                   	leave  
80101de0:	c3                   	ret    

80101de1 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101de1:	55                   	push   %ebp
80101de2:	89 e5                	mov    %esp,%ebp
80101de4:	53                   	push   %ebx
80101de5:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101de8:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101dec:	77 42                	ja     80101e30 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101dee:	8b 45 08             	mov    0x8(%ebp),%eax
80101df1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101df4:	83 c2 08             	add    $0x8,%edx
80101df7:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e02:	75 24                	jne    80101e28 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e04:	8b 45 08             	mov    0x8(%ebp),%eax
80101e07:	8b 00                	mov    (%eax),%eax
80101e09:	83 ec 0c             	sub    $0xc,%esp
80101e0c:	50                   	push   %eax
80101e0d:	e8 4a f7 ff ff       	call   8010155c <balloc>
80101e12:	83 c4 10             	add    $0x10,%esp
80101e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e18:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e1e:	8d 4a 08             	lea    0x8(%edx),%ecx
80101e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e24:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    return addr;
80101e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e2b:	e9 cb 00 00 00       	jmp    80101efb <bmap+0x11a>
  }
  bn -= NDIRECT;
80101e30:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80101e34:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101e38:	0f 87 b0 00 00 00    	ja     80101eee <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101e3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e41:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e4b:	75 1d                	jne    80101e6a <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e50:	8b 00                	mov    (%eax),%eax
80101e52:	83 ec 0c             	sub    $0xc,%esp
80101e55:	50                   	push   %eax
80101e56:	e8 01 f7 ff ff       	call   8010155c <balloc>
80101e5b:	83 c4 10             	add    $0x10,%esp
80101e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e61:	8b 45 08             	mov    0x8(%ebp),%eax
80101e64:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e67:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6d:	8b 00                	mov    (%eax),%eax
80101e6f:	83 ec 08             	sub    $0x8,%esp
80101e72:	ff 75 f4             	pushl  -0xc(%ebp)
80101e75:	50                   	push   %eax
80101e76:	e8 3b e3 ff ff       	call   801001b6 <bread>
80101e7b:	83 c4 10             	add    $0x10,%esp
80101e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e84:	83 c0 18             	add    $0x18,%eax
80101e87:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e94:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e97:	01 d0                	add    %edx,%eax
80101e99:	8b 00                	mov    (%eax),%eax
80101e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ea2:	75 37                	jne    80101edb <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eb1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101eb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb7:	8b 00                	mov    (%eax),%eax
80101eb9:	83 ec 0c             	sub    $0xc,%esp
80101ebc:	50                   	push   %eax
80101ebd:	e8 9a f6 ff ff       	call   8010155c <balloc>
80101ec2:	83 c4 10             	add    $0x10,%esp
80101ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ecb:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ecd:	83 ec 0c             	sub    $0xc,%esp
80101ed0:	ff 75 f0             	pushl  -0x10(%ebp)
80101ed3:	e8 67 1a 00 00       	call   8010393f <log_write>
80101ed8:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101edb:	83 ec 0c             	sub    $0xc,%esp
80101ede:	ff 75 f0             	pushl  -0x10(%ebp)
80101ee1:	e8 48 e3 ff ff       	call   8010022e <brelse>
80101ee6:	83 c4 10             	add    $0x10,%esp
    return addr;
80101ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eec:	eb 0d                	jmp    80101efb <bmap+0x11a>
  }

  panic("bmap: out of range");
80101eee:	83 ec 0c             	sub    $0xc,%esp
80101ef1:	68 0c 99 10 80       	push   $0x8010990c
80101ef6:	e8 6b e6 ff ff       	call   80100566 <panic>
}
80101efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101efe:	c9                   	leave  
80101eff:	c3                   	ret    

80101f00 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f0d:	eb 45                	jmp    80101f54 <itrunc+0x54>
    if(ip->addrs[i]){
80101f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f12:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f15:	83 c2 08             	add    $0x8,%edx
80101f18:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101f1c:	85 c0                	test   %eax,%eax
80101f1e:	74 30                	je     80101f50 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101f20:	8b 45 08             	mov    0x8(%ebp),%eax
80101f23:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f26:	83 c2 08             	add    $0x8,%edx
80101f29:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101f2d:	8b 55 08             	mov    0x8(%ebp),%edx
80101f30:	8b 12                	mov    (%edx),%edx
80101f32:	83 ec 08             	sub    $0x8,%esp
80101f35:	50                   	push   %eax
80101f36:	52                   	push   %edx
80101f37:	e8 6c f7 ff ff       	call   801016a8 <bfree>
80101f3c:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f42:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f45:	83 c2 08             	add    $0x8,%edx
80101f48:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
80101f4f:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f50:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101f54:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80101f58:	7e b5                	jle    80101f0f <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101f5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5d:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f60:	85 c0                	test   %eax,%eax
80101f62:	0f 84 a1 00 00 00    	je     80102009 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f68:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6b:	8b 50 4c             	mov    0x4c(%eax),%edx
80101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f71:	8b 00                	mov    (%eax),%eax
80101f73:	83 ec 08             	sub    $0x8,%esp
80101f76:	52                   	push   %edx
80101f77:	50                   	push   %eax
80101f78:	e8 39 e2 ff ff       	call   801001b6 <bread>
80101f7d:	83 c4 10             	add    $0x10,%esp
80101f80:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f86:	83 c0 18             	add    $0x18,%eax
80101f89:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101f8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101f93:	eb 3c                	jmp    80101fd1 <itrunc+0xd1>
      if(a[j])
80101f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fa2:	01 d0                	add    %edx,%eax
80101fa4:	8b 00                	mov    (%eax),%eax
80101fa6:	85 c0                	test   %eax,%eax
80101fa8:	74 23                	je     80101fcd <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fb7:	01 d0                	add    %edx,%eax
80101fb9:	8b 00                	mov    (%eax),%eax
80101fbb:	8b 55 08             	mov    0x8(%ebp),%edx
80101fbe:	8b 12                	mov    (%edx),%edx
80101fc0:	83 ec 08             	sub    $0x8,%esp
80101fc3:	50                   	push   %eax
80101fc4:	52                   	push   %edx
80101fc5:	e8 de f6 ff ff       	call   801016a8 <bfree>
80101fca:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101fcd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fd4:	83 f8 7f             	cmp    $0x7f,%eax
80101fd7:	76 bc                	jbe    80101f95 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101fd9:	83 ec 0c             	sub    $0xc,%esp
80101fdc:	ff 75 ec             	pushl  -0x14(%ebp)
80101fdf:	e8 4a e2 ff ff       	call   8010022e <brelse>
80101fe4:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101fe7:	8b 45 08             	mov    0x8(%ebp),%eax
80101fea:	8b 40 4c             	mov    0x4c(%eax),%eax
80101fed:	8b 55 08             	mov    0x8(%ebp),%edx
80101ff0:	8b 12                	mov    (%edx),%edx
80101ff2:	83 ec 08             	sub    $0x8,%esp
80101ff5:	50                   	push   %eax
80101ff6:	52                   	push   %edx
80101ff7:	e8 ac f6 ff ff       	call   801016a8 <bfree>
80101ffc:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101fff:	8b 45 08             	mov    0x8(%ebp),%eax
80102002:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80102009:	8b 45 08             	mov    0x8(%ebp),%eax
8010200c:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  iupdate(ip);
80102013:	83 ec 0c             	sub    $0xc,%esp
80102016:	ff 75 08             	pushl  0x8(%ebp)
80102019:	e8 b4 f8 ff ff       	call   801018d2 <iupdate>
8010201e:	83 c4 10             	add    $0x10,%esp
}
80102021:	90                   	nop
80102022:	c9                   	leave  
80102023:	c3                   	ret    

80102024 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80102024:	55                   	push   %ebp
80102025:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80102027:	8b 45 08             	mov    0x8(%ebp),%eax
8010202a:	8b 00                	mov    (%eax),%eax
8010202c:	89 c2                	mov    %eax,%edx
8010202e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102031:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80102034:	8b 45 08             	mov    0x8(%ebp),%eax
80102037:	8b 50 04             	mov    0x4(%eax),%edx
8010203a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010203d:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80102040:	8b 45 08             	mov    0x8(%ebp),%eax
80102043:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80102047:	8b 45 0c             	mov    0xc(%ebp),%eax
8010204a:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
8010204d:	8b 45 08             	mov    0x8(%ebp),%eax
80102050:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80102054:	8b 45 0c             	mov    0xc(%ebp),%eax
80102057:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
8010205b:	8b 45 08             	mov    0x8(%ebp),%eax
8010205e:	8b 50 20             	mov    0x20(%eax),%edx
80102061:	8b 45 0c             	mov    0xc(%ebp),%eax
80102064:	89 50 18             	mov    %edx,0x18(%eax)
  
  #ifdef CS333_P5
  st->uid = ip->uid;
80102067:	8b 45 08             	mov    0x8(%ebp),%eax
8010206a:	0f b7 50 18          	movzwl 0x18(%eax),%edx
8010206e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102071:	66 89 50 0e          	mov    %dx,0xe(%eax)
  st->gid = ip->gid;
80102075:	8b 45 08             	mov    0x8(%ebp),%eax
80102078:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
8010207c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010207f:	66 89 50 10          	mov    %dx,0x10(%eax)
  st->mode.asInt = ip->mode.asInt;
80102083:	8b 45 08             	mov    0x8(%ebp),%eax
80102086:	8b 50 1c             	mov    0x1c(%eax),%edx
80102089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010208c:	89 50 14             	mov    %edx,0x14(%eax)
  #endif
}
8010208f:	90                   	nop
80102090:	5d                   	pop    %ebp
80102091:	c3                   	ret    

80102092 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102092:	55                   	push   %ebp
80102093:	89 e5                	mov    %esp,%ebp
80102095:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102098:	8b 45 08             	mov    0x8(%ebp),%eax
8010209b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010209f:	66 83 f8 03          	cmp    $0x3,%ax
801020a3:	75 5c                	jne    80102101 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801020a5:	8b 45 08             	mov    0x8(%ebp),%eax
801020a8:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020ac:	66 85 c0             	test   %ax,%ax
801020af:	78 20                	js     801020d1 <readi+0x3f>
801020b1:	8b 45 08             	mov    0x8(%ebp),%eax
801020b4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020b8:	66 83 f8 09          	cmp    $0x9,%ax
801020bc:	7f 13                	jg     801020d1 <readi+0x3f>
801020be:	8b 45 08             	mov    0x8(%ebp),%eax
801020c1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020c5:	98                   	cwtl   
801020c6:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
801020cd:	85 c0                	test   %eax,%eax
801020cf:	75 0a                	jne    801020db <readi+0x49>
      return -1;
801020d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d6:	e9 0c 01 00 00       	jmp    801021e7 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
801020de:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020e2:	98                   	cwtl   
801020e3:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
801020ea:	8b 55 14             	mov    0x14(%ebp),%edx
801020ed:	83 ec 04             	sub    $0x4,%esp
801020f0:	52                   	push   %edx
801020f1:	ff 75 0c             	pushl  0xc(%ebp)
801020f4:	ff 75 08             	pushl  0x8(%ebp)
801020f7:	ff d0                	call   *%eax
801020f9:	83 c4 10             	add    $0x10,%esp
801020fc:	e9 e6 00 00 00       	jmp    801021e7 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80102101:	8b 45 08             	mov    0x8(%ebp),%eax
80102104:	8b 40 20             	mov    0x20(%eax),%eax
80102107:	3b 45 10             	cmp    0x10(%ebp),%eax
8010210a:	72 0d                	jb     80102119 <readi+0x87>
8010210c:	8b 55 10             	mov    0x10(%ebp),%edx
8010210f:	8b 45 14             	mov    0x14(%ebp),%eax
80102112:	01 d0                	add    %edx,%eax
80102114:	3b 45 10             	cmp    0x10(%ebp),%eax
80102117:	73 0a                	jae    80102123 <readi+0x91>
    return -1;
80102119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010211e:	e9 c4 00 00 00       	jmp    801021e7 <readi+0x155>
  if(off + n > ip->size)
80102123:	8b 55 10             	mov    0x10(%ebp),%edx
80102126:	8b 45 14             	mov    0x14(%ebp),%eax
80102129:	01 c2                	add    %eax,%edx
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
8010212e:	8b 40 20             	mov    0x20(%eax),%eax
80102131:	39 c2                	cmp    %eax,%edx
80102133:	76 0c                	jbe    80102141 <readi+0xaf>
    n = ip->size - off;
80102135:	8b 45 08             	mov    0x8(%ebp),%eax
80102138:	8b 40 20             	mov    0x20(%eax),%eax
8010213b:	2b 45 10             	sub    0x10(%ebp),%eax
8010213e:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102141:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102148:	e9 8b 00 00 00       	jmp    801021d8 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010214d:	8b 45 10             	mov    0x10(%ebp),%eax
80102150:	c1 e8 09             	shr    $0x9,%eax
80102153:	83 ec 08             	sub    $0x8,%esp
80102156:	50                   	push   %eax
80102157:	ff 75 08             	pushl  0x8(%ebp)
8010215a:	e8 82 fc ff ff       	call   80101de1 <bmap>
8010215f:	83 c4 10             	add    $0x10,%esp
80102162:	89 c2                	mov    %eax,%edx
80102164:	8b 45 08             	mov    0x8(%ebp),%eax
80102167:	8b 00                	mov    (%eax),%eax
80102169:	83 ec 08             	sub    $0x8,%esp
8010216c:	52                   	push   %edx
8010216d:	50                   	push   %eax
8010216e:	e8 43 e0 ff ff       	call   801001b6 <bread>
80102173:	83 c4 10             	add    $0x10,%esp
80102176:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102179:	8b 45 10             	mov    0x10(%ebp),%eax
8010217c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102181:	ba 00 02 00 00       	mov    $0x200,%edx
80102186:	29 c2                	sub    %eax,%edx
80102188:	8b 45 14             	mov    0x14(%ebp),%eax
8010218b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010218e:	39 c2                	cmp    %eax,%edx
80102190:	0f 46 c2             	cmovbe %edx,%eax
80102193:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102196:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102199:	8d 50 18             	lea    0x18(%eax),%edx
8010219c:	8b 45 10             	mov    0x10(%ebp),%eax
8010219f:	25 ff 01 00 00       	and    $0x1ff,%eax
801021a4:	01 d0                	add    %edx,%eax
801021a6:	83 ec 04             	sub    $0x4,%esp
801021a9:	ff 75 ec             	pushl  -0x14(%ebp)
801021ac:	50                   	push   %eax
801021ad:	ff 75 0c             	pushl  0xc(%ebp)
801021b0:	e8 c1 3f 00 00       	call   80106176 <memmove>
801021b5:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	ff 75 f0             	pushl  -0x10(%ebp)
801021be:	e8 6b e0 ff ff       	call   8010022e <brelse>
801021c3:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021c9:	01 45 f4             	add    %eax,-0xc(%ebp)
801021cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021cf:	01 45 10             	add    %eax,0x10(%ebp)
801021d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021d5:	01 45 0c             	add    %eax,0xc(%ebp)
801021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021db:	3b 45 14             	cmp    0x14(%ebp),%eax
801021de:	0f 82 69 ff ff ff    	jb     8010214d <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801021e4:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021e7:	c9                   	leave  
801021e8:	c3                   	ret    

801021e9 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801021e9:	55                   	push   %ebp
801021ea:	89 e5                	mov    %esp,%ebp
801021ec:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801021ef:	8b 45 08             	mov    0x8(%ebp),%eax
801021f2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801021f6:	66 83 f8 03          	cmp    $0x3,%ax
801021fa:	75 5c                	jne    80102258 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801021fc:	8b 45 08             	mov    0x8(%ebp),%eax
801021ff:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102203:	66 85 c0             	test   %ax,%ax
80102206:	78 20                	js     80102228 <writei+0x3f>
80102208:	8b 45 08             	mov    0x8(%ebp),%eax
8010220b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010220f:	66 83 f8 09          	cmp    $0x9,%ax
80102213:	7f 13                	jg     80102228 <writei+0x3f>
80102215:	8b 45 08             	mov    0x8(%ebp),%eax
80102218:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010221c:	98                   	cwtl   
8010221d:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
80102224:	85 c0                	test   %eax,%eax
80102226:	75 0a                	jne    80102232 <writei+0x49>
      return -1;
80102228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010222d:	e9 3d 01 00 00       	jmp    8010236f <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102232:	8b 45 08             	mov    0x8(%ebp),%eax
80102235:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102239:	98                   	cwtl   
8010223a:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
80102241:	8b 55 14             	mov    0x14(%ebp),%edx
80102244:	83 ec 04             	sub    $0x4,%esp
80102247:	52                   	push   %edx
80102248:	ff 75 0c             	pushl  0xc(%ebp)
8010224b:	ff 75 08             	pushl  0x8(%ebp)
8010224e:	ff d0                	call   *%eax
80102250:	83 c4 10             	add    $0x10,%esp
80102253:	e9 17 01 00 00       	jmp    8010236f <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102258:	8b 45 08             	mov    0x8(%ebp),%eax
8010225b:	8b 40 20             	mov    0x20(%eax),%eax
8010225e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102261:	72 0d                	jb     80102270 <writei+0x87>
80102263:	8b 55 10             	mov    0x10(%ebp),%edx
80102266:	8b 45 14             	mov    0x14(%ebp),%eax
80102269:	01 d0                	add    %edx,%eax
8010226b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010226e:	73 0a                	jae    8010227a <writei+0x91>
    return -1;
80102270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102275:	e9 f5 00 00 00       	jmp    8010236f <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010227a:	8b 55 10             	mov    0x10(%ebp),%edx
8010227d:	8b 45 14             	mov    0x14(%ebp),%eax
80102280:	01 d0                	add    %edx,%eax
80102282:	3d 00 14 01 00       	cmp    $0x11400,%eax
80102287:	76 0a                	jbe    80102293 <writei+0xaa>
    return -1;
80102289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010228e:	e9 dc 00 00 00       	jmp    8010236f <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102293:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010229a:	e9 99 00 00 00       	jmp    80102338 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010229f:	8b 45 10             	mov    0x10(%ebp),%eax
801022a2:	c1 e8 09             	shr    $0x9,%eax
801022a5:	83 ec 08             	sub    $0x8,%esp
801022a8:	50                   	push   %eax
801022a9:	ff 75 08             	pushl  0x8(%ebp)
801022ac:	e8 30 fb ff ff       	call   80101de1 <bmap>
801022b1:	83 c4 10             	add    $0x10,%esp
801022b4:	89 c2                	mov    %eax,%edx
801022b6:	8b 45 08             	mov    0x8(%ebp),%eax
801022b9:	8b 00                	mov    (%eax),%eax
801022bb:	83 ec 08             	sub    $0x8,%esp
801022be:	52                   	push   %edx
801022bf:	50                   	push   %eax
801022c0:	e8 f1 de ff ff       	call   801001b6 <bread>
801022c5:	83 c4 10             	add    $0x10,%esp
801022c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801022cb:	8b 45 10             	mov    0x10(%ebp),%eax
801022ce:	25 ff 01 00 00       	and    $0x1ff,%eax
801022d3:	ba 00 02 00 00       	mov    $0x200,%edx
801022d8:	29 c2                	sub    %eax,%edx
801022da:	8b 45 14             	mov    0x14(%ebp),%eax
801022dd:	2b 45 f4             	sub    -0xc(%ebp),%eax
801022e0:	39 c2                	cmp    %eax,%edx
801022e2:	0f 46 c2             	cmovbe %edx,%eax
801022e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022eb:	8d 50 18             	lea    0x18(%eax),%edx
801022ee:	8b 45 10             	mov    0x10(%ebp),%eax
801022f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801022f6:	01 d0                	add    %edx,%eax
801022f8:	83 ec 04             	sub    $0x4,%esp
801022fb:	ff 75 ec             	pushl  -0x14(%ebp)
801022fe:	ff 75 0c             	pushl  0xc(%ebp)
80102301:	50                   	push   %eax
80102302:	e8 6f 3e 00 00       	call   80106176 <memmove>
80102307:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010230a:	83 ec 0c             	sub    $0xc,%esp
8010230d:	ff 75 f0             	pushl  -0x10(%ebp)
80102310:	e8 2a 16 00 00       	call   8010393f <log_write>
80102315:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102318:	83 ec 0c             	sub    $0xc,%esp
8010231b:	ff 75 f0             	pushl  -0x10(%ebp)
8010231e:	e8 0b df ff ff       	call   8010022e <brelse>
80102323:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102326:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102329:	01 45 f4             	add    %eax,-0xc(%ebp)
8010232c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010232f:	01 45 10             	add    %eax,0x10(%ebp)
80102332:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102335:	01 45 0c             	add    %eax,0xc(%ebp)
80102338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010233e:	0f 82 5b ff ff ff    	jb     8010229f <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102344:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102348:	74 22                	je     8010236c <writei+0x183>
8010234a:	8b 45 08             	mov    0x8(%ebp),%eax
8010234d:	8b 40 20             	mov    0x20(%eax),%eax
80102350:	3b 45 10             	cmp    0x10(%ebp),%eax
80102353:	73 17                	jae    8010236c <writei+0x183>
    ip->size = off;
80102355:	8b 45 08             	mov    0x8(%ebp),%eax
80102358:	8b 55 10             	mov    0x10(%ebp),%edx
8010235b:	89 50 20             	mov    %edx,0x20(%eax)
    iupdate(ip);
8010235e:	83 ec 0c             	sub    $0xc,%esp
80102361:	ff 75 08             	pushl  0x8(%ebp)
80102364:	e8 69 f5 ff ff       	call   801018d2 <iupdate>
80102369:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010236c:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010236f:	c9                   	leave  
80102370:	c3                   	ret    

80102371 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102371:	55                   	push   %ebp
80102372:	89 e5                	mov    %esp,%ebp
80102374:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102377:	83 ec 04             	sub    $0x4,%esp
8010237a:	6a 0e                	push   $0xe
8010237c:	ff 75 0c             	pushl  0xc(%ebp)
8010237f:	ff 75 08             	pushl  0x8(%ebp)
80102382:	e8 85 3e 00 00       	call   8010620c <strncmp>
80102387:	83 c4 10             	add    $0x10,%esp
}
8010238a:	c9                   	leave  
8010238b:	c3                   	ret    

8010238c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010238c:	55                   	push   %ebp
8010238d:	89 e5                	mov    %esp,%ebp
8010238f:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102392:	8b 45 08             	mov    0x8(%ebp),%eax
80102395:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102399:	66 83 f8 01          	cmp    $0x1,%ax
8010239d:	74 0d                	je     801023ac <dirlookup+0x20>
    panic("dirlookup not DIR");
8010239f:	83 ec 0c             	sub    $0xc,%esp
801023a2:	68 1f 99 10 80       	push   $0x8010991f
801023a7:	e8 ba e1 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801023ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801023b3:	eb 7b                	jmp    80102430 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023b5:	6a 10                	push   $0x10
801023b7:	ff 75 f4             	pushl  -0xc(%ebp)
801023ba:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023bd:	50                   	push   %eax
801023be:	ff 75 08             	pushl  0x8(%ebp)
801023c1:	e8 cc fc ff ff       	call   80102092 <readi>
801023c6:	83 c4 10             	add    $0x10,%esp
801023c9:	83 f8 10             	cmp    $0x10,%eax
801023cc:	74 0d                	je     801023db <dirlookup+0x4f>
      panic("dirlink read");
801023ce:	83 ec 0c             	sub    $0xc,%esp
801023d1:	68 31 99 10 80       	push   $0x80109931
801023d6:	e8 8b e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801023db:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801023df:	66 85 c0             	test   %ax,%ax
801023e2:	74 47                	je     8010242b <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801023e4:	83 ec 08             	sub    $0x8,%esp
801023e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023ea:	83 c0 02             	add    $0x2,%eax
801023ed:	50                   	push   %eax
801023ee:	ff 75 0c             	pushl  0xc(%ebp)
801023f1:	e8 7b ff ff ff       	call   80102371 <namecmp>
801023f6:	83 c4 10             	add    $0x10,%esp
801023f9:	85 c0                	test   %eax,%eax
801023fb:	75 2f                	jne    8010242c <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801023fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102401:	74 08                	je     8010240b <dirlookup+0x7f>
        *poff = off;
80102403:	8b 45 10             	mov    0x10(%ebp),%eax
80102406:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102409:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010240b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010240f:	0f b7 c0             	movzwl %ax,%eax
80102412:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102415:	8b 45 08             	mov    0x8(%ebp),%eax
80102418:	8b 00                	mov    (%eax),%eax
8010241a:	83 ec 08             	sub    $0x8,%esp
8010241d:	ff 75 f0             	pushl  -0x10(%ebp)
80102420:	50                   	push   %eax
80102421:	e8 95 f5 ff ff       	call   801019bb <iget>
80102426:	83 c4 10             	add    $0x10,%esp
80102429:	eb 19                	jmp    80102444 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010242b:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010242c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102430:	8b 45 08             	mov    0x8(%ebp),%eax
80102433:	8b 40 20             	mov    0x20(%eax),%eax
80102436:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102439:	0f 87 76 ff ff ff    	ja     801023b5 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010243f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102444:	c9                   	leave  
80102445:	c3                   	ret    

80102446 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102446:	55                   	push   %ebp
80102447:	89 e5                	mov    %esp,%ebp
80102449:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010244c:	83 ec 04             	sub    $0x4,%esp
8010244f:	6a 00                	push   $0x0
80102451:	ff 75 0c             	pushl  0xc(%ebp)
80102454:	ff 75 08             	pushl  0x8(%ebp)
80102457:	e8 30 ff ff ff       	call   8010238c <dirlookup>
8010245c:	83 c4 10             	add    $0x10,%esp
8010245f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102462:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102466:	74 18                	je     80102480 <dirlink+0x3a>
    iput(ip);
80102468:	83 ec 0c             	sub    $0xc,%esp
8010246b:	ff 75 f0             	pushl  -0x10(%ebp)
8010246e:	e8 59 f8 ff ff       	call   80101ccc <iput>
80102473:	83 c4 10             	add    $0x10,%esp
    return -1;
80102476:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010247b:	e9 9c 00 00 00       	jmp    8010251c <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102480:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102487:	eb 39                	jmp    801024c2 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010248c:	6a 10                	push   $0x10
8010248e:	50                   	push   %eax
8010248f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102492:	50                   	push   %eax
80102493:	ff 75 08             	pushl  0x8(%ebp)
80102496:	e8 f7 fb ff ff       	call   80102092 <readi>
8010249b:	83 c4 10             	add    $0x10,%esp
8010249e:	83 f8 10             	cmp    $0x10,%eax
801024a1:	74 0d                	je     801024b0 <dirlink+0x6a>
      panic("dirlink read");
801024a3:	83 ec 0c             	sub    $0xc,%esp
801024a6:	68 31 99 10 80       	push   $0x80109931
801024ab:	e8 b6 e0 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801024b0:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801024b4:	66 85 c0             	test   %ax,%ax
801024b7:	74 18                	je     801024d1 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024bc:	83 c0 10             	add    $0x10,%eax
801024bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024c2:	8b 45 08             	mov    0x8(%ebp),%eax
801024c5:	8b 50 20             	mov    0x20(%eax),%edx
801024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024cb:	39 c2                	cmp    %eax,%edx
801024cd:	77 ba                	ja     80102489 <dirlink+0x43>
801024cf:	eb 01                	jmp    801024d2 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801024d1:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801024d2:	83 ec 04             	sub    $0x4,%esp
801024d5:	6a 0e                	push   $0xe
801024d7:	ff 75 0c             	pushl  0xc(%ebp)
801024da:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024dd:	83 c0 02             	add    $0x2,%eax
801024e0:	50                   	push   %eax
801024e1:	e8 7c 3d 00 00       	call   80106262 <strncpy>
801024e6:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801024e9:	8b 45 10             	mov    0x10(%ebp),%eax
801024ec:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024f3:	6a 10                	push   $0x10
801024f5:	50                   	push   %eax
801024f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024f9:	50                   	push   %eax
801024fa:	ff 75 08             	pushl  0x8(%ebp)
801024fd:	e8 e7 fc ff ff       	call   801021e9 <writei>
80102502:	83 c4 10             	add    $0x10,%esp
80102505:	83 f8 10             	cmp    $0x10,%eax
80102508:	74 0d                	je     80102517 <dirlink+0xd1>
    panic("dirlink");
8010250a:	83 ec 0c             	sub    $0xc,%esp
8010250d:	68 3e 99 10 80       	push   $0x8010993e
80102512:	e8 4f e0 ff ff       	call   80100566 <panic>
  
  return 0;
80102517:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010251c:	c9                   	leave  
8010251d:	c3                   	ret    

8010251e <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010251e:	55                   	push   %ebp
8010251f:	89 e5                	mov    %esp,%ebp
80102521:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102524:	eb 04                	jmp    8010252a <skipelem+0xc>
    path++;
80102526:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010252a:	8b 45 08             	mov    0x8(%ebp),%eax
8010252d:	0f b6 00             	movzbl (%eax),%eax
80102530:	3c 2f                	cmp    $0x2f,%al
80102532:	74 f2                	je     80102526 <skipelem+0x8>
    path++;
  if(*path == 0)
80102534:	8b 45 08             	mov    0x8(%ebp),%eax
80102537:	0f b6 00             	movzbl (%eax),%eax
8010253a:	84 c0                	test   %al,%al
8010253c:	75 07                	jne    80102545 <skipelem+0x27>
    return 0;
8010253e:	b8 00 00 00 00       	mov    $0x0,%eax
80102543:	eb 7b                	jmp    801025c0 <skipelem+0xa2>
  s = path;
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
80102548:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010254b:	eb 04                	jmp    80102551 <skipelem+0x33>
    path++;
8010254d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102551:	8b 45 08             	mov    0x8(%ebp),%eax
80102554:	0f b6 00             	movzbl (%eax),%eax
80102557:	3c 2f                	cmp    $0x2f,%al
80102559:	74 0a                	je     80102565 <skipelem+0x47>
8010255b:	8b 45 08             	mov    0x8(%ebp),%eax
8010255e:	0f b6 00             	movzbl (%eax),%eax
80102561:	84 c0                	test   %al,%al
80102563:	75 e8                	jne    8010254d <skipelem+0x2f>
    path++;
  len = path - s;
80102565:	8b 55 08             	mov    0x8(%ebp),%edx
80102568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010256b:	29 c2                	sub    %eax,%edx
8010256d:	89 d0                	mov    %edx,%eax
8010256f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102572:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102576:	7e 15                	jle    8010258d <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102578:	83 ec 04             	sub    $0x4,%esp
8010257b:	6a 0e                	push   $0xe
8010257d:	ff 75 f4             	pushl  -0xc(%ebp)
80102580:	ff 75 0c             	pushl  0xc(%ebp)
80102583:	e8 ee 3b 00 00       	call   80106176 <memmove>
80102588:	83 c4 10             	add    $0x10,%esp
8010258b:	eb 26                	jmp    801025b3 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102590:	83 ec 04             	sub    $0x4,%esp
80102593:	50                   	push   %eax
80102594:	ff 75 f4             	pushl  -0xc(%ebp)
80102597:	ff 75 0c             	pushl  0xc(%ebp)
8010259a:	e8 d7 3b 00 00       	call   80106176 <memmove>
8010259f:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801025a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801025a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801025a8:	01 d0                	add    %edx,%eax
801025aa:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801025ad:	eb 04                	jmp    801025b3 <skipelem+0x95>
    path++;
801025af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801025b3:	8b 45 08             	mov    0x8(%ebp),%eax
801025b6:	0f b6 00             	movzbl (%eax),%eax
801025b9:	3c 2f                	cmp    $0x2f,%al
801025bb:	74 f2                	je     801025af <skipelem+0x91>
    path++;
  return path;
801025bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
801025c0:	c9                   	leave  
801025c1:	c3                   	ret    

801025c2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801025c2:	55                   	push   %ebp
801025c3:	89 e5                	mov    %esp,%ebp
801025c5:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801025c8:	8b 45 08             	mov    0x8(%ebp),%eax
801025cb:	0f b6 00             	movzbl (%eax),%eax
801025ce:	3c 2f                	cmp    $0x2f,%al
801025d0:	75 17                	jne    801025e9 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801025d2:	83 ec 08             	sub    $0x8,%esp
801025d5:	6a 01                	push   $0x1
801025d7:	6a 01                	push   $0x1
801025d9:	e8 dd f3 ff ff       	call   801019bb <iget>
801025de:	83 c4 10             	add    $0x10,%esp
801025e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801025e4:	e9 bb 00 00 00       	jmp    801026a4 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801025e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801025ef:	8b 40 68             	mov    0x68(%eax),%eax
801025f2:	83 ec 0c             	sub    $0xc,%esp
801025f5:	50                   	push   %eax
801025f6:	e8 9f f4 ff ff       	call   80101a9a <idup>
801025fb:	83 c4 10             	add    $0x10,%esp
801025fe:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102601:	e9 9e 00 00 00       	jmp    801026a4 <namex+0xe2>
    ilock(ip);
80102606:	83 ec 0c             	sub    $0xc,%esp
80102609:	ff 75 f4             	pushl  -0xc(%ebp)
8010260c:	e8 c3 f4 ff ff       	call   80101ad4 <ilock>
80102611:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102617:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010261b:	66 83 f8 01          	cmp    $0x1,%ax
8010261f:	74 18                	je     80102639 <namex+0x77>
      iunlockput(ip);
80102621:	83 ec 0c             	sub    $0xc,%esp
80102624:	ff 75 f4             	pushl  -0xc(%ebp)
80102627:	e8 90 f7 ff ff       	call   80101dbc <iunlockput>
8010262c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010262f:	b8 00 00 00 00       	mov    $0x0,%eax
80102634:	e9 a7 00 00 00       	jmp    801026e0 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102639:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010263d:	74 20                	je     8010265f <namex+0x9d>
8010263f:	8b 45 08             	mov    0x8(%ebp),%eax
80102642:	0f b6 00             	movzbl (%eax),%eax
80102645:	84 c0                	test   %al,%al
80102647:	75 16                	jne    8010265f <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102649:	83 ec 0c             	sub    $0xc,%esp
8010264c:	ff 75 f4             	pushl  -0xc(%ebp)
8010264f:	e8 06 f6 ff ff       	call   80101c5a <iunlock>
80102654:	83 c4 10             	add    $0x10,%esp
      return ip;
80102657:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010265a:	e9 81 00 00 00       	jmp    801026e0 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010265f:	83 ec 04             	sub    $0x4,%esp
80102662:	6a 00                	push   $0x0
80102664:	ff 75 10             	pushl  0x10(%ebp)
80102667:	ff 75 f4             	pushl  -0xc(%ebp)
8010266a:	e8 1d fd ff ff       	call   8010238c <dirlookup>
8010266f:	83 c4 10             	add    $0x10,%esp
80102672:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102675:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102679:	75 15                	jne    80102690 <namex+0xce>
      iunlockput(ip);
8010267b:	83 ec 0c             	sub    $0xc,%esp
8010267e:	ff 75 f4             	pushl  -0xc(%ebp)
80102681:	e8 36 f7 ff ff       	call   80101dbc <iunlockput>
80102686:	83 c4 10             	add    $0x10,%esp
      return 0;
80102689:	b8 00 00 00 00       	mov    $0x0,%eax
8010268e:	eb 50                	jmp    801026e0 <namex+0x11e>
    }
    iunlockput(ip);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	ff 75 f4             	pushl  -0xc(%ebp)
80102696:	e8 21 f7 ff ff       	call   80101dbc <iunlockput>
8010269b:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010269e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801026a4:	83 ec 08             	sub    $0x8,%esp
801026a7:	ff 75 10             	pushl  0x10(%ebp)
801026aa:	ff 75 08             	pushl  0x8(%ebp)
801026ad:	e8 6c fe ff ff       	call   8010251e <skipelem>
801026b2:	83 c4 10             	add    $0x10,%esp
801026b5:	89 45 08             	mov    %eax,0x8(%ebp)
801026b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026bc:	0f 85 44 ff ff ff    	jne    80102606 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801026c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801026c6:	74 15                	je     801026dd <namex+0x11b>
    iput(ip);
801026c8:	83 ec 0c             	sub    $0xc,%esp
801026cb:	ff 75 f4             	pushl  -0xc(%ebp)
801026ce:	e8 f9 f5 ff ff       	call   80101ccc <iput>
801026d3:	83 c4 10             	add    $0x10,%esp
    return 0;
801026d6:	b8 00 00 00 00       	mov    $0x0,%eax
801026db:	eb 03                	jmp    801026e0 <namex+0x11e>
  }
  return ip;
801026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801026e0:	c9                   	leave  
801026e1:	c3                   	ret    

801026e2 <namei>:

struct inode*
namei(char *path)
{
801026e2:	55                   	push   %ebp
801026e3:	89 e5                	mov    %esp,%ebp
801026e5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801026e8:	83 ec 04             	sub    $0x4,%esp
801026eb:	8d 45 ea             	lea    -0x16(%ebp),%eax
801026ee:	50                   	push   %eax
801026ef:	6a 00                	push   $0x0
801026f1:	ff 75 08             	pushl  0x8(%ebp)
801026f4:	e8 c9 fe ff ff       	call   801025c2 <namex>
801026f9:	83 c4 10             	add    $0x10,%esp
}
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    

801026fe <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801026fe:	55                   	push   %ebp
801026ff:	89 e5                	mov    %esp,%ebp
80102701:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102704:	83 ec 04             	sub    $0x4,%esp
80102707:	ff 75 0c             	pushl  0xc(%ebp)
8010270a:	6a 01                	push   $0x1
8010270c:	ff 75 08             	pushl  0x8(%ebp)
8010270f:	e8 ae fe ff ff       	call   801025c2 <namex>
80102714:	83 c4 10             	add    $0x10,%esp
}
80102717:	c9                   	leave  
80102718:	c3                   	ret    

80102719 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102719:	55                   	push   %ebp
8010271a:	89 e5                	mov    %esp,%ebp
8010271c:	83 ec 14             	sub    $0x14,%esp
8010271f:	8b 45 08             	mov    0x8(%ebp),%eax
80102722:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102726:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010272a:	89 c2                	mov    %eax,%edx
8010272c:	ec                   	in     (%dx),%al
8010272d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102730:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102734:	c9                   	leave  
80102735:	c3                   	ret    

80102736 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102736:	55                   	push   %ebp
80102737:	89 e5                	mov    %esp,%ebp
80102739:	57                   	push   %edi
8010273a:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010273b:	8b 55 08             	mov    0x8(%ebp),%edx
8010273e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102741:	8b 45 10             	mov    0x10(%ebp),%eax
80102744:	89 cb                	mov    %ecx,%ebx
80102746:	89 df                	mov    %ebx,%edi
80102748:	89 c1                	mov    %eax,%ecx
8010274a:	fc                   	cld    
8010274b:	f3 6d                	rep insl (%dx),%es:(%edi)
8010274d:	89 c8                	mov    %ecx,%eax
8010274f:	89 fb                	mov    %edi,%ebx
80102751:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102754:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102757:	90                   	nop
80102758:	5b                   	pop    %ebx
80102759:	5f                   	pop    %edi
8010275a:	5d                   	pop    %ebp
8010275b:	c3                   	ret    

8010275c <outb>:

static inline void
outb(ushort port, uchar data)
{
8010275c:	55                   	push   %ebp
8010275d:	89 e5                	mov    %esp,%ebp
8010275f:	83 ec 08             	sub    $0x8,%esp
80102762:	8b 55 08             	mov    0x8(%ebp),%edx
80102765:	8b 45 0c             	mov    0xc(%ebp),%eax
80102768:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010276c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010276f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102773:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102777:	ee                   	out    %al,(%dx)
}
80102778:	90                   	nop
80102779:	c9                   	leave  
8010277a:	c3                   	ret    

8010277b <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010277b:	55                   	push   %ebp
8010277c:	89 e5                	mov    %esp,%ebp
8010277e:	56                   	push   %esi
8010277f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102780:	8b 55 08             	mov    0x8(%ebp),%edx
80102783:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102786:	8b 45 10             	mov    0x10(%ebp),%eax
80102789:	89 cb                	mov    %ecx,%ebx
8010278b:	89 de                	mov    %ebx,%esi
8010278d:	89 c1                	mov    %eax,%ecx
8010278f:	fc                   	cld    
80102790:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102792:	89 c8                	mov    %ecx,%eax
80102794:	89 f3                	mov    %esi,%ebx
80102796:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102799:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010279c:	90                   	nop
8010279d:	5b                   	pop    %ebx
8010279e:	5e                   	pop    %esi
8010279f:	5d                   	pop    %ebp
801027a0:	c3                   	ret    

801027a1 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801027a1:	55                   	push   %ebp
801027a2:	89 e5                	mov    %esp,%ebp
801027a4:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801027a7:	90                   	nop
801027a8:	68 f7 01 00 00       	push   $0x1f7
801027ad:	e8 67 ff ff ff       	call   80102719 <inb>
801027b2:	83 c4 04             	add    $0x4,%esp
801027b5:	0f b6 c0             	movzbl %al,%eax
801027b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801027bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801027be:	25 c0 00 00 00       	and    $0xc0,%eax
801027c3:	83 f8 40             	cmp    $0x40,%eax
801027c6:	75 e0                	jne    801027a8 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801027c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801027cc:	74 11                	je     801027df <idewait+0x3e>
801027ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
801027d1:	83 e0 21             	and    $0x21,%eax
801027d4:	85 c0                	test   %eax,%eax
801027d6:	74 07                	je     801027df <idewait+0x3e>
    return -1;
801027d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801027dd:	eb 05                	jmp    801027e4 <idewait+0x43>
  return 0;
801027df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801027e4:	c9                   	leave  
801027e5:	c3                   	ret    

801027e6 <ideinit>:

void
ideinit(void)
{
801027e6:	55                   	push   %ebp
801027e7:	89 e5                	mov    %esp,%ebp
801027e9:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801027ec:	83 ec 08             	sub    $0x8,%esp
801027ef:	68 46 99 10 80       	push   $0x80109946
801027f4:	68 20 d6 10 80       	push   $0x8010d620
801027f9:	e8 34 36 00 00       	call   80105e32 <initlock>
801027fe:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102801:	83 ec 0c             	sub    $0xc,%esp
80102804:	6a 0e                	push   $0xe
80102806:	e8 da 18 00 00       	call   801040e5 <picenable>
8010280b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010280e:	a1 60 49 11 80       	mov    0x80114960,%eax
80102813:	83 e8 01             	sub    $0x1,%eax
80102816:	83 ec 08             	sub    $0x8,%esp
80102819:	50                   	push   %eax
8010281a:	6a 0e                	push   $0xe
8010281c:	e8 73 04 00 00       	call   80102c94 <ioapicenable>
80102821:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102824:	83 ec 0c             	sub    $0xc,%esp
80102827:	6a 00                	push   $0x0
80102829:	e8 73 ff ff ff       	call   801027a1 <idewait>
8010282e:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102831:	83 ec 08             	sub    $0x8,%esp
80102834:	68 f0 00 00 00       	push   $0xf0
80102839:	68 f6 01 00 00       	push   $0x1f6
8010283e:	e8 19 ff ff ff       	call   8010275c <outb>
80102843:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102846:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010284d:	eb 24                	jmp    80102873 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010284f:	83 ec 0c             	sub    $0xc,%esp
80102852:	68 f7 01 00 00       	push   $0x1f7
80102857:	e8 bd fe ff ff       	call   80102719 <inb>
8010285c:	83 c4 10             	add    $0x10,%esp
8010285f:	84 c0                	test   %al,%al
80102861:	74 0c                	je     8010286f <ideinit+0x89>
      havedisk1 = 1;
80102863:	c7 05 58 d6 10 80 01 	movl   $0x1,0x8010d658
8010286a:	00 00 00 
      break;
8010286d:	eb 0d                	jmp    8010287c <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010286f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102873:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010287a:	7e d3                	jle    8010284f <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010287c:	83 ec 08             	sub    $0x8,%esp
8010287f:	68 e0 00 00 00       	push   $0xe0
80102884:	68 f6 01 00 00       	push   $0x1f6
80102889:	e8 ce fe ff ff       	call   8010275c <outb>
8010288e:	83 c4 10             	add    $0x10,%esp
}
80102891:	90                   	nop
80102892:	c9                   	leave  
80102893:	c3                   	ret    

80102894 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102894:	55                   	push   %ebp
80102895:	89 e5                	mov    %esp,%ebp
80102897:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010289a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010289e:	75 0d                	jne    801028ad <idestart+0x19>
    panic("idestart");
801028a0:	83 ec 0c             	sub    $0xc,%esp
801028a3:	68 4a 99 10 80       	push   $0x8010994a
801028a8:	e8 b9 dc ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801028ad:	8b 45 08             	mov    0x8(%ebp),%eax
801028b0:	8b 40 08             	mov    0x8(%eax),%eax
801028b3:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801028b8:	76 0d                	jbe    801028c7 <idestart+0x33>
    panic("incorrect blockno");
801028ba:	83 ec 0c             	sub    $0xc,%esp
801028bd:	68 53 99 10 80       	push   $0x80109953
801028c2:	e8 9f dc ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801028c7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801028ce:	8b 45 08             	mov    0x8(%ebp),%eax
801028d1:	8b 50 08             	mov    0x8(%eax),%edx
801028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d7:	0f af c2             	imul   %edx,%eax
801028da:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801028dd:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801028e1:	7e 0d                	jle    801028f0 <idestart+0x5c>
801028e3:	83 ec 0c             	sub    $0xc,%esp
801028e6:	68 4a 99 10 80       	push   $0x8010994a
801028eb:	e8 76 dc ff ff       	call   80100566 <panic>
  
  idewait(0);
801028f0:	83 ec 0c             	sub    $0xc,%esp
801028f3:	6a 00                	push   $0x0
801028f5:	e8 a7 fe ff ff       	call   801027a1 <idewait>
801028fa:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801028fd:	83 ec 08             	sub    $0x8,%esp
80102900:	6a 00                	push   $0x0
80102902:	68 f6 03 00 00       	push   $0x3f6
80102907:	e8 50 fe ff ff       	call   8010275c <outb>
8010290c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
8010290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102912:	0f b6 c0             	movzbl %al,%eax
80102915:	83 ec 08             	sub    $0x8,%esp
80102918:	50                   	push   %eax
80102919:	68 f2 01 00 00       	push   $0x1f2
8010291e:	e8 39 fe ff ff       	call   8010275c <outb>
80102923:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102926:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102929:	0f b6 c0             	movzbl %al,%eax
8010292c:	83 ec 08             	sub    $0x8,%esp
8010292f:	50                   	push   %eax
80102930:	68 f3 01 00 00       	push   $0x1f3
80102935:	e8 22 fe ff ff       	call   8010275c <outb>
8010293a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
8010293d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102940:	c1 f8 08             	sar    $0x8,%eax
80102943:	0f b6 c0             	movzbl %al,%eax
80102946:	83 ec 08             	sub    $0x8,%esp
80102949:	50                   	push   %eax
8010294a:	68 f4 01 00 00       	push   $0x1f4
8010294f:	e8 08 fe ff ff       	call   8010275c <outb>
80102954:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102957:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010295a:	c1 f8 10             	sar    $0x10,%eax
8010295d:	0f b6 c0             	movzbl %al,%eax
80102960:	83 ec 08             	sub    $0x8,%esp
80102963:	50                   	push   %eax
80102964:	68 f5 01 00 00       	push   $0x1f5
80102969:	e8 ee fd ff ff       	call   8010275c <outb>
8010296e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102971:	8b 45 08             	mov    0x8(%ebp),%eax
80102974:	8b 40 04             	mov    0x4(%eax),%eax
80102977:	83 e0 01             	and    $0x1,%eax
8010297a:	c1 e0 04             	shl    $0x4,%eax
8010297d:	89 c2                	mov    %eax,%edx
8010297f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102982:	c1 f8 18             	sar    $0x18,%eax
80102985:	83 e0 0f             	and    $0xf,%eax
80102988:	09 d0                	or     %edx,%eax
8010298a:	83 c8 e0             	or     $0xffffffe0,%eax
8010298d:	0f b6 c0             	movzbl %al,%eax
80102990:	83 ec 08             	sub    $0x8,%esp
80102993:	50                   	push   %eax
80102994:	68 f6 01 00 00       	push   $0x1f6
80102999:	e8 be fd ff ff       	call   8010275c <outb>
8010299e:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801029a1:	8b 45 08             	mov    0x8(%ebp),%eax
801029a4:	8b 00                	mov    (%eax),%eax
801029a6:	83 e0 04             	and    $0x4,%eax
801029a9:	85 c0                	test   %eax,%eax
801029ab:	74 30                	je     801029dd <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
801029ad:	83 ec 08             	sub    $0x8,%esp
801029b0:	6a 30                	push   $0x30
801029b2:	68 f7 01 00 00       	push   $0x1f7
801029b7:	e8 a0 fd ff ff       	call   8010275c <outb>
801029bc:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801029bf:	8b 45 08             	mov    0x8(%ebp),%eax
801029c2:	83 c0 18             	add    $0x18,%eax
801029c5:	83 ec 04             	sub    $0x4,%esp
801029c8:	68 80 00 00 00       	push   $0x80
801029cd:	50                   	push   %eax
801029ce:	68 f0 01 00 00       	push   $0x1f0
801029d3:	e8 a3 fd ff ff       	call   8010277b <outsl>
801029d8:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
801029db:	eb 12                	jmp    801029ef <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
801029dd:	83 ec 08             	sub    $0x8,%esp
801029e0:	6a 20                	push   $0x20
801029e2:	68 f7 01 00 00       	push   $0x1f7
801029e7:	e8 70 fd ff ff       	call   8010275c <outb>
801029ec:	83 c4 10             	add    $0x10,%esp
  }
}
801029ef:	90                   	nop
801029f0:	c9                   	leave  
801029f1:	c3                   	ret    

801029f2 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801029f2:	55                   	push   %ebp
801029f3:	89 e5                	mov    %esp,%ebp
801029f5:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801029f8:	83 ec 0c             	sub    $0xc,%esp
801029fb:	68 20 d6 10 80       	push   $0x8010d620
80102a00:	e8 4f 34 00 00       	call   80105e54 <acquire>
80102a05:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102a08:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102a14:	75 15                	jne    80102a2b <ideintr+0x39>
    release(&idelock);
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	68 20 d6 10 80       	push   $0x8010d620
80102a1e:	e8 98 34 00 00       	call   80105ebb <release>
80102a23:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102a26:	e9 9a 00 00 00       	jmp    80102ac5 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2e:	8b 40 14             	mov    0x14(%eax),%eax
80102a31:	a3 54 d6 10 80       	mov    %eax,0x8010d654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a39:	8b 00                	mov    (%eax),%eax
80102a3b:	83 e0 04             	and    $0x4,%eax
80102a3e:	85 c0                	test   %eax,%eax
80102a40:	75 2d                	jne    80102a6f <ideintr+0x7d>
80102a42:	83 ec 0c             	sub    $0xc,%esp
80102a45:	6a 01                	push   $0x1
80102a47:	e8 55 fd ff ff       	call   801027a1 <idewait>
80102a4c:	83 c4 10             	add    $0x10,%esp
80102a4f:	85 c0                	test   %eax,%eax
80102a51:	78 1c                	js     80102a6f <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a56:	83 c0 18             	add    $0x18,%eax
80102a59:	83 ec 04             	sub    $0x4,%esp
80102a5c:	68 80 00 00 00       	push   $0x80
80102a61:	50                   	push   %eax
80102a62:	68 f0 01 00 00       	push   $0x1f0
80102a67:	e8 ca fc ff ff       	call   80102736 <insl>
80102a6c:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a72:	8b 00                	mov    (%eax),%eax
80102a74:	83 c8 02             	or     $0x2,%eax
80102a77:	89 c2                	mov    %eax,%edx
80102a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a7c:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a81:	8b 00                	mov    (%eax),%eax
80102a83:	83 e0 fb             	and    $0xfffffffb,%eax
80102a86:	89 c2                	mov    %eax,%edx
80102a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a8b:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102a8d:	83 ec 0c             	sub    $0xc,%esp
80102a90:	ff 75 f4             	pushl  -0xc(%ebp)
80102a93:	e8 16 26 00 00       	call   801050ae <wakeup>
80102a98:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102a9b:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102aa0:	85 c0                	test   %eax,%eax
80102aa2:	74 11                	je     80102ab5 <ideintr+0xc3>
    idestart(idequeue);
80102aa4:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102aa9:	83 ec 0c             	sub    $0xc,%esp
80102aac:	50                   	push   %eax
80102aad:	e8 e2 fd ff ff       	call   80102894 <idestart>
80102ab2:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102ab5:	83 ec 0c             	sub    $0xc,%esp
80102ab8:	68 20 d6 10 80       	push   $0x8010d620
80102abd:	e8 f9 33 00 00       	call   80105ebb <release>
80102ac2:	83 c4 10             	add    $0x10,%esp
}
80102ac5:	c9                   	leave  
80102ac6:	c3                   	ret    

80102ac7 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102ac7:	55                   	push   %ebp
80102ac8:	89 e5                	mov    %esp,%ebp
80102aca:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102acd:	8b 45 08             	mov    0x8(%ebp),%eax
80102ad0:	8b 00                	mov    (%eax),%eax
80102ad2:	83 e0 01             	and    $0x1,%eax
80102ad5:	85 c0                	test   %eax,%eax
80102ad7:	75 0d                	jne    80102ae6 <iderw+0x1f>
    panic("iderw: buf not busy");
80102ad9:	83 ec 0c             	sub    $0xc,%esp
80102adc:	68 65 99 10 80       	push   $0x80109965
80102ae1:	e8 80 da ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae9:	8b 00                	mov    (%eax),%eax
80102aeb:	83 e0 06             	and    $0x6,%eax
80102aee:	83 f8 02             	cmp    $0x2,%eax
80102af1:	75 0d                	jne    80102b00 <iderw+0x39>
    panic("iderw: nothing to do");
80102af3:	83 ec 0c             	sub    $0xc,%esp
80102af6:	68 79 99 10 80       	push   $0x80109979
80102afb:	e8 66 da ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102b00:	8b 45 08             	mov    0x8(%ebp),%eax
80102b03:	8b 40 04             	mov    0x4(%eax),%eax
80102b06:	85 c0                	test   %eax,%eax
80102b08:	74 16                	je     80102b20 <iderw+0x59>
80102b0a:	a1 58 d6 10 80       	mov    0x8010d658,%eax
80102b0f:	85 c0                	test   %eax,%eax
80102b11:	75 0d                	jne    80102b20 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102b13:	83 ec 0c             	sub    $0xc,%esp
80102b16:	68 8e 99 10 80       	push   $0x8010998e
80102b1b:	e8 46 da ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102b20:	83 ec 0c             	sub    $0xc,%esp
80102b23:	68 20 d6 10 80       	push   $0x8010d620
80102b28:	e8 27 33 00 00       	call   80105e54 <acquire>
80102b2d:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102b30:	8b 45 08             	mov    0x8(%ebp),%eax
80102b33:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b3a:	c7 45 f4 54 d6 10 80 	movl   $0x8010d654,-0xc(%ebp)
80102b41:	eb 0b                	jmp    80102b4e <iderw+0x87>
80102b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b46:	8b 00                	mov    (%eax),%eax
80102b48:	83 c0 14             	add    $0x14,%eax
80102b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b51:	8b 00                	mov    (%eax),%eax
80102b53:	85 c0                	test   %eax,%eax
80102b55:	75 ec                	jne    80102b43 <iderw+0x7c>
    ;
  *pp = b;
80102b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5a:	8b 55 08             	mov    0x8(%ebp),%edx
80102b5d:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102b5f:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102b64:	3b 45 08             	cmp    0x8(%ebp),%eax
80102b67:	75 23                	jne    80102b8c <iderw+0xc5>
    idestart(b);
80102b69:	83 ec 0c             	sub    $0xc,%esp
80102b6c:	ff 75 08             	pushl  0x8(%ebp)
80102b6f:	e8 20 fd ff ff       	call   80102894 <idestart>
80102b74:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b77:	eb 13                	jmp    80102b8c <iderw+0xc5>
    sleep(b, &idelock);
80102b79:	83 ec 08             	sub    $0x8,%esp
80102b7c:	68 20 d6 10 80       	push   $0x8010d620
80102b81:	ff 75 08             	pushl  0x8(%ebp)
80102b84:	e8 3e 24 00 00       	call   80104fc7 <sleep>
80102b89:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b8f:	8b 00                	mov    (%eax),%eax
80102b91:	83 e0 06             	and    $0x6,%eax
80102b94:	83 f8 02             	cmp    $0x2,%eax
80102b97:	75 e0                	jne    80102b79 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102b99:	83 ec 0c             	sub    $0xc,%esp
80102b9c:	68 20 d6 10 80       	push   $0x8010d620
80102ba1:	e8 15 33 00 00       	call   80105ebb <release>
80102ba6:	83 c4 10             	add    $0x10,%esp
}
80102ba9:	90                   	nop
80102baa:	c9                   	leave  
80102bab:	c3                   	ret    

80102bac <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102bac:	55                   	push   %ebp
80102bad:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102baf:	a1 34 42 11 80       	mov    0x80114234,%eax
80102bb4:	8b 55 08             	mov    0x8(%ebp),%edx
80102bb7:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102bb9:	a1 34 42 11 80       	mov    0x80114234,%eax
80102bbe:	8b 40 10             	mov    0x10(%eax),%eax
}
80102bc1:	5d                   	pop    %ebp
80102bc2:	c3                   	ret    

80102bc3 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102bc3:	55                   	push   %ebp
80102bc4:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102bc6:	a1 34 42 11 80       	mov    0x80114234,%eax
80102bcb:	8b 55 08             	mov    0x8(%ebp),%edx
80102bce:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102bd0:	a1 34 42 11 80       	mov    0x80114234,%eax
80102bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
80102bd8:	89 50 10             	mov    %edx,0x10(%eax)
}
80102bdb:	90                   	nop
80102bdc:	5d                   	pop    %ebp
80102bdd:	c3                   	ret    

80102bde <ioapicinit>:

void
ioapicinit(void)
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102be4:	a1 64 43 11 80       	mov    0x80114364,%eax
80102be9:	85 c0                	test   %eax,%eax
80102beb:	0f 84 a0 00 00 00    	je     80102c91 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102bf1:	c7 05 34 42 11 80 00 	movl   $0xfec00000,0x80114234
80102bf8:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102bfb:	6a 01                	push   $0x1
80102bfd:	e8 aa ff ff ff       	call   80102bac <ioapicread>
80102c02:	83 c4 04             	add    $0x4,%esp
80102c05:	c1 e8 10             	shr    $0x10,%eax
80102c08:	25 ff 00 00 00       	and    $0xff,%eax
80102c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102c10:	6a 00                	push   $0x0
80102c12:	e8 95 ff ff ff       	call   80102bac <ioapicread>
80102c17:	83 c4 04             	add    $0x4,%esp
80102c1a:	c1 e8 18             	shr    $0x18,%eax
80102c1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102c20:	0f b6 05 60 43 11 80 	movzbl 0x80114360,%eax
80102c27:	0f b6 c0             	movzbl %al,%eax
80102c2a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102c2d:	74 10                	je     80102c3f <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c2f:	83 ec 0c             	sub    $0xc,%esp
80102c32:	68 ac 99 10 80       	push   $0x801099ac
80102c37:	e8 8a d7 ff ff       	call   801003c6 <cprintf>
80102c3c:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102c46:	eb 3f                	jmp    80102c87 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c4b:	83 c0 20             	add    $0x20,%eax
80102c4e:	0d 00 00 01 00       	or     $0x10000,%eax
80102c53:	89 c2                	mov    %eax,%edx
80102c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c58:	83 c0 08             	add    $0x8,%eax
80102c5b:	01 c0                	add    %eax,%eax
80102c5d:	83 ec 08             	sub    $0x8,%esp
80102c60:	52                   	push   %edx
80102c61:	50                   	push   %eax
80102c62:	e8 5c ff ff ff       	call   80102bc3 <ioapicwrite>
80102c67:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6d:	83 c0 08             	add    $0x8,%eax
80102c70:	01 c0                	add    %eax,%eax
80102c72:	83 c0 01             	add    $0x1,%eax
80102c75:	83 ec 08             	sub    $0x8,%esp
80102c78:	6a 00                	push   $0x0
80102c7a:	50                   	push   %eax
80102c7b:	e8 43 ff ff ff       	call   80102bc3 <ioapicwrite>
80102c80:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c83:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c8a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102c8d:	7e b9                	jle    80102c48 <ioapicinit+0x6a>
80102c8f:	eb 01                	jmp    80102c92 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102c91:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102c92:	c9                   	leave  
80102c93:	c3                   	ret    

80102c94 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102c97:	a1 64 43 11 80       	mov    0x80114364,%eax
80102c9c:	85 c0                	test   %eax,%eax
80102c9e:	74 39                	je     80102cd9 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ca3:	83 c0 20             	add    $0x20,%eax
80102ca6:	89 c2                	mov    %eax,%edx
80102ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80102cab:	83 c0 08             	add    $0x8,%eax
80102cae:	01 c0                	add    %eax,%eax
80102cb0:	52                   	push   %edx
80102cb1:	50                   	push   %eax
80102cb2:	e8 0c ff ff ff       	call   80102bc3 <ioapicwrite>
80102cb7:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102cba:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cbd:	c1 e0 18             	shl    $0x18,%eax
80102cc0:	89 c2                	mov    %eax,%edx
80102cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80102cc5:	83 c0 08             	add    $0x8,%eax
80102cc8:	01 c0                	add    %eax,%eax
80102cca:	83 c0 01             	add    $0x1,%eax
80102ccd:	52                   	push   %edx
80102cce:	50                   	push   %eax
80102ccf:	e8 ef fe ff ff       	call   80102bc3 <ioapicwrite>
80102cd4:	83 c4 08             	add    $0x8,%esp
80102cd7:	eb 01                	jmp    80102cda <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102cd9:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102cda:	c9                   	leave  
80102cdb:	c3                   	ret    

80102cdc <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102cdc:	55                   	push   %ebp
80102cdd:	89 e5                	mov    %esp,%ebp
80102cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ce2:	05 00 00 00 80       	add    $0x80000000,%eax
80102ce7:	5d                   	pop    %ebp
80102ce8:	c3                   	ret    

80102ce9 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102ce9:	55                   	push   %ebp
80102cea:	89 e5                	mov    %esp,%ebp
80102cec:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102cef:	83 ec 08             	sub    $0x8,%esp
80102cf2:	68 de 99 10 80       	push   $0x801099de
80102cf7:	68 40 42 11 80       	push   $0x80114240
80102cfc:	e8 31 31 00 00       	call   80105e32 <initlock>
80102d01:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102d04:	c7 05 74 42 11 80 00 	movl   $0x0,0x80114274
80102d0b:	00 00 00 
  freerange(vstart, vend);
80102d0e:	83 ec 08             	sub    $0x8,%esp
80102d11:	ff 75 0c             	pushl  0xc(%ebp)
80102d14:	ff 75 08             	pushl  0x8(%ebp)
80102d17:	e8 2a 00 00 00       	call   80102d46 <freerange>
80102d1c:	83 c4 10             	add    $0x10,%esp
}
80102d1f:	90                   	nop
80102d20:	c9                   	leave  
80102d21:	c3                   	ret    

80102d22 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102d22:	55                   	push   %ebp
80102d23:	89 e5                	mov    %esp,%ebp
80102d25:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102d28:	83 ec 08             	sub    $0x8,%esp
80102d2b:	ff 75 0c             	pushl  0xc(%ebp)
80102d2e:	ff 75 08             	pushl  0x8(%ebp)
80102d31:	e8 10 00 00 00       	call   80102d46 <freerange>
80102d36:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102d39:	c7 05 74 42 11 80 01 	movl   $0x1,0x80114274
80102d40:	00 00 00 
}
80102d43:	90                   	nop
80102d44:	c9                   	leave  
80102d45:	c3                   	ret    

80102d46 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102d46:	55                   	push   %ebp
80102d47:	89 e5                	mov    %esp,%ebp
80102d49:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102d4c:	8b 45 08             	mov    0x8(%ebp),%eax
80102d4f:	05 ff 0f 00 00       	add    $0xfff,%eax
80102d54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d5c:	eb 15                	jmp    80102d73 <freerange+0x2d>
    kfree(p);
80102d5e:	83 ec 0c             	sub    $0xc,%esp
80102d61:	ff 75 f4             	pushl  -0xc(%ebp)
80102d64:	e8 1a 00 00 00       	call   80102d83 <kfree>
80102d69:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d6c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d76:	05 00 10 00 00       	add    $0x1000,%eax
80102d7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102d7e:	76 de                	jbe    80102d5e <freerange+0x18>
    kfree(p);
}
80102d80:	90                   	nop
80102d81:	c9                   	leave  
80102d82:	c3                   	ret    

80102d83 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d83:	55                   	push   %ebp
80102d84:	89 e5                	mov    %esp,%ebp
80102d86:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102d89:	8b 45 08             	mov    0x8(%ebp),%eax
80102d8c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102d91:	85 c0                	test   %eax,%eax
80102d93:	75 1b                	jne    80102db0 <kfree+0x2d>
80102d95:	81 7d 08 3c 79 11 80 	cmpl   $0x8011793c,0x8(%ebp)
80102d9c:	72 12                	jb     80102db0 <kfree+0x2d>
80102d9e:	ff 75 08             	pushl  0x8(%ebp)
80102da1:	e8 36 ff ff ff       	call   80102cdc <v2p>
80102da6:	83 c4 04             	add    $0x4,%esp
80102da9:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102dae:	76 0d                	jbe    80102dbd <kfree+0x3a>
    panic("kfree");
80102db0:	83 ec 0c             	sub    $0xc,%esp
80102db3:	68 e3 99 10 80       	push   $0x801099e3
80102db8:	e8 a9 d7 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102dbd:	83 ec 04             	sub    $0x4,%esp
80102dc0:	68 00 10 00 00       	push   $0x1000
80102dc5:	6a 01                	push   $0x1
80102dc7:	ff 75 08             	pushl  0x8(%ebp)
80102dca:	e8 e8 32 00 00       	call   801060b7 <memset>
80102dcf:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102dd2:	a1 74 42 11 80       	mov    0x80114274,%eax
80102dd7:	85 c0                	test   %eax,%eax
80102dd9:	74 10                	je     80102deb <kfree+0x68>
    acquire(&kmem.lock);
80102ddb:	83 ec 0c             	sub    $0xc,%esp
80102dde:	68 40 42 11 80       	push   $0x80114240
80102de3:	e8 6c 30 00 00       	call   80105e54 <acquire>
80102de8:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102deb:	8b 45 08             	mov    0x8(%ebp),%eax
80102dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102df1:	8b 15 78 42 11 80    	mov    0x80114278,%edx
80102df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dfa:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dff:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102e04:	a1 74 42 11 80       	mov    0x80114274,%eax
80102e09:	85 c0                	test   %eax,%eax
80102e0b:	74 10                	je     80102e1d <kfree+0x9a>
    release(&kmem.lock);
80102e0d:	83 ec 0c             	sub    $0xc,%esp
80102e10:	68 40 42 11 80       	push   $0x80114240
80102e15:	e8 a1 30 00 00       	call   80105ebb <release>
80102e1a:	83 c4 10             	add    $0x10,%esp
}
80102e1d:	90                   	nop
80102e1e:	c9                   	leave  
80102e1f:	c3                   	ret    

80102e20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102e26:	a1 74 42 11 80       	mov    0x80114274,%eax
80102e2b:	85 c0                	test   %eax,%eax
80102e2d:	74 10                	je     80102e3f <kalloc+0x1f>
    acquire(&kmem.lock);
80102e2f:	83 ec 0c             	sub    $0xc,%esp
80102e32:	68 40 42 11 80       	push   $0x80114240
80102e37:	e8 18 30 00 00       	call   80105e54 <acquire>
80102e3c:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102e3f:	a1 78 42 11 80       	mov    0x80114278,%eax
80102e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102e47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102e4b:	74 0a                	je     80102e57 <kalloc+0x37>
    kmem.freelist = r->next;
80102e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e50:	8b 00                	mov    (%eax),%eax
80102e52:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102e57:	a1 74 42 11 80       	mov    0x80114274,%eax
80102e5c:	85 c0                	test   %eax,%eax
80102e5e:	74 10                	je     80102e70 <kalloc+0x50>
    release(&kmem.lock);
80102e60:	83 ec 0c             	sub    $0xc,%esp
80102e63:	68 40 42 11 80       	push   $0x80114240
80102e68:	e8 4e 30 00 00       	call   80105ebb <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102e73:	c9                   	leave  
80102e74:	c3                   	ret    

80102e75 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102e75:	55                   	push   %ebp
80102e76:	89 e5                	mov    %esp,%ebp
80102e78:	83 ec 14             	sub    $0x14,%esp
80102e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80102e7e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e82:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e86:	89 c2                	mov    %eax,%edx
80102e88:	ec                   	in     (%dx),%al
80102e89:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e8c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e90:	c9                   	leave  
80102e91:	c3                   	ret    

80102e92 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e92:	55                   	push   %ebp
80102e93:	89 e5                	mov    %esp,%ebp
80102e95:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102e98:	6a 64                	push   $0x64
80102e9a:	e8 d6 ff ff ff       	call   80102e75 <inb>
80102e9f:	83 c4 04             	add    $0x4,%esp
80102ea2:	0f b6 c0             	movzbl %al,%eax
80102ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102eab:	83 e0 01             	and    $0x1,%eax
80102eae:	85 c0                	test   %eax,%eax
80102eb0:	75 0a                	jne    80102ebc <kbdgetc+0x2a>
    return -1;
80102eb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102eb7:	e9 23 01 00 00       	jmp    80102fdf <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102ebc:	6a 60                	push   $0x60
80102ebe:	e8 b2 ff ff ff       	call   80102e75 <inb>
80102ec3:	83 c4 04             	add    $0x4,%esp
80102ec6:	0f b6 c0             	movzbl %al,%eax
80102ec9:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102ecc:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102ed3:	75 17                	jne    80102eec <kbdgetc+0x5a>
    shift |= E0ESC;
80102ed5:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102eda:	83 c8 40             	or     $0x40,%eax
80102edd:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102ee2:	b8 00 00 00 00       	mov    $0x0,%eax
80102ee7:	e9 f3 00 00 00       	jmp    80102fdf <kbdgetc+0x14d>
  } else if(data & 0x80){
80102eec:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102eef:	25 80 00 00 00       	and    $0x80,%eax
80102ef4:	85 c0                	test   %eax,%eax
80102ef6:	74 45                	je     80102f3d <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ef8:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102efd:	83 e0 40             	and    $0x40,%eax
80102f00:	85 c0                	test   %eax,%eax
80102f02:	75 08                	jne    80102f0c <kbdgetc+0x7a>
80102f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f07:	83 e0 7f             	and    $0x7f,%eax
80102f0a:	eb 03                	jmp    80102f0f <kbdgetc+0x7d>
80102f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f15:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102f1a:	0f b6 00             	movzbl (%eax),%eax
80102f1d:	83 c8 40             	or     $0x40,%eax
80102f20:	0f b6 c0             	movzbl %al,%eax
80102f23:	f7 d0                	not    %eax
80102f25:	89 c2                	mov    %eax,%edx
80102f27:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102f2c:	21 d0                	and    %edx,%eax
80102f2e:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102f33:	b8 00 00 00 00       	mov    $0x0,%eax
80102f38:	e9 a2 00 00 00       	jmp    80102fdf <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102f3d:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102f42:	83 e0 40             	and    $0x40,%eax
80102f45:	85 c0                	test   %eax,%eax
80102f47:	74 14                	je     80102f5d <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f49:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102f50:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102f55:	83 e0 bf             	and    $0xffffffbf,%eax
80102f58:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  }

  shift |= shiftcode[data];
80102f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f60:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102f65:	0f b6 00             	movzbl (%eax),%eax
80102f68:	0f b6 d0             	movzbl %al,%edx
80102f6b:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102f70:	09 d0                	or     %edx,%eax
80102f72:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  shift ^= togglecode[data];
80102f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f7a:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102f7f:	0f b6 00             	movzbl (%eax),%eax
80102f82:	0f b6 d0             	movzbl %al,%edx
80102f85:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102f8a:	31 d0                	xor    %edx,%eax
80102f8c:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102f91:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102f96:	83 e0 03             	and    $0x3,%eax
80102f99:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fa3:	01 d0                	add    %edx,%eax
80102fa5:	0f b6 00             	movzbl (%eax),%eax
80102fa8:	0f b6 c0             	movzbl %al,%eax
80102fab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102fae:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102fb3:	83 e0 08             	and    $0x8,%eax
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	74 22                	je     80102fdc <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102fba:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102fbe:	76 0c                	jbe    80102fcc <kbdgetc+0x13a>
80102fc0:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102fc4:	77 06                	ja     80102fcc <kbdgetc+0x13a>
      c += 'A' - 'a';
80102fc6:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102fca:	eb 10                	jmp    80102fdc <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102fcc:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102fd0:	76 0a                	jbe    80102fdc <kbdgetc+0x14a>
80102fd2:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102fd6:	77 04                	ja     80102fdc <kbdgetc+0x14a>
      c += 'a' - 'A';
80102fd8:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102fdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102fdf:	c9                   	leave  
80102fe0:	c3                   	ret    

80102fe1 <kbdintr>:

void
kbdintr(void)
{
80102fe1:	55                   	push   %ebp
80102fe2:	89 e5                	mov    %esp,%ebp
80102fe4:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102fe7:	83 ec 0c             	sub    $0xc,%esp
80102fea:	68 92 2e 10 80       	push   $0x80102e92
80102fef:	e8 05 d8 ff ff       	call   801007f9 <consoleintr>
80102ff4:	83 c4 10             	add    $0x10,%esp
}
80102ff7:	90                   	nop
80102ff8:	c9                   	leave  
80102ff9:	c3                   	ret    

80102ffa <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102ffa:	55                   	push   %ebp
80102ffb:	89 e5                	mov    %esp,%ebp
80102ffd:	83 ec 14             	sub    $0x14,%esp
80103000:	8b 45 08             	mov    0x8(%ebp),%eax
80103003:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103007:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010300b:	89 c2                	mov    %eax,%edx
8010300d:	ec                   	in     (%dx),%al
8010300e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103011:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103015:	c9                   	leave  
80103016:	c3                   	ret    

80103017 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103017:	55                   	push   %ebp
80103018:	89 e5                	mov    %esp,%ebp
8010301a:	83 ec 08             	sub    $0x8,%esp
8010301d:	8b 55 08             	mov    0x8(%ebp),%edx
80103020:	8b 45 0c             	mov    0xc(%ebp),%eax
80103023:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103027:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010302a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010302e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103032:	ee                   	out    %al,(%dx)
}
80103033:	90                   	nop
80103034:	c9                   	leave  
80103035:	c3                   	ret    

80103036 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103036:	55                   	push   %ebp
80103037:	89 e5                	mov    %esp,%ebp
80103039:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010303c:	9c                   	pushf  
8010303d:	58                   	pop    %eax
8010303e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103041:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103044:	c9                   	leave  
80103045:	c3                   	ret    

80103046 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80103046:	55                   	push   %ebp
80103047:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103049:	a1 7c 42 11 80       	mov    0x8011427c,%eax
8010304e:	8b 55 08             	mov    0x8(%ebp),%edx
80103051:	c1 e2 02             	shl    $0x2,%edx
80103054:	01 c2                	add    %eax,%edx
80103056:	8b 45 0c             	mov    0xc(%ebp),%eax
80103059:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010305b:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80103060:	83 c0 20             	add    $0x20,%eax
80103063:	8b 00                	mov    (%eax),%eax
}
80103065:	90                   	nop
80103066:	5d                   	pop    %ebp
80103067:	c3                   	ret    

80103068 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80103068:	55                   	push   %ebp
80103069:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
8010306b:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80103070:	85 c0                	test   %eax,%eax
80103072:	0f 84 0b 01 00 00    	je     80103183 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103078:	68 3f 01 00 00       	push   $0x13f
8010307d:	6a 3c                	push   $0x3c
8010307f:	e8 c2 ff ff ff       	call   80103046 <lapicw>
80103084:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103087:	6a 0b                	push   $0xb
80103089:	68 f8 00 00 00       	push   $0xf8
8010308e:	e8 b3 ff ff ff       	call   80103046 <lapicw>
80103093:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103096:	68 20 00 02 00       	push   $0x20020
8010309b:	68 c8 00 00 00       	push   $0xc8
801030a0:	e8 a1 ff ff ff       	call   80103046 <lapicw>
801030a5:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
801030a8:	68 80 96 98 00       	push   $0x989680
801030ad:	68 e0 00 00 00       	push   $0xe0
801030b2:	e8 8f ff ff ff       	call   80103046 <lapicw>
801030b7:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
801030ba:	68 00 00 01 00       	push   $0x10000
801030bf:	68 d4 00 00 00       	push   $0xd4
801030c4:	e8 7d ff ff ff       	call   80103046 <lapicw>
801030c9:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
801030cc:	68 00 00 01 00       	push   $0x10000
801030d1:	68 d8 00 00 00       	push   $0xd8
801030d6:	e8 6b ff ff ff       	call   80103046 <lapicw>
801030db:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801030de:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030e3:	83 c0 30             	add    $0x30,%eax
801030e6:	8b 00                	mov    (%eax),%eax
801030e8:	c1 e8 10             	shr    $0x10,%eax
801030eb:	0f b6 c0             	movzbl %al,%eax
801030ee:	83 f8 03             	cmp    $0x3,%eax
801030f1:	76 12                	jbe    80103105 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
801030f3:	68 00 00 01 00       	push   $0x10000
801030f8:	68 d0 00 00 00       	push   $0xd0
801030fd:	e8 44 ff ff ff       	call   80103046 <lapicw>
80103102:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103105:	6a 33                	push   $0x33
80103107:	68 dc 00 00 00       	push   $0xdc
8010310c:	e8 35 ff ff ff       	call   80103046 <lapicw>
80103111:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103114:	6a 00                	push   $0x0
80103116:	68 a0 00 00 00       	push   $0xa0
8010311b:	e8 26 ff ff ff       	call   80103046 <lapicw>
80103120:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103123:	6a 00                	push   $0x0
80103125:	68 a0 00 00 00       	push   $0xa0
8010312a:	e8 17 ff ff ff       	call   80103046 <lapicw>
8010312f:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103132:	6a 00                	push   $0x0
80103134:	6a 2c                	push   $0x2c
80103136:	e8 0b ff ff ff       	call   80103046 <lapicw>
8010313b:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010313e:	6a 00                	push   $0x0
80103140:	68 c4 00 00 00       	push   $0xc4
80103145:	e8 fc fe ff ff       	call   80103046 <lapicw>
8010314a:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010314d:	68 00 85 08 00       	push   $0x88500
80103152:	68 c0 00 00 00       	push   $0xc0
80103157:	e8 ea fe ff ff       	call   80103046 <lapicw>
8010315c:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
8010315f:	90                   	nop
80103160:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80103165:	05 00 03 00 00       	add    $0x300,%eax
8010316a:	8b 00                	mov    (%eax),%eax
8010316c:	25 00 10 00 00       	and    $0x1000,%eax
80103171:	85 c0                	test   %eax,%eax
80103173:	75 eb                	jne    80103160 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103175:	6a 00                	push   $0x0
80103177:	6a 20                	push   $0x20
80103179:	e8 c8 fe ff ff       	call   80103046 <lapicw>
8010317e:	83 c4 08             	add    $0x8,%esp
80103181:	eb 01                	jmp    80103184 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80103183:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103184:	c9                   	leave  
80103185:	c3                   	ret    

80103186 <cpunum>:

int
cpunum(void)
{
80103186:	55                   	push   %ebp
80103187:	89 e5                	mov    %esp,%ebp
80103189:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010318c:	e8 a5 fe ff ff       	call   80103036 <readeflags>
80103191:	25 00 02 00 00       	and    $0x200,%eax
80103196:	85 c0                	test   %eax,%eax
80103198:	74 26                	je     801031c0 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010319a:	a1 60 d6 10 80       	mov    0x8010d660,%eax
8010319f:	8d 50 01             	lea    0x1(%eax),%edx
801031a2:	89 15 60 d6 10 80    	mov    %edx,0x8010d660
801031a8:	85 c0                	test   %eax,%eax
801031aa:	75 14                	jne    801031c0 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
801031ac:	8b 45 04             	mov    0x4(%ebp),%eax
801031af:	83 ec 08             	sub    $0x8,%esp
801031b2:	50                   	push   %eax
801031b3:	68 ec 99 10 80       	push   $0x801099ec
801031b8:	e8 09 d2 ff ff       	call   801003c6 <cprintf>
801031bd:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801031c0:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801031c5:	85 c0                	test   %eax,%eax
801031c7:	74 0f                	je     801031d8 <cpunum+0x52>
    return lapic[ID]>>24;
801031c9:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801031ce:	83 c0 20             	add    $0x20,%eax
801031d1:	8b 00                	mov    (%eax),%eax
801031d3:	c1 e8 18             	shr    $0x18,%eax
801031d6:	eb 05                	jmp    801031dd <cpunum+0x57>
  return 0;
801031d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801031dd:	c9                   	leave  
801031de:	c3                   	ret    

801031df <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801031df:	55                   	push   %ebp
801031e0:	89 e5                	mov    %esp,%ebp
  if(lapic)
801031e2:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801031e7:	85 c0                	test   %eax,%eax
801031e9:	74 0c                	je     801031f7 <lapiceoi+0x18>
    lapicw(EOI, 0);
801031eb:	6a 00                	push   $0x0
801031ed:	6a 2c                	push   $0x2c
801031ef:	e8 52 fe ff ff       	call   80103046 <lapicw>
801031f4:	83 c4 08             	add    $0x8,%esp
}
801031f7:	90                   	nop
801031f8:	c9                   	leave  
801031f9:	c3                   	ret    

801031fa <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801031fa:	55                   	push   %ebp
801031fb:	89 e5                	mov    %esp,%ebp
}
801031fd:	90                   	nop
801031fe:	5d                   	pop    %ebp
801031ff:	c3                   	ret    

80103200 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	83 ec 14             	sub    $0x14,%esp
80103206:	8b 45 08             	mov    0x8(%ebp),%eax
80103209:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010320c:	6a 0f                	push   $0xf
8010320e:	6a 70                	push   $0x70
80103210:	e8 02 fe ff ff       	call   80103017 <outb>
80103215:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103218:	6a 0a                	push   $0xa
8010321a:	6a 71                	push   $0x71
8010321c:	e8 f6 fd ff ff       	call   80103017 <outb>
80103221:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103224:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010322b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010322e:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103233:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103236:	83 c0 02             	add    $0x2,%eax
80103239:	8b 55 0c             	mov    0xc(%ebp),%edx
8010323c:	c1 ea 04             	shr    $0x4,%edx
8010323f:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103242:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103246:	c1 e0 18             	shl    $0x18,%eax
80103249:	50                   	push   %eax
8010324a:	68 c4 00 00 00       	push   $0xc4
8010324f:	e8 f2 fd ff ff       	call   80103046 <lapicw>
80103254:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103257:	68 00 c5 00 00       	push   $0xc500
8010325c:	68 c0 00 00 00       	push   $0xc0
80103261:	e8 e0 fd ff ff       	call   80103046 <lapicw>
80103266:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103269:	68 c8 00 00 00       	push   $0xc8
8010326e:	e8 87 ff ff ff       	call   801031fa <microdelay>
80103273:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103276:	68 00 85 00 00       	push   $0x8500
8010327b:	68 c0 00 00 00       	push   $0xc0
80103280:	e8 c1 fd ff ff       	call   80103046 <lapicw>
80103285:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103288:	6a 64                	push   $0x64
8010328a:	e8 6b ff ff ff       	call   801031fa <microdelay>
8010328f:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103292:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103299:	eb 3d                	jmp    801032d8 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010329b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010329f:	c1 e0 18             	shl    $0x18,%eax
801032a2:	50                   	push   %eax
801032a3:	68 c4 00 00 00       	push   $0xc4
801032a8:	e8 99 fd ff ff       	call   80103046 <lapicw>
801032ad:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801032b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801032b3:	c1 e8 0c             	shr    $0xc,%eax
801032b6:	80 cc 06             	or     $0x6,%ah
801032b9:	50                   	push   %eax
801032ba:	68 c0 00 00 00       	push   $0xc0
801032bf:	e8 82 fd ff ff       	call   80103046 <lapicw>
801032c4:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801032c7:	68 c8 00 00 00       	push   $0xc8
801032cc:	e8 29 ff ff ff       	call   801031fa <microdelay>
801032d1:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801032d4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801032d8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801032dc:	7e bd                	jle    8010329b <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801032de:	90                   	nop
801032df:	c9                   	leave  
801032e0:	c3                   	ret    

801032e1 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801032e1:	55                   	push   %ebp
801032e2:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801032e4:	8b 45 08             	mov    0x8(%ebp),%eax
801032e7:	0f b6 c0             	movzbl %al,%eax
801032ea:	50                   	push   %eax
801032eb:	6a 70                	push   $0x70
801032ed:	e8 25 fd ff ff       	call   80103017 <outb>
801032f2:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801032f5:	68 c8 00 00 00       	push   $0xc8
801032fa:	e8 fb fe ff ff       	call   801031fa <microdelay>
801032ff:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103302:	6a 71                	push   $0x71
80103304:	e8 f1 fc ff ff       	call   80102ffa <inb>
80103309:	83 c4 04             	add    $0x4,%esp
8010330c:	0f b6 c0             	movzbl %al,%eax
}
8010330f:	c9                   	leave  
80103310:	c3                   	ret    

80103311 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103311:	55                   	push   %ebp
80103312:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103314:	6a 00                	push   $0x0
80103316:	e8 c6 ff ff ff       	call   801032e1 <cmos_read>
8010331b:	83 c4 04             	add    $0x4,%esp
8010331e:	89 c2                	mov    %eax,%edx
80103320:	8b 45 08             	mov    0x8(%ebp),%eax
80103323:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103325:	6a 02                	push   $0x2
80103327:	e8 b5 ff ff ff       	call   801032e1 <cmos_read>
8010332c:	83 c4 04             	add    $0x4,%esp
8010332f:	89 c2                	mov    %eax,%edx
80103331:	8b 45 08             	mov    0x8(%ebp),%eax
80103334:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103337:	6a 04                	push   $0x4
80103339:	e8 a3 ff ff ff       	call   801032e1 <cmos_read>
8010333e:	83 c4 04             	add    $0x4,%esp
80103341:	89 c2                	mov    %eax,%edx
80103343:	8b 45 08             	mov    0x8(%ebp),%eax
80103346:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103349:	6a 07                	push   $0x7
8010334b:	e8 91 ff ff ff       	call   801032e1 <cmos_read>
80103350:	83 c4 04             	add    $0x4,%esp
80103353:	89 c2                	mov    %eax,%edx
80103355:	8b 45 08             	mov    0x8(%ebp),%eax
80103358:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010335b:	6a 08                	push   $0x8
8010335d:	e8 7f ff ff ff       	call   801032e1 <cmos_read>
80103362:	83 c4 04             	add    $0x4,%esp
80103365:	89 c2                	mov    %eax,%edx
80103367:	8b 45 08             	mov    0x8(%ebp),%eax
8010336a:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010336d:	6a 09                	push   $0x9
8010336f:	e8 6d ff ff ff       	call   801032e1 <cmos_read>
80103374:	83 c4 04             	add    $0x4,%esp
80103377:	89 c2                	mov    %eax,%edx
80103379:	8b 45 08             	mov    0x8(%ebp),%eax
8010337c:	89 50 14             	mov    %edx,0x14(%eax)
}
8010337f:	90                   	nop
80103380:	c9                   	leave  
80103381:	c3                   	ret    

80103382 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103382:	55                   	push   %ebp
80103383:	89 e5                	mov    %esp,%ebp
80103385:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103388:	6a 0b                	push   $0xb
8010338a:	e8 52 ff ff ff       	call   801032e1 <cmos_read>
8010338f:	83 c4 04             	add    $0x4,%esp
80103392:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103398:	83 e0 04             	and    $0x4,%eax
8010339b:	85 c0                	test   %eax,%eax
8010339d:	0f 94 c0             	sete   %al
801033a0:	0f b6 c0             	movzbl %al,%eax
801033a3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801033a6:	8d 45 d8             	lea    -0x28(%ebp),%eax
801033a9:	50                   	push   %eax
801033aa:	e8 62 ff ff ff       	call   80103311 <fill_rtcdate>
801033af:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801033b2:	6a 0a                	push   $0xa
801033b4:	e8 28 ff ff ff       	call   801032e1 <cmos_read>
801033b9:	83 c4 04             	add    $0x4,%esp
801033bc:	25 80 00 00 00       	and    $0x80,%eax
801033c1:	85 c0                	test   %eax,%eax
801033c3:	75 27                	jne    801033ec <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801033c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
801033c8:	50                   	push   %eax
801033c9:	e8 43 ff ff ff       	call   80103311 <fill_rtcdate>
801033ce:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801033d1:	83 ec 04             	sub    $0x4,%esp
801033d4:	6a 18                	push   $0x18
801033d6:	8d 45 c0             	lea    -0x40(%ebp),%eax
801033d9:	50                   	push   %eax
801033da:	8d 45 d8             	lea    -0x28(%ebp),%eax
801033dd:	50                   	push   %eax
801033de:	e8 3b 2d 00 00       	call   8010611e <memcmp>
801033e3:	83 c4 10             	add    $0x10,%esp
801033e6:	85 c0                	test   %eax,%eax
801033e8:	74 05                	je     801033ef <cmostime+0x6d>
801033ea:	eb ba                	jmp    801033a6 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801033ec:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801033ed:	eb b7                	jmp    801033a6 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801033ef:	90                   	nop
  }

  // convert
  if (bcd) {
801033f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801033f4:	0f 84 b4 00 00 00    	je     801034ae <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801033fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033fd:	c1 e8 04             	shr    $0x4,%eax
80103400:	89 c2                	mov    %eax,%edx
80103402:	89 d0                	mov    %edx,%eax
80103404:	c1 e0 02             	shl    $0x2,%eax
80103407:	01 d0                	add    %edx,%eax
80103409:	01 c0                	add    %eax,%eax
8010340b:	89 c2                	mov    %eax,%edx
8010340d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103410:	83 e0 0f             	and    $0xf,%eax
80103413:	01 d0                	add    %edx,%eax
80103415:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103418:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010341b:	c1 e8 04             	shr    $0x4,%eax
8010341e:	89 c2                	mov    %eax,%edx
80103420:	89 d0                	mov    %edx,%eax
80103422:	c1 e0 02             	shl    $0x2,%eax
80103425:	01 d0                	add    %edx,%eax
80103427:	01 c0                	add    %eax,%eax
80103429:	89 c2                	mov    %eax,%edx
8010342b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010342e:	83 e0 0f             	and    $0xf,%eax
80103431:	01 d0                	add    %edx,%eax
80103433:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103436:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103439:	c1 e8 04             	shr    $0x4,%eax
8010343c:	89 c2                	mov    %eax,%edx
8010343e:	89 d0                	mov    %edx,%eax
80103440:	c1 e0 02             	shl    $0x2,%eax
80103443:	01 d0                	add    %edx,%eax
80103445:	01 c0                	add    %eax,%eax
80103447:	89 c2                	mov    %eax,%edx
80103449:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010344c:	83 e0 0f             	and    $0xf,%eax
8010344f:	01 d0                	add    %edx,%eax
80103451:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103457:	c1 e8 04             	shr    $0x4,%eax
8010345a:	89 c2                	mov    %eax,%edx
8010345c:	89 d0                	mov    %edx,%eax
8010345e:	c1 e0 02             	shl    $0x2,%eax
80103461:	01 d0                	add    %edx,%eax
80103463:	01 c0                	add    %eax,%eax
80103465:	89 c2                	mov    %eax,%edx
80103467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010346a:	83 e0 0f             	and    $0xf,%eax
8010346d:	01 d0                	add    %edx,%eax
8010346f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103472:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103475:	c1 e8 04             	shr    $0x4,%eax
80103478:	89 c2                	mov    %eax,%edx
8010347a:	89 d0                	mov    %edx,%eax
8010347c:	c1 e0 02             	shl    $0x2,%eax
8010347f:	01 d0                	add    %edx,%eax
80103481:	01 c0                	add    %eax,%eax
80103483:	89 c2                	mov    %eax,%edx
80103485:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103488:	83 e0 0f             	and    $0xf,%eax
8010348b:	01 d0                	add    %edx,%eax
8010348d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103490:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103493:	c1 e8 04             	shr    $0x4,%eax
80103496:	89 c2                	mov    %eax,%edx
80103498:	89 d0                	mov    %edx,%eax
8010349a:	c1 e0 02             	shl    $0x2,%eax
8010349d:	01 d0                	add    %edx,%eax
8010349f:	01 c0                	add    %eax,%eax
801034a1:	89 c2                	mov    %eax,%edx
801034a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034a6:	83 e0 0f             	and    $0xf,%eax
801034a9:	01 d0                	add    %edx,%eax
801034ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801034ae:	8b 45 08             	mov    0x8(%ebp),%eax
801034b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
801034b4:	89 10                	mov    %edx,(%eax)
801034b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801034b9:	89 50 04             	mov    %edx,0x4(%eax)
801034bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801034bf:	89 50 08             	mov    %edx,0x8(%eax)
801034c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034c5:	89 50 0c             	mov    %edx,0xc(%eax)
801034c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801034cb:	89 50 10             	mov    %edx,0x10(%eax)
801034ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
801034d1:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801034d4:	8b 45 08             	mov    0x8(%ebp),%eax
801034d7:	8b 40 14             	mov    0x14(%eax),%eax
801034da:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801034e0:	8b 45 08             	mov    0x8(%ebp),%eax
801034e3:	89 50 14             	mov    %edx,0x14(%eax)
}
801034e6:	90                   	nop
801034e7:	c9                   	leave  
801034e8:	c3                   	ret    

801034e9 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801034e9:	55                   	push   %ebp
801034ea:	89 e5                	mov    %esp,%ebp
801034ec:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801034ef:	83 ec 08             	sub    $0x8,%esp
801034f2:	68 18 9a 10 80       	push   $0x80109a18
801034f7:	68 80 42 11 80       	push   $0x80114280
801034fc:	e8 31 29 00 00       	call   80105e32 <initlock>
80103501:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103504:	83 ec 08             	sub    $0x8,%esp
80103507:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010350a:	50                   	push   %eax
8010350b:	ff 75 08             	pushl  0x8(%ebp)
8010350e:	e8 b3 df ff ff       	call   801014c6 <readsb>
80103513:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103516:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103519:	a3 b4 42 11 80       	mov    %eax,0x801142b4
  log.size = sb.nlog;
8010351e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103521:	a3 b8 42 11 80       	mov    %eax,0x801142b8
  log.dev = dev;
80103526:	8b 45 08             	mov    0x8(%ebp),%eax
80103529:	a3 c4 42 11 80       	mov    %eax,0x801142c4
  recover_from_log();
8010352e:	e8 b2 01 00 00       	call   801036e5 <recover_from_log>
}
80103533:	90                   	nop
80103534:	c9                   	leave  
80103535:	c3                   	ret    

80103536 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103536:	55                   	push   %ebp
80103537:	89 e5                	mov    %esp,%ebp
80103539:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010353c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103543:	e9 95 00 00 00       	jmp    801035dd <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103548:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
8010354e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103551:	01 d0                	add    %edx,%eax
80103553:	83 c0 01             	add    $0x1,%eax
80103556:	89 c2                	mov    %eax,%edx
80103558:	a1 c4 42 11 80       	mov    0x801142c4,%eax
8010355d:	83 ec 08             	sub    $0x8,%esp
80103560:	52                   	push   %edx
80103561:	50                   	push   %eax
80103562:	e8 4f cc ff ff       	call   801001b6 <bread>
80103567:	83 c4 10             	add    $0x10,%esp
8010356a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103570:	83 c0 10             	add    $0x10,%eax
80103573:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
8010357a:	89 c2                	mov    %eax,%edx
8010357c:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103581:	83 ec 08             	sub    $0x8,%esp
80103584:	52                   	push   %edx
80103585:	50                   	push   %eax
80103586:	e8 2b cc ff ff       	call   801001b6 <bread>
8010358b:	83 c4 10             	add    $0x10,%esp
8010358e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103591:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103594:	8d 50 18             	lea    0x18(%eax),%edx
80103597:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010359a:	83 c0 18             	add    $0x18,%eax
8010359d:	83 ec 04             	sub    $0x4,%esp
801035a0:	68 00 02 00 00       	push   $0x200
801035a5:	52                   	push   %edx
801035a6:	50                   	push   %eax
801035a7:	e8 ca 2b 00 00       	call   80106176 <memmove>
801035ac:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801035af:	83 ec 0c             	sub    $0xc,%esp
801035b2:	ff 75 ec             	pushl  -0x14(%ebp)
801035b5:	e8 35 cc ff ff       	call   801001ef <bwrite>
801035ba:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801035bd:	83 ec 0c             	sub    $0xc,%esp
801035c0:	ff 75 f0             	pushl  -0x10(%ebp)
801035c3:	e8 66 cc ff ff       	call   8010022e <brelse>
801035c8:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801035cb:	83 ec 0c             	sub    $0xc,%esp
801035ce:	ff 75 ec             	pushl  -0x14(%ebp)
801035d1:	e8 58 cc ff ff       	call   8010022e <brelse>
801035d6:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035dd:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801035e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035e5:	0f 8f 5d ff ff ff    	jg     80103548 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801035eb:	90                   	nop
801035ec:	c9                   	leave  
801035ed:	c3                   	ret    

801035ee <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801035ee:	55                   	push   %ebp
801035ef:	89 e5                	mov    %esp,%ebp
801035f1:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801035f4:	a1 b4 42 11 80       	mov    0x801142b4,%eax
801035f9:	89 c2                	mov    %eax,%edx
801035fb:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103600:	83 ec 08             	sub    $0x8,%esp
80103603:	52                   	push   %edx
80103604:	50                   	push   %eax
80103605:	e8 ac cb ff ff       	call   801001b6 <bread>
8010360a:	83 c4 10             	add    $0x10,%esp
8010360d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103610:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103613:	83 c0 18             	add    $0x18,%eax
80103616:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103619:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010361c:	8b 00                	mov    (%eax),%eax
8010361e:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  for (i = 0; i < log.lh.n; i++) {
80103623:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010362a:	eb 1b                	jmp    80103647 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010362c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010362f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103632:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103636:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103639:	83 c2 10             	add    $0x10,%edx
8010363c:	89 04 95 8c 42 11 80 	mov    %eax,-0x7feebd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103643:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103647:	a1 c8 42 11 80       	mov    0x801142c8,%eax
8010364c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010364f:	7f db                	jg     8010362c <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103651:	83 ec 0c             	sub    $0xc,%esp
80103654:	ff 75 f0             	pushl  -0x10(%ebp)
80103657:	e8 d2 cb ff ff       	call   8010022e <brelse>
8010365c:	83 c4 10             	add    $0x10,%esp
}
8010365f:	90                   	nop
80103660:	c9                   	leave  
80103661:	c3                   	ret    

80103662 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103662:	55                   	push   %ebp
80103663:	89 e5                	mov    %esp,%ebp
80103665:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103668:	a1 b4 42 11 80       	mov    0x801142b4,%eax
8010366d:	89 c2                	mov    %eax,%edx
8010366f:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103674:	83 ec 08             	sub    $0x8,%esp
80103677:	52                   	push   %edx
80103678:	50                   	push   %eax
80103679:	e8 38 cb ff ff       	call   801001b6 <bread>
8010367e:	83 c4 10             	add    $0x10,%esp
80103681:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103684:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103687:	83 c0 18             	add    $0x18,%eax
8010368a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010368d:	8b 15 c8 42 11 80    	mov    0x801142c8,%edx
80103693:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103696:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103698:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010369f:	eb 1b                	jmp    801036bc <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801036a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036a4:	83 c0 10             	add    $0x10,%eax
801036a7:	8b 0c 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%ecx
801036ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036b4:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801036b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036bc:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801036c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036c4:	7f db                	jg     801036a1 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801036c6:	83 ec 0c             	sub    $0xc,%esp
801036c9:	ff 75 f0             	pushl  -0x10(%ebp)
801036cc:	e8 1e cb ff ff       	call   801001ef <bwrite>
801036d1:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801036d4:	83 ec 0c             	sub    $0xc,%esp
801036d7:	ff 75 f0             	pushl  -0x10(%ebp)
801036da:	e8 4f cb ff ff       	call   8010022e <brelse>
801036df:	83 c4 10             	add    $0x10,%esp
}
801036e2:	90                   	nop
801036e3:	c9                   	leave  
801036e4:	c3                   	ret    

801036e5 <recover_from_log>:

static void
recover_from_log(void)
{
801036e5:	55                   	push   %ebp
801036e6:	89 e5                	mov    %esp,%ebp
801036e8:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801036eb:	e8 fe fe ff ff       	call   801035ee <read_head>
  install_trans(); // if committed, copy from log to disk
801036f0:	e8 41 fe ff ff       	call   80103536 <install_trans>
  log.lh.n = 0;
801036f5:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
801036fc:	00 00 00 
  write_head(); // clear the log
801036ff:	e8 5e ff ff ff       	call   80103662 <write_head>
}
80103704:	90                   	nop
80103705:	c9                   	leave  
80103706:	c3                   	ret    

80103707 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103707:	55                   	push   %ebp
80103708:	89 e5                	mov    %esp,%ebp
8010370a:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010370d:	83 ec 0c             	sub    $0xc,%esp
80103710:	68 80 42 11 80       	push   $0x80114280
80103715:	e8 3a 27 00 00       	call   80105e54 <acquire>
8010371a:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010371d:	a1 c0 42 11 80       	mov    0x801142c0,%eax
80103722:	85 c0                	test   %eax,%eax
80103724:	74 17                	je     8010373d <begin_op+0x36>
      sleep(&log, &log.lock);
80103726:	83 ec 08             	sub    $0x8,%esp
80103729:	68 80 42 11 80       	push   $0x80114280
8010372e:	68 80 42 11 80       	push   $0x80114280
80103733:	e8 8f 18 00 00       	call   80104fc7 <sleep>
80103738:	83 c4 10             	add    $0x10,%esp
8010373b:	eb e0                	jmp    8010371d <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010373d:	8b 0d c8 42 11 80    	mov    0x801142c8,%ecx
80103743:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103748:	8d 50 01             	lea    0x1(%eax),%edx
8010374b:	89 d0                	mov    %edx,%eax
8010374d:	c1 e0 02             	shl    $0x2,%eax
80103750:	01 d0                	add    %edx,%eax
80103752:	01 c0                	add    %eax,%eax
80103754:	01 c8                	add    %ecx,%eax
80103756:	83 f8 1e             	cmp    $0x1e,%eax
80103759:	7e 17                	jle    80103772 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010375b:	83 ec 08             	sub    $0x8,%esp
8010375e:	68 80 42 11 80       	push   $0x80114280
80103763:	68 80 42 11 80       	push   $0x80114280
80103768:	e8 5a 18 00 00       	call   80104fc7 <sleep>
8010376d:	83 c4 10             	add    $0x10,%esp
80103770:	eb ab                	jmp    8010371d <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103772:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103777:	83 c0 01             	add    $0x1,%eax
8010377a:	a3 bc 42 11 80       	mov    %eax,0x801142bc
      release(&log.lock);
8010377f:	83 ec 0c             	sub    $0xc,%esp
80103782:	68 80 42 11 80       	push   $0x80114280
80103787:	e8 2f 27 00 00       	call   80105ebb <release>
8010378c:	83 c4 10             	add    $0x10,%esp
      break;
8010378f:	90                   	nop
    }
  }
}
80103790:	90                   	nop
80103791:	c9                   	leave  
80103792:	c3                   	ret    

80103793 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103793:	55                   	push   %ebp
80103794:	89 e5                	mov    %esp,%ebp
80103796:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	68 80 42 11 80       	push   $0x80114280
801037a8:	e8 a7 26 00 00       	call   80105e54 <acquire>
801037ad:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801037b0:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801037b5:	83 e8 01             	sub    $0x1,%eax
801037b8:	a3 bc 42 11 80       	mov    %eax,0x801142bc
  if(log.committing)
801037bd:	a1 c0 42 11 80       	mov    0x801142c0,%eax
801037c2:	85 c0                	test   %eax,%eax
801037c4:	74 0d                	je     801037d3 <end_op+0x40>
    panic("log.committing");
801037c6:	83 ec 0c             	sub    $0xc,%esp
801037c9:	68 1c 9a 10 80       	push   $0x80109a1c
801037ce:	e8 93 cd ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801037d3:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801037d8:	85 c0                	test   %eax,%eax
801037da:	75 13                	jne    801037ef <end_op+0x5c>
    do_commit = 1;
801037dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801037e3:	c7 05 c0 42 11 80 01 	movl   $0x1,0x801142c0
801037ea:	00 00 00 
801037ed:	eb 10                	jmp    801037ff <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801037ef:	83 ec 0c             	sub    $0xc,%esp
801037f2:	68 80 42 11 80       	push   $0x80114280
801037f7:	e8 b2 18 00 00       	call   801050ae <wakeup>
801037fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801037ff:	83 ec 0c             	sub    $0xc,%esp
80103802:	68 80 42 11 80       	push   $0x80114280
80103807:	e8 af 26 00 00       	call   80105ebb <release>
8010380c:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010380f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103813:	74 3f                	je     80103854 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103815:	e8 f5 00 00 00       	call   8010390f <commit>
    acquire(&log.lock);
8010381a:	83 ec 0c             	sub    $0xc,%esp
8010381d:	68 80 42 11 80       	push   $0x80114280
80103822:	e8 2d 26 00 00       	call   80105e54 <acquire>
80103827:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010382a:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
80103831:	00 00 00 
    wakeup(&log);
80103834:	83 ec 0c             	sub    $0xc,%esp
80103837:	68 80 42 11 80       	push   $0x80114280
8010383c:	e8 6d 18 00 00       	call   801050ae <wakeup>
80103841:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103844:	83 ec 0c             	sub    $0xc,%esp
80103847:	68 80 42 11 80       	push   $0x80114280
8010384c:	e8 6a 26 00 00       	call   80105ebb <release>
80103851:	83 c4 10             	add    $0x10,%esp
  }
}
80103854:	90                   	nop
80103855:	c9                   	leave  
80103856:	c3                   	ret    

80103857 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103857:	55                   	push   %ebp
80103858:	89 e5                	mov    %esp,%ebp
8010385a:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010385d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103864:	e9 95 00 00 00       	jmp    801038fe <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103869:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
8010386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103872:	01 d0                	add    %edx,%eax
80103874:	83 c0 01             	add    $0x1,%eax
80103877:	89 c2                	mov    %eax,%edx
80103879:	a1 c4 42 11 80       	mov    0x801142c4,%eax
8010387e:	83 ec 08             	sub    $0x8,%esp
80103881:	52                   	push   %edx
80103882:	50                   	push   %eax
80103883:	e8 2e c9 ff ff       	call   801001b6 <bread>
80103888:	83 c4 10             	add    $0x10,%esp
8010388b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010388e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103891:	83 c0 10             	add    $0x10,%eax
80103894:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
8010389b:	89 c2                	mov    %eax,%edx
8010389d:	a1 c4 42 11 80       	mov    0x801142c4,%eax
801038a2:	83 ec 08             	sub    $0x8,%esp
801038a5:	52                   	push   %edx
801038a6:	50                   	push   %eax
801038a7:	e8 0a c9 ff ff       	call   801001b6 <bread>
801038ac:	83 c4 10             	add    $0x10,%esp
801038af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801038b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038b5:	8d 50 18             	lea    0x18(%eax),%edx
801038b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038bb:	83 c0 18             	add    $0x18,%eax
801038be:	83 ec 04             	sub    $0x4,%esp
801038c1:	68 00 02 00 00       	push   $0x200
801038c6:	52                   	push   %edx
801038c7:	50                   	push   %eax
801038c8:	e8 a9 28 00 00       	call   80106176 <memmove>
801038cd:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	ff 75 f0             	pushl  -0x10(%ebp)
801038d6:	e8 14 c9 ff ff       	call   801001ef <bwrite>
801038db:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801038de:	83 ec 0c             	sub    $0xc,%esp
801038e1:	ff 75 ec             	pushl  -0x14(%ebp)
801038e4:	e8 45 c9 ff ff       	call   8010022e <brelse>
801038e9:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801038ec:	83 ec 0c             	sub    $0xc,%esp
801038ef:	ff 75 f0             	pushl  -0x10(%ebp)
801038f2:	e8 37 c9 ff ff       	call   8010022e <brelse>
801038f7:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801038fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038fe:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103903:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103906:	0f 8f 5d ff ff ff    	jg     80103869 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
8010390c:	90                   	nop
8010390d:	c9                   	leave  
8010390e:	c3                   	ret    

8010390f <commit>:

static void
commit()
{
8010390f:	55                   	push   %ebp
80103910:	89 e5                	mov    %esp,%ebp
80103912:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103915:	a1 c8 42 11 80       	mov    0x801142c8,%eax
8010391a:	85 c0                	test   %eax,%eax
8010391c:	7e 1e                	jle    8010393c <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010391e:	e8 34 ff ff ff       	call   80103857 <write_log>
    write_head();    // Write header to disk -- the real commit
80103923:	e8 3a fd ff ff       	call   80103662 <write_head>
    install_trans(); // Now install writes to home locations
80103928:	e8 09 fc ff ff       	call   80103536 <install_trans>
    log.lh.n = 0; 
8010392d:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
80103934:	00 00 00 
    write_head();    // Erase the transaction from the log
80103937:	e8 26 fd ff ff       	call   80103662 <write_head>
  }
}
8010393c:	90                   	nop
8010393d:	c9                   	leave  
8010393e:	c3                   	ret    

8010393f <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010393f:	55                   	push   %ebp
80103940:	89 e5                	mov    %esp,%ebp
80103942:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103945:	a1 c8 42 11 80       	mov    0x801142c8,%eax
8010394a:	83 f8 1d             	cmp    $0x1d,%eax
8010394d:	7f 12                	jg     80103961 <log_write+0x22>
8010394f:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103954:	8b 15 b8 42 11 80    	mov    0x801142b8,%edx
8010395a:	83 ea 01             	sub    $0x1,%edx
8010395d:	39 d0                	cmp    %edx,%eax
8010395f:	7c 0d                	jl     8010396e <log_write+0x2f>
    panic("too big a transaction");
80103961:	83 ec 0c             	sub    $0xc,%esp
80103964:	68 2b 9a 10 80       	push   $0x80109a2b
80103969:	e8 f8 cb ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010396e:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103973:	85 c0                	test   %eax,%eax
80103975:	7f 0d                	jg     80103984 <log_write+0x45>
    panic("log_write outside of trans");
80103977:	83 ec 0c             	sub    $0xc,%esp
8010397a:	68 41 9a 10 80       	push   $0x80109a41
8010397f:	e8 e2 cb ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103984:	83 ec 0c             	sub    $0xc,%esp
80103987:	68 80 42 11 80       	push   $0x80114280
8010398c:	e8 c3 24 00 00       	call   80105e54 <acquire>
80103991:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103994:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010399b:	eb 1d                	jmp    801039ba <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010399d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a0:	83 c0 10             	add    $0x10,%eax
801039a3:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
801039aa:	89 c2                	mov    %eax,%edx
801039ac:	8b 45 08             	mov    0x8(%ebp),%eax
801039af:	8b 40 08             	mov    0x8(%eax),%eax
801039b2:	39 c2                	cmp    %eax,%edx
801039b4:	74 10                	je     801039c6 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801039b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801039ba:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801039bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039c2:	7f d9                	jg     8010399d <log_write+0x5e>
801039c4:	eb 01                	jmp    801039c7 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
801039c6:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801039c7:	8b 45 08             	mov    0x8(%ebp),%eax
801039ca:	8b 40 08             	mov    0x8(%eax),%eax
801039cd:	89 c2                	mov    %eax,%edx
801039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039d2:	83 c0 10             	add    $0x10,%eax
801039d5:	89 14 85 8c 42 11 80 	mov    %edx,-0x7feebd74(,%eax,4)
  if (i == log.lh.n)
801039dc:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801039e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039e4:	75 0d                	jne    801039f3 <log_write+0xb4>
    log.lh.n++;
801039e6:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801039eb:	83 c0 01             	add    $0x1,%eax
801039ee:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  b->flags |= B_DIRTY; // prevent eviction
801039f3:	8b 45 08             	mov    0x8(%ebp),%eax
801039f6:	8b 00                	mov    (%eax),%eax
801039f8:	83 c8 04             	or     $0x4,%eax
801039fb:	89 c2                	mov    %eax,%edx
801039fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103a00:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103a02:	83 ec 0c             	sub    $0xc,%esp
80103a05:	68 80 42 11 80       	push   $0x80114280
80103a0a:	e8 ac 24 00 00       	call   80105ebb <release>
80103a0f:	83 c4 10             	add    $0x10,%esp
}
80103a12:	90                   	nop
80103a13:	c9                   	leave  
80103a14:	c3                   	ret    

80103a15 <v2p>:
80103a15:	55                   	push   %ebp
80103a16:	89 e5                	mov    %esp,%ebp
80103a18:	8b 45 08             	mov    0x8(%ebp),%eax
80103a1b:	05 00 00 00 80       	add    $0x80000000,%eax
80103a20:	5d                   	pop    %ebp
80103a21:	c3                   	ret    

80103a22 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103a22:	55                   	push   %ebp
80103a23:	89 e5                	mov    %esp,%ebp
80103a25:	8b 45 08             	mov    0x8(%ebp),%eax
80103a28:	05 00 00 00 80       	add    $0x80000000,%eax
80103a2d:	5d                   	pop    %ebp
80103a2e:	c3                   	ret    

80103a2f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103a2f:	55                   	push   %ebp
80103a30:	89 e5                	mov    %esp,%ebp
80103a32:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103a35:	8b 55 08             	mov    0x8(%ebp),%edx
80103a38:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103a3e:	f0 87 02             	lock xchg %eax,(%edx)
80103a41:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103a47:	c9                   	leave  
80103a48:	c3                   	ret    

80103a49 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103a49:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103a4d:	83 e4 f0             	and    $0xfffffff0,%esp
80103a50:	ff 71 fc             	pushl  -0x4(%ecx)
80103a53:	55                   	push   %ebp
80103a54:	89 e5                	mov    %esp,%ebp
80103a56:	51                   	push   %ecx
80103a57:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103a5a:	83 ec 08             	sub    $0x8,%esp
80103a5d:	68 00 00 40 80       	push   $0x80400000
80103a62:	68 3c 79 11 80       	push   $0x8011793c
80103a67:	e8 7d f2 ff ff       	call   80102ce9 <kinit1>
80103a6c:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103a6f:	e8 b8 55 00 00       	call   8010902c <kvmalloc>
  mpinit();        // collect info about this machine
80103a74:	e8 43 04 00 00       	call   80103ebc <mpinit>
  lapicinit();
80103a79:	e8 ea f5 ff ff       	call   80103068 <lapicinit>
  seginit();       // set up segments
80103a7e:	e8 52 4f 00 00       	call   801089d5 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103a83:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a89:	0f b6 00             	movzbl (%eax),%eax
80103a8c:	0f b6 c0             	movzbl %al,%eax
80103a8f:	83 ec 08             	sub    $0x8,%esp
80103a92:	50                   	push   %eax
80103a93:	68 5c 9a 10 80       	push   $0x80109a5c
80103a98:	e8 29 c9 ff ff       	call   801003c6 <cprintf>
80103a9d:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103aa0:	e8 6d 06 00 00       	call   80104112 <picinit>
  ioapicinit();    // another interrupt controller
80103aa5:	e8 34 f1 ff ff       	call   80102bde <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103aaa:	e8 10 d1 ff ff       	call   80100bbf <consoleinit>
  uartinit();      // serial port
80103aaf:	e8 7d 42 00 00       	call   80107d31 <uartinit>
  pinit();         // process table
80103ab4:	e8 5d 0b 00 00       	call   80104616 <pinit>
  tvinit();        // trap vectors
80103ab9:	e8 6f 3e 00 00       	call   8010792d <tvinit>
  binit();         // buffer cache
80103abe:	e8 71 c5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103ac3:	e8 ef d5 ff ff       	call   801010b7 <fileinit>
  ideinit();       // disk
80103ac8:	e8 19 ed ff ff       	call   801027e6 <ideinit>
  if(!ismp)
80103acd:	a1 64 43 11 80       	mov    0x80114364,%eax
80103ad2:	85 c0                	test   %eax,%eax
80103ad4:	75 05                	jne    80103adb <main+0x92>
    timerinit();   // uniprocessor timer
80103ad6:	e8 a3 3d 00 00       	call   8010787e <timerinit>
  startothers();   // start other processors
80103adb:	e8 7f 00 00 00       	call   80103b5f <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103ae0:	83 ec 08             	sub    $0x8,%esp
80103ae3:	68 00 00 00 8e       	push   $0x8e000000
80103ae8:	68 00 00 40 80       	push   $0x80400000
80103aed:	e8 30 f2 ff ff       	call   80102d22 <kinit2>
80103af2:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103af5:	e8 88 0c 00 00       	call   80104782 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103afa:	e8 1a 00 00 00       	call   80103b19 <mpmain>

80103aff <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103aff:	55                   	push   %ebp
80103b00:	89 e5                	mov    %esp,%ebp
80103b02:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103b05:	e8 3a 55 00 00       	call   80109044 <switchkvm>
  seginit();
80103b0a:	e8 c6 4e 00 00       	call   801089d5 <seginit>
  lapicinit();
80103b0f:	e8 54 f5 ff ff       	call   80103068 <lapicinit>
  mpmain();
80103b14:	e8 00 00 00 00       	call   80103b19 <mpmain>

80103b19 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103b19:	55                   	push   %ebp
80103b1a:	89 e5                	mov    %esp,%ebp
80103b1c:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103b1f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b25:	0f b6 00             	movzbl (%eax),%eax
80103b28:	0f b6 c0             	movzbl %al,%eax
80103b2b:	83 ec 08             	sub    $0x8,%esp
80103b2e:	50                   	push   %eax
80103b2f:	68 73 9a 10 80       	push   $0x80109a73
80103b34:	e8 8d c8 ff ff       	call   801003c6 <cprintf>
80103b39:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103b3c:	e8 4d 3f 00 00       	call   80107a8e <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103b41:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b47:	05 a8 00 00 00       	add    $0xa8,%eax
80103b4c:	83 ec 08             	sub    $0x8,%esp
80103b4f:	6a 01                	push   $0x1
80103b51:	50                   	push   %eax
80103b52:	e8 d8 fe ff ff       	call   80103a2f <xchg>
80103b57:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103b5a:	e8 18 12 00 00       	call   80104d77 <scheduler>

80103b5f <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103b5f:	55                   	push   %ebp
80103b60:	89 e5                	mov    %esp,%ebp
80103b62:	53                   	push   %ebx
80103b63:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103b66:	68 00 70 00 00       	push   $0x7000
80103b6b:	e8 b2 fe ff ff       	call   80103a22 <p2v>
80103b70:	83 c4 04             	add    $0x4,%esp
80103b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b76:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103b7b:	83 ec 04             	sub    $0x4,%esp
80103b7e:	50                   	push   %eax
80103b7f:	68 2c d5 10 80       	push   $0x8010d52c
80103b84:	ff 75 f0             	pushl  -0x10(%ebp)
80103b87:	e8 ea 25 00 00       	call   80106176 <memmove>
80103b8c:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103b8f:	c7 45 f4 80 43 11 80 	movl   $0x80114380,-0xc(%ebp)
80103b96:	e9 90 00 00 00       	jmp    80103c2b <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103b9b:	e8 e6 f5 ff ff       	call   80103186 <cpunum>
80103ba0:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ba6:	05 80 43 11 80       	add    $0x80114380,%eax
80103bab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103bae:	74 73                	je     80103c23 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103bb0:	e8 6b f2 ff ff       	call   80102e20 <kalloc>
80103bb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bbb:	83 e8 04             	sub    $0x4,%eax
80103bbe:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103bc1:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103bc7:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bcc:	83 e8 08             	sub    $0x8,%eax
80103bcf:	c7 00 ff 3a 10 80    	movl   $0x80103aff,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd8:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103bdb:	83 ec 0c             	sub    $0xc,%esp
80103bde:	68 00 c0 10 80       	push   $0x8010c000
80103be3:	e8 2d fe ff ff       	call   80103a15 <v2p>
80103be8:	83 c4 10             	add    $0x10,%esp
80103beb:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103bed:	83 ec 0c             	sub    $0xc,%esp
80103bf0:	ff 75 f0             	pushl  -0x10(%ebp)
80103bf3:	e8 1d fe ff ff       	call   80103a15 <v2p>
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	89 c2                	mov    %eax,%edx
80103bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c00:	0f b6 00             	movzbl (%eax),%eax
80103c03:	0f b6 c0             	movzbl %al,%eax
80103c06:	83 ec 08             	sub    $0x8,%esp
80103c09:	52                   	push   %edx
80103c0a:	50                   	push   %eax
80103c0b:	e8 f0 f5 ff ff       	call   80103200 <lapicstartap>
80103c10:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103c13:	90                   	nop
80103c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c17:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103c1d:	85 c0                	test   %eax,%eax
80103c1f:	74 f3                	je     80103c14 <startothers+0xb5>
80103c21:	eb 01                	jmp    80103c24 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103c23:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103c24:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103c2b:	a1 60 49 11 80       	mov    0x80114960,%eax
80103c30:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c36:	05 80 43 11 80       	add    $0x80114380,%eax
80103c3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103c3e:	0f 87 57 ff ff ff    	ja     80103b9b <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103c44:	90                   	nop
80103c45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c48:	c9                   	leave  
80103c49:	c3                   	ret    

80103c4a <p2v>:
80103c4a:	55                   	push   %ebp
80103c4b:	89 e5                	mov    %esp,%ebp
80103c4d:	8b 45 08             	mov    0x8(%ebp),%eax
80103c50:	05 00 00 00 80       	add    $0x80000000,%eax
80103c55:	5d                   	pop    %ebp
80103c56:	c3                   	ret    

80103c57 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103c57:	55                   	push   %ebp
80103c58:	89 e5                	mov    %esp,%ebp
80103c5a:	83 ec 14             	sub    $0x14,%esp
80103c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80103c60:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c64:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103c68:	89 c2                	mov    %eax,%edx
80103c6a:	ec                   	in     (%dx),%al
80103c6b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103c6e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103c72:	c9                   	leave  
80103c73:	c3                   	ret    

80103c74 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103c74:	55                   	push   %ebp
80103c75:	89 e5                	mov    %esp,%ebp
80103c77:	83 ec 08             	sub    $0x8,%esp
80103c7a:	8b 55 08             	mov    0x8(%ebp),%edx
80103c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c80:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103c84:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c87:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c8b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c8f:	ee                   	out    %al,(%dx)
}
80103c90:	90                   	nop
80103c91:	c9                   	leave  
80103c92:	c3                   	ret    

80103c93 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103c93:	55                   	push   %ebp
80103c94:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103c96:	a1 64 d6 10 80       	mov    0x8010d664,%eax
80103c9b:	89 c2                	mov    %eax,%edx
80103c9d:	b8 80 43 11 80       	mov    $0x80114380,%eax
80103ca2:	29 c2                	sub    %eax,%edx
80103ca4:	89 d0                	mov    %edx,%eax
80103ca6:	c1 f8 02             	sar    $0x2,%eax
80103ca9:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103caf:	5d                   	pop    %ebp
80103cb0:	c3                   	ret    

80103cb1 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103cb1:	55                   	push   %ebp
80103cb2:	89 e5                	mov    %esp,%ebp
80103cb4:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103cb7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103cbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103cc5:	eb 15                	jmp    80103cdc <sum+0x2b>
    sum += addr[i];
80103cc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103cca:	8b 45 08             	mov    0x8(%ebp),%eax
80103ccd:	01 d0                	add    %edx,%eax
80103ccf:	0f b6 00             	movzbl (%eax),%eax
80103cd2:	0f b6 c0             	movzbl %al,%eax
80103cd5:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103cd8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103cdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103cdf:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103ce2:	7c e3                	jl     80103cc7 <sum+0x16>
    sum += addr[i];
  return sum;
80103ce4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103ce7:	c9                   	leave  
80103ce8:	c3                   	ret    

80103ce9 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103ce9:	55                   	push   %ebp
80103cea:	89 e5                	mov    %esp,%ebp
80103cec:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103cef:	ff 75 08             	pushl  0x8(%ebp)
80103cf2:	e8 53 ff ff ff       	call   80103c4a <p2v>
80103cf7:	83 c4 04             	add    $0x4,%esp
80103cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d03:	01 d0                	add    %edx,%eax
80103d05:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d0e:	eb 36                	jmp    80103d46 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103d10:	83 ec 04             	sub    $0x4,%esp
80103d13:	6a 04                	push   $0x4
80103d15:	68 84 9a 10 80       	push   $0x80109a84
80103d1a:	ff 75 f4             	pushl  -0xc(%ebp)
80103d1d:	e8 fc 23 00 00       	call   8010611e <memcmp>
80103d22:	83 c4 10             	add    $0x10,%esp
80103d25:	85 c0                	test   %eax,%eax
80103d27:	75 19                	jne    80103d42 <mpsearch1+0x59>
80103d29:	83 ec 08             	sub    $0x8,%esp
80103d2c:	6a 10                	push   $0x10
80103d2e:	ff 75 f4             	pushl  -0xc(%ebp)
80103d31:	e8 7b ff ff ff       	call   80103cb1 <sum>
80103d36:	83 c4 10             	add    $0x10,%esp
80103d39:	84 c0                	test   %al,%al
80103d3b:	75 05                	jne    80103d42 <mpsearch1+0x59>
      return (struct mp*)p;
80103d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d40:	eb 11                	jmp    80103d53 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103d42:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d49:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d4c:	72 c2                	jb     80103d10 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d53:	c9                   	leave  
80103d54:	c3                   	ret    

80103d55 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103d55:	55                   	push   %ebp
80103d56:	89 e5                	mov    %esp,%ebp
80103d58:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103d5b:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d65:	83 c0 0f             	add    $0xf,%eax
80103d68:	0f b6 00             	movzbl (%eax),%eax
80103d6b:	0f b6 c0             	movzbl %al,%eax
80103d6e:	c1 e0 08             	shl    $0x8,%eax
80103d71:	89 c2                	mov    %eax,%edx
80103d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d76:	83 c0 0e             	add    $0xe,%eax
80103d79:	0f b6 00             	movzbl (%eax),%eax
80103d7c:	0f b6 c0             	movzbl %al,%eax
80103d7f:	09 d0                	or     %edx,%eax
80103d81:	c1 e0 04             	shl    $0x4,%eax
80103d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d8b:	74 21                	je     80103dae <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103d8d:	83 ec 08             	sub    $0x8,%esp
80103d90:	68 00 04 00 00       	push   $0x400
80103d95:	ff 75 f0             	pushl  -0x10(%ebp)
80103d98:	e8 4c ff ff ff       	call   80103ce9 <mpsearch1>
80103d9d:	83 c4 10             	add    $0x10,%esp
80103da0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103da3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103da7:	74 51                	je     80103dfa <mpsearch+0xa5>
      return mp;
80103da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103dac:	eb 61                	jmp    80103e0f <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db1:	83 c0 14             	add    $0x14,%eax
80103db4:	0f b6 00             	movzbl (%eax),%eax
80103db7:	0f b6 c0             	movzbl %al,%eax
80103dba:	c1 e0 08             	shl    $0x8,%eax
80103dbd:	89 c2                	mov    %eax,%edx
80103dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dc2:	83 c0 13             	add    $0x13,%eax
80103dc5:	0f b6 00             	movzbl (%eax),%eax
80103dc8:	0f b6 c0             	movzbl %al,%eax
80103dcb:	09 d0                	or     %edx,%eax
80103dcd:	c1 e0 0a             	shl    $0xa,%eax
80103dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dd6:	2d 00 04 00 00       	sub    $0x400,%eax
80103ddb:	83 ec 08             	sub    $0x8,%esp
80103dde:	68 00 04 00 00       	push   $0x400
80103de3:	50                   	push   %eax
80103de4:	e8 00 ff ff ff       	call   80103ce9 <mpsearch1>
80103de9:	83 c4 10             	add    $0x10,%esp
80103dec:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103def:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103df3:	74 05                	je     80103dfa <mpsearch+0xa5>
      return mp;
80103df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103df8:	eb 15                	jmp    80103e0f <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103dfa:	83 ec 08             	sub    $0x8,%esp
80103dfd:	68 00 00 01 00       	push   $0x10000
80103e02:	68 00 00 0f 00       	push   $0xf0000
80103e07:	e8 dd fe ff ff       	call   80103ce9 <mpsearch1>
80103e0c:	83 c4 10             	add    $0x10,%esp
}
80103e0f:	c9                   	leave  
80103e10:	c3                   	ret    

80103e11 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103e11:	55                   	push   %ebp
80103e12:	89 e5                	mov    %esp,%ebp
80103e14:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103e17:	e8 39 ff ff ff       	call   80103d55 <mpsearch>
80103e1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e23:	74 0a                	je     80103e2f <mpconfig+0x1e>
80103e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e28:	8b 40 04             	mov    0x4(%eax),%eax
80103e2b:	85 c0                	test   %eax,%eax
80103e2d:	75 0a                	jne    80103e39 <mpconfig+0x28>
    return 0;
80103e2f:	b8 00 00 00 00       	mov    $0x0,%eax
80103e34:	e9 81 00 00 00       	jmp    80103eba <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e3c:	8b 40 04             	mov    0x4(%eax),%eax
80103e3f:	83 ec 0c             	sub    $0xc,%esp
80103e42:	50                   	push   %eax
80103e43:	e8 02 fe ff ff       	call   80103c4a <p2v>
80103e48:	83 c4 10             	add    $0x10,%esp
80103e4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103e4e:	83 ec 04             	sub    $0x4,%esp
80103e51:	6a 04                	push   $0x4
80103e53:	68 89 9a 10 80       	push   $0x80109a89
80103e58:	ff 75 f0             	pushl  -0x10(%ebp)
80103e5b:	e8 be 22 00 00       	call   8010611e <memcmp>
80103e60:	83 c4 10             	add    $0x10,%esp
80103e63:	85 c0                	test   %eax,%eax
80103e65:	74 07                	je     80103e6e <mpconfig+0x5d>
    return 0;
80103e67:	b8 00 00 00 00       	mov    $0x0,%eax
80103e6c:	eb 4c                	jmp    80103eba <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e71:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e75:	3c 01                	cmp    $0x1,%al
80103e77:	74 12                	je     80103e8b <mpconfig+0x7a>
80103e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e7c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e80:	3c 04                	cmp    $0x4,%al
80103e82:	74 07                	je     80103e8b <mpconfig+0x7a>
    return 0;
80103e84:	b8 00 00 00 00       	mov    $0x0,%eax
80103e89:	eb 2f                	jmp    80103eba <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e8e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e92:	0f b7 c0             	movzwl %ax,%eax
80103e95:	83 ec 08             	sub    $0x8,%esp
80103e98:	50                   	push   %eax
80103e99:	ff 75 f0             	pushl  -0x10(%ebp)
80103e9c:	e8 10 fe ff ff       	call   80103cb1 <sum>
80103ea1:	83 c4 10             	add    $0x10,%esp
80103ea4:	84 c0                	test   %al,%al
80103ea6:	74 07                	je     80103eaf <mpconfig+0x9e>
    return 0;
80103ea8:	b8 00 00 00 00       	mov    $0x0,%eax
80103ead:	eb 0b                	jmp    80103eba <mpconfig+0xa9>
  *pmp = mp;
80103eaf:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103eb5:	89 10                	mov    %edx,(%eax)
  return conf;
80103eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103eba:	c9                   	leave  
80103ebb:	c3                   	ret    

80103ebc <mpinit>:

void
mpinit(void)
{
80103ebc:	55                   	push   %ebp
80103ebd:	89 e5                	mov    %esp,%ebp
80103ebf:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103ec2:	c7 05 64 d6 10 80 80 	movl   $0x80114380,0x8010d664
80103ec9:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103ecc:	83 ec 0c             	sub    $0xc,%esp
80103ecf:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103ed2:	50                   	push   %eax
80103ed3:	e8 39 ff ff ff       	call   80103e11 <mpconfig>
80103ed8:	83 c4 10             	add    $0x10,%esp
80103edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ede:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ee2:	0f 84 96 01 00 00    	je     8010407e <mpinit+0x1c2>
    return;
  ismp = 1;
80103ee8:	c7 05 64 43 11 80 01 	movl   $0x1,0x80114364
80103eef:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ef5:	8b 40 24             	mov    0x24(%eax),%eax
80103ef8:	a3 7c 42 11 80       	mov    %eax,0x8011427c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f00:	83 c0 2c             	add    $0x2c,%eax
80103f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f09:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103f0d:	0f b7 d0             	movzwl %ax,%edx
80103f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f13:	01 d0                	add    %edx,%eax
80103f15:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f18:	e9 f2 00 00 00       	jmp    8010400f <mpinit+0x153>
    switch(*p){
80103f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f20:	0f b6 00             	movzbl (%eax),%eax
80103f23:	0f b6 c0             	movzbl %al,%eax
80103f26:	83 f8 04             	cmp    $0x4,%eax
80103f29:	0f 87 bc 00 00 00    	ja     80103feb <mpinit+0x12f>
80103f2f:	8b 04 85 cc 9a 10 80 	mov    -0x7fef6534(,%eax,4),%eax
80103f36:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103f3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103f41:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f45:	0f b6 d0             	movzbl %al,%edx
80103f48:	a1 60 49 11 80       	mov    0x80114960,%eax
80103f4d:	39 c2                	cmp    %eax,%edx
80103f4f:	74 2b                	je     80103f7c <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103f51:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103f54:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f58:	0f b6 d0             	movzbl %al,%edx
80103f5b:	a1 60 49 11 80       	mov    0x80114960,%eax
80103f60:	83 ec 04             	sub    $0x4,%esp
80103f63:	52                   	push   %edx
80103f64:	50                   	push   %eax
80103f65:	68 8e 9a 10 80       	push   $0x80109a8e
80103f6a:	e8 57 c4 ff ff       	call   801003c6 <cprintf>
80103f6f:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103f72:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
80103f79:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103f7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103f7f:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103f83:	0f b6 c0             	movzbl %al,%eax
80103f86:	83 e0 02             	and    $0x2,%eax
80103f89:	85 c0                	test   %eax,%eax
80103f8b:	74 15                	je     80103fa2 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103f8d:	a1 60 49 11 80       	mov    0x80114960,%eax
80103f92:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103f98:	05 80 43 11 80       	add    $0x80114380,%eax
80103f9d:	a3 64 d6 10 80       	mov    %eax,0x8010d664
      cpus[ncpu].id = ncpu;
80103fa2:	a1 60 49 11 80       	mov    0x80114960,%eax
80103fa7:	8b 15 60 49 11 80    	mov    0x80114960,%edx
80103fad:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103fb3:	05 80 43 11 80       	add    $0x80114380,%eax
80103fb8:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103fba:	a1 60 49 11 80       	mov    0x80114960,%eax
80103fbf:	83 c0 01             	add    $0x1,%eax
80103fc2:	a3 60 49 11 80       	mov    %eax,0x80114960
      p += sizeof(struct mpproc);
80103fc7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103fcb:	eb 42                	jmp    8010400f <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103fd6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103fda:	a2 60 43 11 80       	mov    %al,0x80114360
      p += sizeof(struct mpioapic);
80103fdf:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103fe3:	eb 2a                	jmp    8010400f <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103fe5:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103fe9:	eb 24                	jmp    8010400f <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fee:	0f b6 00             	movzbl (%eax),%eax
80103ff1:	0f b6 c0             	movzbl %al,%eax
80103ff4:	83 ec 08             	sub    $0x8,%esp
80103ff7:	50                   	push   %eax
80103ff8:	68 ac 9a 10 80       	push   $0x80109aac
80103ffd:	e8 c4 c3 ff ff       	call   801003c6 <cprintf>
80104002:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80104005:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
8010400c:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010400f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104012:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104015:	0f 82 02 ff ff ff    	jb     80103f1d <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
8010401b:	a1 64 43 11 80       	mov    0x80114364,%eax
80104020:	85 c0                	test   %eax,%eax
80104022:	75 1d                	jne    80104041 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80104024:	c7 05 60 49 11 80 01 	movl   $0x1,0x80114960
8010402b:	00 00 00 
    lapic = 0;
8010402e:	c7 05 7c 42 11 80 00 	movl   $0x0,0x8011427c
80104035:	00 00 00 
    ioapicid = 0;
80104038:	c6 05 60 43 11 80 00 	movb   $0x0,0x80114360
    return;
8010403f:	eb 3e                	jmp    8010407f <mpinit+0x1c3>
  }

  if(mp->imcrp){
80104041:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104044:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80104048:	84 c0                	test   %al,%al
8010404a:	74 33                	je     8010407f <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
8010404c:	83 ec 08             	sub    $0x8,%esp
8010404f:	6a 70                	push   $0x70
80104051:	6a 22                	push   $0x22
80104053:	e8 1c fc ff ff       	call   80103c74 <outb>
80104058:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010405b:	83 ec 0c             	sub    $0xc,%esp
8010405e:	6a 23                	push   $0x23
80104060:	e8 f2 fb ff ff       	call   80103c57 <inb>
80104065:	83 c4 10             	add    $0x10,%esp
80104068:	83 c8 01             	or     $0x1,%eax
8010406b:	0f b6 c0             	movzbl %al,%eax
8010406e:	83 ec 08             	sub    $0x8,%esp
80104071:	50                   	push   %eax
80104072:	6a 23                	push   $0x23
80104074:	e8 fb fb ff ff       	call   80103c74 <outb>
80104079:	83 c4 10             	add    $0x10,%esp
8010407c:	eb 01                	jmp    8010407f <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
8010407e:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010407f:	c9                   	leave  
80104080:	c3                   	ret    

80104081 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80104081:	55                   	push   %ebp
80104082:	89 e5                	mov    %esp,%ebp
80104084:	83 ec 08             	sub    $0x8,%esp
80104087:	8b 55 08             	mov    0x8(%ebp),%edx
8010408a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010408d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80104091:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104094:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80104098:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010409c:	ee                   	out    %al,(%dx)
}
8010409d:	90                   	nop
8010409e:	c9                   	leave  
8010409f:	c3                   	ret    

801040a0 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	83 ec 04             	sub    $0x4,%esp
801040a6:	8b 45 08             	mov    0x8(%ebp),%eax
801040a9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
801040ad:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801040b1:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
801040b7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801040bb:	0f b6 c0             	movzbl %al,%eax
801040be:	50                   	push   %eax
801040bf:	6a 21                	push   $0x21
801040c1:	e8 bb ff ff ff       	call   80104081 <outb>
801040c6:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
801040c9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801040cd:	66 c1 e8 08          	shr    $0x8,%ax
801040d1:	0f b6 c0             	movzbl %al,%eax
801040d4:	50                   	push   %eax
801040d5:	68 a1 00 00 00       	push   $0xa1
801040da:	e8 a2 ff ff ff       	call   80104081 <outb>
801040df:	83 c4 08             	add    $0x8,%esp
}
801040e2:	90                   	nop
801040e3:	c9                   	leave  
801040e4:	c3                   	ret    

801040e5 <picenable>:

void
picenable(int irq)
{
801040e5:	55                   	push   %ebp
801040e6:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
801040e8:	8b 45 08             	mov    0x8(%ebp),%eax
801040eb:	ba 01 00 00 00       	mov    $0x1,%edx
801040f0:	89 c1                	mov    %eax,%ecx
801040f2:	d3 e2                	shl    %cl,%edx
801040f4:	89 d0                	mov    %edx,%eax
801040f6:	f7 d0                	not    %eax
801040f8:	89 c2                	mov    %eax,%edx
801040fa:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80104101:	21 d0                	and    %edx,%eax
80104103:	0f b7 c0             	movzwl %ax,%eax
80104106:	50                   	push   %eax
80104107:	e8 94 ff ff ff       	call   801040a0 <picsetmask>
8010410c:	83 c4 04             	add    $0x4,%esp
}
8010410f:	90                   	nop
80104110:	c9                   	leave  
80104111:	c3                   	ret    

80104112 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104112:	55                   	push   %ebp
80104113:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104115:	68 ff 00 00 00       	push   $0xff
8010411a:	6a 21                	push   $0x21
8010411c:	e8 60 ff ff ff       	call   80104081 <outb>
80104121:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104124:	68 ff 00 00 00       	push   $0xff
80104129:	68 a1 00 00 00       	push   $0xa1
8010412e:	e8 4e ff ff ff       	call   80104081 <outb>
80104133:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104136:	6a 11                	push   $0x11
80104138:	6a 20                	push   $0x20
8010413a:	e8 42 ff ff ff       	call   80104081 <outb>
8010413f:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104142:	6a 20                	push   $0x20
80104144:	6a 21                	push   $0x21
80104146:	e8 36 ff ff ff       	call   80104081 <outb>
8010414b:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010414e:	6a 04                	push   $0x4
80104150:	6a 21                	push   $0x21
80104152:	e8 2a ff ff ff       	call   80104081 <outb>
80104157:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
8010415a:	6a 03                	push   $0x3
8010415c:	6a 21                	push   $0x21
8010415e:	e8 1e ff ff ff       	call   80104081 <outb>
80104163:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104166:	6a 11                	push   $0x11
80104168:	68 a0 00 00 00       	push   $0xa0
8010416d:	e8 0f ff ff ff       	call   80104081 <outb>
80104172:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104175:	6a 28                	push   $0x28
80104177:	68 a1 00 00 00       	push   $0xa1
8010417c:	e8 00 ff ff ff       	call   80104081 <outb>
80104181:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104184:	6a 02                	push   $0x2
80104186:	68 a1 00 00 00       	push   $0xa1
8010418b:	e8 f1 fe ff ff       	call   80104081 <outb>
80104190:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104193:	6a 03                	push   $0x3
80104195:	68 a1 00 00 00       	push   $0xa1
8010419a:	e8 e2 fe ff ff       	call   80104081 <outb>
8010419f:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
801041a2:	6a 68                	push   $0x68
801041a4:	6a 20                	push   $0x20
801041a6:	e8 d6 fe ff ff       	call   80104081 <outb>
801041ab:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
801041ae:	6a 0a                	push   $0xa
801041b0:	6a 20                	push   $0x20
801041b2:	e8 ca fe ff ff       	call   80104081 <outb>
801041b7:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
801041ba:	6a 68                	push   $0x68
801041bc:	68 a0 00 00 00       	push   $0xa0
801041c1:	e8 bb fe ff ff       	call   80104081 <outb>
801041c6:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801041c9:	6a 0a                	push   $0xa
801041cb:	68 a0 00 00 00       	push   $0xa0
801041d0:	e8 ac fe ff ff       	call   80104081 <outb>
801041d5:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801041d8:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801041df:	66 83 f8 ff          	cmp    $0xffff,%ax
801041e3:	74 13                	je     801041f8 <picinit+0xe6>
    picsetmask(irqmask);
801041e5:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801041ec:	0f b7 c0             	movzwl %ax,%eax
801041ef:	50                   	push   %eax
801041f0:	e8 ab fe ff ff       	call   801040a0 <picsetmask>
801041f5:	83 c4 04             	add    $0x4,%esp
}
801041f8:	90                   	nop
801041f9:	c9                   	leave  
801041fa:	c3                   	ret    

801041fb <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801041fb:	55                   	push   %ebp
801041fc:	89 e5                	mov    %esp,%ebp
801041fe:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104201:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104208:	8b 45 0c             	mov    0xc(%ebp),%eax
8010420b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104211:	8b 45 0c             	mov    0xc(%ebp),%eax
80104214:	8b 10                	mov    (%eax),%edx
80104216:	8b 45 08             	mov    0x8(%ebp),%eax
80104219:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010421b:	e8 b5 ce ff ff       	call   801010d5 <filealloc>
80104220:	89 c2                	mov    %eax,%edx
80104222:	8b 45 08             	mov    0x8(%ebp),%eax
80104225:	89 10                	mov    %edx,(%eax)
80104227:	8b 45 08             	mov    0x8(%ebp),%eax
8010422a:	8b 00                	mov    (%eax),%eax
8010422c:	85 c0                	test   %eax,%eax
8010422e:	0f 84 cb 00 00 00    	je     801042ff <pipealloc+0x104>
80104234:	e8 9c ce ff ff       	call   801010d5 <filealloc>
80104239:	89 c2                	mov    %eax,%edx
8010423b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010423e:	89 10                	mov    %edx,(%eax)
80104240:	8b 45 0c             	mov    0xc(%ebp),%eax
80104243:	8b 00                	mov    (%eax),%eax
80104245:	85 c0                	test   %eax,%eax
80104247:	0f 84 b2 00 00 00    	je     801042ff <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010424d:	e8 ce eb ff ff       	call   80102e20 <kalloc>
80104252:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104259:	0f 84 9f 00 00 00    	je     801042fe <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
8010425f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104262:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104269:	00 00 00 
  p->writeopen = 1;
8010426c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426f:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104276:	00 00 00 
  p->nwrite = 0;
80104279:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427c:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104283:	00 00 00 
  p->nread = 0;
80104286:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104289:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104290:	00 00 00 
  initlock(&p->lock, "pipe");
80104293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104296:	83 ec 08             	sub    $0x8,%esp
80104299:	68 e0 9a 10 80       	push   $0x80109ae0
8010429e:	50                   	push   %eax
8010429f:	e8 8e 1b 00 00       	call   80105e32 <initlock>
801042a4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801042a7:	8b 45 08             	mov    0x8(%ebp),%eax
801042aa:	8b 00                	mov    (%eax),%eax
801042ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801042b2:	8b 45 08             	mov    0x8(%ebp),%eax
801042b5:	8b 00                	mov    (%eax),%eax
801042b7:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801042bb:	8b 45 08             	mov    0x8(%ebp),%eax
801042be:	8b 00                	mov    (%eax),%eax
801042c0:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801042c4:	8b 45 08             	mov    0x8(%ebp),%eax
801042c7:	8b 00                	mov    (%eax),%eax
801042c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042cc:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801042cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801042d2:	8b 00                	mov    (%eax),%eax
801042d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801042da:	8b 45 0c             	mov    0xc(%ebp),%eax
801042dd:	8b 00                	mov    (%eax),%eax
801042df:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801042e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801042e6:	8b 00                	mov    (%eax),%eax
801042e8:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801042ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ef:	8b 00                	mov    (%eax),%eax
801042f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042f4:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801042f7:	b8 00 00 00 00       	mov    $0x0,%eax
801042fc:	eb 4e                	jmp    8010434c <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801042fe:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
801042ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104303:	74 0e                	je     80104313 <pipealloc+0x118>
    kfree((char*)p);
80104305:	83 ec 0c             	sub    $0xc,%esp
80104308:	ff 75 f4             	pushl  -0xc(%ebp)
8010430b:	e8 73 ea ff ff       	call   80102d83 <kfree>
80104310:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104313:	8b 45 08             	mov    0x8(%ebp),%eax
80104316:	8b 00                	mov    (%eax),%eax
80104318:	85 c0                	test   %eax,%eax
8010431a:	74 11                	je     8010432d <pipealloc+0x132>
    fileclose(*f0);
8010431c:	8b 45 08             	mov    0x8(%ebp),%eax
8010431f:	8b 00                	mov    (%eax),%eax
80104321:	83 ec 0c             	sub    $0xc,%esp
80104324:	50                   	push   %eax
80104325:	e8 69 ce ff ff       	call   80101193 <fileclose>
8010432a:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010432d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104330:	8b 00                	mov    (%eax),%eax
80104332:	85 c0                	test   %eax,%eax
80104334:	74 11                	je     80104347 <pipealloc+0x14c>
    fileclose(*f1);
80104336:	8b 45 0c             	mov    0xc(%ebp),%eax
80104339:	8b 00                	mov    (%eax),%eax
8010433b:	83 ec 0c             	sub    $0xc,%esp
8010433e:	50                   	push   %eax
8010433f:	e8 4f ce ff ff       	call   80101193 <fileclose>
80104344:	83 c4 10             	add    $0x10,%esp
  return -1;
80104347:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010434c:	c9                   	leave  
8010434d:	c3                   	ret    

8010434e <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010434e:	55                   	push   %ebp
8010434f:	89 e5                	mov    %esp,%ebp
80104351:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104354:	8b 45 08             	mov    0x8(%ebp),%eax
80104357:	83 ec 0c             	sub    $0xc,%esp
8010435a:	50                   	push   %eax
8010435b:	e8 f4 1a 00 00       	call   80105e54 <acquire>
80104360:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104363:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104367:	74 23                	je     8010438c <pipeclose+0x3e>
    p->writeopen = 0;
80104369:	8b 45 08             	mov    0x8(%ebp),%eax
8010436c:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104373:	00 00 00 
    wakeup(&p->nread);
80104376:	8b 45 08             	mov    0x8(%ebp),%eax
80104379:	05 34 02 00 00       	add    $0x234,%eax
8010437e:	83 ec 0c             	sub    $0xc,%esp
80104381:	50                   	push   %eax
80104382:	e8 27 0d 00 00       	call   801050ae <wakeup>
80104387:	83 c4 10             	add    $0x10,%esp
8010438a:	eb 21                	jmp    801043ad <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010438c:	8b 45 08             	mov    0x8(%ebp),%eax
8010438f:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104396:	00 00 00 
    wakeup(&p->nwrite);
80104399:	8b 45 08             	mov    0x8(%ebp),%eax
8010439c:	05 38 02 00 00       	add    $0x238,%eax
801043a1:	83 ec 0c             	sub    $0xc,%esp
801043a4:	50                   	push   %eax
801043a5:	e8 04 0d 00 00       	call   801050ae <wakeup>
801043aa:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801043ad:	8b 45 08             	mov    0x8(%ebp),%eax
801043b0:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801043b6:	85 c0                	test   %eax,%eax
801043b8:	75 2c                	jne    801043e6 <pipeclose+0x98>
801043ba:	8b 45 08             	mov    0x8(%ebp),%eax
801043bd:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801043c3:	85 c0                	test   %eax,%eax
801043c5:	75 1f                	jne    801043e6 <pipeclose+0x98>
    release(&p->lock);
801043c7:	8b 45 08             	mov    0x8(%ebp),%eax
801043ca:	83 ec 0c             	sub    $0xc,%esp
801043cd:	50                   	push   %eax
801043ce:	e8 e8 1a 00 00       	call   80105ebb <release>
801043d3:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801043d6:	83 ec 0c             	sub    $0xc,%esp
801043d9:	ff 75 08             	pushl  0x8(%ebp)
801043dc:	e8 a2 e9 ff ff       	call   80102d83 <kfree>
801043e1:	83 c4 10             	add    $0x10,%esp
801043e4:	eb 0f                	jmp    801043f5 <pipeclose+0xa7>
  } else
    release(&p->lock);
801043e6:	8b 45 08             	mov    0x8(%ebp),%eax
801043e9:	83 ec 0c             	sub    $0xc,%esp
801043ec:	50                   	push   %eax
801043ed:	e8 c9 1a 00 00       	call   80105ebb <release>
801043f2:	83 c4 10             	add    $0x10,%esp
}
801043f5:	90                   	nop
801043f6:	c9                   	leave  
801043f7:	c3                   	ret    

801043f8 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801043f8:	55                   	push   %ebp
801043f9:	89 e5                	mov    %esp,%ebp
801043fb:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801043fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104401:	83 ec 0c             	sub    $0xc,%esp
80104404:	50                   	push   %eax
80104405:	e8 4a 1a 00 00       	call   80105e54 <acquire>
8010440a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
8010440d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104414:	e9 ad 00 00 00       	jmp    801044c6 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104419:	8b 45 08             	mov    0x8(%ebp),%eax
8010441c:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104422:	85 c0                	test   %eax,%eax
80104424:	74 0d                	je     80104433 <pipewrite+0x3b>
80104426:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010442c:	8b 40 24             	mov    0x24(%eax),%eax
8010442f:	85 c0                	test   %eax,%eax
80104431:	74 19                	je     8010444c <pipewrite+0x54>
        release(&p->lock);
80104433:	8b 45 08             	mov    0x8(%ebp),%eax
80104436:	83 ec 0c             	sub    $0xc,%esp
80104439:	50                   	push   %eax
8010443a:	e8 7c 1a 00 00       	call   80105ebb <release>
8010443f:	83 c4 10             	add    $0x10,%esp
        return -1;
80104442:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104447:	e9 a8 00 00 00       	jmp    801044f4 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
8010444c:	8b 45 08             	mov    0x8(%ebp),%eax
8010444f:	05 34 02 00 00       	add    $0x234,%eax
80104454:	83 ec 0c             	sub    $0xc,%esp
80104457:	50                   	push   %eax
80104458:	e8 51 0c 00 00       	call   801050ae <wakeup>
8010445d:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104460:	8b 45 08             	mov    0x8(%ebp),%eax
80104463:	8b 55 08             	mov    0x8(%ebp),%edx
80104466:	81 c2 38 02 00 00    	add    $0x238,%edx
8010446c:	83 ec 08             	sub    $0x8,%esp
8010446f:	50                   	push   %eax
80104470:	52                   	push   %edx
80104471:	e8 51 0b 00 00       	call   80104fc7 <sleep>
80104476:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104479:	8b 45 08             	mov    0x8(%ebp),%eax
8010447c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104482:	8b 45 08             	mov    0x8(%ebp),%eax
80104485:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010448b:	05 00 02 00 00       	add    $0x200,%eax
80104490:	39 c2                	cmp    %eax,%edx
80104492:	74 85                	je     80104419 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104494:	8b 45 08             	mov    0x8(%ebp),%eax
80104497:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010449d:	8d 48 01             	lea    0x1(%eax),%ecx
801044a0:	8b 55 08             	mov    0x8(%ebp),%edx
801044a3:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801044a9:	25 ff 01 00 00       	and    $0x1ff,%eax
801044ae:	89 c1                	mov    %eax,%ecx
801044b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801044b6:	01 d0                	add    %edx,%eax
801044b8:	0f b6 10             	movzbl (%eax),%edx
801044bb:	8b 45 08             	mov    0x8(%ebp),%eax
801044be:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801044c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c9:	3b 45 10             	cmp    0x10(%ebp),%eax
801044cc:	7c ab                	jl     80104479 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801044ce:	8b 45 08             	mov    0x8(%ebp),%eax
801044d1:	05 34 02 00 00       	add    $0x234,%eax
801044d6:	83 ec 0c             	sub    $0xc,%esp
801044d9:	50                   	push   %eax
801044da:	e8 cf 0b 00 00       	call   801050ae <wakeup>
801044df:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044e2:	8b 45 08             	mov    0x8(%ebp),%eax
801044e5:	83 ec 0c             	sub    $0xc,%esp
801044e8:	50                   	push   %eax
801044e9:	e8 cd 19 00 00       	call   80105ebb <release>
801044ee:	83 c4 10             	add    $0x10,%esp
  return n;
801044f1:	8b 45 10             	mov    0x10(%ebp),%eax
}
801044f4:	c9                   	leave  
801044f5:	c3                   	ret    

801044f6 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801044f6:	55                   	push   %ebp
801044f7:	89 e5                	mov    %esp,%ebp
801044f9:	53                   	push   %ebx
801044fa:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801044fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104500:	83 ec 0c             	sub    $0xc,%esp
80104503:	50                   	push   %eax
80104504:	e8 4b 19 00 00       	call   80105e54 <acquire>
80104509:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010450c:	eb 3f                	jmp    8010454d <piperead+0x57>
    if(proc->killed){
8010450e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104514:	8b 40 24             	mov    0x24(%eax),%eax
80104517:	85 c0                	test   %eax,%eax
80104519:	74 19                	je     80104534 <piperead+0x3e>
      release(&p->lock);
8010451b:	8b 45 08             	mov    0x8(%ebp),%eax
8010451e:	83 ec 0c             	sub    $0xc,%esp
80104521:	50                   	push   %eax
80104522:	e8 94 19 00 00       	call   80105ebb <release>
80104527:	83 c4 10             	add    $0x10,%esp
      return -1;
8010452a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010452f:	e9 bf 00 00 00       	jmp    801045f3 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104534:	8b 45 08             	mov    0x8(%ebp),%eax
80104537:	8b 55 08             	mov    0x8(%ebp),%edx
8010453a:	81 c2 34 02 00 00    	add    $0x234,%edx
80104540:	83 ec 08             	sub    $0x8,%esp
80104543:	50                   	push   %eax
80104544:	52                   	push   %edx
80104545:	e8 7d 0a 00 00       	call   80104fc7 <sleep>
8010454a:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010454d:	8b 45 08             	mov    0x8(%ebp),%eax
80104550:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104556:	8b 45 08             	mov    0x8(%ebp),%eax
80104559:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010455f:	39 c2                	cmp    %eax,%edx
80104561:	75 0d                	jne    80104570 <piperead+0x7a>
80104563:	8b 45 08             	mov    0x8(%ebp),%eax
80104566:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010456c:	85 c0                	test   %eax,%eax
8010456e:	75 9e                	jne    8010450e <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104570:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104577:	eb 49                	jmp    801045c2 <piperead+0xcc>
    if(p->nread == p->nwrite)
80104579:	8b 45 08             	mov    0x8(%ebp),%eax
8010457c:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104582:	8b 45 08             	mov    0x8(%ebp),%eax
80104585:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010458b:	39 c2                	cmp    %eax,%edx
8010458d:	74 3d                	je     801045cc <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010458f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104592:	8b 45 0c             	mov    0xc(%ebp),%eax
80104595:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104598:	8b 45 08             	mov    0x8(%ebp),%eax
8010459b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801045a1:	8d 48 01             	lea    0x1(%eax),%ecx
801045a4:	8b 55 08             	mov    0x8(%ebp),%edx
801045a7:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801045ad:	25 ff 01 00 00       	and    $0x1ff,%eax
801045b2:	89 c2                	mov    %eax,%edx
801045b4:	8b 45 08             	mov    0x8(%ebp),%eax
801045b7:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801045bc:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801045be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801045c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c5:	3b 45 10             	cmp    0x10(%ebp),%eax
801045c8:	7c af                	jl     80104579 <piperead+0x83>
801045ca:	eb 01                	jmp    801045cd <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801045cc:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801045cd:	8b 45 08             	mov    0x8(%ebp),%eax
801045d0:	05 38 02 00 00       	add    $0x238,%eax
801045d5:	83 ec 0c             	sub    $0xc,%esp
801045d8:	50                   	push   %eax
801045d9:	e8 d0 0a 00 00       	call   801050ae <wakeup>
801045de:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801045e1:	8b 45 08             	mov    0x8(%ebp),%eax
801045e4:	83 ec 0c             	sub    $0xc,%esp
801045e7:	50                   	push   %eax
801045e8:	e8 ce 18 00 00       	call   80105ebb <release>
801045ed:	83 c4 10             	add    $0x10,%esp
  return i;
801045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801045f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f6:	c9                   	leave  
801045f7:	c3                   	ret    

801045f8 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
801045f8:	55                   	push   %ebp
801045f9:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
801045fb:	f4                   	hlt    
}
801045fc:	90                   	nop
801045fd:	5d                   	pop    %ebp
801045fe:	c3                   	ret    

801045ff <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801045ff:	55                   	push   %ebp
80104600:	89 e5                	mov    %esp,%ebp
80104602:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104605:	9c                   	pushf  
80104606:	58                   	pop    %eax
80104607:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010460a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010460d:	c9                   	leave  
8010460e:	c3                   	ret    

8010460f <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010460f:	55                   	push   %ebp
80104610:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104612:	fb                   	sti    
}
80104613:	90                   	nop
80104614:	5d                   	pop    %ebp
80104615:	c3                   	ret    

80104616 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104616:	55                   	push   %ebp
80104617:	89 e5                	mov    %esp,%ebp
80104619:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010461c:	83 ec 08             	sub    $0x8,%esp
8010461f:	68 e8 9a 10 80       	push   $0x80109ae8
80104624:	68 80 49 11 80       	push   $0x80114980
80104629:	e8 04 18 00 00       	call   80105e32 <initlock>
8010462e:	83 c4 10             	add    $0x10,%esp
}
80104631:	90                   	nop
80104632:	c9                   	leave  
80104633:	c3                   	ret    

80104634 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	83 ec 18             	sub    $0x18,%esp
    goto found; // using goto similar to the original code (I think this is allowed?)   

  release(&ptable.lock);
  // END: Added for Project 3: List Management
  #else
  acquire(&ptable.lock);
8010463a:	83 ec 0c             	sub    $0xc,%esp
8010463d:	68 80 49 11 80       	push   $0x80114980
80104642:	e8 0d 18 00 00       	call   80105e54 <acquire>
80104647:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010464a:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80104651:	eb 11                	jmp    80104664 <allocproc+0x30>
    if(p->state == UNUSED)
80104653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104656:	8b 40 0c             	mov    0xc(%eax),%eax
80104659:	85 c0                	test   %eax,%eax
8010465b:	74 2a                	je     80104687 <allocproc+0x53>

  release(&ptable.lock);
  // END: Added for Project 3: List Management
  #else
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010465d:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104664:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
8010466b:	72 e6                	jb     80104653 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010466d:	83 ec 0c             	sub    $0xc,%esp
80104670:	68 80 49 11 80       	push   $0x80114980
80104675:	e8 41 18 00 00       	call   80105ebb <release>
8010467a:	83 c4 10             	add    $0x10,%esp
  #endif

  return 0;
8010467d:	b8 00 00 00 00       	mov    $0x0,%eax
80104682:	e9 f9 00 00 00       	jmp    80104780 <allocproc+0x14c>
  // END: Added for Project 3: List Management
  #else
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104687:	90                   	nop
  #endif

  return 0;

found:
  p->state = EMBRYO;
80104688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468b:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  #ifdef CS333_P3P4
  // add new proc to embryo list
  addToStateListHead(&ptable.pLists.embryo, EMBRYO, p); // Added for Project 3: List Management
  #endif  

  p->pid = nextpid++;
80104692:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104697:	8d 50 01             	lea    0x1(%eax),%edx
8010469a:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
801046a0:	89 c2                	mov    %eax,%edx
801046a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a5:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	68 80 49 11 80       	push   $0x80114980
801046b0:	e8 06 18 00 00       	call   80105ebb <release>
801046b5:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801046b8:	e8 63 e7 ff ff       	call   80102e20 <kalloc>
801046bd:	89 c2                	mov    %eax,%edx
801046bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c2:	89 50 08             	mov    %edx,0x8(%eax)
801046c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c8:	8b 40 08             	mov    0x8(%eax),%eax
801046cb:	85 c0                	test   %eax,%eax
801046cd:	75 14                	jne    801046e3 <allocproc+0xaf>
    addToStateListHead(&ptable.pLists.free, UNUSED, p);

    release(&ptable.lock);
    // END: Added for Project 3: List Management
    #else
    p->state = UNUSED;
801046cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #endif

    return 0;
801046d9:	b8 00 00 00 00       	mov    $0x0,%eax
801046de:	e9 9d 00 00 00       	jmp    80104780 <allocproc+0x14c>
  }
  sp = p->kstack + KSTACKSIZE;
801046e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e6:	8b 40 08             	mov    0x8(%eax),%eax
801046e9:	05 00 10 00 00       	add    $0x1000,%eax
801046ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801046f1:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801046f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046fb:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801046fe:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104702:	ba db 78 10 80       	mov    $0x801078db,%edx
80104707:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010470a:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010470c:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104710:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104713:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104716:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104719:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010471f:	83 ec 04             	sub    $0x4,%esp
80104722:	6a 14                	push   $0x14
80104724:	6a 00                	push   $0x0
80104726:	50                   	push   %eax
80104727:	e8 8b 19 00 00       	call   801060b7 <memset>
8010472c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104732:	8b 40 1c             	mov    0x1c(%eax),%eax
80104735:	ba 81 4f 10 80       	mov    $0x80104f81,%edx
8010473a:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // Init value.  Added for Project 1: CTL-P
8010473d:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80104743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104746:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total = 0; // Init value. Added for Project 2: Process Execution Time
80104749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474c:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104753:	00 00 00 
  p->cpu_ticks_in = 0;    // Init value. Added for Project 2: Process Execution Time
80104756:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104759:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104760:	00 00 00 
  p->priority = 0; 	  // Init to highest priority. Added for Project 4: Periodic Priority Adjustment
80104763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104766:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
8010476d:	00 00 00 
  p->budget = DEFAULT_BUDGET; // Init to default budget. Added for Project 4: Periodic Priority Adjustment
80104770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104773:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
8010477a:	01 00 00 

  return p;
8010477d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104780:	c9                   	leave  
80104781:	c3                   	ret    

80104782 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104782:	55                   	push   %ebp
80104783:	89 e5                	mov    %esp,%ebp
80104785:	83 ec 18             	sub    $0x18,%esp
    addToStateListHead(&ptable.pLists.free, UNUSED, &ptable.proc[i]);
    
  release(&ptable.lock);
  #endif
  // END: Added for Project 3: Initializing the Lists
  p = allocproc();
80104788:	e8 a7 fe ff ff       	call   80104634 <allocproc>
8010478d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104793:	a3 68 d6 10 80       	mov    %eax,0x8010d668
  if((p->pgdir = setupkvm()) == 0)
80104798:	e8 dd 47 00 00       	call   80108f7a <setupkvm>
8010479d:	89 c2                	mov    %eax,%edx
8010479f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a2:	89 50 04             	mov    %edx,0x4(%eax)
801047a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a8:	8b 40 04             	mov    0x4(%eax),%eax
801047ab:	85 c0                	test   %eax,%eax
801047ad:	75 0d                	jne    801047bc <userinit+0x3a>
    panic("userinit: out of memory?");
801047af:	83 ec 0c             	sub    $0xc,%esp
801047b2:	68 ef 9a 10 80       	push   $0x80109aef
801047b7:	e8 aa bd ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047bc:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c4:	8b 40 04             	mov    0x4(%eax),%eax
801047c7:	83 ec 04             	sub    $0x4,%esp
801047ca:	52                   	push   %edx
801047cb:	68 00 d5 10 80       	push   $0x8010d500
801047d0:	50                   	push   %eax
801047d1:	e8 fe 49 00 00       	call   801091d4 <inituvm>
801047d6:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801047d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047dc:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801047e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e5:	8b 40 18             	mov    0x18(%eax),%eax
801047e8:	83 ec 04             	sub    $0x4,%esp
801047eb:	6a 4c                	push   $0x4c
801047ed:	6a 00                	push   $0x0
801047ef:	50                   	push   %eax
801047f0:	e8 c2 18 00 00       	call   801060b7 <memset>
801047f5:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801047f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047fb:	8b 40 18             	mov    0x18(%eax),%eax
801047fe:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104807:	8b 40 18             	mov    0x18(%eax),%eax
8010480a:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104810:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104813:	8b 40 18             	mov    0x18(%eax),%eax
80104816:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104819:	8b 52 18             	mov    0x18(%edx),%edx
8010481c:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104820:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104827:	8b 40 18             	mov    0x18(%eax),%eax
8010482a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010482d:	8b 52 18             	mov    0x18(%edx),%edx
80104830:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104834:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483b:	8b 40 18             	mov    0x18(%eax),%eax
8010483e:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104848:	8b 40 18             	mov    0x18(%eax),%eax
8010484b:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104855:	8b 40 18             	mov    0x18(%eax),%eax
80104858:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  p->uid = DEFAULT_UID; // Added for Project 2: UIDs and GIDs and PPIDs
8010485f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104862:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104869:	00 00 00 
  p->gid = DEFAULT_GID; // Added for Project 2: UIDs and GIDs and PPIDs
8010486c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010486f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104876:	00 00 00 


  safestrcpy(p->name, "initcode", sizeof(p->name));
80104879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487c:	83 c0 6c             	add    $0x6c,%eax
8010487f:	83 ec 04             	sub    $0x4,%esp
80104882:	6a 10                	push   $0x10
80104884:	68 08 9b 10 80       	push   $0x80109b08
80104889:	50                   	push   %eax
8010488a:	e8 2b 1a 00 00       	call   801062ba <safestrcpy>
8010488f:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104892:	83 ec 0c             	sub    $0xc,%esp
80104895:	68 11 9b 10 80       	push   $0x80109b11
8010489a:	e8 43 de ff ff       	call   801026e2 <namei>
8010489f:	83 c4 10             	add    $0x10,%esp
801048a2:	89 c2                	mov    %eax,%edx
801048a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a7:	89 50 68             	mov    %edx,0x68(%eax)
  p->state = RUNNABLE;
  addToStateListHead(&ptable.pLists.ready[0], RUNNABLE, p); // added to head of ready since nothing else is there. Modified for Project 4: Periodic Priority Adjustment

  release(&ptable.lock);
  #else
  p->state = RUNNABLE;
801048aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #endif
  // END: Added for Project 3: Initializing the Lists
}
801048b4:	90                   	nop
801048b5:	c9                   	leave  
801048b6:	c3                   	ret    

801048b7 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801048b7:	55                   	push   %ebp
801048b8:	89 e5                	mov    %esp,%ebp
801048ba:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801048bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c3:	8b 00                	mov    (%eax),%eax
801048c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801048c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048cc:	7e 31                	jle    801048ff <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801048ce:	8b 55 08             	mov    0x8(%ebp),%edx
801048d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d4:	01 c2                	add    %eax,%edx
801048d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048dc:	8b 40 04             	mov    0x4(%eax),%eax
801048df:	83 ec 04             	sub    $0x4,%esp
801048e2:	52                   	push   %edx
801048e3:	ff 75 f4             	pushl  -0xc(%ebp)
801048e6:	50                   	push   %eax
801048e7:	e8 35 4a 00 00       	call   80109321 <allocuvm>
801048ec:	83 c4 10             	add    $0x10,%esp
801048ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048f6:	75 3e                	jne    80104936 <growproc+0x7f>
      return -1;
801048f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048fd:	eb 59                	jmp    80104958 <growproc+0xa1>
  } else if(n < 0){
801048ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104903:	79 31                	jns    80104936 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104905:	8b 55 08             	mov    0x8(%ebp),%edx
80104908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490b:	01 c2                	add    %eax,%edx
8010490d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104913:	8b 40 04             	mov    0x4(%eax),%eax
80104916:	83 ec 04             	sub    $0x4,%esp
80104919:	52                   	push   %edx
8010491a:	ff 75 f4             	pushl  -0xc(%ebp)
8010491d:	50                   	push   %eax
8010491e:	e8 c7 4a 00 00       	call   801093ea <deallocuvm>
80104923:	83 c4 10             	add    $0x10,%esp
80104926:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104929:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010492d:	75 07                	jne    80104936 <growproc+0x7f>
      return -1;
8010492f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104934:	eb 22                	jmp    80104958 <growproc+0xa1>
  }
  proc->sz = sz;
80104936:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010493f:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104941:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104947:	83 ec 0c             	sub    $0xc,%esp
8010494a:	50                   	push   %eax
8010494b:	e8 11 47 00 00       	call   80109061 <switchuvm>
80104950:	83 c4 10             	add    $0x10,%esp
  return 0;
80104953:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104958:	c9                   	leave  
80104959:	c3                   	ret    

8010495a <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010495a:	55                   	push   %ebp
8010495b:	89 e5                	mov    %esp,%ebp
8010495d:	57                   	push   %edi
8010495e:	56                   	push   %esi
8010495f:	53                   	push   %ebx
80104960:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104963:	e8 cc fc ff ff       	call   80104634 <allocproc>
80104968:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010496b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010496f:	75 0a                	jne    8010497b <fork+0x21>
    return -1;
80104971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104976:	e9 92 01 00 00       	jmp    80104b0d <fork+0x1b3>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
8010497b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104981:	8b 10                	mov    (%eax),%edx
80104983:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104989:	8b 40 04             	mov    0x4(%eax),%eax
8010498c:	83 ec 08             	sub    $0x8,%esp
8010498f:	52                   	push   %edx
80104990:	50                   	push   %eax
80104991:	e8 f2 4b 00 00       	call   80109588 <copyuvm>
80104996:	83 c4 10             	add    $0x10,%esp
80104999:	89 c2                	mov    %eax,%edx
8010499b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010499e:	89 50 04             	mov    %edx,0x4(%eax)
801049a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049a4:	8b 40 04             	mov    0x4(%eax),%eax
801049a7:	85 c0                	test   %eax,%eax
801049a9:	75 30                	jne    801049db <fork+0x81>
    kfree(np->kstack);
801049ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ae:	8b 40 08             	mov    0x8(%eax),%eax
801049b1:	83 ec 0c             	sub    $0xc,%esp
801049b4:	50                   	push   %eax
801049b5:	e8 c9 e3 ff ff       	call   80102d83 <kfree>
801049ba:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801049bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
    addToStateListHead(&ptable.pLists.free, UNUSED, np);

    release(&ptable.lock);
    #else
    np->state = UNUSED;
801049c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #endif
    // END: Added for Project 3: List Management
    
    return -1;
801049d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049d6:	e9 32 01 00 00       	jmp    80104b0d <fork+0x1b3>
  }
  np->sz = proc->sz;
801049db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e1:	8b 10                	mov    (%eax),%edx
801049e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049e6:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801049e8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049f2:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801049f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049f8:	8b 50 18             	mov    0x18(%eax),%edx
801049fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a01:	8b 40 18             	mov    0x18(%eax),%eax
80104a04:	89 c3                	mov    %eax,%ebx
80104a06:	b8 13 00 00 00       	mov    $0x13,%eax
80104a0b:	89 d7                	mov    %edx,%edi
80104a0d:	89 de                	mov    %ebx,%esi
80104a0f:	89 c1                	mov    %eax,%ecx
80104a11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->uid = proc->uid; // Added for Project 2: UIDs and GIDs and PPIDs
80104a13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a19:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104a1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a22:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid; // Added for Project 2: UIDs and GIDs and PPIDs
80104a28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a2e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a37:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a40:	8b 40 18             	mov    0x18(%eax),%eax
80104a43:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104a4a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104a51:	eb 43                	jmp    80104a96 <fork+0x13c>
    if(proc->ofile[i])
80104a53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a5c:	83 c2 08             	add    $0x8,%edx
80104a5f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a63:	85 c0                	test   %eax,%eax
80104a65:	74 2b                	je     80104a92 <fork+0x138>
      np->ofile[i] = filedup(proc->ofile[i]);
80104a67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a70:	83 c2 08             	add    $0x8,%edx
80104a73:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a77:	83 ec 0c             	sub    $0xc,%esp
80104a7a:	50                   	push   %eax
80104a7b:	e8 c2 c6 ff ff       	call   80101142 <filedup>
80104a80:	83 c4 10             	add    $0x10,%esp
80104a83:	89 c1                	mov    %eax,%ecx
80104a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a8b:	83 c2 08             	add    $0x8,%edx
80104a8e:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np->gid = proc->gid; // Added for Project 2: UIDs and GIDs and PPIDs

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104a92:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104a96:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104a9a:	7e b7                	jle    80104a53 <fork+0xf9>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104a9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa2:	8b 40 68             	mov    0x68(%eax),%eax
80104aa5:	83 ec 0c             	sub    $0xc,%esp
80104aa8:	50                   	push   %eax
80104aa9:	e8 ec cf ff ff       	call   80101a9a <idup>
80104aae:	83 c4 10             	add    $0x10,%esp
80104ab1:	89 c2                	mov    %eax,%edx
80104ab3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ab6:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104ab9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104abf:	8d 50 6c             	lea    0x6c(%eax),%edx
80104ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ac5:	83 c0 6c             	add    $0x6c,%eax
80104ac8:	83 ec 04             	sub    $0x4,%esp
80104acb:	6a 10                	push   $0x10
80104acd:	52                   	push   %edx
80104ace:	50                   	push   %eax
80104acf:	e8 e6 17 00 00       	call   801062ba <safestrcpy>
80104ad4:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104ad7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ada:	8b 40 10             	mov    0x10(%eax),%eax
80104add:	89 45 dc             	mov    %eax,-0x24(%ebp)
  addToStateListTail(&ptable.pLists.ready[0], RUNNABLE, np); // Modified for Project 4: Periodic Priority Adjustment

  release(&ptable.lock);
  #else
  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104ae0:	83 ec 0c             	sub    $0xc,%esp
80104ae3:	68 80 49 11 80       	push   $0x80114980
80104ae8:	e8 67 13 00 00       	call   80105e54 <acquire>
80104aed:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104af0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104af3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104afa:	83 ec 0c             	sub    $0xc,%esp
80104afd:	68 80 49 11 80       	push   $0x80114980
80104b02:	e8 b4 13 00 00       	call   80105ebb <release>
80104b07:	83 c4 10             	add    $0x10,%esp
  #endif
  // END: Added for Project 3: List Management
  
  return pid;
80104b0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104b0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b10:	5b                   	pop    %ebx
80104b11:	5e                   	pop    %esi
80104b12:	5f                   	pop    %edi
80104b13:	5d                   	pop    %ebp
80104b14:	c3                   	ret    

80104b15 <exit>:
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
80104b15:	55                   	push   %ebp
80104b16:	89 e5                	mov    %esp,%ebp
80104b18:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104b1b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b22:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104b27:	39 c2                	cmp    %eax,%edx
80104b29:	75 0d                	jne    80104b38 <exit+0x23>
    panic("init exiting");
80104b2b:	83 ec 0c             	sub    $0xc,%esp
80104b2e:	68 13 9b 10 80       	push   $0x80109b13
80104b33:	e8 2e ba ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104b38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104b3f:	eb 48                	jmp    80104b89 <exit+0x74>
    if(proc->ofile[fd]){
80104b41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b47:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b4a:	83 c2 08             	add    $0x8,%edx
80104b4d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b51:	85 c0                	test   %eax,%eax
80104b53:	74 30                	je     80104b85 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104b55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b5e:	83 c2 08             	add    $0x8,%edx
80104b61:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b65:	83 ec 0c             	sub    $0xc,%esp
80104b68:	50                   	push   %eax
80104b69:	e8 25 c6 ff ff       	call   80101193 <fileclose>
80104b6e:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104b71:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b77:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b7a:	83 c2 08             	add    $0x8,%edx
80104b7d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104b84:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104b85:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104b89:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104b8d:	7e b2                	jle    80104b41 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104b8f:	e8 73 eb ff ff       	call   80103707 <begin_op>
  iput(proc->cwd);
80104b94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b9a:	8b 40 68             	mov    0x68(%eax),%eax
80104b9d:	83 ec 0c             	sub    $0xc,%esp
80104ba0:	50                   	push   %eax
80104ba1:	e8 26 d1 ff ff       	call   80101ccc <iput>
80104ba6:	83 c4 10             	add    $0x10,%esp
  end_op();
80104ba9:	e8 e5 eb ff ff       	call   80103793 <end_op>
  proc->cwd = 0;
80104bae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb4:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104bbb:	83 ec 0c             	sub    $0xc,%esp
80104bbe:	68 80 49 11 80       	push   $0x80114980
80104bc3:	e8 8c 12 00 00       	call   80105e54 <acquire>
80104bc8:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104bcb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd1:	8b 40 14             	mov    0x14(%eax),%eax
80104bd4:	83 ec 0c             	sub    $0xc,%esp
80104bd7:	50                   	push   %eax
80104bd8:	e8 8f 04 00 00       	call   8010506c <wakeup1>
80104bdd:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104be0:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80104be7:	eb 3f                	jmp    80104c28 <exit+0x113>
    if(p->parent == proc){
80104be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bec:	8b 50 14             	mov    0x14(%eax),%edx
80104bef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf5:	39 c2                	cmp    %eax,%edx
80104bf7:	75 28                	jne    80104c21 <exit+0x10c>
      p->parent = initproc;
80104bf9:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c02:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c08:	8b 40 0c             	mov    0xc(%eax),%eax
80104c0b:	83 f8 05             	cmp    $0x5,%eax
80104c0e:	75 11                	jne    80104c21 <exit+0x10c>
        wakeup1(initproc);
80104c10:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104c15:	83 ec 0c             	sub    $0xc,%esp
80104c18:	50                   	push   %eax
80104c19:	e8 4e 04 00 00       	call   8010506c <wakeup1>
80104c1e:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c21:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104c28:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80104c2f:	72 b8                	jb     80104be9 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104c31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c37:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104c3e:	e8 11 02 00 00       	call   80104e54 <sched>
  panic("zombie exit");
80104c43:	83 ec 0c             	sub    $0xc,%esp
80104c46:	68 20 9b 10 80       	push   $0x80109b20
80104c4b:	e8 16 b9 ff ff       	call   80100566 <panic>

80104c50 <wait>:
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104c56:	83 ec 0c             	sub    $0xc,%esp
80104c59:	68 80 49 11 80       	push   $0x80114980
80104c5e:	e8 f1 11 00 00       	call   80105e54 <acquire>
80104c63:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104c66:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c6d:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80104c74:	e9 a9 00 00 00       	jmp    80104d22 <wait+0xd2>
      if(p->parent != proc)
80104c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c7c:	8b 50 14             	mov    0x14(%eax),%edx
80104c7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c85:	39 c2                	cmp    %eax,%edx
80104c87:	0f 85 8d 00 00 00    	jne    80104d1a <wait+0xca>
        continue;
      havekids = 1;
80104c8d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c97:	8b 40 0c             	mov    0xc(%eax),%eax
80104c9a:	83 f8 05             	cmp    $0x5,%eax
80104c9d:	75 7c                	jne    80104d1b <wait+0xcb>
        // Found one.
        pid = p->pid;
80104c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ca2:	8b 40 10             	mov    0x10(%eax),%eax
80104ca5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cab:	8b 40 08             	mov    0x8(%eax),%eax
80104cae:	83 ec 0c             	sub    $0xc,%esp
80104cb1:	50                   	push   %eax
80104cb2:	e8 cc e0 ff ff       	call   80102d83 <kfree>
80104cb7:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cbd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc7:	8b 40 04             	mov    0x4(%eax),%eax
80104cca:	83 ec 0c             	sub    $0xc,%esp
80104ccd:	50                   	push   %eax
80104cce:	e8 d4 47 00 00       	call   801094a7 <freevm>
80104cd3:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ced:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf7:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cfe:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104d05:	83 ec 0c             	sub    $0xc,%esp
80104d08:	68 80 49 11 80       	push   $0x80114980
80104d0d:	e8 a9 11 00 00       	call   80105ebb <release>
80104d12:	83 c4 10             	add    $0x10,%esp
        return pid;
80104d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d18:	eb 5b                	jmp    80104d75 <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104d1a:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d1b:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104d22:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80104d29:	0f 82 4a ff ff ff    	jb     80104c79 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104d2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104d33:	74 0d                	je     80104d42 <wait+0xf2>
80104d35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d3b:	8b 40 24             	mov    0x24(%eax),%eax
80104d3e:	85 c0                	test   %eax,%eax
80104d40:	74 17                	je     80104d59 <wait+0x109>
      release(&ptable.lock);
80104d42:	83 ec 0c             	sub    $0xc,%esp
80104d45:	68 80 49 11 80       	push   $0x80114980
80104d4a:	e8 6c 11 00 00       	call   80105ebb <release>
80104d4f:	83 c4 10             	add    $0x10,%esp
      return -1;
80104d52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d57:	eb 1c                	jmp    80104d75 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104d59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d5f:	83 ec 08             	sub    $0x8,%esp
80104d62:	68 80 49 11 80       	push   $0x80114980
80104d67:	50                   	push   %eax
80104d68:	e8 5a 02 00 00       	call   80104fc7 <sleep>
80104d6d:	83 c4 10             	add    $0x10,%esp
  }
80104d70:	e9 f1 fe ff ff       	jmp    80104c66 <wait+0x16>
}
80104d75:	c9                   	leave  
80104d76:	c3                   	ret    

80104d77 <scheduler>:
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
80104d77:	55                   	push   %ebp
80104d78:	89 e5                	mov    %esp,%ebp
80104d7a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104d7d:	e8 8d f8 ff ff       	call   8010460f <sti>

    idle = 1;  // assume idle unless we schedule a process
80104d82:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104d89:	83 ec 0c             	sub    $0xc,%esp
80104d8c:	68 80 49 11 80       	push   $0x80114980
80104d91:	e8 be 10 00 00       	call   80105e54 <acquire>
80104d96:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d99:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80104da0:	eb 7c                	jmp    80104e1e <scheduler+0xa7>
      if(p->state != RUNNABLE)
80104da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da5:	8b 40 0c             	mov    0xc(%eax),%eax
80104da8:	83 f8 03             	cmp    $0x3,%eax
80104dab:	75 69                	jne    80104e16 <scheduler+0x9f>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
80104dad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      proc = p;
80104db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db7:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104dbd:	83 ec 0c             	sub    $0xc,%esp
80104dc0:	ff 75 f4             	pushl  -0xc(%ebp)
80104dc3:	e8 99 42 00 00       	call   80109061 <switchuvm>
80104dc8:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dce:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      p->cpu_ticks_in = ticks; // set tick that proc enters CPU. Added for Project 2: Process Execution Time
80104dd5:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80104ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dde:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)

      swtch(&cpu->scheduler, proc->context);
80104de4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dea:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ded:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104df4:	83 c2 04             	add    $0x4,%edx
80104df7:	83 ec 08             	sub    $0x8,%esp
80104dfa:	50                   	push   %eax
80104dfb:	52                   	push   %edx
80104dfc:	e8 2a 15 00 00       	call   8010632b <swtch>
80104e01:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104e04:	e8 3b 42 00 00       	call   80109044 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104e09:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104e10:	00 00 00 00 
80104e14:	eb 01                	jmp    80104e17 <scheduler+0xa0>
    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104e16:	90                   	nop
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e17:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104e1e:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80104e25:	0f 82 77 ff ff ff    	jb     80104da2 <scheduler+0x2b>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104e2b:	83 ec 0c             	sub    $0xc,%esp
80104e2e:	68 80 49 11 80       	push   $0x80114980
80104e33:	e8 83 10 00 00       	call   80105ebb <release>
80104e38:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
80104e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104e3f:	0f 84 38 ff ff ff    	je     80104d7d <scheduler+0x6>
      sti();
80104e45:	e8 c5 f7 ff ff       	call   8010460f <sti>
      hlt();
80104e4a:	e8 a9 f7 ff ff       	call   801045f8 <hlt>
    }
  }
80104e4f:	e9 29 ff ff ff       	jmp    80104d7d <scheduler+0x6>

80104e54 <sched>:
// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	53                   	push   %ebx
80104e58:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80104e5b:	83 ec 0c             	sub    $0xc,%esp
80104e5e:	68 80 49 11 80       	push   $0x80114980
80104e63:	e8 1f 11 00 00       	call   80105f87 <holding>
80104e68:	83 c4 10             	add    $0x10,%esp
80104e6b:	85 c0                	test   %eax,%eax
80104e6d:	75 0d                	jne    80104e7c <sched+0x28>
    panic("sched ptable.lock");
80104e6f:	83 ec 0c             	sub    $0xc,%esp
80104e72:	68 2c 9b 10 80       	push   $0x80109b2c
80104e77:	e8 ea b6 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104e7c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e82:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e88:	83 f8 01             	cmp    $0x1,%eax
80104e8b:	74 0d                	je     80104e9a <sched+0x46>
    panic("sched locks");
80104e8d:	83 ec 0c             	sub    $0xc,%esp
80104e90:	68 3e 9b 10 80       	push   $0x80109b3e
80104e95:	e8 cc b6 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104e9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ea0:	8b 40 0c             	mov    0xc(%eax),%eax
80104ea3:	83 f8 04             	cmp    $0x4,%eax
80104ea6:	75 0d                	jne    80104eb5 <sched+0x61>
    panic("sched running");
80104ea8:	83 ec 0c             	sub    $0xc,%esp
80104eab:	68 4a 9b 10 80       	push   $0x80109b4a
80104eb0:	e8 b1 b6 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104eb5:	e8 45 f7 ff ff       	call   801045ff <readeflags>
80104eba:	25 00 02 00 00       	and    $0x200,%eax
80104ebf:	85 c0                	test   %eax,%eax
80104ec1:	74 0d                	je     80104ed0 <sched+0x7c>
    panic("sched interruptible");
80104ec3:	83 ec 0c             	sub    $0xc,%esp
80104ec6:	68 58 9b 10 80       	push   $0x80109b58
80104ecb:	e8 96 b6 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104ed0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ed6:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104edc:	89 45 f4             	mov    %eax,-0xc(%ebp)

  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // add time delta to total CPU time. Added for Project 2: Process Execution Time
80104edf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ee5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104eec:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80104ef2:	8b 1d e0 78 11 80    	mov    0x801178e0,%ebx
80104ef8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104eff:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80104f05:	29 d3                	sub    %edx,%ebx
80104f07:	89 da                	mov    %ebx,%edx
80104f09:	01 ca                	add    %ecx,%edx
80104f0b:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)

  swtch(&proc->context, cpu->scheduler);
80104f11:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f17:	8b 40 04             	mov    0x4(%eax),%eax
80104f1a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f21:	83 c2 1c             	add    $0x1c,%edx
80104f24:	83 ec 08             	sub    $0x8,%esp
80104f27:	50                   	push   %eax
80104f28:	52                   	push   %edx
80104f29:	e8 fd 13 00 00       	call   8010632b <swtch>
80104f2e:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104f31:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f3a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104f40:	90                   	nop
80104f41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f44:	c9                   	leave  
80104f45:	c3                   	ret    

80104f46 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104f46:	55                   	push   %ebp
80104f47:	89 e5                	mov    %esp,%ebp
80104f49:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104f4c:	83 ec 0c             	sub    $0xc,%esp
80104f4f:	68 80 49 11 80       	push   $0x80114980
80104f54:	e8 fb 0e 00 00       	call   80105e54 <acquire>
80104f59:	83 c4 10             	add    $0x10,%esp
  // move proc from running to ready 
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
  proc->state = RUNNABLE;
  addToStateListTail(&ptable.pLists.ready[0], RUNNABLE, proc); // Modified for Project 4: Periodic Priority Adjustment
  #else
  proc->state = RUNNABLE;
80104f5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f62:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #endif

  sched();
80104f69:	e8 e6 fe ff ff       	call   80104e54 <sched>
  release(&ptable.lock);
80104f6e:	83 ec 0c             	sub    $0xc,%esp
80104f71:	68 80 49 11 80       	push   $0x80114980
80104f76:	e8 40 0f 00 00       	call   80105ebb <release>
80104f7b:	83 c4 10             	add    $0x10,%esp
}
80104f7e:	90                   	nop
80104f7f:	c9                   	leave  
80104f80:	c3                   	ret    

80104f81 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104f81:	55                   	push   %ebp
80104f82:	89 e5                	mov    %esp,%ebp
80104f84:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104f87:	83 ec 0c             	sub    $0xc,%esp
80104f8a:	68 80 49 11 80       	push   $0x80114980
80104f8f:	e8 27 0f 00 00       	call   80105ebb <release>
80104f94:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104f97:	a1 20 d0 10 80       	mov    0x8010d020,%eax
80104f9c:	85 c0                	test   %eax,%eax
80104f9e:	74 24                	je     80104fc4 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104fa0:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
80104fa7:	00 00 00 
    iinit(ROOTDEV);
80104faa:	83 ec 0c             	sub    $0xc,%esp
80104fad:	6a 01                	push   $0x1
80104faf:	e8 cc c7 ff ff       	call   80101780 <iinit>
80104fb4:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104fb7:	83 ec 0c             	sub    $0xc,%esp
80104fba:	6a 01                	push   $0x1
80104fbc:	e8 28 e5 ff ff       	call   801034e9 <initlog>
80104fc1:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104fc4:	90                   	nop
80104fc5:	c9                   	leave  
80104fc6:	c3                   	ret    

80104fc7 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80104fc7:	55                   	push   %ebp
80104fc8:	89 e5                	mov    %esp,%ebp
80104fca:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104fcd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fd3:	85 c0                	test   %eax,%eax
80104fd5:	75 0d                	jne    80104fe4 <sleep+0x1d>
    panic("sleep");
80104fd7:	83 ec 0c             	sub    $0xc,%esp
80104fda:	68 6c 9b 10 80       	push   $0x80109b6c
80104fdf:	e8 82 b5 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80104fe4:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
80104feb:	74 24                	je     80105011 <sleep+0x4a>
    acquire(&ptable.lock);
80104fed:	83 ec 0c             	sub    $0xc,%esp
80104ff0:	68 80 49 11 80       	push   $0x80114980
80104ff5:	e8 5a 0e 00 00       	call   80105e54 <acquire>
80104ffa:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80104ffd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105001:	74 0e                	je     80105011 <sleep+0x4a>
80105003:	83 ec 0c             	sub    $0xc,%esp
80105006:	ff 75 0c             	pushl  0xc(%ebp)
80105009:	e8 ad 0e 00 00       	call   80105ebb <release>
8010500e:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80105011:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105017:	8b 55 08             	mov    0x8(%ebp),%edx
8010501a:	89 50 20             	mov    %edx,0x20(%eax)
  // move proc from running to sleep list
  removeFromStateList(&ptable.pLists.running, RUNNING, proc);
  proc->state = SLEEPING;
  addToStateListHead(&ptable.pLists.sleep, SLEEPING, proc);
  #else
  proc->state = SLEEPING;
8010501d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105023:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  #endif
  sched(); // TODO: sched???
8010502a:	e8 25 fe ff ff       	call   80104e54 <sched>
  // END: Added for Project 3: List Management

  // Tidy up.
  proc->chan = 0;
8010502f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105035:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
8010503c:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
80105043:	74 24                	je     80105069 <sleep+0xa2>
    release(&ptable.lock);
80105045:	83 ec 0c             	sub    $0xc,%esp
80105048:	68 80 49 11 80       	push   $0x80114980
8010504d:	e8 69 0e 00 00       	call   80105ebb <release>
80105052:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
80105055:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105059:	74 0e                	je     80105069 <sleep+0xa2>
8010505b:	83 ec 0c             	sub    $0xc,%esp
8010505e:	ff 75 0c             	pushl  0xc(%ebp)
80105061:	e8 ee 0d 00 00       	call   80105e54 <acquire>
80105066:	83 c4 10             	add    $0x10,%esp
  }
}
80105069:	90                   	nop
8010506a:	c9                   	leave  
8010506b:	c3                   	ret    

8010506c <wakeup1>:
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010506c:	55                   	push   %ebp
8010506d:	89 e5                	mov    %esp,%ebp
8010506f:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105072:	c7 45 fc b4 49 11 80 	movl   $0x801149b4,-0x4(%ebp)
80105079:	eb 27                	jmp    801050a2 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
8010507b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010507e:	8b 40 0c             	mov    0xc(%eax),%eax
80105081:	83 f8 02             	cmp    $0x2,%eax
80105084:	75 15                	jne    8010509b <wakeup1+0x2f>
80105086:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105089:	8b 40 20             	mov    0x20(%eax),%eax
8010508c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010508f:	75 0a                	jne    8010509b <wakeup1+0x2f>
      p->state = RUNNABLE;
80105091:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105094:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010509b:	81 45 fc 9c 00 00 00 	addl   $0x9c,-0x4(%ebp)
801050a2:	81 7d fc b4 70 11 80 	cmpl   $0x801170b4,-0x4(%ebp)
801050a9:	72 d0                	jb     8010507b <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
801050ab:	90                   	nop
801050ac:	c9                   	leave  
801050ad:	c3                   	ret    

801050ae <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801050ae:	55                   	push   %ebp
801050af:	89 e5                	mov    %esp,%ebp
801050b1:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	68 80 49 11 80       	push   $0x80114980
801050bc:	e8 93 0d 00 00       	call   80105e54 <acquire>
801050c1:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801050c4:	83 ec 0c             	sub    $0xc,%esp
801050c7:	ff 75 08             	pushl  0x8(%ebp)
801050ca:	e8 9d ff ff ff       	call   8010506c <wakeup1>
801050cf:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801050d2:	83 ec 0c             	sub    $0xc,%esp
801050d5:	68 80 49 11 80       	push   $0x80114980
801050da:	e8 dc 0d 00 00       	call   80105ebb <release>
801050df:	83 c4 10             	add    $0x10,%esp
}
801050e2:	90                   	nop
801050e3:	c9                   	leave  
801050e4:	c3                   	ret    

801050e5 <kill>:
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
801050e5:	55                   	push   %ebp
801050e6:	89 e5                	mov    %esp,%ebp
801050e8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801050eb:	83 ec 0c             	sub    $0xc,%esp
801050ee:	68 80 49 11 80       	push   $0x80114980
801050f3:	e8 5c 0d 00 00       	call   80105e54 <acquire>
801050f8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050fb:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80105102:	eb 4a                	jmp    8010514e <kill+0x69>
    if(p->pid == pid){
80105104:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105107:	8b 50 10             	mov    0x10(%eax),%edx
8010510a:	8b 45 08             	mov    0x8(%ebp),%eax
8010510d:	39 c2                	cmp    %eax,%edx
8010510f:	75 36                	jne    80105147 <kill+0x62>
      p->killed = 1;
80105111:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105114:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010511b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010511e:	8b 40 0c             	mov    0xc(%eax),%eax
80105121:	83 f8 02             	cmp    $0x2,%eax
80105124:	75 0a                	jne    80105130 <kill+0x4b>
        p->state = RUNNABLE;
80105126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105129:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	68 80 49 11 80       	push   $0x80114980
80105138:	e8 7e 0d 00 00       	call   80105ebb <release>
8010513d:	83 c4 10             	add    $0x10,%esp
      return 0;
80105140:	b8 00 00 00 00       	mov    $0x0,%eax
80105145:	eb 25                	jmp    8010516c <kill+0x87>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105147:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
8010514e:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80105155:	72 ad                	jb     80105104 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105157:	83 ec 0c             	sub    $0xc,%esp
8010515a:	68 80 49 11 80       	push   $0x80114980
8010515f:	e8 57 0d 00 00       	call   80105ebb <release>
80105164:	83 c4 10             	add    $0x10,%esp
  return -1;
80105167:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010516c:	c9                   	leave  
8010516d:	c3                   	ret    

8010516e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010516e:	55                   	push   %ebp
8010516f:	89 e5                	mov    %esp,%ebp
80105171:	57                   	push   %edi
80105172:	56                   	push   %esi
80105173:	53                   	push   %ebx
80105174:	83 ec 6c             	sub    $0x6c,%esp
  char *state;
  uint pc[10];
  uint ppid;
 
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command
80105177:	83 ec 0c             	sub    $0xc,%esp
8010517a:	68 9c 9b 10 80       	push   $0x80109b9c
8010517f:	e8 42 b2 ff ff       	call   801003c6 <cprintf>
80105184:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105187:	c7 45 e0 b4 49 11 80 	movl   $0x801149b4,-0x20(%ebp)
8010518e:	e9 0e 02 00 00       	jmp    801053a1 <procdump+0x233>
    if(p->state == UNUSED)
80105193:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105196:	8b 40 0c             	mov    0xc(%eax),%eax
80105199:	85 c0                	test   %eax,%eax
8010519b:	0f 84 f8 01 00 00    	je     80105399 <procdump+0x22b>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801051a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051a4:	8b 40 0c             	mov    0xc(%eax),%eax
801051a7:	83 f8 05             	cmp    $0x5,%eax
801051aa:	77 23                	ja     801051cf <procdump+0x61>
801051ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051af:	8b 40 0c             	mov    0xc(%eax),%eax
801051b2:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801051b9:	85 c0                	test   %eax,%eax
801051bb:	74 12                	je     801051cf <procdump+0x61>
      state = states[p->state];
801051bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051c0:	8b 40 0c             	mov    0xc(%eax),%eax
801051c3:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801051ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
801051cd:	eb 07                	jmp    801051d6 <procdump+0x68>
    else
      state = "???";
801051cf:	c7 45 dc d5 9b 10 80 	movl   $0x80109bd5,-0x24(%ebp)
    // Print PID, Name, UID, GID, PPID, Elapsed, CPU, State, and Size (with needed spacing)
    // Switched to tabs and mod in Project 2: Modifying the Console)
    // (I wish I used this method from the start.... :(  )
    
    // get ppid (and if it is init then its ppid is itself (1))
    if (p->pid == 1)
801051d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051d9:	8b 40 10             	mov    0x10(%eax),%eax
801051dc:	83 f8 01             	cmp    $0x1,%eax
801051df:	75 09                	jne    801051ea <procdump+0x7c>
      ppid = 1;
801051e1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
801051e8:	eb 0c                	jmp    801051f6 <procdump+0x88>
    else
      ppid = p->parent->pid;
801051ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051ed:	8b 40 14             	mov    0x14(%eax),%eax
801051f0:	8b 40 10             	mov    0x10(%eax),%eax
801051f3:	89 45 d8             	mov    %eax,-0x28(%ebp)

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801051f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051f9:	8b 38                	mov    (%eax),%edi
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
		p->cpu_ticks_total / 100,
		p->cpu_ticks_total % 100 / 10,
801051fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051fe:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80105204:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105209:	89 c8                	mov    %ecx,%eax
8010520b:	f7 e2                	mul    %edx
8010520d:	89 d0                	mov    %edx,%eax
8010520f:	c1 e8 05             	shr    $0x5,%eax
80105212:	6b c0 64             	imul   $0x64,%eax,%eax
80105215:	29 c1                	sub    %eax,%ecx
80105217:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
80105219:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010521e:	f7 e2                	mul    %edx
80105220:	c1 ea 03             	shr    $0x3,%edx
80105223:	89 55 a4             	mov    %edx,-0x5c(%ebp)
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
		p->cpu_ticks_total / 100,
80105226:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105229:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
8010522f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105234:	f7 e2                	mul    %edx
80105236:	89 d0                	mov    %edx,%eax
80105238:	c1 e8 05             	shr    $0x5,%eax
8010523b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
		(ticks - p->start_ticks) % 100 % 10,
8010523e:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105244:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105247:	8b 40 7c             	mov    0x7c(%eax),%eax
8010524a:	89 d3                	mov    %edx,%ebx
8010524c:	29 c3                	sub    %eax,%ebx
8010524e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105253:	89 d8                	mov    %ebx,%eax
80105255:	f7 e2                	mul    %edx
80105257:	89 d1                	mov    %edx,%ecx
80105259:	c1 e9 05             	shr    $0x5,%ecx
8010525c:	6b c1 64             	imul   $0x64,%ecx,%eax
8010525f:	29 c3                	sub    %eax,%ebx
80105261:	89 d9                	mov    %ebx,%ecx
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
80105263:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105268:	89 c8                	mov    %ecx,%eax
8010526a:	f7 e2                	mul    %edx
8010526c:	89 d3                	mov    %edx,%ebx
8010526e:	c1 eb 03             	shr    $0x3,%ebx
80105271:	89 d8                	mov    %ebx,%eax
80105273:	c1 e0 02             	shl    $0x2,%eax
80105276:	01 d8                	add    %ebx,%eax
80105278:	01 c0                	add    %eax,%eax
8010527a:	89 cb                	mov    %ecx,%ebx
8010527c:	29 c3                	sub    %eax,%ebx
		p->uid,
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
		(ticks - p->start_ticks) % 100 / 10,
8010527e:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105284:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105287:	8b 40 7c             	mov    0x7c(%eax),%eax
8010528a:	89 d1                	mov    %edx,%ecx
8010528c:	29 c1                	sub    %eax,%ecx
8010528e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105293:	89 c8                	mov    %ecx,%eax
80105295:	f7 e2                	mul    %edx
80105297:	89 d0                	mov    %edx,%eax
80105299:	c1 e8 05             	shr    $0x5,%eax
8010529c:	6b c0 64             	imul   $0x64,%eax,%eax
8010529f:	29 c1                	sub    %eax,%ecx
801052a1:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801052a3:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801052a8:	f7 e2                	mul    %edx
801052aa:	89 d6                	mov    %edx,%esi
801052ac:	c1 ee 03             	shr    $0x3,%esi
801052af:	89 75 9c             	mov    %esi,-0x64(%ebp)
		p->name,
		p->uid,
		p->gid,
		ppid,
		p->priority, // Added for Project 4: ctrl-p Console Command
		(ticks - p->start_ticks) / 100,
801052b2:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
801052b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052bb:	8b 40 7c             	mov    0x7c(%eax),%eax
801052be:	89 d1                	mov    %edx,%ecx
801052c0:	29 c1                	sub    %eax,%ecx
801052c2:	89 c8                	mov    %ecx,%eax
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801052c4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801052c9:	f7 e2                	mul    %edx
801052cb:	89 d1                	mov    %edx,%ecx
801052cd:	c1 e9 05             	shr    $0x5,%ecx
801052d0:	89 4d 98             	mov    %ecx,-0x68(%ebp)
801052d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052d6:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801052dc:	89 45 94             	mov    %eax,-0x6c(%ebp)
801052df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052e2:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
801052e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052eb:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
		p->pid,
		p->name,
801052f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052f4:	8d 50 6c             	lea    0x6c(%eax),%edx
    if (p->pid == 1)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.%d%d\t%d.%d\t%s\t%d\t",
801052f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052fa:	8b 40 10             	mov    0x10(%eax),%eax
801052fd:	83 ec 08             	sub    $0x8,%esp
80105300:	57                   	push   %edi
80105301:	ff 75 dc             	pushl  -0x24(%ebp)
80105304:	ff 75 a4             	pushl  -0x5c(%ebp)
80105307:	ff 75 a0             	pushl  -0x60(%ebp)
8010530a:	53                   	push   %ebx
8010530b:	ff 75 9c             	pushl  -0x64(%ebp)
8010530e:	ff 75 98             	pushl  -0x68(%ebp)
80105311:	ff 75 94             	pushl  -0x6c(%ebp)
80105314:	ff 75 d8             	pushl  -0x28(%ebp)
80105317:	56                   	push   %esi
80105318:	51                   	push   %ecx
80105319:	52                   	push   %edx
8010531a:	50                   	push   %eax
8010531b:	68 dc 9b 10 80       	push   $0x80109bdc
80105320:	e8 a1 b0 ff ff       	call   801003c6 <cprintf>
80105325:	83 c4 40             	add    $0x40,%esp
		p->sz);

    // END: Added for Project 1: CTL-P

    // Print PCs data
    if(p->state == SLEEPING){
80105328:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010532b:	8b 40 0c             	mov    0xc(%eax),%eax
8010532e:	83 f8 02             	cmp    $0x2,%eax
80105331:	75 54                	jne    80105387 <procdump+0x219>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105333:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105336:	8b 40 1c             	mov    0x1c(%eax),%eax
80105339:	8b 40 0c             	mov    0xc(%eax),%eax
8010533c:	83 c0 08             	add    $0x8,%eax
8010533f:	89 c2                	mov    %eax,%edx
80105341:	83 ec 08             	sub    $0x8,%esp
80105344:	8d 45 b0             	lea    -0x50(%ebp),%eax
80105347:	50                   	push   %eax
80105348:	52                   	push   %edx
80105349:	e8 bf 0b 00 00       	call   80105f0d <getcallerpcs>
8010534e:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105351:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105358:	eb 1c                	jmp    80105376 <procdump+0x208>
        cprintf(" %p", pc[i]);
8010535a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010535d:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
80105361:	83 ec 08             	sub    $0x8,%esp
80105364:	50                   	push   %eax
80105365:	68 03 9c 10 80       	push   $0x80109c03
8010536a:	e8 57 b0 ff ff       	call   801003c6 <cprintf>
8010536f:	83 c4 10             	add    $0x10,%esp
    // END: Added for Project 1: CTL-P

    // Print PCs data
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105372:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105376:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
8010537a:	7f 0b                	jg     80105387 <procdump+0x219>
8010537c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010537f:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
80105383:	85 c0                	test   %eax,%eax
80105385:	75 d3                	jne    8010535a <procdump+0x1ec>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105387:	83 ec 0c             	sub    $0xc,%esp
8010538a:	68 07 9c 10 80       	push   $0x80109c07
8010538f:	e8 32 b0 ff ff       	call   801003c6 <cprintf>
80105394:	83 c4 10             	add    $0x10,%esp
80105397:	eb 01                	jmp    8010539a <procdump+0x22c>
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105399:	90                   	nop
  uint ppid;
 
  // Print table column headers
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"); // switched to tabs in Project 2: Modifying the Console. Modified for Project 4: ctrl-p Console Command

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010539a:	81 45 e0 9c 00 00 00 	addl   $0x9c,-0x20(%ebp)
801053a1:	81 7d e0 b4 70 11 80 	cmpl   $0x801170b4,-0x20(%ebp)
801053a8:	0f 82 e5 fd ff ff    	jb     80105193 <procdump+0x25>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801053ae:	90                   	nop
801053af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053b2:	5b                   	pop    %ebx
801053b3:	5e                   	pop    %esi
801053b4:	5f                   	pop    %edi
801053b5:	5d                   	pop    %ebp
801053b6:	c3                   	ret    

801053b7 <readydump>:

// START: Added for Project 3: New Console Control Sequences
void
readydump(void) // Modified for Project 4: ctrl-r Console Command
{
801053b7:	55                   	push   %ebp
801053b8:	89 e5                	mov    %esp,%ebp
801053ba:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801053bd:	83 ec 0c             	sub    $0xc,%esp
801053c0:	68 80 49 11 80       	push   $0x80114980
801053c5:	e8 8a 0a 00 00       	call   80105e54 <acquire>
801053ca:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = 0;
801053cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  cprintf("Ready List Processes:\n"); 
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	68 09 9c 10 80       	push   $0x80109c09
801053dc:	e8 e5 af ff ff       	call   801003c6 <cprintf>
801053e1:	83 c4 10             	add    $0x10,%esp

  for(int i = 0; i < MAX + 1; ++i){
801053e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801053eb:	e9 a4 00 00 00       	jmp    80105494 <readydump+0xdd>
    currPtr = ptable.pLists.ready[i];
801053f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053f3:	05 cc 09 00 00       	add    $0x9cc,%eax
801053f8:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801053ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%d: ", i); // print list number
80105402:	83 ec 08             	sub    $0x8,%esp
80105405:	ff 75 f0             	pushl  -0x10(%ebp)
80105408:	68 20 9c 10 80       	push   $0x80109c20
8010540d:	e8 b4 af ff ff       	call   801003c6 <cprintf>
80105412:	83 c4 10             	add    $0x10,%esp
    
    if (currPtr == 0)
80105415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105419:	75 6f                	jne    8010548a <readydump+0xd3>
      cprintf("Empty!\n");
8010541b:	83 ec 0c             	sub    $0xc,%esp
8010541e:	68 25 9c 10 80       	push   $0x80109c25
80105423:	e8 9e af ff ff       	call   801003c6 <cprintf>
80105428:	83 c4 10             	add    $0x10,%esp

    while (currPtr != 0){
8010542b:	eb 5d                	jmp    8010548a <readydump+0xd3>
      if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
8010542d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105430:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105436:	85 c0                	test   %eax,%eax
80105438:	75 23                	jne    8010545d <readydump+0xa6>
        cprintf("(%d, %d)\n", currPtr->pid, currPtr->budget);
8010543a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543d:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105443:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105446:	8b 40 10             	mov    0x10(%eax),%eax
80105449:	83 ec 04             	sub    $0x4,%esp
8010544c:	52                   	push   %edx
8010544d:	50                   	push   %eax
8010544e:	68 2d 9c 10 80       	push   $0x80109c2d
80105453:	e8 6e af ff ff       	call   801003c6 <cprintf>
80105458:	83 c4 10             	add    $0x10,%esp
8010545b:	eb 21                	jmp    8010547e <readydump+0xc7>
      else
        cprintf("(%d, %d) -> ", currPtr->pid, currPtr->budget);
8010545d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105460:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105469:	8b 40 10             	mov    0x10(%eax),%eax
8010546c:	83 ec 04             	sub    $0x4,%esp
8010546f:	52                   	push   %edx
80105470:	50                   	push   %eax
80105471:	68 37 9c 10 80       	push   $0x80109c37
80105476:	e8 4b af ff ff       	call   801003c6 <cprintf>
8010547b:	83 c4 10             	add    $0x10,%esp

      currPtr = currPtr->next;
8010547e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105481:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105487:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%d: ", i); // print list number
    
    if (currPtr == 0)
      cprintf("Empty!\n");

    while (currPtr != 0){
8010548a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010548e:	75 9d                	jne    8010542d <readydump+0x76>

  struct proc *currPtr = 0;

  cprintf("Ready List Processes:\n"); 

  for(int i = 0; i < MAX + 1; ++i){
80105490:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105498:	0f 8e 52 ff ff ff    	jle    801053f0 <readydump+0x39>

      currPtr = currPtr->next;
    }
  }

  release(&ptable.lock);
8010549e:	83 ec 0c             	sub    $0xc,%esp
801054a1:	68 80 49 11 80       	push   $0x80114980
801054a6:	e8 10 0a 00 00       	call   80105ebb <release>
801054ab:	83 c4 10             	add    $0x10,%esp
}
801054ae:	90                   	nop
801054af:	c9                   	leave  
801054b0:	c3                   	ret    

801054b1 <freedump>:

void
freedump(void)
{
801054b1:	55                   	push   %ebp
801054b2:	89 e5                	mov    %esp,%ebp
801054b4:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801054b7:	83 ec 0c             	sub    $0xc,%esp
801054ba:	68 80 49 11 80       	push   $0x80114980
801054bf:	e8 90 09 00 00       	call   80105e54 <acquire>
801054c4:	83 c4 10             	add    $0x10,%esp
  
  struct proc *currPtr = ptable.pLists.free;
801054c7:	a1 b8 70 11 80       	mov    0x801170b8,%eax
801054cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint numProcs = 0;
801054cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  while (currPtr != 0){
801054d6:	eb 10                	jmp    801054e8 <freedump+0x37>
    ++numProcs;
801054d8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    currPtr = currPtr->next;
801054dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054df:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801054e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&ptable.lock);
  
  struct proc *currPtr = ptable.pLists.free;
  uint numProcs = 0;

  while (currPtr != 0){
801054e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054ec:	75 ea                	jne    801054d8 <freedump+0x27>
    ++numProcs;
    currPtr = currPtr->next;
  }

  cprintf("Free List Size: %d processes\n", numProcs);
801054ee:	83 ec 08             	sub    $0x8,%esp
801054f1:	ff 75 f0             	pushl  -0x10(%ebp)
801054f4:	68 44 9c 10 80       	push   $0x80109c44
801054f9:	e8 c8 ae ff ff       	call   801003c6 <cprintf>
801054fe:	83 c4 10             	add    $0x10,%esp

  release(&ptable.lock);
80105501:	83 ec 0c             	sub    $0xc,%esp
80105504:	68 80 49 11 80       	push   $0x80114980
80105509:	e8 ad 09 00 00       	call   80105ebb <release>
8010550e:	83 c4 10             	add    $0x10,%esp
}
80105511:	90                   	nop
80105512:	c9                   	leave  
80105513:	c3                   	ret    

80105514 <sleepdump>:

void
sleepdump(void)
{
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
8010551a:	83 ec 0c             	sub    $0xc,%esp
8010551d:	68 80 49 11 80       	push   $0x80114980
80105522:	e8 2d 09 00 00       	call   80105e54 <acquire>
80105527:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = ptable.pLists.sleep;
8010552a:	a1 bc 70 11 80       	mov    0x801170bc,%eax
8010552f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  cprintf("Sleep List Processes:\n"); 
80105532:	83 ec 0c             	sub    $0xc,%esp
80105535:	68 62 9c 10 80       	push   $0x80109c62
8010553a:	e8 87 ae ff ff       	call   801003c6 <cprintf>
8010553f:	83 c4 10             	add    $0x10,%esp
  
  if (currPtr == 0)
80105542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105546:	75 5b                	jne    801055a3 <sleepdump+0x8f>
    cprintf("Empty!\n");
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	68 25 9c 10 80       	push   $0x80109c25
80105550:	e8 71 ae ff ff       	call   801003c6 <cprintf>
80105555:	83 c4 10             	add    $0x10,%esp

  while (currPtr != 0){
80105558:	eb 49                	jmp    801055a3 <sleepdump+0x8f>
    if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
8010555a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010555d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105563:	85 c0                	test   %eax,%eax
80105565:	75 19                	jne    80105580 <sleepdump+0x6c>
      cprintf("%d\n", currPtr->pid);
80105567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010556a:	8b 40 10             	mov    0x10(%eax),%eax
8010556d:	83 ec 08             	sub    $0x8,%esp
80105570:	50                   	push   %eax
80105571:	68 79 9c 10 80       	push   $0x80109c79
80105576:	e8 4b ae ff ff       	call   801003c6 <cprintf>
8010557b:	83 c4 10             	add    $0x10,%esp
8010557e:	eb 17                	jmp    80105597 <sleepdump+0x83>
    else
      cprintf("%d -> ", currPtr->pid);
80105580:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105583:	8b 40 10             	mov    0x10(%eax),%eax
80105586:	83 ec 08             	sub    $0x8,%esp
80105589:	50                   	push   %eax
8010558a:	68 7d 9c 10 80       	push   $0x80109c7d
8010558f:	e8 32 ae ff ff       	call   801003c6 <cprintf>
80105594:	83 c4 10             	add    $0x10,%esp

    currPtr = currPtr->next;
80105597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010559a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801055a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cprintf("Sleep List Processes:\n"); 
  
  if (currPtr == 0)
    cprintf("Empty!\n");

  while (currPtr != 0){
801055a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055a7:	75 b1                	jne    8010555a <sleepdump+0x46>
      cprintf("%d -> ", currPtr->pid);

    currPtr = currPtr->next;
  }

  release(&ptable.lock);
801055a9:	83 ec 0c             	sub    $0xc,%esp
801055ac:	68 80 49 11 80       	push   $0x80114980
801055b1:	e8 05 09 00 00       	call   80105ebb <release>
801055b6:	83 c4 10             	add    $0x10,%esp
}
801055b9:	90                   	nop
801055ba:	c9                   	leave  
801055bb:	c3                   	ret    

801055bc <zombiedump>:

void
zombiedump(void)
{
801055bc:	55                   	push   %ebp
801055bd:	89 e5                	mov    %esp,%ebp
801055bf:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801055c2:	83 ec 0c             	sub    $0xc,%esp
801055c5:	68 80 49 11 80       	push   $0x80114980
801055ca:	e8 85 08 00 00       	call   80105e54 <acquire>
801055cf:	83 c4 10             	add    $0x10,%esp

  struct proc *currPtr = ptable.pLists.zombie;
801055d2:	a1 c0 70 11 80       	mov    0x801170c0,%eax
801055d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  cprintf("Zombie List Processes:\n"); 
801055da:	83 ec 0c             	sub    $0xc,%esp
801055dd:	68 84 9c 10 80       	push   $0x80109c84
801055e2:	e8 df ad ff ff       	call   801003c6 <cprintf>
801055e7:	83 c4 10             	add    $0x10,%esp

  if (currPtr == 0)
801055ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055ee:	75 6f                	jne    8010565f <zombiedump+0xa3>
    cprintf("Empty!\n");
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	68 25 9c 10 80       	push   $0x80109c25
801055f8:	e8 c9 ad ff ff       	call   801003c6 <cprintf>
801055fd:	83 c4 10             	add    $0x10,%esp

  while (currPtr != 0){
80105600:	eb 5d                	jmp    8010565f <zombiedump+0xa3>
    if (currPtr->next == 0) // need to check if we're at the tail so we don't print another arrow
80105602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105605:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010560b:	85 c0                	test   %eax,%eax
8010560d:	75 23                	jne    80105632 <zombiedump+0x76>
        cprintf("(%d, %d)\n", currPtr->pid, currPtr->parent->pid);
8010560f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105612:	8b 40 14             	mov    0x14(%eax),%eax
80105615:	8b 50 10             	mov    0x10(%eax),%edx
80105618:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010561b:	8b 40 10             	mov    0x10(%eax),%eax
8010561e:	83 ec 04             	sub    $0x4,%esp
80105621:	52                   	push   %edx
80105622:	50                   	push   %eax
80105623:	68 2d 9c 10 80       	push   $0x80109c2d
80105628:	e8 99 ad ff ff       	call   801003c6 <cprintf>
8010562d:	83 c4 10             	add    $0x10,%esp
80105630:	eb 21                	jmp    80105653 <zombiedump+0x97>
    else
      cprintf("(%d, %d) -> ", currPtr->pid, currPtr->parent->pid);
80105632:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105635:	8b 40 14             	mov    0x14(%eax),%eax
80105638:	8b 50 10             	mov    0x10(%eax),%edx
8010563b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010563e:	8b 40 10             	mov    0x10(%eax),%eax
80105641:	83 ec 04             	sub    $0x4,%esp
80105644:	52                   	push   %edx
80105645:	50                   	push   %eax
80105646:	68 37 9c 10 80       	push   $0x80109c37
8010564b:	e8 76 ad ff ff       	call   801003c6 <cprintf>
80105650:	83 c4 10             	add    $0x10,%esp
    
    currPtr = currPtr->next;
80105653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105656:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010565c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cprintf("Zombie List Processes:\n"); 

  if (currPtr == 0)
    cprintf("Empty!\n");

  while (currPtr != 0){
8010565f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105663:	75 9d                	jne    80105602 <zombiedump+0x46>
      cprintf("(%d, %d) -> ", currPtr->pid, currPtr->parent->pid);
    
    currPtr = currPtr->next;
  }

  release(&ptable.lock);
80105665:	83 ec 0c             	sub    $0xc,%esp
80105668:	68 80 49 11 80       	push   $0x80114980
8010566d:	e8 49 08 00 00       	call   80105ebb <release>
80105672:	83 c4 10             	add    $0x10,%esp
}
80105675:	90                   	nop
80105676:	c9                   	leave  
80105677:	c3                   	ret    

80105678 <getuprocs>:
// END: Added for Project 3: New Console Control Sequences

// get array of uproc structs
int
getuprocs(uint max, struct uproc *table) // Added for Project 2: The "ps" Command
{
80105678:	55                   	push   %ebp
80105679:	89 e5                	mov    %esp,%ebp
8010567b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  uint numProcs = 0; // number of procs in struct array
8010567e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  acquire(&ptable.lock); // get lock so we get a snapshot
80105685:	83 ec 0c             	sub    $0xc,%esp
80105688:	68 80 49 11 80       	push   $0x80114980
8010568d:	e8 c2 07 00 00       	call   80105e54 <acquire>
80105692:	83 c4 10             	add    $0x10,%esp

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
80105695:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
8010569c:	e9 08 01 00 00       	jmp    801057a9 <getuprocs+0x131>
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
801056a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a4:	8b 40 0c             	mov    0xc(%eax),%eax
801056a7:	83 f8 03             	cmp    $0x3,%eax
801056aa:	74 25                	je     801056d1 <getuprocs+0x59>
        p->state == SLEEPING || 
801056ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056af:	8b 40 0c             	mov    0xc(%eax),%eax

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
801056b2:	83 f8 02             	cmp    $0x2,%eax
801056b5:	74 1a                	je     801056d1 <getuprocs+0x59>
        p->state == SLEEPING || 
        p->state == RUNNING  || 
801056b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ba:	8b 40 0c             	mov    0xc(%eax),%eax
  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
        p->state == SLEEPING || 
801056bd:	83 f8 04             	cmp    $0x4,%eax
801056c0:	74 0f                	je     801056d1 <getuprocs+0x59>
        p->state == RUNNING  || 
        p->state == ZOMBIE)
801056c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c5:	8b 40 0c             	mov    0xc(%eax),%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
  {
    // only add a proc if it is in an "active" state
    if (p->state == RUNNABLE || 
        p->state == SLEEPING || 
        p->state == RUNNING  || 
801056c8:	83 f8 05             	cmp    $0x5,%eax
801056cb:	0f 85 d1 00 00 00    	jne    801057a2 <getuprocs+0x12a>
        p->state == ZOMBIE)
    {

      // populate uproc struct entry in table
      table->pid  = p->pid;
801056d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d4:	8b 50 10             	mov    0x10(%eax),%edx
801056d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801056da:	89 10                	mov    %edx,(%eax)
      table->uid  = p->uid;
801056dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056df:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801056e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801056e8:	89 50 04             	mov    %edx,0x4(%eax)
      table->gid  = p->gid;
801056eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
801056f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801056f7:	89 50 08             	mov    %edx,0x8(%eax)

      if (p->pid == 1) // if p is init, then set ppid to itself (1)
801056fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056fd:	8b 40 10             	mov    0x10(%eax),%eax
80105700:	83 f8 01             	cmp    $0x1,%eax
80105703:	75 0c                	jne    80105711 <getuprocs+0x99>
        table->ppid = 1;
80105705:	8b 45 0c             	mov    0xc(%ebp),%eax
80105708:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
8010570f:	eb 0f                	jmp    80105720 <getuprocs+0xa8>
      else
        table->ppid = p->parent->pid;
80105711:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105714:	8b 40 14             	mov    0x14(%eax),%eax
80105717:	8b 50 10             	mov    0x10(%eax),%edx
8010571a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010571d:	89 50 0c             	mov    %edx,0xc(%eax)

      table->priority = p->priority;
80105720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105723:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105729:	8b 45 0c             	mov    0xc(%ebp),%eax
8010572c:	89 50 10             	mov    %edx,0x10(%eax)
      table->elapsed_ticks = ticks - p->start_ticks;
8010572f:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105735:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105738:	8b 40 7c             	mov    0x7c(%eax),%eax
8010573b:	29 c2                	sub    %eax,%edx
8010573d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105740:	89 50 14             	mov    %edx,0x14(%eax)
      table->CPU_total_ticks = p->cpu_ticks_total;
80105743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105746:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
8010574c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010574f:	89 50 18             	mov    %edx,0x18(%eax)
      safestrcpy(table->state, states[p->state], NELEM(table->state));
80105752:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105755:	8b 40 0c             	mov    0xc(%eax),%eax
80105758:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
8010575f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105762:	83 c2 1c             	add    $0x1c,%edx
80105765:	83 ec 04             	sub    $0x4,%esp
80105768:	6a 20                	push   $0x20
8010576a:	50                   	push   %eax
8010576b:	52                   	push   %edx
8010576c:	e8 49 0b 00 00       	call   801062ba <safestrcpy>
80105771:	83 c4 10             	add    $0x10,%esp
      table->size = p->sz;
80105774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105777:	8b 10                	mov    (%eax),%edx
80105779:	8b 45 0c             	mov    0xc(%ebp),%eax
8010577c:	89 50 3c             	mov    %edx,0x3c(%eax)
      safestrcpy(table->name, p->name, NELEM(table->name));
8010577f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105782:	8d 50 6c             	lea    0x6c(%eax),%edx
80105785:	8b 45 0c             	mov    0xc(%ebp),%eax
80105788:	83 c0 40             	add    $0x40,%eax
8010578b:	83 ec 04             	sub    $0x4,%esp
8010578e:	6a 20                	push   $0x20
80105790:	52                   	push   %edx
80105791:	50                   	push   %eax
80105792:	e8 23 0b 00 00       	call   801062ba <safestrcpy>
80105797:	83 c4 10             	add    $0x10,%esp

      ++table; // go to next entry
8010579a:	83 45 0c 60          	addl   $0x60,0xc(%ebp)
      ++numProcs; // inc number of procs in struct array
8010579e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  uint numProcs = 0; // number of procs in struct array

  acquire(&ptable.lock); // get lock so we get a snapshot

  // loop through ptable and add procs to table
  for (p = ptable.proc; p < &ptable.proc[NPROC] && numProcs < max; ++p)
801057a2:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
801057a9:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
801057b0:	73 0c                	jae    801057be <getuprocs+0x146>
801057b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b5:	3b 45 08             	cmp    0x8(%ebp),%eax
801057b8:	0f 82 e3 fe ff ff    	jb     801056a1 <getuprocs+0x29>
      ++table; // go to next entry
      ++numProcs; // inc number of procs in struct array
    }
  }

  release(&ptable.lock); // return lock
801057be:	83 ec 0c             	sub    $0xc,%esp
801057c1:	68 80 49 11 80       	push   $0x80114980
801057c6:	e8 f0 06 00 00       	call   80105ebb <release>
801057cb:	83 c4 10             	add    $0x10,%esp

  return numProcs;
801057ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801057d1:	c9                   	leave  
801057d2:	c3                   	ret    

801057d3 <removeFromStateList>:

// Removes a proc "p" from a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
removeFromStateList(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
801057d3:	55                   	push   %ebp
801057d4:	89 e5                	mov    %esp,%ebp
801057d6:	83 ec 08             	sub    $0x8,%esp
   
  // check if passed in proc is in the specified state
  if (p->state != state) {
801057d9:	8b 45 10             	mov    0x10(%ebp),%eax
801057dc:	8b 40 0c             	mov    0xc(%eax),%eax
801057df:	3b 45 0c             	cmp    0xc(%ebp),%eax
801057e2:	74 34                	je     80105818 <removeFromStateList+0x45>
    panic("The passed in proc to remove had the wrong state.");
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	68 9c 9c 10 80       	push   $0x80109c9c
801057ec:	e8 75 ad ff ff       	call   80100566 <panic>

  // search through list to find proc to remove
  while((*sList) != 0) {
  
    // if matching proc is found then remove it and return
    if ((*sList) == p) {
801057f1:	8b 45 08             	mov    0x8(%ebp),%eax
801057f4:	8b 00                	mov    (%eax),%eax
801057f6:	3b 45 10             	cmp    0x10(%ebp),%eax
801057f9:	75 10                	jne    8010580b <removeFromStateList+0x38>
      (*sList) = p->next; // remove proc by "skipping" over it     
801057fb:	8b 45 10             	mov    0x10(%ebp),%eax
801057fe:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105804:	8b 45 08             	mov    0x8(%ebp),%eax
80105807:	89 10                	mov    %edx,(%eax)
      return;
80105809:	eb 4b                	jmp    80105856 <removeFromStateList+0x83>
    }

    // else, keep searching 
    sList = &(*sList)->next;
8010580b:	8b 45 08             	mov    0x8(%ebp),%eax
8010580e:	8b 00                	mov    (%eax),%eax
80105810:	05 90 00 00 00       	add    $0x90,%eax
80105815:	89 45 08             	mov    %eax,0x8(%ebp)
  if (p->state != state) {
    panic("The passed in proc to remove had the wrong state.");
  }

  // search through list to find proc to remove
  while((*sList) != 0) {
80105818:	8b 45 08             	mov    0x8(%ebp),%eax
8010581b:	8b 00                	mov    (%eax),%eax
8010581d:	85 c0                	test   %eax,%eax
8010581f:	75 d0                	jne    801057f1 <removeFromStateList+0x1e>

    // else, keep searching 
    sList = &(*sList)->next;
  }

  cprintf("removeFromStateList: p->priority is %d p->pid is %d p->ppid is %d\n", p->priority, p->pid, p->parent->pid);
80105821:	8b 45 10             	mov    0x10(%ebp),%eax
80105824:	8b 40 14             	mov    0x14(%eax),%eax
80105827:	8b 48 10             	mov    0x10(%eax),%ecx
8010582a:	8b 45 10             	mov    0x10(%ebp),%eax
8010582d:	8b 50 10             	mov    0x10(%eax),%edx
80105830:	8b 45 10             	mov    0x10(%ebp),%eax
80105833:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105839:	51                   	push   %ecx
8010583a:	52                   	push   %edx
8010583b:	50                   	push   %eax
8010583c:	68 d0 9c 10 80       	push   $0x80109cd0
80105841:	e8 80 ab ff ff       	call   801003c6 <cprintf>
80105846:	83 c4 10             	add    $0x10,%esp
  // if it wasn't found then panic and return error
  panic("The passed in proc to remove was not found.");
80105849:	83 ec 0c             	sub    $0xc,%esp
8010584c:	68 14 9d 10 80       	push   $0x80109d14
80105851:	e8 10 ad ff ff       	call   80100566 <panic>
  
}
80105856:	c9                   	leave  
80105857:	c3                   	ret    

80105858 <getFromStateListHead>:
// This is O(1) and is used to get procs from lists which are equivalent (e.g. free)
// If there the specified list is empty then panic
// Also, if the proc that is gotten has the wrong state then panic
struct proc*
getFromStateListHead(struct proc **sList, enum procstate state) // Added for Project 3: List Management
{
80105858:	55                   	push   %ebp
80105859:	89 e5                	mov    %esp,%ebp
8010585b:	83 ec 18             	sub    $0x18,%esp
  struct proc* head = (*sList);
8010585e:	8b 45 08             	mov    0x8(%ebp),%eax
80105861:	8b 00                	mov    (%eax),%eax
80105863:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // if head exists then return gotten head proc (if correct state) and remove from sList
  if (head != 0) {
80105866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010586a:	74 2d                	je     80105899 <getFromStateListHead+0x41>
    if (head->state != state)
8010586c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586f:	8b 40 0c             	mov    0xc(%eax),%eax
80105872:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105875:	74 0d                	je     80105884 <getFromStateListHead+0x2c>
      panic("The gotten head proc had the wrong state.");
80105877:	83 ec 0c             	sub    $0xc,%esp
8010587a:	68 40 9d 10 80       	push   $0x80109d40
8010587f:	e8 e2 ac ff ff       	call   80100566 <panic>
    else {
      (*sList) = (*sList)->next; // remove gotten head proc by skipping over it
80105884:	8b 45 08             	mov    0x8(%ebp),%eax
80105887:	8b 00                	mov    (%eax),%eax
80105889:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
8010588f:	8b 45 08             	mov    0x8(%ebp),%eax
80105892:	89 10                	mov    %edx,(%eax)
      return head;
80105894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105897:	eb 05                	jmp    8010589e <getFromStateListHead+0x46>
    }
    
  }

  return 0; // if head doesn't exist then null is returned
80105899:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010589e:	c9                   	leave  
8010589f:	c3                   	ret    

801058a0 <addToStateListHead>:

// Adds a proc "p" to the head of a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
addToStateListHead(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 08             	sub    $0x8,%esp
  // check if proc that is being added is correct state
  if (p->state != state) {
801058a6:	8b 45 10             	mov    0x10(%ebp),%eax
801058a9:	8b 40 0c             	mov    0xc(%eax),%eax
801058ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
801058af:	74 0d                	je     801058be <addToStateListHead+0x1e>
    panic("The passed in proc to add to head had the wrong state.");
801058b1:	83 ec 0c             	sub    $0xc,%esp
801058b4:	68 6c 9d 10 80       	push   $0x80109d6c
801058b9:	e8 a8 ac ff ff       	call   80100566 <panic>
  }

  // add proc to head
  p->next = (*sList); // note that if the sList is empty then the next will be set to null (as expected)
801058be:	8b 45 08             	mov    0x8(%ebp),%eax
801058c1:	8b 10                	mov    (%eax),%edx
801058c3:	8b 45 10             	mov    0x10(%ebp),%eax
801058c6:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  (*sList) = p;
801058cc:	8b 45 08             	mov    0x8(%ebp),%eax
801058cf:	8b 55 10             	mov    0x10(%ebp),%edx
801058d2:	89 10                	mov    %edx,(%eax)

}
801058d4:	90                   	nop
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    

801058d7 <addToStateListTail>:

// Adds a proc "p" to the tail of a linked list of procs "sList" that has the state "state"
// switched to return of void since panic will be called during any critical error
void
addToStateListTail(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 3: List Management
{
801058d7:	55                   	push   %ebp
801058d8:	89 e5                	mov    %esp,%ebp
801058da:	83 ec 08             	sub    $0x8,%esp
  // check if proc that is being added is correct state
  if (p->state != state) {
801058dd:	8b 45 10             	mov    0x10(%ebp),%eax
801058e0:	8b 40 0c             	mov    0xc(%eax),%eax
801058e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801058e6:	74 0d                	je     801058f5 <addToStateListTail+0x1e>
    panic("The passed in proc to add to tail had the wrong state.");
801058e8:	83 ec 0c             	sub    $0xc,%esp
801058eb:	68 a4 9d 10 80       	push   $0x80109da4
801058f0:	e8 71 ac ff ff       	call   80100566 <panic>
  }
  
  // if list being added to is empty, then just add to head
  if ((*sList) == 0) {
801058f5:	8b 45 08             	mov    0x8(%ebp),%eax
801058f8:	8b 00                	mov    (%eax),%eax
801058fa:	85 c0                	test   %eax,%eax
801058fc:	75 50                	jne    8010594e <addToStateListTail+0x77>
    (*sList) = p;
801058fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105901:	8b 55 10             	mov    0x10(%ebp),%edx
80105904:	89 10                	mov    %edx,(%eax)
    p->next = 0; 
80105906:	8b 45 10             	mov    0x10(%ebp),%eax
80105909:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105910:	00 00 00 
80105913:	eb 42                	jmp    80105957 <addToStateListTail+0x80>
  // otherwise, find the tail and add proc
  } else {
    while ((*sList) != 0) {
      
      // if tail is found then add proc and return
      if ((*sList)->next == 0) {
80105915:	8b 45 08             	mov    0x8(%ebp),%eax
80105918:	8b 00                	mov    (%eax),%eax
8010591a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105920:	85 c0                	test   %eax,%eax
80105922:	75 1d                	jne    80105941 <addToStateListTail+0x6a>
        (*sList)->next = p;
80105924:	8b 45 08             	mov    0x8(%ebp),%eax
80105927:	8b 00                	mov    (%eax),%eax
80105929:	8b 55 10             	mov    0x10(%ebp),%edx
8010592c:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        p->next = 0;
80105932:	8b 45 10             	mov    0x10(%ebp),%eax
80105935:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010593c:	00 00 00 
        return;
8010593f:	eb 16                	jmp    80105957 <addToStateListTail+0x80>
      }

      // otherwise, keep looping
      sList = &(*sList)->next; 
80105941:	8b 45 08             	mov    0x8(%ebp),%eax
80105944:	8b 00                	mov    (%eax),%eax
80105946:	05 90 00 00 00       	add    $0x90,%eax
8010594b:	89 45 08             	mov    %eax,0x8(%ebp)
    (*sList) = p;
    p->next = 0; 

  // otherwise, find the tail and add proc
  } else {
    while ((*sList) != 0) {
8010594e:	8b 45 08             	mov    0x8(%ebp),%eax
80105951:	8b 00                	mov    (%eax),%eax
80105953:	85 c0                	test   %eax,%eax
80105955:	75 be                	jne    80105915 <addToStateListTail+0x3e>
      // otherwise, keep looping
      sList = &(*sList)->next; 
    }
  }

}
80105957:	c9                   	leave  
80105958:	c3                   	ret    

80105959 <tackToStateListTail>:
// Tacks a proc p (and all of its "next" children) onto the tail of sList. 
// This function is only used when moving a list of procs between ready list priority queues.
// Also, the procs moved will have their priority decremented and their budget reset
void
tackToStateListTail(struct proc **sList, enum procstate state, struct proc *p) // Added for Project 4: Periodic Priority Adjustment (helper)
{
80105959:	55                   	push   %ebp
8010595a:	89 e5                	mov    %esp,%ebp
8010595c:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0;
8010595f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  // if p is null, then just return
  if (p == 0)
80105966:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010596a:	0f 84 de 00 00 00    	je     80105a4e <tackToStateListTail+0xf5>
    return;
  
  // check if proc that is being moved is correct state
  if (p->state != state)
80105970:	8b 45 10             	mov    0x10(%ebp),%eax
80105973:	8b 40 0c             	mov    0xc(%eax),%eax
80105976:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105979:	74 0d                	je     80105988 <tackToStateListTail+0x2f>
    panic("The passed in proc to tack to tail had the wrong state.");
8010597b:	83 ec 0c             	sub    $0xc,%esp
8010597e:	68 dc 9d 10 80       	push   $0x80109ddc
80105983:	e8 de ab ff ff       	call   80100566 <panic>

  // if list being tacked to is empty, then just add to head
  if ((*sList) == 0){
80105988:	8b 45 08             	mov    0x8(%ebp),%eax
8010598b:	8b 00                	mov    (%eax),%eax
8010598d:	85 c0                	test   %eax,%eax
8010598f:	0f 85 ae 00 00 00    	jne    80105a43 <tackToStateListTail+0xea>
    (*sList) = p; // note that p's tail is not set to null since it is assumed its tail and its "next" children are set accordingly
80105995:	8b 45 08             	mov    0x8(%ebp),%eax
80105998:	8b 55 10             	mov    0x10(%ebp),%edx
8010599b:	89 10                	mov    %edx,(%eax)

    
    currPtr = p;
8010599d:	8b 45 10             	mov    0x10(%ebp),%eax
801059a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(currPtr != 0){
801059a3:	eb 2e                	jmp    801059d3 <tackToStateListTail+0x7a>
      currPtr->priority--;
801059a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a8:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801059ae:	8d 50 ff             	lea    -0x1(%eax),%edx
801059b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b4:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
801059ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059bd:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
801059c4:	01 00 00 

      currPtr = currPtr->next;
801059c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ca:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((*sList) == 0){
    (*sList) = p; // note that p's tail is not set to null since it is assumed its tail and its "next" children are set accordingly

    
    currPtr = p;
    while(currPtr != 0){
801059d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059d7:	75 cc                	jne    801059a5 <tackToStateListTail+0x4c>
801059d9:	eb 74                	jmp    80105a4f <tackToStateListTail+0xf6>
  // otherwise, find the tail and tack on p
  } else {
    while ((*sList) != 0) {
      
      // if tail is found then tack on p and return
      if ((*sList)->next == 0){
801059db:	8b 45 08             	mov    0x8(%ebp),%eax
801059de:	8b 00                	mov    (%eax),%eax
801059e0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059e6:	85 c0                	test   %eax,%eax
801059e8:	75 4c                	jne    80105a36 <tackToStateListTail+0xdd>
        (*sList)->next = p; // note that next is not set to null since it is assumed its tail and its "next" children are set accordingly
801059ea:	8b 45 08             	mov    0x8(%ebp),%eax
801059ed:	8b 00                	mov    (%eax),%eax
801059ef:	8b 55 10             	mov    0x10(%ebp),%edx
801059f2:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
         
        currPtr = p;
801059f8:	8b 45 10             	mov    0x10(%ebp),%eax
801059fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(currPtr != 0){
801059fe:	eb 2e                	jmp    80105a2e <tackToStateListTail+0xd5>
          currPtr->priority--;
80105a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a03:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105a09:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0f:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
          currPtr->budget = DEFAULT_BUDGET;
80105a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a18:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105a1f:	01 00 00 

          currPtr = currPtr->next;
80105a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a25:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      // if tail is found then tack on p and return
      if ((*sList)->next == 0){
        (*sList)->next = p; // note that next is not set to null since it is assumed its tail and its "next" children are set accordingly
         
        currPtr = p;
        while(currPtr != 0){
80105a2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a32:	75 cc                	jne    80105a00 <tackToStateListTail+0xa7>
          currPtr->budget = DEFAULT_BUDGET;

          currPtr = currPtr->next;
        }
        
        return;
80105a34:	eb 19                	jmp    80105a4f <tackToStateListTail+0xf6>
      }
      
      // otherwise, keep looping
      sList = &(*sList)->next;
80105a36:	8b 45 08             	mov    0x8(%ebp),%eax
80105a39:	8b 00                	mov    (%eax),%eax
80105a3b:	05 90 00 00 00       	add    $0x90,%eax
80105a40:	89 45 08             	mov    %eax,0x8(%ebp)
      currPtr = currPtr->next;
    }

  // otherwise, find the tail and tack on p
  } else {
    while ((*sList) != 0) {
80105a43:	8b 45 08             	mov    0x8(%ebp),%eax
80105a46:	8b 00                	mov    (%eax),%eax
80105a48:	85 c0                	test   %eax,%eax
80105a4a:	75 8f                	jne    801059db <tackToStateListTail+0x82>
80105a4c:	eb 01                	jmp    80105a4f <tackToStateListTail+0xf6>
{
  struct proc *currPtr = 0;

  // if p is null, then just return
  if (p == 0)
    return;
80105a4e:	90                   	nop
      
      // otherwise, keep looping
      sList = &(*sList)->next;
    }
  }
}
80105a4f:	c9                   	leave  
80105a50:	c3                   	ret    

80105a51 <findMatchingProcPID>:

// find a proc whose PID is equal to the specified PID
// this function searches through all lists except the free list (as mentioned in the mailing list)
struct proc*
findMatchingProcPID(uint pid)
{
80105a51:	55                   	push   %ebp
80105a52:	89 e5                	mov    %esp,%ebp
80105a54:	83 ec 10             	sub    $0x10,%esp
  struct proc *currPtr = 0; 
80105a57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
80105a5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105a65:	eb 3d                	jmp    80105aa4 <findMatchingProcPID+0x53>
    currPtr = ptable.pLists.ready[i];
80105a67:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105a6a:	05 cc 09 00 00       	add    $0x9cc,%eax
80105a6f:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80105a76:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while(currPtr != 0) {
80105a79:	eb 1f                	jmp    80105a9a <findMatchingProcPID+0x49>
      if (currPtr->pid == pid) // check if we found the proc
80105a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a7e:	8b 40 10             	mov    0x10(%eax),%eax
80105a81:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a84:	75 08                	jne    80105a8e <findMatchingProcPID+0x3d>
        return currPtr;
80105a86:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a89:	e9 d4 00 00 00       	jmp    80105b62 <findMatchingProcPID+0x111>

      currPtr = currPtr->next;
80105a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a91:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a97:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc *currPtr = 0; 

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
    currPtr = ptable.pLists.ready[i];
    while(currPtr != 0) {
80105a9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105a9e:	75 db                	jne    80105a7b <findMatchingProcPID+0x2a>
findMatchingProcPID(uint pid)
{
  struct proc *currPtr = 0; 

  // search through ready lists
  for (int i = 0; i < MAX + 1; ++i){ // Added for loop for Project 4: Periodic Priority Adjustment
80105aa0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105aa4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80105aa8:	7e bd                	jle    80105a67 <findMatchingProcPID+0x16>
      currPtr = currPtr->next;
    }
  }

  // search through sleep list
  currPtr = ptable.pLists.sleep;
80105aaa:	a1 bc 70 11 80       	mov    0x801170bc,%eax
80105aaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105ab2:	eb 1f                	jmp    80105ad3 <findMatchingProcPID+0x82>
    if (currPtr->pid == pid) // check if we found the proc
80105ab4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ab7:	8b 40 10             	mov    0x10(%eax),%eax
80105aba:	3b 45 08             	cmp    0x8(%ebp),%eax
80105abd:	75 08                	jne    80105ac7 <findMatchingProcPID+0x76>
      return currPtr;
80105abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ac2:	e9 9b 00 00 00       	jmp    80105b62 <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105ac7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aca:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ad0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    }
  }

  // search through sleep list
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0) {
80105ad3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105ad7:	75 db                	jne    80105ab4 <findMatchingProcPID+0x63>

    currPtr = currPtr->next;
  }

  // search through zombie list
  currPtr = ptable.pLists.zombie;
80105ad9:	a1 c0 70 11 80       	mov    0x801170c0,%eax
80105ade:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105ae1:	eb 1c                	jmp    80105aff <findMatchingProcPID+0xae>
    if (currPtr->pid == pid) // check if we found the proc
80105ae3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ae6:	8b 40 10             	mov    0x10(%eax),%eax
80105ae9:	3b 45 08             	cmp    0x8(%ebp),%eax
80105aec:	75 05                	jne    80105af3 <findMatchingProcPID+0xa2>
      return currPtr;
80105aee:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105af1:	eb 6f                	jmp    80105b62 <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105af3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105af6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105afc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through zombie list
  currPtr = ptable.pLists.zombie;
  while(currPtr != 0) {
80105aff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105b03:	75 de                	jne    80105ae3 <findMatchingProcPID+0x92>

    currPtr = currPtr->next;
  }

  // search through running list
  currPtr = ptable.pLists.running;
80105b05:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80105b0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105b0d:	eb 1c                	jmp    80105b2b <findMatchingProcPID+0xda>
    if (currPtr->pid == pid) // check if we found the proc
80105b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b12:	8b 40 10             	mov    0x10(%eax),%eax
80105b15:	3b 45 08             	cmp    0x8(%ebp),%eax
80105b18:	75 05                	jne    80105b1f <findMatchingProcPID+0xce>
      return currPtr;
80105b1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b1d:	eb 43                	jmp    80105b62 <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105b1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b22:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b28:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through running list
  currPtr = ptable.pLists.running;
  while(currPtr != 0) {
80105b2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105b2f:	75 de                	jne    80105b0f <findMatchingProcPID+0xbe>

    currPtr = currPtr->next;
  }

  // search through embryo list
  currPtr = ptable.pLists.embryo;
80105b31:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80105b36:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(currPtr != 0) {
80105b39:	eb 1c                	jmp    80105b57 <findMatchingProcPID+0x106>
    if (currPtr->pid == pid) // check if we found the proc
80105b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b3e:	8b 40 10             	mov    0x10(%eax),%eax
80105b41:	3b 45 08             	cmp    0x8(%ebp),%eax
80105b44:	75 05                	jne    80105b4b <findMatchingProcPID+0xfa>
      return currPtr;
80105b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b49:	eb 17                	jmp    80105b62 <findMatchingProcPID+0x111>

    currPtr = currPtr->next;
80105b4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b4e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b54:	89 45 fc             	mov    %eax,-0x4(%ebp)
    currPtr = currPtr->next;
  }

  // search through embryo list
  currPtr = ptable.pLists.embryo;
  while(currPtr != 0) {
80105b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105b5b:	75 de                	jne    80105b3b <findMatchingProcPID+0xea>

    currPtr = currPtr->next;
  }

  // if it isn't found then return null
  return 0;
80105b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b62:	c9                   	leave  
80105b63:	c3                   	ret    

80105b64 <setpriority>:
// sets process with pid to the specified priority. Also, this resets the budget of this process.
// only checks the RUNNING, SLEEPING, and RUNNABLE process (as mentioned in mailing list)
// returns 0 on success and -1 on error (e.g. didn't find process, or invalid params)
int
setpriority(int pid, int priority) // Added for Project 4: The setpriority() System Call
{
80105b64:	55                   	push   %ebp
80105b65:	89 e5                	mov    %esp,%ebp
80105b67:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0; 
80105b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  // check params to ensure no invalid input
  if (pid < 0 || priority < 0 || priority > MAX)
80105b71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105b75:	78 0c                	js     80105b83 <setpriority+0x1f>
80105b77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105b7b:	78 06                	js     80105b83 <setpriority+0x1f>
80105b7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105b81:	7e 0a                	jle    80105b8d <setpriority+0x29>
    return -1;
80105b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b88:	e9 53 01 00 00       	jmp    80105ce0 <setpriority+0x17c>

  acquire(&ptable.lock);
80105b8d:	83 ec 0c             	sub    $0xc,%esp
80105b90:	68 80 49 11 80       	push   $0x80114980
80105b95:	e8 ba 02 00 00       	call   80105e54 <acquire>
80105b9a:	83 c4 10             	add    $0x10,%esp
 
  // check running list for process pid
  currPtr = ptable.pLists.running;
80105b9d:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80105ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
80105ba5:	eb 4c                	jmp    80105bf3 <setpriority+0x8f>
    if(currPtr->pid == pid){
80105ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105baa:	8b 50 10             	mov    0x10(%eax),%edx
80105bad:	8b 45 08             	mov    0x8(%ebp),%eax
80105bb0:	39 c2                	cmp    %eax,%edx
80105bb2:	75 33                	jne    80105be7 <setpriority+0x83>
      currPtr->priority = priority;
80105bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
80105bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bba:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
80105bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc3:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105bca:	01 00 00 
      
      release(&ptable.lock); // since process was found, release lock and return 0 (success)
80105bcd:	83 ec 0c             	sub    $0xc,%esp
80105bd0:	68 80 49 11 80       	push   $0x80114980
80105bd5:	e8 e1 02 00 00       	call   80105ebb <release>
80105bda:	83 c4 10             	add    $0x10,%esp
      return 0;
80105bdd:	b8 00 00 00 00       	mov    $0x0,%eax
80105be2:	e9 f9 00 00 00       	jmp    80105ce0 <setpriority+0x17c>
    }

    currPtr = currPtr->next;
80105be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bea:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&ptable.lock);
 
  // check running list for process pid
  currPtr = ptable.pLists.running;
  while(currPtr != 0){
80105bf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bf7:	75 ae                	jne    80105ba7 <setpriority+0x43>

    currPtr = currPtr->next;
  }

  // check sleep list for process pid
  currPtr = ptable.pLists.sleep;
80105bf9:	a1 bc 70 11 80       	mov    0x801170bc,%eax
80105bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
80105c01:	eb 4c                	jmp    80105c4f <setpriority+0xeb>

    if(currPtr->pid == pid){
80105c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c06:	8b 50 10             	mov    0x10(%eax),%edx
80105c09:	8b 45 08             	mov    0x8(%ebp),%eax
80105c0c:	39 c2                	cmp    %eax,%edx
80105c0e:	75 33                	jne    80105c43 <setpriority+0xdf>
      currPtr->priority = priority;
80105c10:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c16:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      currPtr->budget = DEFAULT_BUDGET;
80105c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c1f:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105c26:	01 00 00 
      
      release(&ptable.lock); // since process was found, release lock and return 0 (success)
80105c29:	83 ec 0c             	sub    $0xc,%esp
80105c2c:	68 80 49 11 80       	push   $0x80114980
80105c31:	e8 85 02 00 00       	call   80105ebb <release>
80105c36:	83 c4 10             	add    $0x10,%esp
      return 0;
80105c39:	b8 00 00 00 00       	mov    $0x0,%eax
80105c3e:	e9 9d 00 00 00       	jmp    80105ce0 <setpriority+0x17c>
    }

    currPtr = currPtr->next;
80105c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c46:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // check sleep list for process pid
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0){
80105c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c53:	75 ae                	jne    80105c03 <setpriority+0x9f>
    }

    currPtr = currPtr->next;
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){
80105c55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105c5c:	eb 67                	jmp    80105cc5 <setpriority+0x161>

    currPtr = ptable.pLists.ready[i];
80105c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c61:	05 cc 09 00 00       	add    $0x9cc,%eax
80105c66:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80105c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(currPtr != 0){
80105c70:	eb 49                	jmp    80105cbb <setpriority+0x157>

      if(currPtr->pid == pid){
80105c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c75:	8b 50 10             	mov    0x10(%eax),%edx
80105c78:	8b 45 08             	mov    0x8(%ebp),%eax
80105c7b:	39 c2                	cmp    %eax,%edx
80105c7d:	75 30                	jne    80105caf <setpriority+0x14b>
        currPtr->priority = priority;
80105c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c85:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        currPtr->budget = DEFAULT_BUDGET;
80105c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c8e:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105c95:	01 00 00 
      
        release(&ptable.lock); // since process was found, release lock and return 0 (success)
80105c98:	83 ec 0c             	sub    $0xc,%esp
80105c9b:	68 80 49 11 80       	push   $0x80114980
80105ca0:	e8 16 02 00 00       	call   80105ebb <release>
80105ca5:	83 c4 10             	add    $0x10,%esp
        return 0;
80105ca8:	b8 00 00 00 00       	mov    $0x0,%eax
80105cad:	eb 31                	jmp    80105ce0 <setpriority+0x17c>
      }

      currPtr = currPtr->next;
80105caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){

    currPtr = ptable.pLists.ready[i];
    while(currPtr != 0){
80105cbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cbf:	75 b1                	jne    80105c72 <setpriority+0x10e>
    }

    currPtr = currPtr->next;
  }
  // check ready lists for process pid
  for(int i = 0; i < MAX + 1; ++i){
80105cc1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105cc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cc9:	7e 93                	jle    80105c5e <setpriority+0xfa>
      currPtr = currPtr->next;
    }
  }

  // if nothing was found, release lock and return -1 (error)
  release(&ptable.lock);
80105ccb:	83 ec 0c             	sub    $0xc,%esp
80105cce:	68 80 49 11 80       	push   $0x80114980
80105cd3:	e8 e3 01 00 00       	call   80105ebb <release>
80105cd8:	83 c4 10             	add    $0x10,%esp
  return -1;
80105cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ce0:	c9                   	leave  
80105ce1:	c3                   	ret    

80105ce2 <doPeriodicPromotion>:

// promote all processes within ready, sleeping, and running lists by 1 priority level (this is called from scheduler when we hit ticks threshold) 
void
doPeriodicPromotion(void) // Added for Project 4: Periodic Priority Adjustment
{
80105ce2:	55                   	push   %ebp
80105ce3:	89 e5                	mov    %esp,%ebp
80105ce5:	83 ec 18             	sub    $0x18,%esp
  struct proc *currPtr = 0;
80105ce8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
  // reduce priority of procs in running list (if they aren't at 0)
  currPtr = ptable.pLists.running;
80105cef:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80105cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (currPtr != 0){
80105cf7:	eb 3b                	jmp    80105d34 <doPeriodicPromotion+0x52>
    currPtr->budget = DEFAULT_BUDGET;
80105cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfc:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105d03:	01 00 00 

    if (currPtr->priority > 0){
80105d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d09:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105d0f:	85 c0                	test   %eax,%eax
80105d11:	74 15                	je     80105d28 <doPeriodicPromotion+0x46>
      currPtr->priority--;
80105d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d16:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105d1c:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d22:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    }
      
    currPtr = currPtr->next;
80105d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc *currPtr = 0;
  
  // reduce priority of procs in running list (if they aren't at 0)
  currPtr = ptable.pLists.running;
  while (currPtr != 0){
80105d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d38:	75 bf                	jne    80105cf9 <doPeriodicPromotion+0x17>
      
    currPtr = currPtr->next;
  }

  // reduce priority of procs in sleep list (if they aren't at 0), also reset budgets
  currPtr = ptable.pLists.sleep;
80105d3a:	a1 bc 70 11 80       	mov    0x801170bc,%eax
80105d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(currPtr != 0){
80105d42:	eb 3b                	jmp    80105d7f <doPeriodicPromotion+0x9d>
    currPtr->budget = DEFAULT_BUDGET;
80105d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d47:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105d4e:	01 00 00 
    
    if (currPtr->priority > 0)
80105d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d54:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105d5a:	85 c0                	test   %eax,%eax
80105d5c:	74 15                	je     80105d73 <doPeriodicPromotion+0x91>
      currPtr->priority--;
80105d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d61:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105d67:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d6d:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)

    currPtr = currPtr->next;
80105d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d76:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // reduce priority of procs in sleep list (if they aren't at 0), also reset budgets
  currPtr = ptable.pLists.sleep;
  while(currPtr != 0){
80105d7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d83:	75 bf                	jne    80105d44 <doPeriodicPromotion+0x62>

    currPtr = currPtr->next;
  }

  // reset budgets of procs already in ready[0] to prevent un-needed budget-resets in the below for/while loop
  currPtr = ptable.pLists.ready[0];
80105d85:	a1 b4 70 11 80       	mov    0x801170b4,%eax
80105d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (currPtr != 0){
80105d8d:	eb 19                	jmp    80105da8 <doPeriodicPromotion+0xc6>
    currPtr->budget = DEFAULT_BUDGET;
80105d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d92:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80105d99:	01 00 00 
    currPtr = currPtr->next;
80105d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d9f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    currPtr = currPtr->next;
  }

  // reset budgets of procs already in ready[0] to prevent un-needed budget-resets in the below for/while loop
  currPtr = ptable.pLists.ready[0];
  while (currPtr != 0){
80105da8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dac:	75 e1                	jne    80105d8f <doPeriodicPromotion+0xad>
    currPtr->budget = DEFAULT_BUDGET;
    currPtr = currPtr->next;
  }
  
  // move procs in priorities 1 through MAX + 1 up one level (and reset their budgets)
  for(int i = 1; i < MAX + 1; ++i)
80105dae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80105db5:	eb 3a                	jmp    80105df1 <doPeriodicPromotion+0x10f>
    tackToStateListTail(&ptable.pLists.ready[i - 1], RUNNABLE, ptable.pLists.ready[i]);
80105db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dba:	05 cc 09 00 00       	add    $0x9cc,%eax
80105dbf:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80105dc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105dc9:	83 ea 01             	sub    $0x1,%edx
80105dcc:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80105dd2:	c1 e2 02             	shl    $0x2,%edx
80105dd5:	81 c2 80 49 11 80    	add    $0x80114980,%edx
80105ddb:	83 c2 04             	add    $0x4,%edx
80105dde:	83 ec 04             	sub    $0x4,%esp
80105de1:	50                   	push   %eax
80105de2:	6a 03                	push   $0x3
80105de4:	52                   	push   %edx
80105de5:	e8 6f fb ff ff       	call   80105959 <tackToStateListTail>
80105dea:	83 c4 10             	add    $0x10,%esp
    currPtr->budget = DEFAULT_BUDGET;
    currPtr = currPtr->next;
  }
  
  // move procs in priorities 1 through MAX + 1 up one level (and reset their budgets)
  for(int i = 1; i < MAX + 1; ++i)
80105ded:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105df1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105df5:	7e c0                	jle    80105db7 <doPeriodicPromotion+0xd5>
    tackToStateListTail(&ptable.pLists.ready[i - 1], RUNNABLE, ptable.pLists.ready[i]);

}
80105df7:	90                   	nop
80105df8:	c9                   	leave  
80105df9:	c3                   	ret    

80105dfa <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105dfa:	55                   	push   %ebp
80105dfb:	89 e5                	mov    %esp,%ebp
80105dfd:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105e00:	9c                   	pushf  
80105e01:	58                   	pop    %eax
80105e02:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105e05:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105e08:	c9                   	leave  
80105e09:	c3                   	ret    

80105e0a <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105e0a:	55                   	push   %ebp
80105e0b:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105e0d:	fa                   	cli    
}
80105e0e:	90                   	nop
80105e0f:	5d                   	pop    %ebp
80105e10:	c3                   	ret    

80105e11 <sti>:

static inline void
sti(void)
{
80105e11:	55                   	push   %ebp
80105e12:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105e14:	fb                   	sti    
}
80105e15:	90                   	nop
80105e16:	5d                   	pop    %ebp
80105e17:	c3                   	ret    

80105e18 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105e18:	55                   	push   %ebp
80105e19:	89 e5                	mov    %esp,%ebp
80105e1b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105e1e:	8b 55 08             	mov    0x8(%ebp),%edx
80105e21:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e24:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105e27:	f0 87 02             	lock xchg %eax,(%edx)
80105e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105e30:	c9                   	leave  
80105e31:	c3                   	ret    

80105e32 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105e32:	55                   	push   %ebp
80105e33:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105e35:	8b 45 08             	mov    0x8(%ebp),%eax
80105e38:	8b 55 0c             	mov    0xc(%ebp),%edx
80105e3b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105e3e:	8b 45 08             	mov    0x8(%ebp),%eax
80105e41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105e47:	8b 45 08             	mov    0x8(%ebp),%eax
80105e4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105e51:	90                   	nop
80105e52:	5d                   	pop    %ebp
80105e53:	c3                   	ret    

80105e54 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105e54:	55                   	push   %ebp
80105e55:	89 e5                	mov    %esp,%ebp
80105e57:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105e5a:	e8 52 01 00 00       	call   80105fb1 <pushcli>
  if(holding(lk))
80105e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80105e62:	83 ec 0c             	sub    $0xc,%esp
80105e65:	50                   	push   %eax
80105e66:	e8 1c 01 00 00       	call   80105f87 <holding>
80105e6b:	83 c4 10             	add    $0x10,%esp
80105e6e:	85 c0                	test   %eax,%eax
80105e70:	74 0d                	je     80105e7f <acquire+0x2b>
    panic("acquire");
80105e72:	83 ec 0c             	sub    $0xc,%esp
80105e75:	68 14 9e 10 80       	push   $0x80109e14
80105e7a:	e8 e7 a6 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105e7f:	90                   	nop
80105e80:	8b 45 08             	mov    0x8(%ebp),%eax
80105e83:	83 ec 08             	sub    $0x8,%esp
80105e86:	6a 01                	push   $0x1
80105e88:	50                   	push   %eax
80105e89:	e8 8a ff ff ff       	call   80105e18 <xchg>
80105e8e:	83 c4 10             	add    $0x10,%esp
80105e91:	85 c0                	test   %eax,%eax
80105e93:	75 eb                	jne    80105e80 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105e95:	8b 45 08             	mov    0x8(%ebp),%eax
80105e98:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105e9f:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ea5:	83 c0 0c             	add    $0xc,%eax
80105ea8:	83 ec 08             	sub    $0x8,%esp
80105eab:	50                   	push   %eax
80105eac:	8d 45 08             	lea    0x8(%ebp),%eax
80105eaf:	50                   	push   %eax
80105eb0:	e8 58 00 00 00       	call   80105f0d <getcallerpcs>
80105eb5:	83 c4 10             	add    $0x10,%esp
}
80105eb8:	90                   	nop
80105eb9:	c9                   	leave  
80105eba:	c3                   	ret    

80105ebb <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105ebb:	55                   	push   %ebp
80105ebc:	89 e5                	mov    %esp,%ebp
80105ebe:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105ec1:	83 ec 0c             	sub    $0xc,%esp
80105ec4:	ff 75 08             	pushl  0x8(%ebp)
80105ec7:	e8 bb 00 00 00       	call   80105f87 <holding>
80105ecc:	83 c4 10             	add    $0x10,%esp
80105ecf:	85 c0                	test   %eax,%eax
80105ed1:	75 0d                	jne    80105ee0 <release+0x25>
    panic("release");
80105ed3:	83 ec 0c             	sub    $0xc,%esp
80105ed6:	68 1c 9e 10 80       	push   $0x80109e1c
80105edb:	e8 86 a6 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80105ee3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105eea:	8b 45 08             	mov    0x8(%ebp),%eax
80105eed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105ef4:	8b 45 08             	mov    0x8(%ebp),%eax
80105ef7:	83 ec 08             	sub    $0x8,%esp
80105efa:	6a 00                	push   $0x0
80105efc:	50                   	push   %eax
80105efd:	e8 16 ff ff ff       	call   80105e18 <xchg>
80105f02:	83 c4 10             	add    $0x10,%esp

  popcli();
80105f05:	e8 ec 00 00 00       	call   80105ff6 <popcli>
}
80105f0a:	90                   	nop
80105f0b:	c9                   	leave  
80105f0c:	c3                   	ret    

80105f0d <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105f0d:	55                   	push   %ebp
80105f0e:	89 e5                	mov    %esp,%ebp
80105f10:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105f13:	8b 45 08             	mov    0x8(%ebp),%eax
80105f16:	83 e8 08             	sub    $0x8,%eax
80105f19:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105f1c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105f23:	eb 38                	jmp    80105f5d <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105f25:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105f29:	74 53                	je     80105f7e <getcallerpcs+0x71>
80105f2b:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105f32:	76 4a                	jbe    80105f7e <getcallerpcs+0x71>
80105f34:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105f38:	74 44                	je     80105f7e <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105f44:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f47:	01 c2                	add    %eax,%edx
80105f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f4c:	8b 40 04             	mov    0x4(%eax),%eax
80105f4f:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f54:	8b 00                	mov    (%eax),%eax
80105f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105f59:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105f5d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105f61:	7e c2                	jle    80105f25 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105f63:	eb 19                	jmp    80105f7e <getcallerpcs+0x71>
    pcs[i] = 0;
80105f65:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f72:	01 d0                	add    %edx,%eax
80105f74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105f7a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105f7e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105f82:	7e e1                	jle    80105f65 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105f84:	90                   	nop
80105f85:	c9                   	leave  
80105f86:	c3                   	ret    

80105f87 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105f87:	55                   	push   %ebp
80105f88:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80105f8d:	8b 00                	mov    (%eax),%eax
80105f8f:	85 c0                	test   %eax,%eax
80105f91:	74 17                	je     80105faa <holding+0x23>
80105f93:	8b 45 08             	mov    0x8(%ebp),%eax
80105f96:	8b 50 08             	mov    0x8(%eax),%edx
80105f99:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105f9f:	39 c2                	cmp    %eax,%edx
80105fa1:	75 07                	jne    80105faa <holding+0x23>
80105fa3:	b8 01 00 00 00       	mov    $0x1,%eax
80105fa8:	eb 05                	jmp    80105faf <holding+0x28>
80105faa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105faf:	5d                   	pop    %ebp
80105fb0:	c3                   	ret    

80105fb1 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105fb1:	55                   	push   %ebp
80105fb2:	89 e5                	mov    %esp,%ebp
80105fb4:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105fb7:	e8 3e fe ff ff       	call   80105dfa <readeflags>
80105fbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105fbf:	e8 46 fe ff ff       	call   80105e0a <cli>
  if(cpu->ncli++ == 0)
80105fc4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105fcb:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105fd1:	8d 48 01             	lea    0x1(%eax),%ecx
80105fd4:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105fda:	85 c0                	test   %eax,%eax
80105fdc:	75 15                	jne    80105ff3 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105fde:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105fe4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105fe7:	81 e2 00 02 00 00    	and    $0x200,%edx
80105fed:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105ff3:	90                   	nop
80105ff4:	c9                   	leave  
80105ff5:	c3                   	ret    

80105ff6 <popcli>:

void
popcli(void)
{
80105ff6:	55                   	push   %ebp
80105ff7:	89 e5                	mov    %esp,%ebp
80105ff9:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105ffc:	e8 f9 fd ff ff       	call   80105dfa <readeflags>
80106001:	25 00 02 00 00       	and    $0x200,%eax
80106006:	85 c0                	test   %eax,%eax
80106008:	74 0d                	je     80106017 <popcli+0x21>
    panic("popcli - interruptible");
8010600a:	83 ec 0c             	sub    $0xc,%esp
8010600d:	68 24 9e 10 80       	push   $0x80109e24
80106012:	e8 4f a5 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106017:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010601d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106023:	83 ea 01             	sub    $0x1,%edx
80106026:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010602c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106032:	85 c0                	test   %eax,%eax
80106034:	79 0d                	jns    80106043 <popcli+0x4d>
    panic("popcli");
80106036:	83 ec 0c             	sub    $0xc,%esp
80106039:	68 3b 9e 10 80       	push   $0x80109e3b
8010603e:	e8 23 a5 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106043:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106049:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010604f:	85 c0                	test   %eax,%eax
80106051:	75 15                	jne    80106068 <popcli+0x72>
80106053:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106059:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010605f:	85 c0                	test   %eax,%eax
80106061:	74 05                	je     80106068 <popcli+0x72>
    sti();
80106063:	e8 a9 fd ff ff       	call   80105e11 <sti>
}
80106068:	90                   	nop
80106069:	c9                   	leave  
8010606a:	c3                   	ret    

8010606b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010606b:	55                   	push   %ebp
8010606c:	89 e5                	mov    %esp,%ebp
8010606e:	57                   	push   %edi
8010606f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106070:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106073:	8b 55 10             	mov    0x10(%ebp),%edx
80106076:	8b 45 0c             	mov    0xc(%ebp),%eax
80106079:	89 cb                	mov    %ecx,%ebx
8010607b:	89 df                	mov    %ebx,%edi
8010607d:	89 d1                	mov    %edx,%ecx
8010607f:	fc                   	cld    
80106080:	f3 aa                	rep stos %al,%es:(%edi)
80106082:	89 ca                	mov    %ecx,%edx
80106084:	89 fb                	mov    %edi,%ebx
80106086:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106089:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010608c:	90                   	nop
8010608d:	5b                   	pop    %ebx
8010608e:	5f                   	pop    %edi
8010608f:	5d                   	pop    %ebp
80106090:	c3                   	ret    

80106091 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106091:	55                   	push   %ebp
80106092:	89 e5                	mov    %esp,%ebp
80106094:	57                   	push   %edi
80106095:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106096:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106099:	8b 55 10             	mov    0x10(%ebp),%edx
8010609c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010609f:	89 cb                	mov    %ecx,%ebx
801060a1:	89 df                	mov    %ebx,%edi
801060a3:	89 d1                	mov    %edx,%ecx
801060a5:	fc                   	cld    
801060a6:	f3 ab                	rep stos %eax,%es:(%edi)
801060a8:	89 ca                	mov    %ecx,%edx
801060aa:	89 fb                	mov    %edi,%ebx
801060ac:	89 5d 08             	mov    %ebx,0x8(%ebp)
801060af:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801060b2:	90                   	nop
801060b3:	5b                   	pop    %ebx
801060b4:	5f                   	pop    %edi
801060b5:	5d                   	pop    %ebp
801060b6:	c3                   	ret    

801060b7 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801060b7:	55                   	push   %ebp
801060b8:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801060ba:	8b 45 08             	mov    0x8(%ebp),%eax
801060bd:	83 e0 03             	and    $0x3,%eax
801060c0:	85 c0                	test   %eax,%eax
801060c2:	75 43                	jne    80106107 <memset+0x50>
801060c4:	8b 45 10             	mov    0x10(%ebp),%eax
801060c7:	83 e0 03             	and    $0x3,%eax
801060ca:	85 c0                	test   %eax,%eax
801060cc:	75 39                	jne    80106107 <memset+0x50>
    c &= 0xFF;
801060ce:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801060d5:	8b 45 10             	mov    0x10(%ebp),%eax
801060d8:	c1 e8 02             	shr    $0x2,%eax
801060db:	89 c1                	mov    %eax,%ecx
801060dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801060e0:	c1 e0 18             	shl    $0x18,%eax
801060e3:	89 c2                	mov    %eax,%edx
801060e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801060e8:	c1 e0 10             	shl    $0x10,%eax
801060eb:	09 c2                	or     %eax,%edx
801060ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801060f0:	c1 e0 08             	shl    $0x8,%eax
801060f3:	09 d0                	or     %edx,%eax
801060f5:	0b 45 0c             	or     0xc(%ebp),%eax
801060f8:	51                   	push   %ecx
801060f9:	50                   	push   %eax
801060fa:	ff 75 08             	pushl  0x8(%ebp)
801060fd:	e8 8f ff ff ff       	call   80106091 <stosl>
80106102:	83 c4 0c             	add    $0xc,%esp
80106105:	eb 12                	jmp    80106119 <memset+0x62>
  } else
    stosb(dst, c, n);
80106107:	8b 45 10             	mov    0x10(%ebp),%eax
8010610a:	50                   	push   %eax
8010610b:	ff 75 0c             	pushl  0xc(%ebp)
8010610e:	ff 75 08             	pushl  0x8(%ebp)
80106111:	e8 55 ff ff ff       	call   8010606b <stosb>
80106116:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106119:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010611c:	c9                   	leave  
8010611d:	c3                   	ret    

8010611e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010611e:	55                   	push   %ebp
8010611f:	89 e5                	mov    %esp,%ebp
80106121:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106124:	8b 45 08             	mov    0x8(%ebp),%eax
80106127:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010612a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010612d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106130:	eb 30                	jmp    80106162 <memcmp+0x44>
    if(*s1 != *s2)
80106132:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106135:	0f b6 10             	movzbl (%eax),%edx
80106138:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010613b:	0f b6 00             	movzbl (%eax),%eax
8010613e:	38 c2                	cmp    %al,%dl
80106140:	74 18                	je     8010615a <memcmp+0x3c>
      return *s1 - *s2;
80106142:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106145:	0f b6 00             	movzbl (%eax),%eax
80106148:	0f b6 d0             	movzbl %al,%edx
8010614b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010614e:	0f b6 00             	movzbl (%eax),%eax
80106151:	0f b6 c0             	movzbl %al,%eax
80106154:	29 c2                	sub    %eax,%edx
80106156:	89 d0                	mov    %edx,%eax
80106158:	eb 1a                	jmp    80106174 <memcmp+0x56>
    s1++, s2++;
8010615a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010615e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106162:	8b 45 10             	mov    0x10(%ebp),%eax
80106165:	8d 50 ff             	lea    -0x1(%eax),%edx
80106168:	89 55 10             	mov    %edx,0x10(%ebp)
8010616b:	85 c0                	test   %eax,%eax
8010616d:	75 c3                	jne    80106132 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010616f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106174:	c9                   	leave  
80106175:	c3                   	ret    

80106176 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106176:	55                   	push   %ebp
80106177:	89 e5                	mov    %esp,%ebp
80106179:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010617c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010617f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106182:	8b 45 08             	mov    0x8(%ebp),%eax
80106185:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106188:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010618b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010618e:	73 54                	jae    801061e4 <memmove+0x6e>
80106190:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106193:	8b 45 10             	mov    0x10(%ebp),%eax
80106196:	01 d0                	add    %edx,%eax
80106198:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010619b:	76 47                	jbe    801061e4 <memmove+0x6e>
    s += n;
8010619d:	8b 45 10             	mov    0x10(%ebp),%eax
801061a0:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801061a3:	8b 45 10             	mov    0x10(%ebp),%eax
801061a6:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801061a9:	eb 13                	jmp    801061be <memmove+0x48>
      *--d = *--s;
801061ab:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801061af:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801061b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061b6:	0f b6 10             	movzbl (%eax),%edx
801061b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801061bc:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801061be:	8b 45 10             	mov    0x10(%ebp),%eax
801061c1:	8d 50 ff             	lea    -0x1(%eax),%edx
801061c4:	89 55 10             	mov    %edx,0x10(%ebp)
801061c7:	85 c0                	test   %eax,%eax
801061c9:	75 e0                	jne    801061ab <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801061cb:	eb 24                	jmp    801061f1 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801061cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801061d0:	8d 50 01             	lea    0x1(%eax),%edx
801061d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
801061d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801061d9:	8d 4a 01             	lea    0x1(%edx),%ecx
801061dc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801061df:	0f b6 12             	movzbl (%edx),%edx
801061e2:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801061e4:	8b 45 10             	mov    0x10(%ebp),%eax
801061e7:	8d 50 ff             	lea    -0x1(%eax),%edx
801061ea:	89 55 10             	mov    %edx,0x10(%ebp)
801061ed:	85 c0                	test   %eax,%eax
801061ef:	75 dc                	jne    801061cd <memmove+0x57>
      *d++ = *s++;

  return dst;
801061f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801061f4:	c9                   	leave  
801061f5:	c3                   	ret    

801061f6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801061f6:	55                   	push   %ebp
801061f7:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801061f9:	ff 75 10             	pushl  0x10(%ebp)
801061fc:	ff 75 0c             	pushl  0xc(%ebp)
801061ff:	ff 75 08             	pushl  0x8(%ebp)
80106202:	e8 6f ff ff ff       	call   80106176 <memmove>
80106207:	83 c4 0c             	add    $0xc,%esp
}
8010620a:	c9                   	leave  
8010620b:	c3                   	ret    

8010620c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010620c:	55                   	push   %ebp
8010620d:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010620f:	eb 0c                	jmp    8010621d <strncmp+0x11>
    n--, p++, q++;
80106211:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106215:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106219:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010621d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106221:	74 1a                	je     8010623d <strncmp+0x31>
80106223:	8b 45 08             	mov    0x8(%ebp),%eax
80106226:	0f b6 00             	movzbl (%eax),%eax
80106229:	84 c0                	test   %al,%al
8010622b:	74 10                	je     8010623d <strncmp+0x31>
8010622d:	8b 45 08             	mov    0x8(%ebp),%eax
80106230:	0f b6 10             	movzbl (%eax),%edx
80106233:	8b 45 0c             	mov    0xc(%ebp),%eax
80106236:	0f b6 00             	movzbl (%eax),%eax
80106239:	38 c2                	cmp    %al,%dl
8010623b:	74 d4                	je     80106211 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010623d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106241:	75 07                	jne    8010624a <strncmp+0x3e>
    return 0;
80106243:	b8 00 00 00 00       	mov    $0x0,%eax
80106248:	eb 16                	jmp    80106260 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010624a:	8b 45 08             	mov    0x8(%ebp),%eax
8010624d:	0f b6 00             	movzbl (%eax),%eax
80106250:	0f b6 d0             	movzbl %al,%edx
80106253:	8b 45 0c             	mov    0xc(%ebp),%eax
80106256:	0f b6 00             	movzbl (%eax),%eax
80106259:	0f b6 c0             	movzbl %al,%eax
8010625c:	29 c2                	sub    %eax,%edx
8010625e:	89 d0                	mov    %edx,%eax
}
80106260:	5d                   	pop    %ebp
80106261:	c3                   	ret    

80106262 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106262:	55                   	push   %ebp
80106263:	89 e5                	mov    %esp,%ebp
80106265:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106268:	8b 45 08             	mov    0x8(%ebp),%eax
8010626b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010626e:	90                   	nop
8010626f:	8b 45 10             	mov    0x10(%ebp),%eax
80106272:	8d 50 ff             	lea    -0x1(%eax),%edx
80106275:	89 55 10             	mov    %edx,0x10(%ebp)
80106278:	85 c0                	test   %eax,%eax
8010627a:	7e 2c                	jle    801062a8 <strncpy+0x46>
8010627c:	8b 45 08             	mov    0x8(%ebp),%eax
8010627f:	8d 50 01             	lea    0x1(%eax),%edx
80106282:	89 55 08             	mov    %edx,0x8(%ebp)
80106285:	8b 55 0c             	mov    0xc(%ebp),%edx
80106288:	8d 4a 01             	lea    0x1(%edx),%ecx
8010628b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010628e:	0f b6 12             	movzbl (%edx),%edx
80106291:	88 10                	mov    %dl,(%eax)
80106293:	0f b6 00             	movzbl (%eax),%eax
80106296:	84 c0                	test   %al,%al
80106298:	75 d5                	jne    8010626f <strncpy+0xd>
    ;
  while(n-- > 0)
8010629a:	eb 0c                	jmp    801062a8 <strncpy+0x46>
    *s++ = 0;
8010629c:	8b 45 08             	mov    0x8(%ebp),%eax
8010629f:	8d 50 01             	lea    0x1(%eax),%edx
801062a2:	89 55 08             	mov    %edx,0x8(%ebp)
801062a5:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801062a8:	8b 45 10             	mov    0x10(%ebp),%eax
801062ab:	8d 50 ff             	lea    -0x1(%eax),%edx
801062ae:	89 55 10             	mov    %edx,0x10(%ebp)
801062b1:	85 c0                	test   %eax,%eax
801062b3:	7f e7                	jg     8010629c <strncpy+0x3a>
    *s++ = 0;
  return os;
801062b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801062b8:	c9                   	leave  
801062b9:	c3                   	ret    

801062ba <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801062ba:	55                   	push   %ebp
801062bb:	89 e5                	mov    %esp,%ebp
801062bd:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801062c0:	8b 45 08             	mov    0x8(%ebp),%eax
801062c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801062c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801062ca:	7f 05                	jg     801062d1 <safestrcpy+0x17>
    return os;
801062cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062cf:	eb 31                	jmp    80106302 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801062d1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801062d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801062d9:	7e 1e                	jle    801062f9 <safestrcpy+0x3f>
801062db:	8b 45 08             	mov    0x8(%ebp),%eax
801062de:	8d 50 01             	lea    0x1(%eax),%edx
801062e1:	89 55 08             	mov    %edx,0x8(%ebp)
801062e4:	8b 55 0c             	mov    0xc(%ebp),%edx
801062e7:	8d 4a 01             	lea    0x1(%edx),%ecx
801062ea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801062ed:	0f b6 12             	movzbl (%edx),%edx
801062f0:	88 10                	mov    %dl,(%eax)
801062f2:	0f b6 00             	movzbl (%eax),%eax
801062f5:	84 c0                	test   %al,%al
801062f7:	75 d8                	jne    801062d1 <safestrcpy+0x17>
    ;
  *s = 0;
801062f9:	8b 45 08             	mov    0x8(%ebp),%eax
801062fc:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801062ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106302:	c9                   	leave  
80106303:	c3                   	ret    

80106304 <strlen>:

int
strlen(const char *s)
{
80106304:	55                   	push   %ebp
80106305:	89 e5                	mov    %esp,%ebp
80106307:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010630a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106311:	eb 04                	jmp    80106317 <strlen+0x13>
80106313:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106317:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010631a:	8b 45 08             	mov    0x8(%ebp),%eax
8010631d:	01 d0                	add    %edx,%eax
8010631f:	0f b6 00             	movzbl (%eax),%eax
80106322:	84 c0                	test   %al,%al
80106324:	75 ed                	jne    80106313 <strlen+0xf>
    ;
  return n;
80106326:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106329:	c9                   	leave  
8010632a:	c3                   	ret    

8010632b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010632b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010632f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106333:	55                   	push   %ebp
  pushl %ebx
80106334:	53                   	push   %ebx
  pushl %esi
80106335:	56                   	push   %esi
  pushl %edi
80106336:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106337:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106339:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010633b:	5f                   	pop    %edi
  popl %esi
8010633c:	5e                   	pop    %esi
  popl %ebx
8010633d:	5b                   	pop    %ebx
  popl %ebp
8010633e:	5d                   	pop    %ebp
  ret
8010633f:	c3                   	ret    

80106340 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106340:	55                   	push   %ebp
80106341:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106343:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106349:	8b 00                	mov    (%eax),%eax
8010634b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010634e:	76 12                	jbe    80106362 <fetchint+0x22>
80106350:	8b 45 08             	mov    0x8(%ebp),%eax
80106353:	8d 50 04             	lea    0x4(%eax),%edx
80106356:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010635c:	8b 00                	mov    (%eax),%eax
8010635e:	39 c2                	cmp    %eax,%edx
80106360:	76 07                	jbe    80106369 <fetchint+0x29>
    return -1;
80106362:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106367:	eb 0f                	jmp    80106378 <fetchint+0x38>
  *ip = *(int*)(addr);
80106369:	8b 45 08             	mov    0x8(%ebp),%eax
8010636c:	8b 10                	mov    (%eax),%edx
8010636e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106371:	89 10                	mov    %edx,(%eax)
  return 0;
80106373:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106378:	5d                   	pop    %ebp
80106379:	c3                   	ret    

8010637a <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010637a:	55                   	push   %ebp
8010637b:	89 e5                	mov    %esp,%ebp
8010637d:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106380:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106386:	8b 00                	mov    (%eax),%eax
80106388:	3b 45 08             	cmp    0x8(%ebp),%eax
8010638b:	77 07                	ja     80106394 <fetchstr+0x1a>
    return -1;
8010638d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106392:	eb 46                	jmp    801063da <fetchstr+0x60>
  *pp = (char*)addr;
80106394:	8b 55 08             	mov    0x8(%ebp),%edx
80106397:	8b 45 0c             	mov    0xc(%ebp),%eax
8010639a:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010639c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063a2:	8b 00                	mov    (%eax),%eax
801063a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801063a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801063aa:	8b 00                	mov    (%eax),%eax
801063ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
801063af:	eb 1c                	jmp    801063cd <fetchstr+0x53>
    if(*s == 0)
801063b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801063b4:	0f b6 00             	movzbl (%eax),%eax
801063b7:	84 c0                	test   %al,%al
801063b9:	75 0e                	jne    801063c9 <fetchstr+0x4f>
      return s - *pp;
801063bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801063be:	8b 45 0c             	mov    0xc(%ebp),%eax
801063c1:	8b 00                	mov    (%eax),%eax
801063c3:	29 c2                	sub    %eax,%edx
801063c5:	89 d0                	mov    %edx,%eax
801063c7:	eb 11                	jmp    801063da <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801063c9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801063cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801063d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801063d3:	72 dc                	jb     801063b1 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801063d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063da:	c9                   	leave  
801063db:	c3                   	ret    

801063dc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801063dc:	55                   	push   %ebp
801063dd:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801063df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063e5:	8b 40 18             	mov    0x18(%eax),%eax
801063e8:	8b 40 44             	mov    0x44(%eax),%eax
801063eb:	8b 55 08             	mov    0x8(%ebp),%edx
801063ee:	c1 e2 02             	shl    $0x2,%edx
801063f1:	01 d0                	add    %edx,%eax
801063f3:	83 c0 04             	add    $0x4,%eax
801063f6:	ff 75 0c             	pushl  0xc(%ebp)
801063f9:	50                   	push   %eax
801063fa:	e8 41 ff ff ff       	call   80106340 <fetchint>
801063ff:	83 c4 08             	add    $0x8,%esp
}
80106402:	c9                   	leave  
80106403:	c3                   	ret    

80106404 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106404:	55                   	push   %ebp
80106405:	89 e5                	mov    %esp,%ebp
80106407:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010640a:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010640d:	50                   	push   %eax
8010640e:	ff 75 08             	pushl  0x8(%ebp)
80106411:	e8 c6 ff ff ff       	call   801063dc <argint>
80106416:	83 c4 08             	add    $0x8,%esp
80106419:	85 c0                	test   %eax,%eax
8010641b:	79 07                	jns    80106424 <argptr+0x20>
    return -1;
8010641d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106422:	eb 3b                	jmp    8010645f <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106424:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010642a:	8b 00                	mov    (%eax),%eax
8010642c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010642f:	39 d0                	cmp    %edx,%eax
80106431:	76 16                	jbe    80106449 <argptr+0x45>
80106433:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106436:	89 c2                	mov    %eax,%edx
80106438:	8b 45 10             	mov    0x10(%ebp),%eax
8010643b:	01 c2                	add    %eax,%edx
8010643d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106443:	8b 00                	mov    (%eax),%eax
80106445:	39 c2                	cmp    %eax,%edx
80106447:	76 07                	jbe    80106450 <argptr+0x4c>
    return -1;
80106449:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010644e:	eb 0f                	jmp    8010645f <argptr+0x5b>
  *pp = (char*)i;
80106450:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106453:	89 c2                	mov    %eax,%edx
80106455:	8b 45 0c             	mov    0xc(%ebp),%eax
80106458:	89 10                	mov    %edx,(%eax)
  return 0;
8010645a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010645f:	c9                   	leave  
80106460:	c3                   	ret    

80106461 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106461:	55                   	push   %ebp
80106462:	89 e5                	mov    %esp,%ebp
80106464:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106467:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010646a:	50                   	push   %eax
8010646b:	ff 75 08             	pushl  0x8(%ebp)
8010646e:	e8 69 ff ff ff       	call   801063dc <argint>
80106473:	83 c4 08             	add    $0x8,%esp
80106476:	85 c0                	test   %eax,%eax
80106478:	79 07                	jns    80106481 <argstr+0x20>
    return -1;
8010647a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010647f:	eb 0f                	jmp    80106490 <argstr+0x2f>
  return fetchstr(addr, pp);
80106481:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106484:	ff 75 0c             	pushl  0xc(%ebp)
80106487:	50                   	push   %eax
80106488:	e8 ed fe ff ff       	call   8010637a <fetchstr>
8010648d:	83 c4 08             	add    $0x8,%esp
}
80106490:	c9                   	leave  
80106491:	c3                   	ret    

80106492 <syscall>:
#endif
// END: Added for Project 1: System Call Tracing

void
syscall(void)
{
80106492:	55                   	push   %ebp
80106493:	89 e5                	mov    %esp,%ebp
80106495:	53                   	push   %ebx
80106496:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106499:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010649f:	8b 40 18             	mov    0x18(%eax),%eax
801064a2:	8b 40 1c             	mov    0x1c(%eax),%eax
801064a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801064a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064ac:	7e 30                	jle    801064de <syscall+0x4c>
801064ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b1:	83 f8 1e             	cmp    $0x1e,%eax
801064b4:	77 28                	ja     801064de <syscall+0x4c>
801064b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b9:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801064c0:	85 c0                	test   %eax,%eax
801064c2:	74 1a                	je     801064de <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801064c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064ca:	8b 58 18             	mov    0x18(%eax),%ebx
801064cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d0:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801064d7:	ff d0                	call   *%eax
801064d9:	89 43 1c             	mov    %eax,0x1c(%ebx)
801064dc:	eb 34                	jmp    80106512 <syscall+0x80>
    #endif
    // END: Added for Project 1: System Call Tracing

  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801064de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064e4:	8d 50 6c             	lea    0x6c(%eax),%edx
801064e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
            syscallnames[num], proc->tf->eax);
    #endif
    // END: Added for Project 1: System Call Tracing

  } else {
    cprintf("%d %s: unknown sys call %d\n",
801064ed:	8b 40 10             	mov    0x10(%eax),%eax
801064f0:	ff 75 f4             	pushl  -0xc(%ebp)
801064f3:	52                   	push   %edx
801064f4:	50                   	push   %eax
801064f5:	68 42 9e 10 80       	push   $0x80109e42
801064fa:	e8 c7 9e ff ff       	call   801003c6 <cprintf>
801064ff:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106502:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106508:	8b 40 18             	mov    0x18(%eax),%eax
8010650b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106512:	90                   	nop
80106513:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106516:	c9                   	leave  
80106517:	c3                   	ret    

80106518 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106518:	55                   	push   %ebp
80106519:	89 e5                	mov    %esp,%ebp
8010651b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010651e:	83 ec 08             	sub    $0x8,%esp
80106521:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106524:	50                   	push   %eax
80106525:	ff 75 08             	pushl  0x8(%ebp)
80106528:	e8 af fe ff ff       	call   801063dc <argint>
8010652d:	83 c4 10             	add    $0x10,%esp
80106530:	85 c0                	test   %eax,%eax
80106532:	79 07                	jns    8010653b <argfd+0x23>
    return -1;
80106534:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106539:	eb 50                	jmp    8010658b <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010653b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010653e:	85 c0                	test   %eax,%eax
80106540:	78 21                	js     80106563 <argfd+0x4b>
80106542:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106545:	83 f8 0f             	cmp    $0xf,%eax
80106548:	7f 19                	jg     80106563 <argfd+0x4b>
8010654a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106550:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106553:	83 c2 08             	add    $0x8,%edx
80106556:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010655a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010655d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106561:	75 07                	jne    8010656a <argfd+0x52>
    return -1;
80106563:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106568:	eb 21                	jmp    8010658b <argfd+0x73>
  if(pfd)
8010656a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010656e:	74 08                	je     80106578 <argfd+0x60>
    *pfd = fd;
80106570:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106573:	8b 45 0c             	mov    0xc(%ebp),%eax
80106576:	89 10                	mov    %edx,(%eax)
  if(pf)
80106578:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010657c:	74 08                	je     80106586 <argfd+0x6e>
    *pf = f;
8010657e:	8b 45 10             	mov    0x10(%ebp),%eax
80106581:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106584:	89 10                	mov    %edx,(%eax)
  return 0;
80106586:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010658b:	c9                   	leave  
8010658c:	c3                   	ret    

8010658d <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010658d:	55                   	push   %ebp
8010658e:	89 e5                	mov    %esp,%ebp
80106590:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106593:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010659a:	eb 30                	jmp    801065cc <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010659c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801065a5:	83 c2 08             	add    $0x8,%edx
801065a8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801065ac:	85 c0                	test   %eax,%eax
801065ae:	75 18                	jne    801065c8 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801065b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801065b9:	8d 4a 08             	lea    0x8(%edx),%ecx
801065bc:	8b 55 08             	mov    0x8(%ebp),%edx
801065bf:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801065c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065c6:	eb 0f                	jmp    801065d7 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801065c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801065cc:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801065d0:	7e ca                	jle    8010659c <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801065d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065d7:	c9                   	leave  
801065d8:	c3                   	ret    

801065d9 <sys_dup>:

int
sys_dup(void)
{
801065d9:	55                   	push   %ebp
801065da:	89 e5                	mov    %esp,%ebp
801065dc:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801065df:	83 ec 04             	sub    $0x4,%esp
801065e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065e5:	50                   	push   %eax
801065e6:	6a 00                	push   $0x0
801065e8:	6a 00                	push   $0x0
801065ea:	e8 29 ff ff ff       	call   80106518 <argfd>
801065ef:	83 c4 10             	add    $0x10,%esp
801065f2:	85 c0                	test   %eax,%eax
801065f4:	79 07                	jns    801065fd <sys_dup+0x24>
    return -1;
801065f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065fb:	eb 31                	jmp    8010662e <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801065fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106600:	83 ec 0c             	sub    $0xc,%esp
80106603:	50                   	push   %eax
80106604:	e8 84 ff ff ff       	call   8010658d <fdalloc>
80106609:	83 c4 10             	add    $0x10,%esp
8010660c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010660f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106613:	79 07                	jns    8010661c <sys_dup+0x43>
    return -1;
80106615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010661a:	eb 12                	jmp    8010662e <sys_dup+0x55>
  filedup(f);
8010661c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010661f:	83 ec 0c             	sub    $0xc,%esp
80106622:	50                   	push   %eax
80106623:	e8 1a ab ff ff       	call   80101142 <filedup>
80106628:	83 c4 10             	add    $0x10,%esp
  return fd;
8010662b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010662e:	c9                   	leave  
8010662f:	c3                   	ret    

80106630 <sys_read>:

int
sys_read(void)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106636:	83 ec 04             	sub    $0x4,%esp
80106639:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010663c:	50                   	push   %eax
8010663d:	6a 00                	push   $0x0
8010663f:	6a 00                	push   $0x0
80106641:	e8 d2 fe ff ff       	call   80106518 <argfd>
80106646:	83 c4 10             	add    $0x10,%esp
80106649:	85 c0                	test   %eax,%eax
8010664b:	78 2e                	js     8010667b <sys_read+0x4b>
8010664d:	83 ec 08             	sub    $0x8,%esp
80106650:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106653:	50                   	push   %eax
80106654:	6a 02                	push   $0x2
80106656:	e8 81 fd ff ff       	call   801063dc <argint>
8010665b:	83 c4 10             	add    $0x10,%esp
8010665e:	85 c0                	test   %eax,%eax
80106660:	78 19                	js     8010667b <sys_read+0x4b>
80106662:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106665:	83 ec 04             	sub    $0x4,%esp
80106668:	50                   	push   %eax
80106669:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010666c:	50                   	push   %eax
8010666d:	6a 01                	push   $0x1
8010666f:	e8 90 fd ff ff       	call   80106404 <argptr>
80106674:	83 c4 10             	add    $0x10,%esp
80106677:	85 c0                	test   %eax,%eax
80106679:	79 07                	jns    80106682 <sys_read+0x52>
    return -1;
8010667b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106680:	eb 17                	jmp    80106699 <sys_read+0x69>
  return fileread(f, p, n);
80106682:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106685:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010668b:	83 ec 04             	sub    $0x4,%esp
8010668e:	51                   	push   %ecx
8010668f:	52                   	push   %edx
80106690:	50                   	push   %eax
80106691:	e8 3c ac ff ff       	call   801012d2 <fileread>
80106696:	83 c4 10             	add    $0x10,%esp
}
80106699:	c9                   	leave  
8010669a:	c3                   	ret    

8010669b <sys_write>:

int
sys_write(void)
{
8010669b:	55                   	push   %ebp
8010669c:	89 e5                	mov    %esp,%ebp
8010669e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801066a1:	83 ec 04             	sub    $0x4,%esp
801066a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066a7:	50                   	push   %eax
801066a8:	6a 00                	push   $0x0
801066aa:	6a 00                	push   $0x0
801066ac:	e8 67 fe ff ff       	call   80106518 <argfd>
801066b1:	83 c4 10             	add    $0x10,%esp
801066b4:	85 c0                	test   %eax,%eax
801066b6:	78 2e                	js     801066e6 <sys_write+0x4b>
801066b8:	83 ec 08             	sub    $0x8,%esp
801066bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066be:	50                   	push   %eax
801066bf:	6a 02                	push   $0x2
801066c1:	e8 16 fd ff ff       	call   801063dc <argint>
801066c6:	83 c4 10             	add    $0x10,%esp
801066c9:	85 c0                	test   %eax,%eax
801066cb:	78 19                	js     801066e6 <sys_write+0x4b>
801066cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066d0:	83 ec 04             	sub    $0x4,%esp
801066d3:	50                   	push   %eax
801066d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801066d7:	50                   	push   %eax
801066d8:	6a 01                	push   $0x1
801066da:	e8 25 fd ff ff       	call   80106404 <argptr>
801066df:	83 c4 10             	add    $0x10,%esp
801066e2:	85 c0                	test   %eax,%eax
801066e4:	79 07                	jns    801066ed <sys_write+0x52>
    return -1;
801066e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066eb:	eb 17                	jmp    80106704 <sys_write+0x69>
  return filewrite(f, p, n);
801066ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801066f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801066f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066f6:	83 ec 04             	sub    $0x4,%esp
801066f9:	51                   	push   %ecx
801066fa:	52                   	push   %edx
801066fb:	50                   	push   %eax
801066fc:	e8 89 ac ff ff       	call   8010138a <filewrite>
80106701:	83 c4 10             	add    $0x10,%esp
}
80106704:	c9                   	leave  
80106705:	c3                   	ret    

80106706 <sys_close>:

int
sys_close(void)
{
80106706:	55                   	push   %ebp
80106707:	89 e5                	mov    %esp,%ebp
80106709:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010670c:	83 ec 04             	sub    $0x4,%esp
8010670f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106712:	50                   	push   %eax
80106713:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106716:	50                   	push   %eax
80106717:	6a 00                	push   $0x0
80106719:	e8 fa fd ff ff       	call   80106518 <argfd>
8010671e:	83 c4 10             	add    $0x10,%esp
80106721:	85 c0                	test   %eax,%eax
80106723:	79 07                	jns    8010672c <sys_close+0x26>
    return -1;
80106725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010672a:	eb 28                	jmp    80106754 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010672c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106732:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106735:	83 c2 08             	add    $0x8,%edx
80106738:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010673f:	00 
  fileclose(f);
80106740:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106743:	83 ec 0c             	sub    $0xc,%esp
80106746:	50                   	push   %eax
80106747:	e8 47 aa ff ff       	call   80101193 <fileclose>
8010674c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010674f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106754:	c9                   	leave  
80106755:	c3                   	ret    

80106756 <sys_fstat>:

int
sys_fstat(void)
{
80106756:	55                   	push   %ebp
80106757:	89 e5                	mov    %esp,%ebp
80106759:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010675c:	83 ec 04             	sub    $0x4,%esp
8010675f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106762:	50                   	push   %eax
80106763:	6a 00                	push   $0x0
80106765:	6a 00                	push   $0x0
80106767:	e8 ac fd ff ff       	call   80106518 <argfd>
8010676c:	83 c4 10             	add    $0x10,%esp
8010676f:	85 c0                	test   %eax,%eax
80106771:	78 17                	js     8010678a <sys_fstat+0x34>
80106773:	83 ec 04             	sub    $0x4,%esp
80106776:	6a 1c                	push   $0x1c
80106778:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010677b:	50                   	push   %eax
8010677c:	6a 01                	push   $0x1
8010677e:	e8 81 fc ff ff       	call   80106404 <argptr>
80106783:	83 c4 10             	add    $0x10,%esp
80106786:	85 c0                	test   %eax,%eax
80106788:	79 07                	jns    80106791 <sys_fstat+0x3b>
    return -1;
8010678a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010678f:	eb 13                	jmp    801067a4 <sys_fstat+0x4e>
  return filestat(f, st);
80106791:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106797:	83 ec 08             	sub    $0x8,%esp
8010679a:	52                   	push   %edx
8010679b:	50                   	push   %eax
8010679c:	e8 da aa ff ff       	call   8010127b <filestat>
801067a1:	83 c4 10             	add    $0x10,%esp
}
801067a4:	c9                   	leave  
801067a5:	c3                   	ret    

801067a6 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801067a6:	55                   	push   %ebp
801067a7:	89 e5                	mov    %esp,%ebp
801067a9:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801067ac:	83 ec 08             	sub    $0x8,%esp
801067af:	8d 45 d8             	lea    -0x28(%ebp),%eax
801067b2:	50                   	push   %eax
801067b3:	6a 00                	push   $0x0
801067b5:	e8 a7 fc ff ff       	call   80106461 <argstr>
801067ba:	83 c4 10             	add    $0x10,%esp
801067bd:	85 c0                	test   %eax,%eax
801067bf:	78 15                	js     801067d6 <sys_link+0x30>
801067c1:	83 ec 08             	sub    $0x8,%esp
801067c4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801067c7:	50                   	push   %eax
801067c8:	6a 01                	push   $0x1
801067ca:	e8 92 fc ff ff       	call   80106461 <argstr>
801067cf:	83 c4 10             	add    $0x10,%esp
801067d2:	85 c0                	test   %eax,%eax
801067d4:	79 0a                	jns    801067e0 <sys_link+0x3a>
    return -1;
801067d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067db:	e9 68 01 00 00       	jmp    80106948 <sys_link+0x1a2>

  begin_op();
801067e0:	e8 22 cf ff ff       	call   80103707 <begin_op>
  if((ip = namei(old)) == 0){
801067e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801067e8:	83 ec 0c             	sub    $0xc,%esp
801067eb:	50                   	push   %eax
801067ec:	e8 f1 be ff ff       	call   801026e2 <namei>
801067f1:	83 c4 10             	add    $0x10,%esp
801067f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067fb:	75 0f                	jne    8010680c <sys_link+0x66>
    end_op();
801067fd:	e8 91 cf ff ff       	call   80103793 <end_op>
    return -1;
80106802:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106807:	e9 3c 01 00 00       	jmp    80106948 <sys_link+0x1a2>
  }

  ilock(ip);
8010680c:	83 ec 0c             	sub    $0xc,%esp
8010680f:	ff 75 f4             	pushl  -0xc(%ebp)
80106812:	e8 bd b2 ff ff       	call   80101ad4 <ilock>
80106817:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010681a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010681d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106821:	66 83 f8 01          	cmp    $0x1,%ax
80106825:	75 1d                	jne    80106844 <sys_link+0x9e>
    iunlockput(ip);
80106827:	83 ec 0c             	sub    $0xc,%esp
8010682a:	ff 75 f4             	pushl  -0xc(%ebp)
8010682d:	e8 8a b5 ff ff       	call   80101dbc <iunlockput>
80106832:	83 c4 10             	add    $0x10,%esp
    end_op();
80106835:	e8 59 cf ff ff       	call   80103793 <end_op>
    return -1;
8010683a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010683f:	e9 04 01 00 00       	jmp    80106948 <sys_link+0x1a2>
  }

  ip->nlink++;
80106844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106847:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010684b:	83 c0 01             	add    $0x1,%eax
8010684e:	89 c2                	mov    %eax,%edx
80106850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106853:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106857:	83 ec 0c             	sub    $0xc,%esp
8010685a:	ff 75 f4             	pushl  -0xc(%ebp)
8010685d:	e8 70 b0 ff ff       	call   801018d2 <iupdate>
80106862:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106865:	83 ec 0c             	sub    $0xc,%esp
80106868:	ff 75 f4             	pushl  -0xc(%ebp)
8010686b:	e8 ea b3 ff ff       	call   80101c5a <iunlock>
80106870:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106873:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106876:	83 ec 08             	sub    $0x8,%esp
80106879:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010687c:	52                   	push   %edx
8010687d:	50                   	push   %eax
8010687e:	e8 7b be ff ff       	call   801026fe <nameiparent>
80106883:	83 c4 10             	add    $0x10,%esp
80106886:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106889:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010688d:	74 71                	je     80106900 <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010688f:	83 ec 0c             	sub    $0xc,%esp
80106892:	ff 75 f0             	pushl  -0x10(%ebp)
80106895:	e8 3a b2 ff ff       	call   80101ad4 <ilock>
8010689a:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010689d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068a0:	8b 10                	mov    (%eax),%edx
801068a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a5:	8b 00                	mov    (%eax),%eax
801068a7:	39 c2                	cmp    %eax,%edx
801068a9:	75 1d                	jne    801068c8 <sys_link+0x122>
801068ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ae:	8b 40 04             	mov    0x4(%eax),%eax
801068b1:	83 ec 04             	sub    $0x4,%esp
801068b4:	50                   	push   %eax
801068b5:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801068b8:	50                   	push   %eax
801068b9:	ff 75 f0             	pushl  -0x10(%ebp)
801068bc:	e8 85 bb ff ff       	call   80102446 <dirlink>
801068c1:	83 c4 10             	add    $0x10,%esp
801068c4:	85 c0                	test   %eax,%eax
801068c6:	79 10                	jns    801068d8 <sys_link+0x132>
    iunlockput(dp);
801068c8:	83 ec 0c             	sub    $0xc,%esp
801068cb:	ff 75 f0             	pushl  -0x10(%ebp)
801068ce:	e8 e9 b4 ff ff       	call   80101dbc <iunlockput>
801068d3:	83 c4 10             	add    $0x10,%esp
    goto bad;
801068d6:	eb 29                	jmp    80106901 <sys_link+0x15b>
  }
  iunlockput(dp);
801068d8:	83 ec 0c             	sub    $0xc,%esp
801068db:	ff 75 f0             	pushl  -0x10(%ebp)
801068de:	e8 d9 b4 ff ff       	call   80101dbc <iunlockput>
801068e3:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801068e6:	83 ec 0c             	sub    $0xc,%esp
801068e9:	ff 75 f4             	pushl  -0xc(%ebp)
801068ec:	e8 db b3 ff ff       	call   80101ccc <iput>
801068f1:	83 c4 10             	add    $0x10,%esp

  end_op();
801068f4:	e8 9a ce ff ff       	call   80103793 <end_op>

  return 0;
801068f9:	b8 00 00 00 00       	mov    $0x0,%eax
801068fe:	eb 48                	jmp    80106948 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106900:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80106901:	83 ec 0c             	sub    $0xc,%esp
80106904:	ff 75 f4             	pushl  -0xc(%ebp)
80106907:	e8 c8 b1 ff ff       	call   80101ad4 <ilock>
8010690c:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010690f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106912:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106916:	83 e8 01             	sub    $0x1,%eax
80106919:	89 c2                	mov    %eax,%edx
8010691b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010691e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106922:	83 ec 0c             	sub    $0xc,%esp
80106925:	ff 75 f4             	pushl  -0xc(%ebp)
80106928:	e8 a5 af ff ff       	call   801018d2 <iupdate>
8010692d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106930:	83 ec 0c             	sub    $0xc,%esp
80106933:	ff 75 f4             	pushl  -0xc(%ebp)
80106936:	e8 81 b4 ff ff       	call   80101dbc <iunlockput>
8010693b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010693e:	e8 50 ce ff ff       	call   80103793 <end_op>
  return -1;
80106943:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106948:	c9                   	leave  
80106949:	c3                   	ret    

8010694a <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010694a:	55                   	push   %ebp
8010694b:	89 e5                	mov    %esp,%ebp
8010694d:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106950:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106957:	eb 40                	jmp    80106999 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010695c:	6a 10                	push   $0x10
8010695e:	50                   	push   %eax
8010695f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106962:	50                   	push   %eax
80106963:	ff 75 08             	pushl  0x8(%ebp)
80106966:	e8 27 b7 ff ff       	call   80102092 <readi>
8010696b:	83 c4 10             	add    $0x10,%esp
8010696e:	83 f8 10             	cmp    $0x10,%eax
80106971:	74 0d                	je     80106980 <isdirempty+0x36>
      panic("isdirempty: readi");
80106973:	83 ec 0c             	sub    $0xc,%esp
80106976:	68 5e 9e 10 80       	push   $0x80109e5e
8010697b:	e8 e6 9b ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80106980:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106984:	66 85 c0             	test   %ax,%ax
80106987:	74 07                	je     80106990 <isdirempty+0x46>
      return 0;
80106989:	b8 00 00 00 00       	mov    $0x0,%eax
8010698e:	eb 1b                	jmp    801069ab <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106990:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106993:	83 c0 10             	add    $0x10,%eax
80106996:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106999:	8b 45 08             	mov    0x8(%ebp),%eax
8010699c:	8b 50 20             	mov    0x20(%eax),%edx
8010699f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069a2:	39 c2                	cmp    %eax,%edx
801069a4:	77 b3                	ja     80106959 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801069a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801069ab:	c9                   	leave  
801069ac:	c3                   	ret    

801069ad <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801069ad:	55                   	push   %ebp
801069ae:	89 e5                	mov    %esp,%ebp
801069b0:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801069b3:	83 ec 08             	sub    $0x8,%esp
801069b6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801069b9:	50                   	push   %eax
801069ba:	6a 00                	push   $0x0
801069bc:	e8 a0 fa ff ff       	call   80106461 <argstr>
801069c1:	83 c4 10             	add    $0x10,%esp
801069c4:	85 c0                	test   %eax,%eax
801069c6:	79 0a                	jns    801069d2 <sys_unlink+0x25>
    return -1;
801069c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069cd:	e9 bc 01 00 00       	jmp    80106b8e <sys_unlink+0x1e1>

  begin_op();
801069d2:	e8 30 cd ff ff       	call   80103707 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801069d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
801069da:	83 ec 08             	sub    $0x8,%esp
801069dd:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801069e0:	52                   	push   %edx
801069e1:	50                   	push   %eax
801069e2:	e8 17 bd ff ff       	call   801026fe <nameiparent>
801069e7:	83 c4 10             	add    $0x10,%esp
801069ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069f1:	75 0f                	jne    80106a02 <sys_unlink+0x55>
    end_op();
801069f3:	e8 9b cd ff ff       	call   80103793 <end_op>
    return -1;
801069f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069fd:	e9 8c 01 00 00       	jmp    80106b8e <sys_unlink+0x1e1>
  }

  ilock(dp);
80106a02:	83 ec 0c             	sub    $0xc,%esp
80106a05:	ff 75 f4             	pushl  -0xc(%ebp)
80106a08:	e8 c7 b0 ff ff       	call   80101ad4 <ilock>
80106a0d:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106a10:	83 ec 08             	sub    $0x8,%esp
80106a13:	68 70 9e 10 80       	push   $0x80109e70
80106a18:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106a1b:	50                   	push   %eax
80106a1c:	e8 50 b9 ff ff       	call   80102371 <namecmp>
80106a21:	83 c4 10             	add    $0x10,%esp
80106a24:	85 c0                	test   %eax,%eax
80106a26:	0f 84 4a 01 00 00    	je     80106b76 <sys_unlink+0x1c9>
80106a2c:	83 ec 08             	sub    $0x8,%esp
80106a2f:	68 72 9e 10 80       	push   $0x80109e72
80106a34:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106a37:	50                   	push   %eax
80106a38:	e8 34 b9 ff ff       	call   80102371 <namecmp>
80106a3d:	83 c4 10             	add    $0x10,%esp
80106a40:	85 c0                	test   %eax,%eax
80106a42:	0f 84 2e 01 00 00    	je     80106b76 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106a48:	83 ec 04             	sub    $0x4,%esp
80106a4b:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106a4e:	50                   	push   %eax
80106a4f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106a52:	50                   	push   %eax
80106a53:	ff 75 f4             	pushl  -0xc(%ebp)
80106a56:	e8 31 b9 ff ff       	call   8010238c <dirlookup>
80106a5b:	83 c4 10             	add    $0x10,%esp
80106a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a65:	0f 84 0a 01 00 00    	je     80106b75 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106a6b:	83 ec 0c             	sub    $0xc,%esp
80106a6e:	ff 75 f0             	pushl  -0x10(%ebp)
80106a71:	e8 5e b0 ff ff       	call   80101ad4 <ilock>
80106a76:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a7c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106a80:	66 85 c0             	test   %ax,%ax
80106a83:	7f 0d                	jg     80106a92 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106a85:	83 ec 0c             	sub    $0xc,%esp
80106a88:	68 75 9e 10 80       	push   $0x80109e75
80106a8d:	e8 d4 9a ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a95:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106a99:	66 83 f8 01          	cmp    $0x1,%ax
80106a9d:	75 25                	jne    80106ac4 <sys_unlink+0x117>
80106a9f:	83 ec 0c             	sub    $0xc,%esp
80106aa2:	ff 75 f0             	pushl  -0x10(%ebp)
80106aa5:	e8 a0 fe ff ff       	call   8010694a <isdirempty>
80106aaa:	83 c4 10             	add    $0x10,%esp
80106aad:	85 c0                	test   %eax,%eax
80106aaf:	75 13                	jne    80106ac4 <sys_unlink+0x117>
    iunlockput(ip);
80106ab1:	83 ec 0c             	sub    $0xc,%esp
80106ab4:	ff 75 f0             	pushl  -0x10(%ebp)
80106ab7:	e8 00 b3 ff ff       	call   80101dbc <iunlockput>
80106abc:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106abf:	e9 b2 00 00 00       	jmp    80106b76 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106ac4:	83 ec 04             	sub    $0x4,%esp
80106ac7:	6a 10                	push   $0x10
80106ac9:	6a 00                	push   $0x0
80106acb:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106ace:	50                   	push   %eax
80106acf:	e8 e3 f5 ff ff       	call   801060b7 <memset>
80106ad4:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106ad7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106ada:	6a 10                	push   $0x10
80106adc:	50                   	push   %eax
80106add:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106ae0:	50                   	push   %eax
80106ae1:	ff 75 f4             	pushl  -0xc(%ebp)
80106ae4:	e8 00 b7 ff ff       	call   801021e9 <writei>
80106ae9:	83 c4 10             	add    $0x10,%esp
80106aec:	83 f8 10             	cmp    $0x10,%eax
80106aef:	74 0d                	je     80106afe <sys_unlink+0x151>
    panic("unlink: writei");
80106af1:	83 ec 0c             	sub    $0xc,%esp
80106af4:	68 87 9e 10 80       	push   $0x80109e87
80106af9:	e8 68 9a ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80106afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b01:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106b05:	66 83 f8 01          	cmp    $0x1,%ax
80106b09:	75 21                	jne    80106b2c <sys_unlink+0x17f>
    dp->nlink--;
80106b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b0e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106b12:	83 e8 01             	sub    $0x1,%eax
80106b15:	89 c2                	mov    %eax,%edx
80106b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b1a:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106b1e:	83 ec 0c             	sub    $0xc,%esp
80106b21:	ff 75 f4             	pushl  -0xc(%ebp)
80106b24:	e8 a9 ad ff ff       	call   801018d2 <iupdate>
80106b29:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106b2c:	83 ec 0c             	sub    $0xc,%esp
80106b2f:	ff 75 f4             	pushl  -0xc(%ebp)
80106b32:	e8 85 b2 ff ff       	call   80101dbc <iunlockput>
80106b37:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b3d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106b41:	83 e8 01             	sub    $0x1,%eax
80106b44:	89 c2                	mov    %eax,%edx
80106b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b49:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106b4d:	83 ec 0c             	sub    $0xc,%esp
80106b50:	ff 75 f0             	pushl  -0x10(%ebp)
80106b53:	e8 7a ad ff ff       	call   801018d2 <iupdate>
80106b58:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106b5b:	83 ec 0c             	sub    $0xc,%esp
80106b5e:	ff 75 f0             	pushl  -0x10(%ebp)
80106b61:	e8 56 b2 ff ff       	call   80101dbc <iunlockput>
80106b66:	83 c4 10             	add    $0x10,%esp

  end_op();
80106b69:	e8 25 cc ff ff       	call   80103793 <end_op>

  return 0;
80106b6e:	b8 00 00 00 00       	mov    $0x0,%eax
80106b73:	eb 19                	jmp    80106b8e <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106b75:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106b76:	83 ec 0c             	sub    $0xc,%esp
80106b79:	ff 75 f4             	pushl  -0xc(%ebp)
80106b7c:	e8 3b b2 ff ff       	call   80101dbc <iunlockput>
80106b81:	83 c4 10             	add    $0x10,%esp
  end_op();
80106b84:	e8 0a cc ff ff       	call   80103793 <end_op>
  return -1;
80106b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b8e:	c9                   	leave  
80106b8f:	c3                   	ret    

80106b90 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	83 ec 38             	sub    $0x38,%esp
80106b96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b99:	8b 55 10             	mov    0x10(%ebp),%edx
80106b9c:	8b 45 14             	mov    0x14(%ebp),%eax
80106b9f:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106ba3:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106ba7:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106bab:	83 ec 08             	sub    $0x8,%esp
80106bae:	8d 45 de             	lea    -0x22(%ebp),%eax
80106bb1:	50                   	push   %eax
80106bb2:	ff 75 08             	pushl  0x8(%ebp)
80106bb5:	e8 44 bb ff ff       	call   801026fe <nameiparent>
80106bba:	83 c4 10             	add    $0x10,%esp
80106bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106bc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106bc4:	75 0a                	jne    80106bd0 <create+0x40>
    return 0;
80106bc6:	b8 00 00 00 00       	mov    $0x0,%eax
80106bcb:	e9 c8 01 00 00       	jmp    80106d98 <create+0x208>
  ilock(dp);
80106bd0:	83 ec 0c             	sub    $0xc,%esp
80106bd3:	ff 75 f4             	pushl  -0xc(%ebp)
80106bd6:	e8 f9 ae ff ff       	call   80101ad4 <ilock>
80106bdb:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106bde:	83 ec 04             	sub    $0x4,%esp
80106be1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106be4:	50                   	push   %eax
80106be5:	8d 45 de             	lea    -0x22(%ebp),%eax
80106be8:	50                   	push   %eax
80106be9:	ff 75 f4             	pushl  -0xc(%ebp)
80106bec:	e8 9b b7 ff ff       	call   8010238c <dirlookup>
80106bf1:	83 c4 10             	add    $0x10,%esp
80106bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106bf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106bfb:	74 50                	je     80106c4d <create+0xbd>
    iunlockput(dp);
80106bfd:	83 ec 0c             	sub    $0xc,%esp
80106c00:	ff 75 f4             	pushl  -0xc(%ebp)
80106c03:	e8 b4 b1 ff ff       	call   80101dbc <iunlockput>
80106c08:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106c0b:	83 ec 0c             	sub    $0xc,%esp
80106c0e:	ff 75 f0             	pushl  -0x10(%ebp)
80106c11:	e8 be ae ff ff       	call   80101ad4 <ilock>
80106c16:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106c19:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106c1e:	75 15                	jne    80106c35 <create+0xa5>
80106c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c23:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106c27:	66 83 f8 02          	cmp    $0x2,%ax
80106c2b:	75 08                	jne    80106c35 <create+0xa5>
      return ip;
80106c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c30:	e9 63 01 00 00       	jmp    80106d98 <create+0x208>
    iunlockput(ip);
80106c35:	83 ec 0c             	sub    $0xc,%esp
80106c38:	ff 75 f0             	pushl  -0x10(%ebp)
80106c3b:	e8 7c b1 ff ff       	call   80101dbc <iunlockput>
80106c40:	83 c4 10             	add    $0x10,%esp
    return 0;
80106c43:	b8 00 00 00 00       	mov    $0x0,%eax
80106c48:	e9 4b 01 00 00       	jmp    80106d98 <create+0x208>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106c4d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c54:	8b 00                	mov    (%eax),%eax
80106c56:	83 ec 08             	sub    $0x8,%esp
80106c59:	52                   	push   %edx
80106c5a:	50                   	push   %eax
80106c5b:	e8 9b ab ff ff       	call   801017fb <ialloc>
80106c60:	83 c4 10             	add    $0x10,%esp
80106c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106c66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106c6a:	75 0d                	jne    80106c79 <create+0xe9>
    panic("create: ialloc");
80106c6c:	83 ec 0c             	sub    $0xc,%esp
80106c6f:	68 96 9e 10 80       	push   $0x80109e96
80106c74:	e8 ed 98 ff ff       	call   80100566 <panic>

  ilock(ip);
80106c79:	83 ec 0c             	sub    $0xc,%esp
80106c7c:	ff 75 f0             	pushl  -0x10(%ebp)
80106c7f:	e8 50 ae ff ff       	call   80101ad4 <ilock>
80106c84:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c8a:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106c8e:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c95:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106c99:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ca0:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)

  #ifdef CS333_P5
  ip->uid = DEFAULT_UID;
80106ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ca9:	66 c7 40 18 00 00    	movw   $0x0,0x18(%eax)
  ip->gid = DEFAULT_GID;
80106caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cb2:	66 c7 40 1a 00 00    	movw   $0x0,0x1a(%eax)
  ip->mode.asInt = DEFAULT_MODE;
80106cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cbb:	c7 40 1c ed 01 00 00 	movl   $0x1ed,0x1c(%eax)
  dp->uid = DEFAULT_UID;
80106cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cc5:	66 c7 40 18 00 00    	movw   $0x0,0x18(%eax)
  dp->gid = DEFAULT_GID;
80106ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cce:	66 c7 40 1a 00 00    	movw   $0x0,0x1a(%eax)
  dp->mode.asInt = DEFAULT_MODE;
80106cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd7:	c7 40 1c ed 01 00 00 	movl   $0x1ed,0x1c(%eax)
  #endif

  iupdate(ip);
80106cde:	83 ec 0c             	sub    $0xc,%esp
80106ce1:	ff 75 f0             	pushl  -0x10(%ebp)
80106ce4:	e8 e9 ab ff ff       	call   801018d2 <iupdate>
80106ce9:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106cec:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106cf1:	75 6a                	jne    80106d5d <create+0x1cd>
    dp->nlink++;  // for ".."
80106cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cf6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106cfa:	83 c0 01             	add    $0x1,%eax
80106cfd:	89 c2                	mov    %eax,%edx
80106cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d02:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106d06:	83 ec 0c             	sub    $0xc,%esp
80106d09:	ff 75 f4             	pushl  -0xc(%ebp)
80106d0c:	e8 c1 ab ff ff       	call   801018d2 <iupdate>
80106d11:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d17:	8b 40 04             	mov    0x4(%eax),%eax
80106d1a:	83 ec 04             	sub    $0x4,%esp
80106d1d:	50                   	push   %eax
80106d1e:	68 70 9e 10 80       	push   $0x80109e70
80106d23:	ff 75 f0             	pushl  -0x10(%ebp)
80106d26:	e8 1b b7 ff ff       	call   80102446 <dirlink>
80106d2b:	83 c4 10             	add    $0x10,%esp
80106d2e:	85 c0                	test   %eax,%eax
80106d30:	78 1e                	js     80106d50 <create+0x1c0>
80106d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d35:	8b 40 04             	mov    0x4(%eax),%eax
80106d38:	83 ec 04             	sub    $0x4,%esp
80106d3b:	50                   	push   %eax
80106d3c:	68 72 9e 10 80       	push   $0x80109e72
80106d41:	ff 75 f0             	pushl  -0x10(%ebp)
80106d44:	e8 fd b6 ff ff       	call   80102446 <dirlink>
80106d49:	83 c4 10             	add    $0x10,%esp
80106d4c:	85 c0                	test   %eax,%eax
80106d4e:	79 0d                	jns    80106d5d <create+0x1cd>
      panic("create dots");
80106d50:	83 ec 0c             	sub    $0xc,%esp
80106d53:	68 a5 9e 10 80       	push   $0x80109ea5
80106d58:	e8 09 98 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d60:	8b 40 04             	mov    0x4(%eax),%eax
80106d63:	83 ec 04             	sub    $0x4,%esp
80106d66:	50                   	push   %eax
80106d67:	8d 45 de             	lea    -0x22(%ebp),%eax
80106d6a:	50                   	push   %eax
80106d6b:	ff 75 f4             	pushl  -0xc(%ebp)
80106d6e:	e8 d3 b6 ff ff       	call   80102446 <dirlink>
80106d73:	83 c4 10             	add    $0x10,%esp
80106d76:	85 c0                	test   %eax,%eax
80106d78:	79 0d                	jns    80106d87 <create+0x1f7>
    panic("create: dirlink");
80106d7a:	83 ec 0c             	sub    $0xc,%esp
80106d7d:	68 b1 9e 10 80       	push   $0x80109eb1
80106d82:	e8 df 97 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80106d87:	83 ec 0c             	sub    $0xc,%esp
80106d8a:	ff 75 f4             	pushl  -0xc(%ebp)
80106d8d:	e8 2a b0 ff ff       	call   80101dbc <iunlockput>
80106d92:	83 c4 10             	add    $0x10,%esp

  return ip;
80106d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106d98:	c9                   	leave  
80106d99:	c3                   	ret    

80106d9a <sys_open>:

int
sys_open(void)
{
80106d9a:	55                   	push   %ebp
80106d9b:	89 e5                	mov    %esp,%ebp
80106d9d:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106da0:	83 ec 08             	sub    $0x8,%esp
80106da3:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106da6:	50                   	push   %eax
80106da7:	6a 00                	push   $0x0
80106da9:	e8 b3 f6 ff ff       	call   80106461 <argstr>
80106dae:	83 c4 10             	add    $0x10,%esp
80106db1:	85 c0                	test   %eax,%eax
80106db3:	78 15                	js     80106dca <sys_open+0x30>
80106db5:	83 ec 08             	sub    $0x8,%esp
80106db8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106dbb:	50                   	push   %eax
80106dbc:	6a 01                	push   $0x1
80106dbe:	e8 19 f6 ff ff       	call   801063dc <argint>
80106dc3:	83 c4 10             	add    $0x10,%esp
80106dc6:	85 c0                	test   %eax,%eax
80106dc8:	79 0a                	jns    80106dd4 <sys_open+0x3a>
    return -1;
80106dca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dcf:	e9 61 01 00 00       	jmp    80106f35 <sys_open+0x19b>

  begin_op();
80106dd4:	e8 2e c9 ff ff       	call   80103707 <begin_op>

  if(omode & O_CREATE){
80106dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ddc:	25 00 02 00 00       	and    $0x200,%eax
80106de1:	85 c0                	test   %eax,%eax
80106de3:	74 2a                	je     80106e0f <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106de5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106de8:	6a 00                	push   $0x0
80106dea:	6a 00                	push   $0x0
80106dec:	6a 02                	push   $0x2
80106dee:	50                   	push   %eax
80106def:	e8 9c fd ff ff       	call   80106b90 <create>
80106df4:	83 c4 10             	add    $0x10,%esp
80106df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106dfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106dfe:	75 75                	jne    80106e75 <sys_open+0xdb>
      end_op();
80106e00:	e8 8e c9 ff ff       	call   80103793 <end_op>
      return -1;
80106e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e0a:	e9 26 01 00 00       	jmp    80106f35 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106e0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106e12:	83 ec 0c             	sub    $0xc,%esp
80106e15:	50                   	push   %eax
80106e16:	e8 c7 b8 ff ff       	call   801026e2 <namei>
80106e1b:	83 c4 10             	add    $0x10,%esp
80106e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e25:	75 0f                	jne    80106e36 <sys_open+0x9c>
      end_op();
80106e27:	e8 67 c9 ff ff       	call   80103793 <end_op>
      return -1;
80106e2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e31:	e9 ff 00 00 00       	jmp    80106f35 <sys_open+0x19b>
    }
    ilock(ip);
80106e36:	83 ec 0c             	sub    $0xc,%esp
80106e39:	ff 75 f4             	pushl  -0xc(%ebp)
80106e3c:	e8 93 ac ff ff       	call   80101ad4 <ilock>
80106e41:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e47:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106e4b:	66 83 f8 01          	cmp    $0x1,%ax
80106e4f:	75 24                	jne    80106e75 <sys_open+0xdb>
80106e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e54:	85 c0                	test   %eax,%eax
80106e56:	74 1d                	je     80106e75 <sys_open+0xdb>
      iunlockput(ip);
80106e58:	83 ec 0c             	sub    $0xc,%esp
80106e5b:	ff 75 f4             	pushl  -0xc(%ebp)
80106e5e:	e8 59 af ff ff       	call   80101dbc <iunlockput>
80106e63:	83 c4 10             	add    $0x10,%esp
      end_op();
80106e66:	e8 28 c9 ff ff       	call   80103793 <end_op>
      return -1;
80106e6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e70:	e9 c0 00 00 00       	jmp    80106f35 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106e75:	e8 5b a2 ff ff       	call   801010d5 <filealloc>
80106e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106e7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106e81:	74 17                	je     80106e9a <sys_open+0x100>
80106e83:	83 ec 0c             	sub    $0xc,%esp
80106e86:	ff 75 f0             	pushl  -0x10(%ebp)
80106e89:	e8 ff f6 ff ff       	call   8010658d <fdalloc>
80106e8e:	83 c4 10             	add    $0x10,%esp
80106e91:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106e94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106e98:	79 2e                	jns    80106ec8 <sys_open+0x12e>
    if(f)
80106e9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106e9e:	74 0e                	je     80106eae <sys_open+0x114>
      fileclose(f);
80106ea0:	83 ec 0c             	sub    $0xc,%esp
80106ea3:	ff 75 f0             	pushl  -0x10(%ebp)
80106ea6:	e8 e8 a2 ff ff       	call   80101193 <fileclose>
80106eab:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106eae:	83 ec 0c             	sub    $0xc,%esp
80106eb1:	ff 75 f4             	pushl  -0xc(%ebp)
80106eb4:	e8 03 af ff ff       	call   80101dbc <iunlockput>
80106eb9:	83 c4 10             	add    $0x10,%esp
    end_op();
80106ebc:	e8 d2 c8 ff ff       	call   80103793 <end_op>
    return -1;
80106ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ec6:	eb 6d                	jmp    80106f35 <sys_open+0x19b>
  }
  iunlock(ip);
80106ec8:	83 ec 0c             	sub    $0xc,%esp
80106ecb:	ff 75 f4             	pushl  -0xc(%ebp)
80106ece:	e8 87 ad ff ff       	call   80101c5a <iunlock>
80106ed3:	83 c4 10             	add    $0x10,%esp
  end_op();
80106ed6:	e8 b8 c8 ff ff       	call   80103793 <end_op>

  f->type = FD_INODE;
80106edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ede:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106eea:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ef0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106ef7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106efa:	83 e0 01             	and    $0x1,%eax
80106efd:	85 c0                	test   %eax,%eax
80106eff:	0f 94 c0             	sete   %al
80106f02:	89 c2                	mov    %eax,%edx
80106f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f07:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f0d:	83 e0 01             	and    $0x1,%eax
80106f10:	85 c0                	test   %eax,%eax
80106f12:	75 0a                	jne    80106f1e <sys_open+0x184>
80106f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f17:	83 e0 02             	and    $0x2,%eax
80106f1a:	85 c0                	test   %eax,%eax
80106f1c:	74 07                	je     80106f25 <sys_open+0x18b>
80106f1e:	b8 01 00 00 00       	mov    $0x1,%eax
80106f23:	eb 05                	jmp    80106f2a <sys_open+0x190>
80106f25:	b8 00 00 00 00       	mov    $0x0,%eax
80106f2a:	89 c2                	mov    %eax,%edx
80106f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f2f:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106f35:	c9                   	leave  
80106f36:	c3                   	ret    

80106f37 <sys_mkdir>:

int
sys_mkdir(void)
{
80106f37:	55                   	push   %ebp
80106f38:	89 e5                	mov    %esp,%ebp
80106f3a:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106f3d:	e8 c5 c7 ff ff       	call   80103707 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106f42:	83 ec 08             	sub    $0x8,%esp
80106f45:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f48:	50                   	push   %eax
80106f49:	6a 00                	push   $0x0
80106f4b:	e8 11 f5 ff ff       	call   80106461 <argstr>
80106f50:	83 c4 10             	add    $0x10,%esp
80106f53:	85 c0                	test   %eax,%eax
80106f55:	78 1b                	js     80106f72 <sys_mkdir+0x3b>
80106f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f5a:	6a 00                	push   $0x0
80106f5c:	6a 00                	push   $0x0
80106f5e:	6a 01                	push   $0x1
80106f60:	50                   	push   %eax
80106f61:	e8 2a fc ff ff       	call   80106b90 <create>
80106f66:	83 c4 10             	add    $0x10,%esp
80106f69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106f6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106f70:	75 0c                	jne    80106f7e <sys_mkdir+0x47>
    end_op();
80106f72:	e8 1c c8 ff ff       	call   80103793 <end_op>
    return -1;
80106f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f7c:	eb 18                	jmp    80106f96 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106f7e:	83 ec 0c             	sub    $0xc,%esp
80106f81:	ff 75 f4             	pushl  -0xc(%ebp)
80106f84:	e8 33 ae ff ff       	call   80101dbc <iunlockput>
80106f89:	83 c4 10             	add    $0x10,%esp
  end_op();
80106f8c:	e8 02 c8 ff ff       	call   80103793 <end_op>
  return 0;
80106f91:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106f96:	c9                   	leave  
80106f97:	c3                   	ret    

80106f98 <sys_mknod>:

int
sys_mknod(void)
{
80106f98:	55                   	push   %ebp
80106f99:	89 e5                	mov    %esp,%ebp
80106f9b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106f9e:	e8 64 c7 ff ff       	call   80103707 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106fa3:	83 ec 08             	sub    $0x8,%esp
80106fa6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106fa9:	50                   	push   %eax
80106faa:	6a 00                	push   $0x0
80106fac:	e8 b0 f4 ff ff       	call   80106461 <argstr>
80106fb1:	83 c4 10             	add    $0x10,%esp
80106fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fbb:	78 4f                	js     8010700c <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106fbd:	83 ec 08             	sub    $0x8,%esp
80106fc0:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106fc3:	50                   	push   %eax
80106fc4:	6a 01                	push   $0x1
80106fc6:	e8 11 f4 ff ff       	call   801063dc <argint>
80106fcb:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106fce:	85 c0                	test   %eax,%eax
80106fd0:	78 3a                	js     8010700c <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106fd2:	83 ec 08             	sub    $0x8,%esp
80106fd5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106fd8:	50                   	push   %eax
80106fd9:	6a 02                	push   $0x2
80106fdb:	e8 fc f3 ff ff       	call   801063dc <argint>
80106fe0:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106fe3:	85 c0                	test   %eax,%eax
80106fe5:	78 25                	js     8010700c <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106fe7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fea:	0f bf c8             	movswl %ax,%ecx
80106fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106ff0:	0f bf d0             	movswl %ax,%edx
80106ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106ff6:	51                   	push   %ecx
80106ff7:	52                   	push   %edx
80106ff8:	6a 03                	push   $0x3
80106ffa:	50                   	push   %eax
80106ffb:	e8 90 fb ff ff       	call   80106b90 <create>
80107000:	83 c4 10             	add    $0x10,%esp
80107003:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107006:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010700a:	75 0c                	jne    80107018 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
8010700c:	e8 82 c7 ff ff       	call   80103793 <end_op>
    return -1;
80107011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107016:	eb 18                	jmp    80107030 <sys_mknod+0x98>
  }
  iunlockput(ip);
80107018:	83 ec 0c             	sub    $0xc,%esp
8010701b:	ff 75 f0             	pushl  -0x10(%ebp)
8010701e:	e8 99 ad ff ff       	call   80101dbc <iunlockput>
80107023:	83 c4 10             	add    $0x10,%esp
  end_op();
80107026:	e8 68 c7 ff ff       	call   80103793 <end_op>
  return 0;
8010702b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107030:	c9                   	leave  
80107031:	c3                   	ret    

80107032 <sys_chdir>:

int
sys_chdir(void)
{
80107032:	55                   	push   %ebp
80107033:	89 e5                	mov    %esp,%ebp
80107035:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107038:	e8 ca c6 ff ff       	call   80103707 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010703d:	83 ec 08             	sub    $0x8,%esp
80107040:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107043:	50                   	push   %eax
80107044:	6a 00                	push   $0x0
80107046:	e8 16 f4 ff ff       	call   80106461 <argstr>
8010704b:	83 c4 10             	add    $0x10,%esp
8010704e:	85 c0                	test   %eax,%eax
80107050:	78 18                	js     8010706a <sys_chdir+0x38>
80107052:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107055:	83 ec 0c             	sub    $0xc,%esp
80107058:	50                   	push   %eax
80107059:	e8 84 b6 ff ff       	call   801026e2 <namei>
8010705e:	83 c4 10             	add    $0x10,%esp
80107061:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107068:	75 0c                	jne    80107076 <sys_chdir+0x44>
    end_op();
8010706a:	e8 24 c7 ff ff       	call   80103793 <end_op>
    return -1;
8010706f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107074:	eb 6e                	jmp    801070e4 <sys_chdir+0xb2>
  }
  ilock(ip);
80107076:	83 ec 0c             	sub    $0xc,%esp
80107079:	ff 75 f4             	pushl  -0xc(%ebp)
8010707c:	e8 53 aa ff ff       	call   80101ad4 <ilock>
80107081:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107084:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107087:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010708b:	66 83 f8 01          	cmp    $0x1,%ax
8010708f:	74 1a                	je     801070ab <sys_chdir+0x79>
    iunlockput(ip);
80107091:	83 ec 0c             	sub    $0xc,%esp
80107094:	ff 75 f4             	pushl  -0xc(%ebp)
80107097:	e8 20 ad ff ff       	call   80101dbc <iunlockput>
8010709c:	83 c4 10             	add    $0x10,%esp
    end_op();
8010709f:	e8 ef c6 ff ff       	call   80103793 <end_op>
    return -1;
801070a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070a9:	eb 39                	jmp    801070e4 <sys_chdir+0xb2>
  }
  iunlock(ip);
801070ab:	83 ec 0c             	sub    $0xc,%esp
801070ae:	ff 75 f4             	pushl  -0xc(%ebp)
801070b1:	e8 a4 ab ff ff       	call   80101c5a <iunlock>
801070b6:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801070b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070bf:	8b 40 68             	mov    0x68(%eax),%eax
801070c2:	83 ec 0c             	sub    $0xc,%esp
801070c5:	50                   	push   %eax
801070c6:	e8 01 ac ff ff       	call   80101ccc <iput>
801070cb:	83 c4 10             	add    $0x10,%esp
  end_op();
801070ce:	e8 c0 c6 ff ff       	call   80103793 <end_op>
  proc->cwd = ip;
801070d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801070dc:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801070df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801070e4:	c9                   	leave  
801070e5:	c3                   	ret    

801070e6 <sys_exec>:

int
sys_exec(void)
{
801070e6:	55                   	push   %ebp
801070e7:	89 e5                	mov    %esp,%ebp
801070e9:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801070ef:	83 ec 08             	sub    $0x8,%esp
801070f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070f5:	50                   	push   %eax
801070f6:	6a 00                	push   $0x0
801070f8:	e8 64 f3 ff ff       	call   80106461 <argstr>
801070fd:	83 c4 10             	add    $0x10,%esp
80107100:	85 c0                	test   %eax,%eax
80107102:	78 18                	js     8010711c <sys_exec+0x36>
80107104:	83 ec 08             	sub    $0x8,%esp
80107107:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010710d:	50                   	push   %eax
8010710e:	6a 01                	push   $0x1
80107110:	e8 c7 f2 ff ff       	call   801063dc <argint>
80107115:	83 c4 10             	add    $0x10,%esp
80107118:	85 c0                	test   %eax,%eax
8010711a:	79 0a                	jns    80107126 <sys_exec+0x40>
    return -1;
8010711c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107121:	e9 c6 00 00 00       	jmp    801071ec <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107126:	83 ec 04             	sub    $0x4,%esp
80107129:	68 80 00 00 00       	push   $0x80
8010712e:	6a 00                	push   $0x0
80107130:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107136:	50                   	push   %eax
80107137:	e8 7b ef ff ff       	call   801060b7 <memset>
8010713c:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010713f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107149:	83 f8 1f             	cmp    $0x1f,%eax
8010714c:	76 0a                	jbe    80107158 <sys_exec+0x72>
      return -1;
8010714e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107153:	e9 94 00 00 00       	jmp    801071ec <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010715b:	c1 e0 02             	shl    $0x2,%eax
8010715e:	89 c2                	mov    %eax,%edx
80107160:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107166:	01 c2                	add    %eax,%edx
80107168:	83 ec 08             	sub    $0x8,%esp
8010716b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107171:	50                   	push   %eax
80107172:	52                   	push   %edx
80107173:	e8 c8 f1 ff ff       	call   80106340 <fetchint>
80107178:	83 c4 10             	add    $0x10,%esp
8010717b:	85 c0                	test   %eax,%eax
8010717d:	79 07                	jns    80107186 <sys_exec+0xa0>
      return -1;
8010717f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107184:	eb 66                	jmp    801071ec <sys_exec+0x106>
    if(uarg == 0){
80107186:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010718c:	85 c0                	test   %eax,%eax
8010718e:	75 27                	jne    801071b7 <sys_exec+0xd1>
      argv[i] = 0;
80107190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107193:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010719a:	00 00 00 00 
      break;
8010719e:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010719f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071a2:	83 ec 08             	sub    $0x8,%esp
801071a5:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801071ab:	52                   	push   %edx
801071ac:	50                   	push   %eax
801071ad:	e8 65 9a ff ff       	call   80100c17 <exec>
801071b2:	83 c4 10             	add    $0x10,%esp
801071b5:	eb 35                	jmp    801071ec <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801071b7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801071bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801071c0:	c1 e2 02             	shl    $0x2,%edx
801071c3:	01 c2                	add    %eax,%edx
801071c5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801071cb:	83 ec 08             	sub    $0x8,%esp
801071ce:	52                   	push   %edx
801071cf:	50                   	push   %eax
801071d0:	e8 a5 f1 ff ff       	call   8010637a <fetchstr>
801071d5:	83 c4 10             	add    $0x10,%esp
801071d8:	85 c0                	test   %eax,%eax
801071da:	79 07                	jns    801071e3 <sys_exec+0xfd>
      return -1;
801071dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071e1:	eb 09                	jmp    801071ec <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801071e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801071e7:	e9 5a ff ff ff       	jmp    80107146 <sys_exec+0x60>
  return exec(path, argv);
}
801071ec:	c9                   	leave  
801071ed:	c3                   	ret    

801071ee <sys_pipe>:

int
sys_pipe(void)
{
801071ee:	55                   	push   %ebp
801071ef:	89 e5                	mov    %esp,%ebp
801071f1:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801071f4:	83 ec 04             	sub    $0x4,%esp
801071f7:	6a 08                	push   $0x8
801071f9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801071fc:	50                   	push   %eax
801071fd:	6a 00                	push   $0x0
801071ff:	e8 00 f2 ff ff       	call   80106404 <argptr>
80107204:	83 c4 10             	add    $0x10,%esp
80107207:	85 c0                	test   %eax,%eax
80107209:	79 0a                	jns    80107215 <sys_pipe+0x27>
    return -1;
8010720b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107210:	e9 af 00 00 00       	jmp    801072c4 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107215:	83 ec 08             	sub    $0x8,%esp
80107218:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010721b:	50                   	push   %eax
8010721c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010721f:	50                   	push   %eax
80107220:	e8 d6 cf ff ff       	call   801041fb <pipealloc>
80107225:	83 c4 10             	add    $0x10,%esp
80107228:	85 c0                	test   %eax,%eax
8010722a:	79 0a                	jns    80107236 <sys_pipe+0x48>
    return -1;
8010722c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107231:	e9 8e 00 00 00       	jmp    801072c4 <sys_pipe+0xd6>
  fd0 = -1;
80107236:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010723d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107240:	83 ec 0c             	sub    $0xc,%esp
80107243:	50                   	push   %eax
80107244:	e8 44 f3 ff ff       	call   8010658d <fdalloc>
80107249:	83 c4 10             	add    $0x10,%esp
8010724c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010724f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107253:	78 18                	js     8010726d <sys_pipe+0x7f>
80107255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107258:	83 ec 0c             	sub    $0xc,%esp
8010725b:	50                   	push   %eax
8010725c:	e8 2c f3 ff ff       	call   8010658d <fdalloc>
80107261:	83 c4 10             	add    $0x10,%esp
80107264:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107267:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010726b:	79 3f                	jns    801072ac <sys_pipe+0xbe>
    if(fd0 >= 0)
8010726d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107271:	78 14                	js     80107287 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107273:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107279:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010727c:	83 c2 08             	add    $0x8,%edx
8010727f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107286:	00 
    fileclose(rf);
80107287:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010728a:	83 ec 0c             	sub    $0xc,%esp
8010728d:	50                   	push   %eax
8010728e:	e8 00 9f ff ff       	call   80101193 <fileclose>
80107293:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107299:	83 ec 0c             	sub    $0xc,%esp
8010729c:	50                   	push   %eax
8010729d:	e8 f1 9e ff ff       	call   80101193 <fileclose>
801072a2:	83 c4 10             	add    $0x10,%esp
    return -1;
801072a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072aa:	eb 18                	jmp    801072c4 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801072ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801072af:	8b 55 f4             	mov    -0xc(%ebp),%edx
801072b2:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801072b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801072b7:	8d 50 04             	lea    0x4(%eax),%edx
801072ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072bd:	89 02                	mov    %eax,(%edx)
  return 0;
801072bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801072c4:	c9                   	leave  
801072c5:	c3                   	ret    

801072c6 <sys_chmod>:

#ifdef CS333_P5 // Added for Project 5: New Commands
int
sys_chmod(void)
{
801072c6:	55                   	push   %ebp
801072c7:	89 e5                	mov    %esp,%ebp
801072c9:	83 ec 18             	sub    $0x18,%esp
  char *pathname;
  int mode;
  struct inode *ip;
  
  if(argint(1, &mode) < 0)
801072cc:	83 ec 08             	sub    $0x8,%esp
801072cf:	8d 45 ec             	lea    -0x14(%ebp),%eax
801072d2:	50                   	push   %eax
801072d3:	6a 01                	push   $0x1
801072d5:	e8 02 f1 ff ff       	call   801063dc <argint>
801072da:	83 c4 10             	add    $0x10,%esp
801072dd:	85 c0                	test   %eax,%eax
801072df:	79 0a                	jns    801072eb <sys_chmod+0x25>
    return -1;
801072e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072e6:	e9 8b 00 00 00       	jmp    80107376 <sys_chmod+0xb0>

  if(mode < 0) // check that mode is non-negative
801072eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801072ee:	85 c0                	test   %eax,%eax
801072f0:	79 07                	jns    801072f9 <sys_chmod+0x33>
    return -1;
801072f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072f7:	eb 7d                	jmp    80107376 <sys_chmod+0xb0>
  
  begin_op(); // from chdir
801072f9:	e8 09 c4 ff ff       	call   80103707 <begin_op>
  if(argstr(0, &pathname) < 0 || 
801072fe:	83 ec 08             	sub    $0x8,%esp
80107301:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107304:	50                   	push   %eax
80107305:	6a 00                	push   $0x0
80107307:	e8 55 f1 ff ff       	call   80106461 <argstr>
8010730c:	83 c4 10             	add    $0x10,%esp
8010730f:	85 c0                	test   %eax,%eax
80107311:	78 18                	js     8010732b <sys_chmod+0x65>
     (ip = namei(pathname)) == 0){ // from chdir
80107313:	8b 45 f0             	mov    -0x10(%ebp),%eax

  if(mode < 0) // check that mode is non-negative
    return -1;
  
  begin_op(); // from chdir
  if(argstr(0, &pathname) < 0 || 
80107316:	83 ec 0c             	sub    $0xc,%esp
80107319:	50                   	push   %eax
8010731a:	e8 c3 b3 ff ff       	call   801026e2 <namei>
8010731f:	83 c4 10             	add    $0x10,%esp
80107322:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107325:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107329:	75 0c                	jne    80107337 <sys_chmod+0x71>
     (ip = namei(pathname)) == 0){ // from chdir
    end_op();
8010732b:	e8 63 c4 ff ff       	call   80103793 <end_op>
    return -1;
80107330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107335:	eb 3f                	jmp    80107376 <sys_chmod+0xb0>
  }

  ilock(ip); // from chdir
80107337:	83 ec 0c             	sub    $0xc,%esp
8010733a:	ff 75 f4             	pushl  -0xc(%ebp)
8010733d:	e8 92 a7 ff ff       	call   80101ad4 <ilock>
80107342:	83 c4 10             	add    $0x10,%esp
  ip->mode.asInt = mode;
80107345:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107348:	89 c2                	mov    %eax,%edx
8010734a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010734d:	89 50 1c             	mov    %edx,0x1c(%eax)
  iupdate(ip); // from link
80107350:	83 ec 0c             	sub    $0xc,%esp
80107353:	ff 75 f4             	pushl  -0xc(%ebp)
80107356:	e8 77 a5 ff ff       	call   801018d2 <iupdate>
8010735b:	83 c4 10             	add    $0x10,%esp
  iunlock(ip); // from link
8010735e:	83 ec 0c             	sub    $0xc,%esp
80107361:	ff 75 f4             	pushl  -0xc(%ebp)
80107364:	e8 f1 a8 ff ff       	call   80101c5a <iunlock>
80107369:	83 c4 10             	add    $0x10,%esp

  end_op(); // from chdir
8010736c:	e8 22 c4 ff ff       	call   80103793 <end_op>

  return 0;
80107371:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107376:	c9                   	leave  
80107377:	c3                   	ret    

80107378 <sys_chown>:

int
sys_chown(void)
{
80107378:	55                   	push   %ebp
80107379:	89 e5                	mov    %esp,%ebp
8010737b:	83 ec 18             	sub    $0x18,%esp
  char *pathname;
  int uid;
  struct inode *ip;

  if(argint(1, &uid) < 0)
8010737e:	83 ec 08             	sub    $0x8,%esp
80107381:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107384:	50                   	push   %eax
80107385:	6a 01                	push   $0x1
80107387:	e8 50 f0 ff ff       	call   801063dc <argint>
8010738c:	83 c4 10             	add    $0x10,%esp
8010738f:	85 c0                	test   %eax,%eax
80107391:	79 0a                	jns    8010739d <sys_chown+0x25>
    return -1;
80107393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107398:	e9 96 00 00 00       	jmp    80107433 <sys_chown+0xbb>

  if(uid < 0 || uid > 32767) // check uid bounds (sysproc)
8010739d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801073a0:	85 c0                	test   %eax,%eax
801073a2:	78 0a                	js     801073ae <sys_chown+0x36>
801073a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801073a7:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801073ac:	7e 07                	jle    801073b5 <sys_chown+0x3d>
    return -1;
801073ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073b3:	eb 7e                	jmp    80107433 <sys_chown+0xbb>

  begin_op(); // from chdir
801073b5:	e8 4d c3 ff ff       	call   80103707 <begin_op>
  if(argstr(0, &pathname) < 0 ||
801073ba:	83 ec 08             	sub    $0x8,%esp
801073bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801073c0:	50                   	push   %eax
801073c1:	6a 00                	push   $0x0
801073c3:	e8 99 f0 ff ff       	call   80106461 <argstr>
801073c8:	83 c4 10             	add    $0x10,%esp
801073cb:	85 c0                	test   %eax,%eax
801073cd:	78 18                	js     801073e7 <sys_chown+0x6f>
     (ip = namei(pathname)) == 0){ // from chdir
801073cf:	8b 45 f0             	mov    -0x10(%ebp),%eax

  if(uid < 0 || uid > 32767) // check uid bounds (sysproc)
    return -1;

  begin_op(); // from chdir
  if(argstr(0, &pathname) < 0 ||
801073d2:	83 ec 0c             	sub    $0xc,%esp
801073d5:	50                   	push   %eax
801073d6:	e8 07 b3 ff ff       	call   801026e2 <namei>
801073db:	83 c4 10             	add    $0x10,%esp
801073de:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073e5:	75 0c                	jne    801073f3 <sys_chown+0x7b>
     (ip = namei(pathname)) == 0){ // from chdir
    end_op();
801073e7:	e8 a7 c3 ff ff       	call   80103793 <end_op>
    return -1; 
801073ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073f1:	eb 40                	jmp    80107433 <sys_chown+0xbb>
  }

  ilock(ip); // from chdir
801073f3:	83 ec 0c             	sub    $0xc,%esp
801073f6:	ff 75 f4             	pushl  -0xc(%ebp)
801073f9:	e8 d6 a6 ff ff       	call   80101ad4 <ilock>
801073fe:	83 c4 10             	add    $0x10,%esp
  ip->uid = uid;
80107401:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107404:	89 c2                	mov    %eax,%edx
80107406:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107409:	66 89 50 18          	mov    %dx,0x18(%eax)
  iupdate(ip); // from link
8010740d:	83 ec 0c             	sub    $0xc,%esp
80107410:	ff 75 f4             	pushl  -0xc(%ebp)
80107413:	e8 ba a4 ff ff       	call   801018d2 <iupdate>
80107418:	83 c4 10             	add    $0x10,%esp
  iunlock(ip); // from link
8010741b:	83 ec 0c             	sub    $0xc,%esp
8010741e:	ff 75 f4             	pushl  -0xc(%ebp)
80107421:	e8 34 a8 ff ff       	call   80101c5a <iunlock>
80107426:	83 c4 10             	add    $0x10,%esp
 
  end_op(); // from chdir
80107429:	e8 65 c3 ff ff       	call   80103793 <end_op>

  return 0;
8010742e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107433:	c9                   	leave  
80107434:	c3                   	ret    

80107435 <sys_chgrp>:

int
sys_chgrp(void)
{
80107435:	55                   	push   %ebp
80107436:	89 e5                	mov    %esp,%ebp
80107438:	83 ec 18             	sub    $0x18,%esp
  char *pathname;
  int gid;
  struct inode *ip;

  if(argint(1, &gid) < 0)
8010743b:	83 ec 08             	sub    $0x8,%esp
8010743e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107441:	50                   	push   %eax
80107442:	6a 01                	push   $0x1
80107444:	e8 93 ef ff ff       	call   801063dc <argint>
80107449:	83 c4 10             	add    $0x10,%esp
8010744c:	85 c0                	test   %eax,%eax
8010744e:	79 0a                	jns    8010745a <sys_chgrp+0x25>
    return -1;
80107450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107455:	e9 96 00 00 00       	jmp    801074f0 <sys_chgrp+0xbb>

  if(gid < 0 || gid > 32767) // check gid bounds (sysproc)
8010745a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010745d:	85 c0                	test   %eax,%eax
8010745f:	78 0a                	js     8010746b <sys_chgrp+0x36>
80107461:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107464:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107469:	7e 07                	jle    80107472 <sys_chgrp+0x3d>
    return -1;
8010746b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107470:	eb 7e                	jmp    801074f0 <sys_chgrp+0xbb>

  begin_op(); // from chdir
80107472:	e8 90 c2 ff ff       	call   80103707 <begin_op>
  if(argstr(0, &pathname) < 0 ||
80107477:	83 ec 08             	sub    $0x8,%esp
8010747a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010747d:	50                   	push   %eax
8010747e:	6a 00                	push   $0x0
80107480:	e8 dc ef ff ff       	call   80106461 <argstr>
80107485:	83 c4 10             	add    $0x10,%esp
80107488:	85 c0                	test   %eax,%eax
8010748a:	78 18                	js     801074a4 <sys_chgrp+0x6f>
     (ip = namei(pathname)) == 0){ // from chdir
8010748c:	8b 45 f0             	mov    -0x10(%ebp),%eax

  if(gid < 0 || gid > 32767) // check gid bounds (sysproc)
    return -1;

  begin_op(); // from chdir
  if(argstr(0, &pathname) < 0 ||
8010748f:	83 ec 0c             	sub    $0xc,%esp
80107492:	50                   	push   %eax
80107493:	e8 4a b2 ff ff       	call   801026e2 <namei>
80107498:	83 c4 10             	add    $0x10,%esp
8010749b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010749e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801074a2:	75 0c                	jne    801074b0 <sys_chgrp+0x7b>
     (ip = namei(pathname)) == 0){ // from chdir
    end_op();
801074a4:	e8 ea c2 ff ff       	call   80103793 <end_op>
    return -1;
801074a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074ae:	eb 40                	jmp    801074f0 <sys_chgrp+0xbb>
  }

  ilock(ip); // from chdir
801074b0:	83 ec 0c             	sub    $0xc,%esp
801074b3:	ff 75 f4             	pushl  -0xc(%ebp)
801074b6:	e8 19 a6 ff ff       	call   80101ad4 <ilock>
801074bb:	83 c4 10             	add    $0x10,%esp
  ip->gid = gid;
801074be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801074c1:	89 c2                	mov    %eax,%edx
801074c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c6:	66 89 50 1a          	mov    %dx,0x1a(%eax)
  iupdate(ip); // from link
801074ca:	83 ec 0c             	sub    $0xc,%esp
801074cd:	ff 75 f4             	pushl  -0xc(%ebp)
801074d0:	e8 fd a3 ff ff       	call   801018d2 <iupdate>
801074d5:	83 c4 10             	add    $0x10,%esp
  iunlock(ip); // from link
801074d8:	83 ec 0c             	sub    $0xc,%esp
801074db:	ff 75 f4             	pushl  -0xc(%ebp)
801074de:	e8 77 a7 ff ff       	call   80101c5a <iunlock>
801074e3:	83 c4 10             	add    $0x10,%esp

  end_op(); // from chdir
801074e6:	e8 a8 c2 ff ff       	call   80103793 <end_op>

  return 0;
801074eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801074f0:	c9                   	leave  
801074f1:	c3                   	ret    

801074f2 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801074f2:	55                   	push   %ebp
801074f3:	89 e5                	mov    %esp,%ebp
801074f5:	83 ec 08             	sub    $0x8,%esp
801074f8:	8b 55 08             	mov    0x8(%ebp),%edx
801074fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801074fe:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107502:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107506:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
8010750a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010750e:	66 ef                	out    %ax,(%dx)
}
80107510:	90                   	nop
80107511:	c9                   	leave  
80107512:	c3                   	ret    

80107513 <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
80107513:	55                   	push   %ebp
80107514:	89 e5                	mov    %esp,%ebp
80107516:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107519:	e8 3c d4 ff ff       	call   8010495a <fork>
}
8010751e:	c9                   	leave  
8010751f:	c3                   	ret    

80107520 <sys_exit>:

int
sys_exit(void)
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	83 ec 08             	sub    $0x8,%esp
  exit();
80107526:	e8 ea d5 ff ff       	call   80104b15 <exit>
  return 0;  // not reached
8010752b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107530:	c9                   	leave  
80107531:	c3                   	ret    

80107532 <sys_wait>:

int
sys_wait(void)
{
80107532:	55                   	push   %ebp
80107533:	89 e5                	mov    %esp,%ebp
80107535:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107538:	e8 13 d7 ff ff       	call   80104c50 <wait>
}
8010753d:	c9                   	leave  
8010753e:	c3                   	ret    

8010753f <sys_kill>:

int
sys_kill(void)
{
8010753f:	55                   	push   %ebp
80107540:	89 e5                	mov    %esp,%ebp
80107542:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107545:	83 ec 08             	sub    $0x8,%esp
80107548:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010754b:	50                   	push   %eax
8010754c:	6a 00                	push   $0x0
8010754e:	e8 89 ee ff ff       	call   801063dc <argint>
80107553:	83 c4 10             	add    $0x10,%esp
80107556:	85 c0                	test   %eax,%eax
80107558:	79 07                	jns    80107561 <sys_kill+0x22>
    return -1;
8010755a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010755f:	eb 0f                	jmp    80107570 <sys_kill+0x31>
  return kill(pid);
80107561:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107564:	83 ec 0c             	sub    $0xc,%esp
80107567:	50                   	push   %eax
80107568:	e8 78 db ff ff       	call   801050e5 <kill>
8010756d:	83 c4 10             	add    $0x10,%esp
}
80107570:	c9                   	leave  
80107571:	c3                   	ret    

80107572 <sys_getpid>:

int
sys_getpid(void)
{
80107572:	55                   	push   %ebp
80107573:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107575:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010757b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010757e:	5d                   	pop    %ebp
8010757f:	c3                   	ret    

80107580 <sys_sbrk>:

int
sys_sbrk(void)
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107586:	83 ec 08             	sub    $0x8,%esp
80107589:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010758c:	50                   	push   %eax
8010758d:	6a 00                	push   $0x0
8010758f:	e8 48 ee ff ff       	call   801063dc <argint>
80107594:	83 c4 10             	add    $0x10,%esp
80107597:	85 c0                	test   %eax,%eax
80107599:	79 07                	jns    801075a2 <sys_sbrk+0x22>
    return -1;
8010759b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075a0:	eb 28                	jmp    801075ca <sys_sbrk+0x4a>
  addr = proc->sz;
801075a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801075a8:	8b 00                	mov    (%eax),%eax
801075aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801075ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075b0:	83 ec 0c             	sub    $0xc,%esp
801075b3:	50                   	push   %eax
801075b4:	e8 fe d2 ff ff       	call   801048b7 <growproc>
801075b9:	83 c4 10             	add    $0x10,%esp
801075bc:	85 c0                	test   %eax,%eax
801075be:	79 07                	jns    801075c7 <sys_sbrk+0x47>
    return -1;
801075c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075c5:	eb 03                	jmp    801075ca <sys_sbrk+0x4a>
  return addr;
801075c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801075ca:	c9                   	leave  
801075cb:	c3                   	ret    

801075cc <sys_sleep>:

int
sys_sleep(void)
{
801075cc:	55                   	push   %ebp
801075cd:	89 e5                	mov    %esp,%ebp
801075cf:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801075d2:	83 ec 08             	sub    $0x8,%esp
801075d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801075d8:	50                   	push   %eax
801075d9:	6a 00                	push   $0x0
801075db:	e8 fc ed ff ff       	call   801063dc <argint>
801075e0:	83 c4 10             	add    $0x10,%esp
801075e3:	85 c0                	test   %eax,%eax
801075e5:	79 07                	jns    801075ee <sys_sleep+0x22>
    return -1;
801075e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075ec:	eb 44                	jmp    80107632 <sys_sleep+0x66>
  ticks0 = ticks;
801075ee:	a1 e0 78 11 80       	mov    0x801178e0,%eax
801075f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801075f6:	eb 26                	jmp    8010761e <sys_sleep+0x52>
    if(proc->killed){
801075f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801075fe:	8b 40 24             	mov    0x24(%eax),%eax
80107601:	85 c0                	test   %eax,%eax
80107603:	74 07                	je     8010760c <sys_sleep+0x40>
      return -1;
80107605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010760a:	eb 26                	jmp    80107632 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
8010760c:	83 ec 08             	sub    $0x8,%esp
8010760f:	6a 00                	push   $0x0
80107611:	68 e0 78 11 80       	push   $0x801178e0
80107616:	e8 ac d9 ff ff       	call   80104fc7 <sleep>
8010761b:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010761e:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80107623:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107626:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107629:	39 d0                	cmp    %edx,%eax
8010762b:	72 cb                	jb     801075f8 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
8010762d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107632:	c9                   	leave  
80107633:	c3                   	ret    

80107634 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80107634:	55                   	push   %ebp
80107635:	89 e5                	mov    %esp,%ebp
80107637:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
8010763a:	a1 e0 78 11 80       	mov    0x801178e0,%eax
8010763f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107642:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107645:	c9                   	leave  
80107646:	c3                   	ret    

80107647 <sys_halt>:

//Turn of the computer
int sys_halt(void){
80107647:	55                   	push   %ebp
80107648:	89 e5                	mov    %esp,%ebp
8010764a:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
8010764d:	83 ec 0c             	sub    $0xc,%esp
80107650:	68 c1 9e 10 80       	push   $0x80109ec1
80107655:	e8 6c 8d ff ff       	call   801003c6 <cprintf>
8010765a:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
8010765d:	83 ec 08             	sub    $0x8,%esp
80107660:	68 00 20 00 00       	push   $0x2000
80107665:	68 04 06 00 00       	push   $0x604
8010766a:	e8 83 fe ff ff       	call   801074f2 <outw>
8010766f:	83 c4 10             	add    $0x10,%esp
  return 0;
80107672:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107677:	c9                   	leave  
80107678:	c3                   	ret    

80107679 <sys_date>:

// returns the rtcdate
int
sys_date(void) // Added for Project 1: The date() System Call
{
80107679:	55                   	push   %ebp
8010767a:	89 e5                	mov    %esp,%ebp
8010767c:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if(argptr(0, (void*)&d, sizeof(*d)) < 0)
8010767f:	83 ec 04             	sub    $0x4,%esp
80107682:	6a 18                	push   $0x18
80107684:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107687:	50                   	push   %eax
80107688:	6a 00                	push   $0x0
8010768a:	e8 75 ed ff ff       	call   80106404 <argptr>
8010768f:	83 c4 10             	add    $0x10,%esp
80107692:	85 c0                	test   %eax,%eax
80107694:	79 07                	jns    8010769d <sys_date+0x24>
    return -1;
80107696:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010769b:	eb 14                	jmp    801076b1 <sys_date+0x38>

  cmostime(d);
8010769d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a0:	83 ec 0c             	sub    $0xc,%esp
801076a3:	50                   	push   %eax
801076a4:	e8 d9 bc ff ff       	call   80103382 <cmostime>
801076a9:	83 c4 10             	add    $0x10,%esp
  return 0;
801076ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076b1:	c9                   	leave  
801076b2:	c3                   	ret    

801076b3 <sys_getuid>:

// START: Added for Project 2: UIDs and GIDs and PPIDs
// get uid of current process
int
sys_getuid(void)
{
801076b3:	55                   	push   %ebp
801076b4:	89 e5                	mov    %esp,%ebp
  return proc->uid;
801076b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076bc:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
801076c2:	5d                   	pop    %ebp
801076c3:	c3                   	ret    

801076c4 <sys_getgid>:

// get gid of current process
int
sys_getgid(void)
{
801076c4:	55                   	push   %ebp
801076c5:	89 e5                	mov    %esp,%ebp
  return proc->gid;
801076c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076cd:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
801076d3:	5d                   	pop    %ebp
801076d4:	c3                   	ret    

801076d5 <sys_getppid>:

// get pid of parent process (init is its own parent)
int
sys_getppid(void)
{
801076d5:	55                   	push   %ebp
801076d6:	89 e5                	mov    %esp,%ebp
  if (proc->pid == 1)
801076d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076de:	8b 40 10             	mov    0x10(%eax),%eax
801076e1:	83 f8 01             	cmp    $0x1,%eax
801076e4:	75 07                	jne    801076ed <sys_getppid+0x18>
    return 1;
801076e6:	b8 01 00 00 00       	mov    $0x1,%eax
801076eb:	eb 0c                	jmp    801076f9 <sys_getppid+0x24>
  else
    return proc->parent->pid;
801076ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076f3:	8b 40 14             	mov    0x14(%eax),%eax
801076f6:	8b 40 10             	mov    0x10(%eax),%eax
}
801076f9:	5d                   	pop    %ebp
801076fa:	c3                   	ret    

801076fb <sys_setuid>:

// set uid
int
sys_setuid(void)
{
801076fb:	55                   	push   %ebp
801076fc:	89 e5                	mov    %esp,%ebp
801076fe:	83 ec 18             	sub    $0x18,%esp
  int uid;

  if (argint(0, &uid) < 0)
80107701:	83 ec 08             	sub    $0x8,%esp
80107704:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107707:	50                   	push   %eax
80107708:	6a 00                	push   $0x0
8010770a:	e8 cd ec ff ff       	call   801063dc <argint>
8010770f:	83 c4 10             	add    $0x10,%esp
80107712:	85 c0                	test   %eax,%eax
80107714:	79 07                	jns    8010771d <sys_setuid+0x22>
    return -1;
80107716:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010771b:	eb 2c                	jmp    80107749 <sys_setuid+0x4e>
  
  if (0 <= uid && uid <= 32767){
8010771d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107720:	85 c0                	test   %eax,%eax
80107722:	78 20                	js     80107744 <sys_setuid+0x49>
80107724:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107727:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010772c:	7f 16                	jg     80107744 <sys_setuid+0x49>
    proc->uid = uid;
8010772e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107734:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107737:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    return 0;
8010773d:	b8 00 00 00 00       	mov    $0x0,%eax
80107742:	eb 05                	jmp    80107749 <sys_setuid+0x4e>
  }
  else
    return -1;
80107744:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
80107749:	c9                   	leave  
8010774a:	c3                   	ret    

8010774b <sys_setgid>:

// set gid
int
sys_setgid(void)
{
8010774b:	55                   	push   %ebp
8010774c:	89 e5                	mov    %esp,%ebp
8010774e:	83 ec 18             	sub    $0x18,%esp
  int gid;

  if (argint(0, &gid) < 0)
80107751:	83 ec 08             	sub    $0x8,%esp
80107754:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107757:	50                   	push   %eax
80107758:	6a 00                	push   $0x0
8010775a:	e8 7d ec ff ff       	call   801063dc <argint>
8010775f:	83 c4 10             	add    $0x10,%esp
80107762:	85 c0                	test   %eax,%eax
80107764:	79 07                	jns    8010776d <sys_setgid+0x22>
    return -1;
80107766:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010776b:	eb 2c                	jmp    80107799 <sys_setgid+0x4e>

  if (0 <= gid && gid <= 32767){
8010776d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107770:	85 c0                	test   %eax,%eax
80107772:	78 20                	js     80107794 <sys_setgid+0x49>
80107774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107777:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010777c:	7f 16                	jg     80107794 <sys_setgid+0x49>
    proc->gid = gid;
8010777e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107784:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107787:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    return 0;
8010778d:	b8 00 00 00 00       	mov    $0x0,%eax
80107792:	eb 05                	jmp    80107799 <sys_setgid+0x4e>
  }
  else
    return -1;
80107794:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107799:	c9                   	leave  
8010779a:	c3                   	ret    

8010779b <sys_getprocs>:
// END: Added for Project 2: UIDs and GIDs and PPIDs

// get list of procs (for ps display)
int
sys_getprocs(void) // Added for Project 2: The "ps" Command
{
8010779b:	55                   	push   %ebp
8010779c:	89 e5                	mov    %esp,%ebp
8010779e:	83 ec 18             	sub    $0x18,%esp
  int max;
  struct uproc *table;

  if (argint(0, &max) < 0)
801077a1:	83 ec 08             	sub    $0x8,%esp
801077a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801077a7:	50                   	push   %eax
801077a8:	6a 00                	push   $0x0
801077aa:	e8 2d ec ff ff       	call   801063dc <argint>
801077af:	83 c4 10             	add    $0x10,%esp
801077b2:	85 c0                	test   %eax,%eax
801077b4:	79 07                	jns    801077bd <sys_getprocs+0x22>
    return -1;
801077b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077bb:	eb 31                	jmp    801077ee <sys_getprocs+0x53>

  if (argptr(1, (void*)&table, sizeof(*table)) < 0)
801077bd:	83 ec 04             	sub    $0x4,%esp
801077c0:	6a 60                	push   $0x60
801077c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801077c5:	50                   	push   %eax
801077c6:	6a 01                	push   $0x1
801077c8:	e8 37 ec ff ff       	call   80106404 <argptr>
801077cd:	83 c4 10             	add    $0x10,%esp
801077d0:	85 c0                	test   %eax,%eax
801077d2:	79 07                	jns    801077db <sys_getprocs+0x40>
    return -1;
801077d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077d9:	eb 13                	jmp    801077ee <sys_getprocs+0x53>

  return getuprocs(max, table); // get uproc struct array from proc.c
801077db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801077e1:	83 ec 08             	sub    $0x8,%esp
801077e4:	50                   	push   %eax
801077e5:	52                   	push   %edx
801077e6:	e8 8d de ff ff       	call   80105678 <getuprocs>
801077eb:	83 c4 10             	add    $0x10,%esp
}
801077ee:	c9                   	leave  
801077ef:	c3                   	ret    

801077f0 <sys_setpriority>:

// sets proc with PID of pid to priority and resets budget
// returns 0 on success and -1 on error
int
sys_setpriority(void) // Added for Project 4: The setpriority() System Call
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int priority;

  // get pid/ priority parameters off stack (return -1 on error)
  if(argint(0, &pid) < 0)
801077f6:	83 ec 08             	sub    $0x8,%esp
801077f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801077fc:	50                   	push   %eax
801077fd:	6a 00                	push   $0x0
801077ff:	e8 d8 eb ff ff       	call   801063dc <argint>
80107804:	83 c4 10             	add    $0x10,%esp
80107807:	85 c0                	test   %eax,%eax
80107809:	79 07                	jns    80107812 <sys_setpriority+0x22>
    return -1;
8010780b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107810:	eb 4b                	jmp    8010785d <sys_setpriority+0x6d>
  if(argint(1, &priority) < 0)
80107812:	83 ec 08             	sub    $0x8,%esp
80107815:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107818:	50                   	push   %eax
80107819:	6a 01                	push   $0x1
8010781b:	e8 bc eb ff ff       	call   801063dc <argint>
80107820:	83 c4 10             	add    $0x10,%esp
80107823:	85 c0                	test   %eax,%eax
80107825:	79 07                	jns    8010782e <sys_setpriority+0x3e>
    return -1;
80107827:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010782c:	eb 2f                	jmp    8010785d <sys_setpriority+0x6d>

  // check if parameters have valid values (return -1 on error)
  if (pid < 0 || priority < 0 || priority > MAX)
8010782e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107831:	85 c0                	test   %eax,%eax
80107833:	78 0e                	js     80107843 <sys_setpriority+0x53>
80107835:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107838:	85 c0                	test   %eax,%eax
8010783a:	78 07                	js     80107843 <sys_setpriority+0x53>
8010783c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010783f:	85 c0                	test   %eax,%eax
80107841:	7e 07                	jle    8010784a <sys_setpriority+0x5a>
    return -1;
80107843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107848:	eb 13                	jmp    8010785d <sys_setpriority+0x6d>

  // call setpriority (and return its return code)
  return setpriority(pid, priority);
8010784a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010784d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107850:	83 ec 08             	sub    $0x8,%esp
80107853:	52                   	push   %edx
80107854:	50                   	push   %eax
80107855:	e8 0a e3 ff ff       	call   80105b64 <setpriority>
8010785a:	83 c4 10             	add    $0x10,%esp
}
8010785d:	c9                   	leave  
8010785e:	c3                   	ret    

8010785f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010785f:	55                   	push   %ebp
80107860:	89 e5                	mov    %esp,%ebp
80107862:	83 ec 08             	sub    $0x8,%esp
80107865:	8b 55 08             	mov    0x8(%ebp),%edx
80107868:	8b 45 0c             	mov    0xc(%ebp),%eax
8010786b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010786f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107872:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107876:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010787a:	ee                   	out    %al,(%dx)
}
8010787b:	90                   	nop
8010787c:	c9                   	leave  
8010787d:	c3                   	ret    

8010787e <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010787e:	55                   	push   %ebp
8010787f:	89 e5                	mov    %esp,%ebp
80107881:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107884:	6a 34                	push   $0x34
80107886:	6a 43                	push   $0x43
80107888:	e8 d2 ff ff ff       	call   8010785f <outb>
8010788d:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107890:	68 9c 00 00 00       	push   $0x9c
80107895:	6a 40                	push   $0x40
80107897:	e8 c3 ff ff ff       	call   8010785f <outb>
8010789c:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010789f:	6a 2e                	push   $0x2e
801078a1:	6a 40                	push   $0x40
801078a3:	e8 b7 ff ff ff       	call   8010785f <outb>
801078a8:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801078ab:	83 ec 0c             	sub    $0xc,%esp
801078ae:	6a 00                	push   $0x0
801078b0:	e8 30 c8 ff ff       	call   801040e5 <picenable>
801078b5:	83 c4 10             	add    $0x10,%esp
}
801078b8:	90                   	nop
801078b9:	c9                   	leave  
801078ba:	c3                   	ret    

801078bb <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801078bb:	1e                   	push   %ds
  pushl %es
801078bc:	06                   	push   %es
  pushl %fs
801078bd:	0f a0                	push   %fs
  pushl %gs
801078bf:	0f a8                	push   %gs
  pushal
801078c1:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801078c2:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801078c6:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801078c8:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801078ca:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801078ce:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801078d0:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801078d2:	54                   	push   %esp
  call trap
801078d3:	e8 ce 01 00 00       	call   80107aa6 <trap>
  addl $4, %esp
801078d8:	83 c4 04             	add    $0x4,%esp

801078db <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801078db:	61                   	popa   
  popl %gs
801078dc:	0f a9                	pop    %gs
  popl %fs
801078de:	0f a1                	pop    %fs
  popl %es
801078e0:	07                   	pop    %es
  popl %ds
801078e1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801078e2:	83 c4 08             	add    $0x8,%esp
  iret
801078e5:	cf                   	iret   

801078e6 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
801078e6:	55                   	push   %ebp
801078e7:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
801078e9:	8b 45 08             	mov    0x8(%ebp),%eax
801078ec:	f0 ff 00             	lock incl (%eax)
}
801078ef:	90                   	nop
801078f0:	5d                   	pop    %ebp
801078f1:	c3                   	ret    

801078f2 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801078f2:	55                   	push   %ebp
801078f3:	89 e5                	mov    %esp,%ebp
801078f5:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801078f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801078fb:	83 e8 01             	sub    $0x1,%eax
801078fe:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107902:	8b 45 08             	mov    0x8(%ebp),%eax
80107905:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107909:	8b 45 08             	mov    0x8(%ebp),%eax
8010790c:	c1 e8 10             	shr    $0x10,%eax
8010790f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107913:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107916:	0f 01 18             	lidtl  (%eax)
}
80107919:	90                   	nop
8010791a:	c9                   	leave  
8010791b:	c3                   	ret    

8010791c <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010791c:	55                   	push   %ebp
8010791d:	89 e5                	mov    %esp,%ebp
8010791f:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107922:	0f 20 d0             	mov    %cr2,%eax
80107925:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107928:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010792b:	c9                   	leave  
8010792c:	c3                   	ret    

8010792d <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
8010792d:	55                   	push   %ebp
8010792e:	89 e5                	mov    %esp,%ebp
80107930:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107933:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010793a:	e9 c3 00 00 00       	jmp    80107a02 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010793f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107942:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
80107949:	89 c2                	mov    %eax,%edx
8010794b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010794e:	66 89 14 c5 e0 70 11 	mov    %dx,-0x7fee8f20(,%eax,8)
80107955:	80 
80107956:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107959:	66 c7 04 c5 e2 70 11 	movw   $0x8,-0x7fee8f1e(,%eax,8)
80107960:	80 08 00 
80107963:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107966:	0f b6 14 c5 e4 70 11 	movzbl -0x7fee8f1c(,%eax,8),%edx
8010796d:	80 
8010796e:	83 e2 e0             	and    $0xffffffe0,%edx
80107971:	88 14 c5 e4 70 11 80 	mov    %dl,-0x7fee8f1c(,%eax,8)
80107978:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010797b:	0f b6 14 c5 e4 70 11 	movzbl -0x7fee8f1c(,%eax,8),%edx
80107982:	80 
80107983:	83 e2 1f             	and    $0x1f,%edx
80107986:	88 14 c5 e4 70 11 80 	mov    %dl,-0x7fee8f1c(,%eax,8)
8010798d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107990:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80107997:	80 
80107998:	83 e2 f0             	and    $0xfffffff0,%edx
8010799b:	83 ca 0e             	or     $0xe,%edx
8010799e:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
801079a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079a8:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
801079af:	80 
801079b0:	83 e2 ef             	and    $0xffffffef,%edx
801079b3:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
801079ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079bd:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
801079c4:	80 
801079c5:	83 e2 9f             	and    $0xffffff9f,%edx
801079c8:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
801079cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079d2:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
801079d9:	80 
801079da:	83 ca 80             	or     $0xffffff80,%edx
801079dd:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
801079e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079e7:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
801079ee:	c1 e8 10             	shr    $0x10,%eax
801079f1:	89 c2                	mov    %eax,%edx
801079f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079f6:	66 89 14 c5 e6 70 11 	mov    %dx,-0x7fee8f1a(,%eax,8)
801079fd:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801079fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107a02:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107a09:	0f 8e 30 ff ff ff    	jle    8010793f <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107a0f:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107a14:	66 a3 e0 72 11 80    	mov    %ax,0x801172e0
80107a1a:	66 c7 05 e2 72 11 80 	movw   $0x8,0x801172e2
80107a21:	08 00 
80107a23:	0f b6 05 e4 72 11 80 	movzbl 0x801172e4,%eax
80107a2a:	83 e0 e0             	and    $0xffffffe0,%eax
80107a2d:	a2 e4 72 11 80       	mov    %al,0x801172e4
80107a32:	0f b6 05 e4 72 11 80 	movzbl 0x801172e4,%eax
80107a39:	83 e0 1f             	and    $0x1f,%eax
80107a3c:	a2 e4 72 11 80       	mov    %al,0x801172e4
80107a41:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107a48:	83 c8 0f             	or     $0xf,%eax
80107a4b:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107a50:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107a57:	83 e0 ef             	and    $0xffffffef,%eax
80107a5a:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107a5f:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107a66:	83 c8 60             	or     $0x60,%eax
80107a69:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107a6e:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80107a75:	83 c8 80             	or     $0xffffff80,%eax
80107a78:	a2 e5 72 11 80       	mov    %al,0x801172e5
80107a7d:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107a82:	c1 e8 10             	shr    $0x10,%eax
80107a85:	66 a3 e6 72 11 80    	mov    %ax,0x801172e6
  
}
80107a8b:	90                   	nop
80107a8c:	c9                   	leave  
80107a8d:	c3                   	ret    

80107a8e <idtinit>:

void
idtinit(void)
{
80107a8e:	55                   	push   %ebp
80107a8f:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107a91:	68 00 08 00 00       	push   $0x800
80107a96:	68 e0 70 11 80       	push   $0x801170e0
80107a9b:	e8 52 fe ff ff       	call   801078f2 <lidt>
80107aa0:	83 c4 08             	add    $0x8,%esp
}
80107aa3:	90                   	nop
80107aa4:	c9                   	leave  
80107aa5:	c3                   	ret    

80107aa6 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107aa6:	55                   	push   %ebp
80107aa7:	89 e5                	mov    %esp,%ebp
80107aa9:	57                   	push   %edi
80107aaa:	56                   	push   %esi
80107aab:	53                   	push   %ebx
80107aac:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ab2:	8b 40 30             	mov    0x30(%eax),%eax
80107ab5:	83 f8 40             	cmp    $0x40,%eax
80107ab8:	75 3e                	jne    80107af8 <trap+0x52>
    if(proc->killed)
80107aba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ac0:	8b 40 24             	mov    0x24(%eax),%eax
80107ac3:	85 c0                	test   %eax,%eax
80107ac5:	74 05                	je     80107acc <trap+0x26>
      exit();
80107ac7:	e8 49 d0 ff ff       	call   80104b15 <exit>
    proc->tf = tf;
80107acc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ad2:	8b 55 08             	mov    0x8(%ebp),%edx
80107ad5:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107ad8:	e8 b5 e9 ff ff       	call   80106492 <syscall>
    if(proc->killed)
80107add:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ae3:	8b 40 24             	mov    0x24(%eax),%eax
80107ae6:	85 c0                	test   %eax,%eax
80107ae8:	0f 84 fe 01 00 00    	je     80107cec <trap+0x246>
      exit();
80107aee:	e8 22 d0 ff ff       	call   80104b15 <exit>
    return;
80107af3:	e9 f4 01 00 00       	jmp    80107cec <trap+0x246>
  }

  switch(tf->trapno){
80107af8:	8b 45 08             	mov    0x8(%ebp),%eax
80107afb:	8b 40 30             	mov    0x30(%eax),%eax
80107afe:	83 e8 20             	sub    $0x20,%eax
80107b01:	83 f8 1f             	cmp    $0x1f,%eax
80107b04:	0f 87 a3 00 00 00    	ja     80107bad <trap+0x107>
80107b0a:	8b 04 85 74 9f 10 80 	mov    -0x7fef608c(,%eax,4),%eax
80107b11:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80107b13:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b19:	0f b6 00             	movzbl (%eax),%eax
80107b1c:	84 c0                	test   %al,%al
80107b1e:	75 20                	jne    80107b40 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107b20:	83 ec 0c             	sub    $0xc,%esp
80107b23:	68 e0 78 11 80       	push   $0x801178e0
80107b28:	e8 b9 fd ff ff       	call   801078e6 <atom_inc>
80107b2d:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107b30:	83 ec 0c             	sub    $0xc,%esp
80107b33:	68 e0 78 11 80       	push   $0x801178e0
80107b38:	e8 71 d5 ff ff       	call   801050ae <wakeup>
80107b3d:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107b40:	e8 9a b6 ff ff       	call   801031df <lapiceoi>
    break;
80107b45:	e9 1c 01 00 00       	jmp    80107c66 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107b4a:	e8 a3 ae ff ff       	call   801029f2 <ideintr>
    lapiceoi();
80107b4f:	e8 8b b6 ff ff       	call   801031df <lapiceoi>
    break;
80107b54:	e9 0d 01 00 00       	jmp    80107c66 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107b59:	e8 83 b4 ff ff       	call   80102fe1 <kbdintr>
    lapiceoi();
80107b5e:	e8 7c b6 ff ff       	call   801031df <lapiceoi>
    break;
80107b63:	e9 fe 00 00 00       	jmp    80107c66 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107b68:	e8 60 03 00 00       	call   80107ecd <uartintr>
    lapiceoi();
80107b6d:	e8 6d b6 ff ff       	call   801031df <lapiceoi>
    break;
80107b72:	e9 ef 00 00 00       	jmp    80107c66 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107b77:	8b 45 08             	mov    0x8(%ebp),%eax
80107b7a:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b80:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107b84:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107b87:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b8d:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107b90:	0f b6 c0             	movzbl %al,%eax
80107b93:	51                   	push   %ecx
80107b94:	52                   	push   %edx
80107b95:	50                   	push   %eax
80107b96:	68 d4 9e 10 80       	push   $0x80109ed4
80107b9b:	e8 26 88 ff ff       	call   801003c6 <cprintf>
80107ba0:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107ba3:	e8 37 b6 ff ff       	call   801031df <lapiceoi>
    break;
80107ba8:	e9 b9 00 00 00       	jmp    80107c66 <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107bad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107bb3:	85 c0                	test   %eax,%eax
80107bb5:	74 11                	je     80107bc8 <trap+0x122>
80107bb7:	8b 45 08             	mov    0x8(%ebp),%eax
80107bba:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107bbe:	0f b7 c0             	movzwl %ax,%eax
80107bc1:	83 e0 03             	and    $0x3,%eax
80107bc4:	85 c0                	test   %eax,%eax
80107bc6:	75 40                	jne    80107c08 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107bc8:	e8 4f fd ff ff       	call   8010791c <rcr2>
80107bcd:	89 c3                	mov    %eax,%ebx
80107bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80107bd2:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107bd5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107bdb:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107bde:	0f b6 d0             	movzbl %al,%edx
80107be1:	8b 45 08             	mov    0x8(%ebp),%eax
80107be4:	8b 40 30             	mov    0x30(%eax),%eax
80107be7:	83 ec 0c             	sub    $0xc,%esp
80107bea:	53                   	push   %ebx
80107beb:	51                   	push   %ecx
80107bec:	52                   	push   %edx
80107bed:	50                   	push   %eax
80107bee:	68 f8 9e 10 80       	push   $0x80109ef8
80107bf3:	e8 ce 87 ff ff       	call   801003c6 <cprintf>
80107bf8:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107bfb:	83 ec 0c             	sub    $0xc,%esp
80107bfe:	68 2a 9f 10 80       	push   $0x80109f2a
80107c03:	e8 5e 89 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107c08:	e8 0f fd ff ff       	call   8010791c <rcr2>
80107c0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c10:	8b 45 08             	mov    0x8(%ebp),%eax
80107c13:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107c16:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c1c:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107c1f:	0f b6 d8             	movzbl %al,%ebx
80107c22:	8b 45 08             	mov    0x8(%ebp),%eax
80107c25:	8b 48 34             	mov    0x34(%eax),%ecx
80107c28:	8b 45 08             	mov    0x8(%ebp),%eax
80107c2b:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107c2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c34:	8d 78 6c             	lea    0x6c(%eax),%edi
80107c37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107c3d:	8b 40 10             	mov    0x10(%eax),%eax
80107c40:	ff 75 e4             	pushl  -0x1c(%ebp)
80107c43:	56                   	push   %esi
80107c44:	53                   	push   %ebx
80107c45:	51                   	push   %ecx
80107c46:	52                   	push   %edx
80107c47:	57                   	push   %edi
80107c48:	50                   	push   %eax
80107c49:	68 30 9f 10 80       	push   $0x80109f30
80107c4e:	e8 73 87 ff ff       	call   801003c6 <cprintf>
80107c53:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107c56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c5c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107c63:	eb 01                	jmp    80107c66 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107c65:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107c66:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c6c:	85 c0                	test   %eax,%eax
80107c6e:	74 24                	je     80107c94 <trap+0x1ee>
80107c70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c76:	8b 40 24             	mov    0x24(%eax),%eax
80107c79:	85 c0                	test   %eax,%eax
80107c7b:	74 17                	je     80107c94 <trap+0x1ee>
80107c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80107c80:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107c84:	0f b7 c0             	movzwl %ax,%eax
80107c87:	83 e0 03             	and    $0x3,%eax
80107c8a:	83 f8 03             	cmp    $0x3,%eax
80107c8d:	75 05                	jne    80107c94 <trap+0x1ee>
    exit();
80107c8f:	e8 81 ce ff ff       	call   80104b15 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107c94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c9a:	85 c0                	test   %eax,%eax
80107c9c:	74 1e                	je     80107cbc <trap+0x216>
80107c9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ca4:	8b 40 0c             	mov    0xc(%eax),%eax
80107ca7:	83 f8 04             	cmp    $0x4,%eax
80107caa:	75 10                	jne    80107cbc <trap+0x216>
80107cac:	8b 45 08             	mov    0x8(%ebp),%eax
80107caf:	8b 40 30             	mov    0x30(%eax),%eax
80107cb2:	83 f8 20             	cmp    $0x20,%eax
80107cb5:	75 05                	jne    80107cbc <trap+0x216>
    yield();
80107cb7:	e8 8a d2 ff ff       	call   80104f46 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107cbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cc2:	85 c0                	test   %eax,%eax
80107cc4:	74 27                	je     80107ced <trap+0x247>
80107cc6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ccc:	8b 40 24             	mov    0x24(%eax),%eax
80107ccf:	85 c0                	test   %eax,%eax
80107cd1:	74 1a                	je     80107ced <trap+0x247>
80107cd3:	8b 45 08             	mov    0x8(%ebp),%eax
80107cd6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107cda:	0f b7 c0             	movzwl %ax,%eax
80107cdd:	83 e0 03             	and    $0x3,%eax
80107ce0:	83 f8 03             	cmp    $0x3,%eax
80107ce3:	75 08                	jne    80107ced <trap+0x247>
    exit();
80107ce5:	e8 2b ce ff ff       	call   80104b15 <exit>
80107cea:	eb 01                	jmp    80107ced <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107cec:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cf0:	5b                   	pop    %ebx
80107cf1:	5e                   	pop    %esi
80107cf2:	5f                   	pop    %edi
80107cf3:	5d                   	pop    %ebp
80107cf4:	c3                   	ret    

80107cf5 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80107cf5:	55                   	push   %ebp
80107cf6:	89 e5                	mov    %esp,%ebp
80107cf8:	83 ec 14             	sub    $0x14,%esp
80107cfb:	8b 45 08             	mov    0x8(%ebp),%eax
80107cfe:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107d02:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107d06:	89 c2                	mov    %eax,%edx
80107d08:	ec                   	in     (%dx),%al
80107d09:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107d0c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107d10:	c9                   	leave  
80107d11:	c3                   	ret    

80107d12 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107d12:	55                   	push   %ebp
80107d13:	89 e5                	mov    %esp,%ebp
80107d15:	83 ec 08             	sub    $0x8,%esp
80107d18:	8b 55 08             	mov    0x8(%ebp),%edx
80107d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d1e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107d22:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107d25:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107d29:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107d2d:	ee                   	out    %al,(%dx)
}
80107d2e:	90                   	nop
80107d2f:	c9                   	leave  
80107d30:	c3                   	ret    

80107d31 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107d31:	55                   	push   %ebp
80107d32:	89 e5                	mov    %esp,%ebp
80107d34:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107d37:	6a 00                	push   $0x0
80107d39:	68 fa 03 00 00       	push   $0x3fa
80107d3e:	e8 cf ff ff ff       	call   80107d12 <outb>
80107d43:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107d46:	68 80 00 00 00       	push   $0x80
80107d4b:	68 fb 03 00 00       	push   $0x3fb
80107d50:	e8 bd ff ff ff       	call   80107d12 <outb>
80107d55:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107d58:	6a 0c                	push   $0xc
80107d5a:	68 f8 03 00 00       	push   $0x3f8
80107d5f:	e8 ae ff ff ff       	call   80107d12 <outb>
80107d64:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107d67:	6a 00                	push   $0x0
80107d69:	68 f9 03 00 00       	push   $0x3f9
80107d6e:	e8 9f ff ff ff       	call   80107d12 <outb>
80107d73:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107d76:	6a 03                	push   $0x3
80107d78:	68 fb 03 00 00       	push   $0x3fb
80107d7d:	e8 90 ff ff ff       	call   80107d12 <outb>
80107d82:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107d85:	6a 00                	push   $0x0
80107d87:	68 fc 03 00 00       	push   $0x3fc
80107d8c:	e8 81 ff ff ff       	call   80107d12 <outb>
80107d91:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107d94:	6a 01                	push   $0x1
80107d96:	68 f9 03 00 00       	push   $0x3f9
80107d9b:	e8 72 ff ff ff       	call   80107d12 <outb>
80107da0:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107da3:	68 fd 03 00 00       	push   $0x3fd
80107da8:	e8 48 ff ff ff       	call   80107cf5 <inb>
80107dad:	83 c4 04             	add    $0x4,%esp
80107db0:	3c ff                	cmp    $0xff,%al
80107db2:	74 6e                	je     80107e22 <uartinit+0xf1>
    return;
  uart = 1;
80107db4:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
80107dbb:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107dbe:	68 fa 03 00 00       	push   $0x3fa
80107dc3:	e8 2d ff ff ff       	call   80107cf5 <inb>
80107dc8:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107dcb:	68 f8 03 00 00       	push   $0x3f8
80107dd0:	e8 20 ff ff ff       	call   80107cf5 <inb>
80107dd5:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107dd8:	83 ec 0c             	sub    $0xc,%esp
80107ddb:	6a 04                	push   $0x4
80107ddd:	e8 03 c3 ff ff       	call   801040e5 <picenable>
80107de2:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107de5:	83 ec 08             	sub    $0x8,%esp
80107de8:	6a 00                	push   $0x0
80107dea:	6a 04                	push   $0x4
80107dec:	e8 a3 ae ff ff       	call   80102c94 <ioapicenable>
80107df1:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107df4:	c7 45 f4 f4 9f 10 80 	movl   $0x80109ff4,-0xc(%ebp)
80107dfb:	eb 19                	jmp    80107e16 <uartinit+0xe5>
    uartputc(*p);
80107dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e00:	0f b6 00             	movzbl (%eax),%eax
80107e03:	0f be c0             	movsbl %al,%eax
80107e06:	83 ec 0c             	sub    $0xc,%esp
80107e09:	50                   	push   %eax
80107e0a:	e8 16 00 00 00       	call   80107e25 <uartputc>
80107e0f:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107e12:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e19:	0f b6 00             	movzbl (%eax),%eax
80107e1c:	84 c0                	test   %al,%al
80107e1e:	75 dd                	jne    80107dfd <uartinit+0xcc>
80107e20:	eb 01                	jmp    80107e23 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107e22:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107e23:	c9                   	leave  
80107e24:	c3                   	ret    

80107e25 <uartputc>:

void
uartputc(int c)
{
80107e25:	55                   	push   %ebp
80107e26:	89 e5                	mov    %esp,%ebp
80107e28:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107e2b:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80107e30:	85 c0                	test   %eax,%eax
80107e32:	74 53                	je     80107e87 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107e34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107e3b:	eb 11                	jmp    80107e4e <uartputc+0x29>
    microdelay(10);
80107e3d:	83 ec 0c             	sub    $0xc,%esp
80107e40:	6a 0a                	push   $0xa
80107e42:	e8 b3 b3 ff ff       	call   801031fa <microdelay>
80107e47:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107e4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107e4e:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107e52:	7f 1a                	jg     80107e6e <uartputc+0x49>
80107e54:	83 ec 0c             	sub    $0xc,%esp
80107e57:	68 fd 03 00 00       	push   $0x3fd
80107e5c:	e8 94 fe ff ff       	call   80107cf5 <inb>
80107e61:	83 c4 10             	add    $0x10,%esp
80107e64:	0f b6 c0             	movzbl %al,%eax
80107e67:	83 e0 20             	and    $0x20,%eax
80107e6a:	85 c0                	test   %eax,%eax
80107e6c:	74 cf                	je     80107e3d <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80107e71:	0f b6 c0             	movzbl %al,%eax
80107e74:	83 ec 08             	sub    $0x8,%esp
80107e77:	50                   	push   %eax
80107e78:	68 f8 03 00 00       	push   $0x3f8
80107e7d:	e8 90 fe ff ff       	call   80107d12 <outb>
80107e82:	83 c4 10             	add    $0x10,%esp
80107e85:	eb 01                	jmp    80107e88 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107e87:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107e88:	c9                   	leave  
80107e89:	c3                   	ret    

80107e8a <uartgetc>:

static int
uartgetc(void)
{
80107e8a:	55                   	push   %ebp
80107e8b:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107e8d:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80107e92:	85 c0                	test   %eax,%eax
80107e94:	75 07                	jne    80107e9d <uartgetc+0x13>
    return -1;
80107e96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e9b:	eb 2e                	jmp    80107ecb <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107e9d:	68 fd 03 00 00       	push   $0x3fd
80107ea2:	e8 4e fe ff ff       	call   80107cf5 <inb>
80107ea7:	83 c4 04             	add    $0x4,%esp
80107eaa:	0f b6 c0             	movzbl %al,%eax
80107ead:	83 e0 01             	and    $0x1,%eax
80107eb0:	85 c0                	test   %eax,%eax
80107eb2:	75 07                	jne    80107ebb <uartgetc+0x31>
    return -1;
80107eb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107eb9:	eb 10                	jmp    80107ecb <uartgetc+0x41>
  return inb(COM1+0);
80107ebb:	68 f8 03 00 00       	push   $0x3f8
80107ec0:	e8 30 fe ff ff       	call   80107cf5 <inb>
80107ec5:	83 c4 04             	add    $0x4,%esp
80107ec8:	0f b6 c0             	movzbl %al,%eax
}
80107ecb:	c9                   	leave  
80107ecc:	c3                   	ret    

80107ecd <uartintr>:

void
uartintr(void)
{
80107ecd:	55                   	push   %ebp
80107ece:	89 e5                	mov    %esp,%ebp
80107ed0:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107ed3:	83 ec 0c             	sub    $0xc,%esp
80107ed6:	68 8a 7e 10 80       	push   $0x80107e8a
80107edb:	e8 19 89 ff ff       	call   801007f9 <consoleintr>
80107ee0:	83 c4 10             	add    $0x10,%esp
}
80107ee3:	90                   	nop
80107ee4:	c9                   	leave  
80107ee5:	c3                   	ret    

80107ee6 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107ee6:	6a 00                	push   $0x0
  pushl $0
80107ee8:	6a 00                	push   $0x0
  jmp alltraps
80107eea:	e9 cc f9 ff ff       	jmp    801078bb <alltraps>

80107eef <vector1>:
.globl vector1
vector1:
  pushl $0
80107eef:	6a 00                	push   $0x0
  pushl $1
80107ef1:	6a 01                	push   $0x1
  jmp alltraps
80107ef3:	e9 c3 f9 ff ff       	jmp    801078bb <alltraps>

80107ef8 <vector2>:
.globl vector2
vector2:
  pushl $0
80107ef8:	6a 00                	push   $0x0
  pushl $2
80107efa:	6a 02                	push   $0x2
  jmp alltraps
80107efc:	e9 ba f9 ff ff       	jmp    801078bb <alltraps>

80107f01 <vector3>:
.globl vector3
vector3:
  pushl $0
80107f01:	6a 00                	push   $0x0
  pushl $3
80107f03:	6a 03                	push   $0x3
  jmp alltraps
80107f05:	e9 b1 f9 ff ff       	jmp    801078bb <alltraps>

80107f0a <vector4>:
.globl vector4
vector4:
  pushl $0
80107f0a:	6a 00                	push   $0x0
  pushl $4
80107f0c:	6a 04                	push   $0x4
  jmp alltraps
80107f0e:	e9 a8 f9 ff ff       	jmp    801078bb <alltraps>

80107f13 <vector5>:
.globl vector5
vector5:
  pushl $0
80107f13:	6a 00                	push   $0x0
  pushl $5
80107f15:	6a 05                	push   $0x5
  jmp alltraps
80107f17:	e9 9f f9 ff ff       	jmp    801078bb <alltraps>

80107f1c <vector6>:
.globl vector6
vector6:
  pushl $0
80107f1c:	6a 00                	push   $0x0
  pushl $6
80107f1e:	6a 06                	push   $0x6
  jmp alltraps
80107f20:	e9 96 f9 ff ff       	jmp    801078bb <alltraps>

80107f25 <vector7>:
.globl vector7
vector7:
  pushl $0
80107f25:	6a 00                	push   $0x0
  pushl $7
80107f27:	6a 07                	push   $0x7
  jmp alltraps
80107f29:	e9 8d f9 ff ff       	jmp    801078bb <alltraps>

80107f2e <vector8>:
.globl vector8
vector8:
  pushl $8
80107f2e:	6a 08                	push   $0x8
  jmp alltraps
80107f30:	e9 86 f9 ff ff       	jmp    801078bb <alltraps>

80107f35 <vector9>:
.globl vector9
vector9:
  pushl $0
80107f35:	6a 00                	push   $0x0
  pushl $9
80107f37:	6a 09                	push   $0x9
  jmp alltraps
80107f39:	e9 7d f9 ff ff       	jmp    801078bb <alltraps>

80107f3e <vector10>:
.globl vector10
vector10:
  pushl $10
80107f3e:	6a 0a                	push   $0xa
  jmp alltraps
80107f40:	e9 76 f9 ff ff       	jmp    801078bb <alltraps>

80107f45 <vector11>:
.globl vector11
vector11:
  pushl $11
80107f45:	6a 0b                	push   $0xb
  jmp alltraps
80107f47:	e9 6f f9 ff ff       	jmp    801078bb <alltraps>

80107f4c <vector12>:
.globl vector12
vector12:
  pushl $12
80107f4c:	6a 0c                	push   $0xc
  jmp alltraps
80107f4e:	e9 68 f9 ff ff       	jmp    801078bb <alltraps>

80107f53 <vector13>:
.globl vector13
vector13:
  pushl $13
80107f53:	6a 0d                	push   $0xd
  jmp alltraps
80107f55:	e9 61 f9 ff ff       	jmp    801078bb <alltraps>

80107f5a <vector14>:
.globl vector14
vector14:
  pushl $14
80107f5a:	6a 0e                	push   $0xe
  jmp alltraps
80107f5c:	e9 5a f9 ff ff       	jmp    801078bb <alltraps>

80107f61 <vector15>:
.globl vector15
vector15:
  pushl $0
80107f61:	6a 00                	push   $0x0
  pushl $15
80107f63:	6a 0f                	push   $0xf
  jmp alltraps
80107f65:	e9 51 f9 ff ff       	jmp    801078bb <alltraps>

80107f6a <vector16>:
.globl vector16
vector16:
  pushl $0
80107f6a:	6a 00                	push   $0x0
  pushl $16
80107f6c:	6a 10                	push   $0x10
  jmp alltraps
80107f6e:	e9 48 f9 ff ff       	jmp    801078bb <alltraps>

80107f73 <vector17>:
.globl vector17
vector17:
  pushl $17
80107f73:	6a 11                	push   $0x11
  jmp alltraps
80107f75:	e9 41 f9 ff ff       	jmp    801078bb <alltraps>

80107f7a <vector18>:
.globl vector18
vector18:
  pushl $0
80107f7a:	6a 00                	push   $0x0
  pushl $18
80107f7c:	6a 12                	push   $0x12
  jmp alltraps
80107f7e:	e9 38 f9 ff ff       	jmp    801078bb <alltraps>

80107f83 <vector19>:
.globl vector19
vector19:
  pushl $0
80107f83:	6a 00                	push   $0x0
  pushl $19
80107f85:	6a 13                	push   $0x13
  jmp alltraps
80107f87:	e9 2f f9 ff ff       	jmp    801078bb <alltraps>

80107f8c <vector20>:
.globl vector20
vector20:
  pushl $0
80107f8c:	6a 00                	push   $0x0
  pushl $20
80107f8e:	6a 14                	push   $0x14
  jmp alltraps
80107f90:	e9 26 f9 ff ff       	jmp    801078bb <alltraps>

80107f95 <vector21>:
.globl vector21
vector21:
  pushl $0
80107f95:	6a 00                	push   $0x0
  pushl $21
80107f97:	6a 15                	push   $0x15
  jmp alltraps
80107f99:	e9 1d f9 ff ff       	jmp    801078bb <alltraps>

80107f9e <vector22>:
.globl vector22
vector22:
  pushl $0
80107f9e:	6a 00                	push   $0x0
  pushl $22
80107fa0:	6a 16                	push   $0x16
  jmp alltraps
80107fa2:	e9 14 f9 ff ff       	jmp    801078bb <alltraps>

80107fa7 <vector23>:
.globl vector23
vector23:
  pushl $0
80107fa7:	6a 00                	push   $0x0
  pushl $23
80107fa9:	6a 17                	push   $0x17
  jmp alltraps
80107fab:	e9 0b f9 ff ff       	jmp    801078bb <alltraps>

80107fb0 <vector24>:
.globl vector24
vector24:
  pushl $0
80107fb0:	6a 00                	push   $0x0
  pushl $24
80107fb2:	6a 18                	push   $0x18
  jmp alltraps
80107fb4:	e9 02 f9 ff ff       	jmp    801078bb <alltraps>

80107fb9 <vector25>:
.globl vector25
vector25:
  pushl $0
80107fb9:	6a 00                	push   $0x0
  pushl $25
80107fbb:	6a 19                	push   $0x19
  jmp alltraps
80107fbd:	e9 f9 f8 ff ff       	jmp    801078bb <alltraps>

80107fc2 <vector26>:
.globl vector26
vector26:
  pushl $0
80107fc2:	6a 00                	push   $0x0
  pushl $26
80107fc4:	6a 1a                	push   $0x1a
  jmp alltraps
80107fc6:	e9 f0 f8 ff ff       	jmp    801078bb <alltraps>

80107fcb <vector27>:
.globl vector27
vector27:
  pushl $0
80107fcb:	6a 00                	push   $0x0
  pushl $27
80107fcd:	6a 1b                	push   $0x1b
  jmp alltraps
80107fcf:	e9 e7 f8 ff ff       	jmp    801078bb <alltraps>

80107fd4 <vector28>:
.globl vector28
vector28:
  pushl $0
80107fd4:	6a 00                	push   $0x0
  pushl $28
80107fd6:	6a 1c                	push   $0x1c
  jmp alltraps
80107fd8:	e9 de f8 ff ff       	jmp    801078bb <alltraps>

80107fdd <vector29>:
.globl vector29
vector29:
  pushl $0
80107fdd:	6a 00                	push   $0x0
  pushl $29
80107fdf:	6a 1d                	push   $0x1d
  jmp alltraps
80107fe1:	e9 d5 f8 ff ff       	jmp    801078bb <alltraps>

80107fe6 <vector30>:
.globl vector30
vector30:
  pushl $0
80107fe6:	6a 00                	push   $0x0
  pushl $30
80107fe8:	6a 1e                	push   $0x1e
  jmp alltraps
80107fea:	e9 cc f8 ff ff       	jmp    801078bb <alltraps>

80107fef <vector31>:
.globl vector31
vector31:
  pushl $0
80107fef:	6a 00                	push   $0x0
  pushl $31
80107ff1:	6a 1f                	push   $0x1f
  jmp alltraps
80107ff3:	e9 c3 f8 ff ff       	jmp    801078bb <alltraps>

80107ff8 <vector32>:
.globl vector32
vector32:
  pushl $0
80107ff8:	6a 00                	push   $0x0
  pushl $32
80107ffa:	6a 20                	push   $0x20
  jmp alltraps
80107ffc:	e9 ba f8 ff ff       	jmp    801078bb <alltraps>

80108001 <vector33>:
.globl vector33
vector33:
  pushl $0
80108001:	6a 00                	push   $0x0
  pushl $33
80108003:	6a 21                	push   $0x21
  jmp alltraps
80108005:	e9 b1 f8 ff ff       	jmp    801078bb <alltraps>

8010800a <vector34>:
.globl vector34
vector34:
  pushl $0
8010800a:	6a 00                	push   $0x0
  pushl $34
8010800c:	6a 22                	push   $0x22
  jmp alltraps
8010800e:	e9 a8 f8 ff ff       	jmp    801078bb <alltraps>

80108013 <vector35>:
.globl vector35
vector35:
  pushl $0
80108013:	6a 00                	push   $0x0
  pushl $35
80108015:	6a 23                	push   $0x23
  jmp alltraps
80108017:	e9 9f f8 ff ff       	jmp    801078bb <alltraps>

8010801c <vector36>:
.globl vector36
vector36:
  pushl $0
8010801c:	6a 00                	push   $0x0
  pushl $36
8010801e:	6a 24                	push   $0x24
  jmp alltraps
80108020:	e9 96 f8 ff ff       	jmp    801078bb <alltraps>

80108025 <vector37>:
.globl vector37
vector37:
  pushl $0
80108025:	6a 00                	push   $0x0
  pushl $37
80108027:	6a 25                	push   $0x25
  jmp alltraps
80108029:	e9 8d f8 ff ff       	jmp    801078bb <alltraps>

8010802e <vector38>:
.globl vector38
vector38:
  pushl $0
8010802e:	6a 00                	push   $0x0
  pushl $38
80108030:	6a 26                	push   $0x26
  jmp alltraps
80108032:	e9 84 f8 ff ff       	jmp    801078bb <alltraps>

80108037 <vector39>:
.globl vector39
vector39:
  pushl $0
80108037:	6a 00                	push   $0x0
  pushl $39
80108039:	6a 27                	push   $0x27
  jmp alltraps
8010803b:	e9 7b f8 ff ff       	jmp    801078bb <alltraps>

80108040 <vector40>:
.globl vector40
vector40:
  pushl $0
80108040:	6a 00                	push   $0x0
  pushl $40
80108042:	6a 28                	push   $0x28
  jmp alltraps
80108044:	e9 72 f8 ff ff       	jmp    801078bb <alltraps>

80108049 <vector41>:
.globl vector41
vector41:
  pushl $0
80108049:	6a 00                	push   $0x0
  pushl $41
8010804b:	6a 29                	push   $0x29
  jmp alltraps
8010804d:	e9 69 f8 ff ff       	jmp    801078bb <alltraps>

80108052 <vector42>:
.globl vector42
vector42:
  pushl $0
80108052:	6a 00                	push   $0x0
  pushl $42
80108054:	6a 2a                	push   $0x2a
  jmp alltraps
80108056:	e9 60 f8 ff ff       	jmp    801078bb <alltraps>

8010805b <vector43>:
.globl vector43
vector43:
  pushl $0
8010805b:	6a 00                	push   $0x0
  pushl $43
8010805d:	6a 2b                	push   $0x2b
  jmp alltraps
8010805f:	e9 57 f8 ff ff       	jmp    801078bb <alltraps>

80108064 <vector44>:
.globl vector44
vector44:
  pushl $0
80108064:	6a 00                	push   $0x0
  pushl $44
80108066:	6a 2c                	push   $0x2c
  jmp alltraps
80108068:	e9 4e f8 ff ff       	jmp    801078bb <alltraps>

8010806d <vector45>:
.globl vector45
vector45:
  pushl $0
8010806d:	6a 00                	push   $0x0
  pushl $45
8010806f:	6a 2d                	push   $0x2d
  jmp alltraps
80108071:	e9 45 f8 ff ff       	jmp    801078bb <alltraps>

80108076 <vector46>:
.globl vector46
vector46:
  pushl $0
80108076:	6a 00                	push   $0x0
  pushl $46
80108078:	6a 2e                	push   $0x2e
  jmp alltraps
8010807a:	e9 3c f8 ff ff       	jmp    801078bb <alltraps>

8010807f <vector47>:
.globl vector47
vector47:
  pushl $0
8010807f:	6a 00                	push   $0x0
  pushl $47
80108081:	6a 2f                	push   $0x2f
  jmp alltraps
80108083:	e9 33 f8 ff ff       	jmp    801078bb <alltraps>

80108088 <vector48>:
.globl vector48
vector48:
  pushl $0
80108088:	6a 00                	push   $0x0
  pushl $48
8010808a:	6a 30                	push   $0x30
  jmp alltraps
8010808c:	e9 2a f8 ff ff       	jmp    801078bb <alltraps>

80108091 <vector49>:
.globl vector49
vector49:
  pushl $0
80108091:	6a 00                	push   $0x0
  pushl $49
80108093:	6a 31                	push   $0x31
  jmp alltraps
80108095:	e9 21 f8 ff ff       	jmp    801078bb <alltraps>

8010809a <vector50>:
.globl vector50
vector50:
  pushl $0
8010809a:	6a 00                	push   $0x0
  pushl $50
8010809c:	6a 32                	push   $0x32
  jmp alltraps
8010809e:	e9 18 f8 ff ff       	jmp    801078bb <alltraps>

801080a3 <vector51>:
.globl vector51
vector51:
  pushl $0
801080a3:	6a 00                	push   $0x0
  pushl $51
801080a5:	6a 33                	push   $0x33
  jmp alltraps
801080a7:	e9 0f f8 ff ff       	jmp    801078bb <alltraps>

801080ac <vector52>:
.globl vector52
vector52:
  pushl $0
801080ac:	6a 00                	push   $0x0
  pushl $52
801080ae:	6a 34                	push   $0x34
  jmp alltraps
801080b0:	e9 06 f8 ff ff       	jmp    801078bb <alltraps>

801080b5 <vector53>:
.globl vector53
vector53:
  pushl $0
801080b5:	6a 00                	push   $0x0
  pushl $53
801080b7:	6a 35                	push   $0x35
  jmp alltraps
801080b9:	e9 fd f7 ff ff       	jmp    801078bb <alltraps>

801080be <vector54>:
.globl vector54
vector54:
  pushl $0
801080be:	6a 00                	push   $0x0
  pushl $54
801080c0:	6a 36                	push   $0x36
  jmp alltraps
801080c2:	e9 f4 f7 ff ff       	jmp    801078bb <alltraps>

801080c7 <vector55>:
.globl vector55
vector55:
  pushl $0
801080c7:	6a 00                	push   $0x0
  pushl $55
801080c9:	6a 37                	push   $0x37
  jmp alltraps
801080cb:	e9 eb f7 ff ff       	jmp    801078bb <alltraps>

801080d0 <vector56>:
.globl vector56
vector56:
  pushl $0
801080d0:	6a 00                	push   $0x0
  pushl $56
801080d2:	6a 38                	push   $0x38
  jmp alltraps
801080d4:	e9 e2 f7 ff ff       	jmp    801078bb <alltraps>

801080d9 <vector57>:
.globl vector57
vector57:
  pushl $0
801080d9:	6a 00                	push   $0x0
  pushl $57
801080db:	6a 39                	push   $0x39
  jmp alltraps
801080dd:	e9 d9 f7 ff ff       	jmp    801078bb <alltraps>

801080e2 <vector58>:
.globl vector58
vector58:
  pushl $0
801080e2:	6a 00                	push   $0x0
  pushl $58
801080e4:	6a 3a                	push   $0x3a
  jmp alltraps
801080e6:	e9 d0 f7 ff ff       	jmp    801078bb <alltraps>

801080eb <vector59>:
.globl vector59
vector59:
  pushl $0
801080eb:	6a 00                	push   $0x0
  pushl $59
801080ed:	6a 3b                	push   $0x3b
  jmp alltraps
801080ef:	e9 c7 f7 ff ff       	jmp    801078bb <alltraps>

801080f4 <vector60>:
.globl vector60
vector60:
  pushl $0
801080f4:	6a 00                	push   $0x0
  pushl $60
801080f6:	6a 3c                	push   $0x3c
  jmp alltraps
801080f8:	e9 be f7 ff ff       	jmp    801078bb <alltraps>

801080fd <vector61>:
.globl vector61
vector61:
  pushl $0
801080fd:	6a 00                	push   $0x0
  pushl $61
801080ff:	6a 3d                	push   $0x3d
  jmp alltraps
80108101:	e9 b5 f7 ff ff       	jmp    801078bb <alltraps>

80108106 <vector62>:
.globl vector62
vector62:
  pushl $0
80108106:	6a 00                	push   $0x0
  pushl $62
80108108:	6a 3e                	push   $0x3e
  jmp alltraps
8010810a:	e9 ac f7 ff ff       	jmp    801078bb <alltraps>

8010810f <vector63>:
.globl vector63
vector63:
  pushl $0
8010810f:	6a 00                	push   $0x0
  pushl $63
80108111:	6a 3f                	push   $0x3f
  jmp alltraps
80108113:	e9 a3 f7 ff ff       	jmp    801078bb <alltraps>

80108118 <vector64>:
.globl vector64
vector64:
  pushl $0
80108118:	6a 00                	push   $0x0
  pushl $64
8010811a:	6a 40                	push   $0x40
  jmp alltraps
8010811c:	e9 9a f7 ff ff       	jmp    801078bb <alltraps>

80108121 <vector65>:
.globl vector65
vector65:
  pushl $0
80108121:	6a 00                	push   $0x0
  pushl $65
80108123:	6a 41                	push   $0x41
  jmp alltraps
80108125:	e9 91 f7 ff ff       	jmp    801078bb <alltraps>

8010812a <vector66>:
.globl vector66
vector66:
  pushl $0
8010812a:	6a 00                	push   $0x0
  pushl $66
8010812c:	6a 42                	push   $0x42
  jmp alltraps
8010812e:	e9 88 f7 ff ff       	jmp    801078bb <alltraps>

80108133 <vector67>:
.globl vector67
vector67:
  pushl $0
80108133:	6a 00                	push   $0x0
  pushl $67
80108135:	6a 43                	push   $0x43
  jmp alltraps
80108137:	e9 7f f7 ff ff       	jmp    801078bb <alltraps>

8010813c <vector68>:
.globl vector68
vector68:
  pushl $0
8010813c:	6a 00                	push   $0x0
  pushl $68
8010813e:	6a 44                	push   $0x44
  jmp alltraps
80108140:	e9 76 f7 ff ff       	jmp    801078bb <alltraps>

80108145 <vector69>:
.globl vector69
vector69:
  pushl $0
80108145:	6a 00                	push   $0x0
  pushl $69
80108147:	6a 45                	push   $0x45
  jmp alltraps
80108149:	e9 6d f7 ff ff       	jmp    801078bb <alltraps>

8010814e <vector70>:
.globl vector70
vector70:
  pushl $0
8010814e:	6a 00                	push   $0x0
  pushl $70
80108150:	6a 46                	push   $0x46
  jmp alltraps
80108152:	e9 64 f7 ff ff       	jmp    801078bb <alltraps>

80108157 <vector71>:
.globl vector71
vector71:
  pushl $0
80108157:	6a 00                	push   $0x0
  pushl $71
80108159:	6a 47                	push   $0x47
  jmp alltraps
8010815b:	e9 5b f7 ff ff       	jmp    801078bb <alltraps>

80108160 <vector72>:
.globl vector72
vector72:
  pushl $0
80108160:	6a 00                	push   $0x0
  pushl $72
80108162:	6a 48                	push   $0x48
  jmp alltraps
80108164:	e9 52 f7 ff ff       	jmp    801078bb <alltraps>

80108169 <vector73>:
.globl vector73
vector73:
  pushl $0
80108169:	6a 00                	push   $0x0
  pushl $73
8010816b:	6a 49                	push   $0x49
  jmp alltraps
8010816d:	e9 49 f7 ff ff       	jmp    801078bb <alltraps>

80108172 <vector74>:
.globl vector74
vector74:
  pushl $0
80108172:	6a 00                	push   $0x0
  pushl $74
80108174:	6a 4a                	push   $0x4a
  jmp alltraps
80108176:	e9 40 f7 ff ff       	jmp    801078bb <alltraps>

8010817b <vector75>:
.globl vector75
vector75:
  pushl $0
8010817b:	6a 00                	push   $0x0
  pushl $75
8010817d:	6a 4b                	push   $0x4b
  jmp alltraps
8010817f:	e9 37 f7 ff ff       	jmp    801078bb <alltraps>

80108184 <vector76>:
.globl vector76
vector76:
  pushl $0
80108184:	6a 00                	push   $0x0
  pushl $76
80108186:	6a 4c                	push   $0x4c
  jmp alltraps
80108188:	e9 2e f7 ff ff       	jmp    801078bb <alltraps>

8010818d <vector77>:
.globl vector77
vector77:
  pushl $0
8010818d:	6a 00                	push   $0x0
  pushl $77
8010818f:	6a 4d                	push   $0x4d
  jmp alltraps
80108191:	e9 25 f7 ff ff       	jmp    801078bb <alltraps>

80108196 <vector78>:
.globl vector78
vector78:
  pushl $0
80108196:	6a 00                	push   $0x0
  pushl $78
80108198:	6a 4e                	push   $0x4e
  jmp alltraps
8010819a:	e9 1c f7 ff ff       	jmp    801078bb <alltraps>

8010819f <vector79>:
.globl vector79
vector79:
  pushl $0
8010819f:	6a 00                	push   $0x0
  pushl $79
801081a1:	6a 4f                	push   $0x4f
  jmp alltraps
801081a3:	e9 13 f7 ff ff       	jmp    801078bb <alltraps>

801081a8 <vector80>:
.globl vector80
vector80:
  pushl $0
801081a8:	6a 00                	push   $0x0
  pushl $80
801081aa:	6a 50                	push   $0x50
  jmp alltraps
801081ac:	e9 0a f7 ff ff       	jmp    801078bb <alltraps>

801081b1 <vector81>:
.globl vector81
vector81:
  pushl $0
801081b1:	6a 00                	push   $0x0
  pushl $81
801081b3:	6a 51                	push   $0x51
  jmp alltraps
801081b5:	e9 01 f7 ff ff       	jmp    801078bb <alltraps>

801081ba <vector82>:
.globl vector82
vector82:
  pushl $0
801081ba:	6a 00                	push   $0x0
  pushl $82
801081bc:	6a 52                	push   $0x52
  jmp alltraps
801081be:	e9 f8 f6 ff ff       	jmp    801078bb <alltraps>

801081c3 <vector83>:
.globl vector83
vector83:
  pushl $0
801081c3:	6a 00                	push   $0x0
  pushl $83
801081c5:	6a 53                	push   $0x53
  jmp alltraps
801081c7:	e9 ef f6 ff ff       	jmp    801078bb <alltraps>

801081cc <vector84>:
.globl vector84
vector84:
  pushl $0
801081cc:	6a 00                	push   $0x0
  pushl $84
801081ce:	6a 54                	push   $0x54
  jmp alltraps
801081d0:	e9 e6 f6 ff ff       	jmp    801078bb <alltraps>

801081d5 <vector85>:
.globl vector85
vector85:
  pushl $0
801081d5:	6a 00                	push   $0x0
  pushl $85
801081d7:	6a 55                	push   $0x55
  jmp alltraps
801081d9:	e9 dd f6 ff ff       	jmp    801078bb <alltraps>

801081de <vector86>:
.globl vector86
vector86:
  pushl $0
801081de:	6a 00                	push   $0x0
  pushl $86
801081e0:	6a 56                	push   $0x56
  jmp alltraps
801081e2:	e9 d4 f6 ff ff       	jmp    801078bb <alltraps>

801081e7 <vector87>:
.globl vector87
vector87:
  pushl $0
801081e7:	6a 00                	push   $0x0
  pushl $87
801081e9:	6a 57                	push   $0x57
  jmp alltraps
801081eb:	e9 cb f6 ff ff       	jmp    801078bb <alltraps>

801081f0 <vector88>:
.globl vector88
vector88:
  pushl $0
801081f0:	6a 00                	push   $0x0
  pushl $88
801081f2:	6a 58                	push   $0x58
  jmp alltraps
801081f4:	e9 c2 f6 ff ff       	jmp    801078bb <alltraps>

801081f9 <vector89>:
.globl vector89
vector89:
  pushl $0
801081f9:	6a 00                	push   $0x0
  pushl $89
801081fb:	6a 59                	push   $0x59
  jmp alltraps
801081fd:	e9 b9 f6 ff ff       	jmp    801078bb <alltraps>

80108202 <vector90>:
.globl vector90
vector90:
  pushl $0
80108202:	6a 00                	push   $0x0
  pushl $90
80108204:	6a 5a                	push   $0x5a
  jmp alltraps
80108206:	e9 b0 f6 ff ff       	jmp    801078bb <alltraps>

8010820b <vector91>:
.globl vector91
vector91:
  pushl $0
8010820b:	6a 00                	push   $0x0
  pushl $91
8010820d:	6a 5b                	push   $0x5b
  jmp alltraps
8010820f:	e9 a7 f6 ff ff       	jmp    801078bb <alltraps>

80108214 <vector92>:
.globl vector92
vector92:
  pushl $0
80108214:	6a 00                	push   $0x0
  pushl $92
80108216:	6a 5c                	push   $0x5c
  jmp alltraps
80108218:	e9 9e f6 ff ff       	jmp    801078bb <alltraps>

8010821d <vector93>:
.globl vector93
vector93:
  pushl $0
8010821d:	6a 00                	push   $0x0
  pushl $93
8010821f:	6a 5d                	push   $0x5d
  jmp alltraps
80108221:	e9 95 f6 ff ff       	jmp    801078bb <alltraps>

80108226 <vector94>:
.globl vector94
vector94:
  pushl $0
80108226:	6a 00                	push   $0x0
  pushl $94
80108228:	6a 5e                	push   $0x5e
  jmp alltraps
8010822a:	e9 8c f6 ff ff       	jmp    801078bb <alltraps>

8010822f <vector95>:
.globl vector95
vector95:
  pushl $0
8010822f:	6a 00                	push   $0x0
  pushl $95
80108231:	6a 5f                	push   $0x5f
  jmp alltraps
80108233:	e9 83 f6 ff ff       	jmp    801078bb <alltraps>

80108238 <vector96>:
.globl vector96
vector96:
  pushl $0
80108238:	6a 00                	push   $0x0
  pushl $96
8010823a:	6a 60                	push   $0x60
  jmp alltraps
8010823c:	e9 7a f6 ff ff       	jmp    801078bb <alltraps>

80108241 <vector97>:
.globl vector97
vector97:
  pushl $0
80108241:	6a 00                	push   $0x0
  pushl $97
80108243:	6a 61                	push   $0x61
  jmp alltraps
80108245:	e9 71 f6 ff ff       	jmp    801078bb <alltraps>

8010824a <vector98>:
.globl vector98
vector98:
  pushl $0
8010824a:	6a 00                	push   $0x0
  pushl $98
8010824c:	6a 62                	push   $0x62
  jmp alltraps
8010824e:	e9 68 f6 ff ff       	jmp    801078bb <alltraps>

80108253 <vector99>:
.globl vector99
vector99:
  pushl $0
80108253:	6a 00                	push   $0x0
  pushl $99
80108255:	6a 63                	push   $0x63
  jmp alltraps
80108257:	e9 5f f6 ff ff       	jmp    801078bb <alltraps>

8010825c <vector100>:
.globl vector100
vector100:
  pushl $0
8010825c:	6a 00                	push   $0x0
  pushl $100
8010825e:	6a 64                	push   $0x64
  jmp alltraps
80108260:	e9 56 f6 ff ff       	jmp    801078bb <alltraps>

80108265 <vector101>:
.globl vector101
vector101:
  pushl $0
80108265:	6a 00                	push   $0x0
  pushl $101
80108267:	6a 65                	push   $0x65
  jmp alltraps
80108269:	e9 4d f6 ff ff       	jmp    801078bb <alltraps>

8010826e <vector102>:
.globl vector102
vector102:
  pushl $0
8010826e:	6a 00                	push   $0x0
  pushl $102
80108270:	6a 66                	push   $0x66
  jmp alltraps
80108272:	e9 44 f6 ff ff       	jmp    801078bb <alltraps>

80108277 <vector103>:
.globl vector103
vector103:
  pushl $0
80108277:	6a 00                	push   $0x0
  pushl $103
80108279:	6a 67                	push   $0x67
  jmp alltraps
8010827b:	e9 3b f6 ff ff       	jmp    801078bb <alltraps>

80108280 <vector104>:
.globl vector104
vector104:
  pushl $0
80108280:	6a 00                	push   $0x0
  pushl $104
80108282:	6a 68                	push   $0x68
  jmp alltraps
80108284:	e9 32 f6 ff ff       	jmp    801078bb <alltraps>

80108289 <vector105>:
.globl vector105
vector105:
  pushl $0
80108289:	6a 00                	push   $0x0
  pushl $105
8010828b:	6a 69                	push   $0x69
  jmp alltraps
8010828d:	e9 29 f6 ff ff       	jmp    801078bb <alltraps>

80108292 <vector106>:
.globl vector106
vector106:
  pushl $0
80108292:	6a 00                	push   $0x0
  pushl $106
80108294:	6a 6a                	push   $0x6a
  jmp alltraps
80108296:	e9 20 f6 ff ff       	jmp    801078bb <alltraps>

8010829b <vector107>:
.globl vector107
vector107:
  pushl $0
8010829b:	6a 00                	push   $0x0
  pushl $107
8010829d:	6a 6b                	push   $0x6b
  jmp alltraps
8010829f:	e9 17 f6 ff ff       	jmp    801078bb <alltraps>

801082a4 <vector108>:
.globl vector108
vector108:
  pushl $0
801082a4:	6a 00                	push   $0x0
  pushl $108
801082a6:	6a 6c                	push   $0x6c
  jmp alltraps
801082a8:	e9 0e f6 ff ff       	jmp    801078bb <alltraps>

801082ad <vector109>:
.globl vector109
vector109:
  pushl $0
801082ad:	6a 00                	push   $0x0
  pushl $109
801082af:	6a 6d                	push   $0x6d
  jmp alltraps
801082b1:	e9 05 f6 ff ff       	jmp    801078bb <alltraps>

801082b6 <vector110>:
.globl vector110
vector110:
  pushl $0
801082b6:	6a 00                	push   $0x0
  pushl $110
801082b8:	6a 6e                	push   $0x6e
  jmp alltraps
801082ba:	e9 fc f5 ff ff       	jmp    801078bb <alltraps>

801082bf <vector111>:
.globl vector111
vector111:
  pushl $0
801082bf:	6a 00                	push   $0x0
  pushl $111
801082c1:	6a 6f                	push   $0x6f
  jmp alltraps
801082c3:	e9 f3 f5 ff ff       	jmp    801078bb <alltraps>

801082c8 <vector112>:
.globl vector112
vector112:
  pushl $0
801082c8:	6a 00                	push   $0x0
  pushl $112
801082ca:	6a 70                	push   $0x70
  jmp alltraps
801082cc:	e9 ea f5 ff ff       	jmp    801078bb <alltraps>

801082d1 <vector113>:
.globl vector113
vector113:
  pushl $0
801082d1:	6a 00                	push   $0x0
  pushl $113
801082d3:	6a 71                	push   $0x71
  jmp alltraps
801082d5:	e9 e1 f5 ff ff       	jmp    801078bb <alltraps>

801082da <vector114>:
.globl vector114
vector114:
  pushl $0
801082da:	6a 00                	push   $0x0
  pushl $114
801082dc:	6a 72                	push   $0x72
  jmp alltraps
801082de:	e9 d8 f5 ff ff       	jmp    801078bb <alltraps>

801082e3 <vector115>:
.globl vector115
vector115:
  pushl $0
801082e3:	6a 00                	push   $0x0
  pushl $115
801082e5:	6a 73                	push   $0x73
  jmp alltraps
801082e7:	e9 cf f5 ff ff       	jmp    801078bb <alltraps>

801082ec <vector116>:
.globl vector116
vector116:
  pushl $0
801082ec:	6a 00                	push   $0x0
  pushl $116
801082ee:	6a 74                	push   $0x74
  jmp alltraps
801082f0:	e9 c6 f5 ff ff       	jmp    801078bb <alltraps>

801082f5 <vector117>:
.globl vector117
vector117:
  pushl $0
801082f5:	6a 00                	push   $0x0
  pushl $117
801082f7:	6a 75                	push   $0x75
  jmp alltraps
801082f9:	e9 bd f5 ff ff       	jmp    801078bb <alltraps>

801082fe <vector118>:
.globl vector118
vector118:
  pushl $0
801082fe:	6a 00                	push   $0x0
  pushl $118
80108300:	6a 76                	push   $0x76
  jmp alltraps
80108302:	e9 b4 f5 ff ff       	jmp    801078bb <alltraps>

80108307 <vector119>:
.globl vector119
vector119:
  pushl $0
80108307:	6a 00                	push   $0x0
  pushl $119
80108309:	6a 77                	push   $0x77
  jmp alltraps
8010830b:	e9 ab f5 ff ff       	jmp    801078bb <alltraps>

80108310 <vector120>:
.globl vector120
vector120:
  pushl $0
80108310:	6a 00                	push   $0x0
  pushl $120
80108312:	6a 78                	push   $0x78
  jmp alltraps
80108314:	e9 a2 f5 ff ff       	jmp    801078bb <alltraps>

80108319 <vector121>:
.globl vector121
vector121:
  pushl $0
80108319:	6a 00                	push   $0x0
  pushl $121
8010831b:	6a 79                	push   $0x79
  jmp alltraps
8010831d:	e9 99 f5 ff ff       	jmp    801078bb <alltraps>

80108322 <vector122>:
.globl vector122
vector122:
  pushl $0
80108322:	6a 00                	push   $0x0
  pushl $122
80108324:	6a 7a                	push   $0x7a
  jmp alltraps
80108326:	e9 90 f5 ff ff       	jmp    801078bb <alltraps>

8010832b <vector123>:
.globl vector123
vector123:
  pushl $0
8010832b:	6a 00                	push   $0x0
  pushl $123
8010832d:	6a 7b                	push   $0x7b
  jmp alltraps
8010832f:	e9 87 f5 ff ff       	jmp    801078bb <alltraps>

80108334 <vector124>:
.globl vector124
vector124:
  pushl $0
80108334:	6a 00                	push   $0x0
  pushl $124
80108336:	6a 7c                	push   $0x7c
  jmp alltraps
80108338:	e9 7e f5 ff ff       	jmp    801078bb <alltraps>

8010833d <vector125>:
.globl vector125
vector125:
  pushl $0
8010833d:	6a 00                	push   $0x0
  pushl $125
8010833f:	6a 7d                	push   $0x7d
  jmp alltraps
80108341:	e9 75 f5 ff ff       	jmp    801078bb <alltraps>

80108346 <vector126>:
.globl vector126
vector126:
  pushl $0
80108346:	6a 00                	push   $0x0
  pushl $126
80108348:	6a 7e                	push   $0x7e
  jmp alltraps
8010834a:	e9 6c f5 ff ff       	jmp    801078bb <alltraps>

8010834f <vector127>:
.globl vector127
vector127:
  pushl $0
8010834f:	6a 00                	push   $0x0
  pushl $127
80108351:	6a 7f                	push   $0x7f
  jmp alltraps
80108353:	e9 63 f5 ff ff       	jmp    801078bb <alltraps>

80108358 <vector128>:
.globl vector128
vector128:
  pushl $0
80108358:	6a 00                	push   $0x0
  pushl $128
8010835a:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010835f:	e9 57 f5 ff ff       	jmp    801078bb <alltraps>

80108364 <vector129>:
.globl vector129
vector129:
  pushl $0
80108364:	6a 00                	push   $0x0
  pushl $129
80108366:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010836b:	e9 4b f5 ff ff       	jmp    801078bb <alltraps>

80108370 <vector130>:
.globl vector130
vector130:
  pushl $0
80108370:	6a 00                	push   $0x0
  pushl $130
80108372:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108377:	e9 3f f5 ff ff       	jmp    801078bb <alltraps>

8010837c <vector131>:
.globl vector131
vector131:
  pushl $0
8010837c:	6a 00                	push   $0x0
  pushl $131
8010837e:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108383:	e9 33 f5 ff ff       	jmp    801078bb <alltraps>

80108388 <vector132>:
.globl vector132
vector132:
  pushl $0
80108388:	6a 00                	push   $0x0
  pushl $132
8010838a:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010838f:	e9 27 f5 ff ff       	jmp    801078bb <alltraps>

80108394 <vector133>:
.globl vector133
vector133:
  pushl $0
80108394:	6a 00                	push   $0x0
  pushl $133
80108396:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010839b:	e9 1b f5 ff ff       	jmp    801078bb <alltraps>

801083a0 <vector134>:
.globl vector134
vector134:
  pushl $0
801083a0:	6a 00                	push   $0x0
  pushl $134
801083a2:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801083a7:	e9 0f f5 ff ff       	jmp    801078bb <alltraps>

801083ac <vector135>:
.globl vector135
vector135:
  pushl $0
801083ac:	6a 00                	push   $0x0
  pushl $135
801083ae:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801083b3:	e9 03 f5 ff ff       	jmp    801078bb <alltraps>

801083b8 <vector136>:
.globl vector136
vector136:
  pushl $0
801083b8:	6a 00                	push   $0x0
  pushl $136
801083ba:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801083bf:	e9 f7 f4 ff ff       	jmp    801078bb <alltraps>

801083c4 <vector137>:
.globl vector137
vector137:
  pushl $0
801083c4:	6a 00                	push   $0x0
  pushl $137
801083c6:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801083cb:	e9 eb f4 ff ff       	jmp    801078bb <alltraps>

801083d0 <vector138>:
.globl vector138
vector138:
  pushl $0
801083d0:	6a 00                	push   $0x0
  pushl $138
801083d2:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801083d7:	e9 df f4 ff ff       	jmp    801078bb <alltraps>

801083dc <vector139>:
.globl vector139
vector139:
  pushl $0
801083dc:	6a 00                	push   $0x0
  pushl $139
801083de:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801083e3:	e9 d3 f4 ff ff       	jmp    801078bb <alltraps>

801083e8 <vector140>:
.globl vector140
vector140:
  pushl $0
801083e8:	6a 00                	push   $0x0
  pushl $140
801083ea:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801083ef:	e9 c7 f4 ff ff       	jmp    801078bb <alltraps>

801083f4 <vector141>:
.globl vector141
vector141:
  pushl $0
801083f4:	6a 00                	push   $0x0
  pushl $141
801083f6:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801083fb:	e9 bb f4 ff ff       	jmp    801078bb <alltraps>

80108400 <vector142>:
.globl vector142
vector142:
  pushl $0
80108400:	6a 00                	push   $0x0
  pushl $142
80108402:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108407:	e9 af f4 ff ff       	jmp    801078bb <alltraps>

8010840c <vector143>:
.globl vector143
vector143:
  pushl $0
8010840c:	6a 00                	push   $0x0
  pushl $143
8010840e:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108413:	e9 a3 f4 ff ff       	jmp    801078bb <alltraps>

80108418 <vector144>:
.globl vector144
vector144:
  pushl $0
80108418:	6a 00                	push   $0x0
  pushl $144
8010841a:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010841f:	e9 97 f4 ff ff       	jmp    801078bb <alltraps>

80108424 <vector145>:
.globl vector145
vector145:
  pushl $0
80108424:	6a 00                	push   $0x0
  pushl $145
80108426:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010842b:	e9 8b f4 ff ff       	jmp    801078bb <alltraps>

80108430 <vector146>:
.globl vector146
vector146:
  pushl $0
80108430:	6a 00                	push   $0x0
  pushl $146
80108432:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108437:	e9 7f f4 ff ff       	jmp    801078bb <alltraps>

8010843c <vector147>:
.globl vector147
vector147:
  pushl $0
8010843c:	6a 00                	push   $0x0
  pushl $147
8010843e:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108443:	e9 73 f4 ff ff       	jmp    801078bb <alltraps>

80108448 <vector148>:
.globl vector148
vector148:
  pushl $0
80108448:	6a 00                	push   $0x0
  pushl $148
8010844a:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010844f:	e9 67 f4 ff ff       	jmp    801078bb <alltraps>

80108454 <vector149>:
.globl vector149
vector149:
  pushl $0
80108454:	6a 00                	push   $0x0
  pushl $149
80108456:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010845b:	e9 5b f4 ff ff       	jmp    801078bb <alltraps>

80108460 <vector150>:
.globl vector150
vector150:
  pushl $0
80108460:	6a 00                	push   $0x0
  pushl $150
80108462:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108467:	e9 4f f4 ff ff       	jmp    801078bb <alltraps>

8010846c <vector151>:
.globl vector151
vector151:
  pushl $0
8010846c:	6a 00                	push   $0x0
  pushl $151
8010846e:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108473:	e9 43 f4 ff ff       	jmp    801078bb <alltraps>

80108478 <vector152>:
.globl vector152
vector152:
  pushl $0
80108478:	6a 00                	push   $0x0
  pushl $152
8010847a:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010847f:	e9 37 f4 ff ff       	jmp    801078bb <alltraps>

80108484 <vector153>:
.globl vector153
vector153:
  pushl $0
80108484:	6a 00                	push   $0x0
  pushl $153
80108486:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010848b:	e9 2b f4 ff ff       	jmp    801078bb <alltraps>

80108490 <vector154>:
.globl vector154
vector154:
  pushl $0
80108490:	6a 00                	push   $0x0
  pushl $154
80108492:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108497:	e9 1f f4 ff ff       	jmp    801078bb <alltraps>

8010849c <vector155>:
.globl vector155
vector155:
  pushl $0
8010849c:	6a 00                	push   $0x0
  pushl $155
8010849e:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801084a3:	e9 13 f4 ff ff       	jmp    801078bb <alltraps>

801084a8 <vector156>:
.globl vector156
vector156:
  pushl $0
801084a8:	6a 00                	push   $0x0
  pushl $156
801084aa:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801084af:	e9 07 f4 ff ff       	jmp    801078bb <alltraps>

801084b4 <vector157>:
.globl vector157
vector157:
  pushl $0
801084b4:	6a 00                	push   $0x0
  pushl $157
801084b6:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801084bb:	e9 fb f3 ff ff       	jmp    801078bb <alltraps>

801084c0 <vector158>:
.globl vector158
vector158:
  pushl $0
801084c0:	6a 00                	push   $0x0
  pushl $158
801084c2:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801084c7:	e9 ef f3 ff ff       	jmp    801078bb <alltraps>

801084cc <vector159>:
.globl vector159
vector159:
  pushl $0
801084cc:	6a 00                	push   $0x0
  pushl $159
801084ce:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801084d3:	e9 e3 f3 ff ff       	jmp    801078bb <alltraps>

801084d8 <vector160>:
.globl vector160
vector160:
  pushl $0
801084d8:	6a 00                	push   $0x0
  pushl $160
801084da:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801084df:	e9 d7 f3 ff ff       	jmp    801078bb <alltraps>

801084e4 <vector161>:
.globl vector161
vector161:
  pushl $0
801084e4:	6a 00                	push   $0x0
  pushl $161
801084e6:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801084eb:	e9 cb f3 ff ff       	jmp    801078bb <alltraps>

801084f0 <vector162>:
.globl vector162
vector162:
  pushl $0
801084f0:	6a 00                	push   $0x0
  pushl $162
801084f2:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801084f7:	e9 bf f3 ff ff       	jmp    801078bb <alltraps>

801084fc <vector163>:
.globl vector163
vector163:
  pushl $0
801084fc:	6a 00                	push   $0x0
  pushl $163
801084fe:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108503:	e9 b3 f3 ff ff       	jmp    801078bb <alltraps>

80108508 <vector164>:
.globl vector164
vector164:
  pushl $0
80108508:	6a 00                	push   $0x0
  pushl $164
8010850a:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010850f:	e9 a7 f3 ff ff       	jmp    801078bb <alltraps>

80108514 <vector165>:
.globl vector165
vector165:
  pushl $0
80108514:	6a 00                	push   $0x0
  pushl $165
80108516:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010851b:	e9 9b f3 ff ff       	jmp    801078bb <alltraps>

80108520 <vector166>:
.globl vector166
vector166:
  pushl $0
80108520:	6a 00                	push   $0x0
  pushl $166
80108522:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108527:	e9 8f f3 ff ff       	jmp    801078bb <alltraps>

8010852c <vector167>:
.globl vector167
vector167:
  pushl $0
8010852c:	6a 00                	push   $0x0
  pushl $167
8010852e:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108533:	e9 83 f3 ff ff       	jmp    801078bb <alltraps>

80108538 <vector168>:
.globl vector168
vector168:
  pushl $0
80108538:	6a 00                	push   $0x0
  pushl $168
8010853a:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010853f:	e9 77 f3 ff ff       	jmp    801078bb <alltraps>

80108544 <vector169>:
.globl vector169
vector169:
  pushl $0
80108544:	6a 00                	push   $0x0
  pushl $169
80108546:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010854b:	e9 6b f3 ff ff       	jmp    801078bb <alltraps>

80108550 <vector170>:
.globl vector170
vector170:
  pushl $0
80108550:	6a 00                	push   $0x0
  pushl $170
80108552:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108557:	e9 5f f3 ff ff       	jmp    801078bb <alltraps>

8010855c <vector171>:
.globl vector171
vector171:
  pushl $0
8010855c:	6a 00                	push   $0x0
  pushl $171
8010855e:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108563:	e9 53 f3 ff ff       	jmp    801078bb <alltraps>

80108568 <vector172>:
.globl vector172
vector172:
  pushl $0
80108568:	6a 00                	push   $0x0
  pushl $172
8010856a:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010856f:	e9 47 f3 ff ff       	jmp    801078bb <alltraps>

80108574 <vector173>:
.globl vector173
vector173:
  pushl $0
80108574:	6a 00                	push   $0x0
  pushl $173
80108576:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010857b:	e9 3b f3 ff ff       	jmp    801078bb <alltraps>

80108580 <vector174>:
.globl vector174
vector174:
  pushl $0
80108580:	6a 00                	push   $0x0
  pushl $174
80108582:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108587:	e9 2f f3 ff ff       	jmp    801078bb <alltraps>

8010858c <vector175>:
.globl vector175
vector175:
  pushl $0
8010858c:	6a 00                	push   $0x0
  pushl $175
8010858e:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108593:	e9 23 f3 ff ff       	jmp    801078bb <alltraps>

80108598 <vector176>:
.globl vector176
vector176:
  pushl $0
80108598:	6a 00                	push   $0x0
  pushl $176
8010859a:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010859f:	e9 17 f3 ff ff       	jmp    801078bb <alltraps>

801085a4 <vector177>:
.globl vector177
vector177:
  pushl $0
801085a4:	6a 00                	push   $0x0
  pushl $177
801085a6:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801085ab:	e9 0b f3 ff ff       	jmp    801078bb <alltraps>

801085b0 <vector178>:
.globl vector178
vector178:
  pushl $0
801085b0:	6a 00                	push   $0x0
  pushl $178
801085b2:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801085b7:	e9 ff f2 ff ff       	jmp    801078bb <alltraps>

801085bc <vector179>:
.globl vector179
vector179:
  pushl $0
801085bc:	6a 00                	push   $0x0
  pushl $179
801085be:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801085c3:	e9 f3 f2 ff ff       	jmp    801078bb <alltraps>

801085c8 <vector180>:
.globl vector180
vector180:
  pushl $0
801085c8:	6a 00                	push   $0x0
  pushl $180
801085ca:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801085cf:	e9 e7 f2 ff ff       	jmp    801078bb <alltraps>

801085d4 <vector181>:
.globl vector181
vector181:
  pushl $0
801085d4:	6a 00                	push   $0x0
  pushl $181
801085d6:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801085db:	e9 db f2 ff ff       	jmp    801078bb <alltraps>

801085e0 <vector182>:
.globl vector182
vector182:
  pushl $0
801085e0:	6a 00                	push   $0x0
  pushl $182
801085e2:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801085e7:	e9 cf f2 ff ff       	jmp    801078bb <alltraps>

801085ec <vector183>:
.globl vector183
vector183:
  pushl $0
801085ec:	6a 00                	push   $0x0
  pushl $183
801085ee:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801085f3:	e9 c3 f2 ff ff       	jmp    801078bb <alltraps>

801085f8 <vector184>:
.globl vector184
vector184:
  pushl $0
801085f8:	6a 00                	push   $0x0
  pushl $184
801085fa:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801085ff:	e9 b7 f2 ff ff       	jmp    801078bb <alltraps>

80108604 <vector185>:
.globl vector185
vector185:
  pushl $0
80108604:	6a 00                	push   $0x0
  pushl $185
80108606:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010860b:	e9 ab f2 ff ff       	jmp    801078bb <alltraps>

80108610 <vector186>:
.globl vector186
vector186:
  pushl $0
80108610:	6a 00                	push   $0x0
  pushl $186
80108612:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108617:	e9 9f f2 ff ff       	jmp    801078bb <alltraps>

8010861c <vector187>:
.globl vector187
vector187:
  pushl $0
8010861c:	6a 00                	push   $0x0
  pushl $187
8010861e:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108623:	e9 93 f2 ff ff       	jmp    801078bb <alltraps>

80108628 <vector188>:
.globl vector188
vector188:
  pushl $0
80108628:	6a 00                	push   $0x0
  pushl $188
8010862a:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010862f:	e9 87 f2 ff ff       	jmp    801078bb <alltraps>

80108634 <vector189>:
.globl vector189
vector189:
  pushl $0
80108634:	6a 00                	push   $0x0
  pushl $189
80108636:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010863b:	e9 7b f2 ff ff       	jmp    801078bb <alltraps>

80108640 <vector190>:
.globl vector190
vector190:
  pushl $0
80108640:	6a 00                	push   $0x0
  pushl $190
80108642:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108647:	e9 6f f2 ff ff       	jmp    801078bb <alltraps>

8010864c <vector191>:
.globl vector191
vector191:
  pushl $0
8010864c:	6a 00                	push   $0x0
  pushl $191
8010864e:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108653:	e9 63 f2 ff ff       	jmp    801078bb <alltraps>

80108658 <vector192>:
.globl vector192
vector192:
  pushl $0
80108658:	6a 00                	push   $0x0
  pushl $192
8010865a:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010865f:	e9 57 f2 ff ff       	jmp    801078bb <alltraps>

80108664 <vector193>:
.globl vector193
vector193:
  pushl $0
80108664:	6a 00                	push   $0x0
  pushl $193
80108666:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010866b:	e9 4b f2 ff ff       	jmp    801078bb <alltraps>

80108670 <vector194>:
.globl vector194
vector194:
  pushl $0
80108670:	6a 00                	push   $0x0
  pushl $194
80108672:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108677:	e9 3f f2 ff ff       	jmp    801078bb <alltraps>

8010867c <vector195>:
.globl vector195
vector195:
  pushl $0
8010867c:	6a 00                	push   $0x0
  pushl $195
8010867e:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108683:	e9 33 f2 ff ff       	jmp    801078bb <alltraps>

80108688 <vector196>:
.globl vector196
vector196:
  pushl $0
80108688:	6a 00                	push   $0x0
  pushl $196
8010868a:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010868f:	e9 27 f2 ff ff       	jmp    801078bb <alltraps>

80108694 <vector197>:
.globl vector197
vector197:
  pushl $0
80108694:	6a 00                	push   $0x0
  pushl $197
80108696:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010869b:	e9 1b f2 ff ff       	jmp    801078bb <alltraps>

801086a0 <vector198>:
.globl vector198
vector198:
  pushl $0
801086a0:	6a 00                	push   $0x0
  pushl $198
801086a2:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801086a7:	e9 0f f2 ff ff       	jmp    801078bb <alltraps>

801086ac <vector199>:
.globl vector199
vector199:
  pushl $0
801086ac:	6a 00                	push   $0x0
  pushl $199
801086ae:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801086b3:	e9 03 f2 ff ff       	jmp    801078bb <alltraps>

801086b8 <vector200>:
.globl vector200
vector200:
  pushl $0
801086b8:	6a 00                	push   $0x0
  pushl $200
801086ba:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801086bf:	e9 f7 f1 ff ff       	jmp    801078bb <alltraps>

801086c4 <vector201>:
.globl vector201
vector201:
  pushl $0
801086c4:	6a 00                	push   $0x0
  pushl $201
801086c6:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801086cb:	e9 eb f1 ff ff       	jmp    801078bb <alltraps>

801086d0 <vector202>:
.globl vector202
vector202:
  pushl $0
801086d0:	6a 00                	push   $0x0
  pushl $202
801086d2:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801086d7:	e9 df f1 ff ff       	jmp    801078bb <alltraps>

801086dc <vector203>:
.globl vector203
vector203:
  pushl $0
801086dc:	6a 00                	push   $0x0
  pushl $203
801086de:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801086e3:	e9 d3 f1 ff ff       	jmp    801078bb <alltraps>

801086e8 <vector204>:
.globl vector204
vector204:
  pushl $0
801086e8:	6a 00                	push   $0x0
  pushl $204
801086ea:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801086ef:	e9 c7 f1 ff ff       	jmp    801078bb <alltraps>

801086f4 <vector205>:
.globl vector205
vector205:
  pushl $0
801086f4:	6a 00                	push   $0x0
  pushl $205
801086f6:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801086fb:	e9 bb f1 ff ff       	jmp    801078bb <alltraps>

80108700 <vector206>:
.globl vector206
vector206:
  pushl $0
80108700:	6a 00                	push   $0x0
  pushl $206
80108702:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108707:	e9 af f1 ff ff       	jmp    801078bb <alltraps>

8010870c <vector207>:
.globl vector207
vector207:
  pushl $0
8010870c:	6a 00                	push   $0x0
  pushl $207
8010870e:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108713:	e9 a3 f1 ff ff       	jmp    801078bb <alltraps>

80108718 <vector208>:
.globl vector208
vector208:
  pushl $0
80108718:	6a 00                	push   $0x0
  pushl $208
8010871a:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010871f:	e9 97 f1 ff ff       	jmp    801078bb <alltraps>

80108724 <vector209>:
.globl vector209
vector209:
  pushl $0
80108724:	6a 00                	push   $0x0
  pushl $209
80108726:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010872b:	e9 8b f1 ff ff       	jmp    801078bb <alltraps>

80108730 <vector210>:
.globl vector210
vector210:
  pushl $0
80108730:	6a 00                	push   $0x0
  pushl $210
80108732:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108737:	e9 7f f1 ff ff       	jmp    801078bb <alltraps>

8010873c <vector211>:
.globl vector211
vector211:
  pushl $0
8010873c:	6a 00                	push   $0x0
  pushl $211
8010873e:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108743:	e9 73 f1 ff ff       	jmp    801078bb <alltraps>

80108748 <vector212>:
.globl vector212
vector212:
  pushl $0
80108748:	6a 00                	push   $0x0
  pushl $212
8010874a:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010874f:	e9 67 f1 ff ff       	jmp    801078bb <alltraps>

80108754 <vector213>:
.globl vector213
vector213:
  pushl $0
80108754:	6a 00                	push   $0x0
  pushl $213
80108756:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010875b:	e9 5b f1 ff ff       	jmp    801078bb <alltraps>

80108760 <vector214>:
.globl vector214
vector214:
  pushl $0
80108760:	6a 00                	push   $0x0
  pushl $214
80108762:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108767:	e9 4f f1 ff ff       	jmp    801078bb <alltraps>

8010876c <vector215>:
.globl vector215
vector215:
  pushl $0
8010876c:	6a 00                	push   $0x0
  pushl $215
8010876e:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108773:	e9 43 f1 ff ff       	jmp    801078bb <alltraps>

80108778 <vector216>:
.globl vector216
vector216:
  pushl $0
80108778:	6a 00                	push   $0x0
  pushl $216
8010877a:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010877f:	e9 37 f1 ff ff       	jmp    801078bb <alltraps>

80108784 <vector217>:
.globl vector217
vector217:
  pushl $0
80108784:	6a 00                	push   $0x0
  pushl $217
80108786:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010878b:	e9 2b f1 ff ff       	jmp    801078bb <alltraps>

80108790 <vector218>:
.globl vector218
vector218:
  pushl $0
80108790:	6a 00                	push   $0x0
  pushl $218
80108792:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108797:	e9 1f f1 ff ff       	jmp    801078bb <alltraps>

8010879c <vector219>:
.globl vector219
vector219:
  pushl $0
8010879c:	6a 00                	push   $0x0
  pushl $219
8010879e:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801087a3:	e9 13 f1 ff ff       	jmp    801078bb <alltraps>

801087a8 <vector220>:
.globl vector220
vector220:
  pushl $0
801087a8:	6a 00                	push   $0x0
  pushl $220
801087aa:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801087af:	e9 07 f1 ff ff       	jmp    801078bb <alltraps>

801087b4 <vector221>:
.globl vector221
vector221:
  pushl $0
801087b4:	6a 00                	push   $0x0
  pushl $221
801087b6:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801087bb:	e9 fb f0 ff ff       	jmp    801078bb <alltraps>

801087c0 <vector222>:
.globl vector222
vector222:
  pushl $0
801087c0:	6a 00                	push   $0x0
  pushl $222
801087c2:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801087c7:	e9 ef f0 ff ff       	jmp    801078bb <alltraps>

801087cc <vector223>:
.globl vector223
vector223:
  pushl $0
801087cc:	6a 00                	push   $0x0
  pushl $223
801087ce:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801087d3:	e9 e3 f0 ff ff       	jmp    801078bb <alltraps>

801087d8 <vector224>:
.globl vector224
vector224:
  pushl $0
801087d8:	6a 00                	push   $0x0
  pushl $224
801087da:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801087df:	e9 d7 f0 ff ff       	jmp    801078bb <alltraps>

801087e4 <vector225>:
.globl vector225
vector225:
  pushl $0
801087e4:	6a 00                	push   $0x0
  pushl $225
801087e6:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801087eb:	e9 cb f0 ff ff       	jmp    801078bb <alltraps>

801087f0 <vector226>:
.globl vector226
vector226:
  pushl $0
801087f0:	6a 00                	push   $0x0
  pushl $226
801087f2:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801087f7:	e9 bf f0 ff ff       	jmp    801078bb <alltraps>

801087fc <vector227>:
.globl vector227
vector227:
  pushl $0
801087fc:	6a 00                	push   $0x0
  pushl $227
801087fe:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108803:	e9 b3 f0 ff ff       	jmp    801078bb <alltraps>

80108808 <vector228>:
.globl vector228
vector228:
  pushl $0
80108808:	6a 00                	push   $0x0
  pushl $228
8010880a:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010880f:	e9 a7 f0 ff ff       	jmp    801078bb <alltraps>

80108814 <vector229>:
.globl vector229
vector229:
  pushl $0
80108814:	6a 00                	push   $0x0
  pushl $229
80108816:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010881b:	e9 9b f0 ff ff       	jmp    801078bb <alltraps>

80108820 <vector230>:
.globl vector230
vector230:
  pushl $0
80108820:	6a 00                	push   $0x0
  pushl $230
80108822:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108827:	e9 8f f0 ff ff       	jmp    801078bb <alltraps>

8010882c <vector231>:
.globl vector231
vector231:
  pushl $0
8010882c:	6a 00                	push   $0x0
  pushl $231
8010882e:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108833:	e9 83 f0 ff ff       	jmp    801078bb <alltraps>

80108838 <vector232>:
.globl vector232
vector232:
  pushl $0
80108838:	6a 00                	push   $0x0
  pushl $232
8010883a:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010883f:	e9 77 f0 ff ff       	jmp    801078bb <alltraps>

80108844 <vector233>:
.globl vector233
vector233:
  pushl $0
80108844:	6a 00                	push   $0x0
  pushl $233
80108846:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010884b:	e9 6b f0 ff ff       	jmp    801078bb <alltraps>

80108850 <vector234>:
.globl vector234
vector234:
  pushl $0
80108850:	6a 00                	push   $0x0
  pushl $234
80108852:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108857:	e9 5f f0 ff ff       	jmp    801078bb <alltraps>

8010885c <vector235>:
.globl vector235
vector235:
  pushl $0
8010885c:	6a 00                	push   $0x0
  pushl $235
8010885e:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108863:	e9 53 f0 ff ff       	jmp    801078bb <alltraps>

80108868 <vector236>:
.globl vector236
vector236:
  pushl $0
80108868:	6a 00                	push   $0x0
  pushl $236
8010886a:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010886f:	e9 47 f0 ff ff       	jmp    801078bb <alltraps>

80108874 <vector237>:
.globl vector237
vector237:
  pushl $0
80108874:	6a 00                	push   $0x0
  pushl $237
80108876:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010887b:	e9 3b f0 ff ff       	jmp    801078bb <alltraps>

80108880 <vector238>:
.globl vector238
vector238:
  pushl $0
80108880:	6a 00                	push   $0x0
  pushl $238
80108882:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108887:	e9 2f f0 ff ff       	jmp    801078bb <alltraps>

8010888c <vector239>:
.globl vector239
vector239:
  pushl $0
8010888c:	6a 00                	push   $0x0
  pushl $239
8010888e:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108893:	e9 23 f0 ff ff       	jmp    801078bb <alltraps>

80108898 <vector240>:
.globl vector240
vector240:
  pushl $0
80108898:	6a 00                	push   $0x0
  pushl $240
8010889a:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010889f:	e9 17 f0 ff ff       	jmp    801078bb <alltraps>

801088a4 <vector241>:
.globl vector241
vector241:
  pushl $0
801088a4:	6a 00                	push   $0x0
  pushl $241
801088a6:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801088ab:	e9 0b f0 ff ff       	jmp    801078bb <alltraps>

801088b0 <vector242>:
.globl vector242
vector242:
  pushl $0
801088b0:	6a 00                	push   $0x0
  pushl $242
801088b2:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801088b7:	e9 ff ef ff ff       	jmp    801078bb <alltraps>

801088bc <vector243>:
.globl vector243
vector243:
  pushl $0
801088bc:	6a 00                	push   $0x0
  pushl $243
801088be:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801088c3:	e9 f3 ef ff ff       	jmp    801078bb <alltraps>

801088c8 <vector244>:
.globl vector244
vector244:
  pushl $0
801088c8:	6a 00                	push   $0x0
  pushl $244
801088ca:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801088cf:	e9 e7 ef ff ff       	jmp    801078bb <alltraps>

801088d4 <vector245>:
.globl vector245
vector245:
  pushl $0
801088d4:	6a 00                	push   $0x0
  pushl $245
801088d6:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801088db:	e9 db ef ff ff       	jmp    801078bb <alltraps>

801088e0 <vector246>:
.globl vector246
vector246:
  pushl $0
801088e0:	6a 00                	push   $0x0
  pushl $246
801088e2:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801088e7:	e9 cf ef ff ff       	jmp    801078bb <alltraps>

801088ec <vector247>:
.globl vector247
vector247:
  pushl $0
801088ec:	6a 00                	push   $0x0
  pushl $247
801088ee:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801088f3:	e9 c3 ef ff ff       	jmp    801078bb <alltraps>

801088f8 <vector248>:
.globl vector248
vector248:
  pushl $0
801088f8:	6a 00                	push   $0x0
  pushl $248
801088fa:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801088ff:	e9 b7 ef ff ff       	jmp    801078bb <alltraps>

80108904 <vector249>:
.globl vector249
vector249:
  pushl $0
80108904:	6a 00                	push   $0x0
  pushl $249
80108906:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010890b:	e9 ab ef ff ff       	jmp    801078bb <alltraps>

80108910 <vector250>:
.globl vector250
vector250:
  pushl $0
80108910:	6a 00                	push   $0x0
  pushl $250
80108912:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108917:	e9 9f ef ff ff       	jmp    801078bb <alltraps>

8010891c <vector251>:
.globl vector251
vector251:
  pushl $0
8010891c:	6a 00                	push   $0x0
  pushl $251
8010891e:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108923:	e9 93 ef ff ff       	jmp    801078bb <alltraps>

80108928 <vector252>:
.globl vector252
vector252:
  pushl $0
80108928:	6a 00                	push   $0x0
  pushl $252
8010892a:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010892f:	e9 87 ef ff ff       	jmp    801078bb <alltraps>

80108934 <vector253>:
.globl vector253
vector253:
  pushl $0
80108934:	6a 00                	push   $0x0
  pushl $253
80108936:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010893b:	e9 7b ef ff ff       	jmp    801078bb <alltraps>

80108940 <vector254>:
.globl vector254
vector254:
  pushl $0
80108940:	6a 00                	push   $0x0
  pushl $254
80108942:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108947:	e9 6f ef ff ff       	jmp    801078bb <alltraps>

8010894c <vector255>:
.globl vector255
vector255:
  pushl $0
8010894c:	6a 00                	push   $0x0
  pushl $255
8010894e:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108953:	e9 63 ef ff ff       	jmp    801078bb <alltraps>

80108958 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108958:	55                   	push   %ebp
80108959:	89 e5                	mov    %esp,%ebp
8010895b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010895e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108961:	83 e8 01             	sub    $0x1,%eax
80108964:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108968:	8b 45 08             	mov    0x8(%ebp),%eax
8010896b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010896f:	8b 45 08             	mov    0x8(%ebp),%eax
80108972:	c1 e8 10             	shr    $0x10,%eax
80108975:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108979:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010897c:	0f 01 10             	lgdtl  (%eax)
}
8010897f:	90                   	nop
80108980:	c9                   	leave  
80108981:	c3                   	ret    

80108982 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108982:	55                   	push   %ebp
80108983:	89 e5                	mov    %esp,%ebp
80108985:	83 ec 04             	sub    $0x4,%esp
80108988:	8b 45 08             	mov    0x8(%ebp),%eax
8010898b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010898f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108993:	0f 00 d8             	ltr    %ax
}
80108996:	90                   	nop
80108997:	c9                   	leave  
80108998:	c3                   	ret    

80108999 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108999:	55                   	push   %ebp
8010899a:	89 e5                	mov    %esp,%ebp
8010899c:	83 ec 04             	sub    $0x4,%esp
8010899f:	8b 45 08             	mov    0x8(%ebp),%eax
801089a2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801089a6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801089aa:	8e e8                	mov    %eax,%gs
}
801089ac:	90                   	nop
801089ad:	c9                   	leave  
801089ae:	c3                   	ret    

801089af <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801089af:	55                   	push   %ebp
801089b0:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801089b2:	8b 45 08             	mov    0x8(%ebp),%eax
801089b5:	0f 22 d8             	mov    %eax,%cr3
}
801089b8:	90                   	nop
801089b9:	5d                   	pop    %ebp
801089ba:	c3                   	ret    

801089bb <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801089bb:	55                   	push   %ebp
801089bc:	89 e5                	mov    %esp,%ebp
801089be:	8b 45 08             	mov    0x8(%ebp),%eax
801089c1:	05 00 00 00 80       	add    $0x80000000,%eax
801089c6:	5d                   	pop    %ebp
801089c7:	c3                   	ret    

801089c8 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801089c8:	55                   	push   %ebp
801089c9:	89 e5                	mov    %esp,%ebp
801089cb:	8b 45 08             	mov    0x8(%ebp),%eax
801089ce:	05 00 00 00 80       	add    $0x80000000,%eax
801089d3:	5d                   	pop    %ebp
801089d4:	c3                   	ret    

801089d5 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801089d5:	55                   	push   %ebp
801089d6:	89 e5                	mov    %esp,%ebp
801089d8:	53                   	push   %ebx
801089d9:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801089dc:	e8 a5 a7 ff ff       	call   80103186 <cpunum>
801089e1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801089e7:	05 80 43 11 80       	add    $0x80114380,%eax
801089ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801089ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f2:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801089f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089fb:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a04:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a0b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108a0f:	83 e2 f0             	and    $0xfffffff0,%edx
80108a12:	83 ca 0a             	or     $0xa,%edx
80108a15:	88 50 7d             	mov    %dl,0x7d(%eax)
80108a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a1b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108a1f:	83 ca 10             	or     $0x10,%edx
80108a22:	88 50 7d             	mov    %dl,0x7d(%eax)
80108a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a28:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108a2c:	83 e2 9f             	and    $0xffffff9f,%edx
80108a2f:	88 50 7d             	mov    %dl,0x7d(%eax)
80108a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a35:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108a39:	83 ca 80             	or     $0xffffff80,%edx
80108a3c:	88 50 7d             	mov    %dl,0x7d(%eax)
80108a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a42:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108a46:	83 ca 0f             	or     $0xf,%edx
80108a49:	88 50 7e             	mov    %dl,0x7e(%eax)
80108a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a4f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108a53:	83 e2 ef             	and    $0xffffffef,%edx
80108a56:	88 50 7e             	mov    %dl,0x7e(%eax)
80108a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a5c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108a60:	83 e2 df             	and    $0xffffffdf,%edx
80108a63:	88 50 7e             	mov    %dl,0x7e(%eax)
80108a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a69:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108a6d:	83 ca 40             	or     $0x40,%edx
80108a70:	88 50 7e             	mov    %dl,0x7e(%eax)
80108a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a76:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108a7a:	83 ca 80             	or     $0xffffff80,%edx
80108a7d:	88 50 7e             	mov    %dl,0x7e(%eax)
80108a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a83:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a8a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108a91:	ff ff 
80108a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a96:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108a9d:	00 00 
80108a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aa2:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aac:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108ab3:	83 e2 f0             	and    $0xfffffff0,%edx
80108ab6:	83 ca 02             	or     $0x2,%edx
80108ab9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108ac9:	83 ca 10             	or     $0x10,%edx
80108acc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108adc:	83 e2 9f             	and    $0xffffff9f,%edx
80108adf:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ae8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108aef:	83 ca 80             	or     $0xffffff80,%edx
80108af2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108afb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108b02:	83 ca 0f             	or     $0xf,%edx
80108b05:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b0e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108b15:	83 e2 ef             	and    $0xffffffef,%edx
80108b18:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b21:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108b28:	83 e2 df             	and    $0xffffffdf,%edx
80108b2b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b34:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108b3b:	83 ca 40             	or     $0x40,%edx
80108b3e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b47:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108b4e:	83 ca 80             	or     $0xffffff80,%edx
80108b51:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b64:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108b6b:	ff ff 
80108b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b70:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108b77:	00 00 
80108b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b7c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b86:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108b8d:	83 e2 f0             	and    $0xfffffff0,%edx
80108b90:	83 ca 0a             	or     $0xa,%edx
80108b93:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b9c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108ba3:	83 ca 10             	or     $0x10,%edx
80108ba6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108baf:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108bb6:	83 ca 60             	or     $0x60,%edx
80108bb9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108bc9:	83 ca 80             	or     $0xffffff80,%edx
80108bcc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bd5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108bdc:	83 ca 0f             	or     $0xf,%edx
80108bdf:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108bef:	83 e2 ef             	and    $0xffffffef,%edx
80108bf2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bfb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108c02:	83 e2 df             	and    $0xffffffdf,%edx
80108c05:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c0e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108c15:	83 ca 40             	or     $0x40,%edx
80108c18:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c21:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108c28:	83 ca 80             	or     $0xffffff80,%edx
80108c2b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c34:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c3e:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108c45:	ff ff 
80108c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c4a:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108c51:	00 00 
80108c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c56:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c60:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108c67:	83 e2 f0             	and    $0xfffffff0,%edx
80108c6a:	83 ca 02             	or     $0x2,%edx
80108c6d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c76:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108c7d:	83 ca 10             	or     $0x10,%edx
80108c80:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c89:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108c90:	83 ca 60             	or     $0x60,%edx
80108c93:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ca3:	83 ca 80             	or     $0xffffff80,%edx
80108ca6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108caf:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108cb6:	83 ca 0f             	or     $0xf,%edx
80108cb9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108cc9:	83 e2 ef             	and    $0xffffffef,%edx
80108ccc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108cdc:	83 e2 df             	and    $0xffffffdf,%edx
80108cdf:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108cef:	83 ca 40             	or     $0x40,%edx
80108cf2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cfb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108d02:	83 ca 80             	or     $0xffffff80,%edx
80108d05:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d0e:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d18:	05 b4 00 00 00       	add    $0xb4,%eax
80108d1d:	89 c3                	mov    %eax,%ebx
80108d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d22:	05 b4 00 00 00       	add    $0xb4,%eax
80108d27:	c1 e8 10             	shr    $0x10,%eax
80108d2a:	89 c2                	mov    %eax,%edx
80108d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d2f:	05 b4 00 00 00       	add    $0xb4,%eax
80108d34:	c1 e8 18             	shr    $0x18,%eax
80108d37:	89 c1                	mov    %eax,%ecx
80108d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d3c:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108d43:	00 00 
80108d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d48:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d52:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d5b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108d62:	83 e2 f0             	and    $0xfffffff0,%edx
80108d65:	83 ca 02             	or     $0x2,%edx
80108d68:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d71:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108d78:	83 ca 10             	or     $0x10,%edx
80108d7b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d84:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108d8b:	83 e2 9f             	and    $0xffffff9f,%edx
80108d8e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d97:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108d9e:	83 ca 80             	or     $0xffffff80,%edx
80108da1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108daa:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108db1:	83 e2 f0             	and    $0xfffffff0,%edx
80108db4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dbd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108dc4:	83 e2 ef             	and    $0xffffffef,%edx
80108dc7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dd0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108dd7:	83 e2 df             	and    $0xffffffdf,%edx
80108dda:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108dea:	83 ca 40             	or     $0x40,%edx
80108ded:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108dfd:	83 ca 80             	or     $0xffffff80,%edx
80108e00:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e09:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e12:	83 c0 70             	add    $0x70,%eax
80108e15:	83 ec 08             	sub    $0x8,%esp
80108e18:	6a 38                	push   $0x38
80108e1a:	50                   	push   %eax
80108e1b:	e8 38 fb ff ff       	call   80108958 <lgdt>
80108e20:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108e23:	83 ec 0c             	sub    $0xc,%esp
80108e26:	6a 18                	push   $0x18
80108e28:	e8 6c fb ff ff       	call   80108999 <loadgs>
80108e2d:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e33:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108e39:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108e40:	00 00 00 00 
}
80108e44:	90                   	nop
80108e45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108e48:	c9                   	leave  
80108e49:	c3                   	ret    

80108e4a <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108e4a:	55                   	push   %ebp
80108e4b:	89 e5                	mov    %esp,%ebp
80108e4d:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108e50:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e53:	c1 e8 16             	shr    $0x16,%eax
80108e56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108e5d:	8b 45 08             	mov    0x8(%ebp),%eax
80108e60:	01 d0                	add    %edx,%eax
80108e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e68:	8b 00                	mov    (%eax),%eax
80108e6a:	83 e0 01             	and    $0x1,%eax
80108e6d:	85 c0                	test   %eax,%eax
80108e6f:	74 18                	je     80108e89 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e74:	8b 00                	mov    (%eax),%eax
80108e76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108e7b:	50                   	push   %eax
80108e7c:	e8 47 fb ff ff       	call   801089c8 <p2v>
80108e81:	83 c4 04             	add    $0x4,%esp
80108e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108e87:	eb 48                	jmp    80108ed1 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108e8d:	74 0e                	je     80108e9d <walkpgdir+0x53>
80108e8f:	e8 8c 9f ff ff       	call   80102e20 <kalloc>
80108e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108e97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108e9b:	75 07                	jne    80108ea4 <walkpgdir+0x5a>
      return 0;
80108e9d:	b8 00 00 00 00       	mov    $0x0,%eax
80108ea2:	eb 44                	jmp    80108ee8 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108ea4:	83 ec 04             	sub    $0x4,%esp
80108ea7:	68 00 10 00 00       	push   $0x1000
80108eac:	6a 00                	push   $0x0
80108eae:	ff 75 f4             	pushl  -0xc(%ebp)
80108eb1:	e8 01 d2 ff ff       	call   801060b7 <memset>
80108eb6:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108eb9:	83 ec 0c             	sub    $0xc,%esp
80108ebc:	ff 75 f4             	pushl  -0xc(%ebp)
80108ebf:	e8 f7 fa ff ff       	call   801089bb <v2p>
80108ec4:	83 c4 10             	add    $0x10,%esp
80108ec7:	83 c8 07             	or     $0x7,%eax
80108eca:	89 c2                	mov    %eax,%edx
80108ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ecf:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ed4:	c1 e8 0c             	shr    $0xc,%eax
80108ed7:	25 ff 03 00 00       	and    $0x3ff,%eax
80108edc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ee6:	01 d0                	add    %edx,%eax
}
80108ee8:	c9                   	leave  
80108ee9:	c3                   	ret    

80108eea <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108eea:	55                   	push   %ebp
80108eeb:	89 e5                	mov    %esp,%ebp
80108eed:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ef3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ef8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108efb:	8b 55 0c             	mov    0xc(%ebp),%edx
80108efe:	8b 45 10             	mov    0x10(%ebp),%eax
80108f01:	01 d0                	add    %edx,%eax
80108f03:	83 e8 01             	sub    $0x1,%eax
80108f06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108f0e:	83 ec 04             	sub    $0x4,%esp
80108f11:	6a 01                	push   $0x1
80108f13:	ff 75 f4             	pushl  -0xc(%ebp)
80108f16:	ff 75 08             	pushl  0x8(%ebp)
80108f19:	e8 2c ff ff ff       	call   80108e4a <walkpgdir>
80108f1e:	83 c4 10             	add    $0x10,%esp
80108f21:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108f24:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108f28:	75 07                	jne    80108f31 <mappages+0x47>
      return -1;
80108f2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f2f:	eb 47                	jmp    80108f78 <mappages+0x8e>
    if(*pte & PTE_P)
80108f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f34:	8b 00                	mov    (%eax),%eax
80108f36:	83 e0 01             	and    $0x1,%eax
80108f39:	85 c0                	test   %eax,%eax
80108f3b:	74 0d                	je     80108f4a <mappages+0x60>
      panic("remap");
80108f3d:	83 ec 0c             	sub    $0xc,%esp
80108f40:	68 fc 9f 10 80       	push   $0x80109ffc
80108f45:	e8 1c 76 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80108f4a:	8b 45 18             	mov    0x18(%ebp),%eax
80108f4d:	0b 45 14             	or     0x14(%ebp),%eax
80108f50:	83 c8 01             	or     $0x1,%eax
80108f53:	89 c2                	mov    %eax,%edx
80108f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f58:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108f60:	74 10                	je     80108f72 <mappages+0x88>
      break;
    a += PGSIZE;
80108f62:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108f69:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108f70:	eb 9c                	jmp    80108f0e <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108f72:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108f78:	c9                   	leave  
80108f79:	c3                   	ret    

80108f7a <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108f7a:	55                   	push   %ebp
80108f7b:	89 e5                	mov    %esp,%ebp
80108f7d:	53                   	push   %ebx
80108f7e:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108f81:	e8 9a 9e ff ff       	call   80102e20 <kalloc>
80108f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108f89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108f8d:	75 0a                	jne    80108f99 <setupkvm+0x1f>
    return 0;
80108f8f:	b8 00 00 00 00       	mov    $0x0,%eax
80108f94:	e9 8e 00 00 00       	jmp    80109027 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108f99:	83 ec 04             	sub    $0x4,%esp
80108f9c:	68 00 10 00 00       	push   $0x1000
80108fa1:	6a 00                	push   $0x0
80108fa3:	ff 75 f0             	pushl  -0x10(%ebp)
80108fa6:	e8 0c d1 ff ff       	call   801060b7 <memset>
80108fab:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108fae:	83 ec 0c             	sub    $0xc,%esp
80108fb1:	68 00 00 00 0e       	push   $0xe000000
80108fb6:	e8 0d fa ff ff       	call   801089c8 <p2v>
80108fbb:	83 c4 10             	add    $0x10,%esp
80108fbe:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108fc3:	76 0d                	jbe    80108fd2 <setupkvm+0x58>
    panic("PHYSTOP too high");
80108fc5:	83 ec 0c             	sub    $0xc,%esp
80108fc8:	68 02 a0 10 80       	push   $0x8010a002
80108fcd:	e8 94 75 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108fd2:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
80108fd9:	eb 40                	jmp    8010901b <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fde:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fe4:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fea:	8b 58 08             	mov    0x8(%eax),%ebx
80108fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ff0:	8b 40 04             	mov    0x4(%eax),%eax
80108ff3:	29 c3                	sub    %eax,%ebx
80108ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ff8:	8b 00                	mov    (%eax),%eax
80108ffa:	83 ec 0c             	sub    $0xc,%esp
80108ffd:	51                   	push   %ecx
80108ffe:	52                   	push   %edx
80108fff:	53                   	push   %ebx
80109000:	50                   	push   %eax
80109001:	ff 75 f0             	pushl  -0x10(%ebp)
80109004:	e8 e1 fe ff ff       	call   80108eea <mappages>
80109009:	83 c4 20             	add    $0x20,%esp
8010900c:	85 c0                	test   %eax,%eax
8010900e:	79 07                	jns    80109017 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109010:	b8 00 00 00 00       	mov    $0x0,%eax
80109015:	eb 10                	jmp    80109027 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109017:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010901b:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
80109022:	72 b7                	jb     80108fdb <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109024:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109027:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010902a:	c9                   	leave  
8010902b:	c3                   	ret    

8010902c <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010902c:	55                   	push   %ebp
8010902d:	89 e5                	mov    %esp,%ebp
8010902f:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109032:	e8 43 ff ff ff       	call   80108f7a <setupkvm>
80109037:	a3 38 79 11 80       	mov    %eax,0x80117938
  switchkvm();
8010903c:	e8 03 00 00 00       	call   80109044 <switchkvm>
}
80109041:	90                   	nop
80109042:	c9                   	leave  
80109043:	c3                   	ret    

80109044 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109044:	55                   	push   %ebp
80109045:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109047:	a1 38 79 11 80       	mov    0x80117938,%eax
8010904c:	50                   	push   %eax
8010904d:	e8 69 f9 ff ff       	call   801089bb <v2p>
80109052:	83 c4 04             	add    $0x4,%esp
80109055:	50                   	push   %eax
80109056:	e8 54 f9 ff ff       	call   801089af <lcr3>
8010905b:	83 c4 04             	add    $0x4,%esp
}
8010905e:	90                   	nop
8010905f:	c9                   	leave  
80109060:	c3                   	ret    

80109061 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109061:	55                   	push   %ebp
80109062:	89 e5                	mov    %esp,%ebp
80109064:	56                   	push   %esi
80109065:	53                   	push   %ebx
  pushcli();
80109066:	e8 46 cf ff ff       	call   80105fb1 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010906b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109071:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109078:	83 c2 08             	add    $0x8,%edx
8010907b:	89 d6                	mov    %edx,%esi
8010907d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109084:	83 c2 08             	add    $0x8,%edx
80109087:	c1 ea 10             	shr    $0x10,%edx
8010908a:	89 d3                	mov    %edx,%ebx
8010908c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109093:	83 c2 08             	add    $0x8,%edx
80109096:	c1 ea 18             	shr    $0x18,%edx
80109099:	89 d1                	mov    %edx,%ecx
8010909b:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801090a2:	67 00 
801090a4:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801090ab:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801090b1:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801090b8:	83 e2 f0             	and    $0xfffffff0,%edx
801090bb:	83 ca 09             	or     $0x9,%edx
801090be:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801090c4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801090cb:	83 ca 10             	or     $0x10,%edx
801090ce:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801090d4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801090db:	83 e2 9f             	and    $0xffffff9f,%edx
801090de:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801090e4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801090eb:	83 ca 80             	or     $0xffffff80,%edx
801090ee:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801090f4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801090fb:	83 e2 f0             	and    $0xfffffff0,%edx
801090fe:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109104:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010910b:	83 e2 ef             	and    $0xffffffef,%edx
8010910e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109114:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010911b:	83 e2 df             	and    $0xffffffdf,%edx
8010911e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109124:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010912b:	83 ca 40             	or     $0x40,%edx
8010912e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109134:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010913b:	83 e2 7f             	and    $0x7f,%edx
8010913e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109144:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010914a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109150:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109157:	83 e2 ef             	and    $0xffffffef,%edx
8010915a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109160:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109166:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010916c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109172:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109179:	8b 52 08             	mov    0x8(%edx),%edx
8010917c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109182:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109185:	83 ec 0c             	sub    $0xc,%esp
80109188:	6a 30                	push   $0x30
8010918a:	e8 f3 f7 ff ff       	call   80108982 <ltr>
8010918f:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109192:	8b 45 08             	mov    0x8(%ebp),%eax
80109195:	8b 40 04             	mov    0x4(%eax),%eax
80109198:	85 c0                	test   %eax,%eax
8010919a:	75 0d                	jne    801091a9 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010919c:	83 ec 0c             	sub    $0xc,%esp
8010919f:	68 13 a0 10 80       	push   $0x8010a013
801091a4:	e8 bd 73 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801091a9:	8b 45 08             	mov    0x8(%ebp),%eax
801091ac:	8b 40 04             	mov    0x4(%eax),%eax
801091af:	83 ec 0c             	sub    $0xc,%esp
801091b2:	50                   	push   %eax
801091b3:	e8 03 f8 ff ff       	call   801089bb <v2p>
801091b8:	83 c4 10             	add    $0x10,%esp
801091bb:	83 ec 0c             	sub    $0xc,%esp
801091be:	50                   	push   %eax
801091bf:	e8 eb f7 ff ff       	call   801089af <lcr3>
801091c4:	83 c4 10             	add    $0x10,%esp
  popcli();
801091c7:	e8 2a ce ff ff       	call   80105ff6 <popcli>
}
801091cc:	90                   	nop
801091cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801091d0:	5b                   	pop    %ebx
801091d1:	5e                   	pop    %esi
801091d2:	5d                   	pop    %ebp
801091d3:	c3                   	ret    

801091d4 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801091d4:	55                   	push   %ebp
801091d5:	89 e5                	mov    %esp,%ebp
801091d7:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801091da:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801091e1:	76 0d                	jbe    801091f0 <inituvm+0x1c>
    panic("inituvm: more than a page");
801091e3:	83 ec 0c             	sub    $0xc,%esp
801091e6:	68 27 a0 10 80       	push   $0x8010a027
801091eb:	e8 76 73 ff ff       	call   80100566 <panic>
  mem = kalloc();
801091f0:	e8 2b 9c ff ff       	call   80102e20 <kalloc>
801091f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801091f8:	83 ec 04             	sub    $0x4,%esp
801091fb:	68 00 10 00 00       	push   $0x1000
80109200:	6a 00                	push   $0x0
80109202:	ff 75 f4             	pushl  -0xc(%ebp)
80109205:	e8 ad ce ff ff       	call   801060b7 <memset>
8010920a:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010920d:	83 ec 0c             	sub    $0xc,%esp
80109210:	ff 75 f4             	pushl  -0xc(%ebp)
80109213:	e8 a3 f7 ff ff       	call   801089bb <v2p>
80109218:	83 c4 10             	add    $0x10,%esp
8010921b:	83 ec 0c             	sub    $0xc,%esp
8010921e:	6a 06                	push   $0x6
80109220:	50                   	push   %eax
80109221:	68 00 10 00 00       	push   $0x1000
80109226:	6a 00                	push   $0x0
80109228:	ff 75 08             	pushl  0x8(%ebp)
8010922b:	e8 ba fc ff ff       	call   80108eea <mappages>
80109230:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109233:	83 ec 04             	sub    $0x4,%esp
80109236:	ff 75 10             	pushl  0x10(%ebp)
80109239:	ff 75 0c             	pushl  0xc(%ebp)
8010923c:	ff 75 f4             	pushl  -0xc(%ebp)
8010923f:	e8 32 cf ff ff       	call   80106176 <memmove>
80109244:	83 c4 10             	add    $0x10,%esp
}
80109247:	90                   	nop
80109248:	c9                   	leave  
80109249:	c3                   	ret    

8010924a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010924a:	55                   	push   %ebp
8010924b:	89 e5                	mov    %esp,%ebp
8010924d:	53                   	push   %ebx
8010924e:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109251:	8b 45 0c             	mov    0xc(%ebp),%eax
80109254:	25 ff 0f 00 00       	and    $0xfff,%eax
80109259:	85 c0                	test   %eax,%eax
8010925b:	74 0d                	je     8010926a <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010925d:	83 ec 0c             	sub    $0xc,%esp
80109260:	68 44 a0 10 80       	push   $0x8010a044
80109265:	e8 fc 72 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010926a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109271:	e9 95 00 00 00       	jmp    8010930b <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109276:	8b 55 0c             	mov    0xc(%ebp),%edx
80109279:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010927c:	01 d0                	add    %edx,%eax
8010927e:	83 ec 04             	sub    $0x4,%esp
80109281:	6a 00                	push   $0x0
80109283:	50                   	push   %eax
80109284:	ff 75 08             	pushl  0x8(%ebp)
80109287:	e8 be fb ff ff       	call   80108e4a <walkpgdir>
8010928c:	83 c4 10             	add    $0x10,%esp
8010928f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109292:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109296:	75 0d                	jne    801092a5 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109298:	83 ec 0c             	sub    $0xc,%esp
8010929b:	68 67 a0 10 80       	push   $0x8010a067
801092a0:	e8 c1 72 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801092a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092a8:	8b 00                	mov    (%eax),%eax
801092aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801092af:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801092b2:	8b 45 18             	mov    0x18(%ebp),%eax
801092b5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801092b8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801092bd:	77 0b                	ja     801092ca <loaduvm+0x80>
      n = sz - i;
801092bf:	8b 45 18             	mov    0x18(%ebp),%eax
801092c2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801092c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801092c8:	eb 07                	jmp    801092d1 <loaduvm+0x87>
    else
      n = PGSIZE;
801092ca:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801092d1:	8b 55 14             	mov    0x14(%ebp),%edx
801092d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092d7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801092da:	83 ec 0c             	sub    $0xc,%esp
801092dd:	ff 75 e8             	pushl  -0x18(%ebp)
801092e0:	e8 e3 f6 ff ff       	call   801089c8 <p2v>
801092e5:	83 c4 10             	add    $0x10,%esp
801092e8:	ff 75 f0             	pushl  -0x10(%ebp)
801092eb:	53                   	push   %ebx
801092ec:	50                   	push   %eax
801092ed:	ff 75 10             	pushl  0x10(%ebp)
801092f0:	e8 9d 8d ff ff       	call   80102092 <readi>
801092f5:	83 c4 10             	add    $0x10,%esp
801092f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801092fb:	74 07                	je     80109304 <loaduvm+0xba>
      return -1;
801092fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109302:	eb 18                	jmp    8010931c <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109304:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010930b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010930e:	3b 45 18             	cmp    0x18(%ebp),%eax
80109311:	0f 82 5f ff ff ff    	jb     80109276 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109317:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010931c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010931f:	c9                   	leave  
80109320:	c3                   	ret    

80109321 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109321:	55                   	push   %ebp
80109322:	89 e5                	mov    %esp,%ebp
80109324:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109327:	8b 45 10             	mov    0x10(%ebp),%eax
8010932a:	85 c0                	test   %eax,%eax
8010932c:	79 0a                	jns    80109338 <allocuvm+0x17>
    return 0;
8010932e:	b8 00 00 00 00       	mov    $0x0,%eax
80109333:	e9 b0 00 00 00       	jmp    801093e8 <allocuvm+0xc7>
  if(newsz < oldsz)
80109338:	8b 45 10             	mov    0x10(%ebp),%eax
8010933b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010933e:	73 08                	jae    80109348 <allocuvm+0x27>
    return oldsz;
80109340:	8b 45 0c             	mov    0xc(%ebp),%eax
80109343:	e9 a0 00 00 00       	jmp    801093e8 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109348:	8b 45 0c             	mov    0xc(%ebp),%eax
8010934b:	05 ff 0f 00 00       	add    $0xfff,%eax
80109350:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109355:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109358:	eb 7f                	jmp    801093d9 <allocuvm+0xb8>
    mem = kalloc();
8010935a:	e8 c1 9a ff ff       	call   80102e20 <kalloc>
8010935f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109362:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109366:	75 2b                	jne    80109393 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109368:	83 ec 0c             	sub    $0xc,%esp
8010936b:	68 85 a0 10 80       	push   $0x8010a085
80109370:	e8 51 70 ff ff       	call   801003c6 <cprintf>
80109375:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109378:	83 ec 04             	sub    $0x4,%esp
8010937b:	ff 75 0c             	pushl  0xc(%ebp)
8010937e:	ff 75 10             	pushl  0x10(%ebp)
80109381:	ff 75 08             	pushl  0x8(%ebp)
80109384:	e8 61 00 00 00       	call   801093ea <deallocuvm>
80109389:	83 c4 10             	add    $0x10,%esp
      return 0;
8010938c:	b8 00 00 00 00       	mov    $0x0,%eax
80109391:	eb 55                	jmp    801093e8 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109393:	83 ec 04             	sub    $0x4,%esp
80109396:	68 00 10 00 00       	push   $0x1000
8010939b:	6a 00                	push   $0x0
8010939d:	ff 75 f0             	pushl  -0x10(%ebp)
801093a0:	e8 12 cd ff ff       	call   801060b7 <memset>
801093a5:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801093a8:	83 ec 0c             	sub    $0xc,%esp
801093ab:	ff 75 f0             	pushl  -0x10(%ebp)
801093ae:	e8 08 f6 ff ff       	call   801089bb <v2p>
801093b3:	83 c4 10             	add    $0x10,%esp
801093b6:	89 c2                	mov    %eax,%edx
801093b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093bb:	83 ec 0c             	sub    $0xc,%esp
801093be:	6a 06                	push   $0x6
801093c0:	52                   	push   %edx
801093c1:	68 00 10 00 00       	push   $0x1000
801093c6:	50                   	push   %eax
801093c7:	ff 75 08             	pushl  0x8(%ebp)
801093ca:	e8 1b fb ff ff       	call   80108eea <mappages>
801093cf:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801093d2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801093d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093dc:	3b 45 10             	cmp    0x10(%ebp),%eax
801093df:	0f 82 75 ff ff ff    	jb     8010935a <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801093e5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801093e8:	c9                   	leave  
801093e9:	c3                   	ret    

801093ea <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801093ea:	55                   	push   %ebp
801093eb:	89 e5                	mov    %esp,%ebp
801093ed:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801093f0:	8b 45 10             	mov    0x10(%ebp),%eax
801093f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801093f6:	72 08                	jb     80109400 <deallocuvm+0x16>
    return oldsz;
801093f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801093fb:	e9 a5 00 00 00       	jmp    801094a5 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109400:	8b 45 10             	mov    0x10(%ebp),%eax
80109403:	05 ff 0f 00 00       	add    $0xfff,%eax
80109408:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010940d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109410:	e9 81 00 00 00       	jmp    80109496 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109418:	83 ec 04             	sub    $0x4,%esp
8010941b:	6a 00                	push   $0x0
8010941d:	50                   	push   %eax
8010941e:	ff 75 08             	pushl  0x8(%ebp)
80109421:	e8 24 fa ff ff       	call   80108e4a <walkpgdir>
80109426:	83 c4 10             	add    $0x10,%esp
80109429:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010942c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109430:	75 09                	jne    8010943b <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109432:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109439:	eb 54                	jmp    8010948f <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
8010943b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010943e:	8b 00                	mov    (%eax),%eax
80109440:	83 e0 01             	and    $0x1,%eax
80109443:	85 c0                	test   %eax,%eax
80109445:	74 48                	je     8010948f <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109447:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010944a:	8b 00                	mov    (%eax),%eax
8010944c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109451:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109454:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109458:	75 0d                	jne    80109467 <deallocuvm+0x7d>
        panic("kfree");
8010945a:	83 ec 0c             	sub    $0xc,%esp
8010945d:	68 9d a0 10 80       	push   $0x8010a09d
80109462:	e8 ff 70 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109467:	83 ec 0c             	sub    $0xc,%esp
8010946a:	ff 75 ec             	pushl  -0x14(%ebp)
8010946d:	e8 56 f5 ff ff       	call   801089c8 <p2v>
80109472:	83 c4 10             	add    $0x10,%esp
80109475:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109478:	83 ec 0c             	sub    $0xc,%esp
8010947b:	ff 75 e8             	pushl  -0x18(%ebp)
8010947e:	e8 00 99 ff ff       	call   80102d83 <kfree>
80109483:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109486:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109489:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010948f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109496:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109499:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010949c:	0f 82 73 ff ff ff    	jb     80109415 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801094a2:	8b 45 10             	mov    0x10(%ebp),%eax
}
801094a5:	c9                   	leave  
801094a6:	c3                   	ret    

801094a7 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801094a7:	55                   	push   %ebp
801094a8:	89 e5                	mov    %esp,%ebp
801094aa:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801094ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801094b1:	75 0d                	jne    801094c0 <freevm+0x19>
    panic("freevm: no pgdir");
801094b3:	83 ec 0c             	sub    $0xc,%esp
801094b6:	68 a3 a0 10 80       	push   $0x8010a0a3
801094bb:	e8 a6 70 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801094c0:	83 ec 04             	sub    $0x4,%esp
801094c3:	6a 00                	push   $0x0
801094c5:	68 00 00 00 80       	push   $0x80000000
801094ca:	ff 75 08             	pushl  0x8(%ebp)
801094cd:	e8 18 ff ff ff       	call   801093ea <deallocuvm>
801094d2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801094d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801094dc:	eb 4f                	jmp    8010952d <freevm+0x86>
    if(pgdir[i] & PTE_P){
801094de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801094e8:	8b 45 08             	mov    0x8(%ebp),%eax
801094eb:	01 d0                	add    %edx,%eax
801094ed:	8b 00                	mov    (%eax),%eax
801094ef:	83 e0 01             	and    $0x1,%eax
801094f2:	85 c0                	test   %eax,%eax
801094f4:	74 33                	je     80109529 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801094f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109500:	8b 45 08             	mov    0x8(%ebp),%eax
80109503:	01 d0                	add    %edx,%eax
80109505:	8b 00                	mov    (%eax),%eax
80109507:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010950c:	83 ec 0c             	sub    $0xc,%esp
8010950f:	50                   	push   %eax
80109510:	e8 b3 f4 ff ff       	call   801089c8 <p2v>
80109515:	83 c4 10             	add    $0x10,%esp
80109518:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010951b:	83 ec 0c             	sub    $0xc,%esp
8010951e:	ff 75 f0             	pushl  -0x10(%ebp)
80109521:	e8 5d 98 ff ff       	call   80102d83 <kfree>
80109526:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109529:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010952d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109534:	76 a8                	jbe    801094de <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109536:	83 ec 0c             	sub    $0xc,%esp
80109539:	ff 75 08             	pushl  0x8(%ebp)
8010953c:	e8 42 98 ff ff       	call   80102d83 <kfree>
80109541:	83 c4 10             	add    $0x10,%esp
}
80109544:	90                   	nop
80109545:	c9                   	leave  
80109546:	c3                   	ret    

80109547 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109547:	55                   	push   %ebp
80109548:	89 e5                	mov    %esp,%ebp
8010954a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010954d:	83 ec 04             	sub    $0x4,%esp
80109550:	6a 00                	push   $0x0
80109552:	ff 75 0c             	pushl  0xc(%ebp)
80109555:	ff 75 08             	pushl  0x8(%ebp)
80109558:	e8 ed f8 ff ff       	call   80108e4a <walkpgdir>
8010955d:	83 c4 10             	add    $0x10,%esp
80109560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109567:	75 0d                	jne    80109576 <clearpteu+0x2f>
    panic("clearpteu");
80109569:	83 ec 0c             	sub    $0xc,%esp
8010956c:	68 b4 a0 10 80       	push   $0x8010a0b4
80109571:	e8 f0 6f ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109579:	8b 00                	mov    (%eax),%eax
8010957b:	83 e0 fb             	and    $0xfffffffb,%eax
8010957e:	89 c2                	mov    %eax,%edx
80109580:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109583:	89 10                	mov    %edx,(%eax)
}
80109585:	90                   	nop
80109586:	c9                   	leave  
80109587:	c3                   	ret    

80109588 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109588:	55                   	push   %ebp
80109589:	89 e5                	mov    %esp,%ebp
8010958b:	53                   	push   %ebx
8010958c:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010958f:	e8 e6 f9 ff ff       	call   80108f7a <setupkvm>
80109594:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109597:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010959b:	75 0a                	jne    801095a7 <copyuvm+0x1f>
    return 0;
8010959d:	b8 00 00 00 00       	mov    $0x0,%eax
801095a2:	e9 f8 00 00 00       	jmp    8010969f <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
801095a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801095ae:	e9 c4 00 00 00       	jmp    80109677 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801095b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095b6:	83 ec 04             	sub    $0x4,%esp
801095b9:	6a 00                	push   $0x0
801095bb:	50                   	push   %eax
801095bc:	ff 75 08             	pushl  0x8(%ebp)
801095bf:	e8 86 f8 ff ff       	call   80108e4a <walkpgdir>
801095c4:	83 c4 10             	add    $0x10,%esp
801095c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801095ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801095ce:	75 0d                	jne    801095dd <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801095d0:	83 ec 0c             	sub    $0xc,%esp
801095d3:	68 be a0 10 80       	push   $0x8010a0be
801095d8:	e8 89 6f ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
801095dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801095e0:	8b 00                	mov    (%eax),%eax
801095e2:	83 e0 01             	and    $0x1,%eax
801095e5:	85 c0                	test   %eax,%eax
801095e7:	75 0d                	jne    801095f6 <copyuvm+0x6e>
      panic("copyuvm: page not present");
801095e9:	83 ec 0c             	sub    $0xc,%esp
801095ec:	68 d8 a0 10 80       	push   $0x8010a0d8
801095f1:	e8 70 6f ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801095f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801095f9:	8b 00                	mov    (%eax),%eax
801095fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109600:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109603:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109606:	8b 00                	mov    (%eax),%eax
80109608:	25 ff 0f 00 00       	and    $0xfff,%eax
8010960d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109610:	e8 0b 98 ff ff       	call   80102e20 <kalloc>
80109615:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109618:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010961c:	74 6a                	je     80109688 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010961e:	83 ec 0c             	sub    $0xc,%esp
80109621:	ff 75 e8             	pushl  -0x18(%ebp)
80109624:	e8 9f f3 ff ff       	call   801089c8 <p2v>
80109629:	83 c4 10             	add    $0x10,%esp
8010962c:	83 ec 04             	sub    $0x4,%esp
8010962f:	68 00 10 00 00       	push   $0x1000
80109634:	50                   	push   %eax
80109635:	ff 75 e0             	pushl  -0x20(%ebp)
80109638:	e8 39 cb ff ff       	call   80106176 <memmove>
8010963d:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109640:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109643:	83 ec 0c             	sub    $0xc,%esp
80109646:	ff 75 e0             	pushl  -0x20(%ebp)
80109649:	e8 6d f3 ff ff       	call   801089bb <v2p>
8010964e:	83 c4 10             	add    $0x10,%esp
80109651:	89 c2                	mov    %eax,%edx
80109653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109656:	83 ec 0c             	sub    $0xc,%esp
80109659:	53                   	push   %ebx
8010965a:	52                   	push   %edx
8010965b:	68 00 10 00 00       	push   $0x1000
80109660:	50                   	push   %eax
80109661:	ff 75 f0             	pushl  -0x10(%ebp)
80109664:	e8 81 f8 ff ff       	call   80108eea <mappages>
80109669:	83 c4 20             	add    $0x20,%esp
8010966c:	85 c0                	test   %eax,%eax
8010966e:	78 1b                	js     8010968b <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109670:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010967a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010967d:	0f 82 30 ff ff ff    	jb     801095b3 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109683:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109686:	eb 17                	jmp    8010969f <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109688:	90                   	nop
80109689:	eb 01                	jmp    8010968c <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010968b:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010968c:	83 ec 0c             	sub    $0xc,%esp
8010968f:	ff 75 f0             	pushl  -0x10(%ebp)
80109692:	e8 10 fe ff ff       	call   801094a7 <freevm>
80109697:	83 c4 10             	add    $0x10,%esp
  return 0;
8010969a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010969f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801096a2:	c9                   	leave  
801096a3:	c3                   	ret    

801096a4 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801096a4:	55                   	push   %ebp
801096a5:	89 e5                	mov    %esp,%ebp
801096a7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801096aa:	83 ec 04             	sub    $0x4,%esp
801096ad:	6a 00                	push   $0x0
801096af:	ff 75 0c             	pushl  0xc(%ebp)
801096b2:	ff 75 08             	pushl  0x8(%ebp)
801096b5:	e8 90 f7 ff ff       	call   80108e4a <walkpgdir>
801096ba:	83 c4 10             	add    $0x10,%esp
801096bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801096c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096c3:	8b 00                	mov    (%eax),%eax
801096c5:	83 e0 01             	and    $0x1,%eax
801096c8:	85 c0                	test   %eax,%eax
801096ca:	75 07                	jne    801096d3 <uva2ka+0x2f>
    return 0;
801096cc:	b8 00 00 00 00       	mov    $0x0,%eax
801096d1:	eb 29                	jmp    801096fc <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801096d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096d6:	8b 00                	mov    (%eax),%eax
801096d8:	83 e0 04             	and    $0x4,%eax
801096db:	85 c0                	test   %eax,%eax
801096dd:	75 07                	jne    801096e6 <uva2ka+0x42>
    return 0;
801096df:	b8 00 00 00 00       	mov    $0x0,%eax
801096e4:	eb 16                	jmp    801096fc <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801096e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096e9:	8b 00                	mov    (%eax),%eax
801096eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096f0:	83 ec 0c             	sub    $0xc,%esp
801096f3:	50                   	push   %eax
801096f4:	e8 cf f2 ff ff       	call   801089c8 <p2v>
801096f9:	83 c4 10             	add    $0x10,%esp
}
801096fc:	c9                   	leave  
801096fd:	c3                   	ret    

801096fe <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801096fe:	55                   	push   %ebp
801096ff:	89 e5                	mov    %esp,%ebp
80109701:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109704:	8b 45 10             	mov    0x10(%ebp),%eax
80109707:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010970a:	eb 7f                	jmp    8010978b <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010970c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010970f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109714:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109717:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010971a:	83 ec 08             	sub    $0x8,%esp
8010971d:	50                   	push   %eax
8010971e:	ff 75 08             	pushl  0x8(%ebp)
80109721:	e8 7e ff ff ff       	call   801096a4 <uva2ka>
80109726:	83 c4 10             	add    $0x10,%esp
80109729:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010972c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109730:	75 07                	jne    80109739 <copyout+0x3b>
      return -1;
80109732:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109737:	eb 61                	jmp    8010979a <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109739:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010973c:	2b 45 0c             	sub    0xc(%ebp),%eax
8010973f:	05 00 10 00 00       	add    $0x1000,%eax
80109744:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109747:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010974a:	3b 45 14             	cmp    0x14(%ebp),%eax
8010974d:	76 06                	jbe    80109755 <copyout+0x57>
      n = len;
8010974f:	8b 45 14             	mov    0x14(%ebp),%eax
80109752:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109755:	8b 45 0c             	mov    0xc(%ebp),%eax
80109758:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010975b:	89 c2                	mov    %eax,%edx
8010975d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109760:	01 d0                	add    %edx,%eax
80109762:	83 ec 04             	sub    $0x4,%esp
80109765:	ff 75 f0             	pushl  -0x10(%ebp)
80109768:	ff 75 f4             	pushl  -0xc(%ebp)
8010976b:	50                   	push   %eax
8010976c:	e8 05 ca ff ff       	call   80106176 <memmove>
80109771:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109774:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109777:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010977a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010977d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109780:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109783:	05 00 10 00 00       	add    $0x1000,%eax
80109788:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010978b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010978f:	0f 85 77 ff ff ff    	jne    8010970c <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109795:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010979a:	c9                   	leave  
8010979b:	c3                   	ret    
