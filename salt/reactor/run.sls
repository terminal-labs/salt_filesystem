{% set postdata = data.get('post', {}) %}

run_command:
  cmd.run:
    - tgt: '{{ postdata.tgt }}'
    - name: {{ postdata.cmd }}
