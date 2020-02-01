import boto3
from decimal import Decimal

client = boto3.resource('dynamodb', region_name='us-east-2')
table = client.Table('Location')

table.put_item(
    Item={
        "id": "device123",
        "latitude": Decimal('46.624023'),
        "longitude": Decimal('14.308882'),
        "timestamp": 1580503753,
        "username": "Alexander"
    }
)


response = table.scan()['Items']
print(response)
