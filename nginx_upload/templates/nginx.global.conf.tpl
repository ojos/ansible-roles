user  {{ nginx_upload_user }} {{ nginx_upload_group }};
worker_processes  {{ nginx_upload_worker_processes }};
error_log  {{ nginx_upload_error_log_file }};
pid  {{ nginx_upload_pid_file }};
worker_rlimit_nofile  {{ nginx_upload_worker_rlimit_nofile }};
events {
    worker_connections  {{ nginx_upload_worker_connections }};
    multi_accept {{ nginx_upload_multi_accept }};
}