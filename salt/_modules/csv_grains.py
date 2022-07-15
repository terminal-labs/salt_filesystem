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

    diff = [line for line in diff if line[:2] not in ("--", "++", "@@") and "," in line]  # noqa:E501

    subtractions = [line for line in diff if line[0] == '-']
    additions = [line for line in diff if line[0] == '+']
    return dict(subtractions=subtractions, additions=additions)


def delete_grains():
    subtractions = [line.split(',') for line in get_diff()['subtractions']]  # noqa:E501
    for subtraction in subtractions:
        if __grains__['id'] == subtraction[0][1:]:
            tiaa_maintsched_deleted = __salt__[
                'grains.delkey']("tiaa_maintsched")
            tiaa_patching_deleted = __salt__['grains.delkey']("tiaa_patching")
    return tiaa_maintsched_deleted, tiaa_patching_deleted


def create_grains():
    additions = [line.split(',') for line in get_diff()['additions']]  # noqa:E501
    for addition in additions:
        if __grains__['id'] == addition[0][1:]:
            tiaa_maintsched_added = __salt__['grains.setval'](
                "tiaa_maintsched", addition[2])
            if "app" in addition:
                tiaa_patching_added = __salt__[
                    'grains.setval']("tiaa_patching", True)

    tiaa_maintsched = __salt__['grains.get']("tiaa_maintsched")
    tiaa_patching = __salt__['grains.get']("tiaa_patching")
    return {"tiaa_maintsched": tiaa_maintsched}, {"tiaa_patching": tiaa_patching}  # noqa:E501
