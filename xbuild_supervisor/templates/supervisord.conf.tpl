[unix_http_server]
file={{xbuild_supervisor_unix_http_server_socket_directory}}/{{ xbuild_supervisor_unix_http_server_socket_file_name }}
chmod=0777

[supervisord]
logfile={{ xbuild_supervisor_log_directory }}/{{ xbuild_supervisor_log_file_name }}
logfile_maxbytes={{ xbuild_supervisor_log_file_maxbytes }}
logfile_backups={{ xbuild_supervisor_log_file_backups }}
loglevel={{ xbuild_supervisor_log_level }}
pidfile={{ xbuild_supervisor_pid_directory }}/{{ xbuild_supervisor_pid_file_name }}
nodaemon={{ xbuild_supervisor_nodaemon }}
minfds={{ xbuild_supervisor_minfds }}
minprocs={{ xbuild_supervisor_minprocs }}
user={{ xbuild_supervisor_user }}

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix://{{xbuild_supervisor_unix_http_server_socket_directory}}/{{ xbuild_supervisor_unix_http_server_socket_file_name }}

[include]
files = {{ xbuild_supervisor_include_conf_directory }}/*.conf
