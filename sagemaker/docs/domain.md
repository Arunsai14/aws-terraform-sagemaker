# SageMaker Domain Module

This module creates a SageMaker domain with configurable settings.

## Usage

```hcl
module "sagemaker_domain" {
  source = "../modules/domain"

  domain_name         = "my-sagemaker-domain"
  auth_mode           = "IAM"
  vpc_id              = "vpc-12345678"
  subnet_ids          = ["subnet-12345678", "subnet-87654321"]
  execution_role_arn  = "arn:aws:iam::123456789012:role/sagemaker-execution-role"
  app_network_access_type = "PublicInternetOnly"
  
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
| [aws_sagemaker_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_domain) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain_name | The domain name | `string` | n/a | yes |
| auth_mode | The mode of authentication that members use to access the domain | `string` | `"IAM"` | yes |
| vpc_id | The ID of the Amazon Virtual Private Cloud (VPC) that Studio uses for communication | `string` | n/a | yes |
| subnet_ids | The VPC subnets that Studio uses for communication | `list(string)` | n/a | yes |
| execution_role_arn | The execution role ARN for the domain | `string` | n/a | yes |
| kms_key_id | The AWS KMS customer managed CMK used to encrypt the EFS volume attached to the domain | `string` | `null` | no |
| app_network_access_type | Specifies the VPC used for non-EFS traffic | `string` | `"PublicInternetOnly"` | no |
| security_groups | A list of security group IDs to attach to the user profile | `list(string)` | `null` | no |
| jupyter_server_app_settings | The Jupyter server's app settings | `any` | `null` | no |
| kernel_gateway_app_settings | The kernel gateway app settings | `any` | `null` | no |
| tensor_board_app_settings | The TensorBoard app settings | `any` | `null` | no |
| code_editor_app_settings | The Code Editor application settings | `any` | `null` | no |
| default_space_settings | The default space settings | `any` | `null` | no |
| domain_settings | The domain settings | `any` | `null` | no |
| retention_policy | The retention policy for this domain | `any` | `null` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain_id | The ID of the SageMaker domain |
| domain_arn | The ARN of the SageMaker domain |
| domain_url | The domain's URL |
| home_efs_file_system_id | The ID of the Amazon Elastic File System (EFS) managed by this domain |
| security_group_id_for_domain_boundary | The ID of the security group that authorizes traffic between the RSessionGateway apps and the RStudioServerPro app |
