
## Unable to bind ports: Docker-for-Windows

## show tcp Port Exclusion Ranges

	netsh interface ipv4 show excludedportrange protocol=tcp

## the steps are:

	## Disable hyper-v (which will required a couple of restarts)
	
	dism.exe /Online /Disable-Feature:Microsoft-Hyper-V

	## When you finish all the required restarts, reserve the port you want so hyper-v doesn't reserve it back
	
	netsh int ipv4 add excludedportrange protocol=tcp startport=50070 numberofports=1
	netsh int ipv4 add excludedportrange protocol=tcp startport=50470 numberofports=1
	netsh int ipv4 add excludedportrange protocol=tcp startport=50075 numberofports=1
	netsh int ipv4 add excludedportrange protocol=tcp startport=50475 numberofports=1
	netsh int ipv4 add excludedportrange protocol=tcp startport=50090 numberofports=1
	netsh int ipv4 add excludedportrange protocol=tcp startport=50105 numberofports=1
	
	      ## 50070, 50470, 50075, 50475, 50090, 50105

	## Re-Enable hyper-V (which will require a couple of restart)
	
	dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All

## when your system is back, you will be able to bind to that port successfully.


