{% if grains['domain'] == 'qic.tiaa-cref.org' %}
    {% set sat_server = 'rhelfinish::register_satellite6::lab_satellite_server' %}
{% else %}
    {% set sat_server = 'rhelfinish::register_satellite6::satellite_server' %}
{% endif %}


{% set activation_key = {
    'loc': '1-loc_Unknown', 
    'env': '1-env_Unknown',
    'site': '1-site_UNKNOWN',
    'tier': '1-tier_UNKNOWN'} %}

{% set dc_activation_segment = {
    'cha': '1-loc_Charlotte', 
    'den': '1-loc_Denver',
    'awe': 'loc_Amazon_East',
    'aww': 'loc_Amazon_West'} %}

{% for tiaa_grain, key_segment in dc_activation_segment.items() %}
    {% if tiaa_grain == grains['tiaa_dc'] %}
        {% set activation_key['loc'] = key_segment %}
    {% endif %}
{% endfor %}

{% set activation_key = activation_key.values()|join(",") %}

test_state:
  cmd.run:
    - name: echo {{activation_key}} > /root/activation_key.txt

