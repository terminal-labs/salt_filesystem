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

#   case $week {
#     '1st': {$wom = '1-7'}
#     '2nd': {$wom = '8-14'}
#     '3rd': {$wom = '15-21'}
#     '4th': {$wom = '22-28'}
# '1st&3rd': {$wom = ['1-7', '15-21']}
# '2nd&4th': {$wom = ['8-14', '22-28']}
#   'every': {$wom = '*'}
#   default: { fail('Patch WeekofMonth is not supported') }
#   }

#   # resource title must not change: they are used by Puppet to match cron entries
#   cron { 'Monthly maintenance: patch & restart instance':
#     ensure   => 'present',
#     command  => "[ $(date +\\%A) == '${day}' ] && /usr/local/scripts/monthlyMaint.sh",
#     user     => 'root',
#     month    => '*',
#     monthday => $wom,
#     weekday  => '*',
#     hour     => "${hour}",
#     minute   => fqdn_rand( 50 ),
#   }
#   }
# 42 21 8-14,22-28 * *
# min hour day * *


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


# pprint(transform_tiaa_maintsched("2nd&4th-Tuesday@9pm"))
# pprint(transform_tiaa_maintsched("1st&3rd-Monday@9pm"))
# pprint(transform_tiaa_maintsched("every-Wednesday@11pm"))