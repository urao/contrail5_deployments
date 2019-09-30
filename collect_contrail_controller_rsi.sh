#
# Tested on all-in-one contrail cluster running contrail 5.x on centos 7.6
# Collect all the required contrail logs to sent to dev or jtac
#!/usr/bin/env bash
set -ex

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# variables
log_locations=(/var/log/contrail)
config_locations=(/etc/contrail)
cmd_outputs=("/etc/redhat-release" "uname -a" "contrail-status" "nodetool status" "contrail-version" "df -h" "free -mh")

# create tmp folder to store output file
log_folder='/tmp/contrail_logs'
mkdir -p $log_folder

# collect logs
for dir in "${log_locations[@]}"
do
   echo "Copying logs from $dir"
   specific_log=$log_folder/$dir
   mkdir -p $specific_log
   cp -Lrf $dir $specific_log
done

cd
hostname=$(hostname | cut -d . -f 1)
time=$(date "+%Y-%m-%d")
TAR_FILE=$hostname-$time-RSI.tar.gz
tar -zcf $TAR_FILE $log_folder 
echo "Contrail Controller RSI tar file $TAR_FILE is created !!!!!"
