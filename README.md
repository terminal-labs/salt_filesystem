# Sample Salt filesystem architecture with custom states and modules. 
All custom modules and salt state files have been annotated with explainations and insights. `state/sat_key_gen_1/` and `state/sat_key_gen_2/` modules do the same exact thing. `state/sat_key_gen_2/` is the preferred route because overly cumbersome jinja logic is outsourced to custom module `_modules/tiaa_key.py` using pythin instead.

## Master Config Settings
### The following master configurations were applied in `/etc/salt/master.d/fileserver.conf`  and `/etc/salt/master.d/remote_pillar.conf` for GitFS fileserver and remote pillar deployment.

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
`/etc/salt/master.d/remote_pillar.conf`:
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

### The following minion configurations were applied in `/etc/salt/minion.d/fileserver.conf` to link each minion to active-active master pairs, specified locked salt environments and customs roles based grains.
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
