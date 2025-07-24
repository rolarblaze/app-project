Classes Microservices

Overview

Classes is a microservices-based application demonstrating the migration from a monolithic architecture to a distributed system. 
It consists of a frontend microservice and a PHP-based backend microservice connected to a MySQL database, 
orchestrated using Kubernetes (k3s) on Azure infrastructure for development. 
The services run on a master and worker node within the same subnet, with plans for production refactoring later.


Architecture

The application is split into two microservices:

Frontend: A web interface built as a Docker image, deployed as a Kubernetes Deployment, and exposed via a Service.

Backend: A PHP-based API handling business logic, connected to a MySQL database, deployed as a Kubernetes Deployment and exposed via a Service.

Infrastructure: Hosted on Azure with a Virtual Network (VNet) and subnet, using k3s (lightweight Kubernetes) on a master and worker node in the same subnet for internal communication.

Features
Service Components
Frontend: React/Vue.js application containerized and deployed as a Kubernetes deployment
Backend: PHP application stack with business logic, deployed as a Kubernetes deployment
Database: MySQL database for persistent data storage

Network Architecture

Cloud Provider: Microsoft Azure (AWS compatible)
Orchestration: k3s (Lightweight Kubernetes distribution)
Networking: Single subnet deployment for simplified development networking
Communication: Internal cluster networking for service-to-service communication
External Access: NodePort services for development access

Prerequisites
    Active Azure subscription (or AWS as an alternative)
    Permissions to create virtual networks and compute instances
    SSH key pair for instance access

Local Development Tools
    kubectl: Kubernetes command-line tool for cluster management
    Docker: Container runtime for building and managing images
    Git: Version control for cloning the repository
    SSH client: For remote server access
    Ubuntu 20.04 LTS or later (for k3s nodes)
    Minimum 2GB RAM per node
    25GB disk space per node

Quick Start Guide

Infrastructure Setup
    install azure CLI 
# login to azure
    az login 
# select a subscription 
1. Create Azure Resources

# Create resource group
az group create --name k3s-rg --location eastus

# Create virtual network
az network vnet create \
    --resource-group k3s-rg \
    --name k3s-vnet \
    --address-prefix 10.0.0.0/16 \
    --subnet-name k3s-subnet \
    --subnet-prefix 10.0.0.0/24

2. Launch a virtual Machine 
    # Create k3s-master instance
    az vm create \
        --resource-group k3s-rg \
        --name k3s-master \
        --image Ubuntu24 \
        --size Standard_B2s \
        --subnet k3s-subnet \
        --generate-ssh-keys

3. Cluster Set up 
Lets configure the master Node and install k3s 
    SSH into the master node: ssh azureuser@<master-public-ip>
# Update system packages
    sudo apt update && sudo apt upgrade -y
# Install k3s on master node
    curl -sfL https://get.k3s.io | sh -
    This installs k3s, configures systemd services, generates a node token, and creates a kubeconfig file.
# Verify installation
    sudo kubectl get nodes

4. retrieve Cluster information 
    # Get master node internal IP
    hostname -I

    # Get node token for worker registration
    sudo cat /var/lib/rancher/k3s/server/node-token
    Important: Save both the master IP and node token for worker node setup.
    
 5. Configure worker Node 
    # SSH into worker node
    ssh azureuser@<worker-public-ip>

    # Update system packages
    sudo apt update && sudo apt upgrade -y

    # Join worker to cluster (replace <master-ip> and <node-token>)
    curl -sfL https://get.k3s.io | K3S_URL=https://<master-ip>:6443 K3S_TOKEN=<node-token> sh -
    Replace <master-ip> and <node-token> with the values from step 
You can also pass the TOKEN KEY and master_ip into an env call the env variables instead of directly exposing the key and IP address

6. Verify Cluster 
    # On master node, verify both nodes are ready
    sudo kubectl get nodes

7. Local Development
    navigate to the backend directory where the Dockerfile is 
    cd backend
    #build and push the backend image 
    docker build -t backend-db:latest .
    docker tag backend-db:latest <registry>/backend-db:v1
    docker push <registry>/backend-db:v1
8. repeat the same process for the frontend 

9. Application Deployment
    # Clone repository on master node
    git clone <your-repository-url>
    cd classes-microservices

    # Navigate to Kubernetes manifests
    cd kubernetes

    # Deploy backend services
    kubectl apply -f backend/backend-deployment.yaml
    kubectl apply -f backend/backend-deployment.yaml

    # Deploy frontend services
    kubectl apply -f frontend/frontend-service.yaml
    kubectl apply -f frontend/backend-service.yaml

8. Verify Deployment 
    # Check all pods are running
    kubectl get pods

    # Check services are exposed
    kubectl get services

    # Check deployment status
    kubectl get deployments

    #check the namespace that the app is deployed to 
    kubectl get ns -- it should be created on the default namespace if nothing changes 

    curl ifconfig.me -- get the node public IP

To view your app go to the browser 
http://<master-public-ip>:30080 


















































































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