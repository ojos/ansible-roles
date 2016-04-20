http {
    default_type       {{ openresty_default_type }};
    sendfile           {{ openresty_sendfile }};
    keepalive_timeout  {{ openresty_keepalive_timeout }};
    resolver           {{ openresty_resolver }} valid={{ openresty_resolver_valid }};
    resolver_timeout   {{ openresty_resolver_timeout }};
    server_tokens      {{ openresty_server_tokens }};
    include            mime.types;
    # include            conf.d/http.lua.conf;
    include            conf.d/http.server.conf;
}