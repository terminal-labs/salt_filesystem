###########################################################
# Values can be imported from `assign_env/files/map.yaml` #
# in addition to pillar demonstrated below...             #
###########################################################
{% import_yaml 'state/assign_env/files/map.yaml' as var %}

#################################################################
# Replaces the minion config file `/etc/salt/minion.d/env.conf` #
# to change its saltenv to the value given in pillar or the map #
# file 'state/assign_env/files/map.yaml'                        #
#################################################################
Ensure minion env.conf file is current:
  file.managed:
    - name: /etc/salt/minion.d/env.conf
    - source: salt://state/assign_env/files/env.conf
    - template: jinja
    - defaults:
      environment: {{ pillar['fileserver_env'] }}
#     enviornment{{  var.saltenv }}

####################################
# Restart the salt minion to apply #
# the new configuration            #
####################################
Restart Salt Minion:
  cmd.run:
    - name: 'salt-call service.restart salt-minion'
    - bg: True
    - watch:
      - file: /etc/salt/minion.d/env.conf
