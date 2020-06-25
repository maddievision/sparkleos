[bits 16]
[org 0x7C00]

boot:
    call clr
    call print_str
.forever:
    jmp .forever

clr:
    mov ah, 0 ; clear
    mov al, 0x13 ; vga 16 color gfx mode 640x480
    int 0x10
    ret

print_str:
    mov si, 0
.read_ch:
    mov al, [msg + si]
    mov bl, [msg.colors + si]
    or al, al
    jz .end
    mov ah, 0xE ; char out
    mov bh, 0
    int 0x10

    inc si
    jmp .read_ch
.end:
    ret

msg: db 13, 10, ' hello', 13, 10, '   sparkles', 13, 10, 0
.colors:
    times 10 db 0x54
    times 13 db 0x2B
    db 0

times 510 - ($ - $$) db 0
dw 0xAA55 ; bsig
