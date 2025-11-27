section .data
    sourceArray dw 10, 5, 8, 2, 1, 100, 50, 20
    dataSize    equ 2
    totalBytes  equ ($ - sourceArray)
    newline db 0xA
    space db ' '

section .bss
    destArray   resb totalBytes
    printBuffer resb 12

section .text
    global _start

_start:
    mov rsi, sourceArray
    mov rdi, destArray
    mov rcx, totalBytes
    mov rbx, dataSize
    call SortFunction

    mov rcx, 0
    mov r8, totalBytes
    mov r9, dataSize

.print_loop:
    cmp rcx, r8
    jge .exit_program

    movzx rax, word [destArray + rcx]
    call PrintDecWord

    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall

    add rcx, r9
    jmp .print_loop

.exit_program:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall


SortFunction:
    push rax
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9

    push rcx
    push rsi
    push rdi
    cld
    rep movsb
    pop rdi
    pop rsi
    pop rcx

    mov rax, rcx
    xor rdx, rdx
    div rbx
    mov rcx, rax

    cmp rcx, 1
    jle .Done

    dec rcx

    cmp rbx, 1
    je .SortByte
    cmp rbx, 2
    je .SortWord
    cmp rbx, 4
    je .SortDword
    cmp rbx, 8
    je .SortQword
    jmp .Done

.SortByte:
    mov r8, rcx
.OuterLoop1:
    mov r9, rdi
    mov rcx, r8
.InnerLoop1:
    movzx rax, byte [r9]
    movzx rdx, byte [r9+1]
    cmp al, dl
    jbe .Next1
    mov [r9], dl
    mov [r9+1], al
.Next1:
    inc r9
    dec rcx
    jnz .InnerLoop1
    dec r8
    jnz .OuterLoop1
    jmp .Done

.SortWord:
    mov r8, rcx
.OuterLoop2:
    mov r9, rdi
    mov rcx, r8
.InnerLoop2:
    movzx rax, word [r9]
    movzx rdx, word [r9+2]
    cmp ax, dx
    jbe .Next2
    mov [r9], dx
    mov [r9+2], ax
.Next2:
    add r9, 2
    dec rcx
    jnz .InnerLoop2
    dec r8
    jnz .OuterLoop2
    jmp .Done

.SortDword:
    mov r8, rcx
.OuterLoop4:
    mov r9, rdi
    mov rcx, r8
.InnerLoop4:
    mov eax, [r9]
    mov edx, [r9+4]
    cmp eax, edx
    jbe .Next4
    mov [r9], edx
    mov [r9+4], eax
.Next4:
    add r9, 4
    dec rcx
    jnz .InnerLoop4
    dec r8
    jnz .OuterLoop4
    jmp .Done

.SortQword:
    mov r8, rcx
.OuterLoop8:
    mov r9, rdi
    mov rcx, r8
.InnerLoop8:
    mov rax, [r9]
    mov rdx, [r9+8]
    cmp rax, rdx
    jbe .Next8
    mov [r9], rdx
    mov [r9+8], rax
.Next8:
    add r9, 8
    dec rcx
    jnz .InnerLoop8
    dec r8
    jnz .OuterLoop8

.Done:
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rax
    ret

PrintDecWord:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov rcx, printBuffer + 11
    mov rbx, 10

.divide_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rcx
    mov [rcx], dl
    cmp rax, 0
    jnz .divide_loop

    mov rsi, rcx
    mov rdi, printBuffer + 12
    sub rdi, rsi

    mov rax, 1
    mov rdi, 1
    mov rdx, rdi
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    ret