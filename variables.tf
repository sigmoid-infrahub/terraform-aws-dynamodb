# ====================================
# Basic Configuration
# ====================================

variable "prefix" {
  description = "Prefix for the DynamoDB table"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "table_class" {
  description = "Storage class for the DynamoDB table"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_class)
    error_message = "Table class must be one of: STANDARD, STANDARD_INFREQUENT_ACCESS"
  }
}

# ====================================
# Capacity and Billing Configuration
# ====================================

variable "billing_mode" {
  description = "Billing mode for the DynamoDB table"
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "Billing mode must be one of: PAY_PER_REQUEST, PROVISIONED"
  }
}

variable "read_capacity" {
  description = "Read capacity for the DynamoDB table (only for PROVISIONED mode)"
  type        = number
  default     = 5

  validation {
    condition     = var.billing_mode == "PAY_PER_REQUEST" || (var.read_capacity >= 1 && var.read_capacity <= 10000)
    error_message = "Read capacity must be between 1 and 10000 when billing mode is PROVISIONED"
  }
}

variable "write_capacity" {
  description = "Write capacity for the DynamoDB table (only for PROVISIONED mode)"
  type        = number
  default     = 5

  validation {
    condition     = var.billing_mode == "PAY_PER_REQUEST" || (var.write_capacity >= 1 && var.write_capacity <= 10000)
    error_message = "Write capacity must be between 1 and 10000 when billing mode is PROVISIONED"
  }
}

# ====================================
# Schema Configuration
# ====================================

variable "hash_key" {
  description = "Hash key for the DynamoDB table"
  type        = string
}

variable "range_key" {
  description = "Range key for the DynamoDB table"
  type        = string
  default     = ""
}

variable "attributes" {
  description = "Attributes for the DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))

  validation {
    condition = alltrue([
      for attr in var.attributes : contains(["S", "N", "B"], attr.type)
    ])
    error_message = "Attribute type must be one of: S (String), N (Number), B (Binary)"
  }
}

# ====================================
# Index Configuration
# ====================================

variable "global_secondary_indexes" {
  description = "Global secondary indexes for the DynamoDB table"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = string
    write_capacity     = number
    read_capacity      = number
    projection_type    = string
    non_key_attributes = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for gsi in var.global_secondary_indexes : contains(["ALL", "KEYS_ONLY", "INCLUDE"], gsi.projection_type)
    ])
    error_message = "GSI projection_type must be one of: ALL, KEYS_ONLY, INCLUDE"
  }
}

variable "local_secondary_indexes" {
  description = "Local secondary indexes for the DynamoDB table"
  type = list(object({
    name               = string
    range_key          = string
    projection_type    = string
    non_key_attributes = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for lsi in var.local_secondary_indexes : contains(["ALL", "KEYS_ONLY", "INCLUDE"], lsi.projection_type)
    ])
    error_message = "LSI projection_type must be one of: ALL, KEYS_ONLY, INCLUDE"
  }
}

# ====================================
# TTL Configuration
# ====================================

variable "ttl_enabled" {
  description = "Enable TTL for the DynamoDB table"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "TTL attribute name for the DynamoDB table"
  type        = string
  default     = "ttl"
}

# ====================================
# Streams Configuration
# ====================================

variable "stream_enabled" {
  description = "Enable DynamoDB Streams"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Stream view type for DynamoDB Streams"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"

  validation {
    condition     = contains(["NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES", "KEYS_ONLY"], var.stream_view_type)
    error_message = "Stream view type must be one of: NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES, KEYS_ONLY"
  }
}

# ====================================
# Security Configuration
# ====================================

variable "server_side_encryption_enabled" {
  description = "Enable server-side encryption"
  type        = bool
  default     = true
}

variable "server_side_encryption_kms_key_arn" {
  description = "ARN of the KMS key for server-side encryption (leave null to use AWS managed key)"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for server-side encryption. Empty string uses the AWS managed key"
  type        = string
  default     = ""
}

variable "point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery"
  type        = bool
  default     = true
}

variable "deletion_protection_enabled" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

# ====================================
# Monitoring Configuration
# ====================================

variable "contributor_insights_enabled" {
  description = "Enable CloudWatch Contributor Insights"
  type        = bool
  default     = false
}

# ====================================
# Timeouts Configuration
# ====================================

variable "timeouts" {
  description = "Timeouts for DynamoDB table operations"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "15m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "15m"
  }
}

# ====================================
# Tags Configuration
# ====================================

variable "tags" {
  description = "Additional tags for the DynamoDB table"
  type        = map(string)
  default     = {}
}

# ====================================
# Sigmoid Tags Configuration
# ====================================

variable "sigmoid_environment" {
  description = "Sigmoid environment identifier for cost allocation"
  type        = string
  default     = ""
}

variable "sigmoid_project" {
  description = "Sigmoid project identifier for cost allocation"
  type        = string
  default     = ""
}

variable "sigmoid_team" {
  description = "Sigmoid team identifier for cost allocation"
  type        = string
  default     = ""
}
