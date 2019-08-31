#!/bin/bash

# FILE check-ipfs-gateway.sh
# Changelog
# 2019-06-09 created

LOG_FILE="/tmp/check-ipfs-gateway.log"
RES_FILE="/tmp/ipfs-gateway-result.log"
SELF_PATH=$(dirname $0)
#IPFG=$(which ipfg 2>/dev/null)
IPFG="$HOME/repo/JayBrown-Tools/ipfg/ipfg"
ret=0

echo "Checking available IPFS gateway from inside GFW..." |tee $LOG_FILE
$IPFG |tee -a $LOG_FILE || ret=1

grep Online $LOG_FILE |awk '{ print $2 }' > $RES_FILE
NUM_GW=$(cat $RES_FILE |wc -l)
echo "Done, <$NUM_GW> are available. Run ipfs-gw to see the list." |tee -a $LOG_FILE

# Send out the data
/usr/bin/torsocks python2 $SELF_PATH/irc-send-oftc.py $LOG_FILE

if [[ $? -eq 0 ]] && [[ $ret -eq 0 ]]; then
	echo "==== The data has been sent. ====" |tee -a $LOG_FILE
else
	echo "==== The data has NOT been sent. ====" |tee -a $LOG_FILE
	ret=1
fi


#echo -e "\n>>>> Done. <<<<" |tee -a $LOG_FILE
[[ $ret -eq 0 ]] && exit 0 || exit 1
