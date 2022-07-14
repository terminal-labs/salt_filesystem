# type: ignore
# flake8: noqa
# -*- coding: utf-8 -*-
"""
Manage TIAA Activation Keys with Salt
===============================================
"""
#!/usr/bin/env python

# Module name
__virtualname__ = "grains_mgr"


def test():
    print(__salt__['tiaa_key.generate_activation_keys']())
    return __salt__['tiaa_key.generate_activation_keys']()


def patching_enabled():
    try:
        patching_grain = __grains__['tiaa_patchapp']
    except KeyError:
        patching_grain = None

    if patching_grain is None:
        return "No grain set"
    else:
        return patching_grain
