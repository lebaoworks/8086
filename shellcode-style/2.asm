name "calc-average-bao"

.model small
.stack 100h
          
.code
main:       
    ;print "Input numbers ( 0<=x<=9 ): "
    print_message:
        push 2420h
        push 3a29h
        push 2039h   
        push 3d3ch
        push 783dh
        push 3c30h
        push 2028h
        push 2073h
        push 7265h
        push 626dh
        push 756eh
        push 2074h
        push 7570h
        push 6e49h
    
        mov bp, sp
        lea dx, [bp]
        mov ah, 09h
        int 21h
        
        add sp, 1ch
    
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
            ;print "\r\nAverage: "
            push 2420h
            push 3a65h
            push 6761h
            push 7265h
            push 7641h
            push 0a0dh
            
            mov bp, sp
            lea dx, [bp]
            mov ah, 09h
            int 21h
            
            add sp, 0ch     

            ;print result from stack
            print_dec_digit:
                pop dx
                mov ah, 02h
                int 21h
                loop print_dec_digit
          
    hlt

