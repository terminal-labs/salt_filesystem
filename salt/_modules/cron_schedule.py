# type: ignore
# flake8: noqa
# -*- coding: utf-8 -*-
"""
Cron Schedule Syntax Conversion
===============================================
"""
#!/usr/bin/env python

import re

# Module name
__virtualname__ = "cron_schedule"


def transform_tiaa_maintsched_rhel(tiaa_maintsched):
    """
    Transform schedule input into cron usable form.
    """

    # Default if no tiaa_maintschedule is opted-out.
    cron_sched = None

    # Transform if opt-in (Will contain '-' if
    # schedule provided. Must not contain isolation)
    if '-' in tiaa_maintsched and "isolation" not in tiaa_maintsched.lower():  # noqa:E501
        monthday_map = {
            '1st': '1-7',
            '2nd': '8-14',
            '3rd': '15-21',
            '4th': '22-28',
            '1st&3rd': '1-7,15-21',
            '2nd&4th': '8-14,22-28',
            'every': "'*'"
        }
        # Split input at '-' and '@', set variables.
        monthday, weekday, hour = re.split('-|@', tiaa_maintsched)
        day = monthday_map[monthday]

        # Convert hour into 24hr clock
        r = re.compile("([0-9]+)([a-zA-Z]+)")
        m = r.match(hour)
        char = m.group(2)
        hour = m.group(1) if "am" in char.lower() else str(int(m.group(1))+12)  # noqa:E501

        cron_sched = dict(hour=hour, day=day, weekday=weekday)
    return cron_sched


def transform_tiaa_maintsched_win(tiaa_maintsched):
    """
    Transform schedule input into win_task usable form.
    """

    # Default if no tiaa_maintschedule is opted-out.
    win_sched = None

    # Transform if opt-in (Will contain '-' if
    # schedule provided. Must not contain isolation)
    if '-' in tiaa_maintsched and "isolation" not in tiaa_maintsched.lower():  # noqa:E501
        monthday_map = {
            '1st': ['First'],
            '2nd': ['Second'],
            '3rd': ['Third'],
            '4th': ['Fourth'],
            '1st&3rd': ['First', 'Third'],
            '2nd&4th': ['Second', 'Fourth'],
            'every': "All"
        }
        # Split input at '-' and '@', set variables.
        monthday, weekday, hour = re.split('-|@', tiaa_maintsched)
        monthday = monthday_map[monthday]

        # Convert hour into 24hr clock
        r = re.compile("([0-9]+)([a-zA-Z]+)")
        m = r.match(hour)
        char = m.group(2)
        hour = m.group(1) if "am" in char.lower() else str(int(m.group(1))+12)  # noqa:E501

        win_sched = dict(hour=hour, monthday=monthday, weekday=weekday)
    return win_sched
