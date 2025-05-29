# Simple Ingress Deployment with NGINX and MetalLB

This guide demonstrates how to deploy an Ingress controller (NGINX) and MetalLB for load balancing, and configure an Ingress resource for Longhorn.

## 1. Create the Ingress Resource

Create a file named `ingress.yml` with the following content:

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

Apply the Ingress resource:

```sh
kubectl -n longhorn-system apply -f ingress.yml
```

## 2. Deploy NGINX Ingress Controller

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/cloud/deploy.yaml
kubectl get pods -n ingress-nginx
```

## 3. Deploy MetalLB

```sh
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
```

## 4. Configure MetalLB

Create a file named `metallb-config.yml` with the following content:

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

Apply the MetalLB configuration:

```sh
kubectl apply -f metallb-config.yml
```

## 5. Check Ingress Service

```sh
kubectl get svc -n ingress-nginx
```