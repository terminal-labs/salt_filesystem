# type: ignore
# flake8: noqa
# -*- coding: utf-8 -*-
"""
Manage TIAA Activation Keys with Salt
===============================================
"""
#!/usr/bin/env python

#######################################################
# Module's callable name... (usually the same name as #
# the python file encoding it by convention but can   #
# be whatever you want)                               #
#######################################################
__virtualname__ = "tiaa_key"


def hello(audience='world'):
    #############################
    # Sample function, not used #
    # in salt state code        #
    #############################
    return f'hello, {audience}'


def tiaa_grains():
    #############################
    # Sample function, not used #
    # in salt state code        #
    #############################
    #########################################
    # Extract TIAA grains from master list  #
    #########################################
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


def generate_activation_keys():
    """
    Generate activation keys based on TIAA prefixed grains, i.e., loc, env,
    site, and tier.
    """
    ###########################################
    # Default activation keys to be modified. #
    ###########################################
    activation_keys = [
        '1-loc_Unknown',
        '1-env_Unknown',
        '1-site_UNKNOWN',
        '1-tier_UNKNOWN'
    ]
    ##########################################
    # Map tiaa_loc to activation key segment #
    ##########################################
    activation_key_map = {
        '1-loc_Charlotte': 'cha',
        '1-loc_Denver': 'den',
        'loc_Amazon_East': 'awe',
        'loc_Amazon_West': 'aww'}
    ###################################################
    # Update default activation key with tiaa_loc key #
    ###################################################
    for activation_key, tiaa_grain in activation_key_map.items():
        if __grains__["tiaa_dc"] in tiaa_grain:
            activation_keys[0] = activation_key

    ##########################################
    # Map tiaa_env to activation key segment #
    ##########################################
    activation_key_map = {
        '1-env_PD': 'pd',
        '1-env_DR': 'dr',
        '1-env_PF': 'pf',
        '1-env_CT': 'ct',
        '1-env_TS': 'ts',
        '1-env_AT1': ['at', 'at1', 'ab'],
        '1-env_DV': ['dv', 'd1', 'd2', 'd3', 'd4', 'd5'],
        '1-env_IT1': ['it', 'i1']}
    ###################################################
    # Update default activation key with tiaa_env key #
    ###################################################
    for activation_key, tiaa_grain in activation_key_map.items():
        if __grains__["tiaa_env"] in tiaa_grain:
            activation_keys[1] = activation_key

    ###########################################
    # Map tiaa_site to activation key segment #
    ###########################################
    activation_key_map = {
        '1-site_A': 'a',
        '1-site_B': 'b',
        '1-site_C': 'c',
        '1-site_D': 'd',
        '1-site_E': 'e'}
    ###################################################
    # Update default activation key with tiaa_env key #
    ###################################################
    for activation_key, tiaa_grain in activation_key_map.items():
        if __grains__["tiaa_site"] in tiaa_grain:
            activation_keys[2] = activation_key

    ###########################################
    # Map tiaa_tier to activation key segment #
    ###########################################
    activation_key_map = {
        '1-tier_1': '1',
        '1-tier_2': '2',
        '1-tier_3': '3',
        '1-tier_IS': 'i'}
    ###################################################
    # Update default activation key with tiaa_env key #
    ###################################################
    for activation_key, tiaa_grain in activation_key_map.items():
        if __grains__["tiaa_tier"] in tiaa_grain:
            activation_keys[3] = activation_key

    #############################################
    # Return string of keys separated by spaces #
    #############################################
    return ' '.join(activation_keys)
