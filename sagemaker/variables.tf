/**
 * # Variables for AWS SageMaker Module
 */

# General variables
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# Domain variables
variable "create_domain" {
  description = "Whether to create a SageMaker domain"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "The domain name"
  type        = string
  default     = null
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
  default     = null
}

variable "subnet_ids" {
  description = "The VPC subnets that Studio uses for communication"
  type        = list(string)
  default     = []
}

variable "domain_execution_role_arn" {
  description = "The execution role ARN for the domain"
  type        = string
  default     = null
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

variable "domain_security_groups" {
  description = "A list of security group IDs to attach to the domain"
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

# Notebook variables
variable "create_notebook" {
  description = "Whether to create a SageMaker notebook instance"
  type        = bool
  default     = false
}

variable "notebook_name" {
  description = "The name of the notebook instance (must be unique)"
  type        = string
  default     = null
}

variable "notebook_role_arn" {
  description = "The ARN of the IAM role to be used by the notebook instance"
  type        = string
  default     = null
}

variable "notebook_instance_type" {
  description = "The name of ML compute instance type"
  type        = string
  default     = "ml.t3.medium"
}

variable "notebook_platform_identifier" {
  description = "The platform identifier of the notebook instance runtime environment"
  type        = string
  default     = null
}

variable "notebook_volume_size" {
  description = "The size, in GB, of the ML storage volume to attach to the notebook instance"
  type        = number
  default     = 5
}

variable "notebook_subnet_id" {
  description = "The VPC subnet ID for the notebook instance"
  type        = string
  default     = null
}

variable "notebook_security_groups" {
  description = "The associated security groups for the notebook instance"
  type        = list(string)
  default     = []
}

variable "notebook_kms_key_id" {
  description = "The AWS KMS key that Amazon SageMaker uses to encrypt notebook instance"
  type        = string
  default     = null
}

variable "notebook_lifecycle_config_name" {
  description = "The name of a lifecycle configuration to associate with the notebook instance"
  type        = string
  default     = null
}

variable "notebook_direct_internet_access" {
  description = "Set to Disabled to disable internet access to notebook. Requires security_groups and subnet_id to be set"
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.notebook_direct_internet_access)
    error_message = "Valid values for notebook_direct_internet_access are Enabled and Disabled."
  }
}

variable "notebook_instance_metadata_service_configuration" {
  description = "Information on the IMDS configuration of the notebook instance"
  type        = any
  default     = null
}

variable "notebook_root_access" {
  description = "Whether root access is Enabled or Disabled for users of the notebook instance"
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.notebook_root_access)
    error_message = "Valid values for notebook_root_access are Enabled and Disabled."
  }
}

variable "notebook_default_code_repository" {
  description = "The Git repository associated with the notebook instance as its default code repository"
  type        = string
  default     = null
}

variable "notebook_additional_code_repositories" {
  description = "An array of up to three Git repositories to associate with the notebook instance"
  type        = list(string)
  default     = null
}

# Model variables
variable "create_model" {
  description = "Whether to create a SageMaker model"
  type        = bool
  default     = false
}

variable "model_name" {
  description = "The name of the model"
  type        = string
  default     = null
}

variable "model_execution_role_arn" {
  description = "A role that SageMaker can assume to access model artifacts and docker images for deployment"
  type        = string
  default     = null
}

variable "model_primary_container" {
  description = "The primary docker image containing inference code that is used when the model is deployed for predictions"
  type        = any
  default     = {}
}

variable "model_containers" {
  description = "Specifies containers in the inference pipeline"
  type        = list(any)
  default     = null
}

variable "model_inference_execution_config" {
  description = "Specifies details of how containers in a multi-container endpoint are called"
  type        = any
  default     = null
}

# Endpoint Configuration variables
variable "create_endpoint_config" {
  description = "Whether to create a SageMaker endpoint configuration"
  type        = bool
  default     = false
}

variable "endpoint_config_name" {
  description = "The name of the endpoint configuration"
  type        = string
  default     = null
}

variable "endpoint_config_name_prefix" {
  description = "Creates a unique endpoint configuration name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "endpoint_config_kms_key_arn" {
  description = "Amazon Resource Name (ARN) of a AWS Key Management Service key that Amazon SageMaker uses to encrypt data on the storage volume attached to the ML compute instance that hosts the endpoint"
  type        = string
  default     = null
}

variable "endpoint_config_production_variants" {
  description = "List of production variants for the endpoint configuration"
  type        = any
  default     = []
}

variable "endpoint_config_shadow_production_variants" {
  description = "List of shadow production variants for the endpoint configuration"
  type        = any
  default     = null
}

variable "endpoint_config_data_capture_config" {
  description = "Specifies the parameters to capture input/output of SageMaker models endpoints"
  type        = any
  default     = null
}

variable "endpoint_config_async_inference_config" {
  description = "Specifies configuration for how an endpoint performs asynchronous inference"
  type        = any
  default     = null
}

# Endpoint variables
variable "create_endpoint" {
  description = "Whether to create a SageMaker endpoint"
  type        = bool
  default     = false
}

variable "endpoint_name" {
  description = "The name of the endpoint"
  type        = string
  default     = null
}

variable "endpoint_config_name" {
  description = "The name of the endpoint configuration to use"
  type        = string
  default     = null
}

variable "endpoint_deployment_config" {
  description = "The deployment configuration for an endpoint, which contains the desired deployment strategy and rollback configurations"
  type        = any
  default     = {}
}

# Code Repository variables
variable "create_code_repository" {
  description = "Whether to create a SageMaker code repository"
  type        = bool
  default     = false
}

variable "code_repository_name" {
  description = "The name of the Code Repository (must be unique)"
  type        = string
  default     = null
}

variable "code_repository_git_config" {
  description = "Specifies details about the repository"
  type        = any
  default     = null
}
