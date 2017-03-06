CELERYD_NODES="{{ celery_nodes }}"
CELERY_BIN="{{ celery_bin_file }}"
CELERY_APP="{{ celery_app }}"
CELERYD_CHDIR="{{ celery_change_directory }}"
CELERYD_OPTS="{{ celery_options|join(' ') }}"
CELERYD_LOG_FILE="{{ celery_log_directory }}/{{ celery_log_file }}"
CELERYD_PID_FILE="{{ celery_pid_directory }}/{{ celery_pid_file }}"
CELERYD_USER="{{ celery_user }}"
CELERYD_GROUP="{{ celery_group }}"
CELERY_CREATE_DIRS=1
