lua_package_path        '{{ nginx_home_dir.stdout }}/lua/?.lua;;';
lua_check_client_abort  {{ openresty_lua_check_client_abort }};
lua_code_cache          {{ openresty_lua_code_cache }};