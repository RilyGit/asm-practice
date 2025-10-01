section .data
    msg_prime       db " is prime", 10
    msg_prime_len   equ $-msg_prime
    msg_not_prime   db " is not prime", 10
    msg_not_prime_len equ $-msg_not_prime

section .bss
    num_str resb 20

section .text
global _start

_start:
    mov ax, 17
    movzx rbx, ax

    mov rax, rbx
    mov rsi, num_str
    call print_number

    mov rax, rbx
    call is_prime
    cmp rax, 1
    je prime_label

not_prime_label:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_not_prime
    mov rdx, msg_not_prime_len
    syscall
    jmp exit_program

prime_label:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_prime
    mov rdx, msg_prime_len
    syscall

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall

print_number:
    push rbx
    push rcx
    mov rdi, rsi
    add rdi, 19
    mov byte [rdi], 0
    dec rdi
    mov rbx, rax
    mov rcx, 0
    cmp rbx, 0
    jne .convert_loop
    mov byte [rdi], '0'
    inc rcx
    jmp .print

.convert_loop:
    xor rdx, rdx
    mov rax, rbx
    mov r8, 10
    div r8
    add dl, '0'
    mov [rdi], dl
    dec rdi
    inc rcx
    mov rbx, rax
    test rbx, rbx
    jnz .convert_loop

.print:
    inc rdi
    mov rax, 1
    mov rsi, rdi
    mov rdx, rcx
    mov rdi, 1
    syscall
    pop rcx
    pop rbx
    ret

is_prime:
    push rbx
    push rcx
    push rdx
    cmp rax, 3
    jle .handle_small_numbers
    test al, 1
    jz .not_prime
    mov rbx, rax
    mov rcx, 3

.loop:
    mov rax, rcx
    mul rcx
    cmp rax, rbx
    jg .prime
    mov rax, rbx
    xor rdx, rdx
    div rcx
    test rdx, rdx
    jz .not_prime
    add rcx, 2
    jmp .loop

.handle_small_numbers:
    cmp rax, 2
    jl .not_prime
    jmp .prime

.prime:
    mov rax, 1
    jmp .done

.not_prime:
    mov rax, 0

.done:
    pop rdx
    pop rcx
    pop rbx
    ret