
## steps for create HA hdfs

## 1.Create a common docker network
	docker network create hadoop
	
## 2.Start Zookeeper
	docker run --net=hadoop --name zk-1 --restart always -d zookeeper	

## 3 Start JournalNode
docker run -d --name=jn-1 -e "NNODE1_IP=nn1" -e "NNODE2_IP=nn2" -e "JN_IPS=jn-1:8485" -e "ZK_IPS=zk-1:2181" --net=hadoop -v d:/tmp/hadoop-jn:/mnt/hadoop bastipaeltz/hadoop-ha-docker /etc/bootstrap.sh -d journalnode

## step 4.0 Format the active NameNode
docker run --hostname=nn1 --name=nn1 -it -e "NNODE1_IP=nn1" -e "NNODE2_IP=nn2" -e "JN_IPS=jn-1:8485" -e "ZK_IPS=zk-1:2181" --net=hadoop -v d:/tmp/hadoop-nn1:/mnt/hadoop bastipaeltz/hadoop-ha-docker /etc/bootstrap.sh -d format

## step 4.1 Sync the initial state to the standby NameNode
docker run --hostname=nn2 --name=nn2 -it -e "NNODE1_IP=nn1" -e "NNODE2_IP=nn2" -e "JN_IPS=jn-1:8485" -e "ZK_IPS=zk-1:2181" --net=hadoop -v d:/tmp/hadoop-nn2:/mnt/hadoop -v d:/tmp/hadoop-nn1:/mnt/shared/nn1 bastipaeltz/hadoop-ha-docker /etc/bootstrap.sh -d standby

## remove the nn1 nn2 before step 5,6

docker rm nn1
docker rm nn2

## Step 5 start namenode nn1
docker run --hostname=nn1 -p 50060:50070 --name=nn1 -it -e "NNODE1_IP=nn1" -e "NNODE2_IP=nn2" -e "JN_IPS=jn-1:8485" -e "ZK_IPS=zk-1:2181" --net=hadoop -v d:/tmp/hadoop-nn1:/mnt/hadoop -v d:/tmp/log-nn1:/usr/local/hadoop/logs bastipaeltz/hadoop-ha-docker /etc/bootstrap.sh -d namenode

## Step 6 start namenode nn2
docker run --hostname=nn2 --name=nn2 -p 50080:50070 -it -e "NNODE1_IP=nn1" -e "NNODE2_IP=nn2" -e "JN_IPS=jn-1:8485" -e "ZK_IPS=zk-1:2181" --net=hadoop -v d:/tmp/hadoop-nn2:/mnt/hadoop -v d:/tmp/log-nn2:/usr/local/hadoop/logs bastipaeltz/hadoop-ha-docker /etc/bootstrap.sh -d namenode

## step Start DataNodes
docker run -d -e "NNODE1_IP=nn1" -e "NNODE2_IP=nn2" -e "JN_IPS=jn-1:8485" -e "ZK_IPS=zk-1:2181" --net=hadoop -v d:/tmp/hadoop-dn-1:/mnt/hadoop bastipaeltz/hadoop-ha-docker /etc/bootstrap.sh -d datanode


### export hdfs 

export PATH=$PATH:/usr/local/hadoop/bin/


