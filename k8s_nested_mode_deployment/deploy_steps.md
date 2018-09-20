## Steps to deploy k8s in nested-mode 
## These steps are verified with docker version 1.11.2 and k8s version 1.11.3

# Prerequisites:
1. Running cluster with Contrail 5.0 with Kolla Openstack (Ocata) GA build. 
   Refer[Deployment_steps]() if needed to create one.

# Steps:
1. Create 2 VMs running Ubuntu 16.04.1 xenial, one master and one slave node
2. Either using FloatingIP pool/SNAT feature, make sure these VMs has
   internet connectivity to deploy kubernetes cluster
3. Deploy k8s on master and node
4. Refer to [script]() to run on the master node
5. Refer to [script]() to run on the slave node
6. Check k8s cluster to be in Ready state
```
root@vm4:~# kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
vm3       Ready     <none>    1d        v1.11.3
vm4       Ready     master    1d        v1.11.3
```
7. Either using gatewayless feature or configuring [linklocal address](), make 
   sure these VMs can reach Contrail Config and vRouter nodes
8. Here I used gatewayless feature for connectivity to Contrail nodes
9. Clone contrail-container-build repo on master node
```
git clone https://github.com/Juniper/contrail-container-builder.git
```
10. Copy [common.env file]() in the top directory of the cloned contrail-container-builder repo and
    modify the IP address as per your configuration
11. Create kubernetes secret object which contains username,password of the docker registry
```
kubectl create secret docker-registry usecret --docker-server=hub.juniper.net/contrail --docker-username=<USER_NAME> \
        --docker-password=<PASSWORD> --docker-email=<USER_EMAIL> -n kube-system
```
12. Install Contrail CNI
```
cd contrail-container-builder
cd contrail-container-builder/kubernetes/manifests
./resolve-manifest.sh contrail-kubernetes-nested.yaml  > nested-contrail.yml
kubectl create -f nested-contrail.yml
```
13. Verify Contrail pods are RUNNING
```
kubectl get pods -n kube-system 
NAME                                  READY     STATUS    RESTARTS   AGE
contrail-kube-manager-f2hr8           1/1       Running   0          52s
contrail-kubernetes-cni-agent-k6f2p   1/1       Running   0          52s
coredns-78fcdf6894-6kpmn              1/1       Running   0          23h
coredns-78fcdf6894-9pbkw              1/1       Running   0          23h
etcd-vm4                              1/1       Running   0          23h
kube-apiserver-vm4                    1/1       Running   0          23h
kube-controller-manager-vm4           1/1       Running   0          23h
kube-proxy-5ps5v                      1/1       Running   0          23h
kube-proxy-dgczw                      1/1       Running   0          23h
kube-scheduler-vm4                    1/1       Running   0          23h
```
