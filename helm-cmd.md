
# add a chart repository

helm repo add stable https://charts.helm.sh/stable

# helm install chart

helm install <your-name> -f ~/my-config.yaml <Chart>
	
helm install <your-name> <Chart> --set param1=123

# un-install chart

helm uninstall <your-name>

# get custom values were used in install

helm -n <namespace> get values <your-name>

helm get values <your-name>

# list installed chart

helm list

# get status

helm status <your-name>

