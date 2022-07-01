Ensure script1 is available on minion:
  file.managed:
    - name: /root/script1-dev1.sh
    - source: salt://state/script1/files/script1.sh
    - mode: 600

Run dev1 script directly from master:
  cmd.script:
    - source: salt://state/dev1_only/files/dev1_only_script.sh
#    - name: salt://state/dev1_only/files/dev1_only_script.sh
