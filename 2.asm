name "calc-average-bao"

.model small
.stack 100h


.data
    message_input db 'Input numbers ( 0<=x<=9 ): ', '$'
    message_not_valid db 0dh, 0ah, 'Input is not valid!', '$'
    message_average db 0dh, 0ah, 'Average: ','$'
       
.code
    mov dx, @data
    mov ds, dx
    xor dx, dx
main:       
    print_message:
        lea dx, message_input
        mov ah, 09h
        int 21h
    
    ;use bx to store sumary
    ;use cx to count numbers
    and bx, 00h
    and cx, 00h
        
    ;input numbers with ' ' seperator
    input_number:
        mov ah, 01h
        int 21h
        
        ;if input enter key -> stop input
        cmp al, 0dh
        jz calc_average
        
        ;if input space key -> next number
        cmp al, ' '
        jz input_number
        
        ;if ord(character) < ord('0') -> not valid
        cmp al, '0'
        jbe not_valid
        
        ;if ord(character) > ord('9') -> not valid
        cmp al,'9'
        jg not_valid
        
        ;add number to sumary, increase count
        mov ah, 00h
        sub ax, '0'
        add bx, ax
        inc cx
        
        ;read next character
        jmp input_number
        
        ;print 
        not_valid:
            lea dx, message_not_valid
            mov ah, 09h
            int 21h
            
            hlt
    
    ;calculate average
    calc_average:
        mov ax, bx
        div cl
        
        xor ah, ah

    output_result:
        ;initalize
        mov bx, 0ah     ;decimal
        mov cx, 0h      ;count

        convert_to_decimal: 
            ;extract the last digit
            xor dx, dx 
            div bx                   
          
            ;push (remainer -> decimal digit) to stack 
            add dx, '0'
            inc cx
            push dx               
          
            cmp ax, 0h
            jnz convert_to_decimal
        
        print_result:
            lea dx, message_average
            mov ah, 09h
            int 21h

            ;print result from stack
            print_dec_digit:
                pop dx
                mov ah, 02h
                int 21h
                loop print_dec_digit
          
    hlt


