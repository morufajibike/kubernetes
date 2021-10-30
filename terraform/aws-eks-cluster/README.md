## Overview
Provision an EKS cluster with kubectl and Kubernetes dashboard.

### Source
[Terraform EKS](https://learn.hashicorp.com/tutorials/terraform/eks)

### Steps
1. Create infrastructure:
   - `terraform apply`
2. Configure kubectl:
   - `aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`
3. Deploy Kubernetes Metrics Server
   ```
   wget -O v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz
   kubectl apply -f metrics-server-0.3.6/deploy/1.8+/
   rm -rf metrics-server-0.3.6
   ```
4. Verify Metrics Server:
   - `kubectl get deployment metrics-server -n kube-system`
5. Deploy Kubernetes Dashboard:
   - `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml`
6. Create a proxy server for dashboard to be accessible through localhost:
   - kubectl proxy
7. Authenticate the dashboard:
   - From another terminal (leave proxy running in one), run the following commands:
   - Create the ClusterRoleBinding resource: `kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-eks-cluster/master/kubernetes-dashboard-admin.rbac.yaml`
   - Generate the authorization token: `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')`
   - Select "Token" on the Dashboard UI then copy and paste the entire token above
8. Access dashboard through localhost and port displayed when you started a proxy server.
9. Congratulations, you have provisioned an EKS cluster, configured kubectl, and deployed the Kubernetes dashboard.
9. Clean up resources to prevent significant charges:
   - `terraform destroy`

