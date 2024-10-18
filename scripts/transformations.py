# -- import statements -- #

import pandas as pd
import sqlalchemy as sa
import os
from dotenv import load_dotenv, find_dotenv
import requests

# getting the local variables that we will need

load_dotenv(find_dotenv(), override=True)

PASSWORD = os.getenv('DB_PASS')
API_KEY = os.getenv('BLINKMETRICS_OPENWEATHER_API_KEY')

# -- SQLAlchemy Connection -- #

# SQLAlchemy connection to link MySQL:
connection_url = f"mysql+pymysql://root:{PASSWORD}@localhost:3306/blinkmetrics_project_stage"
db_engine = sa.create_engine(connection_url)

# function to test the SQLAlchemy Connection:
def test_connection() -> bool:
    """
    function to test connection with SQLALchemy

    Returns:
        bool: True if connection is successful, false otherwise
    """
    try:
        with db_engine.connect() as connection:
            print("Connection to MySQL database successful!")
            return True
            
    except Exception as e:
        print(f"Error: {e}")
        return False

# -- Main Code -- #

# function to get city name from latitude and longitude using openweather api
def get_city_name(lat: str, lon: str) -> dict:
    """
    function to get city name from latitude and longitude using openweather reverse geocoding API
    
    Args: 
        lat(str): city latitude
        lon (str): city longitude
    
    Returns:
        dict: dictionary containing city name and the corresponding country code
    """
    # parameters and url:
    limit = 1
    url = f"http://api.openweathermap.org/geo/1.0/reverse?lat={lat}&lon={lon}&limit={limit}&appid={API_KEY}"
    
    try:
        response = requests.get(url)
        return {'name': response.json()[0]['name'], 'country': response.json()[0]['country']}
    
    except Exception as e:
        print(f"{e}")
        return {}

# function to transform the data:
def transform_data() -> list:
    """
    function that transforms the data taken from the Openweather API into the desired warehouse schema

    Returns:
        list: a list containing the transformed tables.
    """
    # getting the data from the df:
    df = pd.read_sql("SELECT * FROM onecall", db_engine)

    # getting city name and the country code
    df['city'] = df.apply(lambda row: get_city_name(row['lat'], row['lon'])['name'], axis=1)
    df['country'] = df.apply(lambda row: get_city_name(row['lat'], row['lon'])['country'], axis=1)
    
    # ----------------------------------------------------------------- #
    # making dim_cities:
    dim_cities = df[['city', 'country']] # getting the newly added city column and the country column from the df to make a new df from them
    dim_cities = dim_cities.drop_duplicates() # dropping any duplicated rows

    dim_cities['city_id'] = range(1, len(dim_cities)  + 1) # adding an id column

    dim_cities = dim_cities[['city_id', 'city', 'country']] # organizing the columns

    # ---------------------------------------------------------------- #

    # keeping the data we want:
    new_df = df[['city', 'country', 'daily', '_airbyte_extracted_at']]

    new_df['daily'] = new_df['daily'].apply(lambda row: eval(row)) # turning the rows of the daily column from strings to list

    exp_df = new_df.explode('daily', ignore_index=True)

    daily_exp = exp_df['daily'].apply(pd.Series) # making a df that contains all the keys that were turned into a column
    exp_df = pd.concat([exp_df.drop(columns=['daily']), daily_exp], axis=1) # combining the main df with the newly created one while also droping the daily column

    temp_exp = exp_df['temp'].apply(pd.Series)
    temp_exp = temp_exp.add_prefix('temp_')
    exp_df = pd.concat([exp_df.drop(columns=['temp']), temp_exp], axis=1)
    
    exp_df['weather'] = exp_df['weather'].apply(lambda row: row[0])
    weather_exp = exp_df['weather'].apply(pd.Series)
    exp_df = pd.concat([exp_df.drop(columns=['weather']), weather_exp], axis=1)

    feell_exp = exp_df['feels_like'].apply(pd.Series)
    feell_exp = feell_exp.add_prefix('feels_like_')
    exp_df = pd.concat([exp_df.drop(columns=['feels_like']), feell_exp], axis=1)

    # transforming the dt column from UNIX to regular datetime format:
    exp_df['dt'] = pd.to_datetime(exp_df['dt'], unit='s')

    cleaned_df = exp_df[['dt', 'city', 'summary', 'temp_morn', 'temp_day', 'temp_eve', 'temp_night', 'temp_min', 'temp_max', 'feels_like_morn', 'feels_like_day', 'feels_like_eve', 'feels_like_night', 'pressure', 'humidity', 'dew_point', 'wind_speed', 'wind_gust', 'clouds', 'uvi', 'pop', 'rain', 'id', '_airbyte_extracted_at']]
    cleaned_df = cleaned_df.rename(columns={'dt': 'date', 'pop': 'precep_prob', 'id': 'weather_id', '_airbyte_extracted_at': 'extracted_at'})
    cleaned_df['id'] = range(1, len(cleaned_df) + 1)

    cleaned_df['date'] = cleaned_df['date'].dt.strftime('%Y-%m-%d')
    cleaned_df['extracted_at'] = cleaned_df['extracted_at'].dt.strftime('%Y-%m-%d')

    cleaned_df['date'] = pd.to_datetime(cleaned_df['date'])
    cleaned_df['extracted_at'] = pd.to_datetime(cleaned_df['extracted_at'])

    # ---------------------------------------------------------------- #
    # making dim weather:
    
    dim_weather = weather_exp[['id', 'main', 'description']].drop_duplicates()
    dim_weather = dim_weather.rename(columns={'id': 'weather_id', 'main': 'weather'})
    dim_weather = dim_weather.sort_values('weather_id', ascending=True)

    # ---------------------------------------------------------------- #
    
    final_fact = cleaned_df.merge(dim_cities, on='city', how='inner')
    final_fact = final_fact.drop(columns=['city', 'country'], axis=0) 
    final_fact = final_fact[['id', 'date', 'city_id', 'summary', 'temp_morn', 'temp_day', 'temp_eve',
        'temp_night', 'temp_min', 'temp_max', 'feels_like_morn',
        'feels_like_day', 'feels_like_eve', 'feels_like_night', 'pressure','humidity', 'dew_point', 'wind_speed', 'wind_gust', 'clouds', 'uvi',
        'precep_prob', 'rain', 'weather_id', 'extracted_at']]
    
    return [final_fact, dim_cities, dim_weather]

# if test_connection():
#     print(transform_data())

# to get csv files:
# trans = transform_data()
# trans[0].to_csv('csv files/fact.csv', index=False)
# trans[1].to_csv('csv files/cities.csv', index=False)
# trans[2].to_csv('csv files/weather.csv', index=False)