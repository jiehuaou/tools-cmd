

How can I merge two branches without losing any files?

	git checkout a (you will switch to branch a)
	
	git merge b (this will merge all changes from branch b into branch a)
	
	git commit -a (this will commit your changes)
	
	
	######### one line : pull develop  and merge into current branch ########
	
	git pull origin develop
	
	######### replace local branch with remote develop branch entirely  ############
	
	git reset --hard origin/CAED-788
	
	
	
************* deploy frontend to develop ****************************************

docker-compose run deploy ./deploy/to-dev.sh 0.1.16 --key id_rsa --copyFromLocal --freshBuild 

docker-compose run deploy ./deploy/to-prod.sh 0.1.20 --key id_rsa --copyFromLocal --freshBuild 

*** login ssh ***

ssh -i ~/.ssh/id_rsa   ec2-user@ec2-54-222-208-228.cn-north-1.compute.amazonaws.com.cn

ssh -i ~/.ssh/id_rsa   ec2-user@ec2-54-223-33-81.cn-north-1.compute.amazonaws.com.cn
                                

ssh -i ~/.ssh/id_rsa   epm-user@10.22.17.133


************ renew cert in SZ em2 for java********************

cd /home/ec2-user/java-key

export SSLLIVE=/etc/letsencrypt/live/ec2-54-223-33-81.cn-north-1.compute.amazonaws.com.cn
export JAVAKEY=/home/ec2-user/java-key

openssl pkcs12 -export -in $SSLLIVE/fullchain.pem -inkey $SSLLIVE/privkey.pem -out $JAVAKEY/ssl_key.p12 -password pass:123456

************ renew cert in GZ em2 for java ********************

cd /home/ec2-user/java-key

export SSLLIVE=/etc/letsencrypt/live/ec2-54-222-208-228.cn-north-1.compute.amazonaws.com.cn
export JAVAKEY=/home/ec2-user/java-key

openssl pkcs12 -export -in $SSLLIVE/fullchain.pem -inkey $SSLLIVE/privkey.pem -out $JAVAKEY/ssl_key.p12 -password pass:123456


********* Hashicorp's Vault -Secret Management for Epam-Projects *********

Development environment BSS-DEV: https://vault.service.consul.epm-sec.projects.epam.com:8200/ui/vault/auth?namespace=bss-dev%2Fepm-cnrm&with=ldap
Production environment BSS: https://vault.service.consul.epm-sec.projects.epam.com:8200/ui/vault/auth?namespace=bss%2Fepm-cnrm&with=ldap

login method: ldap
login username: albert_ou
login password: Aou557700
duo: 

*** copy file from win10 to ec2-instance nodejs / ***

scp ./WW_verify_xxx.txt ec2-user@ec2-host:/home/ec2-user/dynamicform/dynamic-form-wechat-frontend/prod/current/

*** copy file from remote ssh 

ssh  ec2-user@remote_host 'cat /etc/nginx/nginx.conf' > local_ng228.conf
	
	
######## env prod ------

SZ admin - https://ec2-54-223-33-81.cn-north-1.compute.amazonaws.com.cn:9100/

api -   http://54.223.33.81:8888/api

Wechat form: https://ec2-54-223-33-81.cn-north-1.compute.amazonaws.com.cn:9000/


GZ admin  https://ec2-54-222-208-228.cn-north-1.compute.amazonaws.com.cn:9100/

Wechat form: https://ec2-54-222-208-228.cn-north-1.compute.amazonaws.com.cn:9000/

######## env dev ------

admin - http://10.22.17.132:5000/admin/login

api -   http://10.22.17.132:8888/api

Wechat Frontend: http://ec2-54-222-208-228.cn-north-1.compute.amazonaws.com.cn:8000/	




	
******* ADSL cmd ***************

rasdial ADSL sz03984080@163.gd 88888888	
	
******* Maven gen command ***********************************************	
	

mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes 	-DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.1           -DgroupId=demo.ins                 -DartifactId=instream-string            -Dversion=1.0-SNAPSHOT  		-DinteractiveMode=false -DarchetypeCatalog=internal      


******** mvn deploy to BAMS *****

