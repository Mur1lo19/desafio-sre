resource "aws_sns_topic" "sns_example" {
  name = "sns-example"
}

resource "aws_sns_topic_subscription" "topic_sqs_example1" {
  topic_arn = aws_sns_topic.sns_example.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_example1.arn
}

resource "aws_sns_topic_subscription" "topic_sqs_example2" {
  topic_arn = aws_sns_topic.sns_example.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_example2.arn
}