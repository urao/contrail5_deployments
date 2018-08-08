#!/bin/bash

echo "Install packages"
sudo yum install -y gcc python-devel
sudo pip install python-openstackclient
sudo yum install openstack-utils
 
echo "source openrc.sh file"
source /etc/kolla/kolla-toolbox/admin-openrc.sh

openstack token issue
curl -X GET -H "X-Auth-Token:$(openstack token issue | awk '/ id / {print $4}')" \
      http://<Controller_IP>:8081/analytics/uves/vrouters | python -mjson.tool
