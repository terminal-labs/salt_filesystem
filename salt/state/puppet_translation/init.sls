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

# Map tiaa_env to activation key segment
{% set dc_activation_segment = {
    '1-env_PD': 'pd', 
    '1-env_DR': 'dr', 
    '1-env_PF': 'pf',
    '1-env_CT': 'ct', 
    '1-env_TS': 'ts', 
    '1-env_AT1': ['at', 'at1', 'ab'], 
    '1-env_DV': ['dv', 'd1', 'd2', 'd3', 'd4', 'd5'], 
    '1-env_IT1': ['it', 'i1']}  %}
# Update default activation key segment with tiaa_env segment
{% for key_segment, tiaa_grain in dc_activation_segment.items() %}
    {% if grains['tiaa_env'] in tiaa_grain %}
        {% set env_key_segment.value = key_segment %}
    {% endif %}
{% endfor %}

# Map tiaa_site to activation key segment
{% set dc_activation_segment = {
    '1-site_A': 'a', 
    '1-site_B': 'b', 
    '1-site_C': 'c',
    '1-site_D': 'd', 
    '1-site_E': 'e'}  %}
# Update default activation key segment with tiaa_env segment
{% for key_segment, tiaa_grain in dc_activation_segment.items() %}
    {% if grains['tiaa_site'] in tiaa_grain %}
        {% set site_key_segment.value = key_segment %}
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

