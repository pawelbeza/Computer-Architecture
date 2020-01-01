section .bss
    buffer: resb 32

section .text
    global  formatdec
formatdec:
    push    ebp
    mov     ebp, esp

    push    esi
    push    edi

    mov     esi, buffer
    mov     ecx, 10             ; divisor
    mov     eax, [ebp + 16]     ; dividend

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
    mov     edi, buffer
    dec     esi
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
formatLoop:
    mov     dl, [esi]
    mov     [edi], dl

    test    dl, dl
    jz      end

    cmp     dl, '%'
    jne     increment

    mov     dh, [esi + 1]
    cmp     dh, 'd'
    jne     increment

    ; %d occurs so insert number to ouput string
    add     esi, 2
    mov     ecx, buffer
insertInt:
    mov     dl, [ecx]
    test    dl, dl
    jz      formatLoop

    mov     [edi], dl
    inc     ecx
    inc     edi
    jmp     insertInt

increment:
    inc     edi
    inc     esi
    jmp     formatLoop
    
end:
    mov     eax, [ebp + 8]

    pop     edi
    pop     esi

    mov     esp, ebp
    pop     ebp
    ret
