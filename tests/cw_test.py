# pylint: disable=missing-docstring, line-too-long, protected-access, E1101, C0202, E0602, W0109
import unittest
from runner import Runner


class TestE2E(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.snippet = """

            provider "aws" {
              region = "eu-west-2"
              skip_credentials_validation = true
              skip_get_ec2_platforms = true
              skip_requesting_account_id = true
              skip_get_ec2_platforms = true
              skip_metadata_api_check = true
              skip_region_validation = true
            }

            module "rds_alarms" {
              source = "./mymodule"

              providers = {
                aws = "aws"
              }

              db_instance_id               = "1234"
              burst_balance_threshold      = "20"
              cpu_utilization_threshold    = "80"
              cpu_credit_balance_threshold = "20"
              disk_queue_depth_threshold   = "64"
              freeable_memory_threshold    = "64000000"
              free_storage_space_threshold = "20000000000"
              swap_usage_threshold         = "1024000000"
              naming_suffix                = "notprod"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_rds_alarms_burst_balance_too_low(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.burst_balance_too_low"]["threshold"], "20")

    def test_rds_alarms_cpu_utilization_too_high(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.cpu_utilization_too_high"]["threshold"], "80")

    def test_rds_alarms_cpu_credit_balance_too_low(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.cpu_credit_balance_too_low"]["threshold"], "20")

    def test_rds_alarms_disk_queue_depth_too_high(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.disk_queue_depth_too_high"]["threshold"], "64")

    def test_rds_alarms_freeable_memory_too_low(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.freeable_memory_too_low"]["threshold"], "64000000")

    def test_rds_alarms_free_storage_space_too_low(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.free_storage_space_too_low"]["threshold"], "20000000000")

    def test_rds_alarms_swap_usage_too_high(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.swap_usage_too_high"]["threshold"], "1024000000")

if __name__ == '__main__':
    unittest.main()
