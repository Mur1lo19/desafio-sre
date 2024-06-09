resource "aws_sqs_queue" "ext_sqs_example" {
  name                      = "ext-sqs-example"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_example1_deadletter.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "sqs_example1_deadletter" {
  name                      = "sqs-example1-deadletter"
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.ext_sqs_example.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::PRINCIPAL_ACCOUNT_ID:root"
        }
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.ext_sqs_example.arn
      }
    ]
  })
}
