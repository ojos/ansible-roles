#!/bin/bash
export PATH={{ nginx_build_bin_directory }}:{{ nginx_build_gopath_directory }}/bin:{{ ansible_env.PATH }}
export GOROOT={{ project_directory }}/go
export GOPATH={{ project_directory }}/gopath
nginx-build -d {{ nginx_build_work_directory }} {{ nginx_build_openresty_configure_options }} {{ nginx_build_configure_options }}