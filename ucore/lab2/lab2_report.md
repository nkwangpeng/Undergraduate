# lab2 内存管理
[TOC]
## 踩坑`&`遇到的问题
### 问题零
由于以前直接`merge`踩过巨⼤的坑所以选择了⼿动`merge`，但是由于没仔细看`init.c`所以没有`lab1`练习六输出的时候感觉很奇怪就下了`meld`查看对⽐，发现好像并没有出错，于是找了半天原因，直到想起来去看⼀眼`init.c`才发现`idt_init`执⾏是在`pmm_init`之后的，⽽`pmm`并没有完成所以肯定不会有结果。其实也算不上坑，应该算是⻓了⼀个教训，应该完整看完实验内容不然东墙补完补⻄墙是不能⻓久的，以后应该再深⼊研究⼀下`diff merge`这些优秀的⼯具，毕竟⼿动出错概率⾼
### 问题一
执行make报错： `'for' loop initial declaration are only allowed in C99 mode。`
![](./images/3.png)
是因为在`gcc`中直接在`for`循环中初始化了增量：
把
```cpp
for(int i=0;i<len;i++)
...
```
改为
```cpp
int i;
for(i=0;i<len;i++)
...
```
### 问题二
练习⼆和三⼀头雾⽔，可能跟理论课还没有将相关内容以及计组全忘了有关，所以着重看了实验指导书附录内容和`mooc6.3-4`以及`8.4-6`，再根据`get_pte`和`page_remove_pte`的执⾏顺序以及相关注释逐句翻译注释并理解程序这么去写的意图就会理解的很好(但其实`get_pte`都没看懂是在⼲嘛，参考了各种Github⼤佬的报告以及好多遍的MOOC才get到，不过也跟我提前写了这次作业有关(内存什么的还没怎么讲))现在好了，讲完了再看好像就没那么难了。

### 问题三
最终`make grade`已经是50分啦，但是`make qemu`却报错`EOT:kernel seems OK`
![](./images/2.png)
最终解决方式是修改`trap.c`中的`print_ticks()`函数，修改为：
```cpp
ticks++;//TICK_NUM在开头被定义为100
if(ticks%TICK_NUM==0)
{
    print_ticks();
}
break;
```
### 问题四
* 在写`Buddy System`的时候引用头文件`stdlib`时报错：`stdlib.h: No such file or directory`，查看了`/usr/include`下面的文件，`stdlib.h`是存在的，并且它上面的`stdio.h`就能正常使用，网上提到的方法都试过了，都没起作用，所以我也不清楚这是什么原因。最终换了另一种方法写的`Buddy System`
![](./images/6.png)

### 问题五
* 写完所有函数之后执行`make qemu`，发现`default_free_pages`函数中的`PageReserved(base)`判断语句报错：
![](./images/7.png)

查看`PageReserved(base)`相关的定义：
```cpp
#define PG_reserved 0// if this bit=1: the Page is reserved for kernel, cannot be used
in alloc/free_pages; otherwise, this bit=0
#define PageReserved(page) test_bit(PG_reserved, &((page)->flags))
#define SetPageReserved(page) set_bit(PG_reserved, &((page)->flags))
```
**`SetPageReserved`把物理地址对应的`Page`结构中的`flags`标志设置为`PG_reserved`，表示这些页已经被使用了，将来不能被用于分配。**
* 数据类型写错了，`list_entry_t` 和 `Page` 写混了，导致`make`时有`warning`，但当时忽略了，导致后来的错误。
* 混淆了`list_entry_t`的意义，链表的每一个元素中包含的是一个块，而不是一个页，最开始迷迷糊糊的，没有真正弄清这一点，导致`default_init_memmap`、`default_alloc_pages`、`default_free_pages`全都写错了，虽然觉得哪里不太对，但是`make qemu`和`make grade`时居然完全没报出任何问题，所以就没在意……是在最后在对比答案时，才发现自己理解错了。

