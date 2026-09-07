{{
  config(
    materialized='table',
    schema='gold'
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
    case 
        when price_per_night >= 150 then 'premium'
        when price_per_night >= 75 then 'fair'
        else 'budget'
    end as price_per_night_tag,
    created_at as listing_created_at
from {{ ref('silver_listings') }}
