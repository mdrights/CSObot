#!/bin/sh
#PURPOSE	Check my website availability and send the results to IRC/Matrix.
#AUTHOR		MDrights

SELF_PATH=$(dirname $0)
SITE="$1"
PROXY="env https_proxy=http://192.168.100.6:8118"
LOG_FILE="/tmp/check-website.log"

echo "
===================================
>> Today's Results of Site01:"  # |tee -a ${LOG_FILE}

${PROXY} curl -sS -I ${SITE} | head -4 |tee -a ${LOG_FILE}

HOUR=$(date '+%H')

if [ "$HOUR" -eq 10 ]; then
	echo ">> It is time to send the result."
	${PROXY} python2.7 $SELF_PATH/irc-send-oftc.py $LOG_FILE
	# Clear the result log
	[ $? -eq 0 ] && echo > $LOG_FILE
fi
