{% set postdata = data.get('post', {}) %}

run_command:
  local.cmd.run:
    - tgt: '{{ postdata.tgt }}'
    - arg: 
      - {{ postdata.cmd }}
