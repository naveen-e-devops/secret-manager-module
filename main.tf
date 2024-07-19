provider "aws" {
  region = "ap-south-1"
}

data "aws_caller_identity" "current" {}


module "test_creds" {
  source                  = "./modules/secret-manager"
  description             = "Testing secrets permission"
  owners                  = ["naveen"]
  users_with_read_access  = ["siraj", "*naveen"]
  users_with_write_access = ["testuser", "naveen"]
  secret_name             = "dev/test-secret11233/terraform1"
  iam_roles_read_access = ["arn:aws:iam::814445629751:user/naveen",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/pim-report-role"
  ]
}
