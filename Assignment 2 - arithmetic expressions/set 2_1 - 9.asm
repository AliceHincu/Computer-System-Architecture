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
    ;(d+d-b)+(c-a)+d
    a db 10
    b db 25
    c db 5
    d db 40

; our code starts here
segment code use32 class=code
    start:
        ;for 128<d<256, we need ax not al.
        ;I wrote the code for the variables that I chose.
        ;(d+d-b)
        mov al, [d] ; AL = 40
        add al, [d] ; AL = AL+40 = 80
        sub al, [b] ; AL = AL-25 = 55
        
        ;(c-a)
        mov bl, [c] ; BL = 5
        sub bl, [a] ; BL = BL-10 = -5
        
        ;(d+d-b)+(c-a)
        add al, bl ; AL = AL+BL = 55+(-5)= 50
        
        ;(d+d-b)+(c-a)+d
        add al, [d] ; AL =  AL+40 = 90
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
