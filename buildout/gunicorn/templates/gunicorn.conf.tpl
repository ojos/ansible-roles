# -*- coding: utf-8 -*-
import multiprocessing

bind = '{{ gunicorn_bind }}'
backlog = {{ gunicorn_backlog }}
workers = {{ gunicorn_workers }}
worker_class = '{{ gunicorn_worker_class }}'
threads = {{ gunicorn_threads }}
worker_connections = {{ gunicorn_worker_connections }}
max_requests = {{ gunicorn_max_requests }}
max_requests_jitter = {{ gunicorn_max_requests_jitter }}
timeout = {{ gunicorn_timeout }}
graceful_timeout = {{ gunicorn_graceful_timeout }}
keepalive = {{ gunicorn_keepalive }}
limit_request_line = {{ gunicorn_limit_request_line }}
limit_request_fields = {{ gunicorn_limit_request_fields }}
limit_request_field_size = {{ gunicorn_limit_request_field_size }}
debug = {{ gunicorn_debug }}
reload = {{ gunicorn_reload }}
spew = {{ gunicorn_spew }}
check_config = {{ gunicorn_check_config }}
preload_app = {{ gunicorn_preload_app }}
daemon = {{ gunicorn_daemon }}
raw_env = {{ gunicorn_raw_env }}
pidfile = '{{ gunicorn_pid_dir }}/{{ gunicorn_pid_file }}'
worker_tmp_dir = {{ gunicorn_worker_tmp_dir }}
user = '{{ gunicorn_user }}'
group = '{{ gunicorn_group }}'
umask = {{ gunicorn_umask }}
tmp_upload_dir = {{ gunicorn_tmp_upload_dir }}
#secure_scheme_headers = {{ gunicorn_secure_scheme_headers }}
accesslog = '{{ gunicorn_log_dir }}/{{ gunicorn_accesslog }}'
access_log_format = '{{ gunicorn_access_log_format }}'
errorlog = '{{ gunicorn_log_dir }}/{{ gunicorn_errorlog }}'
loglevel = '{{ gunicorn_loglevel }}'
logger_class = '{{ gunicorn_logger_class }}'
# logconfig = {{ gunicorn_logconfig }}
# syslog_addr = '{{ gunicorn_syslog_addr }}'
# syslog = {{ gunicorn_syslog }}
# syslog_prefix = {{ gunicorn_syslog_prefix }}
# syslog_facility = '{{ gunicorn_syslog_facility }}'
# enable_stdio_inheritance = {{ gunicorn_enable_stdio_inheritance }}
proc_name = '{{ gunicorn_proc_name }}'


def post_fork(server, worker):
    server.log.info("Worker spawned (pid: %s)", worker.pid)

def pre_fork(server, worker):
    pass

def pre_exec(server):
    server.log.info("Forked child, re-executing.")

def when_ready(server):
    server.log.info("Server is ready. Spwawning workers")
