	.file	"main.c"
	.text
	.p2align 4,,15
	.globl	TimerInterruptEmulation
	.def	TimerInterruptEmulation;	.scl	2;	.type	32;	.endef
	.seh_proc	TimerInterruptEmulation
TimerInterruptEmulation:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	leaq	32(%rsp), %rbx
	movq	$0, 32(%rsp)
	movq	$10000000, 40(%rsp)
	.p2align 4,,10
.L2:
	xorl	%edx, %edx
	movq	%rbx, %rcx
	call	nanosleep
	call	qSchedulerSysTick
	jmp	.L2
	.seh_endproc
	.section .rdata,"dr"
.LC0:
	.ascii "Userdata : %s  Eventdata:%s\15\12\0"
	.text
	.p2align 4,,15
	.globl	Task6Callback
	.def	Task6Callback;	.scl	2;	.type	32;	.endef
	.seh_proc	Task6Callback
Task6Callback:
	.seh_endprologue
	movq	8(%rcx), %rdx
	movq	16(%rcx), %r8
	leaq	.LC0(%rip), %rcx
	jmp	printf
	.seh_endproc
	.p2align 4,,15
	.globl	Task5Callback
	.def	Task5Callback;	.scl	2;	.type	32;	.endef
	.seh_proc	Task5Callback
Task5Callback:
	.seh_endprologue
	jmp	Task6Callback
	.seh_endproc
	.p2align 4,,15
	.globl	Task4Callback
	.def	Task4Callback;	.scl	2;	.type	32;	.endef
	.seh_proc	Task4Callback
Task4Callback:
	.seh_endprologue
	jmp	Task6Callback
	.seh_endproc
	.section .rdata,"dr"
.LC1:
	.ascii "state machine init\0"
.LC3:
	.ascii "[%s] first\15\12\0"
	.text
	.p2align 4,,15
	.globl	firststate
	.def	firststate;	.scl	2;	.type	32;	.endef
	.seh_proc	firststate
firststate:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movq	32(%rcx), %rsi
	movq	%rcx, %rbx
	cmpb	$0, 24(%rsi)
	jne	.L17
	movzbl	28(%rbx), %eax
	testb	%al, %al
	jne	.L18
.L9:
	leaq	tmr.3884(%rip), %rcx
	call	qSTimerExpired
	testb	%al, %al
	je	.L10
	leaq	secondstate(%rip), %rax
	movq	%rax, (%rbx)
.L10:
	movl	$-32768, %eax
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.p2align 4,,10
.L17:
	leaq	.LC1(%rip), %rcx
	call	puts
	movzbl	28(%rbx), %eax
	testb	%al, %al
	je	.L9
.L18:
	leaq	tmr.3884(%rip), %rcx
	movss	.LC2(%rip), %xmm1
	call	qSTimerSet
	movq	8(%rsi), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L9
	.seh_endproc
	.section .rdata,"dr"
.LC4:
	.ascii "[%s] second\15\12\0"
	.text
	.p2align 4,,15
	.globl	secondstate
	.def	secondstate;	.scl	2;	.type	32;	.endef
	.seh_proc	secondstate
secondstate:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movq	32(%rcx), %rsi
	movzbl	28(%rcx), %eax
	movq	%rcx, %rbx
	testb	%al, %al
	jne	.L28
.L20:
	leaq	tmr.3889(%rip), %rcx
	call	qSTimerExpired
	testb	%al, %al
	je	.L21
	leaq	firststate(%rip), %rax
	movq	%rax, (%rbx)
.L21:
	movl	$-32768, %eax
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.p2align 4,,10
.L28:
	leaq	tmr.3889(%rip), %rcx
	movss	.LC2(%rip), %xmm1
	call	qSTimerSet
	movq	8(%rsi), %rdx
	leaq	.LC4(%rip), %rcx
	call	printf
	jmp	.L20
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC5:
	.ascii "Userdata : %s  Eventdata:%s   %d\15\12\0"
.LC6:
	.ascii "FirstCall\0"
.LC7:
	.ascii "FirtsIteration\0"
.LC8:
	.ascii "LastIteration\0"
.LC9:
	.ascii "TASK1 BY ASYNC EVENT\0"
.LC11:
	.ascii "Timer expired\0"
	.text
	.p2align 4,,15
	.globl	Task1Callback
	.def	Task1Callback;	.scl	2;	.type	32;	.endef
	.seh_proc	Task1Callback
