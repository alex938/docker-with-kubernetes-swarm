# Kubernetes ClusterIP Service Guide

## Initial Deployment

```bash
$ kubectl create deployment httpenv --image=nginxdemos/hello
# Output:
# deployment.apps/httpenv created
```

```bash
$ kubectl scale deployment/httpenv --replicas=5
# Output:
# deployment.apps/httpenv scaled
```

```bash
$ kubectl get pods
# Output:
# NAME                       READY   STATUS    RESTARTS   AGE
# httpenv-6669bdd468-c6d6t   1/1     Running   0          13s
# httpenv-6669bdd468-chrwb   1/1     Running   0          52s
# httpenv-6669bdd468-hpwth   1/1     Running   0          13s
# httpenv-6669bdd468-w7ghk   1/1     Running   0          13s
# httpenv-6669bdd468-wfv7t   1/1     Running   0          13s
```

```bash
$ kubectl get pods -o wide
# Output:
# NAME                       READY   STATUS    RESTARTS   AGE   IP           NODE   NOMINATED NODE   READINESS GATES
# httpenv-6669bdd468-c6d6t   1/1     Running   0          41s   10.244.1.4   kw1    <none>           <none>
# httpenv-6669bdd468-chrwb   1/1     Running   0          80s   10.244.2.2   kw2    <none>           <none>
# httpenv-6669bdd468-hpwth   1/1     Running   0          41s   10.244.1.2   kw1    <none>           <none>
# httpenv-6669bdd468-w7ghk   1/1     Running   0          41s   10.244.1.3   kw1    <none>           <none>
# httpenv-6669bdd468-wfv7t   1/1     Running   0          41s   10.244.2.3   kw2    <none>           <none>
```

```bash
$ kubectl expose deployment httpenv --port=8881 --target-port=80
# Output:
# service/httpenv exposed
```

```bash
$ kubectl get service
# Output:
# NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
# httpenv      ClusterIP   10.111.203.174   <none>        8881/TCP   26s
# kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP    12d
```

```bash
$ kubectl describe svc httpenv
# Output:
# Name:              httpenv
# Namespace:         default
# Labels:            app=httpenv
# Annotations:       <none>
# Selector:          app=httpenv
# Type:              ClusterIP
# IP Family Policy:  SingleStack
# IP Families:       IPv4
# IP:                10.102.149.140
# IPs:               10.102.149.140
# Port:              <unset>  8881/TCP
# TargetPort:        80/TCP
# Endpoints:         10.244.1.2:80,10.244.1.3:80,10.244.1.4:80 + 2 more...
# Session Affinity:  None
# Events:            <none>
```

```bash
$ kubectl run tmp-shell --rm -it --image=ubuntu:latest -- bash
# Inside the shell:
root@tmp-shell:/# apt-get update && apt-get install curl -y
# Output:
# Get:1 http://archive.ubuntu.com/ubuntu jammy InRelease [270 kB]
# ...
# Setting up curl (7.81.0-1ubuntu1.14) ...
# Processing triggers for libc-bin (2.35-0ubuntu3.6) ...
```

```bash
root@tmp-shell:/# curl httpenv:8881
# Output:
# <!DOCTYPE html>
# <html>
# <head>
# <title>Hello World</title>
# ...
# </html>
```

```bash
$ kubectl delete service httpenv
# Output:
# service "httpenv" deleted
```

```bash
$ kubectl delete deployment httpenv
# Output:
# deployment.apps "httpenv" deleted
```