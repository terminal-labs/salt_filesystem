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
        "tiaa_site": fqdn[7],
        "tiaa_tier": fqdn[8]
    }
    return tiaa_grains
