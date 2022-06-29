Ensure scipt1 is available on minion:
  file.managed:
    - name: /root/script1.sh
    - source: salt://script1/files/script1.sh
    - mode: 600
