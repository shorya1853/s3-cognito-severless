import json
import boto3
import base64
import jwt

s3 = boto3.client('s3')

def get_cognito_username(token):
    try:
        decoded_token = jwt.decode(token, algorithms=["RS256"], options={"verify_signature": False})

        # Extract the username
        username = decoded_token['username']
        return username
    except Exception as e:
        print(f"Error decoding Cognito token: {e}")
        return None

def lambda_handler(event, context):
    token = event['headers']['Authorizer']
    username = get_cognito_username(token)
    
    try:
        if event['httpMethod'] == "POST":
            binarydata = event['body']
            decoded_data = base64.b64decode(binarydata)
            if username: 
                s3.put_object(Body = decoded_data, Bucket = "csvconverted123", Key = f'{username}.jpeg')
                return {
                    'statusCode': 200,
                    'body': json.dumps('Image uploaded successfully')
                }
            return {
                'statusCode': 500,
                'body': f'file not found'
            }
        if event["httpMethod"] == "GET":
            print('hello')
            body = s3.get_object(Bucket="csvconverted123", Key= f"{username}.jpeg")
            return {
                'statusCode': 200,
                'body': json.dumps("file founded") 
            }
        return {
            'statusCode': 500,
            'body': f'file not found'
        }
    except Exception as e:
        return {
            "message": f"error{e}",
            "status": 500
        }
    
    