# Separate workflow for RedHat and Windows
{% if grains['os'] == 'RedHat'%}

# Transform tiaa_maintsched grain data
{% set cron_units = salt["cron_schedule.transform_tiaa_maintsched_rhel"](grains['tiaa_maintsched']) %}

# Ensure patching script is present on the minion and cronjob
# is set if opted-in (!None)
{% if cron_units != None %}
Ensure_patching_script_locally_present_rhel:
  file.managed:
    - name: /root/patching_script.sh
    - source: salt://state/cron_patch/files/patching_script.sh
    - defaults:
    - template: jinja
      weekday: {{ cron_units["weekday"] }}
      hour: {{ cron_units["hour"] }}
      day: {{ cron_units["day"] }}

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

# Ensure cronjob is absent if opted-out (None)
{% else %}
Cron_job_absent:
  cron.absent:
    - name: '*'
    - user: root
    - identifier: "tiaa_maintsched"
{% endif %}

{% elif grains['os'] == 'Windows' %}

{% set win_units = salt["cron_schedule.transform_tiaa_maintsched_win"](grains['tiaa_maintsched']) %}

# Ensure patching script is present on the minion and cronjob
# is set if opted-in (!None)
{% if win_units != None %}
Ensure_patching_script_locally_present_win:
  file.managed:
    - name: 'C:\Program Files\tiaa_patching\patching_script.ps1'
    - source: salt://state/cron_patch/files/patching_script.ps1
    - defaults:
    - template: jinja
      weekday: {{ win_units["weekday"] }}
      hour: {{ win_units["hour"] }}
      day: {{ monthday["monthday"] }}

{% endif %}
# Windows skips jobs... "every week remove job, then job gets added back in as debugging technique"
# Demonstrate salt's scheduler. 