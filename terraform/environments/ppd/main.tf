#########################################################
# Environment: PPD
#
# Deploy SCALE FaT databases
#########################################################
terraform {
  backend "s3" {
    bucket         = "scale-terraform-state"
    key            = "ccs-scale-infra-db-fat-ppd"
    region         = "eu-west-2"
    dynamodb_table = "scale_terraform_state_lock"
    encrypt        = true
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

locals {
  environment        = "PPD"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

data "aws_ssm_parameter" "aws_account_id" {
  name = "account-id-${lower(local.environment)}"
}

module "deploy" {
  source                          = "../../modules/configs/deploy-all"
  aws_account_id                  = data.aws_ssm_parameter.aws_account_id.value
  environment                     = local.environment
  availability_zones              = local.availability_zones
  deletion_protection             = false
  skip_final_snapshot             = false
  enabled_cloudwatch_logs_exports = ["postgresql"]
  backup_retention_period         = 35
  guided_match_cluster_instances  = length(local.availability_zones)
  db_instance_class               = "db.r5.xlarge"
  snapshot_identifier             = "final-snaphot-guided-match-0f4dbc34-ff47-0a08-eb51-30798fb5760c"
}
