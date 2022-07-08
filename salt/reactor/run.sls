{% set postdata = data.get('post', {}) %}

run_command:
  local.state.single:
    - tgt: '{{ postdata.tgt }}'
    - args:
      - fun: cmd.run
      - name: {{ postdata.cmd }}
