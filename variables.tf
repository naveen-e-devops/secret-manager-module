variable "stages" {
  type        = set(string)
  description = "List of stages to create resources"
  default     = ["dev"]
}