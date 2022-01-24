terraform {
  backend "s3" {
    bucket = "project-bucket123"
    key    = "us-east-1/appname/asg"
    region = "us-east-1"
  }
}
