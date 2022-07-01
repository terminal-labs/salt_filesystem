Ensure script2 is available on minion:
  file.managed:
    - name: /root/script2-dev1.sh
    - source: salt://state/script2/files/script2.sh
    - mode: 600

Run script2 directly on minion:
  cmd.run:
    - name: bash /root/script2-dev1.sh
    