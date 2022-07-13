#Determine lab or not-lab based on domain
{% if grains['domain'] == 'qic.tiaa-cref.org' %}
    {% set sat_server = 'rhelfinish::register_satellite6::lab_satellite_server' %}
{% else %}
    {% set sat_server = 'rhelfinish::register_satellite6::satellite_server' %}
{% endif %}

# Set activation key segment defaults
{% set loc_activation_key = namespace(value='1-loc_Unknown') %}
{% set env_activation_key = namespace(value='1-env_Unknown') %}
{% set site_activation_key = namespace(value='1-site_UNKNOWN') %}
{% set tier_activation_key = namespace(value='1-tier_UNKNOWN') %}

# Map tiaa_loc to activation key segment
{% set activation_key = {
    '1-loc_Charlotte': 'cha', 
    '1-loc_Denver': 'den',
    'loc_Amazon_East': 'awe',
    'loc_Amazon_West': 'aww'} %}
# Update default activation key segment with tiaa_loc segment
{% for key_segment, tiaa_grain in activation_key.items() %}
    {% if grains['tiaa_dc'] in tiaa_grain %}
        {% set loc_activation_key.value = key_segment %}
    {% endif %}
{% endfor %}

# Map tiaa_env to activation key segment
{% set activation_key = {
    '1-env_PD': 'pd', 
    '1-env_DR': 'dr', 
    '1-env_PF': 'pf',
    '1-env_CT': 'ct', 
    '1-env_TS': 'ts', 
    '1-env_AT1': ['at', 'at1', 'ab'], 
    '1-env_DV': ['dv', 'd1', 'd2', 'd3', 'd4', 'd5'], 
    '1-env_IT1': ['it', 'i1']}  %}
# Update default activation key segment with tiaa_env segment
{% for key_segment, tiaa_grain in activation_key.items() %}
    {% if grains['tiaa_env'] in tiaa_grain %}
        {% set env_activation_key.value = key_segment %}
    {% endif %}
{% endfor %}

# Map tiaa_site to activation key segment
{% set activation_key = {
    '1-site_A': 'a', 
    '1-site_B': 'b', 
    '1-site_C': 'c',
    '1-site_D': 'd', 
    '1-site_E': 'e'}  %}
# Update default activation key segment with tiaa_env segment
{% for key_segment, tiaa_grain in activation_key.items() %}
    {% if grains['tiaa_site'] in tiaa_grain %}
        {% set site_activation_key.value = key_segment %}
    {% endif %}
{% endfor %}

# Map tiaa_tier to activation key segment
{% set activation_key = {
    '1-tier_1': '1', 
    '1-tier_2': '2', 
    '1-tier_3': '3',
    '1-tier_IS': 'i'}  %}
# Update default activation key segment with tiaa_env segment
{% for key_segment, tiaa_grain in activation_key.items() %}
    {% if grains['tiaa_tier'] in tiaa_grain %}
        {% set tier_activation_key.value = key_segment %}
    {% endif %}
{% endfor %}

{% set activation_keys = [
    loc_activation_key.value,
    env_activation_key.value,
    site_activation_key.value,
    tier_activation_key.value
    ]|join(" ") %}
    
{% set register_cmd = [
    '/usr/sbin/subscription-manager',
    'register',
    '--org=TIAA',
    activation_keys
    ]|join(" ") %}

test_state:
  cmd.run:
    - name: echo {{activation_keys}} > /root/activation_keys.txt

test_state_2:
  cmd.run:
    - name: echo {{register_cmd}} > /root/register_cmd.txt

