#!/bin/bash

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"

if [ -s "$1" ]; then
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $2`" 1&>/dev/null                                                  # TG fails to render markdown if there's any "_" in links.
else
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=Oops, no news from $3." 1&>/dev/null
fi

