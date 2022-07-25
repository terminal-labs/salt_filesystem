###############################################################
# Select workflow based on OS. Referencing the grain directly #
# is ok since its not a custom grain... i.e grains['os']      #
# versus salt['grains.get']('os')                             #
###############################################################
{% if grains['os'] == 'RedHat'%}

#######################################################
# Transform tiaa_maintsched grain data by calling     #
# custom module defined in `_modules/maintsched.py`.  #
# salt['grains.get']('tiaa_maintsched') is necessary  #
# in this case versus grains['tiaa_maintsched'] since #
# this is a custom grain that might not exist.        #
#######################################################
{% set cron_units = salt["maintsched.transform_tiaa_maintsched_rhel"](salt['grains.get']('tiaa_maintsched')) %}

###################################################
# Ensure patching script is present on the minion #
###################################################
{% if cron_units != None %}
Ensure_patching_script_locally_present_rhel:
  file.managed:
    - name: /root/patching_script.sh
    - source: salt://state/maintsched/files/patching_script.sh
    - defaults:
    - template: jinja
      weekday: {{ cron_units["weekday"] }}
      hour: {{ cron_units["hour"] }}
      day: {{ cron_units["day"] }}

################################################################
# Ensure Cron Job is present and set to maintsched requirement #
# if opted-in ( not None)                                      #
################################################################
Cron_job_present:
  cron.present:
    - name: '[ $(date +\%A) == {{cron_units["weekday"]}} ] && bash /root/patching_script.sh'
    - user: root
    - minute: {{ salt["random.seed"](55)}}
    - hour: {{ cron_units["hour"] }}
    - daymonth: {{ cron_units["day"] }}
    - identifier: "tiaa_maintsched"
    - require:
      - file: Ensure_patching_script_locally_present_rhel

################################################
# Ensure cronjob is absent if opted-out (None) #
################################################
{% else %}
Cron_job_absent:
  cron.absent:
    - name: '*'
    - user: root
    - identifier: "tiaa_maintsched"
{% endif %}

###############################################################
# Select workflow based on OS. Referencing the grain directly #
# is ok since its not a custom grain... i.e grains['os']      #
# versus salt['grains.get']('os')                             #
###############################################################
{% elif grains['os'] == 'Windows' %}

###########################################
# python-dateutil must be available for   #
# human readbale "Sunday 11:30pm" format  #
###########################################
Ensure_python-dateutil_pkg_available:
  pkg.installed:
    - pkgs:
      - python-dateutil

############################################################
# Purge tiaa_maintsched task from windows scheduler weekly #
# on Sunday 11:30pm. Sets a weekly schedule for            #
# `state.maintsched.clear_win_tasks`                       #
############################################################
Weekly_windows_tiaa_maintsched_task_purge:
  schedule.present:
    - name: delete_windows_tiaa_maintsched_task_weekly
    - function: state.sls
    - job_args:
      - state.maintsched.clear_win_tasks
    - when:
        - Sunday 11:30pm

#########################################################
# Transform tiaa_maintsched grain data by calling       #
# custom module defined in `_modules/maintsched.py`.    #
# salt['grains.get']('tiaa_maintsched') is necessary    #
# in this case versus grains['tiaa_maintsched'] since   #
# this is a custom grain that might not exist.          #
#########################################################
{% set win_units = salt["maintsched.transform_tiaa_maintsched_win"](salt['grains.get']('tiaa_maintsched')) %}

####################################################
# Ensure patching script is present on the minion  #
####################################################
{% if win_units != None %}
Ensure_patching_script_locally_present_win:
  file.managed:
    - name: 'C:\Users\Administrator\patching_script.ps1'
    - source: salt://state/maintsched/files/patching_script.ps1
    - defaults:
    - template: jinja
      weekday: {{ win_units["weekday"] }}
      hour: {{ win_units["hour"] }}
      monthday: {{ win_units["monthday"] }}

#################################################
# Ensure Windows Task is present and set to     #
# maintsched requirement if opted-in (not None) #
#################################################
Win_task_present:
  task.present:
    - name: tiaa_maintsched
    - location: \ 
    - user_name: System
    - action_type: Execute
    - force: True
    - cmd: 'C:\Users\Administrator\patching_script.ps1'
    {% if win_units['monthday'] != "All" %}
    - trigger_type: MonthlyDay
    - months_of_year: 
      - January
      - February
      - March
      - April
      - May
      - June
      - July
      - August
      - September
      - October
      - November
      - December
    - days_of_week:
      - {{ win_units['weekday'] }}
    - weeks_of_month: 
    {% for monthday in win_units['monthday'] %}
      - {{ monthday }}
    {% endfor %}
    {% else %}
    - trigger_type: Weekly
    {% endif %}
    - start_time: "{{win_units['hour']}}:{{salt['random.seed'](55)}}"
    - require:
      - file: Ensure_patching_script_locally_present_win

#####################################################
# Ensure Windows Task is absent if opted-out (None) #
#####################################################
{% else %}
win_task_absent:
  task.absent:
    - name: tiaa_maintsched
{% endif %}
{% endif %}
