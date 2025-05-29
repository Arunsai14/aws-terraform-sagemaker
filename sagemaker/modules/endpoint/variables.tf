/**
 * # Variables for AWS SageMaker Endpoint Module
 */

variable "name" {
  description = "The name of the endpoint"
  type        = string
}

variable "endpoint_config_name" {
  description = "The name of the endpoint configuration to use"
  type        = string
}

variable "deployment_config" {
  description = "The deployment configuration for an endpoint, which contains the desired deployment strategy and rollback configurations"
  type        = any
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
