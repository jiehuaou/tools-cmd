# init schema
		
 ## get latest https://repo1.maven.org/maven2/com/google/guava/guava/27.0-jre/guava-27.0-jre.jar
 ## replace $HIVE_HOME/lib/guava-18.0-jre.jar with this one,
	
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

############## create external table with single text  ############

hdfs dfs -mkdir /company
hdfs dfs -mkdir /company/emp

## Change the Owner of a File

	chown <new-owner>  filename*.ext

hdfs dfs -put   /opt/hive/examples/files/emp.txt /company/emp/emp1  

CREATE EXTERNAL TABLE IF NOT EXISTS emp(
  eName STRING, id1 int, id2 int)
  COMMENT 'emp Names'
  ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '|'
  STORED AS TEXTFILE
  LOCATION '/company/emp';   ## use folder
  


  
############## create partition external table with multiply text  ############


hdfs dfs -mkdir /emp
hdfs dfs -mkdir /emp/region=north
hdfs dfs -mkdir /emp/region=south

hdfs dfs -put   /opt/hive/examples/files/emp-north.txt /emp/region=north/data.txt
hdfs dfs -put   /opt/hive/examples/files/emp-south.txt /emp/region=south/data.txt

drop table emp_parti;

CREATE EXTERNAL TABLE IF NOT EXISTS emp_parti(
  eName STRING, id1 int, id2 int)
  COMMENT 'emp Names'
  partitioned by (region string)
  ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '|'
  STORED AS TEXTFILE
  LOCATION '/unknow';

## use folder   
alter table emp_parti add partition (region ='south') location '/emp/region=south';  
alter table emp_parti add partition (region ='north') location '/emp/region=north';

select region, avg(id1) from emp_parti group by region;


######## create static partition table #########

drop TABLE monitor;

hdfs dfs -mkdir /monitor

