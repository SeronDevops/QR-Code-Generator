variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"  # Change to your desired region
}

variable "lambda_function_name" {
  description = "Name for the Lambda function"
  default     = "qr_code_lambda_function"
}
