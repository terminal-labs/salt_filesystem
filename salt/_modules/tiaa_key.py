# -*- coding: utf-8 -*-
"""
Manage TIAA Activation Keys with Salt
===============================================
"""

__virtualname__ = "tiaa_key"


def get_tiaa_grains():
    """
    Return a dictionary of TIAA prefixed grains.
    """
    # tiaa_grains = {
    #     "tiaa_dc": grains["tiaa_dc"],
    #     "tiaa_env": grains["tiaa_env"],
    #     "tiaa_site": grains["tiaa_site"],
    #     "tiaa_tier": grains["tiaa_tier"]
    # }
    fqdn = __grains__['fqdn']
    return fqdn


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
