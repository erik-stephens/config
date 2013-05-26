
Delivering Email
======================================================================

Settings for exim as smarthost to gandi.net
----------------------------------------------------------------------

- Either use dpkg-reconfigure exim4-config or edit
  update-exim4.conf.conf directly and run `update-exim4.conf`
  manually.  The key settings are domain (/etc/mailname) and
  smarthost.  The domain must match registered domain or mail deliver
  will be rejected.

- Use mail.gandi.net::587 as host to deliver email through.  Note the
  double colons (::).
  
- Provide credentials in /etc/exim4/passwd.client.
