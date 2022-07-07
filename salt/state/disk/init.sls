storage_threshold:
  disk.status:
    - name: /dev/xda1
    - maximum: 97%

clear_cache:
  cmd.run:
    - name: rm -r /var/cache/app
    - onfail:
      - disk: storage_threshold

