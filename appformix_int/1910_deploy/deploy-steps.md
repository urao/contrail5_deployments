
## Steps to deploy Contrail Version 1910.23 + Appformix 

1. Bring up 1 Centos 7.4 Servers with recommended [specifications](https://www.juniper.net/documentation/en_US/contrail19/information-products/topic-collections/release-notes/topic-144688.html#jd0e139) for Contrail deployments
2. Install required packages
```
yum install -y epel-release
yum install -y git python-pip net-tools sshpass
pip install ansible==2.7.10
systemctl stop firewalld; systemctl disable firewalld
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-18.03.1.ce
systemctl start docker
docker login hub.juniper.net/contrail
docker pull hub.juniper.net/contrail/contrail-command-deployer:1910.23
```
3. Copy [instances.yaml](https://github.com/urao/contrail5_deployments/blob/master/5_0_1_deployments/ansible_deployer/dpdk/instances.yaml) 
   into $HOME folder
4. Copy [instances.yaml](https://github.com/urao/contrail5_deployments/blob/master/5_0_1_deployments/ansible_deployer/dpdk/instances.yaml) 
   into $HOME folder
5. Modify above both yaml files with docker registry credentials and make IP address changes as per your topology
6. Copy Appformix [version 3.1.6](https://support.juniper.net/support/downloads/) packages into /opt/software/appformix folder
7. Deploy 
```
docker run -td --net host -e orchestrator=openstack -e action=provision_cluster -v $HOME/command_servers.yml:/command_servers.yml -v $HOME/instances.yaml:/instances.yml --privileged --name contrail_command_deployer hub.juniper.net/contrail//contrail-command-deployer:1910.23
```
8. Check deployment logs
```
tail -f /var/log/contrail/deploy.log
```
