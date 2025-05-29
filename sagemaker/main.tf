/**
 * # AWS SageMaker Terraform Module
 *
 * This module provides a reusable way to create and manage AWS SageMaker resources.
 * It supports creating SageMaker domains, notebook instances, models, endpoints, endpoint configurations, and code repositories.
 */

module "sagemaker_domain" {
  source = "./modules/domain"
  count  = var.create_domain ? 1 : 0

  domain_name         = var.domain_name
  auth_mode           = var.auth_mode
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  execution_role_arn  = var.domain_execution_role_arn
  kms_key_id          = var.kms_key_id
  app_network_access_type = var.app_network_access_type
  security_groups     = var.domain_security_groups
  jupyter_server_app_settings = var.jupyter_server_app_settings
  kernel_gateway_app_settings = var.kernel_gateway_app_settings
  tensor_board_app_settings = var.tensor_board_app_settings
  code_editor_app_settings = var.code_editor_app_settings
  default_space_settings = var.default_space_settings
  domain_settings     = var.domain_settings
  retention_policy    = var.retention_policy
  tags                = var.tags
}

module "sagemaker_notebook" {
  source = "./modules/notebook"
  count  = var.create_notebook ? 1 : 0

  name                = var.notebook_name
  role_arn            = var.notebook_role_arn
  instance_type       = var.notebook_instance_type
  platform_identifier = var.notebook_platform_identifier
  volume_size         = var.notebook_volume_size
  subnet_id           = var.notebook_subnet_id
  security_groups     = var.notebook_security_groups
  kms_key_id          = var.notebook_kms_key_id
  lifecycle_config_name = var.notebook_lifecycle_config_name
  direct_internet_access = var.notebook_direct_internet_access
  instance_metadata_service_configuration = var.notebook_instance_metadata_service_configuration
  root_access         = var.notebook_root_access
  default_code_repository = var.notebook_default_code_repository
  additional_code_repositories = var.notebook_additional_code_repositories
  tags                = var.tags
}

module "sagemaker_model" {
  source = "./modules/model"
  count  = var.create_model ? 1 : 0

  name                = var.model_name
  execution_role_arn  = var.model_execution_role_arn
  primary_container   = var.model_primary_container
  containers          = var.model_containers
  inference_execution_config = var.model_inference_execution_config
  tags                = var.tags
}

module "sagemaker_endpoint_configuration" {
  source = "./modules/endpoint_configuration"
  count  = var.create_endpoint_config ? 1 : 0

  name                 = var.endpoint_config_name
  name_prefix          = var.endpoint_config_name_prefix
  kms_key_arn          = var.endpoint_config_kms_key_arn
  production_variants  = var.endpoint_config_production_variants
  shadow_production_variants = var.endpoint_config_shadow_production_variants
  data_capture_config  = var.endpoint_config_data_capture_config
  async_inference_config = var.endpoint_config_async_inference_config
  tags                 = var.tags
}

module "sagemaker_endpoint" {
  source = "./modules/endpoint"
  count  = var.create_endpoint ? 1 : 0

  name                 = var.endpoint_name
  endpoint_config_name = var.create_endpoint_config ? module.sagemaker_endpoint_configuration[0].endpoint_config_name : var.endpoint_config_name
  deployment_config    = var.endpoint_deployment_config
  tags                 = var.tags

  depends_on = [module.sagemaker_endpoint_configuration]
}

module "sagemaker_code_repository" {
  source = "./modules/code_repository"
  count  = var.create_code_repository ? 1 : 0

  code_repository_name = var.code_repository_name
  git_config           = var.code_repository_git_config
  tags                 = var.tags
}
