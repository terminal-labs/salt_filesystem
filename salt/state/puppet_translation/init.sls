{% if grains['domain'] = qic.tiaa-cref.org%}
    {% set sat_server = "hiera('rhelfinish::register_satellite6::lab_satellite_server')" %}
{% else %}
    {% set sat_server = "hiera('rhelfinish::register_satellite6::satellite_server')" %}
{% endif %}

test_state:
  cmd.run:
    - name: echo {{sat_server}} > /root/sat_server.txt

