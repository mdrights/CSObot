#!/bin/bash

BotDir="$HOME/CSObot"
Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="`cat $BotDir/id-list.txt`"

if [ -s "$1" ]; then
	echo "Your message can't be vacant. Exit."
	exit 1
fi
for i in $Chatid
do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=$1&parse_mode=Markdown" 1&>/dev/null
done


