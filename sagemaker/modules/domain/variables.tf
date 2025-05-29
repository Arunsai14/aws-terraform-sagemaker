/**
 * # Variables for AWS SageMaker Domain Module
 */

variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "auth_mode" {
  description = "The mode of authentication that members use to access the domain. Valid values are IAM and SSO"
  type        = string
  default     = "IAM"
  validation {
    condition     = contains(["IAM", "SSO"], var.auth_mode)
    error_message = "Valid values for auth_mode are IAM and SSO."
  }
}

variable "vpc_id" {
  description = "The ID of the Amazon Virtual Private Cloud (VPC) that Studio uses for communication"
  type        = string
}

variable "subnet_ids" {
  description = "The VPC subnets that Studio uses for communication"
  type        = list(string)
}

variable "execution_role_arn" {
  description = "The execution role ARN for the domain"
  type        = string
}

variable "kms_key_id" {
  description = "The AWS KMS customer managed CMK used to encrypt the EFS volume attached to the domain"
  type        = string
  default     = null
}

variable "app_network_access_type" {
  description = "Specifies the VPC used for non-EFS traffic. Valid values are PublicInternetOnly and VpcOnly"
  type        = string
  default     = "PublicInternetOnly"
  validation {
    condition     = contains(["PublicInternetOnly", "VpcOnly"], var.app_network_access_type)
    error_message = "Valid values for app_network_access_type are PublicInternetOnly and VpcOnly."
  }
}

variable "security_groups" {
  description = "A list of security group IDs to attach to the user profile"
  type        = list(string)
  default     = null
}

variable "jupyter_server_app_settings" {
  description = "The Jupyter server's app settings"
  type        = any
  default     = null
}

variable "kernel_gateway_app_settings" {
  description = "The kernel gateway app settings"
  type        = any
  default     = null
}

variable "tensor_board_app_settings" {
  description = "The TensorBoard app settings"
  type        = any
  default     = null
}

variable "code_editor_app_settings" {
  description = "The Code Editor application settings"
  type        = any
  default     = null
}

variable "default_space_settings" {
  description = "The default space settings"
  type        = any
  default     = null
}

variable "domain_settings" {
  description = "The domain settings"
  type        = any
  default     = null
}

variable "retention_policy" {
  description = "The retention policy for this domain, which specifies whether resources will be retained after the Domain is deleted"
  type        = any
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
