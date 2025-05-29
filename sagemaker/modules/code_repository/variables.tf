/**
 * # Variables for AWS SageMaker Code Repository Module
 */

variable "code_repository_name" {
  description = "The name of the Code Repository (must be unique)"
  type        = string
}

variable "git_config" {
  description = "Specifies details about the repository"
  type        = object({
    repository_url = string
    branch         = optional(string)
    secret_arn     = optional(string)
  })
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
