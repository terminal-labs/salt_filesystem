# Make nginx repo provision to allow install
Ensure_update_file_is_present_with_original_time:
  file.managed:
    - name: /etc/yum.repos.d/nginx.repo
    - contents:
      - '[nginx]'
      - 'name=nginx repo'
      - 'baseurl=http://nginx.org/packages/mainline/rhel/7/$basearch/'
      - 'gpgcheck=0'
      - 'enabled=1'

# Ensure nginx is installed. Update 
# if new packages available
Ensure_nginx_installed:
  pkg.installed:
    - pkgs:
      - nginx  

# Ensure nginx config file is in correct state
nginx_config_file:
  file.managed:
    - name: /etc/nginx/conf.d/basic.conf
    - source: salt://state/nginx_running/files/basic.conf

# nginx.service has reload feature so 
# reload: True can be used to reload after 
# config file changes versus restarting.
Restart_nginx_if_conf_file_changes:
  service.running:
    - name: nginx
    - reload: True
    - enable: True 
    - watch:
        - file: /etc/nginx/conf.d/basic.conf

