/**
 * # Variables for AWS SageMaker Endpoint Configuration Module
 */

variable "name" {
  description = "The name of the endpoint configuration"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique endpoint configuration name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "Amazon Resource Name (ARN) of a AWS Key Management Service key that Amazon SageMaker uses to encrypt data on the storage volume attached to the ML compute instance that hosts the endpoint"
  type        = string
  default     = null
}

variable "production_variants" {
  description = "List of production variants for the endpoint configuration"
  type        = any
}

variable "shadow_production_variants" {
  description = "List of shadow production variants for the endpoint configuration"
  type        = any
  default     = null
}

variable "data_capture_config" {
  description = "Specifies the parameters to capture input/output of SageMaker models endpoints"
  type        = any
  default     = null
}

variable "async_inference_config" {
  description = "Specifies configuration for how an endpoint performs asynchronous inference"
  type        = any
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
