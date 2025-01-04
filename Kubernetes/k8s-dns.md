**Command:**
```bash
alex@k:~$ kubectl get namespaces
```
**Output:**
```bash
NAME              STATUS   AGE
default           Active   12d
kube-flannel      Active   12d
kube-node-lease   Active   12d
kube-public       Active   12d
kube-system       Active   12d
```

**DNS Format:**
```
<service-name>.<namespace>.svc.cluster.local
<service-name>.kube-system.svc.cluster.local
```
