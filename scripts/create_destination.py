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
# print(TOKEN)

# function to get dest definition to be used in creating the source
def get_dest_definition(dest_name: str, token: str) -> str:
    """
    function that retrieves the destination definition

    Args:
        dest_name (str): name of the destination you want the destination definition of
        token (str): authorization token
    Returns:
        str: string containing the destination definition
    """

    dest_def_url = AIRBYTE_API + "/destination_definitions/list" 

    headers = {
        "accept": "application/json",
        "Content-Type" : "application/json",
        "authorization" : "Bearer " + TOKEN
    } 
    
    try:
        dest_def_response = requests.post(dest_def_url, headers=headers)
        dest_def_response.raise_for_status()
        
        for destination_def in dest_def_response.json()['destinationDefinitions']:
            if dest_name.lower() in destination_def['name'].lower():
                return destination_def['destinationDefinitionId']
            
        raise Exception("destination definition not found!")
    
    except Exception as e:
        print(e)
        return ""

# print(get_source_definition('openweather', TOKEN))

# function to create openweather destination:
def create_mysql_dest(dest_definition: str, workspace: str, name: str, host: str, port: int, database: str, username: str, password: str, token: str):
    """
    function to create openweather destination in airbyte

    Args:
        des_definition (str): Open Weather Dest Definition
        workspace (str): Airbyte Workspace ID
        name (str): dest city
        host (str): db host
        port (int): db port
        database (str): db name
        username (str): db user
        password (str): db user password
        token (str): authorization token

    """
    url = AIRBYTE_API + "/destinations/create"

    payload = { 
        "destinationDefinitionId": dest_definition,
        "workspaceId": workspace,

        "connectionConfiguration": {
            "destinationType": "mysql",
            "host": host,
            "port": port,
            "database": database,
            "username": username,
            "password": password
        },

        "name": f"MySQL - {name}"}

    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": "Bearer " + token
    }

    try:
        response = requests.post(url, json=payload, headers=headers)
        # print(response.json())
        response.raise_for_status()

        print(f"Destination for MySQL successfully made")
    
    except Exception as e:
        print(f"{e}")

TOKEN = get_access_token(CLIENT_ID, CLIENT_SECERT)
SOURCE_DEF = get_dest_definition('mysql', TOKEN)

if test_connection() and (TOKEN != '') and (SOURCE_DEF != ''): # if everything was processed well before then enter to make the destination
     create_mysql_dest(SOURCE_DEF, WORK_SPACE, 'Staging', "host.docker.internal", 3306, "blinkmetrics_project_stage", "root", PASSWORD, TOKEN)

