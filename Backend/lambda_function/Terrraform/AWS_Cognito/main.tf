provider "aws" {
  region = var.aws_region
}

resource "aws_cognito_user_pool" "qr_code_user_pool" {
  name = var.user_pool_name

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  schema {
    name     = "email"
    attribute_data_type = "String"
    required = true
  }

  schema {
    name     = "custom_attribute"
    attribute_data_type = "String"
    required = false
  }

  tags = {
    Name = "QR Code User Pool"
  }
}

resource "aws_cognito_identity_pool" "qr_code_identity_pool" {
  identity_pool_name = var.identity_pool_name
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.qr_code_client.id
    provider_name           = aws_cognito_user_pool.qr_code_user_pool.endpoint
    server_side_token_check = true
  }

  tags = {
    Name = "QR Code Identity Pool"
  }
}

resource "aws_cognito_user_pool_client" "qr_code_client" {
  name            = "qr_code_client"
  user_pool_id    = aws_cognito_user_pool.qr_code_user_pool.id
  generate_secret = false
}

