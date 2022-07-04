variable "aws_region" {
  description = "Region where you want to provision your infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "port_list" {
  description = "list of ports to open for our web server"
  type        = list(any)
  default     = ["443", "80", "22"]
}

variable "instance_size" {
  description = "EC2 instance size to provision"
  type        = string
  default     = "t3.micro"
}

variable "tags" {
  description = "tags to apply to resources"
  type        = map(any)
  default = {
    Owner      = "Paul Fomenji"
    Enviroment = "Prod"
    Project    = "CCOE"
  }
}
