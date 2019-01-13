#!/bin/bash

help() 
{
	echo "How to run the script.."
	echo "$0 <username> <password> <poolId>"
	echo "   For example"
	echo "   $0 test@test.com password! 12342343243242424234"
}

if [ "$#" -ne 3 ]; then
	echo "Correct number of arguments are not passed!!"
	help
	exit 1
fi

install_pkgs() {
        username=$1
	password=$2
	poolId=$3
        echo "Install required packages for contrail+openshift 3.9 deployment"
        subscription-manager register --username $username --password $password
        subscription-manager list --available --matches '*OpenShift*'
        subscription-manager attach --pool=$poolId
        subscription-manager repos --disable="*"
        subscription-manager repos  --enable="rhel-7-server-rpms"  --enable="rhel-7-server-extras-rpms"  --enable="rhel-7-server-ose-3.9-rpms"     --enable="rhel-7-fast-datapath-rpms"   --enable="rhel-7-server-ansible-2.5-rpms"
        yum install wget -y && wget -O /tmp/epel-release-latest-7.noarch.rpm https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rpm -ivh /tmp/epel-release-latest-7.noarch.rpm
        yum update -y
	yum install atomic-openshift-excluder atomic-openshift-utils git python-netaddr -y
	atomic-openshift-excluder unexclude -y
        yum install -y python-pip
        pip install ansible==2.5.2
        yum install net-tools -y
}

install_pkgs "$@"
exit 0
