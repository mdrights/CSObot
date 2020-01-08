#!/bin/sh

# FILE monit-alert.sh
# AUTHOR MDrights
# DATE 2020-01-08


SELF_PATH=$(dirname $0)
LOG_FILE=/tmp/csobot-monit-alert.log
MON_LOG=/var/log/monit/monit.log


# Compare the last line of log with the one last time I recorded.
LAST=$(tail -n1 $LOG_FILE)
MSG=$(tail -n1 $MON_LOG)

if [ "$MSG" != "$LAST" ]; then
        echo "New alert found! Send it."
        echo "$MSG" > $LOG_FILE

        # Send the link
        /usr/local/bin/torsocks /usr/local/bin/python $SELF_PATH/irc-send-oftc.py $LOG_FILE
            #[ $? -eq 0 ] && echo "The message has been sent." |tee -a $LOG_FILE
        echo "message is sent."
else
        echo "No new alert found. Sleeping."
fi

exit