mvn deploy:deploy-file -Durl=https://bams-aws.refinitiv.com/artifactory/ext-snapshot.maven.local  \
                       -DrepositoryId="ext-snapshot.maven.local"  \
					   -Dfile=./target/edd-aws-common-0.0.1-SNAPSHOT.jar \
					   -DgroupId="com.refinitiv.edp.ca" \
					   -DartifactId="edd-aws-common" \
					   -Dversion="0.0.1-SNAPSHOT"		


******* Maven spotbugs ***********************************************	

mvn verify

mvn spotbugs:gui
	   
******* Java -cp command ******************************

java -cp "hello-1-1.0-SNAPSHOT.jar;hello-common-1.0-SNAPSHOT.jar" demo.ca.DataClient


******** sam cli **********************************************	   
	   
	sam.cmd init -r java8 -n demo4sqs   # create project
	   
	sam.cmd package --template-file template.yaml  --s3-bucket my-bucket  --output-template-file packaged.yaml
	   
	sam.cmd deploy --template-file ./packaged.yaml --stack-name my-sqs-lambda-example --capabilities CAPABILITY_IAM
	   
********* python Creating a virtual environment *******************************************

## Creating a virtual environment env
py -m venv env


## Activating a virtual environment
.\env\Scripts\activate


************** spark - /tmp/hive on HDFS should be writable *********************

winutils.exe chmod 777 C:\tmp\hive


*********** airflow *************

docker pull apache/airflow

# initialize the database

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

# copy docker file 
  
  docker cp CONTAINER_ID:/path/filename.txt  ./local/file1.txt

  
## ngrok.cc

    143907281030 - http://web.viphk.ngrok.org  - 127.0.0.1:3001
	
	102049281030 - http://api.viphk.ngrok.org  - 127.0.0.1:4001
	
## 7zip command line to exclude subfolder	
	
	7z.exe a -tzip dynamic-form-frontend.zip dynamic-form-frontend\               -mx0 -xr!node_modules -xr!build -xr!*.zip -xr!*.git
	
	7z.exe a -tzip dynamic-form-wechat-frontend.zip dynamic-form-wechat-frontend\ -mx0 -xr!node_modules -xr!build -xr!*.zip -xr!*.git
	
## get field from json and assign to variable in bash script?	

	 value=($(jq -r '.version' package.json))
	 
	 echo $value
	 
## simple http server

    python3 -m http.server --directory /home/path 8000
	
	nohup python3.8 -m http.server --directory /home/ec2-user/resources 9005 &
	
## check port is used 

	sudo netstat -plant | grep LISTEN

## open MS SQL cmd window 

    sqlcmd -S EPCNSZXW0802\SQLEXPRESS -E
	
## build & start ambari docker 

	# build
	docker build -t ambari:001 -f Dockerfile .
	
	# start container, 8080:8080
	
	docker run -p 127.0.0.1:8080:8080/tcp --hostname ambari.hadoop --name ambarihadoop ambari:001
	
	# start container, 8080, 9090 (nifi)
	
	docker run -p 8080:8080 -p 9090:9090 --hostname ambari2.hadoop --name ambarihadoop2 ambari:001
	
	# create cluster, in register server, 1) use docker host , 2) ignor SSH key
	
	# select service, only choose zookeeper
	
	
## config Nifi to connect to HDFS

	# install nifi 
	
	helm install my-release cetic/nifi
	
	# docker container (nifi) connect to wsl's hdfs
	
	# copy core-site.xml,hdfs-site.xml to the folder in docker (nifi)

	# edit core-site.xml update property:
	<property>
		<name>fs.defaultFS</name>
		<value>hdfs://host.docker.internal:9000</value>
	</property>
	
	#edit hdfs-site.xml add property:
	<property>
		<name>dfs.client.use.datanode.hostname</name>
		<value>true</value>
	</property>
	
	# edit /etc/hosts in docker (nifi) add line:
	ip_nn.nn.nn.nn (ping host.docker.internal inside docker) datanode_host (get from datanode page/node in hdfs website)
	
	such as   192.168.65.2    EPCNSZXW0802.princeton.epam.com
	
	# modify ~/hadoop/etc/hadoop/hdfs-site.xml to disable permissions check in HDFS
	
	 <property>
		<name>dfs.permissions</name>
		<value>false</value>
	</property>
	
