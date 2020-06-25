; =============== REAL MODE ===============

[bits 16]
[org 0x7C00]
real_start:
    mov [var_boot], dl
    mov bp, 0x9000
    mov sp, bp

    ; TODO disk stuff

    call set_vga_gfx_mode
    mov si, real_msg
    call print_str

.enter_protected:
    cli
    lgdt [gdt_desc]
    or eax, 1
    mov cr0, eax
    jmp CODE:protected_start

set_vga_gfx_mode:
    mov ah, 0 ; clear
    mov al, 0x13 ; vga 16 color gfx mode 640x480
    int 0x10
    ret

print_str:
.read_ch:
    mov al, [si]
    or al, al
    jz .end
    cmp al, 0x1
    je .color
    mov ah, 0xE ; char out
    mov bh, 0
    int 0x10
    jmp .next
.color:
    inc si
    mov bl, [si]
.next:
    inc si
    jmp .read_ch
.end:
    ret

real_msg:
    db 1, 0x54 ; pink
    db 13, 10
    db ' hello', 13, 10,
    db 1, 0x2B ; gold
    db '   sparkles', 13, 10
    db 13, 10
    db 0

var_boot: db 0

gdt_entries:
.start:
	dd 0, 0
.code_kernel:
CODE equ $ - .start
	dw 0xFFFF, 0
	db 0, 0x9A, 0xCF, 0
.data_kernel:
DATA equ $ - .start
	dw 0xFFFF, 0
	db 0, 0x92, 0xCF, 0
.code_user:
	dw 0xFFFF, 0
	db 0, 0xFA, 0xCF, 0
.data_user:
	dw 0xFFFF, 0
	db 0, 0xF2, 0xCF, 0

gdt_desc:
	dw $ - gdt_entries - 1
	dd gdt_entries

; =============== PROTECTED MODE ===============

[bits 32]

VIDEO equ 0xB8000
GFX_MEM equ 0xA0000

protected_start:
    mov ax, DATA
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    ; ; only works in text modes
    ; mov esi, protected_msg
    ; call print_str32
    mov esi, sparkles_8bpp
    call draw_8bpp
    jmp $
    ; TODO .enter_long

; text mode only
print_str32:
    mov edi, VIDEO
    mov ebx, 0x0700
.read_ch:
    movsx eax, byte [esi]
    or eax, eax
    jz .end
    cmp eax, 1
    je .color
    add eax, ebx
    mov [edi], eax
    inc edi
    inc edi
    jmp .next
.color:
    inc esi
    movsx ebx, byte [esi]
    shl ebx, 8    
.next:
    inc esi
    jmp .read_ch
.end:
    ret

protected_msg:
    db 1, 0x34
    db 'protected'
    db 0

draw_8bpp:
    ; TODO: draw pixel data at middle of screen
    ; just draw test pixel for now, to prove we're in protected mode
    ; (GFX_MEM + x + 320y)
    mov [GFX_MEM + 2 + 320 * 2], byte 0xF
    ret

sparkles_8bpp:
    ; TODO: sparkles pixel data
    db 0

[bits 64]

long_start:
    ; TODO    
    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55 ; bsig
