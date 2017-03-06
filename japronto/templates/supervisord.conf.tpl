[program:japronto]
command={{ japronto_python_bin_directory }}/python {{ japronto_directory }}/{{ japronto_app }}/{{ japronto_app_file_name }}
directory={{ japronto_directory }}/{{ japronto_app }}
user={{ japronto_user }}
autostart=true
autorestart=true
redirect_stderr=true
