provider "aws" {
  region = var.aws_region
}

# CodePipeline
resource "aws_codepipeline" "qr_code_pipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifact_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.codecommit_repository_name
        BranchName     = var.codecommit_branch_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "BuildAction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.qr_code_build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["build_output"]

      configuration = {
        FunctionName    = aws_lambda_function.qr_code_lambda.function_name
        UserParameters  = jsonencode({ key1 = "value1", key2 = "value2" })
        LambdaAlias     = "latest"  # Add any specific alias or version you want to deploy
      }
    }
  }
}

# CodeBuild Project
resource "aws_codebuild_project" "qr_code_build" {
  name       = "qr_code_build"
  description = "CodeBuild project for building the QR Code Generator"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "S3"
    location = aws_s3_bucket.artifact_bucket.bucket
    name = "build_output"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yaml"
    report_build_status = true
  }

  # Add additional configuration as needed
}

# IAM Roles
resource "aws_iam_role" "codepipeline_role" {
  name = "qr_code_pipeline_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "codebuild_role" {
  name = "qr_code_codebuild_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })

  # Attach policies or permissions as needed
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

# Lambda Function
resource "aws_lambda_function" "qr_code_lambda" {
  function_name    = "qr_code_lambda_function"  # Update with your Lambda function name
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

# Lambda Function Permission
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.qr_code_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

# ... (rest of the existing code)
