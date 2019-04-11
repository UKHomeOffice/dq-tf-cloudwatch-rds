# dq-tf-cloudwatch-rds

Cloudwatch module for RDS monitoring using the following components:

- SNS
- Cloudwatch
- IAM
- Lambda (to do)
- Python (to do)

# Usage

```
module "cloudwatch_alarms_rds" {
  source         = "github.com/UKHomeOffice/dq-tf-cloudwatch-rds"
  naming_suffix  = "${local.naming_suffix}"
  db_instance_id = "${aws_db_instance.rds.id}"
}
```

# Supported variables

| Variable name | Required | Description |
| :---: | :---: | :---: |
| naming_suffix | __True__ | Tag naming variable |
| db_instance_id | __True__ | RDS instance ID |
| burst_balance_threshold | False | The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available |
| cpu_utilization_threshold | False | The maximum percentage of CPU utilisation. |
| disk_queue_depth_threshold | True | The maximum number of outstanding IOs (read/write requests) waiting to access the disk. |
| freeable_memory_threshold | False | The minimum amount of available random access memory in Byte. |
| free_storage_space_threshold | False | The minimum amount of available storage space in Byte |
| swap_usage_threshold | False | The maximum amount of swap space used on the DB instance in Byte. |
