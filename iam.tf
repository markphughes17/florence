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

  tags = local.common_tags
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
  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ec2_bucket" {
  role       = aws_iam_role.ec2_bucket_access.name
  policy_arn = aws_iam_policy.bucket_access.arn
}

resource "aws_iam_instance_profile" "ec2_instance" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_bucket_access.name

  tags = local.common_tags
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
        "Action" : "s3:ListAllMyBuckets",
        "Resource" : "arn:aws:s3:::*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : [
          "arn:aws:s3:::florence-bucket",
          "arn:aws:s3:::florence-bucket/*"
        ]
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

  tags = local.common_tags
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


#############
##Cloudtrail
#############

resource "aws_iam_role" "cloudtrail_role" {
  name               = "my-cloudtrail-role"
  assume_role_policy = <<-EOF
   {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
   }
  EOF

  tags = local.common_tags
}

resource "aws_iam_policy" "cloudtrail_policy" {
  name        = "my-trail-policy-for-log-groups"
  description = "policy for trail to send events to cloudwatch log groups"
  policy      = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
              "${aws_cloudwatch_log_group.trails.arn}:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
              "${aws_cloudwatch_log_group.trails.arn}:*"
            ]
        }
      ]
    }
  EOF

  tags = local.common_tags
}
resource "aws_iam_role_policy_attachment" "cloudtrail_roles_policy" {
  role       = aws_iam_role.cloudtrail_role.name
  policy_arn = aws_iam_policy.cloudtrail_policy.arn
}