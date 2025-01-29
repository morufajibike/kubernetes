# Overview

## Instructions
- Get login password with either of the following methods:

    `argocd admin initial-password -n argocd`

    or        
        
    `k get secrets argocd-initial-admin-secret -o yaml -n argocd`

    - Decode the password with:

        `echo "<value from above>" | base64 -d` 

- Configure port-forward to the argocd server service

    `k port-forward svc/argocd-server -n argocd 8080:80`


- Login with `admin` as username and password from above

- Update local kube-config, switch to the right context and apply the manifests in root folder `argocd` i.e

    `k apply -d project.yaml`
        
    `k apply -f application.yaml`

