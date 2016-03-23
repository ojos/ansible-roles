http {
    default_type       {{ nginx_build_default_type }};
    sendfile           {{ nginx_build_sendfile }};
    keepalive_timeout  {{ nginx_build_keepalive_timeout }};
    resolver           {{ nginx_build_resolver }} valid={{ nginx_build_resolver_valid }};
    resolver_timeout   {{ nginx_build_resolver_timeout }};
    server_tokens      {{ nginx_build_server_tokens }};
    include            {{ conf_dir.stdout }}/mime.types;
    # include            {{ conf_dir.stdout }}/conf.d/http.lua.conf;
    include            {{ conf_dir.stdout }}/conf.d/http.server.conf;
}