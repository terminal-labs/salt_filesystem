# type: ignore
# flake8: noqa
# -*- coding: utf-8 -*-
"""
Manage Patching Grains from CSV
===============================================
"""
#!/usr/bin/env python

# Module name
__virtualname__ = "csv_grains"


def _get_saltenv():
    """
    Gets minion's environment. Underscore (_) restricts module to thiss file. 
    """
    return __salt__["config.get"]("saltenv")


def get_diff(
        yesterday_filepath="salt://state/csv_grains_updater/files/yesterday.csv",
        today_filepath="salt://state/csv_grains_updater/files/today.csv"):
    """
    Gets differences between 2 files. This implementation targets files on 
    the master, i.e. 'salt://'.
    """

    # Difference between 2 files, saltenv defaults to 'base' for built-in
    # file.get_diff module.
    saltenv = _get_saltenv()
    diff = __salt__["file.get_diff"](
        yesterday_filepath,
        today_filepath,
        saltenv=saltenv).split("\n")

    # Clean lines for further processsing.
    diff = [line for line in diff if line[:2] not in ("--", "++", "@@") and "," in line]  # noqa:E501

    # Return subtractions and additions separately.
    subtractions = [line for line in diff if line[0] == '-']
    additions = [line for line in diff if line[0] == '+']
    return dict(subtractions=subtractions, additions=additions)


def delete_grains():
    """
    Delete grains associated with subtraction between old and new. 
    Meant to be performed first.
    """

    # Break up list of subtraction lines into list of list of values.
    subtractions = [line.split(',') for line in get_diff()['subtractions']]  # noqa:E501

    # Delete grains if substraction line has minion's id.
    for subtraction in subtractions:
        if __grains__['id'] == subtraction[0][1:]:
            __salt__['grains.delkey']("tiaa_maintsched")
            __salt__['grains.delkey']("tiaa_patching")

    # 'grains.get' should return "" instead of error if no grain is available.
    tiaa_maintsched = __salt__['grains.get']("tiaa_maintsched")
    tiaa_patching = __salt__['grains.get']("tiaa_patching")
    return {"tiaa_maintsched": tiaa_maintsched}, {"tiaa_patching": tiaa_patching}  # noqa:E501


def create_grains():
    """
    Create grains associated with additions between old and new. 
    Meant to be performed following deletes..
    """

    # Break up list of addition lines into list of list of values.
    additions = [line.split(',') for line in get_diff()['additions']]  # noqa:E501

    # Add related grains if addition line has minion's id.
    for addition in additions:
        if __grains__['id'] == addition[0][1:]:
            __salt__['grains.setval']("tiaa_maintsched", addition[2])
            # Add 'tiaa_patching grain if 'app' is present.
            if "app" in addition:
                __salt__['grains.setval']("tiaa_patching", True)

    # 'grains.get' should return updated values.
    tiaa_maintsched = __salt__['grains.get']("tiaa_maintsched")
    tiaa_patching = __salt__['grains.get']("tiaa_patching")
    return {"tiaa_maintsched": tiaa_maintsched}, {"tiaa_patching": tiaa_patching}  # noqa:E501
