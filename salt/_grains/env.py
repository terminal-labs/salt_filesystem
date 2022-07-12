#!/usr/bin/env python

# type: ignore
# flake8: noqa

import socket


def env_grains():
    # initialize a grains dictionary
    fqdn = socket.getfqdn()
    # tiaa_grains = {
    #     "tiaa_dc": fqdn[:2],
    #     "tiaa_env" fqdn[3:4],
    #     "tiaa_site": fqdn[5],
    #     "tiaa_tier": fqdn[6]
    # }
    tiaa_grains = {
        "foo1": fqdn,
        "foo2": fqdn
    }
    return tiaa_grains
