#!/usr/bin/env python

# type: ignore
# flake8: noqa

minion_id = {{grains['id']}}


def env_grains():
    # initialize a grains dictionary
    test_grain = {"id2": minion_domain}
    return test_grain
