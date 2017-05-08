[program:fluentd]
command={{ fluentd_ruby_bin_directory }}/fluentd -c {{ fluentd_conf_directory }}/{{ fluentd_conf_file_name }}
directory={{ project_directory }}
user={{ fluentd_user }}
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile={{ fluentd_log_directory }}/{{ fluentd_log_file_name }}
stdout_logfile_maxbytes={{ fluentd_log_file_maxbytes }}
stdout_logfile_backups={{ fluentd_log_file_backups }}
stdout_capture_maxbytes={{ fluentd_log_file_maxbytes }}