# AWS SageMaker Serverless Inference Example

This example demonstrates how to use the SageMaker module to create a serverless inference endpoint, which is a cost-effective option for workloads with intermittent or unpredictable traffic patterns.

## Prerequisites

Before running this example, you need to:

1. Create a dummy model artifact file:

```bash
# Create a dummy tar.gz file to simulate a model artifact
mkdir -p /tmp/model
echo "dummy model content" > /tmp/model/model.json
tar -czvf dummy_model.tar.gz -C /tmp model
```

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

- IAM role for SageMaker with appropriate permissions
- S3 bucket for model artifacts
- SageMaker model
- SageMaker endpoint configuration with serverless configuration
- SageMaker endpoint

## Serverless Inference Benefits

Serverless inference is ideal for:

1. Workloads with intermittent traffic patterns
2. Applications with unpredictable traffic
3. Cost optimization for endpoints that aren't constantly in use
4. Eliminating the need to manage instance scaling

The serverless configuration in this example specifies:
- `max_concurrency`: Maximum number of concurrent invocations (5)
- `memory_size_in_mb`: Memory allocated to the endpoint (2048 MB)

## Notes

- The example uses a dummy model artifact. In a real-world scenario, you would use an actual trained model.
- Serverless inference has some limitations compared to instance-based endpoints, including maximum request and response payload sizes.
- Not all container images are compatible with serverless inference. Check AWS documentation for compatibility.
