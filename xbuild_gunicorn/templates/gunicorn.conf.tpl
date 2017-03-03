# -*- coding: utf-8 -*-
import multiprocessing

bind = '{{ xbuild_gunicorn_bind }}'
backlog = {{ xbuild_gunicorn_backlog }}
workers = {{ xbuild_gunicorn_workers }}
worker_class = '{{ xbuild_gunicorn_worker_class }}'
threads = {{ xbuild_gunicorn_threads }}
worker_connections = {{ xbuild_gunicorn_worker_connections }}
max_requests = {{ xbuild_gunicorn_max_requests }}
max_requests_jitter = {{ xbuild_gunicorn_max_requests_jitter }}
timeout = {{ xbuild_gunicorn_timeout }}
graceful_timeout = {{ xbuild_gunicorn_graceful_timeout }}
keepalive = {{ xbuild_gunicorn_keepalive }}
limit_request_line = {{ xbuild_gunicorn_limit_request_line }}
limit_request_fields = {{ xbuild_gunicorn_limit_request_fields }}
limit_request_field_size = {{ xbuild_gunicorn_limit_request_field_size }}
debug = {{ xbuild_gunicorn_debug }}
reload = {{ xbuild_gunicorn_reload }}
spew = {{ xbuild_gunicorn_spew }}
check_config = {{ xbuild_gunicorn_check_config }}
preload_app = {{ xbuild_gunicorn_preload_app }}
daemon = {{ xbuild_gunicorn_daemon }}
raw_env = {{ xbuild_gunicorn_raw_env }}
pidfile = '{{ xbuild_gunicorn_pid_directory }}/{{ xbuild_gunicorn_pid_file }}'
worker_tmp_dir = {{ xbuild_gunicorn_worker_tmp_directory }}
user = '{{ xbuild_gunicorn_user }}'
group = '{{ xbuild_gunicorn_group }}'
umask = {{ xbuild_gunicorn_umask }}
tmp_upload_dir = {{ xbuild_gunicorn_tmp_upload_directory }}
#secure_scheme_headers = {{ xbuild_gunicorn_secure_scheme_headers }}
accesslog = '{{ xbuild_gunicorn_log_directory }}/{{ xbuild_gunicorn_accesslog }}'
access_log_format = '{{ xbuild_gunicorn_access_log_format }}'
errorlog = '{{ xbuild_gunicorn_log_directory }}/{{ xbuild_gunicorn_errorlog }}'
loglevel = '{{ xbuild_gunicorn_loglevel }}'
logger_class = '{{ xbuild_gunicorn_logger_class }}'
# logconfig = {{ xbuild_gunicorn_logconfig }}
# syslog_addr = '{{ xbuild_gunicorn_syslog_addr }}'
# syslog = {{ xbuild_gunicorn_syslog }}
# syslog_prefix = {{ xbuild_gunicorn_syslog_prefix }}
# syslog_facility = '{{ xbuild_gunicorn_syslog_facility }}'
# enable_stdio_inheritance = {{ xbuild_gunicorn_enable_stdio_inheritance }}
proc_name = '{{ xbuild_gunicorn_proc_name }}'


def post_fork(server, worker):
    server.log.info("Worker spawned (pid: %s)", worker.pid)

def pre_fork(server, worker):
    pass

def pre_exec(server):
    server.log.info("Forked child, re-executing.")

def when_ready(server):
    server.log.info("Server is ready. Spwawning workers")
