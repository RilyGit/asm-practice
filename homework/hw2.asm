section .data
    buffer db 20 dup(0)     

section .text
    global _start

int2str:
    push rax
    push rsi

    mov rcx, 0        
    mov rbx, 10

.convert_loop:
    xor rdx, rdx       
    div rbx            
    add dl, '0'        
    push rdx           
    inc rcx
    test rax, rax
    jnz .convert_loop

.write_digits:
    pop rax
    mov [rsi], al
    inc rsi
    loop .write_digits 

    mov byte [rsi], 0 

    pop rsi
    pop rax
    ret

_start:
    mov rax, 1234567   
    mov rsi, buffer     
    call int2str

    mov rax, 1          
    mov rdi, 1          
    mov rsi, buffer
    mov rdx, 7          
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

