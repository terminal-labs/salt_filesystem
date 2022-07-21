# Separate workflow for RedHat and Windows
{% if grains['os'] == 'Windows' %}

# Ensure Windows Task is absent if opted-out (None)
win_task_absent:
  task.absent:
    - name: tiaa_maintsched
{% endif %}
