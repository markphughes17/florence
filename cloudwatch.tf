resource "aws_cloudwatch_dashboard" "s3dash" {
  dashboard_name = "s3-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "log",
        "x" : 0,
        "y" : 24,
        "width" : 24,
        "height" : 36,
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


resource "aws_cloudwatch_log_group" "trails" {
  name = "trails"

  tags = local.common_tags
}


resource "aws_cloudwatch_query_definition" "example" {
  name = "s3_query"

  log_group_names = [
    "trails"
  ]

  query_string = <<EOF
fields @timestamp, @message
| sort @timestamp desc
| limit 25
EOF
}