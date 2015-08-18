[program:gunicorn]
command={{ gunicorn_binary }} -c {{ gunicorn_conf_dir }}/{{ gunicorn_conf_file }} {{django_gunicorn_command_option}} {{ django_app_name }}
directory={{ django_app_dir }}
user={{ gunicorn_user }}
autostart=true
autorestart=true
redirect_stderr=true
