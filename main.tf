data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

### --------------------------------------------------
### DynamoDB Table
### --------------------------------------------------
resource "aws_dynamodb_table" "main" {
  name         = local.table_name
  billing_mode = var.billing_mode
  table_class  = var.table_class
  hash_key     = var.hash_key
  range_key    = var.range_key != null && var.range_key != "" ? var.range_key : null

  # Read and write capacity for PROVISIONED billing mode.
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_enabled ? var.stream_view_type : null

  deletion_protection_enabled = var.deletion_protection_enabled

  # Attributes
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # Global Secondary Indexes
  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      write_capacity     = global_secondary_index.value.write_capacity
      read_capacity      = global_secondary_index.value.read_capacity
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.projection_type == "INCLUDE" ? global_secondary_index.value.non_key_attributes : null
    }
  }

  # Local Secondary Indexes
  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = local_secondary_index.value.projection_type == "INCLUDE" ? local_secondary_index.value.non_key_attributes : null
    }
  }

  # TTL
  dynamic "ttl" {
    for_each = var.ttl_enabled ? [1] : []
    content {
      enabled        = true
      attribute_name = var.ttl_attribute_name
    }
  }

  # Server-Side Encryption
  server_side_encryption {
    enabled     = var.server_side_encryption_enabled
    kms_key_arn = var.kms_key_arn != "" ? var.kms_key_arn : var.server_side_encryption_kms_key_arn
  }

  # Point-in-Time Recovery
  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  # Timeouts
  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  lifecycle {
    # Ignore changes to read and write capacity for PROVISIONED billing mode.
    ignore_changes = [
      read_capacity,
      write_capacity
    ]
  }

  tags = merge(local.resolved_tags, {
    Name = local.table_name
  })
}

### --------------------------------------------------
### CloudWatch Contributor Insights
### --------------------------------------------------
resource "aws_dynamodb_contributor_insights" "main" {
  count = var.contributor_insights_enabled ? 1 : 0

  table_name = aws_dynamodb_table.main.name
}
