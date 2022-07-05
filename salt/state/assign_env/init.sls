#{% import_yaml 'state/assign_env/files/map.yaml' as var %}

Ensure minion env.conf file is current:
  file.managed:
    - name: /etc/salt/minion.d/env.conf
    - source: salt://state/assign_env/files/env.conf
    - template: jinja
    - defaults:
      environment: {{ pillar['fileserver_env'] }}

Restart Salt Minion:
  cmd.run:
    - name: 'salt-call service.restart salt-minion'
    - bg: True
    - watch:
      - file: /etc/salt/minion.d/env.conf
