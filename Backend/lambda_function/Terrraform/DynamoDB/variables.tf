variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"  # Change to your desired region
}

variable "dynamodb_table_name" {
  description = "Name for the DynamoDB table"
  default     = "qr_code_table"
}
