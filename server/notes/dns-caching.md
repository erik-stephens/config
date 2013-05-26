
DNS Caching
======================================================================

DnsMasq Cache Settings
----------------------------------------------------------------------

The dnsmasq.conf manual page and dnsmasq.conf coments are pretty
thorough.  Below is a culled list of settings related to caching.
 
- local-ttl

    > Normally responses which come form /etc/hosts and the DHCP lease
    > file have Time-To-Live set as zero, which conventionally means
    > do not cache further. If you are happy to trade lower load on
    > the server for potentially stale date, you can set a
    > time-to-live (in seconds) here.

- cache-size

    > When replying with information from /etc/hosts or the DHCP
    > leases file dnsmasq by default sets the time-to-live field to
    > zero, meaning that the requester should not itself cache the
    > information. This is the correct thing to do in almost all
    > situations. This option allows a time-to-live (in seconds) to be
    > given for these replies.  This will reduce the load on the
    > server at the expense of clients using stale dataunder some
    > circumstances.

- no-negcache

    > Disable negative caching. Negative caching allows dnsmasq to
    > remember "no such domain" answers from upstream nameservers and
    > answer identical queries without forwarding them again.

- neg-ttl

    > Negative replies from upstream servers normally contain
    > time-to-live information in SOA records which dnsmasq uses for
    > caching. If the replies from upstream servers omit this
    > information, dnsmasq does not cache the reply. This option gives
    > a default value for time-to-live (in seconds) which dnsmasq uses
    > to cache negative replies even in the absence of an SOA record.

