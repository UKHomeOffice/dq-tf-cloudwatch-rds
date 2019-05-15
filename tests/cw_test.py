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
              skip_metadata_api_check = true
            }

            module "rds_alarms" {
              source = "./mymodule"

              providers = {
                aws = "aws"
              }

              naming_suffix                = "apps"
              namespace                    = "notprod"
              pipeline_name                = "foo"
              db_instance_id               = "1234"
              burst_balance_threshold      = "20"
              cpu_utilization_threshold    = "80"
              disk_queue_depth_threshold   = "64"
              freeable_memory_threshold    = "64000000"
              free_storage_space_threshold = "20000000000"
              swap_usage_threshold         = "1024000000"
              db_connections_threshold     = "100"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_rds_alarms_burst_balance_too_low(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.burst_balance_too_low"]["threshold"], "20")

    def test_rds_alarms_cpu_utilization_too_high(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.cpu_utilization_too_high"]["threshold"], "80")

    def test_rds_alarms_disk_queue_depth_too_high(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.disk_queue_depth_too_high"]["threshold"], "64")

    def test_rds_alarms_freeable_memory_too_low(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.freeable_memory_too_low"]["threshold"], "64000000")

    def test_rds_alarms_free_storage_space_too_low(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.free_storage_space_too_low"]["threshold"], "20000000000")

    def test_rds_alarms_swap_usage_too_high(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.swap_usage_too_high"]["threshold"], "1024000000")

    def test_rds_alarms_database_connections_too_high(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_metric_alarm.database_connections_too_high"]["threshold"], "100")

    def test_lambda_slack_handler(self):
        self.assertEqual(self.result['rds_alarms']["aws_lambda_function.lambda_slack"]["handler"], "function.lambda_handler")

    def test_lambda_slack_runtime(self):
        self.assertEqual(self.result['rds_alarms']["aws_lambda_function.lambda_slack"]["runtime"], "python3.7")

    def test_lambda_slack_timeout(self):
        self.assertEqual(self.result['rds_alarms']["aws_lambda_function.lambda_slack"]["timeout"], "60")

    def test_lambda_slack_name(self):
        self.assertEqual(self.result['rds_alarms']["aws_lambda_function.lambda_slack"]["tags.Name"], "lambda-slack-1234-apps")

    def test_lambda_slack_function_name(self):
        self.assertEqual(self.result['rds_alarms']["aws_lambda_function.lambda_slack"]["function_name"], "1234-notprod-lambda-slack")

    def test_lambda_iam_policy_name(self):
        self.assertEqual(self.result['rds_alarms']["aws_iam_role_policy.lambda_policy_slack"]["name"], "1234-notprod-lambda-policy-slack")

    def test_lambda_iam_role_name(self):
        self.assertEqual(self.result['rds_alarms']["aws_iam_role.lambda_role_slack"]["name"], "1234-notprod-lambda-role-slack")

    def test_lambda_iam_role_tag(self):
        self.assertEqual(self.result['rds_alarms']["aws_iam_role.lambda_role_slack"]["tags.Name"], "iam-lambda-slack-1234-apps")

    def test_cw_log_groups(self):
        self.assertEqual(self.result['rds_alarms']["aws_cloudwatch_log_group.lambda_log_group_slack"]["tags.Name"], "lambda-log-group-slack-1234-apps")

    def test_iam_policy_logging(self):
        self.assertEqual(self.result['rds_alarms']["aws_iam_policy.lambda_logging_policy_slack"]["name"], "foo-notprod-lambda-logging-policy-slack")

if __name__ == '__main__':
    unittest.main()
