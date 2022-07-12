#!/usr/bin/env python

# type: ignore
# flake8: noqa

import socket


def env_grains():
    # initialize a grains dictionary
    fqdn = socket.getfqdn()
    tiaa_grains = {
        "tiaa_dc": fqdn[:3],
        "tiaa_env": fqdn[4:6],
        "tiaa_site": fqdn[6],
        "tiaa_tier": fqdn[7]
    }
    return tiaa_grains

# {% for tiaa_grain, key_segment in [
#     ['cha', '1-loc_Charlotte'],
#     ['den', '1-loc_Denver'],
#     ['awe', 'loc_Amazon_East'],
#     ['aww', 'loc_Amazon_West']] %}

# {% if tiaa_grain == grains['tiaa_dc'] %}
# {% set activation_key = 'test' %}

# {% endif %}
# {% endfor %}
