    extern printf
    extern soma

    section .data
a:   dd 15
b:   dd 10
c:   dd 15
msg: db "soma deu: %d",10,0

    section .text
    global main
main:
    push ebp
    mov ebp, esp

    push dword[c]
    push dword[b]
    push dword[a]
    call soma
    add esp, 12 ; pop stack -> 4 bytes * 3 pushs

    push eax
    push msg
    call printf
    add esp, 8

    mov esp, ebp
    pop ebp

    mov eax, 0
    ret


