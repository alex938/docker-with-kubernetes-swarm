#!/bin/bash

# Kubernetes Cluster Setup Script for Controller Node

set -euo pipefail

K8S_VERSION="v1.34"
POD_NETWORK_CIDR="10.244.0.0/16"

# Disable Swap
echo "Disabling swap..."
sudo swapoff -a
sudo sed -i '/\sswap\s/ s/^#*/#/' /etc/fstab

# Load Kernel Modules
echo "Loading kernel modules..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl
echo "Configuring sysctl..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Install Docker
echo "Installing Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gpg apt-transport-https
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Add Kubernetes repo (one apt-get update covers both repos)
curl -fsSL "https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/Release.key" | sudo gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure containerd
echo "Configuring containerd..."
sudo systemctl enable --now containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
if ! grep -q 'SystemdCgroup = true' /etc/containerd/config.toml; then
    echo "ERROR: could not set SystemdCgroup = true in /etc/containerd/config.toml" >&2
    exit 1
fi
sudo systemctl restart containerd

# Install Kubernetes
echo "Installing Kubernetes components..."
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

# Initialize Kubernetes Cluster (skipped if already initialised)
if [ -f /etc/kubernetes/admin.conf ]; then
    echo "Cluster already initialised, skipping kubeadm init."
else
    echo "Initialising Kubernetes cluster..."
    sudo kubeadm init --pod-network-cidr="$POD_NETWORK_CIDR"
fi

# Configure kubectl for the current user
echo "Setting up kubectl..."
mkdir -p "$HOME/.kube"
sudo cp /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"

# Install Flannel Network Plugin
echo "Installing Flannel network plugin..."
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Verify Setup
echo "Waiting for control plane node to become Ready..."
kubectl wait --for=condition=Ready node --all --timeout=300s
kubectl get nodes
kubectl get pods -n kube-system

echo "Kubernetes cluster setup completed successfully!"
echo
echo "Run this on each worker node to join the cluster:"
sudo kubeadm token create --print-join-command
