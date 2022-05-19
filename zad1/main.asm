data1 segment
    buff1 db 100 dup('$')

    text_input_a db "Input a(1-8): $"
    text_input_b db "Input b(0-8): $"
    text_newline db 10, 13, '$'
    text_input_error db "Input out of range! Try again!", 10, 13, '$'
    text_root db "Root for x = $"
    text_y_intersection db "Intersection with Y axis for y = $"
    text_scale db "Scale: 1 character = 1 unit", 10, 13, '$'
    text_minus db "-$"
data1 ends


code1 segment
program_start:
    ; init stack
    mov ax, seg stack_top
    mov ss, ax
    mov sp, offset stack_top

get_input_loop:
    ; get input to a and b registers
    call get_input

    ; save registetrs
    push ax
    push bx

    ; push args in  reversed order
    push bx
    push ax 
    call verify_input

    ; restore registers
    pop bx
    pop ax

    cmp dx, 1
    jne no_input_error ; if d != 1, there is no error
        mov dx, 1

        push dx
        mov dx, offset text_input_error
        push dx
        call print1
        pop dx

        jmp get_input_loop
no_input_error: 
    ; save a and b on stack
    push ax
    push bx

    ; ax = b
    ; bx = a
    xchg ax, bx

    ; x_0 = -b/a
    neg al
    cbw ; convert al byte to ax word to fix negative 
    idiv bl; al = ax / bl, ah = remainder

    ; print newline
    mov dx, offset text_newline
    push dx
    call print1

    ; print text
    mov dx, offset text_root
    push dx
    call print1
    
    ; decide whethter to print "-"
    cmp al, 0
    jge _positive
        mov dx, offset text_minus
        push dx
        call print1

        neg al ; negate solution so we can print it
_positive:

    ; print root
    mov dx, seg buff1 
    mov es, dx ; setup extended segment
    mov di, offset buff1 ; save offset to di

    add al, 48d ; add 48d to remainder so it encodes ascii char
    mov byte ptr es:[di], al
    ; add newlines and terminate char
    mov byte ptr es:[di + 1], 10d 
    mov byte ptr es:[di + 2], 13d 
    mov byte ptr es:[di + 3], '$'

    mov dx, offset buff1
    push dx
    call print1

    ;print text
    mov dx, offset text_y_intersection
    push dx
    call print1

    ; print y axis intersection
    pop bx
    push bx ; get b but keep it saved
    add bx, 48d ; add 48d to remainder so it encodes ascii char
    mov byte ptr es:[di], bl

    mov dx, offset buff1
    push dx ; push arg to stack
    call print1
    
    ; print info about scale
    mov dx, offset text_scale
    push dx ; push arg to stack
    call print1

    ; retrive a and b
    pop bx
    pop ax

    ; draw graph in ASCII mode
    ; init cx
    mov cx, 20d

    ; make print terminate after 1 character
    mov byte ptr es:[di + 1], '$'

_for1:
    ; save outer counter and a and b on top of it
    push cx

    mov dx, cx ; save outer iterator to dx
    ; staer inner loop
    mov cx, 20d
    _for2:
        ; those two are nedded to restore a and b at end of loop
        push ax ; a
        push bx ; b
        ; those two are arguments for procedure inside inner loop
        push bx ; b
        push ax ; a

        ; set deafukt
        mov byte ptr es:[di], ' '

        ; check if it lies on the line
        cmp cx, 10d ; check horizontal iterator
        jne _for2_cont1
            mov byte ptr es:[di], '#'

        _for2_cont1:
        cmp dx, 10d ; check vertical iterator
        jne _for2_cont2
            mov byte ptr es:[di], '#'

        _for2_cont2:
        ; check if (10 - cx) * a + b == dx - 10 =>
        ; (10 - cx) * a + b - dx + 10 == 0
        mov ax, 10d
        sub ax, cx

        pop bx ; get a from top of stack
        imul  bl
        pop bx ; get b from top of stack
        add ax, bx
        sub ax, dx
        add ax, 10d

        cmp ax, 0
        jne _end_for2
            mov byte ptr es:[di], '*'


    _end_for2:
        ; print character chosen for this position
        mov ax, offset buff1
        push ax ; push arg to stack
        call print1

        ; retriving b and a
        pop bx
        pop ax
        loop _for2

    ; print newline
    mov dx, offset text_newline
    push dx 
    call print1

    pop cx
    loop _for1

end_program:

    mov ax, 4c00h
    int 21h

; args: NONE
; returns: a to ax, b to bx
get_input:
; ask for a
    mov ax, offset text_input_a
    push ax
    call print1

    mov ah, 1 ; get key
    int 21h ; DOS interupt
    mov ah, 0 ; weclear ah, so ax = key_code

    sub ax, 48d ; convert to number

    ; print newline
    mov dx, offset text_newline
    push dx 
    call print1

    ; ask for b
    push ax ; save ax

    mov ax, offset text_input_b
    push ax 
    call print1

    mov ah, 1 ; get key
    int 21h ; DOS interupt
    mov ah, 0 ; weclear ah, so ax = key_code

    sub ax, 48d ; convert to number

    mov bx, ax ; save result to bx

    ; print newline
    mov dx, offset text_newline
    push dx 
    call print1

    pop ax ; restore ax
    ret


; args on stack: word a, word b  
; returns: dx = 0, if a and b correct, dx = 1, if a or b incorrect
verify_input:
    push bp ; save old base pointer on stack
    mov bp, sp ; set new base pointer in place of stack pointer

    mov ax, word ptr ss:[bp + 4] ; get 1st arg
    mov bx, word ptr ss:[bp + 6] ; get 2nd arg

    mov dx, 0 ; by default there is no error

        ; if a >= 1
    cmp ax, 1d
    jge _cont1
        mov dx, 1
        jmp _verify_input_end
_cont1: ; if a <= 8
    cmp ax, 8d
    jle _cont2
        mov dx, 1
        jmp _verify_input_end
_cont2: ; if b >= 0
    cmp bx, 0
    jge _cont3
        mov dx, 1
        jmp _verify_input_end
_cont3: ; if b <= 8
    cmp bx, 8d
    jle _verify_input_end
        mov dx, 1

_verify_input_end:
    mov sp, bp ; delete local variables - not needed here
    pop bp ; retrive old base pointer
    ret 4


; argument on stack: offset w data1 textu do wypisania 
print1:
    push bp ; save old base pointer on stack
    mov bp, sp ; set new base pointer in place of stack pointer
    push ax
    push dx
    ; stack looks like this:
    ; 0:1 -> bp
    ; 2:3 -> return address
    ; 4:5 -> arguments start

    mov dx, word ptr ss:[bp + 4] ; get arg from stack
    mov ax, seg data1 
    mov ds, ax ; put data1 segment pointer into ds
    mov ah, 9 ; print text command id
    int 21h ; DOS interupt

    pop dx
    pop ax
    mov sp, bp ; delete local variables - not needed here
    pop bp ; retrive old base pointer

    ret 2d ; we return two so sp = sp - 2, so arguemnt is poped off stack



code1 ends

stack1 segment stack
            dw 200 dup(?)
stack_top   dw ?
stack1 ends


end program_start