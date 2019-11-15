#!/bin/bash
# FILE run-ooniprobe.sh
# Changelog
# 2019-06-09 created
# 2019-07-06 add a func to parse the result.
# 2019-11-12 add FnGenNewsSites()

PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:$PATH
LOG_FILE="/tmp/run-ooniprobe.log"
TEST_FILE="$HOME/.ooni/inputs/citizenlab-cn-list"
SELF_PATH=$(dirname $0)
JQ=$(/usr/bin/which jq 2>/dev/null)
OONI=$(/usr/bin/which ooniprobe 2>/dev/null)
#OONI="/usr/local/bin/ooniprobe"
REPO="$HOME/repo/test-lists"
RES_FILE="$HOME/.ooni/inputs/news-sites-zh.list"

[[ -z $JQ ]] && echo "I depend on jq but it is not installed? Quit."
[[ -z $OONI ]] && echo "I depend on ooniprobe but it is not installed? Quit."


FnGenNewsSites()
{
	cat $REPO/lists/cn.csv $REPO/lists/hk.csv $REPO/lists/tw.csv |grep NEWS |awk -F',' '{ print $1 }' |awk -F'/' '{ print $1$2"//"$3 }' |sort |uniq > $RES_FILE 

}

FnParseResult()
{
	TOTAL=$($JQ '.results' $RET_DIR/summary.json |grep anomaly\" |wc -l)
	ANOM=$($JQ '.results' $RET_DIR/summary.json |grep 'anomaly.*true' |wc -l)

	echo "Result: $ANOM of $TOTAL websites are anomaly." |tee -a $LOG_FILE
}


# $1: Test File
# $2: Name of the test
FnRunTest()
{
	ret=0
	DATE=$(date +%Y%m%dT%H%M)

	## Testing global test lists.
	echo "==== $DATE ==== " |tee $LOG_FILE
	cd
	  $OONI  blocking/web_connectivity -t 120 -f $1 > /tmp/ooniprobe-result.log 

	[[ $? -ne 0 ]] && echo "Oops, running OONI probe failed..." |tee -a $LOG_FILE
	#/usr/local/bin/ooniprobe -v blocking/web_connectivity -d 91.239.100.100 -t 120 -f ./.ooni/inputs/data/my-lists_cn.txt
	#/usr/local/bin/ooniprobe -v blocking/web_connectivity -u https://tails.boum.org

	echo "==== Test Result for list: $2 ====" |tee -a $LOG_FILE

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
		
}


FnSendResult()
{
	# Send out the data
	#/usr/bin/torsocks python2 $SELF_PATH/irc-send-oftc.py $LOG_FILE
	python2 $SELF_PATH/irc-send-oftc.py $LOG_FILE

	if [[ $? -eq 0 ]] && [[ $ret -eq 0 ]]; then
		echo "==== The data has been sent. ====" |tee -a $LOG_FILE
	else
		echo "==== The data has NOT been sent. ====" |tee -a $LOG_FILE
		ret=1
	fi

}


## Run them.
FnGenNewsSites
FnRunTest $RES_FILE "Chinese-lang News Agencies"
FnSendResult

#echo -e "\n>>>> Done. <<<<" |tee -a $LOG_FILE
[[ $ret -eq 0 ]] && exit 0 || exit 1
