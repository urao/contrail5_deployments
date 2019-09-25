#!/bin/bash

set -ex

sudo yum install -y epel-release
sudo yum install -y git python-pip net-tools sshpass
sudo pip install ansible==2.5.2.0
sudo pip install requests
