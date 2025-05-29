# AWS SageMaker Terraform Module

This Terraform module provides a reusable way to create and manage AWS SageMaker resources.

## Features

This module supports creating the following SageMaker resources:

- SageMaker Domain
- SageMaker Notebook Instance
- SageMaker Model
- SageMaker Endpoint

## Usage

```hcl
module "sagemaker" {
  source = "path/to/module"

  # Domain configuration
  create_domain         = true
  domain_name           = "my-sagemaker-domain"
  auth_mode             = "IAM"
  vpc_id                = "vpc-12345678"
  subnet_ids            = ["subnet-12345678", "subnet-87654321"]
  domain_execution_role_arn = "arn:aws:iam::123456789012:role/sagemaker-execution-role"
  app_network_access_type = "PublicInternetOnly"

  # Notebook configuration
  create_notebook       = true
  notebook_name         = "my-notebook"
  notebook_role_arn     = "arn:aws:iam::123456789012:role/sagemaker-execution-role"
  notebook_instance_type = "ml.t3.medium"
  notebook_volume_size  = 10
  notebook_subnet_id    = "subnet-12345678"

  # Model configuration
  create_model          = true
  model_name            = "my-model"
  model_execution_role_arn = "arn:aws:iam::123456789012:role/sagemaker-execution-role"
  model_primary_container = {
    image = "763104351884.dkr.ecr.us-east-1.amazonaws.com/tensorflow-inference:2.3.0-cpu"
  }

  # Endpoint configuration
  create_endpoint       = true
  endpoint_name         = "my-endpoint"
  endpoint_config_name  = "my-endpoint-config"

  tags = {
    Environment = "dev"
    Project     = "sagemaker-example"
  }
}
```

## Examples

- [Basic Example](./example) - Creates a SageMaker domain and notebook instance

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| sagemaker_domain | ./modules/domain | n/a |
| sagemaker_notebook | ./modules/notebook | n/a |
| sagemaker_model | ./modules/model | n/a |
| sagemaker_endpoint | ./modules/endpoint | n/a |

## Resources

This module creates the following resources:

- `aws_sagemaker_domain` - SageMaker domain
- `aws_sagemaker_notebook_instance` - SageMaker notebook instance
- `aws_sagemaker_model` - SageMaker model
- `aws_sagemaker_endpoint` - SageMaker endpoint

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_domain | Whether to create a SageMaker domain | `bool` | `false` | no |
| domain_name | The domain name | `string` | `null` | no |
| auth_mode | The mode of authentication that members use to access the domain | `string` | `"IAM"` | no |
| vpc_id | The ID of the Amazon Virtual Private Cloud (VPC) that Studio uses for communication | `string` | `null` | no |
| subnet_ids | The VPC subnets that Studio uses for communication | `list(string)` | `[]` | no |
| domain_execution_role_arn | The execution role ARN for the domain | `string` | `null` | no |
| kms_key_id | The AWS KMS customer managed CMK used to encrypt the EFS volume attached to the domain | `string` | `null` | no |
| app_network_access_type | Specifies the VPC used for non-EFS traffic | `string` | `"PublicInternetOnly"` | no |
| create_notebook | Whether to create a SageMaker notebook instance | `bool` | `false` | no |
| notebook_name | The name of the notebook instance | `string` | `null` | no |
| notebook_role_arn | The ARN of the IAM role to be used by the notebook instance | `string` | `null` | no |
| notebook_instance_type | The name of ML compute instance type | `string` | `"ml.t3.medium"` | no |
| notebook_volume_size | The size, in GB, of the ML storage volume to attach to the notebook instance | `number` | `5` | no |
| notebook_subnet_id | The VPC subnet ID for the notebook instance | `string` | `null` | no |
| notebook_security_groups | The associated security groups for the notebook instance | `list(string)` | `[]` | no |
| notebook_kms_key_id | The AWS KMS key that Amazon SageMaker uses to encrypt notebook instance | `string` | `null` | no |
| notebook_lifecycle_config_name | The name of a lifecycle configuration to associate with the notebook instance | `string` | `null` | no |
| notebook_direct_internet_access | Set to Disabled to disable internet access to notebook | `string` | `"Enabled"` | no |
| create_model | Whether to create a SageMaker model | `bool` | `false` | no |
| model_name | The name of the model | `string` | `null` | no |
| model_execution_role_arn | A role that SageMaker can assume to access model artifacts and docker images for deployment | `string` | `null` | no |
| model_primary_container | The primary docker image containing inference code | `any` | `{}` | no |
| create_endpoint | Whether to create a SageMaker endpoint | `bool` | `false` | no |
| endpoint_name | The name of the endpoint | `string` | `null` | no |
| endpoint_config_name | The name of the endpoint configuration to use | `string` | `null` | no |
| endpoint_deployment_config | The deployment configuration for an endpoint | `any` | `{}` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain_id | The ID of the SageMaker domain |
| domain_arn | The ARN of the SageMaker domain |
| domain_url | The domain's URL |
| domain_home_efs_file_system_id | The ID of the Amazon Elastic File System (EFS) managed by this domain |
| notebook_id | The name of the notebook instance |
| notebook_arn | The ARN of the notebook instance |
| notebook_url | The URL that you use to connect to the Jupyter notebook |
| model_id | The name of the model |
| model_arn | The ARN of the model |
| endpoint_id | The name of the endpoint |
| endpoint_arn | The ARN of the endpoint |

## License

This module is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
