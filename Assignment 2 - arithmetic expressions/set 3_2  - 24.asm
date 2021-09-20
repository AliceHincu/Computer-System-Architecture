bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; [(a-d)+b]*2/c
    a db 100
    b db 10
    c db 40
    d db 30

; our code starts here
segment code use32 class=code
    start:
        ; [(a-d)+b]
        mov bl, [a] ; BL = 100
        sub bl, [d] ; BL = BL-30 = 70
        add bl, [b] ; BL = BL+10 = 80
        
        ; [(a-d)+b]*2/c
        mov al, 2 ; AL = 2
        mul bl ; AX = AL*BL = 2*80 = 160
        mov cl, [c] ; CL = 40
        div cl ; AL = AX/CL = 160/40 = 4 
        
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
