provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "../credentials"
    profile = "ocius"
}

terraform {
    backend "s3" {
        bucket = "ocius-terraform"
        key = "ocius.tfstate"
        region = "ap-southeast-2"
    }
}

data "aws_availability_zones" "all" {}
