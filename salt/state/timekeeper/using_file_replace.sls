{% set system_time = salt['system.get_system_date_time']() %}

Ensure_time_update_is_updated_in_minion_update_file_2:
  file.managed:
    - name: /root/update_record_2.txt
    - contents:
      - '######################################'
      - '# Last update on {{ system_time }} #'
      - '######################################'
      - '##########################################'
      - '# Original update on {{ system_time }} #'
      - '##########################################'
    - replace: True



#Ensure_time_will_be_updated_every_5_seconds:
#  schedule.present:
#    - name: update_record_file_every_5sec_2
#    - function: state.sls
#    - job_args:
#      - state.timekeeper.using_file_replace
#    - seconds: 5
