{{ config(materialized='table') }}

select distinct
    user.id as user_id,
    user.created_at as user_created_at,
    user.description,
    user.name,
    user.username
from {{ ref('stg_raw_tweets') }}, UNNEST([user]) as user