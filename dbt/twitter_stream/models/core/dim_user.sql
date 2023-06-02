{{ config(materialized='table') }}

select distinct
    user.id as user_id,
    user.created_at as created_at,
    user.name,
    user.username,
    user.description
from {{ source('staging', 'stg_raw_tweets') }}, unnest([user]) as user
