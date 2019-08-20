## Steps to deploy Contrail 5.1 on single server or VM

1. Bring up 1 Centos 7.6 (1810) Servers or Virtual Machines with recommended specifications 
   for Contrail deployments, 1 contrail Controller+Compute 
2. Install required packages on server or VM
```
yum install -y epel-release
yum install -y git python-pip net-tools sshpass
pip install ansible==2.5.2.0
pip install requests
```
3. Download  [Contrail 5.1 GA code](https://www.juniper.net/support/downloads/?p=contrail#sw),
```
tar -zxvf contrail-ansible-deployer-5.1.0-0.38.tgz
cd contrail-ansible-deployer
```
4. Copy [instances.yaml](https://github.com/urao/contrail5_deployments/blob/master/5_1_deployments/contrail_networking/instances.yaml) 
   into $HOME/contrail-ansible-deployer/config/ folder
5. Add docker registry credentials and make IP address changes as per your topology
6. Execute the below commands from deployer VM.
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ -e orchestrator=none playbooks/configure_instances.yml
```
7. Deploy Contrail 
```
ansible-playbook -i inventory/ -e orchestrator=none playbooks/install_contrail.yml
```

## References
[Contrail_Install](https://www.juniper.net/documentation/en_US/contrail5.1/topics/concept/install-contrail-ocata-kolla-50.html)
