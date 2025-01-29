# Overview

## Instructions
- Create the EKS cluster and argocd.

- `alias k=kubectl`

- Update kubeconfig:
   - `aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`

- Get login password with either of the following methods:

    `argocd admin initial-password -n argocd`

    or        
        
    `k get secrets argocd-initial-admin-secret -o yaml -n argocd`

    - Decode the password with:

        `echo "<value from above>" | base64 -d` 

- Configure port-forward to the argocd server service

    `k port-forward svc/argocd-server -n argocd 8080:443`

- Login with `admin` as username and password from above

- Update local kube-config, switch to the right context and apply the manifests in root folder `argocd` i.e


    `kubectl config set-context --current --namespace=argocd`

    `k apply -d ./kubernetes/argocd/hostname/project.yaml`
        
    `k apply -f ./kubernetes/argocd/hostname/application.yaml`

- Configure port-forward to the hostname service

    `k port-forward svc/hostname-service -n my-app 8091:8080`
 