**Command:**
```bash
alex@k:~$ kubectl create deployment test --image nginx --dry-run=client
```
**Output:**
```bash
deployment.apps/test created (dry run)
```

**Command:**
```bash
alex@k:~$ kubectl create deployment test --image nginx --dry-run=client -o yaml
```
**Output:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: test
  name: test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: test
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
status: {}
```

**Command:**
```bash
alex@k:~$ kubectl create job test --image nginx --dry-run=client -o yaml
```
**Output:**
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: test
spec:
  template:
    metadata:
      creationTimestamp: null
    spec:
      containers:
      - image: nginx
        name: test
        resources: {}
      restartPolicy: Never
status: {}
```

**Command:**
```bash
alex@k:~$ kubectl create deployment test --image nginx
```
**Output:**
```bash
deployment.apps/test created
```

**Command:**
```bash
alex@k:~$ kubectl expose deployment/test --port 80 --dry-run=client -o yaml
```
**Output:**
```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: test
  name: test
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: test
status:
  loadBalancer: {}
```

**Command:**
```bash
alex@k:~$ kubectl expose deployment/test --type=NodePort --port=8881 --target-port=80 --dry-run=client -o yaml
```