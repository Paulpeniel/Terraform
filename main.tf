#--------------------------------------------
# Building an infrastructure for CI/CD -Pipeline as code project
# We will start by provisioning our VPC
# - 2 or more subnets in 2 or more availability zones
# By Paul Fomenji
#---------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
  #access_key = ""
  #secret_key = ""
}

# Configure a VPC
resource "aws_vpc" "mylab-vpc" {
  cidr_block           = var.cidr_block[0]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "CICD_Project" })

}

# Create the subnets
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.mylab-vpc.id
  cidr_block        = var.cidr_block[1]
  availability_zone = "us-east-1a"

  tags = merge(var.tags, { Name = "CICD_Project" })
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.mylab-vpc.id
  cidr_block        = var.cidr_block[2]
  availability_zone = "us-east-1b"

  tags = merge(var.tags, { Name = "CICD_Project" })
}

resource "aws_subnet" "subnet3" {
  vpc_id            = aws_vpc.mylab-vpc.id
  cidr_block        = var.cidr_block[3]
  availability_zone = "us-east-1c"

  tags = merge(var.tags, { Name = "CICD_Project" })
}

resource "aws_subnet" "subnet4" {
  vpc_id            = aws_vpc.mylab-vpc.id
  cidr_block        = var.cidr_block[4]
  availability_zone = "us-east-1d"

  tags = merge(var.tags, { Name = "CICD_Project" })
}

# create an internet gateway
resource "aws_internet_gateway" "Mylab-Igw" {
  vpc_id = aws_vpc.mylab-vpc.id

  tags = {
    Name = "Mylab-Igw"
  }
}

resource "aws_route_table" "mylab-rt" {
  vpc_id = aws_vpc.mylab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Mylab-Igw.id
  }
}

resource "aws_route_table_association" "mylab-rt-assoc1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.mylab-rt.id

}

# Configure a route table association

resource "aws_route_table_association" "mylab-rt-assoc2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.mylab-rt.id

}

# Configure a security group
resource "aws_security_group" "MyLab-SG" {
  name        = "Security Group for CICD"
  description = "Allow Inbound and Output traffic"
  vpc_id      = aws_vpc.mylab-vpc.id

  dynamic "ingress" {
    for_each = ["80", "8080", "8081", "22"]
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

  tags = merge(var.tags, { Name = "CICD_Project" })
}

resource "aws_eip" "ip" { // give it a static IP4 address
  instance = aws_instance.Jenkins.id
  vpc      = true
}


# Configure an ec2 instance and install Jenkins using and external file template
resource "aws_instance" "Jenkins" {
  ami                         = var.ami
  instance_type               = var.instance_size
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet1.id
  vpc_security_group_ids      = [aws_security_group.MyLab-SG.id]
  user_data                   = file("jenkins.sh")

  tags = {
    "Name" = "Jenkins"
  }


}

# configure an ec2 services for Ansible controle node
resource "aws_instance" "Ansible" {
  ami                         = var.ami
  instance_type               = var.instance_size
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet1.id
  vpc_security_group_ids      = [aws_security_group.MyLab-SG.id]
  user_data                   = file("ansible.sh")

  tags = {
    "Name" = "Ansible"
  }


}

# configure our managed node, which is an apache tomcat server
resource "aws_instance" "Tomcat" {
  ami                         = var.ami
  instance_type               = var.instance_size
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet1.id
  vpc_security_group_ids      = [aws_security_group.MyLab-SG.id]
  user_data                   = file("tomcat.sh")

  tags = {
    "Name" = "AnsibleMN-Tomcat"
  }


}

# Configure another managed node, a docker host server 
resource "aws_instance" "Docker" {
  ami                         = var.ami
  instance_type               = var.instance_size
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet1.id
  vpc_security_group_ids      = [aws_security_group.MyLab-SG.id]
  user_data                   = file("docker.sh")

  tags = {
    "Name" = "AnsibleMN-Docker"
  }


}

# Configure a Sonatype server on an ec2
resource "aws_instance" "Sonatype" {
  ami                         = var.ami
  instance_type               = var.instance_size
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet1.id
  vpc_security_group_ids      = [aws_security_group.MyLab-SG.id]
  #user_data                   = file("sonatype.sh") // I will manually install this

  tags = {
    "Name" = "Sonatype"
  }


}
