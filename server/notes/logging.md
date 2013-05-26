
Logging
======================================================================

Configuration for Hosts
----------------------------------------------------------------------

### On-Site

Each program goes to its own file, tagged with day of month, which
provides crude, automatic log rotation.  This non-standard way of
splitting the logs by program name will break how other utilities such
as fail2ban are configured by default.
 
    $template MsgFile,"/var/log/%programname%.%$DAY%.log"
    if $syslogseverity >= '6' then ?MsgFile
    & ~
    $template ErrFile,"/var/log/%programname%.%$DAY%.err"
    if $syslogseverity <= '5' then ?ErrFile
    & ~

### Off-Site

TODO

Configuration for Guests
----------------------------------------------------------------------

For security and to avoid disk space issues in the guests, just send
all log msgs to each physical host.

    *.* @log1
    *.* @log2
