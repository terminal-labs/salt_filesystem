dev1:
    '*':
        - state.nginx_running
        - state.timekeeper.using_template

    'roles:role_1':
        - match: grain
        - state.maintsched

    'roles:role_2':
        - match: grain
        - state.sat_key_gen_1
