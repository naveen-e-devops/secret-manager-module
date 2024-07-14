provider "aws" {
  region = "ap-south-1"
}

data "aws_caller_identity" "current" {}


module "test_creds" {
  for_each                = var.stages
  source                  = "./modules/secret-manager"
  description             = "Testing secrets permission"
  owners                  = ["*naveen"]
  users_with_read_access  = ["siraj"]
  users_with_write_access = ["testuser"]
  stage                   = each.value
  secret_name             = "${each.value}/test-secret1/terraform"
  iam_roles_read_access = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/pim-report-role-${each.value}"
  ]
}
