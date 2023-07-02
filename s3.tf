resource "aws_s3_bucket" "florence" {
  bucket = "florence-bucket"


  tags = {
    Service = var.service_name
  }
}

resource "aws_s3_bucket_versioning" "florence" {
  bucket = aws_s3_bucket.florence.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "florence_logging" {
  bucket = "florence-log-bucket"
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