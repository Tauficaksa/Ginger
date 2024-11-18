global longmode_start
extern kernel_main

section .text
bits 64
longmode_start:
    ; we are basicly assigning everything to 0 to
    ; clear anything that is in the cpu so we can work with it
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call kernel_main

    hlt