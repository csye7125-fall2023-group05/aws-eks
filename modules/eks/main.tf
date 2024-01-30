locals {
  cluster_name    = var.cluster_name
  PRIVATE_SUBNETS = var.PRIVATE_SUBNETS
  PUBLIC_SUBNETS  = var.PUBLIC_SUBNETS
}
resource "aws_eks_cluster" "pwncorp_cluster" {
  name = "pwncorp-${local.cluster_name}"

  # The Amazon Resource Name (ARN) of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations

  role_arn = var.EKS_CLUSTER_ROLE_ARN

  # Desired Kubernetes master version
  version = "1.27"
  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids = [
      local.PUBLIC_SUBNETS[0].id,
      local.PUBLIC_SUBNETS[1].id,
      local.PRIVATE_SUBNETS[0].id,
      local.PRIVATE_SUBNETS[1].id
    ]
  }
}