## install NIFI into ambari

ambari-server install-mpack --mpack=http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.4.1.1/tars/hdf_ambari_mp/hdf-ambari-mpack-3.4.1.1-4.tar.gz	

	password ： Abc_12345678
	
## install SDC (StreamSets Data Collector) cmd
	
	# create volume
	docker volume create --name sdc-data
	docker volume create --name sdc-etc
	
	# create docker instance
	docker run -v sdc-data:/data -v sdc-etc:/etc/sdc -v ~/hello:/hello -p 18630:18630 --add-host=EPCNSZXW0802.princeton.epam.com:192.168.65.2  -d --name streamsetsdc streamsets/datacollector
	
	# install "hadoop fs"
	cd $SDC_DIST
	bin/streamsets stagelibs -list
	bin/streamsets stagelibs -install=streamsets-datacollector-cdh_5_16-lib
	
	#install custom jar 
	
	copy your.jar  into $USER_LIBRARIES_DIR
	
		
## OpenCage Geocoding API

	APIkey     be9e021128b04991885a88df211bafa8
	
	# sample
	
	https://api.opencagedata.com/geocode/v1/json?q=US,Colorado+City,1041+Westpoint+Ave&key=be9e021128b04991885a88df211bafa8
	
	
## create kafka 

	helm install my-kafka -f ~/hello/my-kafka/values.yaml bitnami/kafka
	
	helm install my-kafka bitnami/kafka --set externalAccess.enabled=true,externalAccess.service.type=LoadBalancer,externalAccess.service.port=9094,externalAccess.autoDiscovery.enabled=true,serviceAccount.create=true,rbac.create=true,deleteTopicEnable=true,autoCreateTopicsEnable=true
	
	# show status
	helm status my-kafka
	
	# delete my-kafka
	helm uninstall my-kafka
	
	# list topic
	kafka-topics.sh --list --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181
	
	# delete topic
	kafka-topics.sh --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181 --delete --topic inScalingTopic
	
	# check topic state
	kafka-log-dirs.sh --bootstrap-server $MY_KAFKA_PORT_9092_TCP_ADDR:9092 --describe --topic-list inScalingTopic

	# create topic
	kafka-topics.sh --create --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181 --replication-factor 1 --partitions 1 --topic mytopic1

## Kafka can be accessed by consumers via port 9092 on the following DNS name from within your cluster:

   
	kafka.default.svc.cluster.local

	# Each Kafka broker can be accessed by producers via port 9092 on the following DNS name(s) from within your cluster
	
	kafka-0.kafka-headless.default.svc.cluster.local:9092

	# To create a pod that you can use as a Kafka client run the following commands:

    
	kubectl run kafka-client --restart='Never' --image docker.io/bitnami/kafka:2.7.0-debian-10-r1 --namespace default --command -- sleep infinity
    kubectl exec --tty -i kafka-client --namespace default -- bash

		# PRODUCER:
        kafka-console-producer.sh \
			--broker-list kafka-0.kafka-headless.default.svc.cluster.local:9092 \
            --topic test

		# CONSUMER:
        kafka-console-consumer.sh \
		    --bootstrap-server kafka.default.svc.cluster.local:9092 \
            --topic test \
            --from-beginning

	# To connect to your Kafka server from outside the cluster, follow the instructions below:

        # NOTE: It may take a few minutes for the LoadBalancer IPs to be available.
        Watch the status with: 'kubectl get svc --namespace default -l "app.kubernetes.io/name=kafka,app.kubernetes.io/instance=my-release,app.kubernetes.io/component=kafka,pod" -w'

		#Kafka Brokers domain: You will have a different external IP for each Kafka broker. 
		#You can get the list of external IPs using the command below:

        echo "$(kubectl get svc --namespace default -l "app.kubernetes.io/name=kafka,app.kubernetes.io/instance=my-release,app.kubernetes.io/component=kafka,pod" -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}' | tr ' ' '\n')"

		Kafka Brokers port: 9094
			
