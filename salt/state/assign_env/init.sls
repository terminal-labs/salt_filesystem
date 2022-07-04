{% import_yaml 'state/assign_env/files/map.yaml' as var %}

Ensure minion env.conf file is current:
  file.managed:
    - name: /etc/salt/minion.d/env.conf
    - source: salt://state/assign_env/files/env.conf
    - template: jinja
    - defaults:
      environment: {{ var.saltenv }}

Ensure minion env.conf changes are applied:
  service.running:
    - name: salt-minion
    - restart: True
    - watch:
      - file: /etc/salt/minion.d/env.conf
