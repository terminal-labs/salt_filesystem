{% set system_time = salt['system.get_system_date_time'](utc_offset="'0400'") %}

Ensure_time_update_is_updated_in_minion_update_file:
  file.managed:
    - name: /root/update_record.txt
    - source: salt://state/timekeeper/files/update_record.txt
    - defaults:
    - template: jinja
      update_time: {{ system_time }}
