# Useful commands

Create join command on control node:
```
kubeadm token create --print-join-command
```

Rename role:
```
kubectl label node kw1 node-role.kubernetes.io/worker=worker
```

Enter shell of deployment:
```
kubectl exec -it app-nginx-deployment-69b6d64f99-8jdlj -- /bin/sh
```

```
 kubectl delete -f k8s/file_server/fileserver.yml
```

```
k describe deployment nginx-deployment-7768bf8cf9-7k7x8
k describe pod nginx-deployment-7768bf8cf9-7k7x8
```

```
kubectl rollout restart deployment nginx-deployment
```

```
k logs nginx-deployment-7bd8977d78-bmj9h
```
