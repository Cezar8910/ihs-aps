section .text
    global calc_cone_volume

calc_cone_volume:
    push ebp
    mov ebp, esp

    finit 

    fld dword [ebp+8]
    fmul st0, st0
    fld dword [ebp+12]
    fmul st1, st0
    fldpi
    fmul st0, st1

    fld1
    fld1
    fld1
    fadd st0, st1
    fadd st0, st2
    fdiv st1, st0
    fstp st0
    fstp st0

    mov esp, ebp
    pop ebp
    ret
