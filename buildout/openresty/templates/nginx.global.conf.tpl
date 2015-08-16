user  {{ openresty_nginx_user }};
worker_processes  {{ openresty_nginx_worker_processes }};
error_log  {{ openresty_nginx_error_log_file }};
pid  {{ openresty_nginx_pid_file }};
events {
    worker_connections  {{ openresty_nginx_worker_connections }};
    use epoll;
    multi_accept {{ openresty_nginx_multi_accept }};
}