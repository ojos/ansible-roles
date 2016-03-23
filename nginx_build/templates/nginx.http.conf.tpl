http {
    default_type       {{ nginx_build_default_type }};
    sendfile           {{ nginx_build_sendfile }};
    keepalive_timeout  {{ nginx_build_keepalive_timeout }};
    resolver           {{ nginx_build_resolver }} valid={{ nginx_build_resolver_valid }};
    resolver_timeout   {{ nginx_build_resolver_timeout }};
    server_tokens      {{ nginx_build_server_tokens }};
    include            {{ nginx_home_dir.stdout }}/conf/mime.types;
    # include            {{ nginx_home_dir.stdout }}/conf/conf.d/http.lua.conf;
    include            {{ nginx_home_dir.stdout }}/conf/conf.d/http.server.conf;
}