[program:locust-slave]
command={{ locust_python_bin_directory }}/locust -H {{ locust_host }} --slave --master-host={{ locust_master_host }}
directory={{ locust_directory }}
user={{ locust_user }}
autostart=true
autorestart=true
redirect_stderr=true
