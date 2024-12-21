#!/bin/bash

# Kubernetes Worker Node Setup Script

# ------------------------------------------------------------------------------
# 1. Disable Swap
# ------------------------------------------------------------------------------
echo "Disabling swap..."
sudo swapoff -a
sudo sed -i '/\/swap.img/ s/^/#/' /etc/fstab

# ------------------------------------------------------------------------------
# 2. Load Kernel Modules
# ------------------------------------------------------------------------------
echo "Loading kernel modules..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# ------------------------------------------------------------------------------
# 3. Configure sysctl
# ------------------------------------------------------------------------------
echo "Configuring sysctl..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# ------------------------------------------------------------------------------
# 4. Install Docker (containerd)
# ------------------------------------------------------------------------------
echo "Installing Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure containerd
echo "Configuring containerd..."
sudo systemctl enable --now containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

# ------------------------------------------------------------------------------
# 5. Install Kubernetes Components
# ------------------------------------------------------------------------------
echo "Installing Kubernetes components..."
sudo apt-get update
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

# ------------------------------------------------------------------------------
# FINAL INSTRUCTIONS
# ------------------------------------------------------------------------------
echo "--------------------------------------------------------"
echo "Kubernetes worker node setup completed successfully!"
echo
echo "Next steps:"
echo "1. On the control-plane node, retrieve the 'kubeadm join' command."
echo "2. Run that command on this node to join the existing Kubernetes cluster."
echo "   For example:"
echo "   sudo kubeadm join <CONTROL_PLANE_IP>:<PORT> --token <TOKEN> \\"
echo "       --discovery-token-ca-cert-hash sha256:<HASH>"
echo "--------------------------------------------------------"
