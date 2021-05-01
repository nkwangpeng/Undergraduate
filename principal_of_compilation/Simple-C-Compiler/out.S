	.file	"temp.c"
	.text
	.comm	temp0,4,4
	.comm	temp1,4,4
	.comm	temp2,4,4
	.comm	temp3,4,4
	.section	.rodata
.str4:
	.string	"%d\n"
	.text
	.globl	func
	.type	func, @function
func:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$6, temp0(%rip)
	movl	temp0(%rip), %eax
	leave
	ret
	.size	func, .-func
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	call	func
	movl	%eax, temp1(%rip)
	movl	$1, temp2(%rip)
	movl	$1, temp3(%rip)
	jmp	.L1
.L0:
	movl	temp2(%rip), %esi
	imull	temp3(%rip), %esi
	movl	%esi, temp2(%rip)
	movl	temp3(%rip), %esi
	addl	$1, %esi
	movl	%esi, temp3(%rip)
.L1:
	movl	temp3(%rip), %esi
	cmpl	temp1(%rip), %esi
	setle	%al
	movzbl	%al, %esi
	testl	%esi, %esi
	jne	.L0
	leaq	.str4(%rip), %rdi
	movq	temp2(%rip), %rsi
	call	printf@PLT
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"CODE BY PENG"
	.section	.note.GNU-stack,"",@progbits
