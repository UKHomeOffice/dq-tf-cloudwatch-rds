locals {
  naming_suffix = ${var.naming_suffix}
  path_module   = var.path_module != "unset" ? var.path_module : path.module

  thresholds = {
    BurstBalanceThreshold     = min(max(var.burst_balance_threshold, 0), 100)
    CPUUtilizationThreshold   = min(max(var.cpu_utilization_threshold, 0), 100)
    DiskQueueDepthThreshold   = max(var.disk_queue_depth_threshold, 0)
    FreeableMemoryThreshold   = max(var.freeable_memory_threshold, 0)
    FreeStorageSpaceThreshold = max(var.free_storage_space_threshold, 0)
    SwapUsageThreshold        = max(var.swap_usage_threshold, 0)
    DatabaseConnections       = max(var.db_connections_threshold, 0)
    WriteLatency              = max(var.write_latency_threshold, 0)
    ReadLatency               = max(var.read_latency_threshold, 0)
  }
}

resource "aws_cloudwatch_metric_alarm" "burst_balance_too_low" {
  alarm_name          = "${var.pipeline_name}-burst-balance-too-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["BurstBalanceThreshold"]
  alarm_description   = "Average database storage burst balance over last 10 minutes too low, expect a significant performance drop soon"
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  alarm_name          = "${var.pipeline_name}-CPU-Utilization-too-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilizationThreshold"]
  alarm_description   = "Average database CPU utilization over last 10 minutes too high"
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
  alarm_name          = "${var.pipeline_name}-disk-queue-depth-too-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["DiskQueueDepthThreshold"]
  alarm_description   = "Average database disk queue depth over last 10 minutes too high, performance may suffer"
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  alarm_name          = "${var.pipeline_name}-freeable-memory-too-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["FreeableMemoryThreshold"]
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer"
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  alarm_name          = "${var.pipeline_name}-free-storage-space-too-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average database free storage space over last 10 minutes too low"
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage_too_high" {
  count               = var.swap_alarm == "true" ? "1" : "0"
  alarm_name          = "${var.pipeline_name}-swap-usage-too-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "SwapUsage"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["SwapUsageThreshold"]
  alarm_description   = "Average database swap usage over last 10 minutes too high, performance may suffer"
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "database_connections_too_high" {
  alarm_name          = "${var.pipeline_name}-database-connections-too-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["DatabaseConnections"]
  alarm_description   = "Average database connection count over last 10 minutes too high."
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "read_latency_too_high" {
  alarm_name          = "${var.pipeline_name}-read-latency-too-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ReadLatency"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["ReadLatency"]
  alarm_description   = "The average amount of time taken per disk I/O operation."
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "write_latency_too_high" {
  alarm_name          = "${var.pipeline_name}-write-latency-too-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "WriteLatency"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = local.thresholds["WriteLatency"]
  alarm_description   = "The average amount of time taken per disk I/O operation."
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

