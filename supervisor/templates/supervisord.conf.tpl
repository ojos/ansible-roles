[unix_http_server]
file={{ supervisor_unix_http_server_socket_directory }}/{{ supervisor_unix_http_server_socket_file_name }}
chmod=0777

[supervisord]
logfile={{ supervisor_log_directory }}/{{ supervisor_log_file_name }}
logfile_maxbytes={{ supervisor_log_file_maxbytes }}
logfile_backups={{ supervisor_log_file_backups }}
loglevel={{ supervisor_log_level }}
pidfile={{ supervisor_pid_directory }}/{{ supervisor_pid_file_name }}
nodaemon={{ supervisor_nodaemon }}
minfds={{ supervisor_minfds }}
minprocs={{ supervisor_minprocs }}
user=root

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix://{{ supervisor_unix_http_server_socket_directory }}/{{ supervisor_unix_http_server_socket_file_name }}

[include]
files = {{ supervisor_include_conf_directory }}/*.conf
