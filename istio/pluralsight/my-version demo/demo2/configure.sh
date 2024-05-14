kubectl create namespace bookinfo

kubectl config set-context --current --namespace bookinfo

# configure proxy container injection
kubectl label namespace bookinfo istio-injection=enabled

kubectl apply -f demo2/bookinfo.yaml