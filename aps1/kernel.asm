; comentarios

ORG 0x7C00
BITS 16
    jmp start

msg: db "hello world", 0x0D, 0x0A, 0

start:

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov si, msg
    call print_string

    xor ax, ax
    mov ax, 101
    call print_number

end:
    jmp $ ; halt


print_string:
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .loop
.done:
    ret

print_number:
    mov bx, 10
    mov cx, 0
.loop1:
    mov dx, 0
    div bx
    ; resposta vai ta no ax, resto no dx
    add dx, 48
    push dx
    inc cx
    cmp ax, 0
    jne .loop1
.loop2:
    pop ax
    mov ah, 0x0E
    int 0x10
    loop .loop2
.done:
    ret

; assinatura de boot

    times 510-($-$$) db 0
    dw 0xAA55
