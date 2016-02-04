user  {{ openresty_user }};
worker_processes  {{ openresty_nginx_worker_processes }};
error_log  {{ openresty_nginx_error_log_file }};
pid  {{ openresty_nginx_pid_file }};
worker_rlimit_nofile  {{ openresty_nginx_worker_rlimit_nofile }};
events {
    worker_connections  {{ openresty_nginx_worker_connections }};
    multi_accept {{ openresty_nginx_multi_accept }};
}