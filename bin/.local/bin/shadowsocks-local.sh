#!/bin/bash
# Start/stop shadowsocks.
#
### BEGIN INIT INFO
# Provides:          shadowsocks-local
# Required-Start:    $network $local_fs $remote_fs
# Required-Stop:     $remote_fs
# Should-Start:
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: shadowsocks is a lightweight tunneling proxy
### END INIT INFO

# Author: Appleshan <apple.shan@gmail.com>
# @See http://guleilab.com/2016/04/05/VPS/

# variable default setting {{{
NAME=shadowsocks-local

BIN=/usr/bin/ss-local
CONFIG_FILE=~/persist/Dropbox/net/shadowsocks-local/ss-config.json
PID_DIR=/tmp
PID_FILE=$PID_DIR/ss-local.pid
RET_VAL=0
# }}}

[ -x $BIN ] || exit 0

check_running() {
  if [[ -r $PID_FILE ]]; then
    read PID <$PID_FILE
    if [[ -d "/proc/$PID" ]]; then
      return 0
    else
      rm -f $PID_FILE
      return 1
    fi
  else
    return 2
  fi
}

do_status() {
  check_running
  case $? in
    0)
      echo "$NAME running with PID $PID"
      ;;
    1)
      echo "$NAME not running, remove PID file $PID_FILE"
      ;;
    2)
      echo "Could not find PID file $PID_FILE, $NAME does not appear to be running"
      ;;
  esac
  return 0
}

do_start() {
  if [[ ! -d $PID_DIR ]]; then
    mkdir $PID_DIR || echo "failed creating PID directory $PID_DIR"; exit 1
  fi
  if check_running; then
    echo "$NAME already running with PID $PID"
    return 0
  fi
  if [[ ! -r $CONFIG_FILE ]]; then
    echo "config file $CONFIG_FILE not found"
    return 1
  fi
  echo "starting $NAME"
  # sudo will set the group to the primary group of $USER
  $BIN --fast-open --reuse-port -c $CONFIG_FILE > /dev/null 2>&1 &
  PID=$!
  echo $PID > $PID_FILE
  sleep 0.3
  if ! check_running; then
    echo "start failed"
    return 1
  fi
  echo "$NAME running with PID $PID"
  return 0
}

do_stop() {
  if check_running; then
    echo "stopping $NAME with PID $PID"
    kill $PID
    rm -f $PID_FILE
  else
    echo "Could not find PID file $PID_FILE"
  fi
}

do_restart() {
  do_stop
  do_start
}

case "$1" in
  start|stop|restart|status)
    do_$1
    ;;
  *)
    echo "Usage: shadowsocks {start|stop|restart|status}"
    RET_VAL=1
    ;;
esac

exit $RET_VAL

# END OF FILE
