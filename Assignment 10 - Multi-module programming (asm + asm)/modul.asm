bits 32

global start, print_max_value, read_number, save_number, max_value, print_end_message, number, save_result     

extern exit, scanf, printf, fopen, fprintf, fclose
import exit msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll 
import fclose msvcrt.dll
import printf msvcrt.dll
import fprintf msvcrt.dll

segment data use32 class=data
    text_message db "Input your string of numbers:", 0
    print_message db "The maximum value is:%d", 10, 0
    end_message db "---Ending---", 0
    format  db "%d", 0
    format_hex db "%x", 0
    
    string times 100 db 0FFh 
    number resd 1
    max_number dd 0CCCCFFCCh
    
    mod_acces_output db "w", 0
    nume_fisier_output db "max1.txt", 0
    file_descriptor_output dd -1    ; the identifier of the output file
    
    
segment code use32 class=code
    print_max_value:
        push dword [max_number]
        push print_message
        call [printf]
        add esp, 4*2
        ret
        
    read_number:
        push dword text_message
        call [printf]
        add esp, 4*1 
        
        push number
        push format
        call [scanf]
        add esp, 4*2
        ret
    
    save_number:
        mov eax, 0
        mov eax, dword [number]
        mov [string + ebx], eax
        add ebx, 4
        ret
    
    max_value:
        mov ebx, 0
        repeta2:
            mov edx, dword [string + ebx]
            mov eax, dword [max_number]
            cmp edx, eax
            
            jl is_smaller
            
            mov dword [max_number], edx
            
            is_smaller:
            mov eax, dword 0
            add ebx, 4
            cmp edx, dword 0
            jne repeta2
        ret
    
    save_result:
        push dword mod_acces_output
        push dword nume_fisier_output
        call [fopen]
        add esp, 4*2                

        mov [file_descriptor_output], eax  ; store the file descriptor returned ;by fopen
        cmp eax, 0
        je final
        
        push dword [max_number]
        push format_hex
        push dword [file_descriptor_output]
        call [fprintf]
        add esp, 4*3
        
        push dword [file_descriptor_output]
        call [fclose]
        add esp, 4
        
        final:
        ret
        
    print_end_message:
        push dword end_message
        call [printf]
        add esp, 4*1
        ret
