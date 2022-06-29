Ensure script2 is available on minion:
  file.managed:
    - name: /root/script2.sh
    - source: salt://script2/files/script2.sh
    - mode: 600

Run script2:
  cmd.run:
    - name: bash /root/script2.sh
    