Task1Callback:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$32, %rsp
	.seh_stackalloc	32
	.seh_endprologue
	movq	%rcx, %rbx
	leaq	Task1(%rip), %rcx
	call	qTaskGetCycles
	movq	8(%rbx), %rdx
	movq	16(%rbx), %r8
	leaq	.LC5(%rip), %rcx
	movl	%eax, %r9d
	call	printf
	cmpb	$0, 24(%rbx)
	jne	.L35
.L30:
	cmpb	$0, 25(%rbx)
	jne	.L36
.L31:
	cmpb	$0, 26(%rbx)
	jne	.L37
	cmpl	$3, (%rbx)
	je	.L38
.L33:
	leaq	tmr.3893(%rip), %rcx
	movss	.LC10(%rip), %xmm1
	call	qSTimerFreeRun
	testb	%al, %al
	jne	.L39
	addq	$32, %rsp
	popq	%rbx
	ret
	.p2align 4,,10
.L39:
	leaq	.LC11(%rip), %rcx
	addq	$32, %rsp
	popq	%rbx
	jmp	puts
	.p2align 4,,10
.L37:
	leaq	.LC8(%rip), %rcx
	call	puts
	cmpl	$3, (%rbx)
	jne	.L33
.L38:
	leaq	.LC9(%rip), %rcx
	call	puts
	jmp	.L33
	.p2align 4,,10
.L36:
	leaq	.LC7(%rip), %rcx
	call	puts
	jmp	.L31
	.p2align 4,,10
.L35:
	leaq	.LC6(%rip), %rcx
	call	puts
	jmp	.L30
	.seh_endproc
	.section .rdata,"dr"
.LC12:
	.ascii "led on\0"
.LC14:
	.ascii "led off\0"
	.text
	.p2align 4,,15
	.globl	blinktaskCallback
	.def	blinktaskCallback;	.scl	2;	.type	32;	.endef
	.seh_proc	blinktaskCallback
blinktaskCallback:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movl	_qCRTaskState_.3919(%rip), %eax
	cmpl	$127, %eax
	je	.L42
	jle	.L63
	cmpl	$128, %eax
	je	.L52
	xorl	%esi, %esi
	cmpl	$133, %eax
	movl	$1, %ebx
	jne	.L40
.L46:
	leaq	tmr.3917(%rip), %rcx
	call	qSTimerExpired
	testb	%al, %al
	je	.L40
.L44:
	leaq	.LC12(%rip), %rcx
	call	puts
	leaq	tmr.3917(%rip), %rcx
	movss	.LC13(%rip), %xmm1
	call	qSTimerSet
	leaq	tmr.3917(%rip), %rcx
	movl	$127, _qCRTaskState_.3919(%rip)
	call	qSTimerExpired
	testb	%al, %al
	je	.L40
	cmpl	%esi, %ebx
	movl	$128, _qCRTaskState_.3919(%rip)
	jne	.L49
.L40:
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.p2align 4,,10
.L52:
	movl	$2, %ebx
	movl	$1, %esi
.L45:
	leaq	tmr.3917(%rip), %rcx
	movss	.LC13(%rip), %xmm1
	call	qSTimerSet
	leaq	.LC14(%rip), %rcx
	call	puts
	leaq	Task1(%rip), %rcx
	xorl	%edx, %edx
	call	qTaskSendEvent
	movl	$133, _qCRTaskState_.3919(%rip)
	jmp	.L46
	.p2align 4,,10
.L63:
	xorl	%esi, %esi
	cmpl	$-32766, %eax
	movl	$1, %ebx
	je	.L44
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.p2align 4,,10
.L42:
	leaq	tmr.3917(%rip), %rcx
	call	qSTimerExpired
	testb	%al, %al
	je	.L40
	movl	$128, _qCRTaskState_.3919(%rip)
	xorl	%esi, %esi
	movl	$1, %ebx
.L49:
	addl	$1, %esi
	addl	$1, %ebx
	jmp	.L45
	.seh_endproc
	.section .rdata,"dr"
.LC15:
	.ascii "ring extracted data %d\15\12\0"
	.text
	.p2align 4,,15
	.globl	Task3Callback
	.def	Task3Callback;	.scl	2;	.type	32;	.endef
	.seh_proc	Task3Callback
Task3Callback:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$32, %rsp
	.seh_stackalloc	32
	.seh_endprologue
	movq	8(%rcx), %rdx
	movq	16(%rcx), %r8
	movq	%rcx, %rbx
	leaq	.LC0(%rip), %rcx
	call	printf
	cmpl	$4, (%rbx)
	je	.L66
	addq	$32, %rsp
	popq	%rbx
	ret
	.p2align 4,,10
