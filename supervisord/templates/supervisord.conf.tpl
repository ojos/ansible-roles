[unix_http_server]
file={{supervisord_unix_http_server_socket_dir}}/{{ supervisord_unix_http_server_socket_file }}
chmod=0777

[supervisord]
logfile={{ supervisord_log_dir }}/{{ supervisord_log_file }}
logfile_maxbytes={{ supervisord_log_file_maxbytes }}
logfile_backups={{ supervisord_log_file_backups }}
loglevel={{ supervisord_log_level }}
pidfile={{ supervisord_pid_dir }}/{{ supervisord_pid_file }}
nodaemon={{ supervisord_nodaemon }}
minfds={{ supervisord_minfds }}
minprocs={{ supervisord_minprocs }}
user={{ supervisord_user }}

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix://{{ supervisord_unix_http_server_socket_file }}

[include]
files = {{ supervisord_include_conf_dir }}/*.conf
