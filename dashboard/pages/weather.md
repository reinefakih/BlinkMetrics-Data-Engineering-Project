---
title: Weather
sidebar_position: 2
---

<Details title='About the Weather'>

  This page shows you some information about the weather forecast in general.

</Details>

<hr>

<Details title='Queries'>

```sql weather
    SELECT 
        *
    FROM weather_warehouse.fact AS f
    INNER JOIN weather_warehouse.dim_weather AS w
        ON f.weather_id = w.weather_id
    INNER JOIN weather_warehouse.dim_cities AS c
        ON f.city_id = c.city_id
    WHERE c.city like '${inputs.city_name_search}';
```
```sql donut_query
    SELECT w.weather AS weather_description,
            COUNT(w.weather) AS weather_count,
            c.city AS city
    FROM weather_warehouse.dim_weather AS w
    INNER JOIN weather_warehouse.fact AS f
        ON f.weather_id = w.weather_id
    INNER JOIN weather_warehouse.dim_cities AS c
        ON f.city_id = c.city_id
    WHERE c.city like '${inputs.city_name_search}'
    GROUP BY c.city, w.weather
```
```sql donut_data
select weather_description as name, weather_count as value
from ${donut_query}
```

</Details>

<TextInput
    name=city_name_search
    title="City Search"
    defaultValue="Paris"
/>

## General Weather Over the Week:
<hr>

<ECharts config={
    {
        tooltip: {
            formatter: '{b}: {c} ({d}%)'
        },
      series: [
        {
          type: 'pie',
          radius: ['40%', '70%'],
          data: [...donut_data],
        }
      ]
      }
    }
/>

<br>

## Temperature:
<hr>
<br>
<Grid cols=2>
    <Group>

        ### Over the Day:

        <Tabs>
            <Tab label="Morning Temperature">
                <LineChart data={weather} x=date y=temp_morn yAxisTitle="Temperature Over the Days">
                    <ReferenceLine y=9000 label="Target"/>
                </LineChart>
            </Tab>
            <Tab label="Day Temperature">
                <LineChart data={weather} x=date y=temp_day yAxisTitle="Temperature Over the Days">
                    <ReferenceLine y=9000 label="Target"/>
                </LineChart>
            </Tab>
            <Tab label="Evening Temperature">
                <LineChart data={weather} x=date y=temp_eve yAxisTitle="Temperature Over the Days">
                    <ReferenceLine y=9000 label="Target"/>
                </LineChart>
            </Tab>
            <Tab label="Night Temperature">
                <LineChart data={weather} x=date y=temp_night yAxisTitle="Temperature Over the Days">
                    <ReferenceLine y=9000 label="Target"/>
                </LineChart>
            </Tab>
        </Tabs>
    </Group>
    
    <Group>

        ### Min and Max:

        <Tabs>
            <Tab label="Min Temperature">
                <LineChart data={weather} x=date y=temp_min yAxisTitle="Min Temperature Over the Days">
                    <ReferenceLine y=9000 label="Target"/>
                </LineChart>
            </Tab>
            <Tab label="Max Temperature">
                <LineChart data={weather} x=date y=temp_max yAxisTitle="Max Temperature Over the Days">
                    <ReferenceLine y=9000 label="Target"/>
                </LineChart>
            </Tab>
        </Tabs>

    </Group>
</Grid>

<br>

## Feels like:
<hr>

<Tabs>
    <Tab label="Morning Temperature">
        <LineChart data={weather} x=date y=feels_like_morn yAxisTitle="Temperature Over the Days">
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
    <Tab label="Day Temperature">
        <LineChart data={weather} x=date y=feels_like_day yAxisTitle="Temperature Over the Days">
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
    <Tab label="Evening Temperature">
        <LineChart data={weather} x=date y=feels_like_eve yAxisTitle="Temperature Over the Days">
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
    <Tab label="Night Temperature">
        <LineChart data={weather} x=date y=feels_like_night yAxisTitle="Temperature Over the Days">
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
</Tabs>

<br>

## Wind:
<hr>

<Tabs>
    <Tab label="Wind Speed">
        <LineChart data={weather} x=date y=wind_speed>
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
    <Tab label="Wind Gust">
        <LineChart data={weather} x=date y=wind_gust>
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
</Tabs>

<br>

## Other Factors:
<hr>

<Tabs>
    <Tab label="Humidity">
        <LineChart data={weather} x=date y=humidity yAxisTitle="Humidity Over the Days">
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
    <Tab label="Dew Point">
        <LineChart data={weather} x=date y=dew_point yAxisTitle="Dew Point Over the Days">
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
    <Tab label="Clouds">
        <LineChart data={weather} x=date y=clouds yAxisTitle="Cloud Coverage Over the Days">
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
    <Tab label="UV Index">
        <LineChart data={weather} x=date y=uvi yAxisTitle="UV Index Over the Days">
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
    <Tab label="Precipitation">
        <LineChart data={weather} x=date y=precep_prob yAxisTitle="Precipitation Probability Over the Days">
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
    <Tab label="Rain">
        <LineChart data={weather} x=date y=rain yAxisTitle="Rainfall Over the Days">
            <ReferenceLine y=9000 label="Target"/>
        </LineChart>
    </Tab>
</Tabs>

<br>
<hr>

## Weather Details:
<Modal title='Weather Data Drill Through' buttonText='Click to See Weather Table'>
    <DataTable data={weather}>
        <Column id=date />
        <Column id=summary />
        <Column id=temp_morn/>
        <Column id=temp_day/>
        <Column id=temp_eve/>
        <Column id=temp_night/>
        <Column id=feels_like_morn/>
        <Column id=feels_like_day/>
        <Column id=feels_like_eve/>
        <Column id=feels_like_night/>
        <Column id=pressure/>
        <Column id=humidity/>
        <Column id=dew_point/>
        <Column id=wind_speed/>
        <Column id=wind_gust/>
        <Column id=clouds/>
        <Column id=uvi/>
        <Column id=precep_prob/>
        <Column id=rain/>
        <Column id=wind_speed/>
        <Column id=weather/>
        <Column id=description/>
    </DataTable>
</Modal>