section .text
    global  formatdec
formatdec:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 20

    push    rbx
    push    r12

    mov     r8, rdi
    mov     r9, rsi
    mov     r10, rdx

    lea     rsi, [rbp - 5]
    mov     [rsi], byte 0
    dec     rsi

    mov     rcx, 10             ; divisor
    mov     rax, r10            ; dividend

    ; calculate abs value of rax
    mov     rdx, rax
    cqo
    xor     rax, rdx
    sub     rax, rdx
    ; converting input int to string (the number will be reversed)
intToString:
    xor     rdx, rdx
    div     rcx

    add     dl, '0'
    mov     [rsi], dl
    dec     rsi
    test    rax, rax
    jnz     intToString

formatting:   
    lea     rbx, [rbp - 6]
    sub     rbx, rsi            ; size of string

    mov     rax, r10
    cmp     rax, 0
    jge     format
    ; add minus sign
    inc     rbx
    ; write formatted data to string
format:
    mov     rdi, r8
    mov     rsi, r9
    mov     r12, rbx
    ; jmp     end
formatLoop:
    xor     rax, rax            ; width size
    xor     rbx, rbx            ; number of additional characters

    mov     dl, [rsi]

    test    dl, dl
    jz      end

    cmp     dl, '%'
    jne     increment

    inc     rsi
    mov     dh, [rsi]

    test    dh, dh
    jz      end

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
spaceFlag:
    mov     rcx, r10
    cmp     rcx, 0
    jl      checkZeroFlag
    mov     [rdi], byte ' '
    inc     rdi
    
checkPlusSign:
    mov     rcx, r10
    cmp     rcx, 0
    jl      checkZeroFlag

    add     rbx, 1
checkZeroFlag:
    mov     dl, [rsi]
    cmp     dl, '0'
    jne     findWidth
    mov     dh, '0'

    mov     rcx, r10
    cmp     rcx, 0
    jl      zeroFlag     

    cmp     [rsi - 1], byte '+'
    jne      zeroFlag

    mov     [rdi], byte '+'
    inc     rdi
zeroFlag:
    mov     rcx, r10
    cmp     rcx, 0
    jge     findWidth

    mov     [rdi], byte '-'
    inc     rdi

    ; find width
findWidth:
    mov     cl, [rsi]

    cmp     cl, 'd'
    je      leftJustify

    cmp     cl, '0'
    jl      increment
    cmp     cl, '9'
    jg      increment

    lea    rax, [rax * 4 + rax]
    movzx   rcx, cl
    lea     rax, [rax * 2 + rcx - '0']

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
    cmp     rcx, 0
    jge     printPlusSign
    mov     [rdi], byte '-'
    inc     rdi
    jmp     insert

    ; print sign of the integer
printPlusSign:
    cmp     dh, '+'
    jne     insert
plusFlag:
    mov     [rdi], byte '+'
    inc     rdi
    ; insert integer to the format
insert:
    inc     rsi

    lea     rcx, [rbp - 5]
    sub     rcx, r12

    mov     rbx, r10
    cmp     rbx, 0
    jge     insertInt
    inc     rcx
insertInt:
    mov     dl, [rcx]
    test    dl, dl
    jz      rightJustify

    mov     [rdi], dl
    inc     rcx
    inc     rdi
    jmp     insertInt

rightJustify:
    cmp    rax, 0
    jle    formatLoop
rightJustifyLoop:
    test    rax, rax
    jz      formatLoop
    mov     [rdi], byte ' '
    inc     rdi
    dec     rax
    jmp     rightJustifyLoop

increment:
    mov     [rdi], dl
    inc     rdi
    inc     rsi
    jmp     formatLoop
    
end:
    mov     rax, r8

    mov     rsp, rbp
    pop     rbp
    ret

    pop     r12
    pop     rbx

    mov     rsp, rbp
    pop     rbp
    ret