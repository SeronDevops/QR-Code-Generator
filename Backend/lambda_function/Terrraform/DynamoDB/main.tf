provider "aws" {
  region = var.aws_region
}

resource "aws_dynamodb_table" "qr_code_table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"  # On-Demand capacity
  hash_key       = "qr_code_id"
  stream_enabled = false  # Disable DynamoDB Streams for simplicity, enable if needed

  attribute {
    name = "qr_code_id"
    type = "S"
  }

  attribute {
    name = "url"
    type = "S"
  }

  # Add more attributes as needed

  tags = {
    Name = "QR Code DynamoDB Table"
  }
}

resource "aws_iam_role" "qr_code_dynamodb_role" {
  name = "qr_code_dynamodb_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_permission" "allow_dynamodb" {
  statement_id  = "AllowExecutionFromDynamoDB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.qr_code_lambda.function_name
  principal     = "dynamodb.amazonaws.com"
}

