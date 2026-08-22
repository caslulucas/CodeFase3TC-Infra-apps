#terraform plan -var-file="environments/personal/personal.tfvars"

environment        = "personal"
aws_region         = "us-east-1"
cluster_name       = "togglemaster-personal"
enable_nat_gateway = true