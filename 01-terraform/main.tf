module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]
}

# =====================================================================
# ECR
#
# Repositórios Docker utilizados pelos microsserviços.
# =====================================================================

module "ecr" {

  source = "./modules/ecr"

  project_name = var.project_name

  environment = var.environment

  repositories = [
    "auth",
    "flag",
    "targeting",
    "evaluation",
    "analytics"
  ]
}

module "eks" {
  source = "./modules/eks"
  project_name = var.project_name
  environment = var.environment
  cluster_name = "${var.project_name}-${var.environment}"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  lab_role_arn = var.lab_role_arn
}

# =====================================================================
# DYNAMODB
# =====================================================================

module "dynamodb" {
  source = "./modules/dynamodb"
  project_name = var.project_name
  environment = var.environment
}


# =====================================================================
# SQS
# =====================================================================

module "sqs" {
  source = "./modules/sqs"
  project_name = var.project_name
  environment = var.environment
}


# =====================================================================
# AUTH DATABASE
# =====================================================================

module "auth_db" {
  source = "./modules/rds"
  project_name = var.project_name
  environment = var.environment
  identifier = "auth-db"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

# =====================================================================
# FLAG DATABASE
# =====================================================================

module "flag_db" {
  source = "./modules/rds"
  project_name = var.project_name
  environment = var.environment
  identifier = "flag-db"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

# =====================================================================
# TARGETING DATABASE
# =====================================================================

module "targeting_db" {
  source = "./modules/rds"
  project_name = var.project_name
  environment = var.environment
  identifier = "targeting-db"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

# =====================================================================
# REDIS
# =====================================================================

module "redis" {
  source = "./modules/redis"
  project_name = var.project_name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}