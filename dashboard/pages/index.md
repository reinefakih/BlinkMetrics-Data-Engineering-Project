---
title: WeatherCast - Overview
sidebar_position: 1
---

<Details title='About the Dashboard'>

  This dashboard aims to show some insights into the weather data extracted from the [OpenWeather One Call API](https://openweathermap.org/api/one-call-3)

</Details>

## General Information:
<Details title='Queries'>

  ```sql countries
    SELECT 
      distinct(c.country) AS country,
      AVG(f.temp_max) AS temp
    FROM weather_warehouse.dim_cities AS c
    INNER JOIN weather_warehouse.fact AS f
    ON c.city_id = f.city_id
    GROUP BY c.country;
  ```
  ```sql number_of_distinct_cities
    SELECT 
        COUNT(DISTINCT(city)) AS city_count,
        COUNT(distinct(country)) AS country_count
    FROM weather_warehouse.dim_cities
  ```
  ```sql max_min_avg_temp
    SELECT 
        MAX(temp_max) AS max_temp,
        MIN(temp_min) AS min_temp,
        AVG(temp_max) AS avg_temp
    FROM weather_warehouse.fact
  ```
  ```sql max_min_avg_humidity
    SELECT 
        MAX(humidity) AS max_hum,
        MIN(humidity) AS min_hum,
        AVG(humidity)::INT AS avg_hum
    FROM weather_warehouse.fact
  ```

</Details>

<AreaMap 
    data={countries} 
    areaCol=country
    geoJsonUrl=https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_110m_admin_0_countries.geojson
    geoId=iso_a2
    value=temp
/>
<br>

- We have <Value data={number_of_distinct_cities} column=city_count/> distinct cities distributed over  <Value data={number_of_distinct_cities} column=country_count/> coutries.
- The highest temperature in our data is <Value data={max_min_avg_temp} column=max_temp/> (&deg;C), the lowest is <Value data={max_min_avg_temp} column=min_temp/> (&deg;C), and the average temperature is <Value data={max_min_avg_temp} column=avg_temp/> (&deg;C).
- The highest humidity % in our data is <Value data={max_min_avg_humidity} column=max_hum/>%, the lowest is <Value data={max_min_avg_humidity} column=min_hum/>%, and the average is <Value data={max_min_avg_humidity} column=avg_hum/>%.

## General Look:
<Details title='Queries'>

  ```sql avg_temp_by_city
      SELECT 
          AVG(f.temp_max) AS avg_temp,
          c.city AS city
      FROM weather_warehouse.fact AS f
      INNER JOIN dim_cities AS c
        ON f.city_id = c.city_id
      GROUP BY c.city;
  ```
  ```sql avg_hum_by_city
      SELECT 
          AVG(f.humidity) AS avg_hum,
          c.city AS city
      FROM weather_warehouse.fact AS f
      INNER JOIN dim_cities AS c
        ON f.city_id = c.city_id
      GROUP BY c.city;
  ```
  ```sql avg_rain_by_city
      SELECT 
          AVG(f.rain) AS avg_rain,
          c.city AS city
      FROM weather_warehouse.fact AS f
      INNER JOIN dim_cities AS c
        ON f.city_id = c.city_id
      GROUP BY c.city;
  ```

</Details>
<Tabs>
    <Tab label="Average Temperature">
        <BarChart 
            data={avg_temp_by_city}
            x=city
            y=avg_temp
            title="Avg Temperature (&deg;C) by City"
        />
    </Tab>
    <Tab label="Average Humidity">
        <BarChart 
            data={avg_hum_by_city}
            x=city
            y=avg_hum
            title="Avg Humidity % by City"
        />
    </Tab>
    <Tab label="Average Rain">
        <BarChart 
            data={avg_rain_by_city}
            x=city
            y=avg_rain
            title="Avg Rain (mm/h) by City"
        />
    </Tab>
</Tabs>