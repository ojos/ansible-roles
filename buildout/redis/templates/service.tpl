#/bin/sh
#
# chkconfig:   - 85 15
# description:  redis-server
# processname: redis

EXEC={{ redis_server_bin }}
CLIEXEC={{ redis_bin_dir }}/redis-cli
PIDFILE={{ redis_pid_file }}
CONF={{ redis_conf_file }}
REDISPORT={{ redis_port }}

start() {
    if [ -f $PIDFILE ]
    then
            echo "$PIDFILE exists, process is already running or crashed"
    else
            echo "Starting Redis server..."
            $EXEC $CONF
    fi
}

stop() {
    if [ ! -f $PIDFILE ]
    then
            echo "$PIDFILE does not exist, process is not running"
    else
            PID=$(cat $PIDFILE)
            echo "Stopping ..."
            $CLIEXEC -p $REDISPORT shutdown
            while [ -x /proc/${PID} ]
            do
                echo "Waiting for Redis to shutdown ..."
                sleep 1
            done
            echo "Redis stopped"
    fi
}

restart() {
    stop
    start
}

case "$1" in
    start)
        $1
        ;;
    stop)
        $1
        ;;
    restart)
        $1
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac