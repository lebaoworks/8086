name "converter-bao"

.model small
.stack 100h
          
.code
main:       
    
    input_decimal:
        ;print "Input decimal to convert to binary ( 0<=x<=65535 ): "
        print_dec_message:
            push 0024h
            push 203ah
            push 2920h
            push 3533h
            push 3535h
            push 363dh
            push 3c78h
            push 3d3ch
            push 3020h
            push 2820h
            push 7972h
            push 616eh
            push 6962h
            push 206fh
            push 7420h
            push 7472h
            push 6576h
            push 6e6fh
            push 6320h
            push 6f74h
            push 206ch
            push 616dh
            push 6963h
            push 6564h
            push 2074h
            push 7570h
            push 6e49h
    
            mov bp, sp
            lea dx, [bp]
            mov ah, 09h
            int 21h
            
            add sp, 36h


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
        ;print "\r\nBinary: "
        push 0024h
        push 203ah      
        push 7972h
        push 616eh
        push 6942h
        push 0a0dh
            
        mov bp, sp
        lea dx, [bp]
        mov ah, 09h
        int 21h
            
        add sp, 0ch
            
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
        ;print "\r\nInput binary to convert to decimal ( <= 16 bits ): "
        print_message_2:
            push 2420h
            push 3a29h
            push 2073h
            push 7469h
            push 6220h
            push 3631h
            push 203dh
            push 3c20h
            push 2820h
            push 6c61h
            push 6d69h
            push 6365h
            push 6420h
            push 6f74h
            push 2074h
            push 7265h
            push 766eh
            push 6f63h
            push 206fh
            push 7420h
            push 7972h
            push 616eh
            push 6962h
            push 2074h
            push 7570h
            push 6e49h
            push 0a0dh

            mov bp, sp
            lea dx, [bp]
            mov ah, 09h
            int 21h
        
            add sp, 36h            
            
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
            
        ;print "\r\nDecimal: "
        push 2420h
        push 3a6ch      
        push 616dh
        push 6963h
        push 6544h
        push 0a0dh
            
        mov bp, sp
        lea dx, [bp]
        mov ah, 09h
        int 21h
            
        add sp, 0ch
            
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

;print "\r\nInput is not valid!"
not_valid:
    push 2421h
    push 6469h
    push 6c61h
    push 7620h
    push 746fh
    push 6e20h
    push 7369h
    push 2074h
    push 7570h
    push 6e49h
    push 0a0dh
        
    mov bp, sp
    lea dx, [bp]
    mov ah, 09h
    int 21h
            
    add sp, 16h
                
    hlt