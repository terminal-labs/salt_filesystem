# Determine lab or not-lab based on domain
{% if grains['domain'] == 'qic.tiaa-cref.org' %}
    {% set sat_server = 'rhelfinish::register_satellite6::lab_satellite_server' %}
{% else %}
    {% set sat_server = 'rhelfinish::register_satellite6::satellite_server' %}
{% endif %}

# Generate activation keys by calling custom module
{% set activation_keys = salt['tiaa_key.generate_activation_keys']() %}

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

