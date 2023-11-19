provider "aws" {
    profile = "boto_usr"
    region = "ap-south-1"
}

# data "archive_file" "api_lambda_code_data" {
#   type        = "zip"
#   source_dir  = "lambda-func.py"
#   output_path = "lambda-func.zip"
# }

data "aws_iam_role" "role" {
  name = "lambda_to_sqs-role-4rgy4sh4"
}

resource "aws_lambda_permission" "post-lambda-permission" {
  statement_id  = "Allowlambda_handler-postInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "lambda_handler"
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:893711537471:${aws_api_gateway_rest_api.rest-api.id}/*/${aws_api_gateway_method.user-post.http_method}${aws_api_gateway_resource.user-resource.path}"
}

resource "aws_lambda_permission" "get-lambda_permission" {
  statement_id  = "Allowlambda_handler-getInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "lambda_handler"
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:893711537471:${aws_api_gateway_rest_api.rest-api.id}/*/${aws_api_gateway_method.user-get.http_method}${aws_api_gateway_resource.user-resource.path}"
}

resource "aws_lambda_function" "lambda-func" {
    function_name = "lambda_handler"
    role = data.aws_iam_role.role.arn
    layers = [ 
      "arn:aws:lambda:ap-south-1:893711537471:layer:jwt-decoder:1"
     ]
    runtime = "python3.10"
    handler ="lambda-func.lambda_handler"
    filename = "lambda-func.zip"
  
}
