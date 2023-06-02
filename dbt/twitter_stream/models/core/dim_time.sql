{{ config(materialized='table') }}

select
    timestamp,
    extract(year from timestamp) as year,
    extract(month from timestamp) as month,
    extract(day from timestamp) as day,
    extract(hour from timestamp) as hour
from (
    select distinct
        timestamp_trunc(created_at, hour) as timestamp
    from {{ ref('stg_raw_tweets') }}
)
