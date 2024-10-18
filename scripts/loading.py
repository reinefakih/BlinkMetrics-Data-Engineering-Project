# -- import statements -- #
import pandas as pd
import sqlalchemy as sa
import os
from dotenv import load_dotenv, find_dotenv
from transformations import transform_data

# getting the local variables that we will need

load_dotenv(find_dotenv(), override=True)

PASSWORD = os.getenv('DB_PASS')

# -- SQLAlchemy Connection -- #

# SQLAlchemy connection to link MySQL:
connection_url = f"mysql+pymysql://root:{PASSWORD}@localhost:3306/blinkmetrics_project_warehouse"
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

def load_into_dim_cities(df: pd.DataFrame):
    """
    function that loads transformed data into dim_cities

    Args:
        df (pd.DataFrame): pandas dataframe of transformed data
    """
    try:
        if df is not None and isinstance(df, pd.DataFrame):
            try:
                df.to_sql('dim_cities', con=db_engine, if_exists='append', index=False)
            
            except Exception as e:
                print(f"{e}")
 
        else:
            raise ValueError(f"Did not recieve a dataframe to Load") 
        
    except Exception as e:
        print(f"Error: {e}")


# load_into_dim_cities(transform_data()[1])

def load_into_dim_weather(df: pd.DataFrame):
    """
    function that loads transformed data into dim_weather

    Args:
        df (pd.DataFrame): pandas dataframe of transformed data
    """
    try:
        if df is not None and isinstance(df, pd.DataFrame):
            try:
                df.to_sql('dim_weather', con=db_engine, if_exists='append', index=False)
            
            except Exception as e:
                print(f"{e}")
 
        else:
            raise ValueError(f"Did not recieve a dataframe to Load") 
        
    except Exception as e:
        print(f"Error: {e}")

# load_into_dim_weather(transform_data()[2])

def load_into_fact_weather_details(df: pd.DataFrame):
    """
    function that loads transformed data into fact_weather_details

    Args:
        df (pd.DataFrame): pandas dataframe of transformed data
    """
    try:
        if df is not None and isinstance(df, pd.DataFrame):
            try:
                df.to_sql('fact_weather_details', con=db_engine, if_exists='append', index=False)
            
            except Exception as e:
                print(f"{e}")
 
        else:
            raise ValueError(f"Did not recieve a dataframe to Load") 
        
    except Exception as e:
        print(f"Error: {e}")

# load_into_fact_weather_details(transform_data()[0])