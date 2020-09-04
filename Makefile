.PHONY: all cluster ingress clean

all: cluster ingress

cluster:
	kind create cluster --name local --config manifests/kind/kindConfig.yaml
	kubectl wait --for=condition=Ready node/local-control-plane

ingress:
	kubectl apply -f manifests/ingress/
	kubectl -n kube-system wait --for=condition=available deployment/skipper-ingress

clean:
	kind delete cluster --name local
