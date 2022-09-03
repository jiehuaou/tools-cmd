
## Start your cluster

	minikube start --driver=docker [default]
	minikube start --driver=virtualbox
	minikube start --driver=hyperv
	
## Delete the existing 'minikube' cluster	

	minikube delete
	
## Enable the Ingress controller

	minikube addons enable ingress
	
## Verify that the NGINX Ingress controller is running

	kubectl get pods -n kube-system	
	
## show info
	
	kubectl get pod
	kubectl get service
	kubectl get node
	
## create pod, yauritux/busybox-curl

    kubectl run mybox --image=yauritux/busybox-curl --restart=Never --command sleep 9999d
	
	kubectl run -it --rm --restart=Never mybox2  --image=curlimages/curl --command sleep 9999d
	
	kubectl run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox sh
	
	# debug above pod
	kubectl debug -it mybox2 --image=curlimages/curl --share-processes --copy-to=mybox-debug
	
	# show log of pod in specific container
	kubectl logs your-pod-name -c your-container-name
	
	
## Deploy applications

    kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
	
	# after delete pod
	kubectl run hello-node --image=k8s.gcr.io/echoserver:1.4

	kubectl create deployment my-web --image=gcr.io/google-samples/hello-app:1.0

	kubectl create deployment my-nginx --image=nginx
	
	kubectl apply -f config_file_link.yaml
	
## Expose the Deployment:

	kubectl expose deployment my-web --type=NodePort --port=8080
	
	kubectl expose deployment hello-node --type=LoadBalancer --port=9101
	
## Verify the Service is created and is available on a node port:

	kubectl get service my-web	
	
## Visit the service via NodePort:

	minikube service my-web --url	
	
	### output sample http://172.17.9.132:30810, or
	
	minikube service my-web ## auto open in browser
	
## how to stop/pause a pod in kubernetes
	
	#  Kubernetes doesn't support stop/pause of current state of pod
	#  However, you can still achieve it by having no working deployments
	
	kubectl scale --replicas=0 deployment/your_deployment
	
## delete pod, svc 

	# delete service
	kubectl delete service hello-node
	
	# delete pod
	kubectl delete pod hello-node-7567d9fdc9-8bmn5
	
	# delete deployment
	kubectl delete deployment hello-node
	

## create an Alpine shell, which you can install other package like curl etc

	kubectl run --image=alpine -it alpine-shell -- /bin/sh
	
	**detach (without killing the container)**

	CTRL + P, CTRL + Q
	
	** re-attach with **

	kubectl attach -it alpine-shell
	
	** install curl and test internal service **
	
	apk add --update curl
	
	curl http://your-service
	
	for i in `seq 1 10 `; do curl http://your-service; echo ; done;
	
# To create an autoscaling CPU deployment, use the following command

	kubectl autoscale deployment my-apache --cpu-percent=50 --min=1 --max=4	
	
	
# Install the Dashboard application into our cluster

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

# To access Dashboard from your local workstation you must create a secure channel

kubectl proxy

# Create An ServiceAccount and ClusterRole Binding
```
# Create a new ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
# Create a ClusterRoleBinding for the ServiceAccount
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

kubectl apply -f user-role.yaml

# print secret name

kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}'

# Get the Token for the ServiceAccount in one step

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

  # or 
  kubectl -n kubernetes-dashboard describe secret admin-user-token-lflc4

  token:     eyJhbGciOiJSUzI1NiIsImtpZCI6InNIOVFpYTZ6c043THhlQWNYVzlFOHozVzNNWWxucFhUSXc3M0FVX3NDNk0ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLWxmbGM0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI5MTJiZGU5MS05MWVhLTRhNWQtOGM5NC1kY2M4YWI3MzEyMGUiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.U6TDcbzT_Z6S4A0-k9Nz8nWubQztbhG6GwzwQFSQK1k8NfQ-BlzJ7-hDq_QZ8MNXOJaR5FLVFjTeCbkf1y3eBHLUh9IrucI-ldTygouW0_WDjK6gzmXFiQQiErrvgSVwUcxXqrCZDJQE63_esiZe7KSCmgi-ySPcLb30its6SbfpfbccrUKSGPPA3PZEzvvFzkugaaZEjW_fxdW2jwUqNz7WiczqmV95WblOlCHnqC7mKGF6q6F0WSq8ISgtteI54pzN2PlGoLkb1sVdX_lN3TNfkI6RBKpiyKhsDCulX-nzZhC519FGWmusk3qKsbfgtlWs47M6dojDpCCa-CJGIg

# Copy the token and copy it into the Dashboard login and press "Sign in"

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

	