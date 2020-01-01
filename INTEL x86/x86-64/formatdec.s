section .bss
    buffer: resb 32

section .text
    global  formatdec
formatdec:
    push    rbp
    mov     rbp, rsp

    mov     r8, rdi
    mov     r9, rsi

    mov     rsi, buffer
    mov     rcx, 10     ; divisor
    mov     rax, rdx    ; dividend

    ; converting input int to string (the number will be reversed)
intToString:
    xor     rdx, rdx
    div     rcx

    add     rdx, '0'
    mov     [rsi], rdx
    inc     rsi

    test    rax, rax
    jnz      intToString

    ; reverse the string
reverseString:
    mov     rdi, buffer
    dec     rsi
reverseLoop:
    cmp     rdi, rsi
    jge     format
    
    mov     dl, [rsi]
    mov     dh, [rdi]
    mov     [rdi], dl
    mov     [rsi], dh
    dec     rsi
    inc     rdi
    jmp     reverseLoop

    ; write formatted data to string
format:
    mov     rdi, r8
    mov     rsi, r9
formatLoop:
    mov     dl, [rsi]
    mov     [rdi], dl

    test    dl, dl
    jz      end

    cmp     dl, '%'
    jne     increment

    mov     dh, [rsi + 1]
    cmp     dh, 'd'
    jne     increment

    ; %d occurs so insert number to ouput string
    add     rsi, 2
    mov     rcx, buffer
insertInt:
    mov     dl, [rcx]
    test    dl, dl
    jz      formatLoop

    mov     [rdi], dl
    inc     rcx
    inc     rdi
    jmp     insertInt

increment:
    inc     rdi
    inc     rsi
    jmp     formatLoop
    
end:
    mov     rax, r8

    mov     rsp, rbp
    pop     rbp
    ret
