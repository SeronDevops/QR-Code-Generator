variable "pipeline_name" {
  description = "Name of the AWS CodePipeline"
  type        = string
  default     = "qr_code_pipeline"
}

variable "aws_region" {
  description = "AWS region where the CodePipeline will be created"
  type        = string
  default     = "us-east-1"  # Change to your desired AWS region
}

variable "codecommit_repository_name" {
  description = "Name of the CodeCommit repository"
  type        = string
  default     = "qr_code_repository"
}

variable "codecommit_branch_name" {
  description = "Name of the CodeCommit repository branch"
  type        = string
  default     = "main"  # Change to your desired branch name
}

# CodeBuild Project Variables
variable "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  type        = string
  default     = "qr_code_build"
}

variable "codebuild_compute_type" {
  description = "CodeBuild compute type"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
  description = "CodeBuild build environment image"
  type        = string
  default     = "aws/codebuild/standard:4.0"
}

variable "codebuild_buildspec" {
  description = "CodeBuild buildspec file"
  type        = string
  default     = "buildspec.yaml"
}

# Lambda Function Variables
variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "qr_code_lambda_function"
}

variable "lambda_runtime" {
  description = "Lambda function runtime"
  type        = string
  default     = "python3.8"
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 512
}

# IAM Role Variables
variable "codepipeline_role_name" {
  description = "Name of the CodePipeline IAM role"
  type        = string
  default     = "qr_code_pipeline_role"
}

variable "codebuild_role_name" {
  description = "Name of the CodeBuild IAM role"
  type        = string
  default     = "qr_code_codebuild_role"
}

variable "lambda_role_name" {
  description = "Name of the Lambda IAM role"
  type        = string
  default     = "qr_code_lambda_role"
}

# Add more variables as needed based on your specific configuration
