bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ; (d+d-b)+(c-a)+d
    a db 10 ; -> 0A  (1byte in memory)
    b dw 20 ; -> 14 00 (2bytes in memory)
    c dd 300 ; -> 2C 01 00 00 (4bytes in memory) 
    d dq 1000 ; -> EDX:EAX(concatenation) E8 03 00 00 00 00 00 00

; our code starts here
segment code use32 class=code
    start:
    
        ;(d+d-b), where d-> quadword, b-> word 
        mov ebx, [d] ; EBX = 1000
        add ebx, [d] ; EBX = EDX+1000 = 2000

        mov ax, [b] ; AX = 20
        ; we convert the doubleword ax to quadword so we can substract it with the quadword d
        mov edx, 0 ; EDX = 0
        push dx 
        push ax
        pop eax ; EAX = 20
        
        sub ebx, eax ; EBX = EBX-EAX = 2000-20 = 1980
        
        
        ;(c-a), where c= doubleword, a=byte
        mov ecx, [c] ; ECX = 300
        
        mov eax, 0
        mov dx, 0
        mov al, [a] ; AL = 10
        ; we convert the byte ah to a doubleword so we can substract it with the doubleword c
        
        push dx
        push ax
        pop eax ; EAX = 10
        
        sub ecx, eax ; ECX = ECX-EAX = 300-10 = 290 
        
        ; (d+d-b)+(c-a)+d  

        add ebx, ecx ; EBX = 1980+290 = 2270
        mov eax, [d]
        add ebx, eax ; EBX = 2270 + 1000 = 3270
        
        ;sub 
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
