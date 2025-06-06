ORG 0x7C00
BITS 16

    jmp start

msg:         db "Exemplo de string para contar vogais.", 0
vogais:      db "AEIOUaeiou", 0
resultado:   db "Qtd de vogais: ", 0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, resultado
    call print_string

    mov si, msg
    xor bx, bx

.proximo_caractere:
    lodsb
    or al, al
    jz .fim_contagem

    push si
    mov di, vogais
    mov cx, 10
.verifica_vogal:
    mov ah, [di]
    cmp al, ah
    je .achou_vogal
    inc di
    loop .verifica_vogal
    jmp .nao_vogal

.achou_vogal:
    inc bl

.nao_vogal:
    pop si
    jmp .proximo_caractere

.fim_contagem:
    mov ax, bx
    call print_number

halt:
    jmp $

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
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    cmp ax, 0
    jne .loop1
.loop2:
    pop ax
    mov ah, 0x0E
    int 0x10
    loop .loop2
    ret

times 510 - ($ - $$) db 0
dw 0xAA55