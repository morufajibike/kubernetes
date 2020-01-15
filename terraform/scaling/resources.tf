variable "cluster_name" {}
variable "demo_cluster_version" {}
variable "demo_cluster_endpoint" {}
variable "demo_cluster_cert_auth_data" {}
variable "launch_config_instance_type" {}
variable "demo_node_iam_role_name" {}
variable "demo_node_sg_ids" {}
variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}
variable "subnet_ids" {}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.demo_cluster_version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint var.demo_cluster_endpoint --b64-cluster-ca var.demo_cluster_cert_auth_data var.cluster_name
USERDATA
}

resource "aws_launch_configuration" "demo" {
  associate_public_ip_address = true
  iam_instance_profile        = var.demo_node_iam_role_name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = var.launch_config_instance_type
  name_prefix                 = "terraform-eks-demo"
  security_groups             = var.demo_node_sg_ids
  user_data_base64            = base64encode(local.demo-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo" {
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.demo.id
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "terraform-eks-demo"
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "terraform-eks-demo"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/var.cluster_name"
    value               = "owned"
    propagate_at_launch = true
  }
}
