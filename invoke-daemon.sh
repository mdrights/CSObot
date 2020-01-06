#!/bin/bash

# FILE invoke-daemon.sh
# AUTHOR MDrights
# DATE 2020-01-05

SELF_PATH=$(dirname $0)
PROC=$1

if ! ps aux |grep -v $0 |grep -v grep |grep "$PROC" ; then
        ${SELF_PATH}/$PROC &
        sleep 5
        echo "Started <$PROC>."
else
        echo "Process <$PROC> is already running...?"
        exit 1
fi

exit

