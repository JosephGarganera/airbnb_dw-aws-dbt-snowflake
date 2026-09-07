{{ 
  config(
    materialized='incremental',
    unique_key='listing_id'
  ) 
}}

select
  listing_id,
  host_id,
  property_type,
  room_type,
  city,
  country,
  accommodates,
  bedrooms,
  bathrooms,
  price_per_night,
  created_at
from {{ source('staging', 'listings') }}

{% if is_incremental() %}
  where created_at > (
    select coalesce(max(created_at), to_timestamp('1900-01-01', 'YYYY-MM-DD')) 
    from {{ this }}
  )
{% endif %}
