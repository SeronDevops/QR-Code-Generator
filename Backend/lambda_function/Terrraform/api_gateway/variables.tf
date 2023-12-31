variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"  # Change to your desired region
}

variable "api_name" {
  description = "Name for the API Gateway"
  default     = "qr_code_api"
}
