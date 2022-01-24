# This code block reads VPC info
# from S3 bucket

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






variable "three-tier" {
  type = map(any)
  default = {
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.three-tier["region"]
}
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"
  # Autoscaling group
  name                      = "example-asg"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier = [
    data.terraform_remote_state.main.outputs.private_subnets[0],
    data.terraform_remote_state.main.outputs.private_subnets[1],
    data.terraform_remote_state.main.outputs.private_subnets[2]
  ]
  # Launch template
  lt_name                = "example-asg"
  description            = "Launch template example"
  update_default_version = true
  use_lt                 = true
  create_lt              = true
  image_id               = "ami-08e4e35cccc6189f4"
  instance_type          = "t3.micro"
  ebs_optimized          = true
  enable_monitoring      = false

  tags_as_map = {
    extra_tag1 = "extra_value1"
    extra_tag2 = "extra_value2"
  }
}

resource "aws_elb" "bar" {
  subnets = [
    data.terraform_remote_state.main.outputs.public_subnets[0],
    data.terraform_remote_state.main.outputs.public_subnets[1],
    data.terraform_remote_state.main.outputs.public_subnets[2]
  ]
  name               = "foobar-terraform-elbs"
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}


resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = module.asg.autoscaling_group_id
  elb                    = aws_elb.bar.id
}
