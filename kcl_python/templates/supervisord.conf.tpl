[kclpy]
environment=AWS_ACCESS_KEY_ID="{{ awsconfig_access_key_id }}",AWS_SECRET_KEY="{{ awsconfig_secret_access_key }}"
command=`amazon_kclpy_helper.py --print_command --java {{ java_path.stdout }} --properties {{ kcl_python_properties_file_name }}`
directory={{ kcl_python_conf_directory }}
user={{ kcl_python_user }}
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile={{ kcl_python_log_directory }}/{{ kcl_python_log_file_name }}
stdout_logfile_maxbytes={{ kcl_python_log_file_maxbytes }}
stdout_logfile_backups={{ kcl_python_log_file_backups }}
stdout_capture_maxbytes={{ kcl_python_log_file_maxbytes }}
