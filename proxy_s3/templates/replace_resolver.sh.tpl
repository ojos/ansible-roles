#!/bin/sh
resolver=`cat {{ proxy_s3_resolv_file }} | grep nameserver | awk '{print substr($0, 12)}'` &&\
if [ -n "$resolver" ]; then sed -i -e "s/{{ proxy_s3_resolver_ip }}/$resolver/g" {{ openresty_nginx_conf_dir }}/nginx.conf ;fi
