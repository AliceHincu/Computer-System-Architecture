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
    result dd 0
    ; char strings are of type byte
	message_a  db "a=", 0  ; char strings for C functions must terminate with 0(value, not char)
    message_b  db "b=", 0;
	format  db "%d", 0  ; %d <=> a decimal number (base 10)
    
segment code use32 class=code
    start:
        ;Read two numbers a and b (base 10) from the keyboard and calculate: (a+b)/(a-b). The quotient will be stored in a variable called "result" ;(defined in the data segment). The values are considered in signed representation.
       
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

        ; we save the sum=a+b in eax
        mov eax, [a]
        add eax, [b]
        
        ;we save the substraction=a-b in ebx
        mov ebx, [a]
        sub ebx, [b]
        
        mov edx, 0
        idiv ebx ; EAX ← EDX:EAX / EBX, EDX ← EDX:EAX % EBX
        
        mov [result+2], edx
        mov [result], eax
        

        
        ; exit(0)
        push dword 0      ; place on stack parameter for exit
        call [exit]       ; call exit to terminate the program