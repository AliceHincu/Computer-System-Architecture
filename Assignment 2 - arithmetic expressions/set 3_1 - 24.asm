bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;( 10*a-5*b)+(d-5*c)
    a db 10
    b db 20
    c db 10
    d dw 500

; our code starts here
segment code use32 class=code
    start:
        ;10*a
        mov al, 10 ; AL = 10
        mov bl, [a] ; BL = 10
        mul bl ; AX = AL*BL = 10*10 = 100
        mov bx, ax ; BX = 100
        
        ;5*b
        mov al, 5 ; AL = 5
        mov cl, [b] ; CL = 20
        mul cl ; AX = AL*CL = 5*20 = 100
        mov cx, ax ; CX = 100
        
        ;(10*a-5*b)
        sub bx, cx ; BX = BX-CX = 100-100 = 0
        
        ;5*c
        mov al, 5 ; AL = 5
        mov cl, [c] ; CL = 10
        mul cl ; AX = AL*CL = 5*10 = 50
        
        ;(d-5*c)
        mov dx, [d] ; DX = 500
        sub dx, ax ; DX = DX-AX = 500-50 = 450
        
        ;(10*a-5*b)+(d-5*c)
        add bx, dx ; BX = BX+DX = 0 + 450 = 450
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
