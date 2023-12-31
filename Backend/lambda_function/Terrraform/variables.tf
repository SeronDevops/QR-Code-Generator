variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"  # Change to your desired region
}

variable "s3_bucket_name" {
  description = "Name for the S3 bucket"
  default     = "my-qr-code-bucket"
}
