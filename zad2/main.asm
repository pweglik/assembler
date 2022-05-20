assume cs:code1

data1 segment
    buff1 db 100 dup('$')
    text_newline db 10, 13, '$'
    text_1 db "1$"
    text_2 db "2$"
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

    ; triangle
    ; we need to push in reverse order
    mov ax, 50d ; y3
    push ax
    mov ax, 50d ; x3
    push ax
    mov ax, 100d ; y2
    push ax
    mov ax, 100d ; x2
    push ax 
    mov ax, 60d ; y1
    push ax
    mov ax, 150d ; x1
    push ax 
    mov ax, 50d ; y0
    push ax
    mov ax, 50d ; x0
    push ax 
    mov ax, 13d ; color
    push ax 
    mov ax, 4d ; number of points
    push ax

    ; args on stack: color, x0, y0, x1, y1, 
    call draw_figure

    mov ax, 4d
    mov bx, 4d
    mul bx ; 4 * num of points
    add ax, 4 ; color and no of points
    sub sp, ax

    ; upside dowm  triangle
    ; we need to push in reverse order
    mov ax, 50d ; y3
    push ax
    mov ax, 200d ; x3
    push ax
    mov ax, 80d ; y2
    push ax
    mov ax, 150d ; x2
    push ax 
    mov ax, 80d ; y1
    push ax
    mov ax, 250d ; x1
    push ax 
    mov ax, 50d ; y0
    push ax
    mov ax, 200d ; x0
    push ax 
    mov ax, 13d ; color
    push ax 
    mov ax, 4d ; number of points
    push ax

    ; args on stack: color, x0, y0, x1, y1, 
    call draw_figure

    mov ax, 4d
    mov bx, 4d
    mul bx ; 4 * num of points
    add ax, 4 ; color and no of points
    sub sp, ax

    ; swuare
    ; we need to push in reverse order
    mov ax, 100d ; y4
    push ax
    mov ax, 200d ; x4
    push ax
    mov ax, 150d ; y3
    push ax
    mov ax, 200d ; x3
    push ax
    mov ax, 150d ; y2
    push ax
    mov ax, 250d ; x2
    push ax 
    mov ax, 100d ; y1
    push ax
    mov ax, 250d ; x1
    push ax 
    mov ax, 100d ; y0
    push ax
    mov ax, 200d ; x0
    push ax 
    mov ax, 10d ; color
    push ax 
    mov ax, 5d ; number of points
    push ax

    ; args on stack: color, x0, y0, x1, y1, 
    call draw_figure

    mov ax, 5d
    mov bx, 4d
    mul bx ; 4 * num of points
    add ax, 6 ; color and no of points
    sub sp, ax

    ; weird shape

    ; we need to push in reverse order
    mov ax, 100d ; y6
    push ax
    mov ax, 100d ; x6
    push ax
    mov ax, 40d ; y5
    push ax
    mov ax, 60d ; x5
    push ax
    mov ax, 130d ; y4
    push ax
    mov ax, 60d ; x4
    push ax
    mov ax, 160d ; y3
    push ax
    mov ax, 80d ; x3
    push ax
    mov ax, 180d ; y2
    push ax
    mov ax, 130d ; x2
    push ax 
    mov ax, 120d ; y1
    push ax
    mov ax, 150d ; x1
    push ax 
    mov ax, 100d ; y0
    push ax
    mov ax, 100d ; x0
    push ax 
    mov ax, 12d ; color
    push ax 
    mov ax, 7d ; number of points
    push ax

    ; args on stack: color, x0, y0, x1, y1, 
    call draw_figure

    mov ax, 7d
    mov bx, 4d
    mul bx ; 4 * num of points
    add ax, 4 ; color and no of points
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
    push bp
    mov bp, sp ; save base pointer

    mov cx, word ptr ss:[bp + 4] ; set cx to number of points

    ; get color
    mov ax, word ptr ss:[bp + 6]
    mov word ptr cs:[fig_color], ax

    ; mov di, cx
    ; rol di, 1 
    ; rol di, 1 ; multiply by 4 to accoutn for 2 words per point
    ; add di, 8d ; account for ip, bp, num of params and color
    ; mov dx, word ptr ss:[bp + di - 4] ; x_0 = x_(n-1)

    sub cx, 1d ; account for already taking 1st point

    _draw_figure_for1:
        push cx
        push word ptr cs:[fig_color] ; put color on argument stack for draw_line

        ; logic do get nth point
        mov di, cx
        rol di, 1 
        rol di, 1 ; multiply by 4 to accoutn for 2 words per point
        add di, 8d ; account for ip, bp, num of params and color

        mov ax, word ptr ss:[bp + di] ; x_n
        cmp ax, dx
        ja _draw_figure_if1 ; if x_n < x_(n-1)
            ; we need to push in reverse order
            mov ax, word ptr ss:[bp + di - 2] ; x_n ; y1
            push ax
            mov ax, word ptr ss:[bp + di - 4] ; x_n ; x1
            push ax 
            mov ax, word ptr ss:[bp + di + 2] ; x_n ; y0
            push ax
            mov ax, word ptr ss:[bp + di] ; x_n ; x0
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

        pop cx
        mov dx, word ptr ss:[bp + di - 8] ; get new dx
        loop _draw_figure_for1


    _draw_figure_end:
    mov sp, bp ; delete local variables 
    pop bp ; retrive old base pointer
    ret

