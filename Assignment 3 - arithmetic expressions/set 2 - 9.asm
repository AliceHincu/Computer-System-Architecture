bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; (a-b+c*128)/(a+b)+e-x; a,b-byte; c-word; e-doubleword; x-qword
    a db 3
    b db 2
    c dw 3
    e dd 200
    x dq 100
; our code starts here
segment code use32 class=code
    start:
        ;(a-b+c*128) -> AX
        mov ax, [c]; AX = 3
        mov bx, 128; BX = 128
        mul bx; (in DX:AX), AX = 384, DX = 0
        
        mov bl, [a]; BL = 3
        sub bl, [b]; BL = BL-b = 3-2 = 1
        mov bh, 0; BH = 0 => BX = 1
        add ax, bx; AX = AX+BX = 384+1 = 385
        
        ;(a+b) -> CL 
        mov cl, [a]; CL = 3
        add cl, [b]; CL = CL+b = 3+2 = 5
        
        ;(a-b+c*128)/(a+b) -> AL
        div cl ; AL = AX/CL = 385/5 = 77
        
        ;(a-b+c*128)/(a+b)+e-x
        mov ah, 0 ; => converting AL -> AX
        push dx
        push ax
        pop eax ; EAX = 77
        mov ebx, [e] ; EBX = 200
        add eax, ebx ; EAX = EAX + EBX = 277
        
        mov edx, 0; EDX = 0
        mov ecx, [x]
        mov ebx, [x+4]
        sub eax, ecx ; EAX = EAX-ECX = 277-100 = 177
        sbb edx, ebx ; EDX = EDX-EBX-CF = 0
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
