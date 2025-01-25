# Configure the Helm repository
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# Install the control plane
## Base components
helm install istio-base istio/base -n istio-system --create-namespace --wait


## Install or upgrade the Kubernetes Gateway API CRDs
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml; }

## istiod control plane
helm install istiod istio/istiod --namespace istio-system --set profile=ambient --wait

## CNI node agent
helm install istio-cni istio/cni -n istio-system --set profile=ambient --wait

# Install the data plane
## ztunnel DaemonSet
helm install ztunnel istio/ztunnel -n istio-system --wait

## Ingress gateway (optional)
helm install istio-ingress istio/gateway -n istio-ingress --create-namespace --wait

### If your Kubernetes cluster doesn’t support the LoadBalancer service type (type: LoadBalancer) with a proper external IP assigned, run the above command without the --wait parameter to avoid the infinite wait. See Installing Gateways for in-depth documentation on gateway installation.

# Configuration
helm show values istio/istiod

# Verify the installation
## Verify the workload status
helm ls -n istio-system
kubectl get pods -n istio-system