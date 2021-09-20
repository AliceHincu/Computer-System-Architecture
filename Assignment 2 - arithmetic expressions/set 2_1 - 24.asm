bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;(a-b-b-c)+(a-c-c-d)
    a db 80
    b db 10
    c db 20
    d db 5

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;(a-b-b-c)
        mov al, [a] ; AL = 80
        sub al, [b] ; AL = AL-10 = 70
        sub al, [b] ; AL = AL-10 = 60
        sub al, [c] ; AL = AL-20 = 40
        
        ;(a-c-c-d)
        mov bl, [a] ; BL = 80
        sub bl, [c] ; BL = BL-20 = 60
        sub bl, [c] ; BL = BL-20 = 40
        sub bl, [d] ; BL = BL-5 = 35
        
        ;(a-b-b-c)+(a-c-c-d)
        add al, bl ; AL = AL+BL = 40+35 = 75
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
