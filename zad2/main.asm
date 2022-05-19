assume cs:code1

data1 segment
    buff1 db 100 dup('$')
    text_newline db 10, 13, '$'

data1 ends


code1 segment
program_start: 
    ; init stack
    mov ax, seg stack1
    mov ss, ax
    mov sp, offset stack_top

    ; change display mode
    mov ah, 0
    ; use 320x200 VGA mode
    mov al, 13h
    ; BIOS interrupt
    int 10h

    ; set es to start of video card memory
    mov ax, 0a000h
    mov es, ax

    mov ax, 4d
    push ax

    push bp
    mov bp, sp
    ; we need to push in reverse order
    mov ax, 13d ; color
    push ax 
    ; mov ax, 100d ; y2
    ; push ax
    ; mov ax, 100d ; x2
    ; push ax 
    mov ax, 60d ; y1
    push ax
    mov ax, 150d ; x1
    push ax 
    mov ax, 50d ; y0
    push ax
    mov ax, 50d ; x0
    push ax 

    ; args on stack: x0, y0, x1, y1, color
    call draw_figure

    pop bp
    pop ax
    sub sp, ax


program_end:
    ; wait for any key before end
    xor ax, ax
    int 16h
    ; go back to text mode
    mov ah, 0
    ; use text mode
    mov al, 3h
    ; BIOS interrupt
    int 10h 

    mov ax, 4c00h ; end progrema
    int 21h


; args on stack: color, any number of poitns in form (word x, word y)
; first point should be pushed last
draw_figure:
    mov cx, bp
    sub cx, sp ; before setting new base pointer, count number of arguments
    sub cx, 2d 
    ror cx, 1d; number of args is (bp - sp - 2) /2 (we need to account for ip already on stack)
    sub cx, 1d ; subtract color argument

    mov ax, cx
    mov bl, 2d
    div bl
    mov cx, ax ; divide cx by 2 to make it number of points

    push bp
    mov bp, sp ; save base pointer

    ; get color
    mov bx, word ptr ss:[bp + 4]
    push bx ; save color on stack

    add ax, 2d ; move to 1st point

    mov dx, word ptr ss:[bp + 6] ; x_0 = x_(n-1)

    sub cx, 1d ; account for already taking 1st point

    _draw_figure_for1:
        pop ax
        push ax ; get color and save it again
        push ax ; put color on argument stack for draw_line

        ; logic do get nth point
        mov di, cx
        rol di, 1 
        rol di, 1 ; multiply by 4 to accoutn for 2 words per point
        add di, 6d ; account for ip, bp, and color

        mov ax, word ptr ss:[bp + di] ; x_n

        call print_regs
        cmp ax, dx
        jae _draw_figure_if1 ; if x_n < x_(n-1)
            ; we need to push in reverse order
            mov ax, word ptr ss:[bp + di + 2] ; x_n ; y1
            push ax
            mov ax, word ptr ss:[bp + di] ; x_n ; x1
            push ax 
            mov ax, word ptr ss:[bp + di + 4] ; x_n ; y0
            push ax
            mov ax, word ptr ss:[bp + di + 6] ; x_n ; x0
            push ax

            jmp _draw_figure_draw_line
        _draw_figure_if1: ; else (  x_n >= x_(n-1) )
            ; we need to push in reverse order
            mov ax, word ptr ss:[bp + di + 2] ; x_n ; y1
            push ax
            mov ax, word ptr ss:[bp + di] ; x_n ; x1
            push ax 
            mov ax, word ptr ss:[bp + di - 2] ; x_n ; y0
            push ax
            mov ax, word ptr ss:[bp + di - 4] ; x_n ; x0
            push ax 

        _draw_figure_draw_line:
        ; args on stack: x0, y0, x1, y1, color
        call draw_line

        loop _draw_figure_for1


    _draw_figure_end:
    mov sp, bp ; delete local variables 
    pop bp ; retrive old base pointer
    ret

; pseudo code for procedure from wikipedia
; draw_line(x0, y0, x1, y1, color)
;     delta_x = x1 - x0
;     delta_y = y1 - y0
;     if slope < 1
;         D = 2*delta_y - delta_x
;         y = y0
;         for x from x0 to x1
;             plot(x,y)
;             if D > 0
;                 y = y + 1
;             
;                  D = D - 2*delta_x
;             else
;                 D = D - 2*delta_x
;             end if
;                 D = D + 2*delta_y
;             else
;                 D = D - 2*delta_x
;     else
;         D = 2*delta_x - delta_y
;         x = x0
;         for y from y0 to y1
;             plot(x,y)
;             if D > 0
;                 x = x + 1
;                 D = D - 2*delta_x
;             end if
;                 D = D + 2*delta_y
;             else
;                 D = D - 2*delta_x      

