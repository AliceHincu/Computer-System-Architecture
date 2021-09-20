bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;(a + b + c) - d + (b - c)
    a db 10 ; -> 0A  (1byte in memory)
    b dw 20 ; -> 14 00 (2bytes in memory)
    c dd 300 ; -> 2C 01 00 00 (4bytes in memory) 
    d dq 1000 ; -> E8 03 00 00 00 00 00 00
    result dq 0
; our code starts here
segment code use32 class=code
    start:
        ;(a + b + c)
        mov al, [a] ; AL = 10
        cbw
        add ax, [b] ; AX = AX+20 = 10+20 = 30
        cwde
        add eax, [c]; EAX = EAX+300 = 30+300 = 330
        mov ebx, eax ; EBX = 330
        
        ;(b - c)
        mov eax, 0
        mov ax, [b] ; AX = 20
        cwde
        sub eax, [c] ; EAX = EAX-c = 20-300 = -280
        
        ;(a + b + c) - d + (b - c)
        add eax, ebx ; EAX = EAX+EBX = (-280)+330 = 50
        cdq ; result is in EDX:EAX
        mov ecx, [d]
        mov ebx, [d+4] ; d is in EBX:ECX
        
        sub eax, ecx ; EAX = -950
        sbb edx, ebx ; EDX = -1       
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