# auto-scale kafka

    cp /mnt/d/bigdata-homework/kafka-homework/task2/kafka-streams-scaling-master/build/libs/kafka-streams-scaling-all.jar .

	# build docker java app
    docker build . --no-cache -t albertou/kafka-streams-scaling:1234
    
	docker push albertou/kafka-streams-scaling:1234

	# build autoscaler and monitor
	kubectl apply -f jmx-config-map.yaml
	kubectl apply -f service.yaml
	kubectl apply -f horizontal-pod-autoscaler.yaml
	kubectl apply -f service-monitor.yaml
	kubectl apply -f kafka-streams-scaling-deployment.yaml
	
	# expose grafana
	kubectl port-forward prometheus-operator-grafana-f9f8dd854-wkwzr 3000:3000
	
	# create topic
	kafka-topics.sh --create --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181 --replication-factor 1 --partitions 6 --topic inScalingTopic
	
	kafka-topics.sh --create --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181 --replication-factor 1 --partitions 1 --topic outScalingTopic
	
	# grafana metric
	prometheus/kube_hpa_status_current_replicas
	default/kafka_consumer_consumer_fetch_manager_metrics_records_lag

	# send kafka msg
	java -cp kafka-streams-scaling-all.jar kafka.streams.scaling.Sender localhost:9094
	
	## java -cp kafka-streams-scaling-all.jar kafka.streams.scaling.App localhost:9094
	
	
	# check topic state
	kafka-log-dirs.sh --bootstrap-server $MY_KAFKA_PORT_9092_TCP_ADDR:9092 --describe --topic-list inScalingTopic
	
	kafka-log-dirs.sh --bootstrap-server $MY_KAFKA_PORT_9092_TCP_ADDR:9092 --describe --topic-list outScalingTopic
	
	
## install mysql 

    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'abc';
	
	mysql -u root -p

	root password : abc
	
	# mysql connector

	ln -s /usr/share/java/mysql-connector-java.jar $HIVE_HOME/lib/mysql-connector-java.jar
	
	# DATABASE metastore and USER 'hive'
	
	CREATE DATABASE metastore;
    CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';
	ALTER  USER 'hive'@'%' IDENTIFIED WITH mysql_native_password BY 'hive';
    
    REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'hive'@'%';
    GRANT ALL PRIVILEGES ON metastore.* TO 'hive'@'%';
    FLUSH PRIVILEGES;
	
	# init schema
		
		# get latest https://repo1.maven.org/maven2/com/google/guava/guava/27.0-jre/guava-27.0-jre.jar
		# replace $HIVE_HOME/lib/guava-18.0-jre.jar with this one,
	
	$HIVE_HOME/bin/schematool -dbType mysql -initSchema
	
	# Start HiveServer2 service, Run the command below to start the HiveServer2 service:
	
	sudo /etc/init.d/ssh start
	
	$HADOOP_HOME/sbin/start-all.sh
	
	sudo /etc/init.d/mysql start

	nohup $HIVE_HOME/bin/hive --service metastore &
	
	nohup $HIVE_HOME/bin/hive --service hiveserver2 &
	
	beeline -u jdbc:hive2://localhost:10000 -n user
	
# create geo-hash UDF

add jar /home/alb/hive/GeohashHiveUDF-1.0-SNAPSHOT-jar-with-dependencies.jar;
add jar /home/alb/hive/phoenix-hive-4.2.0-jar-with-dependencies.jar;  
CREATE TEMPORARY FUNCTION GeohashEncode as 'com.github.gbraccialli.GeohashHiveUDF.UDFGeohashEncode';
CREATE TEMPORARY FUNCTION GeohashDecode as 'com.github.gbraccialli.GeohashHiveUDF.UDFGeohashDecode';

select GeohashEncode(40.91089,-111.40339, 4);	

	
## create weather_ext table
	
CREATE EXTERNAL TABLE weather_ext (
lng double, lat double, avg_tmpr_f double,
avg_tmpr_c double, wthr_date string) 
PARTITIONED BY (year int, month int, day int)
STORED AS PARQUET
LOCATION '/data/weather';
	

# add the directories as partitions
Msck repair table weather_ext;

select year,month,day,count(*) from weather_ext group by year,month,day ;

select * from weather_ext where year=2016 and month=10 and day=31 limit 3;
select * from weather_ext where year=2017 and month=8 and day=31 limit 3;
select * from weather_ext where year=2017 and month=9 and day=30 limit 3;

