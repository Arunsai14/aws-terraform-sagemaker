variable "training_job_name" {
  description = "The name of the training job"
  type        = string
}

variable "role_arn" {
  description = "The IAM role ARN for the training job"
  type        = string
}

variable "algorithm_specification" {
  description = "Specifies the training algorithm to be used"
  type = object({
    training_image     = string
    training_input_mode = string
    algorithm_name     = optional(string)
  })
}

variable "hyper_parameters" {
  description = "Hyperparameters for the training job"
  type        = map(string)
  default     = null
}

variable "input_data_config" {
  description = "Input data configuration for the training job"
  type = list(object({
    channel_name = string
    data_source = object({
      s3_data_source = object({
        s3_data_type             = string
        s3_uri                   = string
        s3_data_distribution_type = optional(string)
      })
    })
    content_type     = optional(string)
    compression_type = optional(string)
    input_mode       = optional(string)
  }))
}

variable "output_data_config" {
  description = "Output data configuration for the training job"
  type = object({
    s3_output_path = string
    kms_key_id     = optional(string)
  })
}

variable "resource_config" {
  description = "Resource configuration for the training job"
  type = object({
    instance_type     = string
    instance_count    = number
    volume_size_in_gb = number
    volume_kms_key_id = optional(string)
  })
}

variable "stopping_condition" {
  description = "Stopping condition for the training job"
  type = object({
    max_runtime_in_seconds = number
    max_wait_time_in_seconds = optional(number)
  })
}

variable "checkpoint_config" {
  description = "Checkpoint configuration for the training job"
  type = object({
    s3_uri     = string
    local_path = optional(string)
  })
  default = null
}

variable "debug_hook_config" {
  description = "Debug hook configuration for the training job"
  type = object({
    s3_output_path = string
    collection_configurations = object({
      collection_name = string
      collection_parameters = optional(map(string))
    })
  })
  default = null
}

variable "tensor_board_output_config" {
  description = "TensorBoard output configuration for the training job"
  type = object({
    s3_output_path = string
  })
  default = null
}

variable "experiment_config" {
  description = "Experiment configuration for the training job"
  type = object({
    experiment_name = string
    trial_name = optional(string)
    trial_component_display_name = optional(string)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the training job"
  type        = map(string)
  default     = {}
}
