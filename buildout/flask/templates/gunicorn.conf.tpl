[program:flask-{{ project_name }}]
command={{ gunicorn_binary }} -c {{ gunicorn_conf_dir }}/{{ gunicorn_conf_file }} {{flask_gunicorn_command_option}} {{ flask_app_name }}
directory={{ flask_app_dir }}
user={{ gunicorn_user }}
autostart=true
autorestart=true
redirect_stderr=true
