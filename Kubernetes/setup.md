## Kubernetes Cluster Setup (Controller)

### Disable Swap
```bash
sudo swapoff -a
sudo nano /etc/fstab # comment out swap
sudo modprobe overlay
sudo modprobe br_netfilter
```

### Load Kernel Modules
```bash
sudo nano /etc/modules-load.d/k8s.conf

overlay
br_netfilter
```

### Configure sysctl
```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system
sysctl net.ipv4.ip_forward
```

### Install Docker
```bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
```

### Configure containerd
```bash
sudo systemctl status containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo nano /etc/containerd/config.toml #cahnge 'SystemdCgroup = true' in [..io.containerd...runc.options]
sudo systemctl restart containerd
sudo systemctl status containerd
```

### Install Kubernetes
```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
```

### Install network plugin (flannel in this case)
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sudo systemctl restart kubelet
kubectl get pods -n kube-system
```

### Initialise Kubernetes Cluster
```bash
sudo kubeadm init --pod-network-cidr 10.244.0.0/16 --control-plane-endpoint "192.168.2.52:6443" --upload-certs
```

### Get kubeadm Token
```bash
sudo kubeadm token list
```

### Get CA Certificate Hash
```bash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform DER 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
```
