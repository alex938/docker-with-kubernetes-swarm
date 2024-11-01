# Docker Swarm Multi Node Voting App

```
sudo docker network create -d overlay frontend
sudo docker network create -d overlay backend
```

```
sudo docker service create --name vote -p 80:80 --network frontend --replicas 2 dockersamples/examplevotingapp_vote:before
sudo docker service create --name redis --network frontend --replicas 2 redis:3.2
sudo docker service create --name worker --network frontend --network backend dockersamples/examplevotingapp_worker
sudo docker service create --name db --mount type=volume,source=db-data,target=/var/lib/postgresql/data --network backend postgres:9.4
#creates volume db-data in /var/lib/docker/volumes/db-data/_data
sudo docker service create --name result --network frontend -p 50001:80 dockersamples/examplevotingapp_result:before
```

```
docker service ls
docker service ps result #redis worker etc

docker service logs worker
#/etc/docker/daemon.json
# {"experimental": true}
```