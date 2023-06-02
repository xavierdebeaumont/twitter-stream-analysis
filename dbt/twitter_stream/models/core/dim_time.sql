{{ config(materialized='table') }}

select
    timestamp_trunc(created_at, hour) as truncated_timestamp,
    created_at as timestamp,
    extract(year from created_at) as year,
    extract(month from created_at) as month,
    extract(day from created_at) as day,
    extract(hour from created_at) as hour
from (
    select distinct created_at
    from {{ ref('stg_raw_tweets') }}
)
