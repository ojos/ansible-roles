server {
    listen       80;
    client_max_body_size {{ nginx_upload_client_max_body_size }};
    server_name  localhost;

    error_page   404              /404.html;
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

    location ^~ /favicon {
        empty_gif;
        access_log    off;
        log_not_found off;
    }

    location / {
        default_type text/html;
        content_by_lua 'ngx.say("<h1>It\'s, Work!!</h1>")';
    }
}