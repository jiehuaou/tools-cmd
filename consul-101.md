## install consul in Win10 cmd (with Administrator role)

choco install consul

## consul cmd start ##

consul agent -dev -node machine1

## consul put KV with python  ##

// pip install python-consul
>>> import consul
>>> c = consul.Consul()
>>> c.kv.put("qqq", "hello world")
>>> c.kv.put("www/abc", "wiki")

## consul cmd put KV  ##

consul kv put redis/config/desc "hello world"

consul kv put data1 "hello world"

## consul cmd import KV json ##
``` data.json
[
  {
    "Key": "app1/path/key",
    "Value": "base64_273yuqwytwq2372=="
  },
  {
    "Key": "app1/path/key2",
    "Value": "base64_273yuqwytwq2372="
  }
]
```

consul.exe kv import @data.json

## consul config folder and key/value ##

http://127.0.0.1:8500/ui/dc1/kv

    config/data-service-1
        foo : world

    config/data-service-1/aws
        user : xxx
        password : yyyy
        sample : zzz

consul kv put "config/data-service-1/foo" "world"

consul kv put "config/data-service-1/aws/user"      "abc"
consul kv put "config/data-service-1/aws/password"  "123456+"
consul kv put "config/data-service-1/aws/sample"    "dynamo-db"

## @RefreshScope ##

    help refresh the values in client when they are changed in consul.


## consul DiscoveryClient ##

    discovery the available services such as Netflix Eureka or Consul.

## launch service svc in discovery-service/target

java -jar -Dserver.port=8080  service-0.0.1-SNAPSHOT.jar --label=pod-1

java -jar -Dserver.port=8081  service-0.0.1-SNAPSHOT.jar --label=pod-2

## launch client svc in discovery-client/target

java -jar -Dserver.port=8088  client-0.0.1-SNAPSHOT.jar 

## test call from client to service

curl http://localhost:8088/another-id

>>/id:hello:app1
>>/id:hello:app2
>>/id:hello:app1
>>/id:hello:app2
...

## consul web UI

    http://localhost:8500/

## generate key

   consul keygen
   
   * KWM9utbepmq8EuIvHZHe67Ec9zsSt+CiDFBO983t/zE= *
   
## build cluster with 2 node 

 ** node1 with ip-10.22.19.91
 
 consul agent -dev  -bind=10.22.19.91 \
	-server -bootstrap-expect=1  \
	-node=agent1 \
	-encrypt=qp7KrVAMs3Sb9IQKMsQf/AziKMDshme2k2CKnPhq54c=  \
	-join "10.22.19.121"

 ** node2 with ip-10.22.19.121
 
 consul agent -dev  -bind=10.22.19.121 \
	-server \
	-node=agent2 \
	-encrypt=qp7KrVAMs3Sb9IQKMsQf/AziKMDshme2k2CKnPhq54c=  \
	-join "10.22.19.91"
	
 
# run consul with diff port 
 
 consul agent -dev -data-dir d:/tmp/consul2 -bind 10.22.19.121 -server -node=agent2 -grpc-port 8902 -dns-port 8601 -http-port 8901


   
