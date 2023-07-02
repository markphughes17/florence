resource "aws_cloudwatch_dashboard" "s3dash" {
  dashboard_name = "s3-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "metric",
        "x" : 8,
        "y" : 24,
        "width" : 8,
        "height" : 6,
        "properties" : {
          "metrics" : [
            [
              "AWS/S3",
              "BucketSizeBytes"
            ],
            [
              "AWS/S3",
              "NumberOfObjects"
            ],
            [
              "AWS/S3",
              "DeleteRequests"
            ],
            [
              "AWS/S3",
              "5xxErrors"
            ],
            [
              "AWS/S3",
              "TotalRequestLatency"
            ]
          ],
          "period" : 60,
          "stat" : "Maximum",
          "region" : "eu-west-2",
          "title" : "S3|Main Stats"
        }
      }
    ]
  })
}