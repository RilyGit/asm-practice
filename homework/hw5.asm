section .data
    BORDER  equ '#'  
    DOT     equ '#'   
    SPACE   equ ' '  
    CR      equ 13     
    LF      equ 10      

section .bss
    line_buffer:    resb 255 + 2   
    height:         resb 1         
    width:          resb 1      

section .text
    global _start

_start:
    mov ah, 36
    mov al, 18

    mov [width], ah    
    mov [height], al   

    call drawEnvelope

    mov eax, 1         
    xor ebx, ebx        
    int 0x80

drawEnvelope:
    push ebp           
    mov ebp, esp

    call prepareLineBuffer  

    call printBorderLine
    call printCenterLines   
    call printBorderLine   

    pop ebp           
    ret

prepareLineBuffer:
    push eax
    movzx eax, byte [width]   
    mov [line_buffer + eax], byte CR 
    inc eax
    mov [line_buffer + eax], byte LF 
    pop eax
    ret

printBorderLine:
    push ecx
    push eax

    movzx ecx, byte [width]   
    xor eax, eax      
fill_loop:
    mov [line_buffer + eax], byte BORDER
    inc eax
    loop fill_loop      

    call printLine    

    pop eax
    pop ecx
    ret

printCenterLines:
    push ebp            
    mov ebp, esp
    sub esp, 8          

    mov dword [ebp-4], 0

    xor eax, eax
    
    movzx eax, byte [width]
    div byte [height]   
    mov [ebp-8], al    

    push ecx
    push edx
    movzx ecx, byte [width]
    sub ecx, 2         
    mov edx, 1          
clear_loop:
    mov [line_buffer + edx], byte SPACE
    inc edx
    loop clear_loop
    pop edx
    pop ecx

    push ecx
    movzx ecx, byte [height]
    sub cl, 2          
dot_loop:
    push ecx           

    xor eax, eax
    mov al, [ebp-8]    
    add [ebp-4], eax    

    mov edx, [ebp-4]   
    mov [line_buffer + edx], byte DOT

    movzx ebx, byte [width]
    dec ebx
    sub ebx, edx      
    mov [line_buffer + ebx], byte DOT

    call printLine

    mov [line_buffer + edx], byte SPACE
    mov [line_buffer + ebx], byte SPACE

    pop ecx           
    loop dot_loop
    pop ecx

    mov esp, ebp      
    pop ebp
    ret

printLine:
    pusha              

    movzx edx, byte [width]
    add edx, 2         
    mov ecx, line_buffer 
    mov ebx, 1          
    mov eax, 4        
    int 0x80

    popa                
    ret