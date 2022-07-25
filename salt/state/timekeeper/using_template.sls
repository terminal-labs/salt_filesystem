###############################################
# Set Jinja variable system_time equal to the #
# system's current UTC time                   #
###############################################
{% set system_time = salt['system.get_system_date_time']() %}

############################################################
# Timekeeper file on the minion will be replaced each time #
# the salt state is run and changes are detected.          #
############################################################
Ensure_time_update_is_updated_in_minion_update_file:
  file.managed:
    - name: /root/update_record.txt
    - source: salt://state/timekeeper/files/update_record.txt
    - defaults:
    - template: jinja
      update_time: {{ system_time }}

##########################################################
# The following state ensures a salt schedule is present #
# on the minion... note the following potential error if #
# too many states are being run at once...               #
##########################################################

#############################################################
# Note: Only one state can be run on a minion at once.      #
# With overly frequent schedules attempts to run additional #
# states could result in the following type of error:       #
# <minion-id>:                                              #
#     Data failed to compile:                               #
# ----------                                                #
#     The function "state.sls" is running as PID 5418 and   #
#     was started at 2022, Jul 21 20:39:55.457957 with      #
#     jid 20220721203955457957                              #
#############################################################
Ensure_time_will_be_updated_every_60_seconds:
  schedule.present:
    - name: update_record_file_every_5sec
    - function: state.sls
    - job_args:
      - state.timekeeper.using_template
    - seconds: 60
