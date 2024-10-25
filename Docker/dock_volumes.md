# Docker Volumes


Still uses what ever is in the Dockerfile, but helpful name volumes 
```
docker container run -d --name mysql -e MYSQL_ALL_EMPTY_PASSWORD:True -v mysql-db:/var/lib/mysql mysql
```

```
docker volume create 
```