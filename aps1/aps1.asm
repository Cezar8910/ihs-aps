; Programa em Assembly x86 modo real para contar vogais em uma string
; Montador: MASM/TASM/NASM (com pequenas adaptações)
; Executa em DOS

org 100h

section .data
    msg db 'Exemplo de string para contar vogais.', 0
    vogais db 'AEIOUaeiou'
    resultado db 'Quantidade de vogais: ', 0
    contagem db 0

section .text
start:
    mov si, msg          ; SI aponta para o início da string
    mov bl, 0            ; BL = contador de vogais

proximo_caractere:
    mov al, [si]         ; Pega caractere atual
    cmp al, 0
    je fim_string        ; Fim da string

    ; Verifica se é vogal
    mov di, vogais
    mov cx, 10           ; 10 vogais
verifica_vogal:
    mov ah, [di]
    cmp al, ah
    je achou_vogal
    inc di
    loop verifica_vogal
    jmp nao_vogal

achou_vogal:
    inc bl               ; Incrementa contador

nao_vogal:
    inc si
    jmp proximo_caractere

fim_string:
    mov [contagem], bl

    ; Exibe mensagem "Quantidade de vogais: "
    mov dx, resultado
    call print_string

    ; Converte BL (contador) para ASCII e exibe
    mov al, bl
    add al, '0'
    mov ah, 0Eh
    int 10h

    ; Fim do programa
    mov ah, 4Ch
    int 21h

;----------------------------------------
; Rotina para imprimir string em DX
print_string:
    pusha
    mov ah, 0Eh
.next_char:
    mov al, [dx]
    cmp al, 0
    je .fim
    int 10h
    inc dx
    jmp .next_char
.fim:
    popa
    ret