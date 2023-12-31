provider "aws" {
  region = var.aws_region
}

resource "aws_api_gateway_rest_api" "qr_code_api" {
  name        = var.api_name
  description = "QR Code API"
}

resource "aws_api_gateway_resource" "qr_code_resource" {
  rest_api_id = aws_api_gateway_rest_api.qr_code_api.id
  parent_id   = aws_api_gateway_rest_api.qr_code_api.root_resource_id
  path_part   = "generate"
}

resource "aws_api_gateway_method" "qr_code_method" {
  rest_api_id = aws_api_gateway_rest_api.qr_code_api.id
  resource_id = aws_api_gateway_resource.qr_code_resource.id
  http_method = "POST"
}

resource "aws_api_gateway_integration" "qr_code_integration" {
  rest_api_id             = aws_api_gateway_rest_api.qr_code_api.id
  resource_id             = aws_api_gateway_resource.qr_code_resource.id
  http_method             = aws_api_gateway_method.qr_code_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.qr_code_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "qr_code_method_response" {
  rest_api_id = aws_api_gateway_rest_api.qr_code_api.id
  resource_id = aws_api_gateway_resource.qr_code_resource.id
  http_method = aws_api_gateway_method.qr_code_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "qr_code_integration_response" {
  rest_api_id  = aws_api_gateway_rest_api.qr_code_api.id
  resource_id  = aws_api_gateway_resource.qr_code_resource.id
  http_method  = aws_api_gateway_method.qr_code_method.http_method
  status_code  = aws_api_gateway_method_response.qr_code_method_response.status_code
  content_handling = "CONVERT_TO_TEXT"
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_deployment" "qr_code_deployment" {
  depends_on = [aws_api_gateway_integration.qr_code_integration]
  rest_api_id = aws_api_gateway_rest_api.qr_code_api.id
  stage_name  = "prod"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.qr_code_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

