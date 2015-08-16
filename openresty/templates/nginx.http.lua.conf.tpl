lua_package_path        '{{ openresty_nginx_conf_dir }}/lua/?.lua;;';
lua_check_client_abort  {{ openresty_nginx_lua_check_client_abort }};
lua_code_cache          {{ openresty_nginx_lua_code_cache }};