; args on stack: x0, y0, x1, y1, color
; we use registers as such:
; cx <- x, bl <- y, bh <- delta_y, dx <- D, stack <- delta_x
; we use bx for other temporary operations 
; we exchange y with x in slope > 1 version
draw_line:
    push bp
    mov bp, sp

    mov ax, word ptr ss:[bp + 8] ; x1
    mov bx, word ptr ss:[bp + 4] ; x0
    ; delta_x = x1 - x0
    sub ax, bx
    push ax ; save delta_x to stack

    mov ax, word ptr ss:[bp + 10] ; y1
    mov bx, word ptr ss:[bp + 6] ; y0
    ; delta_y = y1 - y0
    sub ax, bx
    mov bh, al ; save delta_y to bh

    cmp bh, 0d
    jge _no_negative_delta_y
        neg bh
        push bx
        mov bx, word ptr ss:[bp + 10] ; y1
        neg bl
        mov word ptr ss:[bp + 10], bx
        mov bx, word ptr ss:[bp + 6] ; y0
        neg bl
        mov word ptr ss:[bp + 6], bx
        pop bx

    _no_negative_delta_y:


    

    pop ax
    push ax ; get detla_x temporarly to ax for compare

    cmp al, bh
    jb _draw_line_if1 ; if delta_x >= delta_y

        ; y = y0
        mov ax, word ptr ss:[bp + 6]
        mov bl,  al

        ; D = 2*delta_y - delta_x
        xor dx, dx
        mov dl, bh
        rol dx, 1; multily by two 


        pop ax ; load delta_x to ax
        push ax ; save it

        sub dx, ax ; dx = D = 2*delta_y - delta_x

        mov cx, word ptr ss:[bp + 4] ; cx = x0
        _draw_line_for1:
            ; plot(x,y)
            ; save bx and dx
            push bx
            push dx
            ; construct arguments
            ; color
            mov ax, word ptr ss:[bp + 12] 
            push ax

            ; y
            xor ax, ax
            mov al, bl
            push ax 

            ; x
            mov ax, cx 
            push ax
            
            call draw_point
            ; get bx and dx
            pop dx
            pop bx

            
            cmp dx, 0
            jle _draw_line_if2 ; if D > 0
                ; y = y + 1
                add bl, 1d
                ; D = D - 2*delta_x
                ; get delta_x
                pop ax
                push ax

                rol ax, 1; multily by two 

                sub dx, ax


            _draw_line_if2:

            ; D = D + 2*delta_y
            mov ah, 0d
            mov al, bh ; load delta_y to ax

            rol ax, 1; multily by two 

            add dx, ax

            ; end loop
            inc cx
            cmp cx, word ptr ss:[bp + 8]
            jle _draw_line_for1; loop if x <= x1

        jmp _draw_line_end

    _draw_line_if1: ; if delta_x < delta_y (or just else)
        ; x = x0
        mov ax, word ptr ss:[bp + 4]
        mov bl,  al
        ; D = 2*delta_x - delta_y
        pop dx 
        push dx ; get delta_x to dx

        rol dx, 1; multily by two 

        sub dl, bh ; dx = D = 2*delta_x - delta_y

        mov cx, word ptr ss:[bp + 6]
        _draw_line_for2:
            ; plot(x,y)
            ; save bx and dx
            push bx
            push dx
            ; construct arguments
            ; color
            mov ax, word ptr ss:[bp + 12] 
            push ax

            ; y
            mov ax, cx 
            push ax

            ; x
            xor ax, ax
            mov al, bl
            push ax
            
            call draw_point
            ; get bx and dx
            pop dx
            pop bx

            ; if D > 0
            cmp dx, 0
            jle _draw_line_if3
                ; x = x + 1
                add bl, 1d

                ; D = D - 2*delta_y
                ; get delta_y
                xor ax, ax
                mov al, bh
                rol ax, 1; multily by two 

                sub dx, ax


            _draw_line_if3:

            ; D = D + 2*delta_x
            pop ax
            push ax ; get delta_x

            rol ax, 1; multily by two 

            add dx, ax

            ; end loop
            inc cx
            cmp cx, word ptr ss:[bp + 10]
            jle _draw_line_for2; loop if y <= y1

    _draw_line_end:
    mov sp, bp ; delete local variables 
    pop bp ; retrive old base pointer
    ret 10




