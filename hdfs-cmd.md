# startup hadoop

sudo /etc/init.d/ssh start

$HADOOP_HOME/sbin/start-all.sh

jps # show status

## web UI

	http://localhost:9870

## login
ssh root@sandbox-hdp.hortonworks.com -p 2222		  

## copy files		  
scp -P 2222  expedia.zip root@sandbox-hdp.hortonworks.com:/usr/myfold
scp -P 2222  weather.zip root@sandbox-hdp.hortonworks.com:/usr/myfold
scp -P 2222  hotels.zip root@sandbox-hdp.hortonworks.com:/usr/myfold

## make hdfs folder
sudo -u hdfs  hdfs dfs -mkdir /expedia
sudo -u hdfs  hdfs dfs -mkdir /expedia
sudo -u hdfs  hdfs dfs -mkdir /hotels

## change files owner to hdfs

chown    hdfs    expedia/files*.avro
chown -R hdfs    weather/*.parquet
chown    hdfs    hotels/*.csv

## dfs create dir

bin/hdfs dfs -mkdir /weather

## dfs delete all from specified folder

hadoop dfs -rm -r -skipTrash /data/weather/*

## copy files to HDFS 

 # create folder /data/weather then copy file
 hdfs dfs -put weather  /data

 hdfs dfs -put ./*.avro /data/expedia


## get parquet schema

java -jar parquet-tools-1.8.0.jar schema /folder/part-00140.parquet

## get AVRIO schema

java -jar avro-tools-1.8.2.jar getschema  /folder/part-00140.parquet

## get one avro file count

bin/hadoop jar ~/hello/avro-tools-1.10.1.jar count /data/expedia/part-00000-ef2b800c-0702-462d-b37f-5f2fb3a093d0-c000.avro

## counting on folder, remove any non-data file first.

	bin/hadoop dfs -rm -f /data/expedia/_SUCCESS

bin/hadoop jar ~/hello/avro-tools-1.10.1.jar count /data/expedia

bin/hadoop dfs -put -f /mnt/d/bigdata-homework/data-flow-homework/hotels/part-00000-7b2b2c30-eb5e-4ab6-af89-28fae7bdb9e4-c000.csv    /data/hotels

