---
title: Temperature Analysis - City Wise
sidebar: hide
sidebar_link: False
---

<Details title='Queries'>

  ```sql max_min_avg_temp
    SELECT 
        MAX(temp_max) AS max_temp,
        MIN(temp_min) AS min_temp,
        AVG(temp_max) AS avg_temp
    FROM weather_warehouse.fact as f
    INNER JOIN weather_warehouse.dim_cities AS c
    ON f.city_id = c.city_id;
    WHERE c.city like '${inputs.city_name_search}'
  ```
  ```sql avg_feelslike
    SELECT AVG(feels_like_day) as feels_like_average
    FROM weather_warehouse.fact as f
    INNER JOIN weather_warehouse.dim_cities AS c
    ON f.city_id = c.city_id;
    WHERE c.city like '${inputs.city_name_search}'
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
    FROM weather_warehouse.fact as f
    INNER JOIN weather_warehouse.dim_cities AS c
    ON f.city_id = c.city_id;
    WHERE c.city like '${inputs.city_name_search}'
    GROUP BY "date"
  ```

</Details>

<TextInput
    name=city_name_search
    title="City Search"
    defaultValue="Paris"
/>

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

<LinkButton url='/temperature'>
  Go Back
</LinkButton>