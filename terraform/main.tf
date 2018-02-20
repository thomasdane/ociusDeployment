provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "../credentials"
    profile = "ocius"
}

data "aws_availability_zones" "all" {}
