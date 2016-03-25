#!/bin/bash
nginx-build -d {{ nginx_build_work_directory }} {{ nginx_build_openresty_configure_options }} {{ nginx_build_configure_options }}