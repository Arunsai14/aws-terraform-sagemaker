/**
 * # AWS SageMaker Notebook Instance Module
 *
 * This module creates a SageMaker notebook instance with configurable settings.
 */

resource "aws_sagemaker_notebook_instance" "this" {
  name                    = var.name
  role_arn                = var.role_arn
  instance_type           = var.instance_type
  platform_identifier     = var.platform_identifier
  volume_size             = var.volume_size
  subnet_id               = var.subnet_id
  security_groups         = var.security_groups
  kms_key_id              = var.kms_key_id
  lifecycle_config_name   = var.lifecycle_config_name
  direct_internet_access  = var.direct_internet_access
  root_access             = var.root_access
  
  dynamic "instance_metadata_service_configuration" {
    for_each = var.instance_metadata_service_configuration != null ? [var.instance_metadata_service_configuration] : []
    content {
      minimum_instance_metadata_service_version = instance_metadata_service_configuration.value.minimum_instance_metadata_service_version
    }
  }

  default_code_repository = var.default_code_repository
  additional_code_repositories = var.additional_code_repositories

  tags = var.tags
}
