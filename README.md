# Module: DynamoDB

This module manages an AWS DynamoDB table with support for various configurations including capacity modes, indexes, TTL, and streams.

## Features
- Support for PAY_PER_REQUEST and PROVISIONED billing modes
- Global and Local Secondary Indexes (GSI/LSI)
- TTL configuration
- DynamoDB Streams integration
- Server-side encryption and PITR recovery
- Deletion protection and Contributor Insights

## Usage
```hcl
module "dynamodb" {
  source = "../../terraform-modules/terraform-aws-dynamodb"

  prefix     = "prod"
  table_name = "users"
  hash_key   = "id"
  attributes = [
    { name = "id", type = "S" }
  ]
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `prefix` | `string` | n/a | Prefix for the DynamoDB table |
| `table_name` | `string` | n/a | Name of the DynamoDB table |
| `table_class` | `string` | `"STANDARD"` | Storage class for the DynamoDB table |
| `billing_mode` | `string` | `"PAY_PER_REQUEST"` | Billing mode for the DynamoDB table |
| `read_capacity` | `number` | `5` | Read capacity for the DynamoDB table (only for PROVISIONED mode) |
| `write_capacity` | `number` | `5` | Write capacity for the DynamoDB table (only for PROVISIONED mode) |
| `hash_key` | `string` | n/a | Hash key for the DynamoDB table |
| `range_key` | `string` | `""` | Range key for the DynamoDB table |
| `attributes` | `list(object)` | n/a | Attributes for the DynamoDB table |
| `global_secondary_indexes` | `list(object)` | `[]` | Global secondary indexes for the DynamoDB table |
| `local_secondary_indexes` | `list(object)` | `[]` | Local secondary indexes for the DynamoDB table |
| `ttl_enabled` | `bool` | `false` | Enable TTL for the DynamoDB table |
| `ttl_attribute_name` | `string` | `"ttl"` | TTL attribute name for the DynamoDB table |
| `stream_enabled` | `bool` | `false` | Enable DynamoDB Streams |
| `stream_view_type` | `string` | `"NEW_AND_OLD_IMAGES"` | Stream view type for DynamoDB Streams |
| `server_side_encryption_enabled` | `bool` | `true` | Enable server-side encryption |
| `server_side_encryption_kms_key_arn` | `string` | `null` | ARN of the KMS key for server-side encryption |
| `point_in_time_recovery_enabled` | `bool` | `false` | Enable point-in-time recovery |
| `deletion_protection_enabled` | `bool` | `false` | Enable deletion protection |
| `contributor_insights_enabled` | `bool` | `false` | Enable CloudWatch Contributor Insights |
| `timeouts` | `object` | `{...}` | Timeouts for DynamoDB table operations |
| `tags` | `map(string)` | `{}` | Additional tags for the DynamoDB table |

## Outputs
| Name | Description |
|------|-------------|
| `table_name` | Name of the DynamoDB table |
| `table_arn` | ARN of the DynamoDB table |
| `table_stream_arn` | ARN of the DynamoDB stream (null when streams disabled) |
| `contributor_insights_arn` | ARN of the CloudWatch Contributor Insights configuration |

## Environment Variables
None

## Notes
- `table_class` must be either `STANDARD` or `STANDARD_INFREQUENT_ACCESS`.
- Provisioned capacity values are only used if `billing_mode` is `PROVISIONED`.
