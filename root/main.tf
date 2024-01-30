module "vpc" {
  source          = "../modules/vpc"
  ENV             = var.ENV
  REGION          = var.REGION
  VPC_CIDR_BLOCK  = var.VPC_CIDR_BLOCK
  PUBLIC_SUBNETS  = var.PUBLIC_SUBNETS
  PRIVATE_SUBNETS = var.PRIVATE_SUBNETS
}

module "ssh" {
  source       = "../modules/ssh"
  SSH_KEY_FILE = var.SSH_KEY_FILE
}

module "nat_gateway" {
  source           = "../modules/nat"
  PUBLIC_SUBNETS   = module.vpc.public_subnets
  PRIVATE_SUBNETS  = module.vpc.private_subnets
  cluster_name     = module.vpc.cluster_name
  internet_gateway = module.vpc.internet_gateway
  vpc_id           = module.vpc.vpc_id

}

module "iam" {
  source       = "../modules/iam"
  cluster_name = module.vpc.cluster_name
}

module "eks" {
  source               = "../modules/eks"
  cluster_name         = module.vpc.cluster_name
  PRIVATE_SUBNETS      = module.vpc.private_subnets
  PUBLIC_SUBNETS       = module.vpc.public_subnets
  EKS_CLUSTER_ROLE_ARN = module.iam.EKS_CLUSTER_ROLE_ARN
}

module "node_group" {
  source           = "../modules/node_group"
  EKS_CLUSTER_NAME = module.eks.EKS_CLUSTER_ID
  NODE_GROUP_ARN   = module.iam.NODE_GROUP_ROLE_ARN
  PRIVATE_SUBNETS  = module.vpc.private_subnets
}
