# start zookeeper & kafka

 ./bin/zookeeper-server-start.sh  ./config/zookeeper.properties
 
 ./bin/kafka-server-start.sh     ./config/server.properties


## create kafka topic
```
	kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic mytopic1
	
	kafka-topics.sh --create --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181 --replication-factor 1 --partitions 1 --topic mytopic1
	
	kafka-topics.sh --create --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181 --replication-factor 1 --partitions 6 --topic inScalingTopic2
	
	kafka-topics.sh --create --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181 --replication-factor 1 --partitions 10 --topic topicHotelWithWeather
	
```
	
## list topic

	./bin/kafka-topics.sh --list --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181
	
	./bin/kafka-topics.sh --zookeeper localhost:2181 --describe --topic mytopic1
	
## describe topic Config

    kafka-topics.sh --bootstrap-server   10.100.90.35:9092 --describe --topic mytopic1	
	
	./bin/kafka-topics.sh --bootstrap-server   localhost:9092 --describe --topic mytopic3	

## describe topic log info [folder, size, offsetLag ...]

	./bin/kafka-log-dirs.sh --bootstrap-server localhost:9092 --describe --topic-list mytopic3
	
## see kafka topic partition size

    kafka-log-dirs.sh --describe --bootstrap-server server_ip:9092 --topic-list mytopic1
	kafka-log-dirs.sh --describe --bootstrap-server $MY_KAFKA_PORT_9092_TCP_ADDR:9092 --topic-list topicHotelWithWeather
	
## Delete topic
	
	./bin/kafka-topics.sh --zookeeper localhost:2181 --delete --topic mytopic1
          kafka-topics.sh --zookeeper $MY_KAFKA_ZOOKEEPER_SERVICE_HOST:2181 --delete --topic inScalingTopic
	
## Run Kafka Producer Console

	./bin/kafka-console-producer.sh --broker-list ambari.hadoop:6667 --topic mytopic1
	
	kafka-console-producer.sh --broker-list $MY_KAFKA_PORT_9092_TCP_ADDR:9092 --topic mydata
	
## Run kafka-consumer-console.sh

	./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic mytopic3
	
	
	kafka-topics.sh --zookeeper 10.107.159.178:2181 --describe --topic mytopic1
	kafka-log-dirs.sh --describe --bootstrap-server 10.100.90.35:9092 --topic-list mytopic1
	
	kafka-console-consumer.sh --topic mytopic1 --from-beginning --bootstrap-server $MY_KAFKA_PORT_9092_TCP_ADDR:9092
	
	kafka-console-consumer.sh --topic mydata --from-beginning --bootstrap-server $MY_KAFKA_PORT_9092_TCP_ADDR:9092
	
## change topic retention time to purge data, 
	## To purge the Kafka topic, you need to change the retention time of that topic. 
	## The default retention time is 168 hours, i.e. 7 days. 
	## So, you have to change the retention time to 1 second, 
	## after which the messages from the topic will be deleted. 
	## Then, you can go ahead and change the retention time of the topic back to 168 hours.
	
	## 1 second
	kafka-topics.sh --zookeeper 10.107.159.178:2181 --alter --topic mytopic1 --config retention.ms=1000
	
	## 7 days
	kafka-topics.sh --zookeeper 10.107.159.178:2181 --alter --topic mytopic1 --config retention.ms=604800000
	
## List the topics to which the group is subscribed
./bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group group1 --describe

./bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --all-groups --describe

## Reset the consumer offset for a topic (preview)
./bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group group1 --topic mytopic3 --reset-offsets --to-earliest

## Reset the consumer offset for a topic (execute)
./bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group group1 --topic mytopic3 --reset-offsets --to-earliest --execute

./bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group group1 --topic mytopic3 --reset-offsets --to-offset 10 --execute
