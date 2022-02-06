#!/bin/sh
# FILE check-uptime.sh

# Changelog
## 2019.07.08	created.
## 2022.02.06	refined.

IP="$1"
PORT="$2"
ALIAS="$3"
SELF_PATH=$(dirname $0)
LOG=/tmp/csobot-uptime.log
PROXY="torsocks"
#PROXY="env https_proxy=http://192.168.100.6:8118"

nc -w 5 -z $IP $PORT ; ret=$?

if [ "$ret" -eq 0 ]; then
	echo "$(date) | ${ALIAS} is reachable." | tee $LOG
else
	echo "$(date) | ${ALIAS} is NOT reachable!" | tee $LOG
fi

# Send the log
${PROXY} python2.7 $SELF_PATH/irc-send-oftc.py $LOG

exit
