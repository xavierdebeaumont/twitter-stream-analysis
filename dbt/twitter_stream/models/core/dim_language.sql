{{ config(materialized='seed') }}

select * from "{{ source('seed', 'lang_names.csv') }}"