bits 32 

global start 

extern exit, fopen, fclose, fread, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll

segment data use32 class=data
    file_name db "propozitii.txt", 0
    file_name_output db "propozitii_out.txt", 0
    access_mode db "r", 0
    write_mode db "w", 0
    file_descriptor dd -1
    writing_format db "%s", 0
    input_string resb 200
    output_string resb 200
    len dd 0
    aux dd 0

; our code starts here
segment code use32 class=code
    open_file:
        ; eax = fopen(file_name, access_mode)
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        ret
    
    close_file:
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        ret
    
    read_from_file:
        ; eax = fread(text, 1, len, file_descriptor)
        push dword [file_descriptor]
        push dword 200
        push dword 1
        push dword input_string
        call [fread]
        add esp, 4*4
        
        mov [len], eax
        
        ret
    
    open_output_file:
        push dword write_mode
        push dword file_name_output
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        
        ret
        
    write_output_file:
        push dword output_string
        push dword writing_format
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        ret
    
    start_program:
        mov esi, input_string
        mov edi, output_string
        mov ebx, 1
        mov ecx, [len]
        loop_through_input:
            lodsb ; move letter in al
            
            cmp al, '!'
            je end_of_phrase
            
            cmp ebx, 1
            jne dont_put
                stosb
            
            dont_put:
                loop loop_through_input
            
            end_of_phrase:
                mov [aux], ebx
                mov ebx, 1
                sub dword ebx, [aux]
                loop loop_through_input
        ret
        
    start:
        ; eax = fopen(file_name, access_mode)
        call open_file
        call read_from_file
        call close_file
        
        call start_program
        
        call open_output_file
        call write_output_file
        call close_file
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
