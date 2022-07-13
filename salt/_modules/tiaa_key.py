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
    tiaa_dc = __grains__["tiaa_dc"],
    tiaa_env = __grains__["tiaa_env"],
    tiaa_site = __grains__["tiaa_site"],
    tiaa_tier = __grains__["tiaa_tier"]
    return dict(tiaa_dc=tiaa_dc, tiaa_env=tiaa_env, tiaa_site=tiaa_site, tiaa_tier=tiaa_tier)


# def convert_hosted_zone_domain_name_to_id(keyid, key, domain_name):
#     """
#     Returns a hosted zone ID for a hosted zone domain name if exists, else
#     returns None.
#     """
#     client = establish_client(keyid, key)
#     hosted_zones = client.list_hosted_zones_by_name(DNSName=domain_name)
#     for hosted_zone in hosted_zones['HostedZones']:
#         if hosted_zone['Name'] == f'{domain_name}.':
#             return hosted_zone['Id'].split('/')[-1]
#     return None
