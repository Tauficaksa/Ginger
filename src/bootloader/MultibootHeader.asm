section .multiboot_header
header_start:
    ; Magic number for Multiboot2 (this is the value GRUB looks for)
    dd 0xe85250d6           ; Magic number for Multiboot2 (0xE85250D6)
    
    ; Architecture (0 means i386 architecture, including i686)
    dd 0                    ; 0 for i386 architecture (also applies to i686 in protected mode)

    ; Header length (calculated by subtracting the start address from the end address)
    dd header_end - header_start

    ; Checksum (used to ensure the header is valid)
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

    ; End tag with some more magic (GRUB expects this to indicate the end of the header)
    dw 0                    ; End of the header (must be a 0)
    dw 0                    ; Padding (set to 0)
    dd 8                    ; Tag type (indicates this is the end of the header section)
header_end:
