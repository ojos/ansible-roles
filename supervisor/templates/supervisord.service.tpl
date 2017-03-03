#!/bin/sh
#
# Startup script for the Supervisor server
#
# chkconfig: 2345 85 15
# description: Supervisor is a client/server system that allows its users to \
#              monitor and control a number of processes on UNIX-like \
#              operating systems.
#
# processname: supervisord
# pidfile: {{ supervisor_pid_directory }}/{{ supervisor_pid_file_name }}

# Source function library.
. /etc/rc.d/init.d/functions

DESC="Supervisord Daemon"
DAEMON={{ supervisor_bin_file }}
CTL={{ supervisor_control_bin_file }}
PID={{ supervisor_pid_directory }}/{{ supervisor_pid_file_name }}
CONF={{ supervisor_conf_directory }}/{{ supervisor_conf_file_name }}

start()
{
        if [ -f $PID ]; then
            echo -e "\033[33m $PID already exists. \033[0m"
            echo -e "\033[33m $DESC is already running or crashed. \033[0m"
            echo -e "\033[32m $DESC Reloading $CONF ... \033[0m"
            $CTL -c $CONF reload
            sleep 1
            echo -e "\033[36m $DESC reloaded. \033[0m"
        else
            echo -e "\033[32m $DESC Starting $CONF ... \033[0m"
            $DAEMON --configuration $CONF --pidfile $PID
            sleep 1
            echo -e "\033[36m $DESC started. \033[0m"
        fi
}

stop()
{
        if [ ! -f $PID ]; then
            echo -e "\033[33m $PID doesn't exist. \033[0m"
            echo -e "\033[33m $DESC isn't running. \033[0m"
        else
            echo -e "\033[32m $DESC Stopping $CONF ... \033[0m"
            killproc -p $PID -d 10 $DAEMON
            sleep 1
            echo -e "\033[36m $DESC stopped. \033[0m"
        fi
}

reload()
{
        if [ ! -f $PID ]; then
            echo -e "\033[33m $PID doesn't exist. \033[0m"
            echo -e "\033[33m $DESC isn't running. \033[0m"
            echo -e "\033[32m $DESC Starting $CONF ... \033[0m"
            $DAEMON --configuration $CONF --pidfile $PID
            sleep 1
            echo -e "\033[36m $DESC started. \033[0m"
        else
            echo -e "\033[32m $DESC Reloading $CONF ... \033[0m"
            $CTL -c $CONF reload
            sleep 1
            echo -e "\033[36m $DESC reloaded. \033[0m"
        fi
}

case "$1" in
        start)
                start
                ;;
        stop)
                stop
                ;;
        reload)
                reload
                ;;
        restart)
                stop
                start
                ;;
        status)
                status -p $PID $DAEMON
                ;;
        *)
                echo "Usage: $SCRIPT {start|stop|reload|restart|status}"
                exit 2
esac

exit 0
