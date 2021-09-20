bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0111_0111_0101_0111b ; 
    b db 1011_1110b
    c dd 0

; our code starts here
segment code use32 class=code
    start:
        ;  Given the word A and the byte B, compute the doubleword C as follows:
        ;the bits 0-3 of C are the same as the bits 6-9 of A
        ;the bits 4-5 of C have the value 1
        ;the bits 6-7 of C are the same as the bits 1-2 of B
        ;the bits 8-23 of C are the same as the bits of A
        ;the bits 24-31 of C are the same as the bits of B
        
        ;we save the doubleword C in ECX (now it's just gonna be zeros)
        mov ecx, 0
        
        ; first, I'm converting the word A into a doubleword
        ; --save the word A in EAX
        mov eax, 0 ;
        mov ax, [a] ;now the value of the word [a] is stored in eax and the doubleword [a] is stored in edx:eax 
        
        ; second, I'm converting the byte B into a doubleword
        ; --save the byte B in EBX
        mov ebx, 0
        mov bl, [b]
        
        ;the bits 0-3 of C are the same as the bits 6-9 of A
        and eax, 0000_0000_0000_0000_0000_0011_1100_0000b ; I'm isolating the bits 6-9
        ror eax, 6 
        or ecx, eax ; we put the bits into the result => ecx = 0000_0000_0000_0000_0000_0000_0000_1101
        
        ;the bits 4-5 of C have the value 1
        ; -- we force the value of bits 4-5 of the result to the value 1
        or ecx, 0000_0000_0000_0000_0000_0000_0011_0000b ; ecx = 0000_0000_0000_0000_0000_0000_0011_1101
        
        ;the bits 6-7 of C are the same as the bits 1-2 of B
        and ebx, 0000_0000_0000_0000_0000_0000_0000_0110b ; I'm isolating the bits 1-2
        rol ebx, 5
        or ecx, ebx ; ecx = 0000_0000_0000_0000_0000_0000_1111_1101
        
        ;the bits 8-23 of C are the same as the bits of A
        ; --I'm saving [a] in eax again since it was modified last time
        mov eax, 0
        mov ax, [a]
        ; --we isolate and put the bits into the result
        and eax, 0000_0000_1111_1111_1111_1111_0000_0000b
        or ecx, eax ; ecx = 0000_0000_0000_0000_0111_0111_1111_1101 
        
        ;the bits 24-31 of C are the same as the bits of B
        ; --I'm saving [b] in ebx again since it was modified last time
        mov ebx, 0
        mov bl, [b]
        ; --we isolate and put the bits into the result
        and ebx, 1111_1111_0000_0000_0000_0000_0000_0000b
        or ecx, ebx ; ecx = 0000_0000_0000_0000_0111_0111_1111_1101 
        
        ; we move the result from the register to the result variable
        mov  [c], ecx 
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
