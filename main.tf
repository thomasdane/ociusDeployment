provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "C:/Users/TomDane/.aws/credentials"
    profile = "ocius"
}

resource "aws_instance" "example" {
    ami = "ami-2d39803a"
    instance_type = "t2.nano"

    tags {
        Name = "terraform-example"
    }
}