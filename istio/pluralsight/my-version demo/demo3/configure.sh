kubectl apply -f demo3/details-virtualservice.yaml

## test bad release
kubectl apply -f demo3/details-bad-release.yaml
kubectl apply -f demo3/details-virtualservice.yaml
kubectl apply -f demo3/details-virtualservice-timeout.yaml
kubectl apply -f demo3/details-virtualservice-retry.yaml


