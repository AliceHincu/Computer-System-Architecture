bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    M dd 0011_1001_0101_0100_0111_0111_0101_0111b
    MNew dd 0

; our code starts here
segment code use32 class=code
    start:
        ; Given the doubleword M, compute the doubleword MNew as follows:
        ;the bits 0-3 a of MNew are the same as the bits 5-8 a of M.
        ;the bits 4-7 a of MNew have the value 1
        ;the bits 27-31 a of MNew have the value 0
        ;the bits 8-26 of MNew are the same as the bits 8-26 a of M.
        
        ;we save the result in ecx
        mov ecx, 0
        
        ;the bits 0-3 a of MNew are the same as the bits 5-8 a of M.
        mov eax, [M]
        and eax, 0000_0000_0000_0000_0000_0001_1110_0000b ; i'm isolating the bits 5-8
        ror eax, 5
        or ecx, eax ; ecx = 0000_0000_0000_0000_0000_0000_0000_1010
        
        ;the bits 4-7 a of MNew have the value 1
        or ecx, 0000_0000_0000_0000_0000_0000_1111_0000b ; ecx = 0000_0000_0000_0000_0000_0000_1111_1010
        
        ;the bits 27-31 a of MNew have the value 0
        and ecx, 0000_1111_1111_1111_1111_1111_1111_1111b ; ecx = 0000_0000_0000_0000_0000_0000_1111_1010
        
        ;the bits 8-26 of MNew are the same as the bits 8-26 a of M.
        ;--I'm saving [M] in eax again since it was modified last time
        mov eax, [M]
        and eax, 0000_0111_1111_1111_1111_1111_0000_0000b
        or ecx, eax ; ecx = 0000_0001_0101_0100_0111_0111_1111_1010
        
        ; we move the result from the register to the result variable
        mov  [MNew], ecx 
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
