provider "aws" {
    region = "us-east-1"
    profile = "ocius"
}

terraform {
    backend "s3" {
        bucket = "ocius-terraform"
        key = "ocius.tfstate"
        region = "ap-southeast-2"
        profile = "ocius"
    }
}

data "aws_availability_zones" "all" {}
