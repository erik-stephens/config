
Prevent dhclient from updating /etc/resolv.conf
======================================================================

There are multiple ways to prevent dhclient from overriding
/etc/resolv.conf with the settings published by the dhcp server.
Option 3 is the recommended approach.

1. The simplest but most crude method is to make /etc/resolv.conf
read-only so nothing can modify it.  Removing the write bit will not
suffice.  The filesystem requires Access Control List (ACL) support.

  # Remove immutability attribute
  chattr -i /etc/resolv.conf
  # Edit /etc/resolv.conf to your liking
  $EDITOR /etc/resolv.conf
  # Add immutability attribute
  chattr +i /etc/resolv.conf

2. Make dhclient do nothing for the make_resolv_conf phase by defining
an enter hook.  Create /etc/dhcp/dhclient-enter-hooks.d/nodnsupdate
with execute bit set.  NOTE: the colon is needed since there are no
commands to execute.

    #!/bin/sh
    function make_resolv_conf {
	    :
    }

3. Configure dhclient to use your dns setting instead of the setting
published by the server.  Consult the dhcp-options manual page for
list of options that can be overridden.  Available operations are:
default, prepend, append, supersede.

    prepend domain-name-servers ns.my.domain.com;
    prepend domain-search "my.domain.com", "domain.com";
