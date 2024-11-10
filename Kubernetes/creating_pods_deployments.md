## Kubernetes Commands

### Create a Pod
```bash
kubectl run my-nginx --image nginx
kubectl describe pod my-nginx
kubectl delete pod my-nginx

kubectl run pingpong --image alpine --command --restart=Never --attach -- ping -c 5 1.1.1.1
kubectl delete pod pingpong
```

### Create deployment
```bash
kubectl create deployment my-nginx --image nginx
kubectl get all
kubectl delete deployment my-nginx
```

### Scaling with replicas
```bash
kubectl create deployment my-apache --image httpd
kubectl get pods #1/1
kubectl scale deploy/my-apache --replicas 2
```

### Check cluster
```bash
kubectl get pods -n kube-system
kubectl get nodes
kubectl get pods
kubectl get all
```