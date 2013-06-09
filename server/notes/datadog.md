
Configuring DataDog for Custom Metrics & Event Reporting
======================================================================

Install datadog specific statsd client to easily publish custom
metrics & alerts.  Optionally, sic datadog on log streams and optional
custom parsers:

    curl 'http://dtdg.co/agent-install-debian' > /tmp/install-datadog
    less /tmp/install-datadog
    DD_API_KEY=... bash /tmp/install-datadog
    cd /usr/share/datadog
    echo '' > __init__.py
    curl 'https://raw.github.com/DataDog/dogstatsd-python/master/statsd.py' > statsd.py
    ln -s /usr/share/datadog /usr/share/pyshared/datadog
    for i in /usr/lib/python2.[67]; do ln -s /usr/share/pyshared/datadog $i/dist-packages/datadog; done

