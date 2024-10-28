# Docker Swarm Service

```
docker service create --name nginx_service --replicas 3 -p 80:80
```

```
docker swarm join-token worker
docker swarm join-token manager
```

```
docker swarm join --token SWMTKN-1-xxxxxx <manager-ip>:2377
```

```
docker service create --name nginx_service --replicas 6 --placement-pref "spread=node.id" -p 80:80 nginx
```

```
docker node update --label-add type=pi3 <node-name>
docker node inspect <node-name> --format "{{ .Spec.Labels }}"
docker service create --name nginx_service --replicas 3 --constraint "node.labels.type == pi3" -p 80:80 nginx
```

```
docker service ps <service_name>
```