# Monitoring with Prometheus and Grafana

Istio exports metrics from the proxy containers and configures them to be scraped by [Prometheus](https://prometheus.io/). In this demo we'll explore the metrics and the Istio dashboards in [Grafana](https://grafana.com).

## Reference

- Istio integration for [Grafana](https://istio.io/latest/docs/ops/integrations/grafana/)

- [Istio's Grafana dashboards](https://istio.io/latest/docs/tasks/observability/metrics/using-istio-dashboard/#about-the-grafana-dashboards)

## Pre-reqs

Follow the steps from [Demo 1](../demo1/README.md) to deploy a working instance of Bookinfo with Istio, Prometheus and Kiali configured.

```
kubectl config set-context --current --namespace=bookinfo
```

## Deploy Grafana and Prometheus UI

Deploy Grafana and VirtualServices for the web UIs:

- [02-grafana.yaml](grafana/02-grafana.yaml) - Deployment, Service, configuration and RBAC for Grafana (including dashboards)

- [03-virtualservice.yaml](grafana/03-virtualservice.yaml) - VirtualService binding `grafana.local` and `prometheus.local` to the shared Gateway

```
kubectl apply -f demo2/grafana/
```

> Browse to http://prometheus.local

- Select `istio_requests_total`
- Switch to _Graph_
- Check _Status_/_Targets_ - Kubernetes service discovery

## Generate some load

Send 100 requests per second for next 30 minutes:

_Use your own host's IP address_

```
docker container run -it `
  --add-host "bookinfo.local:192.168.2.120" `
  fortio/fortio `
  load -c 32 -qps 100 -t 30m http://bookinfo.local/productpage
```

- Back to _Graph_ view in Prometheus

## Grafana UI

> Browse to http://grafana.local

 - _Istio Mesh Dashboard_ - overview
 - _Istio Worklod Dashboard_ - drill down into component 

## Deploy a failing service

Update the reviews service to inject faults:

- [reviews-v2-503.yaml](reviews-v2-503.yaml) - faults 50% of requests

```
kubectl apply -f demo2/reviews-v2-503.yaml
```

> Browse to http://bookinfo.local/productpage and check [productpage workload in Grafana](http://grafana.local/d/UbsSZTDik/istio-workload-dashboard?orgId=1&refresh=1m&var-datasource=default&var-namespace=bookinfo&var-workload=productpage-v1&var-qrep=destination&var-srcns=All&var-srcwl=All&var-dstsvc=All)

> And [app graph in Kiali](http://kiali.local/kiali/console/graph/namespaces/?traffic=grpc%2CgrpcRequest%2Chttp%2ChttpRequest%2Ctcp%2CtcpSent&graphType=versionedApp&namespaces=bookinfo&duration=300&refresh=10000&idleNodes=true&layout=kiali-dagre&namespaceLayout=kiali-dagre&edges=trafficDistribution%2CresponseTime%2Crt95%2CtrafficRate)
