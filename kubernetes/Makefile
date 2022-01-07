add-config:
	cp ~/.kube/config ~/.kube/config.$$(date +%Y-%m-%d_%H-%M-%S).backup
	terraform output -raw kubeconfig-prod > kubeconfig-prod.yml
	KUBECONFIG=kubeconfig-prod.yml:~/.kube/config kubectl config view --raw > /tmp/kubeconfig.merge.yml && cp /tmp/kubeconfig.merge.yml ~/.kube/config
