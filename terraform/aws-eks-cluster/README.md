## Overview
Provision an EKS cluster with kubectl and Kubernetes dashboard.

### Source
[Terraform EKS](https://learn.hashicorp.com/tutorials/terraform/eks)

### Deployment Steps
1. Configure AWS credentials/profie with [AWS IAM Identity Center](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html#cli-configure-sso-configure):
   - `aws configure sso`
   - `export AWS_PROFILE=AppviaSandboxAdmin`
2. Create infrastructure:
   - `terraform apply`

### Optional Steps
- Use [k9s](https://k9scli.io/topics/commands/) for cluster management.

### Verification Steps
1. Configure `kubectl`:
   - `aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`
2. Confirm `kubectl` is working:
   - `kubectl get pods`

The following steps are optional - only if you want to deploy a metrics server and dashboard.
1. Deploy Kubernetes Metrics Server
   ```
   wget -O v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz
   kubectl apply -f metrics-server-0.3.6/deploy/1.8+/
   rm -rf metrics-server-0.3.6
   ```
2. Verify Metrics Server:
   - `kubectl get deployment metrics-server -n kube-system`
3. Deploy Kubernetes Dashboard:
   - `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml`
4. Create a proxy server for dashboard to be accessible through localhost:
   - kubectl proxy
5. Authenticate the dashboard:
   - From another terminal (leave proxy running in one), run the following commands:
   - Create the ClusterRoleBinding resource:
     `kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-eks-cluster/master/kubernetes-dashboard-admin.rbac.yaml`
   - Generate the authorization token:
     `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')`
   - Select "Token" on the Dashboard UI then copy and paste the entire token above
6. Access dashboard through localhost and port displayed when you started a proxy server.
7. Congratulations, you have provisioned an EKS cluster, configured kubectl, and deployed the Kubernetes dashboard.

### Clean up
Clean up resources to keep billing charges at a bare minimum:
   - `terraform destroy`

