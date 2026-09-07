{{
  config(
    materialized='table',
    schema='gold'
  )
}}

select
    host_id,
    host_name,
    host_since,
    is_superhost,
    response_rate,
    case 
        when response_rate >= 90 then 'excellent'
        when response_rate >= 70 then 'good'
        else 'needs improvement'
    end as response_rate_quality,
    created_at as host_created_at
from {{ ref('silver_hosts') }}
