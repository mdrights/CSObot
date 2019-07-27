#!/bin/bash

# FILE		check-signalapp.sh
# AUTHOR	MDrights
# Changelog
# 2019.07.27	0.1


TMP=/tmp
LOG_FILE=$TMP/csobot-signal.log
VER_FILE="$TMP/latest.json"
WEB_URL="https://updates.signal.org/android/latest.json"

JQ=$(/usr/bin/which jq 2>/dev/null)
if [[ -z $JQ ]]; then
	echo "Oops, can not find jq tool. Quit."
	exit 1
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
echo "Checking Signal website for new version of Signal."
cd $TMP
curl -O $WEB_URL || echo "Downloading latest.json FAILED."
cd -

NEW_VERSION=$($JQ '.versionName' $VER_FILE)
echo "New Signal version: $NEW_VERSION"

# Compare if there is a new version.
if [[ $CUR_VERSION < $NEW_VERSION ]]; then
	echo "New Signal(Android without GSM) version found!"
	APK_URL=$($JQ '.url' $VER_FILE)
	APK_SHA=$($JQ '.sha256sum' $VER_FILE)
	echo "Download link: $APK_URL"
	echo "SHA256SUM: $APK_SHA"
fi

# Download the Signal apk.
exit


