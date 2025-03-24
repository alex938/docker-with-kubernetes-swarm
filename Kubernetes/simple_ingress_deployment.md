##### This assumes you have longhorn installed.
```
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.8.1
kubectl -n longhorn-system get pod
```
## Step 1: Install Nginx Ingress Controller

First, we need to install the **Ingress Controller** to manage incoming requests.

### 1.1 Install the Ingress Controller

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/cloud/deploy.yaml
```

### 1.2 Verify That Ingress is Running

```sh
kubectl get pods -n ingress-nginx
```

**Expected Output:**

```sql
NAME                                       READY   STATUS    RESTARTS   AGE
ingress-nginx-controller-xxxx              1/1     Running   0          30s
```

---

## Step 2: Install MetalLB (For Bare Metal Clusters)

If your cluster does not automatically assign an External IP, use **MetalLB**.

### 2.1 Install MetalLB

```sh
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
```

### 2.2 Verify MetalLB Pods Are Running

```sh
kubectl get pods -n metallb-system
```

**Expected Output:**

```sql
NAME                          READY   STATUS    RESTARTS   AGE
metallb-controller-xxxxx      1/1     Running   0          10s
metallb-speaker-xxxxx         1/1     Running   0          10s
```

### 2.3 Configure MetalLB with an IP Range

Create **`metallb-config.yml`**:

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: main-pool
  namespace: metallb-system
spec:
  addresses:
    - 192.168.2.233-192.168.2.233
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2
  namespace: metallb-system
```

### 2.4 Apply the Configuration

```sh
kubectl apply -f metallb-config.yml
```

### 2.5 Check if Ingress Now Has an IP

```sh
kubectl get svc -n ingress-nginx
```

**Expected Output:**

```pgsql
NAME                      TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)
ingress-nginx-controller  LoadBalancer   10.107.9.214     192.168.2.233    80:31933/TCP,443:30358/TCP
```

---

## Step 3: Configure Ingress

Create **`ingress.yml`**:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: longhorn-ingress
  namespace: longhorn-system
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: longhorn-frontend
            port:
              number: 80
```

### 3.1 Apply the Ingress Configuration

```sh
kubectl -n longhorn-system apply -f ingress.yml
```