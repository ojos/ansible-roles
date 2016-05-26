[program:kclpy]
environment=AWS_ACCESS_KEY_ID="{{ awsconfig_access_key_id }}",AWS_SECRET_KEY="{{ awsconfig_secret_access_key }}",PATH="{{ supervisord_python_bin_directory }}:%(ENV_PATH)s"
command={{ startup_command.stdout }}
directory={{ kcl_python_conf_directory }}
user={{ kcl_python_user }}
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile={{ kcl_python_log_directory }}/{{ kcl_python_log_file_name }}
