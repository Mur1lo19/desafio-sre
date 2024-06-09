resource "aws_sqs_queue" "sqs_example1" {
  name                      = "sqs-example1"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_example1_deadletter.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "sqs_example1_deadletter" {
  name                      = "sqs-example1-deadletter"
}

resource "aws_sqs_queue" "sqs_example2" {
  name                      = "sqs-example2"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_example1_deadletter.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "sqs_example2_deadletter" {
  name                      = "sqs-example2-deadletter"
}