```
helm repo update
```

```
helm upgrade mydb bitnami/mysql --values values.yml
helm upgrade mydb bitnami/mysql --reuse-values
```

```
helm status mydb
```

```
helm list
```