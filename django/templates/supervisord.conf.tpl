[program:gunicorn-django]
command={{ django_python_bin_directory }}/gunicorn -c {{ xbuild_gunicorn_conf_directory }}/{{ xbuild_gunicorn_conf_file_name }} {{ django_app_name }}.wsgi
directory={{ django_directory }}/{{ django_project }}
user={{ xbuild_gunicorn_user }}
autostart=true
autorestart=true
redirect_stderr=true
