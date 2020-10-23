# For release contrail 5 and above
#!/bin/bash

#
docker exec -it contrail_config_api /bin/bash 
python /usr/lib/python2.7/site-packages/cfgm_common/db_json_exim.py --export-to /root/db-backup.json \
       --conf /etc/contrail/contrail-api.conf
### Check 
# https://github.com/urao/tungsten-fabric/blob/master/db_backup_new_container.md
