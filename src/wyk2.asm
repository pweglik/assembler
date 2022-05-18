dane1 segment
    a4      db 12
    d1      db 13
    text1   db "ABC$"
    text2   db 13, 10, "Stop the war! $"
    text3   db 13, 10, "1234$"
    w1      dw 300
dane1 ends


code1 segment
s1:    
        mov ax, seg stos1
        mov ss, ax
        mov sp, offset ws1

        mov dx, offset text1
        call print1

        mov dx, offset text2
        call print1

        mov dx, offset text3
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