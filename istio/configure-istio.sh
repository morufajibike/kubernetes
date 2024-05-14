#!/bin/bash

kubectl get nodes

helm repo add istio https://istio-release.storage.googleapis.com/charts

helm repo update

helm search repo istio

# Install Istio Base Components 
helm install istio-base istio/base -n istio-system --create-namespace

# Install Istio Control Plane
helm install istiod istio/istiod -n istio-system --wait

# Install Istio Ingress Gateway - takes care of routing traffic from outside the cluster to the services inside the cluster
helm install istio-ingress istio/gateway -n istio-system --create-namespace --wait

helm ls -A

# Deploy an App onto the Mesh
## Istio has a feature called automatic sidecar injection. 
## When enabled, Istio will automatically inject a sidecar proxy into each pod that is deployed 
## in the namespace. This sidecar proxy is responsible for intercepting all incoming and outgoing 
## network traffic to the pod and enforcing the policies that are defined in the Istio configuration.
kubectl label namespace default istio-injection=enabled

kubectl describe namespace default