***
## 练习零：补充lab1

由于lab1没有entry.S建栈（设置了栈的范围），做一些检查，在`printstackframe()`函数中可以不设置递归终点`ebp!=0`。但是lab2设置了，所以`qemu`会死掉。所以要调整好这里。
用`meld`进行代码合并很方便😏。修改的文件有：`kern/init/init.c`、`kern/trap/trap.c`、`kern/debug/kdebug.c`。`lab2`相比于`lab1`两个方面的扩展。首先，`bootloader`的工作有增加，在`bootloader`中，完成了对物理内存资源的探测工作，让`ucore kernel`在后续执行中能够基于`bootloader`探测出的物理内存情况进行物理内存管理初始化工作。其次，`bootloader`不像`lab1`那样，直接调用`kern_init`函数，而是先调用位于`lab2/kern/init/entry.S`中的`kern_entry`函数。`kern_entry`函数的主要任务是为执行`kern_init`建立一个良好的C语言运行环境（设置堆栈），而且临时建立了一个段映射关系，为之后建立分页机制的过程做一个准备（细节在3.5小节有进一步阐述）。完成这些工作后，才调用`kern_init`函数。

## 练习一：first-fit 物理内存管理

### 初始化双向链表
**了解`list.h`中的`list_entry`结构并且会使用相关函数**
```c
//list.h
struct list_entry {//⼀个简单的双链表
 struct list_entry *prev, *next;//两个指针⽗⼦节点
};
typedef struct list_entry list_entry_t;//重命名
list_init() //初始化⼀个新的list_entry
list_add(),list_add_after(),list_add_after()//添加⼀个新的表项
list_del()//从表中删除⼀个表项
list_del_init()//从表中删除并重定义⼀个表项
list_empty()//判断链表是否为空
list_next()list_prev()//获取链表的前⼀项和后⼀项
```
**`default_init()`** :创建一个空的双向链表，初始化空闲列表free_list，将空闲内存块的总数nr_free置0，已经实现好了，不用再修改。

```c
static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}
```

**`default_init_memmap`** :⾸先初始化每个在memelayout.h中定义的page(物理⻚)，将全部的可分配物理⻚视为⼀⼤块空闲块加⼊空闲表。

```c
/**
 * 初始化时使用。
 * 探测到一个基址为base，大小为n 的空间，将它加入list（开始时做一点检查）
 */
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    nr_free += n;
    // 按地址序，依次往后排列。因为是双向链表，所以头指针前一个就是最后一个。
    // 只改了这一句。
    list_add_before(&free_list, &(base->page_link)); 
}
```

### `allocate`分配页

就是找到第一个足够大的页，然后分配它。主要是`free`时，没有保证顺序，所以分配时也是乱序的。这一段只需要改：拆分时小块的插入位置，就插在拆分前处，而不是在list最后即可。

```cpp
// 可以发现，现在的分配方法中list是无序的，就是根据释放时序。
// 取的时候，直接去找第一个可行的。
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);
    // 要的页数比剩余free的页数都多，return null
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    // 找了一圈后退出 TODO: list有空的头结点吗？有吧。
    while ((le = list_next(le)) != &free_list) {
        // 找到这个节点所在的基于Page的变量
        // 这里的page_link就是成员变量的名字，之后会变成宏。。看起来像是一个变量一样，其实不是。
        // ((type *)((char *)(ptr) - offsetof(type, member)))
        // #define offsetof(type, member)
        // ((size_t)(&((type *)0)->member))
        // le2page, 找到这个le所在page结构体的头指针，其中这个le是page变量的page_link成员变量
        struct Page *p = le2page(le, page_link);
        // 找到了一个满足的，就把这个空间（的首页）拿出来
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    //如果找到了可行区域
    if (page != NULL) {
        // 这个可行区域的空间大于需求空间，拆分，将剩下的一段放到list中【free+list的后面一个】
        if (page->property > n) {
            struct Page *p = page + n;
            p->property = page->property - n;
            SetPageProperty(p);
            // 加入后来的，p
            list_add_after(&(page->page_link), &(p->page_link));
            // list_add(&free_list, &(p->page_link));
        }
        // 删除原来的
        list_del(&(page->page_link));
        // 更新空余空间的状态
        nr_free -= n;
        //page被使用了，所以把它的属性clear掉
        ClearPageProperty(page);
    }
    // 返回page
    return page;
}
```

