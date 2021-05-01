
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 d0 11 40 	lgdtl  0x4011d018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 d0 11 00       	mov    $0x11d000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 84 e9 11 00       	mov    $0x11e984,%edx
  100035:	b8 36 da 11 00       	mov    $0x11da36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 da 11 00 	movl   $0x11da36,(%esp)
  100051:	e8 ac 95 00 00       	call   109602 <memset>

    cons_init();                // init the console
  100056:	e8 83 15 00 00       	call   1015de <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 20 9e 10 00 	movl   $0x109e20,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 3c 9e 10 00 	movl   $0x109e3c,(%esp)
  100070:	e8 1c 02 00 00       	call   100291 <cprintf>

    print_kerninfo();
  100075:	e8 bd 08 00 00       	call   100937 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 4b 32 00 00       	call   1032cf <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b2 16 00 00       	call   10173b <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 10 18 00 00       	call   10189e <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 01 0d 00 00       	call   100d94 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 de 17 00 00       	call   101876 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 c6 0c 00 00       	call   100d82 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 da 11 00       	mov    0x11da40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 41 9e 10 00 	movl   $0x109e41,(%esp)
  10015c:	e8 30 01 00 00       	call   100291 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 da 11 00       	mov    0x11da40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 4f 9e 10 00 	movl   $0x109e4f,(%esp)
  10017c:	e8 10 01 00 00       	call   100291 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 da 11 00       	mov    0x11da40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 5d 9e 10 00 	movl   $0x109e5d,(%esp)
  10019c:	e8 f0 00 00 00       	call   100291 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 da 11 00       	mov    0x11da40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 6b 9e 10 00 	movl   $0x109e6b,(%esp)
  1001bc:	e8 d0 00 00 00       	call   100291 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 da 11 00       	mov    0x11da40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 79 9e 10 00 	movl   $0x109e79,(%esp)
  1001dc:	e8 b0 00 00 00       	call   100291 <cprintf>
    round ++;
  1001e1:	a1 40 da 11 00       	mov    0x11da40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 da 11 00       	mov    %eax,0x11da40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile(
  1001f3:	83 ec 08             	sub    $0x8,%esp
  1001f6:	cd 78                	int    $0x78
  1001f8:	89 ec                	mov    %ebp,%esp
		"int %0 \n"//调用 T_SWITCH_TOU 中断
		"movl %%ebp,%%esp"//恢复栈指针
		:
		: "i"(T_SWITCH_TOU)
	);
}
  1001fa:	5d                   	pop    %ebp
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	//把tf->tf_cs和tf->tf_ds都设置为内核代码段和内核数据段
	asm volatile(
  1001ff:	cd 79                	int    $0x79
  100201:	89 ec                	mov    %ebp,%esp
		"int %0 \n"// //调用T_SWITCH_TOK号中断
		"movl %%ebp, %%esp \n"//强行改为内核态，会让cpu认为没有发生特权级转换，%esp的值就不对了
		:
		: "i"(T_SWITCH_TOK)
	);
}
  100203:	5d                   	pop    %ebp
  100204:	c3                   	ret    

00100205 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100205:	55                   	push   %ebp
  100206:	89 e5                	mov    %esp,%ebp
  100208:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020b:	e8 1a ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100210:	c7 04 24 88 9e 10 00 	movl   $0x109e88,(%esp)
  100217:	e8 75 00 00 00       	call   100291 <cprintf>
    lab1_switch_to_user();
  10021c:	e8 cf ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100221:	e8 04 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100226:	c7 04 24 a8 9e 10 00 	movl   $0x109ea8,(%esp)
  10022d:	e8 5f 00 00 00       	call   100291 <cprintf>
    lab1_switch_to_kernel();
  100232:	e8 c5 ff ff ff       	call   1001fc <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100237:	e8 ee fe ff ff       	call   10012a <lab1_print_cur_status>
}
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100244:	8b 45 08             	mov    0x8(%ebp),%eax
  100247:	89 04 24             	mov    %eax,(%esp)
  10024a:	e8 bb 13 00 00       	call   10160a <cons_putc>
    (*cnt) ++;
  10024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100252:	8b 00                	mov    (%eax),%eax
  100254:	8d 50 01             	lea    0x1(%eax),%edx
  100257:	8b 45 0c             	mov    0xc(%ebp),%eax
  10025a:	89 10                	mov    %edx,(%eax)
}
  10025c:	c9                   	leave  
  10025d:	c3                   	ret    

0010025e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025e:	55                   	push   %ebp
  10025f:	89 e5                	mov    %esp,%ebp
  100261:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100264:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10026e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100272:	8b 45 08             	mov    0x8(%ebp),%eax
  100275:	89 44 24 08          	mov    %eax,0x8(%esp)
  100279:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100280:	c7 04 24 3e 02 10 00 	movl   $0x10023e,(%esp)
  100287:	e8 c8 96 00 00       	call   109954 <vprintfmt>
    return cnt;
  10028c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028f:	c9                   	leave  
  100290:	c3                   	ret    

00100291 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100291:	55                   	push   %ebp
  100292:	89 e5                	mov    %esp,%ebp
  100294:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100297:	8d 45 0c             	lea    0xc(%ebp),%eax
  10029a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10029d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a7:	89 04 24             	mov    %eax,(%esp)
  1002aa:	e8 af ff ff ff       	call   10025e <vcprintf>
  1002af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002b5:	c9                   	leave  
  1002b6:	c3                   	ret    

001002b7 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002b7:	55                   	push   %ebp
  1002b8:	89 e5                	mov    %esp,%ebp
  1002ba:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c0:	89 04 24             	mov    %eax,(%esp)
  1002c3:	e8 42 13 00 00       	call   10160a <cons_putc>
}
  1002c8:	c9                   	leave  
  1002c9:	c3                   	ret    

001002ca <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002ca:	55                   	push   %ebp
  1002cb:	89 e5                	mov    %esp,%ebp
  1002cd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002d7:	eb 13                	jmp    1002ec <cputs+0x22>
        cputch(c, &cnt);
  1002d9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002dd:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002e4:	89 04 24             	mov    %eax,(%esp)
  1002e7:	e8 52 ff ff ff       	call   10023e <cputch>
    while ((c = *str ++) != '\0') {
  1002ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ef:	8d 50 01             	lea    0x1(%eax),%edx
  1002f2:	89 55 08             	mov    %edx,0x8(%ebp)
  1002f5:	0f b6 00             	movzbl (%eax),%eax
  1002f8:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002fb:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002ff:	75 d8                	jne    1002d9 <cputs+0xf>
    }
    cputch('\n', &cnt);
  100301:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100304:	89 44 24 04          	mov    %eax,0x4(%esp)
  100308:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10030f:	e8 2a ff ff ff       	call   10023e <cputch>
    return cnt;
  100314:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100317:	c9                   	leave  
  100318:	c3                   	ret    

00100319 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100319:	55                   	push   %ebp
  10031a:	89 e5                	mov    %esp,%ebp
  10031c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  10031f:	e8 22 13 00 00       	call   101646 <cons_getc>
  100324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10032b:	74 f2                	je     10031f <getchar+0x6>
        /* do nothing */;
    return c;
  10032d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100330:	c9                   	leave  
  100331:	c3                   	ret    

00100332 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100332:	55                   	push   %ebp
  100333:	89 e5                	mov    %esp,%ebp
  100335:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10033c:	74 13                	je     100351 <readline+0x1f>
        cprintf("%s", prompt);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 44 24 04          	mov    %eax,0x4(%esp)
  100345:	c7 04 24 c7 9e 10 00 	movl   $0x109ec7,(%esp)
  10034c:	e8 40 ff ff ff       	call   100291 <cprintf>
    }
    int i = 0, c;
  100351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100358:	e8 bc ff ff ff       	call   100319 <getchar>
  10035d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100360:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100364:	79 07                	jns    10036d <readline+0x3b>
            return NULL;
  100366:	b8 00 00 00 00       	mov    $0x0,%eax
  10036b:	eb 79                	jmp    1003e6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10036d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100371:	7e 28                	jle    10039b <readline+0x69>
  100373:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10037a:	7f 1f                	jg     10039b <readline+0x69>
            cputchar(c);
  10037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10037f:	89 04 24             	mov    %eax,(%esp)
  100382:	e8 30 ff ff ff       	call   1002b7 <cputchar>
            buf[i ++] = c;
  100387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10038a:	8d 50 01             	lea    0x1(%eax),%edx
  10038d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100390:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100393:	88 90 60 da 11 00    	mov    %dl,0x11da60(%eax)
  100399:	eb 46                	jmp    1003e1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10039b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10039f:	75 17                	jne    1003b8 <readline+0x86>
  1003a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003a5:	7e 11                	jle    1003b8 <readline+0x86>
            cputchar(c);
  1003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003aa:	89 04 24             	mov    %eax,(%esp)
  1003ad:	e8 05 ff ff ff       	call   1002b7 <cputchar>
            i --;
  1003b2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1003b6:	eb 29                	jmp    1003e1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1003b8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003bc:	74 06                	je     1003c4 <readline+0x92>
  1003be:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003c2:	75 1d                	jne    1003e1 <readline+0xaf>
            cputchar(c);
  1003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c7:	89 04 24             	mov    %eax,(%esp)
  1003ca:	e8 e8 fe ff ff       	call   1002b7 <cputchar>
            buf[i] = '\0';
  1003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d2:	05 60 da 11 00       	add    $0x11da60,%eax
  1003d7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003da:	b8 60 da 11 00       	mov    $0x11da60,%eax
  1003df:	eb 05                	jmp    1003e6 <readline+0xb4>
        }
    }
  1003e1:	e9 72 ff ff ff       	jmp    100358 <readline+0x26>
}
  1003e6:	c9                   	leave  
  1003e7:	c3                   	ret    

001003e8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003e8:	55                   	push   %ebp
  1003e9:	89 e5                	mov    %esp,%ebp
  1003eb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003ee:	a1 60 de 11 00       	mov    0x11de60,%eax
  1003f3:	85 c0                	test   %eax,%eax
  1003f5:	74 02                	je     1003f9 <__panic+0x11>
        goto panic_dead;
  1003f7:	eb 48                	jmp    100441 <__panic+0x59>
    }
    is_panic = 1;
  1003f9:	c7 05 60 de 11 00 01 	movl   $0x1,0x11de60
  100400:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100403:	8d 45 14             	lea    0x14(%ebp),%eax
  100406:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100409:	8b 45 0c             	mov    0xc(%ebp),%eax
  10040c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100410:	8b 45 08             	mov    0x8(%ebp),%eax
  100413:	89 44 24 04          	mov    %eax,0x4(%esp)
  100417:	c7 04 24 ca 9e 10 00 	movl   $0x109eca,(%esp)
  10041e:	e8 6e fe ff ff       	call   100291 <cprintf>
    vcprintf(fmt, ap);
  100423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100426:	89 44 24 04          	mov    %eax,0x4(%esp)
  10042a:	8b 45 10             	mov    0x10(%ebp),%eax
  10042d:	89 04 24             	mov    %eax,(%esp)
  100430:	e8 29 fe ff ff       	call   10025e <vcprintf>
    cprintf("\n");
  100435:	c7 04 24 e6 9e 10 00 	movl   $0x109ee6,(%esp)
  10043c:	e8 50 fe ff ff       	call   100291 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100441:	e8 36 14 00 00       	call   10187c <intr_disable>
    while (1) {
        kmonitor(NULL);
  100446:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10044d:	e8 61 08 00 00       	call   100cb3 <kmonitor>
    }
  100452:	eb f2                	jmp    100446 <__panic+0x5e>

00100454 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100454:	55                   	push   %ebp
  100455:	89 e5                	mov    %esp,%ebp
  100457:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10045a:	8d 45 14             	lea    0x14(%ebp),%eax
  10045d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100460:	8b 45 0c             	mov    0xc(%ebp),%eax
  100463:	89 44 24 08          	mov    %eax,0x8(%esp)
  100467:	8b 45 08             	mov    0x8(%ebp),%eax
  10046a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046e:	c7 04 24 e8 9e 10 00 	movl   $0x109ee8,(%esp)
  100475:	e8 17 fe ff ff       	call   100291 <cprintf>
    vcprintf(fmt, ap);
  10047a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10047d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100481:	8b 45 10             	mov    0x10(%ebp),%eax
  100484:	89 04 24             	mov    %eax,(%esp)
  100487:	e8 d2 fd ff ff       	call   10025e <vcprintf>
    cprintf("\n");
  10048c:	c7 04 24 e6 9e 10 00 	movl   $0x109ee6,(%esp)
  100493:	e8 f9 fd ff ff       	call   100291 <cprintf>
    va_end(ap);
}
  100498:	c9                   	leave  
  100499:	c3                   	ret    

0010049a <is_kernel_panic>:

bool
is_kernel_panic(void) {
  10049a:	55                   	push   %ebp
  10049b:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10049d:	a1 60 de 11 00       	mov    0x11de60,%eax
}
  1004a2:	5d                   	pop    %ebp
  1004a3:	c3                   	ret    

001004a4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004a4:	55                   	push   %ebp
  1004a5:	89 e5                	mov    %esp,%ebp
  1004a7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ad:	8b 00                	mov    (%eax),%eax
  1004af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b5:	8b 00                	mov    (%eax),%eax
  1004b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004c1:	e9 d2 00 00 00       	jmp    100598 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004cc:	01 d0                	add    %edx,%eax
  1004ce:	89 c2                	mov    %eax,%edx
  1004d0:	c1 ea 1f             	shr    $0x1f,%edx
  1004d3:	01 d0                	add    %edx,%eax
  1004d5:	d1 f8                	sar    %eax
  1004d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004dd:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004e0:	eb 04                	jmp    1004e6 <stab_binsearch+0x42>
            m --;
  1004e2:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ec:	7c 1f                	jl     10050d <stab_binsearch+0x69>
  1004ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f1:	89 d0                	mov    %edx,%eax
  1004f3:	01 c0                	add    %eax,%eax
  1004f5:	01 d0                	add    %edx,%eax
  1004f7:	c1 e0 02             	shl    $0x2,%eax
  1004fa:	89 c2                	mov    %eax,%edx
  1004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ff:	01 d0                	add    %edx,%eax
  100501:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100505:	0f b6 c0             	movzbl %al,%eax
  100508:	3b 45 14             	cmp    0x14(%ebp),%eax
  10050b:	75 d5                	jne    1004e2 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  10050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100510:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100513:	7d 0b                	jge    100520 <stab_binsearch+0x7c>
            l = true_m + 1;
  100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100518:	83 c0 01             	add    $0x1,%eax
  10051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10051e:	eb 78                	jmp    100598 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100520:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100527:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052a:	89 d0                	mov    %edx,%eax
  10052c:	01 c0                	add    %eax,%eax
  10052e:	01 d0                	add    %edx,%eax
  100530:	c1 e0 02             	shl    $0x2,%eax
  100533:	89 c2                	mov    %eax,%edx
  100535:	8b 45 08             	mov    0x8(%ebp),%eax
  100538:	01 d0                	add    %edx,%eax
  10053a:	8b 40 08             	mov    0x8(%eax),%eax
  10053d:	3b 45 18             	cmp    0x18(%ebp),%eax
  100540:	73 13                	jae    100555 <stab_binsearch+0xb1>
            *region_left = m;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100548:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10054a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10054d:	83 c0 01             	add    $0x1,%eax
  100550:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100553:	eb 43                	jmp    100598 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100555:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100558:	89 d0                	mov    %edx,%eax
  10055a:	01 c0                	add    %eax,%eax
  10055c:	01 d0                	add    %edx,%eax
  10055e:	c1 e0 02             	shl    $0x2,%eax
  100561:	89 c2                	mov    %eax,%edx
  100563:	8b 45 08             	mov    0x8(%ebp),%eax
  100566:	01 d0                	add    %edx,%eax
  100568:	8b 40 08             	mov    0x8(%eax),%eax
  10056b:	3b 45 18             	cmp    0x18(%ebp),%eax
  10056e:	76 16                	jbe    100586 <stab_binsearch+0xe2>
            *region_right = m - 1;
  100570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100573:	8d 50 ff             	lea    -0x1(%eax),%edx
  100576:	8b 45 10             	mov    0x10(%ebp),%eax
  100579:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10057b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057e:	83 e8 01             	sub    $0x1,%eax
  100581:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100584:	eb 12                	jmp    100598 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100586:	8b 45 0c             	mov    0xc(%ebp),%eax
  100589:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058c:	89 10                	mov    %edx,(%eax)
            l = m;
  10058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100591:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100594:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100598:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10059b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10059e:	0f 8e 22 ff ff ff    	jle    1004c6 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005a8:	75 0f                	jne    1005b9 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ad:	8b 00                	mov    (%eax),%eax
  1005af:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1005b5:	89 10                	mov    %edx,(%eax)
  1005b7:	eb 3f                	jmp    1005f8 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1005bc:	8b 00                	mov    (%eax),%eax
  1005be:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005c1:	eb 04                	jmp    1005c7 <stab_binsearch+0x123>
  1005c3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ca:	8b 00                	mov    (%eax),%eax
  1005cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005cf:	7d 1f                	jge    1005f0 <stab_binsearch+0x14c>
  1005d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005d4:	89 d0                	mov    %edx,%eax
  1005d6:	01 c0                	add    %eax,%eax
  1005d8:	01 d0                	add    %edx,%eax
  1005da:	c1 e0 02             	shl    $0x2,%eax
  1005dd:	89 c2                	mov    %eax,%edx
  1005df:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e2:	01 d0                	add    %edx,%eax
  1005e4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005e8:	0f b6 c0             	movzbl %al,%eax
  1005eb:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005ee:	75 d3                	jne    1005c3 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005f6:	89 10                	mov    %edx,(%eax)
    }
}
  1005f8:	c9                   	leave  
  1005f9:	c3                   	ret    

001005fa <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005fa:	55                   	push   %ebp
  1005fb:	89 e5                	mov    %esp,%ebp
  1005fd:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100600:	8b 45 0c             	mov    0xc(%ebp),%eax
  100603:	c7 00 08 9f 10 00    	movl   $0x109f08,(%eax)
    info->eip_line = 0;
  100609:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100613:	8b 45 0c             	mov    0xc(%ebp),%eax
  100616:	c7 40 08 08 9f 10 00 	movl   $0x109f08,0x8(%eax)
    info->eip_fn_namelen = 9;
  10061d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100620:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100627:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062a:	8b 55 08             	mov    0x8(%ebp),%edx
  10062d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100630:	8b 45 0c             	mov    0xc(%ebp),%eax
  100633:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10063a:	c7 45 f4 10 b5 10 00 	movl   $0x10b510,-0xc(%ebp)
    stab_end = __STAB_END__;
  100641:	c7 45 f0 90 7c 11 00 	movl   $0x117c90,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100648:	c7 45 ec 91 7c 11 00 	movl   $0x117c91,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10064f:	c7 45 e8 00 aa 11 00 	movl   $0x11aa00,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100659:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10065c:	76 0d                	jbe    10066b <debuginfo_eip+0x71>
  10065e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100661:	83 e8 01             	sub    $0x1,%eax
  100664:	0f b6 00             	movzbl (%eax),%eax
  100667:	84 c0                	test   %al,%al
  100669:	74 0a                	je     100675 <debuginfo_eip+0x7b>
        return -1;
  10066b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100670:	e9 c0 02 00 00       	jmp    100935 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100675:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10067c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10067f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100682:	29 c2                	sub    %eax,%edx
  100684:	89 d0                	mov    %edx,%eax
  100686:	c1 f8 02             	sar    $0x2,%eax
  100689:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10068f:	83 e8 01             	sub    $0x1,%eax
  100692:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100695:	8b 45 08             	mov    0x8(%ebp),%eax
  100698:	89 44 24 10          	mov    %eax,0x10(%esp)
  10069c:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006a3:	00 
  1006a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006b5:	89 04 24             	mov    %eax,(%esp)
  1006b8:	e8 e7 fd ff ff       	call   1004a4 <stab_binsearch>
    if (lfile == 0)
  1006bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c0:	85 c0                	test   %eax,%eax
  1006c2:	75 0a                	jne    1006ce <debuginfo_eip+0xd4>
        return -1;
  1006c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006c9:	e9 67 02 00 00       	jmp    100935 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006da:	8b 45 08             	mov    0x8(%ebp),%eax
  1006dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e1:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006e8:	00 
  1006e9:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006fa:	89 04 24             	mov    %eax,(%esp)
  1006fd:	e8 a2 fd ff ff       	call   1004a4 <stab_binsearch>

    if (lfun <= rfun) {
  100702:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100705:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100708:	39 c2                	cmp    %eax,%edx
  10070a:	7f 7c                	jg     100788 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10070c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10070f:	89 c2                	mov    %eax,%edx
  100711:	89 d0                	mov    %edx,%eax
  100713:	01 c0                	add    %eax,%eax
  100715:	01 d0                	add    %edx,%eax
  100717:	c1 e0 02             	shl    $0x2,%eax
  10071a:	89 c2                	mov    %eax,%edx
  10071c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071f:	01 d0                	add    %edx,%eax
  100721:	8b 10                	mov    (%eax),%edx
  100723:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100726:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100729:	29 c1                	sub    %eax,%ecx
  10072b:	89 c8                	mov    %ecx,%eax
  10072d:	39 c2                	cmp    %eax,%edx
  10072f:	73 22                	jae    100753 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100731:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100734:	89 c2                	mov    %eax,%edx
  100736:	89 d0                	mov    %edx,%eax
  100738:	01 c0                	add    %eax,%eax
  10073a:	01 d0                	add    %edx,%eax
  10073c:	c1 e0 02             	shl    $0x2,%eax
  10073f:	89 c2                	mov    %eax,%edx
  100741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100744:	01 d0                	add    %edx,%eax
  100746:	8b 10                	mov    (%eax),%edx
  100748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10074b:	01 c2                	add    %eax,%edx
  10074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100750:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100753:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100756:	89 c2                	mov    %eax,%edx
  100758:	89 d0                	mov    %edx,%eax
  10075a:	01 c0                	add    %eax,%eax
  10075c:	01 d0                	add    %edx,%eax
  10075e:	c1 e0 02             	shl    $0x2,%eax
  100761:	89 c2                	mov    %eax,%edx
  100763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100766:	01 d0                	add    %edx,%eax
  100768:	8b 50 08             	mov    0x8(%eax),%edx
  10076b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076e:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100771:	8b 45 0c             	mov    0xc(%ebp),%eax
  100774:	8b 40 10             	mov    0x10(%eax),%eax
  100777:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10077a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10077d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100780:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100783:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100786:	eb 15                	jmp    10079d <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100788:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078b:	8b 55 08             	mov    0x8(%ebp),%edx
  10078e:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100794:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10079a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10079d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a0:	8b 40 08             	mov    0x8(%eax),%eax
  1007a3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007aa:	00 
  1007ab:	89 04 24             	mov    %eax,(%esp)
  1007ae:	e8 c3 8c 00 00       	call   109476 <strfind>
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b8:	8b 40 08             	mov    0x8(%eax),%eax
  1007bb:	29 c2                	sub    %eax,%edx
  1007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c0:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1007c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007ca:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007d1:	00 
  1007d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e3:	89 04 24             	mov    %eax,(%esp)
  1007e6:	e8 b9 fc ff ff       	call   1004a4 <stab_binsearch>
    if (lline <= rline) {
  1007eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7f 24                	jg     100819 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  1007f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f8:	89 c2                	mov    %eax,%edx
  1007fa:	89 d0                	mov    %edx,%eax
  1007fc:	01 c0                	add    %eax,%eax
  1007fe:	01 d0                	add    %edx,%eax
  100800:	c1 e0 02             	shl    $0x2,%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10080e:	0f b7 d0             	movzwl %ax,%edx
  100811:	8b 45 0c             	mov    0xc(%ebp),%eax
  100814:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100817:	eb 13                	jmp    10082c <debuginfo_eip+0x232>
        return -1;
  100819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10081e:	e9 12 01 00 00       	jmp    100935 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100823:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100826:	83 e8 01             	sub    $0x1,%eax
  100829:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10082c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100832:	39 c2                	cmp    %eax,%edx
  100834:	7c 56                	jl     10088c <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	89 d0                	mov    %edx,%eax
  10083d:	01 c0                	add    %eax,%eax
  10083f:	01 d0                	add    %edx,%eax
  100841:	c1 e0 02             	shl    $0x2,%eax
  100844:	89 c2                	mov    %eax,%edx
  100846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100849:	01 d0                	add    %edx,%eax
  10084b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084f:	3c 84                	cmp    $0x84,%al
  100851:	74 39                	je     10088c <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100856:	89 c2                	mov    %eax,%edx
  100858:	89 d0                	mov    %edx,%eax
  10085a:	01 c0                	add    %eax,%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	c1 e0 02             	shl    $0x2,%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10086c:	3c 64                	cmp    $0x64,%al
  10086e:	75 b3                	jne    100823 <debuginfo_eip+0x229>
  100870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100873:	89 c2                	mov    %eax,%edx
  100875:	89 d0                	mov    %edx,%eax
  100877:	01 c0                	add    %eax,%eax
  100879:	01 d0                	add    %edx,%eax
  10087b:	c1 e0 02             	shl    $0x2,%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100883:	01 d0                	add    %edx,%eax
  100885:	8b 40 08             	mov    0x8(%eax),%eax
  100888:	85 c0                	test   %eax,%eax
  10088a:	74 97                	je     100823 <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10088c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10088f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100892:	39 c2                	cmp    %eax,%edx
  100894:	7c 46                	jl     1008dc <debuginfo_eip+0x2e2>
  100896:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100899:	89 c2                	mov    %eax,%edx
  10089b:	89 d0                	mov    %edx,%eax
  10089d:	01 c0                	add    %eax,%eax
  10089f:	01 d0                	add    %edx,%eax
  1008a1:	c1 e0 02             	shl    $0x2,%eax
  1008a4:	89 c2                	mov    %eax,%edx
  1008a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a9:	01 d0                	add    %edx,%eax
  1008ab:	8b 10                	mov    (%eax),%edx
  1008ad:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008b3:	29 c1                	sub    %eax,%ecx
  1008b5:	89 c8                	mov    %ecx,%eax
  1008b7:	39 c2                	cmp    %eax,%edx
  1008b9:	73 21                	jae    1008dc <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008be:	89 c2                	mov    %eax,%edx
  1008c0:	89 d0                	mov    %edx,%eax
  1008c2:	01 c0                	add    %eax,%eax
  1008c4:	01 d0                	add    %edx,%eax
  1008c6:	c1 e0 02             	shl    $0x2,%eax
  1008c9:	89 c2                	mov    %eax,%edx
  1008cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ce:	01 d0                	add    %edx,%eax
  1008d0:	8b 10                	mov    (%eax),%edx
  1008d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008d5:	01 c2                	add    %eax,%edx
  1008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008da:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008e2:	39 c2                	cmp    %eax,%edx
  1008e4:	7d 4a                	jge    100930 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1008e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008e9:	83 c0 01             	add    $0x1,%eax
  1008ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008ef:	eb 18                	jmp    100909 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f4:	8b 40 14             	mov    0x14(%eax),%eax
  1008f7:	8d 50 01             	lea    0x1(%eax),%edx
  1008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fd:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100903:	83 c0 01             	add    $0x1,%eax
  100906:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100909:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10090c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10090f:	39 c2                	cmp    %eax,%edx
  100911:	7d 1d                	jge    100930 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100913:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100916:	89 c2                	mov    %eax,%edx
  100918:	89 d0                	mov    %edx,%eax
  10091a:	01 c0                	add    %eax,%eax
  10091c:	01 d0                	add    %edx,%eax
  10091e:	c1 e0 02             	shl    $0x2,%eax
  100921:	89 c2                	mov    %eax,%edx
  100923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100926:	01 d0                	add    %edx,%eax
  100928:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10092c:	3c a0                	cmp    $0xa0,%al
  10092e:	74 c1                	je     1008f1 <debuginfo_eip+0x2f7>
        }
    }
    return 0;
  100930:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100935:	c9                   	leave  
  100936:	c3                   	ret    

00100937 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100937:	55                   	push   %ebp
  100938:	89 e5                	mov    %esp,%ebp
  10093a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10093d:	c7 04 24 12 9f 10 00 	movl   $0x109f12,(%esp)
  100944:	e8 48 f9 ff ff       	call   100291 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100949:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100950:	00 
  100951:	c7 04 24 2b 9f 10 00 	movl   $0x109f2b,(%esp)
  100958:	e8 34 f9 ff ff       	call   100291 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10095d:	c7 44 24 04 0c 9e 10 	movl   $0x109e0c,0x4(%esp)
  100964:	00 
  100965:	c7 04 24 43 9f 10 00 	movl   $0x109f43,(%esp)
  10096c:	e8 20 f9 ff ff       	call   100291 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100971:	c7 44 24 04 36 da 11 	movl   $0x11da36,0x4(%esp)
  100978:	00 
  100979:	c7 04 24 5b 9f 10 00 	movl   $0x109f5b,(%esp)
  100980:	e8 0c f9 ff ff       	call   100291 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100985:	c7 44 24 04 84 e9 11 	movl   $0x11e984,0x4(%esp)
  10098c:	00 
  10098d:	c7 04 24 73 9f 10 00 	movl   $0x109f73,(%esp)
  100994:	e8 f8 f8 ff ff       	call   100291 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100999:	b8 84 e9 11 00       	mov    $0x11e984,%eax
  10099e:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009a4:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1009a9:	29 c2                	sub    %eax,%edx
  1009ab:	89 d0                	mov    %edx,%eax
  1009ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009b3:	85 c0                	test   %eax,%eax
  1009b5:	0f 48 c2             	cmovs  %edx,%eax
  1009b8:	c1 f8 0a             	sar    $0xa,%eax
  1009bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009bf:	c7 04 24 8c 9f 10 00 	movl   $0x109f8c,(%esp)
  1009c6:	e8 c6 f8 ff ff       	call   100291 <cprintf>
}
  1009cb:	c9                   	leave  
  1009cc:	c3                   	ret    

001009cd <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009cd:	55                   	push   %ebp
  1009ce:	89 e5                	mov    %esp,%ebp
  1009d0:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e0:	89 04 24             	mov    %eax,(%esp)
  1009e3:	e8 12 fc ff ff       	call   1005fa <debuginfo_eip>
  1009e8:	85 c0                	test   %eax,%eax
  1009ea:	74 15                	je     100a01 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f3:	c7 04 24 b6 9f 10 00 	movl   $0x109fb6,(%esp)
  1009fa:	e8 92 f8 ff ff       	call   100291 <cprintf>
  1009ff:	eb 6d                	jmp    100a6e <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a08:	eb 1c                	jmp    100a26 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100a0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a10:	01 d0                	add    %edx,%eax
  100a12:	0f b6 00             	movzbl (%eax),%eax
  100a15:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a1e:	01 ca                	add    %ecx,%edx
  100a20:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a2c:	7f dc                	jg     100a0a <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
  100a2e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a37:	01 d0                	add    %edx,%eax
  100a39:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a3f:	8b 55 08             	mov    0x8(%ebp),%edx
  100a42:	89 d1                	mov    %edx,%ecx
  100a44:	29 c1                	sub    %eax,%ecx
  100a46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a50:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a56:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a5a:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a62:	c7 04 24 d2 9f 10 00 	movl   $0x109fd2,(%esp)
  100a69:	e8 23 f8 ff ff       	call   100291 <cprintf>
    }
}
  100a6e:	c9                   	leave  
  100a6f:	c3                   	ret    

00100a70 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a70:	55                   	push   %ebp
  100a71:	89 e5                	mov    %esp,%ebp
  100a73:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a76:	8b 45 04             	mov    0x4(%ebp),%eax
  100a79:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a7f:	c9                   	leave  
  100a80:	c3                   	ret    

00100a81 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a81:	55                   	push   %ebp
  100a82:	89 e5                	mov    %esp,%ebp
  100a84:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a87:	89 e8                	mov    %ebp,%eax
  100a89:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t v_ebp=read_ebp();
  100a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t v_eip=read_eip();
  100a92:	e8 d9 ff ff ff       	call   100a70 <read_eip>
  100a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for(i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
  100a9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100aa1:	e9 8f 00 00 00       	jmp    100b35 <print_stackframe+0xb4>
	{
		cprintf("ebp: 0x%08x , eip: 0x%08x , ",v_ebp,v_eip);
  100aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aa9:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab4:	c7 04 24 e4 9f 10 00 	movl   $0x109fe4,(%esp)
  100abb:	e8 d1 f7 ff ff       	call   100291 <cprintf>
		uint32_t *args=(uint32_t *)v_ebp +2;
  100ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac3:	83 c0 08             	add    $0x8,%eax
  100ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int j;
		for(j=0;j<4;++j)
  100ac9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100ad0:	eb 2c                	jmp    100afe <print_stackframe+0x7d>
		{
			cprintf("args[%d] = 0x%08x   ",j,args[j]);
  100ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ad5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100adf:	01 d0                	add    %edx,%eax
  100ae1:	8b 00                	mov    (%eax),%eax
  100ae3:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aee:	c7 04 24 01 a0 10 00 	movl   $0x10a001,(%esp)
  100af5:	e8 97 f7 ff ff       	call   100291 <cprintf>
		for(j=0;j<4;++j)
  100afa:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100afe:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b02:	7e ce                	jle    100ad2 <print_stackframe+0x51>
		}
		cprintf("\n");
  100b04:	c7 04 24 16 a0 10 00 	movl   $0x10a016,(%esp)
  100b0b:	e8 81 f7 ff ff       	call   100291 <cprintf>
		print_debuginfo(v_eip-1);
  100b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b13:	83 e8 01             	sub    $0x1,%eax
  100b16:	89 04 24             	mov    %eax,(%esp)
  100b19:	e8 af fe ff ff       	call   1009cd <print_debuginfo>
		v_eip=((uint32_t *)v_ebp)[1];
  100b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b21:	83 c0 04             	add    $0x4,%eax
  100b24:	8b 00                	mov    (%eax),%eax
  100b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
		v_ebp=((uint32_t *)v_ebp)[0];
  100b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b2c:	8b 00                	mov    (%eax),%eax
  100b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
  100b31:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b35:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b39:	7f 0a                	jg     100b45 <print_stackframe+0xc4>
  100b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b3f:	0f 85 61 ff ff ff    	jne    100aa6 <print_stackframe+0x25>
	}


}
  100b45:	c9                   	leave  
  100b46:	c3                   	ret    

00100b47 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b47:	55                   	push   %ebp
  100b48:	89 e5                	mov    %esp,%ebp
  100b4a:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b54:	eb 0c                	jmp    100b62 <parse+0x1b>
            *buf ++ = '\0';
  100b56:	8b 45 08             	mov    0x8(%ebp),%eax
  100b59:	8d 50 01             	lea    0x1(%eax),%edx
  100b5c:	89 55 08             	mov    %edx,0x8(%ebp)
  100b5f:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b62:	8b 45 08             	mov    0x8(%ebp),%eax
  100b65:	0f b6 00             	movzbl (%eax),%eax
  100b68:	84 c0                	test   %al,%al
  100b6a:	74 1d                	je     100b89 <parse+0x42>
  100b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6f:	0f b6 00             	movzbl (%eax),%eax
  100b72:	0f be c0             	movsbl %al,%eax
  100b75:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b79:	c7 04 24 98 a0 10 00 	movl   $0x10a098,(%esp)
  100b80:	e8 be 88 00 00       	call   109443 <strchr>
  100b85:	85 c0                	test   %eax,%eax
  100b87:	75 cd                	jne    100b56 <parse+0xf>
        }
        if (*buf == '\0') {
  100b89:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8c:	0f b6 00             	movzbl (%eax),%eax
  100b8f:	84 c0                	test   %al,%al
  100b91:	75 02                	jne    100b95 <parse+0x4e>
            break;
  100b93:	eb 67                	jmp    100bfc <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b95:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b99:	75 14                	jne    100baf <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b9b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ba2:	00 
  100ba3:	c7 04 24 9d a0 10 00 	movl   $0x10a09d,(%esp)
  100baa:	e8 e2 f6 ff ff       	call   100291 <cprintf>
        }
        argv[argc ++] = buf;
  100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb2:	8d 50 01             	lea    0x1(%eax),%edx
  100bb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bc2:	01 c2                	add    %eax,%edx
  100bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bc9:	eb 04                	jmp    100bcf <parse+0x88>
            buf ++;
  100bcb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd2:	0f b6 00             	movzbl (%eax),%eax
  100bd5:	84 c0                	test   %al,%al
  100bd7:	74 1d                	je     100bf6 <parse+0xaf>
  100bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdc:	0f b6 00             	movzbl (%eax),%eax
  100bdf:	0f be c0             	movsbl %al,%eax
  100be2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be6:	c7 04 24 98 a0 10 00 	movl   $0x10a098,(%esp)
  100bed:	e8 51 88 00 00       	call   109443 <strchr>
  100bf2:	85 c0                	test   %eax,%eax
  100bf4:	74 d5                	je     100bcb <parse+0x84>
        }
    }
  100bf6:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bf7:	e9 66 ff ff ff       	jmp    100b62 <parse+0x1b>
    return argc;
  100bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bff:	c9                   	leave  
  100c00:	c3                   	ret    

00100c01 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c01:	55                   	push   %ebp
  100c02:	89 e5                	mov    %esp,%ebp
  100c04:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c07:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 04 24             	mov    %eax,(%esp)
  100c14:	e8 2e ff ff ff       	call   100b47 <parse>
  100c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c20:	75 0a                	jne    100c2c <runcmd+0x2b>
        return 0;
  100c22:	b8 00 00 00 00       	mov    $0x0,%eax
  100c27:	e9 85 00 00 00       	jmp    100cb1 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c33:	eb 5c                	jmp    100c91 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c35:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3b:	89 d0                	mov    %edx,%eax
  100c3d:	01 c0                	add    %eax,%eax
  100c3f:	01 d0                	add    %edx,%eax
  100c41:	c1 e0 02             	shl    $0x2,%eax
  100c44:	05 20 d0 11 00       	add    $0x11d020,%eax
  100c49:	8b 00                	mov    (%eax),%eax
  100c4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c4f:	89 04 24             	mov    %eax,(%esp)
  100c52:	e8 4d 87 00 00       	call   1093a4 <strcmp>
  100c57:	85 c0                	test   %eax,%eax
  100c59:	75 32                	jne    100c8d <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5e:	89 d0                	mov    %edx,%eax
  100c60:	01 c0                	add    %eax,%eax
  100c62:	01 d0                	add    %edx,%eax
  100c64:	c1 e0 02             	shl    $0x2,%eax
  100c67:	05 20 d0 11 00       	add    $0x11d020,%eax
  100c6c:	8b 40 08             	mov    0x8(%eax),%eax
  100c6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c72:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c78:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c7c:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c7f:	83 c2 04             	add    $0x4,%edx
  100c82:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c86:	89 0c 24             	mov    %ecx,(%esp)
  100c89:	ff d0                	call   *%eax
  100c8b:	eb 24                	jmp    100cb1 <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c94:	83 f8 02             	cmp    $0x2,%eax
  100c97:	76 9c                	jbe    100c35 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca0:	c7 04 24 bb a0 10 00 	movl   $0x10a0bb,(%esp)
  100ca7:	e8 e5 f5 ff ff       	call   100291 <cprintf>
    return 0;
  100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb1:	c9                   	leave  
  100cb2:	c3                   	ret    

00100cb3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cb3:	55                   	push   %ebp
  100cb4:	89 e5                	mov    %esp,%ebp
  100cb6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cb9:	c7 04 24 d4 a0 10 00 	movl   $0x10a0d4,(%esp)
  100cc0:	e8 cc f5 ff ff       	call   100291 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cc5:	c7 04 24 fc a0 10 00 	movl   $0x10a0fc,(%esp)
  100ccc:	e8 c0 f5 ff ff       	call   100291 <cprintf>

    if (tf != NULL) {
  100cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cd5:	74 0b                	je     100ce2 <kmonitor+0x2f>
        print_trapframe(tf);
  100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cda:	89 04 24             	mov    %eax,(%esp)
  100cdd:	e8 f8 0d 00 00       	call   101ada <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100ce2:	c7 04 24 21 a1 10 00 	movl   $0x10a121,(%esp)
  100ce9:	e8 44 f6 ff ff       	call   100332 <readline>
  100cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cf5:	74 18                	je     100d0f <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d01:	89 04 24             	mov    %eax,(%esp)
  100d04:	e8 f8 fe ff ff       	call   100c01 <runcmd>
  100d09:	85 c0                	test   %eax,%eax
  100d0b:	79 02                	jns    100d0f <kmonitor+0x5c>
                break;
  100d0d:	eb 02                	jmp    100d11 <kmonitor+0x5e>
            }
        }
    }
  100d0f:	eb d1                	jmp    100ce2 <kmonitor+0x2f>
}
  100d11:	c9                   	leave  
  100d12:	c3                   	ret    

00100d13 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d13:	55                   	push   %ebp
  100d14:	89 e5                	mov    %esp,%ebp
  100d16:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d20:	eb 3f                	jmp    100d61 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d25:	89 d0                	mov    %edx,%eax
  100d27:	01 c0                	add    %eax,%eax
  100d29:	01 d0                	add    %edx,%eax
  100d2b:	c1 e0 02             	shl    $0x2,%eax
  100d2e:	05 20 d0 11 00       	add    $0x11d020,%eax
  100d33:	8b 48 04             	mov    0x4(%eax),%ecx
  100d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d39:	89 d0                	mov    %edx,%eax
  100d3b:	01 c0                	add    %eax,%eax
  100d3d:	01 d0                	add    %edx,%eax
  100d3f:	c1 e0 02             	shl    $0x2,%eax
  100d42:	05 20 d0 11 00       	add    $0x11d020,%eax
  100d47:	8b 00                	mov    (%eax),%eax
  100d49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d51:	c7 04 24 25 a1 10 00 	movl   $0x10a125,(%esp)
  100d58:	e8 34 f5 ff ff       	call   100291 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d5d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d64:	83 f8 02             	cmp    $0x2,%eax
  100d67:	76 b9                	jbe    100d22 <mon_help+0xf>
    }
    return 0;
  100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d6e:	c9                   	leave  
  100d6f:	c3                   	ret    

00100d70 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d70:	55                   	push   %ebp
  100d71:	89 e5                	mov    %esp,%ebp
  100d73:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d76:	e8 bc fb ff ff       	call   100937 <print_kerninfo>
    return 0;
  100d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d80:	c9                   	leave  
  100d81:	c3                   	ret    

00100d82 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d88:	e8 f4 fc ff ff       	call   100a81 <print_stackframe>
    return 0;
  100d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d92:	c9                   	leave  
  100d93:	c3                   	ret    

00100d94 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d94:	55                   	push   %ebp
  100d95:	89 e5                	mov    %esp,%ebp
  100d97:	83 ec 28             	sub    $0x28,%esp
  100d9a:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100da0:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100da4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100da8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dac:	ee                   	out    %al,(%dx)
  100dad:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100db3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100db7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dbb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dbf:	ee                   	out    %al,(%dx)
  100dc0:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dc6:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dca:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dce:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dd3:	c7 05 68 e9 11 00 00 	movl   $0x0,0x11e968
  100dda:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100ddd:	c7 04 24 2e a1 10 00 	movl   $0x10a12e,(%esp)
  100de4:	e8 a8 f4 ff ff       	call   100291 <cprintf>
    pic_enable(IRQ_TIMER);
  100de9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df0:	e8 18 09 00 00       	call   10170d <pic_enable>
}
  100df5:	c9                   	leave  
  100df6:	c3                   	ret    

00100df7 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100df7:	55                   	push   %ebp
  100df8:	89 e5                	mov    %esp,%ebp
  100dfa:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dfd:	9c                   	pushf  
  100dfe:	58                   	pop    %eax
  100dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e05:	25 00 02 00 00       	and    $0x200,%eax
  100e0a:	85 c0                	test   %eax,%eax
  100e0c:	74 0c                	je     100e1a <__intr_save+0x23>
        intr_disable();
  100e0e:	e8 69 0a 00 00       	call   10187c <intr_disable>
        return 1;
  100e13:	b8 01 00 00 00       	mov    $0x1,%eax
  100e18:	eb 05                	jmp    100e1f <__intr_save+0x28>
    }
    return 0;
  100e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e1f:	c9                   	leave  
  100e20:	c3                   	ret    

00100e21 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e21:	55                   	push   %ebp
  100e22:	89 e5                	mov    %esp,%ebp
  100e24:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e2b:	74 05                	je     100e32 <__intr_restore+0x11>
        intr_enable();
  100e2d:	e8 44 0a 00 00       	call   101876 <intr_enable>
    }
}
  100e32:	c9                   	leave  
  100e33:	c3                   	ret    

00100e34 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e34:	55                   	push   %ebp
  100e35:	89 e5                	mov    %esp,%ebp
  100e37:	83 ec 10             	sub    $0x10,%esp
  100e3a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e40:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e44:	89 c2                	mov    %eax,%edx
  100e46:	ec                   	in     (%dx),%al
  100e47:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e4a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e50:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e54:	89 c2                	mov    %eax,%edx
  100e56:	ec                   	in     (%dx),%al
  100e57:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e5a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e60:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e64:	89 c2                	mov    %eax,%edx
  100e66:	ec                   	in     (%dx),%al
  100e67:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e6a:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e70:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e74:	89 c2                	mov    %eax,%edx
  100e76:	ec                   	in     (%dx),%al
  100e77:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e7a:	c9                   	leave  
  100e7b:	c3                   	ret    

00100e7c <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e7c:	55                   	push   %ebp
  100e7d:	89 e5                	mov    %esp,%ebp
  100e7f:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e82:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8c:	0f b7 00             	movzwl (%eax),%eax
  100e8f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e96:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9e:	0f b7 00             	movzwl (%eax),%eax
  100ea1:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100ea5:	74 12                	je     100eb9 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ea7:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100eae:	66 c7 05 86 de 11 00 	movw   $0x3b4,0x11de86
  100eb5:	b4 03 
  100eb7:	eb 13                	jmp    100ecc <cga_init+0x50>
    } else {
        *cp = was;
  100eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ec0:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ec3:	66 c7 05 86 de 11 00 	movw   $0x3d4,0x11de86
  100eca:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ecc:	0f b7 05 86 de 11 00 	movzwl 0x11de86,%eax
  100ed3:	0f b7 c0             	movzwl %ax,%eax
  100ed6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100eda:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ede:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ee2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ee6:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ee7:	0f b7 05 86 de 11 00 	movzwl 0x11de86,%eax
  100eee:	83 c0 01             	add    $0x1,%eax
  100ef1:	0f b7 c0             	movzwl %ax,%eax
  100ef4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ef8:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100efc:	89 c2                	mov    %eax,%edx
  100efe:	ec                   	in     (%dx),%al
  100eff:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f02:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f06:	0f b6 c0             	movzbl %al,%eax
  100f09:	c1 e0 08             	shl    $0x8,%eax
  100f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f0f:	0f b7 05 86 de 11 00 	movzwl 0x11de86,%eax
  100f16:	0f b7 c0             	movzwl %ax,%eax
  100f19:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f1d:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f21:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f25:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f29:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f2a:	0f b7 05 86 de 11 00 	movzwl 0x11de86,%eax
  100f31:	83 c0 01             	add    $0x1,%eax
  100f34:	0f b7 c0             	movzwl %ax,%eax
  100f37:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f3b:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f3f:	89 c2                	mov    %eax,%edx
  100f41:	ec                   	in     (%dx),%al
  100f42:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f49:	0f b6 c0             	movzbl %al,%eax
  100f4c:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f52:	a3 80 de 11 00       	mov    %eax,0x11de80
    crt_pos = pos;
  100f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f5a:	66 a3 84 de 11 00    	mov    %ax,0x11de84
}
  100f60:	c9                   	leave  
  100f61:	c3                   	ret    

00100f62 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f62:	55                   	push   %ebp
  100f63:	89 e5                	mov    %esp,%ebp
  100f65:	83 ec 48             	sub    $0x48,%esp
  100f68:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f6e:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f72:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f76:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f7a:	ee                   	out    %al,(%dx)
  100f7b:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f81:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f85:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f89:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f8d:	ee                   	out    %al,(%dx)
  100f8e:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f94:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f98:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f9c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fa0:	ee                   	out    %al,(%dx)
  100fa1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa7:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fab:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100faf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fb3:	ee                   	out    %al,(%dx)
  100fb4:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fba:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fbe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fc2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fc6:	ee                   	out    %al,(%dx)
  100fc7:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fcd:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fd1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fd5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd9:	ee                   	out    %al,(%dx)
  100fda:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fe0:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fe4:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe8:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fec:	ee                   	out    %al,(%dx)
  100fed:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ff3:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100ff7:	89 c2                	mov    %eax,%edx
  100ff9:	ec                   	in     (%dx),%al
  100ffa:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ffd:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101001:	3c ff                	cmp    $0xff,%al
  101003:	0f 95 c0             	setne  %al
  101006:	0f b6 c0             	movzbl %al,%eax
  101009:	a3 88 de 11 00       	mov    %eax,0x11de88
  10100e:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101014:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101018:	89 c2                	mov    %eax,%edx
  10101a:	ec                   	in     (%dx),%al
  10101b:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10101e:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101024:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101028:	89 c2                	mov    %eax,%edx
  10102a:	ec                   	in     (%dx),%al
  10102b:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10102e:	a1 88 de 11 00       	mov    0x11de88,%eax
  101033:	85 c0                	test   %eax,%eax
  101035:	74 0c                	je     101043 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101037:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10103e:	e8 ca 06 00 00       	call   10170d <pic_enable>
    }
}
  101043:	c9                   	leave  
  101044:	c3                   	ret    

00101045 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101045:	55                   	push   %ebp
  101046:	89 e5                	mov    %esp,%ebp
  101048:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101052:	eb 09                	jmp    10105d <lpt_putc_sub+0x18>
        delay();
  101054:	e8 db fd ff ff       	call   100e34 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101059:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10105d:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101063:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101067:	89 c2                	mov    %eax,%edx
  101069:	ec                   	in     (%dx),%al
  10106a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10106d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101071:	84 c0                	test   %al,%al
  101073:	78 09                	js     10107e <lpt_putc_sub+0x39>
  101075:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10107c:	7e d6                	jle    101054 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  10107e:	8b 45 08             	mov    0x8(%ebp),%eax
  101081:	0f b6 c0             	movzbl %al,%eax
  101084:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10108a:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10108d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101091:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101095:	ee                   	out    %al,(%dx)
  101096:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10109c:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010a0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010a4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010a8:	ee                   	out    %al,(%dx)
  1010a9:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010af:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010b3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010b7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010bb:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010bc:	c9                   	leave  
  1010bd:	c3                   	ret    

001010be <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010be:	55                   	push   %ebp
  1010bf:	89 e5                	mov    %esp,%ebp
  1010c1:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010c4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010c8:	74 0d                	je     1010d7 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cd:	89 04 24             	mov    %eax,(%esp)
  1010d0:	e8 70 ff ff ff       	call   101045 <lpt_putc_sub>
  1010d5:	eb 24                	jmp    1010fb <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010de:	e8 62 ff ff ff       	call   101045 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010e3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010ea:	e8 56 ff ff ff       	call   101045 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010ef:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010f6:	e8 4a ff ff ff       	call   101045 <lpt_putc_sub>
    }
}
  1010fb:	c9                   	leave  
  1010fc:	c3                   	ret    

001010fd <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010fd:	55                   	push   %ebp
  1010fe:	89 e5                	mov    %esp,%ebp
  101100:	53                   	push   %ebx
  101101:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101104:	8b 45 08             	mov    0x8(%ebp),%eax
  101107:	b0 00                	mov    $0x0,%al
  101109:	85 c0                	test   %eax,%eax
  10110b:	75 07                	jne    101114 <cga_putc+0x17>
        c |= 0x0700;
  10110d:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101114:	8b 45 08             	mov    0x8(%ebp),%eax
  101117:	0f b6 c0             	movzbl %al,%eax
  10111a:	83 f8 0a             	cmp    $0xa,%eax
  10111d:	74 4c                	je     10116b <cga_putc+0x6e>
  10111f:	83 f8 0d             	cmp    $0xd,%eax
  101122:	74 57                	je     10117b <cga_putc+0x7e>
  101124:	83 f8 08             	cmp    $0x8,%eax
  101127:	0f 85 88 00 00 00    	jne    1011b5 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10112d:	0f b7 05 84 de 11 00 	movzwl 0x11de84,%eax
  101134:	66 85 c0             	test   %ax,%ax
  101137:	74 30                	je     101169 <cga_putc+0x6c>
            crt_pos --;
  101139:	0f b7 05 84 de 11 00 	movzwl 0x11de84,%eax
  101140:	83 e8 01             	sub    $0x1,%eax
  101143:	66 a3 84 de 11 00    	mov    %ax,0x11de84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101149:	a1 80 de 11 00       	mov    0x11de80,%eax
  10114e:	0f b7 15 84 de 11 00 	movzwl 0x11de84,%edx
  101155:	0f b7 d2             	movzwl %dx,%edx
  101158:	01 d2                	add    %edx,%edx
  10115a:	01 c2                	add    %eax,%edx
  10115c:	8b 45 08             	mov    0x8(%ebp),%eax
  10115f:	b0 00                	mov    $0x0,%al
  101161:	83 c8 20             	or     $0x20,%eax
  101164:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101167:	eb 72                	jmp    1011db <cga_putc+0xde>
  101169:	eb 70                	jmp    1011db <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10116b:	0f b7 05 84 de 11 00 	movzwl 0x11de84,%eax
  101172:	83 c0 50             	add    $0x50,%eax
  101175:	66 a3 84 de 11 00    	mov    %ax,0x11de84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10117b:	0f b7 1d 84 de 11 00 	movzwl 0x11de84,%ebx
  101182:	0f b7 0d 84 de 11 00 	movzwl 0x11de84,%ecx
  101189:	0f b7 c1             	movzwl %cx,%eax
  10118c:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101192:	c1 e8 10             	shr    $0x10,%eax
  101195:	89 c2                	mov    %eax,%edx
  101197:	66 c1 ea 06          	shr    $0x6,%dx
  10119b:	89 d0                	mov    %edx,%eax
  10119d:	c1 e0 02             	shl    $0x2,%eax
  1011a0:	01 d0                	add    %edx,%eax
  1011a2:	c1 e0 04             	shl    $0x4,%eax
  1011a5:	29 c1                	sub    %eax,%ecx
  1011a7:	89 ca                	mov    %ecx,%edx
  1011a9:	89 d8                	mov    %ebx,%eax
  1011ab:	29 d0                	sub    %edx,%eax
  1011ad:	66 a3 84 de 11 00    	mov    %ax,0x11de84
        break;
  1011b3:	eb 26                	jmp    1011db <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011b5:	8b 0d 80 de 11 00    	mov    0x11de80,%ecx
  1011bb:	0f b7 05 84 de 11 00 	movzwl 0x11de84,%eax
  1011c2:	8d 50 01             	lea    0x1(%eax),%edx
  1011c5:	66 89 15 84 de 11 00 	mov    %dx,0x11de84
  1011cc:	0f b7 c0             	movzwl %ax,%eax
  1011cf:	01 c0                	add    %eax,%eax
  1011d1:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1011d7:	66 89 02             	mov    %ax,(%edx)
        break;
  1011da:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011db:	0f b7 05 84 de 11 00 	movzwl 0x11de84,%eax
  1011e2:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011e6:	76 5b                	jbe    101243 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011e8:	a1 80 de 11 00       	mov    0x11de80,%eax
  1011ed:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011f3:	a1 80 de 11 00       	mov    0x11de80,%eax
  1011f8:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ff:	00 
  101200:	89 54 24 04          	mov    %edx,0x4(%esp)
  101204:	89 04 24             	mov    %eax,(%esp)
  101207:	e8 35 84 00 00       	call   109641 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10120c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101213:	eb 15                	jmp    10122a <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101215:	a1 80 de 11 00       	mov    0x11de80,%eax
  10121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10121d:	01 d2                	add    %edx,%edx
  10121f:	01 d0                	add    %edx,%eax
  101221:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101226:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10122a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101231:	7e e2                	jle    101215 <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
  101233:	0f b7 05 84 de 11 00 	movzwl 0x11de84,%eax
  10123a:	83 e8 50             	sub    $0x50,%eax
  10123d:	66 a3 84 de 11 00    	mov    %ax,0x11de84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101243:	0f b7 05 86 de 11 00 	movzwl 0x11de86,%eax
  10124a:	0f b7 c0             	movzwl %ax,%eax
  10124d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101251:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101255:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101259:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10125d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10125e:	0f b7 05 84 de 11 00 	movzwl 0x11de84,%eax
  101265:	66 c1 e8 08          	shr    $0x8,%ax
  101269:	0f b6 c0             	movzbl %al,%eax
  10126c:	0f b7 15 86 de 11 00 	movzwl 0x11de86,%edx
  101273:	83 c2 01             	add    $0x1,%edx
  101276:	0f b7 d2             	movzwl %dx,%edx
  101279:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10127d:	88 45 ed             	mov    %al,-0x13(%ebp)
  101280:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101284:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101288:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101289:	0f b7 05 86 de 11 00 	movzwl 0x11de86,%eax
  101290:	0f b7 c0             	movzwl %ax,%eax
  101293:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101297:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10129b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10129f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012a3:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012a4:	0f b7 05 84 de 11 00 	movzwl 0x11de84,%eax
  1012ab:	0f b6 c0             	movzbl %al,%eax
  1012ae:	0f b7 15 86 de 11 00 	movzwl 0x11de86,%edx
  1012b5:	83 c2 01             	add    $0x1,%edx
  1012b8:	0f b7 d2             	movzwl %dx,%edx
  1012bb:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012bf:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012c2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012c6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012ca:	ee                   	out    %al,(%dx)
}
  1012cb:	83 c4 34             	add    $0x34,%esp
  1012ce:	5b                   	pop    %ebx
  1012cf:	5d                   	pop    %ebp
  1012d0:	c3                   	ret    

001012d1 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012d1:	55                   	push   %ebp
  1012d2:	89 e5                	mov    %esp,%ebp
  1012d4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012de:	eb 09                	jmp    1012e9 <serial_putc_sub+0x18>
        delay();
  1012e0:	e8 4f fb ff ff       	call   100e34 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012e9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012ef:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012f3:	89 c2                	mov    %eax,%edx
  1012f5:	ec                   	in     (%dx),%al
  1012f6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012fd:	0f b6 c0             	movzbl %al,%eax
  101300:	83 e0 20             	and    $0x20,%eax
  101303:	85 c0                	test   %eax,%eax
  101305:	75 09                	jne    101310 <serial_putc_sub+0x3f>
  101307:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10130e:	7e d0                	jle    1012e0 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101310:	8b 45 08             	mov    0x8(%ebp),%eax
  101313:	0f b6 c0             	movzbl %al,%eax
  101316:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10131c:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10131f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101323:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101327:	ee                   	out    %al,(%dx)
}
  101328:	c9                   	leave  
  101329:	c3                   	ret    

0010132a <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10132a:	55                   	push   %ebp
  10132b:	89 e5                	mov    %esp,%ebp
  10132d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101330:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101334:	74 0d                	je     101343 <serial_putc+0x19>
        serial_putc_sub(c);
  101336:	8b 45 08             	mov    0x8(%ebp),%eax
  101339:	89 04 24             	mov    %eax,(%esp)
  10133c:	e8 90 ff ff ff       	call   1012d1 <serial_putc_sub>
  101341:	eb 24                	jmp    101367 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101343:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10134a:	e8 82 ff ff ff       	call   1012d1 <serial_putc_sub>
        serial_putc_sub(' ');
  10134f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101356:	e8 76 ff ff ff       	call   1012d1 <serial_putc_sub>
        serial_putc_sub('\b');
  10135b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101362:	e8 6a ff ff ff       	call   1012d1 <serial_putc_sub>
    }
}
  101367:	c9                   	leave  
  101368:	c3                   	ret    

00101369 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101369:	55                   	push   %ebp
  10136a:	89 e5                	mov    %esp,%ebp
  10136c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10136f:	eb 33                	jmp    1013a4 <cons_intr+0x3b>
        if (c != 0) {
  101371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101375:	74 2d                	je     1013a4 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101377:	a1 a4 e0 11 00       	mov    0x11e0a4,%eax
  10137c:	8d 50 01             	lea    0x1(%eax),%edx
  10137f:	89 15 a4 e0 11 00    	mov    %edx,0x11e0a4
  101385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101388:	88 90 a0 de 11 00    	mov    %dl,0x11dea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10138e:	a1 a4 e0 11 00       	mov    0x11e0a4,%eax
  101393:	3d 00 02 00 00       	cmp    $0x200,%eax
  101398:	75 0a                	jne    1013a4 <cons_intr+0x3b>
                cons.wpos = 0;
  10139a:	c7 05 a4 e0 11 00 00 	movl   $0x0,0x11e0a4
  1013a1:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a7:	ff d0                	call   *%eax
  1013a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013b0:	75 bf                	jne    101371 <cons_intr+0x8>
            }
        }
    }
}
  1013b2:	c9                   	leave  
  1013b3:	c3                   	ret    

001013b4 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013b4:	55                   	push   %ebp
  1013b5:	89 e5                	mov    %esp,%ebp
  1013b7:	83 ec 10             	sub    $0x10,%esp
  1013ba:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013c0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013c4:	89 c2                	mov    %eax,%edx
  1013c6:	ec                   	in     (%dx),%al
  1013c7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013ca:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013ce:	0f b6 c0             	movzbl %al,%eax
  1013d1:	83 e0 01             	and    $0x1,%eax
  1013d4:	85 c0                	test   %eax,%eax
  1013d6:	75 07                	jne    1013df <serial_proc_data+0x2b>
        return -1;
  1013d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013dd:	eb 2a                	jmp    101409 <serial_proc_data+0x55>
  1013df:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013e5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e9:	89 c2                	mov    %eax,%edx
  1013eb:	ec                   	in     (%dx),%al
  1013ec:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013ef:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013f3:	0f b6 c0             	movzbl %al,%eax
  1013f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f9:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013fd:	75 07                	jne    101406 <serial_proc_data+0x52>
        c = '\b';
  1013ff:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101406:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101409:	c9                   	leave  
  10140a:	c3                   	ret    

0010140b <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10140b:	55                   	push   %ebp
  10140c:	89 e5                	mov    %esp,%ebp
  10140e:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101411:	a1 88 de 11 00       	mov    0x11de88,%eax
  101416:	85 c0                	test   %eax,%eax
  101418:	74 0c                	je     101426 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10141a:	c7 04 24 b4 13 10 00 	movl   $0x1013b4,(%esp)
  101421:	e8 43 ff ff ff       	call   101369 <cons_intr>
    }
}
  101426:	c9                   	leave  
  101427:	c3                   	ret    

00101428 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101428:	55                   	push   %ebp
  101429:	89 e5                	mov    %esp,%ebp
  10142b:	83 ec 38             	sub    $0x38,%esp
  10142e:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101434:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101438:	89 c2                	mov    %eax,%edx
  10143a:	ec                   	in     (%dx),%al
  10143b:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10143e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101442:	0f b6 c0             	movzbl %al,%eax
  101445:	83 e0 01             	and    $0x1,%eax
  101448:	85 c0                	test   %eax,%eax
  10144a:	75 0a                	jne    101456 <kbd_proc_data+0x2e>
        return -1;
  10144c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101451:	e9 59 01 00 00       	jmp    1015af <kbd_proc_data+0x187>
  101456:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10145c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101460:	89 c2                	mov    %eax,%edx
  101462:	ec                   	in     (%dx),%al
  101463:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101466:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10146a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10146d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101471:	75 17                	jne    10148a <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101473:	a1 a8 e0 11 00       	mov    0x11e0a8,%eax
  101478:	83 c8 40             	or     $0x40,%eax
  10147b:	a3 a8 e0 11 00       	mov    %eax,0x11e0a8
        return 0;
  101480:	b8 00 00 00 00       	mov    $0x0,%eax
  101485:	e9 25 01 00 00       	jmp    1015af <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10148a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148e:	84 c0                	test   %al,%al
  101490:	79 47                	jns    1014d9 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101492:	a1 a8 e0 11 00       	mov    0x11e0a8,%eax
  101497:	83 e0 40             	and    $0x40,%eax
  10149a:	85 c0                	test   %eax,%eax
  10149c:	75 09                	jne    1014a7 <kbd_proc_data+0x7f>
  10149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a2:	83 e0 7f             	and    $0x7f,%eax
  1014a5:	eb 04                	jmp    1014ab <kbd_proc_data+0x83>
  1014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ab:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014ae:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b2:	0f b6 80 60 d0 11 00 	movzbl 0x11d060(%eax),%eax
  1014b9:	83 c8 40             	or     $0x40,%eax
  1014bc:	0f b6 c0             	movzbl %al,%eax
  1014bf:	f7 d0                	not    %eax
  1014c1:	89 c2                	mov    %eax,%edx
  1014c3:	a1 a8 e0 11 00       	mov    0x11e0a8,%eax
  1014c8:	21 d0                	and    %edx,%eax
  1014ca:	a3 a8 e0 11 00       	mov    %eax,0x11e0a8
        return 0;
  1014cf:	b8 00 00 00 00       	mov    $0x0,%eax
  1014d4:	e9 d6 00 00 00       	jmp    1015af <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014d9:	a1 a8 e0 11 00       	mov    0x11e0a8,%eax
  1014de:	83 e0 40             	and    $0x40,%eax
  1014e1:	85 c0                	test   %eax,%eax
  1014e3:	74 11                	je     1014f6 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014e5:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e9:	a1 a8 e0 11 00       	mov    0x11e0a8,%eax
  1014ee:	83 e0 bf             	and    $0xffffffbf,%eax
  1014f1:	a3 a8 e0 11 00       	mov    %eax,0x11e0a8
    }

    shift |= shiftcode[data];
  1014f6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014fa:	0f b6 80 60 d0 11 00 	movzbl 0x11d060(%eax),%eax
  101501:	0f b6 d0             	movzbl %al,%edx
  101504:	a1 a8 e0 11 00       	mov    0x11e0a8,%eax
  101509:	09 d0                	or     %edx,%eax
  10150b:	a3 a8 e0 11 00       	mov    %eax,0x11e0a8
    shift ^= togglecode[data];
  101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101514:	0f b6 80 60 d1 11 00 	movzbl 0x11d160(%eax),%eax
  10151b:	0f b6 d0             	movzbl %al,%edx
  10151e:	a1 a8 e0 11 00       	mov    0x11e0a8,%eax
  101523:	31 d0                	xor    %edx,%eax
  101525:	a3 a8 e0 11 00       	mov    %eax,0x11e0a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10152a:	a1 a8 e0 11 00       	mov    0x11e0a8,%eax
  10152f:	83 e0 03             	and    $0x3,%eax
  101532:	8b 14 85 60 d5 11 00 	mov    0x11d560(,%eax,4),%edx
  101539:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10153d:	01 d0                	add    %edx,%eax
  10153f:	0f b6 00             	movzbl (%eax),%eax
  101542:	0f b6 c0             	movzbl %al,%eax
  101545:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101548:	a1 a8 e0 11 00       	mov    0x11e0a8,%eax
  10154d:	83 e0 08             	and    $0x8,%eax
  101550:	85 c0                	test   %eax,%eax
  101552:	74 22                	je     101576 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101554:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101558:	7e 0c                	jle    101566 <kbd_proc_data+0x13e>
  10155a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10155e:	7f 06                	jg     101566 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101560:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101564:	eb 10                	jmp    101576 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101566:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10156a:	7e 0a                	jle    101576 <kbd_proc_data+0x14e>
  10156c:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101570:	7f 04                	jg     101576 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101572:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101576:	a1 a8 e0 11 00       	mov    0x11e0a8,%eax
  10157b:	f7 d0                	not    %eax
  10157d:	83 e0 06             	and    $0x6,%eax
  101580:	85 c0                	test   %eax,%eax
  101582:	75 28                	jne    1015ac <kbd_proc_data+0x184>
  101584:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10158b:	75 1f                	jne    1015ac <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10158d:	c7 04 24 49 a1 10 00 	movl   $0x10a149,(%esp)
  101594:	e8 f8 ec ff ff       	call   100291 <cprintf>
  101599:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10159f:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015a3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015a7:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015ab:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015af:	c9                   	leave  
  1015b0:	c3                   	ret    

001015b1 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015b1:	55                   	push   %ebp
  1015b2:	89 e5                	mov    %esp,%ebp
  1015b4:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015b7:	c7 04 24 28 14 10 00 	movl   $0x101428,(%esp)
  1015be:	e8 a6 fd ff ff       	call   101369 <cons_intr>
}
  1015c3:	c9                   	leave  
  1015c4:	c3                   	ret    

001015c5 <kbd_init>:

static void
kbd_init(void) {
  1015c5:	55                   	push   %ebp
  1015c6:	89 e5                	mov    %esp,%ebp
  1015c8:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015cb:	e8 e1 ff ff ff       	call   1015b1 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015d7:	e8 31 01 00 00       	call   10170d <pic_enable>
}
  1015dc:	c9                   	leave  
  1015dd:	c3                   	ret    

001015de <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015de:	55                   	push   %ebp
  1015df:	89 e5                	mov    %esp,%ebp
  1015e1:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015e4:	e8 93 f8 ff ff       	call   100e7c <cga_init>
    serial_init();
  1015e9:	e8 74 f9 ff ff       	call   100f62 <serial_init>
    kbd_init();
  1015ee:	e8 d2 ff ff ff       	call   1015c5 <kbd_init>
    if (!serial_exists) {
  1015f3:	a1 88 de 11 00       	mov    0x11de88,%eax
  1015f8:	85 c0                	test   %eax,%eax
  1015fa:	75 0c                	jne    101608 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015fc:	c7 04 24 55 a1 10 00 	movl   $0x10a155,(%esp)
  101603:	e8 89 ec ff ff       	call   100291 <cprintf>
    }
}
  101608:	c9                   	leave  
  101609:	c3                   	ret    

0010160a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10160a:	55                   	push   %ebp
  10160b:	89 e5                	mov    %esp,%ebp
  10160d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101610:	e8 e2 f7 ff ff       	call   100df7 <__intr_save>
  101615:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101618:	8b 45 08             	mov    0x8(%ebp),%eax
  10161b:	89 04 24             	mov    %eax,(%esp)
  10161e:	e8 9b fa ff ff       	call   1010be <lpt_putc>
        cga_putc(c);
  101623:	8b 45 08             	mov    0x8(%ebp),%eax
  101626:	89 04 24             	mov    %eax,(%esp)
  101629:	e8 cf fa ff ff       	call   1010fd <cga_putc>
        serial_putc(c);
  10162e:	8b 45 08             	mov    0x8(%ebp),%eax
  101631:	89 04 24             	mov    %eax,(%esp)
  101634:	e8 f1 fc ff ff       	call   10132a <serial_putc>
    }
    local_intr_restore(intr_flag);
  101639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10163c:	89 04 24             	mov    %eax,(%esp)
  10163f:	e8 dd f7 ff ff       	call   100e21 <__intr_restore>
}
  101644:	c9                   	leave  
  101645:	c3                   	ret    

00101646 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101646:	55                   	push   %ebp
  101647:	89 e5                	mov    %esp,%ebp
  101649:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10164c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101653:	e8 9f f7 ff ff       	call   100df7 <__intr_save>
  101658:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10165b:	e8 ab fd ff ff       	call   10140b <serial_intr>
        kbd_intr();
  101660:	e8 4c ff ff ff       	call   1015b1 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101665:	8b 15 a0 e0 11 00    	mov    0x11e0a0,%edx
  10166b:	a1 a4 e0 11 00       	mov    0x11e0a4,%eax
  101670:	39 c2                	cmp    %eax,%edx
  101672:	74 31                	je     1016a5 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101674:	a1 a0 e0 11 00       	mov    0x11e0a0,%eax
  101679:	8d 50 01             	lea    0x1(%eax),%edx
  10167c:	89 15 a0 e0 11 00    	mov    %edx,0x11e0a0
  101682:	0f b6 80 a0 de 11 00 	movzbl 0x11dea0(%eax),%eax
  101689:	0f b6 c0             	movzbl %al,%eax
  10168c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10168f:	a1 a0 e0 11 00       	mov    0x11e0a0,%eax
  101694:	3d 00 02 00 00       	cmp    $0x200,%eax
  101699:	75 0a                	jne    1016a5 <cons_getc+0x5f>
                cons.rpos = 0;
  10169b:	c7 05 a0 e0 11 00 00 	movl   $0x0,0x11e0a0
  1016a2:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016a8:	89 04 24             	mov    %eax,(%esp)
  1016ab:	e8 71 f7 ff ff       	call   100e21 <__intr_restore>
    return c;
  1016b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016b3:	c9                   	leave  
  1016b4:	c3                   	ret    

001016b5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b5:	55                   	push   %ebp
  1016b6:	89 e5                	mov    %esp,%ebp
  1016b8:	83 ec 14             	sub    $0x14,%esp
  1016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1016be:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c6:	66 a3 70 d5 11 00    	mov    %ax,0x11d570
    if (did_init) {
  1016cc:	a1 ac e0 11 00       	mov    0x11e0ac,%eax
  1016d1:	85 c0                	test   %eax,%eax
  1016d3:	74 36                	je     10170b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d9:	0f b6 c0             	movzbl %al,%eax
  1016dc:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e2:	88 45 fd             	mov    %al,-0x3(%ebp)
  1016e5:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ed:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016ee:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f2:	66 c1 e8 08          	shr    $0x8,%ax
  1016f6:	0f b6 c0             	movzbl %al,%eax
  1016f9:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016ff:	88 45 f9             	mov    %al,-0x7(%ebp)
  101702:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101706:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170a:	ee                   	out    %al,(%dx)
    }
}
  10170b:	c9                   	leave  
  10170c:	c3                   	ret    

0010170d <pic_enable>:

void
pic_enable(unsigned int irq) {
  10170d:	55                   	push   %ebp
  10170e:	89 e5                	mov    %esp,%ebp
  101710:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101713:	8b 45 08             	mov    0x8(%ebp),%eax
  101716:	ba 01 00 00 00       	mov    $0x1,%edx
  10171b:	89 c1                	mov    %eax,%ecx
  10171d:	d3 e2                	shl    %cl,%edx
  10171f:	89 d0                	mov    %edx,%eax
  101721:	f7 d0                	not    %eax
  101723:	89 c2                	mov    %eax,%edx
  101725:	0f b7 05 70 d5 11 00 	movzwl 0x11d570,%eax
  10172c:	21 d0                	and    %edx,%eax
  10172e:	0f b7 c0             	movzwl %ax,%eax
  101731:	89 04 24             	mov    %eax,(%esp)
  101734:	e8 7c ff ff ff       	call   1016b5 <pic_setmask>
}
  101739:	c9                   	leave  
  10173a:	c3                   	ret    

0010173b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173b:	55                   	push   %ebp
  10173c:	89 e5                	mov    %esp,%ebp
  10173e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101741:	c7 05 ac e0 11 00 01 	movl   $0x1,0x11e0ac
  101748:	00 00 00 
  10174b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101751:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101755:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101759:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10175d:	ee                   	out    %al,(%dx)
  10175e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101764:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101768:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101770:	ee                   	out    %al,(%dx)
  101771:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101777:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10177b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10177f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101783:	ee                   	out    %al,(%dx)
  101784:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178a:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10178e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101792:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101796:	ee                   	out    %al,(%dx)
  101797:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10179d:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a9:	ee                   	out    %al,(%dx)
  1017aa:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017bc:	ee                   	out    %al,(%dx)
  1017bd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c3:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017cf:	ee                   	out    %al,(%dx)
  1017d0:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d6:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017da:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017de:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e2:	ee                   	out    %al,(%dx)
  1017e3:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e9:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017ed:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f5:	ee                   	out    %al,(%dx)
  1017f6:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017fc:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101800:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101804:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101808:	ee                   	out    %al,(%dx)
  101809:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10180f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101813:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101817:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181b:	ee                   	out    %al,(%dx)
  10181c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101822:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101826:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10182e:	ee                   	out    %al,(%dx)
  10182f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101835:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101839:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10183d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101841:	ee                   	out    %al,(%dx)
  101842:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101848:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10184c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101850:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101854:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101855:	0f b7 05 70 d5 11 00 	movzwl 0x11d570,%eax
  10185c:	66 83 f8 ff          	cmp    $0xffff,%ax
  101860:	74 12                	je     101874 <pic_init+0x139>
        pic_setmask(irq_mask);
  101862:	0f b7 05 70 d5 11 00 	movzwl 0x11d570,%eax
  101869:	0f b7 c0             	movzwl %ax,%eax
  10186c:	89 04 24             	mov    %eax,(%esp)
  10186f:	e8 41 fe ff ff       	call   1016b5 <pic_setmask>
    }
}
  101874:	c9                   	leave  
  101875:	c3                   	ret    

00101876 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101876:	55                   	push   %ebp
  101877:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101879:	fb                   	sti    
    sti();
}
  10187a:	5d                   	pop    %ebp
  10187b:	c3                   	ret    

0010187c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10187c:	55                   	push   %ebp
  10187d:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10187f:	fa                   	cli    
    cli();
}
  101880:	5d                   	pop    %ebp
  101881:	c3                   	ret    

00101882 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101882:	55                   	push   %ebp
  101883:	89 e5                	mov    %esp,%ebp
  101885:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101888:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10188f:	00 
  101890:	c7 04 24 80 a1 10 00 	movl   $0x10a180,(%esp)
  101897:	e8 f5 e9 ff ff       	call   100291 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10189c:	c9                   	leave  
  10189d:	c3                   	ret    

0010189e <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10189e:	55                   	push   %ebp
  10189f:	89 e5                	mov    %esp,%ebp
  1018a1:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
        int num=sizeof(idt)/sizeof(struct gatedesc);
  1018a4:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i;
        for(i=0;i<num;++i)
  1018ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018b2:	e9 c3 00 00 00       	jmp    10197a <idt_init+0xdc>
        {
                SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  1018b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ba:	8b 04 85 00 d6 11 00 	mov    0x11d600(,%eax,4),%eax
  1018c1:	89 c2                	mov    %eax,%edx
  1018c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c6:	66 89 14 c5 c0 e0 11 	mov    %dx,0x11e0c0(,%eax,8)
  1018cd:	00 
  1018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d1:	66 c7 04 c5 c2 e0 11 	movw   $0x8,0x11e0c2(,%eax,8)
  1018d8:	00 08 00 
  1018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018de:	0f b6 14 c5 c4 e0 11 	movzbl 0x11e0c4(,%eax,8),%edx
  1018e5:	00 
  1018e6:	83 e2 e0             	and    $0xffffffe0,%edx
  1018e9:	88 14 c5 c4 e0 11 00 	mov    %dl,0x11e0c4(,%eax,8)
  1018f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f3:	0f b6 14 c5 c4 e0 11 	movzbl 0x11e0c4(,%eax,8),%edx
  1018fa:	00 
  1018fb:	83 e2 1f             	and    $0x1f,%edx
  1018fe:	88 14 c5 c4 e0 11 00 	mov    %dl,0x11e0c4(,%eax,8)
  101905:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101908:	0f b6 14 c5 c5 e0 11 	movzbl 0x11e0c5(,%eax,8),%edx
  10190f:	00 
  101910:	83 e2 f0             	and    $0xfffffff0,%edx
  101913:	83 ca 0e             	or     $0xe,%edx
  101916:	88 14 c5 c5 e0 11 00 	mov    %dl,0x11e0c5(,%eax,8)
  10191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101920:	0f b6 14 c5 c5 e0 11 	movzbl 0x11e0c5(,%eax,8),%edx
  101927:	00 
  101928:	83 e2 ef             	and    $0xffffffef,%edx
  10192b:	88 14 c5 c5 e0 11 00 	mov    %dl,0x11e0c5(,%eax,8)
  101932:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101935:	0f b6 14 c5 c5 e0 11 	movzbl 0x11e0c5(,%eax,8),%edx
  10193c:	00 
  10193d:	83 e2 9f             	and    $0xffffff9f,%edx
  101940:	88 14 c5 c5 e0 11 00 	mov    %dl,0x11e0c5(,%eax,8)
  101947:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194a:	0f b6 14 c5 c5 e0 11 	movzbl 0x11e0c5(,%eax,8),%edx
  101951:	00 
  101952:	83 ca 80             	or     $0xffffff80,%edx
  101955:	88 14 c5 c5 e0 11 00 	mov    %dl,0x11e0c5(,%eax,8)
  10195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195f:	8b 04 85 00 d6 11 00 	mov    0x11d600(,%eax,4),%eax
  101966:	c1 e8 10             	shr    $0x10,%eax
  101969:	89 c2                	mov    %eax,%edx
  10196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196e:	66 89 14 c5 c6 e0 11 	mov    %dx,0x11e0c6(,%eax,8)
  101975:	00 
        for(i=0;i<num;++i)
  101976:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101980:	0f 8c 31 ff ff ff    	jl     1018b7 <idt_init+0x19>
        }

        SETGATE(idt[T_SWITCH_TOU],0,GD_KTEXT,__vectors[T_SWITCH_TOU],DPL_USER);
  101986:	a1 e0 d7 11 00       	mov    0x11d7e0,%eax
  10198b:	66 a3 80 e4 11 00    	mov    %ax,0x11e480
  101991:	66 c7 05 82 e4 11 00 	movw   $0x8,0x11e482
  101998:	08 00 
  10199a:	0f b6 05 84 e4 11 00 	movzbl 0x11e484,%eax
  1019a1:	83 e0 e0             	and    $0xffffffe0,%eax
  1019a4:	a2 84 e4 11 00       	mov    %al,0x11e484
  1019a9:	0f b6 05 84 e4 11 00 	movzbl 0x11e484,%eax
  1019b0:	83 e0 1f             	and    $0x1f,%eax
  1019b3:	a2 84 e4 11 00       	mov    %al,0x11e484
  1019b8:	0f b6 05 85 e4 11 00 	movzbl 0x11e485,%eax
  1019bf:	83 e0 f0             	and    $0xfffffff0,%eax
  1019c2:	83 c8 0e             	or     $0xe,%eax
  1019c5:	a2 85 e4 11 00       	mov    %al,0x11e485
  1019ca:	0f b6 05 85 e4 11 00 	movzbl 0x11e485,%eax
  1019d1:	83 e0 ef             	and    $0xffffffef,%eax
  1019d4:	a2 85 e4 11 00       	mov    %al,0x11e485
  1019d9:	0f b6 05 85 e4 11 00 	movzbl 0x11e485,%eax
  1019e0:	83 c8 60             	or     $0x60,%eax
  1019e3:	a2 85 e4 11 00       	mov    %al,0x11e485
  1019e8:	0f b6 05 85 e4 11 00 	movzbl 0x11e485,%eax
  1019ef:	83 c8 80             	or     $0xffffff80,%eax
  1019f2:	a2 85 e4 11 00       	mov    %al,0x11e485
  1019f7:	a1 e0 d7 11 00       	mov    0x11d7e0,%eax
  1019fc:	c1 e8 10             	shr    $0x10,%eax
  1019ff:	66 a3 86 e4 11 00    	mov    %ax,0x11e486
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], 3);        
  101a05:	a1 e4 d7 11 00       	mov    0x11d7e4,%eax
  101a0a:	66 a3 88 e4 11 00    	mov    %ax,0x11e488
  101a10:	66 c7 05 8a e4 11 00 	movw   $0x8,0x11e48a
  101a17:	08 00 
  101a19:	0f b6 05 8c e4 11 00 	movzbl 0x11e48c,%eax
  101a20:	83 e0 e0             	and    $0xffffffe0,%eax
  101a23:	a2 8c e4 11 00       	mov    %al,0x11e48c
  101a28:	0f b6 05 8c e4 11 00 	movzbl 0x11e48c,%eax
  101a2f:	83 e0 1f             	and    $0x1f,%eax
  101a32:	a2 8c e4 11 00       	mov    %al,0x11e48c
  101a37:	0f b6 05 8d e4 11 00 	movzbl 0x11e48d,%eax
  101a3e:	83 e0 f0             	and    $0xfffffff0,%eax
  101a41:	83 c8 0e             	or     $0xe,%eax
  101a44:	a2 8d e4 11 00       	mov    %al,0x11e48d
  101a49:	0f b6 05 8d e4 11 00 	movzbl 0x11e48d,%eax
  101a50:	83 e0 ef             	and    $0xffffffef,%eax
  101a53:	a2 8d e4 11 00       	mov    %al,0x11e48d
  101a58:	0f b6 05 8d e4 11 00 	movzbl 0x11e48d,%eax
  101a5f:	83 c8 60             	or     $0x60,%eax
  101a62:	a2 8d e4 11 00       	mov    %al,0x11e48d
  101a67:	0f b6 05 8d e4 11 00 	movzbl 0x11e48d,%eax
  101a6e:	83 c8 80             	or     $0xffffff80,%eax
  101a71:	a2 8d e4 11 00       	mov    %al,0x11e48d
  101a76:	a1 e4 d7 11 00       	mov    0x11d7e4,%eax
  101a7b:	c1 e8 10             	shr    $0x10,%eax
  101a7e:	66 a3 8e e4 11 00    	mov    %ax,0x11e48e
  101a84:	c7 45 f4 80 d5 11 00 	movl   $0x11d580,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a8e:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101a91:	c9                   	leave  
  101a92:	c3                   	ret    

00101a93 <trapname>:

static const char *
trapname(int trapno) {
  101a93:	55                   	push   %ebp
  101a94:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a96:	8b 45 08             	mov    0x8(%ebp),%eax
  101a99:	83 f8 13             	cmp    $0x13,%eax
  101a9c:	77 0c                	ja     101aaa <trapname+0x17>
        return excnames[trapno];
  101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa1:	8b 04 85 e0 a4 10 00 	mov    0x10a4e0(,%eax,4),%eax
  101aa8:	eb 18                	jmp    101ac2 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101aaa:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101aae:	7e 0d                	jle    101abd <trapname+0x2a>
  101ab0:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ab4:	7f 07                	jg     101abd <trapname+0x2a>
        return "Hardware Interrupt";
  101ab6:	b8 8a a1 10 00       	mov    $0x10a18a,%eax
  101abb:	eb 05                	jmp    101ac2 <trapname+0x2f>
    }
    return "(unknown trap)";
  101abd:	b8 9d a1 10 00       	mov    $0x10a19d,%eax
}
  101ac2:	5d                   	pop    %ebp
  101ac3:	c3                   	ret    

00101ac4 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101ac4:	55                   	push   %ebp
  101ac5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aca:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ace:	66 83 f8 08          	cmp    $0x8,%ax
  101ad2:	0f 94 c0             	sete   %al
  101ad5:	0f b6 c0             	movzbl %al,%eax
}
  101ad8:	5d                   	pop    %ebp
  101ad9:	c3                   	ret    

00101ada <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101ada:	55                   	push   %ebp
  101adb:	89 e5                	mov    %esp,%ebp
  101add:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae7:	c7 04 24 de a1 10 00 	movl   $0x10a1de,(%esp)
  101aee:	e8 9e e7 ff ff       	call   100291 <cprintf>
    print_regs(&tf->tf_regs);
  101af3:	8b 45 08             	mov    0x8(%ebp),%eax
  101af6:	89 04 24             	mov    %eax,(%esp)
  101af9:	e8 a1 01 00 00       	call   101c9f <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101afe:	8b 45 08             	mov    0x8(%ebp),%eax
  101b01:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b05:	0f b7 c0             	movzwl %ax,%eax
  101b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0c:	c7 04 24 ef a1 10 00 	movl   $0x10a1ef,(%esp)
  101b13:	e8 79 e7 ff ff       	call   100291 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b18:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b1f:	0f b7 c0             	movzwl %ax,%eax
  101b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b26:	c7 04 24 02 a2 10 00 	movl   $0x10a202,(%esp)
  101b2d:	e8 5f e7 ff ff       	call   100291 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b32:	8b 45 08             	mov    0x8(%ebp),%eax
  101b35:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b39:	0f b7 c0             	movzwl %ax,%eax
  101b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b40:	c7 04 24 15 a2 10 00 	movl   $0x10a215,(%esp)
  101b47:	e8 45 e7 ff ff       	call   100291 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b53:	0f b7 c0             	movzwl %ax,%eax
  101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5a:	c7 04 24 28 a2 10 00 	movl   $0x10a228,(%esp)
  101b61:	e8 2b e7 ff ff       	call   100291 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b66:	8b 45 08             	mov    0x8(%ebp),%eax
  101b69:	8b 40 30             	mov    0x30(%eax),%eax
  101b6c:	89 04 24             	mov    %eax,(%esp)
  101b6f:	e8 1f ff ff ff       	call   101a93 <trapname>
  101b74:	8b 55 08             	mov    0x8(%ebp),%edx
  101b77:	8b 52 30             	mov    0x30(%edx),%edx
  101b7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b7e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b82:	c7 04 24 3b a2 10 00 	movl   $0x10a23b,(%esp)
  101b89:	e8 03 e7 ff ff       	call   100291 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b91:	8b 40 34             	mov    0x34(%eax),%eax
  101b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b98:	c7 04 24 4d a2 10 00 	movl   $0x10a24d,(%esp)
  101b9f:	e8 ed e6 ff ff       	call   100291 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba7:	8b 40 38             	mov    0x38(%eax),%eax
  101baa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bae:	c7 04 24 5c a2 10 00 	movl   $0x10a25c,(%esp)
  101bb5:	e8 d7 e6 ff ff       	call   100291 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bba:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bc1:	0f b7 c0             	movzwl %ax,%eax
  101bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc8:	c7 04 24 6b a2 10 00 	movl   $0x10a26b,(%esp)
  101bcf:	e8 bd e6 ff ff       	call   100291 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd7:	8b 40 40             	mov    0x40(%eax),%eax
  101bda:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bde:	c7 04 24 7e a2 10 00 	movl   $0x10a27e,(%esp)
  101be5:	e8 a7 e6 ff ff       	call   100291 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bf1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bf8:	eb 3e                	jmp    101c38 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfd:	8b 50 40             	mov    0x40(%eax),%edx
  101c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c03:	21 d0                	and    %edx,%eax
  101c05:	85 c0                	test   %eax,%eax
  101c07:	74 28                	je     101c31 <print_trapframe+0x157>
  101c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c0c:	8b 04 85 a0 d5 11 00 	mov    0x11d5a0(,%eax,4),%eax
  101c13:	85 c0                	test   %eax,%eax
  101c15:	74 1a                	je     101c31 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c1a:	8b 04 85 a0 d5 11 00 	mov    0x11d5a0(,%eax,4),%eax
  101c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c25:	c7 04 24 8d a2 10 00 	movl   $0x10a28d,(%esp)
  101c2c:	e8 60 e6 ff ff       	call   100291 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c31:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c35:	d1 65 f0             	shll   -0x10(%ebp)
  101c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c3b:	83 f8 17             	cmp    $0x17,%eax
  101c3e:	76 ba                	jbe    101bfa <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c40:	8b 45 08             	mov    0x8(%ebp),%eax
  101c43:	8b 40 40             	mov    0x40(%eax),%eax
  101c46:	25 00 30 00 00       	and    $0x3000,%eax
  101c4b:	c1 e8 0c             	shr    $0xc,%eax
  101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c52:	c7 04 24 91 a2 10 00 	movl   $0x10a291,(%esp)
  101c59:	e8 33 e6 ff ff       	call   100291 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c61:	89 04 24             	mov    %eax,(%esp)
  101c64:	e8 5b fe ff ff       	call   101ac4 <trap_in_kernel>
  101c69:	85 c0                	test   %eax,%eax
  101c6b:	75 30                	jne    101c9d <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c70:	8b 40 44             	mov    0x44(%eax),%eax
  101c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c77:	c7 04 24 9a a2 10 00 	movl   $0x10a29a,(%esp)
  101c7e:	e8 0e e6 ff ff       	call   100291 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c83:	8b 45 08             	mov    0x8(%ebp),%eax
  101c86:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c8a:	0f b7 c0             	movzwl %ax,%eax
  101c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c91:	c7 04 24 a9 a2 10 00 	movl   $0x10a2a9,(%esp)
  101c98:	e8 f4 e5 ff ff       	call   100291 <cprintf>
    }
}
  101c9d:	c9                   	leave  
  101c9e:	c3                   	ret    

00101c9f <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c9f:	55                   	push   %ebp
  101ca0:	89 e5                	mov    %esp,%ebp
  101ca2:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca8:	8b 00                	mov    (%eax),%eax
  101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cae:	c7 04 24 bc a2 10 00 	movl   $0x10a2bc,(%esp)
  101cb5:	e8 d7 e5 ff ff       	call   100291 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cba:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbd:	8b 40 04             	mov    0x4(%eax),%eax
  101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc4:	c7 04 24 cb a2 10 00 	movl   $0x10a2cb,(%esp)
  101ccb:	e8 c1 e5 ff ff       	call   100291 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd3:	8b 40 08             	mov    0x8(%eax),%eax
  101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cda:	c7 04 24 da a2 10 00 	movl   $0x10a2da,(%esp)
  101ce1:	e8 ab e5 ff ff       	call   100291 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf0:	c7 04 24 e9 a2 10 00 	movl   $0x10a2e9,(%esp)
  101cf7:	e8 95 e5 ff ff       	call   100291 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cff:	8b 40 10             	mov    0x10(%eax),%eax
  101d02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d06:	c7 04 24 f8 a2 10 00 	movl   $0x10a2f8,(%esp)
  101d0d:	e8 7f e5 ff ff       	call   100291 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d12:	8b 45 08             	mov    0x8(%ebp),%eax
  101d15:	8b 40 14             	mov    0x14(%eax),%eax
  101d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1c:	c7 04 24 07 a3 10 00 	movl   $0x10a307,(%esp)
  101d23:	e8 69 e5 ff ff       	call   100291 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d28:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2b:	8b 40 18             	mov    0x18(%eax),%eax
  101d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d32:	c7 04 24 16 a3 10 00 	movl   $0x10a316,(%esp)
  101d39:	e8 53 e5 ff ff       	call   100291 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d41:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d48:	c7 04 24 25 a3 10 00 	movl   $0x10a325,(%esp)
  101d4f:	e8 3d e5 ff ff       	call   100291 <cprintf>
}
  101d54:	c9                   	leave  
  101d55:	c3                   	ret    

00101d56 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d56:	55                   	push   %ebp
  101d57:	89 e5                	mov    %esp,%ebp
  101d59:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5f:	8b 40 30             	mov    0x30(%eax),%eax
  101d62:	83 f8 2f             	cmp    $0x2f,%eax
  101d65:	77 1d                	ja     101d84 <trap_dispatch+0x2e>
  101d67:	83 f8 2e             	cmp    $0x2e,%eax
  101d6a:	0f 83 91 01 00 00    	jae    101f01 <trap_dispatch+0x1ab>
  101d70:	83 f8 21             	cmp    $0x21,%eax
  101d73:	74 7f                	je     101df4 <trap_dispatch+0x9e>
  101d75:	83 f8 24             	cmp    $0x24,%eax
  101d78:	74 51                	je     101dcb <trap_dispatch+0x75>
  101d7a:	83 f8 20             	cmp    $0x20,%eax
  101d7d:	74 1c                	je     101d9b <trap_dispatch+0x45>
  101d7f:	e9 45 01 00 00       	jmp    101ec9 <trap_dispatch+0x173>
  101d84:	83 f8 78             	cmp    $0x78,%eax
  101d87:	0f 84 90 00 00 00    	je     101e1d <trap_dispatch+0xc7>
  101d8d:	83 f8 79             	cmp    $0x79,%eax
  101d90:	0f 84 e7 00 00 00    	je     101e7d <trap_dispatch+0x127>
  101d96:	e9 2e 01 00 00       	jmp    101ec9 <trap_dispatch+0x173>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */

	ticks++;
  101d9b:	a1 68 e9 11 00       	mov    0x11e968,%eax
  101da0:	83 c0 01             	add    $0x1,%eax
  101da3:	a3 68 e9 11 00       	mov    %eax,0x11e968
	if(ticks==TICK_NUM)
  101da8:	a1 68 e9 11 00       	mov    0x11e968,%eax
  101dad:	83 f8 64             	cmp    $0x64,%eax
  101db0:	75 14                	jne    101dc6 <trap_dispatch+0x70>
	{
		ticks=0;
  101db2:	c7 05 68 e9 11 00 00 	movl   $0x0,0x11e968
  101db9:	00 00 00 
		print_ticks();
  101dbc:	e8 c1 fa ff ff       	call   101882 <print_ticks>
	}		
        break;
  101dc1:	e9 3c 01 00 00       	jmp    101f02 <trap_dispatch+0x1ac>
  101dc6:	e9 37 01 00 00       	jmp    101f02 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101dcb:	e8 76 f8 ff ff       	call   101646 <cons_getc>
  101dd0:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101dd3:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dd7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ddb:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ddf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101de3:	c7 04 24 34 a3 10 00 	movl   $0x10a334,(%esp)
  101dea:	e8 a2 e4 ff ff       	call   100291 <cprintf>
        break;
  101def:	e9 0e 01 00 00       	jmp    101f02 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101df4:	e8 4d f8 ff ff       	call   101646 <cons_getc>
  101df9:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dfc:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e00:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e04:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e08:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e0c:	c7 04 24 46 a3 10 00 	movl   $0x10a346,(%esp)
  101e13:	e8 79 e4 ff ff       	call   100291 <cprintf>
        break;
  101e18:	e9 e5 00 00 00       	jmp    101f02 <trap_dispatch+0x1ac>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
	tf->tf_eflags |= FL_IOPL_MASK;
  101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e20:	8b 40 40             	mov    0x40(%eax),%eax
  101e23:	80 cc 30             	or     $0x30,%ah
  101e26:	89 c2                	mov    %eax,%edx
  101e28:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2b:	89 50 40             	mov    %edx,0x40(%eax)
	tf->tf_cs = USER_CS;
  101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e31:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = USER_DS;
  101e37:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3a:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  101e40:	8b 45 08             	mov    0x8(%ebp),%eax
  101e43:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101e47:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4a:	66 89 50 48          	mov    %dx,0x48(%eax)
  101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e51:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e55:	8b 45 08             	mov    0x8(%ebp),%eax
  101e58:	66 89 50 20          	mov    %dx,0x20(%eax)
  101e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5f:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101e63:	8b 45 08             	mov    0x8(%ebp),%eax
  101e66:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e71:	8b 45 08             	mov    0x8(%ebp),%eax
  101e74:	66 89 50 2c          	mov    %dx,0x2c(%eax)
	break;
  101e78:	e9 85 00 00 00       	jmp    101f02 <trap_dispatch+0x1ac>
    case T_SWITCH_TOK:
	tf->tf_cs = KERNEL_CS;
  101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e80:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
  101e86:	8b 45 08             	mov    0x8(%ebp),%eax
  101e89:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e92:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101e96:	8b 45 08             	mov    0x8(%ebp),%eax
  101e99:	66 89 50 48          	mov    %dx,0x48(%eax)
  101e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea0:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea7:	66 89 50 20          	mov    %dx,0x20(%eax)
  101eab:	8b 45 08             	mov    0x8(%ebp),%eax
  101eae:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb5:	66 89 50 28          	mov    %dx,0x28(%eax)
  101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebc:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec3:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        break;
  101ec7:	eb 39                	jmp    101f02 <trap_dispatch+0x1ac>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ecc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ed0:	0f b7 c0             	movzwl %ax,%eax
  101ed3:	83 e0 03             	and    $0x3,%eax
  101ed6:	85 c0                	test   %eax,%eax
  101ed8:	75 28                	jne    101f02 <trap_dispatch+0x1ac>
            print_trapframe(tf);
  101eda:	8b 45 08             	mov    0x8(%ebp),%eax
  101edd:	89 04 24             	mov    %eax,(%esp)
  101ee0:	e8 f5 fb ff ff       	call   101ada <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ee5:	c7 44 24 08 55 a3 10 	movl   $0x10a355,0x8(%esp)
  101eec:	00 
  101eed:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  101ef4:	00 
  101ef5:	c7 04 24 71 a3 10 00 	movl   $0x10a371,(%esp)
  101efc:	e8 e7 e4 ff ff       	call   1003e8 <__panic>
        break;
  101f01:	90                   	nop
        }
    }
}
  101f02:	c9                   	leave  
  101f03:	c3                   	ret    

00101f04 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f04:	55                   	push   %ebp
  101f05:	89 e5                	mov    %esp,%ebp
  101f07:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0d:	89 04 24             	mov    %eax,(%esp)
  101f10:	e8 41 fe ff ff       	call   101d56 <trap_dispatch>
}
  101f15:	c9                   	leave  
  101f16:	c3                   	ret    

00101f17 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $0
  101f19:	6a 00                	push   $0x0
  jmp __alltraps
  101f1b:	e9 67 0a 00 00       	jmp    102987 <__alltraps>

00101f20 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $1
  101f22:	6a 01                	push   $0x1
  jmp __alltraps
  101f24:	e9 5e 0a 00 00       	jmp    102987 <__alltraps>

00101f29 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f29:	6a 00                	push   $0x0
  pushl $2
  101f2b:	6a 02                	push   $0x2
  jmp __alltraps
  101f2d:	e9 55 0a 00 00       	jmp    102987 <__alltraps>

00101f32 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $3
  101f34:	6a 03                	push   $0x3
  jmp __alltraps
  101f36:	e9 4c 0a 00 00       	jmp    102987 <__alltraps>

00101f3b <vector4>:
.globl vector4
vector4:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $4
  101f3d:	6a 04                	push   $0x4
  jmp __alltraps
  101f3f:	e9 43 0a 00 00       	jmp    102987 <__alltraps>

00101f44 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f44:	6a 00                	push   $0x0
  pushl $5
  101f46:	6a 05                	push   $0x5
  jmp __alltraps
  101f48:	e9 3a 0a 00 00       	jmp    102987 <__alltraps>

00101f4d <vector6>:
.globl vector6
vector6:
  pushl $0
  101f4d:	6a 00                	push   $0x0
  pushl $6
  101f4f:	6a 06                	push   $0x6
  jmp __alltraps
  101f51:	e9 31 0a 00 00       	jmp    102987 <__alltraps>

00101f56 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $7
  101f58:	6a 07                	push   $0x7
  jmp __alltraps
  101f5a:	e9 28 0a 00 00       	jmp    102987 <__alltraps>

00101f5f <vector8>:
.globl vector8
vector8:
  pushl $8
  101f5f:	6a 08                	push   $0x8
  jmp __alltraps
  101f61:	e9 21 0a 00 00       	jmp    102987 <__alltraps>

00101f66 <vector9>:
.globl vector9
vector9:
  pushl $9
  101f66:	6a 09                	push   $0x9
  jmp __alltraps
  101f68:	e9 1a 0a 00 00       	jmp    102987 <__alltraps>

00101f6d <vector10>:
.globl vector10
vector10:
  pushl $10
  101f6d:	6a 0a                	push   $0xa
  jmp __alltraps
  101f6f:	e9 13 0a 00 00       	jmp    102987 <__alltraps>

00101f74 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f74:	6a 0b                	push   $0xb
  jmp __alltraps
  101f76:	e9 0c 0a 00 00       	jmp    102987 <__alltraps>

00101f7b <vector12>:
.globl vector12
vector12:
  pushl $12
  101f7b:	6a 0c                	push   $0xc
  jmp __alltraps
  101f7d:	e9 05 0a 00 00       	jmp    102987 <__alltraps>

00101f82 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f82:	6a 0d                	push   $0xd
  jmp __alltraps
  101f84:	e9 fe 09 00 00       	jmp    102987 <__alltraps>

00101f89 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f89:	6a 0e                	push   $0xe
  jmp __alltraps
  101f8b:	e9 f7 09 00 00       	jmp    102987 <__alltraps>

00101f90 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $15
  101f92:	6a 0f                	push   $0xf
  jmp __alltraps
  101f94:	e9 ee 09 00 00       	jmp    102987 <__alltraps>

00101f99 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $16
  101f9b:	6a 10                	push   $0x10
  jmp __alltraps
  101f9d:	e9 e5 09 00 00       	jmp    102987 <__alltraps>

00101fa2 <vector17>:
.globl vector17
vector17:
  pushl $17
  101fa2:	6a 11                	push   $0x11
  jmp __alltraps
  101fa4:	e9 de 09 00 00       	jmp    102987 <__alltraps>

00101fa9 <vector18>:
.globl vector18
vector18:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $18
  101fab:	6a 12                	push   $0x12
  jmp __alltraps
  101fad:	e9 d5 09 00 00       	jmp    102987 <__alltraps>

00101fb2 <vector19>:
.globl vector19
vector19:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $19
  101fb4:	6a 13                	push   $0x13
  jmp __alltraps
  101fb6:	e9 cc 09 00 00       	jmp    102987 <__alltraps>

00101fbb <vector20>:
.globl vector20
vector20:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $20
  101fbd:	6a 14                	push   $0x14
  jmp __alltraps
  101fbf:	e9 c3 09 00 00       	jmp    102987 <__alltraps>

00101fc4 <vector21>:
.globl vector21
vector21:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $21
  101fc6:	6a 15                	push   $0x15
  jmp __alltraps
  101fc8:	e9 ba 09 00 00       	jmp    102987 <__alltraps>

00101fcd <vector22>:
.globl vector22
vector22:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $22
  101fcf:	6a 16                	push   $0x16
  jmp __alltraps
  101fd1:	e9 b1 09 00 00       	jmp    102987 <__alltraps>

00101fd6 <vector23>:
.globl vector23
vector23:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $23
  101fd8:	6a 17                	push   $0x17
  jmp __alltraps
  101fda:	e9 a8 09 00 00       	jmp    102987 <__alltraps>

00101fdf <vector24>:
.globl vector24
vector24:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $24
  101fe1:	6a 18                	push   $0x18
  jmp __alltraps
  101fe3:	e9 9f 09 00 00       	jmp    102987 <__alltraps>

00101fe8 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $25
  101fea:	6a 19                	push   $0x19
  jmp __alltraps
  101fec:	e9 96 09 00 00       	jmp    102987 <__alltraps>

00101ff1 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $26
  101ff3:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ff5:	e9 8d 09 00 00       	jmp    102987 <__alltraps>

00101ffa <vector27>:
.globl vector27
vector27:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $27
  101ffc:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ffe:	e9 84 09 00 00       	jmp    102987 <__alltraps>

00102003 <vector28>:
.globl vector28
vector28:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $28
  102005:	6a 1c                	push   $0x1c
  jmp __alltraps
  102007:	e9 7b 09 00 00       	jmp    102987 <__alltraps>

0010200c <vector29>:
.globl vector29
vector29:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $29
  10200e:	6a 1d                	push   $0x1d
  jmp __alltraps
  102010:	e9 72 09 00 00       	jmp    102987 <__alltraps>

00102015 <vector30>:
.globl vector30
vector30:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $30
  102017:	6a 1e                	push   $0x1e
  jmp __alltraps
  102019:	e9 69 09 00 00       	jmp    102987 <__alltraps>

0010201e <vector31>:
.globl vector31
vector31:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $31
  102020:	6a 1f                	push   $0x1f
  jmp __alltraps
  102022:	e9 60 09 00 00       	jmp    102987 <__alltraps>

00102027 <vector32>:
.globl vector32
vector32:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $32
  102029:	6a 20                	push   $0x20
  jmp __alltraps
  10202b:	e9 57 09 00 00       	jmp    102987 <__alltraps>

00102030 <vector33>:
.globl vector33
vector33:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $33
  102032:	6a 21                	push   $0x21
  jmp __alltraps
  102034:	e9 4e 09 00 00       	jmp    102987 <__alltraps>

00102039 <vector34>:
.globl vector34
vector34:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $34
  10203b:	6a 22                	push   $0x22
  jmp __alltraps
  10203d:	e9 45 09 00 00       	jmp    102987 <__alltraps>

00102042 <vector35>:
.globl vector35
vector35:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $35
  102044:	6a 23                	push   $0x23
  jmp __alltraps
  102046:	e9 3c 09 00 00       	jmp    102987 <__alltraps>

0010204b <vector36>:
.globl vector36
vector36:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $36
  10204d:	6a 24                	push   $0x24
  jmp __alltraps
  10204f:	e9 33 09 00 00       	jmp    102987 <__alltraps>

00102054 <vector37>:
.globl vector37
vector37:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $37
  102056:	6a 25                	push   $0x25
  jmp __alltraps
  102058:	e9 2a 09 00 00       	jmp    102987 <__alltraps>

0010205d <vector38>:
.globl vector38
vector38:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $38
  10205f:	6a 26                	push   $0x26
  jmp __alltraps
  102061:	e9 21 09 00 00       	jmp    102987 <__alltraps>

00102066 <vector39>:
.globl vector39
vector39:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $39
  102068:	6a 27                	push   $0x27
  jmp __alltraps
  10206a:	e9 18 09 00 00       	jmp    102987 <__alltraps>

0010206f <vector40>:
.globl vector40
vector40:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $40
  102071:	6a 28                	push   $0x28
  jmp __alltraps
  102073:	e9 0f 09 00 00       	jmp    102987 <__alltraps>

00102078 <vector41>:
.globl vector41
vector41:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $41
  10207a:	6a 29                	push   $0x29
  jmp __alltraps
  10207c:	e9 06 09 00 00       	jmp    102987 <__alltraps>

00102081 <vector42>:
.globl vector42
vector42:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $42
  102083:	6a 2a                	push   $0x2a
  jmp __alltraps
  102085:	e9 fd 08 00 00       	jmp    102987 <__alltraps>

0010208a <vector43>:
.globl vector43
vector43:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $43
  10208c:	6a 2b                	push   $0x2b
  jmp __alltraps
  10208e:	e9 f4 08 00 00       	jmp    102987 <__alltraps>

00102093 <vector44>:
.globl vector44
vector44:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $44
  102095:	6a 2c                	push   $0x2c
  jmp __alltraps
  102097:	e9 eb 08 00 00       	jmp    102987 <__alltraps>

0010209c <vector45>:
.globl vector45
vector45:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $45
  10209e:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020a0:	e9 e2 08 00 00       	jmp    102987 <__alltraps>

001020a5 <vector46>:
.globl vector46
vector46:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $46
  1020a7:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020a9:	e9 d9 08 00 00       	jmp    102987 <__alltraps>

001020ae <vector47>:
.globl vector47
vector47:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $47
  1020b0:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020b2:	e9 d0 08 00 00       	jmp    102987 <__alltraps>

001020b7 <vector48>:
.globl vector48
vector48:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $48
  1020b9:	6a 30                	push   $0x30
  jmp __alltraps
  1020bb:	e9 c7 08 00 00       	jmp    102987 <__alltraps>

001020c0 <vector49>:
.globl vector49
vector49:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $49
  1020c2:	6a 31                	push   $0x31
  jmp __alltraps
  1020c4:	e9 be 08 00 00       	jmp    102987 <__alltraps>

001020c9 <vector50>:
.globl vector50
vector50:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $50
  1020cb:	6a 32                	push   $0x32
  jmp __alltraps
  1020cd:	e9 b5 08 00 00       	jmp    102987 <__alltraps>

001020d2 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $51
  1020d4:	6a 33                	push   $0x33
  jmp __alltraps
  1020d6:	e9 ac 08 00 00       	jmp    102987 <__alltraps>

001020db <vector52>:
.globl vector52
vector52:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $52
  1020dd:	6a 34                	push   $0x34
  jmp __alltraps
  1020df:	e9 a3 08 00 00       	jmp    102987 <__alltraps>

001020e4 <vector53>:
.globl vector53
vector53:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $53
  1020e6:	6a 35                	push   $0x35
  jmp __alltraps
  1020e8:	e9 9a 08 00 00       	jmp    102987 <__alltraps>

001020ed <vector54>:
.globl vector54
vector54:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $54
  1020ef:	6a 36                	push   $0x36
  jmp __alltraps
  1020f1:	e9 91 08 00 00       	jmp    102987 <__alltraps>

001020f6 <vector55>:
.globl vector55
vector55:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $55
  1020f8:	6a 37                	push   $0x37
  jmp __alltraps
  1020fa:	e9 88 08 00 00       	jmp    102987 <__alltraps>

001020ff <vector56>:
.globl vector56
vector56:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $56
  102101:	6a 38                	push   $0x38
  jmp __alltraps
  102103:	e9 7f 08 00 00       	jmp    102987 <__alltraps>

00102108 <vector57>:
.globl vector57
vector57:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $57
  10210a:	6a 39                	push   $0x39
  jmp __alltraps
  10210c:	e9 76 08 00 00       	jmp    102987 <__alltraps>

00102111 <vector58>:
.globl vector58
vector58:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $58
  102113:	6a 3a                	push   $0x3a
  jmp __alltraps
  102115:	e9 6d 08 00 00       	jmp    102987 <__alltraps>

0010211a <vector59>:
.globl vector59
vector59:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $59
  10211c:	6a 3b                	push   $0x3b
  jmp __alltraps
  10211e:	e9 64 08 00 00       	jmp    102987 <__alltraps>

00102123 <vector60>:
.globl vector60
vector60:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $60
  102125:	6a 3c                	push   $0x3c
  jmp __alltraps
  102127:	e9 5b 08 00 00       	jmp    102987 <__alltraps>

0010212c <vector61>:
.globl vector61
vector61:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $61
  10212e:	6a 3d                	push   $0x3d
  jmp __alltraps
  102130:	e9 52 08 00 00       	jmp    102987 <__alltraps>

00102135 <vector62>:
.globl vector62
vector62:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $62
  102137:	6a 3e                	push   $0x3e
  jmp __alltraps
  102139:	e9 49 08 00 00       	jmp    102987 <__alltraps>

0010213e <vector63>:
.globl vector63
vector63:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $63
  102140:	6a 3f                	push   $0x3f
  jmp __alltraps
  102142:	e9 40 08 00 00       	jmp    102987 <__alltraps>

00102147 <vector64>:
.globl vector64
vector64:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $64
  102149:	6a 40                	push   $0x40
  jmp __alltraps
  10214b:	e9 37 08 00 00       	jmp    102987 <__alltraps>

00102150 <vector65>:
.globl vector65
vector65:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $65
  102152:	6a 41                	push   $0x41
  jmp __alltraps
  102154:	e9 2e 08 00 00       	jmp    102987 <__alltraps>

00102159 <vector66>:
.globl vector66
vector66:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $66
  10215b:	6a 42                	push   $0x42
  jmp __alltraps
  10215d:	e9 25 08 00 00       	jmp    102987 <__alltraps>

00102162 <vector67>:
.globl vector67
vector67:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $67
  102164:	6a 43                	push   $0x43
  jmp __alltraps
  102166:	e9 1c 08 00 00       	jmp    102987 <__alltraps>

0010216b <vector68>:
.globl vector68
vector68:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $68
  10216d:	6a 44                	push   $0x44
  jmp __alltraps
  10216f:	e9 13 08 00 00       	jmp    102987 <__alltraps>

00102174 <vector69>:
.globl vector69
vector69:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $69
  102176:	6a 45                	push   $0x45
  jmp __alltraps
  102178:	e9 0a 08 00 00       	jmp    102987 <__alltraps>

0010217d <vector70>:
.globl vector70
vector70:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $70
  10217f:	6a 46                	push   $0x46
  jmp __alltraps
  102181:	e9 01 08 00 00       	jmp    102987 <__alltraps>

00102186 <vector71>:
.globl vector71
vector71:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $71
  102188:	6a 47                	push   $0x47
  jmp __alltraps
  10218a:	e9 f8 07 00 00       	jmp    102987 <__alltraps>

0010218f <vector72>:
.globl vector72
vector72:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $72
  102191:	6a 48                	push   $0x48
  jmp __alltraps
  102193:	e9 ef 07 00 00       	jmp    102987 <__alltraps>

00102198 <vector73>:
.globl vector73
vector73:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $73
  10219a:	6a 49                	push   $0x49
  jmp __alltraps
  10219c:	e9 e6 07 00 00       	jmp    102987 <__alltraps>

001021a1 <vector74>:
.globl vector74
vector74:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $74
  1021a3:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021a5:	e9 dd 07 00 00       	jmp    102987 <__alltraps>

001021aa <vector75>:
.globl vector75
vector75:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $75
  1021ac:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021ae:	e9 d4 07 00 00       	jmp    102987 <__alltraps>

001021b3 <vector76>:
.globl vector76
vector76:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $76
  1021b5:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021b7:	e9 cb 07 00 00       	jmp    102987 <__alltraps>

001021bc <vector77>:
.globl vector77
vector77:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $77
  1021be:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021c0:	e9 c2 07 00 00       	jmp    102987 <__alltraps>

001021c5 <vector78>:
.globl vector78
vector78:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $78
  1021c7:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021c9:	e9 b9 07 00 00       	jmp    102987 <__alltraps>

001021ce <vector79>:
.globl vector79
vector79:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $79
  1021d0:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021d2:	e9 b0 07 00 00       	jmp    102987 <__alltraps>

001021d7 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $80
  1021d9:	6a 50                	push   $0x50
  jmp __alltraps
  1021db:	e9 a7 07 00 00       	jmp    102987 <__alltraps>

001021e0 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $81
  1021e2:	6a 51                	push   $0x51
  jmp __alltraps
  1021e4:	e9 9e 07 00 00       	jmp    102987 <__alltraps>

001021e9 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $82
  1021eb:	6a 52                	push   $0x52
  jmp __alltraps
  1021ed:	e9 95 07 00 00       	jmp    102987 <__alltraps>

001021f2 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $83
  1021f4:	6a 53                	push   $0x53
  jmp __alltraps
  1021f6:	e9 8c 07 00 00       	jmp    102987 <__alltraps>

001021fb <vector84>:
.globl vector84
vector84:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $84
  1021fd:	6a 54                	push   $0x54
  jmp __alltraps
  1021ff:	e9 83 07 00 00       	jmp    102987 <__alltraps>

00102204 <vector85>:
.globl vector85
vector85:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $85
  102206:	6a 55                	push   $0x55
  jmp __alltraps
  102208:	e9 7a 07 00 00       	jmp    102987 <__alltraps>

0010220d <vector86>:
.globl vector86
vector86:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $86
  10220f:	6a 56                	push   $0x56
  jmp __alltraps
  102211:	e9 71 07 00 00       	jmp    102987 <__alltraps>

00102216 <vector87>:
.globl vector87
vector87:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $87
  102218:	6a 57                	push   $0x57
  jmp __alltraps
  10221a:	e9 68 07 00 00       	jmp    102987 <__alltraps>

0010221f <vector88>:
.globl vector88
vector88:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $88
  102221:	6a 58                	push   $0x58
  jmp __alltraps
  102223:	e9 5f 07 00 00       	jmp    102987 <__alltraps>

00102228 <vector89>:
.globl vector89
vector89:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $89
  10222a:	6a 59                	push   $0x59
  jmp __alltraps
  10222c:	e9 56 07 00 00       	jmp    102987 <__alltraps>

00102231 <vector90>:
.globl vector90
vector90:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $90
  102233:	6a 5a                	push   $0x5a
  jmp __alltraps
  102235:	e9 4d 07 00 00       	jmp    102987 <__alltraps>

0010223a <vector91>:
.globl vector91
vector91:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $91
  10223c:	6a 5b                	push   $0x5b
  jmp __alltraps
  10223e:	e9 44 07 00 00       	jmp    102987 <__alltraps>

00102243 <vector92>:
.globl vector92
vector92:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $92
  102245:	6a 5c                	push   $0x5c
  jmp __alltraps
  102247:	e9 3b 07 00 00       	jmp    102987 <__alltraps>

0010224c <vector93>:
.globl vector93
vector93:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $93
  10224e:	6a 5d                	push   $0x5d
  jmp __alltraps
  102250:	e9 32 07 00 00       	jmp    102987 <__alltraps>

00102255 <vector94>:
.globl vector94
vector94:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $94
  102257:	6a 5e                	push   $0x5e
  jmp __alltraps
  102259:	e9 29 07 00 00       	jmp    102987 <__alltraps>

0010225e <vector95>:
.globl vector95
vector95:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $95
  102260:	6a 5f                	push   $0x5f
  jmp __alltraps
  102262:	e9 20 07 00 00       	jmp    102987 <__alltraps>

00102267 <vector96>:
.globl vector96
vector96:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $96
  102269:	6a 60                	push   $0x60
  jmp __alltraps
  10226b:	e9 17 07 00 00       	jmp    102987 <__alltraps>

00102270 <vector97>:
.globl vector97
vector97:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $97
  102272:	6a 61                	push   $0x61
  jmp __alltraps
  102274:	e9 0e 07 00 00       	jmp    102987 <__alltraps>

00102279 <vector98>:
.globl vector98
vector98:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $98
  10227b:	6a 62                	push   $0x62
  jmp __alltraps
  10227d:	e9 05 07 00 00       	jmp    102987 <__alltraps>

00102282 <vector99>:
.globl vector99
vector99:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $99
  102284:	6a 63                	push   $0x63
  jmp __alltraps
  102286:	e9 fc 06 00 00       	jmp    102987 <__alltraps>

0010228b <vector100>:
.globl vector100
vector100:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $100
  10228d:	6a 64                	push   $0x64
  jmp __alltraps
  10228f:	e9 f3 06 00 00       	jmp    102987 <__alltraps>

00102294 <vector101>:
.globl vector101
vector101:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $101
  102296:	6a 65                	push   $0x65
  jmp __alltraps
  102298:	e9 ea 06 00 00       	jmp    102987 <__alltraps>

0010229d <vector102>:
.globl vector102
vector102:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $102
  10229f:	6a 66                	push   $0x66
  jmp __alltraps
  1022a1:	e9 e1 06 00 00       	jmp    102987 <__alltraps>

001022a6 <vector103>:
.globl vector103
vector103:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $103
  1022a8:	6a 67                	push   $0x67
  jmp __alltraps
  1022aa:	e9 d8 06 00 00       	jmp    102987 <__alltraps>

001022af <vector104>:
.globl vector104
vector104:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $104
  1022b1:	6a 68                	push   $0x68
  jmp __alltraps
  1022b3:	e9 cf 06 00 00       	jmp    102987 <__alltraps>

001022b8 <vector105>:
.globl vector105
vector105:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $105
  1022ba:	6a 69                	push   $0x69
  jmp __alltraps
  1022bc:	e9 c6 06 00 00       	jmp    102987 <__alltraps>

001022c1 <vector106>:
.globl vector106
vector106:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $106
  1022c3:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022c5:	e9 bd 06 00 00       	jmp    102987 <__alltraps>

001022ca <vector107>:
.globl vector107
vector107:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $107
  1022cc:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022ce:	e9 b4 06 00 00       	jmp    102987 <__alltraps>

001022d3 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $108
  1022d5:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022d7:	e9 ab 06 00 00       	jmp    102987 <__alltraps>

001022dc <vector109>:
.globl vector109
vector109:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $109
  1022de:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022e0:	e9 a2 06 00 00       	jmp    102987 <__alltraps>

001022e5 <vector110>:
.globl vector110
vector110:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $110
  1022e7:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022e9:	e9 99 06 00 00       	jmp    102987 <__alltraps>

001022ee <vector111>:
.globl vector111
vector111:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $111
  1022f0:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022f2:	e9 90 06 00 00       	jmp    102987 <__alltraps>

001022f7 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $112
  1022f9:	6a 70                	push   $0x70
  jmp __alltraps
  1022fb:	e9 87 06 00 00       	jmp    102987 <__alltraps>

00102300 <vector113>:
.globl vector113
vector113:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $113
  102302:	6a 71                	push   $0x71
  jmp __alltraps
  102304:	e9 7e 06 00 00       	jmp    102987 <__alltraps>

00102309 <vector114>:
.globl vector114
vector114:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $114
  10230b:	6a 72                	push   $0x72
  jmp __alltraps
  10230d:	e9 75 06 00 00       	jmp    102987 <__alltraps>

00102312 <vector115>:
.globl vector115
vector115:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $115
  102314:	6a 73                	push   $0x73
  jmp __alltraps
  102316:	e9 6c 06 00 00       	jmp    102987 <__alltraps>

0010231b <vector116>:
.globl vector116
vector116:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $116
  10231d:	6a 74                	push   $0x74
  jmp __alltraps
  10231f:	e9 63 06 00 00       	jmp    102987 <__alltraps>

00102324 <vector117>:
.globl vector117
vector117:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $117
  102326:	6a 75                	push   $0x75
  jmp __alltraps
  102328:	e9 5a 06 00 00       	jmp    102987 <__alltraps>

0010232d <vector118>:
.globl vector118
vector118:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $118
  10232f:	6a 76                	push   $0x76
  jmp __alltraps
  102331:	e9 51 06 00 00       	jmp    102987 <__alltraps>

00102336 <vector119>:
.globl vector119
vector119:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $119
  102338:	6a 77                	push   $0x77
  jmp __alltraps
  10233a:	e9 48 06 00 00       	jmp    102987 <__alltraps>

0010233f <vector120>:
.globl vector120
vector120:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $120
  102341:	6a 78                	push   $0x78
  jmp __alltraps
  102343:	e9 3f 06 00 00       	jmp    102987 <__alltraps>

00102348 <vector121>:
.globl vector121
vector121:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $121
  10234a:	6a 79                	push   $0x79
  jmp __alltraps
  10234c:	e9 36 06 00 00       	jmp    102987 <__alltraps>

00102351 <vector122>:
.globl vector122
vector122:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $122
  102353:	6a 7a                	push   $0x7a
  jmp __alltraps
  102355:	e9 2d 06 00 00       	jmp    102987 <__alltraps>

0010235a <vector123>:
.globl vector123
vector123:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $123
  10235c:	6a 7b                	push   $0x7b
  jmp __alltraps
  10235e:	e9 24 06 00 00       	jmp    102987 <__alltraps>

00102363 <vector124>:
.globl vector124
vector124:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $124
  102365:	6a 7c                	push   $0x7c
  jmp __alltraps
  102367:	e9 1b 06 00 00       	jmp    102987 <__alltraps>

0010236c <vector125>:
.globl vector125
vector125:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $125
  10236e:	6a 7d                	push   $0x7d
  jmp __alltraps
  102370:	e9 12 06 00 00       	jmp    102987 <__alltraps>

00102375 <vector126>:
.globl vector126
vector126:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $126
  102377:	6a 7e                	push   $0x7e
  jmp __alltraps
  102379:	e9 09 06 00 00       	jmp    102987 <__alltraps>

0010237e <vector127>:
.globl vector127
vector127:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $127
  102380:	6a 7f                	push   $0x7f
  jmp __alltraps
  102382:	e9 00 06 00 00       	jmp    102987 <__alltraps>

00102387 <vector128>:
.globl vector128
vector128:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $128
  102389:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10238e:	e9 f4 05 00 00       	jmp    102987 <__alltraps>

00102393 <vector129>:
.globl vector129
vector129:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $129
  102395:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10239a:	e9 e8 05 00 00       	jmp    102987 <__alltraps>

0010239f <vector130>:
.globl vector130
vector130:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $130
  1023a1:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023a6:	e9 dc 05 00 00       	jmp    102987 <__alltraps>

001023ab <vector131>:
.globl vector131
vector131:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $131
  1023ad:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023b2:	e9 d0 05 00 00       	jmp    102987 <__alltraps>

001023b7 <vector132>:
.globl vector132
vector132:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $132
  1023b9:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023be:	e9 c4 05 00 00       	jmp    102987 <__alltraps>

001023c3 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $133
  1023c5:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023ca:	e9 b8 05 00 00       	jmp    102987 <__alltraps>

001023cf <vector134>:
.globl vector134
vector134:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $134
  1023d1:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023d6:	e9 ac 05 00 00       	jmp    102987 <__alltraps>

001023db <vector135>:
.globl vector135
vector135:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $135
  1023dd:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023e2:	e9 a0 05 00 00       	jmp    102987 <__alltraps>

001023e7 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $136
  1023e9:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023ee:	e9 94 05 00 00       	jmp    102987 <__alltraps>

001023f3 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $137
  1023f5:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023fa:	e9 88 05 00 00       	jmp    102987 <__alltraps>

001023ff <vector138>:
.globl vector138
vector138:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $138
  102401:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102406:	e9 7c 05 00 00       	jmp    102987 <__alltraps>

0010240b <vector139>:
.globl vector139
vector139:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $139
  10240d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102412:	e9 70 05 00 00       	jmp    102987 <__alltraps>

00102417 <vector140>:
.globl vector140
vector140:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $140
  102419:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10241e:	e9 64 05 00 00       	jmp    102987 <__alltraps>

00102423 <vector141>:
.globl vector141
vector141:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $141
  102425:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10242a:	e9 58 05 00 00       	jmp    102987 <__alltraps>

0010242f <vector142>:
.globl vector142
vector142:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $142
  102431:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102436:	e9 4c 05 00 00       	jmp    102987 <__alltraps>

0010243b <vector143>:
.globl vector143
vector143:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $143
  10243d:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102442:	e9 40 05 00 00       	jmp    102987 <__alltraps>

00102447 <vector144>:
.globl vector144
vector144:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $144
  102449:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10244e:	e9 34 05 00 00       	jmp    102987 <__alltraps>

00102453 <vector145>:
.globl vector145
vector145:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $145
  102455:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10245a:	e9 28 05 00 00       	jmp    102987 <__alltraps>

0010245f <vector146>:
.globl vector146
vector146:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $146
  102461:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102466:	e9 1c 05 00 00       	jmp    102987 <__alltraps>

0010246b <vector147>:
.globl vector147
vector147:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $147
  10246d:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102472:	e9 10 05 00 00       	jmp    102987 <__alltraps>

00102477 <vector148>:
.globl vector148
vector148:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $148
  102479:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10247e:	e9 04 05 00 00       	jmp    102987 <__alltraps>

00102483 <vector149>:
.globl vector149
vector149:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $149
  102485:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10248a:	e9 f8 04 00 00       	jmp    102987 <__alltraps>

0010248f <vector150>:
.globl vector150
vector150:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $150
  102491:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102496:	e9 ec 04 00 00       	jmp    102987 <__alltraps>

0010249b <vector151>:
.globl vector151
vector151:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $151
  10249d:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024a2:	e9 e0 04 00 00       	jmp    102987 <__alltraps>

001024a7 <vector152>:
.globl vector152
vector152:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $152
  1024a9:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024ae:	e9 d4 04 00 00       	jmp    102987 <__alltraps>

001024b3 <vector153>:
.globl vector153
vector153:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $153
  1024b5:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024ba:	e9 c8 04 00 00       	jmp    102987 <__alltraps>

001024bf <vector154>:
.globl vector154
vector154:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $154
  1024c1:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024c6:	e9 bc 04 00 00       	jmp    102987 <__alltraps>

001024cb <vector155>:
.globl vector155
vector155:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $155
  1024cd:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024d2:	e9 b0 04 00 00       	jmp    102987 <__alltraps>

001024d7 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $156
  1024d9:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024de:	e9 a4 04 00 00       	jmp    102987 <__alltraps>

001024e3 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $157
  1024e5:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024ea:	e9 98 04 00 00       	jmp    102987 <__alltraps>

001024ef <vector158>:
.globl vector158
vector158:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $158
  1024f1:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024f6:	e9 8c 04 00 00       	jmp    102987 <__alltraps>

001024fb <vector159>:
.globl vector159
vector159:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $159
  1024fd:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102502:	e9 80 04 00 00       	jmp    102987 <__alltraps>

00102507 <vector160>:
.globl vector160
vector160:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $160
  102509:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10250e:	e9 74 04 00 00       	jmp    102987 <__alltraps>

00102513 <vector161>:
.globl vector161
vector161:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $161
  102515:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10251a:	e9 68 04 00 00       	jmp    102987 <__alltraps>

0010251f <vector162>:
.globl vector162
vector162:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $162
  102521:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102526:	e9 5c 04 00 00       	jmp    102987 <__alltraps>

0010252b <vector163>:
.globl vector163
vector163:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $163
  10252d:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102532:	e9 50 04 00 00       	jmp    102987 <__alltraps>

00102537 <vector164>:
.globl vector164
vector164:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $164
  102539:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10253e:	e9 44 04 00 00       	jmp    102987 <__alltraps>

00102543 <vector165>:
.globl vector165
vector165:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $165
  102545:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10254a:	e9 38 04 00 00       	jmp    102987 <__alltraps>

0010254f <vector166>:
.globl vector166
vector166:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $166
  102551:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102556:	e9 2c 04 00 00       	jmp    102987 <__alltraps>

0010255b <vector167>:
.globl vector167
vector167:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $167
  10255d:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102562:	e9 20 04 00 00       	jmp    102987 <__alltraps>

00102567 <vector168>:
.globl vector168
vector168:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $168
  102569:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10256e:	e9 14 04 00 00       	jmp    102987 <__alltraps>

00102573 <vector169>:
.globl vector169
vector169:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $169
  102575:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10257a:	e9 08 04 00 00       	jmp    102987 <__alltraps>

0010257f <vector170>:
.globl vector170
vector170:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $170
  102581:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102586:	e9 fc 03 00 00       	jmp    102987 <__alltraps>

0010258b <vector171>:
.globl vector171
vector171:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $171
  10258d:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102592:	e9 f0 03 00 00       	jmp    102987 <__alltraps>

00102597 <vector172>:
.globl vector172
vector172:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $172
  102599:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10259e:	e9 e4 03 00 00       	jmp    102987 <__alltraps>

001025a3 <vector173>:
.globl vector173
vector173:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $173
  1025a5:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025aa:	e9 d8 03 00 00       	jmp    102987 <__alltraps>

001025af <vector174>:
.globl vector174
vector174:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $174
  1025b1:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025b6:	e9 cc 03 00 00       	jmp    102987 <__alltraps>

001025bb <vector175>:
.globl vector175
vector175:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $175
  1025bd:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025c2:	e9 c0 03 00 00       	jmp    102987 <__alltraps>

001025c7 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $176
  1025c9:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025ce:	e9 b4 03 00 00       	jmp    102987 <__alltraps>

001025d3 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $177
  1025d5:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025da:	e9 a8 03 00 00       	jmp    102987 <__alltraps>

001025df <vector178>:
.globl vector178
vector178:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $178
  1025e1:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025e6:	e9 9c 03 00 00       	jmp    102987 <__alltraps>

001025eb <vector179>:
.globl vector179
vector179:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $179
  1025ed:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025f2:	e9 90 03 00 00       	jmp    102987 <__alltraps>

001025f7 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $180
  1025f9:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025fe:	e9 84 03 00 00       	jmp    102987 <__alltraps>

00102603 <vector181>:
.globl vector181
vector181:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $181
  102605:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10260a:	e9 78 03 00 00       	jmp    102987 <__alltraps>

0010260f <vector182>:
.globl vector182
vector182:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $182
  102611:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102616:	e9 6c 03 00 00       	jmp    102987 <__alltraps>

0010261b <vector183>:
.globl vector183
vector183:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $183
  10261d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102622:	e9 60 03 00 00       	jmp    102987 <__alltraps>

00102627 <vector184>:
.globl vector184
vector184:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $184
  102629:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10262e:	e9 54 03 00 00       	jmp    102987 <__alltraps>

00102633 <vector185>:
.globl vector185
vector185:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $185
  102635:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10263a:	e9 48 03 00 00       	jmp    102987 <__alltraps>

0010263f <vector186>:
.globl vector186
vector186:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $186
  102641:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102646:	e9 3c 03 00 00       	jmp    102987 <__alltraps>

0010264b <vector187>:
.globl vector187
vector187:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $187
  10264d:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102652:	e9 30 03 00 00       	jmp    102987 <__alltraps>

00102657 <vector188>:
.globl vector188
vector188:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $188
  102659:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10265e:	e9 24 03 00 00       	jmp    102987 <__alltraps>

00102663 <vector189>:
.globl vector189
vector189:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $189
  102665:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10266a:	e9 18 03 00 00       	jmp    102987 <__alltraps>

0010266f <vector190>:
.globl vector190
vector190:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $190
  102671:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102676:	e9 0c 03 00 00       	jmp    102987 <__alltraps>

0010267b <vector191>:
.globl vector191
vector191:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $191
  10267d:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102682:	e9 00 03 00 00       	jmp    102987 <__alltraps>

00102687 <vector192>:
.globl vector192
vector192:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $192
  102689:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10268e:	e9 f4 02 00 00       	jmp    102987 <__alltraps>

00102693 <vector193>:
.globl vector193
vector193:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $193
  102695:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10269a:	e9 e8 02 00 00       	jmp    102987 <__alltraps>

0010269f <vector194>:
.globl vector194
vector194:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $194
  1026a1:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026a6:	e9 dc 02 00 00       	jmp    102987 <__alltraps>

001026ab <vector195>:
.globl vector195
vector195:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $195
  1026ad:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026b2:	e9 d0 02 00 00       	jmp    102987 <__alltraps>

001026b7 <vector196>:
.globl vector196
vector196:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $196
  1026b9:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026be:	e9 c4 02 00 00       	jmp    102987 <__alltraps>

001026c3 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $197
  1026c5:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026ca:	e9 b8 02 00 00       	jmp    102987 <__alltraps>

001026cf <vector198>:
.globl vector198
vector198:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $198
  1026d1:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026d6:	e9 ac 02 00 00       	jmp    102987 <__alltraps>

001026db <vector199>:
.globl vector199
vector199:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $199
  1026dd:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026e2:	e9 a0 02 00 00       	jmp    102987 <__alltraps>

001026e7 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $200
  1026e9:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026ee:	e9 94 02 00 00       	jmp    102987 <__alltraps>

001026f3 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $201
  1026f5:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026fa:	e9 88 02 00 00       	jmp    102987 <__alltraps>

001026ff <vector202>:
.globl vector202
vector202:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $202
  102701:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102706:	e9 7c 02 00 00       	jmp    102987 <__alltraps>

0010270b <vector203>:
.globl vector203
vector203:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $203
  10270d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102712:	e9 70 02 00 00       	jmp    102987 <__alltraps>

00102717 <vector204>:
.globl vector204
vector204:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $204
  102719:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10271e:	e9 64 02 00 00       	jmp    102987 <__alltraps>

00102723 <vector205>:
.globl vector205
vector205:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $205
  102725:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10272a:	e9 58 02 00 00       	jmp    102987 <__alltraps>

0010272f <vector206>:
.globl vector206
vector206:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $206
  102731:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102736:	e9 4c 02 00 00       	jmp    102987 <__alltraps>

0010273b <vector207>:
.globl vector207
vector207:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $207
  10273d:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102742:	e9 40 02 00 00       	jmp    102987 <__alltraps>

00102747 <vector208>:
.globl vector208
vector208:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $208
  102749:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10274e:	e9 34 02 00 00       	jmp    102987 <__alltraps>

00102753 <vector209>:
.globl vector209
vector209:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $209
  102755:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10275a:	e9 28 02 00 00       	jmp    102987 <__alltraps>

0010275f <vector210>:
.globl vector210
vector210:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $210
  102761:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102766:	e9 1c 02 00 00       	jmp    102987 <__alltraps>

0010276b <vector211>:
.globl vector211
vector211:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $211
  10276d:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102772:	e9 10 02 00 00       	jmp    102987 <__alltraps>

00102777 <vector212>:
.globl vector212
vector212:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $212
  102779:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10277e:	e9 04 02 00 00       	jmp    102987 <__alltraps>

00102783 <vector213>:
.globl vector213
vector213:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $213
  102785:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10278a:	e9 f8 01 00 00       	jmp    102987 <__alltraps>

0010278f <vector214>:
.globl vector214
vector214:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $214
  102791:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102796:	e9 ec 01 00 00       	jmp    102987 <__alltraps>

0010279b <vector215>:
.globl vector215
vector215:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $215
  10279d:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027a2:	e9 e0 01 00 00       	jmp    102987 <__alltraps>

001027a7 <vector216>:
.globl vector216
vector216:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $216
  1027a9:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027ae:	e9 d4 01 00 00       	jmp    102987 <__alltraps>

001027b3 <vector217>:
.globl vector217
vector217:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $217
  1027b5:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027ba:	e9 c8 01 00 00       	jmp    102987 <__alltraps>

001027bf <vector218>:
.globl vector218
vector218:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $218
  1027c1:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027c6:	e9 bc 01 00 00       	jmp    102987 <__alltraps>

001027cb <vector219>:
.globl vector219
vector219:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $219
  1027cd:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027d2:	e9 b0 01 00 00       	jmp    102987 <__alltraps>

001027d7 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $220
  1027d9:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027de:	e9 a4 01 00 00       	jmp    102987 <__alltraps>

001027e3 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $221
  1027e5:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027ea:	e9 98 01 00 00       	jmp    102987 <__alltraps>

001027ef <vector222>:
.globl vector222
vector222:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $222
  1027f1:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027f6:	e9 8c 01 00 00       	jmp    102987 <__alltraps>

001027fb <vector223>:
.globl vector223
vector223:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $223
  1027fd:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102802:	e9 80 01 00 00       	jmp    102987 <__alltraps>

00102807 <vector224>:
.globl vector224
vector224:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $224
  102809:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10280e:	e9 74 01 00 00       	jmp    102987 <__alltraps>

00102813 <vector225>:
.globl vector225
vector225:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $225
  102815:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10281a:	e9 68 01 00 00       	jmp    102987 <__alltraps>

0010281f <vector226>:
.globl vector226
vector226:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $226
  102821:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102826:	e9 5c 01 00 00       	jmp    102987 <__alltraps>

0010282b <vector227>:
.globl vector227
vector227:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $227
  10282d:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102832:	e9 50 01 00 00       	jmp    102987 <__alltraps>

00102837 <vector228>:
.globl vector228
vector228:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $228
  102839:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10283e:	e9 44 01 00 00       	jmp    102987 <__alltraps>

00102843 <vector229>:
.globl vector229
vector229:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $229
  102845:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10284a:	e9 38 01 00 00       	jmp    102987 <__alltraps>

0010284f <vector230>:
.globl vector230
vector230:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $230
  102851:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102856:	e9 2c 01 00 00       	jmp    102987 <__alltraps>

0010285b <vector231>:
.globl vector231
vector231:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $231
  10285d:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102862:	e9 20 01 00 00       	jmp    102987 <__alltraps>

00102867 <vector232>:
.globl vector232
vector232:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $232
  102869:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10286e:	e9 14 01 00 00       	jmp    102987 <__alltraps>

00102873 <vector233>:
.globl vector233
vector233:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $233
  102875:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10287a:	e9 08 01 00 00       	jmp    102987 <__alltraps>

0010287f <vector234>:
.globl vector234
vector234:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $234
  102881:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102886:	e9 fc 00 00 00       	jmp    102987 <__alltraps>

0010288b <vector235>:
.globl vector235
vector235:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $235
  10288d:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102892:	e9 f0 00 00 00       	jmp    102987 <__alltraps>

00102897 <vector236>:
.globl vector236
vector236:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $236
  102899:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10289e:	e9 e4 00 00 00       	jmp    102987 <__alltraps>

001028a3 <vector237>:
.globl vector237
vector237:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $237
  1028a5:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028aa:	e9 d8 00 00 00       	jmp    102987 <__alltraps>

001028af <vector238>:
.globl vector238
vector238:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $238
  1028b1:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028b6:	e9 cc 00 00 00       	jmp    102987 <__alltraps>

001028bb <vector239>:
.globl vector239
vector239:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $239
  1028bd:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028c2:	e9 c0 00 00 00       	jmp    102987 <__alltraps>

001028c7 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028c7:	6a 00                	push   $0x0
  pushl $240
  1028c9:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028ce:	e9 b4 00 00 00       	jmp    102987 <__alltraps>

001028d3 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028d3:	6a 00                	push   $0x0
  pushl $241
  1028d5:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028da:	e9 a8 00 00 00       	jmp    102987 <__alltraps>

001028df <vector242>:
.globl vector242
vector242:
  pushl $0
  1028df:	6a 00                	push   $0x0
  pushl $242
  1028e1:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028e6:	e9 9c 00 00 00       	jmp    102987 <__alltraps>

001028eb <vector243>:
.globl vector243
vector243:
  pushl $0
  1028eb:	6a 00                	push   $0x0
  pushl $243
  1028ed:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028f2:	e9 90 00 00 00       	jmp    102987 <__alltraps>

001028f7 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028f7:	6a 00                	push   $0x0
  pushl $244
  1028f9:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028fe:	e9 84 00 00 00       	jmp    102987 <__alltraps>

00102903 <vector245>:
.globl vector245
vector245:
  pushl $0
  102903:	6a 00                	push   $0x0
  pushl $245
  102905:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10290a:	e9 78 00 00 00       	jmp    102987 <__alltraps>

0010290f <vector246>:
.globl vector246
vector246:
  pushl $0
  10290f:	6a 00                	push   $0x0
  pushl $246
  102911:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102916:	e9 6c 00 00 00       	jmp    102987 <__alltraps>

0010291b <vector247>:
.globl vector247
vector247:
  pushl $0
  10291b:	6a 00                	push   $0x0
  pushl $247
  10291d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102922:	e9 60 00 00 00       	jmp    102987 <__alltraps>

00102927 <vector248>:
.globl vector248
vector248:
  pushl $0
  102927:	6a 00                	push   $0x0
  pushl $248
  102929:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10292e:	e9 54 00 00 00       	jmp    102987 <__alltraps>

00102933 <vector249>:
.globl vector249
vector249:
  pushl $0
  102933:	6a 00                	push   $0x0
  pushl $249
  102935:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10293a:	e9 48 00 00 00       	jmp    102987 <__alltraps>

0010293f <vector250>:
.globl vector250
vector250:
  pushl $0
  10293f:	6a 00                	push   $0x0
  pushl $250
  102941:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102946:	e9 3c 00 00 00       	jmp    102987 <__alltraps>

0010294b <vector251>:
.globl vector251
vector251:
  pushl $0
  10294b:	6a 00                	push   $0x0
  pushl $251
  10294d:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102952:	e9 30 00 00 00       	jmp    102987 <__alltraps>

00102957 <vector252>:
.globl vector252
vector252:
  pushl $0
  102957:	6a 00                	push   $0x0
  pushl $252
  102959:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10295e:	e9 24 00 00 00       	jmp    102987 <__alltraps>

00102963 <vector253>:
.globl vector253
vector253:
  pushl $0
  102963:	6a 00                	push   $0x0
  pushl $253
  102965:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10296a:	e9 18 00 00 00       	jmp    102987 <__alltraps>

0010296f <vector254>:
.globl vector254
vector254:
  pushl $0
  10296f:	6a 00                	push   $0x0
  pushl $254
  102971:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102976:	e9 0c 00 00 00       	jmp    102987 <__alltraps>

0010297b <vector255>:
.globl vector255
vector255:
  pushl $0
  10297b:	6a 00                	push   $0x0
  pushl $255
  10297d:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102982:	e9 00 00 00 00       	jmp    102987 <__alltraps>

00102987 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102987:	1e                   	push   %ds
    pushl %es
  102988:	06                   	push   %es
    pushl %fs
  102989:	0f a0                	push   %fs
    pushl %gs
  10298b:	0f a8                	push   %gs
    pushal
  10298d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  10298e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102993:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102995:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102997:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102998:	e8 67 f5 ff ff       	call   101f04 <trap>

    # pop the pushed stack pointer
    popl %esp
  10299d:	5c                   	pop    %esp

0010299e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  10299e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  10299f:	0f a9                	pop    %gs
    popl %fs
  1029a1:	0f a1                	pop    %fs
    popl %es
  1029a3:	07                   	pop    %es
    popl %ds
  1029a4:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1029a5:	83 c4 08             	add    $0x8,%esp
    iret
  1029a8:	cf                   	iret   

001029a9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1029a9:	55                   	push   %ebp
  1029aa:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1029ac:	8b 55 08             	mov    0x8(%ebp),%edx
  1029af:	a1 74 e9 11 00       	mov    0x11e974,%eax
  1029b4:	29 c2                	sub    %eax,%edx
  1029b6:	89 d0                	mov    %edx,%eax
  1029b8:	c1 f8 02             	sar    $0x2,%eax
  1029bb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1029c1:	5d                   	pop    %ebp
  1029c2:	c3                   	ret    

001029c3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1029c3:	55                   	push   %ebp
  1029c4:	89 e5                	mov    %esp,%ebp
  1029c6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029cc:	89 04 24             	mov    %eax,(%esp)
  1029cf:	e8 d5 ff ff ff       	call   1029a9 <page2ppn>
  1029d4:	c1 e0 0c             	shl    $0xc,%eax
}
  1029d7:	c9                   	leave  
  1029d8:	c3                   	ret    

001029d9 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1029d9:	55                   	push   %ebp
  1029da:	89 e5                	mov    %esp,%ebp
  1029dc:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1029df:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e2:	c1 e8 0c             	shr    $0xc,%eax
  1029e5:	89 c2                	mov    %eax,%edx
  1029e7:	a1 c0 e8 11 00       	mov    0x11e8c0,%eax
  1029ec:	39 c2                	cmp    %eax,%edx
  1029ee:	72 1c                	jb     102a0c <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1029f0:	c7 44 24 08 30 a5 10 	movl   $0x10a530,0x8(%esp)
  1029f7:	00 
  1029f8:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1029ff:	00 
  102a00:	c7 04 24 4f a5 10 00 	movl   $0x10a54f,(%esp)
  102a07:	e8 dc d9 ff ff       	call   1003e8 <__panic>
    }
    return &pages[PPN(pa)];
  102a0c:	8b 0d 74 e9 11 00    	mov    0x11e974,%ecx
  102a12:	8b 45 08             	mov    0x8(%ebp),%eax
  102a15:	c1 e8 0c             	shr    $0xc,%eax
  102a18:	89 c2                	mov    %eax,%edx
  102a1a:	89 d0                	mov    %edx,%eax
  102a1c:	c1 e0 02             	shl    $0x2,%eax
  102a1f:	01 d0                	add    %edx,%eax
  102a21:	c1 e0 02             	shl    $0x2,%eax
  102a24:	01 c8                	add    %ecx,%eax
}
  102a26:	c9                   	leave  
  102a27:	c3                   	ret    

00102a28 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102a28:	55                   	push   %ebp
  102a29:	89 e5                	mov    %esp,%ebp
  102a2b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a31:	89 04 24             	mov    %eax,(%esp)
  102a34:	e8 8a ff ff ff       	call   1029c3 <page2pa>
  102a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a3f:	c1 e8 0c             	shr    $0xc,%eax
  102a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a45:	a1 c0 e8 11 00       	mov    0x11e8c0,%eax
  102a4a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102a4d:	72 23                	jb     102a72 <page2kva+0x4a>
  102a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102a56:	c7 44 24 08 60 a5 10 	movl   $0x10a560,0x8(%esp)
  102a5d:	00 
  102a5e:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102a65:	00 
  102a66:	c7 04 24 4f a5 10 00 	movl   $0x10a54f,(%esp)
  102a6d:	e8 76 d9 ff ff       	call   1003e8 <__panic>
  102a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a75:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102a7a:	c9                   	leave  
  102a7b:	c3                   	ret    

00102a7c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102a7c:	55                   	push   %ebp
  102a7d:	89 e5                	mov    %esp,%ebp
  102a7f:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102a82:	8b 45 08             	mov    0x8(%ebp),%eax
  102a85:	83 e0 01             	and    $0x1,%eax
  102a88:	85 c0                	test   %eax,%eax
  102a8a:	75 1c                	jne    102aa8 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102a8c:	c7 44 24 08 84 a5 10 	movl   $0x10a584,0x8(%esp)
  102a93:	00 
  102a94:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102a9b:	00 
  102a9c:	c7 04 24 4f a5 10 00 	movl   $0x10a54f,(%esp)
  102aa3:	e8 40 d9 ff ff       	call   1003e8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  102aab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102ab0:	89 04 24             	mov    %eax,(%esp)
  102ab3:	e8 21 ff ff ff       	call   1029d9 <pa2page>
}
  102ab8:	c9                   	leave  
  102ab9:	c3                   	ret    

00102aba <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102aba:	55                   	push   %ebp
  102abb:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102abd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac0:	8b 00                	mov    (%eax),%eax
}
  102ac2:	5d                   	pop    %ebp
  102ac3:	c3                   	ret    

00102ac4 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102ac4:	55                   	push   %ebp
  102ac5:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  102aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  102acd:	89 10                	mov    %edx,(%eax)
}
  102acf:	5d                   	pop    %ebp
  102ad0:	c3                   	ret    

00102ad1 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102ad1:	55                   	push   %ebp
  102ad2:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad7:	8b 00                	mov    (%eax),%eax
  102ad9:	8d 50 01             	lea    0x1(%eax),%edx
  102adc:	8b 45 08             	mov    0x8(%ebp),%eax
  102adf:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae4:	8b 00                	mov    (%eax),%eax
}
  102ae6:	5d                   	pop    %ebp
  102ae7:	c3                   	ret    

00102ae8 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102ae8:	55                   	push   %ebp
  102ae9:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  102aee:	8b 00                	mov    (%eax),%eax
  102af0:	8d 50 ff             	lea    -0x1(%eax),%edx
  102af3:	8b 45 08             	mov    0x8(%ebp),%eax
  102af6:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102af8:	8b 45 08             	mov    0x8(%ebp),%eax
  102afb:	8b 00                	mov    (%eax),%eax
}
  102afd:	5d                   	pop    %ebp
  102afe:	c3                   	ret    

00102aff <__intr_save>:
__intr_save(void) {
  102aff:	55                   	push   %ebp
  102b00:	89 e5                	mov    %esp,%ebp
  102b02:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102b05:	9c                   	pushf  
  102b06:	58                   	pop    %eax
  102b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102b0d:	25 00 02 00 00       	and    $0x200,%eax
  102b12:	85 c0                	test   %eax,%eax
  102b14:	74 0c                	je     102b22 <__intr_save+0x23>
        intr_disable();
  102b16:	e8 61 ed ff ff       	call   10187c <intr_disable>
        return 1;
  102b1b:	b8 01 00 00 00       	mov    $0x1,%eax
  102b20:	eb 05                	jmp    102b27 <__intr_save+0x28>
    return 0;
  102b22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b27:	c9                   	leave  
  102b28:	c3                   	ret    

00102b29 <__intr_restore>:
__intr_restore(bool flag) {
  102b29:	55                   	push   %ebp
  102b2a:	89 e5                	mov    %esp,%ebp
  102b2c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102b2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b33:	74 05                	je     102b3a <__intr_restore+0x11>
        intr_enable();
  102b35:	e8 3c ed ff ff       	call   101876 <intr_enable>
}
  102b3a:	c9                   	leave  
  102b3b:	c3                   	ret    

00102b3c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b3c:	55                   	push   %ebp
  102b3d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b42:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b45:	b8 23 00 00 00       	mov    $0x23,%eax
  102b4a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b4c:	b8 23 00 00 00       	mov    $0x23,%eax
  102b51:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b53:	b8 10 00 00 00       	mov    $0x10,%eax
  102b58:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b5a:	b8 10 00 00 00       	mov    $0x10,%eax
  102b5f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b61:	b8 10 00 00 00       	mov    $0x10,%eax
  102b66:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b68:	ea 6f 2b 10 00 08 00 	ljmp   $0x8,$0x102b6f
}
  102b6f:	5d                   	pop    %ebp
  102b70:	c3                   	ret    

00102b71 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102b71:	55                   	push   %ebp
  102b72:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102b74:	8b 45 08             	mov    0x8(%ebp),%eax
  102b77:	a3 e4 e8 11 00       	mov    %eax,0x11e8e4
}
  102b7c:	5d                   	pop    %ebp
  102b7d:	c3                   	ret    

00102b7e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b7e:	55                   	push   %ebp
  102b7f:	89 e5                	mov    %esp,%ebp
  102b81:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102b84:	b8 00 d0 11 00       	mov    $0x11d000,%eax
  102b89:	89 04 24             	mov    %eax,(%esp)
  102b8c:	e8 e0 ff ff ff       	call   102b71 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102b91:	66 c7 05 e8 e8 11 00 	movw   $0x10,0x11e8e8
  102b98:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102b9a:	66 c7 05 28 da 11 00 	movw   $0x68,0x11da28
  102ba1:	68 00 
  102ba3:	b8 e0 e8 11 00       	mov    $0x11e8e0,%eax
  102ba8:	66 a3 2a da 11 00    	mov    %ax,0x11da2a
  102bae:	b8 e0 e8 11 00       	mov    $0x11e8e0,%eax
  102bb3:	c1 e8 10             	shr    $0x10,%eax
  102bb6:	a2 2c da 11 00       	mov    %al,0x11da2c
  102bbb:	0f b6 05 2d da 11 00 	movzbl 0x11da2d,%eax
  102bc2:	83 e0 f0             	and    $0xfffffff0,%eax
  102bc5:	83 c8 09             	or     $0x9,%eax
  102bc8:	a2 2d da 11 00       	mov    %al,0x11da2d
  102bcd:	0f b6 05 2d da 11 00 	movzbl 0x11da2d,%eax
  102bd4:	83 e0 ef             	and    $0xffffffef,%eax
  102bd7:	a2 2d da 11 00       	mov    %al,0x11da2d
  102bdc:	0f b6 05 2d da 11 00 	movzbl 0x11da2d,%eax
  102be3:	83 e0 9f             	and    $0xffffff9f,%eax
  102be6:	a2 2d da 11 00       	mov    %al,0x11da2d
  102beb:	0f b6 05 2d da 11 00 	movzbl 0x11da2d,%eax
  102bf2:	83 c8 80             	or     $0xffffff80,%eax
  102bf5:	a2 2d da 11 00       	mov    %al,0x11da2d
  102bfa:	0f b6 05 2e da 11 00 	movzbl 0x11da2e,%eax
  102c01:	83 e0 f0             	and    $0xfffffff0,%eax
  102c04:	a2 2e da 11 00       	mov    %al,0x11da2e
  102c09:	0f b6 05 2e da 11 00 	movzbl 0x11da2e,%eax
  102c10:	83 e0 ef             	and    $0xffffffef,%eax
  102c13:	a2 2e da 11 00       	mov    %al,0x11da2e
  102c18:	0f b6 05 2e da 11 00 	movzbl 0x11da2e,%eax
  102c1f:	83 e0 df             	and    $0xffffffdf,%eax
  102c22:	a2 2e da 11 00       	mov    %al,0x11da2e
  102c27:	0f b6 05 2e da 11 00 	movzbl 0x11da2e,%eax
  102c2e:	83 c8 40             	or     $0x40,%eax
  102c31:	a2 2e da 11 00       	mov    %al,0x11da2e
  102c36:	0f b6 05 2e da 11 00 	movzbl 0x11da2e,%eax
  102c3d:	83 e0 7f             	and    $0x7f,%eax
  102c40:	a2 2e da 11 00       	mov    %al,0x11da2e
  102c45:	b8 e0 e8 11 00       	mov    $0x11e8e0,%eax
  102c4a:	c1 e8 18             	shr    $0x18,%eax
  102c4d:	a2 2f da 11 00       	mov    %al,0x11da2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102c52:	c7 04 24 30 da 11 00 	movl   $0x11da30,(%esp)
  102c59:	e8 de fe ff ff       	call   102b3c <lgdt>
  102c5e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102c64:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c68:	0f 00 d8             	ltr    %ax
    // load the TSS
    ltr(GD_TSS);
}
  102c6b:	c9                   	leave  
  102c6c:	c3                   	ret    

00102c6d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102c6d:	55                   	push   %ebp
  102c6e:	89 e5                	mov    %esp,%ebp
  102c70:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102c73:	c7 05 6c e9 11 00 f8 	movl   $0x10b2f8,0x11e96c
  102c7a:	b2 10 00 
    //pmm_manager=&buddy_pmm_manager;
    cprintf("memory management: %s\n", pmm_manager->name);
  102c7d:	a1 6c e9 11 00       	mov    0x11e96c,%eax
  102c82:	8b 00                	mov    (%eax),%eax
  102c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c88:	c7 04 24 b0 a5 10 00 	movl   $0x10a5b0,(%esp)
  102c8f:	e8 fd d5 ff ff       	call   100291 <cprintf>
    pmm_manager->init();
  102c94:	a1 6c e9 11 00       	mov    0x11e96c,%eax
  102c99:	8b 40 04             	mov    0x4(%eax),%eax
  102c9c:	ff d0                	call   *%eax
}
  102c9e:	c9                   	leave  
  102c9f:	c3                   	ret    

00102ca0 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102ca0:	55                   	push   %ebp
  102ca1:	89 e5                	mov    %esp,%ebp
  102ca3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102ca6:	a1 6c e9 11 00       	mov    0x11e96c,%eax
  102cab:	8b 40 08             	mov    0x8(%eax),%eax
  102cae:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  102cb8:	89 14 24             	mov    %edx,(%esp)
  102cbb:	ff d0                	call   *%eax
}
  102cbd:	c9                   	leave  
  102cbe:	c3                   	ret    

00102cbf <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102cbf:	55                   	push   %ebp
  102cc0:	89 e5                	mov    %esp,%ebp
  102cc2:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102cc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102ccc:	e8 2e fe ff ff       	call   102aff <__intr_save>
  102cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102cd4:	a1 6c e9 11 00       	mov    0x11e96c,%eax
  102cd9:	8b 40 0c             	mov    0xc(%eax),%eax
  102cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  102cdf:	89 14 24             	mov    %edx,(%esp)
  102ce2:	ff d0                	call   *%eax
  102ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cea:	89 04 24             	mov    %eax,(%esp)
  102ced:	e8 37 fe ff ff       	call   102b29 <__intr_restore>
    return page;
  102cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102cf5:	c9                   	leave  
  102cf6:	c3                   	ret    

00102cf7 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102cf7:	55                   	push   %ebp
  102cf8:	89 e5                	mov    %esp,%ebp
  102cfa:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102cfd:	e8 fd fd ff ff       	call   102aff <__intr_save>
  102d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102d05:	a1 6c e9 11 00       	mov    0x11e96c,%eax
  102d0a:	8b 40 10             	mov    0x10(%eax),%eax
  102d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d10:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d14:	8b 55 08             	mov    0x8(%ebp),%edx
  102d17:	89 14 24             	mov    %edx,(%esp)
  102d1a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d1f:	89 04 24             	mov    %eax,(%esp)
  102d22:	e8 02 fe ff ff       	call   102b29 <__intr_restore>
}
  102d27:	c9                   	leave  
  102d28:	c3                   	ret    

00102d29 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102d29:	55                   	push   %ebp
  102d2a:	89 e5                	mov    %esp,%ebp
  102d2c:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102d2f:	e8 cb fd ff ff       	call   102aff <__intr_save>
  102d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102d37:	a1 6c e9 11 00       	mov    0x11e96c,%eax
  102d3c:	8b 40 14             	mov    0x14(%eax),%eax
  102d3f:	ff d0                	call   *%eax
  102d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d47:	89 04 24             	mov    %eax,(%esp)
  102d4a:	e8 da fd ff ff       	call   102b29 <__intr_restore>
    return ret;
  102d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102d52:	c9                   	leave  
  102d53:	c3                   	ret    

00102d54 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102d54:	55                   	push   %ebp
  102d55:	89 e5                	mov    %esp,%ebp
  102d57:	57                   	push   %edi
  102d58:	56                   	push   %esi
  102d59:	53                   	push   %ebx
  102d5a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102d60:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102d67:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102d6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102d75:	c7 04 24 c7 a5 10 00 	movl   $0x10a5c7,(%esp)
  102d7c:	e8 10 d5 ff ff       	call   100291 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102d81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d88:	e9 15 01 00 00       	jmp    102ea2 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102d8d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d93:	89 d0                	mov    %edx,%eax
  102d95:	c1 e0 02             	shl    $0x2,%eax
  102d98:	01 d0                	add    %edx,%eax
  102d9a:	c1 e0 02             	shl    $0x2,%eax
  102d9d:	01 c8                	add    %ecx,%eax
  102d9f:	8b 50 08             	mov    0x8(%eax),%edx
  102da2:	8b 40 04             	mov    0x4(%eax),%eax
  102da5:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102da8:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102dab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102dae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102db1:	89 d0                	mov    %edx,%eax
  102db3:	c1 e0 02             	shl    $0x2,%eax
  102db6:	01 d0                	add    %edx,%eax
  102db8:	c1 e0 02             	shl    $0x2,%eax
  102dbb:	01 c8                	add    %ecx,%eax
  102dbd:	8b 48 0c             	mov    0xc(%eax),%ecx
  102dc0:	8b 58 10             	mov    0x10(%eax),%ebx
  102dc3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102dc6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102dc9:	01 c8                	add    %ecx,%eax
  102dcb:	11 da                	adc    %ebx,%edx
  102dcd:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102dd0:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102dd3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dd9:	89 d0                	mov    %edx,%eax
  102ddb:	c1 e0 02             	shl    $0x2,%eax
  102dde:	01 d0                	add    %edx,%eax
  102de0:	c1 e0 02             	shl    $0x2,%eax
  102de3:	01 c8                	add    %ecx,%eax
  102de5:	83 c0 14             	add    $0x14,%eax
  102de8:	8b 00                	mov    (%eax),%eax
  102dea:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  102df0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102df3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102df6:	83 c0 ff             	add    $0xffffffff,%eax
  102df9:	83 d2 ff             	adc    $0xffffffff,%edx
  102dfc:	89 c6                	mov    %eax,%esi
  102dfe:	89 d7                	mov    %edx,%edi
  102e00:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e03:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e06:	89 d0                	mov    %edx,%eax
  102e08:	c1 e0 02             	shl    $0x2,%eax
  102e0b:	01 d0                	add    %edx,%eax
  102e0d:	c1 e0 02             	shl    $0x2,%eax
  102e10:	01 c8                	add    %ecx,%eax
  102e12:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e15:	8b 58 10             	mov    0x10(%eax),%ebx
  102e18:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102e1e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  102e22:	89 74 24 14          	mov    %esi,0x14(%esp)
  102e26:	89 7c 24 18          	mov    %edi,0x18(%esp)
  102e2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102e2d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102e30:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e34:	89 54 24 10          	mov    %edx,0x10(%esp)
  102e38:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102e3c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102e40:	c7 04 24 d4 a5 10 00 	movl   $0x10a5d4,(%esp)
  102e47:	e8 45 d4 ff ff       	call   100291 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102e4c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e52:	89 d0                	mov    %edx,%eax
  102e54:	c1 e0 02             	shl    $0x2,%eax
  102e57:	01 d0                	add    %edx,%eax
  102e59:	c1 e0 02             	shl    $0x2,%eax
  102e5c:	01 c8                	add    %ecx,%eax
  102e5e:	83 c0 14             	add    $0x14,%eax
  102e61:	8b 00                	mov    (%eax),%eax
  102e63:	83 f8 01             	cmp    $0x1,%eax
  102e66:	75 36                	jne    102e9e <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  102e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e6e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102e71:	77 2b                	ja     102e9e <page_init+0x14a>
  102e73:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102e76:	72 05                	jb     102e7d <page_init+0x129>
  102e78:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102e7b:	73 21                	jae    102e9e <page_init+0x14a>
  102e7d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102e81:	77 1b                	ja     102e9e <page_init+0x14a>
  102e83:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102e87:	72 09                	jb     102e92 <page_init+0x13e>
  102e89:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102e90:	77 0c                	ja     102e9e <page_init+0x14a>
                maxpa = end;
  102e92:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e95:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e98:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102e9e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102ea2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ea5:	8b 00                	mov    (%eax),%eax
  102ea7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102eaa:	0f 8f dd fe ff ff    	jg     102d8d <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102eb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102eb4:	72 1d                	jb     102ed3 <page_init+0x17f>
  102eb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102eba:	77 09                	ja     102ec5 <page_init+0x171>
  102ebc:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102ec3:	76 0e                	jbe    102ed3 <page_init+0x17f>
        maxpa = KMEMSIZE;
  102ec5:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102ecc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ed6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ed9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102edd:	c1 ea 0c             	shr    $0xc,%edx
  102ee0:	a3 c0 e8 11 00       	mov    %eax,0x11e8c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102ee5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102eec:	b8 84 e9 11 00       	mov    $0x11e984,%eax
  102ef1:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ef4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102ef7:	01 d0                	add    %edx,%eax
  102ef9:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102efc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102eff:	ba 00 00 00 00       	mov    $0x0,%edx
  102f04:	f7 75 ac             	divl   -0x54(%ebp)
  102f07:	89 d0                	mov    %edx,%eax
  102f09:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102f0c:	29 c2                	sub    %eax,%edx
  102f0e:	89 d0                	mov    %edx,%eax
  102f10:	a3 74 e9 11 00       	mov    %eax,0x11e974

    for (i = 0; i < npage; i ++) {
  102f15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f1c:	eb 2f                	jmp    102f4d <page_init+0x1f9>
        SetPageReserved(pages + i);
  102f1e:	8b 0d 74 e9 11 00    	mov    0x11e974,%ecx
  102f24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f27:	89 d0                	mov    %edx,%eax
  102f29:	c1 e0 02             	shl    $0x2,%eax
  102f2c:	01 d0                	add    %edx,%eax
  102f2e:	c1 e0 02             	shl    $0x2,%eax
  102f31:	01 c8                	add    %ecx,%eax
  102f33:	83 c0 04             	add    $0x4,%eax
  102f36:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102f3d:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f40:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f43:	8b 55 90             	mov    -0x70(%ebp),%edx
  102f46:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  102f49:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102f4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f50:	a1 c0 e8 11 00       	mov    0x11e8c0,%eax
  102f55:	39 c2                	cmp    %eax,%edx
  102f57:	72 c5                	jb     102f1e <page_init+0x1ca>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102f59:	8b 15 c0 e8 11 00    	mov    0x11e8c0,%edx
  102f5f:	89 d0                	mov    %edx,%eax
  102f61:	c1 e0 02             	shl    $0x2,%eax
  102f64:	01 d0                	add    %edx,%eax
  102f66:	c1 e0 02             	shl    $0x2,%eax
  102f69:	89 c2                	mov    %eax,%edx
  102f6b:	a1 74 e9 11 00       	mov    0x11e974,%eax
  102f70:	01 d0                	add    %edx,%eax
  102f72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102f75:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102f7c:	77 23                	ja     102fa1 <page_init+0x24d>
  102f7e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102f81:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f85:	c7 44 24 08 04 a6 10 	movl   $0x10a604,0x8(%esp)
  102f8c:	00 
  102f8d:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102f94:	00 
  102f95:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  102f9c:	e8 47 d4 ff ff       	call   1003e8 <__panic>
  102fa1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102fa4:	05 00 00 00 40       	add    $0x40000000,%eax
  102fa9:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102fac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fb3:	e9 74 01 00 00       	jmp    10312c <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102fb8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fbe:	89 d0                	mov    %edx,%eax
  102fc0:	c1 e0 02             	shl    $0x2,%eax
  102fc3:	01 d0                	add    %edx,%eax
  102fc5:	c1 e0 02             	shl    $0x2,%eax
  102fc8:	01 c8                	add    %ecx,%eax
  102fca:	8b 50 08             	mov    0x8(%eax),%edx
  102fcd:	8b 40 04             	mov    0x4(%eax),%eax
  102fd0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102fd3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fd6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fd9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fdc:	89 d0                	mov    %edx,%eax
  102fde:	c1 e0 02             	shl    $0x2,%eax
  102fe1:	01 d0                	add    %edx,%eax
  102fe3:	c1 e0 02             	shl    $0x2,%eax
  102fe6:	01 c8                	add    %ecx,%eax
  102fe8:	8b 48 0c             	mov    0xc(%eax),%ecx
  102feb:	8b 58 10             	mov    0x10(%eax),%ebx
  102fee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ff1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ff4:	01 c8                	add    %ecx,%eax
  102ff6:	11 da                	adc    %ebx,%edx
  102ff8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102ffb:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102ffe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103001:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103004:	89 d0                	mov    %edx,%eax
  103006:	c1 e0 02             	shl    $0x2,%eax
  103009:	01 d0                	add    %edx,%eax
  10300b:	c1 e0 02             	shl    $0x2,%eax
  10300e:	01 c8                	add    %ecx,%eax
  103010:	83 c0 14             	add    $0x14,%eax
  103013:	8b 00                	mov    (%eax),%eax
  103015:	83 f8 01             	cmp    $0x1,%eax
  103018:	0f 85 0a 01 00 00    	jne    103128 <page_init+0x3d4>
            if (begin < freemem) {
  10301e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103021:	ba 00 00 00 00       	mov    $0x0,%edx
  103026:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103029:	72 17                	jb     103042 <page_init+0x2ee>
  10302b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10302e:	77 05                	ja     103035 <page_init+0x2e1>
  103030:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103033:	76 0d                	jbe    103042 <page_init+0x2ee>
                begin = freemem;
  103035:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103038:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10303b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103042:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103046:	72 1d                	jb     103065 <page_init+0x311>
  103048:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10304c:	77 09                	ja     103057 <page_init+0x303>
  10304e:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103055:	76 0e                	jbe    103065 <page_init+0x311>
                end = KMEMSIZE;
  103057:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10305e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103065:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103068:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10306b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10306e:	0f 87 b4 00 00 00    	ja     103128 <page_init+0x3d4>
  103074:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103077:	72 09                	jb     103082 <page_init+0x32e>
  103079:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10307c:	0f 83 a6 00 00 00    	jae    103128 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  103082:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  103089:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10308c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10308f:	01 d0                	add    %edx,%eax
  103091:	83 e8 01             	sub    $0x1,%eax
  103094:	89 45 98             	mov    %eax,-0x68(%ebp)
  103097:	8b 45 98             	mov    -0x68(%ebp),%eax
  10309a:	ba 00 00 00 00       	mov    $0x0,%edx
  10309f:	f7 75 9c             	divl   -0x64(%ebp)
  1030a2:	89 d0                	mov    %edx,%eax
  1030a4:	8b 55 98             	mov    -0x68(%ebp),%edx
  1030a7:	29 c2                	sub    %eax,%edx
  1030a9:	89 d0                	mov    %edx,%eax
  1030ab:	ba 00 00 00 00       	mov    $0x0,%edx
  1030b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1030b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030b9:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1030bc:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1030bf:	ba 00 00 00 00       	mov    $0x0,%edx
  1030c4:	89 c7                	mov    %eax,%edi
  1030c6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1030cc:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1030cf:	89 d0                	mov    %edx,%eax
  1030d1:	83 e0 00             	and    $0x0,%eax
  1030d4:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1030d7:	8b 45 80             	mov    -0x80(%ebp),%eax
  1030da:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1030dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1030e0:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1030e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030e9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1030ec:	77 3a                	ja     103128 <page_init+0x3d4>
  1030ee:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1030f1:	72 05                	jb     1030f8 <page_init+0x3a4>
  1030f3:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1030f6:	73 30                	jae    103128 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1030f8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1030fb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1030fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103101:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103104:	29 c8                	sub    %ecx,%eax
  103106:	19 da                	sbb    %ebx,%edx
  103108:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10310c:	c1 ea 0c             	shr    $0xc,%edx
  10310f:	89 c3                	mov    %eax,%ebx
  103111:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103114:	89 04 24             	mov    %eax,(%esp)
  103117:	e8 bd f8 ff ff       	call   1029d9 <pa2page>
  10311c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103120:	89 04 24             	mov    %eax,(%esp)
  103123:	e8 78 fb ff ff       	call   102ca0 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  103128:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10312c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10312f:	8b 00                	mov    (%eax),%eax
  103131:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103134:	0f 8f 7e fe ff ff    	jg     102fb8 <page_init+0x264>
                }
            }
        }
    }
}
  10313a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103140:	5b                   	pop    %ebx
  103141:	5e                   	pop    %esi
  103142:	5f                   	pop    %edi
  103143:	5d                   	pop    %ebp
  103144:	c3                   	ret    

00103145 <enable_paging>:

static void
enable_paging(void) {
  103145:	55                   	push   %ebp
  103146:	89 e5                	mov    %esp,%ebp
  103148:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10314b:	a1 70 e9 11 00       	mov    0x11e970,%eax
  103150:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  103153:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103156:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  103159:	0f 20 c0             	mov    %cr0,%eax
  10315c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  10315f:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  103162:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  103165:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  10316c:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  103170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103173:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  103176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103179:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10317c:	c9                   	leave  
  10317d:	c3                   	ret    

0010317e <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10317e:	55                   	push   %ebp
  10317f:	89 e5                	mov    %esp,%ebp
  103181:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103184:	8b 45 14             	mov    0x14(%ebp),%eax
  103187:	8b 55 0c             	mov    0xc(%ebp),%edx
  10318a:	31 d0                	xor    %edx,%eax
  10318c:	25 ff 0f 00 00       	and    $0xfff,%eax
  103191:	85 c0                	test   %eax,%eax
  103193:	74 24                	je     1031b9 <boot_map_segment+0x3b>
  103195:	c7 44 24 0c 36 a6 10 	movl   $0x10a636,0xc(%esp)
  10319c:	00 
  10319d:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  1031a4:	00 
  1031a5:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  1031ac:	00 
  1031ad:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  1031b4:	e8 2f d2 ff ff       	call   1003e8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1031b9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1031c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031c3:	25 ff 0f 00 00       	and    $0xfff,%eax
  1031c8:	89 c2                	mov    %eax,%edx
  1031ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1031cd:	01 c2                	add    %eax,%edx
  1031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031d2:	01 d0                	add    %edx,%eax
  1031d4:	83 e8 01             	sub    $0x1,%eax
  1031d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031dd:	ba 00 00 00 00       	mov    $0x0,%edx
  1031e2:	f7 75 f0             	divl   -0x10(%ebp)
  1031e5:	89 d0                	mov    %edx,%eax
  1031e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1031ea:	29 c2                	sub    %eax,%edx
  1031ec:	89 d0                	mov    %edx,%eax
  1031ee:	c1 e8 0c             	shr    $0xc,%eax
  1031f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1031f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103202:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103205:	8b 45 14             	mov    0x14(%ebp),%eax
  103208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10320b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10320e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103213:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103216:	eb 6b                	jmp    103283 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103218:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10321f:	00 
  103220:	8b 45 0c             	mov    0xc(%ebp),%eax
  103223:	89 44 24 04          	mov    %eax,0x4(%esp)
  103227:	8b 45 08             	mov    0x8(%ebp),%eax
  10322a:	89 04 24             	mov    %eax,(%esp)
  10322d:	e8 cc 01 00 00       	call   1033fe <get_pte>
  103232:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103235:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103239:	75 24                	jne    10325f <boot_map_segment+0xe1>
  10323b:	c7 44 24 0c 62 a6 10 	movl   $0x10a662,0xc(%esp)
  103242:	00 
  103243:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  10324a:	00 
  10324b:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  103252:	00 
  103253:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  10325a:	e8 89 d1 ff ff       	call   1003e8 <__panic>
        *ptep = pa | PTE_P | perm;
  10325f:	8b 45 18             	mov    0x18(%ebp),%eax
  103262:	8b 55 14             	mov    0x14(%ebp),%edx
  103265:	09 d0                	or     %edx,%eax
  103267:	83 c8 01             	or     $0x1,%eax
  10326a:	89 c2                	mov    %eax,%edx
  10326c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10326f:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103271:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103275:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10327c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103287:	75 8f                	jne    103218 <boot_map_segment+0x9a>
    }
}
  103289:	c9                   	leave  
  10328a:	c3                   	ret    

0010328b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10328b:	55                   	push   %ebp
  10328c:	89 e5                	mov    %esp,%ebp
  10328e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  103291:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103298:	e8 22 fa ff ff       	call   102cbf <alloc_pages>
  10329d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1032a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032a4:	75 1c                	jne    1032c2 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1032a6:	c7 44 24 08 6f a6 10 	movl   $0x10a66f,0x8(%esp)
  1032ad:	00 
  1032ae:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  1032b5:	00 
  1032b6:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  1032bd:	e8 26 d1 ff ff       	call   1003e8 <__panic>
    }
    return page2kva(p);
  1032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032c5:	89 04 24             	mov    %eax,(%esp)
  1032c8:	e8 5b f7 ff ff       	call   102a28 <page2kva>
}
  1032cd:	c9                   	leave  
  1032ce:	c3                   	ret    

001032cf <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1032cf:	55                   	push   %ebp
  1032d0:	89 e5                	mov    %esp,%ebp
  1032d2:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1032d5:	e8 93 f9 ff ff       	call   102c6d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1032da:	e8 75 fa ff ff       	call   102d54 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1032df:	e8 66 04 00 00       	call   10374a <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1032e4:	e8 a2 ff ff ff       	call   10328b <boot_alloc_page>
  1032e9:	a3 c4 e8 11 00       	mov    %eax,0x11e8c4
    memset(boot_pgdir, 0, PGSIZE);
  1032ee:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  1032f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1032fa:	00 
  1032fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103302:	00 
  103303:	89 04 24             	mov    %eax,(%esp)
  103306:	e8 f7 62 00 00       	call   109602 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10330b:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103310:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103313:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10331a:	77 23                	ja     10333f <pmm_init+0x70>
  10331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10331f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103323:	c7 44 24 08 04 a6 10 	movl   $0x10a604,0x8(%esp)
  10332a:	00 
  10332b:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  103332:	00 
  103333:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  10333a:	e8 a9 d0 ff ff       	call   1003e8 <__panic>
  10333f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103342:	05 00 00 00 40       	add    $0x40000000,%eax
  103347:	a3 70 e9 11 00       	mov    %eax,0x11e970

    check_pgdir();
  10334c:	e8 17 04 00 00       	call   103768 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103351:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103356:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10335c:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103361:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103364:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10336b:	77 23                	ja     103390 <pmm_init+0xc1>
  10336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103370:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103374:	c7 44 24 08 04 a6 10 	movl   $0x10a604,0x8(%esp)
  10337b:	00 
  10337c:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  103383:	00 
  103384:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  10338b:	e8 58 d0 ff ff       	call   1003e8 <__panic>
  103390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103393:	05 00 00 00 40       	add    $0x40000000,%eax
  103398:	83 c8 03             	or     $0x3,%eax
  10339b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10339d:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  1033a2:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1033a9:	00 
  1033aa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1033b1:	00 
  1033b2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1033b9:	38 
  1033ba:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1033c1:	c0 
  1033c2:	89 04 24             	mov    %eax,(%esp)
  1033c5:	e8 b4 fd ff ff       	call   10317e <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1033ca:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  1033cf:	8b 15 c4 e8 11 00    	mov    0x11e8c4,%edx
  1033d5:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1033db:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1033dd:	e8 63 fd ff ff       	call   103145 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1033e2:	e8 97 f7 ff ff       	call   102b7e <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1033e7:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  1033ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1033f2:	e8 0c 0a 00 00       	call   103e03 <check_boot_pgdir>

    print_pgdir();
  1033f7:	e8 99 0e 00 00       	call   104295 <print_pgdir>

}
  1033fc:	c9                   	leave  
  1033fd:	c3                   	ret    

001033fe <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1033fe:	55                   	push   %ebp
  1033ff:	89 e5                	mov    %esp,%ebp
  103401:	83 ec 38             	sub    $0x38,%esp
     * typedef uintptr_t pte_t;
     * typedef uintptr_t pde_t;
     */
    //pgdir是一级页表本身,pde_t是一级页表的表项, pte_t表示二级页表的表项
    //pgdir给出页表起始地址。通过查找这个页表，我们可以得到一级页表项(二级页表的入口地址)。
    pde_t *pdep = &pgdir[PDX(la)];//根据虚地址的高十位查询页目录，找到页表项的pdep
  103404:	8b 45 0c             	mov    0xc(%ebp),%eax
  103407:	c1 e8 16             	shr    $0x16,%eax
  10340a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103411:	8b 45 08             	mov    0x8(%ebp),%eax
  103414:	01 d0                	add    %edx,%eax
  103416:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
  103419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10341c:	8b 00                	mov    (%eax),%eax
  10341e:	83 e0 01             	and    $0x1,%eax
  103421:	85 c0                	test   %eax,%eax
  103423:	0f 85 af 00 00 00    	jne    1034d8 <get_pte+0xda>
        //如果在查找二级页表项时，发现对应的二级页表不存在，则需要根据create参数的值来处理是否创建新的二级页表。
        struct  Page* page = alloc_page();
  103429:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103430:	e8 8a f8 ff ff       	call   102cbf <alloc_pages>
  103435:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(!create||page==NULL){
  103438:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10343c:	74 06                	je     103444 <get_pte+0x46>
  10343e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103442:	75 0a                	jne    10344e <get_pte+0x50>
            return NULL;
  103444:	b8 00 00 00 00       	mov    $0x0,%eax
  103449:	e9 e6 00 00 00       	jmp    103534 <get_pte+0x136>
        }                  
        set_page_ref(page,1);//引用次数加一
  10344e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103455:	00 
  103456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103459:	89 04 24             	mov    %eax,(%esp)
  10345c:	e8 63 f6 ff ff       	call   102ac4 <set_page_ref>
        uintptr_t pa = page2pa(page); //获取页的线性地址
  103461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103464:	89 04 24             	mov    %eax,(%esp)
  103467:	e8 57 f5 ff ff       	call   1029c3 <page2pa>
  10346c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa),0,PGSIZE);//初始化,新申请的页全设为零，因为这个页所代表的虚拟地址都没有被映射。
  10346f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103472:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103478:	c1 e8 0c             	shr    $0xc,%eax
  10347b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10347e:	a1 c0 e8 11 00       	mov    0x11e8c0,%eax
  103483:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103486:	72 23                	jb     1034ab <get_pte+0xad>
  103488:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10348b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10348f:	c7 44 24 08 60 a5 10 	movl   $0x10a560,0x8(%esp)
  103496:	00 
  103497:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
  10349e:	00 
  10349f:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  1034a6:	e8 3d cf ff ff       	call   1003e8 <__panic>
  1034ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034ae:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1034b3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1034ba:	00 
  1034bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1034c2:	00 
  1034c3:	89 04 24             	mov    %eax,(%esp)
  1034c6:	e8 37 61 00 00       	call   109602 <memset>
        *pdep=pa|PTE_U|PTE_W|PTE_P;//设置控制位
  1034cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034ce:	83 c8 07             	or     $0x7,%eax
  1034d1:	89 c2                	mov    %eax,%edx
  1034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034d6:	89 10                	mov    %edx,(%eax)
    }
    //KADDR(PDE_ADDR(*pdep)):这部分是由页目录项地址得到关联的页表物理地址， 再转成虚拟地址。
    //PTX(la)：返回虚拟地址la的页表项索引
    //最后返回的是虚拟地址la对应的页表项入口地址  
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; 
  1034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034db:	8b 00                	mov    (%eax),%eax
  1034dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1034e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1034e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034e8:	c1 e8 0c             	shr    $0xc,%eax
  1034eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1034ee:	a1 c0 e8 11 00       	mov    0x11e8c0,%eax
  1034f3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1034f6:	72 23                	jb     10351b <get_pte+0x11d>
  1034f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034ff:	c7 44 24 08 60 a5 10 	movl   $0x10a560,0x8(%esp)
  103506:	00 
  103507:	c7 44 24 04 81 01 00 	movl   $0x181,0x4(%esp)
  10350e:	00 
  10350f:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103516:	e8 cd ce ff ff       	call   1003e8 <__panic>
  10351b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10351e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103523:	8b 55 0c             	mov    0xc(%ebp),%edx
  103526:	c1 ea 0c             	shr    $0xc,%edx
  103529:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  10352f:	c1 e2 02             	shl    $0x2,%edx
  103532:	01 d0                	add    %edx,%eax
}
  103534:	c9                   	leave  
  103535:	c3                   	ret    

00103536 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  103536:	55                   	push   %ebp
  103537:	89 e5                	mov    %esp,%ebp
  103539:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10353c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103543:	00 
  103544:	8b 45 0c             	mov    0xc(%ebp),%eax
  103547:	89 44 24 04          	mov    %eax,0x4(%esp)
  10354b:	8b 45 08             	mov    0x8(%ebp),%eax
  10354e:	89 04 24             	mov    %eax,(%esp)
  103551:	e8 a8 fe ff ff       	call   1033fe <get_pte>
  103556:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103559:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10355d:	74 08                	je     103567 <get_page+0x31>
        *ptep_store = ptep;
  10355f:	8b 45 10             	mov    0x10(%ebp),%eax
  103562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103565:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10356b:	74 1b                	je     103588 <get_page+0x52>
  10356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103570:	8b 00                	mov    (%eax),%eax
  103572:	83 e0 01             	and    $0x1,%eax
  103575:	85 c0                	test   %eax,%eax
  103577:	74 0f                	je     103588 <get_page+0x52>
        return pa2page(*ptep);
  103579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10357c:	8b 00                	mov    (%eax),%eax
  10357e:	89 04 24             	mov    %eax,(%esp)
  103581:	e8 53 f4 ff ff       	call   1029d9 <pa2page>
  103586:	eb 05                	jmp    10358d <get_page+0x57>
    }
    return NULL;
  103588:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10358d:	c9                   	leave  
  10358e:	c3                   	ret    

0010358f <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10358f:	55                   	push   %ebp
  103590:	89 e5                	mov    %esp,%ebp
  103592:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     *                        当修改的页表是进程正在使用的那些页表，使之无效。
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    if (*ptep & PTE_P) {// 页表项存在
  103595:	8b 45 10             	mov    0x10(%ebp),%eax
  103598:	8b 00                	mov    (%eax),%eax
  10359a:	83 e0 01             	and    $0x1,%eax
  10359d:	85 c0                	test   %eax,%eax
  10359f:	74 4d                	je     1035ee <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //找到页表项
  1035a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1035a4:	8b 00                	mov    (%eax),%eax
  1035a6:	89 04 24             	mov    %eax,(%esp)
  1035a9:	e8 ce f4 ff ff       	call   102a7c <pte2page>
  1035ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(page_ref_dec(page)==0)
  1035b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035b4:	89 04 24             	mov    %eax,(%esp)
  1035b7:	e8 2c f5 ff ff       	call   102ae8 <page_ref_dec>
  1035bc:	85 c0                	test   %eax,%eax
  1035be:	75 13                	jne    1035d3 <page_remove_pte+0x44>
        {//判断此页被引用的次数，如果仅仅被引用一次，则这个页也可以被释放。否则，只能释放页表入口
            free_page(page);//释放页
  1035c0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035c7:	00 
  1035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035cb:	89 04 24             	mov    %eax,(%esp)
  1035ce:	e8 24 f7 ff ff       	call   102cf7 <free_pages>
        }                         
        *ptep=0;//该页目录项清零
  1035d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1035d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir,la);//flush tlb
  1035dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e6:	89 04 24             	mov    %eax,(%esp)
  1035e9:	e8 ff 00 00 00       	call   1036ed <tlb_invalidate>
    }
}
  1035ee:	c9                   	leave  
  1035ef:	c3                   	ret    

001035f0 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1035f0:	55                   	push   %ebp
  1035f1:	89 e5                	mov    %esp,%ebp
  1035f3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1035f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1035fd:	00 
  1035fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103601:	89 44 24 04          	mov    %eax,0x4(%esp)
  103605:	8b 45 08             	mov    0x8(%ebp),%eax
  103608:	89 04 24             	mov    %eax,(%esp)
  10360b:	e8 ee fd ff ff       	call   1033fe <get_pte>
  103610:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103617:	74 19                	je     103632 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  103619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10361c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103620:	8b 45 0c             	mov    0xc(%ebp),%eax
  103623:	89 44 24 04          	mov    %eax,0x4(%esp)
  103627:	8b 45 08             	mov    0x8(%ebp),%eax
  10362a:	89 04 24             	mov    %eax,(%esp)
  10362d:	e8 5d ff ff ff       	call   10358f <page_remove_pte>
    }
}
  103632:	c9                   	leave  
  103633:	c3                   	ret    

00103634 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103634:	55                   	push   %ebp
  103635:	89 e5                	mov    %esp,%ebp
  103637:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10363a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103641:	00 
  103642:	8b 45 10             	mov    0x10(%ebp),%eax
  103645:	89 44 24 04          	mov    %eax,0x4(%esp)
  103649:	8b 45 08             	mov    0x8(%ebp),%eax
  10364c:	89 04 24             	mov    %eax,(%esp)
  10364f:	e8 aa fd ff ff       	call   1033fe <get_pte>
  103654:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10365b:	75 0a                	jne    103667 <page_insert+0x33>
        return -E_NO_MEM;
  10365d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103662:	e9 84 00 00 00       	jmp    1036eb <page_insert+0xb7>
    }
    page_ref_inc(page);
  103667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10366a:	89 04 24             	mov    %eax,(%esp)
  10366d:	e8 5f f4 ff ff       	call   102ad1 <page_ref_inc>
    if (*ptep & PTE_P) {
  103672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103675:	8b 00                	mov    (%eax),%eax
  103677:	83 e0 01             	and    $0x1,%eax
  10367a:	85 c0                	test   %eax,%eax
  10367c:	74 3e                	je     1036bc <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103681:	8b 00                	mov    (%eax),%eax
  103683:	89 04 24             	mov    %eax,(%esp)
  103686:	e8 f1 f3 ff ff       	call   102a7c <pte2page>
  10368b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10368e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103691:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103694:	75 0d                	jne    1036a3 <page_insert+0x6f>
            page_ref_dec(page);
  103696:	8b 45 0c             	mov    0xc(%ebp),%eax
  103699:	89 04 24             	mov    %eax,(%esp)
  10369c:	e8 47 f4 ff ff       	call   102ae8 <page_ref_dec>
  1036a1:	eb 19                	jmp    1036bc <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1036ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1036b4:	89 04 24             	mov    %eax,(%esp)
  1036b7:	e8 d3 fe ff ff       	call   10358f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1036bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036bf:	89 04 24             	mov    %eax,(%esp)
  1036c2:	e8 fc f2 ff ff       	call   1029c3 <page2pa>
  1036c7:	0b 45 14             	or     0x14(%ebp),%eax
  1036ca:	83 c8 01             	or     $0x1,%eax
  1036cd:	89 c2                	mov    %eax,%edx
  1036cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036d2:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1036d4:	8b 45 10             	mov    0x10(%ebp),%eax
  1036d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036db:	8b 45 08             	mov    0x8(%ebp),%eax
  1036de:	89 04 24             	mov    %eax,(%esp)
  1036e1:	e8 07 00 00 00       	call   1036ed <tlb_invalidate>
    return 0;
  1036e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1036eb:	c9                   	leave  
  1036ec:	c3                   	ret    

001036ed <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1036ed:	55                   	push   %ebp
  1036ee:	89 e5                	mov    %esp,%ebp
  1036f0:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1036f3:	0f 20 d8             	mov    %cr3,%eax
  1036f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1036f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1036fc:	89 c2                	mov    %eax,%edx
  1036fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103701:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103704:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10370b:	77 23                	ja     103730 <tlb_invalidate+0x43>
  10370d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103710:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103714:	c7 44 24 08 04 a6 10 	movl   $0x10a604,0x8(%esp)
  10371b:	00 
  10371c:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
  103723:	00 
  103724:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  10372b:	e8 b8 cc ff ff       	call   1003e8 <__panic>
  103730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103733:	05 00 00 00 40       	add    $0x40000000,%eax
  103738:	39 c2                	cmp    %eax,%edx
  10373a:	75 0c                	jne    103748 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  10373c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10373f:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103745:	0f 01 38             	invlpg (%eax)
    }
}
  103748:	c9                   	leave  
  103749:	c3                   	ret    

0010374a <check_alloc_page>:

static void
check_alloc_page(void) {
  10374a:	55                   	push   %ebp
  10374b:	89 e5                	mov    %esp,%ebp
  10374d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103750:	a1 6c e9 11 00       	mov    0x11e96c,%eax
  103755:	8b 40 18             	mov    0x18(%eax),%eax
  103758:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10375a:	c7 04 24 88 a6 10 00 	movl   $0x10a688,(%esp)
  103761:	e8 2b cb ff ff       	call   100291 <cprintf>
}
  103766:	c9                   	leave  
  103767:	c3                   	ret    

00103768 <check_pgdir>:

static void
check_pgdir(void) {
  103768:	55                   	push   %ebp
  103769:	89 e5                	mov    %esp,%ebp
  10376b:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10376e:	a1 c0 e8 11 00       	mov    0x11e8c0,%eax
  103773:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103778:	76 24                	jbe    10379e <check_pgdir+0x36>
  10377a:	c7 44 24 0c a7 a6 10 	movl   $0x10a6a7,0xc(%esp)
  103781:	00 
  103782:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103789:	00 
  10378a:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  103791:	00 
  103792:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103799:	e8 4a cc ff ff       	call   1003e8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10379e:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  1037a3:	85 c0                	test   %eax,%eax
  1037a5:	74 0e                	je     1037b5 <check_pgdir+0x4d>
  1037a7:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  1037ac:	25 ff 0f 00 00       	and    $0xfff,%eax
  1037b1:	85 c0                	test   %eax,%eax
  1037b3:	74 24                	je     1037d9 <check_pgdir+0x71>
  1037b5:	c7 44 24 0c c4 a6 10 	movl   $0x10a6c4,0xc(%esp)
  1037bc:	00 
  1037bd:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  1037c4:	00 
  1037c5:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  1037cc:	00 
  1037cd:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  1037d4:	e8 0f cc ff ff       	call   1003e8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1037d9:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  1037de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037e5:	00 
  1037e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1037ed:	00 
  1037ee:	89 04 24             	mov    %eax,(%esp)
  1037f1:	e8 40 fd ff ff       	call   103536 <get_page>
  1037f6:	85 c0                	test   %eax,%eax
  1037f8:	74 24                	je     10381e <check_pgdir+0xb6>
  1037fa:	c7 44 24 0c fc a6 10 	movl   $0x10a6fc,0xc(%esp)
  103801:	00 
  103802:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103809:	00 
  10380a:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  103811:	00 
  103812:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103819:	e8 ca cb ff ff       	call   1003e8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10381e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103825:	e8 95 f4 ff ff       	call   102cbf <alloc_pages>
  10382a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10382d:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103832:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103839:	00 
  10383a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103841:	00 
  103842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103845:	89 54 24 04          	mov    %edx,0x4(%esp)
  103849:	89 04 24             	mov    %eax,(%esp)
  10384c:	e8 e3 fd ff ff       	call   103634 <page_insert>
  103851:	85 c0                	test   %eax,%eax
  103853:	74 24                	je     103879 <check_pgdir+0x111>
  103855:	c7 44 24 0c 24 a7 10 	movl   $0x10a724,0xc(%esp)
  10385c:	00 
  10385d:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103864:	00 
  103865:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  10386c:	00 
  10386d:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103874:	e8 6f cb ff ff       	call   1003e8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103879:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  10387e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103885:	00 
  103886:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10388d:	00 
  10388e:	89 04 24             	mov    %eax,(%esp)
  103891:	e8 68 fb ff ff       	call   1033fe <get_pte>
  103896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10389d:	75 24                	jne    1038c3 <check_pgdir+0x15b>
  10389f:	c7 44 24 0c 50 a7 10 	movl   $0x10a750,0xc(%esp)
  1038a6:	00 
  1038a7:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  1038ae:	00 
  1038af:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  1038b6:	00 
  1038b7:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  1038be:	e8 25 cb ff ff       	call   1003e8 <__panic>
    assert(pa2page(*ptep) == p1);
  1038c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038c6:	8b 00                	mov    (%eax),%eax
  1038c8:	89 04 24             	mov    %eax,(%esp)
  1038cb:	e8 09 f1 ff ff       	call   1029d9 <pa2page>
  1038d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1038d3:	74 24                	je     1038f9 <check_pgdir+0x191>
  1038d5:	c7 44 24 0c 7d a7 10 	movl   $0x10a77d,0xc(%esp)
  1038dc:	00 
  1038dd:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  1038e4:	00 
  1038e5:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  1038ec:	00 
  1038ed:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  1038f4:	e8 ef ca ff ff       	call   1003e8 <__panic>
    assert(page_ref(p1) == 1);
  1038f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038fc:	89 04 24             	mov    %eax,(%esp)
  1038ff:	e8 b6 f1 ff ff       	call   102aba <page_ref>
  103904:	83 f8 01             	cmp    $0x1,%eax
  103907:	74 24                	je     10392d <check_pgdir+0x1c5>
  103909:	c7 44 24 0c 92 a7 10 	movl   $0x10a792,0xc(%esp)
  103910:	00 
  103911:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103918:	00 
  103919:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  103920:	00 
  103921:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103928:	e8 bb ca ff ff       	call   1003e8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10392d:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103932:	8b 00                	mov    (%eax),%eax
  103934:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103939:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10393c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10393f:	c1 e8 0c             	shr    $0xc,%eax
  103942:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103945:	a1 c0 e8 11 00       	mov    0x11e8c0,%eax
  10394a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10394d:	72 23                	jb     103972 <check_pgdir+0x20a>
  10394f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103952:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103956:	c7 44 24 08 60 a5 10 	movl   $0x10a560,0x8(%esp)
  10395d:	00 
  10395e:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  103965:	00 
  103966:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  10396d:	e8 76 ca ff ff       	call   1003e8 <__panic>
  103972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103975:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10397a:	83 c0 04             	add    $0x4,%eax
  10397d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103980:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103985:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10398c:	00 
  10398d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103994:	00 
  103995:	89 04 24             	mov    %eax,(%esp)
  103998:	e8 61 fa ff ff       	call   1033fe <get_pte>
  10399d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1039a0:	74 24                	je     1039c6 <check_pgdir+0x25e>
  1039a2:	c7 44 24 0c a4 a7 10 	movl   $0x10a7a4,0xc(%esp)
  1039a9:	00 
  1039aa:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  1039b1:	00 
  1039b2:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  1039b9:	00 
  1039ba:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  1039c1:	e8 22 ca ff ff       	call   1003e8 <__panic>

    p2 = alloc_page();
  1039c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039cd:	e8 ed f2 ff ff       	call   102cbf <alloc_pages>
  1039d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1039d5:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  1039da:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  1039e1:	00 
  1039e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1039e9:	00 
  1039ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1039ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  1039f1:	89 04 24             	mov    %eax,(%esp)
  1039f4:	e8 3b fc ff ff       	call   103634 <page_insert>
  1039f9:	85 c0                	test   %eax,%eax
  1039fb:	74 24                	je     103a21 <check_pgdir+0x2b9>
  1039fd:	c7 44 24 0c cc a7 10 	movl   $0x10a7cc,0xc(%esp)
  103a04:	00 
  103a05:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103a0c:	00 
  103a0d:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  103a14:	00 
  103a15:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103a1c:	e8 c7 c9 ff ff       	call   1003e8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a21:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103a26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a2d:	00 
  103a2e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103a35:	00 
  103a36:	89 04 24             	mov    %eax,(%esp)
  103a39:	e8 c0 f9 ff ff       	call   1033fe <get_pte>
  103a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a45:	75 24                	jne    103a6b <check_pgdir+0x303>
  103a47:	c7 44 24 0c 04 a8 10 	movl   $0x10a804,0xc(%esp)
  103a4e:	00 
  103a4f:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103a56:	00 
  103a57:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103a5e:	00 
  103a5f:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103a66:	e8 7d c9 ff ff       	call   1003e8 <__panic>
    assert(*ptep & PTE_U);
  103a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a6e:	8b 00                	mov    (%eax),%eax
  103a70:	83 e0 04             	and    $0x4,%eax
  103a73:	85 c0                	test   %eax,%eax
  103a75:	75 24                	jne    103a9b <check_pgdir+0x333>
  103a77:	c7 44 24 0c 34 a8 10 	movl   $0x10a834,0xc(%esp)
  103a7e:	00 
  103a7f:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103a86:	00 
  103a87:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  103a8e:	00 
  103a8f:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103a96:	e8 4d c9 ff ff       	call   1003e8 <__panic>
    assert(*ptep & PTE_W);
  103a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a9e:	8b 00                	mov    (%eax),%eax
  103aa0:	83 e0 02             	and    $0x2,%eax
  103aa3:	85 c0                	test   %eax,%eax
  103aa5:	75 24                	jne    103acb <check_pgdir+0x363>
  103aa7:	c7 44 24 0c 42 a8 10 	movl   $0x10a842,0xc(%esp)
  103aae:	00 
  103aaf:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103ab6:	00 
  103ab7:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103abe:	00 
  103abf:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103ac6:	e8 1d c9 ff ff       	call   1003e8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103acb:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103ad0:	8b 00                	mov    (%eax),%eax
  103ad2:	83 e0 04             	and    $0x4,%eax
  103ad5:	85 c0                	test   %eax,%eax
  103ad7:	75 24                	jne    103afd <check_pgdir+0x395>
  103ad9:	c7 44 24 0c 50 a8 10 	movl   $0x10a850,0xc(%esp)
  103ae0:	00 
  103ae1:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103ae8:	00 
  103ae9:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103af0:	00 
  103af1:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103af8:	e8 eb c8 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p2) == 1);
  103afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b00:	89 04 24             	mov    %eax,(%esp)
  103b03:	e8 b2 ef ff ff       	call   102aba <page_ref>
  103b08:	83 f8 01             	cmp    $0x1,%eax
  103b0b:	74 24                	je     103b31 <check_pgdir+0x3c9>
  103b0d:	c7 44 24 0c 66 a8 10 	movl   $0x10a866,0xc(%esp)
  103b14:	00 
  103b15:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103b1c:	00 
  103b1d:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  103b24:	00 
  103b25:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103b2c:	e8 b7 c8 ff ff       	call   1003e8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103b31:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103b36:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103b3d:	00 
  103b3e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103b45:	00 
  103b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103b49:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b4d:	89 04 24             	mov    %eax,(%esp)
  103b50:	e8 df fa ff ff       	call   103634 <page_insert>
  103b55:	85 c0                	test   %eax,%eax
  103b57:	74 24                	je     103b7d <check_pgdir+0x415>
  103b59:	c7 44 24 0c 78 a8 10 	movl   $0x10a878,0xc(%esp)
  103b60:	00 
  103b61:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103b68:	00 
  103b69:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  103b70:	00 
  103b71:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103b78:	e8 6b c8 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p1) == 2);
  103b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b80:	89 04 24             	mov    %eax,(%esp)
  103b83:	e8 32 ef ff ff       	call   102aba <page_ref>
  103b88:	83 f8 02             	cmp    $0x2,%eax
  103b8b:	74 24                	je     103bb1 <check_pgdir+0x449>
  103b8d:	c7 44 24 0c a4 a8 10 	movl   $0x10a8a4,0xc(%esp)
  103b94:	00 
  103b95:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103b9c:	00 
  103b9d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  103ba4:	00 
  103ba5:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103bac:	e8 37 c8 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p2) == 0);
  103bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103bb4:	89 04 24             	mov    %eax,(%esp)
  103bb7:	e8 fe ee ff ff       	call   102aba <page_ref>
  103bbc:	85 c0                	test   %eax,%eax
  103bbe:	74 24                	je     103be4 <check_pgdir+0x47c>
  103bc0:	c7 44 24 0c b6 a8 10 	movl   $0x10a8b6,0xc(%esp)
  103bc7:	00 
  103bc8:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103bcf:	00 
  103bd0:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103bd7:	00 
  103bd8:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103bdf:	e8 04 c8 ff ff       	call   1003e8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103be4:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103be9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103bf0:	00 
  103bf1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103bf8:	00 
  103bf9:	89 04 24             	mov    %eax,(%esp)
  103bfc:	e8 fd f7 ff ff       	call   1033fe <get_pte>
  103c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c08:	75 24                	jne    103c2e <check_pgdir+0x4c6>
  103c0a:	c7 44 24 0c 04 a8 10 	movl   $0x10a804,0xc(%esp)
  103c11:	00 
  103c12:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103c19:	00 
  103c1a:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103c21:	00 
  103c22:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103c29:	e8 ba c7 ff ff       	call   1003e8 <__panic>
    assert(pa2page(*ptep) == p1);
  103c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c31:	8b 00                	mov    (%eax),%eax
  103c33:	89 04 24             	mov    %eax,(%esp)
  103c36:	e8 9e ed ff ff       	call   1029d9 <pa2page>
  103c3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103c3e:	74 24                	je     103c64 <check_pgdir+0x4fc>
  103c40:	c7 44 24 0c 7d a7 10 	movl   $0x10a77d,0xc(%esp)
  103c47:	00 
  103c48:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103c4f:	00 
  103c50:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  103c57:	00 
  103c58:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103c5f:	e8 84 c7 ff ff       	call   1003e8 <__panic>
    assert((*ptep & PTE_U) == 0);
  103c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c67:	8b 00                	mov    (%eax),%eax
  103c69:	83 e0 04             	and    $0x4,%eax
  103c6c:	85 c0                	test   %eax,%eax
  103c6e:	74 24                	je     103c94 <check_pgdir+0x52c>
  103c70:	c7 44 24 0c c8 a8 10 	movl   $0x10a8c8,0xc(%esp)
  103c77:	00 
  103c78:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103c7f:	00 
  103c80:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  103c87:	00 
  103c88:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103c8f:	e8 54 c7 ff ff       	call   1003e8 <__panic>

    page_remove(boot_pgdir, 0x0);
  103c94:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103c99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103ca0:	00 
  103ca1:	89 04 24             	mov    %eax,(%esp)
  103ca4:	e8 47 f9 ff ff       	call   1035f0 <page_remove>
    assert(page_ref(p1) == 1);
  103ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cac:	89 04 24             	mov    %eax,(%esp)
  103caf:	e8 06 ee ff ff       	call   102aba <page_ref>
  103cb4:	83 f8 01             	cmp    $0x1,%eax
  103cb7:	74 24                	je     103cdd <check_pgdir+0x575>
  103cb9:	c7 44 24 0c 92 a7 10 	movl   $0x10a792,0xc(%esp)
  103cc0:	00 
  103cc1:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103cc8:	00 
  103cc9:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103cd0:	00 
  103cd1:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103cd8:	e8 0b c7 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p2) == 0);
  103cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ce0:	89 04 24             	mov    %eax,(%esp)
  103ce3:	e8 d2 ed ff ff       	call   102aba <page_ref>
  103ce8:	85 c0                	test   %eax,%eax
  103cea:	74 24                	je     103d10 <check_pgdir+0x5a8>
  103cec:	c7 44 24 0c b6 a8 10 	movl   $0x10a8b6,0xc(%esp)
  103cf3:	00 
  103cf4:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103cfb:	00 
  103cfc:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  103d03:	00 
  103d04:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103d0b:	e8 d8 c6 ff ff       	call   1003e8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103d10:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103d15:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d1c:	00 
  103d1d:	89 04 24             	mov    %eax,(%esp)
  103d20:	e8 cb f8 ff ff       	call   1035f0 <page_remove>
    assert(page_ref(p1) == 0);
  103d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d28:	89 04 24             	mov    %eax,(%esp)
  103d2b:	e8 8a ed ff ff       	call   102aba <page_ref>
  103d30:	85 c0                	test   %eax,%eax
  103d32:	74 24                	je     103d58 <check_pgdir+0x5f0>
  103d34:	c7 44 24 0c dd a8 10 	movl   $0x10a8dd,0xc(%esp)
  103d3b:	00 
  103d3c:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103d43:	00 
  103d44:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  103d4b:	00 
  103d4c:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103d53:	e8 90 c6 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p2) == 0);
  103d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d5b:	89 04 24             	mov    %eax,(%esp)
  103d5e:	e8 57 ed ff ff       	call   102aba <page_ref>
  103d63:	85 c0                	test   %eax,%eax
  103d65:	74 24                	je     103d8b <check_pgdir+0x623>
  103d67:	c7 44 24 0c b6 a8 10 	movl   $0x10a8b6,0xc(%esp)
  103d6e:	00 
  103d6f:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103d76:	00 
  103d77:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103d7e:	00 
  103d7f:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103d86:	e8 5d c6 ff ff       	call   1003e8 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  103d8b:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103d90:	8b 00                	mov    (%eax),%eax
  103d92:	89 04 24             	mov    %eax,(%esp)
  103d95:	e8 3f ec ff ff       	call   1029d9 <pa2page>
  103d9a:	89 04 24             	mov    %eax,(%esp)
  103d9d:	e8 18 ed ff ff       	call   102aba <page_ref>
  103da2:	83 f8 01             	cmp    $0x1,%eax
  103da5:	74 24                	je     103dcb <check_pgdir+0x663>
  103da7:	c7 44 24 0c f0 a8 10 	movl   $0x10a8f0,0xc(%esp)
  103dae:	00 
  103daf:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103db6:	00 
  103db7:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  103dbe:	00 
  103dbf:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103dc6:	e8 1d c6 ff ff       	call   1003e8 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  103dcb:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103dd0:	8b 00                	mov    (%eax),%eax
  103dd2:	89 04 24             	mov    %eax,(%esp)
  103dd5:	e8 ff eb ff ff       	call   1029d9 <pa2page>
  103dda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103de1:	00 
  103de2:	89 04 24             	mov    %eax,(%esp)
  103de5:	e8 0d ef ff ff       	call   102cf7 <free_pages>
    boot_pgdir[0] = 0;
  103dea:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103def:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103df5:	c7 04 24 16 a9 10 00 	movl   $0x10a916,(%esp)
  103dfc:	e8 90 c4 ff ff       	call   100291 <cprintf>
}
  103e01:	c9                   	leave  
  103e02:	c3                   	ret    

00103e03 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103e03:	55                   	push   %ebp
  103e04:	89 e5                	mov    %esp,%ebp
  103e06:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103e09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103e10:	e9 ca 00 00 00       	jmp    103edf <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e1e:	c1 e8 0c             	shr    $0xc,%eax
  103e21:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103e24:	a1 c0 e8 11 00       	mov    0x11e8c0,%eax
  103e29:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103e2c:	72 23                	jb     103e51 <check_boot_pgdir+0x4e>
  103e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e31:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e35:	c7 44 24 08 60 a5 10 	movl   $0x10a560,0x8(%esp)
  103e3c:	00 
  103e3d:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  103e44:	00 
  103e45:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103e4c:	e8 97 c5 ff ff       	call   1003e8 <__panic>
  103e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e54:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103e59:	89 c2                	mov    %eax,%edx
  103e5b:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103e60:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103e67:	00 
  103e68:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e6c:	89 04 24             	mov    %eax,(%esp)
  103e6f:	e8 8a f5 ff ff       	call   1033fe <get_pte>
  103e74:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103e77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103e7b:	75 24                	jne    103ea1 <check_boot_pgdir+0x9e>
  103e7d:	c7 44 24 0c 30 a9 10 	movl   $0x10a930,0xc(%esp)
  103e84:	00 
  103e85:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103e8c:	00 
  103e8d:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  103e94:	00 
  103e95:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103e9c:	e8 47 c5 ff ff       	call   1003e8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103ea4:	8b 00                	mov    (%eax),%eax
  103ea6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103eab:	89 c2                	mov    %eax,%edx
  103ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103eb0:	39 c2                	cmp    %eax,%edx
  103eb2:	74 24                	je     103ed8 <check_boot_pgdir+0xd5>
  103eb4:	c7 44 24 0c 6d a9 10 	movl   $0x10a96d,0xc(%esp)
  103ebb:	00 
  103ebc:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103ec3:	00 
  103ec4:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  103ecb:	00 
  103ecc:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103ed3:	e8 10 c5 ff ff       	call   1003e8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103ed8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103ee2:	a1 c0 e8 11 00       	mov    0x11e8c0,%eax
  103ee7:	39 c2                	cmp    %eax,%edx
  103ee9:	0f 82 26 ff ff ff    	jb     103e15 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103eef:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103ef4:	05 ac 0f 00 00       	add    $0xfac,%eax
  103ef9:	8b 00                	mov    (%eax),%eax
  103efb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103f00:	89 c2                	mov    %eax,%edx
  103f02:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103f07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103f0a:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103f11:	77 23                	ja     103f36 <check_boot_pgdir+0x133>
  103f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f16:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f1a:	c7 44 24 08 04 a6 10 	movl   $0x10a604,0x8(%esp)
  103f21:	00 
  103f22:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  103f29:	00 
  103f2a:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103f31:	e8 b2 c4 ff ff       	call   1003e8 <__panic>
  103f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f39:	05 00 00 00 40       	add    $0x40000000,%eax
  103f3e:	39 c2                	cmp    %eax,%edx
  103f40:	74 24                	je     103f66 <check_boot_pgdir+0x163>
  103f42:	c7 44 24 0c 84 a9 10 	movl   $0x10a984,0xc(%esp)
  103f49:	00 
  103f4a:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103f51:	00 
  103f52:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  103f59:	00 
  103f5a:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103f61:	e8 82 c4 ff ff       	call   1003e8 <__panic>

    assert(boot_pgdir[0] == 0);
  103f66:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103f6b:	8b 00                	mov    (%eax),%eax
  103f6d:	85 c0                	test   %eax,%eax
  103f6f:	74 24                	je     103f95 <check_boot_pgdir+0x192>
  103f71:	c7 44 24 0c b8 a9 10 	movl   $0x10a9b8,0xc(%esp)
  103f78:	00 
  103f79:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103f80:	00 
  103f81:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  103f88:	00 
  103f89:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103f90:	e8 53 c4 ff ff       	call   1003e8 <__panic>

    struct Page *p;
    p = alloc_page();
  103f95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103f9c:	e8 1e ed ff ff       	call   102cbf <alloc_pages>
  103fa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103fa4:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  103fa9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103fb0:	00 
  103fb1:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103fb8:	00 
  103fb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103fbc:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fc0:	89 04 24             	mov    %eax,(%esp)
  103fc3:	e8 6c f6 ff ff       	call   103634 <page_insert>
  103fc8:	85 c0                	test   %eax,%eax
  103fca:	74 24                	je     103ff0 <check_boot_pgdir+0x1ed>
  103fcc:	c7 44 24 0c cc a9 10 	movl   $0x10a9cc,0xc(%esp)
  103fd3:	00 
  103fd4:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  103fdb:	00 
  103fdc:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  103fe3:	00 
  103fe4:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  103feb:	e8 f8 c3 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p) == 1);
  103ff0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ff3:	89 04 24             	mov    %eax,(%esp)
  103ff6:	e8 bf ea ff ff       	call   102aba <page_ref>
  103ffb:	83 f8 01             	cmp    $0x1,%eax
  103ffe:	74 24                	je     104024 <check_boot_pgdir+0x221>
  104000:	c7 44 24 0c fa a9 10 	movl   $0x10a9fa,0xc(%esp)
  104007:	00 
  104008:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  10400f:	00 
  104010:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  104017:	00 
  104018:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  10401f:	e8 c4 c3 ff ff       	call   1003e8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104024:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  104029:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104030:	00 
  104031:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104038:	00 
  104039:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10403c:	89 54 24 04          	mov    %edx,0x4(%esp)
  104040:	89 04 24             	mov    %eax,(%esp)
  104043:	e8 ec f5 ff ff       	call   103634 <page_insert>
  104048:	85 c0                	test   %eax,%eax
  10404a:	74 24                	je     104070 <check_boot_pgdir+0x26d>
  10404c:	c7 44 24 0c 0c aa 10 	movl   $0x10aa0c,0xc(%esp)
  104053:	00 
  104054:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  10405b:	00 
  10405c:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  104063:	00 
  104064:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  10406b:	e8 78 c3 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p) == 2);
  104070:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104073:	89 04 24             	mov    %eax,(%esp)
  104076:	e8 3f ea ff ff       	call   102aba <page_ref>
  10407b:	83 f8 02             	cmp    $0x2,%eax
  10407e:	74 24                	je     1040a4 <check_boot_pgdir+0x2a1>
  104080:	c7 44 24 0c 43 aa 10 	movl   $0x10aa43,0xc(%esp)
  104087:	00 
  104088:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  10408f:	00 
  104090:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  104097:	00 
  104098:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  10409f:	e8 44 c3 ff ff       	call   1003e8 <__panic>

    const char *str = "ucore: Hello world!!";
  1040a4:	c7 45 dc 54 aa 10 00 	movl   $0x10aa54,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1040ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1040ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1040b2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1040b9:	e8 6d 52 00 00       	call   10932b <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1040be:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1040c5:	00 
  1040c6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1040cd:	e8 d2 52 00 00       	call   1093a4 <strcmp>
  1040d2:	85 c0                	test   %eax,%eax
  1040d4:	74 24                	je     1040fa <check_boot_pgdir+0x2f7>
  1040d6:	c7 44 24 0c 6c aa 10 	movl   $0x10aa6c,0xc(%esp)
  1040dd:	00 
  1040de:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  1040e5:	00 
  1040e6:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  1040ed:	00 
  1040ee:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  1040f5:	e8 ee c2 ff ff       	call   1003e8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1040fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040fd:	89 04 24             	mov    %eax,(%esp)
  104100:	e8 23 e9 ff ff       	call   102a28 <page2kva>
  104105:	05 00 01 00 00       	add    $0x100,%eax
  10410a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10410d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104114:	e8 ba 51 00 00       	call   1092d3 <strlen>
  104119:	85 c0                	test   %eax,%eax
  10411b:	74 24                	je     104141 <check_boot_pgdir+0x33e>
  10411d:	c7 44 24 0c a4 aa 10 	movl   $0x10aaa4,0xc(%esp)
  104124:	00 
  104125:	c7 44 24 08 4d a6 10 	movl   $0x10a64d,0x8(%esp)
  10412c:	00 
  10412d:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104134:	00 
  104135:	c7 04 24 28 a6 10 00 	movl   $0x10a628,(%esp)
  10413c:	e8 a7 c2 ff ff       	call   1003e8 <__panic>

    free_page(p);
  104141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104148:	00 
  104149:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10414c:	89 04 24             	mov    %eax,(%esp)
  10414f:	e8 a3 eb ff ff       	call   102cf7 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  104154:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  104159:	8b 00                	mov    (%eax),%eax
  10415b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104160:	89 04 24             	mov    %eax,(%esp)
  104163:	e8 71 e8 ff ff       	call   1029d9 <pa2page>
  104168:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10416f:	00 
  104170:	89 04 24             	mov    %eax,(%esp)
  104173:	e8 7f eb ff ff       	call   102cf7 <free_pages>
    boot_pgdir[0] = 0;
  104178:	a1 c4 e8 11 00       	mov    0x11e8c4,%eax
  10417d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104183:	c7 04 24 c8 aa 10 00 	movl   $0x10aac8,(%esp)
  10418a:	e8 02 c1 ff ff       	call   100291 <cprintf>
}
  10418f:	c9                   	leave  
  104190:	c3                   	ret    

00104191 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104191:	55                   	push   %ebp
  104192:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104194:	8b 45 08             	mov    0x8(%ebp),%eax
  104197:	83 e0 04             	and    $0x4,%eax
  10419a:	85 c0                	test   %eax,%eax
  10419c:	74 07                	je     1041a5 <perm2str+0x14>
  10419e:	b8 75 00 00 00       	mov    $0x75,%eax
  1041a3:	eb 05                	jmp    1041aa <perm2str+0x19>
  1041a5:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1041aa:	a2 48 e9 11 00       	mov    %al,0x11e948
    str[1] = 'r';
  1041af:	c6 05 49 e9 11 00 72 	movb   $0x72,0x11e949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1041b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1041b9:	83 e0 02             	and    $0x2,%eax
  1041bc:	85 c0                	test   %eax,%eax
  1041be:	74 07                	je     1041c7 <perm2str+0x36>
  1041c0:	b8 77 00 00 00       	mov    $0x77,%eax
  1041c5:	eb 05                	jmp    1041cc <perm2str+0x3b>
  1041c7:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1041cc:	a2 4a e9 11 00       	mov    %al,0x11e94a
    str[3] = '\0';
  1041d1:	c6 05 4b e9 11 00 00 	movb   $0x0,0x11e94b
    return str;
  1041d8:	b8 48 e9 11 00       	mov    $0x11e948,%eax
}
  1041dd:	5d                   	pop    %ebp
  1041de:	c3                   	ret    

001041df <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1041df:	55                   	push   %ebp
  1041e0:	89 e5                	mov    %esp,%ebp
  1041e2:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1041e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1041e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1041eb:	72 0a                	jb     1041f7 <get_pgtable_items+0x18>
        return 0;
  1041ed:	b8 00 00 00 00       	mov    $0x0,%eax
  1041f2:	e9 9c 00 00 00       	jmp    104293 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1041f7:	eb 04                	jmp    1041fd <get_pgtable_items+0x1e>
        start ++;
  1041f9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1041fd:	8b 45 10             	mov    0x10(%ebp),%eax
  104200:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104203:	73 18                	jae    10421d <get_pgtable_items+0x3e>
  104205:	8b 45 10             	mov    0x10(%ebp),%eax
  104208:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10420f:	8b 45 14             	mov    0x14(%ebp),%eax
  104212:	01 d0                	add    %edx,%eax
  104214:	8b 00                	mov    (%eax),%eax
  104216:	83 e0 01             	and    $0x1,%eax
  104219:	85 c0                	test   %eax,%eax
  10421b:	74 dc                	je     1041f9 <get_pgtable_items+0x1a>
    }
    if (start < right) {
  10421d:	8b 45 10             	mov    0x10(%ebp),%eax
  104220:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104223:	73 69                	jae    10428e <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  104225:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104229:	74 08                	je     104233 <get_pgtable_items+0x54>
            *left_store = start;
  10422b:	8b 45 18             	mov    0x18(%ebp),%eax
  10422e:	8b 55 10             	mov    0x10(%ebp),%edx
  104231:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104233:	8b 45 10             	mov    0x10(%ebp),%eax
  104236:	8d 50 01             	lea    0x1(%eax),%edx
  104239:	89 55 10             	mov    %edx,0x10(%ebp)
  10423c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104243:	8b 45 14             	mov    0x14(%ebp),%eax
  104246:	01 d0                	add    %edx,%eax
  104248:	8b 00                	mov    (%eax),%eax
  10424a:	83 e0 07             	and    $0x7,%eax
  10424d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104250:	eb 04                	jmp    104256 <get_pgtable_items+0x77>
            start ++;
  104252:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104256:	8b 45 10             	mov    0x10(%ebp),%eax
  104259:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10425c:	73 1d                	jae    10427b <get_pgtable_items+0x9c>
  10425e:	8b 45 10             	mov    0x10(%ebp),%eax
  104261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104268:	8b 45 14             	mov    0x14(%ebp),%eax
  10426b:	01 d0                	add    %edx,%eax
  10426d:	8b 00                	mov    (%eax),%eax
  10426f:	83 e0 07             	and    $0x7,%eax
  104272:	89 c2                	mov    %eax,%edx
  104274:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104277:	39 c2                	cmp    %eax,%edx
  104279:	74 d7                	je     104252 <get_pgtable_items+0x73>
        }
        if (right_store != NULL) {
  10427b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10427f:	74 08                	je     104289 <get_pgtable_items+0xaa>
            *right_store = start;
  104281:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104284:	8b 55 10             	mov    0x10(%ebp),%edx
  104287:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104289:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10428c:	eb 05                	jmp    104293 <get_pgtable_items+0xb4>
    }
    return 0;
  10428e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104293:	c9                   	leave  
  104294:	c3                   	ret    

00104295 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104295:	55                   	push   %ebp
  104296:	89 e5                	mov    %esp,%ebp
  104298:	57                   	push   %edi
  104299:	56                   	push   %esi
  10429a:	53                   	push   %ebx
  10429b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10429e:	c7 04 24 e8 aa 10 00 	movl   $0x10aae8,(%esp)
  1042a5:	e8 e7 bf ff ff       	call   100291 <cprintf>
    size_t left, right = 0, perm;
  1042aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1042b1:	e9 fa 00 00 00       	jmp    1043b0 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1042b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042b9:	89 04 24             	mov    %eax,(%esp)
  1042bc:	e8 d0 fe ff ff       	call   104191 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1042c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1042c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042c7:	29 d1                	sub    %edx,%ecx
  1042c9:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1042cb:	89 d6                	mov    %edx,%esi
  1042cd:	c1 e6 16             	shl    $0x16,%esi
  1042d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042d3:	89 d3                	mov    %edx,%ebx
  1042d5:	c1 e3 16             	shl    $0x16,%ebx
  1042d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042db:	89 d1                	mov    %edx,%ecx
  1042dd:	c1 e1 16             	shl    $0x16,%ecx
  1042e0:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1042e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042e6:	29 d7                	sub    %edx,%edi
  1042e8:	89 fa                	mov    %edi,%edx
  1042ea:	89 44 24 14          	mov    %eax,0x14(%esp)
  1042ee:	89 74 24 10          	mov    %esi,0x10(%esp)
  1042f2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1042f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1042fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1042fe:	c7 04 24 19 ab 10 00 	movl   $0x10ab19,(%esp)
  104305:	e8 87 bf ff ff       	call   100291 <cprintf>
        size_t l, r = left * NPTEENTRY;
  10430a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10430d:	c1 e0 0a             	shl    $0xa,%eax
  104310:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104313:	eb 54                	jmp    104369 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104318:	89 04 24             	mov    %eax,(%esp)
  10431b:	e8 71 fe ff ff       	call   104191 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104320:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104323:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104326:	29 d1                	sub    %edx,%ecx
  104328:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10432a:	89 d6                	mov    %edx,%esi
  10432c:	c1 e6 0c             	shl    $0xc,%esi
  10432f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104332:	89 d3                	mov    %edx,%ebx
  104334:	c1 e3 0c             	shl    $0xc,%ebx
  104337:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10433a:	c1 e2 0c             	shl    $0xc,%edx
  10433d:	89 d1                	mov    %edx,%ecx
  10433f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104342:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104345:	29 d7                	sub    %edx,%edi
  104347:	89 fa                	mov    %edi,%edx
  104349:	89 44 24 14          	mov    %eax,0x14(%esp)
  10434d:	89 74 24 10          	mov    %esi,0x10(%esp)
  104351:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104355:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104359:	89 54 24 04          	mov    %edx,0x4(%esp)
  10435d:	c7 04 24 38 ab 10 00 	movl   $0x10ab38,(%esp)
  104364:	e8 28 bf ff ff       	call   100291 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104369:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  10436e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104371:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104374:	89 ce                	mov    %ecx,%esi
  104376:	c1 e6 0a             	shl    $0xa,%esi
  104379:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10437c:	89 cb                	mov    %ecx,%ebx
  10437e:	c1 e3 0a             	shl    $0xa,%ebx
  104381:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  104384:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  104388:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10438b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10438f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  104393:	89 44 24 08          	mov    %eax,0x8(%esp)
  104397:	89 74 24 04          	mov    %esi,0x4(%esp)
  10439b:	89 1c 24             	mov    %ebx,(%esp)
  10439e:	e8 3c fe ff ff       	call   1041df <get_pgtable_items>
  1043a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1043aa:	0f 85 65 ff ff ff    	jne    104315 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1043b0:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1043b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1043b8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1043bb:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1043bf:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1043c2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1043c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1043ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  1043ce:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1043d5:	00 
  1043d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1043dd:	e8 fd fd ff ff       	call   1041df <get_pgtable_items>
  1043e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1043e9:	0f 85 c7 fe ff ff    	jne    1042b6 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1043ef:	c7 04 24 5c ab 10 00 	movl   $0x10ab5c,(%esp)
  1043f6:	e8 96 be ff ff       	call   100291 <cprintf>
}
  1043fb:	83 c4 4c             	add    $0x4c,%esp
  1043fe:	5b                   	pop    %ebx
  1043ff:	5e                   	pop    %esi
  104400:	5f                   	pop    %edi
  104401:	5d                   	pop    %ebp
  104402:	c3                   	ret    

00104403 <page2ppn>:
page2ppn(struct Page *page) {
  104403:	55                   	push   %ebp
  104404:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104406:	8b 55 08             	mov    0x8(%ebp),%edx
  104409:	a1 74 e9 11 00       	mov    0x11e974,%eax
  10440e:	29 c2                	sub    %eax,%edx
  104410:	89 d0                	mov    %edx,%eax
  104412:	c1 f8 02             	sar    $0x2,%eax
  104415:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10441b:	5d                   	pop    %ebp
  10441c:	c3                   	ret    

0010441d <page2pa>:
page2pa(struct Page *page) {
  10441d:	55                   	push   %ebp
  10441e:	89 e5                	mov    %esp,%ebp
  104420:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104423:	8b 45 08             	mov    0x8(%ebp),%eax
  104426:	89 04 24             	mov    %eax,(%esp)
  104429:	e8 d5 ff ff ff       	call   104403 <page2ppn>
  10442e:	c1 e0 0c             	shl    $0xc,%eax
}
  104431:	c9                   	leave  
  104432:	c3                   	ret    

00104433 <page_ref>:
page_ref(struct Page *page) {
  104433:	55                   	push   %ebp
  104434:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104436:	8b 45 08             	mov    0x8(%ebp),%eax
  104439:	8b 00                	mov    (%eax),%eax
}
  10443b:	5d                   	pop    %ebp
  10443c:	c3                   	ret    

0010443d <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  10443d:	55                   	push   %ebp
  10443e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104440:	8b 45 08             	mov    0x8(%ebp),%eax
  104443:	8b 55 0c             	mov    0xc(%ebp),%edx
  104446:	89 10                	mov    %edx,(%eax)
}
  104448:	5d                   	pop    %ebp
  104449:	c3                   	ret    

0010444a <buddy_init_size>:
#define UINT32_REMAINDER(a)     ((a)&(UINT32_MASK(a)>>1))
#define UINT32_ROUND_UP(a)      (UINT32_REMAINDER(a)?(((a)-UINT32_REMAINDER(a))<<1):(a))
#define UINT32_ROUND_DOWN(a)    (UINT32_REMAINDER(a)?((a)-UINT32_REMAINDER(a)):(a))

static void
buddy_init_size(size_t n) {
  10444a:	55                   	push   %ebp
  10444b:	89 e5                	mov    %esp,%ebp
  10444d:	57                   	push   %edi
  10444e:	56                   	push   %esi
  10444f:	53                   	push   %ebx
  104450:	83 ec 2c             	sub    $0x2c,%esp
    assert(n > 1);
  104453:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  104457:	77 24                	ja     10447d <buddy_init_size+0x33>
  104459:	c7 44 24 0c 90 ab 10 	movl   $0x10ab90,0xc(%esp)
  104460:	00 
  104461:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  104468:	00 
  104469:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  104470:	00 
  104471:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  104478:	e8 6b bf ff ff       	call   1003e8 <__panic>
    buddy_physical_size = n;
  10447d:	8b 45 08             	mov    0x8(%ebp),%eax
  104480:	a3 4c e9 11 00       	mov    %eax,0x11e94c
    if (n < 512) {
  104485:	81 7d 08 ff 01 00 00 	cmpl   $0x1ff,0x8(%ebp)
  10448c:	0f 87 de 02 00 00    	ja     104770 <buddy_init_size+0x326>
        buddy_virtual_size = UINT32_ROUND_UP(n-1);
  104492:	8b 45 08             	mov    0x8(%ebp),%eax
  104495:	8d 78 ff             	lea    -0x1(%eax),%edi
  104498:	8b 45 08             	mov    0x8(%ebp),%eax
  10449b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10449e:	8b 45 08             	mov    0x8(%ebp),%eax
  1044a1:	83 e8 01             	sub    $0x1,%eax
  1044a4:	d1 e8                	shr    %eax
  1044a6:	09 c2                	or     %eax,%edx
  1044a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1044ab:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1044ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1044b1:	83 e8 01             	sub    $0x1,%eax
  1044b4:	d1 e8                	shr    %eax
  1044b6:	09 c8                	or     %ecx,%eax
  1044b8:	c1 e8 02             	shr    $0x2,%eax
  1044bb:	09 c2                	or     %eax,%edx
  1044bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1044c0:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1044c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1044c6:	83 e8 01             	sub    $0x1,%eax
  1044c9:	d1 e8                	shr    %eax
  1044cb:	09 c1                	or     %eax,%ecx
  1044cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  1044d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d6:	83 e8 01             	sub    $0x1,%eax
  1044d9:	d1 e8                	shr    %eax
  1044db:	09 d8                	or     %ebx,%eax
  1044dd:	c1 e8 02             	shr    $0x2,%eax
  1044e0:	09 c8                	or     %ecx,%eax
  1044e2:	c1 e8 04             	shr    $0x4,%eax
  1044e5:	09 c2                	or     %eax,%edx
  1044e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1044ea:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1044ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1044f0:	83 e8 01             	sub    $0x1,%eax
  1044f3:	d1 e8                	shr    %eax
  1044f5:	09 c1                	or     %eax,%ecx
  1044f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1044fa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  1044fd:	8b 45 08             	mov    0x8(%ebp),%eax
  104500:	83 e8 01             	sub    $0x1,%eax
  104503:	d1 e8                	shr    %eax
  104505:	09 d8                	or     %ebx,%eax
  104507:	c1 e8 02             	shr    $0x2,%eax
  10450a:	09 c1                	or     %eax,%ecx
  10450c:	8b 45 08             	mov    0x8(%ebp),%eax
  10450f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  104512:	8b 45 08             	mov    0x8(%ebp),%eax
  104515:	83 e8 01             	sub    $0x1,%eax
  104518:	d1 e8                	shr    %eax
  10451a:	09 c3                	or     %eax,%ebx
  10451c:	8b 45 08             	mov    0x8(%ebp),%eax
  10451f:	8d 70 ff             	lea    -0x1(%eax),%esi
  104522:	8b 45 08             	mov    0x8(%ebp),%eax
  104525:	83 e8 01             	sub    $0x1,%eax
  104528:	d1 e8                	shr    %eax
  10452a:	09 f0                	or     %esi,%eax
  10452c:	c1 e8 02             	shr    $0x2,%eax
  10452f:	09 d8                	or     %ebx,%eax
  104531:	c1 e8 04             	shr    $0x4,%eax
  104534:	09 c8                	or     %ecx,%eax
  104536:	c1 e8 08             	shr    $0x8,%eax
  104539:	89 d6                	mov    %edx,%esi
  10453b:	09 c6                	or     %eax,%esi
  10453d:	8b 45 08             	mov    0x8(%ebp),%eax
  104540:	8d 50 ff             	lea    -0x1(%eax),%edx
  104543:	8b 45 08             	mov    0x8(%ebp),%eax
  104546:	83 e8 01             	sub    $0x1,%eax
  104549:	d1 e8                	shr    %eax
  10454b:	09 c2                	or     %eax,%edx
  10454d:	8b 45 08             	mov    0x8(%ebp),%eax
  104550:	8d 48 ff             	lea    -0x1(%eax),%ecx
  104553:	8b 45 08             	mov    0x8(%ebp),%eax
  104556:	83 e8 01             	sub    $0x1,%eax
  104559:	d1 e8                	shr    %eax
  10455b:	09 c8                	or     %ecx,%eax
  10455d:	c1 e8 02             	shr    $0x2,%eax
  104560:	09 c2                	or     %eax,%edx
  104562:	8b 45 08             	mov    0x8(%ebp),%eax
  104565:	8d 48 ff             	lea    -0x1(%eax),%ecx
  104568:	8b 45 08             	mov    0x8(%ebp),%eax
  10456b:	83 e8 01             	sub    $0x1,%eax
  10456e:	d1 e8                	shr    %eax
  104570:	09 c1                	or     %eax,%ecx
  104572:	8b 45 08             	mov    0x8(%ebp),%eax
  104575:	8d 58 ff             	lea    -0x1(%eax),%ebx
  104578:	8b 45 08             	mov    0x8(%ebp),%eax
  10457b:	83 e8 01             	sub    $0x1,%eax
  10457e:	d1 e8                	shr    %eax
  104580:	09 d8                	or     %ebx,%eax
  104582:	c1 e8 02             	shr    $0x2,%eax
  104585:	09 c8                	or     %ecx,%eax
  104587:	c1 e8 04             	shr    $0x4,%eax
  10458a:	89 d3                	mov    %edx,%ebx
  10458c:	09 c3                	or     %eax,%ebx
  10458e:	8b 45 08             	mov    0x8(%ebp),%eax
  104591:	8d 50 ff             	lea    -0x1(%eax),%edx
  104594:	8b 45 08             	mov    0x8(%ebp),%eax
  104597:	83 e8 01             	sub    $0x1,%eax
  10459a:	d1 e8                	shr    %eax
  10459c:	09 c2                	or     %eax,%edx
  10459e:	8b 45 08             	mov    0x8(%ebp),%eax
  1045a1:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1045a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1045a7:	83 e8 01             	sub    $0x1,%eax
  1045aa:	d1 e8                	shr    %eax
  1045ac:	09 c8                	or     %ecx,%eax
  1045ae:	c1 e8 02             	shr    $0x2,%eax
  1045b1:	89 d1                	mov    %edx,%ecx
  1045b3:	09 c1                	or     %eax,%ecx
  1045b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1045bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1045be:	83 e8 01             	sub    $0x1,%eax
  1045c1:	d1 e8                	shr    %eax
  1045c3:	09 c2                	or     %eax,%edx
  1045c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1045c8:	83 e8 01             	sub    $0x1,%eax
  1045cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1045ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1045d1:	83 e8 01             	sub    $0x1,%eax
  1045d4:	d1 e8                	shr    %eax
  1045d6:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1045d9:	c1 e8 02             	shr    $0x2,%eax
  1045dc:	09 d0                	or     %edx,%eax
  1045de:	c1 e8 04             	shr    $0x4,%eax
  1045e1:	09 c8                	or     %ecx,%eax
  1045e3:	c1 e8 08             	shr    $0x8,%eax
  1045e6:	09 d8                	or     %ebx,%eax
  1045e8:	c1 e8 10             	shr    $0x10,%eax
  1045eb:	09 f0                	or     %esi,%eax
  1045ed:	d1 e8                	shr    %eax
  1045ef:	21 f8                	and    %edi,%eax
  1045f1:	85 c0                	test   %eax,%eax
  1045f3:	0f 84 5d 01 00 00    	je     104756 <buddy_init_size+0x30c>
  1045f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1045fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1045ff:	8b 45 08             	mov    0x8(%ebp),%eax
  104602:	83 e8 01             	sub    $0x1,%eax
  104605:	d1 e8                	shr    %eax
  104607:	09 c2                	or     %eax,%edx
  104609:	8b 45 08             	mov    0x8(%ebp),%eax
  10460c:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10460f:	8b 45 08             	mov    0x8(%ebp),%eax
  104612:	83 e8 01             	sub    $0x1,%eax
  104615:	d1 e8                	shr    %eax
  104617:	09 c8                	or     %ecx,%eax
  104619:	c1 e8 02             	shr    $0x2,%eax
  10461c:	09 c2                	or     %eax,%edx
  10461e:	8b 45 08             	mov    0x8(%ebp),%eax
  104621:	8d 48 ff             	lea    -0x1(%eax),%ecx
  104624:	8b 45 08             	mov    0x8(%ebp),%eax
  104627:	83 e8 01             	sub    $0x1,%eax
  10462a:	d1 e8                	shr    %eax
  10462c:	09 c1                	or     %eax,%ecx
  10462e:	8b 45 08             	mov    0x8(%ebp),%eax
  104631:	8d 58 ff             	lea    -0x1(%eax),%ebx
  104634:	8b 45 08             	mov    0x8(%ebp),%eax
  104637:	83 e8 01             	sub    $0x1,%eax
  10463a:	d1 e8                	shr    %eax
  10463c:	09 d8                	or     %ebx,%eax
  10463e:	c1 e8 02             	shr    $0x2,%eax
  104641:	09 c8                	or     %ecx,%eax
  104643:	c1 e8 04             	shr    $0x4,%eax
  104646:	09 c2                	or     %eax,%edx
  104648:	8b 45 08             	mov    0x8(%ebp),%eax
  10464b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10464e:	8b 45 08             	mov    0x8(%ebp),%eax
  104651:	83 e8 01             	sub    $0x1,%eax
  104654:	d1 e8                	shr    %eax
  104656:	09 c1                	or     %eax,%ecx
  104658:	8b 45 08             	mov    0x8(%ebp),%eax
  10465b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  10465e:	8b 45 08             	mov    0x8(%ebp),%eax
  104661:	83 e8 01             	sub    $0x1,%eax
  104664:	d1 e8                	shr    %eax
  104666:	09 d8                	or     %ebx,%eax
  104668:	c1 e8 02             	shr    $0x2,%eax
  10466b:	09 c1                	or     %eax,%ecx
  10466d:	8b 45 08             	mov    0x8(%ebp),%eax
  104670:	8d 58 ff             	lea    -0x1(%eax),%ebx
  104673:	8b 45 08             	mov    0x8(%ebp),%eax
  104676:	83 e8 01             	sub    $0x1,%eax
  104679:	d1 e8                	shr    %eax
  10467b:	09 c3                	or     %eax,%ebx
  10467d:	8b 45 08             	mov    0x8(%ebp),%eax
  104680:	8d 70 ff             	lea    -0x1(%eax),%esi
  104683:	8b 45 08             	mov    0x8(%ebp),%eax
  104686:	83 e8 01             	sub    $0x1,%eax
  104689:	d1 e8                	shr    %eax
  10468b:	09 f0                	or     %esi,%eax
  10468d:	c1 e8 02             	shr    $0x2,%eax
  104690:	09 d8                	or     %ebx,%eax
  104692:	c1 e8 04             	shr    $0x4,%eax
  104695:	09 c8                	or     %ecx,%eax
  104697:	c1 e8 08             	shr    $0x8,%eax
  10469a:	09 c2                	or     %eax,%edx
  10469c:	8b 45 08             	mov    0x8(%ebp),%eax
  10469f:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1046a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1046a5:	83 e8 01             	sub    $0x1,%eax
  1046a8:	d1 e8                	shr    %eax
  1046aa:	09 c1                	or     %eax,%ecx
  1046ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1046af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  1046b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1046b5:	83 e8 01             	sub    $0x1,%eax
  1046b8:	d1 e8                	shr    %eax
  1046ba:	09 d8                	or     %ebx,%eax
  1046bc:	c1 e8 02             	shr    $0x2,%eax
  1046bf:	09 c1                	or     %eax,%ecx
  1046c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1046c4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  1046c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ca:	83 e8 01             	sub    $0x1,%eax
  1046cd:	d1 e8                	shr    %eax
  1046cf:	09 c3                	or     %eax,%ebx
  1046d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1046d4:	8d 70 ff             	lea    -0x1(%eax),%esi
  1046d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1046da:	83 e8 01             	sub    $0x1,%eax
  1046dd:	d1 e8                	shr    %eax
  1046df:	09 f0                	or     %esi,%eax
  1046e1:	c1 e8 02             	shr    $0x2,%eax
  1046e4:	09 d8                	or     %ebx,%eax
  1046e6:	c1 e8 04             	shr    $0x4,%eax
  1046e9:	09 c1                	or     %eax,%ecx
  1046eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ee:	8d 58 ff             	lea    -0x1(%eax),%ebx
  1046f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1046f4:	83 e8 01             	sub    $0x1,%eax
  1046f7:	d1 e8                	shr    %eax
  1046f9:	09 c3                	or     %eax,%ebx
  1046fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1046fe:	8d 70 ff             	lea    -0x1(%eax),%esi
  104701:	8b 45 08             	mov    0x8(%ebp),%eax
  104704:	83 e8 01             	sub    $0x1,%eax
  104707:	d1 e8                	shr    %eax
  104709:	09 f0                	or     %esi,%eax
  10470b:	c1 e8 02             	shr    $0x2,%eax
  10470e:	09 c3                	or     %eax,%ebx
  104710:	8b 45 08             	mov    0x8(%ebp),%eax
  104713:	8d 70 ff             	lea    -0x1(%eax),%esi
  104716:	8b 45 08             	mov    0x8(%ebp),%eax
  104719:	83 e8 01             	sub    $0x1,%eax
  10471c:	d1 e8                	shr    %eax
  10471e:	09 c6                	or     %eax,%esi
  104720:	8b 45 08             	mov    0x8(%ebp),%eax
  104723:	8d 78 ff             	lea    -0x1(%eax),%edi
  104726:	8b 45 08             	mov    0x8(%ebp),%eax
  104729:	83 e8 01             	sub    $0x1,%eax
  10472c:	d1 e8                	shr    %eax
  10472e:	09 f8                	or     %edi,%eax
  104730:	c1 e8 02             	shr    $0x2,%eax
  104733:	09 f0                	or     %esi,%eax
  104735:	c1 e8 04             	shr    $0x4,%eax
  104738:	09 d8                	or     %ebx,%eax
  10473a:	c1 e8 08             	shr    $0x8,%eax
  10473d:	09 c8                	or     %ecx,%eax
  10473f:	c1 e8 10             	shr    $0x10,%eax
  104742:	09 d0                	or     %edx,%eax
  104744:	d1 e8                	shr    %eax
  104746:	f7 d0                	not    %eax
  104748:	89 c2                	mov    %eax,%edx
  10474a:	8b 45 08             	mov    0x8(%ebp),%eax
  10474d:	83 e8 01             	sub    $0x1,%eax
  104750:	21 d0                	and    %edx,%eax
  104752:	01 c0                	add    %eax,%eax
  104754:	eb 06                	jmp    10475c <buddy_init_size+0x312>
  104756:	8b 45 08             	mov    0x8(%ebp),%eax
  104759:	83 e8 01             	sub    $0x1,%eax
  10475c:	a3 50 e9 11 00       	mov    %eax,0x11e950
        buddy_segment_size = 1;
  104761:	c7 05 54 e9 11 00 01 	movl   $0x1,0x11e954
  104768:	00 00 00 
  10476b:	e9 00 02 00 00       	jmp    104970 <buddy_init_size+0x526>
    } else {
        buddy_virtual_size = UINT32_ROUND_DOWN(n);
  104770:	8b 45 08             	mov    0x8(%ebp),%eax
  104773:	d1 e8                	shr    %eax
  104775:	0b 45 08             	or     0x8(%ebp),%eax
  104778:	8b 55 08             	mov    0x8(%ebp),%edx
  10477b:	d1 ea                	shr    %edx
  10477d:	0b 55 08             	or     0x8(%ebp),%edx
  104780:	c1 ea 02             	shr    $0x2,%edx
  104783:	09 d0                	or     %edx,%eax
  104785:	89 c1                	mov    %eax,%ecx
  104787:	8b 45 08             	mov    0x8(%ebp),%eax
  10478a:	d1 e8                	shr    %eax
  10478c:	0b 45 08             	or     0x8(%ebp),%eax
  10478f:	8b 55 08             	mov    0x8(%ebp),%edx
  104792:	d1 ea                	shr    %edx
  104794:	0b 55 08             	or     0x8(%ebp),%edx
  104797:	c1 ea 02             	shr    $0x2,%edx
  10479a:	09 d0                	or     %edx,%eax
  10479c:	c1 e8 04             	shr    $0x4,%eax
  10479f:	09 c1                	or     %eax,%ecx
  1047a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1047a4:	d1 e8                	shr    %eax
  1047a6:	0b 45 08             	or     0x8(%ebp),%eax
  1047a9:	8b 55 08             	mov    0x8(%ebp),%edx
  1047ac:	d1 ea                	shr    %edx
  1047ae:	0b 55 08             	or     0x8(%ebp),%edx
  1047b1:	c1 ea 02             	shr    $0x2,%edx
  1047b4:	09 d0                	or     %edx,%eax
  1047b6:	89 c3                	mov    %eax,%ebx
  1047b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1047bb:	d1 e8                	shr    %eax
  1047bd:	0b 45 08             	or     0x8(%ebp),%eax
  1047c0:	8b 55 08             	mov    0x8(%ebp),%edx
  1047c3:	d1 ea                	shr    %edx
  1047c5:	0b 55 08             	or     0x8(%ebp),%edx
  1047c8:	c1 ea 02             	shr    $0x2,%edx
  1047cb:	09 d0                	or     %edx,%eax
  1047cd:	c1 e8 04             	shr    $0x4,%eax
  1047d0:	09 d8                	or     %ebx,%eax
  1047d2:	c1 e8 08             	shr    $0x8,%eax
  1047d5:	09 c1                	or     %eax,%ecx
  1047d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1047da:	d1 e8                	shr    %eax
  1047dc:	0b 45 08             	or     0x8(%ebp),%eax
  1047df:	8b 55 08             	mov    0x8(%ebp),%edx
  1047e2:	d1 ea                	shr    %edx
  1047e4:	0b 55 08             	or     0x8(%ebp),%edx
  1047e7:	c1 ea 02             	shr    $0x2,%edx
  1047ea:	09 d0                	or     %edx,%eax
  1047ec:	89 c3                	mov    %eax,%ebx
  1047ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1047f1:	d1 e8                	shr    %eax
  1047f3:	0b 45 08             	or     0x8(%ebp),%eax
  1047f6:	8b 55 08             	mov    0x8(%ebp),%edx
  1047f9:	d1 ea                	shr    %edx
  1047fb:	0b 55 08             	or     0x8(%ebp),%edx
  1047fe:	c1 ea 02             	shr    $0x2,%edx
  104801:	09 d0                	or     %edx,%eax
  104803:	c1 e8 04             	shr    $0x4,%eax
  104806:	09 c3                	or     %eax,%ebx
  104808:	8b 45 08             	mov    0x8(%ebp),%eax
  10480b:	d1 e8                	shr    %eax
  10480d:	0b 45 08             	or     0x8(%ebp),%eax
  104810:	8b 55 08             	mov    0x8(%ebp),%edx
  104813:	d1 ea                	shr    %edx
  104815:	0b 55 08             	or     0x8(%ebp),%edx
  104818:	c1 ea 02             	shr    $0x2,%edx
  10481b:	09 d0                	or     %edx,%eax
  10481d:	89 c6                	mov    %eax,%esi
  10481f:	8b 45 08             	mov    0x8(%ebp),%eax
  104822:	d1 e8                	shr    %eax
  104824:	0b 45 08             	or     0x8(%ebp),%eax
  104827:	8b 55 08             	mov    0x8(%ebp),%edx
  10482a:	d1 ea                	shr    %edx
  10482c:	0b 55 08             	or     0x8(%ebp),%edx
  10482f:	c1 ea 02             	shr    $0x2,%edx
  104832:	09 d0                	or     %edx,%eax
  104834:	c1 e8 04             	shr    $0x4,%eax
  104837:	09 f0                	or     %esi,%eax
  104839:	c1 e8 08             	shr    $0x8,%eax
  10483c:	09 d8                	or     %ebx,%eax
  10483e:	c1 e8 10             	shr    $0x10,%eax
  104841:	09 c8                	or     %ecx,%eax
  104843:	d1 e8                	shr    %eax
  104845:	23 45 08             	and    0x8(%ebp),%eax
  104848:	85 c0                	test   %eax,%eax
  10484a:	0f 84 dc 00 00 00    	je     10492c <buddy_init_size+0x4e2>
  104850:	8b 45 08             	mov    0x8(%ebp),%eax
  104853:	d1 e8                	shr    %eax
  104855:	0b 45 08             	or     0x8(%ebp),%eax
  104858:	8b 55 08             	mov    0x8(%ebp),%edx
  10485b:	d1 ea                	shr    %edx
  10485d:	0b 55 08             	or     0x8(%ebp),%edx
  104860:	c1 ea 02             	shr    $0x2,%edx
  104863:	09 d0                	or     %edx,%eax
  104865:	89 c1                	mov    %eax,%ecx
  104867:	8b 45 08             	mov    0x8(%ebp),%eax
  10486a:	d1 e8                	shr    %eax
  10486c:	0b 45 08             	or     0x8(%ebp),%eax
  10486f:	8b 55 08             	mov    0x8(%ebp),%edx
  104872:	d1 ea                	shr    %edx
  104874:	0b 55 08             	or     0x8(%ebp),%edx
  104877:	c1 ea 02             	shr    $0x2,%edx
  10487a:	09 d0                	or     %edx,%eax
  10487c:	c1 e8 04             	shr    $0x4,%eax
  10487f:	09 c1                	or     %eax,%ecx
  104881:	8b 45 08             	mov    0x8(%ebp),%eax
  104884:	d1 e8                	shr    %eax
  104886:	0b 45 08             	or     0x8(%ebp),%eax
  104889:	8b 55 08             	mov    0x8(%ebp),%edx
  10488c:	d1 ea                	shr    %edx
  10488e:	0b 55 08             	or     0x8(%ebp),%edx
  104891:	c1 ea 02             	shr    $0x2,%edx
  104894:	09 d0                	or     %edx,%eax
  104896:	89 c3                	mov    %eax,%ebx
  104898:	8b 45 08             	mov    0x8(%ebp),%eax
  10489b:	d1 e8                	shr    %eax
  10489d:	0b 45 08             	or     0x8(%ebp),%eax
  1048a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1048a3:	d1 ea                	shr    %edx
  1048a5:	0b 55 08             	or     0x8(%ebp),%edx
  1048a8:	c1 ea 02             	shr    $0x2,%edx
  1048ab:	09 d0                	or     %edx,%eax
  1048ad:	c1 e8 04             	shr    $0x4,%eax
  1048b0:	09 d8                	or     %ebx,%eax
  1048b2:	c1 e8 08             	shr    $0x8,%eax
  1048b5:	09 c1                	or     %eax,%ecx
  1048b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1048ba:	d1 e8                	shr    %eax
  1048bc:	0b 45 08             	or     0x8(%ebp),%eax
  1048bf:	8b 55 08             	mov    0x8(%ebp),%edx
  1048c2:	d1 ea                	shr    %edx
  1048c4:	0b 55 08             	or     0x8(%ebp),%edx
  1048c7:	c1 ea 02             	shr    $0x2,%edx
  1048ca:	09 d0                	or     %edx,%eax
  1048cc:	89 c3                	mov    %eax,%ebx
  1048ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1048d1:	d1 e8                	shr    %eax
  1048d3:	0b 45 08             	or     0x8(%ebp),%eax
  1048d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1048d9:	d1 ea                	shr    %edx
  1048db:	0b 55 08             	or     0x8(%ebp),%edx
  1048de:	c1 ea 02             	shr    $0x2,%edx
  1048e1:	09 d0                	or     %edx,%eax
  1048e3:	c1 e8 04             	shr    $0x4,%eax
  1048e6:	09 c3                	or     %eax,%ebx
  1048e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1048eb:	d1 e8                	shr    %eax
  1048ed:	0b 45 08             	or     0x8(%ebp),%eax
  1048f0:	8b 55 08             	mov    0x8(%ebp),%edx
  1048f3:	d1 ea                	shr    %edx
  1048f5:	0b 55 08             	or     0x8(%ebp),%edx
  1048f8:	c1 ea 02             	shr    $0x2,%edx
  1048fb:	09 d0                	or     %edx,%eax
  1048fd:	89 c6                	mov    %eax,%esi
  1048ff:	8b 45 08             	mov    0x8(%ebp),%eax
  104902:	d1 e8                	shr    %eax
  104904:	0b 45 08             	or     0x8(%ebp),%eax
  104907:	8b 55 08             	mov    0x8(%ebp),%edx
  10490a:	d1 ea                	shr    %edx
  10490c:	0b 55 08             	or     0x8(%ebp),%edx
  10490f:	c1 ea 02             	shr    $0x2,%edx
  104912:	09 d0                	or     %edx,%eax
  104914:	c1 e8 04             	shr    $0x4,%eax
  104917:	09 f0                	or     %esi,%eax
  104919:	c1 e8 08             	shr    $0x8,%eax
  10491c:	09 d8                	or     %ebx,%eax
  10491e:	c1 e8 10             	shr    $0x10,%eax
  104921:	09 c8                	or     %ecx,%eax
  104923:	d1 e8                	shr    %eax
  104925:	f7 d0                	not    %eax
  104927:	23 45 08             	and    0x8(%ebp),%eax
  10492a:	eb 03                	jmp    10492f <buddy_init_size+0x4e5>
  10492c:	8b 45 08             	mov    0x8(%ebp),%eax
  10492f:	a3 50 e9 11 00       	mov    %eax,0x11e950
        buddy_segment_size = buddy_virtual_size*sizeof(size_t)*2/PGSIZE;
  104934:	a1 50 e9 11 00       	mov    0x11e950,%eax
  104939:	c1 e0 03             	shl    $0x3,%eax
  10493c:	c1 e8 0c             	shr    $0xc,%eax
  10493f:	a3 54 e9 11 00       	mov    %eax,0x11e954
        if (n > buddy_virtual_size + (buddy_segment_size<<1)) {
  104944:	a1 54 e9 11 00       	mov    0x11e954,%eax
  104949:	8d 14 00             	lea    (%eax,%eax,1),%edx
  10494c:	a1 50 e9 11 00       	mov    0x11e950,%eax
  104951:	01 d0                	add    %edx,%eax
  104953:	3b 45 08             	cmp    0x8(%ebp),%eax
  104956:	73 18                	jae    104970 <buddy_init_size+0x526>
            buddy_virtual_size <<= 1;
  104958:	a1 50 e9 11 00       	mov    0x11e950,%eax
  10495d:	01 c0                	add    %eax,%eax
  10495f:	a3 50 e9 11 00       	mov    %eax,0x11e950
            buddy_segment_size <<= 1;
  104964:	a1 54 e9 11 00       	mov    0x11e954,%eax
  104969:	01 c0                	add    %eax,%eax
  10496b:	a3 54 e9 11 00       	mov    %eax,0x11e954
        }
    }
    buddy_alloc_size = MIN(buddy_virtual_size, buddy_physical_size-buddy_segment_size);
  104970:	8b 15 4c e9 11 00    	mov    0x11e94c,%edx
  104976:	a1 54 e9 11 00       	mov    0x11e954,%eax
  10497b:	29 c2                	sub    %eax,%edx
  10497d:	a1 50 e9 11 00       	mov    0x11e950,%eax
  104982:	39 c2                	cmp    %eax,%edx
  104984:	0f 46 c2             	cmovbe %edx,%eax
  104987:	a3 58 e9 11 00       	mov    %eax,0x11e958
}
  10498c:	83 c4 2c             	add    $0x2c,%esp
  10498f:	5b                   	pop    %ebx
  104990:	5e                   	pop    %esi
  104991:	5f                   	pop    %edi
  104992:	5d                   	pop    %ebp
  104993:	c3                   	ret    

00104994 <buddy_init_segment>:

static void
buddy_init_segment(struct Page *base) {
  104994:	55                   	push   %ebp
  104995:	89 e5                	mov    %esp,%ebp
  104997:	57                   	push   %edi
  104998:	56                   	push   %esi
  104999:	53                   	push   %ebx
  10499a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
    // Init address
    buddy_physical = base;
  1049a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1049a3:	a3 60 e9 11 00       	mov    %eax,0x11e960
    buddy_segment = KADDR(page2pa(base));
  1049a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1049ab:	89 04 24             	mov    %eax,(%esp)
  1049ae:	e8 6a fa ff ff       	call   10441d <page2pa>
  1049b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1049b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1049b9:	c1 e8 0c             	shr    $0xc,%eax
  1049bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1049bf:	a1 c0 e8 11 00       	mov    0x11e8c0,%eax
  1049c4:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  1049c7:	72 23                	jb     1049ec <buddy_init_segment+0x58>
  1049c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1049cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1049d0:	c7 44 24 08 bc ab 10 	movl   $0x10abbc,0x8(%esp)
  1049d7:	00 
  1049d8:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  1049df:	00 
  1049e0:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  1049e7:	e8 fc b9 ff ff       	call   1003e8 <__panic>
  1049ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1049ef:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1049f4:	a3 5c e9 11 00       	mov    %eax,0x11e95c
    buddy_alloc = base + buddy_segment_size;
  1049f9:	8b 15 54 e9 11 00    	mov    0x11e954,%edx
  1049ff:	89 d0                	mov    %edx,%eax
  104a01:	c1 e0 02             	shl    $0x2,%eax
  104a04:	01 d0                	add    %edx,%eax
  104a06:	c1 e0 02             	shl    $0x2,%eax
  104a09:	89 c2                	mov    %eax,%edx
  104a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  104a0e:	01 d0                	add    %edx,%eax
  104a10:	a3 64 e9 11 00       	mov    %eax,0x11e964
    memset(buddy_segment, 0, buddy_segment_size*PGSIZE);
  104a15:	a1 54 e9 11 00       	mov    0x11e954,%eax
  104a1a:	c1 e0 0c             	shl    $0xc,%eax
  104a1d:	89 c2                	mov    %eax,%edx
  104a1f:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  104a24:	89 54 24 08          	mov    %edx,0x8(%esp)
  104a28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a2f:	00 
  104a30:	89 04 24             	mov    %eax,(%esp)
  104a33:	e8 ca 4b 00 00       	call   109602 <memset>
    // Init segment
    nr_free += buddy_alloc_size;
  104a38:	8b 15 80 e9 11 00    	mov    0x11e980,%edx
  104a3e:	a1 58 e9 11 00       	mov    0x11e958,%eax
  104a43:	01 d0                	add    %edx,%eax
  104a45:	a3 80 e9 11 00       	mov    %eax,0x11e980
    size_t block = BUDDY_ROOT;
  104a4a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    size_t alloc_size = buddy_alloc_size;
  104a51:	a1 58 e9 11 00       	mov    0x11e958,%eax
  104a56:	89 45 e0             	mov    %eax,-0x20(%ebp)
    size_t virtual_size = buddy_virtual_size;
  104a59:	a1 50 e9 11 00       	mov    0x11e950,%eax
  104a5e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    buddy_segment[block] = alloc_size;
  104a61:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  104a66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a69:	c1 e2 02             	shl    $0x2,%edx
  104a6c:	01 c2                	add    %eax,%edx
  104a6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104a71:	89 02                	mov    %eax,(%edx)
    while (alloc_size > 0 && alloc_size < virtual_size) {
  104a73:	e9 b3 03 00 00       	jmp    104e2b <buddy_init_segment+0x497>
        virtual_size >>= 1;
  104a78:	d1 6d dc             	shrl   -0x24(%ebp)
        if (alloc_size > virtual_size) {
  104a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104a7e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104a81:	0f 86 79 03 00 00    	jbe    104e00 <buddy_init_segment+0x46c>
            // Add left to free list
            struct Page *page = &buddy_alloc[BUDDY_BEGIN(block)];
  104a87:	a1 64 e9 11 00       	mov    0x11e964,%eax
  104a8c:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a92:	d1 e8                	shr    %eax
  104a94:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104a97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a9a:	d1 ea                	shr    %edx
  104a9c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104a9f:	c1 ea 02             	shr    $0x2,%edx
  104aa2:	09 d0                	or     %edx,%eax
  104aa4:	89 c1                	mov    %eax,%ecx
  104aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104aa9:	d1 e8                	shr    %eax
  104aab:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104aae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104ab1:	d1 ea                	shr    %edx
  104ab3:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104ab6:	c1 ea 02             	shr    $0x2,%edx
  104ab9:	09 d0                	or     %edx,%eax
  104abb:	c1 e8 04             	shr    $0x4,%eax
  104abe:	09 c1                	or     %eax,%ecx
  104ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ac3:	d1 e8                	shr    %eax
  104ac5:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104ac8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104acb:	d1 ea                	shr    %edx
  104acd:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104ad0:	c1 ea 02             	shr    $0x2,%edx
  104ad3:	09 d0                	or     %edx,%eax
  104ad5:	89 c3                	mov    %eax,%ebx
  104ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ada:	d1 e8                	shr    %eax
  104adc:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104adf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104ae2:	d1 ea                	shr    %edx
  104ae4:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104ae7:	c1 ea 02             	shr    $0x2,%edx
  104aea:	09 d0                	or     %edx,%eax
  104aec:	c1 e8 04             	shr    $0x4,%eax
  104aef:	09 d8                	or     %ebx,%eax
  104af1:	c1 e8 08             	shr    $0x8,%eax
  104af4:	09 c1                	or     %eax,%ecx
  104af6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104af9:	d1 e8                	shr    %eax
  104afb:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104afe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104b01:	d1 ea                	shr    %edx
  104b03:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104b06:	c1 ea 02             	shr    $0x2,%edx
  104b09:	09 d0                	or     %edx,%eax
  104b0b:	89 c3                	mov    %eax,%ebx
  104b0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b10:	d1 e8                	shr    %eax
  104b12:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104b15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104b18:	d1 ea                	shr    %edx
  104b1a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104b1d:	c1 ea 02             	shr    $0x2,%edx
  104b20:	09 d0                	or     %edx,%eax
  104b22:	c1 e8 04             	shr    $0x4,%eax
  104b25:	09 c3                	or     %eax,%ebx
  104b27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b2a:	d1 e8                	shr    %eax
  104b2c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104b2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104b32:	d1 ea                	shr    %edx
  104b34:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104b37:	c1 ea 02             	shr    $0x2,%edx
  104b3a:	09 d0                	or     %edx,%eax
  104b3c:	89 c6                	mov    %eax,%esi
  104b3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b41:	d1 e8                	shr    %eax
  104b43:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104b46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104b49:	d1 ea                	shr    %edx
  104b4b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104b4e:	c1 ea 02             	shr    $0x2,%edx
  104b51:	09 d0                	or     %edx,%eax
  104b53:	c1 e8 04             	shr    $0x4,%eax
  104b56:	09 f0                	or     %esi,%eax
  104b58:	c1 e8 08             	shr    $0x8,%eax
  104b5b:	09 d8                	or     %ebx,%eax
  104b5d:	c1 e8 10             	shr    $0x10,%eax
  104b60:	09 c8                	or     %ecx,%eax
  104b62:	d1 e8                	shr    %eax
  104b64:	23 45 e4             	and    -0x1c(%ebp),%eax
  104b67:	89 45 80             	mov    %eax,-0x80(%ebp)
  104b6a:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  104b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b73:	d1 e8                	shr    %eax
  104b75:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104b78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104b7b:	d1 ea                	shr    %edx
  104b7d:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104b80:	c1 ea 02             	shr    $0x2,%edx
  104b83:	09 d0                	or     %edx,%eax
  104b85:	89 c1                	mov    %eax,%ecx
  104b87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b8a:	d1 e8                	shr    %eax
  104b8c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104b8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104b92:	d1 ea                	shr    %edx
  104b94:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104b97:	c1 ea 02             	shr    $0x2,%edx
  104b9a:	09 d0                	or     %edx,%eax
  104b9c:	c1 e8 04             	shr    $0x4,%eax
  104b9f:	09 c1                	or     %eax,%ecx
  104ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ba4:	d1 e8                	shr    %eax
  104ba6:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104ba9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104bac:	d1 ea                	shr    %edx
  104bae:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104bb1:	c1 ea 02             	shr    $0x2,%edx
  104bb4:	09 d0                	or     %edx,%eax
  104bb6:	89 c3                	mov    %eax,%ebx
  104bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bbb:	d1 e8                	shr    %eax
  104bbd:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104bc0:	89 c2                	mov    %eax,%edx
  104bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bc5:	d1 e8                	shr    %eax
  104bc7:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104bca:	c1 e8 02             	shr    $0x2,%eax
  104bcd:	09 d0                	or     %edx,%eax
  104bcf:	c1 e8 04             	shr    $0x4,%eax
  104bd2:	09 d8                	or     %ebx,%eax
  104bd4:	c1 e8 08             	shr    $0x8,%eax
  104bd7:	89 ce                	mov    %ecx,%esi
  104bd9:	09 c6                	or     %eax,%esi
  104bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bde:	d1 e8                	shr    %eax
  104be0:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104be3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104be6:	d1 ea                	shr    %edx
  104be8:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104beb:	c1 ea 02             	shr    $0x2,%edx
  104bee:	09 d0                	or     %edx,%eax
  104bf0:	89 c1                	mov    %eax,%ecx
  104bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bf5:	d1 e8                	shr    %eax
  104bf7:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104bfa:	89 c2                	mov    %eax,%edx
  104bfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bff:	d1 e8                	shr    %eax
  104c01:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104c04:	c1 e8 02             	shr    $0x2,%eax
  104c07:	09 d0                	or     %edx,%eax
  104c09:	c1 e8 04             	shr    $0x4,%eax
  104c0c:	89 cb                	mov    %ecx,%ebx
  104c0e:	09 c3                	or     %eax,%ebx
  104c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c13:	d1 e8                	shr    %eax
  104c15:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104c18:	89 c2                	mov    %eax,%edx
  104c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c1d:	d1 e8                	shr    %eax
  104c1f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104c22:	c1 e8 02             	shr    $0x2,%eax
  104c25:	89 d1                	mov    %edx,%ecx
  104c27:	09 c1                	or     %eax,%ecx
  104c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c2c:	d1 e8                	shr    %eax
  104c2e:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104c31:	89 c2                	mov    %eax,%edx
  104c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c36:	d1 e8                	shr    %eax
  104c38:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104c3b:	c1 e8 02             	shr    $0x2,%eax
  104c3e:	09 d0                	or     %edx,%eax
  104c40:	c1 e8 04             	shr    $0x4,%eax
  104c43:	09 c8                	or     %ecx,%eax
  104c45:	c1 e8 08             	shr    $0x8,%eax
  104c48:	09 d8                	or     %ebx,%eax
  104c4a:	c1 e8 10             	shr    $0x10,%eax
  104c4d:	09 f0                	or     %esi,%eax
  104c4f:	d1 e8                	shr    %eax
  104c51:	23 45 e4             	and    -0x1c(%ebp),%eax
  104c54:	85 c0                	test   %eax,%eax
  104c56:	0f 84 ea 00 00 00    	je     104d46 <buddy_init_segment+0x3b2>
  104c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c5f:	d1 e8                	shr    %eax
  104c61:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104c64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104c67:	d1 ea                	shr    %edx
  104c69:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104c6c:	c1 ea 02             	shr    $0x2,%edx
  104c6f:	09 d0                	or     %edx,%eax
  104c71:	89 c1                	mov    %eax,%ecx
  104c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c76:	d1 e8                	shr    %eax
  104c78:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104c7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104c7e:	d1 ea                	shr    %edx
  104c80:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104c83:	c1 ea 02             	shr    $0x2,%edx
  104c86:	09 d0                	or     %edx,%eax
  104c88:	c1 e8 04             	shr    $0x4,%eax
  104c8b:	09 c1                	or     %eax,%ecx
  104c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c90:	d1 e8                	shr    %eax
  104c92:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104c95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104c98:	d1 ea                	shr    %edx
  104c9a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104c9d:	c1 ea 02             	shr    $0x2,%edx
  104ca0:	09 d0                	or     %edx,%eax
  104ca2:	89 c3                	mov    %eax,%ebx
  104ca4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ca7:	d1 e8                	shr    %eax
  104ca9:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104cac:	89 c2                	mov    %eax,%edx
  104cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cb1:	d1 e8                	shr    %eax
  104cb3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104cb6:	c1 e8 02             	shr    $0x2,%eax
  104cb9:	09 d0                	or     %edx,%eax
  104cbb:	c1 e8 04             	shr    $0x4,%eax
  104cbe:	09 d8                	or     %ebx,%eax
  104cc0:	c1 e8 08             	shr    $0x8,%eax
  104cc3:	89 ce                	mov    %ecx,%esi
  104cc5:	09 c6                	or     %eax,%esi
  104cc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cca:	d1 e8                	shr    %eax
  104ccc:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104ccf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104cd2:	d1 ea                	shr    %edx
  104cd4:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104cd7:	c1 ea 02             	shr    $0x2,%edx
  104cda:	09 d0                	or     %edx,%eax
  104cdc:	89 c1                	mov    %eax,%ecx
  104cde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ce1:	d1 e8                	shr    %eax
  104ce3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104ce6:	89 c2                	mov    %eax,%edx
  104ce8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ceb:	d1 e8                	shr    %eax
  104ced:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104cf0:	c1 e8 02             	shr    $0x2,%eax
  104cf3:	09 d0                	or     %edx,%eax
  104cf5:	c1 e8 04             	shr    $0x4,%eax
  104cf8:	89 cb                	mov    %ecx,%ebx
  104cfa:	09 c3                	or     %eax,%ebx
  104cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cff:	d1 e8                	shr    %eax
  104d01:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104d04:	89 c2                	mov    %eax,%edx
  104d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d09:	d1 e8                	shr    %eax
  104d0b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104d0e:	c1 e8 02             	shr    $0x2,%eax
  104d11:	89 d1                	mov    %edx,%ecx
  104d13:	09 c1                	or     %eax,%ecx
  104d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d18:	d1 e8                	shr    %eax
  104d1a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104d1d:	89 c2                	mov    %eax,%edx
  104d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d22:	d1 e8                	shr    %eax
  104d24:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104d27:	c1 e8 02             	shr    $0x2,%eax
  104d2a:	09 d0                	or     %edx,%eax
  104d2c:	c1 e8 04             	shr    $0x4,%eax
  104d2f:	09 c8                	or     %ecx,%eax
  104d31:	c1 e8 08             	shr    $0x8,%eax
  104d34:	09 d8                	or     %ebx,%eax
  104d36:	c1 e8 10             	shr    $0x10,%eax
  104d39:	09 f0                	or     %esi,%eax
  104d3b:	d1 e8                	shr    %eax
  104d3d:	f7 d0                	not    %eax
  104d3f:	23 45 e4             	and    -0x1c(%ebp),%eax
  104d42:	89 c6                	mov    %eax,%esi
  104d44:	eb 03                	jmp    104d49 <buddy_init_segment+0x3b5>
  104d46:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  104d49:	89 f8                	mov    %edi,%eax
  104d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  104d50:	f7 f6                	div    %esi
  104d52:	8b 55 80             	mov    -0x80(%ebp),%edx
  104d55:	0f af d0             	imul   %eax,%edx
  104d58:	89 d0                	mov    %edx,%eax
  104d5a:	c1 e0 02             	shl    $0x2,%eax
  104d5d:	01 d0                	add    %edx,%eax
  104d5f:	c1 e0 02             	shl    $0x2,%eax
  104d62:	03 45 84             	add    -0x7c(%ebp),%eax
  104d65:	89 45 d0             	mov    %eax,-0x30(%ebp)
            page->property = virtual_size;
  104d68:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104d6e:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(free_list), &(page->page_link));
  104d71:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d74:	83 c0 0c             	add    $0xc,%eax
  104d77:	c7 45 c8 78 e9 11 00 	movl   $0x11e978,-0x38(%ebp)
  104d7e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104d81:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104d84:	89 45 c0             	mov    %eax,-0x40(%ebp)
  104d87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104d8a:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104d8d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104d90:	8b 40 04             	mov    0x4(%eax),%eax
  104d93:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104d96:	89 55 b8             	mov    %edx,-0x48(%ebp)
  104d99:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104d9c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  104d9f:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104da2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104da5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104da8:	89 10                	mov    %edx,(%eax)
  104daa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104dad:	8b 10                	mov    (%eax),%edx
  104daf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104db2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104db5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104db8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104dbb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104dbe:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104dc1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104dc4:	89 10                	mov    %edx,(%eax)
            buddy_segment[BUDDY_LEFT(block)] = virtual_size;
  104dc6:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  104dcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104dce:	c1 e2 03             	shl    $0x3,%edx
  104dd1:	01 c2                	add    %eax,%edx
  104dd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104dd6:	89 02                	mov    %eax,(%edx)
            // Switch ro right
            alloc_size -= virtual_size;
  104dd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ddb:	29 45 e0             	sub    %eax,-0x20(%ebp)
            buddy_segment[BUDDY_RIGHT(block)] = alloc_size;
  104dde:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  104de3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104de6:	c1 e2 03             	shl    $0x3,%edx
  104de9:	83 c2 04             	add    $0x4,%edx
  104dec:	01 c2                	add    %eax,%edx
  104dee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104df1:	89 02                	mov    %eax,(%edx)
            block = BUDDY_RIGHT(block);
  104df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104df6:	01 c0                	add    %eax,%eax
  104df8:	83 c0 01             	add    $0x1,%eax
  104dfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104dfe:	eb 2b                	jmp    104e2b <buddy_init_segment+0x497>
        } else {
            // Switch to left
            buddy_segment[BUDDY_LEFT(block)] = alloc_size;
  104e00:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  104e05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104e08:	c1 e2 03             	shl    $0x3,%edx
  104e0b:	01 c2                	add    %eax,%edx
  104e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104e10:	89 02                	mov    %eax,(%edx)
            buddy_segment[BUDDY_RIGHT(block)] = 0;
  104e12:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  104e17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104e1a:	c1 e2 03             	shl    $0x3,%edx
  104e1d:	83 c2 04             	add    $0x4,%edx
  104e20:	01 d0                	add    %edx,%eax
  104e22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            block = BUDDY_LEFT(block);
  104e28:	d1 65 e4             	shll   -0x1c(%ebp)
    while (alloc_size > 0 && alloc_size < virtual_size) {
  104e2b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104e2f:	74 0c                	je     104e3d <buddy_init_segment+0x4a9>
  104e31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104e34:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104e37:	0f 82 3b fc ff ff    	jb     104a78 <buddy_init_segment+0xe4>
        }
    }
    if (alloc_size > 0) {
  104e3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104e41:	0f 84 3f 03 00 00    	je     105186 <buddy_init_segment+0x7f2>
        struct Page *page = &buddy_alloc[BUDDY_BEGIN(block)];
  104e47:	a1 64 e9 11 00       	mov    0x11e964,%eax
  104e4c:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e52:	d1 e8                	shr    %eax
  104e54:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104e57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104e5a:	d1 ea                	shr    %edx
  104e5c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104e5f:	c1 ea 02             	shr    $0x2,%edx
  104e62:	09 d0                	or     %edx,%eax
  104e64:	89 c1                	mov    %eax,%ecx
  104e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e69:	d1 e8                	shr    %eax
  104e6b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104e6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104e71:	d1 ea                	shr    %edx
  104e73:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104e76:	c1 ea 02             	shr    $0x2,%edx
  104e79:	09 d0                	or     %edx,%eax
  104e7b:	c1 e8 04             	shr    $0x4,%eax
  104e7e:	09 c1                	or     %eax,%ecx
  104e80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e83:	d1 e8                	shr    %eax
  104e85:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104e88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104e8b:	d1 ea                	shr    %edx
  104e8d:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104e90:	c1 ea 02             	shr    $0x2,%edx
  104e93:	09 d0                	or     %edx,%eax
  104e95:	89 c3                	mov    %eax,%ebx
  104e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e9a:	d1 e8                	shr    %eax
  104e9c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104e9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104ea2:	d1 ea                	shr    %edx
  104ea4:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104ea7:	c1 ea 02             	shr    $0x2,%edx
  104eaa:	09 d0                	or     %edx,%eax
  104eac:	c1 e8 04             	shr    $0x4,%eax
  104eaf:	09 d8                	or     %ebx,%eax
  104eb1:	c1 e8 08             	shr    $0x8,%eax
  104eb4:	09 c1                	or     %eax,%ecx
  104eb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104eb9:	d1 e8                	shr    %eax
  104ebb:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104ebe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104ec1:	d1 ea                	shr    %edx
  104ec3:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104ec6:	c1 ea 02             	shr    $0x2,%edx
  104ec9:	09 d0                	or     %edx,%eax
  104ecb:	89 c3                	mov    %eax,%ebx
  104ecd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ed0:	d1 e8                	shr    %eax
  104ed2:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104ed5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104ed8:	d1 ea                	shr    %edx
  104eda:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104edd:	c1 ea 02             	shr    $0x2,%edx
  104ee0:	09 d0                	or     %edx,%eax
  104ee2:	c1 e8 04             	shr    $0x4,%eax
  104ee5:	09 c3                	or     %eax,%ebx
  104ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104eea:	d1 e8                	shr    %eax
  104eec:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104eef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104ef2:	d1 ea                	shr    %edx
  104ef4:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104ef7:	c1 ea 02             	shr    $0x2,%edx
  104efa:	09 d0                	or     %edx,%eax
  104efc:	89 c6                	mov    %eax,%esi
  104efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f01:	d1 e8                	shr    %eax
  104f03:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104f06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104f09:	d1 ea                	shr    %edx
  104f0b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104f0e:	c1 ea 02             	shr    $0x2,%edx
  104f11:	09 d0                	or     %edx,%eax
  104f13:	c1 e8 04             	shr    $0x4,%eax
  104f16:	09 f0                	or     %esi,%eax
  104f18:	c1 e8 08             	shr    $0x8,%eax
  104f1b:	09 d8                	or     %ebx,%eax
  104f1d:	c1 e8 10             	shr    $0x10,%eax
  104f20:	09 c8                	or     %ecx,%eax
  104f22:	d1 e8                	shr    %eax
  104f24:	23 45 e4             	and    -0x1c(%ebp),%eax
  104f27:	89 45 80             	mov    %eax,-0x80(%ebp)
  104f2a:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  104f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f33:	d1 e8                	shr    %eax
  104f35:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104f38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104f3b:	d1 ea                	shr    %edx
  104f3d:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104f40:	c1 ea 02             	shr    $0x2,%edx
  104f43:	09 d0                	or     %edx,%eax
  104f45:	89 c1                	mov    %eax,%ecx
  104f47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f4a:	d1 e8                	shr    %eax
  104f4c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104f4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104f52:	d1 ea                	shr    %edx
  104f54:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104f57:	c1 ea 02             	shr    $0x2,%edx
  104f5a:	09 d0                	or     %edx,%eax
  104f5c:	c1 e8 04             	shr    $0x4,%eax
  104f5f:	09 c1                	or     %eax,%ecx
  104f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f64:	d1 e8                	shr    %eax
  104f66:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104f69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104f6c:	d1 ea                	shr    %edx
  104f6e:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104f71:	c1 ea 02             	shr    $0x2,%edx
  104f74:	09 d0                	or     %edx,%eax
  104f76:	89 c3                	mov    %eax,%ebx
  104f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f7b:	d1 e8                	shr    %eax
  104f7d:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104f80:	89 c2                	mov    %eax,%edx
  104f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f85:	d1 e8                	shr    %eax
  104f87:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104f8a:	c1 e8 02             	shr    $0x2,%eax
  104f8d:	09 d0                	or     %edx,%eax
  104f8f:	c1 e8 04             	shr    $0x4,%eax
  104f92:	09 d8                	or     %ebx,%eax
  104f94:	c1 e8 08             	shr    $0x8,%eax
  104f97:	89 ce                	mov    %ecx,%esi
  104f99:	09 c6                	or     %eax,%esi
  104f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f9e:	d1 e8                	shr    %eax
  104fa0:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104fa3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104fa6:	d1 ea                	shr    %edx
  104fa8:	0b 55 e4             	or     -0x1c(%ebp),%edx
  104fab:	c1 ea 02             	shr    $0x2,%edx
  104fae:	09 d0                	or     %edx,%eax
  104fb0:	89 c1                	mov    %eax,%ecx
  104fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fb5:	d1 e8                	shr    %eax
  104fb7:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104fba:	89 c2                	mov    %eax,%edx
  104fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fbf:	d1 e8                	shr    %eax
  104fc1:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104fc4:	c1 e8 02             	shr    $0x2,%eax
  104fc7:	09 d0                	or     %edx,%eax
  104fc9:	c1 e8 04             	shr    $0x4,%eax
  104fcc:	89 cb                	mov    %ecx,%ebx
  104fce:	09 c3                	or     %eax,%ebx
  104fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fd3:	d1 e8                	shr    %eax
  104fd5:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104fd8:	89 c2                	mov    %eax,%edx
  104fda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fdd:	d1 e8                	shr    %eax
  104fdf:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104fe2:	c1 e8 02             	shr    $0x2,%eax
  104fe5:	89 d1                	mov    %edx,%ecx
  104fe7:	09 c1                	or     %eax,%ecx
  104fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fec:	d1 e8                	shr    %eax
  104fee:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104ff1:	89 c2                	mov    %eax,%edx
  104ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ff6:	d1 e8                	shr    %eax
  104ff8:	0b 45 e4             	or     -0x1c(%ebp),%eax
  104ffb:	c1 e8 02             	shr    $0x2,%eax
  104ffe:	09 d0                	or     %edx,%eax
  105000:	c1 e8 04             	shr    $0x4,%eax
  105003:	09 c8                	or     %ecx,%eax
  105005:	c1 e8 08             	shr    $0x8,%eax
  105008:	09 d8                	or     %ebx,%eax
  10500a:	c1 e8 10             	shr    $0x10,%eax
  10500d:	09 f0                	or     %esi,%eax
  10500f:	d1 e8                	shr    %eax
  105011:	23 45 e4             	and    -0x1c(%ebp),%eax
  105014:	85 c0                	test   %eax,%eax
  105016:	0f 84 ea 00 00 00    	je     105106 <buddy_init_segment+0x772>
  10501c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10501f:	d1 e8                	shr    %eax
  105021:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105024:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105027:	d1 ea                	shr    %edx
  105029:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10502c:	c1 ea 02             	shr    $0x2,%edx
  10502f:	09 d0                	or     %edx,%eax
  105031:	89 c1                	mov    %eax,%ecx
  105033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105036:	d1 e8                	shr    %eax
  105038:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10503b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10503e:	d1 ea                	shr    %edx
  105040:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105043:	c1 ea 02             	shr    $0x2,%edx
  105046:	09 d0                	or     %edx,%eax
  105048:	c1 e8 04             	shr    $0x4,%eax
  10504b:	09 c1                	or     %eax,%ecx
  10504d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105050:	d1 e8                	shr    %eax
  105052:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105055:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105058:	d1 ea                	shr    %edx
  10505a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10505d:	c1 ea 02             	shr    $0x2,%edx
  105060:	09 d0                	or     %edx,%eax
  105062:	89 c3                	mov    %eax,%ebx
  105064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105067:	d1 e8                	shr    %eax
  105069:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10506c:	89 c2                	mov    %eax,%edx
  10506e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105071:	d1 e8                	shr    %eax
  105073:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105076:	c1 e8 02             	shr    $0x2,%eax
  105079:	09 d0                	or     %edx,%eax
  10507b:	c1 e8 04             	shr    $0x4,%eax
  10507e:	09 d8                	or     %ebx,%eax
  105080:	c1 e8 08             	shr    $0x8,%eax
  105083:	89 ce                	mov    %ecx,%esi
  105085:	09 c6                	or     %eax,%esi
  105087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10508a:	d1 e8                	shr    %eax
  10508c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10508f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105092:	d1 ea                	shr    %edx
  105094:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105097:	c1 ea 02             	shr    $0x2,%edx
  10509a:	09 d0                	or     %edx,%eax
  10509c:	89 c1                	mov    %eax,%ecx
  10509e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050a1:	d1 e8                	shr    %eax
  1050a3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1050a6:	89 c2                	mov    %eax,%edx
  1050a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050ab:	d1 e8                	shr    %eax
  1050ad:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1050b0:	c1 e8 02             	shr    $0x2,%eax
  1050b3:	09 d0                	or     %edx,%eax
  1050b5:	c1 e8 04             	shr    $0x4,%eax
  1050b8:	89 cb                	mov    %ecx,%ebx
  1050ba:	09 c3                	or     %eax,%ebx
  1050bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050bf:	d1 e8                	shr    %eax
  1050c1:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1050c4:	89 c2                	mov    %eax,%edx
  1050c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050c9:	d1 e8                	shr    %eax
  1050cb:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1050ce:	c1 e8 02             	shr    $0x2,%eax
  1050d1:	89 d1                	mov    %edx,%ecx
  1050d3:	09 c1                	or     %eax,%ecx
  1050d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050d8:	d1 e8                	shr    %eax
  1050da:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1050dd:	89 c2                	mov    %eax,%edx
  1050df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050e2:	d1 e8                	shr    %eax
  1050e4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1050e7:	c1 e8 02             	shr    $0x2,%eax
  1050ea:	09 d0                	or     %edx,%eax
  1050ec:	c1 e8 04             	shr    $0x4,%eax
  1050ef:	09 c8                	or     %ecx,%eax
  1050f1:	c1 e8 08             	shr    $0x8,%eax
  1050f4:	09 d8                	or     %ebx,%eax
  1050f6:	c1 e8 10             	shr    $0x10,%eax
  1050f9:	09 f0                	or     %esi,%eax
  1050fb:	d1 e8                	shr    %eax
  1050fd:	f7 d0                	not    %eax
  1050ff:	23 45 e4             	and    -0x1c(%ebp),%eax
  105102:	89 c6                	mov    %eax,%esi
  105104:	eb 03                	jmp    105109 <buddy_init_segment+0x775>
  105106:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  105109:	89 f8                	mov    %edi,%eax
  10510b:	ba 00 00 00 00       	mov    $0x0,%edx
  105110:	f7 f6                	div    %esi
  105112:	8b 55 80             	mov    -0x80(%ebp),%edx
  105115:	0f af d0             	imul   %eax,%edx
  105118:	89 d0                	mov    %edx,%eax
  10511a:	c1 e0 02             	shl    $0x2,%eax
  10511d:	01 d0                	add    %edx,%eax
  10511f:	c1 e0 02             	shl    $0x2,%eax
  105122:	03 45 84             	add    -0x7c(%ebp),%eax
  105125:	89 45 cc             	mov    %eax,-0x34(%ebp)
        page->property = alloc_size;
  105128:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10512b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10512e:	89 50 08             	mov    %edx,0x8(%eax)
        list_add(&(free_list), &(page->page_link));
  105131:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105134:	83 c0 0c             	add    $0xc,%eax
  105137:	c7 45 ac 78 e9 11 00 	movl   $0x11e978,-0x54(%ebp)
  10513e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  105141:	8b 45 ac             	mov    -0x54(%ebp),%eax
  105144:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  105147:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10514a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    __list_add(elm, listelm, listelm->next);
  10514d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105150:	8b 40 04             	mov    0x4(%eax),%eax
  105153:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105156:	89 55 9c             	mov    %edx,-0x64(%ebp)
  105159:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10515c:	89 55 98             	mov    %edx,-0x68(%ebp)
  10515f:	89 45 94             	mov    %eax,-0x6c(%ebp)
    prev->next = next->prev = elm;
  105162:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105165:	8b 55 9c             	mov    -0x64(%ebp),%edx
  105168:	89 10                	mov    %edx,(%eax)
  10516a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10516d:	8b 10                	mov    (%eax),%edx
  10516f:	8b 45 98             	mov    -0x68(%ebp),%eax
  105172:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105175:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105178:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10517b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10517e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105181:	8b 55 98             	mov    -0x68(%ebp),%edx
  105184:	89 10                	mov    %edx,(%eax)
    }
}
  105186:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  10518c:	5b                   	pop    %ebx
  10518d:	5e                   	pop    %esi
  10518e:	5f                   	pop    %edi
  10518f:	5d                   	pop    %ebp
  105190:	c3                   	ret    

00105191 <buddy_init>:

static void
buddy_init(void) {
  105191:	55                   	push   %ebp
  105192:	89 e5                	mov    %esp,%ebp
  105194:	83 ec 10             	sub    $0x10,%esp
  105197:	c7 45 fc 78 e9 11 00 	movl   $0x11e978,-0x4(%ebp)
    elm->prev = elm->next = elm;
  10519e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1051a4:	89 50 04             	mov    %edx,0x4(%eax)
  1051a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051aa:	8b 50 04             	mov    0x4(%eax),%edx
  1051ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051b0:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1051b2:	c7 05 80 e9 11 00 00 	movl   $0x0,0x11e980
  1051b9:	00 00 00 
}
  1051bc:	c9                   	leave  
  1051bd:	c3                   	ret    

001051be <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
  1051be:	55                   	push   %ebp
  1051bf:	89 e5                	mov    %esp,%ebp
  1051c1:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0);
  1051c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1051c8:	75 24                	jne    1051ee <buddy_init_memmap+0x30>
  1051ca:	c7 44 24 0c df ab 10 	movl   $0x10abdf,0xc(%esp)
  1051d1:	00 
  1051d2:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  1051d9:	00 
  1051da:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
  1051e1:	00 
  1051e2:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  1051e9:	e8 fa b1 ff ff       	call   1003e8 <__panic>
    // Init pages
    struct Page *p;
    for (p = base; p < base + n; p++) {
  1051ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1051f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1051f4:	eb 6a                	jmp    105260 <buddy_init_memmap+0xa2>
        assert(PageReserved(p));
  1051f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051f9:	83 c0 04             	add    $0x4,%eax
  1051fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  105203:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105206:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105209:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10520c:	0f a3 10             	bt     %edx,(%eax)
  10520f:	19 c0                	sbb    %eax,%eax
  105211:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  105214:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105218:	0f 95 c0             	setne  %al
  10521b:	0f b6 c0             	movzbl %al,%eax
  10521e:	85 c0                	test   %eax,%eax
  105220:	75 24                	jne    105246 <buddy_init_memmap+0x88>
  105222:	c7 44 24 0c e5 ab 10 	movl   $0x10abe5,0xc(%esp)
  105229:	00 
  10522a:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  105231:	00 
  105232:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  105239:	00 
  10523a:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  105241:	e8 a2 b1 ff ff       	call   1003e8 <__panic>
        p->flags = p->property = 0;
  105246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105249:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  105250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105253:	8b 50 08             	mov    0x8(%eax),%edx
  105256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105259:	89 50 04             	mov    %edx,0x4(%eax)
    for (p = base; p < base + n; p++) {
  10525c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  105260:	8b 55 0c             	mov    0xc(%ebp),%edx
  105263:	89 d0                	mov    %edx,%eax
  105265:	c1 e0 02             	shl    $0x2,%eax
  105268:	01 d0                	add    %edx,%eax
  10526a:	c1 e0 02             	shl    $0x2,%eax
  10526d:	89 c2                	mov    %eax,%edx
  10526f:	8b 45 08             	mov    0x8(%ebp),%eax
  105272:	01 d0                	add    %edx,%eax
  105274:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  105277:	0f 87 79 ff ff ff    	ja     1051f6 <buddy_init_memmap+0x38>
    }
    // Init size
    buddy_init_size(n);
  10527d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105280:	89 04 24             	mov    %eax,(%esp)
  105283:	e8 c2 f1 ff ff       	call   10444a <buddy_init_size>
    // Init segment
    buddy_init_segment(base);
  105288:	8b 45 08             	mov    0x8(%ebp),%eax
  10528b:	89 04 24             	mov    %eax,(%esp)
  10528e:	e8 01 f7 ff ff       	call   104994 <buddy_init_segment>
}
  105293:	c9                   	leave  
  105294:	c3                   	ret    

00105295 <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n) {
  105295:	55                   	push   %ebp
  105296:	89 e5                	mov    %esp,%ebp
  105298:	57                   	push   %edi
  105299:	56                   	push   %esi
  10529a:	53                   	push   %ebx
  10529b:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    assert(n > 0);
  1052a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1052a5:	75 24                	jne    1052cb <buddy_alloc_pages+0x36>
  1052a7:	c7 44 24 0c df ab 10 	movl   $0x10abdf,0xc(%esp)
  1052ae:	00 
  1052af:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  1052b6:	00 
  1052b7:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  1052be:	00 
  1052bf:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  1052c6:	e8 1d b1 ff ff       	call   1003e8 <__panic>
    struct Page *page;
    size_t block = BUDDY_ROOT;
  1052cb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    size_t length = UINT32_ROUND_UP(n);
  1052d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1052d5:	d1 e8                	shr    %eax
  1052d7:	0b 45 08             	or     0x8(%ebp),%eax
  1052da:	8b 55 08             	mov    0x8(%ebp),%edx
  1052dd:	d1 ea                	shr    %edx
  1052df:	0b 55 08             	or     0x8(%ebp),%edx
  1052e2:	c1 ea 02             	shr    $0x2,%edx
  1052e5:	09 d0                	or     %edx,%eax
  1052e7:	89 c1                	mov    %eax,%ecx
  1052e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1052ec:	d1 e8                	shr    %eax
  1052ee:	0b 45 08             	or     0x8(%ebp),%eax
  1052f1:	8b 55 08             	mov    0x8(%ebp),%edx
  1052f4:	d1 ea                	shr    %edx
  1052f6:	0b 55 08             	or     0x8(%ebp),%edx
  1052f9:	c1 ea 02             	shr    $0x2,%edx
  1052fc:	09 d0                	or     %edx,%eax
  1052fe:	c1 e8 04             	shr    $0x4,%eax
  105301:	09 c1                	or     %eax,%ecx
  105303:	8b 45 08             	mov    0x8(%ebp),%eax
  105306:	d1 e8                	shr    %eax
  105308:	0b 45 08             	or     0x8(%ebp),%eax
  10530b:	8b 55 08             	mov    0x8(%ebp),%edx
  10530e:	d1 ea                	shr    %edx
  105310:	0b 55 08             	or     0x8(%ebp),%edx
  105313:	c1 ea 02             	shr    $0x2,%edx
  105316:	09 d0                	or     %edx,%eax
  105318:	89 c3                	mov    %eax,%ebx
  10531a:	8b 45 08             	mov    0x8(%ebp),%eax
  10531d:	d1 e8                	shr    %eax
  10531f:	0b 45 08             	or     0x8(%ebp),%eax
  105322:	8b 55 08             	mov    0x8(%ebp),%edx
  105325:	d1 ea                	shr    %edx
  105327:	0b 55 08             	or     0x8(%ebp),%edx
  10532a:	c1 ea 02             	shr    $0x2,%edx
  10532d:	09 d0                	or     %edx,%eax
  10532f:	c1 e8 04             	shr    $0x4,%eax
  105332:	09 d8                	or     %ebx,%eax
  105334:	c1 e8 08             	shr    $0x8,%eax
  105337:	09 c1                	or     %eax,%ecx
  105339:	8b 45 08             	mov    0x8(%ebp),%eax
  10533c:	d1 e8                	shr    %eax
  10533e:	0b 45 08             	or     0x8(%ebp),%eax
  105341:	8b 55 08             	mov    0x8(%ebp),%edx
  105344:	d1 ea                	shr    %edx
  105346:	0b 55 08             	or     0x8(%ebp),%edx
  105349:	c1 ea 02             	shr    $0x2,%edx
  10534c:	09 d0                	or     %edx,%eax
  10534e:	89 c3                	mov    %eax,%ebx
  105350:	8b 45 08             	mov    0x8(%ebp),%eax
  105353:	d1 e8                	shr    %eax
  105355:	0b 45 08             	or     0x8(%ebp),%eax
  105358:	8b 55 08             	mov    0x8(%ebp),%edx
  10535b:	d1 ea                	shr    %edx
  10535d:	0b 55 08             	or     0x8(%ebp),%edx
  105360:	c1 ea 02             	shr    $0x2,%edx
  105363:	09 d0                	or     %edx,%eax
  105365:	c1 e8 04             	shr    $0x4,%eax
  105368:	09 c3                	or     %eax,%ebx
  10536a:	8b 45 08             	mov    0x8(%ebp),%eax
  10536d:	d1 e8                	shr    %eax
  10536f:	0b 45 08             	or     0x8(%ebp),%eax
  105372:	8b 55 08             	mov    0x8(%ebp),%edx
  105375:	d1 ea                	shr    %edx
  105377:	0b 55 08             	or     0x8(%ebp),%edx
  10537a:	c1 ea 02             	shr    $0x2,%edx
  10537d:	09 d0                	or     %edx,%eax
  10537f:	89 c6                	mov    %eax,%esi
  105381:	8b 45 08             	mov    0x8(%ebp),%eax
  105384:	d1 e8                	shr    %eax
  105386:	0b 45 08             	or     0x8(%ebp),%eax
  105389:	8b 55 08             	mov    0x8(%ebp),%edx
  10538c:	d1 ea                	shr    %edx
  10538e:	0b 55 08             	or     0x8(%ebp),%edx
  105391:	c1 ea 02             	shr    $0x2,%edx
  105394:	09 d0                	or     %edx,%eax
  105396:	c1 e8 04             	shr    $0x4,%eax
  105399:	09 f0                	or     %esi,%eax
  10539b:	c1 e8 08             	shr    $0x8,%eax
  10539e:	09 d8                	or     %ebx,%eax
  1053a0:	c1 e8 10             	shr    $0x10,%eax
  1053a3:	09 c8                	or     %ecx,%eax
  1053a5:	d1 e8                	shr    %eax
  1053a7:	23 45 08             	and    0x8(%ebp),%eax
  1053aa:	85 c0                	test   %eax,%eax
  1053ac:	0f 84 de 00 00 00    	je     105490 <buddy_alloc_pages+0x1fb>
  1053b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1053b5:	d1 e8                	shr    %eax
  1053b7:	0b 45 08             	or     0x8(%ebp),%eax
  1053ba:	8b 55 08             	mov    0x8(%ebp),%edx
  1053bd:	d1 ea                	shr    %edx
  1053bf:	0b 55 08             	or     0x8(%ebp),%edx
  1053c2:	c1 ea 02             	shr    $0x2,%edx
  1053c5:	09 d0                	or     %edx,%eax
  1053c7:	89 c1                	mov    %eax,%ecx
  1053c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1053cc:	d1 e8                	shr    %eax
  1053ce:	0b 45 08             	or     0x8(%ebp),%eax
  1053d1:	8b 55 08             	mov    0x8(%ebp),%edx
  1053d4:	d1 ea                	shr    %edx
  1053d6:	0b 55 08             	or     0x8(%ebp),%edx
  1053d9:	c1 ea 02             	shr    $0x2,%edx
  1053dc:	09 d0                	or     %edx,%eax
  1053de:	c1 e8 04             	shr    $0x4,%eax
  1053e1:	09 c1                	or     %eax,%ecx
  1053e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1053e6:	d1 e8                	shr    %eax
  1053e8:	0b 45 08             	or     0x8(%ebp),%eax
  1053eb:	8b 55 08             	mov    0x8(%ebp),%edx
  1053ee:	d1 ea                	shr    %edx
  1053f0:	0b 55 08             	or     0x8(%ebp),%edx
  1053f3:	c1 ea 02             	shr    $0x2,%edx
  1053f6:	09 d0                	or     %edx,%eax
  1053f8:	89 c3                	mov    %eax,%ebx
  1053fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1053fd:	d1 e8                	shr    %eax
  1053ff:	0b 45 08             	or     0x8(%ebp),%eax
  105402:	8b 55 08             	mov    0x8(%ebp),%edx
  105405:	d1 ea                	shr    %edx
  105407:	0b 55 08             	or     0x8(%ebp),%edx
  10540a:	c1 ea 02             	shr    $0x2,%edx
  10540d:	09 d0                	or     %edx,%eax
  10540f:	c1 e8 04             	shr    $0x4,%eax
  105412:	09 d8                	or     %ebx,%eax
  105414:	c1 e8 08             	shr    $0x8,%eax
  105417:	09 c1                	or     %eax,%ecx
  105419:	8b 45 08             	mov    0x8(%ebp),%eax
  10541c:	d1 e8                	shr    %eax
  10541e:	0b 45 08             	or     0x8(%ebp),%eax
  105421:	8b 55 08             	mov    0x8(%ebp),%edx
  105424:	d1 ea                	shr    %edx
  105426:	0b 55 08             	or     0x8(%ebp),%edx
  105429:	c1 ea 02             	shr    $0x2,%edx
  10542c:	09 d0                	or     %edx,%eax
  10542e:	89 c3                	mov    %eax,%ebx
  105430:	8b 45 08             	mov    0x8(%ebp),%eax
  105433:	d1 e8                	shr    %eax
  105435:	0b 45 08             	or     0x8(%ebp),%eax
  105438:	8b 55 08             	mov    0x8(%ebp),%edx
  10543b:	d1 ea                	shr    %edx
  10543d:	0b 55 08             	or     0x8(%ebp),%edx
  105440:	c1 ea 02             	shr    $0x2,%edx
  105443:	09 d0                	or     %edx,%eax
  105445:	c1 e8 04             	shr    $0x4,%eax
  105448:	09 c3                	or     %eax,%ebx
  10544a:	8b 45 08             	mov    0x8(%ebp),%eax
  10544d:	d1 e8                	shr    %eax
  10544f:	0b 45 08             	or     0x8(%ebp),%eax
  105452:	8b 55 08             	mov    0x8(%ebp),%edx
  105455:	d1 ea                	shr    %edx
  105457:	0b 55 08             	or     0x8(%ebp),%edx
  10545a:	c1 ea 02             	shr    $0x2,%edx
  10545d:	09 d0                	or     %edx,%eax
  10545f:	89 c6                	mov    %eax,%esi
  105461:	8b 45 08             	mov    0x8(%ebp),%eax
  105464:	d1 e8                	shr    %eax
  105466:	0b 45 08             	or     0x8(%ebp),%eax
  105469:	8b 55 08             	mov    0x8(%ebp),%edx
  10546c:	d1 ea                	shr    %edx
  10546e:	0b 55 08             	or     0x8(%ebp),%edx
  105471:	c1 ea 02             	shr    $0x2,%edx
  105474:	09 d0                	or     %edx,%eax
  105476:	c1 e8 04             	shr    $0x4,%eax
  105479:	09 f0                	or     %esi,%eax
  10547b:	c1 e8 08             	shr    $0x8,%eax
  10547e:	09 d8                	or     %ebx,%eax
  105480:	c1 e8 10             	shr    $0x10,%eax
  105483:	09 c8                	or     %ecx,%eax
  105485:	d1 e8                	shr    %eax
  105487:	f7 d0                	not    %eax
  105489:	23 45 08             	and    0x8(%ebp),%eax
  10548c:	01 c0                	add    %eax,%eax
  10548e:	eb 03                	jmp    105493 <buddy_alloc_pages+0x1fe>
  105490:	8b 45 08             	mov    0x8(%ebp),%eax
  105493:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // Find block
    while (length <= buddy_segment[block] && length < BUDDY_LENGTH(block)) {
  105496:	e9 ee 09 00 00       	jmp    105e89 <buddy_alloc_pages+0xbf4>
        size_t left = BUDDY_LEFT(block);
  10549b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10549e:	01 c0                	add    %eax,%eax
  1054a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        size_t right = BUDDY_RIGHT(block);
  1054a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054a6:	01 c0                	add    %eax,%eax
  1054a8:	83 c0 01             	add    $0x1,%eax
  1054ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
        if (BUDDY_EMPTY(block)) {                   // Split
  1054ae:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  1054b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1054b6:	c1 e2 02             	shl    $0x2,%edx
  1054b9:	01 d0                	add    %edx,%eax
  1054bb:	8b 00                	mov    (%eax),%eax
  1054bd:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  1054c3:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  1054c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054cc:	d1 e8                	shr    %eax
  1054ce:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1054d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1054d4:	d1 ea                	shr    %edx
  1054d6:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1054d9:	c1 ea 02             	shr    $0x2,%edx
  1054dc:	09 d0                	or     %edx,%eax
  1054de:	89 c1                	mov    %eax,%ecx
  1054e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054e3:	d1 e8                	shr    %eax
  1054e5:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1054e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1054eb:	d1 ea                	shr    %edx
  1054ed:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1054f0:	c1 ea 02             	shr    $0x2,%edx
  1054f3:	09 d0                	or     %edx,%eax
  1054f5:	c1 e8 04             	shr    $0x4,%eax
  1054f8:	09 c1                	or     %eax,%ecx
  1054fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054fd:	d1 e8                	shr    %eax
  1054ff:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105502:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105505:	d1 ea                	shr    %edx
  105507:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10550a:	c1 ea 02             	shr    $0x2,%edx
  10550d:	09 d0                	or     %edx,%eax
  10550f:	89 c3                	mov    %eax,%ebx
  105511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105514:	d1 e8                	shr    %eax
  105516:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105519:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10551c:	d1 ea                	shr    %edx
  10551e:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105521:	c1 ea 02             	shr    $0x2,%edx
  105524:	09 d0                	or     %edx,%eax
  105526:	c1 e8 04             	shr    $0x4,%eax
  105529:	09 d8                	or     %ebx,%eax
  10552b:	c1 e8 08             	shr    $0x8,%eax
  10552e:	89 cb                	mov    %ecx,%ebx
  105530:	09 c3                	or     %eax,%ebx
  105532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105535:	d1 e8                	shr    %eax
  105537:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10553a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10553d:	d1 ea                	shr    %edx
  10553f:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105542:	c1 ea 02             	shr    $0x2,%edx
  105545:	09 d0                	or     %edx,%eax
  105547:	89 c1                	mov    %eax,%ecx
  105549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10554c:	d1 e8                	shr    %eax
  10554e:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105551:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105554:	d1 ea                	shr    %edx
  105556:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105559:	c1 ea 02             	shr    $0x2,%edx
  10555c:	09 d0                	or     %edx,%eax
  10555e:	c1 e8 04             	shr    $0x4,%eax
  105561:	09 c1                	or     %eax,%ecx
  105563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105566:	d1 e8                	shr    %eax
  105568:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10556b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10556e:	d1 ea                	shr    %edx
  105570:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105573:	c1 ea 02             	shr    $0x2,%edx
  105576:	09 d0                	or     %edx,%eax
  105578:	89 c6                	mov    %eax,%esi
  10557a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10557d:	d1 e8                	shr    %eax
  10557f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105582:	89 c2                	mov    %eax,%edx
  105584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105587:	d1 e8                	shr    %eax
  105589:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10558c:	c1 e8 02             	shr    $0x2,%eax
  10558f:	09 d0                	or     %edx,%eax
  105591:	c1 e8 04             	shr    $0x4,%eax
  105594:	09 f0                	or     %esi,%eax
  105596:	c1 e8 08             	shr    $0x8,%eax
  105599:	09 c8                	or     %ecx,%eax
  10559b:	c1 e8 10             	shr    $0x10,%eax
  10559e:	09 d8                	or     %ebx,%eax
  1055a0:	d1 e8                	shr    %eax
  1055a2:	23 45 e4             	and    -0x1c(%ebp),%eax
  1055a5:	85 c0                	test   %eax,%eax
  1055a7:	0f 84 e2 00 00 00    	je     10568f <buddy_alloc_pages+0x3fa>
  1055ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055b0:	d1 e8                	shr    %eax
  1055b2:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1055b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1055b8:	d1 ea                	shr    %edx
  1055ba:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1055bd:	c1 ea 02             	shr    $0x2,%edx
  1055c0:	09 d0                	or     %edx,%eax
  1055c2:	89 c1                	mov    %eax,%ecx
  1055c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055c7:	d1 e8                	shr    %eax
  1055c9:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1055cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1055cf:	d1 ea                	shr    %edx
  1055d1:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1055d4:	c1 ea 02             	shr    $0x2,%edx
  1055d7:	09 d0                	or     %edx,%eax
  1055d9:	c1 e8 04             	shr    $0x4,%eax
  1055dc:	09 c1                	or     %eax,%ecx
  1055de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055e1:	d1 e8                	shr    %eax
  1055e3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1055e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1055e9:	d1 ea                	shr    %edx
  1055eb:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1055ee:	c1 ea 02             	shr    $0x2,%edx
  1055f1:	09 d0                	or     %edx,%eax
  1055f3:	89 c3                	mov    %eax,%ebx
  1055f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055f8:	d1 e8                	shr    %eax
  1055fa:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1055fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105600:	d1 ea                	shr    %edx
  105602:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105605:	c1 ea 02             	shr    $0x2,%edx
  105608:	09 d0                	or     %edx,%eax
  10560a:	c1 e8 04             	shr    $0x4,%eax
  10560d:	09 d8                	or     %ebx,%eax
  10560f:	c1 e8 08             	shr    $0x8,%eax
  105612:	89 cb                	mov    %ecx,%ebx
  105614:	09 c3                	or     %eax,%ebx
  105616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105619:	d1 e8                	shr    %eax
  10561b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10561e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105621:	d1 ea                	shr    %edx
  105623:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105626:	c1 ea 02             	shr    $0x2,%edx
  105629:	09 d0                	or     %edx,%eax
  10562b:	89 c1                	mov    %eax,%ecx
  10562d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105630:	d1 e8                	shr    %eax
  105632:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105635:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105638:	d1 ea                	shr    %edx
  10563a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10563d:	c1 ea 02             	shr    $0x2,%edx
  105640:	09 d0                	or     %edx,%eax
  105642:	c1 e8 04             	shr    $0x4,%eax
  105645:	09 c1                	or     %eax,%ecx
  105647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10564a:	d1 e8                	shr    %eax
  10564c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10564f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105652:	d1 ea                	shr    %edx
  105654:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105657:	c1 ea 02             	shr    $0x2,%edx
  10565a:	09 d0                	or     %edx,%eax
  10565c:	89 c6                	mov    %eax,%esi
  10565e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105661:	d1 e8                	shr    %eax
  105663:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105666:	89 c2                	mov    %eax,%edx
  105668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10566b:	d1 e8                	shr    %eax
  10566d:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105670:	c1 e8 02             	shr    $0x2,%eax
  105673:	09 d0                	or     %edx,%eax
  105675:	c1 e8 04             	shr    $0x4,%eax
  105678:	09 f0                	or     %esi,%eax
  10567a:	c1 e8 08             	shr    $0x8,%eax
  10567d:	09 c8                	or     %ecx,%eax
  10567f:	c1 e8 10             	shr    $0x10,%eax
  105682:	09 d8                	or     %ebx,%eax
  105684:	d1 e8                	shr    %eax
  105686:	f7 d0                	not    %eax
  105688:	23 45 e4             	and    -0x1c(%ebp),%eax
  10568b:	89 c6                	mov    %eax,%esi
  10568d:	eb 03                	jmp    105692 <buddy_alloc_pages+0x3fd>
  10568f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  105692:	89 f8                	mov    %edi,%eax
  105694:	ba 00 00 00 00       	mov    $0x0,%edx
  105699:	f7 f6                	div    %esi
  10569b:	39 85 74 ff ff ff    	cmp    %eax,-0x8c(%ebp)
  1056a1:	0f 85 4a 07 00 00    	jne    105df1 <buddy_alloc_pages+0xb5c>
            size_t begin = BUDDY_BEGIN(block);
  1056a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056aa:	d1 e8                	shr    %eax
  1056ac:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1056af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056b2:	d1 ea                	shr    %edx
  1056b4:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1056b7:	c1 ea 02             	shr    $0x2,%edx
  1056ba:	09 d0                	or     %edx,%eax
  1056bc:	89 c1                	mov    %eax,%ecx
  1056be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056c1:	d1 e8                	shr    %eax
  1056c3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1056c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056c9:	d1 ea                	shr    %edx
  1056cb:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1056ce:	c1 ea 02             	shr    $0x2,%edx
  1056d1:	09 d0                	or     %edx,%eax
  1056d3:	c1 e8 04             	shr    $0x4,%eax
  1056d6:	09 c1                	or     %eax,%ecx
  1056d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056db:	d1 e8                	shr    %eax
  1056dd:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1056e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056e3:	d1 ea                	shr    %edx
  1056e5:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1056e8:	c1 ea 02             	shr    $0x2,%edx
  1056eb:	09 d0                	or     %edx,%eax
  1056ed:	89 c3                	mov    %eax,%ebx
  1056ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056f2:	d1 e8                	shr    %eax
  1056f4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1056f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056fa:	d1 ea                	shr    %edx
  1056fc:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1056ff:	c1 ea 02             	shr    $0x2,%edx
  105702:	09 d0                	or     %edx,%eax
  105704:	c1 e8 04             	shr    $0x4,%eax
  105707:	09 d8                	or     %ebx,%eax
  105709:	c1 e8 08             	shr    $0x8,%eax
  10570c:	09 c1                	or     %eax,%ecx
  10570e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105711:	d1 e8                	shr    %eax
  105713:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105716:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105719:	d1 ea                	shr    %edx
  10571b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10571e:	c1 ea 02             	shr    $0x2,%edx
  105721:	09 d0                	or     %edx,%eax
  105723:	89 c3                	mov    %eax,%ebx
  105725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105728:	d1 e8                	shr    %eax
  10572a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10572d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105730:	d1 ea                	shr    %edx
  105732:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105735:	c1 ea 02             	shr    $0x2,%edx
  105738:	09 d0                	or     %edx,%eax
  10573a:	c1 e8 04             	shr    $0x4,%eax
  10573d:	09 c3                	or     %eax,%ebx
  10573f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105742:	d1 e8                	shr    %eax
  105744:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105747:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10574a:	d1 ea                	shr    %edx
  10574c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10574f:	c1 ea 02             	shr    $0x2,%edx
  105752:	09 d0                	or     %edx,%eax
  105754:	89 c6                	mov    %eax,%esi
  105756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105759:	d1 e8                	shr    %eax
  10575b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10575e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105761:	d1 ea                	shr    %edx
  105763:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105766:	c1 ea 02             	shr    $0x2,%edx
  105769:	09 d0                	or     %edx,%eax
  10576b:	c1 e8 04             	shr    $0x4,%eax
  10576e:	09 f0                	or     %esi,%eax
  105770:	c1 e8 08             	shr    $0x8,%eax
  105773:	09 d8                	or     %ebx,%eax
  105775:	c1 e8 10             	shr    $0x10,%eax
  105778:	09 c8                	or     %ecx,%eax
  10577a:	d1 e8                	shr    %eax
  10577c:	23 45 e4             	and    -0x1c(%ebp),%eax
  10577f:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  105785:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  10578b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10578e:	d1 e8                	shr    %eax
  105790:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105796:	d1 ea                	shr    %edx
  105798:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10579b:	c1 ea 02             	shr    $0x2,%edx
  10579e:	09 d0                	or     %edx,%eax
  1057a0:	89 c1                	mov    %eax,%ecx
  1057a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057a5:	d1 e8                	shr    %eax
  1057a7:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1057aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1057ad:	d1 ea                	shr    %edx
  1057af:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1057b2:	c1 ea 02             	shr    $0x2,%edx
  1057b5:	09 d0                	or     %edx,%eax
  1057b7:	c1 e8 04             	shr    $0x4,%eax
  1057ba:	09 c1                	or     %eax,%ecx
  1057bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057bf:	d1 e8                	shr    %eax
  1057c1:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1057c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1057c7:	d1 ea                	shr    %edx
  1057c9:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1057cc:	c1 ea 02             	shr    $0x2,%edx
  1057cf:	09 d0                	or     %edx,%eax
  1057d1:	89 c3                	mov    %eax,%ebx
  1057d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057d6:	d1 e8                	shr    %eax
  1057d8:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1057db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1057de:	d1 ea                	shr    %edx
  1057e0:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1057e3:	c1 ea 02             	shr    $0x2,%edx
  1057e6:	09 d0                	or     %edx,%eax
  1057e8:	c1 e8 04             	shr    $0x4,%eax
  1057eb:	09 d8                	or     %ebx,%eax
  1057ed:	c1 e8 08             	shr    $0x8,%eax
  1057f0:	89 cb                	mov    %ecx,%ebx
  1057f2:	09 c3                	or     %eax,%ebx
  1057f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057f7:	d1 e8                	shr    %eax
  1057f9:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1057fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1057ff:	d1 ea                	shr    %edx
  105801:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105804:	c1 ea 02             	shr    $0x2,%edx
  105807:	09 d0                	or     %edx,%eax
  105809:	89 c1                	mov    %eax,%ecx
  10580b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10580e:	d1 e8                	shr    %eax
  105810:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105816:	d1 ea                	shr    %edx
  105818:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10581b:	c1 ea 02             	shr    $0x2,%edx
  10581e:	09 d0                	or     %edx,%eax
  105820:	c1 e8 04             	shr    $0x4,%eax
  105823:	09 c1                	or     %eax,%ecx
  105825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105828:	d1 e8                	shr    %eax
  10582a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10582d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105830:	d1 ea                	shr    %edx
  105832:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105835:	c1 ea 02             	shr    $0x2,%edx
  105838:	09 d0                	or     %edx,%eax
  10583a:	89 c6                	mov    %eax,%esi
  10583c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10583f:	d1 e8                	shr    %eax
  105841:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105844:	89 c2                	mov    %eax,%edx
  105846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105849:	d1 e8                	shr    %eax
  10584b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10584e:	c1 e8 02             	shr    $0x2,%eax
  105851:	09 d0                	or     %edx,%eax
  105853:	c1 e8 04             	shr    $0x4,%eax
  105856:	09 f0                	or     %esi,%eax
  105858:	c1 e8 08             	shr    $0x8,%eax
  10585b:	09 c8                	or     %ecx,%eax
  10585d:	c1 e8 10             	shr    $0x10,%eax
  105860:	09 d8                	or     %ebx,%eax
  105862:	d1 e8                	shr    %eax
  105864:	23 45 e4             	and    -0x1c(%ebp),%eax
  105867:	85 c0                	test   %eax,%eax
  105869:	0f 84 e2 00 00 00    	je     105951 <buddy_alloc_pages+0x6bc>
  10586f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105872:	d1 e8                	shr    %eax
  105874:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105877:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10587a:	d1 ea                	shr    %edx
  10587c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10587f:	c1 ea 02             	shr    $0x2,%edx
  105882:	09 d0                	or     %edx,%eax
  105884:	89 c1                	mov    %eax,%ecx
  105886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105889:	d1 e8                	shr    %eax
  10588b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10588e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105891:	d1 ea                	shr    %edx
  105893:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105896:	c1 ea 02             	shr    $0x2,%edx
  105899:	09 d0                	or     %edx,%eax
  10589b:	c1 e8 04             	shr    $0x4,%eax
  10589e:	09 c1                	or     %eax,%ecx
  1058a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058a3:	d1 e8                	shr    %eax
  1058a5:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1058a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1058ab:	d1 ea                	shr    %edx
  1058ad:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1058b0:	c1 ea 02             	shr    $0x2,%edx
  1058b3:	09 d0                	or     %edx,%eax
  1058b5:	89 c3                	mov    %eax,%ebx
  1058b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058ba:	d1 e8                	shr    %eax
  1058bc:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1058bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1058c2:	d1 ea                	shr    %edx
  1058c4:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1058c7:	c1 ea 02             	shr    $0x2,%edx
  1058ca:	09 d0                	or     %edx,%eax
  1058cc:	c1 e8 04             	shr    $0x4,%eax
  1058cf:	09 d8                	or     %ebx,%eax
  1058d1:	c1 e8 08             	shr    $0x8,%eax
  1058d4:	89 cb                	mov    %ecx,%ebx
  1058d6:	09 c3                	or     %eax,%ebx
  1058d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058db:	d1 e8                	shr    %eax
  1058dd:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1058e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1058e3:	d1 ea                	shr    %edx
  1058e5:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1058e8:	c1 ea 02             	shr    $0x2,%edx
  1058eb:	09 d0                	or     %edx,%eax
  1058ed:	89 c1                	mov    %eax,%ecx
  1058ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058f2:	d1 e8                	shr    %eax
  1058f4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1058f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1058fa:	d1 ea                	shr    %edx
  1058fc:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1058ff:	c1 ea 02             	shr    $0x2,%edx
  105902:	09 d0                	or     %edx,%eax
  105904:	c1 e8 04             	shr    $0x4,%eax
  105907:	09 c1                	or     %eax,%ecx
  105909:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10590c:	d1 e8                	shr    %eax
  10590e:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105911:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105914:	d1 ea                	shr    %edx
  105916:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105919:	c1 ea 02             	shr    $0x2,%edx
  10591c:	09 d0                	or     %edx,%eax
  10591e:	89 c6                	mov    %eax,%esi
  105920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105923:	d1 e8                	shr    %eax
  105925:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105928:	89 c2                	mov    %eax,%edx
  10592a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10592d:	d1 e8                	shr    %eax
  10592f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105932:	c1 e8 02             	shr    $0x2,%eax
  105935:	09 d0                	or     %edx,%eax
  105937:	c1 e8 04             	shr    $0x4,%eax
  10593a:	09 f0                	or     %esi,%eax
  10593c:	c1 e8 08             	shr    $0x8,%eax
  10593f:	09 c8                	or     %ecx,%eax
  105941:	c1 e8 10             	shr    $0x10,%eax
  105944:	09 d8                	or     %ebx,%eax
  105946:	d1 e8                	shr    %eax
  105948:	f7 d0                	not    %eax
  10594a:	23 45 e4             	and    -0x1c(%ebp),%eax
  10594d:	89 c6                	mov    %eax,%esi
  10594f:	eb 03                	jmp    105954 <buddy_alloc_pages+0x6bf>
  105951:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  105954:	89 f8                	mov    %edi,%eax
  105956:	ba 00 00 00 00       	mov    $0x0,%edx
  10595b:	f7 f6                	div    %esi
  10595d:	0f af 85 74 ff ff ff 	imul   -0x8c(%ebp),%eax
  105964:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            size_t end = BUDDY_END(block);
  105967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10596a:	d1 e8                	shr    %eax
  10596c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10596f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105972:	d1 ea                	shr    %edx
  105974:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105977:	c1 ea 02             	shr    $0x2,%edx
  10597a:	09 d0                	or     %edx,%eax
  10597c:	89 c1                	mov    %eax,%ecx
  10597e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105981:	d1 e8                	shr    %eax
  105983:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105986:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105989:	d1 ea                	shr    %edx
  10598b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10598e:	c1 ea 02             	shr    $0x2,%edx
  105991:	09 d0                	or     %edx,%eax
  105993:	c1 e8 04             	shr    $0x4,%eax
  105996:	09 c1                	or     %eax,%ecx
  105998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10599b:	d1 e8                	shr    %eax
  10599d:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1059a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1059a3:	d1 ea                	shr    %edx
  1059a5:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1059a8:	c1 ea 02             	shr    $0x2,%edx
  1059ab:	09 d0                	or     %edx,%eax
  1059ad:	89 c3                	mov    %eax,%ebx
  1059af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059b2:	d1 e8                	shr    %eax
  1059b4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1059b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1059ba:	d1 ea                	shr    %edx
  1059bc:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1059bf:	c1 ea 02             	shr    $0x2,%edx
  1059c2:	09 d0                	or     %edx,%eax
  1059c4:	c1 e8 04             	shr    $0x4,%eax
  1059c7:	09 d8                	or     %ebx,%eax
  1059c9:	c1 e8 08             	shr    $0x8,%eax
  1059cc:	09 c1                	or     %eax,%ecx
  1059ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059d1:	d1 e8                	shr    %eax
  1059d3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1059d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1059d9:	d1 ea                	shr    %edx
  1059db:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1059de:	c1 ea 02             	shr    $0x2,%edx
  1059e1:	09 d0                	or     %edx,%eax
  1059e3:	89 c3                	mov    %eax,%ebx
  1059e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059e8:	d1 e8                	shr    %eax
  1059ea:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1059ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1059f0:	d1 ea                	shr    %edx
  1059f2:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1059f5:	c1 ea 02             	shr    $0x2,%edx
  1059f8:	09 d0                	or     %edx,%eax
  1059fa:	c1 e8 04             	shr    $0x4,%eax
  1059fd:	09 c3                	or     %eax,%ebx
  1059ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a02:	d1 e8                	shr    %eax
  105a04:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105a07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a0a:	d1 ea                	shr    %edx
  105a0c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105a0f:	c1 ea 02             	shr    $0x2,%edx
  105a12:	09 d0                	or     %edx,%eax
  105a14:	89 c6                	mov    %eax,%esi
  105a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a19:	d1 e8                	shr    %eax
  105a1b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105a1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a21:	d1 ea                	shr    %edx
  105a23:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105a26:	c1 ea 02             	shr    $0x2,%edx
  105a29:	09 d0                	or     %edx,%eax
  105a2b:	c1 e8 04             	shr    $0x4,%eax
  105a2e:	09 f0                	or     %esi,%eax
  105a30:	c1 e8 08             	shr    $0x8,%eax
  105a33:	09 d8                	or     %ebx,%eax
  105a35:	c1 e8 10             	shr    $0x10,%eax
  105a38:	09 c8                	or     %ecx,%eax
  105a3a:	d1 e8                	shr    %eax
  105a3c:	23 45 e4             	and    -0x1c(%ebp),%eax
  105a3f:	83 c0 01             	add    $0x1,%eax
  105a42:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  105a48:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  105a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a51:	d1 e8                	shr    %eax
  105a53:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105a56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a59:	d1 ea                	shr    %edx
  105a5b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105a5e:	c1 ea 02             	shr    $0x2,%edx
  105a61:	09 d0                	or     %edx,%eax
  105a63:	89 c1                	mov    %eax,%ecx
  105a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a68:	d1 e8                	shr    %eax
  105a6a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105a6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a70:	d1 ea                	shr    %edx
  105a72:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105a75:	c1 ea 02             	shr    $0x2,%edx
  105a78:	09 d0                	or     %edx,%eax
  105a7a:	c1 e8 04             	shr    $0x4,%eax
  105a7d:	09 c1                	or     %eax,%ecx
  105a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a82:	d1 e8                	shr    %eax
  105a84:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105a87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a8a:	d1 ea                	shr    %edx
  105a8c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105a8f:	c1 ea 02             	shr    $0x2,%edx
  105a92:	09 d0                	or     %edx,%eax
  105a94:	89 c3                	mov    %eax,%ebx
  105a96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a99:	d1 e8                	shr    %eax
  105a9b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105a9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105aa1:	d1 ea                	shr    %edx
  105aa3:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105aa6:	c1 ea 02             	shr    $0x2,%edx
  105aa9:	09 d0                	or     %edx,%eax
  105aab:	c1 e8 04             	shr    $0x4,%eax
  105aae:	09 d8                	or     %ebx,%eax
  105ab0:	c1 e8 08             	shr    $0x8,%eax
  105ab3:	89 cb                	mov    %ecx,%ebx
  105ab5:	09 c3                	or     %eax,%ebx
  105ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105aba:	d1 e8                	shr    %eax
  105abc:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105abf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ac2:	d1 ea                	shr    %edx
  105ac4:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105ac7:	c1 ea 02             	shr    $0x2,%edx
  105aca:	09 d0                	or     %edx,%eax
  105acc:	89 c1                	mov    %eax,%ecx
  105ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ad1:	d1 e8                	shr    %eax
  105ad3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105ad6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ad9:	d1 ea                	shr    %edx
  105adb:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105ade:	c1 ea 02             	shr    $0x2,%edx
  105ae1:	09 d0                	or     %edx,%eax
  105ae3:	c1 e8 04             	shr    $0x4,%eax
  105ae6:	09 c1                	or     %eax,%ecx
  105ae8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105aeb:	d1 e8                	shr    %eax
  105aed:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105af0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105af3:	d1 ea                	shr    %edx
  105af5:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105af8:	c1 ea 02             	shr    $0x2,%edx
  105afb:	09 d0                	or     %edx,%eax
  105afd:	89 c6                	mov    %eax,%esi
  105aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b02:	d1 e8                	shr    %eax
  105b04:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105b07:	89 c2                	mov    %eax,%edx
  105b09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b0c:	d1 e8                	shr    %eax
  105b0e:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105b11:	c1 e8 02             	shr    $0x2,%eax
  105b14:	09 d0                	or     %edx,%eax
  105b16:	c1 e8 04             	shr    $0x4,%eax
  105b19:	09 f0                	or     %esi,%eax
  105b1b:	c1 e8 08             	shr    $0x8,%eax
  105b1e:	09 c8                	or     %ecx,%eax
  105b20:	c1 e8 10             	shr    $0x10,%eax
  105b23:	09 d8                	or     %ebx,%eax
  105b25:	d1 e8                	shr    %eax
  105b27:	23 45 e4             	and    -0x1c(%ebp),%eax
  105b2a:	85 c0                	test   %eax,%eax
  105b2c:	0f 84 e2 00 00 00    	je     105c14 <buddy_alloc_pages+0x97f>
  105b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b35:	d1 e8                	shr    %eax
  105b37:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105b3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105b3d:	d1 ea                	shr    %edx
  105b3f:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105b42:	c1 ea 02             	shr    $0x2,%edx
  105b45:	09 d0                	or     %edx,%eax
  105b47:	89 c1                	mov    %eax,%ecx
  105b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b4c:	d1 e8                	shr    %eax
  105b4e:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105b51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105b54:	d1 ea                	shr    %edx
  105b56:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105b59:	c1 ea 02             	shr    $0x2,%edx
  105b5c:	09 d0                	or     %edx,%eax
  105b5e:	c1 e8 04             	shr    $0x4,%eax
  105b61:	09 c1                	or     %eax,%ecx
  105b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b66:	d1 e8                	shr    %eax
  105b68:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105b6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105b6e:	d1 ea                	shr    %edx
  105b70:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105b73:	c1 ea 02             	shr    $0x2,%edx
  105b76:	09 d0                	or     %edx,%eax
  105b78:	89 c3                	mov    %eax,%ebx
  105b7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b7d:	d1 e8                	shr    %eax
  105b7f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105b82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105b85:	d1 ea                	shr    %edx
  105b87:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105b8a:	c1 ea 02             	shr    $0x2,%edx
  105b8d:	09 d0                	or     %edx,%eax
  105b8f:	c1 e8 04             	shr    $0x4,%eax
  105b92:	09 d8                	or     %ebx,%eax
  105b94:	c1 e8 08             	shr    $0x8,%eax
  105b97:	89 cb                	mov    %ecx,%ebx
  105b99:	09 c3                	or     %eax,%ebx
  105b9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b9e:	d1 e8                	shr    %eax
  105ba0:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105ba3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ba6:	d1 ea                	shr    %edx
  105ba8:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105bab:	c1 ea 02             	shr    $0x2,%edx
  105bae:	09 d0                	or     %edx,%eax
  105bb0:	89 c1                	mov    %eax,%ecx
  105bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105bb5:	d1 e8                	shr    %eax
  105bb7:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105bba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105bbd:	d1 ea                	shr    %edx
  105bbf:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105bc2:	c1 ea 02             	shr    $0x2,%edx
  105bc5:	09 d0                	or     %edx,%eax
  105bc7:	c1 e8 04             	shr    $0x4,%eax
  105bca:	09 c1                	or     %eax,%ecx
  105bcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105bcf:	d1 e8                	shr    %eax
  105bd1:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105bd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105bd7:	d1 ea                	shr    %edx
  105bd9:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105bdc:	c1 ea 02             	shr    $0x2,%edx
  105bdf:	09 d0                	or     %edx,%eax
  105be1:	89 c6                	mov    %eax,%esi
  105be3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105be6:	d1 e8                	shr    %eax
  105be8:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105beb:	89 c2                	mov    %eax,%edx
  105bed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105bf0:	d1 e8                	shr    %eax
  105bf2:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105bf5:	c1 e8 02             	shr    $0x2,%eax
  105bf8:	09 d0                	or     %edx,%eax
  105bfa:	c1 e8 04             	shr    $0x4,%eax
  105bfd:	09 f0                	or     %esi,%eax
  105bff:	c1 e8 08             	shr    $0x8,%eax
  105c02:	09 c8                	or     %ecx,%eax
  105c04:	c1 e8 10             	shr    $0x10,%eax
  105c07:	09 d8                	or     %ebx,%eax
  105c09:	d1 e8                	shr    %eax
  105c0b:	f7 d0                	not    %eax
  105c0d:	23 45 e4             	and    -0x1c(%ebp),%eax
  105c10:	89 c6                	mov    %eax,%esi
  105c12:	eb 03                	jmp    105c17 <buddy_alloc_pages+0x982>
  105c14:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  105c17:	89 f8                	mov    %edi,%eax
  105c19:	ba 00 00 00 00       	mov    $0x0,%edx
  105c1e:	f7 f6                	div    %esi
  105c20:	0f af 85 74 ff ff ff 	imul   -0x8c(%ebp),%eax
  105c27:	89 45 d0             	mov    %eax,-0x30(%ebp)
            size_t mid = (begin+end)>>1;
  105c2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105c2d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105c30:	01 d0                	add    %edx,%eax
  105c32:	d1 e8                	shr    %eax
  105c34:	89 45 cc             	mov    %eax,-0x34(%ebp)
            list_del(&(buddy_alloc[begin].page_link));
  105c37:	8b 0d 64 e9 11 00    	mov    0x11e964,%ecx
  105c3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105c40:	89 d0                	mov    %edx,%eax
  105c42:	c1 e0 02             	shl    $0x2,%eax
  105c45:	01 d0                	add    %edx,%eax
  105c47:	c1 e0 02             	shl    $0x2,%eax
  105c4a:	01 c8                	add    %ecx,%eax
  105c4c:	83 c0 0c             	add    $0xc,%eax
  105c4f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  105c52:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105c55:	8b 40 04             	mov    0x4(%eax),%eax
  105c58:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  105c5b:	8b 12                	mov    (%edx),%edx
  105c5d:	89 55 c0             	mov    %edx,-0x40(%ebp)
  105c60:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  105c63:	8b 45 c0             	mov    -0x40(%ebp),%eax
  105c66:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105c69:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  105c6c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105c6f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  105c72:	89 10                	mov    %edx,(%eax)
            buddy_alloc[begin].property >>= 1;
  105c74:	8b 0d 64 e9 11 00    	mov    0x11e964,%ecx
  105c7a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105c7d:	89 d0                	mov    %edx,%eax
  105c7f:	c1 e0 02             	shl    $0x2,%eax
  105c82:	01 d0                	add    %edx,%eax
  105c84:	c1 e0 02             	shl    $0x2,%eax
  105c87:	01 c1                	add    %eax,%ecx
  105c89:	8b 1d 64 e9 11 00    	mov    0x11e964,%ebx
  105c8f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105c92:	89 d0                	mov    %edx,%eax
  105c94:	c1 e0 02             	shl    $0x2,%eax
  105c97:	01 d0                	add    %edx,%eax
  105c99:	c1 e0 02             	shl    $0x2,%eax
  105c9c:	01 d8                	add    %ebx,%eax
  105c9e:	8b 40 08             	mov    0x8(%eax),%eax
  105ca1:	d1 e8                	shr    %eax
  105ca3:	89 41 08             	mov    %eax,0x8(%ecx)
            buddy_alloc[mid].property = buddy_alloc[begin].property;
  105ca6:	8b 0d 64 e9 11 00    	mov    0x11e964,%ecx
  105cac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  105caf:	89 d0                	mov    %edx,%eax
  105cb1:	c1 e0 02             	shl    $0x2,%eax
  105cb4:	01 d0                	add    %edx,%eax
  105cb6:	c1 e0 02             	shl    $0x2,%eax
  105cb9:	01 c1                	add    %eax,%ecx
  105cbb:	8b 1d 64 e9 11 00    	mov    0x11e964,%ebx
  105cc1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105cc4:	89 d0                	mov    %edx,%eax
  105cc6:	c1 e0 02             	shl    $0x2,%eax
  105cc9:	01 d0                	add    %edx,%eax
  105ccb:	c1 e0 02             	shl    $0x2,%eax
  105cce:	01 d8                	add    %ebx,%eax
  105cd0:	8b 40 08             	mov    0x8(%eax),%eax
  105cd3:	89 41 08             	mov    %eax,0x8(%ecx)
            buddy_segment[left] = buddy_segment[block]>>1;
  105cd6:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  105cdb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105cde:	c1 e2 02             	shl    $0x2,%edx
  105ce1:	01 d0                	add    %edx,%eax
  105ce3:	8b 15 5c e9 11 00    	mov    0x11e95c,%edx
  105ce9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105cec:	c1 e1 02             	shl    $0x2,%ecx
  105cef:	01 ca                	add    %ecx,%edx
  105cf1:	8b 12                	mov    (%edx),%edx
  105cf3:	d1 ea                	shr    %edx
  105cf5:	89 10                	mov    %edx,(%eax)
            buddy_segment[right] = buddy_segment[block]>>1;
  105cf7:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  105cfc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105cff:	c1 e2 02             	shl    $0x2,%edx
  105d02:	01 d0                	add    %edx,%eax
  105d04:	8b 15 5c e9 11 00    	mov    0x11e95c,%edx
  105d0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105d0d:	c1 e1 02             	shl    $0x2,%ecx
  105d10:	01 ca                	add    %ecx,%edx
  105d12:	8b 12                	mov    (%edx),%edx
  105d14:	d1 ea                	shr    %edx
  105d16:	89 10                	mov    %edx,(%eax)
            list_add(&free_list, &(buddy_alloc[begin].page_link));
  105d18:	8b 0d 64 e9 11 00    	mov    0x11e964,%ecx
  105d1e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105d21:	89 d0                	mov    %edx,%eax
  105d23:	c1 e0 02             	shl    $0x2,%eax
  105d26:	01 d0                	add    %edx,%eax
  105d28:	c1 e0 02             	shl    $0x2,%eax
  105d2b:	01 c8                	add    %ecx,%eax
  105d2d:	83 c0 0c             	add    $0xc,%eax
  105d30:	c7 45 b8 78 e9 11 00 	movl   $0x11e978,-0x48(%ebp)
  105d37:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  105d3a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  105d3d:	89 45 b0             	mov    %eax,-0x50(%ebp)
  105d40:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105d43:	89 45 ac             	mov    %eax,-0x54(%ebp)
    __list_add(elm, listelm, listelm->next);
  105d46:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105d49:	8b 40 04             	mov    0x4(%eax),%eax
  105d4c:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105d4f:	89 55 a8             	mov    %edx,-0x58(%ebp)
  105d52:	8b 55 b0             	mov    -0x50(%ebp),%edx
  105d55:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  105d58:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next->prev = elm;
  105d5b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105d5e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  105d61:	89 10                	mov    %edx,(%eax)
  105d63:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105d66:	8b 10                	mov    (%eax),%edx
  105d68:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105d6b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105d6e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105d71:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105d74:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105d77:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105d7a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  105d7d:	89 10                	mov    %edx,(%eax)
            list_add(&free_list, &(buddy_alloc[mid].page_link));
  105d7f:	8b 0d 64 e9 11 00    	mov    0x11e964,%ecx
  105d85:	8b 55 cc             	mov    -0x34(%ebp),%edx
  105d88:	89 d0                	mov    %edx,%eax
  105d8a:	c1 e0 02             	shl    $0x2,%eax
  105d8d:	01 d0                	add    %edx,%eax
  105d8f:	c1 e0 02             	shl    $0x2,%eax
  105d92:	01 c8                	add    %ecx,%eax
  105d94:	83 c0 0c             	add    $0xc,%eax
  105d97:	c7 45 9c 78 e9 11 00 	movl   $0x11e978,-0x64(%ebp)
  105d9e:	89 45 98             	mov    %eax,-0x68(%ebp)
  105da1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105da4:	89 45 94             	mov    %eax,-0x6c(%ebp)
  105da7:	8b 45 98             	mov    -0x68(%ebp),%eax
  105daa:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
  105dad:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105db0:	8b 40 04             	mov    0x4(%eax),%eax
  105db3:	8b 55 90             	mov    -0x70(%ebp),%edx
  105db6:	89 55 8c             	mov    %edx,-0x74(%ebp)
  105db9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105dbc:	89 55 88             	mov    %edx,-0x78(%ebp)
  105dbf:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  105dc2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  105dc5:	8b 55 8c             	mov    -0x74(%ebp),%edx
  105dc8:	89 10                	mov    %edx,(%eax)
  105dca:	8b 45 84             	mov    -0x7c(%ebp),%eax
  105dcd:	8b 10                	mov    (%eax),%edx
  105dcf:	8b 45 88             	mov    -0x78(%ebp),%eax
  105dd2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105dd5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  105dd8:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105ddb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105dde:	8b 45 8c             	mov    -0x74(%ebp),%eax
  105de1:	8b 55 88             	mov    -0x78(%ebp),%edx
  105de4:	89 10                	mov    %edx,(%eax)
            block = left;
  105de6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105de9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105dec:	e9 98 00 00 00       	jmp    105e89 <buddy_alloc_pages+0xbf4>
        } else if (length & buddy_segment[left]) {  // Find in left (optimize)
  105df1:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  105df6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105df9:	c1 e2 02             	shl    $0x2,%edx
  105dfc:	01 d0                	add    %edx,%eax
  105dfe:	8b 00                	mov    (%eax),%eax
  105e00:	23 45 e0             	and    -0x20(%ebp),%eax
  105e03:	85 c0                	test   %eax,%eax
  105e05:	74 08                	je     105e0f <buddy_alloc_pages+0xb7a>
            block = left;
  105e07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e0d:	eb 7a                	jmp    105e89 <buddy_alloc_pages+0xbf4>
        } else if (length & buddy_segment[right]) { // Find in right (optimize)
  105e0f:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  105e14:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105e17:	c1 e2 02             	shl    $0x2,%edx
  105e1a:	01 d0                	add    %edx,%eax
  105e1c:	8b 00                	mov    (%eax),%eax
  105e1e:	23 45 e0             	and    -0x20(%ebp),%eax
  105e21:	85 c0                	test   %eax,%eax
  105e23:	74 08                	je     105e2d <buddy_alloc_pages+0xb98>
            block = right;
  105e25:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105e28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e2b:	eb 5c                	jmp    105e89 <buddy_alloc_pages+0xbf4>
        } else if (length <= buddy_segment[left]) { // Find in left
  105e2d:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  105e32:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105e35:	c1 e2 02             	shl    $0x2,%edx
  105e38:	01 d0                	add    %edx,%eax
  105e3a:	8b 00                	mov    (%eax),%eax
  105e3c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  105e3f:	72 08                	jb     105e49 <buddy_alloc_pages+0xbb4>
            block = left;
  105e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e47:	eb 40                	jmp    105e89 <buddy_alloc_pages+0xbf4>
        } else if (length <= buddy_segment[right]) {// Find in right
  105e49:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  105e4e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105e51:	c1 e2 02             	shl    $0x2,%edx
  105e54:	01 d0                	add    %edx,%eax
  105e56:	8b 00                	mov    (%eax),%eax
  105e58:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  105e5b:	72 08                	jb     105e65 <buddy_alloc_pages+0xbd0>
            block = right;
  105e5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105e60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e63:	eb 24                	jmp    105e89 <buddy_alloc_pages+0xbf4>
        } else {                                    // Shouldn't be here
            assert(0);
  105e65:	c7 44 24 0c f5 ab 10 	movl   $0x10abf5,0xc(%esp)
  105e6c:	00 
  105e6d:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  105e74:	00 
  105e75:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  105e7c:	00 
  105e7d:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  105e84:	e8 5f a5 ff ff       	call   1003e8 <__panic>
    while (length <= buddy_segment[block] && length < BUDDY_LENGTH(block)) {
  105e89:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  105e8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e91:	c1 e2 02             	shl    $0x2,%edx
  105e94:	01 d0                	add    %edx,%eax
  105e96:	8b 00                	mov    (%eax),%eax
  105e98:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  105e9b:	0f 82 d6 01 00 00    	jb     106077 <buddy_alloc_pages+0xde2>
  105ea1:	a1 50 e9 11 00       	mov    0x11e950,%eax
  105ea6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ea9:	d1 ea                	shr    %edx
  105eab:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105eae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105eb1:	d1 e9                	shr    %ecx
  105eb3:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105eb6:	c1 e9 02             	shr    $0x2,%ecx
  105eb9:	89 d3                	mov    %edx,%ebx
  105ebb:	09 cb                	or     %ecx,%ebx
  105ebd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ec0:	d1 ea                	shr    %edx
  105ec2:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105ec5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105ec8:	d1 e9                	shr    %ecx
  105eca:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105ecd:	c1 e9 02             	shr    $0x2,%ecx
  105ed0:	09 ca                	or     %ecx,%edx
  105ed2:	c1 ea 04             	shr    $0x4,%edx
  105ed5:	09 d3                	or     %edx,%ebx
  105ed7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105eda:	d1 ea                	shr    %edx
  105edc:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105edf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105ee2:	d1 e9                	shr    %ecx
  105ee4:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105ee7:	c1 e9 02             	shr    $0x2,%ecx
  105eea:	89 d6                	mov    %edx,%esi
  105eec:	09 ce                	or     %ecx,%esi
  105eee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ef1:	d1 ea                	shr    %edx
  105ef3:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105ef6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105ef9:	d1 e9                	shr    %ecx
  105efb:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105efe:	c1 e9 02             	shr    $0x2,%ecx
  105f01:	09 ca                	or     %ecx,%edx
  105f03:	c1 ea 04             	shr    $0x4,%edx
  105f06:	09 f2                	or     %esi,%edx
  105f08:	c1 ea 08             	shr    $0x8,%edx
  105f0b:	09 d3                	or     %edx,%ebx
  105f0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f10:	d1 ea                	shr    %edx
  105f12:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105f18:	d1 e9                	shr    %ecx
  105f1a:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105f1d:	c1 e9 02             	shr    $0x2,%ecx
  105f20:	89 d6                	mov    %edx,%esi
  105f22:	09 ce                	or     %ecx,%esi
  105f24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f27:	d1 ea                	shr    %edx
  105f29:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105f2c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105f2f:	d1 e9                	shr    %ecx
  105f31:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105f34:	c1 e9 02             	shr    $0x2,%ecx
  105f37:	09 ca                	or     %ecx,%edx
  105f39:	c1 ea 04             	shr    $0x4,%edx
  105f3c:	09 d6                	or     %edx,%esi
  105f3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f41:	d1 ea                	shr    %edx
  105f43:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105f46:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105f49:	d1 e9                	shr    %ecx
  105f4b:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105f4e:	c1 e9 02             	shr    $0x2,%ecx
  105f51:	89 d7                	mov    %edx,%edi
  105f53:	09 cf                	or     %ecx,%edi
  105f55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f58:	d1 ea                	shr    %edx
  105f5a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105f5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105f60:	d1 e9                	shr    %ecx
  105f62:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105f65:	c1 e9 02             	shr    $0x2,%ecx
  105f68:	09 ca                	or     %ecx,%edx
  105f6a:	c1 ea 04             	shr    $0x4,%edx
  105f6d:	09 fa                	or     %edi,%edx
  105f6f:	c1 ea 08             	shr    $0x8,%edx
  105f72:	09 f2                	or     %esi,%edx
  105f74:	c1 ea 10             	shr    $0x10,%edx
  105f77:	09 da                	or     %ebx,%edx
  105f79:	d1 ea                	shr    %edx
  105f7b:	23 55 e4             	and    -0x1c(%ebp),%edx
  105f7e:	85 d2                	test   %edx,%edx
  105f80:	0f 84 de 00 00 00    	je     106064 <buddy_alloc_pages+0xdcf>
  105f86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f89:	d1 ea                	shr    %edx
  105f8b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105f8e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105f91:	d1 e9                	shr    %ecx
  105f93:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105f96:	c1 e9 02             	shr    $0x2,%ecx
  105f99:	89 d3                	mov    %edx,%ebx
  105f9b:	09 cb                	or     %ecx,%ebx
  105f9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105fa0:	d1 ea                	shr    %edx
  105fa2:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105fa5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105fa8:	d1 e9                	shr    %ecx
  105faa:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105fad:	c1 e9 02             	shr    $0x2,%ecx
  105fb0:	09 ca                	or     %ecx,%edx
  105fb2:	c1 ea 04             	shr    $0x4,%edx
  105fb5:	09 d3                	or     %edx,%ebx
  105fb7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105fba:	d1 ea                	shr    %edx
  105fbc:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105fbf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105fc2:	d1 e9                	shr    %ecx
  105fc4:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105fc7:	c1 e9 02             	shr    $0x2,%ecx
  105fca:	89 d6                	mov    %edx,%esi
  105fcc:	09 ce                	or     %ecx,%esi
  105fce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105fd1:	d1 ea                	shr    %edx
  105fd3:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105fd6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105fd9:	d1 e9                	shr    %ecx
  105fdb:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105fde:	c1 e9 02             	shr    $0x2,%ecx
  105fe1:	09 ca                	or     %ecx,%edx
  105fe3:	c1 ea 04             	shr    $0x4,%edx
  105fe6:	09 f2                	or     %esi,%edx
  105fe8:	c1 ea 08             	shr    $0x8,%edx
  105feb:	09 d3                	or     %edx,%ebx
  105fed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ff0:	d1 ea                	shr    %edx
  105ff2:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105ff5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  105ff8:	d1 e9                	shr    %ecx
  105ffa:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  105ffd:	c1 e9 02             	shr    $0x2,%ecx
  106000:	89 d6                	mov    %edx,%esi
  106002:	09 ce                	or     %ecx,%esi
  106004:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106007:	d1 ea                	shr    %edx
  106009:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10600c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10600f:	d1 e9                	shr    %ecx
  106011:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  106014:	c1 e9 02             	shr    $0x2,%ecx
  106017:	09 ca                	or     %ecx,%edx
  106019:	c1 ea 04             	shr    $0x4,%edx
  10601c:	09 d6                	or     %edx,%esi
  10601e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106021:	d1 ea                	shr    %edx
  106023:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106026:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  106029:	d1 e9                	shr    %ecx
  10602b:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  10602e:	c1 e9 02             	shr    $0x2,%ecx
  106031:	89 d7                	mov    %edx,%edi
  106033:	09 cf                	or     %ecx,%edi
  106035:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106038:	d1 ea                	shr    %edx
  10603a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10603d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  106040:	d1 e9                	shr    %ecx
  106042:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  106045:	c1 e9 02             	shr    $0x2,%ecx
  106048:	09 ca                	or     %ecx,%edx
  10604a:	c1 ea 04             	shr    $0x4,%edx
  10604d:	09 fa                	or     %edi,%edx
  10604f:	c1 ea 08             	shr    $0x8,%edx
  106052:	09 f2                	or     %esi,%edx
  106054:	c1 ea 10             	shr    $0x10,%edx
  106057:	09 da                	or     %ebx,%edx
  106059:	d1 ea                	shr    %edx
  10605b:	f7 d2                	not    %edx
  10605d:	89 d7                	mov    %edx,%edi
  10605f:	23 7d e4             	and    -0x1c(%ebp),%edi
  106062:	eb 03                	jmp    106067 <buddy_alloc_pages+0xdd2>
  106064:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  106067:	ba 00 00 00 00       	mov    $0x0,%edx
  10606c:	f7 f7                	div    %edi
  10606e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  106071:	0f 87 24 f4 ff ff    	ja     10549b <buddy_alloc_pages+0x206>
        }
    }
    // Allocate
    if (length > buddy_segment[block])
  106077:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  10607c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10607f:	c1 e2 02             	shl    $0x2,%edx
  106082:	01 d0                	add    %edx,%eax
  106084:	8b 00                	mov    (%eax),%eax
  106086:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  106089:	73 0a                	jae    106095 <buddy_alloc_pages+0xe00>
        return NULL;
  10608b:	b8 00 00 00 00       	mov    $0x0,%eax
  106090:	e9 8c 03 00 00       	jmp    106421 <buddy_alloc_pages+0x118c>
    page = &(buddy_alloc[BUDDY_BEGIN(block)]);
  106095:	a1 64 e9 11 00       	mov    0x11e964,%eax
  10609a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  1060a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060a3:	d1 e8                	shr    %eax
  1060a5:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1060a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1060ab:	d1 ea                	shr    %edx
  1060ad:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1060b0:	c1 ea 02             	shr    $0x2,%edx
  1060b3:	09 d0                	or     %edx,%eax
  1060b5:	89 c1                	mov    %eax,%ecx
  1060b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060ba:	d1 e8                	shr    %eax
  1060bc:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1060bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1060c2:	d1 ea                	shr    %edx
  1060c4:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1060c7:	c1 ea 02             	shr    $0x2,%edx
  1060ca:	09 d0                	or     %edx,%eax
  1060cc:	c1 e8 04             	shr    $0x4,%eax
  1060cf:	09 c1                	or     %eax,%ecx
  1060d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060d4:	d1 e8                	shr    %eax
  1060d6:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1060d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1060dc:	d1 ea                	shr    %edx
  1060de:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1060e1:	c1 ea 02             	shr    $0x2,%edx
  1060e4:	09 d0                	or     %edx,%eax
  1060e6:	89 c3                	mov    %eax,%ebx
  1060e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060eb:	d1 e8                	shr    %eax
  1060ed:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1060f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1060f3:	d1 ea                	shr    %edx
  1060f5:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1060f8:	c1 ea 02             	shr    $0x2,%edx
  1060fb:	09 d0                	or     %edx,%eax
  1060fd:	c1 e8 04             	shr    $0x4,%eax
  106100:	09 d8                	or     %ebx,%eax
  106102:	c1 e8 08             	shr    $0x8,%eax
  106105:	09 c1                	or     %eax,%ecx
  106107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10610a:	d1 e8                	shr    %eax
  10610c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10610f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106112:	d1 ea                	shr    %edx
  106114:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106117:	c1 ea 02             	shr    $0x2,%edx
  10611a:	09 d0                	or     %edx,%eax
  10611c:	89 c3                	mov    %eax,%ebx
  10611e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106121:	d1 e8                	shr    %eax
  106123:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106126:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106129:	d1 ea                	shr    %edx
  10612b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10612e:	c1 ea 02             	shr    $0x2,%edx
  106131:	09 d0                	or     %edx,%eax
  106133:	c1 e8 04             	shr    $0x4,%eax
  106136:	09 c3                	or     %eax,%ebx
  106138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10613b:	d1 e8                	shr    %eax
  10613d:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106140:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106143:	d1 ea                	shr    %edx
  106145:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106148:	c1 ea 02             	shr    $0x2,%edx
  10614b:	09 d0                	or     %edx,%eax
  10614d:	89 c6                	mov    %eax,%esi
  10614f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106152:	d1 e8                	shr    %eax
  106154:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106157:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10615a:	d1 ea                	shr    %edx
  10615c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10615f:	c1 ea 02             	shr    $0x2,%edx
  106162:	09 d0                	or     %edx,%eax
  106164:	c1 e8 04             	shr    $0x4,%eax
  106167:	09 f0                	or     %esi,%eax
  106169:	c1 e8 08             	shr    $0x8,%eax
  10616c:	09 d8                	or     %ebx,%eax
  10616e:	c1 e8 10             	shr    $0x10,%eax
  106171:	09 c8                	or     %ecx,%eax
  106173:	d1 e8                	shr    %eax
  106175:	23 45 e4             	and    -0x1c(%ebp),%eax
  106178:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  10617e:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  106184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106187:	d1 e8                	shr    %eax
  106189:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10618c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10618f:	d1 ea                	shr    %edx
  106191:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106194:	c1 ea 02             	shr    $0x2,%edx
  106197:	09 d0                	or     %edx,%eax
  106199:	89 c1                	mov    %eax,%ecx
  10619b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10619e:	d1 e8                	shr    %eax
  1061a0:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1061a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1061a6:	d1 ea                	shr    %edx
  1061a8:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1061ab:	c1 ea 02             	shr    $0x2,%edx
  1061ae:	09 d0                	or     %edx,%eax
  1061b0:	c1 e8 04             	shr    $0x4,%eax
  1061b3:	09 c1                	or     %eax,%ecx
  1061b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1061b8:	d1 e8                	shr    %eax
  1061ba:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1061bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1061c0:	d1 ea                	shr    %edx
  1061c2:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1061c5:	c1 ea 02             	shr    $0x2,%edx
  1061c8:	09 d0                	or     %edx,%eax
  1061ca:	89 c3                	mov    %eax,%ebx
  1061cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1061cf:	d1 e8                	shr    %eax
  1061d1:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1061d4:	89 c2                	mov    %eax,%edx
  1061d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1061d9:	d1 e8                	shr    %eax
  1061db:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1061de:	c1 e8 02             	shr    $0x2,%eax
  1061e1:	09 d0                	or     %edx,%eax
  1061e3:	c1 e8 04             	shr    $0x4,%eax
  1061e6:	09 d8                	or     %ebx,%eax
  1061e8:	c1 e8 08             	shr    $0x8,%eax
  1061eb:	89 ce                	mov    %ecx,%esi
  1061ed:	09 c6                	or     %eax,%esi
  1061ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1061f2:	d1 e8                	shr    %eax
  1061f4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1061f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1061fa:	d1 ea                	shr    %edx
  1061fc:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1061ff:	c1 ea 02             	shr    $0x2,%edx
  106202:	09 d0                	or     %edx,%eax
  106204:	89 c1                	mov    %eax,%ecx
  106206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106209:	d1 e8                	shr    %eax
  10620b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10620e:	89 c2                	mov    %eax,%edx
  106210:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106213:	d1 e8                	shr    %eax
  106215:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106218:	c1 e8 02             	shr    $0x2,%eax
  10621b:	09 d0                	or     %edx,%eax
  10621d:	c1 e8 04             	shr    $0x4,%eax
  106220:	89 cb                	mov    %ecx,%ebx
  106222:	09 c3                	or     %eax,%ebx
  106224:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106227:	d1 e8                	shr    %eax
  106229:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10622c:	89 c2                	mov    %eax,%edx
  10622e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106231:	d1 e8                	shr    %eax
  106233:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106236:	c1 e8 02             	shr    $0x2,%eax
  106239:	89 d1                	mov    %edx,%ecx
  10623b:	09 c1                	or     %eax,%ecx
  10623d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106240:	d1 e8                	shr    %eax
  106242:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106245:	89 c2                	mov    %eax,%edx
  106247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10624a:	d1 e8                	shr    %eax
  10624c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10624f:	c1 e8 02             	shr    $0x2,%eax
  106252:	09 d0                	or     %edx,%eax
  106254:	c1 e8 04             	shr    $0x4,%eax
  106257:	09 c8                	or     %ecx,%eax
  106259:	c1 e8 08             	shr    $0x8,%eax
  10625c:	09 d8                	or     %ebx,%eax
  10625e:	c1 e8 10             	shr    $0x10,%eax
  106261:	09 f0                	or     %esi,%eax
  106263:	d1 e8                	shr    %eax
  106265:	23 45 e4             	and    -0x1c(%ebp),%eax
  106268:	85 c0                	test   %eax,%eax
  10626a:	0f 84 ea 00 00 00    	je     10635a <buddy_alloc_pages+0x10c5>
  106270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106273:	d1 e8                	shr    %eax
  106275:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106278:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10627b:	d1 ea                	shr    %edx
  10627d:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106280:	c1 ea 02             	shr    $0x2,%edx
  106283:	09 d0                	or     %edx,%eax
  106285:	89 c1                	mov    %eax,%ecx
  106287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10628a:	d1 e8                	shr    %eax
  10628c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10628f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106292:	d1 ea                	shr    %edx
  106294:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106297:	c1 ea 02             	shr    $0x2,%edx
  10629a:	09 d0                	or     %edx,%eax
  10629c:	c1 e8 04             	shr    $0x4,%eax
  10629f:	09 c1                	or     %eax,%ecx
  1062a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062a4:	d1 e8                	shr    %eax
  1062a6:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1062a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1062ac:	d1 ea                	shr    %edx
  1062ae:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1062b1:	c1 ea 02             	shr    $0x2,%edx
  1062b4:	09 d0                	or     %edx,%eax
  1062b6:	89 c3                	mov    %eax,%ebx
  1062b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062bb:	d1 e8                	shr    %eax
  1062bd:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1062c0:	89 c2                	mov    %eax,%edx
  1062c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062c5:	d1 e8                	shr    %eax
  1062c7:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1062ca:	c1 e8 02             	shr    $0x2,%eax
  1062cd:	09 d0                	or     %edx,%eax
  1062cf:	c1 e8 04             	shr    $0x4,%eax
  1062d2:	09 d8                	or     %ebx,%eax
  1062d4:	c1 e8 08             	shr    $0x8,%eax
  1062d7:	89 ce                	mov    %ecx,%esi
  1062d9:	09 c6                	or     %eax,%esi
  1062db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062de:	d1 e8                	shr    %eax
  1062e0:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1062e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1062e6:	d1 ea                	shr    %edx
  1062e8:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1062eb:	c1 ea 02             	shr    $0x2,%edx
  1062ee:	09 d0                	or     %edx,%eax
  1062f0:	89 c1                	mov    %eax,%ecx
  1062f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062f5:	d1 e8                	shr    %eax
  1062f7:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1062fa:	89 c2                	mov    %eax,%edx
  1062fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062ff:	d1 e8                	shr    %eax
  106301:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106304:	c1 e8 02             	shr    $0x2,%eax
  106307:	09 d0                	or     %edx,%eax
  106309:	c1 e8 04             	shr    $0x4,%eax
  10630c:	89 cb                	mov    %ecx,%ebx
  10630e:	09 c3                	or     %eax,%ebx
  106310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106313:	d1 e8                	shr    %eax
  106315:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106318:	89 c2                	mov    %eax,%edx
  10631a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10631d:	d1 e8                	shr    %eax
  10631f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106322:	c1 e8 02             	shr    $0x2,%eax
  106325:	89 d1                	mov    %edx,%ecx
  106327:	09 c1                	or     %eax,%ecx
  106329:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10632c:	d1 e8                	shr    %eax
  10632e:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106331:	89 c2                	mov    %eax,%edx
  106333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106336:	d1 e8                	shr    %eax
  106338:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10633b:	c1 e8 02             	shr    $0x2,%eax
  10633e:	09 d0                	or     %edx,%eax
  106340:	c1 e8 04             	shr    $0x4,%eax
  106343:	09 c8                	or     %ecx,%eax
  106345:	c1 e8 08             	shr    $0x8,%eax
  106348:	09 d8                	or     %ebx,%eax
  10634a:	c1 e8 10             	shr    $0x10,%eax
  10634d:	09 f0                	or     %esi,%eax
  10634f:	d1 e8                	shr    %eax
  106351:	f7 d0                	not    %eax
  106353:	23 45 e4             	and    -0x1c(%ebp),%eax
  106356:	89 c6                	mov    %eax,%esi
  106358:	eb 03                	jmp    10635d <buddy_alloc_pages+0x10c8>
  10635a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  10635d:	89 f8                	mov    %edi,%eax
  10635f:	ba 00 00 00 00       	mov    $0x0,%edx
  106364:	f7 f6                	div    %esi
  106366:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  10636c:	0f af d0             	imul   %eax,%edx
  10636f:	89 d0                	mov    %edx,%eax
  106371:	c1 e0 02             	shl    $0x2,%eax
  106374:	01 d0                	add    %edx,%eax
  106376:	c1 e0 02             	shl    $0x2,%eax
  106379:	03 85 74 ff ff ff    	add    -0x8c(%ebp),%eax
  10637f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    list_del(&(page->page_link));
  106382:	8b 45 c8             	mov    -0x38(%ebp),%eax
  106385:	83 c0 0c             	add    $0xc,%eax
  106388:	89 45 80             	mov    %eax,-0x80(%ebp)
    __list_del(listelm->prev, listelm->next);
  10638b:	8b 45 80             	mov    -0x80(%ebp),%eax
  10638e:	8b 40 04             	mov    0x4(%eax),%eax
  106391:	8b 55 80             	mov    -0x80(%ebp),%edx
  106394:	8b 12                	mov    (%edx),%edx
  106396:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  10639c:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    prev->next = next;
  1063a2:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1063a8:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  1063ae:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1063b1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  1063b7:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  1063bd:	89 10                	mov    %edx,(%eax)
    buddy_segment[block] = 0;
  1063bf:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  1063c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1063c7:	c1 e2 02             	shl    $0x2,%edx
  1063ca:	01 d0                	add    %edx,%eax
  1063cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    nr_free -= length;
  1063d2:	a1 80 e9 11 00       	mov    0x11e980,%eax
  1063d7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  1063da:	a3 80 e9 11 00       	mov    %eax,0x11e980
    // Update buddy segment
    while (block != BUDDY_ROOT) {
  1063df:	eb 37                	jmp    106418 <buddy_alloc_pages+0x1183>
        block = BUDDY_PARENT(block);
  1063e1:	d1 6d e4             	shrl   -0x1c(%ebp)
        buddy_segment[block] = buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)];
  1063e4:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  1063e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1063ec:	c1 e2 02             	shl    $0x2,%edx
  1063ef:	01 d0                	add    %edx,%eax
  1063f1:	8b 15 5c e9 11 00    	mov    0x11e95c,%edx
  1063f7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1063fa:	c1 e1 03             	shl    $0x3,%ecx
  1063fd:	01 ca                	add    %ecx,%edx
  1063ff:	8b 0a                	mov    (%edx),%ecx
  106401:	8b 15 5c e9 11 00    	mov    0x11e95c,%edx
  106407:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  10640a:	c1 e3 03             	shl    $0x3,%ebx
  10640d:	83 c3 04             	add    $0x4,%ebx
  106410:	01 da                	add    %ebx,%edx
  106412:	8b 12                	mov    (%edx),%edx
  106414:	09 ca                	or     %ecx,%edx
  106416:	89 10                	mov    %edx,(%eax)
    while (block != BUDDY_ROOT) {
  106418:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  10641c:	75 c3                	jne    1063e1 <buddy_alloc_pages+0x114c>
    }
    return page;
  10641e:	8b 45 c8             	mov    -0x38(%ebp),%eax
}
  106421:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  106427:	5b                   	pop    %ebx
  106428:	5e                   	pop    %esi
  106429:	5f                   	pop    %edi
  10642a:	5d                   	pop    %ebp
  10642b:	c3                   	ret    

0010642c <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
  10642c:	55                   	push   %ebp
  10642d:	89 e5                	mov    %esp,%ebp
  10642f:	57                   	push   %edi
  106430:	56                   	push   %esi
  106431:	53                   	push   %ebx
  106432:	81 ec ac 00 00 00    	sub    $0xac,%esp
    assert(n > 0);
  106438:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10643c:	75 24                	jne    106462 <buddy_free_pages+0x36>
  10643e:	c7 44 24 0c df ab 10 	movl   $0x10abdf,0xc(%esp)
  106445:	00 
  106446:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  10644d:	00 
  10644e:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  106455:	00 
  106456:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  10645d:	e8 86 9f ff ff       	call   1003e8 <__panic>
    struct Page *p = base;
  106462:	8b 45 08             	mov    0x8(%ebp),%eax
  106465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    size_t length = UINT32_ROUND_UP(n);
  106468:	8b 45 0c             	mov    0xc(%ebp),%eax
  10646b:	d1 e8                	shr    %eax
  10646d:	0b 45 0c             	or     0xc(%ebp),%eax
  106470:	8b 55 0c             	mov    0xc(%ebp),%edx
  106473:	d1 ea                	shr    %edx
  106475:	0b 55 0c             	or     0xc(%ebp),%edx
  106478:	c1 ea 02             	shr    $0x2,%edx
  10647b:	09 d0                	or     %edx,%eax
  10647d:	89 c1                	mov    %eax,%ecx
  10647f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106482:	d1 e8                	shr    %eax
  106484:	0b 45 0c             	or     0xc(%ebp),%eax
  106487:	8b 55 0c             	mov    0xc(%ebp),%edx
  10648a:	d1 ea                	shr    %edx
  10648c:	0b 55 0c             	or     0xc(%ebp),%edx
  10648f:	c1 ea 02             	shr    $0x2,%edx
  106492:	09 d0                	or     %edx,%eax
  106494:	c1 e8 04             	shr    $0x4,%eax
  106497:	09 c1                	or     %eax,%ecx
  106499:	8b 45 0c             	mov    0xc(%ebp),%eax
  10649c:	d1 e8                	shr    %eax
  10649e:	0b 45 0c             	or     0xc(%ebp),%eax
  1064a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1064a4:	d1 ea                	shr    %edx
  1064a6:	0b 55 0c             	or     0xc(%ebp),%edx
  1064a9:	c1 ea 02             	shr    $0x2,%edx
  1064ac:	09 d0                	or     %edx,%eax
  1064ae:	89 c3                	mov    %eax,%ebx
  1064b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064b3:	d1 e8                	shr    %eax
  1064b5:	0b 45 0c             	or     0xc(%ebp),%eax
  1064b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1064bb:	d1 ea                	shr    %edx
  1064bd:	0b 55 0c             	or     0xc(%ebp),%edx
  1064c0:	c1 ea 02             	shr    $0x2,%edx
  1064c3:	09 d0                	or     %edx,%eax
  1064c5:	c1 e8 04             	shr    $0x4,%eax
  1064c8:	09 d8                	or     %ebx,%eax
  1064ca:	c1 e8 08             	shr    $0x8,%eax
  1064cd:	09 c1                	or     %eax,%ecx
  1064cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064d2:	d1 e8                	shr    %eax
  1064d4:	0b 45 0c             	or     0xc(%ebp),%eax
  1064d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1064da:	d1 ea                	shr    %edx
  1064dc:	0b 55 0c             	or     0xc(%ebp),%edx
  1064df:	c1 ea 02             	shr    $0x2,%edx
  1064e2:	09 d0                	or     %edx,%eax
  1064e4:	89 c3                	mov    %eax,%ebx
  1064e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064e9:	d1 e8                	shr    %eax
  1064eb:	0b 45 0c             	or     0xc(%ebp),%eax
  1064ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  1064f1:	d1 ea                	shr    %edx
  1064f3:	0b 55 0c             	or     0xc(%ebp),%edx
  1064f6:	c1 ea 02             	shr    $0x2,%edx
  1064f9:	09 d0                	or     %edx,%eax
  1064fb:	c1 e8 04             	shr    $0x4,%eax
  1064fe:	09 c3                	or     %eax,%ebx
  106500:	8b 45 0c             	mov    0xc(%ebp),%eax
  106503:	d1 e8                	shr    %eax
  106505:	0b 45 0c             	or     0xc(%ebp),%eax
  106508:	8b 55 0c             	mov    0xc(%ebp),%edx
  10650b:	d1 ea                	shr    %edx
  10650d:	0b 55 0c             	or     0xc(%ebp),%edx
  106510:	c1 ea 02             	shr    $0x2,%edx
  106513:	09 d0                	or     %edx,%eax
  106515:	89 c6                	mov    %eax,%esi
  106517:	8b 45 0c             	mov    0xc(%ebp),%eax
  10651a:	d1 e8                	shr    %eax
  10651c:	0b 45 0c             	or     0xc(%ebp),%eax
  10651f:	8b 55 0c             	mov    0xc(%ebp),%edx
  106522:	d1 ea                	shr    %edx
  106524:	0b 55 0c             	or     0xc(%ebp),%edx
  106527:	c1 ea 02             	shr    $0x2,%edx
  10652a:	09 d0                	or     %edx,%eax
  10652c:	c1 e8 04             	shr    $0x4,%eax
  10652f:	09 f0                	or     %esi,%eax
  106531:	c1 e8 08             	shr    $0x8,%eax
  106534:	09 d8                	or     %ebx,%eax
  106536:	c1 e8 10             	shr    $0x10,%eax
  106539:	09 c8                	or     %ecx,%eax
  10653b:	d1 e8                	shr    %eax
  10653d:	23 45 0c             	and    0xc(%ebp),%eax
  106540:	85 c0                	test   %eax,%eax
  106542:	0f 84 de 00 00 00    	je     106626 <buddy_free_pages+0x1fa>
  106548:	8b 45 0c             	mov    0xc(%ebp),%eax
  10654b:	d1 e8                	shr    %eax
  10654d:	0b 45 0c             	or     0xc(%ebp),%eax
  106550:	8b 55 0c             	mov    0xc(%ebp),%edx
  106553:	d1 ea                	shr    %edx
  106555:	0b 55 0c             	or     0xc(%ebp),%edx
  106558:	c1 ea 02             	shr    $0x2,%edx
  10655b:	09 d0                	or     %edx,%eax
  10655d:	89 c1                	mov    %eax,%ecx
  10655f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106562:	d1 e8                	shr    %eax
  106564:	0b 45 0c             	or     0xc(%ebp),%eax
  106567:	8b 55 0c             	mov    0xc(%ebp),%edx
  10656a:	d1 ea                	shr    %edx
  10656c:	0b 55 0c             	or     0xc(%ebp),%edx
  10656f:	c1 ea 02             	shr    $0x2,%edx
  106572:	09 d0                	or     %edx,%eax
  106574:	c1 e8 04             	shr    $0x4,%eax
  106577:	09 c1                	or     %eax,%ecx
  106579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10657c:	d1 e8                	shr    %eax
  10657e:	0b 45 0c             	or     0xc(%ebp),%eax
  106581:	8b 55 0c             	mov    0xc(%ebp),%edx
  106584:	d1 ea                	shr    %edx
  106586:	0b 55 0c             	or     0xc(%ebp),%edx
  106589:	c1 ea 02             	shr    $0x2,%edx
  10658c:	09 d0                	or     %edx,%eax
  10658e:	89 c3                	mov    %eax,%ebx
  106590:	8b 45 0c             	mov    0xc(%ebp),%eax
  106593:	d1 e8                	shr    %eax
  106595:	0b 45 0c             	or     0xc(%ebp),%eax
  106598:	8b 55 0c             	mov    0xc(%ebp),%edx
  10659b:	d1 ea                	shr    %edx
  10659d:	0b 55 0c             	or     0xc(%ebp),%edx
  1065a0:	c1 ea 02             	shr    $0x2,%edx
  1065a3:	09 d0                	or     %edx,%eax
  1065a5:	c1 e8 04             	shr    $0x4,%eax
  1065a8:	09 d8                	or     %ebx,%eax
  1065aa:	c1 e8 08             	shr    $0x8,%eax
  1065ad:	09 c1                	or     %eax,%ecx
  1065af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065b2:	d1 e8                	shr    %eax
  1065b4:	0b 45 0c             	or     0xc(%ebp),%eax
  1065b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1065ba:	d1 ea                	shr    %edx
  1065bc:	0b 55 0c             	or     0xc(%ebp),%edx
  1065bf:	c1 ea 02             	shr    $0x2,%edx
  1065c2:	09 d0                	or     %edx,%eax
  1065c4:	89 c3                	mov    %eax,%ebx
  1065c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065c9:	d1 e8                	shr    %eax
  1065cb:	0b 45 0c             	or     0xc(%ebp),%eax
  1065ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  1065d1:	d1 ea                	shr    %edx
  1065d3:	0b 55 0c             	or     0xc(%ebp),%edx
  1065d6:	c1 ea 02             	shr    $0x2,%edx
  1065d9:	09 d0                	or     %edx,%eax
  1065db:	c1 e8 04             	shr    $0x4,%eax
  1065de:	09 c3                	or     %eax,%ebx
  1065e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065e3:	d1 e8                	shr    %eax
  1065e5:	0b 45 0c             	or     0xc(%ebp),%eax
  1065e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1065eb:	d1 ea                	shr    %edx
  1065ed:	0b 55 0c             	or     0xc(%ebp),%edx
  1065f0:	c1 ea 02             	shr    $0x2,%edx
  1065f3:	09 d0                	or     %edx,%eax
  1065f5:	89 c6                	mov    %eax,%esi
  1065f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065fa:	d1 e8                	shr    %eax
  1065fc:	0b 45 0c             	or     0xc(%ebp),%eax
  1065ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  106602:	d1 ea                	shr    %edx
  106604:	0b 55 0c             	or     0xc(%ebp),%edx
  106607:	c1 ea 02             	shr    $0x2,%edx
  10660a:	09 d0                	or     %edx,%eax
  10660c:	c1 e8 04             	shr    $0x4,%eax
  10660f:	09 f0                	or     %esi,%eax
  106611:	c1 e8 08             	shr    $0x8,%eax
  106614:	09 d8                	or     %ebx,%eax
  106616:	c1 e8 10             	shr    $0x10,%eax
  106619:	09 c8                	or     %ecx,%eax
  10661b:	d1 e8                	shr    %eax
  10661d:	f7 d0                	not    %eax
  10661f:	23 45 0c             	and    0xc(%ebp),%eax
  106622:	01 c0                	add    %eax,%eax
  106624:	eb 03                	jmp    106629 <buddy_free_pages+0x1fd>
  106626:	8b 45 0c             	mov    0xc(%ebp),%eax
  106629:	89 45 dc             	mov    %eax,-0x24(%ebp)
    // Find buddy id 
    size_t begin = (base-buddy_alloc);
  10662c:	8b 55 08             	mov    0x8(%ebp),%edx
  10662f:	a1 64 e9 11 00       	mov    0x11e964,%eax
  106634:	29 c2                	sub    %eax,%edx
  106636:	89 d0                	mov    %edx,%eax
  106638:	c1 f8 02             	sar    $0x2,%eax
  10663b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
  106641:	89 45 d8             	mov    %eax,-0x28(%ebp)
    size_t end = begin + length;
  106644:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106647:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10664a:	01 d0                	add    %edx,%eax
  10664c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    size_t block = BUDDY_BLOCK(begin, end);
  10664f:	a1 50 e9 11 00       	mov    0x11e950,%eax
  106654:	8b 55 d8             	mov    -0x28(%ebp),%edx
  106657:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10665a:	29 d1                	sub    %edx,%ecx
  10665c:	89 cf                	mov    %ecx,%edi
  10665e:	ba 00 00 00 00       	mov    $0x0,%edx
  106663:	f7 f7                	div    %edi
  106665:	89 c1                	mov    %eax,%ecx
  106667:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10666a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10666d:	89 d7                	mov    %edx,%edi
  10666f:	29 c7                	sub    %eax,%edi
  106671:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106674:	ba 00 00 00 00       	mov    $0x0,%edx
  106679:	f7 f7                	div    %edi
  10667b:	01 c8                	add    %ecx,%eax
  10667d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // Release block
    for (; p != base + n; p ++) {
  106680:	eb 71                	jmp    1066f3 <buddy_free_pages+0x2c7>
        assert(!PageReserved(p));
  106682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106685:	83 c0 04             	add    $0x4,%eax
  106688:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  10668f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  106692:	8b 45 bc             	mov    -0x44(%ebp),%eax
  106695:	8b 55 c0             	mov    -0x40(%ebp),%edx
  106698:	0f a3 10             	bt     %edx,(%eax)
  10669b:	19 c0                	sbb    %eax,%eax
  10669d:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1066a0:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1066a4:	0f 95 c0             	setne  %al
  1066a7:	0f b6 c0             	movzbl %al,%eax
  1066aa:	85 c0                	test   %eax,%eax
  1066ac:	74 24                	je     1066d2 <buddy_free_pages+0x2a6>
  1066ae:	c7 44 24 0c f7 ab 10 	movl   $0x10abf7,0xc(%esp)
  1066b5:	00 
  1066b6:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  1066bd:	00 
  1066be:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  1066c5:	00 
  1066c6:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  1066cd:	e8 16 9d ff ff       	call   1003e8 <__panic>
        p->flags = 0;
  1066d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1066d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1066dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1066e3:	00 
  1066e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1066e7:	89 04 24             	mov    %eax,(%esp)
  1066ea:	e8 4e dd ff ff       	call   10443d <set_page_ref>
    for (; p != base + n; p ++) {
  1066ef:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
  1066f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1066f6:	89 d0                	mov    %edx,%eax
  1066f8:	c1 e0 02             	shl    $0x2,%eax
  1066fb:	01 d0                	add    %edx,%eax
  1066fd:	c1 e0 02             	shl    $0x2,%eax
  106700:	89 c2                	mov    %eax,%edx
  106702:	8b 45 08             	mov    0x8(%ebp),%eax
  106705:	01 d0                	add    %edx,%eax
  106707:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  10670a:	0f 85 72 ff ff ff    	jne    106682 <buddy_free_pages+0x256>
    }
    base->property = length;
  106710:	8b 45 08             	mov    0x8(%ebp),%eax
  106713:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106716:	89 50 08             	mov    %edx,0x8(%eax)
    list_add(&(free_list), &(base->page_link));
  106719:	8b 45 08             	mov    0x8(%ebp),%eax
  10671c:	83 c0 0c             	add    $0xc,%eax
  10671f:	c7 45 b4 78 e9 11 00 	movl   $0x11e978,-0x4c(%ebp)
  106726:	89 45 b0             	mov    %eax,-0x50(%ebp)
  106729:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10672c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  10672f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  106732:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_add(elm, listelm, listelm->next);
  106735:	8b 45 ac             	mov    -0x54(%ebp),%eax
  106738:	8b 40 04             	mov    0x4(%eax),%eax
  10673b:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10673e:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  106741:	8b 55 ac             	mov    -0x54(%ebp),%edx
  106744:	89 55 a0             	mov    %edx,-0x60(%ebp)
  106747:	89 45 9c             	mov    %eax,-0x64(%ebp)
    prev->next = next->prev = elm;
  10674a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10674d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  106750:	89 10                	mov    %edx,(%eax)
  106752:	8b 45 9c             	mov    -0x64(%ebp),%eax
  106755:	8b 10                	mov    (%eax),%edx
  106757:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10675a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10675d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  106760:	8b 55 9c             	mov    -0x64(%ebp),%edx
  106763:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  106766:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  106769:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10676c:	89 10                	mov    %edx,(%eax)
    nr_free += length;
  10676e:	8b 15 80 e9 11 00    	mov    0x11e980,%edx
  106774:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106777:	01 d0                	add    %edx,%eax
  106779:	a3 80 e9 11 00       	mov    %eax,0x11e980
    buddy_segment[block] = length;
  10677e:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  106783:	8b 55 e0             	mov    -0x20(%ebp),%edx
  106786:	c1 e2 02             	shl    $0x2,%edx
  106789:	01 c2                	add    %eax,%edx
  10678b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10678e:	89 02                	mov    %eax,(%edx)
    // Upadte & merge
    while (block != BUDDY_ROOT) {
  106790:	e9 20 0b 00 00       	jmp    1072b5 <buddy_free_pages+0xe89>
        block = BUDDY_PARENT(block);
  106795:	d1 6d e0             	shrl   -0x20(%ebp)
        size_t left = BUDDY_LEFT(block);
  106798:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10679b:	01 c0                	add    %eax,%eax
  10679d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        size_t right = BUDDY_RIGHT(block);
  1067a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1067a3:	01 c0                	add    %eax,%eax
  1067a5:	83 c0 01             	add    $0x1,%eax
  1067a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right)) {  // Merge
  1067ab:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  1067b0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1067b3:	c1 e2 02             	shl    $0x2,%edx
  1067b6:	01 d0                	add    %edx,%eax
  1067b8:	8b 00                	mov    (%eax),%eax
  1067ba:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  1067c0:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  1067c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1067c9:	d1 e8                	shr    %eax
  1067cb:	0b 45 d0             	or     -0x30(%ebp),%eax
  1067ce:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1067d1:	d1 ea                	shr    %edx
  1067d3:	0b 55 d0             	or     -0x30(%ebp),%edx
  1067d6:	c1 ea 02             	shr    $0x2,%edx
  1067d9:	09 d0                	or     %edx,%eax
  1067db:	89 c1                	mov    %eax,%ecx
  1067dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1067e0:	d1 e8                	shr    %eax
  1067e2:	0b 45 d0             	or     -0x30(%ebp),%eax
  1067e5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1067e8:	d1 ea                	shr    %edx
  1067ea:	0b 55 d0             	or     -0x30(%ebp),%edx
  1067ed:	c1 ea 02             	shr    $0x2,%edx
  1067f0:	09 d0                	or     %edx,%eax
  1067f2:	c1 e8 04             	shr    $0x4,%eax
  1067f5:	09 c1                	or     %eax,%ecx
  1067f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1067fa:	d1 e8                	shr    %eax
  1067fc:	0b 45 d0             	or     -0x30(%ebp),%eax
  1067ff:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106802:	d1 ea                	shr    %edx
  106804:	0b 55 d0             	or     -0x30(%ebp),%edx
  106807:	c1 ea 02             	shr    $0x2,%edx
  10680a:	09 d0                	or     %edx,%eax
  10680c:	89 c3                	mov    %eax,%ebx
  10680e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106811:	d1 e8                	shr    %eax
  106813:	0b 45 d0             	or     -0x30(%ebp),%eax
  106816:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106819:	d1 ea                	shr    %edx
  10681b:	0b 55 d0             	or     -0x30(%ebp),%edx
  10681e:	c1 ea 02             	shr    $0x2,%edx
  106821:	09 d0                	or     %edx,%eax
  106823:	c1 e8 04             	shr    $0x4,%eax
  106826:	09 d8                	or     %ebx,%eax
  106828:	c1 e8 08             	shr    $0x8,%eax
  10682b:	89 cb                	mov    %ecx,%ebx
  10682d:	09 c3                	or     %eax,%ebx
  10682f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106832:	d1 e8                	shr    %eax
  106834:	0b 45 d0             	or     -0x30(%ebp),%eax
  106837:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10683a:	d1 ea                	shr    %edx
  10683c:	0b 55 d0             	or     -0x30(%ebp),%edx
  10683f:	c1 ea 02             	shr    $0x2,%edx
  106842:	09 d0                	or     %edx,%eax
  106844:	89 c1                	mov    %eax,%ecx
  106846:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106849:	d1 e8                	shr    %eax
  10684b:	0b 45 d0             	or     -0x30(%ebp),%eax
  10684e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106851:	d1 ea                	shr    %edx
  106853:	0b 55 d0             	or     -0x30(%ebp),%edx
  106856:	c1 ea 02             	shr    $0x2,%edx
  106859:	09 d0                	or     %edx,%eax
  10685b:	c1 e8 04             	shr    $0x4,%eax
  10685e:	09 c1                	or     %eax,%ecx
  106860:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106863:	d1 e8                	shr    %eax
  106865:	0b 45 d0             	or     -0x30(%ebp),%eax
  106868:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10686b:	d1 ea                	shr    %edx
  10686d:	0b 55 d0             	or     -0x30(%ebp),%edx
  106870:	c1 ea 02             	shr    $0x2,%edx
  106873:	09 d0                	or     %edx,%eax
  106875:	89 c6                	mov    %eax,%esi
  106877:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10687a:	d1 e8                	shr    %eax
  10687c:	0b 45 d0             	or     -0x30(%ebp),%eax
  10687f:	89 c2                	mov    %eax,%edx
  106881:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106884:	d1 e8                	shr    %eax
  106886:	0b 45 d0             	or     -0x30(%ebp),%eax
  106889:	c1 e8 02             	shr    $0x2,%eax
  10688c:	09 d0                	or     %edx,%eax
  10688e:	c1 e8 04             	shr    $0x4,%eax
  106891:	09 f0                	or     %esi,%eax
  106893:	c1 e8 08             	shr    $0x8,%eax
  106896:	09 c8                	or     %ecx,%eax
  106898:	c1 e8 10             	shr    $0x10,%eax
  10689b:	09 d8                	or     %ebx,%eax
  10689d:	d1 e8                	shr    %eax
  10689f:	23 45 d0             	and    -0x30(%ebp),%eax
  1068a2:	85 c0                	test   %eax,%eax
  1068a4:	0f 84 e2 00 00 00    	je     10698c <buddy_free_pages+0x560>
  1068aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1068ad:	d1 e8                	shr    %eax
  1068af:	0b 45 d0             	or     -0x30(%ebp),%eax
  1068b2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1068b5:	d1 ea                	shr    %edx
  1068b7:	0b 55 d0             	or     -0x30(%ebp),%edx
  1068ba:	c1 ea 02             	shr    $0x2,%edx
  1068bd:	09 d0                	or     %edx,%eax
  1068bf:	89 c1                	mov    %eax,%ecx
  1068c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1068c4:	d1 e8                	shr    %eax
  1068c6:	0b 45 d0             	or     -0x30(%ebp),%eax
  1068c9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1068cc:	d1 ea                	shr    %edx
  1068ce:	0b 55 d0             	or     -0x30(%ebp),%edx
  1068d1:	c1 ea 02             	shr    $0x2,%edx
  1068d4:	09 d0                	or     %edx,%eax
  1068d6:	c1 e8 04             	shr    $0x4,%eax
  1068d9:	09 c1                	or     %eax,%ecx
  1068db:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1068de:	d1 e8                	shr    %eax
  1068e0:	0b 45 d0             	or     -0x30(%ebp),%eax
  1068e3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1068e6:	d1 ea                	shr    %edx
  1068e8:	0b 55 d0             	or     -0x30(%ebp),%edx
  1068eb:	c1 ea 02             	shr    $0x2,%edx
  1068ee:	09 d0                	or     %edx,%eax
  1068f0:	89 c3                	mov    %eax,%ebx
  1068f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1068f5:	d1 e8                	shr    %eax
  1068f7:	0b 45 d0             	or     -0x30(%ebp),%eax
  1068fa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1068fd:	d1 ea                	shr    %edx
  1068ff:	0b 55 d0             	or     -0x30(%ebp),%edx
  106902:	c1 ea 02             	shr    $0x2,%edx
  106905:	09 d0                	or     %edx,%eax
  106907:	c1 e8 04             	shr    $0x4,%eax
  10690a:	09 d8                	or     %ebx,%eax
  10690c:	c1 e8 08             	shr    $0x8,%eax
  10690f:	89 cb                	mov    %ecx,%ebx
  106911:	09 c3                	or     %eax,%ebx
  106913:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106916:	d1 e8                	shr    %eax
  106918:	0b 45 d0             	or     -0x30(%ebp),%eax
  10691b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10691e:	d1 ea                	shr    %edx
  106920:	0b 55 d0             	or     -0x30(%ebp),%edx
  106923:	c1 ea 02             	shr    $0x2,%edx
  106926:	09 d0                	or     %edx,%eax
  106928:	89 c1                	mov    %eax,%ecx
  10692a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10692d:	d1 e8                	shr    %eax
  10692f:	0b 45 d0             	or     -0x30(%ebp),%eax
  106932:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106935:	d1 ea                	shr    %edx
  106937:	0b 55 d0             	or     -0x30(%ebp),%edx
  10693a:	c1 ea 02             	shr    $0x2,%edx
  10693d:	09 d0                	or     %edx,%eax
  10693f:	c1 e8 04             	shr    $0x4,%eax
  106942:	09 c1                	or     %eax,%ecx
  106944:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106947:	d1 e8                	shr    %eax
  106949:	0b 45 d0             	or     -0x30(%ebp),%eax
  10694c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10694f:	d1 ea                	shr    %edx
  106951:	0b 55 d0             	or     -0x30(%ebp),%edx
  106954:	c1 ea 02             	shr    $0x2,%edx
  106957:	09 d0                	or     %edx,%eax
  106959:	89 c6                	mov    %eax,%esi
  10695b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10695e:	d1 e8                	shr    %eax
  106960:	0b 45 d0             	or     -0x30(%ebp),%eax
  106963:	89 c2                	mov    %eax,%edx
  106965:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106968:	d1 e8                	shr    %eax
  10696a:	0b 45 d0             	or     -0x30(%ebp),%eax
  10696d:	c1 e8 02             	shr    $0x2,%eax
  106970:	09 d0                	or     %edx,%eax
  106972:	c1 e8 04             	shr    $0x4,%eax
  106975:	09 f0                	or     %esi,%eax
  106977:	c1 e8 08             	shr    $0x8,%eax
  10697a:	09 c8                	or     %ecx,%eax
  10697c:	c1 e8 10             	shr    $0x10,%eax
  10697f:	09 d8                	or     %ebx,%eax
  106981:	d1 e8                	shr    %eax
  106983:	f7 d0                	not    %eax
  106985:	23 45 d0             	and    -0x30(%ebp),%eax
  106988:	89 c6                	mov    %eax,%esi
  10698a:	eb 03                	jmp    10698f <buddy_free_pages+0x563>
  10698c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  10698f:	89 f8                	mov    %edi,%eax
  106991:	ba 00 00 00 00       	mov    $0x0,%edx
  106996:	f7 f6                	div    %esi
  106998:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%ebp)
  10699e:	0f 85 dd 08 00 00    	jne    107281 <buddy_free_pages+0xe55>
  1069a4:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  1069a9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1069ac:	c1 e2 02             	shl    $0x2,%edx
  1069af:	01 d0                	add    %edx,%eax
  1069b1:	8b 00                	mov    (%eax),%eax
  1069b3:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  1069b9:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  1069bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1069c2:	d1 e8                	shr    %eax
  1069c4:	0b 45 cc             	or     -0x34(%ebp),%eax
  1069c7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1069ca:	d1 ea                	shr    %edx
  1069cc:	0b 55 cc             	or     -0x34(%ebp),%edx
  1069cf:	c1 ea 02             	shr    $0x2,%edx
  1069d2:	09 d0                	or     %edx,%eax
  1069d4:	89 c1                	mov    %eax,%ecx
  1069d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1069d9:	d1 e8                	shr    %eax
  1069db:	0b 45 cc             	or     -0x34(%ebp),%eax
  1069de:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1069e1:	d1 ea                	shr    %edx
  1069e3:	0b 55 cc             	or     -0x34(%ebp),%edx
  1069e6:	c1 ea 02             	shr    $0x2,%edx
  1069e9:	09 d0                	or     %edx,%eax
  1069eb:	c1 e8 04             	shr    $0x4,%eax
  1069ee:	09 c1                	or     %eax,%ecx
  1069f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1069f3:	d1 e8                	shr    %eax
  1069f5:	0b 45 cc             	or     -0x34(%ebp),%eax
  1069f8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1069fb:	d1 ea                	shr    %edx
  1069fd:	0b 55 cc             	or     -0x34(%ebp),%edx
  106a00:	c1 ea 02             	shr    $0x2,%edx
  106a03:	09 d0                	or     %edx,%eax
  106a05:	89 c3                	mov    %eax,%ebx
  106a07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106a0a:	d1 e8                	shr    %eax
  106a0c:	0b 45 cc             	or     -0x34(%ebp),%eax
  106a0f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106a12:	d1 ea                	shr    %edx
  106a14:	0b 55 cc             	or     -0x34(%ebp),%edx
  106a17:	c1 ea 02             	shr    $0x2,%edx
  106a1a:	09 d0                	or     %edx,%eax
  106a1c:	c1 e8 04             	shr    $0x4,%eax
  106a1f:	09 d8                	or     %ebx,%eax
  106a21:	c1 e8 08             	shr    $0x8,%eax
  106a24:	89 cb                	mov    %ecx,%ebx
  106a26:	09 c3                	or     %eax,%ebx
  106a28:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106a2b:	d1 e8                	shr    %eax
  106a2d:	0b 45 cc             	or     -0x34(%ebp),%eax
  106a30:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106a33:	d1 ea                	shr    %edx
  106a35:	0b 55 cc             	or     -0x34(%ebp),%edx
  106a38:	c1 ea 02             	shr    $0x2,%edx
  106a3b:	09 d0                	or     %edx,%eax
  106a3d:	89 c1                	mov    %eax,%ecx
  106a3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106a42:	d1 e8                	shr    %eax
  106a44:	0b 45 cc             	or     -0x34(%ebp),%eax
  106a47:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106a4a:	d1 ea                	shr    %edx
  106a4c:	0b 55 cc             	or     -0x34(%ebp),%edx
  106a4f:	c1 ea 02             	shr    $0x2,%edx
  106a52:	09 d0                	or     %edx,%eax
  106a54:	c1 e8 04             	shr    $0x4,%eax
  106a57:	09 c1                	or     %eax,%ecx
  106a59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106a5c:	d1 e8                	shr    %eax
  106a5e:	0b 45 cc             	or     -0x34(%ebp),%eax
  106a61:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106a64:	d1 ea                	shr    %edx
  106a66:	0b 55 cc             	or     -0x34(%ebp),%edx
  106a69:	c1 ea 02             	shr    $0x2,%edx
  106a6c:	09 d0                	or     %edx,%eax
  106a6e:	89 c6                	mov    %eax,%esi
  106a70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106a73:	d1 e8                	shr    %eax
  106a75:	0b 45 cc             	or     -0x34(%ebp),%eax
  106a78:	89 c2                	mov    %eax,%edx
  106a7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106a7d:	d1 e8                	shr    %eax
  106a7f:	0b 45 cc             	or     -0x34(%ebp),%eax
  106a82:	c1 e8 02             	shr    $0x2,%eax
  106a85:	09 d0                	or     %edx,%eax
  106a87:	c1 e8 04             	shr    $0x4,%eax
  106a8a:	09 f0                	or     %esi,%eax
  106a8c:	c1 e8 08             	shr    $0x8,%eax
  106a8f:	09 c8                	or     %ecx,%eax
  106a91:	c1 e8 10             	shr    $0x10,%eax
  106a94:	09 d8                	or     %ebx,%eax
  106a96:	d1 e8                	shr    %eax
  106a98:	23 45 cc             	and    -0x34(%ebp),%eax
  106a9b:	85 c0                	test   %eax,%eax
  106a9d:	0f 84 e2 00 00 00    	je     106b85 <buddy_free_pages+0x759>
  106aa3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106aa6:	d1 e8                	shr    %eax
  106aa8:	0b 45 cc             	or     -0x34(%ebp),%eax
  106aab:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106aae:	d1 ea                	shr    %edx
  106ab0:	0b 55 cc             	or     -0x34(%ebp),%edx
  106ab3:	c1 ea 02             	shr    $0x2,%edx
  106ab6:	09 d0                	or     %edx,%eax
  106ab8:	89 c1                	mov    %eax,%ecx
  106aba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106abd:	d1 e8                	shr    %eax
  106abf:	0b 45 cc             	or     -0x34(%ebp),%eax
  106ac2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106ac5:	d1 ea                	shr    %edx
  106ac7:	0b 55 cc             	or     -0x34(%ebp),%edx
  106aca:	c1 ea 02             	shr    $0x2,%edx
  106acd:	09 d0                	or     %edx,%eax
  106acf:	c1 e8 04             	shr    $0x4,%eax
  106ad2:	09 c1                	or     %eax,%ecx
  106ad4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106ad7:	d1 e8                	shr    %eax
  106ad9:	0b 45 cc             	or     -0x34(%ebp),%eax
  106adc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106adf:	d1 ea                	shr    %edx
  106ae1:	0b 55 cc             	or     -0x34(%ebp),%edx
  106ae4:	c1 ea 02             	shr    $0x2,%edx
  106ae7:	09 d0                	or     %edx,%eax
  106ae9:	89 c3                	mov    %eax,%ebx
  106aeb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106aee:	d1 e8                	shr    %eax
  106af0:	0b 45 cc             	or     -0x34(%ebp),%eax
  106af3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106af6:	d1 ea                	shr    %edx
  106af8:	0b 55 cc             	or     -0x34(%ebp),%edx
  106afb:	c1 ea 02             	shr    $0x2,%edx
  106afe:	09 d0                	or     %edx,%eax
  106b00:	c1 e8 04             	shr    $0x4,%eax
  106b03:	09 d8                	or     %ebx,%eax
  106b05:	c1 e8 08             	shr    $0x8,%eax
  106b08:	89 cb                	mov    %ecx,%ebx
  106b0a:	09 c3                	or     %eax,%ebx
  106b0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106b0f:	d1 e8                	shr    %eax
  106b11:	0b 45 cc             	or     -0x34(%ebp),%eax
  106b14:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106b17:	d1 ea                	shr    %edx
  106b19:	0b 55 cc             	or     -0x34(%ebp),%edx
  106b1c:	c1 ea 02             	shr    $0x2,%edx
  106b1f:	09 d0                	or     %edx,%eax
  106b21:	89 c1                	mov    %eax,%ecx
  106b23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106b26:	d1 e8                	shr    %eax
  106b28:	0b 45 cc             	or     -0x34(%ebp),%eax
  106b2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106b2e:	d1 ea                	shr    %edx
  106b30:	0b 55 cc             	or     -0x34(%ebp),%edx
  106b33:	c1 ea 02             	shr    $0x2,%edx
  106b36:	09 d0                	or     %edx,%eax
  106b38:	c1 e8 04             	shr    $0x4,%eax
  106b3b:	09 c1                	or     %eax,%ecx
  106b3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106b40:	d1 e8                	shr    %eax
  106b42:	0b 45 cc             	or     -0x34(%ebp),%eax
  106b45:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106b48:	d1 ea                	shr    %edx
  106b4a:	0b 55 cc             	or     -0x34(%ebp),%edx
  106b4d:	c1 ea 02             	shr    $0x2,%edx
  106b50:	09 d0                	or     %edx,%eax
  106b52:	89 c6                	mov    %eax,%esi
  106b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106b57:	d1 e8                	shr    %eax
  106b59:	0b 45 cc             	or     -0x34(%ebp),%eax
  106b5c:	89 c2                	mov    %eax,%edx
  106b5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106b61:	d1 e8                	shr    %eax
  106b63:	0b 45 cc             	or     -0x34(%ebp),%eax
  106b66:	c1 e8 02             	shr    $0x2,%eax
  106b69:	09 d0                	or     %edx,%eax
  106b6b:	c1 e8 04             	shr    $0x4,%eax
  106b6e:	09 f0                	or     %esi,%eax
  106b70:	c1 e8 08             	shr    $0x8,%eax
  106b73:	09 c8                	or     %ecx,%eax
  106b75:	c1 e8 10             	shr    $0x10,%eax
  106b78:	09 d8                	or     %ebx,%eax
  106b7a:	d1 e8                	shr    %eax
  106b7c:	f7 d0                	not    %eax
  106b7e:	23 45 cc             	and    -0x34(%ebp),%eax
  106b81:	89 c6                	mov    %eax,%esi
  106b83:	eb 03                	jmp    106b88 <buddy_free_pages+0x75c>
  106b85:	8b 75 cc             	mov    -0x34(%ebp),%esi
  106b88:	89 f8                	mov    %edi,%eax
  106b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  106b8f:	f7 f6                	div    %esi
  106b91:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%ebp)
  106b97:	0f 85 e4 06 00 00    	jne    107281 <buddy_free_pages+0xe55>
            size_t lbegin = BUDDY_BEGIN(left);
  106b9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106ba0:	d1 e8                	shr    %eax
  106ba2:	0b 45 d0             	or     -0x30(%ebp),%eax
  106ba5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106ba8:	d1 ea                	shr    %edx
  106baa:	0b 55 d0             	or     -0x30(%ebp),%edx
  106bad:	c1 ea 02             	shr    $0x2,%edx
  106bb0:	09 d0                	or     %edx,%eax
  106bb2:	89 c1                	mov    %eax,%ecx
  106bb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106bb7:	d1 e8                	shr    %eax
  106bb9:	0b 45 d0             	or     -0x30(%ebp),%eax
  106bbc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106bbf:	d1 ea                	shr    %edx
  106bc1:	0b 55 d0             	or     -0x30(%ebp),%edx
  106bc4:	c1 ea 02             	shr    $0x2,%edx
  106bc7:	09 d0                	or     %edx,%eax
  106bc9:	c1 e8 04             	shr    $0x4,%eax
  106bcc:	09 c1                	or     %eax,%ecx
  106bce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106bd1:	d1 e8                	shr    %eax
  106bd3:	0b 45 d0             	or     -0x30(%ebp),%eax
  106bd6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106bd9:	d1 ea                	shr    %edx
  106bdb:	0b 55 d0             	or     -0x30(%ebp),%edx
  106bde:	c1 ea 02             	shr    $0x2,%edx
  106be1:	09 d0                	or     %edx,%eax
  106be3:	89 c3                	mov    %eax,%ebx
  106be5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106be8:	d1 e8                	shr    %eax
  106bea:	0b 45 d0             	or     -0x30(%ebp),%eax
  106bed:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106bf0:	d1 ea                	shr    %edx
  106bf2:	0b 55 d0             	or     -0x30(%ebp),%edx
  106bf5:	c1 ea 02             	shr    $0x2,%edx
  106bf8:	09 d0                	or     %edx,%eax
  106bfa:	c1 e8 04             	shr    $0x4,%eax
  106bfd:	09 d8                	or     %ebx,%eax
  106bff:	c1 e8 08             	shr    $0x8,%eax
  106c02:	09 c1                	or     %eax,%ecx
  106c04:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106c07:	d1 e8                	shr    %eax
  106c09:	0b 45 d0             	or     -0x30(%ebp),%eax
  106c0c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106c0f:	d1 ea                	shr    %edx
  106c11:	0b 55 d0             	or     -0x30(%ebp),%edx
  106c14:	c1 ea 02             	shr    $0x2,%edx
  106c17:	09 d0                	or     %edx,%eax
  106c19:	89 c3                	mov    %eax,%ebx
  106c1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106c1e:	d1 e8                	shr    %eax
  106c20:	0b 45 d0             	or     -0x30(%ebp),%eax
  106c23:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106c26:	d1 ea                	shr    %edx
  106c28:	0b 55 d0             	or     -0x30(%ebp),%edx
  106c2b:	c1 ea 02             	shr    $0x2,%edx
  106c2e:	09 d0                	or     %edx,%eax
  106c30:	c1 e8 04             	shr    $0x4,%eax
  106c33:	09 c3                	or     %eax,%ebx
  106c35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106c38:	d1 e8                	shr    %eax
  106c3a:	0b 45 d0             	or     -0x30(%ebp),%eax
  106c3d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106c40:	d1 ea                	shr    %edx
  106c42:	0b 55 d0             	or     -0x30(%ebp),%edx
  106c45:	c1 ea 02             	shr    $0x2,%edx
  106c48:	09 d0                	or     %edx,%eax
  106c4a:	89 c6                	mov    %eax,%esi
  106c4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106c4f:	d1 e8                	shr    %eax
  106c51:	0b 45 d0             	or     -0x30(%ebp),%eax
  106c54:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106c57:	d1 ea                	shr    %edx
  106c59:	0b 55 d0             	or     -0x30(%ebp),%edx
  106c5c:	c1 ea 02             	shr    $0x2,%edx
  106c5f:	09 d0                	or     %edx,%eax
  106c61:	c1 e8 04             	shr    $0x4,%eax
  106c64:	09 f0                	or     %esi,%eax
  106c66:	c1 e8 08             	shr    $0x8,%eax
  106c69:	09 d8                	or     %ebx,%eax
  106c6b:	c1 e8 10             	shr    $0x10,%eax
  106c6e:	09 c8                	or     %ecx,%eax
  106c70:	d1 e8                	shr    %eax
  106c72:	23 45 d0             	and    -0x30(%ebp),%eax
  106c75:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  106c7b:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  106c81:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106c84:	d1 e8                	shr    %eax
  106c86:	0b 45 d0             	or     -0x30(%ebp),%eax
  106c89:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106c8c:	d1 ea                	shr    %edx
  106c8e:	0b 55 d0             	or     -0x30(%ebp),%edx
  106c91:	c1 ea 02             	shr    $0x2,%edx
  106c94:	09 d0                	or     %edx,%eax
  106c96:	89 c1                	mov    %eax,%ecx
  106c98:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106c9b:	d1 e8                	shr    %eax
  106c9d:	0b 45 d0             	or     -0x30(%ebp),%eax
  106ca0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106ca3:	d1 ea                	shr    %edx
  106ca5:	0b 55 d0             	or     -0x30(%ebp),%edx
  106ca8:	c1 ea 02             	shr    $0x2,%edx
  106cab:	09 d0                	or     %edx,%eax
  106cad:	c1 e8 04             	shr    $0x4,%eax
  106cb0:	09 c1                	or     %eax,%ecx
  106cb2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106cb5:	d1 e8                	shr    %eax
  106cb7:	0b 45 d0             	or     -0x30(%ebp),%eax
  106cba:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106cbd:	d1 ea                	shr    %edx
  106cbf:	0b 55 d0             	or     -0x30(%ebp),%edx
  106cc2:	c1 ea 02             	shr    $0x2,%edx
  106cc5:	09 d0                	or     %edx,%eax
  106cc7:	89 c3                	mov    %eax,%ebx
  106cc9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106ccc:	d1 e8                	shr    %eax
  106cce:	0b 45 d0             	or     -0x30(%ebp),%eax
  106cd1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106cd4:	d1 ea                	shr    %edx
  106cd6:	0b 55 d0             	or     -0x30(%ebp),%edx
  106cd9:	c1 ea 02             	shr    $0x2,%edx
  106cdc:	09 d0                	or     %edx,%eax
  106cde:	c1 e8 04             	shr    $0x4,%eax
  106ce1:	09 d8                	or     %ebx,%eax
  106ce3:	c1 e8 08             	shr    $0x8,%eax
  106ce6:	89 cb                	mov    %ecx,%ebx
  106ce8:	09 c3                	or     %eax,%ebx
  106cea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106ced:	d1 e8                	shr    %eax
  106cef:	0b 45 d0             	or     -0x30(%ebp),%eax
  106cf2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106cf5:	d1 ea                	shr    %edx
  106cf7:	0b 55 d0             	or     -0x30(%ebp),%edx
  106cfa:	c1 ea 02             	shr    $0x2,%edx
  106cfd:	09 d0                	or     %edx,%eax
  106cff:	89 c1                	mov    %eax,%ecx
  106d01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106d04:	d1 e8                	shr    %eax
  106d06:	0b 45 d0             	or     -0x30(%ebp),%eax
  106d09:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106d0c:	d1 ea                	shr    %edx
  106d0e:	0b 55 d0             	or     -0x30(%ebp),%edx
  106d11:	c1 ea 02             	shr    $0x2,%edx
  106d14:	09 d0                	or     %edx,%eax
  106d16:	c1 e8 04             	shr    $0x4,%eax
  106d19:	09 c1                	or     %eax,%ecx
  106d1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106d1e:	d1 e8                	shr    %eax
  106d20:	0b 45 d0             	or     -0x30(%ebp),%eax
  106d23:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106d26:	d1 ea                	shr    %edx
  106d28:	0b 55 d0             	or     -0x30(%ebp),%edx
  106d2b:	c1 ea 02             	shr    $0x2,%edx
  106d2e:	09 d0                	or     %edx,%eax
  106d30:	89 c6                	mov    %eax,%esi
  106d32:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106d35:	d1 e8                	shr    %eax
  106d37:	0b 45 d0             	or     -0x30(%ebp),%eax
  106d3a:	89 c2                	mov    %eax,%edx
  106d3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106d3f:	d1 e8                	shr    %eax
  106d41:	0b 45 d0             	or     -0x30(%ebp),%eax
  106d44:	c1 e8 02             	shr    $0x2,%eax
  106d47:	09 d0                	or     %edx,%eax
  106d49:	c1 e8 04             	shr    $0x4,%eax
  106d4c:	09 f0                	or     %esi,%eax
  106d4e:	c1 e8 08             	shr    $0x8,%eax
  106d51:	09 c8                	or     %ecx,%eax
  106d53:	c1 e8 10             	shr    $0x10,%eax
  106d56:	09 d8                	or     %ebx,%eax
  106d58:	d1 e8                	shr    %eax
  106d5a:	23 45 d0             	and    -0x30(%ebp),%eax
  106d5d:	85 c0                	test   %eax,%eax
  106d5f:	0f 84 e2 00 00 00    	je     106e47 <buddy_free_pages+0xa1b>
  106d65:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106d68:	d1 e8                	shr    %eax
  106d6a:	0b 45 d0             	or     -0x30(%ebp),%eax
  106d6d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106d70:	d1 ea                	shr    %edx
  106d72:	0b 55 d0             	or     -0x30(%ebp),%edx
  106d75:	c1 ea 02             	shr    $0x2,%edx
  106d78:	09 d0                	or     %edx,%eax
  106d7a:	89 c1                	mov    %eax,%ecx
  106d7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106d7f:	d1 e8                	shr    %eax
  106d81:	0b 45 d0             	or     -0x30(%ebp),%eax
  106d84:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106d87:	d1 ea                	shr    %edx
  106d89:	0b 55 d0             	or     -0x30(%ebp),%edx
  106d8c:	c1 ea 02             	shr    $0x2,%edx
  106d8f:	09 d0                	or     %edx,%eax
  106d91:	c1 e8 04             	shr    $0x4,%eax
  106d94:	09 c1                	or     %eax,%ecx
  106d96:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106d99:	d1 e8                	shr    %eax
  106d9b:	0b 45 d0             	or     -0x30(%ebp),%eax
  106d9e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106da1:	d1 ea                	shr    %edx
  106da3:	0b 55 d0             	or     -0x30(%ebp),%edx
  106da6:	c1 ea 02             	shr    $0x2,%edx
  106da9:	09 d0                	or     %edx,%eax
  106dab:	89 c3                	mov    %eax,%ebx
  106dad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106db0:	d1 e8                	shr    %eax
  106db2:	0b 45 d0             	or     -0x30(%ebp),%eax
  106db5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106db8:	d1 ea                	shr    %edx
  106dba:	0b 55 d0             	or     -0x30(%ebp),%edx
  106dbd:	c1 ea 02             	shr    $0x2,%edx
  106dc0:	09 d0                	or     %edx,%eax
  106dc2:	c1 e8 04             	shr    $0x4,%eax
  106dc5:	09 d8                	or     %ebx,%eax
  106dc7:	c1 e8 08             	shr    $0x8,%eax
  106dca:	89 cb                	mov    %ecx,%ebx
  106dcc:	09 c3                	or     %eax,%ebx
  106dce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106dd1:	d1 e8                	shr    %eax
  106dd3:	0b 45 d0             	or     -0x30(%ebp),%eax
  106dd6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106dd9:	d1 ea                	shr    %edx
  106ddb:	0b 55 d0             	or     -0x30(%ebp),%edx
  106dde:	c1 ea 02             	shr    $0x2,%edx
  106de1:	09 d0                	or     %edx,%eax
  106de3:	89 c1                	mov    %eax,%ecx
  106de5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106de8:	d1 e8                	shr    %eax
  106dea:	0b 45 d0             	or     -0x30(%ebp),%eax
  106ded:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106df0:	d1 ea                	shr    %edx
  106df2:	0b 55 d0             	or     -0x30(%ebp),%edx
  106df5:	c1 ea 02             	shr    $0x2,%edx
  106df8:	09 d0                	or     %edx,%eax
  106dfa:	c1 e8 04             	shr    $0x4,%eax
  106dfd:	09 c1                	or     %eax,%ecx
  106dff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106e02:	d1 e8                	shr    %eax
  106e04:	0b 45 d0             	or     -0x30(%ebp),%eax
  106e07:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106e0a:	d1 ea                	shr    %edx
  106e0c:	0b 55 d0             	or     -0x30(%ebp),%edx
  106e0f:	c1 ea 02             	shr    $0x2,%edx
  106e12:	09 d0                	or     %edx,%eax
  106e14:	89 c6                	mov    %eax,%esi
  106e16:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106e19:	d1 e8                	shr    %eax
  106e1b:	0b 45 d0             	or     -0x30(%ebp),%eax
  106e1e:	89 c2                	mov    %eax,%edx
  106e20:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106e23:	d1 e8                	shr    %eax
  106e25:	0b 45 d0             	or     -0x30(%ebp),%eax
  106e28:	c1 e8 02             	shr    $0x2,%eax
  106e2b:	09 d0                	or     %edx,%eax
  106e2d:	c1 e8 04             	shr    $0x4,%eax
  106e30:	09 f0                	or     %esi,%eax
  106e32:	c1 e8 08             	shr    $0x8,%eax
  106e35:	09 c8                	or     %ecx,%eax
  106e37:	c1 e8 10             	shr    $0x10,%eax
  106e3a:	09 d8                	or     %ebx,%eax
  106e3c:	d1 e8                	shr    %eax
  106e3e:	f7 d0                	not    %eax
  106e40:	23 45 d0             	and    -0x30(%ebp),%eax
  106e43:	89 c6                	mov    %eax,%esi
  106e45:	eb 03                	jmp    106e4a <buddy_free_pages+0xa1e>
  106e47:	8b 75 d0             	mov    -0x30(%ebp),%esi
  106e4a:	89 f8                	mov    %edi,%eax
  106e4c:	ba 00 00 00 00       	mov    $0x0,%edx
  106e51:	f7 f6                	div    %esi
  106e53:	0f af 85 64 ff ff ff 	imul   -0x9c(%ebp),%eax
  106e5a:	89 45 c8             	mov    %eax,-0x38(%ebp)
            size_t rbegin = BUDDY_BEGIN(right);
  106e5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106e60:	d1 e8                	shr    %eax
  106e62:	0b 45 cc             	or     -0x34(%ebp),%eax
  106e65:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106e68:	d1 ea                	shr    %edx
  106e6a:	0b 55 cc             	or     -0x34(%ebp),%edx
  106e6d:	c1 ea 02             	shr    $0x2,%edx
  106e70:	09 d0                	or     %edx,%eax
  106e72:	89 c1                	mov    %eax,%ecx
  106e74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106e77:	d1 e8                	shr    %eax
  106e79:	0b 45 cc             	or     -0x34(%ebp),%eax
  106e7c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106e7f:	d1 ea                	shr    %edx
  106e81:	0b 55 cc             	or     -0x34(%ebp),%edx
  106e84:	c1 ea 02             	shr    $0x2,%edx
  106e87:	09 d0                	or     %edx,%eax
  106e89:	c1 e8 04             	shr    $0x4,%eax
  106e8c:	09 c1                	or     %eax,%ecx
  106e8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106e91:	d1 e8                	shr    %eax
  106e93:	0b 45 cc             	or     -0x34(%ebp),%eax
  106e96:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106e99:	d1 ea                	shr    %edx
  106e9b:	0b 55 cc             	or     -0x34(%ebp),%edx
  106e9e:	c1 ea 02             	shr    $0x2,%edx
  106ea1:	09 d0                	or     %edx,%eax
  106ea3:	89 c3                	mov    %eax,%ebx
  106ea5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106ea8:	d1 e8                	shr    %eax
  106eaa:	0b 45 cc             	or     -0x34(%ebp),%eax
  106ead:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106eb0:	d1 ea                	shr    %edx
  106eb2:	0b 55 cc             	or     -0x34(%ebp),%edx
  106eb5:	c1 ea 02             	shr    $0x2,%edx
  106eb8:	09 d0                	or     %edx,%eax
  106eba:	c1 e8 04             	shr    $0x4,%eax
  106ebd:	09 d8                	or     %ebx,%eax
  106ebf:	c1 e8 08             	shr    $0x8,%eax
  106ec2:	09 c1                	or     %eax,%ecx
  106ec4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106ec7:	d1 e8                	shr    %eax
  106ec9:	0b 45 cc             	or     -0x34(%ebp),%eax
  106ecc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106ecf:	d1 ea                	shr    %edx
  106ed1:	0b 55 cc             	or     -0x34(%ebp),%edx
  106ed4:	c1 ea 02             	shr    $0x2,%edx
  106ed7:	09 d0                	or     %edx,%eax
  106ed9:	89 c3                	mov    %eax,%ebx
  106edb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106ede:	d1 e8                	shr    %eax
  106ee0:	0b 45 cc             	or     -0x34(%ebp),%eax
  106ee3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106ee6:	d1 ea                	shr    %edx
  106ee8:	0b 55 cc             	or     -0x34(%ebp),%edx
  106eeb:	c1 ea 02             	shr    $0x2,%edx
  106eee:	09 d0                	or     %edx,%eax
  106ef0:	c1 e8 04             	shr    $0x4,%eax
  106ef3:	09 c3                	or     %eax,%ebx
  106ef5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106ef8:	d1 e8                	shr    %eax
  106efa:	0b 45 cc             	or     -0x34(%ebp),%eax
  106efd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106f00:	d1 ea                	shr    %edx
  106f02:	0b 55 cc             	or     -0x34(%ebp),%edx
  106f05:	c1 ea 02             	shr    $0x2,%edx
  106f08:	09 d0                	or     %edx,%eax
  106f0a:	89 c6                	mov    %eax,%esi
  106f0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106f0f:	d1 e8                	shr    %eax
  106f11:	0b 45 cc             	or     -0x34(%ebp),%eax
  106f14:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106f17:	d1 ea                	shr    %edx
  106f19:	0b 55 cc             	or     -0x34(%ebp),%edx
  106f1c:	c1 ea 02             	shr    $0x2,%edx
  106f1f:	09 d0                	or     %edx,%eax
  106f21:	c1 e8 04             	shr    $0x4,%eax
  106f24:	09 f0                	or     %esi,%eax
  106f26:	c1 e8 08             	shr    $0x8,%eax
  106f29:	09 d8                	or     %ebx,%eax
  106f2b:	c1 e8 10             	shr    $0x10,%eax
  106f2e:	09 c8                	or     %ecx,%eax
  106f30:	d1 e8                	shr    %eax
  106f32:	23 45 cc             	and    -0x34(%ebp),%eax
  106f35:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  106f3b:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  106f41:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106f44:	d1 e8                	shr    %eax
  106f46:	0b 45 cc             	or     -0x34(%ebp),%eax
  106f49:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106f4c:	d1 ea                	shr    %edx
  106f4e:	0b 55 cc             	or     -0x34(%ebp),%edx
  106f51:	c1 ea 02             	shr    $0x2,%edx
  106f54:	09 d0                	or     %edx,%eax
  106f56:	89 c1                	mov    %eax,%ecx
  106f58:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106f5b:	d1 e8                	shr    %eax
  106f5d:	0b 45 cc             	or     -0x34(%ebp),%eax
  106f60:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106f63:	d1 ea                	shr    %edx
  106f65:	0b 55 cc             	or     -0x34(%ebp),%edx
  106f68:	c1 ea 02             	shr    $0x2,%edx
  106f6b:	09 d0                	or     %edx,%eax
  106f6d:	c1 e8 04             	shr    $0x4,%eax
  106f70:	09 c1                	or     %eax,%ecx
  106f72:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106f75:	d1 e8                	shr    %eax
  106f77:	0b 45 cc             	or     -0x34(%ebp),%eax
  106f7a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106f7d:	d1 ea                	shr    %edx
  106f7f:	0b 55 cc             	or     -0x34(%ebp),%edx
  106f82:	c1 ea 02             	shr    $0x2,%edx
  106f85:	09 d0                	or     %edx,%eax
  106f87:	89 c3                	mov    %eax,%ebx
  106f89:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106f8c:	d1 e8                	shr    %eax
  106f8e:	0b 45 cc             	or     -0x34(%ebp),%eax
  106f91:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106f94:	d1 ea                	shr    %edx
  106f96:	0b 55 cc             	or     -0x34(%ebp),%edx
  106f99:	c1 ea 02             	shr    $0x2,%edx
  106f9c:	09 d0                	or     %edx,%eax
  106f9e:	c1 e8 04             	shr    $0x4,%eax
  106fa1:	09 d8                	or     %ebx,%eax
  106fa3:	c1 e8 08             	shr    $0x8,%eax
  106fa6:	89 cb                	mov    %ecx,%ebx
  106fa8:	09 c3                	or     %eax,%ebx
  106faa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106fad:	d1 e8                	shr    %eax
  106faf:	0b 45 cc             	or     -0x34(%ebp),%eax
  106fb2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106fb5:	d1 ea                	shr    %edx
  106fb7:	0b 55 cc             	or     -0x34(%ebp),%edx
  106fba:	c1 ea 02             	shr    $0x2,%edx
  106fbd:	09 d0                	or     %edx,%eax
  106fbf:	89 c1                	mov    %eax,%ecx
  106fc1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106fc4:	d1 e8                	shr    %eax
  106fc6:	0b 45 cc             	or     -0x34(%ebp),%eax
  106fc9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106fcc:	d1 ea                	shr    %edx
  106fce:	0b 55 cc             	or     -0x34(%ebp),%edx
  106fd1:	c1 ea 02             	shr    $0x2,%edx
  106fd4:	09 d0                	or     %edx,%eax
  106fd6:	c1 e8 04             	shr    $0x4,%eax
  106fd9:	09 c1                	or     %eax,%ecx
  106fdb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106fde:	d1 e8                	shr    %eax
  106fe0:	0b 45 cc             	or     -0x34(%ebp),%eax
  106fe3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  106fe6:	d1 ea                	shr    %edx
  106fe8:	0b 55 cc             	or     -0x34(%ebp),%edx
  106feb:	c1 ea 02             	shr    $0x2,%edx
  106fee:	09 d0                	or     %edx,%eax
  106ff0:	89 c6                	mov    %eax,%esi
  106ff2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106ff5:	d1 e8                	shr    %eax
  106ff7:	0b 45 cc             	or     -0x34(%ebp),%eax
  106ffa:	89 c2                	mov    %eax,%edx
  106ffc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106fff:	d1 e8                	shr    %eax
  107001:	0b 45 cc             	or     -0x34(%ebp),%eax
  107004:	c1 e8 02             	shr    $0x2,%eax
  107007:	09 d0                	or     %edx,%eax
  107009:	c1 e8 04             	shr    $0x4,%eax
  10700c:	09 f0                	or     %esi,%eax
  10700e:	c1 e8 08             	shr    $0x8,%eax
  107011:	09 c8                	or     %ecx,%eax
  107013:	c1 e8 10             	shr    $0x10,%eax
  107016:	09 d8                	or     %ebx,%eax
  107018:	d1 e8                	shr    %eax
  10701a:	23 45 cc             	and    -0x34(%ebp),%eax
  10701d:	85 c0                	test   %eax,%eax
  10701f:	0f 84 e2 00 00 00    	je     107107 <buddy_free_pages+0xcdb>
  107025:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107028:	d1 e8                	shr    %eax
  10702a:	0b 45 cc             	or     -0x34(%ebp),%eax
  10702d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107030:	d1 ea                	shr    %edx
  107032:	0b 55 cc             	or     -0x34(%ebp),%edx
  107035:	c1 ea 02             	shr    $0x2,%edx
  107038:	09 d0                	or     %edx,%eax
  10703a:	89 c1                	mov    %eax,%ecx
  10703c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10703f:	d1 e8                	shr    %eax
  107041:	0b 45 cc             	or     -0x34(%ebp),%eax
  107044:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107047:	d1 ea                	shr    %edx
  107049:	0b 55 cc             	or     -0x34(%ebp),%edx
  10704c:	c1 ea 02             	shr    $0x2,%edx
  10704f:	09 d0                	or     %edx,%eax
  107051:	c1 e8 04             	shr    $0x4,%eax
  107054:	09 c1                	or     %eax,%ecx
  107056:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107059:	d1 e8                	shr    %eax
  10705b:	0b 45 cc             	or     -0x34(%ebp),%eax
  10705e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107061:	d1 ea                	shr    %edx
  107063:	0b 55 cc             	or     -0x34(%ebp),%edx
  107066:	c1 ea 02             	shr    $0x2,%edx
  107069:	09 d0                	or     %edx,%eax
  10706b:	89 c3                	mov    %eax,%ebx
  10706d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107070:	d1 e8                	shr    %eax
  107072:	0b 45 cc             	or     -0x34(%ebp),%eax
  107075:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107078:	d1 ea                	shr    %edx
  10707a:	0b 55 cc             	or     -0x34(%ebp),%edx
  10707d:	c1 ea 02             	shr    $0x2,%edx
  107080:	09 d0                	or     %edx,%eax
  107082:	c1 e8 04             	shr    $0x4,%eax
  107085:	09 d8                	or     %ebx,%eax
  107087:	c1 e8 08             	shr    $0x8,%eax
  10708a:	89 cb                	mov    %ecx,%ebx
  10708c:	09 c3                	or     %eax,%ebx
  10708e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107091:	d1 e8                	shr    %eax
  107093:	0b 45 cc             	or     -0x34(%ebp),%eax
  107096:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107099:	d1 ea                	shr    %edx
  10709b:	0b 55 cc             	or     -0x34(%ebp),%edx
  10709e:	c1 ea 02             	shr    $0x2,%edx
  1070a1:	09 d0                	or     %edx,%eax
  1070a3:	89 c1                	mov    %eax,%ecx
  1070a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1070a8:	d1 e8                	shr    %eax
  1070aa:	0b 45 cc             	or     -0x34(%ebp),%eax
  1070ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1070b0:	d1 ea                	shr    %edx
  1070b2:	0b 55 cc             	or     -0x34(%ebp),%edx
  1070b5:	c1 ea 02             	shr    $0x2,%edx
  1070b8:	09 d0                	or     %edx,%eax
  1070ba:	c1 e8 04             	shr    $0x4,%eax
  1070bd:	09 c1                	or     %eax,%ecx
  1070bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1070c2:	d1 e8                	shr    %eax
  1070c4:	0b 45 cc             	or     -0x34(%ebp),%eax
  1070c7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1070ca:	d1 ea                	shr    %edx
  1070cc:	0b 55 cc             	or     -0x34(%ebp),%edx
  1070cf:	c1 ea 02             	shr    $0x2,%edx
  1070d2:	09 d0                	or     %edx,%eax
  1070d4:	89 c6                	mov    %eax,%esi
  1070d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1070d9:	d1 e8                	shr    %eax
  1070db:	0b 45 cc             	or     -0x34(%ebp),%eax
  1070de:	89 c2                	mov    %eax,%edx
  1070e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1070e3:	d1 e8                	shr    %eax
  1070e5:	0b 45 cc             	or     -0x34(%ebp),%eax
  1070e8:	c1 e8 02             	shr    $0x2,%eax
  1070eb:	09 d0                	or     %edx,%eax
  1070ed:	c1 e8 04             	shr    $0x4,%eax
  1070f0:	09 f0                	or     %esi,%eax
  1070f2:	c1 e8 08             	shr    $0x8,%eax
  1070f5:	09 c8                	or     %ecx,%eax
  1070f7:	c1 e8 10             	shr    $0x10,%eax
  1070fa:	09 d8                	or     %ebx,%eax
  1070fc:	d1 e8                	shr    %eax
  1070fe:	f7 d0                	not    %eax
  107100:	23 45 cc             	and    -0x34(%ebp),%eax
  107103:	89 c6                	mov    %eax,%esi
  107105:	eb 03                	jmp    10710a <buddy_free_pages+0xcde>
  107107:	8b 75 cc             	mov    -0x34(%ebp),%esi
  10710a:	89 f8                	mov    %edi,%eax
  10710c:	ba 00 00 00 00       	mov    $0x0,%edx
  107111:	f7 f6                	div    %esi
  107113:	0f af 85 64 ff ff ff 	imul   -0x9c(%ebp),%eax
  10711a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            list_del(&(buddy_alloc[lbegin].page_link));
  10711d:	8b 0d 64 e9 11 00    	mov    0x11e964,%ecx
  107123:	8b 55 c8             	mov    -0x38(%ebp),%edx
  107126:	89 d0                	mov    %edx,%eax
  107128:	c1 e0 02             	shl    $0x2,%eax
  10712b:	01 d0                	add    %edx,%eax
  10712d:	c1 e0 02             	shl    $0x2,%eax
  107130:	01 c8                	add    %ecx,%eax
  107132:	83 c0 0c             	add    $0xc,%eax
  107135:	89 45 98             	mov    %eax,-0x68(%ebp)
    __list_del(listelm->prev, listelm->next);
  107138:	8b 45 98             	mov    -0x68(%ebp),%eax
  10713b:	8b 40 04             	mov    0x4(%eax),%eax
  10713e:	8b 55 98             	mov    -0x68(%ebp),%edx
  107141:	8b 12                	mov    (%edx),%edx
  107143:	89 55 94             	mov    %edx,-0x6c(%ebp)
  107146:	89 45 90             	mov    %eax,-0x70(%ebp)
    prev->next = next;
  107149:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10714c:	8b 55 90             	mov    -0x70(%ebp),%edx
  10714f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  107152:	8b 45 90             	mov    -0x70(%ebp),%eax
  107155:	8b 55 94             	mov    -0x6c(%ebp),%edx
  107158:	89 10                	mov    %edx,(%eax)
            list_del(&(buddy_alloc[rbegin].page_link));
  10715a:	8b 0d 64 e9 11 00    	mov    0x11e964,%ecx
  107160:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  107163:	89 d0                	mov    %edx,%eax
  107165:	c1 e0 02             	shl    $0x2,%eax
  107168:	01 d0                	add    %edx,%eax
  10716a:	c1 e0 02             	shl    $0x2,%eax
  10716d:	01 c8                	add    %ecx,%eax
  10716f:	83 c0 0c             	add    $0xc,%eax
  107172:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_del(listelm->prev, listelm->next);
  107175:	8b 45 8c             	mov    -0x74(%ebp),%eax
  107178:	8b 40 04             	mov    0x4(%eax),%eax
  10717b:	8b 55 8c             	mov    -0x74(%ebp),%edx
  10717e:	8b 12                	mov    (%edx),%edx
  107180:	89 55 88             	mov    %edx,-0x78(%ebp)
  107183:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next;
  107186:	8b 45 88             	mov    -0x78(%ebp),%eax
  107189:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10718c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10718f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  107192:	8b 55 88             	mov    -0x78(%ebp),%edx
  107195:	89 10                	mov    %edx,(%eax)
            buddy_segment[block] = buddy_segment[left]<<1;
  107197:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  10719c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10719f:	c1 e2 02             	shl    $0x2,%edx
  1071a2:	01 d0                	add    %edx,%eax
  1071a4:	8b 15 5c e9 11 00    	mov    0x11e95c,%edx
  1071aa:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1071ad:	c1 e1 02             	shl    $0x2,%ecx
  1071b0:	01 ca                	add    %ecx,%edx
  1071b2:	8b 12                	mov    (%edx),%edx
  1071b4:	01 d2                	add    %edx,%edx
  1071b6:	89 10                	mov    %edx,(%eax)
            buddy_alloc[lbegin].property = buddy_segment[left]<<1;
  1071b8:	8b 0d 64 e9 11 00    	mov    0x11e964,%ecx
  1071be:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1071c1:	89 d0                	mov    %edx,%eax
  1071c3:	c1 e0 02             	shl    $0x2,%eax
  1071c6:	01 d0                	add    %edx,%eax
  1071c8:	c1 e0 02             	shl    $0x2,%eax
  1071cb:	01 c8                	add    %ecx,%eax
  1071cd:	8b 15 5c e9 11 00    	mov    0x11e95c,%edx
  1071d3:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1071d6:	c1 e1 02             	shl    $0x2,%ecx
  1071d9:	01 ca                	add    %ecx,%edx
  1071db:	8b 12                	mov    (%edx),%edx
  1071dd:	01 d2                	add    %edx,%edx
  1071df:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(free_list), &(buddy_alloc[lbegin].page_link));
  1071e2:	8b 0d 64 e9 11 00    	mov    0x11e964,%ecx
  1071e8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1071eb:	89 d0                	mov    %edx,%eax
  1071ed:	c1 e0 02             	shl    $0x2,%eax
  1071f0:	01 d0                	add    %edx,%eax
  1071f2:	c1 e0 02             	shl    $0x2,%eax
  1071f5:	01 c8                	add    %ecx,%eax
  1071f7:	83 c0 0c             	add    $0xc,%eax
  1071fa:	c7 45 80 78 e9 11 00 	movl   $0x11e978,-0x80(%ebp)
  107201:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  107207:	8b 45 80             	mov    -0x80(%ebp),%eax
  10720a:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  107210:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  107216:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    __list_add(elm, listelm, listelm->next);
  10721c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  107222:	8b 40 04             	mov    0x4(%eax),%eax
  107225:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  10722b:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
  107231:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  107237:	89 95 6c ff ff ff    	mov    %edx,-0x94(%ebp)
  10723d:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
    prev->next = next->prev = elm;
  107243:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  107249:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  10724f:	89 10                	mov    %edx,(%eax)
  107251:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  107257:	8b 10                	mov    (%eax),%edx
  107259:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  10725f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  107262:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  107268:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
  10726e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  107271:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  107277:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  10727d:	89 10                	mov    %edx,(%eax)
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right)) {  // Merge
  10727f:	eb 34                	jmp    1072b5 <buddy_free_pages+0xe89>
        } else {                                        // Update
            buddy_segment[block] = buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)];
  107281:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  107286:	8b 55 e0             	mov    -0x20(%ebp),%edx
  107289:	c1 e2 02             	shl    $0x2,%edx
  10728c:	01 d0                	add    %edx,%eax
  10728e:	8b 15 5c e9 11 00    	mov    0x11e95c,%edx
  107294:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  107297:	c1 e1 03             	shl    $0x3,%ecx
  10729a:	01 ca                	add    %ecx,%edx
  10729c:	8b 0a                	mov    (%edx),%ecx
  10729e:	8b 15 5c e9 11 00    	mov    0x11e95c,%edx
  1072a4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  1072a7:	c1 e3 03             	shl    $0x3,%ebx
  1072aa:	83 c3 04             	add    $0x4,%ebx
  1072ad:	01 da                	add    %ebx,%edx
  1072af:	8b 12                	mov    (%edx),%edx
  1072b1:	09 ca                	or     %ecx,%edx
  1072b3:	89 10                	mov    %edx,(%eax)
    while (block != BUDDY_ROOT) {
  1072b5:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
  1072b9:	0f 85 d6 f4 ff ff    	jne    106795 <buddy_free_pages+0x369>
        }
    }
}
  1072bf:	81 c4 ac 00 00 00    	add    $0xac,%esp
  1072c5:	5b                   	pop    %ebx
  1072c6:	5e                   	pop    %esi
  1072c7:	5f                   	pop    %edi
  1072c8:	5d                   	pop    %ebp
  1072c9:	c3                   	ret    

001072ca <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
  1072ca:	55                   	push   %ebp
  1072cb:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1072cd:	a1 80 e9 11 00       	mov    0x11e980,%eax
}
  1072d2:	5d                   	pop    %ebp
  1072d3:	c3                   	ret    

001072d4 <macro_check>:

static void
macro_check(void) {
  1072d4:	55                   	push   %ebp
  1072d5:	89 e5                	mov    %esp,%ebp
  1072d7:	83 ec 28             	sub    $0x28,%esp
    assert(BUDDY_ROOT == 1);
    assert(BUDDY_LEFT(3) == 6);
    assert(BUDDY_RIGHT(3) == 7);
    assert(BUDDY_PARENT(6) == 3);
    assert(BUDDY_PARENT(7) == 3);
    size_t buddy_virtual_size_store = buddy_virtual_size;
  1072da:	a1 50 e9 11 00       	mov    0x11e950,%eax
  1072df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t buddy_segment_root_store = buddy_segment[BUDDY_ROOT];
  1072e2:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  1072e7:	8b 40 04             	mov    0x4(%eax),%eax
  1072ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    buddy_virtual_size = 16;
  1072ed:	c7 05 50 e9 11 00 10 	movl   $0x10,0x11e950
  1072f4:	00 00 00 
    buddy_segment[BUDDY_ROOT] = 16;
  1072f7:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  1072fc:	83 c0 04             	add    $0x4,%eax
  1072ff:	c7 00 10 00 00 00    	movl   $0x10,(%eax)
    assert(BUDDY_LENGTH(6) == 4);
  107305:	a1 50 e9 11 00       	mov    0x11e950,%eax
  10730a:	83 e8 10             	sub    $0x10,%eax
  10730d:	83 f8 03             	cmp    $0x3,%eax
  107310:	76 24                	jbe    107336 <macro_check+0x62>
  107312:	c7 44 24 0c 08 ac 10 	movl   $0x10ac08,0xc(%esp)
  107319:	00 
  10731a:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107321:	00 
  107322:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  107329:	00 
  10732a:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107331:	e8 b2 90 ff ff       	call   1003e8 <__panic>
    assert(BUDDY_BEGIN(6) == 8);
  107336:	a1 50 e9 11 00       	mov    0x11e950,%eax
  10733b:	c1 e8 02             	shr    $0x2,%eax
  10733e:	01 c0                	add    %eax,%eax
  107340:	83 f8 08             	cmp    $0x8,%eax
  107343:	74 24                	je     107369 <macro_check+0x95>
  107345:	c7 44 24 0c 1d ac 10 	movl   $0x10ac1d,0xc(%esp)
  10734c:	00 
  10734d:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107354:	00 
  107355:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  10735c:	00 
  10735d:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107364:	e8 7f 90 ff ff       	call   1003e8 <__panic>
    assert(BUDDY_END(6) == 12);
  107369:	a1 50 e9 11 00       	mov    0x11e950,%eax
  10736e:	c1 e8 02             	shr    $0x2,%eax
  107371:	89 c2                	mov    %eax,%edx
  107373:	89 d0                	mov    %edx,%eax
  107375:	01 c0                	add    %eax,%eax
  107377:	01 d0                	add    %edx,%eax
  107379:	83 f8 0c             	cmp    $0xc,%eax
  10737c:	74 24                	je     1073a2 <macro_check+0xce>
  10737e:	c7 44 24 0c 31 ac 10 	movl   $0x10ac31,0xc(%esp)
  107385:	00 
  107386:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  10738d:	00 
  10738e:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  107395:	00 
  107396:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  10739d:	e8 46 90 ff ff       	call   1003e8 <__panic>
    assert(BUDDY_BLOCK(8, 12) == 6);
  1073a2:	a1 50 e9 11 00       	mov    0x11e950,%eax
  1073a7:	83 e8 10             	sub    $0x10,%eax
  1073aa:	83 f8 03             	cmp    $0x3,%eax
  1073ad:	76 24                	jbe    1073d3 <macro_check+0xff>
  1073af:	c7 44 24 0c 44 ac 10 	movl   $0x10ac44,0xc(%esp)
  1073b6:	00 
  1073b7:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  1073be:	00 
  1073bf:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  1073c6:	00 
  1073c7:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  1073ce:	e8 15 90 ff ff       	call   1003e8 <__panic>
    assert(BUDDY_EMPTY(BUDDY_ROOT));
  1073d3:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  1073d8:	83 c0 04             	add    $0x4,%eax
  1073db:	8b 10                	mov    (%eax),%edx
  1073dd:	a1 50 e9 11 00       	mov    0x11e950,%eax
  1073e2:	39 c2                	cmp    %eax,%edx
  1073e4:	74 24                	je     10740a <macro_check+0x136>
  1073e6:	c7 44 24 0c 5c ac 10 	movl   $0x10ac5c,0xc(%esp)
  1073ed:	00 
  1073ee:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  1073f5:	00 
  1073f6:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  1073fd:	00 
  1073fe:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107405:	e8 de 8f ff ff       	call   1003e8 <__panic>
    buddy_virtual_size = buddy_virtual_size_store;
  10740a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10740d:	a3 50 e9 11 00       	mov    %eax,0x11e950
    buddy_segment[BUDDY_ROOT] = buddy_segment_root_store;
  107412:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  107417:	8d 50 04             	lea    0x4(%eax),%edx
  10741a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10741d:	89 02                	mov    %eax,(%edx)
    assert(UINT32_ROUND_UP(0x2321) == 0x4000);
    assert(UINT32_ROUND_UP(0x2000) == 0x2000);
    assert(UINT32_ROUND_DOWN(0x4321) == 0x4000);
    assert(UINT32_ROUND_DOWN(0x4000) == 0x4000);

}
  10741f:	c9                   	leave  
  107420:	c3                   	ret    

00107421 <size_check>:

static void
size_check(void) {
  107421:	55                   	push   %ebp
  107422:	89 e5                	mov    %esp,%ebp
  107424:	83 ec 28             	sub    $0x28,%esp

    size_t buddy_physical_size_store = buddy_physical_size;
  107427:	a1 4c e9 11 00       	mov    0x11e94c,%eax
  10742c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    buddy_init_size(200);
  10742f:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
  107436:	e8 0f d0 ff ff       	call   10444a <buddy_init_size>
    assert(buddy_virtual_size == 256);
  10743b:	a1 50 e9 11 00       	mov    0x11e950,%eax
  107440:	3d 00 01 00 00       	cmp    $0x100,%eax
  107445:	74 24                	je     10746b <size_check+0x4a>
  107447:	c7 44 24 0c 74 ac 10 	movl   $0x10ac74,0xc(%esp)
  10744e:	00 
  10744f:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107456:	00 
  107457:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  10745e:	00 
  10745f:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107466:	e8 7d 8f ff ff       	call   1003e8 <__panic>
    buddy_init_size(1024);
  10746b:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  107472:	e8 d3 cf ff ff       	call   10444a <buddy_init_size>
    assert(buddy_virtual_size == 1024);
  107477:	a1 50 e9 11 00       	mov    0x11e950,%eax
  10747c:	3d 00 04 00 00       	cmp    $0x400,%eax
  107481:	74 24                	je     1074a7 <size_check+0x86>
  107483:	c7 44 24 0c 8e ac 10 	movl   $0x10ac8e,0xc(%esp)
  10748a:	00 
  10748b:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107492:	00 
  107493:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  10749a:	00 
  10749b:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  1074a2:	e8 41 8f ff ff       	call   1003e8 <__panic>
    buddy_init_size(1026);
  1074a7:	c7 04 24 02 04 00 00 	movl   $0x402,(%esp)
  1074ae:	e8 97 cf ff ff       	call   10444a <buddy_init_size>
    assert(buddy_virtual_size == 1024);
  1074b3:	a1 50 e9 11 00       	mov    0x11e950,%eax
  1074b8:	3d 00 04 00 00       	cmp    $0x400,%eax
  1074bd:	74 24                	je     1074e3 <size_check+0xc2>
  1074bf:	c7 44 24 0c 8e ac 10 	movl   $0x10ac8e,0xc(%esp)
  1074c6:	00 
  1074c7:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  1074ce:	00 
  1074cf:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1074d6:	00 
  1074d7:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  1074de:	e8 05 8f ff ff       	call   1003e8 <__panic>
    buddy_init_size(1028);    
  1074e3:	c7 04 24 04 04 00 00 	movl   $0x404,(%esp)
  1074ea:	e8 5b cf ff ff       	call   10444a <buddy_init_size>
    assert(buddy_virtual_size == 1024);
  1074ef:	a1 50 e9 11 00       	mov    0x11e950,%eax
  1074f4:	3d 00 04 00 00       	cmp    $0x400,%eax
  1074f9:	74 24                	je     10751f <size_check+0xfe>
  1074fb:	c7 44 24 0c 8e ac 10 	movl   $0x10ac8e,0xc(%esp)
  107502:	00 
  107503:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  10750a:	00 
  10750b:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  107512:	00 
  107513:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  10751a:	e8 c9 8e ff ff       	call   1003e8 <__panic>
    buddy_init_size(1030);    
  10751f:	c7 04 24 06 04 00 00 	movl   $0x406,(%esp)
  107526:	e8 1f cf ff ff       	call   10444a <buddy_init_size>
    assert(buddy_virtual_size == 2048);
  10752b:	a1 50 e9 11 00       	mov    0x11e950,%eax
  107530:	3d 00 08 00 00       	cmp    $0x800,%eax
  107535:	74 24                	je     10755b <size_check+0x13a>
  107537:	c7 44 24 0c a9 ac 10 	movl   $0x10aca9,0xc(%esp)
  10753e:	00 
  10753f:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107546:	00 
  107547:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  10754e:	00 
  10754f:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107556:	e8 8d 8e ff ff       	call   1003e8 <__panic>
    buddy_init_size(buddy_physical_size_store);   
  10755b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10755e:	89 04 24             	mov    %eax,(%esp)
  107561:	e8 e4 ce ff ff       	call   10444a <buddy_init_size>

}
  107566:	c9                   	leave  
  107567:	c3                   	ret    

00107568 <segment_check>:

static void
segment_check(void) {
  107568:	55                   	push   %ebp
  107569:	89 e5                	mov    %esp,%ebp
  10756b:	57                   	push   %edi
  10756c:	56                   	push   %esi
  10756d:	53                   	push   %ebx
  10756e:	83 ec 4c             	sub    $0x4c,%esp

    // Check buddy segment
    size_t total = 0, count = 0;
  107571:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  107578:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    size_t block;
    for (block = BUDDY_ROOT; block < (buddy_virtual_size<<1); block++)
  10757f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  107586:	e9 2f 04 00 00       	jmp    1079ba <segment_check+0x452>
        if (BUDDY_EMPTY(block))
  10758b:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  107590:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107593:	c1 e2 02             	shl    $0x2,%edx
  107596:	01 d0                	add    %edx,%eax
  107598:	8b 00                	mov    (%eax),%eax
  10759a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  10759d:	8b 3d 50 e9 11 00    	mov    0x11e950,%edi
  1075a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1075a6:	d1 e8                	shr    %eax
  1075a8:	0b 45 dc             	or     -0x24(%ebp),%eax
  1075ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1075ae:	d1 ea                	shr    %edx
  1075b0:	0b 55 dc             	or     -0x24(%ebp),%edx
  1075b3:	c1 ea 02             	shr    $0x2,%edx
  1075b6:	09 d0                	or     %edx,%eax
  1075b8:	89 c1                	mov    %eax,%ecx
  1075ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1075bd:	d1 e8                	shr    %eax
  1075bf:	0b 45 dc             	or     -0x24(%ebp),%eax
  1075c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1075c5:	d1 ea                	shr    %edx
  1075c7:	0b 55 dc             	or     -0x24(%ebp),%edx
  1075ca:	c1 ea 02             	shr    $0x2,%edx
  1075cd:	09 d0                	or     %edx,%eax
  1075cf:	c1 e8 04             	shr    $0x4,%eax
  1075d2:	09 c1                	or     %eax,%ecx
  1075d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1075d7:	d1 e8                	shr    %eax
  1075d9:	0b 45 dc             	or     -0x24(%ebp),%eax
  1075dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1075df:	d1 ea                	shr    %edx
  1075e1:	0b 55 dc             	or     -0x24(%ebp),%edx
  1075e4:	c1 ea 02             	shr    $0x2,%edx
  1075e7:	09 d0                	or     %edx,%eax
  1075e9:	89 c3                	mov    %eax,%ebx
  1075eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1075ee:	d1 e8                	shr    %eax
  1075f0:	0b 45 dc             	or     -0x24(%ebp),%eax
  1075f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1075f6:	d1 ea                	shr    %edx
  1075f8:	0b 55 dc             	or     -0x24(%ebp),%edx
  1075fb:	c1 ea 02             	shr    $0x2,%edx
  1075fe:	09 d0                	or     %edx,%eax
  107600:	c1 e8 04             	shr    $0x4,%eax
  107603:	09 d8                	or     %ebx,%eax
  107605:	c1 e8 08             	shr    $0x8,%eax
  107608:	89 cb                	mov    %ecx,%ebx
  10760a:	09 c3                	or     %eax,%ebx
  10760c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10760f:	d1 e8                	shr    %eax
  107611:	0b 45 dc             	or     -0x24(%ebp),%eax
  107614:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107617:	d1 ea                	shr    %edx
  107619:	0b 55 dc             	or     -0x24(%ebp),%edx
  10761c:	c1 ea 02             	shr    $0x2,%edx
  10761f:	09 d0                	or     %edx,%eax
  107621:	89 c1                	mov    %eax,%ecx
  107623:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107626:	d1 e8                	shr    %eax
  107628:	0b 45 dc             	or     -0x24(%ebp),%eax
  10762b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10762e:	d1 ea                	shr    %edx
  107630:	0b 55 dc             	or     -0x24(%ebp),%edx
  107633:	c1 ea 02             	shr    $0x2,%edx
  107636:	09 d0                	or     %edx,%eax
  107638:	c1 e8 04             	shr    $0x4,%eax
  10763b:	09 c1                	or     %eax,%ecx
  10763d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107640:	d1 e8                	shr    %eax
  107642:	0b 45 dc             	or     -0x24(%ebp),%eax
  107645:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107648:	d1 ea                	shr    %edx
  10764a:	0b 55 dc             	or     -0x24(%ebp),%edx
  10764d:	c1 ea 02             	shr    $0x2,%edx
  107650:	09 d0                	or     %edx,%eax
  107652:	89 c6                	mov    %eax,%esi
  107654:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107657:	d1 e8                	shr    %eax
  107659:	0b 45 dc             	or     -0x24(%ebp),%eax
  10765c:	89 c2                	mov    %eax,%edx
  10765e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107661:	d1 e8                	shr    %eax
  107663:	0b 45 dc             	or     -0x24(%ebp),%eax
  107666:	c1 e8 02             	shr    $0x2,%eax
  107669:	09 d0                	or     %edx,%eax
  10766b:	c1 e8 04             	shr    $0x4,%eax
  10766e:	09 f0                	or     %esi,%eax
  107670:	c1 e8 08             	shr    $0x8,%eax
  107673:	09 c8                	or     %ecx,%eax
  107675:	c1 e8 10             	shr    $0x10,%eax
  107678:	09 d8                	or     %ebx,%eax
  10767a:	d1 e8                	shr    %eax
  10767c:	23 45 dc             	and    -0x24(%ebp),%eax
  10767f:	85 c0                	test   %eax,%eax
  107681:	0f 84 e2 00 00 00    	je     107769 <segment_check+0x201>
  107687:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10768a:	d1 e8                	shr    %eax
  10768c:	0b 45 dc             	or     -0x24(%ebp),%eax
  10768f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107692:	d1 ea                	shr    %edx
  107694:	0b 55 dc             	or     -0x24(%ebp),%edx
  107697:	c1 ea 02             	shr    $0x2,%edx
  10769a:	09 d0                	or     %edx,%eax
  10769c:	89 c1                	mov    %eax,%ecx
  10769e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1076a1:	d1 e8                	shr    %eax
  1076a3:	0b 45 dc             	or     -0x24(%ebp),%eax
  1076a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1076a9:	d1 ea                	shr    %edx
  1076ab:	0b 55 dc             	or     -0x24(%ebp),%edx
  1076ae:	c1 ea 02             	shr    $0x2,%edx
  1076b1:	09 d0                	or     %edx,%eax
  1076b3:	c1 e8 04             	shr    $0x4,%eax
  1076b6:	09 c1                	or     %eax,%ecx
  1076b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1076bb:	d1 e8                	shr    %eax
  1076bd:	0b 45 dc             	or     -0x24(%ebp),%eax
  1076c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1076c3:	d1 ea                	shr    %edx
  1076c5:	0b 55 dc             	or     -0x24(%ebp),%edx
  1076c8:	c1 ea 02             	shr    $0x2,%edx
  1076cb:	09 d0                	or     %edx,%eax
  1076cd:	89 c3                	mov    %eax,%ebx
  1076cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1076d2:	d1 e8                	shr    %eax
  1076d4:	0b 45 dc             	or     -0x24(%ebp),%eax
  1076d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1076da:	d1 ea                	shr    %edx
  1076dc:	0b 55 dc             	or     -0x24(%ebp),%edx
  1076df:	c1 ea 02             	shr    $0x2,%edx
  1076e2:	09 d0                	or     %edx,%eax
  1076e4:	c1 e8 04             	shr    $0x4,%eax
  1076e7:	09 d8                	or     %ebx,%eax
  1076e9:	c1 e8 08             	shr    $0x8,%eax
  1076ec:	89 cb                	mov    %ecx,%ebx
  1076ee:	09 c3                	or     %eax,%ebx
  1076f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1076f3:	d1 e8                	shr    %eax
  1076f5:	0b 45 dc             	or     -0x24(%ebp),%eax
  1076f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1076fb:	d1 ea                	shr    %edx
  1076fd:	0b 55 dc             	or     -0x24(%ebp),%edx
  107700:	c1 ea 02             	shr    $0x2,%edx
  107703:	09 d0                	or     %edx,%eax
  107705:	89 c1                	mov    %eax,%ecx
  107707:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10770a:	d1 e8                	shr    %eax
  10770c:	0b 45 dc             	or     -0x24(%ebp),%eax
  10770f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107712:	d1 ea                	shr    %edx
  107714:	0b 55 dc             	or     -0x24(%ebp),%edx
  107717:	c1 ea 02             	shr    $0x2,%edx
  10771a:	09 d0                	or     %edx,%eax
  10771c:	c1 e8 04             	shr    $0x4,%eax
  10771f:	09 c1                	or     %eax,%ecx
  107721:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107724:	d1 e8                	shr    %eax
  107726:	0b 45 dc             	or     -0x24(%ebp),%eax
  107729:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10772c:	d1 ea                	shr    %edx
  10772e:	0b 55 dc             	or     -0x24(%ebp),%edx
  107731:	c1 ea 02             	shr    $0x2,%edx
  107734:	09 d0                	or     %edx,%eax
  107736:	89 c6                	mov    %eax,%esi
  107738:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10773b:	d1 e8                	shr    %eax
  10773d:	0b 45 dc             	or     -0x24(%ebp),%eax
  107740:	89 c2                	mov    %eax,%edx
  107742:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107745:	d1 e8                	shr    %eax
  107747:	0b 45 dc             	or     -0x24(%ebp),%eax
  10774a:	c1 e8 02             	shr    $0x2,%eax
  10774d:	09 d0                	or     %edx,%eax
  10774f:	c1 e8 04             	shr    $0x4,%eax
  107752:	09 f0                	or     %esi,%eax
  107754:	c1 e8 08             	shr    $0x8,%eax
  107757:	09 c8                	or     %ecx,%eax
  107759:	c1 e8 10             	shr    $0x10,%eax
  10775c:	09 d8                	or     %ebx,%eax
  10775e:	d1 e8                	shr    %eax
  107760:	f7 d0                	not    %eax
  107762:	23 45 dc             	and    -0x24(%ebp),%eax
  107765:	89 c6                	mov    %eax,%esi
  107767:	eb 03                	jmp    10776c <segment_check+0x204>
  107769:	8b 75 dc             	mov    -0x24(%ebp),%esi
  10776c:	89 f8                	mov    %edi,%eax
  10776e:	ba 00 00 00 00       	mov    $0x0,%edx
  107773:	f7 f6                	div    %esi
  107775:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
  107778:	0f 85 d2 01 00 00    	jne    107950 <segment_check+0x3e8>
            total += BUDDY_LENGTH(block);
  10777e:	a1 50 e9 11 00       	mov    0x11e950,%eax
  107783:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107786:	d1 ea                	shr    %edx
  107788:	0b 55 dc             	or     -0x24(%ebp),%edx
  10778b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10778e:	d1 e9                	shr    %ecx
  107790:	0b 4d dc             	or     -0x24(%ebp),%ecx
  107793:	c1 e9 02             	shr    $0x2,%ecx
  107796:	89 d3                	mov    %edx,%ebx
  107798:	09 cb                	or     %ecx,%ebx
  10779a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10779d:	d1 ea                	shr    %edx
  10779f:	0b 55 dc             	or     -0x24(%ebp),%edx
  1077a2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1077a5:	d1 e9                	shr    %ecx
  1077a7:	0b 4d dc             	or     -0x24(%ebp),%ecx
  1077aa:	c1 e9 02             	shr    $0x2,%ecx
  1077ad:	09 ca                	or     %ecx,%edx
  1077af:	c1 ea 04             	shr    $0x4,%edx
  1077b2:	09 d3                	or     %edx,%ebx
  1077b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1077b7:	d1 ea                	shr    %edx
  1077b9:	0b 55 dc             	or     -0x24(%ebp),%edx
  1077bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1077bf:	d1 e9                	shr    %ecx
  1077c1:	0b 4d dc             	or     -0x24(%ebp),%ecx
  1077c4:	c1 e9 02             	shr    $0x2,%ecx
  1077c7:	89 d6                	mov    %edx,%esi
  1077c9:	09 ce                	or     %ecx,%esi
  1077cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1077ce:	d1 ea                	shr    %edx
  1077d0:	0b 55 dc             	or     -0x24(%ebp),%edx
  1077d3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1077d6:	d1 e9                	shr    %ecx
  1077d8:	0b 4d dc             	or     -0x24(%ebp),%ecx
  1077db:	c1 e9 02             	shr    $0x2,%ecx
  1077de:	09 ca                	or     %ecx,%edx
  1077e0:	c1 ea 04             	shr    $0x4,%edx
  1077e3:	09 f2                	or     %esi,%edx
  1077e5:	c1 ea 08             	shr    $0x8,%edx
  1077e8:	09 d3                	or     %edx,%ebx
  1077ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1077ed:	d1 ea                	shr    %edx
  1077ef:	0b 55 dc             	or     -0x24(%ebp),%edx
  1077f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1077f5:	d1 e9                	shr    %ecx
  1077f7:	0b 4d dc             	or     -0x24(%ebp),%ecx
  1077fa:	c1 e9 02             	shr    $0x2,%ecx
  1077fd:	89 d6                	mov    %edx,%esi
  1077ff:	09 ce                	or     %ecx,%esi
  107801:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107804:	d1 ea                	shr    %edx
  107806:	0b 55 dc             	or     -0x24(%ebp),%edx
  107809:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10780c:	d1 e9                	shr    %ecx
  10780e:	0b 4d dc             	or     -0x24(%ebp),%ecx
  107811:	c1 e9 02             	shr    $0x2,%ecx
  107814:	09 ca                	or     %ecx,%edx
  107816:	c1 ea 04             	shr    $0x4,%edx
  107819:	09 d6                	or     %edx,%esi
  10781b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10781e:	d1 ea                	shr    %edx
  107820:	0b 55 dc             	or     -0x24(%ebp),%edx
  107823:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  107826:	d1 e9                	shr    %ecx
  107828:	0b 4d dc             	or     -0x24(%ebp),%ecx
  10782b:	c1 e9 02             	shr    $0x2,%ecx
  10782e:	89 d7                	mov    %edx,%edi
  107830:	09 cf                	or     %ecx,%edi
  107832:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107835:	d1 ea                	shr    %edx
  107837:	0b 55 dc             	or     -0x24(%ebp),%edx
  10783a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10783d:	d1 e9                	shr    %ecx
  10783f:	0b 4d dc             	or     -0x24(%ebp),%ecx
  107842:	c1 e9 02             	shr    $0x2,%ecx
  107845:	09 ca                	or     %ecx,%edx
  107847:	c1 ea 04             	shr    $0x4,%edx
  10784a:	09 fa                	or     %edi,%edx
  10784c:	c1 ea 08             	shr    $0x8,%edx
  10784f:	09 f2                	or     %esi,%edx
  107851:	c1 ea 10             	shr    $0x10,%edx
  107854:	09 da                	or     %ebx,%edx
  107856:	d1 ea                	shr    %edx
  107858:	23 55 dc             	and    -0x24(%ebp),%edx
  10785b:	85 d2                	test   %edx,%edx
  10785d:	0f 84 de 00 00 00    	je     107941 <segment_check+0x3d9>
  107863:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107866:	d1 ea                	shr    %edx
  107868:	0b 55 dc             	or     -0x24(%ebp),%edx
  10786b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10786e:	d1 e9                	shr    %ecx
  107870:	0b 4d dc             	or     -0x24(%ebp),%ecx
  107873:	c1 e9 02             	shr    $0x2,%ecx
  107876:	89 d3                	mov    %edx,%ebx
  107878:	09 cb                	or     %ecx,%ebx
  10787a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10787d:	d1 ea                	shr    %edx
  10787f:	0b 55 dc             	or     -0x24(%ebp),%edx
  107882:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  107885:	d1 e9                	shr    %ecx
  107887:	0b 4d dc             	or     -0x24(%ebp),%ecx
  10788a:	c1 e9 02             	shr    $0x2,%ecx
  10788d:	09 ca                	or     %ecx,%edx
  10788f:	c1 ea 04             	shr    $0x4,%edx
  107892:	09 d3                	or     %edx,%ebx
  107894:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107897:	d1 ea                	shr    %edx
  107899:	0b 55 dc             	or     -0x24(%ebp),%edx
  10789c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10789f:	d1 e9                	shr    %ecx
  1078a1:	0b 4d dc             	or     -0x24(%ebp),%ecx
  1078a4:	c1 e9 02             	shr    $0x2,%ecx
  1078a7:	89 d6                	mov    %edx,%esi
  1078a9:	09 ce                	or     %ecx,%esi
  1078ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1078ae:	d1 ea                	shr    %edx
  1078b0:	0b 55 dc             	or     -0x24(%ebp),%edx
  1078b3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1078b6:	d1 e9                	shr    %ecx
  1078b8:	0b 4d dc             	or     -0x24(%ebp),%ecx
  1078bb:	c1 e9 02             	shr    $0x2,%ecx
  1078be:	09 ca                	or     %ecx,%edx
  1078c0:	c1 ea 04             	shr    $0x4,%edx
  1078c3:	09 f2                	or     %esi,%edx
  1078c5:	c1 ea 08             	shr    $0x8,%edx
  1078c8:	09 d3                	or     %edx,%ebx
  1078ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1078cd:	d1 ea                	shr    %edx
  1078cf:	0b 55 dc             	or     -0x24(%ebp),%edx
  1078d2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1078d5:	d1 e9                	shr    %ecx
  1078d7:	0b 4d dc             	or     -0x24(%ebp),%ecx
  1078da:	c1 e9 02             	shr    $0x2,%ecx
  1078dd:	89 d6                	mov    %edx,%esi
  1078df:	09 ce                	or     %ecx,%esi
  1078e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1078e4:	d1 ea                	shr    %edx
  1078e6:	0b 55 dc             	or     -0x24(%ebp),%edx
  1078e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1078ec:	d1 e9                	shr    %ecx
  1078ee:	0b 4d dc             	or     -0x24(%ebp),%ecx
  1078f1:	c1 e9 02             	shr    $0x2,%ecx
  1078f4:	09 ca                	or     %ecx,%edx
  1078f6:	c1 ea 04             	shr    $0x4,%edx
  1078f9:	09 d6                	or     %edx,%esi
  1078fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1078fe:	d1 ea                	shr    %edx
  107900:	0b 55 dc             	or     -0x24(%ebp),%edx
  107903:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  107906:	d1 e9                	shr    %ecx
  107908:	0b 4d dc             	or     -0x24(%ebp),%ecx
  10790b:	c1 e9 02             	shr    $0x2,%ecx
  10790e:	89 d7                	mov    %edx,%edi
  107910:	09 cf                	or     %ecx,%edi
  107912:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107915:	d1 ea                	shr    %edx
  107917:	0b 55 dc             	or     -0x24(%ebp),%edx
  10791a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10791d:	d1 e9                	shr    %ecx
  10791f:	0b 4d dc             	or     -0x24(%ebp),%ecx
  107922:	c1 e9 02             	shr    $0x2,%ecx
  107925:	09 ca                	or     %ecx,%edx
  107927:	c1 ea 04             	shr    $0x4,%edx
  10792a:	09 fa                	or     %edi,%edx
  10792c:	c1 ea 08             	shr    $0x8,%edx
  10792f:	09 f2                	or     %esi,%edx
  107931:	c1 ea 10             	shr    $0x10,%edx
  107934:	09 da                	or     %ebx,%edx
  107936:	d1 ea                	shr    %edx
  107938:	f7 d2                	not    %edx
  10793a:	89 d7                	mov    %edx,%edi
  10793c:	23 7d dc             	and    -0x24(%ebp),%edi
  10793f:	eb 03                	jmp    107944 <segment_check+0x3dc>
  107941:	8b 7d dc             	mov    -0x24(%ebp),%edi
  107944:	ba 00 00 00 00       	mov    $0x0,%edx
  107949:	f7 f7                	div    %edi
  10794b:	01 45 e4             	add    %eax,-0x1c(%ebp)
  10794e:	eb 66                	jmp    1079b6 <segment_check+0x44e>
        else if (block < buddy_virtual_size)
  107950:	a1 50 e9 11 00       	mov    0x11e950,%eax
  107955:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  107958:	73 5c                	jae    1079b6 <segment_check+0x44e>
            assert(buddy_segment[block] == (buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)]));
  10795a:	a1 5c e9 11 00       	mov    0x11e95c,%eax
  10795f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107962:	c1 e2 02             	shl    $0x2,%edx
  107965:	01 d0                	add    %edx,%eax
  107967:	8b 00                	mov    (%eax),%eax
  107969:	8b 15 5c e9 11 00    	mov    0x11e95c,%edx
  10796f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  107972:	c1 e1 03             	shl    $0x3,%ecx
  107975:	01 ca                	add    %ecx,%edx
  107977:	8b 0a                	mov    (%edx),%ecx
  107979:	8b 15 5c e9 11 00    	mov    0x11e95c,%edx
  10797f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  107982:	c1 e3 03             	shl    $0x3,%ebx
  107985:	83 c3 04             	add    $0x4,%ebx
  107988:	01 da                	add    %ebx,%edx
  10798a:	8b 12                	mov    (%edx),%edx
  10798c:	09 ca                	or     %ecx,%edx
  10798e:	39 d0                	cmp    %edx,%eax
  107990:	74 24                	je     1079b6 <segment_check+0x44e>
  107992:	c7 44 24 0c c4 ac 10 	movl   $0x10acc4,0xc(%esp)
  107999:	00 
  10799a:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  1079a1:	00 
  1079a2:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  1079a9:	00 
  1079aa:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  1079b1:	e8 32 8a ff ff       	call   1003e8 <__panic>
    for (block = BUDDY_ROOT; block < (buddy_virtual_size<<1); block++)
  1079b6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1079ba:	a1 50 e9 11 00       	mov    0x11e950,%eax
  1079bf:	01 c0                	add    %eax,%eax
  1079c1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1079c4:	0f 87 c1 fb ff ff    	ja     10758b <segment_check+0x23>
    assert(total == nr_free_pages());
  1079ca:	e8 5a b3 ff ff       	call   102d29 <nr_free_pages>
  1079cf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  1079d2:	74 24                	je     1079f8 <segment_check+0x490>
  1079d4:	c7 44 24 0c 23 ad 10 	movl   $0x10ad23,0xc(%esp)
  1079db:	00 
  1079dc:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  1079e3:	00 
  1079e4:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  1079eb:	00 
  1079ec:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  1079f3:	e8 f0 89 ff ff       	call   1003e8 <__panic>

    // Check free list 
    total = 0, count = 0;
  1079f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1079ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    list_entry_t *le = &free_list;
  107a06:	c7 45 d8 78 e9 11 00 	movl   $0x11e978,-0x28(%ebp)
    while ((le = list_next(le)) != &free_list) {
  107a0d:	eb 16                	jmp    107a25 <segment_check+0x4bd>
        struct Page *p = le2page(le, page_link);
  107a0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  107a12:	83 e8 0c             	sub    $0xc,%eax
  107a15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count ++, total += p->property;
  107a18:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  107a1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  107a1f:	8b 40 08             	mov    0x8(%eax),%eax
  107a22:	01 45 e4             	add    %eax,-0x1c(%ebp)
  107a25:	8b 45 d8             	mov    -0x28(%ebp),%eax
  107a28:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return listelm->next;
  107a2b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107a2e:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  107a31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  107a34:	81 7d d8 78 e9 11 00 	cmpl   $0x11e978,-0x28(%ebp)
  107a3b:	75 d2                	jne    107a0f <segment_check+0x4a7>
    }
    assert(total == nr_free_pages());
  107a3d:	e8 e7 b2 ff ff       	call   102d29 <nr_free_pages>
  107a42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  107a45:	74 24                	je     107a6b <segment_check+0x503>
  107a47:	c7 44 24 0c 23 ad 10 	movl   $0x10ad23,0xc(%esp)
  107a4e:	00 
  107a4f:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107a56:	00 
  107a57:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  107a5e:	00 
  107a5f:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107a66:	e8 7d 89 ff ff       	call   1003e8 <__panic>

}
  107a6b:	83 c4 4c             	add    $0x4c,%esp
  107a6e:	5b                   	pop    %ebx
  107a6f:	5e                   	pop    %esi
  107a70:	5f                   	pop    %edi
  107a71:	5d                   	pop    %ebp
  107a72:	c3                   	ret    

00107a73 <alloc_check>:

static void
alloc_check(void) {
  107a73:	55                   	push   %ebp
  107a74:	89 e5                	mov    %esp,%ebp
  107a76:	83 ec 58             	sub    $0x58,%esp

    // Build buddy system for test
    size_t buddy_physical_size_store = buddy_physical_size;
  107a79:	a1 4c e9 11 00       	mov    0x11e94c,%eax
  107a7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    struct Page *tmp1;
    for (tmp1 = buddy_physical; tmp1 < buddy_physical + 1026; tmp1++)
  107a81:	a1 60 e9 11 00       	mov    0x11e960,%eax
  107a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  107a89:	eb 1d                	jmp    107aa8 <alloc_check+0x35>
        SetPageReserved(tmp1);
  107a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  107a8e:	83 c0 04             	add    $0x4,%eax
  107a91:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  107a98:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  107a9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  107a9e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107aa1:	0f ab 10             	bts    %edx,(%eax)
    for (tmp1 = buddy_physical; tmp1 < buddy_physical + 1026; tmp1++)
  107aa4:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  107aa8:	a1 60 e9 11 00       	mov    0x11e960,%eax
  107aad:	05 28 50 00 00       	add    $0x5028,%eax
  107ab2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  107ab5:	77 d4                	ja     107a8b <alloc_check+0x18>
    buddy_init();
  107ab7:	e8 d5 d6 ff ff       	call   105191 <buddy_init>
    buddy_init_memmap(buddy_physical, 1026);
  107abc:	a1 60 e9 11 00       	mov    0x11e960,%eax
  107ac1:	c7 44 24 04 02 04 00 	movl   $0x402,0x4(%esp)
  107ac8:	00 
  107ac9:	89 04 24             	mov    %eax,(%esp)
  107acc:	e8 ed d6 ff ff       	call   1051be <buddy_init_memmap>

    // Check allocation
    struct Page *p0, *p1, *p2, *p3;
    p0 = p1 = p2 = NULL;
  107ad1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  107ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107adb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  107ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107ae1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert((p0 = alloc_page()) != NULL);
  107ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  107aeb:	e8 cf b1 ff ff       	call   102cbf <alloc_pages>
  107af0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  107af3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  107af7:	75 24                	jne    107b1d <alloc_check+0xaa>
  107af9:	c7 44 24 0c 3c ad 10 	movl   $0x10ad3c,0xc(%esp)
  107b00:	00 
  107b01:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107b08:	00 
  107b09:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  107b10:	00 
  107b11:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107b18:	e8 cb 88 ff ff       	call   1003e8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  107b1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  107b24:	e8 96 b1 ff ff       	call   102cbf <alloc_pages>
  107b29:	89 45 e0             	mov    %eax,-0x20(%ebp)
  107b2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  107b30:	75 24                	jne    107b56 <alloc_check+0xe3>
  107b32:	c7 44 24 0c 58 ad 10 	movl   $0x10ad58,0xc(%esp)
  107b39:	00 
  107b3a:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107b41:	00 
  107b42:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  107b49:	00 
  107b4a:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107b51:	e8 92 88 ff ff       	call   1003e8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  107b56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  107b5d:	e8 5d b1 ff ff       	call   102cbf <alloc_pages>
  107b62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  107b65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  107b69:	75 24                	jne    107b8f <alloc_check+0x11c>
  107b6b:	c7 44 24 0c 74 ad 10 	movl   $0x10ad74,0xc(%esp)
  107b72:	00 
  107b73:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107b7a:	00 
  107b7b:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  107b82:	00 
  107b83:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107b8a:	e8 59 88 ff ff       	call   1003e8 <__panic>
    assert((p3 = alloc_page()) != NULL);
  107b8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  107b96:	e8 24 b1 ff ff       	call   102cbf <alloc_pages>
  107b9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  107b9e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  107ba2:	75 24                	jne    107bc8 <alloc_check+0x155>
  107ba4:	c7 44 24 0c 90 ad 10 	movl   $0x10ad90,0xc(%esp)
  107bab:	00 
  107bac:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107bb3:	00 
  107bb4:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  107bbb:	00 
  107bbc:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107bc3:	e8 20 88 ff ff       	call   1003e8 <__panic>

    assert(p0 + 1 == p1);
  107bc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107bcb:	83 c0 14             	add    $0x14,%eax
  107bce:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  107bd1:	74 24                	je     107bf7 <alloc_check+0x184>
  107bd3:	c7 44 24 0c ac ad 10 	movl   $0x10adac,0xc(%esp)
  107bda:	00 
  107bdb:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107be2:	00 
  107be3:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  107bea:	00 
  107beb:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107bf2:	e8 f1 87 ff ff       	call   1003e8 <__panic>
    assert(p1 + 1 == p2);
  107bf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107bfa:	83 c0 14             	add    $0x14,%eax
  107bfd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  107c00:	74 24                	je     107c26 <alloc_check+0x1b3>
  107c02:	c7 44 24 0c b9 ad 10 	movl   $0x10adb9,0xc(%esp)
  107c09:	00 
  107c0a:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107c11:	00 
  107c12:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  107c19:	00 
  107c1a:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107c21:	e8 c2 87 ff ff       	call   1003e8 <__panic>
    assert(p2 + 1 == p3);
  107c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107c29:	83 c0 14             	add    $0x14,%eax
  107c2c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  107c2f:	74 24                	je     107c55 <alloc_check+0x1e2>
  107c31:	c7 44 24 0c c6 ad 10 	movl   $0x10adc6,0xc(%esp)
  107c38:	00 
  107c39:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107c40:	00 
  107c41:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  107c48:	00 
  107c49:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107c50:	e8 93 87 ff ff       	call   1003e8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0 && page_ref(p3) == 0);
  107c55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107c58:	89 04 24             	mov    %eax,(%esp)
  107c5b:	e8 d3 c7 ff ff       	call   104433 <page_ref>
  107c60:	85 c0                	test   %eax,%eax
  107c62:	75 2d                	jne    107c91 <alloc_check+0x21e>
  107c64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107c67:	89 04 24             	mov    %eax,(%esp)
  107c6a:	e8 c4 c7 ff ff       	call   104433 <page_ref>
  107c6f:	85 c0                	test   %eax,%eax
  107c71:	75 1e                	jne    107c91 <alloc_check+0x21e>
  107c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107c76:	89 04 24             	mov    %eax,(%esp)
  107c79:	e8 b5 c7 ff ff       	call   104433 <page_ref>
  107c7e:	85 c0                	test   %eax,%eax
  107c80:	75 0f                	jne    107c91 <alloc_check+0x21e>
  107c82:	8b 45 d8             	mov    -0x28(%ebp),%eax
  107c85:	89 04 24             	mov    %eax,(%esp)
  107c88:	e8 a6 c7 ff ff       	call   104433 <page_ref>
  107c8d:	85 c0                	test   %eax,%eax
  107c8f:	74 24                	je     107cb5 <alloc_check+0x242>
  107c91:	c7 44 24 0c d4 ad 10 	movl   $0x10add4,0xc(%esp)
  107c98:	00 
  107c99:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107ca0:	00 
  107ca1:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  107ca8:	00 
  107ca9:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107cb0:	e8 33 87 ff ff       	call   1003e8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  107cb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107cb8:	89 04 24             	mov    %eax,(%esp)
  107cbb:	e8 5d c7 ff ff       	call   10441d <page2pa>
  107cc0:	8b 15 c0 e8 11 00    	mov    0x11e8c0,%edx
  107cc6:	c1 e2 0c             	shl    $0xc,%edx
  107cc9:	39 d0                	cmp    %edx,%eax
  107ccb:	72 24                	jb     107cf1 <alloc_check+0x27e>
  107ccd:	c7 44 24 0c 25 ae 10 	movl   $0x10ae25,0xc(%esp)
  107cd4:	00 
  107cd5:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107cdc:	00 
  107cdd:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  107ce4:	00 
  107ce5:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107cec:	e8 f7 86 ff ff       	call   1003e8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  107cf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107cf4:	89 04 24             	mov    %eax,(%esp)
  107cf7:	e8 21 c7 ff ff       	call   10441d <page2pa>
  107cfc:	8b 15 c0 e8 11 00    	mov    0x11e8c0,%edx
  107d02:	c1 e2 0c             	shl    $0xc,%edx
  107d05:	39 d0                	cmp    %edx,%eax
  107d07:	72 24                	jb     107d2d <alloc_check+0x2ba>
  107d09:	c7 44 24 0c 42 ae 10 	movl   $0x10ae42,0xc(%esp)
  107d10:	00 
  107d11:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107d18:	00 
  107d19:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  107d20:	00 
  107d21:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107d28:	e8 bb 86 ff ff       	call   1003e8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  107d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107d30:	89 04 24             	mov    %eax,(%esp)
  107d33:	e8 e5 c6 ff ff       	call   10441d <page2pa>
  107d38:	8b 15 c0 e8 11 00    	mov    0x11e8c0,%edx
  107d3e:	c1 e2 0c             	shl    $0xc,%edx
  107d41:	39 d0                	cmp    %edx,%eax
  107d43:	72 24                	jb     107d69 <alloc_check+0x2f6>
  107d45:	c7 44 24 0c 5f ae 10 	movl   $0x10ae5f,0xc(%esp)
  107d4c:	00 
  107d4d:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107d54:	00 
  107d55:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  107d5c:	00 
  107d5d:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107d64:	e8 7f 86 ff ff       	call   1003e8 <__panic>
    assert(page2pa(p3) < npage * PGSIZE);
  107d69:	8b 45 d8             	mov    -0x28(%ebp),%eax
  107d6c:	89 04 24             	mov    %eax,(%esp)
  107d6f:	e8 a9 c6 ff ff       	call   10441d <page2pa>
  107d74:	8b 15 c0 e8 11 00    	mov    0x11e8c0,%edx
  107d7a:	c1 e2 0c             	shl    $0xc,%edx
  107d7d:	39 d0                	cmp    %edx,%eax
  107d7f:	72 24                	jb     107da5 <alloc_check+0x332>
  107d81:	c7 44 24 0c 7c ae 10 	movl   $0x10ae7c,0xc(%esp)
  107d88:	00 
  107d89:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107d90:	00 
  107d91:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
  107d98:	00 
  107d99:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107da0:	e8 43 86 ff ff       	call   1003e8 <__panic>

    list_entry_t *le = &free_list;
  107da5:	c7 45 f0 78 e9 11 00 	movl   $0x11e978,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  107dac:	eb 3f                	jmp    107ded <alloc_check+0x37a>
        struct Page *p = le2page(le, page_link);
  107dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107db1:	83 e8 0c             	sub    $0xc,%eax
  107db4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(buddy_alloc_pages(p->property) != NULL);
  107db7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  107dba:	8b 40 08             	mov    0x8(%eax),%eax
  107dbd:	89 04 24             	mov    %eax,(%esp)
  107dc0:	e8 d0 d4 ff ff       	call   105295 <buddy_alloc_pages>
  107dc5:	85 c0                	test   %eax,%eax
  107dc7:	75 24                	jne    107ded <alloc_check+0x37a>
  107dc9:	c7 44 24 0c 9c ae 10 	movl   $0x10ae9c,0xc(%esp)
  107dd0:	00 
  107dd1:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107dd8:	00 
  107dd9:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
  107de0:	00 
  107de1:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107de8:	e8 fb 85 ff ff       	call   1003e8 <__panic>
  107ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107df0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  107df3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  107df6:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  107df9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107dfc:	81 7d f0 78 e9 11 00 	cmpl   $0x11e978,-0x10(%ebp)
  107e03:	75 a9                	jne    107dae <alloc_check+0x33b>
    }

    assert(alloc_page() == NULL);
  107e05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  107e0c:	e8 ae ae ff ff       	call   102cbf <alloc_pages>
  107e11:	85 c0                	test   %eax,%eax
  107e13:	74 24                	je     107e39 <alloc_check+0x3c6>
  107e15:	c7 44 24 0c c3 ae 10 	movl   $0x10aec3,0xc(%esp)
  107e1c:	00 
  107e1d:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107e24:	00 
  107e25:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
  107e2c:	00 
  107e2d:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107e34:	e8 af 85 ff ff       	call   1003e8 <__panic>

    // Check release
    free_page(p0);
  107e39:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  107e40:	00 
  107e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107e44:	89 04 24             	mov    %eax,(%esp)
  107e47:	e8 ab ae ff ff       	call   102cf7 <free_pages>
    free_page(p1);
  107e4c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  107e53:	00 
  107e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107e57:	89 04 24             	mov    %eax,(%esp)
  107e5a:	e8 98 ae ff ff       	call   102cf7 <free_pages>
    free_page(p2);
  107e5f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  107e66:	00 
  107e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107e6a:	89 04 24             	mov    %eax,(%esp)
  107e6d:	e8 85 ae ff ff       	call   102cf7 <free_pages>
    assert(nr_free == 3);
  107e72:	a1 80 e9 11 00       	mov    0x11e980,%eax
  107e77:	83 f8 03             	cmp    $0x3,%eax
  107e7a:	74 24                	je     107ea0 <alloc_check+0x42d>
  107e7c:	c7 44 24 0c d8 ae 10 	movl   $0x10aed8,0xc(%esp)
  107e83:	00 
  107e84:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107e8b:	00 
  107e8c:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  107e93:	00 
  107e94:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107e9b:	e8 48 85 ff ff       	call   1003e8 <__panic>

    assert((p1 = alloc_page()) != NULL);
  107ea0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  107ea7:	e8 13 ae ff ff       	call   102cbf <alloc_pages>
  107eac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  107eaf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  107eb3:	75 24                	jne    107ed9 <alloc_check+0x466>
  107eb5:	c7 44 24 0c 58 ad 10 	movl   $0x10ad58,0xc(%esp)
  107ebc:	00 
  107ebd:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107ec4:	00 
  107ec5:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  107ecc:	00 
  107ecd:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107ed4:	e8 0f 85 ff ff       	call   1003e8 <__panic>
    assert((p0 = alloc_pages(2)) != NULL);
  107ed9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  107ee0:	e8 da ad ff ff       	call   102cbf <alloc_pages>
  107ee5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  107ee8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  107eec:	75 24                	jne    107f12 <alloc_check+0x49f>
  107eee:	c7 44 24 0c e5 ae 10 	movl   $0x10aee5,0xc(%esp)
  107ef5:	00 
  107ef6:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107efd:	00 
  107efe:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
  107f05:	00 
  107f06:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107f0d:	e8 d6 84 ff ff       	call   1003e8 <__panic>
    assert(p0 + 2 == p1);
  107f12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107f15:	83 c0 28             	add    $0x28,%eax
  107f18:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  107f1b:	74 24                	je     107f41 <alloc_check+0x4ce>
  107f1d:	c7 44 24 0c 03 af 10 	movl   $0x10af03,0xc(%esp)
  107f24:	00 
  107f25:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107f2c:	00 
  107f2d:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
  107f34:	00 
  107f35:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107f3c:	e8 a7 84 ff ff       	call   1003e8 <__panic>

    assert(alloc_page() == NULL);
  107f41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  107f48:	e8 72 ad ff ff       	call   102cbf <alloc_pages>
  107f4d:	85 c0                	test   %eax,%eax
  107f4f:	74 24                	je     107f75 <alloc_check+0x502>
  107f51:	c7 44 24 0c c3 ae 10 	movl   $0x10aec3,0xc(%esp)
  107f58:	00 
  107f59:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107f60:	00 
  107f61:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
  107f68:	00 
  107f69:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107f70:	e8 73 84 ff ff       	call   1003e8 <__panic>

    free_pages(p0, 2);
  107f75:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  107f7c:	00 
  107f7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107f80:	89 04 24             	mov    %eax,(%esp)
  107f83:	e8 6f ad ff ff       	call   102cf7 <free_pages>
    free_page(p1);
  107f88:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  107f8f:	00 
  107f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107f93:	89 04 24             	mov    %eax,(%esp)
  107f96:	e8 5c ad ff ff       	call   102cf7 <free_pages>
    free_page(p3);
  107f9b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  107fa2:	00 
  107fa3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  107fa6:	89 04 24             	mov    %eax,(%esp)
  107fa9:	e8 49 ad ff ff       	call   102cf7 <free_pages>

    struct Page *p;
    assert((p = alloc_pages(4)) == p0);
  107fae:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  107fb5:	e8 05 ad ff ff       	call   102cbf <alloc_pages>
  107fba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  107fbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107fc0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  107fc3:	74 24                	je     107fe9 <alloc_check+0x576>
  107fc5:	c7 44 24 0c 10 af 10 	movl   $0x10af10,0xc(%esp)
  107fcc:	00 
  107fcd:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  107fd4:	00 
  107fd5:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  107fdc:	00 
  107fdd:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  107fe4:	e8 ff 83 ff ff       	call   1003e8 <__panic>
    assert(alloc_page() == NULL);
  107fe9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  107ff0:	e8 ca ac ff ff       	call   102cbf <alloc_pages>
  107ff5:	85 c0                	test   %eax,%eax
  107ff7:	74 24                	je     10801d <alloc_check+0x5aa>
  107ff9:	c7 44 24 0c c3 ae 10 	movl   $0x10aec3,0xc(%esp)
  108000:	00 
  108001:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  108008:	00 
  108009:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
  108010:	00 
  108011:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  108018:	e8 cb 83 ff ff       	call   1003e8 <__panic>

    assert(nr_free == 0);
  10801d:	a1 80 e9 11 00       	mov    0x11e980,%eax
  108022:	85 c0                	test   %eax,%eax
  108024:	74 24                	je     10804a <alloc_check+0x5d7>
  108026:	c7 44 24 0c 2b af 10 	movl   $0x10af2b,0xc(%esp)
  10802d:	00 
  10802e:	c7 44 24 08 96 ab 10 	movl   $0x10ab96,0x8(%esp)
  108035:	00 
  108036:	c7 44 24 04 55 01 00 	movl   $0x155,0x4(%esp)
  10803d:	00 
  10803e:	c7 04 24 ab ab 10 00 	movl   $0x10abab,(%esp)
  108045:	e8 9e 83 ff ff       	call   1003e8 <__panic>

    // Restore buddy system
    struct Page *tmp2;
    for (tmp2 = buddy_physical; tmp2 < buddy_physical + buddy_physical_size_store; tmp2++)
  10804a:	a1 60 e9 11 00       	mov    0x11e960,%eax
  10804f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  108052:	eb 1d                	jmp    108071 <alloc_check+0x5fe>
        SetPageReserved(tmp2);
  108054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  108057:	83 c0 04             	add    $0x4,%eax
  10805a:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  108061:	89 45 bc             	mov    %eax,-0x44(%ebp)
  108064:	8b 45 bc             	mov    -0x44(%ebp),%eax
  108067:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10806a:	0f ab 10             	bts    %edx,(%eax)
    for (tmp2 = buddy_physical; tmp2 < buddy_physical + buddy_physical_size_store; tmp2++)
  10806d:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  108071:	8b 0d 60 e9 11 00    	mov    0x11e960,%ecx
  108077:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10807a:	89 d0                	mov    %edx,%eax
  10807c:	c1 e0 02             	shl    $0x2,%eax
  10807f:	01 d0                	add    %edx,%eax
  108081:	c1 e0 02             	shl    $0x2,%eax
  108084:	01 c8                	add    %ecx,%eax
  108086:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  108089:	77 c9                	ja     108054 <alloc_check+0x5e1>
    buddy_init();
  10808b:	e8 01 d1 ff ff       	call   105191 <buddy_init>
    buddy_init_memmap(buddy_physical, buddy_physical_size_store);
  108090:	a1 60 e9 11 00       	mov    0x11e960,%eax
  108095:	8b 55 e8             	mov    -0x18(%ebp),%edx
  108098:	89 54 24 04          	mov    %edx,0x4(%esp)
  10809c:	89 04 24             	mov    %eax,(%esp)
  10809f:	e8 1a d1 ff ff       	call   1051be <buddy_init_memmap>

}
  1080a4:	c9                   	leave  
  1080a5:	c3                   	ret    

001080a6 <default_check>:

static void
default_check(void) {
  1080a6:	55                   	push   %ebp
  1080a7:	89 e5                	mov    %esp,%ebp
  1080a9:	83 ec 08             	sub    $0x8,%esp

    // Check buddy system
    macro_check();
  1080ac:	e8 23 f2 ff ff       	call   1072d4 <macro_check>
    size_check();
  1080b1:	e8 6b f3 ff ff       	call   107421 <size_check>
    segment_check();
  1080b6:	e8 ad f4 ff ff       	call   107568 <segment_check>
    alloc_check();
  1080bb:	e8 b3 f9 ff ff       	call   107a73 <alloc_check>
    
}
  1080c0:	c9                   	leave  
  1080c1:	c3                   	ret    

001080c2 <page2ppn>:
page2ppn(struct Page *page) {
  1080c2:	55                   	push   %ebp
  1080c3:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1080c5:	8b 55 08             	mov    0x8(%ebp),%edx
  1080c8:	a1 74 e9 11 00       	mov    0x11e974,%eax
  1080cd:	29 c2                	sub    %eax,%edx
  1080cf:	89 d0                	mov    %edx,%eax
  1080d1:	c1 f8 02             	sar    $0x2,%eax
  1080d4:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1080da:	5d                   	pop    %ebp
  1080db:	c3                   	ret    

001080dc <page2pa>:
page2pa(struct Page *page) {
  1080dc:	55                   	push   %ebp
  1080dd:	89 e5                	mov    %esp,%ebp
  1080df:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1080e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1080e5:	89 04 24             	mov    %eax,(%esp)
  1080e8:	e8 d5 ff ff ff       	call   1080c2 <page2ppn>
  1080ed:	c1 e0 0c             	shl    $0xc,%eax
}
  1080f0:	c9                   	leave  
  1080f1:	c3                   	ret    

001080f2 <page_ref>:
page_ref(struct Page *page) {
  1080f2:	55                   	push   %ebp
  1080f3:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1080f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1080f8:	8b 00                	mov    (%eax),%eax
}
  1080fa:	5d                   	pop    %ebp
  1080fb:	c3                   	ret    

001080fc <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1080fc:	55                   	push   %ebp
  1080fd:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1080ff:	8b 45 08             	mov    0x8(%ebp),%eax
  108102:	8b 55 0c             	mov    0xc(%ebp),%edx
  108105:	89 10                	mov    %edx,(%eax)
}
  108107:	5d                   	pop    %ebp
  108108:	c3                   	ret    

00108109 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  108109:	55                   	push   %ebp
  10810a:	89 e5                	mov    %esp,%ebp
  10810c:	83 ec 10             	sub    $0x10,%esp
  10810f:	c7 45 fc 78 e9 11 00 	movl   $0x11e978,-0x4(%ebp)
    elm->prev = elm->next = elm;
  108116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  108119:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10811c:	89 50 04             	mov    %edx,0x4(%eax)
  10811f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  108122:	8b 50 04             	mov    0x4(%eax),%edx
  108125:	8b 45 fc             	mov    -0x4(%ebp),%eax
  108128:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10812a:	c7 05 80 e9 11 00 00 	movl   $0x0,0x11e980
  108131:	00 00 00 
}
  108134:	c9                   	leave  
  108135:	c3                   	ret    

00108136 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  108136:	55                   	push   %ebp
  108137:	89 e5                	mov    %esp,%ebp
  108139:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  10813c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  108140:	75 24                	jne    108166 <default_init_memmap+0x30>
  108142:	c7 44 24 0c 68 af 10 	movl   $0x10af68,0xc(%esp)
  108149:	00 
  10814a:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108151:	00 
  108152:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  108159:	00 
  10815a:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108161:	e8 82 82 ff ff       	call   1003e8 <__panic>
    struct Page *p = base;
  108166:	8b 45 08             	mov    0x8(%ebp),%eax
  108169:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10816c:	eb 7d                	jmp    1081eb <default_init_memmap+0xb5>
        assert(PageReserved(p));
  10816e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108171:	83 c0 04             	add    $0x4,%eax
  108174:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10817b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10817e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  108181:	8b 55 f0             	mov    -0x10(%ebp),%edx
  108184:	0f a3 10             	bt     %edx,(%eax)
  108187:	19 c0                	sbb    %eax,%eax
  108189:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10818c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  108190:	0f 95 c0             	setne  %al
  108193:	0f b6 c0             	movzbl %al,%eax
  108196:	85 c0                	test   %eax,%eax
  108198:	75 24                	jne    1081be <default_init_memmap+0x88>
  10819a:	c7 44 24 0c 99 af 10 	movl   $0x10af99,0xc(%esp)
  1081a1:	00 
  1081a2:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1081a9:	00 
  1081aa:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  1081b1:	00 
  1081b2:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1081b9:	e8 2a 82 ff ff       	call   1003e8 <__panic>
        p->flags = p->property = 0;
  1081be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1081c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1081c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1081cb:	8b 50 08             	mov    0x8(%eax),%edx
  1081ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1081d1:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1081d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1081db:	00 
  1081dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1081df:	89 04 24             	mov    %eax,(%esp)
  1081e2:	e8 15 ff ff ff       	call   1080fc <set_page_ref>
    for (; p != base + n; p ++) {
  1081e7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1081eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1081ee:	89 d0                	mov    %edx,%eax
  1081f0:	c1 e0 02             	shl    $0x2,%eax
  1081f3:	01 d0                	add    %edx,%eax
  1081f5:	c1 e0 02             	shl    $0x2,%eax
  1081f8:	89 c2                	mov    %eax,%edx
  1081fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1081fd:	01 d0                	add    %edx,%eax
  1081ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  108202:	0f 85 66 ff ff ff    	jne    10816e <default_init_memmap+0x38>
    }
    base->property = n;
  108208:	8b 45 08             	mov    0x8(%ebp),%eax
  10820b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10820e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  108211:	8b 45 08             	mov    0x8(%ebp),%eax
  108214:	83 c0 04             	add    $0x4,%eax
  108217:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  10821e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  108221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  108224:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  108227:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  10822a:	8b 15 80 e9 11 00    	mov    0x11e980,%edx
  108230:	8b 45 0c             	mov    0xc(%ebp),%eax
  108233:	01 d0                	add    %edx,%eax
  108235:	a3 80 e9 11 00       	mov    %eax,0x11e980
    list_add_before(&free_list, &(base->page_link));
  10823a:	8b 45 08             	mov    0x8(%ebp),%eax
  10823d:	83 c0 0c             	add    $0xc,%eax
  108240:	c7 45 dc 78 e9 11 00 	movl   $0x11e978,-0x24(%ebp)
  108247:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_add(elm, listelm->prev, listelm);
  10824a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10824d:	8b 00                	mov    (%eax),%eax
  10824f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  108252:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  108255:	89 45 d0             	mov    %eax,-0x30(%ebp)
  108258:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10825b:	89 45 cc             	mov    %eax,-0x34(%ebp)
    prev->next = next->prev = elm;
  10825e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108261:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  108264:	89 10                	mov    %edx,(%eax)
  108266:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108269:	8b 10                	mov    (%eax),%edx
  10826b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10826e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  108271:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  108274:	8b 55 cc             	mov    -0x34(%ebp),%edx
  108277:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10827a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10827d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108280:	89 10                	mov    %edx,(%eax)
}
  108282:	c9                   	leave  
  108283:	c3                   	ret    

00108284 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  108284:	55                   	push   %ebp
  108285:	89 e5                	mov    %esp,%ebp
  108287:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);//判断n是否大于0
  10828a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10828e:	75 24                	jne    1082b4 <default_alloc_pages+0x30>
  108290:	c7 44 24 0c 68 af 10 	movl   $0x10af68,0xc(%esp)
  108297:	00 
  108298:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  10829f:	00 
  1082a0:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  1082a7:	00 
  1082a8:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1082af:	e8 34 81 ff ff       	call   1003e8 <__panic>
    if (n > nr_free) {//需要分配页的个数小于空闲页的总数,直接返回
  1082b4:	a1 80 e9 11 00       	mov    0x11e980,%eax
  1082b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  1082bc:	73 0a                	jae    1082c8 <default_alloc_pages+0x44>
        return NULL;
  1082be:	b8 00 00 00 00       	mov    $0x0,%eax
  1082c3:	e9 3d 01 00 00       	jmp    108405 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
  1082c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1082cf:	c7 45 f0 78 e9 11 00 	movl   $0x11e978,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
  1082d6:	eb 1c                	jmp    1082f4 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  1082d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1082db:	83 e8 0c             	sub    $0xc,%eax
  1082de:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  1082e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1082e4:	8b 40 08             	mov    0x8(%eax),%eax
  1082e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  1082ea:	72 08                	jb     1082f4 <default_alloc_pages+0x70>
            page = p;
  1082ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1082ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  1082f2:	eb 18                	jmp    10830c <default_alloc_pages+0x88>
  1082f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1082f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  1082fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1082fd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  108300:	89 45 f0             	mov    %eax,-0x10(%ebp)
  108303:	81 7d f0 78 e9 11 00 	cmpl   $0x11e978,-0x10(%ebp)
  10830a:	75 cc                	jne    1082d8 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
  10830c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  108310:	0f 84 ec 00 00 00    	je     108402 <default_alloc_pages+0x17e>
        if (page->property > n) {
  108316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108319:	8b 40 08             	mov    0x8(%eax),%eax
  10831c:	3b 45 08             	cmp    0x8(%ebp),%eax
  10831f:	0f 86 8c 00 00 00    	jbe    1083b1 <default_alloc_pages+0x12d>
            struct Page *p = page + n;
  108325:	8b 55 08             	mov    0x8(%ebp),%edx
  108328:	89 d0                	mov    %edx,%eax
  10832a:	c1 e0 02             	shl    $0x2,%eax
  10832d:	01 d0                	add    %edx,%eax
  10832f:	c1 e0 02             	shl    $0x2,%eax
  108332:	89 c2                	mov    %eax,%edx
  108334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108337:	01 d0                	add    %edx,%eax
  108339:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  10833c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10833f:	8b 40 08             	mov    0x8(%eax),%eax
  108342:	2b 45 08             	sub    0x8(%ebp),%eax
  108345:	89 c2                	mov    %eax,%edx
  108347:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10834a:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  10834d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  108350:	83 c0 04             	add    $0x4,%eax
  108353:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10835a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10835d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108360:	8b 55 e0             	mov    -0x20(%ebp),%edx
  108363:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  108366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  108369:	83 c0 0c             	add    $0xc,%eax
  10836c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10836f:	83 c2 0c             	add    $0xc,%edx
  108372:	89 55 d8             	mov    %edx,-0x28(%ebp)
  108375:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  108378:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10837b:	8b 40 04             	mov    0x4(%eax),%eax
  10837e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  108381:	89 55 d0             	mov    %edx,-0x30(%ebp)
  108384:	8b 55 d8             	mov    -0x28(%ebp),%edx
  108387:	89 55 cc             	mov    %edx,-0x34(%ebp)
  10838a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  10838d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  108390:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108393:	89 10                	mov    %edx,(%eax)
  108395:	8b 45 c8             	mov    -0x38(%ebp),%eax
  108398:	8b 10                	mov    (%eax),%edx
  10839a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10839d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1083a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1083a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1083a6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1083a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1083ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1083af:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
  1083b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1083b4:	83 c0 0c             	add    $0xc,%eax
  1083b7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  1083ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1083bd:	8b 40 04             	mov    0x4(%eax),%eax
  1083c0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1083c3:	8b 12                	mov    (%edx),%edx
  1083c5:	89 55 c0             	mov    %edx,-0x40(%ebp)
  1083c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  1083cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1083ce:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1083d1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1083d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1083d7:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1083da:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  1083dc:	a1 80 e9 11 00       	mov    0x11e980,%eax
  1083e1:	2b 45 08             	sub    0x8(%ebp),%eax
  1083e4:	a3 80 e9 11 00       	mov    %eax,0x11e980
        ClearPageProperty(page);
  1083e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1083ec:	83 c0 04             	add    $0x4,%eax
  1083ef:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  1083f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1083f9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1083fc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1083ff:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  108402:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  108405:	c9                   	leave  
  108406:	c3                   	ret    

00108407 <default_free_pages>:
    

static void
default_free_pages(struct Page *base, size_t n) {
  108407:	55                   	push   %ebp
  108408:	89 e5                	mov    %esp,%ebp
  10840a:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  108410:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  108414:	75 24                	jne    10843a <default_free_pages+0x33>
  108416:	c7 44 24 0c 68 af 10 	movl   $0x10af68,0xc(%esp)
  10841d:	00 
  10841e:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108425:	00 
  108426:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  10842d:	00 
  10842e:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108435:	e8 ae 7f ff ff       	call   1003e8 <__panic>
    struct Page *p = base;
  10843a:	8b 45 08             	mov    0x8(%ebp),%eax
  10843d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  108440:	e9 9d 00 00 00       	jmp    1084e2 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  108445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108448:	83 c0 04             	add    $0x4,%eax
  10844b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  108452:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  108455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  108458:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10845b:	0f a3 10             	bt     %edx,(%eax)
  10845e:	19 c0                	sbb    %eax,%eax
  108460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  108463:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  108467:	0f 95 c0             	setne  %al
  10846a:	0f b6 c0             	movzbl %al,%eax
  10846d:	85 c0                	test   %eax,%eax
  10846f:	75 2c                	jne    10849d <default_free_pages+0x96>
  108471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108474:	83 c0 04             	add    $0x4,%eax
  108477:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10847e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  108481:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108484:	8b 55 e0             	mov    -0x20(%ebp),%edx
  108487:	0f a3 10             	bt     %edx,(%eax)
  10848a:	19 c0                	sbb    %eax,%eax
  10848c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  10848f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  108493:	0f 95 c0             	setne  %al
  108496:	0f b6 c0             	movzbl %al,%eax
  108499:	85 c0                	test   %eax,%eax
  10849b:	74 24                	je     1084c1 <default_free_pages+0xba>
  10849d:	c7 44 24 0c ac af 10 	movl   $0x10afac,0xc(%esp)
  1084a4:	00 
  1084a5:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1084ac:	00 
  1084ad:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
  1084b4:	00 
  1084b5:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1084bc:	e8 27 7f ff ff       	call   1003e8 <__panic>
        p->flags = 0;
  1084c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1084c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1084cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1084d2:	00 
  1084d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1084d6:	89 04 24             	mov    %eax,(%esp)
  1084d9:	e8 1e fc ff ff       	call   1080fc <set_page_ref>
    for (; p != base + n; p ++) {
  1084de:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1084e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1084e5:	89 d0                	mov    %edx,%eax
  1084e7:	c1 e0 02             	shl    $0x2,%eax
  1084ea:	01 d0                	add    %edx,%eax
  1084ec:	c1 e0 02             	shl    $0x2,%eax
  1084ef:	89 c2                	mov    %eax,%edx
  1084f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1084f4:	01 d0                	add    %edx,%eax
  1084f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1084f9:	0f 85 46 ff ff ff    	jne    108445 <default_free_pages+0x3e>
    }
    base->property = n;
  1084ff:	8b 45 08             	mov    0x8(%ebp),%eax
  108502:	8b 55 0c             	mov    0xc(%ebp),%edx
  108505:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  108508:	8b 45 08             	mov    0x8(%ebp),%eax
  10850b:	83 c0 04             	add    $0x4,%eax
  10850e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  108515:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  108518:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10851b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10851e:	0f ab 10             	bts    %edx,(%eax)
  108521:	c7 45 cc 78 e9 11 00 	movl   $0x11e978,-0x34(%ebp)
    return listelm->next;
  108528:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10852b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  10852e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  108531:	e9 08 01 00 00       	jmp    10863e <default_free_pages+0x237>
        p = le2page(le, page_link);
  108536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108539:	83 e8 0c             	sub    $0xc,%eax
  10853c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10853f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108542:	89 45 c8             	mov    %eax,-0x38(%ebp)
  108545:	8b 45 c8             	mov    -0x38(%ebp),%eax
  108548:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  10854b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
  10854e:	8b 45 08             	mov    0x8(%ebp),%eax
  108551:	8b 50 08             	mov    0x8(%eax),%edx
  108554:	89 d0                	mov    %edx,%eax
  108556:	c1 e0 02             	shl    $0x2,%eax
  108559:	01 d0                	add    %edx,%eax
  10855b:	c1 e0 02             	shl    $0x2,%eax
  10855e:	89 c2                	mov    %eax,%edx
  108560:	8b 45 08             	mov    0x8(%ebp),%eax
  108563:	01 d0                	add    %edx,%eax
  108565:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  108568:	75 5a                	jne    1085c4 <default_free_pages+0x1bd>
            base->property += p->property;
  10856a:	8b 45 08             	mov    0x8(%ebp),%eax
  10856d:	8b 50 08             	mov    0x8(%eax),%edx
  108570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108573:	8b 40 08             	mov    0x8(%eax),%eax
  108576:	01 c2                	add    %eax,%edx
  108578:	8b 45 08             	mov    0x8(%ebp),%eax
  10857b:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  10857e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108581:	83 c0 04             	add    $0x4,%eax
  108584:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  10858b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10858e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  108591:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  108594:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  108597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10859a:	83 c0 0c             	add    $0xc,%eax
  10859d:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  1085a0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1085a3:	8b 40 04             	mov    0x4(%eax),%eax
  1085a6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1085a9:	8b 12                	mov    (%edx),%edx
  1085ab:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1085ae:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
  1085b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1085b4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1085b7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1085ba:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1085bd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1085c0:	89 10                	mov    %edx,(%eax)
  1085c2:	eb 7a                	jmp    10863e <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  1085c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1085c7:	8b 50 08             	mov    0x8(%eax),%edx
  1085ca:	89 d0                	mov    %edx,%eax
  1085cc:	c1 e0 02             	shl    $0x2,%eax
  1085cf:	01 d0                	add    %edx,%eax
  1085d1:	c1 e0 02             	shl    $0x2,%eax
  1085d4:	89 c2                	mov    %eax,%edx
  1085d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1085d9:	01 d0                	add    %edx,%eax
  1085db:	3b 45 08             	cmp    0x8(%ebp),%eax
  1085de:	75 5e                	jne    10863e <default_free_pages+0x237>
            p->property += base->property;
  1085e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1085e3:	8b 50 08             	mov    0x8(%eax),%edx
  1085e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1085e9:	8b 40 08             	mov    0x8(%eax),%eax
  1085ec:	01 c2                	add    %eax,%edx
  1085ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1085f1:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  1085f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1085f7:	83 c0 04             	add    $0x4,%eax
  1085fa:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  108601:	89 45 ac             	mov    %eax,-0x54(%ebp)
  108604:	8b 45 ac             	mov    -0x54(%ebp),%eax
  108607:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10860a:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  10860d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108610:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  108613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108616:	83 c0 0c             	add    $0xc,%eax
  108619:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_del(listelm->prev, listelm->next);
  10861c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10861f:	8b 40 04             	mov    0x4(%eax),%eax
  108622:	8b 55 a8             	mov    -0x58(%ebp),%edx
  108625:	8b 12                	mov    (%edx),%edx
  108627:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  10862a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next;
  10862d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  108630:	8b 55 a0             	mov    -0x60(%ebp),%edx
  108633:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  108636:	8b 45 a0             	mov    -0x60(%ebp),%eax
  108639:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10863c:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
  10863e:	81 7d f0 78 e9 11 00 	cmpl   $0x11e978,-0x10(%ebp)
  108645:	0f 85 eb fe ff ff    	jne    108536 <default_free_pages+0x12f>
        }
    }
    nr_free += n;
  10864b:	8b 15 80 e9 11 00    	mov    0x11e980,%edx
  108651:	8b 45 0c             	mov    0xc(%ebp),%eax
  108654:	01 d0                	add    %edx,%eax
  108656:	a3 80 e9 11 00       	mov    %eax,0x11e980
  10865b:	c7 45 9c 78 e9 11 00 	movl   $0x11e978,-0x64(%ebp)
    return listelm->next;
  108662:	8b 45 9c             	mov    -0x64(%ebp),%eax
  108665:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  108668:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  10866b:	eb 76                	jmp    1086e3 <default_free_pages+0x2dc>
        p = le2page(le, page_link);
  10866d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108670:	83 e8 0c             	sub    $0xc,%eax
  108673:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  108676:	8b 45 08             	mov    0x8(%ebp),%eax
  108679:	8b 50 08             	mov    0x8(%eax),%edx
  10867c:	89 d0                	mov    %edx,%eax
  10867e:	c1 e0 02             	shl    $0x2,%eax
  108681:	01 d0                	add    %edx,%eax
  108683:	c1 e0 02             	shl    $0x2,%eax
  108686:	89 c2                	mov    %eax,%edx
  108688:	8b 45 08             	mov    0x8(%ebp),%eax
  10868b:	01 d0                	add    %edx,%eax
  10868d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  108690:	77 42                	ja     1086d4 <default_free_pages+0x2cd>
            assert(base + base->property != p);
  108692:	8b 45 08             	mov    0x8(%ebp),%eax
  108695:	8b 50 08             	mov    0x8(%eax),%edx
  108698:	89 d0                	mov    %edx,%eax
  10869a:	c1 e0 02             	shl    $0x2,%eax
  10869d:	01 d0                	add    %edx,%eax
  10869f:	c1 e0 02             	shl    $0x2,%eax
  1086a2:	89 c2                	mov    %eax,%edx
  1086a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1086a7:	01 d0                	add    %edx,%eax
  1086a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1086ac:	75 24                	jne    1086d2 <default_free_pages+0x2cb>
  1086ae:	c7 44 24 0c d1 af 10 	movl   $0x10afd1,0xc(%esp)
  1086b5:	00 
  1086b6:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1086bd:	00 
  1086be:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  1086c5:	00 
  1086c6:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1086cd:	e8 16 7d ff ff       	call   1003e8 <__panic>
            break;
  1086d2:	eb 18                	jmp    1086ec <default_free_pages+0x2e5>
  1086d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1086d7:	89 45 98             	mov    %eax,-0x68(%ebp)
  1086da:	8b 45 98             	mov    -0x68(%ebp),%eax
  1086dd:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
  1086e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1086e3:	81 7d f0 78 e9 11 00 	cmpl   $0x11e978,-0x10(%ebp)
  1086ea:	75 81                	jne    10866d <default_free_pages+0x266>
    }
    list_add_before(le, &(base->page_link));
  1086ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1086ef:	8d 50 0c             	lea    0xc(%eax),%edx
  1086f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1086f5:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1086f8:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  1086fb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1086fe:	8b 00                	mov    (%eax),%eax
  108700:	8b 55 90             	mov    -0x70(%ebp),%edx
  108703:	89 55 8c             	mov    %edx,-0x74(%ebp)
  108706:	89 45 88             	mov    %eax,-0x78(%ebp)
  108709:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10870c:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  10870f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  108712:	8b 55 8c             	mov    -0x74(%ebp),%edx
  108715:	89 10                	mov    %edx,(%eax)
  108717:	8b 45 84             	mov    -0x7c(%ebp),%eax
  10871a:	8b 10                	mov    (%eax),%edx
  10871c:	8b 45 88             	mov    -0x78(%ebp),%eax
  10871f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  108722:	8b 45 8c             	mov    -0x74(%ebp),%eax
  108725:	8b 55 84             	mov    -0x7c(%ebp),%edx
  108728:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10872b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10872e:	8b 55 88             	mov    -0x78(%ebp),%edx
  108731:	89 10                	mov    %edx,(%eax)
}
  108733:	c9                   	leave  
  108734:	c3                   	ret    

00108735 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  108735:	55                   	push   %ebp
  108736:	89 e5                	mov    %esp,%ebp
    return nr_free;
  108738:	a1 80 e9 11 00       	mov    0x11e980,%eax
}
  10873d:	5d                   	pop    %ebp
  10873e:	c3                   	ret    

0010873f <basic_check>:

static void
basic_check(void) {
  10873f:	55                   	push   %ebp
  108740:	89 e5                	mov    %esp,%ebp
  108742:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  108745:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10874c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10874f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  108752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108755:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  108758:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10875f:	e8 5b a5 ff ff       	call   102cbf <alloc_pages>
  108764:	89 45 ec             	mov    %eax,-0x14(%ebp)
  108767:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10876b:	75 24                	jne    108791 <basic_check+0x52>
  10876d:	c7 44 24 0c ec af 10 	movl   $0x10afec,0xc(%esp)
  108774:	00 
  108775:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  10877c:	00 
  10877d:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  108784:	00 
  108785:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  10878c:	e8 57 7c ff ff       	call   1003e8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  108791:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108798:	e8 22 a5 ff ff       	call   102cbf <alloc_pages>
  10879d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1087a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1087a4:	75 24                	jne    1087ca <basic_check+0x8b>
  1087a6:	c7 44 24 0c 08 b0 10 	movl   $0x10b008,0xc(%esp)
  1087ad:	00 
  1087ae:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1087b5:	00 
  1087b6:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  1087bd:	00 
  1087be:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1087c5:	e8 1e 7c ff ff       	call   1003e8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1087ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1087d1:	e8 e9 a4 ff ff       	call   102cbf <alloc_pages>
  1087d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1087d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1087dd:	75 24                	jne    108803 <basic_check+0xc4>
  1087df:	c7 44 24 0c 24 b0 10 	movl   $0x10b024,0xc(%esp)
  1087e6:	00 
  1087e7:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1087ee:	00 
  1087ef:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
  1087f6:	00 
  1087f7:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1087fe:	e8 e5 7b ff ff       	call   1003e8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  108803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  108806:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  108809:	74 10                	je     10881b <basic_check+0xdc>
  10880b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10880e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  108811:	74 08                	je     10881b <basic_check+0xdc>
  108813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108816:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  108819:	75 24                	jne    10883f <basic_check+0x100>
  10881b:	c7 44 24 0c 40 b0 10 	movl   $0x10b040,0xc(%esp)
  108822:	00 
  108823:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  10882a:	00 
  10882b:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  108832:	00 
  108833:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  10883a:	e8 a9 7b ff ff       	call   1003e8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  10883f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  108842:	89 04 24             	mov    %eax,(%esp)
  108845:	e8 a8 f8 ff ff       	call   1080f2 <page_ref>
  10884a:	85 c0                	test   %eax,%eax
  10884c:	75 1e                	jne    10886c <basic_check+0x12d>
  10884e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108851:	89 04 24             	mov    %eax,(%esp)
  108854:	e8 99 f8 ff ff       	call   1080f2 <page_ref>
  108859:	85 c0                	test   %eax,%eax
  10885b:	75 0f                	jne    10886c <basic_check+0x12d>
  10885d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108860:	89 04 24             	mov    %eax,(%esp)
  108863:	e8 8a f8 ff ff       	call   1080f2 <page_ref>
  108868:	85 c0                	test   %eax,%eax
  10886a:	74 24                	je     108890 <basic_check+0x151>
  10886c:	c7 44 24 0c 64 b0 10 	movl   $0x10b064,0xc(%esp)
  108873:	00 
  108874:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  10887b:	00 
  10887c:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  108883:	00 
  108884:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  10888b:	e8 58 7b ff ff       	call   1003e8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  108890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  108893:	89 04 24             	mov    %eax,(%esp)
  108896:	e8 41 f8 ff ff       	call   1080dc <page2pa>
  10889b:	8b 15 c0 e8 11 00    	mov    0x11e8c0,%edx
  1088a1:	c1 e2 0c             	shl    $0xc,%edx
  1088a4:	39 d0                	cmp    %edx,%eax
  1088a6:	72 24                	jb     1088cc <basic_check+0x18d>
  1088a8:	c7 44 24 0c a0 b0 10 	movl   $0x10b0a0,0xc(%esp)
  1088af:	00 
  1088b0:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1088b7:	00 
  1088b8:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  1088bf:	00 
  1088c0:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1088c7:	e8 1c 7b ff ff       	call   1003e8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1088cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1088cf:	89 04 24             	mov    %eax,(%esp)
  1088d2:	e8 05 f8 ff ff       	call   1080dc <page2pa>
  1088d7:	8b 15 c0 e8 11 00    	mov    0x11e8c0,%edx
  1088dd:	c1 e2 0c             	shl    $0xc,%edx
  1088e0:	39 d0                	cmp    %edx,%eax
  1088e2:	72 24                	jb     108908 <basic_check+0x1c9>
  1088e4:	c7 44 24 0c bd b0 10 	movl   $0x10b0bd,0xc(%esp)
  1088eb:	00 
  1088ec:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1088f3:	00 
  1088f4:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  1088fb:	00 
  1088fc:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108903:	e8 e0 7a ff ff       	call   1003e8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  108908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10890b:	89 04 24             	mov    %eax,(%esp)
  10890e:	e8 c9 f7 ff ff       	call   1080dc <page2pa>
  108913:	8b 15 c0 e8 11 00    	mov    0x11e8c0,%edx
  108919:	c1 e2 0c             	shl    $0xc,%edx
  10891c:	39 d0                	cmp    %edx,%eax
  10891e:	72 24                	jb     108944 <basic_check+0x205>
  108920:	c7 44 24 0c da b0 10 	movl   $0x10b0da,0xc(%esp)
  108927:	00 
  108928:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  10892f:	00 
  108930:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  108937:	00 
  108938:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  10893f:	e8 a4 7a ff ff       	call   1003e8 <__panic>

    list_entry_t free_list_store = free_list;
  108944:	a1 78 e9 11 00       	mov    0x11e978,%eax
  108949:	8b 15 7c e9 11 00    	mov    0x11e97c,%edx
  10894f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  108952:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  108955:	c7 45 e0 78 e9 11 00 	movl   $0x11e978,-0x20(%ebp)
    elm->prev = elm->next = elm;
  10895c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10895f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  108962:	89 50 04             	mov    %edx,0x4(%eax)
  108965:	8b 45 e0             	mov    -0x20(%ebp),%eax
  108968:	8b 50 04             	mov    0x4(%eax),%edx
  10896b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10896e:	89 10                	mov    %edx,(%eax)
  108970:	c7 45 dc 78 e9 11 00 	movl   $0x11e978,-0x24(%ebp)
    return list->next == list;
  108977:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10897a:	8b 40 04             	mov    0x4(%eax),%eax
  10897d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  108980:	0f 94 c0             	sete   %al
  108983:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  108986:	85 c0                	test   %eax,%eax
  108988:	75 24                	jne    1089ae <basic_check+0x26f>
  10898a:	c7 44 24 0c f7 b0 10 	movl   $0x10b0f7,0xc(%esp)
  108991:	00 
  108992:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108999:	00 
  10899a:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  1089a1:	00 
  1089a2:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1089a9:	e8 3a 7a ff ff       	call   1003e8 <__panic>

    unsigned int nr_free_store = nr_free;
  1089ae:	a1 80 e9 11 00       	mov    0x11e980,%eax
  1089b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1089b6:	c7 05 80 e9 11 00 00 	movl   $0x0,0x11e980
  1089bd:	00 00 00 

    assert(alloc_page() == NULL);
  1089c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1089c7:	e8 f3 a2 ff ff       	call   102cbf <alloc_pages>
  1089cc:	85 c0                	test   %eax,%eax
  1089ce:	74 24                	je     1089f4 <basic_check+0x2b5>
  1089d0:	c7 44 24 0c 0e b1 10 	movl   $0x10b10e,0xc(%esp)
  1089d7:	00 
  1089d8:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1089df:	00 
  1089e0:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  1089e7:	00 
  1089e8:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1089ef:	e8 f4 79 ff ff       	call   1003e8 <__panic>

    free_page(p0);
  1089f4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1089fb:	00 
  1089fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1089ff:	89 04 24             	mov    %eax,(%esp)
  108a02:	e8 f0 a2 ff ff       	call   102cf7 <free_pages>
    free_page(p1);
  108a07:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  108a0e:	00 
  108a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108a12:	89 04 24             	mov    %eax,(%esp)
  108a15:	e8 dd a2 ff ff       	call   102cf7 <free_pages>
    free_page(p2);
  108a1a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  108a21:	00 
  108a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108a25:	89 04 24             	mov    %eax,(%esp)
  108a28:	e8 ca a2 ff ff       	call   102cf7 <free_pages>
    assert(nr_free == 3);
  108a2d:	a1 80 e9 11 00       	mov    0x11e980,%eax
  108a32:	83 f8 03             	cmp    $0x3,%eax
  108a35:	74 24                	je     108a5b <basic_check+0x31c>
  108a37:	c7 44 24 0c 23 b1 10 	movl   $0x10b123,0xc(%esp)
  108a3e:	00 
  108a3f:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108a46:	00 
  108a47:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  108a4e:	00 
  108a4f:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108a56:	e8 8d 79 ff ff       	call   1003e8 <__panic>

    assert((p0 = alloc_page()) != NULL);
  108a5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108a62:	e8 58 a2 ff ff       	call   102cbf <alloc_pages>
  108a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  108a6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  108a6e:	75 24                	jne    108a94 <basic_check+0x355>
  108a70:	c7 44 24 0c ec af 10 	movl   $0x10afec,0xc(%esp)
  108a77:	00 
  108a78:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108a7f:	00 
  108a80:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  108a87:	00 
  108a88:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108a8f:	e8 54 79 ff ff       	call   1003e8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  108a94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108a9b:	e8 1f a2 ff ff       	call   102cbf <alloc_pages>
  108aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  108aa3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  108aa7:	75 24                	jne    108acd <basic_check+0x38e>
  108aa9:	c7 44 24 0c 08 b0 10 	movl   $0x10b008,0xc(%esp)
  108ab0:	00 
  108ab1:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108ab8:	00 
  108ab9:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  108ac0:	00 
  108ac1:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108ac8:	e8 1b 79 ff ff       	call   1003e8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  108acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108ad4:	e8 e6 a1 ff ff       	call   102cbf <alloc_pages>
  108ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  108adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  108ae0:	75 24                	jne    108b06 <basic_check+0x3c7>
  108ae2:	c7 44 24 0c 24 b0 10 	movl   $0x10b024,0xc(%esp)
  108ae9:	00 
  108aea:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108af1:	00 
  108af2:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  108af9:	00 
  108afa:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108b01:	e8 e2 78 ff ff       	call   1003e8 <__panic>

    assert(alloc_page() == NULL);
  108b06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108b0d:	e8 ad a1 ff ff       	call   102cbf <alloc_pages>
  108b12:	85 c0                	test   %eax,%eax
  108b14:	74 24                	je     108b3a <basic_check+0x3fb>
  108b16:	c7 44 24 0c 0e b1 10 	movl   $0x10b10e,0xc(%esp)
  108b1d:	00 
  108b1e:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108b25:	00 
  108b26:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
  108b2d:	00 
  108b2e:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108b35:	e8 ae 78 ff ff       	call   1003e8 <__panic>

    free_page(p0);
  108b3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  108b41:	00 
  108b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  108b45:	89 04 24             	mov    %eax,(%esp)
  108b48:	e8 aa a1 ff ff       	call   102cf7 <free_pages>
  108b4d:	c7 45 d8 78 e9 11 00 	movl   $0x11e978,-0x28(%ebp)
  108b54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  108b57:	8b 40 04             	mov    0x4(%eax),%eax
  108b5a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  108b5d:	0f 94 c0             	sete   %al
  108b60:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  108b63:	85 c0                	test   %eax,%eax
  108b65:	74 24                	je     108b8b <basic_check+0x44c>
  108b67:	c7 44 24 0c 30 b1 10 	movl   $0x10b130,0xc(%esp)
  108b6e:	00 
  108b6f:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108b76:	00 
  108b77:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  108b7e:	00 
  108b7f:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108b86:	e8 5d 78 ff ff       	call   1003e8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  108b8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108b92:	e8 28 a1 ff ff       	call   102cbf <alloc_pages>
  108b97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  108b9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  108b9d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  108ba0:	74 24                	je     108bc6 <basic_check+0x487>
  108ba2:	c7 44 24 0c 48 b1 10 	movl   $0x10b148,0xc(%esp)
  108ba9:	00 
  108baa:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108bb1:	00 
  108bb2:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  108bb9:	00 
  108bba:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108bc1:	e8 22 78 ff ff       	call   1003e8 <__panic>
    assert(alloc_page() == NULL);
  108bc6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108bcd:	e8 ed a0 ff ff       	call   102cbf <alloc_pages>
  108bd2:	85 c0                	test   %eax,%eax
  108bd4:	74 24                	je     108bfa <basic_check+0x4bb>
  108bd6:	c7 44 24 0c 0e b1 10 	movl   $0x10b10e,0xc(%esp)
  108bdd:	00 
  108bde:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108be5:	00 
  108be6:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  108bed:	00 
  108bee:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108bf5:	e8 ee 77 ff ff       	call   1003e8 <__panic>

    assert(nr_free == 0);
  108bfa:	a1 80 e9 11 00       	mov    0x11e980,%eax
  108bff:	85 c0                	test   %eax,%eax
  108c01:	74 24                	je     108c27 <basic_check+0x4e8>
  108c03:	c7 44 24 0c 61 b1 10 	movl   $0x10b161,0xc(%esp)
  108c0a:	00 
  108c0b:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108c12:	00 
  108c13:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  108c1a:	00 
  108c1b:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108c22:	e8 c1 77 ff ff       	call   1003e8 <__panic>
    free_list = free_list_store;
  108c27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108c2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  108c2d:	a3 78 e9 11 00       	mov    %eax,0x11e978
  108c32:	89 15 7c e9 11 00    	mov    %edx,0x11e97c
    nr_free = nr_free_store;
  108c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  108c3b:	a3 80 e9 11 00       	mov    %eax,0x11e980

    free_page(p);
  108c40:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  108c47:	00 
  108c48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  108c4b:	89 04 24             	mov    %eax,(%esp)
  108c4e:	e8 a4 a0 ff ff       	call   102cf7 <free_pages>
    free_page(p1);
  108c53:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  108c5a:	00 
  108c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108c5e:	89 04 24             	mov    %eax,(%esp)
  108c61:	e8 91 a0 ff ff       	call   102cf7 <free_pages>
    free_page(p2);
  108c66:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  108c6d:	00 
  108c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108c71:	89 04 24             	mov    %eax,(%esp)
  108c74:	e8 7e a0 ff ff       	call   102cf7 <free_pages>
}
  108c79:	c9                   	leave  
  108c7a:	c3                   	ret    

00108c7b <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  108c7b:	55                   	push   %ebp
  108c7c:	89 e5                	mov    %esp,%ebp
  108c7e:	53                   	push   %ebx
  108c7f:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  108c85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  108c8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  108c93:	c7 45 ec 78 e9 11 00 	movl   $0x11e978,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  108c9a:	eb 6b                	jmp    108d07 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  108c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  108c9f:	83 e8 0c             	sub    $0xc,%eax
  108ca2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  108ca5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  108ca8:	83 c0 04             	add    $0x4,%eax
  108cab:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  108cb2:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  108cb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108cb8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108cbb:	0f a3 10             	bt     %edx,(%eax)
  108cbe:	19 c0                	sbb    %eax,%eax
  108cc0:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  108cc3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  108cc7:	0f 95 c0             	setne  %al
  108cca:	0f b6 c0             	movzbl %al,%eax
  108ccd:	85 c0                	test   %eax,%eax
  108ccf:	75 24                	jne    108cf5 <default_check+0x7a>
  108cd1:	c7 44 24 0c 6e b1 10 	movl   $0x10b16e,0xc(%esp)
  108cd8:	00 
  108cd9:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108ce0:	00 
  108ce1:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  108ce8:	00 
  108ce9:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108cf0:	e8 f3 76 ff ff       	call   1003e8 <__panic>
        count ++, total += p->property;
  108cf5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  108cf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  108cfc:	8b 50 08             	mov    0x8(%eax),%edx
  108cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  108d02:	01 d0                	add    %edx,%eax
  108d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  108d07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  108d0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  108d0d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  108d10:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  108d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  108d16:	81 7d ec 78 e9 11 00 	cmpl   $0x11e978,-0x14(%ebp)
  108d1d:	0f 85 79 ff ff ff    	jne    108c9c <default_check+0x21>
    }
    assert(total == nr_free_pages());
  108d23:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  108d26:	e8 fe 9f ff ff       	call   102d29 <nr_free_pages>
  108d2b:	39 c3                	cmp    %eax,%ebx
  108d2d:	74 24                	je     108d53 <default_check+0xd8>
  108d2f:	c7 44 24 0c 7e b1 10 	movl   $0x10b17e,0xc(%esp)
  108d36:	00 
  108d37:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108d3e:	00 
  108d3f:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  108d46:	00 
  108d47:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108d4e:	e8 95 76 ff ff       	call   1003e8 <__panic>

    basic_check();
  108d53:	e8 e7 f9 ff ff       	call   10873f <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  108d58:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  108d5f:	e8 5b 9f ff ff       	call   102cbf <alloc_pages>
  108d64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  108d67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  108d6b:	75 24                	jne    108d91 <default_check+0x116>
  108d6d:	c7 44 24 0c 97 b1 10 	movl   $0x10b197,0xc(%esp)
  108d74:	00 
  108d75:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108d7c:	00 
  108d7d:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  108d84:	00 
  108d85:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108d8c:	e8 57 76 ff ff       	call   1003e8 <__panic>
    assert(!PageProperty(p0));
  108d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  108d94:	83 c0 04             	add    $0x4,%eax
  108d97:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  108d9e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  108da1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  108da4:	8b 55 c0             	mov    -0x40(%ebp),%edx
  108da7:	0f a3 10             	bt     %edx,(%eax)
  108daa:	19 c0                	sbb    %eax,%eax
  108dac:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  108daf:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  108db3:	0f 95 c0             	setne  %al
  108db6:	0f b6 c0             	movzbl %al,%eax
  108db9:	85 c0                	test   %eax,%eax
  108dbb:	74 24                	je     108de1 <default_check+0x166>
  108dbd:	c7 44 24 0c a2 b1 10 	movl   $0x10b1a2,0xc(%esp)
  108dc4:	00 
  108dc5:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108dcc:	00 
  108dcd:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  108dd4:	00 
  108dd5:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108ddc:	e8 07 76 ff ff       	call   1003e8 <__panic>

    list_entry_t free_list_store = free_list;
  108de1:	a1 78 e9 11 00       	mov    0x11e978,%eax
  108de6:	8b 15 7c e9 11 00    	mov    0x11e97c,%edx
  108dec:	89 45 80             	mov    %eax,-0x80(%ebp)
  108def:	89 55 84             	mov    %edx,-0x7c(%ebp)
  108df2:	c7 45 b4 78 e9 11 00 	movl   $0x11e978,-0x4c(%ebp)
    elm->prev = elm->next = elm;
  108df9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  108dfc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  108dff:	89 50 04             	mov    %edx,0x4(%eax)
  108e02:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  108e05:	8b 50 04             	mov    0x4(%eax),%edx
  108e08:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  108e0b:	89 10                	mov    %edx,(%eax)
  108e0d:	c7 45 b0 78 e9 11 00 	movl   $0x11e978,-0x50(%ebp)
    return list->next == list;
  108e14:	8b 45 b0             	mov    -0x50(%ebp),%eax
  108e17:	8b 40 04             	mov    0x4(%eax),%eax
  108e1a:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  108e1d:	0f 94 c0             	sete   %al
  108e20:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  108e23:	85 c0                	test   %eax,%eax
  108e25:	75 24                	jne    108e4b <default_check+0x1d0>
  108e27:	c7 44 24 0c f7 b0 10 	movl   $0x10b0f7,0xc(%esp)
  108e2e:	00 
  108e2f:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108e36:	00 
  108e37:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  108e3e:	00 
  108e3f:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108e46:	e8 9d 75 ff ff       	call   1003e8 <__panic>
    assert(alloc_page() == NULL);
  108e4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108e52:	e8 68 9e ff ff       	call   102cbf <alloc_pages>
  108e57:	85 c0                	test   %eax,%eax
  108e59:	74 24                	je     108e7f <default_check+0x204>
  108e5b:	c7 44 24 0c 0e b1 10 	movl   $0x10b10e,0xc(%esp)
  108e62:	00 
  108e63:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108e6a:	00 
  108e6b:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  108e72:	00 
  108e73:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108e7a:	e8 69 75 ff ff       	call   1003e8 <__panic>

    unsigned int nr_free_store = nr_free;
  108e7f:	a1 80 e9 11 00       	mov    0x11e980,%eax
  108e84:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  108e87:	c7 05 80 e9 11 00 00 	movl   $0x0,0x11e980
  108e8e:	00 00 00 

    free_pages(p0 + 2, 3);
  108e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  108e94:	83 c0 28             	add    $0x28,%eax
  108e97:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  108e9e:	00 
  108e9f:	89 04 24             	mov    %eax,(%esp)
  108ea2:	e8 50 9e ff ff       	call   102cf7 <free_pages>
    assert(alloc_pages(4) == NULL);
  108ea7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  108eae:	e8 0c 9e ff ff       	call   102cbf <alloc_pages>
  108eb3:	85 c0                	test   %eax,%eax
  108eb5:	74 24                	je     108edb <default_check+0x260>
  108eb7:	c7 44 24 0c b4 b1 10 	movl   $0x10b1b4,0xc(%esp)
  108ebe:	00 
  108ebf:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108ec6:	00 
  108ec7:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  108ece:	00 
  108ecf:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108ed6:	e8 0d 75 ff ff       	call   1003e8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  108edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  108ede:	83 c0 28             	add    $0x28,%eax
  108ee1:	83 c0 04             	add    $0x4,%eax
  108ee4:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  108eeb:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  108eee:	8b 45 a8             	mov    -0x58(%ebp),%eax
  108ef1:	8b 55 ac             	mov    -0x54(%ebp),%edx
  108ef4:	0f a3 10             	bt     %edx,(%eax)
  108ef7:	19 c0                	sbb    %eax,%eax
  108ef9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  108efc:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  108f00:	0f 95 c0             	setne  %al
  108f03:	0f b6 c0             	movzbl %al,%eax
  108f06:	85 c0                	test   %eax,%eax
  108f08:	74 0e                	je     108f18 <default_check+0x29d>
  108f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  108f0d:	83 c0 28             	add    $0x28,%eax
  108f10:	8b 40 08             	mov    0x8(%eax),%eax
  108f13:	83 f8 03             	cmp    $0x3,%eax
  108f16:	74 24                	je     108f3c <default_check+0x2c1>
  108f18:	c7 44 24 0c cc b1 10 	movl   $0x10b1cc,0xc(%esp)
  108f1f:	00 
  108f20:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108f27:	00 
  108f28:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  108f2f:	00 
  108f30:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108f37:	e8 ac 74 ff ff       	call   1003e8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  108f3c:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  108f43:	e8 77 9d ff ff       	call   102cbf <alloc_pages>
  108f48:	89 45 dc             	mov    %eax,-0x24(%ebp)
  108f4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  108f4f:	75 24                	jne    108f75 <default_check+0x2fa>
  108f51:	c7 44 24 0c f8 b1 10 	movl   $0x10b1f8,0xc(%esp)
  108f58:	00 
  108f59:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108f60:	00 
  108f61:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  108f68:	00 
  108f69:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108f70:	e8 73 74 ff ff       	call   1003e8 <__panic>
    assert(alloc_page() == NULL);
  108f75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108f7c:	e8 3e 9d ff ff       	call   102cbf <alloc_pages>
  108f81:	85 c0                	test   %eax,%eax
  108f83:	74 24                	je     108fa9 <default_check+0x32e>
  108f85:	c7 44 24 0c 0e b1 10 	movl   $0x10b10e,0xc(%esp)
  108f8c:	00 
  108f8d:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108f94:	00 
  108f95:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  108f9c:	00 
  108f9d:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108fa4:	e8 3f 74 ff ff       	call   1003e8 <__panic>
    assert(p0 + 2 == p1);
  108fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  108fac:	83 c0 28             	add    $0x28,%eax
  108faf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  108fb2:	74 24                	je     108fd8 <default_check+0x35d>
  108fb4:	c7 44 24 0c 16 b2 10 	movl   $0x10b216,0xc(%esp)
  108fbb:	00 
  108fbc:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  108fc3:	00 
  108fc4:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  108fcb:	00 
  108fcc:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  108fd3:	e8 10 74 ff ff       	call   1003e8 <__panic>

    p2 = p0 + 1;
  108fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  108fdb:	83 c0 14             	add    $0x14,%eax
  108fde:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  108fe1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  108fe8:	00 
  108fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  108fec:	89 04 24             	mov    %eax,(%esp)
  108fef:	e8 03 9d ff ff       	call   102cf7 <free_pages>
    free_pages(p1, 3);
  108ff4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  108ffb:	00 
  108ffc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108fff:	89 04 24             	mov    %eax,(%esp)
  109002:	e8 f0 9c ff ff       	call   102cf7 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  109007:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10900a:	83 c0 04             	add    $0x4,%eax
  10900d:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  109014:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  109017:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10901a:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10901d:	0f a3 10             	bt     %edx,(%eax)
  109020:	19 c0                	sbb    %eax,%eax
  109022:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  109025:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  109029:	0f 95 c0             	setne  %al
  10902c:	0f b6 c0             	movzbl %al,%eax
  10902f:	85 c0                	test   %eax,%eax
  109031:	74 0b                	je     10903e <default_check+0x3c3>
  109033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109036:	8b 40 08             	mov    0x8(%eax),%eax
  109039:	83 f8 01             	cmp    $0x1,%eax
  10903c:	74 24                	je     109062 <default_check+0x3e7>
  10903e:	c7 44 24 0c 24 b2 10 	movl   $0x10b224,0xc(%esp)
  109045:	00 
  109046:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  10904d:	00 
  10904e:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  109055:	00 
  109056:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  10905d:	e8 86 73 ff ff       	call   1003e8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  109062:	8b 45 dc             	mov    -0x24(%ebp),%eax
  109065:	83 c0 04             	add    $0x4,%eax
  109068:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10906f:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  109072:	8b 45 90             	mov    -0x70(%ebp),%eax
  109075:	8b 55 94             	mov    -0x6c(%ebp),%edx
  109078:	0f a3 10             	bt     %edx,(%eax)
  10907b:	19 c0                	sbb    %eax,%eax
  10907d:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  109080:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  109084:	0f 95 c0             	setne  %al
  109087:	0f b6 c0             	movzbl %al,%eax
  10908a:	85 c0                	test   %eax,%eax
  10908c:	74 0b                	je     109099 <default_check+0x41e>
  10908e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  109091:	8b 40 08             	mov    0x8(%eax),%eax
  109094:	83 f8 03             	cmp    $0x3,%eax
  109097:	74 24                	je     1090bd <default_check+0x442>
  109099:	c7 44 24 0c 4c b2 10 	movl   $0x10b24c,0xc(%esp)
  1090a0:	00 
  1090a1:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1090a8:	00 
  1090a9:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  1090b0:	00 
  1090b1:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1090b8:	e8 2b 73 ff ff       	call   1003e8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1090bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1090c4:	e8 f6 9b ff ff       	call   102cbf <alloc_pages>
  1090c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1090cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1090cf:	83 e8 14             	sub    $0x14,%eax
  1090d2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1090d5:	74 24                	je     1090fb <default_check+0x480>
  1090d7:	c7 44 24 0c 72 b2 10 	movl   $0x10b272,0xc(%esp)
  1090de:	00 
  1090df:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1090e6:	00 
  1090e7:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1090ee:	00 
  1090ef:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1090f6:	e8 ed 72 ff ff       	call   1003e8 <__panic>
    free_page(p0);
  1090fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  109102:	00 
  109103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109106:	89 04 24             	mov    %eax,(%esp)
  109109:	e8 e9 9b ff ff       	call   102cf7 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10910e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  109115:	e8 a5 9b ff ff       	call   102cbf <alloc_pages>
  10911a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10911d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  109120:	83 c0 14             	add    $0x14,%eax
  109123:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  109126:	74 24                	je     10914c <default_check+0x4d1>
  109128:	c7 44 24 0c 90 b2 10 	movl   $0x10b290,0xc(%esp)
  10912f:	00 
  109130:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  109137:	00 
  109138:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  10913f:	00 
  109140:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  109147:	e8 9c 72 ff ff       	call   1003e8 <__panic>

    free_pages(p0, 2);
  10914c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  109153:	00 
  109154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109157:	89 04 24             	mov    %eax,(%esp)
  10915a:	e8 98 9b ff ff       	call   102cf7 <free_pages>
    free_page(p2);
  10915f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  109166:	00 
  109167:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10916a:	89 04 24             	mov    %eax,(%esp)
  10916d:	e8 85 9b ff ff       	call   102cf7 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  109172:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  109179:	e8 41 9b ff ff       	call   102cbf <alloc_pages>
  10917e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  109181:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  109185:	75 24                	jne    1091ab <default_check+0x530>
  109187:	c7 44 24 0c b0 b2 10 	movl   $0x10b2b0,0xc(%esp)
  10918e:	00 
  10918f:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  109196:	00 
  109197:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  10919e:	00 
  10919f:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1091a6:	e8 3d 72 ff ff       	call   1003e8 <__panic>
    assert(alloc_page() == NULL);
  1091ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1091b2:	e8 08 9b ff ff       	call   102cbf <alloc_pages>
  1091b7:	85 c0                	test   %eax,%eax
  1091b9:	74 24                	je     1091df <default_check+0x564>
  1091bb:	c7 44 24 0c 0e b1 10 	movl   $0x10b10e,0xc(%esp)
  1091c2:	00 
  1091c3:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1091ca:	00 
  1091cb:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  1091d2:	00 
  1091d3:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1091da:	e8 09 72 ff ff       	call   1003e8 <__panic>

    assert(nr_free == 0);
  1091df:	a1 80 e9 11 00       	mov    0x11e980,%eax
  1091e4:	85 c0                	test   %eax,%eax
  1091e6:	74 24                	je     10920c <default_check+0x591>
  1091e8:	c7 44 24 0c 61 b1 10 	movl   $0x10b161,0xc(%esp)
  1091ef:	00 
  1091f0:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1091f7:	00 
  1091f8:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  1091ff:	00 
  109200:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  109207:	e8 dc 71 ff ff       	call   1003e8 <__panic>
    nr_free = nr_free_store;
  10920c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10920f:	a3 80 e9 11 00       	mov    %eax,0x11e980

    free_list = free_list_store;
  109214:	8b 45 80             	mov    -0x80(%ebp),%eax
  109217:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10921a:	a3 78 e9 11 00       	mov    %eax,0x11e978
  10921f:	89 15 7c e9 11 00    	mov    %edx,0x11e97c
    free_pages(p0, 5);
  109225:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  10922c:	00 
  10922d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109230:	89 04 24             	mov    %eax,(%esp)
  109233:	e8 bf 9a ff ff       	call   102cf7 <free_pages>

    le = &free_list;
  109238:	c7 45 ec 78 e9 11 00 	movl   $0x11e978,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10923f:	eb 1d                	jmp    10925e <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  109241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  109244:	83 e8 0c             	sub    $0xc,%eax
  109247:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  10924a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10924e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  109251:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  109254:	8b 40 08             	mov    0x8(%eax),%eax
  109257:	29 c2                	sub    %eax,%edx
  109259:	89 d0                	mov    %edx,%eax
  10925b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10925e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  109261:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  109264:	8b 45 88             	mov    -0x78(%ebp),%eax
  109267:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10926a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10926d:	81 7d ec 78 e9 11 00 	cmpl   $0x11e978,-0x14(%ebp)
  109274:	75 cb                	jne    109241 <default_check+0x5c6>
    }
    assert(count == 0);
  109276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10927a:	74 24                	je     1092a0 <default_check+0x625>
  10927c:	c7 44 24 0c ce b2 10 	movl   $0x10b2ce,0xc(%esp)
  109283:	00 
  109284:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  10928b:	00 
  10928c:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  109293:	00 
  109294:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  10929b:	e8 48 71 ff ff       	call   1003e8 <__panic>
    assert(total == 0);
  1092a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1092a4:	74 24                	je     1092ca <default_check+0x64f>
  1092a6:	c7 44 24 0c d9 b2 10 	movl   $0x10b2d9,0xc(%esp)
  1092ad:	00 
  1092ae:	c7 44 24 08 6e af 10 	movl   $0x10af6e,0x8(%esp)
  1092b5:	00 
  1092b6:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  1092bd:	00 
  1092be:	c7 04 24 83 af 10 00 	movl   $0x10af83,(%esp)
  1092c5:	e8 1e 71 ff ff       	call   1003e8 <__panic>
}
  1092ca:	81 c4 94 00 00 00    	add    $0x94,%esp
  1092d0:	5b                   	pop    %ebx
  1092d1:	5d                   	pop    %ebp
  1092d2:	c3                   	ret    

001092d3 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1092d3:	55                   	push   %ebp
  1092d4:	89 e5                	mov    %esp,%ebp
  1092d6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1092d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1092e0:	eb 04                	jmp    1092e6 <strlen+0x13>
        cnt ++;
  1092e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  1092e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1092e9:	8d 50 01             	lea    0x1(%eax),%edx
  1092ec:	89 55 08             	mov    %edx,0x8(%ebp)
  1092ef:	0f b6 00             	movzbl (%eax),%eax
  1092f2:	84 c0                	test   %al,%al
  1092f4:	75 ec                	jne    1092e2 <strlen+0xf>
    }
    return cnt;
  1092f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1092f9:	c9                   	leave  
  1092fa:	c3                   	ret    

001092fb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1092fb:	55                   	push   %ebp
  1092fc:	89 e5                	mov    %esp,%ebp
  1092fe:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  109301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  109308:	eb 04                	jmp    10930e <strnlen+0x13>
        cnt ++;
  10930a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10930e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  109311:	3b 45 0c             	cmp    0xc(%ebp),%eax
  109314:	73 10                	jae    109326 <strnlen+0x2b>
  109316:	8b 45 08             	mov    0x8(%ebp),%eax
  109319:	8d 50 01             	lea    0x1(%eax),%edx
  10931c:	89 55 08             	mov    %edx,0x8(%ebp)
  10931f:	0f b6 00             	movzbl (%eax),%eax
  109322:	84 c0                	test   %al,%al
  109324:	75 e4                	jne    10930a <strnlen+0xf>
    }
    return cnt;
  109326:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  109329:	c9                   	leave  
  10932a:	c3                   	ret    

0010932b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10932b:	55                   	push   %ebp
  10932c:	89 e5                	mov    %esp,%ebp
  10932e:	57                   	push   %edi
  10932f:	56                   	push   %esi
  109330:	83 ec 20             	sub    $0x20,%esp
  109333:	8b 45 08             	mov    0x8(%ebp),%eax
  109336:	89 45 f4             	mov    %eax,-0xc(%ebp)
  109339:	8b 45 0c             	mov    0xc(%ebp),%eax
  10933c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10933f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  109342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  109345:	89 d1                	mov    %edx,%ecx
  109347:	89 c2                	mov    %eax,%edx
  109349:	89 ce                	mov    %ecx,%esi
  10934b:	89 d7                	mov    %edx,%edi
  10934d:	ac                   	lods   %ds:(%esi),%al
  10934e:	aa                   	stos   %al,%es:(%edi)
  10934f:	84 c0                	test   %al,%al
  109351:	75 fa                	jne    10934d <strcpy+0x22>
  109353:	89 fa                	mov    %edi,%edx
  109355:	89 f1                	mov    %esi,%ecx
  109357:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10935a:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10935d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  109360:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  109363:	83 c4 20             	add    $0x20,%esp
  109366:	5e                   	pop    %esi
  109367:	5f                   	pop    %edi
  109368:	5d                   	pop    %ebp
  109369:	c3                   	ret    

0010936a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10936a:	55                   	push   %ebp
  10936b:	89 e5                	mov    %esp,%ebp
  10936d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  109370:	8b 45 08             	mov    0x8(%ebp),%eax
  109373:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  109376:	eb 21                	jmp    109399 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  109378:	8b 45 0c             	mov    0xc(%ebp),%eax
  10937b:	0f b6 10             	movzbl (%eax),%edx
  10937e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  109381:	88 10                	mov    %dl,(%eax)
  109383:	8b 45 fc             	mov    -0x4(%ebp),%eax
  109386:	0f b6 00             	movzbl (%eax),%eax
  109389:	84 c0                	test   %al,%al
  10938b:	74 04                	je     109391 <strncpy+0x27>
            src ++;
  10938d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  109391:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  109395:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  109399:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10939d:	75 d9                	jne    109378 <strncpy+0xe>
    }
    return dst;
  10939f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1093a2:	c9                   	leave  
  1093a3:	c3                   	ret    

001093a4 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1093a4:	55                   	push   %ebp
  1093a5:	89 e5                	mov    %esp,%ebp
  1093a7:	57                   	push   %edi
  1093a8:	56                   	push   %esi
  1093a9:	83 ec 20             	sub    $0x20,%esp
  1093ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1093af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1093b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1093b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1093b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1093bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1093be:	89 d1                	mov    %edx,%ecx
  1093c0:	89 c2                	mov    %eax,%edx
  1093c2:	89 ce                	mov    %ecx,%esi
  1093c4:	89 d7                	mov    %edx,%edi
  1093c6:	ac                   	lods   %ds:(%esi),%al
  1093c7:	ae                   	scas   %es:(%edi),%al
  1093c8:	75 08                	jne    1093d2 <strcmp+0x2e>
  1093ca:	84 c0                	test   %al,%al
  1093cc:	75 f8                	jne    1093c6 <strcmp+0x22>
  1093ce:	31 c0                	xor    %eax,%eax
  1093d0:	eb 04                	jmp    1093d6 <strcmp+0x32>
  1093d2:	19 c0                	sbb    %eax,%eax
  1093d4:	0c 01                	or     $0x1,%al
  1093d6:	89 fa                	mov    %edi,%edx
  1093d8:	89 f1                	mov    %esi,%ecx
  1093da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1093dd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1093e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1093e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1093e6:	83 c4 20             	add    $0x20,%esp
  1093e9:	5e                   	pop    %esi
  1093ea:	5f                   	pop    %edi
  1093eb:	5d                   	pop    %ebp
  1093ec:	c3                   	ret    

001093ed <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1093ed:	55                   	push   %ebp
  1093ee:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1093f0:	eb 0c                	jmp    1093fe <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1093f2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1093f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1093fa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1093fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  109402:	74 1a                	je     10941e <strncmp+0x31>
  109404:	8b 45 08             	mov    0x8(%ebp),%eax
  109407:	0f b6 00             	movzbl (%eax),%eax
  10940a:	84 c0                	test   %al,%al
  10940c:	74 10                	je     10941e <strncmp+0x31>
  10940e:	8b 45 08             	mov    0x8(%ebp),%eax
  109411:	0f b6 10             	movzbl (%eax),%edx
  109414:	8b 45 0c             	mov    0xc(%ebp),%eax
  109417:	0f b6 00             	movzbl (%eax),%eax
  10941a:	38 c2                	cmp    %al,%dl
  10941c:	74 d4                	je     1093f2 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10941e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  109422:	74 18                	je     10943c <strncmp+0x4f>
  109424:	8b 45 08             	mov    0x8(%ebp),%eax
  109427:	0f b6 00             	movzbl (%eax),%eax
  10942a:	0f b6 d0             	movzbl %al,%edx
  10942d:	8b 45 0c             	mov    0xc(%ebp),%eax
  109430:	0f b6 00             	movzbl (%eax),%eax
  109433:	0f b6 c0             	movzbl %al,%eax
  109436:	29 c2                	sub    %eax,%edx
  109438:	89 d0                	mov    %edx,%eax
  10943a:	eb 05                	jmp    109441 <strncmp+0x54>
  10943c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  109441:	5d                   	pop    %ebp
  109442:	c3                   	ret    

00109443 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  109443:	55                   	push   %ebp
  109444:	89 e5                	mov    %esp,%ebp
  109446:	83 ec 04             	sub    $0x4,%esp
  109449:	8b 45 0c             	mov    0xc(%ebp),%eax
  10944c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10944f:	eb 14                	jmp    109465 <strchr+0x22>
        if (*s == c) {
  109451:	8b 45 08             	mov    0x8(%ebp),%eax
  109454:	0f b6 00             	movzbl (%eax),%eax
  109457:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10945a:	75 05                	jne    109461 <strchr+0x1e>
            return (char *)s;
  10945c:	8b 45 08             	mov    0x8(%ebp),%eax
  10945f:	eb 13                	jmp    109474 <strchr+0x31>
        }
        s ++;
  109461:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  109465:	8b 45 08             	mov    0x8(%ebp),%eax
  109468:	0f b6 00             	movzbl (%eax),%eax
  10946b:	84 c0                	test   %al,%al
  10946d:	75 e2                	jne    109451 <strchr+0xe>
    }
    return NULL;
  10946f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  109474:	c9                   	leave  
  109475:	c3                   	ret    

00109476 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  109476:	55                   	push   %ebp
  109477:	89 e5                	mov    %esp,%ebp
  109479:	83 ec 04             	sub    $0x4,%esp
  10947c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10947f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  109482:	eb 11                	jmp    109495 <strfind+0x1f>
        if (*s == c) {
  109484:	8b 45 08             	mov    0x8(%ebp),%eax
  109487:	0f b6 00             	movzbl (%eax),%eax
  10948a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10948d:	75 02                	jne    109491 <strfind+0x1b>
            break;
  10948f:	eb 0e                	jmp    10949f <strfind+0x29>
        }
        s ++;
  109491:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  109495:	8b 45 08             	mov    0x8(%ebp),%eax
  109498:	0f b6 00             	movzbl (%eax),%eax
  10949b:	84 c0                	test   %al,%al
  10949d:	75 e5                	jne    109484 <strfind+0xe>
    }
    return (char *)s;
  10949f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1094a2:	c9                   	leave  
  1094a3:	c3                   	ret    

001094a4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1094a4:	55                   	push   %ebp
  1094a5:	89 e5                	mov    %esp,%ebp
  1094a7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1094aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1094b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1094b8:	eb 04                	jmp    1094be <strtol+0x1a>
        s ++;
  1094ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1094be:	8b 45 08             	mov    0x8(%ebp),%eax
  1094c1:	0f b6 00             	movzbl (%eax),%eax
  1094c4:	3c 20                	cmp    $0x20,%al
  1094c6:	74 f2                	je     1094ba <strtol+0x16>
  1094c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1094cb:	0f b6 00             	movzbl (%eax),%eax
  1094ce:	3c 09                	cmp    $0x9,%al
  1094d0:	74 e8                	je     1094ba <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  1094d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1094d5:	0f b6 00             	movzbl (%eax),%eax
  1094d8:	3c 2b                	cmp    $0x2b,%al
  1094da:	75 06                	jne    1094e2 <strtol+0x3e>
        s ++;
  1094dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1094e0:	eb 15                	jmp    1094f7 <strtol+0x53>
    }
    else if (*s == '-') {
  1094e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1094e5:	0f b6 00             	movzbl (%eax),%eax
  1094e8:	3c 2d                	cmp    $0x2d,%al
  1094ea:	75 0b                	jne    1094f7 <strtol+0x53>
        s ++, neg = 1;
  1094ec:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1094f0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1094f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1094fb:	74 06                	je     109503 <strtol+0x5f>
  1094fd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  109501:	75 24                	jne    109527 <strtol+0x83>
  109503:	8b 45 08             	mov    0x8(%ebp),%eax
  109506:	0f b6 00             	movzbl (%eax),%eax
  109509:	3c 30                	cmp    $0x30,%al
  10950b:	75 1a                	jne    109527 <strtol+0x83>
  10950d:	8b 45 08             	mov    0x8(%ebp),%eax
  109510:	83 c0 01             	add    $0x1,%eax
  109513:	0f b6 00             	movzbl (%eax),%eax
  109516:	3c 78                	cmp    $0x78,%al
  109518:	75 0d                	jne    109527 <strtol+0x83>
        s += 2, base = 16;
  10951a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10951e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  109525:	eb 2a                	jmp    109551 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  109527:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10952b:	75 17                	jne    109544 <strtol+0xa0>
  10952d:	8b 45 08             	mov    0x8(%ebp),%eax
  109530:	0f b6 00             	movzbl (%eax),%eax
  109533:	3c 30                	cmp    $0x30,%al
  109535:	75 0d                	jne    109544 <strtol+0xa0>
        s ++, base = 8;
  109537:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10953b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  109542:	eb 0d                	jmp    109551 <strtol+0xad>
    }
    else if (base == 0) {
  109544:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  109548:	75 07                	jne    109551 <strtol+0xad>
        base = 10;
  10954a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  109551:	8b 45 08             	mov    0x8(%ebp),%eax
  109554:	0f b6 00             	movzbl (%eax),%eax
  109557:	3c 2f                	cmp    $0x2f,%al
  109559:	7e 1b                	jle    109576 <strtol+0xd2>
  10955b:	8b 45 08             	mov    0x8(%ebp),%eax
  10955e:	0f b6 00             	movzbl (%eax),%eax
  109561:	3c 39                	cmp    $0x39,%al
  109563:	7f 11                	jg     109576 <strtol+0xd2>
            dig = *s - '0';
  109565:	8b 45 08             	mov    0x8(%ebp),%eax
  109568:	0f b6 00             	movzbl (%eax),%eax
  10956b:	0f be c0             	movsbl %al,%eax
  10956e:	83 e8 30             	sub    $0x30,%eax
  109571:	89 45 f4             	mov    %eax,-0xc(%ebp)
  109574:	eb 48                	jmp    1095be <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  109576:	8b 45 08             	mov    0x8(%ebp),%eax
  109579:	0f b6 00             	movzbl (%eax),%eax
  10957c:	3c 60                	cmp    $0x60,%al
  10957e:	7e 1b                	jle    10959b <strtol+0xf7>
  109580:	8b 45 08             	mov    0x8(%ebp),%eax
  109583:	0f b6 00             	movzbl (%eax),%eax
  109586:	3c 7a                	cmp    $0x7a,%al
  109588:	7f 11                	jg     10959b <strtol+0xf7>
            dig = *s - 'a' + 10;
  10958a:	8b 45 08             	mov    0x8(%ebp),%eax
  10958d:	0f b6 00             	movzbl (%eax),%eax
  109590:	0f be c0             	movsbl %al,%eax
  109593:	83 e8 57             	sub    $0x57,%eax
  109596:	89 45 f4             	mov    %eax,-0xc(%ebp)
  109599:	eb 23                	jmp    1095be <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10959b:	8b 45 08             	mov    0x8(%ebp),%eax
  10959e:	0f b6 00             	movzbl (%eax),%eax
  1095a1:	3c 40                	cmp    $0x40,%al
  1095a3:	7e 3d                	jle    1095e2 <strtol+0x13e>
  1095a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1095a8:	0f b6 00             	movzbl (%eax),%eax
  1095ab:	3c 5a                	cmp    $0x5a,%al
  1095ad:	7f 33                	jg     1095e2 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1095af:	8b 45 08             	mov    0x8(%ebp),%eax
  1095b2:	0f b6 00             	movzbl (%eax),%eax
  1095b5:	0f be c0             	movsbl %al,%eax
  1095b8:	83 e8 37             	sub    $0x37,%eax
  1095bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1095be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1095c1:	3b 45 10             	cmp    0x10(%ebp),%eax
  1095c4:	7c 02                	jl     1095c8 <strtol+0x124>
            break;
  1095c6:	eb 1a                	jmp    1095e2 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1095c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1095cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1095cf:	0f af 45 10          	imul   0x10(%ebp),%eax
  1095d3:	89 c2                	mov    %eax,%edx
  1095d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1095d8:	01 d0                	add    %edx,%eax
  1095da:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1095dd:	e9 6f ff ff ff       	jmp    109551 <strtol+0xad>

    if (endptr) {
  1095e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1095e6:	74 08                	je     1095f0 <strtol+0x14c>
        *endptr = (char *) s;
  1095e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1095eb:	8b 55 08             	mov    0x8(%ebp),%edx
  1095ee:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1095f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1095f4:	74 07                	je     1095fd <strtol+0x159>
  1095f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1095f9:	f7 d8                	neg    %eax
  1095fb:	eb 03                	jmp    109600 <strtol+0x15c>
  1095fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  109600:	c9                   	leave  
  109601:	c3                   	ret    

00109602 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  109602:	55                   	push   %ebp
  109603:	89 e5                	mov    %esp,%ebp
  109605:	57                   	push   %edi
  109606:	83 ec 24             	sub    $0x24,%esp
  109609:	8b 45 0c             	mov    0xc(%ebp),%eax
  10960c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10960f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  109613:	8b 55 08             	mov    0x8(%ebp),%edx
  109616:	89 55 f8             	mov    %edx,-0x8(%ebp)
  109619:	88 45 f7             	mov    %al,-0x9(%ebp)
  10961c:	8b 45 10             	mov    0x10(%ebp),%eax
  10961f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  109622:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  109625:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  109629:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10962c:	89 d7                	mov    %edx,%edi
  10962e:	f3 aa                	rep stos %al,%es:(%edi)
  109630:	89 fa                	mov    %edi,%edx
  109632:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  109635:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  109638:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10963b:	83 c4 24             	add    $0x24,%esp
  10963e:	5f                   	pop    %edi
  10963f:	5d                   	pop    %ebp
  109640:	c3                   	ret    

00109641 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  109641:	55                   	push   %ebp
  109642:	89 e5                	mov    %esp,%ebp
  109644:	57                   	push   %edi
  109645:	56                   	push   %esi
  109646:	53                   	push   %ebx
  109647:	83 ec 30             	sub    $0x30,%esp
  10964a:	8b 45 08             	mov    0x8(%ebp),%eax
  10964d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109650:	8b 45 0c             	mov    0xc(%ebp),%eax
  109653:	89 45 ec             	mov    %eax,-0x14(%ebp)
  109656:	8b 45 10             	mov    0x10(%ebp),%eax
  109659:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10965c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10965f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  109662:	73 42                	jae    1096a6 <memmove+0x65>
  109664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109667:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10966a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10966d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  109670:	8b 45 e8             	mov    -0x18(%ebp),%eax
  109673:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  109676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  109679:	c1 e8 02             	shr    $0x2,%eax
  10967c:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10967e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  109681:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109684:	89 d7                	mov    %edx,%edi
  109686:	89 c6                	mov    %eax,%esi
  109688:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10968a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10968d:	83 e1 03             	and    $0x3,%ecx
  109690:	74 02                	je     109694 <memmove+0x53>
  109692:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  109694:	89 f0                	mov    %esi,%eax
  109696:	89 fa                	mov    %edi,%edx
  109698:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10969b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10969e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1096a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1096a4:	eb 36                	jmp    1096dc <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1096a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1096a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1096ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1096af:	01 c2                	add    %eax,%edx
  1096b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1096b4:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1096b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1096ba:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1096bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1096c0:	89 c1                	mov    %eax,%ecx
  1096c2:	89 d8                	mov    %ebx,%eax
  1096c4:	89 d6                	mov    %edx,%esi
  1096c6:	89 c7                	mov    %eax,%edi
  1096c8:	fd                   	std    
  1096c9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1096cb:	fc                   	cld    
  1096cc:	89 f8                	mov    %edi,%eax
  1096ce:	89 f2                	mov    %esi,%edx
  1096d0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1096d3:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1096d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1096d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1096dc:	83 c4 30             	add    $0x30,%esp
  1096df:	5b                   	pop    %ebx
  1096e0:	5e                   	pop    %esi
  1096e1:	5f                   	pop    %edi
  1096e2:	5d                   	pop    %ebp
  1096e3:	c3                   	ret    

001096e4 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1096e4:	55                   	push   %ebp
  1096e5:	89 e5                	mov    %esp,%ebp
  1096e7:	57                   	push   %edi
  1096e8:	56                   	push   %esi
  1096e9:	83 ec 20             	sub    $0x20,%esp
  1096ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1096ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1096f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1096f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1096f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1096fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1096fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  109701:	c1 e8 02             	shr    $0x2,%eax
  109704:	89 c1                	mov    %eax,%ecx
    asm volatile (
  109706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  109709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10970c:	89 d7                	mov    %edx,%edi
  10970e:	89 c6                	mov    %eax,%esi
  109710:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  109712:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  109715:	83 e1 03             	and    $0x3,%ecx
  109718:	74 02                	je     10971c <memcpy+0x38>
  10971a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10971c:	89 f0                	mov    %esi,%eax
  10971e:	89 fa                	mov    %edi,%edx
  109720:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  109723:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  109726:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  109729:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10972c:	83 c4 20             	add    $0x20,%esp
  10972f:	5e                   	pop    %esi
  109730:	5f                   	pop    %edi
  109731:	5d                   	pop    %ebp
  109732:	c3                   	ret    

00109733 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  109733:	55                   	push   %ebp
  109734:	89 e5                	mov    %esp,%ebp
  109736:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  109739:	8b 45 08             	mov    0x8(%ebp),%eax
  10973c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10973f:	8b 45 0c             	mov    0xc(%ebp),%eax
  109742:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  109745:	eb 30                	jmp    109777 <memcmp+0x44>
        if (*s1 != *s2) {
  109747:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10974a:	0f b6 10             	movzbl (%eax),%edx
  10974d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  109750:	0f b6 00             	movzbl (%eax),%eax
  109753:	38 c2                	cmp    %al,%dl
  109755:	74 18                	je     10976f <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  109757:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10975a:	0f b6 00             	movzbl (%eax),%eax
  10975d:	0f b6 d0             	movzbl %al,%edx
  109760:	8b 45 f8             	mov    -0x8(%ebp),%eax
  109763:	0f b6 00             	movzbl (%eax),%eax
  109766:	0f b6 c0             	movzbl %al,%eax
  109769:	29 c2                	sub    %eax,%edx
  10976b:	89 d0                	mov    %edx,%eax
  10976d:	eb 1a                	jmp    109789 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  10976f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  109773:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  109777:	8b 45 10             	mov    0x10(%ebp),%eax
  10977a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10977d:	89 55 10             	mov    %edx,0x10(%ebp)
  109780:	85 c0                	test   %eax,%eax
  109782:	75 c3                	jne    109747 <memcmp+0x14>
    }
    return 0;
  109784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  109789:	c9                   	leave  
  10978a:	c3                   	ret    

0010978b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10978b:	55                   	push   %ebp
  10978c:	89 e5                	mov    %esp,%ebp
  10978e:	83 ec 58             	sub    $0x58,%esp
  109791:	8b 45 10             	mov    0x10(%ebp),%eax
  109794:	89 45 d0             	mov    %eax,-0x30(%ebp)
  109797:	8b 45 14             	mov    0x14(%ebp),%eax
  10979a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10979d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1097a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1097a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1097a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1097a9:	8b 45 18             	mov    0x18(%ebp),%eax
  1097ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1097af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1097b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1097b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1097b8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1097bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1097be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1097c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1097c5:	74 1c                	je     1097e3 <printnum+0x58>
  1097c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1097ca:	ba 00 00 00 00       	mov    $0x0,%edx
  1097cf:	f7 75 e4             	divl   -0x1c(%ebp)
  1097d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1097d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1097d8:	ba 00 00 00 00       	mov    $0x0,%edx
  1097dd:	f7 75 e4             	divl   -0x1c(%ebp)
  1097e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1097e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1097e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1097e9:	f7 75 e4             	divl   -0x1c(%ebp)
  1097ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1097ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1097f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1097f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1097f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1097fb:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1097fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  109801:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  109804:	8b 45 18             	mov    0x18(%ebp),%eax
  109807:	ba 00 00 00 00       	mov    $0x0,%edx
  10980c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10980f:	77 56                	ja     109867 <printnum+0xdc>
  109811:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  109814:	72 05                	jb     10981b <printnum+0x90>
  109816:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  109819:	77 4c                	ja     109867 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10981b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10981e:	8d 50 ff             	lea    -0x1(%eax),%edx
  109821:	8b 45 20             	mov    0x20(%ebp),%eax
  109824:	89 44 24 18          	mov    %eax,0x18(%esp)
  109828:	89 54 24 14          	mov    %edx,0x14(%esp)
  10982c:	8b 45 18             	mov    0x18(%ebp),%eax
  10982f:	89 44 24 10          	mov    %eax,0x10(%esp)
  109833:	8b 45 e8             	mov    -0x18(%ebp),%eax
  109836:	8b 55 ec             	mov    -0x14(%ebp),%edx
  109839:	89 44 24 08          	mov    %eax,0x8(%esp)
  10983d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  109841:	8b 45 0c             	mov    0xc(%ebp),%eax
  109844:	89 44 24 04          	mov    %eax,0x4(%esp)
  109848:	8b 45 08             	mov    0x8(%ebp),%eax
  10984b:	89 04 24             	mov    %eax,(%esp)
  10984e:	e8 38 ff ff ff       	call   10978b <printnum>
  109853:	eb 1c                	jmp    109871 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  109855:	8b 45 0c             	mov    0xc(%ebp),%eax
  109858:	89 44 24 04          	mov    %eax,0x4(%esp)
  10985c:	8b 45 20             	mov    0x20(%ebp),%eax
  10985f:	89 04 24             	mov    %eax,(%esp)
  109862:	8b 45 08             	mov    0x8(%ebp),%eax
  109865:	ff d0                	call   *%eax
        while (-- width > 0)
  109867:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10986b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10986f:	7f e4                	jg     109855 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  109871:	8b 45 d8             	mov    -0x28(%ebp),%eax
  109874:	05 94 b3 10 00       	add    $0x10b394,%eax
  109879:	0f b6 00             	movzbl (%eax),%eax
  10987c:	0f be c0             	movsbl %al,%eax
  10987f:	8b 55 0c             	mov    0xc(%ebp),%edx
  109882:	89 54 24 04          	mov    %edx,0x4(%esp)
  109886:	89 04 24             	mov    %eax,(%esp)
  109889:	8b 45 08             	mov    0x8(%ebp),%eax
  10988c:	ff d0                	call   *%eax
}
  10988e:	c9                   	leave  
  10988f:	c3                   	ret    

00109890 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  109890:	55                   	push   %ebp
  109891:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  109893:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  109897:	7e 14                	jle    1098ad <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  109899:	8b 45 08             	mov    0x8(%ebp),%eax
  10989c:	8b 00                	mov    (%eax),%eax
  10989e:	8d 48 08             	lea    0x8(%eax),%ecx
  1098a1:	8b 55 08             	mov    0x8(%ebp),%edx
  1098a4:	89 0a                	mov    %ecx,(%edx)
  1098a6:	8b 50 04             	mov    0x4(%eax),%edx
  1098a9:	8b 00                	mov    (%eax),%eax
  1098ab:	eb 30                	jmp    1098dd <getuint+0x4d>
    }
    else if (lflag) {
  1098ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1098b1:	74 16                	je     1098c9 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1098b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1098b6:	8b 00                	mov    (%eax),%eax
  1098b8:	8d 48 04             	lea    0x4(%eax),%ecx
  1098bb:	8b 55 08             	mov    0x8(%ebp),%edx
  1098be:	89 0a                	mov    %ecx,(%edx)
  1098c0:	8b 00                	mov    (%eax),%eax
  1098c2:	ba 00 00 00 00       	mov    $0x0,%edx
  1098c7:	eb 14                	jmp    1098dd <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1098c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1098cc:	8b 00                	mov    (%eax),%eax
  1098ce:	8d 48 04             	lea    0x4(%eax),%ecx
  1098d1:	8b 55 08             	mov    0x8(%ebp),%edx
  1098d4:	89 0a                	mov    %ecx,(%edx)
  1098d6:	8b 00                	mov    (%eax),%eax
  1098d8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1098dd:	5d                   	pop    %ebp
  1098de:	c3                   	ret    

001098df <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1098df:	55                   	push   %ebp
  1098e0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1098e2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1098e6:	7e 14                	jle    1098fc <getint+0x1d>
        return va_arg(*ap, long long);
  1098e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1098eb:	8b 00                	mov    (%eax),%eax
  1098ed:	8d 48 08             	lea    0x8(%eax),%ecx
  1098f0:	8b 55 08             	mov    0x8(%ebp),%edx
  1098f3:	89 0a                	mov    %ecx,(%edx)
  1098f5:	8b 50 04             	mov    0x4(%eax),%edx
  1098f8:	8b 00                	mov    (%eax),%eax
  1098fa:	eb 28                	jmp    109924 <getint+0x45>
    }
    else if (lflag) {
  1098fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  109900:	74 12                	je     109914 <getint+0x35>
        return va_arg(*ap, long);
  109902:	8b 45 08             	mov    0x8(%ebp),%eax
  109905:	8b 00                	mov    (%eax),%eax
  109907:	8d 48 04             	lea    0x4(%eax),%ecx
  10990a:	8b 55 08             	mov    0x8(%ebp),%edx
  10990d:	89 0a                	mov    %ecx,(%edx)
  10990f:	8b 00                	mov    (%eax),%eax
  109911:	99                   	cltd   
  109912:	eb 10                	jmp    109924 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  109914:	8b 45 08             	mov    0x8(%ebp),%eax
  109917:	8b 00                	mov    (%eax),%eax
  109919:	8d 48 04             	lea    0x4(%eax),%ecx
  10991c:	8b 55 08             	mov    0x8(%ebp),%edx
  10991f:	89 0a                	mov    %ecx,(%edx)
  109921:	8b 00                	mov    (%eax),%eax
  109923:	99                   	cltd   
    }
}
  109924:	5d                   	pop    %ebp
  109925:	c3                   	ret    

00109926 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  109926:	55                   	push   %ebp
  109927:	89 e5                	mov    %esp,%ebp
  109929:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10992c:	8d 45 14             	lea    0x14(%ebp),%eax
  10992f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  109932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  109935:	89 44 24 0c          	mov    %eax,0xc(%esp)
  109939:	8b 45 10             	mov    0x10(%ebp),%eax
  10993c:	89 44 24 08          	mov    %eax,0x8(%esp)
  109940:	8b 45 0c             	mov    0xc(%ebp),%eax
  109943:	89 44 24 04          	mov    %eax,0x4(%esp)
  109947:	8b 45 08             	mov    0x8(%ebp),%eax
  10994a:	89 04 24             	mov    %eax,(%esp)
  10994d:	e8 02 00 00 00       	call   109954 <vprintfmt>
    va_end(ap);
}
  109952:	c9                   	leave  
  109953:	c3                   	ret    

00109954 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  109954:	55                   	push   %ebp
  109955:	89 e5                	mov    %esp,%ebp
  109957:	56                   	push   %esi
  109958:	53                   	push   %ebx
  109959:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10995c:	eb 18                	jmp    109976 <vprintfmt+0x22>
            if (ch == '\0') {
  10995e:	85 db                	test   %ebx,%ebx
  109960:	75 05                	jne    109967 <vprintfmt+0x13>
                return;
  109962:	e9 d1 03 00 00       	jmp    109d38 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  109967:	8b 45 0c             	mov    0xc(%ebp),%eax
  10996a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10996e:	89 1c 24             	mov    %ebx,(%esp)
  109971:	8b 45 08             	mov    0x8(%ebp),%eax
  109974:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  109976:	8b 45 10             	mov    0x10(%ebp),%eax
  109979:	8d 50 01             	lea    0x1(%eax),%edx
  10997c:	89 55 10             	mov    %edx,0x10(%ebp)
  10997f:	0f b6 00             	movzbl (%eax),%eax
  109982:	0f b6 d8             	movzbl %al,%ebx
  109985:	83 fb 25             	cmp    $0x25,%ebx
  109988:	75 d4                	jne    10995e <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10998a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10998e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  109995:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109998:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10999b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1099a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1099a5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1099a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1099ab:	8d 50 01             	lea    0x1(%eax),%edx
  1099ae:	89 55 10             	mov    %edx,0x10(%ebp)
  1099b1:	0f b6 00             	movzbl (%eax),%eax
  1099b4:	0f b6 d8             	movzbl %al,%ebx
  1099b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1099ba:	83 f8 55             	cmp    $0x55,%eax
  1099bd:	0f 87 44 03 00 00    	ja     109d07 <vprintfmt+0x3b3>
  1099c3:	8b 04 85 b8 b3 10 00 	mov    0x10b3b8(,%eax,4),%eax
  1099ca:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1099cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1099d0:	eb d6                	jmp    1099a8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1099d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1099d6:	eb d0                	jmp    1099a8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1099d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1099df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1099e2:	89 d0                	mov    %edx,%eax
  1099e4:	c1 e0 02             	shl    $0x2,%eax
  1099e7:	01 d0                	add    %edx,%eax
  1099e9:	01 c0                	add    %eax,%eax
  1099eb:	01 d8                	add    %ebx,%eax
  1099ed:	83 e8 30             	sub    $0x30,%eax
  1099f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1099f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1099f6:	0f b6 00             	movzbl (%eax),%eax
  1099f9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1099fc:	83 fb 2f             	cmp    $0x2f,%ebx
  1099ff:	7e 0b                	jle    109a0c <vprintfmt+0xb8>
  109a01:	83 fb 39             	cmp    $0x39,%ebx
  109a04:	7f 06                	jg     109a0c <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
  109a06:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
  109a0a:	eb d3                	jmp    1099df <vprintfmt+0x8b>
            goto process_precision;
  109a0c:	eb 33                	jmp    109a41 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  109a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  109a11:	8d 50 04             	lea    0x4(%eax),%edx
  109a14:	89 55 14             	mov    %edx,0x14(%ebp)
  109a17:	8b 00                	mov    (%eax),%eax
  109a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  109a1c:	eb 23                	jmp    109a41 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  109a1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  109a22:	79 0c                	jns    109a30 <vprintfmt+0xdc>
                width = 0;
  109a24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  109a2b:	e9 78 ff ff ff       	jmp    1099a8 <vprintfmt+0x54>
  109a30:	e9 73 ff ff ff       	jmp    1099a8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  109a35:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  109a3c:	e9 67 ff ff ff       	jmp    1099a8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  109a41:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  109a45:	79 12                	jns    109a59 <vprintfmt+0x105>
                width = precision, precision = -1;
  109a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109a4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  109a4d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  109a54:	e9 4f ff ff ff       	jmp    1099a8 <vprintfmt+0x54>
  109a59:	e9 4a ff ff ff       	jmp    1099a8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  109a5e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  109a62:	e9 41 ff ff ff       	jmp    1099a8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  109a67:	8b 45 14             	mov    0x14(%ebp),%eax
  109a6a:	8d 50 04             	lea    0x4(%eax),%edx
  109a6d:	89 55 14             	mov    %edx,0x14(%ebp)
  109a70:	8b 00                	mov    (%eax),%eax
  109a72:	8b 55 0c             	mov    0xc(%ebp),%edx
  109a75:	89 54 24 04          	mov    %edx,0x4(%esp)
  109a79:	89 04 24             	mov    %eax,(%esp)
  109a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  109a7f:	ff d0                	call   *%eax
            break;
  109a81:	e9 ac 02 00 00       	jmp    109d32 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  109a86:	8b 45 14             	mov    0x14(%ebp),%eax
  109a89:	8d 50 04             	lea    0x4(%eax),%edx
  109a8c:	89 55 14             	mov    %edx,0x14(%ebp)
  109a8f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  109a91:	85 db                	test   %ebx,%ebx
  109a93:	79 02                	jns    109a97 <vprintfmt+0x143>
                err = -err;
  109a95:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  109a97:	83 fb 06             	cmp    $0x6,%ebx
  109a9a:	7f 0b                	jg     109aa7 <vprintfmt+0x153>
  109a9c:	8b 34 9d 78 b3 10 00 	mov    0x10b378(,%ebx,4),%esi
  109aa3:	85 f6                	test   %esi,%esi
  109aa5:	75 23                	jne    109aca <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  109aa7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  109aab:	c7 44 24 08 a5 b3 10 	movl   $0x10b3a5,0x8(%esp)
  109ab2:	00 
  109ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  109ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
  109aba:	8b 45 08             	mov    0x8(%ebp),%eax
  109abd:	89 04 24             	mov    %eax,(%esp)
  109ac0:	e8 61 fe ff ff       	call   109926 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  109ac5:	e9 68 02 00 00       	jmp    109d32 <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
  109aca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  109ace:	c7 44 24 08 ae b3 10 	movl   $0x10b3ae,0x8(%esp)
  109ad5:	00 
  109ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  109ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  109add:	8b 45 08             	mov    0x8(%ebp),%eax
  109ae0:	89 04 24             	mov    %eax,(%esp)
  109ae3:	e8 3e fe ff ff       	call   109926 <printfmt>
            break;
  109ae8:	e9 45 02 00 00       	jmp    109d32 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  109aed:	8b 45 14             	mov    0x14(%ebp),%eax
  109af0:	8d 50 04             	lea    0x4(%eax),%edx
  109af3:	89 55 14             	mov    %edx,0x14(%ebp)
  109af6:	8b 30                	mov    (%eax),%esi
  109af8:	85 f6                	test   %esi,%esi
  109afa:	75 05                	jne    109b01 <vprintfmt+0x1ad>
                p = "(null)";
  109afc:	be b1 b3 10 00       	mov    $0x10b3b1,%esi
            }
            if (width > 0 && padc != '-') {
  109b01:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  109b05:	7e 3e                	jle    109b45 <vprintfmt+0x1f1>
  109b07:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  109b0b:	74 38                	je     109b45 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  109b0d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  109b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  109b17:	89 34 24             	mov    %esi,(%esp)
  109b1a:	e8 dc f7 ff ff       	call   1092fb <strnlen>
  109b1f:	29 c3                	sub    %eax,%ebx
  109b21:	89 d8                	mov    %ebx,%eax
  109b23:	89 45 e8             	mov    %eax,-0x18(%ebp)
  109b26:	eb 17                	jmp    109b3f <vprintfmt+0x1eb>
                    putch(padc, putdat);
  109b28:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  109b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  109b2f:	89 54 24 04          	mov    %edx,0x4(%esp)
  109b33:	89 04 24             	mov    %eax,(%esp)
  109b36:	8b 45 08             	mov    0x8(%ebp),%eax
  109b39:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  109b3b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  109b3f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  109b43:	7f e3                	jg     109b28 <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  109b45:	eb 38                	jmp    109b7f <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  109b47:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  109b4b:	74 1f                	je     109b6c <vprintfmt+0x218>
  109b4d:	83 fb 1f             	cmp    $0x1f,%ebx
  109b50:	7e 05                	jle    109b57 <vprintfmt+0x203>
  109b52:	83 fb 7e             	cmp    $0x7e,%ebx
  109b55:	7e 15                	jle    109b6c <vprintfmt+0x218>
                    putch('?', putdat);
  109b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  109b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  109b5e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  109b65:	8b 45 08             	mov    0x8(%ebp),%eax
  109b68:	ff d0                	call   *%eax
  109b6a:	eb 0f                	jmp    109b7b <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  109b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  109b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  109b73:	89 1c 24             	mov    %ebx,(%esp)
  109b76:	8b 45 08             	mov    0x8(%ebp),%eax
  109b79:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  109b7b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  109b7f:	89 f0                	mov    %esi,%eax
  109b81:	8d 70 01             	lea    0x1(%eax),%esi
  109b84:	0f b6 00             	movzbl (%eax),%eax
  109b87:	0f be d8             	movsbl %al,%ebx
  109b8a:	85 db                	test   %ebx,%ebx
  109b8c:	74 10                	je     109b9e <vprintfmt+0x24a>
  109b8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  109b92:	78 b3                	js     109b47 <vprintfmt+0x1f3>
  109b94:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  109b98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  109b9c:	79 a9                	jns    109b47 <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
  109b9e:	eb 17                	jmp    109bb7 <vprintfmt+0x263>
                putch(' ', putdat);
  109ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  109ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  109ba7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  109bae:	8b 45 08             	mov    0x8(%ebp),%eax
  109bb1:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  109bb3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  109bb7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  109bbb:	7f e3                	jg     109ba0 <vprintfmt+0x24c>
            }
            break;
  109bbd:	e9 70 01 00 00       	jmp    109d32 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  109bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  109bc9:	8d 45 14             	lea    0x14(%ebp),%eax
  109bcc:	89 04 24             	mov    %eax,(%esp)
  109bcf:	e8 0b fd ff ff       	call   1098df <getint>
  109bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109bd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  109bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  109be0:	85 d2                	test   %edx,%edx
  109be2:	79 26                	jns    109c0a <vprintfmt+0x2b6>
                putch('-', putdat);
  109be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  109be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  109beb:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  109bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  109bf5:	ff d0                	call   *%eax
                num = -(long long)num;
  109bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  109bfd:	f7 d8                	neg    %eax
  109bff:	83 d2 00             	adc    $0x0,%edx
  109c02:	f7 da                	neg    %edx
  109c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109c07:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  109c0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  109c11:	e9 a8 00 00 00       	jmp    109cbe <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  109c16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109c19:	89 44 24 04          	mov    %eax,0x4(%esp)
  109c1d:	8d 45 14             	lea    0x14(%ebp),%eax
  109c20:	89 04 24             	mov    %eax,(%esp)
  109c23:	e8 68 fc ff ff       	call   109890 <getuint>
  109c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  109c2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  109c35:	e9 84 00 00 00       	jmp    109cbe <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  109c3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  109c41:	8d 45 14             	lea    0x14(%ebp),%eax
  109c44:	89 04 24             	mov    %eax,(%esp)
  109c47:	e8 44 fc ff ff       	call   109890 <getuint>
  109c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109c4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  109c52:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  109c59:	eb 63                	jmp    109cbe <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  109c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  109c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  109c62:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  109c69:	8b 45 08             	mov    0x8(%ebp),%eax
  109c6c:	ff d0                	call   *%eax
            putch('x', putdat);
  109c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  109c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  109c75:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  109c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  109c7f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  109c81:	8b 45 14             	mov    0x14(%ebp),%eax
  109c84:	8d 50 04             	lea    0x4(%eax),%edx
  109c87:	89 55 14             	mov    %edx,0x14(%ebp)
  109c8a:	8b 00                	mov    (%eax),%eax
  109c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109c8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  109c96:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  109c9d:	eb 1f                	jmp    109cbe <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  109c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  109ca6:	8d 45 14             	lea    0x14(%ebp),%eax
  109ca9:	89 04 24             	mov    %eax,(%esp)
  109cac:	e8 df fb ff ff       	call   109890 <getuint>
  109cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109cb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  109cb7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  109cbe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  109cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  109cc5:	89 54 24 18          	mov    %edx,0x18(%esp)
  109cc9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  109ccc:	89 54 24 14          	mov    %edx,0x14(%esp)
  109cd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  109cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109cd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  109cda:	89 44 24 08          	mov    %eax,0x8(%esp)
  109cde:	89 54 24 0c          	mov    %edx,0xc(%esp)
  109ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  109ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
  109ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  109cec:	89 04 24             	mov    %eax,(%esp)
  109cef:	e8 97 fa ff ff       	call   10978b <printnum>
            break;
  109cf4:	eb 3c                	jmp    109d32 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  109cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  109cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  109cfd:	89 1c 24             	mov    %ebx,(%esp)
  109d00:	8b 45 08             	mov    0x8(%ebp),%eax
  109d03:	ff d0                	call   *%eax
            break;
  109d05:	eb 2b                	jmp    109d32 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  109d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  109d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  109d0e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  109d15:	8b 45 08             	mov    0x8(%ebp),%eax
  109d18:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  109d1a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  109d1e:	eb 04                	jmp    109d24 <vprintfmt+0x3d0>
  109d20:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  109d24:	8b 45 10             	mov    0x10(%ebp),%eax
  109d27:	83 e8 01             	sub    $0x1,%eax
  109d2a:	0f b6 00             	movzbl (%eax),%eax
  109d2d:	3c 25                	cmp    $0x25,%al
  109d2f:	75 ef                	jne    109d20 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  109d31:	90                   	nop
        }
    }
  109d32:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  109d33:	e9 3e fc ff ff       	jmp    109976 <vprintfmt+0x22>
}
  109d38:	83 c4 40             	add    $0x40,%esp
  109d3b:	5b                   	pop    %ebx
  109d3c:	5e                   	pop    %esi
  109d3d:	5d                   	pop    %ebp
  109d3e:	c3                   	ret    

00109d3f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  109d3f:	55                   	push   %ebp
  109d40:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  109d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  109d45:	8b 40 08             	mov    0x8(%eax),%eax
  109d48:	8d 50 01             	lea    0x1(%eax),%edx
  109d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  109d4e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  109d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  109d54:	8b 10                	mov    (%eax),%edx
  109d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  109d59:	8b 40 04             	mov    0x4(%eax),%eax
  109d5c:	39 c2                	cmp    %eax,%edx
  109d5e:	73 12                	jae    109d72 <sprintputch+0x33>
        *b->buf ++ = ch;
  109d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  109d63:	8b 00                	mov    (%eax),%eax
  109d65:	8d 48 01             	lea    0x1(%eax),%ecx
  109d68:	8b 55 0c             	mov    0xc(%ebp),%edx
  109d6b:	89 0a                	mov    %ecx,(%edx)
  109d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  109d70:	88 10                	mov    %dl,(%eax)
    }
}
  109d72:	5d                   	pop    %ebp
  109d73:	c3                   	ret    

00109d74 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  109d74:	55                   	push   %ebp
  109d75:	89 e5                	mov    %esp,%ebp
  109d77:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  109d7a:	8d 45 14             	lea    0x14(%ebp),%eax
  109d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  109d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109d83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  109d87:	8b 45 10             	mov    0x10(%ebp),%eax
  109d8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  109d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  109d91:	89 44 24 04          	mov    %eax,0x4(%esp)
  109d95:	8b 45 08             	mov    0x8(%ebp),%eax
  109d98:	89 04 24             	mov    %eax,(%esp)
  109d9b:	e8 08 00 00 00       	call   109da8 <vsnprintf>
  109da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  109da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  109da6:	c9                   	leave  
  109da7:	c3                   	ret    

00109da8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  109da8:	55                   	push   %ebp
  109da9:	89 e5                	mov    %esp,%ebp
  109dab:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  109dae:	8b 45 08             	mov    0x8(%ebp),%eax
  109db1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  109db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  109db7:	8d 50 ff             	lea    -0x1(%eax),%edx
  109dba:	8b 45 08             	mov    0x8(%ebp),%eax
  109dbd:	01 d0                	add    %edx,%eax
  109dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109dc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  109dc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  109dcd:	74 0a                	je     109dd9 <vsnprintf+0x31>
  109dcf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  109dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109dd5:	39 c2                	cmp    %eax,%edx
  109dd7:	76 07                	jbe    109de0 <vsnprintf+0x38>
        return -E_INVAL;
  109dd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  109dde:	eb 2a                	jmp    109e0a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  109de0:	8b 45 14             	mov    0x14(%ebp),%eax
  109de3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  109de7:	8b 45 10             	mov    0x10(%ebp),%eax
  109dea:	89 44 24 08          	mov    %eax,0x8(%esp)
  109dee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  109df1:	89 44 24 04          	mov    %eax,0x4(%esp)
  109df5:	c7 04 24 3f 9d 10 00 	movl   $0x109d3f,(%esp)
  109dfc:	e8 53 fb ff ff       	call   109954 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  109e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  109e04:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  109e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  109e0a:	c9                   	leave  
  109e0b:	c3                   	ret    
