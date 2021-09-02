#!/usr/bin/env bash

# FILE			check-ipfs-gateway.sh
# AUTHOR		MDrights
# Changelog
# 2019-08-31    Created. using Jay Brown's tool.
# 2021-08-31    Revived. using ipfg-ng.

set -euo pipefail

SELF_PATH=$(dirname $0)
LOG_FILE="/tmp/check-ipfs-gateway.log"
RES_FILE="/tmp/ipfs-gateway-result.txt"
#IPFG=$(which ipfg 2>/dev/null)
IPFG="$HOME/repo/csobot/ipfg-ng"
ret=0

# Run the program
echo ">> Check remote gateway for changes." |tee $LOG_FILE
$IPFG -c || true

echo
echo "==== Check the IPFS gateways ====" |tee $RES_FILE
$IPFG -R |tee -a $LOG_FILE || ret=1

grep Online $LOG_FILE |awk '{ print $2 }' >> $RES_FILE
NUM_GW=$(cat $RES_FILE |wc -l)

echo "IPFS gateway: <$NUM_GW> are available from inside of GFW." |tee -a $LOG_FILE

# Send out the data
python2.7 $SELF_PATH/irc-send-oftc.py $RES_FILE

if [[ $? -eq 0 ]] && [[ $ret -eq 0 ]]; then
	echo "==== The data has been sent. ====" |tee -a $LOG_FILE
else
	echo "==== The data has NOT been sent. ====" |tee -a $LOG_FILE
	ret=1
fi


[[ $ret -ne 0 ]] && exit 1 
exit 0
