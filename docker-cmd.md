
## pull an images
docker pull hello-world

## run images given container name "myweb"
docker run --name myweb hello-world

	## again
	docker start myweb 


## list container
docker ps
docker container ls

## stop container
docker stop xxxxxxxxx_id
docker stop xxxxxxxxx_name


## delete container
docker rm xxxxxxxxx_id

## run and get into shell, use "apk add any-package"

docker run -it alpine

    *** you can install other package like following ***
	
    apk add curl
	apk add mysql-client
	...

## run and execute command, remove after exit

docker run --rm alpine ls /etc


## run and get into shell, remove after exit

docker run -it --rm alpine


## map local port [8080] -> internal 80
docker run -d -p 8080:80 nginx:latest 

## map multi-port [3000, 8080] -> 80
docker run -d -p 8080:80 -p 3000:80 nginx:latest 



## build images with tag name "node-test"

	docker build -t node-test .


## get into docker bash

	docker exec -it hive-server bash
	
	docker-compose exec hive-server bash


## copy docker file to host
  
  docker cp CONTAINER_ID:/path/filename.txt  ./local/file1.txt
  
## copy  host file to docker container
  
  docker cp ./local/file1.txt  CONTAINER_ID:/path/filename.txt   
  
  
#######  docker-compose ############

docker-compose up -d     ## pull image, create container and start 

docker-compose start     ## start container

docker-compose stop     ## stop container, note: data is kept.

docker-compose down     ## stop container and delete container, note: data will be lost

 
************** spark - /tmp/hive on HDFS should be writable *********************

winutils.exe chmod 777 C:\tmp\hive


*********** airflow *************

docker pull apache/airflow

# initialize the database, with env variable and volumn mapping

docker run -e AIRFLOW_HOME=/demo -v /c/demo:/demo apache/airflow initdb


# start the web server, 
	## default port is 8080, 
	## map local driver c:/demo -> internal /demo

docker run -e AIRFLOW_HOME=/demo -v /c/demo:/demo apache/airflow webserver -p 8080

     ## default port is 8080, but map outside port 5000 -> internal 8080

docker run -e AIRFLOW_HOME=/demo -v /c/demo:/demo -p 5000:8080  apache/airflow webserver -p 8080


	http://localhost:5000


# start the scheduler

docker run -e AIRFLOW_HOME=/demo -v /c/demo:/demo apache/airflow scheduler

	
### hive docker 

# To run Hive with postgresql metastore:
    
	docker-compose up -d


# Load data into Hive:
  $ docker-compose exec hive-server bash
  # /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
  > CREATE TABLE pokes (foo INT, bar STRING);
  > LOAD DATA LOCAL INPATH '/opt/hive/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;
  
  > !quit  # to close the session window.

# copy docker file to local
  
	docker cp CONTAINER_ID:/path/filename.txt  ./local/file1.txt
 
# copy  local file to docker container

	docker cp foo.txt mycontainer:/path/foo.txt 
	
	