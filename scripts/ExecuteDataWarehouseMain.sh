#!/bin/sh

cd /var/local/pdi/

./kitchen.sh -file /var/local/project/AVR/pentaho/datawarehouse/etl/load_data_warehouse_main.kjb > /var/log/pdi/load_data_warehouse_main_$(date + "%Y%m%d%H%M%S").log 2>&1
