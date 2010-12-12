@#include "sched.h"

#define 	PID_OFT		0
#define	STATE_OFT		4
#define	COUNT_OFT		8
#define	PRIORITY_OFT	12
#define	CONTENT_OFT		16

@ Ӧ��ת���������ַ	
#define	SDRAM_BASE		0x30000000
#define	SDRAM_SIZE		0x04000000		
	
	
@ �Ĵ����л�
@ __switch_to(struct task_struct pcur,struct task_struct pnext):	
@ r0 = &pcur, r1 = &pnext
@ ����linux,__switch_to��arch/arm/kernel/entry-armv.S�ж���,���´���ο���	
		
@ ENTRY(__switch_to)
.global __switch_to
__switch_to:		
	add	r0, r0,#CONTENT_OFT
	ldr	sp, =(SDRAM_BASE+0x100000-14*4)

	stmia	r0!,{sp}^		@ �û�/ϵͳģʽ�µ�sp

	mrs	r2, spsr		@ ����spsr������
	stmia	r0!,{r2}

	ldmia	sp!,{r2-r8}		@ �ѽ����ж�ʱ����ļĴ���ת�Ƶ���ǰtask struct��
	stmia	r0!,{r2-r8}
	ldmia	sp!,{r2-r8}
	stmia	r0!,{r2-r8}

	ldr	r0, [r1,#PID_OFT]	@ Ҫ�л����Ľ��̵�PID
	mov	r0, r0, lsl #25	@ PID���ڼĴ��������7λ	
	mcr	p15, 0, r0, c13, c0, 0	@ дnext_pid,�Ӵˣ�VA<32M��ȡַ���㹫ʽ�ͱ��ˣ��������ڵ�VA���Ǵ���32M��

	add	r1, r1, #CONTENT_OFT	@ r1 = &task[next].content

	ldmia	r1!,{sp}^		@ �û�/ϵͳģʽ�µ�sp
	
	ldmia	r1!,{r2}		@ spsr
	msr	spsr_cxsf, r2

	mov	sp, r1		
	ldmia	sp!,{r0-r12,pc}^	@ ģ���жϷ���, ^��ʾ��spsr��ֵ���Ƶ�cpsr