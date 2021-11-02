Guide

https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started

How can I get my worker nodes to join my Amazon EKS cluster?

https://aws.amazon.com/premiumsupport/knowledge-center/eks-worker-nodes-cluster/

## Set up
- terraform output kubeconfig > ~/.kube/config
- terraform output config_map_aws_auth > config_map_aws_auth.yaml
- kubectl create/apply -f config_map_aws_auth.yaml
