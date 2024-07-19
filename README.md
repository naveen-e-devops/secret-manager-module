# tpci-aws-secrets

Create and manage tpci secrets in aws secret manager

## How to Configure a New Secret

1. In the root directory.
2. Edit the `main.tf` file to configure your secret. Here is an example configuration:

  ```hcl

module "test_creds" {
  for_each                = var.stages
  source                  = "./modules/secret-manager"
  description             = "Testing secrets permission"
  owners                  = ["v-user1@pokemon.com"]
  users_with_read_access  = ["*v-user1@pokemon.com", "*v-user2@pokemon.com", ]
  users_with_write_access = ["*v-user1@pokemon.com", "*v-user2@pokemon.com", ]
  stage                   = each.value
  secret_name             = "${each.value}/secret/terraform"
  iam-user-role           = var.iam-user-role
  iam_roles_read_access = [var.iam-user-role,
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/test-service-role-${each.value}"
  ]
}
```
3. Submit a merge request with the changes.

## Variables for Secret

description: (Required) Description of the secret.
owners: (Required) for tagging
users_with_read_access: (Required) List of users who have read access to the secret. Example: ["*v-readuser@pokemon.com"]
users_with_write_access: (Required) List of users who have write access to the secret. Example: ["*v-writeuser@pokemon.com"]
iam_roles_read_access: Lambda execution role ARN to access secret

## Updating Users

To update the users with access to the secret:

Edit the main.tf file to modify the owners, users_with_read_access, or users_with_write_access variables.
Submit a merge request with the changes.

## How to Remove a Secret

Comment out or remove the secret configuration block from the main.tf file.

## Maintaining this Project ( FOR DEVOPS TEAM)

Prerequisites

Terraform installed on your machine. Follow the instructions here to install Terraform.
AWS CLI configured with appropriate credentials.

## How to import existing secret into terraform

1. In the root directory.
2. Edit the `main.tf` file to import existing secret.

  ```hcl

  module "test_creds" {
  for_each                = var.stages
  source                  = "./modules/secret-manager"
  description             = "Testing secrets permission"
  owners                  = ["v-user1@pokemon.com"]
  users_with_read_access  = ["*v-user1@pokemon.com", "*v-user2@pokemon.com", ]
  users_with_write_access = ["*v-user1@pokemon.com", "*v-user2@pokemon.com", ]
  stage                   = each.value
  secret_name             = "${each.value}/secret/terraform"
  iam-user-role           = var.iam-user-role
  iam_roles_read_access = [var.iam-user-role,
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/test-service-role-${each.value}"
  ]
}
```
3. Run the following Terraform import commands to import the existing secret and its policy into Terraform's state.

```hcl
terraform import -var-file=non-prod.tfvars module.existing_secret.aws_secretsmanager_secret.secret <secret_arn>
terraform import -var-file=non-prod.tfvars module.existing_secret.aws_secretsmanager_secret_policy.policy <secret_arn>
```

Ex: terraform import -var-file=non-prod.tfvars module.test_creds.aws_secretsmanager_secret.secret arn:aws:secretsmanager:us-west-2:053655145506:secret:test-user-creds-q89qdZ

terraform import -var-file=non-prod.tfvars module.test_creds.aws_secretsmanager_secret_policy.policy arn:aws:secretsmanager:us-west-2:053655145506:secret:test-user-creds-q89qdZ
