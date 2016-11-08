#!/bin/bash

Token=260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o

if [ -s "$1" ]; then
	wget "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=$(cat $2)" 1>&/dev/null
else
        wget "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=Oops, no news from $3." 1>&/dev/null
fi

