variable "name" {
  type        = string
  description = "The name of the SageMaker model."
  default     = "terraform-sg"
}

variable "namespace" {
  description = "Namespace for naming convention"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}


variable "primary_container" {
  type = object({
    image              = string
    mode               = optional(string)
    model_data_url     = optional(string)
    model_package_name = optional(string)
    container_hostname = optional(string)
    environment        = optional(map(string))
    image_config = optional(object({
      repository_access_mode = string
      repository_auth_config = optional(object({
        repository_credentials_provider_arn = string
      }))
    }))
    inference_specification_name = optional(string)
    multi_model_config = optional(object({
      model_cache_setting = string
    }))
    model_data_source = optional(object({
      s3_data_source = object({
        compression_type = string
        s3_data_type     = string
        s3_uri           = string
        model_access_config = optional(object({
          accept_eula = bool
        }))
      })
    }))
  })
  #   default     = null
  default = {
    image          = "683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-scikit-learn:1.0-1-cpu-py3"
    model_data_url = "s3://your-sagemaker-model-bucket-21-05-25/model/model.tar.gz"
    environment    = {}
  }
  description = "Primary container block"
}

variable "container" {
  type        = list(any)
  default     = null
  description = "List of containers for inference pipeline (alternative to primary_container)"
}

variable "inference_execution_config" {
  type = object({
    mode = string
  })
  default     = null
  description = "Multi-container execution configuration"
}

variable "enable_network_isolation" {
  type        = bool
  default     = null
  description = "Isolate the model container from external network"
}

variable "vpc_config" {
  type = object({
    security_group_ids = list(string)
    subnets            = list(string)
  })
  default     = null
  description = "VPC configuration for the model"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to assign to the SageMaker model"
}


##################################################
# SageManker - Configuration
##################################################


variable "name_prefix" {
  type        = string
  description = "(Optional) Prefix for the endpoint configuration name. Conflicts with name."
  default     = null
}

variable "kms_key_arn" {
  type        = string
  description = "(Optional) ARN of the KMS key to encrypt storage volume data."
  default     = null
}

variable "production_variants" {
  description = "(Required) List of production variant configurations."
  type = list(object({
    variant_name                                      = optional(string)
    model_name                                        = optional(string)
    initial_instance_count                            = optional(number)
    instance_type                                     = optional(string)
    accelerator_type                                  = optional(string)
    container_startup_health_check_timeout_in_seconds = optional(number)
    core_dump_config = optional(object({
      destination_s3_uri = string
      kms_key_id         = string
    }))
    enable_ssm_access                      = optional(bool)
    inference_ami_version                  = optional(string)
    initial_variant_weight                 = optional(number)
    model_data_download_timeout_in_seconds = optional(number)
    routing_config = optional(object({
      routing_strategy = string
    }))
    serverless_config = optional(object({
      max_concurrency         = number
      memory_size_in_mb       = number
      provisioned_concurrency = optional(number)
    }))
    managed_instance_scaling = optional(object({
      status             = optional(string)
      min_instance_count = optional(number)
      max_instance_count = optional(number)
    }))
    volume_size_in_gb = optional(number)
  }))
  default = [
    {
      variant_name = "AllTraffic"
      #   model_name             = "default-model"
      initial_instance_count = 1
      instance_type          = "ml.m5.large"
      initial_variant_weight = 1.0
    }
  ]
}

variable "shadow_production_variants" {
  description = "(Optional) List of shadow production variant configurations."
  type = list(object({
    variant_name           = optional(string)
    model_name             = string
    initial_instance_count = optional(number)
    instance_type          = optional(string)
    initial_variant_weight = optional(number)
  }))
  default = []
}

variable "data_capture_config" {
  description = "(Optional) Configuration for capturing input/output data."
  type = object({
    initial_sampling_percentage = number
    destination_s3_uri          = string
    kms_key_id                  = optional(string)
    enable_capture              = optional(bool)
    capture_options = list(object({
      capture_mode = string
    }))
    capture_content_type_header = optional(object({
      csv_content_types  = optional(list(string))
      json_content_types = optional(list(string))
    }))
  })
  default = null
}

variable "async_inference_config" {
  description = "(Optional) Configuration for asynchronous inference."
  type = object({
    output_config = object({
      s3_output_path  = string
      s3_failure_path = optional(string)
      kms_key_id      = optional(string)
      notification_config = optional(object({
        include_inference_response_in = optional(string)
        error_topic                   = optional(string)
        success_topic                 = optional(string)
      }))
    })
    client_config = optional(object({
      max_concurrent_invocations_per_instance = optional(number)
    }))
  })
  default = null
}

##########################################
##########################################

# variable "endpoint_config_name" {
#   description = "The name of the endpoint configuration to use"
#   type        = string
# }

variable "deployment_config" {
  description = "Deployment configuration block"
  type = object({
    blue_green_update_policy = optional(object({
      traffic_routing_configuration = object({
        type                      = string
        wait_interval_in_seconds = number
        canary_size = optional(object({
          type  = string
          value = number
        }))
        linear_step_size = optional(object({
          type  = string
          value = number
        }))
      })
      maximum_execution_timeout_in_seconds = optional(number)
      termination_wait_in_seconds          = optional(number)
    }))
    auto_rollback_configuration = optional(object({
      alarms = list(object({
        alarm_name = string
      }))
    }))
    rolling_update_policy = optional(object({
      wait_interval_in_seconds             = number
      maximum_execution_timeout_in_seconds = optional(number)
      maximum_batch_size = object({
        type  = string
        value = number
      })
      rollback_maximum_batch_size = optional(object({
        type  = string
        value = number
      }))
    }))
  })
  default = null
}