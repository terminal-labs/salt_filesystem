#!/usr/bin/env python

# type: ignore
# flake8: noqa

minion_domain = grains['id']


def env_grains():
    # initialize a grains dictionary
    test_grain = {"id2": minion_domain}
    # Some code for logic that sets grains like
    grains["yourcustomgrain"] = True
    grains["anothergrain"] = "somevalue"
    return grains
