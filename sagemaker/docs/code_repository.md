# SageMaker Code Repository Module

This module creates a SageMaker code repository with configurable settings.

## Usage

```hcl
module "sagemaker_code_repository" {
  source = "../modules/code_repository"

  code_repository_name = "my-code-repository"
  
  git_config = {
    repository_url = "https://github.com/example/repository.git"
    branch         = "main"
  }
  
  tags = {
    Environment = "dev"
    Project     = "sagemaker-example"
  }
}
```

## Usage with Secret

```hcl
module "sagemaker_code_repository" {
  source = "../modules/code_repository"

  code_repository_name = "my-private-code-repository"
  
  git_config = {
    repository_url = "https://github.com/example/private-repository.git"
    branch         = "main"
    secret_arn     = "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-git-credentials-abcdef"
  }
  
  tags = {
    Environment = "dev"
    Project     = "sagemaker-example"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_sagemaker_code_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_code_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| code_repository_name | The name of the Code Repository (must be unique) | `string` | n/a | yes |
| git_config | Specifies details about the repository | `object` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| code_repository_id | The name of the Code Repository |
| code_repository_arn | The ARN of the Code Repository |
