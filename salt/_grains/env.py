#!/usr/bin/env python

# type: ignore
# flake8: noqa


def env_grains():
    # initialize a grains dictionary
    minion_id = grains['id']
    test_grain = {"id2": minion_id}
    return test_grain
