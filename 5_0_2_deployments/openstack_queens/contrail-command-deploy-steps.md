
## Steps to deploy Contrail Commander New UI with Fabric capabilities

1. Install required packages on deployer VM
```
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl start docker
```
2. Download docker image on deployer VM
```
docker login hub.juniper.net --username <USER_NAME> --password <PASSWORD>
docker pull hub.juniper.net/contrail/contrail-command-deployer:5.0.2-0.360
```
3. Copy [command_servers.yml](https://github.com/urao/contrail5_deployments/blob/master/5_0_2_deployments/command_servers.yml) 
   into $HOME/ folder
4. Add docker registry credentials and make IP address change [IP address on which contrail command will be installed]as per your topology
5. Execute the below commands from deployer VM, to start just the container
```
docker run -t --net host -v $HOME/command_servers.yml:/command_servers.yml -d --privileged --name contrail_command_deployer hub.juniper.net/contrail/contrail-command-deployer:5.0.2-0.360
```
6. Verify contrail_command and contrail_mysql containers are deployed, using command 
```
docker ps -a
```
7. Execute the below commands from deployer VM, to start just the container and import the contrail cluster deployed
```
docker run -t --net host -e orchestrator=openstack -e action=import_cluster -v /root/command_servers.yml:/command_servers.yml -v /root/contrail-ansible-deployer/config/instances.yaml:/instances.yml -d --privileged --name contrail_command_deployer hub.juniper.net/contrail/contrail-command-deployer:5.0.2-0.360
```
8. Login to Contrail Command UI
```
https://<IP_address>:9091
```
