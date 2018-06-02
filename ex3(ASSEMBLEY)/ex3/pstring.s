#311124283 Meital Birka

	.section	.rodata	#read only data section
	
notValidString:	.string	"invalid input!\n"
	
	.text	#the beginning of the code.

#this function gets pointer to psring and return his length.
.globl pstrlen
.type pstrlen, @function
pstrlen:	
	movzbq	(%rdi), %rax	#geting the length.
	ret		#return the value of length. 


.globl replaceChar
.type replaceChar, @function

replaceChar: 
    #rdi -is the pstring char r12
    #rsi -old char r14
    #rdx -new char r15
    pushq   %r12                #current char
    pushq    %rbx               # end counter
    pushq    %r13               # counter
    movq     %rdi,%r12          #current char
    movq     %rsi,%r14          # save the old char
    movq     %rdx,%r15          #save the new char
    movzbq  (%rdi),%rbx         #save the end sign
    movq    $0,%r13             # init  index in 1
    leaq    1(%r12),%r12        #go to the first char

loopForReplace:
    cmpb    (%r12),%r14b        #compare current to the old sign
    je      yesReplace          #if there are equal
 check:
    leaq    1(%r13),%r13        #add 1 to counter 
    leaq    1(%r12),%r12        #go to the next char
    cmpq    %rbx,%r13           #compare current to the end counter
    jl loopForReplace           #if <= go to loop
    je done                     #if equal go to done       
yesReplace:
    movb %r15b,(%r12)           #if yes- change to  old char to new char
    jmp check                   #go to check if there are more chars
done:    
    movq %rdi,%rax           #return the new pstring
    popq %r13                   # pop counter
    popq %rbx                   # pop endcounter
    popq %r12                   #current char
    ret                         

.globl pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
    #rdi -is pstring 1 dst
    #rsi -is pstring 2 src
    #rdx -index i
    #rcx -index j
    
    #r8 -save length of dst
    #r9 -save length of src
    #r10-index end cpy
    #rbx counter

    pushq   %r12                #save pointer to rdi -is pstring 1 dst
    pushq    %r13               #save pointer rsi -is pstring 2 src
    pushq    %r11               # index
    pushq %r8
    pushq %r9
    movq     %rdi,%r12          #save pointer to rdi -is pstring 1 dst
    movq     %rsi,%r13          #save pointer rsi -is pstring 2 src
    movq     %rdx,%r14          #save index i
    movq     %rcx,%r15          #save index j

    movzbq  (%rdi),%r8         #r8 -save length of dst
    movzbq  (%rsi),%r9         #r9 -save length of src
    #r14 -i
    #r15 -j
    #r8 -save length of dst
    #r9 -save length of src

    # checkBorder
    cmpb    $0,%r14b  #if i smaller then 0
    jl      notValid
    cmpb    %r15b,%r8b  # if j bigger the dst len
    jl      notValid
    cmpb    %r15b,%r9b # if j bigger the src len
    jl      notValid
    cmpb    %r14b,%r15b #if i bigger then j
    jl      notValid
    movq    $0,%r11            # init  index in 1

    copy_run_to_i:                  #search for start copy
        leaq    1(%r12),%r12        #go to the next char
        leaq    1(%r13),%r13        #go to the next char
        cmpb    %r11b,%r14b           #compare current to the end counter
        jle copy_run_to_j
        leaq    1(%r11),%r11        #add 1 to counter 
        jmp     copy_run_to_i            #if <= go to loop
    copy_run_to_j:                  #copy letters from i to j
        call copy_i_j               #call copy func
        leaq    1(%r11),%r11        #add 1 to counter 
        leaq    1(%r12),%r12        #go to the next char
        leaq    1(%r13),%r13        #go to the next char
        cmpb    %r11b,%r15b           #compare current to the end counter
        jge copy_run_to_j           #if <= go to loop 
end:                                #end func
       movq    %rdi,%rax           #return the pointer pstring dst
     popq    %r9                   #pop r9
     popq    %r8                   #pop r8
     popq    %r11                  #pop r11
     popq    %r13                  #pop r13
     popq    %r12                  #pop r12
     ret 
copy_i_j:                           #copy i to j as asked in the task
    pushq   %rax                    #save the address of rax before
    movb    (%r13),%al              #change src string
    movb    %al, (%r12)             #move value to r12
    popq    %rax                    #pop rax
    ret
    
notValid:                               #not value func
    movq	   $notValidString,%rdi      #print invalid input
    movq	   $0,%rax                   #needed before print
    call	   printf                    #print
    movq %r12,%rdi                   #move the string back to rdi
    jmp end                          #end func


