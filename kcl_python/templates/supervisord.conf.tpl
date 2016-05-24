[program:kcl_py]
command={{ startup_command.stdout }}
directory={{ kcl_python_directory }}
user={{ kcl_python_user }}
autostart=true
autorestart=true
redirect_stderr=true
