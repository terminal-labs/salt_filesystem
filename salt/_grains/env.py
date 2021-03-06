#!/usr/bin/env python

# type: ignore
# flake8: noqa

import socket

# One possible way creating a custom grain
# based on minion's fqdn


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
