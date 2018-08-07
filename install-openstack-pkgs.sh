#!/bin/bash

echo "Install packages"
yum install -y gcc python-devel
pip install python-openstackclient
 
echo "source openrc.sh file"
source /etc/kolla/kolla-toolbox/admin-openrc.sh

openstack-status
