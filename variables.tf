variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_block" {
  type    = list(string)
  default = ["10.10.0.0/16", "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24", "10.10.4.0/24"]
}

variable "tags" {
  description = "tags for our resources"
  default = {
    Name    = "CICD_Project"
    Owner   = "Paul Fomenji"
    Project = "CI/CD"
  }
}

variable "enviroment" {
  type    = string
  default = "Prod"
}

variable "instance_size" {
  type    = string
  default = "t3.medium"
}

variable "key_name" {
  default = "devops-keypair"
}

variable "ami" {
  type    = string
  default = "ami-0cff7528ff583bf9a"
}
