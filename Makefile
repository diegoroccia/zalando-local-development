.PHONY: all cluster ingress clean

all: cluster ingress

cluster:
	kind create cluster --name local --config manifests/kind/kindConfig.yaml
	kubectl wait --for=condition=Ready node/local-control-plane --timeout 120s

ingress:
	kubectl apply -f manifests/ingress/
	until kubectl rollout status deployment/skipper-ingress -n kube-system; do sleep 3; done

echo:
	helm repo add ealenn https://ealenn.github.io/charts
	helm repo update
	helm upgrade -i echo ealenn/echo-server --namespace default --force
	sleep 30

clean:
	kind delete cluster --name local
