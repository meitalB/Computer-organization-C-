#311124283 Meital Birka
	.section	.rodata	#read only data section
strLenAll: .string	"first pstring length: %d, second pstring length: %d\n"
oldChar: .string "old char: %c"
newChar:.string ", new char: %c, "
strPstring:.string "first string: %s, second string: %s\n"
srtPrintLen: .string "length: %d, string: %s\n"
strCmp: .string "compare result: %d\n"
charFormat: .string "\n%c"
intFormat: .string "%d"
stringFormat: .string "%s"
str8:	.string	"invalid option!\n"
#    Building the jump table:
.align 8                         # Align address to multiple of 8
.JUMP_TABLE:
.quad .String_LENGTH              # Case 50: String_LENGTH
.quad .REPLACE_CHAR               # Case 51: REPLACE_CHAR
.quad .STR_IJ_CPY                 # Case 52: STR_IJ_CPY
.quad .SWAP_CASE                  # Case 53: SWAP_CASE
.quad .CMP_RES                    # Case 54: CMP_RES
.quad .INVALID_OPTION             # Case else:INVALID_OPTION
	.text	#the beginnig of the code
#the func take the option and run the right funtion 
.globl	run_func	#the label "main" is used to state the initial point of this program
	.type	run_func, @function	# the label "main" representing the beginning of a function
run_func:
#we save the old registers
#rbx - save pstring2
#r12 - save pstring1
    
    pushq   %rbp		        #save the old frame pointer
    movq    %rsp,%rbp	        #create the new frame pointer
    pushq   %rbx                 #push the address of rbx before 
    pushq   %r12                 #push the address of r12 before    
    movq    %rdx,%rbx            #pass the argument2 to rbx for later
    movq    %rsi,%r12            #pass the argument1 to rcx for later
   
# Set up the jump table acces
    leaq    -50(%rdi),%r14       # Compute xi = input-50
    cmpq     $4,%r14             # Compare xi:4
    ja .INVALID_OPTION           # if >, goto default-case
    jmp *.JUMP_TABLE(,%r14,8)    # Goto jt[xi]
# Case 50
.String_LENGTH:                  #  String_LENGTH
#the func print the length off both of pstring
    pushq %r14                   #push the address of r14 before 
    pushq %r15                   #push the address of r15 before 
#print the length of the first pstring
    movq    %r12,%rdi       #pass the argument1 to rdi
    
#calculate the length pstring 1
    call pstrlen                #call func
    movq   %rax,%r14	       #passing the results  for printf.
#calculate the length pstring 2
    movq   %rbx,%rdi            #move argument 2 to rdi
    call pstrlen                #call func
    movq   %rax,%r15	       #passing the results - the second parameter for printf.
#print
    movq    %r14,%rsi           #move pointer from r14 to rsi
    movq    %r15,%rdx           #move pointer from r15 to rdx
    movq	   $strLenAll,%rdi      #passing the string the first parameter for printf.
    movq	   $0,%rax              #needed befor print
    call	   printf	       #calling to printf AFTER we passed its parameters.
    popq %r15                   #pop r15
    popq %r14                   #pop r14
    jmp     .L3                  # Goto done

# Case 51
.REPLACE_CHAR: # REPLACE_CHAR
#replace chars as asked at the question from old char to new char
#r14 - save the old char
#r15 - save the new char
    pushq %r14                  #push the address of r14 before
    pushq %r15                  #push the address of r15 before
#scanf old char  
    leaq    -1(%rsp),%rsp       #alloc 1 char length for the length of pstring1 in the stack
    movq    %rsp,%rsi           #save the address of value to a register
    movq	   $charFormat,%rdi     #passing the string the first parameter for printf.
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan length of pstring1
    movq (%rsp),%r14            #put the value in r14
#scanf new char 
    leaq    -1(%rsp),%rsp       #alloc 1 char length for the length of pstring2 in the stack
    movq    %rsp,%rsi           #save the address of value to a register
    movq	    $charFormat,%rdi    #passing the string the second parameter for printf.
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan length of pstring2
    movq    (%rsp),%r15         #put the vale in r14
#print old char
    movq    %r14,%rsi           #move r14 to the arguments of func
    movq	   $oldChar,%rdi	       #passing the string the first parameter for printf.
    movq	   $0,%rax              #needed before print
    call    printf	       #print old char.
#print new char    
    movq    %r15,%rsi           #move r15 to the arguments of func
    movq	   $newChar,%rdi	       #passing the string the first parameter for printf.
    movq	   $0,%rax              #needed before print
    call    printf	       #print new char.
#call replace char    
    movq    %r12,%rdi           #move r12 to the arguments of func
    movq    %r14,%rsi           #move r14 to the arguments of func
    movq    %r15,%rdx           #move r15 to the arguments of func
    call replaceChar            #call replace char func for pstring1
    movq    %rax,%r12           #save the result in r12
#call replace char    
    movq    %rbx,%rdi           #move r12 to the arguments of func
    movq    %r14,%rsi           #move r14 to the arguments of func
    movq    %r15,%rdx           #move r15 to the arguments of func
    call replaceChar            #call replace char func for pstring 2
    movq    %rax,%rbx            #save the result in r1bx
