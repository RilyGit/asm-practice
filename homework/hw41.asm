
section .data
    N           dq 10      
    MSG_IN      db 'Vhidne chyslo (N): '
    LEN_IN      equ $ - MSG_IN
    MSG_OUT     db 'Factorial (N!):   '
    LEN_OUT     equ $ - MSG_OUT
    NEWLINE     db 0Ah      

section .bss
    NUM_BUFFER  resb 21 

section .text
    global _start

_start:

    mov rax, [N]
  
    mov rax, 1         
    mov rdi, 1          
    mov rsi, MSG_IN
    mov rdx, LEN_IN
    syscall
    
    mov rax, [N]       
    call print_uint64   
    call print_newline

  
    mov rax, [N]      
    call factorial_iter 

    push rax            

    mov rax, 1
    mov rdi, 1
    mov rsi, MSG_OUT
    mov rdx, LEN_OUT
    syscall            

    pop rax             


    call print_uint64   
    call print_newline

   
    mov rax, 60      
    xor rdi, rdi       
    syscall

factorial_iter:
    push rbx
    push rcx
    
    mov rcx, rax        
    mov rax, 1          
    xor rdx, rdx        
    
    cmp rcx, 1
    jle .done           
    
    mov rbx, 2          
    
.loop:
    mul rbx
    inc rbx             
    cmp rbx, rcx        
    jle .loop
    
.done:
    pop rcx
    pop rbx
    ret

print_uint64:
    push    rax
    push    rcx
    push    rdx
    push    rsi
    
    mov     rcx, 10             
    mov     rsi, NUM_BUFFER + 20 
    
    cmp     rax, 0
    jne     .convert_loop
    dec     rsi                 
    mov     byte [rsi], '0'     
    jmp     .print

.convert_loop:
    xor     rdx, rdx            
    div     rcx                 
    add     dl, '0'             
    dec     rsi                 
    mov     [rsi], dl           
    test    rax, rax            
    jnz     .convert_loop

.print:

    mov     rdx, NUM_BUFFER + 20
    sub     rdx, rsi           
    
    mov     rax, 1        
    mov     rdi, 1            
    syscall
    
    pop     rsi
    pop     rdx
    pop     rcx
    pop     rax
    ret


print_newline:
    push    rax
    push    rdi
    push    rsi
    push    rdx
    
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, NEWLINE
    mov     rdx, 1
    syscall
    
    pop     rdx
    pop     rsi
    pop     rdi
    pop     rax
    ret