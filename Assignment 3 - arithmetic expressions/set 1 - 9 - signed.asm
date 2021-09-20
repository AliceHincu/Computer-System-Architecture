bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; a-d+b+b+c
    a db 10 ; -> 0A  (1byte in memory)
    b dw 20 ; -> 14 00 (2bytes in memory)
    c dd 300 ; -> 2C 01 00 00 (4bytes in memory) 
    d dq 1000 ; -> E8 03 00 00 00 00 00 00

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, [a] ; AL = 10
        cbw ; CONVERTS AL TO AX = 10
        add ax, [b] ; AX = AX+b = 10+20 = 30
        add ax, [b] ; AX = AX+b = 30+20 = 50
        cwde ; CONVERTS AX TO EAX = 50
        add eax, [c] ; EAX = EAX+c = 50+300 = 350
        sub eax, [d] ; EAX = EAX-d = 350-1000 = -650
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
