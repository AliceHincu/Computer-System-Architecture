; The code below will print message ”n=”, then will read from keyboard the value of perameter n.
bits 32

global start        

; declare extern functions used by the programme
extern exit, printf, scanf ; add printf and scanf as extern functions            
import exit msvcrt.dll    
import printf msvcrt.dll    ; tell the assembler that function printf is found in msvcrt.dll library
import scanf msvcrt.dll     ; similar for scanf
                          
segment data use32 class=data
	a dd  0       ; in this variable we'll store the value read from the keyboard
    b dd  0
    k dd  3
    doi dw 2  ;variabile used for testing divisibility to 2
    result times 16 db 0FFh  ;we initialize with FF
    ; char strings are of type byte
	message_a  db "a=", 0  ; char strings for C functions must terminate with 0(value, not char)
    message_b  db "b=", 0;
	format  db "%d", 0  ; %d <=> a decimal number (base 10)
    print_message db "Nr is %c apples", 0 
    print_message1 dw "1", 0
    print_message0 dw "0", 0
    print_empty dw "", 0
    
segment code use32 class=code
    start:
        ;Two numbers a and b are given. Compute the expression value: (a/b)*k, where k is a constant value defined in data segment. Display the ;expression value (in base 2).
       
        ; will call printf(message) => will print "a="
        ; place parameters on stack 
        
        push dword message_a ; ! on the stack is placed the address of the string, not its value
        call [printf]      ; call function printf for printing
        add esp, 4*1       ; free parameters on the stack; 4 = size of dword; 1 = number of parameters
                                                   
        ; will call scanf(format, a) => will read a number in variable a
        ; place parameters on stack from right to left
        push dword a      ; ! address of a, not value
        push dword format
        call [scanf]       ; call function scanf for reading
        add esp, 4 * 2     ; free parameters on the stack
                           ; 4 = size of a dword; 2 = no of perameters
        
        ; same with b
        push dword message_b 
        call [printf]     
        add esp, 4*1       

        push dword b    
        push dword format
        call [scanf]       
        add esp, 4 * 2

        ; we compute a/b
        mov eax, [a]
        mov ebx, [b]
        mov edx, 0
        idiv ebx ; EAX ← EDX:EAX / EBX, EDX ← EDX:EAX % EBX
        
        ; we compute a/b * k
        mov edx, [k]
        imul edx ; EDX:EAX ← EAX * EDX
        
        mov ecx, 0
        mov ecx, 32
        start_loop2:
            rol edx, 1
            pushad
            jnc ignore_if_not_one1 ;if the bit is one
                ;mov dl, 1
                ;mov [result+esi], dl
                push dword print_message1 ; ! on the stack is placed the address of the string, not its value
            ignore_if_not_one1:
            popad
            pushad
            jc ignore_if_not_zero1 ; if the bit is zero
                ;mov dl, 0
                ;mov [result+esi], dl 
                push dword print_message0 ; ! on the stack is placed the address of the string, not its value
            ignore_if_not_zero1:
            call [printf]      ; call function printf for printing 
            add esp, 4 * 1
            popad
        loop start_loop2

        mov ecx, 0
        mov ecx, 32
        start_loop:
            rol eax, 1
            pushad
            jnc ignore_if_not_one ;if the bit is one
                ;mov dl, 1
                ;mov [result+esi], dl
                push dword print_message1 ; ! on the stack is placed the address of the string, not its value
            ignore_if_not_one:
            popad
            pushad
            jc ignore_if_not_zero ; if the bit is zero
                ;mov dl, 0
                ;mov [result+esi], dl 
                push dword print_message0 ; ! on the stack is placed the address of the string, not its value
            ignore_if_not_zero:
            call [printf]      ; call function printf for printing 
            add esp, 4 * 1
            popad
        loop start_loop
        
        ;push dword result
        ;push dword print_message ; ! on the stack is placed the address of the string, not its value
        ;call [printf]      ; call function printf for printing 
        ;add esp, 4 * 2     ; free par

        
        ; exit(0)
        push dword 0      ; place on stack parameter for exit
        call [exit]       ; call exit to terminate the program