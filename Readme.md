# User Authentication serverless application 

**AWS Services :-**

* Terraform
- Cognito
* ApiGatway
+ Lambda function
- S3
 


**Using _non-proxy_ lambda integration with api**

> [!IMPORTANT]
> In apiGatway request-Integration mapping template uploded file is converted into binary using base64 [check-here](/apis.tf)


User getting authenticate using [cognito](/authorizer.tf) userpool, with Token user can putobject and getobject from s3 using [apigatway](/apis.tf)_post and get method_,[lambda function](/lambda-func.py) is to decode the user token and save the file as username.jpeg, so that the users can access there own file in s3 using get method(with token)

![s3 with cognito (1)](https://github.com/shorya1853/s3-cognito-severless/assets/98734613/fa9338ea-724c-4717-8118-71703e2543b1)
