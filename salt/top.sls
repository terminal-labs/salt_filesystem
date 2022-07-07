dev1:
    '*':
        - foo

    'roles:database':
        - match: grain
        - dev1_only
        - script1
        - script2
