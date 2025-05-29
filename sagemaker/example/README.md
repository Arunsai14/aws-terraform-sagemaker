# AWS SageMaker Example

This example demonstrates how to use the SageMaker module to create various SageMaker resources.

## Usage

To run this example, you need to execute:

```bash
$ terraform init
$ terraform plan -var-file=dev.tfvars
$ terraform apply -var-file=dev.tfvars
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources anymore.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS region | `string` | `"us-east-1"` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{ "Environment": "dev", "Project": "sagemaker-example" }` | no |
| vpc_cidr | CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |
| availability_zones | List of availability zones | `list(string)` | `["us-east-1a", "us-east-1b", "us-east-1c"]` | no |
| private_subnets | List of private subnet CIDR blocks | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` | no |
| public_subnets | List of public subnet CIDR blocks | `list(string)` | `["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]` | no |
| create_domain | Whether to create a SageMaker domain | `bool` | `true` | no |
| domain_name | The domain name | `string` | `"sagemaker-example-domain"` | no |
| auth_mode | The mode of authentication that members use to access the domain | `string` | `"IAM"` | no |
| app_network_access_type | Specifies the VPC used for non-EFS traffic | `string` | `"PublicInternetOnly"` | no |
| create_notebook | Whether to create a SageMaker notebook instance | `bool` | `true` | no |
| notebook_name | The name of the notebook instance | `string` | `"sagemaker-example-notebook"` | no |
| notebook_instance_type | The name of ML compute instance type | `string` | `"ml.t3.medium"` | no |
| notebook_volume_size | The size, in GB, of the ML storage volume to attach to the notebook instance | `number` | `5` | no |
| create_model | Whether to create a SageMaker model | `bool` | `false` | no |
| model_name | The name of the model | `string` | `"sagemaker-example-model"` | no |
| model_primary_container | The primary docker image containing inference code | `any` | `{ "image": "763104351884.dkr.ecr.us-east-1.amazonaws.com/tensorflow-inference:2.3.0-cpu" }` | no |
| create_endpoint | Whether to create a SageMaker endpoint | `bool` | `false` | no |
| endpoint_name | The name of the endpoint | `string` | `"sagemaker-example-endpoint"` | no |
| endpoint_config_name | The name of the endpoint configuration to use | `string` | `"sagemaker-example-endpoint-config"` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| private_subnets | List of IDs of private subnets |
| public_subnets | List of IDs of public subnets |
| sagemaker_role_arn | The ARN of the IAM role for SageMaker |
| domain_id | The ID of the SageMaker domain |
| domain_arn | The ARN of the SageMaker domain |
| domain_url | The domain's URL |
| notebook_id | The name of the notebook instance |
| notebook_arn | The ARN of the notebook instance |
| notebook_url | The URL that you use to connect to the Jupyter notebook |
| model_id | The name of the model |
| model_arn | The ARN of the model |
| endpoint_id | The name of the endpoint |
| endpoint_arn | The ARN of the endpoint |
