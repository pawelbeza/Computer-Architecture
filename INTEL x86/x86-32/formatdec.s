    section .text
    global  formatdec
formatdec:
    push    ebp
    mov     ebp, esp
    sub     esp, 32

    push    esi
    push    edi
    push    ebx

    lea     esi, [ebp - 5]
    mov     [esi], byte 0
    dec     esi

    mov     ecx, 10             ; divisor
    mov     eax, [ebp + 16]     ; dividend

    ; calculate abs value of eax
    mov     edx, eax
    cdq
    xor     eax, edx
    sub     eax, edx
    ; converting input int to string (the number will be reversed)
intToString:
    xor     edx, edx
    div     ecx

    add     dl, '0'
    mov     [esi], dl
    dec     esi

    test    eax, eax
    jnz     intToString

formatting:   
    lea     ebx, [ebp - 6]
    sub     ebx, esi            ; size of string

    mov     eax, [ebp + 16]
    cmp     eax, 0
    jge     format
    ; add minus sign
    inc     ebx
    ; write formatted data to string
format:
    mov     edi, [ebp + 8]
    mov     esi, [ebp + 12]
    mov     [ebp - 4], ebx
formatLoop:
    xor     eax, eax            ; width size
    xor     ebx, ebx            ; number of additional characters

    mov     dl, [esi]

    test    dl, dl
    jz      end

    cmp     dl, '%'
    jne     increment

    inc     esi
    mov     dh, [esi]

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
    inc     esi
    cmp     dh, '+'
    je      checkPlusSign
    
    cmp     dh, '-'
    je      findWidth

    cmp     dh, ' '
    jne     increment
spaceFlag:
    mov     ecx, [ebp + 16]
    cmp     ecx, 0
    jl      checkZeroFlag
    mov     [edi], byte ' '
    inc     edi
    
checkPlusSign:
    mov     ecx, [ebp + 16]
    cmp     ecx, 0
    jl      checkZeroFlag

    add     ebx, 1
checkZeroFlag:
    mov     dl, [esi]
    cmp     dl, '0'
    jne     findWidth
    mov     dh, '0'

    mov     ecx, [ebp + 16]
    cmp     ecx, 0
    jl      zeroFlag     

    cmp     [esi - 1], byte '+'
    jne      zeroFlag

    mov     [edi], byte '+'
    inc     edi
zeroFlag:
    mov     ecx, [ebp + 16]
    cmp     ecx, 0
    jge     findWidth

    mov     [edi], byte '-'
    inc     edi

    ; find width
findWidth:
    mov     cl, [esi]

    cmp     cl, 'd'
    je      leftJustify

    cmp     cl, '0'
    jl      increment
    cmp     cl, '9'
    jg      increment

    lea    eax, [eax * 4 + eax]
    movzx   ecx, cl
    lea     eax, [eax * 2 + ecx - '0']

    inc     esi
    jmp     findWidth

leftJustify:
    mov     dl, ' '             ; for left justify by default fill with spaces
    sub     eax, [ebp-4]
    sub     eax, ebx            ; number of character to be added
    jle     sign
    
    cmp     dh, '-'
    je      sign

    cmp     dh, '0'
    jne     leftJustifyLoop
    mov     dl, '0'             ; fill left with zeros

leftJustifyLoop:
    test    eax, eax
    jz      sign
    mov     [edi], dl
    inc     edi
    dec     eax
    jmp     leftJustifyLoop

sign:
    cmp     dh, '0'
    je      insert

    mov     ecx, [ebp + 16]
    cmp     ecx, 0
    jge     printPlusSign
    mov     [edi], byte '-'
    inc     edi
    jmp     insert

    ; print sign of the integer
printPlusSign:
    cmp     dh, '+'
    jne     insert
plusFlag:
    mov     [edi], byte '+'
    inc     edi
    ; insert integer to the format
insert:
    inc     esi

    lea     ecx, [ebp - 5]
    sub     ecx, [ebp - 4]

    mov     ebx, [ebp + 16]
    cmp     ebx, 0
    jge     insertInt
    inc     ecx
insertInt:
    mov     dl, [ecx]
    test    dl, dl
    jz      rightJustify

    mov     [edi], dl
    inc     ecx
    inc     edi
    jmp     insertInt

rightJustify:
    cmp    eax, 0
    jle    formatLoop
rightJustifyLoop:
    test    eax, eax
    jz      formatLoop
    mov     [edi], byte ' '
    inc     edi
    dec     eax
    jmp     rightJustifyLoop

increment:
    mov     [edi], dl
    inc     edi
    inc     esi
    jmp     formatLoop
    
end:
    mov     eax, [ebp + 8]

    pop     ebx
    pop     edi
    pop     esi

    mov     esp, ebp
    pop     ebp
    ret
