#!/bin/sh
exec ssh -oIdentityFile={{ project_private_key }} "$@"