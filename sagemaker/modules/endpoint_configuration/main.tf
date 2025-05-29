/**
 * # AWS SageMaker Endpoint Configuration Module
 *
 * This module creates a SageMaker endpoint configuration with configurable settings.
 */

resource "aws_sagemaker_endpoint_configuration" "this" {
  name        = var.name
  name_prefix = var.name_prefix
  kms_key_arn = var.kms_key_arn

  dynamic "production_variants" {
    for_each = var.production_variants
    content {
      variant_name           = lookup(production_variants.value, "variant_name", null)
      model_name             = production_variants.value.model_name
      initial_instance_count = lookup(production_variants.value, "initial_instance_count", null)
      instance_type          = lookup(production_variants.value, "instance_type", null)
      initial_variant_weight = lookup(production_variants.value, "initial_variant_weight", null)
      accelerator_type       = lookup(production_variants.value, "accelerator_type", null)
      
      dynamic "core_dump_config" {
        for_each = lookup(production_variants.value, "core_dump_config", null) != null ? [production_variants.value.core_dump_config] : []
        content {
          destination_s3_uri = core_dump_config.value.destination_s3_uri
          kms_key_id         = core_dump_config.value.kms_key_id
        }
      }

      dynamic "serverless_config" {
        for_each = lookup(production_variants.value, "serverless_config", null) != null ? [production_variants.value.serverless_config] : []
        content {
          max_concurrency     = serverless_config.value.max_concurrency
          memory_size_in_mb   = serverless_config.value.memory_size_in_mb
          provisioned_concurrency = lookup(serverless_config.value, "provisioned_concurrency", null)
        }
      }

      dynamic "routing_config" {
        for_each = lookup(production_variants.value, "routing_config", null) != null ? [production_variants.value.routing_config] : []
        content {
          routing_strategy = routing_config.value.routing_strategy
        }
      }

      dynamic "managed_instance_scaling" {
        for_each = lookup(production_variants.value, "managed_instance_scaling", null) != null ? [production_variants.value.managed_instance_scaling] : []
        content {
          status            = lookup(managed_instance_scaling.value, "status", null)
          min_instance_count = lookup(managed_instance_scaling.value, "min_instance_count", null)
          max_instance_count = lookup(managed_instance_scaling.value, "max_instance_count", null)
        }
      }

      container_startup_health_check_timeout_in_seconds = lookup(production_variants.value, "container_startup_health_check_timeout_in_seconds", null)
      model_data_download_timeout_in_seconds = lookup(production_variants.value, "model_data_download_timeout_in_seconds", null)
      volume_size_in_gb = lookup(production_variants.value, "volume_size_in_gb", null)
      enable_ssm_access = lookup(production_variants.value, "enable_ssm_access", null)
      inference_ami_version = lookup(production_variants.value, "inference_ami_version", null)
    }
  }

  dynamic "shadow_production_variants" {
    for_each = var.shadow_production_variants != null ? var.shadow_production_variants : []
    content {
      variant_name           = lookup(shadow_production_variants.value, "variant_name", null)
      model_name             = shadow_production_variants.value.model_name
      initial_instance_count = lookup(shadow_production_variants.value, "initial_instance_count", null)
      instance_type          = lookup(shadow_production_variants.value, "instance_type", null)
      initial_variant_weight = lookup(shadow_production_variants.value, "initial_variant_weight", null)
      accelerator_type       = lookup(shadow_production_variants.value, "accelerator_type", null)
    }
  }

  dynamic "data_capture_config" {
    for_each = var.data_capture_config != null ? [var.data_capture_config] : []
    content {
      initial_sampling_percentage = data_capture_config.value.initial_sampling_percentage
      destination_s3_uri          = data_capture_config.value.destination_s3_uri
      enable_capture              = lookup(data_capture_config.value, "enable_capture", false)
      kms_key_id                  = lookup(data_capture_config.value, "kms_key_id", null)

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
      output_config {
        s3_output_path = async_inference_config.value.output_config.s3_output_path
        s3_failure_path = lookup(async_inference_config.value.output_config, "s3_failure_path", null)
        kms_key_id = lookup(async_inference_config.value.output_config, "kms_key_id", null)

        dynamic "notification_config" {
          for_each = lookup(async_inference_config.value.output_config, "notification_config", null) != null ? [async_inference_config.value.output_config.notification_config] : []
          content {
            success_topic = lookup(notification_config.value, "success_topic", null)
            error_topic = lookup(notification_config.value, "error_topic", null)
            include_inference_response_in = lookup(notification_config.value, "include_inference_response_in", null)
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

  tags = var.tags
}
