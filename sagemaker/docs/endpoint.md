# SageMaker Endpoint Module

This module creates a SageMaker endpoint with configurable settings.

## Usage

```hcl
module "sagemaker_endpoint" {
  source = "../modules/endpoint"

  name                 = "my-endpoint"
  endpoint_config_name = "my-endpoint-config"
  
  deployment_config = {
    blue_green_update_policy = {
      traffic_routing_configuration = {
        type                     = "ALL_AT_ONCE"
        wait_interval_in_seconds = 600
      }
      termination_wait_in_seconds = 600
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
| [aws_sagemaker_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the endpoint | `string` | n/a | yes |
| endpoint_config_name | The name of the endpoint configuration to use | `string` | n/a | yes |
| deployment_config | The deployment configuration for an endpoint, which contains the desired deployment strategy and rollback configurations | `any` | `null` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| endpoint_id | The name of the endpoint |
| endpoint_arn | The ARN of the endpoint |
