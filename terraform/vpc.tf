module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "hello-world-vpc"
  cidr = var.vpc_cidr

  azs            = var.azs
  public_subnets = var.public_subnets

  # Using public subnets for Fargate tasks to avoid NAT Gateway costs for this demo.
  # containter instances will have public IPs but protected by Security Groups.
  enable_nat_gateway = false
  enable_vpn_gateway = false

  map_public_ip_on_launch = true

  tags = var.tags

  public_subnet_tags = {
    "kubernetes.io/cluster/hello-world-eks" = "shared"
    "kubernetes.io/role/elb"                = "1"
  }
}
