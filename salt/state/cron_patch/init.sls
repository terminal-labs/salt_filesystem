# Transform tiaa_maintsched grain data
{% set cron_units = salt["cron_schedule.transform_tiaa_maintsched"](grains['tiaa_maintsched']) %}

# Ensure patching script is present on the minion and cronjob
# is set if opted-in (!None)
{% if cron_units != None %}
Ensure_patching_script_locally_present:
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
    - name: '[ $(date +\%A) == {{cron_units["weekday"]}} ] && /root/patching_script.sh'
    - user: root
#    - minute: random
#    - hour: {{ cron_units["hour"] }}
#    - daymonth: {{ cron_units["day"] }}
    - minute: 35
    - hour: 14
    - daymonth: 16
    - identifier: "tiaa_maintsched"
    - require:
      - file: Ensure_patching_script_locally_present

# Ensure cronjob is absent if opted-out (None)
{% else %}
Cron_job_absent:
  cron.absent:
    - name: '*'
    - user: root
    - identifier: "tiaa_maintsched"
{% endif %}
