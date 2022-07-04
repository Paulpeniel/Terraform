/*
output "public_ip" {  // you can uncomment this if you have an igw attached to your vpc
  value = aws_eip.web.public_ip
}
*/

output "server_id" {
  value = aws_instance.web.id
}

output "securitygroup_id" {
  value = aws_security_group.web.id
}

variable "key_name" {
  type    = string
  default = "devops-keypair"
}
