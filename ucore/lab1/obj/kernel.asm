
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 a2 2d 00 00       	call   102dc6 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 30 15 00 00       	call   10155c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 60 35 10 00 	movl   $0x103560,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 7c 35 10 00       	push   $0x10357c
  10003e:	e8 0a 02 00 00       	call   10024d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 8c 08 00 00       	call   1008d7 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 79 00 00 00       	call   1000c9 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 35 2a 00 00       	call   102a8a <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 45 16 00 00       	call   10169f <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 c7 17 00 00       	call   101826 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 d9 0c 00 00       	call   100d3d <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 73 17 00 00       	call   1017dc <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 50 01 00 00       	call   1001be <lab1_switch_test>

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	83 ec 04             	sub    $0x4,%esp
  100079:	6a 00                	push   $0x0
  10007b:	6a 00                	push   $0x0
  10007d:	6a 00                	push   $0x0
  10007f:	e8 a7 0c 00 00       	call   100d2b <mon_backtrace>
  100084:	83 c4 10             	add    $0x10,%esp
}
  100087:	90                   	nop
  100088:	c9                   	leave  
  100089:	c3                   	ret    

0010008a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10008a:	55                   	push   %ebp
  10008b:	89 e5                	mov    %esp,%ebp
  10008d:	53                   	push   %ebx
  10008e:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  100091:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100094:	8b 55 0c             	mov    0xc(%ebp),%edx
  100097:	8d 5d 08             	lea    0x8(%ebp),%ebx
  10009a:	8b 45 08             	mov    0x8(%ebp),%eax
  10009d:	51                   	push   %ecx
  10009e:	52                   	push   %edx
  10009f:	53                   	push   %ebx
  1000a0:	50                   	push   %eax
  1000a1:	e8 ca ff ff ff       	call   100070 <grade_backtrace2>
  1000a6:	83 c4 10             	add    $0x10,%esp
}
  1000a9:	90                   	nop
  1000aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b5:	83 ec 08             	sub    $0x8,%esp
  1000b8:	ff 75 10             	pushl  0x10(%ebp)
  1000bb:	ff 75 08             	pushl  0x8(%ebp)
  1000be:	e8 c7 ff ff ff       	call   10008a <grade_backtrace1>
  1000c3:	83 c4 10             	add    $0x10,%esp
}
  1000c6:	90                   	nop
  1000c7:	c9                   	leave  
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cf:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d4:	83 ec 04             	sub    $0x4,%esp
  1000d7:	68 00 00 ff ff       	push   $0xffff0000
  1000dc:	50                   	push   %eax
  1000dd:	6a 00                	push   $0x0
  1000df:	e8 cb ff ff ff       	call   1000af <grade_backtrace0>
  1000e4:	83 c4 10             	add    $0x10,%esp
}
  1000e7:	90                   	nop
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    

001000ea <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000ea:	55                   	push   %ebp
  1000eb:	89 e5                	mov    %esp,%ebp
  1000ed:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000f0:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000f3:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f6:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f9:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000fc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100100:	0f b7 c0             	movzwl %ax,%eax
  100103:	83 e0 03             	and    $0x3,%eax
  100106:	89 c2                	mov    %eax,%edx
  100108:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10010d:	83 ec 04             	sub    $0x4,%esp
  100110:	52                   	push   %edx
  100111:	50                   	push   %eax
  100112:	68 81 35 10 00       	push   $0x103581
  100117:	e8 31 01 00 00       	call   10024d <cprintf>
  10011c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100123:	0f b7 d0             	movzwl %ax,%edx
  100126:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012b:	83 ec 04             	sub    $0x4,%esp
  10012e:	52                   	push   %edx
  10012f:	50                   	push   %eax
  100130:	68 8f 35 10 00       	push   $0x10358f
  100135:	e8 13 01 00 00       	call   10024d <cprintf>
  10013a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10013d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100141:	0f b7 d0             	movzwl %ax,%edx
  100144:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100149:	83 ec 04             	sub    $0x4,%esp
  10014c:	52                   	push   %edx
  10014d:	50                   	push   %eax
  10014e:	68 9d 35 10 00       	push   $0x10359d
  100153:	e8 f5 00 00 00       	call   10024d <cprintf>
  100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10015b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015f:	0f b7 d0             	movzwl %ax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	83 ec 04             	sub    $0x4,%esp
  10016a:	52                   	push   %edx
  10016b:	50                   	push   %eax
  10016c:	68 ab 35 10 00       	push   $0x1035ab
  100171:	e8 d7 00 00 00       	call   10024d <cprintf>
  100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100179:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10017d:	0f b7 d0             	movzwl %ax,%edx
  100180:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100185:	83 ec 04             	sub    $0x4,%esp
  100188:	52                   	push   %edx
  100189:	50                   	push   %eax
  10018a:	68 b9 35 10 00       	push   $0x1035b9
  10018f:	e8 b9 00 00 00       	call   10024d <cprintf>
  100194:	83 c4 10             	add    $0x10,%esp
    round ++;
  100197:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10019c:	83 c0 01             	add    $0x1,%eax
  10019f:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001a4:	90                   	nop
  1001a5:	c9                   	leave  
  1001a6:	c3                   	ret    

001001a7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a7:	55                   	push   %ebp
  1001a8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile(
  1001aa:	83 ec 08             	sub    $0x8,%esp
  1001ad:	cd 78                	int    $0x78
  1001af:	89 ec                	mov    %ebp,%esp
		"int %0 \n"//调用 T_SWITCH_TOU 中断
		"movl %%ebp,%%esp"//恢复栈指针
		:
		: "i"(T_SWITCH_TOU)
	);
}
  1001b1:	90                   	nop
  1001b2:	5d                   	pop    %ebp
  1001b3:	c3                   	ret    

001001b4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001b4:	55                   	push   %ebp
  1001b5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	//把tf->tf_cs和tf->tf_ds都设置为内核代码段和内核数据段
	asm volatile(
  1001b7:	cd 79                	int    $0x79
  1001b9:	89 ec                	mov    %ebp,%esp
		"int %0 \n"// //调用T_SWITCH_TOK号中断
		"movl %%ebp, %%esp \n"//强行改为内核态，会让cpu认为没有发生特权级转换，%esp的值就不对了
		:
		: "i"(T_SWITCH_TOK)
	);
}
  1001bb:	90                   	nop
  1001bc:	5d                   	pop    %ebp
  1001bd:	c3                   	ret    

001001be <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001be:	55                   	push   %ebp
  1001bf:	89 e5                	mov    %esp,%ebp
  1001c1:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001c4:	e8 21 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c9:	83 ec 0c             	sub    $0xc,%esp
  1001cc:	68 c8 35 10 00       	push   $0x1035c8
  1001d1:	e8 77 00 00 00       	call   10024d <cprintf>
  1001d6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d9:	e8 c9 ff ff ff       	call   1001a7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001de:	e8 07 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001e3:	83 ec 0c             	sub    $0xc,%esp
  1001e6:	68 e8 35 10 00       	push   $0x1035e8
  1001eb:	e8 5d 00 00 00       	call   10024d <cprintf>
  1001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001f3:	e8 bc ff ff ff       	call   1001b4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001f8:	e8 ed fe ff ff       	call   1000ea <lab1_print_cur_status>
}
  1001fd:	90                   	nop
  1001fe:	c9                   	leave  
  1001ff:	c3                   	ret    

00100200 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100200:	55                   	push   %ebp
  100201:	89 e5                	mov    %esp,%ebp
  100203:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100206:	83 ec 0c             	sub    $0xc,%esp
  100209:	ff 75 08             	pushl  0x8(%ebp)
  10020c:	e8 7c 13 00 00       	call   10158d <cons_putc>
  100211:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100214:	8b 45 0c             	mov    0xc(%ebp),%eax
  100217:	8b 00                	mov    (%eax),%eax
  100219:	8d 50 01             	lea    0x1(%eax),%edx
  10021c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021f:	89 10                	mov    %edx,(%eax)
}
  100221:	90                   	nop
  100222:	c9                   	leave  
  100223:	c3                   	ret    

00100224 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100224:	55                   	push   %ebp
  100225:	89 e5                	mov    %esp,%ebp
  100227:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10022a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100231:	ff 75 0c             	pushl  0xc(%ebp)
  100234:	ff 75 08             	pushl  0x8(%ebp)
  100237:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10023a:	50                   	push   %eax
  10023b:	68 00 02 10 00       	push   $0x100200
  100240:	e8 b7 2e 00 00       	call   1030fc <vprintfmt>
  100245:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100248:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10024b:	c9                   	leave  
  10024c:	c3                   	ret    

0010024d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10024d:	55                   	push   %ebp
  10024e:	89 e5                	mov    %esp,%ebp
  100250:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100253:	8d 45 0c             	lea    0xc(%ebp),%eax
  100256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025c:	83 ec 08             	sub    $0x8,%esp
  10025f:	50                   	push   %eax
  100260:	ff 75 08             	pushl  0x8(%ebp)
  100263:	e8 bc ff ff ff       	call   100224 <vcprintf>
  100268:	83 c4 10             	add    $0x10,%esp
  10026b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100271:	c9                   	leave  
  100272:	c3                   	ret    

00100273 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100273:	55                   	push   %ebp
  100274:	89 e5                	mov    %esp,%ebp
  100276:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100279:	83 ec 0c             	sub    $0xc,%esp
  10027c:	ff 75 08             	pushl  0x8(%ebp)
  10027f:	e8 09 13 00 00       	call   10158d <cons_putc>
  100284:	83 c4 10             	add    $0x10,%esp
}
  100287:	90                   	nop
  100288:	c9                   	leave  
  100289:	c3                   	ret    

0010028a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10028a:	55                   	push   %ebp
  10028b:	89 e5                	mov    %esp,%ebp
  10028d:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100290:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100297:	eb 14                	jmp    1002ad <cputs+0x23>
        cputch(c, &cnt);
  100299:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10029d:	83 ec 08             	sub    $0x8,%esp
  1002a0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002a3:	52                   	push   %edx
  1002a4:	50                   	push   %eax
  1002a5:	e8 56 ff ff ff       	call   100200 <cputch>
  1002aa:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  1002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b0:	8d 50 01             	lea    0x1(%eax),%edx
  1002b3:	89 55 08             	mov    %edx,0x8(%ebp)
  1002b6:	0f b6 00             	movzbl (%eax),%eax
  1002b9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002bc:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002c0:	75 d7                	jne    100299 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002c2:	83 ec 08             	sub    $0x8,%esp
  1002c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002c8:	50                   	push   %eax
  1002c9:	6a 0a                	push   $0xa
  1002cb:	e8 30 ff ff ff       	call   100200 <cputch>
  1002d0:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002d6:	c9                   	leave  
  1002d7:	c3                   	ret    

001002d8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002d8:	55                   	push   %ebp
  1002d9:	89 e5                	mov    %esp,%ebp
  1002db:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002de:	e8 da 12 00 00       	call   1015bd <cons_getc>
  1002e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ea:	74 f2                	je     1002de <getchar+0x6>
        /* do nothing */;
    return c;
  1002ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ef:	c9                   	leave  
  1002f0:	c3                   	ret    

001002f1 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002f1:	55                   	push   %ebp
  1002f2:	89 e5                	mov    %esp,%ebp
  1002f4:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002fb:	74 13                	je     100310 <readline+0x1f>
        cprintf("%s", prompt);
  1002fd:	83 ec 08             	sub    $0x8,%esp
  100300:	ff 75 08             	pushl  0x8(%ebp)
  100303:	68 07 36 10 00       	push   $0x103607
  100308:	e8 40 ff ff ff       	call   10024d <cprintf>
  10030d:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100310:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100317:	e8 bc ff ff ff       	call   1002d8 <getchar>
  10031c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10031f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100323:	79 0a                	jns    10032f <readline+0x3e>
            return NULL;
  100325:	b8 00 00 00 00       	mov    $0x0,%eax
  10032a:	e9 82 00 00 00       	jmp    1003b1 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10032f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100333:	7e 2b                	jle    100360 <readline+0x6f>
  100335:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10033c:	7f 22                	jg     100360 <readline+0x6f>
            cputchar(c);
  10033e:	83 ec 0c             	sub    $0xc,%esp
  100341:	ff 75 f0             	pushl  -0x10(%ebp)
  100344:	e8 2a ff ff ff       	call   100273 <cputchar>
  100349:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10034c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10034f:	8d 50 01             	lea    0x1(%eax),%edx
  100352:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100355:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100358:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10035e:	eb 4c                	jmp    1003ac <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100360:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100364:	75 1a                	jne    100380 <readline+0x8f>
  100366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10036a:	7e 14                	jle    100380 <readline+0x8f>
            cputchar(c);
  10036c:	83 ec 0c             	sub    $0xc,%esp
  10036f:	ff 75 f0             	pushl  -0x10(%ebp)
  100372:	e8 fc fe ff ff       	call   100273 <cputchar>
  100377:	83 c4 10             	add    $0x10,%esp
            i --;
  10037a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10037e:	eb 2c                	jmp    1003ac <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  100380:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100384:	74 06                	je     10038c <readline+0x9b>
  100386:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10038a:	75 8b                	jne    100317 <readline+0x26>
            cputchar(c);
  10038c:	83 ec 0c             	sub    $0xc,%esp
  10038f:	ff 75 f0             	pushl  -0x10(%ebp)
  100392:	e8 dc fe ff ff       	call   100273 <cputchar>
  100397:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  10039a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003a2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003a5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003aa:	eb 05                	jmp    1003b1 <readline+0xc0>
        c = getchar();
  1003ac:	e9 66 ff ff ff       	jmp    100317 <readline+0x26>
        }
    }
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003b9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003be:	85 c0                	test   %eax,%eax
  1003c0:	75 4a                	jne    10040c <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003c2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003c9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003d2:	83 ec 04             	sub    $0x4,%esp
  1003d5:	ff 75 0c             	pushl  0xc(%ebp)
  1003d8:	ff 75 08             	pushl  0x8(%ebp)
  1003db:	68 0a 36 10 00       	push   $0x10360a
  1003e0:	e8 68 fe ff ff       	call   10024d <cprintf>
  1003e5:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003eb:	83 ec 08             	sub    $0x8,%esp
  1003ee:	50                   	push   %eax
  1003ef:	ff 75 10             	pushl  0x10(%ebp)
  1003f2:	e8 2d fe ff ff       	call   100224 <vcprintf>
  1003f7:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003fa:	83 ec 0c             	sub    $0xc,%esp
  1003fd:	68 26 36 10 00       	push   $0x103626
  100402:	e8 46 fe ff ff       	call   10024d <cprintf>
  100407:	83 c4 10             	add    $0x10,%esp
  10040a:	eb 01                	jmp    10040d <__panic+0x5a>
        goto panic_dead;
  10040c:	90                   	nop
    va_end(ap);

panic_dead:
    intr_disable();
  10040d:	e8 d1 13 00 00       	call   1017e3 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100412:	83 ec 0c             	sub    $0xc,%esp
  100415:	6a 00                	push   $0x0
  100417:	e8 35 08 00 00       	call   100c51 <kmonitor>
  10041c:	83 c4 10             	add    $0x10,%esp
  10041f:	eb f1                	jmp    100412 <__panic+0x5f>

00100421 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100421:	55                   	push   %ebp
  100422:	89 e5                	mov    %esp,%ebp
  100424:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100427:	8d 45 14             	lea    0x14(%ebp),%eax
  10042a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10042d:	83 ec 04             	sub    $0x4,%esp
  100430:	ff 75 0c             	pushl  0xc(%ebp)
  100433:	ff 75 08             	pushl  0x8(%ebp)
  100436:	68 28 36 10 00       	push   $0x103628
  10043b:	e8 0d fe ff ff       	call   10024d <cprintf>
  100440:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100446:	83 ec 08             	sub    $0x8,%esp
  100449:	50                   	push   %eax
  10044a:	ff 75 10             	pushl  0x10(%ebp)
  10044d:	e8 d2 fd ff ff       	call   100224 <vcprintf>
  100452:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100455:	83 ec 0c             	sub    $0xc,%esp
  100458:	68 26 36 10 00       	push   $0x103626
  10045d:	e8 eb fd ff ff       	call   10024d <cprintf>
  100462:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100465:	90                   	nop
  100466:	c9                   	leave  
  100467:	c3                   	ret    

00100468 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100468:	55                   	push   %ebp
  100469:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10046b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100470:	5d                   	pop    %ebp
  100471:	c3                   	ret    

00100472 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100472:	55                   	push   %ebp
  100473:	89 e5                	mov    %esp,%ebp
  100475:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100478:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047b:	8b 00                	mov    (%eax),%eax
  10047d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100480:	8b 45 10             	mov    0x10(%ebp),%eax
  100483:	8b 00                	mov    (%eax),%eax
  100485:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10048f:	e9 d2 00 00 00       	jmp    100566 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100494:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100497:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10049a:	01 d0                	add    %edx,%eax
  10049c:	89 c2                	mov    %eax,%edx
  10049e:	c1 ea 1f             	shr    $0x1f,%edx
  1004a1:	01 d0                	add    %edx,%eax
  1004a3:	d1 f8                	sar    %eax
  1004a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ae:	eb 04                	jmp    1004b4 <stab_binsearch+0x42>
            m --;
  1004b0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ba:	7c 1f                	jl     1004db <stab_binsearch+0x69>
  1004bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bf:	89 d0                	mov    %edx,%eax
  1004c1:	01 c0                	add    %eax,%eax
  1004c3:	01 d0                	add    %edx,%eax
  1004c5:	c1 e0 02             	shl    $0x2,%eax
  1004c8:	89 c2                	mov    %eax,%edx
  1004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1004cd:	01 d0                	add    %edx,%eax
  1004cf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004d3:	0f b6 c0             	movzbl %al,%eax
  1004d6:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004d9:	75 d5                	jne    1004b0 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e1:	7d 0b                	jge    1004ee <stab_binsearch+0x7c>
            l = true_m + 1;
  1004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004e6:	83 c0 01             	add    $0x1,%eax
  1004e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004ec:	eb 78                	jmp    100566 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f8:	89 d0                	mov    %edx,%eax
  1004fa:	01 c0                	add    %eax,%eax
  1004fc:	01 d0                	add    %edx,%eax
  1004fe:	c1 e0 02             	shl    $0x2,%eax
  100501:	89 c2                	mov    %eax,%edx
  100503:	8b 45 08             	mov    0x8(%ebp),%eax
  100506:	01 d0                	add    %edx,%eax
  100508:	8b 40 08             	mov    0x8(%eax),%eax
  10050b:	39 45 18             	cmp    %eax,0x18(%ebp)
  10050e:	76 13                	jbe    100523 <stab_binsearch+0xb1>
            *region_left = m;
  100510:	8b 45 0c             	mov    0xc(%ebp),%eax
  100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100516:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10051b:	83 c0 01             	add    $0x1,%eax
  10051e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100521:	eb 43                	jmp    100566 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100523:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100526:	89 d0                	mov    %edx,%eax
  100528:	01 c0                	add    %eax,%eax
  10052a:	01 d0                	add    %edx,%eax
  10052c:	c1 e0 02             	shl    $0x2,%eax
  10052f:	89 c2                	mov    %eax,%edx
  100531:	8b 45 08             	mov    0x8(%ebp),%eax
  100534:	01 d0                	add    %edx,%eax
  100536:	8b 40 08             	mov    0x8(%eax),%eax
  100539:	39 45 18             	cmp    %eax,0x18(%ebp)
  10053c:	73 16                	jae    100554 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10053e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100541:	8d 50 ff             	lea    -0x1(%eax),%edx
  100544:	8b 45 10             	mov    0x10(%ebp),%eax
  100547:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054c:	83 e8 01             	sub    $0x1,%eax
  10054f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100552:	eb 12                	jmp    100566 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100554:	8b 45 0c             	mov    0xc(%ebp),%eax
  100557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055a:	89 10                	mov    %edx,(%eax)
            l = m;
  10055c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100562:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100566:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100569:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10056c:	0f 8e 22 ff ff ff    	jle    100494 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100576:	75 0f                	jne    100587 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100578:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057b:	8b 00                	mov    (%eax),%eax
  10057d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100580:	8b 45 10             	mov    0x10(%ebp),%eax
  100583:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100585:	eb 3f                	jmp    1005c6 <stab_binsearch+0x154>
        l = *region_right;
  100587:	8b 45 10             	mov    0x10(%ebp),%eax
  10058a:	8b 00                	mov    (%eax),%eax
  10058c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10058f:	eb 04                	jmp    100595 <stab_binsearch+0x123>
  100591:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100595:	8b 45 0c             	mov    0xc(%ebp),%eax
  100598:	8b 00                	mov    (%eax),%eax
  10059a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  10059d:	7e 1f                	jle    1005be <stab_binsearch+0x14c>
  10059f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005a2:	89 d0                	mov    %edx,%eax
  1005a4:	01 c0                	add    %eax,%eax
  1005a6:	01 d0                	add    %edx,%eax
  1005a8:	c1 e0 02             	shl    $0x2,%eax
  1005ab:	89 c2                	mov    %eax,%edx
  1005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b0:	01 d0                	add    %edx,%eax
  1005b2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005b6:	0f b6 c0             	movzbl %al,%eax
  1005b9:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005bc:	75 d3                	jne    100591 <stab_binsearch+0x11f>
        *region_left = l;
  1005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c4:	89 10                	mov    %edx,(%eax)
}
  1005c6:	90                   	nop
  1005c7:	c9                   	leave  
  1005c8:	c3                   	ret    

