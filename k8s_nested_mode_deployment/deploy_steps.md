# Steps to deploy k8s in nested-mode 
### These steps are verified with docker version 1.11.2 and k8s version 1.11.3

### Prerequisites:
1. Running cluster with Contrail 5.0 with Kolla Openstack (Ocata) GA build. If you do not already have a cluster, you can create one by using these [steps](https://github.com/urao/contrail5_deployments/tree/master/ansible_deployer)

### Steps:
1. Create 2 VMs running Ubuntu 16.04.1 xenial, one master and one slave node
2. Either using FloatingIP pool/SNAT feature, make sure these VMs has
   internet connectivity to deploy kubernetes cluster
3. Deploying k8s on master and node
4. Refer to [script](https://github.com/urao/contrail5_deployments/blob/master/k8s_nested_mode_deployment/files/run_on_master.sh) to run on the master node
5. Refer to [script](https://github.com/urao/contrail5_deployments/blob/master/k8s_nested_mode_deployment/files/run_on_node.sh) to run on the slave node
6. Check k8s cluster to be in Ready state
```
root@vm4:~# kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
vm3       Ready     <none>    1d        v1.11.3
vm4       Ready     master    1d        v1.11.3
```
7. Either using Gatewayless feature or configuring [linklocal address](https://github.com/Juniper/contrail-kubernetes-docs/blob/master/install/kubernetes/nested-kubernetes.md), make 
   sure these VMs can reach Contrail Config and vRouter nodes
8. Here Gatewayless feature for connectivity to Contrail nodes is used
9. Clone contrail-container-build repo on master node
```
git clone https://github.com/Juniper/contrail-container-builder.git
```
10. Create kubernetes secret object which contains username,password of the docker registry
```
kubectl create secret docker-registry usecret --docker-server=hub.juniper.net/contrail --docker-username=<USER_NAME> \
        --docker-password=<PASSWORD> --docker-email=<USER_EMAIL> -n kube-system
```
11. Copy [common.env file](https://github.com/urao/contrail5_deployments/blob/master/k8s_nested_mode_deployment/files/common.env) in the top directory of the cloned contrail-container-builder repo and
    modify IP address, k8s secret name,  as per your configuration
12. Install Contrail CNI
```
cd contrail-container-builder
cd contrail-container-builder/kubernetes/manifests
./resolve-manifest.sh contrail-kubernetes-nested.yaml  > nested-contrail.yml
kubectl create -f nested-contrail.yml
```
13. Verify Contrail pods are RUNNING
```
root@vm4:~# kubectl get pods -n kube-system 
NAME                                  READY     STATUS    RESTARTS   AGE
contrail-kube-manager-f2hr8           1/1       Running   1          19h
contrail-kubernetes-cni-agent-k6f2p   1/1       Running   0          19h
coredns-78fcdf6894-6kpmn              1/1       Running   0          1d
coredns-78fcdf6894-9pbkw              1/1       Running   0          1d
etcd-vm4                              1/1       Running   1          18h
kube-apiserver-vm4                    1/1       Running   1          18h
kube-controller-manager-vm4           1/1       Running   1          18h
kube-proxy-5ps5v                      1/1       Running   0          1d
kube-proxy-dgczw                      1/1       Running   1          1d
kube-scheduler-vm4                    1/1       Running   1          18h
```

### Useful k8s commands
```
kubectl get nodes
kubectl describe node <NODE_NAME>
kubectl get pods --all-namespaces 
kubectl exec -it <POD_NAME> -- /bin/bash    ==> Get a shell to a running container
kubectl get pods -n kube-system
docker images
docker ps -a
curl -X GET  <USER_NAME>:<PASSWORD> https://hub.juniper.net/v2/contrail/contrail-kubernetes-kube-manager/tags/list   ==> Get tag list for the images
kubectl get pods -o wide
kubectl get pods -o wide --show-labels
kubectl get netpol
kubectl get service
kubectl get secrets -n kube-system
```

### Debug commands
```
kubectl apply -f nested-contrail.yml --dry-run .  ==> Validate if yml is generated correctly
tail -f /var/log/contrail/kube-manager/contrail-kube-manager.log  ==> on master node
kubectl describe pod contrail-kube-manager -n kube-system
```

### Reference
1. [Wiki](https://github.com/Juniper/contrail-kubernetes-docs/blob/master/install/kubernetes/nested-kubernetes.md)
2. [Contrail Security](https://github.com/fashaikh7/Contrail-Security/wiki/Contrail-Security-with-Kubernetes-(nested-mode)-on-OpenStack)
3. [K8s Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
