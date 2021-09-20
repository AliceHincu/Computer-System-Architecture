; Codul de mai jos va deschide un fisier numit "input.txt" din directorul curent si va citi intregul text din acel fisier, in etape, cate 100 de caractere intr-o etapa.
; Deoarece un fisier text poate fi foarte lung, nu este intotdeauna posibil sa citim fisierul intr-o singura etapa pentru ca nu putem defini un sir de caractere suficient de lung pentru intregul text din fisier. De aceea, prelucrarea fisierelor text in etape este necesara.
; Programul va folosi functia fopen pentru deschiderea fisierului, functia fread pentru citirea din fisier si functia fclose pentru inchiderea fisierului creat.
; Deoarece in apelul functiei fopen programul foloseste modul de acces "r", daca un fisier numele dat nu exista in directorul curent,  apelul functiei fopen nu va reusi (eroare). Detalii despre modurile de acces sunt prezentate in sectiunea "Suport teoretic".

bits 32 

global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf, fprintf
import exit msvcrt.dll 
import fopen msvcrt.dll 
import fread msvcrt.dll 
import fclose msvcrt.dll 
import printf msvcrt.dll
import fprintf msvcrt.dll

; our data is declared here 
segment data use32 class=data
    nume_fisier db "input24.txt", 0   ; the name of the file that must be opened
    nume_output db "output24.txt", 0
    mod_acces db "r", 0             ; r for reading
    mod_acces_output db "w", 0      ; w for writing
    descriptor_fis dd -1            ; the identifier of the file
    file_descriptor_output dd -1    ; the identifier of the output file
    nr_car_citite dd 0              ; number of characters read in a step
    len equ 100                     ; numarul maxim de elemente citite din fisier intr-o etapa
    buffer resb len                 ; sirul in care se va citi textul din fisier
    format db "We've read %d chars from file. The text is: %s", 0
    format_final db "The special character is: %c and it appears %d times", 0
    character db 0FFh
; our code starts here
segment code use32 class=code
    start:
        ;A file name and a text (defined in data segment) are given. The text contains lowercase letters, uppercase letters, digits and special ; ; ; ; characters. Replace all digits from the text with character 'C'. Create a file with the given name and write the generated text to file.
        
        ; eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4*2
        
        ; we check if the file is not empty
        cmp eax, 0                  
        je final
        
        mov [descriptor_fis], eax   ; the text is saved in descriptor_fis
        

        bucla:
            ; we read 100ch at a time
            ; eax = fread(buffer, 1, len, descriptor_fis)
            push dword [descriptor_fis]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4
            
            ; eax = number of bites that were read
            cmp eax, 0          ; if the number is zero, then the reading is over and we check the higher frequency
            je final

            mov [nr_car_citite], eax        ; we save the number of characters in nr_car_citite
            
            ; the instructions for processing the characters start here:
            ; ascii_table = frequency array with 256 bytes(1byte=1ascii character) 
            mov ecx, 0
            mov ecx, [nr_car_citite]
            mov edx, 0
            mov ebx, 0
            start_loop2:
                ;we check every character if it is a digit or not
                mov bl, [buffer+edx]
                cmp bl, '0' ; if character < 0
                jl not_digit
                cmp bl, '9'; if character > 9
                jg not_digit
                 
                mov bl, 'C'
                mov [buffer+edx], bl
                
                not_digit:
                inc edx
                ;the loop will end when all characters are parsed
            loop start_loop2
            
            push dword mod_acces_output
            push dword  nume_output
            call [fopen]
            add esp, 4*2                ; clean-up the stack

            mov [file_descriptor_output], eax  ; store the file descriptor returned by fopen
            ; append the text to file using fprintf()
            ; fprintf(file_descriptor, text)
            push dword buffer
            push dword [file_descriptor_output]
            call [fprintf]
            add esp, 4*2
            ; we loop again to see if all characters are read
            jmp bucla
        
        
        ; we close the input file
        ; fclose(descriptor_fis)
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4
        
        ;we close the output file
        push dword [file_descriptor_output]
        call [fclose]
        add esp, 4
        
      final:  
        ; exit(0)
        push    dword 0      
        call    [exit]       