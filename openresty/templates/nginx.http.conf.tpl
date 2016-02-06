http {
    default_type       {{ openresty_nginx_default_type }};
    access_log         {{ openresty_nginx_access_log_file }};
    sendfile           {{ openresty_nginx_sendfile }};
    keepalive_timeout  {{ openresty_nginx_keepalive_timeout }};
    resolver           {{ nginx_resolver }} valid={{ nginx_resolver_valid }};
    resolver_timeout   {{ nginx_resolver_timeout }};
    server_tokens      {{ openresty_nginx_server_tokens }};
    include            {{ openresty_nginx_conf_prefix }}/mime.types;
    include            {{ openresty_nginx_sub_conf_directory }}/http.lua.conf;
    include            {{ openresty_nginx_sub_conf_directory }}/http.server.conf;
}