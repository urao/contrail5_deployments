## Steps to deploy Contrail [1909] nightly build on single server or VM

1. Bring up 1 Centos 7.6 (1810) Servers or Virtual Machines with recommended specifications 
   for Contrail deployments, 1 contrail Controller+Compute 
2. Get the nightly build #, using
```
curl -uXX:XX https://hub.juniper.net/v2/contrail-nightly/contrail-base/tags/list | jq . | grep 1909
```
3. Install required packages on server or VM
```
yum install -y epel-release
yum install -y git python-pip net-tools sshpass
pip install ansible==2.5.2.0
pip install requests
```
4. Git clone the repo
```
git clone --branch R1909 http://github.com/Juniper/contrail-ansible-deployer
cd contrail-ansible-deployer
```
5. Copy [instances.yaml](https://github.com/urao/contrail5_deployments/blob/master/nightly_deployments/instances.yaml) 
   into $HOME/contrail-ansible-deployer/config/ folder
6. Add docker registry credentials and make IP address changes as per your topology
7. Execute the below commands from deployer VM.
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ -e orchestrator=none playbooks/configure_instances.yml
```
8. Deploy Contrail 
```
ansible-playbook -i inventory/ -e orchestrator=none playbooks/install_contrail.yml
```

## References
[Contrail Install](https://www.juniper.net/documentation/en_US/contrail5.1/topics/concept/install-contrail-ocata-kolla-50.html)
