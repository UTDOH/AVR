#!/bin/sh

cd /var/local/pdi/

./kitchen.sh -file /var/local/project/AVR/pentaho/datawarehouse/etl/Fixup/FixupMain.kjb > /var/log/pdi/FixupMain_$(date +"%Y%m%d%H%M%S").log 2>&1
