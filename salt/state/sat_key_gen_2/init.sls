# Assign lab or not-lab sat_server based on domain
{% if grains['domain'] == 'qic.tiaa-cref.org' %}
    {% set sat_server = 'rhelfinish::register_satellite6::lab_satellite_server' %}
{% else %}
    {% set sat_server = 'rhelfinish::register_satellite6::satellite_server' %}
{% endif %}

# Assign runscript based on environment (ct versus not ct)
{% if grains['tiaa_env'] == 'ct' %}
    {% set run_script = 'ct_sample.sh' %}
{% else %}
    {% set run_script = 'notct_sample.sh' %}
{% endif %}

# Generate activation keys by calling custom module 'tiaa_key.generate_activation_keys'
{% set activation_keys = salt['tiaa_key.generate_activation_keys']() %}


# Create /root/sat_key_gen_1 directory if not already present.
Ensure /root/sat_key_gen_1 directory is present:
  file.directory:
    - name: /root/sat_key_gen_1
    - user: root
    - group: root
    - dir_mode: 755

# Create /root/sat_key_gen_1/v1 directory if not already present.
Ensure /root/sat_key_gen_1/v1 directory is present:
  file.directory:
    - name: /root/sat_key_gen_1/v1

# Ensure re-reg-satellite6.sh is present on minion with correct register 
# command and exactly matching version saved on master.
Ensure re-reg-satellite6.sh is present on minion:
  file.managed:
    - name: /root/sat_key_gen_1/v1/re-reg-satellite6.sh
    - source: salt://state/sat_key_gen_1/files/re-reg-satellite6.sh
    - template: jinja
    - defaults:
      register_cmd: "/usr/sbin/subscription-manager register --org=TIAA {{ activation_keys }}"

# Ensure sample1.sh is present on mminion with correct activation keys, 
# sat_server, and random phrase... and exactly matching version saved 
# on master.
Ensure sample1.sh is present on minion:
  file.managed:
    - name: /root/sat_key_gen_1/v1/sample1.sh
    - source: salt://state/sat_key_gen_1/files/sample1.sh
    - template: jinja
    - defaults:
      activation_keys: {{ activation_keys }}
      sat_server: {{ sat_server }}
      random: "Hello TIAA"

# Run environment based runscript directly from master, do not store 
# on minion.
Run environment based runscript directly from master:
  cmd.script:
    - source: salt://state/sat_key_gen_1/files/{{run_script}}
