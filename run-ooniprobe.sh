#!/bin/bash
# FILE run-ooniprobe.sh
# Changelog
# 2019-06-09 created
# 2019-07-06 add a func to parse the result.

LOG_FILE="/tmp/run-ooniprobe.log"
SELF_PATH=$(dirname $0)
JQ=$(which jq 2>/dev/null)

[[ -z $JQ ]] && echo "I depend on jq but it is not installed? Quit."

FnParseResult()
{
	TOTAL=$($JQ '.results' $RET_DIR/summary.json |grep anomaly\" |wc -l)
	ANOM=$($JQ '.results' $RET_DIR/summary.json |grep 'anomaly.*true' |wc -l)

	echo "Result: $ANOM of $TOTAL websites are anomaly." |tee -a $LOG_FILE



}



FnTestCN()
{
	ret=0
	DATE=$(date +%Y%m%dT%H%M)

	## Testing global test lists.
	echo "==== $DATE ==== " |tee $LOG_FILE
	cd
	/usr/local/bin/ooniprobe -v blocking/web_connectivity -t 120 -f ./.ooni/inputs/data/citizenlab-test-lists_cn.txt

	#/usr/local/bin/ooniprobe -v blocking/web_connectivity -d 91.239.100.100 -t 120 -f ./.ooni/inputs/data/my-lists_cn.txt
	#/usr/local/bin/ooniprobe -v blocking/web_connectivity -u https://tails.boum.org

	echo "==== Finished testing for CN ====" |tee -a $LOG_FILE

	# Find the latest measurement (result).
	RET_DIR=$(find $HOME/.ooni/measurements/ -maxdepth 1 -type d |sort -r |head -n1)

	if [[ -r $RET_DIR/summary.json ]]; then
		echo $RET_DIR >> $LOG_FILE

		FnParseResult
	else
		echo "==== Oops, summary.json of this test is not found! ====" |tee -a $LOG_FILE
		ret=1
	fi

	cd -
	# Send out the data
	/usr/bin/torsocks python2 $SELF_PATH/irc-send-oftc.py $LOG_FILE

	if [[ $? -eq 0 ]] && [[ $ret -eq 0 ]]; then
		echo "==== The data has been sent. ====" |tee -a $LOG_FILE
	else
		echo "==== The data has NOT been sent. ====" |tee -a $LOG_FILE
		ret=1
	fi
		
}


## Run them.
FnTestCN

echo -e "\n>>>> Done. <<<<" |tee -a $LOG_FILE
[[ $ret -eq 0 ]] && exit 0 || exit 1
