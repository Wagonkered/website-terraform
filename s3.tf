#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "wagonkered_website" {
  bucket = "wagonkered-website"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "wagonkered_website" {
  bucket            = aws_s3_bucket.wagonkered_website.id
  block_public_policy = true
  block_public_acls = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "wagonkered_website_acl" {
  bucket = aws_s3_bucket.wagonkered_website.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "wagonkered_website_config" {
  bucket = aws_s3_bucket.wagonkered_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.wagonkered_website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "WagonkeredS3BucketPolicy",
    Statement = [
      {
        Sid    = "1",
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.wagonkered_website_access_identity.iam_arn
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.wagonkered_website.arn}/*"
      }
    ],
  })
}

