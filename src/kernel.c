void kernel_main(void)
{
    volatile unsigned short *vga =
        (volatile unsigned short *)0xB8000;

    const char *message = "Welcome to NovaOS!";

    for (int i = 0; message[i] != '\0'; i++) {
        vga[i] = (unsigned short)message[i] | 0x0F00;
    }

    for (;;) {
        __asm__ volatile ("hlt");
    }
}