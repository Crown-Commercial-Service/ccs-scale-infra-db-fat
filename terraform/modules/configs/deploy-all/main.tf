#########################################################
# Config: deploy-all
#
# This configuration will deploy all components.
#########################################################
provider "aws" {
  profile = "default"
  region  = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/CCS_SCALE_Build"
  }
}

data "aws_ssm_parameter" "vpc_id" {
  name = "${lower(var.environment)}-vpc-id"
}

data "aws_ssm_parameter" "private_db_subnet_ids" {
  name = "${lower(var.environment)}-private-db-subnet-ids"
}

data "aws_ssm_parameter" "public_web_subnet_ids" {
  name = "${lower(var.environment)}-public-web-subnet-ids"
}

data "aws_ssm_parameter" "aurora_kms_key_arn" {
  name = "${lower(var.environment)}-aurora-encryption-key"
}

module "guided-match" {
  source                          = "../../guided-match"
  environment                     = var.environment
  vpc_id                          = data.aws_ssm_parameter.vpc_id.value
  availability_zones              = var.availability_zones
  private_db_subnet_ids           = split(",", data.aws_ssm_parameter.private_db_subnet_ids.value)
  deletion_protection             = var.deletion_protection
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  backup_retention_period         = var.backup_retention_period
  cluster_instances               = var.guided_match_cluster_instances
  db_instance_class               = var.db_instance_class
  snapshot_identifier             = var.snapshot_identifier
  kms_key_id                      = data.aws_ssm_parameter.aurora_kms_key_arn.value
}
