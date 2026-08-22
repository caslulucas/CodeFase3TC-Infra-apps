# environments/academy/terraform.tfvars.example
# Para usar o ambiente academy
# terraform plan -var-file="environments/academy/academy.tfvars"


environment        = "academy"
aws_region         = "us-east-1"
cluster_name       = "togglemaster-academy"
lab_role_arn       = "ARN_DA_LABROLE"
enable_nat_gateway = false