variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "instance_type" {
  default     = "t2.small"
  description = "AWS instance type"
}