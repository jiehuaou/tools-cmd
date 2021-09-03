

# Step 11: now move this folder to /usr/local or $home, where you want. A safe place for it.

``` 
	mv apache-tez-0.10.0-bin /usr/local
```
 
# tez-src build, pom.xml
```
<hadoop.version>3.2.1</hadoop.version>
...
<dependency>
    <groupId>com.google.guava</groupId>
    <artifactId>guava</artifactId>
    <version>23.6-jre</version>  
</dependency>


mvn clean package -DskipTests=true -Dmaven.javadoc.skip=true

```

# Step 10: Now, untar the file using the below command:
```
mkdir ~/hadoop/tez-0.9.2-SNAPSHOT/

tar -xvzf tez-0.9.2.tar.gz  --directory ~/hadoop/tez-0.9.2-SNAPSHOT/
```
 
# make a new directory in hdfs and copy this untared tez folder to there.
``` 
 hdfs dfs -mkdir -p /apps/tez-0.9.2-SNAPSHOT/
 
 hadoop fs -put tez-0.9.2.tar.gz  /apps/tez-0.9.2-SNAPSHOT/tez-0.9.2.tar.gz
```


# config $HADOOP_HOME/etc/hadoop/tez-site.xml
```
 <property>  
    <name>tez.container.max.java.heap.fraction</name>   
    <value>0.2</value>  
    <description> by albert</description>
  </property>  

  <property>
    <name>tez.lib.uris</name>
    <value>${fs.defaultFS}/apps/tez-0.9.2-SNAPSHOT/tez-0.9.2.tar.gz</value>  
    <description>String value to a file path. </description>
    <type>string</type>
  </property> 
```

# config hadoop-env.sh
```
export TEZ_CONF_DIR=/home/alb/hadoop/hadoop-3.2.1/etc/hadoop/tez-site.xml
export TEZ_JARS=/home/alb/hadoop/tez-0.9.2-SNAPSHOT
export HADOOP_CLASSPATH=${TEZ_CONF_DIR}:${TEZ_JARS}/*:${TEZ_JARS}/lib/*:${HADOOP_CLASSPATH}:${JAVA_JDBC_LIBS}:${MAPREDUCE_LIBS}
```
 
# test to see if the installation is successful

echo "Hello World Hello Tez" > file01
echo "Hello World Goodbye tez" > file02 
Hadoop fs -mkdir -p /data/tez_input
hadoop fs -put file01 file02 /data/tez_input

hadoop jar tez-examples-0.9.2.jar orderedwordcount /data/tez_input /data/tez_output

# test tez engine

Set hive.execution.engine=tez;

select count(*) from sample;
