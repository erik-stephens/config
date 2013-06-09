
Monitoring Physical Disks
======================================================================

Install smartmontools and activate smartd

Set the temperature logging interval to 1 minute and preserve (p) this
setting across boots:
 
    # smartctl -t scttempint,1,p /dev/sda
    # smartctl -t scttempint,1,p /dev/sdb
