bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ((a + b) + (a + c) + (b + c)) - d
    a db 10 ; -> 0A  (1byte in memory)
    b dw 20 ; -> 14 00 (2bytes in memory)
    c dd 300 ; -> 2C 01 00 00 (4bytes in memory) 
    d dq 1000 ; -> E8 03 00 00 00 00 00 00
    sum dq 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;(a + b), where a -> byte, b -> word
        ;we convert from byte to word ([a])
        mov al, [a] ; AL = 10
        mov ah, 0 ; AH = 0 => AX = 10
        
        mov bx, [b] ; BX = 20
        add bx, ax ; BX = BX+AX = 10+20 = 30
        
        ;(a + c), where a -> word, c -> doubleword
        ;we convert from word to doubleword ([a])
        mov dx, 0 ; DX = 0
        push dx
        push ax
        pop eax ; EAX = 0
        
        mov ecx, [c] ; CX = 300
        add ecx, eax; ECX = ECX+EAX = 300+10 = 310
        
        ;(b + c), where b -> word, c -> doubleword
        ;we convert from word to doubleword ([b])
        mov eax, 0 ; EAX = 0
        mov ax, [b] ; AX = 20
        push dx
        push ax
        pop eax ; EAX = 20
        mov edx, eax ; we make a copy of b that is dword. EDX = B = 20
        
        add eax, [c] ; EAX = EAX + c = 20 + 300 = 320
        
        ;(a + b) + (a + c) + (b + c)
        ;EDX + ECX + EAX 
        
        add [sum], edx;
        add [sum], ecx ; EDX = EDX+ECX = 20+310 = 330
        add [sum], eax ; EDX = EDX+EAX = 330+320 = 650
        
        ;((a + b) + (a + c) + (b + c)) - d, where d -> qword
        mov eax, [sum] ; EAX = 650
        mov edx, [sum+4] ; EDX:EAX = 650
        
        ;we move d in ecx (d is EBX:ECX)
        mov ebx, [d+4]; EBX = 0
        mov ecx, [d] ; ECX = 1000
        sub eax, ecx ; EAX = EAX-ECX = 650-1000 = -350
        sbb edx, ebx ;EDX = EDX-EBX-CF = 0-0-1 = -1
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
