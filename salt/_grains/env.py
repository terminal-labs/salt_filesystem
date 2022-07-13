#!/usr/bin/env python

# type: ignore
# flake8: noqa

# import socket


def env_grains():
    # initialize a grains dictionary
    file = open("/etc/salt/minion_id")
    fqdn = file.readline()
    # fqdn = socket.getfqdn()
    tiaa_grains = {
        "tiaa_dc": fqdn[:3],
        "tiaa_env": fqdn[3:5],
        "tiaa_site": fqdn[6],
        "tiaa_tier": fqdn[7]
    }
    return tiaa_grains
