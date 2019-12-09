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
    ;    NUMBERS COUNT   | (- FCh
    ;____________________|
    ;     TEMPORARY      | (- FEh
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
        
                ;not valid character
                lea dx, message_not_valid
                mov ah, 09h
                int 21h
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


