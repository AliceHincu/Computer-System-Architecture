bits 32 

global start        

extern exit, fopen, fclose, printf, fread

import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll

segment data use32 class=data
    file_name db "in.txt", 0
    buffer resb 100
    cifra resb 3
    contor dd 0
    divizor dd 2
    
    mod_read db "r", 0
    file_descriptor dd -1
    format_str db "%s ", 0
    format_d db "%d ", 0
    
segment code use32 class=code
    start:
        ; Se da in data segment numele unui fisier.
        ; Acesta contine cifre separate prin spatiu
        ; (cifrele sunt din multimea cifrelor bazei 16 separate).
        ; Sa se afiseze fiecare cifra impara citita din fisier
        ; si numarul de biti 0 din reprezentarea binara a acesteia.
        
        ; OPEN GIVEN FILE
        ; eax = fopen(const char* nume_fisier, const char * mod_acces)
        push mod_read
        push file_name
        call [fopen]
        add esp, 8
        ; check for error
        cmp eax, 0
        je error_fopen
        mov [file_descriptor], eax
        
        
        ; start reading in a buffer
        read_part_of_the_file:
            
            ; read 100 chr from the file_descriptor
            ; eax = fread(buffer, 1, len, desc)
            push dword [file_descriptor]
            push dword 100
            push dword 1
            push dword buffer
            call[fread]
            add esp, 4*4
            
            ; eax = 0 -> we finished the text
            cmp eax, 0
            je finished_reading
            
            mov esi, buffer
            mov edi, cifra
            mov ecx, eax

            read_letter_by_letter:
                
                mov eax, 0
                mov edi, cifra
                lodsb
                
                ; cifra == ' ' => continuam citirea
                cmp al, ' '
                je read_letter_by_letter
                cmp al, 0
                je finished_buffer
                
                stosb
                
                ; if 0 <= cifra <= 9
                cmp al, byte'0'
                jb not_digit
                cmp al, byte'9'
                ja not_digit
                
                    ;digit:
                    sub al, byte'0'
                
                not_digit:
                
                ; if A <= cifra <= F
                cmp al, byte'A'
                jb not_letter
                cmp al, byte'F'
                ja not_letter
                    
                    ; letter_digit:
                    sub al, 'A'
                    add al, 10
                
                not_letter:
                
                ;digit:
                
                mov ebx, eax
                mov edx, 0
                div dword[divizor]
                cmp edx, 1
                mov eax, ebx
                
                jne not_print
                    
                    mov dword[contor], 0
                    push ecx
                    
                    mov ecx, dword 8
                    Again:
                        mov ebx, eax
                        and al, 00000001b
                        cmp al, byte 0
                        jne not_increase
                            mov eax, 1
                            add dword[contor], eax 
                        not_increase:
                        mov eax, ebx
                        ror al, 1
                       
                    loop Again
                    
                    ; printf(const char * format, variabila_1, constanta_2, ...);
                    push cifra
                    push format_str
                    call[printf]
                    add esp, 4
                    
                    push dword[contor]
                    push format_d
                    call[printf]
                    add esp, 4
                    
                    pop ecx
                    
                not_print:
            
            jmp read_letter_by_letter
            
            finished_buffer:
        jmp read_part_of_the_file
            
        finished_reading:
        ; CLOSE FILE
        push dword [file_descriptor]
        call[fclose]
        add esp, 4
        
        error_fopen:
        
        ; exit(0)
        push    dword 0      
        call    [exit]       