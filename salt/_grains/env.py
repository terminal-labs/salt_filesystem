#!/usr/bin/env python

# type: ignore
# flake8: noqa


def env_grains(minion_id=__grains__['id']):
    # initialize a grains dictionary
    # minion_id = __grains__['id']
    test_grain = {"id2": minion_id}
    return test_grain