001005c9 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005c9:	55                   	push   %ebp
  1005ca:	89 e5                	mov    %esp,%ebp
  1005cc:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d2:	c7 00 48 36 10 00    	movl   $0x103648,(%eax)
    info->eip_line = 0;
  1005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e5:	c7 40 08 48 36 10 00 	movl   $0x103648,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ef:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1005fc:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100602:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100609:	c7 45 f4 8c 3e 10 00 	movl   $0x103e8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100610:	c7 45 f0 20 bc 10 00 	movl   $0x10bc20,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100617:	c7 45 ec 21 bc 10 00 	movl   $0x10bc21,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10061e:	c7 45 e8 08 dd 10 00 	movl   $0x10dd08,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100628:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10062b:	76 0d                	jbe    10063a <debuginfo_eip+0x71>
  10062d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100630:	83 e8 01             	sub    $0x1,%eax
  100633:	0f b6 00             	movzbl (%eax),%eax
  100636:	84 c0                	test   %al,%al
  100638:	74 0a                	je     100644 <debuginfo_eip+0x7b>
        return -1;
  10063a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10063f:	e9 91 02 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100644:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10064b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10064e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100651:	29 c2                	sub    %eax,%edx
  100653:	89 d0                	mov    %edx,%eax
  100655:	c1 f8 02             	sar    $0x2,%eax
  100658:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10065e:	83 e8 01             	sub    $0x1,%eax
  100661:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100664:	ff 75 08             	pushl  0x8(%ebp)
  100667:	6a 64                	push   $0x64
  100669:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10066c:	50                   	push   %eax
  10066d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100670:	50                   	push   %eax
  100671:	ff 75 f4             	pushl  -0xc(%ebp)
  100674:	e8 f9 fd ff ff       	call   100472 <stab_binsearch>
  100679:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10067c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10067f:	85 c0                	test   %eax,%eax
  100681:	75 0a                	jne    10068d <debuginfo_eip+0xc4>
        return -1;
  100683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100688:	e9 48 02 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10068d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100690:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100693:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100696:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100699:	ff 75 08             	pushl  0x8(%ebp)
  10069c:	6a 24                	push   $0x24
  10069e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006a1:	50                   	push   %eax
  1006a2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006a5:	50                   	push   %eax
  1006a6:	ff 75 f4             	pushl  -0xc(%ebp)
  1006a9:	e8 c4 fd ff ff       	call   100472 <stab_binsearch>
  1006ae:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006b7:	39 c2                	cmp    %eax,%edx
  1006b9:	7f 7c                	jg     100737 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006be:	89 c2                	mov    %eax,%edx
  1006c0:	89 d0                	mov    %edx,%eax
  1006c2:	01 c0                	add    %eax,%eax
  1006c4:	01 d0                	add    %edx,%eax
  1006c6:	c1 e0 02             	shl    $0x2,%eax
  1006c9:	89 c2                	mov    %eax,%edx
  1006cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ce:	01 d0                	add    %edx,%eax
  1006d0:	8b 00                	mov    (%eax),%eax
  1006d2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006d8:	29 d1                	sub    %edx,%ecx
  1006da:	89 ca                	mov    %ecx,%edx
  1006dc:	39 d0                	cmp    %edx,%eax
  1006de:	73 22                	jae    100702 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006e3:	89 c2                	mov    %eax,%edx
  1006e5:	89 d0                	mov    %edx,%eax
  1006e7:	01 c0                	add    %eax,%eax
  1006e9:	01 d0                	add    %edx,%eax
  1006eb:	c1 e0 02             	shl    $0x2,%eax
  1006ee:	89 c2                	mov    %eax,%edx
  1006f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f3:	01 d0                	add    %edx,%eax
  1006f5:	8b 10                	mov    (%eax),%edx
  1006f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006fa:	01 c2                	add    %eax,%edx
  1006fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ff:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100702:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100705:	89 c2                	mov    %eax,%edx
  100707:	89 d0                	mov    %edx,%eax
  100709:	01 c0                	add    %eax,%eax
  10070b:	01 d0                	add    %edx,%eax
  10070d:	c1 e0 02             	shl    $0x2,%eax
  100710:	89 c2                	mov    %eax,%edx
  100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100715:	01 d0                	add    %edx,%eax
  100717:	8b 50 08             	mov    0x8(%eax),%edx
  10071a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	8b 40 10             	mov    0x10(%eax),%eax
  100726:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100729:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10072f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100732:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100735:	eb 15                	jmp    10074c <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100737:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073a:	8b 55 08             	mov    0x8(%ebp),%edx
  10073d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100743:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100749:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074f:	8b 40 08             	mov    0x8(%eax),%eax
  100752:	83 ec 08             	sub    $0x8,%esp
  100755:	6a 3a                	push   $0x3a
  100757:	50                   	push   %eax
  100758:	e8 dd 24 00 00       	call   102c3a <strfind>
  10075d:	83 c4 10             	add    $0x10,%esp
  100760:	89 c2                	mov    %eax,%edx
  100762:	8b 45 0c             	mov    0xc(%ebp),%eax
  100765:	8b 40 08             	mov    0x8(%eax),%eax
  100768:	29 c2                	sub    %eax,%edx
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100770:	83 ec 0c             	sub    $0xc,%esp
  100773:	ff 75 08             	pushl  0x8(%ebp)
  100776:	6a 44                	push   $0x44
  100778:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10077b:	50                   	push   %eax
  10077c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10077f:	50                   	push   %eax
  100780:	ff 75 f4             	pushl  -0xc(%ebp)
  100783:	e8 ea fc ff ff       	call   100472 <stab_binsearch>
  100788:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  10078b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10078e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100791:	39 c2                	cmp    %eax,%edx
  100793:	7f 24                	jg     1007b9 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  100795:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100798:	89 c2                	mov    %eax,%edx
  10079a:	89 d0                	mov    %edx,%eax
  10079c:	01 c0                	add    %eax,%eax
  10079e:	01 d0                	add    %edx,%eax
  1007a0:	c1 e0 02             	shl    $0x2,%eax
  1007a3:	89 c2                	mov    %eax,%edx
  1007a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a8:	01 d0                	add    %edx,%eax
  1007aa:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007ae:	0f b7 d0             	movzwl %ax,%edx
  1007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b4:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007b7:	eb 13                	jmp    1007cc <debuginfo_eip+0x203>
        return -1;
  1007b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007be:	e9 12 01 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c6:	83 e8 01             	sub    $0x1,%eax
  1007c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  1007cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d2:	39 c2                	cmp    %eax,%edx
  1007d4:	7c 56                	jl     10082c <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d9:	89 c2                	mov    %eax,%edx
  1007db:	89 d0                	mov    %edx,%eax
  1007dd:	01 c0                	add    %eax,%eax
  1007df:	01 d0                	add    %edx,%eax
  1007e1:	c1 e0 02             	shl    $0x2,%eax
  1007e4:	89 c2                	mov    %eax,%edx
  1007e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e9:	01 d0                	add    %edx,%eax
  1007eb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007ef:	3c 84                	cmp    $0x84,%al
  1007f1:	74 39                	je     10082c <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f6:	89 c2                	mov    %eax,%edx
  1007f8:	89 d0                	mov    %edx,%eax
  1007fa:	01 c0                	add    %eax,%eax
  1007fc:	01 d0                	add    %edx,%eax
  1007fe:	c1 e0 02             	shl    $0x2,%eax
  100801:	89 c2                	mov    %eax,%edx
  100803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100806:	01 d0                	add    %edx,%eax
  100808:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10080c:	3c 64                	cmp    $0x64,%al
  10080e:	75 b3                	jne    1007c3 <debuginfo_eip+0x1fa>
  100810:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100813:	89 c2                	mov    %eax,%edx
  100815:	89 d0                	mov    %edx,%eax
  100817:	01 c0                	add    %eax,%eax
  100819:	01 d0                	add    %edx,%eax
  10081b:	c1 e0 02             	shl    $0x2,%eax
  10081e:	89 c2                	mov    %eax,%edx
  100820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100823:	01 d0                	add    %edx,%eax
  100825:	8b 40 08             	mov    0x8(%eax),%eax
  100828:	85 c0                	test   %eax,%eax
  10082a:	74 97                	je     1007c3 <debuginfo_eip+0x1fa>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10082c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100832:	39 c2                	cmp    %eax,%edx
  100834:	7c 46                	jl     10087c <debuginfo_eip+0x2b3>
  100836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	89 d0                	mov    %edx,%eax
  10083d:	01 c0                	add    %eax,%eax
  10083f:	01 d0                	add    %edx,%eax
  100841:	c1 e0 02             	shl    $0x2,%eax
  100844:	89 c2                	mov    %eax,%edx
  100846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100849:	01 d0                	add    %edx,%eax
  10084b:	8b 00                	mov    (%eax),%eax
  10084d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100850:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100853:	29 d1                	sub    %edx,%ecx
  100855:	89 ca                	mov    %ecx,%edx
  100857:	39 d0                	cmp    %edx,%eax
  100859:	73 21                	jae    10087c <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085e:	89 c2                	mov    %eax,%edx
  100860:	89 d0                	mov    %edx,%eax
  100862:	01 c0                	add    %eax,%eax
  100864:	01 d0                	add    %edx,%eax
  100866:	c1 e0 02             	shl    $0x2,%eax
  100869:	89 c2                	mov    %eax,%edx
  10086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086e:	01 d0                	add    %edx,%eax
  100870:	8b 10                	mov    (%eax),%edx
  100872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100875:	01 c2                	add    %eax,%edx
  100877:	8b 45 0c             	mov    0xc(%ebp),%eax
  10087a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10087c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10087f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100882:	39 c2                	cmp    %eax,%edx
  100884:	7d 4a                	jge    1008d0 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100886:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100889:	83 c0 01             	add    $0x1,%eax
  10088c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10088f:	eb 18                	jmp    1008a9 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100891:	8b 45 0c             	mov    0xc(%ebp),%eax
  100894:	8b 40 14             	mov    0x14(%eax),%eax
  100897:	8d 50 01             	lea    0x1(%eax),%edx
  10089a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10089d:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a3:	83 c0 01             	add    $0x1,%eax
  1008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008af:	39 c2                	cmp    %eax,%edx
  1008b1:	7d 1d                	jge    1008d0 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b6:	89 c2                	mov    %eax,%edx
  1008b8:	89 d0                	mov    %edx,%eax
  1008ba:	01 c0                	add    %eax,%eax
  1008bc:	01 d0                	add    %edx,%eax
  1008be:	c1 e0 02             	shl    $0x2,%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c6:	01 d0                	add    %edx,%eax
  1008c8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008cc:	3c a0                	cmp    $0xa0,%al
  1008ce:	74 c1                	je     100891 <debuginfo_eip+0x2c8>
        }
    }
    return 0;
  1008d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008d5:	c9                   	leave  
  1008d6:	c3                   	ret    

001008d7 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008d7:	55                   	push   %ebp
  1008d8:	89 e5                	mov    %esp,%ebp
  1008da:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008dd:	83 ec 0c             	sub    $0xc,%esp
  1008e0:	68 52 36 10 00       	push   $0x103652
  1008e5:	e8 63 f9 ff ff       	call   10024d <cprintf>
  1008ea:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008ed:	83 ec 08             	sub    $0x8,%esp
  1008f0:	68 00 00 10 00       	push   $0x100000
  1008f5:	68 6b 36 10 00       	push   $0x10366b
  1008fa:	e8 4e f9 ff ff       	call   10024d <cprintf>
  1008ff:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100902:	83 ec 08             	sub    $0x8,%esp
  100905:	68 5d 35 10 00       	push   $0x10355d
  10090a:	68 83 36 10 00       	push   $0x103683
  10090f:	e8 39 f9 ff ff       	call   10024d <cprintf>
  100914:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100917:	83 ec 08             	sub    $0x8,%esp
  10091a:	68 16 ea 10 00       	push   $0x10ea16
  10091f:	68 9b 36 10 00       	push   $0x10369b
  100924:	e8 24 f9 ff ff       	call   10024d <cprintf>
  100929:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10092c:	83 ec 08             	sub    $0x8,%esp
  10092f:	68 20 fd 10 00       	push   $0x10fd20
  100934:	68 b3 36 10 00       	push   $0x1036b3
  100939:	e8 0f f9 ff ff       	call   10024d <cprintf>
  10093e:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100941:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100946:	05 ff 03 00 00       	add    $0x3ff,%eax
  10094b:	ba 00 00 10 00       	mov    $0x100000,%edx
  100950:	29 d0                	sub    %edx,%eax
  100952:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100958:	85 c0                	test   %eax,%eax
  10095a:	0f 48 c2             	cmovs  %edx,%eax
  10095d:	c1 f8 0a             	sar    $0xa,%eax
  100960:	83 ec 08             	sub    $0x8,%esp
  100963:	50                   	push   %eax
  100964:	68 cc 36 10 00       	push   $0x1036cc
  100969:	e8 df f8 ff ff       	call   10024d <cprintf>
  10096e:	83 c4 10             	add    $0x10,%esp
}
  100971:	90                   	nop
  100972:	c9                   	leave  
  100973:	c3                   	ret    

00100974 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100974:	55                   	push   %ebp
  100975:	89 e5                	mov    %esp,%ebp
  100977:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10097d:	83 ec 08             	sub    $0x8,%esp
  100980:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100983:	50                   	push   %eax
  100984:	ff 75 08             	pushl  0x8(%ebp)
  100987:	e8 3d fc ff ff       	call   1005c9 <debuginfo_eip>
  10098c:	83 c4 10             	add    $0x10,%esp
  10098f:	85 c0                	test   %eax,%eax
  100991:	74 15                	je     1009a8 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100993:	83 ec 08             	sub    $0x8,%esp
  100996:	ff 75 08             	pushl  0x8(%ebp)
  100999:	68 f6 36 10 00       	push   $0x1036f6
  10099e:	e8 aa f8 ff ff       	call   10024d <cprintf>
  1009a3:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a6:	eb 65                	jmp    100a0d <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009af:	eb 1c                	jmp    1009cd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b7:	01 d0                	add    %edx,%eax
  1009b9:	0f b6 00             	movzbl (%eax),%eax
  1009bc:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009c5:	01 ca                	add    %ecx,%edx
  1009c7:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009d0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1009d3:	7c dc                	jl     1009b1 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  1009d5:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009de:	01 d0                	add    %edx,%eax
  1009e0:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  1009e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009e6:	8b 55 08             	mov    0x8(%ebp),%edx
  1009e9:	89 d1                	mov    %edx,%ecx
  1009eb:	29 c1                	sub    %eax,%ecx
  1009ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009f3:	83 ec 0c             	sub    $0xc,%esp
  1009f6:	51                   	push   %ecx
  1009f7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009fd:	51                   	push   %ecx
  1009fe:	52                   	push   %edx
  1009ff:	50                   	push   %eax
  100a00:	68 12 37 10 00       	push   $0x103712
  100a05:	e8 43 f8 ff ff       	call   10024d <cprintf>
  100a0a:	83 c4 20             	add    $0x20,%esp
}
  100a0d:	90                   	nop
  100a0e:	c9                   	leave  
  100a0f:	c3                   	ret    

00100a10 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a10:	55                   	push   %ebp
  100a11:	89 e5                	mov    %esp,%ebp
  100a13:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a16:	8b 45 04             	mov    0x4(%ebp),%eax
  100a19:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a1f:	c9                   	leave  
  100a20:	c3                   	ret    

00100a21 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a21:	55                   	push   %ebp
  100a22:	89 e5                	mov    %esp,%ebp
  100a24:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a27:	89 e8                	mov    %ebp,%eax
  100a29:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t v_ebp=read_ebp();
  100a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t v_eip=read_eip();
  100a32:	e8 d9 ff ff ff       	call   100a10 <read_eip>
  100a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for(int i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
  100a3a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a41:	e9 90 00 00 00       	jmp    100ad6 <print_stackframe+0xb5>
	{
		cprintf("ebp: 0x%08x , eip: 0x%08x , ",v_ebp,v_eip);
  100a46:	83 ec 04             	sub    $0x4,%esp
  100a49:	ff 75 f0             	pushl  -0x10(%ebp)
  100a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  100a4f:	68 24 37 10 00       	push   $0x103724
  100a54:	e8 f4 f7 ff ff       	call   10024d <cprintf>
  100a59:	83 c4 10             	add    $0x10,%esp
		uint32_t *args=(uint32_t *)v_ebp +2;
  100a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5f:	83 c0 08             	add    $0x8,%eax
  100a62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(int j=0;j<4;++j)
  100a65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a6c:	eb 29                	jmp    100a97 <print_stackframe+0x76>
		{
			cprintf("args[%d] = 0x%08x   ",j,args[j]);
  100a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a7b:	01 d0                	add    %edx,%eax
  100a7d:	8b 00                	mov    (%eax),%eax
  100a7f:	83 ec 04             	sub    $0x4,%esp
  100a82:	50                   	push   %eax
  100a83:	ff 75 e8             	pushl  -0x18(%ebp)
  100a86:	68 41 37 10 00       	push   $0x103741
  100a8b:	e8 bd f7 ff ff       	call   10024d <cprintf>
  100a90:	83 c4 10             	add    $0x10,%esp
		for(int j=0;j<4;++j)
  100a93:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a97:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a9b:	7e d1                	jle    100a6e <print_stackframe+0x4d>
		}
		cprintf("\n");
  100a9d:	83 ec 0c             	sub    $0xc,%esp
  100aa0:	68 56 37 10 00       	push   $0x103756
  100aa5:	e8 a3 f7 ff ff       	call   10024d <cprintf>
  100aaa:	83 c4 10             	add    $0x10,%esp
		print_debuginfo(v_eip-1);
  100aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ab0:	83 e8 01             	sub    $0x1,%eax
  100ab3:	83 ec 0c             	sub    $0xc,%esp
  100ab6:	50                   	push   %eax
  100ab7:	e8 b8 fe ff ff       	call   100974 <print_debuginfo>
  100abc:	83 c4 10             	add    $0x10,%esp
		v_eip=((uint32_t *)v_ebp)[1];
  100abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac2:	83 c0 04             	add    $0x4,%eax
  100ac5:	8b 00                	mov    (%eax),%eax
  100ac7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		v_ebp=((uint32_t *)v_ebp)[0];
  100aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acd:	8b 00                	mov    (%eax),%eax
  100acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(int i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
  100ad2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ad6:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100ada:	7f 0a                	jg     100ae6 <print_stackframe+0xc5>
  100adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ae0:	0f 85 60 ff ff ff    	jne    100a46 <print_stackframe+0x25>
	}


}
  100ae6:	90                   	nop
  100ae7:	c9                   	leave  
  100ae8:	c3                   	ret    

00100ae9 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100ae9:	55                   	push   %ebp
  100aea:	89 e5                	mov    %esp,%ebp
  100aec:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100aef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af6:	eb 0c                	jmp    100b04 <parse+0x1b>
            *buf ++ = '\0';
  100af8:	8b 45 08             	mov    0x8(%ebp),%eax
  100afb:	8d 50 01             	lea    0x1(%eax),%edx
  100afe:	89 55 08             	mov    %edx,0x8(%ebp)
  100b01:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b04:	8b 45 08             	mov    0x8(%ebp),%eax
  100b07:	0f b6 00             	movzbl (%eax),%eax
  100b0a:	84 c0                	test   %al,%al
  100b0c:	74 1e                	je     100b2c <parse+0x43>
  100b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b11:	0f b6 00             	movzbl (%eax),%eax
  100b14:	0f be c0             	movsbl %al,%eax
  100b17:	83 ec 08             	sub    $0x8,%esp
  100b1a:	50                   	push   %eax
  100b1b:	68 d8 37 10 00       	push   $0x1037d8
  100b20:	e8 e2 20 00 00       	call   102c07 <strchr>
  100b25:	83 c4 10             	add    $0x10,%esp
  100b28:	85 c0                	test   %eax,%eax
  100b2a:	75 cc                	jne    100af8 <parse+0xf>
        }
        if (*buf == '\0') {
  100b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2f:	0f b6 00             	movzbl (%eax),%eax
  100b32:	84 c0                	test   %al,%al
  100b34:	74 65                	je     100b9b <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b36:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b3a:	75 12                	jne    100b4e <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b3c:	83 ec 08             	sub    $0x8,%esp
  100b3f:	6a 10                	push   $0x10
  100b41:	68 dd 37 10 00       	push   $0x1037dd
  100b46:	e8 02 f7 ff ff       	call   10024d <cprintf>
  100b4b:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b51:	8d 50 01             	lea    0x1(%eax),%edx
  100b54:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b61:	01 c2                	add    %eax,%edx
  100b63:	8b 45 08             	mov    0x8(%ebp),%eax
  100b66:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b68:	eb 04                	jmp    100b6e <parse+0x85>
            buf ++;
  100b6a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b71:	0f b6 00             	movzbl (%eax),%eax
  100b74:	84 c0                	test   %al,%al
  100b76:	74 8c                	je     100b04 <parse+0x1b>
  100b78:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7b:	0f b6 00             	movzbl (%eax),%eax
  100b7e:	0f be c0             	movsbl %al,%eax
  100b81:	83 ec 08             	sub    $0x8,%esp
  100b84:	50                   	push   %eax
  100b85:	68 d8 37 10 00       	push   $0x1037d8
  100b8a:	e8 78 20 00 00       	call   102c07 <strchr>
  100b8f:	83 c4 10             	add    $0x10,%esp
  100b92:	85 c0                	test   %eax,%eax
  100b94:	74 d4                	je     100b6a <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b96:	e9 69 ff ff ff       	jmp    100b04 <parse+0x1b>
            break;
  100b9b:	90                   	nop
        }
    }
    return argc;
  100b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b9f:	c9                   	leave  
  100ba0:	c3                   	ret    

00100ba1 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ba1:	55                   	push   %ebp
  100ba2:	89 e5                	mov    %esp,%ebp
  100ba4:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100ba7:	83 ec 08             	sub    $0x8,%esp
  100baa:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bad:	50                   	push   %eax
  100bae:	ff 75 08             	pushl  0x8(%ebp)
  100bb1:	e8 33 ff ff ff       	call   100ae9 <parse>
  100bb6:	83 c4 10             	add    $0x10,%esp
  100bb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bc0:	75 0a                	jne    100bcc <runcmd+0x2b>
        return 0;
  100bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  100bc7:	e9 83 00 00 00       	jmp    100c4f <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bd3:	eb 59                	jmp    100c2e <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bd5:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bdb:	89 d0                	mov    %edx,%eax
  100bdd:	01 c0                	add    %eax,%eax
  100bdf:	01 d0                	add    %edx,%eax
  100be1:	c1 e0 02             	shl    $0x2,%eax
  100be4:	05 00 e0 10 00       	add    $0x10e000,%eax
  100be9:	8b 00                	mov    (%eax),%eax
  100beb:	83 ec 08             	sub    $0x8,%esp
  100bee:	51                   	push   %ecx
  100bef:	50                   	push   %eax
  100bf0:	e8 72 1f 00 00       	call   102b67 <strcmp>
  100bf5:	83 c4 10             	add    $0x10,%esp
  100bf8:	85 c0                	test   %eax,%eax
  100bfa:	75 2e                	jne    100c2a <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bff:	89 d0                	mov    %edx,%eax
  100c01:	01 c0                	add    %eax,%eax
  100c03:	01 d0                	add    %edx,%eax
  100c05:	c1 e0 02             	shl    $0x2,%eax
  100c08:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c0d:	8b 10                	mov    (%eax),%edx
  100c0f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c12:	83 c0 04             	add    $0x4,%eax
  100c15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c18:	83 e9 01             	sub    $0x1,%ecx
  100c1b:	83 ec 04             	sub    $0x4,%esp
  100c1e:	ff 75 0c             	pushl  0xc(%ebp)
  100c21:	50                   	push   %eax
  100c22:	51                   	push   %ecx
  100c23:	ff d2                	call   *%edx
  100c25:	83 c4 10             	add    $0x10,%esp
  100c28:	eb 25                	jmp    100c4f <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c31:	83 f8 02             	cmp    $0x2,%eax
  100c34:	76 9f                	jbe    100bd5 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c36:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c39:	83 ec 08             	sub    $0x8,%esp
  100c3c:	50                   	push   %eax
  100c3d:	68 fb 37 10 00       	push   $0x1037fb
  100c42:	e8 06 f6 ff ff       	call   10024d <cprintf>
  100c47:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c4f:	c9                   	leave  
  100c50:	c3                   	ret    

00100c51 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c51:	55                   	push   %ebp
  100c52:	89 e5                	mov    %esp,%ebp
  100c54:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c57:	83 ec 0c             	sub    $0xc,%esp
  100c5a:	68 14 38 10 00       	push   $0x103814
  100c5f:	e8 e9 f5 ff ff       	call   10024d <cprintf>
  100c64:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c67:	83 ec 0c             	sub    $0xc,%esp
  100c6a:	68 3c 38 10 00       	push   $0x10383c
  100c6f:	e8 d9 f5 ff ff       	call   10024d <cprintf>
  100c74:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c7b:	74 0e                	je     100c8b <kmonitor+0x3a>
        print_trapframe(tf);
  100c7d:	83 ec 0c             	sub    $0xc,%esp
  100c80:	ff 75 08             	pushl  0x8(%ebp)
  100c83:	e8 db 0d 00 00       	call   101a63 <print_trapframe>
  100c88:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c8b:	83 ec 0c             	sub    $0xc,%esp
  100c8e:	68 61 38 10 00       	push   $0x103861
  100c93:	e8 59 f6 ff ff       	call   1002f1 <readline>
  100c98:	83 c4 10             	add    $0x10,%esp
  100c9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ca2:	74 e7                	je     100c8b <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100ca4:	83 ec 08             	sub    $0x8,%esp
  100ca7:	ff 75 08             	pushl  0x8(%ebp)
  100caa:	ff 75 f4             	pushl  -0xc(%ebp)
  100cad:	e8 ef fe ff ff       	call   100ba1 <runcmd>
  100cb2:	83 c4 10             	add    $0x10,%esp
  100cb5:	85 c0                	test   %eax,%eax
  100cb7:	78 02                	js     100cbb <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100cb9:	eb d0                	jmp    100c8b <kmonitor+0x3a>
                break;
  100cbb:	90                   	nop
            }
        }
    }
}
  100cbc:	90                   	nop
  100cbd:	c9                   	leave  
  100cbe:	c3                   	ret    

00100cbf <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cbf:	55                   	push   %ebp
  100cc0:	89 e5                	mov    %esp,%ebp
  100cc2:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ccc:	eb 3c                	jmp    100d0a <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd1:	89 d0                	mov    %edx,%eax
  100cd3:	01 c0                	add    %eax,%eax
  100cd5:	01 d0                	add    %edx,%eax
  100cd7:	c1 e0 02             	shl    $0x2,%eax
  100cda:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cdf:	8b 08                	mov    (%eax),%ecx
  100ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce4:	89 d0                	mov    %edx,%eax
  100ce6:	01 c0                	add    %eax,%eax
  100ce8:	01 d0                	add    %edx,%eax
  100cea:	c1 e0 02             	shl    $0x2,%eax
  100ced:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cf2:	8b 00                	mov    (%eax),%eax
  100cf4:	83 ec 04             	sub    $0x4,%esp
  100cf7:	51                   	push   %ecx
  100cf8:	50                   	push   %eax
  100cf9:	68 65 38 10 00       	push   $0x103865
  100cfe:	e8 4a f5 ff ff       	call   10024d <cprintf>
  100d03:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100d06:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0d:	83 f8 02             	cmp    $0x2,%eax
  100d10:	76 bc                	jbe    100cce <mon_help+0xf>
    }
    return 0;
  100d12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d17:	c9                   	leave  
  100d18:	c3                   	ret    

