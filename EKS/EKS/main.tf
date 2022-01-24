
# Pull VPC info
data "terraform_remote_state" "main" {
  backend = "s3"
  config = {
    bucket = "project-bucket123"
    key    = "us-east-1/appname/vpc"
    region = "us-east-1"
  }
}

output "full_list" {
  value = data.terraform_remote_state.main.outputs.*
}

variable "region" {
        type = string
        description = "Region to be used"
}
variable "cluster_name" {
        type = string
        description = "Cluster name used"
}
variable "cluster_version" {
        default = "1.19"
        description = "Cluster name used"
}
variable "instance_type" {
        description = "Cluster name used"
        type = string
}
variable "asg_max_size" {
        description = "Tag names used"
        type = string
}
variable "asg_min_size" {
        description = "Tag names used"
        type = string
}
variable "tags" {
        description = "Tag names used"
        type = map(any)
}




provider "aws" {
        region = var.region
}



data "aws_eks_cluster" "cluster" {
        name = module.my-cluster.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
        name = module.my-cluster.cluster_id
}
provider "kubernetes" {
        host = data.aws_eks_cluster.cluster.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
        token = data.aws_eks_cluster_auth.cluster.token
}
module "my-cluster" {
        source = "terraform-aws-modules/eks/aws"
        version = "12.0.0"
        cluster_name = var.cluster_name
        cluster_version = var.cluster_version
        subnets = [
            data.terraform_remote_state.main.outputs.private_subnets[0],
            data.terraform_remote_state.main.outputs.private_subnets[1],
            data.terraform_remote_state.main.outputs.private_subnets[2]
            ]
        vpc_id = data.terraform_remote_state.main.outputs.vpc_id
        cluster_create_security_group = true
        worker_groups = [{
        instance_type = var.instance_type
        asg_max_size = var.asg_max_size
        asg_min_size = var.asg_min_size #min size should be 1
        image = "ami-05674d6c91201b508"
                }
        ]
        tags = var.tags
}



output "cluster_id" {
        value = module.my-cluster.cluster_id
}
output "cluster_arn" {
        value = module.my-cluster.cluster_arn
}
output "cluster_version" {
        value = module.my-cluster.cluster_version
}
output "cluster_security_group_id" {
        value = module.my-cluster.cluster_security_group_id
}
output "workers_asg_names" {
        value = module.my-cluster.workers_asg_names
}
