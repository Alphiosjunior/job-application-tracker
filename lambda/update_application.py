import json
import boto3
import os
from datetime import datetime
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

class DecimalEncoder(json.JSONEncoder):
    """Helper class to convert DynamoDB Decimal types to JSON"""
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super(DecimalEncoder, self).default(obj)

def lambda_handler(event, context):
    """
    Updates a job application
    Expected path parameter: /applications/{id}
    Expected body: {"company": "...", "position": "...", "status": "...", "date": "..."}
    """
    try:
        # Extract application ID from path parameters
        application_id = event['pathParameters']['id']
        
        # Parse request body
        body = json.loads(event['body'])
        
        # Check if application exists
        response = table.get_item(
            Key={'applicationId': application_id}
        )
        
        if 'Item' not in response:
            return {
                'statusCode': 404,
                'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type',
                    'Access-Control-Allow-Methods': 'OPTIONS,POST,GET,PUT,DELETE'
                },
                'body': json.dumps({
                    'error': 'Application not found'
                })
            }
        
        # Build update expression dynamically
        update_expression = "SET updatedAt = :updatedAt"
        expression_attribute_values = {
            ':updatedAt': datetime.utcnow().isoformat()
        }
        
        # Add fields to update if they exist in the request
        if 'company' in body:
            update_expression += ", company = :company"
            expression_attribute_values[':company'] = body['company']
        
        if 'position' in body:
            update_expression += ", #pos = :position"
            expression_attribute_values[':position'] = body['position']
        
        if 'status' in body:
            update_expression += ", #st = :status"
            expression_attribute_values[':status'] = body['status']
        
        if 'date' in body:
            update_expression += ", #dt = :date"
            expression_attribute_values[':date'] = body['date']
        
        # Update item in DynamoDB
        response = table.update_item(
            Key={'applicationId': application_id},
            UpdateExpression=update_expression,
            ExpressionAttributeNames={
                '#pos': 'position',
                '#st': 'status',
                '#dt': 'date'
            },
            ExpressionAttributeValues=expression_attribute_values,
            ReturnValues='ALL_NEW'
        )
        
        updated_application = response['Attributes']
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET,PUT,DELETE'
            },
            'body': json.dumps({
                'message': 'Application updated successfully',
                'application': updated_application
            }, cls=DecimalEncoder)
        }
        
    except KeyError:
        return {
            'statusCode': 400,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET,PUT,DELETE'
            },
            'body': json.dumps({
                'error': 'Missing application ID in path or invalid body'
            })
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET,PUT,DELETE'
            },
            'body': json.dumps({
                'error': 'Internal server error',
                'details': str(e)
            })
        }