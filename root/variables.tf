variable "ENV" {
  description = "The infrastructure environment: dev/staging/prod."
  type        = string
  default     = "dev"
}

variable "REGION" {
  description = "The AWS region to deploy the infrastructure in."
  type        = string
  default     = "us-east-1"
}

variable "VPC_CIDR_BLOCK" {
  description = "VPC CIDR block subnet range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "PUBLIC_SUBNETS" {
  description = "List of public IPV4 subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "PRIVATE_SUBNETS" {
  description = "List of private IPV4 subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "SSH_KEY_FILE" {
  description = "ssh-keygen generated public RSA key to SSH into an EC2 instance"
  type        = string
  default     = "ec2_ssh_key.pub"
}
