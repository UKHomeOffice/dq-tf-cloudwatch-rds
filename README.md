# dq-tf-cloudwatch-rds

Cloudwatch module for RDS monitoring using the following components:

- SNS
- Cloudwatch
- IAM
- Lambda
- Python

# Usage

```
module "cloudwatch_alarms_rds" {
  source         = "github.com/UKHomeOffice/dq-tf-cloudwatch-rds"
  environment    = "notprod"
  naming_suffix  = "${local.naming_suffix}"
  db_instance_id = "${aws_db_instance.rds.id}"
  pipeline_name  = "foobar"
}
```

# Supported variables

| Variable name | Required | Description |
| :---: | :---: | :---: |
| environment | __True__ | Environment name |
| naming_suffix | __True__ | Tag naming variable |
| db_instance_id | __True__ | RDS instance ID |
| pipeline_name | __True__ | Tag name |
| swap_alarm | False | By default this alarm is turned on however for MSSQL the value needs to be set to `false` |
| burst_balance_threshold | False | The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available |
| cpu_utilization_threshold | False | The maximum percentage of CPU utilisation. |
| disk_queue_depth_threshold | False | The maximum number of outstanding IOs (read/write requests) waiting to access the disk. |
| freeable_memory_threshold | False | The minimum amount of available random access memory in Byte. |
| free_storage_space_threshold | False | The minimum amount of available storage space in Byte |
| swap_usage_threshold | False | The maximum amount of swap space used on the DB instance in Byte. |
| db_connections_threshold | False | The maximum number of database connections at any given time. |
| read_latency_threshold | False | The average amount of time taken per disk I/O operation. |
| write_latency_threshold | False | The average amount of time taken per disk I/O operation. |
