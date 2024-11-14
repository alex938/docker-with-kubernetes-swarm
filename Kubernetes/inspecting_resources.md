# Inspecting resources

```
kubectl get all
```

```
kubectl get deploy/my-apache -o wide
```

```
NAME        READY   UP-TO-DATE   AVAILABLE   AGE    CONTAINERS   IMAGES   SELECTOR
my-apache   2/2     2            2           168m   httpd        httpd    app=my-apache
```

```
kubectl get deploy/my-apache -o yaml
```