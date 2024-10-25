# Build and test

```
docker container run -p 80:80 --rm nginx
```

```
docker image build -t nginx_new .
docker image ls
docker container run -p 80:80 --rm nginx_new
docker image tag nginx_new:latest <username>/nginx_new:<tag>
docker push <username>/nginx_new:<tag>
```
