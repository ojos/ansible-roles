[program:kcl_py]
command={{ startup_command.stdout }}
directory={{ project_directory }}
user={{ kcl_python_user }}
autostart=true
autorestart=true
redirect_stderr=true
