################################################
# Set Jinja variable system_time equal to the  #
# system's current UTC time                    #
################################################
{% set system_time = salt['system.get_system_date_time']() %}

#################################################################
# This will place the file with the given content onto the      #
# minion's filesystem but only if it is not already there. If a #
# file with the same name is present, it will not be replaced,  #
# even if there have been changes. Note: `replace: False`.      #
#################################################################
Ensure_update_file_is_present_with_original_time:
  file.managed:
    - name: /root/update_record_2.txt
    - contents:
      - '######################################'
      - '# Last update on {{ system_time }} #'
      - '######################################'
      - '##########################################'
      - '# Original update on {{ system_time }} #'
      - '##########################################'
    - replace: False

#########################################################
# The second line in the file will be replaced with the #
# current system time each time the salt state is run   #
# because it matches the qualiying pattern given. Since #
# the count is set to 1 it will only replace the first  #
# instance of the pattern.                              #
#########################################################
Ensure_update_time_is_replaced_and_original_time_stays:
  file.replace:
    - name: /root/update_record_2.txt
    - pattern: "# .* #"
    - repl: "# Last update on {{ system_time }} #"
    - count: 1
    - backup: False
    - onlyif: 
      - 'ls /root/update_record_2.txt'
