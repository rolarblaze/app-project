
Classes Microservices


Overview 

Classes is a microservice based application. It demonstrate the migration of a monolithic application to a microservices architecture.

It consists of a frontend and a backend, with the backend logic running on PHP. The micrososervice orchastration is deployed using kubernetes(K3s) on azure infrastructure.

The services run on a master and worker node within the same subnet on the same network layer.

Note: this is designed for development purposes with plans for production refactoring later 


ARCHITECTURE 

The application is split into two microservices:
  - Frontend: docker image build, deployed as a jubernetes deployment and exposed via a service.
  - Backend: a php stack connected to mysql database deployed as a kubernetes Deployment and exposed via a service 
  - Infrastructure: Vnet and subnetting hosted on Azure with k3s on a master and slave in the same subnet, using an internal network for communication


PREREQUISITES:
  - active azure subscription or on aws 
  - kubectl installed locally for cluster management 
  - Docker installed for building container images
  - git for Cloning the repository 

Steps: 
1. create a virtual network with a subnet on azure or AWS 
2. launch an ubuntu instance on the subnet call it k3s-master, and k3s-worker 
3. ssh into the the master node 
4 run sudo apt update to update the machine 
 on the master node run curl -sfL https://get.k3s.io | sh - 
    this script will: 
      download and install the k3s binaries 
      configure the systemd services 
      generate required token
      set up a Kubeconfig file 
After installation you need to run a check if k3s installation was successful 
# kubectl get nodes

Next step 
you need to get the Node_token and the master node IP 

to get the master node internal IP 
Hostname or hostname -I on the master node, copy it to a txt file 
to get the Node Token Key run 
cat /var/lib/rancher/k3s/server/node_token on the master 

Now lets get the worker node working, and connected to the master node 
curl -sfL https://get.k3s.io | K3S_URL=https://<master-ip>:6443 K3S_TOKEN=<node-token> sh -  replaces the <master-ip> and <node_token> with your values do this on the worker node


navigate back to your master node and run kubectl get nodes, you should now see two nodes running. if this is succesfull it means both the master and worker node has established a successful communication 

git clone the repository to your master 
cd into the project directory cd /app-project/kubernetes
kubectl apply -f /backend/frontend-deploy.yaml 

do this for all the deployemnt and services

To view the application 
public-ip:30080 on your browser 
















































































# Introduction to Kubernetes

## Kubernetes Engine
- Kind
- Minikube
- Cloud Provider cluster

## Pre-requisites:
- kubectl
- helm
- kustomise
- skaffold

In this module will be using kind kubernetes engine for local deployment.

### TODO for Local running Kubernetes Engine.
- install Docker on your PC
- install kind on your PC
- create a file name "kind-config.yaml" , then save the code snippet below in it.

```
apiVersion: kind.x-k8s.io/v1alpha4
kind: Cluster
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
networking:
  disableDefaultCNI: true

```

- open a terminal to the command below:

```
kind create cluster -n dev --config kind-config.yaml
```

It should create a cluster with 3 workers.