bits 32 

global start        

extern exit, scanf, printf, number, read_number, save_number, max_value, print_max_value, print_end_message, save_result
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll


segment data use32 class=data
    
    
segment code use32 class=code
    start:
        ;Read a string of signed numbers in base 10 from keyboard. Determine the maximum value of the string and write it in the file max.txt (it will ;be created) in 16  base.
        mov ebx, 0
        repeta:
            call read_number
            call save_number
            
            mov eax, dword [number]
            cmp eax, dword 0
            jne repeta
        
        call max_value
        call print_max_value
        call save_result
        call print_end_message
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
