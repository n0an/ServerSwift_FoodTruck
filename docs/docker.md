## Docker

#### Contents
- [Images](#images)
- [Containers](#containers)
- [Docker Compose](#docker-compose)

#### Images
1. Search for image:
```
docker search swift
docker search couchdb
```
2. Pull image:
```
docker pull <image_name>
docker pull ibmcom/swift-ubuntu:latest
docker pull devslopes/swift-ubuntu-docker
docker pull klaemo/couchdb:2.0.0
docker pull couchdb
```
3. List images:
```
docker images
```
4. Remove image:
```
docker rmi <IMAGE_NAME>
```

#### Containers
1. Create hosting folder:
```
cd Desktop
mkdir server
cd server
```
2. Permanent create start and attach container for hosting folder and translate specified ports:
 - Paul:
```
docker run -itv $(pwd):/projects --name projects -w /projects -p 8089:8089 -p 8090:8090 -p 5984:5984 <IMAGE_NAME> /bin/bash
```
 - Devslopes:
```
docker run -itv $(pwd):/root/ -w /root --name devslopes_container devslopes/swift-ubuntu-docker /bin/bash
```
```
docker run -itv $(pwd):/root/ -w /root --name ibmcom -p 8089:8089 -p 8090:8090 -p 5984:5984 ibmcom/swift-ubuntu /bin/bash
```
3. Start and stop container:
```
docker start <CONTAINER_NAME>
docker stop <CONTAINER_NAME>
```
4. Attach started container:
```
docker attach <CONTAINER_NAME>
```
5. Detach container:
```
ctrl+p
ctrl+q
```
6. Exit from docker container:
```
exit
```
7. List created containers:
 - Show running containers:
 ```
 docker ps
 ```
  - Show all containers:
 ```
 docker ps -a
 ```
8. Remove container:
```
docker rm <CONTAINER_NAME>
```
9. Run specific way:
 - Start CouchDB with login and password:
```
docker run --name couch2 -p 5984:5984 -e COUCHDB_USER=anton -e COUCHDB_PASSWORD=123456 klaemo/couchdb:2.0.0
```
 - Start with interactive logging to shell:
```
docker start couch2 -i
docker start devslopes_container -i
docker start projects -i
```

#### Docker Compose
1. For release in root directory of project create file:
**docker-compose.yml**
2. Run release compose:
```
docker-compose up
```
3. For testing create file:
**docker-test.yml**
4. Run testing compose:
```
docker-compose -f docker-test.yml up
```