.L66:
	movq	16(%rbx), %rax
	leaq	.LC15(%rip), %rcx
	movl	(%rax), %edx
	addq	$32, %rsp
	popq	%rbx
	jmp	printf
	.seh_endproc
	.section .rdata,"dr"
.LC17:
	.ascii "hi\0"
	.text
	.p2align 4,,15
	.globl	IdleTaskCallback
	.def	IdleTaskCallback;	.scl	2;	.type	32;	.endef
	.seh_proc	IdleTaskCallback
IdleTaskCallback:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$32, %rsp
	.seh_stackalloc	32
	.seh_endprologue
	leaq	t.3913(%rip), %rcx
	movss	.LC16(%rip), %xmm1
	call	qSTimerFreeRun
	testb	%al, %al
	jne	.L69
	addq	$32, %rsp
	popq	%rbx
	ret
	.p2align 4,,10
.L69:
	leaq	Task1(%rip), %rbx
	leaq	.LC17(%rip), %rcx
	call	puts
	movq	%rbx, %rcx
	movl	$6, %edx
	call	qTaskSetIterations
	movl	$1, %edx
	movq	%rbx, %rcx
	addq	$32, %rsp
	popq	%rbx
	jmp	qTaskSetState
	.seh_endproc
	.p2align 4,,15
	.globl	datacapture
	.def	datacapture;	.scl	2;	.type	32;	.endef
	.seh_proc	datacapture
datacapture:
	.seh_endprologue
	ret
	.seh_endproc
	.p2align 4,,15
	.globl	Task2Callback
	.def	Task2Callback;	.scl	2;	.type	32;	.endef
	.seh_proc	Task2Callback
Task2Callback:
	.seh_endprologue
	jmp	Task6Callback
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC19:
	.ascii "blink\0"
.LC21:
	.ascii "TASK1\0"
.LC22:
	.ascii "TASK3\0"
.LC23:
	.ascii "TASK4\0"
.LC24:
	.ascii "TASK5\0"
.LC25:
	.ascii "TASK6\0"
