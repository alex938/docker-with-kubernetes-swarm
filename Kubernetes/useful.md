# Useful commands

Create join command on control node:
```
kubeadm token create --print-join-command
```

Rename role:
```
kubectl label node kw1 node-role.kubernetes.io/worker=worker
```
