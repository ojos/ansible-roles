[program:kcl_py]
command={{ startup_command.stdout }}
directory={{ kcl_python_conf_directory }}
user={{ kcl_python_user }}
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile={{ kcl_python_log_directory }}/{{ kcl_python_log_file_name }}