### `free_pages`释放页

未修改前，可以发现算法是，从头找到尾部，找到是否有被free的块紧邻的块。而first fit算法是有序的，只需找到它的前后即可，然后合并放入对应位置。该函数重新将⻚链接到`free list`(相邻的合并)，也可以是将⼩的空块合并到⼤块中。
**优化前：**
```c
//在完整的list中找有没有恰好紧贴在这个块前面 或 后面的，如果有，贴一起。
// 最多做两次合并，因为list中的块是已经合并好的了，新加一块最多缝合一个缝隙
default_free_pages(struct Page *base, size_t n){
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
        p = le2page(le, page_link);
        le = list_next(le);
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
        else if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
    // 将新块加如list
    // list_add(&free_list, &(base->page_link));
    le = list_next(&free_list);
    while (le != &free_list) {
        p = le2page(le, page_link);
        if (base + base->property <= p) {
            assert(base + base->property != p);
            break;
        }
        le = list_next(le);
    }
    list_add_before(le, &(base->page_link));
}
```

**优化后：**
```c++
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    // 先更改被释放的这几页的标记位
    for (; p != base + n; p ++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    // 将这几块视为一个连续的内存空间
    base->property = n;
    SetPageProperty(base);

    list_entry_t *next_entry = list_next(&free_list);
    // 找到base的前一块空块的后一块
    while (next_entry != &free_list && le2page(next_entry, page_link) < base)
        next_entry = list_next(next_entry);
    // 找到前面那块
    list_entry_t *prev_entry = list_prev(next_entry);
    // 找到insert的位置
    list_entry_t *insert_entry = prev_entry;
    // 如果和前一块挨在一起，就和前一块合并
    if (prev_entry != &free_list) {
        p = le2page(prev_entry, page_link);
        if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            base = p;
            insert_entry = list_prev(prev_entry);
            list_del(prev_entry);
        }
    }
	// 后一块
    if (next_entry != &free_list) {
        p = le2page(next_entry, page_link);
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(next_entry);
        }
    }
    // 加一下
    nr_free += n;
    list_add(insert_entry, &(base->page_link));
}
```

### 回答问题

优化后的代码已经对`free`过程查找前后紧邻块做了优化。

如果对于每个空闲快，信息相同的保存在首与尾，那么在释放一个快时，就可以检查前一个page和后一个page是否是空闲的。如果前一个是空闲的，修改前一块的ref，然后直接把本块信息清除即可；如果后一块是空闲的，把后一块的首page、末page清除，并相应调整块大小。此时`free`操作时常数时间。如果都不是，则需要用线性时间找到对应位置，插入块。

### 测试结果

```shell
make qemu
输出
...
check_alloc_page() succeeded!
...
但是make grade还是0分。
```

## 练习二：实现寻找虚拟地址对应的页表项
阅读注释中给的宏定义
```c++
//宏 OR 函数
PDX(la) // 返回虚拟地址la的⻚⽬录索引 /kern/mm/mmu.h
KADDR(pa) //返回物理地址pa对应的虚拟地址 /kern/mm/pmm.h
set_page_ref(page,1) //设置此⻚被引⽤⼀次 /kern/mm/pmm.h
page2pa(page) //得到page管理的那⼀⻚的物理地址 /kern/mm/pmm.h
struct Page * alloc_page() //分配⼀⻚出来 /kern/mm/pmm.h
memset(void * s, char c, size_t n) //设置s指向地址的前⾯n个字节为‘c’
//define
PTE_P 0x001 //表示物理内存⻚存在
PTE_W 0x002 //表示物理内存⻚内容可写
PTE_U 0x004 //表示可以读取对应地址的物理内存⻚内容
```

