/**
 * # AWS SageMaker Endpoint Module
 *
 * This module creates a SageMaker endpoint with configurable settings.
 */

resource "aws_sagemaker_endpoint" "this" {
  name                 = var.name
  endpoint_config_name = var.endpoint_config_name

  dynamic "deployment_config" {
    for_each = var.deployment_config != null ? [var.deployment_config] : []
    content {
      dynamic "blue_green_update_policy" {
        for_each = lookup(deployment_config.value, "blue_green_update_policy", null) != null ? [deployment_config.value.blue_green_update_policy] : []
        content {
          traffic_routing_configuration {
            type                     = blue_green_update_policy.value.traffic_routing_configuration.type
            wait_interval_in_seconds = blue_green_update_policy.value.traffic_routing_configuration.wait_interval_in_seconds

            dynamic "canary_size" {
              for_each = lookup(blue_green_update_policy.value.traffic_routing_configuration, "canary_size", null) != null ? [blue_green_update_policy.value.traffic_routing_configuration.canary_size] : []
              content {
                type  = canary_size.value.type
                value = canary_size.value.value
              }
            }

            dynamic "linear_step_size" {
              for_each = lookup(blue_green_update_policy.value.traffic_routing_configuration, "linear_step_size", null) != null ? [blue_green_update_policy.value.traffic_routing_configuration.linear_step_size] : []
              content {
                type  = linear_step_size.value.type
                value = linear_step_size.value.value
              }
            }
          }

          termination_wait_in_seconds          = lookup(blue_green_update_policy.value, "termination_wait_in_seconds", null)
          maximum_execution_timeout_in_seconds = lookup(blue_green_update_policy.value, "maximum_execution_timeout_in_seconds", null)
        }
      }

      dynamic "auto_rollback_configuration" {
        for_each = lookup(deployment_config.value, "auto_rollback_configuration", null) != null ? [deployment_config.value.auto_rollback_configuration] : []
        content {
          dynamic "alarms" {
            for_each = lookup(auto_rollback_configuration.value, "alarms", [])
            content {
              alarm_name = alarms.value.alarm_name
            }
          }
        }
      }

      dynamic "rolling_update_policy" {
        for_each = lookup(deployment_config.value, "rolling_update_policy", null) != null ? [deployment_config.value.rolling_update_policy] : []
        content {
          maximum_batch_size {
            type  = rolling_update_policy.value.maximum_batch_size.type
            value = rolling_update_policy.value.maximum_batch_size.value
          }

          wait_interval_in_seconds = rolling_update_policy.value.wait_interval_in_seconds

          dynamic "rollback_maximum_batch_size" {
            for_each = lookup(rolling_update_policy.value, "rollback_maximum_batch_size", null) != null ? [rolling_update_policy.value.rollback_maximum_batch_size] : []
            content {
              type  = rollback_maximum_batch_size.value.type
              value = rollback_maximum_batch_size.value.value
            }
          }

          maximum_execution_timeout_in_seconds = lookup(rolling_update_policy.value, "maximum_execution_timeout_in_seconds", null)
        }
      }
    }
  }

  tags = var.tags
}