;args on stack - 3 words: x, y, color 
; it destroys ax, bx, and dx!
draw_point:
    push bp
    mov bp, sp


    ; calculate 320 * (199-y) + x, because we treat screen as I quater of cartesian plane
    mov bx, word ptr ss:[bp + 6]
    ; check if y ise negative if it is, flip it

    cmp bl, 0d
    jge _draw_point_if1
        mov bx, word ptr ss:[bp + 6] 
        neg bl
        mov word ptr ss:[bp + 6], bx
    _draw_point_if1:


    mov ax, 199d
    sub ax, bx
    mov bx, 320d

    mul bx ; (dx ax) = ax * 320 (bx), but we ignore dx as we never overflow into it
    mov bx, word ptr ss:[bp + 4]
    add bx, ax ; bx = 320 * (200-y) + x

    mov ax, word ptr ss:[bp + 8] ; set color

    mov byte ptr es:[bx], al ; light up a pixel

    mov sp, bp ; delete local variables - not needed here
    pop bp ; retrive old base pointer
    ret 6

; function for debug puposes 
print_regs:
    ; save registers
    push ax
    push bx
    push cx
    push dx

    push dx
    mov dx, seg buff1 
    mov es, dx ; setup extended segment
    mov di, offset buff1 ; save offset to di
    pop dx

    ; --------- print ax
    push ax ; push arg to stack
    call byte_to_decimal_string

    mov ax, offset buff1
    push ax ; push arg to stack
    call print1

    ; --------- print bx
    push bx ; push arg to stack
    call byte_to_decimal_string

    mov ax, offset buff1
    push ax ; push arg to stack
    call print1

    ; --------- print cx
    push cx ; push arg to stack
    call byte_to_decimal_string

    mov ax, offset buff1
    push ax ; push arg to stack
    call print1

    ; --------- print dx
    push dx ; push arg to stack
    call byte_to_decimal_string

    mov ax, offset buff1
    push ax ; push arg to stack
    call print1

    ; print newline
    push dx
    mov dx, offset text_newline
    push dx ; push arg to stack
    call print1
    pop dx

    ; load saved registers
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; argument on stack: byte to convert
; it fills memory pointed by di
byte_to_decimal_string:
    push bp ; save old base pointer on stack
    mov bp, sp ; set new base pointer in place of stack pointer
    push ax
    push bx
    push dx


    mov ax, word ptr ss:[bp + 4] ; get arg
    mov bx, 10d

    mov dx, 0
    div bx ; ax = (dx ax) / bx, dx = remainder
    add dl, 48d ; add 48d to remainder so it encodes ascii char
    mov byte ptr es:[di + 4], dl ; return  remainder as it is char to display

    mov dx, 0
    div bx ; ax = (dx ax) / bx, dx = remainder
    add dx, 48d ; add 48d to remainder so it encodes ascii char
    mov byte ptr es:[di + 3], dl ; return  remainder as it is char to display

    mov dx, 0
    div bx ; (dx ax) = ax / bx, dx = remainder
    add dx, 48d ; add 48d to remainder so it encodes ascii char
    mov byte ptr es:[di + 2], dl ; return  remainder as it is char to display

    mov dx, 0
    div bx ; ax = (dx ax) / bx, dx = remainder
    add dx, 48d ; add 48d to remainder so it encodes ascii char
    mov byte ptr es:[di + 1], dl ; return  remainder as it is char to display

    mov dx, 0
    div bx ; ax = (dx ax) / bx, dx = remainder
    add dx, 48d ; add 48d to remainder so it encodes ascii char
    mov byte ptr es:[di], dl ; return  remainder as it is char to display

    ; add newlines and terminate char
    mov byte ptr es:[di + 5], 10d 
    mov byte ptr es:[di + 6], 13d 
    mov byte ptr es:[di + 7], '$'

    pop dx
    pop bx
    pop ax
    mov sp, bp ; delete local variables - not needed here
    pop bp ; retrive old base pointer
    ret 2d


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