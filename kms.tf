resource "aws_kms_key" "key" {
  description             = "KMS key used for encrypting the Wagonkered website S3 bucket"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}
