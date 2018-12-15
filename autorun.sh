#!/usr/bin/env bash

function run {
    if ! pgrep $1 ;
    then
        $@&
    fi
}

run xautolock -detectsleep -time 3 -locker "/home/yash/bin/lock.sh" -notify 30 -notifier "/home/yash/bin/lock-notify.sh"
run xss-lock -- "/home/yash/bin/lock.sh"
#run emacs --daemon
run /home/yash/bin/disable-autolock 2>&1 1> /tmp/disable-logs
