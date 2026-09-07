{{
  config(
    materialized = 'table',
    schema = 'gold'
  )
}}

{# Establish the central Metadata Registry mapping out our star schema elements #}
{% set configs = [
  {
    'model_name': 'fct_reservations',
    'alias': 'f',
    'columns': ['booking_id', 'listing_id', 'host_id', 'booking_date', 'booking_status', 'total_amount', 'price_per_night']
  },
  {
    'model_name': 'dim_bookings',
    'alias': 'b',
    'join_condition': 'f.booking_id = b.booking_id',
    'columns': ['booking_created_at']
  },
  {
    'model_name': 'dim_listings',
    'alias': 'l',
    'join_condition': 'f.listing_id = l.listing_id',
    'columns': ['property_type', 'room_type', 'city', 'country', 'accommodates', 'bedrooms', 'bathrooms', 'price_per_night_tag', 'listing_created_at']
  },
  {
    'model_name': 'dim_hosts',
    'alias': 'h',
    'join_condition': 'f.host_id = h.host_id',
    'columns': ['host_name', 'host_since', 'is_superhost', 'response_rate', 'response_rate_quality', 'host_created_at']
  }
] %}

SELECT
  {# Dynamic Column Injection Engine #}
  {% for config in configs -%}
    {% set outer_loop = loop -%}
    {% for col in config.columns -%}
      {{ config.alias }}.{{ col }} AS {{ config.model_name ~ '_' ~ col if outer_loop.index0 > 0 else col }}{%- if not (outer_loop.last and loop.last) %}, {% endif %}
    {% endfor %}
  {% endfor %}
FROM 
  {# Base Table Anchor resolving from index 0 #}
  {{ ref(configs[0].model_name) }} AS {{ configs[0].alias }}

  {# Structural Join Loop Engine #}
  {% for config in configs[1:] -%}
    LEFT JOIN {{ ref(config.model_name) }} AS {{ config.alias }}
      ON {{ config.join_condition }}
  {% endfor %}
