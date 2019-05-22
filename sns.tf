resource "aws_sns_topic" "default" {}

resource "aws_db_event_subscription" "default" {
  sns_topic = "${aws_sns_topic.default.arn}"

  source_type = "db-instance"
  source_ids  = ["${var.db_instance_id}"]

  event_categories = [
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "recovery",
  ]

  depends_on = ["aws_sns_topic_policy.default"]
}

resource "aws_sns_topic_policy" "default" {
  arn    = "${aws_sns_topic.default.arn}"
  policy = "${data.aws_iam_policy_document.sns_topic_policy.json}"
}

resource "aws_sns_topic_subscription" "sns_to_lambda" {
  topic_arn = "${aws_sns_topic.default.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.lambda_slack.arn}"
}
