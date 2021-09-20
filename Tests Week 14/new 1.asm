bits 32

global start        

extern exit , printf, scanf  , fopen, fread, fclose, printf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import print msvcrt.dll

segment data use32 class=data
    message_input_keyboard db "l=", 0
    format db "%d", 0
    
    l dd 0
    
    reading_mode db "r", 0
    writing_mode db "w", 0
    file_name dd "cuvinte.txt", 0
    file_descriptor dd -1
    
    input_string resb 200
    len dd 0
    cuvant resb 40
    
    
    
segment code use32 class=code
    citire_nr_tastatura:
        push dword message_input_keyboard
        call [printf]
        add esp, 4*1
        
        push dword l
        push dword format
        call [scanf]
        add esp, 4*2
        
        ret
    
    open_file:
        ; eax = fopen(file_name, acces_mode)
        push dword reading_mode
        push dword file_name
        call [fopen]
        
        add esp, 4*2
        mov [file_descriptor], eax
        ret
    
    read_from_file:
        ;eax = fread(text, 1, len, file_descriptor_
        push dword [file_descriptor]
        push dword 200
        push dword 1
        push dword input_string
        call [fread]
        add esp, 4*4
        
        mov [len], eax
        ret
    
    close_file:
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        ret
    
    printare_display:
        push dword cuvant
        call [printf]
        add esp, 4*1
        ret
    
    start_program:
        mov esi, input_string
        mov edi, cuvant
        mov ecx, [len]
        mov ebx, 0 ; save length of word
        jecxz final
        
        loop_through_input:
            lodsb ;move a letter in al
            mov [cuvant + ebx], al
            cmp al, "."
            je final_word
            cmp al, " "
            jne not_final
                final_word:
                
                cmp ebx, [l]
                jnb bad_word
                test ebx, 1
               
                jz bad_word
                
                    ;print
                    inc ebx
                    mov [cuvant+ebx], dword 0
                    mov ebx, dword 0
                    pushad
                    call printare_display
                    popad
                    jecxz final
                    loop loop_through_input
                bad_word:
                    mov ebx, 0
                    jecxz final
                    loop loop_through_input
                
            not_final:
            
                inc ebx
                loop loop_through_input
            
        
        final:
        ret
    start:
        call citire_nr_tastatura
        call open_file
        call read_from_file
        
        call start_program
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
