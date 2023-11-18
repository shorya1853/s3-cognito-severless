resource "aws_cognito_user_pools" "auth-user-s3" {
  name = "auth-user-s3"
}

resource "aws_api_gateway_authorizer" "api-auth" {
  name = "CognitoUserPoolAuthorizer"
  type = "COGNITO_USER_POOLS"
  rest_api_id = aws_api_gateway_rest_api.rest-api.id
  provider_arns = aws_cognito_user_pools.auth-user-s3.arn
}