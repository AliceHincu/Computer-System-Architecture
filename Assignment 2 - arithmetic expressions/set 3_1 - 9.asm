bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; 3*[20*(b-a+2)-10*c]+2*(d-3)
    a db 10
    b db 20
    c db 10
    d dw 500

; our code starts here
segment code use32 class=code
    start:
        ; (b-a+2)
        mov ax, [b] ; AX = 20
        sub ax, [a] ; AX = AX-10 = 10
        add ax, 2 ; AX = AX+2 = 12
        
        ; 20*(b-a+2)
        mov bl, 20 ; BL = 20
        mul bl ; AX =  AX * BL = 12*20 = 240
        mov bx, ax ; BX = 240
        
        ; 10*c
        mov al, 10 ; AL = 10
        mov cl, [c] ; CL = 10
        mul cl ; AX = AL*BL = 10*10 = 100

        ;3*[20*(b-a+2)-10*c]
        sub bx, ax ; BX = 240-100 = 140
        mov ax, 3; AX = 3
        mov dx, 0; DX = 0
        mul bx ; AX = AX*BX = 3*140 = 420 , DX  =0
        mov bx, ax ; BX = 420
        
        ;2*(d-3)
        mov cx, [d] ; CX = 500
        sub cx, 3 ; CX = CX-3 = 497
        mov ax, 2 ; AX = 2
        mul cx; AX = AX*CX = 2*497 = 994
        
        ; 3*[20*(b-a+2)-10*c]+2*(d-3)
        add bx, ax; BX = BX+AX = 420 + 994 = 1414
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
