Ensure script1 is available on minion:
  file.managed:
    - name: /root/script1-dev1.sh
    - source: salt://script1/files/script1.sh
    - mode: 600

Run script1:
  cmd.run:
    - name: bash /root/script1-dev1.sh
