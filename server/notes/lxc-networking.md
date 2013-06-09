
Network Setup for LXC
======================================================================

Interfaces
----------------------------------------------------------------------

The external interface (eth1) used for public traffic.  The internal
interface (eth0) used as a bridge for the guest network.

    # WAN
    auto eth1
         iface eth1 inet static
         address 69.160.46.92
         gateway 69.160.46.65
         netmask 255.255.255.224
         broadcast 69.160.46.95

    # LXC bridge
    auto br0
        iface br0 inet static
        bridge_ports eth0
        bridge_fd 0
        bridge_maxwait 0
        address 10.2.1.2
        netmask 255.255.255.0
        network 10.2.1.0
        broadcast 10.2.1.255
