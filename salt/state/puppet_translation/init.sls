{% if grains['domain'] == 'qic.tiaa-cref.org' %}
    {% set sat_server = 'rhelfinish::register_satellite6::lab_satellite_server' %}
{% else %}
    {% set sat_server = 'rhelfinish::register_satellite6::satellite_server' %}
{% endif %}


{% set activation_key = [
    '1-loc_Unknown', 
    '1-env_Unknown',
    '1-site_UNKNOWN',
    '1-tier_UNKNOWN'] %}

{# {% if grains['tiaa_dc'] == 'cha' %}
    {% set activation_key == (activation_key + '1-loc_Charlotte') %}
{% elif grains['tiaa_dc'] == 'den' %}
    {% set activation_key == (activation_key + '1-loc_Denver') %}
{% elif grains['tiaa_dc'] == 'den' %}
    {% set activation_key == (activation_key + 'loc_Amazon_East') %}
{% elif grains['tiaa_dc'] == 'den' %}
    {% set activation_key == (activation_key + 'loc_Amazon_West') %}
{% else %}
    {% set activation_key == (activation_key + '1-loc_Unknown') %} #}

{% for tiaa_grain, key_segment in [
    ('cha', '1-loc_Charlotte'),
    ('den', '1-loc_Denver'),
    ('awe', 'loc_Amazon_East'),
    ('aww', 'loc_Amazon_West')] %}

{% if tiaa_grain == grains['tiaa_dc'] %}
    {% set activation_key = key_segment %}

{% endif %}
{% endfor %}

test_state:
  cmd.run:
    - name: echo {{activation_key}} > /root/activation_key.txt

