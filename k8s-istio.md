# Download Istio

curl -L https://istio.io/downloadIstio | sh -

	# Move to the Istio package directory. For example, if the package is istio-1.11.0:

	cd istio-${version}
	
	# copy istioctl to /usr/local/istioctl
	
	sudo cp bin/istioctl  /usr/local/bin/istioctl
	
# istio profile

|     part              |        default      |            demo  |
| -----------------     | ------------------- |    ------------- |
| Core component        |           ✔        |       ✔          |
| istio-egressgateway   |                     |       ✔         |			
| istio-ingressgateway  |           ✔        |       ✔          |
| istiod                |           ✔        |       ✔          |	

# install with default profile, include ["Istio core", "Istiod", "Ingress gateways" ] components

istioctl install

# install with profile=demo , include ["Istio core", "Istiod", "Ingress gateways", "Egress gateways"] components

istioctl install --set profile=demo

# set label istio-injection=enabled

kubectl label namespace default istio-injection=enabled --overwrite

# remove label <istio-injection> from namespace
```
kubectl label namespace  default istio-injection-

kubectl label namespace <istio-injection-name> <label-name>-
```
	
# find namespace with istio-injection=enabled

kubectl get namespace --selector=istio-injection=enabled

# To completely uninstall Istio from a cluster, run the following command:

istioctl x uninstall --purge

# apply trace monitor, apply addons folder

kubectl apply -f addons/

# grafana - to see matrics
```
istioctl dashboard grafana

# or cmd

kubectl -n istio-system port-forward \
    $(kubectl -n istio-system get pod -l app=grafana \
    -o jsonpath={.items[0].metadata.name}) 3000

```
	
# Kiali — Observability, To visualizing services call
```
istioctl dashboard kiali

# or cmd

kubectl port-forward \
    $(kubectl get pod -n istio-system -l app=kiali \
    -o jsonpath='{.items[0].metadata.name}') \
    -n istio-system 20001
```
> And open http://localhost:20001/ login using “admin” (without quotes) for user and password. 


# Jaeger — Tracing
```
istioctl dashboard jaeger

# or cmd

kubectl port-forward -n istio-system \
    $(kubectl get pod -n istio-system -l app=jaeger \
    -o jsonpath='{.items[0].metadata.name}') 16686
```

# Mirroring (also send) traffic to v2
```
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: httpbin
spec:
  hosts:
    - httpbin
  http:
  - route:
    - destination:
        host: httpbin
        subset: v1
      weight: 100     # all request to v1
    mirror:
      host: httpbin
      subset: v2
    mirrorPercentage:
      value: 100.0      # also forward request to v2 (fire and forget)
```	  

# canary deploy
```
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: sa-logic
spec:
  hosts:
    - sa-logic    
  http:
  - route: 
    - destination: 
        host: sa-logic
        subset: v1
      weight: 80
    - destination: 
        host: sa-logic
        subset: v2
      weight: 20
```

# retry & timeout
```
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: sa-logic
spec:
  hosts:
    - sa-logic
  http:
  - route: 
    - destination: 
        host: sa-logic
        subset: v1
      weight: 80
    - destination: 
        host: sa-logic
        subset: v2
      weight: 20
    timeout: 8s          # timeout
    retries:             # retry
      attempts: 3
      perTryTimeout: 3s     # timeout for each try
```

# auth by JWT
```
apiVersion: security.istio.io/v1beta1
kind: RequestAuthentication
metadata:
  name: auth-policy
  namespace: default
spec:
  selector:
    matchLabels:
      app: sa-web-app
  jwtRules:
  - issuer: "testing@secure.istio.io"
    jwksUri: "https://raw.githubusercontent.com/istio/istio/release-1.5/security/tools/jwt/samples/jwks.json"
---
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: require-jwt
  namespace: default
spec:
  selector:
    matchLabels:
      app: sa-web-app
  action: ALLOW
  rules:
  - from:
    - source:
       requestPrincipals: ["*"]
```

curl ${INGRESS_IP}

> RBAC: access denied 

curl --header "Authorization: Bearer ${VALID_JWT}" ${INGRESS_IP}
	
> 200 ok 

	  













