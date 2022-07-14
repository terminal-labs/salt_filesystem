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
    print(salt['tiaa_key.generate_activation_keys']())
    return salt['tiaa_key.generate_activation_keys']()
