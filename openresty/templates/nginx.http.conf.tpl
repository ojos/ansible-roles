http {
    default_type       {{ openresty_default_type }};
    sendfile           {{ openresty_sendfile }};
    keepalive_timeout  {{ openresty_keepalive_timeout }};
    resolver           {{ openresty_resolver }} valid={{ openresty_resolver_valid }};
    resolver_timeout   {{ openresty_resolver_timeout }};
    server_tokens      {{ openresty_server_tokens }};
    include            {{ nginx_home_dir.stdout }}/conf/mime.types;
    # include            {{ nginx_home_dir.stdout }}/conf/conf.d/http.lua.conf;
    include            {{ nginx_home_dir.stdout }}/conf/conf.d/http.server.conf;
}