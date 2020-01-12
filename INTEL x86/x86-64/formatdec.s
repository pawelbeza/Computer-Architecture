section .bss
    buffer: resb 32

section .text
    global  formatdec
formatdec:
    push    rbp
    mov     rbp, rsp

    push    rbx
    push    r12

    mov     r8, rdi
    mov     r9, rsi
    mov     r10, rdx

    mov     rsi, buffer
    mov     rcx, 10             ; divisor
    mov     rax, r10            ; dividend

    ; calculate abs value of rax
    mov     rdx, rax
    cqo
    ; sar     rdx, 63
    xor     rax, rdx
    sub     rax, rdx

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
    mov     rbx, rsi
    sub     rbx, buffer         ; size of string

    mov     rdi, buffer
    dec     rsi

    mov     rax, r10
    test    rax, rax
    jge     reverseLoop

    ; add minus sign
    inc     rbx
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
    mov     r12, rbx

    xor     rax, rax            ; width size
    xor     rbx, rbx            ; number of additional characters
formatLoop:
    mov     dl, [rsi]
    mov     [rdi], dl

    test    dl, dl
    jz      end

    cmp     dl, '%'
    jne     increment

    inc     rsi
    mov     dh, [rsi]

    cmp     dh, 'd'
    je      sign

noFlags:
    cmp     dh, '0'
    je      zeroFlag

    cmp     dh, '0'
    jl      flags
    cmp     dh, '9'
    jle     findWidth           

flags:
    inc     rsi

    cmp     dh, '+'
    je      checkPlusSign
    
    cmp     dh, '-'
    je      findWidth

    cmp     dh, ' '
    jne     increment

checkPlusSign:
    mov     rcx, r10
    test    rcx, rcx
    jl      findWidth
    mov     rbx, 1
    jmp     findWidth

zeroFlag:
    mov     rcx, r10
    test    rcx, rcx
    jge     findWidth
    mov     [rdi], byte '-'
    inc     rdi

    ; find width
findWidth:
    movzx   rcx, byte [rsi]

    cmp     rcx, 'd'
    je      leftJustify

    cmp     rcx, '0'
    jl      increment
    cmp     rcx, '9'
    jg      increment

    imul    rax, 10
    lea     rax, [rax + rcx - '0']

    inc     rsi
    jmp     findWidth

leftJustify:
    mov     dl, ' '             ; for left justify by default fill with spaces
    sub     rax, r12
    sub     rax, rbx            ; number of character to be added
    jle     sign
    
    cmp     dh, '-'
    je      sign

    cmp     dh, '0'
    jne     leftJustifyLoop
    mov     dl, '0'             ; fill left with zeros

leftJustifyLoop:
    test    rax, rax
    jz      sign
    mov     [rdi], dl
    inc     rdi
    dec     rax
    jmp     leftJustifyLoop

sign:
    cmp     dh, '0'
    je      insert

    mov     rcx, r10
    test    rcx, rcx
    jge     printPlusSign
    mov     [rdi], byte '-'
    inc     rdi
    jmp     insert

    ; print sign of the integer
printPlusSign:
    cmp     dh, ' '
    je     spaceFlag

    cmp     dh, '+'
    jne     insert
plusFlag:
    mov     [rdi], byte '+'
    inc     rdi
    jmp     insert
spaceFlag:
    mov     [rdi], byte ' '
    inc     rdi

    ; insert integer to the format
insert:
    inc     rsi
    mov     rcx, buffer
insertInt:
    mov     dl, [rcx]
    test    dl, dl
    jz      rightJustify

    mov     [rdi], dl
    inc     rcx
    inc     rdi
    jmp     insertInt

rightJustify:
    test    rax, rax
    jle    formatLoop
rightJustifyLoop:
    test    rax, rax
    jz      formatLoop
    mov     [rdi], byte ' '
    inc     rdi
    dec     rax
    jmp     rightJustifyLoop

increment:
    inc     rdi
    inc     rsi
    jmp     formatLoop
    
end:
    mov     rax, r8

    pop     r12
    pop     rbx

    mov     rsp, rbp
    pop     rbp
    ret