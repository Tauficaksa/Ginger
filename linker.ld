ENTRY(kernel_main)

SECTIONS
{
    . = 1M;     /* we are starting after 1M. why? idk */

    .boot :
    {
        KEEP(*(.multiboot_header))
    }

    .text :
    {
        *(.text)
    }
}
