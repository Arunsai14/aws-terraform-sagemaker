/**
 * # AWS SageMaker Domain Module
 *
 * This module creates a SageMaker domain with configurable settings.
 */

resource "aws_sagemaker_domain" "this" {
  domain_name = var.domain_name
  auth_mode   = var.auth_mode
  vpc_id      = var.vpc_id
  subnet_ids  = var.subnet_ids

  default_user_settings {
    execution_role = var.execution_role_arn

    dynamic "jupyter_server_app_settings" {
      for_each = var.jupyter_server_app_settings != null ? [var.jupyter_server_app_settings] : []
      content {
        dynamic "default_resource_spec" {
          for_each = jupyter_server_app_settings.value.default_resource_spec != null ? [jupyter_server_app_settings.value.default_resource_spec] : []
          content {
            instance_type        = lookup(default_resource_spec.value, "instance_type", null)
            sagemaker_image_arn  = lookup(default_resource_spec.value, "sagemaker_image_arn", null)
          }
        }
      }
    }

    dynamic "kernel_gateway_app_settings" {
      for_each = var.kernel_gateway_app_settings != null ? [var.kernel_gateway_app_settings] : []
      content {
        dynamic "default_resource_spec" {
          for_each = kernel_gateway_app_settings.value.default_resource_spec != null ? [kernel_gateway_app_settings.value.default_resource_spec] : []
          content {
            instance_type        = lookup(default_resource_spec.value, "instance_type", null)
            sagemaker_image_arn  = lookup(default_resource_spec.value, "sagemaker_image_arn", null)
          }
        }

        dynamic "custom_image" {
          for_each = lookup(kernel_gateway_app_settings.value, "custom_images", [])
          content {
            app_image_config_name = custom_image.value.app_image_config_name
            image_name            = custom_image.value.image_name
            image_version_number  = lookup(custom_image.value, "image_version_number", null)
          }
        }
      }
    }

    dynamic "tensor_board_app_settings" {
      for_each = var.tensor_board_app_settings != null ? [var.tensor_board_app_settings] : []
      content {
        dynamic "default_resource_spec" {
          for_each = tensor_board_app_settings.value.default_resource_spec != null ? [tensor_board_app_settings.value.default_resource_spec] : []
          content {
            instance_type        = lookup(default_resource_spec.value, "instance_type", null)
            sagemaker_image_arn  = lookup(default_resource_spec.value, "sagemaker_image_arn", null)
          }
        }
      }
    }

    dynamic "code_editor_app_settings" {
      for_each = var.code_editor_app_settings != null ? [var.code_editor_app_settings] : []
      content {
        dynamic "default_resource_spec" {
          for_each = code_editor_app_settings.value.default_resource_spec != null ? [code_editor_app_settings.value.default_resource_spec] : []
          content {
            instance_type        = lookup(default_resource_spec.value, "instance_type", null)
            sagemaker_image_arn  = lookup(default_resource_spec.value, "sagemaker_image_arn", null)
          }
        }
      }
    }

    security_groups = var.security_groups
  }

  dynamic "default_space_settings" {
    for_each = var.default_space_settings != null ? [var.default_space_settings] : []
    content {
      execution_role = default_space_settings.value.execution_role
      security_groups = lookup(default_space_settings.value, "security_groups", null)
    }
  }

  app_network_access_type = var.app_network_access_type
  kms_key_id              = var.kms_key_id

  dynamic "domain_settings" {
    for_each = var.domain_settings != null ? [var.domain_settings] : []
    content {
      execution_role_identity_config = lookup(domain_settings.value, "execution_role_identity_config", null)
      security_group_ids             = lookup(domain_settings.value, "security_group_ids", null)
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? [var.retention_policy] : []
    content {
      home_efs_file_system = retention_policy.value.home_efs_file_system
    }
  }

  tags = var.tags
}
