# SageMaker Endpoint Configuration Module

This module creates a SageMaker endpoint configuration with configurable settings.

## Usage

```hcl
module "sagemaker_endpoint_configuration" {
  source = "../modules/endpoint_configuration"

  name                 = "my-endpoint-config"
  kms_key_arn          = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-5678-90ab-cdef-example11111"
  
  production_variants = [
    {
      variant_name           = "variant-1"
      model_name             = "my-model"
      initial_instance_count = 1
      instance_type          = "ml.t2.medium"
      initial_variant_weight = 1.0
    }
  ]
  
  data_capture_config = {
    initial_sampling_percentage = 100
    destination_s3_uri          = "s3://my-bucket/data-capture"
    enable_capture              = true
    capture_options = [
      {
        capture_mode = "Input"
      },
      {
        capture_mode = "Output"
      }
    ]
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
| [aws_sagemaker_endpoint_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_endpoint_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the endpoint configuration | `string` | `null` | no |
| name_prefix | Creates a unique endpoint configuration name beginning with the specified prefix | `string` | `null` | no |
| kms_key_arn | Amazon Resource Name (ARN) of a AWS Key Management Service key | `string` | `null` | no |
| production_variants | List of production variants for the endpoint configuration | `any` | n/a | yes |
| shadow_production_variants | List of shadow production variants for the endpoint configuration | `any` | `null` | no |
| data_capture_config | Specifies the parameters to capture input/output of SageMaker models endpoints | `any` | `null` | no |
| async_inference_config | Specifies configuration for how an endpoint performs asynchronous inference | `any` | `null` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| endpoint_config_id | The name of the endpoint configuration |
| endpoint_config_arn | The ARN of the endpoint configuration |
| endpoint_config_name | The name of the endpoint configuration |
