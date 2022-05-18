dane1 segment
    text2   db "Stop the war!", 10, 13, '$'
    buff1 db 300 dup('$')
dane1 ends


code1 segment
s1:
; init stack
        mov ax, seg ws1
        mov ss, ax
        mov sp, offset ws1

;       ds: -<- PSP
;       080h -> ilosc znakow
;       081h -> spacja
;       082 -> string paramterow

        ; taking params
        mov ax, seg buff1
        mov es, ax
        ; set si and di
        mov si, 082h
        mov di, offset buff1
        xor cx, cx ; cx = 0
        mov cl, byte ptr ds:[80h]


p1:     
        mov al, byte ptr ds:[si]
        mov byte ptr es:[di], al
        inc si
        inc di
        loop p1 ; cx = cx - 1, if cx != 0 then goto p1


;alternative to loop:
        ; cld     ; clear direction flag - czyli idz z rosnacymi adresami
        ; rep movsb ; es:[di] <= ds:[si], si++ (lub -- w zależność od DF)
        ; rep makes it repeat cx times

        mov dx, offset buff1
        call print1

        mov ax, 4c00h ;end progrema
        int 21h


; arg: dx = offset w dane1 textu do wypisania 
print1:
    mov ax, seg dane1
    mov ds, ax
    mov ah, 9; print text
    int 21h ; przerwanie DOS
    ret


code1 ends

stos1 segment stack
        dw 200 dup(?)
ws1     dw ?
stos1 ends


end s1