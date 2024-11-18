global _start
extern longmode_start

section .text
bits 32
_start:
    mov esp, stack_top

    ; system checks before swtiching to long 64 bit mode
    call check_multiboot
    call check_cpuid
    call check_longmode

    call setup_page_tables
    call enable_paging

    lgdt [gdt64.pointer]
    jmp gdt64.code_segment:longmode_start

    hlt


check_multiboot:
    cmp eax, 0x36d76289
    jne .no_multiboot
    ret
.no_multiboot:
    mov al, 'M'
    jmp show_error

check_cpuid:
    ; SOME CRAZY ID FLIP BIT OPERATIONS
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 1 << 21
    push eax
    popfd
    pushfd
    pop eax
    push ecx
    popfd
    cmp eax, ecx
    je .no_cpuid
    ret
    ; IDK WTF is going on, but all i know is:
    ; we take the flags but to flip it
    ; after we flip it we check if it was succefully flipped
    ; if it is then the cpuid exists
    ; and we set everythign back to what it was because
    ; we dont wanna change anything
.no_cpuid:
    mov al, 'C'
    jmp show_error

check_longmode:
    mov eax, 0x80000000
    cpuid ; we give the cpuid this magic number
    ; if the eax reg doesn have the a value > magic number
    ; then it doesnt have longmode support
    cmp eax, 0x80000001
    jb .no_longmode

    ; now we need to check the lm bit
    mov eax, 0x80000001
    cpuid ; will store the lm bit in the edx reg
    test edx, 1 << 29
    jz .no_longmode

    ret

.no_longmode:
    mov al, "L"
    jmp show_error


setup_page_tables:
    ; we will be making virtual addrs to phy addrs
    ; it is called identity maping
    mov eax, page_table_l3
    ; the first 12 bits are always 0
    ; we use them for flags
    or eax, 0b11 ; present, writable (flags)
    mov [page_table_l4], eax

    mov eax, page_table_l2
    or eax, 0b11 ; present, writable (flags)
    mov [page_table_l3], eax

    ; in the page 2 we can enable the huge page flag which will also
    ; make it point to the phy memory itself
    ; meaning, 2M of page will be alloced

    ; if you know about a page's structure, you know that
    ; the first 9 bits will point to the next page
    ; instead for page2 we will point to the huge page

    mov ecx, 0 ; this is basicly the iterator
.loop:
    mov eax, 0x200000 ; 2M
    mul ecx ; eax * ecx = next page addr
    ; present, writable, huge_page (flags)
    or eax, 0b10000011 ; enabling the huge page flag with others
    ; putting in the page2's identity maping
    ; a bit different form the others because we are making the huge page
    mov [page_table_l2 + ecx * 8], eax

    ; we will fill up all 512 entries of the page2
    ; 512 * 2M/page = 1G
    inc ecx
    cmp ecx, 512
    jne .loop

    ret

enable_paging:
    ; passing the addr of the pages to the cpu
    ; it looks it in the cr3 reg
    mov eax, page_table_l4
    mov cr3, eax

    ; now we need the Phy Addr Ext (PAE)
    ; it is nessesory for 64bit paging
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; enabling longmode
    ; we will access the model spesific regs
    ; and from those we will set the flag to enable longmode
    mov ecx, 0xc0000080
    rdmsr
    or eax, 1 << 8 ; enabled longmode
    wrmsr

    ; now enable paging... FINALLY
    mov eax, cr0
    or eax, 1 << 31 ; enabled paging
    mov cr0, eax

    ret


show_error:
    ; print "ERR: X" where X is the error code
    mov dword [0xb8000], 0x4f524f45 ; E
    mov dword [0xb8004], 0x4f3a4f52 ; R
    mov dword [0xb8008], 0x4f204f20 ; R
    mov byte  [0xb800a], al ; the last char is our error code
    hlt

section .bss
; making our pages
align 4096
page_table_l4:
    resb 4096
page_table_l3:
    resb 4096
page_table_l2:
    resb 4096

stack_bottom:
    resb 4096 * 4
stack_top:


; here we need to create the global descripter table
section .rodata
gdt64:
    dq 0 ; 0 entry?
.code_segment: equ $ - gdt64
    ; code segment
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)
.pointer:
    dw $ - gdt64 - 1
    dq gdt64