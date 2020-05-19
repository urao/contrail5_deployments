#!/bin/bash

# This script will run as cron job to collect CPU,Memory 
# and other details on compute node 
# How to run this script as cron job, every 2 minutes
# */2 * * * * bash <script_location>

#set -o pipefail -e

# Run as root user
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

export LOGFILE=/var/log/contrail/collect_cpu_mem_metrics.log
exec > >(sudo tee -a $LOGFILE)
exec 2>&1

log() {
   echo "$(date +"%F:%H:%M:%S")> $1"
   echo "=========================="
}

#main
echo
echo "===========  start ============"

log "Print memory"
free -m
echo

log "Print top CPU and Memory usage process"
ps -ewo user,pid,ppid,cmd,%mem,%cpu --sort=-%mem | head
echo

log "Print contrail-vrouter-agent process info"
GET_PID=$(pgrep -f ^/usr/bin/contrail-vrouter-agent)
top -p $GET_PID -b -n 1
echo

log "Print vmstat info"
vmstat -a
echo

log "Print vrouter info to collect flow entries etc"
docker exec vrouter_vrouter-agent_1 vrouter --info
echo

echo "===========  stop ============"
echo
