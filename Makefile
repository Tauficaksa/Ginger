# Define directories
SRC_DIR := src
BOOTLOADER_DIR := $(SRC_DIR)/bootloader
KERNEL_DIR := $(SRC_DIR)/kernel
OBJ_DIR := objs
ISO_DIR := _isodir
BOOT_DIR := $(ISO_DIR)/boot
GRUB_DIR := $(BOOT_DIR)/grub

# Define the kernel binary name
KERNEL_BIN := $(BOOT_DIR)/kernel.bin

# Compiler and flags
CC := gcc
AS := nasm
LD := ld
CFLAGS := -ffreestanding -O2 -Wall -Wextra
LDFLAGS := -T linker.ld -O2
ASFLAGS := -felf64

# File extensions
ASM := .asm
C := .c
OBJ := .o

# Define sources and objects
KERNEL_C_SRC := $(wildcard $(KERNEL_DIR)/*.c)
KERNEL_ASM_SRC := $(wildcard $(KERNEL_DIR)/*.asm)
BOOTLOADER_C_SRC := $(wildcard $(BOOTLOADER_DIR)/*.c)
BOOTLOADER_ASM_SRC := $(wildcard $(BOOTLOADER_DIR)/*.asm)

KERNEL_OBJ := $(patsubst $(KERNEL_DIR)/%,$(OBJ_DIR)/%,$(KERNEL_C_SRC:.c=$(OBJ))) $(patsubst $(KERNEL_DIR)/%,$(OBJ_DIR)/%,$(KERNEL_ASM_SRC:.asm=$(OBJ)))
BOOTLOADER_OBJ := $(patsubst $(BOOTLOADER_DIR)/%,$(OBJ_DIR)/%,$(BOOTLOADER_C_SRC:.c=$(OBJ))) $(patsubst $(BOOTLOADER_DIR)/%,$(OBJ_DIR)/%,$(BOOTLOADER_ASM_SRC:.asm=$(OBJ)))

OBJ_FILES := $(KERNEL_OBJ) $(BOOTLOADER_OBJ)

# Build the kernel binary
all: prepare $(KERNEL_BIN)

# Rule to link the kernel binary
$(KERNEL_BIN): $(OBJ_FILES)
	$(LD) -o $@ $(OBJ_FILES) $(LDFLAGS)

# C file compilation rule
$(OBJ_DIR)/%.o: $(KERNEL_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(BOOTLOADER_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Assembly file compilation rule
$(OBJ_DIR)/%.o: $(KERNEL_DIR)/%.asm | $(OBJ_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(OBJ_DIR)/%.o: $(BOOTLOADER_DIR)/%.asm | $(OBJ_DIR)
	$(AS) $(ASFLAGS) $< -o $@

# Copy grub.cfg to the appropriate directory
$(GRUB_DIR)/grub.cfg: $(BOOTLOADER_DIR)/grub.cfg | $(GRUB_DIR)
	cp $< $@

# Create the necessary directories
$(GRUB_DIR):
	mkdir -p $(GRUB_DIR)

# Clean rule
clean:
	rm -rf $(OBJ_DIR)/* $(ISO_DIR)/* ginger.iso

# Create the ISO directory structure
$(ISO_DIR)/boot:
	mkdir -p $(ISO_DIR)/boot

# Create objects directory if it doesn't exist
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Run the build process and create necessary directories
prepare: $(OBJ_DIR) $(ISO_DIR)/boot $(GRUB_DIR)/grub.cfg

# Rule to build and run the ISO
run: all
	grub-mkrescue -o ginger.iso $(ISO_DIR)
	qemu-system-x86_64 -cdrom ginger.iso

.PHONY: clean prepare run