.LC26:
	.ascii "smtask\0"
	.section	.text.startup,"x"
	.p2align 4,,15
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$472, %rsp
	.seh_stackalloc	472
	.seh_endprologue
	leaq	Task3(%rip), %rsi
	call	__main
	leaq	TimerInterruptEmulation(%rip), %r8
	leaq	TimerEmulation(%rip), %rcx
	xorl	%r9d, %r9d
	xorl	%edx, %edx
	leaq	128(%rsp), %rbx
	call	pthread_create
	xorl	%eax, %eax
	leaq	144(%rsp), %rcx
	movl	$4, %edx
	movw	%ax, 126(%rsp)
	leaq	118(%rsp), %rax
	movw	%dx, 144(%rsp)
	movl	$40, %edx
	movq	$0, 176(%rsp)
	movq	$0, 184(%rsp)
	movq	%rax, 152(%rsp)
	leaq	176(%rsp), %rax
	movq	$0, 192(%rsp)
	movq	$0, 200(%rsp)
	movq	$0, 208(%rsp)
	movq	$0, 118(%rsp)
	movb	$10, 146(%rsp)
	movq	%rax, 160(%rsp)
	movl	$5, 108(%rsp)
	movl	$6, 112(%rsp)
	call	qMemoryAlloc
	movl	$10, %r9d
	movl	$4, %r8d
	movq	%rax, %rdx
	movq	%rbx, %rcx
	call	qRBufferInit
	leaq	108(%rsp), %rdx
	movq	%rbx, %rcx
	call	qRBufferPush
	leaq	112(%rsp), %rdx
	movq	%rbx, %rcx
	call	qRBufferPush
	leaq	304(%rsp), %r8
	leaq	IdleTaskCallback(%rip), %rdx
	movl	$10, %r9d
	movss	.LC18(%rip), %xmm0
	call	_qInitScheduler
	leaq	.LC19(%rip), %rax
	leaq	blinktaskCallback(%rip), %rdx
	leaq	blinktask(%rip), %rcx
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	movl	$-32768, 32(%rsp)
	movq	%rax, 48(%rsp)
	movss	.LC20(%rip), %xmm3
	call	qSchedulerAddxTask
	leaq	.LC21(%rip), %rax
	leaq	Task1Callback(%rip), %rdx
	leaq	Task1(%rip), %rcx
	movss	.LC10(%rip), %xmm3
	movl	$1, 40(%rsp)
	movq	%rax, 48(%rsp)
	movl	$5, 32(%rsp)
	movl	$254, %r8d
	call	qSchedulerAddxTask
	leaq	.LC22(%rip), %r9
	leaq	Task3Callback(%rip), %rdx
	movq	%rsi, %rcx
	movl	$127, %r8d
	call	qSchedulerAddeTask
	movq	%rbx, %rdx
	movq	%rsi, %rcx
	movl	$1, %r9d
	movl	$3, %r8d
	call	qTaskLinkRBuffer
	leaq	.LC23(%rip), %r9
	leaq	Task4Callback(%rip), %rdx
	leaq	Task4(%rip), %rcx
	movl	$10, %r8d
	call	qSchedulerAddeTask
	leaq	.LC24(%rip), %r9
	leaq	Task5Callback(%rip), %rdx
	leaq	Task5(%rip), %rcx
	movl	$80, %r8d
	call	qSchedulerAddeTask
	leaq	.LC25(%rip), %r9
	leaq	Task6Callback(%rip), %rdx
	leaq	Task6(%rip), %rcx
	movl	$10, %r8d
	call	qSchedulerAddeTask
	leaq	.LC26(%rip), %rax
	leaq	224(%rsp), %r9
	leaq	SMTask(%rip), %rcx
	movss	.LC27(%rip), %xmm2
	movl	$254, %edx
	movq	%rax, 80(%rsp)
	leaq	firststate(%rip), %rax
	movl	$1, 72(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, 56(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 40(%rsp)
	movq	%rax, 32(%rsp)
	call	qSchedulerAddSMTask
	call	qSchedulePrintChain
	call	qSchedulerRun
	xorl	%eax, %eax
	addq	$472, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.seh_endproc
.lcomm tmr.3917,12,8
	.data
	.align 4
_qCRTaskState_.3919:
	.long	-32766
.lcomm t.3913,12,8
.lcomm tmr.3893,12,8
.lcomm tmr.3889,12,8
.lcomm tmr.3884,12,8
	.comm	SMTask2, 88, 5
	.comm	SMTask, 88, 5
	.comm	blinktask, 88, 5
	.comm	TaskTestST, 88, 5
	.comm	Task6, 88, 5
	.comm	Task5, 88, 5
	.comm	Task4, 88, 5
	.comm	Task3, 88, 5
	.comm	Task2, 88, 5
	.comm	Task1, 88, 5
	.comm	TimerEmulation, 8, 3
	.section .rdata,"dr"
	.align 4
.LC2:
	.long	1075838976
	.align 4
.LC10:
	.long	1056964608
	.align 4
.LC13:
	.long	1065353216
	.align 4
.LC16:
	.long	1084227584
	.align 4
.LC18:
	.long	1008981770
	.align 4
.LC20:
	.long	1028443341
	.align 4
.LC27:
	.long	1036831949
	.ident	"GCC: (GNU) 6.4.0"
	.def	nanosleep;	.scl	2;	.type	32;	.endef
	.def	qSchedulerSysTick;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	qSTimerExpired;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	qSTimerSet;	.scl	2;	.type	32;	.endef
	.def	qTaskGetCycles;	.scl	2;	.type	32;	.endef
	.def	qSTimerFreeRun;	.scl	2;	.type	32;	.endef
	.def	qTaskSendEvent;	.scl	2;	.type	32;	.endef
	.def	qTaskSetIterations;	.scl	2;	.type	32;	.endef
	.def	qTaskSetState;	.scl	2;	.type	32;	.endef
	.def	pthread_create;	.scl	2;	.type	32;	.endef
	.def	qMemoryAlloc;	.scl	2;	.type	32;	.endef
	.def	qRBufferInit;	.scl	2;	.type	32;	.endef
	.def	qRBufferPush;	.scl	2;	.type	32;	.endef
	.def	_qInitScheduler;	.scl	2;	.type	32;	.endef
	.def	qSchedulerAddxTask;	.scl	2;	.type	32;	.endef
	.def	qSchedulerAddeTask;	.scl	2;	.type	32;	.endef
	.def	qTaskLinkRBuffer;	.scl	2;	.type	32;	.endef
	.def	qSchedulerAddSMTask;	.scl	2;	.type	32;	.endef
	.def	qSchedulePrintChain;	.scl	2;	.type	32;	.endef
	.def	qSchedulerRun;	.scl	2;	.type	32;	.endef
