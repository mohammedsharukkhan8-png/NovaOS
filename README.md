# NovaOS

**NovaOS** is a mini project focused on developing a simple, bootable 32-bit operating system kernel from scratch. It starts up through the GRUB bootloader and prints **"Welcome to NovaOS!"** on the screen.

NovaOS is a **learning project**. It is built to show clearly what happens from power-on until the kernel runs. It is not a replacement for Windows or Linux.

---

## Features

- 32-bit x86 kernel written in **C** and **x86 Assembly (NASM)**
- Boots with **GRUB** using the **Multiboot** specification
- Prints text directly to **VGA text-mode memory** (`0xB8000`)
- Custom **linker script** that loads the kernel at 1 MB
- **Makefile** that builds the kernel and a bootable ISO image
- Runs in the **QEMU** emulator

## Project Structure

```
NovaOS/
├── boot/
│   └── boot.s        # Multiboot header, stack setup, jump to kernel_main
├── src/
│   └── kernel.c      # Kernel entry point, prints to VGA text buffer
├── linker.ld         # Decides where each section sits in memory
├── grub.cfg          # GRUB menu entry for NovaOS
├── Makefile          # Build, check, run and clean targets
└── .gitignore
```

## How NovaOS Boots

1. **Power on / start QEMU** - the virtual computer starts.
2. **GRUB loads the kernel** - GRUB finds the Multiboot header and loads `novaos.bin` at 1 MB.
3. **Assembly sets up the stack** - `boot/boot.s` creates a 16 KB stack and calls `kernel_main`.
4. **C code prints on screen** - `src/kernel.c` writes characters to VGA memory at `0xB8000`.
5. **CPU halts** - the kernel stops in a `hlt` loop. Boot is finished.

## Requirements

You need a Linux environment (Ubuntu or Debian is recommended) with these tools:

| Tool | Purpose |
|------|---------|
| `i686-elf-gcc` (cross-compiler) | Compiles the kernel and links the final binary |
| `nasm` | Assembles `boot/boot.s` |
| `make` | Runs the build |
| `grub-pc-bin`, `grub-common` | Provides `grub-mkrescue` and `grub-file` |
| `xorriso`, `mtools` | Used by `grub-mkrescue` to create the ISO |
| `qemu-system-x86` | Runs the ISO in a virtual machine |

Install the common packages on Ubuntu/Debian:

```bash
sudo apt update
sudo apt install nasm make grub-pc-bin grub-common xorriso mtools qemu-system-x86
```

The `i686-elf-gcc` cross-compiler is usually not available through `apt`. Build it from source by following the [OSDev Wiki guide on GCC Cross-Compiler](https://wiki.osdev.org/GCC_Cross-Compiler), or install a prebuilt copy, and make sure it is on your `PATH`.

## Build and Run

Clone the repository:

```bash
git clone https://github.com/mohammedsharukkhan8-png/NovaOS.git
cd NovaOS
```

Build the bootable ISO (`build/novaos.iso`):

```bash
make
```

Check that the kernel is Multiboot-compliant (optional):

```bash
make check
```

Run NovaOS in QEMU:

```bash
make run
```

Remove build files:

```bash
make clean
```

You should see a QEMU window show the GRUB menu, and after boot the message **Welcome to NovaOS!** on the screen.

## Make Targets

| Target | What it does |
|--------|--------------|
| `make` / `make all` | Builds `build/novaos.iso` |
| `make check` | Verifies the kernel with `grub-file --is-x86-multiboot` |
| `make run` | Starts the ISO in `qemu-system-i386` |
| `make clean` | Deletes `build/` and `iso/boot` |

## Current Status

**Done**
- Project folders, linker script, GRUB config and Makefile
- Bootable ISO image
- Kernel prints "Welcome to NovaOS!" on screen
- Tested: builds, boots with GRUB and runs in QEMU

**Planned (future work)**
- Reusable screen-printing functions
- Keyboard input and interrupts
- Memory management
- A simple shell (command prompt)

## Scope

**In scope:** booting, printing text, and small learning modules.
**Not included:** graphical screen, networking or internet, and advanced security.

## Tech Stack

C, x86 Assembly (NASM), i686-elf GCC, GNU Make, GRUB, xorriso, QEMU, Linux

## References

1. OSDev Wiki, "Bare Bones" - https://wiki.osdev.org/Barebones
2. OSDev Wiki, "Tutorials" - https://wiki.osdev.org/Tutorials
3. GNU Project, "GCC Online Documentation" - https://gcc.gnu.org/onlinedocs/
4. Free Software Foundation, "The Multiboot Specification, version 0.6.96" - https://www.gnu.org/software/grub/manual/multiboot/multiboot.html
