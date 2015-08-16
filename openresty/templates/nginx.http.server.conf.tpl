server {
    listen       80;
    server_name  localhost;

    error_page   404              /404.html;
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

    include {{ openresty_nginx_sub_conf_dir }}/http.server.location.conf;
}