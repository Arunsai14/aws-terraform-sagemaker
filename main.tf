################################################################################
## defaults
################################################################################
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.6"

  environment = terraform.workspace
  project     = "terraform-aws-arc-alb"

  extra_tags = {
    Example = "True"
  }
}
###################################################################################
# sagemaker model
###################################################################################
resource "aws_sagemaker_model" "this" {
  name               = var.name
  execution_role_arn = aws_iam_role.sagemaker_execution_role.arn
  tags               = var.tags

  dynamic "primary_container" {
    for_each = var.primary_container == null ? [] : [var.primary_container]
    content {
      image                        = primary_container.value.image
      mode                         = lookup(primary_container.value, "mode", null)
      model_data_url               = lookup(primary_container.value, "model_data_url", "null") 
      model_package_name           = lookup(primary_container.value, "model_package_name", null)
      container_hostname           = lookup(primary_container.value, "container_hostname", null)
      environment                  = lookup(primary_container.value, "environment", null)
      inference_specification_name = lookup(primary_container.value, "inference_specification_name", null)

      dynamic "image_config" {
        for_each = lookup(primary_container.value, "image_config", null) == null ? [] : [primary_container.value.image_config]
        content {
          repository_access_mode = image_config.value.repository_access_mode

          dynamic "repository_auth_config" {
            for_each = lookup(image_config.value, "repository_auth_config", null) == null ? [] : [image_config.value.repository_auth_config]
            content {
              repository_credentials_provider_arn = repository_auth_config.value.repository_credentials_provider_arn
            }
          }
        }
      }

      dynamic "multi_model_config" {
        for_each = lookup(primary_container.value, "multi_model_config", null) == null ? [] : [primary_container.value.multi_model_config]
        content {
          model_cache_setting = multi_model_config.value.model_cache_setting
        }
      }

      dynamic "model_data_source" {
        for_each = lookup(primary_container.value, "model_data_source", null) == null ? [] : [primary_container.value.model_data_source]
        content {
          dynamic "s3_data_source" {
            for_each = model_data_source.value.s3_data_source == null ? [] : [model_data_source.value.s3_data_source]
            content {
              compression_type = s3_data_source.value.compression_type
              s3_data_type     = s3_data_source.value.s3_data_type
              s3_uri           = s3_data_source.value.s3_uri

              dynamic "model_access_config" {
                for_each = lookup(s3_data_source.value, "model_access_config", null) == null ? [] : [s3_data_source.value.model_access_config]
                content {
                  accept_eula = model_access_config.value.accept_eula
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "container" {
    for_each = var.container == null ? [] : var.container
    content {
      image          = container.value.image
      model_data_url = lookup(container.value, "model_data_url", null)
      environment    = lookup(container.value, "environment", null)
    }
  }

  dynamic "inference_execution_config" {
    for_each = var.inference_execution_config == null ? [] : [var.inference_execution_config]
    content {
      mode = inference_execution_config.value.mode
    }
  }

  enable_network_isolation = var.enable_network_isolation

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnets            = vpc_config.value.subnets
    }
  }
}


###################################################################################
# SageManker - Configuration
###################################################################################
resource "aws_sagemaker_endpoint_configuration" "this" {
  name        = "${var.name}-endpoint-configuration"
  name_prefix = var.name_prefix
  kms_key_arn = var.kms_key_arn
  tags        = var.tags

  dynamic "production_variants" {
    for_each = var.production_variants
    content {
      variant_name                                      = lookup(production_variants.value, "variant_name", null)
      model_name                                        = coalesce(production_variants.value.model_name, aws_sagemaker_model.this.name)
      initial_instance_count                            = lookup(production_variants.value, "initial_instance_count", null)
      instance_type                                     = lookup(production_variants.value, "instance_type", null)
      accelerator_type                                  = lookup(production_variants.value, "accelerator_type", null)
      container_startup_health_check_timeout_in_seconds = lookup(production_variants.value, "container_startup_health_check_timeout_in_seconds", null)
      enable_ssm_access                                 = lookup(production_variants.value, "enable_ssm_access", null)
      inference_ami_version                             = lookup(production_variants.value, "inference_ami_version", null)
      initial_variant_weight                            = lookup(production_variants.value, "initial_variant_weight", null)
      model_data_download_timeout_in_seconds            = lookup(production_variants.value, "model_data_download_timeout_in_seconds", null)
      volume_size_in_gb                                 = lookup(production_variants.value, "volume_size_in_gb", null)

      dynamic "routing_config" {
        for_each = lookup(production_variants.value, "routing_config", null) != null ? [production_variants.value.routing_config] : []
        content {
          routing_strategy = routing_config.value.routing_strategy
        }
      }

      dynamic "serverless_config" {
        for_each = lookup(production_variants.value, "serverless_config", null) != null ? [production_variants.value.serverless_config] : []
        content {
          max_concurrency         = serverless_config.value.max_concurrency
          memory_size_in_mb       = serverless_config.value.memory_size_in_mb
          provisioned_concurrency = lookup(serverless_config.value, "provisioned_concurrency", null)
        }
      }

      dynamic "managed_instance_scaling" {
        for_each = lookup(production_variants.value, "managed_instance_scaling", null) != null ? [production_variants.value.managed_instance_scaling] : []
        content {
          status             = lookup(managed_instance_scaling.value, "status", null)
          min_instance_count = lookup(managed_instance_scaling.value, "min_instance_count", null)
          max_instance_count = lookup(managed_instance_scaling.value, "max_instance_count", null)
        }
      }

      dynamic "core_dump_config" {
        for_each = lookup(production_variants.value, "core_dump_config", null) != null ? [production_variants.value.core_dump_config] : []
        content {
          destination_s3_uri = core_dump_config.value.destination_s3_uri
          kms_key_id         = core_dump_config.value.kms_key_id
        }
      }
    }
  }

  dynamic "shadow_production_variants" {
    for_each = var.shadow_production_variants
    content {
      variant_name           = lookup(shadow_production_variants.value, "variant_name", null)
      model_name             = lookup(shadow_production_variants.value, "model_name", null)
      initial_instance_count = lookup(shadow_production_variants.value, "initial_instance_count", null)
      instance_type          = lookup(shadow_production_variants.value, "instance_type", null)
      initial_variant_weight = lookup(shadow_production_variants.value, "initial_variant_weight", null)
    }
  }

  dynamic "data_capture_config" {
    for_each = var.data_capture_config != null ? [var.data_capture_config] : []
    content {
      initial_sampling_percentage = data_capture_config.value.initial_sampling_percentage
      destination_s3_uri          = data_capture_config.value.destination_s3_uri
      kms_key_id                  = lookup(data_capture_config.value, "kms_key_id", null)
      enable_capture              = lookup(data_capture_config.value, "enable_capture", null)

      dynamic "capture_options" {
        for_each = data_capture_config.value.capture_options
        content {
          capture_mode = capture_options.value.capture_mode
        }
      }

      dynamic "capture_content_type_header" {
        for_each = lookup(data_capture_config.value, "capture_content_type_header", null) != null ? [data_capture_config.value.capture_content_type_header] : []
        content {
          csv_content_types  = lookup(capture_content_type_header.value, "csv_content_types", null)
          json_content_types = lookup(capture_content_type_header.value, "json_content_types", null)
        }
      }
    }
  }

  dynamic "async_inference_config" {
    for_each = var.async_inference_config != null ? [var.async_inference_config] : []
    content {
      dynamic "output_config" {
        for_each = [async_inference_config.value.output_config]
        content {
          s3_output_path  = output_config.value.s3_output_path
          s3_failure_path = lookup(output_config.value, "s3_failure_path", null)
          kms_key_id      = lookup(output_config.value, "kms_key_id", null)

          dynamic "notification_config" {
            for_each = lookup(output_config.value, "notification_config", null) != null ? [output_config.value.notification_config] : []
            content {
              include_inference_response_in = lookup(notification_config.value, "include_inference_response_in", null)
              error_topic                   = lookup(notification_config.value, "error_topic", null)
              success_topic                 = lookup(notification_config.value, "success_topic", null)
            }
          }
        }
      }

      dynamic "client_config" {
        for_each = lookup(async_inference_config.value, "client_config", null) != null ? [async_inference_config.value.client_config] : []
        content {
          max_concurrent_invocations_per_instance = lookup(client_config.value, "max_concurrent_invocations_per_instance", null)
        }
      }
    }
  }
}
###################################################################################
###################### sagemaker-endpoint #####################
###################################################################################
resource "aws_sagemaker_endpoint" "this" {
  name                 = "${var.name}-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.this.name

  tags = var.tags

  dynamic "deployment_config" {
    for_each = var.deployment_config != null ? [1] : []
    content {
      dynamic "blue_green_update_policy" {
        for_each = lookup(var.deployment_config, "blue_green_update_policy", null) != null ? [1] : []
        content {
          dynamic "traffic_routing_configuration" {
            for_each = [var.deployment_config.blue_green_update_policy.traffic_routing_configuration]
            content {
              type                      = traffic_routing_configuration.value.type
              wait_interval_in_seconds = traffic_routing_configuration.value.wait_interval_in_seconds
              canary_size {
                type  = lookup(traffic_routing_configuration.value.canary_size, "type", null)
                value = lookup(traffic_routing_configuration.value.canary_size, "value", null)
              }
              linear_step_size {
                type  = lookup(traffic_routing_configuration.value.linear_step_size, "type", null)
                value = lookup(traffic_routing_configuration.value.linear_step_size, "value", null)
              }
            }
          }

          maximum_execution_timeout_in_seconds = lookup(var.deployment_config.blue_green_update_policy, "maximum_execution_timeout_in_seconds", null)
          termination_wait_in_seconds          = lookup(var.deployment_config.blue_green_update_policy, "termination_wait_in_seconds", null)
        }
      }

      dynamic "auto_rollback_configuration" {
        for_each = lookup(var.deployment_config, "auto_rollback_configuration", null) != null ? [1] : []
        content {
          dynamic "alarms" {
            for_each = var.deployment_config.auto_rollback_configuration.alarms
            content {
              alarm_name = alarms.value.alarm_name
            }
          }
        }
      }

      dynamic "rolling_update_policy" {
        for_each = lookup(var.deployment_config, "rolling_update_policy", null) != null ? [1] : []
        content {
          maximum_execution_timeout_in_seconds = lookup(var.deployment_config.rolling_update_policy, "maximum_execution_timeout_in_seconds", null)
          wait_interval_in_seconds             = var.deployment_config.rolling_update_policy.wait_interval_in_seconds

          maximum_batch_size {
            type  = var.deployment_config.rolling_update_policy.maximum_batch_size.type
            value = var.deployment_config.rolling_update_policy.maximum_batch_size.value
          }

          rollback_maximum_batch_size {
            type  = lookup(var.deployment_config.rolling_update_policy.rollback_maximum_batch_size, "type", null)
            value = lookup(var.deployment_config.rolling_update_policy.rollback_maximum_batch_size, "value", null)
          }
        }
      }
    }
  }
}
###################################################################################
#### iam 
###################################################################################
resource "aws_iam_role" "sagemaker_execution_role" {
  name = "sagemaker-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "sagemaker.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}