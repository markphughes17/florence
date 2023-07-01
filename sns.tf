resource "aws_sns_topic" "s3_alerting" {
  name = "s3-event-notification-topic"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": "SNS:Publish",
        "Resource": "arnawssns:*:*:s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.florence.arn}"}
        }
    }]
}
POLICY
}

resource "aws_s3_bucket_notification" "florence" {
  bucket = aws_s3_bucket.florence.id

  topic {
    topic_arn     = aws_sns_topic.s3_alerting.arn
    events        = ["s3ObjectCreated*"]
    filter_suffix = ".log"
  }
}

resource "aws_sns_topic_subscription" "s3_creates_email_target" {
  topic_arn = aws_sns_topic.s3_alerting.arn
  protocol  = "email"
  endpoint  = "markhughes@markhughes.tech"
}