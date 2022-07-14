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


def patching_enabled():
    tiaa_patching_enabled_grain = __salt__[
        'grains.get']("tiaa_patching_enabled")
    if tiaa_patching_enabled_grain is ("" or False):
        __salt__['grains.setval'](
            "tiaa_patching_enabled", True, destructive=False)
        tiaa_patching_enabled_grain = __salt__[
            'grains.get']("tiaa_patching_enabled")
    return tiaa_patching_enabled_grain


def patching_disabled():
    tiaa_patching_enabled_grain = __salt__[
        'grains.get']("tiaa_patching_enabled")
    if tiaa_patching_enabled_grain is ("" or True):
        __salt__['grains.setval'](
            "tiaa_patching_enabled", False, destructive=False)
        tiaa_patching_enabled_grain = __salt__[
            'grains.get']("tiaa_patching_enabled")
    return tiaa_patching_enabled_grain
