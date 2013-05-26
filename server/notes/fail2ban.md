
Fail2Ban
======================================================================

Logging
----------------------------------------------------------------------

Set log target to syslog in /etc/fail2ban/fail2ban.conf:

    logtarget = SYSLOG

Handling Non-standard Log Locations
----------------------------------------------------------------------

Since rsyslog is configured to separate msgs by process name, need to
tell fail2ban where to look.  Fortunately, it understand file glob
patterns.  To avoid merge issues on upgrades to fail2ban, define
settings in /etc/fail2ban/jail.local.

    [ssh]
    enabled  = true
    port     = ssh
    filter   = sshd
    logpath  = /var/log/sshd.*
    maxretry = 6
