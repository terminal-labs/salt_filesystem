main:
    '*':
        - foo
        
    'roles:database':
        - match: grain
        - dev1_only
        - script1
        - script2
