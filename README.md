# salt_filesystem
Simple Salt Filesytem with GitFS

## Master Config
`/etc/salt/master.d/fileserver.conf`:
```
#File: /etc/salt/master.d/fileserver.conf

fileserver_backend:
  - gitfs

gitfs_provider: pygit2
gitfs_update_interval: 10

gitfs_remotes:
  - https://github.com/terminal-labs/salt_filesystem.git:
    - base: main
    - root: salt
#    - privkey: /root/.ssh/id_rsa
#    - pubkey:  /root/.ssh/id_rsa.pub

  - https://github.com/saltstack-formulas/salt-formula.git:
    ########################################################
    # saltenv must be explicitly mapped to branches / tags #
    ########################################################
    - saltenv:
      - dev1:
        - ref: 'v1.11.0'
      - dev2:
        - ref: 'v0.57.0'
    ##############################################################
    # or explicitely make branch / tag available to all saltenvs #
    ##############################################################
#    - all_saltenvs: master
```
```
#File: /etc/salt/master.d/remote_pillar.conf

git_pillar_provider: pygit2
git_pillar_update_interval: 10

ext_pillar:
  - git:
    - main https://github.com/terminal-labs/salt_remotepillar.git:
      - root: pillar
#      - pubkey: rsa.pub
#      - privkey: rsa.pem
```

## Minion Config
`/etc/salt/minion.d/fileserver.conf`:
```
#File: /etc/salt/minion.d/fileserver.conf

id: rhel1
master:
  - 52.23.224.43
  - 75.101.181.163
saltenv: dev1
#pillarenv: main
lock_saltenv: True

grains:
  roles:
    - role_1
    - role_a
```


TOP FILE 
GRAINS.GET
