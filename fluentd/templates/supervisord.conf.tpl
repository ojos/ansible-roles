[program:fluentd]
command={{ fluentd_ruby_bin_directory }}/fluentd -c {{ fluentd_directory }}/{{ fluentd_conf_file_name }}
directory={{ fluentd_directory }}
user={{ fluentd_user }}
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile={{ fluentd_log_directory }}/{{ fluentd_log_file_name }}