00100d19 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d19:	55                   	push   %ebp
  100d1a:	89 e5                	mov    %esp,%ebp
  100d1c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d1f:	e8 b3 fb ff ff       	call   1008d7 <print_kerninfo>
    return 0;
  100d24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d29:	c9                   	leave  
  100d2a:	c3                   	ret    

00100d2b <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d2b:	55                   	push   %ebp
  100d2c:	89 e5                	mov    %esp,%ebp
  100d2e:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d31:	e8 eb fc ff ff       	call   100a21 <print_stackframe>
    return 0;
  100d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3b:	c9                   	leave  
  100d3c:	c3                   	ret    

00100d3d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d3d:	55                   	push   %ebp
  100d3e:	89 e5                	mov    %esp,%ebp
  100d40:	83 ec 18             	sub    $0x18,%esp
  100d43:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d49:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d4d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d51:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d55:	ee                   	out    %al,(%dx)
  100d56:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d5c:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d60:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d64:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d68:	ee                   	out    %al,(%dx)
  100d69:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d6f:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d73:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d77:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d7b:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d7c:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d83:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d86:	83 ec 0c             	sub    $0xc,%esp
  100d89:	68 6e 38 10 00       	push   $0x10386e
  100d8e:	e8 ba f4 ff ff       	call   10024d <cprintf>
  100d93:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d96:	83 ec 0c             	sub    $0xc,%esp
  100d99:	6a 00                	push   $0x0
  100d9b:	e8 d2 08 00 00       	call   101672 <pic_enable>
  100da0:	83 c4 10             	add    $0x10,%esp
}
  100da3:	90                   	nop
  100da4:	c9                   	leave  
  100da5:	c3                   	ret    

00100da6 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100da6:	55                   	push   %ebp
  100da7:	89 e5                	mov    %esp,%ebp
  100da9:	83 ec 10             	sub    $0x10,%esp
  100dac:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100db6:	89 c2                	mov    %eax,%edx
  100db8:	ec                   	in     (%dx),%al
  100db9:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dbc:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dc2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dc6:	89 c2                	mov    %eax,%edx
  100dc8:	ec                   	in     (%dx),%al
  100dc9:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dcc:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dd6:	89 c2                	mov    %eax,%edx
  100dd8:	ec                   	in     (%dx),%al
  100dd9:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ddc:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100de2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100de6:	89 c2                	mov    %eax,%edx
  100de8:	ec                   	in     (%dx),%al
  100de9:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dec:	90                   	nop
  100ded:	c9                   	leave  
  100dee:	c3                   	ret    

00100def <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100def:	55                   	push   %ebp
  100df0:	89 e5                	mov    %esp,%ebp
  100df2:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100df5:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dff:	0f b7 00             	movzwl (%eax),%eax
  100e02:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e09:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e11:	0f b7 00             	movzwl (%eax),%eax
  100e14:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e18:	74 12                	je     100e2c <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e1a:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e21:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e28:	b4 03 
  100e2a:	eb 13                	jmp    100e3f <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e33:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e36:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e3d:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e3f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e46:	0f b7 c0             	movzwl %ax,%eax
  100e49:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e4d:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e51:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e55:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e59:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e5a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e61:	83 c0 01             	add    $0x1,%eax
  100e64:	0f b7 c0             	movzwl %ax,%eax
  100e67:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e6b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e6f:	89 c2                	mov    %eax,%edx
  100e71:	ec                   	in     (%dx),%al
  100e72:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e75:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e79:	0f b6 c0             	movzbl %al,%eax
  100e7c:	c1 e0 08             	shl    $0x8,%eax
  100e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e82:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e89:	0f b7 c0             	movzwl %ax,%eax
  100e8c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e90:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e94:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e98:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e9c:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e9d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea4:	83 c0 01             	add    $0x1,%eax
  100ea7:	0f b7 c0             	movzwl %ax,%eax
  100eaa:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eae:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eb2:	89 c2                	mov    %eax,%edx
  100eb4:	ec                   	in     (%dx),%al
  100eb5:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100eb8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ebc:	0f b6 c0             	movzbl %al,%eax
  100ebf:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec5:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ecd:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ed3:	90                   	nop
  100ed4:	c9                   	leave  
  100ed5:	c3                   	ret    

00100ed6 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ed6:	55                   	push   %ebp
  100ed7:	89 e5                	mov    %esp,%ebp
  100ed9:	83 ec 38             	sub    $0x38,%esp
  100edc:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ee2:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee6:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100eea:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100eee:	ee                   	out    %al,(%dx)
  100eef:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ef5:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100ef9:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100efd:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f01:	ee                   	out    %al,(%dx)
  100f02:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f08:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f0c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f10:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f14:	ee                   	out    %al,(%dx)
  100f15:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f1b:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f1f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f23:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f27:	ee                   	out    %al,(%dx)
  100f28:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f2e:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f32:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f36:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f3a:	ee                   	out    %al,(%dx)
  100f3b:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f41:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f49:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f4d:	ee                   	out    %al,(%dx)
  100f4e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f54:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f58:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f5c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f60:	ee                   	out    %al,(%dx)
  100f61:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f67:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f6b:	89 c2                	mov    %eax,%edx
  100f6d:	ec                   	in     (%dx),%al
  100f6e:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f71:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f75:	3c ff                	cmp    $0xff,%al
  100f77:	0f 95 c0             	setne  %al
  100f7a:	0f b6 c0             	movzbl %al,%eax
  100f7d:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f82:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f88:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f8c:	89 c2                	mov    %eax,%edx
  100f8e:	ec                   	in     (%dx),%al
  100f8f:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f92:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100f98:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100f9c:	89 c2                	mov    %eax,%edx
  100f9e:	ec                   	in     (%dx),%al
  100f9f:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa2:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fa7:	85 c0                	test   %eax,%eax
  100fa9:	74 0d                	je     100fb8 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fab:	83 ec 0c             	sub    $0xc,%esp
  100fae:	6a 04                	push   $0x4
  100fb0:	e8 bd 06 00 00       	call   101672 <pic_enable>
  100fb5:	83 c4 10             	add    $0x10,%esp
    }
}
  100fb8:	90                   	nop
  100fb9:	c9                   	leave  
  100fba:	c3                   	ret    

00100fbb <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fbb:	55                   	push   %ebp
  100fbc:	89 e5                	mov    %esp,%ebp
  100fbe:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fc8:	eb 09                	jmp    100fd3 <lpt_putc_sub+0x18>
        delay();
  100fca:	e8 d7 fd ff ff       	call   100da6 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fcf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fd3:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fd9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fdd:	89 c2                	mov    %eax,%edx
  100fdf:	ec                   	in     (%dx),%al
  100fe0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fe3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fe7:	84 c0                	test   %al,%al
  100fe9:	78 09                	js     100ff4 <lpt_putc_sub+0x39>
  100feb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ff2:	7e d6                	jle    100fca <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  100ff7:	0f b6 c0             	movzbl %al,%eax
  100ffa:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101000:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101003:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101007:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10100b:	ee                   	out    %al,(%dx)
  10100c:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101012:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101016:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10101a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10101e:	ee                   	out    %al,(%dx)
  10101f:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101025:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101029:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10102d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101031:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101032:	90                   	nop
  101033:	c9                   	leave  
  101034:	c3                   	ret    

00101035 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101035:	55                   	push   %ebp
  101036:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101038:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10103c:	74 0d                	je     10104b <lpt_putc+0x16>
        lpt_putc_sub(c);
  10103e:	ff 75 08             	pushl  0x8(%ebp)
  101041:	e8 75 ff ff ff       	call   100fbb <lpt_putc_sub>
  101046:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101049:	eb 1e                	jmp    101069 <lpt_putc+0x34>
        lpt_putc_sub('\b');
  10104b:	6a 08                	push   $0x8
  10104d:	e8 69 ff ff ff       	call   100fbb <lpt_putc_sub>
  101052:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101055:	6a 20                	push   $0x20
  101057:	e8 5f ff ff ff       	call   100fbb <lpt_putc_sub>
  10105c:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  10105f:	6a 08                	push   $0x8
  101061:	e8 55 ff ff ff       	call   100fbb <lpt_putc_sub>
  101066:	83 c4 04             	add    $0x4,%esp
}
  101069:	90                   	nop
  10106a:	c9                   	leave  
  10106b:	c3                   	ret    

0010106c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10106c:	55                   	push   %ebp
  10106d:	89 e5                	mov    %esp,%ebp
  10106f:	53                   	push   %ebx
  101070:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101073:	8b 45 08             	mov    0x8(%ebp),%eax
  101076:	b0 00                	mov    $0x0,%al
  101078:	85 c0                	test   %eax,%eax
  10107a:	75 07                	jne    101083 <cga_putc+0x17>
        c |= 0x0700;
  10107c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101083:	8b 45 08             	mov    0x8(%ebp),%eax
  101086:	0f b6 c0             	movzbl %al,%eax
  101089:	83 f8 0a             	cmp    $0xa,%eax
  10108c:	74 52                	je     1010e0 <cga_putc+0x74>
  10108e:	83 f8 0d             	cmp    $0xd,%eax
  101091:	74 5d                	je     1010f0 <cga_putc+0x84>
  101093:	83 f8 08             	cmp    $0x8,%eax
  101096:	0f 85 8e 00 00 00    	jne    10112a <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
  10109c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010a3:	66 85 c0             	test   %ax,%ax
  1010a6:	0f 84 a4 00 00 00    	je     101150 <cga_putc+0xe4>
            crt_pos --;
  1010ac:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b3:	83 e8 01             	sub    $0x1,%eax
  1010b6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bf:	b0 00                	mov    $0x0,%al
  1010c1:	83 c8 20             	or     $0x20,%eax
  1010c4:	89 c1                	mov    %eax,%ecx
  1010c6:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010cb:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010d2:	0f b7 d2             	movzwl %dx,%edx
  1010d5:	01 d2                	add    %edx,%edx
  1010d7:	01 d0                	add    %edx,%eax
  1010d9:	89 ca                	mov    %ecx,%edx
  1010db:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010de:	eb 70                	jmp    101150 <cga_putc+0xe4>
    case '\n':
        crt_pos += CRT_COLS;
  1010e0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e7:	83 c0 50             	add    $0x50,%eax
  1010ea:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010f0:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010f7:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010fe:	0f b7 c1             	movzwl %cx,%eax
  101101:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101107:	c1 e8 10             	shr    $0x10,%eax
  10110a:	89 c2                	mov    %eax,%edx
  10110c:	66 c1 ea 06          	shr    $0x6,%dx
  101110:	89 d0                	mov    %edx,%eax
  101112:	c1 e0 02             	shl    $0x2,%eax
  101115:	01 d0                	add    %edx,%eax
  101117:	c1 e0 04             	shl    $0x4,%eax
  10111a:	29 c1                	sub    %eax,%ecx
  10111c:	89 ca                	mov    %ecx,%edx
  10111e:	89 d8                	mov    %ebx,%eax
  101120:	29 d0                	sub    %edx,%eax
  101122:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101128:	eb 27                	jmp    101151 <cga_putc+0xe5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10112a:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101130:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101137:	8d 50 01             	lea    0x1(%eax),%edx
  10113a:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101141:	0f b7 c0             	movzwl %ax,%eax
  101144:	01 c0                	add    %eax,%eax
  101146:	01 c8                	add    %ecx,%eax
  101148:	8b 55 08             	mov    0x8(%ebp),%edx
  10114b:	66 89 10             	mov    %dx,(%eax)
        break;
  10114e:	eb 01                	jmp    101151 <cga_putc+0xe5>
        break;
  101150:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101151:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101158:	66 3d cf 07          	cmp    $0x7cf,%ax
  10115c:	76 59                	jbe    1011b7 <cga_putc+0x14b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10115e:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101163:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101169:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10116e:	83 ec 04             	sub    $0x4,%esp
  101171:	68 00 0f 00 00       	push   $0xf00
  101176:	52                   	push   %edx
  101177:	50                   	push   %eax
  101178:	e8 89 1c 00 00       	call   102e06 <memmove>
  10117d:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101180:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101187:	eb 15                	jmp    10119e <cga_putc+0x132>
            crt_buf[i] = 0x0700 | ' ';
  101189:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101191:	01 d2                	add    %edx,%edx
  101193:	01 d0                	add    %edx,%eax
  101195:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10119a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10119e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011a5:	7e e2                	jle    101189 <cga_putc+0x11d>
        }
        crt_pos -= CRT_COLS;
  1011a7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ae:	83 e8 50             	sub    $0x50,%eax
  1011b1:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011b7:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011be:	0f b7 c0             	movzwl %ax,%eax
  1011c1:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011c5:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1011c9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011cd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011d1:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011d2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d9:	66 c1 e8 08          	shr    $0x8,%ax
  1011dd:	0f b6 c0             	movzbl %al,%eax
  1011e0:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011e7:	83 c2 01             	add    $0x1,%edx
  1011ea:	0f b7 d2             	movzwl %dx,%edx
  1011ed:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1011f1:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011f4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011f8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1011fc:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011fd:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101204:	0f b7 c0             	movzwl %ax,%eax
  101207:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10120b:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  10120f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101213:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101217:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101218:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10121f:	0f b6 c0             	movzbl %al,%eax
  101222:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101229:	83 c2 01             	add    $0x1,%edx
  10122c:	0f b7 d2             	movzwl %dx,%edx
  10122f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101233:	88 45 f1             	mov    %al,-0xf(%ebp)
  101236:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10123a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10123e:	ee                   	out    %al,(%dx)
}
  10123f:	90                   	nop
  101240:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101243:	c9                   	leave  
  101244:	c3                   	ret    

00101245 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101245:	55                   	push   %ebp
  101246:	89 e5                	mov    %esp,%ebp
  101248:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10124b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101252:	eb 09                	jmp    10125d <serial_putc_sub+0x18>
        delay();
  101254:	e8 4d fb ff ff       	call   100da6 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101259:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10125d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101263:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101267:	89 c2                	mov    %eax,%edx
  101269:	ec                   	in     (%dx),%al
  10126a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10126d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101271:	0f b6 c0             	movzbl %al,%eax
  101274:	83 e0 20             	and    $0x20,%eax
  101277:	85 c0                	test   %eax,%eax
  101279:	75 09                	jne    101284 <serial_putc_sub+0x3f>
  10127b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101282:	7e d0                	jle    101254 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101284:	8b 45 08             	mov    0x8(%ebp),%eax
  101287:	0f b6 c0             	movzbl %al,%eax
  10128a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101290:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101293:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101297:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10129b:	ee                   	out    %al,(%dx)
}
  10129c:	90                   	nop
  10129d:	c9                   	leave  
  10129e:	c3                   	ret    

0010129f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10129f:	55                   	push   %ebp
  1012a0:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012a2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012a6:	74 0d                	je     1012b5 <serial_putc+0x16>
        serial_putc_sub(c);
  1012a8:	ff 75 08             	pushl  0x8(%ebp)
  1012ab:	e8 95 ff ff ff       	call   101245 <serial_putc_sub>
  1012b0:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012b3:	eb 1e                	jmp    1012d3 <serial_putc+0x34>
        serial_putc_sub('\b');
  1012b5:	6a 08                	push   $0x8
  1012b7:	e8 89 ff ff ff       	call   101245 <serial_putc_sub>
  1012bc:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012bf:	6a 20                	push   $0x20
  1012c1:	e8 7f ff ff ff       	call   101245 <serial_putc_sub>
  1012c6:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012c9:	6a 08                	push   $0x8
  1012cb:	e8 75 ff ff ff       	call   101245 <serial_putc_sub>
  1012d0:	83 c4 04             	add    $0x4,%esp
}
  1012d3:	90                   	nop
  1012d4:	c9                   	leave  
  1012d5:	c3                   	ret    

001012d6 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012d6:	55                   	push   %ebp
  1012d7:	89 e5                	mov    %esp,%ebp
  1012d9:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012dc:	eb 33                	jmp    101311 <cons_intr+0x3b>
        if (c != 0) {
  1012de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012e2:	74 2d                	je     101311 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012e4:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012e9:	8d 50 01             	lea    0x1(%eax),%edx
  1012ec:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012f5:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012fb:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101300:	3d 00 02 00 00       	cmp    $0x200,%eax
  101305:	75 0a                	jne    101311 <cons_intr+0x3b>
                cons.wpos = 0;
  101307:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10130e:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101311:	8b 45 08             	mov    0x8(%ebp),%eax
  101314:	ff d0                	call   *%eax
  101316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101319:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10131d:	75 bf                	jne    1012de <cons_intr+0x8>
            }
        }
    }
}
  10131f:	90                   	nop
  101320:	c9                   	leave  
  101321:	c3                   	ret    

00101322 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101322:	55                   	push   %ebp
  101323:	89 e5                	mov    %esp,%ebp
  101325:	83 ec 10             	sub    $0x10,%esp
  101328:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10132e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101332:	89 c2                	mov    %eax,%edx
  101334:	ec                   	in     (%dx),%al
  101335:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101338:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10133c:	0f b6 c0             	movzbl %al,%eax
  10133f:	83 e0 01             	and    $0x1,%eax
  101342:	85 c0                	test   %eax,%eax
  101344:	75 07                	jne    10134d <serial_proc_data+0x2b>
        return -1;
  101346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10134b:	eb 2a                	jmp    101377 <serial_proc_data+0x55>
  10134d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101353:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101357:	89 c2                	mov    %eax,%edx
  101359:	ec                   	in     (%dx),%al
  10135a:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10135d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101361:	0f b6 c0             	movzbl %al,%eax
  101364:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101367:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10136b:	75 07                	jne    101374 <serial_proc_data+0x52>
        c = '\b';
  10136d:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101374:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101377:	c9                   	leave  
  101378:	c3                   	ret    

00101379 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101379:	55                   	push   %ebp
  10137a:	89 e5                	mov    %esp,%ebp
  10137c:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  10137f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101384:	85 c0                	test   %eax,%eax
  101386:	74 10                	je     101398 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101388:	83 ec 0c             	sub    $0xc,%esp
  10138b:	68 22 13 10 00       	push   $0x101322
  101390:	e8 41 ff ff ff       	call   1012d6 <cons_intr>
  101395:	83 c4 10             	add    $0x10,%esp
    }
}
  101398:	90                   	nop
  101399:	c9                   	leave  
  10139a:	c3                   	ret    

0010139b <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10139b:	55                   	push   %ebp
  10139c:	89 e5                	mov    %esp,%ebp
  10139e:	83 ec 28             	sub    $0x28,%esp
  1013a1:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013a7:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013ab:	89 c2                	mov    %eax,%edx
  1013ad:	ec                   	in     (%dx),%al
  1013ae:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013b1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013b5:	0f b6 c0             	movzbl %al,%eax
  1013b8:	83 e0 01             	and    $0x1,%eax
  1013bb:	85 c0                	test   %eax,%eax
  1013bd:	75 0a                	jne    1013c9 <kbd_proc_data+0x2e>
        return -1;
  1013bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013c4:	e9 5d 01 00 00       	jmp    101526 <kbd_proc_data+0x18b>
  1013c9:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013d3:	89 c2                	mov    %eax,%edx
  1013d5:	ec                   	in     (%dx),%al
  1013d6:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013d9:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013dd:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013e0:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013e4:	75 17                	jne    1013fd <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013e6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013eb:	83 c8 40             	or     $0x40,%eax
  1013ee:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013f3:	b8 00 00 00 00       	mov    $0x0,%eax
  1013f8:	e9 29 01 00 00       	jmp    101526 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1013fd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101401:	84 c0                	test   %al,%al
  101403:	79 47                	jns    10144c <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101405:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140a:	83 e0 40             	and    $0x40,%eax
  10140d:	85 c0                	test   %eax,%eax
  10140f:	75 09                	jne    10141a <kbd_proc_data+0x7f>
  101411:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101415:	83 e0 7f             	and    $0x7f,%eax
  101418:	eb 04                	jmp    10141e <kbd_proc_data+0x83>
  10141a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101421:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101425:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10142c:	83 c8 40             	or     $0x40,%eax
  10142f:	0f b6 c0             	movzbl %al,%eax
  101432:	f7 d0                	not    %eax
  101434:	89 c2                	mov    %eax,%edx
  101436:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143b:	21 d0                	and    %edx,%eax
  10143d:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101442:	b8 00 00 00 00       	mov    $0x0,%eax
  101447:	e9 da 00 00 00       	jmp    101526 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10144c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101451:	83 e0 40             	and    $0x40,%eax
  101454:	85 c0                	test   %eax,%eax
  101456:	74 11                	je     101469 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101458:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10145c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101461:	83 e0 bf             	and    $0xffffffbf,%eax
  101464:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101469:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146d:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101474:	0f b6 d0             	movzbl %al,%edx
  101477:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147c:	09 d0                	or     %edx,%eax
  10147e:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101483:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101487:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10148e:	0f b6 d0             	movzbl %al,%edx
  101491:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101496:	31 d0                	xor    %edx,%eax
  101498:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  10149d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a2:	83 e0 03             	and    $0x3,%eax
  1014a5:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014ac:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b0:	01 d0                	add    %edx,%eax
  1014b2:	0f b6 00             	movzbl (%eax),%eax
  1014b5:	0f b6 c0             	movzbl %al,%eax
  1014b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014bb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c0:	83 e0 08             	and    $0x8,%eax
  1014c3:	85 c0                	test   %eax,%eax
  1014c5:	74 22                	je     1014e9 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014c7:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014cb:	7e 0c                	jle    1014d9 <kbd_proc_data+0x13e>
  1014cd:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014d1:	7f 06                	jg     1014d9 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014d3:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014d7:	eb 10                	jmp    1014e9 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014d9:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014dd:	7e 0a                	jle    1014e9 <kbd_proc_data+0x14e>
  1014df:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014e3:	7f 04                	jg     1014e9 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014e5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014e9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ee:	f7 d0                	not    %eax
  1014f0:	83 e0 06             	and    $0x6,%eax
  1014f3:	85 c0                	test   %eax,%eax
  1014f5:	75 2c                	jne    101523 <kbd_proc_data+0x188>
  1014f7:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014fe:	75 23                	jne    101523 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101500:	83 ec 0c             	sub    $0xc,%esp
  101503:	68 89 38 10 00       	push   $0x103889
  101508:	e8 40 ed ff ff       	call   10024d <cprintf>
  10150d:	83 c4 10             	add    $0x10,%esp
  101510:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101516:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10151a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10151e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101522:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101523:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101526:	c9                   	leave  
  101527:	c3                   	ret    

00101528 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101528:	55                   	push   %ebp
  101529:	89 e5                	mov    %esp,%ebp
  10152b:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10152e:	83 ec 0c             	sub    $0xc,%esp
  101531:	68 9b 13 10 00       	push   $0x10139b
  101536:	e8 9b fd ff ff       	call   1012d6 <cons_intr>
  10153b:	83 c4 10             	add    $0x10,%esp
}
  10153e:	90                   	nop
  10153f:	c9                   	leave  
  101540:	c3                   	ret    

00101541 <kbd_init>:

static void
kbd_init(void) {
  101541:	55                   	push   %ebp
  101542:	89 e5                	mov    %esp,%ebp
  101544:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101547:	e8 dc ff ff ff       	call   101528 <kbd_intr>
    pic_enable(IRQ_KBD);
  10154c:	83 ec 0c             	sub    $0xc,%esp
  10154f:	6a 01                	push   $0x1
  101551:	e8 1c 01 00 00       	call   101672 <pic_enable>
  101556:	83 c4 10             	add    $0x10,%esp
}
  101559:	90                   	nop
  10155a:	c9                   	leave  
  10155b:	c3                   	ret    

0010155c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10155c:	55                   	push   %ebp
  10155d:	89 e5                	mov    %esp,%ebp
  10155f:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101562:	e8 88 f8 ff ff       	call   100def <cga_init>
    serial_init();
  101567:	e8 6a f9 ff ff       	call   100ed6 <serial_init>
    kbd_init();
  10156c:	e8 d0 ff ff ff       	call   101541 <kbd_init>
    if (!serial_exists) {
  101571:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101576:	85 c0                	test   %eax,%eax
  101578:	75 10                	jne    10158a <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10157a:	83 ec 0c             	sub    $0xc,%esp
  10157d:	68 95 38 10 00       	push   $0x103895
  101582:	e8 c6 ec ff ff       	call   10024d <cprintf>
  101587:	83 c4 10             	add    $0x10,%esp
    }
}
  10158a:	90                   	nop
  10158b:	c9                   	leave  
  10158c:	c3                   	ret    

