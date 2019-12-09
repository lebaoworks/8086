name "converter-bao"

.model small
.stack 100h

.data
    message_decimal_input db 'Input decimal to convert to binary ( 0<=x<=65535 ): ','$'
    message_binary_output db 0dh, 0ah, 'Binary: ', '$'
    message_binary_input  db 0dh, 0ah, 'Input binary to convert to decimal ( <= 16 bits ): ', '$'
    message_decimal_output db 0dh, 0ah, 'Decimal: ','$'
    message_not_valid db 0dh, 0ah, 'Input is not valid!' ,'$'

.code
    mov dx, @data
    mov ds, dx
    xor dx, dx
main:       
    
    input_decimal:
        print_dec_message:
            lea dx, message_decimal_input
            mov ah, 09h
            int 21h

        ;use bx to store result
        xor ax, ax
        xor dx, dx
        xor bx, bx        
        xor cx, cx
        
        input_dec_digit:        
            mov ah, 01h
            int 21h
            
            ;if input enter key -> stop input
            cmp al, 0dh
            jz print_binary
            
            ;if ord(character) < ord('0') -> not valid
            cmp al, '0'
            jb not_valid
            
            ;if ord(character) > ord('9') -> not valid
            cmp al,'9'
            jg not_valid
            
            ;append digit to tail
                ;save digit
                xor ch, ch
                mov cl, al
                sub cl, '0'
            
                ;x10
                mov ax, bx
                mov bx, 0ah
                mul bx
                
                ;append to tail
                add ax, cx
                
                ;save number
                mov bx, ax
            
            ;read next digit
            jmp input_dec_digit 
            
    print_binary:
        lea dx, message_binary_output
        mov ah, 09h
        int 21h

        ;loop 16 bits
        mov cx, 10h
            
        ;set output character
        mov ah, 02h
            
        print_binary_bit:
            cmp cx, 00h
            jz input_binary           
            dec cx
                
            ;shift left, if overflow -> CF = 1
            shl bx, 1h    
            jnc is_off
                
            is_on:
                mov dx, '1'
                int 21h
                jmp print_binary_bit
            is_off:
                mov dx, '0'
                int 21h
                jmp print_binary_bit 
                    
    input_binary:
        print_message_2:
            lea dx, message_binary_input
            mov ah, 09h
            int 21h
            
        ;use bx to store result
        xor bx, bx
            
        input_bin_digit:        
            mov ah, 01h
            int 21h
            
            ;if input enter key -> stop input
            cmp al, 0dh
            jz print_decimal
            
            ;if ord(character) < ord('0') -> not valid
            cmp al, '0'
            jz valid
            
            ;if ord(character) > ord('9') -> not valid
            cmp al,'1'
            jz valid
            
            jmp not_valid
            
            valid:
                xor ah, ah
                sub al, '0'
                shl bx, 01h
                or bx, ax
                jmp input_bin_digit

            
    print_decimal:
        ;save number
        push bx
            
        lea dx, message_decimal_output
        mov ah, 09h
        int 21h
            
        ;initalize
        pop ax          ;restore number
        mov bx, 0ah     ;decimal
        xor cx, cx      ;count

        ;push end character for string output
        push 0024h              
            
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
        
        ;print result from stack
        print_dec_digit:
            pop dx
            mov ah, 02h
            int 21h
            loop print_dec_digit

    hlt

not_valid:
    lea dx, message_not_valid
    mov ah, 09h
    int 21h
                
    hlt