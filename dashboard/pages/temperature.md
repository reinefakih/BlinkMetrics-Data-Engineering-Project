---
title: Temperature Analysis
sidebar_position: 3
---

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
  ```sql avg_temp_by_city
      SELECT 
          AVG(f.temp_max) AS avg_temp,
          c.city AS city
      FROM weather_warehouse.fact AS f
      INNER JOIN dim_cities AS c
        ON f.city_id = c.city_id
      GROUP BY c.city;
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
  ```sql avg_feelslike
    SELECT AVG(feels_like_day) as feels_like_average
    FROM weather_warehouse.fact
  ```
  ```sql weather
      SELECT 
          *
      FROM weather_warehouse.fact AS f
      INNER JOIN weather_warehouse.dim_weather AS w
          ON f.weather_id = w.weather_id
      INNER JOIN weather_warehouse.dim_cities AS c
          ON f.city_id = c.city_id;
  ```
  ```sql temps
    SELECT 
      AVG(temp_morn) AS temp_morn,
      AVG(temp_day) AS temp_day,
      AVG(temp_eve) AS temp_eve,
      AVG(temp_night) AS temp_night,
      AVG(feels_like_morn) AS feels_like_morn,
      AVG(feels_like_day) AS feels_like_day,
      AVG(feels_like_eve) AS feels_like_eve,
      AVG(feels_like_night) AS feels_like_night,
      "date"
    FROM weather_warehouse.fact
    WHERE "date" BETWEEN '${inputs.date_filtering.start}' and '${inputs.date_filtering.end}'
    GROUP BY "date"
  ```

</Details>

<!-- <DateRange
    name=date_filtering
    data={temps}
    presetRanges={['Last 7 Days', 'All Time']}
/> -->
<hr>

<BigValue
  data={max_min_avg_temp} 
  value=avg_temp
  title="Avg Temperature (&deg;C)"
/> 

<BigValue 
  data={max_min_avg_temp} 
  value=max_temp
  title="Max Temperature (&deg;C)"
/> 

<BigValue 
  data={max_min_avg_temp} 
  value=min_temp
  title="Min Temperature (&deg;C)"
/>

<BigValue 
  data={avg_feelslike} 
  value=feels_like_average
  title="Feels Like Average (&deg;C)"
/>
<hr>

## General Temperature:

<Tabs>
    <Tab label="Average Temperature by City">
        <BarChart 
            data={avg_temp_by_city}
            x=city
            y=avg_temp
            title="Avg Temperature (&deg;C) by City"
        />
    </Tab>

    <Tab label="Average Temperature by Country">
        <BarChart 
          data={countries}
          x=country
          y=temp
          title="Avg Temperature (&deg;C) by Country"
        />
    </Tab>
</Tabs>

<br>

## Temperature Through the Day:

<LineChart 
    data={temps}
    x=date
    y={['temp_morn','temp_day', 'temp_eve', 'temp_night']}
/> 

<br>

## Real Temperature vs Feels Like:

<Tabs>
    <Tab label="Morning Temperature">
      <LineChart 
          data={temps}
          x=date
          y={['temp_morn','feels_like_morn']}
      />  
    </Tab>

    <Tab label="Day Temperature">
      <LineChart 
          data={temps}
          x=date
          y={['temp_day','feels_like_day']} 
      />  
    </Tab>

    <Tab label="Evening Temperature">
      <LineChart 
          data={temps}
          x=date
          y={['temp_eve','feels_like_eve']} 
      />  
    </Tab>

    <Tab label="Night Temperature">
      <LineChart 
          data={temps}
          x=date
          y={['temp_night','feels_like_night']} 
      />  
    </Tab>
</Tabs>

<br>
<hr>

To see the temperature analysis per city, you can go to:
<LinkButton url='/temp_city'>
  By City
</LinkButton>