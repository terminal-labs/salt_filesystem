{% set cron_units = salt["cron_schedule.transform_tiaa_maintsched"](grains['tiaa_maintsched']) %}

# Ensure patching script is present on the minion. 
Ensure_patching_script_locally_present:
  file.managed:
    - name: /root/patching_script.sh
    - source: salt://state/cron_patch/files/patching_script.sh
    - defaults:
    - template: jinja
      weekday: {{ cron_units["weekday"] }}
      hour: {{ cron_units["hour"] }}
      day: {{ cron_units["day"] }}

## Ensure cron job is present
#Cron_job_present:
#  cron.present:
#    - name: if [ $(date +\%A) == '{{cron_units["weekday"]}}' ]; then bash /root/patching_script.sh; fi
#    - user: root
#    - minute: random
#    - hour: {{ cron_units["hour"] }}
#    - daymonth: {{ cron_units["day"] }}
#    - identifier: "scheduled_patching"
#    - require:
#      - file: Ensure_patching_script_locally_present

## Ensure cron job is present
#Cron_job_present_tues:
#  cron.present:
#    - name: if [ $(date +\%A) == 'Tuesday' ]; then bash /root/patching_script.sh; fi
#    - user: root
#    - minute: random
#    - hour: {{ cron_units["hour"] }}
#    - daymonth: {{ cron_units["day"] }}
#    - identifier: "scheduled_patching_tues"
#    - require:
#      - file: Ensure_patching_script_locally_present

# Ensure cron job is present
#Cron_job_present_wed:
#  cron.present:
#    - name: if [ $(date +\%A) == 'Wednesday' ]; then bash /root/patching_script.sh; fi
#    - user: root
#    - minute: random
#    - hour: {{ cron_units["hour"] }}
#    - daymonth: {{ cron_units["day"] }}
#    - identifier: "scheduled_patching_wed"
#    - require:
#      - file: Ensure_patching_script_locally_present

# Ensure cron job is absent
Cron_job_absent:
  cron.absent:
    - name: '*'
    - user: root
    - identifier: "scheduled_patching_wed"
