#!/bin/bash
# Basic bash script to collect common files and outputs JTAC requests for opening contrail issues.

# Debug commands
#set -x

# Variables
work_directory=/tmp/jtac_rsi

# Array of contrail containers
containers=(
    vrouter_vrouter-agent_1
    vrouter_nodemgr_1
)

logs_local=(
    /var/log/contrail
)

configs_local=(
    /etc/contrail
)

# This directory will be copied from containers as well as host filesystem
crashes=(
    /var/crashes
)

# Array of commands to collect CLI output for troubleshooting
commands=(
    "uptime"
    "cat /etc/redhat-release"
    "uname -a"
    "free -mh"
    "df -h"
    "cat /proc/cpuinfo"
    "ifconfig"
    "iptables -L"
    "contrail-status"
    "docker ps|grep contrail"
    "ls -alh /var/crashes"
    "ulimit -a"
    "netstat -pantu"
    "lsmod | grep vr"
    "docker exec vrouter_vrouter-agent_1 vrouter --info"
    "docker exec vrouter_vrouter-agent_1 vif --list"
    "docker exec vrouter_vrouter-agent_1 flow -l"
    "docker exec vrouter_vrouter-agent_1 dropstats"
    "docker exec vrouter_vrouter-agent_1 mpls --dump"
    "docker exec vrouter_vrouter-agent_1 nh --list"
)

# Additional commands to run with -x option
extra_commands=(
    "lscpu"
    "lsof"
    "ntpq -p"
    "curl -s http://localhost:8085/Snh_AgentXmppConnectionStatusReq?"
)

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Usage: $(basename $0) [-h] [-x]"
    echo "       -h: this help message"
    echo "       -x: collect extra info (hw info, contrail sandesh info, etc.)"
    exit 0
fi

if [ "$1" == "-x" ]; then
    commands=("${commands[@]}" "${extra_commands[@]}")
fi

# Prep work folder to store and compress support information
printf "Creating work folder at $work_directory..."
mkdir $work_directory
printf "Done! \n"

# Create log for CLI outputs
printf "Creating cli output file at $work_directory/cli_output.log..."
touch $work_directory/cli_output.log
printf "Done! \n"

# Commonly run server CLI command outputs
for cli in "${commands[@]}"; do
    printf "Gathering output from '$cli'..."
    echo "# $cli" >> $work_directory/cli_output.log
    eval $cli >> $work_directory/cli_output.log
    echo -e "\n\n########################################\\n########################################\\n\n" >> $work_directory/cli_output.log
    printf "Done! \n"
done

# Gather docker logs
for container in "${containers[@]}"; do
    printf "Gathering docker logs for container $container..."
    mkdir -p $work_directory/$container/logs
    docker logs $container &> $work_directory/$container/logs/${container}.log
    printf "Done! \n"
done
# Gather host filesystem logs
for directory in "${logs_local[@]}"; do
    printf "Gathering host filesystem logs at $directory..."
    mkdir -p $work_directory/$directory
    cp -Lrf $directory $work_directory/$directory
    printf "Done! \n"
done

# Configs from host filesystem
for directory in "${configs_local[@]}"; do
    printf "Copying configs from $directory..."
    mkdir -p $work_directory/$directory
    cp -Lrf $directory/* $work_directory/$directory/
    printf "Done! \n"
done

# Move all crashes to temp directory for later compressing
printf "Copying crash files from containers (if any)..."
for container in "${containers[@]}"; do
    for directory in "${crashes[@]}"; do
        # If directory exists and is not empty
        if docker exec $container find $directory -mindepth 1 2> /dev/null | read; then
            ## Skip iteration if directory does not exist or is empty
            mkdir -p $work_directory/$container/$directory
            docker cp $container:$directory $work_directory/$container/$(dirname $directory)
        fi
    done
done
printf "Done! \n"
for directory in "${crashes[@]}"; do
    printf "Copying crash files files from host filesystem $directory..."
    if [ -z "$(ls -A $directory)" ]; then
        printf "Empty Directory! \n"
    else
        mkdir -p $work_directory/$directory
        mv -f $directory/* $work_directory/$directory
        printf "Done! \n"
    fi
done

# Compress RSI folder
# DO NOT use bzip2 (-j option to tar); it will kill Chemtrails. See RCE-2145
printf "Compressing all collected data and saving to /tmp/$(date +%Y%m%d)-$HOSTNAME-RSI.tar.gz..."
cd $work_directory && tar -czf /tmp/$(date +%Y%m%d)-$HOSTNAME-RSI.tar.gz . &>/dev/null
printf "Done! \n"

# Cleanup mess
rm -rf $work_directory
