{{ config(materialized='table') }}

with stations as (
    select distinct
        station_id,
        station_name
    from {{ ref('stg_raw_data') }}
)

select
    station_id,
    station_name,
    -- Mapping pecific airports to their US Climate Regions
    case 
        when station_name like '%HOUSTON%' then 'Gulf Coast'
        when station_name like '%CHICAGO%' then 'Midwest'
        when station_name like '%LAGUARDIA%' then 'Northeast'
        when station_name like '%LOS ANGELES%' then 'West Coast'
        when station_name like '%MIAMI%' then 'Southeast'
        else 'Other'
    end as climate_region,

    -- Adding State names to add more description
    case 
        when station_name like '%HOUSTON%' then 'Texas'
        when station_name like '%CHICAGO%' then 'Illinois'
        when station_name like '%LAGUARDIA%' then 'New York'
        when station_name like '%LOS ANGELES%' then 'California'
        when station_name like '%MIAMI%' then 'Florida'
        else 'Unknown'
    end as state_name

from stations