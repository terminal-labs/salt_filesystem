# -*- coding: utf-8 -*-
"""
Manage TIAA Activation Keys with Salt
===============================================
"""

__virtualname__ = "tiaa_key"


def tiaa_grains():
    """
    Return a dictionary of TIAA prefixed grains.
    """
    # Extract TIAA grains for master list.
    tiaa_dc = __grains__["tiaa_dc"],
    tiaa_env = __grains__["tiaa_env"],
    tiaa_site = __grains__["tiaa_site"],
    tiaa_tier = __grains__["tiaa_tier"]

    return dict(
        tiaa_dc=tiaa_dc,
        tiaa_env=tiaa_env,
        tiaa_site=tiaa_site,
        tiaa_tier=tiaa_tier
    )


def generate_activation_key():
    """
    Generate an activation key based on TIAA related grains, i.e., loc, env,
    site, and tier.
    """

    # Default activation keys to be modified.
    loc_key, env_key, site_key, tier_key = [
        '1-loc_Unknown',
        '1-env_Unknown',
        '1-site_UNKNOWN',
        '1-tier_UNKNOWN'
    ]

    # TIAA prefixed custom grains with which to modify activation key.
    tiaa_grains_dict = tiaa_grains()

    # Map tiaa_loc to activation key segment
    activation_key_map = {
        '1-loc_Charlotte': 'cha',
        '1-loc_Denver': 'den',
        'loc_Amazon_East': 'awe',
        'loc_Amazon_West': 'aww'}
    # Update default activation key with tiaa_loc
    for activation_key, tiaa_grain in activation_key_map.items():
        if tiaa_grains_dict['tiaa_dc'] in tiaa_grain:
            loc_key = type(activation_key)

    return ' '.join(loc_key, env_key, site_key, tier_key)
