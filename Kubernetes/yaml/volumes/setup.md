## Setting Up Volumes in Kubernetes

**Apply all YAML files in the current directory:**
```bash
kubectl apply -f .
```

**Or apply individual YAML files:**
```bash
kubectl apply -f pv1.yaml
kubectl apply -f pvc1.yaml
kubectl apply -f nginx_deployment.yaml
kubectl apply -f service.yaml
```

**Check Persistent Volumes (PV):**
```bash
kubectl get pv
```

**Check Persistent Volume Claims (PVC):**
```bash
kubectl get pvc
```

**Check Deployments:**
```bash
kubectl get deployments
```

**Check Pods:**
```bash
kubectl get pods
```

**Check Services:**
```bash
kubectl get svc
```

**Add content to the Nginx volume:**
```bash
echo "Nginx running in K8S!" > /volume1/share/nginx_data/index.html
```

**Check it works:**
```bash
curl http://<NodeIP>:30020
```