[unix_http_server]
file={{supervisord_unix_http_server_socket_directory}}/{{ supervisord_unix_http_server_socket_file_name }}
chmod=0777

[supervisord]
logfile={{ supervisord_log_directory }}/{{ supervisord_log_file_name }}
logfile_maxbytes={{ supervisord_log_file_maxbytes }}
logfile_backups={{ supervisord_log_file_backups }}
loglevel={{ supervisord_log_level }}
pidfile={{ supervisord_pid_directory }}/{{ supervisord_pid_file_name }}
nodaemon={{ supervisord_nodaemon }}
minfds={{ supervisord_minfds }}
minprocs={{ supervisord_minprocs }}
user={{ supervisord_user }}

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix://{{ supervisord_unix_http_server_socket_file_name }}

[include]
files = {{ supervisord_include_conf_directory }}/*.conf
