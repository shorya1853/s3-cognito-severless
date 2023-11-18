provider "aws" {
    profile = var.profile
    region = var.region
}

data "archive_file" "api_lambda_code_data" {
  depends_on  = [null_resource.api_clone_repo]
  type        = "zip"
  source_dir  = "./lambda-func.py"
  output_path = "./lambda-func.zip"
}

data "aws_iam_role" "role" {
  name = "lambda_to_sqs-role-4rgy4sh4"
}

resource "aws_lambda_function" "lambda-func" {
    function_name = "lambda_handler"
    role = data.aws_iam_role.role.arn
    layers = [  ]
    runtime = "python3.10"
    handler ="lambda-func.lambda_handler"
    filename = "lambda-func.zip"
  
}
