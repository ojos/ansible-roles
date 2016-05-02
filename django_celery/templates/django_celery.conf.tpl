[program:django-celery-worker]
command={{ django_celery_python_bin_directory }}/celery -A {{ django_app_name }} worker --pool={{ django_celery_worker_pool_class }} --autoscale={{ django_celery_worker_autoscale }} --pidfile={{ django_celery_pid_directory }}/{{ django_celery_worker_pid_file_name }} --logfile={{ django_celery_log_directory }}/{{ django_celery_worker_log_file_name }}
directory={{ django_directory }}/{{ django_project }}
user={{ django_celery_user }}
autostart=true
autorestart=true
redirect_stderr=true

; [program:django-celery-beat]
; command={{ django_celery_python_bin_directory }}/celery -A {{ django_app_name }} beat --pidfile={{ django_celery_pid_directory }}/{{ django_celery_beat_pid_file_name }} --logfile={{ django_celery_log_directory }}/{{ django_celery_beat_log_file_name }}
; directory={{ django_directory }}/{{ django_project }}
; user={{ django_celery_user }}
; autostart=true
; autorestart=true
; redirect_stderr=true
