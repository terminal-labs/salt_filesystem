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


Ensure puppet_translation2/v1 directorys are present:
  file.directory:
    - name: /root/puppet_translation2/v2
    - user: root
    - group: root
    - dir_mode: 755
