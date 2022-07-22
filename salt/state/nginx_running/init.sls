# Ensure nginx is installed. Update 
# if new packages available
Ensure_nginx_installed:
  pkg.installed:
    - pkgs:
      - nginx  

# nginx.service has reload feature so 
# reload: True can be used to reload after 
# config file changes versus restarting.
Restart_nginx_if_conf_file_changes:
  service.running:
    - name: nginx
#    - reload: True
    - enable: True 
    - watch:
        - file: /etc/nginx/nginx.conf 

