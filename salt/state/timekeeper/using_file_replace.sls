{% set system_time = salt['system.get_system_date_time']() %}

Ensure_update_file_is_present_with_original_time:
  file.managed:
    - name: /root/update_record_2.txt
    - contents:
      - '######################################'
      - '# Last update on {{ system_time }} #'
      - '######################################'
      - '##########################################'
      - '# Original update on {{ system_time }} #'
      - '##########################################'
    - replace: False

Ensure_update_time_is_replaced_and_original_time_stays:
  file.replace:
    - name: /root/update_record_2.txt
    - pattern: "# .* #"
    - repl: "# Last update on {{ system_time }} #"
    - count: 1
    - backup: False
    - onlyif: 
      - 'ls /root/update_record_2.txt'

Ensure_time_will_be_updated_every_60_seconds:
  schedule.present:
    - name: file_replace_updater
    - function: state.sls
    - job_args:
      - state.timekeeper.using_file_replace
    - seconds: 60
