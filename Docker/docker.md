# Docker

```shell
docker container run -p 80:80 --name web -d nginx
docker container inspect --format '{{ .NetworkSettings.IPAddress }}' web

docker network ls
docker network inspect bridge
docker network create --subnet=172.30.0.0/24 my_app_network
docker container run -d --name new_nginx --network my_app_network nginx
docker network connect NETWORKID CONTAINERID
docker network disconnect NETWORKID CONTAINERID

docker container run --rm -it centos:7 bash
docker container run --rm -it ubuntu:14.04 bash
```

DNS Round Robin Internal Network
```
docker network create network1
docker container run -d -net network1 --net-alias search elasticsearch:2
docker container run -d -net network1 --net-alias search elasticsearch:2
docker container ls

docker container run --rm -net network1 centos curl -s search:9200
```

DNS Round Robin Internal Network (exposing externally)
docker-compose.yml
```
services:
  search1:
    image: elasticsearch:2
    networks:
      - network1
    container_name: elasticsearch1

  search2:
    image: elasticsearch:2
    networks:
      - network1
    container_name: elasticsearch2

  load_balancer:
    image: nginx:alpine
    networks:
      - network1
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf

networks:
  network1:
    driver: bridge
```

nginx.conf
```
events {}

http {
    upstream search {
        server search1:9200;
        server search2:9200;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://search;
        }
    }
}
```
