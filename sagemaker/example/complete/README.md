# AWS SageMaker Complete Example

This example demonstrates how to use the SageMaker module to create a complete SageMaker environment including domain, notebook, model, endpoint configuration, endpoint, and code repository.

## Prerequisites

Before running this example, you need to:

1. Create a dummy model artifact file:

```bash
# Create a dummy tar.gz file to simulate a model artifact
mkdir -p /tmp/model
echo "dummy model content" > /tmp/model/model.json
tar -czvf dummy_model.tar.gz -C /tmp model
```

2. Set up Git credentials for the code repository (or modify the example to use a public repository).

## Usage

To run this example, you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
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
| random | >= 3.0.0 |

## Resources Created

This example creates the following resources:

- VPC with public and private subnets
- IAM role for SageMaker with appropriate permissions
- Security group for SageMaker resources
- S3 bucket for model artifacts
- SageMaker domain
- SageMaker notebook instance
- SageMaker code repository with Git integration
- SageMaker model
- SageMaker endpoint configuration
- SageMaker endpoint with blue/green deployment configuration

## Notes

- The example uses a dummy model artifact. In a real-world scenario, you would use an actual trained model.
- The Git credentials are stored in AWS Secrets Manager. In a production environment, ensure these are properly secured.
- The example demonstrates blue/green deployment for the endpoint, which is a best practice for production deployments.
