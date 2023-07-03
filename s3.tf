resource "aws_s3_bucket" "florence" {
  bucket        = "florence-bucket"
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_metric" "florence" {
  bucket = aws_s3_bucket.florence.id
  name   = "FlorenceRequests"
}

resource "aws_s3_bucket_versioning" "florence" {
  bucket = aws_s3_bucket.florence.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "florence_logging" {
  bucket = "florence-log-bucket"

  tags = local.common_tags
}

resource "aws_s3_bucket_logging" "florence" {
  bucket = aws_s3_bucket.florence.id

  target_bucket = aws_s3_bucket.florence_logging.id
  target_prefix = "log/"

}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.florence.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

##########################
### Cloudtrail S3 resources
###########################

resource "aws_s3_bucket" "trail-bucket" {
  bucket        = "trail-bucket-florence"
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.trail-bucket.id

  policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:GetBucketAcl",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.trail-bucket.id}"
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.trail-bucket.id}/trails/AWSLogs/*",
        "Condition": {
          "StringEquals": {
            "s3:x-amz-acl": "bucket-owner-full-control"
          }
        }
      }
    ]
  }
  POLICY
}