worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    lua_package_path        '/etc/nginx/lua/?.lua;;';
    lua_check_client_abort  on;
    lua_code_cache          on;

    upstream app_server {
        server 0.0.0.0:8000;
    }

    server {
        listen 80 default;
        client_max_body_size 4G;
        server_name  localhost;

        keepalive_timeout 5;

        # path for static files
        root {{ proxy_gunicorn_static_dir }};

        location / {
            try_files $uri @proxy_to_app;
            break;
        }

        location @proxy_to_app {
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_redirect off;

            proxy_pass   http://app_server;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}