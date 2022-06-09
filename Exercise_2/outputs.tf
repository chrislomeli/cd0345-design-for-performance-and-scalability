# TODO: Define the output variable for the lambda function.
output "vpcid" {
    value = aws_vpc.udacity_vpc
}

output "my_lambda_arn" {
  value = aws_lambda_function.test_lambda.arn

}