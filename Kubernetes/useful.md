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
