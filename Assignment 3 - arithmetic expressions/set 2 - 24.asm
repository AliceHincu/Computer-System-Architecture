bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;a-(7+x)/(b*b-c/d+2); a-doubleword; b,c,d-byte; x-qword
    a dd 300
    b db 10
    c db 100
    d db 5
    x dq 157

; our code starts here
segment code use32 class=code
    start:
        ;(b*b-c/d+2)
        ;b*b
        mov eax, 0
        mov al, [b] ; AL = 10
        mul al ; AX = AL*AL = 100
        mov bx, ax ; BX = 100
        ;c/d
        mov al, [c]; AL = 100
        mov ah, 0 ; we convert from AL to AX =100
        mov cl, [d] ; CL = 5
        div cl ; AL = AX/CL; = 100/5 = 20
        ;b*b-c/d+2
        sub bx, ax ; BX = BX-AX = 100-20 =80
        add bx, 2 ; BX = 82
        
        ;(7+x)
        mov EAX, [x] ; EAX = 157
        mov EDX, [x+4] ; EDX = 0 => DX = 0
        add eax, 7 ; EAX = 164 = > AX = 164
        
        ;(7+x)/(b*b-c/d+2)
        mov cx, bx
        mov ebx, 0
        mov bx, cx
        div ebx ; EAX = EDX:EAX/EBX = 164/82 = 2 = quotient, EDX ← EDX:EAX % EBX = 0 = reminder
        
        ;a-(7+x)/(b*b-c/d+2)
        mov ebx, [a] ; EBX = 300    
        sub ebx, eax; EBX = EBX-EAX = 300-2 = 298
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
