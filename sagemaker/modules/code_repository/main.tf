/**
 * # AWS SageMaker Code Repository Module
 *
 * This module creates a SageMaker code repository with configurable settings.
 */

resource "aws_sagemaker_code_repository" "this" {
  code_repository_name = var.code_repository_name

  git_config {
    repository_url = var.git_config.repository_url
    branch         = lookup(var.git_config, "branch", null)
    secret_arn     = lookup(var.git_config, "secret_arn", null)
  }

  tags = var.tags
}
