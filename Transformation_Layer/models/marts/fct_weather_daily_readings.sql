{{ config(
    materialized='table',
    partition_by={
      "field": "record_date",
      "data_type": "date",
      "granularity": "day"
    }
) }}

select
    weather_pk,          -- Surrogate Key from Intermediate model
    station_id,          -- Join Key to Dim Station
    record_date,
    record_month,
    record_year,
    avg_temp_fahrenheit,
    max_temp_fahrenheit,
    min_temp_fahrenheit,
    precipitation_inches,
    is_heatwave,
    is_freeze,
    is_heavy_rain
from {{ ref('int_weather_daily_metrics_data') }}