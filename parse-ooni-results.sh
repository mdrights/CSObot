#!/bin/bash
# AUTHOR  MDrights
# DATE	  2019-11-15

URL="$1"
LAST_DIR=$(ls -t $HOME/.ooni/measurements |head -n1)
RES_FILE="$HOME/.ooni/measurements/$LAST_DIR/measurements.njson"
#RES_FILE="$HOME/.ooni/measurements/20191112T105229Z-ZZ-AS0-web_connectivity-9d43eaa5fb695c86/measurements.njson"
#echo $RES_FILE

echo "Quering $URL ... "
SITE_JSON=$(cat $RES_FILE |jq --arg URL "$URL" 'select(.test_keys.requests[].request.url == $URL)')

#echo $SITE_JSON

if [[ -z $SITE_JSON ]]; then
	echo "Oops, there might be no result for: $URL "
	exit 1
fi

echo "> Is it accessible?"
echo $SITE_JSON |jq '.test_keys.accessible'
echo

echo "> Is it blocked? "
echo $SITE_JSON |jq '.test_keys.blocking'
echo

echo "> Are DNS queries succeeded? "
echo $SITE_JSON |jq '.test_keys.queries[].failure'
echo

echo "> Is DNS consistent with the control?"
echo $SITE_JSON |jq '.test_keys.dns_consistency'
echo

echo "> TCP connects succeeded?"
echo $SITE_JSON |jq '.test_keys.tcp_connect[].status.failure'
echo

echo "> HTTP requests succeeded?"
echo $SITE_JSON |jq '.test_keys.requests[].failure'
echo


exit
