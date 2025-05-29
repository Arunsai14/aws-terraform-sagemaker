# SageMaker Model Module

This module creates a SageMaker model with configurable settings.

## Usage

```hcl
module "sagemaker_model" {
  source = "../modules/model"

  name               = "my-model"
  execution_role_arn = "arn:aws:iam::123456789012:role/sagemaker-execution-role"
  
  primary_container = {
    image          = "763104351884.dkr.ecr.us-east-1.amazonaws.com/tensorflow-inference:2.3.0-cpu"
    model_data_url = "s3://my-bucket/model.tar.gz"
    environment    = {
      SAGEMAKER_PROGRAM = "inference.py"
    }
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
| [aws_sagemaker_model.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_model) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the model | `string` | n/a | yes |
| execution_role_arn | A role that SageMaker can assume to access model artifacts and docker images for deployment | `string` | n/a | yes |
| primary_container | The primary docker image containing inference code that is used when the model is deployed for predictions | `any` | `null` | no |
| containers | Specifies containers in the inference pipeline | `list(any)` | `null` | no |
| inference_execution_config | Specifies details of how containers in a multi-container endpoint are called | `any` | `null` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| model_id | The name of the model |
| model_arn | The ARN of the model |
