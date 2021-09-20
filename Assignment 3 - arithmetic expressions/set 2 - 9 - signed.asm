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
        ; (a-b+c*128)
        mov ax, [c] ; AX = 3
        mov cx, 128 ; CX = 128
        imul cx ; DX:AX . AX = 384, DX = 0
        mov cx, ax; CX = 384
        
        mov al, [a] ; AL = 3
        sub al, [b] ; AL = 3-b = 3-2 = 1
        cbw
        add ax, cx; AX = AX+CX = 1+384 = 385
        
        
        ; (a+b)
        mov cl, [a]; CL = 3
        add cl, [b]; CL = CL+b = 3+2 = 5
        
        ;(a-b+c*128)/(a+b) -> AL
        idiv cl ; AL = AX/CL = 385/5 = 77
    
        ; (a-b+c*128)/(a+b)+e-x
        cbw ; convert from AL to AX
        cwde ; convert from AX to EAX
        add eax, [e] ; EAX= EAX+e = 77+200 = 277
        mov edx, 0 ; EDX = 0
        cdq ; convert from EAX to EDX:EAX
        mov ebx, [x+4] ; EBX = 0
        mov ecx, [x] ; ECX = 100
        add eax, ecx  ; EAX = EAX+ECX = 277+100=377
        adc edx, ebx ; EDX = EDX+EBX+CF = 0+0+0=0
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
