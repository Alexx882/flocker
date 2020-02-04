# Flutter cloud
http://ec2-3-16-29-237.us-east-2.compute.amazonaws.com:5000/api/ui/

## Webservice and Clustering
`main.py` runs the flask rest service with Swagger API documentation.

`run_clustering.py` clusters based on all the data and stores everything back to dynamodb.

## DynamoDB access
The credentials for AWS DynamoDB must be stored somewhere. Therefore, we used environment variables.
- AWS_ACCESS_KEY_ID\
 The access key for the AWS account

- AWS_SECRET_ACCESS_KEY\
 The secret key for the AWS account

## Debug stuff
`data_generator.py` generates some dummy data for testing the clustering.
