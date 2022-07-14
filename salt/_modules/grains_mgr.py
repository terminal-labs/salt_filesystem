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
    if ("" or False) is tiaa_patching_grain:
        __salt__['grains.setval']("tiaa_patching", True)
        tiaa_patching_grain = __salt__['grains.get']("tiaa_patching")
    return tiaa_patching_grain


def patching_disabled():
    tiaa_patching_grain = __salt__['grains.get']("tiaa_patching")
    if ("" or True) is tiaa_patching_grain:
        __salt__['grains.setval']("tiaa_patching", False)
        tiaa_patching_grain = __salt__['grains.get']("tiaa_patching")
    return tiaa_patching_grain


def remove_grain(grain_key="tiaa_patching"):
    if __salt__['grains.get']("tiaa_patching") is "":
        return f"No {grain_key} grain is present."
    else:
        __salt__['grains.delkey']("tiaa_patching")
        return f"Grain{grain_key} grain deleted."
