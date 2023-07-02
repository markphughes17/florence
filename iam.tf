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
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : [
          "${aws_s3_bucket.florence.arn}/*"
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

resource "aws_iam_group" "users" {
  name = "users"
}

resource "aws_iam_policy" "user_cloudwatch_access" {
  name        = "user_policy"
  path        = "/"
  description = "Allow cloudwatch and instance connect access"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2-instance-connect:SendSSHPublicKey",
        "Resource" : [
          "arn:aws:ec2:eu-west-2:${var.account_id}:instance/${aws_instance.florence.id}"
        ],
        "Condition" : {
          "StringEquals" : {
            "ec2:osuser" : "ami-username"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:DescribeInstances",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "group_attach" {
  group      = aws_iam_group.users.name
  policy_arn = aws_iam_policy.user_cloudwatch_access.arn
}

resource "aws_iam_group_membership" "team" {
  name = "group-membership"

  users = var.username

  group = aws_iam_group.users.name
}