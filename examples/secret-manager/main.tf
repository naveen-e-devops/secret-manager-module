provider "aws" {
  region = "ap-south-1"
}

data "aws_caller_identity" "current" {}

variable "stages" {
  type        = set(string)
  description = "List of stages to create resources"
  default     = ["dev"]
}

variable "devops_ids" {
  type        = list(string)
  description = "List of devops email ids"
  default     = ["naveen", "siraj"]
}


locals {
  write_access = [for email in var.devops_ids : "*${email}"]
  current_time = formatdate("YYYYMMDDHHmmss", timestamp())
}

module "test_creds" {
  source                  = "../../modules/secret-manager"
  description             = "Testing secrets permission"
  owners                  = ["naveen"]
  users_with_read_access  = ["naveen", "siraj"]
  users_with_write_access = ["naveen", "siraj"]
  secret_name             = "dev/test-secret1/terraform-${local.current_time}"
  iam_roles_read_access = [ "arn:aws:iam::814445629751:user/naveen", 
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/pim-report-role-dev"
  ]
}
