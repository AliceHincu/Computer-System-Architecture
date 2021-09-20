bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 2, 1, -3, 0 ; declare string of bytes a
    lenghtA equ $-a ; compute the length of the string "a" in lenghtA
    b db 4, 5, 7, 6, 2, 1 ; declare string of bytes b
    lenghtB equ $-b ; compute the length of the string "b" in lenghtB
    r times lenghtA+lenghtB db 0 ; reserve l bytes for the result string and initialize it

; our code starts here
segment code use32 class=code
    start:
         ;Two byte strings A and B are given. Obtain the string R by concatenating the elements of B in reverse order and the elements of A in revers ;order.
         ;Example:
         ;A: 2, 1, -3, 0
         ;B: 4, 5, 7, 6, 2, 1
         ;R: 1, 2, 6, 7, 5, 4, 0, -3, 1, 2
         
         mov ecx, lenghtB ; we move the lenght of b in ecx to start the loop
         mov esi, lenghtB-1 ; we start from the end of b (the index for the string b)
         mov ebx, 0 ; the index for the string r
         
         jecxz Sfarsit ; skip loop if lenghtB = 0
         ;we put the string B in reverse order in R
         Repeta:
             mov al, [b+esi]
             mov [r+ebx], al
             inc ebx
             dec esi
         loop Repeta
         Sfarsit:
         
         mov ecx,0
         mov esi,0
         mov ecx, lenghtA ; we move the lenght of a in ecx to start the second loop
         mov esi, lenghtA-1 ; we start from the end of A (the index for the string A)
         ;we don't modify the value for the index of R(which is ebx)
         
         jecxz Sfarsit2 ; skip loop if lenghtA = 0
         ;we put the string B in reverse order in R
         Repeta2:
             mov al, [a+esi]
             mov [r+ebx], al
             inc ebx
             dec esi
         loop Repeta2
         Sfarsit2:
         
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
