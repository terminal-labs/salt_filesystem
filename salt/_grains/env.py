#!/usr/bin/env python

# type: ignore
# flake8: noqa

import socket


def env_grains():
    # initialize a grains dictionary
    fqdn = socket.getfqdn()
    tiaa_grains = {
        "tiaa_dc": fqdn[:3],
        "tiaa_env": fqdn[3:5],
        "tiaa_site": fqdn[6],
        "tiaa_tier": fqdn[7]
    }
    return tiaa_grains

# {% if grains['tiaa_dc'] == 'cha' %}
#     {% set activation_key = '1-loc_Charlotte' %}
# {% elif grains['tiaa_dc'] == 'den' %}
#     {% set activation_key = '1-loc_Denver' %}
# {% elif grains['tiaa_dc'] == 'awe' %}
#     {% set activation_key = 'loc_Amazon_East' %}
# {% elif grains['tiaa_dc'] == 'aww' %}
#     {% set activation_key = 'loc_Amazon_West' %}
# {% else %}
#     {% set activation_key = '1-loc_Unknown' %}
# {% endif %}
