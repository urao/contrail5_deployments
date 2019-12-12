#!/bin/bash

#
docker exec -i contrail_config_api python /usr/lib/python2.7/site-packages/cfgm_common/db_json_exim.py --export-to db-backup.json