0010158d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10158d:	55                   	push   %ebp
  10158e:	89 e5                	mov    %esp,%ebp
  101590:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101593:	ff 75 08             	pushl  0x8(%ebp)
  101596:	e8 9a fa ff ff       	call   101035 <lpt_putc>
  10159b:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  10159e:	83 ec 0c             	sub    $0xc,%esp
  1015a1:	ff 75 08             	pushl  0x8(%ebp)
  1015a4:	e8 c3 fa ff ff       	call   10106c <cga_putc>
  1015a9:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015ac:	83 ec 0c             	sub    $0xc,%esp
  1015af:	ff 75 08             	pushl  0x8(%ebp)
  1015b2:	e8 e8 fc ff ff       	call   10129f <serial_putc>
  1015b7:	83 c4 10             	add    $0x10,%esp
}
  1015ba:	90                   	nop
  1015bb:	c9                   	leave  
  1015bc:	c3                   	ret    

001015bd <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015bd:	55                   	push   %ebp
  1015be:	89 e5                	mov    %esp,%ebp
  1015c0:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c3:	e8 b1 fd ff ff       	call   101379 <serial_intr>
    kbd_intr();
  1015c8:	e8 5b ff ff ff       	call   101528 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015cd:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d3:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015d8:	39 c2                	cmp    %eax,%edx
  1015da:	74 36                	je     101612 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015dc:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e1:	8d 50 01             	lea    0x1(%eax),%edx
  1015e4:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015ea:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015f1:	0f b6 c0             	movzbl %al,%eax
  1015f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f7:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015fc:	3d 00 02 00 00       	cmp    $0x200,%eax
  101601:	75 0a                	jne    10160d <cons_getc+0x50>
            cons.rpos = 0;
  101603:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10160a:	00 00 00 
        }
        return c;
  10160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101610:	eb 05                	jmp    101617 <cons_getc+0x5a>
    }
    return 0;
  101612:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101617:	c9                   	leave  
  101618:	c3                   	ret    

00101619 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101619:	55                   	push   %ebp
  10161a:	89 e5                	mov    %esp,%ebp
  10161c:	83 ec 14             	sub    $0x14,%esp
  10161f:	8b 45 08             	mov    0x8(%ebp),%eax
  101622:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101626:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10162a:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101630:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101635:	85 c0                	test   %eax,%eax
  101637:	74 36                	je     10166f <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101639:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163d:	0f b6 c0             	movzbl %al,%eax
  101640:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101646:	88 45 f9             	mov    %al,-0x7(%ebp)
  101649:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10164d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101651:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101652:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101656:	66 c1 e8 08          	shr    $0x8,%ax
  10165a:	0f b6 c0             	movzbl %al,%eax
  10165d:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101663:	88 45 fd             	mov    %al,-0x3(%ebp)
  101666:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10166a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10166e:	ee                   	out    %al,(%dx)
    }
}
  10166f:	90                   	nop
  101670:	c9                   	leave  
  101671:	c3                   	ret    

00101672 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101672:	55                   	push   %ebp
  101673:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101675:	8b 45 08             	mov    0x8(%ebp),%eax
  101678:	ba 01 00 00 00       	mov    $0x1,%edx
  10167d:	89 c1                	mov    %eax,%ecx
  10167f:	d3 e2                	shl    %cl,%edx
  101681:	89 d0                	mov    %edx,%eax
  101683:	f7 d0                	not    %eax
  101685:	89 c2                	mov    %eax,%edx
  101687:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10168e:	21 d0                	and    %edx,%eax
  101690:	0f b7 c0             	movzwl %ax,%eax
  101693:	50                   	push   %eax
  101694:	e8 80 ff ff ff       	call   101619 <pic_setmask>
  101699:	83 c4 04             	add    $0x4,%esp
}
  10169c:	90                   	nop
  10169d:	c9                   	leave  
  10169e:	c3                   	ret    

0010169f <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10169f:	55                   	push   %ebp
  1016a0:	89 e5                	mov    %esp,%ebp
  1016a2:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  1016a5:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016ac:	00 00 00 
  1016af:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016b5:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1016b9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016bd:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016c1:	ee                   	out    %al,(%dx)
  1016c2:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016c8:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1016cc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016d0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1016d4:	ee                   	out    %al,(%dx)
  1016d5:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016db:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1016df:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1016e3:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
  1016e8:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1016ee:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  1016f2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1016f6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1016fa:	ee                   	out    %al,(%dx)
  1016fb:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101701:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101705:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101709:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10170d:	ee                   	out    %al,(%dx)
  10170e:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101714:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101718:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10171c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101720:	ee                   	out    %al,(%dx)
  101721:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101727:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  10172b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10172f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101733:	ee                   	out    %al,(%dx)
  101734:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10173a:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  10173e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101742:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101746:	ee                   	out    %al,(%dx)
  101747:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  10174d:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101751:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101755:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101759:	ee                   	out    %al,(%dx)
  10175a:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101760:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101764:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101768:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
  10176d:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101773:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101777:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10177b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10177f:	ee                   	out    %al,(%dx)
  101780:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101786:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10178a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10178e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101792:	ee                   	out    %al,(%dx)
  101793:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101799:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  10179d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017a1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017a5:	ee                   	out    %al,(%dx)
  1017a6:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017ac:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017b0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017b4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017b8:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017b9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c0:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017c4:	74 13                	je     1017d9 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017c6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017cd:	0f b7 c0             	movzwl %ax,%eax
  1017d0:	50                   	push   %eax
  1017d1:	e8 43 fe ff ff       	call   101619 <pic_setmask>
  1017d6:	83 c4 04             	add    $0x4,%esp
    }
}
  1017d9:	90                   	nop
  1017da:	c9                   	leave  
  1017db:	c3                   	ret    

001017dc <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017dc:	55                   	push   %ebp
  1017dd:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017df:	fb                   	sti    
    sti();
}
  1017e0:	90                   	nop
  1017e1:	5d                   	pop    %ebp
  1017e2:	c3                   	ret    

001017e3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017e3:	55                   	push   %ebp
  1017e4:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017e6:	fa                   	cli    
    cli();
}
  1017e7:	90                   	nop
  1017e8:	5d                   	pop    %ebp
  1017e9:	c3                   	ret    

001017ea <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017ea:	55                   	push   %ebp
  1017eb:	89 e5                	mov    %esp,%ebp
  1017ed:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017f0:	83 ec 08             	sub    $0x8,%esp
  1017f3:	6a 64                	push   $0x64
  1017f5:	68 c0 38 10 00       	push   $0x1038c0
  1017fa:	e8 4e ea ff ff       	call   10024d <cprintf>
  1017ff:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101802:	83 ec 0c             	sub    $0xc,%esp
  101805:	68 ca 38 10 00       	push   $0x1038ca
  10180a:	e8 3e ea ff ff       	call   10024d <cprintf>
  10180f:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101812:	83 ec 04             	sub    $0x4,%esp
  101815:	68 d8 38 10 00       	push   $0x1038d8
  10181a:	6a 12                	push   $0x12
  10181c:	68 ee 38 10 00       	push   $0x1038ee
  101821:	e8 8d eb ff ff       	call   1003b3 <__panic>

00101826 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101826:	55                   	push   %ebp
  101827:	89 e5                	mov    %esp,%ebp
  101829:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
        int num=sizeof(idt)/sizeof(struct gatedesc);
  10182c:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
        for(int i=0;i<num;++i)
  101833:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10183a:	e9 c3 00 00 00       	jmp    101902 <idt_init+0xdc>
        {
                SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  10183f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101842:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101849:	89 c2                	mov    %eax,%edx
  10184b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184e:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101855:	00 
  101856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101859:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101860:	00 08 00 
  101863:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101866:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10186d:	00 
  10186e:	83 e2 e0             	and    $0xffffffe0,%edx
  101871:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101878:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101882:	00 
  101883:	83 e2 1f             	and    $0x1f,%edx
  101886:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10188d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101890:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101897:	00 
  101898:	83 e2 f0             	and    $0xfffffff0,%edx
  10189b:	83 ca 0e             	or     $0xe,%edx
  10189e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a8:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018af:	00 
  1018b0:	83 e2 ef             	and    $0xffffffef,%edx
  1018b3:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bd:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c4:	00 
  1018c5:	83 e2 9f             	and    $0xffffff9f,%edx
  1018c8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d2:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d9:	00 
  1018da:	83 ca 80             	or     $0xffffff80,%edx
  1018dd:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e7:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018ee:	c1 e8 10             	shr    $0x10,%eax
  1018f1:	89 c2                	mov    %eax,%edx
  1018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f6:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018fd:	00 
        for(int i=0;i<num;++i)
  1018fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101902:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101905:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101908:	0f 8c 31 ff ff ff    	jl     10183f <idt_init+0x19>
        }

        SETGATE(idt[T_SWITCH_TOU],0,GD_KTEXT,__vectors[T_SWITCH_TOU],DPL_USER);
  10190e:	a1 c0 e7 10 00       	mov    0x10e7c0,%eax
  101913:	66 a3 60 f4 10 00    	mov    %ax,0x10f460
  101919:	66 c7 05 62 f4 10 00 	movw   $0x8,0x10f462
  101920:	08 00 
  101922:	0f b6 05 64 f4 10 00 	movzbl 0x10f464,%eax
  101929:	83 e0 e0             	and    $0xffffffe0,%eax
  10192c:	a2 64 f4 10 00       	mov    %al,0x10f464
  101931:	0f b6 05 64 f4 10 00 	movzbl 0x10f464,%eax
  101938:	83 e0 1f             	and    $0x1f,%eax
  10193b:	a2 64 f4 10 00       	mov    %al,0x10f464
  101940:	0f b6 05 65 f4 10 00 	movzbl 0x10f465,%eax
  101947:	83 e0 f0             	and    $0xfffffff0,%eax
  10194a:	83 c8 0e             	or     $0xe,%eax
  10194d:	a2 65 f4 10 00       	mov    %al,0x10f465
  101952:	0f b6 05 65 f4 10 00 	movzbl 0x10f465,%eax
  101959:	83 e0 ef             	and    $0xffffffef,%eax
  10195c:	a2 65 f4 10 00       	mov    %al,0x10f465
  101961:	0f b6 05 65 f4 10 00 	movzbl 0x10f465,%eax
  101968:	83 c8 60             	or     $0x60,%eax
  10196b:	a2 65 f4 10 00       	mov    %al,0x10f465
  101970:	0f b6 05 65 f4 10 00 	movzbl 0x10f465,%eax
  101977:	83 c8 80             	or     $0xffffff80,%eax
  10197a:	a2 65 f4 10 00       	mov    %al,0x10f465
  10197f:	a1 c0 e7 10 00       	mov    0x10e7c0,%eax
  101984:	c1 e8 10             	shr    $0x10,%eax
  101987:	66 a3 66 f4 10 00    	mov    %ax,0x10f466
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], 3);        
  10198d:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101992:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101998:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10199f:	08 00 
  1019a1:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1019a8:	83 e0 e0             	and    $0xffffffe0,%eax
  1019ab:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1019b0:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1019b7:	83 e0 1f             	and    $0x1f,%eax
  1019ba:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1019bf:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019c6:	83 e0 f0             	and    $0xfffffff0,%eax
  1019c9:	83 c8 0e             	or     $0xe,%eax
  1019cc:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019d1:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019d8:	83 e0 ef             	and    $0xffffffef,%eax
  1019db:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019e0:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019e7:	83 c8 60             	or     $0x60,%eax
  1019ea:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019ef:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019f6:	83 c8 80             	or     $0xffffff80,%eax
  1019f9:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019fe:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101a03:	c1 e8 10             	shr    $0x10,%eax
  101a06:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101a0c:	c7 45 f4 60 e5 10 00 	movl   $0x10e560,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a16:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101a19:	90                   	nop
  101a1a:	c9                   	leave  
  101a1b:	c3                   	ret    

00101a1c <trapname>:

static const char *
trapname(int trapno) {
  101a1c:	55                   	push   %ebp
  101a1d:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a22:	83 f8 13             	cmp    $0x13,%eax
  101a25:	77 0c                	ja     101a33 <trapname+0x17>
        return excnames[trapno];
  101a27:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2a:	8b 04 85 40 3c 10 00 	mov    0x103c40(,%eax,4),%eax
  101a31:	eb 18                	jmp    101a4b <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a33:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a37:	7e 0d                	jle    101a46 <trapname+0x2a>
  101a39:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a3d:	7f 07                	jg     101a46 <trapname+0x2a>
        return "Hardware Interrupt";
  101a3f:	b8 ff 38 10 00       	mov    $0x1038ff,%eax
  101a44:	eb 05                	jmp    101a4b <trapname+0x2f>
    }
    return "(unknown trap)";
  101a46:	b8 12 39 10 00       	mov    $0x103912,%eax
}
  101a4b:	5d                   	pop    %ebp
  101a4c:	c3                   	ret    

00101a4d <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a4d:	55                   	push   %ebp
  101a4e:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a50:	8b 45 08             	mov    0x8(%ebp),%eax
  101a53:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a57:	66 83 f8 08          	cmp    $0x8,%ax
  101a5b:	0f 94 c0             	sete   %al
  101a5e:	0f b6 c0             	movzbl %al,%eax
}
  101a61:	5d                   	pop    %ebp
  101a62:	c3                   	ret    

00101a63 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a63:	55                   	push   %ebp
  101a64:	89 e5                	mov    %esp,%ebp
  101a66:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a69:	83 ec 08             	sub    $0x8,%esp
  101a6c:	ff 75 08             	pushl  0x8(%ebp)
  101a6f:	68 53 39 10 00       	push   $0x103953
  101a74:	e8 d4 e7 ff ff       	call   10024d <cprintf>
  101a79:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7f:	83 ec 0c             	sub    $0xc,%esp
  101a82:	50                   	push   %eax
  101a83:	e8 b6 01 00 00       	call   101c3e <print_regs>
  101a88:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a92:	0f b7 c0             	movzwl %ax,%eax
  101a95:	83 ec 08             	sub    $0x8,%esp
  101a98:	50                   	push   %eax
  101a99:	68 64 39 10 00       	push   $0x103964
  101a9e:	e8 aa e7 ff ff       	call   10024d <cprintf>
  101aa3:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa9:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101aad:	0f b7 c0             	movzwl %ax,%eax
  101ab0:	83 ec 08             	sub    $0x8,%esp
  101ab3:	50                   	push   %eax
  101ab4:	68 77 39 10 00       	push   $0x103977
  101ab9:	e8 8f e7 ff ff       	call   10024d <cprintf>
  101abe:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac4:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ac8:	0f b7 c0             	movzwl %ax,%eax
  101acb:	83 ec 08             	sub    $0x8,%esp
  101ace:	50                   	push   %eax
  101acf:	68 8a 39 10 00       	push   $0x10398a
  101ad4:	e8 74 e7 ff ff       	call   10024d <cprintf>
  101ad9:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101adc:	8b 45 08             	mov    0x8(%ebp),%eax
  101adf:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ae3:	0f b7 c0             	movzwl %ax,%eax
  101ae6:	83 ec 08             	sub    $0x8,%esp
  101ae9:	50                   	push   %eax
  101aea:	68 9d 39 10 00       	push   $0x10399d
  101aef:	e8 59 e7 ff ff       	call   10024d <cprintf>
  101af4:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101af7:	8b 45 08             	mov    0x8(%ebp),%eax
  101afa:	8b 40 30             	mov    0x30(%eax),%eax
  101afd:	83 ec 0c             	sub    $0xc,%esp
  101b00:	50                   	push   %eax
  101b01:	e8 16 ff ff ff       	call   101a1c <trapname>
  101b06:	83 c4 10             	add    $0x10,%esp
  101b09:	89 c2                	mov    %eax,%edx
  101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0e:	8b 40 30             	mov    0x30(%eax),%eax
  101b11:	83 ec 04             	sub    $0x4,%esp
  101b14:	52                   	push   %edx
  101b15:	50                   	push   %eax
  101b16:	68 b0 39 10 00       	push   $0x1039b0
  101b1b:	e8 2d e7 ff ff       	call   10024d <cprintf>
  101b20:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b23:	8b 45 08             	mov    0x8(%ebp),%eax
  101b26:	8b 40 34             	mov    0x34(%eax),%eax
  101b29:	83 ec 08             	sub    $0x8,%esp
  101b2c:	50                   	push   %eax
  101b2d:	68 c2 39 10 00       	push   $0x1039c2
  101b32:	e8 16 e7 ff ff       	call   10024d <cprintf>
  101b37:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3d:	8b 40 38             	mov    0x38(%eax),%eax
  101b40:	83 ec 08             	sub    $0x8,%esp
  101b43:	50                   	push   %eax
  101b44:	68 d1 39 10 00       	push   $0x1039d1
  101b49:	e8 ff e6 ff ff       	call   10024d <cprintf>
  101b4e:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b51:	8b 45 08             	mov    0x8(%ebp),%eax
  101b54:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b58:	0f b7 c0             	movzwl %ax,%eax
  101b5b:	83 ec 08             	sub    $0x8,%esp
  101b5e:	50                   	push   %eax
  101b5f:	68 e0 39 10 00       	push   $0x1039e0
  101b64:	e8 e4 e6 ff ff       	call   10024d <cprintf>
  101b69:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6f:	8b 40 40             	mov    0x40(%eax),%eax
  101b72:	83 ec 08             	sub    $0x8,%esp
  101b75:	50                   	push   %eax
  101b76:	68 f3 39 10 00       	push   $0x1039f3
  101b7b:	e8 cd e6 ff ff       	call   10024d <cprintf>
  101b80:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b8a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b91:	eb 3f                	jmp    101bd2 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b93:	8b 45 08             	mov    0x8(%ebp),%eax
  101b96:	8b 50 40             	mov    0x40(%eax),%edx
  101b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b9c:	21 d0                	and    %edx,%eax
  101b9e:	85 c0                	test   %eax,%eax
  101ba0:	74 29                	je     101bcb <print_trapframe+0x168>
  101ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba5:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101bac:	85 c0                	test   %eax,%eax
  101bae:	74 1b                	je     101bcb <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb3:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101bba:	83 ec 08             	sub    $0x8,%esp
  101bbd:	50                   	push   %eax
  101bbe:	68 02 3a 10 00       	push   $0x103a02
  101bc3:	e8 85 e6 ff ff       	call   10024d <cprintf>
  101bc8:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bcb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bcf:	d1 65 f0             	shll   -0x10(%ebp)
  101bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd5:	83 f8 17             	cmp    $0x17,%eax
  101bd8:	76 b9                	jbe    101b93 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bda:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdd:	8b 40 40             	mov    0x40(%eax),%eax
  101be0:	c1 e8 0c             	shr    $0xc,%eax
  101be3:	83 e0 03             	and    $0x3,%eax
  101be6:	83 ec 08             	sub    $0x8,%esp
  101be9:	50                   	push   %eax
  101bea:	68 06 3a 10 00       	push   $0x103a06
  101bef:	e8 59 e6 ff ff       	call   10024d <cprintf>
  101bf4:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101bf7:	83 ec 0c             	sub    $0xc,%esp
  101bfa:	ff 75 08             	pushl  0x8(%ebp)
  101bfd:	e8 4b fe ff ff       	call   101a4d <trap_in_kernel>
  101c02:	83 c4 10             	add    $0x10,%esp
  101c05:	85 c0                	test   %eax,%eax
  101c07:	75 32                	jne    101c3b <print_trapframe+0x1d8>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c09:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0c:	8b 40 44             	mov    0x44(%eax),%eax
  101c0f:	83 ec 08             	sub    $0x8,%esp
  101c12:	50                   	push   %eax
  101c13:	68 0f 3a 10 00       	push   $0x103a0f
  101c18:	e8 30 e6 ff ff       	call   10024d <cprintf>
  101c1d:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c20:	8b 45 08             	mov    0x8(%ebp),%eax
  101c23:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c27:	0f b7 c0             	movzwl %ax,%eax
  101c2a:	83 ec 08             	sub    $0x8,%esp
  101c2d:	50                   	push   %eax
  101c2e:	68 1e 3a 10 00       	push   $0x103a1e
  101c33:	e8 15 e6 ff ff       	call   10024d <cprintf>
  101c38:	83 c4 10             	add    $0x10,%esp
    }
}
  101c3b:	90                   	nop
  101c3c:	c9                   	leave  
  101c3d:	c3                   	ret    

00101c3e <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c3e:	55                   	push   %ebp
  101c3f:	89 e5                	mov    %esp,%ebp
  101c41:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c44:	8b 45 08             	mov    0x8(%ebp),%eax
  101c47:	8b 00                	mov    (%eax),%eax
  101c49:	83 ec 08             	sub    $0x8,%esp
  101c4c:	50                   	push   %eax
  101c4d:	68 31 3a 10 00       	push   $0x103a31
  101c52:	e8 f6 e5 ff ff       	call   10024d <cprintf>
  101c57:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5d:	8b 40 04             	mov    0x4(%eax),%eax
  101c60:	83 ec 08             	sub    $0x8,%esp
  101c63:	50                   	push   %eax
  101c64:	68 40 3a 10 00       	push   $0x103a40
  101c69:	e8 df e5 ff ff       	call   10024d <cprintf>
  101c6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c71:	8b 45 08             	mov    0x8(%ebp),%eax
  101c74:	8b 40 08             	mov    0x8(%eax),%eax
  101c77:	83 ec 08             	sub    $0x8,%esp
  101c7a:	50                   	push   %eax
  101c7b:	68 4f 3a 10 00       	push   $0x103a4f
  101c80:	e8 c8 e5 ff ff       	call   10024d <cprintf>
  101c85:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c88:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  101c8e:	83 ec 08             	sub    $0x8,%esp
  101c91:	50                   	push   %eax
  101c92:	68 5e 3a 10 00       	push   $0x103a5e
  101c97:	e8 b1 e5 ff ff       	call   10024d <cprintf>
  101c9c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca2:	8b 40 10             	mov    0x10(%eax),%eax
  101ca5:	83 ec 08             	sub    $0x8,%esp
  101ca8:	50                   	push   %eax
  101ca9:	68 6d 3a 10 00       	push   $0x103a6d
  101cae:	e8 9a e5 ff ff       	call   10024d <cprintf>
  101cb3:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb9:	8b 40 14             	mov    0x14(%eax),%eax
  101cbc:	83 ec 08             	sub    $0x8,%esp
  101cbf:	50                   	push   %eax
  101cc0:	68 7c 3a 10 00       	push   $0x103a7c
  101cc5:	e8 83 e5 ff ff       	call   10024d <cprintf>
  101cca:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd0:	8b 40 18             	mov    0x18(%eax),%eax
  101cd3:	83 ec 08             	sub    $0x8,%esp
  101cd6:	50                   	push   %eax
  101cd7:	68 8b 3a 10 00       	push   $0x103a8b
  101cdc:	e8 6c e5 ff ff       	call   10024d <cprintf>
  101ce1:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce7:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cea:	83 ec 08             	sub    $0x8,%esp
  101ced:	50                   	push   %eax
  101cee:	68 9a 3a 10 00       	push   $0x103a9a
  101cf3:	e8 55 e5 ff ff       	call   10024d <cprintf>
  101cf8:	83 c4 10             	add    $0x10,%esp
}
  101cfb:	90                   	nop
  101cfc:	c9                   	leave  
  101cfd:	c3                   	ret    