.globl swapCase
.type swapCase, @function
swapCase:
    #rdi -is pstring 
    pushq   %r12                #save pointer to rdi -is pstring 1 dst
    pushq   %r13                #counter current
    pushq   %r14                #end counter 
    
    movq    %rdi,%r12          #save pointer to rdi
    movq    $1,%r13             # init  index in 1
    movzbq  (%rdi),%r14         #save the end sign
    leaq    1(%r12),%r12        #go to the first char pstring1
    cmpq $0,%r14                #compare to 0
    jle after_loop              #jmp to the end
    loopForSwap:
        call    swapCheck       #call swap check func
        leaq    1(%r12),%r12        #go to the first char pstring1
        leaq    1(%r13),%r13        #go to the first char pstring1  
        cmpq    %r14,%r13          #compare current i to the end counter   
        jle     loopForSwap         #jmp to loop for swap
    after_loop:
        movq    %rdi,%rax           #return the pointer pstring dst
        popq   %r14                #end counter
        popq   %r13                #counter current
        popq   %r12                #save pointer to rdi -is pstring 1 dst
        ret
swapCheck:                      #check if we need to swap
    pushq %rbx                   #save address of rbx
    movb    (%r12),%bl           #change src string 
    cmp    $65,%bl               #copy the current char check if a big letter
    jl     endCheckFunc         #move to next letter
    cmp    $90,%bl              # check for little letter
    jle     swapToLittle        #if big letter go to swap little
    cmp    $97,%bl              #cmp the value to 97 th check if letter
    jl      endCheckFunc        #jmp fo enf check
    cmp    $122,%bl             #check if small letter
    jg     endCheckFunc         #jmp fo enf check
swapToBig:                      #swap to bigger the char value as ascii table
    sub    $32,%bl              #swap to big
    jmp     endCheckFunc        #jmp fo enf check
swapToLittle:                   #swap to little
    add    $32,%bl              #swap to little the char value as ascii table
    jmp     endCheckFunc        #jmp fo enf check
endCheckFunc:                   #go to end func
    mov    %bl,(%r12)           #move the value to r12
    popq %rbx                   #pop rbx
    ret
    

.globl pstrijcmp
.type pstrijcmp, @function
pstrijcmp:
   
    #rdi -is pstring 1 dst
    #rsi -is pstring 2 src
    #rdx -index i
    #rcx -index j
    
    #r8 -save length of dst
    #r9 -save length of src
    #r10-index end cpy
    #rbx counter
    pushq   %r11                #return value
    pushq   %r12                #save pointer to rdi -is pstring 1 dst
    pushq    %r13               #save pointer rsi -is pstring 2 src
    pushq    %rbx               # index
    pushq %r8
    pushq %r9
    movq     %rdi,%r12          #save pointer to rdi -is pstring 1 dst
    movq     %rsi,%r13          #save pointer rsi -is pstring 2 src
    movq     %rdx,%r14          #save index i
    movq     %rcx,%r15          #save index j
    movq $-1,%rbx                #init counter
    movzbq  (%rdi),%r8         #r8 -save length of dst
    movzbq  (%rsi),%r9         #r9 -save length of src
    #rdx -i
    #r15 -j
    #r8 -save length of dst
    #r9 -save length of src
    
    # checkBorder
    cmpb    $0,%r14b  #if i smaller then 0
    jl      notValidCmp
    cmpb    %r15b,%r8b  # if j bigger the dst len
    jl      notValidCmp
    cmpb    %r15b,%r9b # if j bigger the src len
    jl      notValidCmp
    cmpb    %r14b,%r15b #if i bigger then j
    jl      notValidCmp
       
          run_to_i:
        leaq    1(%rbx),%rbx        #add 1 to counter 
        leaq    1(%r12),%r12        #go to the next char
        leaq    1(%r13),%r13        #go to the next char
        #cmpq    %r14,%rbx           #compare current to the end counter
        pushq %r15                  #push r15 as temp
        mov    %rbx,%r15             #move the value to r15
        cmpb    %r14b,%r15b           #compare current to the end counter
        popq %r15                   #pop r 15
        jl run_to_i           #if <= go to loop
    run_to_j:
        movq $0,%r11
        call comp_i_j
        cmpq $0,%r11
        jne end_cmpFunc
        leaq    1(%rbx),%rbx        #add 1 to counter 
        leaq    1(%r12),%r12        #go to the next char
        leaq    1(%r13),%r13        #go to the next char
        cmp    %r15b,%bl           #compare current to the end counter
        jle run_to_j           #if <= go to loop
    end_cmpFunc:  
        movq    %r11,%rax           #return the pointer pstring dst
        popq    %r9
        popq   %r8
         popq    %rbx
         popq    %r13
         popq   %r12 
         popq   %r11
        ret
    
    
comp_i_j:
    pushq %rbx
    pushq %rcx
    movb (%r12),%bl
    movb (%r13),%cl   
    cmp %bl,%cl
    jg oneIsSmaller
    jl oneIsBigger
    je end_comp_i_j
    
   same: 
        movq    $0,%r11                 #pstring 1 is bigger
        jmp end_comp_i_j
    oneIsBigger: 
        movq    $1,%r11                 #pstring 1 is bigger
        jmp end_comp_i_j
    oneIsSmaller:                        #pstring 1 is smalle
        movq    $-1,%r11                #return -1
    sameString:
    
    end_comp_i_j:
        popq %rcx
        popq %rbx
        ret
 notValidCmp:
    movq	   $notValidString,%rdi      #print invalid input
    movq	   $0,%rax
    call	   printf
    movq    $-2,%r11                #return -1
    jmp end_cmpFunc       
        
        
        
        
        	