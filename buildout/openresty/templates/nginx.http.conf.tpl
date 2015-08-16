http {
    default_type       {{ openresty_nginx_default_type }};
    access_log         {{ openresty_nginx_access_log_file }};
    sendfile           {{ openresty_nginx_sendfile }};
    keepalive_timeout  {{ openresty_nginx_keepalive_timeout }};
    resolver           {{ openresty_nginx_resolver }};
    server_tokens      {{ openresty_nginx_server_tokens }};
    include            {{ openresty_nginx_conf_dir }}/mime.types;
    include            {{ openresty_nginx_sub_conf_dir }}/http.lua.conf;
    include            {{ openresty_nginx_sub_conf_dir }}/http.server.conf;
}