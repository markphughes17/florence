resource "aws_cloudwatch_dashboard" "s3dash" {
  dashboard_name = "s3-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "log",
        "x" : 12,
        "y" : 24,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "region" : "eu-west-2",
          "title" : "S3 writes",
          "query" : "SOURCE 'florence-s3'",
          "view" : "table"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "ec2dash" {
  dashboard_name = "ec2-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "metric",
        "x" : 8,
        "y" : 0,
        "width" : 8,
        "height" : 6,
        "properties" : {
          "metrics" : [
            [
              "AWS/EC2",
              "NetworkIn"
            ]
          ],
          "period" : 60,
          "stat" : "Maximum",
          "region" : "eu-west-2",
          "title" : "EC2|Network In"
        }
      },
      {
        "type" : "metric",
        "x" : 16,
        "y" : 0,
        "width" : 8,
        "height" : 6,
        "properties" : {
          "metrics" : [
            [
              "AWS/EC2",
              "NetworkOut"
            ]
          ],
          "period" : 60,
          "stat" : "Maximum",
          "region" : "eu-west-2",
          "title" : "EC2|Network Out"
        }
      }
    ]
  })
}


resource "aws_cloudwatch_log_group" "trails" {
  name = "trails"

  tags = local.common_tags
}