#print result    
    leaq    1(%r12),%rsi        #pass for print
    leaq    1(%rbx),%rdx        #pass for print
    movq	   $strPstring,%rdi     #passing the string the first parameter for printf.
    movq	   $0,%rax              #needed before print
    call    printf        	#print old char.
    
    popq %r15                   #pop r15
    popq %r14                   #pop r14
    
     jmp    .L3 # Goto done
# Case 52
.STR_IJ_CPY: # STR_IJ_CPY
    pushq %r14 #save i
    pushq %r15 #save j
#scanf i
    leaq    -4(%rsp),%rsp       #alloc 1 int length for the length of pstring1 in the stack
    movq    %rsp,%rsi           #save the address of value to a register
    movq	   $intFormat,%rdi     #passing the string the first parameter for printf.
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan length of pstring1
    movq    (%rsp),%r14            #put the value in r14
#scanf j     
    leaq    -4(%rsp),%rsp       #alloc 1 int length for the length of pstring2 in the stack
    movq    %rsp,%rsi           #save the address of value to a register
    movq	    $intFormat,%rdi     #passing the string the second parameter for printf.
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan length of pstring2
    movq    (%rsp),%r15            #put the vale in r14
#call func
    movq    %r12,%rdi           #move r12 to the arguments of func
    movq    %rbx,%rsi           #move rbx to the arguments of func
    movq    %r14,%rdx           #move r15 to the arguments of func
    movq    %r15,%rcx           #move r15 to the arguments of func
    call    pstrijcpy            #call replace char func for pstring1
    movq    %rax,%r12           #save the result in r12
#print
    movzbq  (%r12),%rsi         #pass for print
    leaq    1(%r12),%rdx        #pass for print
    movq	   $srtPrintLen,%rdi    #passing the string the first parameter for printf.
    movq	   $0,%rax              #needed before print
    call    printf              #print old char.
#print
    movzbq    (%rbx),%rsi        #pass for print
    leaq    1(%rbx),%rdx        #pass for print
    movq	   $srtPrintLen,%rdi    #passing the string the first parameter for printf.
    movq	   $0,%rax              #needed before print
    call    printf       	#print old char
   
    popq %r15                   #pop r15
    popq %r14                   #pop r14
     jmp .L3 # Goto done
# Cases 53
.SWAP_CASE: # SWAP_CASE
    movq %r12,%rdi              #move r12 to the arguments of func
    call swapCase               #call func swap case 
    movq    %rax,%r12           #save the result in r12
   
    movzbq    (%r12),%rsi        #pass for print
    leaq    1(%r12),%rdx        #pass for print
    movq	   $srtPrintLen,%rdi    #passing the string the first parameter for printf.
    movq	   $0,%rax              #needed before print
    call    printf        	#print old char.#print length string1.
#call func swap   
    movq %rbx,%rdi              #move rbx to the arguments of func
     call swapCase              #call swap func
    movq    %rax,%rbx           #save the result in r12
#print result   
    movzbq   (%rbx),%rsi        #pass for print
    leaq    1(%rbx),%rdx        #pass for print
    movq	   $srtPrintLen,%rdi    #passing the string the first parameter for printf.
    movq	   $0,%rax              #needed before print
    call    printf 
    
     jmp    .L3 # Goto done
# Cases 54
.CMP_RES: # CMP_RES
    pushq %r14                  #save i
    pushq %r15                  #save j
#scanf i
    leaq    -4(%rsp),%rsp       #alloc 1 int length for the length of pstring1 in the stack
    movq    %rsp,%rsi           #save the address of value to a register
    movq	   $intFormat,%rdi     #passing the string the first parameter for printf.
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan length of pstring1
    movq (%rsp),%r14            #put the value in r14
#scanf j     
    leaq    -4(%rsp),%rsp       #alloc 1 int length for the length of pstring2 in the stack
    movq    %rsp,%rsi           #save the address of value to a register
    movq	    $intFormat,%rdi     #passing the string the second parameter for printf.
    movq    $0,%rax             #needed before scanf
    call    scanf               #scan length of pstring2
    movq    (%rsp),%r15            #put the vale in r14
#call func str cmp
    movq    %r12,%rdi           #move r12 to the arguments of func
    movq    %rbx,%rsi           #move rbx to the arguments of func
    movq    %r14,%rdx           #move r15 to the arguments of func
    movq    %r15,%rcx           #move r15 to the arguments of func
    call pstrijcmp              #call replace char func for pstring1
    movq    %rax,%rsi           #pass for print
#print result     
    movq	   $strCmp,%rdi         #passing the string the first parameter for printf.
    movq	   $0,%rax              #needed before print
    call    printf        	#print old char.

    popq %r15                   #pop r15
    popq %r14                   #pop r14
    jmp    .L3 # Goto done
 # Default case
.INVALID_OPTION: #INVALID_OPTION
    movq	   $str8,%rdi	        #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).
    movq	   $0,%rax               #needed before prinf
    call    printf		#calling to printf AFTER we passed its parameters.

# Return result
.L3: # done:
    popq    %rbx                #save last rbx
    popq    %r12                #save last r12
    
    movq	   $0, %rax	        #return value is zero (just like in c - we tell the OS that this program finished seccessfully)
    movq	   %rbp, %rsp	        #restore the old stack pointer - release all used memory.
    popq   %rbp		        #restore old frame pointer (the caller function frame)
    ret			        #return to caller function (OS)
