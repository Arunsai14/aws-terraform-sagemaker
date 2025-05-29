/**
 * # AWS SageMaker Model Module
 *
 * This module creates a SageMaker model with configurable settings.
 */

resource "aws_sagemaker_model" "this" {
  name               = var.name
  execution_role_arn = var.execution_role_arn

  dynamic "primary_container" {
    for_each = var.primary_container != null ? [var.primary_container] : []
    content {
      image              = lookup(primary_container.value, "image", null)
      model_data_url     = lookup(primary_container.value, "model_data_url", null)
      environment        = lookup(primary_container.value, "environment", null)
      mode               = lookup(primary_container.value, "mode", null)
      container_hostname = lookup(primary_container.value, "container_hostname", null)
      model_package_name = lookup(primary_container.value, "model_package_name", null)

      dynamic "image_config" {
        for_each = lookup(primary_container.value, "image_config", null) != null ? [primary_container.value.image_config] : []
        content {
          repository_access_mode = image_config.value.repository_access_mode

          dynamic "repository_auth_config" {
            for_each = lookup(image_config.value, "repository_auth_config", null) != null ? [image_config.value.repository_auth_config] : []
            content {
              repository_credentials_provider_arn = repository_auth_config.value.repository_credentials_provider_arn
            }
          }
        }
      }
    }
  }

  dynamic "container" {
    for_each = var.containers != null ? var.containers : []
    content {
      image              = lookup(container.value, "image", null)
      model_data_url     = lookup(container.value, "model_data_url", null)
      environment        = lookup(container.value, "environment", null)
      mode               = lookup(container.value, "mode", null)
      container_hostname = lookup(container.value, "container_hostname", null)
      model_package_name = lookup(container.value, "model_package_name", null)

      dynamic "image_config" {
        for_each = lookup(container.value, "image_config", null) != null ? [container.value.image_config] : []
        content {
          repository_access_mode = image_config.value.repository_access_mode

          dynamic "repository_auth_config" {
            for_each = lookup(image_config.value, "repository_auth_config", null) != null ? [image_config.value.repository_auth_config] : []
            content {
              repository_credentials_provider_arn = repository_auth_config.value.repository_credentials_provider_arn
            }
          }
        }
      }
    }
  }

  dynamic "inference_execution_config" {
    for_each = var.inference_execution_config != null ? [var.inference_execution_config] : []
    content {
      mode = inference_execution_config.value.mode
    }
  }

  tags = var.tags
}
