[program:kclpy]
environment=AWS_ACCESS_KEY_ID="{{ awsconfig_access_key_id }}",AWS_SECRET_KEY="{{ awsconfig_secret_access_key }}",PATH="{{ supervisord_python_bin_directory }}:%(ENV_PATH)s"
command={{ java_path }} -jar ./{{ kclpy_executable_jar_file_name }} --config=./{{ kclpy_properties_file_name }}
directory={{ kclpy_conf_directory }}
user={{ kclpy_user }}
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile={{ kclpy_log_directory }}/{{ kclpy_log_file_name }}
