resource "aws_iam_user" "generatedhealthusers" {
  count = length(var.username)
  name  = element(var.username, count.index)
}

resource "aws_iam_policy" "bucket_access" {
  name        = "bucket_policy"
  path        = "/"
  description = "Allow "
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          aws_s3_bucket.florence.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "ec2_bucket_access" {
  name = "ec2_bucket_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_bucket" {
  role       = aws_iam_role.ec2_bucket_access.name
  policy_arn = aws_iam_policy.bucket_access.arn
}

resource "aws_iam_instance_profile" "ec2_instance" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_bucket_access.name
}