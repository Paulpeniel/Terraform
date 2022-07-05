aws_region    = "us-east-1"
instance_size = "t2.mirco"
key_name      = "devops-keypair"

tags = {
  Name       = "Webserver"
  Owner      = "Paul Fomenji"
  Project    = "CCOE"
  Enviroment = "Prod"
}

port_list = ["80", "443", "22"]
