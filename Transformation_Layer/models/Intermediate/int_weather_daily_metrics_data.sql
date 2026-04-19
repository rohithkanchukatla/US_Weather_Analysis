{{ config(materialized='view') }}

with staging as (
    select * from {{ ref('stg_raw_data') }}
)

select
    --surrogate key to uniquely identify each row
    to_hex(md5(concat(cast(station_id as string), '-', cast(record_date as string)))) as weather_pk,

    -- Natural Keys & Dimensions
    station_id,
    station_name,
    record_date,
    extract(month from record_date) as record_month,
    extract(year from record_date) as record_year,

    -- Metrics 
    avg_temp_fahrenheit,
    max_temp_fahrenheit,
    min_temp_fahrenheit,
    precipitation_inches,

   -- Extreme Event Flags 
    -- Heatwave: Max Temp > 95°F
    case when max_temp_fahrenheit > 95 then 1 else 0 end as is_heatwave,
    
    -- Freeze: Min Temp < 32°F
    case when min_temp_fahrenheit < 32 then 1 else 0 end as is_freeze,
    
    -- Heavy Rain: > 1 inch of rain in a single day
    case when precipitation_inches > 1.0 then 1 else 0 end as is_heavy_rain

from staging