寻找页表项步骤：

1. 在一级页表（页目录）中找到它的对应项，如果存在，直接返回。

2. 如果不存在，不要求创建，返回NULL。

3. 如果不存在，要求创建，alloc空间失败，返回NULL

4. 成功拿到一个page，将它清空，并设置它的引用次数为1（在pages数组中）。

5. 并在一级页表中建立该项。最后返回。

   > 注：返回的是pte的kernel virtual addr，它的计算方法是：
   >
   > 找到该线性地址的页目录项 ==> 
   >
   > 页目录项的内容为二级页表的地址，将它转换为虚拟地址 ==>
   >
   > 根据线性地址在二级页表中的偏移，找到对应页表项地址。

```cpp
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
    // 段机制后得到的地址是linear_addr, ucore中目前va = la
    pde_t *pdep = &pgdir[PDX(la)]; // 找到它的一级页表项（指针），PDX，线性地址的前十位，page dir index
    if(!(*pdep & PTE_P)) // 看一级页表项，其实就是二级页表的物理地址，如果存在（证明二级页表）存在，在二级页表中找到，并直接返回
    {   
        if(!create) // 不要求create，直接返回
            return NULL;
        // 否则alloc a page，建立二级页表，（成功的话）并设置这个page的ref为1，将内存也清空。
        struct Page* page = alloc_page(); 
        if(page == NULL)
            return NULL;
        set_page_ref(page, 1); 
        uintptr_t pa = page2pa(page);  // 页清空
        memset(KADDR(pa), 0, PGSIZE);
        // 在一级页表中，设置该二级页表入口
        *pdep = (pa & ~0xFFF) | PTE_P | PTE_W | PTE_U;
    }
    // PDE_ADDR 就是取了个 &，因为设置的时候取了 |。 得到的是二级页表真正的物理地址。
    // (pte_t *)KADDR(PDE_ADDR(*pdep)): 将物理地址转换为 二级页表的核虚拟地址
    // [PTX(la)] 加上la中相对二级页表的偏移
    // 取地址，返回
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];  // (*pdep)是物理地址
}
```

问题：
- 请描述页目录项（Page Directory Entry）和页表项（Page Table Entry）中每个组成部分的含义以及对ucore而言的潜在用处。
![](./images/1.png)
  答：由于页目录项、页表项的低12位默认为0，所以可以作为标志字段使用。PDE和PTE的⾼20位类似，都是⽤来表示其指向的物理⻚的物理地址，0-9位如上，其中9-11位保留给OS，PDE和PTE的不同在于：①PDE的第7位⽤于设置page⼤⼩0表示4KB，⽽PTE的第7位恒为0；②PDE第6位恒为0，PTE第6位表示脏位即是否需要在swap out的时候写回外存；③PDE的第3位如上第4位设置为1则表示不对该⻚进⾏缓存，PTE的3-4位恒为0；


| 组成部分  | 含义                                       | 地址  |
| --------- | ------------------------------------------ | ----- |
| PTE_P     | 表示物理内存页是否存在                     | 0     |
| PTE_W     | 表示物理内存页是否可写                     | 1     |
| PTE_U     | 表示物理内存页是否可被用户获取(需要特权级) | 2     |
| PTE_PWT   | 表示物理内存页是否直写(write-through)      | 3     |
| PTE_PCD   | 禁用缓存                                   | 4     |
| PTE_A     | 表示物理内存页是否被使用过                 | 5     |
| PTE_D     | 脏页                                       | 6     |
| PTE_PS    | 设置物理内存页的大小                       | 7     |
| PTE_MBZ   | must be zero恒为0                          | 8     |
| PTE_AVAIL | 可以给OS设置和使用                         | 11    |
|           | 高20位                                     | 12-31 |

