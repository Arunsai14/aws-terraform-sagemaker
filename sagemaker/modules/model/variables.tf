/**
 * # Variables for AWS SageMaker Model Module
 */

variable "name" {
  description = "The name of the model"
  type        = string
}

variable "execution_role_arn" {
  description = "A role that SageMaker can assume to access model artifacts and docker images for deployment"
  type        = string
}

variable "primary_container" {
  description = "The primary docker image containing inference code that is used when the model is deployed for predictions"
  type        = any
  default     = null
}

variable "containers" {
  description = "Specifies containers in the inference pipeline"
  type        = list(any)
  default     = null
}

variable "inference_execution_config" {
  description = "Specifies details of how containers in a multi-container endpoint are called"
  type        = any
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
