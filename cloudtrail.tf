resource "aws_cloudtrail" "florence_s3" {
  name                       = "florence-s3"
  s3_bucket_name             = aws_s3_bucket.trail-bucket.id
  s3_key_prefix              = "trails"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_role.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.trails.arn}:*"
  depends_on                 = [aws_s3_bucket_policy.bucket_policy]

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.florence.arn}/"]
    }
  }

  tags = local.common_tags
}