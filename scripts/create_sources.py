# -- import statments -- #

import requests
import os
from dotenv import load_dotenv, find_dotenv
from get_lat_lon import get_lat_lon

# -- Import Local Environmental Variables -- #

load_dotenv(find_dotenv(), override=True)

API_KEY = os.getenv('BLINKMETRICS_OPENWEATHER_API_KEY')
CLIENT_ID = os.getenv('CLIENT_ID')
CLIENT_SECERT = os.getenv('CLIENT_SECRET')
WORK_SPACE = os.getenv('WORK_SPACE_ID')

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

# function to get source definition to be used in creating the source
def get_source_definition(source_name: str, token: str) -> str:
    """
    function that retrieves the source definition

    Args:
        source_name (str): name of the source you want the source definition of
        token (str): authorization token
    Returns:
        str: string containing the source definition
    """

    source_def_url = AIRBYTE_API + "/source_definitions/list" 

    headers = {
        "accept": "application/json",
        "Content-Type" : "application/json",
        "authorization" : "Bearer " + token
        } 
    
    try:
        source_def_response = requests.post(source_def_url, headers=headers)
        source_def_response.raise_for_status()
        
        # print(source_def_response.json()['sourceDefinitions'])
        for source_def in source_def_response.json()['sourceDefinitions']:
            # print(source_def['name'])
            # print(source_def['name'].lower())
            if source_name in source_def['name'].lower():
                return source_def['sourceDefinitionId']
            
        raise Exception("source definition not found!")
    
    except Exception as e:
        print(e)
        return ""

# print(get_source_definition('openweather', TOKEN))

# function to create openweather source:
def create_openweather_source(api_key: str, source_definition: str, workspace: str, city_name: str, lat: str, lon: str, token: str):
    """
    function to create openweather source in airbyte

    Args:
        api_key (str): Open Weather API Key
        source_definition (str): Open Weather Source Definition
        workspace (str): Airbyte Workspace ID
        city_name (str): desired city
        lat (str): city latitude
        lon (str): city longitude
        token (str): authorization token

    """
    url = AIRBYTE_API + "/sources/create"

    payload = {
        "sourceDefinitionId": source_definition,
        "workspaceId": workspace,
        
        "connectionConfiguration": {
            "appid": api_key,
            "lat": f'{lat}',
            "lon": f'{lon}',
            "units": "metric"
        },

        "name": f"OpenWeather - {city_name}"
    }

    headers = {
        "accept": "application/json",
        "Content-Type" : "application/json",
        "authorization" : "Bearer " + token
    } 
    # print(payload)
    # print('----')
    # print(headers)
    try:
        response = requests.post(url, json=payload, headers=headers)
        # print(response.json())
        response.raise_for_status()

        print(f"Source for {city_name} successfully made")
    
    except Exception as e:
        print(f"{e}")

TOKEN = get_access_token(CLIENT_ID, CLIENT_SECERT)
SOURCE_DEF = get_source_definition('openweather', TOKEN)

if test_connection() and (TOKEN != '') and (SOURCE_DEF != ''): # if everything was processed well before then enter to make the source
    # print('entered')
    cities = get_lat_lon() # get the city name, it's lon and lat values

    for city in cities: # parse the list and create a source from them!
        # print(city)
        create_openweather_source(API_KEY, SOURCE_DEF, WORK_SPACE, city['city_name'], city['latitude'], city['longitude'], TOKEN)

# print('process finished!')

