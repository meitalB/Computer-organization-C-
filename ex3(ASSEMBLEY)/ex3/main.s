#311124283 Meital Birka

	.section	.rodata	#read only data section
formatChar:	.string	"%d"
formatString:	.string	"%s"

endOfLine:       .string "\0"
	.text	#the beginnig of the code

.globl	main	#the label "main" is used to state the initial point of this program
	.type	main, @function	# the label "main" representing the beginning of a function
main:
#main func
    pushq   %rbp		       #save the old frame pointer
    movq    %rsp,%rbp	       #create the new frame pointer
    pushq   %r12                #pointer pstring1
    pushq   %r13                #temp pstring1
    pushq   %r11                #pointer pstring2
    pushq   %r15                #temp pstring1
    pushq   %r14                #choose
    pushq   %rbx                #pointer to the 2 pstring
     
    leaq    -1(%rsp),%rsp       #alloc char memory in the stack
    movb    $0,(%rsp)           #put 0 int the stack    
#scanf pstring1    
    leaq    -4(%rsp),%rsp       #alloc 1 int length for the length of pstring1 in the stack
    movq    %rsp,%r12           #pointer to pstring1 
    movq    %rsp,%rsi           #save the address of value to a register
    movq    $formatChar,%rdi    #put "%d" in to a register
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan length of pstring1
    movzbq (%rsp),%r13          #put the size in to a reg we use only the first byte so i pur 0 in the rest
    leaq    1(%rsp),%rsp        #move the ssp one forword 
    subq    %r13,%rsp           #incrase the stack in reg 13 length bytes
    subq    $1,%rsp             #incrase the stack in one more byte
    movb    %r13b,(%rsp)        #move the value to the first byte in the stack
    leaq    1(%rsp),%rsi        #save the address of value to a register
    movq    $formatString,%rdi  #put "%s" in to a register
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan  pstring1
    movq    (%rsp),%r13         #move the value to reg 13
    movq    %rsp,%r12           #save the first p string
#scanf pstring2
    leaq -1(%rsp),%rsp          #alloc char memory in the stack
    movb $0,(%rsp)              #put 0 int the stack
    leaq    -4(%rsp),%rsp       #alloc 1 int length for the length of pstring1 in the stack
    movq  %rsp,%r11             #pointer to pstring2
    movq    %rsp,%rsi           #save the address of value to a register
    movq    $formatChar,%rdi    #put "%d" in to a register
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan length of pstring1
    movzbq (%rsp),%r15          #put the size in to a reg we use only the first byte so i pur 0 in the rest
    leaq 1(%rsp),%rsp           #move the pointer of rsp one byte
    subq %r15,%rsp              #incrase the stack in reg 15 length bytes
    subq $1,%rsp                #incrase the stack in one more byte
    movb %r15b,(%rsp)           #save the address of value to a register
    leaq    1(%rsp),%rsi        #save the address of value to a register
    movq    $formatString,%rdi  #put "%s" in to a register
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan  pstring1
    movq    (%rsp),%r15         #move the value to reg 15   
    movq    %rsp,%rbx           #save the second p string
#scanf option    
    leaq    -4(%rsp),%rsp       #alloc 1 int length for the length of pstring1 in the stack
    movq    %rsp,%r14           #pointer to value
    movq    %rsp,%rsi           #save the address of value to a register
    movq    $formatChar,%rdi    #put "%d" in to a register
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan length of pstring1
    movzbq (%rsp),%r14          #put the size in to a reg we use only the first byte so i pur 0 in the rest
    movq    %r14,%rdi           #opt
    movq    %r12,%rsi           #pstring1
    movq    %rbx,%rdx           #pstring2
    call run_func               #call run func

    popq %rbx                   #pop rbx
    popq %r14                   #pop choose
    popq %r15                   #temp pstring1
    popq %r11                   #pointer pstring2
    popq %r13                   #temp pstring1
    popq %r12                   #pointer pstring1
   
    movq	   $0, %rax	       #return value is zero (just like in c - we tell the OS that this program finished seccessfully)
    movq	   %rbp, %rsp	       #restore the old stack pointer - release all used memory.
    popq   %rbp		       #restore old frame pointer (the caller function frame)
    ret			       #return to caller function (OS)
