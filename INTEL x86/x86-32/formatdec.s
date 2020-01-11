section .bss
    buffer: resb 32

section .text
    global  formatdec
formatdec:
    push    ebp
    mov     ebp, esp
    sub     esp, 4

    push    esi
    push    edi
    push    ebx

    mov     esi, buffer
    mov     ecx, 10             ; divisor
    mov     eax, [ebp + 16]     ; dividend

    ; abs value of eax https://dustri.org/b/absolute-value-in-asm.html
    mov     edx, eax
    sar     edx, 0x1f
    xor     eax, edx
    sub     eax, edx

    ; converting input int to string (the number will be reversed)
intToString:
    xor     edx, edx
    div     ecx

    add     edx, '0'
    mov     [esi], edx
    inc     esi

    test    eax, eax
    jnz      intToString

    ; reverse the string
reverseString:
    mov     ebx, esi
    sub     ebx, buffer ; size of string
    ; mov     [ebp - 4], edx


    mov     edi, buffer
    dec     esi

    mov     eax, [ebp + 16]
    test    eax, eax
    jge     reverseLoop

    ; add minus sign
    ; inc     esi
    inc     ebx
    ; mov     [esi], byte '-'
reverseLoop:
    cmp     edi, esi
    jge     format
    
    mov     dl, [esi]
    mov     dh, [edi]
    mov     [edi], dl
    mov     [esi], dh
    dec     esi
    inc     edi
    jmp     reverseLoop

    ; write formatted data to string
format:
    mov     edi, [ebp + 8]
    mov     esi, [ebp + 12]
    mov     [ebp - 4], ebx

    xor     eax, eax ; width size
    xor     ebx, ebx ; number of additional characters
formatLoop:
    mov     dl, [esi]
    mov     [edi], dl

    test    dl, dl
    jz      end

    cmp     dl, '%'
    jne     increment

    inc     esi
    mov     dh, [esi]

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

    ; mov     ecx, [ebp + 16]
    ; test    ecx, ecx
    ; jl      findWidth

    ; mov     [edi], byte '+'
    ; inc     edi
    ; mov     ebx, 1

    cmp     dh, '+'
    je      checkPlusSign
    
    cmp     dh, '-'
    je      findWidth

    cmp     dh, ' '
    jne     increment

checkPlusSign:
    mov     ecx, [ebp + 16]
    test    ecx, ecx
    jl      findWidth
    mov     ebx, 1
    jmp     findWidth

zeroFlag:
    mov     ecx, [ebp + 16]
    test    ecx, ecx
    jge     findWidth
    mov     [edi], byte '-'
    inc     edi

    ; find width
findWidth:
    movzx     ecx, byte [esi]

    cmp     ecx, 'd'
    je      leftJustify

    cmp     ecx, '0'
    jl      increment
    cmp     ecx, '9'
    jg      increment

    imul    eax, 10
    add     eax, ecx
    sub     eax, '0'

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
    test    ecx, ecx
    jge     printPlusSign
    mov     [edi], byte '-'
    inc     edi
    jmp     insert
printPlusSign:
    cmp     dh, ' '
    je     spaceFlag

    cmp     dh, '+'
    jne     insert
plusFlag:
    mov     [edi], byte '+'
    inc     edi
    jmp     insert
spaceFlag:
    mov     [edi], byte ' '
    inc     edi

insert:
    ; %d occurs so insert number to ouput strings
    inc     esi
    mov     ecx, buffer
insertInt:
    mov     dl, [ecx]
    test    dl, dl
    jz      rightJustify

    mov     [edi], dl
    inc     ecx
    inc     edi
    jmp     insertInt

rightJustify:
    test    eax, eax
    jle    formatLoop
rightJustifyLoop:
    test    eax, eax
    jz      formatLoop
    mov     [edi], byte ' '
    inc     edi
    dec     eax
    jmp     rightJustifyLoop

increment:
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
