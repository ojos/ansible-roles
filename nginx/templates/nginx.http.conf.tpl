http {
    default_type       {{ nginx_default_type }};
    access_log         {{ nginx_access_log_file }};
    sendfile           {{ nginx_sendfile }};
    keepalive_timeout  {{ nginx_keepalive_timeout }};
    resolver           {{ nginx_resolver }} valid={{ nginx_resolver_valid }};
    resolver_timeout   {{ nginx_resolver_timeout }};
    server_tokens      {{ nginx_server_tokens }};
    include            {{ nginx_conf_prefix }}/mime.types;
    include            {{ nginx_sub_conf_directory }}/http.server.conf;
}