{% if grains['os'] == 'Windows' %}

{% set win_units = salt["cron_schedule.transform_tiaa_maintsched_win"](grains['tiaa_maintsched']) %}

# Ensure patching script is present on the minion and cronjob
# is set if opted-in (!None)
{% if win_units != None %}
Ensure_patching_script_locally_present_win:
  file.managed:
    - name: 'C:\Users\Administrator\patching_script.ps1'
    - source: salt://state/cron_patch/files/patching_script.ps1
    - defaults:
    - template: jinja
      weekday: {{ win_units["weekday"] }}
      hour: {{ win_units["hour"] }}
      monthday: {{ win_units["monthday"] }}

Win_action_present:
  win_task.add_action:
    - name: tiaa_maintsched
    - location: \ #(C:\Windows\System32\tasks).
    - user_name: System
    - action_type: Execute
    - cmd: 'C:\Users\Administrator\patching_script.ps1'
    {% if win_units['monthday'] != "All" %}
    - trigger_type: MonthlyDay
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
{% endif %}

{% endif %}
# Windows skips jobs... "every week remove job, then job gets added back in as debugging technique"
# Demonstrate salt's scheduler. 