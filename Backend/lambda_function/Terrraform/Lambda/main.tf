provider "aws" {
  region = var.aws_region
}

resource "aws_lambda_function" "qr_code_lambda" {
  function_name    = var.lambda_function_name
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  filename         = "${path.module}/../../backend/lambda_function/lambda_function.zip"
  source_code_hash = filebase64("${path.module}/../../backend/lambda_function/lambda_function.zip")
  role             = aws_iam_role.qr_code_lambda_role.arn
  timeout          = 30  # Adjust based on the expected execution time of your function
  memory_size      = 512  # Adjust based on the memory requirements of your function

  environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.qr_code_bucket.bucket
    }
  }

  tags = {
    Name = "QR Code Lambda Function"
  }
}

resource "aws_iam_role" "qr_code_lambda_role" {
  name = "qr_code_lambda_role"

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

resource "aws_lambda_permission" "allow_api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.qr_code_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}
