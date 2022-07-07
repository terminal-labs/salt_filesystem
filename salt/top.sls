dev1:
    '*':
        - state.foo

    'roles:database':
        - match: grain
        - state.dev1_only
        - state.script1
        - state.script2
