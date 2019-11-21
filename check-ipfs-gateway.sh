#!/bin/bash

# FILE check-ipfs-gateway.sh
# Changelog
# 2019-08-31 created. using Jay Brown's tool.

SELF_PATH=$(dirname $0)
LOG_FILE="/tmp/check-ipfs-gateway.log"
RES_FILE="$SELF_PATH/ipfs-gateway-result.log"
#IPFG=$(which ipfg 2>/dev/null)
IPFG="$HOME/repo/JayBrown-Tools/ipfg/ipfg"
ret=0

# Checking...
$IPFG |tee $LOG_FILE || ret=1
grep Online $LOG_FILE |awk '{ print $2 }' > $RES_FILE
NUM_GW=$(cat $RES_FILE |wc -l)

echo "Checking available IPFS gateway from inside of GFW..." |tee  $LOG_FILE
echo "IPFS gateway: <$NUM_GW> are available from inside of GFW." |tee -a $LOG_FILE

# Send out the data
python2 $SELF_PATH/irc-send-oftc.py $LOG_FILE

if [[ $? -eq 0 ]] && [[ $ret -eq 0 ]]; then
	echo "==== The data has been sent. ====" |tee -a $LOG_FILE
else
	echo "==== The data has NOT been sent. ====" |tee -a $LOG_FILE
	ret=1
fi


#echo -e "\n>>>> Done. <<<<" |tee -a $LOG_FILE
[[ $ret -eq 0 ]] && exit 0 || exit 1
