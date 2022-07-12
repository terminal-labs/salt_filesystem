#!/usr/bin/env python

# type: ignore
# flake8: noqa

# minion_id = __grains__['id']


def env_grains():
    # initialize a grains dictionary
    test_grain = {"id2": "sam"}
    return test_grain
