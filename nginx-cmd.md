
## install nginx

sudo yum install nginx

## Nginx does not start on its own. To get Nginx running, type:

	sudo systemctl start nginx

	# or
	
	sudo service nginx {stop|start|restart}

## If you are running a firewall, run the following commands to allow HTTP and HTTPS traffic:

sudo firewall-cmd --permanent --zone=public --add-service=http 
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload

## You will see the default CentOS 7 Nginx web page,

http://server_domain_name_or_IP/

##  enable Nginx to start when your system boots. 

sudo systemctl enable nginx

## The default server root directory is 

	/usr/share/nginx/html
	
## The main Nginx configuration file is located at 

	/etc/nginx/nginx.conf	
	
## prod_sz home

	/home/ec2-user/apps/dynamicform/dynamic-form-frontend/prod_sz
	
	https://ec2-54-223-33-81.cn-north-1.compute.amazonaws.com.cn:9100/
	http://ec2-54-223-33-81.cn-north-1.compute.amazonaws.com.cn:9100/
	
## copy cert into linux

scp ./ec2-54-222-208-228.* ec2-user@ec2-54-223-33-81.cn-north-1.compute.amazonaws.com.cn:/home/ec2-user/certs
	
	