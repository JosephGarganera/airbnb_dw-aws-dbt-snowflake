select * from {{ ref('silver_bookings') }}
where response_rate_quality = 'fair'
{# select * from {{ source('staging', 'listings') }} #}