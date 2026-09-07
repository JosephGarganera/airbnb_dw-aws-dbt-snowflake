{{ 
  config(
    materialized='incremental',
    unique_key='host_id'
  ) 
}}

select
  host_id,
  host_name,
  host_since,
  is_superhost,
  response_rate,
  created_at
from {{ source('staging', 'hosts') }}

{% if is_incremental() %}
  where created_at > (
    select coalesce(max(created_at), to_timestamp('1900-01-01', 'YYYY-MM-DD')) 
    from {{ this }}
  )
{% endif %}
