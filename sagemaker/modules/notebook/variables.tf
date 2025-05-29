/**
 * # Variables for AWS SageMaker Notebook Instance Module
 */

variable "name" {
  description = "The name of the notebook instance (must be unique)"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role to be used by the notebook instance"
  type        = string
}

variable "instance_type" {
  description = "The name of ML compute instance type"
  type        = string
  default     = "ml.t3.medium"
}

variable "platform_identifier" {
  description = "The platform identifier of the notebook instance runtime environment"
  type        = string
  default     = null
}

variable "volume_size" {
  description = "The size, in GB, of the ML storage volume to attach to the notebook instance"
  type        = number
  default     = 5
}

variable "subnet_id" {
  description = "The VPC subnet ID"
  type        = string
  default     = null
}

variable "security_groups" {
  description = "The associated security groups"
  type        = list(string)
  default     = null
}

variable "kms_key_id" {
  description = "The AWS KMS key that Amazon SageMaker uses to encrypt the notebook instance"
  type        = string
  default     = null
}

variable "lifecycle_config_name" {
  description = "The name of a lifecycle configuration to associate with the notebook instance"
  type        = string
  default     = null
}

variable "direct_internet_access" {
  description = "Set to Disabled to disable internet access to notebook. Requires security_groups and subnet_id to be set"
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.direct_internet_access)
    error_message = "Valid values for direct_internet_access are Enabled and Disabled."
  }
}

variable "instance_metadata_service_configuration" {
  description = "Information on the IMDS configuration of the notebook instance"
  type        = any
  default     = null
}

variable "root_access" {
  description = "Whether root access is Enabled or Disabled for users of the notebook instance"
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.root_access)
    error_message = "Valid values for root_access are Enabled and Disabled."
  }
}

variable "default_code_repository" {
  description = "The Git repository associated with the notebook instance as its default code repository"
  type        = string
  default     = null
}

variable "additional_code_repositories" {
  description = "An array of up to three Git repositories to associate with the notebook instance"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
