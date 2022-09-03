
# Knative on Kind (KonK)

** https://github.com/csantanapr/knative-kind **

# curl -sL get.konk.dev | bash

🍿 Installing Knative Serving and Eventing ...
✅ Checking dependencies...
KinD version is kind v0.14.0 go1.18.2 linux/amd64
WARNING: Please make sure you are using KinD version v0.12.x, download from https://github.com/kubernetes-sigs/kind/releases
For example if using brew, run: brew upgrade kind
Do you want to continue on your own risk? Y/n: y
You are very brave...
Using image kindest/node:v1.23.4@sha256:0e34f0d0fd448aa2f2819cfd74e99fe5793a6e4938b328f657c8e3f81ee0dfb9
Creating cluster "knative" ...
 ✓ Ensuring node image (kindest/node:v1.23.4) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Waiting ≤ 2m0s for control-plane = Ready ⏳
 • Ready after 18s 💚
Set kubectl context to "kind-knative"
You can now use your cluster with:

kubectl cluster-info --context kind-knative

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
🍿 Installing Knative Serving...
Warning: autoscaling/v2beta2 HorizontalPodAutoscaler is deprecated in v1.23+, unavailable in v1.26+; use autoscaling/v2 HorizontalPodAutoscaler
🔌 Installing Knative Serving Networking Layer kourier...
configmap/config-network patched
service/kourier-ingress created
configmap/config-domain patched
🔥 Installing Knative Eventing...
Warning: autoscaling/v2beta2 HorizontalPodAutoscaler is deprecated in v1.23+, unavailable in v1.26+; use autoscaling/v2 HorizontalPodAutoscaler
Warning: policy/v1beta1 PodDisruptionBudget is deprecated in v1.21+, unavailable in v1.25+; use policy/v1 PodDisruptionBudget
Warning: autoscaling/v2beta2 HorizontalPodAutoscaler is deprecated in v1.23+, unavailable in v1.26+; use autoscaling/v2 HorizontalPodAutoscaler
broker.eventing.knative.dev/example-broker created
NAME             URL                                                                               AGE   READY   REASON
example-broker   http://broker-ingress.knative-eventing.svc.cluster.local/default/example-broker   10s   True
 🚀 Knative install took: 4m12s
 🎉 Now have some fun with Serverless and Event Driven Apps
🕹 Installing Knative Samples Apps...
service.serving.knative.dev/hello created
Downloading hello App container image...
The Knative Service hello endpoint is http://hello.default.127.0.0.1.sslip.io
Hello Knative!

deployment.apps/hello-display created
service/hello-display created
trigger.eventing.knative.dev/hello-display created
clusterdomainclaim.networking.internal.knative.dev/broker-ingress.knative-eventing.127.0.0.1.sslip.io created
domainmapping.serving.knative.dev/broker-ingress.knative-eventing.127.0.0.1.sslip.io created

Sending Cloud Event to event broker
Cloud Event Delivered     "msg": "Hello Knative!"

# kubectl get ksvc,broker,trigger

NAME                                URL                                       LATESTCREATED   LATESTREADY   READY   REASON
service.serving.knative.dev/hello   http://hello.default.127.0.0.1.sslip.io   hello-00001     hello-00001   True

NAME                                         URL                                                                               AGE   READY   REASON
broker.eventing.knative.dev/example-broker   http://broker-ingress.knative-eventing.svc.cluster.local/default/example-broker   65s   True

NAME                                         BROKER           SUBSCRIBER_URI                                   AGE   READY   REASON
trigger.eventing.knative.dev/hello-display   example-broker   http://hello-display.default.svc.cluster.local   9s    True
 🚀 Knative install with samples took: 5m7s
 🎉 Now have some fun with Serverless and Event Driven Apps


** get url **
#  kubectl get ksvc hello -o jsonpath='{.status.url}'

** test to launch pod **
# curl http://hello.default.127.0.0.1.sslip.io

** find pod after test **
# kubectl get pod -l serving.knative.dev/service=hello
# kubectl -n $NAMESPACE logs -l serving.knative.dev/service=hello  --tail=100
# kubectl -n $NAMESPACE logs -l serving.knative.dev/service=fmt-java  --tail=100


```shell
export EXTERNAL_IP="127.0.0.1"
export KNATIVE_DOMAIN="$EXTERNAL_IP.sslip.io"
echo KNATIVE_DOMAIN=$KNATIVE_DOMAIN
```

Allow broker to be assign a domain using Knative ClusterDomainClaim CRD
``` yaml
apiVersion: networking.internal.knative.dev/v1alpha1
kind: ClusterDomainClaim
metadata:
  name: broker-ingress.knative-eventing.${KNATIVE_DOMAIN}
spec:
  namespace: knative-eventing
```

Expose broker externally by assigning a domain using DomainMapping CRD
```yaml
apiVersion: serving.knative.dev/v1alpha1
kind: DomainMapping
metadata:
  name: broker-ingress.knative-eventing.$KNATIVE_DOMAIN
spec:
  ref:
    name: broker-ingress
    kind: Service
    apiVersion: v1
```

Send a Cloud Event usnig curl pod created in the previous step.
```shell
curl -s -v  "http://broker-ingress.knative-eventing.$KNATIVE_DOMAIN/$NAMESPACE/example-broker" \
  -X POST \
  -H "Ce-Id: say-hello" \
  -H "Ce-Specversion: 1.0" \
  -H "Ce-Type: greeting" \
  -H "Ce-Source: not-sendoff" \
  -H "Content-Type: application/json" \
  -d '{"msg":"Hello Knative!"}'
```  


Verify the events were received
```shell
kubectl -n $NAMESPACE logs -l app=hello-display --tail=100

```

Successful events should look like this
```shell
Context Attributes,
  specversion: 1.0
  type: greeting
  source: not-sendoff
  id: say-hello
Data,
  {
    "msg": "Hello Knative!"
  }
```  


