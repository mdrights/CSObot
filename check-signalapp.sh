#!/usr/bin/env bash

# FILE		check-signalapp.sh
# AUTHOR	MDrights
# Changelog
# 2021.08.30	0.3
# 2020.04.04	0.2
# 2019.07.27	0.1


TMP=/tmp
SELF_PATH=$(dirname $0)
LOG_FILE=$TMP/csobot-signal.log
VER_FILE="$TMP/latest.json"
WEB_URL="https://updates.signal.org/android/latest.json"

# Check the prerequisites.
JQ=$(/usr/bin/which jq 2>/dev/null)
if [[ -z $JQ ]]; then
	echo "Oops, can not find jq tool. Quit." |tee $LOG_FILE
	exit 1
fi

IPFS=$(/usr/bin/which ipfs 2>/dev/null)
if [[ -z $IPFS ]]; then
	IPFS=$HOME/go-ipfs/ipfs
#	echo "Oops, can not find IPFS. Quit." |tee $LOG_FILE
#	exit 1
fi

if ! pgrep tor ; then
	echo "Oops, Tor is not running." |tee $LOG_FILE
fi


# Get current Signal version on the website.
if [[ -r $VER_FILE ]]; then
	CUR_VERSION=$($JQ '.versionName' $VER_FILE)
else
	echo "Latest.json not readable. Can not get current Signal version. Go ahead to download one from its website."
	CUR_VERSION=""
fi
echo "Current Signal version: $CUR_VERSION"


# Download latest.json.
echo "Checking Signal website for new version of Signal." # |tee $LOG_FILE
cd $TMP
curl -O $WEB_URL || echo "Downloading latest.json FAILED." |tee -a $LOG_FILE
cd -

NEW_VERSION=$($JQ '.versionName' $VER_FILE)
echo "Latest Signal version: $NEW_VERSION" |tee  $LOG_FILE


# Send it to IPFS.
FnSendIpfs()
{
# Download the Signal apk.
cd $TMP
APK_URL=$(echo $APK_URL |tr -d '"')
APK_NAME=${APK_URL##*/}
curl -O $APK_URL || echo "Downloading Signal app FAILED." |tee -a $LOG_FILE
cd -

if [[ -r "$TMP/$APK_NAME" ]]; then
	echo "Uploading Signal apk to the IPFS daemon on localhost."
	HASH=$($IPFS add -q -w "$TMP/$APK_NAME" |tail -n1; ret=$?)

	if [[ $ret -eq 0 ]] && [[ -n $HASH ]]; then
		echo "Hash: $HASH" |tee -a $LOG_FILE
	else
		echo "Oops, FAILED to upload." |tee -a $LOG_FILE
	fi

else
	echo "Oops, FAILED to download apk file." |tee -a $LOG_FILE
fi
}

# Compare if there is a new version.
if [[ $CUR_VERSION < $NEW_VERSION ]]; then
	echo "New Signal(Android without GSM) version found!" |tee -a $LOG_FILE
	APK_URL=$($JQ '.url' $VER_FILE)
	APK_SHA=$($JQ '.sha256sum' $VER_FILE)
	echo "Download link: $APK_URL" |tee -a $LOG_FILE
	echo "SHA256SUM: $APK_SHA" |tee -a $LOG_FILE

	#FnSendIpfs
else
	echo "No updates since last check." |tee -a $LOG_FILE
fi

# Send the link
python2.7 $SELF_PATH/irc-send-oftc.py $LOG_FILE

if [[ $? -eq 0 ]] ; then
	echo "The link has been sent." |tee -a $LOG_FILE
else
	echo "The link was not sent. Remove the state file."
	rm -f $VER_FILE
fi


exit


