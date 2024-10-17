# -- import statments -- #

import requests
import os
from dotenv import load_dotenv, find_dotenv

# -- Import Local Environmental Variables -- #

load_dotenv(find_dotenv(), override=True)

CLIENT_ID = os.getenv('CLIENT_ID')
CLIENT_SECERT = os.getenv('CLIENT_SECRET')
WORK_SPACE = os.getenv('WORK_SPACE_ID')
PASSWORD = os.getenv('DB_PASS')

# -- Airbyte API URLS -- #

AIRBYTE_PUBLIC_API = "http://localhost:8000/api/public/v1/"
AIRBYTE_API = "http://localhost:8000/api/v1/"

# -- Constants -- #
DEST_ID = "2b4b369c-6429-46f3-ae68-89bf15ba07dc" 

# -- Main Code -- #
# function to test the connection with the API
def test_connection() -> bool:
    """
    Function to test the connection with the API
    
    Returns:
        Bool: True if the connection is working, False otherwise.
    """
    health_url = AIRBYTE_PUBLIC_API + '/health'

    health_response = requests.get(health_url)
    connection_res = health_response.text

    if connection_res == 'Successful operation':
        return True
    
    else:
        return False

# print(test_connection())

# function to get the token used for authorization
def get_access_token(client_id: str, client_secret: str) -> str:
    """
    Function to get the authorization token
    
    Args:
        client_id (str): airbyte client id credential
        client_secret (str): airbyte client secret credential
    Returns:
        str: string containing the authorization token
    """

    url_token = AIRBYTE_PUBLIC_API + "/applications/token"

    payload = {
        "client_id": client_id,
        "client_secret": client_secret,
    }

    headers = {
        "accept": "application/json",
        "content-type": "application/json"
    }

    try:
        token_response = requests.post(url_token, json=payload, headers=headers)
        token_response.raise_for_status()
        
        return token_response.json()['access_token']
    
    except Exception as e:
        print(e)
        return ""
# TOKEN = get_access_token(CLIENT_ID, CLIENT_SECERT)

# function that gets the list of sources in the workspace
def get_list_sources(workspace: str, token: str) -> list:
    """
    function that gets the list of sources in the workspace

    Args:
        workspace (str): airbyte workspace id
        token (str): airbyte authorization token
    
    Returns:
        list : a list of sources in the given workspace
    """
    url = AIRBYTE_API + "/sources/list"

    payload = {
        "workspaceId": workspace
    }

    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": f"Bearer {token}" 
    }

    try: 
        response = requests.post(url, json=payload, headers=headers)
        response.raise_for_status()

        sources = response.json()['sources']
        source_list = []
        for source in sources[2:]:
            source_list.append({'source_id': source['sourceId'], 'source_name': source['name']})

        return source_list
    
    except Exception as e:
        print(f"={e}")
        return []

# source_list = get_list_sources(WORK_SPACE, TOKEN)
# print(source_list)

# function to get jsonschema of a source:
def get_jsonschema(source_id: str, token: str) -> dict:
    """
    function to get jsonschema of a source

    Args:
        source_id (str): The id of the source
        token (str): airbyte authorization token
    
    Returns:
        dict: a dictionary containing the jsonschema
    """
    url = AIRBYTE_API + "/sources/discover_schema"

    payload = {
        "sourceId": source_id
    }

    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": "Bearer " + token
    }

    try:
        response = requests.post(url, json=payload, headers=headers)
        response.raise_for_status()

        schema_response = response.json()
        return schema_response['catalog']['streams'][0]['stream']['jsonSchema']
    
    except Exception as e:
        print(f"{e}")
        return {}

# print(get_jsonschema("e25e436c-a7d9-4c24-b652-1dc67e6180a5", TOKEN))

def create_connection(source_id, source_name, destination_id, jsonschema, token):

    url = AIRBYTE_API + "/connections/create"

    payload = {
        "sourceId": source_id,
        "destinationId": destination_id,
        "name": f"{source_name} to MySQL",
        "namespaceDefinition": "source",  
        "namespaceFormat": "${SOURCE_NAMESPACE}",  
        "syncCatalog": {
            "streams": [
                {
                    "stream": {
                        "name": "onecall",  
                        "namespace": None,  
                        "jsonSchema": jsonschema,
                        "supportedSyncModes": ["full_refresh", "incremental"]
                    },
                    "config": {
                        "syncMode": "incremental",
                        "cursorField": '_airbyte_extracted_at',  
                        "destinationSyncMode": "append",  
                        "selected": True
                    }
                }
            ]
        },
        "scheduleType": "manual",  
        "status": "active"
    }


    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": "Bearer " + token
    }
    try:
        response = requests.post(url, json=payload, headers=headers)
        response.raise_for_status()

        print(f"connection for {source_name} completed successfully")
    
    except Exception as e:
        print(f"{e}")

TOKEN = get_access_token(CLIENT_ID, CLIENT_SECERT)
SOURCES = get_list_sources(WORK_SPACE, TOKEN)

if test_connection() and (TOKEN != "") and (SOURCES != []):
    # print('entered')
    for source in SOURCES:
        jsonschema = get_jsonschema(source['source_id'], TOKEN)
        if jsonschema != {}:
            create_connection(source['source_id'], source['source_name'], DEST_ID, jsonschema, TOKEN)