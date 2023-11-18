resource "aws_api_gateway_rest_api" "rest-api" {
  name = "auth-usr"
}

resource "aws_api_gateway_resource" "user-resource" {
  parent_id   = aws_api_gateway_rest_api.rest-api.root_resource_id
  path_part   = "user"
  rest_api_id = aws_api_gateway_rest_api.rest-api.i
}


/*--------------------------------------------------------
#| Post Method with validator and cognito auth          |
--------------------------------------------------------*/

resource "aws_api_gateway_request_validator" "validation" {
  name                        = "para-body-validation"
  rest_api_id                 = aws_api_gateway_rest_api.rest-api.id
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "user-post" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api-auth.id
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.user-resource.id
  rest_api_id   = aws_api_gateway_rest_api.rest-api.id
  request_validator_id = aws_api_gateway_request_validator.validation.id
   request_parameters = {
    "method.request.header.Content-Type" = true
    "method.request.header.Authorizer" = true
  }
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest-api.id
  resource_id = aws_api_gateway_resource.user-resource.id
  http_method = aws_api_gateway_method.user-post.http_method
  status_code = "200"
}
resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.rest-api.id
  resource_id = aws_api_gateway_resource.user-resource.id
  http_method = aws_api_gateway_method.user-post.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest-api.id
  resource_id             = aws_api_gateway_resource.user-resource.id
  http_method             = aws_api_gateway_method.user-post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda-func.invoke_arn
  request_templates = {
     "application/json" = <<EOF
    #set($inputRoot = $input.path('$'))
    {
        "headers": {
            #foreach($param in $input.params().header.keySet())
                "$param": "$util.escapeJavaScript($input.params().header.get($param))"
                #if($foreach.hasNext),#end
            #end
        },
        "body": "$util.base64Encode($input.body)",
        "httpMethod": "$context.httpMethod"
    }
  EOF
  }
}


/*--------------------------------------------------------
#| Get Method with validation and cognito token         |
--------------------------------------------------------*/

resource "aws_api_gateway_request_validator" "get-validation" {
  name                        = "header-validation"
  rest_api_id                 = aws_api_gateway_rest_api.rest-api.id
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "user-get" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api-auth.id
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.user-resource.id
  rest_api_id   = aws_api_gateway_rest_api.rest-api.id
  request_validator_id = aws_api_gateway_request_validator.get-validation.id
   request_parameters = {
    "method.request.header.Content-Type" = true
    "method.request.header.Authorizer" = true
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest-api.id
  resource_id             = aws_api_gateway_resource.user-resource.id
  http_method             = aws_api_gateway_method.user-get.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda-func.invoke_arn
}