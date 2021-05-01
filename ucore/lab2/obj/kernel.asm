
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 d0 11 00 	lgdtl  0x11d018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 d0 11 c0       	mov    $0xc011d000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 84 e9 11 c0       	mov    $0xc011e984,%edx
c0100035:	b8 36 da 11 c0       	mov    $0xc011da36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 da 11 c0 	movl   $0xc011da36,(%esp)
c0100051:	e8 ac 95 00 00       	call   c0109602 <memset>

    cons_init();                // init the console
c0100056:	e8 83 15 00 00       	call   c01015de <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 20 9e 10 c0 	movl   $0xc0109e20,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 3c 9e 10 c0 	movl   $0xc0109e3c,(%esp)
c0100070:	e8 1c 02 00 00       	call   c0100291 <cprintf>

    print_kerninfo();
c0100075:	e8 bd 08 00 00       	call   c0100937 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 4b 32 00 00       	call   c01032cf <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b2 16 00 00       	call   c010173b <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 10 18 00 00       	call   c010189e <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 01 0d 00 00       	call   c0100d94 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 de 17 00 00       	call   c0101876 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 c6 0c 00 00       	call   c0100d82 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 da 11 c0       	mov    0xc011da40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 41 9e 10 c0 	movl   $0xc0109e41,(%esp)
c010015c:	e8 30 01 00 00       	call   c0100291 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 da 11 c0       	mov    0xc011da40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 4f 9e 10 c0 	movl   $0xc0109e4f,(%esp)
c010017c:	e8 10 01 00 00       	call   c0100291 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 da 11 c0       	mov    0xc011da40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 5d 9e 10 c0 	movl   $0xc0109e5d,(%esp)
c010019c:	e8 f0 00 00 00       	call   c0100291 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 da 11 c0       	mov    0xc011da40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 6b 9e 10 c0 	movl   $0xc0109e6b,(%esp)
c01001bc:	e8 d0 00 00 00       	call   c0100291 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 da 11 c0       	mov    0xc011da40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 79 9e 10 c0 	movl   $0xc0109e79,(%esp)
c01001dc:	e8 b0 00 00 00       	call   c0100291 <cprintf>
    round ++;
c01001e1:	a1 40 da 11 c0       	mov    0xc011da40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 da 11 c0       	mov    %eax,0xc011da40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile(
c01001f3:	83 ec 08             	sub    $0x8,%esp
c01001f6:	cd 78                	int    $0x78
c01001f8:	89 ec                	mov    %ebp,%esp
		"int %0 \n"//调用 T_SWITCH_TOU 中断
		"movl %%ebp,%%esp"//恢复栈指针
		:
		: "i"(T_SWITCH_TOU)
	);
}
c01001fa:	5d                   	pop    %ebp
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	//把tf->tf_cs和tf->tf_ds都设置为内核代码段和内核数据段
	asm volatile(
c01001ff:	cd 79                	int    $0x79
c0100201:	89 ec                	mov    %ebp,%esp
		"int %0 \n"// //调用T_SWITCH_TOK号中断
		"movl %%ebp, %%esp \n"//强行改为内核态，会让cpu认为没有发生特权级转换，%esp的值就不对了
		:
		: "i"(T_SWITCH_TOK)
	);
}
c0100203:	5d                   	pop    %ebp
c0100204:	c3                   	ret    

c0100205 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100205:	55                   	push   %ebp
c0100206:	89 e5                	mov    %esp,%ebp
c0100208:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020b:	e8 1a ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100210:	c7 04 24 88 9e 10 c0 	movl   $0xc0109e88,(%esp)
c0100217:	e8 75 00 00 00       	call   c0100291 <cprintf>
    lab1_switch_to_user();
c010021c:	e8 cf ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100221:	e8 04 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100226:	c7 04 24 a8 9e 10 c0 	movl   $0xc0109ea8,(%esp)
c010022d:	e8 5f 00 00 00       	call   c0100291 <cprintf>
    lab1_switch_to_kernel();
c0100232:	e8 c5 ff ff ff       	call   c01001fc <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100237:	e8 ee fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100244:	8b 45 08             	mov    0x8(%ebp),%eax
c0100247:	89 04 24             	mov    %eax,(%esp)
c010024a:	e8 bb 13 00 00       	call   c010160a <cons_putc>
    (*cnt) ++;
c010024f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100252:	8b 00                	mov    (%eax),%eax
c0100254:	8d 50 01             	lea    0x1(%eax),%edx
c0100257:	8b 45 0c             	mov    0xc(%ebp),%eax
c010025a:	89 10                	mov    %edx,(%eax)
}
c010025c:	c9                   	leave  
c010025d:	c3                   	ret    

c010025e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010025e:	55                   	push   %ebp
c010025f:	89 e5                	mov    %esp,%ebp
c0100261:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100264:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010026b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100272:	8b 45 08             	mov    0x8(%ebp),%eax
c0100275:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100279:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010027c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100280:	c7 04 24 3e 02 10 c0 	movl   $0xc010023e,(%esp)
c0100287:	e8 c8 96 00 00       	call   c0109954 <vprintfmt>
    return cnt;
c010028c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010028f:	c9                   	leave  
c0100290:	c3                   	ret    

c0100291 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100291:	55                   	push   %ebp
c0100292:	89 e5                	mov    %esp,%ebp
c0100294:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100297:	8d 45 0c             	lea    0xc(%ebp),%eax
c010029a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010029d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a7:	89 04 24             	mov    %eax,(%esp)
c01002aa:	e8 af ff ff ff       	call   c010025e <vcprintf>
c01002af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002b5:	c9                   	leave  
c01002b6:	c3                   	ret    

c01002b7 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002b7:	55                   	push   %ebp
c01002b8:	89 e5                	mov    %esp,%ebp
c01002ba:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01002c0:	89 04 24             	mov    %eax,(%esp)
c01002c3:	e8 42 13 00 00       	call   c010160a <cons_putc>
}
c01002c8:	c9                   	leave  
c01002c9:	c3                   	ret    

c01002ca <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002ca:	55                   	push   %ebp
c01002cb:	89 e5                	mov    %esp,%ebp
c01002cd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002d7:	eb 13                	jmp    c01002ec <cputs+0x22>
        cputch(c, &cnt);
c01002d9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002dd:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002e0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002e4:	89 04 24             	mov    %eax,(%esp)
c01002e7:	e8 52 ff ff ff       	call   c010023e <cputch>
    while ((c = *str ++) != '\0') {
c01002ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ef:	8d 50 01             	lea    0x1(%eax),%edx
c01002f2:	89 55 08             	mov    %edx,0x8(%ebp)
c01002f5:	0f b6 00             	movzbl (%eax),%eax
c01002f8:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002fb:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002ff:	75 d8                	jne    c01002d9 <cputs+0xf>
    }
    cputch('\n', &cnt);
c0100301:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100304:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100308:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c010030f:	e8 2a ff ff ff       	call   c010023e <cputch>
    return cnt;
c0100314:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100317:	c9                   	leave  
c0100318:	c3                   	ret    

c0100319 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100319:	55                   	push   %ebp
c010031a:	89 e5                	mov    %esp,%ebp
c010031c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010031f:	e8 22 13 00 00       	call   c0101646 <cons_getc>
c0100324:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010032b:	74 f2                	je     c010031f <getchar+0x6>
        /* do nothing */;
    return c;
c010032d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100330:	c9                   	leave  
c0100331:	c3                   	ret    

c0100332 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100332:	55                   	push   %ebp
c0100333:	89 e5                	mov    %esp,%ebp
c0100335:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010033c:	74 13                	je     c0100351 <readline+0x1f>
        cprintf("%s", prompt);
c010033e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100341:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100345:	c7 04 24 c7 9e 10 c0 	movl   $0xc0109ec7,(%esp)
c010034c:	e8 40 ff ff ff       	call   c0100291 <cprintf>
    }
    int i = 0, c;
c0100351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100358:	e8 bc ff ff ff       	call   c0100319 <getchar>
c010035d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100360:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100364:	79 07                	jns    c010036d <readline+0x3b>
            return NULL;
c0100366:	b8 00 00 00 00       	mov    $0x0,%eax
c010036b:	eb 79                	jmp    c01003e6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010036d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100371:	7e 28                	jle    c010039b <readline+0x69>
c0100373:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010037a:	7f 1f                	jg     c010039b <readline+0x69>
            cputchar(c);
c010037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010037f:	89 04 24             	mov    %eax,(%esp)
c0100382:	e8 30 ff ff ff       	call   c01002b7 <cputchar>
            buf[i ++] = c;
c0100387:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010038a:	8d 50 01             	lea    0x1(%eax),%edx
c010038d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100390:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100393:	88 90 60 da 11 c0    	mov    %dl,-0x3fee25a0(%eax)
c0100399:	eb 46                	jmp    c01003e1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010039b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010039f:	75 17                	jne    c01003b8 <readline+0x86>
c01003a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003a5:	7e 11                	jle    c01003b8 <readline+0x86>
            cputchar(c);
c01003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003aa:	89 04 24             	mov    %eax,(%esp)
c01003ad:	e8 05 ff ff ff       	call   c01002b7 <cputchar>
            i --;
c01003b2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003b6:	eb 29                	jmp    c01003e1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01003b8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003bc:	74 06                	je     c01003c4 <readline+0x92>
c01003be:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003c2:	75 1d                	jne    c01003e1 <readline+0xaf>
            cputchar(c);
c01003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c7:	89 04 24             	mov    %eax,(%esp)
c01003ca:	e8 e8 fe ff ff       	call   c01002b7 <cputchar>
            buf[i] = '\0';
c01003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d2:	05 60 da 11 c0       	add    $0xc011da60,%eax
c01003d7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003da:	b8 60 da 11 c0       	mov    $0xc011da60,%eax
c01003df:	eb 05                	jmp    c01003e6 <readline+0xb4>
        }
    }
c01003e1:	e9 72 ff ff ff       	jmp    c0100358 <readline+0x26>
}
c01003e6:	c9                   	leave  
c01003e7:	c3                   	ret    

c01003e8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003e8:	55                   	push   %ebp
c01003e9:	89 e5                	mov    %esp,%ebp
c01003eb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003ee:	a1 60 de 11 c0       	mov    0xc011de60,%eax
c01003f3:	85 c0                	test   %eax,%eax
c01003f5:	74 02                	je     c01003f9 <__panic+0x11>
        goto panic_dead;
c01003f7:	eb 48                	jmp    c0100441 <__panic+0x59>
    }
    is_panic = 1;
c01003f9:	c7 05 60 de 11 c0 01 	movl   $0x1,0xc011de60
c0100400:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100403:	8d 45 14             	lea    0x14(%ebp),%eax
c0100406:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100409:	8b 45 0c             	mov    0xc(%ebp),%eax
c010040c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100410:	8b 45 08             	mov    0x8(%ebp),%eax
c0100413:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100417:	c7 04 24 ca 9e 10 c0 	movl   $0xc0109eca,(%esp)
c010041e:	e8 6e fe ff ff       	call   c0100291 <cprintf>
    vcprintf(fmt, ap);
c0100423:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100426:	89 44 24 04          	mov    %eax,0x4(%esp)
c010042a:	8b 45 10             	mov    0x10(%ebp),%eax
c010042d:	89 04 24             	mov    %eax,(%esp)
c0100430:	e8 29 fe ff ff       	call   c010025e <vcprintf>
    cprintf("\n");
c0100435:	c7 04 24 e6 9e 10 c0 	movl   $0xc0109ee6,(%esp)
c010043c:	e8 50 fe ff ff       	call   c0100291 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100441:	e8 36 14 00 00       	call   c010187c <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100446:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010044d:	e8 61 08 00 00       	call   c0100cb3 <kmonitor>
    }
c0100452:	eb f2                	jmp    c0100446 <__panic+0x5e>

c0100454 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100454:	55                   	push   %ebp
c0100455:	89 e5                	mov    %esp,%ebp
c0100457:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c010045a:	8d 45 14             	lea    0x14(%ebp),%eax
c010045d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100460:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100463:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100467:	8b 45 08             	mov    0x8(%ebp),%eax
c010046a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010046e:	c7 04 24 e8 9e 10 c0 	movl   $0xc0109ee8,(%esp)
c0100475:	e8 17 fe ff ff       	call   c0100291 <cprintf>
    vcprintf(fmt, ap);
c010047a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010047d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100481:	8b 45 10             	mov    0x10(%ebp),%eax
c0100484:	89 04 24             	mov    %eax,(%esp)
c0100487:	e8 d2 fd ff ff       	call   c010025e <vcprintf>
    cprintf("\n");
c010048c:	c7 04 24 e6 9e 10 c0 	movl   $0xc0109ee6,(%esp)
c0100493:	e8 f9 fd ff ff       	call   c0100291 <cprintf>
    va_end(ap);
}
c0100498:	c9                   	leave  
c0100499:	c3                   	ret    

c010049a <is_kernel_panic>:

bool
is_kernel_panic(void) {
c010049a:	55                   	push   %ebp
c010049b:	89 e5                	mov    %esp,%ebp
    return is_panic;
c010049d:	a1 60 de 11 c0       	mov    0xc011de60,%eax
}
c01004a2:	5d                   	pop    %ebp
c01004a3:	c3                   	ret    

c01004a4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004a4:	55                   	push   %ebp
c01004a5:	89 e5                	mov    %esp,%ebp
c01004a7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ad:	8b 00                	mov    (%eax),%eax
c01004af:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b5:	8b 00                	mov    (%eax),%eax
c01004b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004c1:	e9 d2 00 00 00       	jmp    c0100598 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004cc:	01 d0                	add    %edx,%eax
c01004ce:	89 c2                	mov    %eax,%edx
c01004d0:	c1 ea 1f             	shr    $0x1f,%edx
c01004d3:	01 d0                	add    %edx,%eax
c01004d5:	d1 f8                	sar    %eax
c01004d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004dd:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004e0:	eb 04                	jmp    c01004e6 <stab_binsearch+0x42>
            m --;
c01004e2:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c01004e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004ec:	7c 1f                	jl     c010050d <stab_binsearch+0x69>
c01004ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004f1:	89 d0                	mov    %edx,%eax
c01004f3:	01 c0                	add    %eax,%eax
c01004f5:	01 d0                	add    %edx,%eax
c01004f7:	c1 e0 02             	shl    $0x2,%eax
c01004fa:	89 c2                	mov    %eax,%edx
c01004fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ff:	01 d0                	add    %edx,%eax
c0100501:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100505:	0f b6 c0             	movzbl %al,%eax
c0100508:	3b 45 14             	cmp    0x14(%ebp),%eax
c010050b:	75 d5                	jne    c01004e2 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c010050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100510:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100513:	7d 0b                	jge    c0100520 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100518:	83 c0 01             	add    $0x1,%eax
c010051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010051e:	eb 78                	jmp    c0100598 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100520:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100527:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010052a:	89 d0                	mov    %edx,%eax
c010052c:	01 c0                	add    %eax,%eax
c010052e:	01 d0                	add    %edx,%eax
c0100530:	c1 e0 02             	shl    $0x2,%eax
c0100533:	89 c2                	mov    %eax,%edx
c0100535:	8b 45 08             	mov    0x8(%ebp),%eax
c0100538:	01 d0                	add    %edx,%eax
c010053a:	8b 40 08             	mov    0x8(%eax),%eax
c010053d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100540:	73 13                	jae    c0100555 <stab_binsearch+0xb1>
            *region_left = m;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100548:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010054a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010054d:	83 c0 01             	add    $0x1,%eax
c0100550:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100553:	eb 43                	jmp    c0100598 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100555:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100558:	89 d0                	mov    %edx,%eax
c010055a:	01 c0                	add    %eax,%eax
c010055c:	01 d0                	add    %edx,%eax
c010055e:	c1 e0 02             	shl    $0x2,%eax
c0100561:	89 c2                	mov    %eax,%edx
c0100563:	8b 45 08             	mov    0x8(%ebp),%eax
c0100566:	01 d0                	add    %edx,%eax
c0100568:	8b 40 08             	mov    0x8(%eax),%eax
c010056b:	3b 45 18             	cmp    0x18(%ebp),%eax
c010056e:	76 16                	jbe    c0100586 <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100570:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100573:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100576:	8b 45 10             	mov    0x10(%ebp),%eax
c0100579:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010057b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057e:	83 e8 01             	sub    $0x1,%eax
c0100581:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100584:	eb 12                	jmp    c0100598 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100586:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100589:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010058c:	89 10                	mov    %edx,(%eax)
            l = m;
c010058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100591:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c0100594:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c0100598:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010059b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010059e:	0f 8e 22 ff ff ff    	jle    c01004c6 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005a8:	75 0f                	jne    c01005b9 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ad:	8b 00                	mov    (%eax),%eax
c01005af:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005b5:	89 10                	mov    %edx,(%eax)
c01005b7:	eb 3f                	jmp    c01005f8 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01005bc:	8b 00                	mov    (%eax),%eax
c01005be:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005c1:	eb 04                	jmp    c01005c7 <stab_binsearch+0x123>
c01005c3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ca:	8b 00                	mov    (%eax),%eax
c01005cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005cf:	7d 1f                	jge    c01005f0 <stab_binsearch+0x14c>
c01005d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005d4:	89 d0                	mov    %edx,%eax
c01005d6:	01 c0                	add    %eax,%eax
c01005d8:	01 d0                	add    %edx,%eax
c01005da:	c1 e0 02             	shl    $0x2,%eax
c01005dd:	89 c2                	mov    %eax,%edx
c01005df:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e2:	01 d0                	add    %edx,%eax
c01005e4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005e8:	0f b6 c0             	movzbl %al,%eax
c01005eb:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005ee:	75 d3                	jne    c01005c3 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f6:	89 10                	mov    %edx,(%eax)
    }
}
c01005f8:	c9                   	leave  
c01005f9:	c3                   	ret    

c01005fa <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005fa:	55                   	push   %ebp
c01005fb:	89 e5                	mov    %esp,%ebp
c01005fd:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100600:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100603:	c7 00 08 9f 10 c0    	movl   $0xc0109f08,(%eax)
    info->eip_line = 0;
c0100609:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100613:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100616:	c7 40 08 08 9f 10 c0 	movl   $0xc0109f08,0x8(%eax)
    info->eip_fn_namelen = 9;
c010061d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100620:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100627:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062a:	8b 55 08             	mov    0x8(%ebp),%edx
c010062d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100630:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100633:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010063a:	c7 45 f4 10 b5 10 c0 	movl   $0xc010b510,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100641:	c7 45 f0 90 7c 11 c0 	movl   $0xc0117c90,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100648:	c7 45 ec 91 7c 11 c0 	movl   $0xc0117c91,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010064f:	c7 45 e8 00 aa 11 c0 	movl   $0xc011aa00,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100656:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100659:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010065c:	76 0d                	jbe    c010066b <debuginfo_eip+0x71>
c010065e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100661:	83 e8 01             	sub    $0x1,%eax
c0100664:	0f b6 00             	movzbl (%eax),%eax
c0100667:	84 c0                	test   %al,%al
c0100669:	74 0a                	je     c0100675 <debuginfo_eip+0x7b>
        return -1;
c010066b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100670:	e9 c0 02 00 00       	jmp    c0100935 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100675:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010067c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010067f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100682:	29 c2                	sub    %eax,%edx
c0100684:	89 d0                	mov    %edx,%eax
c0100686:	c1 f8 02             	sar    $0x2,%eax
c0100689:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c010068f:	83 e8 01             	sub    $0x1,%eax
c0100692:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c0100695:	8b 45 08             	mov    0x8(%ebp),%eax
c0100698:	89 44 24 10          	mov    %eax,0x10(%esp)
c010069c:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006a3:	00 
c01006a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006a7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b5:	89 04 24             	mov    %eax,(%esp)
c01006b8:	e8 e7 fd ff ff       	call   c01004a4 <stab_binsearch>
    if (lfile == 0)
c01006bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006c0:	85 c0                	test   %eax,%eax
c01006c2:	75 0a                	jne    c01006ce <debuginfo_eip+0xd4>
        return -1;
c01006c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006c9:	e9 67 02 00 00       	jmp    c0100935 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006da:	8b 45 08             	mov    0x8(%ebp),%eax
c01006dd:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e1:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c01006e8:	00 
c01006e9:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f0:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006fa:	89 04 24             	mov    %eax,(%esp)
c01006fd:	e8 a2 fd ff ff       	call   c01004a4 <stab_binsearch>

    if (lfun <= rfun) {
c0100702:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100705:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100708:	39 c2                	cmp    %eax,%edx
c010070a:	7f 7c                	jg     c0100788 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010070c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010070f:	89 c2                	mov    %eax,%edx
c0100711:	89 d0                	mov    %edx,%eax
c0100713:	01 c0                	add    %eax,%eax
c0100715:	01 d0                	add    %edx,%eax
c0100717:	c1 e0 02             	shl    $0x2,%eax
c010071a:	89 c2                	mov    %eax,%edx
c010071c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071f:	01 d0                	add    %edx,%eax
c0100721:	8b 10                	mov    (%eax),%edx
c0100723:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100726:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100729:	29 c1                	sub    %eax,%ecx
c010072b:	89 c8                	mov    %ecx,%eax
c010072d:	39 c2                	cmp    %eax,%edx
c010072f:	73 22                	jae    c0100753 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100731:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100734:	89 c2                	mov    %eax,%edx
c0100736:	89 d0                	mov    %edx,%eax
c0100738:	01 c0                	add    %eax,%eax
c010073a:	01 d0                	add    %edx,%eax
c010073c:	c1 e0 02             	shl    $0x2,%eax
c010073f:	89 c2                	mov    %eax,%edx
c0100741:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100744:	01 d0                	add    %edx,%eax
c0100746:	8b 10                	mov    (%eax),%edx
c0100748:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010074b:	01 c2                	add    %eax,%edx
c010074d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100750:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100753:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100756:	89 c2                	mov    %eax,%edx
c0100758:	89 d0                	mov    %edx,%eax
c010075a:	01 c0                	add    %eax,%eax
c010075c:	01 d0                	add    %edx,%eax
c010075e:	c1 e0 02             	shl    $0x2,%eax
c0100761:	89 c2                	mov    %eax,%edx
c0100763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100766:	01 d0                	add    %edx,%eax
c0100768:	8b 50 08             	mov    0x8(%eax),%edx
c010076b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076e:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100771:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100774:	8b 40 10             	mov    0x10(%eax),%eax
c0100777:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c010077a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010077d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100780:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100783:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100786:	eb 15                	jmp    c010079d <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100788:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078b:	8b 55 08             	mov    0x8(%ebp),%edx
c010078e:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c0100791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100794:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100797:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010079a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c010079d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a0:	8b 40 08             	mov    0x8(%eax),%eax
c01007a3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007aa:	00 
c01007ab:	89 04 24             	mov    %eax,(%esp)
c01007ae:	e8 c3 8c 00 00       	call   c0109476 <strfind>
c01007b3:	89 c2                	mov    %eax,%edx
c01007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b8:	8b 40 08             	mov    0x8(%eax),%eax
c01007bb:	29 c2                	sub    %eax,%edx
c01007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c0:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01007c6:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007ca:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007d1:	00 
c01007d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007d5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e3:	89 04 24             	mov    %eax,(%esp)
c01007e6:	e8 b9 fc ff ff       	call   c01004a4 <stab_binsearch>
    if (lline <= rline) {
c01007eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007f1:	39 c2                	cmp    %eax,%edx
c01007f3:	7f 24                	jg     c0100819 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c01007f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007f8:	89 c2                	mov    %eax,%edx
c01007fa:	89 d0                	mov    %edx,%eax
c01007fc:	01 c0                	add    %eax,%eax
c01007fe:	01 d0                	add    %edx,%eax
c0100800:	c1 e0 02             	shl    $0x2,%eax
c0100803:	89 c2                	mov    %eax,%edx
c0100805:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100808:	01 d0                	add    %edx,%eax
c010080a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010080e:	0f b7 d0             	movzwl %ax,%edx
c0100811:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100814:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100817:	eb 13                	jmp    c010082c <debuginfo_eip+0x232>
        return -1;
c0100819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010081e:	e9 12 01 00 00       	jmp    c0100935 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100823:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100826:	83 e8 01             	sub    $0x1,%eax
c0100829:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010082c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100832:	39 c2                	cmp    %eax,%edx
c0100834:	7c 56                	jl     c010088c <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100839:	89 c2                	mov    %eax,%edx
c010083b:	89 d0                	mov    %edx,%eax
c010083d:	01 c0                	add    %eax,%eax
c010083f:	01 d0                	add    %edx,%eax
c0100841:	c1 e0 02             	shl    $0x2,%eax
c0100844:	89 c2                	mov    %eax,%edx
c0100846:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100849:	01 d0                	add    %edx,%eax
c010084b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010084f:	3c 84                	cmp    $0x84,%al
c0100851:	74 39                	je     c010088c <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100856:	89 c2                	mov    %eax,%edx
c0100858:	89 d0                	mov    %edx,%eax
c010085a:	01 c0                	add    %eax,%eax
c010085c:	01 d0                	add    %edx,%eax
c010085e:	c1 e0 02             	shl    $0x2,%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100866:	01 d0                	add    %edx,%eax
c0100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086c:	3c 64                	cmp    $0x64,%al
c010086e:	75 b3                	jne    c0100823 <debuginfo_eip+0x229>
c0100870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100873:	89 c2                	mov    %eax,%edx
c0100875:	89 d0                	mov    %edx,%eax
c0100877:	01 c0                	add    %eax,%eax
c0100879:	01 d0                	add    %edx,%eax
c010087b:	c1 e0 02             	shl    $0x2,%eax
c010087e:	89 c2                	mov    %eax,%edx
c0100880:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100883:	01 d0                	add    %edx,%eax
c0100885:	8b 40 08             	mov    0x8(%eax),%eax
c0100888:	85 c0                	test   %eax,%eax
c010088a:	74 97                	je     c0100823 <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c010088c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010088f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100892:	39 c2                	cmp    %eax,%edx
c0100894:	7c 46                	jl     c01008dc <debuginfo_eip+0x2e2>
c0100896:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100899:	89 c2                	mov    %eax,%edx
c010089b:	89 d0                	mov    %edx,%eax
c010089d:	01 c0                	add    %eax,%eax
c010089f:	01 d0                	add    %edx,%eax
c01008a1:	c1 e0 02             	shl    $0x2,%eax
c01008a4:	89 c2                	mov    %eax,%edx
c01008a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a9:	01 d0                	add    %edx,%eax
c01008ab:	8b 10                	mov    (%eax),%edx
c01008ad:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008b3:	29 c1                	sub    %eax,%ecx
c01008b5:	89 c8                	mov    %ecx,%eax
c01008b7:	39 c2                	cmp    %eax,%edx
c01008b9:	73 21                	jae    c01008dc <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008be:	89 c2                	mov    %eax,%edx
c01008c0:	89 d0                	mov    %edx,%eax
c01008c2:	01 c0                	add    %eax,%eax
c01008c4:	01 d0                	add    %edx,%eax
c01008c6:	c1 e0 02             	shl    $0x2,%eax
c01008c9:	89 c2                	mov    %eax,%edx
c01008cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ce:	01 d0                	add    %edx,%eax
c01008d0:	8b 10                	mov    (%eax),%edx
c01008d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008d5:	01 c2                	add    %eax,%edx
c01008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008da:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008e2:	39 c2                	cmp    %eax,%edx
c01008e4:	7d 4a                	jge    c0100930 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c01008e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008e9:	83 c0 01             	add    $0x1,%eax
c01008ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008ef:	eb 18                	jmp    c0100909 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f4:	8b 40 14             	mov    0x14(%eax),%eax
c01008f7:	8d 50 01             	lea    0x1(%eax),%edx
c01008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008fd:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100903:	83 c0 01             	add    $0x1,%eax
c0100906:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100909:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010090c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c010090f:	39 c2                	cmp    %eax,%edx
c0100911:	7d 1d                	jge    c0100930 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100913:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100916:	89 c2                	mov    %eax,%edx
c0100918:	89 d0                	mov    %edx,%eax
c010091a:	01 c0                	add    %eax,%eax
c010091c:	01 d0                	add    %edx,%eax
c010091e:	c1 e0 02             	shl    $0x2,%eax
c0100921:	89 c2                	mov    %eax,%edx
c0100923:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100926:	01 d0                	add    %edx,%eax
c0100928:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010092c:	3c a0                	cmp    $0xa0,%al
c010092e:	74 c1                	je     c01008f1 <debuginfo_eip+0x2f7>
        }
    }
    return 0;
c0100930:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100935:	c9                   	leave  
c0100936:	c3                   	ret    

c0100937 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100937:	55                   	push   %ebp
c0100938:	89 e5                	mov    %esp,%ebp
c010093a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010093d:	c7 04 24 12 9f 10 c0 	movl   $0xc0109f12,(%esp)
c0100944:	e8 48 f9 ff ff       	call   c0100291 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100949:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100950:	c0 
c0100951:	c7 04 24 2b 9f 10 c0 	movl   $0xc0109f2b,(%esp)
c0100958:	e8 34 f9 ff ff       	call   c0100291 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010095d:	c7 44 24 04 0c 9e 10 	movl   $0xc0109e0c,0x4(%esp)
c0100964:	c0 
c0100965:	c7 04 24 43 9f 10 c0 	movl   $0xc0109f43,(%esp)
c010096c:	e8 20 f9 ff ff       	call   c0100291 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100971:	c7 44 24 04 36 da 11 	movl   $0xc011da36,0x4(%esp)
c0100978:	c0 
c0100979:	c7 04 24 5b 9f 10 c0 	movl   $0xc0109f5b,(%esp)
c0100980:	e8 0c f9 ff ff       	call   c0100291 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100985:	c7 44 24 04 84 e9 11 	movl   $0xc011e984,0x4(%esp)
c010098c:	c0 
c010098d:	c7 04 24 73 9f 10 c0 	movl   $0xc0109f73,(%esp)
c0100994:	e8 f8 f8 ff ff       	call   c0100291 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100999:	b8 84 e9 11 c0       	mov    $0xc011e984,%eax
c010099e:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009a4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01009a9:	29 c2                	sub    %eax,%edx
c01009ab:	89 d0                	mov    %edx,%eax
c01009ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009b3:	85 c0                	test   %eax,%eax
c01009b5:	0f 48 c2             	cmovs  %edx,%eax
c01009b8:	c1 f8 0a             	sar    $0xa,%eax
c01009bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009bf:	c7 04 24 8c 9f 10 c0 	movl   $0xc0109f8c,(%esp)
c01009c6:	e8 c6 f8 ff ff       	call   c0100291 <cprintf>
}
c01009cb:	c9                   	leave  
c01009cc:	c3                   	ret    

c01009cd <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009cd:	55                   	push   %ebp
c01009ce:	89 e5                	mov    %esp,%ebp
c01009d0:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e0:	89 04 24             	mov    %eax,(%esp)
c01009e3:	e8 12 fc ff ff       	call   c01005fa <debuginfo_eip>
c01009e8:	85 c0                	test   %eax,%eax
c01009ea:	74 15                	je     c0100a01 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f3:	c7 04 24 b6 9f 10 c0 	movl   $0xc0109fb6,(%esp)
c01009fa:	e8 92 f8 ff ff       	call   c0100291 <cprintf>
c01009ff:	eb 6d                	jmp    c0100a6e <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a08:	eb 1c                	jmp    c0100a26 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a10:	01 d0                	add    %edx,%eax
c0100a12:	0f b6 00             	movzbl (%eax),%eax
c0100a15:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a1e:	01 ca                	add    %ecx,%edx
c0100a20:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a2c:	7f dc                	jg     c0100a0a <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
c0100a2e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a37:	01 d0                	add    %edx,%eax
c0100a39:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a3f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a42:	89 d1                	mov    %edx,%ecx
c0100a44:	29 c1                	sub    %eax,%ecx
c0100a46:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a50:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a56:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a5a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a62:	c7 04 24 d2 9f 10 c0 	movl   $0xc0109fd2,(%esp)
c0100a69:	e8 23 f8 ff ff       	call   c0100291 <cprintf>
    }
}
c0100a6e:	c9                   	leave  
c0100a6f:	c3                   	ret    

c0100a70 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a70:	55                   	push   %ebp
c0100a71:	89 e5                	mov    %esp,%ebp
c0100a73:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a76:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a79:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a7f:	c9                   	leave  
c0100a80:	c3                   	ret    

c0100a81 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a81:	55                   	push   %ebp
c0100a82:	89 e5                	mov    %esp,%ebp
c0100a84:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a87:	89 e8                	mov    %ebp,%eax
c0100a89:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t v_ebp=read_ebp();
c0100a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t v_eip=read_eip();
c0100a92:	e8 d9 ff ff ff       	call   c0100a70 <read_eip>
c0100a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for(i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
c0100a9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100aa1:	e9 8f 00 00 00       	jmp    c0100b35 <print_stackframe+0xb4>
	{
		cprintf("ebp: 0x%08x , eip: 0x%08x , ",v_ebp,v_eip);
c0100aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100aa9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab4:	c7 04 24 e4 9f 10 c0 	movl   $0xc0109fe4,(%esp)
c0100abb:	e8 d1 f7 ff ff       	call   c0100291 <cprintf>
		uint32_t *args=(uint32_t *)v_ebp +2;
c0100ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ac3:	83 c0 08             	add    $0x8,%eax
c0100ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int j;
		for(j=0;j<4;++j)
c0100ac9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100ad0:	eb 2c                	jmp    c0100afe <print_stackframe+0x7d>
		{
			cprintf("args[%d] = 0x%08x   ",j,args[j]);
c0100ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100ad5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100adf:	01 d0                	add    %edx,%eax
c0100ae1:	8b 00                	mov    (%eax),%eax
c0100ae3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aee:	c7 04 24 01 a0 10 c0 	movl   $0xc010a001,(%esp)
c0100af5:	e8 97 f7 ff ff       	call   c0100291 <cprintf>
		for(j=0;j<4;++j)
c0100afa:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100afe:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b02:	7e ce                	jle    c0100ad2 <print_stackframe+0x51>
		}
		cprintf("\n");
c0100b04:	c7 04 24 16 a0 10 c0 	movl   $0xc010a016,(%esp)
c0100b0b:	e8 81 f7 ff ff       	call   c0100291 <cprintf>
		print_debuginfo(v_eip-1);
c0100b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b13:	83 e8 01             	sub    $0x1,%eax
c0100b16:	89 04 24             	mov    %eax,(%esp)
c0100b19:	e8 af fe ff ff       	call   c01009cd <print_debuginfo>
		v_eip=((uint32_t *)v_ebp)[1];
c0100b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b21:	83 c0 04             	add    $0x4,%eax
c0100b24:	8b 00                	mov    (%eax),%eax
c0100b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
		v_ebp=((uint32_t *)v_ebp)[0];
c0100b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b2c:	8b 00                	mov    (%eax),%eax
c0100b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
c0100b31:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b35:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b39:	7f 0a                	jg     c0100b45 <print_stackframe+0xc4>
c0100b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b3f:	0f 85 61 ff ff ff    	jne    c0100aa6 <print_stackframe+0x25>
	}


}
c0100b45:	c9                   	leave  
c0100b46:	c3                   	ret    

c0100b47 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b47:	55                   	push   %ebp
c0100b48:	89 e5                	mov    %esp,%ebp
c0100b4a:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b54:	eb 0c                	jmp    c0100b62 <parse+0x1b>
            *buf ++ = '\0';
c0100b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b59:	8d 50 01             	lea    0x1(%eax),%edx
c0100b5c:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b5f:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b65:	0f b6 00             	movzbl (%eax),%eax
c0100b68:	84 c0                	test   %al,%al
c0100b6a:	74 1d                	je     c0100b89 <parse+0x42>
c0100b6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6f:	0f b6 00             	movzbl (%eax),%eax
c0100b72:	0f be c0             	movsbl %al,%eax
c0100b75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b79:	c7 04 24 98 a0 10 c0 	movl   $0xc010a098,(%esp)
c0100b80:	e8 be 88 00 00       	call   c0109443 <strchr>
c0100b85:	85 c0                	test   %eax,%eax
c0100b87:	75 cd                	jne    c0100b56 <parse+0xf>
        }
        if (*buf == '\0') {
c0100b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8c:	0f b6 00             	movzbl (%eax),%eax
c0100b8f:	84 c0                	test   %al,%al
c0100b91:	75 02                	jne    c0100b95 <parse+0x4e>
            break;
c0100b93:	eb 67                	jmp    c0100bfc <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b95:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b99:	75 14                	jne    c0100baf <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b9b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ba2:	00 
c0100ba3:	c7 04 24 9d a0 10 c0 	movl   $0xc010a09d,(%esp)
c0100baa:	e8 e2 f6 ff ff       	call   c0100291 <cprintf>
        }
        argv[argc ++] = buf;
c0100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bb2:	8d 50 01             	lea    0x1(%eax),%edx
c0100bb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bc2:	01 c2                	add    %eax,%edx
c0100bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bc9:	eb 04                	jmp    c0100bcf <parse+0x88>
            buf ++;
c0100bcb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd2:	0f b6 00             	movzbl (%eax),%eax
c0100bd5:	84 c0                	test   %al,%al
c0100bd7:	74 1d                	je     c0100bf6 <parse+0xaf>
c0100bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bdc:	0f b6 00             	movzbl (%eax),%eax
c0100bdf:	0f be c0             	movsbl %al,%eax
c0100be2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be6:	c7 04 24 98 a0 10 c0 	movl   $0xc010a098,(%esp)
c0100bed:	e8 51 88 00 00       	call   c0109443 <strchr>
c0100bf2:	85 c0                	test   %eax,%eax
c0100bf4:	74 d5                	je     c0100bcb <parse+0x84>
        }
    }
c0100bf6:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bf7:	e9 66 ff ff ff       	jmp    c0100b62 <parse+0x1b>
    return argc;
c0100bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bff:	c9                   	leave  
c0100c00:	c3                   	ret    

c0100c01 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c01:	55                   	push   %ebp
c0100c02:	89 e5                	mov    %esp,%ebp
c0100c04:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c07:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c11:	89 04 24             	mov    %eax,(%esp)
c0100c14:	e8 2e ff ff ff       	call   c0100b47 <parse>
c0100c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c20:	75 0a                	jne    c0100c2c <runcmd+0x2b>
        return 0;
c0100c22:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c27:	e9 85 00 00 00       	jmp    c0100cb1 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c33:	eb 5c                	jmp    c0100c91 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c35:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c3b:	89 d0                	mov    %edx,%eax
c0100c3d:	01 c0                	add    %eax,%eax
c0100c3f:	01 d0                	add    %edx,%eax
c0100c41:	c1 e0 02             	shl    $0x2,%eax
c0100c44:	05 20 d0 11 c0       	add    $0xc011d020,%eax
c0100c49:	8b 00                	mov    (%eax),%eax
c0100c4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c4f:	89 04 24             	mov    %eax,(%esp)
c0100c52:	e8 4d 87 00 00       	call   c01093a4 <strcmp>
c0100c57:	85 c0                	test   %eax,%eax
c0100c59:	75 32                	jne    c0100c8d <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5e:	89 d0                	mov    %edx,%eax
c0100c60:	01 c0                	add    %eax,%eax
c0100c62:	01 d0                	add    %edx,%eax
c0100c64:	c1 e0 02             	shl    $0x2,%eax
c0100c67:	05 20 d0 11 c0       	add    $0xc011d020,%eax
c0100c6c:	8b 40 08             	mov    0x8(%eax),%eax
c0100c6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100c72:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100c75:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100c78:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c7c:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100c7f:	83 c2 04             	add    $0x4,%edx
c0100c82:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100c86:	89 0c 24             	mov    %ecx,(%esp)
c0100c89:	ff d0                	call   *%eax
c0100c8b:	eb 24                	jmp    c0100cb1 <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c94:	83 f8 02             	cmp    $0x2,%eax
c0100c97:	76 9c                	jbe    c0100c35 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c99:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca0:	c7 04 24 bb a0 10 c0 	movl   $0xc010a0bb,(%esp)
c0100ca7:	e8 e5 f5 ff ff       	call   c0100291 <cprintf>
    return 0;
c0100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb1:	c9                   	leave  
c0100cb2:	c3                   	ret    

c0100cb3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cb3:	55                   	push   %ebp
c0100cb4:	89 e5                	mov    %esp,%ebp
c0100cb6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cb9:	c7 04 24 d4 a0 10 c0 	movl   $0xc010a0d4,(%esp)
c0100cc0:	e8 cc f5 ff ff       	call   c0100291 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100cc5:	c7 04 24 fc a0 10 c0 	movl   $0xc010a0fc,(%esp)
c0100ccc:	e8 c0 f5 ff ff       	call   c0100291 <cprintf>

    if (tf != NULL) {
c0100cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cd5:	74 0b                	je     c0100ce2 <kmonitor+0x2f>
        print_trapframe(tf);
c0100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cda:	89 04 24             	mov    %eax,(%esp)
c0100cdd:	e8 f8 0d 00 00       	call   c0101ada <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100ce2:	c7 04 24 21 a1 10 c0 	movl   $0xc010a121,(%esp)
c0100ce9:	e8 44 f6 ff ff       	call   c0100332 <readline>
c0100cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cf5:	74 18                	je     c0100d0f <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d01:	89 04 24             	mov    %eax,(%esp)
c0100d04:	e8 f8 fe ff ff       	call   c0100c01 <runcmd>
c0100d09:	85 c0                	test   %eax,%eax
c0100d0b:	79 02                	jns    c0100d0f <kmonitor+0x5c>
                break;
c0100d0d:	eb 02                	jmp    c0100d11 <kmonitor+0x5e>
            }
        }
    }
c0100d0f:	eb d1                	jmp    c0100ce2 <kmonitor+0x2f>
}
c0100d11:	c9                   	leave  
c0100d12:	c3                   	ret    

c0100d13 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d13:	55                   	push   %ebp
c0100d14:	89 e5                	mov    %esp,%ebp
c0100d16:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d20:	eb 3f                	jmp    c0100d61 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d25:	89 d0                	mov    %edx,%eax
c0100d27:	01 c0                	add    %eax,%eax
c0100d29:	01 d0                	add    %edx,%eax
c0100d2b:	c1 e0 02             	shl    $0x2,%eax
c0100d2e:	05 20 d0 11 c0       	add    $0xc011d020,%eax
c0100d33:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d39:	89 d0                	mov    %edx,%eax
c0100d3b:	01 c0                	add    %eax,%eax
c0100d3d:	01 d0                	add    %edx,%eax
c0100d3f:	c1 e0 02             	shl    $0x2,%eax
c0100d42:	05 20 d0 11 c0       	add    $0xc011d020,%eax
c0100d47:	8b 00                	mov    (%eax),%eax
c0100d49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d51:	c7 04 24 25 a1 10 c0 	movl   $0xc010a125,(%esp)
c0100d58:	e8 34 f5 ff ff       	call   c0100291 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d5d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d64:	83 f8 02             	cmp    $0x2,%eax
c0100d67:	76 b9                	jbe    c0100d22 <mon_help+0xf>
    }
    return 0;
c0100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d6e:	c9                   	leave  
c0100d6f:	c3                   	ret    

c0100d70 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d70:	55                   	push   %ebp
c0100d71:	89 e5                	mov    %esp,%ebp
c0100d73:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d76:	e8 bc fb ff ff       	call   c0100937 <print_kerninfo>
    return 0;
c0100d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d80:	c9                   	leave  
c0100d81:	c3                   	ret    

c0100d82 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d88:	e8 f4 fc ff ff       	call   c0100a81 <print_stackframe>
    return 0;
c0100d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d92:	c9                   	leave  
c0100d93:	c3                   	ret    

c0100d94 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d94:	55                   	push   %ebp
c0100d95:	89 e5                	mov    %esp,%ebp
c0100d97:	83 ec 28             	sub    $0x28,%esp
c0100d9a:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da0:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dac:	ee                   	out    %al,(%dx)
c0100dad:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dbb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dbf:	ee                   	out    %al,(%dx)
c0100dc0:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dc6:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dca:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dce:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd3:	c7 05 68 e9 11 c0 00 	movl   $0x0,0xc011e968
c0100dda:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100ddd:	c7 04 24 2e a1 10 c0 	movl   $0xc010a12e,(%esp)
c0100de4:	e8 a8 f4 ff ff       	call   c0100291 <cprintf>
    pic_enable(IRQ_TIMER);
c0100de9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df0:	e8 18 09 00 00       	call   c010170d <pic_enable>
}
c0100df5:	c9                   	leave  
c0100df6:	c3                   	ret    

c0100df7 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df7:	55                   	push   %ebp
c0100df8:	89 e5                	mov    %esp,%ebp
c0100dfa:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dfd:	9c                   	pushf  
c0100dfe:	58                   	pop    %eax
c0100dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e05:	25 00 02 00 00       	and    $0x200,%eax
c0100e0a:	85 c0                	test   %eax,%eax
c0100e0c:	74 0c                	je     c0100e1a <__intr_save+0x23>
        intr_disable();
c0100e0e:	e8 69 0a 00 00       	call   c010187c <intr_disable>
        return 1;
c0100e13:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e18:	eb 05                	jmp    c0100e1f <__intr_save+0x28>
    }
    return 0;
c0100e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e1f:	c9                   	leave  
c0100e20:	c3                   	ret    

c0100e21 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e21:	55                   	push   %ebp
c0100e22:	89 e5                	mov    %esp,%ebp
c0100e24:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e2b:	74 05                	je     c0100e32 <__intr_restore+0x11>
        intr_enable();
c0100e2d:	e8 44 0a 00 00       	call   c0101876 <intr_enable>
    }
}
c0100e32:	c9                   	leave  
c0100e33:	c3                   	ret    

c0100e34 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e34:	55                   	push   %ebp
c0100e35:	89 e5                	mov    %esp,%ebp
c0100e37:	83 ec 10             	sub    $0x10,%esp
c0100e3a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e40:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e44:	89 c2                	mov    %eax,%edx
c0100e46:	ec                   	in     (%dx),%al
c0100e47:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e4a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e50:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e54:	89 c2                	mov    %eax,%edx
c0100e56:	ec                   	in     (%dx),%al
c0100e57:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e5a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e60:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e64:	89 c2                	mov    %eax,%edx
c0100e66:	ec                   	in     (%dx),%al
c0100e67:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6a:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e70:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e74:	89 c2                	mov    %eax,%edx
c0100e76:	ec                   	in     (%dx),%al
c0100e77:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7a:	c9                   	leave  
c0100e7b:	c3                   	ret    

c0100e7c <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e7c:	55                   	push   %ebp
c0100e7d:	89 e5                	mov    %esp,%ebp
c0100e7f:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e82:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8c:	0f b7 00             	movzwl (%eax),%eax
c0100e8f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e96:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9e:	0f b7 00             	movzwl (%eax),%eax
c0100ea1:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea5:	74 12                	je     c0100eb9 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea7:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eae:	66 c7 05 86 de 11 c0 	movw   $0x3b4,0xc011de86
c0100eb5:	b4 03 
c0100eb7:	eb 13                	jmp    c0100ecc <cga_init+0x50>
    } else {
        *cp = was;
c0100eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ebc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec0:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec3:	66 c7 05 86 de 11 c0 	movw   $0x3d4,0xc011de86
c0100eca:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ecc:	0f b7 05 86 de 11 c0 	movzwl 0xc011de86,%eax
c0100ed3:	0f b7 c0             	movzwl %ax,%eax
c0100ed6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100eda:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ede:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ee6:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee7:	0f b7 05 86 de 11 c0 	movzwl 0xc011de86,%eax
c0100eee:	83 c0 01             	add    $0x1,%eax
c0100ef1:	0f b7 c0             	movzwl %ax,%eax
c0100ef4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef8:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100efc:	89 c2                	mov    %eax,%edx
c0100efe:	ec                   	in     (%dx),%al
c0100eff:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f02:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f06:	0f b6 c0             	movzbl %al,%eax
c0100f09:	c1 e0 08             	shl    $0x8,%eax
c0100f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f0f:	0f b7 05 86 de 11 c0 	movzwl 0xc011de86,%eax
c0100f16:	0f b7 c0             	movzwl %ax,%eax
c0100f19:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f1d:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f21:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f25:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f29:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2a:	0f b7 05 86 de 11 c0 	movzwl 0xc011de86,%eax
c0100f31:	83 c0 01             	add    $0x1,%eax
c0100f34:	0f b7 c0             	movzwl %ax,%eax
c0100f37:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3b:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f3f:	89 c2                	mov    %eax,%edx
c0100f41:	ec                   	in     (%dx),%al
c0100f42:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f49:	0f b6 c0             	movzbl %al,%eax
c0100f4c:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f52:	a3 80 de 11 c0       	mov    %eax,0xc011de80
    crt_pos = pos;
c0100f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5a:	66 a3 84 de 11 c0    	mov    %ax,0xc011de84
}
c0100f60:	c9                   	leave  
c0100f61:	c3                   	ret    

c0100f62 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f62:	55                   	push   %ebp
c0100f63:	89 e5                	mov    %esp,%ebp
c0100f65:	83 ec 48             	sub    $0x48,%esp
c0100f68:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f6e:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f72:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f76:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7a:	ee                   	out    %al,(%dx)
c0100f7b:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f81:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f85:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f89:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f8d:	ee                   	out    %al,(%dx)
c0100f8e:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f94:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f98:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f9c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa0:	ee                   	out    %al,(%dx)
c0100fa1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa7:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fab:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100faf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb3:	ee                   	out    %al,(%dx)
c0100fb4:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fba:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fbe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fc6:	ee                   	out    %al,(%dx)
c0100fc7:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fcd:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd9:	ee                   	out    %al,(%dx)
c0100fda:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe0:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe4:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe8:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fec:	ee                   	out    %al,(%dx)
c0100fed:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff3:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ff7:	89 c2                	mov    %eax,%edx
c0100ff9:	ec                   	in     (%dx),%al
c0100ffa:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ffd:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101001:	3c ff                	cmp    $0xff,%al
c0101003:	0f 95 c0             	setne  %al
c0101006:	0f b6 c0             	movzbl %al,%eax
c0101009:	a3 88 de 11 c0       	mov    %eax,0xc011de88
c010100e:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101014:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101018:	89 c2                	mov    %eax,%edx
c010101a:	ec                   	in     (%dx),%al
c010101b:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010101e:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101024:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101028:	89 c2                	mov    %eax,%edx
c010102a:	ec                   	in     (%dx),%al
c010102b:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010102e:	a1 88 de 11 c0       	mov    0xc011de88,%eax
c0101033:	85 c0                	test   %eax,%eax
c0101035:	74 0c                	je     c0101043 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101037:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010103e:	e8 ca 06 00 00       	call   c010170d <pic_enable>
    }
}
c0101043:	c9                   	leave  
c0101044:	c3                   	ret    

c0101045 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101045:	55                   	push   %ebp
c0101046:	89 e5                	mov    %esp,%ebp
c0101048:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101052:	eb 09                	jmp    c010105d <lpt_putc_sub+0x18>
        delay();
c0101054:	e8 db fd ff ff       	call   c0100e34 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101059:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010105d:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101063:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101067:	89 c2                	mov    %eax,%edx
c0101069:	ec                   	in     (%dx),%al
c010106a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010106d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101071:	84 c0                	test   %al,%al
c0101073:	78 09                	js     c010107e <lpt_putc_sub+0x39>
c0101075:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010107c:	7e d6                	jle    c0101054 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c010107e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101081:	0f b6 c0             	movzbl %al,%eax
c0101084:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010108a:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010108d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101091:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101095:	ee                   	out    %al,(%dx)
c0101096:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010109c:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a8:	ee                   	out    %al,(%dx)
c01010a9:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010af:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010b7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010bb:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010bc:	c9                   	leave  
c01010bd:	c3                   	ret    

c01010be <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010be:	55                   	push   %ebp
c01010bf:	89 e5                	mov    %esp,%ebp
c01010c1:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c8:	74 0d                	je     c01010d7 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01010cd:	89 04 24             	mov    %eax,(%esp)
c01010d0:	e8 70 ff ff ff       	call   c0101045 <lpt_putc_sub>
c01010d5:	eb 24                	jmp    c01010fb <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010de:	e8 62 ff ff ff       	call   c0101045 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ea:	e8 56 ff ff ff       	call   c0101045 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010ef:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f6:	e8 4a ff ff ff       	call   c0101045 <lpt_putc_sub>
    }
}
c01010fb:	c9                   	leave  
c01010fc:	c3                   	ret    

c01010fd <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010fd:	55                   	push   %ebp
c01010fe:	89 e5                	mov    %esp,%ebp
c0101100:	53                   	push   %ebx
c0101101:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101104:	8b 45 08             	mov    0x8(%ebp),%eax
c0101107:	b0 00                	mov    $0x0,%al
c0101109:	85 c0                	test   %eax,%eax
c010110b:	75 07                	jne    c0101114 <cga_putc+0x17>
        c |= 0x0700;
c010110d:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101114:	8b 45 08             	mov    0x8(%ebp),%eax
c0101117:	0f b6 c0             	movzbl %al,%eax
c010111a:	83 f8 0a             	cmp    $0xa,%eax
c010111d:	74 4c                	je     c010116b <cga_putc+0x6e>
c010111f:	83 f8 0d             	cmp    $0xd,%eax
c0101122:	74 57                	je     c010117b <cga_putc+0x7e>
c0101124:	83 f8 08             	cmp    $0x8,%eax
c0101127:	0f 85 88 00 00 00    	jne    c01011b5 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010112d:	0f b7 05 84 de 11 c0 	movzwl 0xc011de84,%eax
c0101134:	66 85 c0             	test   %ax,%ax
c0101137:	74 30                	je     c0101169 <cga_putc+0x6c>
            crt_pos --;
c0101139:	0f b7 05 84 de 11 c0 	movzwl 0xc011de84,%eax
c0101140:	83 e8 01             	sub    $0x1,%eax
c0101143:	66 a3 84 de 11 c0    	mov    %ax,0xc011de84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101149:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c010114e:	0f b7 15 84 de 11 c0 	movzwl 0xc011de84,%edx
c0101155:	0f b7 d2             	movzwl %dx,%edx
c0101158:	01 d2                	add    %edx,%edx
c010115a:	01 c2                	add    %eax,%edx
c010115c:	8b 45 08             	mov    0x8(%ebp),%eax
c010115f:	b0 00                	mov    $0x0,%al
c0101161:	83 c8 20             	or     $0x20,%eax
c0101164:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101167:	eb 72                	jmp    c01011db <cga_putc+0xde>
c0101169:	eb 70                	jmp    c01011db <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010116b:	0f b7 05 84 de 11 c0 	movzwl 0xc011de84,%eax
c0101172:	83 c0 50             	add    $0x50,%eax
c0101175:	66 a3 84 de 11 c0    	mov    %ax,0xc011de84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010117b:	0f b7 1d 84 de 11 c0 	movzwl 0xc011de84,%ebx
c0101182:	0f b7 0d 84 de 11 c0 	movzwl 0xc011de84,%ecx
c0101189:	0f b7 c1             	movzwl %cx,%eax
c010118c:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101192:	c1 e8 10             	shr    $0x10,%eax
c0101195:	89 c2                	mov    %eax,%edx
c0101197:	66 c1 ea 06          	shr    $0x6,%dx
c010119b:	89 d0                	mov    %edx,%eax
c010119d:	c1 e0 02             	shl    $0x2,%eax
c01011a0:	01 d0                	add    %edx,%eax
c01011a2:	c1 e0 04             	shl    $0x4,%eax
c01011a5:	29 c1                	sub    %eax,%ecx
c01011a7:	89 ca                	mov    %ecx,%edx
c01011a9:	89 d8                	mov    %ebx,%eax
c01011ab:	29 d0                	sub    %edx,%eax
c01011ad:	66 a3 84 de 11 c0    	mov    %ax,0xc011de84
        break;
c01011b3:	eb 26                	jmp    c01011db <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b5:	8b 0d 80 de 11 c0    	mov    0xc011de80,%ecx
c01011bb:	0f b7 05 84 de 11 c0 	movzwl 0xc011de84,%eax
c01011c2:	8d 50 01             	lea    0x1(%eax),%edx
c01011c5:	66 89 15 84 de 11 c0 	mov    %dx,0xc011de84
c01011cc:	0f b7 c0             	movzwl %ax,%eax
c01011cf:	01 c0                	add    %eax,%eax
c01011d1:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d7:	66 89 02             	mov    %ax,(%edx)
        break;
c01011da:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011db:	0f b7 05 84 de 11 c0 	movzwl 0xc011de84,%eax
c01011e2:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011e6:	76 5b                	jbe    c0101243 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e8:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c01011ed:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f3:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c01011f8:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011ff:	00 
c0101200:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101204:	89 04 24             	mov    %eax,(%esp)
c0101207:	e8 35 84 00 00       	call   c0109641 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010120c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101213:	eb 15                	jmp    c010122a <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101215:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c010121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010121d:	01 d2                	add    %edx,%edx
c010121f:	01 d0                	add    %edx,%eax
c0101221:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101226:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101231:	7e e2                	jle    c0101215 <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
c0101233:	0f b7 05 84 de 11 c0 	movzwl 0xc011de84,%eax
c010123a:	83 e8 50             	sub    $0x50,%eax
c010123d:	66 a3 84 de 11 c0    	mov    %ax,0xc011de84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101243:	0f b7 05 86 de 11 c0 	movzwl 0xc011de86,%eax
c010124a:	0f b7 c0             	movzwl %ax,%eax
c010124d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101251:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101255:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101259:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010125d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010125e:	0f b7 05 84 de 11 c0 	movzwl 0xc011de84,%eax
c0101265:	66 c1 e8 08          	shr    $0x8,%ax
c0101269:	0f b6 c0             	movzbl %al,%eax
c010126c:	0f b7 15 86 de 11 c0 	movzwl 0xc011de86,%edx
c0101273:	83 c2 01             	add    $0x1,%edx
c0101276:	0f b7 d2             	movzwl %dx,%edx
c0101279:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010127d:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101280:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101284:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101288:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101289:	0f b7 05 86 de 11 c0 	movzwl 0xc011de86,%eax
c0101290:	0f b7 c0             	movzwl %ax,%eax
c0101293:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101297:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010129b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010129f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a3:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a4:	0f b7 05 84 de 11 c0 	movzwl 0xc011de84,%eax
c01012ab:	0f b6 c0             	movzbl %al,%eax
c01012ae:	0f b7 15 86 de 11 c0 	movzwl 0xc011de86,%edx
c01012b5:	83 c2 01             	add    $0x1,%edx
c01012b8:	0f b7 d2             	movzwl %dx,%edx
c01012bb:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012bf:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012ca:	ee                   	out    %al,(%dx)
}
c01012cb:	83 c4 34             	add    $0x34,%esp
c01012ce:	5b                   	pop    %ebx
c01012cf:	5d                   	pop    %ebp
c01012d0:	c3                   	ret    

c01012d1 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d1:	55                   	push   %ebp
c01012d2:	89 e5                	mov    %esp,%ebp
c01012d4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012de:	eb 09                	jmp    c01012e9 <serial_putc_sub+0x18>
        delay();
c01012e0:	e8 4f fb ff ff       	call   c0100e34 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012ef:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f3:	89 c2                	mov    %eax,%edx
c01012f5:	ec                   	in     (%dx),%al
c01012f6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012fd:	0f b6 c0             	movzbl %al,%eax
c0101300:	83 e0 20             	and    $0x20,%eax
c0101303:	85 c0                	test   %eax,%eax
c0101305:	75 09                	jne    c0101310 <serial_putc_sub+0x3f>
c0101307:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010130e:	7e d0                	jle    c01012e0 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101310:	8b 45 08             	mov    0x8(%ebp),%eax
c0101313:	0f b6 c0             	movzbl %al,%eax
c0101316:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010131c:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101323:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101327:	ee                   	out    %al,(%dx)
}
c0101328:	c9                   	leave  
c0101329:	c3                   	ret    

c010132a <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010132a:	55                   	push   %ebp
c010132b:	89 e5                	mov    %esp,%ebp
c010132d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101330:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101334:	74 0d                	je     c0101343 <serial_putc+0x19>
        serial_putc_sub(c);
c0101336:	8b 45 08             	mov    0x8(%ebp),%eax
c0101339:	89 04 24             	mov    %eax,(%esp)
c010133c:	e8 90 ff ff ff       	call   c01012d1 <serial_putc_sub>
c0101341:	eb 24                	jmp    c0101367 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101343:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134a:	e8 82 ff ff ff       	call   c01012d1 <serial_putc_sub>
        serial_putc_sub(' ');
c010134f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101356:	e8 76 ff ff ff       	call   c01012d1 <serial_putc_sub>
        serial_putc_sub('\b');
c010135b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101362:	e8 6a ff ff ff       	call   c01012d1 <serial_putc_sub>
    }
}
c0101367:	c9                   	leave  
c0101368:	c3                   	ret    

c0101369 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101369:	55                   	push   %ebp
c010136a:	89 e5                	mov    %esp,%ebp
c010136c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010136f:	eb 33                	jmp    c01013a4 <cons_intr+0x3b>
        if (c != 0) {
c0101371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101375:	74 2d                	je     c01013a4 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101377:	a1 a4 e0 11 c0       	mov    0xc011e0a4,%eax
c010137c:	8d 50 01             	lea    0x1(%eax),%edx
c010137f:	89 15 a4 e0 11 c0    	mov    %edx,0xc011e0a4
c0101385:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101388:	88 90 a0 de 11 c0    	mov    %dl,-0x3fee2160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010138e:	a1 a4 e0 11 c0       	mov    0xc011e0a4,%eax
c0101393:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101398:	75 0a                	jne    c01013a4 <cons_intr+0x3b>
                cons.wpos = 0;
c010139a:	c7 05 a4 e0 11 c0 00 	movl   $0x0,0xc011e0a4
c01013a1:	00 00 00 
    while ((c = (*proc)()) != -1) {
c01013a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a7:	ff d0                	call   *%eax
c01013a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b0:	75 bf                	jne    c0101371 <cons_intr+0x8>
            }
        }
    }
}
c01013b2:	c9                   	leave  
c01013b3:	c3                   	ret    

c01013b4 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b4:	55                   	push   %ebp
c01013b5:	89 e5                	mov    %esp,%ebp
c01013b7:	83 ec 10             	sub    $0x10,%esp
c01013ba:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c4:	89 c2                	mov    %eax,%edx
c01013c6:	ec                   	in     (%dx),%al
c01013c7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ca:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013ce:	0f b6 c0             	movzbl %al,%eax
c01013d1:	83 e0 01             	and    $0x1,%eax
c01013d4:	85 c0                	test   %eax,%eax
c01013d6:	75 07                	jne    c01013df <serial_proc_data+0x2b>
        return -1;
c01013d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013dd:	eb 2a                	jmp    c0101409 <serial_proc_data+0x55>
c01013df:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e9:	89 c2                	mov    %eax,%edx
c01013eb:	ec                   	in     (%dx),%al
c01013ec:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013ef:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f3:	0f b6 c0             	movzbl %al,%eax
c01013f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f9:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013fd:	75 07                	jne    c0101406 <serial_proc_data+0x52>
        c = '\b';
c01013ff:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101406:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101409:	c9                   	leave  
c010140a:	c3                   	ret    

c010140b <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010140b:	55                   	push   %ebp
c010140c:	89 e5                	mov    %esp,%ebp
c010140e:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101411:	a1 88 de 11 c0       	mov    0xc011de88,%eax
c0101416:	85 c0                	test   %eax,%eax
c0101418:	74 0c                	je     c0101426 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010141a:	c7 04 24 b4 13 10 c0 	movl   $0xc01013b4,(%esp)
c0101421:	e8 43 ff ff ff       	call   c0101369 <cons_intr>
    }
}
c0101426:	c9                   	leave  
c0101427:	c3                   	ret    

c0101428 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101428:	55                   	push   %ebp
c0101429:	89 e5                	mov    %esp,%ebp
c010142b:	83 ec 38             	sub    $0x38,%esp
c010142e:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101434:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101438:	89 c2                	mov    %eax,%edx
c010143a:	ec                   	in     (%dx),%al
c010143b:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010143e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101442:	0f b6 c0             	movzbl %al,%eax
c0101445:	83 e0 01             	and    $0x1,%eax
c0101448:	85 c0                	test   %eax,%eax
c010144a:	75 0a                	jne    c0101456 <kbd_proc_data+0x2e>
        return -1;
c010144c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101451:	e9 59 01 00 00       	jmp    c01015af <kbd_proc_data+0x187>
c0101456:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010145c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101460:	89 c2                	mov    %eax,%edx
c0101462:	ec                   	in     (%dx),%al
c0101463:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101466:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010146a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010146d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101471:	75 17                	jne    c010148a <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101473:	a1 a8 e0 11 c0       	mov    0xc011e0a8,%eax
c0101478:	83 c8 40             	or     $0x40,%eax
c010147b:	a3 a8 e0 11 c0       	mov    %eax,0xc011e0a8
        return 0;
c0101480:	b8 00 00 00 00       	mov    $0x0,%eax
c0101485:	e9 25 01 00 00       	jmp    c01015af <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010148a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148e:	84 c0                	test   %al,%al
c0101490:	79 47                	jns    c01014d9 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101492:	a1 a8 e0 11 c0       	mov    0xc011e0a8,%eax
c0101497:	83 e0 40             	and    $0x40,%eax
c010149a:	85 c0                	test   %eax,%eax
c010149c:	75 09                	jne    c01014a7 <kbd_proc_data+0x7f>
c010149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a2:	83 e0 7f             	and    $0x7f,%eax
c01014a5:	eb 04                	jmp    c01014ab <kbd_proc_data+0x83>
c01014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ab:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014ae:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b2:	0f b6 80 60 d0 11 c0 	movzbl -0x3fee2fa0(%eax),%eax
c01014b9:	83 c8 40             	or     $0x40,%eax
c01014bc:	0f b6 c0             	movzbl %al,%eax
c01014bf:	f7 d0                	not    %eax
c01014c1:	89 c2                	mov    %eax,%edx
c01014c3:	a1 a8 e0 11 c0       	mov    0xc011e0a8,%eax
c01014c8:	21 d0                	and    %edx,%eax
c01014ca:	a3 a8 e0 11 c0       	mov    %eax,0xc011e0a8
        return 0;
c01014cf:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d4:	e9 d6 00 00 00       	jmp    c01015af <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d9:	a1 a8 e0 11 c0       	mov    0xc011e0a8,%eax
c01014de:	83 e0 40             	and    $0x40,%eax
c01014e1:	85 c0                	test   %eax,%eax
c01014e3:	74 11                	je     c01014f6 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e5:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e9:	a1 a8 e0 11 c0       	mov    0xc011e0a8,%eax
c01014ee:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f1:	a3 a8 e0 11 c0       	mov    %eax,0xc011e0a8
    }

    shift |= shiftcode[data];
c01014f6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fa:	0f b6 80 60 d0 11 c0 	movzbl -0x3fee2fa0(%eax),%eax
c0101501:	0f b6 d0             	movzbl %al,%edx
c0101504:	a1 a8 e0 11 c0       	mov    0xc011e0a8,%eax
c0101509:	09 d0                	or     %edx,%eax
c010150b:	a3 a8 e0 11 c0       	mov    %eax,0xc011e0a8
    shift ^= togglecode[data];
c0101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101514:	0f b6 80 60 d1 11 c0 	movzbl -0x3fee2ea0(%eax),%eax
c010151b:	0f b6 d0             	movzbl %al,%edx
c010151e:	a1 a8 e0 11 c0       	mov    0xc011e0a8,%eax
c0101523:	31 d0                	xor    %edx,%eax
c0101525:	a3 a8 e0 11 c0       	mov    %eax,0xc011e0a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010152a:	a1 a8 e0 11 c0       	mov    0xc011e0a8,%eax
c010152f:	83 e0 03             	and    $0x3,%eax
c0101532:	8b 14 85 60 d5 11 c0 	mov    -0x3fee2aa0(,%eax,4),%edx
c0101539:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153d:	01 d0                	add    %edx,%eax
c010153f:	0f b6 00             	movzbl (%eax),%eax
c0101542:	0f b6 c0             	movzbl %al,%eax
c0101545:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101548:	a1 a8 e0 11 c0       	mov    0xc011e0a8,%eax
c010154d:	83 e0 08             	and    $0x8,%eax
c0101550:	85 c0                	test   %eax,%eax
c0101552:	74 22                	je     c0101576 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101554:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101558:	7e 0c                	jle    c0101566 <kbd_proc_data+0x13e>
c010155a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010155e:	7f 06                	jg     c0101566 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101560:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101564:	eb 10                	jmp    c0101576 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101566:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010156a:	7e 0a                	jle    c0101576 <kbd_proc_data+0x14e>
c010156c:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101570:	7f 04                	jg     c0101576 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101572:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101576:	a1 a8 e0 11 c0       	mov    0xc011e0a8,%eax
c010157b:	f7 d0                	not    %eax
c010157d:	83 e0 06             	and    $0x6,%eax
c0101580:	85 c0                	test   %eax,%eax
c0101582:	75 28                	jne    c01015ac <kbd_proc_data+0x184>
c0101584:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010158b:	75 1f                	jne    c01015ac <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010158d:	c7 04 24 49 a1 10 c0 	movl   $0xc010a149,(%esp)
c0101594:	e8 f8 ec ff ff       	call   c0100291 <cprintf>
c0101599:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010159f:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a7:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015ab:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015af:	c9                   	leave  
c01015b0:	c3                   	ret    

c01015b1 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b1:	55                   	push   %ebp
c01015b2:	89 e5                	mov    %esp,%ebp
c01015b4:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015b7:	c7 04 24 28 14 10 c0 	movl   $0xc0101428,(%esp)
c01015be:	e8 a6 fd ff ff       	call   c0101369 <cons_intr>
}
c01015c3:	c9                   	leave  
c01015c4:	c3                   	ret    

c01015c5 <kbd_init>:

static void
kbd_init(void) {
c01015c5:	55                   	push   %ebp
c01015c6:	89 e5                	mov    %esp,%ebp
c01015c8:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015cb:	e8 e1 ff ff ff       	call   c01015b1 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015d7:	e8 31 01 00 00       	call   c010170d <pic_enable>
}
c01015dc:	c9                   	leave  
c01015dd:	c3                   	ret    

c01015de <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015de:	55                   	push   %ebp
c01015df:	89 e5                	mov    %esp,%ebp
c01015e1:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e4:	e8 93 f8 ff ff       	call   c0100e7c <cga_init>
    serial_init();
c01015e9:	e8 74 f9 ff ff       	call   c0100f62 <serial_init>
    kbd_init();
c01015ee:	e8 d2 ff ff ff       	call   c01015c5 <kbd_init>
    if (!serial_exists) {
c01015f3:	a1 88 de 11 c0       	mov    0xc011de88,%eax
c01015f8:	85 c0                	test   %eax,%eax
c01015fa:	75 0c                	jne    c0101608 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015fc:	c7 04 24 55 a1 10 c0 	movl   $0xc010a155,(%esp)
c0101603:	e8 89 ec ff ff       	call   c0100291 <cprintf>
    }
}
c0101608:	c9                   	leave  
c0101609:	c3                   	ret    

c010160a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010160a:	55                   	push   %ebp
c010160b:	89 e5                	mov    %esp,%ebp
c010160d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101610:	e8 e2 f7 ff ff       	call   c0100df7 <__intr_save>
c0101615:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101618:	8b 45 08             	mov    0x8(%ebp),%eax
c010161b:	89 04 24             	mov    %eax,(%esp)
c010161e:	e8 9b fa ff ff       	call   c01010be <lpt_putc>
        cga_putc(c);
c0101623:	8b 45 08             	mov    0x8(%ebp),%eax
c0101626:	89 04 24             	mov    %eax,(%esp)
c0101629:	e8 cf fa ff ff       	call   c01010fd <cga_putc>
        serial_putc(c);
c010162e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101631:	89 04 24             	mov    %eax,(%esp)
c0101634:	e8 f1 fc ff ff       	call   c010132a <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101639:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010163c:	89 04 24             	mov    %eax,(%esp)
c010163f:	e8 dd f7 ff ff       	call   c0100e21 <__intr_restore>
}
c0101644:	c9                   	leave  
c0101645:	c3                   	ret    

c0101646 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101646:	55                   	push   %ebp
c0101647:	89 e5                	mov    %esp,%ebp
c0101649:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010164c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101653:	e8 9f f7 ff ff       	call   c0100df7 <__intr_save>
c0101658:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010165b:	e8 ab fd ff ff       	call   c010140b <serial_intr>
        kbd_intr();
c0101660:	e8 4c ff ff ff       	call   c01015b1 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101665:	8b 15 a0 e0 11 c0    	mov    0xc011e0a0,%edx
c010166b:	a1 a4 e0 11 c0       	mov    0xc011e0a4,%eax
c0101670:	39 c2                	cmp    %eax,%edx
c0101672:	74 31                	je     c01016a5 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101674:	a1 a0 e0 11 c0       	mov    0xc011e0a0,%eax
c0101679:	8d 50 01             	lea    0x1(%eax),%edx
c010167c:	89 15 a0 e0 11 c0    	mov    %edx,0xc011e0a0
c0101682:	0f b6 80 a0 de 11 c0 	movzbl -0x3fee2160(%eax),%eax
c0101689:	0f b6 c0             	movzbl %al,%eax
c010168c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010168f:	a1 a0 e0 11 c0       	mov    0xc011e0a0,%eax
c0101694:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101699:	75 0a                	jne    c01016a5 <cons_getc+0x5f>
                cons.rpos = 0;
c010169b:	c7 05 a0 e0 11 c0 00 	movl   $0x0,0xc011e0a0
c01016a2:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016a8:	89 04 24             	mov    %eax,(%esp)
c01016ab:	e8 71 f7 ff ff       	call   c0100e21 <__intr_restore>
    return c;
c01016b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b3:	c9                   	leave  
c01016b4:	c3                   	ret    

c01016b5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b5:	55                   	push   %ebp
c01016b6:	89 e5                	mov    %esp,%ebp
c01016b8:	83 ec 14             	sub    $0x14,%esp
c01016bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01016be:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c6:	66 a3 70 d5 11 c0    	mov    %ax,0xc011d570
    if (did_init) {
c01016cc:	a1 ac e0 11 c0       	mov    0xc011e0ac,%eax
c01016d1:	85 c0                	test   %eax,%eax
c01016d3:	74 36                	je     c010170b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d9:	0f b6 c0             	movzbl %al,%eax
c01016dc:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e2:	88 45 fd             	mov    %al,-0x3(%ebp)
c01016e5:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016ed:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ee:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f2:	66 c1 e8 08          	shr    $0x8,%ax
c01016f6:	0f b6 c0             	movzbl %al,%eax
c01016f9:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016ff:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101702:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101706:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010170a:	ee                   	out    %al,(%dx)
    }
}
c010170b:	c9                   	leave  
c010170c:	c3                   	ret    

c010170d <pic_enable>:

void
pic_enable(unsigned int irq) {
c010170d:	55                   	push   %ebp
c010170e:	89 e5                	mov    %esp,%ebp
c0101710:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101713:	8b 45 08             	mov    0x8(%ebp),%eax
c0101716:	ba 01 00 00 00       	mov    $0x1,%edx
c010171b:	89 c1                	mov    %eax,%ecx
c010171d:	d3 e2                	shl    %cl,%edx
c010171f:	89 d0                	mov    %edx,%eax
c0101721:	f7 d0                	not    %eax
c0101723:	89 c2                	mov    %eax,%edx
c0101725:	0f b7 05 70 d5 11 c0 	movzwl 0xc011d570,%eax
c010172c:	21 d0                	and    %edx,%eax
c010172e:	0f b7 c0             	movzwl %ax,%eax
c0101731:	89 04 24             	mov    %eax,(%esp)
c0101734:	e8 7c ff ff ff       	call   c01016b5 <pic_setmask>
}
c0101739:	c9                   	leave  
c010173a:	c3                   	ret    

c010173b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010173b:	55                   	push   %ebp
c010173c:	89 e5                	mov    %esp,%ebp
c010173e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101741:	c7 05 ac e0 11 c0 01 	movl   $0x1,0xc011e0ac
c0101748:	00 00 00 
c010174b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101751:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101755:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101759:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010175d:	ee                   	out    %al,(%dx)
c010175e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101764:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101768:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101770:	ee                   	out    %al,(%dx)
c0101771:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101777:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010177b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010177f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101783:	ee                   	out    %al,(%dx)
c0101784:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010178a:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010178e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101792:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101796:	ee                   	out    %al,(%dx)
c0101797:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010179d:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a9:	ee                   	out    %al,(%dx)
c01017aa:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017b0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017bc:	ee                   	out    %al,(%dx)
c01017bd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c3:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017cf:	ee                   	out    %al,(%dx)
c01017d0:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d6:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017da:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017de:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e2:	ee                   	out    %al,(%dx)
c01017e3:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e9:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017ed:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f5:	ee                   	out    %al,(%dx)
c01017f6:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017fc:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101800:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101804:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101808:	ee                   	out    %al,(%dx)
c0101809:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010180f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101813:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101817:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010181b:	ee                   	out    %al,(%dx)
c010181c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101822:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101826:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010182a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010182e:	ee                   	out    %al,(%dx)
c010182f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101835:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101839:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010183d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101841:	ee                   	out    %al,(%dx)
c0101842:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101848:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010184c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101850:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101854:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101855:	0f b7 05 70 d5 11 c0 	movzwl 0xc011d570,%eax
c010185c:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101860:	74 12                	je     c0101874 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101862:	0f b7 05 70 d5 11 c0 	movzwl 0xc011d570,%eax
c0101869:	0f b7 c0             	movzwl %ax,%eax
c010186c:	89 04 24             	mov    %eax,(%esp)
c010186f:	e8 41 fe ff ff       	call   c01016b5 <pic_setmask>
    }
}
c0101874:	c9                   	leave  
c0101875:	c3                   	ret    

c0101876 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101876:	55                   	push   %ebp
c0101877:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101879:	fb                   	sti    
    sti();
}
c010187a:	5d                   	pop    %ebp
c010187b:	c3                   	ret    

c010187c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010187c:	55                   	push   %ebp
c010187d:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010187f:	fa                   	cli    
    cli();
}
c0101880:	5d                   	pop    %ebp
c0101881:	c3                   	ret    

c0101882 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101882:	55                   	push   %ebp
c0101883:	89 e5                	mov    %esp,%ebp
c0101885:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101888:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010188f:	00 
c0101890:	c7 04 24 80 a1 10 c0 	movl   $0xc010a180,(%esp)
c0101897:	e8 f5 e9 ff ff       	call   c0100291 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010189c:	c9                   	leave  
c010189d:	c3                   	ret    

c010189e <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010189e:	55                   	push   %ebp
c010189f:	89 e5                	mov    %esp,%ebp
c01018a1:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
        int num=sizeof(idt)/sizeof(struct gatedesc);
c01018a4:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i;
        for(i=0;i<num;++i)
c01018ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018b2:	e9 c3 00 00 00       	jmp    c010197a <idt_init+0xdc>
        {
                SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
c01018b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ba:	8b 04 85 00 d6 11 c0 	mov    -0x3fee2a00(,%eax,4),%eax
c01018c1:	89 c2                	mov    %eax,%edx
c01018c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c6:	66 89 14 c5 c0 e0 11 	mov    %dx,-0x3fee1f40(,%eax,8)
c01018cd:	c0 
c01018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d1:	66 c7 04 c5 c2 e0 11 	movw   $0x8,-0x3fee1f3e(,%eax,8)
c01018d8:	c0 08 00 
c01018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018de:	0f b6 14 c5 c4 e0 11 	movzbl -0x3fee1f3c(,%eax,8),%edx
c01018e5:	c0 
c01018e6:	83 e2 e0             	and    $0xffffffe0,%edx
c01018e9:	88 14 c5 c4 e0 11 c0 	mov    %dl,-0x3fee1f3c(,%eax,8)
c01018f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f3:	0f b6 14 c5 c4 e0 11 	movzbl -0x3fee1f3c(,%eax,8),%edx
c01018fa:	c0 
c01018fb:	83 e2 1f             	and    $0x1f,%edx
c01018fe:	88 14 c5 c4 e0 11 c0 	mov    %dl,-0x3fee1f3c(,%eax,8)
c0101905:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101908:	0f b6 14 c5 c5 e0 11 	movzbl -0x3fee1f3b(,%eax,8),%edx
c010190f:	c0 
c0101910:	83 e2 f0             	and    $0xfffffff0,%edx
c0101913:	83 ca 0e             	or     $0xe,%edx
c0101916:	88 14 c5 c5 e0 11 c0 	mov    %dl,-0x3fee1f3b(,%eax,8)
c010191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101920:	0f b6 14 c5 c5 e0 11 	movzbl -0x3fee1f3b(,%eax,8),%edx
c0101927:	c0 
c0101928:	83 e2 ef             	and    $0xffffffef,%edx
c010192b:	88 14 c5 c5 e0 11 c0 	mov    %dl,-0x3fee1f3b(,%eax,8)
c0101932:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101935:	0f b6 14 c5 c5 e0 11 	movzbl -0x3fee1f3b(,%eax,8),%edx
c010193c:	c0 
c010193d:	83 e2 9f             	and    $0xffffff9f,%edx
c0101940:	88 14 c5 c5 e0 11 c0 	mov    %dl,-0x3fee1f3b(,%eax,8)
c0101947:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194a:	0f b6 14 c5 c5 e0 11 	movzbl -0x3fee1f3b(,%eax,8),%edx
c0101951:	c0 
c0101952:	83 ca 80             	or     $0xffffff80,%edx
c0101955:	88 14 c5 c5 e0 11 c0 	mov    %dl,-0x3fee1f3b(,%eax,8)
c010195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195f:	8b 04 85 00 d6 11 c0 	mov    -0x3fee2a00(,%eax,4),%eax
c0101966:	c1 e8 10             	shr    $0x10,%eax
c0101969:	89 c2                	mov    %eax,%edx
c010196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196e:	66 89 14 c5 c6 e0 11 	mov    %dx,-0x3fee1f3a(,%eax,8)
c0101975:	c0 
        for(i=0;i<num;++i)
c0101976:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0101980:	0f 8c 31 ff ff ff    	jl     c01018b7 <idt_init+0x19>
        }

        SETGATE(idt[T_SWITCH_TOU],0,GD_KTEXT,__vectors[T_SWITCH_TOU],DPL_USER);
c0101986:	a1 e0 d7 11 c0       	mov    0xc011d7e0,%eax
c010198b:	66 a3 80 e4 11 c0    	mov    %ax,0xc011e480
c0101991:	66 c7 05 82 e4 11 c0 	movw   $0x8,0xc011e482
c0101998:	08 00 
c010199a:	0f b6 05 84 e4 11 c0 	movzbl 0xc011e484,%eax
c01019a1:	83 e0 e0             	and    $0xffffffe0,%eax
c01019a4:	a2 84 e4 11 c0       	mov    %al,0xc011e484
c01019a9:	0f b6 05 84 e4 11 c0 	movzbl 0xc011e484,%eax
c01019b0:	83 e0 1f             	and    $0x1f,%eax
c01019b3:	a2 84 e4 11 c0       	mov    %al,0xc011e484
c01019b8:	0f b6 05 85 e4 11 c0 	movzbl 0xc011e485,%eax
c01019bf:	83 e0 f0             	and    $0xfffffff0,%eax
c01019c2:	83 c8 0e             	or     $0xe,%eax
c01019c5:	a2 85 e4 11 c0       	mov    %al,0xc011e485
c01019ca:	0f b6 05 85 e4 11 c0 	movzbl 0xc011e485,%eax
c01019d1:	83 e0 ef             	and    $0xffffffef,%eax
c01019d4:	a2 85 e4 11 c0       	mov    %al,0xc011e485
c01019d9:	0f b6 05 85 e4 11 c0 	movzbl 0xc011e485,%eax
c01019e0:	83 c8 60             	or     $0x60,%eax
c01019e3:	a2 85 e4 11 c0       	mov    %al,0xc011e485
c01019e8:	0f b6 05 85 e4 11 c0 	movzbl 0xc011e485,%eax
c01019ef:	83 c8 80             	or     $0xffffff80,%eax
c01019f2:	a2 85 e4 11 c0       	mov    %al,0xc011e485
c01019f7:	a1 e0 d7 11 c0       	mov    0xc011d7e0,%eax
c01019fc:	c1 e8 10             	shr    $0x10,%eax
c01019ff:	66 a3 86 e4 11 c0    	mov    %ax,0xc011e486
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], 3);        
c0101a05:	a1 e4 d7 11 c0       	mov    0xc011d7e4,%eax
c0101a0a:	66 a3 88 e4 11 c0    	mov    %ax,0xc011e488
c0101a10:	66 c7 05 8a e4 11 c0 	movw   $0x8,0xc011e48a
c0101a17:	08 00 
c0101a19:	0f b6 05 8c e4 11 c0 	movzbl 0xc011e48c,%eax
c0101a20:	83 e0 e0             	and    $0xffffffe0,%eax
c0101a23:	a2 8c e4 11 c0       	mov    %al,0xc011e48c
c0101a28:	0f b6 05 8c e4 11 c0 	movzbl 0xc011e48c,%eax
c0101a2f:	83 e0 1f             	and    $0x1f,%eax
c0101a32:	a2 8c e4 11 c0       	mov    %al,0xc011e48c
c0101a37:	0f b6 05 8d e4 11 c0 	movzbl 0xc011e48d,%eax
c0101a3e:	83 e0 f0             	and    $0xfffffff0,%eax
c0101a41:	83 c8 0e             	or     $0xe,%eax
c0101a44:	a2 8d e4 11 c0       	mov    %al,0xc011e48d
c0101a49:	0f b6 05 8d e4 11 c0 	movzbl 0xc011e48d,%eax
c0101a50:	83 e0 ef             	and    $0xffffffef,%eax
c0101a53:	a2 8d e4 11 c0       	mov    %al,0xc011e48d
c0101a58:	0f b6 05 8d e4 11 c0 	movzbl 0xc011e48d,%eax
c0101a5f:	83 c8 60             	or     $0x60,%eax
c0101a62:	a2 8d e4 11 c0       	mov    %al,0xc011e48d
c0101a67:	0f b6 05 8d e4 11 c0 	movzbl 0xc011e48d,%eax
c0101a6e:	83 c8 80             	or     $0xffffff80,%eax
c0101a71:	a2 8d e4 11 c0       	mov    %al,0xc011e48d
c0101a76:	a1 e4 d7 11 c0       	mov    0xc011d7e4,%eax
c0101a7b:	c1 e8 10             	shr    $0x10,%eax
c0101a7e:	66 a3 8e e4 11 c0    	mov    %ax,0xc011e48e
c0101a84:	c7 45 f4 80 d5 11 c0 	movl   $0xc011d580,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a8e:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c0101a91:	c9                   	leave  
c0101a92:	c3                   	ret    

c0101a93 <trapname>:

static const char *
trapname(int trapno) {
c0101a93:	55                   	push   %ebp
c0101a94:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a99:	83 f8 13             	cmp    $0x13,%eax
c0101a9c:	77 0c                	ja     c0101aaa <trapname+0x17>
        return excnames[trapno];
c0101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa1:	8b 04 85 e0 a4 10 c0 	mov    -0x3fef5b20(,%eax,4),%eax
c0101aa8:	eb 18                	jmp    c0101ac2 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101aaa:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101aae:	7e 0d                	jle    c0101abd <trapname+0x2a>
c0101ab0:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101ab4:	7f 07                	jg     c0101abd <trapname+0x2a>
        return "Hardware Interrupt";
c0101ab6:	b8 8a a1 10 c0       	mov    $0xc010a18a,%eax
c0101abb:	eb 05                	jmp    c0101ac2 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101abd:	b8 9d a1 10 c0       	mov    $0xc010a19d,%eax
}
c0101ac2:	5d                   	pop    %ebp
c0101ac3:	c3                   	ret    

c0101ac4 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101ac4:	55                   	push   %ebp
c0101ac5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aca:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ace:	66 83 f8 08          	cmp    $0x8,%ax
c0101ad2:	0f 94 c0             	sete   %al
c0101ad5:	0f b6 c0             	movzbl %al,%eax
}
c0101ad8:	5d                   	pop    %ebp
c0101ad9:	c3                   	ret    

c0101ada <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101ada:	55                   	push   %ebp
c0101adb:	89 e5                	mov    %esp,%ebp
c0101add:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae7:	c7 04 24 de a1 10 c0 	movl   $0xc010a1de,(%esp)
c0101aee:	e8 9e e7 ff ff       	call   c0100291 <cprintf>
    print_regs(&tf->tf_regs);
c0101af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af6:	89 04 24             	mov    %eax,(%esp)
c0101af9:	e8 a1 01 00 00       	call   c0101c9f <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101afe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b01:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b05:	0f b7 c0             	movzwl %ax,%eax
c0101b08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0c:	c7 04 24 ef a1 10 c0 	movl   $0xc010a1ef,(%esp)
c0101b13:	e8 79 e7 ff ff       	call   c0100291 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b1f:	0f b7 c0             	movzwl %ax,%eax
c0101b22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b26:	c7 04 24 02 a2 10 c0 	movl   $0xc010a202,(%esp)
c0101b2d:	e8 5f e7 ff ff       	call   c0100291 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b35:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b39:	0f b7 c0             	movzwl %ax,%eax
c0101b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b40:	c7 04 24 15 a2 10 c0 	movl   $0xc010a215,(%esp)
c0101b47:	e8 45 e7 ff ff       	call   c0100291 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b53:	0f b7 c0             	movzwl %ax,%eax
c0101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5a:	c7 04 24 28 a2 10 c0 	movl   $0xc010a228,(%esp)
c0101b61:	e8 2b e7 ff ff       	call   c0100291 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b69:	8b 40 30             	mov    0x30(%eax),%eax
c0101b6c:	89 04 24             	mov    %eax,(%esp)
c0101b6f:	e8 1f ff ff ff       	call   c0101a93 <trapname>
c0101b74:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b77:	8b 52 30             	mov    0x30(%edx),%edx
c0101b7a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b7e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b82:	c7 04 24 3b a2 10 c0 	movl   $0xc010a23b,(%esp)
c0101b89:	e8 03 e7 ff ff       	call   c0100291 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b91:	8b 40 34             	mov    0x34(%eax),%eax
c0101b94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b98:	c7 04 24 4d a2 10 c0 	movl   $0xc010a24d,(%esp)
c0101b9f:	e8 ed e6 ff ff       	call   c0100291 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba7:	8b 40 38             	mov    0x38(%eax),%eax
c0101baa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bae:	c7 04 24 5c a2 10 c0 	movl   $0xc010a25c,(%esp)
c0101bb5:	e8 d7 e6 ff ff       	call   c0100291 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bc1:	0f b7 c0             	movzwl %ax,%eax
c0101bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc8:	c7 04 24 6b a2 10 c0 	movl   $0xc010a26b,(%esp)
c0101bcf:	e8 bd e6 ff ff       	call   c0100291 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd7:	8b 40 40             	mov    0x40(%eax),%eax
c0101bda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bde:	c7 04 24 7e a2 10 c0 	movl   $0xc010a27e,(%esp)
c0101be5:	e8 a7 e6 ff ff       	call   c0100291 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101bf1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101bf8:	eb 3e                	jmp    c0101c38 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfd:	8b 50 40             	mov    0x40(%eax),%edx
c0101c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c03:	21 d0                	and    %edx,%eax
c0101c05:	85 c0                	test   %eax,%eax
c0101c07:	74 28                	je     c0101c31 <print_trapframe+0x157>
c0101c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c0c:	8b 04 85 a0 d5 11 c0 	mov    -0x3fee2a60(,%eax,4),%eax
c0101c13:	85 c0                	test   %eax,%eax
c0101c15:	74 1a                	je     c0101c31 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c1a:	8b 04 85 a0 d5 11 c0 	mov    -0x3fee2a60(,%eax,4),%eax
c0101c21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c25:	c7 04 24 8d a2 10 c0 	movl   $0xc010a28d,(%esp)
c0101c2c:	e8 60 e6 ff ff       	call   c0100291 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c31:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c35:	d1 65 f0             	shll   -0x10(%ebp)
c0101c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c3b:	83 f8 17             	cmp    $0x17,%eax
c0101c3e:	76 ba                	jbe    c0101bfa <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c43:	8b 40 40             	mov    0x40(%eax),%eax
c0101c46:	25 00 30 00 00       	and    $0x3000,%eax
c0101c4b:	c1 e8 0c             	shr    $0xc,%eax
c0101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c52:	c7 04 24 91 a2 10 c0 	movl   $0xc010a291,(%esp)
c0101c59:	e8 33 e6 ff ff       	call   c0100291 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c61:	89 04 24             	mov    %eax,(%esp)
c0101c64:	e8 5b fe ff ff       	call   c0101ac4 <trap_in_kernel>
c0101c69:	85 c0                	test   %eax,%eax
c0101c6b:	75 30                	jne    c0101c9d <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c70:	8b 40 44             	mov    0x44(%eax),%eax
c0101c73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c77:	c7 04 24 9a a2 10 c0 	movl   $0xc010a29a,(%esp)
c0101c7e:	e8 0e e6 ff ff       	call   c0100291 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c86:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c8a:	0f b7 c0             	movzwl %ax,%eax
c0101c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c91:	c7 04 24 a9 a2 10 c0 	movl   $0xc010a2a9,(%esp)
c0101c98:	e8 f4 e5 ff ff       	call   c0100291 <cprintf>
    }
}
c0101c9d:	c9                   	leave  
c0101c9e:	c3                   	ret    

c0101c9f <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c9f:	55                   	push   %ebp
c0101ca0:	89 e5                	mov    %esp,%ebp
c0101ca2:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca8:	8b 00                	mov    (%eax),%eax
c0101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cae:	c7 04 24 bc a2 10 c0 	movl   $0xc010a2bc,(%esp)
c0101cb5:	e8 d7 e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbd:	8b 40 04             	mov    0x4(%eax),%eax
c0101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc4:	c7 04 24 cb a2 10 c0 	movl   $0xc010a2cb,(%esp)
c0101ccb:	e8 c1 e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd3:	8b 40 08             	mov    0x8(%eax),%eax
c0101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cda:	c7 04 24 da a2 10 c0 	movl   $0xc010a2da,(%esp)
c0101ce1:	e8 ab e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce9:	8b 40 0c             	mov    0xc(%eax),%eax
c0101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf0:	c7 04 24 e9 a2 10 c0 	movl   $0xc010a2e9,(%esp)
c0101cf7:	e8 95 e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cff:	8b 40 10             	mov    0x10(%eax),%eax
c0101d02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d06:	c7 04 24 f8 a2 10 c0 	movl   $0xc010a2f8,(%esp)
c0101d0d:	e8 7f e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d15:	8b 40 14             	mov    0x14(%eax),%eax
c0101d18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d1c:	c7 04 24 07 a3 10 c0 	movl   $0xc010a307,(%esp)
c0101d23:	e8 69 e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d2b:	8b 40 18             	mov    0x18(%eax),%eax
c0101d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d32:	c7 04 24 16 a3 10 c0 	movl   $0xc010a316,(%esp)
c0101d39:	e8 53 e5 ff ff       	call   c0100291 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d41:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d48:	c7 04 24 25 a3 10 c0 	movl   $0xc010a325,(%esp)
c0101d4f:	e8 3d e5 ff ff       	call   c0100291 <cprintf>
}
c0101d54:	c9                   	leave  
c0101d55:	c3                   	ret    

c0101d56 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d56:	55                   	push   %ebp
c0101d57:	89 e5                	mov    %esp,%ebp
c0101d59:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d5f:	8b 40 30             	mov    0x30(%eax),%eax
c0101d62:	83 f8 2f             	cmp    $0x2f,%eax
c0101d65:	77 1d                	ja     c0101d84 <trap_dispatch+0x2e>
c0101d67:	83 f8 2e             	cmp    $0x2e,%eax
c0101d6a:	0f 83 91 01 00 00    	jae    c0101f01 <trap_dispatch+0x1ab>
c0101d70:	83 f8 21             	cmp    $0x21,%eax
c0101d73:	74 7f                	je     c0101df4 <trap_dispatch+0x9e>
c0101d75:	83 f8 24             	cmp    $0x24,%eax
c0101d78:	74 51                	je     c0101dcb <trap_dispatch+0x75>
c0101d7a:	83 f8 20             	cmp    $0x20,%eax
c0101d7d:	74 1c                	je     c0101d9b <trap_dispatch+0x45>
c0101d7f:	e9 45 01 00 00       	jmp    c0101ec9 <trap_dispatch+0x173>
c0101d84:	83 f8 78             	cmp    $0x78,%eax
c0101d87:	0f 84 90 00 00 00    	je     c0101e1d <trap_dispatch+0xc7>
c0101d8d:	83 f8 79             	cmp    $0x79,%eax
c0101d90:	0f 84 e7 00 00 00    	je     c0101e7d <trap_dispatch+0x127>
c0101d96:	e9 2e 01 00 00       	jmp    c0101ec9 <trap_dispatch+0x173>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */

	ticks++;
c0101d9b:	a1 68 e9 11 c0       	mov    0xc011e968,%eax
c0101da0:	83 c0 01             	add    $0x1,%eax
c0101da3:	a3 68 e9 11 c0       	mov    %eax,0xc011e968
	if(ticks==TICK_NUM)
c0101da8:	a1 68 e9 11 c0       	mov    0xc011e968,%eax
c0101dad:	83 f8 64             	cmp    $0x64,%eax
c0101db0:	75 14                	jne    c0101dc6 <trap_dispatch+0x70>
	{
		ticks=0;
c0101db2:	c7 05 68 e9 11 c0 00 	movl   $0x0,0xc011e968
c0101db9:	00 00 00 
		print_ticks();
c0101dbc:	e8 c1 fa ff ff       	call   c0101882 <print_ticks>
	}		
        break;
c0101dc1:	e9 3c 01 00 00       	jmp    c0101f02 <trap_dispatch+0x1ac>
c0101dc6:	e9 37 01 00 00       	jmp    c0101f02 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101dcb:	e8 76 f8 ff ff       	call   c0101646 <cons_getc>
c0101dd0:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101dd3:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101dd7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ddb:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ddf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101de3:	c7 04 24 34 a3 10 c0 	movl   $0xc010a334,(%esp)
c0101dea:	e8 a2 e4 ff ff       	call   c0100291 <cprintf>
        break;
c0101def:	e9 0e 01 00 00       	jmp    c0101f02 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101df4:	e8 4d f8 ff ff       	call   c0101646 <cons_getc>
c0101df9:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101dfc:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e00:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e04:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e0c:	c7 04 24 46 a3 10 c0 	movl   $0xc010a346,(%esp)
c0101e13:	e8 79 e4 ff ff       	call   c0100291 <cprintf>
        break;
c0101e18:	e9 e5 00 00 00       	jmp    c0101f02 <trap_dispatch+0x1ac>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
	tf->tf_eflags |= FL_IOPL_MASK;
c0101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e20:	8b 40 40             	mov    0x40(%eax),%eax
c0101e23:	80 cc 30             	or     $0x30,%ah
c0101e26:	89 c2                	mov    %eax,%edx
c0101e28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e2b:	89 50 40             	mov    %edx,0x40(%eax)
	tf->tf_cs = USER_CS;
c0101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e31:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = USER_DS;
c0101e37:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e3a:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
c0101e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e43:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0101e47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4a:	66 89 50 48          	mov    %dx,0x48(%eax)
c0101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e51:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101e55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e58:	66 89 50 20          	mov    %dx,0x20(%eax)
c0101e5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5f:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c0101e63:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e66:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101e6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e6d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e74:	66 89 50 2c          	mov    %dx,0x2c(%eax)
	break;
c0101e78:	e9 85 00 00 00       	jmp    c0101f02 <trap_dispatch+0x1ac>
    case T_SWITCH_TOK:
	tf->tf_cs = KERNEL_CS;
c0101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e80:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
c0101e86:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e89:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
c0101e8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e92:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0101e96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e99:	66 89 50 48          	mov    %dx,0x48(%eax)
c0101e9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea0:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101ea4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea7:	66 89 50 20          	mov    %dx,0x20(%eax)
c0101eab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eae:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c0101eb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb5:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ebc:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101ec0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec3:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        break;
c0101ec7:	eb 39                	jmp    c0101f02 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101ec9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ecc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ed0:	0f b7 c0             	movzwl %ax,%eax
c0101ed3:	83 e0 03             	and    $0x3,%eax
c0101ed6:	85 c0                	test   %eax,%eax
c0101ed8:	75 28                	jne    c0101f02 <trap_dispatch+0x1ac>
            print_trapframe(tf);
c0101eda:	8b 45 08             	mov    0x8(%ebp),%eax
c0101edd:	89 04 24             	mov    %eax,(%esp)
c0101ee0:	e8 f5 fb ff ff       	call   c0101ada <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101ee5:	c7 44 24 08 55 a3 10 	movl   $0xc010a355,0x8(%esp)
c0101eec:	c0 
c0101eed:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0101ef4:	00 
c0101ef5:	c7 04 24 71 a3 10 c0 	movl   $0xc010a371,(%esp)
c0101efc:	e8 e7 e4 ff ff       	call   c01003e8 <__panic>
        break;
c0101f01:	90                   	nop
        }
    }
}
c0101f02:	c9                   	leave  
c0101f03:	c3                   	ret    

c0101f04 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101f04:	55                   	push   %ebp
c0101f05:	89 e5                	mov    %esp,%ebp
c0101f07:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f0d:	89 04 24             	mov    %eax,(%esp)
c0101f10:	e8 41 fe ff ff       	call   c0101d56 <trap_dispatch>
}
c0101f15:	c9                   	leave  
c0101f16:	c3                   	ret    

c0101f17 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f17:	6a 00                	push   $0x0
  pushl $0
c0101f19:	6a 00                	push   $0x0
  jmp __alltraps
c0101f1b:	e9 67 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f20 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f20:	6a 00                	push   $0x0
  pushl $1
c0101f22:	6a 01                	push   $0x1
  jmp __alltraps
c0101f24:	e9 5e 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f29 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f29:	6a 00                	push   $0x0
  pushl $2
c0101f2b:	6a 02                	push   $0x2
  jmp __alltraps
c0101f2d:	e9 55 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f32 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f32:	6a 00                	push   $0x0
  pushl $3
c0101f34:	6a 03                	push   $0x3
  jmp __alltraps
c0101f36:	e9 4c 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f3b <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f3b:	6a 00                	push   $0x0
  pushl $4
c0101f3d:	6a 04                	push   $0x4
  jmp __alltraps
c0101f3f:	e9 43 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f44 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f44:	6a 00                	push   $0x0
  pushl $5
c0101f46:	6a 05                	push   $0x5
  jmp __alltraps
c0101f48:	e9 3a 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f4d <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f4d:	6a 00                	push   $0x0
  pushl $6
c0101f4f:	6a 06                	push   $0x6
  jmp __alltraps
c0101f51:	e9 31 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f56 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f56:	6a 00                	push   $0x0
  pushl $7
c0101f58:	6a 07                	push   $0x7
  jmp __alltraps
c0101f5a:	e9 28 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f5f <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f5f:	6a 08                	push   $0x8
  jmp __alltraps
c0101f61:	e9 21 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f66 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101f66:	6a 09                	push   $0x9
  jmp __alltraps
c0101f68:	e9 1a 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f6d <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f6d:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f6f:	e9 13 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f74 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f74:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f76:	e9 0c 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f7b <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f7b:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f7d:	e9 05 0a 00 00       	jmp    c0102987 <__alltraps>

c0101f82 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f82:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f84:	e9 fe 09 00 00       	jmp    c0102987 <__alltraps>

c0101f89 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f89:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f8b:	e9 f7 09 00 00       	jmp    c0102987 <__alltraps>

c0101f90 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f90:	6a 00                	push   $0x0
  pushl $15
c0101f92:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f94:	e9 ee 09 00 00       	jmp    c0102987 <__alltraps>

c0101f99 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f99:	6a 00                	push   $0x0
  pushl $16
c0101f9b:	6a 10                	push   $0x10
  jmp __alltraps
c0101f9d:	e9 e5 09 00 00       	jmp    c0102987 <__alltraps>

c0101fa2 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101fa2:	6a 11                	push   $0x11
  jmp __alltraps
c0101fa4:	e9 de 09 00 00       	jmp    c0102987 <__alltraps>

c0101fa9 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $18
c0101fab:	6a 12                	push   $0x12
  jmp __alltraps
c0101fad:	e9 d5 09 00 00       	jmp    c0102987 <__alltraps>

c0101fb2 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101fb2:	6a 00                	push   $0x0
  pushl $19
c0101fb4:	6a 13                	push   $0x13
  jmp __alltraps
c0101fb6:	e9 cc 09 00 00       	jmp    c0102987 <__alltraps>

c0101fbb <vector20>:
.globl vector20
vector20:
  pushl $0
c0101fbb:	6a 00                	push   $0x0
  pushl $20
c0101fbd:	6a 14                	push   $0x14
  jmp __alltraps
c0101fbf:	e9 c3 09 00 00       	jmp    c0102987 <__alltraps>

c0101fc4 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101fc4:	6a 00                	push   $0x0
  pushl $21
c0101fc6:	6a 15                	push   $0x15
  jmp __alltraps
c0101fc8:	e9 ba 09 00 00       	jmp    c0102987 <__alltraps>

c0101fcd <vector22>:
.globl vector22
vector22:
  pushl $0
c0101fcd:	6a 00                	push   $0x0
  pushl $22
c0101fcf:	6a 16                	push   $0x16
  jmp __alltraps
c0101fd1:	e9 b1 09 00 00       	jmp    c0102987 <__alltraps>

c0101fd6 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101fd6:	6a 00                	push   $0x0
  pushl $23
c0101fd8:	6a 17                	push   $0x17
  jmp __alltraps
c0101fda:	e9 a8 09 00 00       	jmp    c0102987 <__alltraps>

c0101fdf <vector24>:
.globl vector24
vector24:
  pushl $0
c0101fdf:	6a 00                	push   $0x0
  pushl $24
c0101fe1:	6a 18                	push   $0x18
  jmp __alltraps
c0101fe3:	e9 9f 09 00 00       	jmp    c0102987 <__alltraps>

c0101fe8 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101fe8:	6a 00                	push   $0x0
  pushl $25
c0101fea:	6a 19                	push   $0x19
  jmp __alltraps
c0101fec:	e9 96 09 00 00       	jmp    c0102987 <__alltraps>

c0101ff1 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ff1:	6a 00                	push   $0x0
  pushl $26
c0101ff3:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ff5:	e9 8d 09 00 00       	jmp    c0102987 <__alltraps>

c0101ffa <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ffa:	6a 00                	push   $0x0
  pushl $27
c0101ffc:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101ffe:	e9 84 09 00 00       	jmp    c0102987 <__alltraps>

c0102003 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102003:	6a 00                	push   $0x0
  pushl $28
c0102005:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102007:	e9 7b 09 00 00       	jmp    c0102987 <__alltraps>

c010200c <vector29>:
.globl vector29
vector29:
  pushl $0
c010200c:	6a 00                	push   $0x0
  pushl $29
c010200e:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102010:	e9 72 09 00 00       	jmp    c0102987 <__alltraps>

c0102015 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102015:	6a 00                	push   $0x0
  pushl $30
c0102017:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102019:	e9 69 09 00 00       	jmp    c0102987 <__alltraps>

c010201e <vector31>:
.globl vector31
vector31:
  pushl $0
c010201e:	6a 00                	push   $0x0
  pushl $31
c0102020:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102022:	e9 60 09 00 00       	jmp    c0102987 <__alltraps>

c0102027 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102027:	6a 00                	push   $0x0
  pushl $32
c0102029:	6a 20                	push   $0x20
  jmp __alltraps
c010202b:	e9 57 09 00 00       	jmp    c0102987 <__alltraps>

c0102030 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102030:	6a 00                	push   $0x0
  pushl $33
c0102032:	6a 21                	push   $0x21
  jmp __alltraps
c0102034:	e9 4e 09 00 00       	jmp    c0102987 <__alltraps>

c0102039 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102039:	6a 00                	push   $0x0
  pushl $34
c010203b:	6a 22                	push   $0x22
  jmp __alltraps
c010203d:	e9 45 09 00 00       	jmp    c0102987 <__alltraps>

c0102042 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102042:	6a 00                	push   $0x0
  pushl $35
c0102044:	6a 23                	push   $0x23
  jmp __alltraps
c0102046:	e9 3c 09 00 00       	jmp    c0102987 <__alltraps>

c010204b <vector36>:
.globl vector36
vector36:
  pushl $0
c010204b:	6a 00                	push   $0x0
  pushl $36
c010204d:	6a 24                	push   $0x24
  jmp __alltraps
c010204f:	e9 33 09 00 00       	jmp    c0102987 <__alltraps>

c0102054 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102054:	6a 00                	push   $0x0
  pushl $37
c0102056:	6a 25                	push   $0x25
  jmp __alltraps
c0102058:	e9 2a 09 00 00       	jmp    c0102987 <__alltraps>

c010205d <vector38>:
.globl vector38
vector38:
  pushl $0
c010205d:	6a 00                	push   $0x0
  pushl $38
c010205f:	6a 26                	push   $0x26
  jmp __alltraps
c0102061:	e9 21 09 00 00       	jmp    c0102987 <__alltraps>

c0102066 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $39
c0102068:	6a 27                	push   $0x27
  jmp __alltraps
c010206a:	e9 18 09 00 00       	jmp    c0102987 <__alltraps>

c010206f <vector40>:
.globl vector40
vector40:
  pushl $0
c010206f:	6a 00                	push   $0x0
  pushl $40
c0102071:	6a 28                	push   $0x28
  jmp __alltraps
c0102073:	e9 0f 09 00 00       	jmp    c0102987 <__alltraps>

c0102078 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102078:	6a 00                	push   $0x0
  pushl $41
c010207a:	6a 29                	push   $0x29
  jmp __alltraps
c010207c:	e9 06 09 00 00       	jmp    c0102987 <__alltraps>

c0102081 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102081:	6a 00                	push   $0x0
  pushl $42
c0102083:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102085:	e9 fd 08 00 00       	jmp    c0102987 <__alltraps>

c010208a <vector43>:
.globl vector43
vector43:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $43
c010208c:	6a 2b                	push   $0x2b
  jmp __alltraps
c010208e:	e9 f4 08 00 00       	jmp    c0102987 <__alltraps>

c0102093 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102093:	6a 00                	push   $0x0
  pushl $44
c0102095:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102097:	e9 eb 08 00 00       	jmp    c0102987 <__alltraps>

c010209c <vector45>:
.globl vector45
vector45:
  pushl $0
c010209c:	6a 00                	push   $0x0
  pushl $45
c010209e:	6a 2d                	push   $0x2d
  jmp __alltraps
c01020a0:	e9 e2 08 00 00       	jmp    c0102987 <__alltraps>

c01020a5 <vector46>:
.globl vector46
vector46:
  pushl $0
c01020a5:	6a 00                	push   $0x0
  pushl $46
c01020a7:	6a 2e                	push   $0x2e
  jmp __alltraps
c01020a9:	e9 d9 08 00 00       	jmp    c0102987 <__alltraps>

c01020ae <vector47>:
.globl vector47
vector47:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $47
c01020b0:	6a 2f                	push   $0x2f
  jmp __alltraps
c01020b2:	e9 d0 08 00 00       	jmp    c0102987 <__alltraps>

c01020b7 <vector48>:
.globl vector48
vector48:
  pushl $0
c01020b7:	6a 00                	push   $0x0
  pushl $48
c01020b9:	6a 30                	push   $0x30
  jmp __alltraps
c01020bb:	e9 c7 08 00 00       	jmp    c0102987 <__alltraps>

c01020c0 <vector49>:
.globl vector49
vector49:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $49
c01020c2:	6a 31                	push   $0x31
  jmp __alltraps
c01020c4:	e9 be 08 00 00       	jmp    c0102987 <__alltraps>

c01020c9 <vector50>:
.globl vector50
vector50:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $50
c01020cb:	6a 32                	push   $0x32
  jmp __alltraps
c01020cd:	e9 b5 08 00 00       	jmp    c0102987 <__alltraps>

c01020d2 <vector51>:
.globl vector51
vector51:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $51
c01020d4:	6a 33                	push   $0x33
  jmp __alltraps
c01020d6:	e9 ac 08 00 00       	jmp    c0102987 <__alltraps>

c01020db <vector52>:
.globl vector52
vector52:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $52
c01020dd:	6a 34                	push   $0x34
  jmp __alltraps
c01020df:	e9 a3 08 00 00       	jmp    c0102987 <__alltraps>

c01020e4 <vector53>:
.globl vector53
vector53:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $53
c01020e6:	6a 35                	push   $0x35
  jmp __alltraps
c01020e8:	e9 9a 08 00 00       	jmp    c0102987 <__alltraps>

c01020ed <vector54>:
.globl vector54
vector54:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $54
c01020ef:	6a 36                	push   $0x36
  jmp __alltraps
c01020f1:	e9 91 08 00 00       	jmp    c0102987 <__alltraps>

c01020f6 <vector55>:
.globl vector55
vector55:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $55
c01020f8:	6a 37                	push   $0x37
  jmp __alltraps
c01020fa:	e9 88 08 00 00       	jmp    c0102987 <__alltraps>

c01020ff <vector56>:
.globl vector56
vector56:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $56
c0102101:	6a 38                	push   $0x38
  jmp __alltraps
c0102103:	e9 7f 08 00 00       	jmp    c0102987 <__alltraps>

c0102108 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102108:	6a 00                	push   $0x0
  pushl $57
c010210a:	6a 39                	push   $0x39
  jmp __alltraps
c010210c:	e9 76 08 00 00       	jmp    c0102987 <__alltraps>

c0102111 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102111:	6a 00                	push   $0x0
  pushl $58
c0102113:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102115:	e9 6d 08 00 00       	jmp    c0102987 <__alltraps>

c010211a <vector59>:
.globl vector59
vector59:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $59
c010211c:	6a 3b                	push   $0x3b
  jmp __alltraps
c010211e:	e9 64 08 00 00       	jmp    c0102987 <__alltraps>

c0102123 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102123:	6a 00                	push   $0x0
  pushl $60
c0102125:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102127:	e9 5b 08 00 00       	jmp    c0102987 <__alltraps>

c010212c <vector61>:
.globl vector61
vector61:
  pushl $0
c010212c:	6a 00                	push   $0x0
  pushl $61
c010212e:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102130:	e9 52 08 00 00       	jmp    c0102987 <__alltraps>

c0102135 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102135:	6a 00                	push   $0x0
  pushl $62
c0102137:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102139:	e9 49 08 00 00       	jmp    c0102987 <__alltraps>

c010213e <vector63>:
.globl vector63
vector63:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $63
c0102140:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102142:	e9 40 08 00 00       	jmp    c0102987 <__alltraps>

c0102147 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $64
c0102149:	6a 40                	push   $0x40
  jmp __alltraps
c010214b:	e9 37 08 00 00       	jmp    c0102987 <__alltraps>

c0102150 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $65
c0102152:	6a 41                	push   $0x41
  jmp __alltraps
c0102154:	e9 2e 08 00 00       	jmp    c0102987 <__alltraps>

c0102159 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $66
c010215b:	6a 42                	push   $0x42
  jmp __alltraps
c010215d:	e9 25 08 00 00       	jmp    c0102987 <__alltraps>

c0102162 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $67
c0102164:	6a 43                	push   $0x43
  jmp __alltraps
c0102166:	e9 1c 08 00 00       	jmp    c0102987 <__alltraps>

c010216b <vector68>:
.globl vector68
vector68:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $68
c010216d:	6a 44                	push   $0x44
  jmp __alltraps
c010216f:	e9 13 08 00 00       	jmp    c0102987 <__alltraps>

c0102174 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $69
c0102176:	6a 45                	push   $0x45
  jmp __alltraps
c0102178:	e9 0a 08 00 00       	jmp    c0102987 <__alltraps>

c010217d <vector70>:
.globl vector70
vector70:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $70
c010217f:	6a 46                	push   $0x46
  jmp __alltraps
c0102181:	e9 01 08 00 00       	jmp    c0102987 <__alltraps>

c0102186 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $71
c0102188:	6a 47                	push   $0x47
  jmp __alltraps
c010218a:	e9 f8 07 00 00       	jmp    c0102987 <__alltraps>

c010218f <vector72>:
.globl vector72
vector72:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $72
c0102191:	6a 48                	push   $0x48
  jmp __alltraps
c0102193:	e9 ef 07 00 00       	jmp    c0102987 <__alltraps>

c0102198 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102198:	6a 00                	push   $0x0
  pushl $73
c010219a:	6a 49                	push   $0x49
  jmp __alltraps
c010219c:	e9 e6 07 00 00       	jmp    c0102987 <__alltraps>

c01021a1 <vector74>:
.globl vector74
vector74:
  pushl $0
c01021a1:	6a 00                	push   $0x0
  pushl $74
c01021a3:	6a 4a                	push   $0x4a
  jmp __alltraps
c01021a5:	e9 dd 07 00 00       	jmp    c0102987 <__alltraps>

c01021aa <vector75>:
.globl vector75
vector75:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $75
c01021ac:	6a 4b                	push   $0x4b
  jmp __alltraps
c01021ae:	e9 d4 07 00 00       	jmp    c0102987 <__alltraps>

c01021b3 <vector76>:
.globl vector76
vector76:
  pushl $0
c01021b3:	6a 00                	push   $0x0
  pushl $76
c01021b5:	6a 4c                	push   $0x4c
  jmp __alltraps
c01021b7:	e9 cb 07 00 00       	jmp    c0102987 <__alltraps>

c01021bc <vector77>:
.globl vector77
vector77:
  pushl $0
c01021bc:	6a 00                	push   $0x0
  pushl $77
c01021be:	6a 4d                	push   $0x4d
  jmp __alltraps
c01021c0:	e9 c2 07 00 00       	jmp    c0102987 <__alltraps>

c01021c5 <vector78>:
.globl vector78
vector78:
  pushl $0
c01021c5:	6a 00                	push   $0x0
  pushl $78
c01021c7:	6a 4e                	push   $0x4e
  jmp __alltraps
c01021c9:	e9 b9 07 00 00       	jmp    c0102987 <__alltraps>

c01021ce <vector79>:
.globl vector79
vector79:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $79
c01021d0:	6a 4f                	push   $0x4f
  jmp __alltraps
c01021d2:	e9 b0 07 00 00       	jmp    c0102987 <__alltraps>

c01021d7 <vector80>:
.globl vector80
vector80:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $80
c01021d9:	6a 50                	push   $0x50
  jmp __alltraps
c01021db:	e9 a7 07 00 00       	jmp    c0102987 <__alltraps>

c01021e0 <vector81>:
.globl vector81
vector81:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $81
c01021e2:	6a 51                	push   $0x51
  jmp __alltraps
c01021e4:	e9 9e 07 00 00       	jmp    c0102987 <__alltraps>

c01021e9 <vector82>:
.globl vector82
vector82:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $82
c01021eb:	6a 52                	push   $0x52
  jmp __alltraps
c01021ed:	e9 95 07 00 00       	jmp    c0102987 <__alltraps>

c01021f2 <vector83>:
.globl vector83
vector83:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $83
c01021f4:	6a 53                	push   $0x53
  jmp __alltraps
c01021f6:	e9 8c 07 00 00       	jmp    c0102987 <__alltraps>

c01021fb <vector84>:
.globl vector84
vector84:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $84
c01021fd:	6a 54                	push   $0x54
  jmp __alltraps
c01021ff:	e9 83 07 00 00       	jmp    c0102987 <__alltraps>

c0102204 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $85
c0102206:	6a 55                	push   $0x55
  jmp __alltraps
c0102208:	e9 7a 07 00 00       	jmp    c0102987 <__alltraps>

c010220d <vector86>:
.globl vector86
vector86:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $86
c010220f:	6a 56                	push   $0x56
  jmp __alltraps
c0102211:	e9 71 07 00 00       	jmp    c0102987 <__alltraps>

c0102216 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102216:	6a 00                	push   $0x0
  pushl $87
c0102218:	6a 57                	push   $0x57
  jmp __alltraps
c010221a:	e9 68 07 00 00       	jmp    c0102987 <__alltraps>

c010221f <vector88>:
.globl vector88
vector88:
  pushl $0
c010221f:	6a 00                	push   $0x0
  pushl $88
c0102221:	6a 58                	push   $0x58
  jmp __alltraps
c0102223:	e9 5f 07 00 00       	jmp    c0102987 <__alltraps>

c0102228 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102228:	6a 00                	push   $0x0
  pushl $89
c010222a:	6a 59                	push   $0x59
  jmp __alltraps
c010222c:	e9 56 07 00 00       	jmp    c0102987 <__alltraps>

c0102231 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $90
c0102233:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102235:	e9 4d 07 00 00       	jmp    c0102987 <__alltraps>

c010223a <vector91>:
.globl vector91
vector91:
  pushl $0
c010223a:	6a 00                	push   $0x0
  pushl $91
c010223c:	6a 5b                	push   $0x5b
  jmp __alltraps
c010223e:	e9 44 07 00 00       	jmp    c0102987 <__alltraps>

c0102243 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102243:	6a 00                	push   $0x0
  pushl $92
c0102245:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102247:	e9 3b 07 00 00       	jmp    c0102987 <__alltraps>

c010224c <vector93>:
.globl vector93
vector93:
  pushl $0
c010224c:	6a 00                	push   $0x0
  pushl $93
c010224e:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102250:	e9 32 07 00 00       	jmp    c0102987 <__alltraps>

c0102255 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $94
c0102257:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102259:	e9 29 07 00 00       	jmp    c0102987 <__alltraps>

c010225e <vector95>:
.globl vector95
vector95:
  pushl $0
c010225e:	6a 00                	push   $0x0
  pushl $95
c0102260:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102262:	e9 20 07 00 00       	jmp    c0102987 <__alltraps>

c0102267 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102267:	6a 00                	push   $0x0
  pushl $96
c0102269:	6a 60                	push   $0x60
  jmp __alltraps
c010226b:	e9 17 07 00 00       	jmp    c0102987 <__alltraps>

c0102270 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102270:	6a 00                	push   $0x0
  pushl $97
c0102272:	6a 61                	push   $0x61
  jmp __alltraps
c0102274:	e9 0e 07 00 00       	jmp    c0102987 <__alltraps>

c0102279 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $98
c010227b:	6a 62                	push   $0x62
  jmp __alltraps
c010227d:	e9 05 07 00 00       	jmp    c0102987 <__alltraps>

c0102282 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102282:	6a 00                	push   $0x0
  pushl $99
c0102284:	6a 63                	push   $0x63
  jmp __alltraps
c0102286:	e9 fc 06 00 00       	jmp    c0102987 <__alltraps>

c010228b <vector100>:
.globl vector100
vector100:
  pushl $0
c010228b:	6a 00                	push   $0x0
  pushl $100
c010228d:	6a 64                	push   $0x64
  jmp __alltraps
c010228f:	e9 f3 06 00 00       	jmp    c0102987 <__alltraps>

c0102294 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $101
c0102296:	6a 65                	push   $0x65
  jmp __alltraps
c0102298:	e9 ea 06 00 00       	jmp    c0102987 <__alltraps>

c010229d <vector102>:
.globl vector102
vector102:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $102
c010229f:	6a 66                	push   $0x66
  jmp __alltraps
c01022a1:	e9 e1 06 00 00       	jmp    c0102987 <__alltraps>

c01022a6 <vector103>:
.globl vector103
vector103:
  pushl $0
c01022a6:	6a 00                	push   $0x0
  pushl $103
c01022a8:	6a 67                	push   $0x67
  jmp __alltraps
c01022aa:	e9 d8 06 00 00       	jmp    c0102987 <__alltraps>

c01022af <vector104>:
.globl vector104
vector104:
  pushl $0
c01022af:	6a 00                	push   $0x0
  pushl $104
c01022b1:	6a 68                	push   $0x68
  jmp __alltraps
c01022b3:	e9 cf 06 00 00       	jmp    c0102987 <__alltraps>

c01022b8 <vector105>:
.globl vector105
vector105:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $105
c01022ba:	6a 69                	push   $0x69
  jmp __alltraps
c01022bc:	e9 c6 06 00 00       	jmp    c0102987 <__alltraps>

c01022c1 <vector106>:
.globl vector106
vector106:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $106
c01022c3:	6a 6a                	push   $0x6a
  jmp __alltraps
c01022c5:	e9 bd 06 00 00       	jmp    c0102987 <__alltraps>

c01022ca <vector107>:
.globl vector107
vector107:
  pushl $0
c01022ca:	6a 00                	push   $0x0
  pushl $107
c01022cc:	6a 6b                	push   $0x6b
  jmp __alltraps
c01022ce:	e9 b4 06 00 00       	jmp    c0102987 <__alltraps>

c01022d3 <vector108>:
.globl vector108
vector108:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $108
c01022d5:	6a 6c                	push   $0x6c
  jmp __alltraps
c01022d7:	e9 ab 06 00 00       	jmp    c0102987 <__alltraps>

c01022dc <vector109>:
.globl vector109
vector109:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $109
c01022de:	6a 6d                	push   $0x6d
  jmp __alltraps
c01022e0:	e9 a2 06 00 00       	jmp    c0102987 <__alltraps>

c01022e5 <vector110>:
.globl vector110
vector110:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $110
c01022e7:	6a 6e                	push   $0x6e
  jmp __alltraps
c01022e9:	e9 99 06 00 00       	jmp    c0102987 <__alltraps>

c01022ee <vector111>:
.globl vector111
vector111:
  pushl $0
c01022ee:	6a 00                	push   $0x0
  pushl $111
c01022f0:	6a 6f                	push   $0x6f
  jmp __alltraps
c01022f2:	e9 90 06 00 00       	jmp    c0102987 <__alltraps>

c01022f7 <vector112>:
.globl vector112
vector112:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $112
c01022f9:	6a 70                	push   $0x70
  jmp __alltraps
c01022fb:	e9 87 06 00 00       	jmp    c0102987 <__alltraps>

c0102300 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $113
c0102302:	6a 71                	push   $0x71
  jmp __alltraps
c0102304:	e9 7e 06 00 00       	jmp    c0102987 <__alltraps>

c0102309 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $114
c010230b:	6a 72                	push   $0x72
  jmp __alltraps
c010230d:	e9 75 06 00 00       	jmp    c0102987 <__alltraps>

c0102312 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102312:	6a 00                	push   $0x0
  pushl $115
c0102314:	6a 73                	push   $0x73
  jmp __alltraps
c0102316:	e9 6c 06 00 00       	jmp    c0102987 <__alltraps>

c010231b <vector116>:
.globl vector116
vector116:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $116
c010231d:	6a 74                	push   $0x74
  jmp __alltraps
c010231f:	e9 63 06 00 00       	jmp    c0102987 <__alltraps>

c0102324 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $117
c0102326:	6a 75                	push   $0x75
  jmp __alltraps
c0102328:	e9 5a 06 00 00       	jmp    c0102987 <__alltraps>

c010232d <vector118>:
.globl vector118
vector118:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $118
c010232f:	6a 76                	push   $0x76
  jmp __alltraps
c0102331:	e9 51 06 00 00       	jmp    c0102987 <__alltraps>

c0102336 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102336:	6a 00                	push   $0x0
  pushl $119
c0102338:	6a 77                	push   $0x77
  jmp __alltraps
c010233a:	e9 48 06 00 00       	jmp    c0102987 <__alltraps>

c010233f <vector120>:
.globl vector120
vector120:
  pushl $0
c010233f:	6a 00                	push   $0x0
  pushl $120
c0102341:	6a 78                	push   $0x78
  jmp __alltraps
c0102343:	e9 3f 06 00 00       	jmp    c0102987 <__alltraps>

c0102348 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $121
c010234a:	6a 79                	push   $0x79
  jmp __alltraps
c010234c:	e9 36 06 00 00       	jmp    c0102987 <__alltraps>

c0102351 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $122
c0102353:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102355:	e9 2d 06 00 00       	jmp    c0102987 <__alltraps>

c010235a <vector123>:
.globl vector123
vector123:
  pushl $0
c010235a:	6a 00                	push   $0x0
  pushl $123
c010235c:	6a 7b                	push   $0x7b
  jmp __alltraps
c010235e:	e9 24 06 00 00       	jmp    c0102987 <__alltraps>

c0102363 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102363:	6a 00                	push   $0x0
  pushl $124
c0102365:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102367:	e9 1b 06 00 00       	jmp    c0102987 <__alltraps>

c010236c <vector125>:
.globl vector125
vector125:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $125
c010236e:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102370:	e9 12 06 00 00       	jmp    c0102987 <__alltraps>

c0102375 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $126
c0102377:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102379:	e9 09 06 00 00       	jmp    c0102987 <__alltraps>

c010237e <vector127>:
.globl vector127
vector127:
  pushl $0
c010237e:	6a 00                	push   $0x0
  pushl $127
c0102380:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102382:	e9 00 06 00 00       	jmp    c0102987 <__alltraps>

c0102387 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102387:	6a 00                	push   $0x0
  pushl $128
c0102389:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010238e:	e9 f4 05 00 00       	jmp    c0102987 <__alltraps>

c0102393 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102393:	6a 00                	push   $0x0
  pushl $129
c0102395:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010239a:	e9 e8 05 00 00       	jmp    c0102987 <__alltraps>

c010239f <vector130>:
.globl vector130
vector130:
  pushl $0
c010239f:	6a 00                	push   $0x0
  pushl $130
c01023a1:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01023a6:	e9 dc 05 00 00       	jmp    c0102987 <__alltraps>

c01023ab <vector131>:
.globl vector131
vector131:
  pushl $0
c01023ab:	6a 00                	push   $0x0
  pushl $131
c01023ad:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01023b2:	e9 d0 05 00 00       	jmp    c0102987 <__alltraps>

c01023b7 <vector132>:
.globl vector132
vector132:
  pushl $0
c01023b7:	6a 00                	push   $0x0
  pushl $132
c01023b9:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01023be:	e9 c4 05 00 00       	jmp    c0102987 <__alltraps>

c01023c3 <vector133>:
.globl vector133
vector133:
  pushl $0
c01023c3:	6a 00                	push   $0x0
  pushl $133
c01023c5:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01023ca:	e9 b8 05 00 00       	jmp    c0102987 <__alltraps>

c01023cf <vector134>:
.globl vector134
vector134:
  pushl $0
c01023cf:	6a 00                	push   $0x0
  pushl $134
c01023d1:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01023d6:	e9 ac 05 00 00       	jmp    c0102987 <__alltraps>

c01023db <vector135>:
.globl vector135
vector135:
  pushl $0
c01023db:	6a 00                	push   $0x0
  pushl $135
c01023dd:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01023e2:	e9 a0 05 00 00       	jmp    c0102987 <__alltraps>

c01023e7 <vector136>:
.globl vector136
vector136:
  pushl $0
c01023e7:	6a 00                	push   $0x0
  pushl $136
c01023e9:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01023ee:	e9 94 05 00 00       	jmp    c0102987 <__alltraps>

c01023f3 <vector137>:
.globl vector137
vector137:
  pushl $0
c01023f3:	6a 00                	push   $0x0
  pushl $137
c01023f5:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023fa:	e9 88 05 00 00       	jmp    c0102987 <__alltraps>

c01023ff <vector138>:
.globl vector138
vector138:
  pushl $0
c01023ff:	6a 00                	push   $0x0
  pushl $138
c0102401:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102406:	e9 7c 05 00 00       	jmp    c0102987 <__alltraps>

c010240b <vector139>:
.globl vector139
vector139:
  pushl $0
c010240b:	6a 00                	push   $0x0
  pushl $139
c010240d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102412:	e9 70 05 00 00       	jmp    c0102987 <__alltraps>

c0102417 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102417:	6a 00                	push   $0x0
  pushl $140
c0102419:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010241e:	e9 64 05 00 00       	jmp    c0102987 <__alltraps>

c0102423 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102423:	6a 00                	push   $0x0
  pushl $141
c0102425:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010242a:	e9 58 05 00 00       	jmp    c0102987 <__alltraps>

c010242f <vector142>:
.globl vector142
vector142:
  pushl $0
c010242f:	6a 00                	push   $0x0
  pushl $142
c0102431:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102436:	e9 4c 05 00 00       	jmp    c0102987 <__alltraps>

c010243b <vector143>:
.globl vector143
vector143:
  pushl $0
c010243b:	6a 00                	push   $0x0
  pushl $143
c010243d:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102442:	e9 40 05 00 00       	jmp    c0102987 <__alltraps>

c0102447 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102447:	6a 00                	push   $0x0
  pushl $144
c0102449:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010244e:	e9 34 05 00 00       	jmp    c0102987 <__alltraps>

c0102453 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102453:	6a 00                	push   $0x0
  pushl $145
c0102455:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010245a:	e9 28 05 00 00       	jmp    c0102987 <__alltraps>

c010245f <vector146>:
.globl vector146
vector146:
  pushl $0
c010245f:	6a 00                	push   $0x0
  pushl $146
c0102461:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102466:	e9 1c 05 00 00       	jmp    c0102987 <__alltraps>

c010246b <vector147>:
.globl vector147
vector147:
  pushl $0
c010246b:	6a 00                	push   $0x0
  pushl $147
c010246d:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102472:	e9 10 05 00 00       	jmp    c0102987 <__alltraps>

c0102477 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102477:	6a 00                	push   $0x0
  pushl $148
c0102479:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010247e:	e9 04 05 00 00       	jmp    c0102987 <__alltraps>

c0102483 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102483:	6a 00                	push   $0x0
  pushl $149
c0102485:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010248a:	e9 f8 04 00 00       	jmp    c0102987 <__alltraps>

c010248f <vector150>:
.globl vector150
vector150:
  pushl $0
c010248f:	6a 00                	push   $0x0
  pushl $150
c0102491:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102496:	e9 ec 04 00 00       	jmp    c0102987 <__alltraps>

c010249b <vector151>:
.globl vector151
vector151:
  pushl $0
c010249b:	6a 00                	push   $0x0
  pushl $151
c010249d:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01024a2:	e9 e0 04 00 00       	jmp    c0102987 <__alltraps>

c01024a7 <vector152>:
.globl vector152
vector152:
  pushl $0
c01024a7:	6a 00                	push   $0x0
  pushl $152
c01024a9:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01024ae:	e9 d4 04 00 00       	jmp    c0102987 <__alltraps>

c01024b3 <vector153>:
.globl vector153
vector153:
  pushl $0
c01024b3:	6a 00                	push   $0x0
  pushl $153
c01024b5:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01024ba:	e9 c8 04 00 00       	jmp    c0102987 <__alltraps>

c01024bf <vector154>:
.globl vector154
vector154:
  pushl $0
c01024bf:	6a 00                	push   $0x0
  pushl $154
c01024c1:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01024c6:	e9 bc 04 00 00       	jmp    c0102987 <__alltraps>

c01024cb <vector155>:
.globl vector155
vector155:
  pushl $0
c01024cb:	6a 00                	push   $0x0
  pushl $155
c01024cd:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01024d2:	e9 b0 04 00 00       	jmp    c0102987 <__alltraps>

c01024d7 <vector156>:
.globl vector156
vector156:
  pushl $0
c01024d7:	6a 00                	push   $0x0
  pushl $156
c01024d9:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01024de:	e9 a4 04 00 00       	jmp    c0102987 <__alltraps>

c01024e3 <vector157>:
.globl vector157
vector157:
  pushl $0
c01024e3:	6a 00                	push   $0x0
  pushl $157
c01024e5:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01024ea:	e9 98 04 00 00       	jmp    c0102987 <__alltraps>

c01024ef <vector158>:
.globl vector158
vector158:
  pushl $0
c01024ef:	6a 00                	push   $0x0
  pushl $158
c01024f1:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01024f6:	e9 8c 04 00 00       	jmp    c0102987 <__alltraps>

c01024fb <vector159>:
.globl vector159
vector159:
  pushl $0
c01024fb:	6a 00                	push   $0x0
  pushl $159
c01024fd:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102502:	e9 80 04 00 00       	jmp    c0102987 <__alltraps>

c0102507 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102507:	6a 00                	push   $0x0
  pushl $160
c0102509:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010250e:	e9 74 04 00 00       	jmp    c0102987 <__alltraps>

c0102513 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102513:	6a 00                	push   $0x0
  pushl $161
c0102515:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010251a:	e9 68 04 00 00       	jmp    c0102987 <__alltraps>

c010251f <vector162>:
.globl vector162
vector162:
  pushl $0
c010251f:	6a 00                	push   $0x0
  pushl $162
c0102521:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102526:	e9 5c 04 00 00       	jmp    c0102987 <__alltraps>

c010252b <vector163>:
.globl vector163
vector163:
  pushl $0
c010252b:	6a 00                	push   $0x0
  pushl $163
c010252d:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102532:	e9 50 04 00 00       	jmp    c0102987 <__alltraps>

c0102537 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102537:	6a 00                	push   $0x0
  pushl $164
c0102539:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010253e:	e9 44 04 00 00       	jmp    c0102987 <__alltraps>

c0102543 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102543:	6a 00                	push   $0x0
  pushl $165
c0102545:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010254a:	e9 38 04 00 00       	jmp    c0102987 <__alltraps>

c010254f <vector166>:
.globl vector166
vector166:
  pushl $0
c010254f:	6a 00                	push   $0x0
  pushl $166
c0102551:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102556:	e9 2c 04 00 00       	jmp    c0102987 <__alltraps>

c010255b <vector167>:
.globl vector167
vector167:
  pushl $0
c010255b:	6a 00                	push   $0x0
  pushl $167
c010255d:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102562:	e9 20 04 00 00       	jmp    c0102987 <__alltraps>

c0102567 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102567:	6a 00                	push   $0x0
  pushl $168
c0102569:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010256e:	e9 14 04 00 00       	jmp    c0102987 <__alltraps>

c0102573 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102573:	6a 00                	push   $0x0
  pushl $169
c0102575:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010257a:	e9 08 04 00 00       	jmp    c0102987 <__alltraps>

c010257f <vector170>:
.globl vector170
vector170:
  pushl $0
c010257f:	6a 00                	push   $0x0
  pushl $170
c0102581:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102586:	e9 fc 03 00 00       	jmp    c0102987 <__alltraps>

c010258b <vector171>:
.globl vector171
vector171:
  pushl $0
c010258b:	6a 00                	push   $0x0
  pushl $171
c010258d:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102592:	e9 f0 03 00 00       	jmp    c0102987 <__alltraps>

c0102597 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102597:	6a 00                	push   $0x0
  pushl $172
c0102599:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010259e:	e9 e4 03 00 00       	jmp    c0102987 <__alltraps>

c01025a3 <vector173>:
.globl vector173
vector173:
  pushl $0
c01025a3:	6a 00                	push   $0x0
  pushl $173
c01025a5:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01025aa:	e9 d8 03 00 00       	jmp    c0102987 <__alltraps>

c01025af <vector174>:
.globl vector174
vector174:
  pushl $0
c01025af:	6a 00                	push   $0x0
  pushl $174
c01025b1:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01025b6:	e9 cc 03 00 00       	jmp    c0102987 <__alltraps>

c01025bb <vector175>:
.globl vector175
vector175:
  pushl $0
c01025bb:	6a 00                	push   $0x0
  pushl $175
c01025bd:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01025c2:	e9 c0 03 00 00       	jmp    c0102987 <__alltraps>

c01025c7 <vector176>:
.globl vector176
vector176:
  pushl $0
c01025c7:	6a 00                	push   $0x0
  pushl $176
c01025c9:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01025ce:	e9 b4 03 00 00       	jmp    c0102987 <__alltraps>

c01025d3 <vector177>:
.globl vector177
vector177:
  pushl $0
c01025d3:	6a 00                	push   $0x0
  pushl $177
c01025d5:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01025da:	e9 a8 03 00 00       	jmp    c0102987 <__alltraps>

c01025df <vector178>:
.globl vector178
vector178:
  pushl $0
c01025df:	6a 00                	push   $0x0
  pushl $178
c01025e1:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01025e6:	e9 9c 03 00 00       	jmp    c0102987 <__alltraps>

c01025eb <vector179>:
.globl vector179
vector179:
  pushl $0
c01025eb:	6a 00                	push   $0x0
  pushl $179
c01025ed:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01025f2:	e9 90 03 00 00       	jmp    c0102987 <__alltraps>

c01025f7 <vector180>:
.globl vector180
vector180:
  pushl $0
c01025f7:	6a 00                	push   $0x0
  pushl $180
c01025f9:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025fe:	e9 84 03 00 00       	jmp    c0102987 <__alltraps>

c0102603 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102603:	6a 00                	push   $0x0
  pushl $181
c0102605:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010260a:	e9 78 03 00 00       	jmp    c0102987 <__alltraps>

c010260f <vector182>:
.globl vector182
vector182:
  pushl $0
c010260f:	6a 00                	push   $0x0
  pushl $182
c0102611:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102616:	e9 6c 03 00 00       	jmp    c0102987 <__alltraps>

c010261b <vector183>:
.globl vector183
vector183:
  pushl $0
c010261b:	6a 00                	push   $0x0
  pushl $183
c010261d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102622:	e9 60 03 00 00       	jmp    c0102987 <__alltraps>

c0102627 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102627:	6a 00                	push   $0x0
  pushl $184
c0102629:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010262e:	e9 54 03 00 00       	jmp    c0102987 <__alltraps>

c0102633 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102633:	6a 00                	push   $0x0
  pushl $185
c0102635:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010263a:	e9 48 03 00 00       	jmp    c0102987 <__alltraps>

c010263f <vector186>:
.globl vector186
vector186:
  pushl $0
c010263f:	6a 00                	push   $0x0
  pushl $186
c0102641:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102646:	e9 3c 03 00 00       	jmp    c0102987 <__alltraps>

c010264b <vector187>:
.globl vector187
vector187:
  pushl $0
c010264b:	6a 00                	push   $0x0
  pushl $187
c010264d:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102652:	e9 30 03 00 00       	jmp    c0102987 <__alltraps>

c0102657 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102657:	6a 00                	push   $0x0
  pushl $188
c0102659:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010265e:	e9 24 03 00 00       	jmp    c0102987 <__alltraps>

c0102663 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102663:	6a 00                	push   $0x0
  pushl $189
c0102665:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010266a:	e9 18 03 00 00       	jmp    c0102987 <__alltraps>

c010266f <vector190>:
.globl vector190
vector190:
  pushl $0
c010266f:	6a 00                	push   $0x0
  pushl $190
c0102671:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102676:	e9 0c 03 00 00       	jmp    c0102987 <__alltraps>

c010267b <vector191>:
.globl vector191
vector191:
  pushl $0
c010267b:	6a 00                	push   $0x0
  pushl $191
c010267d:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102682:	e9 00 03 00 00       	jmp    c0102987 <__alltraps>

c0102687 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102687:	6a 00                	push   $0x0
  pushl $192
c0102689:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010268e:	e9 f4 02 00 00       	jmp    c0102987 <__alltraps>

c0102693 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102693:	6a 00                	push   $0x0
  pushl $193
c0102695:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010269a:	e9 e8 02 00 00       	jmp    c0102987 <__alltraps>

c010269f <vector194>:
.globl vector194
vector194:
  pushl $0
c010269f:	6a 00                	push   $0x0
  pushl $194
c01026a1:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01026a6:	e9 dc 02 00 00       	jmp    c0102987 <__alltraps>

c01026ab <vector195>:
.globl vector195
vector195:
  pushl $0
c01026ab:	6a 00                	push   $0x0
  pushl $195
c01026ad:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01026b2:	e9 d0 02 00 00       	jmp    c0102987 <__alltraps>

c01026b7 <vector196>:
.globl vector196
vector196:
  pushl $0
c01026b7:	6a 00                	push   $0x0
  pushl $196
c01026b9:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01026be:	e9 c4 02 00 00       	jmp    c0102987 <__alltraps>

c01026c3 <vector197>:
.globl vector197
vector197:
  pushl $0
c01026c3:	6a 00                	push   $0x0
  pushl $197
c01026c5:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01026ca:	e9 b8 02 00 00       	jmp    c0102987 <__alltraps>

c01026cf <vector198>:
.globl vector198
vector198:
  pushl $0
c01026cf:	6a 00                	push   $0x0
  pushl $198
c01026d1:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01026d6:	e9 ac 02 00 00       	jmp    c0102987 <__alltraps>

c01026db <vector199>:
.globl vector199
vector199:
  pushl $0
c01026db:	6a 00                	push   $0x0
  pushl $199
c01026dd:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01026e2:	e9 a0 02 00 00       	jmp    c0102987 <__alltraps>

c01026e7 <vector200>:
.globl vector200
vector200:
  pushl $0
c01026e7:	6a 00                	push   $0x0
  pushl $200
c01026e9:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01026ee:	e9 94 02 00 00       	jmp    c0102987 <__alltraps>

c01026f3 <vector201>:
.globl vector201
vector201:
  pushl $0
c01026f3:	6a 00                	push   $0x0
  pushl $201
c01026f5:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026fa:	e9 88 02 00 00       	jmp    c0102987 <__alltraps>

c01026ff <vector202>:
.globl vector202
vector202:
  pushl $0
c01026ff:	6a 00                	push   $0x0
  pushl $202
c0102701:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102706:	e9 7c 02 00 00       	jmp    c0102987 <__alltraps>

c010270b <vector203>:
.globl vector203
vector203:
  pushl $0
c010270b:	6a 00                	push   $0x0
  pushl $203
c010270d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102712:	e9 70 02 00 00       	jmp    c0102987 <__alltraps>

c0102717 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102717:	6a 00                	push   $0x0
  pushl $204
c0102719:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010271e:	e9 64 02 00 00       	jmp    c0102987 <__alltraps>

c0102723 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102723:	6a 00                	push   $0x0
  pushl $205
c0102725:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010272a:	e9 58 02 00 00       	jmp    c0102987 <__alltraps>

c010272f <vector206>:
.globl vector206
vector206:
  pushl $0
c010272f:	6a 00                	push   $0x0
  pushl $206
c0102731:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102736:	e9 4c 02 00 00       	jmp    c0102987 <__alltraps>

c010273b <vector207>:
.globl vector207
vector207:
  pushl $0
c010273b:	6a 00                	push   $0x0
  pushl $207
c010273d:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102742:	e9 40 02 00 00       	jmp    c0102987 <__alltraps>

c0102747 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102747:	6a 00                	push   $0x0
  pushl $208
c0102749:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010274e:	e9 34 02 00 00       	jmp    c0102987 <__alltraps>

c0102753 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102753:	6a 00                	push   $0x0
  pushl $209
c0102755:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010275a:	e9 28 02 00 00       	jmp    c0102987 <__alltraps>

c010275f <vector210>:
.globl vector210
vector210:
  pushl $0
c010275f:	6a 00                	push   $0x0
  pushl $210
c0102761:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102766:	e9 1c 02 00 00       	jmp    c0102987 <__alltraps>

c010276b <vector211>:
.globl vector211
vector211:
  pushl $0
c010276b:	6a 00                	push   $0x0
  pushl $211
c010276d:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102772:	e9 10 02 00 00       	jmp    c0102987 <__alltraps>

c0102777 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102777:	6a 00                	push   $0x0
  pushl $212
c0102779:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010277e:	e9 04 02 00 00       	jmp    c0102987 <__alltraps>

c0102783 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102783:	6a 00                	push   $0x0
  pushl $213
c0102785:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010278a:	e9 f8 01 00 00       	jmp    c0102987 <__alltraps>

c010278f <vector214>:
.globl vector214
vector214:
  pushl $0
c010278f:	6a 00                	push   $0x0
  pushl $214
c0102791:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102796:	e9 ec 01 00 00       	jmp    c0102987 <__alltraps>

c010279b <vector215>:
.globl vector215
vector215:
  pushl $0
c010279b:	6a 00                	push   $0x0
  pushl $215
c010279d:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01027a2:	e9 e0 01 00 00       	jmp    c0102987 <__alltraps>

c01027a7 <vector216>:
.globl vector216
vector216:
  pushl $0
c01027a7:	6a 00                	push   $0x0
  pushl $216
c01027a9:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01027ae:	e9 d4 01 00 00       	jmp    c0102987 <__alltraps>

c01027b3 <vector217>:
.globl vector217
vector217:
  pushl $0
c01027b3:	6a 00                	push   $0x0
  pushl $217
c01027b5:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01027ba:	e9 c8 01 00 00       	jmp    c0102987 <__alltraps>

c01027bf <vector218>:
.globl vector218
vector218:
  pushl $0
c01027bf:	6a 00                	push   $0x0
  pushl $218
c01027c1:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01027c6:	e9 bc 01 00 00       	jmp    c0102987 <__alltraps>

c01027cb <vector219>:
.globl vector219
vector219:
  pushl $0
c01027cb:	6a 00                	push   $0x0
  pushl $219
c01027cd:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01027d2:	e9 b0 01 00 00       	jmp    c0102987 <__alltraps>

c01027d7 <vector220>:
.globl vector220
vector220:
  pushl $0
c01027d7:	6a 00                	push   $0x0
  pushl $220
c01027d9:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01027de:	e9 a4 01 00 00       	jmp    c0102987 <__alltraps>

c01027e3 <vector221>:
.globl vector221
vector221:
  pushl $0
c01027e3:	6a 00                	push   $0x0
  pushl $221
c01027e5:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01027ea:	e9 98 01 00 00       	jmp    c0102987 <__alltraps>

c01027ef <vector222>:
.globl vector222
vector222:
  pushl $0
c01027ef:	6a 00                	push   $0x0
  pushl $222
c01027f1:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01027f6:	e9 8c 01 00 00       	jmp    c0102987 <__alltraps>

c01027fb <vector223>:
.globl vector223
vector223:
  pushl $0
c01027fb:	6a 00                	push   $0x0
  pushl $223
c01027fd:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102802:	e9 80 01 00 00       	jmp    c0102987 <__alltraps>

c0102807 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102807:	6a 00                	push   $0x0
  pushl $224
c0102809:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010280e:	e9 74 01 00 00       	jmp    c0102987 <__alltraps>

c0102813 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102813:	6a 00                	push   $0x0
  pushl $225
c0102815:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010281a:	e9 68 01 00 00       	jmp    c0102987 <__alltraps>

c010281f <vector226>:
.globl vector226
vector226:
  pushl $0
c010281f:	6a 00                	push   $0x0
  pushl $226
c0102821:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102826:	e9 5c 01 00 00       	jmp    c0102987 <__alltraps>

c010282b <vector227>:
.globl vector227
vector227:
  pushl $0
c010282b:	6a 00                	push   $0x0
  pushl $227
c010282d:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102832:	e9 50 01 00 00       	jmp    c0102987 <__alltraps>

c0102837 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102837:	6a 00                	push   $0x0
  pushl $228
c0102839:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010283e:	e9 44 01 00 00       	jmp    c0102987 <__alltraps>

c0102843 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102843:	6a 00                	push   $0x0
  pushl $229
c0102845:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010284a:	e9 38 01 00 00       	jmp    c0102987 <__alltraps>

c010284f <vector230>:
.globl vector230
vector230:
  pushl $0
c010284f:	6a 00                	push   $0x0
  pushl $230
c0102851:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102856:	e9 2c 01 00 00       	jmp    c0102987 <__alltraps>

c010285b <vector231>:
.globl vector231
vector231:
  pushl $0
c010285b:	6a 00                	push   $0x0
  pushl $231
c010285d:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102862:	e9 20 01 00 00       	jmp    c0102987 <__alltraps>

c0102867 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102867:	6a 00                	push   $0x0
  pushl $232
c0102869:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010286e:	e9 14 01 00 00       	jmp    c0102987 <__alltraps>

c0102873 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102873:	6a 00                	push   $0x0
  pushl $233
c0102875:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010287a:	e9 08 01 00 00       	jmp    c0102987 <__alltraps>

c010287f <vector234>:
.globl vector234
vector234:
  pushl $0
c010287f:	6a 00                	push   $0x0
  pushl $234
c0102881:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102886:	e9 fc 00 00 00       	jmp    c0102987 <__alltraps>

c010288b <vector235>:
.globl vector235
vector235:
  pushl $0
c010288b:	6a 00                	push   $0x0
  pushl $235
c010288d:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102892:	e9 f0 00 00 00       	jmp    c0102987 <__alltraps>

c0102897 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102897:	6a 00                	push   $0x0
  pushl $236
c0102899:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010289e:	e9 e4 00 00 00       	jmp    c0102987 <__alltraps>

c01028a3 <vector237>:
.globl vector237
vector237:
  pushl $0
c01028a3:	6a 00                	push   $0x0
  pushl $237
c01028a5:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01028aa:	e9 d8 00 00 00       	jmp    c0102987 <__alltraps>

c01028af <vector238>:
.globl vector238
vector238:
  pushl $0
c01028af:	6a 00                	push   $0x0
  pushl $238
c01028b1:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01028b6:	e9 cc 00 00 00       	jmp    c0102987 <__alltraps>

c01028bb <vector239>:
.globl vector239
vector239:
  pushl $0
c01028bb:	6a 00                	push   $0x0
  pushl $239
c01028bd:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01028c2:	e9 c0 00 00 00       	jmp    c0102987 <__alltraps>

c01028c7 <vector240>:
.globl vector240
vector240:
  pushl $0
c01028c7:	6a 00                	push   $0x0
  pushl $240
c01028c9:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01028ce:	e9 b4 00 00 00       	jmp    c0102987 <__alltraps>

c01028d3 <vector241>:
.globl vector241
vector241:
  pushl $0
c01028d3:	6a 00                	push   $0x0
  pushl $241
c01028d5:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01028da:	e9 a8 00 00 00       	jmp    c0102987 <__alltraps>

c01028df <vector242>:
.globl vector242
vector242:
  pushl $0
c01028df:	6a 00                	push   $0x0
  pushl $242
c01028e1:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01028e6:	e9 9c 00 00 00       	jmp    c0102987 <__alltraps>

c01028eb <vector243>:
.globl vector243
vector243:
  pushl $0
c01028eb:	6a 00                	push   $0x0
  pushl $243
c01028ed:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01028f2:	e9 90 00 00 00       	jmp    c0102987 <__alltraps>

c01028f7 <vector244>:
.globl vector244
vector244:
  pushl $0
c01028f7:	6a 00                	push   $0x0
  pushl $244
c01028f9:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028fe:	e9 84 00 00 00       	jmp    c0102987 <__alltraps>

c0102903 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102903:	6a 00                	push   $0x0
  pushl $245
c0102905:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010290a:	e9 78 00 00 00       	jmp    c0102987 <__alltraps>

c010290f <vector246>:
.globl vector246
vector246:
  pushl $0
c010290f:	6a 00                	push   $0x0
  pushl $246
c0102911:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102916:	e9 6c 00 00 00       	jmp    c0102987 <__alltraps>

c010291b <vector247>:
.globl vector247
vector247:
  pushl $0
c010291b:	6a 00                	push   $0x0
  pushl $247
c010291d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102922:	e9 60 00 00 00       	jmp    c0102987 <__alltraps>

c0102927 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102927:	6a 00                	push   $0x0
  pushl $248
c0102929:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010292e:	e9 54 00 00 00       	jmp    c0102987 <__alltraps>

c0102933 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102933:	6a 00                	push   $0x0
  pushl $249
c0102935:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010293a:	e9 48 00 00 00       	jmp    c0102987 <__alltraps>

c010293f <vector250>:
.globl vector250
vector250:
  pushl $0
c010293f:	6a 00                	push   $0x0
  pushl $250
c0102941:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102946:	e9 3c 00 00 00       	jmp    c0102987 <__alltraps>

c010294b <vector251>:
.globl vector251
vector251:
  pushl $0
c010294b:	6a 00                	push   $0x0
  pushl $251
c010294d:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102952:	e9 30 00 00 00       	jmp    c0102987 <__alltraps>

c0102957 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102957:	6a 00                	push   $0x0
  pushl $252
c0102959:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010295e:	e9 24 00 00 00       	jmp    c0102987 <__alltraps>

c0102963 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102963:	6a 00                	push   $0x0
  pushl $253
c0102965:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010296a:	e9 18 00 00 00       	jmp    c0102987 <__alltraps>

c010296f <vector254>:
.globl vector254
vector254:
  pushl $0
c010296f:	6a 00                	push   $0x0
  pushl $254
c0102971:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102976:	e9 0c 00 00 00       	jmp    c0102987 <__alltraps>

c010297b <vector255>:
.globl vector255
vector255:
  pushl $0
c010297b:	6a 00                	push   $0x0
  pushl $255
c010297d:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102982:	e9 00 00 00 00       	jmp    c0102987 <__alltraps>

c0102987 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102987:	1e                   	push   %ds
    pushl %es
c0102988:	06                   	push   %es
    pushl %fs
c0102989:	0f a0                	push   %fs
    pushl %gs
c010298b:	0f a8                	push   %gs
    pushal
c010298d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c010298e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102993:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102995:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102997:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102998:	e8 67 f5 ff ff       	call   c0101f04 <trap>

    # pop the pushed stack pointer
    popl %esp
c010299d:	5c                   	pop    %esp

c010299e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c010299e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010299f:	0f a9                	pop    %gs
    popl %fs
c01029a1:	0f a1                	pop    %fs
    popl %es
c01029a3:	07                   	pop    %es
    popl %ds
c01029a4:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01029a5:	83 c4 08             	add    $0x8,%esp
    iret
c01029a8:	cf                   	iret   

c01029a9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01029a9:	55                   	push   %ebp
c01029aa:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01029ac:	8b 55 08             	mov    0x8(%ebp),%edx
c01029af:	a1 74 e9 11 c0       	mov    0xc011e974,%eax
c01029b4:	29 c2                	sub    %eax,%edx
c01029b6:	89 d0                	mov    %edx,%eax
c01029b8:	c1 f8 02             	sar    $0x2,%eax
c01029bb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01029c1:	5d                   	pop    %ebp
c01029c2:	c3                   	ret    

c01029c3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01029c3:	55                   	push   %ebp
c01029c4:	89 e5                	mov    %esp,%ebp
c01029c6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01029c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01029cc:	89 04 24             	mov    %eax,(%esp)
c01029cf:	e8 d5 ff ff ff       	call   c01029a9 <page2ppn>
c01029d4:	c1 e0 0c             	shl    $0xc,%eax
}
c01029d7:	c9                   	leave  
c01029d8:	c3                   	ret    

c01029d9 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01029d9:	55                   	push   %ebp
c01029da:	89 e5                	mov    %esp,%ebp
c01029dc:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01029df:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e2:	c1 e8 0c             	shr    $0xc,%eax
c01029e5:	89 c2                	mov    %eax,%edx
c01029e7:	a1 c0 e8 11 c0       	mov    0xc011e8c0,%eax
c01029ec:	39 c2                	cmp    %eax,%edx
c01029ee:	72 1c                	jb     c0102a0c <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01029f0:	c7 44 24 08 30 a5 10 	movl   $0xc010a530,0x8(%esp)
c01029f7:	c0 
c01029f8:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01029ff:	00 
c0102a00:	c7 04 24 4f a5 10 c0 	movl   $0xc010a54f,(%esp)
c0102a07:	e8 dc d9 ff ff       	call   c01003e8 <__panic>
    }
    return &pages[PPN(pa)];
c0102a0c:	8b 0d 74 e9 11 c0    	mov    0xc011e974,%ecx
c0102a12:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a15:	c1 e8 0c             	shr    $0xc,%eax
c0102a18:	89 c2                	mov    %eax,%edx
c0102a1a:	89 d0                	mov    %edx,%eax
c0102a1c:	c1 e0 02             	shl    $0x2,%eax
c0102a1f:	01 d0                	add    %edx,%eax
c0102a21:	c1 e0 02             	shl    $0x2,%eax
c0102a24:	01 c8                	add    %ecx,%eax
}
c0102a26:	c9                   	leave  
c0102a27:	c3                   	ret    

c0102a28 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102a28:	55                   	push   %ebp
c0102a29:	89 e5                	mov    %esp,%ebp
c0102a2b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102a2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a31:	89 04 24             	mov    %eax,(%esp)
c0102a34:	e8 8a ff ff ff       	call   c01029c3 <page2pa>
c0102a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a3f:	c1 e8 0c             	shr    $0xc,%eax
c0102a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a45:	a1 c0 e8 11 c0       	mov    0xc011e8c0,%eax
c0102a4a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102a4d:	72 23                	jb     c0102a72 <page2kva+0x4a>
c0102a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a52:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102a56:	c7 44 24 08 60 a5 10 	movl   $0xc010a560,0x8(%esp)
c0102a5d:	c0 
c0102a5e:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102a65:	00 
c0102a66:	c7 04 24 4f a5 10 c0 	movl   $0xc010a54f,(%esp)
c0102a6d:	e8 76 d9 ff ff       	call   c01003e8 <__panic>
c0102a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a75:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102a7a:	c9                   	leave  
c0102a7b:	c3                   	ret    

c0102a7c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102a7c:	55                   	push   %ebp
c0102a7d:	89 e5                	mov    %esp,%ebp
c0102a7f:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a85:	83 e0 01             	and    $0x1,%eax
c0102a88:	85 c0                	test   %eax,%eax
c0102a8a:	75 1c                	jne    c0102aa8 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102a8c:	c7 44 24 08 84 a5 10 	movl   $0xc010a584,0x8(%esp)
c0102a93:	c0 
c0102a94:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102a9b:	00 
c0102a9c:	c7 04 24 4f a5 10 c0 	movl   $0xc010a54f,(%esp)
c0102aa3:	e8 40 d9 ff ff       	call   c01003e8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102ab0:	89 04 24             	mov    %eax,(%esp)
c0102ab3:	e8 21 ff ff ff       	call   c01029d9 <pa2page>
}
c0102ab8:	c9                   	leave  
c0102ab9:	c3                   	ret    

c0102aba <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102aba:	55                   	push   %ebp
c0102abb:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac0:	8b 00                	mov    (%eax),%eax
}
c0102ac2:	5d                   	pop    %ebp
c0102ac3:	c3                   	ret    

c0102ac4 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102ac4:	55                   	push   %ebp
c0102ac5:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aca:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102acd:	89 10                	mov    %edx,(%eax)
}
c0102acf:	5d                   	pop    %ebp
c0102ad0:	c3                   	ret    

c0102ad1 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102ad1:	55                   	push   %ebp
c0102ad2:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102ad4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad7:	8b 00                	mov    (%eax),%eax
c0102ad9:	8d 50 01             	lea    0x1(%eax),%edx
c0102adc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102adf:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ae4:	8b 00                	mov    (%eax),%eax
}
c0102ae6:	5d                   	pop    %ebp
c0102ae7:	c3                   	ret    

c0102ae8 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102ae8:	55                   	push   %ebp
c0102ae9:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102aeb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aee:	8b 00                	mov    (%eax),%eax
c0102af0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102af6:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102afb:	8b 00                	mov    (%eax),%eax
}
c0102afd:	5d                   	pop    %ebp
c0102afe:	c3                   	ret    

c0102aff <__intr_save>:
__intr_save(void) {
c0102aff:	55                   	push   %ebp
c0102b00:	89 e5                	mov    %esp,%ebp
c0102b02:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102b05:	9c                   	pushf  
c0102b06:	58                   	pop    %eax
c0102b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102b0d:	25 00 02 00 00       	and    $0x200,%eax
c0102b12:	85 c0                	test   %eax,%eax
c0102b14:	74 0c                	je     c0102b22 <__intr_save+0x23>
        intr_disable();
c0102b16:	e8 61 ed ff ff       	call   c010187c <intr_disable>
        return 1;
c0102b1b:	b8 01 00 00 00       	mov    $0x1,%eax
c0102b20:	eb 05                	jmp    c0102b27 <__intr_save+0x28>
    return 0;
c0102b22:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b27:	c9                   	leave  
c0102b28:	c3                   	ret    

c0102b29 <__intr_restore>:
__intr_restore(bool flag) {
c0102b29:	55                   	push   %ebp
c0102b2a:	89 e5                	mov    %esp,%ebp
c0102b2c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102b2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b33:	74 05                	je     c0102b3a <__intr_restore+0x11>
        intr_enable();
c0102b35:	e8 3c ed ff ff       	call   c0101876 <intr_enable>
}
c0102b3a:	c9                   	leave  
c0102b3b:	c3                   	ret    

c0102b3c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102b3c:	55                   	push   %ebp
c0102b3d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b42:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102b45:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b4a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102b4c:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b51:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102b53:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b58:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102b5a:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b5f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102b61:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b66:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102b68:	ea 6f 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102b6f
}
c0102b6f:	5d                   	pop    %ebp
c0102b70:	c3                   	ret    

c0102b71 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102b71:	55                   	push   %ebp
c0102b72:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102b74:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b77:	a3 e4 e8 11 c0       	mov    %eax,0xc011e8e4
}
c0102b7c:	5d                   	pop    %ebp
c0102b7d:	c3                   	ret    

c0102b7e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102b7e:	55                   	push   %ebp
c0102b7f:	89 e5                	mov    %esp,%ebp
c0102b81:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102b84:	b8 00 d0 11 c0       	mov    $0xc011d000,%eax
c0102b89:	89 04 24             	mov    %eax,(%esp)
c0102b8c:	e8 e0 ff ff ff       	call   c0102b71 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102b91:	66 c7 05 e8 e8 11 c0 	movw   $0x10,0xc011e8e8
c0102b98:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102b9a:	66 c7 05 28 da 11 c0 	movw   $0x68,0xc011da28
c0102ba1:	68 00 
c0102ba3:	b8 e0 e8 11 c0       	mov    $0xc011e8e0,%eax
c0102ba8:	66 a3 2a da 11 c0    	mov    %ax,0xc011da2a
c0102bae:	b8 e0 e8 11 c0       	mov    $0xc011e8e0,%eax
c0102bb3:	c1 e8 10             	shr    $0x10,%eax
c0102bb6:	a2 2c da 11 c0       	mov    %al,0xc011da2c
c0102bbb:	0f b6 05 2d da 11 c0 	movzbl 0xc011da2d,%eax
c0102bc2:	83 e0 f0             	and    $0xfffffff0,%eax
c0102bc5:	83 c8 09             	or     $0x9,%eax
c0102bc8:	a2 2d da 11 c0       	mov    %al,0xc011da2d
c0102bcd:	0f b6 05 2d da 11 c0 	movzbl 0xc011da2d,%eax
c0102bd4:	83 e0 ef             	and    $0xffffffef,%eax
c0102bd7:	a2 2d da 11 c0       	mov    %al,0xc011da2d
c0102bdc:	0f b6 05 2d da 11 c0 	movzbl 0xc011da2d,%eax
c0102be3:	83 e0 9f             	and    $0xffffff9f,%eax
c0102be6:	a2 2d da 11 c0       	mov    %al,0xc011da2d
c0102beb:	0f b6 05 2d da 11 c0 	movzbl 0xc011da2d,%eax
c0102bf2:	83 c8 80             	or     $0xffffff80,%eax
c0102bf5:	a2 2d da 11 c0       	mov    %al,0xc011da2d
c0102bfa:	0f b6 05 2e da 11 c0 	movzbl 0xc011da2e,%eax
c0102c01:	83 e0 f0             	and    $0xfffffff0,%eax
c0102c04:	a2 2e da 11 c0       	mov    %al,0xc011da2e
c0102c09:	0f b6 05 2e da 11 c0 	movzbl 0xc011da2e,%eax
c0102c10:	83 e0 ef             	and    $0xffffffef,%eax
c0102c13:	a2 2e da 11 c0       	mov    %al,0xc011da2e
c0102c18:	0f b6 05 2e da 11 c0 	movzbl 0xc011da2e,%eax
c0102c1f:	83 e0 df             	and    $0xffffffdf,%eax
c0102c22:	a2 2e da 11 c0       	mov    %al,0xc011da2e
c0102c27:	0f b6 05 2e da 11 c0 	movzbl 0xc011da2e,%eax
c0102c2e:	83 c8 40             	or     $0x40,%eax
c0102c31:	a2 2e da 11 c0       	mov    %al,0xc011da2e
c0102c36:	0f b6 05 2e da 11 c0 	movzbl 0xc011da2e,%eax
c0102c3d:	83 e0 7f             	and    $0x7f,%eax
c0102c40:	a2 2e da 11 c0       	mov    %al,0xc011da2e
c0102c45:	b8 e0 e8 11 c0       	mov    $0xc011e8e0,%eax
c0102c4a:	c1 e8 18             	shr    $0x18,%eax
c0102c4d:	a2 2f da 11 c0       	mov    %al,0xc011da2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102c52:	c7 04 24 30 da 11 c0 	movl   $0xc011da30,(%esp)
c0102c59:	e8 de fe ff ff       	call   c0102b3c <lgdt>
c0102c5e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102c64:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102c68:	0f 00 d8             	ltr    %ax
    // load the TSS
    ltr(GD_TSS);
}
c0102c6b:	c9                   	leave  
c0102c6c:	c3                   	ret    

c0102c6d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102c6d:	55                   	push   %ebp
c0102c6e:	89 e5                	mov    %esp,%ebp
c0102c70:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102c73:	c7 05 6c e9 11 c0 f8 	movl   $0xc010b2f8,0xc011e96c
c0102c7a:	b2 10 c0 
    //pmm_manager=&buddy_pmm_manager;
    cprintf("memory management: %s\n", pmm_manager->name);
c0102c7d:	a1 6c e9 11 c0       	mov    0xc011e96c,%eax
c0102c82:	8b 00                	mov    (%eax),%eax
c0102c84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102c88:	c7 04 24 b0 a5 10 c0 	movl   $0xc010a5b0,(%esp)
c0102c8f:	e8 fd d5 ff ff       	call   c0100291 <cprintf>
    pmm_manager->init();
c0102c94:	a1 6c e9 11 c0       	mov    0xc011e96c,%eax
c0102c99:	8b 40 04             	mov    0x4(%eax),%eax
c0102c9c:	ff d0                	call   *%eax
}
c0102c9e:	c9                   	leave  
c0102c9f:	c3                   	ret    

c0102ca0 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102ca0:	55                   	push   %ebp
c0102ca1:	89 e5                	mov    %esp,%ebp
c0102ca3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102ca6:	a1 6c e9 11 c0       	mov    0xc011e96c,%eax
c0102cab:	8b 40 08             	mov    0x8(%eax),%eax
c0102cae:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cb1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102cb5:	8b 55 08             	mov    0x8(%ebp),%edx
c0102cb8:	89 14 24             	mov    %edx,(%esp)
c0102cbb:	ff d0                	call   *%eax
}
c0102cbd:	c9                   	leave  
c0102cbe:	c3                   	ret    

c0102cbf <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102cbf:	55                   	push   %ebp
c0102cc0:	89 e5                	mov    %esp,%ebp
c0102cc2:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102cc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102ccc:	e8 2e fe ff ff       	call   c0102aff <__intr_save>
c0102cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102cd4:	a1 6c e9 11 c0       	mov    0xc011e96c,%eax
c0102cd9:	8b 40 0c             	mov    0xc(%eax),%eax
c0102cdc:	8b 55 08             	mov    0x8(%ebp),%edx
c0102cdf:	89 14 24             	mov    %edx,(%esp)
c0102ce2:	ff d0                	call   *%eax
c0102ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cea:	89 04 24             	mov    %eax,(%esp)
c0102ced:	e8 37 fe ff ff       	call   c0102b29 <__intr_restore>
    return page;
c0102cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102cf5:	c9                   	leave  
c0102cf6:	c3                   	ret    

c0102cf7 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102cf7:	55                   	push   %ebp
c0102cf8:	89 e5                	mov    %esp,%ebp
c0102cfa:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cfd:	e8 fd fd ff ff       	call   c0102aff <__intr_save>
c0102d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102d05:	a1 6c e9 11 c0       	mov    0xc011e96c,%eax
c0102d0a:	8b 40 10             	mov    0x10(%eax),%eax
c0102d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d10:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102d14:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d17:	89 14 24             	mov    %edx,(%esp)
c0102d1a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d1f:	89 04 24             	mov    %eax,(%esp)
c0102d22:	e8 02 fe ff ff       	call   c0102b29 <__intr_restore>
}
c0102d27:	c9                   	leave  
c0102d28:	c3                   	ret    

c0102d29 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102d29:	55                   	push   %ebp
c0102d2a:	89 e5                	mov    %esp,%ebp
c0102d2c:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d2f:	e8 cb fd ff ff       	call   c0102aff <__intr_save>
c0102d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102d37:	a1 6c e9 11 c0       	mov    0xc011e96c,%eax
c0102d3c:	8b 40 14             	mov    0x14(%eax),%eax
c0102d3f:	ff d0                	call   *%eax
c0102d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d47:	89 04 24             	mov    %eax,(%esp)
c0102d4a:	e8 da fd ff ff       	call   c0102b29 <__intr_restore>
    return ret;
c0102d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102d52:	c9                   	leave  
c0102d53:	c3                   	ret    

c0102d54 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102d54:	55                   	push   %ebp
c0102d55:	89 e5                	mov    %esp,%ebp
c0102d57:	57                   	push   %edi
c0102d58:	56                   	push   %esi
c0102d59:	53                   	push   %ebx
c0102d5a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102d60:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102d67:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102d6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102d75:	c7 04 24 c7 a5 10 c0 	movl   $0xc010a5c7,(%esp)
c0102d7c:	e8 10 d5 ff ff       	call   c0100291 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102d88:	e9 15 01 00 00       	jmp    c0102ea2 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102d8d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d93:	89 d0                	mov    %edx,%eax
c0102d95:	c1 e0 02             	shl    $0x2,%eax
c0102d98:	01 d0                	add    %edx,%eax
c0102d9a:	c1 e0 02             	shl    $0x2,%eax
c0102d9d:	01 c8                	add    %ecx,%eax
c0102d9f:	8b 50 08             	mov    0x8(%eax),%edx
c0102da2:	8b 40 04             	mov    0x4(%eax),%eax
c0102da5:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102da8:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102dab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102dae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102db1:	89 d0                	mov    %edx,%eax
c0102db3:	c1 e0 02             	shl    $0x2,%eax
c0102db6:	01 d0                	add    %edx,%eax
c0102db8:	c1 e0 02             	shl    $0x2,%eax
c0102dbb:	01 c8                	add    %ecx,%eax
c0102dbd:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102dc0:	8b 58 10             	mov    0x10(%eax),%ebx
c0102dc3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dc6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102dc9:	01 c8                	add    %ecx,%eax
c0102dcb:	11 da                	adc    %ebx,%edx
c0102dcd:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102dd0:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102dd3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dd9:	89 d0                	mov    %edx,%eax
c0102ddb:	c1 e0 02             	shl    $0x2,%eax
c0102dde:	01 d0                	add    %edx,%eax
c0102de0:	c1 e0 02             	shl    $0x2,%eax
c0102de3:	01 c8                	add    %ecx,%eax
c0102de5:	83 c0 14             	add    $0x14,%eax
c0102de8:	8b 00                	mov    (%eax),%eax
c0102dea:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0102df0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102df3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102df6:	83 c0 ff             	add    $0xffffffff,%eax
c0102df9:	83 d2 ff             	adc    $0xffffffff,%edx
c0102dfc:	89 c6                	mov    %eax,%esi
c0102dfe:	89 d7                	mov    %edx,%edi
c0102e00:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e03:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e06:	89 d0                	mov    %edx,%eax
c0102e08:	c1 e0 02             	shl    $0x2,%eax
c0102e0b:	01 d0                	add    %edx,%eax
c0102e0d:	c1 e0 02             	shl    $0x2,%eax
c0102e10:	01 c8                	add    %ecx,%eax
c0102e12:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e15:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e18:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102e1e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0102e22:	89 74 24 14          	mov    %esi,0x14(%esp)
c0102e26:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0102e2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e2d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102e30:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102e34:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102e38:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102e3c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102e40:	c7 04 24 d4 a5 10 c0 	movl   $0xc010a5d4,(%esp)
c0102e47:	e8 45 d4 ff ff       	call   c0100291 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102e4c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e52:	89 d0                	mov    %edx,%eax
c0102e54:	c1 e0 02             	shl    $0x2,%eax
c0102e57:	01 d0                	add    %edx,%eax
c0102e59:	c1 e0 02             	shl    $0x2,%eax
c0102e5c:	01 c8                	add    %ecx,%eax
c0102e5e:	83 c0 14             	add    $0x14,%eax
c0102e61:	8b 00                	mov    (%eax),%eax
c0102e63:	83 f8 01             	cmp    $0x1,%eax
c0102e66:	75 36                	jne    c0102e9e <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0102e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e6e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102e71:	77 2b                	ja     c0102e9e <page_init+0x14a>
c0102e73:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102e76:	72 05                	jb     c0102e7d <page_init+0x129>
c0102e78:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102e7b:	73 21                	jae    c0102e9e <page_init+0x14a>
c0102e7d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102e81:	77 1b                	ja     c0102e9e <page_init+0x14a>
c0102e83:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102e87:	72 09                	jb     c0102e92 <page_init+0x13e>
c0102e89:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102e90:	77 0c                	ja     c0102e9e <page_init+0x14a>
                maxpa = end;
c0102e92:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e95:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e98:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102e9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102e9e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102ea2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102ea5:	8b 00                	mov    (%eax),%eax
c0102ea7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102eaa:	0f 8f dd fe ff ff    	jg     c0102d8d <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102eb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102eb4:	72 1d                	jb     c0102ed3 <page_init+0x17f>
c0102eb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102eba:	77 09                	ja     c0102ec5 <page_init+0x171>
c0102ebc:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102ec3:	76 0e                	jbe    c0102ed3 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0102ec5:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102ecc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ed6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102ed9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102edd:	c1 ea 0c             	shr    $0xc,%edx
c0102ee0:	a3 c0 e8 11 c0       	mov    %eax,0xc011e8c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102ee5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102eec:	b8 84 e9 11 c0       	mov    $0xc011e984,%eax
c0102ef1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102ef4:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102ef7:	01 d0                	add    %edx,%eax
c0102ef9:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102efc:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102eff:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f04:	f7 75 ac             	divl   -0x54(%ebp)
c0102f07:	89 d0                	mov    %edx,%eax
c0102f09:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102f0c:	29 c2                	sub    %eax,%edx
c0102f0e:	89 d0                	mov    %edx,%eax
c0102f10:	a3 74 e9 11 c0       	mov    %eax,0xc011e974

    for (i = 0; i < npage; i ++) {
c0102f15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f1c:	eb 2f                	jmp    c0102f4d <page_init+0x1f9>
        SetPageReserved(pages + i);
c0102f1e:	8b 0d 74 e9 11 c0    	mov    0xc011e974,%ecx
c0102f24:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f27:	89 d0                	mov    %edx,%eax
c0102f29:	c1 e0 02             	shl    $0x2,%eax
c0102f2c:	01 d0                	add    %edx,%eax
c0102f2e:	c1 e0 02             	shl    $0x2,%eax
c0102f31:	01 c8                	add    %ecx,%eax
c0102f33:	83 c0 04             	add    $0x4,%eax
c0102f36:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102f3d:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f40:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f43:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102f46:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0102f49:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102f4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f50:	a1 c0 e8 11 c0       	mov    0xc011e8c0,%eax
c0102f55:	39 c2                	cmp    %eax,%edx
c0102f57:	72 c5                	jb     c0102f1e <page_init+0x1ca>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102f59:	8b 15 c0 e8 11 c0    	mov    0xc011e8c0,%edx
c0102f5f:	89 d0                	mov    %edx,%eax
c0102f61:	c1 e0 02             	shl    $0x2,%eax
c0102f64:	01 d0                	add    %edx,%eax
c0102f66:	c1 e0 02             	shl    $0x2,%eax
c0102f69:	89 c2                	mov    %eax,%edx
c0102f6b:	a1 74 e9 11 c0       	mov    0xc011e974,%eax
c0102f70:	01 d0                	add    %edx,%eax
c0102f72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102f75:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102f7c:	77 23                	ja     c0102fa1 <page_init+0x24d>
c0102f7e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102f81:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102f85:	c7 44 24 08 04 a6 10 	movl   $0xc010a604,0x8(%esp)
c0102f8c:	c0 
c0102f8d:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102f94:	00 
c0102f95:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0102f9c:	e8 47 d4 ff ff       	call   c01003e8 <__panic>
c0102fa1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102fa4:	05 00 00 00 40       	add    $0x40000000,%eax
c0102fa9:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102fac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102fb3:	e9 74 01 00 00       	jmp    c010312c <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102fb8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fbe:	89 d0                	mov    %edx,%eax
c0102fc0:	c1 e0 02             	shl    $0x2,%eax
c0102fc3:	01 d0                	add    %edx,%eax
c0102fc5:	c1 e0 02             	shl    $0x2,%eax
c0102fc8:	01 c8                	add    %ecx,%eax
c0102fca:	8b 50 08             	mov    0x8(%eax),%edx
c0102fcd:	8b 40 04             	mov    0x4(%eax),%eax
c0102fd0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102fd3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102fd6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fd9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fdc:	89 d0                	mov    %edx,%eax
c0102fde:	c1 e0 02             	shl    $0x2,%eax
c0102fe1:	01 d0                	add    %edx,%eax
c0102fe3:	c1 e0 02             	shl    $0x2,%eax
c0102fe6:	01 c8                	add    %ecx,%eax
c0102fe8:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102feb:	8b 58 10             	mov    0x10(%eax),%ebx
c0102fee:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ff1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ff4:	01 c8                	add    %ecx,%eax
c0102ff6:	11 da                	adc    %ebx,%edx
c0102ff8:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ffb:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102ffe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103001:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103004:	89 d0                	mov    %edx,%eax
c0103006:	c1 e0 02             	shl    $0x2,%eax
c0103009:	01 d0                	add    %edx,%eax
c010300b:	c1 e0 02             	shl    $0x2,%eax
c010300e:	01 c8                	add    %ecx,%eax
c0103010:	83 c0 14             	add    $0x14,%eax
c0103013:	8b 00                	mov    (%eax),%eax
c0103015:	83 f8 01             	cmp    $0x1,%eax
c0103018:	0f 85 0a 01 00 00    	jne    c0103128 <page_init+0x3d4>
            if (begin < freemem) {
c010301e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103021:	ba 00 00 00 00       	mov    $0x0,%edx
c0103026:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103029:	72 17                	jb     c0103042 <page_init+0x2ee>
c010302b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010302e:	77 05                	ja     c0103035 <page_init+0x2e1>
c0103030:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103033:	76 0d                	jbe    c0103042 <page_init+0x2ee>
                begin = freemem;
c0103035:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103038:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010303b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103042:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103046:	72 1d                	jb     c0103065 <page_init+0x311>
c0103048:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010304c:	77 09                	ja     c0103057 <page_init+0x303>
c010304e:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103055:	76 0e                	jbe    c0103065 <page_init+0x311>
                end = KMEMSIZE;
c0103057:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010305e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103065:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103068:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010306b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010306e:	0f 87 b4 00 00 00    	ja     c0103128 <page_init+0x3d4>
c0103074:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103077:	72 09                	jb     c0103082 <page_init+0x32e>
c0103079:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010307c:	0f 83 a6 00 00 00    	jae    c0103128 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0103082:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0103089:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010308c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010308f:	01 d0                	add    %edx,%eax
c0103091:	83 e8 01             	sub    $0x1,%eax
c0103094:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103097:	8b 45 98             	mov    -0x68(%ebp),%eax
c010309a:	ba 00 00 00 00       	mov    $0x0,%edx
c010309f:	f7 75 9c             	divl   -0x64(%ebp)
c01030a2:	89 d0                	mov    %edx,%eax
c01030a4:	8b 55 98             	mov    -0x68(%ebp),%edx
c01030a7:	29 c2                	sub    %eax,%edx
c01030a9:	89 d0                	mov    %edx,%eax
c01030ab:	ba 00 00 00 00       	mov    $0x0,%edx
c01030b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01030b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01030b9:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01030bc:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01030bf:	ba 00 00 00 00       	mov    $0x0,%edx
c01030c4:	89 c7                	mov    %eax,%edi
c01030c6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01030cc:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01030cf:	89 d0                	mov    %edx,%eax
c01030d1:	83 e0 00             	and    $0x0,%eax
c01030d4:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01030d7:	8b 45 80             	mov    -0x80(%ebp),%eax
c01030da:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01030dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01030e0:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01030e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01030e9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01030ec:	77 3a                	ja     c0103128 <page_init+0x3d4>
c01030ee:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01030f1:	72 05                	jb     c01030f8 <page_init+0x3a4>
c01030f3:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01030f6:	73 30                	jae    c0103128 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01030f8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01030fb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01030fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103101:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103104:	29 c8                	sub    %ecx,%eax
c0103106:	19 da                	sbb    %ebx,%edx
c0103108:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010310c:	c1 ea 0c             	shr    $0xc,%edx
c010310f:	89 c3                	mov    %eax,%ebx
c0103111:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103114:	89 04 24             	mov    %eax,(%esp)
c0103117:	e8 bd f8 ff ff       	call   c01029d9 <pa2page>
c010311c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103120:	89 04 24             	mov    %eax,(%esp)
c0103123:	e8 78 fb ff ff       	call   c0102ca0 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0103128:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010312c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010312f:	8b 00                	mov    (%eax),%eax
c0103131:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103134:	0f 8f 7e fe ff ff    	jg     c0102fb8 <page_init+0x264>
                }
            }
        }
    }
}
c010313a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103140:	5b                   	pop    %ebx
c0103141:	5e                   	pop    %esi
c0103142:	5f                   	pop    %edi
c0103143:	5d                   	pop    %ebp
c0103144:	c3                   	ret    

c0103145 <enable_paging>:

static void
enable_paging(void) {
c0103145:	55                   	push   %ebp
c0103146:	89 e5                	mov    %esp,%ebp
c0103148:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010314b:	a1 70 e9 11 c0       	mov    0xc011e970,%eax
c0103150:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0103153:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103156:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0103159:	0f 20 c0             	mov    %cr0,%eax
c010315c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c010315f:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103162:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0103165:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010316c:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0103170:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103173:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0103176:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103179:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010317c:	c9                   	leave  
c010317d:	c3                   	ret    

c010317e <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010317e:	55                   	push   %ebp
c010317f:	89 e5                	mov    %esp,%ebp
c0103181:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103184:	8b 45 14             	mov    0x14(%ebp),%eax
c0103187:	8b 55 0c             	mov    0xc(%ebp),%edx
c010318a:	31 d0                	xor    %edx,%eax
c010318c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103191:	85 c0                	test   %eax,%eax
c0103193:	74 24                	je     c01031b9 <boot_map_segment+0x3b>
c0103195:	c7 44 24 0c 36 a6 10 	movl   $0xc010a636,0xc(%esp)
c010319c:	c0 
c010319d:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c01031a4:	c0 
c01031a5:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01031ac:	00 
c01031ad:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c01031b4:	e8 2f d2 ff ff       	call   c01003e8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01031b9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01031c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031c3:	25 ff 0f 00 00       	and    $0xfff,%eax
c01031c8:	89 c2                	mov    %eax,%edx
c01031ca:	8b 45 10             	mov    0x10(%ebp),%eax
c01031cd:	01 c2                	add    %eax,%edx
c01031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031d2:	01 d0                	add    %edx,%eax
c01031d4:	83 e8 01             	sub    $0x1,%eax
c01031d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031dd:	ba 00 00 00 00       	mov    $0x0,%edx
c01031e2:	f7 75 f0             	divl   -0x10(%ebp)
c01031e5:	89 d0                	mov    %edx,%eax
c01031e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01031ea:	29 c2                	sub    %eax,%edx
c01031ec:	89 d0                	mov    %edx,%eax
c01031ee:	c1 e8 0c             	shr    $0xc,%eax
c01031f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01031f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01031fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01031fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103202:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103205:	8b 45 14             	mov    0x14(%ebp),%eax
c0103208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010320b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010320e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103213:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103216:	eb 6b                	jmp    c0103283 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103218:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010321f:	00 
c0103220:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103223:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103227:	8b 45 08             	mov    0x8(%ebp),%eax
c010322a:	89 04 24             	mov    %eax,(%esp)
c010322d:	e8 cc 01 00 00       	call   c01033fe <get_pte>
c0103232:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103235:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103239:	75 24                	jne    c010325f <boot_map_segment+0xe1>
c010323b:	c7 44 24 0c 62 a6 10 	movl   $0xc010a662,0xc(%esp)
c0103242:	c0 
c0103243:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c010324a:	c0 
c010324b:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0103252:	00 
c0103253:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c010325a:	e8 89 d1 ff ff       	call   c01003e8 <__panic>
        *ptep = pa | PTE_P | perm;
c010325f:	8b 45 18             	mov    0x18(%ebp),%eax
c0103262:	8b 55 14             	mov    0x14(%ebp),%edx
c0103265:	09 d0                	or     %edx,%eax
c0103267:	83 c8 01             	or     $0x1,%eax
c010326a:	89 c2                	mov    %eax,%edx
c010326c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010326f:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103271:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103275:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010327c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103287:	75 8f                	jne    c0103218 <boot_map_segment+0x9a>
    }
}
c0103289:	c9                   	leave  
c010328a:	c3                   	ret    

c010328b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010328b:	55                   	push   %ebp
c010328c:	89 e5                	mov    %esp,%ebp
c010328e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0103291:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103298:	e8 22 fa ff ff       	call   c0102cbf <alloc_pages>
c010329d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01032a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032a4:	75 1c                	jne    c01032c2 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01032a6:	c7 44 24 08 6f a6 10 	movl   $0xc010a66f,0x8(%esp)
c01032ad:	c0 
c01032ae:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c01032b5:	00 
c01032b6:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c01032bd:	e8 26 d1 ff ff       	call   c01003e8 <__panic>
    }
    return page2kva(p);
c01032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032c5:	89 04 24             	mov    %eax,(%esp)
c01032c8:	e8 5b f7 ff ff       	call   c0102a28 <page2kva>
}
c01032cd:	c9                   	leave  
c01032ce:	c3                   	ret    

c01032cf <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01032cf:	55                   	push   %ebp
c01032d0:	89 e5                	mov    %esp,%ebp
c01032d2:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01032d5:	e8 93 f9 ff ff       	call   c0102c6d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01032da:	e8 75 fa ff ff       	call   c0102d54 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01032df:	e8 66 04 00 00       	call   c010374a <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01032e4:	e8 a2 ff ff ff       	call   c010328b <boot_alloc_page>
c01032e9:	a3 c4 e8 11 c0       	mov    %eax,0xc011e8c4
    memset(boot_pgdir, 0, PGSIZE);
c01032ee:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c01032f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01032fa:	00 
c01032fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103302:	00 
c0103303:	89 04 24             	mov    %eax,(%esp)
c0103306:	e8 f7 62 00 00       	call   c0109602 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010330b:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103310:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103313:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010331a:	77 23                	ja     c010333f <pmm_init+0x70>
c010331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010331f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103323:	c7 44 24 08 04 a6 10 	movl   $0xc010a604,0x8(%esp)
c010332a:	c0 
c010332b:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0103332:	00 
c0103333:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c010333a:	e8 a9 d0 ff ff       	call   c01003e8 <__panic>
c010333f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103342:	05 00 00 00 40       	add    $0x40000000,%eax
c0103347:	a3 70 e9 11 c0       	mov    %eax,0xc011e970

    check_pgdir();
c010334c:	e8 17 04 00 00       	call   c0103768 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103351:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103356:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010335c:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103361:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103364:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010336b:	77 23                	ja     c0103390 <pmm_init+0xc1>
c010336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103370:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103374:	c7 44 24 08 04 a6 10 	movl   $0xc010a604,0x8(%esp)
c010337b:	c0 
c010337c:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0103383:	00 
c0103384:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c010338b:	e8 58 d0 ff ff       	call   c01003e8 <__panic>
c0103390:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103393:	05 00 00 00 40       	add    $0x40000000,%eax
c0103398:	83 c8 03             	or     $0x3,%eax
c010339b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010339d:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c01033a2:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01033a9:	00 
c01033aa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01033b1:	00 
c01033b2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01033b9:	38 
c01033ba:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01033c1:	c0 
c01033c2:	89 04 24             	mov    %eax,(%esp)
c01033c5:	e8 b4 fd ff ff       	call   c010317e <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01033ca:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c01033cf:	8b 15 c4 e8 11 c0    	mov    0xc011e8c4,%edx
c01033d5:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01033db:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01033dd:	e8 63 fd ff ff       	call   c0103145 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01033e2:	e8 97 f7 ff ff       	call   c0102b7e <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01033e7:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c01033ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01033f2:	e8 0c 0a 00 00       	call   c0103e03 <check_boot_pgdir>

    print_pgdir();
c01033f7:	e8 99 0e 00 00       	call   c0104295 <print_pgdir>

}
c01033fc:	c9                   	leave  
c01033fd:	c3                   	ret    

c01033fe <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01033fe:	55                   	push   %ebp
c01033ff:	89 e5                	mov    %esp,%ebp
c0103401:	83 ec 38             	sub    $0x38,%esp
     * typedef uintptr_t pte_t;
     * typedef uintptr_t pde_t;
     */
    //pgdir是一级页表本身,pde_t是一级页表的表项, pte_t表示二级页表的表项
    //pgdir给出页表起始地址。通过查找这个页表，我们可以得到一级页表项(二级页表的入口地址)。
    pde_t *pdep = &pgdir[PDX(la)];//根据虚地址的高十位查询页目录，找到页表项的pdep
c0103404:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103407:	c1 e8 16             	shr    $0x16,%eax
c010340a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103411:	8b 45 08             	mov    0x8(%ebp),%eax
c0103414:	01 d0                	add    %edx,%eax
c0103416:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0103419:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010341c:	8b 00                	mov    (%eax),%eax
c010341e:	83 e0 01             	and    $0x1,%eax
c0103421:	85 c0                	test   %eax,%eax
c0103423:	0f 85 af 00 00 00    	jne    c01034d8 <get_pte+0xda>
        //如果在查找二级页表项时，发现对应的二级页表不存在，则需要根据create参数的值来处理是否创建新的二级页表。
        struct  Page* page = alloc_page();
c0103429:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103430:	e8 8a f8 ff ff       	call   c0102cbf <alloc_pages>
c0103435:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(!create||page==NULL){
c0103438:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010343c:	74 06                	je     c0103444 <get_pte+0x46>
c010343e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103442:	75 0a                	jne    c010344e <get_pte+0x50>
            return NULL;
c0103444:	b8 00 00 00 00       	mov    $0x0,%eax
c0103449:	e9 e6 00 00 00       	jmp    c0103534 <get_pte+0x136>
        }                  
        set_page_ref(page,1);//引用次数加一
c010344e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103455:	00 
c0103456:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103459:	89 04 24             	mov    %eax,(%esp)
c010345c:	e8 63 f6 ff ff       	call   c0102ac4 <set_page_ref>
        uintptr_t pa = page2pa(page); //获取页的线性地址
c0103461:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103464:	89 04 24             	mov    %eax,(%esp)
c0103467:	e8 57 f5 ff ff       	call   c01029c3 <page2pa>
c010346c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa),0,PGSIZE);//初始化,新申请的页全设为零，因为这个页所代表的虚拟地址都没有被映射。
c010346f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103472:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103475:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103478:	c1 e8 0c             	shr    $0xc,%eax
c010347b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010347e:	a1 c0 e8 11 c0       	mov    0xc011e8c0,%eax
c0103483:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103486:	72 23                	jb     c01034ab <get_pte+0xad>
c0103488:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010348b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010348f:	c7 44 24 08 60 a5 10 	movl   $0xc010a560,0x8(%esp)
c0103496:	c0 
c0103497:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
c010349e:	00 
c010349f:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c01034a6:	e8 3d cf ff ff       	call   c01003e8 <__panic>
c01034ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034ae:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01034b3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01034ba:	00 
c01034bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01034c2:	00 
c01034c3:	89 04 24             	mov    %eax,(%esp)
c01034c6:	e8 37 61 00 00       	call   c0109602 <memset>
        *pdep=pa|PTE_U|PTE_W|PTE_P;//设置控制位
c01034cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034ce:	83 c8 07             	or     $0x7,%eax
c01034d1:	89 c2                	mov    %eax,%edx
c01034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d6:	89 10                	mov    %edx,(%eax)
    }
    //KADDR(PDE_ADDR(*pdep)):这部分是由页目录项地址得到关联的页表物理地址， 再转成虚拟地址。
    //PTX(la)：返回虚拟地址la的页表项索引
    //最后返回的是虚拟地址la对应的页表项入口地址  
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; 
c01034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034db:	8b 00                	mov    (%eax),%eax
c01034dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01034e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01034e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034e8:	c1 e8 0c             	shr    $0xc,%eax
c01034eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01034ee:	a1 c0 e8 11 c0       	mov    0xc011e8c0,%eax
c01034f3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01034f6:	72 23                	jb     c010351b <get_pte+0x11d>
c01034f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01034ff:	c7 44 24 08 60 a5 10 	movl   $0xc010a560,0x8(%esp)
c0103506:	c0 
c0103507:	c7 44 24 04 81 01 00 	movl   $0x181,0x4(%esp)
c010350e:	00 
c010350f:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103516:	e8 cd ce ff ff       	call   c01003e8 <__panic>
c010351b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010351e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103523:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103526:	c1 ea 0c             	shr    $0xc,%edx
c0103529:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c010352f:	c1 e2 02             	shl    $0x2,%edx
c0103532:	01 d0                	add    %edx,%eax
}
c0103534:	c9                   	leave  
c0103535:	c3                   	ret    

c0103536 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103536:	55                   	push   %ebp
c0103537:	89 e5                	mov    %esp,%ebp
c0103539:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010353c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103543:	00 
c0103544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103547:	89 44 24 04          	mov    %eax,0x4(%esp)
c010354b:	8b 45 08             	mov    0x8(%ebp),%eax
c010354e:	89 04 24             	mov    %eax,(%esp)
c0103551:	e8 a8 fe ff ff       	call   c01033fe <get_pte>
c0103556:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103559:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010355d:	74 08                	je     c0103567 <get_page+0x31>
        *ptep_store = ptep;
c010355f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103562:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103565:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010356b:	74 1b                	je     c0103588 <get_page+0x52>
c010356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103570:	8b 00                	mov    (%eax),%eax
c0103572:	83 e0 01             	and    $0x1,%eax
c0103575:	85 c0                	test   %eax,%eax
c0103577:	74 0f                	je     c0103588 <get_page+0x52>
        return pa2page(*ptep);
c0103579:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010357c:	8b 00                	mov    (%eax),%eax
c010357e:	89 04 24             	mov    %eax,(%esp)
c0103581:	e8 53 f4 ff ff       	call   c01029d9 <pa2page>
c0103586:	eb 05                	jmp    c010358d <get_page+0x57>
    }
    return NULL;
c0103588:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010358d:	c9                   	leave  
c010358e:	c3                   	ret    

c010358f <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010358f:	55                   	push   %ebp
c0103590:	89 e5                	mov    %esp,%ebp
c0103592:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     *                        当修改的页表是进程正在使用的那些页表，使之无效。
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    if (*ptep & PTE_P) {// 页表项存在
c0103595:	8b 45 10             	mov    0x10(%ebp),%eax
c0103598:	8b 00                	mov    (%eax),%eax
c010359a:	83 e0 01             	and    $0x1,%eax
c010359d:	85 c0                	test   %eax,%eax
c010359f:	74 4d                	je     c01035ee <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //找到页表项
c01035a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01035a4:	8b 00                	mov    (%eax),%eax
c01035a6:	89 04 24             	mov    %eax,(%esp)
c01035a9:	e8 ce f4 ff ff       	call   c0102a7c <pte2page>
c01035ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(page_ref_dec(page)==0)
c01035b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b4:	89 04 24             	mov    %eax,(%esp)
c01035b7:	e8 2c f5 ff ff       	call   c0102ae8 <page_ref_dec>
c01035bc:	85 c0                	test   %eax,%eax
c01035be:	75 13                	jne    c01035d3 <page_remove_pte+0x44>
        {//判断此页被引用的次数，如果仅仅被引用一次，则这个页也可以被释放。否则，只能释放页表入口
            free_page(page);//释放页
c01035c0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035c7:	00 
c01035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035cb:	89 04 24             	mov    %eax,(%esp)
c01035ce:	e8 24 f7 ff ff       	call   c0102cf7 <free_pages>
        }                         
        *ptep=0;//该页目录项清零
c01035d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01035d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir,la);//flush tlb
c01035dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01035e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01035e6:	89 04 24             	mov    %eax,(%esp)
c01035e9:	e8 ff 00 00 00       	call   c01036ed <tlb_invalidate>
    }
}
c01035ee:	c9                   	leave  
c01035ef:	c3                   	ret    

c01035f0 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01035f0:	55                   	push   %ebp
c01035f1:	89 e5                	mov    %esp,%ebp
c01035f3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01035f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01035fd:	00 
c01035fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103601:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103605:	8b 45 08             	mov    0x8(%ebp),%eax
c0103608:	89 04 24             	mov    %eax,(%esp)
c010360b:	e8 ee fd ff ff       	call   c01033fe <get_pte>
c0103610:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103617:	74 19                	je     c0103632 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0103619:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010361c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103620:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103623:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103627:	8b 45 08             	mov    0x8(%ebp),%eax
c010362a:	89 04 24             	mov    %eax,(%esp)
c010362d:	e8 5d ff ff ff       	call   c010358f <page_remove_pte>
    }
}
c0103632:	c9                   	leave  
c0103633:	c3                   	ret    

c0103634 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103634:	55                   	push   %ebp
c0103635:	89 e5                	mov    %esp,%ebp
c0103637:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010363a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103641:	00 
c0103642:	8b 45 10             	mov    0x10(%ebp),%eax
c0103645:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103649:	8b 45 08             	mov    0x8(%ebp),%eax
c010364c:	89 04 24             	mov    %eax,(%esp)
c010364f:	e8 aa fd ff ff       	call   c01033fe <get_pte>
c0103654:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010365b:	75 0a                	jne    c0103667 <page_insert+0x33>
        return -E_NO_MEM;
c010365d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103662:	e9 84 00 00 00       	jmp    c01036eb <page_insert+0xb7>
    }
    page_ref_inc(page);
c0103667:	8b 45 0c             	mov    0xc(%ebp),%eax
c010366a:	89 04 24             	mov    %eax,(%esp)
c010366d:	e8 5f f4 ff ff       	call   c0102ad1 <page_ref_inc>
    if (*ptep & PTE_P) {
c0103672:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103675:	8b 00                	mov    (%eax),%eax
c0103677:	83 e0 01             	and    $0x1,%eax
c010367a:	85 c0                	test   %eax,%eax
c010367c:	74 3e                	je     c01036bc <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103681:	8b 00                	mov    (%eax),%eax
c0103683:	89 04 24             	mov    %eax,(%esp)
c0103686:	e8 f1 f3 ff ff       	call   c0102a7c <pte2page>
c010368b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010368e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103691:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103694:	75 0d                	jne    c01036a3 <page_insert+0x6f>
            page_ref_dec(page);
c0103696:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103699:	89 04 24             	mov    %eax,(%esp)
c010369c:	e8 47 f4 ff ff       	call   c0102ae8 <page_ref_dec>
c01036a1:	eb 19                	jmp    c01036bc <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036a6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01036aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01036ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01036b4:	89 04 24             	mov    %eax,(%esp)
c01036b7:	e8 d3 fe ff ff       	call   c010358f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01036bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036bf:	89 04 24             	mov    %eax,(%esp)
c01036c2:	e8 fc f2 ff ff       	call   c01029c3 <page2pa>
c01036c7:	0b 45 14             	or     0x14(%ebp),%eax
c01036ca:	83 c8 01             	or     $0x1,%eax
c01036cd:	89 c2                	mov    %eax,%edx
c01036cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036d2:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01036d4:	8b 45 10             	mov    0x10(%ebp),%eax
c01036d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036db:	8b 45 08             	mov    0x8(%ebp),%eax
c01036de:	89 04 24             	mov    %eax,(%esp)
c01036e1:	e8 07 00 00 00       	call   c01036ed <tlb_invalidate>
    return 0;
c01036e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01036eb:	c9                   	leave  
c01036ec:	c3                   	ret    

c01036ed <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01036ed:	55                   	push   %ebp
c01036ee:	89 e5                	mov    %esp,%ebp
c01036f0:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01036f3:	0f 20 d8             	mov    %cr3,%eax
c01036f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01036f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01036fc:	89 c2                	mov    %eax,%edx
c01036fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103701:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103704:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010370b:	77 23                	ja     c0103730 <tlb_invalidate+0x43>
c010370d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103710:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103714:	c7 44 24 08 04 a6 10 	movl   $0xc010a604,0x8(%esp)
c010371b:	c0 
c010371c:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
c0103723:	00 
c0103724:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c010372b:	e8 b8 cc ff ff       	call   c01003e8 <__panic>
c0103730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103733:	05 00 00 00 40       	add    $0x40000000,%eax
c0103738:	39 c2                	cmp    %eax,%edx
c010373a:	75 0c                	jne    c0103748 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010373c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010373f:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103742:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103745:	0f 01 38             	invlpg (%eax)
    }
}
c0103748:	c9                   	leave  
c0103749:	c3                   	ret    

c010374a <check_alloc_page>:

static void
check_alloc_page(void) {
c010374a:	55                   	push   %ebp
c010374b:	89 e5                	mov    %esp,%ebp
c010374d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0103750:	a1 6c e9 11 c0       	mov    0xc011e96c,%eax
c0103755:	8b 40 18             	mov    0x18(%eax),%eax
c0103758:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010375a:	c7 04 24 88 a6 10 c0 	movl   $0xc010a688,(%esp)
c0103761:	e8 2b cb ff ff       	call   c0100291 <cprintf>
}
c0103766:	c9                   	leave  
c0103767:	c3                   	ret    

c0103768 <check_pgdir>:

static void
check_pgdir(void) {
c0103768:	55                   	push   %ebp
c0103769:	89 e5                	mov    %esp,%ebp
c010376b:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010376e:	a1 c0 e8 11 c0       	mov    0xc011e8c0,%eax
c0103773:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103778:	76 24                	jbe    c010379e <check_pgdir+0x36>
c010377a:	c7 44 24 0c a7 a6 10 	movl   $0xc010a6a7,0xc(%esp)
c0103781:	c0 
c0103782:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103789:	c0 
c010378a:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0103791:	00 
c0103792:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103799:	e8 4a cc ff ff       	call   c01003e8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010379e:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c01037a3:	85 c0                	test   %eax,%eax
c01037a5:	74 0e                	je     c01037b5 <check_pgdir+0x4d>
c01037a7:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c01037ac:	25 ff 0f 00 00       	and    $0xfff,%eax
c01037b1:	85 c0                	test   %eax,%eax
c01037b3:	74 24                	je     c01037d9 <check_pgdir+0x71>
c01037b5:	c7 44 24 0c c4 a6 10 	movl   $0xc010a6c4,0xc(%esp)
c01037bc:	c0 
c01037bd:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c01037c4:	c0 
c01037c5:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c01037cc:	00 
c01037cd:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c01037d4:	e8 0f cc ff ff       	call   c01003e8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01037d9:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c01037de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037e5:	00 
c01037e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01037ed:	00 
c01037ee:	89 04 24             	mov    %eax,(%esp)
c01037f1:	e8 40 fd ff ff       	call   c0103536 <get_page>
c01037f6:	85 c0                	test   %eax,%eax
c01037f8:	74 24                	je     c010381e <check_pgdir+0xb6>
c01037fa:	c7 44 24 0c fc a6 10 	movl   $0xc010a6fc,0xc(%esp)
c0103801:	c0 
c0103802:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103809:	c0 
c010380a:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0103811:	00 
c0103812:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103819:	e8 ca cb ff ff       	call   c01003e8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010381e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103825:	e8 95 f4 ff ff       	call   c0102cbf <alloc_pages>
c010382a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010382d:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103832:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103839:	00 
c010383a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103841:	00 
c0103842:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103845:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103849:	89 04 24             	mov    %eax,(%esp)
c010384c:	e8 e3 fd ff ff       	call   c0103634 <page_insert>
c0103851:	85 c0                	test   %eax,%eax
c0103853:	74 24                	je     c0103879 <check_pgdir+0x111>
c0103855:	c7 44 24 0c 24 a7 10 	movl   $0xc010a724,0xc(%esp)
c010385c:	c0 
c010385d:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103864:	c0 
c0103865:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c010386c:	00 
c010386d:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103874:	e8 6f cb ff ff       	call   c01003e8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103879:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c010387e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103885:	00 
c0103886:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010388d:	00 
c010388e:	89 04 24             	mov    %eax,(%esp)
c0103891:	e8 68 fb ff ff       	call   c01033fe <get_pte>
c0103896:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010389d:	75 24                	jne    c01038c3 <check_pgdir+0x15b>
c010389f:	c7 44 24 0c 50 a7 10 	movl   $0xc010a750,0xc(%esp)
c01038a6:	c0 
c01038a7:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c01038ae:	c0 
c01038af:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c01038b6:	00 
c01038b7:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c01038be:	e8 25 cb ff ff       	call   c01003e8 <__panic>
    assert(pa2page(*ptep) == p1);
c01038c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038c6:	8b 00                	mov    (%eax),%eax
c01038c8:	89 04 24             	mov    %eax,(%esp)
c01038cb:	e8 09 f1 ff ff       	call   c01029d9 <pa2page>
c01038d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01038d3:	74 24                	je     c01038f9 <check_pgdir+0x191>
c01038d5:	c7 44 24 0c 7d a7 10 	movl   $0xc010a77d,0xc(%esp)
c01038dc:	c0 
c01038dd:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c01038e4:	c0 
c01038e5:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c01038ec:	00 
c01038ed:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c01038f4:	e8 ef ca ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p1) == 1);
c01038f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038fc:	89 04 24             	mov    %eax,(%esp)
c01038ff:	e8 b6 f1 ff ff       	call   c0102aba <page_ref>
c0103904:	83 f8 01             	cmp    $0x1,%eax
c0103907:	74 24                	je     c010392d <check_pgdir+0x1c5>
c0103909:	c7 44 24 0c 92 a7 10 	movl   $0xc010a792,0xc(%esp)
c0103910:	c0 
c0103911:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103918:	c0 
c0103919:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103920:	00 
c0103921:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103928:	e8 bb ca ff ff       	call   c01003e8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010392d:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103932:	8b 00                	mov    (%eax),%eax
c0103934:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103939:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010393c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010393f:	c1 e8 0c             	shr    $0xc,%eax
c0103942:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103945:	a1 c0 e8 11 c0       	mov    0xc011e8c0,%eax
c010394a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010394d:	72 23                	jb     c0103972 <check_pgdir+0x20a>
c010394f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103952:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103956:	c7 44 24 08 60 a5 10 	movl   $0xc010a560,0x8(%esp)
c010395d:	c0 
c010395e:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0103965:	00 
c0103966:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c010396d:	e8 76 ca ff ff       	call   c01003e8 <__panic>
c0103972:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103975:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010397a:	83 c0 04             	add    $0x4,%eax
c010397d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103980:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103985:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010398c:	00 
c010398d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103994:	00 
c0103995:	89 04 24             	mov    %eax,(%esp)
c0103998:	e8 61 fa ff ff       	call   c01033fe <get_pte>
c010399d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01039a0:	74 24                	je     c01039c6 <check_pgdir+0x25e>
c01039a2:	c7 44 24 0c a4 a7 10 	movl   $0xc010a7a4,0xc(%esp)
c01039a9:	c0 
c01039aa:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c01039b1:	c0 
c01039b2:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c01039b9:	00 
c01039ba:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c01039c1:	e8 22 ca ff ff       	call   c01003e8 <__panic>

    p2 = alloc_page();
c01039c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039cd:	e8 ed f2 ff ff       	call   c0102cbf <alloc_pages>
c01039d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01039d5:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c01039da:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01039e1:	00 
c01039e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01039e9:	00 
c01039ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01039ed:	89 54 24 04          	mov    %edx,0x4(%esp)
c01039f1:	89 04 24             	mov    %eax,(%esp)
c01039f4:	e8 3b fc ff ff       	call   c0103634 <page_insert>
c01039f9:	85 c0                	test   %eax,%eax
c01039fb:	74 24                	je     c0103a21 <check_pgdir+0x2b9>
c01039fd:	c7 44 24 0c cc a7 10 	movl   $0xc010a7cc,0xc(%esp)
c0103a04:	c0 
c0103a05:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103a0c:	c0 
c0103a0d:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0103a14:	00 
c0103a15:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103a1c:	e8 c7 c9 ff ff       	call   c01003e8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a21:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103a26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a2d:	00 
c0103a2e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103a35:	00 
c0103a36:	89 04 24             	mov    %eax,(%esp)
c0103a39:	e8 c0 f9 ff ff       	call   c01033fe <get_pte>
c0103a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a45:	75 24                	jne    c0103a6b <check_pgdir+0x303>
c0103a47:	c7 44 24 0c 04 a8 10 	movl   $0xc010a804,0xc(%esp)
c0103a4e:	c0 
c0103a4f:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103a56:	c0 
c0103a57:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103a5e:	00 
c0103a5f:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103a66:	e8 7d c9 ff ff       	call   c01003e8 <__panic>
    assert(*ptep & PTE_U);
c0103a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a6e:	8b 00                	mov    (%eax),%eax
c0103a70:	83 e0 04             	and    $0x4,%eax
c0103a73:	85 c0                	test   %eax,%eax
c0103a75:	75 24                	jne    c0103a9b <check_pgdir+0x333>
c0103a77:	c7 44 24 0c 34 a8 10 	movl   $0xc010a834,0xc(%esp)
c0103a7e:	c0 
c0103a7f:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103a86:	c0 
c0103a87:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0103a8e:	00 
c0103a8f:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103a96:	e8 4d c9 ff ff       	call   c01003e8 <__panic>
    assert(*ptep & PTE_W);
c0103a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a9e:	8b 00                	mov    (%eax),%eax
c0103aa0:	83 e0 02             	and    $0x2,%eax
c0103aa3:	85 c0                	test   %eax,%eax
c0103aa5:	75 24                	jne    c0103acb <check_pgdir+0x363>
c0103aa7:	c7 44 24 0c 42 a8 10 	movl   $0xc010a842,0xc(%esp)
c0103aae:	c0 
c0103aaf:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103ab6:	c0 
c0103ab7:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103abe:	00 
c0103abf:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103ac6:	e8 1d c9 ff ff       	call   c01003e8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103acb:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103ad0:	8b 00                	mov    (%eax),%eax
c0103ad2:	83 e0 04             	and    $0x4,%eax
c0103ad5:	85 c0                	test   %eax,%eax
c0103ad7:	75 24                	jne    c0103afd <check_pgdir+0x395>
c0103ad9:	c7 44 24 0c 50 a8 10 	movl   $0xc010a850,0xc(%esp)
c0103ae0:	c0 
c0103ae1:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103ae8:	c0 
c0103ae9:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0103af0:	00 
c0103af1:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103af8:	e8 eb c8 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p2) == 1);
c0103afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b00:	89 04 24             	mov    %eax,(%esp)
c0103b03:	e8 b2 ef ff ff       	call   c0102aba <page_ref>
c0103b08:	83 f8 01             	cmp    $0x1,%eax
c0103b0b:	74 24                	je     c0103b31 <check_pgdir+0x3c9>
c0103b0d:	c7 44 24 0c 66 a8 10 	movl   $0xc010a866,0xc(%esp)
c0103b14:	c0 
c0103b15:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103b1c:	c0 
c0103b1d:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0103b24:	00 
c0103b25:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103b2c:	e8 b7 c8 ff ff       	call   c01003e8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103b31:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103b36:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103b3d:	00 
c0103b3e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103b45:	00 
c0103b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b49:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b4d:	89 04 24             	mov    %eax,(%esp)
c0103b50:	e8 df fa ff ff       	call   c0103634 <page_insert>
c0103b55:	85 c0                	test   %eax,%eax
c0103b57:	74 24                	je     c0103b7d <check_pgdir+0x415>
c0103b59:	c7 44 24 0c 78 a8 10 	movl   $0xc010a878,0xc(%esp)
c0103b60:	c0 
c0103b61:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103b68:	c0 
c0103b69:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0103b70:	00 
c0103b71:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103b78:	e8 6b c8 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p1) == 2);
c0103b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b80:	89 04 24             	mov    %eax,(%esp)
c0103b83:	e8 32 ef ff ff       	call   c0102aba <page_ref>
c0103b88:	83 f8 02             	cmp    $0x2,%eax
c0103b8b:	74 24                	je     c0103bb1 <check_pgdir+0x449>
c0103b8d:	c7 44 24 0c a4 a8 10 	movl   $0xc010a8a4,0xc(%esp)
c0103b94:	c0 
c0103b95:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103b9c:	c0 
c0103b9d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0103ba4:	00 
c0103ba5:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103bac:	e8 37 c8 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p2) == 0);
c0103bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bb4:	89 04 24             	mov    %eax,(%esp)
c0103bb7:	e8 fe ee ff ff       	call   c0102aba <page_ref>
c0103bbc:	85 c0                	test   %eax,%eax
c0103bbe:	74 24                	je     c0103be4 <check_pgdir+0x47c>
c0103bc0:	c7 44 24 0c b6 a8 10 	movl   $0xc010a8b6,0xc(%esp)
c0103bc7:	c0 
c0103bc8:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103bcf:	c0 
c0103bd0:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103bd7:	00 
c0103bd8:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103bdf:	e8 04 c8 ff ff       	call   c01003e8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103be4:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103be9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103bf0:	00 
c0103bf1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103bf8:	00 
c0103bf9:	89 04 24             	mov    %eax,(%esp)
c0103bfc:	e8 fd f7 ff ff       	call   c01033fe <get_pte>
c0103c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c08:	75 24                	jne    c0103c2e <check_pgdir+0x4c6>
c0103c0a:	c7 44 24 0c 04 a8 10 	movl   $0xc010a804,0xc(%esp)
c0103c11:	c0 
c0103c12:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103c19:	c0 
c0103c1a:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0103c21:	00 
c0103c22:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103c29:	e8 ba c7 ff ff       	call   c01003e8 <__panic>
    assert(pa2page(*ptep) == p1);
c0103c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c31:	8b 00                	mov    (%eax),%eax
c0103c33:	89 04 24             	mov    %eax,(%esp)
c0103c36:	e8 9e ed ff ff       	call   c01029d9 <pa2page>
c0103c3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103c3e:	74 24                	je     c0103c64 <check_pgdir+0x4fc>
c0103c40:	c7 44 24 0c 7d a7 10 	movl   $0xc010a77d,0xc(%esp)
c0103c47:	c0 
c0103c48:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103c4f:	c0 
c0103c50:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0103c57:	00 
c0103c58:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103c5f:	e8 84 c7 ff ff       	call   c01003e8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c67:	8b 00                	mov    (%eax),%eax
c0103c69:	83 e0 04             	and    $0x4,%eax
c0103c6c:	85 c0                	test   %eax,%eax
c0103c6e:	74 24                	je     c0103c94 <check_pgdir+0x52c>
c0103c70:	c7 44 24 0c c8 a8 10 	movl   $0xc010a8c8,0xc(%esp)
c0103c77:	c0 
c0103c78:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103c7f:	c0 
c0103c80:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0103c87:	00 
c0103c88:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103c8f:	e8 54 c7 ff ff       	call   c01003e8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103c94:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103c99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103ca0:	00 
c0103ca1:	89 04 24             	mov    %eax,(%esp)
c0103ca4:	e8 47 f9 ff ff       	call   c01035f0 <page_remove>
    assert(page_ref(p1) == 1);
c0103ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cac:	89 04 24             	mov    %eax,(%esp)
c0103caf:	e8 06 ee ff ff       	call   c0102aba <page_ref>
c0103cb4:	83 f8 01             	cmp    $0x1,%eax
c0103cb7:	74 24                	je     c0103cdd <check_pgdir+0x575>
c0103cb9:	c7 44 24 0c 92 a7 10 	movl   $0xc010a792,0xc(%esp)
c0103cc0:	c0 
c0103cc1:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103cc8:	c0 
c0103cc9:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103cd0:	00 
c0103cd1:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103cd8:	e8 0b c7 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p2) == 0);
c0103cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ce0:	89 04 24             	mov    %eax,(%esp)
c0103ce3:	e8 d2 ed ff ff       	call   c0102aba <page_ref>
c0103ce8:	85 c0                	test   %eax,%eax
c0103cea:	74 24                	je     c0103d10 <check_pgdir+0x5a8>
c0103cec:	c7 44 24 0c b6 a8 10 	movl   $0xc010a8b6,0xc(%esp)
c0103cf3:	c0 
c0103cf4:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103cfb:	c0 
c0103cfc:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0103d03:	00 
c0103d04:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103d0b:	e8 d8 c6 ff ff       	call   c01003e8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103d10:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103d15:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103d1c:	00 
c0103d1d:	89 04 24             	mov    %eax,(%esp)
c0103d20:	e8 cb f8 ff ff       	call   c01035f0 <page_remove>
    assert(page_ref(p1) == 0);
c0103d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d28:	89 04 24             	mov    %eax,(%esp)
c0103d2b:	e8 8a ed ff ff       	call   c0102aba <page_ref>
c0103d30:	85 c0                	test   %eax,%eax
c0103d32:	74 24                	je     c0103d58 <check_pgdir+0x5f0>
c0103d34:	c7 44 24 0c dd a8 10 	movl   $0xc010a8dd,0xc(%esp)
c0103d3b:	c0 
c0103d3c:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103d43:	c0 
c0103d44:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0103d4b:	00 
c0103d4c:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103d53:	e8 90 c6 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p2) == 0);
c0103d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d5b:	89 04 24             	mov    %eax,(%esp)
c0103d5e:	e8 57 ed ff ff       	call   c0102aba <page_ref>
c0103d63:	85 c0                	test   %eax,%eax
c0103d65:	74 24                	je     c0103d8b <check_pgdir+0x623>
c0103d67:	c7 44 24 0c b6 a8 10 	movl   $0xc010a8b6,0xc(%esp)
c0103d6e:	c0 
c0103d6f:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103d76:	c0 
c0103d77:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0103d7e:	00 
c0103d7f:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103d86:	e8 5d c6 ff ff       	call   c01003e8 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0103d8b:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103d90:	8b 00                	mov    (%eax),%eax
c0103d92:	89 04 24             	mov    %eax,(%esp)
c0103d95:	e8 3f ec ff ff       	call   c01029d9 <pa2page>
c0103d9a:	89 04 24             	mov    %eax,(%esp)
c0103d9d:	e8 18 ed ff ff       	call   c0102aba <page_ref>
c0103da2:	83 f8 01             	cmp    $0x1,%eax
c0103da5:	74 24                	je     c0103dcb <check_pgdir+0x663>
c0103da7:	c7 44 24 0c f0 a8 10 	movl   $0xc010a8f0,0xc(%esp)
c0103dae:	c0 
c0103daf:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103db6:	c0 
c0103db7:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0103dbe:	00 
c0103dbf:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103dc6:	e8 1d c6 ff ff       	call   c01003e8 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0103dcb:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103dd0:	8b 00                	mov    (%eax),%eax
c0103dd2:	89 04 24             	mov    %eax,(%esp)
c0103dd5:	e8 ff eb ff ff       	call   c01029d9 <pa2page>
c0103dda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103de1:	00 
c0103de2:	89 04 24             	mov    %eax,(%esp)
c0103de5:	e8 0d ef ff ff       	call   c0102cf7 <free_pages>
    boot_pgdir[0] = 0;
c0103dea:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103def:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103df5:	c7 04 24 16 a9 10 c0 	movl   $0xc010a916,(%esp)
c0103dfc:	e8 90 c4 ff ff       	call   c0100291 <cprintf>
}
c0103e01:	c9                   	leave  
c0103e02:	c3                   	ret    

c0103e03 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103e03:	55                   	push   %ebp
c0103e04:	89 e5                	mov    %esp,%ebp
c0103e06:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103e09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103e10:	e9 ca 00 00 00       	jmp    c0103edf <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e1e:	c1 e8 0c             	shr    $0xc,%eax
c0103e21:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103e24:	a1 c0 e8 11 c0       	mov    0xc011e8c0,%eax
c0103e29:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103e2c:	72 23                	jb     c0103e51 <check_boot_pgdir+0x4e>
c0103e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e31:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e35:	c7 44 24 08 60 a5 10 	movl   $0xc010a560,0x8(%esp)
c0103e3c:	c0 
c0103e3d:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0103e44:	00 
c0103e45:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103e4c:	e8 97 c5 ff ff       	call   c01003e8 <__panic>
c0103e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e54:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103e59:	89 c2                	mov    %eax,%edx
c0103e5b:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103e60:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103e67:	00 
c0103e68:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e6c:	89 04 24             	mov    %eax,(%esp)
c0103e6f:	e8 8a f5 ff ff       	call   c01033fe <get_pte>
c0103e74:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103e77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103e7b:	75 24                	jne    c0103ea1 <check_boot_pgdir+0x9e>
c0103e7d:	c7 44 24 0c 30 a9 10 	movl   $0xc010a930,0xc(%esp)
c0103e84:	c0 
c0103e85:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103e8c:	c0 
c0103e8d:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0103e94:	00 
c0103e95:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103e9c:	e8 47 c5 ff ff       	call   c01003e8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ea4:	8b 00                	mov    (%eax),%eax
c0103ea6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103eab:	89 c2                	mov    %eax,%edx
c0103ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103eb0:	39 c2                	cmp    %eax,%edx
c0103eb2:	74 24                	je     c0103ed8 <check_boot_pgdir+0xd5>
c0103eb4:	c7 44 24 0c 6d a9 10 	movl   $0xc010a96d,0xc(%esp)
c0103ebb:	c0 
c0103ebc:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103ec3:	c0 
c0103ec4:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0103ecb:	00 
c0103ecc:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103ed3:	e8 10 c5 ff ff       	call   c01003e8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103ed8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ee2:	a1 c0 e8 11 c0       	mov    0xc011e8c0,%eax
c0103ee7:	39 c2                	cmp    %eax,%edx
c0103ee9:	0f 82 26 ff ff ff    	jb     c0103e15 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103eef:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103ef4:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103ef9:	8b 00                	mov    (%eax),%eax
c0103efb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103f00:	89 c2                	mov    %eax,%edx
c0103f02:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103f07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f0a:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103f11:	77 23                	ja     c0103f36 <check_boot_pgdir+0x133>
c0103f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f16:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f1a:	c7 44 24 08 04 a6 10 	movl   $0xc010a604,0x8(%esp)
c0103f21:	c0 
c0103f22:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0103f29:	00 
c0103f2a:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103f31:	e8 b2 c4 ff ff       	call   c01003e8 <__panic>
c0103f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f39:	05 00 00 00 40       	add    $0x40000000,%eax
c0103f3e:	39 c2                	cmp    %eax,%edx
c0103f40:	74 24                	je     c0103f66 <check_boot_pgdir+0x163>
c0103f42:	c7 44 24 0c 84 a9 10 	movl   $0xc010a984,0xc(%esp)
c0103f49:	c0 
c0103f4a:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103f51:	c0 
c0103f52:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0103f59:	00 
c0103f5a:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103f61:	e8 82 c4 ff ff       	call   c01003e8 <__panic>

    assert(boot_pgdir[0] == 0);
c0103f66:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103f6b:	8b 00                	mov    (%eax),%eax
c0103f6d:	85 c0                	test   %eax,%eax
c0103f6f:	74 24                	je     c0103f95 <check_boot_pgdir+0x192>
c0103f71:	c7 44 24 0c b8 a9 10 	movl   $0xc010a9b8,0xc(%esp)
c0103f78:	c0 
c0103f79:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103f80:	c0 
c0103f81:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0103f88:	00 
c0103f89:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103f90:	e8 53 c4 ff ff       	call   c01003e8 <__panic>

    struct Page *p;
    p = alloc_page();
c0103f95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f9c:	e8 1e ed ff ff       	call   c0102cbf <alloc_pages>
c0103fa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103fa4:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0103fa9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103fb0:	00 
c0103fb1:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103fb8:	00 
c0103fb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103fbc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fc0:	89 04 24             	mov    %eax,(%esp)
c0103fc3:	e8 6c f6 ff ff       	call   c0103634 <page_insert>
c0103fc8:	85 c0                	test   %eax,%eax
c0103fca:	74 24                	je     c0103ff0 <check_boot_pgdir+0x1ed>
c0103fcc:	c7 44 24 0c cc a9 10 	movl   $0xc010a9cc,0xc(%esp)
c0103fd3:	c0 
c0103fd4:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c0103fdb:	c0 
c0103fdc:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0103fe3:	00 
c0103fe4:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0103feb:	e8 f8 c3 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p) == 1);
c0103ff0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ff3:	89 04 24             	mov    %eax,(%esp)
c0103ff6:	e8 bf ea ff ff       	call   c0102aba <page_ref>
c0103ffb:	83 f8 01             	cmp    $0x1,%eax
c0103ffe:	74 24                	je     c0104024 <check_boot_pgdir+0x221>
c0104000:	c7 44 24 0c fa a9 10 	movl   $0xc010a9fa,0xc(%esp)
c0104007:	c0 
c0104008:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c010400f:	c0 
c0104010:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0104017:	00 
c0104018:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c010401f:	e8 c4 c3 ff ff       	call   c01003e8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104024:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0104029:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104030:	00 
c0104031:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104038:	00 
c0104039:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010403c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104040:	89 04 24             	mov    %eax,(%esp)
c0104043:	e8 ec f5 ff ff       	call   c0103634 <page_insert>
c0104048:	85 c0                	test   %eax,%eax
c010404a:	74 24                	je     c0104070 <check_boot_pgdir+0x26d>
c010404c:	c7 44 24 0c 0c aa 10 	movl   $0xc010aa0c,0xc(%esp)
c0104053:	c0 
c0104054:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c010405b:	c0 
c010405c:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0104063:	00 
c0104064:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c010406b:	e8 78 c3 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p) == 2);
c0104070:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104073:	89 04 24             	mov    %eax,(%esp)
c0104076:	e8 3f ea ff ff       	call   c0102aba <page_ref>
c010407b:	83 f8 02             	cmp    $0x2,%eax
c010407e:	74 24                	je     c01040a4 <check_boot_pgdir+0x2a1>
c0104080:	c7 44 24 0c 43 aa 10 	movl   $0xc010aa43,0xc(%esp)
c0104087:	c0 
c0104088:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c010408f:	c0 
c0104090:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0104097:	00 
c0104098:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c010409f:	e8 44 c3 ff ff       	call   c01003e8 <__panic>

    const char *str = "ucore: Hello world!!";
c01040a4:	c7 45 dc 54 aa 10 c0 	movl   $0xc010aa54,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01040ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01040b2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01040b9:	e8 6d 52 00 00       	call   c010932b <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01040be:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01040c5:	00 
c01040c6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01040cd:	e8 d2 52 00 00       	call   c01093a4 <strcmp>
c01040d2:	85 c0                	test   %eax,%eax
c01040d4:	74 24                	je     c01040fa <check_boot_pgdir+0x2f7>
c01040d6:	c7 44 24 0c 6c aa 10 	movl   $0xc010aa6c,0xc(%esp)
c01040dd:	c0 
c01040de:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c01040e5:	c0 
c01040e6:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c01040ed:	00 
c01040ee:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c01040f5:	e8 ee c2 ff ff       	call   c01003e8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01040fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040fd:	89 04 24             	mov    %eax,(%esp)
c0104100:	e8 23 e9 ff ff       	call   c0102a28 <page2kva>
c0104105:	05 00 01 00 00       	add    $0x100,%eax
c010410a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010410d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104114:	e8 ba 51 00 00       	call   c01092d3 <strlen>
c0104119:	85 c0                	test   %eax,%eax
c010411b:	74 24                	je     c0104141 <check_boot_pgdir+0x33e>
c010411d:	c7 44 24 0c a4 aa 10 	movl   $0xc010aaa4,0xc(%esp)
c0104124:	c0 
c0104125:	c7 44 24 08 4d a6 10 	movl   $0xc010a64d,0x8(%esp)
c010412c:	c0 
c010412d:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104134:	00 
c0104135:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c010413c:	e8 a7 c2 ff ff       	call   c01003e8 <__panic>

    free_page(p);
c0104141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104148:	00 
c0104149:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010414c:	89 04 24             	mov    %eax,(%esp)
c010414f:	e8 a3 eb ff ff       	call   c0102cf7 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0104154:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c0104159:	8b 00                	mov    (%eax),%eax
c010415b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104160:	89 04 24             	mov    %eax,(%esp)
c0104163:	e8 71 e8 ff ff       	call   c01029d9 <pa2page>
c0104168:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010416f:	00 
c0104170:	89 04 24             	mov    %eax,(%esp)
c0104173:	e8 7f eb ff ff       	call   c0102cf7 <free_pages>
    boot_pgdir[0] = 0;
c0104178:	a1 c4 e8 11 c0       	mov    0xc011e8c4,%eax
c010417d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104183:	c7 04 24 c8 aa 10 c0 	movl   $0xc010aac8,(%esp)
c010418a:	e8 02 c1 ff ff       	call   c0100291 <cprintf>
}
c010418f:	c9                   	leave  
c0104190:	c3                   	ret    

c0104191 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104191:	55                   	push   %ebp
c0104192:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104194:	8b 45 08             	mov    0x8(%ebp),%eax
c0104197:	83 e0 04             	and    $0x4,%eax
c010419a:	85 c0                	test   %eax,%eax
c010419c:	74 07                	je     c01041a5 <perm2str+0x14>
c010419e:	b8 75 00 00 00       	mov    $0x75,%eax
c01041a3:	eb 05                	jmp    c01041aa <perm2str+0x19>
c01041a5:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01041aa:	a2 48 e9 11 c0       	mov    %al,0xc011e948
    str[1] = 'r';
c01041af:	c6 05 49 e9 11 c0 72 	movb   $0x72,0xc011e949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01041b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01041b9:	83 e0 02             	and    $0x2,%eax
c01041bc:	85 c0                	test   %eax,%eax
c01041be:	74 07                	je     c01041c7 <perm2str+0x36>
c01041c0:	b8 77 00 00 00       	mov    $0x77,%eax
c01041c5:	eb 05                	jmp    c01041cc <perm2str+0x3b>
c01041c7:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01041cc:	a2 4a e9 11 c0       	mov    %al,0xc011e94a
    str[3] = '\0';
c01041d1:	c6 05 4b e9 11 c0 00 	movb   $0x0,0xc011e94b
    return str;
c01041d8:	b8 48 e9 11 c0       	mov    $0xc011e948,%eax
}
c01041dd:	5d                   	pop    %ebp
c01041de:	c3                   	ret    

c01041df <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01041df:	55                   	push   %ebp
c01041e0:	89 e5                	mov    %esp,%ebp
c01041e2:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01041e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01041e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01041eb:	72 0a                	jb     c01041f7 <get_pgtable_items+0x18>
        return 0;
c01041ed:	b8 00 00 00 00       	mov    $0x0,%eax
c01041f2:	e9 9c 00 00 00       	jmp    c0104293 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01041f7:	eb 04                	jmp    c01041fd <get_pgtable_items+0x1e>
        start ++;
c01041f9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01041fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0104200:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104203:	73 18                	jae    c010421d <get_pgtable_items+0x3e>
c0104205:	8b 45 10             	mov    0x10(%ebp),%eax
c0104208:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010420f:	8b 45 14             	mov    0x14(%ebp),%eax
c0104212:	01 d0                	add    %edx,%eax
c0104214:	8b 00                	mov    (%eax),%eax
c0104216:	83 e0 01             	and    $0x1,%eax
c0104219:	85 c0                	test   %eax,%eax
c010421b:	74 dc                	je     c01041f9 <get_pgtable_items+0x1a>
    }
    if (start < right) {
c010421d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104220:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104223:	73 69                	jae    c010428e <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0104225:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104229:	74 08                	je     c0104233 <get_pgtable_items+0x54>
            *left_store = start;
c010422b:	8b 45 18             	mov    0x18(%ebp),%eax
c010422e:	8b 55 10             	mov    0x10(%ebp),%edx
c0104231:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104233:	8b 45 10             	mov    0x10(%ebp),%eax
c0104236:	8d 50 01             	lea    0x1(%eax),%edx
c0104239:	89 55 10             	mov    %edx,0x10(%ebp)
c010423c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104243:	8b 45 14             	mov    0x14(%ebp),%eax
c0104246:	01 d0                	add    %edx,%eax
c0104248:	8b 00                	mov    (%eax),%eax
c010424a:	83 e0 07             	and    $0x7,%eax
c010424d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104250:	eb 04                	jmp    c0104256 <get_pgtable_items+0x77>
            start ++;
c0104252:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104256:	8b 45 10             	mov    0x10(%ebp),%eax
c0104259:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010425c:	73 1d                	jae    c010427b <get_pgtable_items+0x9c>
c010425e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104268:	8b 45 14             	mov    0x14(%ebp),%eax
c010426b:	01 d0                	add    %edx,%eax
c010426d:	8b 00                	mov    (%eax),%eax
c010426f:	83 e0 07             	and    $0x7,%eax
c0104272:	89 c2                	mov    %eax,%edx
c0104274:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104277:	39 c2                	cmp    %eax,%edx
c0104279:	74 d7                	je     c0104252 <get_pgtable_items+0x73>
        }
        if (right_store != NULL) {
c010427b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010427f:	74 08                	je     c0104289 <get_pgtable_items+0xaa>
            *right_store = start;
c0104281:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104284:	8b 55 10             	mov    0x10(%ebp),%edx
c0104287:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104289:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010428c:	eb 05                	jmp    c0104293 <get_pgtable_items+0xb4>
    }
    return 0;
c010428e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104293:	c9                   	leave  
c0104294:	c3                   	ret    

c0104295 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104295:	55                   	push   %ebp
c0104296:	89 e5                	mov    %esp,%ebp
c0104298:	57                   	push   %edi
c0104299:	56                   	push   %esi
c010429a:	53                   	push   %ebx
c010429b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010429e:	c7 04 24 e8 aa 10 c0 	movl   $0xc010aae8,(%esp)
c01042a5:	e8 e7 bf ff ff       	call   c0100291 <cprintf>
    size_t left, right = 0, perm;
c01042aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01042b1:	e9 fa 00 00 00       	jmp    c01043b0 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01042b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042b9:	89 04 24             	mov    %eax,(%esp)
c01042bc:	e8 d0 fe ff ff       	call   c0104191 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01042c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01042c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042c7:	29 d1                	sub    %edx,%ecx
c01042c9:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01042cb:	89 d6                	mov    %edx,%esi
c01042cd:	c1 e6 16             	shl    $0x16,%esi
c01042d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042d3:	89 d3                	mov    %edx,%ebx
c01042d5:	c1 e3 16             	shl    $0x16,%ebx
c01042d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042db:	89 d1                	mov    %edx,%ecx
c01042dd:	c1 e1 16             	shl    $0x16,%ecx
c01042e0:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01042e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042e6:	29 d7                	sub    %edx,%edi
c01042e8:	89 fa                	mov    %edi,%edx
c01042ea:	89 44 24 14          	mov    %eax,0x14(%esp)
c01042ee:	89 74 24 10          	mov    %esi,0x10(%esp)
c01042f2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01042f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01042fa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01042fe:	c7 04 24 19 ab 10 c0 	movl   $0xc010ab19,(%esp)
c0104305:	e8 87 bf ff ff       	call   c0100291 <cprintf>
        size_t l, r = left * NPTEENTRY;
c010430a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010430d:	c1 e0 0a             	shl    $0xa,%eax
c0104310:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104313:	eb 54                	jmp    c0104369 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104318:	89 04 24             	mov    %eax,(%esp)
c010431b:	e8 71 fe ff ff       	call   c0104191 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104320:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104323:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104326:	29 d1                	sub    %edx,%ecx
c0104328:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010432a:	89 d6                	mov    %edx,%esi
c010432c:	c1 e6 0c             	shl    $0xc,%esi
c010432f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104332:	89 d3                	mov    %edx,%ebx
c0104334:	c1 e3 0c             	shl    $0xc,%ebx
c0104337:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010433a:	c1 e2 0c             	shl    $0xc,%edx
c010433d:	89 d1                	mov    %edx,%ecx
c010433f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104342:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104345:	29 d7                	sub    %edx,%edi
c0104347:	89 fa                	mov    %edi,%edx
c0104349:	89 44 24 14          	mov    %eax,0x14(%esp)
c010434d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104351:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104355:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104359:	89 54 24 04          	mov    %edx,0x4(%esp)
c010435d:	c7 04 24 38 ab 10 c0 	movl   $0xc010ab38,(%esp)
c0104364:	e8 28 bf ff ff       	call   c0100291 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104369:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010436e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104371:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104374:	89 ce                	mov    %ecx,%esi
c0104376:	c1 e6 0a             	shl    $0xa,%esi
c0104379:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010437c:	89 cb                	mov    %ecx,%ebx
c010437e:	c1 e3 0a             	shl    $0xa,%ebx
c0104381:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0104384:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0104388:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010438b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010438f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104393:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104397:	89 74 24 04          	mov    %esi,0x4(%esp)
c010439b:	89 1c 24             	mov    %ebx,(%esp)
c010439e:	e8 3c fe ff ff       	call   c01041df <get_pgtable_items>
c01043a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01043aa:	0f 85 65 ff ff ff    	jne    c0104315 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01043b0:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01043b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043b8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01043bb:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01043bf:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01043c2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01043c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01043ca:	89 44 24 08          	mov    %eax,0x8(%esp)
c01043ce:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01043d5:	00 
c01043d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01043dd:	e8 fd fd ff ff       	call   c01041df <get_pgtable_items>
c01043e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01043e9:	0f 85 c7 fe ff ff    	jne    c01042b6 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01043ef:	c7 04 24 5c ab 10 c0 	movl   $0xc010ab5c,(%esp)
c01043f6:	e8 96 be ff ff       	call   c0100291 <cprintf>
}
c01043fb:	83 c4 4c             	add    $0x4c,%esp
c01043fe:	5b                   	pop    %ebx
c01043ff:	5e                   	pop    %esi
c0104400:	5f                   	pop    %edi
c0104401:	5d                   	pop    %ebp
c0104402:	c3                   	ret    

c0104403 <page2ppn>:
page2ppn(struct Page *page) {
c0104403:	55                   	push   %ebp
c0104404:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104406:	8b 55 08             	mov    0x8(%ebp),%edx
c0104409:	a1 74 e9 11 c0       	mov    0xc011e974,%eax
c010440e:	29 c2                	sub    %eax,%edx
c0104410:	89 d0                	mov    %edx,%eax
c0104412:	c1 f8 02             	sar    $0x2,%eax
c0104415:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010441b:	5d                   	pop    %ebp
c010441c:	c3                   	ret    

c010441d <page2pa>:
page2pa(struct Page *page) {
c010441d:	55                   	push   %ebp
c010441e:	89 e5                	mov    %esp,%ebp
c0104420:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104423:	8b 45 08             	mov    0x8(%ebp),%eax
c0104426:	89 04 24             	mov    %eax,(%esp)
c0104429:	e8 d5 ff ff ff       	call   c0104403 <page2ppn>
c010442e:	c1 e0 0c             	shl    $0xc,%eax
}
c0104431:	c9                   	leave  
c0104432:	c3                   	ret    

c0104433 <page_ref>:
page_ref(struct Page *page) {
c0104433:	55                   	push   %ebp
c0104434:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104436:	8b 45 08             	mov    0x8(%ebp),%eax
c0104439:	8b 00                	mov    (%eax),%eax
}
c010443b:	5d                   	pop    %ebp
c010443c:	c3                   	ret    

c010443d <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010443d:	55                   	push   %ebp
c010443e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104440:	8b 45 08             	mov    0x8(%ebp),%eax
c0104443:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104446:	89 10                	mov    %edx,(%eax)
}
c0104448:	5d                   	pop    %ebp
c0104449:	c3                   	ret    

c010444a <buddy_init_size>:
#define UINT32_REMAINDER(a)     ((a)&(UINT32_MASK(a)>>1))
#define UINT32_ROUND_UP(a)      (UINT32_REMAINDER(a)?(((a)-UINT32_REMAINDER(a))<<1):(a))
#define UINT32_ROUND_DOWN(a)    (UINT32_REMAINDER(a)?((a)-UINT32_REMAINDER(a)):(a))

static void
buddy_init_size(size_t n) {
c010444a:	55                   	push   %ebp
c010444b:	89 e5                	mov    %esp,%ebp
c010444d:	57                   	push   %edi
c010444e:	56                   	push   %esi
c010444f:	53                   	push   %ebx
c0104450:	83 ec 2c             	sub    $0x2c,%esp
    assert(n > 1);
c0104453:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104457:	77 24                	ja     c010447d <buddy_init_size+0x33>
c0104459:	c7 44 24 0c 90 ab 10 	movl   $0xc010ab90,0xc(%esp)
c0104460:	c0 
c0104461:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0104468:	c0 
c0104469:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
c0104470:	00 
c0104471:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0104478:	e8 6b bf ff ff       	call   c01003e8 <__panic>
    buddy_physical_size = n;
c010447d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104480:	a3 4c e9 11 c0       	mov    %eax,0xc011e94c
    if (n < 512) {
c0104485:	81 7d 08 ff 01 00 00 	cmpl   $0x1ff,0x8(%ebp)
c010448c:	0f 87 de 02 00 00    	ja     c0104770 <buddy_init_size+0x326>
        buddy_virtual_size = UINT32_ROUND_UP(n-1);
c0104492:	8b 45 08             	mov    0x8(%ebp),%eax
c0104495:	8d 78 ff             	lea    -0x1(%eax),%edi
c0104498:	8b 45 08             	mov    0x8(%ebp),%eax
c010449b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010449e:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a1:	83 e8 01             	sub    $0x1,%eax
c01044a4:	d1 e8                	shr    %eax
c01044a6:	09 c2                	or     %eax,%edx
c01044a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ab:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01044ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b1:	83 e8 01             	sub    $0x1,%eax
c01044b4:	d1 e8                	shr    %eax
c01044b6:	09 c8                	or     %ecx,%eax
c01044b8:	c1 e8 02             	shr    $0x2,%eax
c01044bb:	09 c2                	or     %eax,%edx
c01044bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01044c0:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01044c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01044c6:	83 e8 01             	sub    $0x1,%eax
c01044c9:	d1 e8                	shr    %eax
c01044cb:	09 c1                	or     %eax,%ecx
c01044cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d0:	8d 58 ff             	lea    -0x1(%eax),%ebx
c01044d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d6:	83 e8 01             	sub    $0x1,%eax
c01044d9:	d1 e8                	shr    %eax
c01044db:	09 d8                	or     %ebx,%eax
c01044dd:	c1 e8 02             	shr    $0x2,%eax
c01044e0:	09 c8                	or     %ecx,%eax
c01044e2:	c1 e8 04             	shr    $0x4,%eax
c01044e5:	09 c2                	or     %eax,%edx
c01044e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ea:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01044ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01044f0:	83 e8 01             	sub    $0x1,%eax
c01044f3:	d1 e8                	shr    %eax
c01044f5:	09 c1                	or     %eax,%ecx
c01044f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01044fa:	8d 58 ff             	lea    -0x1(%eax),%ebx
c01044fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104500:	83 e8 01             	sub    $0x1,%eax
c0104503:	d1 e8                	shr    %eax
c0104505:	09 d8                	or     %ebx,%eax
c0104507:	c1 e8 02             	shr    $0x2,%eax
c010450a:	09 c1                	or     %eax,%ecx
c010450c:	8b 45 08             	mov    0x8(%ebp),%eax
c010450f:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0104512:	8b 45 08             	mov    0x8(%ebp),%eax
c0104515:	83 e8 01             	sub    $0x1,%eax
c0104518:	d1 e8                	shr    %eax
c010451a:	09 c3                	or     %eax,%ebx
c010451c:	8b 45 08             	mov    0x8(%ebp),%eax
c010451f:	8d 70 ff             	lea    -0x1(%eax),%esi
c0104522:	8b 45 08             	mov    0x8(%ebp),%eax
c0104525:	83 e8 01             	sub    $0x1,%eax
c0104528:	d1 e8                	shr    %eax
c010452a:	09 f0                	or     %esi,%eax
c010452c:	c1 e8 02             	shr    $0x2,%eax
c010452f:	09 d8                	or     %ebx,%eax
c0104531:	c1 e8 04             	shr    $0x4,%eax
c0104534:	09 c8                	or     %ecx,%eax
c0104536:	c1 e8 08             	shr    $0x8,%eax
c0104539:	89 d6                	mov    %edx,%esi
c010453b:	09 c6                	or     %eax,%esi
c010453d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104540:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104543:	8b 45 08             	mov    0x8(%ebp),%eax
c0104546:	83 e8 01             	sub    $0x1,%eax
c0104549:	d1 e8                	shr    %eax
c010454b:	09 c2                	or     %eax,%edx
c010454d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104550:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0104553:	8b 45 08             	mov    0x8(%ebp),%eax
c0104556:	83 e8 01             	sub    $0x1,%eax
c0104559:	d1 e8                	shr    %eax
c010455b:	09 c8                	or     %ecx,%eax
c010455d:	c1 e8 02             	shr    $0x2,%eax
c0104560:	09 c2                	or     %eax,%edx
c0104562:	8b 45 08             	mov    0x8(%ebp),%eax
c0104565:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0104568:	8b 45 08             	mov    0x8(%ebp),%eax
c010456b:	83 e8 01             	sub    $0x1,%eax
c010456e:	d1 e8                	shr    %eax
c0104570:	09 c1                	or     %eax,%ecx
c0104572:	8b 45 08             	mov    0x8(%ebp),%eax
c0104575:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0104578:	8b 45 08             	mov    0x8(%ebp),%eax
c010457b:	83 e8 01             	sub    $0x1,%eax
c010457e:	d1 e8                	shr    %eax
c0104580:	09 d8                	or     %ebx,%eax
c0104582:	c1 e8 02             	shr    $0x2,%eax
c0104585:	09 c8                	or     %ecx,%eax
c0104587:	c1 e8 04             	shr    $0x4,%eax
c010458a:	89 d3                	mov    %edx,%ebx
c010458c:	09 c3                	or     %eax,%ebx
c010458e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104591:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104594:	8b 45 08             	mov    0x8(%ebp),%eax
c0104597:	83 e8 01             	sub    $0x1,%eax
c010459a:	d1 e8                	shr    %eax
c010459c:	09 c2                	or     %eax,%edx
c010459e:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a1:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01045a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a7:	83 e8 01             	sub    $0x1,%eax
c01045aa:	d1 e8                	shr    %eax
c01045ac:	09 c8                	or     %ecx,%eax
c01045ae:	c1 e8 02             	shr    $0x2,%eax
c01045b1:	89 d1                	mov    %edx,%ecx
c01045b3:	09 c1                	or     %eax,%ecx
c01045b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01045bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01045be:	83 e8 01             	sub    $0x1,%eax
c01045c1:	d1 e8                	shr    %eax
c01045c3:	09 c2                	or     %eax,%edx
c01045c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c8:	83 e8 01             	sub    $0x1,%eax
c01045cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01045ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d1:	83 e8 01             	sub    $0x1,%eax
c01045d4:	d1 e8                	shr    %eax
c01045d6:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01045d9:	c1 e8 02             	shr    $0x2,%eax
c01045dc:	09 d0                	or     %edx,%eax
c01045de:	c1 e8 04             	shr    $0x4,%eax
c01045e1:	09 c8                	or     %ecx,%eax
c01045e3:	c1 e8 08             	shr    $0x8,%eax
c01045e6:	09 d8                	or     %ebx,%eax
c01045e8:	c1 e8 10             	shr    $0x10,%eax
c01045eb:	09 f0                	or     %esi,%eax
c01045ed:	d1 e8                	shr    %eax
c01045ef:	21 f8                	and    %edi,%eax
c01045f1:	85 c0                	test   %eax,%eax
c01045f3:	0f 84 5d 01 00 00    	je     c0104756 <buddy_init_size+0x30c>
c01045f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01045fc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01045ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104602:	83 e8 01             	sub    $0x1,%eax
c0104605:	d1 e8                	shr    %eax
c0104607:	09 c2                	or     %eax,%edx
c0104609:	8b 45 08             	mov    0x8(%ebp),%eax
c010460c:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010460f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104612:	83 e8 01             	sub    $0x1,%eax
c0104615:	d1 e8                	shr    %eax
c0104617:	09 c8                	or     %ecx,%eax
c0104619:	c1 e8 02             	shr    $0x2,%eax
c010461c:	09 c2                	or     %eax,%edx
c010461e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104621:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0104624:	8b 45 08             	mov    0x8(%ebp),%eax
c0104627:	83 e8 01             	sub    $0x1,%eax
c010462a:	d1 e8                	shr    %eax
c010462c:	09 c1                	or     %eax,%ecx
c010462e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104631:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0104634:	8b 45 08             	mov    0x8(%ebp),%eax
c0104637:	83 e8 01             	sub    $0x1,%eax
c010463a:	d1 e8                	shr    %eax
c010463c:	09 d8                	or     %ebx,%eax
c010463e:	c1 e8 02             	shr    $0x2,%eax
c0104641:	09 c8                	or     %ecx,%eax
c0104643:	c1 e8 04             	shr    $0x4,%eax
c0104646:	09 c2                	or     %eax,%edx
c0104648:	8b 45 08             	mov    0x8(%ebp),%eax
c010464b:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010464e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104651:	83 e8 01             	sub    $0x1,%eax
c0104654:	d1 e8                	shr    %eax
c0104656:	09 c1                	or     %eax,%ecx
c0104658:	8b 45 08             	mov    0x8(%ebp),%eax
c010465b:	8d 58 ff             	lea    -0x1(%eax),%ebx
c010465e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104661:	83 e8 01             	sub    $0x1,%eax
c0104664:	d1 e8                	shr    %eax
c0104666:	09 d8                	or     %ebx,%eax
c0104668:	c1 e8 02             	shr    $0x2,%eax
c010466b:	09 c1                	or     %eax,%ecx
c010466d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104670:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0104673:	8b 45 08             	mov    0x8(%ebp),%eax
c0104676:	83 e8 01             	sub    $0x1,%eax
c0104679:	d1 e8                	shr    %eax
c010467b:	09 c3                	or     %eax,%ebx
c010467d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104680:	8d 70 ff             	lea    -0x1(%eax),%esi
c0104683:	8b 45 08             	mov    0x8(%ebp),%eax
c0104686:	83 e8 01             	sub    $0x1,%eax
c0104689:	d1 e8                	shr    %eax
c010468b:	09 f0                	or     %esi,%eax
c010468d:	c1 e8 02             	shr    $0x2,%eax
c0104690:	09 d8                	or     %ebx,%eax
c0104692:	c1 e8 04             	shr    $0x4,%eax
c0104695:	09 c8                	or     %ecx,%eax
c0104697:	c1 e8 08             	shr    $0x8,%eax
c010469a:	09 c2                	or     %eax,%edx
c010469c:	8b 45 08             	mov    0x8(%ebp),%eax
c010469f:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01046a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a5:	83 e8 01             	sub    $0x1,%eax
c01046a8:	d1 e8                	shr    %eax
c01046aa:	09 c1                	or     %eax,%ecx
c01046ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01046af:	8d 58 ff             	lea    -0x1(%eax),%ebx
c01046b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b5:	83 e8 01             	sub    $0x1,%eax
c01046b8:	d1 e8                	shr    %eax
c01046ba:	09 d8                	or     %ebx,%eax
c01046bc:	c1 e8 02             	shr    $0x2,%eax
c01046bf:	09 c1                	or     %eax,%ecx
c01046c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046c4:	8d 58 ff             	lea    -0x1(%eax),%ebx
c01046c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ca:	83 e8 01             	sub    $0x1,%eax
c01046cd:	d1 e8                	shr    %eax
c01046cf:	09 c3                	or     %eax,%ebx
c01046d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046d4:	8d 70 ff             	lea    -0x1(%eax),%esi
c01046d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01046da:	83 e8 01             	sub    $0x1,%eax
c01046dd:	d1 e8                	shr    %eax
c01046df:	09 f0                	or     %esi,%eax
c01046e1:	c1 e8 02             	shr    $0x2,%eax
c01046e4:	09 d8                	or     %ebx,%eax
c01046e6:	c1 e8 04             	shr    $0x4,%eax
c01046e9:	09 c1                	or     %eax,%ecx
c01046eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ee:	8d 58 ff             	lea    -0x1(%eax),%ebx
c01046f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046f4:	83 e8 01             	sub    $0x1,%eax
c01046f7:	d1 e8                	shr    %eax
c01046f9:	09 c3                	or     %eax,%ebx
c01046fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01046fe:	8d 70 ff             	lea    -0x1(%eax),%esi
c0104701:	8b 45 08             	mov    0x8(%ebp),%eax
c0104704:	83 e8 01             	sub    $0x1,%eax
c0104707:	d1 e8                	shr    %eax
c0104709:	09 f0                	or     %esi,%eax
c010470b:	c1 e8 02             	shr    $0x2,%eax
c010470e:	09 c3                	or     %eax,%ebx
c0104710:	8b 45 08             	mov    0x8(%ebp),%eax
c0104713:	8d 70 ff             	lea    -0x1(%eax),%esi
c0104716:	8b 45 08             	mov    0x8(%ebp),%eax
c0104719:	83 e8 01             	sub    $0x1,%eax
c010471c:	d1 e8                	shr    %eax
c010471e:	09 c6                	or     %eax,%esi
c0104720:	8b 45 08             	mov    0x8(%ebp),%eax
c0104723:	8d 78 ff             	lea    -0x1(%eax),%edi
c0104726:	8b 45 08             	mov    0x8(%ebp),%eax
c0104729:	83 e8 01             	sub    $0x1,%eax
c010472c:	d1 e8                	shr    %eax
c010472e:	09 f8                	or     %edi,%eax
c0104730:	c1 e8 02             	shr    $0x2,%eax
c0104733:	09 f0                	or     %esi,%eax
c0104735:	c1 e8 04             	shr    $0x4,%eax
c0104738:	09 d8                	or     %ebx,%eax
c010473a:	c1 e8 08             	shr    $0x8,%eax
c010473d:	09 c8                	or     %ecx,%eax
c010473f:	c1 e8 10             	shr    $0x10,%eax
c0104742:	09 d0                	or     %edx,%eax
c0104744:	d1 e8                	shr    %eax
c0104746:	f7 d0                	not    %eax
c0104748:	89 c2                	mov    %eax,%edx
c010474a:	8b 45 08             	mov    0x8(%ebp),%eax
c010474d:	83 e8 01             	sub    $0x1,%eax
c0104750:	21 d0                	and    %edx,%eax
c0104752:	01 c0                	add    %eax,%eax
c0104754:	eb 06                	jmp    c010475c <buddy_init_size+0x312>
c0104756:	8b 45 08             	mov    0x8(%ebp),%eax
c0104759:	83 e8 01             	sub    $0x1,%eax
c010475c:	a3 50 e9 11 c0       	mov    %eax,0xc011e950
        buddy_segment_size = 1;
c0104761:	c7 05 54 e9 11 c0 01 	movl   $0x1,0xc011e954
c0104768:	00 00 00 
c010476b:	e9 00 02 00 00       	jmp    c0104970 <buddy_init_size+0x526>
    } else {
        buddy_virtual_size = UINT32_ROUND_DOWN(n);
c0104770:	8b 45 08             	mov    0x8(%ebp),%eax
c0104773:	d1 e8                	shr    %eax
c0104775:	0b 45 08             	or     0x8(%ebp),%eax
c0104778:	8b 55 08             	mov    0x8(%ebp),%edx
c010477b:	d1 ea                	shr    %edx
c010477d:	0b 55 08             	or     0x8(%ebp),%edx
c0104780:	c1 ea 02             	shr    $0x2,%edx
c0104783:	09 d0                	or     %edx,%eax
c0104785:	89 c1                	mov    %eax,%ecx
c0104787:	8b 45 08             	mov    0x8(%ebp),%eax
c010478a:	d1 e8                	shr    %eax
c010478c:	0b 45 08             	or     0x8(%ebp),%eax
c010478f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104792:	d1 ea                	shr    %edx
c0104794:	0b 55 08             	or     0x8(%ebp),%edx
c0104797:	c1 ea 02             	shr    $0x2,%edx
c010479a:	09 d0                	or     %edx,%eax
c010479c:	c1 e8 04             	shr    $0x4,%eax
c010479f:	09 c1                	or     %eax,%ecx
c01047a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047a4:	d1 e8                	shr    %eax
c01047a6:	0b 45 08             	or     0x8(%ebp),%eax
c01047a9:	8b 55 08             	mov    0x8(%ebp),%edx
c01047ac:	d1 ea                	shr    %edx
c01047ae:	0b 55 08             	or     0x8(%ebp),%edx
c01047b1:	c1 ea 02             	shr    $0x2,%edx
c01047b4:	09 d0                	or     %edx,%eax
c01047b6:	89 c3                	mov    %eax,%ebx
c01047b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01047bb:	d1 e8                	shr    %eax
c01047bd:	0b 45 08             	or     0x8(%ebp),%eax
c01047c0:	8b 55 08             	mov    0x8(%ebp),%edx
c01047c3:	d1 ea                	shr    %edx
c01047c5:	0b 55 08             	or     0x8(%ebp),%edx
c01047c8:	c1 ea 02             	shr    $0x2,%edx
c01047cb:	09 d0                	or     %edx,%eax
c01047cd:	c1 e8 04             	shr    $0x4,%eax
c01047d0:	09 d8                	or     %ebx,%eax
c01047d2:	c1 e8 08             	shr    $0x8,%eax
c01047d5:	09 c1                	or     %eax,%ecx
c01047d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01047da:	d1 e8                	shr    %eax
c01047dc:	0b 45 08             	or     0x8(%ebp),%eax
c01047df:	8b 55 08             	mov    0x8(%ebp),%edx
c01047e2:	d1 ea                	shr    %edx
c01047e4:	0b 55 08             	or     0x8(%ebp),%edx
c01047e7:	c1 ea 02             	shr    $0x2,%edx
c01047ea:	09 d0                	or     %edx,%eax
c01047ec:	89 c3                	mov    %eax,%ebx
c01047ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01047f1:	d1 e8                	shr    %eax
c01047f3:	0b 45 08             	or     0x8(%ebp),%eax
c01047f6:	8b 55 08             	mov    0x8(%ebp),%edx
c01047f9:	d1 ea                	shr    %edx
c01047fb:	0b 55 08             	or     0x8(%ebp),%edx
c01047fe:	c1 ea 02             	shr    $0x2,%edx
c0104801:	09 d0                	or     %edx,%eax
c0104803:	c1 e8 04             	shr    $0x4,%eax
c0104806:	09 c3                	or     %eax,%ebx
c0104808:	8b 45 08             	mov    0x8(%ebp),%eax
c010480b:	d1 e8                	shr    %eax
c010480d:	0b 45 08             	or     0x8(%ebp),%eax
c0104810:	8b 55 08             	mov    0x8(%ebp),%edx
c0104813:	d1 ea                	shr    %edx
c0104815:	0b 55 08             	or     0x8(%ebp),%edx
c0104818:	c1 ea 02             	shr    $0x2,%edx
c010481b:	09 d0                	or     %edx,%eax
c010481d:	89 c6                	mov    %eax,%esi
c010481f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104822:	d1 e8                	shr    %eax
c0104824:	0b 45 08             	or     0x8(%ebp),%eax
c0104827:	8b 55 08             	mov    0x8(%ebp),%edx
c010482a:	d1 ea                	shr    %edx
c010482c:	0b 55 08             	or     0x8(%ebp),%edx
c010482f:	c1 ea 02             	shr    $0x2,%edx
c0104832:	09 d0                	or     %edx,%eax
c0104834:	c1 e8 04             	shr    $0x4,%eax
c0104837:	09 f0                	or     %esi,%eax
c0104839:	c1 e8 08             	shr    $0x8,%eax
c010483c:	09 d8                	or     %ebx,%eax
c010483e:	c1 e8 10             	shr    $0x10,%eax
c0104841:	09 c8                	or     %ecx,%eax
c0104843:	d1 e8                	shr    %eax
c0104845:	23 45 08             	and    0x8(%ebp),%eax
c0104848:	85 c0                	test   %eax,%eax
c010484a:	0f 84 dc 00 00 00    	je     c010492c <buddy_init_size+0x4e2>
c0104850:	8b 45 08             	mov    0x8(%ebp),%eax
c0104853:	d1 e8                	shr    %eax
c0104855:	0b 45 08             	or     0x8(%ebp),%eax
c0104858:	8b 55 08             	mov    0x8(%ebp),%edx
c010485b:	d1 ea                	shr    %edx
c010485d:	0b 55 08             	or     0x8(%ebp),%edx
c0104860:	c1 ea 02             	shr    $0x2,%edx
c0104863:	09 d0                	or     %edx,%eax
c0104865:	89 c1                	mov    %eax,%ecx
c0104867:	8b 45 08             	mov    0x8(%ebp),%eax
c010486a:	d1 e8                	shr    %eax
c010486c:	0b 45 08             	or     0x8(%ebp),%eax
c010486f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104872:	d1 ea                	shr    %edx
c0104874:	0b 55 08             	or     0x8(%ebp),%edx
c0104877:	c1 ea 02             	shr    $0x2,%edx
c010487a:	09 d0                	or     %edx,%eax
c010487c:	c1 e8 04             	shr    $0x4,%eax
c010487f:	09 c1                	or     %eax,%ecx
c0104881:	8b 45 08             	mov    0x8(%ebp),%eax
c0104884:	d1 e8                	shr    %eax
c0104886:	0b 45 08             	or     0x8(%ebp),%eax
c0104889:	8b 55 08             	mov    0x8(%ebp),%edx
c010488c:	d1 ea                	shr    %edx
c010488e:	0b 55 08             	or     0x8(%ebp),%edx
c0104891:	c1 ea 02             	shr    $0x2,%edx
c0104894:	09 d0                	or     %edx,%eax
c0104896:	89 c3                	mov    %eax,%ebx
c0104898:	8b 45 08             	mov    0x8(%ebp),%eax
c010489b:	d1 e8                	shr    %eax
c010489d:	0b 45 08             	or     0x8(%ebp),%eax
c01048a0:	8b 55 08             	mov    0x8(%ebp),%edx
c01048a3:	d1 ea                	shr    %edx
c01048a5:	0b 55 08             	or     0x8(%ebp),%edx
c01048a8:	c1 ea 02             	shr    $0x2,%edx
c01048ab:	09 d0                	or     %edx,%eax
c01048ad:	c1 e8 04             	shr    $0x4,%eax
c01048b0:	09 d8                	or     %ebx,%eax
c01048b2:	c1 e8 08             	shr    $0x8,%eax
c01048b5:	09 c1                	or     %eax,%ecx
c01048b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01048ba:	d1 e8                	shr    %eax
c01048bc:	0b 45 08             	or     0x8(%ebp),%eax
c01048bf:	8b 55 08             	mov    0x8(%ebp),%edx
c01048c2:	d1 ea                	shr    %edx
c01048c4:	0b 55 08             	or     0x8(%ebp),%edx
c01048c7:	c1 ea 02             	shr    $0x2,%edx
c01048ca:	09 d0                	or     %edx,%eax
c01048cc:	89 c3                	mov    %eax,%ebx
c01048ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01048d1:	d1 e8                	shr    %eax
c01048d3:	0b 45 08             	or     0x8(%ebp),%eax
c01048d6:	8b 55 08             	mov    0x8(%ebp),%edx
c01048d9:	d1 ea                	shr    %edx
c01048db:	0b 55 08             	or     0x8(%ebp),%edx
c01048de:	c1 ea 02             	shr    $0x2,%edx
c01048e1:	09 d0                	or     %edx,%eax
c01048e3:	c1 e8 04             	shr    $0x4,%eax
c01048e6:	09 c3                	or     %eax,%ebx
c01048e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01048eb:	d1 e8                	shr    %eax
c01048ed:	0b 45 08             	or     0x8(%ebp),%eax
c01048f0:	8b 55 08             	mov    0x8(%ebp),%edx
c01048f3:	d1 ea                	shr    %edx
c01048f5:	0b 55 08             	or     0x8(%ebp),%edx
c01048f8:	c1 ea 02             	shr    $0x2,%edx
c01048fb:	09 d0                	or     %edx,%eax
c01048fd:	89 c6                	mov    %eax,%esi
c01048ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104902:	d1 e8                	shr    %eax
c0104904:	0b 45 08             	or     0x8(%ebp),%eax
c0104907:	8b 55 08             	mov    0x8(%ebp),%edx
c010490a:	d1 ea                	shr    %edx
c010490c:	0b 55 08             	or     0x8(%ebp),%edx
c010490f:	c1 ea 02             	shr    $0x2,%edx
c0104912:	09 d0                	or     %edx,%eax
c0104914:	c1 e8 04             	shr    $0x4,%eax
c0104917:	09 f0                	or     %esi,%eax
c0104919:	c1 e8 08             	shr    $0x8,%eax
c010491c:	09 d8                	or     %ebx,%eax
c010491e:	c1 e8 10             	shr    $0x10,%eax
c0104921:	09 c8                	or     %ecx,%eax
c0104923:	d1 e8                	shr    %eax
c0104925:	f7 d0                	not    %eax
c0104927:	23 45 08             	and    0x8(%ebp),%eax
c010492a:	eb 03                	jmp    c010492f <buddy_init_size+0x4e5>
c010492c:	8b 45 08             	mov    0x8(%ebp),%eax
c010492f:	a3 50 e9 11 c0       	mov    %eax,0xc011e950
        buddy_segment_size = buddy_virtual_size*sizeof(size_t)*2/PGSIZE;
c0104934:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c0104939:	c1 e0 03             	shl    $0x3,%eax
c010493c:	c1 e8 0c             	shr    $0xc,%eax
c010493f:	a3 54 e9 11 c0       	mov    %eax,0xc011e954
        if (n > buddy_virtual_size + (buddy_segment_size<<1)) {
c0104944:	a1 54 e9 11 c0       	mov    0xc011e954,%eax
c0104949:	8d 14 00             	lea    (%eax,%eax,1),%edx
c010494c:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c0104951:	01 d0                	add    %edx,%eax
c0104953:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104956:	73 18                	jae    c0104970 <buddy_init_size+0x526>
            buddy_virtual_size <<= 1;
c0104958:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c010495d:	01 c0                	add    %eax,%eax
c010495f:	a3 50 e9 11 c0       	mov    %eax,0xc011e950
            buddy_segment_size <<= 1;
c0104964:	a1 54 e9 11 c0       	mov    0xc011e954,%eax
c0104969:	01 c0                	add    %eax,%eax
c010496b:	a3 54 e9 11 c0       	mov    %eax,0xc011e954
        }
    }
    buddy_alloc_size = MIN(buddy_virtual_size, buddy_physical_size-buddy_segment_size);
c0104970:	8b 15 4c e9 11 c0    	mov    0xc011e94c,%edx
c0104976:	a1 54 e9 11 c0       	mov    0xc011e954,%eax
c010497b:	29 c2                	sub    %eax,%edx
c010497d:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c0104982:	39 c2                	cmp    %eax,%edx
c0104984:	0f 46 c2             	cmovbe %edx,%eax
c0104987:	a3 58 e9 11 c0       	mov    %eax,0xc011e958
}
c010498c:	83 c4 2c             	add    $0x2c,%esp
c010498f:	5b                   	pop    %ebx
c0104990:	5e                   	pop    %esi
c0104991:	5f                   	pop    %edi
c0104992:	5d                   	pop    %ebp
c0104993:	c3                   	ret    

c0104994 <buddy_init_segment>:

static void
buddy_init_segment(struct Page *base) {
c0104994:	55                   	push   %ebp
c0104995:	89 e5                	mov    %esp,%ebp
c0104997:	57                   	push   %edi
c0104998:	56                   	push   %esi
c0104999:	53                   	push   %ebx
c010499a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
    // Init address
    buddy_physical = base;
c01049a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01049a3:	a3 60 e9 11 c0       	mov    %eax,0xc011e960
    buddy_segment = KADDR(page2pa(base));
c01049a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01049ab:	89 04 24             	mov    %eax,(%esp)
c01049ae:	e8 6a fa ff ff       	call   c010441d <page2pa>
c01049b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01049b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01049b9:	c1 e8 0c             	shr    $0xc,%eax
c01049bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01049bf:	a1 c0 e8 11 c0       	mov    0xc011e8c0,%eax
c01049c4:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
c01049c7:	72 23                	jb     c01049ec <buddy_init_segment+0x58>
c01049c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01049cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01049d0:	c7 44 24 08 bc ab 10 	movl   $0xc010abbc,0x8(%esp)
c01049d7:	c0 
c01049d8:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
c01049df:	00 
c01049e0:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c01049e7:	e8 fc b9 ff ff       	call   c01003e8 <__panic>
c01049ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01049ef:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01049f4:	a3 5c e9 11 c0       	mov    %eax,0xc011e95c
    buddy_alloc = base + buddy_segment_size;
c01049f9:	8b 15 54 e9 11 c0    	mov    0xc011e954,%edx
c01049ff:	89 d0                	mov    %edx,%eax
c0104a01:	c1 e0 02             	shl    $0x2,%eax
c0104a04:	01 d0                	add    %edx,%eax
c0104a06:	c1 e0 02             	shl    $0x2,%eax
c0104a09:	89 c2                	mov    %eax,%edx
c0104a0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a0e:	01 d0                	add    %edx,%eax
c0104a10:	a3 64 e9 11 c0       	mov    %eax,0xc011e964
    memset(buddy_segment, 0, buddy_segment_size*PGSIZE);
c0104a15:	a1 54 e9 11 c0       	mov    0xc011e954,%eax
c0104a1a:	c1 e0 0c             	shl    $0xc,%eax
c0104a1d:	89 c2                	mov    %eax,%edx
c0104a1f:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0104a24:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104a28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a2f:	00 
c0104a30:	89 04 24             	mov    %eax,(%esp)
c0104a33:	e8 ca 4b 00 00       	call   c0109602 <memset>
    // Init segment
    nr_free += buddy_alloc_size;
c0104a38:	8b 15 80 e9 11 c0    	mov    0xc011e980,%edx
c0104a3e:	a1 58 e9 11 c0       	mov    0xc011e958,%eax
c0104a43:	01 d0                	add    %edx,%eax
c0104a45:	a3 80 e9 11 c0       	mov    %eax,0xc011e980
    size_t block = BUDDY_ROOT;
c0104a4a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    size_t alloc_size = buddy_alloc_size;
c0104a51:	a1 58 e9 11 c0       	mov    0xc011e958,%eax
c0104a56:	89 45 e0             	mov    %eax,-0x20(%ebp)
    size_t virtual_size = buddy_virtual_size;
c0104a59:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c0104a5e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    buddy_segment[block] = alloc_size;
c0104a61:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0104a66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a69:	c1 e2 02             	shl    $0x2,%edx
c0104a6c:	01 c2                	add    %eax,%edx
c0104a6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a71:	89 02                	mov    %eax,(%edx)
    while (alloc_size > 0 && alloc_size < virtual_size) {
c0104a73:	e9 b3 03 00 00       	jmp    c0104e2b <buddy_init_segment+0x497>
        virtual_size >>= 1;
c0104a78:	d1 6d dc             	shrl   -0x24(%ebp)
        if (alloc_size > virtual_size) {
c0104a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a7e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104a81:	0f 86 79 03 00 00    	jbe    c0104e00 <buddy_init_segment+0x46c>
            // Add left to free list
            struct Page *page = &buddy_alloc[BUDDY_BEGIN(block)];
c0104a87:	a1 64 e9 11 c0       	mov    0xc011e964,%eax
c0104a8c:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a92:	d1 e8                	shr    %eax
c0104a94:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104a97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a9a:	d1 ea                	shr    %edx
c0104a9c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104a9f:	c1 ea 02             	shr    $0x2,%edx
c0104aa2:	09 d0                	or     %edx,%eax
c0104aa4:	89 c1                	mov    %eax,%ecx
c0104aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104aa9:	d1 e8                	shr    %eax
c0104aab:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104aae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ab1:	d1 ea                	shr    %edx
c0104ab3:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104ab6:	c1 ea 02             	shr    $0x2,%edx
c0104ab9:	09 d0                	or     %edx,%eax
c0104abb:	c1 e8 04             	shr    $0x4,%eax
c0104abe:	09 c1                	or     %eax,%ecx
c0104ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ac3:	d1 e8                	shr    %eax
c0104ac5:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104ac8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104acb:	d1 ea                	shr    %edx
c0104acd:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104ad0:	c1 ea 02             	shr    $0x2,%edx
c0104ad3:	09 d0                	or     %edx,%eax
c0104ad5:	89 c3                	mov    %eax,%ebx
c0104ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ada:	d1 e8                	shr    %eax
c0104adc:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104adf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ae2:	d1 ea                	shr    %edx
c0104ae4:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104ae7:	c1 ea 02             	shr    $0x2,%edx
c0104aea:	09 d0                	or     %edx,%eax
c0104aec:	c1 e8 04             	shr    $0x4,%eax
c0104aef:	09 d8                	or     %ebx,%eax
c0104af1:	c1 e8 08             	shr    $0x8,%eax
c0104af4:	09 c1                	or     %eax,%ecx
c0104af6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104af9:	d1 e8                	shr    %eax
c0104afb:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104afe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104b01:	d1 ea                	shr    %edx
c0104b03:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104b06:	c1 ea 02             	shr    $0x2,%edx
c0104b09:	09 d0                	or     %edx,%eax
c0104b0b:	89 c3                	mov    %eax,%ebx
c0104b0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b10:	d1 e8                	shr    %eax
c0104b12:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104b15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104b18:	d1 ea                	shr    %edx
c0104b1a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104b1d:	c1 ea 02             	shr    $0x2,%edx
c0104b20:	09 d0                	or     %edx,%eax
c0104b22:	c1 e8 04             	shr    $0x4,%eax
c0104b25:	09 c3                	or     %eax,%ebx
c0104b27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b2a:	d1 e8                	shr    %eax
c0104b2c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104b2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104b32:	d1 ea                	shr    %edx
c0104b34:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104b37:	c1 ea 02             	shr    $0x2,%edx
c0104b3a:	09 d0                	or     %edx,%eax
c0104b3c:	89 c6                	mov    %eax,%esi
c0104b3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b41:	d1 e8                	shr    %eax
c0104b43:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104b46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104b49:	d1 ea                	shr    %edx
c0104b4b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104b4e:	c1 ea 02             	shr    $0x2,%edx
c0104b51:	09 d0                	or     %edx,%eax
c0104b53:	c1 e8 04             	shr    $0x4,%eax
c0104b56:	09 f0                	or     %esi,%eax
c0104b58:	c1 e8 08             	shr    $0x8,%eax
c0104b5b:	09 d8                	or     %ebx,%eax
c0104b5d:	c1 e8 10             	shr    $0x10,%eax
c0104b60:	09 c8                	or     %ecx,%eax
c0104b62:	d1 e8                	shr    %eax
c0104b64:	23 45 e4             	and    -0x1c(%ebp),%eax
c0104b67:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104b6a:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c0104b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b73:	d1 e8                	shr    %eax
c0104b75:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104b78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104b7b:	d1 ea                	shr    %edx
c0104b7d:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104b80:	c1 ea 02             	shr    $0x2,%edx
c0104b83:	09 d0                	or     %edx,%eax
c0104b85:	89 c1                	mov    %eax,%ecx
c0104b87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b8a:	d1 e8                	shr    %eax
c0104b8c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104b8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104b92:	d1 ea                	shr    %edx
c0104b94:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104b97:	c1 ea 02             	shr    $0x2,%edx
c0104b9a:	09 d0                	or     %edx,%eax
c0104b9c:	c1 e8 04             	shr    $0x4,%eax
c0104b9f:	09 c1                	or     %eax,%ecx
c0104ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ba4:	d1 e8                	shr    %eax
c0104ba6:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104ba9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104bac:	d1 ea                	shr    %edx
c0104bae:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104bb1:	c1 ea 02             	shr    $0x2,%edx
c0104bb4:	09 d0                	or     %edx,%eax
c0104bb6:	89 c3                	mov    %eax,%ebx
c0104bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bbb:	d1 e8                	shr    %eax
c0104bbd:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104bc0:	89 c2                	mov    %eax,%edx
c0104bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bc5:	d1 e8                	shr    %eax
c0104bc7:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104bca:	c1 e8 02             	shr    $0x2,%eax
c0104bcd:	09 d0                	or     %edx,%eax
c0104bcf:	c1 e8 04             	shr    $0x4,%eax
c0104bd2:	09 d8                	or     %ebx,%eax
c0104bd4:	c1 e8 08             	shr    $0x8,%eax
c0104bd7:	89 ce                	mov    %ecx,%esi
c0104bd9:	09 c6                	or     %eax,%esi
c0104bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bde:	d1 e8                	shr    %eax
c0104be0:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104be3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104be6:	d1 ea                	shr    %edx
c0104be8:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104beb:	c1 ea 02             	shr    $0x2,%edx
c0104bee:	09 d0                	or     %edx,%eax
c0104bf0:	89 c1                	mov    %eax,%ecx
c0104bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bf5:	d1 e8                	shr    %eax
c0104bf7:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104bfa:	89 c2                	mov    %eax,%edx
c0104bfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bff:	d1 e8                	shr    %eax
c0104c01:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104c04:	c1 e8 02             	shr    $0x2,%eax
c0104c07:	09 d0                	or     %edx,%eax
c0104c09:	c1 e8 04             	shr    $0x4,%eax
c0104c0c:	89 cb                	mov    %ecx,%ebx
c0104c0e:	09 c3                	or     %eax,%ebx
c0104c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c13:	d1 e8                	shr    %eax
c0104c15:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104c18:	89 c2                	mov    %eax,%edx
c0104c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c1d:	d1 e8                	shr    %eax
c0104c1f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104c22:	c1 e8 02             	shr    $0x2,%eax
c0104c25:	89 d1                	mov    %edx,%ecx
c0104c27:	09 c1                	or     %eax,%ecx
c0104c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c2c:	d1 e8                	shr    %eax
c0104c2e:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104c31:	89 c2                	mov    %eax,%edx
c0104c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c36:	d1 e8                	shr    %eax
c0104c38:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104c3b:	c1 e8 02             	shr    $0x2,%eax
c0104c3e:	09 d0                	or     %edx,%eax
c0104c40:	c1 e8 04             	shr    $0x4,%eax
c0104c43:	09 c8                	or     %ecx,%eax
c0104c45:	c1 e8 08             	shr    $0x8,%eax
c0104c48:	09 d8                	or     %ebx,%eax
c0104c4a:	c1 e8 10             	shr    $0x10,%eax
c0104c4d:	09 f0                	or     %esi,%eax
c0104c4f:	d1 e8                	shr    %eax
c0104c51:	23 45 e4             	and    -0x1c(%ebp),%eax
c0104c54:	85 c0                	test   %eax,%eax
c0104c56:	0f 84 ea 00 00 00    	je     c0104d46 <buddy_init_segment+0x3b2>
c0104c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c5f:	d1 e8                	shr    %eax
c0104c61:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104c64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104c67:	d1 ea                	shr    %edx
c0104c69:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104c6c:	c1 ea 02             	shr    $0x2,%edx
c0104c6f:	09 d0                	or     %edx,%eax
c0104c71:	89 c1                	mov    %eax,%ecx
c0104c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c76:	d1 e8                	shr    %eax
c0104c78:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104c7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104c7e:	d1 ea                	shr    %edx
c0104c80:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104c83:	c1 ea 02             	shr    $0x2,%edx
c0104c86:	09 d0                	or     %edx,%eax
c0104c88:	c1 e8 04             	shr    $0x4,%eax
c0104c8b:	09 c1                	or     %eax,%ecx
c0104c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c90:	d1 e8                	shr    %eax
c0104c92:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104c95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104c98:	d1 ea                	shr    %edx
c0104c9a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104c9d:	c1 ea 02             	shr    $0x2,%edx
c0104ca0:	09 d0                	or     %edx,%eax
c0104ca2:	89 c3                	mov    %eax,%ebx
c0104ca4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ca7:	d1 e8                	shr    %eax
c0104ca9:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104cac:	89 c2                	mov    %eax,%edx
c0104cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cb1:	d1 e8                	shr    %eax
c0104cb3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104cb6:	c1 e8 02             	shr    $0x2,%eax
c0104cb9:	09 d0                	or     %edx,%eax
c0104cbb:	c1 e8 04             	shr    $0x4,%eax
c0104cbe:	09 d8                	or     %ebx,%eax
c0104cc0:	c1 e8 08             	shr    $0x8,%eax
c0104cc3:	89 ce                	mov    %ecx,%esi
c0104cc5:	09 c6                	or     %eax,%esi
c0104cc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cca:	d1 e8                	shr    %eax
c0104ccc:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104ccf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104cd2:	d1 ea                	shr    %edx
c0104cd4:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104cd7:	c1 ea 02             	shr    $0x2,%edx
c0104cda:	09 d0                	or     %edx,%eax
c0104cdc:	89 c1                	mov    %eax,%ecx
c0104cde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ce1:	d1 e8                	shr    %eax
c0104ce3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104ce6:	89 c2                	mov    %eax,%edx
c0104ce8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ceb:	d1 e8                	shr    %eax
c0104ced:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104cf0:	c1 e8 02             	shr    $0x2,%eax
c0104cf3:	09 d0                	or     %edx,%eax
c0104cf5:	c1 e8 04             	shr    $0x4,%eax
c0104cf8:	89 cb                	mov    %ecx,%ebx
c0104cfa:	09 c3                	or     %eax,%ebx
c0104cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cff:	d1 e8                	shr    %eax
c0104d01:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104d04:	89 c2                	mov    %eax,%edx
c0104d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d09:	d1 e8                	shr    %eax
c0104d0b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104d0e:	c1 e8 02             	shr    $0x2,%eax
c0104d11:	89 d1                	mov    %edx,%ecx
c0104d13:	09 c1                	or     %eax,%ecx
c0104d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d18:	d1 e8                	shr    %eax
c0104d1a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104d1d:	89 c2                	mov    %eax,%edx
c0104d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d22:	d1 e8                	shr    %eax
c0104d24:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104d27:	c1 e8 02             	shr    $0x2,%eax
c0104d2a:	09 d0                	or     %edx,%eax
c0104d2c:	c1 e8 04             	shr    $0x4,%eax
c0104d2f:	09 c8                	or     %ecx,%eax
c0104d31:	c1 e8 08             	shr    $0x8,%eax
c0104d34:	09 d8                	or     %ebx,%eax
c0104d36:	c1 e8 10             	shr    $0x10,%eax
c0104d39:	09 f0                	or     %esi,%eax
c0104d3b:	d1 e8                	shr    %eax
c0104d3d:	f7 d0                	not    %eax
c0104d3f:	23 45 e4             	and    -0x1c(%ebp),%eax
c0104d42:	89 c6                	mov    %eax,%esi
c0104d44:	eb 03                	jmp    c0104d49 <buddy_init_segment+0x3b5>
c0104d46:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c0104d49:	89 f8                	mov    %edi,%eax
c0104d4b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104d50:	f7 f6                	div    %esi
c0104d52:	8b 55 80             	mov    -0x80(%ebp),%edx
c0104d55:	0f af d0             	imul   %eax,%edx
c0104d58:	89 d0                	mov    %edx,%eax
c0104d5a:	c1 e0 02             	shl    $0x2,%eax
c0104d5d:	01 d0                	add    %edx,%eax
c0104d5f:	c1 e0 02             	shl    $0x2,%eax
c0104d62:	03 45 84             	add    -0x7c(%ebp),%eax
c0104d65:	89 45 d0             	mov    %eax,-0x30(%ebp)
            page->property = virtual_size;
c0104d68:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104d6e:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(free_list), &(page->page_link));
c0104d71:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d74:	83 c0 0c             	add    $0xc,%eax
c0104d77:	c7 45 c8 78 e9 11 c0 	movl   $0xc011e978,-0x38(%ebp)
c0104d7e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104d81:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104d84:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0104d87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d8a:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104d8d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104d90:	8b 40 04             	mov    0x4(%eax),%eax
c0104d93:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104d96:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0104d99:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104d9c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0104d9f:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104da2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104da5:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104da8:	89 10                	mov    %edx,(%eax)
c0104daa:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104dad:	8b 10                	mov    (%eax),%edx
c0104daf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104db2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104db5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104db8:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104dbb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104dbe:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104dc1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104dc4:	89 10                	mov    %edx,(%eax)
            buddy_segment[BUDDY_LEFT(block)] = virtual_size;
c0104dc6:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0104dcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104dce:	c1 e2 03             	shl    $0x3,%edx
c0104dd1:	01 c2                	add    %eax,%edx
c0104dd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104dd6:	89 02                	mov    %eax,(%edx)
            // Switch ro right
            alloc_size -= virtual_size;
c0104dd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ddb:	29 45 e0             	sub    %eax,-0x20(%ebp)
            buddy_segment[BUDDY_RIGHT(block)] = alloc_size;
c0104dde:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0104de3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104de6:	c1 e2 03             	shl    $0x3,%edx
c0104de9:	83 c2 04             	add    $0x4,%edx
c0104dec:	01 c2                	add    %eax,%edx
c0104dee:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104df1:	89 02                	mov    %eax,(%edx)
            block = BUDDY_RIGHT(block);
c0104df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104df6:	01 c0                	add    %eax,%eax
c0104df8:	83 c0 01             	add    $0x1,%eax
c0104dfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104dfe:	eb 2b                	jmp    c0104e2b <buddy_init_segment+0x497>
        } else {
            // Switch to left
            buddy_segment[BUDDY_LEFT(block)] = alloc_size;
c0104e00:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0104e05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104e08:	c1 e2 03             	shl    $0x3,%edx
c0104e0b:	01 c2                	add    %eax,%edx
c0104e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e10:	89 02                	mov    %eax,(%edx)
            buddy_segment[BUDDY_RIGHT(block)] = 0;
c0104e12:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0104e17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104e1a:	c1 e2 03             	shl    $0x3,%edx
c0104e1d:	83 c2 04             	add    $0x4,%edx
c0104e20:	01 d0                	add    %edx,%eax
c0104e22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            block = BUDDY_LEFT(block);
c0104e28:	d1 65 e4             	shll   -0x1c(%ebp)
    while (alloc_size > 0 && alloc_size < virtual_size) {
c0104e2b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104e2f:	74 0c                	je     c0104e3d <buddy_init_segment+0x4a9>
c0104e31:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e34:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104e37:	0f 82 3b fc ff ff    	jb     c0104a78 <buddy_init_segment+0xe4>
        }
    }
    if (alloc_size > 0) {
c0104e3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104e41:	0f 84 3f 03 00 00    	je     c0105186 <buddy_init_segment+0x7f2>
        struct Page *page = &buddy_alloc[BUDDY_BEGIN(block)];
c0104e47:	a1 64 e9 11 c0       	mov    0xc011e964,%eax
c0104e4c:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e52:	d1 e8                	shr    %eax
c0104e54:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104e57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104e5a:	d1 ea                	shr    %edx
c0104e5c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104e5f:	c1 ea 02             	shr    $0x2,%edx
c0104e62:	09 d0                	or     %edx,%eax
c0104e64:	89 c1                	mov    %eax,%ecx
c0104e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e69:	d1 e8                	shr    %eax
c0104e6b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104e6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104e71:	d1 ea                	shr    %edx
c0104e73:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104e76:	c1 ea 02             	shr    $0x2,%edx
c0104e79:	09 d0                	or     %edx,%eax
c0104e7b:	c1 e8 04             	shr    $0x4,%eax
c0104e7e:	09 c1                	or     %eax,%ecx
c0104e80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e83:	d1 e8                	shr    %eax
c0104e85:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104e88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104e8b:	d1 ea                	shr    %edx
c0104e8d:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104e90:	c1 ea 02             	shr    $0x2,%edx
c0104e93:	09 d0                	or     %edx,%eax
c0104e95:	89 c3                	mov    %eax,%ebx
c0104e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e9a:	d1 e8                	shr    %eax
c0104e9c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104e9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ea2:	d1 ea                	shr    %edx
c0104ea4:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104ea7:	c1 ea 02             	shr    $0x2,%edx
c0104eaa:	09 d0                	or     %edx,%eax
c0104eac:	c1 e8 04             	shr    $0x4,%eax
c0104eaf:	09 d8                	or     %ebx,%eax
c0104eb1:	c1 e8 08             	shr    $0x8,%eax
c0104eb4:	09 c1                	or     %eax,%ecx
c0104eb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104eb9:	d1 e8                	shr    %eax
c0104ebb:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104ebe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ec1:	d1 ea                	shr    %edx
c0104ec3:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104ec6:	c1 ea 02             	shr    $0x2,%edx
c0104ec9:	09 d0                	or     %edx,%eax
c0104ecb:	89 c3                	mov    %eax,%ebx
c0104ecd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ed0:	d1 e8                	shr    %eax
c0104ed2:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104ed5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ed8:	d1 ea                	shr    %edx
c0104eda:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104edd:	c1 ea 02             	shr    $0x2,%edx
c0104ee0:	09 d0                	or     %edx,%eax
c0104ee2:	c1 e8 04             	shr    $0x4,%eax
c0104ee5:	09 c3                	or     %eax,%ebx
c0104ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104eea:	d1 e8                	shr    %eax
c0104eec:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104eef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ef2:	d1 ea                	shr    %edx
c0104ef4:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104ef7:	c1 ea 02             	shr    $0x2,%edx
c0104efa:	09 d0                	or     %edx,%eax
c0104efc:	89 c6                	mov    %eax,%esi
c0104efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f01:	d1 e8                	shr    %eax
c0104f03:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104f06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f09:	d1 ea                	shr    %edx
c0104f0b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104f0e:	c1 ea 02             	shr    $0x2,%edx
c0104f11:	09 d0                	or     %edx,%eax
c0104f13:	c1 e8 04             	shr    $0x4,%eax
c0104f16:	09 f0                	or     %esi,%eax
c0104f18:	c1 e8 08             	shr    $0x8,%eax
c0104f1b:	09 d8                	or     %ebx,%eax
c0104f1d:	c1 e8 10             	shr    $0x10,%eax
c0104f20:	09 c8                	or     %ecx,%eax
c0104f22:	d1 e8                	shr    %eax
c0104f24:	23 45 e4             	and    -0x1c(%ebp),%eax
c0104f27:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104f2a:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c0104f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f33:	d1 e8                	shr    %eax
c0104f35:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104f38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f3b:	d1 ea                	shr    %edx
c0104f3d:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104f40:	c1 ea 02             	shr    $0x2,%edx
c0104f43:	09 d0                	or     %edx,%eax
c0104f45:	89 c1                	mov    %eax,%ecx
c0104f47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f4a:	d1 e8                	shr    %eax
c0104f4c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104f4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f52:	d1 ea                	shr    %edx
c0104f54:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104f57:	c1 ea 02             	shr    $0x2,%edx
c0104f5a:	09 d0                	or     %edx,%eax
c0104f5c:	c1 e8 04             	shr    $0x4,%eax
c0104f5f:	09 c1                	or     %eax,%ecx
c0104f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f64:	d1 e8                	shr    %eax
c0104f66:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104f69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f6c:	d1 ea                	shr    %edx
c0104f6e:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104f71:	c1 ea 02             	shr    $0x2,%edx
c0104f74:	09 d0                	or     %edx,%eax
c0104f76:	89 c3                	mov    %eax,%ebx
c0104f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f7b:	d1 e8                	shr    %eax
c0104f7d:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104f80:	89 c2                	mov    %eax,%edx
c0104f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f85:	d1 e8                	shr    %eax
c0104f87:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104f8a:	c1 e8 02             	shr    $0x2,%eax
c0104f8d:	09 d0                	or     %edx,%eax
c0104f8f:	c1 e8 04             	shr    $0x4,%eax
c0104f92:	09 d8                	or     %ebx,%eax
c0104f94:	c1 e8 08             	shr    $0x8,%eax
c0104f97:	89 ce                	mov    %ecx,%esi
c0104f99:	09 c6                	or     %eax,%esi
c0104f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f9e:	d1 e8                	shr    %eax
c0104fa0:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104fa3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104fa6:	d1 ea                	shr    %edx
c0104fa8:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0104fab:	c1 ea 02             	shr    $0x2,%edx
c0104fae:	09 d0                	or     %edx,%eax
c0104fb0:	89 c1                	mov    %eax,%ecx
c0104fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fb5:	d1 e8                	shr    %eax
c0104fb7:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104fba:	89 c2                	mov    %eax,%edx
c0104fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fbf:	d1 e8                	shr    %eax
c0104fc1:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104fc4:	c1 e8 02             	shr    $0x2,%eax
c0104fc7:	09 d0                	or     %edx,%eax
c0104fc9:	c1 e8 04             	shr    $0x4,%eax
c0104fcc:	89 cb                	mov    %ecx,%ebx
c0104fce:	09 c3                	or     %eax,%ebx
c0104fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fd3:	d1 e8                	shr    %eax
c0104fd5:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104fd8:	89 c2                	mov    %eax,%edx
c0104fda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fdd:	d1 e8                	shr    %eax
c0104fdf:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104fe2:	c1 e8 02             	shr    $0x2,%eax
c0104fe5:	89 d1                	mov    %edx,%ecx
c0104fe7:	09 c1                	or     %eax,%ecx
c0104fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fec:	d1 e8                	shr    %eax
c0104fee:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104ff1:	89 c2                	mov    %eax,%edx
c0104ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ff6:	d1 e8                	shr    %eax
c0104ff8:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0104ffb:	c1 e8 02             	shr    $0x2,%eax
c0104ffe:	09 d0                	or     %edx,%eax
c0105000:	c1 e8 04             	shr    $0x4,%eax
c0105003:	09 c8                	or     %ecx,%eax
c0105005:	c1 e8 08             	shr    $0x8,%eax
c0105008:	09 d8                	or     %ebx,%eax
c010500a:	c1 e8 10             	shr    $0x10,%eax
c010500d:	09 f0                	or     %esi,%eax
c010500f:	d1 e8                	shr    %eax
c0105011:	23 45 e4             	and    -0x1c(%ebp),%eax
c0105014:	85 c0                	test   %eax,%eax
c0105016:	0f 84 ea 00 00 00    	je     c0105106 <buddy_init_segment+0x772>
c010501c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010501f:	d1 e8                	shr    %eax
c0105021:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105024:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105027:	d1 ea                	shr    %edx
c0105029:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010502c:	c1 ea 02             	shr    $0x2,%edx
c010502f:	09 d0                	or     %edx,%eax
c0105031:	89 c1                	mov    %eax,%ecx
c0105033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105036:	d1 e8                	shr    %eax
c0105038:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010503b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010503e:	d1 ea                	shr    %edx
c0105040:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105043:	c1 ea 02             	shr    $0x2,%edx
c0105046:	09 d0                	or     %edx,%eax
c0105048:	c1 e8 04             	shr    $0x4,%eax
c010504b:	09 c1                	or     %eax,%ecx
c010504d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105050:	d1 e8                	shr    %eax
c0105052:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105055:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105058:	d1 ea                	shr    %edx
c010505a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010505d:	c1 ea 02             	shr    $0x2,%edx
c0105060:	09 d0                	or     %edx,%eax
c0105062:	89 c3                	mov    %eax,%ebx
c0105064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105067:	d1 e8                	shr    %eax
c0105069:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010506c:	89 c2                	mov    %eax,%edx
c010506e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105071:	d1 e8                	shr    %eax
c0105073:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105076:	c1 e8 02             	shr    $0x2,%eax
c0105079:	09 d0                	or     %edx,%eax
c010507b:	c1 e8 04             	shr    $0x4,%eax
c010507e:	09 d8                	or     %ebx,%eax
c0105080:	c1 e8 08             	shr    $0x8,%eax
c0105083:	89 ce                	mov    %ecx,%esi
c0105085:	09 c6                	or     %eax,%esi
c0105087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010508a:	d1 e8                	shr    %eax
c010508c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010508f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105092:	d1 ea                	shr    %edx
c0105094:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105097:	c1 ea 02             	shr    $0x2,%edx
c010509a:	09 d0                	or     %edx,%eax
c010509c:	89 c1                	mov    %eax,%ecx
c010509e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050a1:	d1 e8                	shr    %eax
c01050a3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01050a6:	89 c2                	mov    %eax,%edx
c01050a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050ab:	d1 e8                	shr    %eax
c01050ad:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01050b0:	c1 e8 02             	shr    $0x2,%eax
c01050b3:	09 d0                	or     %edx,%eax
c01050b5:	c1 e8 04             	shr    $0x4,%eax
c01050b8:	89 cb                	mov    %ecx,%ebx
c01050ba:	09 c3                	or     %eax,%ebx
c01050bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050bf:	d1 e8                	shr    %eax
c01050c1:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01050c4:	89 c2                	mov    %eax,%edx
c01050c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050c9:	d1 e8                	shr    %eax
c01050cb:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01050ce:	c1 e8 02             	shr    $0x2,%eax
c01050d1:	89 d1                	mov    %edx,%ecx
c01050d3:	09 c1                	or     %eax,%ecx
c01050d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050d8:	d1 e8                	shr    %eax
c01050da:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01050dd:	89 c2                	mov    %eax,%edx
c01050df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050e2:	d1 e8                	shr    %eax
c01050e4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01050e7:	c1 e8 02             	shr    $0x2,%eax
c01050ea:	09 d0                	or     %edx,%eax
c01050ec:	c1 e8 04             	shr    $0x4,%eax
c01050ef:	09 c8                	or     %ecx,%eax
c01050f1:	c1 e8 08             	shr    $0x8,%eax
c01050f4:	09 d8                	or     %ebx,%eax
c01050f6:	c1 e8 10             	shr    $0x10,%eax
c01050f9:	09 f0                	or     %esi,%eax
c01050fb:	d1 e8                	shr    %eax
c01050fd:	f7 d0                	not    %eax
c01050ff:	23 45 e4             	and    -0x1c(%ebp),%eax
c0105102:	89 c6                	mov    %eax,%esi
c0105104:	eb 03                	jmp    c0105109 <buddy_init_segment+0x775>
c0105106:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c0105109:	89 f8                	mov    %edi,%eax
c010510b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105110:	f7 f6                	div    %esi
c0105112:	8b 55 80             	mov    -0x80(%ebp),%edx
c0105115:	0f af d0             	imul   %eax,%edx
c0105118:	89 d0                	mov    %edx,%eax
c010511a:	c1 e0 02             	shl    $0x2,%eax
c010511d:	01 d0                	add    %edx,%eax
c010511f:	c1 e0 02             	shl    $0x2,%eax
c0105122:	03 45 84             	add    -0x7c(%ebp),%eax
c0105125:	89 45 cc             	mov    %eax,-0x34(%ebp)
        page->property = alloc_size;
c0105128:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010512b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010512e:	89 50 08             	mov    %edx,0x8(%eax)
        list_add(&(free_list), &(page->page_link));
c0105131:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105134:	83 c0 0c             	add    $0xc,%eax
c0105137:	c7 45 ac 78 e9 11 c0 	movl   $0xc011e978,-0x54(%ebp)
c010513e:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0105141:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105144:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0105147:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010514a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    __list_add(elm, listelm, listelm->next);
c010514d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105150:	8b 40 04             	mov    0x4(%eax),%eax
c0105153:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105156:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0105159:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010515c:	89 55 98             	mov    %edx,-0x68(%ebp)
c010515f:	89 45 94             	mov    %eax,-0x6c(%ebp)
    prev->next = next->prev = elm;
c0105162:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105165:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0105168:	89 10                	mov    %edx,(%eax)
c010516a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010516d:	8b 10                	mov    (%eax),%edx
c010516f:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105172:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105175:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105178:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010517b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010517e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105181:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105184:	89 10                	mov    %edx,(%eax)
    }
}
c0105186:	81 c4 8c 00 00 00    	add    $0x8c,%esp
c010518c:	5b                   	pop    %ebx
c010518d:	5e                   	pop    %esi
c010518e:	5f                   	pop    %edi
c010518f:	5d                   	pop    %ebp
c0105190:	c3                   	ret    

c0105191 <buddy_init>:

static void
buddy_init(void) {
c0105191:	55                   	push   %ebp
c0105192:	89 e5                	mov    %esp,%ebp
c0105194:	83 ec 10             	sub    $0x10,%esp
c0105197:	c7 45 fc 78 e9 11 c0 	movl   $0xc011e978,-0x4(%ebp)
    elm->prev = elm->next = elm;
c010519e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01051a4:	89 50 04             	mov    %edx,0x4(%eax)
c01051a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051aa:	8b 50 04             	mov    0x4(%eax),%edx
c01051ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051b0:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01051b2:	c7 05 80 e9 11 c0 00 	movl   $0x0,0xc011e980
c01051b9:	00 00 00 
}
c01051bc:	c9                   	leave  
c01051bd:	c3                   	ret    

c01051be <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
c01051be:	55                   	push   %ebp
c01051bf:	89 e5                	mov    %esp,%ebp
c01051c1:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0);
c01051c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01051c8:	75 24                	jne    c01051ee <buddy_init_memmap+0x30>
c01051ca:	c7 44 24 0c df ab 10 	movl   $0xc010abdf,0xc(%esp)
c01051d1:	c0 
c01051d2:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c01051d9:	c0 
c01051da:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01051e1:	00 
c01051e2:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c01051e9:	e8 fa b1 ff ff       	call   c01003e8 <__panic>
    // Init pages
    struct Page *p;
    for (p = base; p < base + n; p++) {
c01051ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01051f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051f4:	eb 6a                	jmp    c0105260 <buddy_init_memmap+0xa2>
        assert(PageReserved(p));
c01051f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051f9:	83 c0 04             	add    $0x4,%eax
c01051fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0105203:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105206:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105209:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010520c:	0f a3 10             	bt     %edx,(%eax)
c010520f:	19 c0                	sbb    %eax,%eax
c0105211:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0105214:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105218:	0f 95 c0             	setne  %al
c010521b:	0f b6 c0             	movzbl %al,%eax
c010521e:	85 c0                	test   %eax,%eax
c0105220:	75 24                	jne    c0105246 <buddy_init_memmap+0x88>
c0105222:	c7 44 24 0c e5 ab 10 	movl   $0xc010abe5,0xc(%esp)
c0105229:	c0 
c010522a:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0105231:	c0 
c0105232:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0105239:	00 
c010523a:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0105241:	e8 a2 b1 ff ff       	call   c01003e8 <__panic>
        p->flags = p->property = 0;
c0105246:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105249:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0105250:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105253:	8b 50 08             	mov    0x8(%eax),%edx
c0105256:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105259:	89 50 04             	mov    %edx,0x4(%eax)
    for (p = base; p < base + n; p++) {
c010525c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0105260:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105263:	89 d0                	mov    %edx,%eax
c0105265:	c1 e0 02             	shl    $0x2,%eax
c0105268:	01 d0                	add    %edx,%eax
c010526a:	c1 e0 02             	shl    $0x2,%eax
c010526d:	89 c2                	mov    %eax,%edx
c010526f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105272:	01 d0                	add    %edx,%eax
c0105274:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105277:	0f 87 79 ff ff ff    	ja     c01051f6 <buddy_init_memmap+0x38>
    }
    // Init size
    buddy_init_size(n);
c010527d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105280:	89 04 24             	mov    %eax,(%esp)
c0105283:	e8 c2 f1 ff ff       	call   c010444a <buddy_init_size>
    // Init segment
    buddy_init_segment(base);
c0105288:	8b 45 08             	mov    0x8(%ebp),%eax
c010528b:	89 04 24             	mov    %eax,(%esp)
c010528e:	e8 01 f7 ff ff       	call   c0104994 <buddy_init_segment>
}
c0105293:	c9                   	leave  
c0105294:	c3                   	ret    

c0105295 <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n) {
c0105295:	55                   	push   %ebp
c0105296:	89 e5                	mov    %esp,%ebp
c0105298:	57                   	push   %edi
c0105299:	56                   	push   %esi
c010529a:	53                   	push   %ebx
c010529b:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    assert(n > 0);
c01052a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01052a5:	75 24                	jne    c01052cb <buddy_alloc_pages+0x36>
c01052a7:	c7 44 24 0c df ab 10 	movl   $0xc010abdf,0xc(%esp)
c01052ae:	c0 
c01052af:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c01052b6:	c0 
c01052b7:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c01052be:	00 
c01052bf:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c01052c6:	e8 1d b1 ff ff       	call   c01003e8 <__panic>
    struct Page *page;
    size_t block = BUDDY_ROOT;
c01052cb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    size_t length = UINT32_ROUND_UP(n);
c01052d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01052d5:	d1 e8                	shr    %eax
c01052d7:	0b 45 08             	or     0x8(%ebp),%eax
c01052da:	8b 55 08             	mov    0x8(%ebp),%edx
c01052dd:	d1 ea                	shr    %edx
c01052df:	0b 55 08             	or     0x8(%ebp),%edx
c01052e2:	c1 ea 02             	shr    $0x2,%edx
c01052e5:	09 d0                	or     %edx,%eax
c01052e7:	89 c1                	mov    %eax,%ecx
c01052e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01052ec:	d1 e8                	shr    %eax
c01052ee:	0b 45 08             	or     0x8(%ebp),%eax
c01052f1:	8b 55 08             	mov    0x8(%ebp),%edx
c01052f4:	d1 ea                	shr    %edx
c01052f6:	0b 55 08             	or     0x8(%ebp),%edx
c01052f9:	c1 ea 02             	shr    $0x2,%edx
c01052fc:	09 d0                	or     %edx,%eax
c01052fe:	c1 e8 04             	shr    $0x4,%eax
c0105301:	09 c1                	or     %eax,%ecx
c0105303:	8b 45 08             	mov    0x8(%ebp),%eax
c0105306:	d1 e8                	shr    %eax
c0105308:	0b 45 08             	or     0x8(%ebp),%eax
c010530b:	8b 55 08             	mov    0x8(%ebp),%edx
c010530e:	d1 ea                	shr    %edx
c0105310:	0b 55 08             	or     0x8(%ebp),%edx
c0105313:	c1 ea 02             	shr    $0x2,%edx
c0105316:	09 d0                	or     %edx,%eax
c0105318:	89 c3                	mov    %eax,%ebx
c010531a:	8b 45 08             	mov    0x8(%ebp),%eax
c010531d:	d1 e8                	shr    %eax
c010531f:	0b 45 08             	or     0x8(%ebp),%eax
c0105322:	8b 55 08             	mov    0x8(%ebp),%edx
c0105325:	d1 ea                	shr    %edx
c0105327:	0b 55 08             	or     0x8(%ebp),%edx
c010532a:	c1 ea 02             	shr    $0x2,%edx
c010532d:	09 d0                	or     %edx,%eax
c010532f:	c1 e8 04             	shr    $0x4,%eax
c0105332:	09 d8                	or     %ebx,%eax
c0105334:	c1 e8 08             	shr    $0x8,%eax
c0105337:	09 c1                	or     %eax,%ecx
c0105339:	8b 45 08             	mov    0x8(%ebp),%eax
c010533c:	d1 e8                	shr    %eax
c010533e:	0b 45 08             	or     0x8(%ebp),%eax
c0105341:	8b 55 08             	mov    0x8(%ebp),%edx
c0105344:	d1 ea                	shr    %edx
c0105346:	0b 55 08             	or     0x8(%ebp),%edx
c0105349:	c1 ea 02             	shr    $0x2,%edx
c010534c:	09 d0                	or     %edx,%eax
c010534e:	89 c3                	mov    %eax,%ebx
c0105350:	8b 45 08             	mov    0x8(%ebp),%eax
c0105353:	d1 e8                	shr    %eax
c0105355:	0b 45 08             	or     0x8(%ebp),%eax
c0105358:	8b 55 08             	mov    0x8(%ebp),%edx
c010535b:	d1 ea                	shr    %edx
c010535d:	0b 55 08             	or     0x8(%ebp),%edx
c0105360:	c1 ea 02             	shr    $0x2,%edx
c0105363:	09 d0                	or     %edx,%eax
c0105365:	c1 e8 04             	shr    $0x4,%eax
c0105368:	09 c3                	or     %eax,%ebx
c010536a:	8b 45 08             	mov    0x8(%ebp),%eax
c010536d:	d1 e8                	shr    %eax
c010536f:	0b 45 08             	or     0x8(%ebp),%eax
c0105372:	8b 55 08             	mov    0x8(%ebp),%edx
c0105375:	d1 ea                	shr    %edx
c0105377:	0b 55 08             	or     0x8(%ebp),%edx
c010537a:	c1 ea 02             	shr    $0x2,%edx
c010537d:	09 d0                	or     %edx,%eax
c010537f:	89 c6                	mov    %eax,%esi
c0105381:	8b 45 08             	mov    0x8(%ebp),%eax
c0105384:	d1 e8                	shr    %eax
c0105386:	0b 45 08             	or     0x8(%ebp),%eax
c0105389:	8b 55 08             	mov    0x8(%ebp),%edx
c010538c:	d1 ea                	shr    %edx
c010538e:	0b 55 08             	or     0x8(%ebp),%edx
c0105391:	c1 ea 02             	shr    $0x2,%edx
c0105394:	09 d0                	or     %edx,%eax
c0105396:	c1 e8 04             	shr    $0x4,%eax
c0105399:	09 f0                	or     %esi,%eax
c010539b:	c1 e8 08             	shr    $0x8,%eax
c010539e:	09 d8                	or     %ebx,%eax
c01053a0:	c1 e8 10             	shr    $0x10,%eax
c01053a3:	09 c8                	or     %ecx,%eax
c01053a5:	d1 e8                	shr    %eax
c01053a7:	23 45 08             	and    0x8(%ebp),%eax
c01053aa:	85 c0                	test   %eax,%eax
c01053ac:	0f 84 de 00 00 00    	je     c0105490 <buddy_alloc_pages+0x1fb>
c01053b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b5:	d1 e8                	shr    %eax
c01053b7:	0b 45 08             	or     0x8(%ebp),%eax
c01053ba:	8b 55 08             	mov    0x8(%ebp),%edx
c01053bd:	d1 ea                	shr    %edx
c01053bf:	0b 55 08             	or     0x8(%ebp),%edx
c01053c2:	c1 ea 02             	shr    $0x2,%edx
c01053c5:	09 d0                	or     %edx,%eax
c01053c7:	89 c1                	mov    %eax,%ecx
c01053c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01053cc:	d1 e8                	shr    %eax
c01053ce:	0b 45 08             	or     0x8(%ebp),%eax
c01053d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01053d4:	d1 ea                	shr    %edx
c01053d6:	0b 55 08             	or     0x8(%ebp),%edx
c01053d9:	c1 ea 02             	shr    $0x2,%edx
c01053dc:	09 d0                	or     %edx,%eax
c01053de:	c1 e8 04             	shr    $0x4,%eax
c01053e1:	09 c1                	or     %eax,%ecx
c01053e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01053e6:	d1 e8                	shr    %eax
c01053e8:	0b 45 08             	or     0x8(%ebp),%eax
c01053eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01053ee:	d1 ea                	shr    %edx
c01053f0:	0b 55 08             	or     0x8(%ebp),%edx
c01053f3:	c1 ea 02             	shr    $0x2,%edx
c01053f6:	09 d0                	or     %edx,%eax
c01053f8:	89 c3                	mov    %eax,%ebx
c01053fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01053fd:	d1 e8                	shr    %eax
c01053ff:	0b 45 08             	or     0x8(%ebp),%eax
c0105402:	8b 55 08             	mov    0x8(%ebp),%edx
c0105405:	d1 ea                	shr    %edx
c0105407:	0b 55 08             	or     0x8(%ebp),%edx
c010540a:	c1 ea 02             	shr    $0x2,%edx
c010540d:	09 d0                	or     %edx,%eax
c010540f:	c1 e8 04             	shr    $0x4,%eax
c0105412:	09 d8                	or     %ebx,%eax
c0105414:	c1 e8 08             	shr    $0x8,%eax
c0105417:	09 c1                	or     %eax,%ecx
c0105419:	8b 45 08             	mov    0x8(%ebp),%eax
c010541c:	d1 e8                	shr    %eax
c010541e:	0b 45 08             	or     0x8(%ebp),%eax
c0105421:	8b 55 08             	mov    0x8(%ebp),%edx
c0105424:	d1 ea                	shr    %edx
c0105426:	0b 55 08             	or     0x8(%ebp),%edx
c0105429:	c1 ea 02             	shr    $0x2,%edx
c010542c:	09 d0                	or     %edx,%eax
c010542e:	89 c3                	mov    %eax,%ebx
c0105430:	8b 45 08             	mov    0x8(%ebp),%eax
c0105433:	d1 e8                	shr    %eax
c0105435:	0b 45 08             	or     0x8(%ebp),%eax
c0105438:	8b 55 08             	mov    0x8(%ebp),%edx
c010543b:	d1 ea                	shr    %edx
c010543d:	0b 55 08             	or     0x8(%ebp),%edx
c0105440:	c1 ea 02             	shr    $0x2,%edx
c0105443:	09 d0                	or     %edx,%eax
c0105445:	c1 e8 04             	shr    $0x4,%eax
c0105448:	09 c3                	or     %eax,%ebx
c010544a:	8b 45 08             	mov    0x8(%ebp),%eax
c010544d:	d1 e8                	shr    %eax
c010544f:	0b 45 08             	or     0x8(%ebp),%eax
c0105452:	8b 55 08             	mov    0x8(%ebp),%edx
c0105455:	d1 ea                	shr    %edx
c0105457:	0b 55 08             	or     0x8(%ebp),%edx
c010545a:	c1 ea 02             	shr    $0x2,%edx
c010545d:	09 d0                	or     %edx,%eax
c010545f:	89 c6                	mov    %eax,%esi
c0105461:	8b 45 08             	mov    0x8(%ebp),%eax
c0105464:	d1 e8                	shr    %eax
c0105466:	0b 45 08             	or     0x8(%ebp),%eax
c0105469:	8b 55 08             	mov    0x8(%ebp),%edx
c010546c:	d1 ea                	shr    %edx
c010546e:	0b 55 08             	or     0x8(%ebp),%edx
c0105471:	c1 ea 02             	shr    $0x2,%edx
c0105474:	09 d0                	or     %edx,%eax
c0105476:	c1 e8 04             	shr    $0x4,%eax
c0105479:	09 f0                	or     %esi,%eax
c010547b:	c1 e8 08             	shr    $0x8,%eax
c010547e:	09 d8                	or     %ebx,%eax
c0105480:	c1 e8 10             	shr    $0x10,%eax
c0105483:	09 c8                	or     %ecx,%eax
c0105485:	d1 e8                	shr    %eax
c0105487:	f7 d0                	not    %eax
c0105489:	23 45 08             	and    0x8(%ebp),%eax
c010548c:	01 c0                	add    %eax,%eax
c010548e:	eb 03                	jmp    c0105493 <buddy_alloc_pages+0x1fe>
c0105490:	8b 45 08             	mov    0x8(%ebp),%eax
c0105493:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // Find block
    while (length <= buddy_segment[block] && length < BUDDY_LENGTH(block)) {
c0105496:	e9 ee 09 00 00       	jmp    c0105e89 <buddy_alloc_pages+0xbf4>
        size_t left = BUDDY_LEFT(block);
c010549b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010549e:	01 c0                	add    %eax,%eax
c01054a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        size_t right = BUDDY_RIGHT(block);
c01054a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054a6:	01 c0                	add    %eax,%eax
c01054a8:	83 c0 01             	add    $0x1,%eax
c01054ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
        if (BUDDY_EMPTY(block)) {                   // Split
c01054ae:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c01054b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054b6:	c1 e2 02             	shl    $0x2,%edx
c01054b9:	01 d0                	add    %edx,%eax
c01054bb:	8b 00                	mov    (%eax),%eax
c01054bd:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
c01054c3:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c01054c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054cc:	d1 e8                	shr    %eax
c01054ce:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01054d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054d4:	d1 ea                	shr    %edx
c01054d6:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01054d9:	c1 ea 02             	shr    $0x2,%edx
c01054dc:	09 d0                	or     %edx,%eax
c01054de:	89 c1                	mov    %eax,%ecx
c01054e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054e3:	d1 e8                	shr    %eax
c01054e5:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01054e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054eb:	d1 ea                	shr    %edx
c01054ed:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01054f0:	c1 ea 02             	shr    $0x2,%edx
c01054f3:	09 d0                	or     %edx,%eax
c01054f5:	c1 e8 04             	shr    $0x4,%eax
c01054f8:	09 c1                	or     %eax,%ecx
c01054fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054fd:	d1 e8                	shr    %eax
c01054ff:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105502:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105505:	d1 ea                	shr    %edx
c0105507:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010550a:	c1 ea 02             	shr    $0x2,%edx
c010550d:	09 d0                	or     %edx,%eax
c010550f:	89 c3                	mov    %eax,%ebx
c0105511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105514:	d1 e8                	shr    %eax
c0105516:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105519:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010551c:	d1 ea                	shr    %edx
c010551e:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105521:	c1 ea 02             	shr    $0x2,%edx
c0105524:	09 d0                	or     %edx,%eax
c0105526:	c1 e8 04             	shr    $0x4,%eax
c0105529:	09 d8                	or     %ebx,%eax
c010552b:	c1 e8 08             	shr    $0x8,%eax
c010552e:	89 cb                	mov    %ecx,%ebx
c0105530:	09 c3                	or     %eax,%ebx
c0105532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105535:	d1 e8                	shr    %eax
c0105537:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010553a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010553d:	d1 ea                	shr    %edx
c010553f:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105542:	c1 ea 02             	shr    $0x2,%edx
c0105545:	09 d0                	or     %edx,%eax
c0105547:	89 c1                	mov    %eax,%ecx
c0105549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010554c:	d1 e8                	shr    %eax
c010554e:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105551:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105554:	d1 ea                	shr    %edx
c0105556:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105559:	c1 ea 02             	shr    $0x2,%edx
c010555c:	09 d0                	or     %edx,%eax
c010555e:	c1 e8 04             	shr    $0x4,%eax
c0105561:	09 c1                	or     %eax,%ecx
c0105563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105566:	d1 e8                	shr    %eax
c0105568:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010556b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010556e:	d1 ea                	shr    %edx
c0105570:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105573:	c1 ea 02             	shr    $0x2,%edx
c0105576:	09 d0                	or     %edx,%eax
c0105578:	89 c6                	mov    %eax,%esi
c010557a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010557d:	d1 e8                	shr    %eax
c010557f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105582:	89 c2                	mov    %eax,%edx
c0105584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105587:	d1 e8                	shr    %eax
c0105589:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010558c:	c1 e8 02             	shr    $0x2,%eax
c010558f:	09 d0                	or     %edx,%eax
c0105591:	c1 e8 04             	shr    $0x4,%eax
c0105594:	09 f0                	or     %esi,%eax
c0105596:	c1 e8 08             	shr    $0x8,%eax
c0105599:	09 c8                	or     %ecx,%eax
c010559b:	c1 e8 10             	shr    $0x10,%eax
c010559e:	09 d8                	or     %ebx,%eax
c01055a0:	d1 e8                	shr    %eax
c01055a2:	23 45 e4             	and    -0x1c(%ebp),%eax
c01055a5:	85 c0                	test   %eax,%eax
c01055a7:	0f 84 e2 00 00 00    	je     c010568f <buddy_alloc_pages+0x3fa>
c01055ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055b0:	d1 e8                	shr    %eax
c01055b2:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01055b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01055b8:	d1 ea                	shr    %edx
c01055ba:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01055bd:	c1 ea 02             	shr    $0x2,%edx
c01055c0:	09 d0                	or     %edx,%eax
c01055c2:	89 c1                	mov    %eax,%ecx
c01055c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055c7:	d1 e8                	shr    %eax
c01055c9:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01055cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01055cf:	d1 ea                	shr    %edx
c01055d1:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01055d4:	c1 ea 02             	shr    $0x2,%edx
c01055d7:	09 d0                	or     %edx,%eax
c01055d9:	c1 e8 04             	shr    $0x4,%eax
c01055dc:	09 c1                	or     %eax,%ecx
c01055de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055e1:	d1 e8                	shr    %eax
c01055e3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01055e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01055e9:	d1 ea                	shr    %edx
c01055eb:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01055ee:	c1 ea 02             	shr    $0x2,%edx
c01055f1:	09 d0                	or     %edx,%eax
c01055f3:	89 c3                	mov    %eax,%ebx
c01055f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055f8:	d1 e8                	shr    %eax
c01055fa:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01055fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105600:	d1 ea                	shr    %edx
c0105602:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105605:	c1 ea 02             	shr    $0x2,%edx
c0105608:	09 d0                	or     %edx,%eax
c010560a:	c1 e8 04             	shr    $0x4,%eax
c010560d:	09 d8                	or     %ebx,%eax
c010560f:	c1 e8 08             	shr    $0x8,%eax
c0105612:	89 cb                	mov    %ecx,%ebx
c0105614:	09 c3                	or     %eax,%ebx
c0105616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105619:	d1 e8                	shr    %eax
c010561b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010561e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105621:	d1 ea                	shr    %edx
c0105623:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105626:	c1 ea 02             	shr    $0x2,%edx
c0105629:	09 d0                	or     %edx,%eax
c010562b:	89 c1                	mov    %eax,%ecx
c010562d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105630:	d1 e8                	shr    %eax
c0105632:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105635:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105638:	d1 ea                	shr    %edx
c010563a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010563d:	c1 ea 02             	shr    $0x2,%edx
c0105640:	09 d0                	or     %edx,%eax
c0105642:	c1 e8 04             	shr    $0x4,%eax
c0105645:	09 c1                	or     %eax,%ecx
c0105647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010564a:	d1 e8                	shr    %eax
c010564c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010564f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105652:	d1 ea                	shr    %edx
c0105654:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105657:	c1 ea 02             	shr    $0x2,%edx
c010565a:	09 d0                	or     %edx,%eax
c010565c:	89 c6                	mov    %eax,%esi
c010565e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105661:	d1 e8                	shr    %eax
c0105663:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105666:	89 c2                	mov    %eax,%edx
c0105668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010566b:	d1 e8                	shr    %eax
c010566d:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105670:	c1 e8 02             	shr    $0x2,%eax
c0105673:	09 d0                	or     %edx,%eax
c0105675:	c1 e8 04             	shr    $0x4,%eax
c0105678:	09 f0                	or     %esi,%eax
c010567a:	c1 e8 08             	shr    $0x8,%eax
c010567d:	09 c8                	or     %ecx,%eax
c010567f:	c1 e8 10             	shr    $0x10,%eax
c0105682:	09 d8                	or     %ebx,%eax
c0105684:	d1 e8                	shr    %eax
c0105686:	f7 d0                	not    %eax
c0105688:	23 45 e4             	and    -0x1c(%ebp),%eax
c010568b:	89 c6                	mov    %eax,%esi
c010568d:	eb 03                	jmp    c0105692 <buddy_alloc_pages+0x3fd>
c010568f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c0105692:	89 f8                	mov    %edi,%eax
c0105694:	ba 00 00 00 00       	mov    $0x0,%edx
c0105699:	f7 f6                	div    %esi
c010569b:	39 85 74 ff ff ff    	cmp    %eax,-0x8c(%ebp)
c01056a1:	0f 85 4a 07 00 00    	jne    c0105df1 <buddy_alloc_pages+0xb5c>
            size_t begin = BUDDY_BEGIN(block);
c01056a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056aa:	d1 e8                	shr    %eax
c01056ac:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01056af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056b2:	d1 ea                	shr    %edx
c01056b4:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01056b7:	c1 ea 02             	shr    $0x2,%edx
c01056ba:	09 d0                	or     %edx,%eax
c01056bc:	89 c1                	mov    %eax,%ecx
c01056be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056c1:	d1 e8                	shr    %eax
c01056c3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01056c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056c9:	d1 ea                	shr    %edx
c01056cb:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01056ce:	c1 ea 02             	shr    $0x2,%edx
c01056d1:	09 d0                	or     %edx,%eax
c01056d3:	c1 e8 04             	shr    $0x4,%eax
c01056d6:	09 c1                	or     %eax,%ecx
c01056d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056db:	d1 e8                	shr    %eax
c01056dd:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01056e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056e3:	d1 ea                	shr    %edx
c01056e5:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01056e8:	c1 ea 02             	shr    $0x2,%edx
c01056eb:	09 d0                	or     %edx,%eax
c01056ed:	89 c3                	mov    %eax,%ebx
c01056ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056f2:	d1 e8                	shr    %eax
c01056f4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01056f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056fa:	d1 ea                	shr    %edx
c01056fc:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01056ff:	c1 ea 02             	shr    $0x2,%edx
c0105702:	09 d0                	or     %edx,%eax
c0105704:	c1 e8 04             	shr    $0x4,%eax
c0105707:	09 d8                	or     %ebx,%eax
c0105709:	c1 e8 08             	shr    $0x8,%eax
c010570c:	09 c1                	or     %eax,%ecx
c010570e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105711:	d1 e8                	shr    %eax
c0105713:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105716:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105719:	d1 ea                	shr    %edx
c010571b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010571e:	c1 ea 02             	shr    $0x2,%edx
c0105721:	09 d0                	or     %edx,%eax
c0105723:	89 c3                	mov    %eax,%ebx
c0105725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105728:	d1 e8                	shr    %eax
c010572a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010572d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105730:	d1 ea                	shr    %edx
c0105732:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105735:	c1 ea 02             	shr    $0x2,%edx
c0105738:	09 d0                	or     %edx,%eax
c010573a:	c1 e8 04             	shr    $0x4,%eax
c010573d:	09 c3                	or     %eax,%ebx
c010573f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105742:	d1 e8                	shr    %eax
c0105744:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105747:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010574a:	d1 ea                	shr    %edx
c010574c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010574f:	c1 ea 02             	shr    $0x2,%edx
c0105752:	09 d0                	or     %edx,%eax
c0105754:	89 c6                	mov    %eax,%esi
c0105756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105759:	d1 e8                	shr    %eax
c010575b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010575e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105761:	d1 ea                	shr    %edx
c0105763:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105766:	c1 ea 02             	shr    $0x2,%edx
c0105769:	09 d0                	or     %edx,%eax
c010576b:	c1 e8 04             	shr    $0x4,%eax
c010576e:	09 f0                	or     %esi,%eax
c0105770:	c1 e8 08             	shr    $0x8,%eax
c0105773:	09 d8                	or     %ebx,%eax
c0105775:	c1 e8 10             	shr    $0x10,%eax
c0105778:	09 c8                	or     %ecx,%eax
c010577a:	d1 e8                	shr    %eax
c010577c:	23 45 e4             	and    -0x1c(%ebp),%eax
c010577f:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
c0105785:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c010578b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010578e:	d1 e8                	shr    %eax
c0105790:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105796:	d1 ea                	shr    %edx
c0105798:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010579b:	c1 ea 02             	shr    $0x2,%edx
c010579e:	09 d0                	or     %edx,%eax
c01057a0:	89 c1                	mov    %eax,%ecx
c01057a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057a5:	d1 e8                	shr    %eax
c01057a7:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01057aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01057ad:	d1 ea                	shr    %edx
c01057af:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01057b2:	c1 ea 02             	shr    $0x2,%edx
c01057b5:	09 d0                	or     %edx,%eax
c01057b7:	c1 e8 04             	shr    $0x4,%eax
c01057ba:	09 c1                	or     %eax,%ecx
c01057bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057bf:	d1 e8                	shr    %eax
c01057c1:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01057c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01057c7:	d1 ea                	shr    %edx
c01057c9:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01057cc:	c1 ea 02             	shr    $0x2,%edx
c01057cf:	09 d0                	or     %edx,%eax
c01057d1:	89 c3                	mov    %eax,%ebx
c01057d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057d6:	d1 e8                	shr    %eax
c01057d8:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01057db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01057de:	d1 ea                	shr    %edx
c01057e0:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01057e3:	c1 ea 02             	shr    $0x2,%edx
c01057e6:	09 d0                	or     %edx,%eax
c01057e8:	c1 e8 04             	shr    $0x4,%eax
c01057eb:	09 d8                	or     %ebx,%eax
c01057ed:	c1 e8 08             	shr    $0x8,%eax
c01057f0:	89 cb                	mov    %ecx,%ebx
c01057f2:	09 c3                	or     %eax,%ebx
c01057f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057f7:	d1 e8                	shr    %eax
c01057f9:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01057fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01057ff:	d1 ea                	shr    %edx
c0105801:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105804:	c1 ea 02             	shr    $0x2,%edx
c0105807:	09 d0                	or     %edx,%eax
c0105809:	89 c1                	mov    %eax,%ecx
c010580b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010580e:	d1 e8                	shr    %eax
c0105810:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105816:	d1 ea                	shr    %edx
c0105818:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010581b:	c1 ea 02             	shr    $0x2,%edx
c010581e:	09 d0                	or     %edx,%eax
c0105820:	c1 e8 04             	shr    $0x4,%eax
c0105823:	09 c1                	or     %eax,%ecx
c0105825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105828:	d1 e8                	shr    %eax
c010582a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010582d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105830:	d1 ea                	shr    %edx
c0105832:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105835:	c1 ea 02             	shr    $0x2,%edx
c0105838:	09 d0                	or     %edx,%eax
c010583a:	89 c6                	mov    %eax,%esi
c010583c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010583f:	d1 e8                	shr    %eax
c0105841:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105844:	89 c2                	mov    %eax,%edx
c0105846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105849:	d1 e8                	shr    %eax
c010584b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010584e:	c1 e8 02             	shr    $0x2,%eax
c0105851:	09 d0                	or     %edx,%eax
c0105853:	c1 e8 04             	shr    $0x4,%eax
c0105856:	09 f0                	or     %esi,%eax
c0105858:	c1 e8 08             	shr    $0x8,%eax
c010585b:	09 c8                	or     %ecx,%eax
c010585d:	c1 e8 10             	shr    $0x10,%eax
c0105860:	09 d8                	or     %ebx,%eax
c0105862:	d1 e8                	shr    %eax
c0105864:	23 45 e4             	and    -0x1c(%ebp),%eax
c0105867:	85 c0                	test   %eax,%eax
c0105869:	0f 84 e2 00 00 00    	je     c0105951 <buddy_alloc_pages+0x6bc>
c010586f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105872:	d1 e8                	shr    %eax
c0105874:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105877:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010587a:	d1 ea                	shr    %edx
c010587c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010587f:	c1 ea 02             	shr    $0x2,%edx
c0105882:	09 d0                	or     %edx,%eax
c0105884:	89 c1                	mov    %eax,%ecx
c0105886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105889:	d1 e8                	shr    %eax
c010588b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010588e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105891:	d1 ea                	shr    %edx
c0105893:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105896:	c1 ea 02             	shr    $0x2,%edx
c0105899:	09 d0                	or     %edx,%eax
c010589b:	c1 e8 04             	shr    $0x4,%eax
c010589e:	09 c1                	or     %eax,%ecx
c01058a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058a3:	d1 e8                	shr    %eax
c01058a5:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01058a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01058ab:	d1 ea                	shr    %edx
c01058ad:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01058b0:	c1 ea 02             	shr    $0x2,%edx
c01058b3:	09 d0                	or     %edx,%eax
c01058b5:	89 c3                	mov    %eax,%ebx
c01058b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058ba:	d1 e8                	shr    %eax
c01058bc:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01058bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01058c2:	d1 ea                	shr    %edx
c01058c4:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01058c7:	c1 ea 02             	shr    $0x2,%edx
c01058ca:	09 d0                	or     %edx,%eax
c01058cc:	c1 e8 04             	shr    $0x4,%eax
c01058cf:	09 d8                	or     %ebx,%eax
c01058d1:	c1 e8 08             	shr    $0x8,%eax
c01058d4:	89 cb                	mov    %ecx,%ebx
c01058d6:	09 c3                	or     %eax,%ebx
c01058d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058db:	d1 e8                	shr    %eax
c01058dd:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01058e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01058e3:	d1 ea                	shr    %edx
c01058e5:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01058e8:	c1 ea 02             	shr    $0x2,%edx
c01058eb:	09 d0                	or     %edx,%eax
c01058ed:	89 c1                	mov    %eax,%ecx
c01058ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058f2:	d1 e8                	shr    %eax
c01058f4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01058f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01058fa:	d1 ea                	shr    %edx
c01058fc:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01058ff:	c1 ea 02             	shr    $0x2,%edx
c0105902:	09 d0                	or     %edx,%eax
c0105904:	c1 e8 04             	shr    $0x4,%eax
c0105907:	09 c1                	or     %eax,%ecx
c0105909:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010590c:	d1 e8                	shr    %eax
c010590e:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105911:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105914:	d1 ea                	shr    %edx
c0105916:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105919:	c1 ea 02             	shr    $0x2,%edx
c010591c:	09 d0                	or     %edx,%eax
c010591e:	89 c6                	mov    %eax,%esi
c0105920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105923:	d1 e8                	shr    %eax
c0105925:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105928:	89 c2                	mov    %eax,%edx
c010592a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010592d:	d1 e8                	shr    %eax
c010592f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105932:	c1 e8 02             	shr    $0x2,%eax
c0105935:	09 d0                	or     %edx,%eax
c0105937:	c1 e8 04             	shr    $0x4,%eax
c010593a:	09 f0                	or     %esi,%eax
c010593c:	c1 e8 08             	shr    $0x8,%eax
c010593f:	09 c8                	or     %ecx,%eax
c0105941:	c1 e8 10             	shr    $0x10,%eax
c0105944:	09 d8                	or     %ebx,%eax
c0105946:	d1 e8                	shr    %eax
c0105948:	f7 d0                	not    %eax
c010594a:	23 45 e4             	and    -0x1c(%ebp),%eax
c010594d:	89 c6                	mov    %eax,%esi
c010594f:	eb 03                	jmp    c0105954 <buddy_alloc_pages+0x6bf>
c0105951:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c0105954:	89 f8                	mov    %edi,%eax
c0105956:	ba 00 00 00 00       	mov    $0x0,%edx
c010595b:	f7 f6                	div    %esi
c010595d:	0f af 85 74 ff ff ff 	imul   -0x8c(%ebp),%eax
c0105964:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            size_t end = BUDDY_END(block);
c0105967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010596a:	d1 e8                	shr    %eax
c010596c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010596f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105972:	d1 ea                	shr    %edx
c0105974:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105977:	c1 ea 02             	shr    $0x2,%edx
c010597a:	09 d0                	or     %edx,%eax
c010597c:	89 c1                	mov    %eax,%ecx
c010597e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105981:	d1 e8                	shr    %eax
c0105983:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105986:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105989:	d1 ea                	shr    %edx
c010598b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010598e:	c1 ea 02             	shr    $0x2,%edx
c0105991:	09 d0                	or     %edx,%eax
c0105993:	c1 e8 04             	shr    $0x4,%eax
c0105996:	09 c1                	or     %eax,%ecx
c0105998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010599b:	d1 e8                	shr    %eax
c010599d:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01059a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01059a3:	d1 ea                	shr    %edx
c01059a5:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01059a8:	c1 ea 02             	shr    $0x2,%edx
c01059ab:	09 d0                	or     %edx,%eax
c01059ad:	89 c3                	mov    %eax,%ebx
c01059af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059b2:	d1 e8                	shr    %eax
c01059b4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01059b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01059ba:	d1 ea                	shr    %edx
c01059bc:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01059bf:	c1 ea 02             	shr    $0x2,%edx
c01059c2:	09 d0                	or     %edx,%eax
c01059c4:	c1 e8 04             	shr    $0x4,%eax
c01059c7:	09 d8                	or     %ebx,%eax
c01059c9:	c1 e8 08             	shr    $0x8,%eax
c01059cc:	09 c1                	or     %eax,%ecx
c01059ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059d1:	d1 e8                	shr    %eax
c01059d3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01059d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01059d9:	d1 ea                	shr    %edx
c01059db:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01059de:	c1 ea 02             	shr    $0x2,%edx
c01059e1:	09 d0                	or     %edx,%eax
c01059e3:	89 c3                	mov    %eax,%ebx
c01059e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059e8:	d1 e8                	shr    %eax
c01059ea:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01059ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01059f0:	d1 ea                	shr    %edx
c01059f2:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01059f5:	c1 ea 02             	shr    $0x2,%edx
c01059f8:	09 d0                	or     %edx,%eax
c01059fa:	c1 e8 04             	shr    $0x4,%eax
c01059fd:	09 c3                	or     %eax,%ebx
c01059ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a02:	d1 e8                	shr    %eax
c0105a04:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105a07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a0a:	d1 ea                	shr    %edx
c0105a0c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105a0f:	c1 ea 02             	shr    $0x2,%edx
c0105a12:	09 d0                	or     %edx,%eax
c0105a14:	89 c6                	mov    %eax,%esi
c0105a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a19:	d1 e8                	shr    %eax
c0105a1b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105a1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a21:	d1 ea                	shr    %edx
c0105a23:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105a26:	c1 ea 02             	shr    $0x2,%edx
c0105a29:	09 d0                	or     %edx,%eax
c0105a2b:	c1 e8 04             	shr    $0x4,%eax
c0105a2e:	09 f0                	or     %esi,%eax
c0105a30:	c1 e8 08             	shr    $0x8,%eax
c0105a33:	09 d8                	or     %ebx,%eax
c0105a35:	c1 e8 10             	shr    $0x10,%eax
c0105a38:	09 c8                	or     %ecx,%eax
c0105a3a:	d1 e8                	shr    %eax
c0105a3c:	23 45 e4             	and    -0x1c(%ebp),%eax
c0105a3f:	83 c0 01             	add    $0x1,%eax
c0105a42:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
c0105a48:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c0105a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a51:	d1 e8                	shr    %eax
c0105a53:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105a56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a59:	d1 ea                	shr    %edx
c0105a5b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105a5e:	c1 ea 02             	shr    $0x2,%edx
c0105a61:	09 d0                	or     %edx,%eax
c0105a63:	89 c1                	mov    %eax,%ecx
c0105a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a68:	d1 e8                	shr    %eax
c0105a6a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105a6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a70:	d1 ea                	shr    %edx
c0105a72:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105a75:	c1 ea 02             	shr    $0x2,%edx
c0105a78:	09 d0                	or     %edx,%eax
c0105a7a:	c1 e8 04             	shr    $0x4,%eax
c0105a7d:	09 c1                	or     %eax,%ecx
c0105a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a82:	d1 e8                	shr    %eax
c0105a84:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105a87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a8a:	d1 ea                	shr    %edx
c0105a8c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105a8f:	c1 ea 02             	shr    $0x2,%edx
c0105a92:	09 d0                	or     %edx,%eax
c0105a94:	89 c3                	mov    %eax,%ebx
c0105a96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a99:	d1 e8                	shr    %eax
c0105a9b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105a9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105aa1:	d1 ea                	shr    %edx
c0105aa3:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105aa6:	c1 ea 02             	shr    $0x2,%edx
c0105aa9:	09 d0                	or     %edx,%eax
c0105aab:	c1 e8 04             	shr    $0x4,%eax
c0105aae:	09 d8                	or     %ebx,%eax
c0105ab0:	c1 e8 08             	shr    $0x8,%eax
c0105ab3:	89 cb                	mov    %ecx,%ebx
c0105ab5:	09 c3                	or     %eax,%ebx
c0105ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105aba:	d1 e8                	shr    %eax
c0105abc:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105abf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ac2:	d1 ea                	shr    %edx
c0105ac4:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105ac7:	c1 ea 02             	shr    $0x2,%edx
c0105aca:	09 d0                	or     %edx,%eax
c0105acc:	89 c1                	mov    %eax,%ecx
c0105ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ad1:	d1 e8                	shr    %eax
c0105ad3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105ad6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ad9:	d1 ea                	shr    %edx
c0105adb:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105ade:	c1 ea 02             	shr    $0x2,%edx
c0105ae1:	09 d0                	or     %edx,%eax
c0105ae3:	c1 e8 04             	shr    $0x4,%eax
c0105ae6:	09 c1                	or     %eax,%ecx
c0105ae8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105aeb:	d1 e8                	shr    %eax
c0105aed:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105af0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105af3:	d1 ea                	shr    %edx
c0105af5:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105af8:	c1 ea 02             	shr    $0x2,%edx
c0105afb:	09 d0                	or     %edx,%eax
c0105afd:	89 c6                	mov    %eax,%esi
c0105aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b02:	d1 e8                	shr    %eax
c0105b04:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105b07:	89 c2                	mov    %eax,%edx
c0105b09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b0c:	d1 e8                	shr    %eax
c0105b0e:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105b11:	c1 e8 02             	shr    $0x2,%eax
c0105b14:	09 d0                	or     %edx,%eax
c0105b16:	c1 e8 04             	shr    $0x4,%eax
c0105b19:	09 f0                	or     %esi,%eax
c0105b1b:	c1 e8 08             	shr    $0x8,%eax
c0105b1e:	09 c8                	or     %ecx,%eax
c0105b20:	c1 e8 10             	shr    $0x10,%eax
c0105b23:	09 d8                	or     %ebx,%eax
c0105b25:	d1 e8                	shr    %eax
c0105b27:	23 45 e4             	and    -0x1c(%ebp),%eax
c0105b2a:	85 c0                	test   %eax,%eax
c0105b2c:	0f 84 e2 00 00 00    	je     c0105c14 <buddy_alloc_pages+0x97f>
c0105b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b35:	d1 e8                	shr    %eax
c0105b37:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105b3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b3d:	d1 ea                	shr    %edx
c0105b3f:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105b42:	c1 ea 02             	shr    $0x2,%edx
c0105b45:	09 d0                	or     %edx,%eax
c0105b47:	89 c1                	mov    %eax,%ecx
c0105b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b4c:	d1 e8                	shr    %eax
c0105b4e:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105b51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b54:	d1 ea                	shr    %edx
c0105b56:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105b59:	c1 ea 02             	shr    $0x2,%edx
c0105b5c:	09 d0                	or     %edx,%eax
c0105b5e:	c1 e8 04             	shr    $0x4,%eax
c0105b61:	09 c1                	or     %eax,%ecx
c0105b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b66:	d1 e8                	shr    %eax
c0105b68:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105b6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b6e:	d1 ea                	shr    %edx
c0105b70:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105b73:	c1 ea 02             	shr    $0x2,%edx
c0105b76:	09 d0                	or     %edx,%eax
c0105b78:	89 c3                	mov    %eax,%ebx
c0105b7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b7d:	d1 e8                	shr    %eax
c0105b7f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105b82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b85:	d1 ea                	shr    %edx
c0105b87:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105b8a:	c1 ea 02             	shr    $0x2,%edx
c0105b8d:	09 d0                	or     %edx,%eax
c0105b8f:	c1 e8 04             	shr    $0x4,%eax
c0105b92:	09 d8                	or     %ebx,%eax
c0105b94:	c1 e8 08             	shr    $0x8,%eax
c0105b97:	89 cb                	mov    %ecx,%ebx
c0105b99:	09 c3                	or     %eax,%ebx
c0105b9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b9e:	d1 e8                	shr    %eax
c0105ba0:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105ba3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ba6:	d1 ea                	shr    %edx
c0105ba8:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105bab:	c1 ea 02             	shr    $0x2,%edx
c0105bae:	09 d0                	or     %edx,%eax
c0105bb0:	89 c1                	mov    %eax,%ecx
c0105bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105bb5:	d1 e8                	shr    %eax
c0105bb7:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105bba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105bbd:	d1 ea                	shr    %edx
c0105bbf:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105bc2:	c1 ea 02             	shr    $0x2,%edx
c0105bc5:	09 d0                	or     %edx,%eax
c0105bc7:	c1 e8 04             	shr    $0x4,%eax
c0105bca:	09 c1                	or     %eax,%ecx
c0105bcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105bcf:	d1 e8                	shr    %eax
c0105bd1:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105bd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105bd7:	d1 ea                	shr    %edx
c0105bd9:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105bdc:	c1 ea 02             	shr    $0x2,%edx
c0105bdf:	09 d0                	or     %edx,%eax
c0105be1:	89 c6                	mov    %eax,%esi
c0105be3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105be6:	d1 e8                	shr    %eax
c0105be8:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105beb:	89 c2                	mov    %eax,%edx
c0105bed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105bf0:	d1 e8                	shr    %eax
c0105bf2:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105bf5:	c1 e8 02             	shr    $0x2,%eax
c0105bf8:	09 d0                	or     %edx,%eax
c0105bfa:	c1 e8 04             	shr    $0x4,%eax
c0105bfd:	09 f0                	or     %esi,%eax
c0105bff:	c1 e8 08             	shr    $0x8,%eax
c0105c02:	09 c8                	or     %ecx,%eax
c0105c04:	c1 e8 10             	shr    $0x10,%eax
c0105c07:	09 d8                	or     %ebx,%eax
c0105c09:	d1 e8                	shr    %eax
c0105c0b:	f7 d0                	not    %eax
c0105c0d:	23 45 e4             	and    -0x1c(%ebp),%eax
c0105c10:	89 c6                	mov    %eax,%esi
c0105c12:	eb 03                	jmp    c0105c17 <buddy_alloc_pages+0x982>
c0105c14:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c0105c17:	89 f8                	mov    %edi,%eax
c0105c19:	ba 00 00 00 00       	mov    $0x0,%edx
c0105c1e:	f7 f6                	div    %esi
c0105c20:	0f af 85 74 ff ff ff 	imul   -0x8c(%ebp),%eax
c0105c27:	89 45 d0             	mov    %eax,-0x30(%ebp)
            size_t mid = (begin+end)>>1;
c0105c2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105c2d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105c30:	01 d0                	add    %edx,%eax
c0105c32:	d1 e8                	shr    %eax
c0105c34:	89 45 cc             	mov    %eax,-0x34(%ebp)
            list_del(&(buddy_alloc[begin].page_link));
c0105c37:	8b 0d 64 e9 11 c0    	mov    0xc011e964,%ecx
c0105c3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105c40:	89 d0                	mov    %edx,%eax
c0105c42:	c1 e0 02             	shl    $0x2,%eax
c0105c45:	01 d0                	add    %edx,%eax
c0105c47:	c1 e0 02             	shl    $0x2,%eax
c0105c4a:	01 c8                	add    %ecx,%eax
c0105c4c:	83 c0 0c             	add    $0xc,%eax
c0105c4f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105c52:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105c55:	8b 40 04             	mov    0x4(%eax),%eax
c0105c58:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105c5b:	8b 12                	mov    (%edx),%edx
c0105c5d:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0105c60:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105c63:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105c66:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105c69:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105c6c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105c6f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105c72:	89 10                	mov    %edx,(%eax)
            buddy_alloc[begin].property >>= 1;
c0105c74:	8b 0d 64 e9 11 c0    	mov    0xc011e964,%ecx
c0105c7a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105c7d:	89 d0                	mov    %edx,%eax
c0105c7f:	c1 e0 02             	shl    $0x2,%eax
c0105c82:	01 d0                	add    %edx,%eax
c0105c84:	c1 e0 02             	shl    $0x2,%eax
c0105c87:	01 c1                	add    %eax,%ecx
c0105c89:	8b 1d 64 e9 11 c0    	mov    0xc011e964,%ebx
c0105c8f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105c92:	89 d0                	mov    %edx,%eax
c0105c94:	c1 e0 02             	shl    $0x2,%eax
c0105c97:	01 d0                	add    %edx,%eax
c0105c99:	c1 e0 02             	shl    $0x2,%eax
c0105c9c:	01 d8                	add    %ebx,%eax
c0105c9e:	8b 40 08             	mov    0x8(%eax),%eax
c0105ca1:	d1 e8                	shr    %eax
c0105ca3:	89 41 08             	mov    %eax,0x8(%ecx)
            buddy_alloc[mid].property = buddy_alloc[begin].property;
c0105ca6:	8b 0d 64 e9 11 c0    	mov    0xc011e964,%ecx
c0105cac:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105caf:	89 d0                	mov    %edx,%eax
c0105cb1:	c1 e0 02             	shl    $0x2,%eax
c0105cb4:	01 d0                	add    %edx,%eax
c0105cb6:	c1 e0 02             	shl    $0x2,%eax
c0105cb9:	01 c1                	add    %eax,%ecx
c0105cbb:	8b 1d 64 e9 11 c0    	mov    0xc011e964,%ebx
c0105cc1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105cc4:	89 d0                	mov    %edx,%eax
c0105cc6:	c1 e0 02             	shl    $0x2,%eax
c0105cc9:	01 d0                	add    %edx,%eax
c0105ccb:	c1 e0 02             	shl    $0x2,%eax
c0105cce:	01 d8                	add    %ebx,%eax
c0105cd0:	8b 40 08             	mov    0x8(%eax),%eax
c0105cd3:	89 41 08             	mov    %eax,0x8(%ecx)
            buddy_segment[left] = buddy_segment[block]>>1;
c0105cd6:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0105cdb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105cde:	c1 e2 02             	shl    $0x2,%edx
c0105ce1:	01 d0                	add    %edx,%eax
c0105ce3:	8b 15 5c e9 11 c0    	mov    0xc011e95c,%edx
c0105ce9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105cec:	c1 e1 02             	shl    $0x2,%ecx
c0105cef:	01 ca                	add    %ecx,%edx
c0105cf1:	8b 12                	mov    (%edx),%edx
c0105cf3:	d1 ea                	shr    %edx
c0105cf5:	89 10                	mov    %edx,(%eax)
            buddy_segment[right] = buddy_segment[block]>>1;
c0105cf7:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0105cfc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105cff:	c1 e2 02             	shl    $0x2,%edx
c0105d02:	01 d0                	add    %edx,%eax
c0105d04:	8b 15 5c e9 11 c0    	mov    0xc011e95c,%edx
c0105d0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105d0d:	c1 e1 02             	shl    $0x2,%ecx
c0105d10:	01 ca                	add    %ecx,%edx
c0105d12:	8b 12                	mov    (%edx),%edx
c0105d14:	d1 ea                	shr    %edx
c0105d16:	89 10                	mov    %edx,(%eax)
            list_add(&free_list, &(buddy_alloc[begin].page_link));
c0105d18:	8b 0d 64 e9 11 c0    	mov    0xc011e964,%ecx
c0105d1e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105d21:	89 d0                	mov    %edx,%eax
c0105d23:	c1 e0 02             	shl    $0x2,%eax
c0105d26:	01 d0                	add    %edx,%eax
c0105d28:	c1 e0 02             	shl    $0x2,%eax
c0105d2b:	01 c8                	add    %ecx,%eax
c0105d2d:	83 c0 0c             	add    $0xc,%eax
c0105d30:	c7 45 b8 78 e9 11 c0 	movl   $0xc011e978,-0x48(%ebp)
c0105d37:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0105d3a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105d3d:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0105d40:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105d43:	89 45 ac             	mov    %eax,-0x54(%ebp)
    __list_add(elm, listelm, listelm->next);
c0105d46:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105d49:	8b 40 04             	mov    0x4(%eax),%eax
c0105d4c:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0105d4f:	89 55 a8             	mov    %edx,-0x58(%ebp)
c0105d52:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105d55:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0105d58:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next->prev = elm;
c0105d5b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105d5e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105d61:	89 10                	mov    %edx,(%eax)
c0105d63:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105d66:	8b 10                	mov    (%eax),%edx
c0105d68:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105d6b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105d6e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105d71:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105d74:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105d77:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105d7a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0105d7d:	89 10                	mov    %edx,(%eax)
            list_add(&free_list, &(buddy_alloc[mid].page_link));
c0105d7f:	8b 0d 64 e9 11 c0    	mov    0xc011e964,%ecx
c0105d85:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105d88:	89 d0                	mov    %edx,%eax
c0105d8a:	c1 e0 02             	shl    $0x2,%eax
c0105d8d:	01 d0                	add    %edx,%eax
c0105d8f:	c1 e0 02             	shl    $0x2,%eax
c0105d92:	01 c8                	add    %ecx,%eax
c0105d94:	83 c0 0c             	add    $0xc,%eax
c0105d97:	c7 45 9c 78 e9 11 c0 	movl   $0xc011e978,-0x64(%ebp)
c0105d9e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105da1:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105da4:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105da7:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105daa:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
c0105dad:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105db0:	8b 40 04             	mov    0x4(%eax),%eax
c0105db3:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105db6:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0105db9:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105dbc:	89 55 88             	mov    %edx,-0x78(%ebp)
c0105dbf:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0105dc2:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105dc5:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105dc8:	89 10                	mov    %edx,(%eax)
c0105dca:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105dcd:	8b 10                	mov    (%eax),%edx
c0105dcf:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105dd2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105dd5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105dd8:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105ddb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105dde:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105de1:	8b 55 88             	mov    -0x78(%ebp),%edx
c0105de4:	89 10                	mov    %edx,(%eax)
            block = left;
c0105de6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105de9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105dec:	e9 98 00 00 00       	jmp    c0105e89 <buddy_alloc_pages+0xbf4>
        } else if (length & buddy_segment[left]) {  // Find in left (optimize)
c0105df1:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0105df6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105df9:	c1 e2 02             	shl    $0x2,%edx
c0105dfc:	01 d0                	add    %edx,%eax
c0105dfe:	8b 00                	mov    (%eax),%eax
c0105e00:	23 45 e0             	and    -0x20(%ebp),%eax
c0105e03:	85 c0                	test   %eax,%eax
c0105e05:	74 08                	je     c0105e0f <buddy_alloc_pages+0xb7a>
            block = left;
c0105e07:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e0d:	eb 7a                	jmp    c0105e89 <buddy_alloc_pages+0xbf4>
        } else if (length & buddy_segment[right]) { // Find in right (optimize)
c0105e0f:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0105e14:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e17:	c1 e2 02             	shl    $0x2,%edx
c0105e1a:	01 d0                	add    %edx,%eax
c0105e1c:	8b 00                	mov    (%eax),%eax
c0105e1e:	23 45 e0             	and    -0x20(%ebp),%eax
c0105e21:	85 c0                	test   %eax,%eax
c0105e23:	74 08                	je     c0105e2d <buddy_alloc_pages+0xb98>
            block = right;
c0105e25:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105e28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e2b:	eb 5c                	jmp    c0105e89 <buddy_alloc_pages+0xbf4>
        } else if (length <= buddy_segment[left]) { // Find in left
c0105e2d:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0105e32:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105e35:	c1 e2 02             	shl    $0x2,%edx
c0105e38:	01 d0                	add    %edx,%eax
c0105e3a:	8b 00                	mov    (%eax),%eax
c0105e3c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0105e3f:	72 08                	jb     c0105e49 <buddy_alloc_pages+0xbb4>
            block = left;
c0105e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e47:	eb 40                	jmp    c0105e89 <buddy_alloc_pages+0xbf4>
        } else if (length <= buddy_segment[right]) {// Find in right
c0105e49:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0105e4e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e51:	c1 e2 02             	shl    $0x2,%edx
c0105e54:	01 d0                	add    %edx,%eax
c0105e56:	8b 00                	mov    (%eax),%eax
c0105e58:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0105e5b:	72 08                	jb     c0105e65 <buddy_alloc_pages+0xbd0>
            block = right;
c0105e5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105e60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e63:	eb 24                	jmp    c0105e89 <buddy_alloc_pages+0xbf4>
        } else {                                    // Shouldn't be here
            assert(0);
c0105e65:	c7 44 24 0c f5 ab 10 	movl   $0xc010abf5,0xc(%esp)
c0105e6c:	c0 
c0105e6d:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0105e74:	c0 
c0105e75:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c0105e7c:	00 
c0105e7d:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0105e84:	e8 5f a5 ff ff       	call   c01003e8 <__panic>
    while (length <= buddy_segment[block] && length < BUDDY_LENGTH(block)) {
c0105e89:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0105e8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e91:	c1 e2 02             	shl    $0x2,%edx
c0105e94:	01 d0                	add    %edx,%eax
c0105e96:	8b 00                	mov    (%eax),%eax
c0105e98:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0105e9b:	0f 82 d6 01 00 00    	jb     c0106077 <buddy_alloc_pages+0xde2>
c0105ea1:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c0105ea6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ea9:	d1 ea                	shr    %edx
c0105eab:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105eae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105eb1:	d1 e9                	shr    %ecx
c0105eb3:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105eb6:	c1 e9 02             	shr    $0x2,%ecx
c0105eb9:	89 d3                	mov    %edx,%ebx
c0105ebb:	09 cb                	or     %ecx,%ebx
c0105ebd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ec0:	d1 ea                	shr    %edx
c0105ec2:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105ec5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105ec8:	d1 e9                	shr    %ecx
c0105eca:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105ecd:	c1 e9 02             	shr    $0x2,%ecx
c0105ed0:	09 ca                	or     %ecx,%edx
c0105ed2:	c1 ea 04             	shr    $0x4,%edx
c0105ed5:	09 d3                	or     %edx,%ebx
c0105ed7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105eda:	d1 ea                	shr    %edx
c0105edc:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105edf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105ee2:	d1 e9                	shr    %ecx
c0105ee4:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105ee7:	c1 e9 02             	shr    $0x2,%ecx
c0105eea:	89 d6                	mov    %edx,%esi
c0105eec:	09 ce                	or     %ecx,%esi
c0105eee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ef1:	d1 ea                	shr    %edx
c0105ef3:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105ef6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105ef9:	d1 e9                	shr    %ecx
c0105efb:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105efe:	c1 e9 02             	shr    $0x2,%ecx
c0105f01:	09 ca                	or     %ecx,%edx
c0105f03:	c1 ea 04             	shr    $0x4,%edx
c0105f06:	09 f2                	or     %esi,%edx
c0105f08:	c1 ea 08             	shr    $0x8,%edx
c0105f0b:	09 d3                	or     %edx,%ebx
c0105f0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f10:	d1 ea                	shr    %edx
c0105f12:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105f18:	d1 e9                	shr    %ecx
c0105f1a:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105f1d:	c1 e9 02             	shr    $0x2,%ecx
c0105f20:	89 d6                	mov    %edx,%esi
c0105f22:	09 ce                	or     %ecx,%esi
c0105f24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f27:	d1 ea                	shr    %edx
c0105f29:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105f2c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105f2f:	d1 e9                	shr    %ecx
c0105f31:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105f34:	c1 e9 02             	shr    $0x2,%ecx
c0105f37:	09 ca                	or     %ecx,%edx
c0105f39:	c1 ea 04             	shr    $0x4,%edx
c0105f3c:	09 d6                	or     %edx,%esi
c0105f3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f41:	d1 ea                	shr    %edx
c0105f43:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105f46:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105f49:	d1 e9                	shr    %ecx
c0105f4b:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105f4e:	c1 e9 02             	shr    $0x2,%ecx
c0105f51:	89 d7                	mov    %edx,%edi
c0105f53:	09 cf                	or     %ecx,%edi
c0105f55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f58:	d1 ea                	shr    %edx
c0105f5a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105f5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105f60:	d1 e9                	shr    %ecx
c0105f62:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105f65:	c1 e9 02             	shr    $0x2,%ecx
c0105f68:	09 ca                	or     %ecx,%edx
c0105f6a:	c1 ea 04             	shr    $0x4,%edx
c0105f6d:	09 fa                	or     %edi,%edx
c0105f6f:	c1 ea 08             	shr    $0x8,%edx
c0105f72:	09 f2                	or     %esi,%edx
c0105f74:	c1 ea 10             	shr    $0x10,%edx
c0105f77:	09 da                	or     %ebx,%edx
c0105f79:	d1 ea                	shr    %edx
c0105f7b:	23 55 e4             	and    -0x1c(%ebp),%edx
c0105f7e:	85 d2                	test   %edx,%edx
c0105f80:	0f 84 de 00 00 00    	je     c0106064 <buddy_alloc_pages+0xdcf>
c0105f86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f89:	d1 ea                	shr    %edx
c0105f8b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105f8e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105f91:	d1 e9                	shr    %ecx
c0105f93:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105f96:	c1 e9 02             	shr    $0x2,%ecx
c0105f99:	89 d3                	mov    %edx,%ebx
c0105f9b:	09 cb                	or     %ecx,%ebx
c0105f9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105fa0:	d1 ea                	shr    %edx
c0105fa2:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105fa5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105fa8:	d1 e9                	shr    %ecx
c0105faa:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105fad:	c1 e9 02             	shr    $0x2,%ecx
c0105fb0:	09 ca                	or     %ecx,%edx
c0105fb2:	c1 ea 04             	shr    $0x4,%edx
c0105fb5:	09 d3                	or     %edx,%ebx
c0105fb7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105fba:	d1 ea                	shr    %edx
c0105fbc:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105fbf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105fc2:	d1 e9                	shr    %ecx
c0105fc4:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105fc7:	c1 e9 02             	shr    $0x2,%ecx
c0105fca:	89 d6                	mov    %edx,%esi
c0105fcc:	09 ce                	or     %ecx,%esi
c0105fce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105fd1:	d1 ea                	shr    %edx
c0105fd3:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105fd6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105fd9:	d1 e9                	shr    %ecx
c0105fdb:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105fde:	c1 e9 02             	shr    $0x2,%ecx
c0105fe1:	09 ca                	or     %ecx,%edx
c0105fe3:	c1 ea 04             	shr    $0x4,%edx
c0105fe6:	09 f2                	or     %esi,%edx
c0105fe8:	c1 ea 08             	shr    $0x8,%edx
c0105feb:	09 d3                	or     %edx,%ebx
c0105fed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ff0:	d1 ea                	shr    %edx
c0105ff2:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105ff5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0105ff8:	d1 e9                	shr    %ecx
c0105ffa:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0105ffd:	c1 e9 02             	shr    $0x2,%ecx
c0106000:	89 d6                	mov    %edx,%esi
c0106002:	09 ce                	or     %ecx,%esi
c0106004:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106007:	d1 ea                	shr    %edx
c0106009:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010600c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010600f:	d1 e9                	shr    %ecx
c0106011:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0106014:	c1 e9 02             	shr    $0x2,%ecx
c0106017:	09 ca                	or     %ecx,%edx
c0106019:	c1 ea 04             	shr    $0x4,%edx
c010601c:	09 d6                	or     %edx,%esi
c010601e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106021:	d1 ea                	shr    %edx
c0106023:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106026:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0106029:	d1 e9                	shr    %ecx
c010602b:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c010602e:	c1 e9 02             	shr    $0x2,%ecx
c0106031:	89 d7                	mov    %edx,%edi
c0106033:	09 cf                	or     %ecx,%edi
c0106035:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106038:	d1 ea                	shr    %edx
c010603a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010603d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0106040:	d1 e9                	shr    %ecx
c0106042:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0106045:	c1 e9 02             	shr    $0x2,%ecx
c0106048:	09 ca                	or     %ecx,%edx
c010604a:	c1 ea 04             	shr    $0x4,%edx
c010604d:	09 fa                	or     %edi,%edx
c010604f:	c1 ea 08             	shr    $0x8,%edx
c0106052:	09 f2                	or     %esi,%edx
c0106054:	c1 ea 10             	shr    $0x10,%edx
c0106057:	09 da                	or     %ebx,%edx
c0106059:	d1 ea                	shr    %edx
c010605b:	f7 d2                	not    %edx
c010605d:	89 d7                	mov    %edx,%edi
c010605f:	23 7d e4             	and    -0x1c(%ebp),%edi
c0106062:	eb 03                	jmp    c0106067 <buddy_alloc_pages+0xdd2>
c0106064:	8b 7d e4             	mov    -0x1c(%ebp),%edi
c0106067:	ba 00 00 00 00       	mov    $0x0,%edx
c010606c:	f7 f7                	div    %edi
c010606e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0106071:	0f 87 24 f4 ff ff    	ja     c010549b <buddy_alloc_pages+0x206>
        }
    }
    // Allocate
    if (length > buddy_segment[block])
c0106077:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c010607c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010607f:	c1 e2 02             	shl    $0x2,%edx
c0106082:	01 d0                	add    %edx,%eax
c0106084:	8b 00                	mov    (%eax),%eax
c0106086:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0106089:	73 0a                	jae    c0106095 <buddy_alloc_pages+0xe00>
        return NULL;
c010608b:	b8 00 00 00 00       	mov    $0x0,%eax
c0106090:	e9 8c 03 00 00       	jmp    c0106421 <buddy_alloc_pages+0x118c>
    page = &(buddy_alloc[BUDDY_BEGIN(block)]);
c0106095:	a1 64 e9 11 c0       	mov    0xc011e964,%eax
c010609a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
c01060a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060a3:	d1 e8                	shr    %eax
c01060a5:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01060a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01060ab:	d1 ea                	shr    %edx
c01060ad:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01060b0:	c1 ea 02             	shr    $0x2,%edx
c01060b3:	09 d0                	or     %edx,%eax
c01060b5:	89 c1                	mov    %eax,%ecx
c01060b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060ba:	d1 e8                	shr    %eax
c01060bc:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01060bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01060c2:	d1 ea                	shr    %edx
c01060c4:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01060c7:	c1 ea 02             	shr    $0x2,%edx
c01060ca:	09 d0                	or     %edx,%eax
c01060cc:	c1 e8 04             	shr    $0x4,%eax
c01060cf:	09 c1                	or     %eax,%ecx
c01060d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060d4:	d1 e8                	shr    %eax
c01060d6:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01060d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01060dc:	d1 ea                	shr    %edx
c01060de:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01060e1:	c1 ea 02             	shr    $0x2,%edx
c01060e4:	09 d0                	or     %edx,%eax
c01060e6:	89 c3                	mov    %eax,%ebx
c01060e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060eb:	d1 e8                	shr    %eax
c01060ed:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01060f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01060f3:	d1 ea                	shr    %edx
c01060f5:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01060f8:	c1 ea 02             	shr    $0x2,%edx
c01060fb:	09 d0                	or     %edx,%eax
c01060fd:	c1 e8 04             	shr    $0x4,%eax
c0106100:	09 d8                	or     %ebx,%eax
c0106102:	c1 e8 08             	shr    $0x8,%eax
c0106105:	09 c1                	or     %eax,%ecx
c0106107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010610a:	d1 e8                	shr    %eax
c010610c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010610f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106112:	d1 ea                	shr    %edx
c0106114:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106117:	c1 ea 02             	shr    $0x2,%edx
c010611a:	09 d0                	or     %edx,%eax
c010611c:	89 c3                	mov    %eax,%ebx
c010611e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106121:	d1 e8                	shr    %eax
c0106123:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106126:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106129:	d1 ea                	shr    %edx
c010612b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010612e:	c1 ea 02             	shr    $0x2,%edx
c0106131:	09 d0                	or     %edx,%eax
c0106133:	c1 e8 04             	shr    $0x4,%eax
c0106136:	09 c3                	or     %eax,%ebx
c0106138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010613b:	d1 e8                	shr    %eax
c010613d:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106140:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106143:	d1 ea                	shr    %edx
c0106145:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106148:	c1 ea 02             	shr    $0x2,%edx
c010614b:	09 d0                	or     %edx,%eax
c010614d:	89 c6                	mov    %eax,%esi
c010614f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106152:	d1 e8                	shr    %eax
c0106154:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106157:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010615a:	d1 ea                	shr    %edx
c010615c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010615f:	c1 ea 02             	shr    $0x2,%edx
c0106162:	09 d0                	or     %edx,%eax
c0106164:	c1 e8 04             	shr    $0x4,%eax
c0106167:	09 f0                	or     %esi,%eax
c0106169:	c1 e8 08             	shr    $0x8,%eax
c010616c:	09 d8                	or     %ebx,%eax
c010616e:	c1 e8 10             	shr    $0x10,%eax
c0106171:	09 c8                	or     %ecx,%eax
c0106173:	d1 e8                	shr    %eax
c0106175:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106178:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
c010617e:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c0106184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106187:	d1 e8                	shr    %eax
c0106189:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010618c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010618f:	d1 ea                	shr    %edx
c0106191:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106194:	c1 ea 02             	shr    $0x2,%edx
c0106197:	09 d0                	or     %edx,%eax
c0106199:	89 c1                	mov    %eax,%ecx
c010619b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010619e:	d1 e8                	shr    %eax
c01061a0:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01061a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01061a6:	d1 ea                	shr    %edx
c01061a8:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01061ab:	c1 ea 02             	shr    $0x2,%edx
c01061ae:	09 d0                	or     %edx,%eax
c01061b0:	c1 e8 04             	shr    $0x4,%eax
c01061b3:	09 c1                	or     %eax,%ecx
c01061b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061b8:	d1 e8                	shr    %eax
c01061ba:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01061bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01061c0:	d1 ea                	shr    %edx
c01061c2:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01061c5:	c1 ea 02             	shr    $0x2,%edx
c01061c8:	09 d0                	or     %edx,%eax
c01061ca:	89 c3                	mov    %eax,%ebx
c01061cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061cf:	d1 e8                	shr    %eax
c01061d1:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01061d4:	89 c2                	mov    %eax,%edx
c01061d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061d9:	d1 e8                	shr    %eax
c01061db:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01061de:	c1 e8 02             	shr    $0x2,%eax
c01061e1:	09 d0                	or     %edx,%eax
c01061e3:	c1 e8 04             	shr    $0x4,%eax
c01061e6:	09 d8                	or     %ebx,%eax
c01061e8:	c1 e8 08             	shr    $0x8,%eax
c01061eb:	89 ce                	mov    %ecx,%esi
c01061ed:	09 c6                	or     %eax,%esi
c01061ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061f2:	d1 e8                	shr    %eax
c01061f4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01061f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01061fa:	d1 ea                	shr    %edx
c01061fc:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01061ff:	c1 ea 02             	shr    $0x2,%edx
c0106202:	09 d0                	or     %edx,%eax
c0106204:	89 c1                	mov    %eax,%ecx
c0106206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106209:	d1 e8                	shr    %eax
c010620b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010620e:	89 c2                	mov    %eax,%edx
c0106210:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106213:	d1 e8                	shr    %eax
c0106215:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106218:	c1 e8 02             	shr    $0x2,%eax
c010621b:	09 d0                	or     %edx,%eax
c010621d:	c1 e8 04             	shr    $0x4,%eax
c0106220:	89 cb                	mov    %ecx,%ebx
c0106222:	09 c3                	or     %eax,%ebx
c0106224:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106227:	d1 e8                	shr    %eax
c0106229:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010622c:	89 c2                	mov    %eax,%edx
c010622e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106231:	d1 e8                	shr    %eax
c0106233:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106236:	c1 e8 02             	shr    $0x2,%eax
c0106239:	89 d1                	mov    %edx,%ecx
c010623b:	09 c1                	or     %eax,%ecx
c010623d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106240:	d1 e8                	shr    %eax
c0106242:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106245:	89 c2                	mov    %eax,%edx
c0106247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010624a:	d1 e8                	shr    %eax
c010624c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010624f:	c1 e8 02             	shr    $0x2,%eax
c0106252:	09 d0                	or     %edx,%eax
c0106254:	c1 e8 04             	shr    $0x4,%eax
c0106257:	09 c8                	or     %ecx,%eax
c0106259:	c1 e8 08             	shr    $0x8,%eax
c010625c:	09 d8                	or     %ebx,%eax
c010625e:	c1 e8 10             	shr    $0x10,%eax
c0106261:	09 f0                	or     %esi,%eax
c0106263:	d1 e8                	shr    %eax
c0106265:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106268:	85 c0                	test   %eax,%eax
c010626a:	0f 84 ea 00 00 00    	je     c010635a <buddy_alloc_pages+0x10c5>
c0106270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106273:	d1 e8                	shr    %eax
c0106275:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106278:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010627b:	d1 ea                	shr    %edx
c010627d:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106280:	c1 ea 02             	shr    $0x2,%edx
c0106283:	09 d0                	or     %edx,%eax
c0106285:	89 c1                	mov    %eax,%ecx
c0106287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010628a:	d1 e8                	shr    %eax
c010628c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010628f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106292:	d1 ea                	shr    %edx
c0106294:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106297:	c1 ea 02             	shr    $0x2,%edx
c010629a:	09 d0                	or     %edx,%eax
c010629c:	c1 e8 04             	shr    $0x4,%eax
c010629f:	09 c1                	or     %eax,%ecx
c01062a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062a4:	d1 e8                	shr    %eax
c01062a6:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01062a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01062ac:	d1 ea                	shr    %edx
c01062ae:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01062b1:	c1 ea 02             	shr    $0x2,%edx
c01062b4:	09 d0                	or     %edx,%eax
c01062b6:	89 c3                	mov    %eax,%ebx
c01062b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062bb:	d1 e8                	shr    %eax
c01062bd:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01062c0:	89 c2                	mov    %eax,%edx
c01062c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062c5:	d1 e8                	shr    %eax
c01062c7:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01062ca:	c1 e8 02             	shr    $0x2,%eax
c01062cd:	09 d0                	or     %edx,%eax
c01062cf:	c1 e8 04             	shr    $0x4,%eax
c01062d2:	09 d8                	or     %ebx,%eax
c01062d4:	c1 e8 08             	shr    $0x8,%eax
c01062d7:	89 ce                	mov    %ecx,%esi
c01062d9:	09 c6                	or     %eax,%esi
c01062db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062de:	d1 e8                	shr    %eax
c01062e0:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01062e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01062e6:	d1 ea                	shr    %edx
c01062e8:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01062eb:	c1 ea 02             	shr    $0x2,%edx
c01062ee:	09 d0                	or     %edx,%eax
c01062f0:	89 c1                	mov    %eax,%ecx
c01062f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062f5:	d1 e8                	shr    %eax
c01062f7:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01062fa:	89 c2                	mov    %eax,%edx
c01062fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062ff:	d1 e8                	shr    %eax
c0106301:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106304:	c1 e8 02             	shr    $0x2,%eax
c0106307:	09 d0                	or     %edx,%eax
c0106309:	c1 e8 04             	shr    $0x4,%eax
c010630c:	89 cb                	mov    %ecx,%ebx
c010630e:	09 c3                	or     %eax,%ebx
c0106310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106313:	d1 e8                	shr    %eax
c0106315:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106318:	89 c2                	mov    %eax,%edx
c010631a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010631d:	d1 e8                	shr    %eax
c010631f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106322:	c1 e8 02             	shr    $0x2,%eax
c0106325:	89 d1                	mov    %edx,%ecx
c0106327:	09 c1                	or     %eax,%ecx
c0106329:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010632c:	d1 e8                	shr    %eax
c010632e:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106331:	89 c2                	mov    %eax,%edx
c0106333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106336:	d1 e8                	shr    %eax
c0106338:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010633b:	c1 e8 02             	shr    $0x2,%eax
c010633e:	09 d0                	or     %edx,%eax
c0106340:	c1 e8 04             	shr    $0x4,%eax
c0106343:	09 c8                	or     %ecx,%eax
c0106345:	c1 e8 08             	shr    $0x8,%eax
c0106348:	09 d8                	or     %ebx,%eax
c010634a:	c1 e8 10             	shr    $0x10,%eax
c010634d:	09 f0                	or     %esi,%eax
c010634f:	d1 e8                	shr    %eax
c0106351:	f7 d0                	not    %eax
c0106353:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106356:	89 c6                	mov    %eax,%esi
c0106358:	eb 03                	jmp    c010635d <buddy_alloc_pages+0x10c8>
c010635a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c010635d:	89 f8                	mov    %edi,%eax
c010635f:	ba 00 00 00 00       	mov    $0x0,%edx
c0106364:	f7 f6                	div    %esi
c0106366:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c010636c:	0f af d0             	imul   %eax,%edx
c010636f:	89 d0                	mov    %edx,%eax
c0106371:	c1 e0 02             	shl    $0x2,%eax
c0106374:	01 d0                	add    %edx,%eax
c0106376:	c1 e0 02             	shl    $0x2,%eax
c0106379:	03 85 74 ff ff ff    	add    -0x8c(%ebp),%eax
c010637f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    list_del(&(page->page_link));
c0106382:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106385:	83 c0 0c             	add    $0xc,%eax
c0106388:	89 45 80             	mov    %eax,-0x80(%ebp)
    __list_del(listelm->prev, listelm->next);
c010638b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010638e:	8b 40 04             	mov    0x4(%eax),%eax
c0106391:	8b 55 80             	mov    -0x80(%ebp),%edx
c0106394:	8b 12                	mov    (%edx),%edx
c0106396:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c010639c:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    prev->next = next;
c01063a2:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01063a8:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c01063ae:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01063b1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c01063b7:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c01063bd:	89 10                	mov    %edx,(%eax)
    buddy_segment[block] = 0;
c01063bf:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c01063c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01063c7:	c1 e2 02             	shl    $0x2,%edx
c01063ca:	01 d0                	add    %edx,%eax
c01063cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    nr_free -= length;
c01063d2:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
c01063d7:	2b 45 e0             	sub    -0x20(%ebp),%eax
c01063da:	a3 80 e9 11 c0       	mov    %eax,0xc011e980
    // Update buddy segment
    while (block != BUDDY_ROOT) {
c01063df:	eb 37                	jmp    c0106418 <buddy_alloc_pages+0x1183>
        block = BUDDY_PARENT(block);
c01063e1:	d1 6d e4             	shrl   -0x1c(%ebp)
        buddy_segment[block] = buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)];
c01063e4:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c01063e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01063ec:	c1 e2 02             	shl    $0x2,%edx
c01063ef:	01 d0                	add    %edx,%eax
c01063f1:	8b 15 5c e9 11 c0    	mov    0xc011e95c,%edx
c01063f7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c01063fa:	c1 e1 03             	shl    $0x3,%ecx
c01063fd:	01 ca                	add    %ecx,%edx
c01063ff:	8b 0a                	mov    (%edx),%ecx
c0106401:	8b 15 5c e9 11 c0    	mov    0xc011e95c,%edx
c0106407:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
c010640a:	c1 e3 03             	shl    $0x3,%ebx
c010640d:	83 c3 04             	add    $0x4,%ebx
c0106410:	01 da                	add    %ebx,%edx
c0106412:	8b 12                	mov    (%edx),%edx
c0106414:	09 ca                	or     %ecx,%edx
c0106416:	89 10                	mov    %edx,(%eax)
    while (block != BUDDY_ROOT) {
c0106418:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
c010641c:	75 c3                	jne    c01063e1 <buddy_alloc_pages+0x114c>
    }
    return page;
c010641e:	8b 45 c8             	mov    -0x38(%ebp),%eax
}
c0106421:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0106427:	5b                   	pop    %ebx
c0106428:	5e                   	pop    %esi
c0106429:	5f                   	pop    %edi
c010642a:	5d                   	pop    %ebp
c010642b:	c3                   	ret    

c010642c <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
c010642c:	55                   	push   %ebp
c010642d:	89 e5                	mov    %esp,%ebp
c010642f:	57                   	push   %edi
c0106430:	56                   	push   %esi
c0106431:	53                   	push   %ebx
c0106432:	81 ec ac 00 00 00    	sub    $0xac,%esp
    assert(n > 0);
c0106438:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010643c:	75 24                	jne    c0106462 <buddy_free_pages+0x36>
c010643e:	c7 44 24 0c df ab 10 	movl   $0xc010abdf,0xc(%esp)
c0106445:	c0 
c0106446:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c010644d:	c0 
c010644e:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0106455:	00 
c0106456:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c010645d:	e8 86 9f ff ff       	call   c01003e8 <__panic>
    struct Page *p = base;
c0106462:	8b 45 08             	mov    0x8(%ebp),%eax
c0106465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    size_t length = UINT32_ROUND_UP(n);
c0106468:	8b 45 0c             	mov    0xc(%ebp),%eax
c010646b:	d1 e8                	shr    %eax
c010646d:	0b 45 0c             	or     0xc(%ebp),%eax
c0106470:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106473:	d1 ea                	shr    %edx
c0106475:	0b 55 0c             	or     0xc(%ebp),%edx
c0106478:	c1 ea 02             	shr    $0x2,%edx
c010647b:	09 d0                	or     %edx,%eax
c010647d:	89 c1                	mov    %eax,%ecx
c010647f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106482:	d1 e8                	shr    %eax
c0106484:	0b 45 0c             	or     0xc(%ebp),%eax
c0106487:	8b 55 0c             	mov    0xc(%ebp),%edx
c010648a:	d1 ea                	shr    %edx
c010648c:	0b 55 0c             	or     0xc(%ebp),%edx
c010648f:	c1 ea 02             	shr    $0x2,%edx
c0106492:	09 d0                	or     %edx,%eax
c0106494:	c1 e8 04             	shr    $0x4,%eax
c0106497:	09 c1                	or     %eax,%ecx
c0106499:	8b 45 0c             	mov    0xc(%ebp),%eax
c010649c:	d1 e8                	shr    %eax
c010649e:	0b 45 0c             	or     0xc(%ebp),%eax
c01064a1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01064a4:	d1 ea                	shr    %edx
c01064a6:	0b 55 0c             	or     0xc(%ebp),%edx
c01064a9:	c1 ea 02             	shr    $0x2,%edx
c01064ac:	09 d0                	or     %edx,%eax
c01064ae:	89 c3                	mov    %eax,%ebx
c01064b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064b3:	d1 e8                	shr    %eax
c01064b5:	0b 45 0c             	or     0xc(%ebp),%eax
c01064b8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01064bb:	d1 ea                	shr    %edx
c01064bd:	0b 55 0c             	or     0xc(%ebp),%edx
c01064c0:	c1 ea 02             	shr    $0x2,%edx
c01064c3:	09 d0                	or     %edx,%eax
c01064c5:	c1 e8 04             	shr    $0x4,%eax
c01064c8:	09 d8                	or     %ebx,%eax
c01064ca:	c1 e8 08             	shr    $0x8,%eax
c01064cd:	09 c1                	or     %eax,%ecx
c01064cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064d2:	d1 e8                	shr    %eax
c01064d4:	0b 45 0c             	or     0xc(%ebp),%eax
c01064d7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01064da:	d1 ea                	shr    %edx
c01064dc:	0b 55 0c             	or     0xc(%ebp),%edx
c01064df:	c1 ea 02             	shr    $0x2,%edx
c01064e2:	09 d0                	or     %edx,%eax
c01064e4:	89 c3                	mov    %eax,%ebx
c01064e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064e9:	d1 e8                	shr    %eax
c01064eb:	0b 45 0c             	or     0xc(%ebp),%eax
c01064ee:	8b 55 0c             	mov    0xc(%ebp),%edx
c01064f1:	d1 ea                	shr    %edx
c01064f3:	0b 55 0c             	or     0xc(%ebp),%edx
c01064f6:	c1 ea 02             	shr    $0x2,%edx
c01064f9:	09 d0                	or     %edx,%eax
c01064fb:	c1 e8 04             	shr    $0x4,%eax
c01064fe:	09 c3                	or     %eax,%ebx
c0106500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106503:	d1 e8                	shr    %eax
c0106505:	0b 45 0c             	or     0xc(%ebp),%eax
c0106508:	8b 55 0c             	mov    0xc(%ebp),%edx
c010650b:	d1 ea                	shr    %edx
c010650d:	0b 55 0c             	or     0xc(%ebp),%edx
c0106510:	c1 ea 02             	shr    $0x2,%edx
c0106513:	09 d0                	or     %edx,%eax
c0106515:	89 c6                	mov    %eax,%esi
c0106517:	8b 45 0c             	mov    0xc(%ebp),%eax
c010651a:	d1 e8                	shr    %eax
c010651c:	0b 45 0c             	or     0xc(%ebp),%eax
c010651f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106522:	d1 ea                	shr    %edx
c0106524:	0b 55 0c             	or     0xc(%ebp),%edx
c0106527:	c1 ea 02             	shr    $0x2,%edx
c010652a:	09 d0                	or     %edx,%eax
c010652c:	c1 e8 04             	shr    $0x4,%eax
c010652f:	09 f0                	or     %esi,%eax
c0106531:	c1 e8 08             	shr    $0x8,%eax
c0106534:	09 d8                	or     %ebx,%eax
c0106536:	c1 e8 10             	shr    $0x10,%eax
c0106539:	09 c8                	or     %ecx,%eax
c010653b:	d1 e8                	shr    %eax
c010653d:	23 45 0c             	and    0xc(%ebp),%eax
c0106540:	85 c0                	test   %eax,%eax
c0106542:	0f 84 de 00 00 00    	je     c0106626 <buddy_free_pages+0x1fa>
c0106548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010654b:	d1 e8                	shr    %eax
c010654d:	0b 45 0c             	or     0xc(%ebp),%eax
c0106550:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106553:	d1 ea                	shr    %edx
c0106555:	0b 55 0c             	or     0xc(%ebp),%edx
c0106558:	c1 ea 02             	shr    $0x2,%edx
c010655b:	09 d0                	or     %edx,%eax
c010655d:	89 c1                	mov    %eax,%ecx
c010655f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106562:	d1 e8                	shr    %eax
c0106564:	0b 45 0c             	or     0xc(%ebp),%eax
c0106567:	8b 55 0c             	mov    0xc(%ebp),%edx
c010656a:	d1 ea                	shr    %edx
c010656c:	0b 55 0c             	or     0xc(%ebp),%edx
c010656f:	c1 ea 02             	shr    $0x2,%edx
c0106572:	09 d0                	or     %edx,%eax
c0106574:	c1 e8 04             	shr    $0x4,%eax
c0106577:	09 c1                	or     %eax,%ecx
c0106579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010657c:	d1 e8                	shr    %eax
c010657e:	0b 45 0c             	or     0xc(%ebp),%eax
c0106581:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106584:	d1 ea                	shr    %edx
c0106586:	0b 55 0c             	or     0xc(%ebp),%edx
c0106589:	c1 ea 02             	shr    $0x2,%edx
c010658c:	09 d0                	or     %edx,%eax
c010658e:	89 c3                	mov    %eax,%ebx
c0106590:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106593:	d1 e8                	shr    %eax
c0106595:	0b 45 0c             	or     0xc(%ebp),%eax
c0106598:	8b 55 0c             	mov    0xc(%ebp),%edx
c010659b:	d1 ea                	shr    %edx
c010659d:	0b 55 0c             	or     0xc(%ebp),%edx
c01065a0:	c1 ea 02             	shr    $0x2,%edx
c01065a3:	09 d0                	or     %edx,%eax
c01065a5:	c1 e8 04             	shr    $0x4,%eax
c01065a8:	09 d8                	or     %ebx,%eax
c01065aa:	c1 e8 08             	shr    $0x8,%eax
c01065ad:	09 c1                	or     %eax,%ecx
c01065af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01065b2:	d1 e8                	shr    %eax
c01065b4:	0b 45 0c             	or     0xc(%ebp),%eax
c01065b7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01065ba:	d1 ea                	shr    %edx
c01065bc:	0b 55 0c             	or     0xc(%ebp),%edx
c01065bf:	c1 ea 02             	shr    $0x2,%edx
c01065c2:	09 d0                	or     %edx,%eax
c01065c4:	89 c3                	mov    %eax,%ebx
c01065c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01065c9:	d1 e8                	shr    %eax
c01065cb:	0b 45 0c             	or     0xc(%ebp),%eax
c01065ce:	8b 55 0c             	mov    0xc(%ebp),%edx
c01065d1:	d1 ea                	shr    %edx
c01065d3:	0b 55 0c             	or     0xc(%ebp),%edx
c01065d6:	c1 ea 02             	shr    $0x2,%edx
c01065d9:	09 d0                	or     %edx,%eax
c01065db:	c1 e8 04             	shr    $0x4,%eax
c01065de:	09 c3                	or     %eax,%ebx
c01065e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01065e3:	d1 e8                	shr    %eax
c01065e5:	0b 45 0c             	or     0xc(%ebp),%eax
c01065e8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01065eb:	d1 ea                	shr    %edx
c01065ed:	0b 55 0c             	or     0xc(%ebp),%edx
c01065f0:	c1 ea 02             	shr    $0x2,%edx
c01065f3:	09 d0                	or     %edx,%eax
c01065f5:	89 c6                	mov    %eax,%esi
c01065f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01065fa:	d1 e8                	shr    %eax
c01065fc:	0b 45 0c             	or     0xc(%ebp),%eax
c01065ff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106602:	d1 ea                	shr    %edx
c0106604:	0b 55 0c             	or     0xc(%ebp),%edx
c0106607:	c1 ea 02             	shr    $0x2,%edx
c010660a:	09 d0                	or     %edx,%eax
c010660c:	c1 e8 04             	shr    $0x4,%eax
c010660f:	09 f0                	or     %esi,%eax
c0106611:	c1 e8 08             	shr    $0x8,%eax
c0106614:	09 d8                	or     %ebx,%eax
c0106616:	c1 e8 10             	shr    $0x10,%eax
c0106619:	09 c8                	or     %ecx,%eax
c010661b:	d1 e8                	shr    %eax
c010661d:	f7 d0                	not    %eax
c010661f:	23 45 0c             	and    0xc(%ebp),%eax
c0106622:	01 c0                	add    %eax,%eax
c0106624:	eb 03                	jmp    c0106629 <buddy_free_pages+0x1fd>
c0106626:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106629:	89 45 dc             	mov    %eax,-0x24(%ebp)
    // Find buddy id 
    size_t begin = (base-buddy_alloc);
c010662c:	8b 55 08             	mov    0x8(%ebp),%edx
c010662f:	a1 64 e9 11 c0       	mov    0xc011e964,%eax
c0106634:	29 c2                	sub    %eax,%edx
c0106636:	89 d0                	mov    %edx,%eax
c0106638:	c1 f8 02             	sar    $0x2,%eax
c010663b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
c0106641:	89 45 d8             	mov    %eax,-0x28(%ebp)
    size_t end = begin + length;
c0106644:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106647:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010664a:	01 d0                	add    %edx,%eax
c010664c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    size_t block = BUDDY_BLOCK(begin, end);
c010664f:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c0106654:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106657:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010665a:	29 d1                	sub    %edx,%ecx
c010665c:	89 cf                	mov    %ecx,%edi
c010665e:	ba 00 00 00 00       	mov    $0x0,%edx
c0106663:	f7 f7                	div    %edi
c0106665:	89 c1                	mov    %eax,%ecx
c0106667:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010666a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010666d:	89 d7                	mov    %edx,%edi
c010666f:	29 c7                	sub    %eax,%edi
c0106671:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106674:	ba 00 00 00 00       	mov    $0x0,%edx
c0106679:	f7 f7                	div    %edi
c010667b:	01 c8                	add    %ecx,%eax
c010667d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // Release block
    for (; p != base + n; p ++) {
c0106680:	eb 71                	jmp    c01066f3 <buddy_free_pages+0x2c7>
        assert(!PageReserved(p));
c0106682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106685:	83 c0 04             	add    $0x4,%eax
c0106688:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c010668f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106692:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0106695:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0106698:	0f a3 10             	bt     %edx,(%eax)
c010669b:	19 c0                	sbb    %eax,%eax
c010669d:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01066a0:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01066a4:	0f 95 c0             	setne  %al
c01066a7:	0f b6 c0             	movzbl %al,%eax
c01066aa:	85 c0                	test   %eax,%eax
c01066ac:	74 24                	je     c01066d2 <buddy_free_pages+0x2a6>
c01066ae:	c7 44 24 0c f7 ab 10 	movl   $0xc010abf7,0xc(%esp)
c01066b5:	c0 
c01066b6:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c01066bd:	c0 
c01066be:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c01066c5:	00 
c01066c6:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c01066cd:	e8 16 9d ff ff       	call   c01003e8 <__panic>
        p->flags = 0;
c01066d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01066d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01066dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01066e3:	00 
c01066e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01066e7:	89 04 24             	mov    %eax,(%esp)
c01066ea:	e8 4e dd ff ff       	call   c010443d <set_page_ref>
    for (; p != base + n; p ++) {
c01066ef:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
c01066f3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01066f6:	89 d0                	mov    %edx,%eax
c01066f8:	c1 e0 02             	shl    $0x2,%eax
c01066fb:	01 d0                	add    %edx,%eax
c01066fd:	c1 e0 02             	shl    $0x2,%eax
c0106700:	89 c2                	mov    %eax,%edx
c0106702:	8b 45 08             	mov    0x8(%ebp),%eax
c0106705:	01 d0                	add    %edx,%eax
c0106707:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
c010670a:	0f 85 72 ff ff ff    	jne    c0106682 <buddy_free_pages+0x256>
    }
    base->property = length;
c0106710:	8b 45 08             	mov    0x8(%ebp),%eax
c0106713:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106716:	89 50 08             	mov    %edx,0x8(%eax)
    list_add(&(free_list), &(base->page_link));
c0106719:	8b 45 08             	mov    0x8(%ebp),%eax
c010671c:	83 c0 0c             	add    $0xc,%eax
c010671f:	c7 45 b4 78 e9 11 c0 	movl   $0xc011e978,-0x4c(%ebp)
c0106726:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0106729:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010672c:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010672f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106732:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_add(elm, listelm, listelm->next);
c0106735:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106738:	8b 40 04             	mov    0x4(%eax),%eax
c010673b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010673e:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0106741:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0106744:	89 55 a0             	mov    %edx,-0x60(%ebp)
c0106747:	89 45 9c             	mov    %eax,-0x64(%ebp)
    prev->next = next->prev = elm;
c010674a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010674d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0106750:	89 10                	mov    %edx,(%eax)
c0106752:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0106755:	8b 10                	mov    (%eax),%edx
c0106757:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010675a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010675d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106760:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106763:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106766:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106769:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010676c:	89 10                	mov    %edx,(%eax)
    nr_free += length;
c010676e:	8b 15 80 e9 11 c0    	mov    0xc011e980,%edx
c0106774:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106777:	01 d0                	add    %edx,%eax
c0106779:	a3 80 e9 11 c0       	mov    %eax,0xc011e980
    buddy_segment[block] = length;
c010677e:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0106783:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106786:	c1 e2 02             	shl    $0x2,%edx
c0106789:	01 c2                	add    %eax,%edx
c010678b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010678e:	89 02                	mov    %eax,(%edx)
    // Upadte & merge
    while (block != BUDDY_ROOT) {
c0106790:	e9 20 0b 00 00       	jmp    c01072b5 <buddy_free_pages+0xe89>
        block = BUDDY_PARENT(block);
c0106795:	d1 6d e0             	shrl   -0x20(%ebp)
        size_t left = BUDDY_LEFT(block);
c0106798:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010679b:	01 c0                	add    %eax,%eax
c010679d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        size_t right = BUDDY_RIGHT(block);
c01067a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067a3:	01 c0                	add    %eax,%eax
c01067a5:	83 c0 01             	add    $0x1,%eax
c01067a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right)) {  // Merge
c01067ab:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c01067b0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01067b3:	c1 e2 02             	shl    $0x2,%edx
c01067b6:	01 d0                	add    %edx,%eax
c01067b8:	8b 00                	mov    (%eax),%eax
c01067ba:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
c01067c0:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c01067c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01067c9:	d1 e8                	shr    %eax
c01067cb:	0b 45 d0             	or     -0x30(%ebp),%eax
c01067ce:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01067d1:	d1 ea                	shr    %edx
c01067d3:	0b 55 d0             	or     -0x30(%ebp),%edx
c01067d6:	c1 ea 02             	shr    $0x2,%edx
c01067d9:	09 d0                	or     %edx,%eax
c01067db:	89 c1                	mov    %eax,%ecx
c01067dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01067e0:	d1 e8                	shr    %eax
c01067e2:	0b 45 d0             	or     -0x30(%ebp),%eax
c01067e5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01067e8:	d1 ea                	shr    %edx
c01067ea:	0b 55 d0             	or     -0x30(%ebp),%edx
c01067ed:	c1 ea 02             	shr    $0x2,%edx
c01067f0:	09 d0                	or     %edx,%eax
c01067f2:	c1 e8 04             	shr    $0x4,%eax
c01067f5:	09 c1                	or     %eax,%ecx
c01067f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01067fa:	d1 e8                	shr    %eax
c01067fc:	0b 45 d0             	or     -0x30(%ebp),%eax
c01067ff:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106802:	d1 ea                	shr    %edx
c0106804:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106807:	c1 ea 02             	shr    $0x2,%edx
c010680a:	09 d0                	or     %edx,%eax
c010680c:	89 c3                	mov    %eax,%ebx
c010680e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106811:	d1 e8                	shr    %eax
c0106813:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106816:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106819:	d1 ea                	shr    %edx
c010681b:	0b 55 d0             	or     -0x30(%ebp),%edx
c010681e:	c1 ea 02             	shr    $0x2,%edx
c0106821:	09 d0                	or     %edx,%eax
c0106823:	c1 e8 04             	shr    $0x4,%eax
c0106826:	09 d8                	or     %ebx,%eax
c0106828:	c1 e8 08             	shr    $0x8,%eax
c010682b:	89 cb                	mov    %ecx,%ebx
c010682d:	09 c3                	or     %eax,%ebx
c010682f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106832:	d1 e8                	shr    %eax
c0106834:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106837:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010683a:	d1 ea                	shr    %edx
c010683c:	0b 55 d0             	or     -0x30(%ebp),%edx
c010683f:	c1 ea 02             	shr    $0x2,%edx
c0106842:	09 d0                	or     %edx,%eax
c0106844:	89 c1                	mov    %eax,%ecx
c0106846:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106849:	d1 e8                	shr    %eax
c010684b:	0b 45 d0             	or     -0x30(%ebp),%eax
c010684e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106851:	d1 ea                	shr    %edx
c0106853:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106856:	c1 ea 02             	shr    $0x2,%edx
c0106859:	09 d0                	or     %edx,%eax
c010685b:	c1 e8 04             	shr    $0x4,%eax
c010685e:	09 c1                	or     %eax,%ecx
c0106860:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106863:	d1 e8                	shr    %eax
c0106865:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106868:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010686b:	d1 ea                	shr    %edx
c010686d:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106870:	c1 ea 02             	shr    $0x2,%edx
c0106873:	09 d0                	or     %edx,%eax
c0106875:	89 c6                	mov    %eax,%esi
c0106877:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010687a:	d1 e8                	shr    %eax
c010687c:	0b 45 d0             	or     -0x30(%ebp),%eax
c010687f:	89 c2                	mov    %eax,%edx
c0106881:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106884:	d1 e8                	shr    %eax
c0106886:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106889:	c1 e8 02             	shr    $0x2,%eax
c010688c:	09 d0                	or     %edx,%eax
c010688e:	c1 e8 04             	shr    $0x4,%eax
c0106891:	09 f0                	or     %esi,%eax
c0106893:	c1 e8 08             	shr    $0x8,%eax
c0106896:	09 c8                	or     %ecx,%eax
c0106898:	c1 e8 10             	shr    $0x10,%eax
c010689b:	09 d8                	or     %ebx,%eax
c010689d:	d1 e8                	shr    %eax
c010689f:	23 45 d0             	and    -0x30(%ebp),%eax
c01068a2:	85 c0                	test   %eax,%eax
c01068a4:	0f 84 e2 00 00 00    	je     c010698c <buddy_free_pages+0x560>
c01068aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068ad:	d1 e8                	shr    %eax
c01068af:	0b 45 d0             	or     -0x30(%ebp),%eax
c01068b2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01068b5:	d1 ea                	shr    %edx
c01068b7:	0b 55 d0             	or     -0x30(%ebp),%edx
c01068ba:	c1 ea 02             	shr    $0x2,%edx
c01068bd:	09 d0                	or     %edx,%eax
c01068bf:	89 c1                	mov    %eax,%ecx
c01068c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068c4:	d1 e8                	shr    %eax
c01068c6:	0b 45 d0             	or     -0x30(%ebp),%eax
c01068c9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01068cc:	d1 ea                	shr    %edx
c01068ce:	0b 55 d0             	or     -0x30(%ebp),%edx
c01068d1:	c1 ea 02             	shr    $0x2,%edx
c01068d4:	09 d0                	or     %edx,%eax
c01068d6:	c1 e8 04             	shr    $0x4,%eax
c01068d9:	09 c1                	or     %eax,%ecx
c01068db:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068de:	d1 e8                	shr    %eax
c01068e0:	0b 45 d0             	or     -0x30(%ebp),%eax
c01068e3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01068e6:	d1 ea                	shr    %edx
c01068e8:	0b 55 d0             	or     -0x30(%ebp),%edx
c01068eb:	c1 ea 02             	shr    $0x2,%edx
c01068ee:	09 d0                	or     %edx,%eax
c01068f0:	89 c3                	mov    %eax,%ebx
c01068f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068f5:	d1 e8                	shr    %eax
c01068f7:	0b 45 d0             	or     -0x30(%ebp),%eax
c01068fa:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01068fd:	d1 ea                	shr    %edx
c01068ff:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106902:	c1 ea 02             	shr    $0x2,%edx
c0106905:	09 d0                	or     %edx,%eax
c0106907:	c1 e8 04             	shr    $0x4,%eax
c010690a:	09 d8                	or     %ebx,%eax
c010690c:	c1 e8 08             	shr    $0x8,%eax
c010690f:	89 cb                	mov    %ecx,%ebx
c0106911:	09 c3                	or     %eax,%ebx
c0106913:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106916:	d1 e8                	shr    %eax
c0106918:	0b 45 d0             	or     -0x30(%ebp),%eax
c010691b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010691e:	d1 ea                	shr    %edx
c0106920:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106923:	c1 ea 02             	shr    $0x2,%edx
c0106926:	09 d0                	or     %edx,%eax
c0106928:	89 c1                	mov    %eax,%ecx
c010692a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010692d:	d1 e8                	shr    %eax
c010692f:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106932:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106935:	d1 ea                	shr    %edx
c0106937:	0b 55 d0             	or     -0x30(%ebp),%edx
c010693a:	c1 ea 02             	shr    $0x2,%edx
c010693d:	09 d0                	or     %edx,%eax
c010693f:	c1 e8 04             	shr    $0x4,%eax
c0106942:	09 c1                	or     %eax,%ecx
c0106944:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106947:	d1 e8                	shr    %eax
c0106949:	0b 45 d0             	or     -0x30(%ebp),%eax
c010694c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010694f:	d1 ea                	shr    %edx
c0106951:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106954:	c1 ea 02             	shr    $0x2,%edx
c0106957:	09 d0                	or     %edx,%eax
c0106959:	89 c6                	mov    %eax,%esi
c010695b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010695e:	d1 e8                	shr    %eax
c0106960:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106963:	89 c2                	mov    %eax,%edx
c0106965:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106968:	d1 e8                	shr    %eax
c010696a:	0b 45 d0             	or     -0x30(%ebp),%eax
c010696d:	c1 e8 02             	shr    $0x2,%eax
c0106970:	09 d0                	or     %edx,%eax
c0106972:	c1 e8 04             	shr    $0x4,%eax
c0106975:	09 f0                	or     %esi,%eax
c0106977:	c1 e8 08             	shr    $0x8,%eax
c010697a:	09 c8                	or     %ecx,%eax
c010697c:	c1 e8 10             	shr    $0x10,%eax
c010697f:	09 d8                	or     %ebx,%eax
c0106981:	d1 e8                	shr    %eax
c0106983:	f7 d0                	not    %eax
c0106985:	23 45 d0             	and    -0x30(%ebp),%eax
c0106988:	89 c6                	mov    %eax,%esi
c010698a:	eb 03                	jmp    c010698f <buddy_free_pages+0x563>
c010698c:	8b 75 d0             	mov    -0x30(%ebp),%esi
c010698f:	89 f8                	mov    %edi,%eax
c0106991:	ba 00 00 00 00       	mov    $0x0,%edx
c0106996:	f7 f6                	div    %esi
c0106998:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%ebp)
c010699e:	0f 85 dd 08 00 00    	jne    c0107281 <buddy_free_pages+0xe55>
c01069a4:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c01069a9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01069ac:	c1 e2 02             	shl    $0x2,%edx
c01069af:	01 d0                	add    %edx,%eax
c01069b1:	8b 00                	mov    (%eax),%eax
c01069b3:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
c01069b9:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c01069bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01069c2:	d1 e8                	shr    %eax
c01069c4:	0b 45 cc             	or     -0x34(%ebp),%eax
c01069c7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01069ca:	d1 ea                	shr    %edx
c01069cc:	0b 55 cc             	or     -0x34(%ebp),%edx
c01069cf:	c1 ea 02             	shr    $0x2,%edx
c01069d2:	09 d0                	or     %edx,%eax
c01069d4:	89 c1                	mov    %eax,%ecx
c01069d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01069d9:	d1 e8                	shr    %eax
c01069db:	0b 45 cc             	or     -0x34(%ebp),%eax
c01069de:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01069e1:	d1 ea                	shr    %edx
c01069e3:	0b 55 cc             	or     -0x34(%ebp),%edx
c01069e6:	c1 ea 02             	shr    $0x2,%edx
c01069e9:	09 d0                	or     %edx,%eax
c01069eb:	c1 e8 04             	shr    $0x4,%eax
c01069ee:	09 c1                	or     %eax,%ecx
c01069f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01069f3:	d1 e8                	shr    %eax
c01069f5:	0b 45 cc             	or     -0x34(%ebp),%eax
c01069f8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01069fb:	d1 ea                	shr    %edx
c01069fd:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106a00:	c1 ea 02             	shr    $0x2,%edx
c0106a03:	09 d0                	or     %edx,%eax
c0106a05:	89 c3                	mov    %eax,%ebx
c0106a07:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106a0a:	d1 e8                	shr    %eax
c0106a0c:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106a0f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106a12:	d1 ea                	shr    %edx
c0106a14:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106a17:	c1 ea 02             	shr    $0x2,%edx
c0106a1a:	09 d0                	or     %edx,%eax
c0106a1c:	c1 e8 04             	shr    $0x4,%eax
c0106a1f:	09 d8                	or     %ebx,%eax
c0106a21:	c1 e8 08             	shr    $0x8,%eax
c0106a24:	89 cb                	mov    %ecx,%ebx
c0106a26:	09 c3                	or     %eax,%ebx
c0106a28:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106a2b:	d1 e8                	shr    %eax
c0106a2d:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106a30:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106a33:	d1 ea                	shr    %edx
c0106a35:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106a38:	c1 ea 02             	shr    $0x2,%edx
c0106a3b:	09 d0                	or     %edx,%eax
c0106a3d:	89 c1                	mov    %eax,%ecx
c0106a3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106a42:	d1 e8                	shr    %eax
c0106a44:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106a47:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106a4a:	d1 ea                	shr    %edx
c0106a4c:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106a4f:	c1 ea 02             	shr    $0x2,%edx
c0106a52:	09 d0                	or     %edx,%eax
c0106a54:	c1 e8 04             	shr    $0x4,%eax
c0106a57:	09 c1                	or     %eax,%ecx
c0106a59:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106a5c:	d1 e8                	shr    %eax
c0106a5e:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106a61:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106a64:	d1 ea                	shr    %edx
c0106a66:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106a69:	c1 ea 02             	shr    $0x2,%edx
c0106a6c:	09 d0                	or     %edx,%eax
c0106a6e:	89 c6                	mov    %eax,%esi
c0106a70:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106a73:	d1 e8                	shr    %eax
c0106a75:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106a78:	89 c2                	mov    %eax,%edx
c0106a7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106a7d:	d1 e8                	shr    %eax
c0106a7f:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106a82:	c1 e8 02             	shr    $0x2,%eax
c0106a85:	09 d0                	or     %edx,%eax
c0106a87:	c1 e8 04             	shr    $0x4,%eax
c0106a8a:	09 f0                	or     %esi,%eax
c0106a8c:	c1 e8 08             	shr    $0x8,%eax
c0106a8f:	09 c8                	or     %ecx,%eax
c0106a91:	c1 e8 10             	shr    $0x10,%eax
c0106a94:	09 d8                	or     %ebx,%eax
c0106a96:	d1 e8                	shr    %eax
c0106a98:	23 45 cc             	and    -0x34(%ebp),%eax
c0106a9b:	85 c0                	test   %eax,%eax
c0106a9d:	0f 84 e2 00 00 00    	je     c0106b85 <buddy_free_pages+0x759>
c0106aa3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106aa6:	d1 e8                	shr    %eax
c0106aa8:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106aab:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106aae:	d1 ea                	shr    %edx
c0106ab0:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106ab3:	c1 ea 02             	shr    $0x2,%edx
c0106ab6:	09 d0                	or     %edx,%eax
c0106ab8:	89 c1                	mov    %eax,%ecx
c0106aba:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106abd:	d1 e8                	shr    %eax
c0106abf:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106ac2:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106ac5:	d1 ea                	shr    %edx
c0106ac7:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106aca:	c1 ea 02             	shr    $0x2,%edx
c0106acd:	09 d0                	or     %edx,%eax
c0106acf:	c1 e8 04             	shr    $0x4,%eax
c0106ad2:	09 c1                	or     %eax,%ecx
c0106ad4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106ad7:	d1 e8                	shr    %eax
c0106ad9:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106adc:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106adf:	d1 ea                	shr    %edx
c0106ae1:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106ae4:	c1 ea 02             	shr    $0x2,%edx
c0106ae7:	09 d0                	or     %edx,%eax
c0106ae9:	89 c3                	mov    %eax,%ebx
c0106aeb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106aee:	d1 e8                	shr    %eax
c0106af0:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106af3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106af6:	d1 ea                	shr    %edx
c0106af8:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106afb:	c1 ea 02             	shr    $0x2,%edx
c0106afe:	09 d0                	or     %edx,%eax
c0106b00:	c1 e8 04             	shr    $0x4,%eax
c0106b03:	09 d8                	or     %ebx,%eax
c0106b05:	c1 e8 08             	shr    $0x8,%eax
c0106b08:	89 cb                	mov    %ecx,%ebx
c0106b0a:	09 c3                	or     %eax,%ebx
c0106b0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106b0f:	d1 e8                	shr    %eax
c0106b11:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106b14:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106b17:	d1 ea                	shr    %edx
c0106b19:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106b1c:	c1 ea 02             	shr    $0x2,%edx
c0106b1f:	09 d0                	or     %edx,%eax
c0106b21:	89 c1                	mov    %eax,%ecx
c0106b23:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106b26:	d1 e8                	shr    %eax
c0106b28:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106b2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106b2e:	d1 ea                	shr    %edx
c0106b30:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106b33:	c1 ea 02             	shr    $0x2,%edx
c0106b36:	09 d0                	or     %edx,%eax
c0106b38:	c1 e8 04             	shr    $0x4,%eax
c0106b3b:	09 c1                	or     %eax,%ecx
c0106b3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106b40:	d1 e8                	shr    %eax
c0106b42:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106b45:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106b48:	d1 ea                	shr    %edx
c0106b4a:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106b4d:	c1 ea 02             	shr    $0x2,%edx
c0106b50:	09 d0                	or     %edx,%eax
c0106b52:	89 c6                	mov    %eax,%esi
c0106b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106b57:	d1 e8                	shr    %eax
c0106b59:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106b5c:	89 c2                	mov    %eax,%edx
c0106b5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106b61:	d1 e8                	shr    %eax
c0106b63:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106b66:	c1 e8 02             	shr    $0x2,%eax
c0106b69:	09 d0                	or     %edx,%eax
c0106b6b:	c1 e8 04             	shr    $0x4,%eax
c0106b6e:	09 f0                	or     %esi,%eax
c0106b70:	c1 e8 08             	shr    $0x8,%eax
c0106b73:	09 c8                	or     %ecx,%eax
c0106b75:	c1 e8 10             	shr    $0x10,%eax
c0106b78:	09 d8                	or     %ebx,%eax
c0106b7a:	d1 e8                	shr    %eax
c0106b7c:	f7 d0                	not    %eax
c0106b7e:	23 45 cc             	and    -0x34(%ebp),%eax
c0106b81:	89 c6                	mov    %eax,%esi
c0106b83:	eb 03                	jmp    c0106b88 <buddy_free_pages+0x75c>
c0106b85:	8b 75 cc             	mov    -0x34(%ebp),%esi
c0106b88:	89 f8                	mov    %edi,%eax
c0106b8a:	ba 00 00 00 00       	mov    $0x0,%edx
c0106b8f:	f7 f6                	div    %esi
c0106b91:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%ebp)
c0106b97:	0f 85 e4 06 00 00    	jne    c0107281 <buddy_free_pages+0xe55>
            size_t lbegin = BUDDY_BEGIN(left);
c0106b9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106ba0:	d1 e8                	shr    %eax
c0106ba2:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106ba5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106ba8:	d1 ea                	shr    %edx
c0106baa:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106bad:	c1 ea 02             	shr    $0x2,%edx
c0106bb0:	09 d0                	or     %edx,%eax
c0106bb2:	89 c1                	mov    %eax,%ecx
c0106bb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106bb7:	d1 e8                	shr    %eax
c0106bb9:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106bbc:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106bbf:	d1 ea                	shr    %edx
c0106bc1:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106bc4:	c1 ea 02             	shr    $0x2,%edx
c0106bc7:	09 d0                	or     %edx,%eax
c0106bc9:	c1 e8 04             	shr    $0x4,%eax
c0106bcc:	09 c1                	or     %eax,%ecx
c0106bce:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106bd1:	d1 e8                	shr    %eax
c0106bd3:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106bd6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106bd9:	d1 ea                	shr    %edx
c0106bdb:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106bde:	c1 ea 02             	shr    $0x2,%edx
c0106be1:	09 d0                	or     %edx,%eax
c0106be3:	89 c3                	mov    %eax,%ebx
c0106be5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106be8:	d1 e8                	shr    %eax
c0106bea:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106bed:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106bf0:	d1 ea                	shr    %edx
c0106bf2:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106bf5:	c1 ea 02             	shr    $0x2,%edx
c0106bf8:	09 d0                	or     %edx,%eax
c0106bfa:	c1 e8 04             	shr    $0x4,%eax
c0106bfd:	09 d8                	or     %ebx,%eax
c0106bff:	c1 e8 08             	shr    $0x8,%eax
c0106c02:	09 c1                	or     %eax,%ecx
c0106c04:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106c07:	d1 e8                	shr    %eax
c0106c09:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106c0c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106c0f:	d1 ea                	shr    %edx
c0106c11:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106c14:	c1 ea 02             	shr    $0x2,%edx
c0106c17:	09 d0                	or     %edx,%eax
c0106c19:	89 c3                	mov    %eax,%ebx
c0106c1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106c1e:	d1 e8                	shr    %eax
c0106c20:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106c23:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106c26:	d1 ea                	shr    %edx
c0106c28:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106c2b:	c1 ea 02             	shr    $0x2,%edx
c0106c2e:	09 d0                	or     %edx,%eax
c0106c30:	c1 e8 04             	shr    $0x4,%eax
c0106c33:	09 c3                	or     %eax,%ebx
c0106c35:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106c38:	d1 e8                	shr    %eax
c0106c3a:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106c3d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106c40:	d1 ea                	shr    %edx
c0106c42:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106c45:	c1 ea 02             	shr    $0x2,%edx
c0106c48:	09 d0                	or     %edx,%eax
c0106c4a:	89 c6                	mov    %eax,%esi
c0106c4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106c4f:	d1 e8                	shr    %eax
c0106c51:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106c54:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106c57:	d1 ea                	shr    %edx
c0106c59:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106c5c:	c1 ea 02             	shr    $0x2,%edx
c0106c5f:	09 d0                	or     %edx,%eax
c0106c61:	c1 e8 04             	shr    $0x4,%eax
c0106c64:	09 f0                	or     %esi,%eax
c0106c66:	c1 e8 08             	shr    $0x8,%eax
c0106c69:	09 d8                	or     %ebx,%eax
c0106c6b:	c1 e8 10             	shr    $0x10,%eax
c0106c6e:	09 c8                	or     %ecx,%eax
c0106c70:	d1 e8                	shr    %eax
c0106c72:	23 45 d0             	and    -0x30(%ebp),%eax
c0106c75:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
c0106c7b:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c0106c81:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106c84:	d1 e8                	shr    %eax
c0106c86:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106c89:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106c8c:	d1 ea                	shr    %edx
c0106c8e:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106c91:	c1 ea 02             	shr    $0x2,%edx
c0106c94:	09 d0                	or     %edx,%eax
c0106c96:	89 c1                	mov    %eax,%ecx
c0106c98:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106c9b:	d1 e8                	shr    %eax
c0106c9d:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106ca0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106ca3:	d1 ea                	shr    %edx
c0106ca5:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106ca8:	c1 ea 02             	shr    $0x2,%edx
c0106cab:	09 d0                	or     %edx,%eax
c0106cad:	c1 e8 04             	shr    $0x4,%eax
c0106cb0:	09 c1                	or     %eax,%ecx
c0106cb2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106cb5:	d1 e8                	shr    %eax
c0106cb7:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106cba:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106cbd:	d1 ea                	shr    %edx
c0106cbf:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106cc2:	c1 ea 02             	shr    $0x2,%edx
c0106cc5:	09 d0                	or     %edx,%eax
c0106cc7:	89 c3                	mov    %eax,%ebx
c0106cc9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106ccc:	d1 e8                	shr    %eax
c0106cce:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106cd1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106cd4:	d1 ea                	shr    %edx
c0106cd6:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106cd9:	c1 ea 02             	shr    $0x2,%edx
c0106cdc:	09 d0                	or     %edx,%eax
c0106cde:	c1 e8 04             	shr    $0x4,%eax
c0106ce1:	09 d8                	or     %ebx,%eax
c0106ce3:	c1 e8 08             	shr    $0x8,%eax
c0106ce6:	89 cb                	mov    %ecx,%ebx
c0106ce8:	09 c3                	or     %eax,%ebx
c0106cea:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106ced:	d1 e8                	shr    %eax
c0106cef:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106cf2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106cf5:	d1 ea                	shr    %edx
c0106cf7:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106cfa:	c1 ea 02             	shr    $0x2,%edx
c0106cfd:	09 d0                	or     %edx,%eax
c0106cff:	89 c1                	mov    %eax,%ecx
c0106d01:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d04:	d1 e8                	shr    %eax
c0106d06:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106d09:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106d0c:	d1 ea                	shr    %edx
c0106d0e:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106d11:	c1 ea 02             	shr    $0x2,%edx
c0106d14:	09 d0                	or     %edx,%eax
c0106d16:	c1 e8 04             	shr    $0x4,%eax
c0106d19:	09 c1                	or     %eax,%ecx
c0106d1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d1e:	d1 e8                	shr    %eax
c0106d20:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106d23:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106d26:	d1 ea                	shr    %edx
c0106d28:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106d2b:	c1 ea 02             	shr    $0x2,%edx
c0106d2e:	09 d0                	or     %edx,%eax
c0106d30:	89 c6                	mov    %eax,%esi
c0106d32:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d35:	d1 e8                	shr    %eax
c0106d37:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106d3a:	89 c2                	mov    %eax,%edx
c0106d3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d3f:	d1 e8                	shr    %eax
c0106d41:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106d44:	c1 e8 02             	shr    $0x2,%eax
c0106d47:	09 d0                	or     %edx,%eax
c0106d49:	c1 e8 04             	shr    $0x4,%eax
c0106d4c:	09 f0                	or     %esi,%eax
c0106d4e:	c1 e8 08             	shr    $0x8,%eax
c0106d51:	09 c8                	or     %ecx,%eax
c0106d53:	c1 e8 10             	shr    $0x10,%eax
c0106d56:	09 d8                	or     %ebx,%eax
c0106d58:	d1 e8                	shr    %eax
c0106d5a:	23 45 d0             	and    -0x30(%ebp),%eax
c0106d5d:	85 c0                	test   %eax,%eax
c0106d5f:	0f 84 e2 00 00 00    	je     c0106e47 <buddy_free_pages+0xa1b>
c0106d65:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d68:	d1 e8                	shr    %eax
c0106d6a:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106d6d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106d70:	d1 ea                	shr    %edx
c0106d72:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106d75:	c1 ea 02             	shr    $0x2,%edx
c0106d78:	09 d0                	or     %edx,%eax
c0106d7a:	89 c1                	mov    %eax,%ecx
c0106d7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d7f:	d1 e8                	shr    %eax
c0106d81:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106d84:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106d87:	d1 ea                	shr    %edx
c0106d89:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106d8c:	c1 ea 02             	shr    $0x2,%edx
c0106d8f:	09 d0                	or     %edx,%eax
c0106d91:	c1 e8 04             	shr    $0x4,%eax
c0106d94:	09 c1                	or     %eax,%ecx
c0106d96:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d99:	d1 e8                	shr    %eax
c0106d9b:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106d9e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106da1:	d1 ea                	shr    %edx
c0106da3:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106da6:	c1 ea 02             	shr    $0x2,%edx
c0106da9:	09 d0                	or     %edx,%eax
c0106dab:	89 c3                	mov    %eax,%ebx
c0106dad:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106db0:	d1 e8                	shr    %eax
c0106db2:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106db5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106db8:	d1 ea                	shr    %edx
c0106dba:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106dbd:	c1 ea 02             	shr    $0x2,%edx
c0106dc0:	09 d0                	or     %edx,%eax
c0106dc2:	c1 e8 04             	shr    $0x4,%eax
c0106dc5:	09 d8                	or     %ebx,%eax
c0106dc7:	c1 e8 08             	shr    $0x8,%eax
c0106dca:	89 cb                	mov    %ecx,%ebx
c0106dcc:	09 c3                	or     %eax,%ebx
c0106dce:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106dd1:	d1 e8                	shr    %eax
c0106dd3:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106dd6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106dd9:	d1 ea                	shr    %edx
c0106ddb:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106dde:	c1 ea 02             	shr    $0x2,%edx
c0106de1:	09 d0                	or     %edx,%eax
c0106de3:	89 c1                	mov    %eax,%ecx
c0106de5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106de8:	d1 e8                	shr    %eax
c0106dea:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106ded:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106df0:	d1 ea                	shr    %edx
c0106df2:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106df5:	c1 ea 02             	shr    $0x2,%edx
c0106df8:	09 d0                	or     %edx,%eax
c0106dfa:	c1 e8 04             	shr    $0x4,%eax
c0106dfd:	09 c1                	or     %eax,%ecx
c0106dff:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106e02:	d1 e8                	shr    %eax
c0106e04:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106e07:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106e0a:	d1 ea                	shr    %edx
c0106e0c:	0b 55 d0             	or     -0x30(%ebp),%edx
c0106e0f:	c1 ea 02             	shr    $0x2,%edx
c0106e12:	09 d0                	or     %edx,%eax
c0106e14:	89 c6                	mov    %eax,%esi
c0106e16:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106e19:	d1 e8                	shr    %eax
c0106e1b:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106e1e:	89 c2                	mov    %eax,%edx
c0106e20:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106e23:	d1 e8                	shr    %eax
c0106e25:	0b 45 d0             	or     -0x30(%ebp),%eax
c0106e28:	c1 e8 02             	shr    $0x2,%eax
c0106e2b:	09 d0                	or     %edx,%eax
c0106e2d:	c1 e8 04             	shr    $0x4,%eax
c0106e30:	09 f0                	or     %esi,%eax
c0106e32:	c1 e8 08             	shr    $0x8,%eax
c0106e35:	09 c8                	or     %ecx,%eax
c0106e37:	c1 e8 10             	shr    $0x10,%eax
c0106e3a:	09 d8                	or     %ebx,%eax
c0106e3c:	d1 e8                	shr    %eax
c0106e3e:	f7 d0                	not    %eax
c0106e40:	23 45 d0             	and    -0x30(%ebp),%eax
c0106e43:	89 c6                	mov    %eax,%esi
c0106e45:	eb 03                	jmp    c0106e4a <buddy_free_pages+0xa1e>
c0106e47:	8b 75 d0             	mov    -0x30(%ebp),%esi
c0106e4a:	89 f8                	mov    %edi,%eax
c0106e4c:	ba 00 00 00 00       	mov    $0x0,%edx
c0106e51:	f7 f6                	div    %esi
c0106e53:	0f af 85 64 ff ff ff 	imul   -0x9c(%ebp),%eax
c0106e5a:	89 45 c8             	mov    %eax,-0x38(%ebp)
            size_t rbegin = BUDDY_BEGIN(right);
c0106e5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106e60:	d1 e8                	shr    %eax
c0106e62:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106e65:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106e68:	d1 ea                	shr    %edx
c0106e6a:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106e6d:	c1 ea 02             	shr    $0x2,%edx
c0106e70:	09 d0                	or     %edx,%eax
c0106e72:	89 c1                	mov    %eax,%ecx
c0106e74:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106e77:	d1 e8                	shr    %eax
c0106e79:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106e7c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106e7f:	d1 ea                	shr    %edx
c0106e81:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106e84:	c1 ea 02             	shr    $0x2,%edx
c0106e87:	09 d0                	or     %edx,%eax
c0106e89:	c1 e8 04             	shr    $0x4,%eax
c0106e8c:	09 c1                	or     %eax,%ecx
c0106e8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106e91:	d1 e8                	shr    %eax
c0106e93:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106e96:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106e99:	d1 ea                	shr    %edx
c0106e9b:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106e9e:	c1 ea 02             	shr    $0x2,%edx
c0106ea1:	09 d0                	or     %edx,%eax
c0106ea3:	89 c3                	mov    %eax,%ebx
c0106ea5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106ea8:	d1 e8                	shr    %eax
c0106eaa:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106ead:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106eb0:	d1 ea                	shr    %edx
c0106eb2:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106eb5:	c1 ea 02             	shr    $0x2,%edx
c0106eb8:	09 d0                	or     %edx,%eax
c0106eba:	c1 e8 04             	shr    $0x4,%eax
c0106ebd:	09 d8                	or     %ebx,%eax
c0106ebf:	c1 e8 08             	shr    $0x8,%eax
c0106ec2:	09 c1                	or     %eax,%ecx
c0106ec4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106ec7:	d1 e8                	shr    %eax
c0106ec9:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106ecc:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106ecf:	d1 ea                	shr    %edx
c0106ed1:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106ed4:	c1 ea 02             	shr    $0x2,%edx
c0106ed7:	09 d0                	or     %edx,%eax
c0106ed9:	89 c3                	mov    %eax,%ebx
c0106edb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106ede:	d1 e8                	shr    %eax
c0106ee0:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106ee3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106ee6:	d1 ea                	shr    %edx
c0106ee8:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106eeb:	c1 ea 02             	shr    $0x2,%edx
c0106eee:	09 d0                	or     %edx,%eax
c0106ef0:	c1 e8 04             	shr    $0x4,%eax
c0106ef3:	09 c3                	or     %eax,%ebx
c0106ef5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106ef8:	d1 e8                	shr    %eax
c0106efa:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106efd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106f00:	d1 ea                	shr    %edx
c0106f02:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106f05:	c1 ea 02             	shr    $0x2,%edx
c0106f08:	09 d0                	or     %edx,%eax
c0106f0a:	89 c6                	mov    %eax,%esi
c0106f0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106f0f:	d1 e8                	shr    %eax
c0106f11:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106f14:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106f17:	d1 ea                	shr    %edx
c0106f19:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106f1c:	c1 ea 02             	shr    $0x2,%edx
c0106f1f:	09 d0                	or     %edx,%eax
c0106f21:	c1 e8 04             	shr    $0x4,%eax
c0106f24:	09 f0                	or     %esi,%eax
c0106f26:	c1 e8 08             	shr    $0x8,%eax
c0106f29:	09 d8                	or     %ebx,%eax
c0106f2b:	c1 e8 10             	shr    $0x10,%eax
c0106f2e:	09 c8                	or     %ecx,%eax
c0106f30:	d1 e8                	shr    %eax
c0106f32:	23 45 cc             	and    -0x34(%ebp),%eax
c0106f35:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
c0106f3b:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c0106f41:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106f44:	d1 e8                	shr    %eax
c0106f46:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106f49:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106f4c:	d1 ea                	shr    %edx
c0106f4e:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106f51:	c1 ea 02             	shr    $0x2,%edx
c0106f54:	09 d0                	or     %edx,%eax
c0106f56:	89 c1                	mov    %eax,%ecx
c0106f58:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106f5b:	d1 e8                	shr    %eax
c0106f5d:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106f60:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106f63:	d1 ea                	shr    %edx
c0106f65:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106f68:	c1 ea 02             	shr    $0x2,%edx
c0106f6b:	09 d0                	or     %edx,%eax
c0106f6d:	c1 e8 04             	shr    $0x4,%eax
c0106f70:	09 c1                	or     %eax,%ecx
c0106f72:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106f75:	d1 e8                	shr    %eax
c0106f77:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106f7a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106f7d:	d1 ea                	shr    %edx
c0106f7f:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106f82:	c1 ea 02             	shr    $0x2,%edx
c0106f85:	09 d0                	or     %edx,%eax
c0106f87:	89 c3                	mov    %eax,%ebx
c0106f89:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106f8c:	d1 e8                	shr    %eax
c0106f8e:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106f91:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106f94:	d1 ea                	shr    %edx
c0106f96:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106f99:	c1 ea 02             	shr    $0x2,%edx
c0106f9c:	09 d0                	or     %edx,%eax
c0106f9e:	c1 e8 04             	shr    $0x4,%eax
c0106fa1:	09 d8                	or     %ebx,%eax
c0106fa3:	c1 e8 08             	shr    $0x8,%eax
c0106fa6:	89 cb                	mov    %ecx,%ebx
c0106fa8:	09 c3                	or     %eax,%ebx
c0106faa:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106fad:	d1 e8                	shr    %eax
c0106faf:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106fb2:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106fb5:	d1 ea                	shr    %edx
c0106fb7:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106fba:	c1 ea 02             	shr    $0x2,%edx
c0106fbd:	09 d0                	or     %edx,%eax
c0106fbf:	89 c1                	mov    %eax,%ecx
c0106fc1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106fc4:	d1 e8                	shr    %eax
c0106fc6:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106fc9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106fcc:	d1 ea                	shr    %edx
c0106fce:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106fd1:	c1 ea 02             	shr    $0x2,%edx
c0106fd4:	09 d0                	or     %edx,%eax
c0106fd6:	c1 e8 04             	shr    $0x4,%eax
c0106fd9:	09 c1                	or     %eax,%ecx
c0106fdb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106fde:	d1 e8                	shr    %eax
c0106fe0:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106fe3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106fe6:	d1 ea                	shr    %edx
c0106fe8:	0b 55 cc             	or     -0x34(%ebp),%edx
c0106feb:	c1 ea 02             	shr    $0x2,%edx
c0106fee:	09 d0                	or     %edx,%eax
c0106ff0:	89 c6                	mov    %eax,%esi
c0106ff2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106ff5:	d1 e8                	shr    %eax
c0106ff7:	0b 45 cc             	or     -0x34(%ebp),%eax
c0106ffa:	89 c2                	mov    %eax,%edx
c0106ffc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106fff:	d1 e8                	shr    %eax
c0107001:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107004:	c1 e8 02             	shr    $0x2,%eax
c0107007:	09 d0                	or     %edx,%eax
c0107009:	c1 e8 04             	shr    $0x4,%eax
c010700c:	09 f0                	or     %esi,%eax
c010700e:	c1 e8 08             	shr    $0x8,%eax
c0107011:	09 c8                	or     %ecx,%eax
c0107013:	c1 e8 10             	shr    $0x10,%eax
c0107016:	09 d8                	or     %ebx,%eax
c0107018:	d1 e8                	shr    %eax
c010701a:	23 45 cc             	and    -0x34(%ebp),%eax
c010701d:	85 c0                	test   %eax,%eax
c010701f:	0f 84 e2 00 00 00    	je     c0107107 <buddy_free_pages+0xcdb>
c0107025:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107028:	d1 e8                	shr    %eax
c010702a:	0b 45 cc             	or     -0x34(%ebp),%eax
c010702d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107030:	d1 ea                	shr    %edx
c0107032:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107035:	c1 ea 02             	shr    $0x2,%edx
c0107038:	09 d0                	or     %edx,%eax
c010703a:	89 c1                	mov    %eax,%ecx
c010703c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010703f:	d1 e8                	shr    %eax
c0107041:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107044:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107047:	d1 ea                	shr    %edx
c0107049:	0b 55 cc             	or     -0x34(%ebp),%edx
c010704c:	c1 ea 02             	shr    $0x2,%edx
c010704f:	09 d0                	or     %edx,%eax
c0107051:	c1 e8 04             	shr    $0x4,%eax
c0107054:	09 c1                	or     %eax,%ecx
c0107056:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107059:	d1 e8                	shr    %eax
c010705b:	0b 45 cc             	or     -0x34(%ebp),%eax
c010705e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107061:	d1 ea                	shr    %edx
c0107063:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107066:	c1 ea 02             	shr    $0x2,%edx
c0107069:	09 d0                	or     %edx,%eax
c010706b:	89 c3                	mov    %eax,%ebx
c010706d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107070:	d1 e8                	shr    %eax
c0107072:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107075:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107078:	d1 ea                	shr    %edx
c010707a:	0b 55 cc             	or     -0x34(%ebp),%edx
c010707d:	c1 ea 02             	shr    $0x2,%edx
c0107080:	09 d0                	or     %edx,%eax
c0107082:	c1 e8 04             	shr    $0x4,%eax
c0107085:	09 d8                	or     %ebx,%eax
c0107087:	c1 e8 08             	shr    $0x8,%eax
c010708a:	89 cb                	mov    %ecx,%ebx
c010708c:	09 c3                	or     %eax,%ebx
c010708e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107091:	d1 e8                	shr    %eax
c0107093:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107096:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107099:	d1 ea                	shr    %edx
c010709b:	0b 55 cc             	or     -0x34(%ebp),%edx
c010709e:	c1 ea 02             	shr    $0x2,%edx
c01070a1:	09 d0                	or     %edx,%eax
c01070a3:	89 c1                	mov    %eax,%ecx
c01070a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01070a8:	d1 e8                	shr    %eax
c01070aa:	0b 45 cc             	or     -0x34(%ebp),%eax
c01070ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01070b0:	d1 ea                	shr    %edx
c01070b2:	0b 55 cc             	or     -0x34(%ebp),%edx
c01070b5:	c1 ea 02             	shr    $0x2,%edx
c01070b8:	09 d0                	or     %edx,%eax
c01070ba:	c1 e8 04             	shr    $0x4,%eax
c01070bd:	09 c1                	or     %eax,%ecx
c01070bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01070c2:	d1 e8                	shr    %eax
c01070c4:	0b 45 cc             	or     -0x34(%ebp),%eax
c01070c7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01070ca:	d1 ea                	shr    %edx
c01070cc:	0b 55 cc             	or     -0x34(%ebp),%edx
c01070cf:	c1 ea 02             	shr    $0x2,%edx
c01070d2:	09 d0                	or     %edx,%eax
c01070d4:	89 c6                	mov    %eax,%esi
c01070d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01070d9:	d1 e8                	shr    %eax
c01070db:	0b 45 cc             	or     -0x34(%ebp),%eax
c01070de:	89 c2                	mov    %eax,%edx
c01070e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01070e3:	d1 e8                	shr    %eax
c01070e5:	0b 45 cc             	or     -0x34(%ebp),%eax
c01070e8:	c1 e8 02             	shr    $0x2,%eax
c01070eb:	09 d0                	or     %edx,%eax
c01070ed:	c1 e8 04             	shr    $0x4,%eax
c01070f0:	09 f0                	or     %esi,%eax
c01070f2:	c1 e8 08             	shr    $0x8,%eax
c01070f5:	09 c8                	or     %ecx,%eax
c01070f7:	c1 e8 10             	shr    $0x10,%eax
c01070fa:	09 d8                	or     %ebx,%eax
c01070fc:	d1 e8                	shr    %eax
c01070fe:	f7 d0                	not    %eax
c0107100:	23 45 cc             	and    -0x34(%ebp),%eax
c0107103:	89 c6                	mov    %eax,%esi
c0107105:	eb 03                	jmp    c010710a <buddy_free_pages+0xcde>
c0107107:	8b 75 cc             	mov    -0x34(%ebp),%esi
c010710a:	89 f8                	mov    %edi,%eax
c010710c:	ba 00 00 00 00       	mov    $0x0,%edx
c0107111:	f7 f6                	div    %esi
c0107113:	0f af 85 64 ff ff ff 	imul   -0x9c(%ebp),%eax
c010711a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            list_del(&(buddy_alloc[lbegin].page_link));
c010711d:	8b 0d 64 e9 11 c0    	mov    0xc011e964,%ecx
c0107123:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107126:	89 d0                	mov    %edx,%eax
c0107128:	c1 e0 02             	shl    $0x2,%eax
c010712b:	01 d0                	add    %edx,%eax
c010712d:	c1 e0 02             	shl    $0x2,%eax
c0107130:	01 c8                	add    %ecx,%eax
c0107132:	83 c0 0c             	add    $0xc,%eax
c0107135:	89 45 98             	mov    %eax,-0x68(%ebp)
    __list_del(listelm->prev, listelm->next);
c0107138:	8b 45 98             	mov    -0x68(%ebp),%eax
c010713b:	8b 40 04             	mov    0x4(%eax),%eax
c010713e:	8b 55 98             	mov    -0x68(%ebp),%edx
c0107141:	8b 12                	mov    (%edx),%edx
c0107143:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0107146:	89 45 90             	mov    %eax,-0x70(%ebp)
    prev->next = next;
c0107149:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010714c:	8b 55 90             	mov    -0x70(%ebp),%edx
c010714f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107152:	8b 45 90             	mov    -0x70(%ebp),%eax
c0107155:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0107158:	89 10                	mov    %edx,(%eax)
            list_del(&(buddy_alloc[rbegin].page_link));
c010715a:	8b 0d 64 e9 11 c0    	mov    0xc011e964,%ecx
c0107160:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0107163:	89 d0                	mov    %edx,%eax
c0107165:	c1 e0 02             	shl    $0x2,%eax
c0107168:	01 d0                	add    %edx,%eax
c010716a:	c1 e0 02             	shl    $0x2,%eax
c010716d:	01 c8                	add    %ecx,%eax
c010716f:	83 c0 0c             	add    $0xc,%eax
c0107172:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_del(listelm->prev, listelm->next);
c0107175:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0107178:	8b 40 04             	mov    0x4(%eax),%eax
c010717b:	8b 55 8c             	mov    -0x74(%ebp),%edx
c010717e:	8b 12                	mov    (%edx),%edx
c0107180:	89 55 88             	mov    %edx,-0x78(%ebp)
c0107183:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next;
c0107186:	8b 45 88             	mov    -0x78(%ebp),%eax
c0107189:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010718c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010718f:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0107192:	8b 55 88             	mov    -0x78(%ebp),%edx
c0107195:	89 10                	mov    %edx,(%eax)
            buddy_segment[block] = buddy_segment[left]<<1;
c0107197:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c010719c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010719f:	c1 e2 02             	shl    $0x2,%edx
c01071a2:	01 d0                	add    %edx,%eax
c01071a4:	8b 15 5c e9 11 c0    	mov    0xc011e95c,%edx
c01071aa:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01071ad:	c1 e1 02             	shl    $0x2,%ecx
c01071b0:	01 ca                	add    %ecx,%edx
c01071b2:	8b 12                	mov    (%edx),%edx
c01071b4:	01 d2                	add    %edx,%edx
c01071b6:	89 10                	mov    %edx,(%eax)
            buddy_alloc[lbegin].property = buddy_segment[left]<<1;
c01071b8:	8b 0d 64 e9 11 c0    	mov    0xc011e964,%ecx
c01071be:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01071c1:	89 d0                	mov    %edx,%eax
c01071c3:	c1 e0 02             	shl    $0x2,%eax
c01071c6:	01 d0                	add    %edx,%eax
c01071c8:	c1 e0 02             	shl    $0x2,%eax
c01071cb:	01 c8                	add    %ecx,%eax
c01071cd:	8b 15 5c e9 11 c0    	mov    0xc011e95c,%edx
c01071d3:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01071d6:	c1 e1 02             	shl    $0x2,%ecx
c01071d9:	01 ca                	add    %ecx,%edx
c01071db:	8b 12                	mov    (%edx),%edx
c01071dd:	01 d2                	add    %edx,%edx
c01071df:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(free_list), &(buddy_alloc[lbegin].page_link));
c01071e2:	8b 0d 64 e9 11 c0    	mov    0xc011e964,%ecx
c01071e8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01071eb:	89 d0                	mov    %edx,%eax
c01071ed:	c1 e0 02             	shl    $0x2,%eax
c01071f0:	01 d0                	add    %edx,%eax
c01071f2:	c1 e0 02             	shl    $0x2,%eax
c01071f5:	01 c8                	add    %ecx,%eax
c01071f7:	83 c0 0c             	add    $0xc,%eax
c01071fa:	c7 45 80 78 e9 11 c0 	movl   $0xc011e978,-0x80(%ebp)
c0107201:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0107207:	8b 45 80             	mov    -0x80(%ebp),%eax
c010720a:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0107210:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0107216:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    __list_add(elm, listelm, listelm->next);
c010721c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0107222:	8b 40 04             	mov    0x4(%eax),%eax
c0107225:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c010722b:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
c0107231:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c0107237:	89 95 6c ff ff ff    	mov    %edx,-0x94(%ebp)
c010723d:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
    prev->next = next->prev = elm;
c0107243:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0107249:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c010724f:	89 10                	mov    %edx,(%eax)
c0107251:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0107257:	8b 10                	mov    (%eax),%edx
c0107259:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c010725f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107262:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0107268:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
c010726e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107271:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0107277:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c010727d:	89 10                	mov    %edx,(%eax)
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right)) {  // Merge
c010727f:	eb 34                	jmp    c01072b5 <buddy_free_pages+0xe89>
        } else {                                        // Update
            buddy_segment[block] = buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)];
c0107281:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0107286:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107289:	c1 e2 02             	shl    $0x2,%edx
c010728c:	01 d0                	add    %edx,%eax
c010728e:	8b 15 5c e9 11 c0    	mov    0xc011e95c,%edx
c0107294:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0107297:	c1 e1 03             	shl    $0x3,%ecx
c010729a:	01 ca                	add    %ecx,%edx
c010729c:	8b 0a                	mov    (%edx),%ecx
c010729e:	8b 15 5c e9 11 c0    	mov    0xc011e95c,%edx
c01072a4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
c01072a7:	c1 e3 03             	shl    $0x3,%ebx
c01072aa:	83 c3 04             	add    $0x4,%ebx
c01072ad:	01 da                	add    %ebx,%edx
c01072af:	8b 12                	mov    (%edx),%edx
c01072b1:	09 ca                	or     %ecx,%edx
c01072b3:	89 10                	mov    %edx,(%eax)
    while (block != BUDDY_ROOT) {
c01072b5:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
c01072b9:	0f 85 d6 f4 ff ff    	jne    c0106795 <buddy_free_pages+0x369>
        }
    }
}
c01072bf:	81 c4 ac 00 00 00    	add    $0xac,%esp
c01072c5:	5b                   	pop    %ebx
c01072c6:	5e                   	pop    %esi
c01072c7:	5f                   	pop    %edi
c01072c8:	5d                   	pop    %ebp
c01072c9:	c3                   	ret    

c01072ca <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
c01072ca:	55                   	push   %ebp
c01072cb:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01072cd:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
}
c01072d2:	5d                   	pop    %ebp
c01072d3:	c3                   	ret    

c01072d4 <macro_check>:

static void
macro_check(void) {
c01072d4:	55                   	push   %ebp
c01072d5:	89 e5                	mov    %esp,%ebp
c01072d7:	83 ec 28             	sub    $0x28,%esp
    assert(BUDDY_ROOT == 1);
    assert(BUDDY_LEFT(3) == 6);
    assert(BUDDY_RIGHT(3) == 7);
    assert(BUDDY_PARENT(6) == 3);
    assert(BUDDY_PARENT(7) == 3);
    size_t buddy_virtual_size_store = buddy_virtual_size;
c01072da:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c01072df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t buddy_segment_root_store = buddy_segment[BUDDY_ROOT];
c01072e2:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c01072e7:	8b 40 04             	mov    0x4(%eax),%eax
c01072ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    buddy_virtual_size = 16;
c01072ed:	c7 05 50 e9 11 c0 10 	movl   $0x10,0xc011e950
c01072f4:	00 00 00 
    buddy_segment[BUDDY_ROOT] = 16;
c01072f7:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c01072fc:	83 c0 04             	add    $0x4,%eax
c01072ff:	c7 00 10 00 00 00    	movl   $0x10,(%eax)
    assert(BUDDY_LENGTH(6) == 4);
c0107305:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c010730a:	83 e8 10             	sub    $0x10,%eax
c010730d:	83 f8 03             	cmp    $0x3,%eax
c0107310:	76 24                	jbe    c0107336 <macro_check+0x62>
c0107312:	c7 44 24 0c 08 ac 10 	movl   $0xc010ac08,0xc(%esp)
c0107319:	c0 
c010731a:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107321:	c0 
c0107322:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0107329:	00 
c010732a:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107331:	e8 b2 90 ff ff       	call   c01003e8 <__panic>
    assert(BUDDY_BEGIN(6) == 8);
c0107336:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c010733b:	c1 e8 02             	shr    $0x2,%eax
c010733e:	01 c0                	add    %eax,%eax
c0107340:	83 f8 08             	cmp    $0x8,%eax
c0107343:	74 24                	je     c0107369 <macro_check+0x95>
c0107345:	c7 44 24 0c 1d ac 10 	movl   $0xc010ac1d,0xc(%esp)
c010734c:	c0 
c010734d:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107354:	c0 
c0107355:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c010735c:	00 
c010735d:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107364:	e8 7f 90 ff ff       	call   c01003e8 <__panic>
    assert(BUDDY_END(6) == 12);
c0107369:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c010736e:	c1 e8 02             	shr    $0x2,%eax
c0107371:	89 c2                	mov    %eax,%edx
c0107373:	89 d0                	mov    %edx,%eax
c0107375:	01 c0                	add    %eax,%eax
c0107377:	01 d0                	add    %edx,%eax
c0107379:	83 f8 0c             	cmp    $0xc,%eax
c010737c:	74 24                	je     c01073a2 <macro_check+0xce>
c010737e:	c7 44 24 0c 31 ac 10 	movl   $0xc010ac31,0xc(%esp)
c0107385:	c0 
c0107386:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c010738d:	c0 
c010738e:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0107395:	00 
c0107396:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c010739d:	e8 46 90 ff ff       	call   c01003e8 <__panic>
    assert(BUDDY_BLOCK(8, 12) == 6);
c01073a2:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c01073a7:	83 e8 10             	sub    $0x10,%eax
c01073aa:	83 f8 03             	cmp    $0x3,%eax
c01073ad:	76 24                	jbe    c01073d3 <macro_check+0xff>
c01073af:	c7 44 24 0c 44 ac 10 	movl   $0xc010ac44,0xc(%esp)
c01073b6:	c0 
c01073b7:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c01073be:	c0 
c01073bf:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01073c6:	00 
c01073c7:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c01073ce:	e8 15 90 ff ff       	call   c01003e8 <__panic>
    assert(BUDDY_EMPTY(BUDDY_ROOT));
c01073d3:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c01073d8:	83 c0 04             	add    $0x4,%eax
c01073db:	8b 10                	mov    (%eax),%edx
c01073dd:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c01073e2:	39 c2                	cmp    %eax,%edx
c01073e4:	74 24                	je     c010740a <macro_check+0x136>
c01073e6:	c7 44 24 0c 5c ac 10 	movl   $0xc010ac5c,0xc(%esp)
c01073ed:	c0 
c01073ee:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c01073f5:	c0 
c01073f6:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01073fd:	00 
c01073fe:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107405:	e8 de 8f ff ff       	call   c01003e8 <__panic>
    buddy_virtual_size = buddy_virtual_size_store;
c010740a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010740d:	a3 50 e9 11 c0       	mov    %eax,0xc011e950
    buddy_segment[BUDDY_ROOT] = buddy_segment_root_store;
c0107412:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0107417:	8d 50 04             	lea    0x4(%eax),%edx
c010741a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010741d:	89 02                	mov    %eax,(%edx)
    assert(UINT32_ROUND_UP(0x2321) == 0x4000);
    assert(UINT32_ROUND_UP(0x2000) == 0x2000);
    assert(UINT32_ROUND_DOWN(0x4321) == 0x4000);
    assert(UINT32_ROUND_DOWN(0x4000) == 0x4000);

}
c010741f:	c9                   	leave  
c0107420:	c3                   	ret    

c0107421 <size_check>:

static void
size_check(void) {
c0107421:	55                   	push   %ebp
c0107422:	89 e5                	mov    %esp,%ebp
c0107424:	83 ec 28             	sub    $0x28,%esp

    size_t buddy_physical_size_store = buddy_physical_size;
c0107427:	a1 4c e9 11 c0       	mov    0xc011e94c,%eax
c010742c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    buddy_init_size(200);
c010742f:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
c0107436:	e8 0f d0 ff ff       	call   c010444a <buddy_init_size>
    assert(buddy_virtual_size == 256);
c010743b:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c0107440:	3d 00 01 00 00       	cmp    $0x100,%eax
c0107445:	74 24                	je     c010746b <size_check+0x4a>
c0107447:	c7 44 24 0c 74 ac 10 	movl   $0xc010ac74,0xc(%esp)
c010744e:	c0 
c010744f:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107456:	c0 
c0107457:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c010745e:	00 
c010745f:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107466:	e8 7d 8f ff ff       	call   c01003e8 <__panic>
    buddy_init_size(1024);
c010746b:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
c0107472:	e8 d3 cf ff ff       	call   c010444a <buddy_init_size>
    assert(buddy_virtual_size == 1024);
c0107477:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c010747c:	3d 00 04 00 00       	cmp    $0x400,%eax
c0107481:	74 24                	je     c01074a7 <size_check+0x86>
c0107483:	c7 44 24 0c 8e ac 10 	movl   $0xc010ac8e,0xc(%esp)
c010748a:	c0 
c010748b:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107492:	c0 
c0107493:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c010749a:	00 
c010749b:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c01074a2:	e8 41 8f ff ff       	call   c01003e8 <__panic>
    buddy_init_size(1026);
c01074a7:	c7 04 24 02 04 00 00 	movl   $0x402,(%esp)
c01074ae:	e8 97 cf ff ff       	call   c010444a <buddy_init_size>
    assert(buddy_virtual_size == 1024);
c01074b3:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c01074b8:	3d 00 04 00 00       	cmp    $0x400,%eax
c01074bd:	74 24                	je     c01074e3 <size_check+0xc2>
c01074bf:	c7 44 24 0c 8e ac 10 	movl   $0xc010ac8e,0xc(%esp)
c01074c6:	c0 
c01074c7:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c01074ce:	c0 
c01074cf:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01074d6:	00 
c01074d7:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c01074de:	e8 05 8f ff ff       	call   c01003e8 <__panic>
    buddy_init_size(1028);    
c01074e3:	c7 04 24 04 04 00 00 	movl   $0x404,(%esp)
c01074ea:	e8 5b cf ff ff       	call   c010444a <buddy_init_size>
    assert(buddy_virtual_size == 1024);
c01074ef:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c01074f4:	3d 00 04 00 00       	cmp    $0x400,%eax
c01074f9:	74 24                	je     c010751f <size_check+0xfe>
c01074fb:	c7 44 24 0c 8e ac 10 	movl   $0xc010ac8e,0xc(%esp)
c0107502:	c0 
c0107503:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c010750a:	c0 
c010750b:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0107512:	00 
c0107513:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c010751a:	e8 c9 8e ff ff       	call   c01003e8 <__panic>
    buddy_init_size(1030);    
c010751f:	c7 04 24 06 04 00 00 	movl   $0x406,(%esp)
c0107526:	e8 1f cf ff ff       	call   c010444a <buddy_init_size>
    assert(buddy_virtual_size == 2048);
c010752b:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c0107530:	3d 00 08 00 00       	cmp    $0x800,%eax
c0107535:	74 24                	je     c010755b <size_check+0x13a>
c0107537:	c7 44 24 0c a9 ac 10 	movl   $0xc010aca9,0xc(%esp)
c010753e:	c0 
c010753f:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107546:	c0 
c0107547:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c010754e:	00 
c010754f:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107556:	e8 8d 8e ff ff       	call   c01003e8 <__panic>
    buddy_init_size(buddy_physical_size_store);   
c010755b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010755e:	89 04 24             	mov    %eax,(%esp)
c0107561:	e8 e4 ce ff ff       	call   c010444a <buddy_init_size>

}
c0107566:	c9                   	leave  
c0107567:	c3                   	ret    

c0107568 <segment_check>:

static void
segment_check(void) {
c0107568:	55                   	push   %ebp
c0107569:	89 e5                	mov    %esp,%ebp
c010756b:	57                   	push   %edi
c010756c:	56                   	push   %esi
c010756d:	53                   	push   %ebx
c010756e:	83 ec 4c             	sub    $0x4c,%esp

    // Check buddy segment
    size_t total = 0, count = 0;
c0107571:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0107578:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    size_t block;
    for (block = BUDDY_ROOT; block < (buddy_virtual_size<<1); block++)
c010757f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0107586:	e9 2f 04 00 00       	jmp    c01079ba <segment_check+0x452>
        if (BUDDY_EMPTY(block))
c010758b:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c0107590:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107593:	c1 e2 02             	shl    $0x2,%edx
c0107596:	01 d0                	add    %edx,%eax
c0107598:	8b 00                	mov    (%eax),%eax
c010759a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010759d:	8b 3d 50 e9 11 c0    	mov    0xc011e950,%edi
c01075a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01075a6:	d1 e8                	shr    %eax
c01075a8:	0b 45 dc             	or     -0x24(%ebp),%eax
c01075ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01075ae:	d1 ea                	shr    %edx
c01075b0:	0b 55 dc             	or     -0x24(%ebp),%edx
c01075b3:	c1 ea 02             	shr    $0x2,%edx
c01075b6:	09 d0                	or     %edx,%eax
c01075b8:	89 c1                	mov    %eax,%ecx
c01075ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01075bd:	d1 e8                	shr    %eax
c01075bf:	0b 45 dc             	or     -0x24(%ebp),%eax
c01075c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01075c5:	d1 ea                	shr    %edx
c01075c7:	0b 55 dc             	or     -0x24(%ebp),%edx
c01075ca:	c1 ea 02             	shr    $0x2,%edx
c01075cd:	09 d0                	or     %edx,%eax
c01075cf:	c1 e8 04             	shr    $0x4,%eax
c01075d2:	09 c1                	or     %eax,%ecx
c01075d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01075d7:	d1 e8                	shr    %eax
c01075d9:	0b 45 dc             	or     -0x24(%ebp),%eax
c01075dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01075df:	d1 ea                	shr    %edx
c01075e1:	0b 55 dc             	or     -0x24(%ebp),%edx
c01075e4:	c1 ea 02             	shr    $0x2,%edx
c01075e7:	09 d0                	or     %edx,%eax
c01075e9:	89 c3                	mov    %eax,%ebx
c01075eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01075ee:	d1 e8                	shr    %eax
c01075f0:	0b 45 dc             	or     -0x24(%ebp),%eax
c01075f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01075f6:	d1 ea                	shr    %edx
c01075f8:	0b 55 dc             	or     -0x24(%ebp),%edx
c01075fb:	c1 ea 02             	shr    $0x2,%edx
c01075fe:	09 d0                	or     %edx,%eax
c0107600:	c1 e8 04             	shr    $0x4,%eax
c0107603:	09 d8                	or     %ebx,%eax
c0107605:	c1 e8 08             	shr    $0x8,%eax
c0107608:	89 cb                	mov    %ecx,%ebx
c010760a:	09 c3                	or     %eax,%ebx
c010760c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010760f:	d1 e8                	shr    %eax
c0107611:	0b 45 dc             	or     -0x24(%ebp),%eax
c0107614:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107617:	d1 ea                	shr    %edx
c0107619:	0b 55 dc             	or     -0x24(%ebp),%edx
c010761c:	c1 ea 02             	shr    $0x2,%edx
c010761f:	09 d0                	or     %edx,%eax
c0107621:	89 c1                	mov    %eax,%ecx
c0107623:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107626:	d1 e8                	shr    %eax
c0107628:	0b 45 dc             	or     -0x24(%ebp),%eax
c010762b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010762e:	d1 ea                	shr    %edx
c0107630:	0b 55 dc             	or     -0x24(%ebp),%edx
c0107633:	c1 ea 02             	shr    $0x2,%edx
c0107636:	09 d0                	or     %edx,%eax
c0107638:	c1 e8 04             	shr    $0x4,%eax
c010763b:	09 c1                	or     %eax,%ecx
c010763d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107640:	d1 e8                	shr    %eax
c0107642:	0b 45 dc             	or     -0x24(%ebp),%eax
c0107645:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107648:	d1 ea                	shr    %edx
c010764a:	0b 55 dc             	or     -0x24(%ebp),%edx
c010764d:	c1 ea 02             	shr    $0x2,%edx
c0107650:	09 d0                	or     %edx,%eax
c0107652:	89 c6                	mov    %eax,%esi
c0107654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107657:	d1 e8                	shr    %eax
c0107659:	0b 45 dc             	or     -0x24(%ebp),%eax
c010765c:	89 c2                	mov    %eax,%edx
c010765e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107661:	d1 e8                	shr    %eax
c0107663:	0b 45 dc             	or     -0x24(%ebp),%eax
c0107666:	c1 e8 02             	shr    $0x2,%eax
c0107669:	09 d0                	or     %edx,%eax
c010766b:	c1 e8 04             	shr    $0x4,%eax
c010766e:	09 f0                	or     %esi,%eax
c0107670:	c1 e8 08             	shr    $0x8,%eax
c0107673:	09 c8                	or     %ecx,%eax
c0107675:	c1 e8 10             	shr    $0x10,%eax
c0107678:	09 d8                	or     %ebx,%eax
c010767a:	d1 e8                	shr    %eax
c010767c:	23 45 dc             	and    -0x24(%ebp),%eax
c010767f:	85 c0                	test   %eax,%eax
c0107681:	0f 84 e2 00 00 00    	je     c0107769 <segment_check+0x201>
c0107687:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010768a:	d1 e8                	shr    %eax
c010768c:	0b 45 dc             	or     -0x24(%ebp),%eax
c010768f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107692:	d1 ea                	shr    %edx
c0107694:	0b 55 dc             	or     -0x24(%ebp),%edx
c0107697:	c1 ea 02             	shr    $0x2,%edx
c010769a:	09 d0                	or     %edx,%eax
c010769c:	89 c1                	mov    %eax,%ecx
c010769e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01076a1:	d1 e8                	shr    %eax
c01076a3:	0b 45 dc             	or     -0x24(%ebp),%eax
c01076a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01076a9:	d1 ea                	shr    %edx
c01076ab:	0b 55 dc             	or     -0x24(%ebp),%edx
c01076ae:	c1 ea 02             	shr    $0x2,%edx
c01076b1:	09 d0                	or     %edx,%eax
c01076b3:	c1 e8 04             	shr    $0x4,%eax
c01076b6:	09 c1                	or     %eax,%ecx
c01076b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01076bb:	d1 e8                	shr    %eax
c01076bd:	0b 45 dc             	or     -0x24(%ebp),%eax
c01076c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01076c3:	d1 ea                	shr    %edx
c01076c5:	0b 55 dc             	or     -0x24(%ebp),%edx
c01076c8:	c1 ea 02             	shr    $0x2,%edx
c01076cb:	09 d0                	or     %edx,%eax
c01076cd:	89 c3                	mov    %eax,%ebx
c01076cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01076d2:	d1 e8                	shr    %eax
c01076d4:	0b 45 dc             	or     -0x24(%ebp),%eax
c01076d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01076da:	d1 ea                	shr    %edx
c01076dc:	0b 55 dc             	or     -0x24(%ebp),%edx
c01076df:	c1 ea 02             	shr    $0x2,%edx
c01076e2:	09 d0                	or     %edx,%eax
c01076e4:	c1 e8 04             	shr    $0x4,%eax
c01076e7:	09 d8                	or     %ebx,%eax
c01076e9:	c1 e8 08             	shr    $0x8,%eax
c01076ec:	89 cb                	mov    %ecx,%ebx
c01076ee:	09 c3                	or     %eax,%ebx
c01076f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01076f3:	d1 e8                	shr    %eax
c01076f5:	0b 45 dc             	or     -0x24(%ebp),%eax
c01076f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01076fb:	d1 ea                	shr    %edx
c01076fd:	0b 55 dc             	or     -0x24(%ebp),%edx
c0107700:	c1 ea 02             	shr    $0x2,%edx
c0107703:	09 d0                	or     %edx,%eax
c0107705:	89 c1                	mov    %eax,%ecx
c0107707:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010770a:	d1 e8                	shr    %eax
c010770c:	0b 45 dc             	or     -0x24(%ebp),%eax
c010770f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107712:	d1 ea                	shr    %edx
c0107714:	0b 55 dc             	or     -0x24(%ebp),%edx
c0107717:	c1 ea 02             	shr    $0x2,%edx
c010771a:	09 d0                	or     %edx,%eax
c010771c:	c1 e8 04             	shr    $0x4,%eax
c010771f:	09 c1                	or     %eax,%ecx
c0107721:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107724:	d1 e8                	shr    %eax
c0107726:	0b 45 dc             	or     -0x24(%ebp),%eax
c0107729:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010772c:	d1 ea                	shr    %edx
c010772e:	0b 55 dc             	or     -0x24(%ebp),%edx
c0107731:	c1 ea 02             	shr    $0x2,%edx
c0107734:	09 d0                	or     %edx,%eax
c0107736:	89 c6                	mov    %eax,%esi
c0107738:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010773b:	d1 e8                	shr    %eax
c010773d:	0b 45 dc             	or     -0x24(%ebp),%eax
c0107740:	89 c2                	mov    %eax,%edx
c0107742:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107745:	d1 e8                	shr    %eax
c0107747:	0b 45 dc             	or     -0x24(%ebp),%eax
c010774a:	c1 e8 02             	shr    $0x2,%eax
c010774d:	09 d0                	or     %edx,%eax
c010774f:	c1 e8 04             	shr    $0x4,%eax
c0107752:	09 f0                	or     %esi,%eax
c0107754:	c1 e8 08             	shr    $0x8,%eax
c0107757:	09 c8                	or     %ecx,%eax
c0107759:	c1 e8 10             	shr    $0x10,%eax
c010775c:	09 d8                	or     %ebx,%eax
c010775e:	d1 e8                	shr    %eax
c0107760:	f7 d0                	not    %eax
c0107762:	23 45 dc             	and    -0x24(%ebp),%eax
c0107765:	89 c6                	mov    %eax,%esi
c0107767:	eb 03                	jmp    c010776c <segment_check+0x204>
c0107769:	8b 75 dc             	mov    -0x24(%ebp),%esi
c010776c:	89 f8                	mov    %edi,%eax
c010776e:	ba 00 00 00 00       	mov    $0x0,%edx
c0107773:	f7 f6                	div    %esi
c0107775:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
c0107778:	0f 85 d2 01 00 00    	jne    c0107950 <segment_check+0x3e8>
            total += BUDDY_LENGTH(block);
c010777e:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c0107783:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107786:	d1 ea                	shr    %edx
c0107788:	0b 55 dc             	or     -0x24(%ebp),%edx
c010778b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010778e:	d1 e9                	shr    %ecx
c0107790:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0107793:	c1 e9 02             	shr    $0x2,%ecx
c0107796:	89 d3                	mov    %edx,%ebx
c0107798:	09 cb                	or     %ecx,%ebx
c010779a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010779d:	d1 ea                	shr    %edx
c010779f:	0b 55 dc             	or     -0x24(%ebp),%edx
c01077a2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01077a5:	d1 e9                	shr    %ecx
c01077a7:	0b 4d dc             	or     -0x24(%ebp),%ecx
c01077aa:	c1 e9 02             	shr    $0x2,%ecx
c01077ad:	09 ca                	or     %ecx,%edx
c01077af:	c1 ea 04             	shr    $0x4,%edx
c01077b2:	09 d3                	or     %edx,%ebx
c01077b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01077b7:	d1 ea                	shr    %edx
c01077b9:	0b 55 dc             	or     -0x24(%ebp),%edx
c01077bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01077bf:	d1 e9                	shr    %ecx
c01077c1:	0b 4d dc             	or     -0x24(%ebp),%ecx
c01077c4:	c1 e9 02             	shr    $0x2,%ecx
c01077c7:	89 d6                	mov    %edx,%esi
c01077c9:	09 ce                	or     %ecx,%esi
c01077cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01077ce:	d1 ea                	shr    %edx
c01077d0:	0b 55 dc             	or     -0x24(%ebp),%edx
c01077d3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01077d6:	d1 e9                	shr    %ecx
c01077d8:	0b 4d dc             	or     -0x24(%ebp),%ecx
c01077db:	c1 e9 02             	shr    $0x2,%ecx
c01077de:	09 ca                	or     %ecx,%edx
c01077e0:	c1 ea 04             	shr    $0x4,%edx
c01077e3:	09 f2                	or     %esi,%edx
c01077e5:	c1 ea 08             	shr    $0x8,%edx
c01077e8:	09 d3                	or     %edx,%ebx
c01077ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01077ed:	d1 ea                	shr    %edx
c01077ef:	0b 55 dc             	or     -0x24(%ebp),%edx
c01077f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01077f5:	d1 e9                	shr    %ecx
c01077f7:	0b 4d dc             	or     -0x24(%ebp),%ecx
c01077fa:	c1 e9 02             	shr    $0x2,%ecx
c01077fd:	89 d6                	mov    %edx,%esi
c01077ff:	09 ce                	or     %ecx,%esi
c0107801:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107804:	d1 ea                	shr    %edx
c0107806:	0b 55 dc             	or     -0x24(%ebp),%edx
c0107809:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010780c:	d1 e9                	shr    %ecx
c010780e:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0107811:	c1 e9 02             	shr    $0x2,%ecx
c0107814:	09 ca                	or     %ecx,%edx
c0107816:	c1 ea 04             	shr    $0x4,%edx
c0107819:	09 d6                	or     %edx,%esi
c010781b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010781e:	d1 ea                	shr    %edx
c0107820:	0b 55 dc             	or     -0x24(%ebp),%edx
c0107823:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0107826:	d1 e9                	shr    %ecx
c0107828:	0b 4d dc             	or     -0x24(%ebp),%ecx
c010782b:	c1 e9 02             	shr    $0x2,%ecx
c010782e:	89 d7                	mov    %edx,%edi
c0107830:	09 cf                	or     %ecx,%edi
c0107832:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107835:	d1 ea                	shr    %edx
c0107837:	0b 55 dc             	or     -0x24(%ebp),%edx
c010783a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010783d:	d1 e9                	shr    %ecx
c010783f:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0107842:	c1 e9 02             	shr    $0x2,%ecx
c0107845:	09 ca                	or     %ecx,%edx
c0107847:	c1 ea 04             	shr    $0x4,%edx
c010784a:	09 fa                	or     %edi,%edx
c010784c:	c1 ea 08             	shr    $0x8,%edx
c010784f:	09 f2                	or     %esi,%edx
c0107851:	c1 ea 10             	shr    $0x10,%edx
c0107854:	09 da                	or     %ebx,%edx
c0107856:	d1 ea                	shr    %edx
c0107858:	23 55 dc             	and    -0x24(%ebp),%edx
c010785b:	85 d2                	test   %edx,%edx
c010785d:	0f 84 de 00 00 00    	je     c0107941 <segment_check+0x3d9>
c0107863:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107866:	d1 ea                	shr    %edx
c0107868:	0b 55 dc             	or     -0x24(%ebp),%edx
c010786b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010786e:	d1 e9                	shr    %ecx
c0107870:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0107873:	c1 e9 02             	shr    $0x2,%ecx
c0107876:	89 d3                	mov    %edx,%ebx
c0107878:	09 cb                	or     %ecx,%ebx
c010787a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010787d:	d1 ea                	shr    %edx
c010787f:	0b 55 dc             	or     -0x24(%ebp),%edx
c0107882:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0107885:	d1 e9                	shr    %ecx
c0107887:	0b 4d dc             	or     -0x24(%ebp),%ecx
c010788a:	c1 e9 02             	shr    $0x2,%ecx
c010788d:	09 ca                	or     %ecx,%edx
c010788f:	c1 ea 04             	shr    $0x4,%edx
c0107892:	09 d3                	or     %edx,%ebx
c0107894:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107897:	d1 ea                	shr    %edx
c0107899:	0b 55 dc             	or     -0x24(%ebp),%edx
c010789c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010789f:	d1 e9                	shr    %ecx
c01078a1:	0b 4d dc             	or     -0x24(%ebp),%ecx
c01078a4:	c1 e9 02             	shr    $0x2,%ecx
c01078a7:	89 d6                	mov    %edx,%esi
c01078a9:	09 ce                	or     %ecx,%esi
c01078ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01078ae:	d1 ea                	shr    %edx
c01078b0:	0b 55 dc             	or     -0x24(%ebp),%edx
c01078b3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01078b6:	d1 e9                	shr    %ecx
c01078b8:	0b 4d dc             	or     -0x24(%ebp),%ecx
c01078bb:	c1 e9 02             	shr    $0x2,%ecx
c01078be:	09 ca                	or     %ecx,%edx
c01078c0:	c1 ea 04             	shr    $0x4,%edx
c01078c3:	09 f2                	or     %esi,%edx
c01078c5:	c1 ea 08             	shr    $0x8,%edx
c01078c8:	09 d3                	or     %edx,%ebx
c01078ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01078cd:	d1 ea                	shr    %edx
c01078cf:	0b 55 dc             	or     -0x24(%ebp),%edx
c01078d2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01078d5:	d1 e9                	shr    %ecx
c01078d7:	0b 4d dc             	or     -0x24(%ebp),%ecx
c01078da:	c1 e9 02             	shr    $0x2,%ecx
c01078dd:	89 d6                	mov    %edx,%esi
c01078df:	09 ce                	or     %ecx,%esi
c01078e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01078e4:	d1 ea                	shr    %edx
c01078e6:	0b 55 dc             	or     -0x24(%ebp),%edx
c01078e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01078ec:	d1 e9                	shr    %ecx
c01078ee:	0b 4d dc             	or     -0x24(%ebp),%ecx
c01078f1:	c1 e9 02             	shr    $0x2,%ecx
c01078f4:	09 ca                	or     %ecx,%edx
c01078f6:	c1 ea 04             	shr    $0x4,%edx
c01078f9:	09 d6                	or     %edx,%esi
c01078fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01078fe:	d1 ea                	shr    %edx
c0107900:	0b 55 dc             	or     -0x24(%ebp),%edx
c0107903:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0107906:	d1 e9                	shr    %ecx
c0107908:	0b 4d dc             	or     -0x24(%ebp),%ecx
c010790b:	c1 e9 02             	shr    $0x2,%ecx
c010790e:	89 d7                	mov    %edx,%edi
c0107910:	09 cf                	or     %ecx,%edi
c0107912:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107915:	d1 ea                	shr    %edx
c0107917:	0b 55 dc             	or     -0x24(%ebp),%edx
c010791a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010791d:	d1 e9                	shr    %ecx
c010791f:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0107922:	c1 e9 02             	shr    $0x2,%ecx
c0107925:	09 ca                	or     %ecx,%edx
c0107927:	c1 ea 04             	shr    $0x4,%edx
c010792a:	09 fa                	or     %edi,%edx
c010792c:	c1 ea 08             	shr    $0x8,%edx
c010792f:	09 f2                	or     %esi,%edx
c0107931:	c1 ea 10             	shr    $0x10,%edx
c0107934:	09 da                	or     %ebx,%edx
c0107936:	d1 ea                	shr    %edx
c0107938:	f7 d2                	not    %edx
c010793a:	89 d7                	mov    %edx,%edi
c010793c:	23 7d dc             	and    -0x24(%ebp),%edi
c010793f:	eb 03                	jmp    c0107944 <segment_check+0x3dc>
c0107941:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0107944:	ba 00 00 00 00       	mov    $0x0,%edx
c0107949:	f7 f7                	div    %edi
c010794b:	01 45 e4             	add    %eax,-0x1c(%ebp)
c010794e:	eb 66                	jmp    c01079b6 <segment_check+0x44e>
        else if (block < buddy_virtual_size)
c0107950:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c0107955:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0107958:	73 5c                	jae    c01079b6 <segment_check+0x44e>
            assert(buddy_segment[block] == (buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)]));
c010795a:	a1 5c e9 11 c0       	mov    0xc011e95c,%eax
c010795f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107962:	c1 e2 02             	shl    $0x2,%edx
c0107965:	01 d0                	add    %edx,%eax
c0107967:	8b 00                	mov    (%eax),%eax
c0107969:	8b 15 5c e9 11 c0    	mov    0xc011e95c,%edx
c010796f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0107972:	c1 e1 03             	shl    $0x3,%ecx
c0107975:	01 ca                	add    %ecx,%edx
c0107977:	8b 0a                	mov    (%edx),%ecx
c0107979:	8b 15 5c e9 11 c0    	mov    0xc011e95c,%edx
c010797f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
c0107982:	c1 e3 03             	shl    $0x3,%ebx
c0107985:	83 c3 04             	add    $0x4,%ebx
c0107988:	01 da                	add    %ebx,%edx
c010798a:	8b 12                	mov    (%edx),%edx
c010798c:	09 ca                	or     %ecx,%edx
c010798e:	39 d0                	cmp    %edx,%eax
c0107990:	74 24                	je     c01079b6 <segment_check+0x44e>
c0107992:	c7 44 24 0c c4 ac 10 	movl   $0xc010acc4,0xc(%esp)
c0107999:	c0 
c010799a:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c01079a1:	c0 
c01079a2:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01079a9:	00 
c01079aa:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c01079b1:	e8 32 8a ff ff       	call   c01003e8 <__panic>
    for (block = BUDDY_ROOT; block < (buddy_virtual_size<<1); block++)
c01079b6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01079ba:	a1 50 e9 11 c0       	mov    0xc011e950,%eax
c01079bf:	01 c0                	add    %eax,%eax
c01079c1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01079c4:	0f 87 c1 fb ff ff    	ja     c010758b <segment_check+0x23>
    assert(total == nr_free_pages());
c01079ca:	e8 5a b3 ff ff       	call   c0102d29 <nr_free_pages>
c01079cf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
c01079d2:	74 24                	je     c01079f8 <segment_check+0x490>
c01079d4:	c7 44 24 0c 23 ad 10 	movl   $0xc010ad23,0xc(%esp)
c01079db:	c0 
c01079dc:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c01079e3:	c0 
c01079e4:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01079eb:	00 
c01079ec:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c01079f3:	e8 f0 89 ff ff       	call   c01003e8 <__panic>

    // Check free list 
    total = 0, count = 0;
c01079f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01079ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    list_entry_t *le = &free_list;
c0107a06:	c7 45 d8 78 e9 11 c0 	movl   $0xc011e978,-0x28(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0107a0d:	eb 16                	jmp    c0107a25 <segment_check+0x4bd>
        struct Page *p = le2page(le, page_link);
c0107a0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107a12:	83 e8 0c             	sub    $0xc,%eax
c0107a15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count ++, total += p->property;
c0107a18:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
c0107a1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107a1f:	8b 40 08             	mov    0x8(%eax),%eax
c0107a22:	01 45 e4             	add    %eax,-0x1c(%ebp)
c0107a25:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107a28:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return listelm->next;
c0107a2b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107a2e:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0107a31:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107a34:	81 7d d8 78 e9 11 c0 	cmpl   $0xc011e978,-0x28(%ebp)
c0107a3b:	75 d2                	jne    c0107a0f <segment_check+0x4a7>
    }
    assert(total == nr_free_pages());
c0107a3d:	e8 e7 b2 ff ff       	call   c0102d29 <nr_free_pages>
c0107a42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
c0107a45:	74 24                	je     c0107a6b <segment_check+0x503>
c0107a47:	c7 44 24 0c 23 ad 10 	movl   $0xc010ad23,0xc(%esp)
c0107a4e:	c0 
c0107a4f:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107a56:	c0 
c0107a57:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0107a5e:	00 
c0107a5f:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107a66:	e8 7d 89 ff ff       	call   c01003e8 <__panic>

}
c0107a6b:	83 c4 4c             	add    $0x4c,%esp
c0107a6e:	5b                   	pop    %ebx
c0107a6f:	5e                   	pop    %esi
c0107a70:	5f                   	pop    %edi
c0107a71:	5d                   	pop    %ebp
c0107a72:	c3                   	ret    

c0107a73 <alloc_check>:

static void
alloc_check(void) {
c0107a73:	55                   	push   %ebp
c0107a74:	89 e5                	mov    %esp,%ebp
c0107a76:	83 ec 58             	sub    $0x58,%esp

    // Build buddy system for test
    size_t buddy_physical_size_store = buddy_physical_size;
c0107a79:	a1 4c e9 11 c0       	mov    0xc011e94c,%eax
c0107a7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    struct Page *tmp1;
    for (tmp1 = buddy_physical; tmp1 < buddy_physical + 1026; tmp1++)
c0107a81:	a1 60 e9 11 c0       	mov    0xc011e960,%eax
c0107a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a89:	eb 1d                	jmp    c0107aa8 <alloc_check+0x35>
        SetPageReserved(tmp1);
c0107a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a8e:	83 c0 04             	add    $0x4,%eax
c0107a91:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c0107a98:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0107a9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107a9e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107aa1:	0f ab 10             	bts    %edx,(%eax)
    for (tmp1 = buddy_physical; tmp1 < buddy_physical + 1026; tmp1++)
c0107aa4:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0107aa8:	a1 60 e9 11 c0       	mov    0xc011e960,%eax
c0107aad:	05 28 50 00 00       	add    $0x5028,%eax
c0107ab2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107ab5:	77 d4                	ja     c0107a8b <alloc_check+0x18>
    buddy_init();
c0107ab7:	e8 d5 d6 ff ff       	call   c0105191 <buddy_init>
    buddy_init_memmap(buddy_physical, 1026);
c0107abc:	a1 60 e9 11 c0       	mov    0xc011e960,%eax
c0107ac1:	c7 44 24 04 02 04 00 	movl   $0x402,0x4(%esp)
c0107ac8:	00 
c0107ac9:	89 04 24             	mov    %eax,(%esp)
c0107acc:	e8 ed d6 ff ff       	call   c01051be <buddy_init_memmap>

    // Check allocation
    struct Page *p0, *p1, *p2, *p3;
    p0 = p1 = p2 = NULL;
c0107ad1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0107ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107adb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107ae1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0107ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107aeb:	e8 cf b1 ff ff       	call   c0102cbf <alloc_pages>
c0107af0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107af3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107af7:	75 24                	jne    c0107b1d <alloc_check+0xaa>
c0107af9:	c7 44 24 0c 3c ad 10 	movl   $0xc010ad3c,0xc(%esp)
c0107b00:	c0 
c0107b01:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107b08:	c0 
c0107b09:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0107b10:	00 
c0107b11:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107b18:	e8 cb 88 ff ff       	call   c01003e8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0107b1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107b24:	e8 96 b1 ff ff       	call   c0102cbf <alloc_pages>
c0107b29:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107b2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107b30:	75 24                	jne    c0107b56 <alloc_check+0xe3>
c0107b32:	c7 44 24 0c 58 ad 10 	movl   $0xc010ad58,0xc(%esp)
c0107b39:	c0 
c0107b3a:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107b41:	c0 
c0107b42:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c0107b49:	00 
c0107b4a:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107b51:	e8 92 88 ff ff       	call   c01003e8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0107b56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107b5d:	e8 5d b1 ff ff       	call   c0102cbf <alloc_pages>
c0107b62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107b65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107b69:	75 24                	jne    c0107b8f <alloc_check+0x11c>
c0107b6b:	c7 44 24 0c 74 ad 10 	movl   $0xc010ad74,0xc(%esp)
c0107b72:	c0 
c0107b73:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107b7a:	c0 
c0107b7b:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0107b82:	00 
c0107b83:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107b8a:	e8 59 88 ff ff       	call   c01003e8 <__panic>
    assert((p3 = alloc_page()) != NULL);
c0107b8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107b96:	e8 24 b1 ff ff       	call   c0102cbf <alloc_pages>
c0107b9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107b9e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107ba2:	75 24                	jne    c0107bc8 <alloc_check+0x155>
c0107ba4:	c7 44 24 0c 90 ad 10 	movl   $0xc010ad90,0xc(%esp)
c0107bab:	c0 
c0107bac:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107bb3:	c0 
c0107bb4:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c0107bbb:	00 
c0107bbc:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107bc3:	e8 20 88 ff ff       	call   c01003e8 <__panic>

    assert(p0 + 1 == p1);
c0107bc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107bcb:	83 c0 14             	add    $0x14,%eax
c0107bce:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107bd1:	74 24                	je     c0107bf7 <alloc_check+0x184>
c0107bd3:	c7 44 24 0c ac ad 10 	movl   $0xc010adac,0xc(%esp)
c0107bda:	c0 
c0107bdb:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107be2:	c0 
c0107be3:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0107bea:	00 
c0107beb:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107bf2:	e8 f1 87 ff ff       	call   c01003e8 <__panic>
    assert(p1 + 1 == p2);
c0107bf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107bfa:	83 c0 14             	add    $0x14,%eax
c0107bfd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
c0107c00:	74 24                	je     c0107c26 <alloc_check+0x1b3>
c0107c02:	c7 44 24 0c b9 ad 10 	movl   $0xc010adb9,0xc(%esp)
c0107c09:	c0 
c0107c0a:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107c11:	c0 
c0107c12:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0107c19:	00 
c0107c1a:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107c21:	e8 c2 87 ff ff       	call   c01003e8 <__panic>
    assert(p2 + 1 == p3);
c0107c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c29:	83 c0 14             	add    $0x14,%eax
c0107c2c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
c0107c2f:	74 24                	je     c0107c55 <alloc_check+0x1e2>
c0107c31:	c7 44 24 0c c6 ad 10 	movl   $0xc010adc6,0xc(%esp)
c0107c38:	c0 
c0107c39:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107c40:	c0 
c0107c41:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0107c48:	00 
c0107c49:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107c50:	e8 93 87 ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0 && page_ref(p3) == 0);
c0107c55:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107c58:	89 04 24             	mov    %eax,(%esp)
c0107c5b:	e8 d3 c7 ff ff       	call   c0104433 <page_ref>
c0107c60:	85 c0                	test   %eax,%eax
c0107c62:	75 2d                	jne    c0107c91 <alloc_check+0x21e>
c0107c64:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107c67:	89 04 24             	mov    %eax,(%esp)
c0107c6a:	e8 c4 c7 ff ff       	call   c0104433 <page_ref>
c0107c6f:	85 c0                	test   %eax,%eax
c0107c71:	75 1e                	jne    c0107c91 <alloc_check+0x21e>
c0107c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c76:	89 04 24             	mov    %eax,(%esp)
c0107c79:	e8 b5 c7 ff ff       	call   c0104433 <page_ref>
c0107c7e:	85 c0                	test   %eax,%eax
c0107c80:	75 0f                	jne    c0107c91 <alloc_check+0x21e>
c0107c82:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107c85:	89 04 24             	mov    %eax,(%esp)
c0107c88:	e8 a6 c7 ff ff       	call   c0104433 <page_ref>
c0107c8d:	85 c0                	test   %eax,%eax
c0107c8f:	74 24                	je     c0107cb5 <alloc_check+0x242>
c0107c91:	c7 44 24 0c d4 ad 10 	movl   $0xc010add4,0xc(%esp)
c0107c98:	c0 
c0107c99:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107ca0:	c0 
c0107ca1:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0107ca8:	00 
c0107ca9:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107cb0:	e8 33 87 ff ff       	call   c01003e8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0107cb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107cb8:	89 04 24             	mov    %eax,(%esp)
c0107cbb:	e8 5d c7 ff ff       	call   c010441d <page2pa>
c0107cc0:	8b 15 c0 e8 11 c0    	mov    0xc011e8c0,%edx
c0107cc6:	c1 e2 0c             	shl    $0xc,%edx
c0107cc9:	39 d0                	cmp    %edx,%eax
c0107ccb:	72 24                	jb     c0107cf1 <alloc_check+0x27e>
c0107ccd:	c7 44 24 0c 25 ae 10 	movl   $0xc010ae25,0xc(%esp)
c0107cd4:	c0 
c0107cd5:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107cdc:	c0 
c0107cdd:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c0107ce4:	00 
c0107ce5:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107cec:	e8 f7 86 ff ff       	call   c01003e8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0107cf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107cf4:	89 04 24             	mov    %eax,(%esp)
c0107cf7:	e8 21 c7 ff ff       	call   c010441d <page2pa>
c0107cfc:	8b 15 c0 e8 11 c0    	mov    0xc011e8c0,%edx
c0107d02:	c1 e2 0c             	shl    $0xc,%edx
c0107d05:	39 d0                	cmp    %edx,%eax
c0107d07:	72 24                	jb     c0107d2d <alloc_check+0x2ba>
c0107d09:	c7 44 24 0c 42 ae 10 	movl   $0xc010ae42,0xc(%esp)
c0107d10:	c0 
c0107d11:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107d18:	c0 
c0107d19:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c0107d20:	00 
c0107d21:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107d28:	e8 bb 86 ff ff       	call   c01003e8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0107d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d30:	89 04 24             	mov    %eax,(%esp)
c0107d33:	e8 e5 c6 ff ff       	call   c010441d <page2pa>
c0107d38:	8b 15 c0 e8 11 c0    	mov    0xc011e8c0,%edx
c0107d3e:	c1 e2 0c             	shl    $0xc,%edx
c0107d41:	39 d0                	cmp    %edx,%eax
c0107d43:	72 24                	jb     c0107d69 <alloc_check+0x2f6>
c0107d45:	c7 44 24 0c 5f ae 10 	movl   $0xc010ae5f,0xc(%esp)
c0107d4c:	c0 
c0107d4d:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107d54:	c0 
c0107d55:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0107d5c:	00 
c0107d5d:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107d64:	e8 7f 86 ff ff       	call   c01003e8 <__panic>
    assert(page2pa(p3) < npage * PGSIZE);
c0107d69:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107d6c:	89 04 24             	mov    %eax,(%esp)
c0107d6f:	e8 a9 c6 ff ff       	call   c010441d <page2pa>
c0107d74:	8b 15 c0 e8 11 c0    	mov    0xc011e8c0,%edx
c0107d7a:	c1 e2 0c             	shl    $0xc,%edx
c0107d7d:	39 d0                	cmp    %edx,%eax
c0107d7f:	72 24                	jb     c0107da5 <alloc_check+0x332>
c0107d81:	c7 44 24 0c 7c ae 10 	movl   $0xc010ae7c,0xc(%esp)
c0107d88:	c0 
c0107d89:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107d90:	c0 
c0107d91:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0107d98:	00 
c0107d99:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107da0:	e8 43 86 ff ff       	call   c01003e8 <__panic>

    list_entry_t *le = &free_list;
c0107da5:	c7 45 f0 78 e9 11 c0 	movl   $0xc011e978,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0107dac:	eb 3f                	jmp    c0107ded <alloc_check+0x37a>
        struct Page *p = le2page(le, page_link);
c0107dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107db1:	83 e8 0c             	sub    $0xc,%eax
c0107db4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(buddy_alloc_pages(p->property) != NULL);
c0107db7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107dba:	8b 40 08             	mov    0x8(%eax),%eax
c0107dbd:	89 04 24             	mov    %eax,(%esp)
c0107dc0:	e8 d0 d4 ff ff       	call   c0105295 <buddy_alloc_pages>
c0107dc5:	85 c0                	test   %eax,%eax
c0107dc7:	75 24                	jne    c0107ded <alloc_check+0x37a>
c0107dc9:	c7 44 24 0c 9c ae 10 	movl   $0xc010ae9c,0xc(%esp)
c0107dd0:	c0 
c0107dd1:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107dd8:	c0 
c0107dd9:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c0107de0:	00 
c0107de1:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107de8:	e8 fb 85 ff ff       	call   c01003e8 <__panic>
c0107ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107df0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0107df3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107df6:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0107df9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107dfc:	81 7d f0 78 e9 11 c0 	cmpl   $0xc011e978,-0x10(%ebp)
c0107e03:	75 a9                	jne    c0107dae <alloc_check+0x33b>
    }

    assert(alloc_page() == NULL);
c0107e05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107e0c:	e8 ae ae ff ff       	call   c0102cbf <alloc_pages>
c0107e11:	85 c0                	test   %eax,%eax
c0107e13:	74 24                	je     c0107e39 <alloc_check+0x3c6>
c0107e15:	c7 44 24 0c c3 ae 10 	movl   $0xc010aec3,0xc(%esp)
c0107e1c:	c0 
c0107e1d:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107e24:	c0 
c0107e25:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
c0107e2c:	00 
c0107e2d:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107e34:	e8 af 85 ff ff       	call   c01003e8 <__panic>

    // Check release
    free_page(p0);
c0107e39:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107e40:	00 
c0107e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107e44:	89 04 24             	mov    %eax,(%esp)
c0107e47:	e8 ab ae ff ff       	call   c0102cf7 <free_pages>
    free_page(p1);
c0107e4c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107e53:	00 
c0107e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107e57:	89 04 24             	mov    %eax,(%esp)
c0107e5a:	e8 98 ae ff ff       	call   c0102cf7 <free_pages>
    free_page(p2);
c0107e5f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107e66:	00 
c0107e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e6a:	89 04 24             	mov    %eax,(%esp)
c0107e6d:	e8 85 ae ff ff       	call   c0102cf7 <free_pages>
    assert(nr_free == 3);
c0107e72:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
c0107e77:	83 f8 03             	cmp    $0x3,%eax
c0107e7a:	74 24                	je     c0107ea0 <alloc_check+0x42d>
c0107e7c:	c7 44 24 0c d8 ae 10 	movl   $0xc010aed8,0xc(%esp)
c0107e83:	c0 
c0107e84:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107e8b:	c0 
c0107e8c:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0107e93:	00 
c0107e94:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107e9b:	e8 48 85 ff ff       	call   c01003e8 <__panic>

    assert((p1 = alloc_page()) != NULL);
c0107ea0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107ea7:	e8 13 ae ff ff       	call   c0102cbf <alloc_pages>
c0107eac:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107eaf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107eb3:	75 24                	jne    c0107ed9 <alloc_check+0x466>
c0107eb5:	c7 44 24 0c 58 ad 10 	movl   $0xc010ad58,0xc(%esp)
c0107ebc:	c0 
c0107ebd:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107ec4:	c0 
c0107ec5:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
c0107ecc:	00 
c0107ecd:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107ed4:	e8 0f 85 ff ff       	call   c01003e8 <__panic>
    assert((p0 = alloc_pages(2)) != NULL);
c0107ed9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0107ee0:	e8 da ad ff ff       	call   c0102cbf <alloc_pages>
c0107ee5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107ee8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107eec:	75 24                	jne    c0107f12 <alloc_check+0x49f>
c0107eee:	c7 44 24 0c e5 ae 10 	movl   $0xc010aee5,0xc(%esp)
c0107ef5:	c0 
c0107ef6:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107efd:	c0 
c0107efe:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
c0107f05:	00 
c0107f06:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107f0d:	e8 d6 84 ff ff       	call   c01003e8 <__panic>
    assert(p0 + 2 == p1);
c0107f12:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107f15:	83 c0 28             	add    $0x28,%eax
c0107f18:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107f1b:	74 24                	je     c0107f41 <alloc_check+0x4ce>
c0107f1d:	c7 44 24 0c 03 af 10 	movl   $0xc010af03,0xc(%esp)
c0107f24:	c0 
c0107f25:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107f2c:	c0 
c0107f2d:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
c0107f34:	00 
c0107f35:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107f3c:	e8 a7 84 ff ff       	call   c01003e8 <__panic>

    assert(alloc_page() == NULL);
c0107f41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f48:	e8 72 ad ff ff       	call   c0102cbf <alloc_pages>
c0107f4d:	85 c0                	test   %eax,%eax
c0107f4f:	74 24                	je     c0107f75 <alloc_check+0x502>
c0107f51:	c7 44 24 0c c3 ae 10 	movl   $0xc010aec3,0xc(%esp)
c0107f58:	c0 
c0107f59:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107f60:	c0 
c0107f61:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c0107f68:	00 
c0107f69:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107f70:	e8 73 84 ff ff       	call   c01003e8 <__panic>

    free_pages(p0, 2);
c0107f75:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0107f7c:	00 
c0107f7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107f80:	89 04 24             	mov    %eax,(%esp)
c0107f83:	e8 6f ad ff ff       	call   c0102cf7 <free_pages>
    free_page(p1);
c0107f88:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107f8f:	00 
c0107f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f93:	89 04 24             	mov    %eax,(%esp)
c0107f96:	e8 5c ad ff ff       	call   c0102cf7 <free_pages>
    free_page(p3);
c0107f9b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107fa2:	00 
c0107fa3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107fa6:	89 04 24             	mov    %eax,(%esp)
c0107fa9:	e8 49 ad ff ff       	call   c0102cf7 <free_pages>

    struct Page *p;
    assert((p = alloc_pages(4)) == p0);
c0107fae:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0107fb5:	e8 05 ad ff ff       	call   c0102cbf <alloc_pages>
c0107fba:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107fbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107fc0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0107fc3:	74 24                	je     c0107fe9 <alloc_check+0x576>
c0107fc5:	c7 44 24 0c 10 af 10 	movl   $0xc010af10,0xc(%esp)
c0107fcc:	c0 
c0107fcd:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0107fd4:	c0 
c0107fd5:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0107fdc:	00 
c0107fdd:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0107fe4:	e8 ff 83 ff ff       	call   c01003e8 <__panic>
    assert(alloc_page() == NULL);
c0107fe9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107ff0:	e8 ca ac ff ff       	call   c0102cbf <alloc_pages>
c0107ff5:	85 c0                	test   %eax,%eax
c0107ff7:	74 24                	je     c010801d <alloc_check+0x5aa>
c0107ff9:	c7 44 24 0c c3 ae 10 	movl   $0xc010aec3,0xc(%esp)
c0108000:	c0 
c0108001:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0108008:	c0 
c0108009:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
c0108010:	00 
c0108011:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0108018:	e8 cb 83 ff ff       	call   c01003e8 <__panic>

    assert(nr_free == 0);
c010801d:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
c0108022:	85 c0                	test   %eax,%eax
c0108024:	74 24                	je     c010804a <alloc_check+0x5d7>
c0108026:	c7 44 24 0c 2b af 10 	movl   $0xc010af2b,0xc(%esp)
c010802d:	c0 
c010802e:	c7 44 24 08 96 ab 10 	movl   $0xc010ab96,0x8(%esp)
c0108035:	c0 
c0108036:	c7 44 24 04 55 01 00 	movl   $0x155,0x4(%esp)
c010803d:	00 
c010803e:	c7 04 24 ab ab 10 c0 	movl   $0xc010abab,(%esp)
c0108045:	e8 9e 83 ff ff       	call   c01003e8 <__panic>

    // Restore buddy system
    struct Page *tmp2;
    for (tmp2 = buddy_physical; tmp2 < buddy_physical + buddy_physical_size_store; tmp2++)
c010804a:	a1 60 e9 11 c0       	mov    0xc011e960,%eax
c010804f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108052:	eb 1d                	jmp    c0108071 <alloc_check+0x5fe>
        SetPageReserved(tmp2);
c0108054:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108057:	83 c0 04             	add    $0x4,%eax
c010805a:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c0108061:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0108064:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108067:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010806a:	0f ab 10             	bts    %edx,(%eax)
    for (tmp2 = buddy_physical; tmp2 < buddy_physical + buddy_physical_size_store; tmp2++)
c010806d:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c0108071:	8b 0d 60 e9 11 c0    	mov    0xc011e960,%ecx
c0108077:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010807a:	89 d0                	mov    %edx,%eax
c010807c:	c1 e0 02             	shl    $0x2,%eax
c010807f:	01 d0                	add    %edx,%eax
c0108081:	c1 e0 02             	shl    $0x2,%eax
c0108084:	01 c8                	add    %ecx,%eax
c0108086:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108089:	77 c9                	ja     c0108054 <alloc_check+0x5e1>
    buddy_init();
c010808b:	e8 01 d1 ff ff       	call   c0105191 <buddy_init>
    buddy_init_memmap(buddy_physical, buddy_physical_size_store);
c0108090:	a1 60 e9 11 c0       	mov    0xc011e960,%eax
c0108095:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108098:	89 54 24 04          	mov    %edx,0x4(%esp)
c010809c:	89 04 24             	mov    %eax,(%esp)
c010809f:	e8 1a d1 ff ff       	call   c01051be <buddy_init_memmap>

}
c01080a4:	c9                   	leave  
c01080a5:	c3                   	ret    

c01080a6 <default_check>:

static void
default_check(void) {
c01080a6:	55                   	push   %ebp
c01080a7:	89 e5                	mov    %esp,%ebp
c01080a9:	83 ec 08             	sub    $0x8,%esp

    // Check buddy system
    macro_check();
c01080ac:	e8 23 f2 ff ff       	call   c01072d4 <macro_check>
    size_check();
c01080b1:	e8 6b f3 ff ff       	call   c0107421 <size_check>
    segment_check();
c01080b6:	e8 ad f4 ff ff       	call   c0107568 <segment_check>
    alloc_check();
c01080bb:	e8 b3 f9 ff ff       	call   c0107a73 <alloc_check>
    
}
c01080c0:	c9                   	leave  
c01080c1:	c3                   	ret    

c01080c2 <page2ppn>:
page2ppn(struct Page *page) {
c01080c2:	55                   	push   %ebp
c01080c3:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01080c5:	8b 55 08             	mov    0x8(%ebp),%edx
c01080c8:	a1 74 e9 11 c0       	mov    0xc011e974,%eax
c01080cd:	29 c2                	sub    %eax,%edx
c01080cf:	89 d0                	mov    %edx,%eax
c01080d1:	c1 f8 02             	sar    $0x2,%eax
c01080d4:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01080da:	5d                   	pop    %ebp
c01080db:	c3                   	ret    

c01080dc <page2pa>:
page2pa(struct Page *page) {
c01080dc:	55                   	push   %ebp
c01080dd:	89 e5                	mov    %esp,%ebp
c01080df:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01080e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01080e5:	89 04 24             	mov    %eax,(%esp)
c01080e8:	e8 d5 ff ff ff       	call   c01080c2 <page2ppn>
c01080ed:	c1 e0 0c             	shl    $0xc,%eax
}
c01080f0:	c9                   	leave  
c01080f1:	c3                   	ret    

c01080f2 <page_ref>:
page_ref(struct Page *page) {
c01080f2:	55                   	push   %ebp
c01080f3:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01080f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01080f8:	8b 00                	mov    (%eax),%eax
}
c01080fa:	5d                   	pop    %ebp
c01080fb:	c3                   	ret    

c01080fc <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01080fc:	55                   	push   %ebp
c01080fd:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01080ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0108102:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108105:	89 10                	mov    %edx,(%eax)
}
c0108107:	5d                   	pop    %ebp
c0108108:	c3                   	ret    

c0108109 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0108109:	55                   	push   %ebp
c010810a:	89 e5                	mov    %esp,%ebp
c010810c:	83 ec 10             	sub    $0x10,%esp
c010810f:	c7 45 fc 78 e9 11 c0 	movl   $0xc011e978,-0x4(%ebp)
    elm->prev = elm->next = elm;
c0108116:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108119:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010811c:	89 50 04             	mov    %edx,0x4(%eax)
c010811f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108122:	8b 50 04             	mov    0x4(%eax),%edx
c0108125:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108128:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010812a:	c7 05 80 e9 11 c0 00 	movl   $0x0,0xc011e980
c0108131:	00 00 00 
}
c0108134:	c9                   	leave  
c0108135:	c3                   	ret    

c0108136 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0108136:	55                   	push   %ebp
c0108137:	89 e5                	mov    %esp,%ebp
c0108139:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010813c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108140:	75 24                	jne    c0108166 <default_init_memmap+0x30>
c0108142:	c7 44 24 0c 68 af 10 	movl   $0xc010af68,0xc(%esp)
c0108149:	c0 
c010814a:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108151:	c0 
c0108152:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0108159:	00 
c010815a:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108161:	e8 82 82 ff ff       	call   c01003e8 <__panic>
    struct Page *p = base;
c0108166:	8b 45 08             	mov    0x8(%ebp),%eax
c0108169:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010816c:	eb 7d                	jmp    c01081eb <default_init_memmap+0xb5>
        assert(PageReserved(p));
c010816e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108171:	83 c0 04             	add    $0x4,%eax
c0108174:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010817b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010817e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108181:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108184:	0f a3 10             	bt     %edx,(%eax)
c0108187:	19 c0                	sbb    %eax,%eax
c0108189:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010818c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108190:	0f 95 c0             	setne  %al
c0108193:	0f b6 c0             	movzbl %al,%eax
c0108196:	85 c0                	test   %eax,%eax
c0108198:	75 24                	jne    c01081be <default_init_memmap+0x88>
c010819a:	c7 44 24 0c 99 af 10 	movl   $0xc010af99,0xc(%esp)
c01081a1:	c0 
c01081a2:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01081a9:	c0 
c01081aa:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01081b1:	00 
c01081b2:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01081b9:	e8 2a 82 ff ff       	call   c01003e8 <__panic>
        p->flags = p->property = 0;
c01081be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01081c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01081c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01081cb:	8b 50 08             	mov    0x8(%eax),%edx
c01081ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01081d1:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01081d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01081db:	00 
c01081dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01081df:	89 04 24             	mov    %eax,(%esp)
c01081e2:	e8 15 ff ff ff       	call   c01080fc <set_page_ref>
    for (; p != base + n; p ++) {
c01081e7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01081eb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01081ee:	89 d0                	mov    %edx,%eax
c01081f0:	c1 e0 02             	shl    $0x2,%eax
c01081f3:	01 d0                	add    %edx,%eax
c01081f5:	c1 e0 02             	shl    $0x2,%eax
c01081f8:	89 c2                	mov    %eax,%edx
c01081fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01081fd:	01 d0                	add    %edx,%eax
c01081ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0108202:	0f 85 66 ff ff ff    	jne    c010816e <default_init_memmap+0x38>
    }
    base->property = n;
c0108208:	8b 45 08             	mov    0x8(%ebp),%eax
c010820b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010820e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0108211:	8b 45 08             	mov    0x8(%ebp),%eax
c0108214:	83 c0 04             	add    $0x4,%eax
c0108217:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010821e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0108221:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108224:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108227:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c010822a:	8b 15 80 e9 11 c0    	mov    0xc011e980,%edx
c0108230:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108233:	01 d0                	add    %edx,%eax
c0108235:	a3 80 e9 11 c0       	mov    %eax,0xc011e980
    list_add_before(&free_list, &(base->page_link));
c010823a:	8b 45 08             	mov    0x8(%ebp),%eax
c010823d:	83 c0 0c             	add    $0xc,%eax
c0108240:	c7 45 dc 78 e9 11 c0 	movl   $0xc011e978,-0x24(%ebp)
c0108247:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_add(elm, listelm->prev, listelm);
c010824a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010824d:	8b 00                	mov    (%eax),%eax
c010824f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108252:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108255:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0108258:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010825b:	89 45 cc             	mov    %eax,-0x34(%ebp)
    prev->next = next->prev = elm;
c010825e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108261:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108264:	89 10                	mov    %edx,(%eax)
c0108266:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108269:	8b 10                	mov    (%eax),%edx
c010826b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010826e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108271:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108274:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108277:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010827a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010827d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108280:	89 10                	mov    %edx,(%eax)
}
c0108282:	c9                   	leave  
c0108283:	c3                   	ret    

c0108284 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0108284:	55                   	push   %ebp
c0108285:	89 e5                	mov    %esp,%ebp
c0108287:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);//判断n是否大于0
c010828a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010828e:	75 24                	jne    c01082b4 <default_alloc_pages+0x30>
c0108290:	c7 44 24 0c 68 af 10 	movl   $0xc010af68,0xc(%esp)
c0108297:	c0 
c0108298:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c010829f:	c0 
c01082a0:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c01082a7:	00 
c01082a8:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01082af:	e8 34 81 ff ff       	call   c01003e8 <__panic>
    if (n > nr_free) {//需要分配页的个数小于空闲页的总数,直接返回
c01082b4:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
c01082b9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01082bc:	73 0a                	jae    c01082c8 <default_alloc_pages+0x44>
        return NULL;
c01082be:	b8 00 00 00 00       	mov    $0x0,%eax
c01082c3:	e9 3d 01 00 00       	jmp    c0108405 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
c01082c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01082cf:	c7 45 f0 78 e9 11 c0 	movl   $0xc011e978,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c01082d6:	eb 1c                	jmp    c01082f4 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c01082d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082db:	83 e8 0c             	sub    $0xc,%eax
c01082de:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01082e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01082e4:	8b 40 08             	mov    0x8(%eax),%eax
c01082e7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01082ea:	72 08                	jb     c01082f4 <default_alloc_pages+0x70>
            page = p;
c01082ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01082ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01082f2:	eb 18                	jmp    c010830c <default_alloc_pages+0x88>
c01082f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01082fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082fd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0108300:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108303:	81 7d f0 78 e9 11 c0 	cmpl   $0xc011e978,-0x10(%ebp)
c010830a:	75 cc                	jne    c01082d8 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c010830c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108310:	0f 84 ec 00 00 00    	je     c0108402 <default_alloc_pages+0x17e>
        if (page->property > n) {
c0108316:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108319:	8b 40 08             	mov    0x8(%eax),%eax
c010831c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010831f:	0f 86 8c 00 00 00    	jbe    c01083b1 <default_alloc_pages+0x12d>
            struct Page *p = page + n;
c0108325:	8b 55 08             	mov    0x8(%ebp),%edx
c0108328:	89 d0                	mov    %edx,%eax
c010832a:	c1 e0 02             	shl    $0x2,%eax
c010832d:	01 d0                	add    %edx,%eax
c010832f:	c1 e0 02             	shl    $0x2,%eax
c0108332:	89 c2                	mov    %eax,%edx
c0108334:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108337:	01 d0                	add    %edx,%eax
c0108339:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c010833c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010833f:	8b 40 08             	mov    0x8(%eax),%eax
c0108342:	2b 45 08             	sub    0x8(%ebp),%eax
c0108345:	89 c2                	mov    %eax,%edx
c0108347:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010834a:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c010834d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108350:	83 c0 04             	add    $0x4,%eax
c0108353:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010835a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010835d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108360:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108363:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0108366:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108369:	83 c0 0c             	add    $0xc,%eax
c010836c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010836f:	83 c2 0c             	add    $0xc,%edx
c0108372:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0108375:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0108378:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010837b:	8b 40 04             	mov    0x4(%eax),%eax
c010837e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108381:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0108384:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108387:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010838a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c010838d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108390:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108393:	89 10                	mov    %edx,(%eax)
c0108395:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108398:	8b 10                	mov    (%eax),%edx
c010839a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010839d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01083a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01083a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01083a6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01083a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01083ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01083af:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c01083b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083b4:	83 c0 0c             	add    $0xc,%eax
c01083b7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c01083ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01083bd:	8b 40 04             	mov    0x4(%eax),%eax
c01083c0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01083c3:	8b 12                	mov    (%edx),%edx
c01083c5:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01083c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c01083cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01083ce:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01083d1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01083d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01083d7:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01083da:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c01083dc:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
c01083e1:	2b 45 08             	sub    0x8(%ebp),%eax
c01083e4:	a3 80 e9 11 c0       	mov    %eax,0xc011e980
        ClearPageProperty(page);
c01083e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083ec:	83 c0 04             	add    $0x4,%eax
c01083ef:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01083f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01083f9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01083fc:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01083ff:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0108402:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108405:	c9                   	leave  
c0108406:	c3                   	ret    

c0108407 <default_free_pages>:
    

static void
default_free_pages(struct Page *base, size_t n) {
c0108407:	55                   	push   %ebp
c0108408:	89 e5                	mov    %esp,%ebp
c010840a:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0108410:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108414:	75 24                	jne    c010843a <default_free_pages+0x33>
c0108416:	c7 44 24 0c 68 af 10 	movl   $0xc010af68,0xc(%esp)
c010841d:	c0 
c010841e:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108425:	c0 
c0108426:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c010842d:	00 
c010842e:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108435:	e8 ae 7f ff ff       	call   c01003e8 <__panic>
    struct Page *p = base;
c010843a:	8b 45 08             	mov    0x8(%ebp),%eax
c010843d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0108440:	e9 9d 00 00 00       	jmp    c01084e2 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0108445:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108448:	83 c0 04             	add    $0x4,%eax
c010844b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0108452:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0108455:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108458:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010845b:	0f a3 10             	bt     %edx,(%eax)
c010845e:	19 c0                	sbb    %eax,%eax
c0108460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0108463:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108467:	0f 95 c0             	setne  %al
c010846a:	0f b6 c0             	movzbl %al,%eax
c010846d:	85 c0                	test   %eax,%eax
c010846f:	75 2c                	jne    c010849d <default_free_pages+0x96>
c0108471:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108474:	83 c0 04             	add    $0x4,%eax
c0108477:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010847e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0108481:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108484:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108487:	0f a3 10             	bt     %edx,(%eax)
c010848a:	19 c0                	sbb    %eax,%eax
c010848c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c010848f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0108493:	0f 95 c0             	setne  %al
c0108496:	0f b6 c0             	movzbl %al,%eax
c0108499:	85 c0                	test   %eax,%eax
c010849b:	74 24                	je     c01084c1 <default_free_pages+0xba>
c010849d:	c7 44 24 0c ac af 10 	movl   $0xc010afac,0xc(%esp)
c01084a4:	c0 
c01084a5:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01084ac:	c0 
c01084ad:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c01084b4:	00 
c01084b5:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01084bc:	e8 27 7f ff ff       	call   c01003e8 <__panic>
        p->flags = 0;
c01084c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01084cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01084d2:	00 
c01084d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084d6:	89 04 24             	mov    %eax,(%esp)
c01084d9:	e8 1e fc ff ff       	call   c01080fc <set_page_ref>
    for (; p != base + n; p ++) {
c01084de:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01084e2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01084e5:	89 d0                	mov    %edx,%eax
c01084e7:	c1 e0 02             	shl    $0x2,%eax
c01084ea:	01 d0                	add    %edx,%eax
c01084ec:	c1 e0 02             	shl    $0x2,%eax
c01084ef:	89 c2                	mov    %eax,%edx
c01084f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01084f4:	01 d0                	add    %edx,%eax
c01084f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01084f9:	0f 85 46 ff ff ff    	jne    c0108445 <default_free_pages+0x3e>
    }
    base->property = n;
c01084ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0108502:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108505:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0108508:	8b 45 08             	mov    0x8(%ebp),%eax
c010850b:	83 c0 04             	add    $0x4,%eax
c010850e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0108515:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0108518:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010851b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010851e:	0f ab 10             	bts    %edx,(%eax)
c0108521:	c7 45 cc 78 e9 11 c0 	movl   $0xc011e978,-0x34(%ebp)
    return listelm->next;
c0108528:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010852b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c010852e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0108531:	e9 08 01 00 00       	jmp    c010863e <default_free_pages+0x237>
        p = le2page(le, page_link);
c0108536:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108539:	83 e8 0c             	sub    $0xc,%eax
c010853c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010853f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108542:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0108545:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108548:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010854b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c010854e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108551:	8b 50 08             	mov    0x8(%eax),%edx
c0108554:	89 d0                	mov    %edx,%eax
c0108556:	c1 e0 02             	shl    $0x2,%eax
c0108559:	01 d0                	add    %edx,%eax
c010855b:	c1 e0 02             	shl    $0x2,%eax
c010855e:	89 c2                	mov    %eax,%edx
c0108560:	8b 45 08             	mov    0x8(%ebp),%eax
c0108563:	01 d0                	add    %edx,%eax
c0108565:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0108568:	75 5a                	jne    c01085c4 <default_free_pages+0x1bd>
            base->property += p->property;
c010856a:	8b 45 08             	mov    0x8(%ebp),%eax
c010856d:	8b 50 08             	mov    0x8(%eax),%edx
c0108570:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108573:	8b 40 08             	mov    0x8(%eax),%eax
c0108576:	01 c2                	add    %eax,%edx
c0108578:	8b 45 08             	mov    0x8(%ebp),%eax
c010857b:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c010857e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108581:	83 c0 04             	add    $0x4,%eax
c0108584:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010858b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010858e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0108591:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0108594:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0108597:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010859a:	83 c0 0c             	add    $0xc,%eax
c010859d:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c01085a0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01085a3:	8b 40 04             	mov    0x4(%eax),%eax
c01085a6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01085a9:	8b 12                	mov    (%edx),%edx
c01085ab:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01085ae:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
c01085b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01085b4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01085b7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01085ba:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01085bd:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01085c0:	89 10                	mov    %edx,(%eax)
c01085c2:	eb 7a                	jmp    c010863e <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c01085c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085c7:	8b 50 08             	mov    0x8(%eax),%edx
c01085ca:	89 d0                	mov    %edx,%eax
c01085cc:	c1 e0 02             	shl    $0x2,%eax
c01085cf:	01 d0                	add    %edx,%eax
c01085d1:	c1 e0 02             	shl    $0x2,%eax
c01085d4:	89 c2                	mov    %eax,%edx
c01085d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085d9:	01 d0                	add    %edx,%eax
c01085db:	3b 45 08             	cmp    0x8(%ebp),%eax
c01085de:	75 5e                	jne    c010863e <default_free_pages+0x237>
            p->property += base->property;
c01085e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085e3:	8b 50 08             	mov    0x8(%eax),%edx
c01085e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01085e9:	8b 40 08             	mov    0x8(%eax),%eax
c01085ec:	01 c2                	add    %eax,%edx
c01085ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085f1:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01085f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01085f7:	83 c0 04             	add    $0x4,%eax
c01085fa:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0108601:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0108604:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0108607:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010860a:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c010860d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108610:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0108613:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108616:	83 c0 0c             	add    $0xc,%eax
c0108619:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_del(listelm->prev, listelm->next);
c010861c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010861f:	8b 40 04             	mov    0x4(%eax),%eax
c0108622:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0108625:	8b 12                	mov    (%edx),%edx
c0108627:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c010862a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next;
c010862d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0108630:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0108633:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0108636:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0108639:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010863c:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c010863e:	81 7d f0 78 e9 11 c0 	cmpl   $0xc011e978,-0x10(%ebp)
c0108645:	0f 85 eb fe ff ff    	jne    c0108536 <default_free_pages+0x12f>
        }
    }
    nr_free += n;
c010864b:	8b 15 80 e9 11 c0    	mov    0xc011e980,%edx
c0108651:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108654:	01 d0                	add    %edx,%eax
c0108656:	a3 80 e9 11 c0       	mov    %eax,0xc011e980
c010865b:	c7 45 9c 78 e9 11 c0 	movl   $0xc011e978,-0x64(%ebp)
    return listelm->next;
c0108662:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0108665:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0108668:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c010866b:	eb 76                	jmp    c01086e3 <default_free_pages+0x2dc>
        p = le2page(le, page_link);
c010866d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108670:	83 e8 0c             	sub    $0xc,%eax
c0108673:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0108676:	8b 45 08             	mov    0x8(%ebp),%eax
c0108679:	8b 50 08             	mov    0x8(%eax),%edx
c010867c:	89 d0                	mov    %edx,%eax
c010867e:	c1 e0 02             	shl    $0x2,%eax
c0108681:	01 d0                	add    %edx,%eax
c0108683:	c1 e0 02             	shl    $0x2,%eax
c0108686:	89 c2                	mov    %eax,%edx
c0108688:	8b 45 08             	mov    0x8(%ebp),%eax
c010868b:	01 d0                	add    %edx,%eax
c010868d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0108690:	77 42                	ja     c01086d4 <default_free_pages+0x2cd>
            assert(base + base->property != p);
c0108692:	8b 45 08             	mov    0x8(%ebp),%eax
c0108695:	8b 50 08             	mov    0x8(%eax),%edx
c0108698:	89 d0                	mov    %edx,%eax
c010869a:	c1 e0 02             	shl    $0x2,%eax
c010869d:	01 d0                	add    %edx,%eax
c010869f:	c1 e0 02             	shl    $0x2,%eax
c01086a2:	89 c2                	mov    %eax,%edx
c01086a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01086a7:	01 d0                	add    %edx,%eax
c01086a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01086ac:	75 24                	jne    c01086d2 <default_free_pages+0x2cb>
c01086ae:	c7 44 24 0c d1 af 10 	movl   $0xc010afd1,0xc(%esp)
c01086b5:	c0 
c01086b6:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01086bd:	c0 
c01086be:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
c01086c5:	00 
c01086c6:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01086cd:	e8 16 7d ff ff       	call   c01003e8 <__panic>
            break;
c01086d2:	eb 18                	jmp    c01086ec <default_free_pages+0x2e5>
c01086d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086d7:	89 45 98             	mov    %eax,-0x68(%ebp)
c01086da:	8b 45 98             	mov    -0x68(%ebp),%eax
c01086dd:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c01086e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01086e3:	81 7d f0 78 e9 11 c0 	cmpl   $0xc011e978,-0x10(%ebp)
c01086ea:	75 81                	jne    c010866d <default_free_pages+0x266>
    }
    list_add_before(le, &(base->page_link));
c01086ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01086ef:	8d 50 0c             	lea    0xc(%eax),%edx
c01086f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086f5:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01086f8:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01086fb:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01086fe:	8b 00                	mov    (%eax),%eax
c0108700:	8b 55 90             	mov    -0x70(%ebp),%edx
c0108703:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0108706:	89 45 88             	mov    %eax,-0x78(%ebp)
c0108709:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010870c:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c010870f:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0108712:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0108715:	89 10                	mov    %edx,(%eax)
c0108717:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010871a:	8b 10                	mov    (%eax),%edx
c010871c:	8b 45 88             	mov    -0x78(%ebp),%eax
c010871f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108722:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0108725:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0108728:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010872b:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010872e:	8b 55 88             	mov    -0x78(%ebp),%edx
c0108731:	89 10                	mov    %edx,(%eax)
}
c0108733:	c9                   	leave  
c0108734:	c3                   	ret    

c0108735 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0108735:	55                   	push   %ebp
c0108736:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0108738:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
}
c010873d:	5d                   	pop    %ebp
c010873e:	c3                   	ret    

c010873f <basic_check>:

static void
basic_check(void) {
c010873f:	55                   	push   %ebp
c0108740:	89 e5                	mov    %esp,%ebp
c0108742:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0108745:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010874c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010874f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108752:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108755:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0108758:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010875f:	e8 5b a5 ff ff       	call   c0102cbf <alloc_pages>
c0108764:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108767:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010876b:	75 24                	jne    c0108791 <basic_check+0x52>
c010876d:	c7 44 24 0c ec af 10 	movl   $0xc010afec,0xc(%esp)
c0108774:	c0 
c0108775:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c010877c:	c0 
c010877d:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0108784:	00 
c0108785:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c010878c:	e8 57 7c ff ff       	call   c01003e8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0108791:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108798:	e8 22 a5 ff ff       	call   c0102cbf <alloc_pages>
c010879d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01087a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01087a4:	75 24                	jne    c01087ca <basic_check+0x8b>
c01087a6:	c7 44 24 0c 08 b0 10 	movl   $0xc010b008,0xc(%esp)
c01087ad:	c0 
c01087ae:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01087b5:	c0 
c01087b6:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c01087bd:	00 
c01087be:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01087c5:	e8 1e 7c ff ff       	call   c01003e8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01087ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01087d1:	e8 e9 a4 ff ff       	call   c0102cbf <alloc_pages>
c01087d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01087d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01087dd:	75 24                	jne    c0108803 <basic_check+0xc4>
c01087df:	c7 44 24 0c 24 b0 10 	movl   $0xc010b024,0xc(%esp)
c01087e6:	c0 
c01087e7:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01087ee:	c0 
c01087ef:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c01087f6:	00 
c01087f7:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01087fe:	e8 e5 7b ff ff       	call   c01003e8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0108803:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108806:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108809:	74 10                	je     c010881b <basic_check+0xdc>
c010880b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010880e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0108811:	74 08                	je     c010881b <basic_check+0xdc>
c0108813:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108816:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0108819:	75 24                	jne    c010883f <basic_check+0x100>
c010881b:	c7 44 24 0c 40 b0 10 	movl   $0xc010b040,0xc(%esp)
c0108822:	c0 
c0108823:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c010882a:	c0 
c010882b:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0108832:	00 
c0108833:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c010883a:	e8 a9 7b ff ff       	call   c01003e8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010883f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108842:	89 04 24             	mov    %eax,(%esp)
c0108845:	e8 a8 f8 ff ff       	call   c01080f2 <page_ref>
c010884a:	85 c0                	test   %eax,%eax
c010884c:	75 1e                	jne    c010886c <basic_check+0x12d>
c010884e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108851:	89 04 24             	mov    %eax,(%esp)
c0108854:	e8 99 f8 ff ff       	call   c01080f2 <page_ref>
c0108859:	85 c0                	test   %eax,%eax
c010885b:	75 0f                	jne    c010886c <basic_check+0x12d>
c010885d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108860:	89 04 24             	mov    %eax,(%esp)
c0108863:	e8 8a f8 ff ff       	call   c01080f2 <page_ref>
c0108868:	85 c0                	test   %eax,%eax
c010886a:	74 24                	je     c0108890 <basic_check+0x151>
c010886c:	c7 44 24 0c 64 b0 10 	movl   $0xc010b064,0xc(%esp)
c0108873:	c0 
c0108874:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c010887b:	c0 
c010887c:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0108883:	00 
c0108884:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c010888b:	e8 58 7b ff ff       	call   c01003e8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0108890:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108893:	89 04 24             	mov    %eax,(%esp)
c0108896:	e8 41 f8 ff ff       	call   c01080dc <page2pa>
c010889b:	8b 15 c0 e8 11 c0    	mov    0xc011e8c0,%edx
c01088a1:	c1 e2 0c             	shl    $0xc,%edx
c01088a4:	39 d0                	cmp    %edx,%eax
c01088a6:	72 24                	jb     c01088cc <basic_check+0x18d>
c01088a8:	c7 44 24 0c a0 b0 10 	movl   $0xc010b0a0,0xc(%esp)
c01088af:	c0 
c01088b0:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01088b7:	c0 
c01088b8:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c01088bf:	00 
c01088c0:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01088c7:	e8 1c 7b ff ff       	call   c01003e8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01088cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01088cf:	89 04 24             	mov    %eax,(%esp)
c01088d2:	e8 05 f8 ff ff       	call   c01080dc <page2pa>
c01088d7:	8b 15 c0 e8 11 c0    	mov    0xc011e8c0,%edx
c01088dd:	c1 e2 0c             	shl    $0xc,%edx
c01088e0:	39 d0                	cmp    %edx,%eax
c01088e2:	72 24                	jb     c0108908 <basic_check+0x1c9>
c01088e4:	c7 44 24 0c bd b0 10 	movl   $0xc010b0bd,0xc(%esp)
c01088eb:	c0 
c01088ec:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01088f3:	c0 
c01088f4:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c01088fb:	00 
c01088fc:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108903:	e8 e0 7a ff ff       	call   c01003e8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0108908:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010890b:	89 04 24             	mov    %eax,(%esp)
c010890e:	e8 c9 f7 ff ff       	call   c01080dc <page2pa>
c0108913:	8b 15 c0 e8 11 c0    	mov    0xc011e8c0,%edx
c0108919:	c1 e2 0c             	shl    $0xc,%edx
c010891c:	39 d0                	cmp    %edx,%eax
c010891e:	72 24                	jb     c0108944 <basic_check+0x205>
c0108920:	c7 44 24 0c da b0 10 	movl   $0xc010b0da,0xc(%esp)
c0108927:	c0 
c0108928:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c010892f:	c0 
c0108930:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c0108937:	00 
c0108938:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c010893f:	e8 a4 7a ff ff       	call   c01003e8 <__panic>

    list_entry_t free_list_store = free_list;
c0108944:	a1 78 e9 11 c0       	mov    0xc011e978,%eax
c0108949:	8b 15 7c e9 11 c0    	mov    0xc011e97c,%edx
c010894f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0108952:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108955:	c7 45 e0 78 e9 11 c0 	movl   $0xc011e978,-0x20(%ebp)
    elm->prev = elm->next = elm;
c010895c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010895f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108962:	89 50 04             	mov    %edx,0x4(%eax)
c0108965:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108968:	8b 50 04             	mov    0x4(%eax),%edx
c010896b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010896e:	89 10                	mov    %edx,(%eax)
c0108970:	c7 45 dc 78 e9 11 c0 	movl   $0xc011e978,-0x24(%ebp)
    return list->next == list;
c0108977:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010897a:	8b 40 04             	mov    0x4(%eax),%eax
c010897d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0108980:	0f 94 c0             	sete   %al
c0108983:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0108986:	85 c0                	test   %eax,%eax
c0108988:	75 24                	jne    c01089ae <basic_check+0x26f>
c010898a:	c7 44 24 0c f7 b0 10 	movl   $0xc010b0f7,0xc(%esp)
c0108991:	c0 
c0108992:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108999:	c0 
c010899a:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c01089a1:	00 
c01089a2:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01089a9:	e8 3a 7a ff ff       	call   c01003e8 <__panic>

    unsigned int nr_free_store = nr_free;
c01089ae:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
c01089b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01089b6:	c7 05 80 e9 11 c0 00 	movl   $0x0,0xc011e980
c01089bd:	00 00 00 

    assert(alloc_page() == NULL);
c01089c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01089c7:	e8 f3 a2 ff ff       	call   c0102cbf <alloc_pages>
c01089cc:	85 c0                	test   %eax,%eax
c01089ce:	74 24                	je     c01089f4 <basic_check+0x2b5>
c01089d0:	c7 44 24 0c 0e b1 10 	movl   $0xc010b10e,0xc(%esp)
c01089d7:	c0 
c01089d8:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01089df:	c0 
c01089e0:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c01089e7:	00 
c01089e8:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01089ef:	e8 f4 79 ff ff       	call   c01003e8 <__panic>

    free_page(p0);
c01089f4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01089fb:	00 
c01089fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01089ff:	89 04 24             	mov    %eax,(%esp)
c0108a02:	e8 f0 a2 ff ff       	call   c0102cf7 <free_pages>
    free_page(p1);
c0108a07:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108a0e:	00 
c0108a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a12:	89 04 24             	mov    %eax,(%esp)
c0108a15:	e8 dd a2 ff ff       	call   c0102cf7 <free_pages>
    free_page(p2);
c0108a1a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108a21:	00 
c0108a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a25:	89 04 24             	mov    %eax,(%esp)
c0108a28:	e8 ca a2 ff ff       	call   c0102cf7 <free_pages>
    assert(nr_free == 3);
c0108a2d:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
c0108a32:	83 f8 03             	cmp    $0x3,%eax
c0108a35:	74 24                	je     c0108a5b <basic_check+0x31c>
c0108a37:	c7 44 24 0c 23 b1 10 	movl   $0xc010b123,0xc(%esp)
c0108a3e:	c0 
c0108a3f:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108a46:	c0 
c0108a47:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0108a4e:	00 
c0108a4f:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108a56:	e8 8d 79 ff ff       	call   c01003e8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0108a5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108a62:	e8 58 a2 ff ff       	call   c0102cbf <alloc_pages>
c0108a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108a6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108a6e:	75 24                	jne    c0108a94 <basic_check+0x355>
c0108a70:	c7 44 24 0c ec af 10 	movl   $0xc010afec,0xc(%esp)
c0108a77:	c0 
c0108a78:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108a7f:	c0 
c0108a80:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0108a87:	00 
c0108a88:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108a8f:	e8 54 79 ff ff       	call   c01003e8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0108a94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108a9b:	e8 1f a2 ff ff       	call   c0102cbf <alloc_pages>
c0108aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108aa3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108aa7:	75 24                	jne    c0108acd <basic_check+0x38e>
c0108aa9:	c7 44 24 0c 08 b0 10 	movl   $0xc010b008,0xc(%esp)
c0108ab0:	c0 
c0108ab1:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108ab8:	c0 
c0108ab9:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0108ac0:	00 
c0108ac1:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108ac8:	e8 1b 79 ff ff       	call   c01003e8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0108acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108ad4:	e8 e6 a1 ff ff       	call   c0102cbf <alloc_pages>
c0108ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108ae0:	75 24                	jne    c0108b06 <basic_check+0x3c7>
c0108ae2:	c7 44 24 0c 24 b0 10 	movl   $0xc010b024,0xc(%esp)
c0108ae9:	c0 
c0108aea:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108af1:	c0 
c0108af2:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0108af9:	00 
c0108afa:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108b01:	e8 e2 78 ff ff       	call   c01003e8 <__panic>

    assert(alloc_page() == NULL);
c0108b06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108b0d:	e8 ad a1 ff ff       	call   c0102cbf <alloc_pages>
c0108b12:	85 c0                	test   %eax,%eax
c0108b14:	74 24                	je     c0108b3a <basic_check+0x3fb>
c0108b16:	c7 44 24 0c 0e b1 10 	movl   $0xc010b10e,0xc(%esp)
c0108b1d:	c0 
c0108b1e:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108b25:	c0 
c0108b26:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0108b2d:	00 
c0108b2e:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108b35:	e8 ae 78 ff ff       	call   c01003e8 <__panic>

    free_page(p0);
c0108b3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108b41:	00 
c0108b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b45:	89 04 24             	mov    %eax,(%esp)
c0108b48:	e8 aa a1 ff ff       	call   c0102cf7 <free_pages>
c0108b4d:	c7 45 d8 78 e9 11 c0 	movl   $0xc011e978,-0x28(%ebp)
c0108b54:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108b57:	8b 40 04             	mov    0x4(%eax),%eax
c0108b5a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0108b5d:	0f 94 c0             	sete   %al
c0108b60:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0108b63:	85 c0                	test   %eax,%eax
c0108b65:	74 24                	je     c0108b8b <basic_check+0x44c>
c0108b67:	c7 44 24 0c 30 b1 10 	movl   $0xc010b130,0xc(%esp)
c0108b6e:	c0 
c0108b6f:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108b76:	c0 
c0108b77:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0108b7e:	00 
c0108b7f:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108b86:	e8 5d 78 ff ff       	call   c01003e8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0108b8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108b92:	e8 28 a1 ff ff       	call   c0102cbf <alloc_pages>
c0108b97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108b9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108b9d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108ba0:	74 24                	je     c0108bc6 <basic_check+0x487>
c0108ba2:	c7 44 24 0c 48 b1 10 	movl   $0xc010b148,0xc(%esp)
c0108ba9:	c0 
c0108baa:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108bb1:	c0 
c0108bb2:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0108bb9:	00 
c0108bba:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108bc1:	e8 22 78 ff ff       	call   c01003e8 <__panic>
    assert(alloc_page() == NULL);
c0108bc6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108bcd:	e8 ed a0 ff ff       	call   c0102cbf <alloc_pages>
c0108bd2:	85 c0                	test   %eax,%eax
c0108bd4:	74 24                	je     c0108bfa <basic_check+0x4bb>
c0108bd6:	c7 44 24 0c 0e b1 10 	movl   $0xc010b10e,0xc(%esp)
c0108bdd:	c0 
c0108bde:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108be5:	c0 
c0108be6:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0108bed:	00 
c0108bee:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108bf5:	e8 ee 77 ff ff       	call   c01003e8 <__panic>

    assert(nr_free == 0);
c0108bfa:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
c0108bff:	85 c0                	test   %eax,%eax
c0108c01:	74 24                	je     c0108c27 <basic_check+0x4e8>
c0108c03:	c7 44 24 0c 61 b1 10 	movl   $0xc010b161,0xc(%esp)
c0108c0a:	c0 
c0108c0b:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108c12:	c0 
c0108c13:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0108c1a:	00 
c0108c1b:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108c22:	e8 c1 77 ff ff       	call   c01003e8 <__panic>
    free_list = free_list_store;
c0108c27:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108c2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108c2d:	a3 78 e9 11 c0       	mov    %eax,0xc011e978
c0108c32:	89 15 7c e9 11 c0    	mov    %edx,0xc011e97c
    nr_free = nr_free_store;
c0108c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c3b:	a3 80 e9 11 c0       	mov    %eax,0xc011e980

    free_page(p);
c0108c40:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108c47:	00 
c0108c48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c4b:	89 04 24             	mov    %eax,(%esp)
c0108c4e:	e8 a4 a0 ff ff       	call   c0102cf7 <free_pages>
    free_page(p1);
c0108c53:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108c5a:	00 
c0108c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c5e:	89 04 24             	mov    %eax,(%esp)
c0108c61:	e8 91 a0 ff ff       	call   c0102cf7 <free_pages>
    free_page(p2);
c0108c66:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108c6d:	00 
c0108c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c71:	89 04 24             	mov    %eax,(%esp)
c0108c74:	e8 7e a0 ff ff       	call   c0102cf7 <free_pages>
}
c0108c79:	c9                   	leave  
c0108c7a:	c3                   	ret    

c0108c7b <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0108c7b:	55                   	push   %ebp
c0108c7c:	89 e5                	mov    %esp,%ebp
c0108c7e:	53                   	push   %ebx
c0108c7f:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0108c85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108c8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0108c93:	c7 45 ec 78 e9 11 c0 	movl   $0xc011e978,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0108c9a:	eb 6b                	jmp    c0108d07 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0108c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c9f:	83 e8 0c             	sub    $0xc,%eax
c0108ca2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0108ca5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108ca8:	83 c0 04             	add    $0x4,%eax
c0108cab:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0108cb2:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0108cb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108cb8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108cbb:	0f a3 10             	bt     %edx,(%eax)
c0108cbe:	19 c0                	sbb    %eax,%eax
c0108cc0:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0108cc3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0108cc7:	0f 95 c0             	setne  %al
c0108cca:	0f b6 c0             	movzbl %al,%eax
c0108ccd:	85 c0                	test   %eax,%eax
c0108ccf:	75 24                	jne    c0108cf5 <default_check+0x7a>
c0108cd1:	c7 44 24 0c 6e b1 10 	movl   $0xc010b16e,0xc(%esp)
c0108cd8:	c0 
c0108cd9:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108ce0:	c0 
c0108ce1:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0108ce8:	00 
c0108ce9:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108cf0:	e8 f3 76 ff ff       	call   c01003e8 <__panic>
        count ++, total += p->property;
c0108cf5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108cf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108cfc:	8b 50 08             	mov    0x8(%eax),%edx
c0108cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d02:	01 d0                	add    %edx,%eax
c0108d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108d07:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0108d0d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0108d10:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0108d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108d16:	81 7d ec 78 e9 11 c0 	cmpl   $0xc011e978,-0x14(%ebp)
c0108d1d:	0f 85 79 ff ff ff    	jne    c0108c9c <default_check+0x21>
    }
    assert(total == nr_free_pages());
c0108d23:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0108d26:	e8 fe 9f ff ff       	call   c0102d29 <nr_free_pages>
c0108d2b:	39 c3                	cmp    %eax,%ebx
c0108d2d:	74 24                	je     c0108d53 <default_check+0xd8>
c0108d2f:	c7 44 24 0c 7e b1 10 	movl   $0xc010b17e,0xc(%esp)
c0108d36:	c0 
c0108d37:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108d3e:	c0 
c0108d3f:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0108d46:	00 
c0108d47:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108d4e:	e8 95 76 ff ff       	call   c01003e8 <__panic>

    basic_check();
c0108d53:	e8 e7 f9 ff ff       	call   c010873f <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0108d58:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0108d5f:	e8 5b 9f ff ff       	call   c0102cbf <alloc_pages>
c0108d64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0108d67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108d6b:	75 24                	jne    c0108d91 <default_check+0x116>
c0108d6d:	c7 44 24 0c 97 b1 10 	movl   $0xc010b197,0xc(%esp)
c0108d74:	c0 
c0108d75:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108d7c:	c0 
c0108d7d:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0108d84:	00 
c0108d85:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108d8c:	e8 57 76 ff ff       	call   c01003e8 <__panic>
    assert(!PageProperty(p0));
c0108d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108d94:	83 c0 04             	add    $0x4,%eax
c0108d97:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0108d9e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0108da1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108da4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0108da7:	0f a3 10             	bt     %edx,(%eax)
c0108daa:	19 c0                	sbb    %eax,%eax
c0108dac:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0108daf:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0108db3:	0f 95 c0             	setne  %al
c0108db6:	0f b6 c0             	movzbl %al,%eax
c0108db9:	85 c0                	test   %eax,%eax
c0108dbb:	74 24                	je     c0108de1 <default_check+0x166>
c0108dbd:	c7 44 24 0c a2 b1 10 	movl   $0xc010b1a2,0xc(%esp)
c0108dc4:	c0 
c0108dc5:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108dcc:	c0 
c0108dcd:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0108dd4:	00 
c0108dd5:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108ddc:	e8 07 76 ff ff       	call   c01003e8 <__panic>

    list_entry_t free_list_store = free_list;
c0108de1:	a1 78 e9 11 c0       	mov    0xc011e978,%eax
c0108de6:	8b 15 7c e9 11 c0    	mov    0xc011e97c,%edx
c0108dec:	89 45 80             	mov    %eax,-0x80(%ebp)
c0108def:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0108df2:	c7 45 b4 78 e9 11 c0 	movl   $0xc011e978,-0x4c(%ebp)
    elm->prev = elm->next = elm;
c0108df9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0108dfc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0108dff:	89 50 04             	mov    %edx,0x4(%eax)
c0108e02:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0108e05:	8b 50 04             	mov    0x4(%eax),%edx
c0108e08:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0108e0b:	89 10                	mov    %edx,(%eax)
c0108e0d:	c7 45 b0 78 e9 11 c0 	movl   $0xc011e978,-0x50(%ebp)
    return list->next == list;
c0108e14:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0108e17:	8b 40 04             	mov    0x4(%eax),%eax
c0108e1a:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0108e1d:	0f 94 c0             	sete   %al
c0108e20:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0108e23:	85 c0                	test   %eax,%eax
c0108e25:	75 24                	jne    c0108e4b <default_check+0x1d0>
c0108e27:	c7 44 24 0c f7 b0 10 	movl   $0xc010b0f7,0xc(%esp)
c0108e2e:	c0 
c0108e2f:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108e36:	c0 
c0108e37:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0108e3e:	00 
c0108e3f:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108e46:	e8 9d 75 ff ff       	call   c01003e8 <__panic>
    assert(alloc_page() == NULL);
c0108e4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108e52:	e8 68 9e ff ff       	call   c0102cbf <alloc_pages>
c0108e57:	85 c0                	test   %eax,%eax
c0108e59:	74 24                	je     c0108e7f <default_check+0x204>
c0108e5b:	c7 44 24 0c 0e b1 10 	movl   $0xc010b10e,0xc(%esp)
c0108e62:	c0 
c0108e63:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108e6a:	c0 
c0108e6b:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0108e72:	00 
c0108e73:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108e7a:	e8 69 75 ff ff       	call   c01003e8 <__panic>

    unsigned int nr_free_store = nr_free;
c0108e7f:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
c0108e84:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0108e87:	c7 05 80 e9 11 c0 00 	movl   $0x0,0xc011e980
c0108e8e:	00 00 00 

    free_pages(p0 + 2, 3);
c0108e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e94:	83 c0 28             	add    $0x28,%eax
c0108e97:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0108e9e:	00 
c0108e9f:	89 04 24             	mov    %eax,(%esp)
c0108ea2:	e8 50 9e ff ff       	call   c0102cf7 <free_pages>
    assert(alloc_pages(4) == NULL);
c0108ea7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0108eae:	e8 0c 9e ff ff       	call   c0102cbf <alloc_pages>
c0108eb3:	85 c0                	test   %eax,%eax
c0108eb5:	74 24                	je     c0108edb <default_check+0x260>
c0108eb7:	c7 44 24 0c b4 b1 10 	movl   $0xc010b1b4,0xc(%esp)
c0108ebe:	c0 
c0108ebf:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108ec6:	c0 
c0108ec7:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0108ece:	00 
c0108ecf:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108ed6:	e8 0d 75 ff ff       	call   c01003e8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0108edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108ede:	83 c0 28             	add    $0x28,%eax
c0108ee1:	83 c0 04             	add    $0x4,%eax
c0108ee4:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0108eeb:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0108eee:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0108ef1:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0108ef4:	0f a3 10             	bt     %edx,(%eax)
c0108ef7:	19 c0                	sbb    %eax,%eax
c0108ef9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0108efc:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0108f00:	0f 95 c0             	setne  %al
c0108f03:	0f b6 c0             	movzbl %al,%eax
c0108f06:	85 c0                	test   %eax,%eax
c0108f08:	74 0e                	je     c0108f18 <default_check+0x29d>
c0108f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108f0d:	83 c0 28             	add    $0x28,%eax
c0108f10:	8b 40 08             	mov    0x8(%eax),%eax
c0108f13:	83 f8 03             	cmp    $0x3,%eax
c0108f16:	74 24                	je     c0108f3c <default_check+0x2c1>
c0108f18:	c7 44 24 0c cc b1 10 	movl   $0xc010b1cc,0xc(%esp)
c0108f1f:	c0 
c0108f20:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108f27:	c0 
c0108f28:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0108f2f:	00 
c0108f30:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108f37:	e8 ac 74 ff ff       	call   c01003e8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0108f3c:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0108f43:	e8 77 9d ff ff       	call   c0102cbf <alloc_pages>
c0108f48:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108f4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108f4f:	75 24                	jne    c0108f75 <default_check+0x2fa>
c0108f51:	c7 44 24 0c f8 b1 10 	movl   $0xc010b1f8,0xc(%esp)
c0108f58:	c0 
c0108f59:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108f60:	c0 
c0108f61:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0108f68:	00 
c0108f69:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108f70:	e8 73 74 ff ff       	call   c01003e8 <__panic>
    assert(alloc_page() == NULL);
c0108f75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108f7c:	e8 3e 9d ff ff       	call   c0102cbf <alloc_pages>
c0108f81:	85 c0                	test   %eax,%eax
c0108f83:	74 24                	je     c0108fa9 <default_check+0x32e>
c0108f85:	c7 44 24 0c 0e b1 10 	movl   $0xc010b10e,0xc(%esp)
c0108f8c:	c0 
c0108f8d:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108f94:	c0 
c0108f95:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0108f9c:	00 
c0108f9d:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108fa4:	e8 3f 74 ff ff       	call   c01003e8 <__panic>
    assert(p0 + 2 == p1);
c0108fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108fac:	83 c0 28             	add    $0x28,%eax
c0108faf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0108fb2:	74 24                	je     c0108fd8 <default_check+0x35d>
c0108fb4:	c7 44 24 0c 16 b2 10 	movl   $0xc010b216,0xc(%esp)
c0108fbb:	c0 
c0108fbc:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0108fc3:	c0 
c0108fc4:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0108fcb:	00 
c0108fcc:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0108fd3:	e8 10 74 ff ff       	call   c01003e8 <__panic>

    p2 = p0 + 1;
c0108fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108fdb:	83 c0 14             	add    $0x14,%eax
c0108fde:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0108fe1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108fe8:	00 
c0108fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108fec:	89 04 24             	mov    %eax,(%esp)
c0108fef:	e8 03 9d ff ff       	call   c0102cf7 <free_pages>
    free_pages(p1, 3);
c0108ff4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0108ffb:	00 
c0108ffc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108fff:	89 04 24             	mov    %eax,(%esp)
c0109002:	e8 f0 9c ff ff       	call   c0102cf7 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0109007:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010900a:	83 c0 04             	add    $0x4,%eax
c010900d:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0109014:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0109017:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010901a:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010901d:	0f a3 10             	bt     %edx,(%eax)
c0109020:	19 c0                	sbb    %eax,%eax
c0109022:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0109025:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0109029:	0f 95 c0             	setne  %al
c010902c:	0f b6 c0             	movzbl %al,%eax
c010902f:	85 c0                	test   %eax,%eax
c0109031:	74 0b                	je     c010903e <default_check+0x3c3>
c0109033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109036:	8b 40 08             	mov    0x8(%eax),%eax
c0109039:	83 f8 01             	cmp    $0x1,%eax
c010903c:	74 24                	je     c0109062 <default_check+0x3e7>
c010903e:	c7 44 24 0c 24 b2 10 	movl   $0xc010b224,0xc(%esp)
c0109045:	c0 
c0109046:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c010904d:	c0 
c010904e:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0109055:	00 
c0109056:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c010905d:	e8 86 73 ff ff       	call   c01003e8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0109062:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109065:	83 c0 04             	add    $0x4,%eax
c0109068:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010906f:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0109072:	8b 45 90             	mov    -0x70(%ebp),%eax
c0109075:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0109078:	0f a3 10             	bt     %edx,(%eax)
c010907b:	19 c0                	sbb    %eax,%eax
c010907d:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0109080:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0109084:	0f 95 c0             	setne  %al
c0109087:	0f b6 c0             	movzbl %al,%eax
c010908a:	85 c0                	test   %eax,%eax
c010908c:	74 0b                	je     c0109099 <default_check+0x41e>
c010908e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109091:	8b 40 08             	mov    0x8(%eax),%eax
c0109094:	83 f8 03             	cmp    $0x3,%eax
c0109097:	74 24                	je     c01090bd <default_check+0x442>
c0109099:	c7 44 24 0c 4c b2 10 	movl   $0xc010b24c,0xc(%esp)
c01090a0:	c0 
c01090a1:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01090a8:	c0 
c01090a9:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01090b0:	00 
c01090b1:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01090b8:	e8 2b 73 ff ff       	call   c01003e8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01090bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01090c4:	e8 f6 9b ff ff       	call   c0102cbf <alloc_pages>
c01090c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01090cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01090cf:	83 e8 14             	sub    $0x14,%eax
c01090d2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01090d5:	74 24                	je     c01090fb <default_check+0x480>
c01090d7:	c7 44 24 0c 72 b2 10 	movl   $0xc010b272,0xc(%esp)
c01090de:	c0 
c01090df:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01090e6:	c0 
c01090e7:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01090ee:	00 
c01090ef:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01090f6:	e8 ed 72 ff ff       	call   c01003e8 <__panic>
    free_page(p0);
c01090fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0109102:	00 
c0109103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109106:	89 04 24             	mov    %eax,(%esp)
c0109109:	e8 e9 9b ff ff       	call   c0102cf7 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010910e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0109115:	e8 a5 9b ff ff       	call   c0102cbf <alloc_pages>
c010911a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010911d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109120:	83 c0 14             	add    $0x14,%eax
c0109123:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0109126:	74 24                	je     c010914c <default_check+0x4d1>
c0109128:	c7 44 24 0c 90 b2 10 	movl   $0xc010b290,0xc(%esp)
c010912f:	c0 
c0109130:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0109137:	c0 
c0109138:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c010913f:	00 
c0109140:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0109147:	e8 9c 72 ff ff       	call   c01003e8 <__panic>

    free_pages(p0, 2);
c010914c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0109153:	00 
c0109154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109157:	89 04 24             	mov    %eax,(%esp)
c010915a:	e8 98 9b ff ff       	call   c0102cf7 <free_pages>
    free_page(p2);
c010915f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0109166:	00 
c0109167:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010916a:	89 04 24             	mov    %eax,(%esp)
c010916d:	e8 85 9b ff ff       	call   c0102cf7 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0109172:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0109179:	e8 41 9b ff ff       	call   c0102cbf <alloc_pages>
c010917e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109181:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109185:	75 24                	jne    c01091ab <default_check+0x530>
c0109187:	c7 44 24 0c b0 b2 10 	movl   $0xc010b2b0,0xc(%esp)
c010918e:	c0 
c010918f:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c0109196:	c0 
c0109197:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c010919e:	00 
c010919f:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01091a6:	e8 3d 72 ff ff       	call   c01003e8 <__panic>
    assert(alloc_page() == NULL);
c01091ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01091b2:	e8 08 9b ff ff       	call   c0102cbf <alloc_pages>
c01091b7:	85 c0                	test   %eax,%eax
c01091b9:	74 24                	je     c01091df <default_check+0x564>
c01091bb:	c7 44 24 0c 0e b1 10 	movl   $0xc010b10e,0xc(%esp)
c01091c2:	c0 
c01091c3:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01091ca:	c0 
c01091cb:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c01091d2:	00 
c01091d3:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01091da:	e8 09 72 ff ff       	call   c01003e8 <__panic>

    assert(nr_free == 0);
c01091df:	a1 80 e9 11 c0       	mov    0xc011e980,%eax
c01091e4:	85 c0                	test   %eax,%eax
c01091e6:	74 24                	je     c010920c <default_check+0x591>
c01091e8:	c7 44 24 0c 61 b1 10 	movl   $0xc010b161,0xc(%esp)
c01091ef:	c0 
c01091f0:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01091f7:	c0 
c01091f8:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01091ff:	00 
c0109200:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c0109207:	e8 dc 71 ff ff       	call   c01003e8 <__panic>
    nr_free = nr_free_store;
c010920c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010920f:	a3 80 e9 11 c0       	mov    %eax,0xc011e980

    free_list = free_list_store;
c0109214:	8b 45 80             	mov    -0x80(%ebp),%eax
c0109217:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010921a:	a3 78 e9 11 c0       	mov    %eax,0xc011e978
c010921f:	89 15 7c e9 11 c0    	mov    %edx,0xc011e97c
    free_pages(p0, 5);
c0109225:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010922c:	00 
c010922d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109230:	89 04 24             	mov    %eax,(%esp)
c0109233:	e8 bf 9a ff ff       	call   c0102cf7 <free_pages>

    le = &free_list;
c0109238:	c7 45 ec 78 e9 11 c0 	movl   $0xc011e978,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010923f:	eb 1d                	jmp    c010925e <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0109241:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109244:	83 e8 0c             	sub    $0xc,%eax
c0109247:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010924a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010924e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109251:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109254:	8b 40 08             	mov    0x8(%eax),%eax
c0109257:	29 c2                	sub    %eax,%edx
c0109259:	89 d0                	mov    %edx,%eax
c010925b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010925e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109261:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0109264:	8b 45 88             	mov    -0x78(%ebp),%eax
c0109267:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010926a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010926d:	81 7d ec 78 e9 11 c0 	cmpl   $0xc011e978,-0x14(%ebp)
c0109274:	75 cb                	jne    c0109241 <default_check+0x5c6>
    }
    assert(count == 0);
c0109276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010927a:	74 24                	je     c01092a0 <default_check+0x625>
c010927c:	c7 44 24 0c ce b2 10 	movl   $0xc010b2ce,0xc(%esp)
c0109283:	c0 
c0109284:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c010928b:	c0 
c010928c:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0109293:	00 
c0109294:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c010929b:	e8 48 71 ff ff       	call   c01003e8 <__panic>
    assert(total == 0);
c01092a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01092a4:	74 24                	je     c01092ca <default_check+0x64f>
c01092a6:	c7 44 24 0c d9 b2 10 	movl   $0xc010b2d9,0xc(%esp)
c01092ad:	c0 
c01092ae:	c7 44 24 08 6e af 10 	movl   $0xc010af6e,0x8(%esp)
c01092b5:	c0 
c01092b6:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01092bd:	00 
c01092be:	c7 04 24 83 af 10 c0 	movl   $0xc010af83,(%esp)
c01092c5:	e8 1e 71 ff ff       	call   c01003e8 <__panic>
}
c01092ca:	81 c4 94 00 00 00    	add    $0x94,%esp
c01092d0:	5b                   	pop    %ebx
c01092d1:	5d                   	pop    %ebp
c01092d2:	c3                   	ret    

c01092d3 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01092d3:	55                   	push   %ebp
c01092d4:	89 e5                	mov    %esp,%ebp
c01092d6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01092d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01092e0:	eb 04                	jmp    c01092e6 <strlen+0x13>
        cnt ++;
c01092e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c01092e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01092e9:	8d 50 01             	lea    0x1(%eax),%edx
c01092ec:	89 55 08             	mov    %edx,0x8(%ebp)
c01092ef:	0f b6 00             	movzbl (%eax),%eax
c01092f2:	84 c0                	test   %al,%al
c01092f4:	75 ec                	jne    c01092e2 <strlen+0xf>
    }
    return cnt;
c01092f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01092f9:	c9                   	leave  
c01092fa:	c3                   	ret    

c01092fb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01092fb:	55                   	push   %ebp
c01092fc:	89 e5                	mov    %esp,%ebp
c01092fe:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109308:	eb 04                	jmp    c010930e <strnlen+0x13>
        cnt ++;
c010930a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010930e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109311:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109314:	73 10                	jae    c0109326 <strnlen+0x2b>
c0109316:	8b 45 08             	mov    0x8(%ebp),%eax
c0109319:	8d 50 01             	lea    0x1(%eax),%edx
c010931c:	89 55 08             	mov    %edx,0x8(%ebp)
c010931f:	0f b6 00             	movzbl (%eax),%eax
c0109322:	84 c0                	test   %al,%al
c0109324:	75 e4                	jne    c010930a <strnlen+0xf>
    }
    return cnt;
c0109326:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109329:	c9                   	leave  
c010932a:	c3                   	ret    

c010932b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010932b:	55                   	push   %ebp
c010932c:	89 e5                	mov    %esp,%ebp
c010932e:	57                   	push   %edi
c010932f:	56                   	push   %esi
c0109330:	83 ec 20             	sub    $0x20,%esp
c0109333:	8b 45 08             	mov    0x8(%ebp),%eax
c0109336:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109339:	8b 45 0c             	mov    0xc(%ebp),%eax
c010933c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010933f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109342:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109345:	89 d1                	mov    %edx,%ecx
c0109347:	89 c2                	mov    %eax,%edx
c0109349:	89 ce                	mov    %ecx,%esi
c010934b:	89 d7                	mov    %edx,%edi
c010934d:	ac                   	lods   %ds:(%esi),%al
c010934e:	aa                   	stos   %al,%es:(%edi)
c010934f:	84 c0                	test   %al,%al
c0109351:	75 fa                	jne    c010934d <strcpy+0x22>
c0109353:	89 fa                	mov    %edi,%edx
c0109355:	89 f1                	mov    %esi,%ecx
c0109357:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010935a:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010935d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0109360:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109363:	83 c4 20             	add    $0x20,%esp
c0109366:	5e                   	pop    %esi
c0109367:	5f                   	pop    %edi
c0109368:	5d                   	pop    %ebp
c0109369:	c3                   	ret    

c010936a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010936a:	55                   	push   %ebp
c010936b:	89 e5                	mov    %esp,%ebp
c010936d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0109370:	8b 45 08             	mov    0x8(%ebp),%eax
c0109373:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0109376:	eb 21                	jmp    c0109399 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0109378:	8b 45 0c             	mov    0xc(%ebp),%eax
c010937b:	0f b6 10             	movzbl (%eax),%edx
c010937e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109381:	88 10                	mov    %dl,(%eax)
c0109383:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109386:	0f b6 00             	movzbl (%eax),%eax
c0109389:	84 c0                	test   %al,%al
c010938b:	74 04                	je     c0109391 <strncpy+0x27>
            src ++;
c010938d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0109391:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109395:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c0109399:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010939d:	75 d9                	jne    c0109378 <strncpy+0xe>
    }
    return dst;
c010939f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01093a2:	c9                   	leave  
c01093a3:	c3                   	ret    

c01093a4 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01093a4:	55                   	push   %ebp
c01093a5:	89 e5                	mov    %esp,%ebp
c01093a7:	57                   	push   %edi
c01093a8:	56                   	push   %esi
c01093a9:	83 ec 20             	sub    $0x20,%esp
c01093ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01093af:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01093b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01093b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01093bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01093be:	89 d1                	mov    %edx,%ecx
c01093c0:	89 c2                	mov    %eax,%edx
c01093c2:	89 ce                	mov    %ecx,%esi
c01093c4:	89 d7                	mov    %edx,%edi
c01093c6:	ac                   	lods   %ds:(%esi),%al
c01093c7:	ae                   	scas   %es:(%edi),%al
c01093c8:	75 08                	jne    c01093d2 <strcmp+0x2e>
c01093ca:	84 c0                	test   %al,%al
c01093cc:	75 f8                	jne    c01093c6 <strcmp+0x22>
c01093ce:	31 c0                	xor    %eax,%eax
c01093d0:	eb 04                	jmp    c01093d6 <strcmp+0x32>
c01093d2:	19 c0                	sbb    %eax,%eax
c01093d4:	0c 01                	or     $0x1,%al
c01093d6:	89 fa                	mov    %edi,%edx
c01093d8:	89 f1                	mov    %esi,%ecx
c01093da:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01093dd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01093e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01093e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01093e6:	83 c4 20             	add    $0x20,%esp
c01093e9:	5e                   	pop    %esi
c01093ea:	5f                   	pop    %edi
c01093eb:	5d                   	pop    %ebp
c01093ec:	c3                   	ret    

c01093ed <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01093ed:	55                   	push   %ebp
c01093ee:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01093f0:	eb 0c                	jmp    c01093fe <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01093f2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01093f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01093fa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01093fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109402:	74 1a                	je     c010941e <strncmp+0x31>
c0109404:	8b 45 08             	mov    0x8(%ebp),%eax
c0109407:	0f b6 00             	movzbl (%eax),%eax
c010940a:	84 c0                	test   %al,%al
c010940c:	74 10                	je     c010941e <strncmp+0x31>
c010940e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109411:	0f b6 10             	movzbl (%eax),%edx
c0109414:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109417:	0f b6 00             	movzbl (%eax),%eax
c010941a:	38 c2                	cmp    %al,%dl
c010941c:	74 d4                	je     c01093f2 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010941e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109422:	74 18                	je     c010943c <strncmp+0x4f>
c0109424:	8b 45 08             	mov    0x8(%ebp),%eax
c0109427:	0f b6 00             	movzbl (%eax),%eax
c010942a:	0f b6 d0             	movzbl %al,%edx
c010942d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109430:	0f b6 00             	movzbl (%eax),%eax
c0109433:	0f b6 c0             	movzbl %al,%eax
c0109436:	29 c2                	sub    %eax,%edx
c0109438:	89 d0                	mov    %edx,%eax
c010943a:	eb 05                	jmp    c0109441 <strncmp+0x54>
c010943c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109441:	5d                   	pop    %ebp
c0109442:	c3                   	ret    

c0109443 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0109443:	55                   	push   %ebp
c0109444:	89 e5                	mov    %esp,%ebp
c0109446:	83 ec 04             	sub    $0x4,%esp
c0109449:	8b 45 0c             	mov    0xc(%ebp),%eax
c010944c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010944f:	eb 14                	jmp    c0109465 <strchr+0x22>
        if (*s == c) {
c0109451:	8b 45 08             	mov    0x8(%ebp),%eax
c0109454:	0f b6 00             	movzbl (%eax),%eax
c0109457:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010945a:	75 05                	jne    c0109461 <strchr+0x1e>
            return (char *)s;
c010945c:	8b 45 08             	mov    0x8(%ebp),%eax
c010945f:	eb 13                	jmp    c0109474 <strchr+0x31>
        }
        s ++;
c0109461:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0109465:	8b 45 08             	mov    0x8(%ebp),%eax
c0109468:	0f b6 00             	movzbl (%eax),%eax
c010946b:	84 c0                	test   %al,%al
c010946d:	75 e2                	jne    c0109451 <strchr+0xe>
    }
    return NULL;
c010946f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109474:	c9                   	leave  
c0109475:	c3                   	ret    

c0109476 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109476:	55                   	push   %ebp
c0109477:	89 e5                	mov    %esp,%ebp
c0109479:	83 ec 04             	sub    $0x4,%esp
c010947c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010947f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109482:	eb 11                	jmp    c0109495 <strfind+0x1f>
        if (*s == c) {
c0109484:	8b 45 08             	mov    0x8(%ebp),%eax
c0109487:	0f b6 00             	movzbl (%eax),%eax
c010948a:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010948d:	75 02                	jne    c0109491 <strfind+0x1b>
            break;
c010948f:	eb 0e                	jmp    c010949f <strfind+0x29>
        }
        s ++;
c0109491:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0109495:	8b 45 08             	mov    0x8(%ebp),%eax
c0109498:	0f b6 00             	movzbl (%eax),%eax
c010949b:	84 c0                	test   %al,%al
c010949d:	75 e5                	jne    c0109484 <strfind+0xe>
    }
    return (char *)s;
c010949f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01094a2:	c9                   	leave  
c01094a3:	c3                   	ret    

c01094a4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01094a4:	55                   	push   %ebp
c01094a5:	89 e5                	mov    %esp,%ebp
c01094a7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01094aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01094b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01094b8:	eb 04                	jmp    c01094be <strtol+0x1a>
        s ++;
c01094ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01094be:	8b 45 08             	mov    0x8(%ebp),%eax
c01094c1:	0f b6 00             	movzbl (%eax),%eax
c01094c4:	3c 20                	cmp    $0x20,%al
c01094c6:	74 f2                	je     c01094ba <strtol+0x16>
c01094c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01094cb:	0f b6 00             	movzbl (%eax),%eax
c01094ce:	3c 09                	cmp    $0x9,%al
c01094d0:	74 e8                	je     c01094ba <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c01094d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01094d5:	0f b6 00             	movzbl (%eax),%eax
c01094d8:	3c 2b                	cmp    $0x2b,%al
c01094da:	75 06                	jne    c01094e2 <strtol+0x3e>
        s ++;
c01094dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01094e0:	eb 15                	jmp    c01094f7 <strtol+0x53>
    }
    else if (*s == '-') {
c01094e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01094e5:	0f b6 00             	movzbl (%eax),%eax
c01094e8:	3c 2d                	cmp    $0x2d,%al
c01094ea:	75 0b                	jne    c01094f7 <strtol+0x53>
        s ++, neg = 1;
c01094ec:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01094f0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01094f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01094fb:	74 06                	je     c0109503 <strtol+0x5f>
c01094fd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109501:	75 24                	jne    c0109527 <strtol+0x83>
c0109503:	8b 45 08             	mov    0x8(%ebp),%eax
c0109506:	0f b6 00             	movzbl (%eax),%eax
c0109509:	3c 30                	cmp    $0x30,%al
c010950b:	75 1a                	jne    c0109527 <strtol+0x83>
c010950d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109510:	83 c0 01             	add    $0x1,%eax
c0109513:	0f b6 00             	movzbl (%eax),%eax
c0109516:	3c 78                	cmp    $0x78,%al
c0109518:	75 0d                	jne    c0109527 <strtol+0x83>
        s += 2, base = 16;
c010951a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010951e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109525:	eb 2a                	jmp    c0109551 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0109527:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010952b:	75 17                	jne    c0109544 <strtol+0xa0>
c010952d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109530:	0f b6 00             	movzbl (%eax),%eax
c0109533:	3c 30                	cmp    $0x30,%al
c0109535:	75 0d                	jne    c0109544 <strtol+0xa0>
        s ++, base = 8;
c0109537:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010953b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109542:	eb 0d                	jmp    c0109551 <strtol+0xad>
    }
    else if (base == 0) {
c0109544:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109548:	75 07                	jne    c0109551 <strtol+0xad>
        base = 10;
c010954a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109551:	8b 45 08             	mov    0x8(%ebp),%eax
c0109554:	0f b6 00             	movzbl (%eax),%eax
c0109557:	3c 2f                	cmp    $0x2f,%al
c0109559:	7e 1b                	jle    c0109576 <strtol+0xd2>
c010955b:	8b 45 08             	mov    0x8(%ebp),%eax
c010955e:	0f b6 00             	movzbl (%eax),%eax
c0109561:	3c 39                	cmp    $0x39,%al
c0109563:	7f 11                	jg     c0109576 <strtol+0xd2>
            dig = *s - '0';
c0109565:	8b 45 08             	mov    0x8(%ebp),%eax
c0109568:	0f b6 00             	movzbl (%eax),%eax
c010956b:	0f be c0             	movsbl %al,%eax
c010956e:	83 e8 30             	sub    $0x30,%eax
c0109571:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109574:	eb 48                	jmp    c01095be <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109576:	8b 45 08             	mov    0x8(%ebp),%eax
c0109579:	0f b6 00             	movzbl (%eax),%eax
c010957c:	3c 60                	cmp    $0x60,%al
c010957e:	7e 1b                	jle    c010959b <strtol+0xf7>
c0109580:	8b 45 08             	mov    0x8(%ebp),%eax
c0109583:	0f b6 00             	movzbl (%eax),%eax
c0109586:	3c 7a                	cmp    $0x7a,%al
c0109588:	7f 11                	jg     c010959b <strtol+0xf7>
            dig = *s - 'a' + 10;
c010958a:	8b 45 08             	mov    0x8(%ebp),%eax
c010958d:	0f b6 00             	movzbl (%eax),%eax
c0109590:	0f be c0             	movsbl %al,%eax
c0109593:	83 e8 57             	sub    $0x57,%eax
c0109596:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109599:	eb 23                	jmp    c01095be <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010959b:	8b 45 08             	mov    0x8(%ebp),%eax
c010959e:	0f b6 00             	movzbl (%eax),%eax
c01095a1:	3c 40                	cmp    $0x40,%al
c01095a3:	7e 3d                	jle    c01095e2 <strtol+0x13e>
c01095a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01095a8:	0f b6 00             	movzbl (%eax),%eax
c01095ab:	3c 5a                	cmp    $0x5a,%al
c01095ad:	7f 33                	jg     c01095e2 <strtol+0x13e>
            dig = *s - 'A' + 10;
c01095af:	8b 45 08             	mov    0x8(%ebp),%eax
c01095b2:	0f b6 00             	movzbl (%eax),%eax
c01095b5:	0f be c0             	movsbl %al,%eax
c01095b8:	83 e8 37             	sub    $0x37,%eax
c01095bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01095be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095c1:	3b 45 10             	cmp    0x10(%ebp),%eax
c01095c4:	7c 02                	jl     c01095c8 <strtol+0x124>
            break;
c01095c6:	eb 1a                	jmp    c01095e2 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c01095c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01095cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01095cf:	0f af 45 10          	imul   0x10(%ebp),%eax
c01095d3:	89 c2                	mov    %eax,%edx
c01095d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095d8:	01 d0                	add    %edx,%eax
c01095da:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01095dd:	e9 6f ff ff ff       	jmp    c0109551 <strtol+0xad>

    if (endptr) {
c01095e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01095e6:	74 08                	je     c01095f0 <strtol+0x14c>
        *endptr = (char *) s;
c01095e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01095ee:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01095f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01095f4:	74 07                	je     c01095fd <strtol+0x159>
c01095f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01095f9:	f7 d8                	neg    %eax
c01095fb:	eb 03                	jmp    c0109600 <strtol+0x15c>
c01095fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109600:	c9                   	leave  
c0109601:	c3                   	ret    

c0109602 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109602:	55                   	push   %ebp
c0109603:	89 e5                	mov    %esp,%ebp
c0109605:	57                   	push   %edi
c0109606:	83 ec 24             	sub    $0x24,%esp
c0109609:	8b 45 0c             	mov    0xc(%ebp),%eax
c010960c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010960f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109613:	8b 55 08             	mov    0x8(%ebp),%edx
c0109616:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109619:	88 45 f7             	mov    %al,-0x9(%ebp)
c010961c:	8b 45 10             	mov    0x10(%ebp),%eax
c010961f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109622:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109625:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0109629:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010962c:	89 d7                	mov    %edx,%edi
c010962e:	f3 aa                	rep stos %al,%es:(%edi)
c0109630:	89 fa                	mov    %edi,%edx
c0109632:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109635:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109638:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010963b:	83 c4 24             	add    $0x24,%esp
c010963e:	5f                   	pop    %edi
c010963f:	5d                   	pop    %ebp
c0109640:	c3                   	ret    

c0109641 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109641:	55                   	push   %ebp
c0109642:	89 e5                	mov    %esp,%ebp
c0109644:	57                   	push   %edi
c0109645:	56                   	push   %esi
c0109646:	53                   	push   %ebx
c0109647:	83 ec 30             	sub    $0x30,%esp
c010964a:	8b 45 08             	mov    0x8(%ebp),%eax
c010964d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109650:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109653:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109656:	8b 45 10             	mov    0x10(%ebp),%eax
c0109659:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010965c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010965f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109662:	73 42                	jae    c01096a6 <memmove+0x65>
c0109664:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109667:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010966a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010966d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109670:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109673:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109676:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109679:	c1 e8 02             	shr    $0x2,%eax
c010967c:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010967e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109681:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109684:	89 d7                	mov    %edx,%edi
c0109686:	89 c6                	mov    %eax,%esi
c0109688:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010968a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010968d:	83 e1 03             	and    $0x3,%ecx
c0109690:	74 02                	je     c0109694 <memmove+0x53>
c0109692:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109694:	89 f0                	mov    %esi,%eax
c0109696:	89 fa                	mov    %edi,%edx
c0109698:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010969b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010969e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01096a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01096a4:	eb 36                	jmp    c01096dc <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01096a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01096a9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01096ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01096af:	01 c2                	add    %eax,%edx
c01096b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01096b4:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01096b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096ba:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01096bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01096c0:	89 c1                	mov    %eax,%ecx
c01096c2:	89 d8                	mov    %ebx,%eax
c01096c4:	89 d6                	mov    %edx,%esi
c01096c6:	89 c7                	mov    %eax,%edi
c01096c8:	fd                   	std    
c01096c9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01096cb:	fc                   	cld    
c01096cc:	89 f8                	mov    %edi,%eax
c01096ce:	89 f2                	mov    %esi,%edx
c01096d0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01096d3:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01096d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01096d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01096dc:	83 c4 30             	add    $0x30,%esp
c01096df:	5b                   	pop    %ebx
c01096e0:	5e                   	pop    %esi
c01096e1:	5f                   	pop    %edi
c01096e2:	5d                   	pop    %ebp
c01096e3:	c3                   	ret    

c01096e4 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01096e4:	55                   	push   %ebp
c01096e5:	89 e5                	mov    %esp,%ebp
c01096e7:	57                   	push   %edi
c01096e8:	56                   	push   %esi
c01096e9:	83 ec 20             	sub    $0x20,%esp
c01096ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01096ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01096f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01096f8:	8b 45 10             	mov    0x10(%ebp),%eax
c01096fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01096fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109701:	c1 e8 02             	shr    $0x2,%eax
c0109704:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0109706:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109709:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010970c:	89 d7                	mov    %edx,%edi
c010970e:	89 c6                	mov    %eax,%esi
c0109710:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109712:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109715:	83 e1 03             	and    $0x3,%ecx
c0109718:	74 02                	je     c010971c <memcpy+0x38>
c010971a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010971c:	89 f0                	mov    %esi,%eax
c010971e:	89 fa                	mov    %edi,%edx
c0109720:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109723:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109726:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0109729:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010972c:	83 c4 20             	add    $0x20,%esp
c010972f:	5e                   	pop    %esi
c0109730:	5f                   	pop    %edi
c0109731:	5d                   	pop    %ebp
c0109732:	c3                   	ret    

c0109733 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109733:	55                   	push   %ebp
c0109734:	89 e5                	mov    %esp,%ebp
c0109736:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0109739:	8b 45 08             	mov    0x8(%ebp),%eax
c010973c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010973f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109742:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109745:	eb 30                	jmp    c0109777 <memcmp+0x44>
        if (*s1 != *s2) {
c0109747:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010974a:	0f b6 10             	movzbl (%eax),%edx
c010974d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109750:	0f b6 00             	movzbl (%eax),%eax
c0109753:	38 c2                	cmp    %al,%dl
c0109755:	74 18                	je     c010976f <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109757:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010975a:	0f b6 00             	movzbl (%eax),%eax
c010975d:	0f b6 d0             	movzbl %al,%edx
c0109760:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109763:	0f b6 00             	movzbl (%eax),%eax
c0109766:	0f b6 c0             	movzbl %al,%eax
c0109769:	29 c2                	sub    %eax,%edx
c010976b:	89 d0                	mov    %edx,%eax
c010976d:	eb 1a                	jmp    c0109789 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010976f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109773:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0109777:	8b 45 10             	mov    0x10(%ebp),%eax
c010977a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010977d:	89 55 10             	mov    %edx,0x10(%ebp)
c0109780:	85 c0                	test   %eax,%eax
c0109782:	75 c3                	jne    c0109747 <memcmp+0x14>
    }
    return 0;
c0109784:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109789:	c9                   	leave  
c010978a:	c3                   	ret    

c010978b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010978b:	55                   	push   %ebp
c010978c:	89 e5                	mov    %esp,%ebp
c010978e:	83 ec 58             	sub    $0x58,%esp
c0109791:	8b 45 10             	mov    0x10(%ebp),%eax
c0109794:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109797:	8b 45 14             	mov    0x14(%ebp),%eax
c010979a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010979d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01097a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01097a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01097a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01097a9:	8b 45 18             	mov    0x18(%ebp),%eax
c01097ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01097af:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01097b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01097b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01097b8:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01097bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097be:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01097c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01097c5:	74 1c                	je     c01097e3 <printnum+0x58>
c01097c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097ca:	ba 00 00 00 00       	mov    $0x0,%edx
c01097cf:	f7 75 e4             	divl   -0x1c(%ebp)
c01097d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01097d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097d8:	ba 00 00 00 00       	mov    $0x0,%edx
c01097dd:	f7 75 e4             	divl   -0x1c(%ebp)
c01097e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01097e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01097e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01097e9:	f7 75 e4             	divl   -0x1c(%ebp)
c01097ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01097ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01097f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01097f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01097f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01097fb:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01097fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109801:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0109804:	8b 45 18             	mov    0x18(%ebp),%eax
c0109807:	ba 00 00 00 00       	mov    $0x0,%edx
c010980c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010980f:	77 56                	ja     c0109867 <printnum+0xdc>
c0109811:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109814:	72 05                	jb     c010981b <printnum+0x90>
c0109816:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0109819:	77 4c                	ja     c0109867 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010981b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010981e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109821:	8b 45 20             	mov    0x20(%ebp),%eax
c0109824:	89 44 24 18          	mov    %eax,0x18(%esp)
c0109828:	89 54 24 14          	mov    %edx,0x14(%esp)
c010982c:	8b 45 18             	mov    0x18(%ebp),%eax
c010982f:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109833:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109836:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109839:	89 44 24 08          	mov    %eax,0x8(%esp)
c010983d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109841:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109844:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109848:	8b 45 08             	mov    0x8(%ebp),%eax
c010984b:	89 04 24             	mov    %eax,(%esp)
c010984e:	e8 38 ff ff ff       	call   c010978b <printnum>
c0109853:	eb 1c                	jmp    c0109871 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0109855:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109858:	89 44 24 04          	mov    %eax,0x4(%esp)
c010985c:	8b 45 20             	mov    0x20(%ebp),%eax
c010985f:	89 04 24             	mov    %eax,(%esp)
c0109862:	8b 45 08             	mov    0x8(%ebp),%eax
c0109865:	ff d0                	call   *%eax
        while (-- width > 0)
c0109867:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010986b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010986f:	7f e4                	jg     c0109855 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0109871:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109874:	05 94 b3 10 c0       	add    $0xc010b394,%eax
c0109879:	0f b6 00             	movzbl (%eax),%eax
c010987c:	0f be c0             	movsbl %al,%eax
c010987f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109882:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109886:	89 04 24             	mov    %eax,(%esp)
c0109889:	8b 45 08             	mov    0x8(%ebp),%eax
c010988c:	ff d0                	call   *%eax
}
c010988e:	c9                   	leave  
c010988f:	c3                   	ret    

c0109890 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0109890:	55                   	push   %ebp
c0109891:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109893:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109897:	7e 14                	jle    c01098ad <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0109899:	8b 45 08             	mov    0x8(%ebp),%eax
c010989c:	8b 00                	mov    (%eax),%eax
c010989e:	8d 48 08             	lea    0x8(%eax),%ecx
c01098a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01098a4:	89 0a                	mov    %ecx,(%edx)
c01098a6:	8b 50 04             	mov    0x4(%eax),%edx
c01098a9:	8b 00                	mov    (%eax),%eax
c01098ab:	eb 30                	jmp    c01098dd <getuint+0x4d>
    }
    else if (lflag) {
c01098ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01098b1:	74 16                	je     c01098c9 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01098b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01098b6:	8b 00                	mov    (%eax),%eax
c01098b8:	8d 48 04             	lea    0x4(%eax),%ecx
c01098bb:	8b 55 08             	mov    0x8(%ebp),%edx
c01098be:	89 0a                	mov    %ecx,(%edx)
c01098c0:	8b 00                	mov    (%eax),%eax
c01098c2:	ba 00 00 00 00       	mov    $0x0,%edx
c01098c7:	eb 14                	jmp    c01098dd <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01098c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01098cc:	8b 00                	mov    (%eax),%eax
c01098ce:	8d 48 04             	lea    0x4(%eax),%ecx
c01098d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01098d4:	89 0a                	mov    %ecx,(%edx)
c01098d6:	8b 00                	mov    (%eax),%eax
c01098d8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01098dd:	5d                   	pop    %ebp
c01098de:	c3                   	ret    

c01098df <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01098df:	55                   	push   %ebp
c01098e0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01098e2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01098e6:	7e 14                	jle    c01098fc <getint+0x1d>
        return va_arg(*ap, long long);
c01098e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01098eb:	8b 00                	mov    (%eax),%eax
c01098ed:	8d 48 08             	lea    0x8(%eax),%ecx
c01098f0:	8b 55 08             	mov    0x8(%ebp),%edx
c01098f3:	89 0a                	mov    %ecx,(%edx)
c01098f5:	8b 50 04             	mov    0x4(%eax),%edx
c01098f8:	8b 00                	mov    (%eax),%eax
c01098fa:	eb 28                	jmp    c0109924 <getint+0x45>
    }
    else if (lflag) {
c01098fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109900:	74 12                	je     c0109914 <getint+0x35>
        return va_arg(*ap, long);
c0109902:	8b 45 08             	mov    0x8(%ebp),%eax
c0109905:	8b 00                	mov    (%eax),%eax
c0109907:	8d 48 04             	lea    0x4(%eax),%ecx
c010990a:	8b 55 08             	mov    0x8(%ebp),%edx
c010990d:	89 0a                	mov    %ecx,(%edx)
c010990f:	8b 00                	mov    (%eax),%eax
c0109911:	99                   	cltd   
c0109912:	eb 10                	jmp    c0109924 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0109914:	8b 45 08             	mov    0x8(%ebp),%eax
c0109917:	8b 00                	mov    (%eax),%eax
c0109919:	8d 48 04             	lea    0x4(%eax),%ecx
c010991c:	8b 55 08             	mov    0x8(%ebp),%edx
c010991f:	89 0a                	mov    %ecx,(%edx)
c0109921:	8b 00                	mov    (%eax),%eax
c0109923:	99                   	cltd   
    }
}
c0109924:	5d                   	pop    %ebp
c0109925:	c3                   	ret    

c0109926 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109926:	55                   	push   %ebp
c0109927:	89 e5                	mov    %esp,%ebp
c0109929:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010992c:	8d 45 14             	lea    0x14(%ebp),%eax
c010992f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0109932:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109935:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109939:	8b 45 10             	mov    0x10(%ebp),%eax
c010993c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109940:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109943:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109947:	8b 45 08             	mov    0x8(%ebp),%eax
c010994a:	89 04 24             	mov    %eax,(%esp)
c010994d:	e8 02 00 00 00       	call   c0109954 <vprintfmt>
    va_end(ap);
}
c0109952:	c9                   	leave  
c0109953:	c3                   	ret    

c0109954 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0109954:	55                   	push   %ebp
c0109955:	89 e5                	mov    %esp,%ebp
c0109957:	56                   	push   %esi
c0109958:	53                   	push   %ebx
c0109959:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010995c:	eb 18                	jmp    c0109976 <vprintfmt+0x22>
            if (ch == '\0') {
c010995e:	85 db                	test   %ebx,%ebx
c0109960:	75 05                	jne    c0109967 <vprintfmt+0x13>
                return;
c0109962:	e9 d1 03 00 00       	jmp    c0109d38 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0109967:	8b 45 0c             	mov    0xc(%ebp),%eax
c010996a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010996e:	89 1c 24             	mov    %ebx,(%esp)
c0109971:	8b 45 08             	mov    0x8(%ebp),%eax
c0109974:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109976:	8b 45 10             	mov    0x10(%ebp),%eax
c0109979:	8d 50 01             	lea    0x1(%eax),%edx
c010997c:	89 55 10             	mov    %edx,0x10(%ebp)
c010997f:	0f b6 00             	movzbl (%eax),%eax
c0109982:	0f b6 d8             	movzbl %al,%ebx
c0109985:	83 fb 25             	cmp    $0x25,%ebx
c0109988:	75 d4                	jne    c010995e <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c010998a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010998e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0109995:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109998:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010999b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01099a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01099a5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01099a8:	8b 45 10             	mov    0x10(%ebp),%eax
c01099ab:	8d 50 01             	lea    0x1(%eax),%edx
c01099ae:	89 55 10             	mov    %edx,0x10(%ebp)
c01099b1:	0f b6 00             	movzbl (%eax),%eax
c01099b4:	0f b6 d8             	movzbl %al,%ebx
c01099b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01099ba:	83 f8 55             	cmp    $0x55,%eax
c01099bd:	0f 87 44 03 00 00    	ja     c0109d07 <vprintfmt+0x3b3>
c01099c3:	8b 04 85 b8 b3 10 c0 	mov    -0x3fef4c48(,%eax,4),%eax
c01099ca:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01099cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01099d0:	eb d6                	jmp    c01099a8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01099d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01099d6:	eb d0                	jmp    c01099a8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01099d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01099df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01099e2:	89 d0                	mov    %edx,%eax
c01099e4:	c1 e0 02             	shl    $0x2,%eax
c01099e7:	01 d0                	add    %edx,%eax
c01099e9:	01 c0                	add    %eax,%eax
c01099eb:	01 d8                	add    %ebx,%eax
c01099ed:	83 e8 30             	sub    $0x30,%eax
c01099f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01099f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01099f6:	0f b6 00             	movzbl (%eax),%eax
c01099f9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01099fc:	83 fb 2f             	cmp    $0x2f,%ebx
c01099ff:	7e 0b                	jle    c0109a0c <vprintfmt+0xb8>
c0109a01:	83 fb 39             	cmp    $0x39,%ebx
c0109a04:	7f 06                	jg     c0109a0c <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
c0109a06:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
c0109a0a:	eb d3                	jmp    c01099df <vprintfmt+0x8b>
            goto process_precision;
c0109a0c:	eb 33                	jmp    c0109a41 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0109a0e:	8b 45 14             	mov    0x14(%ebp),%eax
c0109a11:	8d 50 04             	lea    0x4(%eax),%edx
c0109a14:	89 55 14             	mov    %edx,0x14(%ebp)
c0109a17:	8b 00                	mov    (%eax),%eax
c0109a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0109a1c:	eb 23                	jmp    c0109a41 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0109a1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109a22:	79 0c                	jns    c0109a30 <vprintfmt+0xdc>
                width = 0;
c0109a24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0109a2b:	e9 78 ff ff ff       	jmp    c01099a8 <vprintfmt+0x54>
c0109a30:	e9 73 ff ff ff       	jmp    c01099a8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0109a35:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0109a3c:	e9 67 ff ff ff       	jmp    c01099a8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0109a41:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109a45:	79 12                	jns    c0109a59 <vprintfmt+0x105>
                width = precision, precision = -1;
c0109a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109a4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109a4d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0109a54:	e9 4f ff ff ff       	jmp    c01099a8 <vprintfmt+0x54>
c0109a59:	e9 4a ff ff ff       	jmp    c01099a8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0109a5e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0109a62:	e9 41 ff ff ff       	jmp    c01099a8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109a67:	8b 45 14             	mov    0x14(%ebp),%eax
c0109a6a:	8d 50 04             	lea    0x4(%eax),%edx
c0109a6d:	89 55 14             	mov    %edx,0x14(%ebp)
c0109a70:	8b 00                	mov    (%eax),%eax
c0109a72:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109a75:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109a79:	89 04 24             	mov    %eax,(%esp)
c0109a7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a7f:	ff d0                	call   *%eax
            break;
c0109a81:	e9 ac 02 00 00       	jmp    c0109d32 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109a86:	8b 45 14             	mov    0x14(%ebp),%eax
c0109a89:	8d 50 04             	lea    0x4(%eax),%edx
c0109a8c:	89 55 14             	mov    %edx,0x14(%ebp)
c0109a8f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0109a91:	85 db                	test   %ebx,%ebx
c0109a93:	79 02                	jns    c0109a97 <vprintfmt+0x143>
                err = -err;
c0109a95:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109a97:	83 fb 06             	cmp    $0x6,%ebx
c0109a9a:	7f 0b                	jg     c0109aa7 <vprintfmt+0x153>
c0109a9c:	8b 34 9d 78 b3 10 c0 	mov    -0x3fef4c88(,%ebx,4),%esi
c0109aa3:	85 f6                	test   %esi,%esi
c0109aa5:	75 23                	jne    c0109aca <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0109aa7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0109aab:	c7 44 24 08 a5 b3 10 	movl   $0xc010b3a5,0x8(%esp)
c0109ab2:	c0 
c0109ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0109abd:	89 04 24             	mov    %eax,(%esp)
c0109ac0:	e8 61 fe ff ff       	call   c0109926 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0109ac5:	e9 68 02 00 00       	jmp    c0109d32 <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
c0109aca:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0109ace:	c7 44 24 08 ae b3 10 	movl   $0xc010b3ae,0x8(%esp)
c0109ad5:	c0 
c0109ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109add:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ae0:	89 04 24             	mov    %eax,(%esp)
c0109ae3:	e8 3e fe ff ff       	call   c0109926 <printfmt>
            break;
c0109ae8:	e9 45 02 00 00       	jmp    c0109d32 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0109aed:	8b 45 14             	mov    0x14(%ebp),%eax
c0109af0:	8d 50 04             	lea    0x4(%eax),%edx
c0109af3:	89 55 14             	mov    %edx,0x14(%ebp)
c0109af6:	8b 30                	mov    (%eax),%esi
c0109af8:	85 f6                	test   %esi,%esi
c0109afa:	75 05                	jne    c0109b01 <vprintfmt+0x1ad>
                p = "(null)";
c0109afc:	be b1 b3 10 c0       	mov    $0xc010b3b1,%esi
            }
            if (width > 0 && padc != '-') {
c0109b01:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109b05:	7e 3e                	jle    c0109b45 <vprintfmt+0x1f1>
c0109b07:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0109b0b:	74 38                	je     c0109b45 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109b0d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0109b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109b13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109b17:	89 34 24             	mov    %esi,(%esp)
c0109b1a:	e8 dc f7 ff ff       	call   c01092fb <strnlen>
c0109b1f:	29 c3                	sub    %eax,%ebx
c0109b21:	89 d8                	mov    %ebx,%eax
c0109b23:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109b26:	eb 17                	jmp    c0109b3f <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0109b28:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0109b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109b2f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109b33:	89 04 24             	mov    %eax,(%esp)
c0109b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b39:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109b3b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109b3f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109b43:	7f e3                	jg     c0109b28 <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109b45:	eb 38                	jmp    c0109b7f <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109b47:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109b4b:	74 1f                	je     c0109b6c <vprintfmt+0x218>
c0109b4d:	83 fb 1f             	cmp    $0x1f,%ebx
c0109b50:	7e 05                	jle    c0109b57 <vprintfmt+0x203>
c0109b52:	83 fb 7e             	cmp    $0x7e,%ebx
c0109b55:	7e 15                	jle    c0109b6c <vprintfmt+0x218>
                    putch('?', putdat);
c0109b57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109b5e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0109b65:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b68:	ff d0                	call   *%eax
c0109b6a:	eb 0f                	jmp    c0109b7b <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0109b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109b73:	89 1c 24             	mov    %ebx,(%esp)
c0109b76:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b79:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109b7b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109b7f:	89 f0                	mov    %esi,%eax
c0109b81:	8d 70 01             	lea    0x1(%eax),%esi
c0109b84:	0f b6 00             	movzbl (%eax),%eax
c0109b87:	0f be d8             	movsbl %al,%ebx
c0109b8a:	85 db                	test   %ebx,%ebx
c0109b8c:	74 10                	je     c0109b9e <vprintfmt+0x24a>
c0109b8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109b92:	78 b3                	js     c0109b47 <vprintfmt+0x1f3>
c0109b94:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0109b98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109b9c:	79 a9                	jns    c0109b47 <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
c0109b9e:	eb 17                	jmp    c0109bb7 <vprintfmt+0x263>
                putch(' ', putdat);
c0109ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ba7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0109bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bb1:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0109bb3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109bb7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109bbb:	7f e3                	jg     c0109ba0 <vprintfmt+0x24c>
            }
            break;
c0109bbd:	e9 70 01 00 00       	jmp    c0109d32 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0109bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109bc9:	8d 45 14             	lea    0x14(%ebp),%eax
c0109bcc:	89 04 24             	mov    %eax,(%esp)
c0109bcf:	e8 0b fd ff ff       	call   c01098df <getint>
c0109bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109bd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0109bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109be0:	85 d2                	test   %edx,%edx
c0109be2:	79 26                	jns    c0109c0a <vprintfmt+0x2b6>
                putch('-', putdat);
c0109be4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109beb:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0109bf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bf5:	ff d0                	call   *%eax
                num = -(long long)num;
c0109bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109bfd:	f7 d8                	neg    %eax
c0109bff:	83 d2 00             	adc    $0x0,%edx
c0109c02:	f7 da                	neg    %edx
c0109c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c07:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109c0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109c11:	e9 a8 00 00 00       	jmp    c0109cbe <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109c16:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109c19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109c1d:	8d 45 14             	lea    0x14(%ebp),%eax
c0109c20:	89 04 24             	mov    %eax,(%esp)
c0109c23:	e8 68 fc ff ff       	call   c0109890 <getuint>
c0109c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109c2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109c35:	e9 84 00 00 00       	jmp    c0109cbe <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109c3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109c41:	8d 45 14             	lea    0x14(%ebp),%eax
c0109c44:	89 04 24             	mov    %eax,(%esp)
c0109c47:	e8 44 fc ff ff       	call   c0109890 <getuint>
c0109c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109c52:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109c59:	eb 63                	jmp    c0109cbe <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0109c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109c62:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0109c69:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c6c:	ff d0                	call   *%eax
            putch('x', putdat);
c0109c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109c75:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0109c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c7f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109c81:	8b 45 14             	mov    0x14(%ebp),%eax
c0109c84:	8d 50 04             	lea    0x4(%eax),%edx
c0109c87:	89 55 14             	mov    %edx,0x14(%ebp)
c0109c8a:	8b 00                	mov    (%eax),%eax
c0109c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109c96:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109c9d:	eb 1f                	jmp    c0109cbe <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ca6:	8d 45 14             	lea    0x14(%ebp),%eax
c0109ca9:	89 04 24             	mov    %eax,(%esp)
c0109cac:	e8 df fb ff ff       	call   c0109890 <getuint>
c0109cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109cb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109cb7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0109cbe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0109cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109cc5:	89 54 24 18          	mov    %edx,0x18(%esp)
c0109cc9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109ccc:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109cd0:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109cd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109cda:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109cde:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ce9:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cec:	89 04 24             	mov    %eax,(%esp)
c0109cef:	e8 97 fa ff ff       	call   c010978b <printnum>
            break;
c0109cf4:	eb 3c                	jmp    c0109d32 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0109cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109cfd:	89 1c 24             	mov    %ebx,(%esp)
c0109d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d03:	ff d0                	call   *%eax
            break;
c0109d05:	eb 2b                	jmp    c0109d32 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0109d07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d0e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0109d15:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d18:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109d1a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109d1e:	eb 04                	jmp    c0109d24 <vprintfmt+0x3d0>
c0109d20:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109d24:	8b 45 10             	mov    0x10(%ebp),%eax
c0109d27:	83 e8 01             	sub    $0x1,%eax
c0109d2a:	0f b6 00             	movzbl (%eax),%eax
c0109d2d:	3c 25                	cmp    $0x25,%al
c0109d2f:	75 ef                	jne    c0109d20 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0109d31:	90                   	nop
        }
    }
c0109d32:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109d33:	e9 3e fc ff ff       	jmp    c0109976 <vprintfmt+0x22>
}
c0109d38:	83 c4 40             	add    $0x40,%esp
c0109d3b:	5b                   	pop    %ebx
c0109d3c:	5e                   	pop    %esi
c0109d3d:	5d                   	pop    %ebp
c0109d3e:	c3                   	ret    

c0109d3f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109d3f:	55                   	push   %ebp
c0109d40:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109d42:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d45:	8b 40 08             	mov    0x8(%eax),%eax
c0109d48:	8d 50 01             	lea    0x1(%eax),%edx
c0109d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d4e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0109d51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d54:	8b 10                	mov    (%eax),%edx
c0109d56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d59:	8b 40 04             	mov    0x4(%eax),%eax
c0109d5c:	39 c2                	cmp    %eax,%edx
c0109d5e:	73 12                	jae    c0109d72 <sprintputch+0x33>
        *b->buf ++ = ch;
c0109d60:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d63:	8b 00                	mov    (%eax),%eax
c0109d65:	8d 48 01             	lea    0x1(%eax),%ecx
c0109d68:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109d6b:	89 0a                	mov    %ecx,(%edx)
c0109d6d:	8b 55 08             	mov    0x8(%ebp),%edx
c0109d70:	88 10                	mov    %dl,(%eax)
    }
}
c0109d72:	5d                   	pop    %ebp
c0109d73:	c3                   	ret    

c0109d74 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109d74:	55                   	push   %ebp
c0109d75:	89 e5                	mov    %esp,%ebp
c0109d77:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109d7a:	8d 45 14             	lea    0x14(%ebp),%eax
c0109d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0109d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d83:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109d87:	8b 45 10             	mov    0x10(%ebp),%eax
c0109d8a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d95:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d98:	89 04 24             	mov    %eax,(%esp)
c0109d9b:	e8 08 00 00 00       	call   c0109da8 <vsnprintf>
c0109da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109da6:	c9                   	leave  
c0109da7:	c3                   	ret    

c0109da8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109da8:	55                   	push   %ebp
c0109da9:	89 e5                	mov    %esp,%ebp
c0109dab:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0109dae:	8b 45 08             	mov    0x8(%ebp),%eax
c0109db1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109db4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109db7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109dba:	8b 45 08             	mov    0x8(%ebp),%eax
c0109dbd:	01 d0                	add    %edx,%eax
c0109dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109dc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0109dc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109dcd:	74 0a                	je     c0109dd9 <vsnprintf+0x31>
c0109dcf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109dd5:	39 c2                	cmp    %eax,%edx
c0109dd7:	76 07                	jbe    c0109de0 <vsnprintf+0x38>
        return -E_INVAL;
c0109dd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0109dde:	eb 2a                	jmp    c0109e0a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109de0:	8b 45 14             	mov    0x14(%ebp),%eax
c0109de3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109de7:	8b 45 10             	mov    0x10(%ebp),%eax
c0109dea:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109dee:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0109df1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109df5:	c7 04 24 3f 9d 10 c0 	movl   $0xc0109d3f,(%esp)
c0109dfc:	e8 53 fb ff ff       	call   c0109954 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0109e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e04:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0109e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109e0a:	c9                   	leave  
c0109e0b:	c3                   	ret    
