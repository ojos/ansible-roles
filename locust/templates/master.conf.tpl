[program:locust-master]
command={{ locust_python_bin_directory }}/locust -H {{ locust_host }} --master
directory={{ locust_directory }}
user={{ locust_user }}
autostart=true
autorestart=true
redirect_stderr=true