00101cfe <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cfe:	55                   	push   %ebp
  101cff:	89 e5                	mov    %esp,%ebp
  101d01:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101d04:	8b 45 08             	mov    0x8(%ebp),%eax
  101d07:	8b 40 30             	mov    0x30(%eax),%eax
  101d0a:	83 f8 2f             	cmp    $0x2f,%eax
  101d0d:	77 1d                	ja     101d2c <trap_dispatch+0x2e>
  101d0f:	83 f8 2e             	cmp    $0x2e,%eax
  101d12:	0f 83 8a 01 00 00    	jae    101ea2 <trap_dispatch+0x1a4>
  101d18:	83 f8 21             	cmp    $0x21,%eax
  101d1b:	74 7c                	je     101d99 <trap_dispatch+0x9b>
  101d1d:	83 f8 24             	cmp    $0x24,%eax
  101d20:	74 50                	je     101d72 <trap_dispatch+0x74>
  101d22:	83 f8 20             	cmp    $0x20,%eax
  101d25:	74 1c                	je     101d43 <trap_dispatch+0x45>
  101d27:	e9 40 01 00 00       	jmp    101e6c <trap_dispatch+0x16e>
  101d2c:	83 f8 78             	cmp    $0x78,%eax
  101d2f:	0f 84 8b 00 00 00    	je     101dc0 <trap_dispatch+0xc2>
  101d35:	83 f8 79             	cmp    $0x79,%eax
  101d38:	0f 84 e2 00 00 00    	je     101e20 <trap_dispatch+0x122>
  101d3e:	e9 29 01 00 00       	jmp    101e6c <trap_dispatch+0x16e>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */

	ticks++;
  101d43:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101d48:	83 c0 01             	add    $0x1,%eax
  101d4b:	a3 08 f9 10 00       	mov    %eax,0x10f908
	if(ticks==TICK_NUM)
  101d50:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101d55:	83 f8 64             	cmp    $0x64,%eax
  101d58:	0f 85 47 01 00 00    	jne    101ea5 <trap_dispatch+0x1a7>
	{
		ticks=0;
  101d5e:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  101d65:	00 00 00 
		print_ticks();
  101d68:	e8 7d fa ff ff       	call   1017ea <print_ticks>
	}		
        break;
  101d6d:	e9 33 01 00 00       	jmp    101ea5 <trap_dispatch+0x1a7>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d72:	e8 46 f8 ff ff       	call   1015bd <cons_getc>
  101d77:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d7a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d7e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d82:	83 ec 04             	sub    $0x4,%esp
  101d85:	52                   	push   %edx
  101d86:	50                   	push   %eax
  101d87:	68 a9 3a 10 00       	push   $0x103aa9
  101d8c:	e8 bc e4 ff ff       	call   10024d <cprintf>
  101d91:	83 c4 10             	add    $0x10,%esp
        break;
  101d94:	e9 0d 01 00 00       	jmp    101ea6 <trap_dispatch+0x1a8>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d99:	e8 1f f8 ff ff       	call   1015bd <cons_getc>
  101d9e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101da1:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101da9:	83 ec 04             	sub    $0x4,%esp
  101dac:	52                   	push   %edx
  101dad:	50                   	push   %eax
  101dae:	68 bb 3a 10 00       	push   $0x103abb
  101db3:	e8 95 e4 ff ff       	call   10024d <cprintf>
  101db8:	83 c4 10             	add    $0x10,%esp
        break;
  101dbb:	e9 e6 00 00 00       	jmp    101ea6 <trap_dispatch+0x1a8>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
	tf->tf_eflags |= FL_IOPL_MASK;
  101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc3:	8b 40 40             	mov    0x40(%eax),%eax
  101dc6:	80 cc 30             	or     $0x30,%ah
  101dc9:	89 c2                	mov    %eax,%edx
  101dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dce:	89 50 40             	mov    %edx,0x40(%eax)
	tf->tf_cs = USER_CS;
  101dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd4:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = USER_DS;
  101dda:	8b 45 08             	mov    0x8(%ebp),%eax
  101ddd:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  101de3:	8b 45 08             	mov    0x8(%ebp),%eax
  101de6:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101dea:	8b 45 08             	mov    0x8(%ebp),%eax
  101ded:	66 89 50 48          	mov    %dx,0x48(%eax)
  101df1:	8b 45 08             	mov    0x8(%ebp),%eax
  101df4:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101df8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfb:	66 89 50 20          	mov    %dx,0x20(%eax)
  101dff:	8b 45 08             	mov    0x8(%ebp),%eax
  101e02:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101e06:	8b 45 08             	mov    0x8(%ebp),%eax
  101e09:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e10:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e14:	8b 45 08             	mov    0x8(%ebp),%eax
  101e17:	66 89 50 2c          	mov    %dx,0x2c(%eax)
	break;
  101e1b:	e9 86 00 00 00       	jmp    101ea6 <trap_dispatch+0x1a8>
    case T_SWITCH_TOK:
	tf->tf_cs = KERNEL_CS;
  101e20:	8b 45 08             	mov    0x8(%ebp),%eax
  101e23:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
  101e29:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2c:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101e32:	8b 45 08             	mov    0x8(%ebp),%eax
  101e35:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101e39:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3c:	66 89 50 48          	mov    %dx,0x48(%eax)
  101e40:	8b 45 08             	mov    0x8(%ebp),%eax
  101e43:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e47:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4a:	66 89 50 20          	mov    %dx,0x20(%eax)
  101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e51:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101e55:	8b 45 08             	mov    0x8(%ebp),%eax
  101e58:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5f:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e63:	8b 45 08             	mov    0x8(%ebp),%eax
  101e66:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        break;
  101e6a:	eb 3a                	jmp    101ea6 <trap_dispatch+0x1a8>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e73:	0f b7 c0             	movzwl %ax,%eax
  101e76:	83 e0 03             	and    $0x3,%eax
  101e79:	85 c0                	test   %eax,%eax
  101e7b:	75 29                	jne    101ea6 <trap_dispatch+0x1a8>
            print_trapframe(tf);
  101e7d:	83 ec 0c             	sub    $0xc,%esp
  101e80:	ff 75 08             	pushl  0x8(%ebp)
  101e83:	e8 db fb ff ff       	call   101a63 <print_trapframe>
  101e88:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101e8b:	83 ec 04             	sub    $0x4,%esp
  101e8e:	68 ca 3a 10 00       	push   $0x103aca
  101e93:	68 c2 00 00 00       	push   $0xc2
  101e98:	68 ee 38 10 00       	push   $0x1038ee
  101e9d:	e8 11 e5 ff ff       	call   1003b3 <__panic>
        break;
  101ea2:	90                   	nop
  101ea3:	eb 01                	jmp    101ea6 <trap_dispatch+0x1a8>
        break;
  101ea5:	90                   	nop
        }
    }
}
  101ea6:	90                   	nop
  101ea7:	c9                   	leave  
  101ea8:	c3                   	ret    

00101ea9 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ea9:	55                   	push   %ebp
  101eaa:	89 e5                	mov    %esp,%ebp
  101eac:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101eaf:	83 ec 0c             	sub    $0xc,%esp
  101eb2:	ff 75 08             	pushl  0x8(%ebp)
  101eb5:	e8 44 fe ff ff       	call   101cfe <trap_dispatch>
  101eba:	83 c4 10             	add    $0x10,%esp
}
  101ebd:	90                   	nop
  101ebe:	c9                   	leave  
  101ebf:	c3                   	ret    

00101ec0 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $0
  101ec2:	6a 00                	push   $0x0
  jmp __alltraps
  101ec4:	e9 67 0a 00 00       	jmp    102930 <__alltraps>

00101ec9 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $1
  101ecb:	6a 01                	push   $0x1
  jmp __alltraps
  101ecd:	e9 5e 0a 00 00       	jmp    102930 <__alltraps>

00101ed2 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $2
  101ed4:	6a 02                	push   $0x2
  jmp __alltraps
  101ed6:	e9 55 0a 00 00       	jmp    102930 <__alltraps>

00101edb <vector3>:
.globl vector3
vector3:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $3
  101edd:	6a 03                	push   $0x3
  jmp __alltraps
  101edf:	e9 4c 0a 00 00       	jmp    102930 <__alltraps>

00101ee4 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $4
  101ee6:	6a 04                	push   $0x4
  jmp __alltraps
  101ee8:	e9 43 0a 00 00       	jmp    102930 <__alltraps>

00101eed <vector5>:
.globl vector5
vector5:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $5
  101eef:	6a 05                	push   $0x5
  jmp __alltraps
  101ef1:	e9 3a 0a 00 00       	jmp    102930 <__alltraps>

00101ef6 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $6
  101ef8:	6a 06                	push   $0x6
  jmp __alltraps
  101efa:	e9 31 0a 00 00       	jmp    102930 <__alltraps>

00101eff <vector7>:
.globl vector7
vector7:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $7
  101f01:	6a 07                	push   $0x7
  jmp __alltraps
  101f03:	e9 28 0a 00 00       	jmp    102930 <__alltraps>

00101f08 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f08:	6a 08                	push   $0x8
  jmp __alltraps
  101f0a:	e9 21 0a 00 00       	jmp    102930 <__alltraps>

00101f0f <vector9>:
.globl vector9
vector9:
  pushl $9
  101f0f:	6a 09                	push   $0x9
  jmp __alltraps
  101f11:	e9 1a 0a 00 00       	jmp    102930 <__alltraps>

00101f16 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f16:	6a 0a                	push   $0xa
  jmp __alltraps
  101f18:	e9 13 0a 00 00       	jmp    102930 <__alltraps>

00101f1d <vector11>:
.globl vector11
vector11:
  pushl $11
  101f1d:	6a 0b                	push   $0xb
  jmp __alltraps
  101f1f:	e9 0c 0a 00 00       	jmp    102930 <__alltraps>

00101f24 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f24:	6a 0c                	push   $0xc
  jmp __alltraps
  101f26:	e9 05 0a 00 00       	jmp    102930 <__alltraps>

00101f2b <vector13>:
.globl vector13
vector13:
  pushl $13
  101f2b:	6a 0d                	push   $0xd
  jmp __alltraps
  101f2d:	e9 fe 09 00 00       	jmp    102930 <__alltraps>

00101f32 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f32:	6a 0e                	push   $0xe
  jmp __alltraps
  101f34:	e9 f7 09 00 00       	jmp    102930 <__alltraps>

00101f39 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $15
  101f3b:	6a 0f                	push   $0xf
  jmp __alltraps
  101f3d:	e9 ee 09 00 00       	jmp    102930 <__alltraps>

00101f42 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $16
  101f44:	6a 10                	push   $0x10
  jmp __alltraps
  101f46:	e9 e5 09 00 00       	jmp    102930 <__alltraps>

00101f4b <vector17>:
.globl vector17
vector17:
  pushl $17
  101f4b:	6a 11                	push   $0x11
  jmp __alltraps
  101f4d:	e9 de 09 00 00       	jmp    102930 <__alltraps>

00101f52 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $18
  101f54:	6a 12                	push   $0x12
  jmp __alltraps
  101f56:	e9 d5 09 00 00       	jmp    102930 <__alltraps>

00101f5b <vector19>:
.globl vector19
vector19:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $19
  101f5d:	6a 13                	push   $0x13
  jmp __alltraps
  101f5f:	e9 cc 09 00 00       	jmp    102930 <__alltraps>

00101f64 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $20
  101f66:	6a 14                	push   $0x14
  jmp __alltraps
  101f68:	e9 c3 09 00 00       	jmp    102930 <__alltraps>

00101f6d <vector21>:
.globl vector21
vector21:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $21
  101f6f:	6a 15                	push   $0x15
  jmp __alltraps
  101f71:	e9 ba 09 00 00       	jmp    102930 <__alltraps>

00101f76 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $22
  101f78:	6a 16                	push   $0x16
  jmp __alltraps
  101f7a:	e9 b1 09 00 00       	jmp    102930 <__alltraps>

00101f7f <vector23>:
.globl vector23
vector23:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $23
  101f81:	6a 17                	push   $0x17
  jmp __alltraps
  101f83:	e9 a8 09 00 00       	jmp    102930 <__alltraps>

00101f88 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $24
  101f8a:	6a 18                	push   $0x18
  jmp __alltraps
  101f8c:	e9 9f 09 00 00       	jmp    102930 <__alltraps>

00101f91 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $25
  101f93:	6a 19                	push   $0x19
  jmp __alltraps
  101f95:	e9 96 09 00 00       	jmp    102930 <__alltraps>

00101f9a <vector26>:
.globl vector26
vector26:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $26
  101f9c:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f9e:	e9 8d 09 00 00       	jmp    102930 <__alltraps>

00101fa3 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $27
  101fa5:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fa7:	e9 84 09 00 00       	jmp    102930 <__alltraps>

00101fac <vector28>:
.globl vector28
vector28:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $28
  101fae:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fb0:	e9 7b 09 00 00       	jmp    102930 <__alltraps>

00101fb5 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $29
  101fb7:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fb9:	e9 72 09 00 00       	jmp    102930 <__alltraps>

00101fbe <vector30>:
.globl vector30
vector30:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $30
  101fc0:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fc2:	e9 69 09 00 00       	jmp    102930 <__alltraps>

00101fc7 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $31
  101fc9:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fcb:	e9 60 09 00 00       	jmp    102930 <__alltraps>

00101fd0 <vector32>:
.globl vector32
vector32:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $32
  101fd2:	6a 20                	push   $0x20
  jmp __alltraps
  101fd4:	e9 57 09 00 00       	jmp    102930 <__alltraps>

00101fd9 <vector33>:
.globl vector33
vector33:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $33
  101fdb:	6a 21                	push   $0x21
  jmp __alltraps
  101fdd:	e9 4e 09 00 00       	jmp    102930 <__alltraps>

00101fe2 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $34
  101fe4:	6a 22                	push   $0x22
  jmp __alltraps
  101fe6:	e9 45 09 00 00       	jmp    102930 <__alltraps>

00101feb <vector35>:
.globl vector35
vector35:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $35
  101fed:	6a 23                	push   $0x23
  jmp __alltraps
  101fef:	e9 3c 09 00 00       	jmp    102930 <__alltraps>

00101ff4 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $36
  101ff6:	6a 24                	push   $0x24
  jmp __alltraps
  101ff8:	e9 33 09 00 00       	jmp    102930 <__alltraps>

00101ffd <vector37>:
.globl vector37
vector37:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $37
  101fff:	6a 25                	push   $0x25
  jmp __alltraps
  102001:	e9 2a 09 00 00       	jmp    102930 <__alltraps>

00102006 <vector38>:
.globl vector38
vector38:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $38
  102008:	6a 26                	push   $0x26
  jmp __alltraps
  10200a:	e9 21 09 00 00       	jmp    102930 <__alltraps>

0010200f <vector39>:
.globl vector39
vector39:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $39
  102011:	6a 27                	push   $0x27
  jmp __alltraps
  102013:	e9 18 09 00 00       	jmp    102930 <__alltraps>

00102018 <vector40>:
.globl vector40
vector40:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $40
  10201a:	6a 28                	push   $0x28
  jmp __alltraps
  10201c:	e9 0f 09 00 00       	jmp    102930 <__alltraps>

00102021 <vector41>:
.globl vector41
vector41:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $41
  102023:	6a 29                	push   $0x29
  jmp __alltraps
  102025:	e9 06 09 00 00       	jmp    102930 <__alltraps>

0010202a <vector42>:
.globl vector42
vector42:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $42
  10202c:	6a 2a                	push   $0x2a
  jmp __alltraps
  10202e:	e9 fd 08 00 00       	jmp    102930 <__alltraps>

00102033 <vector43>:
.globl vector43
vector43:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $43
  102035:	6a 2b                	push   $0x2b
  jmp __alltraps
  102037:	e9 f4 08 00 00       	jmp    102930 <__alltraps>

0010203c <vector44>:
.globl vector44
vector44:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $44
  10203e:	6a 2c                	push   $0x2c
  jmp __alltraps
  102040:	e9 eb 08 00 00       	jmp    102930 <__alltraps>

00102045 <vector45>:
.globl vector45
vector45:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $45
  102047:	6a 2d                	push   $0x2d
  jmp __alltraps
  102049:	e9 e2 08 00 00       	jmp    102930 <__alltraps>

0010204e <vector46>:
.globl vector46
vector46:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $46
  102050:	6a 2e                	push   $0x2e
  jmp __alltraps
  102052:	e9 d9 08 00 00       	jmp    102930 <__alltraps>

00102057 <vector47>:
.globl vector47
vector47:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $47
  102059:	6a 2f                	push   $0x2f
  jmp __alltraps
  10205b:	e9 d0 08 00 00       	jmp    102930 <__alltraps>

00102060 <vector48>:
.globl vector48
vector48:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $48
  102062:	6a 30                	push   $0x30
  jmp __alltraps
  102064:	e9 c7 08 00 00       	jmp    102930 <__alltraps>

00102069 <vector49>:
.globl vector49
vector49:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $49
  10206b:	6a 31                	push   $0x31
  jmp __alltraps
  10206d:	e9 be 08 00 00       	jmp    102930 <__alltraps>

00102072 <vector50>:
.globl vector50
vector50:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $50
  102074:	6a 32                	push   $0x32
  jmp __alltraps
  102076:	e9 b5 08 00 00       	jmp    102930 <__alltraps>

0010207b <vector51>:
.globl vector51
vector51:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $51
  10207d:	6a 33                	push   $0x33
  jmp __alltraps
  10207f:	e9 ac 08 00 00       	jmp    102930 <__alltraps>

00102084 <vector52>:
.globl vector52
vector52:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $52
  102086:	6a 34                	push   $0x34
  jmp __alltraps
  102088:	e9 a3 08 00 00       	jmp    102930 <__alltraps>

0010208d <vector53>:
.globl vector53
vector53:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $53
  10208f:	6a 35                	push   $0x35
  jmp __alltraps
  102091:	e9 9a 08 00 00       	jmp    102930 <__alltraps>

00102096 <vector54>:
.globl vector54
vector54:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $54
  102098:	6a 36                	push   $0x36
  jmp __alltraps
  10209a:	e9 91 08 00 00       	jmp    102930 <__alltraps>

0010209f <vector55>:
.globl vector55
vector55:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $55
  1020a1:	6a 37                	push   $0x37
  jmp __alltraps
  1020a3:	e9 88 08 00 00       	jmp    102930 <__alltraps>

001020a8 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $56
  1020aa:	6a 38                	push   $0x38
  jmp __alltraps
  1020ac:	e9 7f 08 00 00       	jmp    102930 <__alltraps>

001020b1 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $57
  1020b3:	6a 39                	push   $0x39
  jmp __alltraps
  1020b5:	e9 76 08 00 00       	jmp    102930 <__alltraps>

001020ba <vector58>:
.globl vector58
vector58:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $58
  1020bc:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020be:	e9 6d 08 00 00       	jmp    102930 <__alltraps>

001020c3 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $59
  1020c5:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020c7:	e9 64 08 00 00       	jmp    102930 <__alltraps>

001020cc <vector60>:
.globl vector60
vector60:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $60
  1020ce:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020d0:	e9 5b 08 00 00       	jmp    102930 <__alltraps>

001020d5 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $61
  1020d7:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020d9:	e9 52 08 00 00       	jmp    102930 <__alltraps>

001020de <vector62>:
.globl vector62
vector62:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $62
  1020e0:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020e2:	e9 49 08 00 00       	jmp    102930 <__alltraps>

001020e7 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $63
  1020e9:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020eb:	e9 40 08 00 00       	jmp    102930 <__alltraps>

001020f0 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $64
  1020f2:	6a 40                	push   $0x40
  jmp __alltraps
  1020f4:	e9 37 08 00 00       	jmp    102930 <__alltraps>

001020f9 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $65
  1020fb:	6a 41                	push   $0x41
  jmp __alltraps
  1020fd:	e9 2e 08 00 00       	jmp    102930 <__alltraps>

00102102 <vector66>:
.globl vector66
vector66:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $66
  102104:	6a 42                	push   $0x42
  jmp __alltraps
  102106:	e9 25 08 00 00       	jmp    102930 <__alltraps>

0010210b <vector67>:
.globl vector67
vector67:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $67
  10210d:	6a 43                	push   $0x43
  jmp __alltraps
  10210f:	e9 1c 08 00 00       	jmp    102930 <__alltraps>

00102114 <vector68>:
.globl vector68
vector68:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $68
  102116:	6a 44                	push   $0x44
  jmp __alltraps
  102118:	e9 13 08 00 00       	jmp    102930 <__alltraps>

0010211d <vector69>:
.globl vector69
vector69:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $69
  10211f:	6a 45                	push   $0x45
  jmp __alltraps
  102121:	e9 0a 08 00 00       	jmp    102930 <__alltraps>

00102126 <vector70>:
.globl vector70
vector70:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $70
  102128:	6a 46                	push   $0x46
  jmp __alltraps
  10212a:	e9 01 08 00 00       	jmp    102930 <__alltraps>

0010212f <vector71>:
.globl vector71
vector71:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $71
  102131:	6a 47                	push   $0x47
  jmp __alltraps
  102133:	e9 f8 07 00 00       	jmp    102930 <__alltraps>

00102138 <vector72>:
.globl vector72
vector72:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $72
  10213a:	6a 48                	push   $0x48
  jmp __alltraps
  10213c:	e9 ef 07 00 00       	jmp    102930 <__alltraps>

00102141 <vector73>:
.globl vector73
vector73:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $73
  102143:	6a 49                	push   $0x49
  jmp __alltraps
  102145:	e9 e6 07 00 00       	jmp    102930 <__alltraps>

0010214a <vector74>:
.globl vector74
vector74:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $74
  10214c:	6a 4a                	push   $0x4a
  jmp __alltraps
  10214e:	e9 dd 07 00 00       	jmp    102930 <__alltraps>

00102153 <vector75>:
.globl vector75
vector75:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $75
  102155:	6a 4b                	push   $0x4b
  jmp __alltraps
  102157:	e9 d4 07 00 00       	jmp    102930 <__alltraps>

0010215c <vector76>:
.globl vector76
vector76:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $76
  10215e:	6a 4c                	push   $0x4c
  jmp __alltraps
  102160:	e9 cb 07 00 00       	jmp    102930 <__alltraps>

00102165 <vector77>:
.globl vector77
vector77:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $77
  102167:	6a 4d                	push   $0x4d
  jmp __alltraps
  102169:	e9 c2 07 00 00       	jmp    102930 <__alltraps>

0010216e <vector78>:
.globl vector78
vector78:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $78
  102170:	6a 4e                	push   $0x4e
  jmp __alltraps
  102172:	e9 b9 07 00 00       	jmp    102930 <__alltraps>

00102177 <vector79>:
.globl vector79
vector79:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $79
  102179:	6a 4f                	push   $0x4f
  jmp __alltraps
  10217b:	e9 b0 07 00 00       	jmp    102930 <__alltraps>

00102180 <vector80>:
.globl vector80
vector80:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $80
  102182:	6a 50                	push   $0x50
  jmp __alltraps
  102184:	e9 a7 07 00 00       	jmp    102930 <__alltraps>

00102189 <vector81>:
.globl vector81
vector81:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $81
  10218b:	6a 51                	push   $0x51
  jmp __alltraps
  10218d:	e9 9e 07 00 00       	jmp    102930 <__alltraps>

00102192 <vector82>:
.globl vector82
vector82:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $82
  102194:	6a 52                	push   $0x52
  jmp __alltraps
  102196:	e9 95 07 00 00       	jmp    102930 <__alltraps>

0010219b <vector83>:
.globl vector83
vector83:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $83
  10219d:	6a 53                	push   $0x53
  jmp __alltraps
  10219f:	e9 8c 07 00 00       	jmp    102930 <__alltraps>

001021a4 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $84
  1021a6:	6a 54                	push   $0x54
  jmp __alltraps
  1021a8:	e9 83 07 00 00       	jmp    102930 <__alltraps>

001021ad <vector85>:
.globl vector85
vector85:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $85
  1021af:	6a 55                	push   $0x55
  jmp __alltraps
  1021b1:	e9 7a 07 00 00       	jmp    102930 <__alltraps>

001021b6 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $86
  1021b8:	6a 56                	push   $0x56
  jmp __alltraps
  1021ba:	e9 71 07 00 00       	jmp    102930 <__alltraps>

001021bf <vector87>:
.globl vector87
vector87:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $87
  1021c1:	6a 57                	push   $0x57
  jmp __alltraps
  1021c3:	e9 68 07 00 00       	jmp    102930 <__alltraps>

001021c8 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $88
  1021ca:	6a 58                	push   $0x58
  jmp __alltraps
  1021cc:	e9 5f 07 00 00       	jmp    102930 <__alltraps>

001021d1 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $89
  1021d3:	6a 59                	push   $0x59
  jmp __alltraps
  1021d5:	e9 56 07 00 00       	jmp    102930 <__alltraps>

001021da <vector90>:
.globl vector90
vector90:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $90
  1021dc:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021de:	e9 4d 07 00 00       	jmp    102930 <__alltraps>

001021e3 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $91
  1021e5:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021e7:	e9 44 07 00 00       	jmp    102930 <__alltraps>

001021ec <vector92>:
.globl vector92
vector92:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $92
  1021ee:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021f0:	e9 3b 07 00 00       	jmp    102930 <__alltraps>

001021f5 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $93
  1021f7:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021f9:	e9 32 07 00 00       	jmp    102930 <__alltraps>

001021fe <vector94>:
.globl vector94
vector94:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $94
  102200:	6a 5e                	push   $0x5e
  jmp __alltraps
  102202:	e9 29 07 00 00       	jmp    102930 <__alltraps>

00102207 <vector95>:
.globl vector95
vector95:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $95
  102209:	6a 5f                	push   $0x5f
  jmp __alltraps
  10220b:	e9 20 07 00 00       	jmp    102930 <__alltraps>

