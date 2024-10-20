# Docker

```shell
docker container run -p 80:80 --name web -d nginx
docker container inspect --format '{{ .NetworkSettings.IPAddress }}' web

docker network ls
docker network inspect bridge
docker network create --subnet=172.30.0.0/24 my_app_network
docker container run -d --name new_nginx --network my_app_network nginx

docker network connect NETWORKID CONTAINERID  
docker container run --rm -it centos:7 bash
docker container run --rm -it ubuntu:14.04 bash
```
