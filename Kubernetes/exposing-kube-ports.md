# Kubernetes: Exposing Ports

Kubernetes services can expose applications in several ways. Here are the main types:

## 1. ClusterIP

- Provides a single, internal virtual IP.
- **Important:** Only reachable from within the cluster.

```sh
kubectl expose deployment my-app --type=ClusterIP --port=80
```

## 2. NodePort

- Exposes the service on each Node's IP at a static port (the NodePort).
- The service is accessible externally at `<NodeIP>:<NodePort>`.
- Port number is typically in the range 30000–32767.

```sh
kubectl expose deployment my-app --type=NodePort --port=80 --name=my-app-nodeport
```

## 3. LoadBalancer

- Provisions an external load balancer (if supported by the cloud provider).
- Routes external traffic to the service.

```sh
kubectl expose deployment my-app --type=LoadBalancer --port=80 --name=my-app-lb
```

## 4. ExternalName

- Maps the service to a DNS name (CNAME record) in CoreDNS.
- No proxying of traffic; just DNS redirection.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-external-service
spec:
  type: ExternalName
  externalName: example.com
```
