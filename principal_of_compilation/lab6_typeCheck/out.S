	.file	"temp.c"
	.text
	.comm	temp0,4,4
	.comm	temp1,4,4
	.comm	temp3,4,4
	.comm	temp4,4,4
	.comm	temp5,4,4
	.section	.rodata
.str2:
	.string	"%d"
.str6:
	.string	"%d\n%d"
	.text
	.globl	func
	.type	func, @function
func:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$8, temp0(%rip)
	movl	temp0(%rip), %esi
	cmpl	$8, %esi
	sete	%al
	movzbl	%al, %esi
	testl	%esi, %esi
	je	.L0
	movl	$1, %eax
	leave
	ret
	jmp	.L1
.L0:
	movl	$2, %eax
	leave
	ret
.L1:
	leave
	ret
	.size	func, .-func
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	.str2(%rip), %rdi
	leaq	temp1(%rip), %rax
	movq	%rax, %rsi
	call	__isoc99_scanf@PLT
	movl	$1, temp3(%rip)
	movl	$1, temp4(%rip)
	jmp	.L3
.L2:
	movl	temp3(%rip), %esi
	imull	temp4(%rip), %esi
	movl	%esi, temp3(%rip)
	movl	temp4(%rip), %esi
	addl	$1, %esi
	movl	%esi, temp4(%rip)
.L3:
	movl	temp4(%rip), %esi
	cmpl	temp1(%rip), %esi
	setle	%al
	movzbl	%al, %esi
	testl	%esi, %esi
	jne	.L2
	call	func
	movl	%eax, temp5(%rip)
	leaq	.str6(%rip), %rdi
	movq	temp3(%rip), %rsi
	movq	temp5(%rip), %rdx
	call	printf@PLT
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"CODE BY PENG"
	.section	.note.GNU-stack,"",@progbits
