variable "stages" {
  type        = set(string)
  description = "List of stages to create resource"
  default     = ["dev", "stage", "hfe"]
}

variable "description" {
  description = "Description of the secret"
  type        = string
}

variable "owners" {
  description = "List of owner emails"
  type        = list(string)
}

variable "users_with_read_access" {
  description = "List of user IDs with read access (optional)"
  type        = list(string)
  default     = []
}

variable "users_with_write_access" {
  description = "List of user IDs with write access (optional)"
  type        = list(string)
  default     = []
}

variable "iam_roles_read_access" {
  description = "List of IAM role with read access (optional)"
  type        = list(string)
  default     = []
}

variable "secret_name" {
    description = "Name of the secret"
    type = string
    default = ""
}

variable "stage" {
  description = "Stage name"
  type        = string
}