00102210 <vector96>:
.globl vector96
vector96:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $96
  102212:	6a 60                	push   $0x60
  jmp __alltraps
  102214:	e9 17 07 00 00       	jmp    102930 <__alltraps>

00102219 <vector97>:
.globl vector97
vector97:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $97
  10221b:	6a 61                	push   $0x61
  jmp __alltraps
  10221d:	e9 0e 07 00 00       	jmp    102930 <__alltraps>

00102222 <vector98>:
.globl vector98
vector98:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $98
  102224:	6a 62                	push   $0x62
  jmp __alltraps
  102226:	e9 05 07 00 00       	jmp    102930 <__alltraps>

0010222b <vector99>:
.globl vector99
vector99:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $99
  10222d:	6a 63                	push   $0x63
  jmp __alltraps
  10222f:	e9 fc 06 00 00       	jmp    102930 <__alltraps>

00102234 <vector100>:
.globl vector100
vector100:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $100
  102236:	6a 64                	push   $0x64
  jmp __alltraps
  102238:	e9 f3 06 00 00       	jmp    102930 <__alltraps>

0010223d <vector101>:
.globl vector101
vector101:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $101
  10223f:	6a 65                	push   $0x65
  jmp __alltraps
  102241:	e9 ea 06 00 00       	jmp    102930 <__alltraps>

00102246 <vector102>:
.globl vector102
vector102:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $102
  102248:	6a 66                	push   $0x66
  jmp __alltraps
  10224a:	e9 e1 06 00 00       	jmp    102930 <__alltraps>

0010224f <vector103>:
.globl vector103
vector103:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $103
  102251:	6a 67                	push   $0x67
  jmp __alltraps
  102253:	e9 d8 06 00 00       	jmp    102930 <__alltraps>

00102258 <vector104>:
.globl vector104
vector104:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $104
  10225a:	6a 68                	push   $0x68
  jmp __alltraps
  10225c:	e9 cf 06 00 00       	jmp    102930 <__alltraps>

00102261 <vector105>:
.globl vector105
vector105:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $105
  102263:	6a 69                	push   $0x69
  jmp __alltraps
  102265:	e9 c6 06 00 00       	jmp    102930 <__alltraps>

0010226a <vector106>:
.globl vector106
vector106:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $106
  10226c:	6a 6a                	push   $0x6a
  jmp __alltraps
  10226e:	e9 bd 06 00 00       	jmp    102930 <__alltraps>

00102273 <vector107>:
.globl vector107
vector107:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $107
  102275:	6a 6b                	push   $0x6b
  jmp __alltraps
  102277:	e9 b4 06 00 00       	jmp    102930 <__alltraps>

0010227c <vector108>:
.globl vector108
vector108:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $108
  10227e:	6a 6c                	push   $0x6c
  jmp __alltraps
  102280:	e9 ab 06 00 00       	jmp    102930 <__alltraps>

00102285 <vector109>:
.globl vector109
vector109:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $109
  102287:	6a 6d                	push   $0x6d
  jmp __alltraps
  102289:	e9 a2 06 00 00       	jmp    102930 <__alltraps>

0010228e <vector110>:
.globl vector110
vector110:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $110
  102290:	6a 6e                	push   $0x6e
  jmp __alltraps
  102292:	e9 99 06 00 00       	jmp    102930 <__alltraps>

00102297 <vector111>:
.globl vector111
vector111:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $111
  102299:	6a 6f                	push   $0x6f
  jmp __alltraps
  10229b:	e9 90 06 00 00       	jmp    102930 <__alltraps>

001022a0 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $112
  1022a2:	6a 70                	push   $0x70
  jmp __alltraps
  1022a4:	e9 87 06 00 00       	jmp    102930 <__alltraps>

001022a9 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $113
  1022ab:	6a 71                	push   $0x71
  jmp __alltraps
  1022ad:	e9 7e 06 00 00       	jmp    102930 <__alltraps>

001022b2 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $114
  1022b4:	6a 72                	push   $0x72
  jmp __alltraps
  1022b6:	e9 75 06 00 00       	jmp    102930 <__alltraps>

001022bb <vector115>:
.globl vector115
vector115:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $115
  1022bd:	6a 73                	push   $0x73
  jmp __alltraps
  1022bf:	e9 6c 06 00 00       	jmp    102930 <__alltraps>

001022c4 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $116
  1022c6:	6a 74                	push   $0x74
  jmp __alltraps
  1022c8:	e9 63 06 00 00       	jmp    102930 <__alltraps>

001022cd <vector117>:
.globl vector117
vector117:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $117
  1022cf:	6a 75                	push   $0x75
  jmp __alltraps
  1022d1:	e9 5a 06 00 00       	jmp    102930 <__alltraps>

001022d6 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $118
  1022d8:	6a 76                	push   $0x76
  jmp __alltraps
  1022da:	e9 51 06 00 00       	jmp    102930 <__alltraps>

001022df <vector119>:
.globl vector119
vector119:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $119
  1022e1:	6a 77                	push   $0x77
  jmp __alltraps
  1022e3:	e9 48 06 00 00       	jmp    102930 <__alltraps>

001022e8 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $120
  1022ea:	6a 78                	push   $0x78
  jmp __alltraps
  1022ec:	e9 3f 06 00 00       	jmp    102930 <__alltraps>

001022f1 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $121
  1022f3:	6a 79                	push   $0x79
  jmp __alltraps
  1022f5:	e9 36 06 00 00       	jmp    102930 <__alltraps>

001022fa <vector122>:
.globl vector122
vector122:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $122
  1022fc:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022fe:	e9 2d 06 00 00       	jmp    102930 <__alltraps>

00102303 <vector123>:
.globl vector123
vector123:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $123
  102305:	6a 7b                	push   $0x7b
  jmp __alltraps
  102307:	e9 24 06 00 00       	jmp    102930 <__alltraps>

0010230c <vector124>:
.globl vector124
vector124:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $124
  10230e:	6a 7c                	push   $0x7c
  jmp __alltraps
  102310:	e9 1b 06 00 00       	jmp    102930 <__alltraps>

00102315 <vector125>:
.globl vector125
vector125:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $125
  102317:	6a 7d                	push   $0x7d
  jmp __alltraps
  102319:	e9 12 06 00 00       	jmp    102930 <__alltraps>

0010231e <vector126>:
.globl vector126
vector126:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $126
  102320:	6a 7e                	push   $0x7e
  jmp __alltraps
  102322:	e9 09 06 00 00       	jmp    102930 <__alltraps>

00102327 <vector127>:
.globl vector127
vector127:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $127
  102329:	6a 7f                	push   $0x7f
  jmp __alltraps
  10232b:	e9 00 06 00 00       	jmp    102930 <__alltraps>

00102330 <vector128>:
.globl vector128
vector128:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $128
  102332:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102337:	e9 f4 05 00 00       	jmp    102930 <__alltraps>

0010233c <vector129>:
.globl vector129
vector129:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $129
  10233e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102343:	e9 e8 05 00 00       	jmp    102930 <__alltraps>

00102348 <vector130>:
.globl vector130
vector130:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $130
  10234a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10234f:	e9 dc 05 00 00       	jmp    102930 <__alltraps>

00102354 <vector131>:
.globl vector131
vector131:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $131
  102356:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10235b:	e9 d0 05 00 00       	jmp    102930 <__alltraps>

00102360 <vector132>:
.globl vector132
vector132:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $132
  102362:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102367:	e9 c4 05 00 00       	jmp    102930 <__alltraps>

0010236c <vector133>:
.globl vector133
vector133:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $133
  10236e:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102373:	e9 b8 05 00 00       	jmp    102930 <__alltraps>

00102378 <vector134>:
.globl vector134
vector134:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $134
  10237a:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10237f:	e9 ac 05 00 00       	jmp    102930 <__alltraps>

00102384 <vector135>:
.globl vector135
vector135:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $135
  102386:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10238b:	e9 a0 05 00 00       	jmp    102930 <__alltraps>

00102390 <vector136>:
.globl vector136
vector136:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $136
  102392:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102397:	e9 94 05 00 00       	jmp    102930 <__alltraps>

0010239c <vector137>:
.globl vector137
vector137:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $137
  10239e:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023a3:	e9 88 05 00 00       	jmp    102930 <__alltraps>

001023a8 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $138
  1023aa:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023af:	e9 7c 05 00 00       	jmp    102930 <__alltraps>

001023b4 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $139
  1023b6:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023bb:	e9 70 05 00 00       	jmp    102930 <__alltraps>

001023c0 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $140
  1023c2:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023c7:	e9 64 05 00 00       	jmp    102930 <__alltraps>

001023cc <vector141>:
.globl vector141
vector141:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $141
  1023ce:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023d3:	e9 58 05 00 00       	jmp    102930 <__alltraps>

001023d8 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $142
  1023da:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023df:	e9 4c 05 00 00       	jmp    102930 <__alltraps>

001023e4 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $143
  1023e6:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023eb:	e9 40 05 00 00       	jmp    102930 <__alltraps>

001023f0 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $144
  1023f2:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023f7:	e9 34 05 00 00       	jmp    102930 <__alltraps>

001023fc <vector145>:
.globl vector145
vector145:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $145
  1023fe:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102403:	e9 28 05 00 00       	jmp    102930 <__alltraps>

00102408 <vector146>:
.globl vector146
vector146:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $146
  10240a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10240f:	e9 1c 05 00 00       	jmp    102930 <__alltraps>

00102414 <vector147>:
.globl vector147
vector147:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $147
  102416:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10241b:	e9 10 05 00 00       	jmp    102930 <__alltraps>

00102420 <vector148>:
.globl vector148
vector148:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $148
  102422:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102427:	e9 04 05 00 00       	jmp    102930 <__alltraps>

0010242c <vector149>:
.globl vector149
vector149:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $149
  10242e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102433:	e9 f8 04 00 00       	jmp    102930 <__alltraps>

00102438 <vector150>:
.globl vector150
vector150:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $150
  10243a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10243f:	e9 ec 04 00 00       	jmp    102930 <__alltraps>

00102444 <vector151>:
.globl vector151
vector151:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $151
  102446:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10244b:	e9 e0 04 00 00       	jmp    102930 <__alltraps>

00102450 <vector152>:
.globl vector152
vector152:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $152
  102452:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102457:	e9 d4 04 00 00       	jmp    102930 <__alltraps>

0010245c <vector153>:
.globl vector153
vector153:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $153
  10245e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102463:	e9 c8 04 00 00       	jmp    102930 <__alltraps>

00102468 <vector154>:
.globl vector154
vector154:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $154
  10246a:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10246f:	e9 bc 04 00 00       	jmp    102930 <__alltraps>

00102474 <vector155>:
.globl vector155
vector155:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $155
  102476:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10247b:	e9 b0 04 00 00       	jmp    102930 <__alltraps>

00102480 <vector156>:
.globl vector156
vector156:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $156
  102482:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102487:	e9 a4 04 00 00       	jmp    102930 <__alltraps>

0010248c <vector157>:
.globl vector157
vector157:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $157
  10248e:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102493:	e9 98 04 00 00       	jmp    102930 <__alltraps>

00102498 <vector158>:
.globl vector158
vector158:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $158
  10249a:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10249f:	e9 8c 04 00 00       	jmp    102930 <__alltraps>

001024a4 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $159
  1024a6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024ab:	e9 80 04 00 00       	jmp    102930 <__alltraps>

001024b0 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $160
  1024b2:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024b7:	e9 74 04 00 00       	jmp    102930 <__alltraps>

001024bc <vector161>:
.globl vector161
vector161:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $161
  1024be:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024c3:	e9 68 04 00 00       	jmp    102930 <__alltraps>

001024c8 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $162
  1024ca:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024cf:	e9 5c 04 00 00       	jmp    102930 <__alltraps>

001024d4 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $163
  1024d6:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024db:	e9 50 04 00 00       	jmp    102930 <__alltraps>

001024e0 <vector164>:
.globl vector164
vector164:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $164
  1024e2:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024e7:	e9 44 04 00 00       	jmp    102930 <__alltraps>

001024ec <vector165>:
.globl vector165
vector165:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $165
  1024ee:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024f3:	e9 38 04 00 00       	jmp    102930 <__alltraps>

001024f8 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $166
  1024fa:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024ff:	e9 2c 04 00 00       	jmp    102930 <__alltraps>

00102504 <vector167>:
.globl vector167
vector167:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $167
  102506:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10250b:	e9 20 04 00 00       	jmp    102930 <__alltraps>

00102510 <vector168>:
.globl vector168
vector168:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $168
  102512:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102517:	e9 14 04 00 00       	jmp    102930 <__alltraps>

0010251c <vector169>:
.globl vector169
vector169:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $169
  10251e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102523:	e9 08 04 00 00       	jmp    102930 <__alltraps>

00102528 <vector170>:
.globl vector170
vector170:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $170
  10252a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10252f:	e9 fc 03 00 00       	jmp    102930 <__alltraps>

00102534 <vector171>:
.globl vector171
vector171:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $171
  102536:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10253b:	e9 f0 03 00 00       	jmp    102930 <__alltraps>

00102540 <vector172>:
.globl vector172
vector172:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $172
  102542:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102547:	e9 e4 03 00 00       	jmp    102930 <__alltraps>

0010254c <vector173>:
.globl vector173
vector173:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $173
  10254e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102553:	e9 d8 03 00 00       	jmp    102930 <__alltraps>

00102558 <vector174>:
.globl vector174
vector174:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $174
  10255a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10255f:	e9 cc 03 00 00       	jmp    102930 <__alltraps>

00102564 <vector175>:
.globl vector175
vector175:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $175
  102566:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10256b:	e9 c0 03 00 00       	jmp    102930 <__alltraps>

00102570 <vector176>:
.globl vector176
vector176:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $176
  102572:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102577:	e9 b4 03 00 00       	jmp    102930 <__alltraps>

0010257c <vector177>:
.globl vector177
vector177:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $177
  10257e:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102583:	e9 a8 03 00 00       	jmp    102930 <__alltraps>

00102588 <vector178>:
.globl vector178
vector178:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $178
  10258a:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10258f:	e9 9c 03 00 00       	jmp    102930 <__alltraps>

00102594 <vector179>:
.globl vector179
vector179:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $179
  102596:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10259b:	e9 90 03 00 00       	jmp    102930 <__alltraps>

001025a0 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $180
  1025a2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025a7:	e9 84 03 00 00       	jmp    102930 <__alltraps>

001025ac <vector181>:
.globl vector181
vector181:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $181
  1025ae:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025b3:	e9 78 03 00 00       	jmp    102930 <__alltraps>

001025b8 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $182
  1025ba:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025bf:	e9 6c 03 00 00       	jmp    102930 <__alltraps>

001025c4 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $183
  1025c6:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025cb:	e9 60 03 00 00       	jmp    102930 <__alltraps>

001025d0 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $184
  1025d2:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025d7:	e9 54 03 00 00       	jmp    102930 <__alltraps>

001025dc <vector185>:
.globl vector185
vector185:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $185
  1025de:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025e3:	e9 48 03 00 00       	jmp    102930 <__alltraps>

001025e8 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $186
  1025ea:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025ef:	e9 3c 03 00 00       	jmp    102930 <__alltraps>

001025f4 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $187
  1025f6:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025fb:	e9 30 03 00 00       	jmp    102930 <__alltraps>

00102600 <vector188>:
.globl vector188
vector188:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $188
  102602:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102607:	e9 24 03 00 00       	jmp    102930 <__alltraps>

0010260c <vector189>:
.globl vector189
vector189:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $189
  10260e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102613:	e9 18 03 00 00       	jmp    102930 <__alltraps>

00102618 <vector190>:
.globl vector190
vector190:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $190
  10261a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10261f:	e9 0c 03 00 00       	jmp    102930 <__alltraps>

00102624 <vector191>:
.globl vector191
vector191:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $191
  102626:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10262b:	e9 00 03 00 00       	jmp    102930 <__alltraps>

00102630 <vector192>:
.globl vector192
vector192:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $192
  102632:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102637:	e9 f4 02 00 00       	jmp    102930 <__alltraps>

0010263c <vector193>:
.globl vector193
vector193:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $193
  10263e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102643:	e9 e8 02 00 00       	jmp    102930 <__alltraps>

00102648 <vector194>:
.globl vector194
vector194:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $194
  10264a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10264f:	e9 dc 02 00 00       	jmp    102930 <__alltraps>

00102654 <vector195>:
.globl vector195
vector195:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $195
  102656:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10265b:	e9 d0 02 00 00       	jmp    102930 <__alltraps>

00102660 <vector196>:
.globl vector196
vector196:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $196
  102662:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102667:	e9 c4 02 00 00       	jmp    102930 <__alltraps>

0010266c <vector197>:
.globl vector197
vector197:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $197
  10266e:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102673:	e9 b8 02 00 00       	jmp    102930 <__alltraps>

00102678 <vector198>:
.globl vector198
vector198:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $198
  10267a:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10267f:	e9 ac 02 00 00       	jmp    102930 <__alltraps>

00102684 <vector199>:
.globl vector199
vector199:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $199
  102686:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10268b:	e9 a0 02 00 00       	jmp    102930 <__alltraps>

00102690 <vector200>:
.globl vector200
vector200:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $200
  102692:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102697:	e9 94 02 00 00       	jmp    102930 <__alltraps>

0010269c <vector201>:
.globl vector201
vector201:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $201
  10269e:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026a3:	e9 88 02 00 00       	jmp    102930 <__alltraps>

001026a8 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $202
  1026aa:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026af:	e9 7c 02 00 00       	jmp    102930 <__alltraps>

001026b4 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $203
  1026b6:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026bb:	e9 70 02 00 00       	jmp    102930 <__alltraps>

001026c0 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $204
  1026c2:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026c7:	e9 64 02 00 00       	jmp    102930 <__alltraps>

001026cc <vector205>:
.globl vector205
vector205:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $205
  1026ce:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026d3:	e9 58 02 00 00       	jmp    102930 <__alltraps>

001026d8 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $206
  1026da:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026df:	e9 4c 02 00 00       	jmp    102930 <__alltraps>

001026e4 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $207
  1026e6:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026eb:	e9 40 02 00 00       	jmp    102930 <__alltraps>

001026f0 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $208
  1026f2:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026f7:	e9 34 02 00 00       	jmp    102930 <__alltraps>

001026fc <vector209>:
.globl vector209
vector209:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $209
  1026fe:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102703:	e9 28 02 00 00       	jmp    102930 <__alltraps>

00102708 <vector210>:
.globl vector210
vector210:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $210
  10270a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10270f:	e9 1c 02 00 00       	jmp    102930 <__alltraps>

00102714 <vector211>:
.globl vector211
vector211:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $211
  102716:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10271b:	e9 10 02 00 00       	jmp    102930 <__alltraps>

00102720 <vector212>:
.globl vector212
vector212:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $212
  102722:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102727:	e9 04 02 00 00       	jmp    102930 <__alltraps>

0010272c <vector213>:
.globl vector213
vector213:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $213
  10272e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102733:	e9 f8 01 00 00       	jmp    102930 <__alltraps>

00102738 <vector214>:
.globl vector214
vector214:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $214
  10273a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10273f:	e9 ec 01 00 00       	jmp    102930 <__alltraps>

00102744 <vector215>:
.globl vector215
vector215:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $215
  102746:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10274b:	e9 e0 01 00 00       	jmp    102930 <__alltraps>

00102750 <vector216>:
.globl vector216
vector216:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $216
  102752:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102757:	e9 d4 01 00 00       	jmp    102930 <__alltraps>

0010275c <vector217>:
.globl vector217
vector217:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $217
  10275e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102763:	e9 c8 01 00 00       	jmp    102930 <__alltraps>

00102768 <vector218>:
.globl vector218
vector218:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $218
  10276a:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10276f:	e9 bc 01 00 00       	jmp    102930 <__alltraps>

00102774 <vector219>:
.globl vector219
vector219:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $219
  102776:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10277b:	e9 b0 01 00 00       	jmp    102930 <__alltraps>

00102780 <vector220>:
.globl vector220
vector220:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $220
  102782:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102787:	e9 a4 01 00 00       	jmp    102930 <__alltraps>

0010278c <vector221>:
.globl vector221
vector221:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $221
  10278e:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102793:	e9 98 01 00 00       	jmp    102930 <__alltraps>

00102798 <vector222>:
.globl vector222
vector222:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $222
  10279a:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10279f:	e9 8c 01 00 00       	jmp    102930 <__alltraps>

001027a4 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $223
  1027a6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027ab:	e9 80 01 00 00       	jmp    102930 <__alltraps>

001027b0 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $224
  1027b2:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027b7:	e9 74 01 00 00       	jmp    102930 <__alltraps>

001027bc <vector225>:
.globl vector225
vector225:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $225
  1027be:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027c3:	e9 68 01 00 00       	jmp    102930 <__alltraps>

001027c8 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $226
  1027ca:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027cf:	e9 5c 01 00 00       	jmp    102930 <__alltraps>

001027d4 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $227
  1027d6:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027db:	e9 50 01 00 00       	jmp    102930 <__alltraps>

001027e0 <vector228>:
.globl vector228
vector228:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $228
  1027e2:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027e7:	e9 44 01 00 00       	jmp    102930 <__alltraps>

001027ec <vector229>:
.globl vector229
vector229:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $229
  1027ee:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027f3:	e9 38 01 00 00       	jmp    102930 <__alltraps>

001027f8 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $230
  1027fa:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027ff:	e9 2c 01 00 00       	jmp    102930 <__alltraps>

00102804 <vector231>:
.globl vector231
vector231:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $231
  102806:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10280b:	e9 20 01 00 00       	jmp    102930 <__alltraps>

00102810 <vector232>:
.globl vector232
vector232:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $232
  102812:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102817:	e9 14 01 00 00       	jmp    102930 <__alltraps>

0010281c <vector233>:
.globl vector233
vector233:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $233
  10281e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102823:	e9 08 01 00 00       	jmp    102930 <__alltraps>

00102828 <vector234>:
.globl vector234
vector234:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $234
  10282a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10282f:	e9 fc 00 00 00       	jmp    102930 <__alltraps>

00102834 <vector235>:
.globl vector235
vector235:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $235
  102836:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10283b:	e9 f0 00 00 00       	jmp    102930 <__alltraps>

00102840 <vector236>:
.globl vector236
vector236:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $236
  102842:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102847:	e9 e4 00 00 00       	jmp    102930 <__alltraps>

0010284c <vector237>:
.globl vector237
vector237:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $237
  10284e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102853:	e9 d8 00 00 00       	jmp    102930 <__alltraps>

00102858 <vector238>:
.globl vector238
vector238:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $238
  10285a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10285f:	e9 cc 00 00 00       	jmp    102930 <__alltraps>

00102864 <vector239>:
.globl vector239
vector239:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $239
  102866:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10286b:	e9 c0 00 00 00       	jmp    102930 <__alltraps>

00102870 <vector240>:
.globl vector240
vector240:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $240
  102872:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102877:	e9 b4 00 00 00       	jmp    102930 <__alltraps>

0010287c <vector241>:
.globl vector241
vector241:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $241
  10287e:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102883:	e9 a8 00 00 00       	jmp    102930 <__alltraps>

00102888 <vector242>:
.globl vector242
vector242:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $242
  10288a:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10288f:	e9 9c 00 00 00       	jmp    102930 <__alltraps>

00102894 <vector243>:
.globl vector243
vector243:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $243
  102896:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10289b:	e9 90 00 00 00       	jmp    102930 <__alltraps>

001028a0 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $244
  1028a2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028a7:	e9 84 00 00 00       	jmp    102930 <__alltraps>

001028ac <vector245>:
.globl vector245
vector245:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $245
  1028ae:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028b3:	e9 78 00 00 00       	jmp    102930 <__alltraps>

001028b8 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $246
  1028ba:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028bf:	e9 6c 00 00 00       	jmp    102930 <__alltraps>

001028c4 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $247
  1028c6:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028cb:	e9 60 00 00 00       	jmp    102930 <__alltraps>

001028d0 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $248
  1028d2:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028d7:	e9 54 00 00 00       	jmp    102930 <__alltraps>

001028dc <vector249>:
.globl vector249
vector249:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $249
  1028de:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028e3:	e9 48 00 00 00       	jmp    102930 <__alltraps>

001028e8 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $250
  1028ea:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028ef:	e9 3c 00 00 00       	jmp    102930 <__alltraps>

001028f4 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028f4:	6a 00                	push   $0x0
  pushl $251
  1028f6:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028fb:	e9 30 00 00 00       	jmp    102930 <__alltraps>

00102900 <vector252>:
.globl vector252
vector252:
  pushl $0
  102900:	6a 00                	push   $0x0
  pushl $252
  102902:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102907:	e9 24 00 00 00       	jmp    102930 <__alltraps>

