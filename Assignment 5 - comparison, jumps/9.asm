bits 32 ; assembling for the 32 bits architecture

global start        

extern exit
import exit msvcrt.dll 

segment data use32 class=data
	s db 1, 2, 4, 6, 10, 20, 25 ; declare the string of bytes
	l equ $-s ; compute the length of the string in l
	d times l-1 db 0 ; reserve l bytes for the destination string and initialize it

segment code use32 class=code
    start:
         ;A byte string S of length l is given. Obtain the string D of length l-1 so that the elements of D represent the difference between every two ;consecutive elements of S
         ;ex: S: 1, 2, 4, 6, 10, 20, 25
         ;D: 1, 2, 2, 4, 10, 5
         mov ecx, l-1 ; we put the length l in ECX in order to make the loop
         mov esi, 0; we use esi as index     
         jecxz Sfarsit ;skip loop if l-1=0  
         Repeta:
             mov al, [s+esi] ; save the first number
             mov bl, [s+esi+1] ; save the second number
             sub bl, al ; do the difference between second - first            
             mov [d+esi], bl ; the difference is the 'esi'-th character in the string d     
             inc esi ; we increase by 1 until we reach l-1
         loop Repeta
         Sfarsit:;end of the program

         ; exit(0)
         push dword 0 ; push the parameter for exit onto the stack
         call [exit] ; call exit to terminate the program