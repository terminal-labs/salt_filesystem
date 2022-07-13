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
    return dict(tiaa_dc=tiaa_dc, tiaa_env=tiaa_env, tiaa_site=tiaa_site, tiaa_tier=tiaa_tier)


def generate_activation_key():
    """
    Generate an activation key based on TIAA related grains, i.e., loc, env, site, and tier.
    """

    # Default activation key to be modified.
    activation_key = [
        '1-loc_Unknown',
        '1-env_Unknown',
        '1-site_UNKNOWN',
        '1-tier_UNKNOWN'
    ]

    # TIAA prefixed custom grains with which to modify activation key.
    tiaa_grains_dict = tiaa_grains()

    tiaa_grain = tiaa_grains_dict['cha']
    match tiaa_grain:
        case 'cha':
            activation_key[0] = '1-loc_Charlotte'
        case 'den':
            activation_key[0] = '1-loc_Denver'
        case 'awe':
            activation_key[0] = '1-loc_Amazon_East'
        case 'aww':
            activation_key[0] = '1-loc_Amazon_West'

    return activation_key
