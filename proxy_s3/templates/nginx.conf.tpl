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

    server {
        listen       80;
        server_name  localhost;

        location / {
            rewrite_by_lua '
                local dir, file, param = string.match(ngx.var.request_uri, "(.*/)([^?]*)(%??.*)")
                if file == "" then
                    ngx.req.set_uri(dir .. "index.html", false)
                end
            ';

<!--             access_by_lua '
                auth_header = ngx.req.get_headers().authorization
                if not auth_header or auth_header == '' or not string.match(auth_header, '^[Bb]asic ') then
                    ngx.header['WWW-Authenticate'] = 'Restricted'
                    ngx.exit(ngx.HTTP_UNAUTHORIZED)
                end
            '; -->

            set_by_lua $orgn '
                local origin = ngx.req.get_headers()["origin"]
                if origin == nil then
                    origin = "*"
                end
                return origin
            ';

            set $s3_bucket "{{ proxy_s3_bucket }}.s3-ap-northeast-1.amazonaws.com";

            proxy_http_version     1.1;
            proxy_set_header       Host $s3_bucket;
            proxy_set_header       Authorization "";
            proxy_set_header       Cookie "";

            proxy_hide_header Access-Control-Allow-Methods;
            proxy_hide_header Access-Control-Allow-Origin;

            add_header Access-Control-Allow-Origin $orgn;
            add_header Access-Control-Allow-Methods "GET, OPTIONS";
            add_header Access-Control-Allow-Headers "Origin, Authorization, Accept";
            add_header Access-Control-Allow-Credentials true;

            resolver 8.8.8.8 valid=300s;
            resolver_timeout 10s;

            proxy_pass https://$s3_bucket;

            auth_basic "Restricted";
            auth_basic_user_file "{{ proxy_s3_htpassword }}";

            if ($request_method = OPTIONS ) {
                add_header Access-Control-Allow-Origin *;
                add_header Access-Control-Allow-Methods "GET, OPTIONS";
                add_header Access-Control-Allow-Headers "Origin, Authorization, Accept";
                add_header Access-Control-Allow-Credentials true;
                return 200;
            }
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}