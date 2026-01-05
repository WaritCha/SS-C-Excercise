variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 8080
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "public_subnets" {
  description = "Public Subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "hello-world-container"
  }
}

variable "git_repo_url" {
  description = "URL of the Git repository for ArgoCD to sync"
  type        = string
  default     = "https://github.com/YOUR_USERNAME/YOUR_REPO.git"
}
