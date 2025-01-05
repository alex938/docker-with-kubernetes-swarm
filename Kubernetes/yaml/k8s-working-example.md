## Example Service and Deployment

```yaml
apiVersion: v1
kind: Service
metadata:
  name: app-nginx-service
spec:
  type: NodePort
  ports:
    - port: 80
      nodePort: 30010
  selector:
    app: app-nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app-nginx
  template:
    metadata:
      labels:
        app: app-nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.17.3
          ports:
            - containerPort: 80
```

**Apply the YAML:**
```bash
kubectl apply -f app.yml
```

**Output:**
```
service/app-nginx-service created
deployment.apps/app-nginx-deployment created
```

**Dry-run the YAML:**
```bash
kubectl apply -f app.yml --dry-run=server
```

**Output:**
```
service/app-nginx-service unchanged (server dry run)
deployment.apps/app-nginx-deployment unchanged (server dry run)
```

**Test the Service:**
```bash
curl http://192.168.2.50:30010
```

## Make a Change to YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: app-nginx-service
spec:
  type: NodePort
  ports:
    - port: 80
      nodePort: 30020
  selector:
    app: app-nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app-nginx
  template:
    metadata:
      labels:
        app: app-nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.17.3
          ports:
            - containerPort: 80
```

**Dry-run the YAML:**
```bash
kubectl apply -f app.yml --dry-run=server
```

**Output:**
```
service/app-nginx-service configured (server dry run)
deployment.apps/app-nginx-deployment configured (server dry run)
```

**Apply the YAML:**
```bash
kubectl apply -f app.yml
```

**Test the Service:**
```bash
curl http://192.168.2.50:30020