# create weather table and insert data with geo-hash (4 characters)

set hive.exec.dynamic.partition.mode=nonstrict;  # full dynamic partition or full static
set hive.exec.dynamic.partition=true;



CREATE TABLE weather (
  lng double, lat double, avg_tmpr_f double,
  avg_tmpr_c double, wthr_date string, geo string) 
  PARTITIONED BY (year int, month int, day int)
  stored as orc;

insert into weather PARTITION (year , month , day ) 
  select lng, lat , avg_tmpr_f , avg_tmpr_c , wthr_date , 
  GeohashEncode(lat, lng, 4) as geo, year , month , day 
  from weather_ext ;
  
# create weather_avg table and insert avg tempreture with geo-hash (4 characters)
  
set mapreduce.map.memory.mb=4096;  
SET mapreduce.reduce.memory.mb=4096; 
set mapred.reduce.tasks = 5; 

drop table weather_avg;
  
CREATE TABLE weather_avg (
  avg_tmpr_f double,  avg_tmpr_c double,  geo string) 
  PARTITIONED BY (year int, month int, day int)
  stored as orc;
  
insert into weather_avg PARTITION (year , month , day ) 
  select  avg(avg_tmpr_f) as avg_tmpr_f , avg(avg_tmpr_c) as avg_tmpr_c , geo , year , month , day 
  from weather group by year , month , day , geo;


# create hotel_ext table
CREATE EXTERNAL TABLE hotel_ext(Id string,Name string,Country string,City string,Address string,
  Latitude double,Longitude double)
  ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
  STORED AS TEXTFILE
  LOCATION '/data/hotels'
  tblproperties ("skip.header.line.count"="1");
  
select count(*) from hotel_ext;  


# create hotel table with year, month, day
create table hotel(Id string,Name string,Country string,City string,Address string,
  Latitude double,Longitude double, geo string )
  PARTITIONED BY (year int, month int, day int)
  stored as orc;
  
insert into hotel PARTITION (year=2016 , month=10 , day )
   select Id ,Name ,Country ,City ,Address , Latitude ,Longitude , GeohashEncode(Latitude ,Longitude, 4) as geo, day
   from hotel_ext LATERAL VIEW 
   explode(array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)) exp as day;
   
insert into hotel PARTITION (year=2017 , month=8 , day )
   select Id ,Name ,Country ,City ,Address , Latitude ,Longitude , GeohashEncode(Latitude ,Longitude, 4) as geo, day
   from hotel_ext LATERAL VIEW 
   explode(array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)) exp as day;

insert into hotel PARTITION (year=2017 , month=9 , day )
   select Id ,Name ,Country ,City ,Address , Latitude ,Longitude , GeohashEncode(Latitude ,Longitude, 4) as geo, day
   from hotel_ext LATERAL VIEW 
   explode(array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)) exp as day;
  
  
# create table hotel_with_weather

create table hotel_with_weather(Id string,Name string,Country string,City string,Address string,
  Latitude double,Longitude double, geo string, avg_tmpr_f double,  avg_tmpr_c double )
  PARTITIONED BY (year int, month int, day int)
  stored as orc;

select Id ,Name ,Country ,City ,Address , Latitude ,Longitude , a.geo, avg_tmpr_f, avg_tmpr_c , a.year, a.month, a.day 
   from hotel a left join weather_avg b 
   on a.year=b.year and a.month=b.month and a.day=b.day and a.geo=b.geo
   where a.year=2016 and a.month=10 
   limit 30;
   
insert into hotel_with_weather PARTITION (year=2016 , month=10 , day )
   select Id ,Name ,Country ,City ,Address , Latitude ,Longitude , a.geo, avg_tmpr_f, avg_tmpr_c , a.day 
   from hotel a left join weather_avg b 
   on a.year=b.year and a.month=b.month and a.day=b.day and a.geo=b.geo
   where a.year=2016 and a.month=10 ;
   
insert into hotel_with_weather PARTITION (year=2017 , month=8 , day )
   select Id ,Name ,Country ,City ,Address , Latitude ,Longitude , a.geo, avg_tmpr_f, avg_tmpr_c , a.day 
   from hotel a left join weather_avg b 
   on a.year=b.year and a.month=b.month and a.day=b.day and a.geo=b.geo
   where a.year=2017 and a.month=8 ;

