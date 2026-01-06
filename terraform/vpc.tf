module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "hello-world-vpc"
  cidr = var.vpc_cidr

  azs            = var.azs
  public_subnets = var.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  map_public_ip_on_launch = true


}
