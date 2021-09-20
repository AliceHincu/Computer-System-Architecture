bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;(2*d+e)/a
    a db 5
    d db 10
    e dw 5

; our code starts here
segment code use32 class=code
    start:
        ;(2*d+e)
        mov al, 2 ; AL = 2
        mov bl, [d] ; BL = 10
        mul bl ; AX = AL*BL = 2*10 = 20
        add ax, [e] ; AX = AX+5 = 25
        
        ;(2*d+e)/a
        mov bl, [a] ; BL = 5
        div bl ; AL = AX/BL = 25/5 = 5
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
