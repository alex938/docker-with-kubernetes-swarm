# Tomcat Deployment on Kubernetes with Helm

This guide describes how to deploy Tomcat using the Bitnami Helm chart on Kubernetes, configure access, and enable remote management.

## 1. Install Tomcat with Helm

```sh
helm install tomcat bitnami/tomcat
```

## 2. Check Kubernetes Nodes

```sh
kubectl get nodes -o wide
```

Example output:

| NAME  | STATUS | ROLES           | AGE | VERSION  | INTERNAL-IP     | EXTERNAL-IP | OS-IMAGE           | KERNEL-VERSION   | CONTAINER-RUNTIME   |
|-------|--------|-----------------|-----|----------|----------------|-------------|--------------------|------------------|---------------------|
| tk    | Ready  | control-plane   | 50d | v1.30.11 | 192.168.2.230  | <none>      | Ubuntu 24.04.2 LTS | 6.8.0-57-generic | containerd://1.7.27 |
| tkw1  | Ready  | <none>          | 50d | v1.30.11 | 192.168.2.231  | <none>      | Ubuntu 24.04.2 LTS | 6.8.0-57-generic | containerd://1.7.27 |
| tkw2  | Ready  | <none>          | 50d | v1.30.11 | 192.168.2.232  | <none>      | Ubuntu 24.04.2 LTS | 6.8.0-57-generic | containerd://1.7.27 |

## 3. Check Tomcat Service

```sh
kubectl get svc tomcat --namespace default
```

Example output:

| NAME    | TYPE         | CLUSTER-IP     | EXTERNAL-IP | PORT(S)      | AGE |
|---------|--------------|---------------|-------------|--------------|-----|
| tomcat  | LoadBalancer | 10.105.70.175 | <pending>   | 80:32614/TCP | 37m |

## 4. Get Tomcat Admin Password

```sh
kubectl get secret --namespace default tomcat -o jsonpath="{.data.tomcat-password}" | base64 -d
```

## 5. Create Custom Values File

Create a file named `tomcat_values.yml` with the following content:

```yaml
tomcatPassword: test
tomcatUsername: user
allowRemoteManagement: true
service:
  type: NodePort
  nodePorts:
    http: 32007

readinessProbe:
  enabled: true
  initialDelaySeconds: 20
  periodSeconds: 10
  timeoutSeconds: 5
```

## 6. Upgrade Tomcat Release with Custom Values

```sh
helm upgrade tomcat bitnami/tomcat --values tomcat_values.yml --debug
```

## 7. Allow Public Access to Tomcat Manager

Get the Tomcat pod name:

```sh
kubectl get pods -l app.kubernetes.io/name=tomcat
```

Open a shell in the Tomcat pod:

```sh
kubectl exec -it <tomcat-pod-name> -- bash
```

Edit the `context.xml` to comment out the RemoteAddrValve:

```sh
sed -i 's/^\s*<Valve /<!-- <Valve /; s/\/>$/\/> -->/' /bitnami/tomcat/webapps/manager/META-INF/context.xml
```

Example of the commented line:

```xml
<!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve"
       allow="127.\d+.\d+.\d+.\d+|::1|0:0:0:0:0:0:0:1" /> -->
```

## 8. Restart Tomcat Deployment

```sh
kubectl rollout restart deployment tomcat
```

## 9. Uninstall Tomcat (Optional)

```sh
helm uninstall tomcat