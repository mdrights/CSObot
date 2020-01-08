#!/bin/bash

# FILE mail2irc-daemon.sh
# AUTHOR MDrights
# DATE 2020-01-05


SELF_PATH=$(dirname $0)
MAILBOX=$HOME/Maildir
LOG_FILE=/tmp/csobot-mail2irc.log

while true; do
    NEW_MAIL=$(find ${MAILBOX}/new -type f)
    if [[ -z $NEW_MAIL ]]; then
        echo "No new mail found. Cheers."
        echo "" > $LOG_FILE
        #continue
    else
        for NM in $(echo "$NEW_MAIL"); do
            SUB=$(grep "Subject:" $NM)
            FROM=$(grep "From:" $NM)
            DATE=$(grep "Date:" $NM)
            echo "  ==== $DATE ====
            $FROM
            $SUB
            " >> $LOG_FILE

            mv $NM ${MAILBOX}/cur/
        done
    fi

    # Send the results
    if [[ -n $LOG_FILE ]]; then
        python2 $SELF_PATH/irc-send-oftc.py $LOG_FILE
        if [[ $? -eq 0 ]] ; then
            echo "The mail has been sent." |tee -a $LOG_FILE
            echo "" > $LOG_FILE
        fi
    else
        echo "No new mail, do not send." |tee -a $LOG_FILE
    fi

    sleep 60
done

