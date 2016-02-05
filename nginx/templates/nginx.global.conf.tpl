user  {{ nginx_user }} {{ nginx_group }};
worker_processes  {{ nginx_worker_processes }};
error_log  {{ nginx_error_log_file }};
pid  {{ nginx_pid_file }};
worker_rlimit_nofile  {{ nginx_worker_rlimit_nofile }};
events {
    worker_connections  {{ nginx_worker_connections }};
    multi_accept {{ nginx_multi_accept }};
}