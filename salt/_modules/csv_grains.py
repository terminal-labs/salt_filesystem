# type: ignore
# flake8: noqa
# -*- coding: utf-8 -*-
"""
Manage TIAA Activation Keys with Salt
===============================================
"""
#!/usr/bin/env python

# Module name
__virtualname__ = "csv_grains"


def _get_saltenv():
    return __salt__["config.get"]("saltenv")


def get_diff(
        yesterday_filepath="salt://state/csv_grains_updater/files/yesterday.csv",
        today_filepath="salt://state/csv_grains_updater/files/today.csv"):

    saltenv = _get_saltenv()
    diff = __salt__["file.get_diff"](
        yesterday_filepath,
        today_filepath,
        saltenv=saltenv).split("\n")

    # diff = [line for line in diff if line[:2] not in ("--", "++", "@@")]

    return diff
