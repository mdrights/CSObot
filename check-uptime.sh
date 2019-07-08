#!/bin/bash
# FILE check-uptime.sh

# Changelog
## 2019.07.08	created.

IP=
PORT=
LOG=/tmp/csobot-uptime.log

nc -z $IP $PORT ; ret=$?

if [[ $ret -eq 0 ]]; then
	echo "Machine $IP:$PORT is reachable. Congrats!" | tee -a $LOG
else
	echo "Machine $IP:$PORT is NOT reachable!" | tee -a $LOG
	exit 1
fi

exit
