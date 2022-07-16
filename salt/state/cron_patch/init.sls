{% set cron_units = salt["cron_schedule.transform_tiaa_maintsched"](grains['tiaa_maintsched']) %}

# Ensure patching script is present on the minion. 
Ensure patching script locally present:
  file.managed:
    - name: /root/patching_script.sh
    - source: salt://state/cron_patch/files/patching_script.sh

# Ensure bridge script is present on the minion. 
Ensure bridge script locally present:
  file.managed:
    - name: /root/bridge_script.sh
    - source: salt://state/cron_patch/files/bridge_script.sh
    - template: jinja
    - defaults:
      patching_script: "/root/patching_script.sh"
      weekday: {{ cron_units["weekday"] }}
    - require:
      - sls: Ensure patching script locally present