CREATE TABLE monitor (serial STRING, key STRING, data1 STRING, data2 STRING, data3 STRING)
   PARTITIONED BY (size STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
   location '/monitor';

LOAD DATA LOCAL INPATH '/opt/hive/examples/files/monitor1.csv' OVERWRITE INTO TABLE monitor PARTITION (size='1680x720');
LOAD DATA LOCAL INPATH '/opt/hive/examples/files/monitor2.csv' OVERWRITE INTO TABLE monitor PARTITION (size='1920x1080');

select * from monitor where size='1680x720' limit 10;
select * from monitor where size='1920x1080' limit 10;
(select * from monitor where size='1920x1080' limit 10) union (select * from monitor where size='1680x720' limit 10);

######## create static partition table with bucket #########

drop TABLE monitor_bk;
drop TABLE tmp_monitor_bk;

hdfs dfs -mkdir /monitor_bk

CREATE TABLE monitor_bk (serial STRING, key STRING, data1 STRING, data2 STRING, data3 STRING)
   PARTITIONED BY (size STRING) clustered by (key) into 4 buckets
   stored as parquet
   location '/monitor_bk';
   
CREATE TEMPORARY TABLE tmp_monitor_bk (serial STRING, key STRING, data1 STRING, data2 STRING, data3 STRING, size STRING)
   ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/opt/hive/examples/files/monitor1.csv' INTO TABLE tmp_monitor_bk;
LOAD DATA LOCAL INPATH '/opt/hive/examples/files/monitor2.csv' INTO TABLE tmp_monitor_bk;

set hive.enforce.bucketing = true;
set hive.exec.dynamic.partition.mode=nonstrict;  ## dynamic partition require

## clear and insert
INSERT OVERWRITE TABLE monitor_bk PARTITION (size) select * from tmp_monitor_bk;

INSERT OVERWRITE TABLE monitor_bk PARTITION (size='1680x720') select serial , key , data1 , data2 , data3 from tmp_monitor_bk;

INSERT INTO monitor_bk PARTITION(size='80x480') (serial , key , data1 , data2 , data3)  VALUES ('86238762387', '8236632', '111', '2222', '333');

## just insert
INSERT into      TABLE monitor_bk PARTITION (size) select * from tmp_monitor_bk;

select * from monitor_bk where size='1680x720' limit 10;
select * from monitor_bk where size='1920x1080' limit 10;
(select * from monitor_bk where size='1920x1080' limit 10) union (select * from monitor_bk where size='1680x720' limit 10);
select * from monitor_bk where key='38013716626905304' and size='1680x720' ; 

create table monitor_bk_ex like monitor_bk;

  
  
##### create like #########

create table emp2 like emp_parti;  

ALTER TABLE emp2 ADD COLUMNS (k1 Varchar(10));

set hive.exec.dynamic.partition.mode=nonstrict;

insert into emp2 partition (region) select eName , id1 , id2, (case 
when id2=1 then 'a'
when id2=2 then 'b'
when id2=3 then 'c'
when id2=4 then 'd'
when id2=5 then 'e'
when id2=6 then 'f'
else 'x' end),  region from emp_parti;

CREATE TEMPORARY TABLE tmp_param(key string, value string);

insert into tmp_param values('p1', '5');

create view emp_view as select * from emp2 where id2 in (select int(value) from tmp_param where key='p1');

##### create orc table ####

create table orc_tab(userid bigint, string1 string, subtype double, decimal1 decimal(38,10),ts timestamp) stored as orc;

LOAD DATA INPATH '/orcdata/orc_split_elim.orc' INTO TABLE orc_tab;

select count(1), userid from orc_tab group by userid;

create table orc_tab(userid bigint, string1 string, subtype double, decimal1 decimal(38,10),ts timestamp) stored as orc;

##### table support ACID #######

CREATE TABLE students (name VARCHAR(64), age INT, gpa DECIMAL(3, 2))
   CLUSTERED BY (age) INTO 2 BUCKETS STORED AS orc 
   TBLPROPERTIES ('transactional' = 'true'); 

set hive.support.concurrency = true;
set hive.enforce.bucketing = true;
set hive.exec.dynamic.partition.mode = nonstrict;
set hive.txn.manager =org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;
set hive.compactor.initiator.on = true;
set hive.compactor.worker.threads = 1;

INSERT INTO TABLE students VALUES 
   ('fred', 35, 1.28), ('barney', 32, 2.32);
   
update students set gpa = 1.55 where name = 'fred' ;
   
########## group by , Grouping , Rollup and Cube ##########

create table tab1 (a string, b string, c int) ;

insert into table tab1 values ('a1', 'b1', 1), ('a1', 'b2', 1), ('a1', 'b3', 1);
insert into table tab1 values ('a2', 'b1', 1), ('a2', 'b2', 1), ('a2', 'b3', 1);
insert into table tab1 values ('a3', 'b1', 1), ('a3', 'b2', 1), ('a3', 'b3', 1);

# new syntex
insert into table tab1 select 'a3', 'b1', 1 union all select 'a3', 'b2', 1;

# create table employee #
create table salaryperyear(employee string, year int, salary double);

insert into table salaryperyear select  'charles',2016,5.5 union select 'charles',2017,7.5;
insert into table salaryperyear select  'scott',  2016,3.8 union select 'scott',  2017,4.9;
insert into table salaryperyear select  'jean',   2016,4.2 union select 'jean',   2017,9.1;

  ## output to local folder
  
from salaryperyear INSERT OVERWRITE LOCAL DIRECTORY '/tmp/employee' 
  row format delimited fields terminated by ','
  select employee , year , salary  ;
   
insert overwrite local directory '/tmp/hello'
  row format delimited
  fields terminated by '|'
  select * from salaryperyear;

  

## GROUPING SETS, redefine the grouping combination ##

SELECT a, b, SUM(c) FROM tab1 GROUP BY a, b GROUPING SETS ( (a,b) );	

SELECT a, b, SUM( c ) FROM tab1 GROUP BY a, b GROUPING SETS ( (a,b), a);

SELECT a,b, SUM( c ) FROM tab1 GROUP BY a, b GROUPING SETS (a,b);
	
SELECT a, b, SUM( c ) FROM tab1 GROUP BY a, b GROUPING SETS ( (a, b), a, b, ( ) );

## GROUPING__ID, bitvector [0,0] [1,0], [0,1]

SELECT a, b, SUM(c), GROUPING__ID FROM tab1 GROUP BY a, b with ROLLUP ;

## GROUPING () , 0 is part of the grouping set ##

SELECT a, b, SUM(c), GROUPING__ID, grouping(a), grouping(b) FROM tab1 GROUP BY a, b with ROLLUP ;

## Cubes and Rollups
## GROUP BY a, b, c WITH CUBE = GROUP BY a, b, c GROUPING SETS ( (a, b, c), (a, b), (b, c), (a, c), (a), (b), (c), ( )).

SELECT a, b, SUM(c), GROUPING__ID, grouping(a), grouping(b) FROM tab1 GROUP BY a, b with cube ;


########### Order By & Sort By 
########### "Order by " guarantees total order in the output
########### "Sort By " only guarantees ordering of the rows within a reducer.

select * from emp_parti sort by id2;

select * from emp_parti order by id2;

########  cluster by & CLUSTER BY ########

## Distribute BY x: ensures each reducers gets non-overlapping ranges of x, not sort the output 
## Cluster BY x:    ensures each reducers gets non-overlapping ranges, then sorts 

## Cluster By = Distribute By + Sort By

########  join ##########

CREATE TABLE a (k1 string, v1 string);
CREATE TABLE b (k2 string, v2 string);

insert into a values('a', 'aaa-a'), ('b', 'bbb-a');
insert into b values('b', 'bbb-b'), ('c', 'ccc-b');

select * from a [inner] join b on k1=k2;
+-------+--------+-------+--------+
| a.k1  |  a.v1  | b.k2  |  b.v2  |
+-------+--------+-------+--------+
| b     | bbb-a  | b     | bbb-b  |
+-------+--------+-------+--------+

select * from a left join b on k1=k2;
+-------+--------+-------+--------+
| a.k1  |  a.v1  | b.k2  |  b.v2  |
+-------+--------+-------+--------+
| a     | aaa-a  | NULL  | NULL   |
| b     | bbb-a  | b     | bbb-b  |
+-------+--------+-------+--------+

select * from a right join b on k1=k2;
+-------+--------+-------+--------+
| a.k1  |  a.v1  | b.k2  |  b.v2  |
+-------+--------+-------+--------+
| b     | bbb-a  | b     | bbb-b  |
| NULL  | NULL   | c     | ccc-b  |
+-------+--------+-------+--------+

select * from a full join b on k1=k2;
+-------+--------+-------+--------+
| a.k1  |  a.v1  | b.k2  |  b.v2  |
+-------+--------+-------+--------+
| a     | aaa-a  | NULL  | NULL   |
| b     | bbb-a  | b     | bbb-b  |
| NULL  | NULL   | c     | ccc-b  |
+-------+--------+-------+--------+


set hive.strict.checks.cartesian.product = false;

select * from a cross join b ;          ## all possible combination
+-------+--------+-------+--------+
| a.k1  |  a.v1  | b.k2  |  b.v2  |
+-------+--------+-------+--------+
| a     | aaa-a  | b     | bbb-b  |
| b     | bbb-a  | b     | bbb-b  |
| a     | aaa-a  | c     | ccc-b  |
| b     | bbb-a  | c     | ccc-b  |
+-------+--------+-------+--------+


################ hint #############

## streamtble : using very large tables as a stream

select /*+ streamtable(t1)*/ * from emp2 t1 join a t2 on t1.k1=t2.k1;

## mapjoin : cache small tables in memory

select /*+ mapjoin(t2)*/ * from emp2 t1 join a t2 on t1.k1=t2.k1;

########## Joins occur before Where Clause #############

create table documents (id int, name string);
insert into  documents values (1     , 'Document1')   ,
     ( 2     , 'Document2')   ,
     ( 3     , 'Document3')   ,
     ( 4     , 'Document4')   ,
     ( 5     , 'Document5' );

create table downloads (id int, document_id int,  username string);
insert into  downloads values (1    , 1             , 'sandeep')  ,
      (2    , 1             , 'simi'     ),
      (3    , 2             , 'sandeep'  ),
      (4    , 2             , 'reya'     ),
      (5    , 3             , 'simi' );

## on ... where ...

SELECT documents.name, downloads.id
    FROM documents  LEFT OUTER JOIN downloads
      ON documents.id = downloads.document_id
    WHERE username = 'sandeep' ;
+-----------------+---------------+
| documents.name  | downloads.id  |
+-----------------+---------------+
| Document1       | 1             |
| Document2       | 3             |
+-----------------+---------------+

## on ... and ...

SELECT documents.name, downloads.id
  FROM documents    LEFT OUTER JOIN downloads
      ON documents.id = downloads.document_id
        AND username = 'sandeep' ;
+-----------------+---------------+
| documents.name  | downloads.id  |
+-----------------+---------------+
| Document1       | 1             |
| Document2       | 3             |
| Document3       | NULL          |
| Document4       | NULL          |
| Document5       | NULL          |
+-----------------+---------------+

######### LEFT SEMI JOIN implements the IN/EXISTS subquery semantics in an efficient way.	####

SELECT a.key, a.value FROM a WHERE a.key in (SELECT b.key FROM B);

## can be rewritten to ==>

SELECT a.key, a.val FROM a LEFT SEMI JOIN b ON (a.key = b.key);


# Top K sample

CREATE TABLE t_employee (id INT, emp_name VARCHAR(20), dep_name VARCHAR(20),
salary DECIMAL(7, 2), age DECIMAL(3, 0));

INSERT INTO t_employee VALUES
( 1,  'Matthew', 'Management',  4500, 55),
( 2,  'Olivia',  'Management',  4400, 61),
( 3,  'Grace',   'Management',  4000, 42),
( 4,  'Jim',     'Production',  3700, 35),
( 5,  'Alice',   'Production',  3500, 24),
( 6,  'Michael', 'Production',  3600, 28),
( 7,  'Tom',     'Production',  3800, 35),
( 8,  'Kevin',   'Production',  4000, 52),
( 9,  'Elvis',   'Service',     4100, 40),
(10,  'Sophia',  'Sales',       4300, 36),
(11,  'Samantha','Sales',       4100, 38);

## give rank on salary for each department
SELECT dep_name, emp_name, salary
    ,RANK() OVER (PARTITION BY dep_name ORDER BY salary DESC) AS rnk
  FROM t_employee;

## show top 2 salary
SELECT dep_name, emp_name, salary, rnk
FROM (
  SELECT
    dep_name, emp_name, salary
    ,RANK() OVER (PARTITION BY dep_name ORDER BY salary DESC) AS rnk
  FROM t_employee
) a
WHERE rnk <= 2;

# Window Query Concepts
## SQL window query introduces three concepts, namely window partition, window frame and window function.

table {
	result-set {
		partition 1 {
			{frame1} 
			{frame2}
			...
		}
		...
	}
	...
}

** PARTITION ** clause divides result-set into window partitions by one or more columns, optionally sorted by one or more columns.
	 If there’s not PARTITION BY, the entire result-set is treated as a single partition; 
	 if there’s not ORDER BY, window frames cannot be defined, and all rows within the partition constitutes a single frame.

** Window frame ** selects rows from partition for window function to work on. 

** window functions ** compute results on the current frame. Hive supports the following functions:

	1. FIRST_VALUE(col), LAST_VALUE(col) returns the column value of first / last row within the frame;
	2. LEAD(col, n), LAG(col, n) returns the column value of n-th row before / after current row;
	3. RANK(), ROW_NUMBER() assigns a sequence of the current row within the frame. The difference is RANK() will contain duplicate 
	   if there’re identical values.
	4. COUNT(), SUM(col), MIN(col) works as usual.
	
	