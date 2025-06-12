; diretivas para o assembler
org 0x7C00
bits 16

jmp start

; Dados
hello db "hello world", 0x0D, 0x0A, 0
msg   db "escreva algo: ", 0
fim   db "fim do programa",0x0D,0xA, 0
buffer times 64 db 0  ; buffer para entrada do teclado

; inicio do programa
start:
configurando_ivt:
    push ds
    xor ax, ax
    mov ds, ax ;; garantir DS = 0

    mov word[0x100], interrupt_40h      ; offset
    mov word[0x102], 0x0000             ; segmento

    pop ds ;; restaurar DS antigo

    ;; imprimir "hello world"
    mov ax, hello
    push ax
    int 0x40
    add sp, 2

    ;; imprimir mensagem
    mov ax, msg
    push ax
    int 0x40
    add sp, 2

    ;; ler string do teclado para o buffer
    mov di, buffer
    call get_keyboard_input

    ;; chamar int 40h com offset do buffer
    mov ax, buffer
    push ax
    int 0x40
    add sp, 2

    ;; imprimir fim
    mov ax, fim
    push ax
    int 0x40
    add sp, 2

fim_loop:
    jmp $ ; halt

; -------------------
; Rotina da INT 40h
interrupt_40h:
    call print_string
    iret

; -------------------
; Lê string do teclado até ENTER
get_keyboard_input:
    pusha
.getchar:
    mov ah, 0x00
    int 0x16         ; esperar por tecla
    cmp al, 0x0D
    je .done
    mov [di], al     ; salvar no buffer
    inc di

    mov ah, 0x0E     ; ecoar caractere
    int 0x10
    jmp .getchar
.done:
    mov byte [di], 0 ; null terminador
    popa
    ret

; -------------------
; Imprime string apontada por [bp+8]
print_string:
    push bp
    mov bp, sp
    mov si, [bp+8]

.print_loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .print_loop
.done:
    pop bp
    ret

; -------------------
; Assinatura do boot sector
times 510-($-$$) db 0
dw 0xAA55
