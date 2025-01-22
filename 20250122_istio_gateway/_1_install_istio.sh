curl -L https://istio.io/downloadIstio | sh -
mv istio-1.24.2/bin/istioctl /usr/local/bin/

# Install istio
istioctl install -f istio-1.24.2/samples/bookinfo/demo-profile-no-gateways.yaml -y
# ✔ Istio core installed ⛵️
kubectl label namespace default istio-injection=enabled

# Install Kubernetes GatewayAPI CRDs
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
{ kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.2.0" | kubectl apply -f -; }

# Cleanup
rm -rf istio-1.24.2

