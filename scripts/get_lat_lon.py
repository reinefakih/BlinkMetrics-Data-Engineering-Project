# -- Import Statements -- #
import requests
import os
from dotenv import load_dotenv, find_dotenv

# -- Import Local Environmental Variables -- #
# here we will be getting the api key from the local environmental variables

load_dotenv(find_dotenv(), override=True)
API_KEY = os.getenv('BLINKMETRICS_OPENWEATHER_API_KEY')
# print(API_KEY)

# -- Main Code -- #

# first I will define a dictionary containing City Name as Key and Country Code as Value to use it to retrieve the lat-lon values
# I will be using a small number of cities :D
CITY_COUNTRY_CODE = {
    "Canberra": "AU",   # Australia
    "Brasília": "BR",   # Brazil
    "Ottawa": "CA",     # Canada
    "Beijing": "CN",    # China
    "Paris": "FR",      # France
    "Berlin": "DE",     # Germany
    "Tehran": "IR",     # Iran
    "Baghdad": "IQ",    # Iraq
    "Rome": "IT",       # Italy
    "Tokyo": "JP",      # Japan
    "Amman": "JO",      # Jordan
    "Seoul": "KR",      # South Korea
    "Beirut": "LB",     # Lebanon
    "Malé": "MV",       # Maldives
    "Moscow": "RU",     # Russia
    "Riyadh": "SA",     # Saudi Arabia
    "Pretoria": "ZA",   # South Africa
    "Kyiv": "UA",       # Ukraine
    "Abu Dhabi": "AE",  # United Arab Emirates
    "London": "GB",     # United Kingdom
    "Washington, D.C.": "US", # United States
}

def get_lat_lon() -> list:
    """
    Calls the open weather geocoding api to get the latitude and longitude of cities and returns a list.

    Returns:
        list: A list of dictionaries containing the country name, its latitude and longitude.
    """
    lat_lon = [] # initializing an empty list so I can store the lat-lon tuples inside it

    # for loop to take the city name and the country code from above, run them through the api to get the lat-lon values
    for city_name in CITY_COUNTRY_CODE:
        
        # using the appropriate API parameters
        url = f'http://api.openweathermap.org/geo/1.0/direct?q={city_name},{CITY_COUNTRY_CODE[city_name]}&limit=1&appid={API_KEY}'

        try: # to make sure we have no errors in the response and to know where it happened!
            response = requests.get(url) # call the API
            # print(response.status_code)
            response.raise_for_status() # raise HTTPError if any happens
            
            data = response.json() # if no error occurs with the API, store the response here
            
            if not len(data): # if there is an issue with the city name or country code (them being unavailable) we will get an empty response
                raise Exception(f"Response data is empty at {city_name}, {CITY_COUNTRY_CODE[city_name]}") # if we get an empty response raise an error

            lat_lon.append({'city_name': city_name, 'latitude': data[0]['lat'], 'longitude' : data[0]['lon']}) # no issue with the response, append the tuple to the list 

        except Exception as e: # here if we have an HTTP error we print it
            print(str(e).split(': https')[0])

    # TODO: improve validation
    if len(lat_lon) == len(CITY_COUNTRY_CODE):
        return lat_lon

    else:
        print('Not all the countries were processed')
        return []

# print(get_lat_lon())
# print("Finished processing")