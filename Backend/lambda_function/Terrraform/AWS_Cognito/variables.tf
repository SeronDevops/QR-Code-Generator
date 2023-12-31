variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
  default     = "qr_code_user_pool"
}

variable "identity_pool_name" {
  description = "Name of the Cognito Identity Pool"
  type        = string
  default     = "qr_code_identity_pool"
}

variable "cognito_role_name" {
  description = "Name of the IAM role associated with Cognito Identity Pool"
  type        = string
  default     = "qr_code_cognito_role"
}

variable "cognito_unauthenticated_role_name" {
  description = "Name of the IAM unauthenticated role associated with Cognito Identity Pool"
  type        = string
  default     = "qr_code_cognito_unauthenticated_role"
}

variable "cognito_user_pool_client_name" {
  description = "Name of the Cognito User Pool Client"
  type        = string
  default     = "qr_code_user_pool_client"
}

variable "cognito_domain" {
  description = "Cognito domain prefix"
  type        = string
  default     = "qr-code-auth"  # Replace with your desired Cognito domain prefix
}

variable "allowed_oauth_flows" {
  description = "Allowed OAuth flows for the Cognito User Pool Client"
  type        = list(string)
  default     = ["code"]
}

variable "allowed_oauth_scopes" {
  description = "Allowed OAuth scopes for the Cognito User Pool Client"
  type        = list(string)
  default     = ["openid", "email", "profile"]
}

variable "callback_urls" {
  description = "Allowed callback URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["https://example.com/callback"]
}

variable "logout_urls" {
  description = "Allowed logout URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["https://example.com/logout"]
}

# Add more variables as needed based on your specific Cognito configuration
