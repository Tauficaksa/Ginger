global longmode_start

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

    mov dword [0xb8000], 0x2f4b2f4f ; OK?

    hlt