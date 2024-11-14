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

```
kubectl describe deployment my-apache
```
![image](https://github.com/user-attachments/assets/389efebf-1819-4255-81b0-bff2d31f1b76)

```
kubectl describe pod/my-apache-6c8c89bbb9-8wdkq
```
![image](https://github.com/user-attachments/assets/0fe1e569-e08a-46ab-a0f8-590bf4e195ab)

```
kubectl get node kubecontrol1 -o wide
```
![image](https://github.com/user-attachments/assets/fed0d12a-72d0-43af-96c5-951945051bc7)

```
kubectl describe node kubecontrol1
```
![image](https://github.com/user-attachments/assets/0c3125fc-1f54-4c9b-8a04-c317b602f98e)
