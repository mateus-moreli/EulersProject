%macro write 3
    mov eax, 4
    mov ebx, %1
    mov ecx, %2
    mov edx, %3
    int 0x80
%endmacro

%macro exit 1
    mov eax, 1
    mov ebx, %1
    int 0x80
%endmacro

%define STDOUT 1

section .text
global _start

_start:
    mov ecx, 1000        ; contador de 0 até 999
    xor edi, edi         ; número atual
    xor eax, eax         ; acumulador da soma

.loop:
    mov edx, edi
    mov ebx, 3
    xor edx, edx
    mov edx, edi
    mov ebx, 3
    xor edx, edx
    mov eax, edi
    xor edx, edx
    div ebx
    test edx, edx
    jz .add

    mov eax, edi
    mov ebx, 5
    xor edx, edx
    div ebx
    test edx, edx
    jnz .skip

.add:
    add esi, edi

.skip:
    inc edi
    loop .loop

    ; Conversão para string decimal

    mov eax, esi         ; valor da soma
    sub esp, 12          ; espaço para 10 dígitos + \n + null
    mov edi, esp
    mov ecx, 0           ; contador de dígitos

    cmp eax, 0
    jne .convert
    mov byte [edi], '0'
    inc edi
    jmp .done

.convert:
    mov ebx, 10

.convert_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    inc ecx
    test eax, eax
    jnz .convert_loop

.done:
    mov edx, ecx         ; tamanho da string
    write STDOUT, edi, edx
    add esp, 12
    exit 0



