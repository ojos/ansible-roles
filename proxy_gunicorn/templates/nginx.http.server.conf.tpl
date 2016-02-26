upstream app_server {
    server {{ gunicorn_bind }} fail_timeout=0;
}

server {
    listen       80;
    client_max_body_size {{ proxy_gunicorn_nginx_client_max_body_size }};
    server_name  localhost;

    error_page   404              /404.html;
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

    # path for static files
    root {{ proxy_gunicorn_static_dir }};

    location / {
        try_files $uri @proxy_to_app;
        break;
    }

    location @proxy_to_app {
        set $redirect "";
        if ($http_x_forwarded_proto != "https") {
            set $redirect "1";
        }
        if ($http_user_agent !~* ELB-HealthChecker) {
            set $redirect "${redirect}1";
        }
        if ($http_host ~ "{{ proxy_gunicorn_redirect_https_host }}") {
            set $redirect "${redirect}1";
        }
        if ($redirect = "111") {
            rewrite ^ https://$host$request_uri? permanent;
        }

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;

        proxy_pass   http://app_server;
    }
}