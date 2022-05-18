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






    ; exmample colors
    ; mov cx, 200d
    ; _for1:
    ;     push cx ; save cx
    ;     mov bx, cx ; save horizontal iterator
    ;     mov cx, 255d
    ;     _for2:
    ;         ; save bx
    ;         push bx

    ;         ; construct arguments
    ;         mov ax, 255d ; color
    ;         sub ax, cx
    ;         push ax

    ;         mov ax, 200d; y
    ;         sub ax, bx
    ;         push ax 

    ;         mov ax, 255d ; x
    ;         sub ax, cx
    ;         push ax

    ;         ; call with stack from top: x, y, color
    ;         call draw_point

    ;         pop bx ; get bx
    ;         loop _for2

    ;     pop cx ; get cx
    ;     loop _for1





    ; wait for any key before end
    xor ax, ax
    int 16h

program_end:
    ; go back to text mode
    mov ah, 0
    ; use text mode
    mov al, 3h
    ; BIOS interrupt
    int 10h 

    mov ax, 4c00h ; end progrema
    int 21h

; pseudo code for procedure from wikipedia
; draw_line(x0, y0, x1, y1)
;     delta_x = x1 - x0
;     delta_y = y1 - y0
;     D = 2*delta_y - delta_x
;     y = y0

;     for x from x0 to x1
;         plot(x,y)
;         if D > 0
;             y = y + 1
;             D = D - 2*delta_x
;         end if
;         D = D + 2*delta_y

; args on stack: x0, y0, x1, y1
; qw use registers as such:
; cx <- x, al <- y, ah <- delta_y, dx <- D, stack <- delta_x
; we use bx for other temporary operations 
draw_line:
    push bp
    mov bp, sp

    mov ax, word ptr ss:[bp + 8] ; x1
    mov bx, word ptr ss:[bp + 4] ; x0
    ; delta_x = x1 - x0
    sub, ax, bx
    push ax ; save delta_x to stack

    mov ax, word ptr ss:[bp + 10] ; y1
    mov bx, word ptr ss:[bp + 6] ; y0





;args on stack - 3 words: x, y, color 
draw_point:
    push bp
    mov bp, sp


    ; calculate 320 * y + x
    mov bx, 320d
    mov ax, word ptr ss:[bp + 6]
    mul bx ; (dx ax) = ax * 320 (bx), but we ignore dx as we never overflow into it
    mov bx, word ptr ss:[bp + 4]
    add bx, ax ; bx = 320 * y + x

    mov ax, word ptr ss:[bp + 8] ; set colot

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