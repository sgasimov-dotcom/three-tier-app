variable "three-tier" {
    type = map 
    default = {
        region = "us-east-1"
    }
}

provider "aws" {
    region = var.three-tier["region"]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "demo"
  cidr = "10.0.0.0/16"

  azs             = ["${var.three-tier["region"]}a", "${var.three-tier["region"]}b", "${var.three-tier["region"]}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
    CreatedBy   = "DevOps"
    Quarter = "Q1"
  }
}

output vpc_id {
    value = module.vpc.vpc_id
}

output private_subnets {
    value = module.vpc.private_subnets
}

output public_subnets {
    value = module.vpc.public_subnets
}