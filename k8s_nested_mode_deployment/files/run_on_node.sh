#!/usr/bin/env bash
# Tested with Ubuntu 16.04.1
set -e

TOKEN="3shpak.6mbxdp4rhkjv57w0"
GOOGLE_IP="8.8.8.8"

# check internet connectivity
function check_internet_connectivity ()
{
   if ping -q -c 1 -W 1 $GOOGLE_IP > /dev/null; then
      echo "Internet is reachable"
   else
      echo "Internet is not reachable..please check..EXITING.."
      exit 1
   fi
}

# check if root user is running this script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

function deploy_on_ubuntu ()
{
   echo "Deploying k8s on Ubuntu...."
   apt-get update -y 
   echo "$1     $2  \n" >> /etc/hosts
   echo "$3     $4  \n" >> /etc/hosts

   swapoff -a
   apt-get install apt-transport-https ca-certificates curl software-properties-common -y
   curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
   echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
   apt-get update -y
   apt-get install -y kubectl kubelet kubeadm docker-engine
   ufw disable
   sysctl -w net.bridge.bridge-nf-call-iptables=1
   kubeadm join --token $TOKEN --skip-preflight-checks $1:6443 --discovery-toke-unsafe-skip-ca-verification
}

echo "User, please provide the master and node information details:"
read -p "Master node IP address: " masterIP
read -p "Master node Hostname: " mHostname
read -p "Slave node IP address: " slaveIP
read -p "Slave node Hostname: " sHostname
check_internet_connectivity
deploy_on_ubuntu $masterIP $mHostname $slaveIP $sHostname
exit 0
