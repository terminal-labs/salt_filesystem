#Determine lab or not-lab based on domain
{% if grains['domain'] == 'qic.tiaa-cref.org' %}
    {% set sat_server = 'rhelfinish::register_satellite6::lab_satellite_server' %}
{% else %}
    {% set sat_server = 'rhelfinish::register_satellite6::satellite_server' %}
{% endif %}

# Set activation key segment defaults
{% set loc_key_segment = namespace(value='1-loc_Unknown') %}
{% set env_key_segment = namespace(value='1-env_Unknown') %}
{% set site_key_segment = namespace(value='1-site_UNKNOWN') %}
{% set tier_key_segment = namespace(value='1-tier_UNKNOWN') %}

# Map tiaa_loc to activation key segment
{% set dc_activation_segment = {
    '1-loc_Charlotte': 'cha', 
    '1-loc_Denver': 'den',
    'loc_Amazon_East': 'awe',
    'loc_Amazon_West': 'aww'} %}

# Update default activation key segment with tiaa_loc segment
{% for key_segment, tiaa_grain in dc_activation_segment.items() %}
    {% if grains['tiaa_dc'] in tiaa_grain %}
        {% set loc_key_segment.value = key_segment %}
    {% endif %}
{% endfor %}





{% set activation_key = [
    loc_key_segment.value,
    env_key_segment.value,
    site_key_segment.value,
    tier_key_segment.value
    ]|join(",") %}
    
test_state:
  cmd.run:
    - name: echo {{activation_key}} > /root/activation_key.txt

