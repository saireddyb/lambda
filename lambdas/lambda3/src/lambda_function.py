import json
import bs4

def lambda_handler(event, context):
    # Check numpy version
    print("BeautifulSoup version:", bs4.__version__)
    # TODO: Implement your logic here

    return {
        'statusCode': 200,
        'body': 'Hello from Lambda!.'
    }