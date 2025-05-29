variable "processing_job_name" {
  description = "The name of the processing job"
  type        = string
}

variable "role_arn" {
  description = "The IAM role ARN for the processing job"
  type        = string
}

variable "processing_resources" {
  description = "The resources, including the compute instances and storage volumes, to use for the processing job"
  type = object({
    cluster_config = object({
      instance_count    = number
      instance_type     = string
      volume_size_in_gb = number
      volume_kms_key_id = optional(string)
    })
  })
}

variable "app_specification" {
  description = "Configures the processing job to run a specified Docker container image"
  type = object({
    image_uri            = string
    container_arguments  = optional(list(string))
    container_entrypoint = optional(list(string))
  })
}

variable "processing_inputs" {
  description = "List of inputs for the processing job"
  type = list(object({
    input_name = string
    s3_input = object({
      s3_uri                    = string
      local_path                = string
      s3_data_type              = optional(string)
      s3_data_distribution_type = optional(string)
      s3_input_mode             = optional(string)
      s3_compression_type       = optional(string)
    })
  }))
  default = null
}

variable "processing_output_config" {
  description = "Output configuration for the processing job"
  type = object({
    outputs = object({
      output_name = string
      s3_output = object({
        s3_uri         = string
        local_path     = string
        s3_upload_mode = optional(string)
      })
    })
    kms_key_id = optional(string)
  })
  default = null
}

variable "network_config" {
  description = "Network configuration for the processing job"
  type = object({
    vpc_config = object({
      security_group_ids = list(string)
      subnets            = list(string)
    })
    enable_inter_container_traffic_encryption = optional(bool)
    enable_network_isolation                  = optional(bool)
  })
  default = null
}

variable "experiment_config" {
  description = "Experiment configuration for the processing job"
  type = object({
    experiment_name              = string
    trial_name                   = optional(string)
    trial_component_display_name = optional(string)
  })
  default = null
}

variable "stopping_condition" {
  description = "Stopping condition for the processing job"
  type = object({
    max_runtime_in_seconds = number
  })
}

variable "tags" {
  description = "A map of tags to assign to the processing job"
  type        = map(string)
  default     = {}
}
