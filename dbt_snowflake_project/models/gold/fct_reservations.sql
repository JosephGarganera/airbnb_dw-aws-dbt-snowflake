{{
  config(
    materialized='table',
    schema='gold'
  )
}}

select
    -- Foreign Keys linking out to your Dimensions
    b.booking_id,
    b.listing_id,
    l.host_id,
    
    -- Transaction Date and Core Status
    b.booking_date,
    b.booking_status,
    
    -- Clean Numeric Measures
    coalesce(cast(b.total_amount as number(38,2)), 0) as total_amount,
    coalesce(cast(l.price_per_night as number(38,2)), 0) as price_per_night,
    
    -- System Metadata Timestamp
    current_timestamp() as loaded_at_timestamp
from {{ ref('silver_bookings') }} b
left join {{ ref('silver_listings') }} l 
    on b.listing_id = l.listing_id