0010290c <vector253>:
.globl vector253
vector253:
  pushl $0
  10290c:	6a 00                	push   $0x0
  pushl $253
  10290e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102913:	e9 18 00 00 00       	jmp    102930 <__alltraps>

00102918 <vector254>:
.globl vector254
vector254:
  pushl $0
  102918:	6a 00                	push   $0x0
  pushl $254
  10291a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10291f:	e9 0c 00 00 00       	jmp    102930 <__alltraps>

00102924 <vector255>:
.globl vector255
vector255:
  pushl $0
  102924:	6a 00                	push   $0x0
  pushl $255
  102926:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10292b:	e9 00 00 00 00       	jmp    102930 <__alltraps>

00102930 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102930:	1e                   	push   %ds
    pushl %es
  102931:	06                   	push   %es
    pushl %fs
  102932:	0f a0                	push   %fs
    pushl %gs
  102934:	0f a8                	push   %gs
    pushal
  102936:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102937:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10293c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10293e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102940:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102941:	e8 63 f5 ff ff       	call   101ea9 <trap>

    # pop the pushed stack pointer
    popl %esp
  102946:	5c                   	pop    %esp

00102947 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102947:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102948:	0f a9                	pop    %gs
    popl %fs
  10294a:	0f a1                	pop    %fs
    popl %es
  10294c:	07                   	pop    %es
    popl %ds
  10294d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10294e:	83 c4 08             	add    $0x8,%esp
    iret
  102951:	cf                   	iret   

00102952 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102952:	55                   	push   %ebp
  102953:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102955:	8b 45 08             	mov    0x8(%ebp),%eax
  102958:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10295b:	b8 23 00 00 00       	mov    $0x23,%eax
  102960:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102962:	b8 23 00 00 00       	mov    $0x23,%eax
  102967:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102969:	b8 10 00 00 00       	mov    $0x10,%eax
  10296e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102970:	b8 10 00 00 00       	mov    $0x10,%eax
  102975:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102977:	b8 10 00 00 00       	mov    $0x10,%eax
  10297c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10297e:	ea 85 29 10 00 08 00 	ljmp   $0x8,$0x102985
}
  102985:	90                   	nop
  102986:	5d                   	pop    %ebp
  102987:	c3                   	ret    

00102988 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102988:	55                   	push   %ebp
  102989:	89 e5                	mov    %esp,%ebp
  10298b:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10298e:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102993:	05 00 04 00 00       	add    $0x400,%eax
  102998:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10299d:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1029a4:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029a6:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1029ad:	68 00 
  1029af:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029b4:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029ba:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029bf:	c1 e8 10             	shr    $0x10,%eax
  1029c2:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029c7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ce:	83 e0 f0             	and    $0xfffffff0,%eax
  1029d1:	83 c8 09             	or     $0x9,%eax
  1029d4:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029d9:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029e0:	83 c8 10             	or     $0x10,%eax
  1029e3:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029e8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ef:	83 e0 9f             	and    $0xffffff9f,%eax
  1029f2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029f7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029fe:	83 c8 80             	or     $0xffffff80,%eax
  102a01:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a06:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a0d:	83 e0 f0             	and    $0xfffffff0,%eax
  102a10:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a15:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a1c:	83 e0 ef             	and    $0xffffffef,%eax
  102a1f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a24:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a2b:	83 e0 df             	and    $0xffffffdf,%eax
  102a2e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a33:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a3a:	83 c8 40             	or     $0x40,%eax
  102a3d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a42:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a49:	83 e0 7f             	and    $0x7f,%eax
  102a4c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a51:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a56:	c1 e8 18             	shr    $0x18,%eax
  102a59:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a5e:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a65:	83 e0 ef             	and    $0xffffffef,%eax
  102a68:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a6d:	68 10 ea 10 00       	push   $0x10ea10
  102a72:	e8 db fe ff ff       	call   102952 <lgdt>
  102a77:	83 c4 04             	add    $0x4,%esp
  102a7a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a80:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a84:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a87:	90                   	nop
  102a88:	c9                   	leave  
  102a89:	c3                   	ret    

00102a8a <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a8a:	55                   	push   %ebp
  102a8b:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a8d:	e8 f6 fe ff ff       	call   102988 <gdt_init>
}
  102a92:	90                   	nop
  102a93:	5d                   	pop    %ebp
  102a94:	c3                   	ret    

00102a95 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102a95:	55                   	push   %ebp
  102a96:	89 e5                	mov    %esp,%ebp
  102a98:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102aa2:	eb 04                	jmp    102aa8 <strlen+0x13>
        cnt ++;
  102aa4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  102aab:	8d 50 01             	lea    0x1(%eax),%edx
  102aae:	89 55 08             	mov    %edx,0x8(%ebp)
  102ab1:	0f b6 00             	movzbl (%eax),%eax
  102ab4:	84 c0                	test   %al,%al
  102ab6:	75 ec                	jne    102aa4 <strlen+0xf>
    }
    return cnt;
  102ab8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102abb:	c9                   	leave  
  102abc:	c3                   	ret    

00102abd <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102abd:	55                   	push   %ebp
  102abe:	89 e5                	mov    %esp,%ebp
  102ac0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ac3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102aca:	eb 04                	jmp    102ad0 <strnlen+0x13>
        cnt ++;
  102acc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ad0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ad3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ad6:	73 10                	jae    102ae8 <strnlen+0x2b>
  102ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  102adb:	8d 50 01             	lea    0x1(%eax),%edx
  102ade:	89 55 08             	mov    %edx,0x8(%ebp)
  102ae1:	0f b6 00             	movzbl (%eax),%eax
  102ae4:	84 c0                	test   %al,%al
  102ae6:	75 e4                	jne    102acc <strnlen+0xf>
    }
    return cnt;
  102ae8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102aeb:	c9                   	leave  
  102aec:	c3                   	ret    

00102aed <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102aed:	55                   	push   %ebp
  102aee:	89 e5                	mov    %esp,%ebp
  102af0:	57                   	push   %edi
  102af1:	56                   	push   %esi
  102af2:	83 ec 20             	sub    $0x20,%esp
  102af5:	8b 45 08             	mov    0x8(%ebp),%eax
  102af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102b01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b07:	89 d1                	mov    %edx,%ecx
  102b09:	89 c2                	mov    %eax,%edx
  102b0b:	89 ce                	mov    %ecx,%esi
  102b0d:	89 d7                	mov    %edx,%edi
  102b0f:	ac                   	lods   %ds:(%esi),%al
  102b10:	aa                   	stos   %al,%es:(%edi)
  102b11:	84 c0                	test   %al,%al
  102b13:	75 fa                	jne    102b0f <strcpy+0x22>
  102b15:	89 fa                	mov    %edi,%edx
  102b17:	89 f1                	mov    %esi,%ecx
  102b19:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102b1c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102b1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102b25:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102b26:	83 c4 20             	add    $0x20,%esp
  102b29:	5e                   	pop    %esi
  102b2a:	5f                   	pop    %edi
  102b2b:	5d                   	pop    %ebp
  102b2c:	c3                   	ret    

00102b2d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102b2d:	55                   	push   %ebp
  102b2e:	89 e5                	mov    %esp,%ebp
  102b30:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102b33:	8b 45 08             	mov    0x8(%ebp),%eax
  102b36:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102b39:	eb 21                	jmp    102b5c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b3e:	0f b6 10             	movzbl (%eax),%edx
  102b41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b44:	88 10                	mov    %dl,(%eax)
  102b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b49:	0f b6 00             	movzbl (%eax),%eax
  102b4c:	84 c0                	test   %al,%al
  102b4e:	74 04                	je     102b54 <strncpy+0x27>
            src ++;
  102b50:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102b54:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102b58:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102b5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b60:	75 d9                	jne    102b3b <strncpy+0xe>
    }
    return dst;
  102b62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b65:	c9                   	leave  
  102b66:	c3                   	ret    

00102b67 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102b67:	55                   	push   %ebp
  102b68:	89 e5                	mov    %esp,%ebp
  102b6a:	57                   	push   %edi
  102b6b:	56                   	push   %esi
  102b6c:	83 ec 20             	sub    $0x20,%esp
  102b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b81:	89 d1                	mov    %edx,%ecx
  102b83:	89 c2                	mov    %eax,%edx
  102b85:	89 ce                	mov    %ecx,%esi
  102b87:	89 d7                	mov    %edx,%edi
  102b89:	ac                   	lods   %ds:(%esi),%al
  102b8a:	ae                   	scas   %es:(%edi),%al
  102b8b:	75 08                	jne    102b95 <strcmp+0x2e>
  102b8d:	84 c0                	test   %al,%al
  102b8f:	75 f8                	jne    102b89 <strcmp+0x22>
  102b91:	31 c0                	xor    %eax,%eax
  102b93:	eb 04                	jmp    102b99 <strcmp+0x32>
  102b95:	19 c0                	sbb    %eax,%eax
  102b97:	0c 01                	or     $0x1,%al
  102b99:	89 fa                	mov    %edi,%edx
  102b9b:	89 f1                	mov    %esi,%ecx
  102b9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ba0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ba3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102ba9:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102baa:	83 c4 20             	add    $0x20,%esp
  102bad:	5e                   	pop    %esi
  102bae:	5f                   	pop    %edi
  102baf:	5d                   	pop    %ebp
  102bb0:	c3                   	ret    

00102bb1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102bb1:	55                   	push   %ebp
  102bb2:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102bb4:	eb 0c                	jmp    102bc2 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102bb6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102bba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bbe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102bc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bc6:	74 1a                	je     102be2 <strncmp+0x31>
  102bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcb:	0f b6 00             	movzbl (%eax),%eax
  102bce:	84 c0                	test   %al,%al
  102bd0:	74 10                	je     102be2 <strncmp+0x31>
  102bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd5:	0f b6 10             	movzbl (%eax),%edx
  102bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bdb:	0f b6 00             	movzbl (%eax),%eax
  102bde:	38 c2                	cmp    %al,%dl
  102be0:	74 d4                	je     102bb6 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102be2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102be6:	74 18                	je     102c00 <strncmp+0x4f>
  102be8:	8b 45 08             	mov    0x8(%ebp),%eax
  102beb:	0f b6 00             	movzbl (%eax),%eax
  102bee:	0f b6 d0             	movzbl %al,%edx
  102bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bf4:	0f b6 00             	movzbl (%eax),%eax
  102bf7:	0f b6 c0             	movzbl %al,%eax
  102bfa:	29 c2                	sub    %eax,%edx
  102bfc:	89 d0                	mov    %edx,%eax
  102bfe:	eb 05                	jmp    102c05 <strncmp+0x54>
  102c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c05:	5d                   	pop    %ebp
  102c06:	c3                   	ret    

00102c07 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102c07:	55                   	push   %ebp
  102c08:	89 e5                	mov    %esp,%ebp
  102c0a:	83 ec 04             	sub    $0x4,%esp
  102c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c10:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c13:	eb 14                	jmp    102c29 <strchr+0x22>
        if (*s == c) {
  102c15:	8b 45 08             	mov    0x8(%ebp),%eax
  102c18:	0f b6 00             	movzbl (%eax),%eax
  102c1b:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102c1e:	75 05                	jne    102c25 <strchr+0x1e>
            return (char *)s;
  102c20:	8b 45 08             	mov    0x8(%ebp),%eax
  102c23:	eb 13                	jmp    102c38 <strchr+0x31>
        }
        s ++;
  102c25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c29:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2c:	0f b6 00             	movzbl (%eax),%eax
  102c2f:	84 c0                	test   %al,%al
  102c31:	75 e2                	jne    102c15 <strchr+0xe>
    }
    return NULL;
  102c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c38:	c9                   	leave  
  102c39:	c3                   	ret    

00102c3a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102c3a:	55                   	push   %ebp
  102c3b:	89 e5                	mov    %esp,%ebp
  102c3d:	83 ec 04             	sub    $0x4,%esp
  102c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c43:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c46:	eb 0f                	jmp    102c57 <strfind+0x1d>
        if (*s == c) {
  102c48:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4b:	0f b6 00             	movzbl (%eax),%eax
  102c4e:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102c51:	74 10                	je     102c63 <strfind+0x29>
            break;
        }
        s ++;
  102c53:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c57:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5a:	0f b6 00             	movzbl (%eax),%eax
  102c5d:	84 c0                	test   %al,%al
  102c5f:	75 e7                	jne    102c48 <strfind+0xe>
  102c61:	eb 01                	jmp    102c64 <strfind+0x2a>
            break;
  102c63:	90                   	nop
    }
    return (char *)s;
  102c64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c67:	c9                   	leave  
  102c68:	c3                   	ret    

00102c69 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102c69:	55                   	push   %ebp
  102c6a:	89 e5                	mov    %esp,%ebp
  102c6c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102c6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102c76:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102c7d:	eb 04                	jmp    102c83 <strtol+0x1a>
        s ++;
  102c7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102c83:	8b 45 08             	mov    0x8(%ebp),%eax
  102c86:	0f b6 00             	movzbl (%eax),%eax
  102c89:	3c 20                	cmp    $0x20,%al
  102c8b:	74 f2                	je     102c7f <strtol+0x16>
  102c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c90:	0f b6 00             	movzbl (%eax),%eax
  102c93:	3c 09                	cmp    $0x9,%al
  102c95:	74 e8                	je     102c7f <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102c97:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9a:	0f b6 00             	movzbl (%eax),%eax
  102c9d:	3c 2b                	cmp    $0x2b,%al
  102c9f:	75 06                	jne    102ca7 <strtol+0x3e>
        s ++;
  102ca1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ca5:	eb 15                	jmp    102cbc <strtol+0x53>
    }
    else if (*s == '-') {
  102ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  102caa:	0f b6 00             	movzbl (%eax),%eax
  102cad:	3c 2d                	cmp    $0x2d,%al
  102caf:	75 0b                	jne    102cbc <strtol+0x53>
        s ++, neg = 1;
  102cb1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cb5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102cbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cc0:	74 06                	je     102cc8 <strtol+0x5f>
  102cc2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102cc6:	75 24                	jne    102cec <strtol+0x83>
  102cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ccb:	0f b6 00             	movzbl (%eax),%eax
  102cce:	3c 30                	cmp    $0x30,%al
  102cd0:	75 1a                	jne    102cec <strtol+0x83>
  102cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd5:	83 c0 01             	add    $0x1,%eax
  102cd8:	0f b6 00             	movzbl (%eax),%eax
  102cdb:	3c 78                	cmp    $0x78,%al
  102cdd:	75 0d                	jne    102cec <strtol+0x83>
        s += 2, base = 16;
  102cdf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102ce3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102cea:	eb 2a                	jmp    102d16 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102cec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cf0:	75 17                	jne    102d09 <strtol+0xa0>
  102cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf5:	0f b6 00             	movzbl (%eax),%eax
  102cf8:	3c 30                	cmp    $0x30,%al
  102cfa:	75 0d                	jne    102d09 <strtol+0xa0>
        s ++, base = 8;
  102cfc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d00:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102d07:	eb 0d                	jmp    102d16 <strtol+0xad>
    }
    else if (base == 0) {
  102d09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d0d:	75 07                	jne    102d16 <strtol+0xad>
        base = 10;
  102d0f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102d16:	8b 45 08             	mov    0x8(%ebp),%eax
  102d19:	0f b6 00             	movzbl (%eax),%eax
  102d1c:	3c 2f                	cmp    $0x2f,%al
  102d1e:	7e 1b                	jle    102d3b <strtol+0xd2>
  102d20:	8b 45 08             	mov    0x8(%ebp),%eax
  102d23:	0f b6 00             	movzbl (%eax),%eax
  102d26:	3c 39                	cmp    $0x39,%al
  102d28:	7f 11                	jg     102d3b <strtol+0xd2>
            dig = *s - '0';
  102d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2d:	0f b6 00             	movzbl (%eax),%eax
  102d30:	0f be c0             	movsbl %al,%eax
  102d33:	83 e8 30             	sub    $0x30,%eax
  102d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d39:	eb 48                	jmp    102d83 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3e:	0f b6 00             	movzbl (%eax),%eax
  102d41:	3c 60                	cmp    $0x60,%al
  102d43:	7e 1b                	jle    102d60 <strtol+0xf7>
  102d45:	8b 45 08             	mov    0x8(%ebp),%eax
  102d48:	0f b6 00             	movzbl (%eax),%eax
  102d4b:	3c 7a                	cmp    $0x7a,%al
  102d4d:	7f 11                	jg     102d60 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d52:	0f b6 00             	movzbl (%eax),%eax
  102d55:	0f be c0             	movsbl %al,%eax
  102d58:	83 e8 57             	sub    $0x57,%eax
  102d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d5e:	eb 23                	jmp    102d83 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102d60:	8b 45 08             	mov    0x8(%ebp),%eax
  102d63:	0f b6 00             	movzbl (%eax),%eax
  102d66:	3c 40                	cmp    $0x40,%al
  102d68:	7e 3c                	jle    102da6 <strtol+0x13d>
  102d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6d:	0f b6 00             	movzbl (%eax),%eax
  102d70:	3c 5a                	cmp    $0x5a,%al
  102d72:	7f 32                	jg     102da6 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102d74:	8b 45 08             	mov    0x8(%ebp),%eax
  102d77:	0f b6 00             	movzbl (%eax),%eax
  102d7a:	0f be c0             	movsbl %al,%eax
  102d7d:	83 e8 37             	sub    $0x37,%eax
  102d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d86:	3b 45 10             	cmp    0x10(%ebp),%eax
  102d89:	7d 1a                	jge    102da5 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102d8b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d92:	0f af 45 10          	imul   0x10(%ebp),%eax
  102d96:	89 c2                	mov    %eax,%edx
  102d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d9b:	01 d0                	add    %edx,%eax
  102d9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102da0:	e9 71 ff ff ff       	jmp    102d16 <strtol+0xad>
            break;
  102da5:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102da6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102daa:	74 08                	je     102db4 <strtol+0x14b>
        *endptr = (char *) s;
  102dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  102daf:	8b 55 08             	mov    0x8(%ebp),%edx
  102db2:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102db4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102db8:	74 07                	je     102dc1 <strtol+0x158>
  102dba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dbd:	f7 d8                	neg    %eax
  102dbf:	eb 03                	jmp    102dc4 <strtol+0x15b>
  102dc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102dc4:	c9                   	leave  
  102dc5:	c3                   	ret    

00102dc6 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102dc6:	55                   	push   %ebp
  102dc7:	89 e5                	mov    %esp,%ebp
  102dc9:	57                   	push   %edi
  102dca:	83 ec 24             	sub    $0x24,%esp
  102dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dd0:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102dd3:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102dd7:	8b 55 08             	mov    0x8(%ebp),%edx
  102dda:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102ddd:	88 45 f7             	mov    %al,-0x9(%ebp)
  102de0:	8b 45 10             	mov    0x10(%ebp),%eax
  102de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102de6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102de9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102ded:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102df0:	89 d7                	mov    %edx,%edi
  102df2:	f3 aa                	rep stos %al,%es:(%edi)
  102df4:	89 fa                	mov    %edi,%edx
  102df6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102df9:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dff:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102e00:	83 c4 24             	add    $0x24,%esp
  102e03:	5f                   	pop    %edi
  102e04:	5d                   	pop    %ebp
  102e05:	c3                   	ret    

00102e06 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102e06:	55                   	push   %ebp
  102e07:	89 e5                	mov    %esp,%ebp
  102e09:	57                   	push   %edi
  102e0a:	56                   	push   %esi
  102e0b:	53                   	push   %ebx
  102e0c:	83 ec 30             	sub    $0x30,%esp
  102e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  102e1e:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e27:	73 42                	jae    102e6b <memmove+0x65>
  102e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e32:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e38:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e3e:	c1 e8 02             	shr    $0x2,%eax
  102e41:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102e43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e49:	89 d7                	mov    %edx,%edi
  102e4b:	89 c6                	mov    %eax,%esi
  102e4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e4f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102e52:	83 e1 03             	and    $0x3,%ecx
  102e55:	74 02                	je     102e59 <memmove+0x53>
  102e57:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e59:	89 f0                	mov    %esi,%eax
  102e5b:	89 fa                	mov    %edi,%edx
  102e5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102e60:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e63:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102e69:	eb 36                	jmp    102ea1 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102e6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e74:	01 c2                	add    %eax,%edx
  102e76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e79:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e7f:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e85:	89 c1                	mov    %eax,%ecx
  102e87:	89 d8                	mov    %ebx,%eax
  102e89:	89 d6                	mov    %edx,%esi
  102e8b:	89 c7                	mov    %eax,%edi
  102e8d:	fd                   	std    
  102e8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e90:	fc                   	cld    
  102e91:	89 f8                	mov    %edi,%eax
  102e93:	89 f2                	mov    %esi,%edx
  102e95:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102e98:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102e9b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102ea1:	83 c4 30             	add    $0x30,%esp
  102ea4:	5b                   	pop    %ebx
  102ea5:	5e                   	pop    %esi
  102ea6:	5f                   	pop    %edi
  102ea7:	5d                   	pop    %ebp
  102ea8:	c3                   	ret    

00102ea9 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102ea9:	55                   	push   %ebp
  102eaa:	89 e5                	mov    %esp,%ebp
  102eac:	57                   	push   %edi
  102ead:	56                   	push   %esi
  102eae:	83 ec 20             	sub    $0x20,%esp
  102eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  102ec0:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102ec3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ec6:	c1 e8 02             	shr    $0x2,%eax
  102ec9:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ed1:	89 d7                	mov    %edx,%edi
  102ed3:	89 c6                	mov    %eax,%esi
  102ed5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102ed7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102eda:	83 e1 03             	and    $0x3,%ecx
  102edd:	74 02                	je     102ee1 <memcpy+0x38>
  102edf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ee1:	89 f0                	mov    %esi,%eax
  102ee3:	89 fa                	mov    %edi,%edx
  102ee5:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ee8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102eeb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102ef1:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102ef2:	83 c4 20             	add    $0x20,%esp
  102ef5:	5e                   	pop    %esi
  102ef6:	5f                   	pop    %edi
  102ef7:	5d                   	pop    %ebp
  102ef8:	c3                   	ret    

00102ef9 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102ef9:	55                   	push   %ebp
  102efa:	89 e5                	mov    %esp,%ebp
  102efc:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102eff:	8b 45 08             	mov    0x8(%ebp),%eax
  102f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f08:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102f0b:	eb 30                	jmp    102f3d <memcmp+0x44>
        if (*s1 != *s2) {
  102f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f10:	0f b6 10             	movzbl (%eax),%edx
  102f13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f16:	0f b6 00             	movzbl (%eax),%eax
  102f19:	38 c2                	cmp    %al,%dl
  102f1b:	74 18                	je     102f35 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f20:	0f b6 00             	movzbl (%eax),%eax
  102f23:	0f b6 d0             	movzbl %al,%edx
  102f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f29:	0f b6 00             	movzbl (%eax),%eax
  102f2c:	0f b6 c0             	movzbl %al,%eax
  102f2f:	29 c2                	sub    %eax,%edx
  102f31:	89 d0                	mov    %edx,%eax
  102f33:	eb 1a                	jmp    102f4f <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102f35:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102f39:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  102f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  102f40:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f43:	89 55 10             	mov    %edx,0x10(%ebp)
  102f46:	85 c0                	test   %eax,%eax
  102f48:	75 c3                	jne    102f0d <memcmp+0x14>
    }
    return 0;
  102f4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f4f:	c9                   	leave  
  102f50:	c3                   	ret    

00102f51 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102f51:	55                   	push   %ebp
  102f52:	89 e5                	mov    %esp,%ebp
  102f54:	83 ec 38             	sub    $0x38,%esp
  102f57:	8b 45 10             	mov    0x10(%ebp),%eax
  102f5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f5d:	8b 45 14             	mov    0x14(%ebp),%eax
  102f60:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102f63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f66:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f69:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f6c:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102f6f:	8b 45 18             	mov    0x18(%ebp),%eax
  102f72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f78:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f7e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f8b:	74 1c                	je     102fa9 <printnum+0x58>
  102f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f90:	ba 00 00 00 00       	mov    $0x0,%edx
  102f95:	f7 75 e4             	divl   -0x1c(%ebp)
  102f98:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f9e:	ba 00 00 00 00       	mov    $0x0,%edx
  102fa3:	f7 75 e4             	divl   -0x1c(%ebp)
  102fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102faf:	f7 75 e4             	divl   -0x1c(%ebp)
  102fb2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fb5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102fb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102fbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fc1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102fc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fc7:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102fca:	8b 45 18             	mov    0x18(%ebp),%eax
  102fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  102fd2:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102fd5:	72 41                	jb     103018 <printnum+0xc7>
  102fd7:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102fda:	77 05                	ja     102fe1 <printnum+0x90>
  102fdc:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102fdf:	72 37                	jb     103018 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102fe1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102fe4:	83 e8 01             	sub    $0x1,%eax
  102fe7:	83 ec 04             	sub    $0x4,%esp
  102fea:	ff 75 20             	pushl  0x20(%ebp)
  102fed:	50                   	push   %eax
  102fee:	ff 75 18             	pushl  0x18(%ebp)
  102ff1:	ff 75 ec             	pushl  -0x14(%ebp)
  102ff4:	ff 75 e8             	pushl  -0x18(%ebp)
  102ff7:	ff 75 0c             	pushl  0xc(%ebp)
  102ffa:	ff 75 08             	pushl  0x8(%ebp)
  102ffd:	e8 4f ff ff ff       	call   102f51 <printnum>
  103002:	83 c4 20             	add    $0x20,%esp
  103005:	eb 1b                	jmp    103022 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103007:	83 ec 08             	sub    $0x8,%esp
  10300a:	ff 75 0c             	pushl  0xc(%ebp)
  10300d:	ff 75 20             	pushl  0x20(%ebp)
  103010:	8b 45 08             	mov    0x8(%ebp),%eax
  103013:	ff d0                	call   *%eax
  103015:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  103018:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10301c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103020:	7f e5                	jg     103007 <printnum+0xb6>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103022:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103025:	05 10 3d 10 00       	add    $0x103d10,%eax
  10302a:	0f b6 00             	movzbl (%eax),%eax
  10302d:	0f be c0             	movsbl %al,%eax
  103030:	83 ec 08             	sub    $0x8,%esp
  103033:	ff 75 0c             	pushl  0xc(%ebp)
  103036:	50                   	push   %eax
  103037:	8b 45 08             	mov    0x8(%ebp),%eax
  10303a:	ff d0                	call   *%eax
  10303c:	83 c4 10             	add    $0x10,%esp
}
  10303f:	90                   	nop
  103040:	c9                   	leave  
  103041:	c3                   	ret    

