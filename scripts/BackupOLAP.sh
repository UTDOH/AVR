#!/bin/sh

# sudo -i -u postgres pg_dump -i -w -F c -b -v -f /var/local/pentaho/pentaho-solutions/system/extcontent/web/avr2.backup trisano_olap_dev > /var/log/pentaho/avr_backup.log 2>&1
sudo -i -u postgres pg_dump -i -w -F c -b -v -f /var/local/pentaho/pentaho-solutions/system/extcontent/web/avr2.backup trisano_olap
