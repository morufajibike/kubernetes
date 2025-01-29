#!/bin/bash

## install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

## Access The Argo CD API Server
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

## Ingress / Port Forwarding
# kubectl port-forward svc/argocd-server -n argocd 8080:443
## The API server can then be accessed using https://localhost:8080

## login using the cli
## argocd admin initial-password -n argocd

## create an application from a git repo
## kubectl config set-context --current --namespace=argocd
## argocd app create hostname --repo https://github.com/morufajibike/kubernetes.git --path sample-apps/hostname/k8 --dest-server https://kubernetes.default.svc --dest-namespace hostname
### argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default

## sync the application
## argocd app sync guestbook