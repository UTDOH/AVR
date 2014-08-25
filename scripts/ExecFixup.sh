#!/bin/sh

cd /var/local/pdi/

./kitchen.sh -file /var/local/project/AVR/pentaho/datawarehouse/etl/add_person_to_fact_event_main.kjb > /var/log/pdi/add_person_to_fact_event_main_$(date +"%Y%m%d%H%M%S").log 2>&1

./kitchen.sh -file /var/local/project/AVR/pentaho/datawarehouse/etl/add_dim_indexes_to_facts.kjb > /var/log/pdi/add_dim_indexes_to_facts_$(date +"%Y%m%d%H%M%S").log 2>&1

