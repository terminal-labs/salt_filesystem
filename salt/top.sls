#############################################################################################################
#  In the following example minions are assigned a salt grain named `roles`                                 #
#  which further contains a list of assigned roles related grains. I.e. in the minion config file:          #
#                                                                                                           #
#  grains:                                                                                                  #
#    roles:                                                                                                 #
#      - role_1                                                                                             #
#      - role_a                                                                                             #
#                                                                                                           #
#  1) Since all minions in the dev1 environment are assigned role_1, they                                   #
#  can be scoped using their grain role_1 or '*' which includes all minions                                 #
#  regardless of grains.                                                                                     #
#                                                                                                           #
#  2) Minions with role_a assigned in addition to role_1 will include maintsched.sls in their highstate.    #
#                                                                                                           #
#  3) Minions with role_b assigned in addition to role_1 will include sat_key_gen_1.sls in their highstate. #
############################################################################################################
dev1:
######
# 1) #
######
############################################
#    '*':                                  #
#        - state.nginx_running             #
#        - state.timekeeper.using_template #
############################################
    'roles:role_1':
        - match: grain
        - state.nginx_running
        - state.timekeeper.using_template
######
# 2) #
######
    'roles:role_a':
        - match: grain
        - state.maintsched
######
# 3) #
######
    'roles:role_b':
        - match: grain
        - state.sat_key_gen_1
