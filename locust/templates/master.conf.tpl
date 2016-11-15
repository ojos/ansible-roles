[program:locust-master]
command={{ locust_python_bin_directory }}/locust -f {{ locust_directory }}/{{ locust_file_name }} -H {{ locust_host }} --master --logfile {{ locust_log_directory }}/{{ locust_log_file_name }}
directory={{ locust_directory }}
user={{ locust_user }}
autostart=true
autorestart=true
redirect_stderr=true