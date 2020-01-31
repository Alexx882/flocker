import boto3

client = boto3.resource('dynamodb', region_name='us-east-2')
table = client.Table('Location')

response =  table.scan()['Items']
print(response)