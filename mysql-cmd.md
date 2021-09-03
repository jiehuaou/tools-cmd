# start & stop

sudo /etc/init.d/mysql start 
sudo /etc/init.d/mysql stop 
sudo /etc/init.d/mysql restart 


net stop MySQL80 
net start MySQL80


# login with root, mysql -u [username] -p

mysql -u root -p

root password : abc

# init 

CREATE DATABASE hello;

# create user
CREATE USER 'db_user'@'localhost' IDENTIFIED BY 'Aou@8899';

# alter password
alter user 'db_user'@'localhost' IDENTIFIED BY 'abc';

# GRANT type_of_permission ON database_name.table_name TO 'username'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'db_user'@'localhost' ;

FLUSH PRIVILEGES;

# show user PRIVILEGES
SHOW GRANTS FOR 'db_user'@'localhost';


# drop user
DROP USER 'username'@'localhost';

# show table
SHOW TABLES;

## new user

CREATE USER 'db_user2'@'localhost' IDENTIFIED BY 'abc';
alter user 'db_user2'@'localhost' IDENTIFIED BY 'abc';
GRANT ALL PRIVILEGES ON *.* TO 'db_user2'@'localhost' ;
GRANT ALL ON *.* TO 'db_user2'@'localhost' ;
FLUSH PRIVILEGES;


# create table

Field Attribute **NOT NULL** is being used because we do not want this field to be NULL. So, if a user will try to create a record with a NULL value, then MySQL will raise an error.

Field Attribute **AUTO_INCREMENT** tells MySQL to go ahead and add the next available number to the id field.

Keyword ** PRIMARY KEY ** is used to define a column as a primary key. You can use multiple columns separated by a comma to define a primary key.

```
DROP TABLE IF EXISTS emp;

CREATE TABLE emp (
  id INT AUTO_INCREMENT  PRIMARY KEY,
  version INT DEFAULT 1,
  first_name VARCHAR(250) NOT NULL,
  last_name VARCHAR(250) NOT NULL,
  career VARCHAR(250) DEFAULT NULL,
  tel VARCHAR(50) DEFAULT NULL,
  addr VARCHAR(50) DEFAULT NULL,
  data double default 0,
  dep_id int DEFAULT NULL
);

insert into emp (first_name, last_name, career, tel, addr, dep_id) values('first1', 'last1', 'writer', '1231', 'CA', 1);
insert into emp (first_name, last_name, career, tel, addr, dep_id) values('first2', 'last2', 'writer', '1232', 'CA', 1);
insert into emp (first_name, last_name, career, tel, addr, dep_id) values('first3', 'last3', 'writer', '1233', 'CA', 1);
insert into emp (first_name, last_name, career, tel, addr, dep_id) values('first4', 'last4', 'writer', '1234', 'CA', 2);
insert into emp (first_name, last_name, career, tel, addr, dep_id) values('first5', 'last5', 'writer', '1235', 'CA', 2);

insert into emp (first_name, last_name, career, tel, addr, dep_id) values('first6', 'last6', 'reader', '1236', 'CA', 5);


commit;


DROP TABLE IF EXISTS dep;

CREATE TABLE dep(
  id INT PRIMARY KEY,
  VERSION INT DEFAULT 1,
  dep_name VARCHAR(50) NOT NULL ,
  leader  VARCHAR(50)
);

insert into dep (id, dep_name, leader) values(1, 'sport', 'John');
insert into dep (id, dep_name, leader) values(2, 'Motor', 'Jeff');

commit;

```


