[program:locust-slave]
command={{ locust_python_bin_directory }}/locust -H {{ locust_host }} -f {{ locust_directory }}/{{ locust_file_name }} --slave --master-host={{ locust_master_host }} --logfile {{ locust_log_directory }}/{{ locust_log_file_name }}
directory={{ locust_directory }}
user={{ locust_user }}
autostart=true
autorestart=true
redirect_stderr=true