- 如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

  答：可能出现页异常的情况大致有：没有创建一个虚拟地址到物理地址的映射；创建了映射，但物理页不可写。发生了相应异常后，（也就是一种中断后），会保护CPU现场，分析中断原因，交给缺页中断处理，处理结束后恢复现场。额外的，缺页中断在返回后，需要重新执行产生中断的指令。执行中断流程，然后新加页表或者换页表。如果物理内存中有空闲块，就新加页表。不然就把内存写到硬盘，换新页表
## 练习三：释放某虚地址所在页并取消对应二级页表项映射
当释放一个包含某虚地址的物理内存页时，需要让对应此物理内存页的管理数据结构Page做相关的清除处理，使得此物理内存页成为空闲；另外还需把表示虚地址与物理地址对应关系的二级页表项清除。取消页表映射过程如下：

* 将物理页的引用数目减一，如果变为零，那么释放页面；
* 将页目录项清零；
* 刷新TLB

```cpp
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
    if (*ptep & PTE_P) { // 如果二级页表项存在
        struct Page *page = pte2page(*ptep); // 找到这个二级页表项对应的page
        if (page_ref_dec(page) == 0) // 自减该page的ref，如果为0，则free该page
            free_page(page);
        *ptep = 0; //将该page table entry置0
         // 先检查此时cpu使用的一级页表是不是pgdir，如果是，则在快表中，invalidate对应的线性地址。[la 是]
         // 如果不是，则它根本不在快表中。
         // 底层调用invlpg，[INVLPG m 使包含 m(地址) 的页对应TLB项目失效]
         // la应该就是page对应的线性地址吧。。
        tlb_invalidate(pgdir, la); 
    }
}
```

问题：数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？

> 答：有关系，每个页表项/页目录项都对应一个物理页，也就对应pages中的一项。

如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？
2. 阅读实验参考书“系统执行中地址映射的四个阶段”

   物理地址和虚拟地址之间存在偏移量

   物理地址 + KERNBASE(0xC0000000) = 虚拟地址=线性地址

   所以，KERNBASE = 0时，物理地址 = 虚拟地址，把memlayout.h中改为

```c
/*All physical memory mapped at this address */
#define KERNBASE 0x00000000
```

* 并按照lab1修改tools/kernel.ld为
修改链接脚本，将内核起始虚拟地址修改为`0x100000`

```c
SECTIONS {
    /* Load the kernel at this address: "." means the current address */
    . = 0x100000;//原来是0xC0100000
...
```
* 注释掉kern/mm/pmm.c中这一部分代码
```shell
//disable the map of virtual_addr 0~4M
// boot_pgdir[0] = 0;
//now the basic virtual memory map(see memalyout.h) is established.
//check the correctness of the basic virtual memory map.
// check_boot_pgdir();
```

## `make grade`

已经得到了50分。

```shell
Check PMM:               (3.0s)
  -check pmm:                                OK
  -check page table:                         OK
  -check ticks:                              OK
Total Score: 50/50
```

## 扩展练习`Challenge1`
### 分配器的整体思想
>通过⼀个数组形式的完全⼆叉树来监控管理内存，⼆叉树的节点⽤于标记相应内存块的使⽤状态，⾼层节点对应⼤的块，低层节点对应⼩的块，在分配和释放中我们就通过这些节点的标记属性来进⾏块的分离合并。如图所示，假设总⼤⼩为16单位的内存，我们就建⽴⼀个深度为5的满⼆叉树，根节点从数组下标[0]开始，监控⼤⼩16的块；它的左右孩⼦节点下标[1][2]，监控⼤⼩8的块；第三层节点下标[3][6]监控⼤⼩4的块……依此类推。

