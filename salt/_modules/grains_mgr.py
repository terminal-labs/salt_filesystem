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
    tiaa_patching_grain = __salt__['grains.get']("tiaa_patching")
    if tiaa_patching_grain is ("" or False):
        __salt__['grains.setval']("tiaa_patching", True)
        tiaa_patching_grain = __salt__['grains.get']("tiaa_patching")
    return tiaa_patching_grain


def patching_disabled():
    tiaa_patching_grain = __salt__['grains.get']("tiaa_patching")
    if tiaa_patching_grain is ("" or True):
        __salt__['grains.setval']("tiaa_patching", False)
        tiaa_patching_grain = __salt__['grains.get']("tiaa_patching")
    return tiaa_patching_grain
