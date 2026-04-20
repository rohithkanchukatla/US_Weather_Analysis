{{ config(materialized='view') }}

SELECT
    f.*,
    d.climate_region,
    d.state_name
FROM {{ ref('fct_weather_daily_readings') }} f
JOIN {{ ref('dim_stations') }} d
ON f.station_id = d.station_id