insert into hotel_with_weather PARTITION (year=2017 , month=9 , day )
   select Id ,Name ,Country ,City ,Address , Latitude ,Longitude , a.geo, avg_tmpr_f, avg_tmpr_c , a.day 
   from hotel a left join weather_avg b 
   on a.year=b.year and a.month=b.month and a.day=b.day and a.geo=b.geo
   where a.year=2017 and a.month=9 ;

# create kafka topic : topicHotelWithWeather   

kafka-topics.sh --create --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181 --replication-factor 1 --partitions 6 --topic topicHotelWithWeather

# downlaod kafka-handler-3.1.3000.7.1.4.0-203.jar

wget https://repository.cloudera.com/artifactory/cloudera-repos/org/apache/hive/kafka-handler/3.1.3000.7.1.4.0-203/kafka-handler-3.1.3000.7.1.4.0-203.jar

add jar /home/alb/hive/kafka-handler-3.1.3000.7.1.4.0-203.jar;

hadoop dfs -put ./kafka-handler-3.1.3000.7.1.4.0-203.jar  /home/alb/hive/

# create external table moving_hotel_weather_kafka_hive
  
  --  "kafka.serde.class"="org.apache.hadoop.hive.serde2.avro.AvroSerDe"
  
CREATE EXTERNAL TABLE IF NOT EXISTS moving_hotel_weather_kafka_hive 
  (Id string,Name string,Country string,City string,Address string, Latitude double,Longitude double, 
  geo string, avg_tmpr_f double,  avg_tmpr_c double, year int, month int, day int )
  STORED BY 'org.apache.hadoop.hive.kafka.KafkaStorageHandler'
  TBLPROPERTIES( 
    "kafka.topic" = "topicHotelWithWeather",
    "kafka.bootstrap.servers"="localhost:9094"
  );

insert into moving_hotel_weather_kafka_hive
   select  id, name, country, city, address, latitude, longitude, geo, avg_tmpr_f, avg_tmpr_c, year, month, day, 
   null AS `__key`, null AS `__partition`, -1 AS `__offset`, -1 AS `__timestamp`
   from hotel_with_weather order by year, month, day;
   
# hive homework

# task1 get schema

	java -jar avro-tools-1.10.1.jar getschema $avro-file

# create external table expedia

create external table expedia_ext (id BIGINT ,date_time string,site_name int,posa_continent int,
   user_location_country int,user_location_region int,user_location_city int,orig_destination_distance double,
   user_id int,is_mobile int,is_package int,channel int,srch_ci string,srch_co string,srch_adults_cnt int,
   srch_children_cnt int,srch_rm_cnt int,srch_destination_id int,srch_destination_type_id int,hotel_id BIGINT )
   STORED AS avro
   LOCATION '/data/expedia';
   
# Top 10 hotels with max absolute temperature difference by month.

create view view_hotel_with_tmpr as 
  select distinct id, year, month, max(avg_tmpr_c) over (PARTITION BY year, month, id) AS max_tmpr_c,
  min(avg_tmpr_c) over (PARTITION BY year, month, id) AS min_tmpr_c
  from moving_hotel_weather_kafka_hive; 

select * from (
  select id, year, month, diff_tmpr_c, rank() over (PARTITION BY year, month ORDER BY diff_tmpr_c DESC) as ranking
  from (
    select id, year, month, max_tmpr_c,min_tmpr_c, (max_tmpr_c - min_tmpr_c) as diff_tmpr_c from view_hotel_with_tmpr 
  ) a 
) b where ranking<=10;


# top 10 vist hotel,

create view IF NOT EXISTS hotel_visit_view partitioned on (year, month) as
 select  c.srch_ci,c.srch_co,c.hotel_id, c.user_id, year(c.new_date) as year, month(c.new_date) as month from
  (select b.*, date_add(b.srch_ci, b.i) as new_date from (
    select a.id , a.srch_ci , a.srch_co , a.hotel_id,  a.user_id , exp.i 
    from expedia_ext a 
    lateral view posexplode(split(space(datediff(a.srch_co, a.srch_ci)),' ')) exp as i, val
  ) b
) c;


