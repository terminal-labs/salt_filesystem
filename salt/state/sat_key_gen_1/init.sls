############################################################
# This method is not preferred over `sat_key_gen_2.sls`    #
# since all of the logic is coded in jinja which is        #
# quite cumborsome and overly complex.                                       #
############################################################

#####################################################
# Assign lab or not-lab sat_server based on domain  #
#####################################################
{% if grains['domain'] == 'qic.tiaa-cref.org' %}
    {% set sat_server = 'rhelfinish::register_satellite6::lab_satellite_server' %}
{% else %}
    {% set sat_server = 'rhelfinish::register_satellite6::satellite_server' %}
{% endif %}

####################################################################
# Assign runscript based on environment (ct versus not ct)         #
# salt['grains.get']('tiaa_env') is better than grains['tiaa_env'] #
# in this case since there is a possibility of a value of None     #
# if the grain has not been assigned.                              #
####################################################################
{% if salt['grains.get']('tiaa_env') == 'ct' %}
    {% set run_script = 'ct_sample.sh' %}
{% else %}
    {% set run_script = 'notct_sample.sh' %}
{% endif %}

###############################
# Set activation key defaults #
###############################
{% set loc_activation_key = namespace(value='1-loc_Unknown') %}
{% set env_activation_key = namespace(value='1-env_Unknown') %}
{% set site_activation_key = namespace(value='1-site_UNKNOWN') %}
{% set tier_activation_key = namespace(value='1-tier_UNKNOWN') %}

##################################
# Map tiaa_loc to activation key #
##################################
{% set activation_key_map = {
    '1-loc_Charlotte': 'cha', 
    '1-loc_Denver': 'den',
    'loc_Amazon_East': 'awe',
    'loc_Amazon_West': 'aww'} %}
###############################################
# Update default activation key with tiaa_loc #
###############################################
{% for activation_key, tiaa_grain in activation_key_map.items() %}
    {% if salt['grains.get']('tiaa_dc') in tiaa_grain %}
        {% set loc_activation_key.value = activation_key %}
    {% endif %}
{% endfor %}

##################################
# Map tiaa_env to activation key #
##################################
{% set activation_key_map = {
    '1-env_PD': 'pd', 
    '1-env_DR': 'dr', 
    '1-env_PF': 'pf',
    '1-env_CT': 'ct', 
    '1-env_TS': 'ts', 
    '1-env_AT1': ['at', 'at1', 'ab'], 
    '1-env_DV': ['dv', 'd1', 'd2', 'd3', 'd4', 'd5'], 
    '1-env_IT1': ['it', 'i1']}  %}
###############################################
# Update default activation key with tiaa_env #
###############################################
{% for activation_key, tiaa_grain in activation_key_map.items() %}
    {% if salt['grains.get']('tiaa_env') in tiaa_grain %}
        {% set env_activation_key.value = activation_key %}
    {% endif %}
{% endfor %}

###################################
# Map tiaa_site to activation key #
###################################
{% set activation_key_map = {
    '1-site_A': 'a', 
    '1-site_B': 'b', 
    '1-site_C': 'c',
    '1-site_D': 'd', 
    '1-site_E': 'e'}  %}
###############################################
# Update default activation key with tiaa_env #
###############################################
{% for activation_key, tiaa_grain in activation_key_map.items() %}
    {% if salt['grains.get']('tiaa_site') in tiaa_grain %}
        {% set site_activation_key.value = activation_key %}
    {% endif %}
{% endfor %}

###################################
# Map tiaa_tier to activation key #
###################################
{% set activation_key_map = {
    '1-tier_1': '1', 
    '1-tier_2': '2', 
    '1-tier_3': '3',
    '1-tier_IS': 'i'}  %}
###############################################
# Update default activation key with tiaa_env #
###############################################
{% for activation_key, tiaa_grain in activation_key_map.items() %}
    {% if salt['grains.get']('tiaa_tier') in tiaa_grain %}
        {% set tier_activation_key.value = activation_key %}
    {% endif %}
{% endfor %}

################################################
# Generate string of keys separated by spaces  #
################################################
{% set activation_keys = [
    loc_activation_key.value,
    env_activation_key.value,
    site_activation_key.value,
    tier_activation_key.value
    ]|join(" ") %}
    
################################################################
# Create /root/sat_key_gen_1 directory if not already present  #
################################################################
Ensure /root/sat_key_gen_1 directory is present:
  file.directory:
    - name: /root/sat_key_gen_1
    - user: root
    - group: root
    - dir_mode: 755

###################################################################
# Create /root/sat_key_gen_1/v1 directory if not already present  #
###################################################################
Ensure /root/sat_key_gen_1/v1 directory is present:
  file.directory:
    - name: /root/sat_key_gen_1/v1

##################################################################
# Ensure re-reg-satellite6.sh is present on minion with correct  #
# register command and exactly matching original saved on master #
##################################################################
Ensure re-reg-satellite6.sh is present on minion:
  file.managed:
    - name: /root/sat_key_gen_1/v1/re-reg-satellite6.sh
    - source: salt://state/sat_key_gen_1/files/re-reg-satellite6.sh
    - template: jinja
    - defaults:
      register_cmd: "/usr/sbin/subscription-manager register --org=TIAA {{ activation_keys }}"

########################################################################
# Ensure sample1.sh is present on minion with correct activation keys, #
# sat_server, and random phrase... and exactly matching original saved #
# on master.                                                           #
########################################################################
Ensure sample1.sh is present on minion:
  file.managed:
    - name: /root/sat_key_gen_1/v1/sample1.sh
    - source: salt://state/sat_key_gen_1/files/sample1.sh
    - template: jinja
    - defaults:
      activation_keys: {{ activation_keys }}
      sat_server: {{ sat_server }}
      random: "Hello TIAA"

######################################################################
# Run environment based runscript directly from master, do not store #
# on minion.                                                         #
######################################################################
Run environment based runscript directly from master:
  cmd.script:
    - source: salt://state/sat_key_gen_1/files/{{run_script}}
    