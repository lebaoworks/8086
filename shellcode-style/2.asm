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
    
    ;____________________. <- 00h
    ;                    |
    ;                    |
    ;                    |
    ;                    |
    ;                    |
    ;                    |
    ;____________________|
    ;       SUMMARY      | <- FAh
    ;____________________|
    ;    NUMBERS COUNT   | <- FCh
    ;____________________|
    ;     TEMPORARY      | <- FEh
    ;____________________|
    
    push 00h
    push 00h
    push 00h
    mov bp, sp  ;bp = FAh
    
    ;use cx to check if count
    xor cx, cx        
    
    ;input numbers with ' ' seperator
    input_digit:
        mov ah, 01h
        int 21h
        
        ;if ord(character) < ord('0') -> not valid
        cmp al, '0'
        jb non_digit
        
        ;if ord(character) > ord('9') -> not valid
        cmp al,'9'
        jg non_digit
        
        is_digit:
            ;increase count
            or cl, 1h
            
            ;append to tail
            sub al, '0'
            xor ah, ah      ;ax = digit
            mov bx, ax      ;save digit to bx
            
            mov ax, [bp+04h]    ;mov temp to ax
            mov dx, 0ah
            mul dx              ;temp *= 10
            add ax, bx          ;temp += digit
            mov [bp+04h], ax    ;save temp
                    
            ;next character
            jmp input_digit
        
        non_digit:
            ;previous is not a digit
            test cl,cl
            je indentify_seperator
           
            ;count, sum
            add [bp+02h], 1h
            mov bx, [bp+04h]
            add [bp], bx
            
            ;clear temp
            mov [bp+04h], 00h
            xor cx, cx
            
            indentify_seperator:
            
                ;if input enter key -> stop input
                cmp al, 0dh
                jz calc_average
        
                ;if input space key -> next number
                cmp al, ' '
                jz input_digit
        
            ;not_valid
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
                mov bp, sp

                hlt
    
    ;calculate average
    calc_average:
        pop ax  ;get sumary
        pop cx  ;get count
        pop bx  ;remove temp
        
        div cl
        
        xor ah, ah  ;clear remainer

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

