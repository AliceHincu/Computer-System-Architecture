bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir dd 12345678h, 1A2C3C4Dh, 98FCDD76h, 12783A2Bh
    ;12345678h = 0001_0010_0011_0100_0101_0110_0111_1000 = 13 of 1's
    ;1A2B3C4Dh = 0001_1010_0010_1100_0011_1100_0100_1101 = 14 of 1's
    ;98FCDD76h = 1001_1000_1111_1100_1101_1101_0111_0110 = 20 of 1's
    ;12783A2Bh = 0001_0010_0111_1000_0011_1010_0010_1011 = 14 of 1's
    len2 equ $-sir
    len equ ($-sir)/4
    d times len2 db 0FFh 
    doi db 2  ;variabile used for testing divisibility to 2
; our code starts here
segment code use32 class=code
    start:
        ; Being given a string of doublewords, build another string of doublewords which will include only the doublewords from the given string which ; have an even number of bits with the value 1.
        
        mov esi, sir  ;in eds:esi we will store the FAR address of the string "sir"
        cld  ;parse the string from left to right(DF=0).    
        mov ecx, len  ;we will parse the elements of the string in a loop with len iterations.
        mov ebx, 0  ;index for result string 
        
        jecxz Sfarsit  ;skip loop if len=0  
        repeta:
            lodsd  ;in eax we will have the doubleword
            
            mov dl, 0; we count here the 1's
            ;how many 1's are in the doubleword
            ;test = eax & 000_0...._0001
            parcurgere:
                test eax, 1
                
                jz ignore_if_zero
                    inc dl
                ignore_if_zero:
                
                shr eax, 1
                cmp eax, 0 ; if eax is not 0, go on with parcurgere
                jnz parcurgere
            
            ;we need to find out if it has an even number of bits with the value 1.
            mov al, dl
            mov ah, 0
            div byte[doi]
            cmp ah, 0; if the remainder=0 => div to 2
            jnz ignore_if_not_even
                cld
                sub esi, 4 ;we extract 4 so we can get the doubleword again
                lodsd
                mov [d+ebx], eax
                add ebx, 4
            ignore_if_not_even:
                
        loop repeta;if there are more elements (ecx>0) resume the loop.
        Sfarsit:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
