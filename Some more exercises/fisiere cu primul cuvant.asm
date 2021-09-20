bits 32

global start        

extern exit, fopen , fclose, fread, fprintf             
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll

segment data use32 class=data
    file_name_input db "fisier.in", 0
    file_descriptor dd -1
    
    reading_mode db "r", 0
    writing_mode db "w", 0
    writing_format db "%s", 0
    
    input_string resb 200
    first_word resb 40
    proposition resb 50
    len dd 0
    aux dd 0
    index dd 0
    index2 dd 0
    

segment code use32 class=code
    open_input_file:
        ; eax = fopen(file_name, access_mode)
        push dword reading_mode
        push dword file_name_input
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        ret
    
    read_input_file:
        ; eax = fread(text, 1, len, file_descriptor)
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
        add esp, 4*1
        ret
    
    create_output_file:
        push dword writing_mode
        push dword first_word
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        ret
    
    write_output_file:
        push dword proposition
        push dword writing_format
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        ret
        
    start_program:
        mov esi, input_string
        mov edi, proposition
        mov ebx, dword 0
        mov ecx, [len]
        mov [aux], dword 1
        
        loop_through_input:
            lodsb ;move in al a letter
            cmp al, "!"
            je end_of_phrase
            
            stosb
            
            cmp [aux], dword 1 
            jne dont_put ;only the first word
                mov edx, [index]
                mov [first_word + edx], al
                inc dword [index]
            
            
            cmp al, " "
            jne dont_put
                mov [aux], dword 0
                mov [first_word + edx], byte "."
                inc edx
                mov [first_word + edx], byte "o"
                inc edx
                mov [first_word + edx], byte "u"
                inc edx
                mov [first_word + edx], byte "t"
                inc edx
                pushad
                call create_output_file
                call write_output_file
                
                popad
                
                
            
            dont_put:
                loop loop_through_input
                
            end_of_phrase:
                mov [aux], dword 1
                mov [index], dword 0
                lodsb
                cmp ecx, dword 1 ;get rid of enter only for proprozitii that aren't the last one
                je dont_subtract
                    dec ecx
                dont_subtract
                mov edi, dword 0
                loop loop_through_input
                
        ret
    
    start:
        call open_input_file
        call read_input_file
        call close_file
        
        call start_program
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
