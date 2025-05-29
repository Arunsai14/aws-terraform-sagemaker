# AWS SageMaker Asynchronous Inference Example

This example demonstrates how to use the SageMaker module to create an asynchronous inference endpoint, which is ideal for processing large payloads with longer processing times.

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
- S3 bucket for model artifacts and inference results
- SNS topics for success and error notifications
- SageMaker model
- SageMaker endpoint configuration with asynchronous inference configuration
- SageMaker endpoint

## Asynchronous Inference Benefits

Asynchronous inference is ideal for:

1. Processing large payloads (up to 1GB)
2. Longer processing times (up to 15 minutes)
3. Workloads that don't require immediate responses
4. Cost optimization for batch processing

The asynchronous configuration in this example includes:
- S3 paths for storing inference results and failures
- SNS topics for notifications on success and failure
- Client configuration for controlling concurrency

## How to Use the Async Endpoint

To use an asynchronous endpoint:

1. Submit inference requests to the endpoint's `/invocations-async` endpoint
2. Provide an S3 URI where you want the results to be stored
3. Optionally provide an SNS topic ARN for notifications
4. Check the S3 location or wait for SNS notifications for results

## Notes

- The example uses a dummy model artifact. In a real-world scenario, you would use an actual trained model.
- Asynchronous inference has different API endpoints and request/response patterns compared to real-time inference.
- The SNS topics created in this example would need subscription configuration for actual notifications to be delivered.
