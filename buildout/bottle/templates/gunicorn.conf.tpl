[program:bottle-{{ project_name }}]
command={{ gunicorn_binary }} -c {{ gunicorn_conf_dir }}/{{ gunicorn_conf_file }} {{bottle_gunicorn_command_option}} {{ bottle_app_name }}
directory={{ bottle_app_dir }}
user={{ gunicorn_user }}
autostart=true
autorestart=true
redirect_stderr=true
