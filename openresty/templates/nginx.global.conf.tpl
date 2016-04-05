worker_processes  {{ openresty_worker_processes }};
worker_rlimit_nofile  {{ openresty_worker_rlimit_nofile }};
events {
    worker_connections  {{ openresty_worker_connections }};
    multi_accept {{ openresty_multi_accept }};
}