![](./images/4.png)
### 分配过程
`Buddy System`要求分配空间为2的幂，所以首先将请求的页数向上对齐到2的幂。
接下来从二叉树的根节点（1号节点）开始查找满足要求的节点。对于每次检查的节点：
* 如果子树的最大可用空间小于请求空间，那么分配失败；
* 如果子树的最大可用空间大于等于请求空间，并且总空间大小等于请求空间，说明这个节点对应的空间没有被分割和分配，并且满足请求空间大小，那么分配这个空间；
* 如果子树的最大可用空间大于等于请求空间，并且总空间大小大于请求空间，那么在这个节点的子树中查找：
    * 如果这个节点对应的空间没有被分割过（最大可用空间等于总空间大小），那么分割空间，在左子树（左半部分）继续查找；
    * **如果左子树的最大可用空间大于等于请求空间，那么在左子树中继续查找；**
    * **如果右子树的最大可用空间大于等于请求空间，那么在右子树中继续查找。**
* 当一个空间被分配之后，这个空间对应节点的所有父节点的可用空间表都会受到影响，需要自地向上重新更新可用空间信息。
### 释放过程
`Buddy System`要求分配空间为2的幂，所以同样首先将请求的页数向上对齐到2的幂。
在进行释放之前，需要确定要释放的空间对应的节点，然后将空间标记为可用。接下来进行自底向上的操作：
  * 如果某节点的两个子节点对应的空间都未分割和分配，那么合并这两个空间，形成一个更大的空间；
  * 否则，根据子节点的可用空间信息更新父节点的可用空间信息。
### 代码参考--致谢
[References1](https://github.com/zhenghaoz/ucore/tree/master/lab2)
[References2](https://github.com/wuwenbin/buddy2)

## 指导书上的问题
* **管理页级物理内存空间所需的Page结构的内存空间从哪里开始，占多大空间？**

根据`bootloader`给出的内存布局信息找出最大的物理内存地址`maxpa`（定义在`page_init`函数中的局部变量），由于`x86`的起始物理内存地址为0，所以可以得知需要管理的物理页个数为
```shell
npage = maxpa / PGSIZE
```
这样，我们就可以预估出管理页级物理内存空间所需的Page结构的内存空间所需的内存大小为：
```c
sizeof(struct Page) * npage
```
由于`bootloader`加载`ucore`的结束地址（用全局指针变量`end`记录）以上的空间没有被使用，所以我们可以把`end`按页大小为边界取整后，作为管理页级物理内存空间所需的`Page`结构的内存空间，记为：
```c
pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
```
* **空闲内存空间的起始地址在哪里？**
```cpp
uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
```
![](./images/5.png)
* **具体的页映射关系是什么？**

在lab1和lab2中，`bootloader`把`ucore`都放在了起始物理地址为`0x100000`的物理内存空间。
在lab1中，我们已经碰到了简单的段映射，即对等映射关系，保证了物理地址和虚拟地址相等，也就是通过
建立全局段描述符表，让每个段的基址为0，从而确定了对等映射关系。
lab2中，通过几条汇编指令（在`kern/init/entry.S`中）实现分页机制，主要做了两件事：
  * 1.通过 `movl %eax, %cr3` 指令把页目录表的起始地址存入CR3寄存器中；
  * 2.通过 `movl %eax, %cr0` 指令把`cr0`中的`CR0_PG`标志位设置上。

执行完这几条指令后，计算机系统进入了分页模式，虚拟地址、线性地址以及物理地址之间的临时映射关系为：
```shell
lab2 stage 2 before:
    virt addr = linear addr = phy addr # 线性地址在0~4MB之内三者的映射关系
    virt addr = linear addr = phy addr + 0xC0000000 # 线性地址在
0xC0000000~0xC0000000+4MB之内三者的映射关系
```
* **页目录表的起始地址设置在哪里？**

页目录表的虚地址为`0xFAFEB000`，存储在一个4K字节的物理页中，其中每一项是4个字节，保存了页表的地址。
* **页表的起始地址设置在哪里，需要多大空间？**

页表的起始地址在`0xFAC00000`，大小为4K。