00103042 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103042:	55                   	push   %ebp
  103043:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103045:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103049:	7e 14                	jle    10305f <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10304b:	8b 45 08             	mov    0x8(%ebp),%eax
  10304e:	8b 00                	mov    (%eax),%eax
  103050:	8d 48 08             	lea    0x8(%eax),%ecx
  103053:	8b 55 08             	mov    0x8(%ebp),%edx
  103056:	89 0a                	mov    %ecx,(%edx)
  103058:	8b 50 04             	mov    0x4(%eax),%edx
  10305b:	8b 00                	mov    (%eax),%eax
  10305d:	eb 30                	jmp    10308f <getuint+0x4d>
    }
    else if (lflag) {
  10305f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103063:	74 16                	je     10307b <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103065:	8b 45 08             	mov    0x8(%ebp),%eax
  103068:	8b 00                	mov    (%eax),%eax
  10306a:	8d 48 04             	lea    0x4(%eax),%ecx
  10306d:	8b 55 08             	mov    0x8(%ebp),%edx
  103070:	89 0a                	mov    %ecx,(%edx)
  103072:	8b 00                	mov    (%eax),%eax
  103074:	ba 00 00 00 00       	mov    $0x0,%edx
  103079:	eb 14                	jmp    10308f <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10307b:	8b 45 08             	mov    0x8(%ebp),%eax
  10307e:	8b 00                	mov    (%eax),%eax
  103080:	8d 48 04             	lea    0x4(%eax),%ecx
  103083:	8b 55 08             	mov    0x8(%ebp),%edx
  103086:	89 0a                	mov    %ecx,(%edx)
  103088:	8b 00                	mov    (%eax),%eax
  10308a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10308f:	5d                   	pop    %ebp
  103090:	c3                   	ret    

00103091 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103091:	55                   	push   %ebp
  103092:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103094:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103098:	7e 14                	jle    1030ae <getint+0x1d>
        return va_arg(*ap, long long);
  10309a:	8b 45 08             	mov    0x8(%ebp),%eax
  10309d:	8b 00                	mov    (%eax),%eax
  10309f:	8d 48 08             	lea    0x8(%eax),%ecx
  1030a2:	8b 55 08             	mov    0x8(%ebp),%edx
  1030a5:	89 0a                	mov    %ecx,(%edx)
  1030a7:	8b 50 04             	mov    0x4(%eax),%edx
  1030aa:	8b 00                	mov    (%eax),%eax
  1030ac:	eb 28                	jmp    1030d6 <getint+0x45>
    }
    else if (lflag) {
  1030ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1030b2:	74 12                	je     1030c6 <getint+0x35>
        return va_arg(*ap, long);
  1030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b7:	8b 00                	mov    (%eax),%eax
  1030b9:	8d 48 04             	lea    0x4(%eax),%ecx
  1030bc:	8b 55 08             	mov    0x8(%ebp),%edx
  1030bf:	89 0a                	mov    %ecx,(%edx)
  1030c1:	8b 00                	mov    (%eax),%eax
  1030c3:	99                   	cltd   
  1030c4:	eb 10                	jmp    1030d6 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c9:	8b 00                	mov    (%eax),%eax
  1030cb:	8d 48 04             	lea    0x4(%eax),%ecx
  1030ce:	8b 55 08             	mov    0x8(%ebp),%edx
  1030d1:	89 0a                	mov    %ecx,(%edx)
  1030d3:	8b 00                	mov    (%eax),%eax
  1030d5:	99                   	cltd   
    }
}
  1030d6:	5d                   	pop    %ebp
  1030d7:	c3                   	ret    

001030d8 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1030d8:	55                   	push   %ebp
  1030d9:	89 e5                	mov    %esp,%ebp
  1030db:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1030de:	8d 45 14             	lea    0x14(%ebp),%eax
  1030e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030e7:	50                   	push   %eax
  1030e8:	ff 75 10             	pushl  0x10(%ebp)
  1030eb:	ff 75 0c             	pushl  0xc(%ebp)
  1030ee:	ff 75 08             	pushl  0x8(%ebp)
  1030f1:	e8 06 00 00 00       	call   1030fc <vprintfmt>
  1030f6:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1030f9:	90                   	nop
  1030fa:	c9                   	leave  
  1030fb:	c3                   	ret    

001030fc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1030fc:	55                   	push   %ebp
  1030fd:	89 e5                	mov    %esp,%ebp
  1030ff:	56                   	push   %esi
  103100:	53                   	push   %ebx
  103101:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103104:	eb 17                	jmp    10311d <vprintfmt+0x21>
            if (ch == '\0') {
  103106:	85 db                	test   %ebx,%ebx
  103108:	0f 84 8e 03 00 00    	je     10349c <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  10310e:	83 ec 08             	sub    $0x8,%esp
  103111:	ff 75 0c             	pushl  0xc(%ebp)
  103114:	53                   	push   %ebx
  103115:	8b 45 08             	mov    0x8(%ebp),%eax
  103118:	ff d0                	call   *%eax
  10311a:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10311d:	8b 45 10             	mov    0x10(%ebp),%eax
  103120:	8d 50 01             	lea    0x1(%eax),%edx
  103123:	89 55 10             	mov    %edx,0x10(%ebp)
  103126:	0f b6 00             	movzbl (%eax),%eax
  103129:	0f b6 d8             	movzbl %al,%ebx
  10312c:	83 fb 25             	cmp    $0x25,%ebx
  10312f:	75 d5                	jne    103106 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103131:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103135:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10313c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10313f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103142:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103149:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10314c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10314f:	8b 45 10             	mov    0x10(%ebp),%eax
  103152:	8d 50 01             	lea    0x1(%eax),%edx
  103155:	89 55 10             	mov    %edx,0x10(%ebp)
  103158:	0f b6 00             	movzbl (%eax),%eax
  10315b:	0f b6 d8             	movzbl %al,%ebx
  10315e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103161:	83 f8 55             	cmp    $0x55,%eax
  103164:	0f 87 05 03 00 00    	ja     10346f <vprintfmt+0x373>
  10316a:	8b 04 85 34 3d 10 00 	mov    0x103d34(,%eax,4),%eax
  103171:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103173:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103177:	eb d6                	jmp    10314f <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103179:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10317d:	eb d0                	jmp    10314f <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10317f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103186:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103189:	89 d0                	mov    %edx,%eax
  10318b:	c1 e0 02             	shl    $0x2,%eax
  10318e:	01 d0                	add    %edx,%eax
  103190:	01 c0                	add    %eax,%eax
  103192:	01 d8                	add    %ebx,%eax
  103194:	83 e8 30             	sub    $0x30,%eax
  103197:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10319a:	8b 45 10             	mov    0x10(%ebp),%eax
  10319d:	0f b6 00             	movzbl (%eax),%eax
  1031a0:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1031a3:	83 fb 2f             	cmp    $0x2f,%ebx
  1031a6:	7e 39                	jle    1031e1 <vprintfmt+0xe5>
  1031a8:	83 fb 39             	cmp    $0x39,%ebx
  1031ab:	7f 34                	jg     1031e1 <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
  1031ad:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1031b1:	eb d3                	jmp    103186 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1031b3:	8b 45 14             	mov    0x14(%ebp),%eax
  1031b6:	8d 50 04             	lea    0x4(%eax),%edx
  1031b9:	89 55 14             	mov    %edx,0x14(%ebp)
  1031bc:	8b 00                	mov    (%eax),%eax
  1031be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1031c1:	eb 1f                	jmp    1031e2 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  1031c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031c7:	79 86                	jns    10314f <vprintfmt+0x53>
                width = 0;
  1031c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1031d0:	e9 7a ff ff ff       	jmp    10314f <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1031d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1031dc:	e9 6e ff ff ff       	jmp    10314f <vprintfmt+0x53>
            goto process_precision;
  1031e1:	90                   	nop

        process_precision:
            if (width < 0)
  1031e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031e6:	0f 89 63 ff ff ff    	jns    10314f <vprintfmt+0x53>
                width = precision, precision = -1;
  1031ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031f2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1031f9:	e9 51 ff ff ff       	jmp    10314f <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1031fe:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  103202:	e9 48 ff ff ff       	jmp    10314f <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103207:	8b 45 14             	mov    0x14(%ebp),%eax
  10320a:	8d 50 04             	lea    0x4(%eax),%edx
  10320d:	89 55 14             	mov    %edx,0x14(%ebp)
  103210:	8b 00                	mov    (%eax),%eax
  103212:	83 ec 08             	sub    $0x8,%esp
  103215:	ff 75 0c             	pushl  0xc(%ebp)
  103218:	50                   	push   %eax
  103219:	8b 45 08             	mov    0x8(%ebp),%eax
  10321c:	ff d0                	call   *%eax
  10321e:	83 c4 10             	add    $0x10,%esp
            break;
  103221:	e9 71 02 00 00       	jmp    103497 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103226:	8b 45 14             	mov    0x14(%ebp),%eax
  103229:	8d 50 04             	lea    0x4(%eax),%edx
  10322c:	89 55 14             	mov    %edx,0x14(%ebp)
  10322f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103231:	85 db                	test   %ebx,%ebx
  103233:	79 02                	jns    103237 <vprintfmt+0x13b>
                err = -err;
  103235:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103237:	83 fb 06             	cmp    $0x6,%ebx
  10323a:	7f 0b                	jg     103247 <vprintfmt+0x14b>
  10323c:	8b 34 9d f4 3c 10 00 	mov    0x103cf4(,%ebx,4),%esi
  103243:	85 f6                	test   %esi,%esi
  103245:	75 19                	jne    103260 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  103247:	53                   	push   %ebx
  103248:	68 21 3d 10 00       	push   $0x103d21
  10324d:	ff 75 0c             	pushl  0xc(%ebp)
  103250:	ff 75 08             	pushl  0x8(%ebp)
  103253:	e8 80 fe ff ff       	call   1030d8 <printfmt>
  103258:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10325b:	e9 37 02 00 00       	jmp    103497 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
  103260:	56                   	push   %esi
  103261:	68 2a 3d 10 00       	push   $0x103d2a
  103266:	ff 75 0c             	pushl  0xc(%ebp)
  103269:	ff 75 08             	pushl  0x8(%ebp)
  10326c:	e8 67 fe ff ff       	call   1030d8 <printfmt>
  103271:	83 c4 10             	add    $0x10,%esp
            break;
  103274:	e9 1e 02 00 00       	jmp    103497 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103279:	8b 45 14             	mov    0x14(%ebp),%eax
  10327c:	8d 50 04             	lea    0x4(%eax),%edx
  10327f:	89 55 14             	mov    %edx,0x14(%ebp)
  103282:	8b 30                	mov    (%eax),%esi
  103284:	85 f6                	test   %esi,%esi
  103286:	75 05                	jne    10328d <vprintfmt+0x191>
                p = "(null)";
  103288:	be 2d 3d 10 00       	mov    $0x103d2d,%esi
            }
            if (width > 0 && padc != '-') {
  10328d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103291:	7e 76                	jle    103309 <vprintfmt+0x20d>
  103293:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103297:	74 70                	je     103309 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10329c:	83 ec 08             	sub    $0x8,%esp
  10329f:	50                   	push   %eax
  1032a0:	56                   	push   %esi
  1032a1:	e8 17 f8 ff ff       	call   102abd <strnlen>
  1032a6:	83 c4 10             	add    $0x10,%esp
  1032a9:	89 c2                	mov    %eax,%edx
  1032ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032ae:	29 d0                	sub    %edx,%eax
  1032b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032b3:	eb 17                	jmp    1032cc <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1032b5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1032b9:	83 ec 08             	sub    $0x8,%esp
  1032bc:	ff 75 0c             	pushl  0xc(%ebp)
  1032bf:	50                   	push   %eax
  1032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c3:	ff d0                	call   *%eax
  1032c5:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032c8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1032cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032d0:	7f e3                	jg     1032b5 <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1032d2:	eb 35                	jmp    103309 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  1032d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1032d8:	74 1c                	je     1032f6 <vprintfmt+0x1fa>
  1032da:	83 fb 1f             	cmp    $0x1f,%ebx
  1032dd:	7e 05                	jle    1032e4 <vprintfmt+0x1e8>
  1032df:	83 fb 7e             	cmp    $0x7e,%ebx
  1032e2:	7e 12                	jle    1032f6 <vprintfmt+0x1fa>
                    putch('?', putdat);
  1032e4:	83 ec 08             	sub    $0x8,%esp
  1032e7:	ff 75 0c             	pushl  0xc(%ebp)
  1032ea:	6a 3f                	push   $0x3f
  1032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ef:	ff d0                	call   *%eax
  1032f1:	83 c4 10             	add    $0x10,%esp
  1032f4:	eb 0f                	jmp    103305 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  1032f6:	83 ec 08             	sub    $0x8,%esp
  1032f9:	ff 75 0c             	pushl  0xc(%ebp)
  1032fc:	53                   	push   %ebx
  1032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103300:	ff d0                	call   *%eax
  103302:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103305:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103309:	89 f0                	mov    %esi,%eax
  10330b:	8d 70 01             	lea    0x1(%eax),%esi
  10330e:	0f b6 00             	movzbl (%eax),%eax
  103311:	0f be d8             	movsbl %al,%ebx
  103314:	85 db                	test   %ebx,%ebx
  103316:	74 26                	je     10333e <vprintfmt+0x242>
  103318:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10331c:	78 b6                	js     1032d4 <vprintfmt+0x1d8>
  10331e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103322:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103326:	79 ac                	jns    1032d4 <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
  103328:	eb 14                	jmp    10333e <vprintfmt+0x242>
                putch(' ', putdat);
  10332a:	83 ec 08             	sub    $0x8,%esp
  10332d:	ff 75 0c             	pushl  0xc(%ebp)
  103330:	6a 20                	push   $0x20
  103332:	8b 45 08             	mov    0x8(%ebp),%eax
  103335:	ff d0                	call   *%eax
  103337:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  10333a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10333e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103342:	7f e6                	jg     10332a <vprintfmt+0x22e>
            }
            break;
  103344:	e9 4e 01 00 00       	jmp    103497 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103349:	83 ec 08             	sub    $0x8,%esp
  10334c:	ff 75 e0             	pushl  -0x20(%ebp)
  10334f:	8d 45 14             	lea    0x14(%ebp),%eax
  103352:	50                   	push   %eax
  103353:	e8 39 fd ff ff       	call   103091 <getint>
  103358:	83 c4 10             	add    $0x10,%esp
  10335b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10335e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103367:	85 d2                	test   %edx,%edx
  103369:	79 23                	jns    10338e <vprintfmt+0x292>
                putch('-', putdat);
  10336b:	83 ec 08             	sub    $0x8,%esp
  10336e:	ff 75 0c             	pushl  0xc(%ebp)
  103371:	6a 2d                	push   $0x2d
  103373:	8b 45 08             	mov    0x8(%ebp),%eax
  103376:	ff d0                	call   *%eax
  103378:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10337e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103381:	f7 d8                	neg    %eax
  103383:	83 d2 00             	adc    $0x0,%edx
  103386:	f7 da                	neg    %edx
  103388:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10338b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10338e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103395:	e9 9f 00 00 00       	jmp    103439 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10339a:	83 ec 08             	sub    $0x8,%esp
  10339d:	ff 75 e0             	pushl  -0x20(%ebp)
  1033a0:	8d 45 14             	lea    0x14(%ebp),%eax
  1033a3:	50                   	push   %eax
  1033a4:	e8 99 fc ff ff       	call   103042 <getuint>
  1033a9:	83 c4 10             	add    $0x10,%esp
  1033ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033af:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1033b2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033b9:	eb 7e                	jmp    103439 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1033bb:	83 ec 08             	sub    $0x8,%esp
  1033be:	ff 75 e0             	pushl  -0x20(%ebp)
  1033c1:	8d 45 14             	lea    0x14(%ebp),%eax
  1033c4:	50                   	push   %eax
  1033c5:	e8 78 fc ff ff       	call   103042 <getuint>
  1033ca:	83 c4 10             	add    $0x10,%esp
  1033cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1033d3:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1033da:	eb 5d                	jmp    103439 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  1033dc:	83 ec 08             	sub    $0x8,%esp
  1033df:	ff 75 0c             	pushl  0xc(%ebp)
  1033e2:	6a 30                	push   $0x30
  1033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e7:	ff d0                	call   *%eax
  1033e9:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  1033ec:	83 ec 08             	sub    $0x8,%esp
  1033ef:	ff 75 0c             	pushl  0xc(%ebp)
  1033f2:	6a 78                	push   $0x78
  1033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f7:	ff d0                	call   *%eax
  1033f9:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1033fc:	8b 45 14             	mov    0x14(%ebp),%eax
  1033ff:	8d 50 04             	lea    0x4(%eax),%edx
  103402:	89 55 14             	mov    %edx,0x14(%ebp)
  103405:	8b 00                	mov    (%eax),%eax
  103407:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10340a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103411:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103418:	eb 1f                	jmp    103439 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10341a:	83 ec 08             	sub    $0x8,%esp
  10341d:	ff 75 e0             	pushl  -0x20(%ebp)
  103420:	8d 45 14             	lea    0x14(%ebp),%eax
  103423:	50                   	push   %eax
  103424:	e8 19 fc ff ff       	call   103042 <getuint>
  103429:	83 c4 10             	add    $0x10,%esp
  10342c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10342f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103432:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103439:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10343d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103440:	83 ec 04             	sub    $0x4,%esp
  103443:	52                   	push   %edx
  103444:	ff 75 e8             	pushl  -0x18(%ebp)
  103447:	50                   	push   %eax
  103448:	ff 75 f4             	pushl  -0xc(%ebp)
  10344b:	ff 75 f0             	pushl  -0x10(%ebp)
  10344e:	ff 75 0c             	pushl  0xc(%ebp)
  103451:	ff 75 08             	pushl  0x8(%ebp)
  103454:	e8 f8 fa ff ff       	call   102f51 <printnum>
  103459:	83 c4 20             	add    $0x20,%esp
            break;
  10345c:	eb 39                	jmp    103497 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10345e:	83 ec 08             	sub    $0x8,%esp
  103461:	ff 75 0c             	pushl  0xc(%ebp)
  103464:	53                   	push   %ebx
  103465:	8b 45 08             	mov    0x8(%ebp),%eax
  103468:	ff d0                	call   *%eax
  10346a:	83 c4 10             	add    $0x10,%esp
            break;
  10346d:	eb 28                	jmp    103497 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10346f:	83 ec 08             	sub    $0x8,%esp
  103472:	ff 75 0c             	pushl  0xc(%ebp)
  103475:	6a 25                	push   $0x25
  103477:	8b 45 08             	mov    0x8(%ebp),%eax
  10347a:	ff d0                	call   *%eax
  10347c:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  10347f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103483:	eb 04                	jmp    103489 <vprintfmt+0x38d>
  103485:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103489:	8b 45 10             	mov    0x10(%ebp),%eax
  10348c:	83 e8 01             	sub    $0x1,%eax
  10348f:	0f b6 00             	movzbl (%eax),%eax
  103492:	3c 25                	cmp    $0x25,%al
  103494:	75 ef                	jne    103485 <vprintfmt+0x389>
                /* do nothing */;
            break;
  103496:	90                   	nop
    while (1) {
  103497:	e9 68 fc ff ff       	jmp    103104 <vprintfmt+0x8>
                return;
  10349c:	90                   	nop
        }
    }
}
  10349d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1034a0:	5b                   	pop    %ebx
  1034a1:	5e                   	pop    %esi
  1034a2:	5d                   	pop    %ebp
  1034a3:	c3                   	ret    

001034a4 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1034a4:	55                   	push   %ebp
  1034a5:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1034a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034aa:	8b 40 08             	mov    0x8(%eax),%eax
  1034ad:	8d 50 01             	lea    0x1(%eax),%edx
  1034b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034b3:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1034b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034b9:	8b 10                	mov    (%eax),%edx
  1034bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034be:	8b 40 04             	mov    0x4(%eax),%eax
  1034c1:	39 c2                	cmp    %eax,%edx
  1034c3:	73 12                	jae    1034d7 <sprintputch+0x33>
        *b->buf ++ = ch;
  1034c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c8:	8b 00                	mov    (%eax),%eax
  1034ca:	8d 48 01             	lea    0x1(%eax),%ecx
  1034cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1034d0:	89 0a                	mov    %ecx,(%edx)
  1034d2:	8b 55 08             	mov    0x8(%ebp),%edx
  1034d5:	88 10                	mov    %dl,(%eax)
    }
}
  1034d7:	90                   	nop
  1034d8:	5d                   	pop    %ebp
  1034d9:	c3                   	ret    

001034da <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1034da:	55                   	push   %ebp
  1034db:	89 e5                	mov    %esp,%ebp
  1034dd:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1034e0:	8d 45 14             	lea    0x14(%ebp),%eax
  1034e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1034e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034e9:	50                   	push   %eax
  1034ea:	ff 75 10             	pushl  0x10(%ebp)
  1034ed:	ff 75 0c             	pushl  0xc(%ebp)
  1034f0:	ff 75 08             	pushl  0x8(%ebp)
  1034f3:	e8 0b 00 00 00       	call   103503 <vsnprintf>
  1034f8:	83 c4 10             	add    $0x10,%esp
  1034fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103501:	c9                   	leave  
  103502:	c3                   	ret    

00103503 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103503:	55                   	push   %ebp
  103504:	89 e5                	mov    %esp,%ebp
  103506:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103509:	8b 45 08             	mov    0x8(%ebp),%eax
  10350c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10350f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103512:	8d 50 ff             	lea    -0x1(%eax),%edx
  103515:	8b 45 08             	mov    0x8(%ebp),%eax
  103518:	01 d0                	add    %edx,%eax
  10351a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10351d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103524:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103528:	74 0a                	je     103534 <vsnprintf+0x31>
  10352a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10352d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103530:	39 c2                	cmp    %eax,%edx
  103532:	76 07                	jbe    10353b <vsnprintf+0x38>
        return -E_INVAL;
  103534:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103539:	eb 20                	jmp    10355b <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10353b:	ff 75 14             	pushl  0x14(%ebp)
  10353e:	ff 75 10             	pushl  0x10(%ebp)
  103541:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103544:	50                   	push   %eax
  103545:	68 a4 34 10 00       	push   $0x1034a4
  10354a:	e8 ad fb ff ff       	call   1030fc <vprintfmt>
  10354f:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103555:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103558:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10355b:	c9                   	leave  
  10355c:	c3                   	ret    
