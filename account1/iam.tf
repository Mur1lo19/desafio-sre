resource "aws_iam_role" "cluster_eks" {
  name = "cluster-eks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.cluster_eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "node_group_eks" {
  name = "node-group-eks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  role       = aws_iam_role.node_group_eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.node_group_eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "registry_policy" {
  role       = aws_iam_role.node_group_eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


resource "aws_iam_role_policy" "sns_policy" {
  name = "sns-policy"
  role = aws_iam_role.node_group_eks.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sns:Publish"
        Effect = "Allow"
        Resource = aws_sns_topic.sns_example.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "sqs_policy" {
  name = "sqs-policy"
  role = aws_iam_role.node_group_eks.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sqs:SendMessage"
        Effect = "Allow"
        Resource = "arn:aws:sqs:us-east-1:ID_ACCOUNT2:ext-sqs-example"
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3-policy"
  role = aws_iam_role.node_group_eks.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Resource = aws_s3_bucket.s3_example.arn
        Resource = "${aws_s3_bucket.s3_example.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "sm_policy" {
  name = "sm-policy"
  role = aws_iam_role.node_group_eks.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "secretsmanager:GetSecretValue"
        Effect = "Allow"
        Resource = aws_secretsmanager_secret.sm_example.arn
      }
    ]
  })
}