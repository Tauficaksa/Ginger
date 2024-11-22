section .text 
global inb

input_byte:
    ; Arguments:
    ; rdi = port number 

    ; Returns:
    ; al = data from the port

    mov dx, di ; Move the port number (lower 16 bits of rdi) into dx
    in al, dx  ; Read a byte from the port into al
    ret        ; Return, with the result in al