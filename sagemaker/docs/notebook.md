# SageMaker Notebook Instance Module

This module creates a SageMaker notebook instance with configurable settings.

## Usage

```hcl
module "sagemaker_notebook" {
  source = "../modules/notebook"

  name                    = "my-notebook"
  role_arn                = "arn:aws:iam::123456789012:role/sagemaker-execution-role"
  instance_type           = "ml.t3.medium"
  volume_size             = 10
  subnet_id               = "subnet-12345678"
  security_groups         = ["sg-12345678"]
  direct_internet_access  = "Enabled"
  
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
| [aws_sagemaker_notebook_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_notebook_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the notebook instance (must be unique) | `string` | n/a | yes |
| role_arn | The ARN of the IAM role to be used by the notebook instance | `string` | n/a | yes |
| instance_type | The name of ML compute instance type | `string` | `"ml.t3.medium"` | no |
| platform_identifier | The platform identifier of the notebook instance runtime environment | `string` | `null` | no |
| volume_size | The size, in GB, of the ML storage volume to attach to the notebook instance | `number` | `5` | no |
| subnet_id | The VPC subnet ID | `string` | `null` | no |
| security_groups | The associated security groups | `list(string)` | `null` | no |
| kms_key_id | The AWS KMS key that Amazon SageMaker uses to encrypt the notebook instance | `string` | `null` | no |
| lifecycle_config_name | The name of a lifecycle configuration to associate with the notebook instance | `string` | `null` | no |
| direct_internet_access | Set to Disabled to disable internet access to notebook | `string` | `"Enabled"` | no |
| instance_metadata_service_configuration | Information on the IMDS configuration of the notebook instance | `any` | `null` | no |
| root_access | Whether root access is Enabled or Disabled for users of the notebook instance | `string` | `"Enabled"` | no |
| default_code_repository | The Git repository associated with the notebook instance as its default code repository | `string` | `null` | no |
| additional_code_repositories | An array of up to three Git repositories to associate with the notebook instance | `list(string)` | `null` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| notebook_id | The name of the notebook instance |
| notebook_arn | The ARN of the notebook instance |
| notebook_url | The URL that you use to connect to the Jupyter notebook |
| network_interface_id | The network interface ID that Amazon SageMaker created at the time of creating the instance |
