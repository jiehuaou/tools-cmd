

#default admin user

    postgres  /  abc
	
# create database

	create schema hello;

# create user

	create user db_user with ENCRYPTED password 'abc'; 

	alter user db_user with ENCRYPTED password 'abc'; 

	GRANT ALL PRIVILEGES ON DATABASE hello TO db_user;
	