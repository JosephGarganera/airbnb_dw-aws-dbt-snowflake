{{ 
  config(
    materialized='incremental',
    unique_key='booking_id'
  ) 
}}

select
  booking_id,
  listing_id,
  booking_date,
  nights_booked,
  booking_amount,
  cleaning_fee,
  service_fee,
  booking_status,
  created_at
from {{ source('staging', 'bookings') }}

{% if is_incremental() %}
  where created_at > (
    select coalesce(max(created_at), to_timestamp('1900-01-01', 'YYYY-MM-DD')) 
    from {{ this }}
  )
{% endif %}
