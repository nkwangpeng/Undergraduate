#ifndef __KERN_PROCESS_PROC_H__
#define __KERN_PROCESS_PROC_H__

#include <defs.h>
#include <list.h>
#include <trap.h>
#include <memlayout.h>


// process's state in his life cycle
enum proc_state {
    PROC_UNINIT = 0,  // uninitialized
    PROC_SLEEPING,    // sleeping
    PROC_RUNNABLE,    // runnable(maybe running)
    PROC_ZOMBIE,      // almost dead, and wait parent proc to reclaim his resource
};

// Saved registers for kernel context switches.
// Don't need to save all the %fs etc. segment registers,
// because they are constant across kernel contexts.
// Save all the regular registers so we don't need to care
// which are caller save, but not the return register %eax.
// (Not saving %eax just simplifies the switching code.)
// The layout of context must match code in switch.S.
struct context {
    uint32_t eip;
    uint32_t esp;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    uint32_t esi;
    uint32_t edi;
    uint32_t ebp;
};

#define PROC_NAME_LEN               15
#define MAX_PROCESS                 4096
#define MAX_PID                     (MAX_PROCESS * 2)

extern list_entry_t proc_list;

struct proc_struct {
    enum proc_state state;                      // 线程运行的状态，包括就绪态，运行态，休眠态，是个动态变化的信息
    int pid;                                    // 线程id，就跟身份证一样，是标识线程的唯一id
    int runs;                                   // the running times of Proces
    uintptr_t kstack;                           // 内核栈,记录了分配给该进程/线程的内核栈的位置。对内核线程是运⾏时的程序使⽤的栈；⽽对用户线程是发⽣特权级改变的时候使保存被打断的硬件信息⽤的栈
    volatile bool need_resched;                 // 判断线程是否需要cpu调度
    struct proc_struct *parent;                 // the parent process
    struct mm_struct *mm;                       // 管理线程的内存空间，包括lab3中的做的一些内容
    struct context context;                     // 线程的上下文，其实就是一堆寄存器。切换上下文就是切换寄存器的内容,标识现在进程的运行状态
    struct trapframe *tf;                       // 在lab1中的中断遇到过，如果实现特权级的切换需要保存压栈的信息。还有段寄存器的信息，还有通用寄存器的信息。保存了前一个被打断的进程或线程的信息，被中断打断的
    /*当进程从用户空间跳到内核空间时，中断帧记
    录了进程在被中断前的状态。当内核需要跳回用户空间时，需要调整中断帧以恢复让进程继续执行的各寄存
    器值。*/
    uintptr_t cr3;                              // 保存⻚表的物理地址PDT 进程切换的时候⽅便直接使⽤lcr3实现⻚表切换
    uint32_t flags;                             // Process flag
    char name[PROC_NAME_LEN + 1];               // 为了更好地表述这个线程，线程需要有一个名字
    list_entry_t list_link;                     // Process link list 线程控制块的链表
    list_entry_t hash_link;                     // Process hash list 线程控制块的链表（因为用上面的这个查找线程时间会比较长，因此又新建了一个线程的哈希链表）通过pid哈希
};

#define le2proc(le, member)         \
    to_struct((le), struct proc_struct, member)

extern struct proc_struct *idleproc, *initproc, *current;

void proc_init(void);
void proc_run(struct proc_struct *proc);
int kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags);

char *set_proc_name(struct proc_struct *proc, const char *name);
char *get_proc_name(struct proc_struct *proc);
void cpu_idle(void) __attribute__((noreturn));

struct proc_struct *find_proc(int pid);
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf);
int do_exit(int error_code);

#endif /* !__KERN_PROCESS_PROC_H__ */

