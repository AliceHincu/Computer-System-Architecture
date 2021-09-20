; Codul de mai jos va deschide un fisier numit "input.txt" din directorul curent si va citi intregul text din acel fisier, in etape, cate 100 de caractere intr-o etapa.
; Deoarece un fisier text poate fi foarte lung, nu este intotdeauna posibil sa citim fisierul intr-o singura etapa pentru ca nu putem defini un sir de caractere suficient de lung pentru intregul text din fisier. De aceea, prelucrarea fisierelor text in etape este necesara.
; Programul va folosi functia fopen pentru deschiderea fisierului, functia fread pentru citirea din fisier si functia fclose pentru inchiderea fisierului creat.
; Deoarece in apelul functiei fopen programul foloseste modul de acces "r", daca un fisier numele dat nu exista in directorul curent,  apelul functiei fopen nu va reusi (eroare). Detalii despre modurile de acces sunt prezentate in sectiunea "Suport teoretic".

bits 32 

global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf
import exit msvcrt.dll 
import fopen msvcrt.dll 
import fread msvcrt.dll 
import fclose msvcrt.dll 
import printf msvcrt.dll

; our data is declared here 
segment data use32 class=data
    nume_fisier db "input.txt", 0   ; the name of the file that must be opened
    mod_acces db "r", 0             ; r for reading
    descriptor_fis dd -1            ; the identifier of the file
    nr_car_citite dd 0              ; number of characters read in a step
    len equ 100                     ; numarul maxim de elemente citite din fisier intr-o etapa
    buffer resb len                 ; sirul in care se va citi textul din fisier
    format db "We've read %d chars from file. The text is: %s", 0
    format_final db "The special character is: %c and it appears %d times", 0
    character db 0FFh
    len2 equ 256
    ascii_table resb len2
    final_character dd 0
    nr_final dd 0
    nr db 0 
    format_test db "%c", 0
; our code starts here
segment code use32 class=code
    start:
        ;A text file is given. Read the content of the file, determine the special character with the highest frequency and display the character ; ; ; along with its frequency on the screen. The name of text file is defined in the data segment.
        
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
            je frequency

            mov [nr_car_citite], eax        ; we save the number of characters in nr_car_citite
            
            ; the instructions for processing the characters start here:
            ; ascii_table = frequency array with 256 bytes(1byte=1ascii character) 
            mov ecx, 0
            mov ecx, [nr_car_citite]
            mov edx, 0

            start_loop2:
                ;we take every character from the text and add "1" to its position from the ascii_table
                mov bl,[buffer+edx]
                mov [character], bl
                inc edx
                ;we transform the character into a doubleword
                mov bh, 0
                push 0
                push bx
                pop ebx
                ;we increase the frequency
                mov al, [ascii_table+ebx]
                inc al
                mov [ascii_table+ebx],al
                ;the loop will end when all characters are parsed
            loop start_loop2
            
            ;we verify if the text was read properly and the number of characters
            push dword buffer
            push dword [nr_car_citite]
            push dword format
            call [printf]
            add esp, 4*3
            ; we loop again to see if all characters are read
            jmp bucla
        
        ; after we went through all the tezt we check the higher frequency  of the special characters
        frequency:
            mov ecx, 256
            mov bh, 0
            mov edx, 0
            start_loop:
                mov bl,[ascii_table+edx] ;bl = the number of times the character appears in the text
                ;if bl is zero, we skip. If not, we check if edx (=the character) is a digit or letter. If not
                ;then edx is a special character.
                cmp bl, 0
                je is_zero
                cmp edx, '0' ; if character < 0
                jl special_character
                cmp edx, '9'; if 0 <= character <= 9
                jle found_digit
                cmp edx, 'A' ; if 9 < character < A
                jl special_character
                cmp edx, 'Z' ; if A <= character <= Z
                jle found_letter
                cmp edx, 'a' ; if Z < character < a
                jl special_character
                cmp edx, 'z' ; if a <= character <= z
                jle found_letter
                
                special_character:
                    ;if it is a special character, we check if it has the higher frequency or not
                    cmp bl, [nr_final]
                    jle ignore_if_not_more
                    mov [final_character], edx
                    mov [nr_final], bl
                    ignore_if_not_more:
                found_digit:
                found_letter:
                is_zero:
                inc edx
            loop start_loop
      

        ;we display the character and the frequency
        push dword [nr_final]
        push dword [final_character]
        push dword format_final
        call [printf]
        
        ; we close the file
        ; fclose(descriptor_fis)
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4
        
      final:  
        ; exit(0)
        push    dword 0      
        call    [exit]       