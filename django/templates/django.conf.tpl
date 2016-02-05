[program:gunicorn-django]
command={{ gunicorn_python_bin_directory }}/gunicorn -c {{ gunicorn_conf_directory }}/{{ gunicorn_conf_file_name }} {{ django_app_name }}
directory={{ django_directory }}/{{ django_project }}
user={{ gunicorn_user }}
autostart=true
autorestart=true
redirect_stderr=true