fig_color dw 0

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
; cx <- x, bx <- y, dx <- D
; we use ax for other temporary operations 
; we exchange y with x in slope > 1 version
draw_line:
    push bp
    mov bp, sp

    mov ax, word ptr ss:[bp + 8] ; x1
    mov bx, word ptr ss:[bp + 4] ; x0
    ; delta_x = x1 - x0
    sub ax, bx
    mov word ptr cs:[delta_x], ax ; save delta_x to stack

    mov ax, word ptr ss:[bp + 10] ; y1
    mov bx, word ptr ss:[bp + 6] ; y0
    ; delta_y = y1 - y0
    sub ax, bx
    mov word ptr cs:[delta_y], ax ; save delta_y to bh

    mov ax, word ptr ss:[bp + 4] ; x0
    cmp ax, word ptr ss:[bp + 8]
    jle _no_swap ; if x0 > x1
        neg word ptr cs:[delta_x]
        ; exchange x's
        mov bx, word ptr ss:[bp + 8] ; x1
        xchg ax, bx

        mov word ptr ss:[bp + 4], ax 
        mov word ptr ss:[bp + 8], bx

        ; exchange y's
        mov ax, word ptr ss:[bp + 6] ; y0
        mov bx, word ptr ss:[bp + 10]; y1
        xchg ax, bx

        mov word ptr ss:[bp + 6], ax 
        mov word ptr ss:[bp + 10], bx

    _no_swap:

    cmp word ptr cs:[delta_y], 0d
    jge _no_negative_delta_y ; if delta_y < 0
        neg word ptr cs:[delta_y]

        mov bx, word ptr ss:[bp + 10] ; y1
        neg bx
        mov word ptr ss:[bp + 10], bx
        mov bx, word ptr ss:[bp + 6] ; y0
        neg bx
        mov word ptr ss:[bp + 6], bx

    _no_negative_delta_y:

    mov ax, word ptr cs:[delta_x]
    cmp ax, word ptr cs:[delta_y]
    jb _draw_line_if1 ; if delta_x >= delta_y

        ; y = y0
        mov bx, word ptr ss:[bp + 6]

        ; D = 2*delta_y - delta_x
        xor dx, dx
        mov dx, word ptr cs:[delta_y]
        rol dx, 1; multily by two 

        sub dx, word ptr cs:[delta_x] ; dx = D = 2*delta_y - delta_x

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
            push bx 

            ; x
            push cx
            
            call draw_point
            ; get bx and dx
            pop dx
            pop bx

            
            cmp dx, 0
            jle _draw_line_if2 ; if D > 0
                ; y = y + 1
                add bx, 1d
                ; D = D - 2*delta_x
                ; get delta_x
                mov ax, word ptr cs:[delta_x]
                rol ax, 1; multily by two 

                sub dx, ax


            _draw_line_if2:

            ; D = D + 2*delta_y
            xor ax, ax
            mov ax, word ptr cs:[delta_y] ; load delta_y to ax

            rol ax, 1; multily by two 

            add dx, ax

            ; end loop
            inc cx
            cmp cx, word ptr ss:[bp + 8]
            jle _draw_line_for1; loop if x <= x1

        jmp _draw_line_end

    _draw_line_if1: ; if delta_x < delta_y (or just else)
        ; x = x0
        mov bx, word ptr ss:[bp + 4]
        ; D = 2*delta_x - delta_y
        mov dx, word ptr cs:[delta_x]
        rol dx, 1; multily by two 

        sub dx, word ptr cs:[delta_y] ; dx = D = 2*delta_x - delta_y

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
            push cx

            ; x
            push bx
            
            call draw_point
            ; get bx and dx
            pop dx
            pop bx

            ; if D > 0
            cmp dx, 0
            jle _draw_line_if3
                ; x = x + 1
                add bx, 1d

                ; D = D - 2*delta_y
                ; get delta_y
                mov ax, word ptr cs:[delta_y]
                rol ax, 1; multily by two 

                sub dx, ax


            _draw_line_if3:

            ; D = D + 2*delta_x
            ; get delta_x
            mov ax, word ptr cs:[delta_x]

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

delta_y dw 0
delta_x dw 0 


;args on stack - 3 words: x, y, color 
; it destroys ax, bx, and dx!
draw_point:
    push bp
    mov bp, sp


    ; calculate 320 * (199-y) + x, because we treat screen as I quater of cartesian plane
    ; check if y ise negative if it is, flip it

    cmp word ptr ss:[bp + 6], 0d
    jge _draw_point_if1
        neg word ptr ss:[bp + 6] 
    _draw_point_if1:

    mov bx, word ptr ss:[bp + 6]


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
    push di

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
    pop di
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
            dw 400 dup(?)
stack_top   dw ?
stack1 ends

end program_start