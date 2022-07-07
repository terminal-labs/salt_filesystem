dev1:
    '*':
        - state.script1
        - state.script2

    'roles:database':
        - match: grain
        - state.dev1_only
