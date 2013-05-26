
Boot Loading with grub
======================================================================

Serial Console
----------------------------------------------------------------------

Enable serial console in /etc/inittab:

    T0:23:respawn:/sbin/getty -L ttyS0 115200 vt100
    T1:23:respawn:/sbin/getty -L ttyS1 115200 vt100

Enable serial console in boot loader in /etc/default/grub:

    GRUB_CMDLINE_LINUX_DEFAULT=""
    GRUB_CMDLINE_LINUX="console=tty0 console=ttyS1,115200n8"
    GRUB_TERMINAL=serial
    GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
    
Apply changes above and generate grub2 config file:

    update-grub

Make sure serial ports are allowed in /etc/securetty:

    # UART serial ports
    ttyS0
    ttyS1
