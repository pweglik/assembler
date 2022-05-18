assume cs:code1

data1 segment

data1 ends


code1 segment
program_start: 
    ; init stack
    mov ax, seg stos1
    mov ss, ax
    mov sp, offset ws1

    ; change display mode
    mov ah, 0
    ; use 320x200 VGA mode
    mov al, 13h
    ; BIOS interrupt
    int 10h

    ; set es to start of video card memory
    mov ax, 0a000h
    mov es, ax

    mov cx, 200d
    _for1:
        push cx ; save cx
        mov bx, cx ; save horizontal iterator
        mov cx, 255d
        _for2:
            ; save bx
            push bx

            ; construct arguments
            mov ax, 255d ; color
            sub ax, cx
            push ax

            mov ax, 200d; y
            sub ax, bx
            push ax 

            mov ax, 255d ; x
            sub ax, cx
            push ax

            ; call with stack from top: x, y, color
            call draw_point

            pop bx ; get bx
            loop _for2

        pop cx ; get cx
        loop _for1





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

code1 ends


stos1 segment stack
        dw 200 dup(?)
ws1     dw ?
stos1 ends

end program_start