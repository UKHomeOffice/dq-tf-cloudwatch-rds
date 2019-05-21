output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = "${aws_sns_topic.default.arn}"
}

output "role_id" {
  description = "ID of the IAM role"
  value = "${aws_iam_role.lambda_role_slack.id}"
}

output "role_arn" {
  description = "ARN of the IAM role"
  value = "${aws_iam_role.lambda_role_slack.arn}"
}
