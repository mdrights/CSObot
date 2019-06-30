#!/bin/bash
# FILE run-ooniprobe.sh
# Changelog
# 2019-06-09 created

LOG_FILE="/tmp/run-ooniprobe.log"
SELF_PATH=$(dirname $0)

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
		#cat $RET_DIR/summary.json >> $LOG_FILE
		echo $RET_DIR >> $LOG_FILE
	else
		echo "==== Oops, summary.json of this test is not found! ====" |tee -a $LOG_FILE
		ret=1
	fi

	# Send out the data
	python2 $SELF_PATH/irc-client.py

	if [[ $? -eq 0 ]] && [[ $ret -eq 0 ]]; then
		echo "==== The data has been sent. ====" |tee -a $LOG_FILE
	else
		echo "==== The data has NOT been sent. ====" |tee -a $LOG_FILE
		ret=1
	fi
		
}

FnTestG()
{
	ret=0
	DATE=$(date +%Y%m%dT%H%M)

	## Testing global test lists.
	echo "==== $DATE ==== " |tee $LOG_FILE
	cd
	/usr/local/bin/ooniprobe -v blocking/web_connectivity -t 120 -f ./.ooni/inputs/data/citizenlab-test-lists_global.txt

	echo "==== Finished testing for GLOBAL ====" |tee -a $LOG_FILE

	# Find the latest measurement (result).
	RET_DIR=$(find $HOME/.ooni/measurements/ -maxdepth 1 -type d |sort -r |head -n1)

	if [[ -r $RET_DIR/summary.json ]]; then
		#cat $RET_DIR/summary.json >> $LOG_FILE
		echo $RET_DIR >> $LOG_FILE
	else
		echo "==== Oops, summary.json of this test is not found! ====" |tee -a $LOG_FILE
		ret=1
	fi

	# Send out the data
	python2 $SELF_PATH/irc-client.py

	if [[ $? -eq 0 ]] && [[ $ret -eq 0 ]]; then
		echo "==== The data has been sent. ====" |tee -a $LOG_FILE
	else
		echo "==== The data has NOT been sent. ====" |tee -a $LOG_FILE
		ret=1
	fi
}

## Run them.
FnTestCN
#FnTestG

echo -e "\n>>>> Done. <<<<" |tee -a $LOG_FILE
[[ $ret -eq 0 ]] && exit 0 || exit 1
