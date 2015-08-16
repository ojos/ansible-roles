location ^~ /current_time {
    content_by_lua_file {{ openresty_nginx_conf_dir }}/lua/current_time.lua;
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