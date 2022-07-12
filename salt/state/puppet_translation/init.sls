{% if grains['domain'] == 'qic.tiaa-cref.org' %}
    {% set sat_server = 'rhelfinish::register_satellite6::lab_satellite_server' %}
{% else %}
    {% set sat_server = 'rhelfinish::register_satellite6::satellite_server' %}
{% endif %}


{% set loc_key_segment = '1-loc_Unknown' %}
{% set env_key_segment = '1-env_Unknown' %}
{% set site_key_segment = '1-site_UNKNOWN' %}
{% set tier_key_segment = '1-tier_UNKNOWN' %}


{% set dc_activation_segment = {
    'cha': '1-loc_Charlotte', 
    'den': '1-loc_Denver',
    'awe': 'loc_Amazon_East',
    'aww': 'loc_Amazon_West'} %}

{% for tiaa_grain, key_segment in dc_activation_segment.items() %}
    {% if tiaa_grain == grains['tiaa_dc'] %}
        {% set loc_key_segment = key_segment %}
    {% endif %}
{% endfor %}

{% set activation_key = [
    loc_key_segment,
    env_key_segment,
    site_key_segment,
    tier_key_segment
    ]|join(",") %}
    
test_state:
  cmd.run:
    - name: echo {{activation_key}} > /root/activation_key.txt

