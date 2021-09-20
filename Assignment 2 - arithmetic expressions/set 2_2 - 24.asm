bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; (a-c)+(b-d)
    a dw 1700
    d dw 1100
    b dw 300
    c dw 500

; our code starts here
segment code use32 class=code
    start:
        ; (a-c)
        mov ax, [a] ; AX = 1700
        sub ax, [c] ; AX = AX-500 = 1200
        
        ; (b-d)
        mov bx, [b] ; BX = 300
        sub bx, [d] ; BX = BX-1100 = -800
        
        ; (a-c)+(b-d)
        add ax, bx ; AX = AX+BX = 1200+(-800) = 400
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
