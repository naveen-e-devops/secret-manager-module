provider "aws" {
  region = "ap-south-1"
}

data "aws_caller_identity" "current" {}

variable "stages" {
  type        = set(string)
  description = "List of stages to create resources"
  default     = ["dev"]
}

locals {
  current_time = formatdate("YYYYMMDDHHmmss", timestamp())
}

module "test_creds" {
  for_each                = var.stages
  source                  = "../../modules/secret-manager"
  description             = "Testing secrets permission"
  owners                  = ["naveen"]
  users_with_read_access  = ["siraj"]
  users_with_write_access = ["testuser"]
  stage                   = each.value
  secret_name             = "${each.value}/test-secret1/terraform-${local.current_time}"
  iam_roles_read_access = [ "arn:aws:iam::814445629751:user/naveen", 
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/pim-report-role-${each.value}"
  ]
}
