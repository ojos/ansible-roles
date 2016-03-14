http {
    default_type       {{ nginx_upload_default_type }};
    access_log         {{ nginx_upload_access_log_file }};
    sendfile           {{ nginx_upload_sendfile }};
    keepalive_timeout  {{ nginx_upload_keepalive_timeout }};
    resolver           {{ nginx_upload_resolver }} valid={{ nginx_upload_resolver_valid }};
    resolver_timeout   {{ nginx_upload_resolver_timeout }};
    server_tokens      {{ nginx_upload_server_tokens }};
    include            {{ nginx_upload_conf_prefix }}/mime.types;
    include            {{ nginx_upload_sub_conf_directory }}/http.server.conf;
}