# Since the same keys are present in `foo12.sls` 
# and `foo34.sls` and scoped to different minions, 
# the values can be referenced soley by referencing 
# the key, i.e., pillar['foo'] in sls files without 
# conflict

dev1:
  'rhel1*':
    - foo12
  'rhel2*':
    - foo12
  'rhel3*':
    - foo34
  'rhel4*':
    - foo34
