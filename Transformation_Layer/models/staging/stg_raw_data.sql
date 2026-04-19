{{ config(materialized='view') }}

with source_data as (
    select * from {{ source('raw_data', 'weather_raw_partitioned') }}
)

select
    -- Identifiers
    STATION as station_id,
    NAME as station_name,
    DATE as record_date,

    -- Temperature Metrics 
    TEMP as avg_temp_fahrenheit,
    MAX as max_temp_fahrenheit,
    MIN as min_temp_fahrenheit,
    -- Precipitation
    PRCP as precipitation_inches

from source_data