select * from 
(select year, month, hotel_id , vist_count, ROW_NUMBER() over (PARTITION BY year, month ORDER BY vist_count desc) as ranking
  from (
  select a.year, a.month, a.hotel_id, count(*) as vist_count
  from hotel_visit_view a
  group by a.year, a.month, a.hotel_id
) b
) c where ranking<=10;

# For visits with extended stay (more than 7 days) calculate weather trend

## view of expedia with more than 7-day duration

drop view expedia_7day_view;

create view IF NOT EXISTS expedia_7day_view partitioned on (year, month, day) as
 select c.id, c.srch_ci,c.srch_co, c.diff, c.hotel_id, c.user_id, year(c.new_date) as year, month(c.new_date) as month , day(c.new_date) as day 
 from
  (select b.*, date_add(b.srch_ci, b.i) as new_date from (
    select a.id , a.srch_ci , a.srch_co, datediff(a.srch_co, a.srch_ci) as diff , a.hotel_id,  a.user_id , exp.i 
      from expedia_ext a 
      lateral view posexplode(split(space(datediff(a.srch_co, a.srch_ci)),' ')) exp as i, val
    ) b where diff>=7
  ) c;

select * from expedia_7day_view a limit 20;

## view with extract field yyyy-mm-dd on moving_hotel_weather data-set
drop view moving_hotel_weather_view;

create view IF NOT EXISTS moving_hotel_weather_view partitioned on (year, month, day) as
  select id as hotel_id, avg_tmpr_c, cast(concat_ws('-', cast(year as string), cast(month as string), cast(day as string)) as date) as mydate, 
   year, month, day from moving_hotel_weather_kafka_hive;

select * from moving_hotel_weather_view a limit 20;


## table stored temperature for each day when user stay at hotel 
drop table extended_stay_weather_tab;

create table extended_stay_weather_tab (id BIGINT,srch_ci string, srch_co string, diff int, 
  hotel_id BIGINT,user_id BIGINT, avg_tmpr_c double, mydate string, day int)
  PARTITIONED BY (year int, month int )
  CLUSTERED BY (id) SORTED BY (day) into 10 BUCKETS
  stored as orc;

insert into extended_stay_weather_tab
  select a.id, a.srch_ci, a.srch_co, a.diff, a.hotel_id, a.user_id, b.avg_tmpr_c, b.mydate, a.day , a.year, a.month
  from expedia_7day_view a 
  left join moving_hotel_weather_view b
  on a.hotel_id=b.hotel_id and a.year=b.year and a.month=b.month and a.day=b.day;
  
  
## query temperature trend and AVG for each time duration between checkin and checkout
select distinct srch_ci, srch_co, id, user_id, hotel_id,  
  (last_tmpr-first_tmpr) as temperature_diff,
  avg_tmpr as temperature_avg
  from (
    select year, month, day, srch_ci, srch_co, id, user_id, hotel_id, avg_tmpr_c,
      FIRST_VALUE(avg_tmpr_c) over w1 as first_tmpr, 
      LAST_VALUE(avg_tmpr_c) over w1 as last_tmpr, 
      AVG(avg_tmpr_c) over w1 as avg_tmpr
      from extended_stay_weather_tab
      WINDOW w1 AS (PARTITION BY year, month, id ORDER BY day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
  ) x where first_tmpr is not null and last_tmpr is not null and avg_tmpr is not null
  limit 50; 

  
# install spark spark-3.1.1-bin-hadoop3.2.tgz
export SPARK_HOME=/XXX/XXX
export PATH=...:SPARK_HOME/bin:...


# intellj spark maven lib

org.apache.spark:spark-core_2.12:3.1.1
org.apache.spark:spark-sql_2.12:3.1.1

# intellj sbt spark lib 

// https://mvnrepository.com/artifact/org.apache.spark/spark-core
libraryDependencies += "org.apache.spark" %% "spark-core" % "3.1.1"

// https://mvnrepository.com/artifact/org.apache.spark/spark-sql
libraryDependencies += "org.apache.spark" %% "spark-sql" % "3.1.1"

