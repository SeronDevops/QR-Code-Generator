provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "qr_code_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.bucket
    target_prefix = "s3-logs/"
  }

  tags = {
    Name = "QR Code Generator Bucket"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.s3_bucket_name}-logs"
  acl    = "private"
}
