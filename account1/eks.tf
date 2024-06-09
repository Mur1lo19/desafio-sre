resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.cluster_eks.arn

  vpc_config {
    subnet_ids = [aws_subnet.my_public1.id, aws_subnet.my_public2.id]
  }
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.node_group_eks.arn
  subnet_ids      = [aws_subnet.my_private1.id, aws_subnet.my_private2.id]

  scaling_config {
    desired_size = 5
    max_size     = 10
    min_size     = 5
  }

  instance_types = ["t3.medium"]
}
