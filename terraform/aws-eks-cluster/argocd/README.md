# Overview

## Instructions
- Get login password from secret with
    
    `k get secrets argocd-initial-admin-secret -o yaml -n argocd`

- Decode the password with:

    `echo "<value from above>" | base64 -d` 

- Configure port-forward to the argocd server service

    `k port-forward svc/argocd-server -n argocd 8080:80`


- Login with `admin` as username and password from above

- Update local kube-config and apply the manifests in root folder `argocd` i.e

    `k apply -f application.yaml`

    `k apply -d project.yaml`