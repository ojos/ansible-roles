"{{ project_directory }}/openresty/nginx/logs/access.log" "{{ project_directory }}/openresty/nginx/logs/error.log" {
  missingok
  notifempty
  daily
  rotate 7
  create 644 www-data root
  compress
  delaycompress
  notifempty
  sharedscripts
  postrotate
      [ ! -f {{ project_directory }}/openresty/nginx/logs/nginx.pid ] || kill -USR1 `cat {{ project_directory }}/openresty/nginx/logs/nginx.pid`
  endscript
}