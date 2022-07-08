{% set postdata = data.get('post', {}) %}

run_command:
  cmd.run:
    - name: '{{ postdata.cmd }}'
