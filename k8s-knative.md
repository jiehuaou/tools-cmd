
# Install the Knative Serving component¶

kubectl apply -f https://github.com/knative/serving/releases/download/v0.24.0/serving-crds.yaml

kubectl apply -f https://github.com/knative/serving/releases/download/v0.24.0/serving-core.yaml

# Install a networking layer

kubectl apply -f https://github.com/knative/net-kourier/releases/download/v0.24.0/kourier.yaml

kubectl patch configmap/config-network --namespace knative-serving --type merge --patch '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'
  

# Save this to use in the Configure DNS section below.
  
kubectl --namespace kourier-system get service kourier

# verify install

kubectl get pods --namespace knative-serving

# Configure DNS (optional)

kubectl apply -f https://github.com/knative/serving/releases/download/v0.24.0/serving-default-domain.yaml

# support HPA-class autoscaling :

kubectl apply -f https://github.com/knative/serving/releases/download/v0.24.0/serving-hpa.yaml

# Install the Eventing component

kubectl apply -f https://github.com/knative/eventing/releases/download/v0.24.0/eventing-crds.yaml

kubectl apply -f https://github.com/knative/eventing/releases/download/v0.24.0/eventing-core.yaml

# verify 

kubectl get pods --namespace knative-eventing

# Install Knative Kafka Eventing, controller & broker (dispatcher, receiver)

kubectl apply -f https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/v0.24.0/eventing-kafka-controller.yaml

kubectl apply -f https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/v0.24.0/eventing-kafka-broker.yaml
	
	# verify
	kubectl get deployments.apps -n knative-eventing
	
# KafkaBinding that will inject Kafka bootstrap information into the application container (through the Knative Service). 
# Then, the application can access it as the KAFKA_BOOTSTRAP_SERVERS environment variable.	
```
apiVersion: bindings.knative.dev/v1beta1
kind: KafkaBinding
metadata:
  name: kafka-binding-order-saga
spec:
  subject:
    apiVersion: serving.knative.dev/v1
    kind: Service
    name: order-saga
  bootstrapServers:
    - my-cluster-kafka-bootstrap.kafka:9092
```

# KafkaSource - that takes events from a particular topic and sends them to the subscriber. 

# Broker - that need to define Knative Trigger that refers to it.

	
