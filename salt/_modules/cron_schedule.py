# type: ignore
# flake8: noqa
# -*- coding: utf-8 -*-
"""
Cron Schedule  Syntax Conversion
===============================================
"""
#!/usr/bin/env python

import re
from pprint import pprint

# Module name
__virtualname__ = "cron_schedule"


def transform_tiaa_maintsched(tiaa_maintsched):
    cron_sched = None
    if '-' in tiaa_maintsched:
        monthday_map = {
            '1st': '1-7',
            '2nd': '8-14',
            '3rd': '15-21',
            '4th': '22-28',
            '1st&3rd': '1-7,15-21',
            '2nd&4th': '8-14,22-28',
            'every': '*'
        }
        monthday, weekday, hour = re.split('-|@', tiaa_maintsched)
        day = monthday_map[monthday]
        r = re.compile("([0-9]+)([a-zA-Z]+)")
        m = r.match(hour)
        char = m.group(2)
        hour = m.group(1) if "am" in char.lower() else str(int(m.group(1))+12)  # noqa:E501

        cron_sched = dict(hour=hour, day=day, weekday=weekday)
    return cron_sched
