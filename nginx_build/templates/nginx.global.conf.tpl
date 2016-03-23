user  {{ nginx_build_user }};
worker_processes  {{ nginx_build_worker_processes }};
worker_rlimit_nofile  {{ nginx_build_worker_rlimit_nofile }};
events {
    worker_connections  {{ nginx_build_worker_connections }};
    multi_accept {{ nginx_build_multi_accept }};
}