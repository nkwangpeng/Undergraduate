# lab1 

> [hughshine](https://hughshine.github.io) at github

[TOC]

## 练习一：make生成执行文件的过程

> 吐槽：
>
> 1. 让直接读makefile，真的很难受很难受的QAQ。就应该用`make -n`，哼。。白白看了好多makefile的知识，变量、函数那些，真的很复杂。。
> 2. 没有预先学习实验相关内容，会翻来覆去很费时间【所以以后都要先过一遍清华的mooc】
> 3. 啊，对mac还是很不友好，委屈。下面这个依赖树，我就画了好久。

### 1.分析ucore.img的生成过程

#### 1.1 终端输出分析

makefile以树形结构递归的进行编译，通过一些软件可以绘制出依赖树。本项目的递归树为以下。由于`bin/kernel`太长了，所以只截取关键部分。

```
make -Bnd | make2graph | dot -Tpng -o out.png
```

![pic](./files/graph_l.png)



`TARGETS`是Makefile中定义的`.DEFAULT_GOAL`，用于脚本监视核心文件，即`bin/sign` ，`bin/bootblock` ，`bin/kernel` ，`bin/ucore.img `。`bin/ucore.img `是实际的项目最终target。`bin/bootblock`依赖`bin/sign`，后与`bin/kernel`一起生成`ucore.img`。下面将逐一分析它们的作用。

首先宏观的分析`img`生成的过程，查看实际执行了什么：

```shell
make clean  # make -n 可以查看所有将执行的命令。
make "V="
```

可以发现make按以下顺序编译了文件，然后link了重要的二进制文件。中间报出了一些warning（省略掉了），在最后，借助dd，将`bin/bootblock`与`bin/kernel`按照操作系统的需求连接到了一起。
```shell
cc kern/init/init.c
# ...
# 编译大量kernel的基础功能
ld bin/kernel
cc boot/bootasm.S
cc boot/bootmain.c
cc tools/sign.c
# gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign
ld bin/bootblock
# 整合bootasm.o与bootmain.o，并将start段放在0x7C00的位置
i386-elf-ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
# ...
# objcopy把一种目标文件中的内容复制到另一种类型的目标文件中.
# .o比较大，.out比较小。。
# -S  移除所有符号和重定位信息
i386-elf-objcopy -S -O binary obj/bootblock.o obj/bootblock.out
# bin/sign对bootblock进行了检查，并生成bin/bootblock
bin/sign obj/bootblock.out bin/bootblock
# 检查的输出
'obj/bootblock.out' size: 492 bytes
build 512 bytes boot sector: 'bin/bootblock' success!
...
dd if=/dev/zero of=bin/ucore.img count=10000  # 初始化空盘
dd if=bin/bootblock of=bin/ucore.img conv=notrunc  # 先连bootblock, 它需要被放在第一个扇区
dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc  # 在第一个块后接上
```

下面给出了使用的dd命令的参数与其具体意义。

```shell
man dd  
# dd: convert and copy a file
if=<infile>
of=<outfile>
seek=n  # Seek n blocks from the beginning of the output before copying. 
cov=notrunc  # Do not truncate the output file.
count=n  # Copy only n input blocks.

另：/dev/zero在类UNIX系统中是一个特殊的设备文件，当你读它的时候，它会提供无限的空字符
```

#### 1.2 sign, bootblock, kernal的作用与生成脚本分析

##### `bin/sign`

`bin/sign`文件的作用：从上面对运行指令的分析，可以看到`bin/sign`主要用来对`obj/bootblock.out`进行检查，并进一步生成`bin/bootblock`。我对它的原始c文件`tools/sign.c`进行了注释。

```c
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <sys/stat.h>

int
main(int argc, char *argv[]) {
    struct stat st; //_stat结构体是文件（夹）信息的结构体，与stat(filename, buf)配合获取文件信息。
    if (argc != 3) {//检查输入参数数量
        fprintf(stderr, "Usage: <input filename> <output filename>\n");
        return -1;
    }
    if (stat(argv[1], &st) != 0) {//检查输入文件
        fprintf(stderr, "Error opening file '%s': %s\n", argv[1], strerror(errno));
        return -1;
    }
    printf("'%s' size: %lld bytes\n", argv[1], (long long)st.st_size); //输出文件大小
    if (st.st_size > 510) {//如果文件大于510，则报错退出。最后两个字节需要保存标志位。
        fprintf(stderr, "%lld >> 510!!\n", (long long)st.st_size);
        return -1;
    }
    //检查结束，以下代码生成目标文件
    char buf[512];     // 多余位被用0填充
    memset(buf, 0, sizeof(buf));
    FILE *ifp = fopen(argv[1], "rb");
    int size = fread(buf, 1, st.st_size, ifp); //读取blockmain.out
    if (size != st.st_size) { //读取结束后再检查一次，可能读取过程文件发生了改变
        fprintf(stderr, "read '%s' error, size is %d.\n", argv[1], size);
        return -1;
    }
    fclose(ifp); //关掉文件流
    buf[510] = 0x55; // 结束标志位
    buf[511] = 0xAA; // 结束标志位
    FILE *ofp = fopen(argv[2], "wb+"); //准备输出
    size = fwrite(buf, 1, 512, ofp); //将buf输出去
    if (size != 512) { //输出结束，再检查一次
        fprintf(stderr, "write '%s' error, size is %d.\n", argv[2], size);
        return -1;
    }
    fclose(ofp); //关闭输出文件流
    printf("build 512 bytes boot sector: '%s' success!\n", argv[2]); // 输出成功信息
    return 0;
}

```

`bin/sign`的生成过程：

```shell
# -I <value> Add directory to include search path
# -g debug mode
# -Wall 输出warning
# -O2 O2级别的优化
# -c Only run preprocess, compile, and assemble steps
# -o 指明output file
gcc -Itools/ -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o
gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign
```

##### `bin/bootblock`

`bin/bootblock`文件的作用：作为放在主引导扇区的代码，它主要用于初始化寄存器，完成实模式到保护模式的转换。其中为向后兼容，还做了许多检查。

`bin/bootblock`文件的生成过程：

```shell
# -march=cpu-type allows GCC to generate code that may not run at all on processors other than the one indicated
# -fno-* 一些优化选项
# -ggdb 是 -g的另一种写法
# 32位register
# -gstabs Produce debugging information in stabs format (if that is supported)
# -nostdinc Disable standard #include directories for the C++ standard library 因为不需要
# -Os 主要是对程序的尺寸进行优化。

i386-elf-gcc -Iboot/ -march=i686 -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o

i386-elf-gcc -Iboot/ -march=i686 -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootmain.c -o obj/boot/bootmain.o

# -m Don't treat multiple definitions as an error. !!!好像被废弃了。
# -nostdlib Do not use the standard system startup files or libraries when linking. No startup files and only the libraries you specify will be passed to the linker, and options specifying linkage of the system libraries, such as -static-libgcc or -shared-libgcc, are ignored.
# -e symbol_name Specifies the entry point of a main executable. 
# -T scriptfile Use scriptfile as the linker script. 存疑，感觉此处 -Ttext不是做这个的？
# -N Set the text and data sections to be readable and writable. Also, do not page-align the data segment, and disable linking against shared libraries. 
i386-elf-ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o

i386-elf-ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
```

##### `bin/kernel`

`bin/kernel`文件的作用：就是操作系统主要的内容啦，第一个练习不多加探讨。

`bin/kernel`文件的生成过程：以下只展示生成kernel的这一句。就是把一堆文件link起来，按照`tools/kernel.ld`中的规则。

```shell
# -T scriptfile Use scriptfile as the linker script. 这里应该是比较准确的。
# 别的前面都提过了。
i386-elf-ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/readline.o obj/kern/libs/stdio.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/debug/panic.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/intr.o obj/kern/driver/picirq.o obj/kern/trap/trap.o obj/kern/trap/trapentry.o obj/kern/trap/vectors.o obj/kern/mm/pmm.o  obj/libs/printfmt.o obj/libs/string.o
```

#### 1.3 Makefile源码简单分析

再简单分析一下makefile的源码。

makefile的规则，就是一个，即:

```makefle
target: prerequisits
	command
```

并有一些衍生技巧，和类似语法糖的东西。并有五种内容显式规则、隐晦规则、变量定义、文件指示和注释。

项目中的Makefile脚本主要使用了变量、函数、伪目标文件，利用了隐晦规则等等。有好多地方太过细节了，只做了大致了解，感觉可读性不好（尤其是变量，函数那里）。主要参考了这份[资料](<https://blog.csdn.net/ruglcc/article/details/7814546>)，可以跟着它读懂Makefile。由于make支持直接输出将要执行指令，分析编译过程更直接，所以不在此讨论Makefile中的逻辑了。

### 2. 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？ 

在`1.2`中对sign.c的源码分析可知，引导扇区为512字节，且最后两个字节为标志位`0x55 0xAA`。

## 练习二：使用qemu执行并调试lab1中的软件

> 吐槽：
>
> 1. 其实，lab1没有怎么用到调试。。看答案 + 瞎猜 ✅。
> 2. 我想在mac上做试验，就这么难喵？

###  1. 从第一条指令开始，单步跟踪BIOS的执行。

由于使用mac进行的实验，`make`脚本不兼容，不能直接调用`make debug`，因而查看实际执行的命令。

```shell
qemu-system-i386 -S -s -parallel stdio -hda bin/ucore.img -serial null &
sleep 2
gnome-terminal  -e "cgdb -q -x tools/gdbinit" # 在ubuntu上打开一个新的terminal，执行命令。
```

下面使用权宜的替代方法实验：开启两个terminal，分别执行以下命令。

```shell
# 额外的让qemu把执行的汇编输出到q.log
qemu-system-i386 -S -s -parallel stdio -hda bin/ucore.img -serial null -d in_asm -D q.log
# &
gdb -q -x tools/gdbinit
```

其中，`tools/gdbinit`被更改为：

```
file bin/kernel
set architecture i8086
target remote :1234
```

在`gdb`中使用`si`单步执行，`q.log`中输出为以下。

```asm
----------------
IN: 
0xfffffff0:  ea 5b e0 00 f0           ljmpw    $0xf000:$0xe05b  # 加电后跳转

----------------
IN: 
0x000fe05b:  2e 66 83 3e 08 61 00     cmpl     $0, %cs:0x6108  # 到了BIOS那儿

----------------
IN: 
0x000fe062:  0f 85 7a f0              jne      0xd0e0

----------------
IN: 
0x000fe066:  31 d2                    xorw     %dx, %dx

# ...
```

### 2. 在初始化位置0x7c00设置实地址断点,测试断点正常。

输入 `b *0x7c00`，设置实地址断点，`c`执行。并输出下面十句汇编。

```assembly
(gdb) x /10i $pc
=> 0x7c00:      cli
   0x7c01:      cld
   0x7c02:      xor    %eax,%eax
   0x7c04:      mov    %eax,%ds
   0x7c06:      mov    %eax,%es
   0x7c08:      mov    %eax,%ss
   0x7c0a:      in     $0x64,%al
   0x7c0c:      test   $0x2,%al
   0x7c0e:      jne    0x7c0a
   0x7c10:      mov    $0xd1,%al
(gdb) 
```

说明断点正常。

### 3. 反汇编代码与bootasm.S和 bootblock.asm进行比较。

#### 3.1 输出与`obj/bootblock.asm`

首先分析输出与`bootblock.asm`的关系。`bootblock.asm`中注明的地址范围为`7c00`至`7d80`，输出中搜索这两处地址，查看其间代码，发现除了指令名称稍有修改，其他是完全符合的。也可以发现，实际上只执行了部分的`bootmain`段的代码，就进行了跳转。

> 差别大概就是`mov` 和 `movl`的差别。【可以算是一个样子的】

#### 3.2 `obj/bootblock.asm` 与 `boot/bootasm.S`

因为`obj/bootblock.asm`就是由`boot/bootasm.S`与`boot/bootmain.c`生成的，所以前面这部分（`boot/bootasm.S`这块）就应该是一样的。的确就是一样的呀（除了一点点细节的差别）。

不过这里有个疑惑，虽然`boot/bootmain.c`中代码被编译成了汇编放入`obj/bootblock.asm`，不过仍能看见类似c函数的函数定义结构，并不清楚它们的作用。

```c
static void readseg(uintptr_t va, uint32_t count, uint32_t offset) {
... // 汇编代码
// 还没有括号 真的是没头脑/滑稽[可能是调试信息吧。。]
```

### 4. 自己找一个bootloader或内核中的代码位置，设置断点并进行测试。

想看看bootmain那里在做什么，所以设置了断点：`b *0x7d0f`。

虽然`bootblock.asm`里面写下一句要`    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);`，但实际上就是在按汇编指令顺序执行：（其实也应该如此，但是不知道readseg为什么要在这里写一次？？认为和上一问的疑惑有关。）

```
(gdb) si
0x00007d10 in ?? ()
(gdb) si
0x00007d12 in ?? ()
(gdb) si
0x00007d14 in ?? ()
(gdb) si
0x00007d19 in ?? ()
```

简单查了一下，这里应该在第四个练习讨论。所以之后再看。

> 后来看到，感觉就是把原来的c代码和对应的汇编放在一起了。。让人读着方便的。。但是没有查到相关的说明。。

实际执行的汇编就是这个：

```assembly
IN: 
0x00007d0f:  55                       pushl    %ebp

----------------
IN: 
0x00007d10:  31 c9                    xorl     %ecx, %ecx

----------------
IN: 
0x00007d12:  89 e5                    movl     %esp, %ebp

----------------
IN: 
0x00007d14:  ba 00 10 00 00           movl     $0x1000, %edx
```

> 另注，后来在`tools/gdbinit`中添加了下面的命令，使得每一次停止都自动输出下一条指令。gdb中看到的就不只是❓了，很方便。
>
> ```shell
> define hook-stop
> x/i $pc
> end
> ```

## 练习三：分析bootloader进入保护模式的过程。

> 吐槽：
>
> 1. 就是简单的了解一些硬件信息就好了。。

bootloader的第一任务是启用保护模式，并启用分段机制。其实就是分析`boot/bootasm.S`的作用。下面对这个文件进行注释。

> A20：为了向下兼容，模仿地址“回绕”特征，出现了A20 Gate，通过键盘控制器的一个输出与A20地址线控制一直进行与操作。为了不回卷（在实模式下访问高内存区，与保护模式），这个开关要打开。
>
> GDT：在保护模式下，为了更好地管理4G的可寻址（物理地址）空间，采用了分段存储管理机制，以支持存储共享、保护、虚拟存储等。每个段以起始地址和长度限制表示（它还包含一些属性，如粒度、类型、特权级、存在位、已访问位）。GDT是全局段描述符表，分段地址转换是需要访问它，取段基址。像是data segment，code segment，就是由此管理。
>
> > GDTR 为GDT特殊系统段
> >
> > 为什么GDT的第0项是空描述符：
> >
> > 一个任务使用的所有段都是系统全局的，它不需要用LDT来存储私有段信息，当系统切换到这种任务时，会将LDTR寄存器赋值成一个空（全局描述符）选择子，选择子的描述符索引值为0，TI指示位为0，RPL可以为任意值，用这种方式表明当前任务没有LDT。这里的空选择子因为TI为0，所以它实际上指向了GDT的第0项描述符。所以第0项需要时空的，而LDT就不需要。

```assembly
#include <asm.h>  # asm.h 包含许多的宏定义，包括常量和“函数”（应该是地址转换的函数）。

# Start the CPU: switch to 32-bit protected mode, jump into C.
# The BIOS loads this code from the first sector of the hard disk into
# memory at physical address 0x7c00 and starts executing in real mode
# with %cs=0 %ip=7c00.

# 内核代码段段地址[段选择器]
.set PROT_MODE_CSEG,        0x8                     # kernel code segment selector
# 内核Data段段地址[段选择器]
.set PROT_MODE_DSEG,        0x10                    # kernel data segment selector
# 保护模式的flag
.set CR0_PE_ON,             0x1                     # protected mode enable flag

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
# 在16位模式下，首先关闭中断
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    cld                                             # String operations increment
# 将段选择器置0
    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
# 启用A20
seta20.1:
# 等待键盘缓冲区为空，再给键盘发信号
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

# 向0x64端口发送指令，告诉它要写它的P2
    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2
# 在键盘不忙的时候（检查键盘的status register），写键盘的input buffer，将A20位置为高电平
    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    
    # lgdt -> 直接加载全局段描述符
    lgdt gdtdesc
    
    # 将cr0寄存器中PE对应位置位1，开启保护模式。然后去保护模式对应代码处。
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    # 初始化每个段寄存器。但不知道为何都用data segment地址初始化？
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    # 栈指针初始化为$0x7c00，并进入bootmain。
    movl $0x0, %ebp
    movl $start, %esp
    call bootmain

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin

# Bootstrap GDT
.p2align 2                                          # force 4 byte alignment
gdt:
	# 空段描述符，原因前面解释了。
    SEG_NULLASM                                     # null seg
    # 放bootloader，kernel 的 code seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    # 放bootloader，kernel 的 data seg
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel

gdtdesc:  # gdt的描述符：长度与起始位置
    .word 0x17                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt

```

疑惑：

- [ ] 保护模式下段寄存器的初始化

> 另有一些硬件细节被暂时忽略了，就看了和做作业有关的部分。。用到了会再看。。

## 练习四：分析bootloader加载elf格式os的过程。

> 吐槽：
>
> 1. 要记得东西太多了，记不住了，可能会在报告的时候都忘掉QAQ。
> 2. 这个练习，就是看硬盘的文档，理解段的存储形式。

概念说明：

* IDE即“电子集成[驱动器](https://baike.baidu.com/item/%E9%A9%B1%E5%8A%A8%E5%99%A8)”，它的本意是指把“[硬盘控制器](https://baike.baidu.com/item/%E7%A1%AC%E7%9B%98%E6%8E%A7%E5%88%B6%E5%99%A8/3781789)”与“盘体”集成在一起的[硬盘驱动器](https://baike.baidu.com/item/%E7%A1%AC%E7%9B%98%E9%A9%B1%E5%8A%A8%E5%99%A8/213766)。

### 1. bootloader读取硬盘扇区

硬盘的访问，要看这几个让人没头脑的函数。要参考硬盘I/O的那些参数和相关函数。

```c
// waitdisk()
// 0x1f7是硬盘的状态与命令寄存器，检查它是否在忙碌状态。
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
        /* do nothing */;
}

/* readsect - read a single sector at @secno into @dst */
// readsect(dst, secno) 
// 将第secno扇区放到dst内存处
static void
readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();
	
	//0x1f2控制读写的扇区数，设置为1
    outb(0x1F2, 1);                         // count = 1
    //在LBA模式下 0x1f3 - 0x1f6为LBA参数
    //其中0x1f6只有前四位有效，第4位控制主盘or从盘
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    //给读取目标扇区的命令
    outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    // 从0x1f0端口读取SECTSIZE字节数到dst的位置,每次读四个字节，读取 SECTSIZE/ 4次。
    // 不记得为什么是
    // void insl(unsigned short int port, void *addr, unsigned long int count)
    insl(0x1F0, dst, SECTSIZE / 4);
}

/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked. 从kernel的offset处读取count byte到va
 * */
 // 只是对readseg进行了封装，可以读取指定范围的数据至内存。
 // 不过，会被以扇区为单位读进去，被“round off”
 // va是virtual addr
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
	//找到要读的“终点”[最后会将end_va所在的一个扇区大小都占满]
	uintptr_t end_va = va + count;

    // round down to sector boundary
    // 找到真正的起点
    va -= offset % SECTSIZE;

    // translate from bytes to sectors; kernel starts at sector 1
    // 找到要读的扇区起点，从sector 1开始(因为0被占用了)。
    // 而传进来的offset是相对于相对于elfhdr（文件头）的地址
    uint32_t secno = (offset / SECTSIZE) + 1;

    // 依次将对应扇区的内容读入至缓存。va >= end_va时，就是读完了。
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}
```

### 2. bootloader是如何加载ELF格式的OS？

此时只关注`bootmain`函数，我为它添加了注释。

```CQL
/* bootmain - the entry of bootloader */
void
bootmain(void) {
    // read the 1st page off disk
    // 抓取elfhdr，用于判断镜像的信息
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    // header结构体中有 magic这个属性，判断它是不是等于ELF_MAGIC以确定它的格式
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;  //不是则出错
    }

	//操作系统中的信息不是一个结构体就能搞定的；其中不同的段需要载入不同的地方。
	//header中存了program header表的指针，program header就是用来描述这些子program的“descriptor”
    struct proghdr *ph, *eph;
	
    // load each program segment (ignores ph flags)
    //加载programheader表的起点，并依次遍历到终点
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    
    //每一个都按照相应的需求载入内存：相对文件头的偏移，占用字节数，和起始地址(已经是虚拟地址了！！)。
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    // 载入全部完成，根据elfheader中entry，找到内核入口，过去执行，bootloader的使命完成。
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}
```

## 练习五：实现函数调用堆栈跟踪函数

> 吐槽：就是看函数调用栈结构。再加上答案代码，直接就能写出来啦。。

以以下方式实现。

```c
void
print_stackframe(void) {
	// ebp即为基指针（该指针永远指向系统栈最上面一个栈帧的底部），通过它可以一层一层的找到栈中各函数的调用信息
	// eip是下一步代码执行的位置
	// 现在它们被初始化。
         uint32_t ebp = read_ebp();
         uint32_t eip = read_eip();

         for(int i=0; i<STACKFRAME_DEPTH; i++) {
            /*按照16进制输出，补齐8位的宽度，补齐位为0，默认右对齐*/
            cprintf("ebp:0x%08x ", ebp);
            cprintf("eip:0x%08x ", eip);
            
			// 找到该函数的参数的起点，并强制转换为（4 bytes）指针形式
            uint32_t *args = (uint32_t *)ebp + 2;  // 所以只需要加2，ebp + 1 为返回地址
            // 输出连续的四个int空间的参数
            for(int j=0;j<4;j++) {
                cprintf("args[%d]:0x%08x ", j, args[j]);
            }
            
            cprintf("\n");   
            // 根据输出eip输出函数的debug信息，如调用到什么函数的第几行，函数名等
            // 因为eip总是存的下一执行语句的位置，所以要减掉1（这里的1，就是1byte，应该是因为call函数就是1byte），所以找到了被调用的函数的入口地址
            // 这里就需要看 debuginfo_eip() 等的函数了，但是看着头疼，不看了。
            print_debuginfo(eip - 1);
			
			// 去找下一层
            eip = ((uint32_t *)ebp)[1];
            ebp = ((uint32_t *)ebp)[0];
         }
}
```

这张示意图比较重要：

```
+|  栈底方向        | 高位地址
 |    ...        |
 |    ...        |
 |  参数3        |
 |  参数2        |
 |  参数1        |  [ebp] + 8 
 |  返回地址        | [ebp] + 4 -> 入栈前的eip
 |  上一层[ebp]    | <-------- [ebp]
 |  局部变量        |  低位地址
```

输出是对的，可以发现ebp每次高16的地址，当然并不知道原因。参数数量取4取多了。

```
ebp:0x00007b28 eip:0x00100980 args[0]:0x00010074 args[1]:0x00010074 args[2]:0x00007b58 args[3]:0x0010008e 
    kern/debug/kdebug.c:306: print_stackframe+21
ebp:0x00007b38 eip:0x00100c78 args[0]:0x00000000 args[1]:0x00000000 args[2]:0x00000000 args[3]:0x00007ba8 
    kern/debug/kmonitor.c:125: mon_backtrace+10
ebp:0x00007b58 eip:0x0010008e args[0]:0x00000000 args[1]:0x00007b80 args[2]:0xffff0000 args[3]:0x00007b84 
    kern/init/init.c:48: grade_backtrace2+33
ebp:0x00007b78 eip:0x001000b8 args[0]:0x00000000 args[1]:0xffff0000 args[2]:0x00007ba4 args[3]:0x00000029 
    kern/init/init.c:53: grade_backtrace1+38
ebp:0x00007b98 eip:0x001000d7 args[0]:0x00000000 args[1]:0x00100000 args[2]:0xffff0000 args[3]:0x0000001d 
    kern/init/init.c:58: grade_backtrace0+23
ebp:0x00007bb8 eip:0x001000fd args[0]:0x001032fc args[1]:0x001032e0 args[2]:0x0000130a args[3]:0x00000000 
    kern/init/init.c:63: grade_backtrace+34
ebp:0x00007be8 eip:0x00100051 args[0]:0x00000000 args[1]:0x00000000 args[2]:0x00000000 args[3]:0x00007c4f 
    kern/init/init.c:28: kern_init+80
ebp:0x00007bf8 eip:0x00007d70 args[0]:0xc031fcfa args[1]:0xc08ed88e args[2]:0x64e4d08e args[3]:0xfa7502a8 
    <unknow>: -- 0x00007d6f --
ebp:0x00000000 eip:0x00007c4f args[0]:0xf000e2c3 args[1]:0xf000ff53 args[2]:0xf000ff53 args[3]:0xf000ff54 
    <unknow>: -- 0x00007c4e --
ebp:0xf000ff53 eip:0xf000ff53 args[0]:0x00000000 args[1]:0x00000000 args[2]:0x00000000 args[3]:0x00000000 
    <unknow>: -- 0xf000ff52 --
ebp:0x00000000 eip:0x00000000 args[0]:0xf000e2c3 args[1]:0xf000ff53 args[2]:0xf000ff53 args[3]:0xf000ff54 
    <unknow>: -- 0xffffffff --
ebp:0xf000ff53 eip:0xf000ff53 args[0]:0x00000000 args[1]:0x00000000 args[2]:0x00000000 args[3]:0x00000000 
    <unknow>: -- 0xf000ff52 --
ebp:0x00000000 eip:0x00000000 args[0]:0xf000e2c3 args[1]:0xf000ff53 args[2]:0xf000ff53 args[3]:0xf000ff54 
    <unknow>: -- 0xffffffff --
ebp:0xf000ff53 eip:0xf000ff53 args[0]:0x00000000 args[1]:0x00000000 args[2]:0x00000000 args[3]:0x00000000 
    <unknow>: -- 0xf000ff52 --
ebp:0x00000000 eip:0x00000000 args[0]:0xf000e2c3 args[1]:0xf000ff53 args[2]:0xf000ff53 args[3]:0xf000ff54 
    <unknow>: -- 0xffffffff --
ebp:0xf000ff53 eip:0xf000ff53 args[0]:0x00000000 args[1]:0x00000000 args[2]:0x00000000 args[3]:0x00000000 
    <unknow>: -- 0xf000ff52 --
ebp:0x00000000 eip:0x00000000 args[0]:0xf000e2c3 args[1]:0xf000ff53 args[2]:0xf000ff53 args[3]:0xf000ff54 
    <unknow>: -- 0xffffffff --
ebp:0xf000ff53 eip:0xf000ff53 args[0]:0x00000000 args[1]:0x00000000 args[2]:0x00000000 args[3]:0x00000000 
    <unknow>: -- 0xf000ff52 --
ebp:0x00000000 eip:0x00000000 args[0]:0xf000e2c3 args[1]:0xf000ff53 args[2]:0xf000ff53 args[3]:0xf000ff54 
    <unknow>: -- 0xffffffff --
ebp:0xf000ff53 eip:0xf000ff53 args[0]:0x00000000 args[1]:0x00000000 args[2]:0x00000000 args[3]:0x00000000 
    <unknow>: -- 0xf000ff52 --
```

## 练习六：完善中断初始化和处理

> 吐槽：
>
> 1. 这个还是要用一些脑汁的TwT，需要用心看每个有关系的c文件，理解里面的代码含义。
> 2. 看这些文件最大的难点就是，不理解函数的命名潜规则，要熟悉才好。

### 1. 中断向量表

> 问题一：中断描述符表中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

一个表项占8个字节，其中0-1两个字节表示段长度限制（IDT limit），2-7字节是基址（IDT Base Address）。2-3是段地址，0-1 + 6-7共同拼成位移。

> 为啥搞这么乱QAQ

```c
// 变量声明 加冒号的意义是指出"位域长度"。
/* Gate descriptors for interrupts and traps */
struct gatedesc {
    unsigned gd_off_15_0 : 16;        // low 16 bits of offset in segment
    unsigned gd_ss : 16;            // segment selector [段地址]
    unsigned gd_args : 5;            // # args, 0 for interrupt/trap gates
    unsigned gd_rsv1 : 3;            // reserved(should be zero I guess)
    unsigned gd_type : 4;            // type(STS_{TG,IG32,TG32})
    unsigned gd_s : 1;                // must be 0 (system)
    unsigned gd_dpl : 2;            // descriptor(meaning new) privilege level
    unsigned gd_p : 1;                // Present
    unsigned gd_off_31_16 : 16;        // high bits of offset in segment
};
```

> * Interrupt-gate descriptor （中断方式用到）
>
> - Trap-gate descriptor（系统调用用到）

### 2. 完善`trap.c`中`idt_init()`

这一段有一点点乱。`tools/vector.c`笨拙的生成了`vector.S`，可以直接通过extern使用。（因为它被设置为全局变量`.global`）。然后取查`SETGATE`的参数含义，在`memlayout.h`中，定义了全局描述符的宏，也就是我们的第三个参数。至于为什么是`TEXT`，不知道，但是看起来就不像`DATA`。第五个参数是因为还在kernel模式下。别的参数就照着填。

> trapframe是在栈中描述当前被打断程序的数据结构。

`lidt()`要求传入这个指针，所以直接根据注释提示写上。

```c
void
idt_init(void) {
     extern uintptr_t __vectors[];
     for (int i = 0; i < 256; ++i)
     {
/**
 *  #define SETGATE(gate, istrap, sel, off, dpl)
 * Set up a normal interrupt/trap gate descriptor
 *   - istrap: 1 for a trap (= exception) gate, 0 for an interrupt gate
 *   - sel: Code segment selector for interrupt/trap handler
 *   - off: Offset in code segment for interrupt/trap handler
 *   - dpl: Descriptor Privilege Level - the privilege level required
 *          for software to invoke this interrupt/trap gate explicitly
 *          using an int instruction.
 * */
         SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
     }
     
 /**
     static inline void
    lidt(struct pseudodesc *pd) { // 要求传入pseudodesc的指针
        asm volatile ("lidt (%0)" :: "r" (pd));
    }
 */
 // 初始化ldt
     lidt(&idt_pd);
}
```

### 3. 完善`trap.c`中`trap()`的时钟中断处理

实际上对于中断信号的处理被转交到`trap_dispatch()`. 在对应分支加上下面这段。其中`ticks`是在`clock.c`中定义的，中断频率`frequency`也可以在这设置。

```c
...
ticks ++;
if (ticks % TICK_NUM == 0) {
    print_ticks();
}
```

此时执行`make qemu`。时钟中断与键盘中断都被成功展示。

```
++ setup timer interrupts
100 ticks
100 ticks
100 ticks
kbd [105] i
...
```

此时把`init.c`中的challenge开启，这个时候`make grade`已经可以得到三十分了。

```c
//LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
// user/kernel mode switch test
    lab1_switch_test();
```

```
(base) mbp-lxy:lab1 lxy$ make grade
Check Output:            (3.0s)
  -check ring 0:                             OK
  -check switch to ring 3:                   WRONG
   -e !! error: missing '1: @ring 3'
   !! error: missing '1:  cs = 1b'
   !! error: missing '1:  ds = 23'
   !! error: missing '1:  es = 23'
   !! error: missing '1:  ss = 23'

  -check switch to ring 0:                   OK
  -check ticks:                              OK
Total Score: 30/40
make: *** [grade] Error 1
```

#### 附：不初始化ldt时操作系统直接退出的问题
>
> 疑惑：为什么不初始化ldt时，操作系统会直接退出呢，没有搜索到是在哪里做的检查
>
> > 好像是，intr_enable()函数的原因，里面，它调用了`sti`，即启用中断，可能是启用的时候中断向量表没有搞好，操作系统就崩掉了。
>
>嵌入asm时，volatile表示` the instruction has important side-effects.`gcc 就不会对它做更多操作。[here](<https://stackoverflow.com/questions/14449141/the-difference-between-asm-asm-volatile-and-clobbering-memory>).

## Challenge 

### 1. 用户态与核模式的相互切换

> 吐槽：认真看文档TwT

用户态与与核模式见的相互切换，主要见于系统调用，即 system call。用户应用程序调用内核的接口，以完成如I/O的任务。system call 被认为是需主动调用的中断例程。

要完成的两个中断，就是用户态与核模式的相互切换。相互切换主要经过以下步骤：

* 栈切换。
* 保存EFLAGS，代码段选择器和EIP被保存，堆栈段选择器和堆栈指针被保存。
* 开始执行中断处理程序。
* 通用寄存器被保存(处理程序的工作)，更改段选择器。
* 离开中断，应该已经有新的栈指针啦（没有被“还原”为中断之前值）。

ucore中优先级有两种（0（内核态）和3（用户态））。

跟权限直接相关的寄存器有RPL（请求特权级，Requested Privilege Level（in data segment selector）），CPL（当前特权级，current privilege level，in cs reg），DPL（描述符特权级，Descriptor Privilege Level）。需要RPL 与 CPL 都比 DPL小，权限才被允许。

观察代码可以发现，中断向量最终全部调用`trapentry.S`中的`__alltraps`，我分析一下在这里都做了什么。

```assembly
# i'm trapentry.S
#include <memlayout.h>

# vectors.S sends all traps here.
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    # 保存16位寄存器。
    # 注意 pushl，入栈32位，多余的16位是"padding"
    pushl %ds
    pushl %es
    pushl %fs
    pushl %gs
    # 保存eflags，和32位寄存器
    pushal 
    # 以上，这些寄存器按顺序入栈，正好看起来和trapframe一样。

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    # GD_KDATA是kernel data segment的描述符，将它存入ds(data segment)和es(附加段寄存器)
    movl $GD_KDATA, %eax
    movw %ax, %ds
    movw %ax, %es

	# trap需要一个trapframe的指针作为参数，这里把指针地址传进来。后面继续看了一下trapframe的结构，可以发现它各个属性的顺序设计就是按照以上的入栈顺序。
    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp

	# 调用trap函数，完全交给软件
    # call trap(tf), where tf=%esp
    call trap

	# 将入栈的stack pointer，用户栈指针pop出来
    # pop the pushed stack pointer
    popl %esp

	# 通过trapret，中断返回
    # return falls through to trapret...
.globl __trapret
__trapret:
	# 按照开始入栈顺序恢复现场
    # restore registers from stack
    popal

    # restore %ds, %es, %fs and %gs
    popl %gs
    popl %fs
    popl %es
    popl %ds

	# 观看trapframe的结构可知，硬件在调用__alltraps前将trap number与error code入栈了，这个时候要去掉，因为中断已经完美结束了。
	# trap
    # get rid of the trap number and error code
    addl $0x8, %esp
    iret
```

下面是trapframe的结构：

```c
// 可以看见，在trapentry.S中的__alltraps就是按这个顺序的入栈的！！
struct trapframe {
    struct pushregs tf_regs;
    uint16_t tf_gs; 
    uint16_t tf_padding0;
    uint16_t tf_fs;
    uint16_t tf_padding1;
    uint16_t tf_es;
    uint16_t tf_padding2;
    uint16_t tf_ds;
    uint16_t tf_padding3;
    uint32_t tf_trapno;
    /* below here defined by x86 hardware */
    uint32_t tf_err;
    uintptr_t tf_eip;
    uint16_t tf_cs;
    uint16_t tf_padding4;
    uint32_t tf_eflags;
    /* below here only when crossing rings, such as from user to kernel */
    uintptr_t tf_esp;
    uint16_t tf_ss;
    uint16_t tf_padding5;
} __attribute__((packed));
// 还可以看到pushal push 的寄存器，它们没有在trapframe中，所以tf中下面那些东西，都应该是操作系统调用中断时入栈的 TODO
/* registers as pushed by pushal */
struct pushregs {
    uint32_t reg_edi;
    uint32_t reg_esi;
    uint32_t reg_ebp;
    uint32_t reg_oesp;            /* Useless */
    uint32_t reg_ebx;
    uint32_t reg_edx;
    uint32_t reg_ecx;
    uint32_t reg_eax;
};
```

中断中，我们需要做的就是把cs，ss都变成希望转换到的模式的基地址！再改一下控制位`EFLAGs`，更改IO的权限（似乎否则就不能在user状态输出？就无法通过make grade了）。

```c
case T_SWITCH_TOU:
        // cprintf("to user mode?");
        if (tf->tf_cs != USER_CS) { //要保证自己再对应的模式中
            tf->tf_cs = USER_CS;
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
            tf->tf_eflags |= FL_IOPL_MASK;
            print_trapframe(tf);
        }
        break;
    case T_SWITCH_TOK:
        // cprintf("to kernel mode?");
        if (tf->tf_cs != KERNEL_CS) {
            tf->tf_cs = KERNEL_CS;
            tf->tf_ds = tf->tf_es = KERNEL_DS;
            tf->tf_eflags &= ~FL_IOPL_MASK;
        }
        break;
```

以及在ldt初始化的时候，更改“转到kernel中断”的DPL为user，否则User就执行不了它了，只能kernel转kernel（滑稽）。

```c
void
idt_init(void) {
	//...
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
	//...
}
```

最终在`/kern/init/init.c`中加入主动调用system call的汇编代码。

```c
static void
lab1_switch_to_user(void) {
    //LAB1 CHALLENGE 1 : 
     asm volatile (
	    "sub $0x8, %%esp \n"  // 这里为什么要减8？为什么要"movl %%ebp, %%esp"？下面分解。
	    "int %0 \n" //%0 为 T_SWITCH_TOU 参数
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}

static void
lab1_switch_to_kernel(void) {
    // 引发对应的中断（T_SWITCH_TOK）
    asm volatile ( 
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        : 
        : "i"(T_SWITCH_TOK)
    );
}
```

上面的代码还有两个地方要解释，都是跟收到中断时的一些默认操作有关。

1. 为何（只）切换到user mode前要将esp减8？
2. 切换回来为什么要`movl %ebp, esp`？

> 原因？就是这个中断太讨厌了，一般操作一个中断，硬件的设计是默认调用中断前后特权级是相同的，它对栈的转换操作就不会出问题。而实验要求正好要违背它，所以要反其道而行。[reference1](<https://chyyuu.gitbooks.io/ucore_os_docs/content/lab1/lab1_3_3_2_interrupt_exception.html>)，[reference2](<https://howardlau.me/university/ucore/ucore-os-lab-1.html>)，[reference3](<https://www.cnblogs.com/xxrxxr/p/9527344.html>)。

在用户态切换到内核态，由于要求转变至高权限，会发生栈切换，原来的ss，esp都被入栈，ss段自动被切换至内核的段选择子。而在中断返回时，由于特权级别已经为内核态，所以不会出栈ss，esp，所以不需要对此步骤调整。

在高优先级转换到低优先级时，iret还会把入栈的ss，esp出栈（其实根本没有入过栈！）！所以在转换到用户态时，需要多留出8bytes，以保证正常的还原。

所以我们的sp究竟用什么赋值呢，调用中断后的帧基址就是此时的栈顶呀。（应该是这个意思吧）

> 希望我理解的是对的QAQ

此时`make grade`已经是40分啦！

```shell
(base) mbp-lxy:lab1 lxy$ make grade
Check Output:            (2.0s)
  -check ring 0:                             OK
  -check switch to ring 3:                   OK
  -check switch to ring 0:                   OK
  -check ticks:                              OK
Total Score: 40/40
```

### 2. 基于键盘中断的内核态切换

实现方式，直接在键盘中断处增加对输入字符的检查即可。模式切换直接赋值Challenge1中代码即可。

```c
case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
        if (c == '0')
        {
            if (tf->tf_cs != KERNEL_CS) {
                tf->tf_cs = KERNEL_CS;
                tf->tf_ds = tf->tf_es = KERNEL_DS;
                tf->tf_eflags &= ~FL_IOPL_MASK;
                cprintf("--------switching to kernel mode--------");
                print_trapframe(tf);// 输出此时trapframe的具体信息
            }// to kernel mode
        }
        if (c == '3')
        {
            if (tf->tf_cs != USER_CS) {
                tf->tf_cs = USER_CS;
                tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
                tf->tf_eflags |= FL_IOPL_MASK;
                cprintf("--------switching to user mode--------");
                print_trapframe(tf);// 输出此时trapframe的具体信息
            }  // to user mode
        }
        cprintf("kbd [%03d] %c\n", c, c);
        break;
```

根据makefile中的相应检查可知，用户态与核模式的检查标准如下。

```shell
quick_check 'check switch to ring 3'							\
	'+++ switch to  user  mode +++'								\
	'1: @ring 3'												\
	'1:  cs = 1b'												\
	'1:  ds = 23'												\
	'1:  es = 23'												\
	'1:  ss = 23'

quick_check 'check switch to ring 0'							\
	'+++ switch to kernel mode +++'								\
	'2: @ring 0'												\
	'2:  cs = 8'												\
	'2:  ds = 10'												\
	'2:  es = 10'												\
	'2:  ss = 10'
```

实际输出为以下，相应寄存器与检查标准相同，可知测试正确。

```c
--------switching to kernel mode--------trapframe at 0x110cd4
  edi  0x00000000
  esi  0x00010074
  ebp  0x00007be8
  oesp 0x00110cf4
  ebx  0x00010074
  edx  0x00103687
  ecx  0x00000000
  eax  0x00000003
  ds   0x----0010
  es   0x----0010
  fs   0x----0023
  gs   0x----0023
  trap 0x00000021 Hardware Interrupt
  err  0x00000000
  eip  0x0010006f
  cs   0x----0008
  flag 0x00000206 PF,IF,IOPL=0
  
  --------switching to user mode--------trapframe at 0x7b7c
  edi  0x00000000
  esi  0x00010074
  ebp  0x00007be8
  oesp 0x00007b9c
  ebx  0x00010074
  edx  0x00103687
  ecx  0x00000000
  eax  0x00000003
  ds   0x----0023
  es   0x----0023
  fs   0x----0023
  gs   0x----0023
  trap 0x00000021 Hardware Interrupt
  err  0x00000000
  eip  0x0010006f
  cs   0x----001b
  flag 0x00003206 PF,IF,IOPL=3
  esp  0x0010363c
  ss   0x----0023
```

***

## 结语

> 撒花。

做了很久很久，用了得20个小时吧。在没有背景知识下，没头脑的乱做，很耽误时间费精力。（递归学习QAQ）。很多地方参考了答案代码，但力求自己理解其中每一个语句，并以自己的方式实现。

应该先做的事：

1. 看对应内容的慕课（清华大学的那个就好）

2. 对每个练习所涉及的知识，认真看它的文档。（基本上所有的都是有用的QAQ，尤其是challenge部分）

先这个样子叭。

## CHANGELOG

20190926 晚 23:46 更新lab1完整版

20191007 玩 23:36 update 【为什么我要上午去交作业TwT。学姐一定会给我过得叭/滑稽】