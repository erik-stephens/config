Using dnsmasq to Manage Guests
======================================================================

## Goals

- Manage IP allocation of guests centrally using DHCP.

- Serve and cache DNS queries for guests.

- Do not intefere with host's ability to resolve names outside of the
  guest network.  Queries for guest names should use local dnsmasq
  resolver while queries for all other names should use host's
  original resolv.conf setting.

The dnsmasq.conf manual page and dnsmasq.conf coments are pretty
thorough.  Below is a culled list of settings used to serve DNS to
guest containers.
 
- resolv-file

    > Read the IP addresses of the upstream nameservers from <file>,
      instead of /etc/resolv.conf. For the format of this file see
      resolv.conf(5).  The only lines relevant to dnsmasq are
      nameserver ones. Dnsmasq can be told to poll more than one
      resolv.conf file, the first file name specified overrides the
      default, subsequent ones add to the list. This is only allowed
      when polling; the file with the currently latest modification
      time is the one used.
 
        # domain tfks.net
        # search tfks.net
        # search home.tfks.net
        nameserver 69.160.46.70
        nameserver 69.160.46.71
 
- no-resolv

    > Don't read /etc/resolv.conf. Get upstream servers only from the
      command line or the dnsmasq configuration file.

- server

    > Specify IP address of upstream servers directly. Setting this
      flag does not suppress reading of /etc/resolv.conf, use -R to do
      that. If one or more optional domains are given, that server is
      used only for those domains and they are queried only using the
      specified server. This is intended for private nameservers: if
      you have a nameserver on your network which deals with names of
      the form xxx.internal.thekelleys.org.uk at 192.168.1.1 then
      giving the flag -S /internal.thekelleys.org.uk/192.168.1.1 will
      send all queries for internal machines to that nameserver,
      everything else will go to the servers in /etc/resolv.conf. An
      empty domain specification, // has the special meaning of
      "unqualified names only" ie names without any dots in them. A
      non-standard port may be specified as part of the IP address
      using a # character.  More than one -S flag is allowed, with
      repeated domain or ipaddr parts as required.

        server=/*/69.160.46.70
        server=/*/69.160.46.71

- local

    > `local` is a synonym for `server` which gives a domain but no IP
      address.  This tells dnsmasq that a domain is local and it may
      answer queries from /etc/hosts or DHCP but should never forward
      queries on that domain to any upstream servers.

        local=/tfks.net/

- except-interface

    > Do not listen on the specified interface. Note that the order of
      --listen-address, --interface, and --except-interface options
      does not matter and that --except-interface options always
      override the others.

    eth0 is the private interface for the guest network.  eth1 is the
    public interface.  Only want to respond to dns queries for
    localhost & guests.

        except-interface=eth1

- addn-hosts and no-hosts

    > Additional hosts file. Read the specified file as well as
    > /etc/hosts. If `no-hosts` is set, read only the specified
    > file. This option may be repeated for more than one additional
    > hosts file. If a directory is given, then read all the files
    > contained in that directory.
    
    Don't let host's /etc/hosts conflict with the names served for guest network.

        no-hosts
        addn-hosts=/etc/dnsmasq/hosts

- expand-hosts

    > Add the domain to simple names (without a period) in /etc/hosts
    > in the same way as for DHCP-derived names. Note that this does
    > not apply to domain names in cnames, PTR records, TXT records
    > etc.

- domain

    > Specifies DNS domains for the DHCP server. Domains may be be
    > given unconditionally (without the IP range) or for limited IP
    > ranges. This has two effects; firstly it causes the DHCP server
    > to return the domain to any hosts which request it, and sec‐
    > ondly it sets the domain which it is legal for DHCP-configured
    > hosts to claim.  The intention is to constrain hostnames so that
    > an untrusted host on the LAN cannot advertise its name via dhcp
    > as e.g. "microsoft.com" and capture traffic not meant for it.
    > If no domain suffix is specified, then any DHCP hostname with a
    > domain part (ie with a period) will be disallowed and logged. If
    > suffix is specified, then hostnames with a domain part are
    > allowed, provided the domain part matches the suffix. In addi‐
    > tion, when a suffix is set then hostnames without a domain part
    > have the suffix added as an optional domain part. Eg on my
    > network I can set --domain=thekelleys.org.uk and have a machine
    > whose DHCP hostname is "laptop". The IP address for that machine
    > is available from dnsmasq both as "laptop" and
    > "laptop.thekelleys.org.uk". If the domain is given as "#" then
    > the domain is read from the first "search" directive in
    > /etc/resolv.conf (or equivalent).

        domain=phx.tfks.net,10.2.1.0/24,local

- dhcp-range

    > Enable the DHCP server. Addresses will be given out from the
    > range <start-addr> to <end-addr> and from statically defined
    > addresses given in dhcp-host options. If the lease time is
    > given, then leases will be given for that length of time.  The
    > lease time is in seconds, or minutes (eg 45m) or hours (eg 1h)
    > or "infinite". If not given, the default lease time is one
    > hour. The minimum lease time is two minutes.  For IPv6 ranges,
    > the lease time maybe "deprecated"; this sets the preferred
    > lifetime sent in a DHCP lease or router advertisement to zero,
    > which causes clients to use other addresses, if available, for
    > new connections as a prelude to renumbering.
              
        dhcp-range=10.2.1.201,10.2.1.249,24h

- dhcp-host

    > Specify per host parameters for the DHCP server. This allows a
    > machine with a partic‐ ular hardware address to be always
    > allocated the same hostname, IP address and lease time. A
    > hostname specified like this overrides any supplied by the DHCP
    > client on the machine.  It is also allowable to omit the
    > hardware address and include the hostname, in which case the IP
    > address and lease times will apply to any machine claiming that
    > name.  For example --dhcp-host=00:20:e0:3b:13:af,wap,infinite
    > tells dnsmasq to give the machine with hardware address
    > 00:20:e0:3b:13:af the name wap, and an infinite DHCP lease.
    > --dhcp-host=lap,192.168.0.199 tells dnsmasq to always allocate
    > the machine lap the IP address 192.168.0.199.

    These should match the entries in the hosts file that will be used
    to serve dns queries.  TODO: find a way to couple that with this
    to avoid having ip:name mapping defined in two places
              
        dhcp-host=name,ip,infinite
