server {
    listen       80;
    client_max_body_size {{ nginx_build_client_max_body_size }};
    server_name  localhost;

    error_page   404              /404.html;
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

    # location ^~ /current_time {
    #     content_by_lua_file {{ conf_dir.stdout }}/lua/current_time.lua;
    # }

    location ^~ /favicon {
        empty_gif;
        access_log    off;
        log_not_found off;
    }

    location / {
        root   html;
        index  index.html index.htm;
    }
}