#!/bin/bash

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="`cat $BotDir/id-list.txt`"

if [ -s "$1" ]; then
	for i in $Chatid
	do
	wget -O - "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=$(cat $2)&parse_mode=Markdown" > /dev/null
	done

else
	a="Oops, No news from $3."
        wget -O - "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=$a&parse_mode=Markdown" > /dev/null
fi

