# AWS Provider
provider "aws" {
    region = var.my_region
}

# Create a VPC
resource "aws_vpc" "udacity_vpc" {
    cidr_block = "10.0.0.0/16"
}

# Alow access to Lambda assumeed role
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Lambda function
resource "aws_lambda_function" "test_lambda" {
  filename      = "greet_lambda.py.zip"
  function_name = "udacity-greeting-function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "greet_lambda.lambda_handler"
  environment {
        variables = {
        greeting = "Hi There",
        }
  }

  source_code_hash = filebase64sha256("greet_lambda.py.zip")

  runtime = "python3.9"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example,
  ]

}

# CloudWatch Log Group for the Lambda Function.
resource "aws_cloudwatch_log_group" "example" {
  name   = "/aws/lambda/udacity-greeting-function"
  retention_in_days = 14
}

# Access policy for cloudwatch log group
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}