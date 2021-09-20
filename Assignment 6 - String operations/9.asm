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
    len equ ($-sir)/4  ;the length of the string (in doublewords)
    d times len db 0FFh  ;we initialize with FF
    doi db 2  ;variabile used for testing divisibility to 2
    
; our code starts here
segment code use32 class=code
    start:
        ; A list of doublewords is given. Starting from the low part of the doubleword, obtain the doubleword made of the high even bytes of the low ;words of each doubleword from the given list. If there are not enough bytes, the remaining bytes of the doubleword will be filled with the ;byte FFh.Ex:
        ;Given the string of doublewords:
        ;s DD 12345678h, 1A2C3C4Dh, 98FCDD76h, 12783A2Bh
        ;obtain the doubleword:
        ;d DD FF3A3C56h
        
        mov esi, sir  ;in eds:esi we will store the FAR address of the string "sir"
        cld  ;parse the string from left to right(DF=0).    
        mov ecx, len  ;we will parse the elements of the string in a loop with len iterations.
        mov ebx, len-1  ;index for result string (we put it backward)
        
        jecxz Sfarsit  ;skip loop if len=0  
        repeta:
            mov eax, 0  ;clear eax
            lodsw  ;in ax we will have the low word (least significant) of the current doubleword from the string
                   ;The word from the address <DS:ESI> is loaded in AX. ESI+=2
            dec esi  ;ESI = 1 (so we can acces the low byte)
            lodsb  ;in al we will have the low byte (least significant) of the current word from the string
            mov ah, 0  ;now eax=ax=al=low byte
            mov dl, al  ;we make a copy
            
            ;now we check if the number is even
            div byte[doi]  ;check whether ax is divisible to 2
            cmp ah, 0  ;if the remainder is 0, we put the byte in the string d. 
				;else we skip & check the next doubleword.
            
            ;if the remainder is not zero we jump
            jnz par
                mov [d+ebx], dl  ;we put in the result string the low byte backwards.
                dec ebx
            
            par:
            ;go to the next double word
            inc esi
            inc esi
        loop repeta;if there are more elements (ecx>0) resume the loop.
        Sfarsit:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
