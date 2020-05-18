variable "environment" {
}

variable "naming_suffix" {
}

variable "pipeline_name" {
}

variable "swap_alarm" {
  description = "Switch to turn off Swap monitoring (required for MSSQL). Accepted values are 'false' to turn off and 'true' to excplicitly turn on"
  default     = "true"
}

variable "path_module" {
  default = "unset"
}

variable "db_instance_id" {
  description = "The instance ID of the RDS database instance that you want to monitor."
  type        = string
}

variable "burst_balance_threshold" {
  description = "The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available."
  type        = string
  default     = 20
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = string
  default     = 80
}

variable "disk_queue_depth_threshold" {
  description = "The maximum number of outstanding IOs (read/write requests) waiting to access the disk."
  type        = string
  default     = 64
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = string
  default     = 64000000
  # 64 Megabyte in Byte
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  type        = string
  default     = 20000000000
  # 20 Gigabyte in Byte
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the DB instance in Byte."
  type        = string
  default     = 1024000000
  # 1024 Megabyte in Byte
}

variable "db_connections_threshold" {
  description = "The maximum number of database connections at any given time."
  type        = string
  default     = 100
}

variable "read_latency_threshold" {
  description = "The average amount of time taken per disk I/O operation."
  type        = string
  default     = 0.01
  # 20 miliseconds in seconds
}

variable "write_latency_threshold" {
  description = "The average amount of time taken per disk I/O operation."
  type        = string
  default     = 1
  # 1000 miliseconds in seconds
}

