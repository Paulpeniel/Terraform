variable "aws_region" {
  description = "Region where we will provision our infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "instance_size" {
  description = "size of our EC2"
  type        = string
  default     = "t2.mirco"
}

variable "key_name" {
  description = "security key for our web server"
  default     = "devops-keypair"
}

variable "tags" {
  description = "tags for our resources"
  type        = map(any)
  default = {
    Name       = "Webserver"
    Owner      = "Paul Fomenji"
    Project    = "CCOE"
    Enviroment = "Prod"
  }
}

variable "port_list" {
  description = "ports to be opened on web server"
  type        = list(any)
  default     = ["80", "443", "22"]
}
