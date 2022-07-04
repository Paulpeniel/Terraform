#----------------------------------------------
# Use variables
#
# Made by Paul Fomenji
provider "aws" {
  region = var.aws_region
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}
/*
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  tags     = merge(var.tags, { Name = "${var.tags["Enviroment"]}-EIP for Webserver Built by terraform" })
}
*/

resource "aws_instance" "web" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_size
  key_name               = "devops-keypair"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = file("user_data.sh")
  tags                   = merge(var.tags, { Name = "${var.tags["Enviroment"]}-Webserver Built by terraform" })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web" {
  name        = "Webserver-SG"
  description = "Security Group for my ${var.tags["Enviroment"]} webserver"

  dynamic "ingress" {
    for_each = var.port_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags["Enviroment"]}-Webserver-SG" })
}
