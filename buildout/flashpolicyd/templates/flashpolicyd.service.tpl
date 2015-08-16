#!/bin/sh
#
# flashpolicyd   This starts and stops the Flash socket policy server
#
# chkconfig: 345 50 50
# description: The Flash socket policy server
#
# processname: flashpolicyd
# config:      {{ flashpolicyd_policy_file }}
# pidfile:     {{ flashpolicyd_pid_file }}


. /etc/rc.d/init.d/functions
. /etc/sysconfig/network

#####################
#BEGIN CONFIG SECTION

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DESC="Flashpolicyd Daemon"
PYTHON_BIN={{ xbuild_install_dir_prefix }}/python-{{ xbuild_python_version }}/bin/python
DEAMON={{ flashpolicyd_script_file }}
POLICY={{ flashpolicyd_policy_file }}
PID={{ flashpolicyd_pid_file }}
LOG={{ flashpolicyd_log_file }}
TIMEOUT={{ flashpolicyd_timeout }}
PORT={{ flashpolicyd_port }}
SCRIPT={{ flashpolicyd_service_file }}

#END CONFIG SECTION
#####################


[ "$NETWORKING" = "no" ] && exit 0
[ -f "$DEAMON" ] || exit 1
[ -f "$POLICY" ] || exit 1

RETVAL=0

start() {
    echo -n "Starting flashpolicyd: "
    $PYTHON_BIN $DEAMON -f "$POLICY" -p "$PORT" -t "$TIMEOUT" 2>>"$LOG" & 
    RETVAL=$?
    echo $! > $PID
    [ "$RETVAL" -eq 0 ] && success $"$base startup" || failure $"$base startup"
    echo
    touch /var/lock/subsys/flashpolicyd
}

stop() {
    echo -n "Stopping flashpolicyd: "
    killproc -p $PID "$DEAMON"
    RETVAL=$?
    echo
    rm -f /var/lock/subsys/flashpolicyd
}

restart() {
    stop
    start
}

condrestart() {
    [ -e /var/lock/subsys/flashpolicyd ] && restart
}
    
case "$1" in
    start)
    start
    ;;
    stop)
    stop
    ;;
    status)
    status -p "$PID" "$DEAMON"
    ;;
    restart|reload)
    restart
    ;;
    condrestart)
    condrestart
    ;;
    *)
    echo "Usage: $SCRIPT {start|stop|status|restart}"
    RETVAL=1
esac

exit $RETVAL
