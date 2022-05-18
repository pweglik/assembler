dane1 segment
    a4      db 12
    d1      db 13
    text1   db "ABC$"
    w1      dw 300


dane1 ends


code1 segment
s1: mov ax, seg stos1
    mov ss, ax
    mov sp, offset ws1

    mov ax, seg text1
    mov ds, ax
    mov dx, offset text1
    mov ah, 9; print text
    int 21h ; przerwanie DOS

    mov ax, 4c00h ;end progrema
    int 21h


code1 ends


stos1 segment stack
        dw 200 dup(?)
ws1     dw ?
stos1 ends

end s1