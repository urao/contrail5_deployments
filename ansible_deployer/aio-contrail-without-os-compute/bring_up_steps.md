
## Steps to deploy all-in-one Contrail Without Kolla Ocata OpenStack and Compute

1. Bring up a Centos 7.4 VM with 4 vCPU, 32 GB of RAM and 510 GB of disk with default partition
2. VM will have 1 NIC, eth0 configured with static IP/DHCP.
3. Make sure internet is accessible via interface eth0
4. Install required packages
```
yum install -y epel-release
yum install -y epel-release
yum install -y git python-pip net-tools sshpass
pip install ansible==2.4.2.0
```
5. Clone contrail-ansible-deployer
```
cd
git clone http://github.com/Juniper/contrail-ansible-deployer
cd contrail-ansible-deployer
```
6. Copy [instances.yaml](https://github.com/urao/contrail5_deployments/blob/master/ansible_deployer/aio-contrail-without-os-compute/instances.yaml) into config/ folder
7. Modify ssh_pwd, ip, ntpserver, CONTROL_DATA_NET_LIST, CONTROLLER_NODES in the instances.yaml file copied from the previous step
8. Install Contrail requirements
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ playbooks/configure_instances.yml 
```
9. Verify if the requirements  was successful.
```
192.168.122.84            : ok=31   changed=22   unreachable=0    failed=0   
localhost                  : ok=10   changed=2    unreachable=0    failed=0   
```
10. Deploy Contrail containers
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ -e orchestrator=none playbooks/install_contrail.yml
```
11. Verify if the deployment  was successful.
```
192.168.122.84             : ok=86   changed=39   unreachable=0    failed=0
localhost                  : ok=2    changed=1    unreachable=0    failed=0
```
12. Verify if 56 containers are UP and running
```
# docker ps | awk '{print $1}' | wc -l
27
```
```
#contrail-status
Pod        Service         Original Name                          State    Status
analytics  alarm-gen       contrail-analytics-alarm-gen           running  Up 17 minutes
analytics  api             contrail-analytics-api                 running  Up 17 minutes
analytics  collector       contrail-analytics-collector           running  Up 17 minutes
analytics  nodemgr         contrail-nodemgr                       running  Up 17 minutes
analytics  query-engine    contrail-analytics-query-engine        running  Up 17 minutes
analytics  snmp-collector  contrail-analytics-snmp-collector      running  Up 17 minutes
analytics  topology        contrail-analytics-topology            running  Up 17 minutes
config     api             contrail-controller-config-api         running  Up 20 minutes
config     cassandra       contrail-external-cassandra            running  Up 22 minutes
config     device-manager  contrail-controller-config-devicemgr   running  Up 20 minutes
config     nodemgr         contrail-nodemgr                       running  Up 20 minutes
config     rabbitmq        contrail-external-rabbitmq             running  Up 22 minutes
config     schema          contrail-controller-config-schema      running  Up 20 minutes
config     svc-monitor     contrail-controller-config-svcmonitor  running  Up 20 minutes
config     zookeeper       contrail-external-zookeeper            running  Up 22 minutes
control    control         contrail-controller-control-control    running  Up 19 minutes
control    dns             contrail-controller-control-dns        running  Up 19 minutes
control    named           contrail-controller-control-named      running  Up 19 minutes
control    nodemgr         contrail-nodemgr                       running  Up 19 minutes
database   cassandra       contrail-external-cassandra            running  Up 18 minutes
database   kafka           contrail-external-kafka                running  Up 18 minutes
database   nodemgr         contrail-nodemgr                       running  Up 18 minutes
database   zookeeper       contrail-external-zookeeper            running  Up 18 minutes
webui      job             contrail-controller-webui-job          running  Up 19 minutes
webui      web             contrail-controller-webui-web          running  Up 19 minutes

== Contrail control ==
control: active
nodemgr: active
named: active
dns: active

== Contrail analytics ==
snmp-collector: active
query-engine: active
api: active
alarm-gen: active
nodemgr: active
collector: active
topology: active

== Contrail config ==
api: active
zookeeper: active
svc-monitor: active
nodemgr: active
device-manager: active
cassandra: active
rabbitmq: active
schema: active

== Contrail webui ==
web: active
job: active

== Contrail database ==
kafka: active
nodemgr: active
zookeeper: active
cassandra: active
```
## Access to Contrail UI console

1. Browse to the IP http://<VM_IP_ADDRESS>:8143 and login with the user "admin" and the password "contrail123"

## Reference
[Contrail Wiki Link](https://github.com/Juniper/contrail-ansible-deployer/wiki/Contrail-with-Kolla-Ocata)
